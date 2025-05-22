#include-once
#include "Core/GwAu3_Constants_Core.au3"
#include "Core/GwAu3_Memory.au3"
#include "Core/GwAu3_Assembler.au3"
#include "Core/GwAu3_Callback.au3"
#include "Core/GwAu3_Commands.au3"
#include "Core/GwAu3_Utils.au3"
#include "Core/GwAu3_LogMessages.au3"
#include "Modules/Skills/SkillMod_Initialize.au3"
#include "Modules/Skills/SkillMod_Data.au3"
#include "Modules/Skills/SkillMod_Commands.au3"
#include "Modules/Attributes/AttributeMod_Initialize.au3"
#include "Modules/Attributes/AttributeMod_Data.au3"
#include "Modules/Attributes/AttributeMod_Commands.au3"

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

Global $mSellItem = DllStructCreate('ptr;dword;dword;dword')
Global $mSellItemPtr = DllStructGetPtr($mSellItem)

Global $mToggleLanguage = DllStructCreate('ptr;dword')
Global $mToggleLanguagePtr = DllStructGetPtr($mToggleLanguage)

Global $mBuyItem = DllStructCreate('ptr;dword;dword;dword;dword')
Global $mBuyItemPtr = DllStructGetPtr($mBuyItem)

Global $mCraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Global $mCraftItemExPtr = DllStructGetPtr($mCraftItemEx)

Global $mSendChat = DllStructCreate('ptr;dword')
Global $mSendChatPtr = DllStructGetPtr($mSendChat)

Global $mRequestQuote = DllStructCreate('ptr;dword')
Global $mRequestQuotePtr = DllStructGetPtr($mRequestQuote)

Global $mRequestQuoteSell = DllStructCreate('ptr;dword')
Global $mRequestQuoteSellPtr = DllStructGetPtr($mRequestQuoteSell)

Global $mTraderBuy = DllStructCreate('ptr')
Global $mTraderBuyPtr = DllStructGetPtr($mTraderBuy)

Global $mTraderSell = DllStructCreate('ptr')
Global $mTraderSellPtr = DllStructGetPtr($mTraderSell)

Global $mSalvage = DllStructCreate('ptr;dword;dword;dword')
Global $mSalvagePtr = DllStructGetPtr($mSalvage)

Global $mMakeAgentArray = DllStructCreate('ptr;dword')
Global $mMakeAgentArrayPtr = DllStructGetPtr($mMakeAgentArray)

Global $mChangeStatus = DllStructCreate('ptr;dword')
Global $mChangeStatusPtr = DllStructGetPtr($mChangeStatus)

