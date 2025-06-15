#include-once

#Region Observer Match Related
Func GwAu3_MatchMod_GetObserverMatchPtr($aMatchNumber = 0)
    Local $lOffset[4] = [0, 0x18, 0x44, 0x24C]
    Local $lMatchPtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "ptr")
    Local $lPtr = $lMatchPtr[1]
    Return GwAu3_Memory_Read($lPtr + ($aMatchNumber * 4), "ptr")
EndFunc

Func GwAu3_MatchMod_GetObserverMatchInfo($aMatchNumber = 0, $aInfo = "")
	Local $lPtr = _MatchMod_GetObserverMatchPtr($aMatchNumber)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "MatchID"
            Return GwAu3_Memory_Read($lPtr + 0x0, "long")
        Case "MatchIDDup"
            Return GwAu3_Memory_Read($lPtr + 0x4, "long")
        Case "MapID"
            Return GwAu3_Memory_Read($lPtr + 0x8, "long")
        Case "Age"
            Return GwAu3_Memory_Read($lPtr + 0xC, "long")
        Case "Type"
            Return GwAu3_Memory_Read($lPtr + 0x10, "long")
        Case "Reserved"
            Return GwAu3_Memory_Read($lPtr + 0x14, "long")
        Case "Version"
            Return GwAu3_Memory_Read($lPtr + 0x18, "long")
        Case "State"
            Return GwAu3_Memory_Read($lPtr + 0x1C, "long")
        Case "Level"
            Return GwAu3_Memory_Read($lPtr + 0x20, "long")
        Case "Config1"
            Return GwAu3_Memory_Read($lPtr + 0x24, "long")
        Case "Config2"
            Return GwAu3_Memory_Read($lPtr + 0x28, "long")
        Case "Score1"
            Return GwAu3_Memory_Read($lPtr + 0x2C, "long")
        Case "Score2"
            Return GwAu3_Memory_Read($lPtr + 0x30, "long")
        Case "Score3"
            Return GwAu3_Memory_Read($lPtr + 0x34, "long")
        Case "Stat1"
            Return GwAu3_Memory_Read($lPtr + 0x38, "long")
        Case "Stat2"
            Return GwAu3_Memory_Read($lPtr + 0x3C, "long")
        Case "Data1"
            Return GwAu3_Memory_Read($lPtr + 0x40, "long")
        Case "Data2"
            Return GwAu3_Memory_Read($lPtr + 0x44, "long")
        Case "TeamNamesPtr"
            Return GwAu3_Memory_Read($lPtr + 0x48, "ptr")
        Case "Team1Name"
            Local $teamNamesPtr = GwAu3_Memory_Read($lPtr + 0x48, "ptr")
            Return _MatchMod_CleanTeamName(GwAu3_Memory_Read($teamNamesPtr, "wchar[256]"))
        Case "TeamNames2Ptr"
            Return GwAu3_Memory_Read($lPtr + 0x74, "ptr")
        Case "Team2Name"
            Local $teamNames2Ptr = GwAu3_Memory_Read($lPtr + 0x74, "ptr")
            Return _MatchMod_CleanTeamName(GwAu3_Memory_Read($teamNames2Ptr, "wchar[256]"))

    EndSwitch

    Return 0
EndFunc

Func GwAu3_MatchMod_CleanTeamName($name)
    $name = StringRegExpReplace($name, "^[\x{0100}-\x{024F}\x{0B00}-\x{0B7F}]+", "")
    $name = StringRegExpReplace($name, "[\x00-\x1F]+", "")
    $name = StringStripWS($name, $STR_STRIPLEADING + $STR_STRIPTRAILING)
    Return $name
EndFunc
#EndRegion Observer Match Related
