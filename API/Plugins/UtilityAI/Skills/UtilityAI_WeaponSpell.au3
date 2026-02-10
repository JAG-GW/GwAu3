#include-once

Func Anti_WeaponSpell()
	;~ Generic hex checks
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False

	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) Then Return True

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
	Return $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50)
EndFunc

; Skill ID: 787 - $GC_I_SKILL_ID_RESILIENT_WEAPON
Func CanUse_ResilientWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_ResilientWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 3...10...12 seconds, target ally has a Resilient Weapon. While suffering from a hex or condition, that ally gains +1...5...6 Health regeneration and +24 armor.
	; Concise description
	; Weapon Spell. (3...10...12 seconds.) +1...5...6 Health regeneration and +24 armor. No effect unless target ally is hexed or has a condition.

	; Best target: ally who is hexed or conditioned (otherwise no effect)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		; Must be hexed or conditioned
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsHexed) And Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsConditioned) Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 792 - $GC_I_SKILL_ID_SPLINTER_WEAPON
Func CanUse_SplinterWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_SplinterWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 20 seconds, target ally has a Splinter Weapon. Target ally's next 1...4...5 attack[s] deal 5...41...50 damage to up to 4 adjacent foes.
	; Concise description
	; Weapon Spell. (20 seconds.) Attacks deal 5...41...50 damage to 3 [sic] adjacent foes. Ends after 1...4...5 attack[s].

	; Best target: attacking ally with most adjacent enemies
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	If $l_i_BestEnemyCount >= 2 Then Return $l_i_BestAlly
	Return 0
EndFunc

; Skill ID: 793 - $GC_I_SKILL_ID_WEAPON_OF_WARDING
Func CanUse_WeaponOfWarding()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfWarding($a_f_AggroRange)
	; Description
	; Weapon Spell. For 3...7...8 seconds, target ally has a Weapon of Warding that grants target ally +2...4...4 Health regeneration and a 50% chance to block.
	; Concise description
	; Weapon Spell. (3...7...8 seconds.) +2...4...4 Health regeneration. 50% chance to block.

	; Best target: ally with lowest HP% being attacked (adjacent enemies)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 794 - $GC_I_SKILL_ID_WAILING_WEAPON
Func CanUse_WailingWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WailingWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 3...8...9 seconds, target ally has a Wailing Weapon. Whenever the Wailing Weapon strikes an attacking foe, that foe is interrupted.
	; Concise description
	; Weapon Spell. (3...8...9 seconds.) Attacks interrupt attacking foes.

	; Best target: attacking ally with most adjacent enemies
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc

; Skill ID: 795 - $GC_I_SKILL_ID_NIGHTMARE_WEAPON
Func CanUse_NightmreWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_NightmareWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 12 seconds, target ally has a Nightmare Weapon. Target ally's next 3 attacks are reduced by 10...42...50 damage and steal up to 10...42...50 Health.
	; Concise description
	; Weapon Spell. (12 seconds.) Target ally's attacks steal 10...42...50 Health but deal 10...42...50 less damage. Ends after 3 attacks.

	; Best target: attacking ally with lowest HP (needs life steal)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 964 - $GC_I_SKILL_ID_VENGEFUL_WEAPON
Func CanUse_VengefulWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_VengefulWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 8 seconds, the next time target ally takes damage or life steal from a foe, that ally steals up to 15...51...60 Health from that foe.
	; Concise description
	; Weapon Spell. (8 seconds.) Steals 15...51...60 Health from the next foe that deals damage or life steal to target ally.

	; Best target: ally with adjacent enemies and lowest HP
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 983 - $GC_I_SKILL_ID_WEAPON_OF_SHADOW
Func CanUse_WeaponOfShadow()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfShadow($a_f_AggroRange)
	; Description
	; Weapon Spell. For 1...6...7 second[s], target ally has a Weapon of Shadow. Whenever that ally is struck by an attack, that ally's attacker becomes Blinded for 5 seconds. The next 1...3...3 times  that ally hits with an attack, his target is Blinded for 5 seconds.
	; Concise description
	; Weapon Spell. (1...6...7 second[s].) Inflicts Blindness condition (5 seconds) on anyone who attacks target ally. Target ally's next 1...3...3 attack[s] inflict Blindness (5 seconds) if they hit.

	; Best target: ally with most adjacent enemies (blind them)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc

; Skill ID: 1257 - $GC_I_SKILL_ID_SPIRIT_LIGHT_WEAPON
Func CanUse_SpiritLightWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritLightWeapon($a_f_AggroRange)
	; Description
	; Elite Weapon Spell. For 10 seconds, target ally gains 1...12...15 Health per second and an additional 1...12...15 Health per second if that ally is within earshot of a spirit.
	; Concise description
	; Elite Weapon Spell. (10 seconds.) Target ally gains 1...12...15 Health each second. 1...12...15 more healing per second while within earshot of a spirit.

	; Best target: ally with lowest HP%
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 1258 - $GC_I_SKILL_ID_BRUTAL_WEAPON
Func CanUse_BrutalWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_BrutalWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. Give target ally a Brutal Weapon for 10...34...40 seconds. The bearer's weapon strikes for +5...13...15 damage as long as the bearer is under no enchantments.
	; Concise description
	; Weapon Spell. (10...34...40 seconds.) Attacks deal +5...13...15 damage. No effect while target ally is enchanted.

	; Best target: attacking ally who is not enchanted
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		If UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsEnchanted) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 1259 - $GC_I_SKILL_ID_GUIDED_WEAPON
Func CanUse_GuidedWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_GuidedWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 4...9...10 seconds, target ally's attacks cannot be blocked.
	; Concise description
	; Weapon Spell. (4...9...10 seconds.) Attacks are unblockable.

	; Best target: attacking ally
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 1267 - $GC_I_SKILL_ID_VITAL_WEAPON
Func CanUse_VitalWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_VitalWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 5...25...30 seconds, target ally has a Vital Weapon and has +40...148...175 maximum Health.
	; Concise description
	; Weapon Spell. (5...25...30 seconds.) +40...148...175 maximum Health.

	; Best target: ally with lowest HP%
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 1268 - $GC_I_SKILL_ID_WEAPON_OF_QUICKENING
Func CanUse_WeaponOfQuickening()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfQuickening($a_f_AggroRange)
	; Description
	; Elite Weapon Spell. For 5...21...25 seconds, target ally has a Weapon of Quickening, and spells and binding rituals recharge 33% faster.
	; Concise description
	; Elite Weapon Spell. (5...21...25 seconds.) Spells and binding rituals recharge 33% faster.

	; Best target: caster ally (benefits from spell recharge)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsCasting) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 1749 - $GC_I_SKILL_ID_WEAPON_OF_FURY
Func CanUse_WeaponOfFury()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfFury($a_f_AggroRange)
	; Description
	; Elite Weapon Spell. For 5...17...20 seconds, target ally gains 5...41...50% more adrenaline and 1 Energy whenever that ally successfully hits with an attack.
	; Concise description
	; Elite Weapon Spell. (5...17...20 seconds.) 5...41...50% more adrenaline gain and +1 Energy whenever target ally hits with an attack.

	; Best target: attacking ally
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 1750 - $GC_I_SKILL_ID_XINRAES_WEAPON
Func CanUse_XinraesWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_XinraesWeapon($a_f_AggroRange)
	; Description
	; Elite Weapon Spell. For 8 seconds, the next time target ally takes damage from a foe that damage is limited to 5% of that ally's max Health and that ally steals up to 20...68...80 Health from that foe.
	; Concise description
	; Elite Weapon Spell. (8 seconds). The next time target ally takes damage from a foe, that damage is limited to 5% of target ally's max Health and that ally steals 20...68...80 Health from that foe.

	; Best target: ally with adjacent enemies and lowest HP (damage protection + heal)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 1751 - $GC_I_SKILL_ID_WARMONGERS_WEAPON
Func CanUse_WarmongersWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WarmongersWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 3...11...13 seconds, if target ally attacks a foe who is not attacking, that foe is interrupted.
	; Concise description
	; Weapon Spell. (3...11...13 seconds.) Attacks interrupt an action. Does not interrupt attacking foes.

	; Best target: attacking ally with adjacent casting enemies
	Local $l_i_BestAlly = 0
	Local $l_i_BestCasterCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Local $l_i_CasterCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemyCaster")
		If $l_i_CasterCount > $l_i_BestCasterCount Then
			$l_i_BestCasterCount = $l_i_CasterCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	If $l_i_BestCasterCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc

; Skill ID: 1752 - $GC_I_SKILL_ID_WEAPON_OF_REMEDY
Func CanUse_WeaponOfRemedy()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfRemedy($a_f_AggroRange)
	; Description
	; Elite Weapon Spell. For 8 seconds, the next time target ally takes damage or life steal from a foe, that ally steals up to 15...63...75 Health from that foe and loses 1 condition.
	; Concise description
	; Elite Weapon Spell. (8 seconds.) The next time target ally takes damage or life steal from a foe, this ally steals 15...63...75 Health from that foe and loses 1 condition.

	; Best target: conditioned ally with adjacent enemies (condition removal + heal)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsConditioned) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 1786 - $GC_I_SKILL_ID_WEAPON_OF_MASTERY
Func CanUse_WeaponOfMastery()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfMastery($a_f_AggroRange)
	; Description
	; Ritualist
	; Concise description
	; green; font-weight: bold;">15...51...60

	; Best target: attacking ally (weapon damage bonus)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 2073 - $GC_I_SKILL_ID_WEAPON_OF_AGGRESSION
