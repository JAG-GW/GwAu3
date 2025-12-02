#include-once

Func Anti_Skill16()

EndFunc

; Skill ID: 318 - $GC_I_SKILL_ID_DEFY_PAIN
Func CanUse_DefyPain()
	Return True
EndFunc

Func BestTarget_DefyPain($a_f_AggroRange)
	; Description
	; Elite Skill. For 20 seconds you have an additional 90...258...300 Health, an additional 20 armor, and you take &#45;1...8...10 less damage.
	; Concise description
	; Elite Skill. (20 seconds.) You have +90...258...300 maximum Health, +20 armor, and take 1...8...10 less damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 347 - $GC_I_SKILL_ID_ENDURE_PAIN
Func CanUse_EndurePain()
	Return True
EndFunc

Func BestTarget_EndurePain($a_f_AggroRange)
	; Description
	; This article is about the Core skill. For the temporarily available Bonus Mission Pack skill, see Endure Pain (Turai Ossa).
	; Concise description
	; green; font-weight: bold;">7...16...18
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 362 - $GC_I_SKILL_ID_WARRIORS_CUNNING
Func CanUse_WarriorsCunning()
	Return True
EndFunc

Func BestTarget_WarriorsCunning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 363 - $GC_I_SKILL_ID_SHIELD_BASH
Func CanUse_ShieldBash()
	Return True
EndFunc

Func BestTarget_ShieldBash($a_f_AggroRange)
	; Description
	; Skill. For 5...10...11 seconds, while wielding a shield, the next attack skill used against you is blocked. If it was a melee skill, your attacker is knocked down and that skill is disabled for an additional 15 seconds.
	; Concise description
	; Skill. (5...10...11 seconds.) You block the next attack skill. Causes knock-down and +15 second recharge if it was a melee skill. No effect unless you are wielding a shield.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 374 - $GC_I_SKILL_ID_WARRIORS_ENDURANCE
Func CanUse_WarriorsEndurance()
	Return True
EndFunc

Func BestTarget_WarriorsEndurance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 381 - $GC_I_SKILL_ID_HUNDRED_BLADES
Func CanUse_HundredBlades()
	Return True
EndFunc

Func BestTarget_HundredBlades($a_f_AggroRange)
	; Description
	; Elite Skill. For 15 seconds, whenever you attack with a sword, all adjacent foes take 10...22...25 slashing damage.
	; Concise description
	; Elite Skill. (15 seconds.) Deals 10...22...25 slashing damage to all adjacent foes whenever you attack with a sword.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 387 - $GC_I_SKILL_ID_RIPOSTE
Func CanUse_Riposte()
	Return True
EndFunc

Func BestTarget_Riposte($a_f_AggroRange)
	; Description
	; Skill. For 8 seconds, while you have a sword equipped, you block the next melee attack against you and your attacker is struck for 20...68...80 damage.
	; Concise description
	; Skill. (8 seconds). You block the next melee attack and your attacker takes 20...68...80 damage. No effect unless you have a sword equipped.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 388 - $GC_I_SKILL_ID_DEADLY_RIPOSTE
Func CanUse_DeadlyRiposte()
	Return True
EndFunc

Func BestTarget_DeadlyRiposte($a_f_AggroRange)
	; Description
	; Skill. For 8 seconds, while you have a sword equipped, you block the next melee attack against you, and your attacker is struck for 15...75...90 damage and begins Bleeding for 3...21...25 seconds.
	; Concise description
	; Skill. (8 seconds). You block the next melee attack and your attacker takes 15...75...90 damage. Inflicts Bleeding condition. (3...21...25 seconds). No effect unless you have a sword equipped.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 569 - $GC_I_SKILL_ID_VICTORY_OR_DEATH
Func CanUse_VictoryOrDeath()
	Return True
EndFunc

Func BestTarget_VictoryOrDeath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1018 - $GC_I_SKILL_ID_CRITICAL_EYE
Func CanUse_CriticalEye()
	Return True
EndFunc

