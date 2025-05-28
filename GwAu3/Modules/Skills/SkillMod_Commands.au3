#include-once
#include "SkillMod_Initialize.au3"

Func _SkillMod_UseSkill($iSkillSlot, $iTargetID = 0, $iCallTarget = False)
    If Not $g_bSkillModuleInitialized Then
        _Log_Error("SkillMod module not initialized", "SkillMod", $GUIEdit)
        Return False
    EndIf

    If $iSkillSlot < 1 Or $iSkillSlot > 8 Then
        _Log_Error("Invalid skill ID: " & $iSkillSlot, "SkillMod", $GUIEdit)
        Return False
    EndIf

	Local $iAgentID = ConvertID($iTargetID)
    If $iAgentID = 0 Then
        _Log_Error("Target not found: " & $iAgentID, "SkillMod", $GUIEdit)
        Return False
    EndIf

    $iSkillSlot = $iSkillSlot - 1

	DllStructSetData($g_mUseSkill, 1, GetValue('CommandUseSkill'))
    DllStructSetData($g_mUseSkill, 2, GetWorldInfo("MyID"))
    DllStructSetData($g_mUseSkill, 3, $iSkillSlot)
    DllStructSetData($g_mUseSkill, 4, $iAgentID)
    DllStructSetData($g_mUseSkill, 5, $iCallTarget)

    Enqueue($g_mUseSkillPtr, 20)

    $g_iLastSkillUsed = $iSkillSlot + 1
    $g_iLastSkillTarget = ConvertID($iTargetID)

    _Log_Debug("Used skill slot: " & ($iSkillSlot + 1) & " on target: " & ConvertID($iTargetID), "SkillMod", $GUIEdit)
    Return True
EndFunc

Func _SkillMod_UseHeroSkill($iHeroIndex, $iSkillSlot, $iTargetID = 0)
    If Not $g_bSkillModuleInitialized Then
        _Log_Error("SkillMod module not initialized", "SkillMod", $GUIEdit)
        Return False
    EndIf

    If $iHeroIndex < 1 Or $iHeroIndex > 8 Then
        _Log_Error("Invalid hero index: " & $iHeroIndex, "SkillMod", $GUIEdit)
        Return False
    EndIf

    If $iSkillSlot < 1 Or $iSkillSlot > 8 Then
        _Log_Error("Invalid skill slot: " & $iSkillSlot, "SkillMod", $GUIEdit)
        Return False
    EndIf

    $iHeroIndex = GetMyPartyHeroInfo($iHeroIndex, "AgentID")
    If $iHeroIndex = 0 Then
        _Log_Error("Hero not found or not in party: " & $iHeroIndex, "SkillMod", $GUIEdit)
        Return False
    EndIf

	$iTargetID = ConvertID($iTargetID)
    If $iTargetID = 0 Then
        _Log_Error("Target not found: " & $iTargetID, "SkillMod", $GUIEdit)
        Return False
    EndIf

    $iSkillSlot = $iSkillSlot - 1

	DllStructSetData($g_mUseHeroSkill, 1, GetValue('CommandUseHeroSkill'))
    DllStructSetData($g_mUseHeroSkill, 2, $iHeroIndex)
	DllStructSetData($g_mUseHeroSkill, 3, $iTargetID)
    DllStructSetData($g_mUseHeroSkill, 4, $iSkillSlot)

    Enqueue($g_mUseHeroSkillPtr, 16)

    _Log_Debug("Hero " & $iHeroIndex & " used skill " & ($iSkillSlot + 1) & " on target: " & $iTargetID, "SkillMod", $GUIEdit)
    Return True
EndFunc