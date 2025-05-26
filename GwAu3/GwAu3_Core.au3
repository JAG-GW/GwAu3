#include-once
#include "Core/GwAu3_Constants_Core.au3"
#include "Core/GwAu3_Memory.au3"
#include "Core/GwAu3_Assembler.au3"
#include "Core/GwAu3_Callback.au3"
#include "Core/GwAu3_Commands.au3"
#include "Core/GwAu3_Utils.au3"
#include "Core/GwAu3_LogMessages.au3"
#include "Core/GwAu3_FindAssertion.au3"
#include "Modules/Skills/SkillMod_Initialize.au3"
#include "Modules/Skills/SkillMod_Data.au3"
#include "Modules/Skills/SkillMod_Commands.au3"
#include "Modules/Attributes/AttributeMod_Initialize.au3"
#include "Modules/Attributes/AttributeMod_Data.au3"
#include "Modules/Attributes/AttributeMod_Commands.au3"
#include "Modules/Trades/TradeMod_Initialize.au3"
#include "Modules/Trades/TradeMod_Data.au3"
#include "Modules/Trades/TradeMod_Commands.au3"

If @AutoItX64 Then
    MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
    Exit
EndIf

#Region CommandStructs
Global $mInviteGuild = DllStructCreate('ptr;dword;dword header;dword counter;wchar name[32];dword type')
Global $mInviteGuildPtr = DllStructGetPtr($mInviteGuild)

Global $mMove = DllStructCreate('ptr;float;float;float')
Global $mMovePtr = DllStructGetPtr($mMove)

Global $mChangeTarget = DllStructCreate('ptr;dword')
Global $mChangeTargetPtr = DllStructGetPtr($mChangeTarget)

Global $mWriteChat = DllStructCreate('ptr')
Global $mWriteChatPtr = DllStructGetPtr($mWriteChat)

Global $mToggleLanguage = DllStructCreate('ptr;dword')
Global $mToggleLanguagePtr = DllStructGetPtr($mToggleLanguage)

Global $mSendChat = DllStructCreate('ptr;dword')
Global $mSendChatPtr = DllStructGetPtr($mSendChat)

Global $mMakeAgentArray = DllStructCreate('ptr;dword')
Global $mMakeAgentArrayPtr = DllStructGetPtr($mMakeAgentArray)

Global $mChangeStatus = DllStructCreate('ptr;dword')
Global $mChangeStatusPtr = DllStructGetPtr($mChangeStatus)

Global $MTradeHackAddress
Global $mPreGameContextAddr
Global $mFrameArray
#EndRegion CommandStructs

