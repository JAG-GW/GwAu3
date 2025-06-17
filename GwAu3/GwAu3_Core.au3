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
Func GwAu3_Core_Initialize($a_s_GW, $a_b_ChangeTitle = True)
	GwAu3_Log_Info("Initializing...", "GwAu3", $g_h_EditText)
    ; Open process
    If IsString($a_s_GW) Then
        Local $l_h_ProcessList = ProcessList("gw.exe")
        For $i = 1 To $l_h_ProcessList[0][0]
            $g_i_GWProcessId = $l_h_ProcessList[$i][1]
            $g_h_GWWindow = GwAu3_Scanner_GetHwnd($g_i_GWProcessId)
            GwAu3_Memory_Open($g_i_GWProcessId)
            If $g_h_GWProcess Then
                If StringRegExp(GwAu3_Scanner_ScanForCharname(), $a_s_GW) = 1 Then
                    ExitLoop
                EndIf
            EndIf
            GwAu3_Memory_Close()
            $g_h_GWProcess = 0
        Next
    Else
        $g_i_GWProcessId = $a_s_GW
        $g_h_GWWindow = GwAu3_Scanner_GetHwnd($g_i_GWProcessId)
        GwAu3_Memory_Open($a_s_GW)
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


    $g_ap_ScanResults = GwAu3_Scanner_ScanAllPatterns()


	Local $l_p_Temp
    ;Core
    $g_p_BasePointer = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('BasePointer', $g_ap_ScanResults, 'Ptr'))
    $g_p_PacketLocation = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('PacketLocation', $g_ap_ScanResults, 'Ptr'))
    $g_p_Ping = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('Ping', $g_ap_ScanResults, 'Ptr'))
    $g_p_PreGame = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('PreGame', $g_ap_ScanResults, 'Ptr') + 0x35)
    $g_p_FrameArray = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('FrameArray', $g_ap_ScanResults, 'Ptr') - 0x13)
	GwAu3_Memory_SetValue('BasePointer', Ptr($g_p_BasePointer))
	GwAu3_Memory_SetValue('PacketLocation', Ptr($g_p_PacketLocation))
	GwAu3_Memory_SetValue('Ping', Ptr($g_p_Ping))
	GwAu3_Memory_SetValue('PreGame', Ptr($g_p_PreGame))
	GwAu3_Memory_SetValue('FrameArray', Ptr($g_p_FrameArray))
	GwAu3_Memory_SetValue('PacketSend', Ptr(GwAu3_Scanner_GetScanResult('PacketSend', $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('ActionBase', Ptr(GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('ActionBase', $g_ap_ScanResults, 'Ptr'))))
    GwAu3_Memory_SetValue('Action', Ptr(GwAu3_Scanner_GetScanResult('Action', $g_ap_ScanResults, 'Func')))
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
    $g_p_SkillBase = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('SkillBase', $g_ap_ScanResults, 'Ptr'))
    $g_p_SkillTimer = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('SkillTimer', $g_ap_ScanResults, 'Ptr'))
	GwAu3_Memory_SetValue('SkillBase', Ptr($g_p_SkillBase))
    GwAu3_Memory_SetValue('SkillTimer', Ptr($g_p_SkillTimer))
    GwAu3_Memory_SetValue('UseSkill', Ptr(GwAu3_Scanner_GetScanResult('UseSkill', $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('UseHeroSkill', Ptr(GwAu3_Scanner_GetScanResult('UseHeroSkill', $g_ap_ScanResults, 'Func')))
	;Skill log
	GwAu3_Log_Debug("SkillBase: " & GwAu3_Memory_GetValue('SkillBase'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("SkillTimer: " & GwAu3_Memory_GetValue('SkillTimer'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("UseSkill: " & GwAu3_Memory_GetValue('UseSkill'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("UseHeroSkill: " & GwAu3_Memory_GetValue('UseHeroSkill'), "Initialize", $g_h_EditText)

	;Friend
	$g_p_FriendList = GwAu3_Scanner_GetScanResult('FriendList', $g_ap_ScanResults, 'Ptr')
	$g_p_FriendList = GwAu3_Memory_Read(GwAu3_Scanner_FindInRange("57B9", "xx", 2, $g_p_FriendList, $g_p_FriendList + 0xFF))
	$l_p_Temp = GwAu3_Scanner_GetScanResult("RemoveFriend", $g_ap_ScanResults, 'Func')
	$l_p_Temp = GwAu3_Scanner_FindInRange("50E8", "xx", 1, $l_p_Temp, $l_p_Temp + 0x32)
	$l_p_Temp = GwAu3_Scanner_FunctionFromNearCall($l_p_Temp)
    GwAu3_Memory_SetValue('FriendList', Ptr($g_p_FriendList))
	GwAu3_Memory_SetValue('PlayerStatus', Ptr(GwAu3_Scanner_GetScanResult("PlayerStatus", $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('AddFriend', Ptr(GwAu3_Scanner_GetScanResult("AddFriend", $g_ap_ScanResults, 'Func')))
	GwAu3_Memory_SetValue('RemoveFriend', Ptr($l_p_Temp))
	;Friend log
	GwAu3_Log_Debug("FriendList: " & GwAu3_Memory_GetValue('FriendList'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("PlayerStatus: " & GwAu3_Memory_GetValue('PlayerStatus'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("AddFriend: " & GwAu3_Memory_GetValue('AddFriend'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("RemoveFriend: " & GwAu3_Memory_GetValue('RemoveFriend'), "Initialize", $g_h_EditText)

	;Attributes
    $g_p_AttributeInfo = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('AttributeInfo', $g_ap_ScanResults, 'Ptr'))
    GwAu3_Memory_SetValue('AttributeInfo', Ptr($g_p_AttributeInfo))
    GwAu3_Memory_SetValue('IncreaseAttribute', Ptr(GwAu3_Scanner_GetScanResult('IncreaseAttribute', $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('DecreaseAttribute', Ptr(GwAu3_Scanner_GetScanResult('DecreaseAttribute', $g_ap_ScanResults, 'Func')))
	;Attributes log
	GwAu3_Log_Debug("AttributeInfo: " & GwAu3_Memory_GetValue('AttributeInfo'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("IncreaseAttribute: " & GwAu3_Memory_GetValue('IncreaseAttribute'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("DecreaseAttribute: " & GwAu3_Memory_GetValue('DecreaseAttribute'), "Initialize", $g_h_EditText)

	;Trade
	$g_p_BuyItemBase = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('BuyItemBase', $g_ap_ScanResults, 'Ptr'))
    $g_p_SalvageGlobal = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('SalvageGlobal', $g_ap_ScanResults, 'Ptr') - 0x4)
	GwAu3_Memory_SetValue('BuyItemBase', Ptr($g_p_BuyItemBase))
    GwAu3_Memory_SetValue('SalvageGlobal', Ptr($g_p_SalvageGlobal))
    GwAu3_Memory_SetValue('SellItem', Ptr(GwAu3_Scanner_GetScanResult('SellItem', $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('Transaction', Ptr(GwAu3_Scanner_GetScanResult('Transaction', $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('RequestQuote', Ptr(GwAu3_Scanner_GetScanResult('RequestQuote', $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('Trader', Ptr(GwAu3_Scanner_GetScanResult('Trader', $g_ap_ScanResults, 'Func')))
    GwAu3_Memory_SetValue('Salvage', Ptr(GwAu3_Scanner_GetScanResult('Salvage', $g_ap_ScanResults, 'Func')))
	;Trade log
	GwAu3_Log_Debug("BuyItemBase: " & GwAu3_Memory_GetValue('BuyItemBase'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("SalvageGlobal: " & GwAu3_Memory_GetValue('SalvageGlobal'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("SellItem: " & GwAu3_Memory_GetValue('SellItem'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Transaction: " & GwAu3_Memory_GetValue('Transaction'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("RequestQuote: " & GwAu3_Memory_GetValue('RequestQuote'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Trader: " & GwAu3_Memory_GetValue('Trader'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Salvage: " & GwAu3_Memory_GetValue('Salvage'), "Initialize", $g_h_EditText)

	;Agent
	$g_p_AgentBase = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('AgentBase', $g_ap_ScanResults, 'Ptr'))
    $g_i_MaxAgents = $g_p_AgentBase + 0x8
    $g_i_MyID = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('MyID', $g_ap_ScanResults, 'Ptr'))
    $g_i_CurrentTarget = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('CurrentTarget', $g_ap_ScanResults, 'Ptr'))
	GwAu3_Memory_SetValue('AgentBase', Ptr($g_p_AgentBase))
	GwAu3_Memory_SetValue('MaxAgents', Ptr($g_i_MaxAgents))
	GwAu3_Memory_SetValue('MyID', Ptr($g_i_MyID))
	GwAu3_Memory_SetValue('CurrentTarget', Ptr($g_i_CurrentTarget))
    GwAu3_Memory_SetValue('ChangeTarget', Ptr(GwAu3_Scanner_GetScanResult('ChangeTarget', $g_ap_ScanResults, 'Func') + 1))
	;Agent log
	GwAu3_Log_Debug("AgentBase: " & GwAu3_Memory_GetValue('AgentBase'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("MaxAgents: " & GwAu3_Memory_GetValue('MaxAgents'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("MyID: " & GwAu3_Memory_GetValue('MyID'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("ChangeTarget: " & GwAu3_Memory_GetValue('ChangeTarget'), "Initialize", $g_h_EditText)

	;Map
	$g_p_InstanceInfo = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('InstanceInfo', $g_ap_ScanResults, 'Ptr'))
	$g_p_WorldConst = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('WorldConst', $g_ap_ScanResults, 'Ptr'))
	$g_f_ClickCoordsX = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('ClickCoords', $g_ap_ScanResults, 'Ptr'))
	$g_f_ClickCoordsY = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('ClickCoords', $g_ap_ScanResults, 'Ptr') + 9)
	$g_p_Region = GwAu3_Memory_Read(GwAu3_Scanner_GetScanResult('Region', $g_ap_ScanResults, 'Ptr'))
	GwAu3_Memory_SetValue('InstanceInfo', Ptr($g_p_InstanceInfo))
	GwAu3_Memory_SetValue('WorldConst', Ptr($g_p_WorldConst))
	GwAu3_Memory_SetValue('ClickCoords', Ptr($g_f_ClickCoordsX))
	GwAu3_Memory_SetValue('ClickCoords', Ptr($g_f_ClickCoordsY))
	GwAu3_Memory_SetValue('Region', Ptr($g_p_Region))
    GwAu3_Memory_SetValue('Move', Ptr(GwAu3_Scanner_GetScanResult('Move', $g_ap_ScanResults, 'Func')))
	;Map log
	GwAu3_Log_Debug("InstanceInfo: " & GwAu3_Memory_GetValue('InstanceInfo'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("WorldConst: " & GwAu3_Memory_GetValue('WorldConst'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("ClickCoords: " & GwAu3_Memory_GetValue('ClickCoords'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Region: " & GwAu3_Memory_GetValue('Region'), "Initialize", $g_h_EditText)
	GwAu3_Log_Debug("Move: " & GwAu3_Memory_GetValue('Move'), "Initialize", $g_h_EditText)

    ;Hook
    $l_p_Temp = GwAu3_Scanner_GetScanResult('Engine', $g_ap_ScanResults, 'Hook')
    GwAu3_Memory_SetValue('MainStart', Ptr($l_p_Temp))
    GwAu3_Memory_SetValue('MainReturn', Ptr($l_p_Temp + 0x5))
    $l_p_Temp = GwAu3_Scanner_GetScanResult('Render', $g_ap_ScanResults, 'Hook')
    GwAu3_Memory_SetValue('RenderingMod', Ptr($l_p_Temp))
    GwAu3_Memory_SetValue('RenderingModReturn', Ptr($l_p_Temp + 0xA))
    $l_p_Temp = GwAu3_Scanner_GetScanResult('HookedTrader', $g_ap_ScanResults, 'Hook')
    GwAu3_Memory_SetValue('TraderStart', Ptr($l_p_Temp))
    GwAu3_Memory_SetValue('TraderReturn', Ptr($l_p_Temp + 0x5))
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


	$g_i_AgentCopyCount = GwAu3_Memory_GetValue('AgentCopyCount')
    $g_p_AgentCopyBase = GwAu3_Memory_GetValue('AgentCopyBase')
    $g_i_TraderQuoteID = GwAu3_Memory_GetValue('TraderQuoteID')
    $g_i_TraderCostID = GwAu3_Memory_GetValue('TraderCostID')
    $g_f_TraderCostValue = GwAu3_Memory_GetValue('TraderCostValue')
	$g_i_QueueCounter = GwAu3_Memory_Read(GwAu3_Memory_GetValue('QueueCounter'))
    $g_i_QueueSize = GwAu3_Memory_GetValue('QueueSize') - 1
    $g_p_QueueBase = GwAu3_Memory_GetValue('QueueBase')
    $g_b_DisableRendering = GwAu3_Memory_GetValue('DisableRendering')


    ; Setup command structures
    DllStructSetData($g_d_InviteGuild, 1, GwAu3_Memory_GetValue('CommandPacketSend'))
    DllStructSetData($g_d_InviteGuild, 2, 0x4C)
    DllStructSetData($g_d_Packet, 1, GwAu3_Memory_GetValue('CommandPacketSend'))
    DllStructSetData($g_d_Action, 1, GwAu3_Memory_GetValue('CommandAction'))
    DllStructSetData($g_d_SendChat, 1, GwAu3_Memory_GetValue('CommandSendChat'))
    DllStructSetData($g_d_SendChat, 2, 0x0063)
	;Skill
	DllStructSetData($g_d_UseSkill, 1, GwAu3_Memory_GetValue('CommandUseSkill'))
    DllStructSetData($g_d_UseHeroSkill, 1, GwAu3_Memory_GetValue('CommandUseHeroSkill'))
	;Friend
	DllStructSetData($g_d_ChangeStatus, 1, GwAu3_Memory_GetValue('CommandPlayerStatus'))
    DllStructSetData($g_d_AddFriend, 1, GwAu3_Memory_GetValue('CommandAddFriend'))
    DllStructSetData($g_d_RemoveFriend, 1, GwAu3_Memory_GetValue('CommandRemoveFriend'))
	;Attribute
	DllStructSetData($g_d_IncreaseAttribute, 1, GwAu3_Memory_GetValue('CommandIncreaseAttribute'))
    DllStructSetData($g_d_DecreaseAttribute, 1, GwAu3_Memory_GetValue('CommandDecreaseAttribute'))
	;Trade
	DllStructSetData($g_d_SellItem, 1, GwAu3_Memory_GetValue('CommandSellItem'))
    DllStructSetData($g_d_BuyItem, 1, GwAu3_Memory_GetValue('CommandBuyItem'))
    DllStructSetData($g_d_CraftItemEx, 1, GwAu3_Memory_GetValue('CommandCraftItemEx'))
    DllStructSetData($g_d_RequestQuote, 1, GwAu3_Memory_GetValue('CommandRequestQuote'))
    DllStructSetData($g_d_RequestQuoteSell, 1, GwAu3_Memory_GetValue('CommandRequestQuoteSell'))
    DllStructSetData($g_d_TraderBuy, 1, GwAu3_Memory_GetValue('CommandTraderBuy'))
    DllStructSetData($g_d_TraderSell, 1, GwAu3_Memory_GetValue('CommandTraderSell'))
    DllStructSetData($g_d_Salvage, 1, GwAu3_Memory_GetValue('CommandSalvage'))
	;Agent
	DllStructSetData($g_d_ChangeTarget, 1, GwAu3_Memory_GetValue('CommandChangeTarget'))
    DllStructSetData($g_d_MakeAgentArray, 1, GwAu3_Memory_GetValue('CommandMakeAgentArray'))
	;Map
	DllStructSetData($g_d_Move, 1, GwAu3_Memory_GetValue('CommandMove'))

    If $a_b_ChangeTitle Then WinSetTitle($g_h_GWWindow, '', 'Guild Wars - ' & GwAu3_OtherMod_GetCharname())

    GwAu3_Log_Info("End of Initialization.", "GwAu3", $g_h_EditText)
    Return $g_h_GWWindow
EndFunc
#EndRegion Initialization

Func GwAu3_Core_Enqueue($a_p_Ptr, $a_i_Size)
	DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'int', 256 * $g_i_QueueCounter + $g_p_QueueBase, 'ptr', $a_p_Ptr, 'int', $a_i_Size, 'int', '')
	If $g_i_QueueCounter = $g_i_QueueSize Then
		$g_i_QueueCounter = 0
	Else
		$g_i_QueueCounter = $g_i_QueueCounter + 1
	EndIf
EndFunc

Func GwAu3_Core_PerformAction($a_i_Action, $a_i_Flag)
	DllStructSetData($g_d_Action, 2, $a_i_Action)
	DllStructSetData($g_d_Action, 3, $a_i_Flag)
	GwAu3_Core_Enqueue($g_p_Action, 12)
EndFunc

Func GwAu3_Core_SendPacket($a_i_Size, $a_i_Header, $a_i_Param1 = 0, $a_i_Param2 = 0, $a_i_Param3 = 0, $a_i_Param4 = 0, $a_i_Param5 = 0, $a_i_Param6 = 0, $a_i_Param7 = 0, $a_i_Param8 = 0, $a_i_Param9 = 0, $a_i_Param10 = 0)
	DllStructSetData($g_d_Packet, 2, $a_i_Size)
	DllStructSetData($g_d_Packet, 3, $a_i_Header)
	DllStructSetData($g_d_Packet, 4, $a_i_Param1)
	DllStructSetData($g_d_Packet, 5, $a_i_Param2)
	DllStructSetData($g_d_Packet, 6, $a_i_Param3)
	DllStructSetData($g_d_Packet, 7, $a_i_Param4)
	DllStructSetData($g_d_Packet, 8, $a_i_Param5)
	DllStructSetData($g_d_Packet, 9, $a_i_Param6)
	DllStructSetData($g_d_Packet, 10, $a_i_Param7)
	DllStructSetData($g_d_Packet, 11, $a_i_Param8)
	DllStructSetData($g_d_Packet, 12, $a_i_Param9)
	DllStructSetData($g_d_Packet, 13, $a_i_Param10)
	GwAu3_Core_Enqueue($g_p_Packet, 52)
EndFunc

Func GwAu3_Core_ControlAction($a_i_Action, $a_i_ActionType = $GC_I_ACTIONTYPE_ACTIVATE)
	Return GwAu3_Core_PerformAction($a_i_Action, $a_i_ActionType)
EndFunc

#Region function to sort
;~ Description: Salvage the materials out of an item.
Func SalvageMaterials()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_ITEM_SALVAGE_MATERIALS)
EndFunc   ;==>SalvageMaterials

;~ Description: Salvages a mod out of an item.
Func SalvageMod($a_i_ModIndex)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, $a_i_ModIndex)
EndFunc   ;==>SalvageMod

;~ Description: Identifies an item.
Func IdentifyItem($a_v_Item, $a_s_KitType = "Superior")
	Local $l_i_IDKit = 0
	Local $l_i_ItemID = GwAu3_ItemMod_ItemID($a_v_Item)

    If GwAu3_ItemMod_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Then Return True

	Switch $a_s_KitType
		Case "Superior"
			If GwAu3_MapMod_GetInstanceInfo("IsOutpost") Then
				$l_i_IDKit = GwAu3_ItemMod_GetItemInfoByModelID(5899, "ItemID")
				If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_ItemMod_GetItemInfoByModelID(2989, "ItemID")
			ElseIf GwAu3_MapMod_GetInstanceInfo("IsExplorable") Then
				$l_i_IDKit = GwAu3_ItemMod_GetBagsItembyModelID(5899)
				If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_ItemMod_GetBagsItembyModelID(2989)
			EndIf
		Case "Normal"
			If GwAu3_MapMod_GetInstanceInfo("IsOutpost") Then
				$l_i_IDKit = GwAu3_ItemMod_GetItemInfoByModelID(2989, "ItemID")
				If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_ItemMod_GetItemInfoByModelID(5899, "ItemID")
			ElseIf GwAu3_MapMod_GetInstanceInfo("IsExplorable") Then
				$l_i_IDKit = GwAu3_ItemMod_GetBagsItembyModelID(2989)
				If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_ItemMod_GetBagsItembyModelID(5899)
			EndIf
	EndSwitch

    If $l_i_IDKit = 0 Then Return False

    GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_ITEM_IDENTIFY, GwAu3_ItemMod_ItemID($l_i_IDKit), $l_i_ItemID)

    Local $l_i_Deadlock = TimerInit()
    Do
        Sleep(16)
    Until GwAu3_ItemMod_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Or TimerDiff($l_i_Deadlock) > 2500

	If TimerDiff($l_i_Deadlock) > 2500 Then Return False

    Return True
EndFunc   ;==>IdentifyItem

;~ Description: Equips an item.
Func EquipItem($a_v_Item)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEM_EQUIP, GwAu3_ItemMod_ItemID($a_v_Item))
EndFunc   ;==>EquipItem

;~ Description: Uses an item.
Func UseItem($a_v_Item)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEM_USE, GwAu3_ItemMod_ItemID($a_v_Item))
EndFunc   ;==>UseItem

;~ Description: Picks up an item.
Func PickUpItem($a_v_AgentID)
    Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_ITEM_PICKUP, GwAu3_AgentMod_ConvertID($a_v_AgentID), 0)
EndFunc   ;==>PickUpItem

;~ Description: Drops an item.
Func DropItem($a_v_Item, $a_i_Amount = 0)
	Local $l_i_ItemID = GwAu3_ItemMod_ItemID($a_v_Item)
	Local $l_i_Quantity = GwAu3_ItemMod_GetItemInfoByItemID($a_v_Item, "Quantity")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Quantity Then $a_i_Amount = $l_i_Quantity
    Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_DROP_ITEM, $l_i_ItemID, $a_i_Amount)
EndFunc ;==>DropItem

;~ Description: Moves an item.
Func MoveItem($a_v_Item, $a_i_BagNumber, $a_i_Slot)
	Return GwAu3_Core_SendPacket(0x10, $GC_I_HEADER_ITEM_MOVE, GwAu3_ItemMod_ItemID($a_v_Item), GwAu3_ItemMod_GetBagInfo($a_i_BagNumber, "ID"), $a_i_Slot - 1)
EndFunc   ;==>MoveItem

;~ Description: Accepts unclaimed items after a mission.
Func AcceptAllItems()
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEMS_ACCEPT_UNCLAIMED, GwAu3_ItemMod_GetBagInfo(7, "ID"))
EndFunc   ;==>AcceptAllItems

;~ Description: Drop gold on the ground.
Func DropGold($a_i_Amount = 0)
	Local $l_i_Amount = GwAu3_ItemMod_GetInventoryInfo("GoldCharacter")
	If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Amount Then $a_i_Amount = $l_i_Amount
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_DROP_GOLD, $a_i_Amount)
EndFunc   ;==>DropGold

;~ Description: Internal use for moving gold.
Func ChangeGold($a_i_Character, $a_i_Storage)
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_ITEM_CHANGE_GOLD, $a_i_Character, $a_i_Storage) ;0x75
EndFunc   ;==>ChangeGold

;~ Description: Adds a hero to the party.
Func AddHero($a_i_HeroId)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_HERO_ADD, $a_i_HeroId)
EndFunc   ;==>AddHero

;~ Description: Kicks a hero from the party.
Func KickHero($a_i_HeroId)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_HERO_KICK, $a_i_HeroId)
EndFunc   ;==>KickHero

;~ Description: Kicks all heroes from the party.
Func KickAllHeroes()
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_HERO_KICK, 0x26)
EndFunc

;~ Description: Add a henchman to the party.
Func AddNpc($a_i_NpcId)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_PARTY_INVITE_NPC, $a_i_NpcId)
EndFunc   ;==>AddNpc

;~ Description: Kick a henchman from the party.
Func KickNpc($a_i_NpcId)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_PARTY_KICK_NPC, $a_i_NpcId)
EndFunc   ;==>KickNpc

;~ Description: Clear the position flag from a hero.
Func CancelHero($a_i_HeroNumber)
	Local $l_i_AgentID = GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
	Return GwAu3_Core_SendPacket(0x14, $GC_I_HEADER_HERO_FLAG_SINGLE, $l_i_AgentID, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelHero

;~ Description: Clear the position flag from all heroes.
Func CancelAll()
	Return GwAu3_Core_SendPacket(0x10, $GC_I_HEADER_HERO_FLAG_ALL, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelAll

;~ Description: Place a hero's position flag.
Func CommandHero($a_i_HeroNumber, $a_f_X, $a_f_Y)
	Return GwAu3_Core_SendPacket(0x14, $GC_I_HEADER_HERO_FLAG_SINGLE, GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), GwAu3_Utils_FloatToInt($a_f_X), GwAu3_Utils_FloatToInt($a_f_Y), 0)
EndFunc   ;==>CommandHero

;~ Description: Place the full-party position flag.
Func CommandAll($a_f_X, $a_f_Y)
	Return GwAu3_Core_SendPacket(0x10, $GC_I_HEADER_HERO_FLAG_ALL, GwAu3_Utils_FloatToInt($a_f_X), GwAu3_Utils_FloatToInt($a_f_Y), 0)
EndFunc   ;==>CommandAll

;~ Description: Lock a hero onto a target.
Func LockHeroTarget($a_i_HeroNumber, $a_i_AgentID = 0) ;$a_i_AgentID=0 Cancels Lock
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_HERO_LOCK_TARGET, GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_AgentID)
EndFunc   ;==>LockHeroTarget

;~ Description: Change a hero's aggression level.
Func SetHeroAggression($a_i_HeroNumber, $a_i_Aggression) ;0=Fight, 1=Guard, 2=Avoid
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_HERO_BEHAVIOR, GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_Aggression)
EndFunc   ;==>SetHeroAggression

;~ Description: Internal use for enabling or disabling hero skills
Func ChangeHeroSkillSlotState($a_i_HeroNumber, $a_i_SkillSlot)
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_HERO_SKILL_TOGGLE, GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_SkillSlot - 1)
EndFunc   ;==>ChangeHeroSkillSlotState

;~ Description: Run to or follow a player.
Func GoPlayer($a_v_Agent)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_INTERACT_PLAYER, GwAu3_AgentMod_ConvertID($a_v_Agent))
EndFunc   ;==>GoPlayer

;~ Description: Talk to an NPC
Func GoNPC($a_v_Agent)
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_INTERACT_LIVING, GwAu3_AgentMod_ConvertID($a_v_Agent))
EndFunc   ;==>GoNPC

;~ Description: Run to a signpost.
Func GoSignpost($a_v_Agent)
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_GADGET_INTERACT, GwAu3_AgentMod_ConvertID($a_v_Agent), 0)
EndFunc   ;==>GoSignpost

;~ Description: Attack an agent.
Func Attack($a_v_Agent, $a_b_CallTarget = False)
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_ACTION_ATTACK, GwAu3_AgentMod_ConvertID($a_v_Agent), $a_b_CallTarget)
EndFunc   ;==>Attack

;~ Description: Call target.
Func CallTarget($a_v_Target)
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_CALL_TARGET, 0xA, GwAu3_AgentMod_ConvertID($a_v_Target))
EndFunc   ;==>CallTarget

;~ Description: Cancel current action.
Func CancelAction()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_ACTION_CANCEL)
EndFunc   ;==>CancelAction

;~ Description: Drop a buff with specific skill ID targeting a specific agent
Func DropBuff($a_i_SkillID, $a_v_AgentID, $a_i_HeroNumber = 0)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_BUFF_DROP, GwAu3_AgentMod_GetAgentBuffInfo(_AgentMod_ConvertID($a_v_AgentID), $a_i_SkillID, "BuffID"))
EndFunc   ;==>DropBuff

;~ Description: Leave your party.
Func LeaveGroup($a_b_KickHeroes = True)
	If $a_b_KickHeroes Then KickAllHeroes()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_PARTY_LEAVE_GROUP)
EndFunc   ;==>LeaveGroup

;~ Description: Change a skill on the skillbar.
Func SetSkillbarSkill($a_i_Slot, $a_i_SkillID, $a_i_HeroNumber = 0)
	Local $l_i_HeroID
	If $a_i_HeroNumber <> 0 Then
		$l_i_HeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
	Else
		$l_i_HeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
	EndIf
	Return GwAu3_Core_SendPacket(0x14, $GC_I_HEADER_SKILLBAR_SKILL_SET, $l_i_HeroID, $a_i_Slot - 1, $a_i_SkillID, 0)
EndFunc   ;==>SetSkillbarSkill

;~ Description: Load all skills onto a skillbar simultaneously.
Func LoadSkillBar($a_i_Skill1 = 0, $a_i_Skill2 = 0, $a_i_Skill3 = 0, $a_i_Skill4 = 0, $a_i_Skill5 = 0, $a_i_Skill6 = 0, $a_i_Skill7 = 0, $a_i_Skill8 = 0, $a_i_HeroNumber = 0)
	Local $l_i_HeroID
	If $a_i_HeroNumber <> 0 Then
		$l_i_HeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
	Else
		$l_i_HeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
	EndIf
	Return GwAu3_Core_SendPacket(0x2C, $GC_I_HEADER_SKILLBAR_LOAD, $l_i_HeroID, 8, $a_i_Skill1, $a_i_Skill2, $a_i_Skill3, $a_i_Skill4, $a_i_Skill5, $a_i_Skill6, $a_i_Skill7, $a_i_Skill8)
EndFunc   ;==>LoadSkillBar

;~ Description: Change your secondary profession.
Func ChangeSecondProfession($a_i_Profession, $a_i_HeroNumber = 0)
	Local $l_i_HeroID
	If $a_i_HeroNumber <> 0 Then
		$l_i_HeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
	Else
		$l_i_HeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
	EndIf
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_PROFESSION_CHANGE, $l_i_HeroID, $a_i_Profession)
EndFunc   ;==>ChangeSecondProfession

;~ Description: Internal use for map travel.
Func MoveMap($a_i_MapID, $a_i_Region, $a_i_District, $a_i_Language)
	Return GwAu3_Core_SendPacket(0x18, $GC_I_HEADER_PARTY_TRAVEL, $a_i_MapID, $a_i_Region, $a_i_District, $a_i_Language, False)
EndFunc   ;==>MoveMap

;~ Description: Returns to outpost after resigning/failure.
Func ReturnToOutpost()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_PARTY_RETURN_TO_OUTPOST)
EndFunc   ;==>ReturnToOutpost

;~ Description: Enter a challenge mission/pvp.
Func EnterChallenge()
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_PARTY_ENTER_CHALLENGE, 1)
EndFunc   ;==>EnterChallenge

;~ Description: Enter a foreign challenge mission/pvp.
;~ Func EnterChallengeForeign()
;~ 	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_PARTY_ENTER_FOREIGN_CHALLENGE, 0)
;~ EndFunc   ;==>EnterChallengeForeign

;~ Description: Travel to your guild hall.
Func TravelGH()
	Local $l_ai_Offset[3] = [0, 0x18, 0x3C]
	Local $l_p_GH = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
	GwAu3_Core_SendPacket(0x18, $GC_I_HEADER_PARTY_ENTER_GUILD_HALL, GwAu3_Memory_Read($l_p_GH[1] + 0x64), GwAu3_Memory_Read($l_p_GH[1] + 0x68), GwAu3_Memory_Read($l_p_GH[1] + 0x6C), GwAu3_Memory_Read($l_p_GH[1] + 0x70), 1)
	;~ Return WaitMapLoading()
EndFunc   ;==>TravelGH

;~ Description: Leave your guild hall.
Func LeaveGH()
	GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_PARTY_LEAVE_GUILD_HALL, 1)
	;~ Return WaitMapLoading()
EndFunc   ;==>LeaveGH

;~ Description: Switches to/from Hard Mode.
Func SwitchMode($a_i_Mode)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_PARTY_SET_DIFFICULTY, $a_i_Mode)
EndFunc   ;==>SwitchMode

;~ Description: Donate Kurzick or Luxon faction.
Func DonateFaction($a_s_Faction)
	If StringLeft($a_s_Faction, 1) = 'k' Then
		Return GwAu3_Core_SendPacket(0x10, $GC_I_HEADER_FACTION_DEPOSIT, 0, 0, 5000)
	Else
		Return GwAu3_Core_SendPacket(0x10, $GC_I_HEADER_FACTION_DEPOSIT, 0, 1, 5000)
	EndIf
EndFunc   ;==>DonateFaction

;~ Description: Open a dialog.
Func Dialog($a_v_DialogID)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_DIALOG_SEND, $a_v_DialogID)
EndFunc   ;==>Dialog

;~ Description: Skip a cinematic.
Func SkipCinematic()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_CINEMATIC_SKIP)
EndFunc   ;==>SkipCinematic

Func SetDisplayedTitle($a_i_Title = 0)
	If $a_i_Title <> 0 Then
		Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_TITLE_DISPLAY, $a_i_Title)
	Else
		Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_TITLE_HIDE)
	EndIf
EndFunc   ;==>SetDisplayedTitle

;~ Description: Accept a quest from an NPC.
Func AcceptQuest($a_i_QuestID)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_DIALOG_SEND, '0x008' & Hex($a_i_QuestID, 3) & '01')
EndFunc   ;==>AcceptQuest

;~ Description: Accept the reward for a quest.
Func QuestReward($a_i_QuestID)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_DIALOG_SEND, '0x008' & Hex($a_i_QuestID, 3) & '07')
EndFunc   ;==>QuestReward

;~ Description: Abandon a quest.
Func AbandonQuest($a_i_QuestID)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_QUEST_ABANDON, $a_i_QuestID)
EndFunc   ;==>AbandonQuest

Func TradePlayer($a_v_Agent)
	Return GwAu3_Core_SendPacket(0x08, $GC_I_HEADER_TRADE_INITIATE, GwAu3_AgentMod_ConvertID($a_v_Agent))
EndFunc   ;==>TradePlayer

Func AcceptTrade()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_TRADE_ACCEPT)
EndFunc   ;==>AcceptTrade

;~ Description: Like pressing the "Accept" button in a trade. Can only be used after both players have submitted their offer.
Func SubmitOffer($a_i_Gold = 0)
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_TRADE_SUBMIT_OFFER, $a_i_Gold)
EndFunc   ;==>SubmitOffer

;~ Description: Like pressing the "Cancel" button in a trade.
Func CancelTrade()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CANCEL)
EndFunc   ;==>CancelTrade

;~ Description: Like pressing the "Change Offer" button.
Func ChangeOffer()
	Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CANCEL_OFFER)
