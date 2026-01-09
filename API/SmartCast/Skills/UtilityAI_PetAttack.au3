#include-once

Func Anti_PetAttack()
	; Check if player has a pet
	Local $l_i_PetAgentID = Party_GetPetInfo(1, "AgentID")
	If $l_i_PetAgentID = 0 Then Return True

	; Check if pet belongs to player
	Local $l_i_OwnerID = Party_GetPetInfo(1, "OwnerAgentID")
	If $l_i_OwnerID <> Agent_GetAgentInfo(-2, "ID") Then Return True

	; Check if pet is alive
	Local $l_f_PetHP = Agent_GetAgentInfo($l_i_PetAgentID, "HP")
	If $l_f_PetHP <= 0 Then Return True

	; Check if pet is blinded
	Return UAI_AgentHasVisibleEffect($l_i_PetAgentID, $GC_I_EFFECT_TYPE_STATUS, $GC_I_EFFECT_ID_BLINDED)
EndFunc

; Skill ID: 437 - $GC_I_SKILL_ID_BESTIAL_POUNCE
Func CanUse_BestialPounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_BestialPounce($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Bestial Pounce that deals +5...17...20 damage. If the attack strikes a foe who is casting a spell, that foe is knocked down.
	; Concise description
	; Pet Attack. Deals +5...17...20 damage. Causes knock-down if target foe is casting a spell.

	; Priority: Casting enemy (KD trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 438 - $GC_I_SKILL_ID_MAIMING_STRIKE
Func CanUse_MaimingStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_MaimingStrike($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Maiming Strike that deals +5...17...20 damage. If that attack hits a moving foe that foe becomes Crippled for 3...13...15 seconds.
	; Concise description
	; Pet Attack. Deals +5...17...20 damage. Inflicts Crippled condition (3...13...15 seconds) if target foe is moving.

	; Priority: Moving enemy (Cripple trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 439 - $GC_I_SKILL_ID_FERAL_LUNGE
Func CanUse_FeralLunge()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_FeralLunge($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Feral Lunge that deals +5...29...35 damage. If the attack strikes a foe who is attacking, that foe suffers from Bleeding for 5...21...25 seconds.
	; Concise description
	; Pet Attack. Deals +5...29...35 damage. Inflicts Bleeding condition if target foe is attacking (5...21...25 seconds).

	; Priority: Attacking enemy (Bleeding trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 440 - $GC_I_SKILL_ID_SCAVENGER_STRIKE
Func CanUse_ScavengerStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_ScavengerStrike($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Scavenger Strike that deals +10...22...25 damage. If the attack strikes a foe who is suffering a condition, you gain 3...13...15 Energy.
	; Concise description
	; Pet Attack. Deals +10...22...25 damage. You gain 3...13...15 Energy if target foe has a condition.

	; Priority: Conditioned enemy (Energy gain trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 441 - $GC_I_SKILL_ID_MELANDRUS_ASSAULT
Func CanUse_MelandrusAssault()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_MelandrusAssault($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Melandru's Assault that deals +5...17...20 damage to all nearby foes.
	; Concise description
	; Pet Attack. Deals +5...17...20 damage to nearby foes.

	; AOE attack: Target enemy with most adjacent enemies
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 442 - $GC_I_SKILL_ID_FEROCIOUS_STRIKE
Func CanUse_FerociousStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_FerociousStrike($a_f_AggroRange)
	; Description
	; Elite Pet Attack. Your animal companion attempts a Ferocious Strike that deals +13...25...28 damage. If that attack hits, you gain adrenaline and 3...9...10 Energy.
	; Concise description
	; Elite Pet Attack. Deals +13...25...28 damage. You gain adrenaline and 3...9...10 energy.

	; Any enemy (unconditional bonus)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 443 - $GC_I_SKILL_ID_PREDATORS_POUNCE
Func CanUse_PredatorsPounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_PredatorsPounce($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Predator's Pounce that deals +5...29...35 damage. If that attack hits, your animal companion gains 5...41...50 Health.
	; Concise description
	; Pet Attack. Deals +5...29...35 damage. Your pet gains 5...41...50 Health if this attack hits.

	; Any enemy (unconditional bonus - pet heal)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 444 - $GC_I_SKILL_ID_BRUTAL_STRIKE
Func CanUse_BrutalStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_BrutalStrike($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Brutal Strike that deals +5...29...35 damage. If that attack strikes a foe whose Health is below 50%, that foe takes an additional +5...29...35 damage.
	; Concise description
	; Pet Attack. Deals +5...29...35 damage. Deals +5...29...35 more damage if target foe is under 50% health.

	; Priority: Enemy below 50% HP (double damage trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsBelow50HP")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 445 - $GC_I_SKILL_ID_DISRUPTING_LUNGE
Func CanUse_DisruptingLunge()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingLunge($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Disrupting Lunge that deals +1...10...12 damage. If that attack strikes a foe using a skill that skill is interrupted and is disabled for an additional 20 seconds.
	; Concise description
	; Pet Attack. Deals +1...10...12 damage. Interrupts a skill. Interruption effect: interrupted skill is disabled for +20 seconds.

	; Priority: Enemy Caster (Try to rupt)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1201 - $GC_I_SKILL_ID_SAVAGE_POUNCE
Func CanUse_SavagePounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_SavagePounce($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Savage Pounce that deals +5...17...20 damage. If the attack strikes a foe who is casting a spell, that foe is knocked down.
	; Concise description
	; Pet Attack. Deals +5...17...20 damage. Causes knock-down if target foe is casting a spell.

	; Priority: Casting enemy (KD trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1202 - $GC_I_SKILL_ID_ENRAGED_LUNGE
Func CanUse_EnragedLunge()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_EnragedLunge($a_f_AggroRange)
	; Description
	; Elite Pet Attack. Your animal companion attempts an Enraged Lunge that applies a Deep Wound to target foe for 5...17...20 seconds and deals +10...42...50 damage.
	; Concise description
	; Elite Pet Attack. Inflicts Deep Wound condition (5...17...20 seconds) and deals +10...42...50 damage.

	; Priority: Enemy not already deep wounded (maximize Deep Wound application)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsNotDeepWounded")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy (damage is still good)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1203 - $GC_I_SKILL_ID_BESTIAL_MAULING
Func CanUse_BestialMauling()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_BestialMauling($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Bestial Mauling that deals +5...17...20 damage. If the attack strikes a knocked-down foe, that foe is Dazed for 4...9...10 seconds.
	; Concise description
	; Pet Attack. Deals +5...17...20 damage. Inflicts Dazed condition (4...9...10 seconds) if target foe is knocked-down.

	; Priority: Knocked down enemy (Daze trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1205 - $GC_I_SKILL_ID_POISONOUS_BITE
Func CanUse_PoisonousBite()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonousBite($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Poisonous Bite that Poisons target foe for 5...17...20 seconds.
	; Concise description
	; Pet Attack. Inflicts Poisoned condition (5...17...20 seconds).

	; Priority: Enemy not already poisoned (maximize Poison application)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsNotPoisoned")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy (refresh poison)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1206 - $GC_I_SKILL_ID_POUNCE
Func CanUse_Pounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_Pounce($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion's next attack is a Pounce that deals +5...17...20 damage. If the attack strikes a moving foe, that foe is knocked down.
	; Concise description
	; Pet Attack. Deals +5...17...20 damage. Causes knock-down if target foe is moving.

	; Priority: Moving enemy (KD trigger)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 3047 - $GC_I_SKILL_ID_MELANDRUS_ASSAULT_PvP
Func CanUse_MelandrusAssaultPvP()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_MelandrusAssaultPvP($a_f_AggroRange)
	; Description
	; Pet Attack. Your animal companion attempts a Melandru's Assault that deals +5...17...20 damage. If that attack strikes a foe with an enchantment, that foe and all adjacent foes take +5...29...35 additional damage.
	; Concise description
	; Pet Attack. Deals +5...17...20 damage. Deals +5...29...35 more damage to target and foes adjacent to target if this foe is enchanted.

	; Priority: Enchanted enemy with most adjacent enemies (AOE damage trigger)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enchanted enemy
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Last fallback: Any enemy (base damage only)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 3051 - $GC_I_SKILL_ID_ENRAGED_LUNGE_PvP
Func CanUse_EnragedLungePvP()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc

Func BestTarget_EnragedLungePvP($a_f_AggroRange)
	; Description
	; Elite Pet Attack. Your animal companion attempts an Enraged Lunge that deals +3...19...23 damage (maximum bonus 80) for each recharging Beast Mastery skill.
	; Concise description
	; Elite Pet Attack. Deals +3...19...23 damage (maximum 80) for each of your recharging Beast Mastery skills.

	; Any enemy (damage scales with recharging skills, unconditional)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

