#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

#Region Module Constants
; Skill module specific constants
Global Const $SKILL_LOG_SIZE = 0x00000010
Global Const $SKILL_EVENT_ACTIVATE = 1
Global Const $SKILL_EVENT_CANCEL = 2
Global Const $SKILL_EVENT_COMPLETE = 3
#EndRegion Module Constants

#Region Module Global Variables
Global $g_mSkillBase	; Pointer to skill data array
Global $g_mSkillTimer	; Pointer to skill timer

; Skill command structures
Global $g_mUseSkill = DllStructCreate('ptr;dword;dword;dword')
Global $g_mUseSkillPtr = DllStructGetPtr($g_mUseSkill)

Global $g_mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Global $g_mUseHeroSkillPtr = DllStructGetPtr($g_mUseHeroSkill)

; Module state variables
Global $g_bSkillModuleInitialized = False
Global $g_iLastSkillUsed = 0
Global $g_iLastSkillTarget = 0
#EndRegion Module Global Variables

#Region Initialize Functions
; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_Initialize
; Description ...: Initializes the skill management module
; Syntax.........: _SkillMod_Initialize()
; Parameters ....: None
; Return values .: True if initialization succeeds, False otherwise
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Must be called after main initialization
;                  - Sets up all necessary data for the module
; Related .......: _SkillMod_Cleanup
;============================================================================================
Func _SkillMod_Initialize()
    If $g_bSkillModuleInitialized Then
        _Log_Warning("SkillMod module already initialized", "SkillMod", $GUIEdit)
        Return True
    EndIf

    _Log_Info("Initializing SkillMod module...", "SkillMod", $GUIEdit)

    ; Initialize skill data
    _SkillMod_InitializeData()

    ; Initialize commands
    _SkillMod_InitializeCommands()

    $g_bSkillModuleInitialized = True
    _Log_Info("SkillMod module initialized successfully", "SkillMod", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_InitializeData
; Description ...: Initializes skill base data
; Syntax.........: _SkillMod_InitializeData()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_Initialize
;============================================================================================
Func _SkillMod_InitializeData()
	; Read skill base address
	$g_mSkillBase = MemoryRead(GetScannedAddress('ScanSkillBase', 0x8))
	If $g_mSkillBase = 0 Then _Log_Error("Invalid SkillBase address", "SkillMod", $GUIEdit)
	SetValue('SkillBase', Ptr($g_mSkillBase))
	_Log_Debug("SkillBase: " & Ptr($g_mSkillBase), "SkillMod", $GUIEdit)

	; Read skill timer address
	$g_mSkillTimer = MemoryRead(GetScannedAddress('ScanSkillTimer', -0x3))
	If $g_mSkillTimer = 0 Then _Log_Error("Invalid SkillTimer address", "SkillMod", $GUIEdit)
	SetValue('SkillTimer', Ptr($g_mSkillTimer))
	_Log_Debug("SkillTimer: " & Ptr($g_mSkillTimer), "SkillMod", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_InitializeCommands
; Description ...: Initializes command and function addresses
; Syntax.........: _SkillMod_InitializeCommands()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_Initialize
;============================================================================================
Func _SkillMod_InitializeCommands()
	Local $lTemp

	; Setup skill log addresses
	$lTemp = GetScannedAddress('ScanSkillLog', 0x1)
	SetValue('SkillLogStart', Ptr($lTemp))
	SetValue('SkillLogReturn', Ptr($lTemp + 0x5))

	$lTemp = GetScannedAddress('ScanSkillCompleteLog', -0x4)
	SetValue('SkillCompleteLogStart', Ptr($lTemp))
	SetValue('SkillCompleteLogReturn', Ptr($lTemp + 0x5))

	$lTemp = GetScannedAddress('ScanSkillCancelLog', 0x5)
	SetValue('SkillCancelLogStart', Ptr($lTemp))
	SetValue('SkillCancelLogReturn', Ptr($lTemp + 0x6))

	; Setup skill functions
	SetValue('UseSkillFunction', Ptr(GetScannedAddress('ScanUseSkillFunction', -0x125)))
	SetValue('UseHeroSkillFunction', Ptr(GetScannedAddress('ScanUseHeroSkillFunction', -0x59)))

	; Setup constants
	SetValue('SkillLogSize', $SKILL_LOG_SIZE)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_Cleanup
; Description ...: Cleans up module resources
; Syntax.........: _SkillMod_Cleanup()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Should be called when closing the application
; Related .......: _SkillMod_Initialize
;============================================================================================
Func _SkillMod_Cleanup()
    If Not $g_bSkillModuleInitialized Then Return

    _Log_Info("Cleaning up SkillMod module...", "SkillMod", $GUIEdit)

    ; Reset state variables
    $g_iLastSkillUsed = 0
    $g_iLastSkillTarget = 0
    $g_bSkillModuleInitialized = False

    _Log_Info("SkillMod module cleanup completed", "SkillMod", $GUIEdit)
EndFunc
#EndRegion Initialize Functions

#Region Pattern, Structure & Assembly Code Generation
; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_DefinePatterns
; Description ...: Defines scan patterns for skill-related functions
; Syntax.........: _SkillMod_DefinePatterns()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Called during the scan phase of initialization
; Related .......: _SkillMod_CreateCommands
;============================================================================================
Func _SkillMod_DefinePatterns()
    _Log_Debug("Defining skill-related scan patterns...", "SkillMod", $GUIEdit)

    _('ScanSkillBase:')
    AddPattern('8D04B6C1E00505') ; STILL WORKING 23.12.24

    _('ScanSkillTimer:')
    AddPattern('FFD68B4DF08BD88B4708') ; STILL WORKING 23.12.24

    _('ScanUseSkillFunction:')
    AddPattern('85F6745B83FE1174') ; STILL WORKING 23.12.24

    _('ScanUseHeroSkillFunction:')
    AddPattern('BA02000000B954080000') ; STILL WORKING 23.12.24

    _('ScanSkillLog:')
    AddPattern('408946105E5B5D') ; COULD NOT UPDATE! 23.12.24

    _('ScanSkillCompleteLog:')
    AddPattern('741D6A006A40') ; COULD NOT UPDATE! 23.12.24

    _('ScanSkillCancelLog:')
    AddPattern('741D6A006A48') ; COULD NOT UPDATE! 23.12.24

    _Log_Debug("Skill patterns defined successfully", "SkillMod", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_SetupStructures
; Description ...: Configures data structures for commands
; Syntax.........: _SkillMod_SetupStructures()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_Initialize
;============================================================================================
Func _SkillMod_SetupStructures()
    DllStructSetData($g_mUseSkill, 1, GetValue('CommandUseSkill'))
    DllStructSetData($g_mUseHeroSkill, 1, GetValue('CommandUseHeroSkill'))

    _Log_Debug("Skill structures configured successfully", "SkillMod", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_CreateUseSkillCommand
; Description ...: Creates ASM command for using a skill
; Syntax.........: _SkillMod_CreateUseSkillCommand()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_CreateCommands
;============================================================================================
Func _SkillMod_CreateUseSkillCommand()
    _('CommandUseSkill:')
    _('mov ecx,dword[eax+C]')
    _('push ecx')
    _('mov ebx,dword[eax+8]')
    _('push ebx')
    _('mov edx,dword[eax+4]')
    _('dec edx')
    _('push edx')
    _('mov eax,dword[MyID]')
    _('push eax')
    _('call UseSkillFunction')
    _('pop eax')
    _('pop edx')
    _('pop ebx')
    _('pop ecx')
    _('ljmp CommandReturn')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_CreateHeroUseSkillCommand
; Description ...: Creates ASM command for making a hero use a skill
; Syntax.........: _SkillMod_CreateHeroUseSkillCommand()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_CreateCommands
;============================================================================================
Func _SkillMod_CreateHeroUseSkillCommand()
    _('CommandUseHeroSkill:')
    _('mov ecx,dword[eax+8]')
    _('push ecx')
    _('mov ecx,dword[eax+c]')
    _('push ecx')
    _('mov ecx,dword[eax+4]')
    _('push ecx')
    _('call UseHeroSkillFunction')
    _('add esp,C')
    _('ljmp CommandReturn')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_CreateSkillLog
; Description ...: Creates skill activation logging function
; Syntax.........: _SkillMod_CreateSkillLog()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_CreateLogFunctions
;============================================================================================
Func _SkillMod_CreateSkillLog()
    _('SkillLogProc:')
    _('pushad')

    _('mov eax,dword[SkillLogCounter]')
    _('push eax')
    _('shl eax,4')
    _('add eax,SkillLogBase')

    _('mov ecx,dword[edi]')
    _('mov dword[eax],ecx')
    _('mov ecx,dword[ecx*4+TargetLogBase]')
    _('mov dword[eax+4],ecx')
    _('mov ecx,dword[edi+4]')
    _('mov dword[eax+8],ecx')
    _('mov ecx,dword[edi+8]')
    _('mov dword[eax+c],ecx')

    _('push ' & $SKILL_EVENT_ACTIVATE)
    _('push eax')
    _('push CallbackEvent')
    _('push dword[CallbackHandle]')
    _('call dword[PostMessage]')

    _('pop eax')
    _('inc eax')
    _('cmp eax,SkillLogSize')
    _('jnz SkillLogSkipReset')
    _('xor eax,eax')
    _('SkillLogSkipReset:')
    _('mov dword[SkillLogCounter],eax')

    _('popad')
    _('inc eax')
    _('mov dword[esi+10],eax')
    _('pop esi')
    _('ljmp SkillLogReturn')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_CreateSkillCancelLog
; Description ...: Creates skill cancellation logging function
; Syntax.........: _SkillMod_CreateSkillCancelLog()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_CreateLogFunctions
;============================================================================================
Func _SkillMod_CreateSkillCancelLog()
    _('SkillCancelLogProc:')
    _('pushad')

    _('mov eax,dword[SkillLogCounter]')
    _('push eax')
    _('shl eax,4')
    _('add eax,SkillLogBase')

    _('mov ecx,dword[edi]')
    _('mov dword[eax],ecx')
    _('mov ecx,dword[ecx*4+TargetLogBase]')
    _('mov dword[eax+4],ecx')
    _('mov ecx,dword[edi+4]')
    _('mov dword[eax+8],ecx')

    _('push ' & $SKILL_EVENT_CANCEL)
    _('push eax')
    _('push CallbackEvent')
    _('push dword[CallbackHandle]')
    _('call dword[PostMessage]')

    _('pop eax')
    _('inc eax')
    _('cmp eax,SkillLogSize')
    _('jnz SkillCancelLogSkipReset')
    _('xor eax,eax')
    _('SkillCancelLogSkipReset:')
    _('mov dword[SkillLogCounter],eax')

    _('popad')
    _('push 0')
    _('push 48')
    _('mov ecx,esi')
    _('ljmp SkillCancelLogReturn')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_CreateSkillCompleteLog
; Description ...: Creates skill completion logging function
; Syntax.........: _SkillMod_CreateSkillCompleteLog()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _SkillMod_CreateLogFunctions
;============================================================================================
Func _SkillMod_CreateSkillCompleteLog()
    _('SkillCompleteLogProc:')
    _('pushad')

    _('mov eax,dword[SkillLogCounter]')
    _('push eax')
    _('shl eax,4')
    _('add eax,SkillLogBase')

    _('mov ecx,dword[edi]')
    _('mov dword[eax],ecx')
    _('mov ecx,dword[ecx*4+TargetLogBase]')
    _('mov dword[eax+4],ecx')
    _('mov ecx,dword[edi+4]')
    _('mov dword[eax+8],ecx')

    _('push ' & $SKILL_EVENT_COMPLETE)
    _('push eax')
    _('push CallbackEvent')
    _('push dword[CallbackHandle]')
    _('call dword[PostMessage]')

    _('pop eax')
    _('inc eax')
    _('cmp eax,SkillLogSize')
    _('jnz SkillCompleteLogSkipReset')
    _('xor eax,eax')
    _('SkillCompleteLogSkipReset:')
    _('mov dword[SkillLogCounter],eax')

    _('popad')
    _('mov eax,dword[edi+4]')
    _('test eax,eax')
    _('ljmp SkillCompleteLogReturn')
EndFunc
#EndRegion Pattern, Structure & Assembly Code Generation

#Region Internal Functions
; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_CreateCommands
; Description ...: Creates ASM commands for skill operations
; Syntax.........: _SkillMod_CreateCommands()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Called during ASM command creation phase
; Related .......: _SkillMod_DefinePatterns
;============================================================================================
Func _SkillMod_CreateCommands()
    _Log_Debug("Creating skill-related ASM commands...", "SkillMod", $GUIEdit)

    ; Command for using a skill
    _SkillMod_CreateUseSkillCommand()

    ; Command for making a hero use a skill
    _SkillMod_CreateHeroUseSkillCommand()

    _Log_Debug("Skill commands created successfully", "SkillMod", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_CreateSkillLogFunctions
; Description ...: Creates logging functions for skill events
; Syntax.........: _SkillMod_CreateSkillLogFunctions()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Called during ASM log function creation phase
; Related .......: _SkillMod_CreateCommands
;============================================================================================
Func _SkillMod_CreateSkillLogFunctions()
    _Log_Debug("Creating skill logging functions...", "SkillMod", $GUIEdit)

    _SkillMod_CreateSkillLog()
    _SkillMod_CreateSkillCancelLog()
    _SkillMod_CreateSkillCompleteLog()

    _Log_Debug("Skill logging functions created successfully", "SkillMod", $GUIEdit)
EndFunc
#EndRegion Internal Functions