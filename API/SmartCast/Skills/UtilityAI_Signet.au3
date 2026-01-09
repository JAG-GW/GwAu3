#include-once

;If there is the effect return true
Func Anti_Signet()
	Return UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE)
EndFunc

Func CanUse_SignetOfCapture()
	Return False
EndFunc

Func BestTarget_SignetOfCapture($a_f_AggroRange)
	; Description
	; Signet. Choose one skill from a nearby dead Boss of your profession. Signet of Capture is permanently replaced by that skill. If that skill was elite, gain 250 XP for every level you have earned.
	; Concise description
	; Signet. Choose one skill from a nearby dead Boss of your profession. Signet of Capture is permanently replaced by that skill. If that skill was elite, gain 250 XP for every level you have earned.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AntidoteSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_AntidoteSignet($a_f_AggroRange)
	; Description
	; Signet. Cleanse yourself of Poison, Disease, and Blindness, and one additional condition.
	; Concise description
	; Signet. Remove Poison, Disease, and Blindness from yourself, and one additional condition.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ArchersSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_ArchersSignet($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_BaneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BaneSignet($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 26...50...56 holy damage. If target foe was attacking, that foe is knocked down.
	; Concise description
	; Signet. Deals 26...50...56 holy damage. Causes knock-down if target foe is attacking.
	Return 0
EndFunc

Func CanUse_BarbedSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSignet($a_f_AggroRange)
	; Description
	; Signet. You inflict Bleeding for 3...13...15 seconds on target foe and all adjacent foes.
	; Concise description
	; Signet. Target and adjacent foes suffer from Bleeding (3...13...15 seconds).
	Return 0
EndFunc

Func CanUse_BarbedSignetPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSignetPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_BlessedSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BlessedSignet($a_f_AggroRange)
	; Description
	; Signet. For each enchantment you are maintaining, you gain 3 Energy. You cannot gain more than 3...20...24 Energy in this way.
	; Concise description
	; Signet. You gain 3 Energy for each enchantment you are maintaining. You cannot gain more than 3...20...24 Energy in this way.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_BoonSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BoonSignet($a_f_AggroRange)
	; Description
	; Elite Signet. Heal target ally for 20...68...80 Health. Your next Healing or Protection Prayer  spell that targets an ally heals for an additional 20...68...80 Health.
	; Concise description
	; Elite Signet. Heals for 20...68...80. Your next Healing or Protection Prayer [sic] spell that targets an ally heals for +20...68...80 Health.
	Return 0
EndFunc

Func CanUse_CandyCornStrike()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CandyCornStrike($a_f_AggroRange)
	; Description
	; Signet. Launch a delicious projectile at target foe. If it hits, foe takes 50 damage and you gain 1 strike of adrenaline. This spell  ignores armor.
	; Concise description
	; Signet. Projectile: deals 50 damage, and you gain 1 strike of adrenaline. Armor Ignoring.
	Return 0
EndFunc

Func CanUse_CastigationSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CastigationSignet($a_f_AggroRange)
	; Description
	; This article is about the Eye of the North skill. For the temporarily available Bonus Mission Pack skill, see Castigation Signet (Saul D'Alessio).
	; Concise description
	; green; font-weight: bold;">26...50...56
	Return 0
EndFunc

Func CanUse_CastigationSignetSaulDalessio()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CastigationSignetSaulDalessio($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_CauterySignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CauterySignet($a_f_AggroRange)
	; Description
	; Elite Signet. All party members lose all conditions. You are set on Fire  for 1 second for each condition removed in this way.
	; Concise description
	; Elite Signet. All party members lose all conditions. You begin Burning (one second for each condition removed).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_DeathPactSignet()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_DeathPactSignet($a_f_AggroRange)
	; Description
	; "DPS" and "Dps" redirects here. For the damage measurement, see Damage per second.
	; Concise description
	; green; font-weight: bold;">15...83...100
	Return 0
EndFunc

Func CanUse_DeathPactSignetPvp()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_DeathPactSignetPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_DolyakSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_DolyakSignet($a_f_AggroRange)
	; Description
	; Signet. For 8...18...20 seconds, you have +10...34...40 armor and cannot be knocked down, but your movement is slowed by 75%.
	; Concise description
	; Signet. (8...18...20 seconds.) You have +10...34...40 armor and cannot be knocked-down. You move 75% slower.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_EtherSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_EtherSignet($a_f_AggroRange)
	; Description
	; Signet. If you have less than 5...9...10 Energy, gain 10...18...20 Energy.
	; Concise description
	; Signet. You gain 10...18...20 Energy. No effect unless you have less than 5...9...10 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_GlowingSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_GlowingSignet($a_f_AggroRange)
	; Description
	; Signet. If target foe is Burning, you gain 5...13...15 Energy.
	; Concise description
	; Signet. You gain 5...13...15 Energy if target foe is Burning.
	Return 0
EndFunc

Func CanUse_HexEaterSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_HexEaterSignet($a_f_AggroRange)
	; Description
	; Signet. Target touched ally and up to 2...4...5 adjacent allies each lose one hex. You gain 1...3...4 Energy for each hex removed this way.
	; Concise description
	; Touch Signet. Removes a hex from target and 2...4...5 adjacent allies. Removal effect: you gain 1...3...4 Energy for each hex removed.
	Return 0
EndFunc

Func CanUse_HealingSignet()
	If Anti_Signet() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.80 Then Return False
	Return True
EndFunc

Func BestTarget_HealingSignet($a_f_AggroRange)
	; Description
	; This article is about the Core skill. For the temporarily available Bonus Mission Pack skill, see Healing Signet (Turai Ossa).
	; Concise description
	; green; font-weight: bold;">82...154...172
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_KeystoneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_KeystoneSignet($a_f_AggroRange)
	; Description
	; Elite Signet. All of your signets except Keystone Signet are recharged. For 20 seconds, the next 0...5...6 time[s] you use a signet that targets a foe, all other foes adjacent to your target take 15...51...60 damage and are interrupted.
	; Concise description
	; Elite Signet. (20 seconds.) Your next 0...5...6 signet[s] interrupt [sic] and deal 15...51...60 damage to other foes adjacent to your target. Initial Effect: [sic] recharges all of your other signets.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_LeechSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_LeechSignet($a_f_AggroRange)
	; Description
	; Signet. Interrupt target foe's action. If that action was a spell, you gain 3...13...15 Energy.
	; Concise description
	; Signet. Interrupts an action. Interruption effect: you gain 3...13...15 Energy if the action was a spell.
	Return 0
EndFunc

Func CanUse_LightbringerSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_LightbringerSignet($a_f_AggroRange)
	; Description
	; Signet. If you are within the area of a demonic servant of Abaddon, you gain 4...5 strikes of adrenaline and 22...24 Energy.
	; Concise description
	; Signet. You gain 4...5 strikes of adrenaline and 22...24 Energy if you are within the area of a demonic servant of Abaddon.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_PlagueSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PlagueSignet($a_f_AggroRange)
	; Description
	; Elite Signet. Transfer all negative conditions with 100...180...200% of their remaining durations from yourself to target foe. (50% failure chance with Curses 4 or less.)
	; Concise description
	; Elite Signet. Transfers all conditions with 100...180...200% of their remaining durations from yourself to target foe. 50% failure chance unless Curses 5 or more.
	Return 0
EndFunc

Func CanUse_PoisonTipSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonTipSignet($a_f_AggroRange)
	; Description
	; Signet. For 60 seconds, your next attack also inflicts Poison for 8...14...15 seconds.
	; Concise description
	; Signet. (60 seconds.) Inflicts Poisoned condition (8...14...15 seconds) with your next attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_PolymockBaneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockBaneSignet($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 150 damage. If target foe is casting a spell, that spell is interrupted.
	; Concise description
	; Signet. Deals 150 damage. Interrupts a spell.
	Return 0
EndFunc

Func CanUse_PolymockEtherSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockEtherSignet($a_f_AggroRange)
	; Description
	; Signet. If you have 0 Energy, you gain 10 Energy.
	; Concise description
	; Signet. Gain 10 Energy if you have 0 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_PolymockSignetOfClumsiness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSignetOfClumsiness($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 150 damage. If that foe is casting a spell, that spell is interrupted.
	; Concise description
	; Signet. Interrupts a spell. Deals 150 damage.
	Return 0
EndFunc

Func CanUse_PurgeSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PurgeSignet($a_f_AggroRange)
	; Description
	; Signet. Remove all hexes and conditions from target ally. You lose 10 Energy for each hex and each condition removed.
	; Concise description
	; Signet. Removes all hexes and conditions. Removal cost: 10 Energy each.
	Return 0
EndFunc

Func CanUse_RemedySignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_RemedySignet($a_f_AggroRange)
	; Description
	; Signet. You lose 1 condition.
	; Concise description
	; Signet. You lose one condition.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SadistsSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SadistsSignet($a_f_AggroRange)
	; Description
	; Signet. You gain 10...34...40 Health for each condition on target foe.
	; Concise description
	; Signet. You gain 10...34...40 Health for each condition on target foe.
	Return 0
EndFunc

Func CanUse_SignetOfAggression()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAggression($a_f_AggroRange)
	; Description
	; Signet. If you are under the effects of a shout or chant, you gain 2 strikes of adrenaline.
	; Concise description
	; Signet. You gain 2 adrenaline if you are under the effects of a shout or chant.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfAgony()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAgony($a_f_AggroRange)
	; Description
	; Signet. You suffer from Bleeding for 25 seconds. All nearby foes take 10...58...70 damage.
	; Concise description
	; Signet. Deals 10...58...70 damage to foes near you. You begin Bleeding (25 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfAgonyPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAgonyPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfBinding()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfBinding($a_f_AggroRange)
	; Description
	; Signet. You lose 200...80...50 Health and take control of target enemy-controlled spirit. (50% failure chance with Spawning Power 4 or less.)
	; Concise description
	; Signet. You lose 200...80...50 Health. Gain control of target enemy-controlled spirit. 50% failure chance unless Spawning Power 5 or more.
	Return 0
EndFunc

Func CanUse_SignetOfClumsiness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfClumsiness($a_f_AggroRange)
	; Description
	; Signet. If target foe is attacking, that foe and all adjacent foes are interrupted and take 15...51...60 damage. Any foes using attack skills are knocked down.
	; Concise description
	; Signet. Interrupts an attack for target foe and all adjacent foes. Interruption effect: deals 15...51...60 damage; knocks down foes using attack skills.
	Return 0
EndFunc

Func CanUse_SignetOfClumsinessPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfClumsinessPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfCorruptionKurzick()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCorruptionKurzick($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfCorruptionLuxon()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCorruptionLuxon($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfCreation()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCreation($a_f_AggroRange)
	; Description
	; Signet. You gain 4 Energy for every summoned creature you control within earshot (maximum 3...10...12 Energy).
	; Concise description
	; Signet. Gain 4 Energy (maximum 3...10...12 Energy) for each summoned creature you control within earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfCreationPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCreationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfDeadlyCorruption()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDeadlyCorruption($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 5...29...35 damage for each condition on that foe (maximum 130 damage).
	; Concise description
	; Signet. Deals 5...29...35 damage (maximum 130) for each condition on target foe.
	Return 0
EndFunc

Func CanUse_SignetOfDeadlyCorruptionPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDeadlyCorruptionPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDevotion()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDevotion($a_f_AggroRange)
	; Description
	; Signet. Heal target ally for 14...83...100 Health.
	; Concise description
	; Signet. Heals for 14...83...100.
	Return 0
EndFunc

Func CanUse_SignetOfDisenchantment()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDisenchantment($a_f_AggroRange)
	; Description
	; Signet. Lose all Energy. Target foe loses one enchantment.
	; Concise description
	; Signet. Removes one enchantment. You lose all Energy.
	Return 0
EndFunc

Func CanUse_SignetOfDisruption()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDisruption($a_f_AggroRange)
	; Description
	; Signet. If target foe is casting a spell, the spell is interrupted and that foe suffers 10...43...51 damage. If that foe is hexed, Signet of Disruption can interrupt any non-spell skills.
	; Concise description
	; Signet. Interrupts a spell. Can interrupt any skill if target foe is hexed. Interruption effect: deals 10...43...51 damage.
	Return 0
EndFunc

Func CanUse_SignetOfDistraction()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDistraction($a_f_AggroRange)
	; Description
	; Signet. If target foe is casting a spell, that spell is interrupted and disabled for 1...4...5 seconds for each signet you have equipped.
	; Concise description
	; Signet. Interrupts a spell. Interruption effect: target foe's spell is disabled for 1...4...5 seconds for each signet you have equipped.
	Return 0
EndFunc

Func CanUse_SignetOfGhostlyMight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfGhostlyMight($a_f_AggroRange)
	; Description
	; Elite Signet. For 5...17...20 seconds, all spirits you control within earshot attack 33% faster and deal 5...9...10 additional damage.
	; Concise description
	; Elite Signet. (5...17...20 seconds.) All spirits you control within earshot attack 33% faster and deal +5...9...10 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfGhostlyMightPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfGhostlyMightPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfHumility()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfHumility($a_f_AggroRange)
	; Description
	; Signet. Target foe's elite skill is disabled for 1...13...16 second[s]. Your non-Mesmer skills are disabled for 10 seconds.
	; Concise description
	; Signet. Disables elite skill (1...13...16 second[s]). Disables your non-Mesmer skills (10 seconds).
	Return 0
EndFunc

Func CanUse_SignetOfIllusions()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfIllusions($a_f_AggroRange)
	; Description
	; Elite Signet. Your next 1...3...3 spell[s] use your Illusion attribute instead of its normal attribute.
	; Concise description
	; Elite Signet. Your next 1...3...3 spell[s] use your Illusion attribute instead of its normal attribute.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfInfection()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfInfection($a_f_AggroRange)
	; Description
	; Signet. If target foe is Bleeding, that foe is Diseased for 13...20 seconds.
	; Concise description
	; Signet. Inflicts Diseased condition 13...20 seconds if target foe is Bleeding.
	Return 0
EndFunc

Func CanUse_SignetOfJudgment()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfJudgment($a_f_AggroRange)
	; Description
	; Elite Signet. Target foe is knocked down. That foe and all adjacent foes take 15...63...75 holy damage.
	; Concise description
	; Elite Signet. Knocks down target. Deals 15...63...75 holy damage to target and adjacent foes.
	Return 0
EndFunc

Func CanUse_SignetOfJudgmentPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfJudgmentPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfLostSouls()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfLostSouls($a_f_AggroRange)
	; Description
	; Signet. If target foe is below 50% Health, you gain 10...82...100 Health and 1...8...10 Energy.
	; Concise description
	; Signet. You gain 10...82...100 Health and 1...8...10 Energy if target foe is below 50% Health.
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsBelow50HP")
EndFunc

Func CanUse_SignetOfMalice()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMalice($a_f_AggroRange)
	; Description
	; Signet. For each condition suffered by target foe, you lose one condition.
	; Concise description
	; Signet. You lose one condition for each condition on target foe.
	Return 0
EndFunc

Func CanUse_SignetOfMidnight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMidnight($a_f_AggroRange)
	; Description
	; Elite Signet. You and target touched foe become Blinded for 15 seconds.
	; Concise description
	; Elite Touch Signet. (15 seconds.) Inflicts Blindness condition. You suffer from Blindness (15 seconds).
	Return 0
EndFunc

Func CanUse_SignetOfMysticSpeed()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMysticSpeed($a_f_AggroRange)
	; Description
	; Signet. For 30 seconds, your next 1...3...3 self-targeting enchantment[s] cast instantly. Flash enchantments do not consume uses of this skill.
	; Concise description
	; Signet. (30 seconds.) Your next 1...3...3 self-targeted enchantments [sic] cast instantly. Flash enchantments do not consume uses of this skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfMysticWrath()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMysticWrath($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 5...29...35 holy damage for each enchantment on you (maximum 100 holy damage).
	; Concise description
	; Signet. Deals 5...29...35 holy damage for each enchantment on you (maximum 100 holy damage).
	Return 0
EndFunc

Func CanUse_SignetOfPiousLight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousLight($a_f_AggroRange)
	; Description
	; Signet. Remove 1 Dervish enchantment. Target ally is healed for 30...126...150 Health. If an enchantment was removed in this way, this signet recharges 75% faster.
	; Concise description
	; Signet. Heals for 30...126...150. Removes one of your Dervish enchantments. Removal effect: recharges 75% faster.
	Return 0
EndFunc

Func CanUse_SignetOfPiousRestraint()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousRestraint($a_f_AggroRange)
	; Description
	; Signet. Remove one Dervish enchantment. Target foe is Crippled for 5...13...15 seconds. If an enchantment was removed, all foes nearby your target are also Crippled and this signet recharges 75% faster.
	; Concise description
	; Signet. Inflicts Crippled condition (5...13...15 seconds). Remove one of your Dervish enchantments. Removal effect: also causes Cripple to foes nearby your target and recharges 75% faster.
	Return 0
EndFunc

Func CanUse_SignetOfPiousRestraintPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousRestraintPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfRage()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRage($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 5...41...50 holy damage and +5...9...10 holy damage for each adrenaline skill that foe has.
	; Concise description
	; Signet. Deals 5...41...50 holy damage. Deals 5...9...10 more holy damage for each of target foe's adrenaline skills.
	Return 0
EndFunc

Func CanUse_SignetOfRecall()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRecall($a_f_AggroRange)
	; Description
	; Signet. For 10 seconds, you have -4 Energy regeneration. When this effect ends, you gain 13...19...20 Energy.
	; Concise description
	; Signet. (10 seconds.) You have -4 Energy regeneration. End effect: you gain 13...19...20 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfRejuvenation()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRejuvenation($a_f_AggroRange)
	; Description
	; Signet. Heal target ally for 15...63...75. If target ally is casting a spell or attacking, that ally is healed for an additional 15...63...75 Health.
	; Concise description
	; Signet. Heals for 15...63...75. Heals for 15...63...75 more if target ally is casting a spell or attacking.
	Return 0
EndFunc

Func CanUse_SignetOfRemoval()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRemoval($a_f_AggroRange)
	; Description
	; Elite Signet. If target ally is under the effects of an enchantment, that ally loses one hex and one condition.
	; Concise description
	; Elite Signet. Removes one hex and one condition. No effect unless target ally is enchanted.
	Return 0
EndFunc

Func CanUse_ResurrectionSignet()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_ResurrectionSignet($a_f_AggroRange)
	; Description
	; Signet. Resurrect target party member. That party member is returned to life with 100% Health and 25% Energy. This signet only recharges when you gain a morale boost.
	; Concise description
	; Signet. Resurrects target party member (100% Health, 25% Energy). This signet only recharges when you gain a morale boost.
	Return 0
EndFunc

Func CanUse_SignetOfReturn()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfReturn($a_f_AggroRange)
	; Description
	; Signet. Resurrect target party member with 5...13...15% Health and 1...3...4% Energy for each party member within earshot.
	; Concise description
	; Signet. Resurrects target party member (5...13...15% Health and 1...3...4% Energy for each party member in earshot).
	Return 0
EndFunc

Func CanUse_SignetOfReturnPvp()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfReturnPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfShadows()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfShadows($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 5...29...35 damage. If your target was Blinded, that foe suffers an additional 15...51...60 damage.
	; Concise description
	; Signet. Deals 5...29...35 damage. Deals 15...51...60 more damage if target foe is Blinded.
	Return 0
EndFunc

Func CanUse_SignetOfSorrow()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSorrow($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 15...63...75 damage. If target foe is near a corpse or has a dead pet, this skill recharges instantly.
	; Concise description
	; Signet. Deals 15...63...75 damage. Recharges instantly if target foe is near a corpse or has a dead pet.
	Return 0
EndFunc

Func CanUse_SignetOfSpirits()
	If Anti_Signet() Then Return False

	Local $l_i_Spirit1 = UAI_FindAgentByPlayerNumber(4229, -2, 5000, "UAI_Filter_IsControlledSpirit")
	Local $l_i_Spirit2 = UAI_FindAgentByPlayerNumber(4230, -2, 5000, "UAI_Filter_IsControlledSpirit")
	Local $l_i_Spirit3 = UAI_FindAgentByPlayerNumber(4231, -2, 5000, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit1 <> 0 And $l_i_Spirit2 <> 0 And $l_i_Spirit3 <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit1, $GC_UAI_AGENT_HP) < 0.20 Or UAI_GetAgentInfoByID($l_i_Spirit2, $GC_UAI_AGENT_HP) < 0.20 Or UAI_GetAgentInfoByID($l_i_Spirit3, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_SignetOfSpirits($a_f_AggroRange)
	; Description
	; Elite Signet. Create 3 level 1...10...12 spirits. These spirits deal 5...17...20 damage with attacks and die after 60 seconds.
	; Concise description
	; Elite Signet. Creates 3 level 1...10...12 spirits (60 second lifespan). These spirits deal 5...17...20 damage with attacks.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfSpiritsPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSpiritsPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfStamina()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfStamina($a_f_AggroRange)
	; Description
	; Signet. You have +50...250...300 maximum Health. This signet ends if you successfully hit with an attack.
	; Concise description
	; Signet. You have +50...250...300 maximum Health. Ends if you hit with an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfStrength()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfStrength($a_f_AggroRange)
	; Description
	; Signet. Your next 1...13...16 attack[s] deal +5 damage.
	; Concise description
	; Signet. Your attacks deal +5 damage. Ends after 1...13...16 attack[s].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfSuffering()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSuffering($a_f_AggroRange)
	; Description
	; Elite Signet. You suffer from Bleeding for 6 seconds. The next Necromancer skill that targets a foe causes Bleeding for 2...13...16 seconds.
	; Concise description
	; Elite Signet. You Bleed for 6 seconds. Applies Bleeding (2...13...16 seconds) to the target of your next Necromancer skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SignetOfSynergy()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSynergy($a_f_AggroRange)
	; Description
	; Signet. Target other ally is healed for 40...88...100 Health. If you are not under the effects of an enchantment, you are also healed for 40...88...100 Health.
	; Concise description
	; Signet. Heal target ally for 40...88...100. You are also healed for 40...88...100 if you are not enchanted. Cannot self-target.
	Return 0
EndFunc

Func CanUse_SignetOfTheUnseen()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfTheUnseen($a_f_AggroRange)
	; Description
	; Elite Signet. Target foe and all nearby foes take 80 damage and are knocked down. If any of those foes are summoned creatures, those foes begin Burning for 6 seconds.
	; Concise description
	; Elite Signet. Deals 80 holy damage and knocks down target and nearby foes. Burns summoned creatures (6 seconds.)
	Return 0
EndFunc

Func CanUse_SignetOfToxicShock()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfToxicShock($a_f_AggroRange)
	; Description
	; Signet. If target foe is suffering from Poison, that foe takes 10...82...100 damage.
	; Concise description
	; Signet. Deals 10...82...100 damage. No effect unless target foe is Poisoned
	Return 0
EndFunc

Func CanUse_SignetOfTwilight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfTwilight($a_f_AggroRange)
	; Description
	; Signet. For each hex on target foe, that foe loses one enchantment.
	; Concise description
	; Signet. Removes one enchantment for each hex on target foe.
	Return 0
EndFunc

Func CanUse_SignetOfWeariness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfWeariness($a_f_AggroRange)
	; Description
	; Signet. Target foe and all nearby foes lose 3...7...8 Energy and suffer from Weakness for 1...10...12 second[s].
	; Concise description
	; Signet. Also affects foes near your target. Causes 3...7...8 Energy loss and inflicts Weakness (1...10...12 second[s]).
	Return 0
EndFunc

Func CanUse_SunspearRebirthSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SunspearRebirthSignet($a_f_AggroRange)
	; Description
	; Sunspear rank
	; Concise description
	; //en.wikipedia.org/wiki/Sic" class="extiw" title="w:Sic">
	Return 0
EndFunc

Func CanUse_TryptophanSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_TryptophanSignet($a_f_AggroRange)
	; Description
	; Signet. For 14...20 seconds, target foe and all adjacent foes move and attack 23...40% slower.
	; Concise description
	; Signet. (14...20 seconds.) Target and adjacent foes move and attack 23...40% slower.
	Return 0
EndFunc

Func CanUse_UnnaturalSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_UnnaturalSignet($a_f_AggroRange)
	; Description
	; Signet. Target foe takes 15...63...75 damage. If that foe is under the effects of a hex or enchantment, foes adjacent to your target take 5...41...50 damage.
	; Concise description
	; Signet. Deals 15...63...75 damage. Deals 5...41...50 damage to other adjacent foes if the target is hexed or enchanted.

	; Priority 1: Hexed/Enchanted enemy with most adjacent enemies (AOE bonus)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexedOrEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 2: Any hexed/enchanted enemy (triggers AOE even if alone)
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexedOrEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy (no AOE bonus but still does damage)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

Func CanUse_UnnaturalSignetPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_UnnaturalSignetPvp($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_UnnaturalSignetSaulDalessio()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_UnnaturalSignetSaulDalessio($a_f_AggroRange)
	Return 0
EndFunc

