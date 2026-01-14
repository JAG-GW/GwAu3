#include-once

#Region Inventory
; Inventory Array
Global Enum _
    $GC_I_INVENTORY_PTR, _
    $GC_I_INVENTORY_ITEMID, _
    $GC_I_INVENTORY_BAG, _
    $GC_I_INVENTORY_ITEMTYPE, _
    $GC_I_INVENTORY_EXTRAID, _
    $GC_I_INVENTORY_VALUE, _
    $GC_I_INVENTORY_ISIDENTIFIED, _
    $GC_I_INVENTORY_ISSTACKABLE, _
    $GC_I_INVENTORY_ISINSCRIBABLE, _
    $GC_I_INVENTORY_MODELID, _
    $GC_I_INVENTORY_RARITY, _
    $GC_I_INVENTORY_ISMATERIALSALVAGEABLE, _
    $GC_I_INVENTORY_QUANTITY, _
    $GC_I_INVENTORY_SLOT

; Storage
Global Enum _
	$GC_I_INVENTORY_UNUSED_BAG, $GC_I_INVENTORY_BACKPACK, _
	$GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, _
	$GC_I_INVENTORY_BAG2, $GC_I_INVENTORY_EQUIPMENT_PACK, _
	$GC_I_INVENTORY_MATERIAL_STORAGE, $GC_I_INVENTORY_UNCLAIMED_ITEMS, _
    $GC_I_INVENTORY_STORAGE1, $GC_I_INVENTORY_STORAGE2, _
	$GC_I_INVENTORY_STORAGE3, $GC_I_INVENTORY_STORAGE4, _
	$GC_I_INVENTORY_STORAGE5, $GC_I_INVENTORY_STORAGE6, _
	$GC_I_INVENTORY_STORAGE7, $GC_I_INVENTORY_STORAGE8, _
	$GC_I_INVENTORY_STORAGE9, $GC_I_INVENTORY_STORAGE10, _
	$GC_I_INVENTORY_STORAGE11, $GC_I_INVENTORY_STORAGE12, _
	$GC_I_INVENTORY_STORAGE13, $GC_I_INVENTORY_STORAGE14, _
	$GC_I_INVENTORY_EQUIPPED_ITEMS
#EndRegion Inventory

#Region Rarity
Global Const $GC_I_RARITY_WHITE = 2621
Global Const $GC_I_RARITY_BLUE = 2623
Global Const $GC_I_RARITY_PURPLE = 2626
Global Const $GC_I_RARITY_GOLD = 2624
Global Const $GC_I_RARITY_GREEN = 2627
#EndRegion Rarity

#Region ItemType
Global Const $GC_I_TYPE_SALVAGE = 0
Global Const $GC_I_TYPE_LEADHAND = 1
Global Const $GC_I_TYPE_AXE = 2
Global Const $GC_I_TYPE_BAG = 3
Global Const $GC_I_TYPE_BOOTS = 4
Global Const $GC_I_TYPE_BOW = 5
Global Const $GC_I_TYPE_BUNDLE = 6
Global Const $GC_I_TYPE_CHESTPIECE = 7
Global Const $GC_I_TYPE_RUNE_AND_MOD = 8
Global Const $GC_I_TYPE_USABLE = 9
Global Const $GC_I_TYPE_DYE = 10
Global Const $GC_I_TYPE_MATERIAL_AND_ZCOINS = 11
Global Const $GC_I_TYPE_OFFHAND = 12
Global Const $GC_I_TYPE_GLOVES = 13
Global Const $GC_I_TYPE_CELESTIAL_SIGIL = 14
Global Const $GC_I_TYPE_HAMMER = 15
Global Const $GC_I_TYPE_HEADPIECE = 16
Global Const $GC_I_TYPE_TROPHY_2 = 17
Global Const $GC_I_TYPE_KEY = 18
Global Const $GC_I_TYPE_LEGGINS = 19
Global Const $GC_I_TYPE_GOLD_COINS = 20
Global Const $GC_I_TYPE_QUEST_ITEM = 21
Global Const $GC_I_TYPE_WAND = 22
Global Const $GC_I_TYPE_SHIELD = 24
Global Const $GC_I_TYPE_STAFF = 26
Global Const $GC_I_TYPE_SWORD = 27
Global Const $GC_I_TYPE_KIT = 29
Global Const $GC_I_TYPE_TROPHY = 30
Global Const $GC_I_TYPE_SCROLL = 31
Global Const $GC_I_TYPE_DAGGERS = 32
Global Const $GC_I_TYPE_PRESENT = 33
Global Const $GC_I_TYPE_MINIPET = 34
Global Const $GC_I_TYPE_SCYTHE = 35
Global Const $GC_I_TYPE_SPEAR = 36
Global Const $GC_I_TYPE_BOOKS = 43
Global Const $GC_I_TYPE_COSTUME_BODY = 44
Global Const $GC_I_TYPE_COSTUME_HEADPIC = 45
Global Const $GC_I_TYPE_NOT_EQUIPPED = 46
#EndRegion ItemType

#Region Gold
Global Const $GC_I_MODELID_GOLD_COIN = 2511
#EndRegion Gold

#Region Kits
Global Const $GC_I_MODELID_CHARR_SALVAGE_KIT = 18721
Global Const $GC_I_MODELID_SALVAGE_KIT = 2992
Global Const $GC_I_MODELID_EXPERT_SALVAGE_KIT = 2991
Global Const $GC_I_MODELID_SUPERIOR_SALVAGE_KIT = 5900
Global Const $GC_I_MODELID_IDENTIFICATION_KIT = 2989
Global Const $GC_I_MODELID_SUPERIOR_IDENTIFICATION_KIT = 5899
#EndRegion Kits

#Region Dyes
Global Const $GC_I_MODELID_DYE = 146
Global Const $GC_I_EXTRAID_DYE_BLUE = 2
Global Const $GC_I_EXTRAID_DYE_GREEN = 3
Global Const $GC_I_EXTRAID_DYE_PURPLE = 4
Global Const $GC_I_EXTRAID_DYE_RED = 5
Global Const $GC_I_EXTRAID_DYE_YELLOW = 6
Global Const $GC_I_EXTRAID_DYE_BROWN = 7
Global Const $GC_I_EXTRAID_DYE_ORANGE = 8
Global Const $GC_I_EXTRAID_DYE_SILVER = 9
Global Const $GC_I_EXTRAID_DYE_BLACK = 10
Global Const $GC_I_EXTRAID_DYE_GRAY = 11
Global Const $GC_I_EXTRAID_DYE_WHITE = 12
Global Const $GC_I_EXTRAID_DYE_PINK = 13

Global Const $GC_AI_EXTRAID_DYES[13] = [12, _
    $GC_I_EXTRAID_DYE_BLUE, _
    $GC_I_EXTRAID_DYE_GREEN, _
    $GC_I_EXTRAID_DYE_PURPLE, _
    $GC_I_EXTRAID_DYE_RED, _
    $GC_I_EXTRAID_DYE_YELLOW, _
    $GC_I_EXTRAID_DYE_BROWN, _
    $GC_I_EXTRAID_DYE_ORANGE, _
    $GC_I_EXTRAID_DYE_SILVER, _
    $GC_I_EXTRAID_DYE_BLACK, _
    $GC_I_EXTRAID_DYE_GRAY, _
    $GC_I_EXTRAID_DYE_WHITE, _
    $GC_I_EXTRAID_DYE_PINK _
]
#EndRegion Dyes

#Region Materials
; Material
Global Const $GC_I_MODELID_BONES = 921
Global Const $GC_I_MODELID_CLOTHS = 925
Global Const $GC_I_MODELID_DUST = 929
Global Const $GC_I_MODELID_FEATHERS = 933
Global Const $GC_I_MODELID_PLANT_FIBRES = 934
Global Const $GC_I_MODELID_TANNED_HIDE = 940
Global Const $GC_I_MODELID_WOOD = 946
Global Const $GC_I_MODELID_IRON = 948
Global Const $GC_I_MODELID_SCALES = 953
Global Const $GC_I_MODELID_CHITIN = 954
Global Const $GC_I_MODELID_GRANITE = 955

; Rare Material
Global Const $GC_I_MODELID_CHARCOAL = 922
Global Const $GC_I_MODELID_MONSTROUS_CLAW = 923
Global Const $GC_I_MODELID_LINEN = 926
Global Const $GC_I_MODELID_DAMASK = 927
Global Const $GC_I_MODELID_SILK = 928
Global Const $GC_I_MODELID_GLOB_OF_ECTOPLASM = 930
Global Const $GC_I_MODELID_MONSTROUS_EYE = 931
Global Const $GC_I_MODELID_MONSTROUS_FANG = 932
Global Const $GC_I_MODELID_DIAMOND = 935
Global Const $GC_I_MODELID_ONYX = 936
Global Const $GC_I_MODELID_RUBY = 937
Global Const $GC_I_MODELID_SAPPHIRE = 938
Global Const $GC_I_MODELID_GLASS_VIAL = 939
Global Const $GC_I_MODELID_FUR_SQUARE = 941
Global Const $GC_I_MODELID_LEATHER_SQUARE = 942
Global Const $GC_I_MODELID_ELONIAN_LEATHER_SQUARE = 943
Global Const $GC_I_MODELID_VIAL_OF_INK = 944
Global Const $GC_I_MODELID_OBSIDIAN_SHARD = 945
Global Const $GC_I_MODELID_STEEL_INGOT = 949
Global Const $GC_I_MODELID_DELDRIMOR_STEEL_INGOT = 950
Global Const $GC_I_MODELID_ROLL_OF_PARCHMENT = 951
Global Const $GC_I_MODELID_ROLL_OF_VELLUM = 952
Global Const $GC_I_MODELID_SPIRITWOOD_PLANK = 956
Global Const $GC_I_MODELID_AMBER_CHUNK = 6532
Global Const $GC_I_MODELID_JADEIT_SHARD = 6533

Global Const $GC_AI_COMMON_MATERIALS[12] = [ 11, _
	$GC_I_MODELID_BONES, _
	$GC_I_MODELID_CLOTHS, _
	$GC_I_MODELID_DUST, _
	$GC_I_MODELID_FEATHERS, _
	$GC_I_MODELID_PLANT_FIBRES, _
    $GC_I_MODELID_TANNED_HIDE, _
	$GC_I_MODELID_WOOD, _
	$GC_I_MODELID_IRON, _
	$GC_I_MODELID_SCALES, _
	$GC_I_MODELID_CHITIN, _
	$GC_I_MODELID_GRANITE _
]

Global Const $GC_AI_RARE_MATERIALS[26] = [ 25, _
	$GC_I_MODELID_CHARCOAL, _
	$GC_I_MODELID_MONSTROUS_CLAW, _
	$GC_I_MODELID_LINEN, _
	$GC_I_MODELID_DAMASK, _
	$GC_I_MODELID_SILK, _
	$GC_I_MODELID_GLOB_OF_ECTOPLASM, _
	$GC_I_MODELID_MONSTROUS_EYE, _
	$GC_I_MODELID_MONSTROUS_FANG, _
	$GC_I_MODELID_DIAMOND, _
	$GC_I_MODELID_ONYX, _
	$GC_I_MODELID_RUBY, _
	$GC_I_MODELID_SAPPHIRE, _
	$GC_I_MODELID_GLASS_VIAL, _
	$GC_I_MODELID_FUR_SQUARE, _
	$GC_I_MODELID_LEATHER_SQUARE, _
	$GC_I_MODELID_ELONIAN_LEATHER_SQUARE, _
	$GC_I_MODELID_VIAL_OF_INK, _
	$GC_I_MODELID_OBSIDIAN_SHARD, _
	$GC_I_MODELID_STEEL_INGOT, _
	$GC_I_MODELID_DELDRIMOR_STEEL_INGOT, _
	$GC_I_MODELID_ROLL_OF_PARCHMENT, _
	$GC_I_MODELID_ROLL_OF_VELLUM, _
	$GC_I_MODELID_SPIRITWOOD_PLANK, _
	$GC_I_MODELID_AMBER_CHUNK, _
	$GC_I_MODELID_JADEIT_SHARD _
]

Global Const $GC_AI_ALL_MATERIALS[37] = [ 36, _
	$GC_I_MODELID_BONES, _
	$GC_I_MODELID_CHARCOAL, _
	$GC_I_MODELID_MONSTROUS_CLAW, _
	$GC_I_MODELID_CLOTHS, _
	$GC_I_MODELID_LINEN, _
	$GC_I_MODELID_DAMASK, _
	$GC_I_MODELID_SILK, _
	$GC_I_MODELID_DUST, _
	$GC_I_MODELID_GLOB_OF_ECTOPLASM, _
	$GC_I_MODELID_MONSTROUS_EYE, _
	$GC_I_MODELID_MONSTROUS_FANG, _
	$GC_I_MODELID_FEATHERS, _
	$GC_I_MODELID_PLANT_FIBRES, _
	$GC_I_MODELID_DIAMOND, _
	$GC_I_MODELID_ONYX, _
	$GC_I_MODELID_RUBY, _
	$GC_I_MODELID_SAPPHIRE, _
	$GC_I_MODELID_GLASS_VIAL, _
	$GC_I_MODELID_FUR_SQUARE, _
	$GC_I_MODELID_LEATHER_SQUARE, _
	$GC_I_MODELID_ELONIAN_LEATHER_SQUARE, _
	$GC_I_MODELID_VIAL_OF_INK, _
	$GC_I_MODELID_TANNED_HIDE, _
	$GC_I_MODELID_OBSIDIAN_SHARD, _
	$GC_I_MODELID_WOOD, _
	$GC_I_MODELID_IRON, _
	$GC_I_MODELID_STEEL_INGOT, _
	$GC_I_MODELID_DELDRIMOR_STEEL_INGOT, _
	$GC_I_MODELID_ROLL_OF_PARCHMENT, _
	$GC_I_MODELID_ROLL_OF_VELLUM, _
	$GC_I_MODELID_SCALES, _
	$GC_I_MODELID_CHITIN, _
	$GC_I_MODELID_GRANITE, _
	$GC_I_MODELID_SPIRITWOOD_PLANK, _
	$GC_I_MODELID_AMBER_CHUNK, _
	$GC_I_MODELID_JADEIT_SHARD _
]
#EndRegion Materials

#Region Scrolls
Global Const $GC_I_MODELID_PASSAGE_SCROLL_TO_URGOZ_WARREN = 3256
Global Const $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_UNDERWORLD = 3746
Global Const $GC_I_MODELID_SCROLL_OF_HEROS_INSIGHT = 5594
Global Const $GC_I_MODELID_SCROLL_OF_BERSERKERS_INSIGHT = 5595
Global Const $GC_I_MODELID_SCROLL_OF_SLAYERS_INSIGHT = 5611
Global Const $GC_I_MODELID_SCROLL_OF_ADVENTURES_INSIGHT = 5853
Global Const $GC_I_MODELID_SCROLL_OF_RAMPAGERS_INSIGHT = 5975
Global Const $GC_I_MODELID_SCROLL_OF_HUNTERS_INSIGHT = 5976
Global Const $GC_I_MODELID_SCROLL_OF_THE_LIGHTBRINGER = 21233
Global Const $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_DEEP = 22279
Global Const $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_FISSURE_OF_WOE = 22280

Global Const $GC_AI_ALL_SCROLLS[11] = [10, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_URGOZ_WARREN, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_UNDERWORLD, _
    $GC_I_MODELID_SCROLL_OF_HEROS_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_BERSERKERS_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_SLAYERS_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_ADVENTURES_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_HUNTERS_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_THE_LIGHTBRINGER, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_DEEP, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_FISSURE_OF_WOE _
]

Global Const $GC_AI_BLUE_SCROLLS[4] = [ 3, _
	$GC_I_MODELID_SCROLL_OF_ADVENTURES_INSIGHT, _
	$GC_I_MODELID_SCROLL_OF_RAMPAGERS_INSIGHT, _
	$GC_I_MODELID_SCROLL_OF_HUNTERS_INSIGHT _
]

Global Const $GC_AI_GOLD_SCROLLS[9] = [8, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_URGOZ_WARREN, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_UNDERWORLD, _
    $GC_I_MODELID_SCROLL_OF_HEROS_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_BERSERKERS_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_SLAYERS_INSIGHT, _
    $GC_I_MODELID_SCROLL_OF_THE_LIGHTBRINGER, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_DEEP, _
    $GC_I_MODELID_PASSAGE_SCROLL_TO_THE_FISSURE_OF_WOE _
]
#EndRegion Scrolls

#Region WeaponMods
; Shield
; Damage Reduction
Global Const $GC_S_MOD_SHIELD_MINUS3_HEX 						= "03009820"	; -3wHex (shield only?)
Global Const $GC_S_MOD_SHIELD_MINUS2_STANCE 					= "0200A820"	; -2wStance
Global Const $GC_S_MOD_SHIELD_MINUS2_ENCH 						= "02008820"	; -2wEnch
Global Const $GC_S_MOD_SHIELD_MINUS520 							= "05147820"	; -5(20%)
; Hp
Global Const $GC_S_MOD_SHIELD_PLUS30 							= "001E4823"	; +30HP (shield only?)
Global Const $GC_S_MOD_SHIELD_PLUS45_STANCE 					= "002D8823"	; +45HPwStance
Global Const $GC_S_MOD_SHIELD_PLUS45_ENCH 						= "002D6823"	; +45HPwEnch
Global Const $GC_S_MOD_SHIELD_PLUS44_ENCH 						= "002C6823"	; +44HPwEnch
Global Const $GC_S_MOD_SHIELD_PLUS43_ENCH 						= "002B6823"	; +43HPwEnch
Global Const $GC_S_MOD_SHIELD_PLUS42_ENCH 						= "002A6823"	; +42HPwEnch
Global Const $GC_S_MOD_SHIELD_PLUS41_ENCH 						= "00296823"	; +41HPwEnch
Global Const $GC_S_MOD_SHIELD_PLUS60_HEX 						= "003C7823"	; +60HPwHex
; +1 20% Mods
Global Const $GC_S_MOD_SHIELD_PLUS_ILLUSION 					= "14011824"	; +1 Illu 20%
Global Const $GC_S_MOD_SHIELD_PLUS_DOMINATION 					= "14021824"	; +1 Dom 20%
Global Const $GC_S_MOD_SHIELD_PLUS_INSPIRATION 					= "14031824"	; +1 Insp 20%
Global Const $GC_S_MOD_SHIELD_PLUS_BLOOD 						= "14041824"	; +1 Blood 20%
Global Const $GC_S_MOD_SHIELD_PLUS_DEATH 						= "14051824"	; +1 Death 20%
Global Const $GC_S_MOD_SHIELD_PLUS_SOUL_REAP 					= "14061824"	; +1 SoulR 20%
Global Const $GC_S_MOD_SHIELD_PLUS_CURSES 						= "14071824"	; +1 Curses 20%
Global Const $GC_S_MOD_SHIELD_PLUS_AIR 							= "14081824"	; +1 Air 20%
Global Const $GC_S_MOD_SHIELD_PLUS_EARTH 						= "14091824"	; +1 Earth 20%
Global Const $GC_S_MOD_SHIELD_PLUS_FIRE 						= "140A1824"	; +1 Fire 20%
Global Const $GC_S_MOD_SHIELD_PLUS_WATER 						= "140B1824"	; +1 Water 20%
Global Const $GC_S_MOD_SHIELD_PLUS_HEALING 						= "140D1824"	; +1 Heal 20%
Global Const $GC_S_MOD_SHIELD_PLUS_SMITE 						= "140E1824"	; +1 Smite 20%
Global Const $GC_S_MOD_SHIELD_PLUS_PROT 						= "140F1824"	; +1 Prot 20%
Global Const $GC_S_MOD_SHIELD_PLUS_DIVINE 						= "14101824"	; +1 Divine 20%
Global Const $GC_S_MOD_SHIELD_PLUS_STRENGTH 					= "14111824"	; +1 Strength 20%
Global Const $GC_S_MOD_SHIELD_PLUS_TACTICS 						= "14151824"	; +1 Tactics 20%
; +10vs Monsters Mods
Global Const $GC_S_MOD_SHIELD_PLUS_VS_UNDEAD 					= "0A004821"	; +10vs Undead
Global Const $GC_S_MOD_SHIELD_PLUS_VS_CHARR 					= "0A014821"	; +10vs Charr
Global Const $GC_S_MOD_SHIELD_PLUS_VS_TROLLS 					= "0A024821"	; +10vs Trolls
Global Const $GC_S_MOD_SHIELD_PLUS_VS_PLANTS 					= "0A034821"	; +10vs Plants
Global Const $GC_S_MOD_SHIELD_PLUS_VS_SKELETONS 				= "0A044821"	; +10vs Skeletons
Global Const $GC_S_MOD_SHIELD_PLUS_VS_GIANTS 					= "0A054821"	; +10vs Giants
Global Const $GC_S_MOD_SHIELD_PLUS_VS_DWARVES 					= "0A064821"	; +10vs Dwarves
Global Const $GC_S_MOD_SHIELD_PLUS_VS_TENGU 					= "0A074821"	; +10vs Tengu
Global Const $GC_S_MOD_SHIELD_PLUS_VS_DEMONS 					= "0A084821"	; +10vs Demons
Global Const $GC_S_MOD_SHIELD_PLUS_VS_DRAGONS 					= "0A094821"	; +10vs Dragons
Global Const $GC_S_MOD_SHIELD_PLUS_VS_OGRES 					= "0A0A4821"	; +10vs Ogres
; +10vs Dmg -Physical
Global Const $GC_S_MOD_SHIELD_PLUS_VS_BLUNT 					= "0A001821"	; +10vs Blunt
Global Const $GC_S_MOD_SHIELD_PLUS_VS_PIERCING 					= "0A011821"	; +10vs Piercing
Global Const $GC_S_MOD_SHIELD_PLUS_VS_SLASHING 					= "0A021821"	; +10vs Slashing
; +10vs Dmg - Elemental
Global Const $GC_S_MOD_SHIELD_PLUS_VS_COLD 						= "0A031821"	; +10vs Cold
Global Const $GC_S_MOD_SHIELD_PLUS_VS_LIGHTNING 				= "0A041821"	; +10vs Lightning
Global Const $GC_S_MOD_SHIELD_PLUS_VS_FIRE 						= "0A051821"	; +10vs Fire
Global Const $GC_S_MOD_SHIELD_PLUS_VS_EARTH 					= "0A0B1821"	; +10vs Earth
; +20 vs Conditions
Global Const $GC_S_MOD_SHIELD_VS_BLEEDING                       = "DE017824"	; +20%vs Bleeding
Global Const $GC_S_MOD_SHIELD_VS_BLIND                          = "DF017824"	; +20%vs Blind
Global Const $GC_S_MOD_SHIELD_VS_CRIPPLE                        = "E1017824"	; +20%vs Cripple
Global Const $GC_S_MOD_SHIELD_VS_DEEP_WOUND                     = "E2017824"	; +20%vs Deep Wound
Global Const $GC_S_MOD_SHIELD_VS_DISEASE                        = "E3017824"	; +20%vs Disease
Global Const $GC_S_MOD_SHIELD_VS_POISON                         = "E4017824"	; +20%vs Poison
Global Const $GC_S_MOD_SHIELD_VS_DAZE                           = "E5017824"	; +20%vs Daze
Global Const $GC_S_MOD_SHIELD_VS_WEAKNESS                       = "E6017824"	; +20%vs Weakness
; Staff
;Generic 10% HCT
Global Const $GC_S_MOD_STAFF_ALL10_CAST 						= "000A0822"	; 10% HCT
; Mes mods
Global Const $GC_S_MOD_STAFF_FAST_CASTING20_CASTING 			= "00141822"	; 20% FastCasting (Unconfirmed)
Global Const $GC_S_MOD_STAFF_ILLUSION20_CASTING 				= "01141822"	; 20% Illusion
Global Const $GC_S_MOD_STAFF_DOMINATION20_CASTING 				= "02141822"	; 20% domination
Global Const $GC_S_MOD_STAFF_INSPIRATION20_CASTING 				= "03141822"	; 20% Inspiration
; Necro mods
Global Const $GC_S_MOD_STAFF_BLOOD20_CASTING 					= "04141822"	; 20% Blood
Global Const $GC_S_MOD_STAFF_DEATH20_CASTING 					= "05141822"	; 20% death
Global Const $GC_S_MOD_STAFF_SOUL_REAP20_CASTING 				= "06141822"	; 20% Soul Reap (Doesnt drop)
Global Const $GC_S_MOD_STAFF_CURSES20_CASTING 					= "07141822"	; 20% Curses
; Ele mods
Global Const $GC_S_MOD_STAFF_AIR20_CASTING 						= "08141822"	; 20% air
Global Const $GC_S_MOD_STAFF_EARTH20_CASTING 					= "09141822"	; 20% Earth
Global Const $GC_S_MOD_STAFF_FIRE20_CASTING 					= "0A141822"	; 20% fire
Global Const $GC_S_MOD_STAFF_WATER20_CASTING 					= "0B141822"	; 20% water
Global Const $GC_S_MOD_STAFF_ENERGY20_CASTING 					= "0C141822"	; 20% Energy Storage (Doesnt drop)
; Monk mods
Global Const $GC_S_MOD_STAFF_HEALING20_CASTING 					= "0D141822"	; 20% healing
Global Const $GC_S_MOD_STAFF_SMITE20_CASTING 					= "0E141822"	; 20% smite
Global Const $GC_S_MOD_STAFF_PROTECTION20_CASTING 				= "0F141822"	; 20% protection
Global Const $GC_S_MOD_STAFF_DIVINE20_CASTING 					= "10141822"	; 20% divine
; Rit mods
Global Const $GC_S_MOD_STAFF_COMMUNING20_CASTING 				= "20141822"	; 20% Communing
Global Const $GC_S_MOD_STAFF_RESTORATION20_CASTING 				= "21141822"	; 20% Restoration
Global Const $GC_S_MOD_STAFF_CHANNELING20_CASTING 				= "22141822"	; 20% channeling
Global Const $GC_S_MOD_STAFF_SPAWNING20_CASTING 				= "24141822"	; 20% Spawning

; Wand/Offhand
; Universal mods
Global Const $GC_S_MOD_CASTER_PLUS_FIVE 						= "05320823"	; +5^50
Global Const $GC_S_MOD_CASTER_PLUS_FIVE_ENCH 					= "0500F822"	; +5wEnch
Global Const $GC_S_MOD_CASTER_ALL10_CAST 						= "000A0822"	; 10% cast
Global Const $GC_S_MOD_CASTER_ALL10_RECHARGE 					= "000AA823"	; 10% recharge
Global Const $GC_S_MOD_CASTER_ENERGY_ALWAYS15 					= "0F00D822"	; Energy +15
Global Const $GC_S_MOD_CASTER_ENERGY_REGEN 						= "0100C820"	; Energy regeneration -1
Global Const $GC_S_MOD_CASTER_PLUS30 							= "001E4823"	; +30HP
; Mes mods
Global Const $GC_S_MOD_CASTER_FAST_CASTING19_CASTING 			= "00131822"	; 19% fast casting
Global Const $GC_S_MOD_CASTER_FAST_CASTING19_RECHARGE 			= "00139823"	; 19% fast casting recharge
Global Const $GC_S_MOD_CASTER_ILLUSION19_CASTING 				= "01131822"	; 19% illusion
Global Const $GC_S_MOD_CASTER_ILLUSION19_RECHARGE 				= "01139823"	; 19% illusion recharge
Global Const $GC_S_MOD_CASTER_DOMINATION19_CASTING 				= "02131822"	; 19% domination
Global Const $GC_S_MOD_CASTER_DOMINATION19_RECHARGE 			= "02139823"	; 19% domination recharge
Global Const $GC_S_MOD_CASTER_INSPIRATION19_CASTING 			= "03131822"	; 19% inspiration
Global Const $GC_S_MOD_CASTER_INSPIRATION19_RECHARGE 			= "03139823"	; 19% inspiration recharge

Global Const $GC_S_MOD_CASTER_FAST_CASTING20_CASTING 			= "00141822"	; 20% fast casting
Global Const $GC_S_MOD_CASTER_FAST_CASTING20_RECHARGE 			= "00149823"	; 20% fast casting recharge
Global Const $GC_S_MOD_CASTER_ILLUSION20_CASTING 				= "01141822"	; 20% illusion
Global Const $GC_S_MOD_CASTER_ILLUSION20_RECHARGE 				= "01149823"	; 20% illusion recharge
Global Const $GC_S_MOD_CASTER_DOMINATION20_CASTING 				= "02141822"	; 20% domination
Global Const $GC_S_MOD_CASTER_DOMINATION20_RECHARGE 			= "02149823"	; 20% domination recharge
Global Const $GC_S_MOD_CASTER_INSPIRATION20_CASTING 			= "03141822"	; 20% inspiration
Global Const $GC_S_MOD_CASTER_INSPIRATION20_RECHARGE 			= "03149823"	; 20% inspiration recharge
; Necro mods
Global Const $GC_S_MOD_CASTER_BLOOD20_CASTING 					= "04141822"	; 20% blood
Global Const $GC_S_MOD_CASTER_BLOOD20_RECHARGE 					= "04149823"	; 20% blood recharge
Global Const $GC_S_MOD_CASTER_DEATH20_CASTING 					= "05141822"	; 20% death
Global Const $GC_S_MOD_CASTER_DEATH20_RECHARGE 					= "05149823"	; 20% death recharge
Global Const $GC_S_MOD_CASTER_SOUL_REAP20_CASTING 				= "06141822"	; 20% soul reaping
Global Const $GC_S_MOD_CASTER_SOUL_REAP20_RECHARGE 				= "06149823"	; 20% soul reaping recharge
Global Const $GC_S_MOD_CASTER_CURSES20_CASTING 					= "07141822"	; 20% curses
Global Const $GC_S_MOD_CASTER_CURSES20_RECHARGE 				= "07149823"	; 20% curses recharge
; Ele mods
Global Const $GC_S_MOD_CASTER_AIR20_CASTING 					= "08141822"	; 20% air
Global Const $GC_S_MOD_CASTER_AIR20_RECHARGE 					= "08149823"	; 20% air recharge
Global Const $GC_S_MOD_CASTER_EARTH20_CASTING 					= "09141822"	; 20% earth
Global Const $GC_S_MOD_CASTER_EARTH20_RECHARGE 					= "09149823"	; 20% earth recharge
Global Const $GC_S_MOD_CASTER_FIRE20_CASTING 					= "0A141822"	; 20% fire
Global Const $GC_S_MOD_CASTER_FIRE20_RECHARGE 					= "0A149823"	; 20% fire recharge
Global Const $GC_S_MOD_CASTER_WATER20_CASTING 					= "0B141822"	; 20% water
Global Const $GC_S_MOD_CASTER_WATER20_RECHARGE 					= "0B149823"	; 20% water recharge
Global Const $GC_S_MOD_CASTER_ENERGY20_CASTING 					= "0C141822"	; 20% energy storage
Global Const $GC_S_MOD_CASTER_ENERGY20_RECHARGE 				= "0C149823"	; 20% energy storage recharge
; Monk mods
Global Const $GC_S_MOD_CASTER_HEALING20_CASTING 				= "0D141822"	; 20% healing
Global Const $GC_S_MOD_CASTER_HEALING20_RECHARGE 				= "0D149823"	; 20% healing recharge
Global Const $GC_S_MOD_CASTER_SMITING20_CASTING 				= "0E141822"	; 20% smite
Global Const $GC_S_MOD_CASTER_SMITING20_RECHARGE 				= "0E149823"	; 20% smite recharge
Global Const $GC_S_MOD_CASTER_PROTECTION20_CASTING 				= "0F141822"	; 20% protection
Global Const $GC_S_MOD_CASTER_PROTECTION20_RECHARGE 			= "0F149823"	; 20% protection recharge
Global Const $GC_S_MOD_CASTER_DIVINE20_CASTING 					= "10141822"	; 20% divine
Global Const $GC_S_MOD_CASTER_DIVINE20_RECHARGE 				= "10149823"	; 20% divine recharge
; Rit mods
Global Const $GC_S_MOD_CASTER_COMMUNING20_CASTING 				= "20141822"	; 20% communing
Global Const $GC_S_MOD_CASTER_COMMUNING20_RECHARGE 				= "20149823"	; 20% communing recharge
Global Const $GC_S_MOD_CASTER_RESTORATION20_CASTING 			= "21141822"	; 20% restoration
Global Const $GC_S_MOD_CASTER_RESTORATION20_RECHARGE 			= "21149823"	; 20% restoration recharge
Global Const $GC_S_MOD_CASTER_CHANNELING20_CASTING 				= "22141822"	; 20% channeling
Global Const $GC_S_MOD_CASTER_CHANNELING20_RECHARGE 			= "22149823"	; 20% channeling recharge
Global Const $GC_S_MOD_CASTER_SPAWNING20_CASTING 				= "24141822"	; 20% spawning power
Global Const $GC_S_MOD_CASTER_SPAWNING20_RECHARGE 				= "24149823"	; 20% spawning power recharge
; +1 20% Mods
Global Const $GC_S_MOD_CASTER_FAST_CASTING 						= "14001824"	; +1 fast casting 20%
Global Const $GC_S_MOD_CASTER_PLUS_ILLUSION 					= "14011824"	; +1 illu 20%
Global Const $GC_S_MOD_CASTER_PLUS_DOMINATION 					= "14021824"	; +1 dom 20%
Global Const $GC_S_MOD_CASTER_PLUS_INSPIRATION 					= "14031824"	; +1 insp 20%
Global Const $GC_S_MOD_CASTER_PLUS_BLOOD 						= "14041824"	; +1 blood 20%
Global Const $GC_S_MOD_CASTER_PLUS_DEATH 						= "14051824"	; +1 death 20%
Global Const $GC_S_MOD_CASTER_PLUS_SOUL_REAP 					= "14061824"	; +1 soul reaping 20%
Global Const $GC_S_MOD_CASTER_PLUS_CURSES 						= "14071824"	; +1 curses 20%
Global Const $GC_S_MOD_CASTER_PLUS_AIR 							= "14081824"	; +1 air 20%
Global Const $GC_S_MOD_CASTER_PLUS_EARTH 						= "14091824"	; +1 earth 20%
Global Const $GC_S_MOD_CASTER_PLUS_FIRE 						= "140A1824"	; +1 fire 20%
Global Const $GC_S_MOD_CASTER_PLUS_WATER 						= "140B1824"	; +1 water 20%
Global Const $GC_S_MOD_CASTER_PLUS_ENERGY 						= "140C1824"	; +1 energy storage 20%
Global Const $GC_S_MOD_CASTER_PLUS_HEALING 						= "140D1824"	; +1 heal 20%
Global Const $GC_S_MOD_CASTER_PLUS_SMITING 						= "140E1824"	; +1 smite 20%
Global Const $GC_S_MOD_CASTER_PLUS_PROTECTION 					= "140F1824"	; +1 prot 20%
Global Const $GC_S_MOD_CASTER_PLUS_DIVINE 						= "14101824"	; +1 divine 20%
Global Const $GC_S_MOD_CASTER_PLUS_COMMUNING 					= "14201824"	; +1 communing 20%
Global Const $GC_S_MOD_CASTER_PLUS_RESTORATION 					= "14211824"	; +1 restoration 20%
Global Const $GC_S_MOD_CASTER_PLUS_CHANNELING 					= "14221824"	; +1 channeling 20%
Global Const $GC_S_MOD_CASTER_PLUS_SPAWNING 					= "14241824"	; +1 spawning power 20%

; Martial
Global Const $GC_S_MOD_MARTIAL_PLUS15_FLAT 						= "0F003822"	; unconditional +15%
Global Const $GC_S_MOD_MARTIAL_PLUS1550 						= "0F327822"	; +15%^50
Global Const $GC_S_MOD_MARTIAL_PLUS15_ENCH 						= "0F006822"	; +15%wEnch
Global Const $GC_S_MOD_MARTIAL_PLUS15_STANCE 					= "0F00A822"	; +15%wStance
Global Const $GC_S_MOD_MARTIAL_PLUS5_ENERGY 					= "0500D822"	; +5e
Global Const $GC_S_MOD_MARTIAL_MINUS5_ENERGY 					= "0500B820"	; -5e
Global Const $GC_S_MOD_MARTIAL_MINUS10_ARMOR 					= "0A001820"	; -10 armor while attacking
Global Const $GC_S_MOD_MARTIAL_VAMP 							= "0100E820"	; -1HP regen
Global Const $GC_S_MOD_MARTIAL_ZEAL 							= "0100C820"	; -1energy regen
#EndRegion WeaponMods

#Region ArmorMods (Runes)
; Mesmer
Global Const $GC_S_INSIGNIA_MESMER_ARTIFICER 					= "E2010824"	; Artificer Insignia
Global Const $GC_S_INSIGNIA_MESMER_PRODIGY 						= "E3010824"	; Prodigy Insignia
Global Const $GC_S_INSIGNIA_MESMER_VIRTUOSO 					= "E4010824"	; Virtuoso	Insignia

Global Const $GC_S_RUNE_MESMER_MINOR_FAST_CASTING 				= "0100E821"	; Minor FastCasting Rune
Global Const $GC_S_RUNE_MESMER_MINOR_ILLUSION_MAGIC 			= "0101E821"	; Minor IllusionMagic Rune
Global Const $GC_S_RUNE_MESMER_MINOR_DOMINATION_MAGIC 			= "0102E821"	; Minor DominationMagic Rune
Global Const $GC_S_RUNE_MESMER_MINOR_INSPIRATION_MAGIC 			= "0103E821"	; Minor InspirationMagic Rune
Global Const $GC_S_RUNE_MESMER_MAJOR_FAST_CASTING 				= "0200E821"	; Major FastCasting Rune
Global Const $GC_S_RUNE_MESMER_MAJOR_ILLUSION_MAGIC 			= "0201E821"	; Major IllusionMagic Rune
Global Const $GC_S_RUNE_MESMER_MAJOR_DOMINATION_MAGIC 			= "0202E821"	; Major DominationMagic Rune
Global Const $GC_S_RUNE_MESMER_MAJOR_INSPIRATION_MAGIC 			= "0203E821"	; Major InspirationMagic Rune
Global Const $GC_S_RUNE_MESMER_SUPERIOR_FAST_CASTING 			= "0300E821"	; Superior FastCasting Rune
Global Const $GC_S_RUNE_MESMER_SUPERIOR_ILLUSION_MAGIC 			= "0301E821"	; Superior IllusionMagic Rune
Global Const $GC_S_RUNE_MESMER_SUPERIOR_DOMINATION_MAGIC 		= "0302E821"	; Superior DominationMagic Rune
Global Const $GC_S_RUNE_MESMER_SUPERIOR_INSPIRATION_MAGIC 		= "0303E821"	; Superior InspirationMagic Rune

; Necromancer
Global Const $GC_S_INSIGNIA_NECROMANCER_TORMENTOR 				= "EC010824"	; Tormentor Insignia
Global Const $GC_S_INSIGNIA_NECROMANCER_UNDERTAKER 				= "ED010824"	; Undertaker Insignia
Global Const $GC_S_INSIGNIA_NECROMANCER_BONELACE 				= "EE010824"	; Bonelace Insignia
Global Const $GC_S_INSIGNIA_NECROMANCER_MINION_MASTER 			= "EF010824"	; MinionMaster Insignia
Global Const $GC_S_INSIGNIA_NECROMANCER_BLIGHTER 				= "F0010824"	; Blighter Insignia
Global Const $GC_S_INSIGNIA_NECROMANCER_BLOODSTAINED 			= "0A020824"	; Bloodstained Insignia

Global Const $GC_S_RUNE_NECROMANCER_MINOR_BLOOD_MAGIC 			= "0104E821"	; Minor BloodMagic Rune
Global Const $GC_S_RUNE_NECROMANCER_MINOR_DEATH_MAGIC 			= "0105E821"	; Minor DeathMagic Rune
Global Const $GC_S_RUNE_NECROMANCER_MINOR_SOUL_REAPING 			= "0106E821"	; Minor SoulReaping Rune
Global Const $GC_S_RUNE_NECROMANCER_MINOR_CURSES		 		= "0107E821"	; Minor Curses Rune
Global Const $GC_S_RUNE_NECROMANCER_MAJOR_BLOOD_MAGIC 			= "0204E821"	; Major BloodMagic Rune
Global Const $GC_S_RUNE_NECROMANCER_MAJOR_DEATH_MAGIC 			= "0205E821"	; Major DeathMagic Rune
Global Const $GC_S_RUNE_NECROMANCER_MAJOR_SOUL_REAPING 			= "0206E821"	; Major SoulReaping Rune
Global Const $GC_S_RUNE_NECROMANCER_MAJOR_CURSES		 		= "0207E821"	; Major Curses Rune
Global Const $GC_S_RUNE_NECROMANCER_SUPERIOR_BLOOD_MAGIC 		= "0304E821"	; Superior BloodMagic Rune
Global Const $GC_S_RUNE_NECROMANCER_SUPERIOR_DEATH_MAGIC  		= "0305E821"	; Superior DeathMagic Rune
Global Const $GC_S_RUNE_NECROMANCER_SUPERIOR_SOUL_REAPING	 	= "0306E821"	; Superior SoulReaping Rune
Global Const $GC_S_RUNE_NECROMANCER_SUPERIOR_CURSES			 	= "0307E821"	; Superior Curses Rune

; Elementalist
Global Const $GC_S_INSIGNIA_ELEMENTALIST_PRISMATIC 				= "F1010824"	; Prismatic Insignia
Global Const $GC_S_INSIGNIA_ELEMENTALIST_HYDROMANCER 			= "F2010824"	; Hydromancer Insignia
Global Const $GC_S_INSIGNIA_ELEMENTALIST_GEOMANCER 				= "F3010824"	; Geomancer Insignia
Global Const $GC_S_INSIGNIA_ELEMENTALIST_PYROMANCER 			= "F4010824"	; Pyromancer Insignia
Global Const $GC_S_INSIGNIA_ELEMENTALIST_AEROMANCER 			= "F5010824"	; Aeromancer Insignia

Global Const $GC_S_RUNE_WARRIOR_MINOR_AIR_MAGIC					= "0108E821"	; Minor AirMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_EARTH_MAGIC				= "0109E821"	; Minor EarthMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_FIRE_MAGIC				= "010AE821"	; Minor FireMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_WATER_MAGIC 				= "010BE821"	; Minor WaterMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_ENERGY_STORAGE 			= "010CE821"	; Minor EnergyStorage Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_AIR_MAGIC					= "0208E821"	; Major AirMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_EARTH_MAGIC				= "0209E821"	; Major EarthMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_FIRE_MAGIC 				= "020AE821"	; Major FireMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_WATER_MAGIC				= "020BE821"	; Major WaterMagic Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_ENERGY_STORAGE 			= "020CE821"	; Major EnergyStorage Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_AIR_MAGIC 				= "0308E821"	; Superior AirMagic Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_EARTH_MAGIC			= "0309E821"	; Superior EarthMagic Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_FIRE_MAGIC 			= "030AE821"	; Superior FireMagic Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_WATER_MAGIC 			= "030BE821"	; Superior WaterMagic Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_ENERGY_STORAGE 		= "030CE821"	; Superior EnergyStorage Rune

; Monk
Global Const $GC_S_INSIGNIA_MONK_WANDERER 						= "F6010824"	; Wanderer Insignia
Global Const $GC_S_INSIGNIA_MONK_DISCIPLE 						= "F7010824"	; Disciple Insignia
Global Const $GC_S_INSIGNIA_MONK_ANCHORITE 						= "F8010824"	; Anchorite Insignia

Global Const $GC_S_RUNE_MONK_MINOR_HEALING_PRAYERS 				= "010DE821"	; Minor HealingPrayers Rune
Global Const $GC_S_RUNE_MONK_MINOR_SMITING_PRAYERS 				= "010EE821"	; Minor SmitingPrayers Rune
Global Const $GC_S_RUNE_MONK_MINOR_PROTECTION_PRAYERS 			= "010FE821"	; Minor ProtectionPrayers Rune
Global Const $GC_S_RUNE_MONK_MINOR_DIVINE_FAVOR		 			= "0110E821"	; Minor DivineFavor Rune
Global Const $GC_S_RUNE_MONK_MAJOR_HEALING_PRAYERS				= "020DE821"	; Major HealingPrayers Rune
Global Const $GC_S_RUNE_MONK_MAJOR_MINOR_SMITING_PRAYERS		= "020EE821"	; Major SmitingPrayers Rune
Global Const $GC_S_RUNE_MONK_MAJOR_PROTECTION_PRAYERSC 			= "020FE821"	; Major ProtectionPrayers Rune
Global Const $GC_S_RUNE_MONK_MAJOR_DIVINE_FAVOR 				= "0210E821"	; Major DivineFavor Rune
Global Const $GC_S_RUNE_MONK_SUPERIOR_HEALING_PRAYERS 			= "030DE821"	; Superior HealingPrayers Rune
Global Const $GC_S_RUNE_MONK_SUPERIOR_MINOR_SMITING_PRAYERS 	= "030EE821"	; Superior SmitingPrayers Rune
Global Const $GC_S_RUNE_MONK_SUPERIOR_PROTECTION_PRAYERS 		= "030FE821"	; Superior ProtectionPrayers Rune
Global Const $GC_S_RUNE_MONK_SUPERIOR_DIVINE_FAVOR 				= "0310E821"	; Superior DivineFavor Rune

; Warrior
Global Const $GC_S_INSIGNIA_WARRIOR_KNIGHT 						= "F9010824"	; Knight Insignia
Global Const $GC_S_INSIGNIA_WARRIOR_DREADNOUGHT 				= "FA010824"	; Dreadnought Insignia
Global Const $GC_S_INSIGNIA_WARRIOR_SENTINEL 					= "FB010824"	; Sentinel Insignia
Global Const $GC_S_INSIGNIA_WARRIOR_LIEUTENANT 					= "08020824"	; Lieutenant Insignia
Global Const $GC_S_INSIGNIA_WARRIOR_STONEFIST 					= "09020824"	; Stonefist Insignia

Global Const $GC_S_RUNE_WARRIOR_MINOR_ABSORPTION 				= "FC000824"	; Minor Absorption Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_ABSORPTION 				= "FD000824"	; Major Absorption Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_ABSORPTION 			= "FE000824"	; Superior Absorption Rune

Global Const $GC_S_RUNE_WARRIOR_MINOR_STRENGHT 					= "0111E821"	; Minor Strenght Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_AXE_MASTERY 				= "0112E821"	; Minor AxeMastery Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_HAMMER_MASTERY 			= "0113E821"	; Minor HammerMastery Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_SWORDSMANSHIP 			= "0114E821"	; Minor Swordsmanship Rune
Global Const $GC_S_RUNE_WARRIOR_MINOR_TACTICS 					= "0115E821"	; Minor Tactics Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_STRENGHT 					= "0211E821"	; Major Strenght Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_AXE_MASTERY 				= "0212E821"	; Major AxeMastery Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_HAMMER_MASTERY 			= "0213E821"	; Major HammerMastery Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_SWORDSMANSHIP 			= "0214E821"	; Major Swordsmanship Rune
Global Const $GC_S_RUNE_WARRIOR_MAJOR_TACTICS 					= "0215E821"	; Major Tactics Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_STRENGHT 				= "0311E821"	; Superior Strenght Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_AXE_MASTERY 			= "0312E821"	; Superior AxeMastery Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_HAMMER_MASTERY 		= "0313E821"	; Superior HammerMastery Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_SWORDSMANSHIP 			= "0314E821"	; Superior Swordsmanship Rune
Global Const $GC_S_RUNE_WARRIOR_SUPERIOR_TACTICS 				= "0315E821"	; Superior Tactics Rune

; Ranger
Global Const $GC_S_INSIGNIA_RANGER_FROSTBOUND 					= "FC010824"	; Frostbound Insignia
Global Const $GC_S_INSIGNIA_RANGER_EARTHBOUND 					= "FD010824"	; Earthbound Insignia
Global Const $GC_S_INSIGNIA_RANGER_PYREBOUND 					= "FE010824"	; Pyrebound Insignia
Global Const $GC_S_INSIGNIA_RANGER_STORMBOUND 					= "FF010824"	; Stormbound Insignia
Global Const $GC_S_INSIGNIA_RANGER_BEASTMASTER 					= "00020824"	; Beastmaster Insignia
Global Const $GC_S_INSIGNIA_RANGER_SCOUT 						= "01020824"	; Scout Insignia

Global Const $GC_S_RUNE_RANGER_MINOR_BEAST_MASTERY 				= "0116E821"	; Minor BeastMastery Rune
Global Const $GC_S_RUNE_RANGER_MINOR_EXPERTISE 					= "0117E821"	; Minor Expertise Rune
Global Const $GC_S_RUNE_RANGER_MINOR_WILDERNESS_SURVIVAL 		= "0118E821"	; Minor WildernessSurvival Rune
Global Const $GC_S_RUNE_RANGER_MINOR_MARKSMANSHIP 				= "0119E821"	; Minor Marksmanship Rune
Global Const $GC_S_RUNE_RANGER_MAJOR_BEAST_MASTERY 				= "0216E821"	; Major BeastMastery Rune
Global Const $GC_S_RUNE_RANGER_MAJOR_EXPERTISE 					= "0217E821"	; Major Expertise Rune
Global Const $GC_S_RUNE_RANGER_MAJOR_WILDERNESS_SURVIVAL 		= "0218E821"	; Major WildernessSurvival Rune
Global Const $GC_S_RUNE_RANGER_MAJOR_MARKSMANSHIP 				= "0219E821"	; Major Marksmanship Rune
Global Const $GC_S_RUNE_RANGER_SUPERIOR_BEAST_MASTERY 			= "0316E821"	; Superior BeastMastery Rune
Global Const $GC_S_RUNE_RANGER_SUPERIOR_EXPERTISE 				= "0317E821"	; Superior Expertise Rune
Global Const $GC_S_RUNE_RANGER_SUPERIOR_WILDERNESS_SURVIVAL 	= "0318E821"	; Superior WildernessSurvival Rune
Global Const $GC_S_RUNE_RANGER_SUPERIOR_MARKSMANSHIP 			= "0319E821"	; Superior Marksmanship Rune

; Assassin
Global Const $GC_S_INSIGNIA_ASSASSIN_VANGUARD 					= "DE010824"	; Vanguard Insignia
Global Const $GC_S_INSIGNIA_ASSASSIN_INFILTRATOR 				= "DF010824"	; Infiltrator Insignia
Global Const $GC_S_INSIGNIA_ASSASSIN_SABOTEUR 					= "E0010824"	; Saboteur Insignia
Global Const $GC_S_INSIGNIA_ASSASSIN_NIGHTSTALKER 				= "E1010824"	; Nightstalker Insignia

Global Const $GC_S_RUNE_ASSASSIN_MINOR_DAGGER_MASTERY 			= "011DE821"	; Minor DaggerMastery Rune
Global Const $GC_S_RUNE_ASSASSIN_MINOR_DEADLY_ARTS				= "011EE821"	; Minor DeadlyArts Rune
Global Const $GC_S_RUNE_ASSASSIN_MINOR_SHADOW_ARTS 				= "011FE821"	; Minor ShadowArts Rune
Global Const $GC_S_RUNE_ASSASSIN_MINOR_CRITICAL_STRIKES 		= "0123E821"	; Minor CriticalStrikes Rune
Global Const $GC_S_RUNE_ASSASSIN_MAJOR_DAGGER_MASTERY 			= "021DE821"	; Major DaggerMastery Rune
Global Const $GC_S_RUNE_ASSASSIN_MAJOR_DEADLY_ART 				= "021EE821"	; Major DeadlyArts Rune
Global Const $GC_S_RUNE_ASSASSIN_MAJOR_SHADOW_ARTS 				= "021FE821"	; Major ShadowArts Rune
Global Const $GC_S_RUNE_ASSASSIN_MAJOR_CRITICAL_STRIKES 		= "0223E821"	; Major CriticalStrikes Rune
Global Const $GC_S_RUNE_ASSASSIN_SUPERIOR_DAGGER_MASTERY 		= "031DE821"	; Superior DaggerMastery Rune
Global Const $GC_S_RUNE_ASSASSIN_SUPERIOR_DEADLY_ART			= "031EE821"	; Superior DeadlyArts Rune
Global Const $GC_S_RUNE_ASSASSIN_SUPERIOR_SHADOW_ARTS 			= "031FE821"	; Superior ShadowArts Rune
Global Const $GC_S_RUNE_ASSASSIN_SUPERIOR_CRITICAL_STRIKES 		= "0323E821"	; Superior CriticalStrikes Rune

; Ritualist
Global Const $GC_S_INSIGNIA_RITUALIST_SHAMAN 					= "04020824"	; Shaman Insignia
Global Const $GC_S_INSIGNIA_RITUALIST_GHOST_FORGE 				= "05020824"	; GhostForge Insignia
Global Const $GC_S_INSIGNIA_RITUALIST_MYSTIC 					= "06020824"	; Mystic Insignia

Global Const $GC_S_RUNE_RITUALIST_MINOR_COMMUNING 				= "0120E821"	; Minor Communing Rune
Global Const $GC_S_RUNE_RITUALIST_MINOR_RESTORATION_MAGIC 		= "0121E821"	; Minor RestorationMagic Rune
Global Const $GC_S_RUNE_RITUALIST_MINOR_CHANNELING_MAGIC 		= "0122E821"	; Minor ChannelingMagic Rune
Global Const $GC_S_RUNE_RITUALIST_MINOR_SPAWNING_POWER 			= "0124E821"	; Minor SpawningPower Rune
Global Const $GC_S_RUNE_RITUALIST_MAJOR_COMMUNING 				= "0220E821"	; Major Communing Rune
Global Const $GC_S_RUNE_RITUALIST_MAJOR_RESTORATION_MAGIC 		= "0221E821"	; Major RestorationMagic Rune
Global Const $GC_S_RUNE_RITUALIST_MAJOR_CHANNELING_MAGIC 		= "0222E821"	; Major ChannelingMagic Rune
Global Const $GC_S_RUNE_RITUALIST_MAJOR_SPAWNING_POWER 			= "0224E821"	; Major SpawningPower
Global Const $GC_S_RUNE_RITUALIST_SUPERIOR_COMMUNING 			= "0320E821"	; Superior Communing Rune
Global Const $GC_S_RUNE_RITUALIST_SUPERIOR_RESTORATION_MAGIC 	= "0321E821"	; Superior RestorationMagic Rune
Global Const $GC_S_RUNE_RITUALIST_SUPERIOR_CHANNELING_MAGIC 	= "0322E821"	; Superior ChannelingMagic Rune
Global Const $GC_S_RUNE_RITUALIST_SUPERIOR_SPAWNING_POWER 		= "0324E821"	; Superior SpawningPower Rune

; Paragon
Global Const $GC_S_INSIGNIA_PARAGON_CENTURION					= "07020824"	; Centurion	Insignia

Global Const $GC_S_RUNE_PARAGON_MINOR_SPEAR_MASTERY				= "0125E821"	; Minor SpearMastery Rune
Global Const $GC_S_RUNE_PARAGON_MINOR_COMMAND 					= "0126E821"	; Minor Command Rune
Global Const $GC_S_RUNE_PARAGON_MINOR_MOTIVATION 				= "0127E821"	; Minor Motivation Rune
Global Const $GC_S_RUNE_PARAGON_MINOR_LEADERSHIP				= "0128E821"	; Minor Leadership Rune
Global Const $GC_S_RUNE_PARAGON_MAJOR_SPEAR_MASTERY				= "0225E821"	; Major SpearMastery Rune
Global Const $GC_S_RUNE_PARAGON_MAJOR_COMMAND  					= "0226E821"	; Major Command Rune
Global Const $GC_S_RUNE_PARAGON_MAJOR_MOTIVATION 				= "0227E821"	; Major Motivation Rune
Global Const $GC_S_RUNE_PARAGON_MAJOR_LEADERSHIP 				= "0228E821"	; Major Leadership Rune
Global Const $GC_S_RUNE_PARAGON_SUPERIOR_SPEAR_MASTERY	 		= "0325E821"	; Superior SpearMastery Rune
Global Const $GC_S_RUNE_PARAGON_SUPERIOR_COMMAND  				= "0326E821"	; Superior Command Rune
Global Const $GC_S_RUNE_PARAGON_SUPERIOR_MOTIVATION 			= "0327E821"	; Superior Motivation Rune
Global Const $GC_S_RUNE_PARAGON_SUPERIOR_LEADERSHIP 			= "0328E821"	; Superior Leadership Rune

; Dervish
Global Const $GC_S_INSIGNIA_DERVISH_WINDWALKER					= "02020824"	; Windwalker Insignia
Global Const $GC_S_INSIGNIA_DERVISH_FORSAKEN					= "03020824"	; Forsaken Insignia

Global Const $GC_S_RUNE_DERVISH_MINOR_SCYTHE_MASTERY			= "0129E821"	; Minor ScytheMastery Rune
Global Const $GC_S_RUNE_DERVISH_MINOR_WIND_PRAYERS 				= "012AE821"	; Minor WindPrayers Rune
Global Const $GC_S_RUNE_DERVISH_MINOR_EARTH_PRAYERS				= "012BE821"	; Minor EarthPrayers Rune
Global Const $GC_S_RUNE_DERVISH_MINOR_MYSTICISM					= "012CE821"	; Minor Mysticism Rune
Global Const $GC_S_RUNE_DERVISH_MAJOR_SCYTHE_MASTERY			= "0229E821"	; Major ScytheMastery Rune
Global Const $GC_S_RUNE_DERVISH_MAJOR_WIND_PRAYERS  			= "022AE821"	; Major WindPrayers Rune
Global Const $GC_S_RUNE_DERVISH_MAJOR_EARTH_PRAYERS 			= "022BE821"	; Major EarthPrayers Rune
Global Const $GC_S_RUNE_DERVISH_MAJOR_MYSTICISM 				= "022CE821"	; Major Mysticism Rune
Global Const $GC_S_RUNE_DERVISH_SUPERIOR_SCYTHE_MASTERY		 	= "0329E821"	; Superior ScytheMastery Rune
Global Const $GC_S_RUNE_DERVISH_SUPERIOR_WIND_PRAYERS  			= "032AE821"	; Superior WindPrayers Rune
Global Const $GC_S_RUNE_DERVISH_SUPERIOR_EARTH_PRAYERS 			= "032BE821"	; Superior EarthPrayers Rune
Global Const $GC_S_RUNE_DERVISH_SUPERIOR_MYSTICISM 				= "032CE821"	; Superior Mysticism Rune

; General
Global Const $GC_S_INSIGNIA_GENERAL_RADIANT 					= "E5010824"	; Radiant Insignia
Global Const $GC_S_INSIGNIA_GENERAL_SURVIVOR 					= "E6010824"	; Survivor Insignia
Global Const $GC_S_INSIGNIA_GENERAL_STALWART 					= "E7010824"	; Stalwart Insignia
Global Const $GC_S_INSIGNIA_GENERAL_BRAWLER 					= "E8010824"	; Brawler Insignia
Global Const $GC_S_INSIGNIA_GENERAL_BLESSED 					= "E9010824"	; Blessed Insignia
Global Const $GC_S_INSIGNIA_GENERAL_HERALD 						= "EA010824"	; Herald Insignia
Global Const $GC_S_INSIGNIA_GENERAL_SENTRY 						= "EB010824"	; Sentry Insignia

Global Const $GC_S_RUNE_GENERAL_ATTUNEMENT 						= "11020824"	; Attunement Rune
Global Const $GC_S_RUNE_GENERAL_VITAE							= "12020824"	; Vitae Rune
Global Const $GC_S_RUNE_GENERAL_RECOVERY						= "13020824"	; Recovery Rune
Global Const $GC_S_RUNE_GENERAL_RESTORATION						= "14020824"	; Restoration Rune
Global Const $GC_S_RUNE_GENERAL_CLARITY 						= "15020824"	; Clarity Rune
Global Const $GC_S_RUNE_GENERAL_PURITY							= "16020824"	; Purity Rune

Global Const $GC_S_RUNE_GENERAL_MINOR_VIGOR 					= "FF000824"	; Minor Vigor Rune
Global Const $GC_S_RUNE_GENERAL_MAJOR_VIGOR 					= "00010824"	; Major Vigor Rune
Global Const $GC_S_RUNE_GENERAL_SUPERIOR_VIGOR 					= "01010824"	; Superior Vigor Rune
#EndRegion ArmorMods (Runes)

#Region Consumable Crafted Items
Global Const $GC_I_MODELID_ESSENCE_OF_CELERITY = 24859
Global Const $GC_I_MODELID_ARMOR_OF_SALVATION = 24860
Global Const $GC_I_MODELID_GRAIL_OF_MIGHT = 24861
Global Const $GC_I_MODELID_POWERSTONE_OF_COURAGE = 24862
Global Const $GC_I_MODELID_STAR_OF_TRANSFERENCE = 25896
Global Const $GC_I_MODELID_PERFECT_SALVAGE_KIT = 25881
Global Const $GC_I_MODELID_SCROLL_OF_RESURRECTION = 26501

Global Const $GC_AI_ALL_CONSUMABLE_CRAFTER_ITEMS[8] = [ 7, _
    $GC_I_MODELID_ESSENCE_OF_CELERITY, _
    $GC_I_MODELID_ARMOR_OF_SALVATION, _
    $GC_I_MODELID_GRAIL_OF_MIGHT, _
    $GC_I_MODELID_POWERSTONE_OF_COURAGE, _
    $GC_I_MODELID_STAR_OF_TRANSFERENCE, _
    $GC_I_MODELID_PERFECT_SALVAGE_KIT, _
    $GC_I_MODELID_SCROLL_OF_RESURRECTION _
]
Global Const $GC_AI_CONSET[4] = [ 3, _
    $GC_I_MODELID_ESSENCE_OF_CELERITY, _
    $GC_I_MODELID_ARMOR_OF_SALVATION, _
    $GC_I_MODELID_GRAIL_OF_MIGHT _
]
#EndRegion Consumable Crafted Items

#Region Alcohol
Global Const $GC_I_MODELID_HUNTERS_ALE = 910
Global Const $GC_I_MODELID_FLASK_OF_FIREWATER = 2513
Global Const $GC_I_MODELID_DWARVEN_ALE = 5585
Global Const $GC_I_MODELID_WITCHS_BREW = 6049
Global Const $GC_I_MODELID_SPIKED_EGGNOG = 6366
Global Const $GC_I_MODELID_VIAL_OF_ABSINTHE = 6367
Global Const $GC_I_MODELID_EGGNOG = 6375
Global Const $GC_I_MODELID_SPIKED_EGGNOGG = 6366
Global Const $GC_I_MODELID_BOTTLE_OF_RICE_WINE = 15477
Global Const $GC_I_MODELID_ZEHTUKAS_JUG = 19171
Global Const $GC_I_MODELID_BOTTLE_OF_JUNIBERRY_GIN = 19172
Global Const $GC_I_MODELID_BOTTLE_OF_VABBIAN_WINE = 19173
Global Const $GC_I_MODELID_SHAMROCK_ALE = 22190
Global Const $GC_I_MODELID_AGED_DWARVEN_ALE = 24593
Global Const $GC_I_MODELID_HARD_APPLE_CIDER = 28435
Global Const $GC_I_MODELID_BOTTLE_OF_GROG = 30855
Global Const $GC_I_MODELID_AGED_HUNTERS_ALE = 31145
Global Const $GC_I_MODELID_KEG_OF_AGED_HUNTERS_ALE = 31146
Global Const $GC_I_MODELID_KRYTAN_BRANDY = 35124
Global Const $GC_I_MODELID_BATTLE_ISLE_ICED_TEA = 36682

Global Const $GC_AI_ALL_ALCOHOL[20] = [ 19, _
    $GC_I_MODELID_HUNTERS_ALE, _
    $GC_I_MODELID_FLASK_OF_FIREWATER, _
    $GC_I_MODELID_DWARVEN_ALE, _
    $GC_I_MODELID_WITCHS_BREW, _
    $GC_I_MODELID_SPIKED_EGGNOG, _
    $GC_I_MODELID_VIAL_OF_ABSINTHE, _
    $GC_I_MODELID_EGGNOG, _
    $GC_I_MODELID_BOTTLE_OF_RICE_WINE, _
    $GC_I_MODELID_ZEHTUKAS_JUG, _
    $GC_I_MODELID_BOTTLE_OF_JUNIBERRY_GIN, _
    $GC_I_MODELID_BOTTLE_OF_VABBIAN_WINE, _
    $GC_I_MODELID_SHAMROCK_ALE, _
    $GC_I_MODELID_AGED_DWARVEN_ALE, _
    $GC_I_MODELID_HARD_APPLE_CIDER, _
    $GC_I_MODELID_BOTTLE_OF_GROG, _
    $GC_I_MODELID_AGED_HUNTERS_ALE, _
    $GC_I_MODELID_KEG_OF_AGED_HUNTERS_ALE, _
    $GC_I_MODELID_KRYTAN_BRANDY, _
    $GC_I_MODELID_BATTLE_ISLE_ICED_TEA _
]

Global Const $GC_AI_ONEPOINT_ALCOHOL[12] = [ 11, _
    $GC_I_MODELID_HUNTERS_ALE, _
    $GC_I_MODELID_DWARVEN_ALE, _
    $GC_I_MODELID_WITCHS_BREW, _
    $GC_I_MODELID_VIAL_OF_ABSINTHE, _
    $GC_I_MODELID_EGGNOG, _
    $GC_I_MODELID_BOTTLE_OF_RICE_WINE, _
    $GC_I_MODELID_ZEHTUKAS_JUG, _
    $GC_I_MODELID_BOTTLE_OF_JUNIBERRY_GIN, _
    $GC_I_MODELID_BOTTLE_OF_VABBIAN_WINE, _
    $GC_I_MODELID_SHAMROCK_ALE, _
    $GC_I_MODELID_HARD_APPLE_CIDER _
]

Global Const $GC_AI_THREEPOINT_ALCOHOL[8] = [ 7, _
    $GC_I_MODELID_FLASK_OF_FIREWATER, _
    $GC_I_MODELID_SPIKED_EGGNOGG, _
    $GC_I_MODELID_AGED_DWARVEN_ALE, _
    $GC_I_MODELID_BOTTLE_OF_GROG, _
    $GC_I_MODELID_AGED_HUNTERS_ALE, _
    $GC_I_MODELID_KEG_OF_AGED_HUNTERS_ALE, _
    $GC_I_MODELID_KRYTAN_BRANDY _
]

Global Const $GC_AI_FIFTYPOINT_ALCOHOL[2] = [ 1, _
    $GC_I_MODELID_BATTLE_ISLE_ICED_TEA _
]
#Endregion Alcohol

#Region Party
Global Const $GC_I_MODELID_GHOST_IN_THE_BOX = 6368
Global Const $GC_I_MODELID_SQUASH_SERUM = 6369
Global Const $GC_I_MODELID_SNOWMAN_SUMMONER = 6376
Global Const $GC_I_MODELID_BOTTLE_ROCKET = 21809
Global Const $GC_I_MODELID_CHAMPAGNE_POPPER = 21810
Global Const $GC_I_MODELID_SPARKLER = 21813
Global Const $GC_I_MODELID_CRATE_OF_FIREWORKS = 29436
Global Const $GC_I_MODELID_DISCO_BALL = 29543
Global Const $GC_I_MODELID_PARTY_BEACON = 36683

Global Const $GC_AI_ALL_PARTY[10] = [ 9, _
    $GC_I_MODELID_GHOST_IN_THE_BOX, _
    $GC_I_MODELID_SQUASH_SERUM, _
    $GC_I_MODELID_SNOWMAN_SUMMONER, _
    $GC_I_MODELID_BOTTLE_ROCKET, _
    $GC_I_MODELID_CHAMPAGNE_POPPER, _
    $GC_I_MODELID_SPARKLER, _
    $GC_I_MODELID_CRATE_OF_FIREWORKS, _
    $GC_I_MODELID_DISCO_BALL, _
    $GC_I_MODELID_PARTY_BEACON _
]

Global Const $GC_AI_SPAMMABLE_PARTY[7] = [ 8, _
    $GC_I_MODELID_SQUASH_SERUM, _
    $GC_I_MODELID_SNOWMAN_SUMMONER, _
    $GC_I_MODELID_BOTTLE_ROCKET, _
    $GC_I_MODELID_CHAMPAGNE_POPPER, _
    $GC_I_MODELID_SPARKLER, _
    $GC_I_MODELID_PARTY_BEACON _
]

Global Const $GC_AI_NON_SPAMMABLE_PARTY[4] = [ 3, _
    $GC_I_MODELID_GHOST_IN_THE_BOX, _
    $GC_I_MODELID_CRATE_OF_FIREWORKS, _
    $GC_I_MODELID_DISCO_BALL _
]
#EndRegion Party

#Region Sweets
Global Const $GC_I_MODELID_CREME_BRULEE  = 15528
Global Const $GC_I_MODELID_RED_BEAN_CAKE = 15479
Global Const $GC_I_MODELID_MANDRAGOR_ROOT_CAKE = 19170
Global Const $GC_I_MODELID_FRUITCAKE = 21492
Global Const $GC_I_MODELID_SUGARY_BLUE_DRINK = 21812
Global Const $GC_I_MODELID_CHOCOLATE_BUNNY = 22644
Global Const $GC_I_MODELID_MINI_TREATS_OF_PURITY = 30208
Global Const $GC_I_MODELID_JAR_OF_HONEY = 31150
Global Const $GC_I_MODELID_KRYTAN_LOKUM = 35125
Global Const $GC_I_MODELID_DELICIOUS_CAKE = 36681

Global Const $GC_AI_ALL_SWEET[11] = [ 10, _
    $GC_I_MODELID_CREME_BRULEE, _
    $GC_I_MODELID_RED_BEAN_CAKE, _
    $GC_I_MODELID_MANDRAGOR_ROOT_CAKE, _
    $GC_I_MODELID_FRUITCAKE, _
    $GC_I_MODELID_SUGARY_BLUE_DRINK, _
    $GC_I_MODELID_CHOCOLATE_BUNNY, _
    $GC_I_MODELID_MINI_TREATS_OF_PURITY, _
    $GC_I_MODELID_JAR_OF_HONEY, _
    $GC_I_MODELID_KRYTAN_LOKUM, _
    $GC_I_MODELID_DELICIOUS_CAKE _
]
#EndRegion Sweets

#Region Tonics
Global Const $GC_I_MODELID_SINISTER_AUTOMATONIC_TONIC = 4730
Global Const $GC_I_MODELID_TRANSMOGRIFIER_TONIC = 15837
Global Const $GC_I_MODELID_YULETIDE_TONIC = 21490
Global Const $GC_I_MODELID_BEETLE_JUICE_TONIC = 22192
Global Const $GC_I_MODELID_ABYSSAL_TONIC = 30624
Global Const $GC_I_MODELID_CEREBRAL_TONIC = 30626
Global Const $GC_I_MODELID_MACABRE_TONIC = 30628
Global Const $GC_I_MODELID_TRAPDOOR_TONIC = 30630
Global Const $GC_I_MODELID_SEARING_TONIC = 30632
Global Const $GC_I_MODELID_AUTOMATONIC_TONIC = 30634
Global Const $GC_I_MODELID_SKELETONIC_TONIC = 30636
Global Const $GC_I_MODELID_BOREAL_TONIC = 30638
Global Const $GC_I_MODELID_GELATINOUS_TONIC = 30640
Global Const $GC_I_MODELID_PHANTASMAL_TONIC = 30642
Global Const $GC_I_MODELID_ABOMINABLE_TONIC = 30646
Global Const $GC_I_MODELID_FROSTY_TONIC = 30648
Global Const $GC_I_MODELID_MISCHIEVOUS_TONIC = 31020
Global Const $GC_I_MODELID_MYSTERIOUS_TONIC = 31141
Global Const $GC_I_MODELID_COTTONTAIL_TONIC = 31142
Global Const $GC_I_MODELID_ZAISHEN_TONIC = 31144
Global Const $GC_I_MODELID_UNSEEN_TONIC = 31172
Global Const $GC_I_MODELID_SPOOKY_TONIC = 37771
Global Const $GC_I_MODELID_MINUTELY_MAD_KING_TONIC = 37772

Global Const $GC_AI_NORMAL_TONICS[24] = [ 23, _
    $GC_I_MODELID_SINISTER_AUTOMATONIC_TONIC, _
    $GC_I_MODELID_TRANSMOGRIFIER_TONIC, _
    $GC_I_MODELID_YULETIDE_TONIC, _
    $GC_I_MODELID_BEETLE_JUICE_TONIC, _
    $GC_I_MODELID_ABYSSAL_TONIC, _
    $GC_I_MODELID_CEREBRAL_TONIC, _
    $GC_I_MODELID_MACABRE_TONIC, _
    $GC_I_MODELID_TRAPDOOR_TONIC, _
    $GC_I_MODELID_SEARING_TONIC, _
    $GC_I_MODELID_AUTOMATONIC_TONIC, _
    $GC_I_MODELID_SKELETONIC_TONIC, _
    $GC_I_MODELID_BOREAL_TONIC, _
    $GC_I_MODELID_GELATINOUS_TONIC, _
    $GC_I_MODELID_PHANTASMAL_TONIC, _
    $GC_I_MODELID_ABOMINABLE_TONIC, _
    $GC_I_MODELID_FROSTY_TONIC, _
    $GC_I_MODELID_MISCHIEVOUS_TONIC, _
    $GC_I_MODELID_MYSTERIOUS_TONIC, _
    $GC_I_MODELID_COTTONTAIL_TONIC, _
    $GC_I_MODELID_ZAISHEN_TONIC, _
    $GC_I_MODELID_UNSEEN_TONIC, _
    $GC_I_MODELID_SPOOKY_TONIC, _
    $GC_I_MODELID_MINUTELY_MAD_KING_TONIC _
]
#EndRegion Tonics

#Region EL Tonics
Global Const $GC_I_MODELID_EL_BEETLE_JUICE_TONIC = 21193
Global Const $GC_I_MODELID_EL_TRANSMOGRIFIER_TONIC = 23242
Global Const $GC_I_MODELID_EL_YULETIDE_TONIC = 29241
Global Const $GC_I_MODELID_EL_COTTONTAIL_TONIC = 31143
Global Const $GC_I_MODELID_EL_CRATE_OF_FIREWORKS = 31147
Global Const $GC_I_MODELID_EL_UNSEEN_TONIC = 31173
Global Const $GC_I_MODELID_EL_HENCHMAN_TONIC = 32850
Global Const $GC_I_MODELID_EL_REINDEER_TONIC = 34156
Global Const $GC_I_MODELID_EL_ABYSSAL_TONIC = 30625
Global Const $GC_I_MODELID_EL_CEREBRAL_TONIC = 30627
Global Const $GC_I_MODELID_EL_MACABRE_TONIC = 30629
Global Const $GC_I_MODELID_EL_TRAPDOOR_TONIC = 30631
Global Const $GC_I_MODELID_EL_SEARING_TONIC = 30633
Global Const $GC_I_MODELID_EL_AUTOMATONIC_TONIC = 30635
Global Const $GC_I_MODELID_EL_SKELETONIC_TONIC = 30637
Global Const $GC_I_MODELID_EL_BOREAL_TONIC = 30639
Global Const $GC_I_MODELID_EL_GELATINOUS_TONIC = 30641
Global Const $GC_I_MODELID_EL_PHANTASMAL_TONIC = 30643
Global Const $GC_I_MODELID_EL_ABOMINABLE_TONIC = 30647
Global Const $GC_I_MODELID_EL_FROSTY_TONIC = 30649
Global Const $GC_I_MODELID_EL_SINISTER_AUTOMATONIC_TONIC = 30827
Global Const $GC_I_MODELID_EL_MISCHIEVIOUS_TONIC = 31021
Global Const $GC_I_MODELID_EL_KOSS_TONIC = 36425
Global Const $GC_I_MODELID_EL_DUNKORO_TONIC = 36426
Global Const $GC_I_MODELID_EL_MELONNI_TONIC = 36427
Global Const $GC_I_MODELID_EL_ACOLYTE_JIN_TONIC = 36428
Global Const $GC_I_MODELID_EL_ACOLYTE_SOUSUKE_TONIC = 36429
Global Const $GC_I_MODELID_EL_TAHLKORA_TONIC = 36430
Global Const $GC_I_MODELID_EL_ZHED_SHADOWHOOF_TONIC = 36431
Global Const $GC_I_MODELID_EL_MAGRID_THE_SLY_TONIC = 36432
Global Const $GC_I_MODELID_EL_MASTER_OF_WHISPERS_TONIC = 36433
Global Const $GC_I_MODELID_EL_GOREN_TONIC = 36434
Global Const $GC_I_MODELID_EL_NORGU_TONIC = 36435
Global Const $GC_I_MODELID_EL_MORGAHN_TONIC = 36436
Global Const $GC_I_MODELID_EL_RAZAH_TONIC = 36437
Global Const $GC_I_MODELID_EL_OLIAS_TONIC = 36438
Global Const $GC_I_MODELID_EL_ZENMAI_TONIC = 36439
Global Const $GC_I_MODELID_EL_OGDEN_STONEHEALER_TONIC = 36440
Global Const $GC_I_MODELID_EL_VEKK_TONIC = 36441
Global Const $GC_I_MODELID_EL_GWEN_TONIC = 36442
Global Const $GC_I_MODELID_EL_XANDRA_TONIC = 36443
Global Const $GC_I_MODELID_EL_KAHMU_TONIC = 36444
Global Const $GC_I_MODELID_EL_JORA_TONIC = 36445
Global Const $GC_I_MODELID_EL_PYRE_FIERCEHOT_TONIC = 36446
Global Const $GC_I_MODELID_EL_ANTON_TONIC = 36447
Global Const $GC_I_MODELID_EL_HAYDA_TONIC = 36448
Global Const $GC_I_MODELID_EL_LIVIA_TONIC = 36449
Global Const $GC_I_MODELID_EL_KEIRAN_THACKERAY_TONIC = 36450
Global Const $GC_I_MODELID_EL_MIKU_TONIC = 36451
Global Const $GC_I_MODELID_EL_MOX_TONIC = 36452
Global Const $GC_I_MODELID_EL_SHIRO_TONIC = 36453
Global Const $GC_I_MODELID_EL_PRINCE_RURIK_TONIC = 36455
Global Const $GC_I_MODELID_EL_MARGONITE_TONIC = 36456
Global Const $GC_I_MODELID_EL_DESTROYER_TONIC = 36457
Global Const $GC_I_MODELID_EL_QUEEN_SALMA_TONIC = 36458
Global Const $GC_I_MODELID_EL_SLIGHTLY_MAD_KING_TONIC = 36460
Global Const $GC_I_MODELID_EL_KUUNAVANG_TONIC = 36461
Global Const $GC_I_MODELID_EL_GUILD_LORD_TONIC = 36652
Global Const $GC_I_MODELID_EL_KNIGHT_TONIC = 36655
Global Const $GC_I_MODELID_EL_AVATAR_OF_BALTHAZAR_TONIC = 36658
Global Const $GC_I_MODELID_EL_PRIEST_OF_BALTHAZAR_TONIC = 36659
Global Const $GC_I_MODELID_EL_GHOSTLY_HERO_TONIC = 36660
Global Const $GC_I_MODELID_EL_BALTHAZARS_CHAMPION_TONIC = 36661
Global Const $GC_I_MODELID_EL_GHOSTLY_PRIEST_TONIC = 36663
Global Const $GC_I_MODELID_EL_FLAME_SENTINEL_TONIC = 36664
Global Const $GC_I_MODELID_EL_LEGIONAIRE_TONIC = 37808


Global Const $GC_AI_EL_TONICS[68] = [ 67, _
    $GC_I_MODELID_EL_BEETLE_JUICE_TONIC, _
    $GC_I_MODELID_EL_TRANSMOGRIFIER_TONIC, _
    $GC_I_MODELID_EL_YULETIDE_TONIC, _
    $GC_I_MODELID_EL_COTTONTAIL_TONIC, _
    $GC_I_MODELID_EL_CRATE_OF_FIREWORKS, _
    $GC_I_MODELID_EL_UNSEEN_TONIC, _
    $GC_I_MODELID_EL_HENCHMAN_TONIC, _
    $GC_I_MODELID_EL_REINDEER_TONIC, _
    $GC_I_MODELID_EL_ABYSSAL_TONIC, _
    $GC_I_MODELID_EL_CEREBRAL_TONIC, _
    $GC_I_MODELID_EL_MACABRE_TONIC, _
    $GC_I_MODELID_EL_TRAPDOOR_TONIC, _
    $GC_I_MODELID_EL_SEARING_TONIC, _
    $GC_I_MODELID_EL_AUTOMATONIC_TONIC, _
    $GC_I_MODELID_EL_SKELETONIC_TONIC, _
    $GC_I_MODELID_EL_BOREAL_TONIC, _
    $GC_I_MODELID_EL_GELATINOUS_TONIC, _
    $GC_I_MODELID_EL_PHANTASMAL_TONIC, _
    $GC_I_MODELID_EL_ABOMINABLE_TONIC, _
    $GC_I_MODELID_EL_FROSTY_TONIC, _
    $GC_I_MODELID_EL_SINISTER_AUTOMATONIC_TONIC, _
    $GC_I_MODELID_EL_MISCHIEVIOUS_TONIC, _
    $GC_I_MODELID_EL_KOSS_TONIC, _
    $GC_I_MODELID_EL_DUNKORO_TONIC, _
    $GC_I_MODELID_EL_MELONNI_TONIC, _
    $GC_I_MODELID_EL_ACOLYTE_JIN_TONIC, _
    $GC_I_MODELID_EL_ACOLYTE_SOUSUKE_TONIC, _
    $GC_I_MODELID_EL_TAHLKORA_TONIC, _
    $GC_I_MODELID_EL_ZHED_SHADOWHOOF_TONIC, _
    $GC_I_MODELID_EL_MAGRID_THE_SLY_TONIC, _
    $GC_I_MODELID_EL_MASTER_OF_WHISPERS_TONIC, _
    $GC_I_MODELID_EL_GOREN_TONIC, _
    $GC_I_MODELID_EL_NORGU_TONIC, _
    $GC_I_MODELID_EL_MORGAHN_TONIC, _
    $GC_I_MODELID_EL_RAZAH_TONIC, _
    $GC_I_MODELID_EL_OLIAS_TONIC, _
    $GC_I_MODELID_EL_ZENMAI_TONIC, _
    $GC_I_MODELID_EL_OGDEN_STONEHEALER_TONIC, _
    $GC_I_MODELID_EL_VEKK_TONIC, _
    $GC_I_MODELID_EL_GWEN_TONIC, _
    $GC_I_MODELID_EL_XANDRA_TONIC, _
    $GC_I_MODELID_EL_KAHMU_TONIC, _
    $GC_I_MODELID_EL_JORA_TONIC, _
    $GC_I_MODELID_EL_PYRE_FIERCEHOT_TONIC, _
    $GC_I_MODELID_EL_ANTON_TONIC, _
    $GC_I_MODELID_EL_HAYDA_TONIC, _
    $GC_I_MODELID_EL_LIVIA_TONIC, _
    $GC_I_MODELID_EL_KEIRAN_THACKERAY_TONIC, _
    $GC_I_MODELID_EL_MIKU_TONIC, _
    $GC_I_MODELID_EL_MOX_TONIC, _
    $GC_I_MODELID_EL_SHIRO_TONIC, _
    $GC_I_MODELID_EL_PRINCE_RURIK_TONIC, _
    $GC_I_MODELID_EL_MARGONITE_TONIC, _
    $GC_I_MODELID_EL_DESTROYER_TONIC, _
    $GC_I_MODELID_EL_QUEEN_SALMA_TONIC, _
    $GC_I_MODELID_EL_SLIGHTLY_MAD_KING_TONIC, _
    $GC_I_MODELID_EL_KUUNAVANG_TONIC, _
    $GC_I_MODELID_EL_GUILD_LORD_TONIC, _
    $GC_I_MODELID_EL_KNIGHT_TONIC, _
    $GC_I_MODELID_EL_AVATAR_OF_BALTHAZAR_TONIC, _
    $GC_I_MODELID_EL_PRIEST_OF_BALTHAZAR_TONIC, _
    $GC_I_MODELID_EL_GHOSTLY_HERO_TONIC, _
    $GC_I_MODELID_EL_BALTHAZARS_CHAMPION_TONIC, _
    $GC_I_MODELID_EL_GHOSTLY_PRIEST_TONIC, _
    $GC_I_MODELID_EL_FLAME_SENTINEL_TONIC, _
    $GC_I_MODELID_EL_LEGIONAIRE_TONIC _
]

Global Const $GC_AI_WHITE_EL_TONIC[17] = [ 16, _
    $GC_I_MODELID_EL_DUNKORO_TONIC, _
    $GC_I_MODELID_EL_MELONNI_TONIC, _
    $GC_I_MODELID_EL_ACOLYTE_JIN_TONIC, _
    $GC_I_MODELID_EL_ACOLYTE_SOUSUKE_TONIC, _
    $GC_I_MODELID_EL_TAHLKORA_TONIC, _
    $GC_I_MODELID_EL_MAGRID_THE_SLY_TONIC, _
    $GC_I_MODELID_EL_GOREN_TONIC, _
    $GC_I_MODELID_EL_NORGU_TONIC, _
    $GC_I_MODELID_EL_MORGAHN_TONIC, _
    $GC_I_MODELID_EL_OLIAS_TONIC, _
    $GC_I_MODELID_EL_ZENMAI_TONIC, _
    $GC_I_MODELID_EL_VEKK_TONIC, _
    $GC_I_MODELID_EL_XANDRA_TONIC, _
    $GC_I_MODELID_EL_KAHMU_TONIC, _
    $GC_I_MODELID_EL_HAYDA_TONIC, _
    $GC_I_MODELID_EL_LIVIA_TONIC _
]

Global Const $GC_AI_PURPLE_EL_TONIC[11] = [ 10, _
    $GC_I_MODELID_EL_KOSS_TONIC, _
    $GC_I_MODELID_EL_ZHED_SHADOWHOOF_TONIC, _
    $GC_I_MODELID_EL_MASTER_OF_WHISPERS_TONIC, _
    $GC_I_MODELID_EL_RAZAH_TONIC, _
    $GC_I_MODELID_EL_OGDEN_STONEHEALER_TONIC, _
    $GC_I_MODELID_EL_JORA_TONIC, _
    $GC_I_MODELID_EL_PYRE_FIERCEHOT_TONIC, _
    $GC_I_MODELID_EL_ANTON_TONIC, _
    $GC_I_MODELID_EL_MOX_TONIC, _
    $GC_I_MODELID_EL_QUEEN_SALMA_TONIC _
]

Global Const $GC_AI_GOLD_EL_TONIC[6] = [ 5, _
    $GC_I_MODELID_EL_GWEN_TONIC, _
    $GC_I_MODELID_EL_KEIRAN_THACKERAY_TONIC, _
    $GC_I_MODELID_EL_MIKU_TONIC, _
    $GC_I_MODELID_EL_SHIRO_TONIC, _
    $GC_I_MODELID_EL_PRINCE_RURIK_TONIC _
]

Global Const $GC_AI_GREEN_EL_TONIC[5] = [ 4, _
    $GC_I_MODELID_EL_MARGONITE_TONIC, _
    $GC_I_MODELID_EL_DESTROYER_TONIC, _
    $GC_I_MODELID_EL_SLIGHTLY_MAD_KING_TONIC, _
    $GC_I_MODELID_EL_KUUNAVANG_TONIC _
]

Global Const $GC_AI_PVP_EL_TONIC[9] = [ 8, _
    $GC_I_MODELID_EL_GUILD_LORD_TONIC, _
    $GC_I_MODELID_EL_KNIGHT_TONIC, _
    $GC_I_MODELID_EL_AVATAR_OF_BALTHAZAR_TONIC, _
    $GC_I_MODELID_EL_PRIEST_OF_BALTHAZAR_TONIC, _
    $GC_I_MODELID_EL_GHOSTLY_HERO_TONIC, _
    $GC_I_MODELID_EL_BALTHAZARS_CHAMPION_TONIC, _
    $GC_I_MODELID_EL_GHOSTLY_PRIEST_TONIC, _
    $GC_I_MODELID_EL_FLAME_SENTINEL_TONIC _
]
#EndRegion EL Tonics

#Region Pcons
Global Const $GC_I_MODELID_DRAKE_KABOB = 17060
Global Const $GC_I_MODELID_SKALEFIN_SOUP = 17061
Global Const $GC_I_MODELID_PAHNAI_SALAD = 17062
Global Const $GC_I_MODELID_CUPCAKE = 22269
Global Const $GC_I_MODELID_PUMPKIN_PIE = 28436
Global Const $GC_I_MODELID_GOLDEN_EGG = 22752
Global Const $GC_I_MODELID_CANDY_CORN = 28432
Global Const $GC_I_MODELID_CANDY_APPLE = 28431
Global Const $GC_I_MODELID_LUNAR_FORTUNE = 21833
Global Const $GC_I_MODELID_LUNAR_FORTUNE_2 = 29434
Global Const $GC_I_MODELID_WAR_SUPPLIES = 35121
Global Const $GC_I_MODELID_BLUE_ROCK = 31151
Global Const $GC_I_MODELID_GREEN_ROCK = 31152
Global Const $GC_I_MODELID_RED_ROCK = 31153

Global Const $GC_AI_PCONS[15] = [ 14, _
    $GC_I_MODELID_DRAKE_KABOB, _
    $GC_I_MODELID_SKALEFIN_SOUP, _
    $GC_I_MODELID_PAHNAI_SALAD, _
    $GC_I_MODELID_CUPCAKE, _
    $GC_I_MODELID_PUMPKIN_PIE, _
    $GC_I_MODELID_GOLDEN_EGG, _
    $GC_I_MODELID_CANDY_CORN, _
    $GC_I_MODELID_CANDY_APPLE, _
    $GC_I_MODELID_LUNAR_FORTUNE, _
    $GC_I_MODELID_LUNAR_FORTUNE_2, _
    $GC_I_MODELID_WAR_SUPPLIES, _
    $GC_I_MODELID_BLUE_ROCK, _
    $GC_I_MODELID_GREEN_ROCK, _
    $GC_I_MODELID_RED_ROCK _
]
#Endregion Pcons

#Region DP Removals
Global Const $GC_I_MODELID_PEPPERMINT_CC = 6370
Global Const $GC_I_MODELID_REFINED_JELLY = 19039
Global Const $GC_I_MODELID_ELIXIR_OF_VALOR = 21227
Global Const $GC_I_MODELID_WINTERGREEN_CC = 21488
Global Const $GC_I_MODELID_RAINBOW_CC = 21489
Global Const $GC_I_MODELID_FOUR_LEAF_CLOVER = 22191
Global Const $GC_I_MODELID_HONEYCOMB = 26784
Global Const $GC_I_MODELID_PUMPKIN_COOKIE = 28433
Global Const $GC_I_MODELID_OATH_OF_PURITY = 30206
Global Const $GC_I_MODELID_SEAL_OF_THE_DRAGON_EMPIRE = 30211
Global Const $GC_I_MODELID_SHINING_BLADE_RATION = 35127

Global Const $GC_AI_DP_REMOVAL[12] = [ 11, _
    $GC_I_MODELID_PEPPERMINT_CC, _
    $GC_I_MODELID_REFINED_JELLY, _
    $GC_I_MODELID_ELIXIR_OF_VALOR, _
    $GC_I_MODELID_WINTERGREEN_CC, _
    $GC_I_MODELID_RAINBOW_CC, _
    $GC_I_MODELID_FOUR_LEAF_CLOVER, _
    $GC_I_MODELID_HONEYCOMB, _
    $GC_I_MODELID_PUMPKIN_COOKIE, _
    $GC_I_MODELID_OATH_OF_PURITY, _
    $GC_I_MODELID_SEAL_OF_THE_DRAGON_EMPIRE, _
    $GC_I_MODELID_SHINING_BLADE_RATION _
]
#Endregion DP Removals

#Region Events
Global Const $GC_I_MODELID_CC_SHARDS = 556
Global Const $GC_I_MODELID_VICTORY_TOKEN = 18345
Global Const $GC_I_MODELID_LUNAR_TOKEN = 21833
Global Const $GC_I_MODELID_TOTS = 28434
Global Const $GC_I_MODELID_WAYFARER_MARK = 37765
Global Const $GC_I_MODELID_RACING_MEDAL = 37793

Global Const $GC_AI_EVENT_ITEMS[20] = [ 19, _
    $GC_I_MODELID_CHOCOLATE_BUNNY, _
    $GC_I_MODELID_BOTTLE_OF_GROG, _
    $GC_I_MODELID_SHAMROCK_ALE, _
    $GC_I_MODELID_HARD_APPLE_CIDER, _
    $GC_I_MODELID_CHAMPAGNE_POPPER, _
    $GC_I_MODELID_BOTTLE_ROCKET, _
    $GC_I_MODELID_SPARKLER, _
    $GC_I_MODELID_HUNTERS_ALE, _
    $GC_I_MODELID_KRYTAN_BRANDY, _
    $GC_I_MODELID_SUGARY_BLUE_DRINK, _
    $GC_I_MODELID_FRUITCAKE, _
    $GC_I_MODELID_SPIKED_EGGNOGG, _
    $GC_I_MODELID_EGGNOG, _
    $GC_I_MODELID_SNOWMAN_SUMMONER, _
    $GC_I_MODELID_FROSTY_TONIC, _
    $GC_I_MODELID_MISCHIEVOUS_TONIC, _
    $GC_I_MODELID_DELICIOUS_CAKE, _
    $GC_I_MODELID_BATTLE_ISLE_ICED_TEA, _
    $GC_I_MODELID_PARTY_BEACON _
]

Global Const $GC_AI_EVENT_TROPHIES[7] = [ 6, _
    $GC_I_MODELID_RACING_MEDAL, _
    $GC_I_MODELID_TOTS, _
    $GC_I_MODELID_CC_SHARDS, _
    $GC_I_MODELID_VICTORY_TOKEN, _
    $GC_I_MODELID_LUNAR_TOKEN, _
    $GC_I_MODELID_WAYFARER_MARK _
]
#Endregion Events

#Region Reward Trophy
Global Const $GC_I_MODELID_EQUIPMENT_REQUISITION = 5817
Global Const $GC_I_MODELID_MONASTERY_CREDIT = 5819
Global Const $GC_I_MODELID_LUXON_TOTEM = 6048
Global Const $GC_I_MODELID_IMPERIAL_COMMENDATION = 6068
Global Const $GC_I_MODELID_BATTLE_COMMENDATION = 17081
Global Const $GC_I_MODELID_TRADE_CONTRACT = 17082
Global Const $GC_I_MODELID_ANCIENT_ARTIFACT = 19182
Global Const $GC_I_MODELID_KOURNAN_COIN = 19195
Global Const $GC_I_MODELID_INSCRIBED_SECRET = 19196
Global Const $GC_I_MODELID_ARMBRACE_OF_TRUTH = 21127
Global Const $GC_I_MODELID_MARGONITE_GEMSTONE = 21128
Global Const $GC_I_MODELID_STYGIAN_GEMSTONE = 21129
Global Const $GC_I_MODELID_TITAN_GEMSTONE = 21130
Global Const $GC_I_MODELID_TORMENT_GEMSTONE = 21131
Global Const $GC_I_MODELID_COFFER_OF_WHISPERS = 21228
Global Const $GC_I_MODELID_GLOB_OF_FROZEN_ECTOPLASM = 21509
Global Const $GC_I_MODELID_ZHOS_JOURNAL = 25866
Global Const $GC_I_MODELID_BISON_CHAMPIONSHIP_TOKEN = 27563
Global Const $GC_I_MODELID_MONUMENTAL_TAPESTRY = 27583
Global Const $GC_I_MODELID_BUROL_IRONFISTS_COMMENDATION = 29018
Global Const $GC_I_MODELID_IMPERIAL_GUARD_REQUISITION_ORDER = 29108
Global Const $GC_I_MODELID_IMPERIAL_GUARD_LOCKBOX = 30212
Global Const $GC_I_MODELID_GIFT_OF_THE_TRAVELLER = 31148
Global Const $GC_I_MODELID_GIFT_OF_THE_HUNTSMAN = 31149
Global Const $GC_I_MODELID_COPPER_ZAISHEN_COIN = 31202
Global Const $GC_I_MODELID_GOLD_ZAISHEN_COIN = 31203
Global Const $GC_I_MODELID_SILVER_ZAISHEN_COIN = 31204
Global Const $GC_I_MODELID_PAPER_WRAPPED_PARCEL = 34212
Global Const $GC_I_MODELID_SACK_OF_RANDOM_JUNK = 34213
Global Const $GC_I_MODELID_ROYAL_GIFT = 35120
Global Const $GC_I_MODELID_CONFESSORS_ORDERS = 35123
Global Const $GC_I_MODELID_CHAMPIONS_ZAISHEN_STRONGBOX = 36665
Global Const $GC_I_MODELID_HEROS_ZAISHEN_STRONGBOX = 36666
Global Const $GC_I_MODELID_GLADIATORS_ZAISHEN_STRONGBOX = 36667
Global Const $GC_I_MODELID_STRATEGISTS_ZAISHEN_STRONGBOX = 36668
Global Const $GC_I_MODELID_MINISTERIAL_COMMENDATION = 36985

Global Const $GC_AI_REWARD_TROPHIES[36] = [35, _
    $GC_I_MODELID_COPPER_ZAISHEN_COIN, _
    $GC_I_MODELID_GOLD_ZAISHEN_COIN, _
    $GC_I_MODELID_SILVER_ZAISHEN_COIN, _
    $GC_I_MODELID_MONASTERY_CREDIT, _
    $GC_I_MODELID_IMPERIAL_COMMENDATION, _
    $GC_I_MODELID_LUXON_TOTEM, _
    $GC_I_MODELID_EQUIPMENT_REQUISITION, _
    $GC_I_MODELID_BATTLE_COMMENDATION, _
    $GC_I_MODELID_KOURNAN_COIN, _
    $GC_I_MODELID_TRADE_CONTRACT, _
    $GC_I_MODELID_ANCIENT_ARTIFACT, _
    $GC_I_MODELID_INSCRIBED_SECRET, _
    $GC_I_MODELID_BUROL_IRONFISTS_COMMENDATION, _
    $GC_I_MODELID_BISON_CHAMPIONSHIP_TOKEN, _
    $GC_I_MODELID_MONUMENTAL_TAPESTRY, _
    $GC_I_MODELID_ROYAL_GIFT, _
    $GC_I_MODELID_CONFESSORS_ORDERS, _
    $GC_I_MODELID_PAPER_WRAPPED_PARCEL, _
    $GC_I_MODELID_SACK_OF_RANDOM_JUNK, _
    $GC_I_MODELID_MINISTERIAL_COMMENDATION, _
    $GC_I_MODELID_IMPERIAL_GUARD_REQUISITION_ORDER, _
    $GC_I_MODELID_GLOB_OF_FROZEN_ECTOPLASM, _
    $GC_I_MODELID_ARMBRACE_OF_TRUTH, _
    $GC_I_MODELID_MARGONITE_GEMSTONE, _
    $GC_I_MODELID_STYGIAN_GEMSTONE, _
    $GC_I_MODELID_TITAN_GEMSTONE, _
    $GC_I_MODELID_TORMENT_GEMSTONE, _
    $GC_I_MODELID_COFFER_OF_WHISPERS, _
    $GC_I_MODELID_GIFT_OF_THE_TRAVELLER, _
    $GC_I_MODELID_GIFT_OF_THE_HUNTSMAN, _
    $GC_I_MODELID_CHAMPIONS_ZAISHEN_STRONGBOX, _
    $GC_I_MODELID_HEROS_ZAISHEN_STRONGBOX, _
    $GC_I_MODELID_GLADIATORS_ZAISHEN_STRONGBOX, _
    $GC_I_MODELID_STRATEGISTS_ZAISHEN_STRONGBOX, _
    $GC_I_MODELID_ZHOS_JOURNAL _
]
#EndRegion Reward Trophy

#Region Tomes
Global Const $GC_I_MODELID_ELITE_ASSASSIN_TOME = 21786
Global Const $GC_I_MODELID_ELITE_MESMER_TOME = 21787
Global Const $GC_I_MODELID_ELITE_NECROMANCER_TOME = 21788
Global Const $GC_I_MODELID_ELITE_ELEMENTALIST_TOME = 21789
Global Const $GC_I_MODELID_ELITE_MONK_TOME = 21790
Global Const $GC_I_MODELID_ELITE_WARRIOR_TOME = 21791
Global Const $GC_I_MODELID_ELITE_RANGER_TOME = 21792
Global Const $GC_I_MODELID_ELITE_DERVISH_TOME = 21793
Global Const $GC_I_MODELID_ELITE_RITUALIST_TOME = 21794
Global Const $GC_I_MODELID_ELITE_PARAGON_TOME = 21795

Global Const $GC_AI_ELITE_TOMES[11] = [ 10, _
    $GC_I_MODELID_ELITE_WARRIOR_TOME, _
    $GC_I_MODELID_ELITE_RANGER_TOME, _
    $GC_I_MODELID_ELITE_MONK_TOME, _
    $GC_I_MODELID_ELITE_NECROMANCER_TOME, _
    $GC_I_MODELID_ELITE_MESMER_TOME, _
    $GC_I_MODELID_ELITE_ELEMENTALIST_TOME, _
    $GC_I_MODELID_ELITE_ASSASSIN_TOME, _
    $GC_I_MODELID_ELITE_RITUALIST_TOME, _
	$GC_I_MODELID_ELITE_PARAGON_TOME, _
    $GC_I_MODELID_ELITE_DERVISH_TOME _
]

Global Const $GC_I_MODELID_ASSASSIN_TOME = 21796
Global Const $GC_I_MODELID_MESMER_TOME = 21797
Global Const $GC_I_MODELID_NECROMANCER_TOME = 21798
Global Const $GC_I_MODELID_ELEMENTALIST_TOME = 21799
Global Const $GC_I_MODELID_MONK_TOME = 21800
Global Const $GC_I_MODELID_WARRIOR_TOME = 21801
Global Const $GC_I_MODELID_RANGER_TOME = 21802
Global Const $GC_I_MODELID_DERVISH_TOME = 21803
Global Const $GC_I_MODELID_RITUALIST_TOME = 21804
Global Const $GC_I_MODELID_PARAGON_TOME = 21805

Global Const $GC_AI_NORMAL_TOMES[11] = [ 10, _
    $GC_I_MODELID_WARRIOR_TOME, _
    $GC_I_MODELID_RANGER_TOME, _
	$GC_I_MODELID_MONK_TOME, _
    $GC_I_MODELID_NECROMANCER_TOME, _
    $GC_I_MODELID_MESMER_TOME, _
    $GC_I_MODELID_ELEMENTALIST_TOME, _
    $GC_I_MODELID_ASSASSIN_TOME, _
    $GC_I_MODELID_RITUALIST_TOME, _
	$GC_I_MODELID_PARAGON_TOME, _
    $GC_I_MODELID_DERVISH_TOME _
]

Global Const $GC_AI_ALL_TOMES[21] = [ 20, _
    $GC_I_MODELID_WARRIOR_TOME, _
    $GC_I_MODELID_RANGER_TOME, _
	$GC_I_MODELID_MONK_TOME, _
    $GC_I_MODELID_NECROMANCER_TOME, _
    $GC_I_MODELID_MESMER_TOME, _
    $GC_I_MODELID_ELEMENTALIST_TOME, _
    $GC_I_MODELID_ASSASSIN_TOME, _
    $GC_I_MODELID_RITUALIST_TOME, _
    $GC_I_MODELID_PARAGON_TOME, _
	$GC_I_MODELID_DERVISH_TOME, _
    $GC_I_MODELID_ELITE_WARRIOR_TOME, _
    $GC_I_MODELID_ELITE_RANGER_TOME, _
	$GC_I_MODELID_ELITE_MONK_TOME, _
    $GC_I_MODELID_ELITE_NECROMANCER_TOME, _
    $GC_I_MODELID_ELITE_MESMER_TOME, _
    $GC_I_MODELID_ELITE_ELEMENTALIST_TOME, _
    $GC_I_MODELID_ELITE_ASSASSIN_TOME, _
    $GC_I_MODELID_ELITE_RITUALIST_TOME, _
    $GC_I_MODELID_ELITE_PARAGON_TOME, _
    $GC_I_MODELID_ELITE_DERVISH_TOME _
]
#EndRegion Tomes

#Region Stone
Global Const $GC_I_MODELID_MERCANTILE_SUMMONING_STONE = 21154
Global Const $GC_I_MODELID_TENGU_SUPPORT_FLARE = 30209
Global Const $GC_I_MODELID_IMPERIAL_GUARD_REINFORCEMENT_ORDER = 30210
Global Const $GC_I_MODELID_AUTOMATON_SUMMONING_STONE = 30846
Global Const $GC_I_MODELID_IGNEOUS_SUMMONING_STONE = 30847
Global Const $GC_I_MODELID_CHITINOUS_SUMMONING_STONE = 30959
Global Const $GC_I_MODELID_MYSTICAL_SUMMONING_STONE = 30960
Global Const $GC_I_MODELID_AMBER_SUMMONING_STONE = 30961
Global Const $GC_I_MODELID_ARTIC_SUMMONING_STONE = 30962
Global Const $GC_I_MODELID_DEMONIC_SUMMONING_STONE = 30963
Global Const $GC_I_MODELID_GELATINOUS_SUMMONING_STONE = 30964
Global Const $GC_I_MODELID_FOSSILIZED_SUMMONING_STONE = 30965
Global Const $GC_I_MODELID_JADEITE_SUMMONING_STONE = 30966
Global Const $GC_I_MODELID_MISCHIEVOUS_SUMMONING_STONE = 31022
Global Const $GC_I_MODELID_FROSTY_SUMMONING_STONE = 31023
Global Const $GC_I_MODELID_MYSTERIOUS_SUMMONING_STONE = 31155
Global Const $GC_I_MODELID_ZAISHEN_SUMMONING_STONE = 31156
Global Const $GC_I_MODELID_GHASTLY_SUMMONING_STONE = 32557
Global Const $GC_I_MODELID_CELESTIAL_SUMMONING_STONE = 34176
Global Const $GC_I_MODELID_SHINING_BLADE_WAR_HORN = 35126
Global Const $GC_I_MODELID_LEGIONNAIRE_SUMMONING_STONE = 37810

Global Const $GC_AI_ALL_SUMMONING_STONES[22] = [21, _
    $GC_I_MODELID_MERCANTILE_SUMMONING_STONE, _
    $GC_I_MODELID_TENGU_SUPPORT_FLARE, _
    $GC_I_MODELID_IMPERIAL_GUARD_REINFORCEMENT_ORDER, _
    $GC_I_MODELID_AUTOMATON_SUMMONING_STONE, _
    $GC_I_MODELID_IGNEOUS_SUMMONING_STONE, _
    $GC_I_MODELID_CHITINOUS_SUMMONING_STONE, _
    $GC_I_MODELID_MYSTICAL_SUMMONING_STONE, _
    $GC_I_MODELID_AMBER_SUMMONING_STONE, _
    $GC_I_MODELID_ARTIC_SUMMONING_STONE, _
    $GC_I_MODELID_DEMONIC_SUMMONING_STONE, _
    $GC_I_MODELID_GELATINOUS_SUMMONING_STONE, _
    $GC_I_MODELID_FOSSILIZED_SUMMONING_STONE, _
    $GC_I_MODELID_JADEITE_SUMMONING_STONE, _
    $GC_I_MODELID_MISCHIEVOUS_SUMMONING_STONE, _
    $GC_I_MODELID_FROSTY_SUMMONING_STONE, _
    $GC_I_MODELID_MYSTERIOUS_SUMMONING_STONE, _
    $GC_I_MODELID_ZAISHEN_SUMMONING_STONE, _
    $GC_I_MODELID_GHASTLY_SUMMONING_STONE, _
    $GC_I_MODELID_CELESTIAL_SUMMONING_STONE, _
    $GC_I_MODELID_SHINING_BLADE_WAR_HORN, _
    $GC_I_MODELID_LEGIONNAIRE_SUMMONING_STONE _
]
#EndRegion Stone

#Region Keys
Global Const $GC_I_MODELID_BOGROOTS_BOSS_KEY = 2593
Global Const $GC_I_MODELID_PHANTOM_KEY = 5882
Global Const $GC_I_MODELID_ELONIAN_KEY = 5960
Global Const $GC_I_MODELID_MINERS_KEY = 5961
Global Const $GC_I_MODELID_SHIVERPEAK_KEY = 5962
Global Const $GC_I_MODELID_DARKSTONE_KEY = 5963
Global Const $GC_I_MODELID_KRYTAN_KEY = 5964
Global Const $GC_I_MODELID_MAGUUMA_KEY = 5965
Global Const $GC_I_MODELID_ASCALONIAN_KEY = 5966
Global Const $GC_I_MODELID_STEEL_KEY = 5967
Global Const $GC_I_MODELID_OBSIDIAN_KEY = 5971
Global Const $GC_I_MODELID_FORBIDDEN_KEY = 6534
Global Const $GC_I_MODELID_KURZICK_KEY = 6535
Global Const $GC_I_MODELID_STONEROOT_KEY = 6536
Global Const $GC_I_MODELID_SHING_JEA_KEY = 6537
Global Const $GC_I_MODELID_LUXON_KEY = 6538
Global Const $GC_I_MODELID_DEEP_JADE_KEY = 6539
Global Const $GC_I_MODELID_CANTHAN_KEY = 6540
Global Const $GC_I_MODELID_ANCIENT_ELONIAN_KEY = 15556
Global Const $GC_I_MODELID_ISTANI_KEY = 15557
Global Const $GC_I_MODELID_VABBIAN_KEY = 15558
Global Const $GC_I_MODELID_KOURNAN_KEY = 15559
Global Const $GC_I_MODELID_MARGONITE_KEY = 15560
Global Const $GC_I_MODELID_DEMONIC_KEY = 19174
Global Const $GC_I_MODELID_LOCKPICK = 22751
Global Const $GC_I_MODELID_ZAISHEN_KEY = 28571

Global Const $GC_AI_KEYS[27] = [ 26, _
    $GC_I_MODELID_BOGROOTS_BOSS_KEY, _
    $GC_I_MODELID_PHANTOM_KEY, _
    $GC_I_MODELID_ELONIAN_KEY, _
    $GC_I_MODELID_MINERS_KEY, _
    $GC_I_MODELID_SHIVERPEAK_KEY, _
    $GC_I_MODELID_DARKSTONE_KEY, _
    $GC_I_MODELID_KRYTAN_KEY, _
    $GC_I_MODELID_MAGUUMA_KEY, _
    $GC_I_MODELID_ASCALONIAN_KEY, _
    $GC_I_MODELID_STEEL_KEY, _
    $GC_I_MODELID_OBSIDIAN_KEY, _
    $GC_I_MODELID_FORBIDDEN_KEY, _
    $GC_I_MODELID_KURZICK_KEY, _
    $GC_I_MODELID_STONEROOT_KEY, _
    $GC_I_MODELID_SHING_JEA_KEY, _
    $GC_I_MODELID_LUXON_KEY, _
    $GC_I_MODELID_DEEP_JADE_KEY, _
    $GC_I_MODELID_CANTHAN_KEY, _
    $GC_I_MODELID_ANCIENT_ELONIAN_KEY, _
    $GC_I_MODELID_ISTANI_KEY, _
    $GC_I_MODELID_VABBIAN_KEY, _
    $GC_I_MODELID_KOURNAN_KEY, _
    $GC_I_MODELID_MARGONITE_KEY, _
    $GC_I_MODELID_DEMONIC_KEY, _
    $GC_I_MODELID_LOCKPICK, _
    $GC_I_MODELID_ZAISHEN_KEY _
]

