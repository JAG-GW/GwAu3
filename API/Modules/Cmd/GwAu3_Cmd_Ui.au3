#include-once

;~ Description: Sends dialog ID.
Func Ui_Dialog($a_i_DialogID)
    DllStructSetData($g_d_Dialog, 2, $a_i_DialogID)
    Core_Enqueue($g_p_Dialog, 8)
EndFunc   ;==>Ui_Dialog

;~ Description: Open targeted chest using dialog options. (0x1 = Use Key, 0x2 = Use Lockpick, 0x80 = Cancel)
Func Ui_OpenChest($a_b_UseLockpick = True)
    If $a_b_UseLockpick Then
        DllStructSetData($g_d_OpenChest, 2, 0x2)
    Else
        DllStructSetData($g_d_OpenChest, 2, 0x1)
    EndIf
    Core_Enqueue($g_p_OpenChest, 8)
EndFunc   ;==>Ui_OpenChest

;~ Description: Command a hero via flag.
Func Ui_CommandHero($a_i_HeroNumber, $a_f_X, $a_f_Y)
    DllStructSetData($g_d_FlagHero, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_FlagHero, 3, Utils_FloatToInt($a_f_X))
    DllStructSetData($g_d_FlagHero, 4, Utils_FloatToInt($a_f_Y))
    DllStructSetData($g_d_FlagHero, 5, 0) ; zPos
    Core_Enqueue($g_p_FlagHero, 20)
EndFunc   ;==>Ui_CommandHero

;~ Description: Clear the position flag of a hero.
Func Ui_CancelHero($a_i_HeroNumber)
    DllStructSetData($g_d_FlagHero, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_FlagHero, 3, 0x7F800000)
    DllStructSetData($g_d_FlagHero, 4, 0x7F800000)
    DllStructSetData($g_d_FlagHero, 5, 0) ; zPos
    Core_Enqueue($g_p_FlagHero, 20)
EndFunc   ;==>Ui_CancelHero

;~ Description: Command all heroes via flag.
Func Ui_CommandAll($a_f_X, $a_f_Y)
    DllStructSetData($g_d_FlagAll, 2, Utils_FloatToInt($a_f_X))
    DllStructSetData($g_d_FlagAll, 3, Utils_FloatToInt($a_f_Y))
    DllStructSetData($g_d_FlagAll, 4, 0) ; zPos
    Core_Enqueue($g_p_FlagAll, 16)
EndFunc   ;==>Ui_CommandAll

;~ Description: Clear the position flag of all heroes.
Func Ui_CancelAll()
    DllStructSetData($g_d_FlagAll, 2, 0x7F800000)
    DllStructSetData($g_d_FlagAll, 3, 0x7F800000)
    DllStructSetData($g_d_FlagAll, 4, 0) ; zPos
    Core_Enqueue($g_p_FlagAll, 16)
EndFunc   ;==>Ui_CancelAll

;~ Description: Sets hero behavior (0 = Fight, 1 = Guard, 2 = Avoid Combat).
Func Ui_SetHeroBehavior($a_i_HeroNumber, $a_i_Behavior = 1)
    DllStructSetData($g_d_SetHeroBehavior, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_SetHeroBehavior, 3, $a_i_Behavior)
    Core_Enqueue($g_p_SetHeroBehavior, 12)
EndFunc   ;==>Ui_SetHeroBehavior