#Region Initialisation
; #FUNCTION# ;===============================================================================
; Name...........: GetHwnd
; Description ...: Returns a window handle from a process ID
; Syntax.........: GetHwnd($aProc)
; Parameters ....: $aProc - Process ID to find window handle for
; Return values .: Window handle as integer, 0 if not found
; Author ........:
; Modified.......:
; Remarks .......: - Internal helper function
;                  - Finds the main window for a specified process ID
;                  - Checks if window is visible before returning
; Related .......: Initialize
;============================================================================================
Func GetHwnd($aProc)
	Local $wins = WinList()
	For $i = 1 To UBound($wins) - 1
		If (WinGetProcess($wins[$i][1]) == $aProc) And (BitAND(WinGetState($wins[$i][1]), 2)) Then Return $wins[$i][1]
	Next
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: GetWindowHandle
; Description ...: Returns the window handle of the Guild Wars client
; Syntax.........: GetWindowHandle()
; Parameters ....: None
; Return values .: Window handle as integer
; Author ........:
; Modified.......:
; Remarks .......: - Must be called after Initialize()
;                  - Used for window manipulation functions
; Related .......: Initialize
;============================================================================================
Func GetWindowHandle()
	Return $mGWWindowHandle
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: GetLoggedCharNames
; Description ...: Returns a list of logged-in character names
; Syntax.........: GetLoggedCharNames()
; Parameters ....: None
; Return values .: Pipe-delimited string of character names
; Author ........:
; Modified.......:
; Remarks .......: - Can be called before Initialize() to find character names
;                  - Returns empty string if no characters are logged in
;                  - Format: "CharName1|CharName2|CharName3"
; Related .......: ScanGW, ScanForCharname
;============================================================================================
Func GetLoggedCharNames()
	Local $array = ScanGW()
	If $array[0] == 0 Then Return '' ; No characters logged
	Local $ret = $array[1] ; Start with the first character name
	For $i = 2 To $array[0] ; Concatenate remaining names, if any
		$ret &= "|" & $array[$i]
	Next
	Return $ret
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: ScanGW
; Description ...: Scans for all running Guild Wars processes
; Syntax.........: ScanGW()
; Parameters ....: None
; Return values .: Array with character names, [0] contains count
; Author ........:
; Modified.......:
; Remarks .......: - Internal function used by GetLoggedCharNames
;                  - Searches all running processes for Guild Wars clients
;                  - Returns an array where [0] is the count and [1..n] are character names
; Related .......: GetLoggedCharNames, ScanForCharname
;============================================================================================
Func ScanGW()
	Local $lProcessList = ProcessList("gw.exe")
	Local $lReturnArray[1] = [0]
	Local $lPid

	For $i = 1 To $lProcessList[0][0]
		MemoryOpen($lProcessList[$i][1])

		If $mGWProcHandle Then
			$lReturnArray[0] += 1
			ReDim $lReturnArray[$lReturnArray[0] + 1]
			$lReturnArray[$lReturnArray[0]] = ScanForCharname()
		EndIf

		MemoryClose()

		$mGWProcHandle = 0
	Next

	Return $lReturnArray
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: Initialize
; Description ...: Initializes the GwAu3 library and injects code into Guild Wars
; Syntax.........: Initialize($aGW, $bChangeTitle = True, $aUseStringLog = False, $aUseEventSystem = True)
; Parameters ....: $aGW           - Character name or process ID of Guild Wars client
;                  $bChangeTitle  - [optional] Whether to change window title with character name (default: True)
;                  $aUseStringLog - [optional] Whether to enable string logging (default: False)
;                  $aUseEventSystem - [optional] Whether to enable event system (default: True)
; Return values .: Window handle of the Guild Wars client
; Author ........:
; Modified.......:
; Remarks .......: - Must be called before any other GwAu3 functions
;                  - Searches for Guild Wars process by character name or uses provided PID
;                  - Injects code into the game client to enable API functionality
;                  - Sets up memory locations and command structures
;                  - Creates callback system if event system is enabled
; Related .......: GetWindowHandle, GetLoggedCharNames
;============================================================================================
Func Initialize($aGW, $bChangeTitle = True, $aUseStringLog = False, $aUseEventSystem = True)
   ; Initialize variables
   $mUseStringLog = $aUseStringLog
   $mUseEventSystem = $aUseEventSystem

   ; Check if $aGW is a string or a process ID
   If IsString($aGW) Then
      ; Find the process ID of the game client
      Local $lProcessList = ProcessList("gw.exe")
      For $i = 1 To $lProcessList[0][0]
        $mGWProcessId = $lProcessList[$i][1]
        $mGWWindowHandle = GetHwnd($mGWProcessId)
        MemoryOpen($mGWProcessId)
        If $mGWProcHandle Then
           ; Check if the character name matches
           If StringRegExp(ScanForCharname(), $aGW) = 1 Then
              ExitLoop
           EndIf
        EndIf
        MemoryClose()
        $mGWProcHandle = 0
      Next
   Else
      ; Use the provided process ID
      $mGWProcessId = $aGW
      $mGWWindowHandle = GetHwnd($mGWProcessId)
      MemoryOpen($aGW)
      ScanForCharname()
   EndIf

   Scan()

   ; Read Memory Values for Game Data
   $mBasePointer = MemoryRead(GetScannedAddress('ScanBasePointer', 0x8))
   SetValue('BasePointer', Ptr($mBasePointer))
   _Log_Debug("BasePointer: " & Ptr($mBasePointer), "Initialize", $GUIEdit)

   $mAgentBase = MemoryRead(GetScannedAddress('ScanAgentArray', -0x3))
   SetValue('AgentBase', Ptr($mAgentBase))
   _Log_Debug("AgentBase: " & Ptr($mAgentBase), "Initialize", $GUIEdit)

   $mMaxAgents = $mAgentBase + 0x8
   SetValue('MaxAgents', Ptr($mMaxAgents))
   _Log_Debug("MaxAgents: " & Ptr($mMaxAgents), "Initialize", $GUIEdit)

   $mMyID = MemoryRead(GetScannedAddress('ScanMyID', -3))
   SetValue('MyID', Ptr($mMyID))
   _Log_Debug("MyID: " & Ptr($mMyID), "Initialize", $GUIEdit)

   $mCurrentTarget = MemoryRead(GetScannedAddress('ScanCurrentTarget', -0xE))
   _Log_Debug("CurrentTarget: " & Ptr($mCurrentTarget), "Initialize", $GUIEdit)

   $mPacketLocation = Ptr(MemoryRead(GetScannedAddress('ScanBaseOffset', 0xB)))
   SetValue('PacketLocation', $mPacketLocation)
   _Log_Debug("PacketLocation: " & $mPacketLocation, "Initialize", $GUIEdit)

   $mPing = MemoryRead(GetScannedAddress('ScanPing', -0x14))
   _Log_Debug("Ping: " & Ptr($mPing), "Initialize", $GUIEdit)

   $mLoggedIn = MemoryRead(GetScannedAddress('ScanLoggedIn', 0x3))
   _Log_Debug("LoggedIn: " & Ptr($mLoggedIn), "Initialize", $GUIEdit)

   $mRegion = MemoryRead(GetScannedAddress('ScanRegion', -0x3))
   _Log_Debug("Region: " & Ptr($mRegion), "Initialize", $GUIEdit)

   $mZoomStill = GetScannedAddress("ScanZoomStill", 0x33)
   _Log_Debug("ZoomStill: " & Ptr($mZoomStill), "Initialize", $GUIEdit)

   $mZoomMoving = GetScannedAddress("ScanZoomMoving", 0x21)
	_Log_Debug("ZoomMoving: " & Ptr($mZoomMoving), "Initialize", $GUIEdit)

   $mCurrentStatus = MemoryRead(GetScannedAddress('ScanChangeStatusFunction', 0x23))
   _Log_Debug("CurrentStatus: " & Ptr($mCurrentStatus), "Initialize", $GUIEdit)

   $mCharslots = MemoryRead(GetScannedAddress('ScanCharslots', 0x16))
   _Log_Debug("Charslots: " & Ptr($mCharslots), "Initialize", $GUIEdit)

   $mInstanceInfo = MemoryRead(GetScannedAddress('ScanInstanceInfo', 0xE))
   _Log_Debug("InstanceInfo: " & Ptr($mInstanceInfo), "Initialize", $GUIEdit)

   $mAreaInfo = MemoryRead(GetScannedAddress('ScanAreaInfo', 0x6))
   _Log_Debug("AreaInfo: " & Ptr($mAreaInfo), "Initialize", $GUIEdit)

   $mWorldConst = MemoryRead(GetScannedAddress('ScanWorldConst', 0x8))
   _Log_Debug("WorldConst: " & Ptr($mWorldConst), "Initialize", $GUIEdit)

	$mPreGameContextAddr = MemoryRead(GetScannedAddress('ScanPreGameContextAddr', 0x35))
	_Log_Debug("PreGameContextAddr: " & Ptr($mPreGameContextAddr), "Initialize", $GUIEdit)

   	$mFrameArray = MemoryRead(GetScannedAddress('ScanFrameArray', -0x13))
	_Log_Debug("FrameArray: " & Ptr($mFrameArray), "Initialize", $GUIEdit)

   _SkillMod_Initialize()
   _AttributeMod_Initialize()
   _TradeMod_Initialize()

   $lTemp = GetScannedAddress('ScanEngine', -0x22)
   SetValue('MainStart', Ptr($lTemp))
   SetValue('MainReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanRenderFunc', -0x67)
   	SetValue('RenderingMod', Ptr($lTemp))
	SetValue('RenderingModReturn', Ptr($lTemp + 0xA))

   $lTemp = GetScannedAddress('ScanTargetLog', 0x1)
   SetValue('TargetLogStart', Ptr($lTemp))
   SetValue('TargetLogReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanChatLog', 0x12)
   SetValue('ChatLogStart', Ptr($lTemp))
   SetValue('ChatLogReturn', Ptr($lTemp + 0x6))

   $lTemp = GetScannedAddress('ScanTraderHook', -0x2F)
   SetValue('TraderHookStart', Ptr($lTemp))
   SetValue('TraderHookReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanDialogLog', -0x4)
   SetValue('DialogLogStart', Ptr($lTemp))
   SetValue('DialogLogReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanStringFilter1', -0x5)
   SetValue('StringFilter1Start', Ptr($lTemp))
   SetValue('StringFilter1Return', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanStringFilter2', 0x16)
   SetValue('StringFilter2Start', Ptr($lTemp))
   SetValue('StringFilter2Return', Ptr($lTemp + 0x5))

   SetValue('StringLogStart', Ptr(GetScannedAddress('ScanStringLog', 0x16)))

   SetValue('LoadFinishedStart', Ptr(GetScannedAddress('ScanLoadFinished', 0x1)))
   SetValue('LoadFinishedReturn', Ptr(GetScannedAddress('ScanLoadFinished', 0x6)))

   SetValue('PostMessage', Ptr(MemoryRead(GetScannedAddress('ScanPostMessage', 0xB))))
   SetValue('Sleep', MemoryRead(MemoryRead(GetValue('ScanSleep') + 0x8) + 0x3))

   SetValue('MoveFunction', Ptr(GetScannedAddress('ScanMoveFunction', 0x1)))

  ;SetValue('ChangeTargetFunction', Ptr(GetScannedAddress('ScanChangeTargetFunction', -0x0089) + 1, 8))
   SetValue('ChangeTargetFunction', Ptr(GetScannedAddress('ScanChangeTargetFunction', -0x0086) + 1))
   SetValue('WriteChatFunction', Ptr(GetScannedAddress('ScanWriteChatFunction', -0x3D)))

   SetValue('PacketSendFunction', Ptr(GetScannedAddress('ScanPacketSendFunction', -0x50)))

   SetValue('ActionBase', Ptr(MemoryRead(GetScannedAddress('ScanActionBase', -0x3))))
   SetValue('ActionFunction', Ptr(GetScannedAddress('ScanActionFunction', -0x3)))

   SetValue('ClickToMoveFix', Ptr(GetScannedAddress("ScanClickToMoveFix", 0x1)))

   SetValue('ChangeStatusFunction', Ptr(GetScannedAddress("ScanChangeStatusFunction", 0x1)))

   SetValue('QueueSize', '0x00000010')
   SetValue('ChatLogSize', '0x00000010')
   SetValue('TargetLogSize', '0x00000200')
   SetValue('StringLogSize', '0x00000200')
   SetValue('CallbackEvent', '0x00000501')
   $MTradeHackAddress = GetScannedAddress("ScanTradeHack", 0)

   ModifyMemory()

   $mQueueCounter = MemoryRead(GetValue('QueueCounter'))
   $mQueueSize = GetValue('QueueSize') - 1
   $mQueueBase = GetValue('QueueBase')
   $mTargetLogBase = GetValue('TargetLogBase')
   $mStringLogBase = GetValue('StringLogBase')
   $mMapIsLoaded = GetValue('MapIsLoaded')
   $mEnsureEnglish = GetValue('EnsureEnglish')
   $mTraderQuoteID = GetValue('TraderQuoteID')
   $mTraderCostID = GetValue('TraderCostID')
   $mTraderCostValue = GetValue('TraderCostValue')
   $mDisableRendering = GetValue('DisableRendering')
   $mAgentCopyCount = GetValue('AgentCopyCount')
   $mAgentCopyBase = GetValue('AgentCopyBase')
   $mLastDialogID = GetValue('LastDialogID')

	If $mUseEventSystem Then
		$mGUI = GUICreate('GwAu3')
		RegisterCallbackHandler()
		MemoryWrite(GetValue('CallbackHandle'), $mGUI)
	EndIf

   DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mInviteGuild, 2, 0x4C)
   DllStructSetData($mMove, 1, GetValue('CommandMove'))
   DllStructSetData($mChangeTarget, 1, GetValue('CommandChangeTarget'))
   DllStructSetData($mPacket, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mAction, 1, GetValue('CommandAction'))
   DllStructSetData($mToggleLanguage, 1, GetValue('CommandToggleLanguage'))
   DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
   DllStructSetData($mSendChat, 2, 0x0063) ; putting raw value, because $HEADER_SEND_CHAT_MESSAGE is used before declaration
   DllStructSetData($mWriteChat, 1, GetValue('CommandWriteChat'))
   DllStructSetData($mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
   DllStructSetData($mChangeStatus, 1, GetValue('CommandChangeStatus'))
   _SkillMod_SetupStructures()
   _AttributeMod_SetupStructures()
   _TradeMod_SetupStructures()

   If $bChangeTitle Then
      WinSetTitle($mGWWindowHandle, '', 'Guild Wars - ' & GetCharname())
   EndIf
   SetMaxMemory()

   Return $mGWWindowHandle
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: Scan
; Description ...: Scans memory for Guild Wars functions and data
; Syntax.........: Scan()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Core scanning function that finds all needed memory addresses
;                  - Sets up patterns for all game functions and data structures
;                  - Creates and injects scanning code into the game
;                  - This is the heart of the memory scanning system
; Related .......: Initialize, AddPattern, GetScannedAddress
;============================================================================================
Func Scan()
	Local $lGwBase = ScanForProcess()
	$mASMSize = 0
	$mASMCodeOffset = 0
	$mASMString = ''

	_('MainModPtr/4')

	; Regular patterns
	_('ScanBasePointer:')
	AddPattern('506A0F6A00FF35')

	_('ScanAgentBase:')
	AddPattern('FF501083C6043BF775E2')

	_('ScanAgentArray:')
	AddPattern('8B0C9085C97419')

	_('ScanCurrentTarget:')
	AddPattern('83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55')

	_('ScanMyID:')
	AddPattern('83EC08568BF13B15')

	_('ScanEngine:')
	AddPattern('568B3085F67478EB038D4900D9460C')

	_('ScanRenderFunc:')
	AddPattern('F6C401741C68B1010000BA')

	_('ScanLoadFinished:')
	AddPattern('8B561C8BCF52E8')

	_('ScanPostMessage:')
	AddPattern('6A00680080000051FF15')

	_('ScanTargetLog:')
	AddPattern('5356578BFA894DF4E8')

	_('ScanChangeTargetFunction:')
	AddPattern('3BDF0F95')

	_('ScanMoveFunction:')
	AddPattern('558BEC83EC208D45F0')

	_('ScanPing:')
	AddPattern('E874651600')

	_('ScanLoggedIn:')
	AddPattern('C705ACDE740000000000C3CCCCCCCC')

	_('ScanRegion:')
	AddPattern('6A548D46248908')

	_('ScanPacketSendFunction:')
	AddPattern('C747540000000081E6')

	_('ScanBaseOffset:')
	AddPattern('83C40433C08BE55DC3A1')

	_('ScanWriteChatFunction:')
	AddPattern('8D85E0FEFFFF50681C01')

	_('ScanChatLog:')
	AddPattern('8B45F48B138B4DEC50')

	_('ScanStringLog:')
	AddPattern('893E8B7D10895E04397E08')

	_('ScanStringFilter1:')
	AddPattern('8B368B4F2C6A006A008B06')

	_('ScanStringFilter2:')
	AddPattern('515356578BF933D28B4F2C')

	_('ScanActionFunction:')
	AddPattern('8B7508578BF983FE09750C6876')

	_('ScanActionBase:')
	AddPattern('8D1C87899DF4')

	_('ScanBuyItemFunction:')
	AddPattern('D9EED9580CC74004')

	_('ScanTraderHook:')
	AddPattern('50516A466A06')

	_('ScanSleep:')
	AddPattern('6A0057FF15D8408A006860EA0000')

	_('ScanClickToMoveFix:')
	AddPattern('3DD301000074')

	_('ScanZoomStill:')
	AddPattern('558BEC8B41085685C0')

	_('ScanZoomMoving:')
	AddPattern('EB358B4304')

	_('ScanChangeStatusFunction:')
	AddPattern('558BEC568B750883FE047C14')

	_('ScanCharslots:')
	AddPattern('8B551041897E38897E3C897E34897E48897E4C890D')

	_('ScanReadChatFunction:')
	AddPattern('A128B6EB00')

	_('ScanDialogLog:')
	AddPattern('8B45088945FC8D45F8506A08C745F841')

	_("ScanTradeHack:")
	AddPattern("8BEC8B450883F846")

	_("ScanClickCoords:")
	AddPattern("8B451C85C0741CD945F8")

	_("ScanInstanceInfo:")
	AddPattern("6A2C50E80000000083C408C7")

	_("ScanAreaInfo:")
	AddPattern("6BC67C5E05")

	_("ScanWorldConst:")
	AddPattern("8D0476C1E00405")

	_SkillMod_DefinePatterns()
	_AttributeMod_DefinePatterns()
	_TradeMod_DefinePatterns()

	; Add assertion patterns using the optimized system
	_Log_Debug("Adding assertion patterns...", "Scan", $GUIEdit)

	_('ScanPreGameContextAddr:')
	AddPattern(GetAssertionPattern("P:\Code\Gw\Ui\UiPregame.cpp", "!s_scene"))

	_('ScanFrameArray:')
	AddPattern(GetAssertionPattern("P:\Code\Engine\Frame\FrMsg.cpp", "frame"))

	; Original ScanProc (unchanged)
	_('ScanProc:')
	_('pushad')
	_('mov ecx,' & Hex($lGwBase, 8))
	_('mov esi,ScanProc')
	_('ScanLoop:')
	_('inc ecx')
	_('mov al,byte[ecx]')
	_('mov edx,ScanBasePointer')

	_('ScanInnerLoop:')
	_('mov ebx,dword[edx]')
	_('cmp ebx,-1')
	_('jnz ScanContinue')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')
	_('jmp ScanExit')

	_('ScanContinue:')
	_('lea edi,dword[edx+ebx]')
	_('add edi,C')
	_('mov ah,byte[edi]')
	_('cmp al,ah')
	_('jz ScanMatched')
	_('cmp ah,00')
	_('jz ScanMatched')
	_('mov dword[edx],0')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')
	_('jmp ScanExit')

	_('ScanMatched:')
	_('inc ebx')
	_('mov edi,dword[edx+4]')
	_('cmp ebx,edi')
	_('jz ScanFound')
	_('mov dword[edx],ebx')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')
	_('jmp ScanExit')

	_('ScanFound:')
	_('lea edi,dword[edx+8]')
	_('mov dword[edi],ecx')
	_('mov dword[edx],-1')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')

	_('ScanExit:')
	_('popad')
	_('retn')

	; Continue with the rest
	$mBase = $lGwBase + 0x9DF000
	Local $lScanMemory = MemoryRead($mBase, 'ptr')

	If $lScanMemory = 0 Then
		$mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 0x40)
		$mMemory = $mMemory[0]
		MemoryWrite($mBase, $mMemory)
	Else
		$mMemory = $lScanMemory
	EndIf

	CompleteASMCode()

	If $lScanMemory = 0 Then
		WriteBinary($mASMString, $mMemory + $mASMCodeOffset)

		Local $lThread = DllCall($mKernelHandle, 'int', 'CreateRemoteThread', 'int', $mGWProcHandle, 'ptr', 0, 'int', 0, 'int', GetLabelInfo('ScanProc'), 'ptr', 0, 'int', 0, 'int', 0)
		$lThread = $lThread[0]

		Local $lResult
		Do
			$lResult = DllCall($mKernelHandle, 'int', 'WaitForSingleObject', 'int', $lThread, 'int', 50)
		Until $lResult[0] <> 258

		DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $lThread)
	EndIf

EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: ScanForProcess
; Description ...: Finds the memory address of the Guild Wars process
; Syntax.........: ScanForProcess()
; Parameters ....: None
; Return values .: Base memory address of Guild Wars process
; Author ........:
; Modified.......:
; Remarks .......: - Internal function used during initialization
;                  - Scans memory for Guild Wars signature patterns
;                  - Returns the memory base address of the process
; Related .......: Initialize, Scan
;============================================================================================
Func ScanForProcess()
	Local $lCharNameCode = BinaryToString('0x558BEC83EC105356578B7D0833F63BFE')
	Local $lCurrentSearchAddress = 0x00000000
	Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

	While $lCurrentSearchAddress < 0x01F00000
		Local $lMBI[7]
		DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
		For $i = 0 To 6
			$lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
		Next
		If $lMBI[4] = 4096 Then
			Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

			$lTmpMemData = DllStructGetData($lBuffer, 1)
			$lTmpMemData = BinaryToString($lTmpMemData)

			$lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
			If $lSearch > 0 Then
				Return $lMBI[0]
			EndIf
		EndIf
		$lCurrentSearchAddress += $lMBI[3]
	WEnd
	Return ''
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: ScanForCharname
; Description ...: Scans Guild Wars memory for character name
; Syntax.........: ScanForCharname()
; Parameters ....: None
; Return values .: Character name as string
; Author ........:
; Modified.......:
; Remarks .......: - Internal function used during initialization
;                  - Searches memory for character name pattern
;                  - Sets $mCharname variable and returns the name
; Related .......: Initialize, GetCharname
;============================================================================================
Func ScanForCharname()
	Local $lCharNameCode = BinaryToString('0x6A14FF751868') ;0x90909066C705
	Local $lCurrentSearchAddress = 0x00000000 ;0x00401000
	Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

	While $lCurrentSearchAddress < 0x01F00000
		Local $lMBI[7]
		DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
		For $i = 0 To 6
			$lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
		Next
		If $lMBI[4] = 4096 Then
			Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

			$lTmpMemData = DllStructGetData($lBuffer, 1)
			$lTmpMemData = BinaryToString($lTmpMemData)

			$lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
			If $lSearch > 0 Then
				$lTmpAddress = $lCurrentSearchAddress + $lSearch - 1
				DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lTmpAddress + 6, 'ptr', DllStructGetPtr($lTmpBuffer), 'int', DllStructGetSize($lTmpBuffer), 'int', '')
				$mCharname = DllStructGetData($lTmpBuffer, 1)
				Return GetCharname()
			EndIf
		EndIf
		$lCurrentSearchAddress += $lMBI[3]
	WEnd
	Return ''
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: GetGWBase
; Description ...: Gets the base address of Guild Wars process
; Syntax.........: GetGWBase()
; Parameters ....: None
; Return values .: Base address as pointer
; Author ........:
; Modified.......:
; Remarks .......: - Returns the memory base address of Guild Wars
;                  - Adjusts raw address by subtracting 4096
;                  - Formats as pointer
; Related .......: ScanForProcess
;============================================================================================
Func GetGWBase()
	; **Scan for Guild Wars Process and Get Base Address**
	Local $lGwBase = ScanForProcess() - 4096 ; Subtract 4096 from the process address to get the base address

	; **Convert Base Address to Hexadecimal String**
	$lGwBase = Ptr($lGwBase) ; Prefix the hexadecimal value with "0x"

	; **Return Base Address as Hexadecimal String**
	Return $lGwBase
