#include-once

Func Anti_Form()

EndFunc

; Skill ID: 1518 - $GC_I_SKILL_ID_AVATAR_OF_BALTHAZAR
Func CanUse_AvatarOfBalthazar()
	Return True
EndFunc

Func BestTarget_AvatarOfBalthazar($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, you gain +20 armor against physical damage, you gain adrenaline 25% faster, your attacks deal holy damage, and whenever you lose a Dervish enchantment, nearby foes are set on fire for 1...3...3 second[s]. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) You gain +20 armor against physical damage, you gain adrenaline 25% faster, your attacks deal holy damage, you inflict Burning (1...3...3 second[s]) on nearby foes whenever you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1519 - $GC_I_SKILL_ID_AVATAR_OF_DWAYNA
Func CanUse_AvatarOfDwayna()
	Return True
EndFunc

Func BestTarget_AvatarOfDwayna($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, your attacks deal holy damage. Whenever you use a Dervish attack skill, you lose 1 hex. Whenever you lose a Dervish enchantment, all allies in earshot are healed for 5...41...50 Health. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) You deal holy damage. Whenever you use a Dervish attack skill, you lose 1 hex. Heal allies in earshot for 5...41...50 Health when you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1520 - $GC_I_SKILL_ID_AVATAR_OF_GRENTH
Func CanUse_AvatarOfGrenth()
;~ 	If UAI_PlayerHasEffect($GC_I_SKILL_ID_AVATAR_OF_GRENTH) And UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_GRENTH, $GC_UAI_EFFECT_Duration) > 5000 Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_GRENTH, $GC_UAI_EFFECT_Duration) > 5000 Then Return False
	Return True
EndFunc

Func BestTarget_AvatarOfGrenth($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, your scythe attacks deal dark damage, and steal 0...10...12 Health. You are immune to Disease, and inflict Disease on all adjacent foes for 3 seconds whenever you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) Your scythe attacks deal dark damage and steal 0...10...12 Health. You are immune to Disease. Apply Disease to all adjacent foes (3 seconds) when you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1521 - $GC_I_SKILL_ID_AVATAR_OF_LYSSA
Func CanUse_AvatarOfLyssa()
	Return True
EndFunc

Func BestTarget_AvatarOfLyssa($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, your Dervish enchantments recharge 50% faster and your attacks deal chaos damage. Whenever you lose a Dervish enchantment, steal 1 Energy from all nearby foes. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) Your Dervish enchantments recharge 50% faster and deal chaos damage with attacks. Steal 1 Energy from nearby foes when you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1522 - $GC_I_SKILL_ID_AVATAR_OF_MELANDRU
Func CanUse_AvatarOfMelandru()
	Return True
EndFunc

Func BestTarget_AvatarOfMelandru($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, you have +150 Health, +30 elemental armor, and your attacks deal earth damage. Whenever you lose a Dervish enchantment, all party members in earshot lose 1 condition. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) You have +150 maximum Health, +30 elemental armor, and your attacks deal earth damage. Cure 1 condition from all party members in earshot whenever you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1902 - $GC_I_SKILL_ID_AVATAR_OF_GRENTH_SNOW_FIGHTING_SKILL
Func CanUse_AvatarOfGrenthSnowFightingSkill()
	Return True
EndFunc

Func BestTarget_AvatarOfGrenthSnowFightingSkill($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, your scythe attacks deal dark damage, and steal 0...10...12 Health. You are immune to Disease, and inflict Disease on all adjacent foes for 3 seconds whenever you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) Your scythe attacks deal dark damage and steal 0...10...12 Health. You are immune to Disease. Apply Disease to all adjacent foes (3 seconds) when you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1903 - $GC_I_SKILL_ID_AVATAR_OF_DWAYNA_SNOW_FIGHTING_SKILL
Func CanUse_AvatarOfDwaynaSnowFightingSkill()
	Return True
EndFunc

Func BestTarget_AvatarOfDwaynaSnowFightingSkill($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, your attacks deal holy damage. Whenever you use a Dervish attack skill, you lose 1 hex. Whenever you lose a Dervish enchantment, all allies in earshot are healed for 5...41...50 Health. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) You deal holy damage. Whenever you use a Dervish attack skill, you lose 1 hex. Heal allies in earshot for 5...41...50 Health when you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2374 - $GC_I_SKILL_ID_URSAN_BLESSING
Func CanUse_UrsanBlessing()
	Return True
EndFunc

Func BestTarget_UrsanBlessing($a_f_AggroRange)
	; Description
	; Elite Form. You lose all effects and take on the aspect of the bear. For 60 seconds, you have 100 armor and 750...790...800 Health. All your attributes are set to 0 and bear attacks replace your skills.
	; Concise description
	; Elite Form. You lose all effects and take on the aspect of the bear (60 seconds). All your attributes are set to 0 and bear attacks replace your skills, and you have 100 armor and 750...790...800 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2379 - $GC_I_SKILL_ID_VOLFEN_BLESSING
Func CanUse_VolfenBlessing()
	Return True
EndFunc

