#include-once

Func Anti_Ritual()
	Return False
EndFunc

; Skill ID: 462 - $GC_I_SKILL_ID_WINTER
Func CanUse_Winter()
	Return True
EndFunc

Func BestTarget_Winter($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. For creatures within its range, all elemental damage is cold damage instead. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Converts elemental damage to cold damage for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 463 - $GC_I_SKILL_ID_WINNOWING
Func CanUse_Winnowing()
	Return True
EndFunc

Func BestTarget_Winnowing($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. Non-spirit creatures within range take 4 additional damage whenever they take physical damage. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Increases physical damage by +4 for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 464 - $GC_I_SKILL_ID_EDGE_OF_EXTINCTION
Func CanUse_EdgeOfExtinction()
	Return True
EndFunc

Func BestTarget_EdgeOfExtinction($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. If a non-spirit creature within range dies, Edge of Extinction deals 14...43...50 damage to all creatures of the same type that are below 90% Health and within range of the spirit. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Deals 14...43...50 damage to creatures in its range whenever a creature of the same type dies. Does not affect spirits. No damage to creatures above 90% Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 465 - $GC_I_SKILL_ID_GREATER_CONFLAGRATION
Func CanUse_GreaterConflagration()
	Return True
EndFunc

Func BestTarget_GreaterConflagration($a_f_AggroRange)
	; Description
	; Elite Nature Ritual. Create a level 1...8...10 spirit. For non-spirit creatures within its range, all physical damage is fire damage instead. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Elite Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Converts physical damage to fire damage for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 466 - $GC_I_SKILL_ID_CONFLAGRATION
Func CanUse_Conflagration()
	Return True
EndFunc

Func BestTarget_Conflagration($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. For non-spirit creatures within its range, all arrows that hit strike for fire damage. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). All arrows deal fire damage for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 467 - $GC_I_SKILL_ID_FERTILE_SEASON
Func CanUse_FertileSeason()
	Return True
EndFunc

Func BestTarget_FertileSeason($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. Non-spirit creatures within range have +50...130...150 maximum Health and gain +8 armor. This spirit dies after 15...39...45 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (15...39...45 second lifespan). Creatures in range have +50...130...150 maximum health and +8 armor. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 468 - $GC_I_SKILL_ID_SYMBIOSIS
Func CanUse_Symbiosis()
	Return True
EndFunc

Func BestTarget_Symbiosis($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. For each enchantment on a non-spirit creature within range, that creature has +27...125...150 maximum Health. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Creatures in range have +27...125...150 maximum health for each enchantment on them. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 469 - $GC_I_SKILL_ID_PRIMAL_ECHOES
Func CanUse_PrimalEchoes()
	Return True
EndFunc

Func BestTarget_PrimalEchoes($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 Spirit. For non-Spirit creatures within its range, Signets cost 10 Energy to use. This Spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Signets cost 10 energy for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 470 - $GC_I_SKILL_ID_PREDATORY_SEASON
Func CanUse_PredatorySeason()
	Return True
EndFunc

Func BestTarget_PredatorySeason($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. For non-spirit creatures within its range, all healing is reduced by 20%. If any of your attacks hit, you gain 5 Health. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Creatures in range receive 20% less from healing. Creatures gain 5 health each time they hit with an attack. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 471 - $GC_I_SKILL_ID_FROZEN_SOIL
Func CanUse_FrozenSoil()
	Return True
EndFunc

Func BestTarget_FrozenSoil($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. Non-spirit creatures within its range cannot activate resurrection skills. This spirit dies after 30...78...90 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit. (30...78...90 second lifespan). Creatures in range cannot activate resurrection skills. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 472 - $GC_I_SKILL_ID_FAVORABLE_WINDS
Func CanUse_FavorableWinds()
	Return True
EndFunc

Func BestTarget_FavorableWinds($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. For non-spirit creatures within its range, arrows move twice as fast and strike for +6 damage. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Arrows move twice as fast and hit for +6 damage for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 473 - $GC_I_SKILL_ID_HIGH_WINDS
Func CanUse_HighWinds()
	Return True
EndFunc

Func BestTarget_HighWinds($a_f_AggroRange)
	; Description
	; Ranger
	; Concise description
	; green; font-weight: bold;">1...8...10
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 474 - $GC_I_SKILL_ID_ENERGIZING_WIND
Func CanUse_EnergizingWind()
	Return True
EndFunc

Func BestTarget_EnergizingWind($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...5...6 spirit. For non-spirit creatures within its range, all skills cost 15 less Energy (minimum cost 10 Energy), and skills recharge 25% slower. This spirit dies after 1...25...31 second[s].
	; Concise description
	; Nature Ritual. Creates a level 1...5...6 spirit (1...25...31 second[s] lifespan). Skills cost 15 less energy (minimum cost 10 energy) and recharge 25% slower for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 475 - $GC_I_SKILL_ID_QUICKENING_ZEPHYR
Func CanUse_QuickeningZephyr()
	Return True
EndFunc

Func BestTarget_QuickeningZephyr($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. For non-spirit creatures within its range, all skills recharge twice as fast and cost 30% more of the base Energy to cast. This spirit dies after 15...39...45 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (15...39...45 second lifespan). Skills cost 30% more Energy and recharge twice as fast for creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 476 - $GC_I_SKILL_ID_NATURES_RENEWAL
Func CanUse_NaturesRenewal()
	Return True
EndFunc

Func BestTarget_NaturesRenewal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 477 - $GC_I_SKILL_ID_MUDDY_TERRAIN
Func CanUse_MuddyTerrain()
	Return True
EndFunc

Func BestTarget_MuddyTerrain($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. Non-spirit creatures within its range move 10% slower and speed boosts have no effect. This spirit dies after 30...78...90 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...78...90 second lifespan). Creatures in range have 10% slower movement: also negates speed boosts. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 870 - $GC_I_SKILL_ID_PESTILENCE
Func CanUse_Pestilence()
	Return True
EndFunc

Func BestTarget_Pestilence($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. When any creature within its range dies, conditions on that creature spread to any creature in the area already suffering from a condition. This spirit dies after 30...78...90 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...78...90 second lifespan). When any creature in range dies, conditions on this creature spread to any creature in the area with a condition. Spirits are not affected.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...8...10 spirit. The spirit's attacks deal 5...17...20 damage and cause Blindness for 1...5...6 second[s]. This spirit dies after 30 second[s].
	; Concise description
	; Binding Ritual. Creates a level 1...8...10 spirit (30-second lifespan). Its attacks deal 5...17...20 damage and inflict Blindness condition (1...5...6 second[s]).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...10...12 spirit. Whenever a non-spirit ally in its range takes damage or life steal, it is reduced by 15 and the spirit takes 15 damage. This spirit dies after 30...54...60 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...10...12 spirit (30...54...60 second lifespan). Whenever a non-spirit ally within range takes damage or life steal, it is reduced by 15 and the spirit takes 15 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 920 - $GC_I_SKILL_ID_DESTRUCTION
Func CanUse_Destruction()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4215, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Destruction($a_f_AggroRange)
	; Description
	; Binding Ritual. Create a level 1...11...14 Spirit that dies after 30 seconds. When this Spirit dies, all foes in the area take 5...21...25 damage for each second the Spirit was alive (maximum 150 damage).
	; Concise description
	; Binding Ritual. Create a level 1...11...14 Spirit that dies after 30 seconds. When this Spirit dies, all foes in the area take 5...21...25 damage for each second the Spirit was alive (maximum 150 damage).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...10...12 spirit. This spirit deals 5...17...20 damage and anyone struck by its attack is interrupted. This spirit dies after 10...22...25 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...10...12 spirit (10...22...25 second lifespan). Its attacks deal 5...17...20 damage and interrupt actions.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; This article is about the Factions skill. For the temporarily available Bonus Mission Pack skill, see Disenchantment (Togo).
	; Concise description
	; green; font-weight: bold;">1...10...12
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 947 - $GC_I_SKILL_ID_BRAMBLES
Func CanUse_Brambles()
	Return True
EndFunc

Func BestTarget_Brambles($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 Spirit. Non-Spirit creatures that are knocked down in its range take 5 damage and begin Bleeding for 5...17...20 seconds. This Spirit dies after 30...126...150 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Knocked-down creatures take 5 damage and begin Bleeding (5...17...20 seconds). Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 961 - $GC_I_SKILL_ID_LACERATE
Func CanUse_Lacerate()
	Return True
EndFunc

Func BestTarget_Lacerate($a_f_AggroRange)
	; Description
	; Elite Nature Ritual. Create a level 1...8...10 spirit. Bleeding creatures within its range suffer -2 Health degeneration. When this spirit dies, all non-spirit creatures within its range that have less than 90% Health begin Bleeding for 5...21...25 seconds. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Elite Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Bleeding creatures in range have -2 Health degeneration. End effect: Inflicts Bleeding condition (5...21...25 seconds) on creatures in range that have less than 90% health. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 963 - $GC_I_SKILL_ID_RESTORATION
Func CanUse_Restoration()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False

	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4223, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Restoration($a_f_AggroRange)
	; Description
	; This article is about the skill Restoration. For the Ritualist attribute line, see Restoration Magic.
	; Concise description
	; green; font-weight: bold;">1...11...14
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...11...14 spirit. Non-spirit allies within its range gain +1...3...3 Health regeneration. This spirit dies after 15...39...45 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...11...14 spirit (15...39...45 second lifespan). Non-spirit allies within range have +1...3...3 Health regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; This article is about the skill Shelter. For the -suffix weapon modifier, see Of Shelter.
	; Concise description
	; green; font-weight: bold;">1...10...12
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 997 - $GC_I_SKILL_ID_FAMINE
Func CanUse_Famine()
	Return True
EndFunc

Func BestTarget_Famine($a_f_AggroRange)
	; Description
	; Elite Nature Ritual. Create a level 1...8...10 spirit. Whenever a non-spirit creature in its range reaches 0 Energy, that creature takes 10...30...35 damage. This spirit dies after 30...78...90 seconds.
	; Concise description
	; Elite Nature Ritual. Creates a level 1...8...10 spirit (30...78...90 lifespan). Deals 10...30...35 damage to creatures in range that reach 0 energy. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1212 - $GC_I_SKILL_ID_EQUINOX
Func CanUse_Equinox()
	Return True
EndFunc

Func BestTarget_Equinox($a_f_AggroRange)
	; Description
	; Elite Nature Ritual. Create a level 1...8...10 spirit. Spells cast within its range that cause Overcast cause an additional 10 Overcast. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Elite Nature Ritual. Creates a level 1...8...10 spirit (30...126...150 second lifespan). Overcast-causing spells cast within range cause an additional 10 Overcast.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1213 - $GC_I_SKILL_ID_TRANQUILITY
Func CanUse_Tranquility()
	Return True
EndFunc

Func BestTarget_Tranquility($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. Enchantments cast by non-spirit creatures within its range expire 20...44...50% faster. This spirit dies after 15...51...60 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (15...51...60 second lifespan). Enchantments expire 20...44...50% faster on creatures in range. Does not affect spirits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1247 - $GC_I_SKILL_ID_PAIN
Func CanUse_Pain()
	Return True
EndFunc

Func BestTarget_Pain($a_f_AggroRange)
	; Description
	; Binding Ritual. Create a level 1...10...12 spirit. This spirit's attacks deal 5...25...30 damage. This spirit dies after 30...126...150 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...10...12 spirit (30...126...150 second lifespan). Its attacks deal 5...25...30 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...11...14 spirit. All non-spirit allies within its range have a 75% chance to block incoming attacks. Every time an attack is blocked in this way, this spirit takes 60 damage. This spirit dies after 30...54...60 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...11...14 spirit (30...54...60 second lifespan). Non-spirit allies within range have 75% chance to block. Block effect: this spirit takes 60 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Elite Binding Ritual. Create a level 1...11...14 spirit. Every 4 seconds, this spirit heals one non-spirit ally in the area for 10...94...115 Health. This spirit dies after 90 seconds.
	; Concise description
	; Elite Binding Ritual. Creates a level 1...11...14 spirit (90 second lifespan). Every 4 seconds this spirit heals one non-spirit ally for 10...94...115.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1251 - $GC_I_SKILL_ID_LIFE
Func CanUse_Life()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4218, -2, 2500, "UAI_Filter_IsControlledSpirit")

	If $l_i_Spirit <> 0 Then Return False

	Return True
EndFunc

Func BestTarget_Life($a_f_AggroRange)
	; Description
	; Binding Ritual. Create a level 1...11...14 spirit. When this spirit dies, all non-spirit allies within its range are healed for 1...6...7 Health for each second this spirit was alive. This spirit dies after 20 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...11...14 spirit (20 second lifespan). Affects non-spirit allies within range. End effect: heals for 1...6...7 for each second this spirit was alive.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...11...14 spirit. All non-spirit foes knocked down within its range are knocked down for at least 3 seconds. Whenever this happens, this spirit loses 50...30...25 Health. This spirit dies after 15...39...45 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...11...14 spirit (15...39...45 second lifespan). Any time non-spirit foes within range are knocked down, they are knocked down for at least 3 seconds. Knock-down cost: this spirit loses 50...30...25 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...10...12 spirit who dies after 30...126...150 seconds. Attacks by that spirit steal up to 5...21...25 Health.
	; Concise description
	; Binding Ritual. Creates a level 1...10...12 spirit (30...126...150 second lifespan). Its attacks steal 5...21...25 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Elite Binding Ritual. Create a level 1...10...12 spirit. Whenever this spirit's attack hits a stationary foe, that foe is knocked down and the spirit loses 70...54...50 Health. This spirit dies after 30...54...60 seconds.
	; Concise description
	; Elite Binding Ritual. Creates a level 1...10...12 spirit (30...54...60 second lifespan). Its attacks against stationary foes cause knock-down. Knock-down cost: this spirit loses 70...54...50 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...10...12 spirit. All foes within its range take twice as long to build adrenaline. This spirit dies after 15...39...45 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...10...12 spirit (15...39...45 second lifespan). Building adrenaline takes twice as long for foes within range.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1472 - $GC_I_SKILL_ID_TOXICITY
Func CanUse_Toxicity()
	Return True
EndFunc

Func BestTarget_Toxicity($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. Poisoned or Diseased creatures within its range suffer -2 Health degeneration. This spirit dies after 30...78...90 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...78...90 second lifespan.) Poisoned or Diseased creatures within range have -2 Health degeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1473 - $GC_I_SKILL_ID_QUICKSAND
Func CanUse_Quicksand()
	Return True
EndFunc

Func BestTarget_Quicksand($a_f_AggroRange)
	; Description
	; This article is about the skill Quicksand. For the environment effect of the same name, see Quicksand (environment effect).
	; Concise description
	; green; font-weight: bold;">1...8...10
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1725 - $GC_I_SKILL_ID_ROARING_WINDS
Func CanUse_RoaringWinds()
	Return True
EndFunc

Func BestTarget_RoaringWinds($a_f_AggroRange)
	; Description
	; Nature Ritual. Create a level 1...8...10 spirit. Chants and shouts cost 1...4...5 more Energy. This spirit dies after 30...54...60 seconds.
	; Concise description
	; Nature Ritual. Creates a level 1...8...10 spirit (30...54...60 second lifespan). Chants and shouts cost 1...4...5 more Energy for creatures in range.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1730 - $GC_I_SKILL_ID_INFURIATING_HEAT
Func CanUse_InfuriatingHeat()
	Return True
EndFunc

Func BestTarget_InfuriatingHeat($a_f_AggroRange)
	; Description
	; Elite Nature Ritual. Create a level 1...8...10 spirit. Non-spirit creatures within its range gain adrenaline twice as fast. This spirit dies after 30...54...60 seconds.
	; Concise description
	; Elite Nature Ritual. Creates a level 1...8...10 spirit (30...54...60 second lifespan). Doubles adrenaline gain for creatures in range.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; This article is about the skill. For the creature, see Anguish (creature).
	; Concise description
	; green; font-weight: bold;">1...9...11
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...11...14 spirit. All allies within its range holding an item gain 15...39...45 maximum Health and 10 maximum Energy. This spirit dies after 15...51...60 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...11...14 spirit (15...51...60 second lifespan). Allies in range holding an item gain 15...39...45 maximum Health and 10 maximum Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...11...14 spirit. Conditions on allies within range of this spirit expire 20...44...50% faster. This spirit dies after 30...54...60 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...11...14 spirit (30...54...60 second lifespan). Conditions on allies in range expire 20...44...50% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1901 - $GC_I_SKILL_ID_JACK_FROST
Func CanUse_JackFrost()
	Return True
EndFunc

Func BestTarget_JackFrost($a_f_AggroRange)
	; Description
	; Binding Ritual. Create a level 5 Jack Frost. This creature deals 50 damage with snowballs. This creature dies after 60 seconds.
	; Concise description
	; Binding Ritual. Creates a level 5 Jack Frost (60 second lifespan). It deals 50 damage with snowballs.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 4...14 spirit that dies after 75...150 seconds. Attacks by this spirit steal up to 10...20 Health, and you are healed for 10...20 Health.
	; Concise description
	; Binding Ritual. Creates a level 4...14 spirit (lifespan 75...150 seconds). Its attacks steal 10...20 Health, and you are healed for 10...20.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...16...20 spirit. This spirit heals all party members within earshot for 3...9...10 Health each second. This spirit loses 3...9...10 Health for each party member healed in this way. This spirit dies after 30...78...90 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...16...20 spirit (30...78...90 second lifespan). Heals party members in earshot for 3...9...10 each second. Healing cost: this spirit loses 3...9...10 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Binding Ritual. Create a level 1...10...12 spirit. This spirit causes 3...9...10 Health loss each second to foes within earshot. This spirit loses 3...9...10 Health for each foe hurt in this way. This spirit dies after 30...78...90 seconds.
	; Concise description
	; Binding Ritual. Creates a level 1...10...12 spirit (30...78...90 second lifespan). Causes 3...9...10 Health loss each second to foes in earshot. This spirit loses 3...9...10 Health for each foe that loses Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2422 - $GC_I_SKILL_ID_WINDS
Func CanUse_Winds()
	Return True
EndFunc

Func BestTarget_Winds($a_f_AggroRange)
	; Description
	; Ebon Vanguard Ritual. Create a level 4...10 Spirit. All foes within its range have 15% chance to miss with ranged attacks. This spirit dies after 54...90 seconds.
	; Concise description
	; Ebon Vanguard Ritual. Creates a level 4...10 spirit (54...90 second lifespan.) Affects foes within range. 15% chance to miss with ranged attacks.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2656 - $GC_I_SKILL_ID_CALL_TO_THE_SPIRIT_REALM
Func CanUse_CallToTheSpiritRealm()
	Return True
EndFunc

Func BestTarget_CallToTheSpiritRealm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2691 - $GC_I_SKILL_ID_DISENCHANTMENT_TOGO
Func CanUse_DisenchantmentTogo()
	Return True
EndFunc

Func BestTarget_DisenchantmentTogo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3005 - $GC_I_SKILL_ID_UNION_PVP
Func CanUse_UnionPvp()
	Return True
EndFunc

Func BestTarget_UnionPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3006 - $GC_I_SKILL_ID_SHADOWSONG_PVP
Func CanUse_ShadowsongPvp()
	Return True
EndFunc

Func BestTarget_ShadowsongPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3007 - $GC_I_SKILL_ID_PAIN_PVP
Func CanUse_PainPvp()
	Return True
EndFunc

Func BestTarget_PainPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3008 - $GC_I_SKILL_ID_DESTRUCTION_PVP
Func CanUse_DestructionPvp()
	Return True
EndFunc

Func BestTarget_DestructionPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3009 - $GC_I_SKILL_ID_SOOTHING_PVP
Func CanUse_SoothingPvp()
	Return True
EndFunc

Func BestTarget_SoothingPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3010 - $GC_I_SKILL_ID_DISPLACEMENT_PVP
Func CanUse_DisplacementPvp()
	Return True
EndFunc

Func BestTarget_DisplacementPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3011 - $GC_I_SKILL_ID_PRESERVATION_PVP
Func CanUse_PreservationPvp()
	Return True
EndFunc

Func BestTarget_PreservationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3012 - $GC_I_SKILL_ID_LIFE_PVP
Func CanUse_LifePvp()
	Return True
EndFunc

Func BestTarget_LifePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3013 - $GC_I_SKILL_ID_RECUPERATION_PVP
Func CanUse_RecuperationPvp()
	Return True
EndFunc

Func BestTarget_RecuperationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3014 - $GC_I_SKILL_ID_DISSONANCE_PVP
Func CanUse_DissonancePvp()
	Return True
EndFunc

Func BestTarget_DissonancePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3015 - $GC_I_SKILL_ID_EARTHBIND_PVP
Func CanUse_EarthbindPvp()
	Return True
EndFunc

Func BestTarget_EarthbindPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3016 - $GC_I_SKILL_ID_SHELTER_PVP
Func CanUse_ShelterPvp()
	Return True
EndFunc

Func BestTarget_ShelterPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3017 - $GC_I_SKILL_ID_DISENCHANTMENT_PVP
Func CanUse_DisenchantmentPvp()
	Return True
EndFunc

Func BestTarget_DisenchantmentPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3018 - $GC_I_SKILL_ID_RESTORATION_PVP
Func CanUse_RestorationPvp()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_RestorationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3019 - $GC_I_SKILL_ID_BLOODSONG_PVP
Func CanUse_BloodsongPvp()
	Return True
EndFunc

Func BestTarget_BloodsongPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3020 - $GC_I_SKILL_ID_WANDERLUST_PVP
Func CanUse_WanderlustPvp()
	Return True
EndFunc

Func BestTarget_WanderlustPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3024 - $GC_I_SKILL_ID_EMPOWERMENT_PVP
Func CanUse_EmpowermentPvp()
	Return True
EndFunc

Func BestTarget_EmpowermentPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3025 - $GC_I_SKILL_ID_RECOVERY_PVP
Func CanUse_RecoveryPvp()
	Return True
EndFunc

Func BestTarget_RecoveryPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3038 - $GC_I_SKILL_ID_AGONY_PVP
Func CanUse_AgonyPvp()
	Return True
EndFunc

Func BestTarget_AgonyPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3039 - $GC_I_SKILL_ID_REJUVENATION_PVP
Func CanUse_RejuvenationPvp()
	Return True
EndFunc

Func BestTarget_RejuvenationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3041 - $GC_I_SKILL_ID_SHADOWSONG_MASTER_RIYO
Func CanUse_ShadowsongMasterRiyo()
	Return True
EndFunc

Func BestTarget_ShadowsongMasterRiyo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3042 - ;  $GC_I_SKILL_ID_PAIN
; Skill ID: 3043 - ;  $GC_I_SKILL_ID_WANDERLUST
