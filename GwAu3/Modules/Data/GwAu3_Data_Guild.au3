#include-once

#Region Guild Context
Func Guild_GetGuildContextPtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x3C]
    Local $l_ap_GuildPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_GuildPtr[1]
EndFunc

Func Guild_GetMyGuildInfo($a_s_Info = "")
    Local $l_p_Ptr = Guild_GetGuildContextPtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "PlayerName"
            Return Memory_Read($l_p_Ptr + 0x34, "wchar[20]")
        Case "PlayerGuildIndex"
            Return Memory_Read($l_p_Ptr + 0x60, "long")
        Case "PlayerGuildRank"
            Return Memory_Read($l_p_Ptr + 0x2A0, "long")
        Case "Announcement"
            Return Memory_Read($l_p_Ptr + 0x78, "wchar[256]")
        Case "AnnouncementAuthor"
            Return Memory_Read($l_p_Ptr + 0x278, "wchar[20]")

        Case "TownAlliance"
            Return Memory_Read($l_p_Ptr + 0x2A8, "ptr")
        Case "TownAllianceSize"
            Return Memory_Read($l_p_Ptr + 0x2A8 + 0x8, "long")

        Case "KurzickTownCount"
            Return Memory_Read($l_p_Ptr + 0x2B8, "long")
        Case "LuxonTownCount"
            Return Memory_Read($l_p_Ptr + 0x2BC, "long")

        Case "GuildRosterPtr"
            Return Memory_Read($l_p_Ptr + 0x358, "ptr")
        Case "GuildRosterSize"
            Return Memory_Read($l_p_Ptr + 0x358 + 0x8, "long")

        Case "GuildArrayPtr"
            Return Memory_Read($l_p_Ptr + 0x2F8, "ptr")
        Case "GuildArraySize"
            Return Memory_Read($l_p_Ptr + 0x2F8 + 0x8, "long")

        Case "GuildHistoryPtr"
            Return Memory_Read($l_p_Ptr + 0x2CC, "ptr")
        Case "GuildHistorySize"
            Return Memory_Read($l_p_Ptr + 0x2CC + 0x8, "long")
    EndSwitch

    Return 0
EndFunc

Func Guild_GetGuildPlayerInfo($a_i_PlayerIndex, $a_s_Info = "")
    Local $l_p_RosterDataPtr = Guild_GetMyGuildInfo("GuildRosterPtr")
    Local $l_i_RosterSize = Guild_GetMyGuildInfo("GuildRosterSize")

    If $l_p_RosterDataPtr = 0 Or $a_i_PlayerIndex < 0 Or $a_i_PlayerIndex >= $l_i_RosterSize Then Return 0

    Local $l_p_PlayerPtr = Memory_Read($l_p_RosterDataPtr + ($a_i_PlayerIndex * 4), "ptr")
    If $l_p_PlayerPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "InvitedName"
            Return Memory_Read($l_p_PlayerPtr + 0x8, "wchar[20]")

        Case "CurrentName"
            Return Memory_Read($l_p_PlayerPtr + 0x30, "wchar[20]")

        Case "InviterName"
            Return Memory_Read($l_p_PlayerPtr + 0x58, "wchar[20]")

        Case "InviteTime"
            Return Memory_Read($l_p_PlayerPtr + 0x80, "long")

        Case "PromoterName"
            Return Memory_Read($l_p_PlayerPtr + 0x84, "wchar[20]")

        Case "Offline"
            Return Memory_Read($l_p_PlayerPtr + 0xDC, "long")

        Case "MemberType"
            Return Memory_Read($l_p_PlayerPtr + 0xE0, "long")

        Case "Status"
            Return Memory_Read($l_p_PlayerPtr + 0xE4, "long")
    EndSwitch

    Return 0
EndFunc

Func Guild_GetGuildHistoryEvent($a_i_EventIndex, $a_s_Info = "")
    Local $l_p_HistoryDataPtr = Guild_GetMyGuildInfo("GuildHistoryPtr")
    Local $l_i_HistorySize = Guild_GetMyGuildInfo("GuildHistorySize")

    If $l_p_HistoryDataPtr = 0 Or $a_i_EventIndex < 0 Or $a_i_EventIndex >= $l_i_HistorySize Then Return 0

    Local $l_p_EventPtr = Memory_Read($l_p_HistoryDataPtr + ($a_i_EventIndex * 4), "ptr")
    If $l_p_EventPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "Time1"
            Return Memory_Read($l_p_EventPtr, "long")

        Case "Time2"
            Return Memory_Read($l_p_EventPtr + 0x4, "long")

        Case "Name"
            Return Memory_Read($l_p_EventPtr + 0x8, "wchar[256]")
    EndSwitch

    Return 0
EndFunc

Func Guild_GetTownAllianceInfo($a_i_AllianceIndex, $a_s_Info = "")
    Local $l_p_TownAlliancesPtr = Guild_GetMyGuildInfo("TownAlliance")
    Local $l_i_TownAlliancesSize = Guild_GetMyGuildInfo("TownAllianceSize")

    If $l_p_TownAlliancesPtr = 0 Or $a_i_AllianceIndex < 0 Or $a_i_AllianceIndex >= $l_i_TownAlliancesSize Then Return 0

    Local $l_p_AlliancePtr = Memory_Read($l_p_TownAlliancesPtr + ($a_i_AllianceIndex * 4), "ptr")
    If $l_p_AlliancePtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "Rank"
            Return Memory_Read($l_p_AlliancePtr, "long")
        Case "Allegiance"
            Return Memory_Read($l_p_AlliancePtr + 0x4, "long")
        Case "Faction"
            Return Memory_Read($l_p_AlliancePtr + 0x8, "long")
        Case "Name"
            Return Memory_Read($l_p_AlliancePtr + 0xC, "wchar[32]")
        Case "Tag"
            Return Memory_Read($l_p_AlliancePtr + 0x4C, "wchar[5]")
        Case "CapeBackgroundColor"
            Return Memory_Read($l_p_AlliancePtr + 0x58, "long")
        Case "CapeDetailColor"
            Return Memory_Read($l_p_AlliancePtr + 0x5C, "long")
        Case "CapeEmblemColor"
            Return Memory_Read($l_p_AlliancePtr + 0x60, "long")
        Case "CapeShape"
            Return Memory_Read($l_p_AlliancePtr + 0x64, "long")
        Case "CapeDetail"
            Return Memory_Read($l_p_AlliancePtr + 0x68, "long")
        Case "CapeEmblem"
            Return Memory_Read($l_p_AlliancePtr + 0x6C, "long")
        Case "CapeTrim"
            Return Memory_Read($l_p_AlliancePtr + 0x70, "long")
        Case "MapID"
            Return Memory_Read($l_p_AlliancePtr + 0x74, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Guild Context
