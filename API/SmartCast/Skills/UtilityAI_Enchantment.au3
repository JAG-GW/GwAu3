#include-once

Func Anti_Enchantment()
	;~ Generic hex checks
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False

	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) Then Return True
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
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPOIL_VICTOR) Then
		If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) < UAI_GetPlayerInfo($GC_UAI_AGENT_HP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SPOIL_VICTOR, "Scale")
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPOIL_VICTOR_PVP) Then
		If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) < UAI_GetPlayerInfo($GC_UAI_AGENT_HP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SPOIL_VICTOR_PVP, "Scale")
	EndIf
	Return $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50)
EndFunc

; Skill ID: 32 - $GC_I_SKILL_ID_ILLUSION_OF_WEAKNESS
Func CanUse_IllusionOfWeakness()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IllusionOfWeakness($a_f_AggroRange)
	; Description
	; Enchantment Spell. You lose 50...202...240 Health. Illusion of Weakness ends if damage drops your Health below 25% of your maximum. When Illusion of Weakness ends, you gain 50...202...240 Health.
	; Concise description
	; Enchantment Spell. Lose 50...202...240 Health. End effect: you gain 50...202...240 Health. Ends if damage drops your Health below 25% of your maximum.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 33 - $GC_I_SKILL_ID_ILLUSIONARY_WEAPONRY