Func BestTarget_CriticalEye($a_f_AggroRange)
	; Description
	; Skill. For 10...30...35 seconds, you have an additional 3...13...15% chance to land a critical hit when attacking. You gain 1 Energy whenever you score a critical hit.
	; Concise description
	; Skill. (10...30...35 seconds.) You have +3...13...15% chance to land a critical hit. You gain 1 Energy whenever you land a critical hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1156 - $GC_I_SKILL_ID_AURA_OF_THE_JUGGERNAUT
Func CanUse_AuraOfTheJuggernaut()
	Return True
EndFunc

Func BestTarget_AuraOfTheJuggernaut($a_f_AggroRange)
	; Description
	; Skill. You are inside a Kurzick Juggernaut's aura. All allies within a Kurzick Juggernaut's aura receive +1 Energy regeneration.
	; Concise description
	; Skill. Allies have +1 Energy regeneration when in range of the Kurzick Juggernaut's aura.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1217 - $GC_I_SKILL_ID_RITUAL_LORD
Func CanUse_RitualLord()
	Return True
EndFunc

Func BestTarget_RitualLord($a_f_AggroRange)
	; Description
	; Elite Skill. For 5...29...35 seconds, your Ritualist attributes are boosted by 2...4...4 for your next skill. If that skill is a Binding Ritual, it recharges 10...50...60% faster and Ritual Lord recharges instantly.
	; Concise description
	; Elite Skill. (5...29...35 seconds.) You have +2...4...4 to all Ritualist attributes for your next skill. If that skill is a Binding Ritual, it recharges 10...50...60% faster and Ritual Lord recharges instantly.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1240 - $GC_I_SKILL_ID_SOUL_TWISTING
Func CanUse_SoulTwisting()
	Return True
EndFunc

Func BestTarget_SoulTwisting($a_f_AggroRange)
	; Description
	; ST redirects here. For other uses, see ST (disambiguation).
	; Concise description
	; green; font-weight: bold;">5...37...45
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1377 - $GC_I_SKILL_ID_ETHER_PRISM
Func CanUse_EtherPrism()
	Return True
EndFunc

Func BestTarget_EtherPrism($a_f_AggroRange)
	; Description
	; Elite Skill. For 3 seconds, all damage you take is reduced by 75%. When Ether Prism ends, you gain 5...17...20 Energy.
	; Concise description
	; Elite Skill. (3 seconds.) All damage you take is reduced by 75%. End effect: gain 5...17...20 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1408 - $GC_I_SKILL_ID_RAGE_OF_THE_NTOUKA
Func CanUse_RageOfTheNtouka()
	Return True
EndFunc

Func BestTarget_RageOfTheNtouka($a_f_AggroRange)
	; Description
	; Elite Skill. Gain 1...6...7 strike[s] of adrenaline. For 10 seconds, whenever you use an adrenal skill, that skill recharges for 5 seconds.
	; Concise description
	; Elite Skill. You gain 1...6...7 adrenaline. For 10 seconds, adrenal skills have a 5 second recharge when used.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1463 - $GC_I_SKILL_ID_ROUGH_CURRENT
Func CanUse_RoughCurrent()
	Return True
EndFunc

