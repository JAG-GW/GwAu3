#include-once

Func Anti_Skill10()
	Return False
EndFunc

; Skill ID: 29 - $GC_I_SKILL_ID_BLACKOUT
Func CanUse_Blackout()
	Return True
EndFunc

Func BestTarget_Blackout($a_f_AggroRange)
	; Description
	; Skill. For 2...5...6 seconds, all of touched target foe's skills are disabled, and all of your skills are disabled for 5 seconds.
	; Concise description
	; Touch Skill. (2...5...6 seconds.) Disables skills. Your skills are disabled (5 seconds).
	Return 0
EndFunc

; Skill ID: 154 - $GC_I_SKILL_ID_PLAGUE_TOUCH
Func CanUse_PlagueTouch()
	Return True
EndFunc

Func BestTarget_PlagueTouch($a_f_AggroRange)
	; Description
	; Skill. Transfer 1...3...3 negative condition[s] and [its/their] remaining duration[s] from yourself to target touched foe.
	; Concise description
	; Touch Skill. Transfers 1...3...3 condition[s] from yourself to target foe.
	Return 0
EndFunc

; Skill ID: 155 - $GC_I_SKILL_ID_VILE_TOUCH
Func CanUse_VileTouch()
	Return True
EndFunc

Func BestTarget_VileTouch($a_f_AggroRange)
	; Description
	; Skill. Touch target foe to deal 20...56...65 damage.
	; Concise description
	; Touch Skill. Deals 20...56...65 damage.
	Return 0
EndFunc

; Skill ID: 156 - $GC_I_SKILL_ID_VAMPIRIC_TOUCH
Func CanUse_VampiricTouch()
	; Only use if there's an enemy in touch range
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") < 1 Then Return False
	Return True
EndFunc

Func BestTarget_VampiricTouch($a_f_AggroRange)
	; Description
	; Skill. Touch target foe to steal up to 29...65...74 Health.
	; Concise description
	; Touch Skill. Steals 29...65...74 Health.
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 158 - $GC_I_SKILL_ID_TOUCH_OF_AGONY
Func CanUse_TouchOfAgony()
	Return True
EndFunc

Func BestTarget_TouchOfAgony($a_f_AggroRange)
	; Description
	; Skill. Target touched foe takes 20...50...58 shadow damage.
	; Concise description
	; Touch Skill. Deals 20...50...58 damage.
	Return 0
EndFunc

; Skill ID: 231 - $GC_I_SKILL_ID_SHOCK
Func CanUse_Shock()
	Return True
EndFunc

Func BestTarget_Shock($a_f_AggroRange)
	; Description
	; Skill. Target touched foe is knocked down and struck for 10...50...60 lightning damage. This skill has 25% armor penetration.
	; Concise description
	; Touch Skill. Deals 10...50...60 lightning damage. Causes knock-down. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 232 - $GC_I_SKILL_ID_LIGHTNING_TOUCH
Func CanUse_LightningTouch()
	Return True
EndFunc

Func BestTarget_LightningTouch($a_f_AggroRange)
	; Description
	; Skill. Target touched foe and all adjacent foes are struck for 10...50...60 lightning damage, are Blinded for 1...3...4 second[s], and have Cracked Armor for 1...8...10 second[s]. This skill has 25% armor penetration.
	; Concise description
	; Touch Skill. Deals 10...50...60 lightning damage. Also hits foes adjacent to target foe. Inflicts Blind (1...3...4 second[s]) and Cracked Armor (1...8...10 second[s]) on all struck foes. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 300 - $GC_I_SKILL_ID_CONTEMPLATION_OF_PURITY
Func CanUse_ContemplationOfPurity()
	Return True
EndFunc

Func BestTarget_ContemplationOfPurity($a_f_AggroRange)
	; Description
	; Skill. Lose all enchantments. For each one lost, you gain 0...64...80 Health, lose one hex, and lose one condition (maximum 1...7...8 hexes and conditions).
	; Concise description
	; Skill. You gain 0...64...80 Health and lose one hex and one condition for each enchantment on you (maximum 1...7...8 hexes and conditions). You lose all enchantments.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 312 - $GC_I_SKILL_ID_HOLY_STRIKE
Func CanUse_HolyStrike()
	Return True
EndFunc

Func BestTarget_HolyStrike($a_f_AggroRange)
	; Description
	; Skill. Touched target foe takes 10...46...55 holy damage. If knocked down, your target takes an additional 10...46...55 holy damage.
	; Concise description
	; Touch Skill. Deals 10...46...55 holy damage. Deals 10...46...55 more holy damage if target is knocked down.
	Return 0
EndFunc

; Skill ID: 389 - $GC_I_SKILL_ID_FLOURISH
Func CanUse_Flourish()
	Return True
EndFunc

Func BestTarget_Flourish($a_f_AggroRange)
	; Description
	; Elite Skill. All of your attack skills become recharged. You gain 2...6...7 Energy for each skill recharged by Flourish.
	; Concise description
	; Elite Skill. Recharges your attack skills. You gain 2...6...7 Energy for each skill recharged.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 411 - $GC_I_SKILL_ID_CHARM_ANIMAL
Func CanUse_CharmAnimal()
	Return True
EndFunc

Func BestTarget_CharmAnimal($a_f_AggroRange)
	; Description
	; Skill. Charm target animal. Once charmed, your animal companion will travel with you whenever you have Charm Animal equipped. You cannot charm an animal that is more than 4 levels above you.
	; Concise description
	; Skill. Charm target animal. Once charmed, your animal companion will travel with you whenever you have Charm Animal equipped. You cannot charm an animal that is more than 4 levels above you.
	Return 0
EndFunc

; Skill ID: 422 - $GC_I_SKILL_ID_REVIVE_ANIMAL
Func CanUse_ReviveAnimal()
	Return True
EndFunc

Func BestTarget_ReviveAnimal($a_f_AggroRange)
	; Description
	; Skill. Resurrect all nearby allied animal companions. They come back to life with 10...77...94% Health.
	; Concise description
	; Skill. Resurrects all nearby allied pets (10...77...94% Health).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 424 - $GC_I_SKILL_ID_THROW_DIRT
Func CanUse_ThrowDirt()
	Return True
EndFunc

Func BestTarget_ThrowDirt($a_f_AggroRange)
	; Description
	; Skill. Target touched foe and foes adjacent to your target become Blinded for 3...13...15 seconds.
	; Concise description
	; Touch Skill. Inflicts Blindness condition (3...13...15 seconds). Also affects foes adjacent to target foe.
	Return 0
EndFunc

; Skill ID: 436 - $GC_I_SKILL_ID_COMFORT_ANIMAL
Func CanUse_ComfortAnimal()
    Local $l_i_PetSize = World_GetWorldInfo("PetInfoArraySize")
    Local $lMyPet = 0

    ; PetNumber starts at 1, not 0
    For $i = 1 To $l_i_PetSize
        If Party_GetPetInfo($i, "OwnerAgentID") = Agent_GetMyID() Then
            $lMyPet = Party_GetPetInfo($i, "AgentID")
            ExitLoop
        EndIf
    Next

    If $lMyPet = 0 Then Return False

    If Agent_GetAgentInfo($lMyPet, "HPPercent") < 0.5 Then Return True

    Return False
EndFunc

Func BestTarget_ComfortAnimal($a_f_AggroRange)
	; Description
	; Skill. You heal your animal companion for 20...87...104 Health. If your companion is dead, it is resurrected with 10...48...58% Health. If you have Comfort Animal equipped, your animal companion will travel with you.
	; Concise description
	; Skill. Your pet gains 20...87...104 Health. Resurrects your pet (10...48...58% Health.) If you have Comfort Animal equipped, your animal companion will travel with you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 446 - $GC_I_SKILL_ID_TROLL_UNGUENT
Func CanUse_TrollUnguent()
	; Only use if HP is below 80%
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc

Func BestTarget_TrollUnguent($a_f_AggroRange)
	; Description
	; Skill. For 13 seconds, you gain +3...9...10 Health regeneration.
	; Concise description
	; Skill. (13 seconds.) You have +3...9...10 Health regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 510 - $GC_I_SKILL_ID_DEAFENING_ROAR
Func CanUse_DeafeningRoar()
	Return True
EndFunc

Func BestTarget_DeafeningRoar($a_f_AggroRange)
	; Description
	; Skill. All nearby foes become Dazed for 20 seconds.
	; Concise description
	; Skill. Inflicts Dazed condition (20 seconds) to nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 516 - $GC_I_SKILL_ID_CLAIM_RESOURCE1
Func CanUse_ClaimResource1()
	Return True
EndFunc

Func BestTarget_ClaimResource1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 517 - $GC_I_SKILL_ID_CLAIM_RESOURCE2
Func CanUse_ClaimResource2()
	Return True
EndFunc

Func BestTarget_ClaimResource2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 518 - $GC_I_SKILL_ID_CLAIM_RESOURCE3
Func CanUse_ClaimResource3()
	Return True
EndFunc

Func BestTarget_ClaimResource3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 519 - $GC_I_SKILL_ID_CLAIM_RESOURCE4
Func CanUse_ClaimResource4()
	Return True
EndFunc

Func BestTarget_ClaimResource4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 520 - $GC_I_SKILL_ID_CLAIM_RESOURCE5
Func CanUse_ClaimResource5()
	Return True
EndFunc

