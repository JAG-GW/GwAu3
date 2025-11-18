#include-once

;If there is the effect return true
Func Anti_Signet()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_IGNORANCE, "HasEffect") Then Return True
	Return False
EndFunc

Func CanUse_AntidoteSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_AntidoteSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ArchersSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_ArchersSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BaneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BaneSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_BarbedSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_BarbedSignetPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSignetPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BlessedSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BlessedSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BoonSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_BoonSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_CandyCornStrike()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CandyCornStrike($aAggroRange)
	Return 0
EndFunc

Func CanUse_CastigationSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CastigationSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_CastigationSignetSaulDalessio()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CastigationSignetSaulDalessio($aAggroRange)
	Return 0
EndFunc

Func CanUse_CauterySignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_CauterySignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DeathPactSignet()
	If Anti_Signet() Then Return False
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_DeathPactSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_DeathPactSignetPvp()
	If Anti_Signet() Then Return False
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_DeathPactSignetPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_DolyakSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_DolyakSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_EtherSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_EtherSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_GlowingSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_GlowingSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_HexEaterSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_HexEaterSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_HealingSignet()
	If Anti_Signet() Then Return False
	If Agent_GetAgentInfo(-2, "HPPercent") > 0.80 Then Return False
	Return True
EndFunc

Func BestTarget_HealingSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_KeystoneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_KeystoneSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LeechSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_LeechSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_LightbringerSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_LightbringerSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PlagueSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PlagueSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_PoisonTipSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonTipSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PolymockBaneSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockBaneSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_PolymockEtherSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockEtherSignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PolymockSignetOfClumsiness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockSignetOfClumsiness($aAggroRange)
	Return 0
EndFunc

Func CanUse_PurgeSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_PurgeSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_RemedySignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_RemedySignet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SadistsSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SadistsSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfAggression()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAggression($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfAgony()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAgony($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfAgonyPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfAgonyPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfBinding()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfBinding($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfClumsiness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfClumsiness($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfClumsinessPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfClumsinessPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfCorruptionKurzick()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCorruptionKurzick($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfCorruptionLuxon()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCorruptionLuxon($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfCreation()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCreation($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfCreationPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfCreationPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfDeadlyCorruption()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDeadlyCorruption($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDeadlyCorruptionPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDeadlyCorruptionPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDevotion()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDevotion($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDisenchantment()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDisenchantment($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDisruption()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDisruption($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfDistraction()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfDistraction($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfGhostlyMight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfGhostlyMight($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfGhostlyMightPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfGhostlyMightPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfHumility()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfHumility($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfIllusions()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfIllusions($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfInfection()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfInfection($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfJudgment()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfJudgment($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfJudgmentPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfJudgmentPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfLostSouls()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfLostSouls($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfMalice()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMalice($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfMidnight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMidnight($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfMysticSpeed()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMysticSpeed($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfMysticWrath()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfMysticWrath($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfPiousLight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousLight($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfPiousRestraint()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousRestraint($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfPiousRestraintPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfPiousRestraintPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfRage()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRage($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfRecall()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRecall($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfRejuvenation()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRejuvenation($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfRemoval()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfRemoval($aAggroRange)
	Return 0
EndFunc

Func CanUse_ResurrectionSignet()
	If Anti_Signet() Then Return False
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_ResurrectionSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfReturn()
	If Anti_Signet() Then Return False
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfReturn($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfReturnPvp()
	If Anti_Signet() Then Return False
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfReturnPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfShadows()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfShadows($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfSorrow()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSorrow($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfSpirits()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSpirits($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfSpiritsPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSpiritsPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfStamina()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfStamina($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfStrength()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfStrength($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfSuffering()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSuffering($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SignetOfSynergy()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfSynergy($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfTheUnseen()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfTheUnseen($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfToxicShock()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfToxicShock($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfTwilight()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfTwilight($aAggroRange)
	Return 0
EndFunc

Func CanUse_SignetOfWeariness()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SignetOfWeariness($aAggroRange)
	Return 0
EndFunc

Func CanUse_SunspearRebirthSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_SunspearRebirthSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_TryptophanSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_TryptophanSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_UnnaturalSignet()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_UnnaturalSignet($aAggroRange)
	Return 0
EndFunc

Func CanUse_UnnaturalSignetPvp()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_UnnaturalSignetPvp($aAggroRange)
	Return 0
EndFunc

Func CanUse_UnnaturalSignetSaulDalessio()
	If Anti_Signet() Then Return False
	Return True
EndFunc

Func BestTarget_UnnaturalSignetSaulDalessio($aAggroRange)
	Return 0
EndFunc

