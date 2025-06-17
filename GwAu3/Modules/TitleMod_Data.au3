#include-once

#Region Title Related
Global Enum $GC_E_TITLEID_HERO, $GC_E_TITLEID_TYRIAN_CARTO, $GC_E_TITLEID_CANTHAN_CARTO, $GC_E_TITLEID_GLADIATOR, $GC_E_TITLEID_CHAMPION, $GC_E_TITLEID_KURZICK, $GC_E_TITLEID_LUXON, $GC_E_TITLEID_DRUNKARD, _
    $GC_E_TITLEID_DEPRECATED_SKILL_HUNTER, _ ; Pre hard mode update version
    $GC_E_TITLEID_SURVIVOR, $GC_E_TITLEID_KOABD, _
    $GC_E_TITLEID_DEPRECATED_TREASURE_HUNTER, _ ; Old title, non-account bound
    $GC_E_TITLEID_DEPRECATED_WISDOM, _ ; Old title, non-account bound
    $GC_E_TITLEID_PROTECTOR_TYRIA, $GC_E_TITLEID_PROTECTOR_CANTHA, $GC_E_TITLEID_LUCKY, $GC_E_TITLEID_UNLUCKY, $GC_E_TITLEID_SUNSPEAR, $GC_E_TITLEID_ELONIAN_CARTO, _
    $GC_E_TITLEID_PROTECTOR_ELONA, $GC_E_TITLEID_LIGHTBRINGER, $GC_E_TITLEID_LDOA, $GC_E_TITLEID_COMMANDER, $GC_E_TITLEID_GAMER, _
    $GC_E_TITLEID_SKILL_HUNTER_TYRIA, $GC_E_TITLEID_VANQUISHER_TYRIA, $GC_E_TITLEID_SKILL_HUNTER_CANTHA, _
    $GC_E_TITLEID_VANQUISHER_CANTHA, $GC_E_TITLEID_SKILL_HUNTER_ELONA, $GC_E_TITLEID_VANQUISHER_ELONA, _
    $GC_E_TITLEID_LEGENDARY_CARTO, $GC_E_TITLEID_LEGENDARY_GUARDIAN, $GC_E_TITLEID_LEGENDARY_SKILL_HUNTER, _
    $GC_E_TITLEID_LEGENDARY_VANQUISHER, $GC_E_TITLEID_SWEETS, $GC_E_TITLEID_GUARDIAN_TYRIA, $GC_E_TITLEID_GUARDIAN_CANTHA, _
    $GC_E_TITLEID_GUARDIAN_ELONA, $GC_E_TITLEID_ASURAN, $GC_E_TITLEID_DELDRIMOR, $GC_E_TITLEID_VANGUARD, $GC_E_TITLEID_NORN, $GC_E_TITLEID_MASTER_OF_THE_NORTH, _
    $GC_E_TITLEID_PARTY, $GC_E_TITLEID_ZAISHEN, $GC_E_TITLEID_TREASURE_HUNTER, $GC_E_TITLEID_WISDOM, $GC_E_TITLEID_CODEX, $GC_E_TITLEID_NONE = 0xff

Func GwAu3_TitleMod_GetTitleInfo($a_i_Title = 0, $a_s_Info = "")
    Local $l_p_Ptr = GwAu3_OtherMod_GetWorldInfo("TitleArray")
    Local $l_i_Size = GwAu3_OtherMod_GetWorldInfo("TitleArraySize")
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