#include-once
#include <Array.au3>

#include "GwAu3/GwAu3_Core.au3"
#include "GwAu3/GwAu3_GetInfo.au3"
#include "GwAu3/GwAu3_ExtraInfo.au3"
#include "GwAu3/GwAu3_Packet.au3"
#include "GwAu3/GwAu3_Enqueue.au3"
#include "GwAu3/GwAu3_PerformAction.au3"

#Region Global Items
Global Const $RARITY_Gold = 2624
Global Const $RARITY_Purple = 2626
Global Const $RARITY_Blue = 2623
Global Const $RARITY_White = 2621
Global Const $PickUpAll = False

Global $Armor_of_Salvation_item_effect = 2520
Global $Grail_of_Might_item_effect = 2521
Global $Essence_of_Celerity_item_effect = 2522

Global Enum $HERO_Norgu = 1, $HERO_Goren, $HERO_Tahlkora, $HERO_MasterOfWhispers, $HERO_AcolyteJin, $HERO_Koss, $HERO_Dunkoro, $HERO_AcolyteSousuke, $HERO_Melonni, _
$HERO_ZhedShadowhoof, $HERO_GeneralMorgahn, $HERO_MargridTheSly, $HERO_Olias = 14, $HERO_Razah, $HERO_MOX, $HERO_Jora = 18, $HERO_PyreFierceshot, _
$HERO_Livia = 21, $HERO_Hayda, $HERO_Kahmu, $HERO_Gwen, $HERO_Xandra, $HERO_Vekk, $HERO_Ogden
Global Enum $HERO_MercenaryHero1 = 28, $HERO_MercenaryHero2 = 29, $HERO_MercenaryHero3 = 30, $HERO_MercenaryHero4 = 31, $HERO_MercenaryHero5 = 32, $HERO_MercenaryHero6 = 33, $HERO_MercenaryHero7 = 34, $HERO_MercenaryHero8 = 35
Global Enum $HEROMODE_Fight, $HEROMODE_Guard, $HEROMODE_Avoid


;~ Materials
Global Const $model_id_lockpick = 22751
Global Const $model_id_glacial_stone = 27047
Global Const $model_id_bone = 921
Global Const $model_id_iron_ingot = 948
Global Const $model_id_wood_plank = 946
Global Const $model_id_granite_slab = 955
Global Const $model_id_dust = 929
Global Const $model_id_scale = 953
Global Const $model_id_tanned_hide_square = 940
Global Const $model_id_bolt_of_cloth = 925
Global Const $model_id_Saurian_bone = 27035
Global Const $model_id_brood_claws = 27982
Global Const $model_id_sin_tome = 21796
Global $All_Materials_Array[36] = [921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]
Global $Common_Materials_Array[11] = [921, 925, 929, 933, 934, 940, 946, 948, 953, 954, 955]
Global $Rare_Materials_Array[25] = [922, 923, 926, 927, 928, 930, 931, 932, 935, 936, 937, 938, 939, 941, 942, 943, 944, 945, 949, 950, 951, 952, 956, 6532, 6533]

;~ General Items
Global $General_Items_Array[6] = [2989, 2991, 2992, 5899, 5900, 22751]
Global Const $item_type_axe = 2
Global Const $item_type_bow = 5
Global Const $item_type_offhand = 12
Global Const $item_type_hammer = 15
Global Const $item_type_wand = 22
Global Const $item_type_shield = 24
Global Const $item_type_staff = 26
Global Const $item_type_sword = 27
Global Const $item_type_dagger = 32
Global Const $item_type_scythe = 35
Global Const $item_type_spear = 36

; Define global constants
Global Const $STATIC_AGENT_TYPE = 0x200
Global Const $ITEM_AGENT_TYPE = 0x400
Global Const $CHEST_TYPE = 512

; Initialize chest tracking array
Global $OpenedChestAgentIDs = []



Global $OpenedChestAgentIDs[1]
Global $aChestID[9000]
     $aChestID[65] = "Krytan Chest"
     $aChestID[66] = "Elonian Chest"
     $aChestID[67] = "Maguuma Chest"
     $aChestID[68] = "Phantom Chest"
     $aChestID[69] = "Ascalonian Chest"
	 $aChestID[70] = "Miners Chest"
     $aChestID[71] = "Steel Chest"
     $aChestID[72] = "Shiverpeak Chest"
     $aChestID[73] = "Darkstone Chest"
	 $aChestID[74] = "Obsidian Chest"
	 $aChestID[4576] = "Forbidden Chest"
     $aChestID[4577] = "Kurzick Chest"
	 $aChestID[4578] = "Stoneroot Chest"
     $aChestID[4579] = "Shing Jea Chest"
	 $aChestID[4580] = "Luxon Chest"
	 $aChestID[4581] = "Deep Jade Chest"
     $aChestID[4582] = "Canthan Chest"
	 $aChestID[6061] = "Ancient Elonian Chest"
     $aChestID[6062] = "Istani Chest"
	 $aChestID[6063] = "Vabbi Chest"
     $aChestID[6064] = "Kournan Chest"
     $aChestID[6065] = "Margonite Chest"
     $aChestID[7053] = "Demonic Chest"
	 $aChestID[8141] = "Locked Chest"

;~ Dungeon Key
Global Const $TYPE_KEY = 18

;Kits
;Global Const $MODEL_ID_CHEAP_SALVAGE_KIT	= 2992
;Global Const $MODEL_ID_SALVAGE_KIT			= 5900
;Global Const $MODEL_ID_CHEAP_ID_KIT			= 2989
Global Const $MODEL_ID_EXPERT_SALVAGE_KIT = 2991
Global Const $MODEL_ID_ID_KIT				= 5899
;Global Const $EXPERT_SALVAGE_KIT_MODEL_ID = 2991
Global Const $EXPERT_SALVAGE_KIT_USES_DIVISOR = 8
Global Const $BASIC_SALVAGE_KIT_MODEL_ID = 2992
Global Const $SUPERIOR_SALVAGE_KIT_MODEL_ID = 5900
Global Const $SUPERIOR_SALVAGE_KIT_USES_DIVISOR = 10


;~ Charr Carving
Global Const $Carving = 27052

;~ All Weapon mods
Global $Weapon_Mod_Array[25] = [893, 894, 895, 896, 897, 905, 906, 907, 908, 909, 6323, 6331, 15540, 15541, 15542, 15543, 15544, 15551, 15552, 15553, 15554, 15555, 17059, 19122, 19123]

;~ General Items
Global $General_Items_Array[6] = [2989, 2991, 2992, 5899, 5900, 22751]
Global Const $ITEM_ID_Lockpicks = 22751

;~ Dyes
Global Const $ITEM_ID_Dyes = 146
Global Const $ITEM_ExtraID_BlackDye = 10
Global Const $ITEM_ExtraID_WhiteDye = 12

;~ Alcohol
Global $Alcohol_Array[19] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $OnePoint_Alcohol_Array[11] = [910, 5585, 6049, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 28435]
Global $ThreePoint_Alcohol_Array[7] = [2513, 6366, 24593, 30855, 31145, 31146, 35124]
Global $FiftyPoint_Alcohol_Array[1] = [36682]

;~ Party
Global $Spam_Party_Array[5] = [6376, 21809, 21810, 21813, 36683]

;~ Sweets
Global $Spam_Sweet_Array[6] = [21492, 21812, 22269, 22644, 22752, 28436]

;~ Tonics
Global $Tonic_Party_Array[4] = [15837, 21490, 30648, 31020]

;~ DR Removal
Global $DPRemoval_Sweets[6] = [6370, 21488, 21489, 22191, 26784, 28433]

;~ Special Drops
Global $Special_Drops[7] = [5656, 18345, 21491, 37765, 21833, 28433, 28434]

;~ Stupid Drops that I am not using, but in here in case you want these to add these to the CanPickUp and collect in your chest
Global $Map_Piece_Array[4] = [24629, 24630, 24631, 24632]

;~ Stackable Trophies
Global $Stackable_Trophies_Array[1] = [27047]
Global Const $ITEM_ID_Glacial_Stones = 27047


