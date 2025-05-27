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
#include "Modules/Agents/AgentMod_Initialize.au3"
#include "Modules/Agents/AgentMod_Data.au3"
#include "Modules/Agents/AgentMod_Commands.au3"

If @AutoItX64 Then
    MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
    Exit
EndIf

#Region CommandStructs
Global $mInviteGuild = DllStructCreate('ptr;dword;dword header;dword counter;wchar name[32];dword type')
Global $mInviteGuildPtr = DllStructGetPtr($mInviteGuild)

Global $mWriteChat = DllStructCreate('ptr')
Global $mWriteChatPtr = DllStructGetPtr($mWriteChat)

Global $mToggleLanguage = DllStructCreate('ptr;dword')
Global $mToggleLanguagePtr = DllStructGetPtr($mToggleLanguage)

Global $mSendChat = DllStructCreate('ptr;dword')
Global $mSendChatPtr = DllStructGetPtr($mSendChat)

Global $mChangeStatus = DllStructCreate('ptr;dword')
Global $mChangeStatusPtr = DllStructGetPtr($mChangeStatus)

Global $MTradeHackAddress
Global $mPreGameContextAddr
Global $mFrameArray
#EndRegion CommandStructs

#Region Initialisation
Func GetHwnd($aProc)
	Local $wins = WinList()
	For $i = 1 To UBound($wins) - 1
		If (WinGetProcess($wins[$i][1]) == $aProc) And (BitAND(WinGetState($wins[$i][1]), 2)) Then Return $wins[$i][1]
	Next
EndFunc

Func GetWindowHandle()
	Return $mGWWindowHandle
EndFunc

Func GetLoggedCharNames()
	Local $array = ScanGW()
	If $array[0] == 0 Then Return ''
	Local $ret = $array[1]
	For $i = 2 To $array[0]
		$ret &= "|" & $array[$i]
	Next
	Return $ret
EndFunc

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