Func BestTarget_VolfenBlessing($a_f_AggroRange)
	; Description
	; Elite Form. You lose all effects and take on the aspect of the wolf. For 60 seconds, you have 80 armor, 660...700 Health, and 2...4 Health regeneration. All your attributes are set to 0 and wolf attacks replace your skills.
	; Concise description
	; Elite Form. You lose all effects and take on the aspect of the wolf (60 seconds). All your attributes are set to 0 and wolf attacks replace your skills, and you have 80 armor, 660...700 Health and 2...4 Health regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2384 - $GC_I_SKILL_ID_RAVEN_BLESSING
Func CanUse_RavenBlessing()
	Return True
EndFunc

Func BestTarget_RavenBlessing($a_f_AggroRange)
	; Description
	; Elite Form. You lose all effects and take on the aspect of the raven. For 60 seconds, you have 80 armor, 660...700 Health, and a 20...30% chance to block. All your attributes are set to 0 and raven attacks replace your skills.
	; Concise description
	; Elite Form. You lose all effects and take on the aspect of the Raven (60 seconds). All your attributes are set to 0 and raven attacks replace your skills, and you have 80 armor, 660...700 Health, and a 20...30% block chance.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2486 - $GC_I_SKILL_ID_ELEMENTAL_SHIFT
Func CanUse_ElementalShift()
	Return True
EndFunc

Func BestTarget_ElementalShift($a_f_AggroRange)
	; Description
	; Form. Creature becomes attuned to a different element.
	; Concise description
	; Form. Creature becomes attuned to a different element.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2494 - $GC_I_SKILL_ID_BEAR_FORM
Func CanUse_BearForm()
	Return True
EndFunc

Func BestTarget_BearForm($a_f_AggroRange)
	; Description
	; Form. For 60 seconds, you assume the form of a bear. While in this form, your Health is increased by 250 and your attacks strike for 25% more damage.
	; Concise description
	; Form. (60 seconds.) Assume the form of a bear. While in this form, you have +250 Health and deal 25% more damage with attacks.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2504 - $GC_I_SKILL_ID_SIEGE_DEVOURER
Func CanUse_SiegeDevourer()
	Return True
EndFunc

Func BestTarget_SiegeDevourer($a_f_AggroRange)
	; Description
	; Form. You have mounted a siege devourer. You can command the siege devourer to move and to use its skills.
	; Concise description
	; Form. Mount the siege devourer. You can command it to move and use skills.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2658 - $GC_I_SKILL_ID_HIDE
Func CanUse_Hide()
	Return True
EndFunc

Func BestTarget_Hide($a_f_AggroRange)
	; Description
	; Form. While you are hidden, enemies cannot see or target you for up to 60 seconds.
	; Concise description
	; Form. Conceal yourself (60 seconds). Enemies cannot see or target you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2659 - $GC_I_SKILL_ID_FEIGN_DEATH
Func CanUse_FeignDeath()
	Return True
EndFunc

Func BestTarget_FeignDeath($a_f_AggroRange)
	; Description
	; Form. Play dead, causing all enemies to cease attacking you. This skill ends when you move.
	; Concise description
	; Form. Play dead. All enemies cease attacking. Ends when you move.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2967 - $GC_I_SKILL_ID_AVATAR_OF_GRENTH_PvP
Func CanUse_AvatarOfGrenthPvP()
	Return True
EndFunc

Func BestTarget_AvatarOfGrenthPvP($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, your scythe attacks deal dark damage, and steal 0...10...12 Health. You are immune to Disease, and inflict Disease on all adjacent foes for 3 seconds whenever you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) Your scythe attacks deal dark damage and steal 0...10...12 Health. You are immune to Disease. Apply Disease to all adjacent foes (3 seconds) when you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3270 - $GC_I_SKILL_ID_AVATAR_OF_DWAYNA_PvP
Func CanUse_AvatarOfDwaynaPvP()
	Return True
EndFunc

Func BestTarget_AvatarOfDwaynaPvP($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, your attacks deal holy damage. Whenever you use a Dervish attack skill, you lose 1 hex. Whenever you lose a Dervish enchantment, all allies in earshot are healed for 5...41...50 Health. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) You deal holy damage. Whenever you use a Dervish attack skill, you lose 1 hex. Heal allies in earshot for 5...41...50 Health when you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3271 - $GC_I_SKILL_ID_AVATAR_OF_MELANDRU_PvP
Func CanUse_AvatarOfMelandruPvP()
	Return True
EndFunc

Func BestTarget_AvatarOfMelandruPvP($a_f_AggroRange)
	; Description
	; Elite Form. For 10...74...90 seconds, you have +150 Health, +30 elemental armor, and your attacks deal earth damage. Whenever you lose a Dervish enchantment, all party members in earshot lose 1 condition. This skill is disabled for 45 seconds.
	; Concise description
	; Elite Form. (10...74...90 seconds.) You have +150 maximum Health, +30 elemental armor, and your attacks deal earth damage. Cure 1 condition from all party members in earshot whenever you lose a Dervish enchantment. This skill is disabled for 45 seconds.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3376 - $GC_I_SKILL_ID_SHAPESHIFT
Func CanUse_Shapeshift()
	Return True
EndFunc

Func BestTarget_Shapeshift($a_f_AggroRange)
	; Description
	; Form. Change forms.
	; Concise description
	; Form. Change forms.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
