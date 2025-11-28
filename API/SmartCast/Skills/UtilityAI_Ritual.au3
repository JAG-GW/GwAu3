#include-once

Func Anti_Ritual()

EndFunc

; Skill ID: 462 - $GC_I_SKILL_ID_WINTER
Func CanUse_Winter()
	Return True
EndFunc

Func BestTarget_Winter($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 463 - $GC_I_SKILL_ID_WINNOWING
Func CanUse_Winnowing()
	Return True
EndFunc

Func BestTarget_Winnowing($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 464 - $GC_I_SKILL_ID_EDGE_OF_EXTINCTION
Func CanUse_EdgeOfExtinction()
	Return True
EndFunc

Func BestTarget_EdgeOfExtinction($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 465 - $GC_I_SKILL_ID_GREATER_CONFLAGRATION
Func CanUse_GreaterConflagration()
	Return True
EndFunc

Func BestTarget_GreaterConflagration($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 466 - $GC_I_SKILL_ID_CONFLAGRATION
Func CanUse_Conflagration()
	Return True
EndFunc

Func BestTarget_Conflagration($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 467 - $GC_I_SKILL_ID_FERTILE_SEASON
Func CanUse_FertileSeason()
	Return True
EndFunc

Func BestTarget_FertileSeason($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 468 - $GC_I_SKILL_ID_SYMBIOSIS
Func CanUse_Symbiosis()
	Return True
EndFunc

Func BestTarget_Symbiosis($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 469 - $GC_I_SKILL_ID_PRIMAL_ECHOES
Func CanUse_PrimalEchoes()
	Return True
EndFunc

Func BestTarget_PrimalEchoes($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 470 - $GC_I_SKILL_ID_PREDATORY_SEASON
Func CanUse_PredatorySeason()
	Return True
EndFunc

Func BestTarget_PredatorySeason($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 471 - $GC_I_SKILL_ID_FROZEN_SOIL
Func CanUse_FrozenSoil()
	Return True
EndFunc

Func BestTarget_FrozenSoil($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 472 - $GC_I_SKILL_ID_FAVORABLE_WINDS
Func CanUse_FavorableWinds()
	Return True
EndFunc

Func BestTarget_FavorableWinds($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 473 - $GC_I_SKILL_ID_HIGH_WINDS
Func CanUse_HighWinds()
	Return True
EndFunc

Func BestTarget_HighWinds($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 474 - $GC_I_SKILL_ID_ENERGIZING_WIND
Func CanUse_EnergizingWind()
	Return True
EndFunc

Func BestTarget_EnergizingWind($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 475 - $GC_I_SKILL_ID_QUICKENING_ZEPHYR
Func CanUse_QuickeningZephyr()
	Return True
EndFunc

Func BestTarget_QuickeningZephyr($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 476 - $GC_I_SKILL_ID_NATURES_RENEWAL
Func CanUse_NaturesRenewal()
	Return True
EndFunc

Func BestTarget_NaturesRenewal($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 477 - $GC_I_SKILL_ID_MUDDY_TERRAIN
Func CanUse_MuddyTerrain()
	Return True
EndFunc

Func BestTarget_MuddyTerrain($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 870 - $GC_I_SKILL_ID_PESTILENCE
Func CanUse_Pestilence()
	Return True
EndFunc

Func BestTarget_Pestilence($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 871 - $GC_I_SKILL_ID_SHADOWSONG
Func CanUse_Shadowsong()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4213, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Shadowsong($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 911 - $GC_I_SKILL_ID_UNION
Func CanUse_Union()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4224, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Union($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 920 - $GC_I_SKILL_ID_DESTRUCTION
Func CanUse_Destruction()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4215, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Destruction($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 921 - $GC_I_SKILL_ID_DISSONANCE
Func CanUse_Dissonance()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4221, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Dissonance($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 923 - $GC_I_SKILL_ID_DISENCHANTMENT
Func CanUse_Disenchantment()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4225, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Disenchantment($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 947 - $GC_I_SKILL_ID_BRAMBLES
Func CanUse_Brambles()
	Return True
EndFunc

Func BestTarget_Brambles($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 961 - $GC_I_SKILL_ID_LACERATE
Func CanUse_Lacerate()
	Return True
EndFunc

Func BestTarget_Lacerate($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 963 - $GC_I_SKILL_ID_RESTORATION
Func CanUse_Restoration()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False

	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4223, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Restoration($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 981 - $GC_I_SKILL_ID_RECUPERATION
Func CanUse_Recuperation()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4220, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Recuperation($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 982 - $GC_I_SKILL_ID_SHELTER
Func CanUse_Shelter()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4223, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Shelter($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 997 - $GC_I_SKILL_ID_FAMINE
Func CanUse_Famine()
	Return True
EndFunc

Func BestTarget_Famine($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1212 - $GC_I_SKILL_ID_EQUINOX
Func CanUse_Equinox()
	Return True
EndFunc

Func BestTarget_Equinox($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1213 - $GC_I_SKILL_ID_TRANQUILITY
Func CanUse_Tranquility()
	Return True
EndFunc

Func BestTarget_Tranquility($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1247 - $GC_I_SKILL_ID_PAIN
Func CanUse_Pain()
	Return True
EndFunc

Func BestTarget_Pain($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1249 - $GC_I_SKILL_ID_DISPLACEMENT
Func CanUse_Displacement()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4217, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Displacement($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1250 - $GC_I_SKILL_ID_PRESERVATION
Func CanUse_Preservation()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4219, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Preservation($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1251 - $GC_I_SKILL_ID_LIFE
Func CanUse_Life()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4218, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Life($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1252 - $GC_I_SKILL_ID_EARTHBIND
Func CanUse_Earthbind()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4222, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Earthbind($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1253 - $GC_I_SKILL_ID_BLOODSONG
Func CanUse_Bloodsong()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4227, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Bloodsong($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1255 - $GC_I_SKILL_ID_WANDERLUST
Func CanUse_Wanderlust()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4228, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Wanderlust($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1266 - $GC_I_SKILL_ID_SOOTHING
Func CanUse_Soothing()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4216, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Soothing($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1472 - $GC_I_SKILL_ID_TOXICITY
Func CanUse_Toxicity()
	Return True
EndFunc

Func BestTarget_Toxicity($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1473 - $GC_I_SKILL_ID_QUICKSAND
Func CanUse_Quicksand()
	Return True
EndFunc

Func BestTarget_Quicksand($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1725 - $GC_I_SKILL_ID_ROARING_WINDS
Func CanUse_RoaringWinds()
	Return True
EndFunc

Func BestTarget_RoaringWinds($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1730 - $GC_I_SKILL_ID_INFURIATING_HEAT
Func CanUse_InfuriatingHeat()
	Return True
EndFunc

Func BestTarget_InfuriatingHeat($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1734 - $GC_I_SKILL_ID_GAZE_OF_FURY
Func CanUse_GazeOfFury()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5722, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then Return False

	If UAI_CountAgents(-2, 1250, "UAI_Filter_IsControlledSpirit") = 0 Then Return False

	Return True
EndFunc

Func BestTarget_GazeOfFury($a_f_AggroRange)
	Return
EndFunc

; Skill ID: 1745 - $GC_I_SKILL_ID_ANGUISH
Func CanUse_Anguish()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5720, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Anguish($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1747 - $GC_I_SKILL_ID_EMPOWERMENT
Func CanUse_Empowerment()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5721, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Empowerment($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1748 - $GC_I_SKILL_ID_RECOVERY
Func CanUse_Recovery()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5719, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Recovery($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1901 - $GC_I_SKILL_ID_JACK_FROST
Func CanUse_JackFrost()
	Return True
EndFunc

Func BestTarget_JackFrost($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2110 - $GC_I_SKILL_ID_VAMPIRISM
Func CanUse_Vampirism()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5723, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Vampirism($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2204 - $GC_I_SKILL_ID_REJUVENATION
Func CanUse_Rejuvenation()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5853, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Rejuvenation($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2205 - $GC_I_SKILL_ID_AGONY
Func CanUse_Agony()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5854, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf

	Return True
EndFunc

Func BestTarget_Agony($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2422 - $GC_I_SKILL_ID_WINDS
Func CanUse_Winds()
	Return True
EndFunc

Func BestTarget_Winds($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2656 - $GC_I_SKILL_ID_CALL_TO_THE_SPIRIT_REALM
Func CanUse_CallToTheSpiritRealm()
	Return True
EndFunc

Func BestTarget_CallToTheSpiritRealm($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2691 - $GC_I_SKILL_ID_DISENCHANTMENT_TOGO
Func CanUse_DisenchantmentTogo()
	Return True
EndFunc

Func BestTarget_DisenchantmentTogo($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3005 - $GC_I_SKILL_ID_UNION_PVP
Func CanUse_UnionPvp()
	Return True
EndFunc

Func BestTarget_UnionPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3006 - $GC_I_SKILL_ID_SHADOWSONG_PVP
Func CanUse_ShadowsongPvp()
	Return True
EndFunc

Func BestTarget_ShadowsongPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3007 - $GC_I_SKILL_ID_PAIN_PVP
Func CanUse_PainPvp()
	Return True
EndFunc

Func BestTarget_PainPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3008 - $GC_I_SKILL_ID_DESTRUCTION_PVP
Func CanUse_DestructionPvp()
	Return True
EndFunc

Func BestTarget_DestructionPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3009 - $GC_I_SKILL_ID_SOOTHING_PVP
Func CanUse_SoothingPvp()
	Return True
EndFunc

Func BestTarget_SoothingPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3010 - $GC_I_SKILL_ID_DISPLACEMENT_PVP
Func CanUse_DisplacementPvp()
	Return True
EndFunc

Func BestTarget_DisplacementPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3011 - $GC_I_SKILL_ID_PRESERVATION_PVP
Func CanUse_PreservationPvp()
	Return True
EndFunc

Func BestTarget_PreservationPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3012 - $GC_I_SKILL_ID_LIFE_PVP
Func CanUse_LifePvp()
	Return True
EndFunc

Func BestTarget_LifePvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3013 - $GC_I_SKILL_ID_RECUPERATION_PVP
Func CanUse_RecuperationPvp()
	Return True
EndFunc

Func BestTarget_RecuperationPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3014 - $GC_I_SKILL_ID_DISSONANCE_PVP
Func CanUse_DissonancePvp()
	Return True
EndFunc

Func BestTarget_DissonancePvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3015 - $GC_I_SKILL_ID_EARTHBIND_PVP
Func CanUse_EarthbindPvp()
	Return True
EndFunc

Func BestTarget_EarthbindPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3016 - $GC_I_SKILL_ID_SHELTER_PVP
Func CanUse_ShelterPvp()
	Return True
EndFunc

Func BestTarget_ShelterPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3017 - $GC_I_SKILL_ID_DISENCHANTMENT_PVP
Func CanUse_DisenchantmentPvp()
	Return True
EndFunc

Func BestTarget_DisenchantmentPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3018 - $GC_I_SKILL_ID_RESTORATION_PVP
Func CanUse_RestorationPvp()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_RestorationPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3019 - $GC_I_SKILL_ID_BLOODSONG_PVP
Func CanUse_BloodsongPvp()
	Return True
EndFunc

Func BestTarget_BloodsongPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3020 - $GC_I_SKILL_ID_WANDERLUST_PVP
Func CanUse_WanderlustPvp()
	Return True
EndFunc

Func BestTarget_WanderlustPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3022 - $GC_I_SKILL_ID_GAZE_OF_FURY_PVP
Func CanUse_GazeOfFuryPvp()
	Return True
EndFunc

Func BestTarget_GazeOfFuryPvp($a_f_AggroRange)
	Return
EndFunc

; Skill ID: 3023 - $GC_I_SKILL_ID_ANGUISH_PVP
Func CanUse_AnguishPvp()
	Return True
EndFunc

Func BestTarget_AnguishPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3024 - $GC_I_SKILL_ID_EMPOWERMENT_PVP
Func CanUse_EmpowermentPvp()
	Return True
EndFunc

Func BestTarget_EmpowermentPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3025 - $GC_I_SKILL_ID_RECOVERY_PVP
Func CanUse_RecoveryPvp()
	Return True
EndFunc

Func BestTarget_RecoveryPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3038 - $GC_I_SKILL_ID_AGONY_PVP
Func CanUse_AgonyPvp()
	Return True
EndFunc

Func BestTarget_AgonyPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3039 - $GC_I_SKILL_ID_REJUVENATION_PVP
Func CanUse_RejuvenationPvp()
	Return True
EndFunc

Func BestTarget_RejuvenationPvp($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3041 - $GC_I_SKILL_ID_SHADOWSONG_MASTER_RIYO
Func CanUse_ShadowsongMasterRiyo()
	Return True
EndFunc

Func BestTarget_ShadowsongMasterRiyo($a_f_AggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3042 - ;  $GC_I_SKILL_ID_PAIN
; Skill ID: 3043 - ;  $GC_I_SKILL_ID_WANDERLUST