EndFunc   ;==>ChangeOffer

;~ $a_i_ItemID = ID of the item or item agent, $a_i_Quantity = Quantity
Func OfferItem($a_i_ItemID, $a_i_Quantity = 1)
;~ 	Local $l_i_ItemID
;~ 	$l_i_ItemID = GetBag_ItemMod_ItemIDByModelID($a_i_ModelID)
	Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_TRADE_ADD_ITEM, $a_i_ItemID, $a_i_Quantity)
EndFunc   ;==>OfferItem

;~ Description: Open a chest with key.
Func OpenChestNoLockpick()
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 1)
EndFunc   ;==>OpenChestNoLockpick

;~ Description: Open a chest with lockpick.
Func OpenChest()
	Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 2)
EndFunc   ;==>OpenChest

Func SwitchWeaponSet($a_i_WeaponSet)
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_SWITCH_SET, $a_i_WeaponSet)
EndFunc   ;==>SwitchWeaponSet

;~ Description: Sleep a random amount of time.
Func RndSleep($a_i_Amount, $a_f_Random = 0.05)
	Local $l_f_Random = $a_i_Amount * $a_f_Random
	Sleep(Random($a_i_Amount - $l_f_Random, $a_i_Amount + $l_f_Random))
EndFunc   ;==>RndSleep