Func Initialize($aGW, $bChangeTitle = True, $aUseStringLog = False, $aUseEventSystem = True)
   $mUseStringLog = $aUseStringLog
   $mUseEventSystem = $aUseEventSystem

   _Log_Info("Initializing...", "GwAu3", $GUIEdit)

   If IsString($aGW) Then
      Local $lProcessList = ProcessList("gw.exe")
      For $i = 1 To $lProcessList[0][0]
        $mGWProcessId = $lProcessList[$i][1]
        $mGWWindowHandle = GetHwnd($mGWProcessId)
        MemoryOpen($mGWProcessId)
        If $mGWProcHandle Then
           If StringRegExp(ScanForCharname(), $aGW) = 1 Then
              ExitLoop
           EndIf
        EndIf
        MemoryClose()
        $mGWProcHandle = 0
      Next
   Else
      $mGWProcessId = $aGW
      $mGWWindowHandle = GetHwnd($mGWProcessId)
      MemoryOpen($aGW)
      ScanForCharname()
   EndIf

   Scan()

   $mBasePointer = MemoryRead(GetScannedAddress('ScanBasePointer', 0x8))
   SetValue('BasePointer', Ptr($mBasePointer))
   _Log_Debug("BasePointer: " & Ptr($mBasePointer), "Initialize", $GUIEdit)

   $mPacketLocation = Ptr(MemoryRead(GetScannedAddress('ScanBaseOffset', 0xB)))
   SetValue('PacketLocation', $mPacketLocation)
   _Log_Debug("PacketLocation: " & $mPacketLocation, "Initialize", $GUIEdit)

   $mPing = MemoryRead(GetScannedAddress('ScanPing', -0x14))
   _Log_Debug("Ping: " & Ptr($mPing), "Initialize", $GUIEdit)

   $mLoggedIn = MemoryRead(GetScannedAddress('ScanLoggedIn', 0x3))
   _Log_Debug("LoggedIn: " & Ptr($mLoggedIn), "Initialize", $GUIEdit)

   $mCurrentStatus = MemoryRead(GetScannedAddress('ScanChangeStatusFunction', 0x23))
   _Log_Debug("CurrentStatus: " & Ptr($mCurrentStatus), "Initialize", $GUIEdit)

   $mCharslots = MemoryRead(GetScannedAddress('ScanCharslots', 0x16))
   _Log_Debug("Charslots: " & Ptr($mCharslots), "Initialize", $GUIEdit)

	$mPreGameContextAddr = MemoryRead(GetScannedAddress('ScanPreGameContextAddr', 0x35))
	_Log_Debug("PreGameContextAddr: " & Ptr($mPreGameContextAddr), "Initialize", $GUIEdit)

   	$mFrameArray = MemoryRead(GetScannedAddress('ScanFrameArray', -0x13))
	_Log_Debug("FrameArray: " & Ptr($mFrameArray), "Initialize", $GUIEdit)

   _SkillMod_Initialize()
   _AttributeMod_Initialize()
   _TradeMod_Initialize()
   _AgentMod_Initialize()

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

   SetValue('WriteChatFunction', Ptr(GetScannedAddress('ScanWriteChatFunction', -0x3D)))

   SetValue('PacketSendFunction', Ptr(GetScannedAddress('ScanPacketSendFunction', -0x50)))

   SetValue('ActionBase', Ptr(MemoryRead(GetScannedAddress('ScanActionBase', -0x3))))
   SetValue('ActionFunction', Ptr(GetScannedAddress('ScanActionFunction', -0x3)))

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
   $mEnsureEnglish = GetValue('EnsureEnglish')
   $mTraderQuoteID = GetValue('TraderQuoteID')
   $mTraderCostID = GetValue('TraderCostID')
   $mTraderCostValue = GetValue('TraderCostValue')
   $mDisableRendering = GetValue('DisableRendering')
   $mLastDialogID = GetValue('LastDialogID')

	If $mUseEventSystem Then
		$mGUI = GUICreate('GwAu3')
		RegisterCallbackHandler()
		MemoryWrite(GetValue('CallbackHandle'), $mGUI)
	EndIf

   DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mInviteGuild, 2, 0x4C)
   DllStructSetData($mPacket, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mAction, 1, GetValue('CommandAction'))
   DllStructSetData($mToggleLanguage, 1, GetValue('CommandToggleLanguage'))
   DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
   DllStructSetData($mSendChat, 2, 0x0063) ; putting raw value, because $HEADER_SEND_CHAT_MESSAGE is used before declaration
   DllStructSetData($mWriteChat, 1, GetValue('CommandWriteChat'))
   DllStructSetData($mChangeStatus, 1, GetValue('CommandChangeStatus'))
   _SkillMod_SetupStructures()
   _AttributeMod_SetupStructures()
   _TradeMod_SetupStructures()
   _AgentMod_SetupStructures()
   _MapMod_SetupStructures()

   If $bChangeTitle Then
      WinSetTitle($mGWWindowHandle, '', 'Guild Wars - ' & GetCharname())
   EndIf
   SetMaxMemory()

   _Log_Info("End of Initialization.", "GwAu3", $GUIEdit)

   Return $mGWWindowHandle
EndFunc

Func Scan()
	Local $lGwBase = ScanForProcess()
	$mASMSize = 0
	$mASMCodeOffset = 0
	$mASMString = ''

	_('MainModPtr/4')

	_('ScanBasePointer:')
	AddPattern('506A0F6A00FF35')

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

	_('ScanPing:')
	AddPattern('E874651600')

	_('ScanLoggedIn:')
	AddPattern('C705ACDE740000000000C3CCCCCCCC')

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

	_SkillMod_DefinePatterns()
	_AttributeMod_DefinePatterns()
	_TradeMod_DefinePatterns()
	_AgentMod_DefinePatterns()
	_MapMod_DefinePatterns()

	Local $assertions[2][2] = [ _
		["P:\Code\Gw\Ui\UiPregame.cpp", "!s_scene"], _
		["P:\Code\Engine\Frame\FrMsg.cpp", "frame"] _
	]
	Local $assertionPatterns = GetMultipleAssertionPatterns($assertions)
	_('ScanPreGameContextAddr:')
	AddPattern($assertionPatterns[0])
	_('ScanFrameArray:')
	AddPattern($assertionPatterns[1])

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

Func ScanForCharname()
	Local $lCharNameCode = BinaryToString('0x6A14FF751868')
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
#EndRegion Initialisation