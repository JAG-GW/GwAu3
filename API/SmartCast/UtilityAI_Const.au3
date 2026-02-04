#include-once

Global $g_i_BestTarget = 0
Global $g_i_ForceTarget = 0
Global $g_i_LastCalledTarget = 0
Global $g_as_BestTargetCache[9]
Global $g_as_CanUseCache[9]
Global $g_b_CanUseSkill = True
Global $g_b_SkillChanged = False
Global $g_b_CacheWeaponSet = False
Global $g_b_CallTarget = True

;Slecet your combat mode:
; Finisher = priorize lowest hp target
; Pressure = priorize highest hp target
Global $g_i_FightMode = 1
Global Enum $g_i_FinisherMode, $g_i_PressureMode

;Weapon Set Data Indices
Global Const $GC_UAI_WEAPONSET_WeaponType = 0
Global Const $GC_UAI_WEAPONSET_WeaponId = 1
Global Const $GC_UAI_WEAPONSET_OffhandType = 2
Global Const $GC_UAI_WEAPONSET_OffhandId = 3
Global Const $GC_UAI_WEAPONSET_MaxHP = 4
Global Const $GC_UAI_WEAPONSET_MaxEnergy = 5
;New: Mod-based scores for combat decisions
Global Const $GC_UAI_WEAPONSET_OffensiveScore = 6    ;Sundering, Vampiric, Zealous, Damage+%, conditions
Global Const $GC_UAI_WEAPONSET_DefensiveScore = 7   ;Armor+, HP+, Damage reduction, Shield
Global Const $GC_UAI_WEAPONSET_CastingScore = 8     ;HCT, HSR, 40/40
Global Const $GC_UAI_WEAPONSET_EnchantScore = 9     ;Enchant duration +20%
Global Const $GC_UAI_WEAPONSET_IsRanged = 10        ;Bow, Spear, Wand, Staff
Global Const $GC_UAI_WEAPONSET_HasShield = 11       ;Has shield equipped
Global Const $GC_UAI_WEAPONSET_HasVampiric = 12     ;Has vampiric mod
Global Const $GC_UAI_WEAPONSET_HasZealous = 13      ;Has zealous mod

