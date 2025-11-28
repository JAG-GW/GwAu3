#include-once

Func Anti_EchoRefrain()

EndFunc

; Skill ID: 1574 - $GC_I_SKILL_ID_ENDURING_HARMONY
Func CanUse_EnduringHarmony()
	Return True
EndFunc

Func BestTarget_EnduringHarmony($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1575 - $GC_I_SKILL_ID_BLAZING_FINALE
Func CanUse_BlazingFinale()
	Return True
EndFunc

Func BestTarget_BlazingFinale($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1576 - $GC_I_SKILL_ID_BURNING_REFRAIN
Func CanUse_BurningRefrain()
	Return True
EndFunc

Func BestTarget_BurningRefrain($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1577 - $GC_I_SKILL_ID_FINALE_OF_RESTORATION
Func CanUse_FinaleOfRestoration()
	Return True
EndFunc

Func BestTarget_FinaleOfRestoration($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1578 - $GC_I_SKILL_ID_MENDING_REFRAIN
Func CanUse_MendingRefrain()
	Return True
EndFunc

Func BestTarget_MendingRefrain($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1579 - $GC_I_SKILL_ID_PURIFYING_FINALE
Func CanUse_PurifyingFinale()
	Return True
EndFunc

Func BestTarget_PurifyingFinale($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1580 - $GC_I_SKILL_ID_BLADETURN_REFRAIN
Func CanUse_BladeturnRefrain()
	Return True
EndFunc

Func BestTarget_BladeturnRefrain($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1773 - $GC_I_SKILL_ID_SOLDIERS_FURY
Func CanUse_SoldiersFury()
	Return True
EndFunc

Func BestTarget_SoldiersFury($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1774 - $GC_I_SKILL_ID_AGGRESSIVE_REFRAIN
Func CanUse_AggressiveRefrain()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_AGGRESSIVE_REFRAIN) And UAI_GetAgentEffectTimeRemaining(-2, $GC_I_SKILL_ID_AGGRESSIVE_REFRAIN) > 3000 Then Return False
	Return True
EndFunc

Func BestTarget_AggressiveRefrain($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1775 - $GC_I_SKILL_ID_ENERGIZING_FINALE
Func CanUse_EnergizingFinale()
	Return True
EndFunc

Func BestTarget_EnergizingFinale($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2075 - $GC_I_SKILL_ID_HASTY_REFRAIN
Func CanUse_HastyRefrain()
	Return True
EndFunc

Func BestTarget_HastyRefrain($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3028 - $GC_I_SKILL_ID_BLAZING_FINALE_PVP
Func CanUse_BlazingFinalePvp()
	Return True
EndFunc

Func BestTarget_BlazingFinalePvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3029 - $GC_I_SKILL_ID_BLADETURN_REFRAIN_PVP
Func CanUse_BladeturnRefrainPvp()
	Return True
EndFunc

Func BestTarget_BladeturnRefrainPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3062 - $GC_I_SKILL_ID_FINALE_OF_RESTORATION_PVP
Func CanUse_FinaleOfRestorationPvp()
	Return True
EndFunc

Func BestTarget_FinaleOfRestorationPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3149 - $GC_I_SKILL_ID_MENDING_REFRAIN_PVP
Func CanUse_MendingRefrainPvp()
	Return True
EndFunc

Func BestTarget_MendingRefrainPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3431 - $GC_I_SKILL_ID_HEROIC_REFRAIN
Func CanUse_HeroicRefrain()
	Return True
EndFunc

Func BestTarget_HeroicRefrain($a_f_AggroRange)
	If Attribute_GetPartyAttributeInfo($GC_I_ATTR_LEADERSHIP, 0, "CurrentLevel") < 20 Then Return Agent_GetMyID()

	Local $l_ai_PartyArray = Party_GetMembersArray()

	For $l_i_i = 1 To $l_ai_PartyArray[0]
		If UAI_AgentHasEffect($l_ai_PartyArray[$l_i_i], $GC_I_SKILL_ID_HEROIC_REFRAIN) Then ContinueLoop
		Return $l_ai_PartyArray[$l_i_i]
	Next

	Return 0
EndFunc
