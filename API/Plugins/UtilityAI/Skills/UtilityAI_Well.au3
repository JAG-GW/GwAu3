#include-once

Func Anti_Well()
	;~ Generic hex checks
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False

	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True

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

; Skill ID: 91 - $GC_I_SKILL_ID_WELL_OF_POWER
Func CanUse_WellOfPower()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfPower($a_f_AggroRange)
	; Description
	; Elite Well Spell. Exploit nearest corpse to create a Well of Power at that location. For 8...18...20 seconds, allies within the area of Well of Power gain +1...5...6 Health regeneration and +2 Energy regeneration.
	; Concise description
	; Elite Well Spell. (8...18...20 seconds.) Allies in this well have +1...5...6 Health regeneration and +2 Energy regeneration. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForAllySupport($a_f_AggroRange)
EndFunc

; Skill ID: 92 - $GC_I_SKILL_ID_WELL_OF_BLOOD
Func CanUse_WellOfBlood()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfBlood($a_f_AggroRange)
	; Description
	; Well Spell. Exploit nearest corpse to create a Well of Blood at its location. For 8...18...20 seconds, allies in that area receive +1...5...6 Health regeneration.
	; Concise description
	; Well Spell. (8...18...20 seconds.) Allies in this well have +1...5...6 Health regeneration. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForAllySupport($a_f_AggroRange)
EndFunc

; Skill ID: 93 - $GC_I_SKILL_ID_WELL_OF_SUFFERING
Func CanUse_WellOfSuffering()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfSuffering($a_f_AggroRange)
	; Description
	; Well Spell. Exploit nearest corpse to create a Well of Suffering at its location. For 10...26...30 seconds, foes in that area suffer -1...5...6 Health degeneration.
	; Concise description
	; Well Spell. (10...26...30 seconds.) Foes in this well have -1...5...6 Health degeneration. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc

; Skill ID: 94 - $GC_I_SKILL_ID_WELL_OF_THE_PROFANE
Func CanUse_WellOfTheProfane()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfTheProfane($a_f_AggroRange)
	; Description
	; Well Spell. Exploit nearest corpse to create a Well of the Profane at its location. For 8...18...20 seconds, foes in that area are stripped of all enchantments and cannot be the target of further enchantments. (50% failure chance with Death Magic 4 or less.)
	; Concise description
	; Well Spell. (8...18...20 seconds.) Foes in this well lose all enchantments and cannot be the target of further enchantments. Exploits a fresh corpse. 50% failure chance unless Death Magic 5 or more.
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc

; Skill ID: 818 - $GC_I_SKILL_ID_WELL_OF_WEARINESS
Func CanUse_WellOfWeariness()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfWeariness($a_f_AggroRange)
	; Description
	; Well Spell. Exploit target corpse to create a Well of Weariness for 10...46...55 seconds. Enemies within the Well suffer -1 Energy degeneration.
	; Concise description
	; Well Spell. (10...46...55 seconds.) Foes in this well have -1 Energy degeneration. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc

; Skill ID: 1366 - $GC_I_SKILL_ID_WELL_OF_DARKNESS
Func CanUse_WellOfDarkness()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfDarkness($a_f_AggroRange)
	; Description
	; Well Spell. Exploit nearest corpse to create a Well of Darkness for 5...41...50 seconds. Hexed foes within the Well of Darkness miss 50% of the time.
	; Concise description
	; Well Spell. (5...41...50 seconds.) Hexed foes in this well have 50% chance to miss. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc

; Skill ID: 1660 - $GC_I_SKILL_ID_WELL_OF_SILENCE
Func CanUse_WellOfSilence()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfSilence($a_f_AggroRange)
	; Description
	; Well Spell. Exploit target corpse to create a Well of Silence for 10...26...30 seconds. Foes within the well cannot use shouts or chants and suffer -1...3...4 Health degeneration.
	; Concise description
	; Well Spell. (10...26...30 seconds.) Foes in this well cannot use shouts and chants and have -1...3...4 Health degeneration. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc

; Skill ID: 2236 - $GC_I_SKILL_ID_WELL_OF_RUIN
Func CanUse_WellOfRuin()
	If Anti_Well() Then Return False
	Return True
EndFunc

Func BestTarget_WellOfRuin($a_f_AggroRange)
	; Description
	; Well Spell. Exploit nearest corpse to create a Well of Ruin at its location. For 5...25...30 seconds, whenever a foe in the well takes physical damage, that foe has Cracked Armor for 5...17...20 seconds.
	; Concise description
	; Well Spell. (5...25...30 seconds.) Inflicts Cracked Armor condition (5...17...20 seconds) to any foe in the well that takes physical damage. Exploits a fresh corpse.
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc

