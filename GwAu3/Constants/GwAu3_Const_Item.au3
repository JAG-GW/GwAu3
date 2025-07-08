#include-once

#Region Inventory
; Inventory Array
Global Enum _
    $GC_I_INVENTORY_PTR = 0, _
    $GC_I_INVENTORY_ITEMID, _
    $GC_I_INVENTORY_BAG, _
    $GC_I_INVENTORY_ITEMTYPE, _
    $GC_I_INVENTORY_EXTRAID, _
    $GC_I_INVENTORY_VALUE, _
    $GC_I_INVENTORY_ISIDENTIFIED, _
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

#include-once

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
Global Const $GC_S_MOD_SHIELD_PLUS_DEMONS 						= "A0848210"	; +10vs Demons
Global Const $GC_S_MOD_SHIELD_PLUS_DRAGONS 						= "A0948210"	; +10vs Dragons
Global Const $GC_S_MOD_SHIELD_PLUS_PLANTS 						= "A0348210"	; +10vs Plants
Global Const $GC_S_MOD_SHIELD_PLUS_UNDEAD 						= "A0048210"	; +10vs Undead
Global Const $GC_S_MOD_SHIELD_PLUS_TENGU 						= "A0748210"	; +10vs Tengu
Global Const $GC_S_MOD_SHIELD_PLUS_CHARR 						= "0A014821"	; +10vs Charr
Global Const $GC_S_MOD_SHIELD_PLUS_TROLLS 						= "0A024821"	; +10vs Trolls
Global Const $GC_S_MOD_SHIELD_PLUS_SKELETONS 					= "0A044821"	; +10vs Skeletons
Global Const $GC_S_MOD_SHIELD_PLUS_GIANTS 						= "0A054821"	; +10vs Giants
Global Const $GC_S_MOD_SHIELD_PLUS_DWARVES 						= "0A064821"	; +10vs Dwarves
Global Const $GC_S_MOD_SHIELD_PLUS_OGRES 						= "0A0A4821"	; +10vs Ogres
; +10vs Dmg - Elemental
Global Const $GC_S_MOD_SHIELD_PLUS_LIGHTNING 					= "A0418210"	; +10vs Lightning
Global Const $GC_S_MOD_SHIELD_PLUS_VS_EARTH 					= "A0B18210"	; +10vs Earth
Global Const $GC_S_MOD_SHIELD_PLUS_COLD 						= "A0318210"	; +10vs Cold
Global Const $GC_S_MOD_SHIELD_PLUS_VS_FIRE 						= "A0518210"	; +10vs Fire
; +10vs Dmg -Physical
Global Const $GC_S_MOD_SHIELD_PLUS_PIERCING 					= "A0118210"	; +10vs Piercing
Global Const $GC_S_MOD_SHIELD_PLUS_BLUNT 						= "A0018210"	; +10vs Blunt
Global Const $GC_S_MOD_SHIELD_PLUS_SLASHING 					= "A0218210"	; +10vs Slashing
; +20 vs Conditions
Global Const $GC_S_MOD_SHIELD_VS_BLIND 							= "DF017824"	; +20%vs Blind

; Staff
;Generic 10% HCT
Global Const $GC_S_MOD_STAFF_ALL10_CAST 						= "A0822"		; 10% HCT
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
Global Const $GC_S_MOD_CASTER_PLUS_FIVE 						= "5320823"		; +5^50
Global Const $GC_S_MOD_CASTER_PLUS_FIVE_ENCH 					= "500F822"		; +5wEnch
Global Const $GC_S_MOD_CASTER_ALL10_CAST 						= "000A0822"	; 10% cast
Global Const $GC_S_MOD_CASTER_ALL10_RECHARGE 					= "000AA823"	; 10% recharge
Global Const $GC_S_MOD_CASTER_ENERGY_ALWAYS15 					= "0F00D822"	; Energy +15
Global Const $GC_S_MOD_CASTER_ENERGY_REGEN 						= "0100C820"	; Energy regeneration -1
Global Const $GC_S_MOD_CASTER_PLUS30 							= "001E4823"	; +30HP
; Mes mods
Global Const $GC_S_MOD_CASTER_FAST_CASTING20_RECHARGE 			= "00149823"	; 20% fast casting
Global Const $GC_S_MOD_CASTER_FAST_CASTING20_CASTING 			= "00141822"	; 20% fast casting recharge
Global Const $GC_S_MOD_CASTER_ILLUSION20_RECHARGE 				= "01149823"	; 20% illusion
Global Const $GC_S_MOD_CASTER_ILLUSION20_CASTING 				= "01141822"	; 20% illusion recharge
Global Const $GC_S_MOD_CASTER_DOMINATION20_CASTING 				= "02141822"	; 20% domination
Global Const $GC_S_MOD_CASTER_DOMINATION20_RECHARGE 			= "02149823"	; 20% domination recharge
Global Const $GC_S_MOD_CASTER_INSPIRATION20_RECHARGE 			= "03149823"	; 20% inspiration
Global Const $GC_S_MOD_CASTER_INSPIRATION20_CASTING 			= "03141822"	; 20% inspiration recharge
; Necro mods
Global Const $GC_S_MOD_CASTER_DEATH20_CASTING 					= "05141822"	; 20% death
Global Const $GC_S_MOD_CASTER_DEATH20_RECHARGE 					= "05149823"	; 20% death recharge
Global Const $GC_S_MOD_CASTER_BLOOD20_RECHARGE 					= "04149823"	; 20% blood
Global Const $GC_S_MOD_CASTER_BLOOD20_CASTING 					= "04141822"	; 20% blood recharge
Global Const $GC_S_MOD_CASTER_SOUL_REAP20_RECHARGE 				= "06149823"	; 20% soul reaping
Global Const $GC_S_MOD_CASTER_SOUL_REAP20_CASTING 				= "06141822"	; 20% soul reaping recharge
Global Const $GC_S_MOD_CASTER_CURSES20_RECHARGE 				= "07149823"	; 20% curses
Global Const $GC_S_MOD_CASTER_CURSES20_CASTING 					= "07141822"	; 20% curses recharge
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
Global Const $GC_S_MOD_MESMER_ARTIFICER 						= "E2010824"	; Artificer Insignia
Global Const $GC_S_MOD_MESMER_PRODIGY 							= "E3010824"	; Prodigy Insignia
Global Const $GC_S_MOD_MESMER_VIRTUOSO 							= "E4010824"	; Virtuoso	Insignia

Global Const $GC_S_MOD_MESMER_MINOR_FAST_CASTING 				= "0100E821"	; Minor FastCasting Rune
Global Const $GC_S_MOD_MESMER_MINOR_ILLUSION_MAGIC 				= "0101E821"	; Minor IllusionMagic Rune
Global Const $GC_S_MOD_MESMER_MINOR_DOMINATION_MAGIC 			= "0102E821"	; Minor DominationMagic Rune
Global Const $GC_S_MOD_MESMER_MINOR_INSPIRATION_MAGIC 			= "0103E821"	; Minor InspirationMagic Rune
Global Const $GC_S_MOD_MESMER_MAJOR_FAST_CASTING 				= "0200E821"	; Major FastCasting Rune
Global Const $GC_S_MOD_MESMER_MAJOR_ILLUSION_MAGIC 				= "0201E821"	; Major IllusionMagic Rune
Global Const $GC_S_MOD_MESMER_MAJOR_DOMINATION_MAGIC 			= "0202E821"	; Major DominationMagic Rune
Global Const $GC_S_MOD_MESMER_MAJOR_INSPIRATION_MAGIC 			= "0203E821"	; Major InspirationMagic Rune
Global Const $GC_S_MOD_MESMER_SUPERIOR_FAST_CASTING 			= "0300E821"	; Superior FastCasting Rune
Global Const $GC_S_MOD_MESMER_SUPERIOR_ILLUSION_MAGIC 			= "0301E821"	; Superior IllusionMagic Rune
Global Const $GC_S_MOD_MESMER_SUPERIOR_DOMINATION_MAGIC 		= "0302E821"	; Superior DominationMagic Rune
Global Const $GC_S_MOD_MESMER_SUPERIOR_INSPIRATION_MAGIC 		= "0303E821"	; Superior InspirationMagic Rune

; Necromancer
Global Const $GC_S_MOD_NECROMANCER_TORMENTOR 					= "EC010824"	; Tormentor Insignia
Global Const $GC_S_MOD_NECROMANCER_UNDERTAKER 					= "ED010824"	; Undertaker Insignia
Global Const $GC_S_MOD_NECROMANCER_BONELACE 					= "EE010824"	; Bonelace Insignia
Global Const $GC_S_MOD_NECROMANCER_MINION_MASTER 				= "EF010824"	; MinionMaster Insignia
Global Const $GC_S_MOD_NECROMANCER_BLIGHTER 					= "F0010824"	; Blighter Insignia
Global Const $GC_S_MOD_NECROMANCER_BLOODSTAINED 				= "0A020824"	; Bloodstained Insignia

Global Const $GC_S_MOD_NECROMANCER_MINOR_BLOOD_MAGIC 			= "0104E821"	; Minor BloodMagic Rune
Global Const $GC_S_MOD_NECROMANCER_MINOR_DEATH_MAGIC 			= "0105E821"	; Minor DeathMagic Rune
Global Const $GC_S_MOD_NECROMANCER_MINOR_SOUL_REAPING 			= "0106E821"	; Minor SoulReaping Rune
Global Const $GC_S_MOD_NECROMANCER_MINOR_CURSES		 			= "0107E821"	; Minor Curses Rune
Global Const $GC_S_MOD_NECROMANCER_MAJOR_BLOOD_MAGIC 			= "0204E821"	; Major BloodMagic Rune
Global Const $GC_S_MOD_NECROMANCER_MAJOR_DEATH_MAGIC 			= "0205E821"	; Major DeathMagic Rune
Global Const $GC_S_MOD_NECROMANCER_MAJOR_SOUL_REAPING 			= "0206E821"	; Major SoulReaping Rune
Global Const $GC_S_MOD_NECROMANCER_MAJOR_CURSES		 			= "0207E821"	; Major Curses Rune
Global Const $GC_S_MOD_NECROMANCER_SUPERIOR_BLOOD_MAGIC 		= "0304E821"	; Superior BloodMagic Rune
Global Const $GC_S_MOD_NECROMANCER_SUPERIOR_DEATH_MAGIC  		= "0305E821"	; Superior DeathMagic Rune
Global Const $GC_S_MOD_NECROMANCER_SUPERIOR_SOUL_REAPING	 	= "0306E821"	; Superior SoulReaping Rune
Global Const $GC_S_MOD_NECROMANCER_SUPERIOR_CURSES			 	= "0307E821"	; Superior Curses Rune
 
; Elementalist
Global Const $GC_S_MOD_ELEMENTALIST_PRISMATIC 					= "F1010824"	; Prismatic Insignia
Global Const $GC_S_MOD_ELEMENTALIST_HYDROMANCER 				= "F2010824"	; Hydromancer Insignia
Global Const $GC_S_MOD_ELEMENTALIST_GEOMANCER 					= "F3010824"	; Geomancer Insignia
Global Const $GC_S_MOD_ELEMENTALIST_PYROMANCER 					= "F4010824"	; Pyromancer Insignia
Global Const $GC_S_MOD_ELEMENTALIST_AEROMANCER 					= "F5010824"	; Aeromancer Insignia

Global Const $GC_S_MOD_WARRIOR_MINOR_AIR_MAGIC					= "0108E821"	; Minor AirMagic Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_EARTH_MAGIC				= "0109E821"	; Minor EarthMagic Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_FIRE_MAGIC					= "010AE821"	; Minor FireMagic Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_WATER_MAGIC 				= "010BE821"	; Minor WaterMagic Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_ENERGY_STORAGE 			= "010CE821"	; Minor EnergyStorage Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_AIR_MAGIC					= "0208E821"	; Major AirMagic Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_EARTH_MAGIC				= "0209E821"	; Major EarthMagic Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_FIRE_MAGIC 				= "020AE821"	; Major FireMagic Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_WATER_MAGIC				= "020BE821"	; Major WaterMagic Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_ENERGY_STORAGE 			= "020CE821"	; Major EnergyStorage Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_AIR_MAGIC 				= "0308E821"	; Superior AirMagic Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_EARTH_MAGIC				= "0309E821"	; Superior EarthMagic Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_FIRE_MAGIC 				= "030AE821"	; Superior FireMagic Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_WATER_MAGIC 			= "030BE821"	; Superior WaterMagic Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_ENERGY_STORAGE 			= "030CE821"	; Superior EnergyStorage Rune

; Monk
Global Const $GC_S_MOD_MONK_WANDERER 							= "F6010824"	; Wanderer Insignia
Global Const $GC_S_MOD_MONK_DISCIPLE 							= "F7010824"	; Disciple Insignia
Global Const $GC_S_MOD_MONK_ANCHORITE 							= "F8010824"	; Anchorite Insignia

Global Const $GC_S_MOD_MONK_MINOR_HEALING_PRAYERS 				= "010DE821"	; Minor HealingPrayers Rune
Global Const $GC_S_MOD_MONK_MINOR_SMITING_PRAYERS 				= "010EE821"	; Minor SmitingPrayers Rune
Global Const $GC_S_MOD_MONK_MINOR_PROTECTION_PRAYERS 			= "010FE821"	; Minor ProtectionPrayers Rune
Global Const $GC_S_MOD_MONK_MINOR_DIVINE_FAVOR		 			= "0110E821"	; Minor DivineFavor Rune
Global Const $GC_S_MOD_MONK_MAJOR_HEALING_PRAYERS				= "020DE821"	; Major HealingPrayers Rune
Global Const $GC_S_MOD_MONK_MAJOR_MINOR_SMITING_PRAYERS			= "020EE821"	; Major SmitingPrayers Rune
Global Const $GC_S_MOD_MONK_MAJOR_PROTECTION_PRAYERSC 			= "020FE821"	; Major ProtectionPrayers Rune
Global Const $GC_S_MOD_MONK_MAJOR_DIVINE_FAVOR 					= "0210E821"	; Major DivineFavor Rune
Global Const $GC_S_MOD_MONK_SUPERIOR_HEALING_PRAYERS 			= "030DE821"	; Superior HealingPrayers Rune
Global Const $GC_S_MOD_MONK_SUPERIOR_MINOR_SMITING_PRAYERS 		= "030EE821"	; Superior SmitingPrayers Rune
Global Const $GC_S_MOD_MONK_SUPERIOR_PROTECTION_PRAYERS 		= "030FE821"	; Superior ProtectionPrayers Rune
Global Const $GC_S_MOD_MONK_SUPERIOR_DIVINE_FAVOR 				= "0310E821"	; Superior DivineFavor Rune

; Warrior
Global Const $GC_S_MOD_WARRIOR_KNIGHT 							= "F9010824"	; Knight Insignia
Global Const $GC_S_MOD_WARRIOR_DREADNOUGHT 						= "FA010824"	; Dreadnought Insignia
Global Const $GC_S_MOD_WARRIOR_SENTINEL 						= "FB010824"	; Sentinel Insignia
Global Const $GC_S_MOD_WARRIOR_LIEUTENANT 						= "08020824"	; Lieutenant Insignia
Global Const $GC_S_MOD_WARRIOR_STONEFIST 						= "09020824"	; Stonefist Insignia

Global Const $GC_S_MOD_WARRIOR_MINOR_ABSORPTION 				= "FC000824"	; Minor Absorption Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_ABSORPTION 				= "FD000824"	; Major Absorption Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_ABSORPTION 				= "FE000824"	; Superior Absorption Rune

Global Const $GC_S_MOD_WARRIOR_MINOR_STRENGHT 					= "0111E821"	; Minor Strenght Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_AXE_MASTERY 				= "0112E821"	; Minor AxeMastery Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_HAMMER_MASTERY 			= "0113E821"	; Minor HammerMastery Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_SWORDSMANSHIP 				= "0114E821"	; Minor Swordsmanship Rune
Global Const $GC_S_MOD_WARRIOR_MINOR_TACTICS 					= "0115E821"	; Minor Tactics Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_STRENGHT 					= "0211E821"	; Major Strenght Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_AXE_MASTERY 				= "0212E821"	; Major AxeMastery Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_HAMMER_MASTERY 			= "0213E821"	; Major HammerMastery Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_SWORDSMANSHIP 				= "0214E821"	; Major Swordsmanship Rune
Global Const $GC_S_MOD_WARRIOR_MAJOR_TACTICS 					= "0215E821"	; Major Tactics Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_STRENGHT 				= "0311E821"	; Superior Strenght Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_AXE_MASTERY 			= "0312E821"	; Superior AxeMastery Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_HAMMER_MASTERY 			= "0313E821"	; Superior HammerMastery Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_SWORDSMANSHIP 			= "0314E821"	; Superior Swordsmanship Rune
Global Const $GC_S_MOD_WARRIOR_SUPERIOR_TACTICS 				= "0315E821"	; Superior Tactics Rune

; Ranger
Global Const $GC_S_MOD_RANGER_FROSTBOUND 						= "FC010824"	; Frostbound Insignia
Global Const $GC_S_MOD_RANGER_EARTHBOUND 						= "FD010824"	; Earthbound Insignia
Global Const $GC_S_MOD_RANGER_PYREBOUND 						= "FE010824"	; Pyrebound Insignia
Global Const $GC_S_MOD_RANGER_STORMBOUND 						= "FF010824"	; Stormbound Insignia
Global Const $GC_S_MOD_RANGER_BEASTMASTER 						= "00020824"	; Beastmaster Insignia
Global Const $GC_S_MOD_RANGER_SCOUT 							= "01020824"	; Scout Insignia

Global Const $GC_S_MOD_RANGER_MINOR_BEAST_MASTERY 				= "0116E821"	; Minor BeastMastery Rune
Global Const $GC_S_MOD_RANGER_MINOR_EXPERTISE 					= "0117E821"	; Minor Expertise Rune
Global Const $GC_S_MOD_RANGER_MINOR_WILDERNESS_SURVIVAL 		= "0118E821"	; Minor WildernessSurvival Rune
Global Const $GC_S_MOD_RANGER_MINOR_MARKSMANSHIP 				= "0119E821"	; Minor Marksmanship Rune
Global Const $GC_S_MOD_RANGER_MAJOR_BEAST_MASTERY 				= "0216E821"	; Major BeastMastery Rune
Global Const $GC_S_MOD_RANGER_MAJOR_EXPERTISE 					= "0217E821"	; Major Expertise Rune
Global Const $GC_S_MOD_RANGER_MAJOR_WILDERNESS_SURVIVAL 		= "0218E821"	; Major WildernessSurvival Rune
Global Const $GC_S_MOD_RANGER_MAJOR_MARKSMANSHIP 				= "0219E821"	; Major Marksmanship Rune
Global Const $GC_S_MOD_RANGER_SUPERIOR_BEAST_MASTERY 			= "0316E821"	; Superior BeastMastery Rune
Global Const $GC_S_MOD_RANGER_SUPERIOR_EXPERTISE 				= "0317E821"	; Superior Expertise Rune
Global Const $GC_S_MOD_RANGER_SUPERIOR_WILDERNESS_SURVIVAL 		= "0318E821"	; Superior WildernessSurvival Rune
Global Const $GC_S_MOD_RANGER_SUPERIOR_MARKSMANSHIP 			= "0319E821"	; Superior Marksmanship Rune

; Assassin
Global Const $GC_S_MOD_ASSASSIN_VANGUARD 						= "DE010824"	; Vanguard Insignia
Global Const $GC_S_MOD_ASSASSIN_INFILTRATOR 					= "DF010824"	; Infiltrator Insignia
Global Const $GC_S_MOD_ASSASSIN_SABOTEUR 						= "E0010824"	; Saboteur Insignia
Global Const $GC_S_MOD_ASSASSIN_NIGHTSTALKER 					= "E1010824"	; Nightstalker Insignia

Global Const $GC_S_MOD_ASSASSIN_MINOR_DAGGER_MASTERY 			= "011DE821"	; Minor DaggerMastery Rune
Global Const $GC_S_MOD_ASSASSIN_MINOR_DEADLY_ARTS				= "011EE821"	; Minor DeadlyArts Rune
Global Const $GC_S_MOD_ASSASSIN_MINOR_SHADOW_ARTS 				= "011FE821"	; Minor ShadowArts Rune
Global Const $GC_S_MOD_ASSASSIN_MINOR_CRITICAL_STRIKES 			= "0123E821"	; Minor CriticalStrikes Rune
Global Const $GC_S_MOD_ASSASSIN_MAJOR_DAGGER_MASTERY 			= "021DE821"	; Major DaggerMastery Rune
Global Const $GC_S_MOD_ASSASSIN_MAJOR_DEADLY_ART 				= "021EE821"	; Major DeadlyArts Rune
Global Const $GC_S_MOD_ASSASSIN_MAJOR_SHADOW_ARTS 				= "021FE821"	; Major ShadowArts Rune
Global Const $GC_S_MOD_ASSASSIN_MAJOR_CRITICAL_STRIKES 			= "0223E821"	; Major CriticalStrikes Rune
Global Const $GC_S_MOD_ASSASSIN_SUPERIOR_DAGGER_MASTERY 		= "031DE821"	; Superior DaggerMastery Rune
Global Const $GC_S_MOD_ASSASSIN_SUPERIOR_DEADLY_ART				= "031EE821"	; Superior DeadlyArts Rune
Global Const $GC_S_MOD_ASSASSIN_SUPERIOR_SHADOW_ARTS 			= "031FE821"	; Superior ShadowArts Rune
Global Const $GC_S_MOD_ASSASSIN_SUPERIOR_CRITICAL_STRIKES 		= "0323E821"	; Superior CriticalStrikes Rune

; Ritualist
Global Const $GC_S_MOD_RITUALIST_SHAMAN 						= "04020824"	; Shaman Insignia
Global Const $GC_S_MOD_RITUALIST_GHOST_FORGE 					= "05020824"	; GhostForge Insignia
Global Const $GC_S_MOD_RITUALIST_MYSTIC 						= "06020824"	; Mystic Insignia

Global Const $GC_S_MOD_RITUALIST_MINOR_COMMUNING 				= "0120E821"	; Minor Communing Rune
Global Const $GC_S_MOD_RITUALIST_MINOR_RESTORATION_MAGIC 		= "0121E821"	; Minor RestorationMagic Rune
Global Const $GC_S_MOD_RITUALIST_MINOR_CHANNELING_MAGIC 		= "0122E821"	; Minor ChannelingMagic Rune
Global Const $GC_S_MOD_RITUALIST_MINOR_SPAWNING_POWER 			= "0124E821"	; Minor SpawningPower Rune
Global Const $GC_S_MOD_RITUALIST_MAJOR_COMMUNING 				= "0220E821"	; Major Communing Rune
Global Const $GC_S_MOD_RITUALIST_MAJOR_RESTORATION_MAGIC 		= "0221E821"	; Major RestorationMagic Rune
Global Const $GC_S_MOD_RITUALIST_MAJOR_CHANNELING_MAGIC 		= "0222E821"	; Major ChannelingMagic Rune
Global Const $GC_S_MOD_RITUALIST_MAJOR_SPAWNING_POWER 			= "0224E821"	; Major SpawningPower 
Global Const $GC_S_MOD_RITUALIST_SUPERIOR_COMMUNING 			= "0320E821"	; Superior Communing Rune
Global Const $GC_S_MOD_RITUALIST_SUPERIOR_RESTORATION_MAGIC 	= "0321E821"	; Superior RestorationMagic Rune
Global Const $GC_S_MOD_RITUALIST_SUPERIOR_CHANNELING_MAGIC 		= "0322E821"	; Superior ChannelingMagic Rune
Global Const $GC_S_MOD_RITUALIST_SUPERIOR_SPAWNING_POWER 		= "0324E821"	; Superior SpawningPower Rune

; Paragon
Global Const $GC_S_MOD_PARAGON_CENTURION						= "07020824"	; Centurion	Insignia

Global Const $GC_S_MOD_PARAGON_MINOR_SPEAR_MASTERY				= "0125E821"	; Minor SpearMastery Rune
Global Const $GC_S_MOD_PARAGON_MINOR_COMMAND 					= "0126E821"	; Minor Command Rune
Global Const $GC_S_MOD_PARAGON_MINOR_MOTIVATION 				= "0127E821"	; Minor Motivation Rune
Global Const $GC_S_MOD_PARAGON_MINOR_LEADERSHIP					= "0128E821"	; Minor Leadership Rune
Global Const $GC_S_MOD_PARAGON_MAJOR_SPEAR_MASTERY				= "0225E821"	; Major SpearMastery Rune
Global Const $GC_S_MOD_PARAGON_MAJOR_COMMAND  					= "0226E821"	; Major Command Rune
Global Const $GC_S_MOD_PARAGON_MAJOR_MOTIVATION 				= "0227E821"	; Major Motivation Rune
Global Const $GC_S_MOD_PARAGON_MAJOR_LEADERSHIP 				= "0228E821"	; Major Leadership Rune
Global Const $GC_S_MOD_PARAGON_SUPERIOR_SPEAR_MASTERY	 		= "0325E821"	; Superior SpearMastery Rune
Global Const $GC_S_MOD_PARAGON_SUPERIOR_COMMAND  				= "0326E821"	; Superior Command Rune
Global Const $GC_S_MOD_PARAGON_SUPERIOR_MOTIVATION 				= "0327E821"	; Superior Motivation Rune
Global Const $GC_S_MOD_PARAGON_SUPERIOR_LEADERSHIP 				= "0328E821"	; Superior Leadership Rune

; Dervish
Global Const $GC_S_MOD_DERVISH_WINDWALKER						= "02020824"	; Windwalker Insignia
Global Const $GC_S_MOD_DERVISH_FORSAKEN							= "03020824"	; Forsaken Insignia

Global Const $GC_S_MOD_DERVISH_MINOR_SCYTHE_MASTERY				= "0129E821"	; Minor ScytheMastery Rune
Global Const $GC_S_MOD_DERVISH_MINOR_WIND_PRAYERS 				= "012AE821"	; Minor WindPrayers Rune
Global Const $GC_S_MOD_DERVISH_MINOR_EARTH_PRAYERS				= "012BE821"	; Minor EarthPrayers Rune
Global Const $GC_S_MOD_DERVISH_MINOR_MYSTICISM					= "012CE821"	; Minor Mysticism Rune
Global Const $GC_S_MOD_DERVISH_MAJOR_SCYTHE_MASTERY				= "0229E821"	; Major ScytheMastery Rune
Global Const $GC_S_MOD_DERVISH_MAJOR_WIND_PRAYERS  				= "022AE821"	; Major WindPrayers Rune
Global Const $GC_S_MOD_DERVISH_MAJOR_EARTH_PRAYERS 				= "022BE821"	; Major EarthPrayers Rune
Global Const $GC_S_MOD_DERVISH_MAJOR_MYSTICISM 					= "022CE821"	; Major Mysticism Rune
Global Const $GC_S_MOD_DERVISH_SUPERIOR_SCYTHE_MASTERY		 	= "0329E821"	; Superior ScytheMastery Rune
Global Const $GC_S_MOD_DERVISH_SUPERIOR_WIND_PRAYERS  			= "032AE821"	; Superior WindPrayers Rune
Global Const $GC_S_MOD_DERVISH_SUPERIOR_EARTH_PRAYERS 			= "032BE821"	; Superior EarthPrayers Rune
Global Const $GC_S_MOD_DERVISH_SUPERIOR_MYSTICISM 				= "032CE821"	; Superior Mysticism Rune

; General
Global Const $GC_S_MOD_GENERAL_RADIANT 							= "E5010824"	; Radiant Insignia
Global Const $GC_S_MOD_GENERAL_SURVIVOR 						= "E6010824"	; Survivor Insignia
Global Const $GC_S_MOD_GENERAL_STALWART 						= "E7010824"	; Stalwart Insignia
Global Const $GC_S_MOD_GENERAL_BRAWLER 							= "E8010824"	; Brawler Insignia
Global Const $GC_S_MOD_GENERAL_BLESSED 							= "E9010824"	; Blessed Insignia
Global Const $GC_S_MOD_GENERAL_HERALD 							= "EA010824"	; Herald Insignia
Global Const $GC_S_MOD_GENERAL_SENTRY 							= "EB010824"	; Sentry Insignia
	
Global Const $GC_S_MOD_GENERAL_ATTUNEMENT 						= "11020824"	; Attunement Rune
Global Const $GC_S_MOD_GENERAL_VITAE							= "12020824"	; Vitae Rune
Global Const $GC_S_MOD_GENERAL_RECOVERY							= "13020824"	; Recovery Rune
Global Const $GC_S_MOD_GENERAL_RESTORATION						= "14020824"	; Restoration Rune
Global Const $GC_S_MOD_GENERAL_CLARITY 							= "15020824"	; Clarity Rune
Global Const $GC_S_MOD_GENERAL_PURITY							= "16020824"	; Purity Rune

Global Const $GC_S_MOD_GENERAL_MINOR_VIGOR 						= "FF000824"	; Minor Vigor Rune
Global Const $GC_S_MOD_GENERAL_MAJOR_VIGOR 						= "00010824"	; Major Vigor Rune
Global Const $GC_S_MOD_GENERAL_SUPERIOR_VIGOR 					= "01010824"	; Superior Vigor Rune
#EndRegion ArmorMods (Runes)