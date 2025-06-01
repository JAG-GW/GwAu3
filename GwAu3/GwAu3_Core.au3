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
#include "Modules/Maps/MapMod_Initialize.au3"
#include "Modules/Maps/MapMod_Data.au3"
#include "Modules/Maps/MapMod_Commands.au3"
#include "Modules/Friends/FriendMod_Initialize.au3"
#include "Modules/Friends/FriendMod_Data.au3"
#include "Modules/Friends/FriendMod_Commands.au3"

If @AutoItX64 Then
    MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
    Exit
EndIf

#Region CommandStructs
Global $mInviteGuild = DllStructCreate('ptr;dword;dword header;dword counter;wchar name[32];dword type')
Global $mInviteGuildPtr = DllStructGetPtr($mInviteGuild)

Global $mSendChat = DllStructCreate('ptr;dword')
Global $mSendChatPtr = DllStructGetPtr($mSendChat)

Global $mAction = DllStructCreate('ptr;dword;dword;')
Global $mActionPtr = DllStructGetPtr($mAction)

Global $mPacket = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Global $mPacketPtr = DllStructGetPtr($mPacket)

Global $mBasePointer
Global $mPacketLocation
Global $mQueueCounter
Global $mQueueSize
Global $mQueueBase
Global $mPreGameContextAddr
Global $mFrameArray
Global $mFriendList
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

Func Initialize($aGW, $bChangeTitle = True, $aUseEventSystem = True)
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

	$mPacketLocation = Ptr(MemoryRead(GetScannedAddress('ScanPacketLocation', 0xB)))
	SetValue('PacketLocation', $mPacketLocation)
	_Log_Debug("PacketLocation: " & $mPacketLocation, "Initialize", $GUIEdit)

	$mPing = MemoryRead(GetScannedAddress('ScanPing', -0x14))
	_Log_Debug("Ping: " & Ptr($mPing), "Initialize", $GUIEdit)

	$mPreGameContextAddr = MemoryRead(GetScannedAddress('ScanPreGameContextAddr', 0x35))
	_Log_Debug("PreGameContextAddr: " & Ptr($mPreGameContextAddr), "Initialize", $GUIEdit)

	$mFrameArray = MemoryRead(GetScannedAddress('ScanFrameArray', -0x13))
	_Log_Debug("FrameArray: " & Ptr($mFrameArray), "Initialize", $GUIEdit)

	$mFriendList = GetScannedAddress('ScanFriendList', 0)
	$mFriendList = MemoryRead(FindInRange("57B9", "xx", 2, $mFriendList, $mFriendList + 0xFF))
	_Log_Debug("FriendList: " & Ptr($mFriendList), "Initialize", $GUIEdit)

	_SkillMod_Initialize()
	_AttributeMod_Initialize()
	_TradeMod_Initialize()
	_AgentMod_Initialize()
	_MapMod_Initialize()
	_FriendMod_Initialize()

	$lTemp = GetScannedAddress('ScanEngine', -0x22)
	SetValue('MainStart', Ptr($lTemp))
	SetValue('MainReturn', Ptr($lTemp + 0x5))

	$lTemp = GetScannedAddress('ScanRenderFunc', -0x67)
	SetValue('RenderingMod', Ptr($lTemp))
	SetValue('RenderingModReturn', Ptr($lTemp + 0xA))

	$lTemp = GetScannedAddress('ScanTraderHook', -0x2F)
	SetValue('TraderHookStart', Ptr($lTemp))
	SetValue('TraderHookReturn', Ptr($lTemp + 0x5))

	SetValue('PacketSendFunction', Ptr(GetScannedAddress('ScanPacketSendFunction', -0x50)))

	SetValue('ActionBase', Ptr(MemoryRead(GetScannedAddress('ScanActionBase', -0x3))))
	SetValue('ActionFunction', Ptr(GetScannedAddress('ScanActionFunction', -0x3)))

	SetValue('QueueSize', '0x00000010')
	SetValue('CallbackEvent', '0x00000501')

	ModifyMemory()

	$mQueueCounter = MemoryRead(GetValue('QueueCounter'))
	$mQueueSize = GetValue('QueueSize') - 1
	$mQueueBase = GetValue('QueueBase')
	$mDisableRendering = GetValue('DisableRendering')

	If $mUseEventSystem Then
		$mGUI = GUICreate('GwAu3')
		RegisterCallbackHandler()
		MemoryWrite(GetValue('CallbackHandle'), $mGUI)
	EndIf

	DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mPacket, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mAction, 1, GetValue('CommandAction'))
	DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
	DllStructSetData($mSendChat, 2, 0x0063) ; putting raw value, because $HEADER_SEND_CHAT_MESSAGE is used before declaration

	$g_mAgentCopyCount = GetValue('AgentCopyCount')
	$g_mAgentCopyBase = GetValue('AgentCopyBase')
	$g_mTraderQuoteID = GetValue('TraderQuoteID')
    $g_mTraderCostID = GetValue('TraderCostID')
    $g_mTraderCostValue = GetValue('TraderCostValue')

	If $bChangeTitle Then
		WinSetTitle($mGWWindowHandle, '', 'Guild Wars - ' & GetCharname())
	EndIf

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

	_('ScanPing:')
	AddPattern('E874651600')

	_('ScanPacketSendFunction:')
	AddPattern('C747540000000081E6')

	_('ScanPacketLocation:')
	AddPattern('83C40433C08BE55DC3A1')

	_('ScanActionFunction:')
	AddPattern('8B7508578BF983FE09750C6876')

	_('ScanActionBase:')
	AddPattern('8D1C87899DF4')

	_('ScanTraderHook:')
	AddPattern('50516A466A06')

	_SkillMod_DefinePatterns()
	_AttributeMod_DefinePatterns()
	_TradeMod_DefinePatterns()
	_AgentMod_DefinePatterns()
	_MapMod_DefinePatterns()
	_FriendMod_DefinePatterns()

	Local $assertions[3][2] = [ _
		["P:\Code\Gw\Ui\UiPregame.cpp", "!s_scene"], _
		["P:\Code\Engine\Frame\FrMsg.cpp", "frame"], _
		["P:\Code\Gw\Friend\FriendApi.cpp", "friendName && *friendName"]]

	Local $assertionPatterns = GetMultipleAssertionPatterns($assertions)
	_('ScanPreGameContextAddr:')
	AddPattern($assertionPatterns[0])
	_('ScanFrameArray:')
	AddPattern($assertionPatterns[1])
	_('ScanFriendList:')
	AddPattern($assertionPatterns[2])

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