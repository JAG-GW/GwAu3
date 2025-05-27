#include-once
#include "AttributeMod_Initialize.au3"

Func _AttributeMod_GetAttributeName($iAttributeID)
    If $iAttributeID >= 0 And $iAttributeID < 45 Then
        Return $g_aAttributeNames[$iAttributeID]
    EndIf
    Return "Unknown"
EndFunc

Func _AttributeMod_GetLastModified()
    Local $result[2] = [$g_iLastAttributeModified, $g_iLastAttributeValue]
    Return $result
EndFunc

Func _AttributeMod_GetAttributePtr($aAttributeID)
	Local $lAttributeStructAddress = $g_mAttributeInfo + (0x14 * $aAttributeID)
	Return Ptr($lAttributeStructAddress)
EndFunc

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