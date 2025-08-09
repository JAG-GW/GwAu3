#include-once

#Region Observer Match Related
Func Match_GetObserverMatchPtr($a_i_MatchNumber = 0)
    Local $l_ai_Offset[4] = [0, 0x18, 0x44, 0x24C]
    Local $l_ap_MatchPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Local $l_p_Ptr = $l_ap_MatchPtr[1]
    Return Memory_Read($l_p_Ptr + ($a_i_MatchNumber * 4), "ptr")
EndFunc

Func Match_GetObserverMatchInfo($a_i_MatchNumber = 0, $a_s_Info = "")
    Local $l_p_Ptr = Match_GetObserverMatchPtr($a_i_MatchNumber)
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "MatchID"
            Return Memory_Read($l_p_Ptr + 0x0, "long")
        Case "MatchIDDup"
            Return Memory_Read($l_p_Ptr + 0x4, "long")
        Case "MapID"
            Return Memory_Read($l_p_Ptr + 0x8, "long")
        Case "Age"
            Return Memory_Read($l_p_Ptr + 0xC, "long")
        Case "Type"
            Return Memory_Read($l_p_Ptr + 0x10, "long")
        Case "Reserved"
            Return Memory_Read($l_p_Ptr + 0x14, "long")
        Case "Version"
            Return Memory_Read($l_p_Ptr + 0x18, "long")
        Case "State"
            Return Memory_Read($l_p_Ptr + 0x1C, "long")
        Case "Level"
            Return Memory_Read($l_p_Ptr + 0x20, "long")
        Case "Config1"
            Return Memory_Read($l_p_Ptr + 0x24, "long")
        Case "Config2"
            Return Memory_Read($l_p_Ptr + 0x28, "long")
        Case "Score1"
            Return Memory_Read($l_p_Ptr + 0x2C, "long")
        Case "Score2"
            Return Memory_Read($l_p_Ptr + 0x30, "long")
        Case "Score3"
            Return Memory_Read($l_p_Ptr + 0x34, "long")
        Case "Stat1"
            Return Memory_Read($l_p_Ptr + 0x38, "long")
        Case "Stat2"
            Return Memory_Read($l_p_Ptr + 0x3C, "long")
        Case "Data1"
            Return Memory_Read($l_p_Ptr + 0x40, "long")
        Case "Data2"
            Return Memory_Read($l_p_Ptr + 0x44, "long")
        Case "TeamNamesPtr"
            Return Memory_Read($l_p_Ptr + 0x48, "ptr")
        Case "Team1Name"
            Local $l_p_TeamNamesPtr = Memory_Read($l_p_Ptr + 0x48, "ptr")
            Return Match_CleanTeamName(Memory_Read($l_p_TeamNamesPtr, "wchar[256]"))
        Case "TeamNames2Ptr"
            Return Memory_Read($l_p_Ptr + 0x74, "ptr")
        Case "Team2Name"
            Local $l_p_TeamNames2Ptr = Memory_Read($l_p_Ptr + 0x74, "ptr")
            Return Match_CleanTeamName(Memory_Read($l_p_TeamNames2Ptr, "wchar[256]"))

    EndSwitch

    Return 0
EndFunc

Func Match_CleanTeamName($a_s_Name)
    $a_s_Name = StringRegExpReplace($a_s_Name, "^[\x{0100}-\x{024F}\x{0B00}-\x{0B7F}]+", "")
    $a_s_Name = StringRegExpReplace($a_s_Name, "[\x00-\x1F]+", "")
    $a_s_Name = StringStripWS($a_s_Name, $STR_STRIPLEADING + $STR_STRIPTRAILING)
    Return $a_s_Name
EndFunc
#EndRegion Observer Match Related
