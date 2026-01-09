#include-once

Func Anti_Attack()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BLIND) Then Return True

	;~ Generic hex checks
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False

	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spirit_Shackles) Then Return True

	;~ Check for hexes that punish attacking
	Local $l_i_CommingDamage = 0

	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Ineptitude) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Ineptitude, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Clumsiness) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Clumsiness, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Wandering_Eye) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Wandering_Eye, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Wandering_Eye_PvP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Wandering_Eye_PvP, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spiteful_Spirit) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Spiteful_Spirit, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spoil_Victor) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Spoil_Victor, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Empathy) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Empathy, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Empathy_PvP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Empathy_PvP, "Scale")
	Return $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50)
EndFunc

; Skill ID: 320 - $GC_I_SKILL_ID_HAMSTRING
Func CanUse_Hamstring()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Hamstring($a_f_AggroRange)
	; Description
	; Sword Attack. If this attack hits, your target is Crippled for 3...13...15 seconds, slowing his movement.
	; Concise description
	; Sword Attack. Inflicts Crippled condition (3...13...15 seconds).
	Return 0
EndFunc

; Skill ID: 321 - $GC_I_SKILL_ID_WILD_BLOW
Func CanUse_WildBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildBlow($a_f_AggroRange)
	; Description
	; Melee Attack. Lose all adrenaline. If it hits, this attack will result in a critical hit and any stance being used by your target ends. This attack cannot be blocked.
	; Concise description
	; Melee Attack. Always a critical hit. Removes a stance. Unblockable. Lose all adrenaline.
	Return 0
EndFunc