;~ Description: Sleep a period of time, plus or minus a tolerance
Func TolSleep($a_i_Amount = 150, $a_i_Tolerance = 50)
	Sleep(Random($a_i_Amount - $a_i_Tolerance, $a_i_Amount + $a_i_Tolerance))
EndFunc   ;==>TolSleep

;~ Description: Sleep a period of time, plus ping.
Func PingSleep($a_i_MsExtra = 0)
	Sleep(GwAu3_OtherMod_GetPing() + $a_i_MsExtra)
EndFunc   ;==>PingSleep

;~ Description: Enable graphics rendering.
Func EnableRendering()
    If GetRenderEnabled() Then Return 1
	GwAu3_Memory_Write($g_b_DisableRendering, 0)
EndFunc ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering()
	If GetRenderDisabled() Then Return 1
	GwAu3_Memory_Write($g_b_DisableRendering, 1)
EndFunc ;==>DisableRendering

;~ Description: Checks if Rendering is disabled
Func GetRenderDisabled()
	Return GwAu3_Memory_Read($g_b_DisableRendering) = 1
EndFunc ;==>GetRenderDisabled

;~ Description: Checks if Rendering is enabled
Func GetRenderEnabled()
	Return GwAu3_Memory_Read($g_b_DisableRendering) = 0
