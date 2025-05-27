#include-once
#include "MapMod_Initialize.au3"

Func _MapMod_GetRegion()
	Return MemoryRead($g_mRegion)
EndFunc

Func _MapMod_GetLastMoveCoords()
    Local $aCoords[2] = [$g_fLastMoveX, $g_fLastMoveY]
    Return $aCoords
EndFunc

Func _MapMod_GetClickCoords()
    Local $aCoords[2]
    $aCoords[0] = MemoryRead($g_mClickCoordsX, 'float')
    $aCoords[1] = MemoryRead($g_mClickCoordsY, 'float')
    Return $aCoords
EndFunc

#Region Instance Related
Func GetInstanceInfo($aInfo = "")
	If $aInfo = "" Then Return 0
	Local $lOffset[1] = [0x4]
	Local $lResult = MemoryReadPtr($g_mInstanceInfo, $lOffset, "dword")

	Switch $aInfo
		Case "Type"
			Return $lResult[1]
		Case "IsExplorable"
			Return $lResult[1] = 1
		Case "IsLoading"
			Return $lResult[1] = 2
		Case "IsOutpost"
			Return $lResult[1] = 0
	EndSwitch

	Return 0
EndFunc
#EndRegion Instance Related

#Region Area Related
Func GetAreaPtr($aMapID = 0)
    Local $lAreaInfoAddress = $g_mAreaInfo + (0x7C * $aMapID)
    Return Ptr($lAreaInfoAddress)
EndFunc

Func GetAreaInfo($aMapID, $aInfo = "")
    Local $lPtr = GetAreaPtr($aMapID)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Campaign"
            Return MemoryRead($lPtr, "long")
        Case "Continent"
            Return MemoryRead($lPtr + 0x4, "long")
        Case "Region"
            Return MemoryRead($lPtr + 0x8, "long")
        Case "RegionType"
            Return MemoryRead($lPtr + 0xC, "long")
        Case "Flags"
            Return MemoryRead($lPtr + 0x10, "long")
        Case "ThumbnailID"
            Return MemoryRead($lPtr + 0x14, "long")
        Case "MinPartySize"
            Return MemoryRead($lPtr + 0x18, "long")
        Case "MaxPartySize"
            Return MemoryRead($lPtr + 0x1C, "long")
        Case "MinPlayerSize"
            Return MemoryRead($lPtr + 0x20, "long")
        Case "MaxPlayerSize"
            Return MemoryRead($lPtr + 0x24, "long")
        Case "ControlledOutpostID"
            Return MemoryRead($lPtr + 0x28, "long")
        Case "FractionMission"
            Return MemoryRead($lPtr + 0x2C, "long")
        Case "MinLevel"
            Return MemoryRead($lPtr + 0x30, "long")
        Case "MaxLevel"
            Return MemoryRead($lPtr + 0x34, "long")
        Case "NeededPQ"
            Return MemoryRead($lPtr + 0x38, "long")
        Case "MissionMapsTo"
            Return MemoryRead($lPtr + 0x3C, "long")
        Case "X"
            Return MemoryRead($lPtr + 0x40, "long")
        Case "Y"
            Return MemoryRead($lPtr + 0x44, "long")
        Case "IconStartX"
            Return MemoryRead($lPtr + 0x48, "long")
        Case "IconStartY"
            Return MemoryRead($lPtr + 0x4C, "long")
        Case "IconEndX"
            Return MemoryRead($lPtr + 0x50, "long")
        Case "IconEndY"
            Return MemoryRead($lPtr + 0x54, "long")
        Case "IconStartXDupe"
            Return MemoryRead($lPtr + 0x58, "long")
        Case "IconStartYDupe"
            Return MemoryRead($lPtr + 0x5C, "long")
        Case "IconEndXDupe"
            Return MemoryRead($lPtr + 0x60, "long")
        Case "IconEndYDupe"
            Return MemoryRead($lPtr + 0x64, "long")
        Case "FileID"
            Return MemoryRead($lPtr + 0x68, "long")
        Case "MissionChronology"
            Return MemoryRead($lPtr + 0x6C, "long")
        Case "HAMapChronology"
            Return MemoryRead($lPtr + 0x70, "long")
        Case "NameID"
            Return MemoryRead($lPtr + 0x74, "long")
        Case "DescriptionID"
            Return MemoryRead($lPtr + 0x78, "long")


        Case "FileID1"
            Local $fileID = MemoryRead($lPtr + 0x68, "long")
            Return Mod(($fileID - 1), 0xFF00) + 0x100
        Case "FileID2"
            Local $fileID = MemoryRead($lPtr + 0x68, "long")
            Return Int(($fileID - 1) / 0xFF00) + 0x100
        Case "HasEnterButton"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x100) <> 0 Or BitAND($flags, 0x40000) <> 0
        Case "IsOnWorldMap"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x20) = 0
        Case "IsPvP"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x40001) <> 0
        Case "IsGuildHall"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x800000) <> 0
        Case "IsVanquishableArea"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x10000000) <> 0
        Case "IsUnlockable"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x10000) <> 0
        Case "HasMissionMapsTo"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x8000000) <> 0
	EndSwitch

    Return 0
EndFunc
#EndRegion Area Related