#include-once

; Script Start - Add your code below here
Func Cache_SkillBar()
	If Map_GetInstanceInfo("Type") = 2 Then Return
	$SkillBarCache = 0			; resets the array if we cache a different skill bar
	Global $SkillBarCache[9][44]
	Sleep(32)
	For $i = 1 To 8
		Local $lCurrentSkillID = Skill_GetSkillbarInfo($i, "SkillID")
		$SkillBarCache[$i][$SkillID] = $lCurrentSkillID
		$SkillBarCache[$i][$Campaign] = Skill_GetSkillInfo($lCurrentSkillID, "Campaign")
		$SkillBarCache[$i][$SkillType] = Skill_GetSkillInfo($lCurrentSkillID, "SkillType")
		$SkillBarCache[$i][$Special] = Skill_GetSkillInfo($lCurrentSkillID, "Special")
		$SkillBarCache[$i][$ComboReq] = Skill_GetSkillInfo($lCurrentSkillID, "ComboReq")
		$SkillBarCache[$i][$Effect1] = Skill_GetSkillInfo($lCurrentSkillID, "Effect1")
		$SkillBarCache[$i][$RequireCondition] = Skill_GetSkillInfo($lCurrentSkillID, "RequireCondition")
		$SkillBarCache[$i][$Effect2] = Skill_GetSkillInfo($lCurrentSkillID, "Effect2")
		$SkillBarCache[$i][$WeaponReq] = Skill_GetSkillInfo($lCurrentSkillID, "WeaponReq")
		$SkillBarCache[$i][$Profession] = Skill_GetSkillInfo($lCurrentSkillID, "Profession")
		$SkillBarCache[$i][$Attribute] = Skill_GetSkillInfo($lCurrentSkillID, "Attribute")
		$SkillBarCache[$i][$Title] = Skill_GetSkillInfo($lCurrentSkillID, "Title")
		$SkillBarCache[$i][$SkillIDPvP] = Skill_GetSkillInfo($lCurrentSkillID, "SkillIDPvP")
		$SkillBarCache[$i][$Combo] = Skill_GetSkillInfo($lCurrentSkillID, "Combo")
		$SkillBarCache[$i][$Target] = Skill_GetSkillInfo($lCurrentSkillID, "Target")
		$SkillBarCache[$i][$SkillEquipType] = Skill_GetSkillInfo($lCurrentSkillID, "SkillEquipType")
		$SkillBarCache[$i][$Overcast] = Skill_GetSkillInfo($lCurrentSkillID, "Overcast")
		$SkillBarCache[$i][$EnergyCost] = Skill_GetSkillInfo($lCurrentSkillID, "EnergyCost")
		$SkillBarCache[$i][$HealthCost] = Skill_GetSkillInfo($lCurrentSkillID, "HealthCost")
		$SkillBarCache[$i][$Adrenaline] = Skill_GetSkillInfo($lCurrentSkillID, "Adrenaline")
		$SkillBarCache[$i][$Activation] = Skill_GetSkillInfo($lCurrentSkillID, "Activation")
		$SkillBarCache[$i][$Aftercast] = Skill_GetSkillInfo($lCurrentSkillID, "Aftercast") * 750
		$SkillBarCache[$i][$Duration0] = Skill_GetSkillInfo($lCurrentSkillID, "Duration0")
		$SkillBarCache[$i][$Duration15] = Skill_GetSkillInfo($lCurrentSkillID, "Duration15")
		$SkillBarCache[$i][$Recharge] = Skill_GetSkillInfo($lCurrentSkillID, "Recharge")
		$SkillBarCache[$i][$SkillArguments] = Skill_GetSkillInfo($lCurrentSkillID, "SkillArguments")
		$SkillBarCache[$i][$Scale0] = Skill_GetSkillInfo($lCurrentSkillID, "Scale0")
		$SkillBarCache[$i][$Scale15] = Skill_GetSkillInfo($lCurrentSkillID, "Scale15")
		$SkillBarCache[$i][$BonusScale0] = Skill_GetSkillInfo($lCurrentSkillID, "BonusScale0")
		$SkillBarCache[$i][$BonusScale15] = Skill_GetSkillInfo($lCurrentSkillID, "BonusScale15")
		$SkillBarCache[$i][$EffectConstant1] = Skill_GetSkillInfo($lCurrentSkillID, "EffectConstant1")
		$SkillBarCache[$i][$EffectConstant2] = Skill_GetSkillInfo($lCurrentSkillID, "EffectConstant2")
		$SkillBarCache[$i][$CasterOverheadAnimationID] = Skill_GetSkillInfo($lCurrentSkillID, "CasterOverheadAnimationID")
		$SkillBarCache[$i][$CasterBodyAnimationID] = Skill_GetSkillInfo($lCurrentSkillID, "CasterBodyAnimationID")
		$SkillBarCache[$i][$TargetBodyAnimationID] = Skill_GetSkillInfo($lCurrentSkillID, "TargetBodyAnimationID")
		$SkillBarCache[$i][$TargetOverheadAnimationID] = Skill_GetSkillInfo($lCurrentSkillID, "TargetOverheadAnimationID")
		$SkillBarCache[$i][$ProjectileAnimation1ID] = Skill_GetSkillInfo($lCurrentSkillID, "ProjectileAnimation1ID")
		$SkillBarCache[$i][$ProjectileAnimation2ID] = Skill_GetSkillInfo($lCurrentSkillID, "ProjectileAnimation2ID")
		$SkillBarCache[$i][$IconFileID] = Skill_GetSkillInfo($lCurrentSkillID, "IconFileID")
		$SkillBarCache[$i][$IconFileID2] = Skill_GetSkillInfo($lCurrentSkillID, "IconFileID2")
		$SkillBarCache[$i][$Name] = Skill_GetSkillInfo($lCurrentSkillID, "Name")
		$SkillBarCache[$i][$Concise] = Skill_GetSkillInfo($lCurrentSkillID, "Concise")
		$SkillBarCache[$i][$Description] = Skill_GetSkillInfo($lCurrentSkillID, "Description")
	Next

	For $i = 1 To 8
		$BestTargetCache[$i] = SmartCast_BestTarget($i)
	Next

	For $i = 1 To 8
		$CanUseCache[$i] = SmartCast_CanUse($i)
	Next

	For $i = 1 To 8
		Local $lSkillID = $SkillBarCache[$i][$SkillID]
		Out("Skill Name:          " & $GC_AMX2_SKILL_DATA[$lSkillID][1])
		Out("    - SkillID:           " & $lSkillID)
		Out("    - BestTarget:    " & $BestTargetCache[$i])
		Out("    - CanUse:         " & $CanUseCache[$i] & @CRLF)
	Next
