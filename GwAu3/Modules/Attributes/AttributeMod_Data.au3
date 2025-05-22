#include-once
#include "AttributeMod_Initialize.au3"

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_GetAttributeName
; Description ...: Returns the name of an attribute by its ID
; Syntax.........: _AttributeMod_GetAttributeName($iAttributeID)
; Parameters ....: $iAttributeID - ID of the attribute (0-44)
; Return values .: String name of the attribute, "Unknown" if invalid ID
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Useful for logging and debugging
;                  - Supports all Guild Wars attributes including Factions and Nightfall
; Related .......: _AttributeMod_GetAttributeID
;============================================================================================
Func _AttributeMod_GetAttributeName($iAttributeID)
    If $iAttributeID >= 0 And $iAttributeID < 45 Then
        Return $g_aAttributeNames[$iAttributeID]
    EndIf
    Return "Unknown"
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_GetLastModified
; Description ...: Returns information about the last modified attribute
; Syntax.........: _AttributeMod_GetLastModified()
; Parameters ....: None
; Return values .: Array[2] - [0] = Attribute ID, [1] = Change amount
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Returns [-1, 0] if no attributes have been modified
;                  - Useful for tracking and debugging
; Related .......: _AttributeMod_IncreaseAttribute, _AttributeMod_DecreaseAttribute
;============================================================================================
Func _AttributeMod_GetLastModified()
    Local $result[2] = [$g_iLastAttributeModified, $g_iLastAttributeValue]
    Return $result
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_GetAttributePtr
; Description ...: Returns a pointer to attribute data structure
; Syntax.........: _AttributeMod_GetAttributePtr($aAttributeID)
; Parameters ....: $aAttributeID - ID of the attribute (0-44)
; Return values .: Pointer to attribute data structure
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Each attribute structure is 0x14 bytes in size
;                  - Calculates pointer based on attribute info base address and ID
; Related .......: _AttributeMod_GetAttributeInfo
;============================================================================================
Func _AttributeMod_GetAttributePtr($aAttributeID)
	Local $lAttributeStructAddress = $g_mAttributeInfo + (0x14 * $aAttributeID)
	Return Ptr($lAttributeStructAddress)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_GetAttributeInfo
; Description ...: Retrieves specific information about an attribute
; Syntax.........: _AttributeMod_GetAttributeInfo($aAttributeID, $aInfo = "")
; Parameters ....: $aAttributeID - ID of the attribute to query (0-44)
;                  $aInfo        - Information type to retrieve
; Return values .: The requested attribute information, 0 if invalid
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Available info types: "ProfessionID", "AttributeID", "NameID", "DescID", "IsPVE"
;                  - Returns static attribute information from game data
; Related .......: _AttributeMod_GetPartyAttributeInfo, _AttributeMod_GetAttributePtr
;============================================================================================
Func _AttributeMod_GetAttributeInfo($aAttributeID, $aInfo = "")
    Local $lPtr = _AttributeMod_GetAttributePtr($aAttributeID)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "ProfessionID"
			Return MemoryRead($lPtr, "long")
		Case "AttributeID"
			Return MemoryRead($lPtr + 0x4, "long")
		Case "NameID"
			Return MemoryRead($lPtr + 0x8, "long")
		Case "DescID"
			Return MemoryRead($lPtr + 0xC, "long")
		Case "IsPVE"
			Return MemoryRead($lPtr + 0x10, "long")
	EndSwitch

	Return 0
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_GetPartyAttributeInfo
; Description ...: Retrieves attribute information for party members or heroes
; Syntax.........: _AttributeMod_GetPartyAttributeInfo($aAttributeID, $aHeroNumber = 0, $aInfo = "")
; Parameters ....: $aAttributeID - ID of the attribute to query (0-44)
;                  $aHeroNumber  - [optional] Hero number (0 for player, 1-8 for heroes)
;                  $aInfo        - Information type to retrieve
; Return values .: The requested attribute information, 0 if invalid or not found
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Available info types: "ID", "BaseLevel"/"LevelBase", "Level"/"CurrentLevel",
;                    "DecrementPoints", "IncrementPoints", "HasAttribute", "BonusLevel",
;                    "IsMaxed", "IsRaisable", "IsDecreasable"
;                  - Searches through party attribute array to find matching agent
;                  - BonusLevel = CurrentLevel - BaseLevel (from equipment/temporary effects)
;                  - IsMaxed checks if attribute is at level 12 or higher
;                  - IsRaisable/IsDecreasable check if points are available for modification
; Related .......: _AttributeMod_GetAttributeInfo, GetMyPartyHeroInfo
;============================================================================================
Func _AttributeMod_GetPartyAttributeInfo($aAttributeID, $aHeroNumber = 0, $aInfo = "")
	Local $lAgentID
	If $aHeroNumber <> 0 Then
		$lAgentID = GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		$lAgentID = GetWorldInfo("MyID")
	EndIf
    Local $lBuffer
    Local $lOffset[5]
    $lOffset[0] = 0
    $lOffset[1] = 0x18
    $lOffset[2] = 0x2C
    $lOffset[3] = 0xAC

    For $i = 0 To GetWorldInfo("PartyAttributeArraySize")
        $lOffset[4] = 0x43C * $i
        $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)

        If $lBuffer[1] == $lAgentID Then
            Local $lBaseAttrOffset = 0x43C * $i + 0x14 * $aAttributeID + 0x4

            Switch $aInfo
                Case "ID"
                    $lOffset[4] = $lBaseAttrOffset
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "BaseLevel", "LevelBase"
                    $lOffset[4] = $lBaseAttrOffset + 0x4
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "Level", "CurrentLevel"
                    $lOffset[4] = $lBaseAttrOffset + 0x8
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "DecrementPoints"
                    $lOffset[4] = $lBaseAttrOffset + 0xC
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "IncrementPoints"
                    $lOffset[4] = $lBaseAttrOffset + 0x10
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1]
                Case "HasAttribute"
                    $lOffset[4] = $lBaseAttrOffset
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] <> 0
                Case "BonusLevel"
                    $lOffset[4] = $lBaseAttrOffset + 0x4
                    Local $baseLevel = MemoryReadPtr($mBasePointer, $lOffset)[1]
                    $lOffset[4] = $lBaseAttrOffset + 0x8
                    Local $currentLevel = MemoryReadPtr($mBasePointer, $lOffset)[1]
                    Return $currentLevel - $baseLevel
                Case "IsMaxed"
                    $lOffset[4] = $lBaseAttrOffset + 0x8
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] >= 12
                Case "IsRaisable"
                    $lOffset[4] = $lBaseAttrOffset + 0x10
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] > 0
                Case "IsDecreasable"
                    $lOffset[4] = $lBaseAttrOffset + 0xC
                    $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
                    Return $lBuffer[1] > 0
                Case Else
                    Return 0
            EndSwitch
        EndIf
    Next
    Return 0
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_GetProfPrimaryAttribute
; Description ...: Returns the primary attribute ID for a given profession
; Syntax.........: _AttributeMod_GetProfPrimaryAttribute($aProfession)
; Parameters ....: $aProfession - Profession ID (1-10)
;                                 1=Warrior, 2=Ranger, 3=Monk, 4=Necromancer, 5=Mesmer,
;                                 6=Elementalist, 7=Assassin, 8=Ritualist, 9=Paragon, 10=Dervish
; Return values .: Primary attribute ID for the profession:
;                  Warrior=17 (Strength), Ranger=23 (Expertise), Monk=16 (Divine Favor),
;                  Necromancer=6 (Soul Reaping), Mesmer=0 (Fast Casting),
;                  Elementalist=12 (Energy Storage), Assassin=35 (Critical Strikes),
;                  Ritualist=36 (Spawning Power), Paragon=40 (Leadership),
;                  Dervish=44 (Mysticism)
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Each profession has one unique primary attribute
;                  - Primary attributes cannot be used by other professions
;                  - Returns nothing if invalid profession ID is provided
; Related .......: _AttributeMod_GetAttributeName, _AttributeMod_IncreaseAttribute
;============================================================================================
Func _AttributeMod_GetProfPrimaryAttribute($aProfession)
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