EndFunc ;==>GetRenderEnabled

;~ Description: Toggle Rendering *and* Window State
Func ToggleRendering()
	If GetRenderDisabled() Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		GwAu3_Memory_Clear()
	EndIf
EndFunc ;==>ToggleRendering

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
;~ 				Also toggles Window State
Func PurgeHook($a_i_Time = 10000)
	If GetRenderEnabled() Then Return 1
	ToggleRendering()
	Sleep($a_i_Time)
	ToggleRendering()
EndFunc ;==>PurgeHook

;~ Description: Toggle Rendering (the GW window will stay hidden)
Func ToggleRendering_()
	If GetRenderDisabled() Then
        EnableRendering()
		GwAu3_Memory_Clear()
	Else
		DisableRendering()
		GwAu3_Memory_Clear()
	EndIf
EndFunc ;==>ToggleRendering_

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
Func PurgeHook_($a_i_Time = 10000)
	If GetRenderEnabled() Then Return 1
    ToggleRendering_()
    Sleep($a_i_Time)
    ToggleRendering_()
EndFunc ;==PurgeHook_

;~ Description: Write a message in chat (can only be seen by botter).
Func WriteChat($a_s_Message, $a_s_Sender = 'GwAu3')
	Local $l_s_Message, $l_s_Sender
	Local $l_p_Address = 256 * $g_i_QueueCounter + $g_p_QueueBase

	If $g_i_QueueCounter = $g_i_QueueSize Then
		$g_i_QueueCounter = 0
	Else
		$g_i_QueueCounter = $g_i_QueueCounter + 1
	EndIf

	If StringLen($a_s_Sender) > 19 Then
		$l_s_Sender = StringLeft($a_s_Sender, 19)
	Else
		$l_s_Sender = $a_s_Sender
	EndIf

	GwAu3_Memory_Write($l_p_Address + 4, $l_s_Sender, 'wchar[20]')

	If StringLen($a_s_Message) > 100 Then
		$l_s_Message = StringLeft($a_s_Message, 100)
	Else
		$l_s_Message = $a_s_Message
	EndIf

	GwAu3_Memory_Write($l_p_Address + 44, $l_s_Message, 'wchar[101]')
	DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'int', $l_p_Address, 'ptr', $mWriteChatPtr, 'int', 4, 'int', '')

	If StringLen($a_s_Message) > 100 Then WriteChat(StringTrimLeft($a_s_Message, 100), $a_s_Sender)
