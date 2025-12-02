#include-once

Func Anti_Trap()

EndFunc

; Skill ID: 457 - $GC_I_SKILL_ID_DUST_TRAP
Func CanUse_DustTrap()
	Return True
EndFunc

Func BestTarget_DustTrap($a_f_AggroRange)
	; Description
	; Trap. When Dust Trap is triggered, every second (for 5 seconds total), all nearby foes are Blinded for 3...7...8 seconds and take 10...22...25 damage. While activating this skill, you are easily interrupted. Dust Trap ends after 90 seconds.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Deals 10...22...25 damage every second (5 seconds). Inflicts Blindness (3...7...8 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 458 - $GC_I_SKILL_ID_BARBED_TRAP
Func CanUse_BarbedTrap()
	Return True
EndFunc

Func BestTarget_BarbedTrap($a_f_AggroRange)
	; Description
	; Trap. When Barbed Trap is triggered, all nearby foes are struck for 7...20...23 piercing damage, become Crippled, and begin Bleeding for 3...21...25 seconds. Barbed Trap ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Deals 7...20...23 piercing damage. Inflicts Crippled and Bleeding (3...21...25 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 459 - $GC_I_SKILL_ID_FLAME_TRAP
Func CanUse_FlameTrap()
	Return True
EndFunc

Func BestTarget_FlameTrap($a_f_AggroRange)
	; Description
	; Trap. When Flame Trap is triggered, every second (for 3 seconds total), all nearby foes are struck for 5...17...20 fire damage and set on fire for 1...3...3 second[s]. Flame Trap ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Deals 5...17...20 fire damage every second (3 seconds). Inflicts Burning (1...3...3 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 460 - $GC_I_SKILL_ID_HEALING_SPRING
Func CanUse_HealingSpring()
	Return True
EndFunc

Func BestTarget_HealingSpring($a_f_AggroRange)
	; Description
	; Trap. For 10 seconds, all adjacent allies are healed for 15...51...60 every 2 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (10 seconds.) Affects adjacent allies. Heals for 15...51...60 every 2 seconds. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 461 - $GC_I_SKILL_ID_SPIKE_TRAP
Func CanUse_SpikeTrap()
	Return True
EndFunc

Func BestTarget_SpikeTrap($a_f_AggroRange)
	; Description
	; Elite Trap. When Spike Trap is triggered, every second (for 2 seconds), all nearby foes are struck for 10...34...40 piercing damage, become Crippled for 3...21...25 seconds, and are knocked down. Spike Trap ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Elite Trap. (90 seconds.) Affects nearby foes. Deals 10...34...40 piercing damage every second (2 seconds). Causes knockdown and inflicts Crippled (3...21...25 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 854 - $GC_I_SKILL_ID_SNARE
Func CanUse_Snare()
	Return True
EndFunc

Func BestTarget_Snare($a_f_AggroRange)
	; Description
	; Trap. When Snare is triggered, all nearby foes become Crippled for 3...13...15 seconds. Snare ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Inflicts Crippled (3...13...15 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1211 - $GC_I_SKILL_ID_VIPERS_NEST
Func CanUse_VipersNest()
	Return True
EndFunc

Func BestTarget_VipersNest($a_f_AggroRange)
	; Description
	; Trap. Create a Viper's Nest. When it is triggered, all nearby foes are struck for 5...29...35 piercing damage and become Poisoned for 5...17...20 seconds. Viper's Nest expires after 90 seconds. This Trap is easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Deals 5...29...35 piercing damage. Inflicts Poisoned (5...17...20 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1330 - $GC_I_SKILL_ID_TWISTED_SPIKES
Func CanUse_TwistedSpikes()
	Return True
EndFunc

Func BestTarget_TwistedSpikes($a_f_AggroRange)
	; Description
	; Trap. When Twisted Spikes is triggered, all nearby foes suffer from a Deep Wound and begin bleeding for 3...13...15 seconds. Twisted Spikes ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Inflicts Deep Wound and Bleeding (3...13...15 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1331 - $GC_I_SKILL_ID_MARBLE_TRAP
Func CanUse_MarbleTrap()
	Return True
EndFunc

Func BestTarget_MarbleTrap($a_f_AggroRange)
	; Description
	; Trap. When Marble Trap is triggered, all nearby foes are knocked down, and if they are holding an item, they are Dazed for 4...9...10 seconds. Marble Trap ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Causes knockdown. Inflicts Dazed (4...9...10 seconds) if holding item. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1332 - $GC_I_SKILL_ID_SHADOW_TRIPWIRE
Func CanUse_ShadowTripwire()
	Return True
EndFunc

Func BestTarget_ShadowTripwire($a_f_AggroRange)
	; Description
	; Trap. When Shadow Tripwire is triggered, all nearby foes become Crippled for 3...13...15 seconds, and you Shadow Step to that location. Shadow Tripwire ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Inflicts Crippled (3...13...15 seconds). You Shadow Step to trap location. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1476 - $GC_I_SKILL_ID_TRIPWIRE
Func CanUse_Tripwire()
	Return True
EndFunc

Func BestTarget_Tripwire($a_f_AggroRange)
	; Description
	; Trap. When Tripwire is triggered, all nearby foes are struck for 5...17...20 piercing damage. Any Crippled foes are knocked down. Tripwire ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Deals 5...17...20 piercing damage to nearby foes. Causes knockdown to Crippled foes. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1729 - $GC_I_SKILL_ID_SMOKE_TRAP
Func CanUse_SmokeTrap()
	Return True
EndFunc

Func BestTarget_SmokeTrap($a_f_AggroRange)
	; Description
	; Elite Trap. When Smoke Trap is triggered, nearby foes are Blinded and Dazed for 5...9...10 seconds. Smoke Trap ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Elite Trap. (90 seconds.) Inflicts Blinded and Dazed (5...9...10 seconds) to nearby foes. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2140 - $GC_I_SKILL_ID_PIERCING_TRAP
Func CanUse_PiercingTrap()
	Return True
EndFunc

Func BestTarget_PiercingTrap($a_f_AggroRange)
	; Description
	; Trap. When Piercing Trap is triggered, all nearby foes are struck for 5...41...50 piercing damage. Any foes with Cracked Armor are struck for an additional 15...51...60 damage. Piercing Trap ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Deals 5...41...50 piercing damage. Deals 15...51...60 more damage to foes with Cracked Armor. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2223 - $GC_I_SKILL_ID_BLACK_POWDER_MINE
Func CanUse_BlackPowderMine()
	Return True
EndFunc

Func BestTarget_BlackPowderMine($a_f_AggroRange)
	; Description
	; Trap. When Black Powder Mine is triggered, all nearby foes are struck for 20...30 damage, become Blinded, and begin Bleeding for 7...10 seconds. Black Powder Mine ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Deals 20...30 damage. Inflicts Blindness and Bleeding (7...10 seconds). Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2421 - $GC_I_SKILL_ID_WEAKNESS_TRAP
Func CanUse_WeaknessTrap()
	Return True
EndFunc

Func BestTarget_WeaknessTrap($a_f_AggroRange)
	; Description
	; Trap. When Weakness Trap is triggered, all nearby foes are Weakened for 10...20 seconds and take 24...50 lightning damage. All Charr are knocked down. Weakness Trap ends after 90 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. (90 seconds.) Affects nearby foes. Deals 24...50 lightning damage. Inflicts Weakness (10...20 seconds). Knocks down Charr. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2727 - $GC_I_SKILL_ID_SPRING_OF_PURITY
Func CanUse_SpringOfPurity()
	Return True
EndFunc

Func BestTarget_SpringOfPurity($a_f_AggroRange)
	; Description
	; Trap. Create a Spring of Purity at your location that lasts for 10 seconds. Every two seconds, Spring of Purity removes 1 hex from adjacent allies, and removes 1 enchantment from adjacent foes.
	; Concise description
	; Trap. (10 seconds.) Every 2 seconds removes 1 hex from adjacent allies and 1 enchantment from adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2834 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3293 - $GC_I_SKILL_ID_LAND_MINE
Func CanUse_LandMine()
	Return True
EndFunc

Func BestTarget_LandMine($a_f_AggroRange)
	; Description
	; Trap. When Land Mine is triggered, all nearby foes are struck for 500 damage and knocked down for 4 seconds. While activating this skill, you are easily interrupted.
	; Concise description
	; Trap. Affects nearby foes. Deals 500 damage. Knocks down for 4 seconds. Easily interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

