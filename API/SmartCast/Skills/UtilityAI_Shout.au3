#include-once

Func Anti_Shout()
	;Cacophony did damage when cast a shout
	;If scale damage make more damage than our HP + 50 then true (don't cast)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CACOPHONY) Then
		If Effect_GetEffectArg($GC_I_SKILL_ID_CACOPHONY, "Scale") > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50) Then Return True
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VOCAL_MINORITY) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_WELL_OF_SILENCE) Then Return True
	Return False
EndFunc

Func CanUse_ToTheLimit()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ToTheLimit($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IWillAvengeYou()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IWillAvengeYou($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForGreatJustice()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForGreatJustice($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WatchYourself()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_WatchYourself($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Charge()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Charge($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_VictoryIsMine()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VictoryIsMine($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FearMe()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FearMe($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ShieldsUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldsUp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IWillSurvive()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IWillSurvive($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DontBelieveTheirLies()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DontBelieveTheirLies($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfFerocity()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfFerocity($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfProtection()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfProtection($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfElementalProtection()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfElementalProtection($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfVitality()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfVitality($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHaste($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfHealing()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHealing($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfResilience()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfResilience($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfFeeding()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfFeeding($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfTheHunter()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfTheHunter($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfBrutality()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfBrutality($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfDisruption()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfDisruption($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SymbioticBond()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SymbioticBond($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_OtyughsCry()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_OtyughsCry($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Retreat()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Retreat($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_KilroyStonekin()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_KilroyStonekin($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AimTrue()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_AimTrue($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Coward()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Coward($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Headshot()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Headshot($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NoneShallPass()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NoneShallPass($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_OnYourKnees()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_OnYourKnees($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RemoveWithHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveWithHaste($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MmmmSnowcone()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MmmmSnowcone($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LetsGetEm()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_LetsGetEm($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YouWillDie()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouWillDie($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SongOfTheMists()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfTheMists($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PredatoryBond()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_PredatoryBond($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_EchoingBanishment()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_EchoingBanishment($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YoureAllAlone()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YoureAllAlone($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_EnemiesMustDie()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_EnemiesMustDie($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StrikeAsOne()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StrikeAsOne($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Godspeed()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Godspeed($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_GoForTheEyes()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_GoForTheEyes($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BraceYourself()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_BraceYourself($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StandYourGround()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandYourGround($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LeadTheWay()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_LeadTheWay($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MakeHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MakeHaste($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WeShallReturn()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_WeShallReturn($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverGiveUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverGiveUp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_HelpMe()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_HelpMe($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FallBack()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FallBack($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Incoming()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Incoming($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheyreOnFire()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_THEYRE_ON_FIRE) Then Return False
	Return True
EndFunc

Func BestTarget_TheyreOnFire($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverSurrender()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverSurrender($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ItsJustAFleshWound()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ItsJustAFleshWound($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RemoveQueenWail()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveQueenWail($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_QueenWail()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_QueenWail($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MakeYourTime()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MakeYourTime($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CantTouchThis()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CantTouchThis($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FindTheirWeakness()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeakness($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ThePowerIsYours()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ThePowerIsYours($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForgeTheWay()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForgeTheWay($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SteadyAim()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SteadyAim($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SaveYourselvesLuxon()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SaveYourselvesLuxon($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SaveYourselvesKurzick()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SaveYourselvesKurzick($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IMeantToDoThat()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IMeantToDoThat($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheresNothingToFear()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNothingToFear($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SpiritRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritRoar($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_VolfenBloodlustCurseOfTheNornbear()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenBloodlustCurseOfTheNornbear($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RavenShriekAGateTooFar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RavenShriekAGateTooFar($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Tremor()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Tremor($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ThunderingRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ThunderingRoar($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DontTrip()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DontTrip($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ByUralsHammer()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_ByUralsHammer($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_KraksCharge()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_KraksCharge($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StandUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandUp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FinishHim()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FinishHim($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DodgeThis()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DodgeThis($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IAmTheStrongest()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IAmTheStrongest($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IAmUnstoppable()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IAmUnstoppable($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YouMoveLikeADwarf()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouMoveLikeADwarf($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_YouAreAllWeaklings()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouAreAllWeaklings($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_UrsanRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_UrsanRoar($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_VolfenBloodlust()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenBloodlust($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_RavenShriek()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RavenShriek($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_UrsanRoarBloodWashesBlood()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_UrsanRoarBloodWashesBlood($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DestroyTheHumans()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DestroyTheHumans($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TengusMimicry()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TengusMimicry($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CallOfHastePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHastePvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FormUpAndAdvance()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FormUpAndAdvance($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_Advance()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Advance($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForElona()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForElona($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CryOfMadness()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CryOfMadness($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MotivatingInsults()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MotivatingInsults($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ItsGoodToBeKing()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ItsGoodToBeKing($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_MaddeningLaughter()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MaddeningLaughter($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WatchYourselfPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_WatchYourselfPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IncomingPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IncomingPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverSurrenderPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverSurrenderPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ForGreatJusticePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForGreatJusticePvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_GoForTheEyesPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_GoForTheEyesPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BraceYourselfPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_BraceYourselfPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CantTouchThisPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CantTouchThisPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StandYourGroundPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandYourGroundPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_WeShallReturnPvp()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_WeShallReturnPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FindTheirWeaknessPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeaknessPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_NeverGiveUpPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverGiveUpPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_HelpMePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_HelpMePvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FallBackPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FallBackPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PredatoryBondPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_PredatoryBondPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_StickyGround()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StickyGround($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SugarShock()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SugarShock($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheMadKingsInfluence()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheMadKingsInfluence($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheresNotEnoughTime()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNotEnoughTime($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_FindTheirWeaknessThackeray()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeaknessThackeray($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TheresNothingToFearThackeray()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNothingToFearThackeray($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TangoDown()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TangoDown($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_IllBeBack()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IllBeBack($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_TogetherAsOne()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TogetherAsOne($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc
