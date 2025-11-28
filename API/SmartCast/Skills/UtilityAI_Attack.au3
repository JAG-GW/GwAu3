#include-once

Func Anti_Attack()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BLIND) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spirit_Shackles) Then Return True

	Local $l_i_CommingDamage = 0

	; Check for hexes that punish attacking
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Ineptitude) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Ineptitude, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Clumsiness) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Clumsiness, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Wandering_Eye) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Wandering_Eye, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Wandering_Eye_PvP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Wandering_Eye_PvP, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spiteful_Spirit) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Spiteful_Spirit, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spoil_Victor) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Spoil_Victor, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Empathy) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Empathy, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Empathy_PvP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Empathy_PvP, "Scale")

	If $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50) Then Return True

	Return False
EndFunc

; Skill ID: 320 - $GC_I_SKILL_ID_HAMSTRING
Func CanUse_Hamstring()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Hamstring($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 321 - $GC_I_SKILL_ID_WILD_BLOW
Func CanUse_WildBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 322 - $GC_I_SKILL_ID_POWER_ATTACK
Func CanUse_PowerAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PowerAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 323 - $GC_I_SKILL_ID_DESPERATION_BLOW
Func CanUse_DesperationBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DesperationBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 324 - $GC_I_SKILL_ID_THRILL_OF_VICTORY
Func CanUse_ThrillOfVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ThrillOfVictory($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 325 - $GC_I_SKILL_ID_DISTRACTING_BLOW
Func CanUse_DistractingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DistractingBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 326 - $GC_I_SKILL_ID_PROTECTORS_STRIKE
Func CanUse_ProtectorsStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ProtectorsStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 327 - $GC_I_SKILL_ID_GRIFFONS_SWEEP
Func CanUse_GriffonsSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GriffonsSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 328 - $GC_I_SKILL_ID_PURE_STRIKE
Func CanUse_PureStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PureStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 329 - $GC_I_SKILL_ID_SKULL_CRACK
Func CanUse_SkullCrack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SkullCrack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 330 - $GC_I_SKILL_ID_CYCLONE_AXE
Func CanUse_CycloneAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CycloneAxe($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 331 - $GC_I_SKILL_ID_HAMMER_BASH
Func CanUse_HammerBash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HammerBash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 332 - $GC_I_SKILL_ID_BULLS_STRIKE
Func CanUse_BullsStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BullsStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 334 - $GC_I_SKILL_ID_AXE_RAKE
Func CanUse_AxeRake()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AxeRake($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 335 - $GC_I_SKILL_ID_CLEAVE
Func CanUse_Cleave()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Cleave($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 336 - $GC_I_SKILL_ID_EXECUTIONERS_STRIKE
Func CanUse_ExecutionersStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ExecutionersStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 337 - $GC_I_SKILL_ID_DISMEMBER
Func CanUse_Dismember()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Dismember($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 338 - $GC_I_SKILL_ID_EVISCERATE
Func CanUse_Eviscerate()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Eviscerate($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 339 - $GC_I_SKILL_ID_PENETRATING_BLOW
Func CanUse_PenetratingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 340 - $GC_I_SKILL_ID_DISRUPTING_CHOP
Func CanUse_DisruptingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 341 - $GC_I_SKILL_ID_SWIFT_CHOP
Func CanUse_SwiftChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SwiftChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 342 - $GC_I_SKILL_ID_AXE_TWIST
Func CanUse_AxeTwist()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AxeTwist($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 350 - $GC_I_SKILL_ID_BELLY_SMASH
Func CanUse_BellySmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BellySmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 351 - $GC_I_SKILL_ID_MIGHTY_BLOW
Func CanUse_MightyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MightyBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 352 - $GC_I_SKILL_ID_CRUSHING_BLOW
Func CanUse_CrushingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CrushingBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 353 - $GC_I_SKILL_ID_CRUDE_SWING
Func CanUse_CrudeSwing()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CrudeSwing($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 354 - $GC_I_SKILL_ID_EARTH_SHAKER
Func CanUse_EarthShaker()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EarthShaker($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 355 - $GC_I_SKILL_ID_DEVASTATING_HAMMER
Func CanUse_DevastatingHammer()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DevastatingHammer($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 356 - $GC_I_SKILL_ID_IRRESISTIBLE_BLOW
Func CanUse_IrresistibleBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_IrresistibleBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 357 - $GC_I_SKILL_ID_COUNTER_BLOW
Func CanUse_CounterBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CounterBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 358 - $GC_I_SKILL_ID_BACKBREAKER
Func CanUse_Backbreaker()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Backbreaker($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 359 - $GC_I_SKILL_ID_HEAVY_BLOW
Func CanUse_HeavyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HeavyBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 360 - $GC_I_SKILL_ID_STAGGERING_BLOW
Func CanUse_StaggeringBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StaggeringBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 382 - $GC_I_SKILL_ID_SEVER_ARTERY
Func CanUse_SeverArtery()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SeverArtery($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 383 - $GC_I_SKILL_ID_GALRATH_SLASH
Func CanUse_GalrathSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GalrathSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 384 - $GC_I_SKILL_ID_GASH
Func CanUse_Gash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Gash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 385 - $GC_I_SKILL_ID_FINAL_THRUST
Func CanUse_FinalThrust()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FinalThrust($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 386 - $GC_I_SKILL_ID_SEEKING_BLADE
Func CanUse_SeekingBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SeekingBlade($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 390 - $GC_I_SKILL_ID_SAVAGE_SLASH
Func CanUse_SavageSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SavageSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 391 - $GC_I_SKILL_ID_HUNTERS_SHOT
Func CanUse_HuntersShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HuntersShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 392 - $GC_I_SKILL_ID_PIN_DOWN
Func CanUse_PinDown()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PinDown($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 393 - $GC_I_SKILL_ID_CRIPPLING_SHOT
Func CanUse_CripplingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 394 - $GC_I_SKILL_ID_POWER_SHOT
Func CanUse_PowerShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PowerShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 395 - $GC_I_SKILL_ID_BARRAGE
Func CanUse_Barrage()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Barrage($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 396 - $GC_I_SKILL_ID_DUAL_SHOT
Func CanUse_DualShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DualShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 397 - $GC_I_SKILL_ID_QUICK_SHOT
Func CanUse_QuickShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_QuickShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 398 - $GC_I_SKILL_ID_PENETRATING_ATTACK
Func CanUse_PenetratingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 399 - $GC_I_SKILL_ID_DISTRACTING_SHOT
Func CanUse_DistractingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DistractingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 400 - $GC_I_SKILL_ID_PRECISION_SHOT
Func CanUse_PrecisionShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PrecisionShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 401 - $GC_I_SKILL_ID_SPLINTER_SHOT_MONSTER_SKILL
; Skill ID: 402 - $GC_I_SKILL_ID_DETERMINED_SHOT
Func CanUse_DeterminedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeterminedShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 403 - $GC_I_SKILL_ID_CALLED_SHOT
Func CanUse_CalledShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CalledShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 404 - $GC_I_SKILL_ID_POISON_ARROW
Func CanUse_PoisonArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonArrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 405 - $GC_I_SKILL_ID_OATH_SHOT
Func CanUse_OathShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_OathShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 406 - $GC_I_SKILL_ID_DEBILITATING_SHOT
Func CanUse_DebilitatingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DebilitatingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 407 - $GC_I_SKILL_ID_POINT_BLANK_SHOT
Func CanUse_PointBlankShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PointBlankShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 408 - $GC_I_SKILL_ID_CONCUSSION_SHOT
Func CanUse_ConcussionShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ConcussionShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 409 - $GC_I_SKILL_ID_PUNISHING_SHOT
Func CanUse_PunishingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PunishingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 426 - $GC_I_SKILL_ID_SAVAGE_SHOT
Func CanUse_SavageShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SavageShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 428 - $GC_I_SKILL_ID_INCENDIARY_ARROWS
Func CanUse_IncendiaryArrows()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_IncendiaryArrows($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 501 - $GC_I_SKILL_ID_SIEGE_ATTACK4
Func CanUse_SiegeAttack4()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack4($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 511 - $GC_I_SKILL_ID_BRUTAL_MAULING
Func CanUse_BrutalMauling()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrutalMauling($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 512 - $GC_I_SKILL_ID_CRIPPLING_ATTACK
Func CanUse_CripplingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 524 - $GC_I_SKILL_ID_DOZEN_SHOT
Func CanUse_DozenShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DozenShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 530 - $GC_I_SKILL_ID_GIANT_STOMP
Func CanUse_GiantStomp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GiantStomp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 531 - $GC_I_SKILL_ID_AGNARS_RAGE
Func CanUse_AgnarsRage()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AgnarsRage($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 539 - $GC_I_SKILL_ID_HUNGER_OF_THE_LICH
Func CanUse_HungerOfTheLich()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HungerOfTheLich($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 577 - $GC_I_SKILL_ID_SIEGE_ATTACK1
Func CanUse_SiegeAttack1()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack1($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 578 - $GC_I_SKILL_ID_SIEGE_ATTACK2
Func CanUse_SiegeAttack2()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack2($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 775 - $GC_I_SKILL_ID_DEATH_BLOSSOM
Func CanUse_DeathBlossom()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeathBlossom($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 776 - $GC_I_SKILL_ID_TWISTING_FANGS
Func CanUse_TwistingFangs()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TwistingFangs($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 777 - $GC_I_SKILL_ID_HORNS_OF_THE_OX
Func CanUse_HornsOfTheOx()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HornsOfTheOx($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 778 - $GC_I_SKILL_ID_FALLING_SPIDER
Func CanUse_FallingSpider()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FallingSpider($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 779 - $GC_I_SKILL_ID_BLACK_LOTUS_STRIKE
Func CanUse_BlackLotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlackLotusStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 780 - $GC_I_SKILL_ID_FOX_FANGS
Func CanUse_FoxFangs()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FoxFangs($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 781 - $GC_I_SKILL_ID_MOEBIUS_STRIKE
Func CanUse_MoebiusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MoebiusStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 782 - $GC_I_SKILL_ID_JAGGED_STRIKE
Func CanUse_JaggedStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_JaggedStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 783 - $GC_I_SKILL_ID_UNSUSPECTING_STRIKE
Func CanUse_UnsuspectingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_UnsuspectingStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 849 - $GC_I_SKILL_ID_LACERATING_CHOP
Func CanUse_LaceratingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LaceratingChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 850 - $GC_I_SKILL_ID_FIERCE_BLOW
Func CanUse_FierceBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FierceBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 851 - $GC_I_SKILL_ID_SUN_AND_MOON_SLASH
Func CanUse_SunAndMoonSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SunAndMoonSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 852 - $GC_I_SKILL_ID_SPLINTER_SHOT
Func CanUse_SplinterShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SplinterShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 853 - $GC_I_SKILL_ID_MELANDRUS_SHOT
Func CanUse_MelandrusShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MelandrusShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 872 - $GC_I_SKILL_ID_SHADOWSONG_ATTACK
Func CanUse_ShadowsongAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowsongAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 874 - $GC_I_SKILL_ID_CONSUMING_FLAMES
Func CanUse_ConsumingFlames()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ConsumingFlames($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 888 - $GC_I_SKILL_ID_WHIRLING_AXE
Func CanUse_WhirlingAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WhirlingAxe($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 889 - $GC_I_SKILL_ID_FORCEFUL_BLOW
Func CanUse_ForcefulBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ForcefulBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 892 - $GC_I_SKILL_ID_QUIVERING_BLADE
Func CanUse_QuiveringBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_QuiveringBlade($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 904 - $GC_I_SKILL_ID_FURIOUS_AXE
Func CanUse_FuriousAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FuriousAxe($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 905 - $GC_I_SKILL_ID_AUSPICIOUS_BLOW
Func CanUse_AuspiciousBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AuspiciousBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 907 - $GC_I_SKILL_ID_DRAGON_SLASH
Func CanUse_DragonSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DragonSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 908 - $GC_I_SKILL_ID_MARAUDERS_SHOT
Func CanUse_MaraudersShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MaraudersShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 909 - $GC_I_SKILL_ID_FOCUSED_SHOT
Func CanUse_FocusedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FocusedShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 922 - $GC_I_SKILL_ID_DISSONANCE_ATTACK
Func CanUse_DissonanceAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DissonanceAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 924 - $GC_I_SKILL_ID_DISENCHANTMENT_ATTACK
Func CanUse_DisenchantmentAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisenchantmentAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 948 - $GC_I_SKILL_ID_DESPERATE_STRIKE
Func CanUse_DesperateStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DesperateStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 975 - $GC_I_SKILL_ID_EXHAUSTING_ASSAULT
Func CanUse_ExhaustingAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ExhaustingAssault($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 976 - $GC_I_SKILL_ID_REPEATING_STRIKE
Func CanUse_RepeatingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RepeatingStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 986 - $GC_I_SKILL_ID_NINE_TAIL_STRIKE
Func CanUse_NineTailStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_NineTailStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 988 - $GC_I_SKILL_ID_TEMPLE_STRIKE
Func CanUse_TempleStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TempleStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 989 - $GC_I_SKILL_ID_GOLDEN_PHOENIX_STRIKE
Func CanUse_GoldenPhoenixStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenPhoenixStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 992 - $GC_I_SKILL_ID_TRIPLE_CHOP
Func CanUse_TripleChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TripleChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 993 - $GC_I_SKILL_ID_ENRAGED_SMASH
Func CanUse_EnragedSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EnragedSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 994 - $GC_I_SKILL_ID_RENEWING_SMASH
Func CanUse_RenewingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RenewingSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 996 - $GC_I_SKILL_ID_STANDING_SLASH
Func CanUse_StandingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StandingSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1019 - $GC_I_SKILL_ID_CRITICAL_STRIKE
Func CanUse_CriticalStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CriticalStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1020 - $GC_I_SKILL_ID_BLADES_OF_STEEL
Func CanUse_BladesOfSteel()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BladesOfSteel($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1021 - $GC_I_SKILL_ID_JUNGLE_STRIKE
Func CanUse_JungleStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_JungleStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1022 - $GC_I_SKILL_ID_WILD_STRIKE
Func CanUse_WildStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1023 - $GC_I_SKILL_ID_LEAPING_MANTIS_STING
Func CanUse_LeapingMantisSting()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LeapingMantisSting($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1024 - $GC_I_SKILL_ID_BLACK_MANTIS_THRUST
Func CanUse_BlackMantisThrust()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlackMantisThrust($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1025 - $GC_I_SKILL_ID_DISRUPTING_STAB
Func CanUse_DisruptingStab()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingStab($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1026 - $GC_I_SKILL_ID_GOLDEN_LOTUS_STRIKE
Func CanUse_GoldenLotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenLotusStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1133 - $GC_I_SKILL_ID_DRUNKEN_BLOW
Func CanUse_DrunkenBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DrunkenBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1134 - $GC_I_SKILL_ID_LEVIATHANS_SWEEP
Func CanUse_LeviathansSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LeviathansSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1135 - $GC_I_SKILL_ID_JAIZHENJU_STRIKE
Func CanUse_JaizhenjuStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_JaizhenjuStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1136 - $GC_I_SKILL_ID_PENETRATING_CHOP
Func CanUse_PenetratingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1137 - $GC_I_SKILL_ID_YETI_SMASH
Func CanUse_YetiSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_YetiSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1144 - $GC_I_SKILL_ID_SILVERWING_SLASH
Func CanUse_SilverwingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SilverwingSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1179 - $GC_I_SKILL_ID_DARK_CHAIN_LIGHTNING
Func CanUse_DarkChainLightning()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DarkChainLightning($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1191 - $GC_I_SKILL_ID_SUNDERING_ATTACK
Func CanUse_SunderingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SunderingAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1192 - $GC_I_SKILL_ID_ZOJUNS_SHOT
Func CanUse_ZojunsShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ZojunsShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1197 - $GC_I_SKILL_ID_NEEDLING_SHOT
Func CanUse_NeedlingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_NeedlingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1198 - $GC_I_SKILL_ID_BROAD_HEAD_ARROW
Func CanUse_BroadHeadArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BroadHeadArrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1248 - $GC_I_SKILL_ID_PAIN_ATTACK
Func CanUse_PainAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PainAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1254 - $GC_I_SKILL_ID_BLOODSONG_ATTACK
Func CanUse_BloodsongAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BloodsongAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1256 - $GC_I_SKILL_ID_WANDERLUST_ATTACK
Func CanUse_WanderlustAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WanderlustAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1309 - $GC_I_SKILL_ID_SUICIDE_ENERGY
Func CanUse_SuicideEnergy()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SuicideEnergy($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1310 - $GC_I_SKILL_ID_SUICIDE_HEALTH
Func CanUse_SuicideHealth()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SuicideHealth($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1319 - ;  $GC_I_SKILL_ID_FINAL_THRUST
; Skill ID: 1385 - $GC_I_SKILL_ID_SIEGE_ATTACK3
Func CanUse_SiegeAttack3()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack3($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1402 - $GC_I_SKILL_ID_CRITICAL_CHOP
Func CanUse_CriticalChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CriticalChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1403 - $GC_I_SKILL_ID_AGONIZING_CHOP
Func CanUse_AgonizingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AgonizingChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1409 - $GC_I_SKILL_ID_MOKELE_SMASH
Func CanUse_MokeleSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MokeleSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1410 - $GC_I_SKILL_ID_OVERBEARING_SMASH
Func CanUse_OverbearingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_OverbearingSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1415 - $GC_I_SKILL_ID_CRIPPLING_SLASH
Func CanUse_CripplingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1416 - $GC_I_SKILL_ID_BARBAROUS_SLICE
Func CanUse_BarbarousSlice()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BarbarousSlice($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1419 - $GC_I_SKILL_ID_FEEDING_FRENZY_SKILL
Func CanUse_FeedingFrenzySkill()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FeedingFrenzySkill($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1420 - $GC_I_SKILL_ID_QUAKE_OF_AHDASHIM
Func CanUse_QuakeOfAhdashim()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_QuakeOfAhdashim($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1451 - $GC_I_SKILL_ID_HUNGERS_BITE
Func CanUse_HungersBite()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HungersBite($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1461 - $GC_I_SKILL_ID_EARTH_VORTEX
Func CanUse_EarthVortex()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EarthVortex($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1462 - $GC_I_SKILL_ID_FROST_VORTEX
Func CanUse_FrostVortex()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FrostVortex($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1465 - $GC_I_SKILL_ID_PREPARED_SHOT
Func CanUse_PreparedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PreparedShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1466 - $GC_I_SKILL_ID_BURNING_ARROW
Func CanUse_BurningArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BurningArrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1467 - $GC_I_SKILL_ID_ARCING_SHOT
Func CanUse_ArcingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ArcingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1469 - $GC_I_SKILL_ID_CROSSFIRE
Func CanUse_Crossfire()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Crossfire($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1483 - $GC_I_SKILL_ID_BANISHING_STRIKE
Func CanUse_BanishingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BanishingStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1484 - $GC_I_SKILL_ID_MYSTIC_SWEEP
Func CanUse_MysticSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MysticSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1485 - $GC_I_SKILL_ID_EREMITES_ATTACK
Func CanUse_EremitesAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EremitesAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1486 - $GC_I_SKILL_ID_REAP_IMPURITIES
Func CanUse_ReapImpurities()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ReapImpurities($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1487 - $GC_I_SKILL_ID_TWIN_MOON_SWEEP
Func CanUse_TwinMoonSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TwinMoonSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1488 - $GC_I_SKILL_ID_VICTORIOUS_SWEEP
Func CanUse_VictoriousSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_VictoriousSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1489 - $GC_I_SKILL_ID_IRRESISTIBLE_SWEEP
Func CanUse_IrresistibleSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_IrresistibleSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1490 - $GC_I_SKILL_ID_PIOUS_ASSAULT
Func CanUse_PiousAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PiousAssault($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1535 - $GC_I_SKILL_ID_CRIPPLING_SWEEP
Func CanUse_CripplingSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1536 - $GC_I_SKILL_ID_WOUNDING_STRIKE
Func CanUse_WoundingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WoundingStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1537 - $GC_I_SKILL_ID_WEARYING_STRIKE
Func CanUse_WearyingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WearyingStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1538 - $GC_I_SKILL_ID_LYSSAS_ASSAULT
Func CanUse_LyssasAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LyssasAssault($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1539 - $GC_I_SKILL_ID_CHILLING_VICTORY
Func CanUse_ChillingVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ChillingVictory($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1546 - $GC_I_SKILL_ID_BLAZING_SPEAR
Func CanUse_BlazingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlazingSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1547 - $GC_I_SKILL_ID_MIGHTY_THROW
Func CanUse_MightyThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MightyThrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1548 - $GC_I_SKILL_ID_CRUEL_SPEAR
Func CanUse_CruelSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CruelSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1549 - $GC_I_SKILL_ID_HARRIERS_TOSS
Func CanUse_HarriersToss()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HarriersToss($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1550 - $GC_I_SKILL_ID_UNBLOCKABLE_THROW
Func CanUse_UnblockableThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_UnblockableThrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1551 - $GC_I_SKILL_ID_SPEAR_OF_LIGHTNING
Func CanUse_SpearOfLightning()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfLightning($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1552 - $GC_I_SKILL_ID_WEARYING_SPEAR
Func CanUse_WearyingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WearyingSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1600 - $GC_I_SKILL_ID_BARBED_SPEAR
Func CanUse_BarbedSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1601 - $GC_I_SKILL_ID_VICIOUS_ATTACK
Func CanUse_ViciousAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ViciousAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1602 - $GC_I_SKILL_ID_STUNNING_STRIKE
Func CanUse_StunningStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StunningStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1603 - $GC_I_SKILL_ID_MERCILESS_SPEAR
Func CanUse_MercilessSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MercilessSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1604 - $GC_I_SKILL_ID_DISRUPTING_THROW
Func CanUse_DisruptingThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingThrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1605 - $GC_I_SKILL_ID_WILD_THROW
Func CanUse_WildThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildThrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1633 - $GC_I_SKILL_ID_MALICIOUS_STRIKE
Func CanUse_MaliciousStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MaliciousStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1634 - $GC_I_SKILL_ID_SHATTERING_ASSAULT
Func CanUse_ShatteringAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ShatteringAssault($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1635 - $GC_I_SKILL_ID_GOLDEN_SKULL_STRIKE
Func CanUse_GoldenSkullStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenSkullStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1636 - $GC_I_SKILL_ID_BLACK_SPIDER_STRIKE
Func CanUse_BlackSpiderStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlackSpiderStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1637 - $GC_I_SKILL_ID_GOLDEN_FOX_STRIKE
Func CanUse_GoldenFoxStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenFoxStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1670 - $GC_I_SKILL_ID_SIEGE_ATTACK_BOMBARDMENT
Func CanUse_SiegeAttackBombardment()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttackBombardment($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1693 - $GC_I_SKILL_ID_COUNTERATTACK
Func CanUse_Counterattack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Counterattack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1694 - $GC_I_SKILL_ID_MAGEHUNTER_STRIKE
Func CanUse_MagehunterStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MagehunterStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1695 - $GC_I_SKILL_ID_SOLDIERS_STRIKE
Func CanUse_SoldiersStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SoldiersStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1696 - $GC_I_SKILL_ID_DECAPITATE
Func CanUse_Decapitate()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Decapitate($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1697 - $GC_I_SKILL_ID_MAGEHUNTERS_SMASH
Func CanUse_MagehuntersSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MagehuntersSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1702 - $GC_I_SKILL_ID_STEELFANG_SLASH
Func CanUse_SteelfangSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SteelfangSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1705 - $GC_I_SKILL_ID_EARTH_SHATTERING_BLOW
Func CanUse_EarthShatteringBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EarthShatteringBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1719 - $GC_I_SKILL_ID_SCREAMING_SHOT
Func CanUse_ScreamingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ScreamingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1720 - $GC_I_SKILL_ID_KEEN_ARROW
Func CanUse_KeenArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeenArrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1722 - $GC_I_SKILL_ID_FORKED_ARROW
Func CanUse_ForkedArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ForkedArrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1726 - $GC_I_SKILL_ID_MAGEBANE_SHOT
Func CanUse_MagebaneShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MagebaneShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1735 - $GC_I_SKILL_ID_GAZE_OF_FURY_ATTACK
Func CanUse_GazeOfFuryAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GazeOfFuryAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1746 - $GC_I_SKILL_ID_ANGUISH_ATTACK
Func CanUse_AnguishAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AnguishAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1753 - $GC_I_SKILL_ID_RENDING_SWEEP
Func CanUse_RendingSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RendingSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1767 - $GC_I_SKILL_ID_REAPERS_SWEEP
Func CanUse_ReapersSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ReapersSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1783 - $GC_I_SKILL_ID_SLAYERS_SPEAR
Func CanUse_SlayersSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SlayersSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1784 - $GC_I_SKILL_ID_SWIFT_JAVELIN
Func CanUse_SwiftJavelin()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SwiftJavelin($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1895 - $GC_I_SKILL_ID_WILD_SMASH
Func CanUse_WildSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1897 - $GC_I_SKILL_ID_JADOTHS_STORM_OF_JUDGMENT
Func CanUse_JadothsStormOfJudgment()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_JadothsStormOfJudgment($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1935 - $GC_I_SKILL_ID_TORTUROUS_EMBERS
Func CanUse_TorturousEmbers()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TorturousEmbers($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1953 - $GC_I_SKILL_ID_TRIPLE_SHOT_LUXON
Func CanUse_TripleShotLuxon()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TripleShotLuxon($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1957 - $GC_I_SKILL_ID_SPEAR_OF_FURY_LUXON
Func CanUse_SpearOfFuryLuxon()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfFuryLuxon($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1986 - $GC_I_SKILL_ID_VAMPIRIC_ASSAULT
Func CanUse_VampiricAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_VampiricAssault($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1987 - $GC_I_SKILL_ID_LOTUS_STRIKE
Func CanUse_LotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LotusStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1988 - $GC_I_SKILL_ID_GOLDEN_FANG_STRIKE
Func CanUse_GoldenFangStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenFangStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1990 - $GC_I_SKILL_ID_FALLING_LOTUS_STRIKE
Func CanUse_FallingLotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FallingLotusStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2008 - $GC_I_SKILL_ID_PULVERIZING_SMASH
Func CanUse_PulverizingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PulverizingSmash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2009 - $GC_I_SKILL_ID_KEEN_CHOP
Func CanUse_KeenChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeenChop($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2010 - $GC_I_SKILL_ID_KNEE_CUTTER
Func CanUse_KneeCutter()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KneeCutter($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2012 - $GC_I_SKILL_ID_RADIANT_SCYTHE
Func CanUse_RadiantScythe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RadiantScythe($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2015 - $GC_I_SKILL_ID_FARMERS_SCYTHE
Func CanUse_FarmersScythe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FarmersScythe($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2066 - $GC_I_SKILL_ID_DISARM
Func CanUse_Disarm()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Disarm($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2069 - $GC_I_SKILL_ID_SLOTH_HUNTERS_SHOT
Func CanUse_SlothHuntersShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SlothHuntersShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2070 - $GC_I_SKILL_ID_AURA_SLICER
Func CanUse_AuraSlicer()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AuraSlicer($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2071 - $GC_I_SKILL_ID_ZEALOUS_SWEEP
Func CanUse_ZealousSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ZealousSweep($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2074 - $GC_I_SKILL_ID_CHEST_THUMPER
Func CanUse_ChestThumper()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ChestThumper($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2096 - $GC_I_SKILL_ID_TRIPLE_SHOT_KURZICK
Func CanUse_TripleShotKurzick()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TripleShotKurzick($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2099 - $GC_I_SKILL_ID_SPEAR_OF_FURY_KURZICK
Func CanUse_SpearOfFuryKurzick()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfFuryKurzick($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2107 - $GC_I_SKILL_ID_WHIRLWIND_ATTACK
Func CanUse_WhirlwindAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WhirlwindAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2111 - $GC_I_SKILL_ID_VAMPIRISM_ATTACK
Func CanUse_VampirismAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_VampirismAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2116 - $GC_I_SKILL_ID_SNEAK_ATTACK
Func CanUse_SneakAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SneakAttack($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2124 - $GC_I_SKILL_ID_SHATTERED_SPIRIT
Func CanUse_ShatteredSpirit()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ShatteredSpirit($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2127 - $GC_I_SKILL_ID_UNSEEN_AGGRESSION
Func CanUse_UnseenAggression()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_UnseenAggression($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2135 - $GC_I_SKILL_ID_TRAMPLING_OX
Func CanUse_TramplingOx()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TramplingOx($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2143 - $GC_I_SKILL_ID_DISRUPTING_SHOT
Func CanUse_DisruptingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2144 - $GC_I_SKILL_ID_VOLLEY
Func CanUse_Volley()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Volley($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2147 - $GC_I_SKILL_ID_CRIPPLING_VICTORY
Func CanUse_CripplingVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingVictory($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2150 - $GC_I_SKILL_ID_MAIMING_SPEAR
Func CanUse_MaimingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MaimingSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2157 - $GC_I_SKILL_ID_GOLEM_STRIKE
Func CanUse_GolemStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GolemStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2158 - $GC_I_SKILL_ID_BLOODSTONE_SLASH
Func CanUse_BloodstoneSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BloodstoneSlash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2182 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2183 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2184 - $GC_I_SKILL_ID_ROLLING_SHIFT
Func CanUse_RollingShift()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RollingShift($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2194 - $GC_I_SKILL_ID_DISTRACTING_STRIKE
Func CanUse_DistractingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DistractingStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2195 - $GC_I_SKILL_ID_SYMBOLIC_STRIKE
Func CanUse_SymbolicStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SymbolicStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2197 - $GC_I_SKILL_ID_BODY_BLOW
Func CanUse_BodyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BodyBlow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2198 - $GC_I_SKILL_ID_BODY_SHOT
Func CanUse_BodyShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BodyShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2209 - $GC_I_SKILL_ID_HOLY_SPEAR
Func CanUse_HolySpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HolySpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2210 - $GC_I_SKILL_ID_SPEAR_SWIPE
Func CanUse_SpearSwipe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearSwipe($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2228 - $GC_I_SKILL_ID_DEFT_STRIKE
Func CanUse_DeftStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeftStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2238 - $GC_I_SKILL_ID_SPEAR_OF_REDEMPTION
Func CanUse_SpearOfRedemption()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfRedemption($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2239 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2335 - $GC_I_SKILL_ID_BRAWLING_JAB1
Func CanUse_BrawlingJab1()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingJab1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2336 - $GC_I_SKILL_ID_BRAWLING_JAB2
Func CanUse_BrawlingJab2()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingJab2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2337 - $GC_I_SKILL_ID_BRAWLING_STRAIGHT_RIGHT
Func CanUse_BrawlingStraightRight()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingStraightRight($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2338 - $GC_I_SKILL_ID_BRAWLING_HOOK1
Func CanUse_BrawlingHook1()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingHook1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2339 - $GC_I_SKILL_ID_BRAWLING_HOOK2
Func CanUse_BrawlingHook2()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingHook2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2340 - $GC_I_SKILL_ID_BRAWLING_UPPERCUT
Func CanUse_BrawlingUppercut()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingUppercut($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2341 - $GC_I_SKILL_ID_BRAWLING_COMBO_PUNCH
Func CanUse_BrawlingComboPunch()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingComboPunch($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2342 - $GC_I_SKILL_ID_BRAWLING_HEADBUTT_BRAWLING_SKILL
Func CanUse_BrawlingHeadbuttBrawlingSkill()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingHeadbuttBrawlingSkill($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2361 - $GC_I_SKILL_ID_CLUB_OF_A_THOUSAND_BEARS
Func CanUse_ClubOfAThousandBears()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ClubOfAThousandBears($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2365 - $GC_I_SKILL_ID_THUNDERFIST_STRIKE
Func CanUse_ThunderfistStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ThunderfistStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2490 - $GC_I_SKILL_ID_PARASITIC_BITE
Func CanUse_ParasiticBite()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ParasiticBite($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2515 - $GC_I_SKILL_ID_THE_SNIPERS_SPEAR
Func CanUse_TheSnipersSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TheSnipersSpear($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2640 - ;  $GC_I_SKILL_ID_CRIPPLING_SLASH
; Skill ID: 2641 - ;  $GC_I_SKILL_ID_SUN_AND_MOON_SLASH
; Skill ID: 2644 - ;  $GC_I_SKILL_ID_BURNING_ARROW
; Skill ID: 2646 - ;  $GC_I_SKILL_ID_FALLING_LOTUS_STRIKE
; Skill ID: 2678 - $GC_I_SKILL_ID_WHIRLWIND_ATTACK_TURAI_OSSA
Func CanUse_WhirlwindAttackTuraiOssa()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WhirlwindAttackTuraiOssa($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2685 - $GC_I_SKILL_ID_DRAGON_SLASH_TURAI_OSSA
Func CanUse_DragonSlashTuraiOssa()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DragonSlashTuraiOssa($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2732 - $GC_I_SKILL_ID_FALKENS_FIRE_FIST
Func CanUse_FalkensFireFist()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FalkensFireFist($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2808 - $GC_I_SKILL_ID_ENRAGED_SMASH_PVP
Func CanUse_EnragedSmashPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EnragedSmashPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2861 - $GC_I_SKILL_ID_PENETRATING_ATTACK_PVP
Func CanUse_PenetratingAttackPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingAttackPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2864 - $GC_I_SKILL_ID_SUNDERING_ATTACK_PVP
Func CanUse_SunderingAttackPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SunderingAttackPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2873 - $GC_I_SKILL_ID_MYSTIC_SWEEP_PVP
Func CanUse_MysticSweepPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MysticSweepPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2874 - $GC_I_SKILL_ID_EREMITES_ATTACK_PVP
Func CanUse_EremitesAttackPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EremitesAttackPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2875 - $GC_I_SKILL_ID_HARRIERS_TOSS_PVP
Func CanUse_HarriersTossPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HarriersTossPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2888 - $GC_I_SKILL_ID_CHILLING_VICTORY_PVP
Func CanUse_ChillingVictoryPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ChillingVictoryPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2925 - $GC_I_SKILL_ID_SLOTH_HUNTERS_SHOT_PVP
Func CanUse_SlothHuntersShotPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SlothHuntersShotPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2929 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2932 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2933 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2951 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3055 - $GC_I_SKILL_ID_PAIN_ATTACK_TOGO1
Func CanUse_PainAttackTogo1()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PainAttackTogo1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3056 - $GC_I_SKILL_ID_PAIN_ATTACK_TOGO2
Func CanUse_PainAttackTogo2()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PainAttackTogo2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3057 - $GC_I_SKILL_ID_PAIN_ATTACK_TOGO3
Func CanUse_PainAttackTogo3()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PainAttackTogo3($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3061 - $GC_I_SKILL_ID_DEATH_BLOSSOM_PVP
Func CanUse_DeathBlossomPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeathBlossomPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3074 - $GC_I_SKILL_ID_BONE_SPIKE
Func CanUse_BoneSpike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BoneSpike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3075 - $GC_I_SKILL_ID_FLURRY_OF_SPLINTERS
Func CanUse_FlurryOfSplinters()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FlurryOfSplinters($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3084 - $GC_I_SKILL_ID_REAPING_OF_DHUUM
Func CanUse_ReapingOfDhuum()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ReapingOfDhuum($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3133 - $GC_I_SKILL_ID_WEIGHT_OF_DHUUM
Func CanUse_WeightOfDhuum()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WeightOfDhuum($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3140 - $GC_I_SKILL_ID_STAGGERING_BLOW_PVP
Func CanUse_StaggeringBlowPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StaggeringBlowPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3142 - $GC_I_SKILL_ID_FIERCE_BLOW_PVP
Func CanUse_FierceBlowPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FierceBlowPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3143 - $GC_I_SKILL_ID_RENEWING_SMASH_PVP
Func CanUse_RenewingSmashPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RenewingSmashPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3147 - $GC_I_SKILL_ID_KEEN_ARROW_PVP
Func CanUse_KeenArrowPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeenArrowPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3153 - $GC_I_SKILL_ID_PAIN_ATTACK_SIGNET_OF_SPIRITS1
Func CanUse_PainAttackSignetOfSpirits1()
	Return True
EndFunc

Func BestTarget_PainAttackSignetOfSpirits1($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3154 - $GC_I_SKILL_ID_PAIN_ATTACK_SIGNET_OF_SPIRITS2
Func CanUse_PainAttackSignetOfSpirits2()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PainAttackSignetOfSpirits2($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3155 - $GC_I_SKILL_ID_PAIN_ATTACK_SIGNET_OF_SPIRITS3
Func CanUse_PainAttackSignetOfSpirits3()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PainAttackSignetOfSpirits3($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3163 - $GC_I_SKILL_ID_KEIRANS_SNIPER_SHOT
Func CanUse_KeiransSniperShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeiransSniperShot($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3164 - $GC_I_SKILL_ID_FALKEN_PUNCH
Func CanUse_FalkenPunch()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FalkenPunch($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3235 - $GC_I_SKILL_ID_KEIRANS_SNIPER_SHOT_HEARTS_OF_THE_NORTH
Func CanUse_KeiransSniperShotHeartsOfTheNorth()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeiransSniperShotHeartsOfTheNorth($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3236 - $GC_I_SKILL_ID_GRAVESTONE_MARKER
Func CanUse_GravestoneMarker()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GravestoneMarker($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3237 - $GC_I_SKILL_ID_TERMINAL_VELOCITY
Func CanUse_TerminalVelocity()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TerminalVelocity($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3238 - $GC_I_SKILL_ID_RELENTLESS_ASSAULT
Func CanUse_RelentlessAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RelentlessAssault($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3244 - $GC_I_SKILL_ID_WITHERING_BLADE
Func CanUse_WitheringBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WitheringBlade($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3246 - $GC_I_SKILL_ID_VENOM_FANG
Func CanUse_VenomFang()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_VenomFang($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3249 - $GC_I_SKILL_ID_RAIN_OF_ARROWS
Func CanUse_RainOfArrows()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RainOfArrows($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3250 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3251 - $GC_I_SKILL_ID_FOX_FANGS_PVP
Func CanUse_FoxFangsPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FoxFangsPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3252 - $GC_I_SKILL_ID_WILD_STRIKE_PVP
Func CanUse_WildStrikePvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildStrikePvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3263 - $GC_I_SKILL_ID_BANISHING_STRIKE_PVP
Func CanUse_BanishingStrikePvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BanishingStrikePvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3264 - $GC_I_SKILL_ID_TWIN_MOON_SWEEP_PVP
Func CanUse_TwinMoonSweepPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TwinMoonSweepPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3265 - $GC_I_SKILL_ID_IRRESISTIBLE_SWEEP_PVP
Func CanUse_IrresistibleSweepPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_IrresistibleSweepPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3266 - $GC_I_SKILL_ID_PIOUS_ASSAULT_PVP
Func CanUse_PiousAssaultPvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PiousAssaultPvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3295 - $GC_I_SKILL_ID_CLUB_STRIKE
Func CanUse_ClubStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ClubStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3296 - $GC_I_SKILL_ID_BLUDGEON
Func CanUse_Bludgeon()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Bludgeon($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3301 - $GC_I_SKILL_ID_ANNIHILATOR_BASH
Func CanUse_AnnihilatorBash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AnnihilatorBash($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3367 - $GC_I_SKILL_ID_WOUNDING_STRIKE_PVP
Func CanUse_WoundingStrikePvp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WoundingStrikePvp($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3381 - $GC_I_SKILL_ID_ANNIHILATOR_STRIKE
Func CanUse_AnnihilatorStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AnnihilatorStrike($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3383 - $GC_I_SKILL_ID_ANNIHILATOR_KNUCKLE
Func CanUse_AnnihilatorKnuckle()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AnnihilatorKnuckle($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3425 - $GC_I_SKILL_ID_JUDGMENT_STRIKE
Func CanUse_JudgmentStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_JudgmentStrike($a_f_AggroRange)
	Return 0
EndFunc

