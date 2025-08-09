#include-once

#include "Constants/_Constants.au3"
#include "Core/_Core.au3"
#include "Modules/_Modules.au3"

If @AutoItX64 Then
    MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
    Exit
EndIf

#Region Initialization
Func Core_Initialize($a_s_GW, $a_b_ChangeTitle = True)
	Log_Info("Checking for updates...", "GwAu3", $g_h_EditText)
	Local $l_i_UpdateStatus = Updater_CheckForGwAu3Updates()
	Switch $l_i_UpdateStatus
		Case 0
			Log_Info("Encountered an error while checking for updates", "GwAu3", $g_h_EditText)
		Case 1
			Log_Info("No updates available", "GwAu3", $g_h_EditText)
		Case 2
			Log_Info("Update has been cancelled", "GwAu3", $g_h_EditText)
		Case 3
			Log_Info("Updates disabled", "GwAu3", $g_h_EditText)
		Case 4
			Log_Info("Update complete", "GwAu3", $g_h_EditText)
	EndSwitch
	Log_Info("Initializing...", "GwAu3", $g_h_EditText)
    ; Open process
    If IsString($a_s_GW) Then
        Local $l_h_ProcessList = ProcessList("gw.exe")
        For $i = 1 To $l_h_ProcessList[0][0]
            $g_i_GWProcessId = $l_h_ProcessList[$i][1]
            $g_h_GWWindow = Scanner_GetHwnd($g_i_GWProcessId)
            Memory_Open($g_i_GWProcessId)
            If $g_h_GWProcess Then
                If StringRegExp(Scanner_ScanForCharname(), $a_s_GW) = 1 Then
                    ExitLoop
                EndIf
            EndIf
            Memory_Close()
            $g_h_GWProcess = 0
        Next
    Else
        $g_i_GWProcessId = $a_s_GW
        $g_h_GWWindow = Scanner_GetHwnd($g_i_GWProcessId)
        Memory_Open($a_s_GW)
        Scanner_ScanForCharname()
    EndIf

	Scanner_ClearPatterns()
    ; Core patterns
    Scanner_AddPattern('BasePointer', '506A0F6A00FF35', 0x8, 'Ptr')
    Scanner_AddPattern('Ping', '568B750889165E', -0x3, 'Ptr')
    Scanner_AddPattern('PacketSend', 'C747540000000081E6', -0x50, 'Func')
    Scanner_AddPattern('PacketLocation', '83C40433C08BE55DC3A1', 0xB, 'Ptr')
    Scanner_AddPattern('Action', '8B7508578BF983FE09750C6876', -0x3, 'Func')
    Scanner_AddPattern('ActionBase', '8D1C87899DF4', -0x3, 'Ptr')
	Scanner_AddPattern('Environment', '6BC67C5E05', 0x6, 'Ptr')
    Scanner_AddPattern('PreGame', "P:\Code\Gw\Ui\UiPregame.cpp", "!s_scene", 'Ptr')
    Scanner_AddPattern('FrameArray', "P:\Code\Engine\Frame\FrMsg.cpp", "frame", 'Ptr')
	; Skill patterns
    Scanner_AddPattern('SkillBase', '8D04B6C1E00505', 0x8, 'Ptr')
    Scanner_AddPattern('SkillTimer', 'FFD68B4DF08BD88B4708', -0x3, 'Ptr')
    Scanner_AddPattern('UseSkill', '85F6745B83FE1174', -0x125, 'Func')
    Scanner_AddPattern('UseHeroSkill', 'BA02000000B954080000', -0x59, 'Func')
	; Friend patterns
	Scanner_AddPattern('FriendList', "P:\Code\Gw\Friend\FriendApi.cpp", "friendName && *friendName", 'Ptr')
    Scanner_AddPattern('PlayerStatus', '83FE037740FF24B50000000033C0', -0x25, 'Func')
    Scanner_AddPattern('AddFriend', '8B751083FE037465', -0x47, 'Func')
    Scanner_AddPattern('RemoveFriend', '83F803741D83F8047418', 0x0, 'Func')
    ; Attribute patterns
    Scanner_AddPattern('AttributeInfo', 'BA3300000089088d4004', -0x3, 'Ptr')
    Scanner_AddPattern('IncreaseAttribute', '8B7D088B702C8B1F3B9E00050000', -0x5A, 'Func')
    Scanner_AddPattern('DecreaseAttribute', '8B8AA800000089480C5DC3CC', 0x19, 'Func')
    ; Trade patterns
    Scanner_AddPattern('Transaction', '85FF741D8B4D14EB08', -0x7E, 'Func')
    Scanner_AddPattern('BuyItemBase', 'D9EED9580CC74004', 0xF, 'Ptr')
    Scanner_AddPattern('RequestQuote', '8B752083FE107614', -0x34, 'Func')
    Scanner_AddPattern('Salvage','33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC76', -0xA, 'Func')
    Scanner_AddPattern('SalvageGlobal', '8B4A04538945F48B4208', 0x1, 'Ptr')
    ; Agent patterns
    Scanner_AddPattern('AgentBase', '8B0C9085C97419', -0x3, 'Ptr')
    Scanner_AddPattern('ChangeTarget', '3BDF0F95', -0x86, 'Func')
    Scanner_AddPattern('CurrentTarget', '83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55', -0xE, 'Ptr')
    Scanner_AddPattern('MyID', '83EC08568BF13B15', -0x3, 'Ptr')
    ; Map patterns
    Scanner_AddPattern('Move', '558BEC83EC208D45F0', 0x1, 'Func')
    Scanner_AddPattern('ClickCoords', '8B451C85C0741CD945F8', 0xD, 'Ptr')
    Scanner_AddPattern('InstanceInfo', '6A2C50E80000000083C408C7', 0xE, 'Ptr')
    Scanner_AddPattern('WorldConst', '8D0476C1E00405', 0x8, 'Ptr')
    Scanner_AddPattern('Region', '6A548D46248908', -0x3, 'Ptr')
	Scanner_AddPattern('AreaInfo', '6BC67C5E05', 0x6, 'Ptr')
	; Ui
	Scanner_AddPattern('SendUIMessage', 'B900000000E8000000005DC3894508', 0x0, 'Func')
	Scanner_AddPattern('EnterMission', 'A900001000743A', 0x52, 'Func')
	Scanner_AddPattern('SetDifficulty', '8B75086828010010', 0x71, 'Func')
	Scanner_AddPattern('OpenChest', '83C901894B24', 0x29, 'Func')
	; hook
	Scanner_AddPattern('Engine', '568B3085F67478EB038D4900D9460C', -0x22, 'Hook')
    Scanner_AddPattern('Render', 'F6C401741C68B1010000BA', -0x67, 'Hook')
	Scanner_AddPattern('HookedTrader', '50516A476A06', -0x2F, 'Hook')
	If IsDeclared("g_b_AddPattern") Then Extend_AddPattern()

    $g_ap_ScanResults = Scanner_ScanAllPatterns()


	Local $l_p_Temp
    ;Core
    $g_p_BasePointer = Memory_Read(Scanner_GetScanResult('BasePointer', $g_ap_ScanResults, 'Ptr'))
    $g_p_PacketLocation = Memory_Read(Scanner_GetScanResult('PacketLocation', $g_ap_ScanResults, 'Ptr'))
    $g_p_Ping = Memory_Read(Scanner_GetScanResult('Ping', $g_ap_ScanResults, 'Ptr'))
    $g_p_PreGame = Memory_Read(Scanner_GetScanResult('PreGame', $g_ap_ScanResults, 'Ptr') + 0x35)
    $g_p_FrameArray = Memory_Read(Scanner_GetScanResult('FrameArray', $g_ap_ScanResults, 'Ptr') - 0x13)
	Memory_SetValue('BasePointer', Ptr($g_p_BasePointer))
	Memory_SetValue('PacketLocation', Ptr($g_p_PacketLocation))
	Memory_SetValue('Ping', Ptr($g_p_Ping))
	Memory_SetValue('PreGame', Ptr($g_p_PreGame))
	Memory_SetValue('FrameArray', Ptr($g_p_FrameArray))
	Memory_SetValue('PacketSend', Ptr(Scanner_GetScanResult('PacketSend', $g_ap_ScanResults, 'Func')))
    Memory_SetValue('ActionBase', Ptr(Memory_Read(Scanner_GetScanResult('ActionBase', $g_ap_ScanResults, 'Ptr'))))
    Memory_SetValue('Action', Ptr(Scanner_GetScanResult('Action', $g_ap_ScanResults, 'Func')))
	Memory_SetValue('Environment', Ptr(Memory_GetScannedAddress('ScanEnvironmentPtr', 0x6)))
	;Core log
	Log_Debug("BasePointer: " & Memory_GetValue('BasePointer'), "Initialize", $g_h_EditText)
	Log_Debug("PacketLocation: " & Memory_GetValue('PacketLocation'), "Initialize", $g_h_EditText)
	Log_Debug("Ping: " & Memory_GetValue('Ping'), "Initialize", $g_h_EditText)
	Log_Debug("PreGame: " & Memory_GetValue('PreGame'), "Initialize", $g_h_EditText)
	Log_Debug("FrameArray: " & Memory_GetValue('FrameArray'), "Initialize", $g_h_EditText)
	Log_Debug("PacketSend: " & Memory_GetValue('PacketSend'), "Initialize", $g_h_EditText)
	Log_Debug("ActionBase: " & Memory_GetValue('ActionBase'), "Initialize", $g_h_EditText)
	Log_Debug("Action: " & Memory_GetValue('Action'), "Initialize", $g_h_EditText)
	Log_Debug("Environment: " & Memory_GetValue('Environment'), "Initialize", $g_h_EditText)

	;Skill
    $g_p_SkillBase = Memory_Read(Scanner_GetScanResult('SkillBase', $g_ap_ScanResults, 'Ptr'))
    $g_p_SkillTimer = Memory_Read(Scanner_GetScanResult('SkillTimer', $g_ap_ScanResults, 'Ptr'))
	Memory_SetValue('SkillBase', Ptr($g_p_SkillBase))
    Memory_SetValue('SkillTimer', Ptr($g_p_SkillTimer))
    Memory_SetValue('UseSkill', Ptr(Scanner_GetScanResult('UseSkill', $g_ap_ScanResults, 'Func')))
    Memory_SetValue('UseHeroSkill', Ptr(Scanner_GetScanResult('UseHeroSkill', $g_ap_ScanResults, 'Func')))
	;Skill log
	Log_Debug("SkillBase: " & Memory_GetValue('SkillBase'), "Initialize", $g_h_EditText)
	Log_Debug("SkillTimer: " & Memory_GetValue('SkillTimer'), "Initialize", $g_h_EditText)
	Log_Debug("UseSkill: " & Memory_GetValue('UseSkill'), "Initialize", $g_h_EditText)
	Log_Debug("UseHeroSkill: " & Memory_GetValue('UseHeroSkill'), "Initialize", $g_h_EditText)

	;Friend
	$g_p_FriendList = Scanner_GetScanResult('FriendList', $g_ap_ScanResults, 'Ptr')
	$g_p_FriendList = Memory_Read(Scanner_FindInRange("57B9", "xx", 2, $g_p_FriendList, $g_p_FriendList + 0xFF))
	$l_p_Temp = Scanner_GetScanResult("RemoveFriend", $g_ap_ScanResults, 'Func')
	$l_p_Temp = Scanner_FindInRange("50E8", "xx", 1, $l_p_Temp, $l_p_Temp + 0x32)
	$l_p_Temp = Scanner_FunctionFromNearCall($l_p_Temp)
    Memory_SetValue('FriendList', Ptr($g_p_FriendList))
	Memory_SetValue('PlayerStatus', Ptr(Scanner_GetScanResult("PlayerStatus", $g_ap_ScanResults, 'Func')))
    Memory_SetValue('AddFriend', Ptr(Scanner_GetScanResult("AddFriend", $g_ap_ScanResults, 'Func')))
	Memory_SetValue('RemoveFriend', Ptr($l_p_Temp))
	;Friend log
	Log_Debug("FriendList: " & Memory_GetValue('FriendList'), "Initialize", $g_h_EditText)
	Log_Debug("PlayerStatus: " & Memory_GetValue('PlayerStatus'), "Initialize", $g_h_EditText)
	Log_Debug("AddFriend: " & Memory_GetValue('AddFriend'), "Initialize", $g_h_EditText)
	Log_Debug("RemoveFriend: " & Memory_GetValue('RemoveFriend'), "Initialize", $g_h_EditText)

	;Attributes
    $g_p_AttributeInfo = Memory_Read(Scanner_GetScanResult('AttributeInfo', $g_ap_ScanResults, 'Ptr'))
    Memory_SetValue('AttributeInfo', Ptr($g_p_AttributeInfo))
    Memory_SetValue('IncreaseAttribute', Ptr(Scanner_GetScanResult('IncreaseAttribute', $g_ap_ScanResults, 'Func')))
    Memory_SetValue('DecreaseAttribute', Ptr(Scanner_GetScanResult('DecreaseAttribute', $g_ap_ScanResults, 'Func')))
	;Attributes log
	Log_Debug("AttributeInfo: " & Memory_GetValue('AttributeInfo'), "Initialize", $g_h_EditText)
	Log_Debug("IncreaseAttribute: " & Memory_GetValue('IncreaseAttribute'), "Initialize", $g_h_EditText)
	Log_Debug("DecreaseAttribute: " & Memory_GetValue('DecreaseAttribute'), "Initialize", $g_h_EditText)

	;Trade
	$g_p_BuyItemBase = Memory_Read(Scanner_GetScanResult('BuyItemBase', $g_ap_ScanResults, 'Ptr'))
    $g_p_SalvageGlobal = Memory_Read(Scanner_GetScanResult('SalvageGlobal', $g_ap_ScanResults, 'Ptr') - 0x4)
	Memory_SetValue('BuyItemBase', Ptr($g_p_BuyItemBase))
    Memory_SetValue('SalvageGlobal', Ptr($g_p_SalvageGlobal))
    Memory_SetValue('Transaction', Ptr(Scanner_GetScanResult('Transaction', $g_ap_ScanResults, 'Func')))
    Memory_SetValue('RequestQuote', Ptr(Scanner_GetScanResult('RequestQuote', $g_ap_ScanResults, 'Func')))
    Memory_SetValue('Salvage', Ptr(Scanner_GetScanResult('Salvage', $g_ap_ScanResults, 'Func')))
	;Trade log
	Log_Debug("BuyItemBase: " & Memory_GetValue('BuyItemBase'), "Initialize", $g_h_EditText)
	Log_Debug("SalvageGlobal: " & Memory_GetValue('SalvageGlobal'), "Initialize", $g_h_EditText)
	Log_Debug("Transaction: " & Memory_GetValue('Transaction'), "Initialize", $g_h_EditText)
	Log_Debug("RequestQuote: " & Memory_GetValue('RequestQuote'), "Initialize", $g_h_EditText)
	Log_Debug("Salvage: " & Memory_GetValue('Salvage'), "Initialize", $g_h_EditText)

	;Agent
	$g_p_AgentBase = Memory_Read(Scanner_GetScanResult('AgentBase', $g_ap_ScanResults, 'Ptr'))
    $g_i_MaxAgents = $g_p_AgentBase + 0x8
    $g_i_MyID = Memory_Read(Scanner_GetScanResult('MyID', $g_ap_ScanResults, 'Ptr'))
    $g_i_CurrentTarget = Memory_Read(Scanner_GetScanResult('CurrentTarget', $g_ap_ScanResults, 'Ptr'))
	Memory_SetValue('AgentBase', Ptr($g_p_AgentBase))
	Memory_SetValue('MaxAgents', Ptr($g_i_MaxAgents))
	Memory_SetValue('MyID', Ptr($g_i_MyID))
	Memory_SetValue('CurrentTarget', Ptr($g_i_CurrentTarget))
    Memory_SetValue('ChangeTarget', Ptr(Scanner_GetScanResult('ChangeTarget', $g_ap_ScanResults, 'Func') + 1))
	;Agent log
	Log_Debug("AgentBase: " & Memory_GetValue('AgentBase'), "Initialize", $g_h_EditText)
	Log_Debug("MaxAgents: " & Memory_GetValue('MaxAgents'), "Initialize", $g_h_EditText)
	Log_Debug("MyID: " & Memory_GetValue('MyID'), "Initialize", $g_h_EditText)
	Log_Debug("ChangeTarget: " & Memory_GetValue('ChangeTarget'), "Initialize", $g_h_EditText)

	;Map
	$g_p_InstanceInfo = Memory_Read(Scanner_GetScanResult('InstanceInfo', $g_ap_ScanResults, 'Ptr'))
	$g_p_WorldConst = Memory_Read(Scanner_GetScanResult('WorldConst', $g_ap_ScanResults, 'Ptr'))
	$g_f_ClickCoordsX = Memory_Read(Scanner_GetScanResult('ClickCoords', $g_ap_ScanResults, 'Ptr'))
	$g_f_ClickCoordsY = Memory_Read(Scanner_GetScanResult('ClickCoords', $g_ap_ScanResults, 'Ptr') + 9)
	$g_p_Region = Memory_Read(Scanner_GetScanResult('Region', $g_ap_ScanResults, 'Ptr'))
	$g_p_AreaInfo = Memory_Read(Scanner_GetScanResult('AreaInfo', $g_ap_ScanResults, 'Ptr'))
	Memory_SetValue('InstanceInfo', Ptr($g_p_InstanceInfo))
	Memory_SetValue('WorldConst', Ptr($g_p_WorldConst))
	Memory_SetValue('ClickCoords', Ptr($g_f_ClickCoordsX))
	Memory_SetValue('ClickCoords', Ptr($g_f_ClickCoordsY))
	Memory_SetValue('Region', Ptr($g_p_Region))
    Memory_SetValue('Move', Ptr(Scanner_GetScanResult('Move', $g_ap_ScanResults, 'Func')))
	Memory_SetValue('AreaInfo', Ptr($g_p_AreaInfo))
	;Map log
	Log_Debug("InstanceInfo: " & Memory_GetValue('InstanceInfo'), "Initialize", $g_h_EditText)
	Log_Debug("WorldConst: " & Memory_GetValue('WorldConst'), "Initialize", $g_h_EditText)
	Log_Debug("ClickCoords: " & Memory_GetValue('ClickCoords'), "Initialize", $g_h_EditText)
	Log_Debug("Region: " & Memory_GetValue('Region'), "Initialize", $g_h_EditText)
	Log_Debug("Move: " & Memory_GetValue('Move'), "Initialize", $g_h_EditText)
	Log_Debug("AreaInfo: " & Memory_GetValue('AreaInfo'), "Initialize", $g_h_EditText)

	;Ui
	$l_p_Temp = Scanner_GetScanResult('EnterMission', $g_ap_ScanResults, 'Func')
	Memory_SetValue('EnterMission', Ptr(Scanner_GetCallTargetAddress($l_p_Temp)))
	$l_p_Temp = Scanner_GetScanResult('SetDifficulty', $g_ap_ScanResults, 'Func')
	Memory_SetValue('SetDifficulty', Ptr(Scanner_GetCallTargetAddress($l_p_Temp)))
	$l_p_Temp = Scanner_GetScanResult('OpenChest', $g_ap_ScanResults, 'Func')
	Memory_SetValue('OpenChest', Ptr(Scanner_GetCallTargetAddress($l_p_Temp)))
	;Ui log
	Log_Debug("EnterMission: " & Memory_GetValue('EnterMission'), "Initialize", $g_h_EditText)
	Log_Debug("SetDifficulty: " & Memory_GetValue('SetDifficulty'), "Initialize", $g_h_EditText)

    ;Hook
    $l_p_Temp = Scanner_GetScanResult('Engine', $g_ap_ScanResults, 'Hook')
    Memory_SetValue('MainStart', Ptr($l_p_Temp))
    Memory_SetValue('MainReturn', Ptr($l_p_Temp + 0x5))
    $l_p_Temp = Scanner_GetScanResult('Render', $g_ap_ScanResults, 'Hook')
    Memory_SetValue('RenderingMod', Ptr($l_p_Temp))
    Memory_SetValue('RenderingModReturn', Ptr($l_p_Temp + 0xA))
    $l_p_Temp = Scanner_GetScanResult('HookedTrader', $g_ap_ScanResults, 'Hook')
    Memory_SetValue('TraderStart', Ptr($l_p_Temp))
    Memory_SetValue('TraderReturn', Ptr($l_p_Temp + 0x5))
	;Hook log
	Log_Debug("MainStart: " & Memory_GetValue('MainStart'), "Initialize", $g_h_EditText)
	Log_Debug("MainReturn: " & Memory_GetValue('MainReturn'), "Initialize", $g_h_EditText)
	Log_Debug("RenderingMod: " & Memory_GetValue('RenderingMod'), "Initialize", $g_h_EditText)
	Log_Debug("RenderingModReturn: " & Memory_GetValue('RenderingModReturn'), "Initialize", $g_h_EditText)
	Log_Debug("TraderStart: " & Memory_GetValue('TraderStart'), "Initialize", $g_h_EditText)
	Log_Debug("TraderReturn: " & Memory_GetValue('TraderReturn'), "Initialize", $g_h_EditText)
	If IsDeclared("g_b_Scanner") Then Extend_Scanner()


	Memory_SetValue('QueueSize', '0x00000010')


    ; Modify memory
    Assembler_ModifyMemory()

	$g_i_AgentCopyCount = Memory_GetValue('AgentCopyCount')
    $g_p_AgentCopyBase = Memory_GetValue('AgentCopyBase')
    $g_i_TraderQuoteID = Memory_GetValue('TraderQuoteID')
    $g_i_TraderCostID = Memory_GetValue('TraderCostID')
    $g_f_TraderCostValue = Memory_GetValue('TraderCostValue')
	$g_i_QueueCounter = Memory_Read(Memory_GetValue('QueueCounter'))
    $g_i_QueueSize = Memory_GetValue('QueueSize') - 1
    $g_p_QueueBase = Memory_GetValue('QueueBase')
    $g_b_DisableRendering = Memory_GetValue('DisableRendering')
	If IsDeclared("g_b_InitializeResult") Then Extend_InitializeResult()


    ; Setup command structures
    DllStructSetData($g_d_InviteGuild, 1, Memory_GetValue('CommandPacketSend'))
    DllStructSetData($g_d_Packet, 1, Memory_GetValue('CommandPacketSend'))
    DllStructSetData($g_d_Action, 1, Memory_GetValue('CommandAction'))
    DllStructSetData($g_d_SendChat, 1, Memory_GetValue('CommandSendChat'))
    DllStructSetData($g_d_SendChat, 2, 0x0063)
	;Skill
	DllStructSetData($g_d_UseSkill, 1, Memory_GetValue('CommandUseSkill'))
    DllStructSetData($g_d_UseHeroSkill, 1, Memory_GetValue('CommandUseHeroSkill'))
	;Friend
	DllStructSetData($g_d_ChangeStatus, 1, Memory_GetValue('CommandPlayerStatus'))
    DllStructSetData($g_d_AddFriend, 1, Memory_GetValue('CommandAddFriend'))
    DllStructSetData($g_d_RemoveFriend, 1, Memory_GetValue('CommandRemoveFriend'))
	;Attribute
	DllStructSetData($g_d_IncreaseAttribute, 1, Memory_GetValue('CommandIncreaseAttribute'))
    DllStructSetData($g_d_DecreaseAttribute, 1, Memory_GetValue('CommandDecreaseAttribute'))
	;Trade
	DllStructSetData($g_d_SellItem, 1, Memory_GetValue('CommandSellItem'))
    DllStructSetData($g_d_BuyItem, 1, Memory_GetValue('CommandBuyItem'))
    DllStructSetData($g_d_RequestQuote, 1, Memory_GetValue('CommandRequestQuote'))
    DllStructSetData($g_d_RequestQuoteSell, 1, Memory_GetValue('CommandRequestQuoteSell'))
    DllStructSetData($g_d_TraderBuy, 1, Memory_GetValue('CommandTraderBuy'))
    DllStructSetData($g_d_TraderSell, 1, Memory_GetValue('CommandTraderSell'))
    DllStructSetData($g_d_Salvage, 1, Memory_GetValue('CommandSalvage'))
	;Agent
	DllStructSetData($g_d_ChangeTarget, 1, Memory_GetValue('CommandChangeTarget'))
    DllStructSetData($g_d_MakeAgentArray, 1, Memory_GetValue('CommandMakeAgentArray'))
	;Map
	DllStructSetData($g_d_Move, 1, Memory_GetValue('CommandMove'))
	;Ui
	DllStructSetData($g_d_EnterMission, 1, Memory_GetValue('CommandEnterMission'))
	DllStructSetData($g_d_SetDifficulty, 1, Memory_GetValue('CommandSetDifficulty'))
	DllStructSetData($g_d_OpenChest, 1, Memory_GetValue('CommandOpenChest'))

    If $a_b_ChangeTitle Then WinSetTitle($g_h_GWWindow, '', 'Guild Wars - ' & Player_GetCharname())

    Log_Info("End of Initialization", "GwAu3", $g_h_EditText)
    Return $g_h_GWWindow