Global $MTradeHackAddress
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

   _SkillMod_Initialize()
   _AttributeMod_Initialize()

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

   SetValue('SalvageFunction', Ptr(GetScannedAddress('ScanSalvageFunction', -0xA)))
   SetValue('SalvageGlobal', Ptr(MemoryRead(GetScannedAddress('ScanSalvageGlobal', 1) - 0x4)))

   SetValue('MoveFunction', Ptr(GetScannedAddress('ScanMoveFunction', 0x1)))

  ;SetValue('ChangeTargetFunction', Ptr(GetScannedAddress('ScanChangeTargetFunction', -0x0089) + 1, 8))
   SetValue('ChangeTargetFunction', Ptr(GetScannedAddress('ScanChangeTargetFunction', -0x0086) + 1))
   SetValue('WriteChatFunction', Ptr(GetScannedAddress('ScanWriteChatFunction', -0x3D)))

   SetValue('SellItemFunction', Ptr(GetScannedAddress('ScanSellItemFunction', -0x55)))
   SetValue('PacketSendFunction', Ptr(GetScannedAddress('ScanPacketSendFunction', -0x50)))

   SetValue('ActionBase', Ptr(MemoryRead(GetScannedAddress('ScanActionBase', -0x3))))
   SetValue('ActionFunction', Ptr(GetScannedAddress('ScanActionFunction', -0x3)))

   SetValue('BuyItemBase', Ptr(MemoryRead(GetScannedAddress('ScanBuyItemBase', 0xF))))

   SetValue('TransactionFunction', Ptr(GetScannedAddress('ScanTransactionFunction', -0x7E)))
   SetValue('RequestQuoteFunction', Ptr(GetScannedAddress('ScanRequestQuoteFunction', -0x34)))

   SetValue('TraderFunction', Ptr(GetScannedAddress('ScanTraderFunction', -0x1E)))
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
   DllStructSetData($mSellItem, 1, GetValue('CommandSellItem'))
   DllStructSetData($mAction, 1, GetValue('CommandAction'))
   DllStructSetData($mToggleLanguage, 1, GetValue('CommandToggleLanguage'))
   DllStructSetData($mBuyItem, 1, GetValue('CommandBuyItem'))
   DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
   DllStructSetData($mSendChat, 2, 0x0063) ; putting raw value, because $HEADER_SEND_CHAT_MESSAGE is used before declaration
   DllStructSetData($mWriteChat, 1, GetValue('CommandWriteChat'))
   DllStructSetData($mRequestQuote, 1, GetValue('CommandRequestQuote'))
   DllStructSetData($mRequestQuoteSell, 1, GetValue('CommandRequestQuoteSell'))
   DllStructSetData($mTraderBuy, 1, GetValue('CommandTraderBuy'))
   DllStructSetData($mTraderSell, 1, GetValue('CommandTraderSell'))
   DllStructSetData($mSalvage, 1, GetValue('CommandSalvage'))
   DllStructSetData($mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
   DllStructSetData($mChangeStatus, 1, GetValue('CommandChangeStatus'))
   _SkillMod_SetupStructures()
   _AttributeMod_SetupStructures()

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

	; Scan patterns
	_('ScanBasePointer:')
	AddPattern('506A0F6A00FF35') ;85C0750F8BCE CHECKED ; STILL UPDATED 23.12.24

	_('ScanAgentBase:') ; Still in use? (16/06-2023)
	;AddPattern('FF50104783C6043BFB75E1') ; Still in use? (16/06-2023)
	AddPattern('FF501083C6043BF775E2') ; UPDATED 23.12.24

	_('ScanAgentArray:')
	AddPattern('8B0C9085C97419')

	_('ScanCurrentTarget:')
	AddPattern('83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55') ;UPDATED 23.12.24

	_('ScanMyID:')
	AddPattern('83EC08568BF13B15') ; STILL WORKING 23.12.24

	_('ScanEngine:')
	AddPattern('568B3085F67478EB038D4900D9460C') ; UPDATED 23.12.24 NEEDS TO GET UPDATED EACH PATCH

	_('ScanRenderFunc:')
	AddPattern('F6C401741C68B1010000BA') ; STILL WORKING 23.12.24

	_('ScanLoadFinished:')
	AddPattern('8B561C8BCF52E8') ; COULD NOT UPDATE! 23.12.24

	_('ScanPostMessage:')
	AddPattern('6A00680080000051FF15') ; COULD NOT UPDATE! 23.12.24

	_('ScanTargetLog:')
	AddPattern('5356578BFA894DF4E8') ; COULD NOT UPDATE! 23.12.24

	_('ScanChangeTargetFunction:')
	AddPattern('3BDF0F95') ; STILL WORKING 23.12.24, 33C03BDA0F95C033

	_('ScanMoveFunction:')
	AddPattern('558BEC83EC208D45F0') ; STILL WORKING 23.12.24, 558BEC83EC2056578BF98D4DF0

	_('ScanPing:')
	AddPattern('E874651600') ; UPDATED 23.12.24

;~ 	_('ScanMapID:')
;~ 	AddPattern('558BEC8B450885C074078B') ;STILL WORKING 23.12.24, B07F8D55

;~ 	_('ScanMapLoading:')
;~ 	AddPattern('2480ED0000000000') ; UPDATED 25.12.24, 6A2C50E8

	_('ScanLoggedIn:')
	AddPattern('C705ACDE740000000000C3CCCCCCCC') ; UPDATED 26.12.24, NEED TO GET UPDATED EACH PATCH OLD:BFFFC70580 85C07411B807

	_('ScanRegion:')
	AddPattern('6A548D46248908') ; STILL WORKING 23.12.24

;~ 	_('ScanMapInfo:')
;~ 	AddPattern('8BF0EB038B750C3B') ; STILL WORKING 23.12.24, 83F9FD7406

;~ 	_('ScanLanguage:')
;~ 	AddPattern('C38B75FC8B04B5') ; COULD NOT UPDATE! 23.12.24

	_('ScanPacketSendFunction:')
	AddPattern('C747540000000081E6') ;UPDATED 28.12.24 old: F7D9C74754010000001BC981, 558BEC83EC2C5356578BF985

	_('ScanBaseOffset:')
	AddPattern('83C40433C08BE55DC3A1') ; STILL WORKING 23.12.24, 5633F63BCE740E5633D2

	_('ScanWriteChatFunction:')
	AddPattern('8D85E0FEFFFF50681C01') ;STILL WORKING 23.12.24, 558BEC5153894DFC8B4D0856578B

	_('ScanChatLog:')
	AddPattern('8B45F48B138B4DEC50') ; COULD NOT UPDATE! 23.12.24

	_('ScanSellItemFunction:')
	AddPattern('8B4D2085C90F858E') ; COULD NOT UPDATE! 23.12.24

	_('ScanStringLog:')
	AddPattern('893E8B7D10895E04397E08') ; COULD NOT UPDATE! 23.12.24

	_('ScanStringFilter1:')
	AddPattern('8B368B4F2C6A006A008B06') ; COULD NOT UPDATE! 23.12.24

	_('ScanStringFilter2:')
	AddPattern('515356578BF933D28B4F2C') ; COULD NOT UPDATE! 23.12.24

	_('ScanActionFunction:')
	AddPattern('8B7508578BF983FE09750C6876') ;STILL WORKING 23.12.24, ;8B7D0883FF098BF175116876010000

	_('ScanActionBase:')
	AddPattern('8D1C87899DF4') ; UPDATED 24.12.24, OLD: 8D1C87899DF4FEFFFF8BC32BC7C1F802, 8B4208A80175418B4A08

	_('ScanTransactionFunction:')
	AddPattern('85FF741D8B4D14EB08') ;STILL WORKING 23.12.24 ;558BEC81ECC000000053568B75085783FE108BFA8BD97614

	_('ScanBuyItemFunction:') ; Still in use? (16/06-2023)
	AddPattern('D9EED9580CC74004') ;STILL WORKING 23.12.24 ; Still in use? (16/06-2023)

	_('ScanBuyItemBase:')
	AddPattern('D9EED9580CC74004') ;STILL WORKING 23.12.24

	_('ScanRequestQuoteFunction:')
	AddPattern('8B752083FE107614')  ;STILL WORKING 23.12.24;8B750C5783FE107614 ;53568B750C5783FE10

	_('ScanTraderFunction:')
	;AddPattern('8B45188B551085') ;83FF10761468
	AddPattern('83FF10761468D2210000') ;STILL WORKING 23.12.24

	_('ScanTraderHook:')
	AddPattern('50516A466A06')

	_('ScanSleep:')
	AddPattern('6A0057FF15D8408A006860EA0000') ; UPDATED 24.12.24, OLD:5F5E5B741A6860EA0000

	_('ScanSalvageFunction:')
	AddPattern('33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC76') ; UPDATED 24.12.24 OLD:33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC75
	;AddPattern('8BFA8BD9897DF0895DF4')

	_('ScanSalvageGlobal:')
	AddPattern('8B4A04538945F48B4208') ; UPDATED 24.12.24, OLD: 8B5104538945F48B4108568945E88B410C578945EC8B4110528955E48945F0
	;AddPattern('8B018B4904A3')

	_('ScanClickToMoveFix:')
	AddPattern('3DD301000074') ;STILL WORKING 23.12.24,

	_('ScanZoomStill:')
	AddPattern('558BEC8B41085685C0') ; COULD NOT UPDATE! 23.12.24

	_('ScanZoomMoving:')
	AddPattern('EB358B4304') ; COULD NOT UPDATE! 23.12.24

	_('ScanChangeStatusFunction:')
	AddPattern('558BEC568B750883FE047C14') ;STILL WORKING 23.12.24, 568BF183FE047C14682F020000

	_('ScanCharslots:')
	AddPattern('8B551041897E38897E3C897E34897E48897E4C890D') ; COULD NOT UPDATE! 23.12.24

	_('ScanReadChatFunction:')
	AddPattern('A128B6EB00') ; COULD NOT UPDATE! 23.12.24

	_('ScanDialogLog:')
	AddPattern('8B45088945FC8D45F8506A08C745F841') ;STILL WORKING 23.12.24, 558BEC83EC285356578BF28BD9

	_("ScanTradeHack:")
	AddPattern("8BEC8B450883F846") ;STILL WORKING 23.12.24

	_("ScanClickCoords:")
	AddPattern("8B451C85C0741CD945F8") ;STILL WORKING 23.12.24

	_("ScanInstanceInfo:")
	AddPattern("6A2C50E80000000083C408C7") ;Added by Greg76 to get Instance Info

	_("ScanAreaInfo:")
	AddPattern("6BC67C5E05") ;Added by Greg76 to get Area Info

	_("ScanWorldConst:")
	AddPattern("8D0476C1E00405") ;Added by Greg76 to get World Info

	_SkillMod_DefinePatterns()
	_AttributeMod_DefinePatterns()

	_('ScanProc:') ; Label for the scan procedure
	_('pushad') ; Push all general-purpose registers onto the stack to save their values
	_('mov ecx,' & Hex($lGwBase, 8)) ; Move the base address of the Guild Wars process into the ECX register
	_('mov esi,ScanProc') ; Move the address of the ScanProc label into the ESI register
	_('ScanLoop:') ; Label for the scan loop
	_('inc ecx') ; Increment the value in the ECX register by 1
	_('mov al,byte[ecx]') ; Move the byte value at the address stored in ECX into the AL register
	_('mov edx,ScanBasePointer') ; Move the address of the ScanBasePointer into the EDX register


	_('ScanInnerLoop:') ; Label for the inner scan loop
	_('mov ebx,dword[edx]') ; Move the 4-byte value at the address stored in EDX into the EBX register
	_('cmp ebx,-1') ; Compare the value in EBX to -1
	_('jnz ScanContinue') ; Jump to the ScanContinue label if the comparison is not zero
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero
	_('jmp ScanExit') ; Jump to the ScanExit label


	_('ScanContinue:') ; Label for the scan continue section
	_('lea edi,dword[edx+ebx]') ; Load the effective address of the value at EDX + EBX into the EDI register
	_('add edi,C') ; Add the value of C to the address in EDI
	_('mov ah,byte[edi]') ; Move the byte value at the address stored in EDI into the AH register
	_('cmp al,ah') ; Compare the value in AL to the value in AH
	_('jz ScanMatched') ; Jump to the ScanMatched label if the comparison is zero (i.e., the values match)
	_('cmp ah,00')    ;Added by Greg76 for scan wildcards
	_('jz ScanMatched')    ;Added by Greg76 for scan wildcards
	_('mov dword[edx],0') ; Move the value 0 into the 4-byte location at the address stored in EDX
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero
	_('jmp ScanExit') ; Jump to the ScanExit label


	_('ScanMatched:') ; Label for the scan matched section
	_('inc ebx') ; Increment the value in the EBX register by 1
	_('mov edi,dword[edx+4]') ; Move the 4-byte value at the address EDX + 4 into the EDI register
	_('cmp ebx,edi') ; Compare the value in EBX to the value in EDI
	_('jz ScanFound') ; Jump to the ScanFound label if the comparison is zero (i.e., the values match)
	_('mov dword[edx],ebx') ; Move the value in EBX into the 4-byte location at the address stored in EDX
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero
	_('jmp ScanExit') ; Jump to the ScanExit label


	_('ScanFound:') ; Label for the scan found section
	_('lea edi,dword[edx+8]') ; Load the effective address of the value at EDX + 8 into the EDI register
	_('mov dword[edi],ecx') ; Move the value in ECX into the 4-byte location at the address stored in EDI
	_('mov dword[edx],-1') ; Move the value -1 into the 4-byte location at the address stored in EDX (mark as found)
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero

	_('ScanExit:') ; Label for the scan exit section
	_('popad') ; Pop all general-purpose registers from the stack to restore their original values
	_('retn') ; Return from the current function (exit the scan routine)


	$mBase = $lGwBase + 0x9DF000
	Local $lScanMemory = MemoryRead($mBase, 'ptr')

	; Check if the scan memory address is empty (no previous injection)
	If $lScanMemory = 0 Then
		; Allocate a new block of memory for the scan routine
		$mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 0x40)
		$mMemory = $mMemory[0] ; Get the allocated memory address

		; Write the allocated memory address to the scan memory location
		MemoryWrite($mBase, $mMemory)

;~ out("First Inject: " & $mMemory)
	Else
		; If the scan memory address is not empty, use the existing memory address
		$mMemory = $lScanMemory
	EndIf


	; Complete the assembly code for the scan routine
	CompleteASMCode()

	; Check if this is the first injection (no previous scan memory address)
	If $lScanMemory = 0 Then
		; Write the assembly code to the allocated memory address
		WriteBinary($mASMString, $mMemory + $mASMCodeOffset)

		; Create a new thread in the target process to execute the scan routine
		Local $lThread = DllCall($mKernelHandle, 'int', 'CreateRemoteThread', 'int', $mGWProcHandle, 'ptr', 0, 'int', 0, 'int', GetLabelInfo('ScanProc'), 'ptr', 0, 'int', 0, 'int', 0)
		$lThread = $lThread[0] ; Get the thread ID

		; Wait for the thread to finish executing
		Local $lResult
		Do
			; Wait for up to 50ms for the thread to finish
			$lResult = DllCall($mKernelHandle, 'int', 'WaitForSingleObject', 'int', $lThread, 'int', 50)
		Until $lResult[0] <> 258 ; Wait until the thread is no longer waiting (258 is the WAIT_TIMEOUT constant)

		; Close the thread handle to free up system resources
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