Func CanUse_IllusionaryWeaponry()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IllusionaryWeaponry($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 30 seconds, your melee attacks neither hit nor fail to hit. Instead, Illusionary Weaponry deals 8...34...40 damage to your targets for each melee attack. You have +5 armor for each equipped Illusion Magic skill.
	; Concise description
	; Elite Enchantment Spell. (30 seconds.) Deals 8...34...40 damage to foes in place of other damage or effects from melee attacks. You have +5 armor for each equipped Illusion Magic skill. Your melee attacks neither hit nor fail to hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 34 - $GC_I_SKILL_ID_SYMPATHETIC_VISAGE
Func CanUse_SympatheticVisage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SympatheticVisage($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 4...9...10 seconds, whenever target ally is hit by a melee attack, all adjacent foes lose all adrenaline and 3 Energy.
	; Concise description
	; Enchantment Spell. (4...9...10 seconds.) All adjacent foes lose all adrenaline and 3 Energy whenever a melee attack hits target ally.
	Return 0
EndFunc

; Skill ID: 37 - $GC_I_SKILL_ID_ILLUSION_OF_HASTE
Func CanUse_IllusionOfHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IllusionOfHaste($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...10...11 seconds you are no longer Crippled, and you move 33% faster. When Illusion of Haste ends, you become Crippled for 3 seconds.
	; Concise description
	; Enchantment Spell. (5...10...11 seconds.) You move 33% faster. Initial effect: removes Crippled condition. End effect: you are Crippled (3 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 38 - $GC_I_SKILL_ID_CHANNELING
Func CanUse_Channeling()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Channeling($a_f_AggroRange)
	; Description
	; This article is about the skill Channeling. For the attribute, see Channeling Magic.
	; Concise description
	; green; font-weight: bold;">8...46...56
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 74 - $GC_I_SKILL_ID_ECHO
Func CanUse_Echo()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Echo($a_f_AggroRange)
	; Description
	; This article is about the elite Mesmer skill. For the skill type of the same name, see Echo (skill type).
	; Concise description
	; Acquisition">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 75 - $GC_I_SKILL_ID_ARCANE_ECHO
Func CanUse_ArcaneEcho()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ArcaneEcho($a_f_AggroRange)
	; Description
	; Enchantment Spell. If you cast a spell in the next 20 seconds, Arcane Echo is replaced with that spell for 20 seconds. Arcane Echo ends prematurely if you use a non-spell skill.
	; Concise description
	; Enchantment Spell. (20 seconds.) Arcane Echo becomes the next spell you use (20 seconds). This enchantment ends if you use any skill that is not a spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 82 - $GC_I_SKILL_ID_MANTRA_OF_RECALL
Func CanUse_MantraOfRecall()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MantraOfRecall($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 20 seconds, you gain no benefit from it. You gain 10...22...25 Energy when Mantra of Recall ends.
	; Concise description
	; Elite Enchantment Spell. (20 seconds.) End effect: you gain 10...22...25 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 88 - $GC_I_SKILL_ID_VERATAS_AURA
Func CanUse_VeratasAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VeratasAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 104 - $GC_I_SKILL_ID_DEATH_NOVA
Func CanUse_DeathNova()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DeathNova($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30 seconds, if target ally dies, all adjacent foes take 26...85...100 damage and are Poisoned for 15 seconds.
	; Concise description
	; Enchantment Spell. (30 seconds.) Deals 26...85...100 damage and inflicts Poisoned condition (15 seconds) on adjacent foes if target ally dies.
	Return 0
EndFunc

; Skill ID: 111 - $GC_I_SKILL_ID_AWAKEN_THE_BLOOD
Func CanUse_AwakenTheBlood()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AwakenTheBlood($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 20...39...44 seconds, you gain +2 Blood Magic and +2 Curses, but whenever you sacrifice Health, you sacrifice 50% more than the normal amount.
	; Concise description
	; Enchantment Spell. (20...39...44 seconds.) You have +2 Blood Magic and Curses. Sacrifice 50% more Health than normal.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 113 - $GC_I_SKILL_ID_TAINTED_FLESH
Func CanUse_TaintedFlesh()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_TaintedFlesh($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 20...39...44 seconds, target ally is immune to disease, and anyone striking that ally in melee becomes Diseased for 3...13...15 seconds.
	; Concise description
	; Elite Enchantment Spell. (20...39...44 seconds.) Foes who hit target ally in melee become Diseased (3...13...15 seconds); this ally is immune to Disease.
	Return 0
EndFunc

; Skill ID: 114 - $GC_I_SKILL_ID_AURA_OF_THE_LICH
Func CanUse_AuraOfTheLich()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfTheLich($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. All corpses within earshot are exploited and you animate a level 1...14...17 bone horror plus one for each corpse exploited in this way. For 5...37...45 seconds, your Death Magic attribute is increased by +1.
	; Concise description
	; Elite Enchantment Spell. Exploit all corpses in earshot. Animates a level 1...14...17 bone horror, plus one for each exploited corpse. You have +1 Death Magic (5...37...45 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 115 - $GC_I_SKILL_ID_BLOOD_RENEWAL
Func CanUse_BloodRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BloodRenewal($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 7 seconds, you gain +3...5...6 Health regeneration. When Blood Renewal ends, you gain 40...160...190 Health.
	; Concise description
	; Enchantment Spell. (7 seconds.) You have +3...5...6 Health regeneration. End effect: heals you for 40...160...190.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 116 - $GC_I_SKILL_ID_DARK_AURA
Func CanUse_DarkAura()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_DARK_AURA, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc

Func BestTarget_DarkAura($a_f_AggroRange)
	; Description
	; This article is about the skill.&#32;&#32;For the blessing from an avatar, see Dark Aura (blessing).&#32;&#32;For the blessing during Deactivating R.O.X., see Dark Aura (Deactivating R.O.X.).
	; Concise description
	; green; font-weight: bold;">5...41...50
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 119 - $GC_I_SKILL_ID_BLOOD_IS_POWER
Func CanUse_BloodIsPower()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BloodIsPower($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 10 seconds, target other ally gains +3...5...6 Energy regeneration.
	; Concise description
	; Elite Enchantment Spell. (10 seconds.) +3...5...6 Energy regeneration. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 130 - $GC_I_SKILL_ID_DEMONIC_FLESH
Func CanUse_DemonicFlesh()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DemonicFlesh($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30...54...60 seconds, whenever you use a skill that targets a foe, you deal 5...17...20 shadow damage to all other foes adjacent to you.
	; Concise description
	; Enchantment Spell. (30...54...60 seconds.) When using a skill on a foe, deal 5...17...20 shadow damage to all other foes adjacent to you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 134 - $GC_I_SKILL_ID_ORDER_OF_PAIN
Func CanUse_OrderOfPain()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfPain($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5 seconds, whenever a party member hits a foe with physical damage, that party member does +3...13...16 damage.
	; Concise description
	; Enchantment Spell. Enchants all party members (5 seconds). 3...13...16 more damage whenever these party members hit with physical damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 138 - $GC_I_SKILL_ID_DARK_BOND
Func CanUse_DarkBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DarkBond($a_f_AggroRange)
	; Description
	; Enchantment Spell. For the next 30...54...60 seconds, whenever you receive damage, your closest minion suffers 75% of that damage for you.
	; Concise description
	; Enchantment Spell. (30...54...60 seconds.) Transfers 75% of incoming damage from you to your nearest servant.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 139 - $GC_I_SKILL_ID_INFUSE_CONDITION
Func CanUse_InfuseCondition()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_InfuseCondition($a_f_AggroRange)
	; Description
	; Enchantment Spell. For the next 15...51...60 seconds, whenever you receive a condition, that condition is transferred to your closest minion instead.
	; Concise description
	; Enchantment Spell. (15...51...60 seconds.) Whenever you receive a condition, it transfers from you to your closest undead servant.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 147 - $GC_I_SKILL_ID_DARK_FURY
Func CanUse_DarkFury()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DarkFury($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5 seconds, whenever any party member hits with an attack, that party member gains one hit of adrenaline. (50% failure chance with Blood Magic of 4 or less.)
	; Concise description
	; Enchantment Spell. Enchants party members (5 seconds). These party members gain one strike of adrenaline each time they hit with an attack. 50% failure chance unless Blood Magic 5 or more.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 148 - $GC_I_SKILL_ID_ORDER_OF_THE_VAMPIRE
Func CanUse_OrderOfTheVampire()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfTheVampire($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5 seconds, whenever a party member who is not under the effects of another Necromancer enchantment hits a foe with physical damage, that party member steals up to 3...13...16 Health.
	; Concise description
	; Elite Enchantment Spell. Enchants all party members (5 seconds.) These party members steal 3...13...16 Health with each physical damage attack. Party members under another Necromancer enchantment are not affected.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 157 - $GC_I_SKILL_ID_BLOOD_RITUAL
Func CanUse_BloodRitual()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BloodRitual($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8...13...14 seconds, target touched ally gains +3 Energy regeneration. Blood Ritual cannot be used on the caster.
	; Concise description
	; Enchantment Spell. (8...13...14 seconds.) +3 Energy regeneration. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 160 - $GC_I_SKILL_ID_WINDBORNE_SPEED
Func CanUse_WindborneSpeed()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WindborneSpeed($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...11...13 seconds, target ally moves 33% faster.
	; Concise description
	; Enchantment Spell. (5...11...13 seconds.) Target ally moves 33% faster.
	Return 0
EndFunc

; Skill ID: 164 - $GC_I_SKILL_ID_ELEMENTAL_ATTUNEMENT
Func CanUse_ElementalAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ElementalAttunement($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 25...53...60 seconds, you are attuned to Air, Fire, Water, and Earth and gain +1...2...2 to these attributes. You gain 50% of the base Energy cost of the skill each time you use magic associated with any of these elements.
	; Concise description
	; Elite Enchantment Spell. (25...53...60 seconds.) Your elemental attributes are increased by +1...2...2. You gain 50% of the Energy cost of any Air, Earth, Fire, and Water Magic skills you use.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 165 - $GC_I_SKILL_ID_ARMOR_OF_EARTH
Func CanUse_ArmorOfEarth()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ArmorOfEarth($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30 seconds, you gain 24...53...60 armor, but move 50...21...14% slower.
	; Concise description
	; Enchantment Spell. (30 seconds.) You have +24...53...60 armor. You move 50...21...14% slower.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 166 - $GC_I_SKILL_ID_KINETIC_ARMOR
Func CanUse_KineticArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_KineticArmor($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8 seconds, you gain +20...68...80 armor. Whenever you cast a spell, Kinetic Armor is renewed for 8 seconds.
	; Concise description
	; Enchantment Spell. (8 seconds.) You have +20...68...80 armor. Renewal bonus: cast a spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 168 - $GC_I_SKILL_ID_MAGNETIC_AURA
Func CanUse_MagneticAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MagneticAura($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 1...4...5 second[s], you block the next attack against you and deal 10...42...50 damage to your attacker. If you are Overcast, all party members in earshot are also enchanted.
	; Concise description
	; Enchantment Spell. (1...4...5 second[s].) Block the next attack against you and reflect 10...42...50 damage to the attacker. If you are Overcast, enchant party members in earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 169 - $GC_I_SKILL_ID_EARTH_ATTUNEMENT
Func CanUse_EarthAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EarthAttunement($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 36...55...60 seconds, you are attuned to Earth. You gain 1 Energy plus 30% of the base Energy cost of the skill each time you use Earth Magic.
	; Concise description
	; Enchantment Spell. (36...55...60 seconds.) You gain 1 Energy plus 30% of the Energy cost when you use an Earth Magic skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 178 - $GC_I_SKILL_ID_ETHER_PRODIGY
Func CanUse_EtherProdigy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EtherProdigy($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. Lose all enchantments. For 8...18...20 seconds, you gain +6 Energy regeneration. When Ether Prodigy ends, you lose 2 Health for each point of Energy you have.
	; Concise description
	; Elite Enchantment Spell. (8...18...20 seconds.) You have +6 Energy regeneration. End effect: lose 2 Health for each point of Energy you have. Lose all enchantments.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 180 - $GC_I_SKILL_ID_AURA_OF_RESTORATION
Func CanUse_AuraOfRestoration()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfRestoration($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, you gain 0...1...1 Energy and are healed for 200...440...500% of the Energy cost each time you cast a spell.
	; Concise description
	; Enchantment Spell. (60 seconds.) You gain 0...1...1 Energy and are healed for 200...440...500% of the Energy cost each time you cast a spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 181 - $GC_I_SKILL_ID_ETHER_RENEWAL
Func CanUse_EtherRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EtherRenewal($a_f_AggroRange)
	; Description
	; "ER" redirects here. For the monk elite skill, see Empathic Removal.
	; Concise description
	; green; font-weight: bold;">5...17...20
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 182 - $GC_I_SKILL_ID_CONJURE_FLAME
Func CanUse_ConjureFlame()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ConjureFlame($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, if you're wielding a fire weapon, your attacks strike for an additional 5...17...20 fire damage.
	; Concise description
	; Enchantment Spell. (60 seconds.) Your attacks hit for +5...17...20 fire damage. No effect unless your weapon deals fire damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 184 - $GC_I_SKILL_ID_FIRE_ATTUNEMENT
Func CanUse_FireAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FireAttunement($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 36...55...60 seconds, you are attuned to Fire. You gain 1 Energy plus 30% of the base Energy cost of the skill each time you use Fire Magic.
	; Concise description
	; Enchantment Spell. (36...55...60 seconds.) You gain 1 Energy plus 30% of the Energy cost when you use a Fire Magic skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 206 - $GC_I_SKILL_ID_ARMOR_OF_FROST
Func CanUse_ArmorOfFrost()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ArmorOfFrost($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...29...34 seconds, you gain +40 armor against physical damage and have +1 Water Magic.
	; Concise description
	; Enchantment Spell. (10...29...34 seconds.) You have +40 armor against physical damage and have +1 Water Magic.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 207 - $GC_I_SKILL_ID_CONJURE_FROST
Func CanUse_ConjureFrost()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ConjureFrost($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, if you're wielding a cold weapon, your attacks strike for an additional 5...17...20 cold damage.
	; Concise description
	; Enchantment Spell. (60 seconds.) Your attacks hit for +5...17...20 cold damage. No effect unless your weapon deals cold damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 208 - $GC_I_SKILL_ID_WATER_ATTUNEMENT
Func CanUse_WaterAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WaterAttunement($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 36...55...60 seconds, you are attuned to Water. You gain 1 Energy plus 30% of the base Energy cost of the skill each time you use Water Magic.
	; Concise description
	; Enchantment Spell. (36...55...60 seconds.) You gain 1 Energy plus 30% of the Energy cost when you use a Water Magic skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 214 - $GC_I_SKILL_ID_ICE_SPEAR
Func CanUse_IceSpear()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IceSpear($a_f_AggroRange)
	; Description
	; Enchantment Spell. Send out an Ice Spear, striking target foe for 10...50...60 cold damage if it hits. If you are Overcast, you gain +1...3...4 Health regeneration for 5 seconds.
	; Concise description
	; Enchantment Spell. Projectile: deals 10...50...60 cold damage. Gain +1...3...4 Health regeneration for 5 seconds if Overcast.
	Return 0
EndFunc

; Skill ID: 216 - $GC_I_SKILL_ID_IRON_MIST
Func CanUse_IronMist()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IronMist($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8...14...15 seconds, you have +15 armor. Your Air Magic spells that target a foe activate and recharge 25% faster, but you are Overcast by 3 points.
	; Concise description
	; Enchantment Spell. (8...14...15 seconds.) Gain +15 armor. Air Magic spells that target a foe activate and recharge 25% faster, but you are Overcast by 3 points.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 218 - $GC_I_SKILL_ID_OBSIDIAN_FLESH
Func CanUse_ObsidianFlesh()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ObsidianFlesh($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 8...18...20 seconds, you gain +20 armor and cannot be the target of enemy spells, but cannot attack and have -2 energy degeneration.
	; Concise description
	; Elite Enchantment Spell. (8...18...20 seconds.) You have +20 armor and enemy spells cannot target you. You cannot attack and have -2 energy degeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 221 - $GC_I_SKILL_ID_CONJURE_LIGHTNING
Func CanUse_ConjureLightning()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ConjureLightning($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, if you're wielding a lightning weapon, your attacks strike for an additional 5...17...20 lightning damage.
	; Concise description
	; Enchantment Spell. (60 seconds.) Your attacks hit for +5...17...20 lightning damage. No effect unless your weapon deals lightning damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 225 - $GC_I_SKILL_ID_AIR_ATTUNEMENT
Func CanUse_AirAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AirAttunement($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 36...55...60 seconds, you are attuned to Air. You gain 1 Energy plus 30% of the base Energy cost of the skill whenever you use Air Magic.
	; Concise description
	; Enchantment Spell. (36...55...60 seconds.) You gain 1 Energy plus 30% of the Energy cost whenever you use an Air Magic skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 233 - $GC_I_SKILL_ID_SWIRLING_AURA
Func CanUse_SwirlingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SwirlingAura($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5 seconds, you are enchanted with Swirling Aura and have 1...5...6 Health regeneration and a 50% chance to block projectiles. If you are Overcast when you cast this spell, all party members in earshot are also enchanted.
	; Concise description
	; Enchantment Spell. (5 seconds.) Gives 1...5...6 Health regeneration and a 50% chance to block projectiles. If Overcast, also enchants party members in earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 236 - $GC_I_SKILL_ID_MIST_FORM
Func CanUse_MistForm()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MistForm($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 10...38...45 seconds, you take 33% less damage from foes under the effects of Water Magic hexes. Whenever you cast an elemental spell, all non-spirit allies in earshot are healed for 50...210...250% of the Energy cost of the spell.
	; Concise description
	; Elite Enchantment Spell. (10...38...45 seconds.) Take 33% less damage from foes hexed with Water Magic. Heals non-spirit allies in earshot for 50...210...250% of the energy cost of your elemental spells.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 238 - $GC_I_SKILL_ID_ARMOR_OF_MIST
Func CanUse_ArmorOfMist()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ArmorOfMist($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8...18...20 seconds, you gain +10...34...40 armor and move 33% faster.
	; Concise description
	; Enchantment Spell. (8...18...20 seconds.) You have +10...34...40 armor and move 33% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 241 - $GC_I_SKILL_ID_LIFE_BOND
Func CanUse_LifeBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LifeBond($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, whenever target other ally takes damage from an attack, half the damage is redirected to you. The damage you receive this way is reduced by 3...25...30.
	; Concise description
	; Enchantment Spell. Half of the damage target ally takes from attacks is redirected to you. Redirected damage is reduced by 3...25...30. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 242 - $GC_I_SKILL_ID_BALTHAZARS_SPIRIT
Func CanUse_BalthazarsSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BalthazarsSpirit($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, target ally gains adrenaline and 1 Energy after taking damage. (The amount of adrenaline gained increases depending on your rank in Smiting Prayers.)
	; Concise description
	; Enchantment Spell. Target ally gains adrenaline and 1 Energy when taking damage.
	Return 0
EndFunc

; Skill ID: 243 - $GC_I_SKILL_ID_STRENGTH_OF_HONOR
Func CanUse_StrengthOfHonor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_StrengthOfHonor($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, target ally deals 5...21...25 more damage in melee.
	; Concise description
	; Enchantment Spell. Target ally deals 5...21...25 more damage in melee.
	Return 0
EndFunc

; Skill ID: 244 - $GC_I_SKILL_ID_LIFE_ATTUNEMENT
Func CanUse_LifeAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LifeAttunement($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, target ally deals 30% less damage with attacks, but gains 14...43...50% more Health when healed.
	; Concise description
	; Enchantment Spell. Target ally gains 14...43...50% more Health when healed. This ally deals 30% less damage with attacks.
	Return 0
EndFunc

; Skill ID: 245 - $GC_I_SKILL_ID_PROTECTIVE_SPIRIT
Func CanUse_ProtectiveSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ProtectiveSpirit($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...19...23 seconds, target ally cannot lose more than 10% max Health due to damage from a single attack or spell.
	; Concise description
	; Enchantment Spell. (5...19...23 seconds.) Incoming damage is reduced to 10% of target ally's maximum Health.
	Return 0
EndFunc

; Skill ID: 246 - $GC_I_SKILL_ID_DIVINE_INTERVENTION
Func CanUse_DivineIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DivineIntervention($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10 seconds, the next time target ally receives damage that would be fatal, the damage is negated and that ally is healed for 26...197...240 Health.
	; Concise description
	; Enchantment Spell. (10 seconds.) Negates the next fatal damage target ally takes. Negation effect: heals for 26...197...240.
	Return 0
EndFunc

; Skill ID: 248 - $GC_I_SKILL_ID_RETRIBUTION
Func CanUse_Retribution()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Retribution($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, whenever target ally takes attack damage, this spell deals 33% of the damage back to the source (maximum 5...17...20 damage).
	; Concise description
	; Enchantment Spell. Deals 33% of each attack's damage (maximum 5...17...20) back to the source.
	Return 0
EndFunc

; Skill ID: 249 - $GC_I_SKILL_ID_HOLY_WRATH
Func CanUse_HolyWrath()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HolyWrath($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...26...30 seconds, the next 1...8...10 time[s] target other ally takes attack damage, this spell deals 66% of the damage back to the source (maximum of 5...41...50 damage).
	; Concise description
	; Enchantment Spell. (10...26...30 seconds). Deals 66% of each attack's damage (maximum 5...41...50) back to source. Ends after dealing damage 1...8...10 time[s]. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 250 - $GC_I_SKILL_ID_ESSENCE_BOND
Func CanUse_EssenceBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EssenceBond($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, whenever target ally takes physical or elemental damage, you gain 1 Energy.
	; Concise description
	; Enchantment Spell. You gain 1 Energy whenever target ally takes physical or elemental damage.
	Return 0
EndFunc

; Skill ID: 254 - $GC_I_SKILL_ID_VIGOROUS_SPIRIT
Func CanUse_VigorousSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VigorousSpirit($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30 seconds, each time target ally attacks or casts a spell, that ally is healed for 5...17...20 Health.
	; Concise description
	; Enchantment Spell. (30 seconds.) Heals for 5...17...20 each time target ally attacks or casts a spell.
	Return 0
EndFunc

; Skill ID: 255 - $GC_I_SKILL_ID_WATCHFUL_SPIRIT
Func CanUse_WatchfulSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WatchfulSpirit($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, target ally gains +2 Health regeneration. That ally is healed for 30...150...180 Health when Watchful Spirit ends.
	; Concise description
	; Enchantment Spell. +2 Health regeneration. End effect: heals for 30...150...180.
	Return 0
EndFunc

; Skill ID: 256 - $GC_I_SKILL_ID_BLESSED_AURA
Func CanUse_BlessedAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BlessedAura($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, Monk enchantments you cast last 10...30...35% longer.
	; Concise description
	; Enchantment Spell. Monk enchantments you cast last 10...30...35% longer.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 257 - $GC_I_SKILL_ID_AEGIS
Func CanUse_Aegis()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Aegis($a_f_AggroRange)
	; Description
	; This article is about the skill. For the shield with the same name, see Aegis (shield).
	; Concise description
	; green; font-weight: bold;">5...10...11
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 258 - $GC_I_SKILL_ID_GUARDIAN
Func CanUse_Guardian()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Guardian($a_f_AggroRange)
	; Description
	; This article is about a monk skill. For the character title, see Guardian (title).
	; Concise description
	; green; font-weight: bold;">2...6...7
	Return 0
EndFunc

; Skill ID: 259 - $GC_I_SKILL_ID_SHIELD_OF_DEFLECTION
Func CanUse_ShieldOfDeflection()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldOfDeflection($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 3...9...10 seconds, target ally has a 75% chance to block attacks and gains 15...27...30 armor.
	; Concise description
	; Elite Enchantment Spell. (3...9...10 seconds.) 75% chance to block. +15...27...30 armor.
	Return 0
EndFunc

; Skill ID: 260 - $GC_I_SKILL_ID_AURA_OF_FAITH
Func CanUse_AuraOfFaith()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfFaith($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 3 seconds, target ally gains 50...90...100% more Health when healed and takes 5...41...50% less damage.
	; Concise description
	; Elite Enchantment Spell. (3 seconds.) Target ally gains 50...90...100% more Health when healed and takes 5...41...50% less damage.
	Return 0
EndFunc

; Skill ID: 261 - $GC_I_SKILL_ID_SHIELD_OF_REGENERATION
Func CanUse_ShieldOfRegeneration()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldOfRegeneration($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5...11...13 seconds, target ally gains +3...9...10 Health regeneration and 40 armor.
	; Concise description
	; Elite Enchantment Spell. (5...11...13 seconds.) +3...9...10 Health regeneration and +40 armor.
	Return 0
EndFunc

; Skill ID: 262 - $GC_I_SKILL_ID_SHIELD_OF_JUDGMENT
Func CanUse_ShieldOfJudgment()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldOfJudgment($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 8...18...20 seconds, anyone striking target ally with an attack is knocked down and suffers 5...41...50 holy damage.
	; Concise description
	; Elite Enchantment Spell. (8...18...20 seconds.) Deals 5...41...50 holy damage to foes attacking [sic] target ally. Causes knock-down.
	Return 0
EndFunc

; Skill ID: 263 - $GC_I_SKILL_ID_PROTECTIVE_BOND
Func CanUse_ProtectiveBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ProtectiveBond($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, target ally cannot lose more than 5% max Health due to damage from a single attack or spell. When Protective Bond prevents damage, you lose 6...4...3 Energy or the spell ends.
	; Concise description
	; Enchantment Spell. Target ally cannot lose more than 5% max Health from a single attack or spell. Each time damage is reduced you lose 6...4...3 Energy or this spell ends.
	Return 0
EndFunc

; Skill ID: 266 - $GC_I_SKILL_ID_PEACE_AND_HARMONY
Func CanUse_PeaceAndHarmony()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PeaceAndHarmony($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. Target ally loses 0...7...9 condition[s] and hex[es]. For 1...3...3 second[s], conditions and hexes expire 90% faster on that ally. All your Smiting Prayers are disabled for 20 seconds.
	; Concise description
	; Elite Enchantment Spell. Target ally loses 0...7...9 condition[s] and hex[es]. Conditions and hexes expire 90% faster on that ally (1...3...3 second[s]). Disables your Smiting Prayers (20 seconds).
	Return 0
EndFunc

; Skill ID: 267 - $GC_I_SKILL_ID_JUDGES_INSIGHT
Func CanUse_JudgesInsight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_JudgesInsight($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 268 - $GC_I_SKILL_ID_UNYIELDING_AURA
Func CanUse_UnyieldingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_UnyieldingAura($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. While you maintain this enchantment, your Monk spells heal for +15...51...60% more Health. When this enchantment ends one random other party member is resurrected with full Health and Energy and teleported to your location.
	; Concise description
	; Elite Enchantment Spell. Your Monk spells heal for +15...51...60%. End effect: a random other party member is resurrected with full Health and Energy and teleported to your location.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 269 - $GC_I_SKILL_ID_MARK_OF_PROTECTION
Func CanUse_MarkOfProtection()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MarkOfProtection($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 10 seconds, whenever target ally would take damage, that ally is healed for that amount instead, maximum 6...49...60. All your Protection Prayers are disabled for 5 seconds.
	; Concise description
	; Elite Enchantment Spell. (10 seconds.) Converts incoming damage to healing (maximum 6...49...60). All your Protection Prayers are disabled (5 seconds).
	Return 0
EndFunc

; Skill ID: 270 - $GC_I_SKILL_ID_LIFE_BARRIER
Func CanUse_LifeBarrier()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LifeBarrier($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. While you maintain this enchantment, damage dealt to target other ally is reduced by 20...44...50%. If your Health is below 50% when that ally takes damage, Life Barrier ends.
	; Concise description
	; Elite Enchantment Spell. Reduces damage by 20...44...50%. Cannot self-target. If your Health is below 50% when target takes damage, Life Barrier ends.
	Return 0
EndFunc

; Skill ID: 271 - $GC_I_SKILL_ID_ZEALOTS_FIRE
Func CanUse_ZealotsFire()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ZealotsFire($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, whenever you use a skill that targets an ally, all foes adjacent to that target are struck for 5...29...35 fire damage and you lose 1 Energy.
	; Concise description
	; Enchantment Spell. (60 seconds.) Whenever you use a skill on an ally, all foes adjacent to that ally are hit for 5...29...35 fire damage. Damage cost: you lose 1 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 272 - $GC_I_SKILL_ID_BALTHAZARS_AURA
Func CanUse_BalthazarsAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BalthazarsAura($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 273 - $GC_I_SKILL_ID_SPELL_BREAKER
Func CanUse_SpellBreaker()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpellBreaker($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5...15...17 seconds, target ally cannot be the target of enemy spells.
	; Concise description
	; Elite Enchantment Spell. (5...15...17 seconds.) Target ally cannot be the target of enemy spells.
	Return 0
EndFunc

; Skill ID: 274 - $GC_I_SKILL_ID_HEALING_SEED
Func CanUse_HealingSeed()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HealingSeed($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10 seconds, whenever target other ally takes damage, that ally and all adjacent allies gain 3...25...30 Health.
	; Concise description
	; Enchantment Spell. (10 seconds.) Target and adjacent allies gain 3...25...30 Health whenever this ally takes damage. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 284 - $GC_I_SKILL_ID_DIVINE_BOON
Func CanUse_DivineBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DivineBoon($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, whenever you cast a Protection Prayer  or Divine Favor spell that targets an ally, that ally is healed for 15...51...60 Health, and you lose 1 Energy.
	; Concise description
	; Enchantment Spell. Whenever you cast a Protection Prayer [sic] or Divine Favor spell on an ally, that ally is healed for 15...51...60. Heal cost: you lose 1 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 285 - $GC_I_SKILL_ID_HEALING_HANDS
Func CanUse_HealingHands()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HealingHands($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 10 seconds, whenever target ally takes damage, that ally is healed for 5...29...35 Health.
	; Concise description
	; Elite Enchantment Spell. (10 seconds.) Heals for 5...29...35 whenever target takes damage.
	Return 0
EndFunc

; Skill ID: 288 - $GC_I_SKILL_ID_HEALING_BREEZE
Func CanUse_HealingBreeze()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HealingBreeze($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 15 seconds, target ally gains +4...8...9 Health regeneration.
	; Concise description
	; Enchantment Spell. (15 seconds.) +4...8...9 Health regeneration.
	Return 0
EndFunc

; Skill ID: 289 - $GC_I_SKILL_ID_VITAL_BLESSING
Func CanUse_VitalBlessing()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VitalBlessing($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, target ally has +40...168...200 maximum Health.
	; Concise description
	; Enchantment Spell. +40...168...200 maximum Health.
	Return 0
EndFunc

; Skill ID: 290 - $GC_I_SKILL_ID_MENDING
Func CanUse_Mending()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Mending($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, target ally gains +1...3...4 Health regeneration.
	; Concise description
	; Enchantment Spell. +1...3...4 Health regeneration.
	Return 0
EndFunc

; Skill ID: 291 - $GC_I_SKILL_ID_LIVE_VICARIOUSLY
Func CanUse_LiveVicariously()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LiveVicariously($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, whenever target ally hits a foe, you gain 2...14...17 Health.
	; Concise description
	; Enchantment Spell. You gain 2...14...17 Health whenever target ally hits a foe.
	Return 0
EndFunc

; Skill ID: 299 - $GC_I_SKILL_ID_SHIELDING_HANDS
Func CanUse_ShieldingHands()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldingHands($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8 seconds, damage and life steal received by target ally is reduced by 3...15...18. When Shielding Hands ends, that ally is healed for 5...41...50 Health.
	; Concise description
	; Enchantment Spell. (8 seconds.) Reduces incoming damage and life steal by 3...15...18. End effect: heals for 5...41...50
	Return 0
EndFunc

; Skill ID: 307 - $GC_I_SKILL_ID_REVERSAL_OF_FORTUNE
Func CanUse_ReversalOfFortune()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ReversalOfFortune($a_f_AggroRange)
	; Description
	; "RoF" redirects here. For the Prophecies mission, see Ring of Fire.
	; Concise description
	; green; font-weight: bold;">15...67...80
	Return 0
EndFunc

; Skill ID: 308 - $GC_I_SKILL_ID_SUCCOR
Func CanUse_Succor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Succor($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this Enchantment, target other ally gains +1 Health and +1 Energy regeneration, but you lose 1 Energy each time that ally casts a Spell.
	; Concise description
	; Enchantment Spell. +1 Health regeneration and +1 Energy regeneration. Cannot self-target. You lose 1 Energy each time target ally casts a spell.
	Return 0
EndFunc

; Skill ID: 309 - $GC_I_SKILL_ID_HOLY_VEIL
Func CanUse_HolyVeil()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HolyVeil($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, any hex cast on target ally takes twice as long to cast. When Holy Veil ends, one hex is removed from target ally.
	; Concise description
	; Enchantment Spell. Doubles casting time of hexes cast on target ally. End effect: removes a hex.
	Return 0
EndFunc

; Skill ID: 310 - $GC_I_SKILL_ID_DIVINE_SPIRIT
Func CanUse_DivineSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DivineSpirit($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 1...11...14 second[s], Monk Spells cost you 5 less Energy to cast. (Minimum cost: 1 Energy.)
	; Concise description
	; Enchantment Spell. (1...11...14 second[s].) Monk spells cost you 5 less Energy. Minimum cost: 1 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 315 - $GC_I_SKILL_ID_VENGEANCE
Func CanUse_Vengeance()
	If Anti_Enchantment() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_Vengeance($a_f_AggroRange)
	; Description
	; This article is about the Monk skill. For the weapon, see Anniversary Daggers "Vengeance".
	; Concise description
	; #808080;">End effect: this ally dies.
	Return 0
EndFunc

; Skill ID: 515 - $GC_I_SKILL_ID_CHARR_BUFF
Func CanUse_CharrBuff()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_CharrBuff($a_f_AggroRange)
	; Description
	; Monster skill
	; Concise description
	; 1em; margin-bottom:1em; clear:both;" />
	Return 0
EndFunc

; Skill ID: 532 - $GC_I_SKILL_ID_HEALING_BREEZE_AGNARS_RAGE
Func CanUse_HealingBreezeAgnarsRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HealingBreezeAgnarsRage($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 584 - $GC_I_SKILL_ID_DIVINE_FIRE
Func CanUse_DivineFire()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DivineFire($a_f_AggroRange)
	; Description
	; Prophecies
	; Concise description
	; Acquisition">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 596 - $GC_I_SKILL_ID_CHIMERA_OF_INTENSITY
Func CanUse_ChimeraOfIntensity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ChimeraOfIntensity($a_f_AggroRange)
	; Description
	; Enchantment Spell. Your skills recharge 50% faster, spells you cast cost 50% less Energy, and your movement speed is increased by 50%.
	; Concise description
	; Enchantment Spell. Your skills recharge 50% faster, spells you cast cost 50% less Energy, and your movement speed is increased by 50%.
	Return 0
EndFunc

; Skill ID: 763 - $GC_I_SKILL_ID_JAUNDICED_GAZE
Func CanUse_JaundicedGaze()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_JaundicedGaze($a_f_AggroRange)
	; Description
	; Enchantment Spell. Remove an enchantment from target foe. If an enchantment is removed, for the next 1...12...15 second[s], your next enchantment spell casts 0...1...1 second[s] faster and costs 1...8...10 less Energy.
	; Concise description
	; Enchantment Spell. Removes an enchantment from target foe. Removal effect: your next enchantment casts 0...1...1 second[s] faster and costs 1...8...10 less Energy. (1...12...15 second[s])
	Return 0
EndFunc

; Skill ID: 771 - $GC_I_SKILL_ID_AURA_OF_DISPLACEMENT
Func CanUse_AuraOfDisplacement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfDisplacement($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. When you cast Aura of Displacement, Shadow Step to target foe. When you stop maintaining Aura of Displacement you return to your original location.
	; Concise description
	; Elite Enchantment Spell. Shadow Step to target foe. End effect: return to your original location.
	Return 0
EndFunc

; Skill ID: 806 - $GC_I_SKILL_ID_CULTISTS_FERVOR
Func CanUse_CultistsFervor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_CultistsFervor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 807 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 813 - $GC_I_SKILL_ID_LYSSAS_AURA
Func CanUse_LyssasAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LyssasAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 814 - $GC_I_SKILL_ID_SHADOW_REFUGE
Func CanUse_ShadowRefuge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowRefuge($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 6 seconds, you gain 5...9...10 Health regeneration. When Shadow Refuge ends, you gain 40...88...100 Health if you are attacking.
	; Concise description
	; Enchantment Spell. (6 seconds.) You have +5...9...10 Health regeneration. End effect: heals you for 40...88...100 if you are attacking.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 819 - $GC_I_SKILL_ID_VAMPIRIC_SPIRIT
Func CanUse_VampiricSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VampiricSpirit($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. Steal up to 5...41...50 Health from target foe. For 10 seconds, you have +5...9...10 Health regeneration.
	; Concise description
	; Elite Enchantment Spell. Steal 5...41...50 Health from target foe. You have +5...9...10 Health regeneration (10 seconds).
	Return 0
EndFunc

; Skill ID: 823 - $GC_I_SKILL_ID_BURNING_SPEED
Func CanUse_BurningSpeed()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BurningSpeed($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 7 seconds, you are set on fire and move 30...42...45% faster. When Burning Speed ends, all adjacent foes are set on fire for 3...8...9 seconds.
	; Concise description
	; Enchantment Spell. (7 seconds.) You move 30...42...45% faster. You suffer from Burning (7 seconds). End effect: inflicts Burning condition (3...8...9 seconds) on adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 826 - $GC_I_SKILL_ID_SHADOW_FORM
Func CanUse_ShadowForm()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowForm($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5...18...21 seconds, you cannot be the target of enemy spells, and you gain 5 damage reduction for each Assassin enchantment on you. You cannot deal more than 5...21...25 damage with a single skill or attack.
	; Concise description
	; Elite Enchantment Spell. (5...18...21 seconds.) Enemy spells cannot target you. Gain 5 damage reduction for each Assassin enchantment on you. You cannot deal more than 5...21...25 damage with a single skill or attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 829 - $GC_I_SKILL_ID_VERATAS_PROMISE
Func CanUse_VeratasPromise()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VeratasPromise($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 833 - $GC_I_SKILL_ID_BORROWED_ENERGY
Func CanUse_BorrowedEnergy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BorrowedEnergy($a_f_AggroRange)
	; Description
	; Mesmer
	; Concise description
	; green; font-weight: bold;">4...9...10
	Return 0
EndFunc

; Skill ID: 837 - $GC_I_SKILL_ID_ENERGY_BOON
Func CanUse_EnergyBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EnergyBoon($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 36...55...60 seconds, Energy Boon raises the maximum Health of you and target ally by 1...3...3 for each point of your respective maximum Energy. When this enchantment is first applied, you and your target gain 1...10...12 Energy. You gain an additional 1 Energy for every 2 points you have in Energy Storage.
	; Concise description
	; Elite Enchantment Spell. (36...55...60 seconds.) Maximum Health for you and target ally is increased by 1...3...3 for each point of maximum Energy. Initial effect: Both gain 1...10...12 Energy. You gain +1 Energy for every 2 points of Energy Storage.
	Return 0
EndFunc

; Skill ID: 838 - $GC_I_SKILL_ID_DWAYNAS_SORROW
Func CanUse_DwaynasSorrow()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DwaynasSorrow($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 843 - $GC_I_SKILL_ID_GUST
Func CanUse_Gust()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Gust($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5...10...11 seconds, both you and target ally move 33% faster. When you cast this spell, all foes near you and your target take 15...59...70 cold damage. Foes struck by Gust while attacking or moving are knocked down.
	; Concise description
	; Elite Enchantment Spell. (5...10...11 seconds.) You and target ally move 33% faster. Initial effect: Foes near you and target ally are struck for 15...59...70 cold damage. Attacking or moving foes are knocked down.
	Return 0
EndFunc

; Skill ID: 848 - $GC_I_SKILL_ID_REVERSE_HEX
Func CanUse_ReverseHex()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ReverseHex($a_f_AggroRange)
	; Description
	; Enchantment Spell. Remove one hex from target ally. If a hex was removed in this way, for 5...9...10 seconds, the next time target ally would take damage, that damage is reduced by 5...41...50.
	; Concise description
	; Enchantment Spell. (5...9...10 seconds.) Removes one hex from target ally. The next damage this ally takes is reduced by 5...41...50. No effect unless this ally is hexed.
	Return 0
EndFunc

; Skill ID: 863 - $GC_I_SKILL_ID_ORDER_OF_APOSTASY
Func CanUse_OrderOfApostasy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_OrderOfApostasy($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5 seconds, whenever a party member hits a foe with physical damage, that foe loses one enchantment. For each Monk enchantment removed, you lose 25...17...15% maximum Health.
	; Concise description
	; Elite Enchantment Spell. Enchants all party members (5 seconds). These party members remove one enchantment when they deal physical damage. Removal cost: for each Monk enchantment, you lose 25...17...15% maximum Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 885 - $GC_I_SKILL_ID_SHIELD_GUARDIAN
Func CanUse_ShieldGuardian()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldGuardian($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 1...3...4 seconds, all party members in earshot have a 75% chance to block incoming attacks. If an attack is blocked, all allies in earshot are healed for 10...34...40 and Shield Guardian ends.
	; Concise description
	; Enchantment Spell. (1...3...4 second[s]). Party members in earshot have a 75% chance to block attacks. Block effect: Allies in earshot are healed for 10...34...40, and Shield Guardian ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 886 - $GC_I_SKILL_ID_RESTFUL_BREEZE
Func CanUse_RestfulBreeze()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_RestfulBreeze($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8...16...18 seconds, target ally has +10 Health regeneration. This enchantment ends if that ally attacks or uses a skill.
	; Concise description
	; Enchantment Spell. (8...16...18 seconds.) +10 Health regeneration. Ends if target ally attacks or uses a skill.
	Return 0
EndFunc

; Skill ID: 925 - $GC_I_SKILL_ID_RECALL
Func CanUse_Recall()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Recall($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain Recall, nothing happens. When Recall ends, you Shadow Step to the ally you targeted when you activated this skill and all of your skills are disabled for 10 seconds.
	; Concise description
	; Enchantment Spell. End effect: Shadow Step to target ally. Cannot self-target and disables all of your skills for 10 seconds when it ends.
	Return 0
EndFunc

; Skill ID: 926 - $GC_I_SKILL_ID_SHARPEN_DAGGERS
Func CanUse_SharpenDaggers()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SharpenDaggers($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...25...30 seconds, your dagger attacks cause Bleeding for 5...13...15 seconds.
	; Concise description
	; Enchantment Spell. (5...25...30 seconds.) Your dagger attacks inflict the Bleeding condition (5...13...15 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 930 - $GC_I_SKILL_ID_AUSPICIOUS_INCANTATION
Func CanUse_AuspiciousIncantation()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuspiciousIncantation($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 20 seconds, the next spell you cast is disabled for an additional 10...6...5 seconds, and you gain 110...182...200% of that spell's Energy cost.
	; Concise description
	; Enchantment Spell. (20 seconds.) Your next spell gives you 110...182...200% of its Energy cost. That spell takes 10...6...5 seconds longer to recharge.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 949 - $GC_I_SKILL_ID_WAY_OF_THE_FOX
Func CanUse_WayOfTheFox()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfTheFox($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...30...35 seconds, your next 1...5...6 attack[s] cannot be blocked.
	; Concise description
	; Enchantment Spell. (10...30...35 seconds.) Your attacks are unblockable. Ends after 1...5...6 attack[s].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 956 - $GC_I_SKILL_ID_ENERGY_FONT
Func CanUse_EnergyFont()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EnergyFont($a_f_AggroRange)
	; Description
	; Elementalist
	; Concise description
	; green; font-weight: bold;">15...51...60
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 957 - $GC_I_SKILL_ID_SPELL_SHIELD
Func CanUse_SpellShield()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpellShield($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...17...20 seconds, while you are casting spells, foes cannot target you with spells. When Spell Shield ends, all your skills are disabled for 10...6...5 seconds.
	; Concise description
	; Enchantment Spell. (5...17...20 seconds.) While casting spells, you cannot be the target of spells. End effect: your skills are disabled (10...6...5 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 977 - $GC_I_SKILL_ID_WAY_OF_THE_LOTUS
Func CanUse_WayOfTheLotus()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfTheLotus($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 20 seconds, the next time you hit with a dual attack skill, you gain 5...17...20 Energy.
	; Concise description
	; Enchantment Spell. (20 seconds.) You gain 5...17...20 Energy the next time you hit with a dual attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 984 - $GC_I_SKILL_ID_TORCH_ENCHANTMENT
Func CanUse_TorchEnchantment()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_TorchEnchantment($a_f_AggroRange)
	; Description
	; Core
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 987 - $GC_I_SKILL_ID_WAY_OF_THE_EMPTY_PALM
Func CanUse_WayOfTheEmptyPalm()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfTheEmptyPalm($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5...17...20 seconds, off-hand and dual attacks cost no Energy.
	; Concise description
	; Elite Enchantment Spell. (5...17...20 seconds.) Your off-hand and dual attacks cost no Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1006 - $GC_I_SKILL_ID_ICE_FORT
Func CanUse_IceFort()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IceFort($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10 seconds, you cannot be knocked down, you are immune to conditions, and all incoming damage is reduced to 0. Ice Fort ends if you move.
	; Concise description
	; Enchantment Spell. (10 seconds.) You cannot be knocked down, you are immune to conditions, and you take no damage. Ends if you move.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1013 - $GC_I_SKILL_ID_ICE_BREAKER
Func CanUse_IceBreaker()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IceBreaker($a_f_AggroRange)
	; Description
	; This article is about the snow fighting skill. For the unique hammer, see The Ice Breaker.
	; Concise description
	; Acquisition">edit
	Return 0
EndFunc

; Skill ID: 1027 - $GC_I_SKILL_ID_CRITICAL_DEFENSES
Func CanUse_CriticalDefenses()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_CriticalDefenses($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 4...9...10 seconds, you have a 75% chance to block. Critical Defenses refreshes every time you land a critical hit.
	; Concise description
	; Enchantment Spell. (4...9...10 seconds.) You have a 75% chance to block. Renewal: every time you land a critical hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1028 - $GC_I_SKILL_ID_WAY_OF_PERFECTION
Func CanUse_WayOfPerfection()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfPerfection($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, whenever you successfully land a critical hit, you gain 10...34...40 Health.
	; Concise description
	; Enchantment Spell. (60 seconds.) Your critical hits heal you for 10...34...40.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1029 - $GC_I_SKILL_ID_DARK_APOSTASY
Func CanUse_DarkApostasy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DarkApostasy($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 3...14...17 seconds, every time you successfully land a critical hit, you remove one enchantment from your target. If you remove an enchantment in this way, you lose 10...5...4 Energy or Dark Apostasy ends.
	; Concise description
	; Elite Enchantment Spell. (3...14...17 seconds.) Your critical hits remove an enchantment. Removal cost: lose 10...5...4 Energy or Dark Apostasy ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1030 - $GC_I_SKILL_ID_LOCUSTS_FURY
Func CanUse_LocustsFury()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LocustsFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1031 - $GC_I_SKILL_ID_SHROUD_OF_DISTRESS
Func CanUse_ShroudOfDistress()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShroudOfDistress($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30...54...60 seconds, if you are below 50% Health, you have 3...7...8 health regeneration and a 75% chance to block attacks.
	; Concise description
	; Enchantment Spell. (30...54...60 seconds.) You have 3...7...8 health regeneration and a 75% chance to block. No effect unless your Health is below 50%.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1054 - $GC_I_SKILL_ID_ANCESTORS_VISAGE
Func CanUse_AncestorsVisage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AncestorsVisage($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1084 - $GC_I_SKILL_ID_SLIVER_ARMOR
Func CanUse_SliverArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SliverArmor($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...10...11 seconds, you have 25...45...50% chance to block attacks and whenever you are the target of a hostile spell or attack one nearby foe is struck for 5...29...35 earth damage.
	; Concise description
	; Enchantment Spell. (5...10...11 seconds.) You have 25...45...50% chance to block. Deals 5...29...35 earth damage to one nearby foe whenever you are the target of a hostile spell or attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1091 - $GC_I_SKILL_ID_DOUBLE_DRAGON
Func CanUse_DoubleDragon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DoubleDragon($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. Invoke the power of the Dragon. For 8 seconds, you and target ally are enchanted with Double Dragon. Adjacent foes are dealt 5...25...30 fire damage each second. Additionally, when you or your ally use skills that target a foe, that foe is set on fire for 0...2...3 second[s].
	; Concise description
	; Elite Enchantment Spell. (8 seconds.) Enchants you and target ally. Adjacent foes take 5...25...30 fire damage each second. Skills that target a foe also inflict Burning (0...2...3 second[s]).
	Return 0
EndFunc

; Skill ID: 1114 - $GC_I_SKILL_ID_SPIRIT_BOND
Func CanUse_SpiritBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritBond($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8 seconds, whenever target ally takes more than 50 damage from the next 10 attacks or spells, that ally is healed for 30...78...90 Health.
	; Concise description
	; Enchantment Spell. (8 seconds.) Heals for 30...78...90 whenever target ally takes more than 50 damage. Ends after this ally takes damage from 10 attacks or spells.
	Return 0
EndFunc

; Skill ID: 1115 - $GC_I_SKILL_ID_AIR_OF_ENCHANTMENT
Func CanUse_AirOfEnchantment()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AirOfEnchantment($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 4...9...10 seconds, enchantments cast on target other ally cost 5 less Energy (minimum 1 Energy).
	; Concise description
	; Elite Enchantment Spell. (4...9...10 seconds.) Enchantments cast on target ally cost 5 less Energy (minimum 1 Energy). Cannot self-target.
	Return 0
EndFunc

; Skill ID: 1123 - $GC_I_SKILL_ID_LIFE_SHEATH
Func CanUse_LifeSheath()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LifeSheath($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. Remove 0...2...2 condition[s] from target ally. For 8 seconds, the next time that ally would take damage or life steal, that ally gains that amount of Health instead (maximum 20...84...100).
	; Concise description
	; Elite Enchantment Spell. (8 seconds.) Converts the next incoming damage or life steal (maximum 20...84...100) to healing. Initial effect: Removes 0...2...2 condition[s].
	Return 0
EndFunc

; Skill ID: 1152 - $GC_I_SKILL_ID_DEMONIC_AGILITY
Func CanUse_DemonicAgility()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DemonicAgility($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30 seconds, This  demon creature has 100% chance to double strike when attacking in melee.
	; Concise description
	; Enchantment Spell. (30 seconds.) This demon creature has 100% chance to double strike when attacking in melee.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1153 - $GC_I_SKILL_ID_BLESSING_OF_THE_KIRIN
Func CanUse_BlessingOfTheKirin()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BlessingOfTheKirin($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30 seconds, the next time a nearby ally of this Kirin uses a skill, that ally is cured of Miasma or one condition.
	; Concise description
	; Enchantment Spell. (30 seconds.) When a nearby ally uses a skill, that ally is cured of Miasma or one condition.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1229 - $GC_I_SKILL_ID_EXPLOSIVE_GROWTH
Func CanUse_ExplosiveGrowth()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ExplosiveGrowth($a_f_AggroRange)
	; Description
	; This article is about the skill. For the creature, see Explosive Growth (NPC).
	; Concise description
	; green; font-weight: bold;">15...51...60
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1230 - $GC_I_SKILL_ID_BOON_OF_CREATION
Func CanUse_BoonOfCreation()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BoonOfCreation($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 15...51...60 seconds, whenever you create a creature, you gain 5...41...50 Health and 1...5...6 Energy.
	; Concise description
	; Enchantment Spell. (15...51...60 seconds.) You gain 5...41...50 Health and 1...5...6 Energy whenever you create a creature.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1231 - $GC_I_SKILL_ID_SPIRIT_CHANNELING
Func CanUse_SpiritChanneling()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritChanneling($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 12 seconds, you have +1...5...6 Energy regeneration. When you cast this spell, you gain 3...10...12 Energy if you are within earshot of a spirit.
	; Concise description
	; Elite Enchantment Spell. (12 seconds.) You have +1...5...6 Energy regeneration. Initial effect: you gain 3...10...12 Energy if you are within earshot of a spirit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1244 - $GC_I_SKILL_ID_GHOSTLY_HASTE
Func CanUse_GhostlyHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_GhostlyHaste($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...17...20 seconds, spells you cast while within earshot of a spirit recharge 25% faster.
	; Concise description
	; Enchantment Spell. (5...17...20 seconds.) Spells you cast recharge 25% faster. No effect unless you are within earshot of a spirit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1261 - $GC_I_SKILL_ID_FRIGID_ARMOR
Func CanUse_FrigidArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FrigidArmor($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...22...25 seconds, you have +10...34...40 armor against physical damage and cannot be set on fire.
	; Concise description
	; Enchantment Spell. (10...22...25 seconds.) You have +10...34...40 armor against physical damage and immunity to Burning.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1311 - $GC_I_SKILL_ID_NIGHTMARE_REFUGE
Func CanUse_NightmareRefuge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_NightmareRefuge($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Related skills">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1323 - $GC_I_SKILL_ID_SUGAR_RUSH_MEDIUM
Func CanUse_SugarRushMedium()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SugarRushMedium($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1338 - $GC_I_SKILL_ID_PERSISTENCE_OF_MEMORY
Func CanUse_PersistenceOfMemory()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PersistenceOfMemory($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...17...20 seconds, whenever a spell you cast is interrupted, that spell is instantly recharged.
	; Concise description
	; Enchantment Spell. (5...17...20 seconds.) Your interrupted spells recharge instantly.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1340 - $GC_I_SKILL_ID_SYMBOLIC_CELERITY
Func CanUse_SymbolicCelerity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SymbolicCelerity($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 36...55...60 seconds, all of your signets use your Fast Casting attribute instead of their normal attributes.
	; Concise description
	; Enchantment Spell. (36...55...60 seconds.) Your signets use your Fast Casting attribute.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1355 - $GC_I_SKILL_ID_JAGGED_BONES
Func CanUse_JaggedBones()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_JaggedBones($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 30 seconds, whenever target undead servant dies, it is replaced by a level 0...12...15 jagged horror that causes Bleeding with each of its attacks.
	; Concise description
	; Elite Enchantment Spell. (30 seconds.) When target undead servant dies, it is replaced by a level 0...12...15 jagged horror that inflicts Bleeding with attacks.
	Return 0
EndFunc

; Skill ID: 1356 - $GC_I_SKILL_ID_CONTAGION
Func CanUse_Contagion()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Contagion($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 60 seconds, whenever you suffer from a new condition, all foes in the area suffer from that same condition and you sacrifice 10...6...5% maximum Health.
	; Concise description
	; Elite Enchantment Spell. (60 seconds.) Whenever you gain a condition, all foes in the area gain that same condition. You sacrifice 10...6...5% maximum Health each time this happens.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1357 - $GC_I_SKILL_ID_BLOODLETTING
Func CanUse_Bloodletting()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Bloodletting($a_f_AggroRange)
	; Description
	; Necromancer
	; Concise description
	; green; font-weight: bold;">1...5...6
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1370 - $GC_I_SKILL_ID_STORM_DJINNS_HASTE
Func CanUse_StormDjinnsHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_StormDjinnsHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1371 - $GC_I_SKILL_ID_STONE_STRIKER
Func CanUse_StoneStriker()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_StoneStriker($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...25...30 seconds, whenever you take or deal elemental or physical damage, that damage is converted to earth damage.
	; Concise description
	; Enchantment Spell. (5...25...30 seconds.) Converts elemental and physical damage you take or deal to earth damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1373 - $GC_I_SKILL_ID_STONE_SHEATH
Func CanUse_StoneSheath()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_StoneSheath($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5...17...20 seconds, you and target ally have +1...24...30 armor and are immune to critical hits. When you cast this spell, all foes near you and your target take 15...59...70 earth damage and are Weakened for 5...17...20 seconds.
	; Concise description
	; Elite Enchantment Spell. (5...17...20 seconds.) Gives you and target ally +1...24...30 armor and immunity to critical hits. Initial effect: Foes near you and target ally are struck for 15...59...70 earth damage and are Weakened (5...17...20 seconds).
	Return 0
EndFunc

; Skill ID: 1375 - $GC_I_SKILL_ID_STONEFLESH_AURA
Func CanUse_StonefleshAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_StonefleshAura($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...13...15 seconds, damage you receive is reduced by 1...25...31, and you are immune to critical attacks.
	; Concise description
	; Enchantment Spell. (5...13...15 seconds.) Reduces damage you take by 1...25...31, and you are immune to critical hits.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1378 - $GC_I_SKILL_ID_MASTER_OF_MAGIC
Func CanUse_MasterOfMagic()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MasterOfMagic($a_f_AggroRange)
	; Description
	; This article is about the skill Master of Magic. For the NPC on the Isle of the Nameless, see Master of Magic (NPC).
	; Concise description
	; green; font-weight: bold;">1...49...61
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1381 - $GC_I_SKILL_ID_FLAME_DJINNS_HASTE1
Func CanUse_FlameDjinnsHaste1()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FlameDjinnsHaste1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1390 - $GC_I_SKILL_ID_JUDGES_INTERVENTION
Func CanUse_JudgesIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_JudgesIntervention($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10 seconds, the next time target ally receives damage that would be fatal, the damage is negated and one nearby foe takes 30...150...180 holy damage.
	; Concise description
	; Enchantment Spell. (10 seconds.) Negates the next fatal damage. Negation effect: deals 30...150...180 holy damage to one foe near target ally.
	Return 0
EndFunc

; Skill ID: 1391 - $GC_I_SKILL_ID_SUPPORTIVE_SPIRIT
Func CanUse_SupportiveSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SupportiveSpirit($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...19...23 seconds, whenever target ally takes damage while knocked down, that ally is healed for 5...29...35 Health.
	; Concise description
	; Enchantment Spell. (5...19...23 seconds.) Heals for 5...29...35 whenever target ally takes damage while knocked-down.
	Return 0
EndFunc

; Skill ID: 1392 - $GC_I_SKILL_ID_WATCHFUL_HEALING
Func CanUse_WatchfulHealing()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WatchfulHealing($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10 seconds, target ally gains +1...3...4 Health regeneration. If this skill ends prematurely, that ally gains 30...102...120 Health.
	; Concise description
	; Enchantment Spell. (10 seconds.) Target ally has +1...3...4 Health regeneration and gains 30...102...120 Health if this enchantment ends early.
	Return 0
EndFunc

; Skill ID: 1393 - $GC_I_SKILL_ID_HEALERS_BOON
Func CanUse_HealersBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HealersBoon($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 10...46...55 seconds.  Healing Prayers spells cast 50% faster and heal for 50% more Health.
	; Concise description
	; Elite Enchantment Spell. (10...46...55 seconds.) Healing Prayers spells cast 50% faster and heal for 50% more.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1394 - $GC_I_SKILL_ID_HEALERS_COVENANT
Func CanUse_HealersCovenant()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HealersCovenant($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1395 - $GC_I_SKILL_ID_BALTHAZARS_PENDULUM
Func CanUse_BalthazarsPendulum()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BalthazarsPendulum($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1399 - $GC_I_SKILL_ID_SHIELD_OF_ABSORPTION
Func CanUse_ShieldOfAbsorption()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldOfAbsorption($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 3...6...7 seconds, damage received by target ally is reduced by 5 each time that ally is hit while under the effects of this enchantment.
	; Concise description
	; Enchantment Spell. (3...6...7 seconds.) Reduces incoming damage by 5 each time target ally takes damage.
	Return 0
EndFunc

; Skill ID: 1400 - $GC_I_SKILL_ID_REVERSAL_OF_DAMAGE
Func CanUse_ReversalOfDamage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ReversalOfDamage($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8 seconds, the next time target ally would take damage, the foe dealing the damage takes that damage instead (maximum 5...61...75).
	; Concise description
	; Enchantment Spell. (8 seconds.) Negates the next damage and hits the source for that same amount (maximum 5...61...75).
	Return 0
EndFunc

; Skill ID: 1450 - $GC_I_SKILL_ID_ABADDONS_CONSPIRACY
Func CanUse_AbaddonsConspiracy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AbaddonsConspiracy($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 1457 - $GC_I_SKILL_ID_ABADDONS_CHOSEN
Func CanUse_AbaddonsChosen()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AbaddonsChosen($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1480 - $GC_I_SKILL_ID_SPIRITS_GIFT
Func CanUse_SpiritsGift()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritsGift($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1492 - $GC_I_SKILL_ID_REMOVE_WIND_PRAYERS_SKILL
Func CanUse_RemoveWindPrayersSkill()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveWindPrayersSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1493 - $GC_I_SKILL_ID_GRENTHS_FINGERS
Func CanUse_GrenthsFingers()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_GrenthsFingers($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1494 - $GC_I_SKILL_ID_REMOVE_BOON_OF_THE_GODS
Func CanUse_RemoveBoonOfTheGods()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveBoonOfTheGods($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1495 - $GC_I_SKILL_ID_AURA_OF_THORNS
Func CanUse_AuraOfThorns()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfThorns($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. All nearby foes begin Bleeding for 5...13...15 seconds. For 30 seconds, this enchantment does nothing. When this enchantment ends, all nearby foes are Crippled for 3...7...8 seconds.
	; Concise description
	; Flash Enchantment Spell. (30 seconds.) Initial effect: inflicts Bleeding condition (5...13...15 seconds) on nearby foes. End effect: inflicts Crippled condition (3...7...8 seconds) on nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1496 - $GC_I_SKILL_ID_BALTHAZARS_RAGE
Func CanUse_BalthazarsRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BalthazarsRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1497 - $GC_I_SKILL_ID_DUST_CLOAK
Func CanUse_DustCloak()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DustCloak($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. All adjacent foes are struck for 10...34...40 earth damage. For 30 seconds, your attacks deal earth damage. When this enchantment ends, all adjacent foes are Blinded for 1...3...4 second[s].
	; Concise description
	; Flash Enchantment Spell. (30 seconds.) Your attacks deal earth damage. Initial effect: deals 10...34...40 earth damage to adjacent foes. End effect: inflicts Blindness condition (1...3...4 second[s]) on adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1498 - $GC_I_SKILL_ID_STAGGERING_FORCE
Func CanUse_StaggeringForce()
	If Anti_Enchantment() Then Return False
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") <= 1 Then Return False
	Return True
EndFunc

Func BestTarget_StaggeringForce($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. All nearby foes are struck for 10...34...40 earth damage. For 30 seconds, your attacks deal earth damage. When this enchantment ends, all nearby foes have Cracked Armor for 1...8...10 second[s].
	; Concise description
	; Flash Enchantment Spell. (30 seconds.) Your attacks deal earth damage. Initial effect: deals 10...34...40 earth damage to nearby foes. End effect: inflicts Cracked Armor condition (1...8...10 second[s]) on nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1499 - $GC_I_SKILL_ID_PIOUS_RENEWAL
Func CanUse_PiousRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PiousRenewal($a_f_AggroRange)
	; Description
	; Elite Flash Enchantment Spell. For 8 seconds, nothing happens. When this enchantment ends, Pious Renewal is recharged and you gain 0...4...5 Energy and 0...24...30 Health.
	; Concise description
	; Elite Flash Enchantment Spell. (8 seconds.) End Effect: recharges itself and you gain 0...4...5 Energy and 0...24...30 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1500 - $GC_I_SKILL_ID_MIRAGE_CLOAK
Func CanUse_MirageCloak()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MirageCloak($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. For 1...6...7 second[s], you have a 40...72...80% chance to block incoming attacks. When you cast this enchantment, all nearby foes are struck for 10...34...40 earth damage.
	; Concise description
	; Flash Enchantment Spell. (1...6...7 second[s].) You have 40...72...80% chance to block. Initial Effect: deals 10...34...40 earth damage to nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1501 - $GC_I_SKILL_ID_REMOVE_BALTHAZARS_RAGE
Func CanUse_RemoveBalthazarsRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_RemoveBalthazarsRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1502 - $GC_I_SKILL_ID_ARCANE_ZEAL
Func CanUse_ArcaneZeal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ArcaneZeal($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 10 seconds, whenever you cast a spell, you gain 1 Energy for each enchantment on you (maximum 1...6...7 Energy).
	; Concise description
	; Elite Enchantment Spell. (10 seconds.) You gain 1 Energy (maximum 1...6...7) for each enchantment on you whenever you cast a spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1503 - $GC_I_SKILL_ID_MYSTIC_VIGOR
Func CanUse_MysticVigor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MysticVigor($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 20 seconds, every time you successfully hit with an attack, you gain 3...13...15 Health for each enchantment on you (maximum 25 Health).
	; Concise description
	; Enchantment Spell. (20 seconds.) You gain 3...13...15 Health (maximum 25) for each enchantment on you whenever you hit with an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1504 - $GC_I_SKILL_ID_WATCHFUL_INTERVENTION
Func CanUse_WatchfulIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WatchfulIntervention($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, the next time damage drops target ally's Health below 25%, that ally is healed for 50...170...200 Health.
	; Concise description
	; Enchantment Spell. (60 seconds.) Heals for 50...170...200 the next time damage drops target ally's Health below 25%.
	Return 0
EndFunc

; Skill ID: 1505 - $GC_I_SKILL_ID_VOW_OF_PIETY
Func CanUse_VowOfPiety()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VowOfPiety($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 20 seconds, you have +24 armor and +1...3...4 Health regeneration. Vow of Piety renews whenever an enchantment on you ends.
	; Concise description
	; Enchantment Spell. (20 seconds) +24 armor and +1...3...4 Health regeneration. Renewal: Whenever an enchantment on you ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1506 - $GC_I_SKILL_ID_VITAL_BOON
Func CanUse_VitalBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VitalBoon($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 20 seconds, you have +40...88...100 maximum Health. When this enchantment ends, you are healed for 75...175...200 Health.
	; Concise description
	; Enchantment Spell. (20 seconds.) You have +40...88...100 maximum Health. End effect: Heals you for 75...175...200.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1507 - $GC_I_SKILL_ID_HEART_OF_HOLY_FLAME
Func CanUse_HeartOfHolyFlame()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HeartOfHolyFlame($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. All nearby foes take 5...25...30 holy damage. For 30 seconds, your attacks deal holy damage. When this enchantment ends, all nearby foes are set on fire for 2...4...5 seconds.
	; Concise description
	; Flash Enchantment Spell. (30 seconds.) Your attacks deal holy damage. Initial effect: deals 5...25...30 holy damage to nearby foes. End effect: inflicts Burning condition (2...4...5 seconds) on nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1509 - $GC_I_SKILL_ID_FAITHFUL_INTERVENTION
Func CanUse_FaithfulIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FaithfulIntervention($a_f_AggroRange)
	; Description
	; Enchantment Spell. If damage drops your Health below 50%, Faithful Intervention ends. When Faithful Intervention ends, you are healed for 30...126...150 Health.
	; Concise description
	; Enchantment Spell. You gain 30...126...150 Health the next time damage drops your Health below 50%.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1510 - $GC_I_SKILL_ID_SAND_SHARDS
Func CanUse_SandShards()
	If Anti_Enchantment() Then Return False
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") <= 1 Then Return False
	Return True
EndFunc

Func BestTarget_SandShards($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. For 30 seconds, the next 1...4...5 time[s] you hit with a scythe, all other adjacent foes take 10...50...60 earth damage.
	; Concise description
	; Flash Enchantment Spell. (30 seconds.) Deal 10...50...60 earth damage to all other adjacent foes whenever you hit with your scythe. Ends after 1...4...5 hit[s].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1511 - $GC_I_SKILL_ID_INTIMIDATING_AURA_BETA_VERSION
Func CanUse_IntimidatingAuraBetaVersion()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IntimidatingAuraBetaVersion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1512 - $GC_I_SKILL_ID_LYSSAS_HASTE
Func CanUse_LyssasHaste()
	If Anti_Enchantment() Then Return False
	Local $l_i_NearestEnemy = UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
	If UAI_GetAgentInfoByID($l_i_NearestEnemy, $GC_UAI_AGENT_Distance) > $GC_I_RANGE_ADJACENT Then Return False
	Return True
EndFunc

Func BestTarget_LyssasHaste($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. For 3...13...15 seconds, your Dervish enchantments recharge 33% faster. When you activate this enchantment, all adjacent foes are interrupted. When this enchantment ends, all adjacent foes are interrupted. 50% failure chance unless Wind Prayers 5 or higher.
	; Concise description
	; Flash Enchantment Spell. (3...13...15 seconds.) Your Dervish enchantments recharge 33% faster. Initial Effect: interrupts all adjacent foes. End Effect: interrupts all adjacent foes. 50% failure chance unless Wind Prayers 5 or higher.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1513 - $GC_I_SKILL_ID_GUIDING_HANDS
Func CanUse_GuidingHands()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_GuidingHands($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 20 seconds, your next 0...2...3 attack[s] cannot be blocked. When activated, this skill removes the Blindness condition.
	; Concise description
	; Enchantment Spell. (20 seconds.) Your next 0...2...3 attack[s] cannot be blocked. Initial effect: removes Blindness.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1514 - $GC_I_SKILL_ID_FLEETING_STABILITY
Func CanUse_FleetingStability()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FleetingStability($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. For 2...5...6 seconds, you cannot be knocked down and move 25% faster. This enchantment ends prematurely if it prevents a knockdown.
	; Concise description
	; Flash Enchantment Spell. (2...5...6 seconds.) You cannot be knocked down and move 25% faster. Ends if knockdown prevented.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1515 - $GC_I_SKILL_ID_ARMOR_OF_SANCTITY
Func CanUse_ArmorOfSanctity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ArmorOfSanctity($a_f_AggroRange)
	; Description
	; Enchantment Spell. All adjacent foes suffer from Weakness for 5...13...15 seconds. For 15 seconds, you take 5...17...20 less damage from foes suffering from a condition.
	; Concise description
	; Enchantment Spell. Inflicts Weakness condition on all adjacent foes (5...13...15). You take 5...17...20 less damage from foes with a condition. (15 seconds.)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1516 - $GC_I_SKILL_ID_MYSTIC_REGENERATION
Func CanUse_MysticRegeneration()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) >= 0.95 Then Return False
	Return True
EndFunc

Func BestTarget_MysticRegeneration($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...17...20 seconds, you have +1...3...4 Health regeneration for each enchantment (maximum of 8) on you.
	; Concise description
	; Enchantment Spell. (5...17...20 seconds.) You have +1...3...4 Health regeneration for each enchantment (maximum of 8) on you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1517 - $GC_I_SKILL_ID_VOW_OF_SILENCE
Func CanUse_VowOfSilence()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VowOfSilence($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 5...9...10 seconds, you cannot be the target of spells, and you cannot cast spells.
	; Concise description
	; Elite Enchantment Spell. (5...9...10 seconds.) Spells cannot target you. You cannot cast spells.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1523 - $GC_I_SKILL_ID_MEDITATION
Func CanUse_Meditation()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Meditation($a_f_AggroRange)
	; Description
	; Enchantment Spell. Lose all adrenaline. For 20 seconds, you gain 1...3...4 Energy every time an enchantment on you ends.
	; Concise description
	; Enchantment Spell. (20 seconds.) Lose all adrenaline. Gain 1...3...4 Energy whenever an enchantment on you ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1524 - $GC_I_SKILL_ID_EREMITES_ZEAL
Func CanUse_EremitesZeal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EremitesZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1531 - $GC_I_SKILL_ID_INTIMIDATING_AURA
Func CanUse_IntimidatingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IntimidatingAura($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, you have +40...88...100 max Health and take 1...8...10 less damage from foes with less Health than you.
	; Concise description
	; Enchantment Spell. (60 seconds.) You have +40...88...100 max Health and take &#45;1...8...10 damage from foes with less Health than you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1540 - $GC_I_SKILL_ID_CONVICTION
Func CanUse_Conviction()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Conviction($a_f_AggroRange)
	; Description
	; This article is about the skill. For the weapon with the same name, see Conviction (weapon).
	; Concise description
	; green; font-weight: bold;">1...3...3
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1541 - $GC_I_SKILL_ID_ENCHANTED_HASTE
Func CanUse_EnchantedHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EnchantedHaste($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. For 7 seconds, you move 25% faster. If this enchantment ends prematurely, you lose 1 condition.
	; Concise description
	; Flash Enchantment Spell. (7 seconds). You move 25% faster. Lose 1 condition if this enchantment ends prematurely.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1544 - $GC_I_SKILL_ID_WHIRLING_CHARGE
Func CanUse_WhirlingCharge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WhirlingCharge($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. For 1...5...6 second[s], you move 33% faster than normal. The next time you strike a foe, all other nearby foes take 10...50...60 cold damage and this enchantment ends.
	; Concise description
	; Flash Enchantment Spell. (1...5...6 second[s].) You move 33% faster. Deal 10...50...60 cold damage to all other nearby foes the next time you hit a foe and this enchantment ends.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1612 - $GC_I_SKILL_ID_SUGAR_RUSH_LONG
Func CanUse_SugarRushLong()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SugarRushLong($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1638 - $GC_I_SKILL_ID_DEADLY_HASTE
Func CanUse_DeadlyHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DeadlyHaste($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...30...35 seconds, half-ranged spells cast 5...41...50% faster and recharge 5...41...50% faster.
	; Concise description
	; Enchantment Spell. (10...30...35 seconds.) Your half-ranged spells cast 5...41...50% faster and recharge 5...41...50% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1639 - $GC_I_SKILL_ID_ASSASSINS_REMEDY
Func CanUse_AssassinsRemedy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AssassinsRemedy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1640 - $GC_I_SKILL_ID_FOXS_PROMISE
Func CanUse_FoxsPromise()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FoxsPromise($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1641 - $GC_I_SKILL_ID_FEIGNED_NEUTRALITY
Func CanUse_FeignedNeutrality()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FeignedNeutrality($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 4...9...10 seconds, you have +7 Health regeneration and +80 armor. This enchantment ends if you successfully hit with an attack or use a skill.
	; Concise description
	; Enchantment Spell. (4...9...10 seconds.) You have +7 Health regeneration and +80 armor. Ends if you hit with an attack or use a skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1654 - $GC_I_SKILL_ID_SHADOW_MELD
Func CanUse_ShadowMeld()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowMeld($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. Shadow Step to target other ally. When you stop maintaining this Enchantment, you return to your original location.
	; Concise description
	; Elite Enchantment Spell. Shadow Step to target ally. End effect: return to your original location. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 1663 - $GC_I_SKILL_ID_ELEMENTAL_FLAME
Func CanUse_ElementalFlame()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ElementalFlame($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...30...35 seconds, whenever you apply an Elemental hex to a foe, that foe is set on fire for 1...4...5 second[s].
	; Concise description
	; Enchantment Spell. (10...30...35 seconds.) Inflicts Burning condition (1...4...5 second[s]) whenever you apply an Elemental hex to a target.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1683 - $GC_I_SKILL_ID_PENSIVE_GUARDIAN
Func CanUse_PensiveGuardian()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PensiveGuardian($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...10...11 seconds, target ally has a 50% chance to block attacks from enchanted foes.
	; Concise description
	; Enchantment Spell. (5...10...11 seconds.) 50% chance to block enchanted foes.
	Return 0
EndFunc

; Skill ID: 1684 - $GC_I_SKILL_ID_SCRIBES_INSIGHT
Func CanUse_ScribesInsight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ScribesInsight($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1685 - $GC_I_SKILL_ID_HOLY_HASTE
Func CanUse_HolyHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HolyHaste($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 1...48...60 second[s], your Healing Prayers spells cast 50% faster. This enchantment ends if you cast another enchantment.
	; Concise description
	; Enchantment Spell. (1...48...60 second[s].) Your Healing Prayers spells cast 50% faster. Ends if you cast an enchantment.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1736 - $GC_I_SKILL_ID_SPIRITS_STRENGTH
Func CanUse_SpiritsStrength()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritsStrength($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1737 - $GC_I_SKILL_ID_WIELDERS_ZEAL
Func CanUse_WieldersZeal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WieldersZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1738 - $GC_I_SKILL_ID_SIGHT_BEYOND_SIGHT
Func CanUse_SightBeyondSight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SightBeyondSight($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 8...18...20 seconds, you cannot be Blinded.
	; Concise description
	; Enchantment Spell. (8...18...20 seconds). You are immune to Blindness.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1739 - $GC_I_SKILL_ID_RENEWING_MEMORIES
Func CanUse_RenewingMemories()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_RenewingMemories($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...17...20 seconds, while holding an item, any weapon and item Spells you cast cost 5...29...35% less Energy.
	; Concise description
	; Enchantment Spell. (5...17...20 seconds.) Your weapon and item spells cost 5...29...35% less Energy. No effect unless holding an item.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1740 - $GC_I_SKILL_ID_WIELDERS_REMEDY
Func CanUse_WieldersRemedy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WieldersRemedy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1754 - $GC_I_SKILL_ID_ONSLAUGHT
Func CanUse_Onslaught()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Onslaught($a_f_AggroRange)
	; Description
	; Elite Flash Enchantment Spell. For 3...13...15 seconds, you attack, move and gain adrenaline 25% faster.
	; Concise description
	; Elite Flash Enchantment Spell. (3...13...15 seconds.) You attack, move and gain adrenaline 25% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1755 - $GC_I_SKILL_ID_MYSTIC_CORRUPTION
Func CanUse_MysticCorruption()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MysticCorruption($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. All adjacent foes suffer from Disease for 1...2...2 second[s]. For 20 seconds, nothing happens. Disease duration is doubled if you are enchanted when you activate this skill. When this enchantment ends, all party members in earshot are cured of Disease.
	; Concise description
	; Flash Enchantment Spell. (20 seconds.) Initial Effect: all adjacent foes are Diseased (1...2...2 second[s].) Double duration if you are already enchanted. End Effect: party members in earshot lose Disease.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1756 - $GC_I_SKILL_ID_GRENTHS_GRASP
Func CanUse_GrenthsGrasp()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_GrenthsGrasp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1757 - $GC_I_SKILL_ID_VEIL_OF_THORNS
Func CanUse_VeilOfThorns()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VeilOfThorns($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. When you cast this enchantment, all nearby foes are struck for 5...41...50 piercing damage. For 5...21...25 seconds you take 5...29...35% less damage from spells.
	; Concise description
	; Flash Enchantment Spell. (5...21...25 seconds.) Spell damage is reduced by 5...29...35%. Initial Effect: nearby foes are struck for 5...41...50 piercing damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1758 - $GC_I_SKILL_ID_HARRIERS_GRASP
Func CanUse_HarriersGrasp()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HarriersGrasp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1759 - $GC_I_SKILL_ID_VOW_OF_STRENGTH
Func CanUse_VowOfStrength()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VowOfStrength($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 15 seconds, whenever you attack a foe with your scythe, you deal 10...22...25 slashing damage to all adjacent foes.
	; Concise description
	; Elite Enchantment Spell. (15 seconds.) When you attack with a scythe, deals 10...22...25 slashing damage to adjacent foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1760 - $GC_I_SKILL_ID_EBON_DUST_AURA
Func CanUse_EbonDustAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EbonDustAura($a_f_AggroRange)
	; Description
	; Elite Flash Enchantment Spell. When you cast this enchantment, all nearby foes are Blinded for 1...6...7 second[s]. For 30 seconds, if you are wielding an earth weapon, your melee attacks deal +3...13...15 earth damage. When this enchantment ends, you are cured of Blindness.
	; Concise description
	; Elite Flash Enchantment Spell. (30 seconds.) Deal +3...13...15 earth damage with your melee attacks. Initial Effect: Blinds nearby foes for 1...6...7 second[s]. End Effect: removes Blindness. No effect unless wielding an earth weapon.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1761 - $GC_I_SKILL_ID_ZEALOUS_VOW
Func CanUse_ZealousVow()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ZealousVow($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 20 seconds, you have -3 Energy regeneration, and you gain 1...5...6 Energy every time you hit with an attack.
	; Concise description
	; Elite Enchantment Spell. (20 seconds.) You gain 1...5...6 Energy each time you hit with an attack. You have -3 Energy regeneration.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1763 - $GC_I_SKILL_ID_ZEALOUS_RENEWAL
Func CanUse_ZealousRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ZealousRenewal($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. All nearby foes take 5...25...30 holy damage. For 5...21...25 seconds, you have -1 Energy regeneration, and gain 1 Energy whenever you hit a foe. If this enchantment ends prematurely, you gain 1...4...5 Energy.
	; Concise description
	; Flash Enchantment Spell. (5...21...25 seconds.) Initial effect: deals 5...25...30 holy damage to nearby foes. You have -1 Energy regeneration and gain 1 Energy when you hit. Gain 1...4...5 Energy if this enchantment ends early.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1764 - $GC_I_SKILL_ID_ATTACKERS_INSIGHT
Func CanUse_AttackersInsight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AttackersInsight($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1765 - $GC_I_SKILL_ID_RENDING_AURA
Func CanUse_RendingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_RendingAura($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. When you cast this enchantment, all nearby foes take 10...34...40 cold damage. For&#160;&#160;30  seconds, your attack skills remove enchantments from knocked-down foes. When this enchantment ends, nearby foes are affected by Cracked Armor for 1...8...10 second[s].
	; Concise description
	; Flash Enchantment Spell. (30 seconds.) Your attack skills remove enchantments from knocked-down foes. Initial effect: deals 10...34...40 cold damage to all nearby foes. End effect: nearby foes have Cracked Armor for 1...8...10 second[s].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1766 - $GC_I_SKILL_ID_FEATHERFOOT_GRACE
Func CanUse_FeatherfootGrace()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FeatherfootGrace($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...17...20 seconds, you move 25% faster, and conditions expire 25% faster.
	; Concise description
	; Enchantment Spell. (5...17...20 seconds.) You move 25% faster, and conditions expire 25% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1768 - $GC_I_SKILL_ID_HARRIERS_HASTE
Func CanUse_HarriersHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HarriersHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1787 - $GC_I_SKILL_ID_ACCELERATED_GROWTH
Func CanUse_AcceleratedGrowth()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AcceleratedGrowth($a_f_AggroRange)
	; Description
	; Ritualist
	; Concise description
	; green; font-weight: bold;">15...51...60
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1820 - $GC_I_SKILL_ID_SPIRIT_FORM_REMAINS_OF_SAHLAHJA
Func CanUse_SpiritFormRemainsOfSahlahja()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritFormRemainsOfSahlahja($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1821 - $GC_I_SKILL_ID_GODS_BLESSING
Func CanUse_GodsBlessing()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_GodsBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1860 - $GC_I_SKILL_ID_SUGAR_RUSH_SHORT
Func CanUse_SugarRushShort()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SugarRushShort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1916 - $GC_I_SKILL_ID_SUGAR_JOLT_SHORT
Func CanUse_SugarJoltShort()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SugarJoltShort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1933 - $GC_I_SKILL_ID_SUGAR_JOLT_LONG
Func CanUse_SugarJoltLong()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SugarJoltLong($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1948 - $GC_I_SKILL_ID_SHADOW_SANCTUARY_LUXON2
Func CanUse_ShadowSanctuaryLuxon2()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowSanctuaryLuxon2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1951 - $GC_I_SKILL_ID_ELEMENTAL_LORD_LUXON
Func CanUse_ElementalLordLuxon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ElementalLordLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1952 - $GC_I_SKILL_ID_SELFLESS_SPIRIT_LUXON
Func CanUse_SelflessSpiritLuxon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SelflessSpiritLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1955 - $GC_I_SKILL_ID_AURA_OF_HOLY_MIGHT_LUXON
Func CanUse_AuraOfHolyMightLuxon()
	If Anti_Enchantment() Then Return False
	If UAI_AgentHasEffect(Agent_GetMyID(), $GC_I_SKILL_ID_PIOUS_RENEWAL) Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfHolyMightLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1989 - $GC_I_SKILL_ID_WAY_OF_THE_MANTIS
Func CanUse_WayOfTheMantis()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfTheMantis($a_f_AggroRange)
	; Description
	; Assassin
	; Concise description
	; Trivia">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1997 - $GC_I_SKILL_ID_WITHERING_AURA
Func CanUse_WitheringAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WitheringAura($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...17...20 seconds, target ally's melee attacks cause Weakness for 5...17...20 seconds.
	; Concise description
	; Enchantment Spell. (5...17...20 seconds.) Target ally's melee attacks cause Weakness condition (5...17...20 seconds.)
	Return 0
EndFunc

; Skill ID: 2005 - $GC_I_SKILL_ID_SMITERS_BOON
Func CanUse_SmitersBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SmitersBoon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2007 - $GC_I_SKILL_ID_PURIFYING_VEIL
Func CanUse_PurifyingVeil()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PurifyingVeil($a_f_AggroRange)
	; Description
	; Enchantment Spell. While you maintain this enchantment, conditions expire 5...41...50% faster on target ally. When this enchantment ends, one condition is removed from that ally.
	; Concise description
	; Enchantment Spell. Conditions expire 5...41...50% faster on target ally. End effect: removes a condition.
	Return 0
EndFunc

; Skill ID: 2013 - $GC_I_SKILL_ID_GRENTHS_AURA
Func CanUse_GrenthsAura()
	If Anti_Enchantment() Then Return False
	Local $l_i_NearestEnemy = UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
	If UAI_GetAgentInfoByID($l_i_NearestEnemy, $GC_UAI_AGENT_Distance) > $GC_I_RANGE_ADJACENT Then Return False
	Return True
EndFunc

Func BestTarget_GrenthsAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2061 - $GC_I_SKILL_ID_PATIENT_SPIRIT
Func CanUse_PatientSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PatientSpirit($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 2 seconds, target ally is enchanted with Patient Spirit. Unless this enchantment ends prematurely, that ally is healed for 30...102...120 Health when the enchantment ends.
	; Concise description
	; Enchantment Spell. (2 seconds.) End effect: heals for 30...102...120. No effect if ends early.
	Return 0
EndFunc

; Skill ID: 2063 - $GC_I_SKILL_ID_AURA_OF_STABILITY
Func CanUse_AuraOfStability()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfStability($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 3...7...8 seconds, target other ally cannot be knocked down.
	; Concise description
	; Enchantment Spell. (3...7...8 seconds.) Target ally cannot be knocked-down. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 2064 - $GC_I_SKILL_ID_SPOTLESS_MIND
Func CanUse_SpotlessMind()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpotlessMind($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 1...12...15 seconds, target other ally loses a hex every 5 seconds.
	; Concise description
	; Enchantment Spell. (1...12...15 seconds.) Removes a hex every 5 seconds. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 2065 - $GC_I_SKILL_ID_SPOTLESS_SOUL
Func CanUse_SpotlessSoul()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpotlessSoul($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 1...12...15 seconds, target other ally loses a condition every 3 seconds.
	; Concise description
	; Enchantment Spell. (1...12...15 seconds.) Removes a condition every 3 seconds. Cannot self-target.
	Return 0
EndFunc

; Skill ID: 2091 - $GC_I_SKILL_ID_SHADOW_SANCTUARY_KURZICK
Func CanUse_ShadowSanctuaryKurzick()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowSanctuaryKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2094 - $GC_I_SKILL_ID_ELEMENTAL_LORD_KURZICK
Func CanUse_ElementalLordKurzick()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ElementalLordKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2095 - $GC_I_SKILL_ID_SELFLESS_SPIRIT_KURZICK
Func CanUse_SelflessSpiritKurzick()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SelflessSpiritKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2098 - $GC_I_SKILL_ID_AURA_OF_HOLY_MIGHT_KURZICK
Func CanUse_AuraOfHolyMightKurzick()
	If Anti_Enchantment() Then Return False
	If UAI_AgentHasEffect(Agent_GetMyID(), $GC_I_SKILL_ID_PIOUS_RENEWAL) Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfHolyMightKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2101 - $GC_I_SKILL_ID_CRITICAL_AGILITY
Func CanUse_CriticalAgility()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_CriticalAgility($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 4 seconds and 1 second for each rank of Critical Strikes, you attack 33% faster and gain 15...25 armor. This skill reapplies itself every time you land a critical hit.
	; Concise description
	; Enchantment Spell. (4 seconds plus 1 second for each rank of Critical Strikes.) You attack 33% faster and gain +15...25 armor. Renewal: every time you land a critical hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2105 - $GC_I_SKILL_ID_SEED_OF_LIFE
Func CanUse_SeedOfLife()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SeedOfLife($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 2...5 seconds, whenever target other ally takes damage, all party members are healed for 2 Health for each rank in Divine Favor.
	; Concise description
	; Enchantment Spell. (2...5) seconds. Heals party members for 2 for each rank in Divine Favor whenever target takes damage. Cannot self target.
	Return 0
EndFunc

; Skill ID: 2109 - $GC_I_SKILL_ID_ETERNAL_AURA
Func CanUse_EternalAura()
	If Anti_Enchantment() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc

Func BestTarget_EternalAura($a_f_AggroRange)
	; Description
	; Enchantment Spell. You have +100 max Health. When this enchantment ends, all party members in the area are resurrected with 40...50% Health and 20...30% Energy.
	; Concise description
	; Enchantment Spell. You have +100 max Health. End effect: all party members in the area are resurrected with 40...50% Health and 20...30% Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2128 - $GC_I_SKILL_ID_VOLFEN_POUNCE_CURSE_OF_THE_NORNBEAR
Func CanUse_VolfenPounceCurseOfTheNornbear()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenPounceCurseOfTheNornbear($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2138 - $GC_I_SKILL_ID_HEXERS_VIGOR
Func CanUse_HexersVigor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HexersVigor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2139 - $GC_I_SKILL_ID_MASOCHISM
Func CanUse_Masochism()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_MASOCHISM, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc

Func BestTarget_Masochism($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...34...40 seconds, you have +2 to your Death Magic and Soul Reaping attributes and sacrifice 5...3...3% of your maximum Health when you cast a spell.
	; Concise description
	; Enchantment Spell. (10...34...40 seconds.) You have +2 Death Magic and Soul Reaping. Sacrifice 5...3...3% Health when you cast a spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2187 - $GC_I_SKILL_ID_WAY_OF_THE_MASTER
Func CanUse_WayOfTheMaster()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_WayOfTheMaster($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 60 seconds, while holding a non-dagger weapon, you have an additional 3...27...33% chance to land a critical hit.
	; Concise description
	; Enchantment Spell. (60 seconds.) While holding a non-dagger weapon, you have +3...27...33% chance to land a critical hit.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2190 - $GC_I_SKILL_ID_MAGNETIC_SURGE
Func CanUse_MagneticSurge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MagneticSurge($a_f_AggroRange)
	; Description
	; Enchantment Spell. Target foe takes 15...63...75 damage. If you are Overcast, Magnetic Surge enchants all allies in earshot for 1...4...5 second[s] to block the next attack against them.
	; Concise description
	; Enchantment Spell. Deals 15...63...75 damage. If you are Overcast, allies in earshot are enchanted for 1...4...5 [sic] and block the next attack against them.
	Return 0
EndFunc

; Skill ID: 2201 - $GC_I_SKILL_ID_SHIELD_OF_FORCE
Func CanUse_ShieldOfForce()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShieldOfForce($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. For 1...13...16 second[s], blocks the next 1 attack against you. If an attack is blocked, all adjacent attacking foes are knocked down and suffer from Weakness for 5...17...20 seconds.
	; Concise description
	; Flash Enchantment Spell. (1...13...16 second[s].) Blocks the next 1 attack against you. Knocks down and inflicts Weakness (5...17...20 seconds) on all adjacent attacking foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2220 - $GC_I_SKILL_ID_GREAT_DWARF_ARMOR
Func CanUse_GreatDwarfArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_GreatDwarfArmor($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 22...40 seconds, target ally has +24 armor, +60 maximum Health, and an additional +24 armor against Destroyers.
	; Concise description
	; Enchantment Spell. (22...40 seconds.) +24 armor and +60 maximum Health. Additional +24 armor against Destroyers.
	Return 0
EndFunc

; Skill ID: 2249 - $GC_I_SKILL_ID_POLYMOCK_BLOCK
Func CanUse_PolymockBlock()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockBlock($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 2 seconds, the next enemy spell that targets you fails.
	; Concise description
	; Enchantment Spell. (2 seconds.) The next enemy spell that targets you fails.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2265 - $GC_I_SKILL_ID_POLYMOCK_LIGHTNING_DJINNS_HASTE
Func CanUse_PolymockLightningDjinnsHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockLightningDjinnsHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2280 - $GC_I_SKILL_ID_POLYMOCK_FROZEN_ARMOR
Func CanUse_PolymockFrozenArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_PolymockFrozenArmor($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 30 seconds, you gain 1,000 maximum Health.
	; Concise description
	; Enchantment Spell. (30 seconds.) You have +1,000 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2328 - $GC_I_SKILL_ID_CRYSTAL_SHIELD
Func CanUse_CrystalShield()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_CrystalShield($a_f_AggroRange)
	; Description
	; Enchantment Spell. This creature conjures a shield that absorbs 250 damage.
	; Concise description
	; Enchantment Spell. The ettin conjures a shield that absorbs 250 damage. The ettin can cast spells but not attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2383 - $GC_I_SKILL_ID_VOLFEN_AGILITY
Func CanUse_VolfenAgility()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VolfenAgility($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...20 seconds your Volfen Skills recharge 66% faster.
	; Concise description
	; Enchantment Spell. (10...20 seconds.) Your Volfen skills recharge 66% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2411 - $GC_I_SKILL_ID_MINDBENDER
Func CanUse_Mindbender()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_Mindbender($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 10...16 seconds, you move 20...33% faster and your Spells take 20% less time to cast.
	; Concise description
	; Enchantment Spell. (10...16 seconds.) You move 20...33% faster and cast Spells 20% faster.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2417 - $GC_I_SKILL_ID_MENTAL_BLOCK
Func CanUse_MentalBlock()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MentalBlock($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 5...11 seconds you have a 50% chance to block attacks. This Enchantment is reapplied every time an enemy strikes you.
	; Concise description
	; Enchantment Spell. (5...11 seconds.) You have a 50% chance to block. Renewal: every time an enemy hits you.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2423 - $GC_I_SKILL_ID_DWARVEN_STABILITY
Func CanUse_DwarvenStability()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DwarvenStability($a_f_AggroRange)
	; Description
	; Enchantment Spell. For 24...30 seconds, your stances last 55...100% longer. If you activated this skill while drunk, you cannot be knocked down.
	; Concise description
	; Enchantment Spell. (24...30 seconds.) Your stances last 55...100% longer. You cannot be knocked-down if you activated this skill while drunk . [sic]
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2635 - $GC_I_SKILL_ID_FLAME_DJINNS_HASTE2
Func CanUse_FlameDjinnsHaste2()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_FlameDjinnsHaste2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2638 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2655 - $GC_I_SKILL_ID_DRAGON_EMPIRE_RAGE
Func CanUse_DragonEmpireRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DragonEmpireRage($a_f_AggroRange)
	; Description
	; Enchantment Spell. Unleash the rage of the Dragon Empire bloodline, dealing 300 damage to all nearby enemies. For 15 seconds you gain 200 maximum Health.
	; Concise description
	; Enchantment Spell. Unleash the rage of the Dragon Empire bloodline and deal 300 damage to nearby enemies. You gain 200 maximum health (15 seconds).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2730 - $GC_I_SKILL_ID_AURA_OF_PURITY
Func CanUse_AuraOfPurity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfPurity($a_f_AggroRange)
	; Description
	; Flash Enchantment Spell. All adjacent foes lose 1 enchantment. For 10 seconds, your attacks deal +1...10...12 holy damage. When Aura of Purity ends, all adjacent foes lose one enchantment.
	; Concise description
	; Flash Enchantment Spell. Your attacks deal +1...10...12 holy damage (10 seconds). Initial effect: all adjacent foes lose 1 enchantment. End effect: all adjacent foes lose one enchantment.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2791 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2797 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2805 - $GC_I_SKILL_ID_MIST_FORM_PvP
Func CanUse_MistFormPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MistFormPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2857 - $GC_I_SKILL_ID_AEGIS_PvP
Func CanUse_AegisPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AegisPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2860 - $GC_I_SKILL_ID_ETHER_RENEWAL_PvP
Func CanUse_EtherRenewalPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EtherRenewalPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2862 - $GC_I_SKILL_ID_SHADOW_FORM_PvP
Func CanUse_ShadowFormPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShadowFormPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2869 - $GC_I_SKILL_ID_ASSASSINS_REMEDY_PvP
Func CanUse_AssassinsRemedyPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AssassinsRemedyPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2884 - $GC_I_SKILL_ID_MYSTIC_REGENERATION_PvP
Func CanUse_MysticRegenerationPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MysticRegenerationPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2891 - $GC_I_SKILL_ID_UNYIELDING_AURA_PvP
Func CanUse_UnyieldingAuraPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_UnyieldingAuraPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2892 - $GC_I_SKILL_ID_SPIRIT_BOND_PvP
Func CanUse_SpiritBondPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SpiritBondPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 2895 - $GC_I_SKILL_ID_SMITERS_BOON_PvP
Func CanUse_SmitersBoonPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_SmitersBoonPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2912 - $GC_I_SKILL_ID_BIT_GOLEM_RECTIFIER
Func CanUse_BitGolemRectifier()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_BitGolemRectifier($a_f_AggroRange)
	; Description
	; Enchantment Spell. N.O.X. is healed for 10 Health every second.
	; Concise description
	; Enchantment Spell. Heals N.O.X. for 10 every second.
	Return 0
EndFunc

; Skill ID: 2915 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2934 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2943 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2956 - ;  $GC_I_SKILL_ID_UNKNOWN
; Skill ID: 2999 - $GC_I_SKILL_ID_STRENGTH_OF_HONOR_PvP
Func CanUse_StrengthOfHonorPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_StrengthOfHonorPvP($a_f_AggroRange)
	Return 0
EndFunc

; Skill ID: 3003 - $GC_I_SKILL_ID_ARMOR_OF_UNFEELING_PvP
Func CanUse_ArmorOfUnfeelingPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ArmorOfUnfeelingPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3048 - $GC_I_SKILL_ID_SHROUD_OF_DISTRESS_PvP
Func CanUse_ShroudOfDistressPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ShroudOfDistressPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3054 - $GC_I_SKILL_ID_MASOCHISM_PvP
Func CanUse_MasochismPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_MasochismPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3181 - $GC_I_SKILL_ID_ILLUSIONARY_WEAPONRY_PvP
Func CanUse_IllusionaryWeaponryPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IllusionaryWeaponryPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3267 - $GC_I_SKILL_ID_EBON_DUST_AURA_PvP
Func CanUse_EbonDustAuraPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_EbonDustAuraPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3268 - $GC_I_SKILL_ID_HEART_OF_HOLY_FLAME_PvP
Func CanUse_HeartOfHolyFlamePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_HeartOfHolyFlamePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3269 - $GC_I_SKILL_ID_GUIDING_HANDS_PvP
Func CanUse_GuidingHandsPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_GuidingHandsPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3346 - $GC_I_SKILL_ID_AURA_OF_THORNS_PvP
Func CanUse_AuraOfThornsPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfThornsPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3347 - $GC_I_SKILL_ID_DUST_CLOAK_PvP
Func CanUse_DustCloakPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_DustCloakPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3348 - $GC_I_SKILL_ID_LYSSAS_HASTE_PvP
Func CanUse_LyssasHastePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_LyssasHastePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3365 - $GC_I_SKILL_ID_ONSLAUGHT_PvP
Func CanUse_OnslaughtPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_OnslaughtPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3373 - $GC_I_SKILL_ID_ILLUSION_OF_HASTE_PvP
Func CanUse_IllusionOfHastePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_IllusionOfHastePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3375 - $GC_I_SKILL_ID_AURA_OF_RESTORATION_PvP
Func CanUse_AuraOfRestorationPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_AuraOfRestorationPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3397 - $GC_I_SKILL_ID_ELEMENTAL_FLAME_PvP
Func CanUse_ElementalFlamePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_ElementalFlamePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3423 - $GC_I_SKILL_ID_SOUL_TAKER
Func CanUse_SoulTaker()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOUL_TAKER, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc

Func BestTarget_SoulTaker($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 3...25...30 seconds, your attacks sacrifice 15...19...20 health and deal 15...19...20 more damage. PvE Skill
	; Concise description
	; Elite Enchantment Spell. (3...25...30 seconds.) Attacks deal +15...19...20 damage and sacrifice 15...19...20 health. PvE Skill
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3424 - $GC_I_SKILL_ID_OVER_THE_LIMIT
Func CanUse_OverTheLimit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_OverTheLimit($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. While you maintain this enchantment, your spells cast 15...19...20% faster, and recharge 15...43...50% faster, but you continuously gain Overcast. PvE Skill
	; Concise description
	; Elite Enchantment Spell. Spells cast 15...19...20% faster and recharge 15...43...50% faster. Continuously gain Overcast while active. PvE Skill
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3430 - $GC_I_SKILL_ID_VOW_OF_REVOLUTION
Func CanUse_VowOfRevolution()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc

Func BestTarget_VowOfRevolution($a_f_AggroRange)
	; Description
	; Elite Enchantment Spell. For 3...9...10 seconds, you have +1...4...5 energy regeneration. This skill reapplies itself every time you use a non-Dervish skill. PvE Skill
	; Concise description
	; Elite Enchantment Spell. (3...9...10 seconds.) Gain +1...4...5 energy regeneration. Renewal: whenever you use a non-Dervish skill. PvE Skill
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

