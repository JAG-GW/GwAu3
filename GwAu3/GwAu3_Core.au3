#include-once
#include "Core/GwAu3_Constants.au3"
#include "Core/GwAu3_Memory.au3"
#include "Core/GwAu3_Assembler.au3"
#include "Core/GwAu3_Utils.au3"
#include "Core/GwAu3_LogMessages.au3"
#include "Core/GwAu3_Scanner.au3"

#include "Modules/Agents/AgentMod_Data.au3"
#include "Modules/Agents/AgentMod_Commands.au3"
#include "Modules/Attributes/AttributeMod_Data.au3"
#include "Modules/Attributes/AttributeMod_Commands.au3"
#include "Modules/Friends/FriendMod_Data.au3"
#include "Modules/Friends/FriendMod_Commands.au3"
#include "Modules/Guilds/GuildMod_Data.au3"
#include "Modules/Guilds/GuildMod_Commands.au3"
#include "Modules/Items/ItemMod_Data.au3"
#include "Modules/Items/ItemMod_Commands.au3"
#include "Modules/Maps/MapMod_Data.au3"
#include "Modules/Maps/MapMod_Commands.au3"
#include "Modules/Matchs/MatchMod_Commands.au3"
#include "Modules/Matchs/MatchMod_Data.au3"
#include "Modules/Others/OtherMod_Commands.au3"
#include "Modules/Others/OtherMod_Data.au3"
#include "Modules/Party/PartyMod_Commands.au3"
#include "Modules/Party/PartyMod_Data.au3"
#include "Modules/Quests/QuestMod_Commands.au3"
#include "Modules/Quests/QuestMod_Data.au3"
#include "Modules/Skills/SkillMod_Data.au3"
#include "Modules/Skills/SkillMod_Commands.au3"
#include "Modules/Titles/TitleMod_Commands.au3"
#include "Modules/Titles/TitleMod_Data.au3"
#include "Modules/Trades/TradeMod_Data.au3"
#include "Modules/Trades/TradeMod_Commands.au3"
#include "Modules/Ui/UiMod_Commands.au3"
#include "Modules/Ui/UiMod_Data.au3"


If @AutoItX64 Then
    MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
    Exit
EndIf