EndFunc
#EndRegion Initialization

Func Core_Enqueue($a_p_Ptr, $a_i_Size)
	DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'int', 256 * $g_i_QueueCounter + $g_p_QueueBase, 'ptr', $a_p_Ptr, 'int', $a_i_Size, 'int', '')
	If $g_i_QueueCounter = $g_i_QueueSize Then
		$g_i_QueueCounter = 0
	Else
		$g_i_QueueCounter = $g_i_QueueCounter + 1
	EndIf
EndFunc

Func Core_PerformAction($a_i_Action, $a_i_Flag)
	DllStructSetData($g_d_Action, 2, $a_i_Action)
	DllStructSetData($g_d_Action, 3, $a_i_Flag)
	Core_Enqueue($g_p_Action, 12)
EndFunc

Func Core_SendPacket($a_i_Size, $a_i_Header, $a_i_Param1 = 0, $a_i_Param2 = 0, $a_i_Param3 = 0, $a_i_Param4 = 0, $a_i_Param5 = 0, $a_i_Param6 = 0, $a_i_Param7 = 0, $a_i_Param8 = 0, $a_i_Param9 = 0, $a_i_Param10 = 0)
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
	Core_Enqueue($g_p_Packet, 52)
EndFunc

Func Core_ControlAction($a_i_Action, $a_i_ActionType = $GC_I_ACTIONTYPE_ACTIVATE)
	Return Core_PerformAction($a_i_Action, $a_i_ActionType)
