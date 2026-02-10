#include-once

Func Anti_Skill16()
	Return False
EndFunc

; Skill ID: 318 - $GC_I_SKILL_ID_DEFY_PAIN
Func CanUse_DefyPain()
	; Use when HP is below 80% - defensive skill
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.8 Then Return False
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
	; Emergency survival skill - use when HP is critical (below 50%)
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.5 Then Return False
	Return True
EndFunc

Func BestTarget_EndurePain($a_f_AggroRange)
	; Description
	; Skill. For 7...16...18 seconds you have an additional 90...258...300 Health.
	; Concise description
	; Skill. (7...16...18 seconds.) You have +90...258...300 maximum Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 362 - $GC_I_SKILL_ID_WARRIORS_CUNNING
Func CanUse_WarriorsCunning()
	; Only useful when actively attacking
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Return False
	Return True
EndFunc

Func BestTarget_WarriorsCunning($a_f_AggroRange)
	; Description
	; Skill. For 5...10...11 seconds, your melee attacks cannot be blocked.
	; Concise description
	; Skill. (5...10...11 seconds.) Your melee attacks are unblockable.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 363 - $GC_I_SKILL_ID_SHIELD_BASH
Func CanUse_ShieldBash()
	; Block skill - use when adjacent enemies are present
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
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
	; Energy management skill - use when attacking and energy is low
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 10 Then Return False
	Return True
EndFunc

Func BestTarget_WarriorsEndurance($a_f_AggroRange)
	; Description
	; Elite Skill. For 5...29...35 seconds, you gain 3 Energy each time you hit with a melee attack. Warrior's Endurance cannot raise your Energy above 10...22...25.
	; Concise description
	; Elite Skill. (5...29...35 seconds.) You gain 3 Energy each time you hit with a melee attack. No Energy gain if you have more than 10...22...25 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 381 - $GC_I_SKILL_ID_HUNDRED_BLADES
Func CanUse_HundredBlades()
	; AoE skill - only worth using with multiple adjacent enemies
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 2 Then Return False
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
	; Block skill - use when adjacent enemies are present
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
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
	; Block skill - use when adjacent enemies are present
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
	Return True
EndFunc

Func BestTarget_DeadlyRiposte($a_f_AggroRange)
	; Description
	; Skill. For 8 seconds, while you have a sword equipped, you block the next melee attack against you, and your attacker is struck for 15...75...90 damage and begins Bleeding for 3...21...25 seconds.
	; Concise description
	; Skill. (8 seconds). You block the next melee attack and your attacker takes 15...75...90 damage. Inflicts Bleeding condition. (3...21...25 seconds). No effect unless you have a sword equipped.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1018 - $GC_I_SKILL_ID_CRITICAL_EYE
Func CanUse_CriticalEye()
	; Critical hit buff - only useful when attacking
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Return False
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
	; Elite Skill. For 5...37...45 seconds, your Binding Rituals cost 15 less Energy (minimum 10) and recharge instantly. Soul Twisting ends after 1...3...3 Binding Ritual[s].
	; Concise description
	; Elite Skill. (5...37...45 seconds.) Your Binding Rituals cost 15 less Energy (minimum 10) and recharge instantly. Ends after 1...3...3 Binding Ritual[s].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1377 - $GC_I_SKILL_ID_ETHER_PRISM
Func CanUse_EtherPrism()
	; Damage reduction + energy gain - use when HP is low
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.5 Then Return False
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
	; Skill. The Staff of the Mists does 30 damage to all foes within range every 4 seconds.
	; Concise description
	; Skill. The Staff of the Mists does 30 damage to all foes within range every 4 seconds.
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

; Skill ID: 1721 - $GC_I_SKILL_ID_RAMPAGE_AS_ONE
Func CanUse_RampageAsOne()
	; Requires pet to be alive
	Local $l_i_PetSize = World_GetWorldInfo("PetInfoArraySize")
    Local $lMyPet = 0

    ; PetNumber starts at 1, not 0
    For $i = 1 To $l_i_PetSize
        If Party_GetPetInfo($i, "OwnerAgentID") = UAI_GetPlayerInfo($GC_UAI_AGENT_ID) Then
            $lMyPet = Party_GetPetInfo($i, "AgentID")
            ExitLoop
        EndIf
    Next

    If $lMyPet = 0 Then Return False

    If Agent_GetAgentInfo($lMyPet, "HPPercent") = 0 Then Return False
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
	; Only works when NOT enchanted
	If UAI_GetPlayerInfo($GC_UAI_AGENT_IsEnchanted) Then Return False
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
	; Requires pet to be alive
	Local $l_i_PetSize = World_GetWorldInfo("PetInfoArraySize")
    Local $lMyPet = 0

    ; PetNumber starts at 1, not 0
    For $i = 1 To $l_i_PetSize
        If Party_GetPetInfo($i, "OwnerAgentID") = UAI_GetPlayerInfo($GC_UAI_AGENT_ID) Then
            $lMyPet = Party_GetPetInfo($i, "AgentID")
            ExitLoop
        EndIf
    Next

    If $lMyPet = 0 Then Return False

    If Agent_GetAgentInfo($lMyPet, "HPPercent") = 0 Then Return False
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
	; Block skill - use when adjacent enemies are present
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
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

; Skill ID: 2733 - $GC_I_SKILL_ID_FALKEN_QUICK
Func CanUse_FalkenQuick()
	Return True
EndFunc

Func BestTarget_FalkenQuick($a_f_AggroRange)
	; Description
	; Skill. A good courier doesn't need luck; a good courier just needs to be FAST! You move 50% faster.
	; Concise description
	; Skill. You move 50% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2865 - $GC_I_SKILL_ID_RITUAL_LORD_PvP
Func CanUse_RitualLordPvP()
	Return True
EndFunc

Func BestTarget_RitualLordPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
