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
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_IWillAvengeYou()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IWillAvengeYou($a_f_AggroRange)
	; Description
	; Shout. For each dead ally, you gain 10 seconds of +3...6...7 Health regeneration and your attack speed increases by 25%.
	; Concise description
	; Shout. You have +3...6...7 Health regeneration and attack 25% faster (10 seconds for each dead ally).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ForGreatJustice()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForGreatJustice($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_WatchYourself()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_WatchYourself($a_f_AggroRange)
	; Description
	; Shout. Party members within earshot gain +5...21...25 armor for 10 seconds. This shout ends after 10 incoming attacks.
	; Concise description
	; Shout. (10 seconds.) Party members in earshot have +5...21...25 armor. Ends after 10 incoming attacks.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Charge()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Charge($a_f_AggroRange)
	; Description
	; Elite Shout. Allies in earshot lose the Crippled condition. For 5...11...13 seconds, these allies move 33% faster.
	; Concise description
	; Elite Shout. (5...11...13 seconds.) Allies in earshot move 33% faster. Initial effect: these allies lose the Crippled condition.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_VictoryIsMine()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VictoryIsMine($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FearMe()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FearMe($a_f_AggroRange)
	; Description
	; Shout. All nearby foes lose 1...3...4 Energy. For 1...12...15 second[s], your melee attacks gain +5...25...30% chance of a critical hit against stationary foes.
	; Concise description
	; Shout. (1...12...15 second[s].) You have +5...25...30% chance of a critical hit with melee attacks against stationary foes. Initial effect: nearby foes lose 1...3...4 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ShieldsUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldsUp($a_f_AggroRange)
	; Description
	; Shout. For 5...10...11 seconds, you and all party members within earshot gain +60 armor against incoming projectile attacks.
	; Concise description
	; Shout. (5...10...11 seconds.) Party members in earshot have +60 armor against projectile attacks.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_IWillSurvive()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IWillSurvive($a_f_AggroRange)
	; Description
	; Shout. You gain +3 Health regeneration for each condition you are suffering. This regeneration expires after 5...10...11 seconds.
	; Concise description
	; Shout. (5...10...11 seconds.) You have +3 Health regeneration for each condition on you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_DontBelieveTheirLies()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DontBelieveTheirLies($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfFerocity()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfFerocity($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">5%...50%
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfProtection()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfProtection($a_f_AggroRange)
	; Description
	; Shout. For 120 seconds, your animal companion has a 5...17...20 base damage reduction.
	; Concise description
	; Shout. (120 seconds.) Your pet has 5...17...20 damage reduction.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfElementalProtection()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfElementalProtection($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">1...11...14
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfVitality()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfVitality($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">1...11...14
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHaste($a_f_AggroRange)
	; Description
	; Shout. For 30 seconds, your animal companion has a 33% faster attack speed and moves 33% faster.
	; Concise description
	; Shout. (30 seconds.) Your pet moves and attacks 33% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfHealing()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHealing($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">1...11...14
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfResilience()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfResilience($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; Trivia">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfFeeding()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfFeeding($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">1...11...14
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfTheHunter()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfTheHunter($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">5...41...50
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfBrutality()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfBrutality($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">5...41...50
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfDisruption()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfDisruption($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">5...41...50
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SymbioticBond()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SymbioticBond($a_f_AggroRange)
	; Description
	; Shout. For 120...264...300 seconds, your animal companion gains 1...3...3 Health regeneration, and half of all damage dealt to your animal companion is redirected to you.
	; Concise description
	; Shout. (120...264...300 seconds.) Your pet has +1...3...3 Health regeneration. Half of all damage dealt to your pet is redirected to you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_OtyughsCry()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_OtyughsCry($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Retreat()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Retreat($a_f_AggroRange)
	; Description
	; Shout. If there are any dead allies within earshot, your party moves 33% faster for 5...10...11 seconds.
	; Concise description
	; Shout. (5...10...11 seconds.) Party members in earshot move 33% faster. No effect unless there are dead allies within earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_KilroyStonekin()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_KilroyStonekin($a_f_AggroRange)
	; Description
	; This article is about the NPC. For the quest, see Kilroy Stonekin (quest).
	; Concise description
	; This article is about the NPC. For the quest, see Kilroy Stonekin (quest).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AimTrue()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_AimTrue($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Coward()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Coward($a_f_AggroRange)
	; Description
	; Elite Shout. If target foe is moving, that foe is knocked down.
	; Concise description
	; Elite Shout. Causes knock-down if target foe is moving.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Headshot()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Headshot($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_NoneShallPass()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NoneShallPass($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_OnYourKnees()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_OnYourKnees($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_RemoveWithHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveWithHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_MmmmSnowcone()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MmmmSnowcone($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_LetsGetEm()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_LetsGetEm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_YouWillDie()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouWillDie($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SongOfTheMists()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfTheMists($a_f_AggroRange)
	; Description
	; Shout. For 10 seconds, each nearby ally gains +6 Energy regeneration. If an ally successfully uses a skill, Song of The Mists ends and steals 20 Health from the nearest foe.
	; Concise description
	; Shout. (10 seconds.) +6 Energy regeneration to nearby allies. If an ally successfully uses a skill, Song of The Mists ends and steals 20 Health from the nearest foe.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_PredatoryBond()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_PredatoryBond($a_f_AggroRange)
	; Description
	; Shout. For 5...17...20 seconds, your animal companion attacks 25% faster and heals you for 1...25...31 Health with each successful attack.
	; Concise description
	; Shout. (5...17...20 seconds.) Your pet attacks 25% faster and you gain 1...25...31 Health whenever your pet makes a successful attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_EchoingBanishment()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_EchoingBanishment($a_f_AggroRange)
	; Description
	; Shout. Target foe is banished to the mists and his spirit bound to Shiro. If the Spirit Binder is destroyed, the spirit is freed.
	; Concise description
	; Shout. Target foe is banished to the mists and his spirit bound to Shiro. If the Spirit Binder is destroyed, the spirit is freed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_YoureAllAlone()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YoureAllAlone($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_EnemiesMustDie()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_EnemiesMustDie($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_StrikeAsOne()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StrikeAsOne($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Godspeed()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Godspeed($a_f_AggroRange)
	; Description
	; Shout. For 5...17...20 seconds, all allies within earshot move 25% faster while under the effects of an enchantment.
	; Concise description
	; Shout. (5...17...20 seconds.) Allies in earshot move 25% faster while enchanted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_GoForTheEyes()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_GoForTheEyes($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_BraceYourself()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_BraceYourself($a_f_AggroRange)
	; Description
	; Shout. For 5...13...15 seconds, the next time target other ally would be knocked down, all nearby foes take 15...63...75 damage instead.
	; Concise description
	; Shout. (5...13...15 seconds.) Prevents the next knock-down and deals 15...63...75 damage to all foes near target ally. Cannot self-target.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_StandYourGround()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandYourGround($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_LeadTheWay()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_LeadTheWay($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_MakeHaste()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MakeHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_WeShallReturn()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_WeShallReturn($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_NeverGiveUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverGiveUp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_HelpMe()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_HelpMe($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FallBack()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FallBack($a_f_AggroRange)
	; Description
	; Shout. For 4...9...10 seconds, all allies within earshot gain 5...13...15 Health per second while moving and move 33% faster. "Fall Back!" ends on an ally affected by this shout when that ally successfully hits with an attack.
	; Concise description
	; Shout. (4...9...10 seconds.) Allies in earshot gain 5...13...15 Health per second while moving and move 33% faster. Ends for an ally if that ally hits with an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Incoming()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Incoming($a_f_AggroRange)
	; Description
	; Elite Shout. For 4...9...10 seconds, all allies within earshot move 33% faster, and gain 5...13...15 Health while moving.
	; Concise description
	; Elite Shout. (4...9...10 seconds) Allies in earshot move 33% faster and gain 5...13...15 Health while moving.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TheyreOnFire()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_THEYRE_ON_FIRE) Then Return False
	Return True
EndFunc

Func BestTarget_TheyreOnFire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_NeverSurrender()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverSurrender($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ItsJustAFleshWound()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ItsJustAFleshWound($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_RemoveQueenWail()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveQueenWail($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_QueenWail()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_QueenWail($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; Trivia">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_MakeYourTime()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MakeYourTime($a_f_AggroRange)
	; Description
	; Shout. You gain 1 strike of adrenaline for each party member within earshot (maximum 1...4...5 adrenaline).
	; Concise description
	; Shout. You gain one adrenaline (maximum 1...4...5) for each party member in earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CantTouchThis()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CantTouchThis($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FindTheirWeakness()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeakness($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ThePowerIsYours()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ThePowerIsYours($a_f_AggroRange)
	; Description
	; Elite Shout. For 3 seconds, all allies within earshot gain 0...1...1 Energy regeneration.
	; Concise description
	; Elite Shout. (3 seconds.) Allies within earshot gain 0...1...1 Energy regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ForgeTheWay()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForgeTheWay($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SteadyAim()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SteadyAim($a_f_AggroRange)
	; Description
	; Shout. For 10 seconds, the next time each ally within earshot throws a snowball, that snowball moves 100% faster.
	; Concise description
	; Shout. (10 seconds.) The next time each ally in earshot throws a snowball, that snowball moves 100% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SaveYourselvesLuxon()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SaveYourselvesLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SaveYourselvesKurzick()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SaveYourselvesKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_IMeantToDoThat()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IMeantToDoThat($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TheresNothingToFear()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNothingToFear($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SpiritRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritRoar($a_f_AggroRange)
	; Description
	; Shout. This shout deals 50 holy damage to nearby foes, and 25 more holy damage to affected foes that have an enchantment on them.
	; Concise description
	; Shout. Deals 50 holy damage to nearby foes, and 25 more holy damage for each enchantment on them.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_VolfenBloodlustCurseOfTheNornbear()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenBloodlustCurseOfTheNornbear($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_RavenShriekAGateTooFar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RavenShriekAGateTooFar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Tremor()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Tremor($a_f_AggroRange)
	; Description
	; Shout. All foes within earshot are knocked down for 4 seconds.
	; Concise description
	; Shout. Causes knock-down (4 seconds) to foes in earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ThunderingRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ThunderingRoar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_DontTrip()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DontTrip($a_f_AggroRange)
	; Description
	; Shout. For 3...5 seconds, party members within earshot cannot be knocked down.
	; Concise description
	; Shout. (3...5 seconds.) Prevents knock-down; affects party members within earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ByUralsHammer()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_ByUralsHammer($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_KraksCharge()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_KraksCharge($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_StandUp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandUp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FinishHim()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FinishHim($a_f_AggroRange)
	; Description
	; "FH" redirects here. For the outpost, see Fishermen's Haven.
	; Concise description
	; green; font-weight: bold;">44...80
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_DodgeThis()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DodgeThis($a_f_AggroRange)
	; Description
	; Shout. For 16...20 seconds, your next attack cannot be blocked and does +14...20 damage.
	; Concise description
	; Shout. (16...20 seconds.) Your next attack is unblockable and deals +14...20 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_IAmTheStrongest()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IAmTheStrongest($a_f_AggroRange)
	; Description
	; Shout. Your next 5...8 attacks do an additional +14...20 damage.
	; Concise description
	; Shout. Your next 5...8 attacks deal +14...20 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_IAmUnstoppable()
	If Anti_Shout() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_IsCrippled) Or UAI_GetPlayerInfo($GC_UAI_AGENT_IsKnockedDown) Then Return True
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) >= 0.95 Then Return False
	Return True
EndFunc

Func BestTarget_IAmUnstoppable($a_f_AggroRange)
	; Description
	; Shout. For 16...20 seconds, you have +24 armor and cannot be knocked down or Crippled.
	; Concise description
	; Shout. (16...20 seconds.) You have +24 armor and cannot be knocked-down or Crippled.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_YouMoveLikeADwarf()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouMoveLikeADwarf($a_f_AggroRange)
	; Description
	; Shout. Target foe is knocked down and takes 44...80 damage. That foe is also Crippled for 8...15 seconds.
	; Concise description
	; Shout. Deals 44...80 damage, causes knock-down, and inflicts Crippled condition (8...15 seconds).

	; Priority 1: Monks (interrupt healers)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 2: Casters (interrupt spellcasters)
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Priority 3: Melee (War, Sin, Derv)
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMelee")
	If $l_i_Target <> 0 Then Return $l_i_Target

	; Fallback: Any enemy
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc

Func CanUse_YouAreAllWeaklings()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_YouAreAllWeaklings($a_f_AggroRange)
	; Description
	; Shout. Target foe and foes adjacent to target are Weakened for 8...12 seconds.
	; Concise description
	; Shout. Inflicts Weakness condition (8...12 seconds). Also affects adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_UrsanRoar()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_UrsanRoar($a_f_AggroRange)
	; Description
	; Shout. For 2...5 seconds, all enemies within earshot are Weakened and all allies deal +5...15 damage per attack.
	; Concise description
	; Shout. (2...5 seconds) Inflicts Weakness condition to foes in earshot. Allies in earshot deal +5...15 damage per attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_VolfenBloodlust()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenBloodlust($a_f_AggroRange)
	; Description
	; Shout. For 2...7 seconds, you and all nearby allies attack 33% faster.
	; Concise description
	; Shout. (2...7 seconds.) You and nearby allies attack 33% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_RavenShriek()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_RavenShriek($a_f_AggroRange)
	; Description
	; Shout. Remove Blindness from all allies within earshot. Cause Blindness to nearby foes for 4...10 seconds.
	; Concise description
	; Shout. Removes Blindness from allies in earshot. Inflicts Blindness condition (4...10 seconds) to nearby enemies.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_UrsanRoarBloodWashesBlood()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_UrsanRoarBloodWashesBlood($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_DestroyTheHumans()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_DestroyTheHumans($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TengusMimicry()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TengusMimicry($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CallOfHastePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CallOfHastePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FormUpAndAdvance()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FormUpAndAdvance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_Advance()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_Advance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ForElona()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForElona($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CryOfMadness()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CryOfMadness($a_f_AggroRange)
	; Description
	; Elite Shout. Scream like a madman! Foes in the area lose 10 Energy and all adrenaline. For 10 seconds, allies within earshot move 25% faster and have +5 Health regeneration and +1 Energy regeneration.
	; Concise description
	; Elite Shout. Foes in the area lose 10 Energy and all adrenaline. Allies within earshot move 25% faster and have +5 Health regeneration and +1 Energy regeneration. (10 seconds.)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_MotivatingInsults()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MotivatingInsults($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ItsGoodToBeKing()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ItsGoodToBeKing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_MaddeningLaughter()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_MaddeningLaughter($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_WatchYourselfPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_WatchYourselfPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_IncomingPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IncomingPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_NeverSurrenderPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverSurrenderPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ForGreatJusticePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_ForGreatJusticePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_GoForTheEyesPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_GoForTheEyesPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_BraceYourselfPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_BraceYourselfPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CantTouchThisPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_CantTouchThisPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_StandYourGroundPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StandYourGroundPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_WeShallReturnPvp()
	If Anti_Shout() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_WeShallReturnPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FindTheirWeaknessPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeaknessPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_NeverGiveUpPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_NeverGiveUpPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_HelpMePvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_HelpMePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FallBackPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FallBackPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_PredatoryBondPvp()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_PredatoryBondPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_StickyGround()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_StickyGround($a_f_AggroRange)
	; Description
	; Agent of the Mad King skill
	; Concise description
	; //en.wikipedia.org/wiki/Sic" class="extiw" title="w:Sic">
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SugarShock()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_SugarShock($a_f_AggroRange)
	; Description
	; Shout. Knocks down target foe for 10 seconds.
	; Concise description
	; Shout. Causes knock-down (10 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TheMadKingsInfluence()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheMadKingsInfluence($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TheresNotEnoughTime()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNotEnoughTime($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_FindTheirWeaknessThackeray()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_FindTheirWeaknessThackeray($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TheresNothingToFearThackeray()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TheresNothingToFearThackeray($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TangoDown()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TangoDown($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_IllBeBack()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_IllBeBack($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_TogetherAsOne()
	If Anti_Shout() Then Return False
	Return True
EndFunc

Func BestTarget_TogetherAsOne($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
