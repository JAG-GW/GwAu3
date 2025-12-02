#include-once

Func UAI_Fight($a_f_x, $a_f_y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500, $a_i_FightMode = $g_i_FinisherMode)
	$g_i_BestTarget = 0
	$g_i_FightMode = $a_i_FightMode
	Local $l_i_MyOldMap = Map_GetMapID(), $l_i_MapLoadingOld = Map_GetInstanceInfo("Type")
	Do
		UAI_UseSkills($a_f_x, $a_f_y, $a_f_AggroRange, $a_f_MaxDistanceToXY)
		Sleep(32)
	Until UAI_CountAgents(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy") = 0 Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Party_IsWiped() Or Map_GetMapID() <> $l_i_MyOldMap Or Map_GetInstanceInfo("Type") <> $l_i_MapLoadingOld
EndFunc   ;==>UAI_Fight

;~ Use this function to cast all of your skills or skills of a certain type.
Func UAI_UseSkills($a_f_x, $a_f_y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500)
	For $l_i_i = 1 To 8
		If UAI_GetStaticSkillInfo($l_i_i, $GC_UAI_STATIC_SKILL_SkillID) = 0 Then ContinueLoop

;~ 	UPDATE CACHE FIRST
		UAI_UpdateCache($a_f_AggroRange)
		If $g_b_CacheWeaponSet Then UAI_ShouldSwitchWeaponSet()

;~ 	CHECK PARTY
		If UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Or Party_IsWiped() = 1 Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsKnockedDown) Then Return
		If UAI_CountAgents(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy") = 0 Then Return

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
;Uses Special flags and Effect2 flags to identify priority skills
Func UAI_PrioritySkills($a_f_AggroRange = 1320)
	; Priority Special flags (from $GC_UAI_STATIC_SKILL_Special)
	Local $l_ai_PrioritySpecialFlags[] = [$GC_I_SKILL_SPECIAL_FLAG_RESURRECTION, $GC_I_SKILL_SPECIAL_FLAG_ELITE]

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
	$g_i_BestTarget = Call($g_as_BestTargetCache[$a_i_Slot], $a_f_AggroRange)
	If $g_i_BestTarget = 0 Then Return

	If Call($g_as_CanUseCache[$a_i_Slot]) Then
		UAI_UseSkillEX($a_i_Slot, $g_i_BestTarget)
		; Actualize cache after casting priority skills
		UAI_UpdateCache($a_f_AggroRange)
	EndIf
EndFunc

; Drop bundle if player has Item Spell buff and can cast (skill is recharged)
Func UAI_DropBundle()
	For $l_i_Slot = 1 To 8
		; Check if skill is an Item Spell
		Local $l_i_Type = UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_SkillType)
		If $l_i_Type <> $GC_I_SKILL_TYPE_ITEM_SPELL Then ContinueLoop

		; Get skill ID to check if player has the buff
		Local $l_i_SkillID = UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_SkillID)
		If $l_i_SkillID = 0 Then ContinueLoop

		; Check if player has the Item Spell buff (holding the ashes)
		If Not UAI_PlayerHasBuff($l_i_SkillID) Then ContinueLoop

		; Check if skill is recharged (can drop bundle)
		If UAI_CanCast($l_i_Slot) Then
			; Drop bundle by using the skill on self
			UAI_UseSkillEX($l_i_Slot, Agent_GetMyID())
			; Actualize cache after casting item spell
			UAI_UpdateCache($a_f_AggroRange)
			Return
		EndIf

		; Check if skill is not recharged (but can drop bundle)
		If UAI_CanDrop($l_i_Slot) Then
			Core_ControlAction($GC_I_CONTROL_ACTION_DROP_ITEM)
			Return
		EndIf
	Next
EndFunc