EndFunc   ;==>WriteChat

;~ Description: Send a whisper to another player.
Func SendWhisper($a_s_Receiver, $a_s_Message)
	Local $l_s_Total = 'whisper ' & $a_s_Receiver & ',' & $a_s_Message
	Local $l_s_Message

	If StringLen($l_s_Total) > 120 Then
		$l_s_Message = StringLeft($l_s_Total, 120)
	Else
		$l_s_Message = $l_s_Total
	EndIf

	SendChat($l_s_Message, '/')

	If StringLen($l_s_Total) > 120 Then SendWhisper($a_s_Receiver, StringTrimLeft($l_s_Total, 120))
EndFunc   ;==>SendWhisper

;~ Description: Send a message to chat.
;~ '!' = All, '@' = Guild, '#' = Team, '$' = Trade, '%' = Alliance, '"' = Whisper
Func SendChat($a_s_Message, $a_s_Channel = '!')
	Local $l_s_Message
	Local $l_p_Address = 256 * $g_i_QueueCounter + $g_p_QueueBase

	If $g_i_QueueCounter = $g_i_QueueSize Then
		$g_i_QueueCounter = 0
	Else
		$g_i_QueueCounter = $g_i_QueueCounter + 1
	EndIf

	If StringLen($a_s_Message) > 120 Then
		$l_s_Message = StringLeft($a_s_Message, 120)
	Else
		$l_s_Message = $a_s_Message
	EndIf

	GwAu3_Memory_Write($l_p_Address + 12, $a_s_Channel & $l_s_Message, 'wchar[122]')
	DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'int', $l_p_Address, 'ptr', $g_p_SendChat, 'int', 8, 'int', '')

	If StringLen($a_s_Message) > 120 Then SendChat(StringTrimLeft($a_s_Message, 120), $a_s_Channel)
