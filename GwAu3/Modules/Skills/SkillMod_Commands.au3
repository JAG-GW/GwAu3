#include-once

Func GwAu3_SkillMod_UseSkill($iSkillSlot, $iTargetID = 0, $iCallTarget = False)
    If $iSkillSlot < 1 Or $iSkillSlot > 8 Then
        GwAu3_Log_Error("Invalid skill ID: " & $iSkillSlot, "SkillMod", $g_h_EditText)
        Return False
    EndIf

	Local $iAgentID = GwAu3_AgentMod_ConvertID($iTargetID)
    If $iAgentID = 0 Then
        GwAu3_Log_Error("Target not found: " & $iAgentID, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    $iSkillSlot = $iSkillSlot - 1

	DllStructSetData($g_d_UseSkill, 1, GwAu3_Memory_GetValue('CommandUseSkill'))
    DllStructSetData($g_d_UseSkill, 2, GwAu3_OtherMod_GetWorldInfo("MyID"))
    DllStructSetData($g_d_UseSkill, 3, $iSkillSlot)
    DllStructSetData($g_d_UseSkill, 4, $iAgentID)
    DllStructSetData($g_d_UseSkill, 5, $iCallTarget)

    GwAu3_Core_Enqueue($g_p_UseSkill, 20)

    $g_i_LastSkillUsed = $iSkillSlot + 1
    $g_i_LastSkillTarget = GwAu3_AgentMod_ConvertID($iTargetID)

    GwAu3_Log_Debug("Used skill slot: " & ($iSkillSlot + 1) & " on target: " & GwAu3_AgentMod_ConvertID($iTargetID), "SkillMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_SkillMod_UseHeroSkill($iHeroIndex, $iSkillSlot, $iTargetID = 0)
    If $iHeroIndex < 1 Or $iHeroIndex > 8 Then
        GwAu3_Log_Error("Invalid hero index: " & $iHeroIndex, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    If $iSkillSlot < 1 Or $iSkillSlot > 8 Then
        GwAu3_Log_Error("Invalid skill slot: " & $iSkillSlot, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    $iHeroIndex = GwAu3_PartyMod_GetMyPartyHeroInfo($iHeroIndex, "AgentID")
    If $iHeroIndex = 0 Then
        GwAu3_Log_Error("Hero not found or not in party: " & $iHeroIndex, "SkillMod", $g_h_EditText)
        Return False
    EndIf

	$iTargetID = GwAu3_AgentMod_ConvertID($iTargetID)
    If $iTargetID = 0 Then
        GwAu3_Log_Error("Target not found: " & $iTargetID, "SkillMod", $g_h_EditText)
        Return False
    EndIf

    $iSkillSlot = $iSkillSlot - 1

	DllStructSetData($g_d_UseHeroSkill, 1, GwAu3_Memory_GetValue('CommandUseHeroSkill'))
    DllStructSetData($g_d_UseHeroSkill, 2, $iHeroIndex)
	DllStructSetData($g_d_UseHeroSkill, 3, $iTargetID)
    DllStructSetData($g_d_UseHeroSkill, 4, $iSkillSlot)

    GwAu3_Core_Enqueue($g_p_UseHeroSkill, 16)

    GwAu3_Log_Debug("Hero " & $iHeroIndex & " used skill " & ($iSkillSlot + 1) & " on target: " & $iTargetID, "SkillMod", $g_h_EditText)
    Return True
EndFunc