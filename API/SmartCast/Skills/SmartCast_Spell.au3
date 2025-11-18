#include-once

; Skill ID: 5 - $GC_I_SKILL_ID_POWER_BLOCK
Func CanUse_PowerBlock()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_GUILT, "HasEffect") Then Return False
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_DIVERSION, "HasEffect") Then Return False
	If Not Agent_GetAgentInfo($BestTarget, "IsCasting") Then Return False
	Return True
EndFunc

Func BestTarget_PowerBlock($aAggroRange)
	Return
EndFunc

; Skill ID: 21 - $GC_I_SKILL_ID_INSPIRED_ENCHANTMENT
Func CanUse_InspiredEnchantment()
	Return True
EndFunc

Func BestTarget_InspiredEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 22 - $GC_I_SKILL_ID_INSPIRED_HEX
Func CanUse_InspiredHex()
	Return True
EndFunc

Func BestTarget_InspiredHex($aAggroRange)
	Return
EndFunc

; Skill ID: 23 - $GC_I_SKILL_ID_POWER_SPIKE
Func CanUse_PowerSpike()
	Return True
EndFunc

Func BestTarget_PowerSpike($aAggroRange)
	Return
EndFunc

; Skill ID: 24 - $GC_I_SKILL_ID_POWER_LEAK
Func CanUse_PowerLeak()
	Return True
EndFunc

Func BestTarget_PowerLeak($aAggroRange)
	Return
EndFunc

; Skill ID: 25 - $GC_I_SKILL_ID_POWER_DRAIN
Func CanUse_PowerDrain()
	Return True
EndFunc

Func BestTarget_PowerDrain($aAggroRange)
	Return
EndFunc

; Skill ID: 27 - $GC_I_SKILL_ID_SHATTER_DELUSIONS
Func CanUse_ShatterDelusions()
	Return True
EndFunc

Func BestTarget_ShatterDelusions($aAggroRange)
	Return
EndFunc

; Skill ID: 39 - $GC_I_SKILL_ID_ENERGY_SURGE
Func CanUse_EnergySurge()
	Return True
EndFunc

Func BestTarget_EnergySurge($aAggroRange)
	Return
EndFunc

; Skill ID: 40 - $GC_I_SKILL_ID_ETHER_FEAST
Func CanUse_EtherFeast()
	Return True
EndFunc

Func BestTarget_EtherFeast($aAggroRange)
	Return
EndFunc

; Skill ID: 42 - $GC_I_SKILL_ID_ENERGY_BURN
Func CanUse_EnergyBurn()
	Return True
EndFunc

Func BestTarget_EnergyBurn($aAggroRange)
	Return
EndFunc

; Skill ID: 57 - $GC_I_SKILL_ID_CRY_OF_FRUSTRATION
Func CanUse_CryOfFrustration()
	Return True
EndFunc

Func BestTarget_CryOfFrustration($aAggroRange)
	Return
EndFunc

; Skill ID: 64 - $GC_I_SKILL_ID_MIMIC
Func CanUse_Mimic()
	Return True
EndFunc

Func BestTarget_Mimic($aAggroRange)
	Return
EndFunc

; Skill ID: 65 - $GC_I_SKILL_ID_ARCANE_MIMICRY
Func CanUse_ArcaneMimicry()
	Return True
EndFunc

Func BestTarget_ArcaneMimicry($aAggroRange)
	Return
EndFunc

; Skill ID: 67 - $GC_I_SKILL_ID_SHATTER_HEX
Func CanUse_ShatterHex()
	Return True
EndFunc

Func BestTarget_ShatterHex($aAggroRange)
	Return
EndFunc

; Skill ID: 68 - $GC_I_SKILL_ID_DRAIN_ENCHANTMENT
Func CanUse_DrainEnchantment()
	Return True
EndFunc

Func BestTarget_DrainEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 69 - $GC_I_SKILL_ID_SHATTER_ENCHANTMENT
Func CanUse_ShatterEnchantment()
	Return True
EndFunc

Func BestTarget_ShatterEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 70 - $GC_I_SKILL_ID_DISAPPEAR
Func CanUse_Disappear()
	Return True
EndFunc

Func BestTarget_Disappear($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 77 - $GC_I_SKILL_ID_CHAOS_STORM
Func CanUse_ChaosStorm()
	Return True
EndFunc

Func BestTarget_ChaosStorm($aAggroRange)
	Return
EndFunc

; Skill ID: 78 - $GC_I_SKILL_ID_EPIDEMIC
Func CanUse_Epidemic()
	Return True
EndFunc

Func BestTarget_Epidemic($aAggroRange)
	Return
EndFunc

; Skill ID: 79 - $GC_I_SKILL_ID_ENERGY_DRAIN
Func CanUse_EnergyDrain()
	Return True
EndFunc

Func BestTarget_EnergyDrain($aAggroRange)
	Return
EndFunc

; Skill ID: 80 - $GC_I_SKILL_ID_ENERGY_TAP
Func CanUse_EnergyTap()
	Return True
EndFunc

Func BestTarget_EnergyTap($aAggroRange)
	Return
EndFunc

; Skill ID: 81 - $GC_I_SKILL_ID_ARCANE_THIEVERY
Func CanUse_ArcaneThievery()
	Return True
EndFunc

Func BestTarget_ArcaneThievery($aAggroRange)
	Return
EndFunc

; Skill ID: 83 - $GC_I_SKILL_ID_ANIMATE_BONE_HORROR
Func CanUse_AnimateBoneHorror()
	Return True
EndFunc

Func BestTarget_AnimateBoneHorror($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 84 - $GC_I_SKILL_ID_ANIMATE_BONE_FIEND
Func CanUse_AnimateBoneFiend()
	Return True
EndFunc

Func BestTarget_AnimateBoneFiend($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 85 - $GC_I_SKILL_ID_ANIMATE_BONE_MINIONS
Func CanUse_AnimateBoneMinions()
	Return True
EndFunc

Func BestTarget_AnimateBoneMinions($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 86 - $GC_I_SKILL_ID_GRENTHS_BALANCE
Func CanUse_GrenthsBalance()
	Return True
EndFunc

Func BestTarget_GrenthsBalance($aAggroRange)
	Return
EndFunc

; Skill ID: 87 - $GC_I_SKILL_ID_VERATAS_GAZE
Func CanUse_VeratasGaze()
	Return True
EndFunc

Func BestTarget_VeratasGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 89 - $GC_I_SKILL_ID_DEATHLY_CHILL
Func CanUse_DeathlyChill()
	Return True
EndFunc

Func BestTarget_DeathlyChill($aAggroRange)
	Return
EndFunc

; Skill ID: 90 - $GC_I_SKILL_ID_VERATAS_SACRIFICE
Func CanUse_VeratasSacrifice()
	Return True
EndFunc

Func BestTarget_VeratasSacrifice($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 95 - $GC_I_SKILL_ID_PUTRID_EXPLOSION
Func CanUse_PutridExplosion()
	Return True
EndFunc

Func BestTarget_PutridExplosion($aAggroRange)
	Return
EndFunc

; Skill ID: 96 - $GC_I_SKILL_ID_SOUL_FEAST
Func CanUse_SoulFeast()
	Return True
EndFunc

Func BestTarget_SoulFeast($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 97 - $GC_I_SKILL_ID_NECROTIC_TRAVERSAL
Func CanUse_NecroticTraversal()
	Return True
EndFunc

Func BestTarget_NecroticTraversal($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 98 - $GC_I_SKILL_ID_CONSUME_CORPSE
Func CanUse_ConsumeCorpse()
	Return True
EndFunc

Func BestTarget_ConsumeCorpse($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 102 - $GC_I_SKILL_ID_SHADOW_STRIKE
Func CanUse_ShadowStrike()
	Return True
EndFunc

Func BestTarget_ShadowStrike($aAggroRange)
	Return
EndFunc

; Skill ID: 105 - $GC_I_SKILL_ID_DEATHLY_SWARM
Func CanUse_DeathlySwarm()
	Return True
EndFunc

Func BestTarget_DeathlySwarm($aAggroRange)
	Return
EndFunc

; Skill ID: 106 - $GC_I_SKILL_ID_ROTTING_FLESH
Func CanUse_RottingFlesh()
	Return True
EndFunc

Func BestTarget_RottingFlesh($aAggroRange)
	Return
EndFunc

; Skill ID: 107 - $GC_I_SKILL_ID_VIRULENCE
Func CanUse_Virulence()
	Return True
EndFunc

Func BestTarget_Virulence($aAggroRange)
	Return
EndFunc

; Skill ID: 110 - $GC_I_SKILL_ID_UNHOLY_FEAST
Func CanUse_UnholyFeast()
	Return True
EndFunc

Func BestTarget_UnholyFeast($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 112 - $GC_I_SKILL_ID_DESECRATE_ENCHANTMENTS
Func CanUse_DesecrateEnchantments()
	Return True
EndFunc

Func BestTarget_DesecrateEnchantments($aAggroRange)
	Return
EndFunc

; Skill ID: 117 - $GC_I_SKILL_ID_ENFEEBLE1
Func CanUse_Enfeeble1()
	Return True
EndFunc

Func BestTarget_Enfeeble1($aAggroRange)
	Return
EndFunc

; Skill ID: 118 - $GC_I_SKILL_ID_ENFEEBLING_BLOOD
Func CanUse_EnfeeblingBlood()
	Return True
EndFunc

Func BestTarget_EnfeeblingBlood($aAggroRange)
	Return
EndFunc

; Skill ID: 120 - $GC_I_SKILL_ID_BLOOD_OF_THE_MASTER
Func CanUse_BloodOfTheMaster()
	Return True
EndFunc

Func BestTarget_BloodOfTheMaster($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 133 - $GC_I_SKILL_ID_DARK_PACT
Func CanUse_DarkPact()
	Return True
EndFunc

Func BestTarget_DarkPact($aAggroRange)
	Return
EndFunc

; Skill ID: 141 - $GC_I_SKILL_ID_REND_ENCHANTMENTS
Func CanUse_RendEnchantments()
	Return True
EndFunc

Func BestTarget_RendEnchantments($aAggroRange)
	Return
EndFunc

; Skill ID: 143 - $GC_I_SKILL_ID_STRIP_ENCHANTMENT
Func CanUse_StripEnchantment()
	Return True
EndFunc

Func BestTarget_StripEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 144 - $GC_I_SKILL_ID_CHILBLAINS
Func CanUse_Chilblains()
	Return True
EndFunc

Func BestTarget_Chilblains($aAggroRange)
	Return
EndFunc

; Skill ID: 146 - $GC_I_SKILL_ID_OFFERING_OF_BLOOD
Func CanUse_OfferingOfBlood()
	Return True
EndFunc

Func BestTarget_OfferingOfBlood($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 149 - $GC_I_SKILL_ID_PLAGUE_SENDING
Func CanUse_PlagueSending()
	Return True
EndFunc

Func BestTarget_PlagueSending($aAggroRange)
	Return
EndFunc

; Skill ID: 151 - $GC_I_SKILL_ID_FEAST_OF_CORRUPTION
Func CanUse_FeastOfCorruption()
	Return True
EndFunc

Func BestTarget_FeastOfCorruption($aAggroRange)
	Return
EndFunc

; Skill ID: 152 - $GC_I_SKILL_ID_TASTE_OF_DEATH
Func CanUse_TasteOfDeath()
	Return True
EndFunc

Func BestTarget_TasteOfDeath($aAggroRange)
	Return
EndFunc

; Skill ID: 153 - $GC_I_SKILL_ID_VAMPIRIC_GAZE
Func CanUse_VampiricGaze()
	Return True
EndFunc

Func BestTarget_VampiricGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 159 - $GC_I_SKILL_ID_WEAKEN_ARMOR
Func CanUse_WeakenArmor()
	Return True
EndFunc

Func BestTarget_WeakenArmor($aAggroRange)
	Return
EndFunc

; Skill ID: 161 - $GC_I_SKILL_ID_LIGHTNING_STORM
Func CanUse_LightningStorm()
	Return True
EndFunc

Func BestTarget_LightningStorm($aAggroRange)
	Return
EndFunc

; Skill ID: 162 - $GC_I_SKILL_ID_GALE
Func CanUse_Gale()
	Return True
EndFunc

Func BestTarget_Gale($aAggroRange)
	Return
EndFunc

; Skill ID: 163 - $GC_I_SKILL_ID_WHIRLWIND
Func CanUse_Whirlwind()
	Return True
EndFunc

Func BestTarget_Whirlwind($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 167 - $GC_I_SKILL_ID_ERUPTION
Func CanUse_Eruption()
	Return True
EndFunc

Func BestTarget_Eruption($aAggroRange)
	Return
EndFunc

; Skill ID: 170 - $GC_I_SKILL_ID_EARTHQUAKE
Func CanUse_Earthquake()
	Return True
EndFunc

Func BestTarget_Earthquake($aAggroRange)
	Return
EndFunc

; Skill ID: 171 - $GC_I_SKILL_ID_STONING
Func CanUse_Stoning()
	Return True
EndFunc

Func BestTarget_Stoning($aAggroRange)
	Return
EndFunc

; Skill ID: 172 - $GC_I_SKILL_ID_STONE_DAGGERS
Func CanUse_StoneDaggers()
	Return True
EndFunc

Func BestTarget_StoneDaggers($aAggroRange)
	Return
EndFunc

; Skill ID: 174 - $GC_I_SKILL_ID_AFTERSHOCK
Func CanUse_Aftershock()
	Return True
EndFunc

Func BestTarget_Aftershock($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 183 - $GC_I_SKILL_ID_INFERNO
Func CanUse_Inferno()
	Return True
EndFunc

Func BestTarget_Inferno($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 185 - $GC_I_SKILL_ID_MIND_BURN
Func CanUse_MindBurn()
	Return True
EndFunc

Func BestTarget_MindBurn($aAggroRange)
	Return
EndFunc

; Skill ID: 186 - $GC_I_SKILL_ID_FIREBALL
Func CanUse_Fireball()
	Return True
EndFunc

Func BestTarget_Fireball($aAggroRange)
	Return
EndFunc

; Skill ID: 187 - $GC_I_SKILL_ID_METEOR
Func CanUse_Meteor()
	Return True
EndFunc

Func BestTarget_Meteor($aAggroRange)
	Return
EndFunc

; Skill ID: 188 - $GC_I_SKILL_ID_FLAME_BURST
Func CanUse_FlameBurst()
	Return True
EndFunc

Func BestTarget_FlameBurst($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 189 - $GC_I_SKILL_ID_RODGORTS_INVOCATION
Func CanUse_RodgortsInvocation()
	Return True
EndFunc

Func BestTarget_RodgortsInvocation($aAggroRange)
	Return
EndFunc

; Skill ID: 191 - $GC_I_SKILL_ID_IMMOLATE
Func CanUse_Immolate()
	Return True
EndFunc

Func BestTarget_Immolate($aAggroRange)
	Return
EndFunc

; Skill ID: 192 - $GC_I_SKILL_ID_METEOR_SHOWER
Func CanUse_MeteorShower()
	Return True
EndFunc

Func BestTarget_MeteorShower($aAggroRange)
	Return
EndFunc

; Skill ID: 193 - $GC_I_SKILL_ID_PHOENIX
Func CanUse_Phoenix()
	Return True
EndFunc

Func BestTarget_Phoenix($aAggroRange)
	Return
EndFunc

; Skill ID: 194 - $GC_I_SKILL_ID_FLARE
Func CanUse_Flare()
	Return True
EndFunc

Func BestTarget_Flare($aAggroRange)
	Return
EndFunc

; Skill ID: 195 - $GC_I_SKILL_ID_LAVA_FONT
Func CanUse_LavaFont()
	Return True
EndFunc

Func BestTarget_LavaFont($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 196 - $GC_I_SKILL_ID_SEARING_HEAT
Func CanUse_SearingHeat()
	Return True
EndFunc

Func BestTarget_SearingHeat($aAggroRange)
	Return
EndFunc

; Skill ID: 197 - $GC_I_SKILL_ID_FIRE_STORM
Func CanUse_FireStorm()
	Return True
EndFunc

Func BestTarget_FireStorm($aAggroRange)
	Return
EndFunc

; Skill ID: 215 - $GC_I_SKILL_ID_MAELSTROM
Func CanUse_Maelstrom()
	Return True
EndFunc

Func BestTarget_Maelstrom($aAggroRange)
	Return
EndFunc

; Skill ID: 217 - $GC_I_SKILL_ID_CRYSTAL_WAVE
Func CanUse_CrystalWave()
	Return True
EndFunc

Func BestTarget_CrystalWave($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 219 - $GC_I_SKILL_ID_OBSIDIAN_FLAME
Func CanUse_ObsidianFlame()
	Return True
EndFunc

Func BestTarget_ObsidianFlame($aAggroRange)
	Return
EndFunc

; Skill ID: 220 - $GC_I_SKILL_ID_BLINDING_FLASH
Func CanUse_BlindingFlash()
	Return True
EndFunc

Func BestTarget_BlindingFlash($aAggroRange)
	Return
EndFunc

; Skill ID: 223 - $GC_I_SKILL_ID_CHAIN_LIGHTNING
Func CanUse_ChainLightning()
	Return True
EndFunc

Func BestTarget_ChainLightning($aAggroRange)
	Return
EndFunc

; Skill ID: 224 - $GC_I_SKILL_ID_ENERVATING_CHARGE
Func CanUse_EnervatingCharge()
	Return True
EndFunc

Func BestTarget_EnervatingCharge($aAggroRange)
	Return
EndFunc

; Skill ID: 226 - $GC_I_SKILL_ID_MIND_SHOCK
Func CanUse_MindShock()
	Return True
EndFunc

Func BestTarget_MindShock($aAggroRange)
	Return
EndFunc

; Skill ID: 228 - $GC_I_SKILL_ID_THUNDERCLAP
Func CanUse_Thunderclap()
	Return True
EndFunc

Func BestTarget_Thunderclap($aAggroRange)
	Return
EndFunc

; Skill ID: 229 - $GC_I_SKILL_ID_LIGHTNING_ORB1
Func CanUse_LightningOrb1()
	Return True
EndFunc

Func BestTarget_LightningOrb1($aAggroRange)
	Return
EndFunc

; Skill ID: 230 - $GC_I_SKILL_ID_LIGHTNING_JAVELIN
Func CanUse_LightningJavelin()
	Return True
EndFunc

Func BestTarget_LightningJavelin($aAggroRange)
	Return
EndFunc

; Skill ID: 237 - $GC_I_SKILL_ID_WATER_TRIDENT
Func CanUse_WaterTrident()
	Return True
EndFunc

Func BestTarget_WaterTrident($aAggroRange)
	Return
EndFunc

; Skill ID: 240 - $GC_I_SKILL_ID_SMITE
Func CanUse_Smite()
	Return True
EndFunc

Func BestTarget_Smite($aAggroRange)
	Return
EndFunc

; Skill ID: 247 - $GC_I_SKILL_ID_SYMBOL_OF_WRATH
Func CanUse_SymbolOfWrath()
	Return True
EndFunc

Func BestTarget_SymbolOfWrath($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 252 - $GC_I_SKILL_ID_BANISH
Func CanUse_Banish()
	Return True
EndFunc

Func BestTarget_Banish($aAggroRange)
	Return
EndFunc

; Skill ID: 275 - $GC_I_SKILL_ID_MEND_CONDITION
Func CanUse_MendCondition()
	Return True
EndFunc

Func BestTarget_MendCondition($aAggroRange)
	Return
EndFunc

; Skill ID: 276 - $GC_I_SKILL_ID_RESTORE_CONDITION
Func CanUse_RestoreCondition()
	Return True
EndFunc

Func BestTarget_RestoreCondition($aAggroRange)
	Return
EndFunc

; Skill ID: 277 - $GC_I_SKILL_ID_MEND_AILMENT
Func CanUse_MendAilment()
	Return True
EndFunc

Func BestTarget_MendAilment($aAggroRange)
	Return
EndFunc

; Skill ID: 278 - $GC_I_SKILL_ID_PURGE_CONDITIONS
Func CanUse_PurgeConditions()
	Return True
EndFunc

Func BestTarget_PurgeConditions($aAggroRange)
	Return
EndFunc

; Skill ID: 279 - $GC_I_SKILL_ID_DIVINE_HEALING
Func CanUse_DivineHealing()
	Return True
EndFunc

Func BestTarget_DivineHealing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 280 - $GC_I_SKILL_ID_HEAL_AREA
Func CanUse_HealArea()
	Return True
EndFunc

Func BestTarget_HealArea($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 281 - $GC_I_SKILL_ID_ORISON_OF_HEALING
Func CanUse_OrisonOfHealing()
	Return True
EndFunc

Func BestTarget_OrisonOfHealing($aAggroRange)
	Return
EndFunc

; Skill ID: 282 - $GC_I_SKILL_ID_WORD_OF_HEALING
Func CanUse_WordOfHealing()
	Return True
EndFunc

Func BestTarget_WordOfHealing($aAggroRange)
	Return
EndFunc

; Skill ID: 283 - $GC_I_SKILL_ID_DWAYNAS_KISS
Func CanUse_DwaynasKiss()
	Return True
EndFunc

Func BestTarget_DwaynasKiss($aAggroRange)
	Return
EndFunc

; Skill ID: 286 - $GC_I_SKILL_ID_HEAL_OTHER
Func CanUse_HealOther()
	Return True
EndFunc

Func BestTarget_HealOther($aAggroRange)
	Return
EndFunc

; Skill ID: 287 - $GC_I_SKILL_ID_HEAL_PARTY
Func CanUse_HealParty()
	Return True
EndFunc

Func BestTarget_HealParty($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 292 - $GC_I_SKILL_ID_INFUSE_HEALTH
Func CanUse_InfuseHealth()
	Return True
EndFunc

Func BestTarget_InfuseHealth($aAggroRange)
	Return
EndFunc

; Skill ID: 298 - $GC_I_SKILL_ID_MARTYR
Func CanUse_Martyr()
	Return True
EndFunc

Func BestTarget_Martyr($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 301 - $GC_I_SKILL_ID_REMOVE_HEX
Func CanUse_RemoveHex()
	Return True
EndFunc

Func BestTarget_RemoveHex($aAggroRange)
	Return
EndFunc

; Skill ID: 302 - $GC_I_SKILL_ID_SMITE_HEX
Func CanUse_SmiteHex()
	Return True
EndFunc

Func BestTarget_SmiteHex($aAggroRange)
	Return
EndFunc

; Skill ID: 303 - $GC_I_SKILL_ID_CONVERT_HEXES
Func CanUse_ConvertHexes()
	Return True
EndFunc

Func BestTarget_ConvertHexes($aAggroRange)
	Return
EndFunc

; Skill ID: 304 - $GC_I_SKILL_ID_LIGHT_OF_DWAYNA
Func CanUse_LightOfDwayna()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_LightOfDwayna($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 305 - $GC_I_SKILL_ID_RESURRECT
Func CanUse_Resurrect()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_Resurrect($aAggroRange)
	Return
EndFunc

; Skill ID: 306 - $GC_I_SKILL_ID_REBIRTH
Func CanUse_Rebirth()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_Rebirth($aAggroRange)
	Return
EndFunc

; Skill ID: 311 - $GC_I_SKILL_ID_DRAW_CONDITIONS
Func CanUse_DrawConditions()
	Return True
EndFunc

Func BestTarget_DrawConditions($aAggroRange)
	Return
EndFunc

; Skill ID: 313 - $GC_I_SKILL_ID_HEALING_TOUCH
Func CanUse_HealingTouch()
	Return True
EndFunc

Func BestTarget_HealingTouch($aAggroRange)
	Return
EndFunc

; Skill ID: 314 - $GC_I_SKILL_ID_RESTORE_LIFE
Func CanUse_RestoreLife()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_RestoreLife($aAggroRange)
	Return
EndFunc

; Skill ID: 488 - $GC_I_SKILL_ID_ERUPTION_ENVIRONMENT
Func CanUse_EruptionEnvironment()
	Return True
EndFunc

Func BestTarget_EruptionEnvironment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 489 - $GC_I_SKILL_ID_FIRE_STORM_ENVIRONMENT
Func CanUse_FireStormEnvironment()
	Return True
EndFunc

Func BestTarget_FireStormEnvironment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 491 - $GC_I_SKILL_ID_FOUNT_OF_MAGUUMA
Func CanUse_FountOfMaguuma()
	Return True
EndFunc

Func BestTarget_FountOfMaguuma($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 492 - $GC_I_SKILL_ID_HEALING_FOUNTAIN
Func CanUse_HealingFountain()
	Return True
EndFunc

Func BestTarget_HealingFountain($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 493 - $GC_I_SKILL_ID_ICY_GROUND
Func CanUse_IcyGround()
	Return True
EndFunc

Func BestTarget_IcyGround($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 494 - $GC_I_SKILL_ID_MAELSTROM_ENVIRONMENT
Func CanUse_MaelstromEnvironment()
	Return True
EndFunc

Func BestTarget_MaelstromEnvironment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 495 - $GC_I_SKILL_ID_MURSAAT_TOWER_SKILL
Func CanUse_MursaatTowerSkill()
	Return True
EndFunc

Func BestTarget_MursaatTowerSkill($aAggroRange)
	Return
EndFunc

; Skill ID: 496 - $GC_I_SKILL_ID_QUICKSAND_ENVIRONMENT_EFFECT
Func CanUse_QuicksandEnvironmentEffect()
	Return True
EndFunc

Func BestTarget_QuicksandEnvironmentEffect($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 497 - $GC_I_SKILL_ID_CURSE_OF_THE_BLOODSTONE
Func CanUse_CurseOfTheBloodstone()
	Return True
EndFunc

Func BestTarget_CurseOfTheBloodstone($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 498 - $GC_I_SKILL_ID_CHAIN_LIGHTNING_ENVIRONMENT
Func CanUse_ChainLightningEnvironment()
	Return True
EndFunc

Func BestTarget_ChainLightningEnvironment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 499 - $GC_I_SKILL_ID_OBELISK_LIGHTNING
Func CanUse_ObeliskLightning()
	Return True
EndFunc

Func BestTarget_ObeliskLightning($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 500 - $GC_I_SKILL_ID_TAR
Func CanUse_Tar()
	Return True
EndFunc

Func BestTarget_Tar($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 525 - $GC_I_SKILL_ID_NIBBLE
Func CanUse_Nibble()
	Return True
EndFunc

Func BestTarget_Nibble($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 543 - $GC_I_SKILL_ID_GUARDIAN_PACIFY
Func CanUse_GuardianPacify()
	Return True
EndFunc

Func BestTarget_GuardianPacify($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 544 - $GC_I_SKILL_ID_SOUL_VORTEX
Func CanUse_SoulVortex()
	Return True
EndFunc

Func BestTarget_SoulVortex($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 545 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 560 - $GC_I_SKILL_ID_RESURRECT_GARGOYLE
Func CanUse_ResurrectGargoyle()
	Return True
EndFunc

Func BestTarget_ResurrectGargoyle($aAggroRange)
	Return
EndFunc

; Skill ID: 562 - $GC_I_SKILL_ID_LIGHTNING_ORB2
Func CanUse_LightningOrb2()
	Return True
EndFunc

Func BestTarget_LightningOrb2($aAggroRange)
	Return
EndFunc

; Skill ID: 563 - $GC_I_SKILL_ID_WURM_SIEGE_DUNES_OF_DESPAIR
Func CanUse_WurmSiegeDunesOfDespair()
	Return True
EndFunc

Func BestTarget_WurmSiegeDunesOfDespair($aAggroRange)
	Return
EndFunc

; Skill ID: 564 - $GC_I_SKILL_ID_WURM_SIEGE
Func CanUse_WurmSiege()
	Return True
EndFunc

Func BestTarget_WurmSiege($aAggroRange)
	Return
EndFunc

; Skill ID: 566 - $GC_I_SKILL_ID_SHIVER_TOUCH
Func CanUse_ShiverTouch()
	Return True
EndFunc

Func BestTarget_ShiverTouch($aAggroRange)
	Return
EndFunc

; Skill ID: 568 - $GC_I_SKILL_ID_VANISH
Func CanUse_Vanish()
	Return True
EndFunc

Func BestTarget_Vanish($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 571 - $GC_I_SKILL_ID_DISRUPTING_DAGGER
Func CanUse_DisruptingDagger()
	Return True
EndFunc

Func BestTarget_DisruptingDagger($aAggroRange)
	Return
EndFunc

; Skill ID: 576 - $GC_I_SKILL_ID_STATUES_BLESSING
Func CanUse_StatuesBlessing()
	Return True
EndFunc

Func BestTarget_StatuesBlessing($aAggroRange)
	Return
EndFunc

; Skill ID: 579 - $GC_I_SKILL_ID_DOMAIN_OF_SKILL_DAMAGE
Func CanUse_DomainOfSkillDamage()
	Return True
EndFunc

Func BestTarget_DomainOfSkillDamage($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 580 - $GC_I_SKILL_ID_DOMAIN_OF_ENERGY_DRAINING
Func CanUse_DomainOfEnergyDraining()
	Return True
EndFunc

Func BestTarget_DomainOfEnergyDraining($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 581 - $GC_I_SKILL_ID_DOMAIN_OF_ELEMENTS
Func CanUse_DomainOfElements()
	Return True
EndFunc

Func BestTarget_DomainOfElements($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 582 - $GC_I_SKILL_ID_DOMAIN_OF_HEALTH_DRAINING
Func CanUse_DomainOfHealthDraining()
	Return True
EndFunc

Func BestTarget_DomainOfHealthDraining($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 583 - $GC_I_SKILL_ID_DOMAIN_OF_SLOW
Func CanUse_DomainOfSlow()
	Return True
EndFunc

Func BestTarget_DomainOfSlow($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 585 - $GC_I_SKILL_ID_SWAMP_WATER
Func CanUse_SwampWater()
	Return True
EndFunc

Func BestTarget_SwampWater($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 586 - $GC_I_SKILL_ID_JANTHIRS_GAZE
Func CanUse_JanthirsGaze()
	Return True
EndFunc

Func BestTarget_JanthirsGaze($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 587 - $GC_I_SKILL_ID_FAKE_SPELL
Func CanUse_FakeSpell()
	Return True
EndFunc

Func BestTarget_FakeSpell($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 589 - $GC_I_SKILL_ID_STORMCALLER_SKILL
Func CanUse_StormcallerSkill()
	Return True
EndFunc

Func BestTarget_StormcallerSkill($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 591 - $GC_I_SKILL_ID_QUEST_SKILL
Func CanUse_QuestSkill()
	Return True
EndFunc

Func BestTarget_QuestSkill($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 592 - $GC_I_SKILL_ID_RURIK_MUST_LIVE
Func CanUse_RurikMustLive()
	Return True
EndFunc

Func BestTarget_RurikMustLive($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 595 - $GC_I_SKILL_ID_RESTORE_LIFE_MONSTER_SKILL
Func BestTarget_RestoreLifeMonsterSkill($aAggroRange)
	Return
EndFunc

; Skill ID: 766 - $GC_I_SKILL_ID_GAZE_OF_CONTEMPT
Func CanUse_GazeOfContempt()
	Return True
EndFunc

Func BestTarget_GazeOfContempt($aAggroRange)
	Return
EndFunc

; Skill ID: 769 - $GC_I_SKILL_ID_VIPERS_DEFENSE
Func CanUse_VipersDefense()
	Return True
EndFunc

Func BestTarget_VipersDefense($aAggroRange)
	Return
EndFunc

; Skill ID: 770 - $GC_I_SKILL_ID_RETURN
Func CanUse_Return()
	Return True
EndFunc

Func BestTarget_Return($aAggroRange)
	Return
EndFunc

; Skill ID: 784 - $GC_I_SKILL_ID_ENTANGLING_ASP
Func CanUse_EntanglingAsp()
	Return True
EndFunc

Func BestTarget_EntanglingAsp($aAggroRange)
	Return
EndFunc

; Skill ID: 791 - $GC_I_SKILL_ID_FLESH_OF_MY_FLESH
Func CanUse_FleshOfMyFlesh()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_FleshOfMyFlesh($aAggroRange)
	Return
EndFunc

; Skill ID: 796 - $GC_I_SKILL_ID_SORROWS_FLAME
Func CanUse_SorrowsFlame()
	Return True
EndFunc

Func BestTarget_SorrowsFlame($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 797 - $GC_I_SKILL_ID_SORROWS_FIST
Func CanUse_SorrowsFist()
	Return True
EndFunc

Func BestTarget_SorrowsFist($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 798 - $GC_I_SKILL_ID_BLAST_FURNACE
Func CanUse_BlastFurnace()
	Return True
EndFunc

Func BestTarget_BlastFurnace($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 799 - $GC_I_SKILL_ID_BEGUILING_HAZE
Func CanUse_BeguilingHaze()
	Return True
EndFunc

Func BestTarget_BeguilingHaze($aAggroRange)
	Return
EndFunc

; Skill ID: 805 - $GC_I_SKILL_ID_ANIMATE_VAMPIRIC_HORROR
Func CanUse_AnimateVampiricHorror()
	Return True
EndFunc

Func BestTarget_AnimateVampiricHorror($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 817 - $GC_I_SKILL_ID_DISCORD
Func CanUse_Discord()
	Return True
EndFunc

Func BestTarget_Discord($aAggroRange)
	Return
EndFunc

; Skill ID: 824 - $GC_I_SKILL_ID_LAVA_ARROWS
Func CanUse_LavaArrows()
	Return True
EndFunc

Func BestTarget_LavaArrows($aAggroRange)
	Return
EndFunc

; Skill ID: 825 - $GC_I_SKILL_ID_BED_OF_COALS
Func CanUse_BedOfCoals()
	Return True
EndFunc

Func BestTarget_BedOfCoals($aAggroRange)
	Return
EndFunc

; Skill ID: 830 - $GC_I_SKILL_ID_RAY_OF_JUDGMENT
Func CanUse_RayOfJudgment()
	Return True
EndFunc

Func BestTarget_RayOfJudgment($aAggroRange)
	Return
EndFunc

; Skill ID: 832 - $GC_I_SKILL_ID_ANIMATE_FLESH_GOLEM
Func CanUse_AnimateFleshGolem()
	Return True
EndFunc

Func BestTarget_AnimateFleshGolem($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 836 - $GC_I_SKILL_ID_RIDE_THE_LIGHTNING
Func CanUse_RideTheLightning()
	Return True
EndFunc

Func BestTarget_RideTheLightning($aAggroRange)
	Return
EndFunc

; Skill ID: 840 - $GC_I_SKILL_ID_POISONED_HEART
Func CanUse_PoisonedHeart()
	Return True
EndFunc

Func BestTarget_PoisonedHeart($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 841 - $GC_I_SKILL_ID_FETID_GROUND
Func CanUse_FetidGround()
	Return True
EndFunc

Func BestTarget_FetidGround($aAggroRange)
	Return
EndFunc

; Skill ID: 842 - $GC_I_SKILL_ID_ARC_LIGHTNING
Func CanUse_ArcLightning()
	Return True
EndFunc

Func BestTarget_ArcLightning($aAggroRange)
	Return
EndFunc

; Skill ID: 844 - $GC_I_SKILL_ID_CHURNING_EARTH
Func CanUse_ChurningEarth()
	Return True
EndFunc

Func BestTarget_ChurningEarth($aAggroRange)
	Return
EndFunc

; Skill ID: 845 - $GC_I_SKILL_ID_LIQUID_FLAME
Func CanUse_LiquidFlame()
	Return True
EndFunc

Func BestTarget_LiquidFlame($aAggroRange)
	Return
EndFunc

; Skill ID: 846 - $GC_I_SKILL_ID_STEAM1
Func CanUse_Steam1()
	Return True
EndFunc

Func BestTarget_Steam1($aAggroRange)
	Return
EndFunc

; Skill ID: 855 - $GC_I_SKILL_ID_CHOMPER
Func CanUse_Chomper()
	Return True
EndFunc

Func BestTarget_Chomper($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 858 - $GC_I_SKILL_ID_DANCING_DAGGERS
Func CanUse_DancingDaggers()
	Return True
EndFunc

Func BestTarget_DancingDaggers($aAggroRange)
	Return
EndFunc

; Skill ID: 862 - $GC_I_SKILL_ID_RAVENOUS_GAZE
Func CanUse_RavenousGaze()
	Return True
EndFunc

Func BestTarget_RavenousGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 864 - $GC_I_SKILL_ID_OPPRESSIVE_GAZE
Func CanUse_OppressiveGaze()
	Return True
EndFunc

Func BestTarget_OppressiveGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 865 - $GC_I_SKILL_ID_LIGHTNING_HAMMER
Func CanUse_LightningHammer()
	Return True
EndFunc

Func BestTarget_LightningHammer($aAggroRange)
	Return
EndFunc

; Skill ID: 866 - $GC_I_SKILL_ID_VAPOR_BLADE
Func CanUse_VaporBlade()
	Return True
EndFunc

Func BestTarget_VaporBlade($aAggroRange)
	Return
EndFunc

; Skill ID: 867 - $GC_I_SKILL_ID_HEALING_LIGHT
Func CanUse_HealingLight()
	Return True
EndFunc

Func BestTarget_HealingLight($aAggroRange)
	Return
EndFunc

; Skill ID: 873 - $GC_I_SKILL_ID_RESURRECT_MONSTER_SKILL
Func BestTarget_ResurrectMonsterSkill($aAggroRange)
	Return
EndFunc

; Skill ID: 877 - $GC_I_SKILL_ID_LYSSAS_BALANCE
Func CanUse_LyssasBalance()
	Return True
EndFunc

Func BestTarget_LyssasBalance($aAggroRange)
	Return
EndFunc

; Skill ID: 884 - $GC_I_SKILL_ID_SEARING_FLAMES1
Func CanUse_SearingFlames1()
	Return True
EndFunc

Func BestTarget_SearingFlames1($aAggroRange)
	Return
EndFunc

; Skill ID: 897 - $GC_I_SKILL_ID_OATH_OF_HEALING
Func CanUse_OathOfHealing()
	Return True
EndFunc

Func BestTarget_OathOfHealing($aAggroRange)
	Return
EndFunc

; Skill ID: 902 - $GC_I_SKILL_ID_BLOOD_OF_THE_AGGRESSOR
Func CanUse_BloodOfTheAggressor()
	Return True
EndFunc

Func BestTarget_BloodOfTheAggressor($aAggroRange)
	Return
EndFunc

; Skill ID: 903 - $GC_I_SKILL_ID_ICY_PRISM
Func CanUse_IcyPrism()
	Return True
EndFunc

Func BestTarget_IcyPrism($aAggroRange)
	Return
EndFunc

; Skill ID: 910 - $GC_I_SKILL_ID_SPIRIT_RIFT
Func CanUse_SpiritRift()
	Return True
EndFunc

Func BestTarget_SpiritRift($aAggroRange)
	Return
EndFunc

; Skill ID: 914 - $GC_I_SKILL_ID_CONSUME_SOUL
Func CanUse_ConsumeSoul()
	Return True
EndFunc

Func BestTarget_ConsumeSoul($aAggroRange)
	Return
EndFunc

; Skill ID: 915 - $GC_I_SKILL_ID_SPIRIT_LIGHT
Func CanUse_SpiritLight()
	Return True
EndFunc

Func BestTarget_SpiritLight($aAggroRange)
	Return
EndFunc

; Skill ID: 917 - $GC_I_SKILL_ID_RUPTURE_SOUL
Func CanUse_RuptureSoul()
	Return True
EndFunc

Func BestTarget_RuptureSoul($aAggroRange)
	Return
EndFunc

; Skill ID: 918 - $GC_I_SKILL_ID_SPIRIT_TO_FLESH
Func CanUse_SpiritToFlesh()
	Return True
EndFunc

Func BestTarget_SpiritToFlesh($aAggroRange)
	Return
EndFunc

; Skill ID: 919 - $GC_I_SKILL_ID_SPIRIT_BURN
Func CanUse_SpiritBurn()
	Return True
EndFunc

Func BestTarget_SpiritBurn($aAggroRange)
	Return
EndFunc

; Skill ID: 931 - $GC_I_SKILL_ID_POWER_RETURN
Func CanUse_PowerReturn()
	Return True
EndFunc

Func BestTarget_PowerReturn($aAggroRange)
	Return
EndFunc

; Skill ID: 932 - $GC_I_SKILL_ID_COMPLICATE
Func CanUse_Complicate()
	Return True
EndFunc

Func BestTarget_Complicate($aAggroRange)
	Return
EndFunc

; Skill ID: 933 - $GC_I_SKILL_ID_SHATTER_STORM
Func CanUse_ShatterStorm()
	Return True
EndFunc

Func BestTarget_ShatterStorm($aAggroRange)
	Return
EndFunc

; Skill ID: 936 - $GC_I_SKILL_ID_ENVENOM_ENCHANTMENTS
Func CanUse_EnvenomEnchantments()
	Return True
EndFunc

Func BestTarget_EnvenomEnchantments($aAggroRange)
	Return
EndFunc

; Skill ID: 937 - $GC_I_SKILL_ID_SHOCKWAVE
Func CanUse_Shockwave()
	Return True
EndFunc

Func BestTarget_Shockwave($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 940 - $GC_I_SKILL_ID_CRY_OF_LAMENT
Func CanUse_CryOfLament()
	Return True
EndFunc

Func BestTarget_CryOfLament($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 941 - $GC_I_SKILL_ID_BLESSED_LIGHT
Func CanUse_BlessedLight()
	Return True
EndFunc

Func BestTarget_BlessedLight($aAggroRange)
	Return
EndFunc

; Skill ID: 942 - $GC_I_SKILL_ID_WITHDRAW_HEXES
Func CanUse_WithdrawHexes()
	Return True
EndFunc

Func BestTarget_WithdrawHexes($aAggroRange)
	Return
EndFunc

; Skill ID: 943 - $GC_I_SKILL_ID_EXTINGUISH
Func CanUse_Extinguish()
	Return True
EndFunc

Func BestTarget_Extinguish($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 952 - $GC_I_SKILL_ID_DEATHS_CHARGE
Func CanUse_DeathsCharge()
	Return True
EndFunc

Func BestTarget_DeathsCharge($aAggroRange)
	Return
EndFunc

; Skill ID: 954 - $GC_I_SKILL_ID_EXPEL_HEXES
Func CanUse_ExpelHexes()
	Return True
EndFunc

Func BestTarget_ExpelHexes($aAggroRange)
	Return
EndFunc

; Skill ID: 955 - $GC_I_SKILL_ID_RIP_ENCHANTMENT
Func CanUse_RipEnchantment()
	Return True
EndFunc

Func BestTarget_RipEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 958 - $GC_I_SKILL_ID_HEALING_WHISPER
Func CanUse_HealingWhisper()
	Return True
EndFunc

Func BestTarget_HealingWhisper($aAggroRange)
	Return
EndFunc

; Skill ID: 959 - $GC_I_SKILL_ID_ETHEREAL_LIGHT
Func CanUse_EtherealLight()
	Return True
EndFunc

Func BestTarget_EtherealLight($aAggroRange)
	Return
EndFunc

; Skill ID: 960 - $GC_I_SKILL_ID_RELEASE_ENCHANTMENTS
Func CanUse_ReleaseEnchantments()
	Return True
EndFunc

Func BestTarget_ReleaseEnchantments($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 962 - $GC_I_SKILL_ID_SPIRIT_TRANSFER
Func CanUse_SpiritTransfer()
	Return True
EndFunc

Func BestTarget_SpiritTransfer($aAggroRange)
	Return
EndFunc

; Skill ID: 965 - $GC_I_SKILL_ID_ARCHEMORUS_STRIKE
Func CanUse_ArchemorusStrike()
	Return True
EndFunc

Func BestTarget_ArchemorusStrike($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 966 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_1
Func CanUse_SpearOfArchemorusLevel1()
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel1($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 967 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_2
Func CanUse_SpearOfArchemorusLevel2()
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel2($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 968 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_3
Func CanUse_SpearOfArchemorusLevel3()
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel3($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 969 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_4
Func CanUse_SpearOfArchemorusLevel4()
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel4($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 970 - $GC_I_SKILL_ID_SPEAR_OF_ARCHEMORUS_LEVEL_5
Func CanUse_SpearOfArchemorusLevel5()
	Return True
EndFunc

Func BestTarget_SpearOfArchemorusLevel5($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 971 - $GC_I_SKILL_ID_ARGOS_CRY
Func CanUse_ArgosCry()
	Return True
EndFunc

Func BestTarget_ArgosCry($aAggroRange)
	Return
EndFunc

; Skill ID: 972 - $GC_I_SKILL_ID_JADE_FURY
Func CanUse_JadeFury()
	Return True
EndFunc

Func BestTarget_JadeFury($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 973 - $GC_I_SKILL_ID_BLINDING_POWDER
Func CanUse_BlindingPowder()
	Return True
EndFunc

Func BestTarget_BlindingPowder($aAggroRange)
	Return
EndFunc

; Skill ID: 974 - $GC_I_SKILL_ID_MANTIS_TOUCH
Func CanUse_MantisTouch()
	Return True
EndFunc

Func BestTarget_MantisTouch($aAggroRange)
	Return
EndFunc

; Skill ID: 980 - $GC_I_SKILL_ID_FEAST_OF_SOULS
Func CanUse_FeastOfSouls()
	Return True
EndFunc

Func BestTarget_FeastOfSouls($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 985 - $GC_I_SKILL_ID_CALTROPS
Func CanUse_Caltrops()
	Return True
EndFunc

Func BestTarget_Caltrops($aAggroRange)
	Return
EndFunc

; Skill ID: 991 - $GC_I_SKILL_ID_DENY_HEXES
Func CanUse_DenyHexes()
	Return True
EndFunc

Func BestTarget_DenyHexes($aAggroRange)
	Return
EndFunc

; Skill ID: 1000 - $GC_I_SKILL_ID_BLINDING_SNOW
Func CanUse_BlindingSnow()
	Return True
EndFunc

Func BestTarget_BlindingSnow($aAggroRange)
	Return
EndFunc

; Skill ID: 1001 - $GC_I_SKILL_ID_AVALANCHE_SKILL
Func CanUse_AvalancheSkill()
	Return True
EndFunc

Func BestTarget_AvalancheSkill($aAggroRange)
	Return
EndFunc

; Skill ID: 1002 - $GC_I_SKILL_ID_SNOWBALL
Func CanUse_Snowball()
	Return True
EndFunc

Func BestTarget_Snowball($aAggroRange)
	Return
EndFunc

; Skill ID: 1003 - $GC_I_SKILL_ID_MEGA_SNOWBALL
Func CanUse_MegaSnowball()
	Return True
EndFunc

Func BestTarget_MegaSnowball($aAggroRange)
	Return
EndFunc

; Skill ID: 1011 - $GC_I_SKILL_ID_HOLIDAY_BLUES
Func CanUse_HolidayBlues()
	Return True
EndFunc

Func BestTarget_HolidayBlues($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1015 - $GC_I_SKILL_ID_FLURRY_OF_ICE
Func CanUse_FlurryOfIce()
	Return True
EndFunc

Func BestTarget_FlurryOfIce($aAggroRange)
	Return
EndFunc

; Skill ID: 1016 - $GC_I_SKILL_ID_SNOWBALL_NPC
Func CanUse_SnowballNpc()
	Return True
EndFunc

Func BestTarget_SnowballNpc($aAggroRange)
	Return
EndFunc

; Skill ID: 1032 - $GC_I_SKILL_ID_HEART_OF_SHADOW
Func CanUse_HeartOfShadow()
	Return True
EndFunc

Func BestTarget_HeartOfShadow($aAggroRange)
	Return
EndFunc

; Skill ID: 1038 - $GC_I_SKILL_ID_CRIPPLING_DAGGER
Func CanUse_CripplingDagger()
	Return True
EndFunc

Func BestTarget_CripplingDagger($aAggroRange)
	Return
EndFunc

; Skill ID: 1040 - $GC_I_SKILL_ID_SPIRIT_WALK
Func CanUse_SpiritWalk()
	Return True
EndFunc

Func BestTarget_SpiritWalk($aAggroRange)
	Return
EndFunc

; Skill ID: 1048 - $GC_I_SKILL_ID_REVEALED_ENCHANTMENT
Func CanUse_RevealedEnchantment()
	Return True
EndFunc

Func BestTarget_RevealedEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 1049 - $GC_I_SKILL_ID_REVEALED_HEX
Func CanUse_RevealedHex()
	Return True
EndFunc

Func BestTarget_RevealedHex($aAggroRange)
	Return
EndFunc

; Skill ID: 1052 - $GC_I_SKILL_ID_ACCUMULATED_PAIN
Func CanUse_AccumulatedPain()
	Return True
EndFunc

Func BestTarget_AccumulatedPain($aAggroRange)
	Return
EndFunc

; Skill ID: 1053 - $GC_I_SKILL_ID_PSYCHIC_DISTRACTION
Func CanUse_PsychicDistraction()
	Return True
EndFunc

Func BestTarget_PsychicDistraction($aAggroRange)
	Return
EndFunc

; Skill ID: 1057 - $GC_I_SKILL_ID_PSYCHIC_INSTABILITY
Func CanUse_PsychicInstability()
	Return True
EndFunc

Func BestTarget_PsychicInstability($aAggroRange)
	Return
EndFunc

; Skill ID: 1060 - $GC_I_SKILL_ID_CELESTIAL_HASTE
Func CanUse_CelestialHaste()
	Return True
EndFunc

Func BestTarget_CelestialHaste($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1061 - $GC_I_SKILL_ID_FEEDBACK
Func CanUse_Feedback()
	Return True
EndFunc

Func BestTarget_Feedback($aAggroRange)
	Return
EndFunc

; Skill ID: 1062 - $GC_I_SKILL_ID_ARCANE_LARCENY
Func CanUse_ArcaneLarceny()
	Return True
EndFunc

Func BestTarget_ArcaneLarceny($aAggroRange)
	Return
EndFunc

; Skill ID: 1067 - $GC_I_SKILL_ID_LIFEBANE_STRIKE
Func CanUse_LifebaneStrike()
	Return True
EndFunc

Func BestTarget_LifebaneStrike($aAggroRange)
	Return
EndFunc

; Skill ID: 1068 - $GC_I_SKILL_ID_BITTER_CHILL
Func CanUse_BitterChill()
	Return True
EndFunc

Func BestTarget_BitterChill($aAggroRange)
	Return
EndFunc

; Skill ID: 1069 - $GC_I_SKILL_ID_TASTE_OF_PAIN
Func CanUse_TasteOfPain()
	Return True
EndFunc

Func BestTarget_TasteOfPain($aAggroRange)
	Return
EndFunc

; Skill ID: 1070 - $GC_I_SKILL_ID_DEFILE_ENCHANTMENTS
Func CanUse_DefileEnchantments()
	Return True
EndFunc

Func BestTarget_DefileEnchantments($aAggroRange)
	Return
EndFunc

; Skill ID: 1075 - $GC_I_SKILL_ID_VAMPIRIC_SWARM
Func CanUse_VampiricSwarm()
	Return True
EndFunc

Func BestTarget_VampiricSwarm($aAggroRange)
	Return
EndFunc

; Skill ID: 1076 - $GC_I_SKILL_ID_BLOOD_DRINKER
Func CanUse_BloodDrinker()
	Return True
EndFunc

Func BestTarget_BloodDrinker($aAggroRange)
	Return
EndFunc

; Skill ID: 1081 - $GC_I_SKILL_ID_TEINAIS_WIND
Func CanUse_TeinaisWind()
	Return True
EndFunc

Func BestTarget_TeinaisWind($aAggroRange)
	Return
EndFunc

; Skill ID: 1082 - $GC_I_SKILL_ID_SHOCK_ARROW
Func CanUse_ShockArrow()
	Return True
EndFunc

Func BestTarget_ShockArrow($aAggroRange)
	Return
EndFunc

; Skill ID: 1083 - $GC_I_SKILL_ID_UNSTEADY_GROUND
Func CanUse_UnsteadyGround()
	Return True
EndFunc

Func BestTarget_UnsteadyGround($aAggroRange)
	Return
EndFunc

; Skill ID: 1086 - $GC_I_SKILL_ID_DRAGONS_STOMP
Func CanUse_DragonsStomp()
	Return True
EndFunc

Func BestTarget_DragonsStomp($aAggroRange)
	Return
EndFunc

; Skill ID: 1088 - $GC_I_SKILL_ID_SECOND_WIND
Func CanUse_SecondWind()
	Return True
EndFunc

Func BestTarget_SecondWind($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1094 - $GC_I_SKILL_ID_BREATH_OF_FIRE
Func CanUse_BreathOfFire()
	Return True
EndFunc

Func BestTarget_BreathOfFire($aAggroRange)
	Return
EndFunc

; Skill ID: 1095 - $GC_I_SKILL_ID_STAR_BURST
Func CanUse_StarBurst()
	Return True
EndFunc

Func BestTarget_StarBurst($aAggroRange)
	Return
EndFunc

; Skill ID: 1099 - $GC_I_SKILL_ID_TEINAIS_CRYSTALS
Func CanUse_TeinaisCrystals()
	Return True
EndFunc

Func BestTarget_TeinaisCrystals($aAggroRange)
	Return
EndFunc

; Skill ID: 1106 - $GC_I_SKILL_ID_SHIELD_OF_SAINT_VIKTOR
Func CanUse_ShieldOfSaintViktor()
	Return True
EndFunc

Func BestTarget_ShieldOfSaintViktor($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1107 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_1
Func CanUse_UrnOfSaintViktorLevel1()
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel1($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1108 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_2
Func CanUse_UrnOfSaintViktorLevel2()
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel2($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1109 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_3
Func CanUse_UrnOfSaintViktorLevel3()
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel3($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1110 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_4
Func CanUse_UrnOfSaintViktorLevel4()
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel4($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1111 - $GC_I_SKILL_ID_URN_OF_SAINT_VIKTOR_LEVEL_5
Func CanUse_UrnOfSaintViktorLevel5()
	Return True
EndFunc

Func BestTarget_UrnOfSaintViktorLevel5($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1113 - $GC_I_SKILL_ID_KIRINS_WRATH
Func CanUse_KirinsWrath()
	Return True
EndFunc

Func BestTarget_KirinsWrath($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1117 - $GC_I_SKILL_ID_HEAVENS_DELIGHT
Func CanUse_HeavensDelight()
	Return True
EndFunc

Func BestTarget_HeavensDelight($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1118 - $GC_I_SKILL_ID_HEALING_BURST
Func CanUse_HealingBurst()
	Return True
EndFunc

Func BestTarget_HealingBurst($aAggroRange)
	Return
EndFunc

; Skill ID: 1119 - $GC_I_SKILL_ID_KAREIS_HEALING_CIRCLE
Func CanUse_KareisHealingCircle()
	Return True
EndFunc

Func BestTarget_KareisHealingCircle($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1120 - $GC_I_SKILL_ID_JAMEIS_GAZE
Func CanUse_JameisGaze()
	Return True
EndFunc

Func BestTarget_JameisGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 1121 - $GC_I_SKILL_ID_GIFT_OF_HEALTH
Func CanUse_GiftOfHealth()
	Return True
EndFunc

Func BestTarget_GiftOfHealth($aAggroRange)
	Return
EndFunc

; Skill ID: 1126 - $GC_I_SKILL_ID_EMPATHIC_REMOVAL
Func CanUse_EmpathicRemoval()
	Return True
EndFunc

Func BestTarget_EmpathicRemoval($aAggroRange)
	Return
EndFunc

; Skill ID: 1128 - $GC_I_SKILL_ID_RESURRECTION_CHANT
Func CanUse_ResurrectionChant()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_ResurrectionChant($aAggroRange)
	Return
EndFunc

; Skill ID: 1129 - $GC_I_SKILL_ID_WORD_OF_CENSURE
Func CanUse_WordOfCensure()
	Return True
EndFunc

Func BestTarget_WordOfCensure($aAggroRange)
	Return
EndFunc

; Skill ID: 1130 - $GC_I_SKILL_ID_SPEAR_OF_LIGHT
Func CanUse_SpearOfLight()
	Return True
EndFunc

Func BestTarget_SpearOfLight($aAggroRange)
	Return
EndFunc

; Skill ID: 1174 - $GC_I_SKILL_ID_CATHEDRAL_COLLAPSE2
Func CanUse_CathedralCollapse2()
	Return True
EndFunc

Func BestTarget_CathedralCollapse2($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1175 - $GC_I_SKILL_ID_BLOOD_OF_ZU_HELTZER
Func CanUse_BloodOfZuHeltzer()
	Return True
EndFunc

Func BestTarget_BloodOfZuHeltzer($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1183 - $GC_I_SKILL_ID_CORRUPTED_DRAGON_SPORES
Func CanUse_CorruptedDragonSpores()
	Return True
EndFunc

Func BestTarget_CorruptedDragonSpores($aAggroRange)
	Return
EndFunc

; Skill ID: 1184 - $GC_I_SKILL_ID_CORRUPTED_DRAGON_SCALES
Func CanUse_CorruptedDragonScales()
	Return True
EndFunc

Func BestTarget_CorruptedDragonScales($aAggroRange)
	Return
EndFunc

; Skill ID: 1189 - $GC_I_SKILL_ID_OF_ROYAL_BLOOD
Func CanUse_OfRoyalBlood()
	Return True
EndFunc

Func BestTarget_OfRoyalBlood($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1190 - $GC_I_SKILL_ID_PASSAGE_TO_TAHNNAKAI
Func CanUse_PassageToTahnnakai()
	Return True
EndFunc

Func BestTarget_PassageToTahnnakai($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1215 - $GC_I_SKILL_ID_CLAMOR_OF_SOULS
Func CanUse_ClamorOfSouls()
	Return True
EndFunc

Func BestTarget_ClamorOfSouls($aAggroRange)
	Return
EndFunc

; Skill ID: 1216 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 1224 - $GC_I_SKILL_ID_DRAW_SPIRIT
Func CanUse_DrawSpirit()
	Return True
EndFunc

Func BestTarget_DrawSpirit($aAggroRange)
	Return
EndFunc

; Skill ID: 1225 - $GC_I_SKILL_ID_CHANNELED_STRIKE
Func CanUse_ChanneledStrike()
	Return True
EndFunc

Func BestTarget_ChanneledStrike($aAggroRange)
	Return
EndFunc

; Skill ID: 1226 - $GC_I_SKILL_ID_SPIRIT_BOON_STRIKE
Func CanUse_SpiritBoonStrike()
	Return True
EndFunc

Func BestTarget_SpiritBoonStrike($aAggroRange)
	Return
EndFunc

; Skill ID: 1227 - $GC_I_SKILL_ID_ESSENCE_STRIKE
Func CanUse_EssenceStrike()
	Return True
EndFunc

Func BestTarget_EssenceStrike($aAggroRange)
	Return
EndFunc

; Skill ID: 1228 - $GC_I_SKILL_ID_SPIRIT_SIPHON
Func CanUse_SpiritSiphon()
	Return True
EndFunc

Func BestTarget_SpiritSiphon($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1233 - $GC_I_SKILL_ID_SOOTHING_MEMORIES
Func CanUse_SoothingMemories()
	Return True
EndFunc

Func BestTarget_SoothingMemories($aAggroRange)
	Return
EndFunc

; Skill ID: 1234 - $GC_I_SKILL_ID_MEND_BODY_AND_SOUL
Func CanUse_MendBodyAndSoul()
	Return True
EndFunc

Func BestTarget_MendBodyAndSoul($aAggroRange)
	Return
EndFunc

; Skill ID: 1242 - $GC_I_SKILL_ID_ARCHEMORUS_STRIKE_CELESTIAL_SUMMONING
Func CanUse_ArchemorusStrikeCelestialSummoning()
	Return True
EndFunc

Func BestTarget_ArchemorusStrikeCelestialSummoning($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1243 - $GC_I_SKILL_ID_SHIELD_OF_SAINT_VIKTOR_CELESTIAL_SUMMONING
Func CanUse_ShieldOfSaintViktorCelestialSummoning()
	Return True
EndFunc

Func BestTarget_ShieldOfSaintViktorCelestialSummoning($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1245 - $GC_I_SKILL_ID_GAZE_FROM_BEYOND
Func CanUse_GazeFromBeyond()
	Return True
EndFunc

Func BestTarget_GazeFromBeyond($aAggroRange)
	Return
EndFunc

; Skill ID: 1262 - $GC_I_SKILL_ID_HEALING_RING
Func CanUse_HealingRing()
	Return True
EndFunc

Func BestTarget_HealingRing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1263 - $GC_I_SKILL_ID_RENEW_LIFE
Func CanUse_RenewLife()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_RenewLife($aAggroRange)
	Return
EndFunc

; Skill ID: 1264 - $GC_I_SKILL_ID_DOOM
Func CanUse_Doom()
	Return True
EndFunc

Func BestTarget_Doom($aAggroRange)
	Return
EndFunc

; Skill ID: 1265 - $GC_I_SKILL_ID_WIELDERS_BOON
Func CanUse_WieldersBoon()
	Return True
EndFunc

Func BestTarget_WieldersBoon($aAggroRange)
	Return
EndFunc

; Skill ID: 1277 - $GC_I_SKILL_ID_BATTLE_CRY2
Func CanUse_BattleCry2()
	Return True
EndFunc

Func BestTarget_BattleCry2($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1278 - $GC_I_SKILL_ID_ELEMENTAL_DEFENSE_ZONE
Func CanUse_ElementalDefenseZone()
	Return True
EndFunc

Func BestTarget_ElementalDefenseZone($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1279 - $GC_I_SKILL_ID_MELEE_DEFENSE_ZONE
Func CanUse_MeleeDefenseZone()
	Return True
EndFunc

Func BestTarget_MeleeDefenseZone($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1283 - $GC_I_SKILL_ID_TURRET_ARROW
Func CanUse_TurretArrow()
	Return True
EndFunc

Func BestTarget_TurretArrow($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1284 - $GC_I_SKILL_ID_BLOOD_FLOWER_SKILL
Func CanUse_BloodFlowerSkill()
	Return True
EndFunc

Func BestTarget_BloodFlowerSkill($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1285 - $GC_I_SKILL_ID_FIRE_FLOWER_SKILL
Func CanUse_FireFlowerSkill()
	Return True
EndFunc

Func BestTarget_FireFlowerSkill($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1286 - $GC_I_SKILL_ID_POISON_ARROW_FLOWER
Func CanUse_PoisonArrowFlower()
	Return True
EndFunc

Func BestTarget_PoisonArrowFlower($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1305 - $GC_I_SKILL_ID_SHIELDING_URN_SKILL
Func CanUse_ShieldingUrnSkill()
	Return True
EndFunc

Func BestTarget_ShieldingUrnSkill($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1318 - $GC_I_SKILL_ID_FIREBALL_OBELISK
Func CanUse_FireballObelisk()
	Return True
EndFunc

Func BestTarget_FireballObelisk($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1333 - $GC_I_SKILL_ID_EXTEND_CONDITIONS
Func CanUse_ExtendConditions()
	Return True
EndFunc

Func BestTarget_ExtendConditions($aAggroRange)
	Return
EndFunc

; Skill ID: 1334 - $GC_I_SKILL_ID_HYPOCHONDRIA
Func CanUse_Hypochondria()
	Return True
EndFunc

Func BestTarget_Hypochondria($aAggroRange)
	Return
EndFunc

; Skill ID: 1336 - $GC_I_SKILL_ID_SPIRITUAL_PAIN
Func CanUse_SpiritualPain()
	Return True
EndFunc

Func BestTarget_SpiritualPain($aAggroRange)
	Return
EndFunc

; Skill ID: 1337 - $GC_I_SKILL_ID_DRAIN_DELUSIONS
Func CanUse_DrainDelusions()
	Return True
EndFunc

Func BestTarget_DrainDelusions($aAggroRange)
	Return
EndFunc

; Skill ID: 1342 - $GC_I_SKILL_ID_TEASE
Func CanUse_Tease()
	Return True
EndFunc

Func BestTarget_Tease($aAggroRange)
	Return
EndFunc

; Skill ID: 1347 - $GC_I_SKILL_ID_DISCHARGE_ENCHANTMENT
Func CanUse_DischargeEnchantment()
	Return True
EndFunc

Func BestTarget_DischargeEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 1348 - $GC_I_SKILL_ID_HEX_EATER_VORTEX
Func CanUse_HexEaterVortex()
	Return True
EndFunc

Func BestTarget_HexEaterVortex($aAggroRange)
	Return
EndFunc

; Skill ID: 1349 - $GC_I_SKILL_ID_MIRROR_OF_DISENCHANTMENT
Func CanUse_MirrorOfDisenchantment()
	Return True
EndFunc

Func BestTarget_MirrorOfDisenchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 1350 - $GC_I_SKILL_ID_SIMPLE_THIEVERY
Func CanUse_SimpleThievery()
	Return True
EndFunc

Func BestTarget_SimpleThievery($aAggroRange)
	Return
EndFunc

; Skill ID: 1351 - $GC_I_SKILL_ID_ANIMATE_SHAMBLING_HORROR
Func CanUse_AnimateShamblingHorror()
	Return True
EndFunc

Func BestTarget_AnimateShamblingHorror($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1352 - $GC_I_SKILL_ID_ORDER_OF_UNDEATH
Func CanUse_OrderOfUndeath()
	Return True
EndFunc

Func BestTarget_OrderOfUndeath($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1353 - $GC_I_SKILL_ID_PUTRID_FLESH
Func CanUse_PutridFlesh()
	Return True
EndFunc

Func BestTarget_PutridFlesh($aAggroRange)
	Return
EndFunc

; Skill ID: 1354 - $GC_I_SKILL_ID_FEAST_FOR_THE_DEAD
Func CanUse_FeastForTheDead()
	Return True
EndFunc

Func BestTarget_FeastForTheDead($aAggroRange)
	Return
EndFunc

; Skill ID: 1359 - $GC_I_SKILL_ID_PAIN_OF_DISENCHANTMENT
Func CanUse_PainOfDisenchantment()
	Return True
EndFunc

Func BestTarget_PainOfDisenchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 1367 - $GC_I_SKILL_ID_BLINDING_SURGE
Func CanUse_BlindingSurge()
	Return True
EndFunc

Func BestTarget_BlindingSurge($aAggroRange)
	Return
EndFunc

; Skill ID: 1369 - $GC_I_SKILL_ID_LIGHTNING_BOLT
Func CanUse_LightningBolt()
	Return True
EndFunc

Func BestTarget_LightningBolt($aAggroRange)
	Return
EndFunc

; Skill ID: 1372 - $GC_I_SKILL_ID_SANDSTORM
Func CanUse_Sandstorm()
	Return True
EndFunc

Func BestTarget_Sandstorm($aAggroRange)
	Return
EndFunc

; Skill ID: 1374 - $GC_I_SKILL_ID_EBON_HAWK
Func CanUse_EbonHawk()
	Return True
EndFunc

Func BestTarget_EbonHawk($aAggroRange)
	Return
EndFunc

; Skill ID: 1379 - $GC_I_SKILL_ID_GLOWING_GAZE1
Func CanUse_GlowingGaze1()
	Return True
EndFunc

Func BestTarget_GlowingGaze1($aAggroRange)
	Return
EndFunc

; Skill ID: 1380 - $GC_I_SKILL_ID_SAVANNAH_HEAT
Func CanUse_SavannahHeat()
	Return True
EndFunc

Func BestTarget_SavannahHeat($aAggroRange)
	Return
EndFunc

; Skill ID: 1396 - $GC_I_SKILL_ID_WORDS_OF_COMFORT
Func CanUse_WordsOfComfort()
	Return True
EndFunc

Func BestTarget_WordsOfComfort($aAggroRange)
	Return
EndFunc

; Skill ID: 1397 - $GC_I_SKILL_ID_LIGHT_OF_DELIVERANCE
Func CanUse_LightOfDeliverance()
	Return True
EndFunc

Func BestTarget_LightOfDeliverance($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1401 - $GC_I_SKILL_ID_MENDING_TOUCH
Func CanUse_MendingTouch()
	Return True
EndFunc

Func BestTarget_MendingTouch($aAggroRange)
	Return
EndFunc

; Skill ID: 1424 - $GC_I_SKILL_ID_STOP_PUMP
Func CanUse_StopPump()
	Return True
EndFunc

Func BestTarget_StopPump($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1430 - $GC_I_SKILL_ID_WAVE_OF_TORMENT
Func CanUse_WaveOfTorment()
	Return True
EndFunc

Func BestTarget_WaveOfTorment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1434 - $GC_I_SKILL_ID_CORRUPTED_HEALING
Func CanUse_CorruptedHealing()
	Return True
EndFunc

Func BestTarget_CorruptedHealing($aAggroRange)
	Return
EndFunc

; Skill ID: 1444 - $GC_I_SKILL_ID_SUMMON_TORMENT
Func CanUse_SummonTorment()
	Return True
EndFunc

Func BestTarget_SummonTorment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1479 - $GC_I_SKILL_ID_OFFERING_OF_SPIRIT
Func CanUse_OfferingOfSpirit()
	Return True
EndFunc

Func BestTarget_OfferingOfSpirit($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1482 - $GC_I_SKILL_ID_RECLAIM_ESSENCE
Func CanUse_ReclaimEssence()
	Return True
EndFunc

Func BestTarget_ReclaimEssence($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1491 - $GC_I_SKILL_ID_MYSTIC_TWISTER
Func CanUse_MysticTwister()
	Return True
EndFunc

Func BestTarget_MysticTwister($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1525 - $GC_I_SKILL_ID_NATURAL_HEALING
Func CanUse_NaturalHealing()
	Return True
EndFunc

Func BestTarget_NaturalHealing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1526 - $GC_I_SKILL_ID_IMBUE_HEALTH
Func CanUse_ImbueHealth()
	Return True
EndFunc

Func BestTarget_ImbueHealth($aAggroRange)
	Return
EndFunc

; Skill ID: 1527 - $GC_I_SKILL_ID_MYSTIC_HEALING
Func CanUse_MysticHealing()
	Return True
EndFunc

Func BestTarget_MysticHealing($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1528 - $GC_I_SKILL_ID_DWAYNAS_TOUCH
Func CanUse_DwaynasTouch()
	Return True
EndFunc

Func BestTarget_DwaynasTouch($aAggroRange)
	Return
EndFunc

; Skill ID: 1529 - $GC_I_SKILL_ID_PIOUS_RESTORATION
Func CanUse_PiousRestoration()
	Return True
EndFunc

Func BestTarget_PiousRestoration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1532 - $GC_I_SKILL_ID_MYSTIC_SANDSTORM
Func CanUse_MysticSandstorm()
	Return True
EndFunc

Func BestTarget_MysticSandstorm($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1533 - $GC_I_SKILL_ID_WINDS_OF_DISENCHANTMENT
Func CanUse_WindsOfDisenchantment()
	Return True
EndFunc

Func BestTarget_WindsOfDisenchantment($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1534 - $GC_I_SKILL_ID_RENDING_TOUCH
Func CanUse_RendingTouch()
	Return True
EndFunc

Func BestTarget_RendingTouch($aAggroRange)
	Return
EndFunc

; Skill ID: 1545 - $GC_I_SKILL_ID_TEST_OF_FAITH
Func CanUse_TestOfFaith()
	Return True
EndFunc

Func BestTarget_TestOfFaith($aAggroRange)
	Return
EndFunc

; Skill ID: 1610 - $GC_I_SKILL_ID_SUMMONING_OF_THE_SCEPTER
Func CanUse_SummoningOfTheScepter()
	Return True
EndFunc

Func BestTarget_SummoningOfTheScepter($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1611 - $GC_I_SKILL_ID_RISE_FROM_YOUR_GRAVE
Func CanUse_RiseFromYourGrave()
	Return True
EndFunc

Func BestTarget_RiseFromYourGrave($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1651 - $GC_I_SKILL_ID_DEATHS_RETREAT
Func CanUse_DeathsRetreat()
	Return True
EndFunc

Func BestTarget_DeathsRetreat($aAggroRange)
	Return
EndFunc

; Skill ID: 1653 - $GC_I_SKILL_ID_SWAP
Func CanUse_Swap()
	Return True
EndFunc

Func BestTarget_Swap($aAggroRange)
	Return
EndFunc

; Skill ID: 1659 - $GC_I_SKILL_ID_TOXIC_CHILL
Func CanUse_ToxicChill()
	Return True
EndFunc

Func BestTarget_ToxicChill($aAggroRange)
	Return
EndFunc

; Skill ID: 1661 - $GC_I_SKILL_ID_GLOWSTONE
Func CanUse_Glowstone()
	Return True
EndFunc

Func BestTarget_Glowstone($aAggroRange)
	Return
EndFunc

; Skill ID: 1662 - $GC_I_SKILL_ID_MIND_BLAST
Func CanUse_MindBlast()
	Return True
EndFunc

Func BestTarget_MindBlast($aAggroRange)
	Return
EndFunc

; Skill ID: 1664 - $GC_I_SKILL_ID_INVOKE_LIGHTNING
Func CanUse_InvokeLightning()
	Return True
EndFunc

Func BestTarget_InvokeLightning($aAggroRange)
	Return
EndFunc

; Skill ID: 1665 - $GC_I_SKILL_ID_BATTLE_CRY1
Func CanUse_BattleCry1()
	Return True
EndFunc

Func BestTarget_BattleCry1($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1666 - $GC_I_SKILL_ID_MENDING_SHRINE_BONUS
Func CanUse_MendingShrineBonus()
	Return True
EndFunc

Func BestTarget_MendingShrineBonus($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1667 - $GC_I_SKILL_ID_ENERGY_SHRINE_BONUS
Func CanUse_EnergyShrineBonus()
	Return True
EndFunc

Func BestTarget_EnergyShrineBonus($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1668 - $GC_I_SKILL_ID_NORTHERN_HEALTH_SHRINE_BONUS
Func CanUse_NorthernHealthShrineBonus()
	Return True
EndFunc

Func BestTarget_NorthernHealthShrineBonus($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1669 - $GC_I_SKILL_ID_SOUTHERN_HEALTH_SHRINE_BONUS
Func CanUse_SouthernHealthShrineBonus()
	Return True
EndFunc

Func BestTarget_SouthernHealthShrineBonus($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1672 - $GC_I_SKILL_ID_TO_THE_PAIN_HERO_BATTLES
Func CanUse_ToThePainHeroBattles()
	Return True
EndFunc

Func BestTarget_ToThePainHeroBattles($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1686 - $GC_I_SKILL_ID_GLIMMER_OF_LIGHT
Func CanUse_GlimmerOfLight()
	Return True
EndFunc

Func BestTarget_GlimmerOfLight($aAggroRange)
	Return
EndFunc

; Skill ID: 1687 - $GC_I_SKILL_ID_ZEALOUS_BENEDICTION
Func CanUse_ZealousBenediction()
	Return True
EndFunc

Func BestTarget_ZealousBenediction($aAggroRange)
	Return
EndFunc

; Skill ID: 1691 - $GC_I_SKILL_ID_DISMISS_CONDITION
Func CanUse_DismissCondition()
	Return True
EndFunc

Func BestTarget_DismissCondition($aAggroRange)
	Return
EndFunc

; Skill ID: 1692 - $GC_I_SKILL_ID_DIVERT_HEXES
Func CanUse_DivertHexes()
	Return True
EndFunc

Func BestTarget_DivertHexes($aAggroRange)
	Return
EndFunc

; Skill ID: 1717 - $GC_I_SKILL_ID_SUNSPEAR_SIEGE
Func CanUse_SunspearSiege()
	Return True
EndFunc

Func BestTarget_SunspearSiege($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1733 - $GC_I_SKILL_ID_WIELDERS_STRIKE
Func CanUse_WieldersStrike()
	Return True
EndFunc

Func BestTarget_WieldersStrike($aAggroRange)
	Return
EndFunc

; Skill ID: 1741 - $GC_I_SKILL_ID_GHOSTMIRROR_LIGHT
Func CanUse_GhostmirrorLight()
	Return True
EndFunc

Func BestTarget_GhostmirrorLight($aAggroRange)
	Return
EndFunc

; Skill ID: 1744 - $GC_I_SKILL_ID_CARETAKERS_CHARGE
Func CanUse_CaretakersCharge()
	Return True
EndFunc

Func BestTarget_CaretakersCharge($aAggroRange)
	Return
EndFunc

; Skill ID: 1859 - $GC_I_SKILL_ID_ALTAR_BUFF
Func CanUse_AltarBuff()
	Return True
EndFunc

Func BestTarget_AltarBuff($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1866 - $GC_I_SKILL_ID_CAPTURE_POINT
Func CanUse_CapturePoint()
	Return True
EndFunc

Func BestTarget_CapturePoint($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1885 - $GC_I_SKILL_ID_BANISH_ENCHANTMENT
Func CanUse_BanishEnchantment()
	Return True
EndFunc

Func BestTarget_BanishEnchantment($aAggroRange)
	Return
EndFunc

; Skill ID: 1896 - $GC_I_SKILL_ID_UNYIELDING_ANGUISH
Func CanUse_UnyieldingAnguish()
	Return True
EndFunc

Func BestTarget_UnyieldingAnguish($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1938 - $GC_I_SKILL_ID_PUTRID_FLAMES
Func CanUse_PutridFlames()
	Return True
EndFunc

Func BestTarget_PutridFlames($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1983 - $GC_I_SKILL_ID_FIRE_DART
Func CanUse_FireDart()
	Return True
EndFunc

Func BestTarget_FireDart($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1984 - $GC_I_SKILL_ID_ICE_DART
Func CanUse_IceDart()
	Return True
EndFunc

Func BestTarget_IceDart($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1985 - $GC_I_SKILL_ID_POISON_DART
Func CanUse_PoisonDart()
	Return True
EndFunc

Func BestTarget_PoisonDart($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 1994 - $GC_I_SKILL_ID_POWER_LOCK
Func CanUse_PowerLock()
	Return True
EndFunc

Func BestTarget_PowerLock($aAggroRange)
	Return
EndFunc

; Skill ID: 1995 - $GC_I_SKILL_ID_WASTE_NOT_WANT_NOT
Func CanUse_WasteNotWantNot()
	Return True
EndFunc

Func BestTarget_WasteNotWantNot($aAggroRange)
	Return
EndFunc

; Skill ID: 2003 - $GC_I_SKILL_ID_CURE_HEX
Func CanUse_CureHex()
	Return True
EndFunc

Func BestTarget_CureHex($aAggroRange)
	Return
EndFunc

; Skill ID: 2004 - $GC_I_SKILL_ID_SMITE_CONDITION
Func CanUse_SmiteCondition()
	Return True
EndFunc

Func BestTarget_SmiteCondition($aAggroRange)
	Return
EndFunc

; Skill ID: 2019 - $GC_I_SKILL_ID_BURNING_GROUND
Func CanUse_BurningGround()
	Return True
EndFunc

Func BestTarget_BurningGround($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2020 - $GC_I_SKILL_ID_FREEZING_GROUND
Func CanUse_FreezingGround()
	Return True
EndFunc

Func BestTarget_FreezingGround($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2021 - $GC_I_SKILL_ID_POISON_GROUND
Func CanUse_PoisonGround()
	Return True
EndFunc

Func BestTarget_PoisonGround($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2022 - $GC_I_SKILL_ID_FIRE_JET
Func CanUse_FireJet()
	Return True
EndFunc

Func BestTarget_FireJet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2024 - $GC_I_SKILL_ID_POISON_JET
Func CanUse_PoisonJet()
	Return True
EndFunc

Func BestTarget_PoisonJet($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2027 - $GC_I_SKILL_ID_FIRE_SPOUT
Func CanUse_FireSpout()
	Return True
EndFunc

Func BestTarget_FireSpout($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2029 - $GC_I_SKILL_ID_POISON_SPOUT
Func CanUse_PoisonSpout()
	Return True
EndFunc

Func BestTarget_PoisonSpout($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2045 - $GC_I_SKILL_ID_SARCOPHAGUS_SPORES
Func CanUse_SarcophagusSpores()
	Return True
EndFunc

Func BestTarget_SarcophagusSpores($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2046 - $GC_I_SKILL_ID_EXPLODING_BARREL
Func CanUse_ExplodingBarrel()
	Return True
EndFunc

Func BestTarget_ExplodingBarrel($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2051 - $GC_I_SKILL_ID_SUMMON_SPIRITS_LUXON
Func CanUse_SummonSpiritsLuxon()
	Return True
EndFunc

Func BestTarget_SummonSpiritsLuxon($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2055 - $GC_I_SKILL_ID_ANEURYSM
Func CanUse_Aneurysm()
	Return True
EndFunc

Func BestTarget_Aneurysm($aAggroRange)
	Return
EndFunc

; Skill ID: 2057 - $GC_I_SKILL_ID_FOUL_FEAST
Func CanUse_FoulFeast()
	Return True
EndFunc

Func BestTarget_FoulFeast($aAggroRange)
	Return
EndFunc

; Skill ID: 2059 - $GC_I_SKILL_ID_SHELL_SHOCK
Func CanUse_ShellShock()
	Return True
EndFunc

Func BestTarget_ShellShock($aAggroRange)
	Return
EndFunc

; Skill ID: 2062 - $GC_I_SKILL_ID_HEALING_RIBBON
Func CanUse_HealingRibbon()
	Return True
EndFunc

Func BestTarget_HealingRibbon($aAggroRange)
	Return
EndFunc

; Skill ID: 2076 - $GC_I_SKILL_ID_DRAIN_MINION
Func CanUse_DrainMinion()
	Return True
EndFunc

Func BestTarget_DrainMinion($aAggroRange)
	Return
EndFunc

; Skill ID: 2079 - $GC_I_SKILL_ID_FLESHREAVERS_ESCAPE
Func CanUse_FleshreaversEscape()
	Return True
EndFunc

Func BestTarget_FleshreaversEscape($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2083 - $GC_I_SKILL_ID_MANDRAGORS_CHARGE
Func CanUse_MandragorsCharge()
	Return True
EndFunc

Func BestTarget_MandragorsCharge($aAggroRange)
	Return
EndFunc

; Skill ID: 2084 - $GC_I_SKILL_ID_ROCK_SLIDE
Func CanUse_RockSlide()
	Return True
EndFunc

Func BestTarget_RockSlide($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2085 - $GC_I_SKILL_ID_AVALANCHE_EFFECT
Func CanUse_AvalancheEffect()
	Return True
EndFunc

Func BestTarget_AvalancheEffect($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2087 - $GC_I_SKILL_ID_CEILING_COLLAPSE
Func CanUse_CeilingCollapse()
	Return True
EndFunc

Func BestTarget_CeilingCollapse($aAggroRange)
	Return
EndFunc

; Skill ID: 2100 - $GC_I_SKILL_ID_SUMMON_SPIRITS_KURZICK
Func CanUse_SummonSpiritsKurzick()
	Return True
EndFunc

Func BestTarget_SummonSpiritsKurzick($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2102 - $GC_I_SKILL_ID_CRY_OF_PAIN
Func CanUse_CryOfPain()
	Return True
EndFunc

Func BestTarget_CryOfPain($aAggroRange)
	Return
EndFunc

; Skill ID: 2161 - $GC_I_SKILL_ID_GOLEM_FIRE_SHIELD
Func CanUse_GolemFireShield()
	Return True
EndFunc

Func BestTarget_GolemFireShield($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2165 - $GC_I_SKILL_ID_DIAMONDSHARD_GRAVE
Func CanUse_DiamondshardGrave()
	Return True
EndFunc

Func BestTarget_DiamondshardGrave($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2167 - $GC_I_SKILL_ID_DIAMONDSHARD_MIST
Func CanUse_DiamondshardMist()
	Return True
EndFunc

Func BestTarget_DiamondshardMist($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2172 - $GC_I_SKILL_ID_RAVEN_SWOOP_A_GATE_TOO_FAR
Func CanUse_RavenSwoopAGateTooFar()
	Return True
EndFunc

Func BestTarget_RavenSwoopAGateTooFar($aAggroRange)
	Return
EndFunc

; Skill ID: 2189 - $GC_I_SKILL_ID_ANGORODONS_GAZE
Func CanUse_AngorodonsGaze()
	Return True
EndFunc

Func BestTarget_AngorodonsGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 2191 - $GC_I_SKILL_ID_SLIPPERY_GROUND
Func CanUse_SlipperyGround()
	Return True
EndFunc

Func BestTarget_SlipperyGround($aAggroRange)
	Return
EndFunc

; Skill ID: 2192 - $GC_I_SKILL_ID_GLOWING_ICE
Func CanUse_GlowingIce()
	Return True
EndFunc

Func BestTarget_GlowingIce($aAggroRange)
	Return
EndFunc

; Skill ID: 2193 - $GC_I_SKILL_ID_ENERGY_BLAST
Func CanUse_EnergyBlast()
	Return True
EndFunc

Func BestTarget_EnergyBlast($aAggroRange)
	Return
EndFunc

; Skill ID: 2202 - $GC_I_SKILL_ID_MENDING_GRIP
Func CanUse_MendingGrip()
	Return True
EndFunc

Func BestTarget_MendingGrip($aAggroRange)
	Return
EndFunc

; Skill ID: 2211 - $GC_I_SKILL_ID_ALKARS_ALCHEMICAL_ACID
Func CanUse_AlkarsAlchemicalAcid()
	Return True
EndFunc

Func BestTarget_AlkarsAlchemicalAcid($aAggroRange)
	Return
EndFunc

; Skill ID: 2212 - $GC_I_SKILL_ID_LIGHT_OF_DELDRIMOR
Func CanUse_LightOfDeldrimor()
	Return True
EndFunc

Func BestTarget_LightOfDeldrimor($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2221 - $GC_I_SKILL_ID_BREATH_OF_THE_GREAT_DWARF
Func CanUse_BreathOfTheGreatDwarf()
	Return True
EndFunc

Func BestTarget_BreathOfTheGreatDwarf($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2222 - $GC_I_SKILL_ID_SNOW_STORM
Func CanUse_SnowStorm()
	Return True
EndFunc

Func BestTarget_SnowStorm($aAggroRange)
	Return
EndFunc

; Skill ID: 2224 - $GC_I_SKILL_ID_SUMMON_MURSAAT
Func CanUse_SummonMursaat()
	Return True
EndFunc

Func BestTarget_SummonMursaat($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2225 - $GC_I_SKILL_ID_SUMMON_RUBY_DJINN
Func CanUse_SummonRubyDjinn()
	Return True
EndFunc

Func BestTarget_SummonRubyDjinn($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2226 - $GC_I_SKILL_ID_SUMMON_ICE_IMP
Func CanUse_SummonIceImp()
	Return True
EndFunc

Func BestTarget_SummonIceImp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2227 - $GC_I_SKILL_ID_SUMMON_NAGA_SHAMAN
Func CanUse_SummonNagaShaman()
	Return True
EndFunc

Func BestTarget_SummonNagaShaman($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2234 - $GC_I_SKILL_ID_EBON_VANGUARD_SNIPER_SUPPORT
Func CanUse_EbonVanguardSniperSupport()
	Return True
EndFunc

Func BestTarget_EbonVanguardSniperSupport($aAggroRange)
	Return
EndFunc

; Skill ID: 2235 - $GC_I_SKILL_ID_EBON_VANGUARD_ASSASSIN_SUPPORT
Func CanUse_EbonVanguardAssassinSupport()
	Return True
EndFunc

Func BestTarget_EbonVanguardAssassinSupport($aAggroRange)
	Return
EndFunc

; Skill ID: 2248 - $GC_I_SKILL_ID_POLYMOCK_POWER_DRAIN
Func CanUse_PolymockPowerDrain()
	Return True
EndFunc

Func BestTarget_PolymockPowerDrain($aAggroRange)
	Return
EndFunc

; Skill ID: 2253 - $GC_I_SKILL_ID_POLYMOCK_OVERLOAD
Func CanUse_PolymockOverload()
	Return True
EndFunc

Func BestTarget_PolymockOverload($aAggroRange)
	Return
EndFunc

; Skill ID: 2256 - $GC_I_SKILL_ID_ORDER_OF_UNHOLY_VIGOR
Func CanUse_OrderOfUnholyVigor()
	Return True
EndFunc

Func BestTarget_OrderOfUnholyVigor($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2257 - $GC_I_SKILL_ID_ORDER_OF_THE_LICH
Func CanUse_OrderOfTheLich()
	Return True
EndFunc

Func BestTarget_OrderOfTheLich($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2258 - $GC_I_SKILL_ID_MASTER_OF_NECROMANCY
Func CanUse_MasterOfNecromancy()
	Return True
EndFunc

Func BestTarget_MasterOfNecromancy($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2259 - $GC_I_SKILL_ID_ANIMATE_UNDEAD
Func CanUse_AnimateUndead()
	Return True
EndFunc

Func BestTarget_AnimateUndead($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2260 - $GC_I_SKILL_ID_POLYMOCK_DEATHLY_CHILL
Func CanUse_PolymockDeathlyChill()
	Return True
EndFunc

Func BestTarget_PolymockDeathlyChill($aAggroRange)
	Return
EndFunc

; Skill ID: 2262 - $GC_I_SKILL_ID_POLYMOCK_ROTTING_FLESH
Func CanUse_PolymockRottingFlesh()
	Return True
EndFunc

Func BestTarget_PolymockRottingFlesh($aAggroRange)
	Return
EndFunc

; Skill ID: 2263 - $GC_I_SKILL_ID_POLYMOCK_LIGHTNING_STRIKE
Func CanUse_PolymockLightningStrike()
	Return True
EndFunc

Func BestTarget_PolymockLightningStrike($aAggroRange)
	Return
EndFunc

; Skill ID: 2264 - $GC_I_SKILL_ID_POLYMOCK_LIGHTNING_ORB
Func CanUse_PolymockLightningOrb()
	Return True
EndFunc

Func BestTarget_PolymockLightningOrb($aAggroRange)
	Return
EndFunc

; Skill ID: 2266 - $GC_I_SKILL_ID_POLYMOCK_FLARE
Func CanUse_PolymockFlare()
	Return True
EndFunc

Func BestTarget_PolymockFlare($aAggroRange)
	Return
EndFunc

; Skill ID: 2267 - $GC_I_SKILL_ID_POLYMOCK_IMMOLATE
Func CanUse_PolymockImmolate()
	Return True
EndFunc

Func BestTarget_PolymockImmolate($aAggroRange)
	Return
EndFunc

; Skill ID: 2268 - $GC_I_SKILL_ID_POLYMOCK_METEOR
Func CanUse_PolymockMeteor()
	Return True
EndFunc

Func BestTarget_PolymockMeteor($aAggroRange)
	Return
EndFunc

; Skill ID: 2269 - $GC_I_SKILL_ID_POLYMOCK_ICE_SPEAR
Func CanUse_PolymockIceSpear()
	Return True
EndFunc

Func BestTarget_PolymockIceSpear($aAggroRange)
	Return
EndFunc

; Skill ID: 2270 - $GC_I_SKILL_ID_POLYMOCK_ICY_PRISON
Func CanUse_PolymockIcyPrison()
	Return True
EndFunc

Func BestTarget_PolymockIcyPrison($aAggroRange)
	Return
EndFunc

; Skill ID: 2271 - $GC_I_SKILL_ID_POLYMOCK_MIND_FREEZE
Func CanUse_PolymockMindFreeze()
	Return True
EndFunc

Func BestTarget_PolymockMindFreeze($aAggroRange)
	Return
EndFunc

; Skill ID: 2272 - $GC_I_SKILL_ID_POLYMOCK_ICE_SHARD_STORM
Func CanUse_PolymockIceShardStorm()
	Return True
EndFunc

Func BestTarget_PolymockIceShardStorm($aAggroRange)
	Return
EndFunc

; Skill ID: 2273 - $GC_I_SKILL_ID_POLYMOCK_FROZEN_TRIDENT
Func CanUse_PolymockFrozenTrident()
	Return True
EndFunc

Func BestTarget_PolymockFrozenTrident($aAggroRange)
	Return
EndFunc

; Skill ID: 2274 - $GC_I_SKILL_ID_POLYMOCK_SMITE
Func CanUse_PolymockSmite()
	Return True
EndFunc

Func BestTarget_PolymockSmite($aAggroRange)
	Return
EndFunc

; Skill ID: 2275 - $GC_I_SKILL_ID_POLYMOCK_SMITE_HEX
Func CanUse_PolymockSmiteHex()
	Return True
EndFunc

Func BestTarget_PolymockSmiteHex($aAggroRange)
	Return
EndFunc

; Skill ID: 2277 - $GC_I_SKILL_ID_POLYMOCK_STONE_DAGGERS
Func CanUse_PolymockStoneDaggers()
	Return True
EndFunc

Func BestTarget_PolymockStoneDaggers($aAggroRange)
	Return
EndFunc

; Skill ID: 2278 - $GC_I_SKILL_ID_POLYMOCK_OBSIDIAN_FLAME
Func CanUse_PolymockObsidianFlame()
	Return True
EndFunc

Func BestTarget_PolymockObsidianFlame($aAggroRange)
	Return
EndFunc

; Skill ID: 2279 - $GC_I_SKILL_ID_POLYMOCK_EARTHQUAKE
Func CanUse_PolymockEarthquake()
	Return True
EndFunc

Func BestTarget_PolymockEarthquake($aAggroRange)
	Return
EndFunc

; Skill ID: 2282 - $GC_I_SKILL_ID_POLYMOCK_FIREBALL
Func CanUse_PolymockFireball()
	Return True
EndFunc

Func BestTarget_PolymockFireball($aAggroRange)
	Return
EndFunc

; Skill ID: 2283 - $GC_I_SKILL_ID_POLYMOCK_RODGORTS_INVOCATION
Func CanUse_PolymockRodgortsInvocation()
	Return True
EndFunc

Func BestTarget_PolymockRodgortsInvocation($aAggroRange)
	Return
EndFunc

; Skill ID: 2288 - $GC_I_SKILL_ID_POLYMOCK_LAMENTATION
Func CanUse_PolymockLamentation()
	Return True
EndFunc

Func BestTarget_PolymockLamentation($aAggroRange)
	Return
EndFunc

; Skill ID: 2289 - $GC_I_SKILL_ID_POLYMOCK_SPIRIT_RIFT
Func CanUse_PolymockSpiritRift()
	Return True
EndFunc

Func BestTarget_PolymockSpiritRift($aAggroRange)
	Return
EndFunc

; Skill ID: 2293 - $GC_I_SKILL_ID_POLYMOCK_GLOWING_GAZE
Func CanUse_PolymockGlowingGaze()
	Return True
EndFunc

Func BestTarget_PolymockGlowingGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 2294 - $GC_I_SKILL_ID_POLYMOCK_SEARING_FLAMES
Func CanUse_PolymockSearingFlames()
	Return True
EndFunc

Func BestTarget_PolymockSearingFlames($aAggroRange)
	Return
EndFunc

; Skill ID: 2297 - $GC_I_SKILL_ID_POLYMOCK_STONING
Func CanUse_PolymockStoning()
	Return True
EndFunc

Func BestTarget_PolymockStoning($aAggroRange)
	Return
EndFunc

; Skill ID: 2298 - $GC_I_SKILL_ID_POLYMOCK_ERUPTION
Func CanUse_PolymockEruption()
	Return True
EndFunc

Func BestTarget_PolymockEruption($aAggroRange)
	Return
EndFunc

; Skill ID: 2299 - $GC_I_SKILL_ID_POLYMOCK_SHOCK_ARROW
Func CanUse_PolymockShockArrow()
	Return True
EndFunc

Func BestTarget_PolymockShockArrow($aAggroRange)
	Return
EndFunc

; Skill ID: 2300 - $GC_I_SKILL_ID_POLYMOCK_MIND_SHOCK
Func CanUse_PolymockMindShock()
	Return True
EndFunc

Func BestTarget_PolymockMindShock($aAggroRange)
	Return
EndFunc

; Skill ID: 2301 - $GC_I_SKILL_ID_POLYMOCK_PIERCING_LIGHT_SPEAR
Func CanUse_PolymockPiercingLightSpear()
	Return True
EndFunc

Func BestTarget_PolymockPiercingLightSpear($aAggroRange)
	Return
EndFunc

; Skill ID: 2302 - $GC_I_SKILL_ID_POLYMOCK_MIND_BLAST
Func CanUse_PolymockMindBlast()
	Return True
EndFunc

Func BestTarget_PolymockMindBlast($aAggroRange)
	Return
EndFunc

; Skill ID: 2303 - $GC_I_SKILL_ID_POLYMOCK_SAVANNAH_HEAT
Func CanUse_PolymockSavannahHeat()
	Return True
EndFunc

Func BestTarget_PolymockSavannahHeat($aAggroRange)
	Return
EndFunc

; Skill ID: 2305 - $GC_I_SKILL_ID_POLYMOCK_LIGHTNING_BLAST
Func CanUse_PolymockLightningBlast()
	Return True
EndFunc

Func BestTarget_PolymockLightningBlast($aAggroRange)
	Return
EndFunc

; Skill ID: 2306 - $GC_I_SKILL_ID_POLYMOCK_POISONED_GROUND
Func CanUse_PolymockPoisonedGround()
	Return True
EndFunc

Func BestTarget_PolymockPoisonedGround($aAggroRange)
	Return
EndFunc

; Skill ID: 2308 - $GC_I_SKILL_ID_POLYMOCK_SANDSTORM
Func CanUse_PolymockSandstorm()
	Return True
EndFunc

Func BestTarget_PolymockSandstorm($aAggroRange)
	Return
EndFunc

; Skill ID: 2309 - $GC_I_SKILL_ID_POLYMOCK_BANISH
Func CanUse_PolymockBanish()
	Return True
EndFunc

Func BestTarget_PolymockBanish($aAggroRange)
	Return
EndFunc

; Skill ID: 2368 - $GC_I_SKILL_ID_MURAKAIS_CONSUMPTION
Func CanUse_MurakaisConsumption()
	Return True
EndFunc

Func BestTarget_MurakaisConsumption($aAggroRange)
	Return
EndFunc

; Skill ID: 2369 - $GC_I_SKILL_ID_MURAKAIS_CENSURE
Func CanUse_MurakaisCensure()
	Return True
EndFunc

Func BestTarget_MurakaisCensure($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2370 - $GC_I_SKILL_ID_MURAKAIS_CALAMITY
Func CanUse_MurakaisCalamity()
	Return True
EndFunc

Func BestTarget_MurakaisCalamity($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2371 - $GC_I_SKILL_ID_MURAKAIS_STORM_OF_SOULS
Func CanUse_MurakaisStormOfSouls()
	Return True
EndFunc

Func BestTarget_MurakaisStormOfSouls($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2386 - $GC_I_SKILL_ID_RAVEN_SWOOP
Func CanUse_RavenSwoop()
	Return True
EndFunc

Func BestTarget_RavenSwoop($aAggroRange)
	Return
EndFunc

; Skill ID: 2390 - $GC_I_SKILL_ID_FILTHY_EXPLOSION
Func CanUse_FilthyExplosion()
	Return True
EndFunc

Func BestTarget_FilthyExplosion($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2391 - $GC_I_SKILL_ID_MURAKAIS_CALL
Func CanUse_MurakaisCall()
	Return True
EndFunc

Func BestTarget_MurakaisCall($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2398 - $GC_I_SKILL_ID_CONSUME_FLAMES
Func CanUse_ConsumeFlames()
	Return True
EndFunc

Func BestTarget_ConsumeFlames($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2412 - $GC_I_SKILL_ID_SMOOTH_CRIMINAL
Func CanUse_SmoothCriminal()
	Return True
EndFunc

Func BestTarget_SmoothCriminal($aAggroRange)
	Return
EndFunc

; Skill ID: 2413 - $GC_I_SKILL_ID_TECHNOBABBLE
Func CanUse_Technobabble()
	Return True
EndFunc

Func BestTarget_Technobabble($aAggroRange)
	Return
EndFunc

; Skill ID: 2420 - $GC_I_SKILL_ID_EBON_ESCAPE
Func CanUse_EbonEscape()
	Return True
EndFunc

Func BestTarget_EbonEscape($aAggroRange)
	Return
EndFunc

; Skill ID: 2487 - $GC_I_SKILL_ID_DRYDERS_FEAST
Func CanUse_DrydersFeast()
	Return True
EndFunc

Func BestTarget_DrydersFeast($aAggroRange)
	Return
EndFunc

; Skill ID: 2517 - $GC_I_SKILL_ID_REVERSE_POLARITY_FIRE_SHIELD
Func CanUse_ReversePolarityFireShield()
	Return True
EndFunc

Func BestTarget_ReversePolarityFireShield($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2538 - $GC_I_SKILL_ID_ANIMATE_UNDEAD_PALAWA_JOKO
Func CanUse_AnimateUndeadPalawaJoko()
	Return True
EndFunc

Func BestTarget_AnimateUndeadPalawaJoko($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2539 - $GC_I_SKILL_ID_ORDER_OF_UNHOLY_VIGOR_PALAWA_JOKO
Func CanUse_OrderOfUnholyVigorPalawaJoko()
	Return True
EndFunc

Func BestTarget_OrderOfUnholyVigorPalawaJoko($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2540 - $GC_I_SKILL_ID_ORDER_OF_THE_LICH_PALAWA_JOKO
Func CanUse_OrderOfTheLichPalawaJoko()
	Return True
EndFunc

Func BestTarget_OrderOfTheLichPalawaJoko($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2543 - $GC_I_SKILL_ID_WURM_SIEGE_EYE_OF_THE_NORTH
Func CanUse_WurmSiegeEyeOfTheNorth()
	Return True
EndFunc

Func BestTarget_WurmSiegeEyeOfTheNorth($aAggroRange)
	Return
EndFunc

; Skill ID: 2626 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2628 - $GC_I_SKILL_ID_ENFEEBLE2
Func CanUse_Enfeeble2()
	Return True
EndFunc

Func BestTarget_Enfeeble2($aAggroRange)
	Return
EndFunc

; Skill ID: 2629 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2632 - $GC_I_SKILL_ID_SEARING_FLAMES2
Func CanUse_SearingFlames2()
	Return True
EndFunc

Func BestTarget_SearingFlames2($aAggroRange)
	Return
EndFunc

; Skill ID: 2633 - $GC_I_SKILL_ID_GLOWING_GAZE2
Func CanUse_GlowingGaze2()
	Return True
EndFunc

Func BestTarget_GlowingGaze2($aAggroRange)
	Return
EndFunc

; Skill ID: 2634 - $GC_I_SKILL_ID_STEAM2
Func CanUse_Steam2()
	Return True
EndFunc

Func BestTarget_Steam2($aAggroRange)
	Return
EndFunc

; Skill ID: 2636 - $GC_I_SKILL_ID_LIQUID_FLAM2
Func CanUse_LiquidFlam2()
	Return True
EndFunc

Func BestTarget_LiquidFlam2($aAggroRange)
	Return
EndFunc

; Skill ID: 2637 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2639 - $GC_I_SKILL_ID_SMITE_CONDITION2
Func CanUse_SmiteCondition2()
	Return True
EndFunc

Func BestTarget_SmiteCondition2($aAggroRange)
	Return
EndFunc

; Skill ID: 2664 - $GC_I_SKILL_ID_SPIKE_TRAP_SPELL
Func CanUse_SpikeTrapSpell()
	Return True
EndFunc

Func BestTarget_SpikeTrapSpell($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2666 - $GC_I_SKILL_ID_FIRE_AND_BRIMSTONE
Func CanUse_FireAndBrimstone()
	Return True
EndFunc

Func BestTarget_FireAndBrimstone($aAggroRange)
	Return
EndFunc

; Skill ID: 2686 - $GC_I_SKILL_ID_ESSENCE_STRIKE_TOGO
Func CanUse_EssenceStrikeTogo()
	Return True
EndFunc

Func BestTarget_EssenceStrikeTogo($aAggroRange)
	Return
EndFunc

; Skill ID: 2687 - $GC_I_SKILL_ID_SPIRIT_BURN_TOGO
Func CanUse_SpiritBurnTogo()
	Return True
EndFunc

Func BestTarget_SpiritBurnTogo($aAggroRange)
	Return
EndFunc

; Skill ID: 2688 - $GC_I_SKILL_ID_SPIRIT_RIFT_TOGO
Func CanUse_SpiritRiftTogo()
	Return True
EndFunc

Func BestTarget_SpiritRiftTogo($aAggroRange)
	Return
EndFunc

; Skill ID: 2689 - $GC_I_SKILL_ID_MEND_BODY_AND_SOUL_TOGO
Func CanUse_MendBodyAndSoulTogo()
	Return True
EndFunc

Func BestTarget_MendBodyAndSoulTogo($aAggroRange)
	Return
EndFunc

; Skill ID: 2690 - $GC_I_SKILL_ID_OFFERING_OF_SPIRIT_TOGO
Func CanUse_OfferingOfSpiritTogo()
	Return True
EndFunc

Func BestTarget_OfferingOfSpiritTogo($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2722 - $GC_I_SKILL_ID_REDEMPTION_OF_PURITY
Func CanUse_RedemptionOfPurity()
	Return True
EndFunc

Func BestTarget_RedemptionOfPurity($aAggroRange)
	Return
EndFunc

; Skill ID: 2723 - $GC_I_SKILL_ID_PURIFY_ENERGY
Func CanUse_PurifyEnergy()
	Return True
EndFunc

Func BestTarget_PurifyEnergy($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2724 - $GC_I_SKILL_ID_PURIFYING_FLAME
Func CanUse_PurifyingFlame()
	Return True
EndFunc

Func BestTarget_PurifyingFlame($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2725 - $GC_I_SKILL_ID_PURIFYING_PRAYER
Func CanUse_PurifyingPrayer()
	Return True
EndFunc

Func BestTarget_PurifyingPrayer($aAggroRange)
	Return
EndFunc

; Skill ID: 2729 - $GC_I_SKILL_ID_PURIFY_SOUL
Func CanUse_PurifySoul()
	Return True
EndFunc

Func BestTarget_PurifySoul($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2755 - $GC_I_SKILL_ID_JADE_BROTHERHOOD_BOMB
Func CanUse_JadeBrotherhoodBomb()
	Return True
EndFunc

Func BestTarget_JadeBrotherhoodBomb($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2759 - $GC_I_SKILL_ID_ROCKET_PROPELLED_GOBSTOPPER
Func CanUse_RocketPropelledGobstopper()
	Return True
EndFunc

Func BestTarget_RocketPropelledGobstopper($aAggroRange)
	Return
EndFunc

; Skill ID: 2760 - $GC_I_SKILL_ID_RAIN_OF_TERROR_SPELL
Func CanUse_RainOfTerrorSpell()
	Return True
EndFunc

Func BestTarget_RainOfTerrorSpell($aAggroRange)
	Return
EndFunc

; Skill ID: 2762 - $GC_I_SKILL_ID_SUGAR_INFUSION
Func CanUse_SugarInfusion()
	Return True
EndFunc

Func BestTarget_SugarInfusion($aAggroRange)
	Return
EndFunc

; Skill ID: 2763 - $GC_I_SKILL_ID_FEAST_OF_VENGEANCE
Func CanUse_FeastOfVengeance()
	Return True
EndFunc

Func BestTarget_FeastOfVengeance($aAggroRange)
	Return
EndFunc

; Skill ID: 2764 - $GC_I_SKILL_ID_ANIMATE_CANDY_MINIONS
Func CanUse_AnimateCandyMinions()
	Return True
EndFunc

Func BestTarget_AnimateCandyMinions($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2765 - $GC_I_SKILL_ID_TASTE_OF_UNDEATH
Func CanUse_TasteOfUndeath()
	Return True
EndFunc

Func BestTarget_TasteOfUndeath($aAggroRange)
	Return
EndFunc

; Skill ID: 2766 - $GC_I_SKILL_ID_SCOURGE_OF_CANDY
Func CanUse_ScourgeOfCandy()
	Return True
EndFunc

Func BestTarget_ScourgeOfCandy($aAggroRange)
	Return
EndFunc

; Skill ID: 2768 - $GC_I_SKILL_ID_MAD_KING_PONY_SUPPORT
Func CanUse_MadKingPonySupport()
	Return True
EndFunc

Func BestTarget_MadKingPonySupport($aAggroRange)
	Return
EndFunc

; Skill ID: 2789 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2790 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2795 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2796 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2799 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2804 - $GC_I_SKILL_ID_MIND_SHOCK_PVP
Func CanUse_MindShockPvp()
	Return True
EndFunc

Func BestTarget_MindShockPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2807 - $GC_I_SKILL_ID_RIDE_THE_LIGHTNING_PVP
Func CanUse_RideTheLightningPvp()
	Return True
EndFunc

Func BestTarget_RideTheLightningPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2809 - $GC_I_SKILL_ID_OBSIDIAN_FLAME_PVP
Func CanUse_ObsidianFlamePvp()
	Return True
EndFunc

Func BestTarget_ObsidianFlamePvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2833 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2835 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2836 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2852 - $GC_I_SKILL_ID_ENERGY_DRAIN_PVP
Func CanUse_EnergyDrainPvp()
	Return True
EndFunc

Func BestTarget_EnergyDrainPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2853 - $GC_I_SKILL_ID_ENERGY_TAP_PVP
Func CanUse_EnergyTapPvp()
	Return True
EndFunc

Func BestTarget_EnergyTapPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2856 - $GC_I_SKILL_ID_LIGHTNING_ORB_PVP
Func CanUse_LightningOrbPvp()
	Return True
EndFunc

Func BestTarget_LightningOrbPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2859 - $GC_I_SKILL_ID_ENFEEBLE_PVP
Func CanUse_EnfeeblePvp()
	Return True
EndFunc

Func BestTarget_EnfeeblePvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2863 - $GC_I_SKILL_ID_DISCORD_PVP
Func CanUse_DiscordPvp()
	Return True
EndFunc

Func BestTarget_DiscordPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2866 - $GC_I_SKILL_ID_FLESH_OF_MY_FLESH_PVP
Func CanUse_FleshOfMyFleshPvp()
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Or Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then Return False
	Return True
EndFunc

Func BestTarget_FleshOfMyFleshPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2870 - $GC_I_SKILL_ID_BLINDING_SURGE_PVP
Func CanUse_BlindingSurgePvp()
	Return True
EndFunc

Func BestTarget_BlindingSurgePvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2871 - $GC_I_SKILL_ID_LIGHT_OF_DELIVERANCE_PVP
Func CanUse_LightOfDeliverancePvp()
	Return True
EndFunc

Func BestTarget_LightOfDeliverancePvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2881 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2885 - $GC_I_SKILL_ID_ENFEEBLING_BLOOD_PVP
Func CanUse_EnfeeblingBloodPvp()
	Return True
EndFunc

Func BestTarget_EnfeeblingBloodPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 2902 - $GC_I_SKILL_ID_REACTOR_BLAST
Func CanUse_ReactorBlast()
	Return True
EndFunc

Func BestTarget_ReactorBlast($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2907 - $GC_I_SKILL_ID_NOX_BEAM
Func CanUse_NoxBeam()
	Return True
EndFunc

Func BestTarget_NoxBeam($aAggroRange)
	Return
EndFunc

; Skill ID: 2909 - $GC_I_SKILL_ID_NOXION_BUSTER
Func CanUse_NoxionBuster()
	Return True
EndFunc

Func BestTarget_NoxionBuster($aAggroRange)
	Return
EndFunc

; Skill ID: 2911 - $GC_I_SKILL_ID_BIT_GOLEM_BREAKER
Func CanUse_BitGolemBreaker()
	Return True
EndFunc

Func BestTarget_BitGolemBreaker($aAggroRange)
	Return
EndFunc

; Skill ID: 2913 - $GC_I_SKILL_ID_BIT_GOLEM_CRASH
Func CanUse_BitGolemCrash()
	Return True
EndFunc

Func BestTarget_BitGolemCrash($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2914 - $GC_I_SKILL_ID_BIT_GOLEM_FORCE
Func CanUse_BitGolemForce()
	Return True
EndFunc

Func BestTarget_BitGolemForce($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2917 - $GC_I_SKILL_ID_NOX_THUNDER
Func CanUse_NoxThunder()
	Return True
EndFunc

Func BestTarget_NoxThunder($aAggroRange)
	Return
EndFunc

; Skill ID: 2920 - $GC_I_SKILL_ID_NOX_FIRE
Func CanUse_NoxFire()
	Return True
EndFunc

Func BestTarget_NoxFire($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2921 - $GC_I_SKILL_ID_NOX_KNUCKLE
Func CanUse_NoxKnuckle()
	Return True
EndFunc

Func BestTarget_NoxKnuckle($aAggroRange)
	Return
EndFunc

; Skill ID: 2922 - $GC_I_SKILL_ID_NOX_DIVIDER_DRIVE
Func CanUse_NoxDividerDrive()
	Return True
EndFunc

Func BestTarget_NoxDividerDrive($aAggroRange)
	Return
EndFunc

; Skill ID: 2927 - $GC_I_SKILL_ID_SHRINE_BACKLASH
Func CanUse_ShrineBacklash()
	Return True
EndFunc

Func BestTarget_ShrineBacklash($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2935 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2938 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2939 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2940 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2941 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2946 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2952 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2957 - $GC_I_SKILL_ID_WESTERN_HEALTH_SHRINE_BONUS
Func CanUse_WesternHealthShrineBonus()
	Return True
EndFunc

Func BestTarget_WesternHealthShrineBonus($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2958 - $GC_I_SKILL_ID_EASTERN_HEALTH_SHRINE_BONUS
Func CanUse_EasternHealthShrineBonus()
	Return True
EndFunc

Func BestTarget_EasternHealthShrineBonus($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 2964 - $GC_I_SKILL_ID_SNOWBALL2
Func CanUse_Snowball2()
	Return True
EndFunc

Func BestTarget_Snowball2($aAggroRange)
	Return
EndFunc

; Skill ID: 3021 - $GC_I_SKILL_ID_SAVANNAH_HEAT_PVP
Func CanUse_SavannahHeatPvp()
	Return True
EndFunc

Func BestTarget_SavannahHeatPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3044 - $GC_I_SKILL_ID_SPIRIT_SIPHON_MASTER_RIYO
Func CanUse_SpiritSiphonMasterRiyo()
	Return True
EndFunc

Func BestTarget_SpiritSiphonMasterRiyo($aAggroRange)
	Return
EndFunc

; Skill ID: 3058 - $GC_I_SKILL_ID_UNHOLY_FEAST_PVP
Func CanUse_UnholyFeastPvp()
	Return True
EndFunc

Func BestTarget_UnholyFeastPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3076 - $GC_I_SKILL_ID_EVERLASTING_MOBSTOPPER_SKILL
Func CanUse_EverlastingMobstopperSkill()
	Return True
EndFunc

Func BestTarget_EverlastingMobstopperSkill($aAggroRange)
	Return
EndFunc

; Skill ID: 3078 - $GC_I_SKILL_ID_CURSE_OF_DHUUM
Func CanUse_CurseOfDhuum()
	Return True
EndFunc

Func BestTarget_CurseOfDhuum($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3079 - $GC_I_SKILL_ID_DHUUMS_REST_REAPER_SKILL
Func CanUse_DhuumsRestReaperSkill()
	Return True
EndFunc

Func BestTarget_DhuumsRestReaperSkill($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3081 - $GC_I_SKILL_ID_SUMMON_CHAMPION
Func CanUse_SummonChampion()
	Return True
EndFunc

Func BestTarget_SummonChampion($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3082 - $GC_I_SKILL_ID_SUMMON_MINIONS
Func CanUse_SummonMinions()
	Return True
EndFunc

Func BestTarget_SummonMinions($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3085 - $GC_I_SKILL_ID_JUDGMENT_OF_DHUUM
Func CanUse_JudgmentOfDhuum()
	Return True
EndFunc

Func BestTarget_JudgmentOfDhuum($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3087 - $GC_I_SKILL_ID_DHUUMS_REST
Func CanUse_DhuumsRest()
	Return True
EndFunc

Func BestTarget_DhuumsRest($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3088 - $GC_I_SKILL_ID_SPIRITUAL_HEALING
Func CanUse_SpiritualHealing()
	Return True
EndFunc

Func BestTarget_SpiritualHealing($aAggroRange)
	Return
EndFunc

; Skill ID: 3089 - $GC_I_SKILL_ID_ENCASE_SKELETAL
Func CanUse_EncaseSkeletal()
	Return True
EndFunc

Func BestTarget_EncaseSkeletal($aAggroRange)
	Return
EndFunc

; Skill ID: 3090 - $GC_I_SKILL_ID_REVERSAL_OF_DEATH
Func CanUse_ReversalOfDeath()
	Return True
EndFunc

Func BestTarget_ReversalOfDeath($aAggroRange)
	Return
EndFunc

; Skill ID: 3091 - $GC_I_SKILL_ID_GHOSTLY_FURY
Func CanUse_GhostlyFury()
	Return True
EndFunc

Func BestTarget_GhostlyFury($aAggroRange)
	Return
EndFunc

; Skill ID: 3135 - $GC_I_SKILL_ID_SPIRITUAL_HEALING_REAPER_SKILL
Func CanUse_SpiritualHealingReaperSkill()
	Return True
EndFunc

Func BestTarget_SpiritualHealingReaperSkill($aAggroRange)
	Return
EndFunc

; Skill ID: 3136 - $GC_I_SKILL_ID_GHOSTLY_FURY_REAPER_SKILL
Func CanUse_GhostlyFuryReaperSkill()
	Return True
EndFunc

Func BestTarget_GhostlyFuryReaperSkill($aAggroRange)
	Return
EndFunc

; Skill ID: 3165 - $GC_I_SKILL_ID_GOLEM_PILEBUNKER
Func CanUse_GolemPilebunker()
	Return True
EndFunc

Func BestTarget_GolemPilebunker($aAggroRange)
	Return
EndFunc

; Skill ID: 3167 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3168 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3169 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3170 - $GC_I_SKILL_ID_KOROS_GAZE
Func CanUse_KorosGaze()
	Return True
EndFunc

Func BestTarget_KorosGaze($aAggroRange)
	Return
EndFunc

; Skill ID: 3171 - $GC_I_SKILL_ID_EBON_VANGUARD_ASSASSIN_SUPPORT_NPC
Func CanUse_EbonVanguardAssassinSupportNpc()
	Return True
EndFunc

Func BestTarget_EbonVanguardAssassinSupportNpc($aAggroRange)
	Return
EndFunc

; Skill ID: 3180 - $GC_I_SKILL_ID_SHATTER_DELUSIONS_PVP
Func CanUse_ShatterDelusionsPvp()
	Return True
EndFunc

Func BestTarget_ShatterDelusionsPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3184 - $GC_I_SKILL_ID_ACCUMULATED_PAIN_PVP
Func CanUse_AccumulatedPainPvp()
	Return True
EndFunc

Func BestTarget_AccumulatedPainPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3185 - $GC_I_SKILL_ID_PSYCHIC_INSTABILITY_PVP
Func CanUse_PsychicInstabilityPvp()
	Return True
EndFunc

Func BestTarget_PsychicInstabilityPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3189 - $GC_I_SKILL_ID_SPIRITUAL_PAIN_PVP
Func CanUse_SpiritualPainPvp()
	Return True
EndFunc

Func BestTarget_SpiritualPainPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3194 - $GC_I_SKILL_ID_MIRROR_OF_DISENCHANTMENT_PVP
Func CanUse_MirrorOfDisenchantmentPvp()
	Return True
EndFunc

Func BestTarget_MirrorOfDisenchantmentPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3197 - $GC_I_SKILL_ID_ADORATION
Func CanUse_Adoration()
	Return True
EndFunc

Func BestTarget_Adoration($aAggroRange)
	Return
EndFunc

; Skill ID: 3232 - $GC_I_SKILL_ID_HEAL_PARTY_PVP
Func CanUse_HealPartyPvp()
	Return True
EndFunc

Func BestTarget_HealPartyPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3242 - $GC_I_SKILL_ID_COMING_OF_SPRING
Func CanUse_ComingOfSpring()
	Return True
EndFunc

Func BestTarget_ComingOfSpring($aAggroRange)
	Return
EndFunc

; Skill ID: 3245 - $GC_I_SKILL_ID_DEATHS_EMBRACE
Func CanUse_DeathsEmbrace()
	Return True
EndFunc

Func BestTarget_DeathsEmbrace($aAggroRange)
	Return
EndFunc

; Skill ID: 3253 - $GC_I_SKILL_ID_ULTRA_SNOWBALL
Func CanUse_UltraSnowball()
	Return True
EndFunc

Func BestTarget_UltraSnowball($aAggroRange)
	Return
EndFunc

; Skill ID: 3254 - $GC_I_SKILL_ID_BLIZZARD
Func CanUse_Blizzard()
	Return True
EndFunc

Func BestTarget_Blizzard($aAggroRange)
	Return
EndFunc

; Skill ID: 3259 - $GC_I_SKILL_ID_ULTRA_SNOWBALL2
Func CanUse_UltraSnowball2()
	Return True
EndFunc

Func BestTarget_UltraSnowball2($aAggroRange)
	Return
EndFunc

; Skill ID: 3260 - $GC_I_SKILL_ID_ULTRA_SNOWBALL3
Func CanUse_UltraSnowball3()
	Return True
EndFunc

Func BestTarget_UltraSnowball3($aAggroRange)
	Return
EndFunc

; Skill ID: 3261 - $GC_I_SKILL_ID_ULTRA_SNOWBALL4
Func CanUse_UltraSnowball4()
	Return True
EndFunc

Func BestTarget_UltraSnowball4($aAggroRange)
	Return
EndFunc

; Skill ID: 3262 - $GC_I_SKILL_ID_ULTRA_SNOWBALL5
Func CanUse_UltraSnowball5()
	Return True
EndFunc

Func BestTarget_UltraSnowball5($aAggroRange)
	Return
EndFunc

; Skill ID: 3272 - $GC_I_SKILL_ID_MYSTIC_HEALING_PVP
Func CanUse_MysticHealingPvp()
	Return True
EndFunc

Func BestTarget_MysticHealingPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3290 - $GC_I_SKILL_ID_STUN_GRENADE
Func CanUse_StunGrenade()
	Return True
EndFunc

Func BestTarget_StunGrenade($aAggroRange)
	Return
EndFunc

; Skill ID: 3291 - $GC_I_SKILL_ID_FRAGMENTATION_GRENADE
Func CanUse_FragmentationGrenade()
	Return True
EndFunc

Func BestTarget_FragmentationGrenade($aAggroRange)
	Return
EndFunc

; Skill ID: 3292 - $GC_I_SKILL_ID_TEAR_GAS
Func CanUse_TearGas()
	Return True
EndFunc

Func BestTarget_TearGas($aAggroRange)
	Return
EndFunc

; Skill ID: 3299 - $GC_I_SKILL_ID_PHASED_PLASMA_BURST
Func CanUse_PhasedPlasmaBurst()
	Return True
EndFunc

Func BestTarget_PhasedPlasmaBurst($aAggroRange)
	Return
EndFunc

; Skill ID: 3300 - $GC_I_SKILL_ID_PLASMA_SHOT
Func CanUse_PlasmaShot()
	Return True
EndFunc

Func BestTarget_PlasmaShot($aAggroRange)
	Return
EndFunc

; Skill ID: 3371 - $GC_I_SKILL_ID_MIRROR_SHATTER
Func CanUse_MirrorShatter()
	Return True
EndFunc

Func BestTarget_MirrorShatter($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3378 - $GC_I_SKILL_ID_PHASE_SHIELD
Func CanUse_PhaseShield()
	Return True
EndFunc

Func BestTarget_PhaseShield($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3379 - $GC_I_SKILL_ID_REACTOR_BURST
Func CanUse_ReactorBurst()
	Return True
EndFunc

Func BestTarget_ReactorBurst($aAggroRange)
	Return Agent_GetMyID()
EndFunc

; Skill ID: 3382 - $GC_I_SKILL_ID_ANNIHILATOR_BEAM
Func CanUse_AnnihilatorBeam()
	Return True
EndFunc

Func BestTarget_AnnihilatorBeam($aAggroRange)
	Return
EndFunc

; Skill ID: 3396 - $GC_I_SKILL_ID_LIGHTNING_HAMMER_PVP
Func CanUse_LightningHammerPvp()
	Return True
EndFunc

Func BestTarget_LightningHammerPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3398 - $GC_I_SKILL_ID_SLIPPERY_GROUND_PVP
Func CanUse_SlipperyGroundPvp()
	Return True
EndFunc

Func BestTarget_SlipperyGroundPvp($aAggroRange)
	Return
EndFunc

; Skill ID: 3411 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3412 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3413 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3414 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3415 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3416 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3420 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 3421 - ;  $GC_I_SKILL_ID_UNKNOWN