EndFunc   ;==>SendChat

;~ Description: Deposit gold into storage.
Func DepositGold($a_i_Amount = 0)
	Local $l_i_Amount
	Local $l_i_Storage = GwAu3_ItemMod_GetInventoryInfo("GoldStorage")
	Local $l_i_Character = GwAu3_ItemMod_GetInventoryInfo("GoldCharacter")

	If $a_i_Amount > 0 And $l_i_Character >= $a_i_Amount Then
		$l_i_Amount = $a_i_Amount
	Else
		$l_i_Amount = $l_i_Character
	EndIf

	If $l_i_Storage + $l_i_Amount > 1000000 Then $l_i_Amount = 1000000 - $l_i_Storage

	ChangeGold($l_i_Character - $l_i_Amount, $l_i_Storage + $l_i_Amount)
EndFunc   ;==>DepositGold

;~ Description: Withdraw gold from storage.
Func WithdrawGold($a_i_Amount = 0)
	Local $l_i_Amount
	Local $l_i_Storage = GwAu3_ItemMod_GetInventoryInfo("GoldStorage")
	Local $l_i_Character = GwAu3_ItemMod_GetInventoryInfo("GoldCharacter")

	If $a_i_Amount > 0 And $l_i_Storage >= $a_i_Amount Then
		$l_i_Amount = $a_i_Amount
	Else
		$l_i_Amount = $l_i_Storage
	EndIf

	If $l_i_Character + $l_i_Amount > 100000 Then $l_i_Amount = 100000 - $l_i_Character

	ChangeGold($l_i_Character + $l_i_Amount, $l_i_Storage - $l_i_Amount)
