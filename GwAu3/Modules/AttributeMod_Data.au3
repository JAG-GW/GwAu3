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

Func GwAu3_AttributeMod_GetAttributeName($a_i_AttributeID)
    If $a_i_AttributeID >= 0 And $a_i_AttributeID < 45 Then
        Return $g_as_AttributeNames[$a_i_AttributeID]
    EndIf
    Return "Unknown"
EndFunc

Func GwAu3_AttributeMod_GetLastModified()
    Local $l_ai_Result[2] = [$g_i_LastAttributeModified, $g_i_LastAttributeValue]
    Return $l_ai_Result
EndFunc

Func GwAu3_AttributeMod_GetAttributePtr($a_i_AttributeID)
    Local $l_p_AttributeStructAddress = $g_p_AttributeInfo + (0x14 * $a_i_AttributeID)
    Return Ptr($l_p_AttributeStructAddress)
EndFunc

Func GwAu3_AttributeMod_GetAttributeInfo($a_i_AttributeID, $a_s_Info = "")
    Local $l_p_Ptr = GwAu3_AttributeMod_GetAttributePtr($a_i_AttributeID)
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "ProfessionID"
            Return GwAu3_Memory_Read($l_p_Ptr, "long")
        Case "AttributeID"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x4, "long")
        Case "NameID"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x8, "long")
        Case "DescID"
            Return GwAu3_Memory_Read($l_p_Ptr + 0xC, "long")
        Case "IsPVE"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x10, "long")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_AttributeMod_GetPartyAttributeInfo($a_i_AttributeID, $a_i_HeroNumber = 0, $a_s_Info = "")
    Local $l_i_AgentID
    If $a_i_HeroNumber <> 0 Then
        $l_i_AgentID = GwAu3_PartyMod_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Else
        $l_i_AgentID = GwAu3_OtherMod_GetWorldInfo("MyID")
    EndIf
    Local $l_av_Buffer
    Local $l_ai_Offset[5]
    $l_ai_Offset[0] = 0
    $l_ai_Offset[1] = 0x18
    $l_ai_Offset[2] = 0x2C
    $l_ai_Offset[3] = 0xAC

    For $l_i_Idx = 0 To GwAu3_OtherMod_GetWorldInfo("PartyAttributeArraySize")
        $l_ai_Offset[4] = 0x43C * $l_i_Idx
        $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)

        If $l_av_Buffer[1] == $l_i_AgentID Then
            Local $l_i_BaseAttrOffset = 0x43C * $l_i_Idx + 0x14 * $a_i_AttributeID + 0x4

            Switch $a_s_Info
                Case "ID"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "BaseLevel", "LevelBase"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x4
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "Level", "CurrentLevel"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x8
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "DecrementPoints"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0xC
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "IncrementPoints"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x10
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "HasAttribute"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] <> 0
                Case "BonusLevel"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x4
                    Local $l_i_BaseLevel = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)[1]
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x8
                    Local $l_i_CurrentLevel = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)[1]
                    Return $l_i_CurrentLevel - $l_i_BaseLevel
                Case "IsMaxed"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x8
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] >= 12
                Case "IsRaisable"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x10
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] > 0
                Case "IsDecreasable"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0xC
                    $l_av_Buffer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] > 0
                Case Else
                    Return 0
            EndSwitch
        EndIf
    Next
    Return 0
EndFunc

Func GwAu3_AttributeMod_GetProfPrimaryAttribute($a_i_Profession)
    Switch $a_i_Profession
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
EndFunc