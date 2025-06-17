#include-once

#Region Party Context
Func GwAu3_PartyMod_GetPartyContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x4C]
    Local $lPartyPtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $lOffset, 'ptr')
    Return $lPartyPtr[1]
EndFunc

Func GwAu3_PartyMod_GetPartyContextInfo($aInfo = "")
    Local $lPtr = GwAu3_PartyMod_GetPartyContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Flags"
            Return GwAu3_Memory_Read($lPtr + 0x14, "long")
        Case "IsHardMode"
            Local $flags = GwAu3_Memory_Read($lPtr + 0x14, "long")
            Return BitAND($flags, 0x10) <> 0
        Case "IsDefeated"
            Local $flags = GwAu3_Memory_Read($lPtr + 0x14, "long")
            Return BitAND($flags, 0x20) <> 0
        Case "IsPartyLeader"
            Local $flags = GwAu3_Memory_Read($lPtr + 0x14, "long")
            Return BitAND(BitShift($flags, 7), 1) <> 0
		Case "IsWaitingForMission"
			Local $flags = GwAu3_Memory_Read($lPtr + 0x14, "long")
            Return BitAND($flags, 0x8) <> 0


        Case "MyPartyPtr"
            Return GwAu3_Memory_Read($lPtr + 0x54, "ptr")

;~         Case "PlayerPartyID"
;~             Local $partyPtr = GwAu3_Memory_Read($lPtr + 0x54, "ptr")
;~             Return GwAu3_Memory_Read($partyPtr, "long")

;~         Case "PlayerCount"
;~             Local $partyPtr = GwAu3_Memory_Read($lPtr + 0x54, "ptr")
;~             Return GwAu3_Memory_Read($partyPtr + 0xC, "long")

;~         Case "HenchmenCount"
;~             Local $partyPtr = GwAu3_Memory_Read($lPtr + 0x54, "ptr")
;~             Return GwAu3_Memory_Read($partyPtr + 0x1C, "long")

;~         Case "HeroCount"
;~             Local $partyPtr = GwAu3_Memory_Read($lPtr + 0x54, "ptr")
;~             Return GwAu3_Memory_Read($partyPtr + 0x2C, "long")

;~         Case "OtherCount" ; Spirit, Minions, Pets (not the Spirits and Minions of heroes, only your character)
;~             Local $partyPtr = GwAu3_Memory_Read($lPtr + 0x54, "ptr")
;~             Return GwAu3_Memory_Read($partyPtr + 0x3C, "long")

;~         Case "TotalPartySize"
;~             Local $playerCount = GetPartyInfo("PlayerCount")
;~             Local $henchmenCount = GetPartyInfo("HenchmenCount")
;~             Local $heroCount = GwAu3_PartyMod_GetMyPartyInfo("ArrayHeroPartyMemberSize")
;~             Return $playerCount + $henchmenCount + $heroCount

    EndSwitch
    Return 0
EndFunc

Func GwAu3_PartyMod_GetMyPartyInfo($aInfo = "")
    Local $partyPtr = GwAu3_PartyMod_GetPartyContextInfo("MyPartyPtr")
    If $partyPtr = 0 Or $aInfo = "" Then Return 0

	Switch $aInfo
		Case "PartyID"
			Return GwAu3_Memory_Read($partyPtr, "long")
		Case "ArrayPlayerPartyMember"
			Return GwAu3_Memory_Read($partyPtr + 0x4, "ptr")
		Case "ArrayPlayerPartyMemberSize"
			Return GwAu3_Memory_Read($partyPtr + 0xC, "long")

		Case "ArrayHenchmanPartyMember"
			Return GwAu3_Memory_Read($partyPtr + 0x14, "ptr")
		Case "ArrayHenchmanPartyMemberSize"
			Return GwAu3_Memory_Read($partyPtr + 0x1C, "long")

		Case "ArrayHeroPartyMember"
			Return GwAu3_Memory_Read($partyPtr + 0x24, "ptr")
		Case "ArrayHeroPartyMemberSize"
			Return GwAu3_Memory_Read($partyPtr + 0x2C, "long")

		Case "ArrayOthersPartyMember"
			Return GwAu3_Memory_Read($partyPtr + 0x34, "ptr")
		Case "ArrayOthersPartyMemberSize"
			Return GwAu3_Memory_Read($partyPtr + 0x3C, "long")
	EndSwitch

	Return 0
EndFunc