#Region Initialization
Func GwAu3_Core_Initialize($aGW, $bChangeTitle = True)
    GwAu3_Log_Info("Initializing...", "GwAu3", $g_h_EditText)

    ; Open process
    If IsString($aGW) Then
        Local $lProcessList = ProcessList("gw.exe")
        For $i = 1 To $lProcessList[0][0]
            $mGWProcessId = $lProcessList[$i][1]
            $mGWWindowHandle = GwAu3_Scanner_GetHwnd($mGWProcessId)
            GwAu3_Memory_Open($mGWProcessId)
            If $mGWProcHandle Then
                If StringRegExp(GwAu3_Scanner_ScanForCharname(), $aGW) = 1 Then
                    ExitLoop
                EndIf
            EndIf
            GwAu3_Memory_Close()
            $mGWProcHandle = 0
        Next
    Else
        $mGWProcessId = $aGW
        $mGWWindowHandle = GwAu3_Scanner_GetHwnd($mGWProcessId)
        GwAu3_Memory_Open($aGW)
        GwAu3_Scanner_ScanForCharname()
    EndIf

	GwAu3_Scanner_ClearPatterns()
    ; Core patterns
    GwAu3_Scanner_AddPattern('BasePointer', '506A0F6A00FF35', 0x8, 'Ptr')
    GwAu3_Scanner_AddPattern('Ping', '568B750889165E', -0x3, 'Ptr')
    GwAu3_Scanner_AddPattern('PacketSend', 'C747540000000081E6', -0x50, 'Func')
    GwAu3_Scanner_AddPattern('PacketLocation', '83C40433C08BE55DC3A1', 0xB, 'Ptr')
    GwAu3_Scanner_AddPattern('Action', '8B7508578BF983FE09750C6876', -0x3, 'Func')
    GwAu3_Scanner_AddPattern('ActionBase', '8D1C87899DF4', -0x3, 'Ptr')
	GwAu3_Scanner_AddPattern('Environment', '6BC67C5E05', 0x6, 'Ptr')
    GwAu3_Scanner_AddPattern('PreGame', "P:\Code\Gw\Ui\UiPregame.cpp", "!s_scene", 'Ptr')
    GwAu3_Scanner_AddPattern('FrameArray', "P:\Code\Engine\Frame\FrMsg.cpp", "frame", 'Ptr')
	; Skill patterns
    GwAu3_Scanner_AddPattern('SkillBase', '8D04B6C1E00505', 0x8, 'Ptr')
    GwAu3_Scanner_AddPattern('SkillTimer', 'FFD68B4DF08BD88B4708', -0x3, 'Ptr')
    GwAu3_Scanner_AddPattern('UseSkill', '85F6745B83FE1174', -0x125, 'Func')
    GwAu3_Scanner_AddPattern('UseHeroSkill', 'BA02000000B954080000', -0x59, 'Func')
	; Friend patterns
	GwAu3_Scanner_AddPattern('FriendList', "P:\Code\Gw\Friend\FriendApi.cpp", "friendName && *friendName", 'Ptr')
    GwAu3_Scanner_AddPattern('PlayerStatus', '83FE037740FF24B50000000033C0', -0x25, 'Func')
    GwAu3_Scanner_AddPattern('AddFriend', '8B751083FE037465', -0x47, 'Func')
    GwAu3_Scanner_AddPattern('RemoveFriend', '83F803741D83F8047418', 0x0, 'Func')
    ; Attribute patterns
    GwAu3_Scanner_AddPattern('AttributeInfo', 'BA3300000089088d4004', -0x3, 'Ptr')
    GwAu3_Scanner_AddPattern('IncreaseAttribute', '8B7D088B702C8B1F3B9E00050000', -0x5A, 'Func')
    GwAu3_Scanner_AddPattern('DecreaseAttribute', '8B8AA800000089480C5DC3CC', 0x19, 'Func')
    ; Trade patterns
    GwAu3_Scanner_AddPattern('SellItem', '8B4D2085C90F858E', -0x55, 'Func')
    GwAu3_Scanner_AddPattern('Transaction', '85FF741D8B4D14EB08', -0x7E, 'Func')
    GwAu3_Scanner_AddPattern('BuyItemBase', 'D9EED9580CC74004', 0xF, 'Ptr')
    GwAu3_Scanner_AddPattern('RequestQuote', '8B752083FE107614', -0x34, 'Func')
    GwAu3_Scanner_AddPattern('Trader', '83FF10761468D2210000', -0x1E, 'Func')
    GwAu3_Scanner_AddPattern('Salvage','33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC76', -0xA, 'Func')
    GwAu3_Scanner_AddPattern('SalvageGlobal', '8B4A04538945F48B4208', 0x1, 'Ptr')
    ; Agent patterns
    GwAu3_Scanner_AddPattern('AgentBase', 'FF501083C6043BF775E2', -0x3, 'Ptr')
    GwAu3_Scanner_AddPattern('ChangeTarget', '3BDF0F95', -0x86, 'Func')
    GwAu3_Scanner_AddPattern('CurrentTarget', '83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55', -0xE, 'Ptr')
    GwAu3_Scanner_AddPattern('MyID', '83EC08568BF13B15', -0x3, 'Ptr')
    ; Map patterns
    GwAu3_Scanner_AddPattern('Move', '558BEC83EC208D45F0', 0x1, 'Func')
    GwAu3_Scanner_AddPattern('ClickCoords', '8B451C85C0741CD945F8', 0xD, 'Ptr')
    GwAu3_Scanner_AddPattern('InstanceInfo', '6A2C50E80000000083C408C7', 0xE, 'Ptr')
    GwAu3_Scanner_AddPattern('WorldConst', '8D0476C1E00405', 0x8, 'Ptr')
    GwAu3_Scanner_AddPattern('Region', '6A548D46248908', -0x3, 'Ptr')
	; hook
	GwAu3_Scanner_AddPattern('Engine', '568B3085F67478EB038D4900D9460C', -0x22, 'Hook')
    GwAu3_Scanner_AddPattern('Render', 'F6C401741C68B1010000BA', -0x67, 'Hook')
	GwAu3_Scanner_AddPattern('HookedTrader', '50516A466A06', -0x2F, 'Hook')


    $aScanResults = GwAu3_Scanner_ScanAllPatterns()


	Local $lTemp
    ;Core
    $mBasePointer = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('BasePointer', $aScanResults, 'Ptr'))
    $mPacketLocation = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('PacketLocation', $aScanResults, 'Ptr'))
    $mPing = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('Ping', $aScanResults, 'Ptr'))
    $mPreGame = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('PreGame', $aScanResults, 'Ptr') + 0x35)
    $mFrameArray = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('FrameArray', $aScanResults, 'Ptr') - 0x13)
	GwAu3_Memory_SetValue('BasePointer', Ptr($mBasePointer))
	GwAu3_Memory_SetValue('PacketLocation', Ptr($mPacketLocation))
	GwAu3_Memory_SetValue('Ping', Ptr($mPing))
	GwAu3_Memory_SetValue('PreGame', Ptr($mPreGame))
	GwAu3_Memory_SetValue('FrameArray', Ptr($mFrameArray))
	GwAu3_Memory_SetValue('PacketSend', Ptr(GwAu3_Scanner_GetScanResult('PacketSend', $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('ActionBase', Ptr(GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('ActionBase', $aScanResults, 'Ptr'))))
    GwAu3_Memory_SetValue('Action', Ptr(GwAu3_Scanner_GetScanResult('Action', $aScanResults, 'Func')))
	GwAu3_Memory_SetValue('Environment', Ptr(GwAu3_Memory_GetScannedAddress('ScanEnvironmentPtr', 0x6)))
	;Core log
	GwAu3_Log_Debug("BasePointer: " & GwAu3_Memory_GetValue('BasePointer'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("PacketLocation: " & GwAu3_Memory_GetValue('PacketLocation'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Ping: " & GwAu3_Memory_GetValue('Ping'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("PreGame: " & GwAu3_Memory_GetValue('PreGame'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("FrameArray: " & GwAu3_Memory_GetValue('FrameArray'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("PacketSend: " & GwAu3_Memory_GetValue('PacketSend'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("ActionBase: " & GwAu3_Memory_GetValue('ActionBase'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Action: " & GwAu3_Memory_GetValue('Action'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Environment: " & GwAu3_Memory_GetValue('Environment'), "Initialize", $g_h_EditText)

	;Skill
    $g_mSkillBase = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('SkillBase', $aScanResults, 'Ptr'))
    $g_mSkillTimer = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('SkillTimer', $aScanResults, 'Ptr'))
	GwAu3_Memory_SetValue('SkillBase', Ptr($g_mSkillBase))
    GwAu3_Memory_SetValue('SkillTimer', Ptr($g_mSkillTimer))
    GwAu3_Memory_SetValue('UseSkill', Ptr(GwAu3_Scanner_GetScanResult('UseSkill', $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('UseHeroSkill', Ptr(GwAu3_Scanner_GetScanResult('UseHeroSkill', $aScanResults, 'Func')))
	;Skill log
	GwAu3_Log_Debug("SkillBase: " & GwAu3_Memory_GetValue('SkillBase'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("SkillTimer: " & GwAu3_Memory_GetValue('SkillTimer'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("UseSkill: " & GwAu3_Memory_GetValue('UseSkill'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("UseHeroSkill: " & GwAu3_Memory_GetValue('UseHeroSkill'), "Initialize", $g_h_EditText)

	;Friend
	$g_mFriendList = GwAu3_Scanner_GetScanResult('FriendList', $aScanResults, 'Ptr')
	$g_mFriendList = GwAu3_Memory_Read(GwAu3_Scanner_FindInRange("57B9", "xx", 2, $g_mFriendList, $g_mFriendList + 0xFF))
	$lTemp = GwAu3_Scanner_GetScanResult("RemoveFriend", $aScanResults, 'Func')
	$lTemp = GwAu3_Scanner_FindInRange("50E8", "xx", 1, $lTemp, $lTemp + 0x32)
	$lTemp = GwAu3_Scanner_FunctionFromNearCall($lTemp)
    GwAu3_Memory_SetValue('FriendList', Ptr($g_mFriendList))
	GwAu3_Memory_SetValue('PlayerStatus', Ptr(GwAu3_Scanner_GetScanResult("PlayerStatus", $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('AddFriend', Ptr(GwAu3_Scanner_GetScanResult("AddFriend", $aScanResults, 'Func')))
	GwAu3_Memory_SetValue('RemoveFriend', Ptr($lTemp))
	;Friend log
	GwAu3_Log_Debug("FriendList: " & GwAu3_Memory_GetValue('FriendList'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("PlayerStatus: " & GwAu3_Memory_GetValue('PlayerStatus'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("AddFriend: " & GwAu3_Memory_GetValue('AddFriend'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("RemoveFriend: " & GwAu3_Memory_GetValue('RemoveFriend'), "Initialize", $g_h_EditText)

	;Attributes
    $g_mAttributeInfo = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('AttributeInfo', $aScanResults, 'Ptr'))
    GwAu3_Memory_SetValue('AttributeInfo', Ptr($g_mAttributeInfo))
    GwAu3_Memory_SetValue('IncreaseAttribute', Ptr(GwAu3_Scanner_GetScanResult('IncreaseAttribute', $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('DecreaseAttribute', Ptr(GwAu3_Scanner_GetScanResult('DecreaseAttribute', $aScanResults, 'Func')))
	;Attributes log
	GwAu3_Log_Debug("AttributeInfo: " & GwAu3_Memory_GetValue('AttributeInfo'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("IncreaseAttribute: " & GwAu3_Memory_GetValue('IncreaseAttribute'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("DecreaseAttribute: " & GwAu3_Memory_GetValue('DecreaseAttribute'), "Initialize", $g_h_EditText)

	;Trade
	$g_mBuyItemBase = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('BuyItemBase', $aScanResults, 'Ptr'))
    $g_mSalvageGlobal = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('SalvageGlobal', $aScanResults, 'Ptr') - 0x4)
	GwAu3_Memory_SetValue('BuyItemBase', Ptr($g_mBuyItemBase))
    GwAu3_Memory_SetValue('SalvageGlobal', Ptr($g_mSalvageGlobal))
    GwAu3_Memory_SetValue('SellItem', Ptr(GwAu3_Scanner_GetScanResult('SellItem', $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('Transaction', Ptr(GwAu3_Scanner_GetScanResult('Transaction', $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('RequestQuote', Ptr(GwAu3_Scanner_GetScanResult('RequestQuote', $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('Trader', Ptr(GwAu3_Scanner_GetScanResult('Trader', $aScanResults, 'Func')))
    GwAu3_Memory_SetValue('Salvage', Ptr(GwAu3_Scanner_GetScanResult('Salvage', $aScanResults, 'Func')))
	;Trade log
	GwAu3_Log_Debug("BuyItemBase: " & GwAu3_Memory_GetValue('BuyItemBase'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("SalvageGlobal: " & GwAu3_Memory_GetValue('SalvageGlobal'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("SellItem: " & GwAu3_Memory_GetValue('SellItem'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Transaction: " & GwAu3_Memory_GetValue('Transaction'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("RequestQuote: " & GwAu3_Memory_GetValue('RequestQuote'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Trader: " & GwAu3_Memory_GetValue('Trader'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Salvage: " & GwAu3_Memory_GetValue('Salvage'), "Initialize", $g_h_EditText)

	;Agent
	$g_mAgentBase = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('AgentBase', $aScanResults, 'Ptr'))
    $g_mMaxAgents = $g_mAgentBase + 0x8
    $g_mMyID = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('MyID', $aScanResults, 'Ptr'))
    $g_mCurrentTarget = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('CurrentTarget', $aScanResults, 'Ptr'))
	GwAu3_Memory_SetValue('AgentBase', Ptr($g_mAgentBase))
	GwAu3_Memory_SetValue('MaxAgents', Ptr($g_mMaxAgents))
	GwAu3_Memory_SetValue('MyID', Ptr($g_mMyID))
	GwAu3_Memory_SetValue('CurrentTarget', Ptr($g_mCurrentTarget))
    GwAu3_Memory_SetValue('ChangeTarget', Ptr(GwAu3_Scanner_GetScanResult('ChangeTarget', $aScanResults, 'Func') + 1))
	;Agent log
	GwAu3_Log_Debug("AgentBase: " & GwAu3_Memory_GetValue('AgentBase'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("MaxAgents: " & GwAu3_Memory_GetValue('MaxAgents'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("MyID: " & GwAu3_Memory_GetValue('MyID'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("ChangeTarget: " & GwAu3_Memory_GetValue('ChangeTarget'), "Initialize", $g_h_EditText)

	;Map
	$g_mInstanceInfo = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('InstanceInfo', $aScanResults, 'Ptr'))
	$g_mWorldConst = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('WorldConst', $aScanResults, 'Ptr'))
	$g_mClickCoordsX = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('ClickCoords', $aScanResults, 'Ptr'))
	$g_mClickCoordsY = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('ClickCoords', $aScanResults, 'Ptr') + 9)
	$g_mRegion = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('Region', $aScanResults, 'Ptr'))
	GwAu3_Memory_SetValue('InstanceInfo', Ptr($g_mInstanceInfo))
	GwAu3_Memory_SetValue('WorldConst', Ptr($g_mWorldConst))
	GwAu3_Memory_SetValue('ClickCoords', Ptr($g_mClickCoordsX))
	GwAu3_Memory_SetValue('ClickCoords', Ptr($g_mClickCoordsY))
	GwAu3_Memory_SetValue('Region', Ptr($g_mRegion))
    GwAu3_Memory_SetValue('Move', Ptr(GwAu3_Scanner_GetScanResult('Move', $aScanResults, 'Func')))
	;Map log
	GwAu3_Log_Debug("InstanceInfo: " & GwAu3_Memory_GetValue('InstanceInfo'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("WorldConst: " & GwAu3_Memory_GetValue('WorldConst'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("ClickCoords: " & GwAu3_Memory_GetValue('ClickCoords'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Region: " & GwAu3_Memory_GetValue('Region'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Move: " & GwAu3_Memory_GetValue('Move'), "Initialize", $g_h_EditText)

    ;Hook
    $lTemp = GwAu3_Scanner_GetScanResult('Engine', $aScanResults, 'Hook')
    GwAu3_Memory_SetValue('MainStart', Ptr($lTemp))
    GwAu3_Memory_SetValue('MainReturn', Ptr($lTemp + 0x5))
    $lTemp = GwAu3_Scanner_GetScanResult('Render', $aScanResults, 'Hook')
    GwAu3_Memory_SetValue('RenderingMod', Ptr($lTemp))
    GwAu3_Memory_SetValue('RenderingModReturn', Ptr($lTemp + 0xA))
    $lTemp = GwAu3_Scanner_GetScanResult('HookedTrader', $aScanResults, 'Hook')
    GwAu3_Memory_SetValue('TraderStart', Ptr($lTemp))
    GwAu3_Memory_SetValue('TraderReturn', Ptr($lTemp + 0x5))
	;Hook log
	GwAu3_Log_Debug("MainStart: " & GwAu3_Memory_GetValue('MainStart'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("MainReturn: " & GwAu3_Memory_GetValue('MainReturn'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("RenderingMod: " & GwAu3_Memory_GetValue('RenderingMod'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("RenderingModReturn: " & GwAu3_Memory_GetValue('RenderingModReturn'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("TraderStart: " & GwAu3_Memory_GetValue('TraderStart'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("TraderReturn: " & GwAu3_Memory_GetValue('TraderReturn'), "Initialize", $g_h_EditText)


	GwAu3_Memory_SetValue('QueueSize', '0x00000010')


    ; Modify memory
    GwAu3_Assembler_ModifyMemory()


	$g_mAgentCopyCount = GwAu3_Memory_GetValue('AgentCopyCount')
    $g_mAgentCopyBase = GwAu3_Memory_GetValue('AgentCopyBase')
    $g_mTraderQuoteID = GwAu3_Memory_GetValue('TraderQuoteID')
    $g_mTraderCostID = GwAu3_Memory_GetValue('TraderCostID')
    $g_mTraderCostValue = GwAu3_Memory_GetValue('TraderCostValue')
	$mQueueCounter = GwAu3_Memory_Read(GwAu3_Memory_GetValue('QueueCounter'))
    $mQueueSize = GwAu3_Memory_GetValue('QueueSize') - 1
    $mQueueBase = GwAu3_Memory_GetValue('QueueBase')
    $mDisableRendering = GwAu3_Memory_GetValue('DisableRendering')


    ; Setup command structures
    DllStructSetData($mInviteGuild, 1, GwAu3_Memory_GetValue('CommandPacketSend'))
    DllStructSetData($mInviteGuild, 2, 0x4C)
    DllStructSetData($mPacket, 1, GwAu3_Memory_GetValue('CommandPacketSend'))
    DllStructSetData($mAction, 1, GwAu3_Memory_GetValue('CommandAction'))
    DllStructSetData($mSendChat, 1, GwAu3_Memory_GetValue('CommandSendChat'))
    DllStructSetData($mSendChat, 2, 0x0063)
	;Skill
	DllStructSetData($g_mUseSkill, 1, GwAu3_Memory_GetValue('CommandUseSkill'))
    DllStructSetData($g_mUseHeroSkill, 1, GwAu3_Memory_GetValue('CommandUseHeroSkill'))
	;Friend
	DllStructSetData($g_mChangeStatus, 1, GwAu3_Memory_GetValue('CommandPlayerStatus'))
    DllStructSetData($g_mAddFriend, 1, GwAu3_Memory_GetValue('CommandAddFriend'))
    DllStructSetData($g_mRemoveFriend, 1, GwAu3_Memory_GetValue('CommandRemoveFriend'))
	;Attribute
	DllStructSetData($g_mIncreaseAttribute, 1, GwAu3_Memory_GetValue('CommandIncreaseAttribute'))
    DllStructSetData($g_mDecreaseAttribute, 1, GwAu3_Memory_GetValue('CommandDecreaseAttribute'))
	;Trade
	DllStructSetData($g_mSellItem, 1, GwAu3_Memory_GetValue('CommandSellItem'))
    DllStructSetData($g_mBuyItem, 1, GwAu3_Memory_GetValue('CommandBuyItem'))
    DllStructSetData($g_mCraftItemEx, 1, GwAu3_Memory_GetValue('CommandCraftItemEx'))
    DllStructSetData($g_mRequestQuote, 1, GwAu3_Memory_GetValue('CommandRequestQuote'))
    DllStructSetData($g_mRequestQuoteSell, 1, GwAu3_Memory_GetValue('CommandRequestQuoteSell'))
    DllStructSetData($g_mTraderBuy, 1, GwAu3_Memory_GetValue('CommandTraderBuy'))
    DllStructSetData($g_mTraderSell, 1, GwAu3_Memory_GetValue('CommandTraderSell'))
    DllStructSetData($g_mSalvage, 1, GwAu3_Memory_GetValue('CommandSalvage'))
	;Agent
	DllStructSetData($g_mChangeTarget, 1, GwAu3_Memory_GetValue('CommandChangeTarget'))
    DllStructSetData($g_mMakeAgentArray, 1, GwAu3_Memory_GetValue('CommandMakeAgentArray'))
	;Map
	DllStructSetData($g_mMove, 1, GwAu3_Memory_GetValue('CommandMove'))

    If $bChangeTitle Then WinSetTitle($mGWWindowHandle, '', 'Guild Wars - ' & GwAu3_OtherMod_GetCharname())

    GwAu3_Log_Info("End of Initialization.", "GwAu3", $g_h_EditText)
    Return $mGWWindowHandle
EndFunc
#EndRegion Initialization

Func GwAu3_Core_Enqueue($aPtr, $aSize)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', 256 * $mQueueCounter + $mQueueBase, 'ptr', $aPtr, 'int', $aSize, 'int', '')
	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf
EndFunc

Func GwAu3_Core_PerformAction($aAction, $aFlag)
	DllStructSetData($mAction, 2, $aAction)
	DllStructSetData($mAction, 3, $aFlag)
	GwAu3_Core_Enqueue($mActionPtr, 12)
EndFunc

Func GwAu3_Core_SendPacket($aSize, $aHeader, $aParam1 = 0, $aParam2 = 0, $aParam3 = 0, $aParam4 = 0, $aParam5 = 0, $aParam6 = 0, $aParam7 = 0, $aParam8 = 0, $aParam9 = 0, $aParam10 = 0)
	DllStructSetData($mPacket, 2, $aSize)
	DllStructSetData($mPacket, 3, $aHeader)
	DllStructSetData($mPacket, 4, $aParam1)
	DllStructSetData($mPacket, 5, $aParam2)
	DllStructSetData($mPacket, 6, $aParam3)
	DllStructSetData($mPacket, 7, $aParam4)
	DllStructSetData($mPacket, 8, $aParam5)
	DllStructSetData($mPacket, 9, $aParam6)
	DllStructSetData($mPacket, 10, $aParam7)
	DllStructSetData($mPacket, 11, $aParam8)
	DllStructSetData($mPacket, 12, $aParam9)
	DllStructSetData($mPacket, 13, $aParam10)
	GwAu3_Core_Enqueue($mPacketPtr, 52)
EndFunc
