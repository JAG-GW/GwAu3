#include-once

#Region Account Related
Func GwAu3_Account_GetAccountInfo($a_s_Info = "")
    Local $l_p_Ptr = GwAu3_Account_GetWorldInfo("AccountInfo")
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AccountName"
            Local $l_p_Name = GwAu3_Memory_Read($l_p_Ptr, "ptr")
            Return GwAu3_Memory_Read($l_p_Name, "wchar[32]")
        Case "Wins"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x4, "dword")
        Case "Losses"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x8, "dword")
        Case "Rating"
            Return GwAu3_Memory_Read($l_p_Ptr + 0xC, "dword")
        Case "QualifierPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x10, "dword")
        Case "Rank"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x14, "dword")
        Case "TournamentRewardPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x18, "dword")
    EndSwitch

    Return 0
EndFunc
#EndRegion Account Related