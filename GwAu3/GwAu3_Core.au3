#include-once

#include "Constants/_Constants.au3"
#include "Core/_Core.au3"
#include "Modules/_Modules.au3"

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
    GwAu3_Scanner_AddPattern('AgentBase', '8B0C9085C97419', -0x3, 'Ptr')
    GwAu3_Scanner_AddPattern('ChangeTarget', '3BDF0F95', -0x86, 'Func')
    GwAu3_Scanner_AddPattern('CurrentTarget', '83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55', -0xE, 'Ptr')
    GwAu3_Scanner_AddPattern('MyID', '83EC08568BF13B15', -0x3, 'Ptr')
    ; Map patterns
    GwAu3_Scanner_AddPattern('Move', '558BEC83EC208D45F0', 0x1, 'Func')
    GwAu3_Scanner_AddPattern('ClickCoords', '8B451C85C0741CD945F8', 0xD, 'Ptr')
    GwAu3_Scanner_AddPattern('InstanceInfo', '6A2C50E80000000083C408C7', 0xE, 'Ptr')
    GwAu3_Scanner_AddPattern('WorldConst', '8D0476C1E00405', 0x8, 'Ptr')
    GwAu3_Scanner_AddPattern('Region', '6A548D46248908', -0x3, 'Ptr')
	; Ui
	GwAu3_Scanner_AddPattern('SendUIMessage', 'B900000000E8000000005DC3894508', 0x0, 'Func')
	GwAu3_Scanner_AddPattern('EnterMission', 'A900001000743A', 0x52, 'Func')
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

	;Ui
	$l_p_Temp = GwAu3_Scanner_GetScanResult('EnterMission', $g_ap_ScanResults, 'Func')
	GwAu3_Memory_SetValue('EnterMission', Ptr(GwAu3_Scanner_GetCallTargetAddress($l_p_Temp)))
	;Ui log
	GwAu3_Log_Debug("EnterMission: " & GwAu3_Memory_GetValue('EnterMission'), "Initialize", $g_h_EditText)

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
	;Ui
	DllStructSetData($g_d_EnterMission, 1, GwAu3_Memory_GetValue('CommandEnterMission'))

    If $a_b_ChangeTitle Then WinSetTitle($g_h_GWWindow, '', 'Guild Wars - ' & GwAu3_Player_GetCharname())

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

Func GwAu3_Core_AutoStart()
	If $g_bAutoStart And $g_s_MainCharName <> "" Then
		Sleep(2000)
		StartBot()
		Local $l_h_GWWindow = GwAu3_Core_GetGuildWarsWindow()
		If $l_h_GWWindow = 0 Then
			_Exit()
		EndIf

		If GwAu3_PreGame_Ptr() <> 0 Then

			Local $l_i_currentIndex = GwAu3_PreGame_ChosenCharacter()
			Local $l_s_currentName = StringStripWS(GwAu3_PreGame_CharName($l_i_currentIndex), 3)

			If StringCompare($l_s_currentName, $g_s_MainCharName, 0) <> 0 Then
				Local $l_b_found = False
				Local $l_i_maxAttempts = 20
				Local $l_i_attempts = 0
				Local $l_i_initialIndex = $l_i_currentIndex

				While $l_i_attempts < $l_i_maxAttempts And Not $l_b_found
					ControlSend($l_h_GWWindow, "", "", "{RIGHT}")
					Sleep(250)

					$l_i_currentIndex = GwAu3_PreGame_ChosenCharacter()
					$l_s_currentName = StringStripWS(GwAu3_PreGame_CharName($l_i_currentIndex), 3)

					If StringCompare($l_s_currentName, $g_s_MainCharName, 0) = 0 Then
						$l_b_found = True
					EndIf

					$l_i_attempts += 1

					If $l_i_attempts > 1 And $l_i_currentIndex = $l_i_initialIndex Then
						ExitLoop
					EndIf
				WEnd

				If Not $l_b_found Then
					MsgBox(16, "Error", "Character '" & $g_s_MainCharName & "' not found on this account!")
					_Exit()
				EndIf
			EndIf

			ControlSend($l_h_GWWindow, "", "", "{ENTER}")

			While GwAu3_PreGame_Ptr() <> 0
				Sleep(500)
			WEnd
			GwAu3_Map_WaitMapLoading()
			Sleep(1000)
		EndIf
	EndIf
EndFunc

Func GwAu3_Core_GetGuildWarsWindow()
    Local $l_s_expectedTitle = "Guild Wars - " & $g_s_MainCharName

    Local $l_h_Wnd = WinGetHandle($l_s_expectedTitle)
    If $l_h_Wnd <> 0 Then Return $l_h_Wnd
EndFunc