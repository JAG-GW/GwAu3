#include-once

Func Anti_Ward()
	;~ Generic hex checks
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False

	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) Then Return True

	;~ Check for hexes that punish casting by damage
	Local $l_i_CommingDamage = 0

	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BACKFIRE) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_BACKFIRE, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
		$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, "Scale")
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
			$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, "BonusScale")
		EndIf
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP) Then
		$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP, "Scale")
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP) Then
			$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP, "BonusScale")
		EndIf
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MISTRUST, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST_PVP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MISTRUST_PVP, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MARK_OF_SUBVERSION) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MARK_OF_SUBVERSION, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SOUL_LEECH) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SOUL_LEECH, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SPITEFUL_SPIRIT, "Scale")
	Return $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50)
EndFunc

; Skill ID: 175 - $GC_I_SKILL_ID_WARD_AGAINST_ELEMENTS
Func CanUse_WardAgainstElements()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardAgainstElements($a_f_AggroRange)
	; Description
	; Ward Spell. You create a Ward Against Elements at your current location. For 8...18...20 seconds, non-spirit allies in this area gain +24 armor against elemental damage.
	; Concise description
	; Ward Spell. (8...18...20 seconds.) Allies in this ward have +24 armor against elemental damage. Spirits are unaffected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 176 - $GC_I_SKILL_ID_WARD_AGAINST_MELEE
Func CanUse_WardAgainstMelee()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardAgainstMelee($a_f_AggroRange)
	; Description
	; Ward Spell. You create a Ward Against Melee at your current location. For 5...17...20 seconds, non-spirit allies in this area have a 50% chance to block melee attacks.
	; Concise description
	; Ward Spell. (5...17...20 seconds.) Allies in this ward have a 50% chance to block melee attacks. Allied spirits are not affected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 177 - $GC_I_SKILL_ID_WARD_AGAINST_FOES
Func CanUse_WardAgainstFoes()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardAgainstFoes($a_f_AggroRange)
	; Description
	; Ward Spell. You create a Ward Against Foes at your current location. For 8...18...20 seconds, non-spirit foes in this area move 50% slower.
	; Concise description
	; Ward Spell. (8...18...20 seconds.) Foes in this ward move 50% slower.
	; Offensive ward - move to center of enemy group
	If UAI_MoveToOffensiveWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 239 - $GC_I_SKILL_ID_WARD_AGAINST_HARM
Func CanUse_WardAgainstHarm()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardAgainstHarm($a_f_AggroRange)
	; Description
	; Elite Ward Spell. Create a Ward Against Harm at this location. For 5...13...15 seconds, non-spirit allies in this area have +1...3...3 health regeneration, +12...22...24 armor, and an additional +12...22...24 armor against elemental damage. This spell is disabled for 20 seconds.
	; Concise description
	; Elite Ward Spell. (5...13...15 seconds.) Allies in this ward have +1...3...3 Health regeneration, +12...22...24 armor, and +12...22...24 additional armor against elemental damage. Spirits are unaffected. This spell is disabled for 20 seconds.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 938 - $GC_I_SKILL_ID_WARD_OF_STABILITY
Func CanUse_WardOfStability()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardOfStability($a_f_AggroRange)
	; Description
	; Ward Spell. Create a Ward of Stability at your current location. For 10...22...25 seconds, non-spirit allies cannot be knocked down.
	; Concise description
	; Ward Spell. (10...22...25 seconds.) Allies in this ward cannot be knocked-down. Allied spirits are not affected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 1093 - $GC_I_SKILL_ID_TEINAIS_HEAT
Func CanUse_TeinaisHeat()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_TeinaisHeat($a_f_AggroRange)
	; Description
	; Ward Spell. Place a ward of Teinai's Heat at your location for 10...14...15 seconds. Foes within the ward suffer 2...4...5 health degeneration. Weakened foes attack 33% slower. This skill is disabled for 20 seconds.
	; Concise description
	; Ward Spell. (10...14...15 seconds.) Causes -2...4...5 health degeneration. Weakened foes in the ward attack 33% slower. Disabled for 20 seconds.
	; Offensive ward - move to center of enemy group
	If UAI_MoveToOffensiveWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2001 - $GC_I_SKILL_ID_WARD_OF_WEAKNESS
Func CanUse_WardOfWeakness()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardOfWeakness($a_f_AggroRange)
	; Description
	; Ward Spell. You create a Ward of Weakness at your current location. For 5...17...20 seconds, foes in this area become Weakened for 5...17...20 seconds whenever they take elemental damage.
	; Concise description
	; Ward Spell. (5...17...20 seconds). Inflicts Weakened condition (5...17...20 seconds) to any foes that take elemental damage in this ward.
	; Offensive ward - move to center of enemy group
	If UAI_MoveToOffensiveWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2231 - $GC_I_SKILL_ID_EBON_BATTLE_STANDARD_OF_COURAGE
