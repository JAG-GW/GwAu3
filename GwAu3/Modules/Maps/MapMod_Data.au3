#include-once

Func GwAu3_MapMod_GetRegion()
	Return GwAu3_Memory_Read($g_mRegion)
EndFunc

Func GwAu3_MapMod_GetLastMoveCoords()
    Local $aCoords[2] = [$g_fLastMoveX, $g_fLastMoveY]
    Return $aCoords
EndFunc

Func GwAu3_MapMod_GetClickCoords()
    Local $aCoords[2]
    $aCoords[0] = GwAu3_Memory_Read($g_mClickCoordsX, 'float')
    $aCoords[1] = GwAu3_Memory_Read($g_mClickCoordsY, 'float')
    Return $aCoords
EndFunc

#Region Instance Related
Func GwAu3_MapMod_GetInstanceInfo($aInfo = "")
	If $aInfo = "" Then Return 0
	Local $lOffset[1] = [0x4]
	Local $lResult = GwAu3_Memory_ReadPtr($g_mInstanceInfo, $lOffset, "dword")

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

#Region Character Context Related
Func GwAu3_MapMod_GetCharacterContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x44]
    Local $lCharPtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "ptr")
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