Func BestTarget_RoughCurrent($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1464 - $GC_I_SKILL_ID_TURBULENT_FLOW
Func CanUse_TurbulentFlow()
	Return True
EndFunc

Func BestTarget_TurbulentFlow($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; green; font-weight: bold;">1...5
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1508 - $GC_I_SKILL_ID_EXTEND_ENCHANTMENTS
Func CanUse_ExtendEnchantments()
	Return True
EndFunc

Func BestTarget_ExtendEnchantments($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, your next Dervish enchantment lasts 10...122...150% longer.
	; Concise description
	; Skill. (10 seconds.) Your next Dervish enchantment lasts 10...122...150% longer.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1606 - $GC_I_SKILL_ID_CURSE_OF_THE_STAFF_OF_THE_MISTS
Func CanUse_CurseOfTheStaffOfTheMists()
	Return True
EndFunc

Func BestTarget_CurseOfTheStaffOfTheMists($a_f_AggroRange)
	; Description
	; Nightfall
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1607 - $GC_I_SKILL_ID_AURA_OF_THE_STAFF_OF_THE_MISTS
Func CanUse_AuraOfTheStaffOfTheMists()
	Return True
EndFunc

Func BestTarget_AuraOfTheStaffOfTheMists($a_f_AggroRange)
	; Description
	; Skill. The power of the Staff of the Mists heals you and your allies for 30 Health every 4 seconds and drains 30 Health from all nearby foes every 4 seconds.
	; Concise description
	; Skill. The power of the Staff of the Mists heals you and your allies for 30 Health every 4 seconds and drains 30 Health from all nearby foes every 4 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1608 - $GC_I_SKILL_ID_POWER_OF_THE_STAFF_OF_THE_MISTS
Func CanUse_PowerOfTheStaffOfTheMists()
	Return True
EndFunc

Func BestTarget_PowerOfTheStaffOfTheMists($a_f_AggroRange)
	; Description
	; Skill. As the magic of the Staff of the Mists runs through your veins, you gain +4 Health regeneration.
	; Concise description
	; Skill. As the magic of the Staff of the Mists runs through your veins, you gain +4 Health regeneration
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1680 - $GC_I_SKILL_ID_DRAKE_SKIN
Func CanUse_DrakeSkin()
	Return True
EndFunc

Func BestTarget_DrakeSkin($a_f_AggroRange)
	; Description
	; Nightfall
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1681 - $GC_I_SKILL_ID_SKALE_VIGOR
Func CanUse_SkaleVigor()
	Return True
EndFunc

Func BestTarget_SkaleVigor($a_f_AggroRange)
	; Description
	; Nightfall
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1682 - $GC_I_SKILL_ID_PAHNAI_SALAD_ITEM_EFFECT
Func CanUse_PahnaiSaladItemEffect()
	Return True
EndFunc

Func BestTarget_PahnaiSaladItemEffect($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1704 - $GC_I_SKILL_ID_UNTOUCHABLE
Func CanUse_Untouchable()
	Return True
EndFunc

Func BestTarget_Untouchable($a_f_AggroRange)
	; Description
	; Skill. You are invulnerable for 5 seconds after being resurrected by the Resurrection Shrine.
	; Concise description
	; Skill. (5 seconds.) You are invulnerable after being resurrected by the Resurrection Shrine.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1721 - $GC_I_SKILL_ID_RAMPAGE_AS_ONE
Func CanUse_RampageAsOne()
	Return True
EndFunc

Func BestTarget_RampageAsOne($a_f_AggroRange)
	; Description
	; Elite Skill. For 3...13...15 seconds, both you and your animal companion attack 33% faster and run 25% faster.
	; Concise description
	; Elite Skill. (3...13...15 seconds.) You and your pet attack 33% faster and move 25% faster. No effect unless your pet is alive.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1769 - $GC_I_SKILL_ID_FOCUSED_ANGER
Func CanUse_FocusedAnger()
	Return True
EndFunc

Func BestTarget_FocusedAnger($a_f_AggroRange)
	; Description
	; Elite Skill. For 45 seconds, you gain 0...120...150% more adrenaline.
	; Concise description
	; Elite Skill. (45 seconds.) You gain 0...120...150% more adrenaline.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1770 - $GC_I_SKILL_ID_NATURAL_TEMPER
Func CanUse_NaturalTemper()
	Return True
EndFunc

Func BestTarget_NaturalTemper($a_f_AggroRange)
	; Description
	; Skill. For 4...9...10 seconds, you gain 33% more adrenaline while not under the effects of an Enchantment.
	; Concise description
	; Skill. (4...9...10 seconds.) You gain 33% more adrenaline. No effect if you are enchanted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1893 - $GC_I_SKILL_ID_ENRAGED
Func CanUse_Enraged()
	Return True
EndFunc

Func BestTarget_Enraged($a_f_AggroRange)
	; Description
	; Skill. Attacks and skills do +50% damage if this creature's Health is below 70%, and an additional +50% damage if its Health is below 30%.
	; Concise description
	; Skill. This creature's attacks and skills do +50% damage if its Health is below 70%, and an additional +50% damage if its Health is below 30%.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1918 - $GC_I_SKILL_ID_RAM
Func CanUse_Ram()
	Return True
EndFunc

Func BestTarget_Ram($a_f_AggroRange)
	; Description
	; Skill. For 2 seconds, all adjacent enemy rollerbeetles are knocked down.
	; Concise description
	; Skill. Knocks-down adjacent enemy rollerbeetles (2 seconds.)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1919 - $GC_I_SKILL_ID_HARDEN_SHELL
Func CanUse_HardenShell()
	Return True
EndFunc

Func BestTarget_HardenShell($a_f_AggroRange)
	; Description
	; Skill. For 4 seconds, you cannot be knocked down.
	; Concise description
	; Skill. (4 seconds.) You cannot be knocked-down.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1920 - $GC_I_SKILL_ID_ROLLERBEETLE_DASH
Func CanUse_RollerbeetleDash()
	Return True
EndFunc

Func BestTarget_RollerbeetleDash($a_f_AggroRange)
	; Description
	; Skill. For 5 seconds, you move extremely fast.
	; Concise description
	; Skill. (5 seconds.) You move extremely fast.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1921 - $GC_I_SKILL_ID_SUPER_ROLLERBEETLE
Func CanUse_SuperRollerbeetle()
	Return True
EndFunc

Func BestTarget_SuperRollerbeetle($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, you move extremely fast and cannot be knocked down.
	; Concise description
	; Skill. (10 seconds.) You move extremely fast and cannot be knocked-down.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1922 - $GC_I_SKILL_ID_ROLLERBEETLE_ECHO
Func CanUse_RollerbeetleEcho()
	Return True
EndFunc

Func BestTarget_RollerbeetleEcho($a_f_AggroRange)
	; Description
	; Skill. For 20 seconds, this skill is replaced with the next skill you use. Rollerbeetle Echo acts as this skill for 30 seconds.
	; Concise description
	; Skill. (20 seconds.) Rollerbeetle Echo becomes the next skill you use (30 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1923 - $GC_I_SKILL_ID_DISTRACTING_LUNGE
Func CanUse_DistractingLunge()
	Return True
EndFunc

Func BestTarget_DistractingLunge($a_f_AggroRange)
	; Description
	; Skill. All of target rollerbeetle's skills are disabled for 5 seconds.
	; Concise description
	; Skill. Disables target rollerbeetle's skills (5 seconds).
	Return 0
EndFunc

; Skill ID: 1924 - $GC_I_SKILL_ID_ROLLERBEETLE_BLAST
Func CanUse_RollerbeetleBlast()
	Return True
EndFunc

Func BestTarget_RollerbeetleBlast($a_f_AggroRange)
	; Description
	; Skill. Target rollerbeetle is knocked down.
	; Concise description
	; Skill. Knocks-down target rollerbeetle.
	Return 0
EndFunc

; Skill ID: 1925 - $GC_I_SKILL_ID_SPIT_ROCKS
Func CanUse_SpitRocks()
	Return True
EndFunc

Func BestTarget_SpitRocks($a_f_AggroRange)
	; Description
	; Skill. You spit rocks at target rollerbeetle. If they hit, that target is knocked down.
	; Concise description
	; Skill. Spit rocks at target rollerbeetle. Causes knock-down if they hit.
	Return 0
EndFunc

; Skill ID: 1932 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1934 - $GC_I_SKILL_ID_GOLDEN_EGG_SKILL
Func CanUse_GoldenEggSkill()
	Return True
EndFunc

Func BestTarget_GoldenEggSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1945 - $GC_I_SKILL_ID_BIRTHDAY_CUPCAKE_SKILL
Func CanUse_BirthdayCupcakeSkill()
	Return True
EndFunc

Func BestTarget_BirthdayCupcakeSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2104 - $GC_I_SKILL_ID_INTENSITY
Func CanUse_Intensity()
	Return True
EndFunc

Func BestTarget_Intensity($a_f_AggroRange)
	; Description
	; Skill. For 10 seconds, the next time you deal elemental damage with a spell to a target, you deal 60...70% of that damage to all other foes in the area.
	; Concise description
	; Skill. (10 seconds.) The next time you deal elemental damage with a spell, other targets in the area take 60...70% of that damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2108 - $GC_I_SKILL_ID_NEVER_RAMPAGE_ALONE
Func CanUse_NeverRampageAlone()
	Return True
EndFunc

Func BestTarget_NeverRampageAlone($a_f_AggroRange)
	; Description
	; Skill. For 18...25 seconds, you and your pet attack 25% faster and have 1...3 Health regeneration.
	; Concise description
	; Skill. (18...25 seconds.) You and your pet attack 25% faster and have +1...3 Health regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2208 - $GC_I_SKILL_ID_BURNING_SHIELD
Func CanUse_BurningShield()
	Return True
EndFunc

Func BestTarget_BurningShield($a_f_AggroRange)
	; Description
	; Skill. For 3...8...9 seconds, while wielding a shield, the next attack skill used against you is blocked. If it was a melee attack, your attacker is set on fire for 1...5...6 seconds.
	; Concise description
	; Skill. (3...8...9 seconds.) Blocks the next attack skill against you. Inflicts Burning condition (1...5...6 second[s]) if it was a melee attack. No effect unless you are wielding a shield.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2360 - $GC_I_SKILL_ID_FEEL_NO_PAIN
Func CanUse_FeelNoPain()
	Return True
EndFunc

Func BestTarget_FeelNoPain($a_f_AggroRange)
	; Description
	; Skill. For 30 seconds you have +2...3 Health regeneration. If you are drunk when activating this skill, you also have +200...300 maximum Health.
	; Concise description
	; Skill. (30 seconds.) You have +2...3 Health regeneration. You have +200...300 maximum Health if you are drunk when activating this skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2378 - $GC_I_SKILL_ID_URSAN_FORCE
Func CanUse_UrsanForce()
	Return True
EndFunc

Func BestTarget_UrsanForce($a_f_AggroRange)
	; Description
	; Skill. For 8...14 seconds, you move 20...33% faster and can break wooden barricades.
	; Concise description
	; Skill. (8...14 seconds.) You move 20...33% faster and can break wooden barricades.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2604 - $GC_I_SKILL_ID_CANDY_CORN_SKILL
Func CanUse_CandyCornSkill()
	Return True
EndFunc

Func BestTarget_CandyCornSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2605 - $GC_I_SKILL_ID_CANDY_APPLE_SKILL
Func CanUse_CandyAppleSkill()
	Return True
EndFunc

Func BestTarget_CandyAppleSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2649 - $GC_I_SKILL_ID_PIE_INDUCED_ECSTASY
Func CanUse_PieInducedEcstasy()
	Return True
EndFunc

Func BestTarget_PieInducedEcstasy($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Acquisition">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2713 - $GC_I_SKILL_ID_VICTORY_IS_OURS
Func CanUse_VictoryIsOurs()
	Return True
EndFunc

Func BestTarget_VictoryIsOurs($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2733 - $GC_I_SKILL_ID_FALKEN_QUICK
Func CanUse_FalkenQuick()
	Return True
EndFunc

Func BestTarget_FalkenQuick($a_f_AggroRange)
	; Description
	; Factions
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2802 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2865 - $GC_I_SKILL_ID_RITUAL_LORD_PvP
Func CanUse_RitualLordPvP()
	Return True
EndFunc

Func BestTarget_RitualLordPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2886 - $GC_I_SKILL_ID_SUMMONING_SICKNESS
Func CanUse_SummoningSickness()
	Return True
EndFunc

Func BestTarget_SummoningSickness($a_f_AggroRange)
	; Description
	; Skill. For 10 minutes, you are unable to use summoning stones.
	; Concise description
	; Skill. (10 minutes.) You are unable to use summoning stones.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2889 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2923 - $GC_I_SKILL_ID_YO_HO_HO_AND_A_BOTTLE_OF_GROG
Func CanUse_YoHoHoAndABottleOfGrog()
	Return True
EndFunc

Func BestTarget_YoHoHoAndABottleOfGrog($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Drinking pirate grog can cause you to spontaneously spout piratical non sequiturs. Do not attempt to wield weapons or ride siege devourers while under the influence of grog as drinking and adventuring can be hazardous to your health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2924 - $GC_I_SKILL_ID_OATH_OF_PROTECTION
Func CanUse_OathOfProtection()
	Return True
EndFunc

Func BestTarget_OathOfProtection($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; Notes">edit
	Return 0
EndFunc

; Skill ID: 2928 - $GC_I_SKILL_ID_AMULET_OF_PROTECTION2
Func CanUse_AmuletOfProtection2()
	Return True
EndFunc

Func BestTarget_AmuletOfProtection2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2968 - $GC_I_SKILL_ID_OVERSIZED_TONIC_WARNING
Func CanUse_OversizedTonicWarning()
	Return True
EndFunc

Func BestTarget_OversizedTonicWarning($a_f_AggroRange)
	; Description
	; Skill
	; Concise description
	; Abominable, Automatonic, Phantasmal, and Sinister Automatonic.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2971 - $GC_I_SKILL_ID_BLUE_ROCK_CANDY_RUSH
Func CanUse_BlueRockCandyRush()
	Return True
EndFunc

Func BestTarget_BlueRockCandyRush($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2972 - $GC_I_SKILL_ID_GREEN_ROCK_CANDY_RUSH
Func CanUse_GreenRockCandyRush()
	Return True
EndFunc

Func BestTarget_GreenRockCandyRush($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2973 - $GC_I_SKILL_ID_RED_ROCK_CANDY_RUSH
Func CanUse_RedRockCandyRush()
	Return True
EndFunc

Func BestTarget_RedRockCandyRush($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3077 - $GC_I_SKILL_ID_WEAKENED_BY_DHUUM
Func CanUse_WeakenedByDhuum()
	Return True
EndFunc

Func BestTarget_WeakenedByDhuum($a_f_AggroRange)
	; Description
	; Skill. You are overcome by the energy coming off the Everlasting Mobstopper holding your newly captured Skeleton of Dhuum. You couldn't possibly handle capturing another while in this state.
	; Concise description
	; Skill. You are overcome by the energy coming off the Everlasting Mobstopper holding your newly captured Skeleton of Dhuum. You couldn't possibly handle capturing another while in this state.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3080 - $GC_I_SKILL_ID_DHUUM_SKILL
Func CanUse_DhuumSkill()
	Return True
EndFunc

Func BestTarget_DhuumSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3132 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3174 - $GC_I_SKILL_ID_WELL_SUPPLIED
Func CanUse_WellSupplied()
	Return True
EndFunc

Func BestTarget_WellSupplied($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3198 - $GC_I_SKILL_ID_IMPENDING_DHUUM
Func CanUse_ImpendingDhuum()
	Return True
EndFunc

Func BestTarget_ImpendingDhuum($a_f_AggroRange)
	; Description
	; Skill. No resurrection spell can save you now. Your account has been banned.
	; Concise description
	; Skill. No resurrection spell can save you now. Your account has been banned.
	Return 0
EndFunc

; Skill ID: 3202 - $GC_I_SKILL_ID_OATH_OF_PROTECTION2
Func CanUse_OathOfProtection2()
	Return True
EndFunc

Func BestTarget_OathOfProtection2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3206 - $GC_I_SKILL_ID_SPECTRAL_INFUSION
Func CanUse_SpectralInfusion()
	Return True
EndFunc

Func BestTarget_SpectralInfusion($a_f_AggroRange)
	; Description
	; Skill. For an undetermined time, you are protected from most of the effects of the Mursaat's vilest magic, reflecting some of its damage back on any Mursaat or Jade Construct within range.
	; Concise description
	; Skill. For an undetermined time, you are protected from most of the effects of the Mursaat's vilest magic, reflecting some of its damage back on any Mursaat or Jade Construct within range.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3407 - ;  $GC_I_SKILL_ID_UNKNOWN
