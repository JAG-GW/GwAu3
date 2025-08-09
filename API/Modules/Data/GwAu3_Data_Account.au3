#include-once

#Region Account Related
Func Account_GetAccountInfo($a_s_Info = "")
    Local $l_p_Ptr = World_GetWorldInfo("AccountInfo")
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AccountName"
            Local $l_p_Name = Memory_Read($l_p_Ptr, "ptr")
            Return Memory_Read($l_p_Name, "wchar[32]")
        Case "Wins"
            Return Memory_Read($l_p_Ptr + 0x4, "dword")
        Case "Losses"
            Return Memory_Read($l_p_Ptr + 0x8, "dword")
        Case "Rating"
            Return Memory_Read($l_p_Ptr + 0xC, "dword")
        Case "QualifierPoints"
            Return Memory_Read($l_p_Ptr + 0x10, "dword")
        Case "Rank"
            Return Memory_Read($l_p_Ptr + 0x14, "dword")
        Case "TournamentRewardPoints"
            Return Memory_Read($l_p_Ptr + 0x18, "dword")
    EndSwitch

    Return 0
EndFunc
#EndRegion Account Related