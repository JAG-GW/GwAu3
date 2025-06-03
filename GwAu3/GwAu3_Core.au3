#include-once
#include "Core/GwAu3_Constants_Core.au3"
#include "Core/GwAu3_Memory.au3"
#include "Core/GwAu3_Assembler.au3"
#include "Core/GwAu3_Callback.au3"
#include "Core/GwAu3_Commands.au3"
#include "Core/GwAu3_Utils.au3"
#include "Core/GwAu3_LogMessages.au3"
#include "Core/GwAu3_FindAssertion.au3"

#include "Modules/Skills/SkillMod_Data.au3"
#include "Modules/Skills/SkillMod_Commands.au3"
#include "Modules/Friends/FriendMod_Data.au3"
#include "Modules/Friends/FriendMod_Commands.au3"
#include "Modules/Attributes/AttributeMod_Data.au3"
#include "Modules/Attributes/AttributeMod_Commands.au3"
#include "Modules/Trades/TradeMod_Data.au3"
#include "Modules/Trades/TradeMod_Commands.au3"
#include "Modules/Agents/AgentMod_Data.au3"
#include "Modules/Agents/AgentMod_Commands.au3"
#include "Modules/Maps/MapMod_Data.au3"
#include "Modules/Maps/MapMod_Commands.au3"


If @AutoItX64 Then
    MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
    Exit
EndIf

#Region Global Variables
; Structure to store pattern information
Global $g_aPatterns[1][6] = [[0]] ; [full_name, pattern, offset, type, is_assertion, assertion_msg]
Global $g_aAssertionPatterns[0][2] ; [file, message]

; Pattern types
Global Const $PATTERN_TYPE_PTR = 'Ptr'    ; Pointer to data
Global Const $PATTERN_TYPE_FUNC = 'Func'  ; Function to call
Global Const $PATTERN_TYPE_HOOK = 'Hook'  ; Hook/injection point

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
Global $mPreGame
Global $mFrameArray
Global $mFriendList

;Skill
Global $g_mSkillBase
Global $g_mSkillTimer
Global $g_mUseSkill = DllStructCreate('ptr;dword;dword;dword;bool')
Global $g_mUseSkillPtr = DllStructGetPtr($g_mUseSkill)
Global $g_mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Global $g_mUseHeroSkillPtr = DllStructGetPtr($g_mUseHeroSkill)
Global $g_iLastSkillUsed = 0
Global $g_iLastSkillTarget = 0

;Friend
Global $g_mFriendList
Global $g_mChangeStatus = DllStructCreate('ptr;dword')
Global $g_mChangeStatusPtr = DllStructGetPtr($g_mChangeStatus)
Global $g_mAddFriend = DllStructCreate('ptr;ptr;ptr;dword')
Global $g_mAddFriendPtr = DllStructGetPtr($g_mAddFriend)
Global $g_mRemoveFriend = DllStructCreate('ptr;byte[16];ptr;dword')
Global $g_mRemoveFriendPtr = DllStructGetPtr($g_mRemoveFriend)
Global $g_iLastStatus = 0

;Attribute
Global $g_mAttributeInfo
Global $g_mIncreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_mIncreaseAttributePtr = DllStructGetPtr($g_mIncreaseAttribute)
Global $g_mDecreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_mDecreaseAttributePtr = DllStructGetPtr($g_mDecreaseAttribute)
Global $g_bAttributeModuleInitialized = False
Global $g_iLastAttributeModified = -1
Global $g_iLastAttributeValue = 0

