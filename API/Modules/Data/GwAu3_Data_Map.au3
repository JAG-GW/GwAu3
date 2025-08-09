#include-once

;~ Returns how long the current instance has been active, in milliseconds.
Func Map_GetInstanceUpTime()
    Local $l_ai_Offset[4] = [0, 0x18, 0x8, 0x1AC]
    Local $l_av_Timer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Timer[1]
EndFunc   ;==>GetInstanceUpTime

Func Map_GetRegion()
    Return Memory_Read($g_p_Region)
EndFunc

Func Map_GetLastMoveCoords()
    Local $l_af_Coords[2] = [$g_f_LastMoveX, $g_f_LastMoveY]
    Return $l_af_Coords
EndFunc

Func Map_GetClickCoords()
    Local $l_af_Coords[2]
    $l_af_Coords[0] = Memory_Read($g_f_ClickCoordsX, 'float')
    $l_af_Coords[1] = Memory_Read($g_f_ClickCoordsY, 'float')
    Return $l_af_Coords
EndFunc

#Region Instance Related
Func Map_GetInstanceInfo($a_s_Info = "")
    If $a_s_Info = "" Then Return 0
    Local $l_ai_Offset[1] = [0x4]
    Local $l_av_Result = Memory_ReadPtr($g_p_InstanceInfo, $l_ai_Offset, "dword")

    Switch $a_s_Info
        Case "Type"
            Return $l_av_Result[1]
        Case "IsExplorable"
            Return $l_av_Result[1] = 1
        Case "IsLoading"
            Return $l_av_Result[1] = 2
        Case "IsOutpost"
            Return $l_av_Result[1] = 0
    EndSwitch

    Return 0
EndFunc

Func Map_GetCurrentAreaInfo($a_s_Info = "")
    If $a_s_Info = "" Then Return 0
    Local $l_ai_Offset[1] = [0x8]
    Local $l_av_Result = Memory_ReadPtr($g_p_InstanceInfo, $l_ai_Offset, "ptr")
    Local $l_p_Ptr = $l_av_Result[1]

    Switch $a_s_Info
        Case "Campaign"
            Return Memory_Read($l_p_Ptr, "long")
        Case "Continent"
            Return Memory_Read($l_p_Ptr + 0x4, "long")
        Case "Region"
            Return Memory_Read($l_p_Ptr + 0x8, "long")
        Case "RegionType"
            Return Memory_Read($l_p_Ptr + 0xC, "long")
        Case "ThumbnailID"
            Return Memory_Read($l_p_Ptr + 0x14, "long")
        Case "MinPartySize"
            Return Memory_Read($l_p_Ptr + 0x18, "long")
        Case "MaxPartySize"
            Return Memory_Read($l_p_Ptr + 0x1C, "long")
        Case "MinPlayerSize"
            Return Memory_Read($l_p_Ptr + 0x20, "long")
        Case "MaxPlayerSize"
            Return Memory_Read($l_p_Ptr + 0x24, "long")
        Case "ControlledOutpostID"
            Return Memory_Read($l_p_Ptr + 0x28, "long")
        Case "FractionMission"
            Return Memory_Read($l_p_Ptr + 0x2C, "long")
        Case "MinLevel"
            Return Memory_Read($l_p_Ptr + 0x30, "long")
        Case "MaxLevel"
            Return Memory_Read($l_p_Ptr + 0x34, "long")
        Case "NeededPQ"
            Return Memory_Read($l_p_Ptr + 0x38, "long")
        Case "MissionMapsTo"
            Return Memory_Read($l_p_Ptr + 0x3C, "long")
        Case "X"
            Return Memory_Read($l_p_Ptr + 0x40, "long")
        Case "Y"
            Return Memory_Read($l_p_Ptr + 0x44, "long")
        Case "IconStartX"
            Return Memory_Read($l_p_Ptr + 0x48, "long")
        Case "IconStartY"
            Return Memory_Read($l_p_Ptr + 0x4C, "long")
        Case "IconEndX"
            Return Memory_Read($l_p_Ptr + 0x50, "long")
        Case "IconEndY"
            Return Memory_Read($l_p_Ptr + 0x54, "long")
        Case "IconStartXDupe"
            Return Memory_Read($l_p_Ptr + 0x58, "long")
        Case "IconStartYDupe"
            Return Memory_Read($l_p_Ptr + 0x5C, "long")
        Case "IconEndXDupe"
            Return Memory_Read($l_p_Ptr + 0x60, "long")
        Case "IconEndYDupe"
            Return Memory_Read($l_p_Ptr + 0x64, "long")
        Case "FileID"
            Return Memory_Read($l_p_Ptr + 0x68, "long")
        Case "MissionChronology"
            Return Memory_Read($l_p_Ptr + 0x6C, "long")
        Case "HAMapChronology"
            Return Memory_Read($l_p_Ptr + 0x70, "long")
        Case "NameID"
            Return Memory_Read($l_p_Ptr + 0x74, "long")
        Case "DescriptionID"
            Return Memory_Read($l_p_Ptr + 0x78, "long")
    EndSwitch

    Return 0
EndFunc

Func Map_GetCurrentRegionType()
	Local $l_i_RegionType = Map_GetCurrentAreaInfo("RegionType")

	Switch $l_i_RegionType
		Case 0
			Return "Alliance Battle"
		Case 1
			Return "Arena"
		Case 2
			Return "Explorable"
		Case 3
			Return "Guild Battle"
		Case 4
			Return "Guild Hall"
		Case 5
			Return "Mission Outpost"
		Case 6
			Return "Cooperative Mission"
		Case 7
			Return "Competitive Mission"
		Case 8
			Return "Elite Mission"
		Case 9
			Return "Challenge"
		Case 10
			Return "Outpost"
		Case 11
			Return "Zaishen Battle"
		Case 12
			Return "Heroes Ascent"
		Case 13
			Return "City"
		Case 14
			Return "Mission"
		Case 15
			Return "Hero Battle Outpost"
		Case 16
			Return "Hero Battle Area"
		Case 17
			Return "Eotn Mission"
		Case 18
			Return "Dungeon"
		Case 19
			Return "Marketplace"
		Case 20
			Return "Unknown 20"
		Case 21
			Return "Dev Region"
		Case Else
			Return "Unknown Else"
	EndSwitch
EndFunc
#EndRegion Instance Related

#Region Character Context Related
Func Map_GetCharacterContextPtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x44]
    Local $l_ap_CharPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_CharPtr[1]
EndFunc

Func Map_GetCharacterInfo($a_s_Info = "")
    Local $l_p_Ptr = Map_GetCharacterContextPtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "PlayerUUID"
            Local $l_ai_UUID[4]
            For $l_i_Idx = 0 To 3
                $l_ai_UUID[$l_i_Idx] = Memory_Read($l_p_Ptr + 0x64 + ($l_i_Idx * 4), "long")
            Next
            Return $l_ai_UUID
        Case "PlayerName"
            Return Memory_Read($l_p_Ptr + 0x74, "wchar[20]")
        Case "WorldFlags"
            Return Memory_Read($l_p_Ptr + 0x190, "long")
        Case "Token1" ; World ID
            Return Memory_Read($l_p_Ptr + 0x194, "long")
        Case "MapID"
            Return Memory_Read($l_p_Ptr + 0x198, "long")
        Case "IsExplorable"
            Return Memory_Read($l_p_Ptr + 0x19C, "long")
        Case "Token2" ; Player ID
            Return Memory_Read($l_p_Ptr + 0x1B8, "long")
        Case "DistrictNumber"
            Return Memory_Read($l_p_Ptr + 0x220, "long")
        Case "Language"
            Return Memory_Read($l_p_Ptr + 0x224, "long")
        Case "Region"
            Return Memory_Read($g_p_Region)
        Case "ObserveMapID"
            Return Memory_Read($l_p_Ptr + 0x228, "long")
        Case "CurrentMapID"
            Return Memory_Read($l_p_Ptr + 0x22C, "long")
        Case "ObserveMapType"
            Return Memory_Read($l_p_Ptr + 0x230, "long")
        Case "CurrentMapType"
            Return Memory_Read($l_p_Ptr + 0x234, "long")
        Case "ObserverMatch"
            Return Memory_Read($l_p_Ptr + 0x24C, "ptr")
        Case "PlayerFlags"
            Return Memory_Read($l_p_Ptr + 0x2A0, "long")
        Case "PlayerNumber"
            Return Memory_Read($l_p_Ptr + 0x2A4, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Character Context Related

;~ Description: Returns current MapID
Func Map_GetMapID()
    Return Map_GetCharacterInfo("MapID")
EndFunc   ;==>GetMapID

#Region Area Related
Func Map_GetAreaPtr($aMapID = 0)
    Local $lAreaInfoAddress = $g_p_AreaInfo + (0x7C * $aMapID)
    Return Ptr($lAreaInfoAddress)
EndFunc

Func Map_GetAreaInfo($aMapID, $aInfo = "")
    Local $lPtr = Map_GetAreaPtr($aMapID)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Campaign"
            Return Memory_Read($lPtr, "long")
        Case "Continent"
            Return Memory_Read($lPtr + 0x4, "long")
        Case "Region"
            Return Memory_Read($lPtr + 0x8, "long")
        Case "RegionType"
            Return Memory_Read($lPtr + 0xC, "long")
        Case "Flags"
            Return Memory_Read($lPtr + 0x10, "long")
        Case "ThumbnailID"
            Return Memory_Read($lPtr + 0x14, "long")
        Case "MinPartySize"
            Return Memory_Read($lPtr + 0x18, "long")
        Case "MaxPartySize"
            Return Memory_Read($lPtr + 0x1C, "long")
        Case "MinPlayerSize"
            Return Memory_Read($lPtr + 0x20, "long")
        Case "MaxPlayerSize"
            Return Memory_Read($lPtr + 0x24, "long")
        Case "ControlledOutpostID"
            Return Memory_Read($lPtr + 0x28, "long")
        Case "FractionMission"
            Return Memory_Read($lPtr + 0x2C, "long")
        Case "MinLevel"
            Return Memory_Read($lPtr + 0x30, "long")
        Case "MaxLevel"
            Return Memory_Read($lPtr + 0x34, "long")
        Case "NeededPQ"
            Return Memory_Read($lPtr + 0x38, "long")
        Case "MissionMapsTo"
            Return Memory_Read($lPtr + 0x3C, "long")
        Case "X"
            Return Memory_Read($lPtr + 0x40, "long")
        Case "Y"
            Return Memory_Read($lPtr + 0x44, "long")
        Case "IconStartX"
            Return Memory_Read($lPtr + 0x48, "long")
        Case "IconStartY"
            Return Memory_Read($lPtr + 0x4C, "long")
        Case "IconEndX"
            Return Memory_Read($lPtr + 0x50, "long")
        Case "IconEndY"
            Return Memory_Read($lPtr + 0x54, "long")
        Case "IconStartXDupe"
            Return Memory_Read($lPtr + 0x58, "long")
        Case "IconStartYDupe"
            Return Memory_Read($lPtr + 0x5C, "long")
        Case "IconEndXDupe"
            Return Memory_Read($lPtr + 0x60, "long")
        Case "IconEndYDupe"
            Return Memory_Read($lPtr + 0x64, "long")
        Case "FileID"
            Return Memory_Read($lPtr + 0x68, "long")
        Case "MissionChronology"
            Return Memory_Read($lPtr + 0x6C, "long")
        Case "HAMapChronology"
            Return Memory_Read($lPtr + 0x70, "long")
        Case "NameID"
            Return Memory_Read($lPtr + 0x74, "long")
        Case "DescriptionID"
            Return Memory_Read($lPtr + 0x78, "long")


        Case "FileID1"
            Local $fileID = Memory_Read($lPtr + 0x68, "long")
            Return Mod(($fileID - 1), 0xFF00) + 0x100
        Case "FileID2"
            Local $fileID = Memory_Read($lPtr + 0x68, "long")
            Return Int(($fileID - 1) / 0xFF00) + 0x100
        Case "HasEnterButton"
            Local $flags = Memory_Read($lPtr + 0x10, "long")
            Return BitAND($flags, 0x100) <> 0 Or BitAND($flags, 0x40000) <> 0
        Case "IsOnWorldMap"
            Local $flags = Memory_Read($lPtr + 0x10, "long")
            Return BitAND($flags, 0x20) = 0
        Case "IsPvP"
            Local $flags = Memory_Read($lPtr + 0x10, "long")
            Return BitAND($flags, 0x40001) <> 0
        Case "IsGuildHall"
            Local $flags = Memory_Read($lPtr + 0x10, "long")
            Return BitAND($flags, 0x800000) <> 0
        Case "IsVanquishableArea"
            Local $flags = Memory_Read($lPtr + 0x10, "long")
            Return BitAND($flags, 0x10000000) <> 0
        Case "IsUnlockable"
            Local $flags = Memory_Read($lPtr + 0x10, "long")
            Return BitAND($flags, 0x10000) <> 0
        Case "HasMissionMapsTo"
            Local $flags = Memory_Read($lPtr + 0x10, "long")
            Return BitAND($flags, 0x8000000) <> 0
	EndSwitch

    Return 0
EndFunc
#EndRegion Area Related
