#include-once

Func UAI_Fight($a_f_x, $a_f_y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500, $a_i_FightMode = $g_i_FinisherMode, $a_b_UseSwitchSet = False, $a_i_PlayerNumber = -1)
	$g_i_BestTarget = 0
	$g_i_ForceTarget = 0
	$g_i_FightMode = $a_i_FightMode
	$a_b_UseSwitchSet = $g_b_CacheWeaponSet

	Local $l_i_MyOldMap = Map_GetMapID(), $l_i_MapLoadingOld = Map_GetInstanceInfo("Type")

	If $a_i_PlayerNumber <> -1 Then
		UAI_UpdateCache($a_f_AggroRange)
		$g_i_ForceTarget = UAI_FindAgentByPlayerNumber($a_i_PlayerNumber, -2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
		If $g_i_ForceTarget = 0 Then Return True
	EndIf

	If $g_b_CacheWeaponSet Then UAI_DeterminateWeaponSets()

	Do
		If $g_i_ForceTarget <> 0 And UAI_GetAgentInfoByID($g_i_ForceTarget, $GC_UAI_AGENT_IsDead) Then ExitLoop
		UAI_UseSkills($a_f_x, $a_f_y, $a_f_AggroRange, $a_f_MaxDistanceToXY)
		Sleep(128)
	Until UAI_CountEnemyInPartyAggroRange($a_f_AggroRange) = 0 Or Agent_GetAgentInfo(-2, "IsDead") Or Party_IsWiped() Or Map_GetMapID() <> $l_i_MyOldMap Or Map_GetInstanceInfo("Type") <> $l_i_MapLoadingOld
EndFunc   ;==>UAI_Fight

;~ Use this function to cast all of your skills or skills of a certain type.
Func UAI_UseSkills($a_f_x, $a_f_y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500)
	Static $ls_i_LowPrioSkill = 6
	For $i = 1 To 6
		Local $l_i_Slot = $i

		if $l_i_Slot = 6 Then
			$l_i_Slot = $ls_i_LowPrioSkill
			$ls_i_LowPrioSkill += 1
			If $ls_i_LowPrioSkill > 8 Then $ls_i_LowPrioSkill = 6
		EndIf

		If UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_SkillID) = 0 Then ContinueLoop

;~ 	UPDATE CACHE FIRST
		UAI_UpdateCache($a_f_AggroRange)
		If UAI_CountEnemyInPartyAggroRange($a_f_AggroRange) = 0 Then ExitLoop
		If $g_b_CacheWeaponSet Then UAI_ShouldSwitchWeaponSet()

;~ 	CHECK PARTY
		If UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Party_IsWiped() = 1 Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsKnockedDown) Then Return

		If $g_b_SkillChanged = True Then
			If Cache_EndFormChangeBuild($l_i_Slot) Then
				$g_b_SkillChanged = False
			EndIf
		EndIf

;~ 	MOVE TOWARD HERO AGGRO TARGET
		; If no enemy in player's range but heroes have aggro, move toward the enemy
		Local $l_i_PlayerRangeEnemy = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
		If $l_i_PlayerRangeEnemy = 0 Then
			Local $l_i_PartyRangeEnemy = UAI_GetNearestEnemyInPartyRange($a_f_AggroRange)
			If $l_i_PartyRangeEnemy <> 0 Then
				; Move toward the enemy that the hero has aggro'd
				Local $l_f_EnemyX = UAI_GetAgentInfoByID($l_i_PartyRangeEnemy, $GC_UAI_AGENT_X)
				Local $l_f_EnemyY = UAI_GetAgentInfoByID($l_i_PartyRangeEnemy, $GC_UAI_AGENT_Y)
				Map_Move($l_f_EnemyX, $l_f_EnemyY, 0)
				Sleep(500)
				Return ; Exit and let the next loop iteration handle the rest
			EndIf
		EndIf

;~ 	AUTO ATTACK
		If UAI_CanAutoAttack() Then
			If $g_i_ForceTarget <> 0 Then 
				Agent_Attack($g_i_ForceTarget)
			Else
				Agent_Attack(UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy"), False)
			EndIf
		Else
			If UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Core_ControlAction($GC_I_CONTROL_ACTION_CANCEL_ACTION)
		EndIf

;~ 	PRIORITY SKILLS
		UAI_PrioritySkills($a_f_AggroRange)

;~ 	BUNDLE TO DROP
		UAI_DropBundle($a_f_AggroRange)

;~ 	USESKILL
		If UAI_CanCast($l_i_Slot) Then
			$g_i_BestTarget = Call($g_as_BestTargetCache[$l_i_Slot], $a_f_AggroRange)
			If $g_i_ForceTarget <> 0 And UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Allegiance) = $GC_I_ALLEGIANCE_ENEMY Then
				$g_i_BestTarget = $g_i_ForceTarget
			EndIf
			If $g_i_BestTarget = 0 Then ContinueLoop

			$g_b_CanUseSkill = Call($g_as_CanUseCache[$l_i_Slot])

			If $g_b_CanUseSkill = True And Agent_GetDistance($g_i_BestTarget) < $a_f_AggroRange Then
				UAI_UseSkillEX($l_i_Slot, $g_i_BestTarget)
				If Cache_FormChangeBuild($l_i_Slot) Then $g_b_SkillChanged = True
			Else
				ContinueLoop
			EndIf
		EndIf