Func CanUse_EbonBattleStandardOfCourage()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_EbonBattleStandardOfCourage($a_f_AggroRange)
	; Description
	; Ward Spell. You plant an Ebon Battle Standard of Courage at your current location. For 14...20 seconds, non-spirit allies in this area gain +24 armor and an additional +24 armor against Charr.
	; Concise description
	; Ward Spell. (14...20 seconds.) Allies in this ward have +24 armor and +24 more armor against Charr. Spirits are unaffected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2232 - $GC_I_SKILL_ID_EBON_BATTLE_STANDARD_OF_WISDOM
Func CanUse_EbonBattleStandardOfWisdom()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_EbonBattleStandardOfWisdom($a_f_AggroRange)
	; Description
	; Ward Spell. You plant an Ebon Battle Standard of Wisdom at your current location. For 14...20 seconds, non-spirit allies in this area have a 44...60% chance to halve skill recharge of spells they cast.
	; Concise description
	; Ward Spell. (14...20 seconds.) Spells that allies in this ward cast have a 44...60% chance to recharge 50% faster. Spirits are unaffected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2233 - $GC_I_SKILL_ID_EBON_BATTLE_STANDARD_OF_HONOR
Func CanUse_EbonBattleStandardOfHonor()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_EbonBattleStandardOfHonor($a_f_AggroRange)
	; Description
	; Ward Spell. You plant an Ebon Battle Standard of Honor at your current location. For 14...20 seconds, non-spirit allies in this area strike for +8...15 damage and an additional +7...10 vs. Charr.
	; Concise description
	; Ward Spell. (14...20 seconds.) Allies in this ward deal +8...15 damage and +7...10 more damage against Charr. Spirits are unaffected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2414 - $GC_I_SKILL_ID_RADIATION_FIELD
Func CanUse_RadiationField()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_RadiationField($a_f_AggroRange)
	; Description
	; Ward Spell. For 5 seconds, foes in the area have -4...6 Health degeneration. When the portal ends, foes in the area are Diseased for 12...20 seconds.
	; Concise description
	; Ward Spell. (5 seconds.) Causes -4...6 Health degeneration to foes in the area. End effect: inflicts Disease condition (12...20 seconds) to foes in the area.
	; Offensive ward - move to center of enemy group
	If UAI_MoveToOffensiveWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2674 - $GC_I_SKILL_ID_BANNER_OF_THE_UNSEEN
Func CanUse_BannerOfTheUnseen()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_BannerOfTheUnseen($a_f_AggroRange)
	; Description
	; Ward Spell. Create a Banner of the Unseen at your location. For 5 seconds, all allies in its area are healed for 25 Health each second. When this spell ends, all allies in its area are healed for 100.
	; Concise description
	; Ward Spell. (5 seconds.) Heals all allies in its area for 25 each second. End effect: heals for 100.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2806 - $GC_I_SKILL_ID_WARD_AGAINST_HARM_PvP
Func CanUse_WardAgainstHarmPvP()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardAgainstHarmPvP($a_f_AggroRange)
	; Description
	; Elite Ward Spell. Create a Ward Against Harm at this location. For 5...13...15 seconds, non-spirit allies in this area have +1...3...3 health regeneration, +12...22...24 armor, and an additional +12...22...24 armor against elemental damage. This spell is disabled for 20 seconds.
	; Concise description
	; Elite Ward Spell. (5...13...15 seconds.) Allies in this ward have +1...3...3 Health regeneration, +12...22...24 armor, and +12...22...24 additional armor against elemental damage. Spirits are unaffected. This spell is disabled for 20 seconds.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 2855 - $GC_I_SKILL_ID_WARD_AGAINST_MELEE_PvP
Func CanUse_WardAgainstMeleePvP()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_WardAgainstMeleePvP($a_f_AggroRange)
	; Description
	; Ward Spell. You create a Ward Against Melee at your current location. For 5...17...20 seconds, non-spirit allies in this area have a 50% chance to block melee attacks.
	; Concise description
	; Ward Spell. (5...17...20 seconds.) Allies in this ward have a 50% chance to block melee attacks. Allied spirits are not affected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 3172 - $GC_I_SKILL_ID_EBON_VANGUARD_BATTLE_STANDARD_OF_POWER
Func CanUse_EbonVanguardBattleStandardOfPower()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_EbonVanguardBattleStandardOfPower($a_f_AggroRange)
	; Description
	; Ward Spell. You plant an Ebon Battle Standard of Power at your current location. For 20 seconds, non-spirit allies in this area strike for +15 damage and gain +24 armor.
	; Concise description
	; Ward Spell. (20 seconds.) Allies in this ward deal +15 damage and have +24 more armor. Spirits are unaffected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

; Skill ID: 3422 - $GC_I_SKILL_ID_TIME_WARD
Func CanUse_TimeWard()
	If Anti_Ward() Then Return False
	Return True
EndFunc

Func BestTarget_TimeWard($a_f_AggroRange)
	; Description
	; Elite Ward Spell. You create a Time Ward at your location. For 3...13...15 seconds, non-spirit allies in this area cast spells 15...19...20% faster and recharge skills 15...19...20% faster.
	; Concise description
	; Elite Ward Spell. (3...13...15 seconds.) Allies in this ward cast spells 15...19...20% faster and recharge skills 15...19...20% faster. Allied spirits are not affected.
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc

