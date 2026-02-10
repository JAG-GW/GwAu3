#include-once

; ========== Static Skill data ==========
Global $g_amx2_StaticSkillCache[9][43]

Global Enum $GC_UAI_STATIC_SKILL_SkillID, _
    $GC_UAI_STATIC_SKILL_Campaign, _
    $GC_UAI_STATIC_SKILL_SkillType, _
    $GC_UAI_STATIC_SKILL_Special, _
	$GC_UAI_STATIC_SKILL_ComboReq, _
    $GC_UAI_STATIC_SKILL_Effect1, _
    $GC_UAI_STATIC_SKILL_Condition, _
    $GC_UAI_STATIC_SKILL_Effect2, _
    $GC_UAI_STATIC_SKILL_WeaponReq, _
    $GC_UAI_STATIC_SKILL_Profession, _
    $GC_UAI_STATIC_SKILL_Attribute, _
    $GC_UAI_STATIC_SKILL_Title, _
    $GC_UAI_STATIC_SKILL_SkillIDPvP, _
    $GC_UAI_STATIC_SKILL_Combo, _
    $GC_UAI_STATIC_SKILL_Target, _
    $GC_UAI_STATIC_SKILL_SkillEquipType, _
    $GC_UAI_STATIC_SKILL_Overcast, _
    $GC_UAI_STATIC_SKILL_EnergyCost, _
    $GC_UAI_STATIC_SKILL_HealthCost, _
    $GC_UAI_STATIC_SKILL_Adrenaline, _
    $GC_UAI_STATIC_SKILL_Activation, _
    $GC_UAI_STATIC_SKILL_Aftercast, _
    $GC_UAI_STATIC_SKILL_Duration0, _
    $GC_UAI_STATIC_SKILL_Duration15, _
    $GC_UAI_STATIC_SKILL_Recharge, _
    $GC_UAI_STATIC_SKILL_SkillArguments, _
    $GC_UAI_STATIC_SKILL_Scale0, _
    $GC_UAI_STATIC_SKILL_Scale15, _
    $GC_UAI_STATIC_SKILL_BonusScale0, _
    $GC_UAI_STATIC_SKILL_BonusScale15, _
    $GC_UAI_STATIC_SKILL_AoeRange, _
    $GC_UAI_STATIC_SKILL_ConstEffect, _
    $GC_UAI_STATIC_SKILL_CasterOverheadAnimationID, _
    $GC_UAI_STATIC_SKILL_CasterBodyAnimationID, _
    $GC_UAI_STATIC_SKILL_TargetBodyAnimationID, _
    $GC_UAI_STATIC_SKILL_TargetOverheadAnimationID, _
    $GC_UAI_STATIC_SKILL_ProjectileAnimation1ID, _
    $GC_UAI_STATIC_SKILL_ProjectileAnimation2ID, _
    $GC_UAI_STATIC_SKILL_IconFileID, _
    $GC_UAI_STATIC_SKILL_IconFileID2, _
	$GC_UAI_STATIC_SKILL_IconFileIDHD, _
    $GC_UAI_STATIC_SKILL_Name, _
    $GC_UAI_STATIC_SKILL_Concise, _
    $GC_UAI_STATIC_SKILL_Description

; ========== Cache Static Skill data ==========
Func UAI_StaticDataSkill($a_i_SkillID)
    Static $ss_StructInfo = Memory_CreateStructure( _
        "long SkillID[0x0];" & _
        "long Campaign[0x8];" & _
        "long SkillType[0xC];" & _
        "long Special[0x10];" & _
        "long ComboReq[0x14];" & _
        "long Effect1[0x18];" & _
        "long Condition[0x1C];" & _
        "long Effect2[0x20];" & _
        "long WeaponReq[0x24];" & _
        "byte Profession[0x28];" & _
        "byte Attribute[0x29];" & _
        "word Title[0x2A];" & _
        "long SkillIDPvP[0x2C];" & _
        "byte Combo[0x30];" & _
        "byte Target[0x31];" & _
        "byte SkillEquipType[0x33];" & _
        "byte Overcast[0x34];" & _
        "byte EnergyCost[0x35];" & _
        "byte HealthCost[0x36];" & _
        "dword Adrenaline[0x38];" & _
        "float Activation[0x3C];" & _
        "float Aftercast[0x40];" & _
        "dword Duration0[0x44];" & _
        "dword Duration15[0x48];" & _
        "dword Recharge[0x4C];" & _
        "dword SkillArguments[0x58];" & _
        "dword Scale0[0x5C];" & _
        "dword Scale15[0x60];" & _
        "dword BonusScale0[0x64];" & _
        "dword BonusScale15[0x68];" & _
        "float AoeRange[0x6C];" & _
        "float ConstEffect[0x70];" & _
        "dword CasterOverheadAnimationID[0x74];" & _
        "dword CasterBodyAnimationID[0x78];" & _
        "dword TargetBodyAnimationID[0x7C];" & _
        "dword TargetOverheadAnimationID[0x80];" & _
        "dword ProjectileAnimation1ID[0x84];" & _
        "dword ProjectileAnimation2ID[0x88];" & _
        "dword IconFileID[0x8C];" & _
        "dword IconFileID2[0x90];" & _
		"dword IconFileIDHD[0x94];" & _
        "dword Name[0x98];" & _
        "dword Concise[0x9C];" & _
        "dword Description[0xA0]")

    Local $l_p_SkillPtr = Skill_GetSkillPtr($a_i_SkillID)
    If $l_p_SkillPtr = 0 Then Return SetError(1, 0, 0)

    Return Memory_ReadStruct($l_p_SkillPtr, $ss_StructInfo)
EndFunc

Func UAI_CacheSkillBar()
	$g_amx2_StaticSkillCache = 0			; resets the array if we cache a different skill bar
	Global $g_amx2_StaticSkillCache[9][43]

    For $i = 1 To 8
        Local $l_i_SkillID = Skill_GetSkillbarInfo($i, "SkillID")

        If $l_i_SkillID = 0 Then
            For $j = 0 To 42
                $g_amx2_StaticSkillCache[$i][$j] = 0
            Next
            ContinueLoop
        EndIf

        Local $l_av_SkillData = UAI_StaticDataSkill($l_i_SkillID)
        If @error Or Not IsArray($l_av_SkillData) Then ContinueLoop

        Local $l_i_Max = UBound($l_av_SkillData) - 1
        If $l_i_Max > 42 Then $l_i_Max = 42

        For $j = 0 To $l_i_Max
            $g_amx2_StaticSkillCache[$i][$j] = $l_av_SkillData[$j]
        Next

        Local $l_i_Overcast = $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_Overcast]
        Switch $l_i_Overcast
			Case 5
				$g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_Overcast] = 5
			Case 10
                $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_Overcast] = 10
            Case Else
                $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_Overcast] = 0
        EndSwitch

        ; Traitement spécial pour EnergyCost
        Local $l_i_EnergyCost = $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_EnergyCost]
        Switch $l_i_EnergyCost
            Case 11
                $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_EnergyCost] = 15
            Case 12
                $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_EnergyCost] = 25
        EndSwitch

        ; Traitement spécial pour Aftercast (conversion en ms)
        $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_Aftercast] = _
            $g_amx2_StaticSkillCache[$i][$GC_UAI_STATIC_SKILL_Aftercast] * 750
    Next
EndFunc

Func UAI_GetStaticSkillInfo($a_i_Slot, $a_i_InfoType)
    If $a_i_Slot < 1 Or $a_i_Slot > 8 Then Return 0
    If $a_i_InfoType < 0 Or $a_i_InfoType > 42 Then Return 0
    Return $g_amx2_StaticSkillCache[$a_i_Slot][$a_i_InfoType]
EndFunc
