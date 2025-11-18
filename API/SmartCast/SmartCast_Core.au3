#include-once

Func Fight($x, $y, $aAggroRange = 1320, $aMaxDistanceToXY = 3500)
	$BestTarget = 0
	Local $MyOldMap = Map_GetMapID(), $lMapLoadingOld = Map_GetInstanceInfo("Type")
	Do
		UseSkills($x, $y, $aAggroRange, $aMaxDistanceToXY)
		Sleep(32)
	Until Count_NumberOf(-2, $aAggroRange, "Filter_IsLivingEnemy") = 0 Or Agent_GetAgentInfo(-2, "IsDead") Or Party_IsWiped() Or Map_GetMapID() <> $MyOldMap Or Map_GetInstanceInfo("Type") <> $lMapLoadingOld
EndFunc   ;==>Fight

;~ Use this function to cast all of your skills or skills of a certain type.
Func UseSkills($x, $y, $aAggroRange = 1320, $aMaxDistanceToXY = 3500)
	For $i = 1 To 8
		If Agent_GetAgentInfo(-2, "IsDead") Or Party_IsWiped() = 1 Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or Agent_GetAgentInfo(-2, "IsKnockedDown") Then Return
		If Count_NumberOf(-2, $aAggroRange, "Filter_IsLivingEnemy") = 0 Then Return

		If $SkillBarCache[$i][$SkillID] = 0 Then ContinueLoop

		If $SkillChanged = True Then
			If Cache_EndFormChangeBuild($i) Then
				$SkillChanged = False
			EndIf
		EndIf

;~ 	PRIORITY SKILLS
		SmartCast_PrioritySkills()

;~ 	BUNDLE TO DROP
		SmartCast_DropBundle()

;~ 	AUTO ATTACK
		If SmartCast_CanAutoAttack() Then
			If $BestTarget <> Agent_GetMyID() And $BestTarget <> $LastCalledTarget Then Agent_CallTarget($BestTarget)
			Agent_Attack(Nearest_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy"), False)
			$LastCalledTarget = $BestTarget
		Else
			If Agent_GetAgentInfo(-2, "IsAttacking") Then Core_ControlAction($GC_I_CONTROL_ACTION_CANCEL_ACTION)
		EndIf

;~ 	USESKILL
		If SmartCast_CanCast($i) Then
			$BestTarget = Call($BestTargetCache[$i], $aAggroRange)
			If $BestTarget = 0 Then ContinueLoop

			$CanUseSkill = Call($CanUseCache[$i])

			If $CanUseSkill = True And Agent_GetDistance($BestTarget) < $aAggroRange Then
				SmartCast_UseSkillEX($i, $BestTarget)
				If Cache_FormChangeBuild($i) Then $SkillChanged = True
			Else
				ContinueLoop
			EndIf
		EndIf

;~ 	MOVE IF TOO FARHEST
		If $x <> 0 Or $y <> 0 Then
			If Agent_GetDistanceToXY($x, $y) > $aMaxDistanceToXY Then Return	; exit fight if we deviate for waypoints by more than allowed distance
		EndIf
		Sleep(32)
	Next
	Return True
EndFunc   ;==>UseSkills

; Use skill function
Func SmartCast_UseSkillEX($aSkillSlot, $aAgentID = -2)
	Local $lSkillID = $SkillBarCache[$aSkillSlot][$SkillID]

	If $aAgentID <> Agent_GetMyID() Then Agent_ChangeTarget($aAgentID)

	Skill_UseSkill($aSkillSlot, $aAgentID)

	;If it's melee attack wait until target is in nearby range
	If Skill_IsAttackType($lSkillID) Or Skill_IsSkill2Type($lSkillID) Or Skill_IsSkillType($lSkillID) Or Skill_IsTouchSpecial($lSkillID) Then
		Do
			Sleep(32)
		Until Agent_GetDistance($aAgentID) <= 240 Or Agent_GetAgentInfo(-2, "IsDead") Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or Not SmartCast_CanCast($aSkillSlot)

	;ElseIf it's spell wait until target is in aggro range
	ElseIf Agent_GetDistance($aAgentID) > 1320 Then
		Do
			Sleep(32)
		Until Agent_GetDistance($aAgentID) <= 1320 Or Agent_GetAgentInfo(-2, "IsDead") Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or Not SmartCast_CanCast($aSkillSlot)
	EndIf

	Do
        Sleep(32)
    Until Agent_GetAgentInfo(-2, "IsDead") Or Agent_GetDistance($aAgentID) > 1320 Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or (Not Agent_GetAgentInfo(-2, "IsCasting") And Not Agent_GetAgentInfo(-2, "Skill") And Not Skill_GetSkillbarInfo($aSkillSlot, "Casting"))
EndFunc   ;==>UseSkillEX

;Priority skills, check at each loop if can cast
Func SmartCast_PrioritySkills()
	Local $aPrioritySkills[] = [$GC_I_SKILL_ID_ASSASSINS_PROMISE, $GC_I_SKILL_ID_EREMITES_ZEAL, $GC_I_SKILL_ID_PANIC, $GC_I_SKILL_ID_INFUSE_HEALTH, _
								$GC_I_SKILL_ID_SEED_OF_LIFE, $GC_I_SKILL_ID_HEALING_BURST, $GC_I_SKILL_ID_PATIENT_SPIRIT, $GC_I_SKILL_ID_LIFE_SHEATH, _
								$GC_I_SKILL_ID_RESTORE_CONDITION, $GC_I_SKILL_ID_PEACE_AND_HARMONY]

	For $skillID In $aPrioritySkills
		Local $slot = Skill_GetSlotByID($skillID)
		If $slot > 0 Then
			_TryCastPrioritySkill($slot)
		EndIf
	Next
EndFunc

Func _TryCastPrioritySkill($i)
	If Not SmartCast_CanCast($i) Then Return

	$BestTarget = Call($BestTargetCache[$i], $aAggroRange)
	If $BestTarget = 0 Then Return

	If Call($CanUseCache[$i]) Then
		SmartCast_UseSkillEX($i, $BestTarget)
	EndIf
EndFunc

Func SmartCast_DropBundle()
	For $i = 1 To 8
;~ 		Switch $SkillBarCache[$i][$SkillID]
;~ 			Case
;~ 		EndSwitch
	Next
EndFunc