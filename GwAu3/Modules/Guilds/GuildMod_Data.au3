#include-once

#Region Guild Context
Func GwAu3_GuildMod_GetGuildContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x3C]
    Local $lGuildPtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lGuildPtr[1]
EndFunc

Func GwAu3_GuildMod_GetMyGuildInfo($aInfo = "")
    Local $lPtr = _GuildMod_GetGuildContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "PlayerName"
            Return GwAu3_Memory_Read($lPtr + 0x34, "wchar[20]")
        Case "PlayerGuildIndex"
            Return GwAu3_Memory_Read($lPtr + 0x60, "long")
        Case "PlayerGuildRank"
            Return GwAu3_Memory_Read($lPtr + 0x2A0, "long")
        Case "Announcement"
            Return GwAu3_Memory_Read($lPtr + 0x78, "wchar[256]")
        Case "AnnouncementAuthor"
            Return GwAu3_Memory_Read($lPtr + 0x278, "wchar[20]")

		Case "TownAlliance"
			Return GwAu3_Memory_Read($lPtr + 0x2A8, "ptr")
		Case "TownAllianceSize"
			Return GwAu3_Memory_Read($lPtr + 0x2A8 + 0x8, "long")

        Case "KurzickTownCount"
            Return GwAu3_Memory_Read($lPtr + 0x2B8, "long")
        Case "LuxonTownCount"
            Return GwAu3_Memory_Read($lPtr + 0x2BC, "long")

		Case "GuildRosterPtr"
			Return GwAu3_Memory_Read($lPtr + 0x358, "ptr")
        Case "GuildRosterSize"
            Return GwAu3_Memory_Read($lPtr + 0x358 + 0x8, "long")

        Case "GuildArrayPtr"
            Return GwAu3_Memory_Read($lPtr + 0x2F8, "ptr")
        Case "GuildArraySize"
            Return GwAu3_Memory_Read($lPtr + 0x2F8 + 0x8, "long")

        Case "GuildHistoryPtr"
            Return GwAu3_Memory_Read($lPtr + 0x2CC, "ptr")
        Case "GuildHistorySize"
            Return GwAu3_Memory_Read($lPtr + 0x2CC + 0x8, "long")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_GuildMod_GetGuildPlayerInfo($aPlayerIndex, $aInfo = "")
    Local $rosterDataPtr = _GuildMod_GetMyGuildInfo("GuildRosterPtr")
    Local $rosterSize = _GuildMod_GetMyGuildInfo("GuildRosterSize")

    If $rosterDataPtr = 0 Or $aPlayerIndex < 0 Or $aPlayerIndex >= $rosterSize Then Return 0

    Local $playerPtr = GwAu3_Memory_Read($rosterDataPtr + ($aPlayerIndex * 4), "ptr")
    If $playerPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "InvitedName"
            Return GwAu3_Memory_Read($playerPtr + 0x8, "wchar[20]")

        Case "CurrentName"
            Return GwAu3_Memory_Read($playerPtr + 0x30, "wchar[20]")

        Case "InviterName"
            Return GwAu3_Memory_Read($playerPtr + 0x58, "wchar[20]")

        Case "InviteTime"
            Return GwAu3_Memory_Read($playerPtr + 0x80, "long")

        Case "PromoterName"
            Return GwAu3_Memory_Read($playerPtr + 0x84, "wchar[20]")

        Case "Offline"
            Return GwAu3_Memory_Read($playerPtr + 0xDC, "long")

        Case "MemberType"
            Return GwAu3_Memory_Read($playerPtr + 0xE0, "long")

        Case "Status"
            Return GwAu3_Memory_Read($playerPtr + 0xE4, "long")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_GuildMod_GetGuildHistoryEvent($aEventIndex, $aInfo = "")
    Local $HistoryDataPtr = _GuildMod_GetMyGuildInfo("GuildHistoryPtr")
    Local $HistorySize = _GuildMod_GetMyGuildInfo("GuildHistorySize")

    If $HistoryDataPtr = 0 Or $aEventIndex < 0 Or $aEventIndex >= $HistorySize Then Return 0

    Local $eventPtr = GwAu3_Memory_Read($HistoryDataPtr + ($aEventIndex * 4), "ptr")
    If $eventPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Time1"
            Return GwAu3_Memory_Read($eventPtr, "long")

        Case "Time2"
            Return GwAu3_Memory_Read($eventPtr + 0x4, "long")

        Case "Name"
            Return GwAu3_Memory_Read($eventPtr + 0x8, "wchar[256]")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_GuildMod_GetTownAllianceInfo($aAllianceIndex, $aInfo = "")
	Local $townAlliancesPtr = _GuildMod_GetMyGuildInfo("TownAlliance")
    Local $townAlliancesSize = _GuildMod_GetMyGuildInfo("TownAllianceSize")

	If $townAlliancesPtr = 0 Or $aAllianceIndex < 0 Or $aAllianceIndex >= $townAlliancesSize Then Return 0

    Local $alliancePtr = GwAu3_Memory_Read($townAlliancesPtr + ($aAllianceIndex * 4), "ptr")
    If $alliancePtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Rank"
            Return GwAu3_Memory_Read($alliancePtr, "long")
        Case "Allegiance"
            Return GwAu3_Memory_Read($alliancePtr + 0x4, "long")
        Case "Faction"
            Return GwAu3_Memory_Read($alliancePtr + 0x8, "long")
        Case "Name"
            Return GwAu3_Memory_Read($alliancePtr + 0xC, "wchar[32]")
        Case "Tag"
            Return GwAu3_Memory_Read($alliancePtr + 0x4C, "wchar[5]")
        Case "CapeBackgroundColor"
            Return GwAu3_Memory_Read($alliancePtr + 0x58, "long")
        Case "CapeDetailColor"
            Return GwAu3_Memory_Read($alliancePtr + 0x5C, "long")
        Case "CapeEmblemColor"
            Return GwAu3_Memory_Read($alliancePtr + 0x60, "long")
        Case "CapeShape"
            Return GwAu3_Memory_Read($alliancePtr + 0x64, "long")
        Case "CapeDetail"
            Return GwAu3_Memory_Read($alliancePtr + 0x68, "long")
        Case "CapeEmblem"
            Return GwAu3_Memory_Read($alliancePtr + 0x6C, "long")
        Case "CapeTrim"
            Return GwAu3_Memory_Read($alliancePtr + 0x70, "long")
        Case "MapID"
            Return GwAu3_Memory_Read($alliancePtr + 0x74, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Guild Context