;~ Description: Commands hero to drop held bundle.
Func Ui_DropHeroBundle($a_i_HeroNumber)
    DllStructSetData($g_d_DropHeroBundle, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    Core_Enqueue($g_p_DropHeroBundle, 8)
EndFunc   ;==>Ui_DropHeroBundle

;~ Description: Locks hero onto a target (0 = remove lock).
Func Ui_LockHeroTarget($a_i_HeroNumber, $a_i_TargetAgentID = 0)
    DllStructSetData($g_d_LockHeroTarget, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_LockHeroTarget, 3, Agent_ConvertID($a_i_TargetAgentID))
    Core_Enqueue($g_p_LockHeroTarget, 12)
EndFunc   ;==>Ui_LockHeroTarget

;~ Description: Toggles state of a hero skill (enabled/disabled).
Func Ui_ToggleHeroSkillState($a_i_HeroNumber, $a_i_Skillslot)
    DllStructSetData($g_d_ToggleHeroSkillState, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_ToggleHeroSkillState, 3, $a_i_Skillslot - 1)
    Core_Enqueue($g_p_ToggleHeroSkillState, 12)
EndFunc   ;==>Ui_ToggleHeroSkillState

;~ Description: Enable a skill on a hero's skill bar.
Func Ui_EnableHeroSkill($a_i_HeroNumber, $a_i_SkillSlot)
	If Party_GetIsHeroSkillDisabled($a_i_HeroNumber, $a_i_SkillSlot) Then Ui_ToggleHeroSkillState($a_i_HeroNumber, $a_i_SkillSlot)
EndFunc   ;==>Ui_EnableHeroSkill

;~ Description: Disable a skill on a hero's skill bar.
Func Ui_DisableHeroSkill($a_i_HeroNumber, $a_i_SkillSlot)
	If Not Party_GetIsHeroSkillDisabled($a_i_HeroNumber, $a_i_SkillSlot) Then Ui_ToggleHeroSkillState($a_i_HeroNumber, $a_i_SkillSlot)
	Return True
EndFunc   ;==>Ui_DisableHeroSkill

;~ Description: Add NPC via the Party Search window.
Func Ui_AddNPC($a_i_AgentID)
    DllStructSetData($g_d_AddNPC, 2, $a_i_AgentID)
    Core_Enqueue($g_p_AddNPC, 8)
EndFunc   ;==>Ui_AddNPC

;~ Description: Add hero via the Party Search window.
Func Ui_AddHero($a_i_HeroID)
    DllStructSetData($g_d_AddHero, 2, $a_i_HeroID)
    Core_Enqueue($g_p_AddHero, 8)
EndFunc   ;==>Ui_AddHero

;~ Description: Kick NPC via the Party Search window.
Func Ui_KickNPC($a_i_AgentID)
    DllStructSetData($g_d_KickNPC, 2, $a_i_AgentID)
    Core_Enqueue($g_p_KickNPC, 8)
EndFunc   ;==>Ui_KickNPC

;~ Description: Kick hero via the Party Search window.
Func Ui_KickHero($a_i_HeroID)
    DllStructSetData($g_d_KickHero, 2, $a_i_HeroID)
    Core_Enqueue($g_p_KickHero, 8)
EndFunc   ;==>Ui_KickHero

;~ Description: Kicks all heroes from the group.
Func Ui_KickAllHeroes()
    DllStructSetData($g_d_KickHero, 2, 0x26)
    Core_Enqueue($g_p_KickHero, 8)
EndFunc   ;==>Ui_KickAllHeroes

;~ Description: Leaves group via Party Formation window. Optional flag to keep/kick heroes.
Func Ui_LeaveGroup($a_b_KickAllHeroes = True)
    DllStructSetData($g_d_LeaveGroup, 2, 0x26)
    Core_Enqueue($g_p_LeaveGroup, 8)
    If $a_b_KickAllHeroes Then Ui_KickAllHeroes()
EndFunc   ;==>Ui_LeaveGroup

;~ Description: Sets difficulty via Party Formation window. (False = NM, True = HM)
Func Ui_SetDifficulty($a_b_HardMode = False)
    DllStructSetData($g_d_SetDifficulty, 2, $a_b_HardMode)
    Core_Enqueue($g_p_SetDifficulty, 8)
EndFunc   ;==>Ui_SetDifficulty

;~ Description: Enters Mission/Challenge via Party Formation window. (False = Foreign Character, True = Native Character)
Func Ui_EnterChallenge($a_b_Foreign = False, $a_WaitToLoad = True)
    DllStructSetData($g_d_EnterMission, 2, Not $a_b_Foreign)
    Core_Enqueue($g_p_EnterMission, 8)
	If $a_WaitToLoad Then Return Map_WaitMapLoading(-1, 1)
EndFunc   ;==>Ui_EnterChallenge

;~ Description: Initiates map travel.
Func Ui_MoveMap($a_i_MapID, $a_i_Region, $a_i_Language, $a_i_District)
    DllStructSetData($g_d_MoveMap, 2, 0x1000017A)
    DllStructSetData($g_d_MoveMap, 3, $a_i_MapID)
    DllStructSetData($g_d_MoveMap, 4, $a_i_Region)
    DllStructSetData($g_d_MoveMap, 5, $a_i_Language)
    DllStructSetData($g_d_MoveMap, 6, $a_i_District)
    Core_Enqueue($g_p_MoveMap, 24)
EndFunc   ;==>Ui_MoveMap

;~ Description: Enable graphics rendering.
Func Ui_EnableRendering()
    If Ui_GetRenderEnabled() Then Return 1
    Memory_Write($g_b_DisableRendering, 0)
EndFunc ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func Ui_DisableRendering()
    If Ui_GetRenderDisabled() Then Return 1
    Memory_Write($g_b_DisableRendering, 1)
EndFunc ;==>DisableRendering

;~ Description: Toggle Rendering *and* Window State
Func Ui_ToggleRendering()
    If Ui_GetRenderDisabled() Then
        Ui_EnableRendering()
        WinSetState(Scanner_GetWindowHandle(), "", @SW_SHOW)
    Else
        Ui_DisableRendering()
        WinSetState(Scanner_GetWindowHandle(), "", @SW_HIDE)
        Memory_Clear()
    EndIf
EndFunc ;==>ToggleRendering

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
;~              Also toggles Window State
Func Ui_PurgeHook($a_i_Time = 10000)
    If Ui_GetRenderEnabled() Then Return 1
    Ui_ToggleRendering()
    Sleep($a_i_Time)
    Ui_ToggleRendering()
EndFunc ;==>PurgeHook

;~ Description: Toggle Rendering (the GW window will stay hidden)
Func Ui_ToggleRendering_()
    If Ui_GetRenderDisabled() Then
        Ui_EnableRendering()
    Else
        Ui_DisableRendering()
        Memory_Clear()
    EndIf
EndFunc ;==>ToggleRendering_

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
Func Ui_PurgeHook_($a_i_Time = 10000)
    If Ui_GetRenderEnabled() Then Return 1
    Ui_ToggleRendering_()
    Sleep($a_i_Time)
    Ui_ToggleRendering_()
EndFunc ;==PurgeHook_