;Trade
Global $g_mBuyItemBase      ; Pointer to buy item base
Global $g_mTraderQuoteID    ; Current trader quote ID
Global $g_mTraderCostID     ; Trader cost ID
Global $g_mTraderCostValue  ; Trader cost value
Global $g_mSalvageGlobal    ; Pointer to salvage global data
Global $g_mSellItem = DllStructCreate('ptr;dword;dword;dword')
Global $g_mSellItemPtr = DllStructGetPtr($g_mSellItem)
Global $g_mBuyItem = DllStructCreate('ptr;dword;dword;dword;dword')
Global $g_mBuyItemPtr = DllStructGetPtr($g_mBuyItem)
Global $g_mCraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Global $g_mCraftItemExPtr = DllStructGetPtr($g_mCraftItemEx)
Global $g_mRequestQuote = DllStructCreate('ptr;dword')
Global $g_mRequestQuotePtr = DllStructGetPtr($g_mRequestQuote)
Global $g_mRequestQuoteSell = DllStructCreate('ptr;dword')
Global $g_mRequestQuoteSellPtr = DllStructGetPtr($g_mRequestQuoteSell)
Global $g_mTraderBuy = DllStructCreate('ptr')
Global $g_mTraderBuyPtr = DllStructGetPtr($g_mTraderBuy)
Global $g_mTraderSell = DllStructCreate('ptr')
Global $g_mTraderSellPtr = DllStructGetPtr($g_mTraderSell)
Global $g_mSalvage = DllStructCreate('ptr;dword;dword;dword')
Global $g_mSalvagePtr = DllStructGetPtr($g_mSalvage)
Global $g_bTradeModuleInitialized = False
Global $g_iLastTransactionType = -1
Global $g_iLastItemID = 0
Global $g_iLastQuantity = 0
Global $g_iLastPrice = 0

;Agent
Global $g_mAgentBase      ; Pointer to agent array
Global $g_mMaxAgents      ; Maximum number of agents
Global $g_mMyID           ; Player's agent ID
Global $g_mCurrentTarget  ; Current target agent ID
Global $g_mAgentCopyCount ; Count of copied agents
Global $g_mAgentCopyBase  ; Base address of agent copy array
Global $g_mChangeTarget = DllStructCreate('ptr;dword')
Global $g_mChangeTargetPtr = DllStructGetPtr($g_mChangeTarget)
Global $g_mMakeAgentArray = DllStructCreate('ptr;dword')
Global $g_mMakeAgentArrayPtr = DllStructGetPtr($g_mMakeAgentArray)
Global $g_bAgentModuleInitialized = False
Global $g_iLastTargetID = 0

;Map
Global $g_mMapIsLoaded      ; Flag indicating if map is loaded
Global $g_mMapLoading       ; Flag indicating if map is loading
Global $g_mInstanceInfo     ; Pointer to instance information
Global $g_mAreaInfo         ; Pointer to area information
Global $g_mWorldConst       ; Pointer to world constants
Global $g_mRegion
Global $g_mMove = DllStructCreate('ptr;float;float;float')
Global $g_mMovePtr = DllStructGetPtr($g_mMove)
Global $g_bMapModuleInitialized = False
Global $g_fLastMoveX = 0
Global $g_fLastMoveY = 0
Global $g_mClickCoordsX = 0
Global $g_mClickCoordsY = 0
#EndRegion Global Variables