Func CanUse_WeaponOfAggression()
	If Anti_WeaponSpell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_IsWeaponSpelled) Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfAggression($a_f_AggroRange)
	; Description
	; Weapon Spell. For 5...13...15 seconds, you attack 25% faster.
	; Concise description
	; Weapon Spell. (5...13...15 seconds.) You attack 25% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2148 - $GC_I_SKILL_ID_SUNDERING_WEAPON
Func CanUse_SunderingWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_SunderingWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 4...9...10 seconds, target ally's next 3 attacks have 10% armor penetration and cause Cracked Armor for 5...17...20 seconds.
	; Concise description
	; Weapon Spell. (4...9...10 seconds.) Target ally's next 3 attacks inflict Cracked Armor condition (5...17...20 seconds) and have 10% armor penetration.

	; Best target: attacking ally
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 2149 - $GC_I_SKILL_ID_WEAPON_OF_RENEWAL
Func CanUse_WeaponOfRenewal()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfRenewal($a_f_AggroRange)
	; Description
	; Weapon Spell. For 4...9...10 seconds, the next time target ally hits with an attack skill, that ally gains 1...6...7 Energy.
	; Concise description
	; Weapon Spell. (4...9...10 seconds.) Target ally gains 1...6...7 Energy the next time this ally hits with an attack skill.

	; Best target: attacking ally with low energy
	Local $l_i_BestAlly = 0
	Local $l_f_LowestEnergy = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Local $l_f_Energy = UAI_GetAgentInfo($i, $GC_UAI_AGENT_CurrentEnergy)
		If $l_f_Energy < $l_f_LowestEnergy Then
			$l_f_LowestEnergy = $l_f_Energy
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 2206 - $GC_I_SKILL_ID_GHOSTLY_WEAPON
Func CanUse_GhostlyWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_GhostlyWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 5...17...20 seconds, target other ally's next attack cannot be blocked.
	; Concise description
	; Weapon Spell. (5...17...20 seconds.) Target ally's next attack is unblockable. Cannot self-target.

	; Best target: attacking ally (not self)
	Local $l_i_PlayerID = UAI_GetPlayerInfo($GC_UAI_AGENT_ID)

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If $l_i_AgentID = $l_i_PlayerID Then ContinueLoop
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 2219 - $GC_I_SKILL_ID_GREAT_DWARF_WEAPON
Func CanUse_GreatDwarfWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_GreatDwarfWeapon($a_f_AggroRange)
	; Description
	; Weapon Spell. For 20 seconds, target other ally's weapon strikes for +15...20 damage and has a 28...40% chance to cause knock down.
	; Concise description
	; Weapon Spell. (20 seconds.) +15...20 weapon damage and 28...40% chance to cause knock-down with attacks. Cannot self-target.

	; Best target: attacking ally (not self)
	Local $l_i_PlayerID = UAI_GetPlayerInfo($GC_UAI_AGENT_ID)

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If $l_i_AgentID = $l_i_PlayerID Then ContinueLoop
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 2868 - $GC_I_SKILL_ID_SPLINTER_WEAPON_PvP
Func CanUse_SplinterWeaponPvP()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_SplinterWeaponPvP($a_f_AggroRange)
	; Description
	; Weapon Spell. For 20 seconds, target ally has a Splinter Weapon. Target ally's next 1...4...5 attack[s] deal 5...25...30 damage to up to 4 adjacent foes.
	; Concise description
	; Weapon Spell. (20 seconds.) Attacks deal 5...25...30 damage to 3 [sic] adjacent foes. Ends after 1...4...5 attack[s].

	; Best target: attacking ally with most adjacent enemies
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	If $l_i_BestEnemyCount >= 2 Then Return $l_i_BestAlly
	Return 0
EndFunc

; Skill ID: 2893 - $GC_I_SKILL_ID_WEAPON_OF_WARDING_PvP
Func CanUse_WeaponOfWardingPvP()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponOfWardingPvP($a_f_AggroRange)
	; Description
	; Weapon Spell. For 3...7...8 seconds, target ally has a Weapon of Warding that grants target ally +2...4...4 Health regeneration and a 50% chance to block.
	; Concise description
	; Weapon Spell. (3...7...8 seconds.) +2...4...4 Health regeneration. 50% chance to block.

	; Best target: ally with lowest HP% being attacked (adjacent enemies)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop

		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop

		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 3429 - $GC_I_SKILL_ID_WEAPONS_OF_THREE_FORGES
Func CanUse_WeaponsOfThreeForges()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc

Func BestTarget_WeaponsOfThreeForges($a_f_AggroRange)
	; Description
	; Elite Weapon Spell. For 3...17...20 seconds, each non-spirit ally in earshot gains the effect of a random Weapon Spell. PvE Skill
	; Concise description
	; Elite Weapon Spell. (3...17...20 seconds.) Allies in earshot gain the effect of a random Weapon Spell. Allied spirits are not affected. PvE Skill
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

