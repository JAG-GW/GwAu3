#include-once

#Region Title Related
Func GwAu3_Title_GetTitleInfo($a_i_Title = 0, $a_s_Info = "")
    Local $l_p_Ptr = GwAu3_World_GetWorldInfo("TitleArray")
    Local $l_i_Size = GwAu3_World_GetWorldInfo("TitleArraySize")
    If $l_p_Ptr = 0 Or $a_i_Title < 0 Or $a_i_Title >= $l_i_Size Then Return 0

    $l_p_Ptr = $l_p_Ptr + ($a_i_Title * 0x28)
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "Props"
            Return GwAu3_Memory_Read($l_p_Ptr, "dword")
        Case "CurrentPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x4, "dword")
        Case "CurrentTitleTier"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x8, "dword")
        Case "PointsNeededCurrentRank"
            Return GwAu3_Memory_Read($l_p_Ptr + 0xC, "dword")
        Case "NextTitleTier"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x10, "dword")
        Case "PointsNeededNextRank"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x14, "dword")
        Case "MaxTitleRank"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x18, "dword")
        Case "MaxTitleTier"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x1C, "dword")
    EndSwitch

    Return 0
EndFunc
#EndRegion Title Related