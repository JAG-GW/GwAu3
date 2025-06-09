#include-once
#include "Core/GwAu3_Constants.au3"
#include "Core/GwAu3_Memory.au3"
#include "Core/GwAu3_Assembler.au3"
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


#Region Initialization
Func Initialize($aGW, $bChangeTitle = True)
    _Log_Info("Initializing...", "GwAu3", $g_h_EditText)

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
    AddPattern('Ping', '568B750889165E', -0x3, 'Ptr')
    AddPattern('PacketSend', 'C747540000000081E6', -0x50, 'Func')
    AddPattern('PacketLocation', '83C40433C08BE55DC3A1', 0xB, 'Ptr')
    AddPattern('Action', '8B7508578BF983FE09750C6876', -0x3, 'Func')
    AddPattern('ActionBase', '8D1C87899DF4', -0x3, 'Ptr')
    AddPattern('PreGame', "P:\Code\Gw\Ui\UiPregame.cpp", "!s_scene", 'Ptr')
    AddPattern('FrameArray', "P:\Code\Engine\Frame\FrMsg.cpp", "frame", 'Ptr')
	; Skill patterns
    AddPattern('SkillBase', '8D04B6C1E00505', 0x8, 'Ptr')
    AddPattern('SkillTimer', 'FFD68B4DF08BD88B4708', -0x3, 'Ptr')
    AddPattern('UseSkill', '85F6745B83FE1174', -0x125, 'Func')
    AddPattern('UseHeroSkill', 'BA02000000B954080000', -0x59, 'Func')
	; Friend patterns
	AddPattern('FriendList', "P:\Code\Gw\Friend\FriendApi.cpp", "friendName && *friendName", 'Ptr')
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
	; hook
	AddPattern('Engine', '568B3085F67478EB038D4900D9460C', -0x22, 'Hook')
    AddPattern('Render', 'F6C401741C68B1010000BA', -0x67, 'Hook')
	AddPattern('HookedTrader', '50516A466A06', -0x2F, 'Hook')


    $aScanResults = ScanAllPatterns()


	Local $lTemp
    ;Core
    $mBasePointer = MemoryRead(GetScanResult('BasePointer', $aScanResults, 'Ptr'))
    SetValue('BasePointer', Ptr($mBasePointer))
    $mPacketLocation = MemoryRead(GetScanResult('PacketLocation', $aScanResults, 'Ptr'))
    SetValue('PacketLocation', Ptr($mPacketLocation))
    $mPing = MemoryRead(GetScanResult('Ping', $aScanResults, 'Ptr'))
	SetValue('Ping', Ptr($mPing))
    $mPreGame = MemoryRead(GetScanResult('PreGame', $aScanResults, 'Ptr') + 0x35)
	SetValue('PreGame', Ptr($mPreGame))
    $mFrameArray = MemoryRead(GetScanResult('FrameArray', $aScanResults, 'Ptr') - 0x13)
	SetValue('FrameArray', Ptr($mFrameArray))
	SetValue('PacketSend', Ptr(GetScanResult('PacketSend', $aScanResults, 'Func')))
    SetValue('ActionBase', Ptr(MemoryRead(GetScanResult('ActionBase', $aScanResults, 'Ptr'))))
    SetValue('Action', Ptr(GetScanResult('Action', $aScanResults, 'Func')))
	;Core log
	_Log_Debug("BasePointer: " & GetValue('BasePointer'), "Initialize", $g_h_EditText)
	_Log_Debug("PacketLocation: " & GetValue('PacketLocation'), "Initialize", $g_h_EditText)
	_Log_Debug("Ping: " & GetValue('Ping'), "Initialize", $g_h_EditText)
	_Log_Debug("PreGame: " & GetValue('PreGame'), "Initialize", $g_h_EditText)
	_Log_Debug("FrameArray: " & GetValue('FrameArray'), "Initialize", $g_h_EditText)
	_Log_Debug("PacketSend: " & GetValue('PacketSend'), "Initialize", $g_h_EditText)
	_Log_Debug("ActionBase: " & GetValue('ActionBase'), "Initialize", $g_h_EditText)
	_Log_Debug("Action: " & GetValue('Action'), "Initialize", $g_h_EditText)

	;Skill
    $g_mSkillBase = MemoryRead(GetScanResult('SkillBase', $aScanResults, 'Ptr'))
    SetValue('SkillBase', Ptr($g_mSkillBase))
    $g_mSkillTimer = MemoryRead(GetScanResult('SkillTimer', $aScanResults, 'Ptr'))
    SetValue('SkillTimer', Ptr($g_mSkillTimer))
    SetValue('UseSkill', Ptr(GetScanResult('UseSkill', $aScanResults, 'Func')))
    SetValue('UseHeroSkill', Ptr(GetScanResult('UseHeroSkill', $aScanResults, 'Func')))
	;Skill log
	_Log_Debug("SkillBase: " & GetValue('SkillBase'), "Initialize", $g_h_EditText)
	_Log_Debug("SkillTimer: " & GetValue('SkillTimer'), "Initialize", $g_h_EditText)
	_Log_Debug("UseSkill: " & GetValue('UseSkill'), "Initialize", $g_h_EditText)
	_Log_Debug("UseHeroSkill: " & GetValue('UseHeroSkill'), "Initialize", $g_h_EditText)

	;Friend
	$g_mFriendList = GetScanResult('FriendList', $aScanResults, 'Ptr')
	$g_mFriendList = MemoryRead(FindInRange("57B9", "xx", 2, $g_mFriendList, $g_mFriendList + 0xFF))
    SetValue('FriendList', Ptr($g_mFriendList))
	SetValue('PlayerStatus', Ptr(GetScanResult("PlayerStatus", $aScanResults, 'Func')))
    SetValue('AddFriend', Ptr(GetScanResult("AddFriend", $aScanResults, 'Func')))
	$lTemp = GetScanResult("RemoveFriend", $aScanResults, 'Func')
	$lTemp = FindInRange("50E8", "xx", 1, $lTemp, $lTemp + 0x32)
	$lTemp = FunctionFromNearCall($lTemp)
	SetValue('RemoveFriend', Ptr($lTemp))
	;Friend log
	_Log_Debug("FriendList: " & GetValue('FriendList'), "Initialize", $g_h_EditText)
	_Log_Debug("PlayerStatus: " & GetValue('PlayerStatus'), "Initialize", $g_h_EditText)
	_Log_Debug("AddFriend: " & GetValue('AddFriend'), "Initialize", $g_h_EditText)
	_Log_Debug("RemoveFriend: " & GetValue('RemoveFriend'), "Initialize", $g_h_EditText)

	;Attributes
    $g_mAttributeInfo = MemoryRead(GetScanResult('AttributeInfo', $aScanResults, 'Ptr'))
    SetValue('AttributeInfo', Ptr($g_mAttributeInfo))
    SetValue('IncreaseAttribute', Ptr(GetScanResult('IncreaseAttribute', $aScanResults, 'Func')))
    SetValue('DecreaseAttribute', Ptr(GetScanResult('DecreaseAttribute', $aScanResults, 'Func')))
	;Attributes log
	_Log_Debug("AttributeInfo: " & GetValue('AttributeInfo'), "Initialize", $g_h_EditText)
	_Log_Debug("IncreaseAttribute: " & GetValue('IncreaseAttribute'), "Initialize", $g_h_EditText)
	_Log_Debug("DecreaseAttribute: " & GetValue('DecreaseAttribute'), "Initialize", $g_h_EditText)

	;Trade
	$g_mBuyItemBase = MemoryRead(GetScanResult('BuyItemBase', $aScanResults, 'Ptr'))
    SetValue('BuyItemBase', Ptr($g_mBuyItemBase))
    $g_mSalvageGlobal = MemoryRead(GetScanResult('SalvageGlobal', $aScanResults, 'Ptr') - 0x4)
    SetValue('SalvageGlobal', Ptr($g_mSalvageGlobal))
    SetValue('SellItem', Ptr(GetScanResult('SellItem', $aScanResults, 'Func')))
    SetValue('Transaction', Ptr(GetScanResult('Transaction', $aScanResults, 'Func')))
    SetValue('RequestQuote', Ptr(GetScanResult('RequestQuote', $aScanResults, 'Func')))
    SetValue('Trader', Ptr(GetScanResult('Trader', $aScanResults, 'Func')))
    SetValue('Salvage', Ptr(GetScanResult('Salvage', $aScanResults, 'Func')))
	;Trade log
	_Log_Debug("BuyItemBase: " & GetValue('BuyItemBase'), "Initialize", $g_h_EditText)
	_Log_Debug("SalvageGlobal: " & GetValue('SalvageGlobal'), "Initialize", $g_h_EditText)
	_Log_Debug("SellItem: " & GetValue('SellItem'), "Initialize", $g_h_EditText)
	_Log_Debug("Transaction: " & GetValue('Transaction'), "Initialize", $g_h_EditText)
	_Log_Debug("RequestQuote: " & GetValue('RequestQuote'), "Initialize", $g_h_EditText)
	_Log_Debug("Trader: " & GetValue('Trader'), "Initialize", $g_h_EditText)
	_Log_Debug("Salvage: " & GetValue('Salvage'), "Initialize", $g_h_EditText)

	;Agent
	$g_mAgentBase = MemoryRead(GetScanResult('AgentBase', $aScanResults, 'Ptr'))
    SetValue('AgentBase', Ptr($g_mAgentBase))
    $g_mMaxAgents = $g_mAgentBase + 0x8
    SetValue('MaxAgents', Ptr($g_mMaxAgents))
    $g_mMyID = MemoryRead(GetScanResult('MyID', $aScanResults, 'Ptr'))
    SetValue('MyID', Ptr($g_mMyID))
    $g_mCurrentTarget = MemoryRead(GetScanResult('CurrentTarget', $aScanResults, 'Ptr'))
    SetValue('ChangeTarget', Ptr(GetScanResult('ChangeTarget', $aScanResults, 'Func') + 1))
	;Agent log
	_Log_Debug("AgentBase: " & GetValue('AgentBase'), "Initialize", $g_h_EditText)
	_Log_Debug("MaxAgents: " & GetValue('MaxAgents'), "Initialize", $g_h_EditText)
	_Log_Debug("MyID: " & GetValue('MyID'), "Initialize", $g_h_EditText)
	_Log_Debug("ChangeTarget: " & GetValue('ChangeTarget'), "Initialize", $g_h_EditText)

	;Map
	$g_mInstanceInfo = MemoryRead(GetScanResult('InstanceInfo', $aScanResults, 'Ptr'))
	SetValue('InstanceInfo', Ptr($g_mInstanceInfo))
    $g_mAreaInfo = MemoryRead(GetScanResult('AreaInfo', $aScanResults, 'Ptr'))
	SetValue('AreaInfo', Ptr($g_mAreaInfo))
    $g_mWorldConst = MemoryRead(GetScanResult('WorldConst', $aScanResults, 'Ptr'))
	SetValue('WorldConst', Ptr($g_mWorldConst))
    $g_mClickCoordsX = MemoryRead(GetScanResult('ClickCoords', $aScanResults, 'Ptr'))
	SetValue('ClickCoords', Ptr($g_mClickCoordsX))
    $g_mClickCoordsY = MemoryRead(GetScanResult('ClickCoords', $aScanResults, 'Ptr') + 9)
	SetValue('ClickCoords', Ptr($g_mClickCoordsY))
    $g_mRegion = MemoryRead(GetScanResult('Region', $aScanResults, 'Ptr'))
	SetValue('Region', Ptr($g_mRegion))
    SetValue('Move', Ptr(GetScanResult('Move', $aScanResults, 'Func')))
	;Map log
	_Log_Debug("InstanceInfo: " & GetValue('InstanceInfo'), "Initialize", $g_h_EditText)
	_Log_Debug("AreaInfo: " & GetValue('AreaInfo'), "Initialize", $g_h_EditText)
	_Log_Debug("WorldConst: " & GetValue('WorldConst'), "Initialize", $g_h_EditText)
	_Log_Debug("ClickCoords: " & GetValue('ClickCoords'), "Initialize", $g_h_EditText)
	_Log_Debug("Region: " & GetValue('Region'), "Initialize", $g_h_EditText)
	_Log_Debug("Move: " & GetValue('Move'), "Initialize", $g_h_EditText)

    ;Hook
    $lTemp = GetScanResult('Engine', $aScanResults, 'Hook')
    SetValue('MainStart', Ptr($lTemp))
    SetValue('MainReturn', Ptr($lTemp + 0x5))
    $lTemp = GetScanResult('Render', $aScanResults, 'Hook')
    SetValue('RenderingMod', Ptr($lTemp))
    SetValue('RenderingModReturn', Ptr($lTemp + 0xA))
    $lTemp = GetScanResult('HookedTrader', $aScanResults, 'Hook')
    SetValue('TraderStart', Ptr($lTemp))
    SetValue('TraderReturn', Ptr($lTemp + 0x5))
	;Hook log
	_Log_Debug("MainStart: " & GetValue('MainStart'), "Initialize", $g_h_EditText)
	_Log_Debug("MainReturn: " & GetValue('MainReturn'), "Initialize", $g_h_EditText)
	_Log_Debug("RenderingMod: " & GetValue('RenderingMod'), "Initialize", $g_h_EditText)
	_Log_Debug("RenderingModReturn: " & GetValue('RenderingModReturn'), "Initialize", $g_h_EditText)
	_Log_Debug("TraderStart: " & GetValue('TraderStart'), "Initialize", $g_h_EditText)
	_Log_Debug("TraderReturn: " & GetValue('TraderReturn'), "Initialize", $g_h_EditText)


	SetValue('QueueSize', '0x00000010')


    ; Modify memory
    ModifyMemory()


	$g_mAgentCopyCount = GetValue('AgentCopyCount')
    $g_mAgentCopyBase = GetValue('AgentCopyBase')
    $g_mTraderQuoteID = GetValue('TraderQuoteID')
    $g_mTraderCostID = GetValue('TraderCostID')
    $g_mTraderCostValue = GetValue('TraderCostValue')
	$mQueueCounter = MemoryRead(GetValue('QueueCounter'))
    $mQueueSize = GetValue('QueueSize') - 1
    $mQueueBase = GetValue('QueueBase')
    $mDisableRendering = GetValue('DisableRendering')


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

    If $bChangeTitle Then WinSetTitle($mGWWindowHandle, '', 'Guild Wars - ' & GetCharname())

    _Log_Info("End of Initialization.", "GwAu3", $g_h_EditText)
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

	$aPattern = StringReplace($aPattern, "??", "00")

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