EndFunc

#EndRegion Initialisation

Func AddAssertionPattern($aFile, $aMsg, $aOffset)
	; First, we need to find the strings in .rdata
	Local $file_rdata = 0
	Local $msg_rdata = 0

	; Initialize sections if not already done
	If $sections[$SECTION_RDATA][0] = 0 Then
		InitializeSections(GetGWBaseAddress())
	EndIf

	; Find file string in .rdata
	If $aFile <> "" Then
		Local $file_bytes = _StringToBytes($aFile)
		Local $file_mask = ""
		For $i = 1 To BinaryLen($file_bytes)
			$file_mask &= "x"
		Next
		$file_rdata = Find($file_bytes, $file_mask, 0, $SECTION_RDATA)
		If $file_rdata = 0 Then
			_Log_Error("File string not found in .rdata: " & $aFile, "Scan", $GUIEdit)
			Return ; String not found
		EndIf
	EndIf

	; Find message string in .rdata
	If $aMsg <> "" Then
		Local $msg_bytes = _StringToBytes($aMsg)
		Local $msg_mask = ""
		For $i = 1 To BinaryLen($msg_bytes)
			$msg_mask &= "x"
		Next
		$msg_rdata = Find($msg_bytes, $msg_mask, 0, $SECTION_RDATA)
		If $msg_rdata = 0 Then
			_Log_Error("Message string not found in .rdata: " & $aMsg, "Scan", $GUIEdit)
			Return ; String not found
		EndIf
	EndIf

	; Create the pattern with assertion marker
	Local $pattern = "AA000000" ; Marker for assertion pattern (at offset 12)
	$pattern &= SwapEndian(Hex($file_rdata, 8)) ; File address (offset 13-16)
	$pattern &= "00" ; Padding (offset 17)
	$pattern &= SwapEndian(Hex($msg_rdata, 8)) ; Msg address (offset 18-21)
	$pattern &= SwapEndian(Hex($aOffset, 8)) ; Offset (offset 22-25)

	; Pad to 68 bytes
	Local $padding_count = 68 - 14
	For $i = 1 To $padding_count
		$pattern &= "00"
	Next

	$mASMString &= "00000000" & SwapEndian(Hex(10, 8)) & $pattern
	$mASMSize += 80
EndFunc