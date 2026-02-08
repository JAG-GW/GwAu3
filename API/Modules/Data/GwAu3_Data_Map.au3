#include-once

;~ Returns how long the current instance has been active, in milliseconds.
Func Map_GetInstanceUpTime()
    Local $l_ai_Offset[4] = [0, 0x18, 0x8, 0x1AC]
    Local $l_av_Timer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Timer[1]
EndFunc   ;==>GetInstanceUpTime

;~ Returns the internal time the player has been in the current instance, in seconds.
Func Map_GetTimeOnMap()
    Return Memory_Read($g_p_TimeOnMap, 'float')
EndFunc

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
            Return Utils_MakeInt32(Memory_Read($g_p_Region))
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

;~ Description: Returns True if current MapID is wanted MapID, including event MapIDs
Func Map_IsMap($a_i_MapID)
    Return Map_GetNormalizedMapID() = $a_i_MapID
EndFunc

;~ Description: Returns MapID or normalized MapID in case of an event MapID
Func Map_GetNormalizedMapID()
    Local $l_i_MapID = Map_GetMapID()

    If $l_i_MapID < 808 Or $l_i_MapID > 821 Then Return $l_i_MapID

    Switch $l_i_MapID
        Case $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
            Return $GC_I_MAP_ID_LIONS_ARCH

        Case $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
            Return  $GC_I_MAP_ID_DROKNARS_FORGE

        Case $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS_HALLOWEEN
            Return $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS

        Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
            Return $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN

        Case $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST_WINTERSDAY
            Return $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST

        Case $GC_I_MAP_ID_ASCALON_CITY_WINTERSDAY
            Return $GC_I_MAP_ID_ASCALON_CITY

        Case $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
            Return $GC_I_MAP_ID_SHING_JEA_MONASTERY

        Case $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
            Return $GC_I_MAP_ID_KAINENG_CENTER
    EndSwitch

    Return SetError(1, 0, 0)
EndFunc

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

Func Map_IsMapUnlocked($a_i_MapID)
    Local $l_p_WorldContext = World_GetWorldContextPtr()

    If $l_p_WorldContext = 0 Then Return False

    Local $l_p_ArrayStruct = $l_p_WorldContext + 0x60C
    Local $l_p_ArrayBuffer = Memory_Read($l_p_ArrayStruct, "ptr")
    Local $l_i_ArraySize = Memory_Read($l_p_ArrayStruct + 0x8, "dword")

    If $l_p_ArrayBuffer = 0 Or $l_i_ArraySize = 0 Then Return False

    Local $l_i_RealIndex = Floor($a_i_MapID / 32)

    If $l_i_RealIndex >= $l_i_ArraySize Then Return False

    Local $l_i_Value = Memory_Read($l_p_ArrayBuffer + ($l_i_RealIndex * 4), "dword")
    Local $l_i_Shift = Mod($a_i_MapID, 32)
    Local $l_i_Flag = BitShift(1, -$l_i_Shift) ; 1 << shift

    Return BitAND($l_i_Value, $l_i_Flag) <> 0
EndFunc

; =============================================================================
; Map_IsOutpost - Checks if a map is a valid outpost that can be traveled to
; @param $a_i_MapID: The map ID to check
; @return: True if valid outpost, False otherwise
; =============================================================================
Func Map_IsOutpost($a_i_MapID)
	; Get map info using Map_GetAreaInfo
	Local $l_i_ThumbnailID = Map_GetAreaInfo($a_i_MapID, "ThumbnailID")
	Local $l_i_NameID = Map_GetAreaInfo($a_i_MapID, "NameID")
	Local $l_i_X = Map_GetAreaInfo($a_i_MapID, "X")
	Local $l_i_Y = Map_GetAreaInfo($a_i_MapID, "Y")
	Local $l_i_Flags = Map_GetAreaInfo($a_i_MapID, "Flags")
	Local $l_i_RegionType = Map_GetAreaInfo($a_i_MapID, "RegionType")

	; Check if basic info exists
	If Not $l_i_ThumbnailID Or Not $l_i_NameID Then Return False
	If Not ($l_i_X Or $l_i_Y) Then Return False

	; Check flags - invalid if both 0x5000000 bits are set
	If BitAND($l_i_Flags, 0x5000000) = 0x5000000 Then Return False
	; Check flags - invalid if 0x80000000 bit is set
	If BitAND($l_i_Flags, 0x80000000) = 0x80000000 Then Return False

	; Check RegionType - must be one of the valid outpost types
	; 1 = Arena, 5 = Mission Outpost, 6 = Cooperative Mission, 7 = Competitive Mission
	; 8 = Elite Mission, 9 = Challenge, 10 = Outpost, 13 = City
	Switch $l_i_RegionType
		Case 1, 5, 6, 7, 8, 9, 10, 13, 19
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>Map_IsOutpost