;~ 	MOVE IF TOO FARHEST
		If $a_f_MaxDistanceToXY <> 0 Then
			If $a_f_x <> 0 Or $a_f_y <> 0 Then
				If Agent_GetDistanceToXY($a_f_x, $a_f_y) > $a_f_MaxDistanceToXY Then ExitLoop
			EndIf
		EndIf
	Next
	Return True
EndFunc   ;==>UAI_UseSkills

; Use skill function
Func UAI_UseSkillEX($a_i_SkillSlot, $a_i_AgentID = -2)
	If $a_i_AgentID <> Agent_GetMyID() Then Agent_ChangeTarget($a_i_AgentID)
	If $g_b_CacheWeaponSet Then UAI_GetBestWeaponSetBySkillSlot($a_i_SkillSlot)

	If $a_i_AgentID <> Agent_GetMyID() And $a_i_AgentID <> $g_i_LastCalledTarget Then
		If $g_b_CallTarget Then Agent_CallTarget($a_i_AgentID)
		$g_i_LastCalledTarget = $a_i_AgentID
	EndIf
	
	Skill_UseSkill($a_i_SkillSlot, $a_i_AgentID)
	Sleep(128)

	;If it's melee attack wait until target is in nearby range
	Local $l_i_Skilltype = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillType)
	Local $l_i_Special = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Special)
	Local $l_i_WeaponReq = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_WeaponReq)
	If ($l_i_Skilltype = $GC_I_SKILL_TYPE_ATTACK And Not $l_i_WeaponReq = $GC_I_SKILL_REQUIRE_BOW And Not $GC_I_SKILL_REQUIRE_SPEAR) _
		Or $l_i_Skilltype = $GC_I_SKILL_TYPE_SKILL2 Or $l_i_Skilltype = $GC_I_SKILL_TYPE_SKILL Or $l_i_Special = $GC_I_SKILL_SPECIAL_FLAG_TOUCH Then
		Local $l_h_WaitStart = TimerInit()
		Sleep(128)
		Do
			If TimerDiff($l_h_WaitStart) > 5000 Then ExitLoop
			If $l_i_Special <> $GC_I_SKILL_SPECIAL_FLAG_RESURRECTION And Agent_GetAgentInfo($g_i_BestTarget, "IsDead") Then
				Core_ControlAction($GC_I_CONTROL_ACTION_CANCEL_ACTION)
				ExitLoop
			EndIf
			Sleep(32)
			UAI_UpdateCache(100)
		Until Agent_GetDistance($a_i_AgentID) <= 240 Or Agent_GetAgentInfo(-2, "IsDead") Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or Not UAI_CanCast($a_i_SkillSlot) Or Agent_GetAgentInfo(-2, "IsKnocked")
	EndIf

	Local $l_h_CastStart = TimerInit()
	Do
		If TimerDiff($l_h_CastStart) > 5000 Then ExitLoop
		If $l_i_Special <> $GC_I_SKILL_SPECIAL_FLAG_RESURRECTION And Agent_GetAgentInfo($g_i_BestTarget, "IsDead") Then
			Core_ControlAction($GC_I_CONTROL_ACTION_CANCEL_ACTION)
			ExitLoop
		EndIf
		Sleep(32)
	Until Agent_GetAgentInfo(-2, "IsDead") Or Agent_GetDistance($a_i_AgentID) > 1320 Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or (Not Agent_GetAgentInfo(-2, "IsCasting") And Not Agent_GetAgentInfo(-2, "Skill") And Not Skill_GetSkillbarInfo($a_i_SkillSlot, "Casting") Or Agent_GetAgentInfo(-2, "IsKnocked"))
EndFunc   ;==>UAI_UseSkillEX

