#include-once

#Region Module Constants
; Attribute module specific constants
Global Const $GC_I_ATTRIBUTE_MIN_VALUE = 0
Global Const $GC_I_ATTRIBUTE_MAX_VALUE = 12
Global Const $GC_I_ATTRIBUTE_MAJOR_MAX = 16

; Guild Wars attribute IDs (complete list)
; Core Professions
Global Const $GC_I_ATTR_FAST_CASTING = 0
Global Const $GC_I_ATTR_ILLUSION = 1
Global Const $GC_I_ATTR_DOMINATION = 2
Global Const $GC_I_ATTR_INSPIRATION = 3
Global Const $GC_I_ATTR_BLOOD = 4
Global Const $GC_I_ATTR_DEATH = 5
Global Const $GC_I_ATTR_SOUL_REAPING = 6
Global Const $GC_I_ATTR_CURSES = 7
Global Const $GC_I_ATTR_AIR = 8
Global Const $GC_I_ATTR_EARTH = 9
Global Const $GC_I_ATTR_FIRE = 10
Global Const $GC_I_ATTR_WATER = 11
Global Const $GC_I_ATTR_ENERGY_STORAGE = 12
Global Const $GC_I_ATTR_HEALING = 13
Global Const $GC_I_ATTR_SMITING = 14
Global Const $GC_I_ATTR_PROTECTION = 15
Global Const $GC_I_ATTR_DIVINE_FAVOR = 16
Global Const $GC_I_ATTR_STRENGTH = 17
Global Const $GC_I_ATTR_AXE = 18
Global Const $GC_I_ATTR_HAMMER = 19
Global Const $GC_I_ATTR_SWORDSMANSHIP = 20
Global Const $GC_I_ATTR_TACTICS = 21
Global Const $GC_I_ATTR_BEAST_MASTERY = 22
Global Const $GC_I_ATTR_EXPERTISE = 23
Global Const $GC_I_ATTR_WILDERNESS = 24
Global Const $GC_I_ATTR_MARKSMANSHIP = 25

; Factions Professions
Global Const $GC_I_ATTR_DAGGER_MASTERY = 29
Global Const $GC_I_ATTR_DEADLY_ARTS = 30
Global Const $GC_I_ATTR_SHADOW_ARTS = 31
Global Const $GC_I_ATTR_COMMUNING = 32
Global Const $GC_I_ATTR_RESTORATION_MAGIC = 33
Global Const $GC_I_ATTR_CHANNELING_MAGIC = 34
Global Const $GC_I_ATTR_CRITICAL_STRIKES = 35
Global Const $GC_I_ATTR_SPAWNING_POWER = 36

; Nightfall Professions
Global Const $GC_I_ATTR_SPEAR_MASTERY = 37
Global Const $GC_I_ATTR_COMMAND = 38
Global Const $GC_I_ATTR_MOTIVATION = 39
Global Const $GC_I_ATTR_LEADERSHIP = 40
Global Const $GC_I_ATTR_SCYTHE_MASTERY = 41
Global Const $GC_I_ATTR_WIND_PRAYERS = 42
Global Const $GC_I_ATTR_EARTH_PRAYERS = 43
Global Const $GC_I_ATTR_MYSTICISM = 44

; Attribute operation results
Global Const $GC_I_ATTR_RESULT_SUCCESS = 0
Global Const $GC_I_ATTR_RESULT_INVALID_ID = 1
Global Const $GC_I_ATTR_RESULT_INVALID_VALUE = 2
Global Const $GC_I_ATTR_RESULT_NO_POINTS = 3
Global Const $GC_I_ATTR_RESULT_MAX_REACHED = 4

; Attribute name lookup table
Global $g_as_AttributeNames[45] = [ _
    "Fast Casting", "Illusion Magic", "Domination Magic", "Inspiration Magic", _
    "Blood Magic", "Death Magic", "Soul Reaping", "Curses", _
    "Air Magic", "Earth Magic", "Fire Magic", "Water Magic", "Energy Storage", _
    "Healing Prayers", "Smiting Prayers", "Protection Prayers", "Divine Favor", _
    "Strength", "Axe Mastery", "Hammer Mastery", "Swordsmanship", "Tactics", _
    "Beast Mastery", "Expertise", "Wilderness Survival", "Marksmanship", _
    "Unknown", "Unknown", "Unknown", _
    "Dagger Mastery", "Deadly Arts", "Shadow Arts", _
    "Communing", "Restoration Magic", "Channeling Magic", _
    "Critical Strikes", "Spawning Power", _
    "Spear Mastery", "Command", "Motivation", "Leadership", _
    "Scythe Mastery", "Wind Prayers", "Earth Prayers", "Mysticism"]
#EndRegion Module Constants
