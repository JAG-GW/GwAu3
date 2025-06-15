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

	DllStructSetData($g_mUseSkill, 1, GwAu3_Memory_GetValue('CommandUseSkill'))
    DllStructSetData($g_mUseSkill, 2, GwAu3_OtherMod_GetWorldInfo("MyID"))
    DllStructSetData($g_mUseSkill, 3, $iSkillSlot)
    DllStructSetData($g_mUseSkill, 4, $iAgentID)
    DllStructSetData($g_mUseSkill, 5, $iCallTarget)

    GwAu3_Core_Enqueue($g_mUseSkillPtr, 20)

    $g_iLastSkillUsed = $iSkillSlot + 1
    $g_iLastSkillTarget = GwAu3_AgentMod_ConvertID($iTargetID)

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

	DllStructSetData($g_mUseHeroSkill, 1, GwAu3_Memory_GetValue('CommandUseHeroSkill'))
    DllStructSetData($g_mUseHeroSkill, 2, $iHeroIndex)
	DllStructSetData($g_mUseHeroSkill, 3, $iTargetID)
    DllStructSetData($g_mUseHeroSkill, 4, $iSkillSlot)

    GwAu3_Core_Enqueue($g_mUseHeroSkillPtr, 16)

    GwAu3_Log_Debug("Hero " & $iHeroIndex & " used skill " & ($iSkillSlot + 1) & " on target: " & $iTargetID, "SkillMod", $g_h_EditText)
    Return True
EndFunc