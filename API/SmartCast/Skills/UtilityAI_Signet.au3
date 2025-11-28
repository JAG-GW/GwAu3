#include-once

;If there is the effect return true
Func Anti_Signet()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE) Then Return True
	Return False
EndFunc

Func CanUse_SignetOfCapture()
	Return False
EndFunc

Func BestTarget_SignetOfCapture($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AntidoteSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_AntidoteSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ArchersSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_ArchersSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BaneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BaneSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_BarbedSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_BarbedSignetPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSignetPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BlessedSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BlessedSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BoonSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BoonSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_CandyCornStrike()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CandyCornStrike($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_CastigationSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CastigationSignet($a_f_AggroRange)
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
	Return Agent_GetMyID()
EndFunc

Func CanUse_DeathPactSignet()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_DeathPactSignet($a_f_AggroRange)
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
	Return Agent_GetMyID()
EndFunc

Func CanUse_EtherSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_EtherSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_GlowingSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_GlowingSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_HexEaterSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_HexEaterSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_HealingSignet()
	If Anti_Signet() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.80 Then Return False
	Return True
EndFunc

Func BestTarget_HealingSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_KeystoneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_KeystoneSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LeechSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_LeechSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_LightbringerSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_LightbringerSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PlagueSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PlagueSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_PoisonTipSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonTipSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PolymockBaneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockBaneSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_PolymockEtherSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockEtherSignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PolymockSignetOfClumsiness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSignetOfClumsiness($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_PurgeSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PurgeSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_RemedySignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_RemedySignet($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SadistsSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SadistsSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfAggression()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAggression($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfAgony()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAgony($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfAgonyPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAgonyPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfBinding()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfBinding($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfClumsiness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfClumsiness($a_f_AggroRange)
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
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfCreationPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCreationPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfDeadlyCorruption()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDeadlyCorruption($a_f_AggroRange)
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
	Return 0
EndFunc

Func CanUse_SignetOfDisenchantment()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDisenchantment($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDisruption()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDisruption($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDistraction()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDistraction($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfGhostlyMight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfGhostlyMight($a_f_AggroRange)
	Return Agent_GetMyID()
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
	Return 0
EndFunc

Func CanUse_SignetOfIllusions()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfIllusions($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfInfection()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfInfection($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfJudgment()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfJudgment($a_f_AggroRange)
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
	Return 0
EndFunc

Func CanUse_SignetOfMalice()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMalice($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfMidnight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMidnight($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfMysticSpeed()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMysticSpeed($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfMysticWrath()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMysticWrath($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfPiousLight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousLight($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfPiousRestraint()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousRestraint($a_f_AggroRange)
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
	Return 0
EndFunc

Func CanUse_SignetOfRecall()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRecall($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfRejuvenation()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRejuvenation($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfRemoval()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRemoval($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_ResurrectionSignet()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_ResurrectionSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfReturn()
	If Anti_Signet() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfReturn($a_f_AggroRange)
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
	Return 0
EndFunc

Func CanUse_SignetOfSorrow()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSorrow($a_f_AggroRange)
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
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfSpiritsPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSpiritsPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfStamina()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfStamina($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfStrength()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfStrength($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfSuffering()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSuffering($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfSynergy()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSynergy($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfTheUnseen()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfTheUnseen($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfToxicShock()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfToxicShock($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfTwilight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfTwilight($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfWeariness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfWeariness($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_SunspearRebirthSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SunspearRebirthSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_TryptophanSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_TryptophanSignet($a_f_AggroRange)
	Return 0
EndFunc

Func CanUse_UnnaturalSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_UnnaturalSignet($a_f_AggroRange)
	Return 0
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

