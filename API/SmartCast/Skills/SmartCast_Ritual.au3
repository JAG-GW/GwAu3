#include-once

; Skill ID: 462 - $GC_I_SKILL_ID_WINTER
Func CanUse_Winter()
	Return True
EndFunc

Func BestTarget_Winter($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 463 - $GC_I_SKILL_ID_WINNOWING
Func CanUse_Winnowing()
	Return True
EndFunc

Func BestTarget_Winnowing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 464 - $GC_I_SKILL_ID_EDGE_OF_EXTINCTION
Func CanUse_EdgeOfExtinction()
	Return True
EndFunc

Func BestTarget_EdgeOfExtinction($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 465 - $GC_I_SKILL_ID_GREATER_CONFLAGRATION
Func CanUse_GreaterConflagration()
	Return True
EndFunc

Func BestTarget_GreaterConflagration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 466 - $GC_I_SKILL_ID_CONFLAGRATION
Func CanUse_Conflagration()
	Return True
EndFunc

Func BestTarget_Conflagration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 467 - $GC_I_SKILL_ID_FERTILE_SEASON
Func CanUse_FertileSeason()
	Return True
EndFunc

Func BestTarget_FertileSeason($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 468 - $GC_I_SKILL_ID_SYMBIOSIS
Func CanUse_Symbiosis()
	Return True
EndFunc

Func BestTarget_Symbiosis($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 469 - $GC_I_SKILL_ID_PRIMAL_ECHOES
Func CanUse_PrimalEchoes()
	Return True
EndFunc

Func BestTarget_PrimalEchoes($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 470 - $GC_I_SKILL_ID_PREDATORY_SEASON
Func CanUse_PredatorySeason()
	Return True
EndFunc

Func BestTarget_PredatorySeason($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 471 - $GC_I_SKILL_ID_FROZEN_SOIL
Func CanUse_FrozenSoil()
	Return True
EndFunc

Func BestTarget_FrozenSoil($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 472 - $GC_I_SKILL_ID_FAVORABLE_WINDS
Func CanUse_FavorableWinds()
	Return True
EndFunc

Func BestTarget_FavorableWinds($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 473 - $GC_I_SKILL_ID_HIGH_WINDS
Func CanUse_HighWinds()
	Return True
EndFunc

Func BestTarget_HighWinds($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 474 - $GC_I_SKILL_ID_ENERGIZING_WIND
Func CanUse_EnergizingWind()
	Return True
EndFunc

Func BestTarget_EnergizingWind($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 475 - $GC_I_SKILL_ID_QUICKENING_ZEPHYR
Func CanUse_QuickeningZephyr()
	Return True
EndFunc

Func BestTarget_QuickeningZephyr($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 476 - $GC_I_SKILL_ID_NATURES_RENEWAL
Func CanUse_NaturesRenewal()
	Return True
EndFunc

Func BestTarget_NaturesRenewal($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 477 - $GC_I_SKILL_ID_MUDDY_TERRAIN
Func CanUse_MuddyTerrain()
	Return True
EndFunc

Func BestTarget_MuddyTerrain($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 870 - $GC_I_SKILL_ID_PESTILENCE
Func CanUse_Pestilence()
	Return True
EndFunc

Func BestTarget_Pestilence($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 871 - $GC_I_SKILL_ID_SHADOWSONG
Func CanUse_Shadowsong()
	Local $lSpirit = Agent_FindByPlayerNumber(4213, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Shadowsong($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 911 - $GC_I_SKILL_ID_UNION
Func CanUse_Union()
	Local $lSpirit = Agent_FindByPlayerNumber(4224, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Union($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 920 - $GC_I_SKILL_ID_DESTRUCTION
Func CanUse_Destruction()
	Local $lSpirit = Agent_FindByPlayerNumber(4215, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Destruction($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 921 - $GC_I_SKILL_ID_DISSONANCE
Func CanUse_Dissonance()
	Local $lSpirit = Agent_FindByPlayerNumber(4221, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Dissonance($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 923 - $GC_I_SKILL_ID_DISENCHANTMENT
Func CanUse_Disenchantment()
	Local $lSpirit = Agent_FindByPlayerNumber(4225, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Disenchantment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 947 - $GC_I_SKILL_ID_BRAMBLES
Func CanUse_Brambles()
	Return True
EndFunc

Func BestTarget_Brambles($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 961 - $GC_I_SKILL_ID_LACERATE
Func CanUse_Lacerate()
	Return True
EndFunc

Func BestTarget_Lacerate($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 963 - $GC_I_SKILL_ID_RESTORATION
Func CanUse_Restoration()
	If CachedAgent_HasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or CachedAgent_HasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False

	Local $lSpirit = Agent_FindByPlayerNumber(4223, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Restoration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 981 - $GC_I_SKILL_ID_RECUPERATION
Func CanUse_Recuperation()
	Local $lSpirit = Agent_FindByPlayerNumber(4220, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Recuperation($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 982 - $GC_I_SKILL_ID_SHELTER
Func CanUse_Shelter()
	Local $lSpirit = Agent_FindByPlayerNumber(4223, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Shelter($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 997 - $GC_I_SKILL_ID_FAMINE
Func CanUse_Famine()
	Return True
EndFunc

Func BestTarget_Famine($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1212 - $GC_I_SKILL_ID_EQUINOX
Func CanUse_Equinox()
	Return True
EndFunc

Func BestTarget_Equinox($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1213 - $GC_I_SKILL_ID_TRANQUILITY
Func CanUse_Tranquility()
	Return True
EndFunc

Func BestTarget_Tranquility($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1247 - $GC_I_SKILL_ID_PAIN
Func CanUse_Pain()
	Return True
EndFunc

Func BestTarget_Pain($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1249 - $GC_I_SKILL_ID_DISPLACEMENT
Func CanUse_Displacement()
	Local $lSpirit = Agent_FindByPlayerNumber(4217, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Displacement($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1250 - $GC_I_SKILL_ID_PRESERVATION
Func CanUse_Preservation()
	Local $lSpirit = Agent_FindByPlayerNumber(4219, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Preservation($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1251 - $GC_I_SKILL_ID_LIFE
Func CanUse_Life()
	Local $lSpirit = Agent_FindByPlayerNumber(4218, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Life($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1252 - $GC_I_SKILL_ID_EARTHBIND
Func CanUse_Earthbind()
	Local $lSpirit = Agent_FindByPlayerNumber(4222, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Earthbind($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1253 - $GC_I_SKILL_ID_BLOODSONG
Func CanUse_Bloodsong()
	Local $lSpirit = Agent_FindByPlayerNumber(4227, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Bloodsong($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1255 - $GC_I_SKILL_ID_WANDERLUST
Func CanUse_Wanderlust()
	Local $lSpirit = Agent_FindByPlayerNumber(4228, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Wanderlust($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1266 - $GC_I_SKILL_ID_SOOTHING
Func CanUse_Soothing()
	Local $lSpirit = Agent_FindByPlayerNumber(4216, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Soothing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1472 - $GC_I_SKILL_ID_TOXICITY
Func CanUse_Toxicity()
	Return True
EndFunc

Func BestTarget_Toxicity($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1473 - $GC_I_SKILL_ID_QUICKSAND
Func CanUse_Quicksand()
	Return True
EndFunc

Func BestTarget_Quicksand($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1725 - $GC_I_SKILL_ID_ROARING_WINDS
Func CanUse_RoaringWinds()
	Return True
EndFunc

Func BestTarget_RoaringWinds($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1730 - $GC_I_SKILL_ID_INFURIATING_HEAT
Func CanUse_InfuriatingHeat()
	Return True
EndFunc

Func BestTarget_InfuriatingHeat($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1734 - $GC_I_SKILL_ID_GAZE_OF_FURY
Func CanUse_GazeOfFury()
	Local $lSpirit = Agent_FindByPlayerNumber(5722, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then Return False

	If Count_NumberOf(-2, 1250, "Filter_IsControlledSpirit") = 0 Then Return False

	Return True
EndFunc

Func BestTarget_GazeOfFury($aAggroRange)
	Return
EndFunc

; Skill ID: 1745 - $GC_I_SKILL_ID_ANGUISH
Func CanUse_Anguish()
	Local $lSpirit = Agent_FindByPlayerNumber(5720, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Anguish($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1747 - $GC_I_SKILL_ID_EMPOWERMENT
Func CanUse_Empowerment()
	Local $lSpirit = Agent_FindByPlayerNumber(5721, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Empowerment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1748 - $GC_I_SKILL_ID_RECOVERY
Func CanUse_Recovery()
	Local $lSpirit = Agent_FindByPlayerNumber(5719, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Recovery($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1901 - $GC_I_SKILL_ID_JACK_FROST
Func CanUse_JackFrost()
	Return True
EndFunc

Func BestTarget_JackFrost($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2110 - $GC_I_SKILL_ID_VAMPIRISM
Func CanUse_Vampirism()
	Local $lSpirit = Agent_FindByPlayerNumber(5723, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Vampirism($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2204 - $GC_I_SKILL_ID_REJUVENATION
Func CanUse_Rejuvenation()
	Local $lSpirit = Agent_FindByPlayerNumber(5853, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Rejuvenation($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2205 - $GC_I_SKILL_ID_AGONY
Func CanUse_Agony()
	Local $lSpirit = Agent_FindByPlayerNumber(5854, -2, 2500, "Filter_IsControlledSpirit")

	If $lSpirit <> 0 Then
		If Agent_GetAgentInfo($lSpirit, "HP") < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Agony($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2422 - $GC_I_SKILL_ID_WINDS
Func CanUse_Winds()
	Return True
EndFunc

Func BestTarget_Winds($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2656 - $GC_I_SKILL_ID_CALL_TO_THE_SPIRIT_REALM
Func CanUse_CallToTheSpiritRealm()
	Return True
EndFunc

Func BestTarget_CallToTheSpiritRealm($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2691 - $GC_I_SKILL_ID_DISENCHANTMENT_TOGO
Func CanUse_DisenchantmentTogo()
	Return True
EndFunc

Func BestTarget_DisenchantmentTogo($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3005 - $GC_I_SKILL_ID_UNION_PVP
Func CanUse_UnionPvp()
	Return True
EndFunc

Func BestTarget_UnionPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3006 - $GC_I_SKILL_ID_SHADOWSONG_PVP
Func CanUse_ShadowsongPvp()
	Return True
EndFunc

Func BestTarget_ShadowsongPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3007 - $GC_I_SKILL_ID_PAIN_PVP
Func CanUse_PainPvp()
	Return True
EndFunc

Func BestTarget_PainPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3008 - $GC_I_SKILL_ID_DESTRUCTION_PVP
Func CanUse_DestructionPvp()
	Return True
EndFunc

Func BestTarget_DestructionPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3009 - $GC_I_SKILL_ID_SOOTHING_PVP
Func CanUse_SoothingPvp()
	Return True
EndFunc

Func BestTarget_SoothingPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3010 - $GC_I_SKILL_ID_DISPLACEMENT_PVP
Func CanUse_DisplacementPvp()
	Return True
EndFunc

Func BestTarget_DisplacementPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3011 - $GC_I_SKILL_ID_PRESERVATION_PVP
Func CanUse_PreservationPvp()
	Return True
EndFunc

Func BestTarget_PreservationPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3012 - $GC_I_SKILL_ID_LIFE_PVP
Func CanUse_LifePvp()
	Return True
EndFunc

Func BestTarget_LifePvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3013 - $GC_I_SKILL_ID_RECUPERATION_PVP
Func CanUse_RecuperationPvp()
	Return True
EndFunc

Func BestTarget_RecuperationPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3014 - $GC_I_SKILL_ID_DISSONANCE_PVP
Func CanUse_DissonancePvp()
	Return True
EndFunc

Func BestTarget_DissonancePvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3015 - $GC_I_SKILL_ID_EARTHBIND_PVP
Func CanUse_EarthbindPvp()
	Return True
EndFunc

Func BestTarget_EarthbindPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3016 - $GC_I_SKILL_ID_SHELTER_PVP
Func CanUse_ShelterPvp()
	Return True
EndFunc

Func BestTarget_ShelterPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3017 - $GC_I_SKILL_ID_DISENCHANTMENT_PVP
Func CanUse_DisenchantmentPvp()
	Return True
EndFunc

Func BestTarget_DisenchantmentPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3018 - $GC_I_SKILL_ID_RESTORATION_PVP
Func CanUse_RestorationPvp()
	If CachedAgent_HasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or CachedAgent_HasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_RestorationPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3019 - $GC_I_SKILL_ID_BLOODSONG_PVP
Func CanUse_BloodsongPvp()
	Return True
EndFunc

Func BestTarget_BloodsongPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3020 - $GC_I_SKILL_ID_WANDERLUST_PVP
Func CanUse_WanderlustPvp()
	Return True
EndFunc

Func BestTarget_WanderlustPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3022 - $GC_I_SKILL_ID_GAZE_OF_FURY_PVP
Func CanUse_GazeOfFuryPvp()
	Return True
EndFunc

Func BestTarget_GazeOfFuryPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3023 - $GC_I_SKILL_ID_ANGUISH_PVP
Func CanUse_AnguishPvp()
	Return True
EndFunc

Func BestTarget_AnguishPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3024 - $GC_I_SKILL_ID_EMPOWERMENT_PVP
Func CanUse_EmpowermentPvp()
	Return True
EndFunc

Func BestTarget_EmpowermentPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3025 - $GC_I_SKILL_ID_RECOVERY_PVP
Func CanUse_RecoveryPvp()
	Return True
EndFunc

Func BestTarget_RecoveryPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3038 - $GC_I_SKILL_ID_AGONY_PVP
Func CanUse_AgonyPvp()
	Return True
EndFunc

Func BestTarget_AgonyPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3039 - $GC_I_SKILL_ID_REJUVENATION_PVP
Func CanUse_RejuvenationPvp()
	Return True
EndFunc

Func BestTarget_RejuvenationPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3041 - $GC_I_SKILL_ID_SHADOWSONG_MASTER_RIYO
Func CanUse_ShadowsongMasterRiyo()
	Return True
EndFunc

Func BestTarget_ShadowsongMasterRiyo($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3042 - ;  $GC_I_SKILL_ID_PAIN
; Skill ID: 3043 - ;  $GC_I_SKILL_ID_WANDERLUST