;Priority skills, check at each loop if can cast
;Uses Special flags and Effect2 flags to identify priority skills
Func UAI_PrioritySkills($a_f_AggroRange = 1320)
	; Priority Special flags (from $GC_UAI_STATIC_SKILL_Special)
	Local $l_ai_PrioritySpecialFlags[] = [$GC_I_SKILL_SPECIAL_FLAG_RESURRECTION, $GC_I_SKILL_SPECIAL_FLAG_ELITE, $GC_I_SKILL_SPECIAL_FLAG_PVE]

	; Priority Effect2 flags (from $GC_UAI_STATIC_SKILL_Effect2)
	Local $l_ai_PriorityEffect2Flags[] = [$GC_I_SKILL_EFFECT2_ENERGY_STEAL, $GC_I_SKILL_EFFECT2_ENERGY_GAIN, _
										  $GC_I_SKILL_EFFECT2_HEX_REMOVAL, $GC_I_SKILL_EFFECT2_CONDITION_REMOVAL]

	; Priority Skill Type (from $GC_UAI_STATIC_SKILL_SkillType)
	Local $l_ai_PrioritySkillType[] = [$GC_I_SKILL_TYPE_WELL, $GC_I_SKILL_TYPE_GLYPH, $GC_I_SKILL_TYPE_PREPARATION, $GC_I_SKILL_TYPE_ITEM_SPELL]

	; Check each skill slot
	For $l_i_Slot = 1 To 8
		If Not UAI_CanCast($l_i_Slot) Then ContinueLoop
		Local $l_i_Special = UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_Special)
		Local $l_i_Effect2 = UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_Effect2)
		Local $l_i_Type = UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_SkillType)

		; Check Special flags
		For $l_i_Flag In $l_ai_PrioritySpecialFlags
			If BitAND($l_i_Special, $l_i_Flag) Then
				UAI_CastPrioritySkill($l_i_Slot, $a_f_AggroRange)
				ExitLoop 2 ; Exit both loops after casting
			EndIf
		Next

		; Check Effect2 flags
		For $l_i_Flag In $l_ai_PriorityEffect2Flags
			If BitAND($l_i_Effect2, $l_i_Flag) Then
				UAI_CastPrioritySkill($l_i_Slot, $a_f_AggroRange)
				ExitLoop 2 ; Exit both loops after casting
			EndIf
		Next

		; Check SkillType (direct value comparison, not flags)
		For $l_i_PriorityType In $l_ai_PrioritySkillType
			If $l_i_Type = $l_i_PriorityType Then
				UAI_CastPrioritySkill($l_i_Slot, $a_f_AggroRange)
				ExitLoop 2 ; Exit both loops after casting
			EndIf
		Next
	Next
EndFunc

Func UAI_CastPrioritySkill($a_i_Slot, $a_f_AggroRange = 1320)
	If UAI_CanCast($a_i_Slot) Then
		$g_i_BestTarget = Call($g_as_BestTargetCache[$a_i_Slot], $a_f_AggroRange)
		If $g_i_ForceTarget <> 0 And UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Allegiance) = $GC_I_ALLEGIANCE_ENEMY Then
			$g_i_BestTarget = $g_i_ForceTarget
		EndIf
		If $g_i_BestTarget = 0 Then Return

		$g_b_CanUseSkill = Call($g_as_CanUseCache[$a_i_Slot])

		If $g_b_CanUseSkill = True And Agent_GetDistance($g_i_BestTarget) < $a_f_AggroRange Then
			UAI_UseSkillEX($a_i_Slot, $g_i_BestTarget)
			If Cache_FormChangeBuild($a_i_Slot) Then $g_b_SkillChanged = True
			UAI_UpdateCache($a_f_AggroRange)
		EndIf
	EndIf
EndFunc

; Drop bundle if player has Item Spell effect and can cast (skill is recharged)
Func UAI_DropBundle($a_f_AggroRange = 1320)
	For $l_i_Slot = 1 To 8
		; Check if skill is an Item Spell
		Local $l_i_Type = UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_SkillType)
		If $l_i_Type <> $GC_I_SKILL_TYPE_ITEM_SPELL Then ContinueLoop

		; Get skill ID to check if player has the effect
		Local $l_i_SkillID = UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_SkillID)
		If $l_i_SkillID = 0 Then ContinueLoop

		; Check if player has the Item Spell effect (holding the ashes)
		If Not UAI_PlayerHasEffect($l_i_SkillID) Then ContinueLoop

		; Check if skill is recharged (can drop bundle)
		If UAI_CanCast($l_i_Slot) Then
			$g_i_BestTarget = Call($g_as_BestTargetCache[$l_i_Slot], $a_f_AggroRange)
			If $g_i_ForceTarget <> 0 And UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Allegiance) = $GC_I_ALLEGIANCE_ENEMY Then
				$g_i_BestTarget = $g_i_ForceTarget
			EndIf
			If $g_i_BestTarget = 0 Then ContinueLoop

			$g_b_CanUseSkill = Call($g_as_CanUseCache[$l_i_Slot])

			If $g_b_CanUseSkill = True And Agent_GetDistance($g_i_BestTarget) < $a_f_AggroRange Then
				UAI_UseSkillEX($l_i_Slot, $g_i_BestTarget)
				If Cache_FormChangeBuild($l_i_Slot) Then $g_b_SkillChanged = True
				UAI_UpdateCache($a_f_AggroRange)
			EndIf
		EndIf

		; Check if skill is not recharged (but can drop bundle)
		If UAI_CanDrop($l_i_Slot) Then
			Core_ControlAction($GC_I_CONTROL_ACTION_DROP_ITEM)
			Return
		EndIf
	Next
EndFunc