EndFunc   ;==>Cache_SkillBar

Func Cache_FormChangeBuild($aSkillSlot)
	Switch $SkillBarCache[$aSkillSlot][$SkillID]
		Case $GC_I_SKILL_ID_URSAN_BLESSING, $GC_I_SKILL_ID_VOLFEN_BLESSING, $GC_I_SKILL_ID_RAVEN_BLESSING
			Cache_SkillBar()
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc

Func Cache_EndFormChangeBuild($aSkillSlot)
	Switch $SkillBarCache[$aSkillSlot][$SkillID]
		Case $GC_I_SKILL_ID_URSAN_STRIKE, $GC_I_SKILL_ID_URSAN_RAGE, $GC_I_SKILL_ID_URSAN_ROAR, $GC_I_SKILL_ID_URSAN_FORCE, $GC_I_SKILL_ID_Totem_of_Man
			Return False
		Case $GC_I_SKILL_ID_RAVEN_TALONS, $GC_I_SKILL_ID_RAVEN_SWOOP, $GC_I_SKILL_ID_RAVEN_SHRIEK, $GC_I_SKILL_ID_Raven_Flight
			Return False
		Case $GC_I_SKILL_ID_VOLFEN_CLAW, $GC_I_SKILL_ID_VOLFEN_POUNCE, $GC_I_SKILL_ID_VOLFEN_BLOODLUST, $GC_I_SKILL_ID_VOLFEN_AGILITY
			Return False
		Case Else
			Cache_SkillBar()
			Return True
	EndSwitch
EndFunc
