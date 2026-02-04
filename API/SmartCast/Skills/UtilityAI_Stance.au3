#include-once

Func Anti_Stance()
	Return False
EndFunc

; Skill ID: 6 - $GC_I_SKILL_ID_MANTRA_OF_EARTH
Func CanUse_MantraOfEarth()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfEarth($a_f_AggroRange)
	; Description
	; Stance. For 30...78...90 seconds, whenever you take earth damage, the damage is reduced by 26...45...50% and you gain 2 Energy.
	; Concise description
	; Stance. (30...78...90 seconds.) Reduces earth damage you take by 26...45...50%. You gain 2 Energy when you take earth damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 7 - $GC_I_SKILL_ID_MANTRA_OF_FLAME
Func CanUse_MantraOfFlame()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfFlame($a_f_AggroRange)
	; Description
	; Stance. For 30...78...90 seconds, whenever you take fire damage, the damage is reduced by 26...45...50% and you gain 2 Energy.
	; Concise description
	; Stance. (30...78...90 seconds.) Reduces fire damage you take by 26...45...50%. You gain 2 Energy when you take fire damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 8 - $GC_I_SKILL_ID_MANTRA_OF_FROST
Func CanUse_MantraOfFrost()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfFrost($a_f_AggroRange)
	; Description
	; Stance. For 30...78...90 seconds, whenever you take cold damage, the damage is reduced by 26...45...50% and you gain 2 Energy.
	; Concise description
	; Stance. (30...78...90 seconds.) Reduces cold damage you take by 26...45...50%. You gain 2 Energy when you take cold damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 9 - $GC_I_SKILL_ID_MANTRA_OF_LIGHTNING
Func CanUse_MantraOfLightning()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfLightning($a_f_AggroRange)
	; Description
	; Stance. For 30...78...90 seconds, whenever you take lightning damage, the damage is reduced by 26...45...50% and you gain 2 Energy.
	; Concise description
	; Stance. (30...78...90 seconds.) Reduces lightning damage you take by 26...45...50%. You gain 2 Energy when you take lightning damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 10 - $GC_I_SKILL_ID_HEX_BREAKER
Func CanUse_HexBreaker()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_HexBreaker($a_f_AggroRange)
	; Description
	; Stance. For 5...65...80 seconds, the next time you are the target of a hex, that hex fails and the caster takes 10...39...46 damage.
	; Concise description
	; Stance. (5...65...80 seconds.) The next hex against you fails and the caster takes 10...39...46 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 11 - $GC_I_SKILL_ID_DISTORTION
Func CanUse_Distortion()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Distortion($a_f_AggroRange)
	; Description
	; Stance. For 1...4...5 second[s], you have a 75% chance to block attacks. Whenever you block an attack this way, you lose 2 Energy or Distortion ends.
	; Concise description
	; Stance. (1...4...5 second[s].) You have 75% chance to block. Block cost: you lose 2 Energy or Distortion ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 12 - $GC_I_SKILL_ID_MANTRA_OF_CELERITY
Func CanUse_MantraOfCelerity()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfCelerity($a_f_AggroRange)
	; Description
	; Elite Stance. For 30...78...90 seconds, your Fast Casting attribute increases by 50%. Whenever you cast a spell, you lose 3 Energy or Mantra of Celerity ends.
	; Concise description
	; Elite Stance. (30...78...90 seconds.) Your Fast Casting attribute increases by 50%. Cast cost: lose 3 Energy or Mantra of Celerity ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 13 - $GC_I_SKILL_ID_MANTRA_OF_RECOVERY
Func CanUse_MantraOfRecovery()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfRecovery($a_f_AggroRange)
	; Description
	; Elite Stance. For 5...17...20 seconds, spells you cast recharge 33% faster.
	; Concise description
	; Elite Stance. (5...17...20 seconds.) Your spells recharge 33% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 14 - $GC_I_SKILL_ID_MANTRA_OF_PERSISTENCE
Func CanUse_MantraOfPersistence()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfPersistence($a_f_AggroRange)
	; Description
	; Stance. For 5...21...25 seconds, any Illusion Magic hex you cast lasts 10...34...40% longer.
	; Concise description
	; Stance. (5...21...25 seconds.) Illusion hexes you cast last 10...34...40% longer.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 15 - $GC_I_SKILL_ID_MANTRA_OF_INSCRIPTIONS