; Skill ID: 322 - $GC_I_SKILL_ID_POWER_ATTACK
Func CanUse_PowerAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PowerAttack($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you strike for +10...34...40 damage.
	; Concise description
	; Melee Attack. Deals +10...34...40 damage.
	Return 0
EndFunc

; Skill ID: 323 - $GC_I_SKILL_ID_DESPERATION_BLOW
Func CanUse_DesperationBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DesperationBlow($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you strike for +10...34...40 damage, and your target suffers from one of the following conditions: Deep Wound (for 20 seconds), Weakness (for 20 seconds), Bleeding (for 25 seconds), or Crippled (for 15 seconds). After making a Desperation Blow, you are knocked down.
	; Concise description
	; Melee Attack. Deals +10...34...40 damage. Inflicts one of the following random conditions: Deep Wound (20 seconds), Weakness (20 seconds), Bleeding (25 seconds), or Crippled (15 seconds). You are knocked-down.
	Return 0
EndFunc

; Skill ID: 324 - $GC_I_SKILL_ID_THRILL_OF_VICTORY
Func CanUse_ThrillOfVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ThrillOfVictory($a_f_AggroRange)
	; Description
	; Melee Attack. If this blow hits, you deal +20...36...40 damage. If you have more Health than target foe, you gain 1...2...2 strike[s] of adrenaline.
	; Concise description
	; Melee Attack. Deals +20...36...40 damage. If you have more Health than your target, you gain 1...2...2 adrenaline.
	Return 0
EndFunc

; Skill ID: 325 - $GC_I_SKILL_ID_DISTRACTING_BLOW
Func CanUse_DistractingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DistractingBlow($a_f_AggroRange)
	; Description
	; This article is about the Core skill. For the temporarily available Bonus Mission Pack skill, see Distracting Blow (Turai Ossa).
	; Concise description
	; #808080;">Hits for no damage.
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
	; Description
	; Sword Attack. If Pure Strike hits, you strike for +1...24...30 damage. If you are not using a stance, Pure Strike cannot be blocked.
	; Concise description
	; Sword Attack. Deals +1...24...30 damage. Unblockable unless you are in a stance.
	Return 0
EndFunc

; Skill ID: 329 - $GC_I_SKILL_ID_SKULL_CRACK
Func CanUse_SkullCrack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SkullCrack($a_f_AggroRange)
	; Description
	; Elite Melee Attack. If it hits, this attack interrupts the target's current action. If that foe was casting a spell, that foe is Dazed for 10 seconds.
	; Concise description
	; Elite Melee Attack. Interrupts an action. Inflicts Dazed condition (10 seconds) if target is casting a spell.
	Return 0
EndFunc

; Skill ID: 330 - $GC_I_SKILL_ID_CYCLONE_AXE
Func CanUse_CycloneAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CycloneAxe($a_f_AggroRange)
	; Description
	; Axe Attack. Perform a spinning axe attack striking for +4...10...12 damage to all adjacent opponents.
	; Concise description
	; Axe Attack. Deals +4...10...12 damage to all foes adjacent to you.
	Return 0
EndFunc

; Skill ID: 331 - $GC_I_SKILL_ID_HAMMER_BASH
Func CanUse_HammerBash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HammerBash($a_f_AggroRange)
	; Description
	; Hammer Attack. Lose all adrenaline. If Hammer Bash hits, your target is knocked down.
	; Concise description
	; Hammer Attack. Causes knock-down. Lose all adrenaline.
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
	; Description
	; Axe Attack. If this attack hits a foe suffering from a Deep Wound, you strike for +1...8...10 damage, and that foe becomes Crippled for 15 seconds.
	; Concise description
	; Axe Attack. Deals +1...8...10 damage and inflicts Crippled condition (15 seconds) if target foe has a Deep Wound.
	Return 0
EndFunc

; Skill ID: 335 - $GC_I_SKILL_ID_CLEAVE
Func CanUse_Cleave()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Cleave($a_f_AggroRange)
	; Description
	; Elite Axe Attack. If this attack hits, you strike for +10...26...30 damage.
	; Concise description
	; Elite Axe Attack. Deals +10...26...30 damage.
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
	; Description
	; Axe Attack. If it hits, this axe blow will inflict a Deep Wound on the target foe, lowering that foe's maximum Health by 20% for 5...17...20 seconds.
	; Concise description
	; Axe Attack. Inflicts Deep Wound condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 338 - $GC_I_SKILL_ID_EVISCERATE
Func CanUse_Eviscerate()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Eviscerate($a_f_AggroRange)
	; Description
	; Elite Axe Attack. If Eviscerate hits, you strike for +1...25...31 damage and inflict a Deep Wound, lowering your target's maximum Health by 20% for 5...17...20 seconds.
	; Concise description
	; Elite Axe Attack. Deals +1...25...31 damage. Inflicts Deep Wound condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 339 - $GC_I_SKILL_ID_PENETRATING_BLOW
Func CanUse_PenetratingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingBlow($a_f_AggroRange)
	; Description
	; Axe Attack. If this attack hits, you strike for +5...17...20 damage. This axe attack has 20% armor penetration.
	; Concise description
	; Axe Attack. Deals +5...17...20 damage. 20% armor penetration.
	Return 0
EndFunc

; Skill ID: 340 - $GC_I_SKILL_ID_DISRUPTING_CHOP
Func CanUse_DisruptingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingChop($a_f_AggroRange)
	; Description
	; Axe Attack. If it hits, this attack interrupts the target's current action. If that action was a skill, that skill is disabled for an additional 20 seconds.
	; Concise description
	; Axe Attack. Interrupts an action. Interruption effect: interrupted skill is disabled for +20 seconds.
	Return 0
EndFunc

; Skill ID: 341 - $GC_I_SKILL_ID_SWIFT_CHOP
Func CanUse_SwiftChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SwiftChop($a_f_AggroRange)
	; Description
	; Axe Attack. If this attack hits, you strike for +1...16...20 damage. If Swift Chop is blocked, target foe takes 1...16...20 damage and suffers a Deep Wound for 20 seconds.
	; Concise description
	; Axe Attack. Deals +1...16...20 damage. Deals 1...16...20 damage and inflicts Deep Wound condition (20 seconds) if blocked.
	Return 0
EndFunc

; Skill ID: 342 - $GC_I_SKILL_ID_AXE_TWIST
Func CanUse_AxeTwist()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AxeTwist($a_f_AggroRange)
	; Description
	; Axe Attack. If this attack hits a foe suffering from a Deep Wound, you strike for 1...16...20 more damage and that foe suffers from Weakness for 20 seconds.
	; Concise description
	; Axe Attack. Deals +1...16...20 damage and inflicts Weakness condition (20 seconds) if target foe has a Deep Wound.
	Return 0
EndFunc

; Skill ID: 350 - $GC_I_SKILL_ID_BELLY_SMASH
Func CanUse_BellySmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BellySmash($a_f_AggroRange)
	; Description
	; Hammer Attack. If this attack strikes a foe who is knocked down, the resulting dust cloud will blind adjacent foes for 3...6...7 seconds.
	; Concise description
	; Hammer Attack. Inflicts Blindness condition to adjacent foes (3...6...7 seconds) if target foe is knocked down.
	Return 0
EndFunc

; Skill ID: 351 - $GC_I_SKILL_ID_MIGHTY_BLOW
Func CanUse_MightyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MightyBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. If this attack hits, you strike for +10...34...40 damage.
	; Concise description
	; Hammer Attack. Deals +10...34...40 damage.
	Return 0
EndFunc

; Skill ID: 352 - $GC_I_SKILL_ID_CRUSHING_BLOW
Func CanUse_CrushingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CrushingBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. If this attack hits, you strike for +1...16...20 damage. If you hit a knocked-down foe you inflict a Deep Wound, lowering your target's maximum Health by 20% for 5...17...20 seconds.
	; Concise description
	; Hammer Attack. Deals +1...16...20 damage. Inflicts Deep Wound condition if target foe is knocked-down (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 353 - $GC_I_SKILL_ID_CRUDE_SWING
Func CanUse_CrudeSwing()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CrudeSwing($a_f_AggroRange)
	; Description
	; Hammer Attack. Attack all adjacent foes. Each foe you hit is struck for +1...16...20 damage.
	; Concise description
	; Hammer Attack. Attack all adjacent foes for +1...16...20 damage.
	Return 0
EndFunc

; Skill ID: 354 - $GC_I_SKILL_ID_EARTH_SHAKER
Func CanUse_EarthShaker()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EarthShaker($a_f_AggroRange)
	; Description
	; Elite Hammer Attack. Target foe and all adjacent foes are knocked down. (50% failure chance with Hammer Mastery 4 or less.)
	; Concise description
	; Elite Hammer Attack. Knocks down target and adjacent foes. 50% failure chance unless Hammer Mastery is 5 or more.
	Return 0
EndFunc

; Skill ID: 355 - $GC_I_SKILL_ID_DEVASTATING_HAMMER
Func CanUse_DevastatingHammer()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DevastatingHammer($a_f_AggroRange)
	; Description
	; Elite Hammer Attack. If Devastating Hammer hits, your target is knocked down and suffers from Weakness for 5...17...20 seconds.
	; Concise description
	; Elite Hammer Attack. Causes knock-down. Inflicts Weakness condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 356 - $GC_I_SKILL_ID_IRRESISTIBLE_BLOW
Func CanUse_IrresistibleBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_IrresistibleBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. If this attack hits, you strike for +5...17...20 damage. If Irresistible Blow is blocked, your target is knocked down and takes 5...17...20 damage.
	; Concise description
	; Hammer Attack. Deals +5...17...20 damage. Deals 5...17...20 damage and causes knock-down if blocked.
	Return 0
EndFunc

; Skill ID: 357 - $GC_I_SKILL_ID_COUNTER_BLOW
Func CanUse_CounterBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CounterBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. If this attack hits an attacking foe, that foe is knocked down.
	; Concise description
	; Hammer Attack. Causes knock-down if target foe is attacking.
	Return 0
EndFunc

; Skill ID: 358 - $GC_I_SKILL_ID_BACKBREAKER
Func CanUse_Backbreaker()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Backbreaker($a_f_AggroRange)
	; Description
	; Elite Hammer Attack. If Backbreaker hits, you strike for +1...16...20 damage and your target is knocked down. If you have 8 Strength or higher, this knockdown lasts 4 seconds.
	; Concise description
	; Elite Hammer Attack. Deals +1...16...20 damage. Causes knockdown. Knockdown lasts 4 seconds with Strength 8 or higher.
	Return 0
EndFunc

; Skill ID: 359 - $GC_I_SKILL_ID_HEAVY_BLOW
Func CanUse_HeavyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HeavyBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. Lose all adrenaline. If this attack hits a foe suffering from Weakness, that foe is knocked down and you strike for +1...24...30 damage.
	; Concise description
	; Hammer Attack. Deals +1...24...30 damage and causes knock-down if target foe is Weakened. Lose all adrenaline.
	Return 0
EndFunc

; Skill ID: 360 - $GC_I_SKILL_ID_STAGGERING_BLOW
Func CanUse_StaggeringBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StaggeringBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. If this hammer blow hits, your target will suffer from Weakness for 5...17...20 seconds.
	; Concise description
	; Hammer Attack. Inflicts Weakness condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 382 - $GC_I_SKILL_ID_SEVER_ARTERY
Func CanUse_SeverArtery()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SeverArtery($a_f_AggroRange)
	; Description
	; Sword Attack. If this attack hits, the opponent begins Bleeding for 5...21...25 seconds, losing Health over time.
	; Concise description
	; Sword Attack. Inflicts Bleeding condition (5...21...25 seconds).
	Return 0
EndFunc

; Skill ID: 383 - $GC_I_SKILL_ID_GALRATH_SLASH
Func CanUse_GalrathSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GalrathSlash($a_f_AggroRange)
	; Description
	; Sword Attack. This attack strikes for +1...32...40 damage if it hits.
	; Concise description
	; Sword Attack. Deals +1...32...40 damage.
	Return 0
EndFunc

; Skill ID: 384 - $GC_I_SKILL_ID_GASH
Func CanUse_Gash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Gash($a_f_AggroRange)
	; Description
	; Sword Attack. If this attack hits a Bleeding foe, you strike for 5...17...20 more damage and that foe suffers a Deep Wound, lowering that foe's maximum Health by 20% for 5...17...20 seconds.
	; Concise description
	; Sword Attack. Deals +5...17...20 damage and inflicts Deep Wound condition (5...17...20 seconds) if your target is Bleeding.
	Return 0
EndFunc

; Skill ID: 385 - $GC_I_SKILL_ID_FINAL_THRUST
Func CanUse_FinalThrust()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FinalThrust($a_f_AggroRange)
	; Description
	; Sword Attack. Lose all adrenaline. If Final Thrust hits, you deal 1...32...40 more damage. This damage is doubled if your target was below 50% Health.
	; Concise description
	; Sword Attack. Deals +1...32...40 damage. Deals +1...32...40 more damage if target foe is below 50% Health. Lose all adrenaline.
	Return 0
EndFunc

; Skill ID: 386 - $GC_I_SKILL_ID_SEEKING_BLADE
Func CanUse_SeekingBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SeekingBlade($a_f_AggroRange)
	; Description
	; Sword Attack. If this attack hits you strike for +1...16...20 damage. If Seeking Blade is blocked, your target begins Bleeding for 25 seconds and takes 1...16...20 damage.
	; Concise description
	; Sword Attack. Deals +1...16...20 damage. Deals 1...16...20 damage and inflicts Bleeding condition (25 seconds) if blocked.
	Return 0
EndFunc

; Skill ID: 390 - $GC_I_SKILL_ID_SAVAGE_SLASH
Func CanUse_SavageSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SavageSlash($a_f_AggroRange)
	; Description
	; Sword Attack. If this attack hits, it interrupts target foe's action. If that action was a spell, you deal 1...32...40 extra damage.
	; Concise description
	; Sword Attack. Interrupts an action. Interruption effect: deals +1...32...40 damage if action was a spell.
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
	; Description
	; Bow Attack. If Pin Down hits, your target is Crippled for 3...13...15 seconds.
	; Concise description
	; Bow Attack. Inflicts Crippled condition (3...13...15 seconds).
	Return 0
EndFunc

; Skill ID: 393 - $GC_I_SKILL_ID_CRIPPLING_SHOT
Func CanUse_CripplingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingShot($a_f_AggroRange)
	; Description
	; Elite Bow Attack. If Crippling Shot hits, your target becomes Crippled for 1...9...11 second[s]. This attack cannot be blocked.
	; Concise description
	; Elite Bow Attack. Unblockable. Inflicts Crippled condition (1...9...11 second[s]).
	Return 0
EndFunc

; Skill ID: 394 - $GC_I_SKILL_ID_POWER_SHOT
Func CanUse_PowerShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PowerShot($a_f_AggroRange)
	; Description
	; Bow Attack. If Power Shot hits, target foe takes 25...45...50 damage.
	; Concise description
	; Bow Attack. Target foe takes 25...45...50 damage.
	Return 0
EndFunc

; Skill ID: 395 - $GC_I_SKILL_ID_BARRAGE
Func CanUse_Barrage()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Barrage($a_f_AggroRange)
	; Description
	; Elite Bow Attack. All your preparations are removed. Shoot arrows at target foe and up to 5 foes adjacent to your target. These arrows strike for +5...17...20 damage if they hit.
	; Concise description
	; Elite Bow Attack. Deals +5...17...20 damage. Hits 5 foes adjacent to your target. All your preparations are removed.
	Return 0
EndFunc

; Skill ID: 396 - $GC_I_SKILL_ID_DUAL_SHOT
Func CanUse_DualShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DualShot($a_f_AggroRange)
	; Description
	; Bow Attack. Shoot two arrows simultaneously at target foe. These arrows deal 25% less damage.
	; Concise description
	; Bow Attack. You shoot two arrows simultaneously at target foe. These arrows deal 25% less damage
	Return 0
EndFunc

; Skill ID: 397 - $GC_I_SKILL_ID_QUICK_SHOT
Func CanUse_QuickShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_QuickShot($a_f_AggroRange)
	; Description
	; Elite Bow Attack. Shoot an arrow that moves twice as fast.
	; Concise description
	; Elite Bow Attack. You shoot an arrow that moves twice as fast.
	Return 0
EndFunc

; Skill ID: 398 - $GC_I_SKILL_ID_PENETRATING_ATTACK
Func CanUse_PenetratingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingAttack($a_f_AggroRange)
	; Description
	; Bow Attack. If Penetrating Attack hits, you strike for +5...21...25 damage and this attack has 10% armor penetration.
	; Concise description
	; Bow Attack. Deals +5...21...25 damage. 10% armor penetration.
	Return 0
EndFunc

; Skill ID: 399 - $GC_I_SKILL_ID_DISTRACTING_SHOT
Func CanUse_DistractingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DistractingShot($a_f_AggroRange)
	; Description
	; Bow Attack. If Distracting Shot hits, it interrupts target foe's action but deals only 1...13...16 damage. If the interrupted action was a skill, that skill is disabled for an additional 20 seconds.
	; Concise description
	; Bow Attack. Interrupts an action. Interruption effect: interrupted skill is disabled for +20 seconds. Hits for only 1...13...16 damage.
	Return 0
EndFunc

; Skill ID: 400 - $GC_I_SKILL_ID_PRECISION_SHOT
Func CanUse_PrecisionShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PrecisionShot($a_f_AggroRange)
	; Description
	; Bow Attack. If Precision Shot hits, you strike for +3...9...10 damage. Precision Shot cannot be blocked. This action is easily interrupted.
	; Concise description
	; Bow Attack. Deals +3...9...10 damage. Unblockable. Easily Interrupted.
	Return 0
EndFunc

; Skill ID: 401 - $GC_I_SKILL_ID_SPLINTER_SHOT_MONSTER_SKILL
; Skill ID: 402 - $GC_I_SKILL_ID_DETERMINED_SHOT
Func CanUse_DeterminedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeterminedShot($a_f_AggroRange)
	; Description
	; Bow Attack. If Determined Shot hits, you strike for +5...17...20 damage. If Determined Shot fails to hit, all of your attack skills are recharged.
	; Concise description
	; Bow Attack. Deals +5...17...20 damage. Recharges your attack skills if it fails to hit.
	Return 0
EndFunc

; Skill ID: 403 - $GC_I_SKILL_ID_CALLED_SHOT
Func CanUse_CalledShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CalledShot($a_f_AggroRange)
	; Description
	; Bow Attack. Shoot an arrow that moves 3 times faster and cannot be blocked.
	; Concise description
	; Bow Attack. You shoot an arrow that moves 3 times faster. Unblockable.
	Return 0
EndFunc

; Skill ID: 404 - $GC_I_SKILL_ID_POISON_ARROW
Func CanUse_PoisonArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PoisonArrow($a_f_AggroRange)
	; Description
	; This article is about the Ranger skill. For the monster skill, see Poison Arrow (flower).
	; Concise description
	; green; font-weight: bold;">5...17...20
	Return 0
EndFunc

; Skill ID: 405 - $GC_I_SKILL_ID_OATH_SHOT
Func CanUse_OathShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_OathShot($a_f_AggroRange)
	; Description
	; Elite Bow Attack. If Oath Shot hits, all of your skills except Oath Shot are recharged. If it misses, all of your skills are disabled for 10...5...4 seconds. (50% miss chance with Expertise 7 or less.)
	; Concise description
	; Elite Bow Attack. Recharges all skills except Oath Shot if it hits. Disables all skills if it misses (10...5...4 seconds). 50% miss chance unless Expertise 8 or higher.
	Return 0
EndFunc

; Skill ID: 406 - $GC_I_SKILL_ID_DEBILITATING_SHOT
Func CanUse_DebilitatingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DebilitatingShot($a_f_AggroRange)
	; Description
	; Bow Attack. If Debilitating Shot hits, your target loses 1...8...10 Energy.
	; Concise description
	; Bow Attack. Causes 1...8...10 Energy loss.
	Return 0
EndFunc

; Skill ID: 407 - $GC_I_SKILL_ID_POINT_BLANK_SHOT
Func CanUse_PointBlankShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PointBlankShot($a_f_AggroRange)
	; Description
	; Bow Attack. Shoot an arrow that has half the normal range, but strikes for +10...34...40 damage.
	; Concise description
	; Half Range Bow Attack. Deals +10...34...40 damage.
	Return 0
EndFunc

; Skill ID: 408 - $GC_I_SKILL_ID_CONCUSSION_SHOT
Func CanUse_ConcussionShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ConcussionShot($a_f_AggroRange)
	; Description
	; Bow Attack. If Concussion Shot hits while target foe is casting a spell, the spell is interrupted and your target is Dazed for 5...17...20 seconds. This attack deals only 1...13...16 damage.
	; Concise description
	; Bow Attack. Interrupts a spell. Interruption effect: inflicts Dazed condition (5...17...20 seconds). Hits for only 1...13...16 damage.
	Return 0
EndFunc

; Skill ID: 409 - $GC_I_SKILL_ID_PUNISHING_SHOT
Func CanUse_PunishingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PunishingShot($a_f_AggroRange)
	; Description
	; Elite Bow Attack. If Punishing Shot hits, you strike for +10...18...20 damage and your target is interrupted.
	; Concise description
	; Elite Bow Attack. Deals +10...18...20 damage. Interrupts an action.
	Return 0
EndFunc

; Skill ID: 426 - $GC_I_SKILL_ID_SAVAGE_SHOT
Func CanUse_SavageShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SavageShot($a_f_AggroRange)
	; Description
	; Bow Attack. If Savage Shot hits, your target's action is interrupted. If that action was a spell, you strike for +13...25...28 damage.
	; Concise description
	; Bow Attack. Interrupts an action. Interruption effect: deals +13...25...28 damage if action was a spell.
	Return 0
EndFunc

; Skill ID: 428 - $GC_I_SKILL_ID_INCENDIARY_ARROWS
Func CanUse_IncendiaryArrows()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_IncendiaryArrows($a_f_AggroRange)
	; Description
	; Elite Bow Attack. Shoot arrows at target foe and up to 2 foes near your target. Those foes are set on fire for 1...3...3 second[s].
	; Concise description
	; Elite Bow Attack. Hits 2 foes near your target and inflicts burning (1...3...3 second[s]).
	Return 0
EndFunc

; Skill ID: 501 - $GC_I_SKILL_ID_SIEGE_ATTACK4
Func CanUse_SiegeAttack4()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 511 - $GC_I_SKILL_ID_BRUTAL_MAULING
Func CanUse_BrutalMauling()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrutalMauling($a_f_AggroRange)
	; Description
	; Attack. Brutal Mauling
	; Concise description
	; Attack. Brutal Mauling
	Return 0
EndFunc

; Skill ID: 512 - $GC_I_SKILL_ID_CRIPPLING_ATTACK
Func CanUse_CripplingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingAttack($a_f_AggroRange)
	; Description
	; Attack. (monster only)
	; Concise description
	; Attack. (monster only)
	Return 0
EndFunc

; Skill ID: 524 - $GC_I_SKILL_ID_DOZEN_SHOT
Func CanUse_DozenShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DozenShot($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return 0
EndFunc

; Skill ID: 530 - $GC_I_SKILL_ID_GIANT_STOMP
Func CanUse_GiantStomp()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GiantStomp($a_f_AggroRange)
	; Description
	; This article is about the Monster skill. For the temporarily available Bonus Mission Pack skill, see Giant Stomp (Turai Ossa).
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 531 - $GC_I_SKILL_ID_AGNARS_RAGE
Func CanUse_AgnarsRage()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AgnarsRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 539 - $GC_I_SKILL_ID_HUNGER_OF_THE_LICH
Func CanUse_HungerOfTheLich()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HungerOfTheLich($a_f_AggroRange)
	; Description
	; Attack. (monster only) If this attack hits target foe it removes one enchantment. If an enchantment is removed you gain 100 Health and 5 Energy.
	; Concise description
	; Attack. (monster only) Removes one enchantment. Removal effect: you gain 100 Health and 5 Energy.
	Return 0
EndFunc

; Skill ID: 577 - $GC_I_SKILL_ID_SIEGE_ATTACK1
Func CanUse_SiegeAttack1()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 578 - $GC_I_SKILL_ID_SIEGE_ATTACK2
Func CanUse_SiegeAttack2()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 775 - $GC_I_SKILL_ID_DEATH_BLOSSOM
Func CanUse_DeathBlossom()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeathBlossom($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow an off-hand attack. If it hits, Death Blossom strikes target foe for +20...40...45 damage and all adjacent foes take 20...40...45 damage.
	; Concise description
	; Dual Attack. Deals +20...40...45 damage. Also affects foes adjacent to target foe. Must follow an off-hand attack.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc

; Skill ID: 776 - $GC_I_SKILL_ID_TWISTING_FANGS
Func CanUse_TwistingFangs()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TwistingFangs($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow an off-hand attack. If it hits, Twisting Fangs strikes for +10...18...20 damage and struck foe suffers from Bleeding and Deep Wound for 5...17...20 seconds.
	; Concise description
	; Dual Attack. Deals +10...18...20 damage. Inflicts Bleeding and Deep Wound conditions (5...17...20 seconds). Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 777 - $GC_I_SKILL_ID_HORNS_OF_THE_OX
Func CanUse_HornsOfTheOx()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HornsOfTheOx($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow an off-hand attack. If it hits, Horns of the Ox strikes for +1...9...11 damage. If struck foe is not adjacent to any allies, that foe is knocked down.
	; Concise description
	; Dual Attack. Deals +1...9...11 damage. Causes knock-down if the target foe is not adjacent to any of its allies. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 778 - $GC_I_SKILL_ID_FALLING_SPIDER
Func CanUse_FallingSpider()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FallingSpider($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must strike a knocked-down foe. If it hits, Falling Spider strikes for +15...31...35 damage and target foe is Poisoned for 5...17...20 seconds.
	; Concise description
	; Off-Hand Attack. Deals +15...31...35 damage. Inflicts Poisoned condition (5...17...20 seconds). No effect unless target foe is knocked-down.
	Return 0
EndFunc

; Skill ID: 779 - $GC_I_SKILL_ID_BLACK_LOTUS_STRIKE
Func CanUse_BlackLotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlackLotusStrike($a_f_AggroRange)
	; Description
	; Lead Attack. If it hits, Black Lotus Strike strikes for +10...27...31 damage. If target foe is suffering from a Hex, you gain 5...11...13 Energy.
	; Concise description
	; Lead Attack. Deals +10...27...31 damage. You gain 5...11...13 Energy if target foe is hexed.
	Return 0
EndFunc

; Skill ID: 780 - $GC_I_SKILL_ID_FOX_FANGS
Func CanUse_FoxFangs()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FoxFangs($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must follow a lead attack. Fox Fangs cannot be blocked and strikes for +10...30...35 damage if it hits.
	; Concise description
	; Off-Hand Attack. Deals +10...30...35 damage. Unblockable. Must follow a lead attack.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc

; Skill ID: 781 - $GC_I_SKILL_ID_MOEBIUS_STRIKE
Func CanUse_MoebiusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MoebiusStrike($a_f_AggroRange)
	; Description
	; Elite Off-Hand Attack. Must follow a Dual Attack. If it hits, Moebius Strike strikes for +10...30...35 damage. If you strike a foe whose Health is below 50%, all your other attack skills are recharged.
	; Concise description
	; Elite Off-Hand Attack. Deals +10...30...35 damage. Recharges all your other attack skills if target foe's Health is below 50%. Must follow a dual attack.
	Return 0
EndFunc

; Skill ID: 782 - $GC_I_SKILL_ID_JAGGED_STRIKE
Func CanUse_JaggedStrike()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc

Func BestTarget_JaggedStrike($a_f_AggroRange)
	; Description
	; Lead Attack. If Jagged Strike hits, your target suffers from Bleeding for 5...17...20 seconds.
	; Concise description
	; Lead Attack. Inflicts Bleeding condition (5...17...20 seconds).
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 783 - $GC_I_SKILL_ID_UNSUSPECTING_STRIKE
Func CanUse_UnsuspectingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_UnsuspectingStrike($a_f_AggroRange)
	; Description
	; Lead Attack. If this attack hits, you strike for +19...29...31 damage. If your target was above 90% Health you deal an additional 15...63...75 damage.
	; Concise description
	; Lead Attack. Deals +19...29...31 damage. Deals 15...63...75 more damage if target foe's Health is above 90%.
	Return 0
EndFunc

; Skill ID: 849 - $GC_I_SKILL_ID_LACERATING_CHOP
Func CanUse_LaceratingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LaceratingChop($a_f_AggroRange)
	; Description
	; Axe Attack. If Lacerating Chop hits, you deal +5...17...20 damage. If it strikes a knocked down foe your target suffers from Bleeding for 5...17...20 seconds.
	; Concise description
	; Axe Attack. Deals +5...17...20 damage. Inflicts Bleeding condition (5...17...20 seconds) if target foe is knocked-down.
	Return 0
EndFunc

; Skill ID: 850 - $GC_I_SKILL_ID_FIERCE_BLOW
Func CanUse_FierceBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FierceBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. If Fierce Blow hits, you strike for +5...17...20 damage. If target foe was  suffering from Weakness, that foe also suffers from a Deep Wound for 1...7...8 second[s].
	; Concise description
	; Hammer Attack. Deals +5...17...20 damage. Inflicts Deep Wound (1...7...8 second[s]) if target foe is Weakened.
	Return 0
EndFunc

; Skill ID: 851 - $GC_I_SKILL_ID_SUN_AND_MOON_SLASH
Func CanUse_SunAndMoonSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SunAndMoonSlash($a_f_AggroRange)
	; Description
	; Sword Attack. Attack target foe twice. These attacks cannot be blocked.
	; Concise description
	; Sword Attack. You attack target foe twice. Unblockable.
	Return 0
EndFunc

; Skill ID: 852 - $GC_I_SKILL_ID_SPLINTER_SHOT
Func CanUse_SplinterShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SplinterShot($a_f_AggroRange)
	; Description
	; This article is about the player version of Splinter Shot. For the old version used by various monsters in EotN, see Splinter Shot (monster skill).
	; Concise description
	; green; font-weight: bold;">3...13...15
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
	; Description
	; This article is about the skill used by Flame Djinn.&#32;&#32;For the skill used by Arctic Nightmares during Flames of the Bear Spirit, see Consume Flames.
	; Concise description
	; Notes">edit
	Return 0
EndFunc

; Skill ID: 888 - $GC_I_SKILL_ID_WHIRLING_AXE
Func CanUse_WhirlingAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WhirlingAxe($a_f_AggroRange)
	; Description
	; Elite Axe Attack. If Whirling Axe hits, you strike for +5...17...20 damage and any stance being used by your target ends. This attack cannot be blocked.
	; Concise description
	; Elite Axe Attack. Deals +5...17...20 damage and removes a stance. Unblockable.
	Return 0
EndFunc

; Skill ID: 889 - $GC_I_SKILL_ID_FORCEFUL_BLOW
Func CanUse_ForcefulBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ForcefulBlow($a_f_AggroRange)
	; Description
	; Elite Hammer Attack. If Forceful Blow hits, you strike for +10...26...30 damage and any stance being used by target foe ends. Target foe suffers from Weakness for 5...17...20 seconds. This attack cannot be blocked.
	; Concise description
	; Elite Hammer Attack. Deals +10...26...30 damage. Remove target foe's stance. Inflicts Weakness condition (5...17...20 seconds). Unblockable.
	Return 0
EndFunc

; Skill ID: 892 - $GC_I_SKILL_ID_QUIVERING_BLADE
Func CanUse_QuiveringBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_QuiveringBlade($a_f_AggroRange)
	; Description
	; This article is about the skill. For weapon with the same name, see Quivering Blade (weapon).
	; Concise description
	; green; font-weight: bold;">10...34...40
	Return 0
EndFunc

; Skill ID: 904 - $GC_I_SKILL_ID_FURIOUS_AXE
Func CanUse_FuriousAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FuriousAxe($a_f_AggroRange)
	; Description
	; Axe Attack. If Furious Axe hits, you strike for +5...29...35 damage. If it is blocked you gain 3 strikes worth of adrenaline.
	; Concise description
	; Axe Attack. Deals +5...29...35 damage. Gives you 3 strikes of adrenaline if blocked.
	Return 0
EndFunc

; Skill ID: 905 - $GC_I_SKILL_ID_AUSPICIOUS_BLOW
Func CanUse_AuspiciousBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AuspiciousBlow($a_f_AggroRange)
	; Description
	; Hammer Attack. If Auspicious Blow hits, you strike for +5...17...20 damage and gain 3...7...8 Energy. If target foe is suffering from Weakness, this attack is unblockable.
	; Concise description
	; Hammer Attack. Deals +5...17...20 damage and you gain 3...7...8 Energy. Unblockable if target foe is Weakened.
	Return 0
EndFunc

; Skill ID: 907 - $GC_I_SKILL_ID_DRAGON_SLASH
Func CanUse_DragonSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DragonSlash($a_f_AggroRange)
	; Description
	; This article is about the Factions skill. For the temporarily available Bonus Mission Pack skill, see Dragon Slash (Turai Ossa).
	; Concise description
	; green; font-weight: bold;">10...34...40
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
	; Description
	; Bow Attack. If Focused Shot hits, you strike for +10...22...25 damage but all of your other attack skills are disabled for 5...3...3 seconds.
	; Concise description
	; Bow Attack. Deals +10...22...25 damage. Your other attack skills are disabled (5...3...3 seconds) if this attack hits.
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
	; Description
	; Lead Attack. If you have less than 50...74...80% Health, you deal +15...51...60 damage.
	; Concise description
	; Lead Attack. Deals +15...51...60 damage if you have less than 50...74...80% Health.
	Return 0
EndFunc

; Skill ID: 975 - $GC_I_SKILL_ID_EXHAUSTING_ASSAULT
Func CanUse_ExhaustingAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ExhaustingAssault($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow a lead attack. Target foe's action is interrupted. If that action was casting a spell, target foe suffers 10 Overcast.
	; Concise description
	; Dual Attack. Interrupts an action. Inflicts 10 Overcast if the interrupted action was a spell. Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 976 - $GC_I_SKILL_ID_REPEATING_STRIKE
Func CanUse_RepeatingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RepeatingStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must follow an off-hand attack. If it hits, this attack strikes for +10...26...30 damage. If it misses, it takes an additional 15 seconds to recharge.
	; Concise description
	; Off-Hand Attack. Deals +10...26...30 damage. This skill has +15 second recharge time if it misses. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 986 - $GC_I_SKILL_ID_NINE_TAIL_STRIKE
Func CanUse_NineTailStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_NineTailStrike($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow an off-hand attack. Nine Tail Strike cannot be blocked and strikes for +15...35...40 damage if it hits.
	; Concise description
	; Dual Attack. Deals +15...35...40 damage. Unblockable. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 988 - $GC_I_SKILL_ID_TEMPLE_STRIKE
Func CanUse_TempleStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TempleStrike($a_f_AggroRange)
	; Description
	; Elite Off-Hand Attack. Must follow a lead attack. If this attack hits, target foe is Dazed and Blinded for 1...8...10 seconds, and if target foe is casting a spell, that foe is interrupted.
	; Concise description
	; Elite Off-Hand Attack. Interrupts a spell. Inflicts Dazed and Blindness conditions (1...8...10 seconds). Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 989 - $GC_I_SKILL_ID_GOLDEN_PHOENIX_STRIKE
Func CanUse_GoldenPhoenixStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenPhoenixStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. If you are not under the effects of an enchantment, this skill misses. If it hits, Golden Phoenix Strike deals +10...26...30 damage and all adjacent foes take 10...26...30 damage.
	; Concise description
	; Off-Hand Attack. Deals +10...26...30 damage to target and deals 10...26...30 damage to adjacent foes. Fails if you are not enchanted.
	Return 0
EndFunc

; Skill ID: 992 - $GC_I_SKILL_ID_TRIPLE_CHOP
Func CanUse_TripleChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TripleChop($a_f_AggroRange)
	; Description
	; Elite Axe Attack. Attack target foe and adjacent foes. Each attack that hits deals +10...34...40 damage.
	; Concise description
	; Elite Axe Attack. Deals +10...34...40 damage. Also hits adjacent foes.
	Return 0
EndFunc

; Skill ID: 993 - $GC_I_SKILL_ID_ENRAGED_SMASH
Func CanUse_EnragedSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EnragedSmash($a_f_AggroRange)
	; Description
	; Elite Hammer Attack. If Enraged Smash hits, you gain 1...3...4 strike[s] of adrenaline. If you hit a moving foe, you strike for +10...34...40 damage, and target foe is knocked down.
	; Concise description
	; Elite Hammer Attack. Gives you 1...3...4 strike[s] of adrenaline if you hit. Deals +10...34...40 damage and causes knockdown if target foe was moving.
	Return 0
EndFunc

; Skill ID: 994 - $GC_I_SKILL_ID_RENEWING_SMASH
Func CanUse_RenewingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RenewingSmash($a_f_AggroRange)
	; Description
	; Hammer Attack. If Renewing Smash hits, it deals +10...34...40 damage. If you hit a knocked-down foe, you gain 3 Energy and this attack recharges instantly.
	; Concise description
	; Hammer Attack. Deals +10...34...40 damage. You gain 3 Energy and this attack recharges instantly if target foe was knocked down.
	Return 0
EndFunc

; Skill ID: 996 - $GC_I_SKILL_ID_STANDING_SLASH
Func CanUse_StandingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StandingSlash($a_f_AggroRange)
	; Description
	; Sword Attack. If it hits, Standing Slash deals +5...17...20 damage plus an additional 5...17...20 damage if you are in a stance.
	; Concise description
	; Sword Attack. Deals +5...17...20 damage. Deals 5...17...20 more damage if you are in a stance.
	Return 0
EndFunc

; Skill ID: 1019 - $GC_I_SKILL_ID_CRITICAL_STRIKE
Func CanUse_CriticalStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CriticalStrike($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow an off-hand attack. If it hits, this attack strikes for +10...26...30 damage, results in a critical hit, and you gain 1...3...3 Energy.
	; Concise description
	; Dual Attack. Deals +10...26...30 damage. Automatic critical hit. You gain 1...3...3 Energy. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 1020 - $GC_I_SKILL_ID_BLADES_OF_STEEL
Func CanUse_BladesOfSteel()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BladesOfSteel($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow an off-hand attack. If it hits, this attack strikes for +5...14...16 damage (maximum bonus 60) for each recharging dagger attack.
	; Concise description
	; Dual Attack. Deals +5...14...16 damage (maximum 60) for each recharging dagger attack. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 1021 - $GC_I_SKILL_ID_JUNGLE_STRIKE
Func CanUse_JungleStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_JungleStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must follow a lead attack. If it hits, this attack strikes for +10...22...25 damage. If it hits a foe that was Crippled, that foe and all adjacent foes take +1...25...31 damage.
	; Concise description
	; Off-Hand Attack. Deals +10...22...25 damage. Deals +1...25...31 damage to target and adjacent foes if target foe is Crippled. Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 1022 - $GC_I_SKILL_ID_WILD_STRIKE
Func CanUse_WildStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must follow a lead attack. If it hits, this attack strikes for +10...30...35 damage and any stance being used by target foe ends. This attack cannot be blocked.
	; Concise description
	; Off-Hand Attack. Deals +10...30...35 damage. Removes target foe's stance. Unblockable. Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 1023 - $GC_I_SKILL_ID_LEAPING_MANTIS_STING
Func CanUse_LeapingMantisSting()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LeapingMantisSting($a_f_AggroRange)
	; Description
	; Lead Attack. If Mantis Sting hits, target foe takes +5...13...15 damage. If this attack strikes a moving foe, that foe is Crippled for 3...13...15 seconds.
	; Concise description
	; Lead Attack. Deals +5...13...15 damage. Inflicts Crippled condition (3...13...15 seconds) if target foe is moving.
	Return 0
EndFunc

; Skill ID: 1024 - $GC_I_SKILL_ID_BLACK_MANTIS_THRUST
Func CanUse_BlackMantisThrust()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlackMantisThrust($a_f_AggroRange)
	; Description
	; Lead Attack. If this attack hits, you strike for +8...18...20 damage. If target foe is suffering from a Hex, that foe is Crippled for 3...13...15 seconds.
	; Concise description
	; Lead Attack. Deals +8...18...20 damage. Inflicts Crippled condition (3...13...15 seconds) if target foe is hexed.
	Return 0
EndFunc

; Skill ID: 1025 - $GC_I_SKILL_ID_DISRUPTING_STAB
Func CanUse_DisruptingStab()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingStab($a_f_AggroRange)
	; Description
	; Lead Attack. If this attack hits, it interrupts target foe's action. If that action was a spell, it is disabled for 3...9...10 seconds.
	; Concise description
	; Lead Attack. Interrupts an action. If the interrupted action was a spell, it is disabled (3...9...10 seconds).
	Return 0
EndFunc

; Skill ID: 1026 - $GC_I_SKILL_ID_GOLDEN_LOTUS_STRIKE
Func CanUse_GoldenLotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenLotusStrike($a_f_AggroRange)
	; Description
	; Lead Attack. If it hits, this attack strikes for +5...17...20 damage. If you are under the effects of an Enchantment, you gain 5...7...8 Energy.
	; Concise description
	; Lead Attack. Deals +5...17...20 damage. You gain 5...7...8 Energy if you are enchanted.
	Return 0
EndFunc

; Skill ID: 1133 - $GC_I_SKILL_ID_DRUNKEN_BLOW
Func CanUse_DrunkenBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DrunkenBlow($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you strike for +10...34...40 damage and your target suffers from one of the following conditions: Deep Wound (for 20 seconds), Weakness (for 20 seconds), Bleeding (for 25 seconds), or Crippled (for 15 seconds). After making a Drunken Blow, you are knocked down.
	; Concise description
	; Melee Attack. Deals +10...34...40 damage. Inflicts one of the following random conditions: Deep Wound (20 seconds), Weakness (20 seconds), Bleeding (25 seconds), or Crippled (15 seconds). You are knocked-down.
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
	; Description
	; Sword Attack. If Jaizhenju Strike hits, you strike for +1...24...30 damage. If you are not using a stance, Jaizhenju Strike cannot be blocked.
	; Concise description
	; Sword Attack. Deals +1...24...30 damage. Unblockable unless you are in a stance.
	Return 0
EndFunc

; Skill ID: 1136 - $GC_I_SKILL_ID_PENETRATING_CHOP
Func CanUse_PenetratingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingChop($a_f_AggroRange)
	; Description
	; Axe Attack. If this attack hits, you strike for +5...17...20 damage. This axe attack has 20% armor penetration.
	; Concise description
	; Axe Attack. Deals +5...17...20 damage. 20% armor penetration.
	Return 0
EndFunc

; Skill ID: 1137 - $GC_I_SKILL_ID_YETI_SMASH
Func CanUse_YetiSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_YetiSmash($a_f_AggroRange)
	; Description
	; Hammer Attack. Lose all adrenaline. Attack all adjacent foes. If this attack strikes a foe suffering from a condition, that foe is knocked down. (50% failure chance with Hammer Mastery 4 or less.)
	; Concise description
	; Hammer Attack. Attack all adjacent foes. Knocks down foes suffering from a condition. You lose all adrenaline. 50% failure chance unless Hammer Mastery is 5 or more.
	Return 0
EndFunc

; Skill ID: 1144 - $GC_I_SKILL_ID_SILVERWING_SLASH
Func CanUse_SilverwingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SilverwingSlash($a_f_AggroRange)
	; Description
	; Sword Attack. This attack strikes for +1...32...40 damage if it hits.
	; Concise description
	; Sword Attack. Deals +1...32...40 damage.
	Return 0
EndFunc

; Skill ID: 1179 - $GC_I_SKILL_ID_DARK_CHAIN_LIGHTNING
Func CanUse_DarkChainLightning()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DarkChainLightning($a_f_AggroRange)
	; Description
	; Attack. Target foe is struck for 300 lightning damage and is knocked down. Dark Chain Lightning then hits each nearest foe in succession, knocking down each foe and striking for 10% less damage each time.
	; Concise description
	; Attack. Deals 300 lightning damage and causes knock-down. Dark Chain Lightning then hits each nearest foe in succession, knocking-down each foe and doing 10% less damage each time.
	Return 0
EndFunc

; Skill ID: 1191 - $GC_I_SKILL_ID_SUNDERING_ATTACK
Func CanUse_SunderingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SunderingAttack($a_f_AggroRange)
	; Description
	; Bow Attack. If Sundering Attack hits, you strike for +5...21...25 damage and this attack has 10% armor penetration.
	; Concise description
	; Bow Attack. Deals +5...21...25 damage. 10% armor penetration.
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
	; Description
	; Bow Attack. Needling Shot strikes for only 10...26...30 damage and moves faster than normal. If Needling Shot strikes a foe below 50% Health, Needling Shot recharges instantly. Your other attack skills are disabled for 2 seconds.
	; Concise description
	; Bow Attack. Fast-moving arrow. Deals 10...26...30 damage. Recharges instantly if target foe is below 50% Health. Your other attack skills are disabled (2 seconds).
	Return 0
EndFunc

; Skill ID: 1198 - $GC_I_SKILL_ID_BROAD_HEAD_ARROW
Func CanUse_BroadHeadArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BroadHeadArrow($a_f_AggroRange)
	; Description
	; Elite Bow Attack. You shoot a broad head arrow that moves slower than normal. If it hits, target foe is Dazed for 5...17...20 seconds, and if target foe is casting a spell that spell is interrupted.
	; Concise description
	; Elite Bow Attack. Slow moving arrow. Interrupts a spell. Inflicts Dazed condition (5...17...20 seconds).
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
	; Description
	; Attack. The next time you land a physical attack, you sacrifice all of your Health and target foe loses all Energy.
	; Concise description
	; Attack. The next time you land a physical attack, you sacrifice all of your Health and target foe loses all Energy.
	Return 0
EndFunc

; Skill ID: 1310 - $GC_I_SKILL_ID_SUICIDE_HEALTH
Func CanUse_SuicideHealth()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SuicideHealth($a_f_AggroRange)
	; Description
	; Attack. The next time you land a physical attack, you sacrifice all of your Health and target foe loses all Health.
	; Concise description
	; Attack. The next time you land a physical attack, you sacrifice all of your Health and target foe loses all Health.
	Return 0
EndFunc

; Skill ID: 1319 - ;  $GC_I_SKILL_ID_FINAL_THRUST
; Skill ID: 1385 - $GC_I_SKILL_ID_SIEGE_ATTACK3
Func CanUse_SiegeAttack3()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttack3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1402 - $GC_I_SKILL_ID_CRITICAL_CHOP
Func CanUse_CriticalChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CriticalChop($a_f_AggroRange)
	; Description
	; Axe Attack. If this attack hits, you inflict +5...17...20 damage. If this attack results in a critical hit, target foe is interrupted.
	; Concise description
	; Axe Attack. Deals +5...17...20 damage. Interrupts an action if you land a critical hit.
	Return 0
EndFunc

; Skill ID: 1403 - $GC_I_SKILL_ID_AGONIZING_CHOP
Func CanUse_AgonizingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AgonizingChop($a_f_AggroRange)
	; Description
	; Axe Attack. When this attack hits, you deal +5...17...20 damage. If target foe is suffering from a Deep Wound, you interrupt that foe's action.
	; Concise description
	; Axe Attack. Deals +5...17...20 damage. Interrupts an action if target foe has a Deep Wound.
	Return 0
EndFunc

; Skill ID: 1409 - $GC_I_SKILL_ID_MOKELE_SMASH
Func CanUse_MokeleSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MokeleSmash($a_f_AggroRange)
	; Description
	; Hammer Attack. If this attack hits, you strike for +5...17...20 damage and gain 2 strikes of adrenaline.
	; Concise description
	; Hammer Attack. Deals +5...17...20 damage and you gain 2 strikes of adrenaline.
	Return 0
EndFunc

; Skill ID: 1410 - $GC_I_SKILL_ID_OVERBEARING_SMASH
Func CanUse_OverbearingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_OverbearingSmash($a_f_AggroRange)
	; Description
	; Hammer Attack. If this attack hits, you deal +1...16...20 damage. If target foe is knocked down, that foe is Dazed for 1...7...8 second[s].
	; Concise description
	; Hammer Attack. Deals +1...16...20 damage. If target foe is knocked down, they are Dazed (1...7...8 second[s]).
	Return 0
EndFunc

; Skill ID: 1415 - $GC_I_SKILL_ID_CRIPPLING_SLASH
Func CanUse_CripplingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingSlash($a_f_AggroRange)
	; Description
	; Elite Sword Attack. If this attack hits, target foe is Crippled for 5...13...15 seconds and begins Bleeding for 10...22...25 seconds.
	; Concise description
	; Elite Sword Attack. Inflicts Crippled condition (5...13...15 seconds) and Bleeding condition (10...22...25 seconds).
	Return 0
EndFunc

; Skill ID: 1416 - $GC_I_SKILL_ID_BARBAROUS_SLICE
Func CanUse_BarbarousSlice()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BarbarousSlice($a_f_AggroRange)
	; Description
	; Sword Attack. If this attack hits, you deal +5...25...30 damage. If you are currently not in a stance, you also inflict Bleeding for 5...13...15 seconds.
	; Concise description
	; Sword Attack. Deals +5...25...30 damage. Inflicts Bleeding condition (5...13...15 seconds) if you are not in a stance.
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
	; Description
	; Attack. Players in the area are knocked down for 4 seconds and take 100 damage. If a player is carrying a bundle item, that bundle item is destroyed. This skill cannot be disabled.
	; Concise description
	; Attack. Deals 100 damage and knocks-down players in the area (4 seconds). If a player is carrying a bundle item, that bundle item is destroyed. This skill cannot be disabled.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
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
	; Description
	; Attack. For 30 seconds, all foes in this area are struck for 15 earth damage every second. Any foe using a skill when struck is knocked down.
	; Concise description
	; Attack. (30 seconds.) Deals 15 earth damage every second to all foes in the area. Any foe using a skill when struck is knocked-down.
	Return 0
EndFunc

; Skill ID: 1462 - $GC_I_SKILL_ID_FROST_VORTEX
Func CanUse_FrostVortex()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FrostVortex($a_f_AggroRange)
	; Description
	; Attack. For 30 seconds, all foes in the area are struck for 50 cold damage every 3 seconds. Any foe moving when struck is slowed by 90% for 10 seconds.
	; Concise description
	; Attack. (30 seconds.) Deals 50 cold damage every 3 seconds to all foes in the area. Any foe moving when struck moves 90% slower (10 seconds).
	Return 0
EndFunc

; Skill ID: 1465 - $GC_I_SKILL_ID_PREPARED_SHOT
Func CanUse_PreparedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PreparedShot($a_f_AggroRange)
	; Description
	; Elite Bow Attack. If this attack hits, you strike for +10...22...25 damage. If you are under the effects of a preparation, you gain 1...7...9 Energy.
	; Concise description
	; Elite Bow Attack. Deals +10...22...25 damage. You gain 1...7...9 Energy if you have a preparation active.
	Return 0
EndFunc

; Skill ID: 1466 - $GC_I_SKILL_ID_BURNING_ARROW
Func CanUse_BurningArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BurningArrow($a_f_AggroRange)
	; Description
	; Elite Bow Attack. If this attack hits, you strike for +10...26...30 damage and cause Burning for 1...6...7 seconds.
	; Concise description
	; Elite Bow Attack. Deals +10...26...30 damage. Inflicts Burning condition (1...6...7 seconds).
	Return 0
EndFunc

; Skill ID: 1467 - $GC_I_SKILL_ID_ARCING_SHOT
Func CanUse_ArcingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ArcingShot($a_f_AggroRange)
	; Description
	; Bow Attack. If this arrow hits, it strikes for +10...22...25 damage. This arrow cannot be blocked, but it moves 50% slower.
	; Concise description
	; Bow Attack. Deals +10...22...25 damage. Unblockable. This arrow moves 50% slower.
	Return 0
EndFunc

; Skill ID: 1469 - $GC_I_SKILL_ID_CROSSFIRE
Func CanUse_Crossfire()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Crossfire($a_f_AggroRange)
	; Description
	; Bow Attack. If this attack hits target foe, it deals +5...17...20 damage. If that foe is near any of your allies, this attack cannot be blocked.
	; Concise description
	; Bow Attack. Deals +5...17...20 damage. Unblockable if target foe is near any of your allies.
	Return 0
EndFunc

; Skill ID: 1483 - $GC_I_SKILL_ID_BANISHING_STRIKE
Func CanUse_BanishingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BanishingStrike($a_f_AggroRange)
	; Description
	; Melee Attack. If it hits, this attack deals 10...50...60 holy damage. It deals double damage to summoned creatures.
	; Concise description
	; Melee Attack. Deals 10...50...60 holy damage. Deals double damage to summoned creatures.
	Return 0
EndFunc

; Skill ID: 1484 - $GC_I_SKILL_ID_MYSTIC_SWEEP
Func CanUse_MysticSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MysticSweep($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you deal +3...10...12 damage. If you are enchanted, this attack deals an additional +3...10...12 damage.
	; Concise description
	; Melee Attack. Deals +3...10...12 damage. Deals an additional +3...10...12 damage if you are enchanted.
	Return 0
EndFunc

; Skill ID: 1485 - $GC_I_SKILL_ID_EREMITES_ATTACK
Func CanUse_EremitesAttack()
	If Anti_Attack() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") <= 1 Then Return False
	Return True
EndFunc

Func BestTarget_EremitesAttack($a_f_AggroRange)

	Return UAI_GetBestAOETarget(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1486 - $GC_I_SKILL_ID_REAP_IMPURITIES
Func CanUse_ReapImpurities()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ReapImpurities($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you deal +3...13...15 damage. Each foe you hit loses 1 condition. For each foe who loses a condition, all foes adjacent to that target foe take 10...34...40 holy damage.
	; Concise description
	; Melee Attack. Deals +3...13...15 damage. Struck foes lose 1 condition. Removal Effect: all foes adjacent to those struck take 10...34...40 holy damage.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1487 - $GC_I_SKILL_ID_TWIN_MOON_SWEEP
Func CanUse_TwinMoonSweep()
	If Anti_Attack() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc

Func BestTarget_TwinMoonSweep($a_f_AggroRange)
	; Description
	; Melee Attack. You lose 1 Dervish enchantment and gain 10...42...50 Health. If an enchantment is lost in this way, you cannot be blocked, you strike twice, and you gain an additional 10...58...70 Health.
	; Concise description
	; Melee Attack. Remove 1 of your Dervish enchantments. Gain 10...42...50 Health. Removal effect: unblockable, attack twice, and gain 10...58...70 more Health.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1488 - $GC_I_SKILL_ID_VICTORIOUS_SWEEP
Func CanUse_VictoriousSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_VictoriousSweep($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you deal +5...21...25 damage. If target foe has less Health than you, you gain 30...70...80 Health.
	; Concise description
	; Melee Attack. Deals +5...21...25 damage. You gain 30...70...80 Health for each foe you hit that has less Health than you.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1489 - $GC_I_SKILL_ID_IRRESISTIBLE_SWEEP
Func CanUse_IrresistibleSweep()
	If Anti_Attack() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc

Func BestTarget_IrresistibleSweep($a_f_AggroRange)
	; Description
	; Scythe Attack. Deal +3...13...15 damage and lose 1 Dervish enchantment. If you lose an enchantment in this way, Irresistible Sweep cannot be blocked, removes a stance, and deals +3...13...15 additional damage.
	; Concise description
	; Scythe Attack. Deals +3...13...15 damage. Remove 1 of your Dervish enchantments. Removal effect: unblockable, removes a stance, deals +3...13...15 additional damage.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1490 - $GC_I_SKILL_ID_PIOUS_ASSAULT
Func CanUse_PiousAssault()
	If Anti_Attack() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc

Func BestTarget_PiousAssault($a_f_AggroRange)
	; Description
	; Melee Attack. If it hits, this attack deals +10...18...20 damage and removes 1 Dervish enchantment. If a Dervish enchantment was removed, this skill recharges 75% faster and adjacent foes take 10...26...30 damage.
	; Concise description
	; Melee Attack. Deals +10...18...20 damage. Removes 1 of your Dervish enchantments. Removal Effect: this skill recharges 75% faster and adjacent foes take 10...26...30 damage.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1535 - $GC_I_SKILL_ID_CRIPPLING_SWEEP
Func CanUse_CripplingSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingSweep($a_f_AggroRange)
	; Description
	; Scythe Attack. If this attack hits a foe, that foe is Crippled for 3...10...12 seconds. This skill deals +3...13...15 extra damage if that foe is moving.
	; Concise description
	; Scythe Attack. (3...10...12 seconds.) Inflicts Cripple [sic] condition. Deals +3...13...15 damage to moving foes.
	Return 0
EndFunc

; Skill ID: 1536 - $GC_I_SKILL_ID_WOUNDING_STRIKE
Func CanUse_WoundingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WoundingStrike($a_f_AggroRange)
	; Description
	; Elite Scythe Attack. If this attack hits, you do +5...17...20 damage, target foe suffers from Bleeding for 5...17...20 seconds, and you lose 1 Dervish enchantment. If an enchantment is removed, target foe also suffers from a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Elite Scythe Attack. Deals +5...17...20 damage and inflicts Bleeding condition (5...17...20 seconds). Remove 1 Dervish enchantment. Removal Effect: inflicts Deep Wound condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 1537 - $GC_I_SKILL_ID_WEARYING_STRIKE
Func CanUse_WearyingStrike()
	If Anti_Attack() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc

Func BestTarget_WearyingStrike($a_f_AggroRange)
	; Description
	; Scythe Attack. You remove 1 Dervish enchantment. If an enchantment was removed, you inflict a Deep Wound for 3...9...10 seconds. You suffer from Weakness for 10 seconds if an enchantment is not removed.
	; Concise description
	; Scythe Attack. Remove 1 Dervish Enchantment. Removal Effect: Inflicts Deep Wound condition (3...9...10 seconds). You are Weakened (10 seconds) if an enchantment is not lost.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
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
	; Description
	; Scythe Attack. If it hits, this attack strikes for +3...13...15 damage. For each foe hit who has less Health than you, that foe and all adjacent foes are struck for 10...26...30 cold damage.
	; Concise description
	; Scythe Attack. Deals +3...13...15 damage. Deals 10...26...30 cold damage to each foe hit who has less Health than you and foes adjacent to those targets.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
EndFunc

; Skill ID: 1546 - $GC_I_SKILL_ID_BLAZING_SPEAR
Func CanUse_BlazingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlazingSpear($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, it deals +5...21...25 damage and sets target foe on Fire  for 1...3...3 second[s].
	; Concise description
	; Spear Attack. Deals +5...21...25 damage. Inflicts Burning condition (1...3...3 second[s]).
	Return 0
EndFunc

; Skill ID: 1547 - $GC_I_SKILL_ID_MIGHTY_THROW
Func CanUse_MightyThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MightyThrow($a_f_AggroRange)
	; Description
	; Spear Attack. Your spear moves three times faster. If it hits, you deal +10...34...40 damage.
	; Concise description
	; Spear Attack. Deals +10...34...40 damage. This spear moves three times faster.
	Return 0
EndFunc

; Skill ID: 1548 - $GC_I_SKILL_ID_CRUEL_SPEAR
Func CanUse_CruelSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CruelSpear($a_f_AggroRange)
	; Description
	; Elite Spear Attack. If this attack hits, you deal +1...25...31 damage. If it hits a non-moving target, you inflict a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Elite Spear Attack. Deals +1...25...31 damage. Inflicts Deep Wound condition (5...17...20 seconds) if target is not moving.
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
	; Description
	; Spear Attack. If this attack hits, you deal +10...34...40 damage. This attack cannot be blocked.
	; Concise description
	; Spear Attack. Deals +10...34...40 damage. Unblockable.
	Return 0
EndFunc

; Skill ID: 1551 - $GC_I_SKILL_ID_SPEAR_OF_LIGHTNING
Func CanUse_SpearOfLightning()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfLightning($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, it deals +8...18...20 lightning damage. This attack has 25% armor penetration.
	; Concise description
	; Spear Attack. Deals +8...18...20 lightning damage. 25% armor penetration.
	Return 0
EndFunc

; Skill ID: 1552 - $GC_I_SKILL_ID_WEARYING_SPEAR
Func CanUse_WearyingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WearyingSpear($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, you deal +10...34...40 damage. You are Weakened for 5 seconds.
	; Concise description
	; Spear Attack. Deals +10...34...40 damage. You are Weakened (5 seconds).
	Return 0
EndFunc

; Skill ID: 1600 - $GC_I_SKILL_ID_BARBED_SPEAR
Func CanUse_BarbedSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BarbedSpear($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, your target begins Bleeding for 5...17...20 seconds.
	; Concise description
	; Spear Attack. Inflicts Bleeding condition (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 1601 - $GC_I_SKILL_ID_VICIOUS_ATTACK
Func CanUse_ViciousAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ViciousAttack($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, you deal +5...17...20 damage. If you land a critical hit with this attack, target foe suffers from a Deep Wound for 5...13...15 seconds.
	; Concise description
	; Spear Attack. Deals +5...17...20 damage. Inflicts Deep Wound condition (5...13...15 seconds) with a critical hit.
	Return 0
EndFunc

; Skill ID: 1602 - $GC_I_SKILL_ID_STUNNING_STRIKE
Func CanUse_StunningStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StunningStrike($a_f_AggroRange)
	; Description
	; Elite Spear Attack. If this attack hits, you deal +5...25...30 damage. If it hits a foe suffering from a condition, that foe is also Dazed for 4...9...10 seconds.
	; Concise description
	; Elite Spear Attack. Deals +5...25...30 damage. Inflicts Dazed condition (4...9...10 seconds) if target has a condition.
	Return 0
EndFunc

; Skill ID: 1603 - $GC_I_SKILL_ID_MERCILESS_SPEAR
Func CanUse_MercilessSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MercilessSpear($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits a foe with less than 50% Health, that foe suffers from a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Spear Attack. Inflicts Deep Wound condition (5...17...20 seconds). No effect unless target has less than 50% Health.
	Return 0
EndFunc

; Skill ID: 1604 - $GC_I_SKILL_ID_DISRUPTING_THROW
Func CanUse_DisruptingThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingThrow($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits a foe suffering from a condition, that foe is interrupted.
	; Concise description
	; Spear Attack. Interrupts actions. No effect unless target has a condition.
	Return 0
EndFunc

; Skill ID: 1605 - $GC_I_SKILL_ID_WILD_THROW
Func CanUse_WildThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildThrow($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, it deals +5...17...20 damage, and any stance being used by your target ends. This attack cannot be blocked. All of your non-spear attack skills are disabled for 3 seconds.
	; Concise description
	; Spear Attack. Deals +5...17...20 damage. Unblockable. Ends target's stance.Disables [sic] your non-spear attack skills for 3 seconds.
	Return 0
EndFunc

; Skill ID: 1633 - $GC_I_SKILL_ID_MALICIOUS_STRIKE
Func CanUse_MaliciousStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MaliciousStrike($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits a foe suffering from a condition, you deal +10...26...30 damage and this attack results in a critical hit.
	; Concise description
	; Melee Attack. If target foe has a condition, this attack deals +10...26...30 damage and is a critical hit.
	Return 0
EndFunc

; Skill ID: 1634 - $GC_I_SKILL_ID_SHATTERING_ASSAULT
Func CanUse_ShatteringAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ShatteringAssault($a_f_AggroRange)
	; Description
	; Elite Dual Attack. Must follow an off-hand attack. If it hits, you deal 5...41...50 damage and target foe loses one enchantment. This attack cannot be blocked.
	; Concise description
	; Elite Dual Attack. Deals 5...41...50 damage. Removes one enchantment. Unblockable. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 1635 - $GC_I_SKILL_ID_GOLDEN_SKULL_STRIKE
Func CanUse_GoldenSkullStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenSkullStrike($a_f_AggroRange)
	; Description
	; Elite Off-Hand Attack. If you are under the effects of an enchantment and this attack hits, target foe is Dazed 1...4...5 seconds.
	; Concise description
	; Elite Off-Hand Attack. Inflicts Dazed condition (1...4...5 seconds). No effect unless you are enchanted.
	Return 0
EndFunc

; Skill ID: 1636 - $GC_I_SKILL_ID_BLACK_SPIDER_STRIKE
Func CanUse_BlackSpiderStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BlackSpiderStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must strike a hexed foe. If it hits, this attack strikes for +5...17...20 damage and target foe is Poisoned for 5...17...20 seconds.
	; Concise description
	; Off-Hand Attack. Deals +5...17...20 damage. Inflicts Poisoned condition (5...17...20 seconds). Must strike a hexed foe.
	Return 0
EndFunc

; Skill ID: 1637 - $GC_I_SKILL_ID_GOLDEN_FOX_STRIKE
Func CanUse_GoldenFoxStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenFoxStrike($a_f_AggroRange)
	; Description
	; GFS redirects here. For other uses, see GFS (disambiguation).
	; Concise description
	; green; font-weight: bold;">10...26...30
	Return 0
EndFunc

; Skill ID: 1670 - $GC_I_SKILL_ID_SIEGE_ATTACK_BOMBARDMENT
Func CanUse_SiegeAttackBombardment()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SiegeAttackBombardment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1693 - $GC_I_SKILL_ID_COUNTERATTACK
Func CanUse_Counterattack()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Counterattack($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you strike for +5...29...35 damage. If you hit an attacking foe, you gain 2...5...6 Energy.
	; Concise description
	; Melee Attack. Deals +5...29...35 damage. You gain 2...5...6 Energy if target foe is attacking.
	Return 0
EndFunc

; Skill ID: 1694 - $GC_I_SKILL_ID_MAGEHUNTER_STRIKE
Func CanUse_MagehunterStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MagehunterStrike($a_f_AggroRange)
	; Description
	; Elite Melee Attack. If this attack hits, you strike for +5...17...20 damage. If your target is under the effects of an enchantment, this attack cannot be blocked.
	; Concise description
	; Elite Melee Attack. Deals +5...17...20 damage. Unblockable if target foe is enchanted.
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
	; Description
	; Elite Axe Attack. You lose all adrenaline and all Energy. If this attack hits, you deal +5...41...50 damage and cause a Deep Wound for 5...17...20 seconds. This attack always results in a critical hit.
	; Concise description
	; Elite Axe Attack. Deals +5...41...50 damage. Inflicts Deep Wound condition (5...17...20 seconds). Automatic critical hit. You lose all adrenaline and Energy.
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
	; Description
	; Sword Attack. If this attack hits, you deal +1...25...31 damage. If you hit a foe that is knocked down, you gain 1...4...5 adrenaline.
	; Concise description
	; Sword Attack. Deals +1...25...31 damage. You gain 1...4...5 adrenaline if target foe is knocked down.
	Return 0
EndFunc

; Skill ID: 1705 - $GC_I_SKILL_ID_EARTH_SHATTERING_BLOW
Func CanUse_EarthShatteringBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EarthShatteringBlow($a_f_AggroRange)
	; Description
	; Attack. All foes in the area of target take 100 blunt damage and are knocked down. Surrounding foes take 80 earth damage.
	; Concise description
	; Attack. Deals 100 blunt damage and causes knock-down to foes in the area of target. 80 earth damage to surrounding foes.
	Return 0
EndFunc

; Skill ID: 1719 - $GC_I_SKILL_ID_SCREAMING_SHOT
Func CanUse_ScreamingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ScreamingShot($a_f_AggroRange)
	; Description
	; Bow Attack. If this attack hits, you deal +10...22...25 damage. If your target is within earshot, that foe begins Bleeding for 5...17...20 seconds.
	; Concise description
	; Bow Attack. Deals +10...22...25 damage. Inflicts Bleeding condition (5...17...20 seconds) if target foe is within earshot.
	Return 0
EndFunc

; Skill ID: 1720 - $GC_I_SKILL_ID_KEEN_ARROW
Func CanUse_KeenArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeenArrow($a_f_AggroRange)
	; Description
	; Bow Attack. If this attack hits, you strike for +5...17...20 damage. If you land a critical hit, you deal an additional +5...21...25 damage.
	; Concise description
	; Bow Attack. Deals +5...17...20 damage. Deals +5...21...25 more damage if you land a critical hit.
	Return 0
EndFunc

; Skill ID: 1722 - $GC_I_SKILL_ID_FORKED_ARROW
Func CanUse_ForkedArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ForkedArrow($a_f_AggroRange)
	; Description
	; Bow Attack. Shoot two arrows simultaneously at target foe. If you are under the effects of an enchantment or hex, you shoot only one arrow.
	; Concise description
	; Bow Attack. You shoot two arrows simultaneously. Shoot only one arrow if you are enchanted or hexed.
	Return 0
EndFunc

; Skill ID: 1726 - $GC_I_SKILL_ID_MAGEBANE_SHOT
Func CanUse_MagebaneShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MagebaneShot($a_f_AggroRange)
	; Description
	; Elite Bow Attack. If this attack hits, it interrupts target foe's action. If that action was a spell, it is disabled for an additional 10 seconds. This attack cannot be blocked.
	; Concise description
	; Elite Bow Attack. Interrupts an action. Interruption effect: an interrupted spell is disabled for +10 seconds. Unblockable.
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
	If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc

Func BestTarget_RendingSweep($a_f_AggroRange)
	; Description
	; Scythe Attack. You deal +5...17...20 and lose 1 Dervish enchantment. If an enchantment was lost, you remove an enchantment from each foe you hit.
	; Concise description
	; Scythe Attack. Deals +5...17...20 damage. You lose 1 Dervish enchantment. Removal effect: struck foes lose an enchantment.
	Return UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
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
	; Description
	; Spear Attack. If this attack hits, you deal +5...17...20 damage. If you are under the effects of an enchantment, this spear flies twice as fast and cannot be blocked.
	; Concise description
	; Spear Attack. Deals +5...17...20 damage. This spear moves twice as fast and is unblockable if you are enchanted.
	Return 0
EndFunc

; Skill ID: 1895 - $GC_I_SKILL_ID_WILD_SMASH
Func CanUse_WildSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildSmash($a_f_AggroRange)
	; Description
	; Attack. Target foe is knocked down. Any stances currently in use by target foe end and are disabled for 5 seconds. This attack cannot be blocked.
	; Concise description
	; Attack. Causes knock-down. Ends a stance and disables it (5 seconds). Unblockable.
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
	; Description
	; Monster skill
	; Concise description
	; "en","wgPageContentModel":"wikitext","wgRelevantPageName":"Torturous_Embers","wgRelevantArticleId":282757,"wgIsProbablyEditable":true,"wgRelevantPageIsProbablyEditable":true,"wgRestrictionEdit":[],"wgRestrictionMove":[],"wgMFDisplayWikibaseDescriptions":{"search":false,"nearby":false,"watchlist":false,"tagline":false},"wgPopupsFlags":4,"wgMediaViewerOnClick":true,"wgMediaViewerEnabledByDefault":true}; RLSTATE={"site.styles":"ready","user.styles":"ready","user":"ready","user.options":"loading","skins.monobook.styles":"ready"};RLPAGEMODULES=["site","mediawiki.page.ready","skins.monobook.scripts","mmv.head","mmv.bootstrap.autostart","ext.popups"];
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
	; Description
	; Dual Attack. Must follow an off-hand attack. If this attack hits, you steal 10...34...40 Health.
	; Concise description
	; Dual Attack. Steals 10...34...40 Health if this attack hits. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 1987 - $GC_I_SKILL_ID_LOTUS_STRIKE
Func CanUse_LotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_LotusStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must follow a lead attack. If it hits, this attack strikes for +10...22...25 damage and you gain 5...17...20 Energy.
	; Concise description
	; Off-Hand Attack. Deals +10...22...25 damage; you gain 5...17...20 Energy. Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 1988 - $GC_I_SKILL_ID_GOLDEN_FANG_STRIKE
Func CanUse_GoldenFangStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GoldenFangStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must follow a lead attack. If you are under the effects of an enchantment and this attack hits, target foe suffers from a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Off-Hand Attack. Inflicts Deep Wound condition (5...17...20 seconds) if you are enchanted. Must follow a lead attack.
	Return 0
EndFunc

; Skill ID: 1990 - $GC_I_SKILL_ID_FALLING_LOTUS_STRIKE
Func CanUse_FallingLotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FallingLotusStrike($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Must strike a knocked-down foe. If it hits, you strike for +15...31...35 damage and gain 1...10...12 Energy.
	; Concise description
	; Off-Hand Attack. Deals +15...31...35 damage; you gain 1...10...12 Energy. No effect unless target foe is knocked-down.
	Return 0
EndFunc

; Skill ID: 2008 - $GC_I_SKILL_ID_PULVERIZING_SMASH
Func CanUse_PulverizingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PulverizingSmash($a_f_AggroRange)
	; Description
	; Hammer Attack. If you hit a knocked-down foe, that foe suffers from Weakness and a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Hammer Attack. Inflicts Weakness and Deep Wound conditions (5...17...20 seconds) if target foe is knocked-down.
	Return 0
EndFunc

; Skill ID: 2009 - $GC_I_SKILL_ID_KEEN_CHOP
Func CanUse_KeenChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeenChop($a_f_AggroRange)
	; Description
	; Axe Attack. If it hits, this attack always results in a critical hit.
	; Concise description
	; Axe Attack. Always a critical hit.
	Return 0
EndFunc

; Skill ID: 2010 - $GC_I_SKILL_ID_KNEE_CUTTER
Func CanUse_KneeCutter()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KneeCutter($a_f_AggroRange)
	; Description
	; Sword Attack. If this attack hits a Crippled foe, you gain 2...6...7 Energy and 1...3...3 strikes  of adrenaline.
	; Concise description
	; Sword Attack. You gain 2...6...7 Energy and 1...3...3 adrenaline if target foe is Crippled.
	Return 0
EndFunc

; Skill ID: 2012 - $GC_I_SKILL_ID_RADIANT_SCYTHE
Func CanUse_RadiantScythe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RadiantScythe($a_f_AggroRange)
	; Description
	; Scythe Attack. This attack strikes for +1 damage for each point of Energy you currently have, maximum 5...25...30. You gain 1...6...7 Energy if this attack hits.
	; Concise description
	; Scythe Attack. Deals +1 damage (maximum 5...25...30) for each point of Energy you have. Gain 1...6...7 Energy.
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
	; Description
	; Sword Attack. Interrupt target foe's action. If that action was an attack, all of that foe's attack skills are disabled for 0...2...3 second[s].
	; Concise description
	; Sword Attack. Interrupts target foe. Interruption effect: disables this foe's attack skills (0...2...3 second[s]) if that action was an attack.
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
	; Description
	; Melee Attack. If this attack hits, you inflict Bleeding for 5...13...15 seconds. If you are enchanted, you also inflict Cracked Armor for 1...8...10 second[s].
	; Concise description
	; Melee Attack. (5...13...15 seconds.)Inflicts [sic] Bleeding condition. Also inflicts Cracked Armor (1...8...10 second[s]) if you are enchanted.
	Return 0
EndFunc

; Skill ID: 2071 - $GC_I_SKILL_ID_ZEALOUS_SWEEP
Func CanUse_ZealousSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ZealousSweep($a_f_AggroRange)
	; Description
	; Scythe Attack. If this attack hits, you deal +5...17...20 damage. You gain 3 Energy and 1 adrenaline for each foe you hit.
	; Concise description
	; Scythe Attack. Deals +5...17...20 damage. You gain 3 Energy and 1 adrenaline for each foe you hit.
	Return 0
EndFunc

; Skill ID: 2074 - $GC_I_SKILL_ID_CHEST_THUMPER
Func CanUse_ChestThumper()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ChestThumper($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits a foe with Cracked Armor, that foe suffers a Deep Wound for 5...17...20 seconds.
	; Concise description
	; Spear Attack. Inflicts Deep Wound condition (5...17...20 seconds) if target foe has Cracked Armor.
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
	; Description
	; This article is about the Nightfall skill. For the temporarily available Bonus Mission Pack skill, see Whirlwind Attack (Turai Ossa).
	; Concise description
	; green; font-weight: bold;">13...20
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
	; Description
	; Melee Attack. If this attack hits, target foe is Blinded for 5...8 seconds. This attack counts as a lead attack.
	; Concise description
	; Melee Attack. Inflicts Blindness (5...8 seconds). Counts as a lead attack.
	Return 0
EndFunc

; Skill ID: 2124 - $GC_I_SKILL_ID_SHATTERED_SPIRIT
Func CanUse_ShatteredSpirit()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ShatteredSpirit($a_f_AggroRange)
	; Description
	; Melee Attack. This attack removes 2 hexes on target boss and deals 50 more damage for each hex removed in this way.
	; Concise description
	; Melee Attack. This attack removes 2 hexes on target boss. Removal effect: +50 damage for each hex removed.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2127 - $GC_I_SKILL_ID_UNSEEN_AGGRESSION
Func CanUse_UnseenAggression()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_UnseenAggression($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2135 - $GC_I_SKILL_ID_TRAMPLING_OX
Func CanUse_TramplingOx()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TramplingOx($a_f_AggroRange)
	; Description
	; Dual Attack. Must follow an off-hand attack. If it hits, you deal +5...17...20 damage. If you a  hit a Crippled foe, that foe is knocked down.
	; Concise description
	; Dual Attack. Deals +5...17...20 damage; causes knock-down if target foe is Crippled. Must follow an off-hand attack.
	Return 0
EndFunc

; Skill ID: 2143 - $GC_I_SKILL_ID_DISRUPTING_SHOT
Func CanUse_DisruptingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DisruptingShot($a_f_AggroRange)
	; Description
	; Bow Attack. If this attack hits, target foe's action is interrupted. If that action was a Skill, you strike for +10...34...40 damage.
	; Concise description
	; Bow Attack. Interrupts an action. Interruption effect: +10...34...40 damage if you interrupt a skill.
	Return 0
EndFunc

; Skill ID: 2144 - $GC_I_SKILL_ID_VOLLEY
Func CanUse_Volley()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Volley($a_f_AggroRange)
	; Description
	; Bow Attack. All your Preparations are removed. Shoot arrows at target foe and up to 3 foes adjacent to your target. These arrows strike for +1...8...10 damage if they hit.
	; Concise description
	; Bow Attack. Deals +1...8...10 damage. Hits up to 3 foes adjacent to your target. All your preparations are removed.
	Return 0
EndFunc

; Skill ID: 2147 - $GC_I_SKILL_ID_CRIPPLING_VICTORY
Func CanUse_CripplingVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingVictory($a_f_AggroRange)
	; Description
	; Scythe Attack. If this attack hits a foe, that foe is Crippled for 3...7...8 seconds. If you have more Health than target foe, all adjacent foes take 10...26...30 earth damage.
	; Concise description
	; Scythe Attack. (3...7...8 seconds) Cripples target foe. If your health is greater than target foe's, all adjacent foes take 10...26...30 earth damage.
	Return 0
EndFunc

; Skill ID: 2150 - $GC_I_SKILL_ID_MAIMING_SPEAR
Func CanUse_MaimingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MaimingSpear($a_f_AggroRange)
	; Description
	; Spear Attack. If your attack hits a Bleeding foe, that foe is Crippled for 5...17...20 seconds.
	; Concise description
	; Spear Attack. Inflicts Crippled condition (5...17...20 seconds) if target foe is Bleeding.
	Return 0
EndFunc

; Skill ID: 2157 - $GC_I_SKILL_ID_GOLEM_STRIKE
Func CanUse_GolemStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_GolemStrike($a_f_AggroRange)
	; Description
	; Melee Attack. Target takes 180 damage and is Dazed for 3 seconds.
	; Concise description
	; Melee Attack. Deals 180 damage and inflicts Dazed condition (3 seconds).
	Return 0
EndFunc

; Skill ID: 2158 - $GC_I_SKILL_ID_BLOODSTONE_SLASH
Func CanUse_BloodstoneSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BloodstoneSlash($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, it steals 75 Health.
	; Concise description
	; Melee Attack. Steal 75 Health.
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
	; Description
	; Attack. Creature shifts form to attack.
	; Concise description
	; Attack. Shift forms to attack.
	Return 0
EndFunc

; Skill ID: 2194 - $GC_I_SKILL_ID_DISTRACTING_STRIKE
Func CanUse_DistractingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DistractingStrike($a_f_AggroRange)
	; Description
	; Melee Attack. If Distracting Strike hits, it deals no damage and interrupts target foe's action. If target foe has Cracked Armor, that skill is disabled for 20 seconds.
	; Concise description
	; Melee Attack. Interrupts an action. Interruption effect: Disables interrupted skill (20 seconds) if target foe has Cracked Armor. Deals no damage.
	Return 0
EndFunc

; Skill ID: 2195 - $GC_I_SKILL_ID_SYMBOLIC_STRIKE
Func CanUse_SymbolicStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SymbolicStrike($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, you deal +12 damage for each signet you have equipped (maximum 70 damage).
	; Concise description
	; Melee Attack. Deals +12 damage (maximum 70) for each signet you have equipped.
	Return 0
EndFunc

; Skill ID: 2197 - $GC_I_SKILL_ID_BODY_BLOW
Func CanUse_BodyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BodyBlow($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack hits, target foe takes +10...34...40 damage. If target foe has Cracked Armor, that foe suffers from a Deep Wound for 0...12...15 second[s].
	; Concise description
	; Melee Attack. Deals +10...34...40 damage. Inflicts Deep Wound (0...12...15 second[s]) if target foe has Cracked Armor.
	Return 0
EndFunc

; Skill ID: 2198 - $GC_I_SKILL_ID_BODY_SHOT
Func CanUse_BodyShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BodyShot($a_f_AggroRange)
	; Description
	; Bow Attack. If this attack hits, you deal +5...17...20 damage. If it hits a foe with Cracked Armor, you gain 5...9...10 Energy.
	; Concise description
	; Bow Attack. Deals +5...17...20 damage. You gain 5...9...10 Energy if target foe has Cracked Armor.
	Return 0
EndFunc

; Skill ID: 2209 - $GC_I_SKILL_ID_HOLY_SPEAR
Func CanUse_HolySpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HolySpear($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, you deal +5...17...20 damage. If it hits a summoned creature, all nearby foes take 15...75...90 holy damage, and are set on fire for 3 seconds.
	; Concise description
	; Spear Attack. Deals +5...17...20 damage. Deals 15...75...90 holy damage and inflicts Burning condition (3 seconds) to nearby foes if you hit a summoned creature.
	Return 0
EndFunc

; Skill ID: 2210 - $GC_I_SKILL_ID_SPEAR_SWIPE
Func CanUse_SpearSwipe()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearSwipe($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, you deal +5...17...20 damage and target foe is Dazed for 4...9...10 seconds. This attack has melee range.
	; Concise description
	; Spear Melee Attack. Deals +5...17...20 damage and inflicts Dazed condition (4...9...10 seconds). This attack has melee range.
	Return 0
EndFunc

; Skill ID: 2228 - $GC_I_SKILL_ID_DEFT_STRIKE
Func CanUse_DeftStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeftStrike($a_f_AggroRange)
	; Description
	; Ranged Attack. If this attack hits, target foe takes 18...30 damage. If that foe has Cracked Armor, it begins Bleeding for 18...30 seconds.
	; Concise description
	; Ranged Attack. Deals 18...30 damage. Inflicts Bleeding condition (18...30 seconds) if target foe has Cracked Armor.
	Return 0
EndFunc

; Skill ID: 2238 - $GC_I_SKILL_ID_SPEAR_OF_REDEMPTION
Func CanUse_SpearOfRedemption()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SpearOfRedemption($a_f_AggroRange)
	; Description
	; Spear Attack. If this attack hits, you deal +5...17...20 damage. If it fails to hit, you lose one condition.
	; Concise description
	; Spear Attack. Deals +5...17...20 damage. If it fails to hit, you lose one condition.
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
	; Description
	; Melee Attack. If this attack hits, it deals 25 damage and interrupts an action.
	; Concise description
	; Melee Attack. Deals 25 damage; interrupts an action.
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
	; Description
	; Melee Attack. You deliver an uppercut to your foe, dealing 80 damage. This attack cannot be blocked.
	; Concise description
	; Melee Attack. Deals 80 damage. Unblockable.
	Return 0
EndFunc

; Skill ID: 2341 - $GC_I_SKILL_ID_BRAWLING_COMBO_PUNCH
Func CanUse_BrawlingComboPunch()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BrawlingComboPunch($a_f_AggroRange)
	; Description
	; Melee Attack. You attack twice, dealing 50 damage each time.
	; Concise description
	; Melee Attack. Attack twice for 50 damage each time.
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
	; Description
	; This article is about a PvE-only skill. For the weapon of the same name, see Club of a Thousand Bears (weapon).
	; Concise description
	; green; font-weight: bold;">6...9
	Return 0
EndFunc

; Skill ID: 2365 - $GC_I_SKILL_ID_THUNDERFIST_STRIKE
Func CanUse_ThunderfistStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ThunderfistStrike($a_f_AggroRange)
	; Description
	; Melee Attack. You deliver a Thunderfist Strike to your opponent, dealing 100 damage if it hits.
	; Concise description
	; Melee Attack. Deals 100 damage.
	Return 0
EndFunc

; Skill ID: 2490 - $GC_I_SKILL_ID_PARASITIC_BITE
Func CanUse_ParasiticBite()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ParasiticBite($a_f_AggroRange)
	; Description
	; Melee Attack. If this attack is successful, target foe has -1 Health degeneration and you have +1 Health regeneration for 5 seconds.
	; Concise description
	; Melee Attack. (5 seconds.) This attack inflicts -1 Health degeneration and you gain + 1 Health regeneration.
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

; Skill ID: 2808 - $GC_I_SKILL_ID_ENRAGED_SMASH_PvP
Func CanUse_EnragedSmashPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EnragedSmashPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2861 - $GC_I_SKILL_ID_PENETRATING_ATTACK_PvP
Func CanUse_PenetratingAttackPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PenetratingAttackPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2864 - $GC_I_SKILL_ID_SUNDERING_ATTACK_PvP
Func CanUse_SunderingAttackPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SunderingAttackPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2873 - $GC_I_SKILL_ID_MYSTIC_SWEEP_PvP
Func CanUse_MysticSweepPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_MysticSweepPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2874 - $GC_I_SKILL_ID_EREMITES_ATTACK_PvP
Func CanUse_EremitesAttackPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_EremitesAttackPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2875 - $GC_I_SKILL_ID_HARRIERS_TOSS_PvP
Func CanUse_HarriersTossPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_HarriersTossPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2888 - $GC_I_SKILL_ID_CHILLING_VICTORY_PvP
Func CanUse_ChillingVictoryPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ChillingVictoryPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2925 - $GC_I_SKILL_ID_SLOTH_HUNTERS_SHOT_PvP
Func CanUse_SlothHuntersShotPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_SlothHuntersShotPvP($a_f_AggroRange)
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

; Skill ID: 3061 - $GC_I_SKILL_ID_DEATH_BLOSSOM_PvP
Func CanUse_DeathBlossomPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_DeathBlossomPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3074 - $GC_I_SKILL_ID_BONE_SPIKE
Func CanUse_BoneSpike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BoneSpike($a_f_AggroRange)
	; Description
	; Bow Attack. A Bone Spike shoots out, dealing 100 damage to target foe. The Bone Spike seems to penetrate all defenses.
	; Concise description
	; Bow Attack. A Bone Spike shoots out, dealing 100 damage to target foe. The Bone Spike seems to penetrate all defenses.
	Return 0
EndFunc

; Skill ID: 3075 - $GC_I_SKILL_ID_FLURRY_OF_SPLINTERS
Func CanUse_FlurryOfSplinters()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FlurryOfSplinters($a_f_AggroRange)
	; Description
	; Bow Attack. A flurry of Bone Splinters shoots out, hitting target foe and up to 5 foes in longbow range for 35 damage per hit over 3 seconds. The Bone Splinters seem to penetrate all defenses.
	; Concise description
	; Bow Attack. A flurry of Bone Splinters shoots out, hitting target foe and up to 5 foes in longbow range for 35 damage per hit over 3 seconds. The Bone Splinters seem to penetrate all defenses.
	Return 0
EndFunc

; Skill ID: 3084 - $GC_I_SKILL_ID_REAPING_OF_DHUUM
Func CanUse_ReapingOfDhuum()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ReapingOfDhuum($a_f_AggroRange)
	; Description
	; Scythe Attack. Dhuum deals 200 damage to a new target with each strike. Dhuum only strikes a foe once in this way and will stop this attack after the fourth strike or when no eligible targets are within the area of his last strike. Dhuum is untargetable during this attack.
	; Concise description
	; Scythe Attack. Dhuum deals 200 damage to a new target with each strike. Dhuum only strikes a foe once in this way and will stop this attack after the fourth strike or when no eligible targets are within the area of his last strike. Dhuum is untargetable during this attack.
	Return 0
EndFunc

; Skill ID: 3133 - $GC_I_SKILL_ID_WEIGHT_OF_DHUUM
Func CanUse_WeightOfDhuum()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WeightOfDhuum($a_f_AggroRange)
	; Description
	; Scythe Attack. For 5 seconds, target foe moves and attacks 90% slower, has tripled casting times, benefits 75% less from healing, and has -10 Health degeneration.
	; Concise description
	; Scythe Attack. (5 seconds.) Target foe moves and attacks 90% slower, has tripled casting times, benefits 75% less from healing, and has -10 Health degeneration.
	Return 0
EndFunc

; Skill ID: 3140 - $GC_I_SKILL_ID_STAGGERING_BLOW_PvP
Func CanUse_StaggeringBlowPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_StaggeringBlowPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3142 - $GC_I_SKILL_ID_FIERCE_BLOW_PvP
Func CanUse_FierceBlowPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FierceBlowPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3143 - $GC_I_SKILL_ID_RENEWING_SMASH_PvP
Func CanUse_RenewingSmashPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RenewingSmashPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3147 - $GC_I_SKILL_ID_KEEN_ARROW_PvP
Func CanUse_KeenArrowPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_KeenArrowPvP($a_f_AggroRange)
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
	; Description
	; Melee Attack. Deals +100 damage to target foe, knocks them down and sets that foe on fire for 5 seconds.
	; Concise description
	; Melee Attack. Target foe takes +100 damage, is knocked down, and on fire for 5 seconds.
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
	; Description
	; Bow Attack. Deals +35 piercing damage and Cripples target foe for 15 seconds. If target foe is suffering from Weakness, that foe is knocked down for 3 seconds.
	; Concise description
	; Bow Attack. Deals +35 damage to target foe. Inflicts Crippled (15 seconds). Knocks down (3 seconds) targets suffering Weakness.
	Return 0
EndFunc

; Skill ID: 3237 - $GC_I_SKILL_ID_TERMINAL_VELOCITY
Func CanUse_TerminalVelocity()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TerminalVelocity($a_f_AggroRange)
	; Description
	; Bow Attack. Deals +30 piercing damage and interrupts target foe. If target foe is Bleeding, they suffer a Deep Wound for 20 seconds. This arrow moves twice as fast.
	; Concise description
	; Bow Attack. Deals +30 damage. Interrupts target. Inflicts Deep Wound (20 seconds) on Bleeding foes. This arrow moves twice as fast.
	Return 0
EndFunc

; Skill ID: 3238 - $GC_I_SKILL_ID_RELENTLESS_ASSAULT
Func CanUse_RelentlessAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RelentlessAssault($a_f_AggroRange)
	; Description
	; Bow Attack. You lose up to 3 conditions. If this attack hits, you strike for +20 piercing damage and the target foe suffers Poison for 20 seconds.
	; Concise description
	; Bow Attack. Lose up to 3 conditions. Deals +20 damage and Poisons target foe (20 seconds) if the attack hits.
	Return 0
EndFunc

; Skill ID: 3244 - $GC_I_SKILL_ID_WITHERING_BLADE
Func CanUse_WitheringBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WitheringBlade($a_f_AggroRange)
	; Description
	; Off-Hand Attack. Deals +50 damage, and inflicts Weakness on target foe for 20 seconds.
	; Concise description
	; Off-Hand Attack. Deals +50 damage. Inflicts Weakness (20 seconds).
	Return 0
EndFunc

; Skill ID: 3246 - $GC_I_SKILL_ID_VENOM_FANG
Func CanUse_VenomFang()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_VenomFang($a_f_AggroRange)
	; Description
	; Dual Attack. Target foe becomes Poisoned for 20 seconds. If target foe has a Deep Wound, this attack deals an additional 80 damage.
	; Concise description
	; Dual Attack. Target is Poisoned (20 seconds). Deals +80 damage if target foe has a Deep Wound.
	Return 0
EndFunc

; Skill ID: 3249 - $GC_I_SKILL_ID_RAIN_OF_ARROWS
Func CanUse_RainOfArrows()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_RainOfArrows($a_f_AggroRange)
	; Description
	; Bow Attack. Shoot arrows at target foe and up to 3 foes near your target. Each arrow strikes for +20 damage if it hits.
	; Concise description
	; Bow Attack. Deals +20 damage. Hits up to 3 foes near your target.
	Return 0
EndFunc

; Skill ID: 3250 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3251 - $GC_I_SKILL_ID_FOX_FANGS_PvP
Func CanUse_FoxFangsPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_FoxFangsPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3252 - $GC_I_SKILL_ID_WILD_STRIKE_PvP
Func CanUse_WildStrikePvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WildStrikePvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3263 - $GC_I_SKILL_ID_BANISHING_STRIKE_PvP
Func CanUse_BanishingStrikePvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_BanishingStrikePvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3264 - $GC_I_SKILL_ID_TWIN_MOON_SWEEP_PvP
Func CanUse_TwinMoonSweepPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_TwinMoonSweepPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3265 - $GC_I_SKILL_ID_IRRESISTIBLE_SWEEP_PvP
Func CanUse_IrresistibleSweepPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_IrresistibleSweepPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3266 - $GC_I_SKILL_ID_PIOUS_ASSAULT_PvP
Func CanUse_PiousAssaultPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_PiousAssaultPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3295 - $GC_I_SKILL_ID_CLUB_STRIKE
Func CanUse_ClubStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_ClubStrike($a_f_AggroRange)
	; Description
	; Attack. You strike for +25 damage. If target foe is suffering from one or more conditions, you strike for an additional +25 damage and target foe is knocked down.
	; Concise description
	; Attack. Strikes for +25 damage. Strikes for an additional +25 damage and causes knock-down if target is suffering from a condition.
	Return 0
EndFunc

; Skill ID: 3296 - $GC_I_SKILL_ID_BLUDGEON
Func CanUse_Bludgeon()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_Bludgeon($a_f_AggroRange)
	; Description
	; Attack. You strike for +50 damage. If target foe is knocked down, you strike for an additional +50 damage and target foe suffers a Deep Wound for 10 seconds.
	; Concise description
	; Attack. Strikes for +50 damage. Strikes for an additional +50 damage and applies a Deep Wound (10 seconds) if target is knocked down.
	Return 0
EndFunc

; Skill ID: 3301 - $GC_I_SKILL_ID_ANNIHILATOR_BASH
Func CanUse_AnnihilatorBash()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AnnihilatorBash($a_f_AggroRange)
	; Description
	; Melee Attack. Removes blind condition and ends target's current stance. Target foe is knocked down and struck for +50 damage.
	; Concise description
	; Melee Attack. Deals +50 damage. Knocks down foe. Initial Effect: Removes blind condition and ends target foe's stance.
	Return 0
EndFunc

; Skill ID: 3367 - $GC_I_SKILL_ID_WOUNDING_STRIKE_PvP
Func CanUse_WoundingStrikePvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_WoundingStrikePvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3381 - $GC_I_SKILL_ID_ANNIHILATOR_STRIKE
Func CanUse_AnnihilatorStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AnnihilatorStrike($a_f_AggroRange)
	; Description
	; Attack. If this attack hits, it steals 75 Health. Steal twice as much Health if it strike  Sarah.
	; Concise description
	; Attack. Steal 75 Health. If you strike Sarah, steal twice as much Health.
	Return 0
EndFunc

; Skill ID: 3383 - $GC_I_SKILL_ID_ANNIHILATOR_KNUCKLE
Func CanUse_AnnihilatorKnuckle()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_AnnihilatorKnuckle($a_f_AggroRange)
	; Description
	; Attack. Strikes target and adjacent foes for +80 damage.
	; Concise description
	; Attack. Deals +80 damage to target and adjacent foes.
	Return 0
EndFunc

; Skill ID: 3425 - $GC_I_SKILL_ID_JUDGMENT_STRIKE
Func CanUse_JudgmentStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc

Func BestTarget_JudgmentStrike($a_f_AggroRange)
	; Description
	; Elite Melee Attack. Attack target and adjacent foes. Each attack that hits deals +13...27...30 Holy damage  and knocks down attacking foes. PvE Skill
	; Concise description
	; Elite Melee Attack. Attacks target and adjacent foes for +13...27...30 Holy damage. Causes knock down on attacking foes. PvE Skill
	Return 0
EndFunc

