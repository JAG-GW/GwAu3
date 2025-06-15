#include-once

#Region Module Constants
; Attribute module specific constants
Global Const $ATTRIBUTE_MIN_VALUE = 0
Global Const $ATTRIBUTE_MAX_VALUE = 12
Global Const $ATTRIBUTE_MAJOR_MAX = 16

; Guild Wars attribute IDs (complete list)
; Core Professions
Global Const $ATTR_FAST_CASTING = 0
Global Const $ATTR_ILLUSION = 1
Global Const $ATTR_DOMINATION = 2
Global Const $ATTR_INSPIRATION = 3
Global Const $ATTR_BLOOD = 4
Global Const $ATTR_DEATH = 5
Global Const $ATTR_SOUL_REAPING = 6
Global Const $ATTR_CURSES = 7
Global Const $ATTR_AIR = 8
Global Const $ATTR_EARTH = 9
Global Const $ATTR_FIRE = 10
Global Const $ATTR_WATER = 11
Global Const $ATTR_ENERGY_STORAGE = 12
Global Const $ATTR_HEALING = 13
Global Const $ATTR_SMITING = 14
Global Const $ATTR_PROTECTION = 15
Global Const $ATTR_DIVINE_FAVOR = 16
Global Const $ATTR_STRENGTH = 17
Global Const $ATTR_AXE = 18
Global Const $ATTR_HAMMER = 19
Global Const $ATTR_SWORDSMANSHIP = 20
Global Const $ATTR_TACTICS = 21
Global Const $ATTR_BEAST_MASTERY = 22
Global Const $ATTR_EXPERTISE = 23
Global Const $ATTR_WILDERNESS = 24
Global Const $ATTR_MARKSMANSHIP = 25

; Factions Professions
Global Const $ATTR_DAGGER_MASTERY = 29
Global Const $ATTR_DEADLY_ARTS = 30
Global Const $ATTR_SHADOW_ARTS = 31
Global Const $ATTR_COMMUNING = 32
Global Const $ATTR_RESTORATION_MAGIC = 33
Global Const $ATTR_CHANNELING_MAGIC = 34
Global Const $ATTR_CRITICAL_STRIKES = 35
Global Const $ATTR_SPAWNING_POWER = 36

; Nightfall Professions
Global Const $ATTR_SPEAR_MASTERY = 37
Global Const $ATTR_COMMAND = 38
Global Const $ATTR_MOTIVATION = 39
Global Const $ATTR_LEADERSHIP = 40
Global Const $ATTR_SCYTHE_MASTERY = 41
Global Const $ATTR_WIND_PRAYERS = 42
Global Const $ATTR_EARTH_PRAYERS = 43
Global Const $ATTR_MYSTICISM = 44

; Attribute operation results
Global Const $ATTR_RESULT_SUCCESS = 0
Global Const $ATTR_RESULT_INVALID_ID = 1
Global Const $ATTR_RESULT_INVALID_VALUE = 2
Global Const $ATTR_RESULT_NO_POINTS = 3
Global Const $ATTR_RESULT_MAX_REACHED = 4

; Attribute name lookup table
Global $g_aAttributeNames[45] = [ _
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

Func GwAu3_AttributeMod_GetAttributeName($iAttributeID)
    If $iAttributeID >= 0 And $iAttributeID < 45 Then
        Return $g_aAttributeNames[$iAttributeID]
    EndIf
    Return "Unknown"
EndFunc

Func GwAu3_AttributeMod_GetLastModified()
    Local $result[2] = [$g_iLastAttributeModified, $g_iLastAttributeValue]
    Return $result
EndFunc

Func GwAu3_AttributeMod_GetAttributePtr($aAttributeID)
	Local $lAttributeStructAddress = $g_mAttributeInfo + (0x14 * $aAttributeID)
	Return Ptr($lAttributeStructAddress)
EndFunc

Func GwAu3_AttributeMod_GetAttributeInfo($aAttributeID, $aInfo = "")
    Local $lPtr = _AttributeMod_GetAttributePtr($aAttributeID)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "ProfessionID"
			Return GwAu3_Memory_Read($lPtr, "long")
		Case "AttributeID"
			Return GwAu3_Memory_Read($lPtr + 0x4, "long")
		Case "NameID"
			Return GwAu3_Memory_Read($lPtr + 0x8, "long")
		Case "DescID"
			Return GwAu3_Memory_Read($lPtr + 0xC, "long")
		Case "IsPVE"
			Return GwAu3_Memory_Read($lPtr + 0x10, "long")
	EndSwitch

	Return 0
EndFunc

Func GwAu3_AttributeMod_GetPartyAttributeInfo($aAttributeID, $aHeroNumber = 0, $aInfo = "")
	Local $lAgentID
	If $aHeroNumber <> 0 Then
		$lAgentID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		$lAgentID = GwAu3_OtherMod_GetWorldInfo("MyID")
	EndIf
    Local $lBuffer
    Local $lOffset[5]
    $lOffset[0] = 0
    $lOffset[1] = 0x18
    $lOffset[2] = 0x2C
    $lOffset[3] = 0xAC

    For $i = 0 To GwAu3_OtherMod_GetWorldInfo("PartyAttributeArraySize")
        $lOffset[4] = 0x43C * $i
        $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)

        If $lBuffer[1] == $lAgentID Then
            Local $lBaseAttrOffset = 0x43C * $i + 0x14 * $aAttributeID + 0x4

            Switch $aInfo
                Case "ID"
                    $lOffset[4] = $lBaseAttrOffset
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "BaseLevel", "LevelBase"
                    $lOffset[4] = $lBaseAttrOffset + 0x4
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "Level", "CurrentLevel"
                    $lOffset[4] = $lBaseAttrOffset + 0x8
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "DecrementPoints"
                    $lOffset[4] = $lBaseAttrOffset + 0xC
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "IncrementPoints"
                    $lOffset[4] = $lBaseAttrOffset + 0x10
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "HasAttribute"
                    $lOffset[4] = $lBaseAttrOffset
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] <> 0
                Case "BonusLevel"
                    $lOffset[4] = $lBaseAttrOffset + 0x4
                    Local $baseLevel = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)[1]
                    $lOffset[4] = $lBaseAttrOffset + 0x8
                    Local $currentLevel = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)[1]
                    Return $currentLevel - $baseLevel
                Case "IsMaxed"
                    $lOffset[4] = $lBaseAttrOffset + 0x8
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] >= 12
                Case "IsRaisable"
                    $lOffset[4] = $lBaseAttrOffset + 0x10
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] > 0
                Case "IsDecreasable"
                    $lOffset[4] = $lBaseAttrOffset + 0xC
                    $lBuffer = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] > 0
                Case Else
                    Return 0
            EndSwitch
        EndIf
    Next
    Return 0
EndFunc

Func GwAu3_AttributeMod_GetProfPrimaryAttribute($aProfession)
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
EndFunc