Func GwAu3_PartyMod_GetMyPartyPlayerMemberInfo($aPartyMemberNumber = 1, $aInfo = "")
    Local $lPlayerPartyPtr = GwAu3_PartyMod_GetMyPartyInfo("ArrayPlayerPartyMember")
	Local $lPlayerPartySize = GwAu3_PartyMod_GetMyPartyInfo("ArrayPlayerPartyMemberSize")
	$aPartyMemberNumber = $aPartyMemberNumber - 1
	If $lPlayerPartyPtr = 0 Or $aPartyMemberNumber < 0 Or $aPartyMemberNumber >= $lPlayerPartySize Then Return 0

    Local $playerPtr = $lPlayerPartyPtr + ($aPartyMemberNumber * 0xC)
    If $playerPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "LoginNumber"
            Return GwAu3_Memory_Read($playerPtr, "long")

        Case "CalledTargetID"
            Return GwAu3_Memory_Read($playerPtr + 0x4, "long")

        Case "State"
            Return GwAu3_Memory_Read($playerPtr + 0x8, "long")

        Case "IsConnected"
            Local $state = GwAu3_Memory_Read($playerPtr + 0x8, "long")
            Return BitAND($state, 1) <> 0

        Case "IsTicked"
            Local $state = GwAu3_Memory_Read($playerPtr + 0x8, "long")
            Return BitAND($state, 2) <> 0
    EndSwitch

    Return 0
EndFunc

Func GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber = 1, $aInfo = "", $aIncludeOtherHeroPlayers = False)
    Local $lPlayerPartyPtr = GwAu3_PartyMod_GetMyPartyInfo("ArrayHeroPartyMember")
    Local $lPlayerPartySize = GwAu3_PartyMod_GetMyPartyInfo("ArrayHeroPartyMemberSize")

    If $lPlayerPartyPtr = 0 Or $aHeroNumber < 1 Or $aHeroNumber > $lPlayerPartySize Then Return 0

    If $aIncludeOtherHeroPlayers Then
        $aHeroNumber = $aHeroNumber - 1
        Local $lHeroPtr = $lPlayerPartyPtr + ($aHeroNumber * 0x18)
    Else
        Local $lPlayerNumber = GwAu3_MapMod_GetCharacterInfo("PlayerNumber")
		Local $lMatchedCount = 0
        Local $lHeroPtr = 0
        If $lPlayerNumber = 0 Then Return 0

        For $i = 0 To $lPlayerPartySize - 1
            Local $lCurrentHeroPtr = $lPlayerPartyPtr + ($i * 0x18)
            Local $lOwnerPlayerNumber = GwAu3_Memory_Read($lCurrentHeroPtr + 0x4, "long")

            If $lOwnerPlayerNumber = $lPlayerNumber Then
                $lMatchedCount += 1
                If $lMatchedCount = $aHeroNumber Then
                    $lHeroPtr = $lCurrentHeroPtr
                    ExitLoop
                EndIf
            EndIf
        Next

        If $lHeroPtr = 0 Then Return 0
	EndIf

	Switch $aInfo
		Case "AgentID"
			Return GwAu3_Memory_Read($lHeroPtr, "long")
		Case "OwnerPlayerNumber"
			If Not $aIncludeOtherHeroPlayers Then Return $lOwnerPlayerNumber
			Return GwAu3_Memory_Read($lHeroPtr + 0x4, "long")
		Case "HeroID"
			Return GwAu3_Memory_Read($lHeroPtr + 0x8, "long")
		Case "Level"
			Return GwAu3_Memory_Read($lHeroPtr + 0x14, "long")
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>_PartyMod_GetMyPartyHeroInfo

Func GwAu3_PartyMod_GetMyPartyHenchmanInfo($aHenchmanNumber = 1, $aInfo = "")
    Local $lPlayerPartyPtr = GwAu3_PartyMod_GetMyPartyInfo("ArrayHenchmanPartyMember")
	Local $lPlayerPartySize = GwAu3_PartyMod_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
	$aHenchmanNumber = $aHenchmanNumber - 1
	If $lPlayerPartyPtr = 0 Or $aHenchmanNumber < 0 Or $aHenchmanNumber >= $lPlayerPartySize Then Return 0

    Local $henchmanPtr = $lPlayerPartyPtr + ($aHenchmanNumber * 0x34)
    If $henchmanPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "AgentID"
            Return GwAu3_Memory_Read($henchmanPtr, "long")

        Case "Profession"
            Return GwAu3_Memory_Read($henchmanPtr + 0x2C, "long")

        Case "Level"
            Return GwAu3_Memory_Read($henchmanPtr + 0x30, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Party Context

#Region Party Morale Related
Func GwAu3_PartyMod_GetMoraleInfo($aAgentID = -2, $aInfo = "")
    Local $lAgentID = GwAu3_AgentMod_ConvertID($aAgentID)

    Local $lOffset[4] = [0, 0x18, 0x2C, 0x638]
    Local $lIndex = GwAu3_Memory_ReadPtr($g_p_BasePointer, $lOffset)

    ReDim $lOffset[6]
    $lOffset[3] = 0x62C
    $lOffset[4] = 8 + 0xC * BitAND($lAgentID, $lIndex[1])
    $lOffset[5] = 0x18
    Local $lReturn = GwAu3_Memory_ReadPtr($g_p_BasePointer, $lOffset)

    If Not IsArray($lReturn) Or $lReturn[0] = 0 Then Return 0

    Switch $aInfo
        Case "Morale"
            Return $lReturn[1] - 100
        Case "RawMorale"
            Return $lReturn[1]
        Case "IsMaxMorale"
            Return ($lReturn[1] >= 110)
		Case "IsMinMorale"
            Return ($lReturn[1] <= 40)
        Case "IsMoraleBoost"
            Return ($lReturn[1] > 100)
        Case "IsMoralePenalty"
            Return ($lReturn[1] < 100)
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion  Party Morale Related

#Region Party Profession Related
Func GwAu3_PartyMod_GetPartyProfessionInfo($aAgentID = 0, $aInfo = "")
	Local $lPtr = GwAu3_OtherMod_GetWorldInfo("PartyProfessionArray")
	Local $lSize = GwAu3_OtherMod_GetWorldInfo("PartyProfessionArraySize")
	Local $lAgentPtr = 0

	For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x14)
        If GwAu3_Memory_Read($lAgentEffectsPtr, "dword") = GwAu3_AgentMod_ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

	If $lAgentPtr = 0 Then Return 0

	Switch $aInfo
        Case "AgentID"
            Return GwAu3_Memory_Read($lAgentPtr, "dword")
        Case "Primary"
            Return GwAu3_Memory_Read($lAgentPtr + 0x4, "dword")
		Case "Secondary"
            Return GwAu3_Memory_Read($lAgentPtr + 0x8, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion  Party Profession Related

#Region Pet Related
Func GwAu3_PartyMod_GetPetInfo($aPetNumber = 0, $aInfo = "")
	Local $lPetPtr = GwAu3_OtherMod_GetWorldInfo("PetInfoArray")
	Local $lPetSize = GwAu3_OtherMod_GetWorldInfo("PetInfoArraySize")
	$aPetNumber = $aPetNumber - 1
	If $lPetPtr = 0 Or $aPetNumber < 0 Or $aPetNumber >= $lPetSize Then Return 0

    $lPetPtr = $lPetPtr + ($aPetNumber * 0x1C)
    If $lPetPtr = 0 Or $aInfo = "" Then Return 0

	Switch $aInfo
        Case "AgentID"
            Return GwAu3_Memory_Read($lPetPtr, "dword")
        Case "OwnerAgentID"
            Return GwAu3_Memory_Read($lPetPtr + 0x4, "dword")
        Case "PetNamePtr"
            Return GwAu3_Memory_Read($lPetPtr + 0x8, "ptr")
        Case "PetName"
            Local $namePtr = GwAu3_Memory_Read($lPetPtr + 0x8, "ptr")
            If $namePtr > 0x10000 Then
                Return GwAu3_Memory_Read($namePtr, "wchar[32]")
            Else
                Return "Unknown"
            EndIf
        Case "ModelFileID1"
            Return GwAu3_Memory_Read($lPetPtr + 0xC, "dword")
        Case "ModelFileID2"
            Return GwAu3_Memory_Read($lPetPtr + 0x10, "dword")
        Case "Behavior"
            Return GwAu3_Memory_Read($lPetPtr + 0x14, "dword")
        Case "LockedTargetID"
            Return GwAu3_Memory_Read($lPetPtr + 0x18, "dword")
        Case "IsFighting"
            Return GwAu3_Memory_Read($lPetPtr + 0x14, "dword") = 0
        Case "IsGuarding"
            Return GwAu3_Memory_Read($lPetPtr + 0x14, "dword") = 1
        Case "IsAvoiding"
            Return GwAu3_Memory_Read($lPetPtr + 0x14, "dword") = 2
        Case "HasLockedTarget"
            Return GwAu3_Memory_Read($lPetPtr + 0x18, "dword") <> 0
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion Pet Related

#Region Controlled Minion Related
Func GwAu3_PartyMod_GetControlledMinionsInfo($aAgentID = 0, $aInfo = "")
	Local $lPtr = GwAu3_OtherMod_GetWorldInfo("ControlledMinionsArray")
	Local $lSize = GwAu3_OtherMod_GetWorldInfo("ControlledMinionsArraySize")
	Local $lAgentPtr = 0

	For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x8)
        If GwAu3_Memory_Read($lAgentEffectsPtr, "dword") = GwAu3_AgentMod_ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

	If $lAgentPtr = 0 Then Return 0

	Switch $aInfo
        Case "AgentID"
            Return GwAu3_Memory_Read($lAgentPtr, "dword")
        Case "MinionCount"
            Return GwAu3_Memory_Read($lAgentPtr + 0x4, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion

#Region Hero Related
Func GwAu3_PartyMod_GetHeroFlagInfo($aHeroNumber = 1, $aInfo = "")
	Local $lPtr = GwAu3_OtherMod_GetWorldInfo("HeroFlagArray")
	Local $lSize = GwAu3_OtherMod_GetWorldInfo("HeroFlagArraySize")
	If $lPtr = 0 Or $aHeroNumber < 1 Or $aHeroNumber >= $lSize Then Return 0

	local $lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	If $lHeroID = 0 Then Return 0

	Local $lReadHeroID, $lHeroFlagPtr
	For $i = 0 To $lSize - 1
		$lHeroFlagPtr = $lPtr + (0x24 * $i)
		$lReadHeroID = GwAu3_Memory_Read($lHeroFlagPtr + 0x4, "dword")
		If $lHeroFlagPtr <> 0 And $lReadHeroID = $lHeroID Then ExitLoop
	Next
	If $lHeroFlagPtr = 0 Or $lReadHeroID <> $lHeroID Then Return 0

	Switch $aInfo
		Case "HeroID"
			Return GwAu3_Memory_Read($lHeroFlagPtr, "dword")
		Case "AgentID"
			Return GwAu3_Memory_Read($lHeroFlagPtr + 0x4, "dword")
		Case "Level"
			Return GwAu3_Memory_Read($lHeroFlagPtr + 0x8, "dword")
		Case "Behavior"
			Return GwAu3_Memory_Read($lHeroFlagPtr + 0xC, "dword")
		Case "FlagX"
			Return GwAu3_Memory_Read($lHeroFlagPtr + 0x10, "float")
		Case "FlagY"
			Return GwAu3_Memory_Read($lHeroFlagPtr + 0x14, "float")
		Case "LockedTargetID"
			Return GwAu3_Memory_Read($lHeroFlagPtr + 0x20, "dword")
	EndSwitch

	Return 0
EndFunc

Func GwAu3_PartyMod_GetHeroInfo($aHeroNumber = 1, $aInfo = "")
	Local $lPtr = GwAu3_OtherMod_GetWorldInfo("HeroInfoArray")
	Local $lSize = GwAu3_OtherMod_GetWorldInfo("HeroInfoArraySize")
	If $lPtr = 0 Or $aHeroNumber < 1 Or $aHeroNumber >= $lSize Then Return 0

	local $lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	If $lHeroID = 0 Then Return 0

	Local $lReadHeroID, $lHeroPtr
	For $i = 0 To $lSize - 1
		$lHeroPtr = $lPtr + (0x78 * $i)
		$lReadHeroID = GwAu3_Memory_Read($lHeroPtr + 0x4, "dword")
		If $lHeroPtr <> 0 And $lReadHeroID = $lHeroID Then ExitLoop
	Next
	If $lHeroPtr = 0 Or $lReadHeroID <> $lHeroID Then Return 0

    Switch $aInfo
        Case "HeroID"
            Return GwAu3_Memory_Read($lHeroPtr, "dword")
        Case "AgentID"
            Return GwAu3_Memory_Read($lHeroPtr + 0x4, "dword")
        Case "Level"
            Return GwAu3_Memory_Read($lHeroPtr + 0x8, "dword")
        Case "Primary"
            Return GwAu3_Memory_Read($lHeroPtr + 0xC, "dword")
        Case "Secondary"
            Return GwAu3_Memory_Read($lHeroPtr + 0x10, "dword")
        Case "HeroFileID"
            Return GwAu3_Memory_Read($lHeroPtr + 0x14, "dword")
        Case "ModelFileID"
            Return GwAu3_Memory_Read($lHeroPtr + 0x18, "dword")
        Case "Name"
;~ 			Local $lname = GwAu3_Memory_Read($lHeroPtr + 0x50, "ptr")
;~ 			Return GwAu3_Memory_Read($lname, "char[20]")
            Return GwAu3_Memory_Read($lHeroPtr + 0x50, "wchar[24]")
    EndSwitch

    Return 0
EndFunc
#EndRegion Hero Related
