#include-once

Func Anti_Shout()
	;Cacophony did damage when cast a shout
	;If scale damage make more damage than our HP + 50 then true (don't cast)
	If CachedAgent_HasEffect($GC_I_SKILL_ID_CACOPHONY) Then
		If Effect_GetEffectArg($GC_I_SKILL_ID_CACOPHONY, "Scale") > (Agent_GetAgentInfo(-2, "CurrentHP") + 50) Then Return True
	EndIf
	If CachedAgent_HasEffect($GC_I_SKILL_ID_VOCAL_MINORITY) Then Return True
	If CachedAgent_HasEffect($GC_I_SKILL_ID_WELL_OF_SILENCE) Then Return True
	Return False
EndFunc

Func CanUse_ToTheLimit()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ToTheLimit($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IWillAvengeYou()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IWillAvengeYou($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForGreatJustice()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForGreatJustice($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WatchYourself()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_WatchYourself($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Charge()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Charge($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_VictoryIsMine()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VictoryIsMine($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FearMe()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FearMe($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ShieldsUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldsUp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IWillSurvive()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IWillSurvive($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DontBelieveTheirLies()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DontBelieveTheirLies($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfFerocity()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfFerocity($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfProtection()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfProtection($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfElementalProtection()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfElementalProtection($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfVitality()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfVitality($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHaste($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfHealing()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHealing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfResilience()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfResilience($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfFeeding()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfFeeding($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfTheHunter()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfTheHunter($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfBrutality()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfBrutality($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfDisruption()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfDisruption($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SymbioticBond()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SymbioticBond($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_OtyughsCry()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_OtyughsCry($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Retreat()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Retreat($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_KilroyStonekin()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_KilroyStonekin($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AimTrue()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_AimTrue($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Coward()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Coward($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Headshot()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Headshot($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NoneShallPass()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NoneShallPass($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_OnYourKnees()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_OnYourKnees($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RemoveWithHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveWithHaste($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MmmmSnowcone()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MmmmSnowcone($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LetsGetEm()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_LetsGetEm($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YouWillDie()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouWillDie($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SongOfTheMists()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfTheMists($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PredatoryBond()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_PredatoryBond($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_EchoingBanishment()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_EchoingBanishment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YoureAllAlone()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YoureAllAlone($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_EnemiesMustDie()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_EnemiesMustDie($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StrikeAsOne()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StrikeAsOne($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Godspeed()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Godspeed($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_GoForTheEyes()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_GoForTheEyes($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BraceYourself()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_BraceYourself($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StandYourGround()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandYourGround($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LeadTheWay()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_LeadTheWay($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MakeHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MakeHaste($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WeShallReturn()
	If Anti_Shout() Then Return False
	If CachedAgent_HasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or CachedAgent_HasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_WeShallReturn($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverGiveUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverGiveUp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_HelpMe()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_HelpMe($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FallBack()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FallBack($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Incoming()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Incoming($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheyreOnFire()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheyreOnFire($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverSurrender()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverSurrender($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ItsJustAFleshWound()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ItsJustAFleshWound($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RemoveQueenWail()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveQueenWail($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_QueenWail()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_QueenWail($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MakeYourTime()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MakeYourTime($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CantTouchThis()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CantTouchThis($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FindTheirWeakness()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeakness($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ThePowerIsYours()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ThePowerIsYours($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForgeTheWay()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForgeTheWay($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SteadyAim()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SteadyAim($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SaveYourselvesLuxon()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SaveYourselvesLuxon($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IMeantToDoThat()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IMeantToDoThat($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheresNothingToFear()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNothingToFear($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SpiritRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritRoar($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_VolfenBloodlustCurseOfTheNornbear()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenBloodlustCurseOfTheNornbear($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RavenShriekAGateTooFar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RavenShriekAGateTooFar($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Tremor()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Tremor($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ThunderingRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ThunderingRoar($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DontTrip()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DontTrip($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ByUralsHammer()
	If Anti_Shout() Then Return False
	If CachedAgent_HasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or CachedAgent_HasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_ByUralsHammer($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_KraksCharge()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_KraksCharge($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StandUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandUp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FinishHim()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FinishHim($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DodgeThis()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DodgeThis($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IAmTheStrongest()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IAmTheStrongest($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IAmUnstoppable()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IAmUnstoppable($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YouMoveLikeADwarf()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouMoveLikeADwarf($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YouAreAllWeaklings()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouAreAllWeaklings($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_UrsanRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_UrsanRoar($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_VolfenBloodlust()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenBloodlust($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RavenShriek()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RavenShriek($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_UrsanRoarBloodWashesBlood()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_UrsanRoarBloodWashesBlood($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DestroyTheHumans()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DestroyTheHumans($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TengusMimicry()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TengusMimicry($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfHastePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHastePvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FormUpAndAdvance()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FormUpAndAdvance($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Advance()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Advance($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForElona()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForElona($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CryOfMadness()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CryOfMadness($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MotivatingInsults()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MotivatingInsults($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ItsGoodToBeKing()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ItsGoodToBeKing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MaddeningLaughter()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MaddeningLaughter($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WatchYourselfPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_WatchYourselfPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IncomingPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IncomingPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverSurrenderPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverSurrenderPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForGreatJusticePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForGreatJusticePvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_GoForTheEyesPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_GoForTheEyesPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BraceYourselfPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_BraceYourselfPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CantTouchThisPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CantTouchThisPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StandYourGroundPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandYourGroundPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WeShallReturnPvp()
	If Anti_Shout() Then Return False
	If CachedAgent_HasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or CachedAgent_HasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_WeShallReturnPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FindTheirWeaknessPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeaknessPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverGiveUpPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverGiveUpPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_HelpMePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_HelpMePvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FallBackPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FallBackPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PredatoryBondPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_PredatoryBondPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StickyGround()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StickyGround($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SugarShock()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SugarShock($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheMadKingsInfluence()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheMadKingsInfluence($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheresNotEnoughTime()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNotEnoughTime($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FindTheirWeaknessThackeray()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeaknessThackeray($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheresNothingToFearThackeray()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNothingToFearThackeray($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TangoDown()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TangoDown($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IllBeBack()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IllBeBack($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TogetherAsOne()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TogetherAsOne($aAggroRange)
	Return Agent_GetMyID()
EndFunc
