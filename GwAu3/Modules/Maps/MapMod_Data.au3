#include-once

Func GwAu3_MapMod_GetRegion()
	Return GwAu3_Memory_Read($g_p_Region)
EndFunc

Func GwAu3_MapMod_GetLastMoveCoords()
    Local $aCoords[2] = [$g_f_LastMoveX, $g_f_LastMoveY]
    Return $aCoords
EndFunc

Func GwAu3_MapMod_GetClickCoords()
    Local $aCoords[2]
    $aCoords[0] = GwAu3_Memory_Read($g_f_ClickCoordsX, 'float')
    $aCoords[1] = GwAu3_Memory_Read($g_f_ClickCoordsY, 'float')
    Return $aCoords
EndFunc

#Region Instance Related
Func GwAu3_MapMod_GetInstanceInfo($aInfo = "")
	If $aInfo = "" Then Return 0
	Local $lOffset[1] = [0x4]
	Local $lResult = GwAu3_Memory_ReadPtr($g_p_InstanceInfo, $lOffset, "dword")

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

Func GwAu3_MapMod_GetCurrentAreaInfo($aInfo = "")
	If $aInfo = "" Then Return 0
	Local $lOffset[1] = [0x8]
	Local $lPtr = GwAu3_Memory_ReadPtr($g_p_InstanceInfo, $lOffset, "dword")

    Switch $aInfo
        Case "Campaign"
            Return MemoryRead($lPtr, "long")
        Case "Continent"
            Return MemoryRead($lPtr + 0x4, "long")
        Case "Region"
            Return MemoryRead($lPtr + 0x8, "long")
        Case "RegionType"
            Return MemoryRead($lPtr + 0xC, "long")
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
	EndSwitch

    Return 0
EndFunc
#EndRegion Instance Related

#Region Character Context Related
Func GwAu3_MapMod_GetCharacterContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x44]
    Local $lCharPtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $lOffset, "ptr")
    Return $lCharPtr[1]
EndFunc

Func GwAu3_MapMod_GetCharacterInfo($aInfo = "")
    Local $lPtr = GwAu3_MapMod_GetCharacterContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "PlayerUUID"
            Local $uuid[4]
            For $i = 0 To 3
                $uuid[$i] = GwAu3_Memory_Read($lPtr + 0x64 + ($i * 4), "long")
            Next
            Return $uuid
        Case "PlayerName"
            Return GwAu3_Memory_Read($lPtr + 0x74, "wchar[20]")
		Case "WorldFlags"
            Return GwAu3_Memory_Read($lPtr + 0x190, "long")
		Case "Token1" ; World ID
            Return GwAu3_Memory_Read($lPtr + 0x194, "long")
		Case "MapID"
            Return GwAu3_Memory_Read($lPtr + 0x198, "long")
		Case "IsExplorable"
            Return GwAu3_Memory_Read($lPtr + 0x19C, "long")
		Case "Token2" ; Player ID
            Return GwAu3_Memory_Read($lPtr + 0x1B8, "long")
		Case "DistrictNumber"
            Return GwAu3_Memory_Read($lPtr + 0x220, "long")
		Case "Language"
            Return GwAu3_Memory_Read($lPtr + 0x224, "long")
		Case "Region"
			Return GwAu3_Memory_Read($mRegion)
        Case "ObserveMapID"
            Return GwAu3_Memory_Read($lPtr + 0x228, "long")
        Case "CurrentMapID"
            Return GwAu3_Memory_Read($lPtr + 0x22C, "long")
        Case "ObserveMapType"
            Return GwAu3_Memory_Read($lPtr + 0x230, "long")
        Case "CurrentMapType"
            Return GwAu3_Memory_Read($lPtr + 0x234, "long")
		Case "ObserverMatch"
			Return GwAu3_Memory_Read($lPtr + 0x24C, "ptr")
        Case "PlayerFlags"
            Return GwAu3_Memory_Read($lPtr + 0x2A0, "long")
        Case "PlayerNumber"
            Return GwAu3_Memory_Read($lPtr + 0x2A4, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Character Context Related