#Region Initialization
Func Initialize($aGW, $bChangeTitle = True, $aUseEventSystem = True)
    $mUseEventSystem = $aUseEventSystem

    _Log_Info("Initializing...", "GwAu3", $GUIEdit)

    ; Open process
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

	ClearPatterns()
    ; Core patterns
    AddPattern('BasePointer', '506A0F6A00FF35', 0x8, 'Ptr')
    AddPattern('Engine', '568B3085F67478EB038D4900D9460C', -0x22, 'Hook')
    AddPattern('Render', 'F6C401741C68B1010000BA', -0x67, 'Hook')
    AddPattern('Ping', '568B750889165E', -0x3, 'Ptr')
    AddPattern('PacketSend', 'C747540000000081E6', -0x50, 'Func')
    AddPattern('PacketLocation', '83C40433C08BE55DC3A1', 0xB, 'Ptr')
    AddPattern('Action', '8B7508578BF983FE09750C6876', -0x3, 'Func')
    AddPattern('ActionBase', '8D1C87899DF4', -0x3, 'Ptr')
    AddPattern('Trader', '50516A466A06', -0x2F, 'Hook')
    ; Assertion patterns
    AddPattern('PreGame', "P:\Code\Gw\Ui\UiPregame.cpp", "!s_scene", 'Ptr')
    AddPattern('FrameArray', "P:\Code\Engine\Frame\FrMsg.cpp", "frame", 'Ptr')
    AddPattern('FriendList', "P:\Code\Gw\Friend\FriendApi.cpp", "friendName && *friendName", 'Ptr')
	; Skill patterns
    AddPattern('SkillBase', '8D04B6C1E00505', 0x8, 'Ptr')
    AddPattern('SkillTimer', 'FFD68B4DF08BD88B4708', -0x3, 'Ptr')
    AddPattern('UseSkill', '85F6745B83FE1174', -0x125, 'Func')
    AddPattern('UseHeroSkill', 'BA02000000B954080000', -0x59, 'Func')
	; Friend patterns
    AddPattern('PlayerStatus', '83FE037740FF24B50000000033C0', -0x25, 'Func')
    AddPattern('AddFriend', '8B751083FE037465', -0x47, 'Func')
    AddPattern('RemoveFriend', '83F803741D83F8047418', 0x0, 'Func')
    ; Attribute patterns
    AddPattern('AttributeInfo', 'BA3300000089088d4004', -0x3, 'Ptr')
    AddPattern('IncreaseAttribute', '8B7D088B702C8B1F3B9E00050000', -0x5A, 'Func')
    AddPattern('DecreaseAttribute', '8B8AA800000089480C5DC3CC', 0x19, 'Func')
    ; Trade patterns
    AddPattern('SellItem', '8B4D2085C90F858E', -0x55, 'Func')
    AddPattern('Transaction', '85FF741D8B4D14EB08', -0x7E, 'Func')
    AddPattern('BuyItemBase', 'D9EED9580CC74004', 0xF, 'Ptr')
    AddPattern('RequestQuote', '8B752083FE107614', -0x34, 'Func')
    AddPattern('Trader', '83FF10761468D2210000', -0x1E, 'Func')
    AddPattern('Salvage', '33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC76', -0xA, 'Func')
    AddPattern('SalvageGlobal', '8B4A04538945F48B4208', 0x1, 'Ptr')
    ; Agent patterns
    AddPattern('AgentBase', 'FF501083C6043BF775E2', -0x3, 'Ptr')
    AddPattern('ChangeTarget', '3BDF0F95', -0x86, 'Func')
    AddPattern('CurrentTarget', '83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55', -0xE, 'Ptr')
    AddPattern('MyID', '83EC08568BF13B15', -0x3, 'Ptr')
    ; Map patterns
    AddPattern('Move', '558BEC83EC208D45F0', 0x1, 'Func')
    AddPattern('ClickCoords', '8B451C85C0741CD945F8', 0xD, 'Ptr')
    AddPattern('InstanceInfo', '6A2C50E80000000083C408C7', 0xE, 'Ptr')
    AddPattern('AreaInfo', '6BC67C5E05', 0x6, 'Ptr')
    AddPattern('WorldConst', '8D0476C1E00405', 0x8, 'Ptr')
    AddPattern('Region', '6A548D46248908', -0x3, 'Ptr')

    Local $aScanResults = ScanAllPatterns()

    ;Core
    $mBasePointer = MemoryRead(GetScanResult('BasePointer', $aScanResults))
    SetValue('BasePointer', Ptr($mBasePointer))
    $mPacketLocation = MemoryRead(GetScanResult('PacketLocation', $aScanResults))
    SetValue('PacketLocation', Ptr($mPacketLocation))
    $mPing = MemoryRead(GetScanResult('Ping', $aScanResults))
	SetValue('Ping', $mPing)
    $mPreGame = MemoryRead(GetScanResult('PreGame', $aScanResults) + 0x35)
	SetValue('PreGame', $mPreGame)
    $mFrameArray = MemoryRead(GetScanResult('FrameArray', $aScanResults) - 0x13)
	SetValue('FrameArray', $mFrameArray)

	;Skill
    $g_mSkillBase = MemoryRead(GetScanResult('SkillBase', $aScanResults))
    SetValue('SkillBase', Ptr($g_mSkillBase))
    $g_mSkillTimer = MemoryRead(GetScanResult('SkillTimer', $aScanResults))
    SetValue('SkillTimer', Ptr($g_mSkillTimer))
    SetValue('UseSkill', Ptr(GetScanResult('UseSkill', $aScanResults)))
    SetValue('UseHeroSkill', Ptr(GetScanResult('UseHeroSkill', $aScanResults)))

	;Friend
	$g_mFriendList = GetScanResult('FriendList', $aScanResults)
	$g_mFriendList = MemoryRead(FindInRange("57B9", "xx", 2, $g_mFriendList, $g_mFriendList + 0xFF))
    SetValue('FriendList', Ptr($g_mFriendList))
	SetValue('PlayerStatus', Ptr(GetScanResult("PlayerStatus", $aScanResults)))
    SetValue('AddFriend', Ptr(GetScanResult("AddFriend", $aScanResults)))
	Local $lAddFriendScan = GetScanResult("RemoveFriend", $aScanResults)
	$lAddFriendScan = FindInRange("50E8", "xx", 1, $lAddFriendScan, $lAddFriendScan + 0x32)
	$lAddFriendScan = FunctionFromNearCall($lAddFriendScan)
	SetValue('RemoveFriend', Ptr($lAddFriendScan))

	;Attributes
    $g_mAttributeInfo = MemoryRead(GetScanResult('AttributeInfo', $aScanResults))
    SetValue('AttributeInfo', Ptr($g_mAttributeInfo))
    SetValue('IncreaseAttribute', Ptr(GetScanResult('IncreaseAttribute', $aScanResults)))
    SetValue('DecreaseAttribute', Ptr(GetScanResult('DecreaseAttribute', $aScanResults)))

	;Trade
	$g_mBuyItemBase = MemoryRead(GetScanResult('BuyItemBase', $aScanResults))
    SetValue('BuyItemBase', Ptr($g_mBuyItemBase))
    $g_mSalvageGlobal = MemoryRead(GetScanResult('SalvageGlobal', $aScanResults) - 0x4)
    SetValue('SalvageGlobal', Ptr($g_mSalvageGlobal))
    SetValue('SellItem', Ptr(GetScanResult('SellItem', $aScanResults)))
    SetValue('Transaction', Ptr(GetScanResult('Transaction', $aScanResults)))
    SetValue('RequestQuote', Ptr(GetScanResult('RequestQuote', $aScanResults)))
    SetValue('Trader', Ptr(GetScanResult('Trader', $aScanResults)))
    SetValue('Salvage', Ptr(GetScanResult('Salvage', $aScanResults)))

	;Agent
	$g_mAgentBase = MemoryRead(GetScanResult('AgentBase', $aScanResults))
    SetValue('AgentBase', Ptr($g_mAgentBase))
    $g_mMaxAgents = $g_mAgentBase + 0x8
    SetValue('MaxAgents', Ptr($g_mMaxAgents))
    $g_mMyID = MemoryRead(GetScanResult('MyID', $aScanResults))
    SetValue('MyID', Ptr($g_mMyID))
    $g_mCurrentTarget = MemoryRead(GetScanResult('CurrentTarget', $aScanResults))
    SetValue('ChangeTarget', Ptr(GetScanResult('ChangeTarget', $aScanResults) + 1))

	;Map
	$g_mInstanceInfo = MemoryRead(GetScanResult('InstanceInfo', $aScanResults))
	SetValue('InstanceInfo', Ptr($g_mInstanceInfo))
    $g_mAreaInfo = MemoryRead(GetScanResult('AreaInfo', $aScanResults))
	SetValue('AreaInfo', Ptr($g_mAreaInfo))
    $g_mWorldConst = MemoryRead(GetScanResult('WorldConst', $aScanResults))
	SetValue('WorldConst', Ptr($g_mWorldConst))
    $g_mClickCoordsX = MemoryRead(GetScanResult('ClickCoords', $aScanResults))
	SetValue('ClickCoords', Ptr($g_mClickCoordsX))
    $g_mClickCoordsY = MemoryRead(GetScanResult('ClickCoords', $aScanResults) + 9)
	SetValue('ClickCoords', Ptr($g_mClickCoordsY))
    $g_mRegion = MemoryRead(GetScanResult('Region', $aScanResults))
	SetValue('Region', Ptr($g_mRegion))
    SetValue('Move', Ptr(GetScanResult('Move', $aScanResults)))

    ; Setup addresses for hooks
    Local $lTemp = GetScanResult('Engine', $aScanResults, 'Hook')
    SetValue('MainStart', Ptr($lTemp))
    SetValue('MainReturn', Ptr($lTemp + 0x5))

    $lTemp = GetScanResult('Render', $aScanResults, 'Hook')
    SetValue('RenderingMod', Ptr($lTemp))
    SetValue('RenderingModReturn', Ptr($lTemp + 0xA))

    $lTemp = GetScanResult('Trader', $aScanResults, 'Hook')
    SetValue('TraderStart', Ptr($lTemp))
    SetValue('TraderReturn', Ptr($lTemp + 0x5))

    SetValue('PacketSend', Ptr(GetScanResult('PacketSend', $aScanResults)))
    SetValue('ActionBase', Ptr(MemoryRead(GetScanResult('ActionBase', $aScanResults))))
    SetValue('Action', Ptr(GetScanResult('Action', $aScanResults)))

    SetValue('QueueSize', '0x00000010')
    SetValue('CallbackEvent', '0x00000501')

    ; Modify memory
    ModifyMemory()

    $mQueueCounter = MemoryRead(GetValue('QueueCounter'))
    $mQueueSize = GetValue('QueueSize') - 1
    $mQueueBase = GetValue('QueueBase')
    $mDisableRendering = GetValue('DisableRendering')

    ; Setup event system
    If $mUseEventSystem Then
        $mGUI = GUICreate('GwAu3')
        RegisterCallbackHandler()
        MemoryWrite(GetValue('CallbackHandle'), $mGUI)
    EndIf

    ; Setup command structures
    DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
    DllStructSetData($mInviteGuild, 2, 0x4C)
    DllStructSetData($mPacket, 1, GetValue('CommandPacketSend'))
    DllStructSetData($mAction, 1, GetValue('CommandAction'))
    DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
    DllStructSetData($mSendChat, 2, 0x0063)
	;Skill
	DllStructSetData($g_mUseSkill, 1, GetValue('CommandUseSkill'))
    DllStructSetData($g_mUseHeroSkill, 1, GetValue('CommandUseHeroSkill'))
	;Friend
	DllStructSetData($g_mChangeStatus, 1, GetValue('CommandPlayerStatus'))
    DllStructSetData($g_mAddFriend, 1, GetValue('CommandAddFriend'))
    DllStructSetData($g_mRemoveFriend, 1, GetValue('CommandRemoveFriend'))
	;Attribute
	DllStructSetData($g_mIncreaseAttribute, 1, GetValue('CommandIncreaseAttribute'))
    DllStructSetData($g_mDecreaseAttribute, 1, GetValue('CommandDecreaseAttribute'))
	;Trade
	DllStructSetData($g_mSellItem, 1, GetValue('CommandSellItem'))
    DllStructSetData($g_mBuyItem, 1, GetValue('CommandBuyItem'))
    DllStructSetData($g_mCraftItemEx, 1, GetValue('CommandCraftItemEx'))
    DllStructSetData($g_mRequestQuote, 1, GetValue('CommandRequestQuote'))
    DllStructSetData($g_mRequestQuoteSell, 1, GetValue('CommandRequestQuoteSell'))
    DllStructSetData($g_mTraderBuy, 1, GetValue('CommandTraderBuy'))
    DllStructSetData($g_mTraderSell, 1, GetValue('CommandTraderSell'))
    DllStructSetData($g_mSalvage, 1, GetValue('CommandSalvage'))
	;Agent
	DllStructSetData($g_mChangeTarget, 1, GetValue('CommandChangeTarget'))
    DllStructSetData($g_mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
	;Map
	DllStructSetData($g_mMove, 1, GetValue('CommandMove'))

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
#EndRegion Initialization

#Region Helper Functions
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
#EndRegion Helper Functions

#Region Simplified Pattern Management
; Add a pattern to the scan list
Func AddPattern($sName, $sPattern, $iOffsetOrMsg = 0, $sType = 'Ptr')
    Local $iIndex = $g_aPatterns[0][0] + 1
    ReDim $g_aPatterns[$iIndex + 1][6]
    $g_aPatterns[0][0] = $iIndex

    ; Build full name with prefix and suffix
    Local $sFullName = 'Scan' & $sName & $sType

    ; Check if it's an assertion pattern
    Local $bIsAssertion = False
    Local $sAssertionMsg = ""

    If StringInStr($sPattern, ":\") Or StringInStr($sPattern, ":/") Then
        ; This is a file path, so it's an assertion
        $bIsAssertion = True
        $sAssertionMsg = $iOffsetOrMsg

        ; Add to assertion list
        Local $iAssertIndex = UBound($g_aAssertionPatterns)
        ReDim $g_aAssertionPatterns[$iAssertIndex + 1][2]
        $g_aAssertionPatterns[$iAssertIndex][0] = $sPattern
        $g_aAssertionPatterns[$iAssertIndex][1] = $sAssertionMsg
    EndIf

    ; Store pattern information
    $g_aPatterns[$iIndex][0] = $sFullName
    $g_aPatterns[$iIndex][1] = $sPattern
    $g_aPatterns[$iIndex][2] = $bIsAssertion ? 0 : $iOffsetOrMsg ; Offset if not assertion
    $g_aPatterns[$iIndex][3] = $sType
    $g_aPatterns[$iIndex][4] = $bIsAssertion
    $g_aPatterns[$iIndex][5] = $sAssertionMsg
EndFunc

; Clear all patterns
Func ClearPatterns()
    ReDim $g_aPatterns[1][6]
    $g_aPatterns[0][0] = 0
    ReDim $g_aAssertionPatterns[0][2]
EndFunc

; Get pattern info by original name
Func GetPatternInfo($sName, $sType = '')
    Local $sSearchName = 'Scan' & $sName & $sType
    For $i = 1 To $g_aPatterns[0][0]
        If $g_aPatterns[$i][0] = $sSearchName Or _
           ($sType = '' And StringInStr($g_aPatterns[$i][0], 'Scan' & $sName)) Then
            Local $aInfo[6]
            For $j = 0 To 5
                $aInfo[$j] = $g_aPatterns[$i][$j]
            Next
            Return $aInfo
        EndIf
    Next
    Return 0
EndFunc

; Scan all patterns and return results
Func ScanAllPatterns()
    Local $lGwBase = ScanForProcess()
    Local $aResults[$g_aPatterns[0][0] + 1]
    $aResults[0] = $g_aPatterns[0][0]

    ; Handle assertion patterns first if any exist
    If UBound($g_aAssertionPatterns) > 0 Then
        Local $assertionPatterns = GetMultipleAssertionPatterns($g_aAssertionPatterns)

        ; Update assertion patterns with actual patterns
        Local $iAssertIdx = 0
        For $i = 1 To $g_aPatterns[0][0]
            If $g_aPatterns[$i][4] Then ; Is assertion
                $g_aPatterns[$i][1] = $assertionPatterns[$iAssertIdx]
                $iAssertIdx += 1
            EndIf
        Next
    EndIf

    ; Create ASM for scanning
    $mASMSize = 0
    $mASMCodeOffset = 0
    $mASMString = ''

    _('MainModPtr/4')

    ; Add all patterns to ASM
    For $i = 1 To $g_aPatterns[0][0]
        _($g_aPatterns[$i][0] & ':')
        AddPatternToASM($g_aPatterns[$i][1])
    Next

    ; Add scan procedure
    _CreateScanProcedure($lGwBase)

    ; Execute scan
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

    ; Collect results using GetScannedAddress which does the proper calculation
    For $i = 1 To $g_aPatterns[0][0]
        $aResults[$i] = GetScannedAddress($g_aPatterns[$i][0], $g_aPatterns[$i][2])
    Next

    Return $aResults
EndFunc

; Get a specific scan result by original name and optional type
Func GetScanResult($sName, $aResults = 0, $sType = '')
    If Not IsArray($aResults) Then Return 0

    ; Build search name
    Local $sSearchName = 'Scan' & $sName & $sType

    For $i = 1 To $g_aPatterns[0][0]
        If $g_aPatterns[$i][0] = $sSearchName Or _
           ($sType = '' And StringInStr($g_aPatterns[$i][0], 'Scan' & $sName)) Then
            Return $aResults[$i]
        EndIf
    Next

    Return 0
EndFunc

; Helper function to add pattern to ASM
Func AddPatternToASM($aPattern)
    Local $lSize = Int(0.5 * StringLen($aPattern))
    Local $pattern_header = "00000000" & _
                           SwapEndian(Hex($lSize, 8)) & _
                           "00000000"

    $mASMString &= $pattern_header & $aPattern
    $mASMSize += $lSize + 12

    Local $padding_count = 68 - $lSize
    For $i = 1 To $padding_count
        $mASMSize += 1
        $mASMString &= "00"
    Next
EndFunc
#EndRegion Simplified Pattern Management
