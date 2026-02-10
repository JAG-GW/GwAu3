#include-once

Func Anti_Preparation()
	Return False
EndFunc

; Skill ID: 429 - $GC_I_SKILL_ID_MELANDRUS_ARROWS
Func CanUse_MelandrusArrows()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_MelandrusArrows($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 430 - $GC_I_SKILL_ID_MARKSMANS_WAGER
Func CanUse_MarksmansWager()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_MarksmansWager($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 431 - $GC_I_SKILL_ID_IGNITE_ARROWS
Func CanUse_IgniteArrows()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_IgniteArrows($a_f_AggroRange)
	; Description
	; Preparation. For 24 seconds, your arrows explode on contact, dealing 3...15...18 fire damage to target and all adjacent foes.
	; Concise description
	; Preparation. (24 seconds.) Your arrows deal 3...15...18 fire damage to target and foes adjacent to target.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 432 - $GC_I_SKILL_ID_READ_THE_WIND
Func CanUse_ReadTheWind()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_ReadTheWind($a_f_AggroRange)
	; Description
	; Preparation. For 24 seconds, your arrows move twice as fast and deal 3...9...10 extra damage.
	; Concise description
	; Preparation. (24 seconds). +3...9...10 damage. Your arrows move twice as fast.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 433 - $GC_I_SKILL_ID_KINDLE_ARROWS
Func CanUse_KindleArrows()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_KindleArrows($a_f_AggroRange)
	; Description
	; Preparation. For 24 seconds, your arrows deal fire damage and hit for an additional 3...20...24 fire damage.
	; Concise description
	; Preparation. (24 seconds.) +3...20...24 fire damage. Your arrows deal fire damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 434 - $GC_I_SKILL_ID_CHOKING_GAS
Func CanUse_ChokingGas()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_ChokingGas($a_f_AggroRange)
	; Description
	; Preparation. For 1...10...12 seconds, your arrows deal 1...7...8 more damage and spread Choking Gas to all adjacent foes on impact. Choking Gas interrupts foes attempting to cast spells.
	; Concise description
	; Preparation. (1...10...12 seconds.) +1...7...8 damage. Spreads Choking Gas to foes adjacent to target. Choking Gas interrupts spells.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 435 - $GC_I_SKILL_ID_APPLY_POISON
Func CanUse_ApplyPoison()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_ApplyPoison($a_f_AggroRange)
	; Description
	; Preparation. For 24 seconds, foes struck by your physical attacks become Poisoned for 3...13...15 seconds.
	; Concise description
	; Preparation. (24 seconds.) Your physical attacks inflict Poisoned condition (3...13...15 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 893 - $GC_I_SKILL_ID_SEEKING_ARROWS
Func CanUse_SeekingArrows()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_SeekingArrows($a_f_AggroRange)
	; Description
	; Preparation. For 3...12...14 seconds, your arrows cannot be blocked. Seeking Arrows ends if you fail to hit.
	; Concise description
	; Preparation. (3...12...14 seconds.) Your arrows are unblockable. Ends if you fail to hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 946 - $GC_I_SKILL_ID_TRAPPERS_FOCUS
Func CanUse_TrappersFocus()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_TrappersFocus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1007 - $GC_I_SKILL_ID_YELLOW_SNOW
Func CanUse_YellowSnow()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_YellowSnow($a_f_AggroRange)
	; Description
	; Snow fighting skill
	; Concise description
	; //en.wikipedia.org/wiki/Sic" class="extiw" title="w:Sic">
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1181 - $GC_I_SKILL_ID_CORRUPTED_BREATH
Func CanUse_CorruptedBreath()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_CorruptedBreath($a_f_AggroRange)
	; Description
	; Preparation. For 20 seconds, whenever your attacks hit a foe, all nearby foes take 50 damage for each enchantment on your target.
	; Concise description
	; Preparation. (20 seconds.) Whenever your attacks hit, all nearby foes take 50 damage for each enchantment on your target.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1199 - $GC_I_SKILL_ID_GLASS_ARROWS
Func CanUse_GlassArrows()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_GlassArrows($a_f_AggroRange)
	; Description
	; Elite Preparation. For 10...30...35 seconds, your arrows strike for +5...17...20 damage if they hit and cause Bleeding for 10...18...20 seconds if they are blocked.
	; Concise description
	; Elite Preparation. (10...30...35 seconds.) Your arrows deal +5...17...20 damage. Inflicts Bleeding condition if blocked (10...18...20 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1470 - $GC_I_SKILL_ID_BARBED_ARROWS
Func CanUse_BarbedArrows()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedArrows($a_f_AggroRange)
	; Description
	; Preparation. For 24 seconds, your arrows cause Bleeding for 3...13...15 seconds. You have -40 armor while activating this skill.
	; Concise description
	; Preparation. (24 seconds.) Your arrows inflict Bleeding condition (3...13...15 seconds). You have -40 armor while activating this skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1723 - $GC_I_SKILL_ID_DISRUPTING_ACCURACY
Func CanUse_DisruptingAccuracy()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingAccuracy($a_f_AggroRange)
	; Description
	; Preparation. For 36 seconds, whenever your arrows critical, they also interrupt your target.
	; Concise description
	; Preparation. (36 seconds.) Interrupts an action whenever your arrows critical.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2068 - $GC_I_SKILL_ID_RAPID_FIRE
Func CanUse_RapidFire()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_RapidFire($a_f_AggroRange)
	; Description
	; Preparation. For 5...21...25 seconds, you attack 33% faster while wielding a bow.
	; Concise description
	; Preparation. (5...21...25 seconds.) You attack 33% faster while wielding a bow.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2145 - $GC_I_SKILL_ID_EXPERT_FOCUS
Func CanUse_ExpertFocus()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_ExpertFocus($a_f_AggroRange)
	; Description
	; Preparation. For 24 seconds, your bow attack skills cost 1...2...2 less Energy and deal 1...8...10 extra damage.
	; Concise description
	; Preparation. (24 seconds.) Your bow attack skills cost 1...2...2 less Energy and do +1...8...10 damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2969 - $GC_I_SKILL_ID_READ_THE_WIND_PvP
Func CanUse_ReadTheWindPvP()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_ReadTheWindPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3145 - $GC_I_SKILL_ID_GLASS_ARROWS_PvP
Func CanUse_GlassArrowsPvP()
	If Anti_Preparation() Then Return False
	Return True
EndFunc

Func BestTarget_GlassArrowsPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

