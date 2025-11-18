#include-once

#Region Account Related
Func Account_GetAccountContextPtr()
    Return Game_GetGameInfo("AccountContext")
EndFunc

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

Func Account_IsSkillUnlocked($a_i_SkillID)
    Local $l_p_AccountContext = Account_GetAccountContextPtr()
    If $l_p_AccountContext = 0 Then Return False

    Local $l_p_UnlockedSkillsArray = Memory_Read($l_p_AccountContext + 0x124, "ptr")
    If $l_p_UnlockedSkillsArray = 0 Then Return False

    Local $l_i_ArraySize = Memory_Read($l_p_AccountContext + 0x124 + 0x8, "long")

    Local $l_i_RealIndex = Floor($a_i_SkillID / 32)

    If $l_i_RealIndex >= $l_i_ArraySize Then Return False

    Local $l_i_Shift = Mod($a_i_SkillID, 32)
    Local $l_i_Flag = BitShift(1, -$l_i_Shift)

    Local $l_i_Value = Memory_Read($l_p_UnlockedSkillsArray + ($l_i_RealIndex * 4), "dword")

    Return BitAND($l_i_Value, $l_i_Flag) <> 0
EndFunc
#EndRegion Account Related