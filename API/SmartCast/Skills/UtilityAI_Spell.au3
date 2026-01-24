#include-once

Func Anti_Spell()
	;Return true depending on target skills
;~ 	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) Then Return True
;~ 	If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) Then Return True

	;~ Generic hex checks
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False

	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True

	;~ Check for hexes that punish casting by damage
	Local $l_i_CommingDamage = 0

	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BACKFIRE) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_BACKFIRE, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
		$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, "Scale")
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
			$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, "BonusScale")
		EndIf
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP) Then
		$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP, "Scale")
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP) Then
			$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP, "BonusScale")
		EndIf
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MISTRUST, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST_PVP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MISTRUST_PVP, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MARK_OF_SUBVERSION) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MARK_OF_SUBVERSION, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SOUL_LEECH) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SOUL_LEECH, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SPITEFUL_SPIRIT, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPOIL_VICTOR) Then
		If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) < UAI_GetPlayerInfo($GC_UAI_AGENT_HP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SPOIL_VICTOR, "Scale")
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPOIL_VICTOR_PVP) Then
		If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) < UAI_GetPlayerInfo($GC_UAI_AGENT_HP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SPOIL_VICTOR_PVP, "Scale")
	EndIf
	Return $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50)
EndFunc

; Skill ID: 5 - $GC_I_SKILL_ID_POWER_BLOCK
Func CanUse_PowerBlock()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return False
	If Not UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_IsCasting) Then Return False
	Return True
EndFunc

Func BestTarget_PowerBlock($a_f_AggroRange)
	; Description
	; Elite Spell. If target foe is casting a spell or chant, that skill and all skills of the same attribute are disabled for 1...10...12 seconds and that skill is interrupted.
	; Concise description
	; Elite Spell. If target foe is casting a spell or chant, that skill and all skills of the same attribute are disabled (1...10...12 seconds) and that skill is interrupted.
	Return 0
EndFunc

; Skill ID: 21 - $GC_I_SKILL_ID_INSPIRED_ENCHANTMENT
Func CanUse_InspiredEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_InspiredEnchantment($a_f_AggroRange)
	; Description
	; Spell. Removes an enchantment from target foe and gain 3...13...15 Energy. For 20 seconds, Inspired Enchantment is replaced with the enchantment removed from target foe.
	; Concise description
	; Spell. Removes an enchantment from target foe. Removal effects: you gain 3...13...15 Energy; this spell is replaced with that enchantment (20 seconds).
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc

; Skill ID: 22 - $GC_I_SKILL_ID_INSPIRED_HEX
Func CanUse_InspiredHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_InspiredHex($a_f_AggroRange)
	; Description
	; Spell. Remove a hex from target ally and gain 4...9...10 Energy. For 20 seconds, Inspired Hex is replaced with the hex that was removed.
	; Concise description
	; Spell. Removes a hex from target ally. Removal effects: you gain 4...9...10 Energy; this spell is replaced with that hex (20 seconds).
	Return 0
EndFunc

; Skill ID: 23 - $GC_I_SKILL_ID_POWER_SPIKE
Func CanUse_PowerSpike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PowerSpike($a_f_AggroRange)
	; Description
	; Spell. If target foe is casting a spell or a chant, that skill is interrupted and target foe takes 30...102...120 damage.
	; Concise description
	; Spell. Interrupts a spell or chant. Interruption effect: deals 30...102...120 damage.
	Return 0
EndFunc

; Skill ID: 24 - $GC_I_SKILL_ID_POWER_LEAK
Func CanUse_PowerLeak()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PowerLeak($a_f_AggroRange)
	; Description
	; Spell. If target foe is casting a spell or chant, that skill is interrupted and target foe loses 3...14...17 Energy.
	; Concise description
	; Spell. Interrupts a spell or chant. Interruption effect: causes 3...14...17 Energy loss.
	Return 0
EndFunc

; Skill ID: 25 - $GC_I_SKILL_ID_POWER_DRAIN
Func CanUse_PowerDrain()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False

	Local $lSkillID = UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Skill)
	Local $lRuptable = [$GC_I_SKILL_TYPE_HEX, $GC_I_SKILL_TYPE_SPELL, $GC_I_SKILL_TYPE_ENCHANTMENT, $GC_I_SKILL_TYPE_WELL, $GC_I_SKILL_TYPE_WARD, $GC_I_SKILL_TYPE_ITEM_SPELL, $GC_I_SKILL_TYPE_WEAPON_SPELL, $GC_I_SKILL_TYPE_CHANT]

	For $i = 0 To UBound($lRuptable) - 1
		If Skill_GetSkillInfo($lSkillID, "SkillType") = $i Then Return True
	Next

	Return False
EndFunc

Func BestTarget_PowerDrain($a_f_AggroRange)
	; Description
	; Spell. If target foe is casting a spell or chant, that skill is interrupted and you gain 1...25...31 Energy.
	; Concise description
	; Spell. Interrupts a spell or chant. Interruption effect: you gain 1...25...31 Energy.
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster|UAI_Filter_IsCasting")
EndFunc

; Skill ID: 27 - $GC_I_SKILL_ID_SHATTER_DELUSIONS
Func CanUse_ShatterDelusions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShatterDelusions($a_f_AggroRange)
	; Description
	; Spell. Remove one Mesmer hex from target foe. If a hex was removed, that foe and all adjacent foes takes 15...63...75 damage.
	; Concise description
	; Spell. Removes a Mesmer hex from target foe. Removal effect: 15...63...75 damage to target and all adjacent foes.
	; Target enemies with hex for damage, prefer grouped enemies
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
EndFunc