;Weapon Sets 2D Array: [SetIndex 0-3][DataIndex 0-13]
Global $g_a2D_WeaponSets[4][14] = [ _
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

;Best set trackers: [Score/Value, SetNumber]
Global $g_ai_High_Hp_Set[2] = [0, 0]
Global $g_ai_High_Energy_Set[2] = [0, 0]
Global $g_ai_Best_Offensive_Set[2] = [0, 0]
Global $g_ai_Best_Defensive_Set[2] = [0, 0]
Global $g_ai_Best_Casting_Set[2] = [0, 0]
Global $g_ai_Best_Enchant_Set[2] = [0, 0]
Global $g_ai_Best_Ranged_Set[2] = [0, 0]      ;[IsRanged (0/1), SetNumber]
Global $g_ai_Best_Vampiric_Set[2] = [0, 0]    ;[HasVampiric (0/1), SetNumber]
Global $g_ai_Best_Zealous_Set[2] = [0, 0]     ;[HasZealous (0/1), SetNumber]
;4 = set / 2 = weapon / 8 = Mods
Global $g_as3_Weapon_Mods[4][2][8] = [ _
		[["", "", "", "", "", "", "", ""], ["", "", "", "", "", "", "", ""]], _	;weapon set 1 / Weapon per set / mod per weapon
        [["", "", "", "", "", "", "", ""], ["", "", "", "", "", "", "", ""]], _	;weapon set 2 / Weapon per set / mod per weapon
        [["", "", "", "", "", "", "", ""], ["", "", "", "", "", "", "", ""]], _	;weapon set 3 / Weapon per set / mod per weapon
		[["", "", "", "", "", "", "", ""], ["", "", "", "", "", "", "", ""]]]   ;weapon set 4 / Weapon per set / mod per weapon
;Hysteresis flags to prevent flip-flop between sets
Global $g_b_InDefensiveMode = False
Global $g_b_InLowEnergyMode = False

#Region Mods
Global $g_as2_OtherWeaponsMods [24][3] = [ _
		 [ "Highly salvageable",							"1E000826",   ""], _
		 [ "Improved sale value",							"3200F805",   ""], _
		 [ "Damage +15% (-1 energy regen)",					"0F003822",   "0100C820"], _
		 [ "Damage +15% (-1 HP regen)",						"0F003822",   "0100E820"], _
		 [ "+30 HP",										"001E4823",   ""], _
		 [ "Air Magic +1 (20% chance)",						"14081824",   ""], _
		 [ "Blood Magic +1 (20% chance)",					"14041824",   ""], _
		 [ "Channeling Magic +1 (20% chance)",				"14221824",   ""], _
		 [ "Communing Magic +1 (20% chance)",				"14201824",   ""], _
		 [ "Curse Magic +1 (20% chance)",					"14071824",   ""], _
		 [ "Death Magic +1 (20% chance)",					"14051824",   ""], _
		 [ "Divine Favor  +1 (20% chance)",					"14101824",   ""], _
		 [ "Domination Magic +1 (20% chance)",				"14021824",   ""], _
		 [ "Earth Magic +1 (20% chance)",					"14091824",   ""], _
		 [ "Fire Magic +1 (20% chance)",					"140A1824",   ""], _
		 [ "Healing Prayers +1 (20% chance)",				"140D1824",   ""], _
		 [ "Illusion Magic +1 (20% chance)",				"14011824",   ""], _
		 [ "Inspiration  +1 (20% chance)",					"14031824",   ""], _
		 [ "Protection Prayers +1 (20% chance)",			"140F1824",   ""], _
		 [ "Restoration Magic +1 (20% chance)",				"14211824",   ""], _
		 [ "Smiting Prayers +1 (20% chance)",				"140E1824",   ""], _
		 [ "Soul Reaping +1 (20% chance)",					"14061824",   ""], _
		 [ "Spawning Magic +1 (20% chance)",				"14241824",   ""], _
		 [ "Water Magic +1 (20% chance)",					"140B1824",   ""]]
;[Name, effect, mods]
Global $g_as2_MartialWeaponsInscription[11][3] = [ _
	["I have the power!",				"Energy +5",							"0500D822"], _
	["Let the Memory Live Again", 		"HSR10", 								"????????"], _
	["Strength and Honor", 				"Damage +15% (HP> 50%)", 				"0F327822"], _
	["Guided by Fate", 					"Damage +15% (while Enchanted)",		"0F006822"], _
	["Dance with Death",				"Damage +15% (while in a Stance)",		"0F00A822"], _
	["Too Much Information",			"Damage +15% (vs Hexed Foes)",			"0F005822"], _
	["To the Pain!",					"Damage +15% (-10 AL while attacking)",	"0A001820"], _
	["Brawn over Brains",				"Damage +15% (Energy -5)",				"0500B820"], _
	["Vengeance is Mine",				"Damage 20% (HP<50%)",					"14328822"], _
	["Don't Fear the Reaper",			"Damage 20% (while Hexed)",				"14009822"], _
	["Don't Think Twice",				"HCT10",								"000A0822"]]
Global $g_as2_SpellCastingWeaponsInscription[15][3] = [ _
	["Hale and Hearty", 				"Energy +5 (HP>50%)", 					"05320823"], _
	["Have Faith",						"Energy +5 (while Enchanted)",			"0500F822"], _
	["Don't call it a comeback!",		"Energy +7 (HP<50%)",					"07321823"], _
	["I am Sorrow.",					"Energy +7 (while hexed)",				"07002823"], _
	["Seize the Day",					"Energy +15 (-1 energy regen)",			"0100C820"], _
	["Aptitude not Attitude",			"HCT20",								"22500140828"], _
	["Strength and Honor", 				"Damage +15% (HP> 50%)", 				"0F327822"], _
	["Guided by Fate", 					"Damage +15% (while Enchanted)",		"0F006822"], _
	["Dance with Death",				"Damage +15% (while in a Stance)",		"0F00A822"], _
	["Too Much Information",			"Damage +15% (vs Hexed Foes)",			"0F005822"], _
	["To the Pain!",					"Damage +15% (-10 AL while attacking)",	"0A001820"], _
	["Brawn over Brains",				"Damage +15% (Energy -5)",				"0500B820"], _
	["Vengeance is Mine",				"Damage 20% (HP<50%)",					"14328822"], _
	["Don't Fear the Reaper",			"Damage 20% (while Hexed)",				"14009822"], _
	["Don't Think Twice",				"HCT10",								"000A0822"]]
Global $g_as2_FocusShieldWeaponsInscription[34][3] = [ _
	["Master of My Domain", 		 	"+1 Attr. (Chance 20%)",				"00143828"], _
	["Not the face!",					"Armor +10 (vs Blunt)",					"0A0018A1"], _
	["Leaf on the Wind",				"Armor +10 (vs Cold)",					"0A0318A1"], _
	["Like a Rolling Stone",			"Armor +10 (vs Earth)",					"0A0B18A1"], _
	["Sleep Now in the Fire",			"Armor +10 (vs Fire)",					"0A0518A1"], _
	["Riders on the Storm",				"Armor +10 (vs Lightning)",				"0A0418A1"], _
	["Through Thick and Thin",			"Armor +10 (vs Piercing)",				"0A0118A1"], _
	["The Riddle of Steel",				"Armor +10 (vs Slashing)",				"0A0218A1"], _
	["Sheltered by Faith",				"Damage -2 (while Enchanted)",			"02008820"], _
	["Run For Your Life!",				"Damage -2 (while in a Stance)",		"0200A820"], _
	["Nothing to Fear",					"Damage -3 (while Hexed)",				"03009820"], _
	["Luck of the Draw",				"Damage -5 (Chance: 20%)",				"05147820"], _
	["Fear Cuts Deeper",				"-20% Bleeding", 						"00005828"], _
	["I Can See Clearly Now",			"-20% Blind",							"00015828"], _
	["Swift as the Wind",				"-20% Crippled",						"00035828"], _
	["Soundness of Mind",				"-20% Dazed",							"00075828"], _
	["Strength of Body",				"-20% Deep Wound",						"00045828"], _
	["Cast Out the Unclean",			"-20% Disease",							"00055828"], _
	["Pure of Heart",					"-20% Poison", 							"00065828"], _
	["Only the Strong Survive",			"-20% Weakness",						"00085828"], _
	["Hail to the King",				"Armor +5 (HP> 50%)",					"0532A821"], _
	["Faith is My Shield",				"Armor +5 (while Enchanted)",			"05009821"], _
	["Might Makes Right",				"Armor +5 (while attacking)",			"05007821"], _
	["Knowing is Half the Battle.",		"Armor +5 (while casting)",				"05008821"], _
	["Man for All Seasons",				"Armor +5 (vs Elemental)",				"05002821"], _
	["Survival of the Fittest",			"Armor +5 (vs Physical)",				"05005821"], _
	["Ignorance is Bliss",				"Armor +5 (Energy -5)",					"0500B820"], _
	["Life is Pain",					"Armor +5 (Health -20)",				"1400D820"], _
	["Down But Not Out",				"Armor +10 (HP< 50%)",					"0A32B821"], _
	["Be Just and Fear Not",			"Armor +10 (while Hexed)",				"0A00C821"], _
	["Live for Today",					"Energy +15 (Regen -1)", 				"0F00D822"], _ ;0100C820
	["Serenity Now", 					"HSR10",								"000AA823"], _
	["Forget Me Not", 					"HSR20",								"00142828"], _
	["Aptitude not Attitude",			"HCT20",								"22500140828"]]
Global $g_as2_AxeUpgrade[30][3] = [ _
	["Barbed",							"Bleeding +33%", 						"DE016824"], _
	["Cruel",							"Deep Wound +33%",						"E2016824"], _
	["Crippling",						"Crippled +33%",						"E1016824"], _
	["Heavy",							"Weakness +33%", 						"E601824"], _
	["Poisonous",						"Poison +33%", 							"E4016824"], _
	["Ebon",							"Earth damage",							"000BB824"], _
	["Fiery",							"Fire damage", 							"0005B824"], _
	["Icy",								"Cold damage",							"0003B824"], _
	["Shocking",						"Lightning damage", 					"0004B824"], _
	["Furious",							"Double adrenaline 10%", 				"0A00B823"], _
	["Sundering",						"Armor penetration +20%", 				"1414F823"], _
	["Vampiric (+3)",					"Life draining", 						"00032825"], _
	["Zealous",							"Energy gain on hit",					"01001825"], _
	["Axe Grip of Defense",				"Armor +5",								"05000821"], _
	["Axe Grip of Shelter", 			"+7 armor vs Physical",					"07005821"], _
	["Axe Grip of Warding",				"+7 Armor vs Elemental",				"07002821"], _
	["Axe Grip of Enchanting",			"+20% Enchantment Duration",			"1400B822"], _
	["Axe Grip of Fortitude",			"Health +30",							"001E4823"], _
	["Axe Grip of Axe Mastery",			"Axe Mastery +1 (20% chance)",			"14121824"], _
	["Axe Grip of Charr slaying",		"+ 20% (vs Charr)",						"00018080"], _
	["Axe Grip of Demons slaying",		"+ 20% (vs Demons)",					"00088080"], _
	["Axe Grip of Dragons slaying",		"+ 20% (vs Dragons",					"00098080"], _
	["Axe Grip of Dwarves slaying",		"+ 20% (vs Dwarves)",					"00068080"], _
	["Axe Grip of Giants slaying",		"+ 20% (vs Giants)",					"00058080"], _
	["Axe Grip of Ogres slaying",		"+ 20% (vs Ogres)",						"000A8080"], _
	["Axe Grip of Plants slaying",		"+ 20% (vs Plants)",					"00038080"], _
	["Axe Grip of Skeletons slaying",	"+ 20% (vs Skeletons)",					"00048080"], _
	["Axe Grip of Tengu slaying",		"+ 20% (vs Tengu)",						"00078080"], _
	["Axe Grip of Trolls slaying",		"+ 20% (vs Trolls)",					"00028080"], _
	["Axe Grip of Undead slaying",		"+ 20% (vs Undead)",					"001448A2"]]
Global $g_as2_HammerUpgrade[27][3] = [ _
	["Cruel",							"Deep Wound +33%",						"E2016824"], _
	["Heavy",							"Weakness +33%", 						"E601824"], _
	["Ebon",							"Earth damage",							"000BB824"], _
	["Fiery",							"Fire damage", 							"0005B824"], _
	["Icy",								"Cold damage",							"0003B824"], _
	["Shocking",						"Lightning damage", 					"0004B824"], _
	["Furious",							"Double adrenaline 10%", 				"0A00B823"], _
	["Sundering",						"Armor penetration +20%", 				"1414F823"], _
	["Vampiric (+3)",					"Life draining", 						"00032825"], _
	["Zealous",							"Energy gain on hit",					"01001825"], _
	["Hammer Haft of Defense",			"Armor +5",								"05000821"], _
	["Hammer Haft of Shelter", 			"+7 armor vs Physical",					"07005821"], _
	["Hammer Haft of Warding",			"+7 Armor vs Elemental",				"07002821"], _
	["Hammer Haft of Enchanting",		"+20% Enchantment Duration",			"1400B822"], _
	["Hammer Haft of Fortitude",		"Health +30",							"001E4823"], _
	["Hammer Haft of Hammer Mastery",	"Hammer Mastery +1 (20% chance)",		"14131824"], _
	["Hammer Haft of Charr slaying",	"+ 20% (vs Charr)",						"00018080"], _
	["Hammer Haft of Demons slaying",	"+ 20% (vs Demons)",					"00088080"], _
	["Hammer Haft of Dragons slaying",	"+ 20% (vs Dragons",					"00098080"], _
	["Hammer Haft of Dwarves slaying",	"+ 20% (vs Dwarves)",					"00068080"], _
	["Hammer Haft of Giants slaying",	"+ 20% (vs Giants)",					"00058080"], _
	["Hammer Haft of Ogres slaying",	"+ 20% (vs Ogres)",						"000A8080"], _
	["Hammer Haft of Plants slaying",	"+ 20% (vs Plants)",					"00038080"], _
	["Hammer Haft of Skeletons slaying","+ 20% (vs Skeletons)",					"00048080"], _
	["Hammer Haft of Tengu slaying",	"+ 20% (vs Tengu)",						"00078080"], _
	["Hammer Haft of Trolls slaying",	"+ 20% (vs Trolls)",					"00028080"], _
	["Hammer Haft of Undead slaying",	"+ 20% (vs Undead)",					"001448A2"]]
Global $g_as2_SwordUpgrade[29][3] = [ _
	["Barbed",							"Bleeding +33%", 						"DE016824"], _
	["Cruel",							"Deep Wound +33%",						"E2016824"], _
	["Crippling",						"Crippled +33%",						"E1016824"], _
	["Poisonous",						"Poison +33%", 							"E4016824"], _
	["Ebon",							"Earth damage",							"000BB824"], _
	["Fiery",							"Fire damage", 							"0005B824"], _
	["Icy",								"Cold damage",							"0003B824"], _
	["Shocking",						"Lightning damage", 					"0004B824"], _
	["Furious",							"Double adrenaline 10%", 				"0A00B823"], _
	["Sundering",						"Armor penetration +20%", 				"1414F823"], _
	["Vampiric (+3)",					"Life draining", 						"00032825"], _
	["Zealous",							"Energy gain on hit",					"01001825"], _
	["Sword Pommel of Defense",			"Armor +5",								"05000821"], _
	["Sword Pommel of Shelter", 		"+7 armor vs Physical",					"07005821"], _
	["Sword Pommel of Warding",			"+7 Armor vs Elemental",				"07002821"], _
	["Sword Pommel of Enchanting",		"+20% Enchantment Duration",			"1400B822"], _
	["Sword Pommel of Fortitude",		"Health +30",							"001E4823"], _
	["Sword Pommel of Swordmanship",	"Swordmanship +1 (20% chance)",			"14141824"], _
	["Sword Pommel of Charr slaying",	"+ 20% (vs Charr)",						"00018080"], _
	["Sword Pommel of Demons slaying",	"+ 20% (vs Demons)",					"00088080"], _
	["Sword Pommel of Dragons slaying",	"+ 20% (vs Dragons",					"00098080"], _
	["Sword Pommel of Dwarves slaying",	"+ 20% (vs Dwarves)",					"00068080"], _
	["Sword Pommel of Giants slaying",	"+ 20% (vs Giants)",					"00058080"], _
	["Sword Pommel of Ogres slaying",	"+ 20% (vs Ogres)",						"000A8080"], _
	["Sword Pommel of Plants slaying",	"+ 20% (vs Plants)",					"00038080"], _
	["Sword Pommel of Skeletons slaying","+ 20% (vs Skeletons)",				"00048080"], _
	["Sword Pommel of Tengu slaying",	"+ 20% (vs Tengu)",						"00078080"], _
	["Sword Pommel of Trolls slaying",	"+ 20% (vs Trolls)",					"00028080"], _
	["Sword Pommel of Undead slaying",	"+ 20% (vs Undead)",					"001448A2"]]
Global $g_as2_DaggerUpgrade[20][3] = [ _
	["Barbed",							"Bleeding +33%", 						"DE016824"], _
	["Cruel",							"Deep Wound +33%",						"E2016824"], _
	["Crippling",						"Crippled +33%",						"E1016824"], _
	["Heavy",							"Weakness +33%", 						"E601824"], _
	["Poisonous",						"Poison +33%", 							"E4016824"], _
	["Silencing",						"Dazed +33%", 							"E5016824"], _
	["Ebon",							"Earth damage",							"000BB824"], _
	["Fiery",							"Fire damage", 							"0005B824"], _
	["Icy",								"Cold damage",							"0003B824"], _
	["Shocking",						"Lightning damage", 					"0004B824"], _
	["Furious",							"Double adrenaline 10%", 				"0A00B823"], _
	["Sundering",						"Armor penetration +20%", 				"1414F823"], _
	["Vampiric (+3)",					"Life draining", 						"00032825"], _
	["Zealous",							"Energy gain on hit",					"01001825"], _
	["Dagger Handle of Defense",		"Armor +5",								"05000821"], _
	["Dagger Handle of Shelter", 		"+7 armor vs Physical",					"07005821"], _
	["Dagger Handle of Warding",		"+7 Armor vs Elemental",				"07002821"], _
	["Dagger Handle of Enchanting",		"+20% Enchantment Duration",			"1400B822"], _
	["Dagger Handle of Fortitude",		"Health +30",							"001E4823"], _
	["Dagger Handle of Dagger Mastery",	"Dagger Mastery +1 (20% chance)",		"141D1824"]]
Global $g_as2_ScytheUpgrade[19][3] = [ _
	["Barbed",							"Bleeding +33%", 						"DE016824"], _
	["Cruel",							"Deep Wound +33%",						"E2016824"], _
	["Crippling",						"Crippled +33%",						"E1016824"], _
	["Heavy",							"Weakness +33%", 						"E601824"], _
	["Poisonous",						"Poison +33%", 							"E4016824"], _
	["Ebon",							"Earth damage",							"000BB824"], _
	["Fiery",							"Fire damage", 							"0005B824"], _
	["Icy",								"Cold damage",							"0003B824"], _
	["Shocking",						"Lightning damage", 					"0004B824"], _
	["Furious",							"Double adrenaline 10%", 				"0A00B823"], _
	["Sundering",						"Armor penetration +20%", 				"1414F823"], _
	["Vampiric (+5)",					"Life draining", 						"00052825"], _
	["Zealous",							"Energy gain on hit",					"01001825"], _
	["Scythe Grip of Defense",			"Armor +5",								"05000821"], _
	["Scythe Grip of Shelter", 			"+7 armor vs Physical",					"07005821"], _
	["Scythe Grip of Warding",			"+7 Armor vs Elemental",				"07002821"], _
	["Scythe Grip of Enchanting",		"+20% Enchantment Duration",			"1400B822"], _
	["Scythe Grip of Fortitude",		"Health +30",							"001E4823"], _
	["Scythe Grip of Scythe Mastery",	"Scythe Mastery +1 (20% chance)",		"14291824"]]
Global $g_as2_BowUpgrade[29][3] = [ _
	["Barbed",							"Bleeding +33%", 						"DE016824"], _
	["Crippling",						"Crippled +33%",						"E1016824"], _
	["Poisonous",						"Poison +33%", 							"E4016824"], _
	["Silencing",						"Dazed +33%", 							"E5016824"], _
	["Ebon",							"Earth damage",							"000BB824"], _
	["Fiery",							"Fire damage", 							"0005B824"], _
	["Icy",								"Cold damage",							"0003B824"], _
	["Shocking",						"Lightning damage", 					"0004B824"], _
	["Furious",							"Double adrenaline 10%", 				"0A00B823"], _
	["Sundering",						"Armor penetration +20%", 				"1414F823"], _
	["Vampiric (+5)",					"Life draining", 						"00052825"], _
	["Zealous",							"Energy gain on hit",					"01001825"], _
	["Bow Grip of Defense",				"Armor +5",								"05000821"], _
	["Bow Grip of Shelter", 			"+7 armor vs Physical",					"07005821"], _
	["Bow Grip of Warding",				"+7 Armor vs Elemental",				"07002821"], _
	["Bow Grip of Enchanting",			"+20% Enchantment Duration",			"1400B822"], _
	["Bow Grip of Fortitude",			"Health +30",							"001E4823"], _
	["Bow Grip of Marksmanship",		"Marksmanship +1 (20% chance)",			"14191824"], _
	["Bow Grip of Charr slaying",		"+ 20% (vs Charr)",						"00018080"], _
	["Bow Grip of Demons slaying",		"+ 20% (vs Demons)",					"00088080"], _
	["Bow Grip of Dragons slaying",		"+ 20% (vs Dragons",					"00098080"], _
	["Bow Grip of Dwarves slaying",		"+ 20% (vs Dwarves)",					"00068080"], _
	["Bow Grip of Giants slaying",		"+ 20% (vs Giants)",					"00058080"], _
	["Bow Grip of Ogres slaying",		"+ 20% (vs Ogres)",						"000A8080"], _
	["Bow Grip of Plants slaying",		"+ 20% (vs Plants)",					"00038080"], _
	["Bow Grip of Skeletons slaying",	"+ 20% (vs Skeletons)",					"00048080"], _
	["Bow Grip of Tengu slaying",		"+ 20% (vs Tengu)",						"00078080"], _
	["Bow Grip of Trolls slaying",		"+ 20% (vs Trolls)",					"00028080"], _
	["Bow Grip of Undead slaying",		"+ 20% (vs Undead)",					"001448A2"]]
Global $g_as2_SpearUpgrade[20][3] = [ _
	["Barbed",							"Bleeding +33%", 						"DE016824"], _
	["Cruel",							"Deep Wound +33%",						"E2016824"], _
	["Crippling",						"Crippled +33%",						"E1016824"], _
	["Heavy",							"Weakness +33%", 						"E601824"], _
	["Poisonous",						"Poison +33%", 							"E4016824"], _
	["Silencing",						"Dazed +33%", 							"E5016824"], _
	["Ebon",							"Earth damage",							"000BB824"], _
	["Fiery",							"Fire damage", 							"0005B824"], _
	["Icy",								"Cold damage",							"0003B824"], _
	["Shocking",						"Lightning damage", 					"0004B824"], _
	["Furious",							"Double adrenaline 10%", 				"0A00B823"], _
	["Sundering",						"Armor penetration +20%", 				"1414F823"], _
	["Vampiric (+3)",					"Life draining", 						"00032825"], _
	["Zealous",							"Energy gain on hit",					"01001825"], _
	["Spear Grip of Defense",			"Armor +5",								"05000821"], _
	["Spear Grip of Shelter", 			"+7 armor vs Physical",					"07005821"], _
	["Spear Grip of Warding",			"+7 Armor vs Elemental",				"07002821"], _
	["Spear Grip of Enchanting",		"+20% Enchantment Duration",			"1400B822"], _
	["Spear Grip of Fortitude",			"Health +30",							"001E4823"], _
	["Spear Grip of Spear Mastery",		"Spear Mastery +1 (20% chance)",		"14251824"]]
Global $g_as2_StaffWandUpgrade[28][3] = [ _
	["Staff Head Adept",				"HCT20", 								"02500140828"], _
	["Staff Head Defensive", 			"Armor +5", 							"05000821"], _
	["Staff Head Hale", 				"+30 HP",								"A013025001E4823"], _
	["Staff Head Insightful",			"Energy +5" ,							"0500D822"], _
	["Staff Head Swift",				"HCT10",								"000A0822"], _
	["Staff Wrapping of Defense",		"Armor +5",								"05000821"], _
	["Staff Wrapping of Shelter", 		"+7 armor vs Physical",					"07005821"], _
	["Staff Wrapping of Warding",		"+7 Armor vs Elemental",				"07002821"], _
	["Staff Wrapping of Enchanting",	"+20% Enchantment Duration",			"1400B822"], _
	["Staff Wrapping of Fortitude",		"Health +30",							"001E4823"], _
	["Staff Wrapping of Fortitude", 	"+30 HP (staff wrapping)",				"9013025001E4823"], _
	["Staff Wrapping of Devotion", 		"+45 HP while Enchanted",				"002D6823"], _
	["Staff Wrapping of Endurance",		"+45 HP while in a Stance",				"002D8823"], _
	["Staff Wrapping of Valor",			"+60 HP while Hexed",					"003C7823"], _
	["Staff Wrapping of Attr",			"+1 Attr. (Chance 20%)",				"00143828"], _
	["Staff Wrapping of Charr slaying",	"+ 20% (vs Charr)",						"00018080"], _
	["Staff Wrapping of Demons slaying","+ 20% (vs Demons)",					"00088080"], _
	["Staff Wrapping of Dragons slaying","+ 20% (vs Dragons",					"00098080"], _
	["Staff Wrapping of Dwarves slaying","+ 20% (vs Dwarves)",					"00068080"], _
	["Staff Wrapping of Giants slaying","+ 20% (vs Giants)",					"00058080"], _
	["Staff Wrapping of Ogres slaying",	"+ 20% (vs Ogres)",						"000A8080"], _
	["Staff Wrapping of Plants slaying","+ 20% (vs Plants)",					"00038080"], _
	["Staff Wrapping of Skeletons slaying","+ 20% (vs Skeletons)",				"00048080"], _
	["Staff Wrapping of Tengu slaying",	"+ 20% (vs Tengu)",						"00078080"], _
	["Staff Wrapping of Trolls slaying","+ 20% (vs Trolls)",					"00028080"], _
	["Staff Wrapping of Undead slaying","+ 20% (vs Undead)",					"001448A2"], _
	["Wand Wrapping of Quickening",		"HSR20",								"00142828"], _
	["Wand Wrapping of Memory",			"HSR10",								"000AA823"]]
Global $g_as2_ShieldUpgrade[5][3] = [ _
	["Shield Handle of Fortitude",		"Health +30",							"001E4823"], _
	["Shield Handle of Fortitude", 		"+30 HP (Shield Handle)",				"9013025001E4823"], _
	["Shield Handle of Devotion", 		"+45 HP while Enchanted",				"002D6823"], _
	["Shield Handle of Endurance",		"+45 HP while in a Stance",				"002D8823"], _
	["Shield Handle of Valor",			"+60 HP while Hexed",					"003C7823"]]
Global $g_as2_FocusUpgrade[7][3] = [ _
	["Focus Core of Swiftness",		"HCT20",			 						"02500140828"], _
	["Focus Core of Adptitude",		"HCT10", 									"????????"], _
	["Focus Core of Fortitude",		"Health +30",								"001E4823"], _
	["Focus Core of Fortitude", 	"+30 HP (Focus Core)",						"9013025001E4823"], _
	["Focus Core of Devotion", 		"+45 HP while Enchanted",					"002D6823"], _
	["Focus Core of Endurance",		"+45 HP while in a Stance",					"002D8823"], _
	["Focus Core of Valor",			"+60 HP while Hexed",						"003C7823"]]
#EndRegion Mods
