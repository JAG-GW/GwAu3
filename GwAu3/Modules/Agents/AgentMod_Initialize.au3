#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

#Region Module Constants
; Agent module specific constants
Global Const $AGENT_TYPE_LIVING = 0xDB
Global Const $AGENT_TYPE_GADGET = 0x200
Global Const $AGENT_TYPE_ITEM = 0x400

; Agent array constants
Global Const $AGENT_MAX_COPY = 256
Global Const $AGENT_STRUCT_SIZE = 0x1C0
#EndRegion Module Constants

#Region Module Global Variables
; Agent data pointers
Global $g_mAgentBase      ; Pointer to agent array
Global $g_mMaxAgents      ; Maximum number of agents
Global $g_mMyID           ; Player's agent ID
Global $g_mCurrentTarget  ; Current target agent ID
Global $g_mAgentCopyCount ; Count of copied agents
Global $g_mAgentCopyBase  ; Base address of agent copy array

; Agent command structures
Global $g_mChangeTarget = DllStructCreate('ptr;dword')
Global $g_mChangeTargetPtr = DllStructGetPtr($g_mChangeTarget)

Global $g_mMakeAgentArray = DllStructCreate('ptr;dword')
Global $g_mMakeAgentArrayPtr = DllStructGetPtr($g_mMakeAgentArray)

; Module state variables
Global $g_bAgentModuleInitialized = False
Global $g_iLastTargetID = 0
#EndRegion Module Global Variables

#Region Initialize Functions
; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_Initialize
; Description ...: Initializes the agent management module
; Syntax.........: _AgentMod_Initialize()
; Parameters ....: None
; Return values .: True if initialization succeeds, False otherwise
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Must be called after main initialization
;                  - Sets up all necessary data for agent operations
; Related .......: _AgentMod_Cleanup
;============================================================================================
Func _AgentMod_Initialize()
    If $g_bAgentModuleInitialized Then
        _Log_Warning("AgentMod module already initialized", "AgentMod", $GUIEdit)
        Return True
    EndIf

    ; Initialize agent data
    _AgentMod_InitializeData()

    ; Initialize commands
    _AgentMod_InitializeCommands()

    $g_bAgentModuleInitialized = True
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_InitializeData
; Description ...: Initializes agent base data
; Syntax.........: _AgentMod_InitializeData()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Internal module function
; Related .......: _AgentMod_Initialize
;============================================================================================
Func _AgentMod_InitializeData()
   $g_mAgentBase = MemoryRead(GetScannedAddress('ScanAgentArray', -0x3))
   SetValue('AgentBase', Ptr($g_mAgentBase))
   _Log_Debug("AgentBase: " & Ptr($g_mAgentBase), "AgentMod", $GUIEdit)

   $g_mMaxAgents = $g_mAgentBase + 0x8
   SetValue('MaxAgents', Ptr($g_mMaxAgents))
   _Log_Debug("MaxAgents: " & Ptr($g_mMaxAgents), "AgentMod", $GUIEdit)

   $g_mMyID = MemoryRead(GetScannedAddress('ScanMyID', -3))
   SetValue('MyID', Ptr($g_mMyID))
   _Log_Debug("MyID: " & Ptr($g_mMyID), "AgentMod", $GUIEdit)

   $g_mCurrentTarget = MemoryRead(GetScannedAddress('ScanCurrentTarget', -0xE))
   _Log_Debug("CurrentTarget: " & Ptr($g_mCurrentTarget), "AgentMod", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_InitializeCommands
; Description ...: Initializes command and function addresses
; Syntax.........: _AgentMod_InitializeCommands()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Internal module function
; Related .......: _AgentMod_Initialize
;============================================================================================
Func _AgentMod_InitializeCommands()
    SetValue('ChangeTargetFunction', Ptr(GetScannedAddress('ScanChangeTargetFunction', -0x0086) + 1))
	_Log_Debug("ChangeTargetFunction: " & GetValue('ChangeTargetFunction'), "AgentMod", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_Cleanup
; Description ...: Cleans up module resources
; Syntax.........: _AgentMod_Cleanup()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Should be called when closing the application
; Related .......: _AgentMod_Initialize
;============================================================================================
Func _AgentMod_Cleanup()
    If Not $g_bAgentModuleInitialized Then Return

    ; Reset state variables
    $g_iLastTargetID = 0
    $g_bAgentModuleInitialized = False
EndFunc
#EndRegion Initialize Functions

#Region Pattern, Structure & Assembly Code Generation
; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_DefinePatterns
; Description ...: Defines scan patterns for agent-related functions
; Syntax.........: _AgentMod_DefinePatterns()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Called during the scan phase of initialization
;                  - Note: Most agent patterns are defined in main scan
; Related .......: _AgentMod_CreateCommands
;============================================================================================
Func _AgentMod_DefinePatterns()
	_('ScanAgentBase:')
	AddPattern('FF501083C6043BF775E2')

	_('ScanAgentArray:')
	AddPattern('8B0C9085C97419')

	_('ScanChangeTargetFunction:')
	AddPattern('3BDF0F95')

	_('ScanCurrentTarget:')
	AddPattern('83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55')

	_('ScanMyID:')
	AddPattern('83EC08568BF13B15')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_SetupStructures
; Description ...: Configures data structures for commands
; Syntax.........: _AgentMod_SetupStructures()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Called after command creation to setup structure pointers
; Related .......: _AgentMod_Initialize
;============================================================================================
Func _AgentMod_SetupStructures()
	$g_mAgentCopyCount = GetValue('AgentCopyCount')
	$g_mAgentCopyBase = GetValue('AgentCopyBase')

    DllStructSetData($g_mChangeTarget, 1, GetValue('CommandChangeTarget'))
    DllStructSetData($g_mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_CreateCommands
; Description ...: Creates ASM commands for agent operations
; Syntax.........: _AgentMod_CreateCommands()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Note: Agent commands are created in main CreateCommands()
;                  - This function is kept for module consistency
; Related .......: _AgentMod_DefinePatterns
;============================================================================================
Func _AgentMod_CreateCommands()
	_("CommandChangeTarget:")
	_("xor edx,edx")
	_("push edx")
	_("mov eax,dword[eax+4]")
	_("push eax")
	_("call ChangeTargetFunction")
;~ 	_("pop eax")
;~ 	_("pop edx")
	_('add esp,8')
	_("ljmp CommandReturn")

	_('CommandMakeAgentArray:')
	_('mov eax,dword[eax+4]')
	_('xor ebx,ebx')
	_('xor edx,edx')
	_('mov edi,AgentCopyBase')
	_('AgentCopyLoopStart:')
	_('inc ebx')
	_('cmp ebx,dword[MaxAgents]')
	_('jge AgentCopyLoopExit')
	_('mov esi,dword[AgentBase]')
	_('lea esi,dword[esi+ebx*4]')
	_('mov esi,dword[esi]')
	_('test esi,esi')
	_('jz AgentCopyLoopStart')
	_('cmp eax,0')
	_('jz CopyAgent')
	_('cmp eax,dword[esi+9C]')
	_('jnz AgentCopyLoopStart')
	_('CopyAgent:')
	_('mov ecx,1C0')
	_('clc')
	_('repe movsb')
	_('inc edx')
	_('jmp AgentCopyLoopStart')
	_('AgentCopyLoopExit:')
	_('mov dword[AgentCopyCount],edx')
	_('ljmp CommandReturn')
EndFunc
#EndRegion Pattern, Structure & Assembly Code Generation