Func CanUse_MantraOfInscriptions()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfInscriptions($a_f_AggroRange)
	; Description
	; This article is about the Core skill. For the temporarily available Bonus Mission Pack skill, see Mantra of Inscriptions (Saul D'Alessio).
	; Concise description
	; green; font-weight: bold;">5...21...25
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 16 - $GC_I_SKILL_ID_MANTRA_OF_CONCENTRATION
Func CanUse_MantraOfConcentration()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfConcentration($a_f_AggroRange)
	; Description
	; Stance. For 1...31...38 seconds, the next time you would be interrupted, you are not interrupted.
	; Concise description
	; Stance. (1...31...38 seconds.) The next time you would be interrupted, you are not interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 17 - $GC_I_SKILL_ID_MANTRA_OF_RESOLVE
Func CanUse_MantraOfResolve()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfResolve($a_f_AggroRange)
	; Description
	; Stance. For 30...78...90 seconds, you cannot be interrupted, but each time you would have been interrupted, you lose 10...5...4 Energy or Mantra of Resolve ends.
	; Concise description
	; Stance. (30...78...90 seconds.) Prevents interrupts against you. Prevention cost: lose 10...5...4 Energy or Mantra of Resolve ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 18 - $GC_I_SKILL_ID_MANTRA_OF_SIGNETS
Func CanUse_MantraOfSignets()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfSignets($a_f_AggroRange)
	; Description
	; Stance. For 10...34...40 seconds, you have +3 armor for each signet you have equipped. Whenever you use a signet you gain 5...49...60 health.
	; Concise description
	; Stance. (10...34...40 seconds.) You have +3 armor for each signet. You gain 5...49...60 health each time you use a signet.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 72 - $GC_I_SKILL_ID_ELEMENTAL_RESISTANCE
Func CanUse_ElementalResistance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ElementalResistance($a_f_AggroRange)
	; Description
	; Stance. For 30...78...90 seconds, You gain +40 armor against elemental damage, but you lose 24...14...12 armor against physical damage.
	; Concise description
	; Stance. (30...78...90 seconds.) You have +40 armor against elemental damage. You have &#45;24...14...12 armor against physical damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 73 - $GC_I_SKILL_ID_PHYSICAL_RESISTANCE
Func CanUse_PhysicalResistance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_PhysicalResistance($a_f_AggroRange)
	; Description
	; Stance. For 30...78...90 seconds, You gain +40 armor against physical damage, but you lose 24...14...12 armor against elemental damage.
	; Concise description
	; Stance. (30...78...90 seconds.) You have +40 armor against physical damage. You have &#45;24...14...12 armor against elemental damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 317 - $GC_I_SKILL_ID_BATTLE_RAGE
Func CanUse_BattleRage()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BattleRage($a_f_AggroRange)
	; Description
	; Elite Stance. For 5...17...20 seconds, you move 33% faster and gain double adrenaline from attacks. Battle Rage ends if you use any non-adrenal skills.
	; Concise description
	; Elite Stance. (5...17...20 seconds.) You move 33% faster and gain double adrenaline from your attacks. Ends if you use any non-adrenal skills.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 319 - $GC_I_SKILL_ID_RUSH
Func CanUse_Rush()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Rush($a_f_AggroRange)
	; Description
	; This article is about the Warrior skill. For the gameplay technique, see Rushing.
	; Concise description
	; green; font-weight: bold;">8...18...20
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 344 - $GC_I_SKILL_ID_FLURRY
Func CanUse_Flurry()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Flurry($a_f_AggroRange)
	; Description
	; Stance. For 5 seconds, your attack rate is increased by 33%, but you deal 25% less damage.
	; Concise description
	; Stance. (5 seconds). You attack 33% faster. You do 25% less damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 345 - $GC_I_SKILL_ID_DEFENSIVE_STANCE
Func CanUse_DefensiveStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DefensiveStance($a_f_AggroRange)
	; Description
	; Stance. For 1...4...5 second[s], you have a 75% chance to block melee and projectile attacks. When Defensive Stance ends, you gain one strike of adrenaline for each melee attack skill you have (maximum 0...3...4).
	; Concise description
	; Stance. (1...4...5 second[s].) You have 75% chance to block. End effect: gain one adrenaline for each melee attack skill you have (maximum 0...3...4).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 346 - $GC_I_SKILL_ID_FRENZY
Func CanUse_Frenzy()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Frenzy($a_f_AggroRange)
	; Description
	; Stance. For 8 seconds, you attack 33% faster but take double damage.
	; Concise description
	; Stance. (8 seconds.) You attack 33% faster. You take double damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 349 - $GC_I_SKILL_ID_SPRINT
Func CanUse_Sprint()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Sprint($a_f_AggroRange)
	; Description
	; Stance. For 8...13...14 seconds, you move 25% faster.
	; Concise description
	; Stance. (8...13...14 seconds.) You move 25% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 370 - $GC_I_SKILL_ID_BERSERKER_STANCE
Func CanUse_BerserkerStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BerserkerStance($a_f_AggroRange)
	; Description
	; Stance. For 5...10...11 seconds, you attack 33% faster and gain 50% more adrenaline. Berserker Stance ends if you use a skill.
	; Concise description
	; Stance. (5...10...11 seconds.) You attack 33% faster and gain 50% more adrenaline. Ends if you use a skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 371 - $GC_I_SKILL_ID_BALANCED_STANCE
Func CanUse_BalancedStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BalancedStance($a_f_AggroRange)
	; Description
	; Stance. For 8...18...20 seconds, you cannot be knocked down and you do not suffer extra damage from a critical attack.
	; Concise description
	; Stance. (8...18...20 seconds.) You cannot be knocked-down and do not take extra damage from critical hits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 372 - $GC_I_SKILL_ID_GLADIATORS_DEFENSE
Func CanUse_GladiatorsDefense()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_GladiatorsDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 373 - $GC_I_SKILL_ID_DEFLECT_ARROWS
Func CanUse_DeflectArrows()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DeflectArrows($a_f_AggroRange)
	; Description
	; Stance. For 1...5...6 second[s], you have a 75% chance to block attacks. If you block a projectile attack, adjacent foes suffer from Bleeding for 5...13...15 seconds.
	; Concise description
	; Stance. (1...5...6 second[s].) You have 75% chance to block attacks. Adjacent foes suffer Bleeding (5...13...15 seconds) when you block a projectile attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 375 - $GC_I_SKILL_ID_DWARVEN_BATTLE_STANCE
Func CanUse_DwarvenBattleStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DwarvenBattleStance($a_f_AggroRange)
	; Description
	; Elite Stance. For 5...10...11 seconds, if you are wielding a hammer, you attack 33% faster, you gain +40 armor, and your attack skills interrupt foes when they hit.
	; Concise description
	; Elite Stance. (5...10...11 seconds.) You attack 33% faster, you gain +40 armor, and your attack skills interrupt actions. No effect unless you have a hammer equipped.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 376 - $GC_I_SKILL_ID_DISCIPLINED_STANCE
Func CanUse_DisciplinedStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DisciplinedStance($a_f_AggroRange)
	; Description
	; Stance. For 1...3...4 second[s], you gain +10 armor and have a 75% chance to block attacks. Disciplined Stance ends if you use an adrenal skill.
	; Concise description
	; Stance. (1...3...4 second[s].) You have 75% chance to block and +10 armor. Ends if you use an adrenal skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 377 - $GC_I_SKILL_ID_WARY_STANCE
Func CanUse_WaryStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_WaryStance($a_f_AggroRange)
	; Description
	; Stance. For 1...5...6 second[s], you block any attack skills used against you. For each successful block, you gain adrenaline and 5 Energy. Wary Stance ends if you use a skill.
	; Concise description
	; Stance. (1...5...6 second[s]). You block attack skills. Gain adrenaline and 5 Energy for each block. Ends if you use a skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 378 - $GC_I_SKILL_ID_SHIELD_STANCE
Func CanUse_ShieldStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldStance($a_f_AggroRange)
	; Description
	; Stance. For 1...5...6 second[s], while wielding a shield, you have a 75% chance to block incoming attacks, and damage is reduced by 2 for each rank of Strength (maximum 15 damage reduction).
	; Concise description
	; Stance. (1...5...6 second[s].) You have 75% chance to block. Damage is reduced by 2 for each rank of Strength (maximum 15 damage reduction). No effect unless you have a shield equipped.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 379 - $GC_I_SKILL_ID_BULLS_CHARGE
Func CanUse_BullsCharge()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BullsCharge($a_f_AggroRange)
	; Description
	; Elite Stance. For 5...10...11 seconds, you move 33% faster and if you strike a moving foe in melee, that foe is knocked down. Bull's Charge ends if you use a skill.
	; Concise description
	; Elite Stance. (5...10...11 seconds.) You move 33% faster. Causes knock-down if you hit a moving foe in melee. Ends if you use a skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 380 - $GC_I_SKILL_ID_BONETTIS_DEFENSE
Func CanUse_BonettisDefense()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BonettisDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 425 - $GC_I_SKILL_ID_DODGE
Func CanUse_Dodge()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Dodge($a_f_AggroRange)
	; Description
	; This article is about the Ranger skill. For the game mechanic, see Line of sight.
	; Concise description
	; green; font-weight: bold;">5...10...11
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 448 - $GC_I_SKILL_ID_ESCAPE
Func CanUse_Escape()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Escape($a_f_AggroRange)
	; Description
	; Elite Stance. For 1...7...8 second[s], you move 33% faster and have a 75% chance to block attacks.
	; Concise description
	; Elite Stance. (1...7...8 second[s].) You move 33% faster and have 75% chance to block.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 449 - $GC_I_SKILL_ID_PRACTICED_STANCE
Func CanUse_PracticedStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_PracticedStance($a_f_AggroRange)
	; Description
	; Elite Stance. For 20...32...35 seconds, your Preparations recharge 50% faster and last 30...126...150% longer.
	; Concise description
	; Elite Stance. (20...32...35 seconds.) Your preparations recharge 50% faster and last 30...126...150% longer.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 450 - $GC_I_SKILL_ID_WHIRLING_DEFENSE
Func CanUse_WhirlingDefense()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_WhirlingDefense($a_f_AggroRange)
	; Description
	; Stance. For 8...18...20 seconds, you have 75% chance to block attacks. Whenever you block a projectile in this way, adjacent foes take 5...10...11 damage.
	; Concise description
	; Stance. (8...18...20 seconds.) You have 75% chance to block. Deals 5...10...11 damage to adjacent foes whenever you block a projectile attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 451 - $GC_I_SKILL_ID_MELANDRUS_RESILIENCE
Func CanUse_MelandrusResilience()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MelandrusResilience($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 452 - $GC_I_SKILL_ID_DRYDERS_DEFENSES
Func CanUse_DrydersDefenses()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DrydersDefenses($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 453 - $GC_I_SKILL_ID_LIGHTNING_REFLEXES
Func CanUse_LightningReflexes()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_LightningReflexes($a_f_AggroRange)
	; Description
	; Stance. For 5...10...11 seconds, you have a 75% chance to block melee and projectile attacks, and you attack 33% faster.
	; Concise description
	; Stance. (5...10...11 seconds.) You attack 33% faster and have 75% chance to block.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 454 - $GC_I_SKILL_ID_TIGERS_FURY
Func CanUse_TigersFury()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_TigersFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 455 - $GC_I_SKILL_ID_STORM_CHASER
Func CanUse_StormChaser()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_StormChaser($a_f_AggroRange)
	; Description
	; Stance. For 8...18...20 seconds, you move 25% faster, and you gain 1...4...5 Energy whenever you take elemental damage.
	; Concise description
	; Stance. (8...18...20 seconds.) You move 25% faster and gain 1...4...5 Energy whenever you take elemental damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 456 - $GC_I_SKILL_ID_SERPENTS_QUICKNESS
Func CanUse_SerpentsQuickness()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SerpentsQuickness($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 535 - $GC_I_SKILL_ID_JAGGED_CRYSTAL_SKIN
Func CanUse_JaggedCrystalSkin()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_JaggedCrystalSkin($a_f_AggroRange)
	; Description
	; Stance. (monster only) For 10 seconds, whenever you are hit by physical damage, nearby foes take 100 damage.
	; Concise description
	; Stance. (monster only) (10 seconds.) 100 damage to foes near you whenever you take physical damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 540 - $GC_I_SKILL_ID_EMBRACE_THE_PAIN
Func CanUse_EmbraceThePain()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_EmbraceThePain($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 572 - $GC_I_SKILL_ID_DEADLY_PARADOX
Func CanUse_DeadlyParadox()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DeadlyParadox($a_f_AggroRange)
	; Description
	; Stance. All of your attack skills are disabled for 10 seconds. For 5...13...15 seconds, your Assassin skills activate and recharge 33% faster.
	; Concise description
	; Stance. (5...13...15 seconds.) Your Assassin skills activate and recharge 33% faster. Disables your attack skills (10 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 811 - $GC_I_SKILL_ID_RUN_AS_ONE
Func CanUse_RunAsOne()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RunAsOne($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 831 - $GC_I_SKILL_ID_PRIMAL_RAGE
Func CanUse_PrimalRage()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_PrimalRage($a_f_AggroRange)
	; Description
	; Elite Stance. For 1...12...15 second[s], you attack 33% faster and move 25% faster, but you take double damage.
	; Concise description
	; Elite Stance. (1...12...15 second[s].) You attack 33% faster and move 25% faster. You take double damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 929 - $GC_I_SKILL_ID_SHADOW_OF_HASTE
Func CanUse_ShadowOfHaste()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowOfHaste($a_f_AggroRange)
	; Description
	; Stance. For 10...34...40 seconds you move 15% faster than normal. When Shadow of Haste ends, you shadow step to your original location.
	; Concise description
	; Stance. (10...34...40 seconds.) You move 15% faster. End effect: return to your original location.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 995 - $GC_I_SKILL_ID_TIGER_STANCE
Func CanUse_TigerStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_TigerStance($a_f_AggroRange)
	; Description
	; Stance. For 4...9...10 seconds, you attack 33% faster. Tiger Stance ends if any of your attacks fail to hit.
	; Concise description
	; Stance. (4...9...10 seconds.) You attack 33% faster. Ends if you fail to hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1005 - $GC_I_SKILL_ID_ICE_SKATES
Func CanUse_IceSkates()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_IceSkates($a_f_AggroRange)
	; Description
	; Elementalist
	; Concise description
	; Trivia">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1037 - $GC_I_SKILL_ID_DARK_ESCAPE
Func CanUse_DarkEscape()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DarkEscape($a_f_AggroRange)
	; Description
	; Stance. For 5...13...15 seconds, you move 25% faster and take half damage. Dark Escape ends if you successfully hit with an attack.
	; Concise description
	; Stance. (5...13...15 seconds.) You move 25% faster and take half damage. Ends if you hit with an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1041 - $GC_I_SKILL_ID_UNSEEN_FURY
Func CanUse_UnseenFury()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_UnseenFury($a_f_AggroRange)
	; Description
	; Stance. All adjacent foes are Blinded for 3...9...10 seconds. For 10...26...30 seconds, you cannot be blocked by Blinded foes.
	; Concise description
	; Stance. Inflicts Blindness condition on adjacent foes (3...9...10). You cannot be blocked by Blinded foes for 10...26...30 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1042 - $GC_I_SKILL_ID_FLASHING_BLADES
Func CanUse_FlashingBlades()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_FlashingBlades($a_f_AggroRange)
	; Description
	; Elite Stance. For 5...25...30 seconds, you have a 75% chance to block incoming attacks while attacking. If you block an attack in this way, your attacker takes 5...17...20 damage.
	; Concise description
	; Elite Stance. (5...25...30 seconds.) You have 75% chance to block while attacking. Block effect: 5...17...20 damage to your attacker.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1043 - $GC_I_SKILL_ID_DASH
Func CanUse_Dash()
	If Anti_Stance() Then Return False
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsMoving) Then Return False
	Return True
EndFunc

Func BestTarget_Dash($a_f_AggroRange)
	; Description
	; Stance. For 3 seconds, you run 50% faster.
	; Concise description
	; Stance. (3 seconds.) You move 50% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1142 - $GC_I_SKILL_ID_AUSPICIOUS_PARRY
Func CanUse_AuspiciousParry()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_AuspiciousParry($a_f_AggroRange)
	; Description
	; Elite Stance. For 8 seconds, the next attack against you is blocked. You gain 1...3...4 strike[s] of adrenaline when this stance ends.
	; Concise description
	; Elite Stance. (8 seconds.) Blocks one attack. End effect: you gain 1...3...4 strike[s] of adrenaline.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1172 - $GC_I_SKILL_ID_TURTLE_SHELL
Func CanUse_TurtleShell()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_TurtleShell($a_f_AggroRange)
	; Description
	; Stance. Reduces damage from non-critical hits.
	; Concise description
	; Stance. Reduces damage from non-critical hits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1182 - $GC_I_SKILL_ID_RENEWING_CORRUPTION
Func CanUse_RenewingCorruption()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RenewingCorruption($a_f_AggroRange)
	; Description
	; Stance. For 20 seconds, if Kuunavang is in casting range when this creature dies, Kuunavang is healed for 500 Health.
	; Concise description
	; Stance. (20 seconds.) If Kuunavang is in casting range when this creature dies, Kuunavang is healed for 500 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1196 - $GC_I_SKILL_ID_ZOJUNS_HASTE
Func CanUse_ZojunsHaste()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ZojunsHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1209 - $GC_I_SKILL_ID_BESTIAL_FURY
Func CanUse_BestialFury()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BestialFury($a_f_AggroRange)
	; Description
	; Stance. All your non-attack skills are disabled for 5 seconds. For 5...10...11 seconds, you attack 25% faster.
	; Concise description
	; Stance. (5...10...11 seconds.) You attack 25% faster. Your non-attack skills are disabled (5 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1270 - $GC_I_SKILL_ID_FINGERS_OF_CHAOS
Func CanUse_FingersOfChaos()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_FingersOfChaos($a_f_AggroRange)
	; Description
	; Stance. (monster only) For 5 seconds, your attacks: cannot miss rangers; remove enchantments from monks; cause conditions on warriors; interrupt elementalists; and lose a hex when attacking necros.
	; Concise description
	; Stance. (monster only) (5 seconds.) Your attacks cannot miss Rangers, remove enchantments from Monks, cause conditions on Warriors, interrupt Elementalists, and remove a hex when attacking Necromancers.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1274 - $GC_I_SKILL_ID_BATTLE_SCARS
Func CanUse_BattleScars()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BattleScars($a_f_AggroRange)
	; Description
	; Stance. For 7 seconds, Shiro's attacks gain life stealing equal to the highest damage he takes while in this stance.
	; Concise description
	; Stance. (7 seconds.) Shiro's attacks gain life stealing equal to the highest damage he takes while in this stance.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1275 - $GC_I_SKILL_ID_RIPOSTING_SHADOWS
Func CanUse_RipostingShadows()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RipostingShadows($a_f_AggroRange)
	; Description
	; Stance. For 20 seconds, Shiro Shadow Steps to the next foe who attacks you  and attempts a return attack. If this attack hits, Riposting Shadows is renewed.
	; Concise description
	; Stance. (20 seconds.) Shiro Shadow Steps to the next foe who attacks target and attempts a return attack. If this attack hits, Riposting Shadows is renewed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1404 - $GC_I_SKILL_ID_FLAIL
Func CanUse_Flail()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Flail($a_f_AggroRange)
	; Description
	; Stance. For 1...12...15 second[s], you attack 33% faster but move 33% slower.
	; Concise description
	; Stance. (1...12...15 second[s].) You attack 33% faster. You move 33% slower.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1405 - $GC_I_SKILL_ID_CHARGING_STRIKE
Func CanUse_ChargingStrike()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ChargingStrike($a_f_AggroRange)
	; Description
	; Elite Stance. For 1...8...10 second[s], you run 33% faster. Your next successful melee hit does +10...34...40 damage and this stance ends. This stance ends if you use a skill.
	; Concise description
	; Elite Stance. (1...8...10 second[s].) You move 33% faster and deal +10...34...40 damage with your next melee hit. Ends when you hit or if you use a skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1413 - $GC_I_SKILL_ID_BURST_OF_AGGRESSION
Func CanUse_BurstOfAggression()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BurstOfAggression($a_f_AggroRange)
	; Description
	; Stance. For 2...8...10 seconds, you attack 33% faster. When this stance ends, you lose all adrenaline.
	; Concise description
	; Stance. (2...8...10 seconds.) You attack 33% faster. End effect: lose all adrenaline.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1414 - $GC_I_SKILL_ID_ENRAGING_CHARGE
Func CanUse_EnragingCharge()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_EnragingCharge($a_f_AggroRange)
	; Description
	; Stance. For 5...13...15 seconds, you move 25% faster. Enraging Charge ends when you successfully strike a target, at which point you gain 0...2...3 strike[s] of adrenaline if you hit with a melee attack.
	; Concise description
	; Stance. (5...13...15 seconds.) You move 25% faster. Gain +0...2...3 adrenaline on your next melee attack. Ends after your next hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1436 - $GC_I_SKILL_ID_CORRUPTED_STRENGTH
Func CanUse_CorruptedStrength()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_CorruptedStrength($a_f_AggroRange)
	; Description
	; Stance. For 10 seconds, all corrupted plants in the area do not take physical and elemental damage.
	; Concise description
	; Stance. (10 seconds.) All corrupted plants in the area are invulnerable to physical and elemental damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1442 - $GC_I_SKILL_ID_JUNUNDU_TUNNEL
Func CanUse_JununduTunnel()
	If Anti_Stance() Then Return False
	; Stance for movement speed and knockdown on adjacent foes when emerging
	; Best used when there are adjacent enemies to knockdown
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") > 0 Then Return True
	Return False
EndFunc

Func BestTarget_JununduTunnel($a_f_AggroRange)
	; Stance. Invulnerable while tunneling. Knocks-down adjacent foes (3 seconds) when emerging.
	; Self-target stance
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1474 - $GC_I_SKILL_ID_STORMS_EMBRACE
Func CanUse_StormsEmbrace()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_StormsEmbrace($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1475 - $GC_I_SKILL_ID_TRAPPERS_SPEED
Func CanUse_TrappersSpeed()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_TrappersSpeed($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1542 - $GC_I_SKILL_ID_PIOUS_CONCENTRATION
Func CanUse_PiousConcentration()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_PiousConcentration($a_f_AggroRange)
	; Description
	; Stance. For 5...17...20 seconds, you cannot be interrupted, but each time you would have been interrupted, you lose 1 Dervish enchantment or Pious Concentration ends.
	; Concise description
	; Stance. (5...17...20 seconds.) Prevents interrupts. Prevention cost: you lose one Dervish enchantment or Pious Concentration ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1543 - $GC_I_SKILL_ID_PIOUS_HASTE
Func CanUse_PiousHaste()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_PiousHaste($a_f_AggroRange)
	; Description
	; Stance. You remove 1 Dervish enchantment and for 1...6...7 second[s] you move 25% faster. If an enchantment was removed you move 50% faster instead.
	; Concise description
	; Stance. (1...6...7 second[s].) Lose 1 Dervish enchantment and move 25% faster. Removal Effect: Run 50% faster instead.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1582 - $GC_I_SKILL_ID_REMOVE_LEADERSHIP_SKILL
Func CanUse_RemoveLeadershipSkill()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveLeadershipSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1615 - $GC_I_SKILL_ID_REMOVE_QUEEN_ARMOR
Func CanUse_RemoveQueenArmor()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveQueenArmor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1618 - $GC_I_SKILL_ID_QUEEN_ARMOR
Func CanUse_QueenArmor()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_QueenArmor($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1649 - $GC_I_SKILL_ID_WAY_OF_THE_ASSASSIN
Func CanUse_WayOfTheAssassin()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfTheAssassin($a_f_AggroRange)
	; Description
	; Elite Stance. For the next 20 seconds while wielding daggers, you attack 5...17...20% faster and have a +5...29...35% chance to land a critical hit.
	; Concise description
	; Elite Stance. (20 seconds.) While wielding daggers, you attack 5...17...20% faster and have +5...29...35% chance to land a critical hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1650 - $GC_I_SKILL_ID_SHADOW_WALK
Func CanUse_ShadowWalk()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowWalk($a_f_AggroRange)
	; Description
	; Stance. Shadow Step to target foe. For 15 seconds nothing happens. Your attack skills are disabled for 1 second, and your stances and enchantments are disabled for 10 seconds. When this stance ends, you return to your original location.
	; Concise description
	; Stance. (15 seconds.) Shadow Step to target foe. End effect: return to your original location. Disables your attack skills for 1 second. Disables your stances and enchantments for 10 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1658 - $GC_I_SKILL_ID_SYMBOLIC_POSTURE
Func CanUse_SymbolicPosture()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SymbolicPosture($a_f_AggroRange)
	; Description
	; Stance. For 5...17...20 seconds, the next signet you activate recharges 20...68...80% faster.
	; Concise description
	; Stance. (5...17...20 seconds.) Your next signet recharges 20...68...80% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1698 - $GC_I_SKILL_ID_SOLDIERS_STANCE
Func CanUse_SoldiersStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SoldiersStance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1699 - $GC_I_SKILL_ID_SOLDIERS_DEFENSE
Func CanUse_SoldiersDefense()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SoldiersDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1700 - $GC_I_SKILL_ID_FRENZIED_DEFENSE
Func CanUse_FrenziedDefense()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_FrenziedDefense($a_f_AggroRange)
	; Description
	; Stance. For 8 seconds, you have a 75% chance to block incoming attacks, but take double damage.
	; Concise description
	; Stance. (8 seconds.) You have 75% chance to block. You take double damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1701 - $GC_I_SKILL_ID_STEADY_STANCE
Func CanUse_SteadyStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SteadyStance($a_f_AggroRange)
	; Description
	; Elite Stance. For 10 seconds, the next time you would be knocked down, you gain 1...3...3 strike[s] of adrenaline and 1...6...7 Energy instead.
	; Concise description
	; Elite Stance. (10 seconds.) The next time you would be knocked-down, you gain 1...3...3 adrenaline and 1...6...7 Energy instead.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1724 - $GC_I_SKILL_ID_EXPERTS_DEXTERITY
Func CanUse_ExpertsDexterity()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ExpertsDexterity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1727 - $GC_I_SKILL_ID_NATURAL_STRIDE
Func CanUse_NaturalStride()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_NaturalStride($a_f_AggroRange)
	; Description
	; Stance. For 1...7...8 second[s], you run 33% faster and have a 50% chance to block incoming attacks. Natural Stride ends if you become hexed or enchanted.
	; Concise description
	; Stance. (1...7...8 second[s].) You move 33% faster and have 50% chance to block. Ends if you become hexed or enchanted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1728 - $GC_I_SKILL_ID_HEKETS_RAMPAGE
Func CanUse_HeketsRampage()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_HeketsRampage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1762 - $GC_I_SKILL_ID_HEART_OF_FURY
Func CanUse_HeartOfFury()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_HeartOfFury($a_f_AggroRange)
	; Description
	; Stance. For 2...8...10 seconds, you attack 25% faster.
	; Concise description
	; Stance. (2...8...10 seconds.) You attack 25% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1785 - $GC_I_SKILL_ID_NATURES_SPEED
Func CanUse_NaturesSpeed()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_NaturesSpeed($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1937 - $GC_I_SKILL_ID_INFERNAL_RAGE
Func CanUse_InfernalRage()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_InfernalRage($a_f_AggroRange)
	; Description
	; Stance. For 45 seconds, this creature has +1,000 maximum Health and attacks 33% faster, and its melee attacks hit target and nearby foes.
	; Concise description
	; Stance. (45 seconds.) Your melee attacks hit nearby foes. You gain +1,000 maximum Health and attack 33% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2126 - $GC_I_SKILL_ID_SPIRIT_SENSES
Func CanUse_SpiritSenses()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritSenses($a_f_AggroRange)
	; Description
	; Stance. For 15 seconds, this creature cannot be Blinded or Weakened, and its attacks are unblockable and steal 75 Health.
	; Concise description
	; Stance. (15 seconds.) You cannot be Blinded or Weakened; attacks are unblockable and steal 75 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2132 - $GC_I_SKILL_ID_VOLFEN_AGILITY_CURSE_OF_THE_NORNBEAR
Func CanUse_VolfenAgilityCurseOfTheNornbear()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenAgilityCurseOfTheNornbear($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2134 - $GC_I_SKILL_ID_CHARGING_SPIRIT
Func CanUse_ChargingSpirit()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ChargingSpirit($a_f_AggroRange)
	; Description
	; Stance. Run 25% faster for 5 seconds. The next attack that successfully hits deal +50 damage, cause this skill to end, and all adjacent foes are knocked down.
	; Concise description
	; Stance. (5 seconds.) You move 25% faster. Your next attack deals +50 damage and causes knock-down to all adjacent foes. Ends when you hit with an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2136 - $GC_I_SKILL_ID_SMOKE_POWDER_DEFENSE
Func CanUse_SmokePowderDefense()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SmokePowderDefense($a_f_AggroRange)
	; Description
	; Stance. For 8 seconds, the next time you are struck, you take half damage and all adjacent foes are Blinded for 2...5...6 seconds.
	; Concise description
	; Stance. (8 seconds.) The next time you are struck, you take half damage and inflict Blindness condition (2...5...6 seconds) on adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2146 - $GC_I_SKILL_ID_PIOUS_FURY
Func CanUse_PiousFury()
	If Anti_Stance() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc

Func BestTarget_PiousFury($a_f_AggroRange)
	; Description
	; Stance. Remove 1 Dervish enchantment. For 1...6...7 second[s], you attack 25% faster. If an enchantment was removed, this stance lasts twice as long.
	; Concise description
	; Stance. (1...6...7 second[s].)You [sic] attack 25% faster and remove 1 of your Dervish enchantments. Removal effect: this stance lasts twice as long.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2170 - $GC_I_SKILL_ID_RAVEN_FLIGHT_A_GATE_TOO_FAR
Func CanUse_RavenFlightAGateTooFar()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RavenFlightAGateTooFar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2177 - $GC_I_SKILL_ID_RAGE_OF_THE_JOTUN
Func CanUse_RageOfTheJotun()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RageOfTheJotun($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2196 - $GC_I_SKILL_ID_SOLDIERS_SPEED
Func CanUse_SoldiersSpeed()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SoldiersSpeed($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2218 - $GC_I_SKILL_ID_DRUNKEN_MASTER
Func CanUse_DrunkenMaster()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DrunkenMaster($a_f_AggroRange)
	; Description
	; Stance. For 72...90 seconds, your movement and attack speeds are increased by 10...15%. If you are drunk while activating this skill, your movement and attack speeds are increased by 25...33% instead.
	; Concise description
	; Stance. (72...90 seconds.) You move and attack 10...15% faster if you are not drunk. You move and attack 25...33% faster if you are drunk.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2334 - $GC_I_SKILL_ID_BRAWLING_BLOCK
Func CanUse_BrawlingBlock()
	If UAI_Filter_IsDazed(UAI_GetPlayerInfo($GC_UAI_AGENT_ID)) Then Return False
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingBlock($a_f_AggroRange)
	; Description
	; Stance. For 2 seconds, you block the next attack. This skill ends if you use an attack skill. You cannot use this skill if you are Dazed.
	; Concise description
	; Stance. (2 seconds.) Block the next attack. Ends if you use an attack skill. You cannot use this skill if you are Dazed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2381 - $GC_I_SKILL_ID_VOLFEN_POUNCE
Func CanUse_VolfenPounce()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenPounce($a_f_AggroRange)
	; Description
	; Stance. You run 15...33% faster for 10...20 seconds and deal 60...100 damage to adjacent targets while this skill is active. Dealing damage causes this skill to end.
	; Concise description
	; Stance. (10...20 seconds.) You move 15...33% faster and deal 60...100 damage to adjacent targets. Ends when you deal damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2388 - $GC_I_SKILL_ID_RAVEN_FLIGHT
Func CanUse_RavenFlight()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RavenFlight($a_f_AggroRange)
	; Description
	; Stance. For 5...15 seconds, you cannot be knocked down.
	; Concise description
	; Stance. (5...15 seconds.) You cannot be knocked-down.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2396 - $GC_I_SKILL_ID_URSAN_FORCE_BLOOD_WASHES_BLOOD
Func CanUse_UrsanForceBloodWashesBlood()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_UrsanForceBloodWashesBlood($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2509 - $GC_I_SKILL_ID_HYAHHHHH1
Func CanUse_Hyahhhhh1()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Hyahhhhh1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2510 - $GC_I_SKILL_ID_HYAHHHHH2
Func CanUse_Hyahhhhh2()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Hyahhhhh2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2511 - $GC_I_SKILL_ID_HYAHHHHH3
Func CanUse_Hyahhhhh3()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Hyahhhhh3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2512 - $GC_I_SKILL_ID_HYAHHHHH4
Func CanUse_Hyahhhhh4()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Hyahhhhh4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2541 - $GC_I_SKILL_ID_GOLEM_BOOSTERS
Func CanUse_GolemBoosters()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_GolemBoosters($a_f_AggroRange)
	; Description
	; Stance. For 8 seconds, you move 100% faster. While this skill is active, your next attack knocks down target foe, and this skill ends.
	; Concise description
	; Stance. (8 seconds.) You move 100% faster. Your next attack causes knock-down and this skill ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2660 - $GC_I_SKILL_ID_FLEE
Func CanUse_Flee()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_Flee($a_f_AggroRange)
	; Description
	; Stance. For 10 seconds, you move 33% faster.
	; Concise description
	; Stance. (10 seconds.) You move 33% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2680 - $GC_I_SKILL_ID_DISTORTION_GWEN
Func CanUse_DistortionGwen()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DistortionGwen($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2726 - $GC_I_SKILL_ID_STRENGTH_OF_PURITY
Func CanUse_StrengthOfPurity()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_StrengthOfPurity($a_f_AggroRange)
	; Description
	; Stance. Your next 1...3...4 attacks strike for +1...10...12 damage and deal holy damage. If these attacks are blocked or miss, your target loses one 1 enchantment and you lose 1 hex.
	; Concise description
	; Stance. Your next 1...3...4 attacks strike for +1...10...12 damage and deal holy damage. If these attacks are blocked or miss, your target loses one 1 enchantment and you lose 1 hex.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2728 - $GC_I_SKILL_ID_WAY_OF_THE_PURE
Func CanUse_WayOfThePure()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfThePure($a_f_AggroRange)
	; Description
	; Stance. For 5...11...13 seconds, you attack and move 25% faster, and your critical hits remove an enchantment from target foe.
	; Concise description
	; Stance. Attack and move 25% faster (5...11...13 seconds). Your critical hits remove an enchantment from target foe.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2882 - $GC_I_SKILL_ID_MANTRA_OF_INSCRIPTIONS_PvP
Func CanUse_MantraOfInscriptionsPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfInscriptionsPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2908 - $GC_I_SKILL_ID_NOX_FIELD_DASH
Func CanUse_NoxFieldDash()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_NoxFieldDash($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2959 - $GC_I_SKILL_ID_EXPERTS_DEXTERITY_PvP
Func CanUse_ExpertsDexterityPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ExpertsDexterityPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3002 - $GC_I_SKILL_ID_WARRIORS_ENDURANCE_PvP
Func CanUse_WarriorsEndurancePvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_WarriorsEndurancePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3049 - $GC_I_SKILL_ID_UNSEEN_FURY_PvP
Func CanUse_UnseenFuryPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_UnseenFuryPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3052 - $GC_I_SKILL_ID_CONVICTION_PvP
Func CanUse_ConvictionPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ConvictionPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3060 - $GC_I_SKILL_ID_ESCAPE_PvP
Func CanUse_EscapePvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_EscapePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3063 - $GC_I_SKILL_ID_MANTRA_OF_RESOLVE_PvP
Func CanUse_MantraOfResolvePvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfResolvePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3070 - $GC_I_SKILL_ID_SUGAR_RUSH_AGENT_OF_THE_MAD_KING
Func CanUse_SugarRushAgentOfTheMadKing()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SugarRushAgentOfTheMadKing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3141 - $GC_I_SKILL_ID_LIGHTNING_REFLEXES_PvP
Func CanUse_LightningReflexesPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_LightningReflexesPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3156 - $GC_I_SKILL_ID_SOLDIERS_STANCE_PvP
Func CanUse_SoldiersStancePvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SoldiersStancePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3166 - $GC_I_SKILL_ID_DRUNKEN_STUMBLING
Func CanUse_DrunkenStumbling()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DrunkenStumbling($a_f_AggroRange)
	; Description
	; Stance. For 10 seconds, you attack 33% faster and cannot be knocked down. Whenever you would be knocked down, you gain 1 adrenaline and all adjacent foes take 50 damage.
	; Concise description
	; Stance. (10 seconds.) You attack 33% faster and cannot be knocked down. If hit with a knockdown, you gain 1 adrenaline and adjacent foes take 50 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3179 - $GC_I_SKILL_ID_MANTRA_OF_SIGNETS_PvP
Func CanUse_MantraOfSignetsPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfSignetsPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3201 - $GC_I_SKILL_ID_TORIIMOS_BURNING_FURY
Func CanUse_ToriimosBurningFury()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_ToriimosBurningFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3204 - $GC_I_SKILL_ID_DEFY_PAIN_PvP
Func CanUse_DefyPainPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_DefyPainPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3239 - $GC_I_SKILL_ID_NATURES_BLESSING
Func CanUse_NaturesBlessing()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_NaturesBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3247 - $GC_I_SKILL_ID_SURVIVORS_WILL
Func CanUse_SurvivorsWill()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SurvivorsWill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3294 - $GC_I_SKILL_ID_RIOT_SHIELD
Func CanUse_RiotShield()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_RiotShield($a_f_AggroRange)
	; Description
	; Stance. For 10 seconds, you have a 100% chance to block attacks, and spells targeting you fail. Riot Shield ends if you move.
	; Concise description
	; Stance. (10 seconds.) You have a 100% chance to block attacks. Spells targeting you fail. Ends if you move.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3366 - $GC_I_SKILL_ID_HEART_OF_FURY_PvP
Func CanUse_HeartOfFuryPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_HeartOfFuryPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3368 - $GC_I_SKILL_ID_PIOUS_FURY_PvP
Func CanUse_PiousFuryPvP()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_PiousFuryPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3426 - $GC_I_SKILL_ID_SEVEN_WEAPONS_STANCE
Func CanUse_SevenWeaponsStance()
	If Anti_Stance() Then Return False
	Return True
EndFunc

Func BestTarget_SevenWeaponsStance($a_f_AggroRange)
	; Description
	; "SWS" redirects here. For Stone Summit tactics shield, see Summit Warlord Shield.
	; Concise description
	; green; font-weight: bold;">3...17...20
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