#EndRegion Keys

#Region Hero Armor Upgrades
Global Const $GC_I_MODELID_ANCIENT_ARMOR_REMNANT = 19190
Global Const $GC_I_MODELID_STOLEN_SUNSPEAR_ARMOR = 19191
Global Const $GC_I_MODELID_MYSTERIOUS_ARMOR_PIECE = 19192
Global Const $GC_I_MODELID_PRIMEVAL_ARMOR_REMNANT = 19193
Global Const $GC_I_MODELID_DELDRIMOR_ARMOR_REMNANT = 27321
Global Const $GC_I_MODELID_CLOTH_OF_THE_BROTHERHOOD = 27322

Global Const $GC_AI_ALL_HERO_ARMOR_UPGRADES[7] = [ 6, _
    $GC_I_MODELID_ANCIENT_ARMOR_REMNANT, _
    $GC_I_MODELID_STOLEN_SUNSPEAR_ARMOR, _
    $GC_I_MODELID_MYSTERIOUS_ARMOR_PIECE, _
    $GC_I_MODELID_PRIMEVAL_ARMOR_REMNANT, _
    $GC_I_MODELID_DELDRIMOR_ARMOR_REMNANT, _
    $GC_I_MODELID_CLOTH_OF_THE_BROTHERHOOD _
]
#EndRegion Hero_Armor_Upgrades

#Region Endgame Rewards
Global Const $GC_I_MODELID_AMULET_OF_THE_MISTS = 6069
Global Const $GC_I_MODELID_BOOK_OF_SECRETS = 19197
Global Const $GC_I_MODELID_DROKNARS_KEY = 26724
Global Const $GC_I_MODELID_IMPERIAL_DRAGONS_TEAR = 30205
Global Const $GC_I_MODELID_DELDRIMOR_TALISMAN = 30693
Global Const $GC_I_MODELID_MEDAL_OF_HONOR = 35122

Global Const $GC_AI_ALL_ENDGAME_REWARDS[7] = [ 6, _
    $GC_I_MODELID_AMULET_OF_THE_MISTS, _
    $GC_I_MODELID_BOOK_OF_SECRETS, _
    $GC_I_MODELID_DROKNARS_KEY, _
    $GC_I_MODELID_IMPERIAL_DRAGONS_TEAR, _
    $GC_I_MODELID_DELDRIMOR_TALISMAN, _
    $GC_I_MODELID_MEDAL_OF_HONOR _
]
#EndRegion Endgame Rewards

#Region Polymock
Global Const $GC_I_MODELID_WIND_RIDER_POLYMOCK_PIECE = 24356
Global Const $GC_I_MODELID_GARGOYLE_POLYMOCK_PIECE = 24361
Global Const $GC_I_MODELID_MERGOYLE_POLYMOCK_PIECE = 24369
Global Const $GC_I_MODELID_SKALE_POLYMOCK_PIECE = 24373
Global Const $GC_I_MODELID_FIRE_IMP_POLYMOCK_PIECE = 24359
Global Const $GC_I_MODELID_KAPPA_POLYMOCK_PIECE = 24367
Global Const $GC_I_MODELID_ICE_IMP_POLYMOCK_PIECE = 24366
Global Const $GC_I_MODELID_EARTH_ELEMENTAL_POLYMOCK_PIECE = 24357
Global Const $GC_I_MODELID_ICE_ELEMENTAL_POLYMOCK_PIECE = 24365
Global Const $GC_I_MODELID_FIRE_ELEMENTAL_POLYMOCK_PIECE = 24358
Global Const $GC_I_MODELID_ALOE_SEED_POLYMOCK_PIECE = 24355
Global Const $GC_I_MODELID_MIRAGE_IBOGA_POLYMOCK_PIECE = 24363
Global Const $GC_I_MODELID_GAKI_POLYMOCK_PIECE = 24360
Global Const $GC_I_MODELID_MANTIS_DREAMWEAVER_POLYMOCK_PIECE = 24368
Global Const $GC_I_MODELID_MURSAAT_ELEMENTALIST_POLYMOCK_PIECE = 24370
Global Const $GC_I_MODELID_RUBY_DJINN_POLYMOCK_PIECE = 24371
Global Const $GC_I_MODELID_NAGA_SHAMAN_POLYMOCK_PIECE = 24372
Global Const $GC_I_MODELID_STONE_RAIN_POLYMOCK_PIECE = 24374

Global Const $GC_AI_ALL_POLYMOCK_PIECES[19] = [ 18, _
    $GC_I_MODELID_ALOE_SEED_POLYMOCK_PIECE, _
    $GC_I_MODELID_WIND_RIDER_POLYMOCK_PIECE, _
    $GC_I_MODELID_EARTH_ELEMENTAL_POLYMOCK_PIECE, _
    $GC_I_MODELID_FIRE_ELEMENTAL_POLYMOCK_PIECE, _
    $GC_I_MODELID_FIRE_IMP_POLYMOCK_PIECE, _
    $GC_I_MODELID_GAKI_POLYMOCK_PIECE, _
    $GC_I_MODELID_GARGOYLE_POLYMOCK_PIECE, _
    $GC_I_MODELID_MIRAGE_IBOGA_POLYMOCK_PIECE, _
    $GC_I_MODELID_ICE_ELEMENTAL_POLYMOCK_PIECE, _
    $GC_I_MODELID_ICE_IMP_POLYMOCK_PIECE, _
    $GC_I_MODELID_KAPPA_POLYMOCK_PIECE, _
    $GC_I_MODELID_MANTIS_DREAMWEAVER_POLYMOCK_PIECE, _
    $GC_I_MODELID_MERGOYLE_POLYMOCK_PIECE, _
    $GC_I_MODELID_MURSAAT_ELEMENTALIST_POLYMOCK_PIECE, _
    $GC_I_MODELID_RUBY_DJINN_POLYMOCK_PIECE, _
    $GC_I_MODELID_NAGA_SHAMAN_POLYMOCK_PIECE, _
    $GC_I_MODELID_SKALE_POLYMOCK_PIECE, _
    $GC_I_MODELID_STONE_RAIN_POLYMOCK_PIECE _
]

Global Const $GC_AI_GOLD_POLYMOCK_PIECES[9] = [ 8, _
    $GC_I_MODELID_WIND_RIDER_POLYMOCK_PIECE, _
    $GC_I_MODELID_GAKI_POLYMOCK_PIECE, _
    $GC_I_MODELID_MIRAGE_IBOGA_POLYMOCK_PIECE, _
    $GC_I_MODELID_MANTIS_DREAMWEAVER_POLYMOCK_PIECE, _
    $GC_I_MODELID_MURSAAT_ELEMENTALIST_POLYMOCK_PIECE, _
    $GC_I_MODELID_RUBY_DJINN_POLYMOCK_PIECE, _
    $GC_I_MODELID_NAGA_SHAMAN_POLYMOCK_PIECE, _
    $GC_I_MODELID_STONE_RAIN_POLYMOCK_PIECE _
]

Global Const $GC_AI_PURPLE_POLYMOCK[6] = [ 5, _
    $GC_I_MODELID_ALOE_SEED_POLYMOCK_PIECE, _
    $GC_I_MODELID_EARTH_ELEMENTAL_POLYMOCK_PIECE, _
    $GC_I_MODELID_FIRE_ELEMENTAL_POLYMOCK_PIECE, _
    $GC_I_MODELID_ICE_ELEMENTAL_POLYMOCK_PIECE, _
    $GC_I_MODELID_KAPPA_POLYMOCK_PIECE _
]

Global Const $GC_AI_WHITE_POLYMOCK[6] = [ 5, _
    $GC_I_MODELID_FIRE_IMP_POLYMOCK_PIECE, _
    $GC_I_MODELID_GARGOYLE_POLYMOCK_PIECE, _
    $GC_I_MODELID_ICE_IMP_POLYMOCK_PIECE, _
    $GC_I_MODELID_MERGOYLE_POLYMOCK_PIECE, _
    $GC_I_MODELID_SKALE_POLYMOCK_PIECE _
]
#EndRegion Polymock

#Region Pre searing Trophies
Global Const $GC_I_MODELID_SPIDER_LEG = 422
Global Const $GC_I_MODELID_CHARR_CARVING = 423
Global Const $GC_I_MODELID_ICY_LODESTONE = 424
Global Const $GC_I_MODELID_DULL_CARAPACE = 425
Global Const $GC_I_MODELID_GARGOYLE_SKULL = 426
Global Const $GC_I_MODELID_WORN_BELT = 427
Global Const $GC_I_MODELID_UNNATURAL_SEED = 428
Global Const $GC_I_MODELID_SKALE_FIN_PRE = 429
Global Const $GC_I_MODELID_SKELETAL_LIMB = 430
Global Const $GC_I_MODELID_ENCHANTED_LODESTONE = 431
Global Const $GC_I_MODELID_GRAWL_NECKLACE = 432
Global Const $GC_I_MODELID_BAKED_HUSK = 433
Global Const $GC_I_MODELID_RED_IRIS_FLOWER = 2994

Global Const $GC_AI_All_PRESEARING_TROPHIES[14] = [13, _
    $GC_I_MODELID_SPIDER_LEG, _
    $GC_I_MODELID_CHARR_CARVING, _
    $GC_I_MODELID_ICY_LODESTONE, _
    $GC_I_MODELID_DULL_CARAPACE, _
    $GC_I_MODELID_GARGOYLE_SKULL, _
    $GC_I_MODELID_WORN_BELT, _
    $GC_I_MODELID_UNNATURAL_SEED, _
    $GC_I_MODELID_SKALE_FIN_PRE, _
    $GC_I_MODELID_SKELETAL_LIMB, _
    $GC_I_MODELID_ENCHANTED_LODESTONE, _
    $GC_I_MODELID_GRAWL_NECKLACE, _
    $GC_I_MODELID_BAKED_HUSK, _
    $GC_I_MODELID_RED_IRIS_FLOWER _
]
#EndRegion Pre searing Trophies

#Region Stackable trophies
Global Const $GC_I_MODELID_SPIKED_CREST = 434
Global Const $GC_I_MODELID_HARDENED_HUMP = 435
Global Const $GC_I_MODELID_MERGOYLE_SKULL = 436
Global Const $GC_I_MODELID_GLOWING_HEART = 439
Global Const $GC_I_MODELID_FOREST_MINOTAUR_HORN = 440
Global Const $GC_I_MODELID_SHADOWY_REMNANT = 441
Global Const $GC_I_MODELID_ABNORMAL_SEED = 442
Global Const $GC_I_MODELID_BOG_SKALE_FIN = 443
Global Const $GC_I_MODELID_FEATHERED_CAROMI_SCALP = 444
Global Const $GC_I_MODELID_SHRIVELED_EYE = 446
Global Const $GC_I_MODELID_DUNE_BURROWER_JAW = 447
Global Const $GC_I_MODELID_LOSARU_MANE = 448
Global Const $GC_I_MODELID_BLEACHED_CARAPACE = 449
Global Const $GC_I_MODELID_TOPAZ_CREST = 450
Global Const $GC_I_MODELID_ENCRUSTED_LODESTONE = 451
Global Const $GC_I_MODELID_MASSIVE_JAWBONE = 452
Global Const $GC_I_MODELID_IRIDESCANT_GRIFFON_WING = 453
Global Const $GC_I_MODELID_DESSICATED_HYDRA_CLAW = 454
Global Const $GC_I_MODELID_MINOTAUR_HORN = 455
Global Const $GC_I_MODELID_JADE_MANDIBLE = 457
Global Const $GC_I_MODELID_FORGOTTEN_SEAL = 459
Global Const $GC_I_MODELID_WHITE_MANTLE_EMBLEM = 460
Global Const $GC_I_MODELID_WHITE_MANTLE_BADGE = 461
Global Const $GC_I_MODELID_MURSAAT_TOKEN = 462
Global Const $GC_I_MODELID_EBON_SPIDER_LEG = 463
Global Const $GC_I_MODELID_ANCIENT_EYE = 464
Global Const $GC_I_MODELID_BEHEMOTH_JAW = 465
Global Const $GC_I_MODELID_MAGUUMA_MANE = 466
Global Const $GC_I_MODELID_THORNY_CARAPACE = 467
Global Const $GC_I_MODELID_TANGLED_SEED = 468
Global Const $GC_I_MODELID_MOSSY_MANDIBLE = 469
Global Const $GC_I_MODELID_JUNGLE_SKALE_FIN = 70
Global Const $GC_I_MODELID_JUNGLE_TROLL_TUSK = 471
Global Const $GC_I_MODELID_OBSIDIAN_BURROWER_JAW = 472
Global Const $GC_I_MODELID_DEMONIC_FANG = 473
Global Const $GC_I_MODELID_PHANTOM_RESIDUE = 474
Global Const $GC_I_MODELID_GRUESOME_STERNUM = 475
Global Const $GC_I_MODELID_DEMONIC_REMAINS = 476
Global Const $GC_I_MODELID_STORMY_EYE = 477
Global Const $GC_I_MODELID_SCAR_BEHEMOTH_JAW = 478
Global Const $GC_I_MODELID_FETID_CARAPACE = 479
Global Const $GC_I_MODELID_SINGED_GARGOYLE_SKULL = 480
Global Const $GC_I_MODELID_GRUESOME_RIBCAGE = 482
Global Const $GC_I_MODELID_RAWHIDE_BELT = 483
Global Const $GC_I_MODELID_LEATHERY_CLAW = 484
Global Const $GC_I_MODELID_SCORCHED_SEED = 485
Global Const $GC_I_MODELID_SCORCHED_LODESTONE = 486
Global Const $GC_I_MODELID_ORNATE_GRAWL_NECKLACE = 487
Global Const $GC_I_MODELID_SHIVERPEAK_MANE = 488
Global Const $GC_I_MODELID_FROSTFIRE_FANG = 489
Global Const $GC_I_MODELID_ICY_HUMP = 490
Global Const $GC_I_MODELID_HUGE_JAWBONE = 492
Global Const $GC_I_MODELID_FROSTED_GRIFFON_WING = 493
Global Const $GC_I_MODELID_FRIGID_HEART = 494
Global Const $GC_I_MODELID_CURVED_MINTAUR_HORN = 495
Global Const $GC_I_MODELID_AZURE_REMAINS = 496
Global Const $GC_I_MODELID_ALPINE_SEED = 497
Global Const $GC_I_MODELID_FEATHERED_AVICARA_SCALP = 498
Global Const $GC_I_MODELID_INTRICATE_GRAWL_NECKLACE = 499
Global Const $GC_I_MODELID_MOUNTAIN_TROLL_TUSK = 500
Global Const $GC_I_MODELID_STONE_SUMMIT_BADGE = 502
Global Const $GC_I_MODELID_MOLTEN_CLAW = 503
Global Const $GC_I_MODELID_DECAYED_ORR_EMBLEM = 504
Global Const $GC_I_MODELID_IGNEOUS_SPIDER_LEG = 505
Global Const $GC_I_MODELID_MOLTEN_EYE = 506
Global Const $GC_I_MODELID_FIERY_CREST = 508
Global Const $GC_I_MODELID_IGNEOUS_HUMP = 510
Global Const $GC_I_MODELID_UNCTUOUS_REMAINS = 511
Global Const $GC_I_MODELID_MAHGO_CLAW = 513
Global Const $GC_I_MODELID_MOLTEN_HEART = 514
Global Const $GC_I_MODELID_CORROSIVE_SPIDER_LEG = 518
Global Const $GC_I_MODELID_UMBRAL_EYE = 519
Global Const $GC_I_MODELID_SHADOWY_CREST = 520
Global Const $GC_I_MODELID_DARK_REMAINS = 522
Global Const $GC_I_MODELID_GLOOM_SEED = 523
Global Const $GC_I_MODELID_UMBRAL_SKELETAL_LIMB = 525
Global Const $GC_I_MODELID_SHADOWY_HUSK = 526
Global Const $GC_I_MODELID_ENSLAVEMENT_STONE = 532
Global Const $GC_I_MODELID_KURZICK_BAUBLE = 604
Global Const $GC_I_MODELID_JADE_BRACELET = 809
Global Const $GC_I_MODELID_LUXON_PENDANT = 810
Global Const $GC_I_MODELID_BONE_CHARM = 811
Global Const $GC_I_MODELID_TRUFFLE = 813
Global Const $GC_I_MODELID_SKULL_JUJU = 814
Global Const $GC_I_MODELID_MANTID_PINCER = 815
Global Const $GC_I_MODELID_STONE_HORN = 816
Global Const $GC_I_MODELID_KEEN_ONI_CLAW = 817
Global Const $GC_I_MODELID_DREDGE_INCISOR = 818
Global Const $GC_I_MODELID_DRAGON_ROOT = 819
Global Const $GC_I_MODELID_STONE_CARVING = 820
Global Const $GC_I_MODELID_WARDEN_HORN = 822
Global Const $GC_I_MODELID_PULSATING_GROWTH = 824
Global Const $GC_I_MODELID_FORGOTTEN_TRINKET_BOX = 825
Global Const $GC_I_MODELID_AUGMENTED_FLESH = 826
Global Const $GC_I_MODELID_PUTRID_CYST = 827
Global Const $GC_I_MODELID_MANTIS_PINCER = 829
Global Const $GC_I_MODELID_NAGA_PELT = 833
Global Const $GC_I_MODELID_FEATHERED_CREST = 835
Global Const $GC_I_MODELID_FEATHERED_SCALP = 836
Global Const $GC_I_MODELID_KAPPA_HATCHLING_SHELL = 838
Global Const $GC_I_MODELID_BLACK_PEARL = 841
Global Const $GC_I_MODELID_ROT_WALLOW_TUSK = 842
Global Const $GC_I_MODELID_KRAKEN_EYE = 843
Global Const $GC_I_MODELID_AZURE_CREST = 844
Global Const $GC_I_MODELID_KIRIN_HORN = 846
Global Const $GC_I_MODELID_KEEN_ONI_TALON = 847
Global Const $GC_I_MODELID_NAGA_SKIN = 848
Global Const $GC_I_MODELID_GUARDIAN_MOSS = 849
Global Const $GC_I_MODELID_ARCHAIC_KAPPA_SHELL = 850
Global Const $GC_I_MODELID_STOLEN_PROVISIONS = 851
Global Const $GC_I_MODELID_SOUL_STONE = 852
Global Const $GC_I_MODELID_VERMIN_HIDE = 853
Global Const $GC_I_MODELID_VENERABLE_MANTID_PINCER = 854
Global Const $GC_I_MODELID_CELESTIAL_ESSENCE = 855
Global Const $GC_I_MODELID_MOON_SHELL = 1009
Global Const $GC_I_MODELID_COPPER_SHILLING = 1577
Global Const $GC_I_MODELID_GOLD_DOUBLOON = 1578
Global Const $GC_I_MODELID_SILVER_BULLION_COIN = 1579
Global Const $GC_I_MODELID_DEMONIC_RELIC = 1580
Global Const $GC_I_MODELID_MARGONITE_MASK = 1581
Global Const $GC_I_MODELID_KOURNAN_PENDANT = 1582
Global Const $GC_I_MODELID_MUMMY_WRAPPING = 1583
Global Const $GC_I_MODELID_SANDBLASTED_LODESTONE = 1584
Global Const $GC_I_MODELID_INSCRIBED_SHARD = 1587
Global Const $GC_I_MODELID_DUSTY_INSECT_CARAPACE = 1588
Global Const $GC_I_MODELID_GIANT_TUSK = 1590
Global Const $GC_I_MODELID_INSECT_APPENDAGE = 1597
Global Const $GC_I_MODELID_JUVENILE_TERMITE_LEG = 1598
Global Const $GC_I_MODELID_SENTIENT_ROOT = 1600
Global Const $GC_I_MODELID_SENTIENT_SEED = 1601
Global Const $GC_I_MODELID_SKALE_TOOTH = 1603
Global Const $GC_I_MODELID_SKALE_CLAW = 1604
Global Const $GC_I_MODELID_SKELETON_BONE = 1605
Global Const $GC_I_MODELID_COBALT_TALON = 1609
Global Const $GC_I_MODELID_SKREE_WING = 1610
Global Const $GC_I_MODELID_INSECT_CARAPACE = 1617
Global Const $GC_I_MODELID_SENTIENT_LODESTONE = 1619
Global Const $GC_I_MODELID_IMMOLATED_DJINN_ESSENCE = 1620
Global Const $GC_I_MODELID_ROARING_ETHER_CLAW = 1629
Global Const $GC_I_MODELID_MANDRAGOR_HUSK = 1668
Global Const $GC_I_MODELID_MANDRAGOR_SWAMPROOT = 1671
Global Const $GC_I_MODELID_BEHEMOTH_HIDE = 1675
Global Const $GC_I_MODELID_GEODE = 1681
Global Const $GC_I_MODELID_HUNTING_MINOTAUR_HORN = 1682
Global Const $GC_I_MODELID_MANDRAGOR_ROOT = 1686
Global Const $GC_I_MODELID_IBOGA_PETAL = 19183
Global Const $GC_I_MODELID_SKALE_FIN = 19184
Global Const $GC_I_MODELID_CHUNK_OF_DRAKE_FLESH = 19185
Global Const $GC_I_MODELID_RUBY_DJINN_ESSENCE = 19187
Global Const $GC_I_MODELID_SAPPHIRE_DJINN_ESSENCE = 19188
Global Const $GC_I_MODELID_SENTIENT_SPORE = 19198
Global Const $GC_I_MODELID_HEKET_TONGUE = 19199
Global Const $GC_I_MODELID_GOLDEN_RIN_RELIC = 24354
Global Const $GC_I_MODELID_DESTROYER_CORE = 27033
Global Const $GC_I_MODELID_INCUBUS_WING = 27034
Global Const $GC_I_MODELID_SAURIAN_BONE = 27035
Global Const $GC_I_MODELID_AMPHIBIAN_TONGUE = 27036
Global Const $GC_I_MODELID_WEAVER_LEG = 27037
Global Const $GC_I_MODELID_PATCH_OF_SIMIAN_FUR = 27038
Global Const $GC_I_MODELID_QUETZAL_CREST = 27039
Global Const $GC_I_MODELID_SKELK_CLAW = 27040
Global Const $GC_I_MODELID_SENTIENT_VINE = 27041
Global Const $GC_I_MODELID_FRIGID_MANDRAGOR_HUSK = 27042
Global Const $GC_I_MODELID_MODNIR_MANE = 27043
Global Const $GC_I_MODELID_STONE_SUMMIT_EMBLEM = 27044
Global Const $GC_I_MODELID_JOTUN_PELT = 27045
Global Const $GC_I_MODELID_BERSERKER_HORN = 27046
Global Const $GC_I_MODELID_GLACIAL_STONE = 27047
Global Const $GC_I_MODELID_FROZEN_WURM_HUSK = 27048
Global Const $GC_I_MODELID_MOUNTAIN_ROOT = 27049
Global Const $GC_I_MODELID_PILE_OF_ELEMENTAL_DUST = 27050
Global Const $GC_I_MODELID_SUPERIOR_CHARR_CARVING = 27052
Global Const $GC_I_MODELID_STONE_GRAWL_NECKLACE = 27053
Global Const $GC_I_MODELID_MANTID_UNGULA = 27054
Global Const $GC_I_MODELID_SKALE_FANG = 27055
Global Const $GC_I_MODELID_STONE_CLAW = 27057
Global Const $GC_I_MODELID_SKELK_FANG = 27060
Global Const $GC_I_MODELID_FUNGAL_ROOT = 27061
Global Const $GC_I_MODELID_FLESH_REAVER_MORSEL = 27062
Global Const $GC_I_MODELID_GOLEM_RUNESTONE = 27065
Global Const $GC_I_MODELID_BEETLE_EGG = 27066
Global Const $GC_I_MODELID_BLOB_OF_OOZE = 27067
Global Const $GC_I_MODELID_CHROMATIC_SCALE = 27069
Global Const $GC_I_MODELID_DRYDER_WEB = 27070
Global Const $GC_I_MODELID_VAETTIR_ESSENCE = 27071
Global Const $GC_I_MODELID_KRAIT_SKIN = 27729
Global Const $GC_I_MODELID_UNDEAD_BONE = 27974

Global Const $GC_AI_MONSTER_TROPHIES[188] = [187, _
    $GC_I_MODELID_SPIKED_CREST, _
    $GC_I_MODELID_HARDENED_HUMP, _
    $GC_I_MODELID_MERGOYLE_SKULL, _
    $GC_I_MODELID_GLOWING_HEART, _
    $GC_I_MODELID_FOREST_MINOTAUR_HORN, _
    $GC_I_MODELID_SHADOWY_REMNANT, _
    $GC_I_MODELID_ABNORMAL_SEED, _
    $GC_I_MODELID_BOG_SKALE_FIN, _
    $GC_I_MODELID_FEATHERED_CAROMI_SCALP, _
    $GC_I_MODELID_SHRIVELED_EYE, _
    $GC_I_MODELID_DUNE_BURROWER_JAW, _
    $GC_I_MODELID_LOSARU_MANE, _
    $GC_I_MODELID_BLEACHED_CARAPACE, _
    $GC_I_MODELID_TOPAZ_CREST, _
    $GC_I_MODELID_ENCRUSTED_LODESTONE, _
    $GC_I_MODELID_MASSIVE_JAWBONE, _
    $GC_I_MODELID_IRIDESCANT_GRIFFON_WING, _
    $GC_I_MODELID_DESSICATED_HYDRA_CLAW, _
    $GC_I_MODELID_MINOTAUR_HORN, _
    $GC_I_MODELID_JADE_MANDIBLE, _
    $GC_I_MODELID_FORGOTTEN_SEAL, _
    $GC_I_MODELID_WHITE_MANTLE_EMBLEM, _
    $GC_I_MODELID_WHITE_MANTLE_BADGE, _
    $GC_I_MODELID_MURSAAT_TOKEN, _
    $GC_I_MODELID_EBON_SPIDER_LEG, _
    $GC_I_MODELID_ANCIENT_EYE, _
    $GC_I_MODELID_BEHEMOTH_JAW, _
    $GC_I_MODELID_MAGUUMA_MANE, _
    $GC_I_MODELID_THORNY_CARAPACE, _
    $GC_I_MODELID_TANGLED_SEED, _
    $GC_I_MODELID_MOSSY_MANDIBLE, _
    $GC_I_MODELID_JUNGLE_SKALE_FIN, _
    $GC_I_MODELID_JUNGLE_TROLL_TUSK, _
    $GC_I_MODELID_OBSIDIAN_BURROWER_JAW, _
    $GC_I_MODELID_DEMONIC_FANG, _
    $GC_I_MODELID_PHANTOM_RESIDUE, _
    $GC_I_MODELID_GRUESOME_STERNUM, _
    $GC_I_MODELID_DEMONIC_REMAINS, _
    $GC_I_MODELID_STORMY_EYE, _
    $GC_I_MODELID_SCAR_BEHEMOTH_JAW, _
    $GC_I_MODELID_FETID_CARAPACE, _
    $GC_I_MODELID_SINGED_GARGOYLE_SKULL, _
    $GC_I_MODELID_GRUESOME_RIBCAGE, _
    $GC_I_MODELID_RAWHIDE_BELT, _
    $GC_I_MODELID_LEATHERY_CLAW, _
    $GC_I_MODELID_SCORCHED_SEED, _
    $GC_I_MODELID_SCORCHED_LODESTONE, _
    $GC_I_MODELID_ORNATE_GRAWL_NECKLACE, _
    $GC_I_MODELID_SHIVERPEAK_MANE, _
    $GC_I_MODELID_FROSTFIRE_FANG, _
    $GC_I_MODELID_ICY_HUMP, _
    $GC_I_MODELID_HUGE_JAWBONE, _
    $GC_I_MODELID_FROSTED_GRIFFON_WING, _
    $GC_I_MODELID_FRIGID_HEART, _
    $GC_I_MODELID_CURVED_MINTAUR_HORN, _
    $GC_I_MODELID_AZURE_REMAINS, _
    $GC_I_MODELID_ALPINE_SEED, _
    $GC_I_MODELID_FEATHERED_AVICARA_SCALP, _
    $GC_I_MODELID_INTRICATE_GRAWL_NECKLACE, _
    $GC_I_MODELID_MOUNTAIN_TROLL_TUSK, _
    $GC_I_MODELID_STONE_SUMMIT_BADGE, _
    $GC_I_MODELID_MOLTEN_CLAW, _
    $GC_I_MODELID_DECAYED_ORR_EMBLEM, _
    $GC_I_MODELID_IGNEOUS_SPIDER_LEG, _
    $GC_I_MODELID_MOLTEN_EYE, _
    $GC_I_MODELID_FIERY_CREST, _
    $GC_I_MODELID_IGNEOUS_HUMP, _
    $GC_I_MODELID_UNCTUOUS_REMAINS, _
    $GC_I_MODELID_MAHGO_CLAW, _
    $GC_I_MODELID_MOLTEN_HEART, _
    $GC_I_MODELID_CORROSIVE_SPIDER_LEG, _
    $GC_I_MODELID_UMBRAL_EYE, _
    $GC_I_MODELID_SHADOWY_CREST, _
    $GC_I_MODELID_DARK_REMAINS, _
    $GC_I_MODELID_GLOOM_SEED, _
    $GC_I_MODELID_UMBRAL_SKELETAL_LIMB, _
    $GC_I_MODELID_SHADOWY_HUSK, _
    $GC_I_MODELID_ENSLAVEMENT_STONE, _
    $GC_I_MODELID_KURZICK_BAUBLE, _
    $GC_I_MODELID_JADE_BRACELET, _
    $GC_I_MODELID_LUXON_PENDANT, _
    $GC_I_MODELID_BONE_CHARM, _
    $GC_I_MODELID_TRUFFLE, _
    $GC_I_MODELID_SKULL_JUJU, _
    $GC_I_MODELID_MANTID_PINCER, _
    $GC_I_MODELID_STONE_HORN, _
    $GC_I_MODELID_KEEN_ONI_CLAW, _
    $GC_I_MODELID_DREDGE_INCISOR, _
    $GC_I_MODELID_DRAGON_ROOT, _
    $GC_I_MODELID_STONE_CARVING, _
    $GC_I_MODELID_WARDEN_HORN, _
    $GC_I_MODELID_PULSATING_GROWTH, _
    $GC_I_MODELID_FORGOTTEN_TRINKET_BOX, _
    $GC_I_MODELID_AUGMENTED_FLESH, _
    $GC_I_MODELID_PUTRID_CYST, _
    $GC_I_MODELID_MANTIS_PINCER, _
    $GC_I_MODELID_NAGA_PELT, _
    $GC_I_MODELID_FEATHERED_CREST, _
    $GC_I_MODELID_FEATHERED_SCALP, _
    $GC_I_MODELID_KAPPA_HATCHLING_SHELL, _
    $GC_I_MODELID_BLACK_PEARL, _
    $GC_I_MODELID_ROT_WALLOW_TUSK, _
    $GC_I_MODELID_KRAKEN_EYE, _
    $GC_I_MODELID_AZURE_CREST, _
    $GC_I_MODELID_KIRIN_HORN, _
    $GC_I_MODELID_KEEN_ONI_TALON, _
    $GC_I_MODELID_NAGA_SKIN, _
    $GC_I_MODELID_GUARDIAN_MOSS, _
    $GC_I_MODELID_ARCHAIC_KAPPA_SHELL, _
    $GC_I_MODELID_STOLEN_PROVISIONS, _
    $GC_I_MODELID_SOUL_STONE, _
    $GC_I_MODELID_VERMIN_HIDE, _
    $GC_I_MODELID_VENERABLE_MANTID_PINCER, _
    $GC_I_MODELID_CELESTIAL_ESSENCE, _
    $GC_I_MODELID_MOON_SHELL, _
    $GC_I_MODELID_COPPER_SHILLING, _
    $GC_I_MODELID_GOLD_DOUBLOON, _
    $GC_I_MODELID_SILVER_BULLION_COIN, _
    $GC_I_MODELID_DEMONIC_RELIC, _
    $GC_I_MODELID_MARGONITE_MASK, _
    $GC_I_MODELID_KOURNAN_PENDANT, _
    $GC_I_MODELID_MUMMY_WRAPPING, _
    $GC_I_MODELID_SANDBLASTED_LODESTONE, _
    $GC_I_MODELID_INSCRIBED_SHARD, _
    $GC_I_MODELID_DUSTY_INSECT_CARAPACE, _
    $GC_I_MODELID_GIANT_TUSK, _
    $GC_I_MODELID_INSECT_APPENDAGE, _
    $GC_I_MODELID_JUVENILE_TERMITE_LEG, _
    $GC_I_MODELID_SENTIENT_ROOT, _
    $GC_I_MODELID_SENTIENT_SEED, _
    $GC_I_MODELID_SKALE_TOOTH, _
    $GC_I_MODELID_SKALE_CLAW, _
    $GC_I_MODELID_SKELETON_BONE, _
    $GC_I_MODELID_COBALT_TALON, _
    $GC_I_MODELID_SKREE_WING, _
    $GC_I_MODELID_INSECT_CARAPACE, _
    $GC_I_MODELID_SENTIENT_LODESTONE, _
    $GC_I_MODELID_IMMOLATED_DJINN_ESSENCE, _
    $GC_I_MODELID_ROARING_ETHER_CLAW, _
    $GC_I_MODELID_MANDRAGOR_HUSK, _
    $GC_I_MODELID_MANDRAGOR_SWAMPROOT, _
    $GC_I_MODELID_BEHEMOTH_HIDE, _
    $GC_I_MODELID_GEODE, _
    $GC_I_MODELID_HUNTING_MINOTAUR_HORN, _
    $GC_I_MODELID_MANDRAGOR_ROOT, _
    $GC_I_MODELID_IBOGA_PETAL, _
    $GC_I_MODELID_SKALE_FIN, _
    $GC_I_MODELID_CHUNK_OF_DRAKE_FLESH, _
    $GC_I_MODELID_RUBY_DJINN_ESSENCE, _
    $GC_I_MODELID_SAPPHIRE_DJINN_ESSENCE, _
    $GC_I_MODELID_SENTIENT_SPORE, _
    $GC_I_MODELID_HEKET_TONGUE, _
    $GC_I_MODELID_GOLDEN_RIN_RELIC, _
    $GC_I_MODELID_DESTROYER_CORE, _
    $GC_I_MODELID_INCUBUS_WING, _
    $GC_I_MODELID_SAURIAN_BONE, _
    $GC_I_MODELID_AMPHIBIAN_TONGUE, _
    $GC_I_MODELID_WEAVER_LEG, _
    $GC_I_MODELID_PATCH_OF_SIMIAN_FUR, _
    $GC_I_MODELID_QUETZAL_CREST, _
    $GC_I_MODELID_SKELK_CLAW, _
    $GC_I_MODELID_SENTIENT_VINE, _
    $GC_I_MODELID_FRIGID_MANDRAGOR_HUSK, _
    $GC_I_MODELID_MODNIR_MANE, _
    $GC_I_MODELID_STONE_SUMMIT_EMBLEM, _
    $GC_I_MODELID_JOTUN_PELT, _
    $GC_I_MODELID_BERSERKER_HORN, _
    $GC_I_MODELID_GLACIAL_STONE, _
    $GC_I_MODELID_FROZEN_WURM_HUSK, _
    $GC_I_MODELID_MOUNTAIN_ROOT, _
    $GC_I_MODELID_PILE_OF_ELEMENTAL_DUST, _
    $GC_I_MODELID_SUPERIOR_CHARR_CARVING, _
    $GC_I_MODELID_STONE_GRAWL_NECKLACE, _
    $GC_I_MODELID_MANTID_UNGULA, _
    $GC_I_MODELID_SKALE_FANG, _
    $GC_I_MODELID_STONE_CLAW, _
    $GC_I_MODELID_SKELK_FANG, _
    $GC_I_MODELID_FUNGAL_ROOT, _
    $GC_I_MODELID_FLESH_REAVER_MORSEL, _
    $GC_I_MODELID_GOLEM_RUNESTONE, _
    $GC_I_MODELID_BEETLE_EGG, _
    $GC_I_MODELID_BLOB_OF_OOZE, _
    $GC_I_MODELID_CHROMATIC_SCALE, _
    $GC_I_MODELID_DRYDER_WEB, _
    $GC_I_MODELID_VAETTIR_ESSENCE, _
    $GC_I_MODELID_KRAIT_SKIN, _
    $GC_I_MODELID_UNDEAD_BONE _
]
#EndRegion Stackable trophies