Func BestTarget_ClaimResource5($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 521 - $GC_I_SKILL_ID_CLAIM_RESOURCE6
Func CanUse_ClaimResource6()
	Return True
EndFunc

Func BestTarget_ClaimResource6($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 522 - $GC_I_SKILL_ID_CLAIM_RESOURCE7
Func CanUse_ClaimResource7()
	Return True
EndFunc

Func BestTarget_ClaimResource7($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 523 - $GC_I_SKILL_ID_CLAIM_RESOURCE8
Func CanUse_ClaimResource8()
	Return True
EndFunc

Func BestTarget_ClaimResource8($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 526 - $GC_I_SKILL_ID_CLAIM_RESOURCE9
Func CanUse_ClaimResource9()
	Return True
EndFunc

Func BestTarget_ClaimResource9($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 527 - $GC_I_SKILL_ID_CLAIM_RESOURCE10
Func CanUse_ClaimResource10()
	Return True
EndFunc

Func BestTarget_ClaimResource10($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 536 - $GC_I_SKILL_ID_CRYSTAL_HIBERNATION
Func CanUse_CrystalHibernation()
	Return True
EndFunc

Func BestTarget_CrystalHibernation($a_f_AggroRange)
	; Description
	; Skill. (monster only) For 20 seconds, Gain +7 Health regeneration. Whenever you would take non-physical damage, gain an equal amount of Health instead.
	; Concise description
	; Skill. (monster only) (20 seconds.) You gain +7 Health regeneration. Converts incoming non-physical damage to healing.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 541 - $GC_I_SKILL_ID_LIFE_VORTEX
Func CanUse_LifeVortex()
	Return True
EndFunc

Func BestTarget_LifeVortex($a_f_AggroRange)
	; Description
	; Skill. (monster only) Steal up to 200 Health from each foe within 30 feet.
	; Concise description
	; Skill. (monster only) Steal up to 200 Health from each foe within 30 feet.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 546 - $GC_I_SKILL_ID_SPECTRAL_AGONY
Func CanUse_SpectralAgony()
	Return True
EndFunc

Func BestTarget_SpectralAgony($a_f_AggroRange)
	; Description
	; This article is about the Monster skill. For the temporarily available Bonus Mission Pack skill, see Spectral Agony (Saul D'Alessio).
	; Concise description
	; green; font-weight: bold;">1...30
	Return 0
EndFunc

; Skill ID: 565 - $GC_I_SKILL_ID_CLAIM_RESOURCE
Func CanUse_ClaimResource()
	Return True
EndFunc

Func BestTarget_ClaimResource($a_f_AggroRange)
	; Description
	; Skill. Will open doors and unlocks locked locks.
	; Concise description
	; Skill. Opens doors and locks.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 573 - $GC_I_SKILL_ID_TELEPORT_PLAYERS
Func CanUse_TeleportPlayers()
	Return True
EndFunc

Func BestTarget_TeleportPlayers($a_f_AggroRange)
	; Description
	; Skill
	; Concise description
	; 20251201122354 Cache expiry: 86400 Reduced expiry: false Complications: [] CPU time usage: 0.013 seconds Real time usage: 0.019 seconds Preprocessor visited node count: 270/1000000 Post‐expand include size: 1341/2097152 bytes Template argument size: 350/2097152 bytes Highest expansion depth: 7/100 Expensive parser function count: 0/100 Unstrip recursion depth: 0/20 Unstrip post‐expand size: 0/5000000 bytes ExtLoops count: 0/1000 -->
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 588 - $GC_I_SKILL_ID_CHARM_ANIMAL_MONSTER
; Skill ID: 590 - $GC_I_SKILL_ID_KNOCK
Func CanUse_Knock()
	Return True
EndFunc

Func BestTarget_Knock($a_f_AggroRange)
	; Description
	; Skill. Rurik's wait to open the exit door.
	; Concise description
	; Skill. Rurik's wait to open the exit door.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 786 - $GC_I_SKILL_ID_IRON_PALM
Func CanUse_IronPalm()
	Return True
EndFunc

Func BestTarget_IronPalm($a_f_AggroRange)
	; Description
	; Skill. Target touched foe suffers 5...41...50 damage, and if that foe is suffering from a hex or condition that foe is knocked down. Iron Palm counts as a lead attack.
	; Concise description
	; Touch Skill. Deals 5...41...50 damage. Causes knock-down if target foe is hexed or has a condition. Counts as a lead attack.
	Return 0
EndFunc

; Skill ID: 810 - $GC_I_SKILL_ID_PROTECTORS_DEFENSE
Func CanUse_ProtectorsDefense()
	Return True
EndFunc

Func BestTarget_ProtectorsDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 990 - $GC_I_SKILL_ID_EXPUNGE_ENCHANTMENTS
Func CanUse_ExpungeEnchantments()
	Return True
EndFunc

Func BestTarget_ExpungeEnchantments($a_f_AggroRange)
	; Description
	; Skill. Target foe loses 1 enchantment. All of your other non-attack skills are disabled for 10...6...5 seconds. For each skill disabled in this way, target touched foe loses 1 additional enchantment.
	; Concise description
	; Touch Skill. Removes one enchantment for each non-attack skill you have. All your non-attack skills are disabled (10...6...5 seconds).
	Return 0
EndFunc

; Skill ID: 1033 - $GC_I_SKILL_ID_IMPALE
Func CanUse_Impale()
	Return True
EndFunc

Func BestTarget_Impale($a_f_AggroRange)
	; Description
	; Skill. Must follow a dual attack. Target foe is struck for 25...85...100 earth damage and suffers from a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Skill. Deals 25...85...100 earth damage. Inflicts Deep Wound condition (5...17...20 seconds). Must follow a dual attack.
	Return 0
EndFunc

; Skill ID: 1039 - $GC_I_SKILL_ID_STAR_STRIKE
Func CanUse_StarStrike()
	Return True
EndFunc

Func BestTarget_StarStrike($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, upon every successful hit by you or a party member a level 20 celestial attacker is called forth to attack foes (maximum of 6).
	; Concise description
	; Skill. (10 seconds.) Party-wide effect. Every successful attack summons a level 20 celestial attacker (maximum of 6).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1045 - $GC_I_SKILL_ID_PALM_STRIKE
Func CanUse_PalmStrike()
	Return True
EndFunc

Func BestTarget_PalmStrike($a_f_AggroRange)
	; Description
	; Elite Skill. Target touched foe takes 10...54...65 damage and is Crippled for 1...4...5 second[s]. This skill counts as an off-hand attack.
	; Concise description
	; Elite Touch Skill. Deals 10...54...65 damage and inflicts Crippled condition (1...4...5 second[s]). This skill counts as an off-hand attack.
	Return 0
EndFunc

; Skill ID: 1072 - $GC_I_SKILL_ID_STAR_SERVANT
Func CanUse_StarServant()
	Return True
EndFunc

Func BestTarget_StarServant($a_f_AggroRange)
	; Description
	; Skill. Summon a level-25 celestial horror at your location. Each time the celestial horror successfully lands an attack, your party gains 25 Health and 3 Energy.
	; Concise description
	; Skill. Summon a level 25 celestial horror. Your party members gain 25 Health and 3 Energy each time the celestial horror lands an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1077 - $GC_I_SKILL_ID_VAMPIRIC_BITE
Func CanUse_VampiricBite()
	Return True
EndFunc

Func BestTarget_VampiricBite($a_f_AggroRange)
	; Description
	; Skill. Touch target foe to steal up to 29...65...74 Health.
	; Concise description
	; Touch Skill. Steals 29...65...74 Health.
	Return 0
EndFunc

; Skill ID: 1078 - $GC_I_SKILL_ID_WALLOWS_BITE
Func CanUse_WallowsBite()
	Return True
EndFunc

Func BestTarget_WallowsBite($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1079 - $GC_I_SKILL_ID_ENFEEBLING_TOUCH
Func CanUse_EnfeeblingTouch()
	Return True
EndFunc

Func BestTarget_EnfeeblingTouch($a_f_AggroRange)
	; Description
	; Skill. Target touched foe loses 5...41...50 Health and suffers from Weakness for 5...17...20 seconds.
	; Concise description
	; Touch Skill. Causes 5...41...50 Health loss. Inflicts Weakness condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 1100 - $GC_I_SKILL_ID_CELESTIAL_STORM
Func CanUse_CelestialStorm()
	Return True
EndFunc

Func BestTarget_CelestialStorm($a_f_AggroRange)
	; Description
	; Skill. Create a celestial storm at target foe's location that lasts for 15 seconds. Each second, all foes in the area take 40 fire damage, 40 cold damage, 40 lightning damage, and 40 earth damage.
	; Concise description
	; Skill. Deals 40 damage of each elemental type each second (15 seconds). Hits all foes in the area of target's initial location.
	Return 0
EndFunc

; Skill ID: 1124 - $GC_I_SKILL_ID_STAR_SHINE
Func CanUse_StarShine()
	Return True
EndFunc

Func BestTarget_StarShine($a_f_AggroRange)
	; Description
	; Skill. Your entire party is healed to their maximum Health. All conditions and hexes are removed from your party.
	; Concise description
	; Skill. Heals your entire party to their maximum Health and removes all conditions and hexes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1131 - $GC_I_SKILL_ID_STONESOUL_STRIKE
Func CanUse_StonesoulStrike()
	Return True
EndFunc

Func BestTarget_StonesoulStrike($a_f_AggroRange)
	; Description
	; Skill. Touched target foe takes 10...46...55 holy damage. If knocked down, your target takes an additional 10...46...55 holy damage.
	; Concise description
	; Touch Skill. Deals 10...46...55 holy damage. Deals 10...46...55 more holy damage if target is knocked down.
	Return 0
EndFunc

; Skill ID: 1140 - $GC_I_SKILL_ID_STORM_OF_SWORDS
Func CanUse_StormOfSwords()
	Return True
EndFunc

Func BestTarget_StormOfSwords($a_f_AggroRange)
	; Description
	; Skill. For 15 seconds, you and all adjacent allies deal 25 damage to all adjacent foes each second.
	; Concise description
	; Skill. (15 seconds.) Affects you and all adjacent allies. Deals 25 damage to all adjacent foes each second.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1146 - $GC_I_SKILL_ID_SHOVE
Func CanUse_Shove()
	Return True
EndFunc

Func BestTarget_Shove($a_f_AggroRange)
	; Description
	; Elite Skill. Target touched foe is knocked down. If that foe was moving, that foe's stance ends and that foe takes 15...63...75 damage before being knocked down.
	; Concise description
	; Elite Touch Skill. Causes knockdown. Initial effect: ends foe's stance and deals 15...63...75 damage if target foe is moving.
	Return 0
EndFunc

; Skill ID: 1147 - $GC_I_SKILL_ID_BASE_DEFENSE
Func CanUse_BaseDefense()
	Return True
EndFunc

Func BestTarget_BaseDefense($a_f_AggroRange)
	; Description
	; Skill. All foes in range lose 999 Health and are knocked down for 5 seconds.
	; Concise description
	; Skill. Causes 999 Health loss and knocks down (5 seconds). Hits all foes in range.
	Return 0
EndFunc

; Skill ID: 1148 - $GC_I_SKILL_ID_CARRIER_DEFENSE
Func CanUse_CarrierDefense()
	Return True
EndFunc

Func BestTarget_CarrierDefense($a_f_AggroRange)
	; Description
	; Skill. All nearby foes take 100 damage and are teleported away.
	; Concise description
	; Skill. Deals 100 damage to nearby foes and teleports them away.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1149 - $GC_I_SKILL_ID_THE_CHALICE_OF_CORRUPTION
Func CanUse_TheChaliceOfCorruption()
	Return True
EndFunc

Func BestTarget_TheChaliceOfCorruption($a_f_AggroRange)
	; Description
	; Skill. Target foe suffers -2 Health degeneration. This effect lasts until it is removed by Brother Tosai.
	; Concise description
	; Skill. -2 Health degeneration. This effect lasts until Brother Tosai removes it.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1155 - $GC_I_SKILL_ID_JUGGERNAUT_TOSS
Func CanUse_JuggernautToss()
	Return True
EndFunc

Func BestTarget_JuggernautToss($a_f_AggroRange)
	; Description
	; Skill. Target touched foe takes 50 damage and is knocked down for 5 seconds.
	; Concise description
	; Touch Skill. 50 damage. Causes knock-down (5 seconds).
	Return 0
EndFunc

; Skill ID: 1178 - $GC_I_SKILL_ID_LAST_STAND
Func CanUse_LastStand()
	Return True
EndFunc

Func BestTarget_LastStand($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1185 - $GC_I_SKILL_ID_CONSTRUCT_POSSESSION
Func CanUse_ConstructPossession()
	Return True
EndFunc

Func BestTarget_ConstructPossession($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1186 - $GC_I_SKILL_ID_SIEGE_TURTLE_ATTACK_THE_ETERNAL_GROVE
Func CanUse_SiegeTurtleAttackTheEternalGrove()
	Return True
EndFunc

Func BestTarget_SiegeTurtleAttackTheEternalGrove($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1187 - $GC_I_SKILL_ID_SIEGE_TURTLE_ATTACK_FORT_ASPENWOOD
Func CanUse_SiegeTurtleAttackFortAspenwood()
	Return True
EndFunc

Func BestTarget_SiegeTurtleAttackFortAspenwood($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1188 - $GC_I_SKILL_ID_SIEGE_TURTLE_ATTACK_GYALA_HATCHERY
Func CanUse_SiegeTurtleAttackGyalaHatchery()
	Return True
EndFunc

Func BestTarget_SiegeTurtleAttackGyalaHatchery($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1195 - $GC_I_SKILL_ID_HEAL_AS_ONE
Func CanUse_HealAsOne()
	Return True
EndFunc

Func BestTarget_HealAsOne($a_f_AggroRange)
	; Description
	; Elite Skill. For 15 seconds, your animal companion steals 1...16...20 Health whenever it hits with an attack. You and your companion are both healed for 20...87...104 Health. If your companion is dead, it's resurrected with 50% Health. If you have this skill equipped, your companion will travel with you.
	; Concise description
	; Elite Skill. (15 seconds.) Your pet's attacks steal 1...16...20 Health. Initial effect: heals you and your pet for 20...87...104; resurrects your pet (50% Health) if dead. If you have this equipped, your pet will travel with you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1207 - $GC_I_SKILL_ID_CELESTIAL_STANCE
Func CanUse_CelestialStance()
	Return True
EndFunc

Func BestTarget_CelestialStance($a_f_AggroRange)
	; Description
	; Skill. For 15 seconds, your entire party has a 75% chance to block attacks and +3 Health regeneration.
	; Concise description
	; Skill. (15 seconds.) Affects all party members. 75% chance to block. +3 Health regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1232 - $GC_I_SKILL_ID_ARMOR_OF_UNFEELING
Func CanUse_ArmorOfUnfeeling()
	Return True
EndFunc

Func BestTarget_ArmorOfUnfeeling($a_f_AggroRange)
	; Description
	; Skill. For 10...30...35 seconds, your spirits within earshot take 50% less damage and are immune to critical attacks.
	; Concise description
	; Skill. (10...30...35 seconds.) Your spirits within earshot take 50% less damage and are immune to critical attacks.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1241 - $GC_I_SKILL_ID_CELESTIAL_SUMMONING
Func CanUse_CelestialSummoning()
	Return True
EndFunc

Func BestTarget_CelestialSummoning($a_f_AggroRange)
	; Description
	; Skill. Archemorous and Saint Viktor are summoned from the spirit realm.
	; Concise description
	; Skill. Archemorous and Saint Viktor are summoned from the spirit realm.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1246 - $GC_I_SKILL_ID_ANCESTORS_RAGE
Func CanUse_AncestorsRage()
	Return True
EndFunc

Func BestTarget_AncestorsRage($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1273 - $GC_I_SKILL_ID_IMPOSSIBLE_ODDS
Func CanUse_ImpossibleOdds()
	Return True
EndFunc

Func BestTarget_ImpossibleOdds($a_f_AggroRange)
	; Description
	; Skill. All hexes are removed from Shiro. For the next 10 seconds, all of Shiro's attacks are double strikes and hit nearby foes. Shiro tranfers  any conditions from himself to foes he hits.
	; Concise description
	; Skill. (10 seconds.) All Shiro's attacks are double strikes and hit nearby foes. Shiro transfers conditions from himself to foes he hits. Initial effect: removes all hexes from Shiro.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1276 - $GC_I_SKILL_ID_MEDITATION_OF_THE_REAPER1
Func CanUse_MeditationOfTheReaper1()
	Return True
EndFunc

Func BestTarget_MeditationOfTheReaper1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1307 - $GC_I_SKILL_ID_FORESTS_BINDING
Func CanUse_ForestsBinding()
	Return True
EndFunc

Func BestTarget_ForestsBinding($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1308 - $GC_I_SKILL_ID_EXPLODING_SPORES
Func CanUse_ExplodingSpores()
	Return True
EndFunc

Func BestTarget_ExplodingSpores($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1315 - $GC_I_SKILL_ID_RAGE_OF_THE_SEA
Func CanUse_RageOfTheSea()
	Return True
EndFunc

Func BestTarget_RageOfTheSea($a_f_AggroRange)
	; Description
	; Skill. For 2 minutes, you have +4 Health regeneration, +1 Energy regeneration, and you move 33% faster.
	; Concise description
	; Skill. (2 minutes.) You have +4 Health regeneration, +1 Energy regeneration, and move 33% faster.
	Return 0
EndFunc

; Skill ID: 1316 - $GC_I_SKILL_ID_MEDITATION_OF_THE_REAPER2
Func CanUse_MeditationOfTheReaper2()
	Return True
EndFunc

Func BestTarget_MeditationOfTheReaper2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1317 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1324 - $GC_I_SKILL_ID_TORMENT_SLASH
Func CanUse_TormentSlash()
	Return True
EndFunc

Func BestTarget_TormentSlash($a_f_AggroRange)
	; Description
	; This article is about the skill used by Torment Claws. For the skill used by Smothering Tendrils, see Torment Slash (Smothering Tendrils).
	; Concise description
	; Related skills">edit
	Return 0
EndFunc

; Skill ID: 1326 - $GC_I_SKILL_ID_TRADE_WINDS
Func CanUse_TradeWinds()
	Return True
EndFunc

Func BestTarget_TradeWinds($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, you move with the swiftness of the Canthan fleet. This enchantment may also be applied to target allies.
	; Concise description
	; Skill. (10 seconds.) Target ally moves with the swiftness of the Canthan fleet.
	Return 0
EndFunc

; Skill ID: 1327 - $GC_I_SKILL_ID_DRAGON_BLAST
Func CanUse_DragonBlast()
	Return True
EndFunc

Func BestTarget_DragonBlast($a_f_AggroRange)
	; Description
	; Dragon Arena skill
	; Concise description
	; kills target foe if it hits.
	Return 0
EndFunc

; Skill ID: 1328 - $GC_I_SKILL_ID_IMPERIAL_MAJESTY
Func CanUse_ImperialMajesty()
	Return True
EndFunc

Func BestTarget_ImperialMajesty($a_f_AggroRange)
	; Description
	; Skill. Target touched foe kowtows before you and takes 80 damage.
	; Concise description
	; Touch Skill. Target foe kowtows before you and takes 80 damage.
	Return 0
EndFunc

; Skill ID: 1339 - $GC_I_SKILL_ID_SYMBOLS_OF_INSPIRATION
Func CanUse_SymbolsOfInspiration()
	Return True
EndFunc

Func BestTarget_SymbolsOfInspiration($a_f_AggroRange)
	; Description
	; Elite Skill. For 1...25...31 seconds, this skill becomes the Elite of target foe. Elite spells you cast use your Fast Casting attribute instead of their normal attributes.
	; Concise description
	; Elite Skill. (1...25...31 seconds.) This skill becomes the Elite of target foe. Elite spells you cast use your Fast Casting attribute instead of their normal attributes.
	Return 0
EndFunc

; Skill ID: 1386 - $GC_I_SKILL_ID_SENTRY_TRAP_SKILL
Func CanUse_SentryTrapSkill()
	Return True
EndFunc

Func BestTarget_SentryTrapSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1387 - $GC_I_SKILL_ID_CALTROPS_MONSTER
Func CanUse_CaltropsMonster()
	Return True
EndFunc

Func BestTarget_CaltropsMonster($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1388 - $GC_I_SKILL_ID_SACRED_BRANCH
Func CanUse_SacredBranch()
	Return True
EndFunc

Func BestTarget_SacredBranch($a_f_AggroRange)
	; Description
	; Domination Magic
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Sacred_Branch","wgRelevantArticleId":314966,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1389 - $GC_I_SKILL_ID_LIGHT_OF_SEBORHIN
Func CanUse_LightOfSeborhin()
	Return True
EndFunc

Func BestTarget_LightOfSeborhin($a_f_AggroRange)
	; Description
	; Skill. Dropping the Light of Seborhin next to a Harbinger is the only means by which to damage a Harbinger.
	; Concise description
	; Skill. Harbingers can only be damaged by dropping the Light of Seborhin next to them.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1406 - $GC_I_SKILL_ID_HEADBUTT
Func CanUse_Headbutt()
	Return True
EndFunc

Func BestTarget_Headbutt($a_f_AggroRange)
	; Description
	; Elite Skill. Target touched foe takes 40...88...100 damage. You are Dazed for 5...17...20 seconds.
	; Concise description
	; Elite Touch Skill. Deals 40...88...100 damage. You are Dazed (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 1407 - $GC_I_SKILL_ID_LIONS_COMFORT
Func CanUse_LionsComfort()
	Return True
EndFunc

Func BestTarget_LionsComfort($a_f_AggroRange)
	; Description
	; Skill. All of your signets are disabled for 12 seconds. You are healed for 50...98...110 Health, and gain 0...2...3 strike[s] of adrenaline.
	; Concise description
	; Skill. You are healed for 50...98...110 and gain 0...2...3 strike[s] of adrenaline. Disables your signets (12 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1418 - $GC_I_SKILL_ID_DISARM_TRAP
Func CanUse_DisarmTrap()
	Return True
EndFunc

Func BestTarget_DisarmTrap($a_f_AggroRange)
	; Description
	; Skill. You disable an activated sentry trap before it discharges. You are easily interrupted while using this skill.
	; Concise description
	; Skill. You disable an activated sentry trap before it discharges. You are easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1422 - $GC_I_SKILL_ID_CREATE_LIGHT_OF_SEBORHIN
Func CanUse_CreateLightOfSeborhin()
	Return True
EndFunc

Func BestTarget_CreateLightOfSeborhin($a_f_AggroRange)
	; Description
	; Skill. Ancient energies are called forth to create the Light of Seborhin. This skill cannot be disabled.
	; Concise description
	; Skill. Ancient energies are called forth to create the Light of Seborhin. This skill cannot be disabled.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1423 - $GC_I_SKILL_ID_UNLOCK_CELL
Func CanUse_UnlockCell()
	Return True
EndFunc

Func BestTarget_UnlockCell($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; //en.wikipedia.org/wiki/Sic" class="extiw" title="w:Sic">
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1438 - $GC_I_SKILL_ID_JUNUNDU_FEAST
Func CanUse_JununduFeast()
	; Only use if there's a corpse nearby to exploit
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsDeadEnemy") = 0 Then Return False
	Return True
EndFunc

Func BestTarget_JununduFeast($a_f_AggroRange)
	; Skill. (30 seconds.) Junundu Feast is replaced with Choking Breath, Blinding Breath, or Burning Breath. Must exploit an adjacent fresh corpse.
	; Self-target skill that exploits adjacent corpse
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1439 - $GC_I_SKILL_ID_JUNUNDU_STRIKE
Func CanUse_JununduStrike()
	; Touch skill - needs an enemy in adjacent range
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	Return True
EndFunc

Func BestTarget_JununduStrike($a_f_AggroRange)
	; Touch Skill. Deals 150 piercing damage. You are healed for 75.
	; Basic touch attack, target nearest enemy
	Return UAI_GetNearestAgent(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1440 - $GC_I_SKILL_ID_JUNUNDU_SMASH
Func CanUse_JununduSmash()
	; AoE adjacent damage + knockdown - needs enemies nearby
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	Return True
EndFunc

Func BestTarget_JununduSmash($a_f_AggroRange)
	; Skill. Deals 250 damage and causes knock-down (4 seconds). Also affects adjacent foes.
	; Self-target AoE skill
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1441 - $GC_I_SKILL_ID_JUNUNDU_SIEGE1
Func CanUse_JununduSiege1()
	; Projectile skill - cannot be used on nearby foes, needs enemy at range
	If UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	; Check there's an enemy outside nearby range (projectile can't hit nearby)
	Local $l_i_NearbyCount = UAI_CountAgents(-2, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
	Local $l_i_TotalCount = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy")
	If $l_i_TotalCount <= $l_i_NearbyCount Then Return False
	Return True
EndFunc

Func BestTarget_JununduSiege1($a_f_AggroRange)
	; Elite Skill. Projectile: deals 400 earth damage and causes knock-down. Cannot be used on nearby foes.
	; Target enemy outside nearby range
	Return UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1443 - $GC_I_SKILL_ID_LEAVE_JUNUNDU
Func CanUse_LeaveJunundu()
	Return False
EndFunc

Func BestTarget_LeaveJunundu($a_f_AggroRange)
	; Description
	; Skill. The junundu releases you from its jaws.
	; Concise description
	; Skill. The junundu releases you from its jaws.
	Return 0
EndFunc

; Skill ID: 1445 - $GC_I_SKILL_ID_SIGNAL_FLARE
Func CanUse_SignalFlare()
	Return True
EndFunc

Func BestTarget_SignalFlare($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1446 - $GC_I_SKILL_ID_THE_ELIXIR_OF_STRENGTH
Func CanUse_TheElixirOfStrength()
	Return True
EndFunc

Func BestTarget_TheElixirOfStrength($a_f_AggroRange)
	; Description
	; Nightfall
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1447 - $GC_I_SKILL_ID_EHZAH_FROM_ABOVE
Func CanUse_EhzahFromAbove()
	Return True
EndFunc

Func BestTarget_EhzahFromAbove($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1454 - $GC_I_SKILL_ID_CALL_TO_THE_TORMENT
Func CanUse_CallToTheTorment()
	Return True
EndFunc

Func BestTarget_CallToTheTorment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1455 - $GC_I_SKILL_ID_COMMAND_OF_TORMENT
Func CanUse_CommandOfTorment()
	Return True
EndFunc

Func BestTarget_CommandOfTorment($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 4 random torment creatures are summoned to this location.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1456 - $GC_I_SKILL_ID_ABADDONS_FAVOR
Func CanUse_AbaddonsFavor()
	Return True
EndFunc

Func BestTarget_AbaddonsFavor($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1471 - $GC_I_SKILL_ID_SCAVENGERS_FOCUS
Func CanUse_ScavengersFocus()
	Return True
EndFunc

Func BestTarget_ScavengersFocus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1573 - $GC_I_SKILL_ID_AWE
Func CanUse_Awe()
	Return True
EndFunc

Func BestTarget_Awe($a_f_AggroRange)
	; Description
	; Skill. If this skill hits a knocked-down foe, that foe becomes Dazed for 5...13...15 seconds. Awe has half the normal range.
	; Concise description
	; Half Range Skill. Inflicts Dazed condition (5...13...15 seconds). No effect unless target is knocked-down.
	Return 0
EndFunc

; Skill ID: 1583 - $GC_I_SKILL_ID_LEADERS_ZEAL
Func CanUse_LeadersZeal()
	Return True
EndFunc

Func BestTarget_LeadersZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1584 - $GC_I_SKILL_ID_LEADERS_COMFORT
Func CanUse_LeadersComfort()
	Return True
EndFunc

Func BestTarget_LeadersComfort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1586 - $GC_I_SKILL_ID_ANGELIC_PROTECTION
Func CanUse_AngelicProtection()
	Return True
EndFunc

Func BestTarget_AngelicProtection($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, any time target other ally takes more than 250...130...100 damage per second, that ally is healed for any damage over that amount.
	; Concise description
	; Skill. (10 seconds.) Each second that target ally takes damage over 250...130...100, that ally is healed for any damage over that amount. Cannot self target.
	Return 0
EndFunc

; Skill ID: 1587 - $GC_I_SKILL_ID_ANGELIC_BOND
Func CanUse_AngelicBond()
	Return True
EndFunc

Func BestTarget_AngelicBond($a_f_AggroRange)
	; Description
	; Elite Skill. For 10 seconds, the next time an ally within earshot would take fatal damage, that damage is negated and that ally is healed for 20...164...200 Health. Angelic Bond ends on all other allies.
	; Concise description
	; Elite Skill. (10 seconds.) The next time an ally within earshot would take fatal damage, that damage is negated and that ally is healed for 20...164...200. Ends on other allies.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1609 - $GC_I_SKILL_ID_SCEPTER_OF_ETHER
Func CanUse_ScepterOfEther()
	Return True
EndFunc

Func BestTarget_ScepterOfEther($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1616 - $GC_I_SKILL_ID_QUEEN_HEAL
Func CanUse_QueenHeal()
	Return True
EndFunc

Func BestTarget_QueenHeal($a_f_AggroRange)
	; Description
	; Skill. Exploit one adjacent corpse. Queen Heal is replaced with Choking Breath, Blinding Breath, or Burning Breath for 30 seconds.
	; Concise description
	; Skill. (30 seconds.) Junundu Feast [sic] is replaced with Choking Breath, Blinding Breath or Burning Breath. Must exploit an adjacent fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1619 - $GC_I_SKILL_ID_QUEEN_BITE
Func CanUse_QueenBite()
	Return True
EndFunc

Func BestTarget_QueenBite($a_f_AggroRange)
	; Description
	; Skill. Target touched foe is struck for 80 piercing damage.
	; Concise description
	; Touch Skill. Deals 80 piercing damage.
	Return 0
EndFunc

; Skill ID: 1620 - $GC_I_SKILL_ID_QUEEN_THUMP
Func CanUse_QueenThump()
	Return True
EndFunc

Func BestTarget_QueenThump($a_f_AggroRange)
	; Description
	; Skill. All adjacent foes are struck for 80 damage and knocked down for 4 seconds.
	; Concise description
	; Skill. Deals 80 damage and knocks-down foes adjacent to you (4 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1621 - $GC_I_SKILL_ID_QUEEN_SIEGE
Func CanUse_QueenSiege()
	Return True
EndFunc

Func BestTarget_QueenSiege($a_f_AggroRange)
	; Description
	; Skill. Spit a projectile at target foe. It strikes for 100 earth damage and knocks down target foe if it hits. This skill cannot be used on nearby foes.
	; Concise description
	; Skill. Projectile: deals 100 earth damage and causes knock-down. Cannot be used on nearby foes.
	Return 0
EndFunc

; Skill ID: 1643 - $GC_I_SKILL_ID_ASSAULT_ENCHANTMENTS
Func CanUse_AssaultEnchantments()
	Return True
EndFunc

Func BestTarget_AssaultEnchantments($a_f_AggroRange)
	; Description
	; Elite Skill. Must follow a dual attack. Target foe loses all enchantments.
	; Concise description
	; Elite Skill. Removes all enchantments. Must follow a dual attack.
	Return 0
EndFunc

; Skill ID: 1644 - $GC_I_SKILL_ID_WASTRELS_COLLAPSE
Func CanUse_WastrelsCollapse()
	Return True
EndFunc

Func BestTarget_WastrelsCollapse($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1645 - $GC_I_SKILL_ID_LIFT_ENCHANTMENT
Func CanUse_LiftEnchantment()
	Return True
EndFunc

Func BestTarget_LiftEnchantment($a_f_AggroRange)
	; Description
	; Touch Skill. If target touched foe is knocked down, that foe loses one enchantment.
	; Concise description
	; Touch Skill. Removes one enchantment.No [sic] effect unless target foe is knocked-down.
	Return 0
EndFunc

; Skill ID: 1706 - $GC_I_SKILL_ID_CORRUPT_POWER
Func CanUse_CorruptPower()
	Return True
EndFunc

Func BestTarget_CorruptPower($a_f_AggroRange)
	; Description
	; Skill. All foes take 30 damage 5 times over the next 3 seconds. Each strike also removes one stance or enchantment from each foe.
	; Concise description
	; Skill. All foes take 30 damage 5 times over the next 3 seconds. Each strike also removes one stance or enchantment from each foe.
	Return 0
EndFunc

; Skill ID: 1708 - $GC_I_SKILL_ID_GAZE_OF_MOAVUKAAL
Func CanUse_GazeOfMoavukaal()
	Return True
EndFunc

Func BestTarget_GazeOfMoavukaal($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1711 - $GC_I_SKILL_ID_THE_APOCRYPHA_IS_CHANGING_TO_ANOTHER_FORM
Func CanUse_TheApocryphaIsChangingToAnotherForm()
	Return True
EndFunc

Func BestTarget_TheApocryphaIsChangingToAnotherForm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1715 - $GC_I_SKILL_ID_REFORM_CARVINGS
Func CanUse_ReformCarvings()
	Return True
EndFunc

Func BestTarget_ReformCarvings($a_f_AggroRange)
	; Description
	; Skill. Graven Monolith reforms itself to release new powers.
	; Concise description
	; Skill. Graven Monolith reforms itself to release new powers.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1718 - $GC_I_SKILL_ID_SOUL_TORTURE
Func CanUse_SoulTorture()
	Return True
EndFunc

Func BestTarget_SoulTorture($a_f_AggroRange)
	; Description
	; Skill. Caster consumes a soul, ripping it from this world and sending it to Dhuum.
	; Concise description
	; Skill. Caster consumes a soul, ripping it from this world and sending it to Dhuum.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1814 - $GC_I_SKILL_ID_LIGHTBRINGERS_GAZE
Func CanUse_LightbringersGaze()
	Return True
EndFunc

Func BestTarget_LightbringersGaze($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1818 - $GC_I_SKILL_ID_MADDENED_STRIKE
Func CanUse_MaddenedStrike()
	Return True
EndFunc

Func BestTarget_MaddenedStrike($a_f_AggroRange)
	; Description
	; Skill. The maddened spirit touches you and drains away 700 Health.
	; Concise description
	; Touch Skill. The maddened spirit drains away 700 Health.
	Return 0
EndFunc

; Skill ID: 1855 - $GC_I_SKILL_ID_KOURNAN_SIEGE
Func CanUse_KournanSiege()
	Return True
EndFunc

Func BestTarget_KournanSiege($a_f_AggroRange)
	; Description
	; Skill. A signal flare is fired into the air to summon siege fire from any nearby garrisons. Every 3 seconds for 12 seconds, targets hit by the siege fire take 40 damage and are interrupted. This skill is easily interrupted.
	; Concise description
	; Skill. (12 seconds.) A signal flare is fired into the air to summon siege fire from any nearby garrisons. Every 3 seconds, targets hit by the siege fire take 40 damage and are interrupted. Easily interrupted.
	Return 0
EndFunc

; Skill ID: 1861 - $GC_I_SKILL_ID_CHOKING_BREATH
Func CanUse_ChokingBreath()
	; Interrupt skill - best used when enemies are nearby
	If UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	Return True
EndFunc

Func BestTarget_ChokingBreath($a_f_AggroRange)
	; Skill. Interrupts target and adjacent foes. Causes knock-down (4 seconds) to any foe casting a spell.
	; Prioritize casting enemies for knockdown bonus
	Local $l_i_CastingTarget = UAI_GetNearestAgent(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_CastingTarget <> 0 Then Return $l_i_CastingTarget
	; Fallback to best AoE target for adjacent interrupt
	Local $l_i_AOETarget = UAI_GetBestAOETarget(-2, $GC_I_RANGE_EARSHOT, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_AOETarget <> 0 Then Return $l_i_AOETarget
	; Fallback to nearest enemy
	Return UAI_GetNearestAgent(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1862 - $GC_I_SKILL_ID_JUNUNDU_BITE
Func CanUse_JununduBite()
	; Touch skill - needs an enemy in adjacent range
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	Return True
EndFunc

Func BestTarget_JununduBite($a_f_AggroRange)
	; Touch Skill. Deals 375 piercing damage. You are healed for 500 if target foe is knocked-down.
	; Prioritize knocked down enemies for bonus heal
	Local $l_i_KnockedTarget = UAI_GetNearestAgent(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_KnockedTarget <> 0 Then Return $l_i_KnockedTarget
	; Fallback to any adjacent enemy
	Return UAI_GetNearestAgent(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1863 - $GC_I_SKILL_ID_BLINDING_BREATH
Func CanUse_BlindingBreath()
	; AoE adjacent damage + blindness - needs enemies in adjacent range
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	Return True
EndFunc

Func BestTarget_BlindingBreath($a_f_AggroRange)
	; Skill. Deals 400 damage and inflicts Blindness condition (15 seconds). Also affects adjacent foes.
	; Self-target AoE skill, but check if there are non-blind enemies to maximize value
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1864 - $GC_I_SKILL_ID_BURNING_BREATH
Func CanUse_BurningBreath()
	; Projectile skill - cannot be used on nearby foes, needs enemy at range
	If UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	; Check there's an enemy outside nearby range (projectile can't hit nearby)
	Local $l_i_NearbyCount = UAI_CountAgents(-2, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
	Local $l_i_TotalCount = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy")
	If $l_i_TotalCount <= $l_i_NearbyCount Then Return False
	Return True
EndFunc

Func BestTarget_BurningBreath($a_f_AggroRange)
	; Skill. Projectile: deals 250 fire damage and inflicts Burning (5 seconds). Cannot be used on nearby foes.
	; Target enemy outside nearby range, prioritize non-burning targets
	Local $l_i_FarthestTarget = UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
	If $l_i_FarthestTarget <> 0 Then Return $l_i_FarthestTarget
	Return 0
EndFunc

; Skill ID: 1865 - $GC_I_SKILL_ID_JUNUNDU_WAIL
Func CanUse_JununduWail()
	; Blocked by anti-resurrect effects
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	; Check if there are dead allies to resurrect OR no enemies for healing
	Local $l_i_DeadAllies = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsDeadAlly")
	Local $l_i_Enemies = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy")
	; Use if there are dead allies to res, or if no enemies (for healing)
	If $l_i_DeadAllies > 0 Or $l_i_Enemies = 0 Then Return True
	Return False
EndFunc

Func BestTarget_JununduWail($a_f_AggroRange)
	; Skill. Resurrect all dead junundu in earshot. If there are no enemies in earshot, gain 500 Health for each junundu in range.
	; Self-target skill
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1868 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1869 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1870 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1874 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1875 - $GC_I_SKILL_ID_WORDS_OF_MADNESS
Func CanUse_WordsOfMadness()
	Return True
EndFunc

Func BestTarget_WordsOfMadness($a_f_AggroRange)
	; Description
	; This article is about Abaddon's skill. For skill used by Qwytzylkak, see Words of Madness (Qwytzylkak).
	; Concise description
	; Notes">edit
	Return 0
EndFunc

; Skill ID: 1876 - $GC_I_SKILL_ID_UNKNOWN_JUNUNDU_ABILITY
Func CanUse_UnknownJununduAbility()
	Return True
EndFunc

Func BestTarget_UnknownJununduAbility($a_f_AggroRange)
	; Description
	; Elite Skill. You have not taught your junundu to perform this skill.
	; Concise description
	; Elite Skill. You have not taught your junundu to perform this skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1880 - $GC_I_SKILL_ID_TORMENT_SLASH_SMOTHERING_TENDRILS
Func CanUse_TormentSlashSmotheringTendrils()
	Return True
EndFunc

Func BestTarget_TormentSlashSmotheringTendrils($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1884 - $GC_I_SKILL_ID_CONSUME_TORMENT
Func CanUse_ConsumeTorment()
	Return True
EndFunc

Func BestTarget_ConsumeTorment($a_f_AggroRange)
	; Description
	; Skill. All conditions and hexes are removed from caster. For each condition or hex removed in this way, caster gains 300 Health.
	; Concise description
	; Skill. All conditions and hexes are removed from caster. For each condition or hex removed in this way, caster gains 300 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1886 - $GC_I_SKILL_ID_SUMMONING_SHADOWS
Func CanUse_SummoningShadows()
	Return True
EndFunc

Func BestTarget_SummoningShadows($a_f_AggroRange)
	; Description
	; Skill. After 3 seconds, all of caster's foes unwillingly Shadow Step to positions adjacent to the caster.
	; Concise description
	; Skill. (3 seconds.) End effect: all of caster's foes Shadow Step to positions adjacent to the caster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1894 - $GC_I_SKILL_ID_TOUCH_OF_AAAAARRRRRRGGGHHH
Func CanUse_TouchOfAaaaarrrrrrggghhh()
	Return True
EndFunc

Func BestTarget_TouchOfAaaaarrrrrrggghhh($a_f_AggroRange)
	; Description
	; Skill. Target foe's attributes are set to 0 for 20 seconds, and target foe and another random foe swap positions.
	; Concise description
	; Skill. (20 seconds.) Target foe's attributes are set to 0. This foe and another random foe swap positions.
	Return 0
EndFunc

; Skill ID: 1900 - $GC_I_SKILL_ID_SIDE_STEP
Func CanUse_SideStep()
	Return True
EndFunc

Func BestTarget_SideStep($a_f_AggroRange)
	; Description
	; Skill. Shadow Step to a random location in the area. You gain 250 Health.
	; Concise description
	; Skill. Shadow Step to a random location in the area. You gain 250 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1906 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1907 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1908 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1909 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1910 - $GC_I_SKILL_ID_CHARM_ANIMAL_WHITE_MANTLE
Func CanUse_CharmAnimalWhiteMantle()
	Return True
EndFunc

Func BestTarget_CharmAnimalWhiteMantle($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1913 - $GC_I_SKILL_ID_CLAIM_RESOURCE_HEROES_ASCENT
Func CanUse_ClaimResourceHeroesAscent()
	Return True
EndFunc

Func BestTarget_ClaimResourceHeroesAscent($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1926 - $GC_I_SKILL_ID_LUNAR_BLESSING
Func CanUse_LunarBlessing()
	Return True
EndFunc

Func BestTarget_LunarBlessing($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1927 - $GC_I_SKILL_ID_LUCKY_AURA
Func CanUse_LuckyAura()
	Return True
EndFunc

Func BestTarget_LuckyAura($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1928 - $GC_I_SKILL_ID_SPIRITUAL_POSSESSION
Func CanUse_SpiritualPossession()
	Return True
EndFunc

Func BestTarget_SpiritualPossession($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1929 - $GC_I_SKILL_ID_WATER
Func CanUse_Water()
	Return True
EndFunc

Func BestTarget_Water($a_f_AggroRange)
	; Description
	; This article is about the effect Water. For the attribute, see Water Magic.
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1939 - $GC_I_SKILL_ID_SHROUD_OF_ASH
Func CanUse_ShroudOfAsh()
	Return True
EndFunc

Func BestTarget_ShroudOfAsh($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Shroud_of_Ash","wgRelevantArticleId":282759,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1940 - $GC_I_SKILL_ID_FLAME_CALL
Func CanUse_FlameCall()
	Return True
EndFunc

Func BestTarget_FlameCall($a_f_AggroRange)
	; Description
	; Skill. A signal horn sounds a warning that intruders have entered the temple.
	; Concise description
	; Skill. Sounds a signal horn, warning that intruders have entered the temple.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1941 - $GC_I_SKILL_ID_TORTURERS_INFERNO
Func CanUse_TorturersInferno()
	Return True
EndFunc

Func BestTarget_TorturersInferno($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1942 - $GC_I_SKILL_ID_WHIRLING_FIRES
Func CanUse_WhirlingFires()
	Return True
EndFunc

Func BestTarget_WhirlingFires($a_f_AggroRange)
	; Description
	; Skill. All foes in the area take 120 fire damage.
	; Concise description
	; Skill. Deals 120 fire damage to foes in the area.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1943 - $GC_I_SKILL_ID_CHARR_SIEGE_ATTACK_WHAT_MUST_BE_DONE
Func CanUse_CharrSiegeAttackWhatMustBeDone()
	Return True
EndFunc

Func BestTarget_CharrSiegeAttackWhatMustBeDone($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1944 - $GC_I_SKILL_ID_CHARR_SIEGE_ATTACK_AGAINST_THE_CHARR
Func CanUse_CharrSiegeAttackAgainstTheCharr()
	Return True
EndFunc

Func BestTarget_CharrSiegeAttackAgainstTheCharr($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2011 - $GC_I_SKILL_ID_GRAPPLE
Func CanUse_Grapple()
	Return True
EndFunc

Func BestTarget_Grapple($a_f_AggroRange)
	; Description
	; Skill. You and target touched foe are knocked down. You lose your current stance.
	; Concise description
	; Touch Skill. Causes knockdown. You are also knocked down. Your current stance ends.
	Return 0
EndFunc

; Skill ID: 2078 - $GC_I_SKILL_ID_BERSERK
Func CanUse_Berserk()
	Return True
EndFunc

Func BestTarget_Berserk($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, all skills do double damage and randomly give the target one of the following conditions for 10 seconds: Cripple, Bleeding, Deep Wound, Weakness, or Dazed.
	; Concise description
	; Skill. (10 seconds.) All skills do double damage and inflict one of the following random conditions (10 seconds): Cripple, Bleeding, Deep Wound, Weakness, or Dazed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2080 - $GC_I_SKILL_ID_CHOMP
Func CanUse_Chomp()
	Return True
EndFunc

Func BestTarget_Chomp($a_f_AggroRange)
	; Description
	; Skill. Caster gains 500 Health after destroying target touched smaller creature.
	; Concise description
	; Touch Skill. Gain 500 Health. Destroy target smaller creature.
	Return 0
EndFunc

; Skill ID: 2081 - $GC_I_SKILL_ID_TWISTING_JAWS
Func CanUse_TwistingJaws()
	Return True
EndFunc

Func BestTarget_TwistingJaws($a_f_AggroRange)
	; Description
	; Skill. Creature steals 120 Health from target touched foe. That foe suffers from a Deep Wound and begins Bleeding for 10 seconds.
	; Concise description
	; Touch Skill. Steals 120 Health; inflicts a Deep Wound and Bleeding (10 seconds).
	Return 0
EndFunc

; Skill ID: 2088 - $GC_I_SKILL_ID_TRAMPLE
Func CanUse_Trample()
	Return True
EndFunc

Func BestTarget_Trample($a_f_AggroRange)
	; Description
	; Skill. Target touched foe and all adjacent foes are knocked down and struck for 80 damage.
	; Concise description
	; Touch Skill. Deals 80 damage; causes knock-down. Also hits adjacent foes.
	Return 0
EndFunc

; Skill ID: 2103 - $GC_I_SKILL_ID_NECROSIS
Func CanUse_Necrosis()
	Return True
EndFunc

Func BestTarget_Necrosis($a_f_AggroRange)
	; Description
	; Skill. If target foe is suffering from a condition or hex, that foe suffers 60...90 damage.
	; Concise description
	; Skill. Deals 60...90 damage if target foe has a condition or hex.
	Local $l_i_Conditionned = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	Local $l_i_Hexed = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Conditionned <> 0 Then Return $l_i_Conditionned
	If $l_i_Hexed <> 0 Then Return $l_i_Hexed
	Return 0
EndFunc

; Skill ID: 2106 - $GC_I_SKILL_ID_CALL_OF_THE_EYE
Func CanUse_CallOfTheEye()
	Return True
EndFunc

Func BestTarget_CallOfTheEye($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2113 - $GC_I_SKILL_ID_URSAN_RAGE_BLOOD_WASHES_BLOOD
Func CanUse_UrsanRageBloodWashesBlood()
	Return True
EndFunc

Func BestTarget_UrsanRageBloodWashesBlood($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2114 - $GC_I_SKILL_ID_URSAN_STRIKE_BLOOD_WASHES_BLOOD
Func CanUse_UrsanStrikeBloodWashesBlood()
	Return True
EndFunc

Func BestTarget_UrsanStrikeBloodWashesBlood($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2115 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2118 - $GC_I_SKILL_ID_FIREBOMB
Func CanUse_Firebomb()
	Return True
EndFunc

Func BestTarget_Firebomb($a_f_AggroRange)
	; Description
	; Skill. Launch a slow-moving firebomb at this foe. This skill cannot recharge slower than normal.
	; Concise description
	; Skill. Launch a slow-moving firebomb at this foe. This skill cannot recharge slower than normal.
	Return 0
EndFunc

; Skill ID: 2119 - $GC_I_SKILL_ID_SHIELD_OF_FIRE
Func CanUse_ShieldOfFire()
	Return True
EndFunc

Func BestTarget_ShieldOfFire($a_f_AggroRange)
	; Description
	; Skill. For 20 seconds, all damage dealt to this creature is inflicted upon the attacker as well. This skill cannot recharge slower than normal.
	; Concise description
	; Skill. (20 seconds.) Damage dealt to this creature is also inflicted upon the attacker. This skill cannot recharge slower than normal.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2129 - $GC_I_SKILL_ID_VOLFEN_CLAW_CURSE_OF_THE_NORNBEAR
Func CanUse_VolfenClawCurseOfTheNornbear()
	Return True
EndFunc

Func BestTarget_VolfenClawCurseOfTheNornbear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2130 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2133 - $GC_I_SKILL_ID_VOLFEN_BLESSING_CURSE_OF_THE_NORNBEAR
Func CanUse_VolfenBlessingCurseOfTheNornbear()
	Return True
EndFunc

Func BestTarget_VolfenBlessingCurseOfTheNornbear($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2141 - $GC_I_SKILL_ID_COMPANIONSHIP
Func CanUse_Companionship()
	Return True
EndFunc

Func BestTarget_Companionship($a_f_AggroRange)
	; Description
	; Skill. If you have less Health than your pet, you are healed for 30...102...120 Health. If your pet has less Health than you, it is healed for 30...102...120 Health.
	; Concise description
	; Skill. Heals you for 30...102...120 if you have less Health than your pet. Heals your pet for 30...102...120 if it has less Health than you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2142 - $GC_I_SKILL_ID_FERAL_AGGRESSION
Func CanUse_FeralAggression()
	Return True
EndFunc

Func BestTarget_FeralAggression($a_f_AggroRange)
	; Description
	; Skill. For 5...17...20 seconds, your pet attacks 33% faster and deals +3...9...10 additional damage.
	; Concise description
	; Skill. (5...17...20 seconds.) Your pet attacks 33% faster and deals +3...9...10 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2153 - $GC_I_SKILL_ID_A_POOL_OF_WATER
Func CanUse_APoolOfWater()
	Return True
EndFunc

Func BestTarget_APoolOfWater($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2154 - $GC_I_SKILL_ID_PHASE_SHIELD_EFFECT
Func CanUse_PhaseShieldEffect()
	Return True
EndFunc

Func BestTarget_PhaseShieldEffect($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2155 - $GC_I_SKILL_ID_PHASE_SHIELD_MONSTER_SKILL
Func BestTarget_PhaseShieldMonsterSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2156 - $GC_I_SKILL_ID_VITALITY_TRANSFER
Func CanUse_VitalityTransfer()
	Return True
EndFunc

Func BestTarget_VitalityTransfer($a_f_AggroRange)
	; Description
	; Skill. Target ally is healed for 100 Health, and the nearest foe takes 100 damage.
	; Concise description
	; Skill. Heals target ally for 100; the nearest foe takes 100 damage.
	Return 0
EndFunc

; Skill ID: 2159 - $GC_I_SKILL_ID_ENERGY_BLAST_GOLEM
Func CanUse_EnergyBlastGolem()
	Return True
EndFunc

Func BestTarget_EnergyBlastGolem($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2160 - $GC_I_SKILL_ID_CHAOTIC_ENERGY
Func CanUse_ChaoticEnergy()
	Return True
EndFunc

Func BestTarget_ChaoticEnergy($a_f_AggroRange)
	; Description
	; Skill. 5 chaotic Energy sources strike up to 5 foes and deal 125 damage per strike.
	; Concise description
	; Skill. 5 chaotic energy sources strike up to 5 foes and deal 125 damage per strike.
	Return 0
EndFunc

; Skill ID: 2168 - $GC_I_SKILL_ID_RAVEN_BLESSING_A_GATE_TOO_FAR
Func CanUse_RavenBlessingAGateTooFar()
	Return True
EndFunc

Func BestTarget_RavenBlessingAGateTooFar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2169 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2173 - $GC_I_SKILL_ID_RAVEN_TALONS_A_GATE_TOO_FAR
Func CanUse_RavenTalonsAGateTooFar()
	Return True
EndFunc

Func BestTarget_RavenTalonsAGateTooFar($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2174 - $GC_I_SKILL_ID_ASPECT_OF_OAK
Func CanUse_AspectOfOak()
	Return True
EndFunc

Func BestTarget_AspectOfOak($a_f_AggroRange)
	; Description
	; Skill. Prevents the next 300 damage this creature would take.
	; Concise description
	; Skill. Prevents the next 300 damage you would take.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2179 - $GC_I_SKILL_ID_SUNDERING_SOULCRUSH
Func CanUse_SunderingSoulcrush()
	Return True
EndFunc

Func BestTarget_SunderingSoulcrush($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Sundering_Soulcrush","wgRelevantArticleId":230854,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return 0
EndFunc

; Skill ID: 2180 - $GC_I_SKILL_ID_PYROCLASTIC_SHOT
Func CanUse_PyroclasticShot()
	Return True
EndFunc

Func BestTarget_PyroclasticShot($a_f_AggroRange)
	; Description
	; Skill. Pyroclastic fragments spew forth, dealing 80 damage to target foe and all adjacent foes. Affected foes are Crippled and begin Burning for 7 seconds. This skill causes any powder keg in target's hands to explode.
	; Concise description
	; Skill. Projectile: deals 80 damage and inflicts Burning and Crippled conditions (7 seconds) on target and adjacent foes. Causes any powder keg in target's hands to explode.
	Return 0
EndFunc

; Skill ID: 2181 - $GC_I_SKILL_ID_EXPLOSIVE_FORCE
Func CanUse_ExplosiveForce()
	Return True
EndFunc

Func BestTarget_ExplosiveForce($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Explosive_Force","wgRelevantArticleId":282762,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2185 - $GC_I_SKILL_ID_POWDER_KEG_EXPLOSION
Func CanUse_PowderKegExplosion()
	Return True
EndFunc

Func BestTarget_PowderKegExplosion($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Powder_Keg_Explosion","wgRelevantArticleId":69463,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2203 - $GC_I_SKILL_ID_SPIRITLEECH_AURA
Func CanUse_SpiritleechAura()
	Return True
EndFunc

Func BestTarget_SpiritleechAura($a_f_AggroRange)
	; Description
	; Skill. For 5...17...20 seconds, all of your spirits within earshot deal 5...17...20 less damage and steal 5...17...20 Health when they attack.
	; Concise description
	; Skill. (5...17...20 seconds.) All of your spirits within earshot deal 5...17...20 less damage and steal 5...17...20 Health when they attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2207 - $GC_I_SKILL_ID_INSPIRATIONAL_SPEECH
Func CanUse_InspirationalSpeech()
	Return True
EndFunc

Func BestTarget_InspirationalSpeech($a_f_AggroRange)
	; Description
	; Skill. You lose all adrenaline and target other ally gains 1...3...4 strikes of adrenaline.
	; Concise description
	; Skill. Target ally gains 1...3...4 strike[s] of adrenaline. Cannot self-target. You lose all adrenaline.
	Return 0
EndFunc

; Skill ID: 2213 - $GC_I_SKILL_ID_EAR_BITE
Func CanUse_EarBite()
	Return True
EndFunc

Func BestTarget_EarBite($a_f_AggroRange)
	; Description
	; Skill. Target touched foe takes 50...70 piercing damage and begins Bleeding for 15...25 seconds.
	; Concise description
	; Touch Skill. Deals 50...70 piercing damage and inflicts Bleeding condition (15...25 seconds).
	Return 0
EndFunc

; Skill ID: 2214 - $GC_I_SKILL_ID_LOW_BLOW
Func CanUse_LowBlow()
	Return True
EndFunc

Func BestTarget_LowBlow($a_f_AggroRange)
	; Description
	; Skill. Strike target foe for 45...70 damage. If target foe is knocked down, that foe takes an additional 30...50 damage and suffers from Cracked Armor for 14...20 seconds.
	; Concise description
	; Touch Skill. Deals 45...70 damage. Inflicts 30...50 damage and Cracked Armor (14...20 seconds) if target foe is knocked down.
	Return 0
EndFunc

; Skill ID: 2215 - $GC_I_SKILL_ID_BRAWLING_HEADBUTT
Func CanUse_BrawlingHeadbutt()
	Return True
EndFunc

Func BestTarget_BrawlingHeadbutt($a_f_AggroRange)
	; Description
	; This article is about the Deldrimor skill. For the brawling skill with the same name, see Brawling Headbutt (Brawling skill).
	; Concise description
	; green; font-weight: bold;">45...70
	Return 0
EndFunc

; Skill ID: 2241 - $GC_I_SKILL_ID_GELATINOUS_CORPSE_CONSUMPTION
Func CanUse_GelatinousCorpseConsumption()
	Return True
EndFunc

Func BestTarget_GelatinousCorpseConsumption($a_f_AggroRange)
	; Description
	; Skill. Exploit target touched corpse to create 3 unstable oozes.
	; Concise description
	; Skill. Creates 3 unstable oozes. Exploits a fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2242 - $GC_I_SKILL_ID_GELATINOUS_MUTATION
Func CanUse_GelatinousMutation()
	Return True
EndFunc

Func BestTarget_GelatinousMutation($a_f_AggroRange)
	; Description
	; Skill. Mutating ooze creates an unstable ooze. This skill always recharges in 4 seconds.
	; Concise description
	; Skill. Mutating ooze creates an unstable ooze. This skill always recharges in 4 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2243 - $GC_I_SKILL_ID_GELATINOUS_ABSORPTION
Func CanUse_GelatinousAbsorption()
	Return True
EndFunc

Func BestTarget_GelatinousAbsorption($a_f_AggroRange)
	; Description
	; Skill. For 15 seconds, all damage dealt to the caster heals  the caster.
	; Concise description
	; Skill. (0 [sic] seconds.) Converts all damage this creatures takes to healing.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2244 - $GC_I_SKILL_ID_UNSTABLE_OOZE_EXPLOSION
Func CanUse_UnstableOozeExplosion()
	Return True
EndFunc

Func BestTarget_UnstableOozeExplosion($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Related skills">edit
	Return 0
EndFunc

; Skill ID: 2246 - $GC_I_SKILL_ID_UNSTABLE_AURA
Func CanUse_UnstableAura()
	Return True
EndFunc

Func BestTarget_UnstableAura($a_f_AggroRange)
	; Description
	; Skill. For 30 seconds, if the golem is struck by elemental damage, all of its attacks are converted to that damage type.
	; Concise description
	; Skill. (30 seconds.) If the golem takes elemental damage, its attacks are converted to that damage type.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2247 - $GC_I_SKILL_ID_UNSTABLE_PULSE
Func CanUse_UnstablePulse()
	Return True
EndFunc

Func BestTarget_UnstablePulse($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, if the golem is struck by elemental damage, all of its attacks are converted to that damage type and Unstable Pulse ends. When Unstable Pulse ends, the golem hits all adjacent foes for 175 damage.
	; Concise description
	; Skill. (10 seconds.) If the golem takes elemental damge, its attacks are converted to that damage type. End effect: adjacent foes take 175 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2331 - $GC_I_SKILL_ID_SEARING_BREATH
Func CanUse_SearingBreath()
	Return True
EndFunc

Func BestTarget_SearingBreath($a_f_AggroRange)
	; Description
	; Skill. The Great Destroyer breathes a cone of fire that hits foes for 80 fire damage and 40 more fire damage for each enchantment on them. All Destroyers in the affected area are healed for 80 Health.
	; Concise description
	; Skill. A cone of fire deals 80 fire damage and 40 more fire damage for each enchantment on struck foes. All Destroyers in the cone's area are healed for 80.
	Return 0
EndFunc

; Skill ID: 2333 - $GC_I_SKILL_ID_BRAWLING
Func CanUse_Brawling()
	Return True
EndFunc

Func BestTarget_Brawling($a_f_AggroRange)
	; Description
	; This article is about the skill. For the minigame, see Dwarven brawling.
	; Concise description
	; Acquisition">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2344 - $GC_I_SKILL_ID_CALL_OF_DESTRUCTION
Func CanUse_CallOfDestruction()
	Return True
EndFunc

Func BestTarget_CallOfDestruction($a_f_AggroRange)
	; Description
	; Skill. The Great Destroyer summons a group of Destroyers.
	; Concise description
	; Skill. Summons a group of Destroyers.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2345 - $GC_I_SKILL_ID_FLAME_JET
Func CanUse_FlameJet()
	Return True
EndFunc

Func BestTarget_FlameJet($a_f_AggroRange)
	; Description
	; Skill. A jet of lava shoots out to target foe dealing 600 damage. If that foe is under the effects of an enchantment, the damage is halved.
	; Concise description
	; Skill. Deals 600 damage. Half that damage if target is enchanted.
	Return 0
EndFunc

; Skill ID: 2346 - $GC_I_SKILL_ID_LAVA_GROUND
Func CanUse_LavaGround()
	Return True
EndFunc

Func BestTarget_LavaGround($a_f_AggroRange)
	; Description
	; Skill. The Great Destroyer creates a giant blast that melts earth into lava.
	; Concise description
	; Skill. Creates a giant blast that melts earth into lava.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2347 - $GC_I_SKILL_ID_LAVA_WAVE
Func CanUse_LavaWave()
	Return True
EndFunc

Func BestTarget_LavaWave($a_f_AggroRange)
	; Description
	; Skill. The Great Destroyer sends out a wave of lava that deals 100 fire damage to all Burning foes. While submerged in lava, the Great Destroyer gains 10 Health regeneration and is immune to all damage. Lava Wave ends after 12 seconds or if all other Destroyers are destroyed.
	; Concise description
	; Skill. Deals 100 fire damage to all Burning foes. The Great Destroyer is submerged in lava, gains +10 Health regeneration, and is immune to all damage. Lava Wave ends after 12 seconds or if all other Destroyers are destroyed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2349 - $GC_I_SKILL_ID_SPIRIT_SHIELD
Func CanUse_SpiritShield()
	Return True
EndFunc

Func BestTarget_SpiritShield($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Spirit_Shield","wgRelevantArticleId":271780,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2350 - $GC_I_SKILL_ID_SUMMONING_LORD
Func CanUse_SummoningLord()
	Return True
EndFunc

Func BestTarget_SummoningLord($a_f_AggroRange)
	; Description
	; Skill. For the next 30 seconds, all of your summoning spells take 1 second to cast instead of their normal casting time.
	; Concise description
	; Skill. For the next 30 seconds, all of your summoning spells take 1 second to cast instead of their normal casting time.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2351 - $GC_I_SKILL_ID_CHARM_ANIMAL_ASHLYN_SPIDERFRIEND
Func CanUse_CharmAnimalAshlynSpiderfriend()
	Return True
EndFunc

Func BestTarget_CharmAnimalAshlynSpiderfriend($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2352 - $GC_I_SKILL_ID_CHARR_SIEGE_ATTACK_ASSAULT_ON_THE_STRONGHOLD
Func CanUse_CharrSiegeAttackAssaultOnTheStronghold()
	Return True
EndFunc

Func BestTarget_CharrSiegeAttackAssaultOnTheStronghold($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2362 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2363 - $GC_I_SKILL_ID_TALON_STRIKE
Func CanUse_TalonStrike()
	Return True
EndFunc

Func BestTarget_TalonStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2364 - $GC_I_SKILL_ID_LAVA_BLAST
Func CanUse_LavaBlast()
	Return True
EndFunc

Func BestTarget_LavaBlast($a_f_AggroRange)
	; Description
	; Skill. Lava surges upward, knocking down all foes standing in lava and dealing 75 damage.
	; Concise description
	; Skill. Lava surges upward, knocking down all foes standing in lava and dealing 75 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2367 - $GC_I_SKILL_ID_ALKARS_CONCOCTION
Func CanUse_AlkarsConcoction()
	Return True
EndFunc

Func BestTarget_AlkarsConcoction($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2375 - $GC_I_SKILL_ID_URSAN_STRIKE
Func CanUse_UrsanStrike()
	Return True
EndFunc

Func BestTarget_UrsanStrike($a_f_AggroRange)
	; Description
	; Skill. You deal 40...75 damage, and 40...75 slashing damage to target touched foe.
	; Concise description
	; Touch Skill. Deals 40...75 damage, and 40...75 slashing damage.
	Return 0
EndFunc

; Skill ID: 2376 - $GC_I_SKILL_ID_URSAN_RAGE
Func CanUse_UrsanRage()
	Return True
EndFunc

Func BestTarget_UrsanRage($a_f_AggroRange)
	; Description
	; Skill. Touch target foe and deal 60...135 physical damage to all adjacent enemies. Struck foes are also knocked down for 2 seconds.
	; Concise description
	; Touch Skill. Deals 60...135 physical damage. Causes knock-down. Hits foes adjacent to you.
	Return 0
EndFunc

; Skill ID: 2380 - $GC_I_SKILL_ID_VOLFEN_CLAW
Func CanUse_VolfenClaw()
	Return True
EndFunc

Func BestTarget_VolfenClaw($a_f_AggroRange)
	; Description
	; Skill. You deal 40...60 damage and target touched foe suffers from Deep Wound for 2...5 seconds.
	; Concise description
	; Touch Skill. Deals 40...60 damage. Inflicts Deep Wound condition (2...5 seconds.)
	Return 0
EndFunc

; Skill ID: 2385 - $GC_I_SKILL_ID_RAVEN_TALONS
Func CanUse_RavenTalons()
	Return True
EndFunc

Func BestTarget_RavenTalons($a_f_AggroRange)
	; Description
	; Skill. Target touched foe takes 20...35 piercing damage and is Bleeding and Crippled for 4...10 seconds.
	; Concise description
	; Touch Skill. Deals 20...35 piercing damage. Inflicts Bleeding and Crippled conditions (4...10 seconds).
	Return 0
EndFunc

; Skill ID: 2389 - $GC_I_SKILL_ID_TOTEM_OF_MAN
Func CanUse_TotemOfMan()
	Return True
EndFunc

Func BestTarget_TotemOfMan($a_f_AggroRange)
	; Description
	; Skill. You lose all Energy. Your aspect returns to normal.
	; Concise description
	; Skill. Returns your aspect and skills to normal. You lose all Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2392 - $GC_I_SKILL_ID_SPAWN_PODS
Func CanUse_SpawnPods()
	Return True
EndFunc

Func BestTarget_SpawnPods($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; 20251201143025 Cache expiry: 86400 Reduced expiry: false Complications: [] CPU time usage: 0.018 seconds Real time usage: 0.027 seconds Preprocessor visited node count: 301/1000000 Post‐expand include size: 2809/2097152 bytes Template argument size: 547/2097152 bytes Highest expansion depth: 7/100 Expensive parser function count: 0/100 Unstrip recursion depth: 0/20 Unstrip post‐expand size: 0/5000000 bytes ExtLoops count: 0/1000 -->
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2393 - $GC_I_SKILL_ID_ENRAGED_BLAST
Func CanUse_EnragedBlast()
	Return True
EndFunc

Func BestTarget_EnragedBlast($a_f_AggroRange)
	; Description
	; Skill. When interrupted, the Great Destroyer becomes enraged and emits a blast of Energy that knocks down all foes within earshot and deals 115 damage.
	; Concise description
	; Skill. When interrupted, the Great Destroyer becomes enraged and emits a blast that knocks down all foes within earshot and deals 115 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2394 - $GC_I_SKILL_ID_SPAWN_HATCHLING
Func CanUse_SpawnHatchling()
	Return True
EndFunc

Func BestTarget_SpawnHatchling($a_f_AggroRange)
	; Description
	; Skill. Creates a Destroyer hatchling from a pod.
	; Concise description
	; Skill. Creates a Destroyer hatchling from a pod.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2397 - $GC_I_SKILL_ID_URSAN_AURA
Func CanUse_UrsanAura()
	Return True
EndFunc

Func BestTarget_UrsanAura($a_f_AggroRange)
	; Description
	; This article is about the unlinked temporary version. For the Norn rank version of Ursan Aura, see Ursan Blessing.
	; Concise description
	; Skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2409 - $GC_I_SKILL_ID_EXTRACT_INSCRIPTION
Func CanUse_ExtractInscription()
	Return True
EndFunc

Func BestTarget_ExtractInscription($a_f_AggroRange)
	; Description
	; Skill. Extracts an inscription from an Inscribed Ettin.
	; Concise description
	; Skill. Extracts an inscription from an Inscribed Ettin.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2416 - $GC_I_SKILL_ID_AIR_OF_SUPERIORITY
Func CanUse_AirOfSuperiority()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AIR_OF_SUPERIORITY, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc

Func BestTarget_AirOfSuperiority($a_f_AggroRange)
	; Description
	; Skill. For 20...30 seconds you gain a random Asura benefit every time you earn experience from killing an enemy.
	; Concise description
	; Skill. (20...30 seconds). Gain a random Asura benefit every time you earn experience from killing an enemy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2426 - $GC_I_SKILL_ID_DECIPHER_INSCRIPTIONS
Func CanUse_DecipherInscriptions()
	Return True
EndFunc

Func BestTarget_DecipherInscriptions($a_f_AggroRange)
	; Description
	; Skill. Applies extracted inscriptions to open a doorway.
	; Concise description
	; Skill. Deciphers Ancient Inscriptions.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2428 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2429 - $GC_I_SKILL_ID_ASURAN_FLAME_STAFF
Func CanUse_AsuranFlameStaff()
	Return True
EndFunc

Func BestTarget_AsuranFlameStaff($a_f_AggroRange)
	; Description
	; Bundle skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Asuran_Flame_Staff","wgRelevantArticleId":114095,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2433 - $GC_I_SKILL_ID_HAUNTED_GROUND
Func CanUse_HauntedGround()
	Return True
EndFunc

Func BestTarget_HauntedGround($a_f_AggroRange)
	; Description
	; Eye of the North
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2483 - $GC_I_SKILL_ID_GLOAT
Func CanUse_Gloat()
	Return True
EndFunc

Func BestTarget_Gloat($a_f_AggroRange)
	; Description
	; Skill. After killing an enemy, all Charr within earshot gain 10 Energy and 5 adrenaline.
	; Concise description
	; Skill. After killing an enemy, all Charr within earshot gain 10 Energy and 5 adrenaline.
	Return 0
EndFunc

; Skill ID: 2484 - $GC_I_SKILL_ID_METAMORPHOSIS
Func CanUse_Metamorphosis()
	Return True
EndFunc

Func BestTarget_Metamorphosis($a_f_AggroRange)
	; Description
	; Skill. Creature changes into an adult krait.
	; Concise description
	; Skill. Creature changes into an adult krait.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2485 - $GC_I_SKILL_ID_INNER_FIRE
Func CanUse_InnerFire()
	Return True
EndFunc

Func BestTarget_InnerFire($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, you gain 30 Health every second.
	; Concise description
	; Skill. (10 seconds.) You gain 30 Health every second.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2488 - $GC_I_SKILL_ID_FUNGAL_EXPLOSION
Func CanUse_FungalExplosion()
	Return True
EndFunc

Func BestTarget_FungalExplosion($a_f_AggroRange)
	; Description
	; Skill. This plant spore explodes, causing Poison and Diseased  to nearby foes; also spreads seeds for new fungus.
	; Concise description
	; Skill. The spore explodes, inflicts Poison and Disease conditions to nearby foes, and spreads seeds for new fungus.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2489 - $GC_I_SKILL_ID_BLOOD_RAGE
Func CanUse_BloodRage()
	Return True
EndFunc

Func BestTarget_BloodRage($a_f_AggroRange)
	; Description
	; Skill. For 15 seconds, you attack 25% faster and deal 25% more damage with attacks, but cannot use non-attack skills.
	; Concise description
	; Skill. (15 seconds.) Attack 25% faster and deal 25% more damage with attacks. Disables non-attack skills.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2492 - $GC_I_SKILL_ID_OOZE_COMBINATION
Func CanUse_OozeCombination()
	Return True
EndFunc

Func BestTarget_OozeCombination($a_f_AggroRange)
	; Description
	; Skill. Combine with target touched ooze.
	; Concise description
	; Touch Skill. Combine with another Ooze.
	Return 0
EndFunc

; Skill ID: 2493 - $GC_I_SKILL_ID_OOZE_DIVISION
Func CanUse_OozeDivision()
	Return True
EndFunc

Func BestTarget_OozeDivision($a_f_AggroRange)
	; Description
	; Skill. Ooze loses half of its current Health and creates a duplicate.
	; Concise description
	; Skill. Ooze loses half of its current Health and creates a duplicate.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2496 - $GC_I_SKILL_ID_SPORE_EXPLOSION
Func CanUse_SporeExplosion()
	Return True
EndFunc

Func BestTarget_SporeExplosion($a_f_AggroRange)
	; Description
	; Skill. This plant spore explodes, causing Poison and Disease to nearby foes, and spreading seeds for new plants.
	; Concise description
	; Skill. This plant spore explodes, inflicting Poison and Disease conditions on nearby foes; also spreads seeds for new plants.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2497 - $GC_I_SKILL_ID_DORMANT_HUSK
Func CanUse_DormantHusk()
	Return True
EndFunc

Func BestTarget_DormantHusk($a_f_AggroRange)
	; Description
	; Skill. This plant has 40 damage reduction and +20 Health regeneration while dormant but cannot attack or use other skills.
	; Concise description
	; Skill. This plant gains 40 damage reduction and +20 Health regeneration while dormant but cannot attack or use other skills.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2498 - $GC_I_SKILL_ID_MONKEY_SEE__MONKEY_DO
Func CanUse_MonkeySeeMonkeyDo()
	Return True
EndFunc

Func BestTarget_MonkeySeeMonkeyDo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2499 - $GC_I_SKILL_ID_FEEDING_FRENZY
Func CanUse_FeedingFrenzy()
	Return True
EndFunc

Func BestTarget_FeedingFrenzy($a_f_AggroRange)
	; Description
	; This article is about a quest. For the skill, see Feeding Frenzy (skill).
	; Concise description
	; This article is about a quest. For the skill, see Feeding Frenzy (skill).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2502 - $GC_I_SKILL_ID_SOULRENDING_SHRIEK
Func CanUse_SoulrendingShriek()
	Return True
EndFunc

Func BestTarget_SoulrendingShriek($a_f_AggroRange)
	; Description
	; Skill. Target foe takes 40 damage. If target is enchanted, that foe loses one enchantment and is Dazed for 8 seconds.
	; Concise description
	; Skill. 40 damage. Removes one enchantment and inflicts Dazed condition (8 seconds) if target foe is enchanted.
	Return 0
EndFunc

; Skill ID: 2505 - $GC_I_SKILL_ID_SIEGE_DEVOURER_FEAST
Func CanUse_SiegeDevourerFeast()
	Return True
EndFunc

Func BestTarget_SiegeDevourerFeast($a_f_AggroRange)
	; Description
	; Skill. Exploit one adjacent corpse to gain 200 Health.
	; Concise description
	; Skill. Gain 200 Health. Requires an adjacent fresh corpse.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2506 - $GC_I_SKILL_ID_DEVOURER_BITE
Func CanUse_DevourerBite()
	Return True
EndFunc

Func BestTarget_DevourerBite($a_f_AggroRange)
	; Description
	; Devourer skill
	; Concise description
	; 20251201190305 Cache expiry: 86400 Reduced expiry: false Complications: [] CPU time usage: 0.016 seconds Real time usage: 0.028 seconds Preprocessor visited node count: 282/1000000 Post‐expand include size: 2278/2097152 bytes Template argument size: 494/2097152 bytes Highest expansion depth: 7/100 Expensive parser function count: 0/100 Unstrip recursion depth: 0/20 Unstrip post‐expand size: 0/5000000 bytes ExtLoops count: 0/1000 -->
	Return 0
EndFunc

; Skill ID: 2507 - $GC_I_SKILL_ID_SIEGE_DEVOURER_SWIPE
Func CanUse_SiegeDevourerSwipe()
	Return True
EndFunc

Func BestTarget_SiegeDevourerSwipe($a_f_AggroRange)
	; Description
	; Skill. All nearby foes are struck for 100 piercing damage and are knocked down.
	; Concise description
	; Skill. Deals 100 piercing damage; causes knock-down. Affects foes near you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2508 - $GC_I_SKILL_ID_DEVOURER_SIEGE
Func CanUse_DevourerSiege()
	Return True
EndFunc

Func BestTarget_DevourerSiege($a_f_AggroRange)
	; Description
	; Skill. Launch two projectiles at target foe's location. Foes near that location are struck for 150 fire damage and knocked down. This skill cannot target a foe near you.
	; Concise description
	; Skill. Two projectiles: deal 150 fire damage; causes knock-down. Hits foes near target. Cannot target foes near you.
	Return 0
EndFunc

; Skill ID: 2513 - $GC_I_SKILL_ID_DISMOUNT_SIEGE_DEVOURER
Func CanUse_DismountSiegeDevourer()
	Return True
EndFunc

Func BestTarget_DismountSiegeDevourer($a_f_AggroRange)
	; Description
	; Skill. You dismount the siege devourer.
	; Concise description
	; Skill. Dismount the siege devourer.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2516 - $GC_I_SKILL_ID_MOUNT
Func CanUse_Mount()
	Return True
EndFunc

Func BestTarget_Mount($a_f_AggroRange)
	; Description
	; "Mount" redirects here. For temporary skills acquired in mount forms, see List of temporary skills#Mount skills.
	; Concise description
	; Notes">edit
	Return 0
EndFunc

; Skill ID: 2518 - $GC_I_SKILL_ID_TENGUS_GAZE
Func CanUse_TengusGaze()
	Return True
EndFunc

Func BestTarget_TengusGaze($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2524 - $GC_I_SKILL_ID_FORGEWIGHTS_BLESSING
Func CanUse_ForgewightsBlessing()
	Return True
EndFunc

Func BestTarget_ForgewightsBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2525 - $GC_I_SKILL_ID_SELVETARMS_BLESSING
Func CanUse_SelvetarmsBlessing()
	Return True
EndFunc

Func BestTarget_SelvetarmsBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2526 - $GC_I_SKILL_ID_THOMMISS_BLESSING
Func CanUse_ThommissBlessing()
	Return True
EndFunc

Func BestTarget_ThommissBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2529 - $GC_I_SKILL_ID_RANDS_ATTACK
Func CanUse_RandsAttack()
	Return True
EndFunc

Func BestTarget_RandsAttack($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2542 - $GC_I_SKILL_ID_CHARM_ANIMAL_MONSTER_
; Skill ID: 2545 - $GC_I_SKILL_ID_LIT_TORCH
Func CanUse_LitTorch()
	Return True
EndFunc

Func BestTarget_LitTorch($a_f_AggroRange)
	; Description
	; Skill. This torch's flame expires after 30 seconds. Bring the torch to a burning brazier to rekindle it.
	; Concise description
	; Skill. This torch's flame expires after 30 seconds. Bring the torch to a burning brazier to rekindle it.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2650 - $GC_I_SKILL_ID_CHARM_ANIMAL_CHARR_DEMOLISHER
Func CanUse_CharmAnimalCharrDemolisher()
	Return True
EndFunc

Func BestTarget_CharmAnimalCharrDemolisher($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2661 - $GC_I_SKILL_ID_THROW_ROCK
Func CanUse_ThrowRock()
	Return True
EndFunc

Func BestTarget_ThrowRock($a_f_AggroRange)
	; Description
	; Skill. Throw a rock at your target. If it strikes a foe, that foe is knocked down and becomes Crippled for 10 seconds.
	; Concise description
	; Skill. Throw a rock at your target, causing knockdown and inflicting Crippled condition (10 seconds.)
	Return 0
EndFunc

; Skill ID: 2662 - $GC_I_SKILL_ID_NIGHTMARISH_AURA
Func CanUse_NightmarishAura()
	Return True
EndFunc

Func BestTarget_NightmarishAura($a_f_AggroRange)
	; Description
	; Skill. (null)
	; Concise description
	; Skill. (null)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2663 - $GC_I_SKILL_ID_SIEGE_STRIKE
Func CanUse_SiegeStrike()
	Return True
EndFunc

Func BestTarget_SiegeStrike($a_f_AggroRange)
	; Description
	; Skill. Target foe is struck for 200 damage and knocked down.
	; Concise description
	; Skill. Deals 200 damage and causes knockdown.
	Return 0
EndFunc

; Skill ID: 2665 - $GC_I_SKILL_ID_BARBED_BOMB
Func CanUse_BarbedBomb()
	Return True
EndFunc

Func BestTarget_BarbedBomb($a_f_AggroRange)
	; Description
	; Skill. Barbed Bomb deals 100 damage and inflicts Bleeding for 5 seconds on nearby foes.
	; Concise description
	; Skill. Deal 100 damage and inflict Bleeding condition (5 seconds) to nearby enemies.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2667 - $GC_I_SKILL_ID_BALM_BOMB
Func CanUse_BalmBomb()
	Return True
EndFunc

Func BestTarget_BalmBomb($a_f_AggroRange)
	; Description
	; Skill. Balm Bomb removes 3 conditions from adjacent allies.
	; Concise description
	; Skill. Remove 3 conditions from adjacent allies.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2668 - $GC_I_SKILL_ID_EXPLOSIVES
Func CanUse_Explosives()
	Return True
EndFunc

Func BestTarget_Explosives($a_f_AggroRange)
	; Description
	; Skill. Explosives deals 100 damage to nearby enemies.
	; Concise description
	; Skill. Deal 100 damage to nearby enemies.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2669 - $GC_I_SKILL_ID_RATIONS
Func CanUse_Rations()
	Return True
EndFunc

Func BestTarget_Rations($a_f_AggroRange)
	; Description
	; Skill. Rations heal adjacent allies for 100 Health.
	; Concise description
	; Skill. Heal adjacent allies for 100.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2673 - $GC_I_SKILL_ID_STUN_BOMB
Func CanUse_StunBomb()
	Return True
EndFunc

Func BestTarget_StunBomb($a_f_AggroRange)
	; Description
	; Skill. Stun Bomb knocks down nearby enemies.
	; Concise description
	; Skill. Knock down nearby enemies.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2677 - $GC_I_SKILL_ID_GIANT_STOMP_TURAI_OSSA
Func CanUse_GiantStompTuraiOssa()
	Return True
EndFunc

Func BestTarget_GiantStompTuraiOssa($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2679 - $GC_I_SKILL_ID_JUNUNDU_SIEGE2
Func CanUse_JununduSiege2()
	; Projectile skill - cannot be used on nearby foes, needs enemy at range (same as JununduSiege1)
	If UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy") = 0 Then Return False
	; Check there's an enemy outside nearby range (projectile can't hit nearby)
	Local $l_i_NearbyCount = UAI_CountAgents(-2, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
	Local $l_i_TotalCount = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy")
	If $l_i_TotalCount <= $l_i_NearbyCount Then Return False
	Return True
EndFunc

Func BestTarget_JununduSiege2($a_f_AggroRange)
	; Elite Skill. Projectile: deals 400 earth damage and causes knock-down. Cannot be used on nearby foes.
	; Target enemy outside nearby range
	Return UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 2692 - $GC_I_SKILL_ID_FIRE_DART2
Func CanUse_FireDart2()
	Return True
EndFunc

Func BestTarget_FireDart2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2697 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2831 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2867 - $GC_I_SKILL_ID_ANCESTORS_RAGE_PvP
Func CanUse_AncestorsRagePvP()
	Return True
EndFunc

Func BestTarget_AncestorsRagePvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2894 - $GC_I_SKILL_ID_BAMPH_LITE
Func BestTarget_BamphLite($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2903 - $GC_I_SKILL_ID_REACTOR_BLAST_TIMER
Func CanUse_ReactorBlastTimer()
	Return True
EndFunc

Func BestTarget_ReactorBlastTimer($a_f_AggroRange)
	; Description
	; Skill. P.O.X. counts down from 5 before setting off a reactor blast.
	; Concise description
	; Skill. P.O.X counts down from 5 before setting off a reactor blast.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2905 - $GC_I_SKILL_ID_INTERNAL_POWER_ENGAGED
Func CanUse_InternalPowerEngaged()
	Return True
EndFunc

Func BestTarget_InternalPowerEngaged($a_f_AggroRange)
	; Description
	; Skill. P.O.X uses internal powering devices to gain 2 Health regeneration.
	; Concise description
	; Skill. P.O.X uses internal powering devices to gain 2 Health regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2910 - $GC_I_SKILL_ID_COUNTDOWN
Func CanUse_Countdown()
	Return True
EndFunc

Func BestTarget_Countdown($a_f_AggroRange)
	; Description
	; Skill. Starts charging sequence for the N.O.X.ion Buster
	; Concise description
	; Skill. Starts charging sequence for the N.O.X.ion Buster
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2918 - $GC_I_SKILL_ID_NOX_LOCK_ON
Func CanUse_NoxLockOn()
	Return True
EndFunc

Func BestTarget_NoxLockOn($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2926 - $GC_I_SKILL_ID_BAMPH_LIFESTEAL
Func BestTarget_BamphLifesteal($a_f_AggroRange)
	; Description
	; Skill. Bamph Lifesteal
	; Concise description
	; Skill. Bamph Lifesteal
	Return 0
EndFunc

; Skill ID: 2931 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2960 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2961 - $GC_I_SKILL_ID_DELAYED_BLAST_BAMPH
Func CanUse_DelayedBlastBamph()
	Return True
EndFunc

Func BestTarget_DelayedBlastBamph($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3000 - $GC_I_SKILL_ID_GUNTHERS_GAZE
Func CanUse_GunthersGaze()
	Return True
EndFunc

Func BestTarget_GunthersGaze($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3045 - $GC_I_SKILL_ID_COMFORT_ANIMAL_PvP
Func CanUse_ComfortAnimalPvP()
	Return True
EndFunc

Func BestTarget_ComfortAnimalPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3065 - $GC_I_SKILL_ID_CHARM_ANIMAL2
Func CanUse_CharmAnimal2()
	Return True
EndFunc

Func BestTarget_CharmAnimal2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3066 - $GC_I_SKILL_ID_CHARM_ANIMAL3
Func CanUse_CharmAnimal3()
	Return True
EndFunc

Func BestTarget_CharmAnimal3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3068 - $GC_I_SKILL_ID_CHARM_ANIMAL_CODEX
Func CanUse_CharmAnimalCodex()
	Return True
EndFunc

Func BestTarget_CharmAnimalCodex($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3083 - $GC_I_SKILL_ID_TOUCH_OF_DHUUM
Func CanUse_TouchOfDhuum()
	Return True
EndFunc

Func BestTarget_TouchOfDhuum($a_f_AggroRange)
	; Description
	; Skill. Steal 100 Health from target touched foe. That foe receives 15% Death Penalty. If Touch of Dhuum steals health from a foe with 60% Death Penalty, that foe dies.
	; Concise description
	; Touch Skill. Steal 100 Health from target foe. That foe receives 15% Death Penalty. If Touch of Dhuum steals health from a foe with 60% Death Penalty, that foe dies.
	Return 0
EndFunc

; Skill ID: 3144 - $GC_I_SKILL_ID_HEAL_AS_ONE_PvP
Func CanUse_HealAsOnePvP()
	Return True
EndFunc

Func BestTarget_HealAsOnePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3159 - $GC_I_SKILL_ID_CHARM_DRAKE
Func CanUse_CharmDrake()
	Return True
EndFunc

Func BestTarget_CharmDrake($a_f_AggroRange)
	; Description
	; Skill. Bandit Charms Drake.
	; Concise description
	; Skill. Bandit Charms Drake.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3160 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3161 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3175 - $GC_I_SKILL_ID_GUILD_MONUMENT_PROTECTED
Func CanUse_GuildMonumentProtected()
	Return True
EndFunc

Func BestTarget_GuildMonumentProtected($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; #808080;">No effect unless NPC is within earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3199 - $GC_I_SKILL_ID_SACRIFICE_PAWN
Func CanUse_SacrificePawn()
	Return True
EndFunc

Func BestTarget_SacrificePawn($a_f_AggroRange)
	; Description
	; Skill. Drains the life of target ally, killing them and healing the caster for an amount equal to that ally's current Health.
	; Concise description
	; Skill. Kills target ally. Caster gains Health equal to that ally's current Health.
	Return 0
EndFunc

; Skill ID: 3203 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3205 - $GC_I_SKILL_ID_ENTOURAGE
Func CanUse_Entourage()
	Return True
EndFunc

Func BestTarget_Entourage($a_f_AggroRange)
	; Description
	; Skill. For 15 second, the Guild Lord is shielded by his guards. He takes no more than 30 damage from each attack or skill and takes 30 less damage each second. This skill can only be used if there are more defending NPCs than attackers.
	; Concise description
	; Skill. (15 second[sic].) The Guild Lord takes no more than 30 damage from each attack or skill and takes 30 less damage each second. Cannot be used unless defending NPCs outnumber attackers.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3207 - $GC_I_SKILL_ID_ENTOURAGE_BUFFER
Func CanUse_EntourageBuffer()
	Return True
EndFunc

Func BestTarget_EntourageBuffer($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3209 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3303 - $GC_I_SKILL_ID_DAMAGE_ASSESSMENT
Func CanUse_DamageAssessment()
	Return True
EndFunc

Func BestTarget_DamageAssessment($a_f_AggroRange)
	; Description
	; Skill. You lose all conditions. Shadowstep directly away from target enemy.
	; Concise description
	; Skill. You lose all conditions. Shadowstep directly away from target enemy.
	Return 0
EndFunc

; Skill ID: 3305 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3370 - $GC_I_SKILL_ID_SMASH_OF_THE_TITANS
Func CanUse_SmashOfTheTitans()
	Return True
EndFunc

Func BestTarget_SmashOfTheTitans($a_f_AggroRange)
	; Description
	; Remove all enchantments from target foe. All adjacent foes are knocked down and struck for 150 damage.
	; Concise description
	; Touch Skill. Target foe loses all Enchantments. All Adjacent Foes are Knocked Down and struck for 150 damage. [sic]
	Return 0
EndFunc

; Skill ID: 3384 - $GC_I_SKILL_ID_ANNIHILATOR_TOSS
Func CanUse_AnnihilatorToss()
	Return True
EndFunc

Func BestTarget_AnnihilatorToss($a_f_AggroRange)
	; Description
	; Skill. Throw target touched foe into lava. Only works near a suitably hot lava pit.
	; Concise description
	; Touch Skill. Throw target into lava. Only works near very hot lava.
	Return 0
EndFunc

; Skill ID: 3402 - $GC_I_SKILL_ID_TONIC_TIPSINESS
Func CanUse_TonicTipsiness()
	Return True
EndFunc

Func BestTarget_TonicTipsiness($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3404 - $GC_I_SKILL_ID_GIFT_OF_BATTLE
Func CanUse_GiftOfBattle()
	Return True
EndFunc

Func BestTarget_GiftOfBattle($a_f_AggroRange)
	; Description
	; This article is about the skill. For the bundle, see Gift of Battle (bundle).
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3410 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3417 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3418 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3419 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3428 - $GC_I_SKILL_ID_SHADOW_THEFT
Func CanUse_ShadowTheft()
	Return True
EndFunc

Func BestTarget_ShadowTheft($a_f_AggroRange)
	; Description
	; Elite Skill. Shadow Step to target foe. For 5...17...20 seconds that foe's attributes are reduced by 1...4...5 and your attributes are increased by 1...4...5. This skill counts as a Lead Attack. PvE Skill
	; Concise description
	; Elite Skill. Shadow Step to target foe. For 5...17...20 seconds that foe's attributes are reduced by 1...4...5 and your attributes are increased by 1...4...5. Counts as a Lead Attack. PvE Skill
	Return 0
EndFunc

