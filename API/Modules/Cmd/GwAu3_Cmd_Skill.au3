#include-once

Func Skill_UseSkill($a_i_SkillSlot, $a_v_TargetID = 0, $a_b_CallTarget = False)
    If $a_i_SkillSlot < 1 Or $a_i_SkillSlot > 8 Then
        Log_Error("Invalid skill ID: " & $a_i_SkillSlot, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    Local $l_i_AgentID = Agent_ConvertID($a_v_TargetID)
    If $l_i_AgentID = 0 Then
        Log_Error("Target not found: " & $l_i_AgentID, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    $a_i_SkillSlot = $a_i_SkillSlot - 1

    DllStructSetData($g_d_UseSkill, 2, World_GetWorldInfo("MyID"))
    DllStructSetData($g_d_UseSkill, 3, $a_i_SkillSlot)
    DllStructSetData($g_d_UseSkill, 4, $l_i_AgentID)
    DllStructSetData($g_d_UseSkill, 5, $a_b_CallTarget)

    Core_Enqueue($g_p_UseSkill, 20)

    $g_i_LastSkillUsed = $a_i_SkillSlot + 1
    $g_i_LastSkillTarget = Agent_ConvertID($a_v_TargetID)

    Log_Debug("Used skill slot: " & ($a_i_SkillSlot + 1) & " on target: " & Agent_ConvertID($a_v_TargetID), "SkillMod", $g_h_EditText)
    Return True
EndFunc

Func Skill_UseHeroSkill($a_i_HeroIndex, $a_i_SkillSlot, $a_v_TargetID = 0)
    If $a_i_HeroIndex < 1 Or $a_i_HeroIndex > 8 Then
        Log_Error("Invalid hero index: " & $a_i_HeroIndex, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_SkillSlot < 1 Or $a_i_SkillSlot > 8 Then
        Log_Error("Invalid skill slot: " & $a_i_SkillSlot, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    $a_i_HeroIndex = Party_GetMyPartyHeroInfo($a_i_HeroIndex, "AgentID")
    If $a_i_HeroIndex = 0 Then
        Log_Error("Hero not found or not in party: " & $a_i_HeroIndex, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    $a_v_TargetID = Agent_ConvertID($a_v_TargetID)
    If $a_v_TargetID = 0 Then
        Log_Error("Target not found: " & $a_v_TargetID, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    $a_i_SkillSlot = $a_i_SkillSlot - 1

    DllStructSetData($g_d_UseHeroSkill, 2, $a_i_HeroIndex)
    DllStructSetData($g_d_UseHeroSkill, 3, $a_v_TargetID)
    DllStructSetData($g_d_UseHeroSkill, 4, $a_i_SkillSlot)

    Core_Enqueue($g_p_UseHeroSkill, 16)

    Log_Debug("Hero " & $a_i_HeroIndex & " used skill " & ($a_i_SkillSlot + 1) & " on target: " & $a_v_TargetID, "SkillMod", $g_h_EditText)
    Return True
EndFunc

;~ Description: Change a skill on the skillbar.
Func Skill_SetSkillbarSkill($a_i_Slot, $a_i_SkillID, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Else
        $l_i_HeroID = World_GetWorldInfo("MyID")
    EndIf
    Return Core_SendPacket(0x14, $GC_I_HEADER_SKILLBAR_SKILL_SET, $l_i_HeroID, $a_i_Slot - 1, $a_i_SkillID, 0)
EndFunc   ;==>SetSkillbarSkill

;~ Description: Load all skills onto a skillbar simultaneously.
Func Skill_LoadSkillBar($a_i_Skill1 = 0, $a_i_Skill2 = 0, $a_i_Skill3 = 0, $a_i_Skill4 = 0, $a_i_Skill5 = 0, $a_i_Skill6 = 0, $a_i_Skill7 = 0, $a_i_Skill8 = 0, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Else
        $l_i_HeroID = World_GetWorldInfo("MyID")
    EndIf
    Return Core_SendPacket(0x2C, $GC_I_HEADER_SKILLBAR_LOAD, $l_i_HeroID, 8, $a_i_Skill1, $a_i_Skill2, $a_i_Skill3, $a_i_Skill4, $a_i_Skill5, $a_i_Skill6, $a_i_Skill7, $a_i_Skill8)
EndFunc   ;==>LoadSkillBar

