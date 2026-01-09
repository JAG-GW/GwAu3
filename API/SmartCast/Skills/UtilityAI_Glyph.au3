#include-once

Func Anti_Glyph()
	Return False
EndFunc

; Skill ID: 198 - $GC_I_SKILL_ID_GLYPH_OF_ELEMENTAL_POWER
Func CanUse_GlyphOfElementalPower()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfElementalPower($a_f_AggroRange)
	; Description
	; Glyph. For 25 seconds, your elemental attributes are boosted by 2 for your next 10 spells.
	; Concise description
	; Glyph. (25 seconds.) Your next 10 spells have +2 to your elemental attributes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 199 - $GC_I_SKILL_ID_GLYPH_OF_ENERGY
Func CanUse_GlyphOfEnergy()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfEnergy($a_f_AggroRange)
	; Description
	; Elite Glyph. Your next 1...3...3 spell[s] do[es] not cause Overcast and cost[s] 10...22...25 less Energy to cast. Your elemental attributes are increased by 1...2...2.
	; Concise description
	; Elite Glyph. Your next 1...3...3 spell[s] do[es] not cause Overcast and cost[s] 10...22...25 less Energy. Gain 1...2...2 to all elemental attributes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 200 - $GC_I_SKILL_ID_GLYPH_OF_LESSER_ENERGY
Func CanUse_GlyphOfLesserEnergy()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfLesserEnergy($a_f_AggroRange)
	; Description
	; Glyph. For the next 15 seconds, your next 2 spells cost 10...16...18 less Energy to cast.
	; Concise description
	; Glyph. (15 seconds.) Your next 2 spells cost 10...16...18 less Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 201 - $GC_I_SKILL_ID_GLYPH_OF_CONCENTRATION
Func CanUse_GlyphOfConcentration()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfConcentration($a_f_AggroRange)
	; Description
	; Glyph. For 15 seconds, your next 1 spell cannot be interrupted and ignores the effects of being Dazed.
	; Concise description
	; Glyph. (15 seconds.) Your next spell cannot be interrupted and ignores Dazed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 202 - $GC_I_SKILL_ID_GLYPH_OF_SACRIFICE
Func CanUse_GlyphOfSacrifice()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfSacrifice($a_f_AggroRange)
	; Description
	; Glyph. For 15 seconds, your next spell casts instantly, but it takes an additional 30 seconds to recharge. Ends prematurely if you use a non-spell skill.
	; Concise description
	; Glyph. (15 seconds.) Your next spell casts instantly but takes an additional 30 seconds to recharge. Ends if you use a non-spell skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 203 - $GC_I_SKILL_ID_GLYPH_OF_RENEWAL
Func CanUse_GlyphOfRenewal()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfRenewal($a_f_AggroRange)
	; Description
	; Elite Glyph. For 15 seconds, your next spell instantly recharges.
	; Concise description
	; Elite Glyph. (15 seconds.) Your next spell recharges instantly.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1008 - $GC_I_SKILL_ID_HIDDEN_ROCK
Func CanUse_HiddenRock()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_HiddenRock($a_f_AggroRange)
	; Description
	; Glyph. Your next snowball knocks down target foe and causes Daze for 10 seconds.
	; Concise description
	; Glyph. Your next snowball causes knock-down and inflicts Dazed (10 seconds.)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1096 - $GC_I_SKILL_ID_GLYPH_OF_ESSENCE
Func CanUse_GlyphOfEssence()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfEssence($a_f_AggroRange)
	; Description
	; Glyph. For 15 seconds, your next spell casts instantly but causes you to lose all Energy.
	; Concise description
	; Glyph. (15 seconds.) Your next spell casts instantly. You lose all Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1376 - $GC_I_SKILL_ID_GLYPH_OF_RESTORATION
Func CanUse_GlyphOfRestoration()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfRestoration($a_f_AggroRange)
	; Description
	; Glyph. For 15 seconds, your next 2 spells heal you for 30...90...105 Health, and you are healed for 150...350...400% of the Energy cost of each spell.
	; Concise description
	; Glyph. (15 seconds.) Your next 2 spells heal you for 30...90...105 and 150...350...400% of their Energy costs.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2002 - $GC_I_SKILL_ID_GLYPH_OF_SWIFTNESS
Func CanUse_GlyphOfSwiftness()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfSwiftness($a_f_AggroRange)
	; Description
	; Glyph. For 15 seconds, your next 1...4...5 spell[s] recharge 25% faster and projectiles from the affected spells move 200% faster.
	; Concise description
	; Glyph. (15 seconds.) Your next 1...4...5 spell[s] recharge 25% faster and projectiles move 200% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2060 - $GC_I_SKILL_ID_GLYPH_OF_IMMOLATION
Func CanUse_GlyphOfImmolation()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_GlyphOfImmolation($a_f_AggroRange)
	; Description
	; Glyph. For 15 seconds, your next 1...3...4 spell[s] that target[s] a foe also cause[s] Burning for 1...3...4 second[s].
	; Concise description
	; Glyph. (15 seconds.) Your next 1...3...4 spell[s] that target[s] a foe also inflict[s] Burning (1...3...4 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2250 - $GC_I_SKILL_ID_POLYMOCK_GLYPH_OF_CONCENTRATION
Func CanUse_PolymockGlyphOfConcentration()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockGlyphOfConcentration($a_f_AggroRange)
	; Description
	; Glyph. For 8 seconds, your next spell cannot be interrupted.
	; Concise description
	; Glyph. (8 seconds.) Your next spell cannot be interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2252 - $GC_I_SKILL_ID_POLYMOCK_GLYPH_OF_POWER
Func CanUse_PolymockGlyphOfPower()
	If Anti_Glyph() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockGlyphOfPower($a_f_AggroRange)
	; Description
	; Glyph. If you are below 50% health, your next spell that targets a foe deals 200 additional damage. If you are below 25% health, your next 2 spells are affected.
	; Concise description
	; Glyph. Your next spell that targets a foe deals +200 damage if you are below 50% Health. If you are below 25% Health, your next 2 spells are affected.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
