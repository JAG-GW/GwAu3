#include-once

Func Anti_EchoRefrain()
	Return False
EndFunc

; Skill ID: 1574 - $GC_I_SKILL_ID_ENDURING_HARMONY
Func CanUse_EnduringHarmony()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_EnduringHarmony($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, chants and shouts last 50% longer on target non-spirit ally.
	; Concise description
	; Echo. (10...30...35 seconds.) Chants and shouts last 50% longer on target ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 1575 - $GC_I_SKILL_ID_BLAZING_FINALE
Func CanUse_BlazingFinale()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_BlazingFinale($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, whenever a chant or shout ends on target non-spirit ally, all foes adjacent to that ally are set on Fire for 1...6...7 second[s].
	; Concise description
	; Echo. (10...30...35 seconds.) Inflicts Burning condition (1...6...7 second[s]) to adjacent foes whenever a chant or shout ends on target ally. Cannot target spirits.

	; Find ally with most adjacent enemies (best position for burning effect)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Blazing Finale
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_BLAZING_FINALE) Then ContinueLoop

		; Count adjacent enemies around this ally
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")

		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	; Require at least 1 adjacent enemy to make the skill worthwhile
	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly

	Return 0
EndFunc

; Skill ID: 1576 - $GC_I_SKILL_ID_BURNING_REFRAIN
Func CanUse_BurningRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_BurningRefrain($a_f_AggroRange)
	; Description
	; Echo. For 20 seconds, if target non-spirit ally hits a foe with more Health than that ally, that foe is set on Fire  for 1...3...3 second[s]. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (20 seconds.) Inflicts Burning condition (1...3...3 second[s]) if target ally hits a foe with more Health. Renewal: Whenever a chant or shout ends on that ally. Cannot target spirits.

	; Best targets: melee allies with low HP (more likely to trigger burning on hits)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 999999

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Burning Refrain
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_BURNING_REFRAIN) Then ContinueLoop

		; Get current HP - lower HP means more likely to trigger (enemy has more HP)
		Local $l_f_CurrentHP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_CurrentHP)

		If $l_f_CurrentHP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_CurrentHP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 1577 - $GC_I_SKILL_ID_FINALE_OF_RESTORATION
Func CanUse_FinaleOfRestoration()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_FinaleOfRestoration($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, whenever a chant or shout ends on target non-spirit ally, that ally is healed for 15...63...75 Health.
	; Concise description
	; Echo. (10...30...35 seconds.) Target ally gains [sic] 15...63...75 Health whenever a shout or chant ends on that ally. Cannot target spirits.

	; Best target: ally with lowest HP% (needs healing most)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Finale of Restoration
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_FINALE_OF_RESTORATION) Then ContinueLoop

		; Get HP percentage - lower is better (needs healing)
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)

		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 1578 - $GC_I_SKILL_ID_MENDING_REFRAIN
Func CanUse_MendingRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_MendingRefrain($a_f_AggroRange)
	; Description
	; Echo. For 15 seconds, target non-spirit ally has +2...3...3 Health regeneration. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (15 seconds.) Target ally has +2...3...3 Health regeneration. Renewal: whenever a chant or shout ends on that ally. Cannot target spirits.

	; Best target: melee ally with lowest HP% (takes damage, benefits from regen)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Mending Refrain
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_MENDING_REFRAIN) Then ContinueLoop

		; Get HP percentage - lower is better
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)

		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 1579 - $GC_I_SKILL_ID_PURIFYING_FINALE
Func CanUse_PurifyingFinale()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_PurifyingFinale($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, target non-spirit ally loses 1 condition whenever a chant or shout ends on that ally.
	; Concise description
	; Echo. (10...30...35 seconds.) Target ally loses one condition whenever a chant or shout ends on that ally. Cannot target spirits.

	; Best target: ally with conditions
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Purifying Finale
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_PURIFYING_FINALE) Then ContinueLoop

		; Must have a condition
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsConditioned) Then ContinueLoop

		Return $l_i_AgentID
	Next

	Return 0
EndFunc

; Skill ID: 1580 - $GC_I_SKILL_ID_BLADETURN_REFRAIN
Func CanUse_BladeturnRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_BladeturnRefrain($a_f_AggroRange)
	; Description
	; Echo. For 20 seconds, target non-spirit ally has a 5...17...20% chance to block incoming attacks. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (20 seconds.) Target ally has 5...17...20% chance to block. Renewal: Whenever a chant or shout ends on that ally. Cannot target spirits.

	; Best target: melee ally with most adjacent enemies (being attacked most)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Bladeturn Refrain
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_BLADETURN_REFRAIN) Then ContinueLoop

		; Count adjacent enemies (more enemies = more attacks to block)
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")

		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	; Require at least 1 adjacent enemy
	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly

	Return 0
EndFunc

; Skill ID: 1773 - $GC_I_SKILL_ID_SOLDIERS_FURY
Func CanUse_SoldiersFury()
	If Anti_EchoRefrain() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOLDIERS_FURY, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc

Func BestTarget_SoldiersFury($a_f_AggroRange)
	; Description
	; Elite Echo. For 10...30...35 seconds, if you are under the effects of a chant or a shout, you attack 33% faster and gain 33% more adrenaline, but you have -20 armor.
	; Concise description
	; Elite Echo. (10...30...35 seconds.) You attack 33% faster and gain 33% more adrenaline if under the effects of a shout or chant. You have -20 armor.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1774 - $GC_I_SKILL_ID_AGGRESSIVE_REFRAIN
Func CanUse_AggressiveRefrain()
	If Anti_EchoRefrain() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AGGRESSIVE_REFRAIN, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc

Func BestTarget_AggressiveRefrain($a_f_AggroRange)
	; Description
	; Echo. For 5...21...25 seconds, you attack 25% faster but have -20 armor. This echo is reapplied every time a chant or shout ends on you.
	; Concise description
	; Echo. (5...21...25 seconds.) You attack 25% faster. Renewal: whenever a chant or shout ends on you. You have -20 armor.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1775 - $GC_I_SKILL_ID_ENERGIZING_FINALE
Func CanUse_EnergizingFinale()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_EnergizingFinale($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, whenever a shout or chant ends on target non-spirit ally, that ally gains 1 Energy.
	; Concise description
	; Echo. (10...30...35 seconds.) Target ally gains 1 Energy whenever a shout or chant ends on that ally. Cannot target spirits.

	; Best target: ally with lowest energy percentage
	Local $l_i_BestAlly = 0
	Local $l_f_LowestEnergy = 1.0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Energizing Finale
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_ENERGIZING_FINALE) Then ContinueLoop

		; Get energy percentage - lower is better
		Local $l_f_Energy = UAI_GetAgentInfo($i, $GC_UAI_AGENT_EnergyPercent)

		If $l_f_Energy < $l_f_LowestEnergy Then
			$l_f_LowestEnergy = $l_f_Energy
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	Return $l_i_BestAlly
EndFunc

; Skill ID: 2075 - $GC_I_SKILL_ID_HASTY_REFRAIN
Func CanUse_HastyRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_HastyRefrain($a_f_AggroRange)
	; Description
	; Echo. For 3...9...11 seconds, target ally moves 25% faster. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (3...9...11 seconds.) Target ally moves 25% faster. Renewal: every time a chant or shout ends on this ally.

	; Best target: farthest ally without the effect (needs speed boost to catch up)
	Local $l_i_BestAlly = 0
	Local $l_f_FarthestDist = 0
	Local $l_i_FallbackAlly = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Must be living ally
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		; Cannot target spirits
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop

		; Check distance from player
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

		; Skip if already has Hasty Refrain
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_HASTY_REFRAIN) Then ContinueLoop

		; Track fallback (any ally without effect)
		If $l_i_FallbackAlly = 0 Then $l_i_FallbackAlly = $l_i_AgentID

		; Track farthest ally
		If $l_f_Distance > $l_f_FarthestDist Then
			$l_f_FarthestDist = $l_f_Distance
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next

	; Return farthest if found, otherwise fallback
	If $l_i_BestAlly <> 0 Then Return $l_i_BestAlly
	Return $l_i_FallbackAlly
EndFunc

; Skill ID: 3028 - $GC_I_SKILL_ID_BLAZING_FINALE_PvP
Func CanUse_BlazingFinalePvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_BlazingFinalePvP($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, whenever a chant or shout ends on target non-spirit ally, all foes adjacent to that ally are set on Fire for 1...3...3 second[s].
	; Concise description
	; Echo. (10...30...35 seconds.) Inflicts Burning condition (1...3...3 second[s]) to adjacent foes whenever a chant or shout ends on target ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 3029 - $GC_I_SKILL_ID_BLADETURN_REFRAIN_PvP
Func CanUse_BladeturnRefrainPvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_BladeturnRefrainPvP($a_f_AggroRange)
	; Description
	; Echo. For 20 seconds, target non-spirit ally has +10...34...40 armor against slashing damage. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (20 seconds.) Target ally has +10...34...40 armor against slashing damage. Renewal: Whenever a chant or shout ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 3062 - $GC_I_SKILL_ID_FINALE_OF_RESTORATION_PvP
Func CanUse_FinaleOfRestorationPvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_FinaleOfRestorationPvP($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, the next 5 times that a chant or shout ends on target non-spirit ally, that ally is healed for 15...63...75 Health.
	; Concise description
	; Echo. (10...30...35 seconds.) Target ally gains [sic] 15...63...75 Health the next 5 times a shout or chant ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 3149 - $GC_I_SKILL_ID_MENDING_REFRAIN_PvP
Func CanUse_MendingRefrainPvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_MendingRefrainPvP($a_f_AggroRange)
	; Description
	; Echo. For 15 seconds, you have +2...3...3 Health regeneration. This echo is reapplied every time a chant or shout ends on you.
	; Concise description
	; Echo. (15 seconds.) You have +2...3...3 Health regeneration. Renewal: whenever a chant or shout ends on you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3431 - $GC_I_SKILL_ID_HEROIC_REFRAIN
Func CanUse_HeroicRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc

Func BestTarget_HeroicRefrain($a_f_AggroRange)
	; Description
	; Elite Echo. For 3...13...15 seconds, target non-spirit ally gains +1...3...3 to all attributes. This echo is reapplied every time a chant or shout ends on that ally. PvE Skill
	; Concise description
	; Elite Echo. (3...13...15 seconds.) Target ally gains +1...3...3 to all attributes. Renewal: every time a chant or shout ends on this ally. Cannot target spirits. PvE Skill
	If Attribute_GetPartyAttributeInfo($GC_I_ATTRIBUTE_LEADERSHIP, 0, "CurrentLevel") < 20 Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)

	Local $l_ai_PartyArray = Party_GetMembersArray()

	For $i = 1 To $l_ai_PartyArray[0]
		If UAI_AgentHasEffect($l_ai_PartyArray[$i], $GC_I_SKILL_ID_HEROIC_REFRAIN) Then ContinueLoop
		Return $l_ai_PartyArray[$i]
	Next

	Return 0
EndFunc