; Skill ID: 39 - $GC_I_SKILL_ID_ENERGY_SURGE
Func CanUse_EnergySurge()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnergySurge($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe loses 1...8...10 Energy. For each point of Energy lost, that foe and all nearby foes take 9 damage.
	; Concise description
	; Elite Spell. Causes 1...8...10 Energy loss. Deals 9 damage to target and nearby foes for each point of Energy lost.

	; Priority 1: Most enemies in nearby range (AOE)
	; Priority 2: Most casters in the group (for energy drain effectiveness)
	Local $l_i_BestAgent = 0
	Local $l_i_BestCount = 0
	Local $l_i_BestCasterCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Check range
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Must be living enemy
		If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop

		; Count enemies in nearby range
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
		; Count casters in nearby range
		Local $l_i_CasterCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")

		; Priority 1: More enemies wins
		; Priority 2: More casters wins (better energy drain targets)
		If $l_i_EnemyCount > $l_i_BestCount Then
			$l_i_BestCount = $l_i_EnemyCount
			$l_i_BestCasterCount = $l_i_CasterCount
			$l_i_BestAgent = $l_i_AgentID
		ElseIf $l_i_EnemyCount = $l_i_BestCount And $l_i_CasterCount > $l_i_BestCasterCount Then
			$l_i_BestCasterCount = $l_i_CasterCount
			$l_i_BestAgent = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAgent
EndFunc

; Skill ID: 40 - $GC_I_SKILL_ID_ETHER_FEAST
Func CanUse_EtherFeast()
	If Anti_Spell() Then Return False
	; Only use if HP is below 70%
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.7 Then Return False
	Return True
EndFunc

Func BestTarget_EtherFeast($a_f_AggroRange)
	; Description
	; Spell. Target foe loses 3 Energy. You are healed 20...56...65 for each point of Energy lost.
	; Concise description
	; Spell. Causes 3 Energy loss. You gain 20...56...65 Health for each point of Energy lost.
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 42 - $GC_I_SKILL_ID_ENERGY_BURN
Func CanUse_EnergyBurn()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnergyBurn($a_f_AggroRange)
	; Description
	; Spell. Target foe loses 1...8...10 Energy and takes 9 damage for each point of Energy lost.
	; Concise description
	; Spell. Causes 1...8...10 Energy loss. Deals 9 damage for each point of Energy lost.
	Return 0
EndFunc

; Skill ID: 57 - $GC_I_SKILL_ID_CRY_OF_FRUSTRATION
Func CanUse_CryOfFrustration()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CryOfFrustration($a_f_AggroRange)
	; Description
	; "CoF" and "Cof" redirects here. For the dungeon, see Cathedral of Flames.
	; Concise description
	; green; font-weight: bold;">15...63...75
	Return 0
EndFunc

; Skill ID: 64 - $GC_I_SKILL_ID_MIMIC
Func CanUse_Mimic()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Mimic($a_f_AggroRange)
	; Description
	; Mesmer
	; Concise description
	; #808080;">Ends after one use.
	Return 0
EndFunc

; Skill ID: 65 - $GC_I_SKILL_ID_ARCANE_MIMICRY
Func CanUse_ArcaneMimicry()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ArcaneMimicry($a_f_AggroRange)
	; Description
	; "AM" redirects here. For the mission, see Abaddon's Mouth.
	; Concise description
	; #808080;">Cannot self-target. No effect if target's elite skill is a form.
	Return 0
EndFunc

; Skill ID: 67 - $GC_I_SKILL_ID_SHATTER_HEX
Func CanUse_ShatterHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShatterHex($a_f_AggroRange)
	; Description
	; Spell. Remove a hex from target ally. If a hex is removed, foes near that ally take 30...102...120 damage.
	; Concise description
	; Spell. Removes a hex from target ally. Removal effect: deals 30...102...120 damage to foes near this ally.
	Return 0
EndFunc

; Skill ID: 68 - $GC_I_SKILL_ID_DRAIN_ENCHANTMENT
Func CanUse_DrainEnchantment()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc

Func BestTarget_DrainEnchantment($a_f_AggroRange)
	; Description
	; Spell. Remove an enchantment from target foe. If an enchantment is removed, you gain 8...15...17 Energy and 40...104...120 Health.
	; Concise description
	; Spell. Removes an enchantment from target foe. Removal effect: you gain 8...15...17 Energy and 40...104...120 Health.
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc

; Skill ID: 69 - $GC_I_SKILL_ID_SHATTER_ENCHANTMENT
Func CanUse_ShatterEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShatterEnchantment($a_f_AggroRange)
	; Description
	; Spell. Remove an enchantment from target foe. If an enchantment is removed, that foe takes 14...83...100 damage.
	; Concise description
	; Spell. Removes an enchantment from target foe. Removal effect: deals 14...83...100 damage.
	Return 0
EndFunc

; Skill ID: 77 - $GC_I_SKILL_ID_CHAOS_STORM
Func CanUse_ChaosStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ChaosStorm($a_f_AggroRange)
	; Description
	; Spell. Create a Chaos Storm at target foe's location that lasts for 10 seconds. Each second, foes adjacent to this location take 5...21...25 damage and lose 0...2...2 Energy.
	; Concise description
	; Spell. Deals 5...21...25 damage and causes 0...2...2 Energy loss each second (10 seconds). Hits foes adjacent to target's initial location.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 78 - $GC_I_SKILL_ID_EPIDEMIC
Func CanUse_Epidemic()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Epidemic($a_f_AggroRange)
	; Description
	; Spell. Spread all negative conditions and their remaining durations from target foe to all foes adjacent to your target.
	; Concise description
	; Spell. Conditions on target foe transfer to adjacent foes.
	Return 0
EndFunc

; Skill ID: 79 - $GC_I_SKILL_ID_ENERGY_DRAIN
Func CanUse_EnergyDrain()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc

Func BestTarget_EnergyDrain($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe loses 2...8...9 Energy. You gain 3 Energy for each point of Energy lost.
	; Concise description
	; Elite Spell. Causes 2...8...9 Energy loss. You gain 3 Energy for each point of Energy lost.

	; Priority 1: Monks
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 2: Casters
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Best single target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 80 - $GC_I_SKILL_ID_ENERGY_TAP
Func CanUse_EnergyTap()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc

Func BestTarget_EnergyTap($a_f_AggroRange)
	; Description
	; Spell. Target foe loses 4...6...7 Energy. You gain 2 Energy for each point of Energy lost.
	; Concise description
	; Spell. Causes 4...6...7 Energy loss. You gain 2 Energy for each point of Energy lost.

	; Priority 1: Monks
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 2: Casters
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Best single target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 81 - $GC_I_SKILL_ID_ARCANE_THIEVERY
Func CanUse_ArcaneThievery()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ArcaneThievery($a_f_AggroRange)
	; Description
	; Spell. For 5...29...35 seconds, one random spell is disabled for target foe, and Arcane Thievery is replaced by that spell.
	; Concise description
	; Spell. (5...29...35 seconds.) Disables one random spell. This skill becomes that spell.
	Return 0
EndFunc

; Skill ID: 83 - $GC_I_SKILL_ID_ANIMATE_BONE_HORROR
Func CanUse_AnimateBoneHorror()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateBoneHorror($a_f_AggroRange)
	; Description
	; Spell. Exploit nearest corpse to animate a level 1...14...17 bone horror.
	; Concise description
	; Spell. Creates a level 1...14...17 bone horror. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 84 - $GC_I_SKILL_ID_ANIMATE_BONE_FIEND
Func CanUse_AnimateBoneFiend()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateBoneFiend($a_f_AggroRange)
	; Description
	; Spell. Exploit nearest corpse to animate a level 1...14...17 bone fiend. Bone fiends can attack at range.
	; Concise description
	; Spell. Creates a level 1...14...17 bone fiend that can attack at range. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 85 - $GC_I_SKILL_ID_ANIMATE_BONE_MINIONS
Func CanUse_AnimateBoneMinions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateBoneMinions($a_f_AggroRange)
	; Description
	; Spell. Exploit nearest corpse to animate two level 0...10...12 bone minions.
	; Concise description
	; Spell. Creates two level 0...10...12 bone minions. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 86 - $GC_I_SKILL_ID_GRENTHS_BALANCE
Func CanUse_GrenthsBalance()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GrenthsBalance($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 87 - $GC_I_SKILL_ID_VERATAS_GAZE
Func CanUse_VeratasGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_VeratasGaze($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 89 - $GC_I_SKILL_ID_DEATHLY_CHILL
Func CanUse_DeathlyChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DeathlyChill($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 5...41...50 cold damage. If that foe's Health is above 50%, you deal an additional 5...41...50 shadow damage.
	; Concise description
	; Spell. Deals 5...41...50 cold damage. Deals 5...41...50 more damage if target foe was above 50% Health.
	Return 0
EndFunc

; Skill ID: 90 - $GC_I_SKILL_ID_VERATAS_SACRIFICE
Func CanUse_VeratasSacrifice()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_VeratasSacrifice($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 95 - $GC_I_SKILL_ID_PUTRID_EXPLOSION
Func CanUse_PutridExplosion()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PutridExplosion($a_f_AggroRange)
	; Description
	; Spell. The corpse nearest your target explodes, sending out a shockwave that deals 24...101...120 damage to nearby foes.
	; Concise description
	; Spell. Explodes a corpse, dealing 24...101...120 damage to foes near it. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc

; Skill ID: 96 - $GC_I_SKILL_ID_SOUL_FEAST
Func CanUse_SoulFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SoulFeast($a_f_AggroRange)
	; Description
	; Spell. Exploit nearest corpse to gain 50...234...280 Health.
	; Concise description
	; Spell. You gain 50...234...280 Health. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 97 - $GC_I_SKILL_ID_NECROTIC_TRAVERSAL
Func CanUse_NecroticTraversal()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NecroticTraversal($a_f_AggroRange)
	; Description
	; Spell. Exploit a random corpse. You teleport to that corpse's location and all nearby foes become Poisoned for 5...17...20 seconds.
	; Concise description
	; Spell. Teleport to a corpse's location. Inflicts Poisoned condition (5...17...20 seconds). Affects all nearby foes. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 98 - $GC_I_SKILL_ID_CONSUME_CORPSE
Func CanUse_ConsumeCorpse()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ConsumeCorpse($a_f_AggroRange)
	; Description
	; Spell. Exploit a random corpse. You teleport to that corpse's location and gain 25...85...100 Health and 5...17...20 Energy.
	; Concise description
	; Spell. Teleport to a corpse's location. You gain 25...85...100 Health and 5...17...20 Energy. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 102 - $GC_I_SKILL_ID_SHADOW_STRIKE
Func CanUse_ShadowStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowStrike($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 12...41...48 shadow damage. If that foe's Health is above 50%, you steal up to 12...41...48 Health.
	; Concise description
	; Spell. Deals 12...41...48 damage. Steal up to 12...41...48 Health if this foe was above 50% Health.
	Return 0
EndFunc

; Skill ID: 105 - $GC_I_SKILL_ID_DEATHLY_SWARM
Func CanUse_DeathlySwarm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DeathlySwarm($a_f_AggroRange)
	; Description
	; Spell. Deathly Swarm flies out slowly and strikes for 30...78...90 cold damage on up to three targets in the area.
	; Concise description
	; Spell. Deathly Swarm flies out slowly and deals 30...78...90 cold damage. Hits two additional foes in the area.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 106 - $GC_I_SKILL_ID_ROTTING_FLESH
Func CanUse_RottingFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RottingFlesh($a_f_AggroRange)
	; Description
	; Spell. Target fleshy foe becomes Diseased for 10...22...25 seconds, slowly losing Health.
	; Concise description
	; Spell. Inflicts Diseased condition (10...22...25 seconds).
	Return 0
EndFunc

; Skill ID: 107 - $GC_I_SKILL_ID_VIRULENCE
Func CanUse_Virulence()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Virulence($a_f_AggroRange)
	; Description
	; Elite Spell. If target foe was already suffering from a condition, that foe suffers from Disease, Poison, and Weakness for 3...13...15 seconds.
	; Concise description
	; Elite Spell. Inflicts Disease, Poison, and Weakness conditions (3...13...15 seconds). No effect unless this foe already had a condition.
	Return 0
EndFunc

; Skill ID: 110 - $GC_I_SKILL_ID_UNHOLY_FEAST
Func CanUse_UnholyFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UnholyFeast($a_f_AggroRange)
	; Description
	; Spell. Steal up to 10...54...65 Health from up to 1...3...4 foes  in the area.
	; Concise description
	; Spell. Steals 10...54...65 Health from 1...3...4 foe[s] in the area around you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 112 - $GC_I_SKILL_ID_DESECRATE_ENCHANTMENTS
Func CanUse_DesecrateEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DesecrateEnchantments($a_f_AggroRange)
	; Description
	; Spell. Target foe and all nearby foes take 6...49...60 shadow damage and 4...17...20 shadow damage for each enchantment on them.
	; Concise description
	; Spell. Deals 6...49...60 damage to target and nearby foes. Deals 4...17...20 more damage for each enchantment on them.
	Return 0
EndFunc

; Skill ID: 117 - $GC_I_SKILL_ID_ENFEEBLE1
Func CanUse_Enfeeble1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Enfeeble1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 118 - $GC_I_SKILL_ID_ENFEEBLING_BLOOD
Func CanUse_EnfeeblingBlood()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnfeeblingBlood($a_f_AggroRange)
	; Description
	; Spell. Target foe and all nearby foes suffer from Weakness for 5...17...20 seconds.
	; Concise description
	; Spell. Inflicts Weakness condition (5...17...20 seconds) on this foe and nearby foes.
	Return 0
EndFunc

; Skill ID: 120 - $GC_I_SKILL_ID_BLOOD_OF_THE_MASTER
Func CanUse_BloodOfTheMaster()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BloodOfTheMaster($a_f_AggroRange)
	; Description
	; Spell. All of your undead allies are healed for 30...99...116 Health. You sacrifice an additional 2% maximum Health per minion healed in this way.
	; Concise description
	; Spell. Heals your undead servants for 30...99...116. Healing cost: +2% Health sacrifice per servant healed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 133 - $GC_I_SKILL_ID_DARK_PACT
Func CanUse_DarkPact()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DarkPact($a_f_AggroRange)
	; Description
	; Spell. Deal 10...40...48 shadow damage to target foe.
	; Concise description
	; Spell. Deals 10...40...48 damage.
	Return 0
EndFunc

; Skill ID: 141 - $GC_I_SKILL_ID_REND_ENCHANTMENTS
Func CanUse_RendEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RendEnchantments($a_f_AggroRange)
	; Description
	; Spell. Remove 5...8...9 enchantments from target foe. For each Monk enchantment removed, you lose 55...31...25 Health.
	; Concise description
	; Spell. Removes 5...8...9 enchantments from target foe. Removal cost: you lose 55...31...25 Health for each Monk enchantment removed.
	Return 0
EndFunc

; Skill ID: 143 - $GC_I_SKILL_ID_STRIP_ENCHANTMENT
Func CanUse_StripEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_StripEnchantment($a_f_AggroRange)
	; Description
	; Spell. Remove 0...2...2 enchantment[s] from target foe. If an enchantment is removed, you steal 5...53...65 Health.
	; Concise description
	; Spell. Removes 0...2...2 enchantment[s] from target foe. Removal effect: you steal 5...53...65 Health.
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc

; Skill ID: 144 - $GC_I_SKILL_ID_CHILBLAINS
Func CanUse_Chilblains()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Chilblains($a_f_AggroRange)
	; Description
	; Spell. You become Poisoned for 10 seconds. Foes in the area of your target are struck for 10...37...44 cold damage and lose 1...2...2 enchantment[s].
	; Concise description
	; Spell. Deals 10...37...44 cold damage to foes in the area around your target; removes 1...2...2 enchantment[s] from these foes. You are Poisoned (10 seconds).
	Return 0
EndFunc

; Skill ID: 146 - $GC_I_SKILL_ID_OFFERING_OF_BLOOD
Func CanUse_OfferingOfBlood()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OfferingOfBlood($a_f_AggroRange)
	; Description
	; Elite Spell. You gain 8...18...20 Energy.
	; Concise description
	; Elite Spell. You gain 8...18...20 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 149 - $GC_I_SKILL_ID_PLAGUE_SENDING
Func CanUse_PlagueSending()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PlagueSending($a_f_AggroRange)
	; Description
	; Spell. Transfer 1...3...3 negative condition[s] and [its/their] remaining duration[s] from yourself to target foe and all adjacent foes.
	; Concise description
	; Spell. Transfer 1...3...3 condition[s] and [its/their] remaining duration[s] from yourself to target foe and all adjacent foes.
	Return 0
EndFunc

; Skill ID: 151 - $GC_I_SKILL_ID_FEAST_OF_CORRUPTION
Func CanUse_FeastOfCorruption()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FeastOfCorruption($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe and all adjacent foes are struck for 16...67...80 shadow damage. You steal up to 8...34...40 Health from each struck foe who is suffering from a hex.
	; Concise description
	; Elite Spell. Deals 16...67...80 damage to target and adjacent foes. Steal 8...34...40 Health from each hexed foe.
	Return 0
EndFunc

; Skill ID: 152 - $GC_I_SKILL_ID_TASTE_OF_DEATH
Func CanUse_TasteOfDeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TasteOfDeath($a_f_AggroRange)
	; Description
	; Spell. Steal up to 100...340...400 Health from target animated undead ally.
	; Concise description
	; Spell. Steals 100...340...400 Health from allied undead servant.
	Return 0
EndFunc

; Skill ID: 153 - $GC_I_SKILL_ID_VAMPIRIC_GAZE
Func CanUse_VampiricGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_VampiricGaze($a_f_AggroRange)
	; Description
	; Spell. Steal up to 18...52...60 Health from target foe.
	; Concise description
	; Spell. Steals 18...52...60 Health.
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 159 - $GC_I_SKILL_ID_WEAKEN_ARMOR
Func CanUse_WeakenArmor()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WeakenArmor($a_f_AggroRange)
	; Description
	; Spell. Target foe and foes adjacent to your target have Cracked Armor for 5...17...20 seconds.
	; Concise description
	; Spell. Also affects adjacent foes. Inflicts Cracked Armor condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 161 - $GC_I_SKILL_ID_LIGHTNING_STORM
Func CanUse_LightningStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningStorm($a_f_AggroRange)
	; Description
	; Elementalist
	; Concise description
	; green; font-weight: bold;">14...61...73
	Return 0
EndFunc

; Skill ID: 162 - $GC_I_SKILL_ID_GALE
Func CanUse_Gale()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Gale($a_f_AggroRange)
	; Description
	; Spell. Knock down target foe for 2 seconds. (50% failure chance with Air Magic 4 or less.)
	; Concise description
	; Spell. Causes knock-down. 50% failure chance unless Air Magic 5 or more.
	Return 0
EndFunc

; Skill ID: 163 - $GC_I_SKILL_ID_WHIRLWIND
Func CanUse_Whirlwind()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Whirlwind($a_f_AggroRange)
	; Description
	; Spell. All adjacent foes take 15...63...75 cold damage. Attacking foes struck by Whirlwind are knocked down. If you are Overcast, this spell strikes nearby instead of adjacent.
	; Concise description
	; Spell. Hits foes adjacent to you. Deals 15...63...75 cold damage. Causes knock-down to attacking foes. Strikes nearby instead of adjacent if Overcast.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 167 - $GC_I_SKILL_ID_ERUPTION
Func CanUse_Eruption()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Eruption($a_f_AggroRange)
	; Description
	; Spell. Cause an Eruption at target foe's location. Each second for 5 seconds, foes near this location are struck for 10...34...40 earth damage and are Blinded for 10 seconds.
	; Concise description
	; Spell. Deals 10...34...40 earth damage each second (5 seconds). Hits foes near target's initial location. Inflicts Blindness condition (10 seconds).
	Return 0
EndFunc

; Skill ID: 170 - $GC_I_SKILL_ID_EARTHQUAKE
Func CanUse_Earthquake()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Earthquake($a_f_AggroRange)
	; Description
	; Spell. You invoke an Earthquake at target foe's location. All foes near this location are knocked down and are struck for 26...85...100 earth damage.
	; Concise description
	; Spell. Deals 26...85...100 earth damage. Also hits foes near target. Causes knock-down.
	Return 0
EndFunc

; Skill ID: 171 - $GC_I_SKILL_ID_STONING
Func CanUse_Stoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Stoning($a_f_AggroRange)
	; Description
	; Spell. Send out a large stone, striking target foe for 45...93...105 earth damage if it hits. If Stoning hits a foe suffering from Weakness, that foe is knocked down.
	; Concise description
	; Spell. Projectile: deals 45...93...105 earth damage. Causes knock-down if target foe is Weakened.
	Return 0
EndFunc

; Skill ID: 172 - $GC_I_SKILL_ID_STONE_DAGGERS
Func CanUse_StoneDaggers()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_StoneDaggers($a_f_AggroRange)
	; Description
	; Spell. Send out two Stone Daggers. Each Stone Dagger strikes target foe for 8...28...33 earth damage if it hits. If you are Overcast, each projectile inflicts Bleeding for 1...4...5 second[s].
	; Concise description
	; Spell. Two projectiles: each deals 8...28...33 earth damage. If Overcast, cause Bleeding for 1...4...5 second[s].
	Return 0
EndFunc

; Skill ID: 174 - $GC_I_SKILL_ID_AFTERSHOCK
Func CanUse_Aftershock()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Aftershock($a_f_AggroRange)
	; Description
	; Spell. Nearby foes are struck for 26...85...100 earth damage. Knocked down foes are struck for 10...56...68 additional earth damage.
	; Concise description
	; Spell. Deals 26...85...100 earth damage to nearby foes. Deals 10...56...68 more earth damage to knocked down foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 183 - $GC_I_SKILL_ID_INFERNO
Func CanUse_Inferno()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Inferno($a_f_AggroRange)
	; Description
	; Spell. All adjacent foes are struck for 30...114...135 fire damage.
	; Concise description
	; Spell. Deals 30...114...135 fire damage to foes adjacent to you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 185 - $GC_I_SKILL_ID_MIND_BURN
Func CanUse_MindBurn()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MindBurn($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe and all adjacent foes take 15...51...60 fire damage. If you have more Energy than target foe, that foe and all adjacent foes take an additional 15...51...60 fire damage and are set on fire for 1...8...10 second[s].
	; Concise description
	; Elite Spell. Deals 15...51...60 fire damage. If you have more energy than target foe, deals 15...51...60 more fire damage and inflicts Burning (1...8...10 second[s]). Also hits adjacent foes.
	Return 0
EndFunc

; Skill ID: 186 - $GC_I_SKILL_ID_FIREBALL
Func CanUse_Fireball()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Fireball($a_f_AggroRange)
	; Description
	; This article is about the skill. For the effect from the Obelisk Flag Stand, see Fireball (obelisk).
	; Concise description
	; deals
	Return 0
EndFunc

; Skill ID: 187 - $GC_I_SKILL_ID_METEOR
Func CanUse_Meteor()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Meteor($a_f_AggroRange)
	; Description
	; Spell. Target foe and all adjacent foes are struck for 7...91...112 fire damage and knocked down.
	; Concise description
	; Spell. Deals 7...91...112 fire damage and causes knock-down. Also hits foes adjacent to target foe.
	Return 0
EndFunc

; Skill ID: 188 - $GC_I_SKILL_ID_FLAME_BURST
Func CanUse_FlameBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FlameBurst($a_f_AggroRange)
	; Description
	; Spell. All nearby foes are struck for 15...99...120 fire damage.
	; Concise description
	; Spell. Deals 15...99...120 fire damage to all foes near you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 189 - $GC_I_SKILL_ID_RODGORTS_INVOCATION
Func CanUse_RodgortsInvocation()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RodgortsInvocation($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 191 - $GC_I_SKILL_ID_IMMOLATE
Func CanUse_Immolate()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Immolate($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 20...64...75 fire damage and is set on fire for 1...3...3 second[s].
	; Concise description
	; Spell. Deals 20...64...75 fire damage. Inflicts Burning condition (1...3...3 second[s]).
	Return 0
EndFunc

; Skill ID: 192 - $GC_I_SKILL_ID_METEOR_SHOWER
Func CanUse_MeteorShower()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MeteorShower($a_f_AggroRange)
	; Description
	; Spell. Create a Meteor Shower at target foe's location. For 9 seconds, foes adjacent to that location are struck for 7...91...112 fire damage and knocked down every 3 seconds.
	; Concise description
	; Spell. Deals 7...91...112 fire damage and causes knock-down every 3 seconds (9 seconds). Hits foes adjacent to target's initial location.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 193 - $GC_I_SKILL_ID_PHOENIX
Func CanUse_Phoenix()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Phoenix($a_f_AggroRange)
	; Description
	; This article is about the spell. For the animal companion, see Phoenix (pet).
	; Concise description
	; deals
	Return 0
EndFunc

; Skill ID: 194 - $GC_I_SKILL_ID_FLARE
Func CanUse_Flare()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Flare($a_f_AggroRange)
	; Description
	; Spell. Send out a flare that strikes target foe for 20...56...65 fire damage if it hits. If you are Overcast, Flare hits adjacent foes as well.
	; Concise description
	; Spell. Projectile: deals 20...56...65 fire damage. If Overcast, strikes adjacent.
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 195 - $GC_I_SKILL_ID_LAVA_FONT
Func CanUse_LavaFont()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LavaFont($a_f_AggroRange)
	; Description
	; Spell. For 5 seconds, foes adjacent to the location where this spell was cast are struck for 5...41...50 fire damage each second. If you are Overcast, this spell strikes nearby foes instead of adjacent ones.
	; Concise description
	; Spell. Deals 5...41...50 fire damage each second (5 seconds). Hits foes adjacent to your initial location. If Overcast, range increased to nearby.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 196 - $GC_I_SKILL_ID_SEARING_HEAT
Func CanUse_SearingHeat()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SearingHeat($a_f_AggroRange)
	; Description
	; Spell. Cause Searing Heat at target foe's location. For 5 seconds, foes near this location are struck for 10...34...40 fire damage each second. When Searing Heat ends, foes in the area of effect are set on fire for 3 seconds.
	; Concise description
	; Spell. Deals 10...34...40 fire damage each second (5 seconds). Hits foes near target's initial location. End effect: inflicts Burning condition (3 seconds).
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 197 - $GC_I_SKILL_ID_FIRE_STORM
Func CanUse_FireStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireStorm($a_f_AggroRange)
	; Description
	; Spell. Create a Fire Storm at target foe's location. For 10 seconds, foes adjacent to that location are struck for 5...29...35 fire damage each second.
	; Concise description
	; Spell. Deals 5...29...35 fire damage each second (10 seconds). Hits foes adjacent to target's initial location.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 215 - $GC_I_SKILL_ID_MAELSTROM
Func CanUse_Maelstrom()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Maelstrom($a_f_AggroRange)
	; Description
	; Spell. Create a Maelstrom at target foe's location. For 10 seconds, foes adjacent to that area are struck for 10...22...25 cold damage each second. Maelstrom interrupts spell-casting when it hits.
	; Concise description
	; Spell. Deals 10...22...25 cold damage and interrupts spells each second (10 seconds). Hits foes adjacent to target's initial location.
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 217 - $GC_I_SKILL_ID_CRYSTAL_WAVE
Func CanUse_CrystalWave()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CrystalWave($a_f_AggroRange)
	; Description
	; Spell. Foes adjacent to you are struck for 10...58...70 damage but are cured of any negative conditions. Each condition removed deals 5...13...15 damage.
	; Concise description
	; Spell. Deals 10...58...70 damage to all foes adjacent to you. Those foes lose all conditions and take 5...13...15 damage for each condition removed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 219 - $GC_I_SKILL_ID_OBSIDIAN_FLAME
Func CanUse_ObsidianFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ObsidianFlame($a_f_AggroRange)
	; Description
	; This article is about a spell. For the guild found in Cantha, see Obsidian Flame (guild).
	; Concise description
	; green; font-weight: bold;">22...94...112
	Return 0
EndFunc

; Skill ID: 220 - $GC_I_SKILL_ID_BLINDING_FLASH
Func CanUse_BlindingFlash()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BlindingFlash($a_f_AggroRange)
	; Description
	; Spell. Target foe is Blinded for 3...7...8 seconds.
	; Concise description
	; Spell. Inflicts Blindness condition (3...7...8 seconds).
	; Blinded affects attacks, so prefer attacking enemies
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 223 - $GC_I_SKILL_ID_CHAIN_LIGHTNING
Func CanUse_ChainLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ChainLightning($a_f_AggroRange)
	; Description
	; Spell. Target foe and up to two other foes near your target are struck for 10...70...85 lightning damage. This spell has 25% armor penetration.
	; Concise description
	; Spell. Deals 10...70...85 lightning damage. Also hits two foes near your target. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 224 - $GC_I_SKILL_ID_ENERVATING_CHARGE
Func CanUse_EnervatingCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnervatingCharge($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 25...45...50 lightning damage and suffers from Weakness for 5...17...20 seconds. This spell has 25% armor penetration.
	; Concise description
	; Spell. Deals 25...45...50 lightning damage. Inflicts Weakness condition (5...17...20 seconds). 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 226 - $GC_I_SKILL_ID_MIND_SHOCK
Func CanUse_MindShock()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MindShock($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe suffers 10...42...50 lightning damage. If you have more Energy than target foe, that foe suffers 10...42...50 more lightning damage and is knocked down. This spell has 25% armor penetration.
	; Concise description
	; Elite Spell. Deals 10...42...50 lightning damage. If you have more Energy than target foe, deals +10...42...50 lightning damage and causes knockdown. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 228 - $GC_I_SKILL_ID_THUNDERCLAP
Func CanUse_Thunderclap()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Thunderclap($a_f_AggroRange)
	; Description
	; Elite Spell. Create a massive shockwave at target foe's location. Deals 10...42...50 lightning damage to target and all adjacent foes. Struck foes are interrupted and suffer from Cracked Armor and Weakness for 5...17...20 seconds. This spell has 25% armor penetration.
	; Concise description
	; Elite Spell. Deals 10...42...50 lightning damage. Also strikes adjacent foes. Inflicts Cracked Armor and Weakness (5...17...20 seconds). Causes interrupt. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 229 - $GC_I_SKILL_ID_LIGHTNING_ORB1
Func CanUse_LightningOrb1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningOrb1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 230 - $GC_I_SKILL_ID_LIGHTNING_JAVELIN
Func CanUse_LightningJavelin()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningJavelin($a_f_AggroRange)
	; Description
	; Spell. Send out a Lightning Javelin that strikes for 15...43...50 lightning damage if it hits. Lightning Javelin interrupts attacking foes. This spell has 25% armor penetration and strikes all foes between you and your target.
	; Concise description
	; Spell. Projectile: Deals 15...43...50 lightning damage. Interrupts if your target is attacking. 25% armor penetration. Strikes all foes between you and your target.
	; Prefer attacking enemies for interrupt effect
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 237 - $GC_I_SKILL_ID_WATER_TRIDENT
Func CanUse_WaterTrident()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WaterTrident($a_f_AggroRange)
	; Description
	; Elite Spell. Send out a fast-moving Water Trident, striking target foe and up to 2 adjacent foes for 10...74...90 cold damage if it hits. If it hits a moving foe, that foe is knocked down.
	; Concise description
	; Elite Spell. Fast Projectile: deals 10...74...90 cold damage and knocks-down moving foes. Shoots 2 additional projectiles at adjacent foes.
	Return 0
EndFunc

; Skill ID: 240 - $GC_I_SKILL_ID_SMITE
Func CanUse_Smite()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Smite($a_f_AggroRange)
	; Description
	; Spell. This attack  deals 10...46...55 Holy  damage. If attacking, your target takes an additional 10...30...35 Holy  damage.
	; Concise description
	; Spell. Deals 10...46...55 holy damage. Deals 10...30...35 more holy damage if target is attacking.
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc

; Skill ID: 247 - $GC_I_SKILL_ID_SYMBOL_OF_WRATH
Func CanUse_SymbolOfWrath()
	If Anti_Spell() Then Return False
	; Only use if there are adjacent enemies
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") < 1 Then Return False
	Return True
EndFunc

Func BestTarget_SymbolOfWrath($a_f_AggroRange)
	; Description
	; Spell. For 5 seconds, foes adjacent to the location in which the spell was cast take 8...27...32 holy damage each second.
	; Concise description
	; Spell. Deals 8...27...32 holy damage each second (5 seconds). Hits foes adjacent to your initial location.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 252 - $GC_I_SKILL_ID_BANISH
Func CanUse_Banish()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Banish($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 20...49...56 holy damage. This spell does double damage to summoned creatures.
	; Concise description
	; Spell. Deals 20...49...56 holy damage. Deals double damage to summoned creatures.
	; Prefer summoned creatures (minions, spirits) for double damage
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMinion")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsSpirit")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 275 - $GC_I_SKILL_ID_MEND_CONDITION
Func CanUse_MendCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MendCondition($a_f_AggroRange)
	; Description
	; Spell. Remove one condition (Poison, Disease, Blindness, Dazed, Bleeding, Crippled, Burning, Weakness, Cracked Armor, or Deep Wound) from target other ally. If a condition is removed, that ally is healed for 5...57...70 Health.
	; Concise description
	; Spell. Removes one condition. Removal effect: heals for 5...57...70. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 276 - $GC_I_SKILL_ID_RESTORE_CONDITION
Func CanUse_RestoreCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RestoreCondition($a_f_AggroRange)
	; Description
	; Elite Spell. Remove all conditions (Poison, Disease, Blindness, Dazed, Bleeding, Crippled, Burning, Weakness, Cracked Armor, and Deep Wound) from target other ally. For each condition removed, that ally is healed for 10...58...70 Health.
	; Concise description
	; Elite Spell. Removes all conditions. Removal effect: heals for 10...58...70 for each condition removed. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 277 - $GC_I_SKILL_ID_MEND_AILMENT
Func CanUse_MendAilment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MendAilment($a_f_AggroRange)
	; Description
	; Spell. Remove one condition (Poison, Disease, Blindness, Dazed, Bleeding, Crippled, Burning, Weakness, Cracked Armor, or Deep Wound) from target ally. For each remaining Condition, that ally is healed for 5...57...70 Health.
	; Concise description
	; Spell. Removes a condition. Removal effect: heals for 5...57...70 for each remaining condition.
	Return 0
EndFunc

; Skill ID: 278 - $GC_I_SKILL_ID_PURGE_CONDITIONS
Func CanUse_PurgeConditions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PurgeConditions($a_f_AggroRange)
	; Description
	; Spell. Remove all conditions (Poison, Disease, Blindness, Dazed, Bleeding, Crippled, Burning, Weakness, Cracked Armor, and Deep Wound) from target ally.
	; Concise description
	; Spell. Removes all conditions.
	Return 0
EndFunc

; Skill ID: 279 - $GC_I_SKILL_ID_DIVINE_HEALING
Func CanUse_DivineHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DivineHealing($a_f_AggroRange)
	; Description
	; Spell. Heals you and party members within earshot for 15...51...60 points.
	; Concise description
	; Spell. Heals you and party members within earshot for 15...51...60.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 280 - $GC_I_SKILL_ID_HEAL_AREA
Func CanUse_HealArea()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealArea($a_f_AggroRange)
	; Description
	; Spell. Heal yourself and all adjacent creatures for 30...150...180 points.
	; Concise description
	; Spell. Heals you and adjacent allies and foes for 30...150...180.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 281 - $GC_I_SKILL_ID_ORISON_OF_HEALING
Func CanUse_OrisonOfHealing()
	If Anti_Spell() Then Return False
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc

Func BestTarget_OrisonOfHealing($a_f_AggroRange)
	; Description
	; Spell. Heal target ally for 20...60...70 Health.
	; Concise description
	; Spell. Heals for 20...60...70.
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc

; Skill ID: 282 - $GC_I_SKILL_ID_WORD_OF_HEALING
Func CanUse_WordOfHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WordOfHealing($a_f_AggroRange)
	; Description
	; Elite Spell. Heal target ally for 5...81...100 Health. Heal for an additional 30...98...115 Health if that ally is below 50% Health.
	; Concise description
	; Elite Spell. Heals for 5...81...100. Heals for 30...98...115 more if target ally is below 50% Health.
	Return 0
EndFunc

; Skill ID: 283 - $GC_I_SKILL_ID_DWAYNAS_KISS
Func CanUse_DwaynasKiss()
	If Anti_Spell() Then Return False
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc

Func BestTarget_DwaynasKiss($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsEnchanted|UAI_Filter_IsHexed")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.8 And $l_i_Target <> 0 Then Return $l_i_Target

	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsHexed")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.8 And $l_i_Target <> 0 Then Return $l_i_Target

	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsEnchanted")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.8 And $l_i_Target <> 0 Then Return $l_i_Target

	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.5 And $l_i_Target <> 0 Then Return $l_i_Target

	Return 0
EndFunc

; Skill ID: 286 - $GC_I_SKILL_ID_HEAL_OTHER
Func CanUse_HealOther()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealOther($a_f_AggroRange)
	; Description
	; Spell. Heal target other ally for 35...151...180 Health.
	; Concise description
	; Spell. Heals for 35...151...180. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 287 - $GC_I_SKILL_ID_HEAL_PARTY
Func CanUse_HealParty()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealParty($a_f_AggroRange)
	; Description
	; Spell. Heal entire party for 30...66...75 Health.
	; Concise description
	; Spell. Heals entire party for 30...66...75.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 292 - $GC_I_SKILL_ID_INFUSE_HEALTH
Func CanUse_InfuseHealth()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_InfuseHealth($a_f_AggroRange)
	; Description
	; Spell. Lose half your current Health. Target other ally is healed for 100...129...136% of the amount you lost.
	; Concise description
	; Spell. Heals for 100...129...136% of half your current Health. Lose half your current Health. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 298 - $GC_I_SKILL_ID_MARTYR
Func CanUse_Martyr()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Martyr($a_f_AggroRange)
	; Description
	; Elite Spell. Transfer all conditions and their remaining durations from your allies to you.
	; Concise description
	; Elite Spell. Transfer all conditions from all allies to you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 301 - $GC_I_SKILL_ID_REMOVE_HEX
Func CanUse_RemoveHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveHex($a_f_AggroRange)
	; Description
	; Spell. Remove a hex from target ally.
	; Concise description
	; Spell. Removes a hex from target ally.
	Return 0
EndFunc

; Skill ID: 302 - $GC_I_SKILL_ID_SMITE_HEX
Func CanUse_SmiteHex()
	If Anti_Spell() Then Return False
	If UAI_CountAgents($g_i_BestTarget, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy") < 1 Then Return False
	Return True
EndFunc

Func BestTarget_SmiteHex($a_f_AggroRange)
	; Description
	; Spell. Remove a hex from target ally. If a hex is removed, foes in the area suffer 10...70...85 holy damage.
	; Concise description
	; Spell. Removes a hex from target ally. Removal effect: deals 10...70...85 holy damage to foes in the area of target ally.
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
EndFunc

; Skill ID: 303 - $GC_I_SKILL_ID_CONVERT_HEXES
Func CanUse_ConvertHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ConvertHexes($a_f_AggroRange)
	; Description
	; Spell. Remove all hexes from target other ally. For 8...18...20 seconds, that ally gains +10 armor for each Necromancer hex that was removed.
	; Concise description
	; Spell. Removes all hexes; +10 armor for each Necromancer hex removed (8...18...20 seconds). Cannot self-target.
	Return 0
EndFunc

; Skill ID: 304 - $GC_I_SKILL_ID_LIGHT_OF_DWAYNA
Func CanUse_LightOfDwayna()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_LightOfDwayna($a_f_AggroRange)
	; Description
	; Spell. Resurrect all dead party members in the area. They are returned to life with 25% Health and zero Energy.
	; Concise description
	; Spell. Resurrects all dead party members in the area. (25% Health, zero Energy).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 305 - $GC_I_SKILL_ID_RESURRECT
Func CanUse_Resurrect()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_Resurrect($a_f_AggroRange)
	; Description
	; This article is about the Monk skill. For the game mechanic, see Resurrection. For the monster skills, see Resurrect (monster skill) and Resurrect (Gargoyle).
	; Concise description
	; none" />
	Return 0
EndFunc

; Skill ID: 306 - $GC_I_SKILL_ID_REBIRTH
Func CanUse_Rebirth()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_Rebirth($a_f_AggroRange)
	; Description
	; Spell. Resurrect target party member. Target party member is returned to life with 25% Health and zero Energy, and is teleported to your current location. All of target's skills are disabled for 10...4...3 seconds. This spell consumes all of your remaining Energy.
	; Concise description
	; Spell. Resurrects target party member (25% Health, 0 Energy). Teleports target to you. Disables target's skills (10...4...3 seconds). You lose all Energy.
	Return 0
EndFunc

; Skill ID: 311 - $GC_I_SKILL_ID_DRAW_CONDITIONS
Func CanUse_DrawConditions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DrawConditions($a_f_AggroRange)
	; Description
	; Spell. All negative conditions are transferred from target other ally to yourself. For each condition acquired, you gain 6...22...26 Health.
	; Concise description
	; Spell. Transfers all conditions from target ally to yourself. Transfer effect: you gain 6...22...26 Health for each condition. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 313 - $GC_I_SKILL_ID_HEALING_TOUCH
Func CanUse_HealingTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealingTouch($a_f_AggroRange)
	; Description
	; Spell. Heal target touched ally for 16...51...60 Health. Health gain from Divine Favor is doubled for this spell.
	; Concise description
	; Touch Spell. Heals for 16...51...60. Double Health gain from Divine Favor for this spell.
	Return 0
EndFunc

; Skill ID: 314 - $GC_I_SKILL_ID_RESTORE_LIFE
Func CanUse_RestoreLife()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_RestoreLife($a_f_AggroRange)
	; Description
	; Spell. Touch the body of a fallen party member. Target party member is returned to life with 20...56...65% Health and 42...80...90% Energy.
	; Concise description
	; Touch Spell. Resurrects target party member (20...56...65% Health, 42...80...90% Energy).
	Return 0
EndFunc

; Skill ID: 488 - $GC_I_SKILL_ID_ERUPTION_ENVIRONMENT
Func CanUse_EruptionEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EruptionEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 489 - $GC_I_SKILL_ID_FIRE_STORM_ENVIRONMENT
Func CanUse_FireStormEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireStormEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 491 - $GC_I_SKILL_ID_FOUNT_OF_MAGUUMA
Func CanUse_FountOfMaguuma()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FountOfMaguuma($a_f_AggroRange)
	; Description
	; Prophecies
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 492 - $GC_I_SKILL_ID_HEALING_FOUNTAIN
Func CanUse_HealingFountain()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealingFountain($a_f_AggroRange)
	; Description
	; Prophecies
	; Concise description
	; Related Skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 493 - $GC_I_SKILL_ID_ICY_GROUND
Func CanUse_IcyGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_IcyGround($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Locations">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 494 - $GC_I_SKILL_ID_MAELSTROM_ENVIRONMENT
Func CanUse_MaelstromEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MaelstromEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 495 - $GC_I_SKILL_ID_MURSAAT_TOWER_SKILL
Func CanUse_MursaatTowerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MursaatTowerSkill($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 496 - $GC_I_SKILL_ID_QUICKSAND_ENVIRONMENT_EFFECT
Func CanUse_QuicksandEnvironmentEffect()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_QuicksandEnvironmentEffect($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 497 - $GC_I_SKILL_ID_CURSE_OF_THE_BLOODSTONE
Func CanUse_CurseOfTheBloodstone()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CurseOfTheBloodstone($a_f_AggroRange)
	; Description
	; Prophecies
	; Concise description
	; Note">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 498 - $GC_I_SKILL_ID_CHAIN_LIGHTNING_ENVIRONMENT
Func CanUse_ChainLightningEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ChainLightningEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 499 - $GC_I_SKILL_ID_OBELISK_LIGHTNING
Func CanUse_ObeliskLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ObeliskLightning($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 500 - $GC_I_SKILL_ID_TAR
Func CanUse_Tar()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Tar($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; 302px;">
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 525 - $GC_I_SKILL_ID_NIBBLE
Func CanUse_Nibble()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Nibble($a_f_AggroRange)
	; Description
	; Spell. Touch target corpse to gain 20 Health.
	; Concise description
	; Touch Spell. Touch target corpse to gain 20 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 543 - $GC_I_SKILL_ID_GUARDIAN_PACIFY
Func CanUse_GuardianPacify()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GuardianPacify($a_f_AggroRange)
	; Description
	; Spell. Guardians become pacified until attacked.
	; Concise description
	; Spell. Guardians become pacified until attacked.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 544 - $GC_I_SKILL_ID_SOUL_VORTEX
Func CanUse_SoulVortex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SoulVortex($a_f_AggroRange)
	; Description
	; Spell. (monster only)
	; Concise description
	; Spell. (monster only)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 545 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 560 - $GC_I_SKILL_ID_RESURRECT_GARGOYLE
Func CanUse_ResurrectGargoyle()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ResurrectGargoyle($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 562 - $GC_I_SKILL_ID_LIGHTNING_ORB2
Func CanUse_LightningOrb2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningOrb2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 563 - $GC_I_SKILL_ID_WURM_SIEGE_DUNES_OF_DESPAIR
Func CanUse_WurmSiegeDunesOfDespair()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WurmSiegeDunesOfDespair($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 564 - $GC_I_SKILL_ID_WURM_SIEGE
Func CanUse_WurmSiege()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WurmSiege($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 566 - $GC_I_SKILL_ID_SHIVER_TOUCH
Func CanUse_ShiverTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShiverTouch($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return 0
EndFunc

; Skill ID: 568 - $GC_I_SKILL_ID_VANISH
Func CanUse_Vanish()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Vanish($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 571 - $GC_I_SKILL_ID_DISRUPTING_DAGGER
Func CanUse_DisruptingDagger()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingDagger($a_f_AggroRange)
	; Description
	; Spell. Send out a Disrupting Dagger at target foe that strikes for 10...30...35 earth damage. If that foe was activating a skill, that skill is interrupted. This spell has half the normal range.
	; Concise description
	; Half Range Spell. Projectile: deals 10...30...35 earth damage. Interrupts a skill.
	Return 0
EndFunc

; Skill ID: 576 - $GC_I_SKILL_ID_STATUES_BLESSING
Func CanUse_StatuesBlessing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_StatuesBlessing($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 579 - $GC_I_SKILL_ID_DOMAIN_OF_SKILL_DAMAGE
Func CanUse_DomainOfSkillDamage()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DomainOfSkillDamage($a_f_AggroRange)
	; Description
	; Prophecies
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Domain_of_Skill_Damage","wgRelevantArticleId":120538,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 580 - $GC_I_SKILL_ID_DOMAIN_OF_ENERGY_DRAINING
Func CanUse_DomainOfEnergyDraining()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DomainOfEnergyDraining($a_f_AggroRange)
	; Description
	; Spell. While you are in this area you suffer from Energy degeneration.
	; Concise description
	; Spell. While you are in this area you suffer from Energy degeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 581 - $GC_I_SKILL_ID_DOMAIN_OF_ELEMENTS
Func CanUse_DomainOfElements()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DomainOfElements($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Domain_of_Elements","wgRelevantArticleId":120540,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 582 - $GC_I_SKILL_ID_DOMAIN_OF_HEALTH_DRAINING
Func CanUse_DomainOfHealthDraining()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DomainOfHealthDraining($a_f_AggroRange)
	; Description
	; Spell. While you are in this area you suffer from Health degeneration.
	; Concise description
	; Spell. While you are in this area you suffer from Health degeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 583 - $GC_I_SKILL_ID_DOMAIN_OF_SLOW
Func CanUse_DomainOfSlow()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DomainOfSlow($a_f_AggroRange)
	; Description
	; Spell. While you are in this area your movement is slowed.
	; Concise description
	; Spell. While you are in this area your movement is slowed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 585 - $GC_I_SKILL_ID_SWAMP_WATER
Func CanUse_SwampWater()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SwampWater($a_f_AggroRange)
	; Description
	; Prophecies
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 586 - $GC_I_SKILL_ID_JANTHIRS_GAZE
Func CanUse_JanthirsGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_JanthirsGaze($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 587 - $GC_I_SKILL_ID_FAKE_SPELL
Func CanUse_FakeSpell()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FakeSpell($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 589 - $GC_I_SKILL_ID_STORMCALLER_SKILL
Func CanUse_StormcallerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_StormcallerSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 591 - $GC_I_SKILL_ID_QUEST_SKILL
Func CanUse_QuestSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_QuestSkill($a_f_AggroRange)
	; Description
	; Skill
	; Concise description
	; 20251201190841 Cache expiry: 86400 Reduced expiry: false Complications: [] CPU time usage: 0.012 seconds Real time usage: 0.019 seconds Preprocessor visited node count: 270/1000000 Post‐expand include size: 1220/2097152 bytes Template argument size: 218/2097152 bytes Highest expansion depth: 7/100 Expensive parser function count: 0/100 Unstrip recursion depth: 0/20 Unstrip post‐expand size: 0/5000000 bytes ExtLoops count: 0/1000 -->
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 592 - $GC_I_SKILL_ID_RURIK_MUST_LIVE
Func CanUse_RurikMustLive()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RurikMustLive($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Rurik_Must_Live","wgRelevantArticleId":244783,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 766 - $GC_I_SKILL_ID_GAZE_OF_CONTEMPT
Func CanUse_GazeOfContempt()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GazeOfContempt($a_f_AggroRange)
	; Description
	; Spell. If target foe has more than 50% Health, that foe loses all enchantments.
	; Concise description
	; Spell. Removes target foe's enchantments. No effect unless this foe has more than 50% Health.
	Return 0
EndFunc

; Skill ID: 769 - $GC_I_SKILL_ID_VIPERS_DEFENSE
Func CanUse_VipersDefense()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_VipersDefense($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 770 - $GC_I_SKILL_ID_RETURN
Func CanUse_Return()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Return($a_f_AggroRange)
	; Description
	; Spell. All adjacent foes are Crippled for 3...7...8 seconds. Shadow Step to target other ally's location.
	; Concise description
	; Spell. Inflicts Crippled condition (3...7...8 seconds) on all foes adjacent to you. You Shadow Step to target ally's location. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 784 - $GC_I_SKILL_ID_ENTANGLING_ASP
Func CanUse_EntanglingAsp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EntanglingAsp($a_f_AggroRange)
	; Description
	; Spell. Entangling Asp must follow a lead attack. Target foe is knocked down and becomes Poisoned for 5...17...20 seconds.
	; Concise description
	; Spell. Causes knock-down. Inflicts Poisoned condition (5...17...20 seconds). Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 791 - $GC_I_SKILL_ID_FLESH_OF_MY_FLESH
Func CanUse_FleshOfMyFlesh()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_FleshOfMyFlesh($a_f_AggroRange)
	; Description
	; Spell. Lose half your Health. Resurrect target party member with your current Health and 5...17...20% Energy.
	; Concise description
	; Spell. Resurrect target party member (half your current Health and 5...17...20% Energy). Lose half your Health.
	Return 0
EndFunc

; Skill ID: 796 - $GC_I_SKILL_ID_SORROWS_FLAME
Func CanUse_SorrowsFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SorrowsFlame($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 797 - $GC_I_SKILL_ID_SORROWS_FIST
Func CanUse_SorrowsFist()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SorrowsFist($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 798 - $GC_I_SKILL_ID_BLAST_FURNACE
Func CanUse_BlastFurnace()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BlastFurnace($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 799 - $GC_I_SKILL_ID_BEGUILING_HAZE
Func CanUse_BeguilingHaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BeguilingHaze($a_f_AggroRange)
	; Description
	; Elite Spell. Shadow Step to target foe. That foe becomes Dazed for 3...8...9 seconds.
	; Concise description
	; Elite Spell. You Shadow Step to this foe. Inflicts Dazed condition (3...8...9 seconds).
	Return 0
EndFunc

; Skill ID: 805 - $GC_I_SKILL_ID_ANIMATE_VAMPIRIC_HORROR
Func CanUse_AnimateVampiricHorror()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateVampiricHorror($a_f_AggroRange)
	; Description
	; Spell. Exploit nearest corpse to animate a level 1...14...17 Vampiric Horror. Whenever a Vampiric Horror you control deals damage, you gain the same amount of Health.
	; Concise description
	; Spell. Creates a level 1...14...17 vampiric horror. You gain Health equal to the damage it deals. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 817 - $GC_I_SKILL_ID_DISCORD
Func CanUse_Discord()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Discord($a_f_AggroRange)
	; Description
	; Elite Spell. If target foe is suffering from a condition and under the effects of a hex or an enchantment, that foe suffers 30...94...110 damage.
	; Concise description
	; Elite Spell. Deals 30...94...110 damage. No effect unless target foe has a condition and is either hexed or enchanted.
	Return 0
EndFunc

; Skill ID: 824 - $GC_I_SKILL_ID_LAVA_ARROWS
Func CanUse_LavaArrows()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LavaArrows($a_f_AggroRange)
	; Description
	; Spell. Lava Arrows fly toward up to 3 foes near your target and strike for 20...56...65 fire damage if they hit.
	; Concise description
	; Spell. Projectile: deals 20...56...65 fire damage. Bonus effect: sends projectiles at 2 other foes near your target.
	Return 0
EndFunc

; Skill ID: 825 - $GC_I_SKILL_ID_BED_OF_COALS
Func CanUse_BedOfCoals()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BedOfCoals($a_f_AggroRange)
	; Description
	; Spell. Create a Bed of Coals at target foe's location. For 5 seconds, foes adjacent to target foe are struck for 5...24...29 fire damage each second. Any foe knocked down on the Bed of Coals is set on fire for 3...6...7 seconds.
	; Concise description
	; Spell. Deals 5...24...29 fire damage each second (5 seconds) to location of target foe. Hits foes adjacent to your target. Inflicts Burning condition (3...6...7 seconds) on knocked down foes.
	Return 0
EndFunc

; Skill ID: 830 - $GC_I_SKILL_ID_RAY_OF_JUDGMENT
Func CanUse_RayOfJudgment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RayOfJudgment($a_f_AggroRange)
	; Description
	; Elite Spell. Invoke a Ray of Judgment at target foe's location. For 5 seconds, target foe and all foes adjacent to this location take 5...37...45 holy damage each second and begin Burning for 1...3...3 second[s].
	; Concise description
	; Elite Spell. Deals 5...37...45 holy damage and inflicts Burning (1...3...3 second[s]) every second (5 seconds). Hits foes adjacent to target's initial location.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 832 - $GC_I_SKILL_ID_ANIMATE_FLESH_GOLEM
Func CanUse_AnimateFleshGolem()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateFleshGolem($a_f_AggroRange)
	; Description
	; Elite Spell. Exploit nearest corpse to animate a level 3...21...25 Flesh Golem. The Flesh Golem leaves an exploitable corpse. You can have only one Flesh Golem at a time.
	; Concise description
	; Elite Spell. Creates a level 3...21...25 flesh golem which leaves a fresh corpse when it dies. Exploits a fresh corpse. You can have only one flesh golem at a time.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 836 - $GC_I_SKILL_ID_RIDE_THE_LIGHTNING
Func CanUse_RideTheLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RideTheLightning($a_f_AggroRange)
	; Description
	; Elite Spell. You Ride the Lightning to target. All adjacent foes are Blinded for 1...4...5 second[s]. If your target is a foe, it is struck for 10...58...70 lightning damage. This spell has 25% armor penetration.
	; Concise description
	; Elite Spell. Deals 10...58...70 lightning damage. 25% armor penetration. Blinds all adjacent foes (1...4...5 second[s]). You instantly move to your target. May target allies.
	Return 0
EndFunc

; Skill ID: 840 - $GC_I_SKILL_ID_POISONED_HEART
Func CanUse_PoisonedHeart()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonedHeart($a_f_AggroRange)
	; Description
	; Spell. You and all adjacent foes are Poisoned for 5...13...15 seconds.
	; Concise description
	; Spell. Inflicts Poisoned condition (5...13...15 seconds) to adjacent foes. You are also Poisoned.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 841 - $GC_I_SKILL_ID_FETID_GROUND
Func CanUse_FetidGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FetidGround($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 15...55...65 cold damage. If that foe is knocked down, that foe becomes Poisoned for 5...17...20 seconds.
	; Concise description
	; Spell. Deals 15...55...65 cold damage. Inflicts Poisoned condition (5...17...20 seconds) if target foe is knocked-down.
	Return 0
EndFunc

; Skill ID: 842 - $GC_I_SKILL_ID_ARC_LIGHTNING
Func CanUse_ArcLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ArcLightning($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 5...33...40 lightning damage. If you are Overcast, two foes near your target are struck for 15...71...85 lightning damage. Damage from Arc Lightning has 25% armor penetration.
	; Concise description
	; Spell. Deals 5...33...40 lightning damage. Deals 15...71...85 lightning damage to two nearby foes if you are Overcast. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 844 - $GC_I_SKILL_ID_CHURNING_EARTH
Func CanUse_ChurningEarth()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ChurningEarth($a_f_AggroRange)
	; Description
	; Spell. Create Churning Earth at target foe's location. For the next 5 seconds, Churning Earth strikes foes near that location for 10...34...40 earth damage each second. Any foe moving faster than normal when struck by Churning Earth is knocked down.
	; Concise description
	; Spell. Deals 10...34...40 earth damage each second (5 seconds). Hits foes near target's initial location. Causes knock-down to foes moving faster than normal.
	Return 0
EndFunc

; Skill ID: 845 - $GC_I_SKILL_ID_LIQUID_FLAME
Func CanUse_LiquidFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LiquidFlame($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 7...91...112 fire damage. If that foe is attacking or casting a spell, nearby foes are also struck for 7...91...112 fire damage.
	; Concise description
	; Spell. Deals 7...91...112 fire damage. Deals 7...91...112 fire damage to nearby foes if target was attacking or casting.
	Return 0
EndFunc

; Skill ID: 846 - $GC_I_SKILL_ID_STEAM1
Func CanUse_Steam1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Steam1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 855 - $GC_I_SKILL_ID_CHOMPER
Func CanUse_Chomper()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Chomper($a_f_AggroRange)
	; Description
	; Spell. Chomper
	; Concise description
	; Spell. Chomper
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 858 - $GC_I_SKILL_ID_DANCING_DAGGERS
Func CanUse_DancingDaggers()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DancingDaggers($a_f_AggroRange)
	; Description
	; Spell. Send out three Dancing Daggers at target foe, each striking for 5...29...35 earth damage if they hit. Dancing Daggers has half the normal range. This skill counts as a lead attack.
	; Concise description
	; Half Range Spell. Three projectiles: each deals 5...29...35 earth damage. Counts as a lead attack.
	Return 0
EndFunc

; Skill ID: 862 - $GC_I_SKILL_ID_RAVENOUS_GAZE
Func CanUse_RavenousGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RavenousGaze($a_f_AggroRange)
	; Description
	; Elite Spell. Deal 15...27...30 damage and steal 15...27...30 Health from target foe and all nearby foes.
	; Concise description
	; Elite Spell. Deals 15...27...30 damage and steals 15...27...30 Health from target and nearby foes.
	Return 0
EndFunc

; Skill ID: 864 - $GC_I_SKILL_ID_OPPRESSIVE_GAZE
Func CanUse_OppressiveGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OppressiveGaze($a_f_AggroRange)
	; Description
	; Spell. Target foe and adjacent foes take 10...26...30 shadow damage. Foes already suffering from a condition are Poisoned and Weakened for 3...10...12 seconds.
	; Concise description
	; Spell. Deals 10...26...30 damage to target and adjacent foes. Inflicts Poison and Weakness (3...10...12 second) on foes suffering from a condition.
	Return 0
EndFunc

; Skill ID: 865 - $GC_I_SKILL_ID_LIGHTNING_HAMMER
Func CanUse_LightningHammer()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningHammer($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 10...82...100 lightning damage and applies Cracked Armor for 5...17...20 seconds. Lightning Hammer has 25% armor penetration.
	; Concise description
	; Spell. Deals 10...82...100 lightning damage. Applies Cracked Armor (5...17...20 seconds). 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 866 - $GC_I_SKILL_ID_VAPOR_BLADE
Func CanUse_VaporBlade()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_VaporBlade($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 15...111...135 cold damage. Vapor Blade deals half damage if that foe has any enchantments on them.
	; Concise description
	; Spell. Deals 15...111...135 cold damage. Half damage if target foe is enchanted.
	Return 0
EndFunc

; Skill ID: 867 - $GC_I_SKILL_ID_HEALING_LIGHT
Func CanUse_HealingLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealingLight($a_f_AggroRange)
	; Description
	; Elite Spell. Heal target ally for 40...88...100 Health. If your target has an enchantment, you gain 1...3...3 Energy.
	; Concise description
	; Elite Spell. Heals for 40...88...100. You gain 1...3...3 Energy if target ally is enchanted.
	Return 0
EndFunc

; Skill ID: 877 - $GC_I_SKILL_ID_LYSSAS_BALANCE
Func CanUse_LyssasBalance()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LyssasBalance($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 884 - $GC_I_SKILL_ID_SEARING_FLAMES1
Func CanUse_SearingFlames1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SearingFlames1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 897 - $GC_I_SKILL_ID_OATH_OF_HEALING
Func CanUse_OathOfHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OathOfHealing($a_f_AggroRange)
	; Description
	; Spell. (monster only) Heal your Guild Lord for 200 Health.
	; Concise description
	; Spell. (monster only) Heal Guild Lord for 200.
	Return 0
EndFunc

; Skill ID: 902 - $GC_I_SKILL_ID_BLOOD_OF_THE_AGGRESSOR
Func CanUse_BloodOfTheAggressor()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BloodOfTheAggressor($a_f_AggroRange)
	; Description
	; Spell. Steal up to 5...37...45 Health from target foe. If that foe was attacking, that foe suffers Weakness for 3...10...12 seconds.
	; Concise description
	; Spell. Steal 5...37...45 Health. Inflicts Weakness (3...10...12 seconds) if target foe was attacking.
	Return 0
EndFunc

; Skill ID: 903 - $GC_I_SKILL_ID_ICY_PRISM
Func CanUse_IcyPrism()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_IcyPrism($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 15...63...75 cold damage. If that foe has a Water Magic hex, Icy Prism deals +15...63...75 cold damage to all other nearby foes.
	; Concise description
	; Spell. Deals 15...63...75 cold damage. Deals +[sic]15...63...75 cold damage to other nearby foes if target has a Water Magic hex.
	Return 0
EndFunc

; Skill ID: 910 - $GC_I_SKILL_ID_SPIRIT_RIFT
Func CanUse_SpiritRift()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritRift($a_f_AggroRange)
	; Description
	; This article is about the Factions skill. For the temporarily available Bonus Mission Pack skill, see Spirit Rift (Togo).
	; Concise description
	; green; font-weight: bold;">25...105...125
	Return 0
EndFunc

; Skill ID: 914 - $GC_I_SKILL_ID_CONSUME_SOUL
Func CanUse_ConsumeSoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ConsumeSoul($a_f_AggroRange)
	; Description
	; Elite Spell. You steal 5...49...60 Health from target foe. All hostile summoned creatures in the area of that foe take 25...105...125 damage.
	; Concise description
	; Elite Spell. Steals 5...49...60 Health. Deal 25...105...125 damage to hostile summoned creatures in the area of target foe.
	Return 0
EndFunc

; Skill ID: 915 - $GC_I_SKILL_ID_SPIRIT_LIGHT
Func CanUse_SpiritLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritLight($a_f_AggroRange)
	; Description
	; Spell. Target ally is healed for 60...156...180. If any spirits are within earshot, you don't sacrifice Health.
	; Concise description
	; Spell. Heals for 60...156...180. You don't sacrifice Health if you are within earshot of any spirits.
	Return 0
EndFunc

; Skill ID: 917 - $GC_I_SKILL_ID_RUPTURE_SOUL
Func CanUse_RuptureSoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RuptureSoul($a_f_AggroRange)
	; Description
	; Spell. Target allied spirit is destroyed. All nearby enemies are struck for 50...122...140 lightning damage and become blinded for 3...10...12 seconds.
	; Concise description
	; Spell. Destroys target allied spirit. Deals 50...122...140 lightning damage and inflicts Blindness condition (3...10...12 seconds) to nearby foes.
	Return 0
EndFunc

; Skill ID: 918 - $GC_I_SKILL_ID_SPIRIT_TO_FLESH
Func CanUse_SpiritToFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritToFlesh($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 919 - $GC_I_SKILL_ID_SPIRIT_BURN
Func CanUse_SpiritBurn()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritBurn($a_f_AggroRange)
	; Description
	; This article is about the Factions skill. For the temporarily available Bonus Mission Pack skill, see Spirit Burn (Togo).
	; Concise description
	; green; font-weight: bold;">5...41...50
	Return 0
EndFunc

; Skill ID: 931 - $GC_I_SKILL_ID_POWER_RETURN
Func CanUse_PowerReturn()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PowerReturn($a_f_AggroRange)
	; Description
	; Spell. If target foe is casting a spell or chant, that skill is interrupted and target foe gains 10...6...5 Energy.
	; Concise description
	; Spell. Interrupts a spell or chant. Interruption effect: target foe gains 10...6...5 Energy.
	Return 0
EndFunc

; Skill ID: 932 - $GC_I_SKILL_ID_COMPLICATE
Func CanUse_Complicate()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Complicate($a_f_AggroRange)
	; Description
	; Spell. If target foe is using a skill, that skill is interrupted and disabled for target foe and all foes in the area for an additional 5...11...12 seconds.
	; Concise description
	; Spell. Interrupt a skill. Interruption effect: disables interrupted skill (+5...11...12 seconds) for target foe and all foes in the area.
	Return 0
EndFunc

; Skill ID: 933 - $GC_I_SKILL_ID_SHATTER_STORM
Func CanUse_ShatterStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShatterStorm($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe loses all enchantments. For each enchantment removed this way, Shatter Storm is disabled for an additional 7 seconds.
	; Concise description
	; Elite Spell. Removes all enchantments. Removal cost: Shatter Storm is disabled for +7 seconds for each enchantment removed.
	Return 0
EndFunc

; Skill ID: 936 - $GC_I_SKILL_ID_ENVENOM_ENCHANTMENTS
Func CanUse_EnvenomEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnvenomEnchantments($a_f_AggroRange)
	; Description
	; Spell. Target foe loses one enchantment. For every remaining enchantment, target foe is poisoned for 3...9...10 seconds.
	; Concise description
	; Spell. Removes one enchantment from target foe. Inflicts Poisoned condition (3...9...10 seconds for each remaining enchantment on that foe).
	Return 0
EndFunc

; Skill ID: 937 - $GC_I_SKILL_ID_SHOCKWAVE
Func CanUse_Shockwave()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Shockwave($a_f_AggroRange)
	; Description
	; Elite Spell. All foes in the area take 15...51...60 earth damage and are Weakened for 1...8...10 second[s]. Nearby foes also take +15...51...60 earth damage and have Cracked Armor for 1...8...10 second[s]. Adjacent foes suffer the previous effects, take +15...51...60 earth damage, and are Blinded for 1...8...10 second[s].
	; Concise description
	; Elite Spell. Foes in the area take 15...51...60 earth damage and are Weakened (1...8...10 second[s]). Nearby foes also take +15...51...60 earth damage and have Cracked Armor (1...8...10 second[s]). Adjacent foes also take +15...51...60 earth damage and are Blinded (1...8...10 second[s]).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 940 - $GC_I_SKILL_ID_CRY_OF_LAMENT
Func CanUse_CryOfLament()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CryOfLament($a_f_AggroRange)
	; Description
	; Monk
	; Concise description
	; green; font-weight: bold;">10...34...40
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 941 - $GC_I_SKILL_ID_BLESSED_LIGHT
Func CanUse_BlessedLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BlessedLight($a_f_AggroRange)
	; Description
	; Elite Spell. Heal target ally for 10...114...140 Health and remove one condition and one hex.
	; Concise description
	; Elite Spell. Heals for 10...114...140. Removes one condition and one hex.
	Return 0
EndFunc

; Skill ID: 942 - $GC_I_SKILL_ID_WITHDRAW_HEXES
Func CanUse_WithdrawHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WithdrawHexes($a_f_AggroRange)
	; Description
	; Elite Spell. Remove all hexes from target ally and all adjacent allies. This spell takes an additional 20...8...5 seconds to recharge for each hex removed in this way.
	; Concise description
	; Elite Spell. Removes all hexes. Also affects adjacent allies. Removal cost: +20...8...5 seconds recharge for each hex removed.
	Return 0
EndFunc

; Skill ID: 943 - $GC_I_SKILL_ID_EXTINGUISH
Func CanUse_Extinguish()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Extinguish($a_f_AggroRange)
	; Description
	; Spell. Remove one condition from each party member. Party members relieved of Burning are healed for 10...82...100 Health.
	; Concise description
	; Spell. Affects all party members. Removes one condition. Party members relieved of Burning are healed for 10...82...100.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 952 - $GC_I_SKILL_ID_DEATHS_CHARGE
Func CanUse_DeathsCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DeathsCharge($a_f_AggroRange)
	; Description
	; Spell. Shadow Step to target foe. If that foe has more Health than you, you are healed for 65...173...200.
	; Concise description
	; Spell. You Shadow Step to target foe. You are healed for 65...173...200 if this foe has more Health than you.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_AgentHasMoreHpThanMe")
EndFunc

; Skill ID: 954 - $GC_I_SKILL_ID_EXPEL_HEXES
Func CanUse_ExpelHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ExpelHexes($a_f_AggroRange)
	; Description
	; Elite Spell. Remove up to 2 Hexes from target ally.
	; Concise description
	; Elite Spell. Removes 2 hexes from target ally.
	Return 0
EndFunc

; Skill ID: 955 - $GC_I_SKILL_ID_RIP_ENCHANTMENT
Func CanUse_RipEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RipEnchantment($a_f_AggroRange)
	; Description
	; Spell. Remove 1 enchantment from target foe. If an enchantment was removed, that foe suffers from Bleeding for 5...21...25 seconds.
	; Concise description
	; Spell. Removes 1 enchantment. Removal effect: inflicts Bleeding (5...21...25 seconds).
	Return 0
EndFunc

; Skill ID: 958 - $GC_I_SKILL_ID_HEALING_WHISPER
Func CanUse_HealingWhisper()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealingWhisper($a_f_AggroRange)
	; Description
	; Spell. Target other ally is healed for 40...88...100. This spell has half the normal range.
	; Concise description
	; Half Range Spell. Heals for 40...88...100. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 959 - $GC_I_SKILL_ID_ETHEREAL_LIGHT
Func CanUse_EtherealLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EtherealLight($a_f_AggroRange)
	; Description
	; Spell. Target ally is healed for 25...85...100. This spell is easily interrupted.
	; Concise description
	; Spell. Heals for 25...85...100. Easily interrupted.
	Return 0
EndFunc

; Skill ID: 960 - $GC_I_SKILL_ID_RELEASE_ENCHANTMENTS
Func CanUse_ReleaseEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ReleaseEnchantments($a_f_AggroRange)
	; Description
	; Spell. Lose all enchantments. Each party member is healed for 5...29...35 Health for each Monk enchantment lost.
	; Concise description
	; Spell. Removes all of your enchantments. Heals all party members for 5...29...35 for each Monk Enchantment removed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 962 - $GC_I_SKILL_ID_SPIRIT_TRANSFER
Func CanUse_SpiritTransfer()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritTransfer($a_f_AggroRange)
	; Description
	; Spell. The spirit nearest you loses 5...41...50 Health. Target ally is healed for 5 for each point of Health lost.
	; Concise description
	; Spell. The spirit nearest you loses 5...41...50 Health. Heals target ally for 5 for each point of Health lost.
	Return 0
EndFunc

; Skill ID: 965 - $GC_I_SKILL_ID_ARCHEMORUS_STRIKE
Func CanUse_ArchemorusStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ArchemorusStrike($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 966 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_1
Func CanUse_SpearOfArchemorusLevel1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 967 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_2
Func CanUse_SpearOfArchemorusLevel2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 968 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_3
Func CanUse_SpearOfArchemorusLevel3()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 969 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_4
Func CanUse_SpearOfArchemorusLevel4()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 970 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_5
Func CanUse_SpearOfArchemorusLevel5()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel5($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 971 - $GC_I_SKILL_ID_ARGOS_CRY
Func CanUse_ArgosCry()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ArgosCry($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 972 - $GC_I_SKILL_ID_JADE_FURY
Func CanUse_JadeFury()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_JadeFury($a_f_AggroRange)
	; Description
	; Spell. All foes in the area take 50 damage, are knocked down, and then take an additional 150 damage.
	; Concise description
	; Spell. Deals 50 damage, causes knock-down, and then deals an additional 150 damage. Affects foes in the area.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 973 - $GC_I_SKILL_ID_BLINDING_POWDER
Func CanUse_BlindingPowder()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BlindingPowder($a_f_AggroRange)
	; Description
	; Spell. Must follow an off-hand attack. Target foe and all adjacent foes become Blinded for 3...13...15 seconds.
	; Concise description
	; Spell. Inflicts Blindness condition (3...13...15 seconds) on target and adjacent foes. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 974 - $GC_I_SKILL_ID_MANTIS_TOUCH
Func CanUse_MantisTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MantisTouch($a_f_AggroRange)
	; Description
	; Spell. Must follow a lead attack. Target foe becomes Crippled for 5...17...20 seconds. This skill counts as an off-hand attack.
	; Concise description
	; Spell. Inflicts Crippled condition (5...17...20 seconds). This skill counts as an off-hand attack. Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 980 - $GC_I_SKILL_ID_FEAST_OF_SOULS
Func CanUse_FeastOfSouls()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FeastOfSouls($a_f_AggroRange)
	; Description
	; Spell. Destroy all nearby allies' spirits. For each spirit destroyed in this way, all party members are healed for 50...90...100 Health.
	; Concise description
	; Spell. Heals all party members for 50...90...100 for each nearby allied spirit. All nearby allied spirits are destroyed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 985 - $GC_I_SKILL_ID_CALTROPS
Func CanUse_Caltrops()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Caltrops($a_f_AggroRange)
	; Description
	; Spell. Target foe and all foes adjacent to your target are Crippled for 5...13...15 seconds. Caltrops has half the normal range.
	; Concise description
	; Half Range Spell. Inflicts Crippled condition (5...13...15 seconds) on target and adjacent foes.
	Return 0
EndFunc

; Skill ID: 991 - $GC_I_SKILL_ID_DENY_HEXES
Func CanUse_DenyHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DenyHexes($a_f_AggroRange)
	; Description
	; Spell. Remove one hex from target ally and one additional hex for each recharging Divine Favor skill you have.
	; Concise description
	; Spell. Removes one hex from target ally and one additional hex for each recharging Divine Favor skill you have.
	Return 0
EndFunc

; Skill ID: 1000 - $GC_I_SKILL_ID_BLINDING_SNOW
Func CanUse_BlindingSnow()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BlindingSnow($a_f_AggroRange)
	; Description
	; Spell. You interrupt target foe's action. That foe is Blinded for 10 seconds.
	; Concise description
	; Spell. Interrupts an action. Also inflicts Blindness (10 seconds.)
	Return 0
EndFunc

; Skill ID: 1001 - $GC_I_SKILL_ID_AVALANCHE_SKILL
Func CanUse_AvalancheSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AvalancheSkill($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1002 - $GC_I_SKILL_ID_SNOWBALL
Func CanUse_Snowball()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Snowball($a_f_AggroRange)
	; Description
	; This article is about the skill used by player characters. For the skill used by Kimberly, see Snowball (NPC).
	; Concise description
	; deals 50 damage. You gain 1 strike of adrenaline.
	Return 0
EndFunc

; Skill ID: 1003 - $GC_I_SKILL_ID_MEGA_SNOWBALL
Func CanUse_MegaSnowball()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MegaSnowball($a_f_AggroRange)
	; Description
	; Spell. You throw a very slow-moving snowball at target foe. That foe is knocked down and takes 75 damage if it hits.
	; Concise description
	; Spell. Very slow projectile: deals 75 damage and causes knock-down.
	Return 0
EndFunc

; Skill ID: 1011 - $GC_I_SKILL_ID_HOLIDAY_BLUES
Func CanUse_HolidayBlues()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HolidayBlues($a_f_AggroRange)
	; Description
	; Spell. Sacrifice 50% maximum Health. All nearby foes take 50 damage, and you bring the Holiday Blues to this location. For 30 seconds, foes within the area suffer -15 Health degeneration.
	; Concise description
	; Spell. Deals 50 damage to nearby foes. Foes within the area have -15 Health degeneration (30 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1015 - $GC_I_SKILL_ID_FLURRY_OF_ICE
Func CanUse_FlurryOfIce()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FlurryOfIce($a_f_AggroRange)
	; Description
	; Spell. Throw a snowball at up to 4 foes adjacent to your target. These snowballs deal 50 damage if they hit.
	; Concise description
	; Spell. Throw a snowball at up to 4 foes adjacent to your target. These snowballs deal 50 damage if they hit.
	Return 0
EndFunc

; Skill ID: 1016 - $GC_I_SKILL_ID_SNOWBALL_NPC
Func CanUse_SnowballNpc()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SnowballNpc($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1032 - $GC_I_SKILL_ID_HEART_OF_SHADOW
Func CanUse_HeartOfShadow()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HeartOfShadow($a_f_AggroRange)
	; Description
	; Spell. You are healed for 30...126...150. Shadow Step to a nearby location directly away from your target.
	; Concise description
	; Spell. You are healed for 30...126...150 and you Shadow Step to a nearby location directly away from your target.
	Return 0
EndFunc

; Skill ID: 1038 - $GC_I_SKILL_ID_CRIPPLING_DAGGER
Func CanUse_CripplingDagger()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingDagger($a_f_AggroRange)
	; Description
	; Spell. Send out a Crippling Dagger at target foe. Crippling Dagger strikes for 15...51...60 earth damage if it hits, and Cripples moving foes for 3...13...15 seconds. This spell has half the normal range.
	; Concise description
	; Half Range Spell. Projectile: deals 15...51...60 earth damage. Inflicts Crippled condition (3...13...15 seconds) if target foe is moving.
	Return 0
EndFunc

; Skill ID: 1040 - $GC_I_SKILL_ID_SPIRIT_WALK
Func CanUse_SpiritWalk()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritWalk($a_f_AggroRange)
	; Description
	; Spell. Shadow Step to target spirit.
	; Concise description
	; Spell. Shadow Step to target Spirit. [sic]
	Return 0
EndFunc

; Skill ID: 1048 - $GC_I_SKILL_ID_REVEALED_ENCHANTMENT
Func CanUse_RevealedEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RevealedEnchantment($a_f_AggroRange)
	; Description
	; Spell. Remove an enchantment from target foe and gain 3...13...15 Energy. For 20 seconds, Revealed Enchantment is replaced with the enchantment removed from target foe.
	; Concise description
	; Spell. Removes an enchantment from target foe. Removal effects: you gain 3...13...15 Energy; this spell is replaced with that enchantment (20 seconds).
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc

; Skill ID: 1049 - $GC_I_SKILL_ID_REVEALED_HEX
Func CanUse_RevealedHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RevealedHex($a_f_AggroRange)
	; Description
	; Spell. Remove a hex from target ally and gain 4...9...10 Energy. For 20 seconds, Revealed Hex is replaced with the hex that was removed.
	; Concise description
	; Spell. Removes a hex from target ally. Removal effects: you gain 4...9...10 Energy; this spell is replaced with that hex (20 seconds).
	Return 0
EndFunc

; Skill ID: 1052 - $GC_I_SKILL_ID_ACCUMULATED_PAIN
Func CanUse_AccumulatedPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AccumulatedPain($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 15...63...75 damage. If target foe is suffering from 2 or more hexes, that foe suffers a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Spell. Deals 15...63...75 damage. Inflicts Deep Wound condition (5...17...20 seconds) if target foe has 2 or more hexes.
	Return 0
EndFunc

; Skill ID: 1053 - $GC_I_SKILL_ID_PSYCHIC_DISTRACTION
Func CanUse_PsychicDistraction()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PsychicDistraction($a_f_AggroRange)
	; Description
	; Elite Spell. All of your other skills are disabled for 8 seconds. If target foe is using a skill, that skill is interrupted and disabled for an additional 5...11...12 seconds.
	; Concise description
	; Elite Spell. Interrupts a skill. Interruption effect: disables interrupted skill (+5...11...12 seconds). Your other skills are disabled (8 seconds).
	Return 0
EndFunc

; Skill ID: 1057 - $GC_I_SKILL_ID_PSYCHIC_INSTABILITY
Func CanUse_PsychicInstability()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PsychicInstability($a_f_AggroRange)
	; Description
	; Elite Spell. Interrupt the target foe's action. If that action was a skill, that foe and nearby foes are knocked down for 2...4...4 seconds. (50% failure chance with Fast Casting 4 or less.)
	; Concise description
	; Elite Spell. Interrupts an action. Interruption effect: if the action is a skill, cause knockdown for 2...4...4 seconds on target foe and all nearby foes. 50% failure chance unless Fast Casting 5 or higher.
	Return 0
EndFunc

; Skill ID: 1060 - $GC_I_SKILL_ID_CELESTIAL_HASTE
Func CanUse_CelestialHaste()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CelestialHaste($a_f_AggroRange)
	; Description
	; Spell. For 15 seconds, your entire party has 50% faster casting and all skills recharge 25% faster.
	; Concise description
	; Spell. (15 seconds.) Affects all party members. 50% faster casting. 25% faster skill recharge.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1061 - $GC_I_SKILL_ID_FEEDBACK
Func CanUse_Feedback()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Feedback($a_f_AggroRange)
	; Description
	; This article is about the skill. For the Feedback namespace main page, see Feedback:Main.
	; Concise description
	; target foe loses
	Return 0
EndFunc

; Skill ID: 1062 - $GC_I_SKILL_ID_ARCANE_LARCENY
Func CanUse_ArcaneLarceny()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ArcaneLarceny($a_f_AggroRange)
	; Description
	; Spell. For 5...29...35 seconds, one random spell is disabled for target foe and Arcane Larceny is replaced by that spell.
	; Concise description
	; Spell. (5...29...35 seconds.) Disables one random spell. This skill becomes that spell.
	Return 0
EndFunc

; Skill ID: 1067 - $GC_I_SKILL_ID_LIFEBANE_STRIKE
Func CanUse_LifebaneStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LifebaneStrike($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 12...41...48 shadow damage. If that foe's Health is above 50%, you steal up to 12...41...48 Health.
	; Concise description
	; Spell. Deals 12...41...48 damage. Steals 12...41...48 Health if target foe's Health is above 50%.
	Return 0
EndFunc

; Skill ID: 1068 - $GC_I_SKILL_ID_BITTER_CHILL
Func CanUse_BitterChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BitterChill($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 15...51...60 cold damage. If that foe had more Health than you, Bitter Chill recharges instantly.
	; Concise description
	; Spell. Deals 15...51...60 cold damage. Recharges instantly if target foe had more Health than you.
	Return 0
EndFunc

; Skill ID: 1069 - $GC_I_SKILL_ID_TASTE_OF_PAIN
Func CanUse_TasteOfPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TasteOfPain($a_f_AggroRange)
	; Description
	; Spell. If target foe is below 50% Health, you gain 30...126...150 Health.
	; Concise description
	; Spell. Heals you for 30...126...150. No effect unless target foe is below 50% Health.
	Return 0
EndFunc

; Skill ID: 1070 - $GC_I_SKILL_ID_DEFILE_ENCHANTMENTS
Func CanUse_DefileEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DefileEnchantments($a_f_AggroRange)
	; Description
	; Spell. Target foe and all nearby foes take 6...49...60 shadow damage and 4...17...20 shadow damage for each enchantment on them.
	; Concise description
	; Spell. Deals 6...49...60 damage to target and nearby foes. Deals 4...17...20 more damage for each enchantment on them.
	Return 0
EndFunc

; Skill ID: 1075 - $GC_I_SKILL_ID_VAMPIRIC_SWARM
Func CanUse_VampiricSwarm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_VampiricSwarm($a_f_AggroRange)
	; Description
	; Spell. Vampiric Swarm steals up to 15...51...60 Health from up to three foes in the area.
	; Concise description
	; Spell. Steals 15...51...60 Health. Hits 2 additional foes in the area.
	Return 0
EndFunc

; Skill ID: 1076 - $GC_I_SKILL_ID_BLOOD_DRINKER
Func CanUse_BloodDrinker()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BloodDrinker($a_f_AggroRange)
	; Description
	; This article is about the skill. For the creature, see Blood Drinker (NPC).
	; Concise description
	; green; font-weight: bold;">20...56...65
	Return 0
EndFunc

; Skill ID: 1081 - $GC_I_SKILL_ID_TEINAIS_WIND
Func CanUse_TeinaisWind()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TeinaisWind($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1082 - $GC_I_SKILL_ID_SHOCK_ARROW
Func CanUse_ShockArrow()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShockArrow($a_f_AggroRange)
	; Description
	; Spell. Send out a shocking arrow that flies swiftly toward target foe, striking for 5...41...50 lightning damage. If Shock Arrow strikes a foe suffering from Cracked Armor, you gain 5 Energy plus 1 Energy for every 2 ranks of Energy Storage. Shock Arrow has 25% armor penetration.
	; Concise description
	; Spell. Rapid projectile: deals 5...41...50 lightning damage. Gain 5 Energy plus 1 Energy for every 2 ranks of Energy Storage if you hit a foe suffering from Cracked Armor. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 1083 - $GC_I_SKILL_ID_UNSTEADY_GROUND
Func CanUse_UnsteadyGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UnsteadyGround($a_f_AggroRange)
	; Description
	; Elite Spell. You create Unsteady Ground at target foe's location. For 5 seconds, nearby foes take 10...34...40 earth damage each second. Attacking foes struck by Unsteady Ground are knocked down.
	; Concise description
	; Elite Spell. Deals 10...34...40 earth damage each second (5 seconds) and causes knock-down to attacking foes. Hits foes near target's initial location.
	Return 0
EndFunc

; Skill ID: 1086 - $GC_I_SKILL_ID_DRAGONS_STOMP
Func CanUse_DragonsStomp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DragonsStomp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1088 - $GC_I_SKILL_ID_SECOND_WIND
Func CanUse_SecondWind()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SecondWind($a_f_AggroRange)
	; Description
	; Elite Spell. You gain 1 Energy and 5 Health for each point of Energy restricted by Overcast. You lose all enchantments.
	; Concise description
	; Elite Spell. You gain 1 Energy and 5 Health for each point of Overcast. You lose all enchantments.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1094 - $GC_I_SKILL_ID_BREATH_OF_FIRE
Func CanUse_BreathOfFire()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BreathOfFire($a_f_AggroRange)
	; Description
	; Spell. Create Breath of Fire at target foe's current location. For 5 seconds, foes adjacent to that location are struck for 10...34...40 fire damage each second.
	; Concise description
	; Spell. Deals 10...34...40 fire damage each second (5 seconds). Hits foes adjacent to target's initial location.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1095 - $GC_I_SKILL_ID_STAR_BURST
Func CanUse_StarBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_StarBurst($a_f_AggroRange)
	; Description
	; Elite Spell. Target touched foe and all foes in the area are struck for 7...91...112 fire damage and set on fire for 1...3...4 second[s]. For each foe you hit, gain 2 Energy.
	; Concise description
	; Elite Touch Spell. Deals 7...91...112 fire damage. Inflicts Burning (1...3...4 seconds). [sic] Gain 2 Energy for each foe struck. Also hits foes in the area.
	Return 0
EndFunc

; Skill ID: 1099 - $GC_I_SKILL_ID_TEINAIS_CRYSTALS
Func CanUse_TeinaisCrystals()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TeinaisCrystals($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1106 - $GC_I_SKILL_ID_SHIELD_OF_SAINT_VIKTOR
Func CanUse_ShieldOfSaintViktor()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldOfSaintViktor($a_f_AggroRange)
	; Description
	; Spell. You are protected by the Shield of Saint Viktor. 80...1280 damage is absorbed.
	; Concise description
	; Spell. You are protected by the Shield of Saint Viktor. 80...1280 damage is absorbed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1107 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_1
Func CanUse_UrnOfSaintViktorLevel1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1108 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_2
Func CanUse_UrnOfSaintViktorLevel2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1109 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_3
Func CanUse_UrnOfSaintViktorLevel3()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1110 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_4
Func CanUse_UrnOfSaintViktorLevel4()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1111 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_5
Func CanUse_UrnOfSaintViktorLevel5()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel5($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1113 - $GC_I_SKILL_ID_KIRINS_WRATH
Func CanUse_KirinsWrath()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_KirinsWrath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1117 - $GC_I_SKILL_ID_HEAVENS_DELIGHT
Func CanUse_HeavensDelight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HeavensDelight($a_f_AggroRange)
	; Description
	; Spell. Heals you and party members within earshot for 15...51...60 points.
	; Concise description
	; Spell. Heals you and party members within earshot for 15...51...60 points.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1118 - $GC_I_SKILL_ID_HEALING_BURST
Func CanUse_HealingBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealingBurst($a_f_AggroRange)
	; Description
	; Elite Spell. Target ally is healed for 10...130...160. All party members in earshot of your target gain Health equal to the Divine Favor bonus from this spell. Your Smiting Prayers are disabled for 20 seconds.
	; Concise description
	; Elite Spell. Heals for 10...130...160. Party members in earshot of your target gain Health equal to the Divine Favor bonus. Disables your Smiting Prayers (20 seconds).
	Return 0
EndFunc

; Skill ID: 1119 - $GC_I_SKILL_ID_KAREIS_HEALING_CIRCLE
Func CanUse_KareisHealingCircle()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_KareisHealingCircle($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1120 - $GC_I_SKILL_ID_JAMEIS_GAZE
Func CanUse_JameisGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_JameisGaze($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1121 - $GC_I_SKILL_ID_GIFT_OF_HEALTH
Func CanUse_GiftOfHealth()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GiftOfHealth($a_f_AggroRange)
	; Description
	; Spell. All of your other Healing Prayers skills are disabled for 10...6...5 seconds. Target other ally is healed for 15...123...150 Health.
	; Concise description
	; Spell. Heals for 15...123...150. Disables your other Healing Prayers skills (10...6...5 seconds). Cannot self-target.
	Return 0
EndFunc

; Skill ID: 1126 - $GC_I_SKILL_ID_EMPATHIC_REMOVAL
Func CanUse_EmpathicRemoval()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EmpathicRemoval($a_f_AggroRange)
	; Description
	; Elite Spell. You and target other ally lose 1 condition and 1 hex, and are healed for 50.
	; Concise description
	; Elite Spell. Removes one condition and hex from target ally and yourself, and heals for 50. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 1128 - $GC_I_SKILL_ID_RESURRECTION_CHANT
Func CanUse_ResurrectionChant()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_ResurrectionChant($a_f_AggroRange)
	; Description
	; Spell. Resurrect target party member with up to your current Health and 5...29...35% Energy. This spell has half the normal range.
	; Concise description
	; Half Range Spell. Resurrects target party member at your current Health and with 5...29...35% Energy.
	Return 0
EndFunc

; Skill ID: 1129 - $GC_I_SKILL_ID_WORD_OF_CENSURE
Func CanUse_WordOfCensure()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WordOfCensure($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe takes 15...63...75 holy damage. If your target was below 33% Health, Word of Censure takes 20 additional seconds to recharge.
	; Concise description
	; Elite Spell. Deals 15...63...75 holy damage. +20 recharge time if target foe is below 33% Health.
	Return 0
EndFunc

; Skill ID: 1130 - $GC_I_SKILL_ID_SPEAR_OF_LIGHT
Func CanUse_SpearOfLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfLight($a_f_AggroRange)
	; Description
	; Spell. Spear of Light flies toward target foe and deals 26...50...56 holy damage if it hits. Spear of Light deals +15...51...60 damage if it hits an attacking foe.
	; Concise description
	; Spell. Projectile: deals 26...50...56 holy damage. Deals 15...51...60 more damage if target foe is attacking.
	Return 0
EndFunc

; Skill ID: 1174 - $GC_I_SKILL_ID_CATHEDRAL_COLLAPSE2
Func CanUse_CathedralCollapse2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CathedralCollapse2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1175 - $GC_I_SKILL_ID_BLOOD_OF_ZU_HELTZER
Func CanUse_BloodOfZuHeltzer()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BloodOfZuHeltzer($a_f_AggroRange)
	; Description
	; Spell. Magical barriers put in place by a zu Heltzer family member are opened.
	; Concise description
	; Spell. Magical barriers put in place by a zu Heltzer family member are opened.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1183 - $GC_I_SKILL_ID_CORRUPTED_DRAGON_SPORES
Func CanUse_CorruptedDragonSpores()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CorruptedDragonSpores($a_f_AggroRange)
	; Description
	; Spell. Create 6 "Corrupted Spore" creatures around target foe. Foes within their range take 100% longer to cast spells and suffer from -2 Health degeneration. Corrupted Spore creatures die after 30 seconds.
	; Concise description
	; Spell. (30 seconds.) Create 6 corrupted spore creatures around target foe. Foes within their range take twice as long to cast spells and have -2 Health degeneration.
	Return 0
EndFunc

; Skill ID: 1184 - $GC_I_SKILL_ID_CORRUPTED_DRAGON_SCALES
Func CanUse_CorruptedDragonScales()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CorruptedDragonScales($a_f_AggroRange)
	; Description
	; Spell. Create 6 "Corrupted Scale" creatures around target foe. Foes within their range attack 50% slower and suffer from -10 Health degeneration. Corrupted Scale creatures die after 30 seconds.
	; Concise description
	; Spell. (30 seconds.) Create 6 corrupted scale creatures around target foe. Foes within their range attack 50% slower and have -10 Health degeneration.
	Return 0
EndFunc

; Skill ID: 1189 - $GC_I_SKILL_ID_OF_ROYAL_BLOOD
Func CanUse_OfRoyalBlood()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OfRoyalBlood($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; 20251201191131 Cache expiry: 86400 Reduced expiry: false Complications: [] CPU time usage: 0.016 seconds Real time usage: 0.023 seconds Preprocessor visited node count: 292/1000000 Post‐expand include size: 2195/2097152 bytes Template argument size: 574/2097152 bytes Highest expansion depth: 7/100 Expensive parser function count: 0/100 Unstrip recursion depth: 0/20 Unstrip post‐expand size: 0/5000000 bytes ExtLoops count: 0/1000 -->
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1190 - $GC_I_SKILL_ID_PASSAGE_TO_TAHNNAKAI
Func CanUse_PassageToTahnnakai()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PassageToTahnnakai($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1215 - $GC_I_SKILL_ID_CLAMOR_OF_SOULS
Func CanUse_ClamorOfSouls()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ClamorOfSouls($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe and all nearby foes take 10...54...65 lightning damage. If you are within earshot of a spirit or holding a bundle item, you gain 10 Energy.
	; Concise description
	; Elite Spell. Deals 10...54...65 lightning damage to target and nearby foes. You gain 10 Energy if you are within earshot of a spirit or holding a bundle item.
	Return 0
EndFunc

; Skill ID: 1216 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1224 - $GC_I_SKILL_ID_DRAW_SPIRIT
Func CanUse_DrawSpirit()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DrawSpirit($a_f_AggroRange)
	; Description
	; Spell. Teleport target allied spirit to your location.
	; Concise description
	; Spell. Teleports target allied spirit to your location.
	Return 0
EndFunc

; Skill ID: 1225 - $GC_I_SKILL_ID_CHANNELED_STRIKE
Func CanUse_ChanneledStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ChanneledStrike($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 5...77...95 lightning damage. That foe is struck for an additional 5...29...35 lightning damage if you are holding an item.
	; Concise description
	; Spell. Deals 5...77...95 lightning damage. Deals 5...29...35 additional lightning damage if you are holding an item.
	Return 0
EndFunc

; Skill ID: 1226 - $GC_I_SKILL_ID_SPIRIT_BOON_STRIKE
Func CanUse_SpiritBoonStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritBoonStrike($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 20...56...65 lightning damage, and all spirits you control within earshot gain 20...56...65 Health.
	; Concise description
	; Spell. Deals 20...56...65 lightning damage. Spirits you control within earshot gain 20...56...65 Health.
	Return 0
EndFunc

; Skill ID: 1227 - $GC_I_SKILL_ID_ESSENCE_STRIKE
Func CanUse_EssenceStrike()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc

Func BestTarget_EssenceStrike($a_f_AggroRange)
	; Description
	; This article is about the Factions skill. For the temporarily available Bonus Mission Pack skill, see Essence Strike (Togo).
	; Concise description
	; green; font-weight: bold;">15...51...60
	Return UAI_GetBestSingleTarget(-2, 1320, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1228 - $GC_I_SKILL_ID_SPIRIT_SIPHON
Func CanUse_SpiritSiphon()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritSiphon($a_f_AggroRange)
	; Description
	; This article is about the Factions skill. For the version used by Master Riyo, see Spirit Siphon (Master Riyo).
	; Concise description
	; green; font-weight: bold;">15...43...50
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1233 - $GC_I_SKILL_ID_SOOTHING_MEMORIES
Func CanUse_SoothingMemories()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SoothingMemories($a_f_AggroRange)
	; Description
	; Spell. Target ally is healed for 10...82...100 Health. If you are holding an item, you gain 3 Energy.
	; Concise description
	; Spell. Heals for 10...82...100. You gain 3 Energy if you are holding an item.
	Return 0
EndFunc

; Skill ID: 1234 - $GC_I_SKILL_ID_MEND_BODY_AND_SOUL
Func CanUse_MendBodyAndSoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MendBodyAndSoul($a_f_AggroRange)
	; Description
	; This article is about the Factions skill. For the temporarily available Bonus Mission Pack skill, see Mend Body and Soul (Togo).
	; Concise description
	; green; font-weight: bold;">20...96...115
	Return 0
EndFunc

; Skill ID: 1242 - $GC_I_SKILL_ID_ARCHEMORUS_STRIKE_CELESTIAL_SUMMONING
Func CanUse_ArchemorusStrikeCelestialSummoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ArchemorusStrikeCelestialSummoning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1243 - $GC_I_SKILL_ID_SHIELD_OF_SAINT_VIKTOR_CELESTIAL_SUMMONING
Func CanUse_ShieldOfSaintViktorCelestialSummoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldOfSaintViktorCelestialSummoning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1245 - $GC_I_SKILL_ID_GAZE_FROM_BEYOND
Func CanUse_GazeFromBeyond()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GazeFromBeyond($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1262 - $GC_I_SKILL_ID_HEALING_RING
Func CanUse_HealingRing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealingRing($a_f_AggroRange)
	; Description
	; Spell. Heal adjacent creatures for 30...150...180 Health. The caster is not healed.
	; Concise description
	; Spell. Heals adjacent allies and foes for 30...150...180. The caster is not healed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1263 - $GC_I_SKILL_ID_RENEW_LIFE
Func CanUse_RenewLife()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_RenewLife($a_f_AggroRange)
	; Description
	; Spell. Resurrect target touched dead target  party member with 50% Health and 5...17...20% Energy. That party member and all allies within earshot are healed for 55...115...130 Health.
	; Concise description
	; Touch Spell. Resurrects target party member (50% Health and 5...17...20% Energy). Heals allies within earshot for 55...115...130.
	Return 0
EndFunc

; Skill ID: 1264 - $GC_I_SKILL_ID_DOOM
Func CanUse_Doom()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Doom($a_f_AggroRange)
	; Description
	; Spell. Strike target foe for 10...34...40 lightning (maximum 135) damage for every recharging binding ritual you have.
	; Concise description
	; Spell. Deals 10...34...40 lightning damage (maximum 135) for each of your recharging binding rituals.
	Return 0
EndFunc

; Skill ID: 1265 - $GC_I_SKILL_ID_WIELDERS_BOON
Func CanUse_WieldersBoon()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WieldersBoon($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1277 - $GC_I_SKILL_ID_BATTLE_CRY2
Func CanUse_BattleCry2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BattleCry2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1278 - $GC_I_SKILL_ID_ELEMENTAL_DEFENSE_ZONE
Func CanUse_ElementalDefenseZone()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ElementalDefenseZone($a_f_AggroRange)
	; Description
	; Factions
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1279 - $GC_I_SKILL_ID_MELEE_DEFENSE_ZONE
Func CanUse_MeleeDefenseZone()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MeleeDefenseZone($a_f_AggroRange)
	; Description
	; Factions
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1283 - $GC_I_SKILL_ID_TURRET_ARROW
Func CanUse_TurretArrow()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TurretArrow($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1284 - $GC_I_SKILL_ID_BLOOD_FLOWER_SKILL
Func CanUse_BloodFlowerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BloodFlowerSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1285 - $GC_I_SKILL_ID_FIRE_FLOWER_SKILL
Func CanUse_FireFlowerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireFlowerSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1286 - $GC_I_SKILL_ID_POISON_ARROW_FLOWER
Func CanUse_PoisonArrowFlower()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonArrowFlower($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1305 - $GC_I_SKILL_ID_SHIELDING_URN_SKILL
Func CanUse_ShieldingUrnSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldingUrnSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1318 - $GC_I_SKILL_ID_FIREBALL_OBELISK
Func CanUse_FireballObelisk()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireballObelisk($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1333 - $GC_I_SKILL_ID_EXTEND_CONDITIONS
Func CanUse_ExtendConditions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ExtendConditions($a_f_AggroRange)
	; Description
	; Elite Spell. Spread all conditions from target foe to foes near your target. The durations of those conditions are increased by 5...81...100% (maximum 30 seconds).
	; Concise description
	; Elite Spell. Spread all conditions from target foe to foes near your target. Those [sic] durations of those conditions are increased by 5...81...100% (maximum 30 seconds).
	Return 0
EndFunc

; Skill ID: 1334 - $GC_I_SKILL_ID_HYPOCHONDRIA
Func CanUse_Hypochondria()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Hypochondria($a_f_AggroRange)
	; Description
	; Spell. Transfer all conditions from all foes in the area to target foe.
	; Concise description
	; Spell. Transfer all conditions from foes in the area to target foe.
	Return 0
EndFunc

; Skill ID: 1336 - $GC_I_SKILL_ID_SPIRITUAL_PAIN
Func CanUse_SpiritualPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritualPain($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 15...63...75 damage. All hostile summoned creatures in the area of that foe take 25...105...125 damage.
	; Concise description
	; Spell. Deals 15...63...75 damage. Deals 25...105...125 damage to hostile summoned creatures in the area of your target foe.

	; Priority: Target with most summoned creatures (spirits/minions) in area
	Local $l_i_BestAgent = 0
	Local $l_i_BestSummonCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Check range
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Must be living enemy
		If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop

		; Count enemy spirits and minions in area range
		Local $l_i_SpiritCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsSpirit")
		Local $l_i_MinionCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMinion")
		Local $l_i_SummonCount = $l_i_SpiritCount + $l_i_MinionCount

		If $l_i_SummonCount > $l_i_BestSummonCount Then
			$l_i_BestSummonCount = $l_i_SummonCount
			$l_i_BestAgent = $l_i_AgentID
		EndIf
	Next

	; Found a target near summoned creatures
	If $l_i_BestAgent <> 0 Then Return $l_i_BestAgent

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1337 - $GC_I_SKILL_ID_DRAIN_DELUSIONS
Func CanUse_DrainDelusions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DrainDelusions($a_f_AggroRange)
	; Description
	; Spell. Remove one Mesmer hex from target foe. If a hex was removed in this way, that foe loses 1...4...5 Energy and you gain 4 Energy for each point lost.
	; Concise description
	; Spell. Removes one Mesmer hex from target foe. Causes 1...4...5 Energy loss. You gain 4 Energy for each point lost. No effect unless a hex was removed.
	Return 0
EndFunc

; Skill ID: 1342 - $GC_I_SKILL_ID_TEASE
Func CanUse_Tease()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Tease($a_f_AggroRange)
	; Description
	; Elite Spell. If target foe is using a skill, that foe and other foes in the area are interrupted and you steal 0...4...5 Energy from all foes in the area.
	; Concise description
	; Elite Spell. Interrupts a skill. Interruption effect: also interrupts other foes in the area, and you steal 0...4...5 Energy from all foes in the area.
	Return 0
EndFunc

; Skill ID: 1347 - $GC_I_SKILL_ID_DISCHARGE_ENCHANTMENT
Func CanUse_DischargeEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DischargeEnchantment($a_f_AggroRange)
	; Description
	; Spell. Remove one enchantment from target foe. If that foe is hexed, this skill recharges 20...44...50% faster.
	; Concise description
	; Spell. Removes one enchantment from target foe. 20...44...50% faster recharge if that foe was hexed.
	Return 0
EndFunc

; Skill ID: 1348 - $GC_I_SKILL_ID_HEX_EATER_VORTEX
Func CanUse_HexEaterVortex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HexEaterVortex($a_f_AggroRange)
	; Description
	; Elite Spell. Remove a hex from target ally. If a hex is removed in this way, foes near that ally take 30...78...90 damage and lose one enchantment.
	; Concise description
	; Elite Spell. Removes one hex from target ally. Removal effect: deals 30...78...90 damage and removes one enchantment from foes near this ally.
	Return 0
EndFunc

; Skill ID: 1349 - $GC_I_SKILL_ID_MIRROR_OF_DISENCHANTMENT
Func CanUse_MirrorOfDisenchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MirrorOfDisenchantment($a_f_AggroRange)
	; Description
	; Spell. Remove one enchantment from target foe. All of that foe's party members also lose that same enchantment.
	; Concise description
	; Spell. Removes one enchantment from target foe. That foe's party members also lose this enchantment.
	Return 0
EndFunc

; Skill ID: 1350 - $GC_I_SKILL_ID_SIMPLE_THIEVERY
Func CanUse_SimpleThievery()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SimpleThievery($a_f_AggroRange)
	; Description
	; Elite Spell. Interrupt target foe's action. If that action was a skill, that skill is disabled for 5...17...20 seconds, and Simple Thievery is replaced by that skill.
	; Concise description
	; Elite Spell. Interrupts an action. Interruption effect: If a skill was interrupted, that skill is disabled and Simple Thievery becomes that skill (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 1351 - $GC_I_SKILL_ID_ANIMATE_SHAMBLING_HORROR
Func CanUse_AnimateShamblingHorror()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateShamblingHorror($a_f_AggroRange)
	; Description
	; Spell. Exploit nearest corpse to create a level 1...14...17 shambling horror. When the shambling horror dies, it is replaced by a level 0...12...15 jagged horror that causes Bleeding with each of its attacks.
	; Concise description
	; Spell. Creates a level 1...14...17 shambling horror. When the shambling horror dies, it is replaced by a level 0...12...15 jagged horror that causes Bleeding with each of its attacks. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1352 - $GC_I_SKILL_ID_ORDER_OF_UNDEATH
Func CanUse_OrderOfUndeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfUndeath($a_f_AggroRange)
	; Description
	; Elite Spell. For 5 seconds, your minions deal +3...13...16 damage, but you lose 2% of your maximum Health whenever one of your minions hits with an attack.
	; Concise description
	; Elite Spell. (5 seconds.) Your undead servants deal +3...13...16 damage. You lose 2% of your maximum Health whenever your servants hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1353 - $GC_I_SKILL_ID_PUTRID_FLESH
Func CanUse_PutridFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PutridFlesh($a_f_AggroRange)
	; Description
	; Spell. Destroy one of your target animated undead minions. All foes near that creature are Diseased for 5...13...15 seconds.
	; Concise description
	; Spell. Destroys one of your undead servants. Inflicts Diseased condition (5...13...15 seconds) to foes near this servant.
	Return 0
EndFunc

; Skill ID: 1354 - $GC_I_SKILL_ID_FEAST_FOR_THE_DEAD
Func CanUse_FeastForTheDead()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FeastForTheDead($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1359 - $GC_I_SKILL_ID_PAIN_OF_DISENCHANTMENT
Func CanUse_PainOfDisenchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PainOfDisenchantment($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe loses 1...3...3 enchantment[s]. If an enchantment was lost in this way, that foe and all adjacent foes lose 10...82...100 Health.
	; Concise description
	; Elite Spell. Target foe loses 1...3...3 enchantment[s]. Removal effect: that foe and all adjacent foes lose 10...82...100 Health.
	Return 0
EndFunc

; Skill ID: 1367 - $GC_I_SKILL_ID_BLINDING_SURGE
Func CanUse_BlindingSurge()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BlindingSurge($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe is struck for 5...41...50 lightning damage. That foe and all adjacent foes are Blinded for 3...7...8 seconds. This spell has 25% armor penetration. If this spell strikes an attacking foe, all adjacent foes are also struck and this spell deals 50% more damage.
	; Concise description
	; Elite Spell. Deals 5...41...50 lightning damage. Inflicts Blindness condition (3...7...8 seconds) on target and adjacent foes. 25% armor penetration. If target was attacking, also hits adjacent foes and deals 50% more damage.
	Return 0
EndFunc

; Skill ID: 1369 - $GC_I_SKILL_ID_LIGHTNING_BOLT
Func CanUse_LightningBolt()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningBolt($a_f_AggroRange)
	; Description
	; Spell. Send out a Lightning Bolt that strikes for 5...41...50 lightning damage if it hits. If Lightning Bolt strikes a moving foe, that foe is struck for 5...41...50 additional lightning damage. This spell has 25% armor penetration.
	; Concise description
	; Spell. Projectile: deals 5...41...50 lightning damage. Deals 5...41...50 more lightning damage if target foe is moving. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 1372 - $GC_I_SKILL_ID_SANDSTORM
Func CanUse_Sandstorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Sandstorm($a_f_AggroRange)
	; Description
	; Elite Spell. Create a Sandstorm at target foe's location. For 10 seconds, nearby foes are struck for 10...26...30 earth damage each second and attacking foes are struck for an additional 10...26...30 earth damage each second.
	; Concise description
	; Elite Spell. Deals 10...26...30 earth damage each second (10 seconds). Hits foes near target foe's initial location. Hits attacking foes for 10...26...30 more earth damage each second.
	Return 0
EndFunc

; Skill ID: 1374 - $GC_I_SKILL_ID_EBON_HAWK
Func CanUse_EbonHawk()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EbonHawk($a_f_AggroRange)
	; Description
	; Spell. Send a projectile that strikes target foe for 10...70...85 earth damage and causes Weakness for 5...13...15 seconds if it hits.
	; Concise description
	; Spell. Projectile: deals 10...70...85 earth damage and inflicts Weakness condition (5...13...15 seconds).
	Return 0
EndFunc

; Skill ID: 1379 - $GC_I_SKILL_ID_GLOWING_GAZE1
Func CanUse_GlowingGaze1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GlowingGaze1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1380 - $GC_I_SKILL_ID_SAVANNAH_HEAT
Func CanUse_SavannahHeat()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SavannahHeat($a_f_AggroRange)
	; Description
	; Elite Spell. You create Savannah Heat at target foe's location. For 5 seconds, all nearby foes take 5...17...20 fire damage for each second this spell has been in effect.
	; Concise description
	; Elite Spell. Deals 5...17...20 fire damage for each second since casting this spell (5 seconds). Hits foes near target's initial location.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1396 - $GC_I_SKILL_ID_WORDS_OF_COMFORT
Func CanUse_WordsOfComfort()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WordsOfComfort($a_f_AggroRange)
	; Description
	; Spell. Target ally is healed for 15...51...60 Health and an additional 15...39...45 Health if that ally is suffering from a condition.
	; Concise description
	; Spell. Heals for 15...51...60. Heals for 15...39...45 more if target ally has a condition.
	Return 0
EndFunc

; Skill ID: 1397 - $GC_I_SKILL_ID_LIGHT_OF_DELIVERANCE
Func CanUse_LightOfDeliverance()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightOfDeliverance($a_f_AggroRange)
	; Description
	; Elite Spell. All party members are healed for 5...57...70 Health.
	; Concise description
	; Elite Spell. Heals entire party for 5...57...70.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1401 - $GC_I_SKILL_ID_MENDING_TOUCH
Func CanUse_MendingTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MendingTouch($a_f_AggroRange)
	; Description
	; Spell. Touched ally loses two conditions and is healed for 15...51...60 Health for each condition removed in this way.
	; Concise description
	; Touch Spell. Removes two conditions. Heals for 15...51...60 for each condition removed.
	Return 0
EndFunc

; Skill ID: 1424 - $GC_I_SKILL_ID_STOP_PUMP
Func CanUse_StopPump()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_StopPump($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Stop_Pump","wgRelevantArticleId":282756,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1430 - $GC_I_SKILL_ID_WAVE_OF_TORMENT
Func CanUse_WaveOfTorment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WaveOfTorment($a_f_AggroRange)
	; Description
	; Spell. All enemies in the area are hit for 150 damage.
	; Concise description
	; Spell. Deals 150 damage to all foes in the area.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1434 - $GC_I_SKILL_ID_CORRUPTED_HEALING
Func CanUse_CorruptedHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CorruptedHealing($a_f_AggroRange)
	; Description
	; Spell. Heal one corrupted root for 300 Health. Caster is also fully healed.
	; Concise description
	; Spell. Heal one corrupted root for 300. Caster is also fully healed.
	Return 0
EndFunc

; Skill ID: 1444 - $GC_I_SKILL_ID_SUMMON_TORMENT
Func CanUse_SummonTorment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SummonTorment($a_f_AggroRange)
	; Description
	; Spell. Any nearby rifts or altars become much more Tormented
	; Concise description
	; Spell. Any nearby rifts or altars become much more Tormented.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1479 - $GC_I_SKILL_ID_OFFERING_OF_SPIRIT
Func CanUse_OfferingOfSpirit()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OfferingOfSpirit($a_f_AggroRange)
	; Description
	; This article is about the Nightfall skill. For the temporarily available Bonus Mission Pack skill, see Offering of Spirit (Togo).
	; Concise description
	; green; font-weight: bold;">8...15...17
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1482 - $GC_I_SKILL_ID_RECLAIM_ESSENCE
Func CanUse_ReclaimEssence()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ReclaimEssence($a_f_AggroRange)
	; Description
	; Elite Spell. All of your Spirits die. You gain 5...17...20 Energy and all of your Binding Rituals are recharged if a Spirit died in this way.
	; Concise description
	; Elite Spell. All of your Spirits die. If a Spirit dies in this way, you gain 5...17...20 Energy and all of your Binding Rituals are recharged.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1491 - $GC_I_SKILL_ID_MYSTIC_TWISTER
Func CanUse_MysticTwister()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MysticTwister($a_f_AggroRange)
	; Description
	; Spell. Deals 10...50...60 cold damage to all nearby foes. If you are enchanted, this spell deals an additional 10...50...60 cold damage.
	; Concise description
	; Spell. Deals 10...50...60 cold damage to all nearby foes. Deals 10...50...60 more cold damage if you are enchanted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1525 - $GC_I_SKILL_ID_NATURAL_HEALING
Func CanUse_NaturalHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NaturalHealing($a_f_AggroRange)
	; Description
	; Spell. You are healed for 50...146...170 Health. If you are not enchanted, this spell activates 50% faster.
	; Concise description
	; Spell. Heals you for 50...146...170. This skill activates 50% faster if you are not enchanted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1526 - $GC_I_SKILL_ID_IMBUE_HEALTH
Func CanUse_ImbueHealth()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ImbueHealth($a_f_AggroRange)
	; Description
	; Spell. Target other ally is healed for 5...41...50% of your current Health (maximum 300 Health).
	; Concise description
	; Spell. Heals for 5...41...50% of your current Health (maximum 300). Cannot self-target.
	Return 0
EndFunc

; Skill ID: 1527 - $GC_I_SKILL_ID_MYSTIC_HEALING
Func CanUse_MysticHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MysticHealing($a_f_AggroRange)
	; Description
	; Spell. You are healed for 5...53...65 Health. Also heals all enchanted party members for 5...53...65 Health.
	; Concise description
	; Spell. Heals you for 5...53...65. Heals all enchanted party members for 5...53...65 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1528 - $GC_I_SKILL_ID_DWAYNAS_TOUCH
Func CanUse_DwaynasTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DwaynasTouch($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1529 - $GC_I_SKILL_ID_PIOUS_RESTORATION
Func CanUse_PiousRestoration()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PiousRestoration($a_f_AggroRange)
	; Description
	; Spell. You gain 80...136...150 Health and remove 1 Dervish enchantment. If an enchantment was removed in this way, you also lose 1...2...2 hex[es].
	; Concise description
	; Spell. Gain 80...136...150 Health and remove 1 Dervish enchantment. Removal effect: lose 1...2...2 hex[es].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1532 - $GC_I_SKILL_ID_MYSTIC_SANDSTORM
Func CanUse_MysticSandstorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MysticSandstorm($a_f_AggroRange)
	; Description
	; Spell. Create a sandstorm at your location that lasts 3 seconds. Each second, foes nearby this location take 10...18...20 earth damage. Attacking foes take an additional 10...18...20 damage. If you are enchanted when you cast this spell, it lasts twice as long.
	; Concise description
	; Spell. (3 seconds.) Deals 10...18...20 earth damage each second. Deals an additional 10...18...20 damage to attacking foes. Hits foes nearby your initial location. Lasts twice as long if you are enchanted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1533 - $GC_I_SKILL_ID_WINDS_OF_DISENCHANTMENT
Func CanUse_WindsOfDisenchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WindsOfDisenchantment($a_f_AggroRange)
	; Description
	; Spell. Lose 1 Dervish enchantment. If a Dervish enchantment was removed in this way, all nearby foes lose 1 enchantment and take 20...68...80 cold damage.
	; Concise description
	; Spell. Remove one of your Dervish enchantments. Removal effect: all nearby foes lose 1 enchantment and take 20...68...80 cold damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1534 - $GC_I_SKILL_ID_RENDING_TOUCH
Func CanUse_RendingTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RendingTouch($a_f_AggroRange)
	; Description
	; Spell. Deals 15...55...65 cold damage to target foe. You lose one Dervish enchantment. If an enchantment was removed, target foe loses 1 enchantment and you gain 1 strike of adrenaline.
	; Concise description
	; Touch Spell. Deals 15...55...65 cold damage. Lose 1 Dervish enchantment. Removal effect: target foe loses 1 enchantment and you gain 1 strike of adrenaline.
	Return 0
EndFunc

; Skill ID: 1545 - $GC_I_SKILL_ID_TEST_OF_FAITH
Func CanUse_TestOfFaith()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TestOfFaith($a_f_AggroRange)
	; Description
	; Spell. Deals 15...55...65 cold damage and takes 1 enchantment from target foe. If that foe was not enchanted, that foe is Dazed for 1...3...4 second[s].
	; Concise description
	; Touch Spell. Deals 15...55...65 cold damage and removes 1 enchantment. Target foe is Dazed for 1...3...4 second[s] if that foe was not enchanted.
	Return 0
EndFunc

; Skill ID: 1610 - $GC_I_SKILL_ID_SUMMONING_OF_THE_SCEPTER
Func CanUse_SummoningOfTheScepter()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SummoningOfTheScepter($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1611 - $GC_I_SKILL_ID_RISE_FROM_YOUR_GRAVE
Func CanUse_RiseFromYourGrave()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RiseFromYourGrave($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1651 - $GC_I_SKILL_ID_DEATHS_RETREAT
Func CanUse_DeathsRetreat()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DeathsRetreat($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1653 - $GC_I_SKILL_ID_SWAP
Func CanUse_Swap()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Swap($a_f_AggroRange)
	; Description
	; Spell. You and target summoned creature Shadow Step to each other's location.
	; Concise description
	; Spell. You and target summoned creature Shadow Step to each other's locations.
	Return 0
EndFunc

; Skill ID: 1659 - $GC_I_SKILL_ID_TOXIC_CHILL
Func CanUse_ToxicChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ToxicChill($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe is struck for 15...63...75 cold damage. If that foe is under the effects of a hex or enchantment, that foe becomes Poisoned for 10...22...25 seconds.
	; Concise description
	; Elite Spell. Deals 15...63...75 cold damage. Inflicts Poisoned condition (10...22...25 seconds) if target foe is hexed or enchanted.
	Return 0
EndFunc

; Skill ID: 1661 - $GC_I_SKILL_ID_GLOWSTONE
Func CanUse_Glowstone()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Glowstone($a_f_AggroRange)
	; Description
	; Spell. Send a projectile that strikes for 5...41...50 earth damage if it hits. If this spell hits a weakened  foe, you gain 5 Energy plus 1 Energy for every 2 ranks of Energy Storage.
	; Concise description
	; Spell. Projectile: deals 5...41...50 earth damage. You gain 5 Energy plus 1 Energy for every 2 ranks of Energy Storage if target foe is Weakened.
	Return 0
EndFunc

; Skill ID: 1662 - $GC_I_SKILL_ID_MIND_BLAST
Func CanUse_MindBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MindBlast($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe is struck for 15...51...60 fire damage. If you have more Energy than target foe, you gain 1...7...8 Energy.
	; Concise description
	; Elite Spell. Deals 15...51...60 fire damage. You gain 1...7...8 Energy if you have more Energy than target foe.
	Return 0
EndFunc

; Skill ID: 1664 - $GC_I_SKILL_ID_INVOKE_LIGHTNING
Func CanUse_InvokeLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_InvokeLightning($a_f_AggroRange)
	; Description
	; Elite Spell. Target foe and up to two other foes near your target are struck for 10...74...90 lightning damage. This spell has 25% armor penetration.
	; Concise description
	; Elite Spell. Deals 10...74...90 lightning damage. Hits two foes near target. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 1665 - $GC_I_SKILL_ID_BATTLE_CRY1
Func CanUse_BattleCry1()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BattleCry1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1666 - $GC_I_SKILL_ID_MENDING_SHRINE_BONUS
Func CanUse_MendingShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MendingShrineBonus($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; Locations">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1667 - $GC_I_SKILL_ID_ENERGY_SHRINE_BONUS
Func CanUse_EnergyShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnergyShrineBonus($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Acquisition">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1668 - $GC_I_SKILL_ID_NORTHERN_HEALTH_SHRINE_BONUS
Func CanUse_NorthernHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NorthernHealthShrineBonus($a_f_AggroRange)
	; Description
	; Spell. Your party members' maximum Health is increased by 120.
	; Concise description
	; Spell. Your party members have +120 maximum Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1669 - $GC_I_SKILL_ID_SOUTHERN_HEALTH_SHRINE_BONUS
Func CanUse_SouthernHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SouthernHealthShrineBonus($a_f_AggroRange)
	; Description
	; Spell. Your party members' maximum Health is increased by 120.
	; Concise description
	; Spell. Your party members have +120 maximum Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1672 - $GC_I_SKILL_ID_TO_THE_PAIN_HERO_BATTLES
Func CanUse_ToThePainHeroBattles()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ToThePainHeroBattles($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1686 - $GC_I_SKILL_ID_GLIMMER_OF_LIGHT
Func CanUse_GlimmerOfLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GlimmerOfLight($a_f_AggroRange)
	; Description
	; Elite Spell. Heal target ally for 10...94...115 Health.
	; Concise description
	; Elite Spell. Heals for 10...94...115.
	Return 0
EndFunc

; Skill ID: 1687 - $GC_I_SKILL_ID_ZEALOUS_BENEDICTION
Func CanUse_ZealousBenediction()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ZealousBenediction($a_f_AggroRange)
	; Description
	; Elite Spell. Heal target ally for 30...150...180 Health. If target was below 50% Health, you gain 7 Energy.
	; Concise description
	; Elite Spell. Heals for 30...150...180. You gain 7 Energy if target ally was below 50% Health.
	Return 0
EndFunc

; Skill ID: 1691 - $GC_I_SKILL_ID_DISMISS_CONDITION
Func CanUse_DismissCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DismissCondition($a_f_AggroRange)
	; Description
	; Spell. Remove one condition from target ally. If that ally is under the effects of an enchantment, that ally is healed for 15...63...75 Health.
	; Concise description
	; Spell. Removes one condition. Heals for 15...63...75 if target ally is enchanted.
	Return 0
EndFunc

; Skill ID: 1692 - $GC_I_SKILL_ID_DIVERT_HEXES
Func CanUse_DivertHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DivertHexes($a_f_AggroRange)
	; Description
	; Elite Spell. Remove up to 1...3...3 hex[es] from target ally. For each hex removed in this way, that ally loses one condition and gains 15...63...75 Health.
	; Concise description
	; Elite Spell. Removes 1...3...3 hex[es]. For each hex removed, target ally loses one condition and gains 15...63...75 Health.
	Return 0
EndFunc

; Skill ID: 1717 - $GC_I_SKILL_ID_SUNSPEAR_SIEGE
Func CanUse_SunspearSiege()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SunspearSiege($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1733 - $GC_I_SKILL_ID_WIELDERS_STRIKE
Func CanUse_WieldersStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WieldersStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1741 - $GC_I_SKILL_ID_GHOSTMIRROR_LIGHT
Func CanUse_GhostmirrorLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GhostmirrorLight($a_f_AggroRange)
	; Description
	; Spell. Target other ally is healed for 15...75...90 Health. If you are within earshot of a spirit, you are also healed for 15...75...90 Health.
	; Concise description
	; Spell. Heals for 15...75...90. You gain 15...75...90 Health if you are within earshot of a spirit. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 1744 - $GC_I_SKILL_ID_CARETAKERS_CHARGE
Func CanUse_CaretakersCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CaretakersCharge($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1859 - $GC_I_SKILL_ID_ALTAR_BUFF
Func CanUse_AltarBuff()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AltarBuff($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1866 - $GC_I_SKILL_ID_CAPTURE_POINT
Func CanUse_CapturePoint()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CapturePoint($a_f_AggroRange)
	; Description
	; Spell. While within the range of this capture point, heroes and henchmen take the initiative in attacking targets.
	; Concise description
	; Spell. While within the range of this catpure point, heroes and henchmen take the initiative in attacking targets.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1885 - $GC_I_SKILL_ID_BANISH_ENCHANTMENT
Func CanUse_BanishEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BanishEnchantment($a_f_AggroRange)
	; Description
	; Spell. All enchantments are removed from caster's target foe. For each enchantment removed in this way, one skill is disabled on all foes for 6 seconds.
	; Concise description
	; Spell. All enchantments are removed from target foe. For each enchantment removed in this way, one skill is disabled on all foes (6 seconds).
	Return 0
EndFunc

; Skill ID: 1896 - $GC_I_SKILL_ID_UNYIELDING_ANGUISH
Func CanUse_UnyieldingAnguish()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UnyieldingAnguish($a_f_AggroRange)
	; Description
	; Spell. Caster resurrects the nearest Anguished Soul.
	; Concise description
	; Spell. Caster resurrects the nearest Anguished Soul.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1938 - $GC_I_SKILL_ID_PUTRID_FLAMES
Func CanUse_PutridFlames()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PutridFlames($a_f_AggroRange)
	; Description
	; Spell. All adjacent foes are struck for 100 fire damage and becomes Poisoned and Diseased for 10 seconds.
	; Concise description
	; Spell. Deals 100 fire damage; inflicts Poisoned and Diseased conditions (10 seconds); affects adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1983 - $GC_I_SKILL_ID_FIRE_DART
Func CanUse_FireDart()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireDart($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; deals 33 damage and inflicts Burning condition (4 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1984 - $GC_I_SKILL_ID_ICE_DART
Func CanUse_IceDart()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_IceDart($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; deals 33 damage and causes 33% slower movement (6 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1985 - $GC_I_SKILL_ID_POISON_DART
Func CanUse_PoisonDart()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonDart($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; deals 33 damage and inflicts Poisoned condition (8 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1994 - $GC_I_SKILL_ID_POWER_LOCK
Func CanUse_PowerLock()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PowerLock($a_f_AggroRange)
	; Description
	; Spell. If target foe is casting a spell or chant, that skill is interrupted and disabled for an additional 5...11...13 seconds.
	; Concise description
	; Spell. Interrupts a spell or chant. Interruption effect: interrupted spell or chant is disabled for +5...11...13 seconds.
	Return 0
EndFunc

; Skill ID: 1995 - $GC_I_SKILL_ID_WASTE_NOT_WANT_NOT
Func CanUse_WasteNotWantNot()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WasteNotWantNot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2003 - $GC_I_SKILL_ID_CURE_HEX
Func CanUse_CureHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CureHex($a_f_AggroRange)
	; Description
	; Spell. Remove one Hex from target ally. If a Hex was removed, that ally is healed for 30...102...120 Health.
	; Concise description
	; Spell. Removes a Hex. Removal effect: Heals for 30...102...120.
	Return 0
EndFunc

; Skill ID: 2004 - $GC_I_SKILL_ID_SMITE_CONDITION
Func CanUse_SmiteCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SmiteCondition($a_f_AggroRange)
	; Description
	; Spell. Remove one condition from target ally. If a condition was removed, foes in the area take 10...50...60 holy damage.
	; Concise description
	; Spell. Removes a condition. Removal effect: deals 10...50...60 holy damage to foes in the area of target ally.
	Return 0
EndFunc

; Skill ID: 2019 - $GC_I_SKILL_ID_BURNING_GROUND
Func CanUse_BurningGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BurningGround($a_f_AggroRange)
	; Description
	; Environment effect
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Burning_Ground","wgRelevantArticleId":307391,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2020 - $GC_I_SKILL_ID_FREEZING_GROUND
Func CanUse_FreezingGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FreezingGround($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2021 - $GC_I_SKILL_ID_POISON_GROUND
Func CanUse_PoisonGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonGround($a_f_AggroRange)
	; Description
	; Environment effect
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Poison_Ground","wgRelevantArticleId":307390,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2022 - $GC_I_SKILL_ID_FIRE_JET
Func CanUse_FireJet()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireJet($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; 302px;">
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2024 - $GC_I_SKILL_ID_POISON_JET
Func CanUse_PoisonJet()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonJet($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2027 - $GC_I_SKILL_ID_FIRE_SPOUT
Func CanUse_FireSpout()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireSpout($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; 302px;">
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2029 - $GC_I_SKILL_ID_POISON_SPOUT
Func CanUse_PoisonSpout()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonSpout($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2045 - $GC_I_SKILL_ID_SARCOPHAGUS_SPORES
Func CanUse_SarcophagusSpores()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SarcophagusSpores($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2046 - $GC_I_SKILL_ID_EXPLODING_BARREL
Func CanUse_ExplodingBarrel()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ExplodingBarrel($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2051 - $GC_I_SKILL_ID_SUMMON_SPIRITS_LUXON
Func CanUse_SummonSpiritsLuxon()
	If Anti_Spell() Then Return False
	Local $lSpiritsAt5000 = UAI_CountAgents(-2, 5000, "UAI_Filter_IsControlledSpirit")
	If $lSpiritsAt5000 = 0 Then Return False

	Local $lSpiritsAt1000 = UAI_CountAgents(-2, 1000, "UAI_Filter_IsControlledSpirit")

	If $lSpiritsAt5000 > 0 And $lSpiritsAt1000 = $lSpiritsAt5000 Then
		$lLowestSpirit = UAI_GetAgentLowest(-2, 1320, $GC_UAI_AGENT_HP, "UAI_Filter_IsControlledSpirit")
		If UAI_GetAgentInfoByID($lLowestSpirit, $GC_UAI_AGENT_HP) < 0.85 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_SummonSpiritsLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2055 - $GC_I_SKILL_ID_ANEURYSM
Func CanUse_Aneurysm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Aneurysm($a_f_AggroRange)
	; Description
	; Spell. Target foe regains all Energy. For each point of Energy gained in this way, that foe takes 1...3...3 damage and all adjacent foes lose 1 Energy. (Maximum 1...24...30).
	; Concise description
	; Spell. Target foe regains all Energy. For each point of Energy gained, target takes 1...3...3 damage and all adjacent foes lose 1 Energy (maximum 1...24...30).
	Return 0
EndFunc

; Skill ID: 2057 - $GC_I_SKILL_ID_FOUL_FEAST
Func CanUse_FoulFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FoulFeast($a_f_AggroRange)
	; Description
	; Spell. All conditions are transferred from target other ally to yourself. For each condition acquired in this way, you gain 0...36...45 Health and 0...2...2 Energy. This skill recharges twice as fast if you remove Disease from your target.
	; Concise description
	; Spell. Transfers all conditions from target ally to yourself. You gain 0...36...45 Health and 0...2...2 Energy for each condition transferred. Half recharge if you remove Disease. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 2059 - $GC_I_SKILL_ID_SHELL_SHOCK
Func CanUse_ShellShock()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShellShock($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 10...26...30 lightning damage and has Cracked Armor for 5...17...20 seconds. This spell has 25% armor penetration. If you are Overcast, this spell strikes adjacent foes.
	; Concise description
	; Spell. Deals 10...26...30 lightning damage. Inflicts Cracked Armor condition (5...17...20 seconds). 25% armor penetration. If Overcast, strikes adjacent.
	Return 0
EndFunc

; Skill ID: 2062 - $GC_I_SKILL_ID_HEALING_RIBBON
Func CanUse_HealingRibbon()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealingRibbon($a_f_AggroRange)
	; Description
	; Spell. Target other ally is healed for 20...92...110 Health. Up to 2 additional allies near target ally are healed for 10...82...100 Health.
	; Concise description
	; Spell. Heals for 20...92...110. Heals two additional allies near target ally for 10...82...100. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 2076 - $GC_I_SKILL_ID_DRAIN_MINION
Func CanUse_DrainMinion()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DrainMinion($a_f_AggroRange)
	; Description
	; Spell. Sacrifice target undead servant to gain 300 Health.
	; Concise description
	; Spell. Sacrifice target undead servant to gain 300 Health.
	Return 0
EndFunc

; Skill ID: 2079 - $GC_I_SKILL_ID_FLESHREAVERS_ESCAPE
Func CanUse_FleshreaversEscape()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FleshreaversEscape($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2083 - $GC_I_SKILL_ID_MANDRAGORS_CHARGE
Func CanUse_MandragorsCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MandragorsCharge($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2084 - $GC_I_SKILL_ID_ROCK_SLIDE
Func CanUse_RockSlide()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RockSlide($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2085 - $GC_I_SKILL_ID_AVALANCHE_EFFECT
Func CanUse_AvalancheEffect()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AvalancheEffect($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2087 - $GC_I_SKILL_ID_CEILING_COLLAPSE
Func CanUse_CeilingCollapse()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CeilingCollapse($a_f_AggroRange)
	; Description
	; Spell. Creature causes debris to fall from the ceiling, dealing 50 damage and interrupting all foes within earshot.
	; Concise description
	; Spell. Creature causes debris to fall from the ceiling, dealing 50 damage and interrupting all foes within earshot.
	Return 0
EndFunc

; Skill ID: 2100 - $GC_I_SKILL_ID_SUMMON_SPIRITS_KURZICK
Func CanUse_SummonSpiritsKurzick()
	If Anti_Spell() Then Return False
	Local $lSpiritsAt5000 = UAI_CountAgents(-2, 5000, "UAI_Filter_IsControlledSpirit")
	If $lSpiritsAt5000 = 0 Then Return False

	Local $lSpiritsAt1000 = UAI_CountAgents(-2, 1000, "UAI_Filter_IsControlledSpirit")

	If $lSpiritsAt5000 > 0 And $lSpiritsAt1000 = $lSpiritsAt5000 Then
		$lLowestSpirit = UAI_GetAgentLowest(-2, 1320, $GC_UAI_AGENT_HP, "UAI_Filter_IsControlledSpirit")
		If UAI_GetAgentInfoByID($lLowestSpirit, $GC_UAI_AGENT_HP) < 0.85 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_SummonSpiritsKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2102 - $GC_I_SKILL_ID_CRY_OF_PAIN
Func CanUse_CryOfPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CryOfPain($a_f_AggroRange)
	; Description
	; Spell. Interrupt target foe's skill. If that foe was suffering from a Mesmer hex, that foe and all foes in the area take 25...50 damage and have 3...5 Health degeneration for 10 seconds.
	; Concise description
	; Spell. Interrupts a skill. If target foe had a Mesmer hex, deals 25...50 damage to target and foes in the area and causes 3...5 Health degeneration (10 seconds).
	Return 0
EndFunc

; Skill ID: 2161 - $GC_I_SKILL_ID_GOLEM_FIRE_SHIELD
Func CanUse_GolemFireShield()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GolemFireShield($a_f_AggroRange)
	; Description
	; Spell. You are immune to the damage and effects from fire darts while in the area of the worker golem.
	; Concise description
	; Spell. You are immune to damage and effects from fire darts while in the area of the worker golem.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2165 - $GC_I_SKILL_ID_DIAMONDSHARD_GRAVE
Func CanUse_DiamondshardGrave()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DiamondshardGrave($a_f_AggroRange)
	; Description
	; Spell. Frozen condensation coalesces into spikes of ice, deals 140 damage, and causes Bleeding for 10 seconds.
	; Concise description
	; Spell. Frozen condensation coalesces into spikes of ice, deals 140 damage, and inflicts the Bleeding condition (10 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2167 - $GC_I_SKILL_ID_DIAMONDSHARD_MIST
Func CanUse_DiamondshardMist()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DiamondshardMist($a_f_AggroRange)
	; Description
	; Spell. The Remnant of Antiquities begins freezing the condensation within the air, focusing it into crystal shards.
	; Concise description
	; Spell. Condensation in the air freezes into glittering shards. While in this area, you move 33% slower.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2172 - $GC_I_SKILL_ID_RAVEN_SWOOP_A_GATE_TOO_FAR
Func CanUse_RavenSwoopAGateTooFar()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RavenSwoopAGateTooFar($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2189 - $GC_I_SKILL_ID_ANGORODONS_GAZE
Func CanUse_AngorodonsGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AngorodonsGaze($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2191 - $GC_I_SKILL_ID_SLIPPERY_GROUND
Func CanUse_SlipperyGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SlipperyGround($a_f_AggroRange)
	; Description
	; Spell. If target or adjacent foes are Blind or moving, these foes are knocked down. There is a 50% chance of failure with Water Magic less than 5.
	; Concise description
	; Spell. Causes knock-down if this foe is Blind or moving. Affects foes adjacent to your target. 50% failure chance unless Water Magic greater than 4.
	Return 0
EndFunc

; Skill ID: 2192 - $GC_I_SKILL_ID_GLOWING_ICE
Func CanUse_GlowingIce()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GlowingIce($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 5...41...50 cold damage. If that foe is under the effects of a Water Magic hex, you gain 5 Energy plus 1 Energy for every 2 ranks of Energy Storage.
	; Concise description
	; Spell. Deals 5...41...50 cold damage. You gain 5 Energy plus 1 Energy for every 2 ranks of Energy Storage if target foe is hexed with Water Magic.
	Return 0
EndFunc

; Skill ID: 2193 - $GC_I_SKILL_ID_ENERGY_BLAST
Func CanUse_EnergyBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnergyBlast($a_f_AggroRange)
	; Description
	; This article is about the Elementalist skill. For the monster skill of the same name, see Energy Blast (golem).
	; Concise description
	; green; font-weight: bold;">1...2...2
	Return 0
EndFunc

; Skill ID: 2202 - $GC_I_SKILL_ID_MENDING_GRIP
Func CanUse_MendingGrip()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MendingGrip($a_f_AggroRange)
	; Description
	; Spell. Target ally is healed for 15...63...75 Health. If that ally is under the effects of a weapon spell, that ally loses one condition.
	; Concise description
	; Spell. Heals for 15...63...75. Removes one condition if target ally is under a Weapon [sic] spell.
	Return 0
EndFunc

; Skill ID: 2211 - $GC_I_SKILL_ID_ALKARS_ALCHEMICAL_ACID
Func CanUse_AlkarsAlchemicalAcid()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AlkarsAlchemicalAcid($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2212 - $GC_I_SKILL_ID_LIGHT_OF_DELDRIMOR
Func CanUse_LightOfDeldrimor()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightOfDeldrimor($a_f_AggroRange)
	; Description
	; Spell. All foes in the area are struck for 55...80 holy damage. The location of hidden objects are briefly indicated on your Compass. Any hidden objects in the area are revealed.
	; Concise description
	; Spell. Deals 55...80 holy damage to foes in the area. Pings hidden objects within the area on the compass.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2221 - $GC_I_SKILL_ID_BREATH_OF_THE_GREAT_DWARF
Func CanUse_BreathOfTheGreatDwarf()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BreathOfTheGreatDwarf($a_f_AggroRange)
	; Description
	; Spell. All party members are relieved of Burning and are healed for 50...60 Health.
	; Concise description
	; Spell. Removes burning and heals for 50...60 Health. Affects party members.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2222 - $GC_I_SKILL_ID_SNOW_STORM
Func CanUse_SnowStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SnowStorm($a_f_AggroRange)
	; Description
	; Spell. Create a Snow Storm at target foe's location. For 5 seconds, foes adjacent to that location are struck for 30...40 cold damage each second.
	; Concise description
	; Spell. Deals 30...40 cold damage each second (5 seconds). Hits foes adjacent to target foe's initial location.
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 2224 - $GC_I_SKILL_ID_SUMMON_MURSAAT
Func CanUse_SummonMursaat()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5847, -2, 2500, "UAI_Filter_IsLivingAlly")

	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_SummonMursaat($a_f_AggroRange)
	; Description
	; Spell. Summon a level 14...20 Mursaat that lives for 40...60 seconds and has Enervating Charge. Only 1 Asura Summon can be active at a time.
	; Concise description
	; Spell. Summon a level 14...20 Mursaat (40...60 lifespan) that has Enervating Charge. Only 1 Asura Summon can be active a time.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2225 - $GC_I_SKILL_ID_SUMMON_RUBY_DJINN
Func CanUse_SummonRubyDjinn()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5848, -2, 2500, "UAI_Filter_IsLivingAlly")

	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_SummonRubyDjinn($a_f_AggroRange)
	; Description
	; Spell. Summon a level 14...20 Ruby Djinn that lives for 40...60 seconds and has Immolate. Only 1 Asura Summon can be active at a time.
	; Concise description
	; Spell. Summon a level 14...20 Ruby Djinn (40...60 lifespan) that has Immolate. Only 1 Asura Summon can be active a time.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2226 - $GC_I_SKILL_ID_SUMMON_ICE_IMP
Func CanUse_SummonIceImp()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5849, -2, 2500, "UAI_Filter_IsLivingAlly")

	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_SummonIceImp($a_f_AggroRange)
	; Description
	; Spell. Summon a level 14...20 Ice Imp that lives for 40...60 seconds and has Ice Spikes. Only 1 Asura Summon can be active a time.
	; Concise description
	; Spell. Summon a level 14...20 Ice Imp (40...60 lifespan) that has Ice Spikes. Only 1 Asura Summon can be active a time.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2227 - $GC_I_SKILL_ID_SUMMON_NAGA_SHAMAN
Func CanUse_SummonNagaShaman()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5850, -2, 2500, "UAI_Filter_IsLivingAlly")

	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_SummonNagaShaman($a_f_AggroRange)
	; Description
	; Spell. Summon a level 14...20 Naga Shaman that lives for 40...60 seconds and has Stoning. Only 1 Asura Summon can be active a time.
	; Concise description
	; Spell. Summon a level 14...20 Naga Shaman (40...60 lifespan) that has Stoning. Only 1 Asura Summon can be active a time.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2234 - $GC_I_SKILL_ID_EBON_VANGUARD_SNIPER_SUPPORT
Func CanUse_EbonVanguardSniperSupport()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EbonVanguardSniperSupport($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 54...90 piercing damage and begins Bleeding for 5...25 seconds. This attack has a 10% chance of doing an additional +540...900 piercing damage. If this attack hits a Charr it has a 25% chance of doing an additional +540...900 piercing damage.
	; Concise description
	; Spell. Deals 54...90 piercing damage and inflicts Bleeding condition (5...25 seconds). 10% chance of +540...900 piercing damage. 25% chance of +540...900 piercing damage if target foe is a Charr.
	Return 0
EndFunc

; Skill ID: 2235 - $GC_I_SKILL_ID_EBON_VANGUARD_ASSASSIN_SUPPORT
Func CanUse_EbonVanguardAssassinSupport()
	If Anti_Spell() Then Return False
	;5852
	Return True
EndFunc

Func BestTarget_EbonVanguardAssassinSupport($a_f_AggroRange)
	; Description
	; This article is about the Ebon Vanguard rank skill. For the skill used by Nola Sheppard, see Ebon Vanguard Assassin Support (NPC).
	; Concise description
	; green; font-weight: bold;">14...20

	; Priority 1: Monks hexed or conditioned
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk|UAI_Filter_IsHexedOrConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 2: Casters hexed or conditioned
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster|UAI_Filter_IsHexedOrConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 1: Monks
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 2: Casters
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Best single target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 2248 - $GC_I_SKILL_ID_POLYMOCK_POWER_DRAIN
Func CanUse_PolymockPowerDrain()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockPowerDrain($a_f_AggroRange)
	; Description
	; Spell. If target foe is casting a spell or glyph, that foe is interrupted and you gain 3 Energy.
	; Concise description
	; Spell. Interrupts a spell or glyph. Interruption effect: you gain 3 Energy.
	Return 0
EndFunc

; Skill ID: 2253 - $GC_I_SKILL_ID_POLYMOCK_OVERLOAD
Func CanUse_PolymockOverload()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockOverload($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 100 damage. If that foe was casting a spell, you deal +50 damage.
	; Concise description
	; Spell. Deals 100 damage. Deals 50 more damage if target foe was casting a spell.
	Return 0
EndFunc

; Skill ID: 2256 - $GC_I_SKILL_ID_ORDER_OF_UNHOLY_VIGOR
Func CanUse_OrderOfUnholyVigor()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfUnholyVigor($a_f_AggroRange)
	; Description
	; Spell. For 15 seconds, all of Zoldark's minions attack 33% faster.
	; Concise description
	; Spell. (15 seconds.) All Minions of Zoldark attack 33% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2257 - $GC_I_SKILL_ID_ORDER_OF_THE_LICH
Func CanUse_OrderOfTheLich()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfTheLich($a_f_AggroRange)
	; Description
	; Spell. For 15 seconds, all of Zoldark's minions have +3 Health regeneration and steal 15 Health each time they successfully hit with an attack.
	; Concise description
	; Spell. (15 seconds.) All Minions of Zoldark have +3 Health regeneration and steal 15 Health each time they hit with an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2258 - $GC_I_SKILL_ID_MASTER_OF_NECROMANCY
Func CanUse_MasterOfNecromancy()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MasterOfNecromancy($a_f_AggroRange)
	; Description
	; Spell. For 12 seconds, Zoldark has +10 armor and +5% maximum Health for each Minion of Zoldark that is currently alive.
	; Concise description
	; Spell. (12 seconds.) Zoldark gains +10 armor and +5% maximum Health for each Minion of Zoldark that is alive.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2259 - $GC_I_SKILL_ID_ANIMATE_UNDEAD
Func CanUse_AnimateUndead()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateUndead($a_f_AggroRange)
	; Description
	; Spell. All of Zoldark's minions are resurrected with 100% Health and 50% Energy.
	; Concise description
	; Spell. All Minions of Zoldark are resurrected with 100% Health and 50% Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2260 - $GC_I_SKILL_ID_POLYMOCK_DEATHLY_CHILL
Func CanUse_PolymockDeathlyChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockDeathlyChill($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 100 damage. If that foe is above 50% Health, you deal an additional 50 damage.
	; Concise description
	; Spell. Deals 100 damage. Deals 50 more damage if target foe's Health is above 50%.
	Return 0
EndFunc

; Skill ID: 2262 - $GC_I_SKILL_ID_POLYMOCK_ROTTING_FLESH
Func CanUse_PolymockRottingFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockRottingFlesh($a_f_AggroRange)
	; Description
	; Spell. Target foe becomes Diseased for 20 seconds and slowly loses Health.
	; Concise description
	; Spell. Inflicts Diseased condition (20 seconds). Disease causes -4 Health degeneration.
	Return 0
EndFunc

; Skill ID: 2263 - $GC_I_SKILL_ID_POLYMOCK_LIGHTNING_STRIKE
Func CanUse_PolymockLightningStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockLightningStrike($a_f_AggroRange)
	; Description
	; Spell. Strike target foe for 120 damage.
	; Concise description
	; Spell. Deals 120 damage.
	Return 0
EndFunc

; Skill ID: 2264 - $GC_I_SKILL_ID_POLYMOCK_LIGHTNING_ORB
Func CanUse_PolymockLightningOrb()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockLightningOrb($a_f_AggroRange)
	; Description
	; Spell. Send out a Lightning Orb that strikes target foe for 800 damage if it hits.
	; Concise description
	; Spell. Projectile: deals 800 damage.
	Return 0
EndFunc

; Skill ID: 2266 - $GC_I_SKILL_ID_POLYMOCK_FLARE
Func CanUse_PolymockFlare()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockFlare($a_f_AggroRange)
	; Description
	; Spell. Send out a Flare that strikes target foe for 120 damage if it hits.
	; Concise description
	; Spell. Projectile: deals 120 damage.
	Return 0
EndFunc

; Skill ID: 2267 - $GC_I_SKILL_ID_POLYMOCK_IMMOLATE
Func CanUse_PolymockImmolate()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockImmolate($a_f_AggroRange)
	; Description
	; Spell. Target foe is set on fire for 20 seconds.
	; Concise description
	; Spell. Inflicts Burning condition (20 seconds). Burning causes -7 Health degeneration.
	Return 0
EndFunc

; Skill ID: 2268 - $GC_I_SKILL_ID_POLYMOCK_METEOR
Func CanUse_PolymockMeteor()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockMeteor($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 600 damage. If that foe is casting a spell, that spell is interrupted.
	; Concise description
	; Spell. Deals 600 damage. Interrupts a spell.
	Return 0
EndFunc

; Skill ID: 2269 - $GC_I_SKILL_ID_POLYMOCK_ICE_SPEAR
Func CanUse_PolymockIceSpear()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockIceSpear($a_f_AggroRange)
	; Description
	; Spell. Send out an Ice Spear, striking target foe for 120 damage if it hits.
	; Concise description
	; Spell. Projectile: deals 120 damage.
	Return 0
EndFunc

; Skill ID: 2270 - $GC_I_SKILL_ID_POLYMOCK_ICY_PRISON
Func CanUse_PolymockIcyPrison()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockIcyPrison($a_f_AggroRange)
	; Description
	; Polymock skill
	; Concise description
	; disables interrupted spell (5 seconds).
	Return 0
EndFunc

; Skill ID: 2271 - $GC_I_SKILL_ID_POLYMOCK_MIND_FREEZE
Func CanUse_PolymockMindFreeze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockMindFreeze($a_f_AggroRange)
	; Description
	; Spell. Target foe suffers 400 damage. If you have more Energy than target foe, that foe suffers an additional 400 damage.
	; Concise description
	; Spell. Deals 400 damage. Deals 400 more damage if you have more Energy than target foe.
	Return 0
EndFunc

; Skill ID: 2272 - $GC_I_SKILL_ID_POLYMOCK_ICE_SHARD_STORM
Func CanUse_PolymockIceShardStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockIceShardStorm($a_f_AggroRange)
	; Description
	; Spell. Target foe begins Bleeding for 20 seconds.
	; Concise description
	; Spell. Inflicts Bleeding condition (20 seconds). Bleeding causes -3 Health degeneration.
	Return 0
EndFunc

; Skill ID: 2273 - $GC_I_SKILL_ID_POLYMOCK_FROZEN_TRIDENT
Func CanUse_PolymockFrozenTrident()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockFrozenTrident($a_f_AggroRange)
	; Description
	; Spell. Send out a fast-moving Frozen Trident that strikes target foe for 600 damage if it hits. If target foe is casting a spell, that spell is interrupted.
	; Concise description
	; Spell. Fast projectile: deals 600 damage. Interrupts a spell.
	Return 0
EndFunc

; Skill ID: 2274 - $GC_I_SKILL_ID_POLYMOCK_SMITE
Func CanUse_PolymockSmite()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSmite($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 120 damage.
	; Concise description
	; Spell. Deals 120 damage.
	Return 0
EndFunc

; Skill ID: 2275 - $GC_I_SKILL_ID_POLYMOCK_SMITE_HEX
Func CanUse_PolymockSmiteHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSmiteHex($a_f_AggroRange)
	; Description
	; Spell. Remove the last hex placed upon you. If a hex is removed, your enemy takes 400 damage.
	; Concise description
	; Spell. Remove the last hex placed upon you. Removal effect: deals 400 damage to your foe.
	Return 0
EndFunc

; Skill ID: 2277 - $GC_I_SKILL_ID_POLYMOCK_STONE_DAGGERS
Func CanUse_PolymockStoneDaggers()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockStoneDaggers($a_f_AggroRange)
	; Description
	; Spell. Send out two Stone Daggers. Each Stone Dagger strikes target foe for 60 damage if it hits.
	; Concise description
	; Spell. Two projectiles: deals 60 damage each.
	Return 0
EndFunc

; Skill ID: 2278 - $GC_I_SKILL_ID_POLYMOCK_OBSIDIAN_FLAME
Func CanUse_PolymockObsidianFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockObsidianFlame($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 800 damage.
	; Concise description
	; Spell. Deals 800 damage.
	Return 0
EndFunc

; Skill ID: 2279 - $GC_I_SKILL_ID_POLYMOCK_EARTHQUAKE
Func CanUse_PolymockEarthquake()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockEarthquake($a_f_AggroRange)
	; Description
	; Spell. You invoke an Earthquake at target foe's location. Target foe is struck for 650 damage. If that foe is casting a spell, that spell is interrupted.
	; Concise description
	; Spell. Interrupts a spell. Deals 650 damage.
	Return 0
EndFunc

; Skill ID: 2282 - $GC_I_SKILL_ID_POLYMOCK_FIREBALL
Func CanUse_PolymockFireball()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockFireball($a_f_AggroRange)
	; Description
	; Spell. Send out a ball of fire that strikes target foe for 800 damage if it hits.
	; Concise description
	; Spell. Projectile: deals 800 damage.
	Return 0
EndFunc

; Skill ID: 2283 - $GC_I_SKILL_ID_POLYMOCK_RODGORTS_INVOCATION
Func CanUse_PolymockRodgortsInvocation()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockRodgortsInvocation($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2288 - $GC_I_SKILL_ID_POLYMOCK_LAMENTATION
Func CanUse_PolymockLamentation()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockLamentation($a_f_AggroRange)
	; Description
	; Spell. Strike target foe for 120 damage.
	; Concise description
	; Spell. Deals 120 damage.
	Return 0
EndFunc

; Skill ID: 2289 - $GC_I_SKILL_ID_POLYMOCK_SPIRIT_RIFT
Func CanUse_PolymockSpiritRift()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSpiritRift($a_f_AggroRange)
	; Description
	; Spell. Open a Spirit Rift at target foe's location. After 3 seconds, that foe is struck for 850 damage.
	; Concise description
	; Spell. Open a Spirit Rift at target foe's location. Deals 850 damage after 3 seconds.
	Return 0
EndFunc

; Skill ID: 2293 - $GC_I_SKILL_ID_POLYMOCK_GLOWING_GAZE
Func CanUse_PolymockGlowingGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockGlowingGaze($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 150 damage. If that foe is on fire, you gain 6 Energy.
	; Concise description
	; Spell. Deals 150 damage. You gain 6 Energy if target foe is Burning.
	Return 0
EndFunc

; Skill ID: 2294 - $GC_I_SKILL_ID_POLYMOCK_SEARING_FLAMES
Func CanUse_PolymockSearingFlames()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSearingFlames($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck with Searing Flames. If that foe is already on fire, that foe takes 800 damage. Otherwise, that foe begins Burning for 5 seconds.
	; Concise description
	; Spell. Deals 800 damage if target foe is Burning. Otherwise, that foe begins Burning (5 seconds). Burning causes -7 Health degeneration.
	Return 0
EndFunc

; Skill ID: 2297 - $GC_I_SKILL_ID_POLYMOCK_STONING
Func CanUse_PolymockStoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockStoning($a_f_AggroRange)
	; Description
	; Spell. Send out a large stone, striking target foe for 800 damage if it hits.
	; Concise description
	; Spell. Projectile: 800 damage.
	Return 0
EndFunc

; Skill ID: 2298 - $GC_I_SKILL_ID_POLYMOCK_ERUPTION
Func CanUse_PolymockEruption()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockEruption($a_f_AggroRange)
	; Description
	; Spell. Cause an eruption at target foe's location. Target foe takes 400 damage and all of that foe's glyphs are disabled for 15 seconds.
	; Concise description
	; Spell. Deals 400 damage and disables all of target foe's glyphs (15 seconds).
	Return 0
EndFunc

; Skill ID: 2299 - $GC_I_SKILL_ID_POLYMOCK_SHOCK_ARROW
Func CanUse_PolymockShockArrow()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockShockArrow($a_f_AggroRange)
	; Description
	; Spell. Send out a Shock Arrow that flies swiftly toward target foe, striking for 150 damage if it hits. If target foe is using a glyph, that foe takes 200 additional damage.
	; Concise description
	; Spell. Fast projectile: deals 150 damage. Deals 200 more damage if target foe is using a glyph.
	Return 0
EndFunc

; Skill ID: 2300 - $GC_I_SKILL_ID_POLYMOCK_MIND_SHOCK
Func CanUse_PolymockMindShock()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockMindShock($a_f_AggroRange)
	; Description
	; Spell. Target foe suffers 400 damage. If you have more Energy than target foe, that foe suffers an additional 400 damage.
	; Concise description
	; Spell. Deals 400 damage. Deals 400 more damage if you have more Energy than target foe.
	Return 0
EndFunc

; Skill ID: 2301 - $GC_I_SKILL_ID_POLYMOCK_PIERCING_LIGHT_SPEAR
Func CanUse_PolymockPiercingLightSpear()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockPiercingLightSpear($a_f_AggroRange)
	; Description
	; Spell. A Piercing Light Spear flies toward target foe and causes Bleeding for 20 seconds if it hits.
	; Concise description
	; Spell. Projectile: inflicts Bleeding condition (20 seconds). Bleeding causes -3 Health degeneration.
	Return 0
EndFunc

; Skill ID: 2302 - $GC_I_SKILL_ID_POLYMOCK_MIND_BLAST
Func CanUse_PolymockMindBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockMindBlast($a_f_AggroRange)
	; Description
	; Spell. Target foe suffers 300 damage. If you have less Energy than target foe, you gain 8 Energy.
	; Concise description
	; Spell. Deals 300 damage. Gain 8 Energy if you have less Energy than target foe.
	Return 0
EndFunc

; Skill ID: 2303 - $GC_I_SKILL_ID_POLYMOCK_SAVANNAH_HEAT
Func CanUse_PolymockSavannahHeat()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSavannahHeat($a_f_AggroRange)
	; Description
	; Spell. You create Savannah Heat at target foe's location. For 5 seconds, that foe takes 100 damage each second and an additional 50 damage for each second this spell has been in effect.
	; Concise description
	; Spell. Deals 100 damage each second (5 seconds) at target foe's location. Deals 50 more damage for each second since casting this spell.
	Return 0
EndFunc

; Skill ID: 2305 - $GC_I_SKILL_ID_POLYMOCK_LIGHTNING_BLAST
Func CanUse_PolymockLightningBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockLightningBlast($a_f_AggroRange)
	; Description
	; Spell. Target foe is struck for 800 damage.
	; Concise description
	; Spell. Deals 800 damage.
	Return 0
EndFunc

; Skill ID: 2306 - $GC_I_SKILL_ID_POLYMOCK_POISONED_GROUND
Func CanUse_PolymockPoisonedGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockPoisonedGround($a_f_AggroRange)
	; Description
	; Spell. Target foe becomes Poisoned for 20 seconds.
	; Concise description
	; Spell. Inflicts Poisoned condition (20 seconds). Poison causes -4 Health degeneration.
	Return 0
EndFunc

; Skill ID: 2308 - $GC_I_SKILL_ID_POLYMOCK_SANDSTORM
Func CanUse_PolymockSandstorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSandstorm($a_f_AggroRange)
	; Description
	; Spell. Create a Sandstorm at target foe's location. For 10 seconds, target foe is struck for 40 damage each second. If that foe is casting a spell, that foe takes an additional 20 damage each second.
	; Concise description
	; Spell. Deals 40 damage each second at target foe's location (10 seconds). Deals 20 more damage each second if that foe is casting a spell.
	Return 0
EndFunc

; Skill ID: 2309 - $GC_I_SKILL_ID_POLYMOCK_BANISH
Func CanUse_PolymockBanish()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockBanish($a_f_AggroRange)
	; Description
	; Spell. Target foe takes 800 damage.
	; Concise description
	; Spell. Deals 800 damage.
	Return 0
EndFunc

; Skill ID: 2368 - $GC_I_SKILL_ID_MURAKAIS_CONSUMPTION
Func CanUse_MurakaisConsumption()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MurakaisConsumption($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2369 - $GC_I_SKILL_ID_MURAKAIS_CENSURE
Func CanUse_MurakaisCensure()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MurakaisCensure($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2370 - $GC_I_SKILL_ID_MURAKAIS_CALAMITY
Func CanUse_MurakaisCalamity()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MurakaisCalamity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2371 - $GC_I_SKILL_ID_MURAKAIS_STORM_OF_SOULS
Func CanUse_MurakaisStormOfSouls()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MurakaisStormOfSouls($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2386 - $GC_I_SKILL_ID_RAVEN_SWOOP
Func CanUse_RavenSwoop()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RavenSwoop($a_f_AggroRange)
	; Description
	; Spell. Strike target foe and all adjacent foes for 60...100 damage.
	; Concise description
	; Spell. Deals 60...100 damage. Also hits adjacent foes.
	Return 0
EndFunc

; Skill ID: 2390 - $GC_I_SKILL_ID_FILTHY_EXPLOSION
Func CanUse_FilthyExplosion()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FilthyExplosion($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Filthy_Explosion","wgRelevantArticleId":282763,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2391 - $GC_I_SKILL_ID_MURAKAIS_CALL
Func CanUse_MurakaisCall()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MurakaisCall($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2398 - $GC_I_SKILL_ID_CONSUME_FLAMES
Func CanUse_ConsumeFlames()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ConsumeFlames($a_f_AggroRange)
	; Description
	; This article is about the skill used by Arctic Nightmares during Flames of the Bear Spirit.&#32;&#32;For the skill used by Flame Djinn, see Consuming Flames.
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2412 - $GC_I_SKILL_ID_SMOOTH_CRIMINAL
Func CanUse_SmoothCriminal()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SmoothCriminal($a_f_AggroRange)
	; Description
	; Spell. For 10...20 seconds, one random spell is disabled for target foe and Smooth Criminal is replaced by that spell. You gain 5...10 Energy.
	; Concise description
	; Spell. (10...20 seconds.) Disables one Spell. This skill becomes that Spell. You gain 5...10 Energy.
	Return 0
EndFunc

; Skill ID: 2413 - $GC_I_SKILL_ID_TECHNOBABBLE
Func CanUse_Technobabble()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Technobabble($a_f_AggroRange)
	; Description
	; Spell. Target foe and all adjacent foes are struck for 30...40 damage. If target foe is not a boss, that foe and all adjacent foes are Dazed for 3...5 seconds.
	; Concise description
	; Spell. Deals 30...40 damage to target and adjacent foes. Inflicts Dazed condition (3...5 seconds) on these foes if target was not a boss.
	Return 0
EndFunc

; Skill ID: 2420 - $GC_I_SKILL_ID_EBON_ESCAPE
Func CanUse_EbonEscape()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EbonEscape($a_f_AggroRange)
	; Description
	; Spell. Shadow Step to target other ally. You and that other ally are healed for 70...110 health.
	; Concise description
	; Spell. Heals you and target ally for 70...110. Initial effect: Shadow Step to this ally. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 2487 - $GC_I_SKILL_ID_DRYDERS_FEAST
Func CanUse_DrydersFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DrydersFeast($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2517 - $GC_I_SKILL_ID_REVERSE_POLARITY_FIRE_SHIELD
Func CanUse_ReversePolarityFireShield()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ReversePolarityFireShield($a_f_AggroRange)
	; Description
	; Spell. Living creatures standing within this shield have -50 armor against fire damage.
	; Concise description
	; Spell. Living creatures in the shield have -50 armor against fire damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2538 - $GC_I_SKILL_ID_ANIMATE_UNDEAD_PALAWA_JOKO
Func CanUse_AnimateUndeadPalawaJoko()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateUndeadPalawaJoko($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2539 - $GC_I_SKILL_ID_ORDER_OF_UNHOLY_VIGOR_PALAWA_JOKO
Func CanUse_OrderOfUnholyVigorPalawaJoko()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfUnholyVigorPalawaJoko($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2540 - $GC_I_SKILL_ID_ORDER_OF_THE_LICH_PALAWA_JOKO
Func CanUse_OrderOfTheLichPalawaJoko()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfTheLichPalawaJoko($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2543 - $GC_I_SKILL_ID_WURM_SIEGE_EYE_OF_THE_NORTH
Func CanUse_WurmSiegeEyeOfTheNorth()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WurmSiegeEyeOfTheNorth($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2626 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2628 - $GC_I_SKILL_ID_ENFEEBLE2
Func CanUse_Enfeeble2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Enfeeble2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2629 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2632 - $GC_I_SKILL_ID_SEARING_FLAMES2
Func CanUse_SearingFlames2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SearingFlames2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2633 - $GC_I_SKILL_ID_GLOWING_GAZE2
Func CanUse_GlowingGaze2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GlowingGaze2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2634 - $GC_I_SKILL_ID_STEAM2
Func CanUse_Steam2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Steam2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2636 - $GC_I_SKILL_ID_LIQUID_FLAM2
Func CanUse_LiquidFlam2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LiquidFlam2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2637 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2639 - $GC_I_SKILL_ID_SMITE_CONDITION2
Func CanUse_SmiteCondition2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SmiteCondition2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2664 - $GC_I_SKILL_ID_SPIKE_TRAP_SPELL
Func CanUse_SpikeTrapSpell()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpikeTrapSpell($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2666 - $GC_I_SKILL_ID_FIRE_AND_BRIMSTONE
Func CanUse_FireAndBrimstone()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FireAndBrimstone($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Fire_and_Brimstone","wgRelevantArticleId":230825,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return 0
EndFunc

; Skill ID: 2686 - $GC_I_SKILL_ID_ESSENCE_STRIKE_TOGO
Func CanUse_EssenceStrikeTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EssenceStrikeTogo($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2687 - $GC_I_SKILL_ID_SPIRIT_BURN_TOGO
Func CanUse_SpiritBurnTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritBurnTogo($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2688 - $GC_I_SKILL_ID_SPIRIT_RIFT_TOGO
Func CanUse_SpiritRiftTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritRiftTogo($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2689 - $GC_I_SKILL_ID_MEND_BODY_AND_SOUL_TOGO
Func CanUse_MendBodyAndSoulTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MendBodyAndSoulTogo($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2690 - $GC_I_SKILL_ID_OFFERING_OF_SPIRIT_TOGO
Func CanUse_OfferingOfSpiritTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_OfferingOfSpiritTogo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2722 - $GC_I_SKILL_ID_REDEMPTION_OF_PURITY
Func CanUse_RedemptionOfPurity()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RedemptionOfPurity($a_f_AggroRange)
	; Description
	; Spell. Destroy target minion. That minion is replaced with a level 12 Spirit of Pain. This Spirit deals 30 damage. This Spirit dies after 150 seconds.
	; Concise description
	; Spell. Target minion is destroyed and replaced with a level 12 Spirit of Pain. This spirit deals 30 damage and dies after 150 seconds.
	Return 0
EndFunc

; Skill ID: 2723 - $GC_I_SKILL_ID_PURIFY_ENERGY
Func CanUse_PurifyEnergy()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PurifyEnergy($a_f_AggroRange)
	; Description
	; Spell. Remove an enchantment from all nearby foes. If enchantments are removed, you steal 1 Energy from each foe who loses an enchantment.
	; Concise description
	; Spell. Remove an enchantment from all nearby foes. Steal 1 energy from foes who lose an enchantment.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2724 - $GC_I_SKILL_ID_PURIFYING_FLAME
Func CanUse_PurifyingFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PurifyingFlame($a_f_AggroRange)
	; Description
	; Spell. Create a Purifying Flame at your location. For 5 seconds, this flame deals 10...10...10 damage to foes in the area. When Purifying Flame ends, foes in the area lose 1 enchantment, and allies in the area lose 1 hex.
	; Concise description
	; Spell. Create a Purifying Flame at your location. Deals 10...10...10 damage to foes in the area (5 seconds). When Purifying Flame ends, foes in the area lose 1 enchantment, and allies in the area lose 1 hex.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2725 - $GC_I_SKILL_ID_PURIFYING_PRAYER
Func CanUse_PurifyingPrayer()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PurifyingPrayer($a_f_AggroRange)
	; Description
	; Spell. Removes 2...4...4 hexes and 2...4...4 conditions from target ally. For each hex removed, 1 foe near target ally loses an enchantment.
	; Concise description
	; Spell. Removes 2...4...4 hexes and 2...4...4 conditions from target ally. For each hex removed, 1 foe near target ally loses an enchantment.
	Return 0
EndFunc

; Skill ID: 2729 - $GC_I_SKILL_ID_PURIFY_SOUL
Func CanUse_PurifySoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PurifySoul($a_f_AggroRange)
	; Description
	; Spell. All friendly spirits within earshot gain +1 health regeneration for 3 seconds. All enemy spirits within earshot begin burning for 3 seconds.
	; Concise description
	; Spell. All friendly spirits within earshot gain +1 health regeneration for 3 seconds. All enemy spirits within earshot burn for 3 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2755 - $GC_I_SKILL_ID_JADE_BROTHERHOOD_BOMB
Func CanUse_JadeBrotherhoodBomb()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_JadeBrotherhoodBomb($a_f_AggroRange)
	; Description
	; Spell. Self destruct, dealing 750 damage to adjacent foes, 500 damage to nearby foes and 250 damage to foes in the area
	; Concise description
	; Spell. Self destruct, dealing 750 damage to adjacent foes, 500 damage to nearby foes and 250 damage to foes in the area
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2759 - $GC_I_SKILL_ID_ROCKET_PROPELLED_GOBSTOPPER
Func CanUse_RocketPropelledGobstopper()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RocketPropelledGobstopper($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2760 - $GC_I_SKILL_ID_RAIN_OF_TERROR_SPELL
Func CanUse_RainOfTerrorSpell()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RainOfTerrorSpell($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2762 - $GC_I_SKILL_ID_SUGAR_INFUSION
Func CanUse_SugarInfusion()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SugarInfusion($a_f_AggroRange)
	; Description
	; Spell. Sacrifice 25% of your current Health. Target other ally is healed for 150% of the amount you lost. If this targets Mad King Thorn, this spell heals for 200% the amount you lost.
	; Concise description
	; Spell. Heal target ally for 150% of your Health sacrifice. If targeting Mad King Thorn, heal for 200% of your Health sacrifice. You lose a quarter of your current health. Cannot Self Target.
	Return 0
EndFunc

; Skill ID: 2763 - $GC_I_SKILL_ID_FEAST_OF_VENGEANCE
Func CanUse_FeastOfVengeance()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FeastOfVengeance($a_f_AggroRange)
	; Description
	; Spell. Steal 150 Health from target foe.
	; Concise description
	; Spell. You steal 150 Health from target foe.
	Return 0
EndFunc

; Skill ID: 2764 - $GC_I_SKILL_ID_ANIMATE_CANDY_MINIONS
Func CanUse_AnimateCandyMinions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnimateCandyMinions($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; #808080;">Requires a fresh corpse. You can have only 6 Candy Minions at a time.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2765 - $GC_I_SKILL_ID_TASTE_OF_UNDEATH
Func CanUse_TasteOfUndeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TasteOfUndeath($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Related skills">edit
	Return 0
EndFunc

; Skill ID: 2766 - $GC_I_SKILL_ID_SCOURGE_OF_CANDY
Func CanUse_ScourgeOfCandy()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ScourgeOfCandy($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Related skills">edit
	Return 0
EndFunc

; Skill ID: 2768 - $GC_I_SKILL_ID_MAD_KING_PONY_SUPPORT
Func CanUse_MadKingPonySupport()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MadKingPonySupport($a_f_AggroRange)
	; Description
	; Elite Spell. Summon a level 20 Invisible Pony. This summoned pony prances to target foe. This pony lasts 60 seconds.
	; Concise description
	; Elite Spell. Summon a level 20 Invisible Pony. This summoned pony prances to target foe. This pony lasts 60 seconds.
	Return 0
EndFunc

; Skill ID: 2789 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2790 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2795 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2796 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2799 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2804 - $GC_I_SKILL_ID_MIND_SHOCK_PVP
Func CanUse_MindShockPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MindShockPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2807 - $GC_I_SKILL_ID_RIDE_THE_LIGHTNING_PVP
Func CanUse_RideTheLightningPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_RideTheLightningPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2809 - $GC_I_SKILL_ID_OBSIDIAN_FLAME_PVP
Func CanUse_ObsidianFlamePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ObsidianFlamePvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2833 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2835 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2836 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2852 - $GC_I_SKILL_ID_ENERGY_DRAIN_PVP
Func CanUse_EnergyDrainPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnergyDrainPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2853 - $GC_I_SKILL_ID_ENERGY_TAP_PVP
Func CanUse_EnergyTapPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnergyTapPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2856 - $GC_I_SKILL_ID_LIGHTNING_ORB_PVP
Func CanUse_LightningOrbPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningOrbPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2859 - $GC_I_SKILL_ID_ENFEEBLE_PVP
Func CanUse_EnfeeblePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnfeeblePvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2863 - $GC_I_SKILL_ID_DISCORD_PVP
Func CanUse_DiscordPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DiscordPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2866 - $GC_I_SKILL_ID_FLESH_OF_MY_FLESH_PVP
Func CanUse_FleshOfMyFleshPvp()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_FleshOfMyFleshPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2870 - $GC_I_SKILL_ID_BLINDING_SURGE_PVP
Func CanUse_BlindingSurgePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BlindingSurgePvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2871 - $GC_I_SKILL_ID_LIGHT_OF_DELIVERANCE_PVP
Func CanUse_LightOfDeliverancePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightOfDeliverancePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2881 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2885 - $GC_I_SKILL_ID_ENFEEBLING_BLOOD_PVP
Func CanUse_EnfeeblingBloodPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EnfeeblingBloodPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2902 - $GC_I_SKILL_ID_REACTOR_BLAST
Func CanUse_ReactorBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ReactorBlast($a_f_AggroRange)
	; Description
	; Spell. P.O.X. sets off an explosion, striking everything in the area for 200 damage and causing knockdown and Burning for 10 seconds.
	; Concise description
	; Spell. P.O.X sets off explosion in the area which deals 200 damage, causes knock down, and inflicts Burning (10 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2907 - $GC_I_SKILL_ID_NOX_BEAM
Func CanUse_NoxBeam()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NoxBeam($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2909 - $GC_I_SKILL_ID_NOXION_BUSTER
Func CanUse_NoxionBuster()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NoxionBuster($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2911 - $GC_I_SKILL_ID_BIT_GOLEM_BREAKER
Func CanUse_BitGolemBreaker()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BitGolemBreaker($a_f_AggroRange)
	; Description
	; Spell. Launch a projectile that strikes target foe for 30 damage and inflicts a random condition for 15 seconds.
	; Concise description
	; Spell. Projectile: 30 damage and inflicts a random condition (15 seconds).
	Return 0
EndFunc

; Skill ID: 2913 - $GC_I_SKILL_ID_BIT_GOLEM_CRASH
Func CanUse_BitGolemCrash()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BitGolemCrash($a_f_AggroRange)
	; Description
	; Spell. All foes near the impact area suffer 250 damage and are knocked down.
	; Concise description
	; Spell. Deals 250 damage to all foes near the impact area and causes knockdown.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2914 - $GC_I_SKILL_ID_BIT_GOLEM_FORCE
Func CanUse_BitGolemForce()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_BitGolemForce($a_f_AggroRange)
	; Description
	; Spell. All adjacent foes are struck for 150 damage.
	; Concise description
	; Spell. Deals 150 damage to all adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2917 - $GC_I_SKILL_ID_NOX_THUNDER
Func CanUse_NoxThunder()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NoxThunder($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2920 - $GC_I_SKILL_ID_NOX_FIRE
Func CanUse_NoxFire()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NoxFire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2921 - $GC_I_SKILL_ID_NOX_KNUCKLE
Func CanUse_NoxKnuckle()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NoxKnuckle($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2922 - $GC_I_SKILL_ID_NOX_DIVIDER_DRIVE
Func CanUse_NoxDividerDrive()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_NoxDividerDrive($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2927 - $GC_I_SKILL_ID_SHRINE_BACKLASH
Func CanUse_ShrineBacklash()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShrineBacklash($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2935 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2938 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2939 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2940 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2941 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2946 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2952 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2957 - $GC_I_SKILL_ID_WESTERN_HEALTH_SHRINE_BONUS
Func CanUse_WesternHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_WesternHealthShrineBonus($a_f_AggroRange)
	; Description
	; Spell. Your party members' maximum Health is increased by 120.
	; Concise description
	; Spell. Your party members have +120 maximum Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2958 - $GC_I_SKILL_ID_EASTERN_HEALTH_SHRINE_BONUS
Func CanUse_EasternHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EasternHealthShrineBonus($a_f_AggroRange)
	; Description
	; Spell. Your party members' maximum Health is increased by 120.
	; Concise description
	; Spell. Your party members have +120 maximum Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2964 - $GC_I_SKILL_ID_SNOWBALL2
Func CanUse_Snowball2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Snowball2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3021 - $GC_I_SKILL_ID_SAVANNAH_HEAT_PVP
Func CanUse_SavannahHeatPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SavannahHeatPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3044 - $GC_I_SKILL_ID_SPIRIT_SIPHON_MASTER_RIYO
Func CanUse_SpiritSiphonMasterRiyo()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritSiphonMasterRiyo($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3058 - $GC_I_SKILL_ID_UNHOLY_FEAST_PVP
Func CanUse_UnholyFeastPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UnholyFeastPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3076 - $GC_I_SKILL_ID_EVERLASTING_MOBSTOPPER_SKILL
Func CanUse_EverlastingMobstopperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EverlastingMobstopperSkill($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3078 - $GC_I_SKILL_ID_CURSE_OF_DHUUM
Func CanUse_CurseOfDhuum()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_CurseOfDhuum($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Curse_of_Dhuum","wgRelevantArticleId":228612,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3079 - $GC_I_SKILL_ID_DHUUMS_REST_REAPER_SKILL
Func CanUse_DhuumsRestReaperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DhuumsRestReaperSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3081 - $GC_I_SKILL_ID_SUMMON_CHAMPION
Func CanUse_SummonChampion()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SummonChampion($a_f_AggroRange)
	; Description
	; Spell. Summon a Champion of Dhuum.
	; Concise description
	; Spell. Summon a Champion of Dhuum.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3082 - $GC_I_SKILL_ID_SUMMON_MINIONS
Func CanUse_SummonMinions()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SummonMinions($a_f_AggroRange)
	; Description
	; Spell. Summon Minions of Dhuum.
	; Concise description
	; Spell. Summon Minions of Dhuum.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3085 - $GC_I_SKILL_ID_JUDGMENT_OF_DHUUM
Func CanUse_JudgmentOfDhuum()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_JudgmentOfDhuum($a_f_AggroRange)
	; Description
	; Spell. For 4 seconds, Dhuum deals 75 damage each second to foes in spirit range.
	; Concise description
	; Spell. For 4 seconds, Dhuum deals 75 damage each second to foes in spirit range.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3087 - $GC_I_SKILL_ID_DHUUMS_REST
Func CanUse_DhuumsRest()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DhuumsRest($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3088 - $GC_I_SKILL_ID_SPIRITUAL_HEALING
Func CanUse_SpiritualHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritualHealing($a_f_AggroRange)
	; Description
	; Spell. Heal target other ally for 250 Health.
	; Concise description
	; Spell. Heals for 250 Health. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 3089 - $GC_I_SKILL_ID_ENCASE_SKELETAL
Func CanUse_EncaseSkeletal()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EncaseSkeletal($a_f_AggroRange)
	; Description
	; Spirit Form skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Encase_Skeletal","wgRelevantArticleId":228642,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return 0
EndFunc

; Skill ID: 3090 - $GC_I_SKILL_ID_REVERSAL_OF_DEATH
Func CanUse_ReversalOfDeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ReversalOfDeath($a_f_AggroRange)
	; Description
	; Spell. Remove 5% Death Penalty from target other ally.
	; Concise description
	; Spell. Remove 5% Death Penalty. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 3091 - $GC_I_SKILL_ID_GHOSTLY_FURY
Func CanUse_GhostlyFury()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GhostlyFury($a_f_AggroRange)
	; Description
	; Spirit Form skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Ghostly_Fury","wgRelevantArticleId":228646,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return 0
EndFunc

; Skill ID: 3135 - $GC_I_SKILL_ID_SPIRITUAL_HEALING_REAPER_SKILL
Func CanUse_SpiritualHealingReaperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritualHealingReaperSkill($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3136 - $GC_I_SKILL_ID_GHOSTLY_FURY_REAPER_SKILL
Func CanUse_GhostlyFuryReaperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GhostlyFuryReaperSkill($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3165 - $GC_I_SKILL_ID_GOLEM_PILEBUNKER
Func CanUse_GolemPilebunker()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_GolemPilebunker($a_f_AggroRange)
	; Description
	; Spell
	; Concise description
	; 20251201191736 Cache expiry: 86400 Reduced expiry: false Complications: [] CPU time usage: 0.015 seconds Real time usage: 0.023 seconds Preprocessor visited node count: 285/1000000 Post‐expand include size: 1904/2097152 bytes Template argument size: 618/2097152 bytes Highest expansion depth: 7/100 Expensive parser function count: 0/100 Unstrip recursion depth: 0/20 Unstrip post‐expand size: 0/5000000 bytes ExtLoops count: 0/1000 -->
	Return 0
EndFunc

; Skill ID: 3167 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3168 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3169 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3170 - $GC_I_SKILL_ID_KOROS_GAZE
Func CanUse_KorosGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_KorosGaze($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3171 - $GC_I_SKILL_ID_EBON_VANGUARD_ASSASSIN_SUPPORT_NPC
Func CanUse_EbonVanguardAssassinSupportNpc()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_EbonVanguardAssassinSupportNpc($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3180 - $GC_I_SKILL_ID_SHATTER_DELUSIONS_PVP
Func CanUse_ShatterDelusionsPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ShatterDelusionsPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3184 - $GC_I_SKILL_ID_ACCUMULATED_PAIN_PVP
Func CanUse_AccumulatedPainPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AccumulatedPainPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3185 - $GC_I_SKILL_ID_PSYCHIC_INSTABILITY_PVP
Func CanUse_PsychicInstabilityPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PsychicInstabilityPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3189 - $GC_I_SKILL_ID_SPIRITUAL_PAIN_PVP
Func CanUse_SpiritualPainPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritualPainPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3194 - $GC_I_SKILL_ID_MIRROR_OF_DISENCHANTMENT_PVP
Func CanUse_MirrorOfDisenchantmentPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MirrorOfDisenchantmentPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3197 - $GC_I_SKILL_ID_ADORATION
Func CanUse_Adoration()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Adoration($a_f_AggroRange)
	; Description
	; Spell. Heal target ally 75 Health, and give them a 1% morale boost.
	; Concise description
	; Spell. Heals for 75. Grants a 1% morale boost.
	Return 0
EndFunc

; Skill ID: 3232 - $GC_I_SKILL_ID_HEAL_PARTY_PVP
Func CanUse_HealPartyPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_HealPartyPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3242 - $GC_I_SKILL_ID_COMING_OF_SPRING
Func CanUse_ComingOfSpring()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ComingOfSpring($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3245 - $GC_I_SKILL_ID_DEATHS_EMBRACE
Func CanUse_DeathsEmbrace()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_DeathsEmbrace($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3253 - $GC_I_SKILL_ID_ULTRA_SNOWBALL
Func CanUse_UltraSnowball()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UltraSnowball($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; deals 100 damage. You gain 1 strike of adrenaline.
	Return 0
EndFunc

; Skill ID: 3254 - $GC_I_SKILL_ID_BLIZZARD
Func CanUse_Blizzard()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_Blizzard($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Notes">edit
	Return 0
EndFunc

; Skill ID: 3259 - $GC_I_SKILL_ID_ULTRA_SNOWBALL2
Func CanUse_UltraSnowball2()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UltraSnowball2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3260 - $GC_I_SKILL_ID_ULTRA_SNOWBALL3
Func CanUse_UltraSnowball3()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UltraSnowball3($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3261 - $GC_I_SKILL_ID_ULTRA_SNOWBALL4
Func CanUse_UltraSnowball4()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UltraSnowball4($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3262 - $GC_I_SKILL_ID_ULTRA_SNOWBALL5
Func CanUse_UltraSnowball5()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_UltraSnowball5($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3272 - $GC_I_SKILL_ID_MYSTIC_HEALING_PVP
Func CanUse_MysticHealingPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MysticHealingPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3290 - $GC_I_SKILL_ID_STUN_GRENADE
Func CanUse_StunGrenade()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_StunGrenade($a_f_AggroRange)
	; Description
	; Spell. Deals 50 Blunt damage to target and adjacent foes. Target and foes in the area are Dazed for 5 seconds and Blinded for 10 seconds.
	; Concise description
	; Spell. Target and adjacent foes take 50 Blunt damage. Target and foes in the area are Dazed (5 seconds) and Blinded (10 seconds).
	Return 0
EndFunc

; Skill ID: 3291 - $GC_I_SKILL_ID_FRAGMENTATION_GRENADE
Func CanUse_FragmentationGrenade()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_FragmentationGrenade($a_f_AggroRange)
	; Description
	; Spell. Target and adjacent foes take 300 Piercing damage and begin bleeding for 15 seconds. Nearby foes are struck for 200 damage and begin bleeding for 10 seconds. All other foes in the area are struck for 100 damage and begin bleeding for 5 seconds.
	; Concise description
	; Spell. Deals 300 Piercing damage and applies Bleeding (15 seconds) to target and adjacent foes. Deals 200 Piercing damage and applies Bleeding (10 seconds) to nearby foes. Deals 100 Piercing damage and applies Bleeding (5 seconds) to other foes in the area.
	Return 0
EndFunc

; Skill ID: 3292 - $GC_I_SKILL_ID_TEAR_GAS
Func CanUse_TearGas()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_TearGas($a_f_AggroRange)
	; Description
	; Spell. Your Tear Gas explodes at target foe's location, striking adjacent foes for 50 fire damage and creating a Smoke Screen for 10 seconds. Foes inside the Smoke Screen suffer from Poison for 10 seconds and cannot cast spells.
	; Concise description
	; Spell. Deals 50 fire damage to target and adjacent foes. Creates a Smoke Screen (10 seconds) that applies poison (10 seconds) and prevents spellcasting.
	Return 0
EndFunc

; Skill ID: 3299 - $GC_I_SKILL_ID_PHASED_PLASMA_BURST
Func CanUse_PhasedPlasmaBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PhasedPlasmaBurst($a_f_AggroRange)
	; Description
	; Spell. Fires a projectile at target enemy. If this projectile hits, target foe takes 100 damage. Nearby foes take 50 damage.
	; Concise description
	; Spell. Projectile. Target foe takes 100 damage. Nearby foes takes 50 damage.
	Return 0
EndFunc

; Skill ID: 3300 - $GC_I_SKILL_ID_PLASMA_SHOT
Func CanUse_PlasmaShot()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PlasmaShot($a_f_AggroRange)
	; Description
	; Spell. Fires a projectile at target enemy. If this projectile hits, target foe takes 75 damage.
	; Concise description
	; Spell. Projectile. Target foe takes 75 damage.
	Return 0
EndFunc

; Skill ID: 3371 - $GC_I_SKILL_ID_MIRROR_SHATTER
Func CanUse_MirrorShatter()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_MirrorShatter($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3378 - $GC_I_SKILL_ID_PHASE_SHIELD
Func CanUse_PhaseShield()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_PhaseShield($a_f_AggroRange)
	; Description
	; This article is about the player skill. For the skill used by G.O.L.E.M. 2.0, see Phase Shield (monster skill).
	; Concise description
	; Acquisition">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3379 - $GC_I_SKILL_ID_REACTOR_BURST
Func CanUse_ReactorBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_ReactorBurst($a_f_AggroRange)
	; Description
	; Spell. Overload your reactor, removing a condition from yourself and dealing 150 damage to all adjacent foes. Foes struck by Reactor Burst are interrupted and set on fire for 3 seconds.
	; Concise description
	; Spell. Removes a condition. Deals 150 damage to adjacent foes and sets them on fire (3 seconds). Interrupts struck foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3382 - $GC_I_SKILL_ID_ANNIHILATOR_BEAM
Func CanUse_AnnihilatorBeam()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_AnnihilatorBeam($a_f_AggroRange)
	; Description
	; Spell. Send out a beam that strikes all targets in a line for 300 damage.
	; Concise description
	; Spell. Deals 300 damage to all targets in a line.
	Return 0
EndFunc

; Skill ID: 3396 - $GC_I_SKILL_ID_LIGHTNING_HAMMER_PVP
Func CanUse_LightningHammerPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_LightningHammerPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3398 - $GC_I_SKILL_ID_SLIPPERY_GROUND_PVP
Func CanUse_SlipperyGroundPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc

Func BestTarget_SlipperyGroundPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3411 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3412 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3413 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3414 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3415 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3416 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3420 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3421 - ;  $GC_I_SKILL_ID_UNKNOWN