EndFunc   ;==>WithdrawGold

;~ Description: Map travel to an outpost.
Func TravelTo($a_i_MapID, $a_i_Language = GwAu3_MapMod_GetCharacterInfo("Language"), $a_i_Region = GwAu3_MapMod_GetCharacterInfo("Region"), $a_i_District = 0)
	If	_MapMod_GetCharacterInfo("MapID") = $a_i_MapID And GwAu3_MapMod_GetInstanceInfo("IsOutpost") _
		And $a_i_Language = GwAu3_MapMod_GetCharacterInfo("Language") And $a_i_Region = GwAu3_MapMod_GetCharacterInfo("Region")  Then Return True
	MoveMap($a_i_MapID, $a_i_Region, $a_i_District, $a_i_Language)
	Return WaitMapLoading($a_i_MapID)
EndFunc   ;==>TravelTo

;~ 	Waits $a_i_Deadlock for load to start, and $a_i_DeadLock for agent to load after map is loaded.
Func WaitMapLoading($a_i_MapID = 0, $a_i_Deadlock = 10000, $a_b_SkipCinematic = False)
	Local $l_i_Timer = TimerInit(), $l_i_TypeMap
	Do
		Sleep(100)
		$l_i_TypeMap = GwAu3_Memory_Read(_AgentMod_GetAgentPtr(-2) + 0x158, 'long')
	Until Not BitAND($l_i_TypeMap, 0x400000) Or TimerDiff($l_i_Timer) > $a_i_Deadlock

	If $a_b_SkipCinematic Then
		Sleep(2500)
		SkipCinematic()
	EndIf

	$l_i_Timer = TimerInit()
	Do
		$l_i_TypeMap = GwAu3_Memory_Read(_AgentMod_GetAgentPtr(-2) + 0x158, 'long')
		Sleep(200)
	Until BitAND($l_i_TypeMap, 0x400000) And (GetMapID() = $a_i_MapID Or $a_i_MapID = 0) Or TimerDiff($l_i_Timer) > $a_i_Deadlock
	Sleep(3000)
	If TimerDiff($l_i_Timer) < $a_i_Deadlock + 3000 Then Return True
	Return False