;~ Tomes
Global $All_Tomes_Array[20] = [21796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 21805, 21786, 21787, 21788, 21789, 21790, 21791, 21792, 21793, 21794, 21795]
Global Const $ITEM_ID_Mesmer_Tome = 21797

;~ Arrays for the title spamming (Not inside this version of the bot, but at least the arrays are made for you)
Global $ModelsAlcohol[100] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $ModelSweetOutpost[100] = [15528, 15479, 19170, 21492, 21812, 22644, 31150, 35125, 36681]
Global $ModelsSweetPve[100] = [22269, 22644, 28431, 28432, 28436]
Global $ModelsParty[100] = [6368, 6369, 6376, 21809, 21810, 21813]

Global $Array_pscon[39]=[910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682, 6376, 21809, 21810, 21813, 36683, 21492, 21812, 22269, 22644, 22752, 28436,15837, 21490, 30648, 31020, 6370, 21488, 21489, 22191, 26784, 28433, 5656, 18345, 21491, 37765, 21833, 28433, 28434]


Global $Legion = False, $Bool_IdAndSell = False, $Bool_HM = False, $Bool_Store = False, $Bool_PickUp = False, $Bool_usealc = False, $Bool_cons = False, $Bool_Donate = False, $Bool_Uselockpicks = False

#Region Global MatsPic´s And ModelID´Select
Global $PIC_MATS[26][2] = [["Fur Square", 941],["Bolt of Linen", 926],["Bolt of Damask", 927],["Bolt of Silk", 928],["Glob of Ectoplasm", 930],["Steel of Ignot", 949],["Deldrimor Steel Ingot", 950],["Monstrous Claws", 923],["Monstrous Eye", 931],["Monstrous Fangs", 932],["Rubies", 937],["Sapphires", 938],["Diamonds", 935],["Onyx Gemstones", 936],["Lumps of Charcoal", 922],["Obsidian Shard", 945],["Tempered Glass Vial", 939],["Leather Squares", 942],["Elonian Leather Square", 943],["Vial of Ink", 944],["Rolls of Parchment", 951],["Rolls of Vellum", 952],["Spiritwood Planks", 956],["Amber Chunk", 6532],["Jadeite Shard", 6533]]
#EndRegion Global MatsPic´s And ModelID´Select

;Global $Array_Store_ModelIDs460[147] = [474, 476, 486, 522, 525, 811, 819, 822, 835, 610, 2994, 19185, 22751, 4629, 24630, 4631, 24632, 27033, 27035, 27044, 27046, 27047, 7052, 5123 _
;		, 1796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 1805, 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682 _
;		, 6376 , 6368 , 6369 , 21809 , 21810, 21813, 29436, 29543, 36683, 4730, 15837, 21490, 22192, 30626, 30630, 30638, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 1172, 15528 _
;		, 15479, 19170, 21492, 21812, 22269, 22644, 22752, 28431, 28432, 28436, 1150, 35125, 36681, 3256, 3746, 5594, 5595, 5611, 5853, 5975, 5976, 21233, 22279, 22280, 6370, 21488 _
;		, 21489, 22191, 35127, 26784, 28433, 18345, 21491, 28434, 35121, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943 _
;		, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]

#EndRegion Global Items

Global Enum $BAG_Backpack = 1, $BAG_BeltPouch, $BAG_Bag1, $BAG_Bag2, $BAG_EquipmentPack, $BAG_UnclaimedItems = 7, $BAG_Storage1, $BAG_Storage2, _
		$BAG_Storage3, $BAG_Storage4, $BAG_StorageAnniversary, $BAG_Storage5, $BAG_Storage6, $BAG_Storage7, $BAG_Storage8



Global Enum $ATTRIB_FastCasting, $ATTRIB_IllusionMagic, $ATTRIB_DominationMagic, $ATTRIB_InspirationMagic, _
		$ATTRIB_BloodMagic, $ATTRIB_DeathMagic, $ATTRIB_SoulReaping, $ATTRIB_Curses, _
		$ATTRIB_AirMagic, $ATTRIB_EarthMagic, $ATTRIB_FireMagic, $ATTRIB_WaterMagic, $ATTRIB_EnergyStorage, _
		$ATTRIB_HealingPrayers, $ATTRIB_SmitingPrayers, $ATTRIB_ProtectionPrayers, $ATTRIB_DivineFavor, _
		$ATTRIB_Strength, $ATTRIB_AxeMastery, $ATTRIB_HammerMastery, $ATTRIB_Swordsmanship, $ATTRIB_Tactics, _
		$ATTRIB_BeastMastery, $ATTRIB_Expertise, $ATTRIB_WildernessSurvival, $ATTRIB_Marksmanship, _
		$ATTRIB_DaggerMastery, $ATTRIB_DeadlyArts, $ATTRIB_ShadowArts, _
		$ATTRIB_Communing, $ATTRIB_RestorationMagic, $ATTRIB_ChannelingMagic, _
		$ATTRIB_CriticalStrikes, _
		$ATTRIB_SpawningPower, _
		$ATTRIB_SpearMastery, $ATTRIB_Command, $ATTRIB_Motivation, $ATTRIB_Leadership, _
		$ATTRIB_ScytheMastery, $ATTRIB_WindPrayers, $ATTRIB_EarthPrayers, $ATTRIB_Mysticism

Global Enum $EQUIP_Weapon, $EQUIP_Offhand, $EQUIP_Chest, $EQUIP_Legs, $EQUIP_Head, $EQUIP_Feet, $EQUIP_Hands

Global Enum $SKILLTYPE_Stance = 3, $SKILLTYPE_Hex, $SKILLTYPE_Spell, $SKILLTYPE_Enchantment, $SKILLTYPE_Signet, $SKILLTYPE_Well = 9, _
		$SKILLTYPE_Skill, $SKILLTYPE_Ward, $SKILLTYPE_Glyph, $SKILLTYPE_Attack = 14, $SKILLTYPE_Shout, $SKILLTYPE_Preparation = 19, _
		$SKILLTYPE_Trap = 21, $SKILLTYPE_Ritual, $SKILLTYPE_ItemSpell = 24, $SKILLTYPE_WeaponSpell, $SKILLTYPE_Chant = 27, $SKILLTYPE_EchoRefrain

Global Enum $REGION_International = -2, $REGION_America = 0, $REGION_Korea, $REGION_Europe, $REGION_China, $REGION_Japan

Global Enum $LANGUAGE_English = 0, $LANGUAGE_French = 2, $LANGUAGE_German, $LANGUAGE_Italian, $LANGUAGE_Spanish, $LANGUAGE_Polish = 9, $LANGUAGE_Russian

Global Const $FLAG_RESET = 0x7F800000; unflagging heores

Global $DroknardIsHere = 0


Global $intSkillEnergy[8] = [1, 15, 5, 5, 10, 15, 10, 5]
; Change the next lines to your skill casting times in milliseconds. use ~250 for shouts/stances, ~1000 for attack skills:
Global $intSkillCastTime[8] = [1000, 1250, 1250, 1250, 1250, 1000,  250, 1000]
; Change the next lines to your skill adrenaline count (1 to 8). leave as 0 for skills without adren
Global $intSkillAdrenaline[8] = [0, 0, 0, 0, 0, 0, 0, 0]

Global $totalskills = 7

Global $iItems_Picked = 0

Global $DeadOnTheRun = 0

; Define a custom structure via a DLL call for item properties
Global $lItemExtraStruct = DllStructCreate("byte rarity;" & _
                                           "byte unknown1[3];" & _
                                           "byte modifier;" & _
                                           "byte unknown2[13];" & _
                                           "byte lastModifier")

; Define rune array
Local $aRunes[39][2] = [ _
    [0x240801F9, "Rune.KnightsInsignia"], [0x24080208, "Rune.LieutenantsInsignia"], [0x24080209, "Rune.StonefistInsignia"], _
    [0x240801FA, "Rune.DreadnoughtInsignia"], [0x240801FB, "Rune.SentinelsInsignia"], [0x240800FC, "Rune.RuneOfMinorAbsorption"], _
    [0x21E81501, "Rune.RuneOfMinorTactics"], [0x21E81101, "Rune.RuneOfMinorStrength"], [0x21E81201, "Rune.RuneOfMinorAxeMastery"], _
    [0x21E81301, "Rune.RuneOfMinorHammerMastery"], [0x21E81401, "Rune.RuneOfMinorSwordsmanship"], [0x240800FD, "Rune.RuneOfMajorAbsorption"], _
    [0x21E81502, "Rune.RuneOfMajorTactics"], [0x21E81102, "Rune.RuneOfMajorStrength"], [0x21E81202, "Rune.RuneOfMajorAxeMastery"], _
    [0x21E81302, "Rune.RuneOfMajorHammerMastery"], [0x21E81402, "Rune.RuneOfMajorSwordsmanship"], [0x240800FE, "Rune.RuneOfSuperiorAbsorption"], _
    [0x21E81503, "Rune.RuneOfSuperiorTactics"], [0x21E81103, "Rune.RuneOfSuperiorStrength"], [0x21E81203, "Rune.RuneOfSuperiorAxeMastery"], _
    [0x21E81303, "Rune.RuneOfSuperiorHammerMastery"], [0x21E81403, "Rune.RuneOfSuperiorSwordsmanship"], [0x240801FC, "Rune.FrostboundInsignia"], _
    [0x240801FE, "Rune.PyreboundInsignia"], [0x240801FF, "Rune.StormboundInsignia"], [0x24080201, "Rune.ScoutsInsignia"], _
    [0x240801FD, "Rune.EarthboundInsignia"], [0x24080200, "Rune.BeastmastersInsignia"], [0x21E81801, "Rune.RuneOfMinorWildernessSurvival"], _
    [0x24080211, "Rune.RuneOfAttunement"], [0x24080213, "Rune.RuneOfRecovery"], [0x24080214, "Rune.RuneOfRestoration"], _
    [0x24080215, "Rune.RuneOfClarity"], [0x24080216, "Rune.RuneOfPurity"], [0x240800FF, "Rune.RuneOfMinorVigor"], _
    [0x24080101, "Rune.RuneOfSuperiorVigor"], [0x24080100, "Rune.RuneOfMajorVigor"], [0x24080212, "Rune.RuneOfVitae"] _
]

; Function to find rune by modifier
Func FindRuneByModifier($modifier)
    For $i = 0 To UBound($aRunes) - 1
        If Hex($modifier, 8) == $aRunes[$i][0] Then
            Return $aRunes[$i][1]
        EndIf
    Next
    Return "Unknown Modifier"
EndFunc

; Example usage
; 	DllStructSetData($lItemExtraStruct, "modifier", 0x240801F9)  ; set an example modifier
; 	Local $runeName = FindRuneByModifier(DllStructGetData($lItemExtraStruct, "modifier"))
; 	ConsoleWrite("Rune associated with the modifier: " & $runeName & @CRLF)
;This script helps associate modifiers in an item's data structure with a readable string name from the rune array, facilitating easier processing and display.
;
;======TEST TEST TEST END
;======================
;===========================================================================


Global $lItemExtraStructPtr = DllStructGetPtr($lItemExtraStruct)
Global $lItemExtraStructSize = DllStructGetSize($lItemExtraStruct)
#comments-start
Global $lItemNameStruct = DllStructCreate("byte rarity;"& _; Colour of the item (can be used as rarity); follow $lItemExtraStruct ->same pointer
		"byte ModMode;" & _;
		"byte ModCount;" & _;Number of Mods in the item
		"byte Name[4];" & _;Name ID of the item
		"byte Prefix[4];" & _; Depending on Item, Insignia, Axe Haft, Sword Hilt etc.
		"byte Suffix1[4];" & _; Depending on Item, Rune, Axe Grip, Sword Pommel etc.
		"byte Suffix2[4]"); (Runes Only) Quality of the Suffix (e.g. superior)

Global $lItemNameStructPtr = DllStructGetPtr($lItemNameStruct)
Global $lItemNameStructSize = DllStructGetSize($lItemNameStruct)
#comments-end

;-------> Item Extra Req Struct Definition
Global $lItemExtraReqStruct = DllStructCreate( _
		"byte requirement;" & _
		"byte attribute");Skill Template Format
Global $lItemExtraReqStructPtr = DllStructGetPtr($lItemExtraReqStruct)
Global $lItemExtraReqStructSize = DllStructGetSize($lItemExtraReqStruct)
;-------> Item Mod Struct definition
Global $lItemModStruct = DllStructCreate( _
		"byte unknown1[28];" & _
		"byte armor")
Global $lItemModStructPtr = DllStructGetPtr($lItemModStruct)
Global $lItemModStructSize = DllStructGetSize($lItemModStruct)


#Region H&H

Func MoveHero($aX, $aY, $HeroID, $Random = 75); Parameter1 = heroID (1-7) reset flags $aX = 0x7F800000, $aY = 0x7F800000

	Switch $HeroID
		Case "All"
			CommandAll(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 1
			CommandHero1(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 2
			CommandHero2(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 3
			CommandHero3(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 4
			CommandHero4(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 5
			CommandHero5(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 6
			CommandHero6(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 7
			CommandHero7(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
	EndSwitch
EndFunc   ;==>MoveHero

Func GetHeroIdByName($heroName)
    Switch $heroName
        Case "Norgu"
            Return $HERO_Norgu
        Case "Goren"
            Return $HERO_Goren
        Case "Tahlkora"
            Return $HERO_Tahlkora
        Case "Master Of Whispers"
            Return $HERO_MasterOfWhispers
        Case "Acolyte Jin"
            Return $HERO_AcolyteJin
        Case "Koss"
            Return $HERO_Koss
        Case "Dunkoro"
            Return $HERO_Dunkoro
        Case "Acolyte Sousuke"
            Return $HERO_AcolyteSousuke
        Case "Melonni"
            Return $HERO_Melonni
        Case "Zhed Shadowhoof"
            Return $HERO_ZhedShadowhoof
        Case "General Morgahn"
            Return $HERO_GeneralMorgahn
        Case "Margrid The Sly"
            Return $HERO_MargridTheSly
        Case "Olias"
            Return $HERO_Olias
        Case "Razah"
            Return $HERO_Razah
        Case "MOX"
            Return $HERO_MOX
        Case "Jora"
            Return $HERO_Jora
        Case "Pyre Fierceshot"
            Return $HERO_PyreFierceshot
        Case "Livia"
            Return $HERO_Livia
        Case "Hayda"
            Return $HERO_Hayda
        Case "Kahmu"
            Return $HERO_Kahmu
        Case "Gwen"
            Return $HERO_Gwen
        Case "Xandra"
            Return $HERO_Xandra
        Case "Vekk"
            Return $HERO_Vekk
        Case "Ogden"
            Return $HERO_Ogden
        Case "Mercenary Hero 1"
            Return $HERO_MercenaryHero1
        Case "Mercenary Hero 2"
            Return $HERO_MercenaryHero2
        Case "Mercenary Hero 3"
            Return $HERO_MercenaryHero3
        Case "Mercenary Hero 4"
            Return $HERO_MercenaryHero4
        Case "Mercenary Hero 5"
            Return $HERO_MercenaryHero5
        Case "Mercenary Hero 6"
            Return $HERO_MercenaryHero6
        Case "Mercenary Hero 7"
            Return $HERO_MercenaryHero7
        Case "Mercenary Hero 8"
            Return $HERO_MercenaryHero8
        Case Else
            Return -1 ; Hero name not found
    EndSwitch
EndFunc

#Region chest

Func GetAgentArraySorted($lAgentType)     ;returns a 2-dimensional array([agentID, [distance]) sorted by distance
	Local $lDistance
	Local $lAgentArray = GetAgentArray($lAgentType)
	Local $lReturnArray[1][2]
	Local $lMe = GetAgentByID(-2)
	Local $AgentID
	For $i = 1 To $lAgentArray[0]
		$lDistance = (DllStructGetData($lMe, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($lMe, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		$AgentID = DllStructGetData($lAgentArray[$i], 'ID')
		ReDim $lReturnArray[$i][2]
		$lReturnArray[$i - 1][0] = $AgentID
		$lReturnArray[$i - 1][1] = Sqrt($lDistance)
	Next
	_ArraySort($lReturnArray, 0, 0, 0, 1)
	Return $lReturnArray
 EndFunc   ;==>GetAgentArraySorted

  ; Function to check for chests and interact with them
Func CheckForChest($chestRun = False)
   ; Check if the character is dead
   If GetIsDead(-2) Then Return

   ; Get all static objects
   Local $AgentArray = GetAgentArraySorted($STATIC_AGENT_TYPE)
   Local $lAgent = 0
   Local $ChestFound = False

   ; Look for valid chests
   For $i = 0 To UBound($AgentArray) - 1
      $lAgent = GetAgentByID($AgentArray[$i][0])

      ; Skip if not a chest or invalid chest ID
      If DllStructGetData($lAgent, 'Type') <> $CHEST_TYPE Or $aChestID = "" Then
        ContinueLoop
      EndIf

      ; Check if chest was already opened
      If Not IsChestOpened($AgentArray[$i][0]) Then
        ; Add chest to opened list
        AddOpenedChest($AgentArray[$i][0])
        $ChestFound = True
        ExitLoop
      EndIf
   Next

   If Not $ChestFound Then Return

   ; Interact with chest
   ChangeTarget($lAgent)
   GoSignpost($lAgent)
   OpenChestByExtraType($aChestID)
   Sleep(GetPing() + 500)

   ; Handle loot
   Local $ItemArray = GetAgentArraySorted($ITEM_AGENT_TYPE)
   If UBound($ItemArray) > 0 Then
      ChangeTarget($ItemArray[0][0])
      PickUpLoot()
   EndIf
EndFunc

; Function to check if a chest has been opened
Func IsChestOpened($chestID)
   If UBound($OpenedChestAgentIDs) = 0 Then Return False
   Return _ArraySearch($OpenedChestAgentIDs, $chestID) <> -1
EndFunc

; Function to add a chest to the opened list
Func AddOpenedChest($chestID)
   If UBound($OpenedChestAgentIDs) = 0 Then
      ReDim $OpenedChestAgentIDs[1]
      $OpenedChestAgentIDs[0] = $chestID
   Else
      _ArrayAdd($OpenedChestAgentIDs, $chestID)
   EndIf
EndFunc

Func CheckForChest2($chestrun = False)
    Local $AgentArray, $lAgent, $lType, $playerAgent
    Local $ChestFound = False
    Local $MaxDistance = 10000  ; Maximum distance to check for chests

    If GetIsDead(-2) Then Return  ; Exit if the player is dead
    $playerAgent = GetPlayerCoords()  ; Get the player agent
    $AgentArray = GetAgentArraySorted(0x200)  ; Retrieve sorted array of static type entities
    For $i = 0 To UBound($AgentArray) - 1
        $lAgent = GetAgentByID($AgentArray[$i][0])
        If Not IsDllStruct($lAgent) Then ContinueLoop  ; Validate each agent before proceeding

        $lType = DllStructGetData($lAgent, 'Type')
        If $lType <> 512 Then ContinueLoop  ; Skip non-chest agents

        $lDistance = CalculateDistance($playerAgent, $lAgent)
        If $lDistance > $MaxDistance Then ContinueLoop  ; Skip chests out of specified range

        ; Check if chest has been opened before
        If _ArraySearch($OpenedChestAgentIDs, $AgentArray[$i][0]) <> -1 Then
            ContinueLoop  ; Skip this chest as it has already been opened
        EndIf

        ; Not found in the opened chest list, proceed
        $ChestFound = True
        ChangeTarget($lAgent)
        GoSignpost($lAgent)
        OpenChestByExtraType($aChestID)
        Sleep(GetPing() + 500)

        ; Add the chest ID to the blacklist after opening
        _ArrayAdd($OpenedChestAgentIDs, $AgentArray[$i][0])

        ; Retrieve items dropped from the chest
        $AgentArray = GetAgentArraySorted(0x400)
        ChangeTarget($AgentArray[0][0])
        PickUpLoot()
    Next

    If Not $ChestFound Then Return False  ; Return False if no chests found
    Return True  ; Indicate successful operation
EndFunc   ;==>CheckForChest2

Func PickUpLoot2()
    If CountSlots() < 1 Then Return ; Check if inventory is full and exit if no slots are available

    If GetIsDead(-2) Then Return ; Exit the function if the player is dead

    Local $lAgent, $lItem, $lDeadlock
    For $i = 1 To GetMaxAgents() ; Loop through all agents in the area
        $lAgent = GetAgentByID($i) ; Retrieve agent data by its ID

        If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop ; Only proceed if agent type is item (0x400)

        $lItem = GetItemByAgentID($i)
        If CanPickUp($lItem) Then ; Check if the item is eligible to be picked up
            PickUpItem($lItem) ; Execute the pick up item action
            $lDeadlock = TimerInit() ; Start a timer to avoid a deadlock situation

            While GetAgentExists($i) ; Loop while the item still exists
                Sleep(100) ; Small delay to reduce CPU load and allow for server response time
                If GetIsDead(-2) Then Return ; Exit if the player dies during the process

                If TimerDiff($lDeadlock) > 15000 Then ExitLoop ; Break the loop after 15 seconds to avoid infinite loop
            WEnd
        EndIf
    Next
EndFunc   ;==>PickUpLoot2

#EndRegion Chest

;=================================================================================================
; Function:			PickUpItems($iItems = -1, $fMaxDistance = 1012)
; Description:		PickUp defined number of items in defined area around default = 1012
; Parameter(s):		$iItems:	number of items to be picked
;					$fMaxDistance:	area within items should be picked up
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns $iItemsPicked (number of items picked)
; Author(s):		GWCA team, recoded by ddarek, thnx to The ArkanaProject
;=================================================================================================
Func PickupItems($iItems = -1, $fMaxDistance = 506)
	Local $aItemID, $lNearestDistance, $lDistance
	$tDeadlock = TimerInit()
	Do
		$aItem = GetNearestItemToAgent(-2)
		$lDistance = @extended

		$aItemID = DllStructGetData($aItem, 'ID')
		If $aItemID = 0 Or $lDistance > $fMaxDistance Or TimerDiff($tDeadlock) > 30000 Then ExitLoop
		PickUpItem($aItem)
		$tDeadlock2 = TimerInit()
		Do
			Sleep(500)
			If TimerDiff($tDeadlock2) > 5000 Then ContinueLoop 2
		Until DllStructGetData(GetAgentById($aItemID), 'ID') == 0
		$iItems_Picked += 1
		;UpdateStatus("Picked total " & $iItems_Picked & " items")
	Until $iItems_Picked = $iItems
	Return $iItems_Picked
EndFunc   ;==>PickupItems
#Region Misc

Func GetTeam($aTeam); Thnx to The Arkana Project. Only works in PvP!
	Local $lTeamNumber
	Local $lTeam[1][2]
	Local $lTeamSmall[1] = [0]
	Local $lAgent
	If IsString($aTeam) Then
		Switch $aTeam
			Case "Blue"
				$lTeamNumber = 1
			Case "Red"
				$lTeamNumber = 2
			Case "Yellow"
				$lTeamNumber = 3
			Case "Purple"
				$lTeamNumber = 4
			Case "Cyan"
				$lTeamNumber = 5
			Case Else
				$lTeamNumber = 0
		EndSwitch
	Else
		$lTeamNumber = $aTeam
	EndIf
	$lTeam[0][0] = 0
	$lTeam[0][1] = $lTeamNumber
	If $lTeamNumber == 0 Then Return $lTeamSmall
	For $i = 1 To GetMaxAgents()
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'ID') == 0 Then ContinueLoop
		If GetIsLiving($lAgent) And DllStructGetData($lAgent, 'Team') == $lTeamNumber And (DllStructGetData($lAgent, 'LoginNumber') <> 0 Or StringRight(GetAgentName($lAgent), 9) == "Henchman]") Then
			$lTeam[0][0] += 1
			ReDim $lTeam[$lTeam[0][0]+1][2]
			$lTeam[$lTeam[0][0]][0] = DllStructGetData($lAgent, 'id')
			$lTeam[$lTeam[0][0]][1] = DllStructGetData($lAgent, 'PlayerNumber')
		EndIf
	Next
	_ArraySort($lTeam, 0, 1, 0, 1)
	Redim $lTeamSmall[$lTeam[0][0]+1]
	For $i = 0 To $lTeam[0][0]
		$lTeamSmall[$i] = $lTeam[$i][0]
	Next
	Return $lTeamSmall
EndFunc

Func FormatName($aAgent); Thnx to The Arkana Project. Only works in PvP!
	If IsDllStruct($aAgent) == 0 Then $aAgent = GetAgentByID($aAgent)
	Local $lString
	Switch DllStructGetData($aAgent, 'Primary')
		Case 1
			$lString &= "W"
		Case 2
			$lString &= "R"
		Case 3
			$lString &= "Mo"
		Case 4
			$lString &= "N"
		Case 5
			$lString &= "Me"
		Case 6
			$lString &= "E"
		Case 7
			$lString &= "A"
		Case 8
			$lString &= "Rt"
		Case 9
			$lString &= "P"
		Case 10
			$lString &= "D"
	EndSwitch
	Switch DllStructGetData($aAgent, 'Secondary')
		Case 1
			$lString &= "/W"
		Case 2
			$lString &= "/R"
		Case 3
			$lString &= "/Mo"
		Case 4
			$lString &= "/N"
		Case 5
			$lString &= "/Me"
		Case 6
			$lString &= "/E"
		Case 7
			$lString &= "/A"
		Case 8
			$lString &= "/Rt"
		Case 9
			$lString &= "/P"
		Case 10
			$lString &= "/D"
	EndSwitch
	$lString &= " - "
	If DllStructGetData($aAgent, 'LoginNumber') > 0 Then
		$lString &= GetPlayerName($aAgent)
	Else
		$lString &= StringReplace(GetAgentName($aAgent), "Corpse of ", "")
	EndIf
	Return $lString
EndFunc

Func IsBlackDye($aModelID, $aExtraID)
	If $aModelID == $model_id_dye Then
		Switch $aExtraID
			Case $item_extraid_black_dye
				Return True
			Case Else
				Return False
		EndSwitch
	EndIf
EndFunc ;==>IsBlackDye

Func IsWhiteDye($aModelID, $aExtraID)
	If $aModelID == $model_id_dye Then
		Switch $aExtraID
			Case $ITEM_ExtraID_WhiteDye
				Return True
			Case Else
				Return False
		EndSwitch
	EndIf
EndFunc ;==>IsBlackDye

#EndRegion Misc

;~ Description: Sleep a random amount of time.
Func RndSleep($aAmount, $aRandom = 0.05)
	Local $lRandom = $aAmount * $aRandom
	Sleep(Random($aAmount - $lRandom, $aAmount + $lRandom))
EndFunc   ;==>RndSleep

;~ Description: Sleep a period of time, plus or minus a tolerance
Func TolSleep($aAmount = 150, $aTolerance = 50)
	Sleep(Random($aAmount - $aTolerance, $aAmount + $aTolerance))
EndFunc   ;==>TolSleep

Func PingSleep($msExtra = 0)
	$ping = GetPing()
	Sleep($ping + $msExtra)
EndFunc   ;==>PingSleep

#Region Loading build
Func LoadSkillTemplate($aTemplate, $aHeroNumber = 0)
	Local $lHeroID = GetHeroInfo($aHeroNumber, "AgentID")
	Local $lSplitTemplate = StringSplit($aTemplate, '')

	Local $lTemplateType ; 4 Bits
	Local $lVersionNumber ; 4 Bits
	Local $lProfBits ; 2 Bits -> P
	Local $lProfPrimary ; P Bits
	Local $lProfSecondary ; P Bits
	Local $lAttributesCount ; 4 Bits
	Local $lAttributesBits ; 4 Bits -> A
	Local $lAttributes[1][2] ; A Bits + 4 Bits (for each Attribute)
	Local $lSkillsBits ; 4 Bits -> S
	Local $lSkills[8] ; S Bits * 8
	Local $lOpTail ; 1 Bit

	$aTemplate = ''
	For $i = 1 To $lSplitTemplate[0]
		$aTemplate &= Base64ToBin64($lSplitTemplate[$i])
	Next

	$lTemplateType = Bin64ToDec(StringLeft($aTemplate, 4))
	$aTemplate = StringTrimLeft($aTemplate, 4)
	If $lTemplateType <> 14 Then Return False

	$lVersionNumber = Bin64ToDec(StringLeft($aTemplate, 4))
	$aTemplate = StringTrimLeft($aTemplate, 4)

	$lProfBits = Bin64ToDec(StringLeft($aTemplate, 2)) * 2 + 4
	$aTemplate = StringTrimLeft($aTemplate, 2)

	$lProfPrimary = Bin64ToDec(StringLeft($aTemplate, $lProfBits))
	$aTemplate = StringTrimLeft($aTemplate, $lProfBits)
	If $lProfPrimary <> GetHeroInfo($aHeroNumber, "Primary") Then Return False

	$lProfSecondary = Bin64ToDec(StringLeft($aTemplate, $lProfBits))
	$aTemplate = StringTrimLeft($aTemplate, $lProfBits)

	$lAttributesCount = Bin64ToDec(StringLeft($aTemplate, 4))
	$aTemplate = StringTrimLeft($aTemplate, 4)

	$lAttributesBits = Bin64ToDec(StringLeft($aTemplate, 4)) + 4
	$aTemplate = StringTrimLeft($aTemplate, 4)

	$lAttributes[0][0] = $lAttributesCount
	For $i = 1 To $lAttributesCount
		If Bin64ToDec(StringLeft($aTemplate, $lAttributesBits)) == GetProfPrimaryAttribute($lProfPrimary) Then
			$aTemplate = StringTrimLeft($aTemplate, $lAttributesBits)
			$lAttributes[0][1] = Bin64ToDec(StringLeft($aTemplate, 4))
			$aTemplate = StringTrimLeft($aTemplate, 4)
			ContinueLoop
		EndIf
		$lAttributes[0][0] += 1
		ReDim $lAttributes[$lAttributes[0][0] + 1][2]
		$lAttributes[$i][0] = Bin64ToDec(StringLeft($aTemplate, $lAttributesBits))
		$aTemplate = StringTrimLeft($aTemplate, $lAttributesBits)
		$lAttributes[$i][1] = Bin64ToDec(StringLeft($aTemplate, 4))
		$aTemplate = StringTrimLeft($aTemplate, 4)
	Next

	$lSkillsBits = Bin64ToDec(StringLeft($aTemplate, 4)) + 8
	$aTemplate = StringTrimLeft($aTemplate, 4)

	For $i = 0 To 7
		$lSkills[$i] = Bin64ToDec(StringLeft($aTemplate, $lSkillsBits))
		$aTemplate = StringTrimLeft($aTemplate, $lSkillsBits)
	Next

	$lOpTail = Bin64ToDec($aTemplate)

	$lAttributes[0][0] = $lProfSecondary
	LoadAttributes($lAttributes, $aHeroNumber)
	LoadSkillBar($lSkills[0], $lSkills[1], $lSkills[2], $lSkills[3], $lSkills[4], $lSkills[5], $lSkills[6], $lSkills[7], $aHeroNumber)
EndFunc   ;==>LoadSkillTemplate

Func LoadAttributes($aAttributesArray, $aHeroNumber = 0)
	Local $lPrimaryAttribute
	Local $lDeadlock = 0
	Local $lHeroID = GetHeroInfo($aHeroNumber, "AgentID")
	Local $lLevel
	Local $TestTimer = 0

	$lPrimaryAttribute = GetProfPrimaryAttribute(GetHeroInfo($aHeroNumber, "Primary"))

	If $aAttributesArray[0][0] <> 0 And GetHeroInfo($aHeroNumber, "Secondary") <> $aAttributesArray[0][0] And GetHeroInfo($aHeroNumber, "Primary") <> $aAttributesArray[0][0] Then
		Do
			$lDeadlock = TimerInit()
			ChangeSecondProfession($aAttributesArray[0][0], $aHeroNumber)
			Do
				Sleep(16)
			Until GetHeroInfo($aHeroNumber, "Secondary") == $aAttributesArray[0][0] Or TimerDiff($lDeadlock) > 5000
		Until GetHeroInfo($aHeroNumber, "Secondary") == $aAttributesArray[0][0] Or TimerDiff($lDeadlock) > 10000
	EndIf

	$aAttributesArray[0][0] = $lPrimaryAttribute
	For $i = 0 To UBound($aAttributesArray) - 1
		If $aAttributesArray[$i][1] > 12 Then $aAttributesArray[$i][1] = 12
		If $aAttributesArray[$i][1] < 0 Then $aAttributesArray[$i][1] = 0
	Next

	While GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $aAttributesArray[0][1]
		$lLevel = GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
		$lDeadlock = TimerInit()
		DecreaseAttribute($lPrimaryAttribute, $aHeroNumber)
		Do
			Sleep(16)
		Until GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
		Sleep(16)
	WEnd
	For $i = 1 To UBound($aAttributesArray) - 1

		While GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") > $aAttributesArray[$i][1]
			$lLevel = GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel")
			$lDeadlock = TimerInit()
			DecreaseAttribute($aAttributesArray[$i][0], $aHeroNumber)
			Do
				Sleep(16)
			Until GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
			Sleep(16)
		WEnd
	Next
	For $i = 0 To 44

		If GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0 Then
			If $i = $lPrimaryAttribute Then ContinueLoop
			For $J = 1 To UBound($aAttributesArray) - 1
				If $i = $aAttributesArray[$J][0] Then ContinueLoop 2
			Next
			While GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0
				$lLevel = GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel")
				$lDeadlock = TimerInit()
				DecreaseAttribute($i, $aHeroNumber)
				Do
					Sleep(16)
				Until GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
				Sleep(16)
			WEnd
		EndIf
	Next

	$TestTimer = 0

	While GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $aAttributesArray[0][1]
		$lLevel = GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
		$lDeadlock = TimerInit()
		IncreaseAttribute($lPrimaryAttribute, $aHeroNumber)
		Do
			Sleep(16)
			$TestTimer = $TestTimer + 1
		Until GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > 5000
		Sleep(16)
		If $TestTimer > 225 Then ExitLoop
	WEnd
	For $i = 1 To UBound($aAttributesArray) - 1
		$TestTimer = 0

		While GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") < $aAttributesArray[$i][1]
			$lLevel = GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel")
			$lDeadlock = TimerInit()
			IncreaseAttribute($aAttributesArray[$i][0], $aHeroNumber)
			Do
				Sleep(16)
				$TestTimer = $TestTimer + 1
			Until GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > 5000
			Sleep(16)
			If $TestTimer > 225 Then ExitLoop
		WEnd
	Next
EndFunc   ;==>LoadAttributes

Func GetProfPrimaryAttribute($aProfession)
	Switch $aProfession
		Case 1
			Return 17
		Case 2
			Return 23
		Case 3
			Return 16
		Case 4
			Return 6
		Case 5
			Return 0
		Case 6
			Return 12
		Case 7
			Return 35
		Case 8
			Return 36
		Case 9
			Return 40
		Case 10
			Return 44
	EndSwitch
EndFunc   ;==>GetProfPrimaryAttribute
#EndRegion Loading Build

#Region Rendering
;~ Description: Enable graphics rendering.
Func EnableRendering($aShowWindow = True)
	Local $lWindowHandle = $mGWWindowHandle, $lPrevGWState = WinGetState($lWindowHandle), $lPrevWindow = WinGetHandle("[ACTIVE]", ""), $lPrevWindowState = WinGetState($lPrevWindow)
	If $aShowWindow And $lPrevGWState Then
		If BitAND($lPrevGWState, 16) Then
			WinSetState($lWindowHandle, "", @SW_RESTORE)
		ElseIf Not BitAND($lPrevGWState, 2) Then
			WinSetState($lWindowHandle, "", @SW_SHOW)
		EndIf
		If $lWindowHandle <> $lPrevWindow And $lPrevWindow Then RestoreWindowState($lPrevWindow, $lPrevWindowState)
	EndIf
	If Not GetIsRendering() Then
		$mRendering = True
		If Not MemoryWrite($mDisableRendering, 0) Then Return SetError(@error, False)
		Sleep(250)
	EndIf
	Return 1
EndFunc   ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering($aHideWindow = True)
	Local $lWindowHandle = $mGWWindowHandle
	If $aHideWindow And WinGetState($lWindowHandle) Then WinSetState($lWindowHandle, "", @SW_HIDE)
	If GetIsRendering() Then
		$mRendering = True
		If Not MemoryWrite($mDisableRendering, 1) Then Return SetError(@error, False)
		Sleep(250)
	EndIf
	Return 1
EndFunc   ;==>DisableRendering

;Toggles graphics rendering
Func ToggleRendering()
	Return GetIsRendering() ? DisableRendering() : EnableRendering()
EndFunc   ;==>ToggleRendering

Func GetIsRendering()
	Return MemoryRead($mDisableRendering) <> 1
EndFunc   ;==>GetIsRendering

;Internally used - restores a window to previous state.
Func RestoreWindowState($aWindowHandle, $aPreviousWindowState)
	If Not $aWindowHandle Or Not $aPreviousWindowState Then Return 0

	Local $lStates[6] = [1, 2, 4, 8, 16, 32], $lCurrentWindowState = WinGetState($aWindowHandle)
	For $i = 0 To UBound($lStates) - 1
		If BitAND($aPreviousWindowState, $lStates[$i]) And Not BitAND($lCurrentWindowState, $lStates[$i]) Then WinSetState($aWindowHandle, "", $lStates[$i])
	Next
EndFunc   ;==>RestoreWindowState
#EndRegion Rendering

#Region Chat
;~ Description: Write a message in chat (can only be seen by botter).
Func WriteChat($aMessage, $aSender = 'GwAu3')
	Local $lMessage, $lSender
	Local $lAddress = 256 * $mQueueCounter + $mQueueBase

	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf

	If StringLen($aSender) > 19 Then
		$lSender = StringLeft($aSender, 19)
	Else
		$lSender = $aSender
	EndIf

	MemoryWrite($lAddress + 4, $lSender, 'wchar[20]')

	If StringLen($aMessage) > 100 Then
		$lMessage = StringLeft($aMessage, 100)
	Else
		$lMessage = $aMessage
	EndIf

	MemoryWrite($lAddress + 44, $lMessage, 'wchar[101]')
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mWriteChatPtr, 'int', 4, 'int', '')

	If StringLen($aMessage) > 100 Then WriteChat(StringTrimLeft($aMessage, 100), $aSender)
EndFunc   ;==>WriteChat

;~ Description: Send a whisper to another player.
Func SendWhisper($aReceiver, $aMessage)
	Local $lTotal = 'whisper ' & $aReceiver & ',' & $aMessage
	Local $lMessage

	If StringLen($lTotal) > 120 Then
		$lMessage = StringLeft($lTotal, 120)
	Else
		$lMessage = $lTotal
	EndIf

	SendChat($lMessage, '/')

	If StringLen($lTotal) > 120 Then SendWhisper($aReceiver, StringTrimLeft($lTotal, 120))
EndFunc   ;==>SendWhisper

;~ Description: Send a message to chat.
Func SendChat($aMessage, $aChannel = '!')
	Local $lMessage
	Local $lAddress = 256 * $mQueueCounter + $mQueueBase

	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf

	If StringLen($aMessage) > 120 Then
		$lMessage = StringLeft($aMessage, 120)
	Else
		$lMessage = $aMessage
	EndIf

	MemoryWrite($lAddress + 12, $aChannel & $lMessage, 'wchar[122]')
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mSendChatPtr, 'int', 8, 'int', '')

	If StringLen($aMessage) > 120 Then SendChat(StringTrimLeft($aMessage, 120), $aChannel)
EndFunc   ;==>SendChat

;~ Description: Invite a player to the party.
Func InvitePlayer($aPlayerName)
	SendChat('invite ' & $aPlayerName, '/')
EndFunc   ;==>InvitePlayer

;~ Description: Resign.
Func Resign()
	SendChat('resign', '/')
EndFunc   ;==>Resign
#EndRegion Chat

#Region Item
;~ Description: Identifies all items in a bag.
Func IdentifyBag($aBagNumber, $aGolds = True, $aPurples = False, $aBlue = False, $aWhites = False)
	Local $aItemID
	$aBag = GetBagPtr($aBagNumber)
	For $i = 1 To GetBagInfo($aBagNumber, "Slots")
		$aItemID = GetItemBySlot($aBagNumber, $i)
		If ItemID($aItemID) == 0 Then ContinueLoop

		Switch GetItemInfoByItemID($aItemID, "Rarity")
			Case 2624 ;gold
				If $aGolds == False Then ContinueLoop
				IdentifyItem($aItemID)
			Case 2626 ;purple
				If $aPurples == False Then ContinueLoop
				IdentifyItem($aItemID)
			Case 2623 ;blue
				If $aBlue == False Then ContinueLoop
				IdentifyItem($aItemID)
			Case 2621 ;white
				If $aWhites == False Then ContinueLoop
				IdentifyItem($aItemID)
		EndSwitch
	Next
EndFunc   ;==>IdentifyBag

Func GetCraftMatsString($aModelID, $aAmount)
	Local $lCount = 0
	Local $lQuantity = 0
	Local $lMatString = ''
	For $bag = 1 To 4
		$lBagPtr = GetBagPtr($bag)
		If $lBagPtr = 0 Then ContinueLoop ; no valid bag
		For $slot = 1 To MemoryRead($lBagPtr + 32, 'long')
			$lSlotPtr = GetItemPtrBySlot($lBagPtr, $slot)
			If $lSlotPtr = 0 Then ContinueLoop ; empty slot
			If MemoryRead($lSlotPtr + 44, 'long') = $aModelID Then
				$lMatString &= MemoryRead($lSlotPtr, 'long') & ';'
				$lCount += 1
				$lQuantity += MemoryRead($lSlotPtr + 75, 'byte')
				If $lQuantity >= $aAmount Then
					Return SetExtended($lCount, $lMatString)
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>GetCraftMatsString

;~ Description: Deposit gold into storage.
Func DepositGold($aAmount = 0)
	Local $lAmount
	Local $lStorage = GetInventoryInfo("GoldStorage")
	Local $lCharacter = GetInventoryInfo("GoldCharacter")

	If $aAmount > 0 And $lCharacter >= $aAmount Then
		$lAmount = $aAmount
	Else
		$lAmount = $lCharacter
	EndIf

	If $lStorage + $lAmount > 1000000 Then $lAmount = 1000000 - $lStorage

	ChangeGold($lCharacter - $lAmount, $lStorage + $lAmount)
EndFunc   ;==>DepositGold

;~ Description: Withdraw gold from storage.
Func WithdrawGold($aAmount = 0)
	Local $lAmount
	Local $lStorage = GetInventoryInfo("GoldStorage")
	Local $lCharacter = GetInventoryInfo("GoldCharacter")

	If $aAmount > 0 And $lStorage >= $aAmount Then
		$lAmount = $aAmount
	Else
		$lAmount = $lStorage
	EndIf

	If $lCharacter + $lAmount > 100000 Then $lAmount = 100000 - $lCharacter

	ChangeGold($lCharacter + $lAmount, $lStorage - $lAmount)
EndFunc   ;==>WithdrawGold

#EndRegion Item

#Region H&H
;~ Description: Disable a skill on a hero's skill bar.
Func DisableHeroSkillSlot($aHeroNumber, $aSkillSlot)
	If Not GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot) Then ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot)
EndFunc   ;==>DisableHeroSkillSlot

;~ Description: Enable a skill on a hero's skill bar.
Func EnableHeroSkillSlot($aHeroNumber, $aSkillSlot)
	If GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot) Then ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot)
EndFunc   ;==>EnableHeroSkillSlot
#EndRegion H&H

#Region Movement
;~ Description: Move to a location and wait until you reach it.
Func MoveTo($aX, $aY, $aRandom = 50)
	Local $lBlocked = 0
	Local $lMapLoading = GetInstanceInfo("Type")
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)

	Move($lDestX, $lDestY, 0)

	Do
		Sleep(100)
		If GetAgentInfo(-2, 'HP') <= 0 Then ExitLoop

		If Not GetAgentInfo(-2, "IsMoving") Then
			$lBlocked += 1
			$lDestX = $aX + Random(-$aRandom, $aRandom)
			$lDestY = $aY + Random(-$aRandom, $aRandom)
			Move($lDestX, $lDestY, 0)
		EndIf
	Until ComputeDistance(GetAgentInfo(-2, 'X'), GetAgentInfo(-2, 'Y'), $lDestX, $lDestY) < 25 Or $lBlocked > 14 Or $lMapLoading <> GetInstanceInfo("Type")
EndFunc   ;==>MoveTo

;~ Description: Talks to NPC and waits until you reach them.
Func GoToNPC($aAgent)
    Local $lBlocked = 0
    Local $lMapLoading = GetInstanceInfo("Type")

    Move(X($aAgent), Y($aAgent), 100)
    Do
        Sleep(100)
        If GetAgentInfo(-2, "IsDead") Then Return ExitLoop

        If Not GetAgentInfo(-2, "IsMoving") Then
            $lBlocked += 1
			$lDestX = $aX + Random(-$aRandom, $aRandom)
			$lDestY = $aY + Random(-$aRandom, $aRandom)
			Move($lDestX, $lDestY, 0)
        EndIf
    Until GetDistance($aAgent, -2) < 200 Or $lBlocked > 14 Or $lMapLoading <> GetInstanceInfo("Type")
    GoNPC($aAgent)
EndFunc   ;==>GoToNPC

;~ Description: Go to signpost and waits until you reach it.
Func GoToSignpost($aAgent)
	Local $lBlocked = 0
	Local $lMapLoading = GetInstanceInfo("Type")

	Move(GetAgentInfo($aAgent, 'X'), GetAgentInfo($aAgent, 'Y'), 100)

	Do
		Sleep(100)

		If GetAgentInfo(-2, 'HP') <= 0 Then ExitLoop

		If Not GetAgentInfo(-2, "IsMoving") Then
            $lBlocked += 1
			$lDestX = $aX + Random(-$aRandom, $aRandom)
			$lDestY = $aY + Random(-$aRandom, $aRandom)
			Move($lDestX, $lDestY, 0)
        EndIf
	Until ComputeDistance(GetAgentInfo(-2, 'X'), GetAgentInfo(-2, 'Y'), GetAgentInfo($aAgent, 'X'), GetAgentInfo($aAgent, 'Y')) < 250 Or $lBlocked > 14 Or $lMapLoading <> GetInstanceInfo("Type")
	GoSignpost($aAgent)
EndFunc   ;==>GoToSignpost
#EndRegion Movement

#Region Travel
;~ Description: Map travel to an outpost.
Func TravelTo($aMapID, $aRegion = GetCharacterInfo("Region"), $aDistrict = GetCharacterInfo("District"), $aDis = GetCharacterInfo("Language"))
	If GetCharacterInfo("MapID") = $aMapID And $aDis = 0 And GetInstanceInfo("IsOutpost") Then Return True
	MoveMap($aMapID, $aRegion, $aDistrict, $aDis)
	Return WaitMapLoading($aMapID)
EndFunc   ;==>TravelTo

;~ Description: Wait for map to load until every context are loaded.
Func WaitMapLoading($aMapID = -1, $aInstanceType = -1)
	Do
		Sleep(250)
	Until GetAgentPtr(-2) <> 0 And GetAgentArraySize() <> 0 And GetSkillbarPtr() <> 0 And GetPartyContextPtr() <> 0 And ($aInstanceType = -1 Or GetInstanceInfo("Type") = $aInstanceType) And ($aMapID = -1 Or GetCharacterInfo("MapID") = $aMapID)
EndFunc

;~ Description: Returns current MapID
Func GetMapID()
    Return GetCharacterInfo("MapID")
EndFunc   ;==>GetMapID
#EndRegion Travel

#Region Misc

Func UseSkillEx($aSkillSlot, $lTgt = -2, $aTimeout = 3000)
	If GetAgentInfo(-2, "IsDead") Then Return
	If Not GetSkillbarInfo($aSkillSlot, "IsRecharged") Then Return
	Local $lSkillID = GetSkillbarInfo($aSkillSlot, "SkillID")
	If GetEnergy(-2) < GetSkillInfo($lSkillID, "EnergyCost") Then Return
	Local $lAftercast = GetSkillInfo($lSkillID, "Aftercast")
	Local $lDeadlock = TimerInit()
	UseSkill($aSkillSlot, $lTgt)

	Do
		Sleep(16)
	Until (GetSkillbarInfo($aSkillSlot, "Casting") And GetAgentInfo(-2, "IsCasting")) Or GetAgentInfo(-2, "IsDead") Or (TimerDiff($lDeadlock) > $aTimeout)
EndFunc   ;==>UseSkillEx
#EndRegion Misc


#Region Queries
#Region Item
;~ Description: Returns a weapon or shield's minimum required attribute.
Func GetItemReq($aItem)
	Local $lMod = GetModByIdentifier($aItem, "9827")
	Return $lMod[0]
EndFunc   ;==>GetItemReq

;~ Description: Returns a weapon or shield's required attribute.
Func GetItemAttribute($aItem)
	Local $lMod = GetModByIdentifier($aItem, "9827")
	Return $lMod[1]
EndFunc   ;==>GetItemAttribute

;~ Description: Returns an array of a the requested mod.
Func GetModByIdentifier($aItem, $aIdentifier)
	Local $aItem = ItemID($aItem)
	Local $lReturn[2]
	Local $lString = StringTrimLeft(GetModStruct($aItem), 2)
	For $i = 0 To StringLen($lString) / 8 - 2
		If StringMid($lString, 8 * $i + 5, 4) == $aIdentifier Then
			$lReturn[0] = Int("0x" & StringMid($lString, 8 * $i + 1, 2))
			$lReturn[1] = Int("0x" & StringMid($lString, 8 * $i + 3, 2))
			ExitLoop
		EndIf
	Next
	Return $lReturn
EndFunc   ;==>GetModByIdentifier

;~ Description: Returns modstruct of an item.
Func GetModStruct($aItem)
	Local $lItemPtr = 0

    If IsPtr($aItem) Then
        $lItemPtr = $aItem
    Else
        $lItemPtr = GetItemPtr($aItem)
    EndIf
	If $lItemPtr = 0 Then Return 0

	Local $lModStructPtr = GetItemInfoByPtr($lItemPtr, "ModStruct")
    If $lModStructPtr = 0 Then Return 0

	Local $lModStructSize = GetItemInfoByPtr($lItemPtr, "ModStructSize")
    If $lModStructSize = 0 Then Return 0

	Return MemoryRead($lModStructPtr, 'Byte[' & $lModStructSize * 4 & ']')
EndFunc   ;==>GetModStruct

Func CheckArea($aX, $aY, $range = 1320)
	$ret = False
	$pX = GetAgentInfo(-2, "X")
    $pY = GetAgentInfo(-2, "Y")

	If ($pX < $aX + $range) And ($pX > $aX - $range) And ($pY < $aY + $range) And ($pY > $aY - $range) Then
		$ret = True
	EndIf
	Return $ret
EndFunc   ;==>CheckAreaRange

Func Disconnected()
	Local $lCheck = False
	Local $lDeadlock = TimerInit()
	Do
		Sleep(20)
		$lCheck = GetInstanceInfo("Type") <> 2 And GetAgentExists(-2)
	Until $lCheck Or TimerDiff($lDeadlock) > 5000
	If $lCheck = False Then
;~ 		Out("Disconnected!")
;~ 		Out("Attempting to reconnect.")
		ControlSend($mGWWindowHandle, "", "", "{Enter}")
		$lDeadlock = TimerInit()
		Do
			Sleep(20)
			$lCheck = GetInstanceInfo("Type") <> 2 And GetAgentExists(-2)
		Until $lCheck Or TimerDiff($lDeadlock) > 60000
		If $lCheck = False Then
;~ 			Out("Failed to Reconnect 1!")
;~ 			Out("Retrying.")
			ControlSend($mGWWindowHandle, "", "", "{Enter}")
			$lDeadlock = TimerInit()
			Do
				Sleep(20)
				$lCheck = GetInstanceInfo("Type") <> 2 And GetAgentExists(-2)
			Until $lCheck Or TimerDiff($lDeadlock) > 60000
			If $lCheck = False Then
;~ 				Out("Failed to Reconnect 2!")
;~ 				Out("Retrying.")
				ControlSend($mGWWindowHandle, "", "", "{Enter}")
				$lDeadlock = TimerInit()
				Do
					Sleep(20)
					$lCheck = GetInstanceInfo("Type") <> 2 And GetAgentExists(-2)
				Until $lCheck Or TimerDiff($lDeadlock) > 60000
				If $lCheck = False Then
;~ 					Out("Could not reconnect!")
;~ 					Out("Exiting.")
					EnableRendering()
					Exit 1
				EndIf
			EndIf
		EndIf
	EndIf
	Sleep(5000)
EndFunc   ;==>Disconnected

Func GetBestTarget($aRange = 1320)
	Local $lBestTarget, $lDistance, $lLowestSum = 100000000
	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		Local $lSumDistances = 0
		If GetAgentInfo($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If GetAgentInfo($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If GetAgentInfo($lAgentArray[$i], 'ID') = GetMyID() Then ContinueLoop
		If GetDistance($lAgentArray[$i]) > $aRange Then ContinueLoop
		For $j = 1 To $lAgentArray[0]
			If GetAgentInfo($lAgentArray[$j], 'Allegiance') <> 3 Then ContinueLoop
			If GetAgentInfo($lAgentArray[$j], 'HP') <= 0 Then ContinueLoop
			If GetAgentInfo($lAgentArray[$j], 'ID') = GetMyID() Then ContinueLoop
			If GetDistance($lAgentArray[$j]) > $aRange Then ContinueLoop
			$lDistance = GetDistance($lAgentArray[$i], $lAgentArray[$j])
			$lSumDistances += $lDistance
		Next
		If $lSumDistances < $lLowestSum Then
			$lLowestSum = $lSumDistances
			$lBestTarget = $lAgentArray[$i]
		EndIf
	Next
	Return $lBestTarget
EndFunc   ;==>GetBestTarget

#Region "Town and Party Management"
; Function to handle resignation and returning to outpost.
Func ResignAndReturn()
	Resign()
	If GetPartyDefeated() Then
		Sleep(1000)
		ReturnToOutpost()
		Return WaitMapLoading(-1, 0)
	EndIf
EndFunc   ;==>ResignAndReturn
#EndRegion "Town and Party Management"

;~ Description: Returns World struct. (from 0 to 8)
Func GetWorldInfoByID($aWorldID)
    Local $lWorldStructAddress = $mWorldConst + (0x30 * $aWorldID)

    DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lWorldStructAddress, 'ptr', DllStructGetPtr($g_WorldStruct), 'int', DllStructGetSize($g_WorldStruct), 'int', '')

    Return $g_WorldStruct
EndFunc   ;==>GetWorldInfoByID
