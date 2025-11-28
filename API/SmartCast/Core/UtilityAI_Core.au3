#include-once

Func UAI_Fight($a_f_x, $a_f_y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500)
	$g_i_BestTarget = 0
	Local $l_i_MyOldMap = Map_GetMapID(), $l_i_MapLoadingOld = Map_GetInstanceInfo("Type")
	Do
		UAI_UseSkills($a_f_x, $a_f_y, $a_f_AggroRange, $a_f_MaxDistanceToXY)
		Sleep(32)
	Until UAI_CountAgents(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy") = 0 Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Party_IsWiped() Or Map_GetMapID() <> $l_i_MyOldMap Or Map_GetInstanceInfo("Type") <> $l_i_MapLoadingOld
EndFunc   ;==>UAI_Fight

;~ Use this function to cast all of your skills or skills of a certain type.
Func UAI_UseSkills($a_f_x, $a_f_y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500)
	For $l_i_i = 1 To 8
;~ 	UPDATE AGENT CACHE FIRST
		UAI_UpdateCache($a_f_AggroRange)

		If UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Party_IsWiped() = 1 Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsKnockedDown) Then Return
		If UAI_CountAgents(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy") = 0 Then Return

		If UAI_GetStaticSkillInfo($l_i_i, $GC_UAI_STATIC_SKILL_SkillID) = 0 Then ContinueLoop

		If $g_b_SkillChanged = True Then
			If Cache_EndFormChangeBuild($l_i_i) Then
				$g_b_SkillChanged = False
			EndIf
		EndIf

;~ 	PRIORITY SKILLS
		UAI_PrioritySkills($a_f_AggroRange)

;~ 	BUNDLE TO DROP
		UAI_DropBundle()

;~ 	AUTO ATTACK
		If UAI_CanAutoAttack() Then
			If $g_i_BestTarget <> Agent_GetMyID() And $g_i_BestTarget <> $g_i_LastCalledTarget Then Agent_CallTarget($g_i_BestTarget)
			Agent_Attack(UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy"), False)
			$g_i_LastCalledTarget = $g_i_BestTarget
		Else
			If UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Core_ControlAction($GC_I_CONTROL_ACTION_CANCEL_ACTION)
		EndIf

;~ 	USESKILL
		If UAI_CanCast($l_i_i) Then
			$g_i_BestTarget = Call($g_as_BestTargetCache[$l_i_i], $a_f_AggroRange)
			If $g_i_BestTarget = 0 Then ContinueLoop

			$g_b_CanUseSkill = Call($g_as_CanUseCache[$l_i_i])

			If $g_b_CanUseSkill = True And Agent_GetDistance($g_i_BestTarget) < $a_f_AggroRange Then
				UAI_UseSkillEX($l_i_i, $g_i_BestTarget)
				If Cache_FormChangeBuild($l_i_i) Then $g_b_SkillChanged = True
			Else
				ContinueLoop
			EndIf
		EndIf

;~ 	MOVE IF TOO FARHEST
		If $a_f_x <> 0 Or $a_f_y <> 0 Then
			If Agent_GetDistanceToXY($a_f_x, $a_f_y) > $a_f_MaxDistanceToXY Then Return
		EndIf
		Sleep(32)
	Next
	Return True
EndFunc   ;==>UAI_UseSkills

; Use skill function
Func UAI_UseSkillEX($a_i_SkillSlot, $a_i_AgentID = -2)
	If $a_i_AgentID <> Agent_GetMyID() Then Agent_ChangeTarget($a_i_AgentID)
	If $g_b_CacheWeaponSet Then UAI_GetBestWeaponSetBySkillSlot($a_i_SkillSlot)

	Skill_UseSkill($a_i_SkillSlot, $a_i_AgentID)

	;If it's melee attack wait until target is in nearby range
	Local $l_i_Skilltype = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillType)
	Local $l_i_Special = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Special)
	If $l_i_Skilltype = $GC_I_SKILL_TYPE_ATTACK Or $l_i_Skilltype = $GC_I_SKILL_TYPE_SKILL2 Or $l_i_Skilltype = $GC_I_SKILL_TYPE_SKILL Or $l_i_Special = $GC_I_SKILL_SPECIAL_FLAG_TOUCH Then
		Local $l_h_WaitStart = TimerInit()
		Do
			Sleep(32)
			If TimerDiff($l_h_WaitStart) > 5000 Then ExitLoop
		Until Agent_GetDistance($a_i_AgentID) <= 240 Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or Not UAI_CanCast($a_i_SkillSlot)

	;ElseIf it's spell wait until target is in aggro range
	ElseIf Agent_GetDistance($a_i_AgentID) > 1320 Then
		Local $l_h_WaitStart = TimerInit()
		Do
			Sleep(32)
			If TimerDiff($l_h_WaitStart) > 5000 Then ExitLoop
		Until Agent_GetDistance($a_i_AgentID) <= 1320 Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or Not UAI_CanCast($a_i_SkillSlot)
	EndIf

	Local $l_h_CastStart = TimerInit()
	Do
		Sleep(32)
		If TimerDiff($l_h_CastStart) > 5000 Then ExitLoop
	Until UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Agent_GetDistance($a_i_AgentID) > 1320 Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or (Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsCasting) And Not UAI_GetPlayerInfo($GC_UAI_AGENT_Skill) And Not Skill_GetSkillbarInfo($a_i_SkillSlot, "Casting"))
EndFunc   ;==>UAI_UseSkillEX

;Priority skills, check at each loop if can cast
Func UAI_PrioritySkills($a_f_AggroRange = 1320)
	Local $l_ai_PrioritySkills[] = [$GC_I_SKILL_ID_ASSASSINS_PROMISE, $GC_I_SKILL_ID_EREMITES_ZEAL, $GC_I_SKILL_ID_PANIC, $GC_I_SKILL_ID_INFUSE_HEALTH, _
								$GC_I_SKILL_ID_SEED_OF_LIFE, $GC_I_SKILL_ID_HEALING_BURST, $GC_I_SKILL_ID_PATIENT_SPIRIT, $GC_I_SKILL_ID_LIFE_SHEATH, _
								$GC_I_SKILL_ID_RESTORE_CONDITION, $GC_I_SKILL_ID_PEACE_AND_HARMONY]

	For $l_i_SkillID In $l_ai_PrioritySkills
		Local $l_i_Slot = Skill_GetSlotByID($l_i_SkillID)
		If $l_i_Slot > 0 Then
			UAI_CastPrioritySkill($l_i_Slot, $a_f_AggroRange)
		EndIf
	Next
EndFunc

Func UAI_CastPrioritySkill($a_i_Slot, $a_f_AggroRange = 1320)
	If Not UAI_CanCast($a_i_Slot) Then Return

	$g_i_BestTarget = Call($g_as_BestTargetCache[$a_i_Slot], $a_f_AggroRange)
	If $g_i_BestTarget = 0 Then Return

	If Call($g_as_CanUseCache[$a_i_Slot]) Then
		UAI_UseSkillEX($a_i_Slot, $g_i_BestTarget)
		; Actualize cache after casting priority skills
		UAI_UpdateCache($a_f_AggroRange)
	EndIf
EndFunc

Func UAI_DropBundle()
	For $l_i_i = 1 To 8
;~ 		Switch UAI_GetStaticSkillInfo($l_i_i, $GC_UAI_STATIC_SKILL_SkillID)
;~ 			Case
;~ 		EndSwitch
	Next
EndFunc