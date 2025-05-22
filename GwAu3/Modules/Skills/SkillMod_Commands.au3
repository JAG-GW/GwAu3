#include-once
#include "SkillMod_Initialize.au3"

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_UseSkill
; Description ...: Uses a skill
; Syntax.........: _SkillMod_UseSkill($iSkillSlot, $iTargetID = 0, $iCallTarget = 0)
; Parameters ....: $iSkillSlot    - ID of the skill to use (1-8)
;                  $iTargetID   - [optional] Target ID (default: 0)
;                  $iCallTarget - [optional] Call Target (default: False)
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Skill must be available on the skill bar
;                  - Cooldown is not checked by this function
; Related .......: _SkillMod_UseHeroSkill, _SkillMod_GetSkillRecharge
;============================================================================================
Func _SkillMod_UseSkill($iSkillSlot, $iTargetID = 0, $iCallTarget = False)
    If Not $g_bSkillModuleInitialized Then
        _Log_Error("SkillMod module not initialized", "SkillMod", $GUIEdit)
        Return False
    EndIf

    If $iSkillSlot < 1 Or $iSkillSlot > 8 Then
        _Log_Error("Invalid skill ID: " & $iSkillSlot, "SkillMod", $GUIEdit)
        Return False
    EndIf

    DllStructSetData($g_mUseSkill, 2, $iSkillSlot)
    DllStructSetData($g_mUseSkill, 3, ConvertID($iTargetID))
    DllStructSetData($g_mUseSkill, 4, $iCallTarget)

    Enqueue($g_mUseSkillPtr, 16)

    ; Record for tracking
    $g_iLastSkillUsed = $iSkillSlot
    $g_iLastSkillTarget = ConvertID($iTargetID)

    _Log_Debug("Used skill slot: " & $iSkillSlot & " on target: " & ConvertID($iTargetID), "SkillMod", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _SkillMod_UseHeroSkill
; Description ...: Makes a hero use a skill
; Syntax.........: _SkillMod_UseHeroSkill($iHeroIndex, $iSkillSlot, $iTargetID = 0)
; Parameters ....: $iHeroIndex - Hero index (1-8 for heroes)
;                  $iSkillSlot   - Skill slot position (1-8)
;                  $iTargetID  - [optional] Target ID (default: 0)
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Hero must be in the party
;                  - Skill must be available on the hero's skill bar
; Related .......: _SkillMod_UseSkill
;============================================================================================
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

    DllStructSetData($g_mUseHeroSkill, 2, GetMyPartyHeroInfo($iHeroIndex, "AgentID"))
	DllStructSetData($g_mUseHeroSkill, 3, ConvertID($iTargetID))
    DllStructSetData($g_mUseHeroSkill, 4, $iSkillSlot -1)

    Enqueue($g_mUseHeroSkillPtr, 16)

    _Log_Debug("Hero " & $iHeroIndex & " used skill " & $iSkillSlot & " on target: " & ConvertID($iTargetID), "SkillMod", $GUIEdit)
    Return True
EndFunc
