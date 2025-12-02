#include-once

Func Anti_EchoRefrain()

EndFunc

; Skill ID: 1574 - $GC_I_SKILL_ID_ENDURING_HARMONY
Func CanUse_EnduringHarmony()
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
	Return True
EndFunc

Func BestTarget_BlazingFinale($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, whenever a chant or shout ends on target non-spirit ally, all foes adjacent to that ally are set on Fire for 1...6...7 second[s].
	; Concise description
	; Echo. (10...30...35 seconds.) Inflicts Burning condition (1...6...7 second[s]) to adjacent foes whenever a chant or shout ends on target ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 1576 - $GC_I_SKILL_ID_BURNING_REFRAIN
Func CanUse_BurningRefrain()
	Return True
EndFunc

Func BestTarget_BurningRefrain($a_f_AggroRange)
	; Description
	; Echo. For 20 seconds, if target non-spirit ally hits a foe with more Health than that ally, that foe is set on Fire  for 1...3...3 second[s]. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (20 seconds.) Inflicts Burning condition (1...3...3 second[s]) if target ally hits a foe with more Health. Renewal: Whenever a chant or shout ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 1577 - $GC_I_SKILL_ID_FINALE_OF_RESTORATION
Func CanUse_FinaleOfRestoration()
	Return True
EndFunc

Func BestTarget_FinaleOfRestoration($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, whenever a chant or shout ends on target non-spirit ally, that ally is healed for 15...63...75 Health.
	; Concise description
	; Echo. (10...30...35 seconds.) Target ally gains [sic] 15...63...75 Health whenever a shout or chant ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 1578 - $GC_I_SKILL_ID_MENDING_REFRAIN
Func CanUse_MendingRefrain()
	Return True
EndFunc

Func BestTarget_MendingRefrain($a_f_AggroRange)
	; Description
	; Echo. For 15 seconds, target non-spirit ally has +2...3...3 Health regeneration. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (15 seconds.) Target ally has +2...3...3 Health regeneration. Renewal: whenever a chant or shout ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 1579 - $GC_I_SKILL_ID_PURIFYING_FINALE
Func CanUse_PurifyingFinale()
	Return True
EndFunc

Func BestTarget_PurifyingFinale($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, target non-spirit ally loses 1 condition whenever a chant or shout ends on that ally.
	; Concise description
	; Echo. (10...30...35 seconds.) Target ally loses one condition whenever a chant or shout ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 1580 - $GC_I_SKILL_ID_BLADETURN_REFRAIN
Func CanUse_BladeturnRefrain()
	Return True
EndFunc

Func BestTarget_BladeturnRefrain($a_f_AggroRange)
	; Description
	; Echo. For 20 seconds, target non-spirit ally has a 5...17...20% chance to block incoming attacks. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (20 seconds.) Target ally has 5...17...20% chance to block. Renewal: Whenever a chant or shout ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 1773 - $GC_I_SKILL_ID_SOLDIERS_FURY
Func CanUse_SoldiersFury()
	Return True
EndFunc

Func BestTarget_SoldiersFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1774 - $GC_I_SKILL_ID_AGGRESSIVE_REFRAIN
Func CanUse_AggressiveRefrain()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_AGGRESSIVE_REFRAIN) And UAI_GetAgentEffectTimeRemaining(-2, $GC_I_SKILL_ID_AGGRESSIVE_REFRAIN) > 3000 Then Return False
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
	Return True
EndFunc

Func BestTarget_EnergizingFinale($a_f_AggroRange)
	; Description
	; Echo. For 10...30...35 seconds, whenever a shout or chant ends on target non-spirit ally, that ally gains 1 Energy.
	; Concise description
	; Echo. (10...30...35 seconds.) Target ally gains 1 Energy whenever a shout or chant ends on that ally. Cannot target spirits.
	Return 0
EndFunc

; Skill ID: 2075 - $GC_I_SKILL_ID_HASTY_REFRAIN
Func CanUse_HastyRefrain()
	Return True
EndFunc

Func BestTarget_HastyRefrain($a_f_AggroRange)
	; Description
	; Echo. For 3...9...11 seconds, target ally moves 25% faster. This echo is reapplied every time a chant or shout ends on that ally.
	; Concise description
	; Echo. (3...9...11 seconds.) Target ally moves 25% faster. Renewal: every time a chant or shout ends on this ally.
	Return 0
EndFunc

; Skill ID: 3028 - $GC_I_SKILL_ID_BLAZING_FINALE_PvP
Func CanUse_BlazingFinalePvP()
	Return True
EndFunc

Func BestTarget_BlazingFinalePvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3029 - $GC_I_SKILL_ID_BLADETURN_REFRAIN_PvP
Func CanUse_BladeturnRefrainPvP()
	Return True
EndFunc

Func BestTarget_BladeturnRefrainPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3062 - $GC_I_SKILL_ID_FINALE_OF_RESTORATION_PvP
Func CanUse_FinaleOfRestorationPvP()
	Return True
EndFunc

Func BestTarget_FinaleOfRestorationPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3149 - $GC_I_SKILL_ID_MENDING_REFRAIN_PvP
Func CanUse_MendingRefrainPvP()
	Return True
EndFunc

Func BestTarget_MendingRefrainPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3431 - $GC_I_SKILL_ID_HEROIC_REFRAIN
Func CanUse_HeroicRefrain()
	Return True
EndFunc

Func BestTarget_HeroicRefrain($a_f_AggroRange)
	If Attribute_GetPartyAttributeInfo($GC_I_ATTR_LEADERSHIP, 0, "CurrentLevel") < 20 Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)

	Local $l_ai_PartyArray = Party_GetMembersArray()

	For $l_i_i = 1 To $l_ai_PartyArray[0]
		If UAI_AgentHasEffect($l_ai_PartyArray[$l_i_i], $GC_I_SKILL_ID_HEROIC_REFRAIN) Then ContinueLoop
		Return $l_ai_PartyArray[$l_i_i]
	Next

	Return 0
EndFunc