EndFunc   ;==>WaitMapLoading

Func WaitMapLoadingEx($a_i_MapID = -1, $a_i_InstanceType = -1)
	Do
		Sleep(250)
		If GwAu3_OtherMod_GetGameInfo("IsCinematic") Then
			SkipCinematic()
			Sleep(1000)
		EndIf
	Until GwAu3_AgentMod_GetAgentPtr(-2) <> 0 And GwAu3_AgentMod_GetAgentArraySize() <> 0 And GwAu3_OtherMod_GetWorldInfo("SkillbarArray") <> 0 And _PartyMod_GetPartyContextPtr() <> 0 _
	And ($a_i_InstanceType = -1 Or GwAu3_MapMod_GetInstanceInfo("Type") = $a_i_InstanceType) And ($a_i_MapID = -1 Or GetMapID() = $a_i_MapID) And Not GwAu3_OtherMod_GetGameInfo("IsCinematic")
EndFunc

;~ Description: Returns current MapID
Func GetMapID()
    Return GwAu3_MapMod_GetCharacterInfo("MapID")
EndFunc   ;==>GetMapID

;~ Description: Returns the distance between two agents.
Func GetDistance($a_v_AgentID1 = -1, $a_v_AgentID2 = -2)
	Return ComputeDistance(GwAu3_AgentMod_GetAgentInfo($a_v_AgentID1, 'X'), GwAu3_AgentMod_GetAgentInfo($a_v_AgentID1, 'Y'), GwAu3_AgentMod_GetAgentInfo($a_v_AgentID2, 'X'), GwAu3_AgentMod_GetAgentInfo($a_v_AgentID2, 'Y'))
EndFunc   ;==>GetDistance

;~ Description: Returns the distance between two coordinate pairs.
Func ComputeDistance($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
	Return Sqrt(($a_f_X1 - $a_f_X2) ^ 2 + ($a_f_Y1 - $a_f_Y2) ^ 2)
EndFunc   ;==>ComputeDistance

Func GetBestTarget($a_i_Range = 1320)
	Local $l_i_BestTarget, $l_f_Distance, $l_f_LowestSum = 100000000
	Local $l_ai_AgentArray = GwAu3_AgentMod_GetAgentArray(0xDB)
	For $l_i_Idx = 1 To $l_ai_AgentArray[0]
		Local $l_f_SumDistances = 0
		If GwAu3_AgentMod_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'Allegiance') <> 3 Then ContinueLoop
		If GwAu3_AgentMod_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'HP') <= 0 Then ContinueLoop
		If GwAu3_AgentMod_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'ID') = GwAu3_AgentMod_GetMyID() Then ContinueLoop
		If GetDistance($l_ai_AgentArray[$l_i_Idx]) > $a_i_Range Then ContinueLoop
		For $l_i_SubIdx = 1 To $l_ai_AgentArray[0]
			If GwAu3_AgentMod_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'Allegiance') <> 3 Then ContinueLoop
			If GwAu3_AgentMod_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'HP') <= 0 Then ContinueLoop
			If GwAu3_AgentMod_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'ID') = GwAu3_AgentMod_GetMyID() Then ContinueLoop
			If GetDistance($l_ai_AgentArray[$l_i_SubIdx]) > $a_i_Range Then ContinueLoop
			$l_f_Distance = GetDistance($l_ai_AgentArray[$l_i_Idx], $l_ai_AgentArray[$l_i_SubIdx])
			$l_f_SumDistances += $l_f_Distance
		Next
		If $l_f_SumDistances < $l_f_LowestSum Then
			$l_f_LowestSum = $l_f_SumDistances
			$l_i_BestTarget = $l_ai_AgentArray[$l_i_Idx]
		EndIf
	Next
	Return $l_i_BestTarget
EndFunc   ;==>GetBestTarget

;~ Description: Returns modstruct of an item.
Func GetModStruct($a_v_Item)
	If GwAu3_ItemMod_GetItemInfoByItemID($a_v_Item, "ModStruct") = 0 Then Return
	Return GwAu3_Memory_Read(_ItemMod_GetItemInfoByItemID($a_v_Item, "ModStruct"), 'Byte[' & GwAu3_ItemMod_GetItemInfoByItemID($a_v_Item, "ModStructSize") * 4 & ']')
EndFunc   ;==>GetModStruct
#EndRegion function to sort