EndFunc

Func Core_AutoStart()
	If $g_bAutoStart And $g_s_MainCharName <> "" Then
		Sleep(2000)
		StartBot()
		Local $l_h_GWWindow = Core_GetGuildWarsWindow()
		If $l_h_GWWindow = 0 Then
			_Exit()
		EndIf

		If PreGame_Ptr() <> 0 Then

			Local $l_i_currentIndex = PreGame_ChosenCharacter()
			Local $l_s_currentName = StringStripWS(PreGame_CharName($l_i_currentIndex), 3)

			If StringCompare($l_s_currentName, $g_s_MainCharName, 0) <> 0 Then
				Local $l_b_found = False
				Local $l_i_maxAttempts = 20
				Local $l_i_attempts = 0
				Local $l_i_initialIndex = $l_i_currentIndex

				While $l_i_attempts < $l_i_maxAttempts And Not $l_b_found
					ControlSend($l_h_GWWindow, "", "", "{RIGHT}")
					Sleep(250)

					$l_i_currentIndex = PreGame_ChosenCharacter()
					$l_s_currentName = StringStripWS(PreGame_CharName($l_i_currentIndex), 3)

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

			While PreGame_Ptr() <> 0
				Sleep(500)
			WEnd
			Map_WaitMapLoading()
			Sleep(1000)
		EndIf
	EndIf
EndFunc

Func Core_GetGuildWarsWindow()
    Local $l_s_expectedTitle = "Guild Wars - " & $g_s_MainCharName

    Local $l_h_Wnd = WinGetHandle($l_s_expectedTitle)
    If $l_h_Wnd <> 0 Then Return $l_h_Wnd
EndFunc