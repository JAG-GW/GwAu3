#include-once

;~ Description: Internal use for BuyItem()
Func GetMerchantItemsBase()
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x24]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetMerchantItemsBase

;~ Description: Internal use for BuyItem()
Func GetMerchantItemsSize()
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x28]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetMerchantItemsSize

;~ Description: Returns current ping.
Func GetPing()
	Return MemoryRead($mPing)
EndFunc   ;==>GetPing

;~ Description: Returns your characters name.
Func GetCharname()
	Return MemoryRead($mCharname, 'wchar[30]')
EndFunc   ;==>GetCharname

;~ Description: Returns if you're logged in.
Func GetLoggedIn()
	Return MemoryRead($mLoggedIn)
EndFunc   ;==>GetLoggedIn

;~ Returns how long the current instance has been active, in milliseconds.
Func GetInstanceUpTime()
	Local $lOffset[4] = [0, 0x18, 0x8, 0x1AC]
	Local $lTimer = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lTimer[1]
EndFunc   ;==>GetInstanceUpTime

Func GetPlayerStatus()
	Return MemoryRead($mCurrentStatus)
EndFunc   ;==>GetPlayerStatus

#Region Instance Related
Func GetInstanceInfo($aInfo = "")
	If $aInfo = "" Then Return 0
	Local $lOffset[1] = [0x4]
	Local $lResult = MemoryReadPtr($mInstanceInfo, $lOffset, "dword")

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

#Region PreGame Context
;~ No need curently
#EndRegion PreGame Context

#Region Map Context
;~ No need curently
#EndRegion Map Context

#Region Agent Context
;~ No need curently
#EndRegion Agent Context

#Region Account Context
;~ No need curently
#EndRegion Account Context

#Region Gadget Context
;~ No need curently
#EndRegion Gadget Context

#Region Game Context Related
Func GetGameContextPtr()
    Local $lOffset[2] = [0, 0x18]
    Local $lGamePtr = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lGamePtr[1]
EndFunc

Func GetGameInfo($aInfo = "")
    Local $lPtr = GetGameContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "AgentContext"
			Return MemoryRead($lPtr + 0x8, "ptr")
		Case "MapContext"
			Return MemoryRead($lPtr + 0x14, "ptr")


		Case "TextParser"
			Return MemoryRead($lPtr + 0x18, "ptr")
		Case "GameLanguage"
			Local $lTextParserPtr = MemoryRead($lPtr + 0x18, "ptr")
			Return MemoryRead($lTextParserPtr + 0x1d0, "dword")


		Case "SomeNumber"
			Return MemoryRead($lPtr + 0x20, "dword")
		Case "AccountContext"
			Return MemoryRead($lPtr + 0x28, "ptr")
		Case "WorldContext"
			Return MemoryRead($lPtr + 0x2C, "ptr")


		Case "Cinematic"
			Return MemoryRead($lPtr + 0x30, "ptr")
		Case "IsCinematic"
			Local $lCinematicPtr = MemoryRead($lPtr + 0x30, "ptr")
			If MemoryRead($lCinematicPtr) <> 0 Or MemoryRead($lCinematicPtr + 0x4) <> 0 Then Return True
			Return False

		Case "GadgetContext"
			Return MemoryRead($lPtr + 0x38, "ptr")
		Case "GuildContext"
			Return MemoryRead($lPtr + 0x3C, "ptr")
		Case "ItemContext"
			Return MemoryRead($lPtr + 0x40, "ptr")
		Case "CharContext"
			Return MemoryRead($lPtr + 0x44, "ptr")
		Case "PartyContext"
			Return MemoryRead($lPtr + 0x4C, "ptr")
		Case "TradeContext"
			Return MemoryRead($lPtr + 0x58, "ptr")
    EndSwitch

    Return 0
EndFunc
#EndRegion Game Context Related

#Region Character Context Related
Func GetCharacterContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x44]
    Local $lCharPtr = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lCharPtr[1]
EndFunc

Func GetCharacterInfo($aInfo = "")
    Local $lPtr = GetCharacterContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "PlayerUUID"
            Local $uuid[4]
            For $i = 0 To 3
                $uuid[$i] = MemoryRead($lPtr + 0x64 + ($i * 4), "long")
            Next
            Return $uuid
        Case "PlayerName"
            Return MemoryRead($lPtr + 0x74, "wchar[20]")
		Case "WorldFlags"
            Return MemoryRead($lPtr + 0x190, "long")
		Case "Token1" ; World ID
            Return MemoryRead($lPtr + 0x194, "long")
		Case "MapID"
            Return MemoryRead($lPtr + 0x198, "long")
		Case "IsExplorable"
            Return MemoryRead($lPtr + 0x19C, "long")
		Case "Token2" ; Player ID
            Return MemoryRead($lPtr + 0x1B8, "long")
		Case "DistrictNumber"
            Return MemoryRead($lPtr + 0x220, "long")
		Case "Language"
            Return MemoryRead($lPtr + 0x224, "long")
		Case "Region"
			Return MemoryRead($mRegion)
        Case "ObserveMapID"
            Return MemoryRead($lPtr + 0x228, "long")
        Case "CurrentMapID"
            Return MemoryRead($lPtr + 0x22C, "long")
        Case "ObserveMapType"
            Return MemoryRead($lPtr + 0x230, "long")
        Case "CurrentMapType"
            Return MemoryRead($lPtr + 0x234, "long")
		Case "ObserverMatch"
			Return MemoryRead($lPtr + 0x24C, "ptr")
        Case "PlayerFlags"
            Return MemoryRead($lPtr + 0x2A0, "long")
        Case "PlayerNumber"
            Return MemoryRead($lPtr + 0x2A4, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Character Context Related

#Region Observer Match Related
Func GetObserverMatchPtr($aMatchNumber = 0)
    Local $lOffset[4] = [0, 0x18, 0x44, 0x24C]
    Local $lMatchPtr = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
    Local $lPtr = $lMatchPtr[1]
    Return MemoryRead($lPtr + ($aMatchNumber * 4), "ptr")
EndFunc

Func GetObserverMatchInfo($aMatchNumber = 0, $aInfo = "")
	Local $lPtr = GetObserverMatchPtr($aMatchNumber)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "MatchID"
            Return MemoryRead($lPtr + 0x0, "long")
        Case "MatchIDDup"
            Return MemoryRead($lPtr + 0x4, "long")
        Case "MapID"
            Return MemoryRead($lPtr + 0x8, "long")
        Case "Age"
            Return MemoryRead($lPtr + 0xC, "long")
        Case "Type"
            Return MemoryRead($lPtr + 0x10, "long")
        Case "Reserved"
            Return MemoryRead($lPtr + 0x14, "long")
        Case "Version"
            Return MemoryRead($lPtr + 0x18, "long")
        Case "State"
            Return MemoryRead($lPtr + 0x1C, "long")
        Case "Level"
            Return MemoryRead($lPtr + 0x20, "long")
        Case "Config1"
            Return MemoryRead($lPtr + 0x24, "long")
        Case "Config2"
            Return MemoryRead($lPtr + 0x28, "long")
        Case "Score1"
            Return MemoryRead($lPtr + 0x2C, "long")
        Case "Score2"
            Return MemoryRead($lPtr + 0x30, "long")
        Case "Score3"
            Return MemoryRead($lPtr + 0x34, "long")
        Case "Stat1"
            Return MemoryRead($lPtr + 0x38, "long")
        Case "Stat2"
            Return MemoryRead($lPtr + 0x3C, "long")
        Case "Data1"
            Return MemoryRead($lPtr + 0x40, "long")
        Case "Data2"
            Return MemoryRead($lPtr + 0x44, "long")
        Case "TeamNamesPtr"
            Return MemoryRead($lPtr + 0x48, "ptr")
        Case "Team1Name"
            Local $teamNamesPtr = MemoryRead($lPtr + 0x48, "ptr")
            Return CleanTeamName(MemoryRead($teamNamesPtr, "wchar[256]"))
        Case "TeamNames2Ptr"
            Return MemoryRead($lPtr + 0x74, "ptr")
        Case "Team2Name"
            Local $teamNames2Ptr = MemoryRead($lPtr + 0x74, "ptr")
            Return CleanTeamName(MemoryRead($teamNames2Ptr, "wchar[256]"))

    EndSwitch

    Return 0
EndFunc

Func CleanTeamName($name)
    $name = StringRegExpReplace($name, "^[\x{0100}-\x{024F}\x{0B00}-\x{0B7F}]+", "")
    $name = StringRegExpReplace($name, "[\x00-\x1F]+", "")
    $name = StringStripWS($name, $STR_STRIPLEADING + $STR_STRIPTRAILING)
    Return $name
EndFunc
#EndRegion Observer Match Related

#Region Trade Context Related
Func GetTradePtr()
    Local $lOffset[3] = [0, 0x18, 0x58]
    Local $lTradePtr = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lTradePtr[1]
EndFunc

Func GetTradeInfo($aInfo = "")
	Local $lPtr = GetTradePtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Flags"
            Return MemoryRead($lPtr, "long")
        Case "IsTradeClosed"
            Local $flags = MemoryRead($lPtr, "long")
            Return BitAND($flags, 0) = 0
        Case "IsTradeInitiated"
            Local $flags = MemoryRead($lPtr, "long")
            Return BitAND($flags, 1) <> 0
        Case "IsPartnerTradeOffered"
            Local $flags = MemoryRead($lPtr, "long")
            Return BitAND($flags, 2) <> 0
		Case "IsPlayerTradeOffered"
            Local $flags = MemoryRead($lPtr, "long")
            Return BitAND($flags, 3) <> 0
		Case "IsPlayerTradeAccepted"
            Local $flags = MemoryRead($lPtr, "long")
            Return BitAND($flags, 7) <> 0

        Case "PlayerGold"
            Return MemoryRead($lPtr + 0x10, "long")
		Case "PlayerItemsPtr"
            Return MemoryRead($lPtr + 0x14, "ptr")
		Case "PlayerItemCount"
            Return MemoryRead($lPtr + 0x1C, "long")

        Case "PartnerGold"
            Return MemoryRead($lPtr + 0x24, "long")
        Case "PartnerItemsPtr"
            Return MemoryRead($lPtr + 0x28, "ptr")
        Case "PartnerItemCount"
            Return MemoryRead($lPtr + 0x30, "long")

    EndSwitch

    Return 0
EndFunc

Func GetPlayerTradeItemsInfo($aTradeSlot = 0, $aInfo = "")
	Local $itemsPtr = GetTradeInfo("PlayerItemsPtr")
    If $itemsPtr = 0 Or $aInfo = "" Then Return 0

	Local $itemCount = GetTradeInfo("PlayerItemCount")
    If $itemCount = 0 Or $aTradeSlot >= $itemCount Then Return 0

    Local $itemPtr = $itemsPtr + ($aTradeSlot * 8)
    Local $itemID = MemoryRead($itemPtr, "long")

    Switch $aInfo
        Case "ItemID"
            Return $itemID
        Case "Quantity"
            Return MemoryRead($itemPtr + 4, "long")
        Case "ModelID"
            Return GetItemInfoByPtr($itemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func GetPartnerTradeItemsInfo($aTradeSlot = 0, $aInfo = "")
	Local $itemsPtr = GetTradeInfo("PartnerItemsPtr")
    If $itemsPtr = 0 Or $aInfo = "" Then Return 0

	Local $itemCount = GetTradeInfo("PartnerItemCount")
    If $itemCount = 0 Or $aTradeSlot >= $itemCount Then Return 0

    Local $itemPtr = $itemsPtr + ($aTradeSlot * 8)
    Local $itemID = MemoryRead($itemPtr, "long")

    Switch $aInfo
        Case "ItemID"
            Return $itemID
        Case "Quantity"
            Return MemoryRead($itemPtr + 4, "long")
        Case "ModelID"
            Return GetItemInfoByPtr($itemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func GetArrayPlayerTradeItems()
	Local $itemCount = GetTradeInfo("PlayerItemCount")

    If $itemCount = 0 Then
        Local $items[1] = [0]
        Return $items
    EndIf

    Local $items[$itemCount + 1][2]
    $items[0][0] = $itemCount

	Local $itemsPtr = GetTradeInfo("PlayerItemsPtr")
    If $itemsPtr = 0 Then Return $items

    For $i = 0 To $itemCount - 1
        ; Read ModelID
        $items[$i + 1][0] = GetItemInfoByPtr(MemoryRead($itemsPtr + ($i * 8), "long"), "ModelID")
        ; Read item quantity
        $items[$i + 1][1] = MemoryRead($itemsPtr + ($i * 8) + 4, "long")
    Next

    Return $items
EndFunc

Func GetArrayPartnerTradeItems()
	Local $itemCount = GetTradeInfo("PartnerItemCount")

    If $itemCount = 0 Then
        Local $items[1] = [0]
        Return $items
    EndIf

    Local $items[$itemCount + 1][2]
    $items[0][0] = $itemCount

	Local $itemsPtr = GetTradeInfo("PartnerItemsPtr")
    If $itemsPtr = 0 Then Return $items

    For $i = 0 To $itemCount - 1
        ; Read ModelID
        $items[$i + 1][0] = GetItemInfoByPtr(MemoryRead($itemsPtr + ($i * 8), "long"), "ModelID")
        ; Read item quantity
        $items[$i + 1][1] = MemoryRead($itemsPtr + ($i * 8) + 4, "long")
    Next

    Return $items
EndFunc
#EndRegion Trade Context Related

#Region Guild Context
Func GetGuildContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x3C]
    Local $lGuildPtr = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lGuildPtr[1]
EndFunc

Func GetMyGuildInfo($aInfo = "")
    Local $lPtr = GetGuildContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "PlayerName"
            Return MemoryRead($lPtr + 0x34, "wchar[20]")
        Case "PlayerGuildIndex"
            Return MemoryRead($lPtr + 0x60, "long")
        Case "PlayerGuildRank"
            Return MemoryRead($lPtr + 0x2A0, "long")
        Case "Announcement"
            Return MemoryRead($lPtr + 0x78, "wchar[256]")
        Case "AnnouncementAuthor"
            Return MemoryRead($lPtr + 0x278, "wchar[20]")

		Case "TownAlliance"
			Return MemoryRead($lPtr + 0x2A8, "ptr")
		Case "TownAllianceSize"
			Return MemoryRead($lPtr + 0x2A8 + 0x8, "long")

        Case "KurzickTownCount"
            Return MemoryRead($lPtr + 0x2B8, "long")
        Case "LuxonTownCount"
            Return MemoryRead($lPtr + 0x2BC, "long")

		Case "GuildRosterPtr"
			Return MemoryRead($lPtr + 0x358, "ptr")
        Case "GuildRosterSize"
            Return MemoryRead($lPtr + 0x358 + 0x8, "long")

        Case "GuildArrayPtr"
            Return MemoryRead($lPtr + 0x2F8, "ptr")
        Case "GuildArraySize"
            Return MemoryRead($lPtr + 0x2F8 + 0x8, "long")

        Case "GuildHistoryPtr"
            Return MemoryRead($lPtr + 0x2CC, "ptr")
        Case "GuildHistorySize"
            Return MemoryRead($lPtr + 0x2CC + 0x8, "long")
    EndSwitch

    Return 0
EndFunc

Func GetGuildPlayerInfo($aPlayerIndex, $aInfo = "")
    Local $rosterDataPtr = GetMyGuildInfo("GuildRosterPtr")
    Local $rosterSize = GetMyGuildInfo("GuildRosterSize")

    If $rosterDataPtr = 0 Or $aPlayerIndex < 0 Or $aPlayerIndex >= $rosterSize Then Return 0

    Local $playerPtr = MemoryRead($rosterDataPtr + ($aPlayerIndex * 4), "ptr")
    If $playerPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "InvitedName"
            Return MemoryRead($playerPtr + 0x8, "wchar[20]")

        Case "CurrentName"
            Return MemoryRead($playerPtr + 0x30, "wchar[20]")

        Case "InviterName"
            Return MemoryRead($playerPtr + 0x58, "wchar[20]")

        Case "InviteTime"
            Return MemoryRead($playerPtr + 0x80, "long")

        Case "PromoterName"
            Return MemoryRead($playerPtr + 0x84, "wchar[20]")

        Case "Offline"
            Return MemoryRead($playerPtr + 0xDC, "long")

        Case "MemberType"
            Return MemoryRead($playerPtr + 0xE0, "long")

        Case "Status"
            Return MemoryRead($playerPtr + 0xE4, "long")
    EndSwitch

    Return 0
EndFunc

Func GetGuildHistoryEvent($aEventIndex, $aInfo = "")
    Local $HistoryDataPtr = GetMyGuildInfo("GuildHistoryPtr")
    Local $HistorySize = GetMyGuildInfo("GuildHistorySize")

    If $HistoryDataPtr = 0 Or $aEventIndex < 0 Or $aEventIndex >= $HistorySize Then Return 0

    Local $eventPtr = MemoryRead($HistoryDataPtr + ($aEventIndex * 4), "ptr")
    If $eventPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Time1"
            Return MemoryRead($eventPtr, "long")

        Case "Time2"
            Return MemoryRead($eventPtr + 0x4, "long")

        Case "Name"
            Return MemoryRead($eventPtr + 0x8, "wchar[256]")
    EndSwitch

    Return 0
EndFunc

Func GetTownAllianceInfo($aAllianceIndex, $aInfo = "")
	Local $townAlliancesPtr = GetMyGuildInfo("TownAlliance")
    Local $townAlliancesSize = GetMyGuildInfo("TownAllianceSize")

	If $townAlliancesPtr = 0 Or $aAllianceIndex < 0 Or $aAllianceIndex >= $townAlliancesSize Then Return 0

    Local $alliancePtr = MemoryRead($townAlliancesPtr + ($aAllianceIndex * 4), "ptr")
    If $alliancePtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Rank"
            Return MemoryRead($alliancePtr, "long")
        Case "Allegiance"
            Return MemoryRead($alliancePtr + 0x4, "long")
        Case "Faction"
            Return MemoryRead($alliancePtr + 0x8, "long")
        Case "Name"
            Return MemoryRead($alliancePtr + 0xC, "wchar[32]")
        Case "Tag"
            Return MemoryRead($alliancePtr + 0x4C, "wchar[5]")
        Case "CapeBackgroundColor"
            Return MemoryRead($alliancePtr + 0x58, "long")
        Case "CapeDetailColor"
            Return MemoryRead($alliancePtr + 0x5C, "long")
        Case "CapeEmblemColor"
            Return MemoryRead($alliancePtr + 0x60, "long")
        Case "CapeShape"
            Return MemoryRead($alliancePtr + 0x64, "long")
        Case "CapeDetail"
            Return MemoryRead($alliancePtr + 0x68, "long")
        Case "CapeEmblem"
            Return MemoryRead($alliancePtr + 0x6C, "long")
        Case "CapeTrim"
            Return MemoryRead($alliancePtr + 0x70, "long")
        Case "MapID"
            Return MemoryRead($alliancePtr + 0x74, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Guild Context

#Region Item Context
Func GetItemContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x40]
    Local $lItemContextPtr = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lItemContextPtr[1]
EndFunc

Func GetInventoryPtr()
	Local $lOffset[4] = [0, 0x18, 0x40, 0xF8]
    Local $lItemContextPtr = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lItemContextPtr[1]
EndFunc

Func GetInventoryInfo($aInfo = "")
    Local $lPtr = GetInventoryPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "GoldCharacter"
            Return MemoryRead($lPtr + 0x90, "long")
        Case "GoldStorage"
            Return MemoryRead($lPtr + 0x94, "long")
        Case "ActiveWeaponSet"
            Return MemoryRead($lPtr + 0x84, "long")

        Case "BundlePtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x5C, "ptr")
		Case "BundleItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x5C, "ptr"), "dword")
		Case "BundleAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x5C, "ptr") + 0x4, "dword")
		Case "BundleModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x5C, "ptr") + 0x2C, "dword")


        Case "WeaponSet0WeaponPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x64, "ptr")
		Case "WeaponSet0WeaponItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x64, "ptr"), "dword")
		Case "WeaponSet0WeaponAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x64, "ptr") + 0x4, "dword")
		Case "WeaponSet0WeaponModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x64, "ptr") + 0x2C, "dword")


        Case "WeaponSet0OffhandPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x68, "ptr")
		Case "WeaponSet0OffhandItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x68, "ptr"), "dword")
		Case "WeaponSet0OffhandAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x68, "ptr") + 0x4, "dword")
		Case "WeaponSet0OffhandModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x68, "ptr") + 0x2C, "dword")


        Case "WeaponSet1WeaponPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x6C, "ptr")
		Case "WeaponSet1WeaponItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x6C, "ptr"), "dword")
		Case "WeaponSet1WeaponAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x6C, "ptr") + 0x4, "dword")
		Case "WeaponSet1WeaponModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x6C, "ptr") + 0x2C, "dword")


        Case "WeaponSet1OffhandPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x70, "ptr")
		Case "WeaponSet1OffhandItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x70, "ptr"), "dword")
		Case "WeaponSet1OffhandAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x70, "ptr") + 0x4, "dword")
		Case "WeaponSet1OffhandModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x70, "ptr") + 0x2C, "dword")


        Case "WeaponSet2WeaponPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x74, "ptr")
		Case "WeaponSet2WeaponItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x74, "ptr"), "dword")
		Case "WeaponSet2WeaponAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x74, "ptr") + 0x4, "dword")
		Case "WeaponSet2WeaponModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x74, "ptr") + 0x2C, "dword")


        Case "WeaponSet2OffhandPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x78, "ptr")
		Case "WeaponSet2OffhandItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x78, "ptr"), "dword")
		Case "WeaponSet2OffhandAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x78, "ptr") + 0x4, "dword")
		Case "WeaponSet2OffhandModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x78, "ptr") + 0x2C, "dword")


        Case "WeaponSet3WeaponPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x7C, "ptr")
		Case "WeaponSet3WeaponItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x7C, "ptr"), "dword")
		Case "WeaponSet3WeaponAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x7C, "ptr") + 0x4, "dword")
		Case "WeaponSet3WeaponModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x7C, "ptr") + 0x2C, "dword")


        Case "WeaponSet3OffhandPtr" ;<-- Item struct
            Return MemoryRead($lPtr + 0x80, "ptr")
		Case "WeaponSet3OffhandItemID"
			Return  MemoryRead(MemoryRead($lPtr + 0x80, "ptr"), "dword")
		Case "WeaponSet3OffhandAgentID"
			Return  MemoryRead(MemoryRead($lPtr + 0x80, "ptr") + 0x4, "dword")
		Case "WeaponSet3OffhandModelID"
            Return  MemoryRead(MemoryRead($lPtr + 0x80, "ptr") + 0x2C, "dword")
    EndSwitch

    Return 0
EndFunc

Global Enum $INVENTORY_unused_bag, $INVENTORY_backpack, $INVENTORY_belt_pouch, $INVENTORY_bag1, $INVENTORY_bag2, $INVENTORY_equipment_pack, $INVENTORY_material_storage, $INVENTORY_unclaimed_items, _
			$INVENTORY_storage1, $INVENTORY_storage2, $INVENTORY_storage3, $INVENTORY_storage4, $INVENTORY_storage5, $INVENTORY_storage6, $INVENTORY_storage7, _
			$INVENTORY_storage8, $INVENTORY_storage9, $INVENTORY_storage10, $INVENTORY_storage11, $INVENTORY_storage12, $INVENTORY_storage13, $INVENTORY_storage14, $INVENTORY_equipped_items

Func GetBagPtr($aBagNumber)
    If IsPtr($aBagNumber) Then Return $aBagNumber
	Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x4 * $aBagNumber]
	Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
	Return $lItemStructAddress[1]
EndFunc   ;==>GetBagPtr

Func GetBagInfo($aBagNumber, $aInfo = "")
    Local $lBagPtr = GetBagPtr($aBagNumber)
    If $lBagPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "BagType"
            Return MemoryRead($lBagPtr, "dword")
		Case "IsInventoryBag"
			If MemoryRead($lBagPtr, "dword") = 1 Then Return True
			Return False
		Case "IsEquipped"
			If MemoryRead($lBagPtr, "dword") = 2 Then Return True
			Return False
		Case "IsNotCollected"
			If MemoryRead($lBagPtr, "dword") = 3 Then Return True
			Return False
		Case "IsStorage"
			If MemoryRead($lBagPtr, "dword") = 4 Then Return True
			Return False
		Case "IsMaterialStorage"
			If MemoryRead($lBagPtr, "dword") = 5 Then Return True
			Return False

        Case "Index"
            Return MemoryRead($lBagPtr + 0x4, "dword")
		Case "ID"
            Return MemoryRead($lBagPtr + 0x8, "dword")
		Case "ContainerItem"
            Return MemoryRead($lBagPtr + 0xC, "dword")
		Case "ItemCount"
            Return MemoryRead($lBagPtr + 0x10, "dword")
		Case "Bag"
            Return MemoryRead($lBagPtr + 0x14, "ptr")
		Case "ItemArray"
            Return MemoryRead($lBagPtr + 0x18, "ptr")
		Case "FakeSlots"
            Return MemoryRead($lBagPtr + 0x1C, "long")
		Case "Slots"
            Return MemoryRead($lBagPtr + 0x20, "long")
		Case "EmptySlots"
			Return MemoryRead($lBagPtr + 0x20, "long") - MemoryRead($lBagPtr + 0x10, "dword")
		Case Else
			Return 0
	EndSwitch

    Return 0
EndFunc

Func GetBagsItembyModelID($aModelID)
    Local $lBagList[4] = [$INVENTORY_backpack, $INVENTORY_belt_pouch, $INVENTORY_bag1, $INVENTORY_bag2]

    For $i = 0 To UBound($lBagList) - 1
        Local $lBagPtr = GetBagPtr($lBagList[$i])
        If $lBagPtr = 0 Then ContinueLoop

        Local $lItemArray = GetBagItemArray($lBagList[$i])

        For $j = 1 To $lItemArray[0]
            Local $lItemPtr = $lItemArray[$j]
            If MemoryRead($lItemPtr + 0x2C, "dword") = $aModelID Then
                Return MemoryRead($lItemPtr, "dword")
            EndIf
        Next
    Next

    Return 0
EndFunc   ;==>GetBagsItemIDbyModelID

Func GetBagItemArray($aBagNumber)
    Local $lBagPtr = GetBagPtr($aBagNumber)
    If $lBagPtr = 0 Then Return 0

    Local $lItemArrayPtr = GetBagInfo($aBagNumber, "ItemArray")
    If $lItemArrayPtr = 0 Then Return 0

    Local $lSlots = GetBagInfo($aBagNumber, "Slots")
    If $lSlots = 0 Then Return 0

    Local $lItemArray[$lSlots + 1]
    Local $lItemPtr, $lCount = 0

    Local $lItemPtrBuffer = DllStructCreate("ptr[" & $lSlots & "]")
    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, "ptr", $lItemArrayPtr, "struct*", $lItemPtrBuffer, "ulong_ptr", 4 * $lSlots, "ulong_ptr*", 0)

    For $i = 1 To $lSlots
        $lItemPtr = DllStructGetData($lItemPtrBuffer, 1, $i)
        If $lItemPtr = 0 Then ContinueLoop

        $lCount += 1
        $lItemArray[$lCount] = $lItemPtr
    Next

    $lItemArray[0] = $lCount
    ReDim $lItemArray[$lCount + 1]

    Return $lItemArray
EndFunc   ;==>GetBagItemArray

Func GetItemBySlot($aBagNumber, $aSlot)
	If $aSlot < 1 Or $aSlot > GetBagInfo($aBagNumber, "Slots") Then Return 0

	Local $lBagPtr = GetBagPtr($aBagNumber)
	Local $lItemPtr = MemoryRead($lBagPtr + 0x18, 'ptr')

	Return MemoryRead($lItemPtr + 0x4 * ($aSlot - 1), 'ptr')
EndFunc   ;==>GetItemBySlot

Func ItemID($aItem)
	If IsPtr($aItem) Then
		Return MemoryRead($aItem, "long")
	ElseIf IsDllStruct($aItem) Then
		Return DllStructGetData($aItem, "ID")
	Else
		Return $aItem
	EndIf
EndFunc   ;==>ItemID

Func GetItemPtr($aItemID)
	If IsPtr($aItemID) Then Return $aItemID
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0x4 * ItemID($aItemID)]
	Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, "ptr")
	Return $lItemStructAddress[1]
EndFunc   ;==>GetItemPtr

Func GetItemInfoByItemID($aItemID, $aInfo = "")
    Local $lItemPtr = GetItemPtr($aItemID)
    If $lItemPtr = 0 Or $aInfo = "" Then Return 0

    Return GetItemInfoByPtr($lItemPtr, $aInfo)
EndFunc   ;==>GetItemInfo

Func GetItemInfoByAgentID($aAgentID, $aInfo = "")
    Local $lItemID = FindItemByAgentID($aAgentID)
    If $lItemID = 0 Then Return 0

    If $aInfo = "" Then Return $lItemID
	Local $lItemPtr = GetItemPtr($lItemID)
    Return GetItemInfoByPtr($lItemPtr, $aInfo)
EndFunc   ;==>GetItemInfoByAgentID

Func GetItemInfoByModelID($aModelID, $aInfo = "")
    Local $lItemID = FindItemByModelID($aModelID)
    If $lItemID = 0 Then Return 0

    If $aInfo = "" Then Return $lItemID
	Local $lItemPtr = GetItemPtr($lItemID)
    Return GetItemInfoByPtr($lItemPtr, $aInfo)
EndFunc   ;==>GetItemInfoByModelID

Func GetItemInfoByPtr($lItemPtr, $aInfo)
    Switch $aInfo
        Case "ItemID"
            Return MemoryRead($lItemPtr, "dword")
        Case "AgentID"
            Return MemoryRead($lItemPtr + 0x4, "dword")
        Case "BagEquipped"
            Return MemoryRead($lItemPtr + 0x8, "ptr")
        Case "Bag"
            Return MemoryRead($lItemPtr + 0xC, "ptr")

        Case "ModStruct"
            Return MemoryRead($lItemPtr + 0x10, "ptr")
        Case "ModStructSize"
            Return MemoryRead($lItemPtr + 0x14, "dword")

        Case "Customized"
            Return MemoryRead($lItemPtr + 0x18, "ptr")
        Case "ModelFileID"
            Return MemoryRead($lItemPtr + 0x1C, "dword")

        Case "ItemType"
            Return MemoryRead($lItemPtr + 0x20, "byte")
		Case "IsMaterial"
			If MemoryRead($lItemPtr + 0x20, "byte") <> 11 Then Return False
			Return True

        Case "Dye1"
            Return MemoryRead($lItemPtr + 0x21, "byte")
        Case "Dye2"
            Return MemoryRead($lItemPtr + 0x22, "byte")
        Case "Dye3"
            Return MemoryRead($lItemPtr + 0x23, "byte")

        Case "ExtraID"
            Return MemoryRead($lItemPtr + 0x22, "byte")

         Case "Value"
            Return MemoryRead($lItemPtr + 0x24, "Short")
        Case "h0026"
            Return MemoryRead($lItemPtr + 0x26, "Short")

        Case "Interaction"
            Return MemoryRead($lItemPtr + 0x28, "dword")
        Case "IsIdentified"
            Return BitAND(MemoryRead($lItemPtr + 0x28, "dword"), 0x1) > 0
        Case "IsCommonMaterial"
            Return BitAND(MemoryRead($lItemPtr + 0x28, "dword"), 0x20) > 0
        Case "IsStackable"
            Return BitAND(MemoryRead($lItemPtr + 0x28, "dword"), 0x80000) > 0
        Case "IsInscribable"
            Return BitAND(MemoryRead($lItemPtr + 0x28, "dword"), 0x08000000) > 0

        Case "ModelID"
            Return MemoryRead($lItemPtr + 0x2C, "dword")
        Case "InfoString"
            Return MemoryRead($lItemPtr + 0x30, "ptr")

        Case "NameEnc"
            Return MemoryRead($lItemPtr + 0x34, "ptr")
		Case "Rarity"
			Local $lRarityPtr = MemoryRead($lItemPtr + 0x38, "ptr")
			Return MemoryRead($lRarityPtr, 'ushort')

        Case "CompleteNameEnc"
            Return MemoryRead($lItemPtr + 0x38, "ptr")
        Case "SingleItemName"
            Return MemoryRead($lItemPtr + 0x3C, "ptr")
        Case "h0040[2]"
            Return MemoryRead($lItemPtr + 0x40, "long")
        Case "ItemFormula"
            Return MemoryRead($lItemPtr + 0x48, "Short")
        Case "IsMaterialSalvageable"
            Return MemoryRead($lItemPtr + 0x4A, "byte")
        Case "h004B"
            Return MemoryRead($lItemPtr + 0x4B, "byte")
        Case "Quantity"
            Return MemoryRead($lItemPtr + 0x4C, "short")
        Case "Equipped"
            Return MemoryRead($lItemPtr + 0x4E, "byte")
        Case "Profession"
            Return MemoryRead($lItemPtr + 0x4F, "byte")
        Case "Slot"
            Return MemoryRead($lItemPtr + 0x50, "byte")
        Case Else
            Return 0
    EndSwitch
EndFunc   ;==>GetItemInfoByPtr

Func FindItemByModelID($aModelID)
    Local $lItemArray = GetItemArray()

    For $i = 1 To $lItemArray[0]
        Local $lItemPtr = $lItemArray[$i]
        If MemoryRead($lItemPtr + 0x2C, "dword") = $aModelID Then
            Return MemoryRead($lItemPtr, "dword")
        EndIf
    Next

    Return 0
EndFunc   ;==>FindItemByModelID

Func FindItemByAgentID($aAgentID)
    Local $lItemArray = GetItemArray()

    For $i = 1 To $lItemArray[0]
        Local $lItemPtr = $lItemArray[$i]
        If MemoryRead($lItemPtr + 0x4, "dword") = $aAgentID Then
            Return MemoryRead($lItemPtr, "dword")
        EndIf
    Next

    Return 0
EndFunc   ;==>_FindItemByAgentID

Func GetMaxItems()
	Local $lOffset[4] = [0, 0x18, 0x40, 0xB8 + 0x8]
	Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, "dword")
	Return $lItemStructAddress[1]
EndFunc   ;==>GetMaxItems

Func GetItemArray()
	Local $lMaxItems = GetMaxItems()
    If $lMaxItems <= 0 Then Return

	Local $lOffset[4] = [0, 0x18, 0x40, 0xB8]
	Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, "dword")

	Local $lItemArray[$lMaxItems + 1]
    Local $lPtr, $lCount = 0
    Local $lItemBasePtr = $lItemStructAddress[1]
    Local $lItemPtrBuffer = DllStructCreate("ptr[" & $lMaxItems & "]")

    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, "ptr", $lItemBasePtr, "struct*", $lItemPtrBuffer, "ulong_ptr", 4 * $lMaxItems, "ulong_ptr*", 0)

    For $i = 1 To $lMaxItems
        $lPtr = DllStructGetData($lItemPtrBuffer, 1, $i)
        If $lPtr = 0 Then ContinueLoop

        $lCount += 1
        $lItemArray[$lCount] = $lPtr
    Next

    $lItemArray[0] = $lCount
    ReDim $lItemArray[$lCount + 1]

    Return $lItemArray
EndFunc   ;==>GetItemArray

#EndRegion Item Context

#Region Party Context
Func GetPartyContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x4C]
    Local $lPartyPtr = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
    Return $lPartyPtr[1]
EndFunc

Func GetPartyContextInfo($aInfo = "")
    Local $lPtr = GetPartyContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Flags"
            Return MemoryRead($lPtr + 0x14, "long")
        Case "IsHardMode"
            Local $flags = MemoryRead($lPtr + 0x14, "long")
            Return BitAND($flags, 0x10) <> 0
        Case "IsDefeated"
            Local $flags = MemoryRead($lPtr + 0x14, "long")
            Return BitAND($flags, 0x20) <> 0
        Case "IsPartyLeader"
            Local $flags = MemoryRead($lPtr + 0x14, "long")
            Return BitAND(BitShift($flags, 7), 1) <> 0
		Case "IsWaitingForMission"
			Local $flags = MemoryRead($lPtr + 0x14, "long")
            Return BitAND($flags, 0x8) <> 0


        Case "MyPartyPtr"
            Return MemoryRead($lPtr + 0x54, "ptr")

;~         Case "PlayerPartyID"
;~             Local $partyPtr = MemoryRead($lPtr + 0x54, "ptr")
;~             Return MemoryRead($partyPtr, "long")

;~         Case "PlayerCount"
;~             Local $partyPtr = MemoryRead($lPtr + 0x54, "ptr")
;~             Return MemoryRead($partyPtr + 0xC, "long")

;~         Case "HenchmenCount"
;~             Local $partyPtr = MemoryRead($lPtr + 0x54, "ptr")
;~             Return MemoryRead($partyPtr + 0x1C, "long")

;~         Case "HeroCount"
;~             Local $partyPtr = MemoryRead($lPtr + 0x54, "ptr")
;~             Return MemoryRead($partyPtr + 0x2C, "long")

;~         Case "OtherCount" ; Spirit, Minions, Pets (not the Spirits and Minions of heroes, only your character)
;~             Local $partyPtr = MemoryRead($lPtr + 0x54, "ptr")
;~             Return MemoryRead($partyPtr + 0x3C, "long")

;~         Case "TotalPartySize"
;~             Local $playerCount = GetPartyInfo("PlayerCount")
;~             Local $henchmenCount = GetPartyInfo("HenchmenCount")
;~             Local $heroCount = GetMyPartyInfo("ArrayHeroPartyMemberSize")
;~             Return $playerCount + $henchmenCount + $heroCount

    EndSwitch
    Return 0
EndFunc

Func GetMyPartyInfo($aInfo = "")
    Local $partyPtr = GetPartyContextInfo("MyPartyPtr")
    If $partyPtr = 0 Or $aInfo = "" Then Return 0

	Switch $aInfo
		Case "PartyID"
			Return MemoryRead($partyPtr, "long")
		Case "ArrayPlayerPartyMember"
			Return MemoryRead($partyPtr + 0x4, "ptr")
		Case "ArrayPlayerPartyMemberSize"
			Return MemoryRead($partyPtr + 0xC, "long")

		Case "ArrayHenchmanPartyMember"
			Return MemoryRead($partyPtr + 0x14, "ptr")
		Case "ArrayHenchmanPartyMemberSize"
			Return MemoryRead($partyPtr + 0x1C, "long")

		Case "ArrayHeroPartyMember"
			Return MemoryRead($partyPtr + 0x24, "ptr")
		Case "ArrayHeroPartyMemberSize"
			Return MemoryRead($partyPtr + 0x2C, "long")

		Case "ArrayOthersPartyMember"
			Return MemoryRead($partyPtr + 0x34, "ptr")
		Case "ArrayOthersPartyMemberSize"
			Return MemoryRead($partyPtr + 0x3C, "long")
	EndSwitch

	Return 0
EndFunc

Func GetMyPartyPlayerMemberInfo($aPartyMemberNumber = 1, $aInfo = "")
    Local $lPlayerPartyPtr = GetMyPartyInfo("ArrayPlayerPartyMember")
	Local $lPlayerPartySize = GetMyPartyInfo("ArrayPlayerPartyMemberSize")
	$aPartyMemberNumber = $aPartyMemberNumber - 1
	If $lPlayerPartyPtr = 0 Or $aPartyMemberNumber < 0 Or $aPartyMemberNumber >= $lPlayerPartySize Then Return 0

    Local $playerPtr = $lPlayerPartyPtr + ($aPartyMemberNumber * 0xC)
    If $playerPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "LoginNumber"
            Return MemoryRead($playerPtr, "long")

        Case "CalledTargetID"
            Return MemoryRead($playerPtr + 0x4, "long")

        Case "State"
            Return MemoryRead($playerPtr + 0x8, "long")

        Case "IsConnected"
            Local $state = MemoryRead($playerPtr + 0x8, "long")
            Return BitAND($state, 1) <> 0

        Case "IsTicked"
            Local $state = MemoryRead($playerPtr + 0x8, "long")
            Return BitAND($state, 2) <> 0
    EndSwitch

    Return 0
EndFunc

Func GetMyPartyHeroInfo($aHeroNumber = 1, $aInfo = "")
    Local $lPlayerPartyPtr = GetMyPartyInfo("ArrayHeroPartyMember")
	Local $lPlayerPartySize = GetMyPartyInfo("ArrayHeroPartyMemberSize")
	$aHeroNumber = $aHeroNumber - 1
	If $lPlayerPartyPtr = 0 Or $aHeroNumber < 0 Or $aHeroNumber >= $lPlayerPartySize Then Return 0

    Local $heroPtr = $lPlayerPartyPtr + ($aHeroNumber * 0x18)
    If $heroPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "AgentID"
			Return MemoryRead($heroPtr, "long")

        Case "OwnerPlayerNumber"
            Return MemoryRead($heroPtr + 0x4, "long")

        Case "HeroID"
            Return MemoryRead($heroPtr + 0x8, "long")

        Case "Level"
            Return MemoryRead($heroPtr + 0x14, "long")
    EndSwitch

    Return 0
EndFunc

Func GetMyPartyHenchmanInfo($aHenchmanNumber = 1, $aInfo = "")
    Local $lPlayerPartyPtr = GetMyPartyInfo("ArrayHenchmanPartyMember")
	Local $lPlayerPartySize = GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
	$aHenchmanNumber = $aHenchmanNumber - 1
	If $lPlayerPartyPtr = 0 Or $aHenchmanNumber < 0 Or $aHenchmanNumber >= $lPlayerPartySize Then Return 0

    Local $henchmanPtr = $lPlayerPartyPtr + ($aHenchmanNumber * 0x34)
    If $henchmanPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "AgentID"
            Return MemoryRead($henchmanPtr, "long")

        Case "Profession"
            Return MemoryRead($henchmanPtr + 0x2C, "long")

        Case "Level"
            Return MemoryRead($henchmanPtr + 0x30, "long")
    EndSwitch

    Return 0
EndFunc
#EndRegion Party Context

#Region World Context
Func GetWorldContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x2C]
    Local $lWorldContextPtr = MemoryReadPtr($mBasePointer, $lOffset)
    Return $lWorldContextPtr[1]
EndFunc

Func GetWorldInfo($aInfo = "")
	Local $lPtr = GetWorldContextPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "AccountInfo"
			Return MemoryRead($lPtr, "ptr")
		Case "MessageBuffArray" ;--> To check <Useless ??>
			Return MemoryRead($lPtr + 0x4, "ptr")
		Case "DialogBuffArray" ;--> To check <Useless ??>
			Return MemoryRead($lPtr + 0x14, "ptr")
		Case "MerchItemArray" ;--> To check
			Return MemoryRead($lPtr + 0x24, "ptr")
		Case "MerchItemArraySize" ;--> To check
			Return MemoryRead($lPtr + 0x24 + 0x4, "dword")
		Case "MerchItemArray2" ;--> To check
			Return MemoryRead($lPtr + 0x34, "ptr")
		Case "MerchItemArray2Size" ;--> To check
			Return MemoryRead($lPtr + 0x34 + 0x4, "dword")
		Case "PartyAllyArray" ;--> To check <Useless ??>
			Return MemoryRead($lPtr + 0x8C, "ptr")
		Case "FlagAll"
			Local $lFlags[3] = [MemoryRead($lPtr + 0x9C, "float"), _
								MemoryRead($lPtr + 0xA0, "float"), _
								MemoryRead($lPtr + 0xA4, "float")]
			Return $lFlags
		Case "ActiveQuestID"
			Return MemoryRead($lPtr + 0x528, "dword")
		Case "PlayerNumber"
			Return MemoryRead($lPtr + 0x67C, "dword")
		Case "MyID"
			Local $lID = MemoryRead($lPtr + 0x680, "dword")
			Return MemoryRead($lID + 0x14, "dword")
		Case "IsHmUnlocked"
			Return MemoryRead($lPtr + 0x684, "dword")
		Case "SalvageSessionID"
			Return MemoryRead($lPtr + 0x690, "dword")
		Case "PlayerTeamToken"
			Return MemoryRead($lPtr + 0x6A8, "dword")
		Case "Experience"
			Return MemoryRead($lPtr + 0x740, "dword")
		Case "CurrentKurzick"
			Return MemoryRead($lPtr + 0x748, "dword")
		Case "TotalEarnedKurzick"
			Return MemoryRead($lPtr + 0x750, "dword")
		Case "CurrentLuxon"
			Return MemoryRead($lPtr + 0x758, "dword")
		Case "TotalEarnedLuxon"
			Return MemoryRead($lPtr + 0x760, "dword")
		Case "CurrentImperial"
			Return MemoryRead($lPtr + 0x768, "dword")
		Case "TotalEarnedImperial"
			Return MemoryRead($lPtr + 0x770, "dword")
		Case "Level"
			Return MemoryRead($lPtr + 0x788, "dword")
		Case "Morale"
			Return MemoryRead($lPtr + 0x790, "dword")
		Case "CurrentBalth"
			Return MemoryRead($lPtr + 0x798, "dword")
		Case "TotalEarnedBalth"
			Return MemoryRead($lPtr + 0x7A0, "dword")
		Case "CurrentSkillPoints"
			Return MemoryRead($lPtr + 0x7A8, "dword")
		Case "TotalEarnedSkillPoints"
			Return MemoryRead($lPtr + 0x7B0, "dword")
		Case "MaxKurzickPoints"
			Return MemoryRead($lPtr + 0x7B8, "dword")
		Case "MaxLuxonPoints"
			Return MemoryRead($lPtr + 0x7BC, "dword")
		Case "MaxBalthPoints"
			Return MemoryRead($lPtr + 0x7C0, "dword")
		Case "MaxImperialPoints"
			Return MemoryRead($lPtr + 0x7C4, "dword")
		Case "EquipmentStatus"
			Return MemoryRead($lPtr + 0x7C8, "dword")
		Case "FoesKilled"
			Return MemoryRead($lPtr + 0x84C, "dword")
		Case "FoesToKill"
			Return MemoryRead($lPtr + 0x850, "dword")

		;Map Agent Array <Useless ??>
		Case "MapAgentArray" ;--> To check
			Return MemoryRead($lPtr + 0x7C, "ptr")
		Case "MapAgentArraySize" ;--> To check
			Return MemoryRead($lPtr + 0x7C + 0x8, "long")

		;Party Attribute Array
		Case "PartyAttributeArray"
			Return MemoryRead($lPtr + 0xAC, "ptr")
		Case "PartyAttributeArraySize"
			Return MemoryRead($lPtr + 0xAC + 0x8, "long")

		;Agent Effect Array
		Case "AgentEffectsArray"
			Return MemoryRead($lPtr + 0x508, "ptr")
		Case "AgentEffectsArraySize"
			Return MemoryRead($lPtr + 0x508 + 0x8, "long")

		;Quest Array
		Case "QuestLog"
			Return MemoryRead($lPtr + 0x52C, "ptr")
		Case "QuestLogSize"
			Return MemoryRead($lPtr + 0x52C + 0x8, "long")

		;Mission Objective <Useless ??>
		Case "MissionObjectiveArray" ;--> To check
			Return MemoryRead($lPtr + 0x564, "ptr")
		Case "MissionObjectiveArraySize" ;--> To check
			Return MemoryRead($lPtr + 0x564 + 0x8, "long")

		;Hero Array
		Case "HeroFlagArray"
			Return MemoryRead($lPtr + 0x584, "ptr")
		Case "HeroFlagArraySize"
			Return MemoryRead($lPtr + 0x584 + 0x8, "long")
		Case "HeroInfoArray"
			Return MemoryRead($lPtr + 0x594, "ptr")
		Case "HeroInfoArraySize"
			Return MemoryRead($lPtr + 0x594 + 0x8, "long")

		;Minion Array
		Case "ControlledMinionsArray"
			Return MemoryRead($lPtr + 0x5BC, "ptr")
		Case "ControlledMinionsArraySize"
			Return MemoryRead($lPtr + 0x5BC + 0x8, "long")

		;Morale Array
		Case "PlayerMoraleInfo"
			Return MemoryRead($lPtr + 0x624, "ptr")
		Case "PlayerMoraleInfoSize"
			Return MemoryRead($lPtr + 0x624 + 0x8, "long")
		Case "PartyMoraleInfo"
			Return MemoryRead($lPtr + 0x62C, "ptr")
		Case "PartyMoraleInfoSize"
			Return MemoryRead($lPtr + 0x62C + 0x8, "long")

		;Pet Array
		Case "PetInfoArray"
			Return MemoryRead($lPtr + 0x6AC, "ptr")
		Case "PetInfoArraySize"
			Return MemoryRead($lPtr + 0x6AC + 0x8, "long")

		;Party Profession Array
		Case "PartyProfessionArray"
			Return MemoryRead($lPtr + 0x6BC, "ptr")
		Case "PartyProfessionArraySize"
			Return MemoryRead($lPtr + 0x6BC + 0x8, "long")

		;Skill Array
		Case "SkillbarArray"
			Return MemoryRead($lPtr + 0x6F0, "ptr")
		Case "SkillbarArraySize"
			Return MemoryRead($lPtr + 0x6F0 + 0x8, "long")

		;Agent Info Array (name only)
		Case "AgentInfoArray" ;--> To check (name_enc) <Useless for GwAu3>
			Return MemoryRead($lPtr + 0x7CC, "ptr")
		Case "AgentInfoArraySize" ;--> To check (name_enc) <Useless for GwAu3>
			Return MemoryRead($lPtr + 0x7CC + 0x8, "long")

		;NPC Array
		Case "NPCArray"
			Return MemoryRead($lPtr + 0x7FC, "ptr")
		Case "NPCArraySize"
			Return MemoryRead($lPtr + 0x7FC + 0x8, "long")

		;Player Array
		Case "PlayerArray"
			Return MemoryRead($lPtr + 0x80C, "ptr")
		Case "PlayerArraySize"
			Return MemoryRead($lPtr + 0x80C + 0x8, "long")

		;Title Array
		Case "TitleArray"
			Return MemoryRead($lPtr + 0x81C, "ptr")
		Case "TitleArraySize"
			Return MemoryRead($lPtr + 0x81C, "ptr")

		;Special array
		Case "VanquishedAreasArray" ;--> To check
			Return MemoryRead($lPtr + 0x83C, "ptr")
		Case "VanquishedAreasArraySize" ;--> To check
			Return MemoryRead($lPtr + 0x83C + 0x8, "long")
		Case "MissionsCompletedArray" ;--> To check
			Return MemoryRead($lPtr + 0x5CC, "ptr")
        Case "MissionsBonusArray" ;--> To check
			Return MemoryRead($lPtr + 0x5DC, "ptr")
        Case "MissionsCompletedHMArray" ;--> To check
			Return MemoryRead($lPtr + 0x5EC, "ptr")
        Case "MissionsBonusHMArray" ;--> To check
			Return MemoryRead($lPtr + 0x5FC, "ptr")
		Case "LearnableSkillsArray" ;--> To check
			Return MemoryRead($lPtr + 0x700, "ptr")
		Case "UnlockedSkillsArray" ;--> To check
			Return MemoryRead($lPtr + 0x710, "ptr")
		Case "UnlockedMapArray" ;--> To check
			Return MemoryRead($lPtr + 0x60C, "ptr")
		Case "HenchmanIDArray" ;--> To check
			Return MemoryRead($lPtr + 0x574, "ptr")
	EndSwitch

	Return 0
EndFunc
#EndRegion World Context

#Region Party Morale Related
Func GetMoraleInfo($aAgentID = -2, $aInfo = "")
    Local $lAgentID = ConvertID($aAgentID)

    Local $lOffset[4] = [0, 0x18, 0x2C, 0x638]
    Local $lIndex = MemoryReadPtr($mBasePointer, $lOffset)

    ReDim $lOffset[6]
    $lOffset[3] = 0x62C
    $lOffset[4] = 8 + 0xC * BitAND($lAgentID, $lIndex[1])
    $lOffset[5] = 0x18
    Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)

    If Not IsArray($lReturn) Or $lReturn[0] = 0 Then Return 0

    Switch $aInfo
        Case "Morale"
            Return $lReturn[1] - 100
        Case "RawMorale"
            Return $lReturn[1]
        Case "IsMaxMorale"
            Return ($lReturn[1] >= 110)
		Case "IsMinMorale"
            Return ($lReturn[1] <= 40)
        Case "IsMoraleBoost"
            Return ($lReturn[1] > 100)
        Case "IsMoralePenalty"
            Return ($lReturn[1] < 100)
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion  Party Morale Related

#Region Party Profession Related
Func GetPartyProfessionInfo($aAgentID = 0, $aInfo = "")
	Local $lPtr = GetWorldInfo("PartyProfessionArray")
	Local $lSize = GetWorldInfo("PartyProfessionArraySize")
	Local $lAgentPtr = 0

	For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x14)
        If MemoryRead($lAgentEffectsPtr, "dword") = ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

	If $lAgentPtr = 0 Then Return 0

	Switch $aInfo
        Case "AgentID"
            Return MemoryRead($lAgentPtr, "dword")
        Case "Primary"
            Return MemoryRead($lAgentPtr + 0x4, "dword")
		Case "Secondary"
            Return MemoryRead($lAgentPtr + 0x8, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion  Party Profession Related

#Region Related NPC Info
;~ TIPS: $aModelFileID = Player number of an npc
Func GetNpcInfo($aModelFileID = 0, $aInfo = "")
	Local $lPtr = GetWorldInfo("NpcArray")
	Local $lSize = GetWorldInfo("NpcArraySize")
	Local $lAgentPtr = 0

	For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x30)
        If MemoryRead($lAgentEffectsPtr, "dword") = $aModelFileID Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

	If $lAgentPtr = 0 Then Return 0

	Switch $aInfo
		Case "ModelFileID"
            Return MemoryRead($lAgentPtr, "dword")
        Case "Scale"
            Return MemoryRead($lAgentPtr + 0x8, "dword")
		Case "Sex"
            Return MemoryRead($lAgentPtr + 0xC, "dword")
		Case "NpcFlags"
            Return MemoryRead($lAgentPtr + 0x10, "dword")
		Case "Primary"
            Return MemoryRead($lAgentPtr + 0x14, "dword")
		Case "DefaultLevel", "Level"
            Return MemoryRead($lAgentPtr + 0x1C, "byte")
		Case "IsHenchman"
			Local $flags = MemoryRead($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x10) <> 0
		Case "IsHero"
			Local $flags = MemoryRead($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x20) <> 0
		Case "IsSpirit"
			Local $flags = MemoryRead($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x4000) <> 0
		Case "IsMinion"
			Local $flags = MemoryRead($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x100) <> 0
		Case "IsPet"
			Local $flags = MemoryRead($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0xD) <> 0
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion

#Region Related Player Info
Func GetPlayerInfo($aAgentID = 0, $aInfo = "")
	Local $lPtr = GetWorldInfo("PlayerArray")
	Local $lSize = GetWorldInfo("PlayerArraySize")
	Local $lAgentPtr = 0

	For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x4C)
        If MemoryRead($lAgentEffectsPtr, "dword") = ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

	If $lAgentPtr = 0 Then Return 0

	Switch $aInfo
        Case "AgentID"
            Return MemoryRead($lAgentPtr, "dword")
        Case "AppearanceBitmap"
            Return MemoryRead($lAgentPtr + 0x10, "dword")
		Case "Flags"
            Return MemoryRead($lAgentPtr + 0x14, "dword")
		Case "Primary"
            Return MemoryRead($lAgentPtr + 0x18, "dword")
		Case "Secondary"
            Return MemoryRead($lAgentPtr + 0x1C, "dword")
		Case "Name"
;~             Return MemoryRead($lAgentPtr + 0x24, "wchar[20]")
			Local $lName = MemoryRead($lAgentPtr + 0x24, "ptr")
			Return MemoryRead($lName, "wchar[20]")
		Case "PartLeaderPlayerNumber"
            Return MemoryRead($lAgentPtr + 0x2C, "dword")
		Case "ActiveTitle"
            Return MemoryRead($lAgentPtr + 0x30, "dword")
		Case "PlayerNumber"
            Return MemoryRead($lAgentPtr + 0x34, "dword")
		Case "PartySize"
            Return MemoryRead($lAgentPtr + 0x38, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion Related Player Info

#Region Controlled Minion Related
Func GetControlledMinionsInfo($aAgentID = 0, $aInfo = "")
	Local $lPtr = GetWorldInfo("ControlledMinionsArray")
	Local $lSize = GetWorldInfo("ControlledMinionsArraySize")
	Local $lAgentPtr = 0

	For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x8)
        If MemoryRead($lAgentEffectsPtr, "dword") = ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

	If $lAgentPtr = 0 Then Return 0

	Switch $aInfo
        Case "AgentID"
            Return MemoryRead($lAgentPtr, "dword")
        Case "MinionCount"
            Return MemoryRead($lAgentPtr + 0x4, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion

#Region Title Related
Global Enum $TitleID_Hero, $TitleID_TyrianCarto, $TitleID_CanthanCarto, $TitleID_Gladiator, $TitleID_Champion, $TitleID_Kurzick, $TitleID_Luxon, $TitleID_Drunkard, _
    $TitleID_Deprecated_SkillHunter, _ ; Pre hard mode update version
    $TitleID_Survivor, $TitleID_KoaBD, _
    $TitleID_Deprecated_TreasureHunter, _ ; Old title, non-account bound
    $TitleID_Deprecated_Wisdom, _ ; Old title, non-account bound
    $TitleID_ProtectorTyria, $TitleID_ProtectorCantha, $TitleID_Lucky, $TitleID_Unlucky, $TitleID_Sunspear, $TitleID_ElonianCarto, _
    $TitleID_ProtectorElona, $TitleID_Lightbringer, $TitleID_LDoA, $TitleID_Commander, $TitleID_Gamer, _
    $TitleID_SkillHunterTyria, $TitleID_VanquisherTyria, $TitleID_SkillHunterCantha, _
    $TitleID_VanquisherCantha, $TitleID_SkillHunterElona, $TitleID_VanquisherElona, _
    $TitleID_LegendaryCarto, $TitleID_LegendaryGuardian, $TitleID_LegendarySkillHunter, _
    $TitleID_LegendaryVanquisher, $TitleID_Sweets, $TitleID_GuardianTyria, $TitleID_GuardianCantha, _
    $TitleID_GuardianElona, $TitleID_Asuran, $TitleID_Deldrimor, $TitleID_Vanguard, $TitleID_Norn, $TitleID_MasterOfTheNorth, _
    $TitleID_Party, $TitleID_Zaishen, $TitleID_TreasureHunter, $TitleID_Wisdom, $TitleID_Codex, $TitleID_None = 0xff

Func GetTitleInfo($aTitle = 0, $aInfo = "")
	Local $lPtr = GetWorldInfo("TitleArray")
	Local $lSize = GetWorldInfo("TitleArraySize")
	If $lPtr = 0 Or $aTitle < 0 Or $aTitle >= $lSize Then Return 0

    $lPtr = $lPtr + ($aTitle * 0x28)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "Props"
			Return MemoryRead($lPtr, "dword")
		Case "CurrentPoints"
			Return MemoryRead($lPtr + 0x4, "dword")
		Case "CurrentTitleTier"
			Return MemoryRead($lPtr + 0x8, "dword")
		Case "PointsNeededCurrentRank"
			Return MemoryRead($lPtr + 0xC, "dword")
		Case "NextTitleTier"
			Return MemoryRead($lPtr + 0x10, "dword")
		Case "PointsNeededNextRank"
			Return MemoryRead($lPtr + 0x14, "dword")
		Case "MaxTitleRank"
			Return MemoryRead($lPtr + 0x18, "dword")
		Case "MaxTitleTier"
			Return MemoryRead($lPtr + 0x1C, "dword")
	EndSwitch

	Return 0
EndFunc
#EndRegion Title Related

#Region Pet Related
Func GetPetInfo($aPetNumber = 0, $aInfo = "")
	Local $lPetPtr = GetWorldInfo("PetInfoArray")
	Local $lPetSize = GetWorldInfo("PetInfoArraySize")
	$aPetNumber = $aPetNumber - 1
	If $lPetPtr = 0 Or $aPetNumber < 0 Or $aPetNumber >= $lPetSize Then Return 0

    $lPetPtr = $lPetPtr + ($aPetNumber * 0x1C)
    If $lPetPtr = 0 Or $aInfo = "" Then Return 0

	Switch $aInfo
        Case "AgentID"
            Return MemoryRead($lPetPtr, "dword")
        Case "OwnerAgentID"
            Return MemoryRead($lPetPtr + 0x4, "dword")
        Case "PetNamePtr"
            Return MemoryRead($lPetPtr + 0x8, "ptr")
        Case "PetName"
            Local $namePtr = MemoryRead($lPetPtr + 0x8, "ptr")
            If $namePtr > 0x10000 Then
                Return MemoryRead($namePtr, "wchar[32]")
            Else
                Return "Unknown"
            EndIf
        Case "ModelFileID1"
            Return MemoryRead($lPetPtr + 0xC, "dword")
        Case "ModelFileID2"
            Return MemoryRead($lPetPtr + 0x10, "dword")
        Case "Behavior"
            Return MemoryRead($lPetPtr + 0x14, "dword")
        Case "LockedTargetID"
            Return MemoryRead($lPetPtr + 0x18, "dword")
        Case "IsFighting"
            Return MemoryRead($lPetPtr + 0x14, "dword") = 0
        Case "IsGuarding"
            Return MemoryRead($lPetPtr + 0x14, "dword") = 1
        Case "IsAvoiding"
            Return MemoryRead($lPetPtr + 0x14, "dword") = 2
        Case "HasLockedTarget"
            Return MemoryRead($lPetPtr + 0x18, "dword") <> 0
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion Pet Related

#Region Account Related
Func GetAccountInfo($aInfo = "")
    Local $lPtr = GetWorldInfo("AccountInfo")
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "AccountName"
			Local $lName = MemoryRead($lPtr, "ptr")
			Return MemoryRead($lName, "wchar[32]")
		Case "Wins"
            Return MemoryRead($lPtr + 0x4, "dword")
        Case "Losses"
            Return MemoryRead($lPtr + 0x8, "dword")
        Case "Rating"
            Return MemoryRead($lPtr + 0xC, "dword")
        Case "QualifierPoints"
            Return MemoryRead($lPtr + 0x10, "dword")
        Case "Rank"
            Return MemoryRead($lPtr + 0x14, "dword")
        Case "TournamentRewardPoints"
            Return MemoryRead($lPtr + 0x18, "dword")
	EndSwitch

	Return 0
EndFunc
#EndRegion Account Related

#Region Quest Related
Func GetQuestInfo($aQuestID, $aInfo = "")
	Local $lPtr
    Local $lSize = GetWorldInfo("QuestLogSize")
	If $lSize = 0 Or $aInfo = "" Then Return 0

	For $i = 0 To $lSize
		Local $lOffsetQuestLog[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $i]
		Local $lQuestPtr = MemoryReadPtr($mBasePointer, $lOffsetQuestLog, "long")
		If $lQuestPtr[1] = $aQuestID Then $lPtr = Ptr($lQuestPtr[0])
	Next

    Switch $aInfo
		Case "QuestID"
			Return MemoryRead($lPtr, "long")

		Case "LogState"
			Return MemoryRead($lPtr + 0x4, "long")
		Case "IsCompleted"
			Switch MemoryRead($lPtr + 0x4, "long")
				Case 2, 3, 19, 32, 34, 35, 79
					Return True
				Case Else
					Return False
			EndSwitch
		Case "CanReward"
			Switch MemoryRead($lPtr + 0x4, "long")
				Case 32, 33
					Return True
				Case Else
					Return False
			EndSwitch
		Case "IsIncomplete"
			If MemoryRead($lPtr + 0x4, "long") = 1 Then Return True
			Return False
		Case "IsCurrentQuest"
			If MemoryRead($lPtr + 0x4, "long") = 0x10 Then Return True
			Return False
		Case "IsAreaPrimary"
			If MemoryRead($lPtr + 0x4, "long") = 0x40 Then Return True
			Return False
		Case "IsPrimary"
			If MemoryRead($lPtr + 0x4, "long") = 0x20 Then Return True
			Return False


		Case "Location"
			Local $lLocationPtr = MemoryRead($lPtr + 0x8, "ptr")
            Return MemoryRead($lLocationPtr, "wchar[256]")
		Case "Name"
			Local $lNamePtr = MemoryRead($lPtr + 0xC, "ptr")
            Return MemoryRead($lNamePtr, "wchar[256]")
		Case "NPC"
			Local $lNPCPtr = MemoryRead($lPtr + 0x10, "ptr")
            Return MemoryRead($lNPCPtr, "wchar[256]")
		Case "MapFrom"
			Return MemoryRead($lPtr + 0x14, "dword")
		Case "MarkerX"
			Return MemoryRead($lPtr + 0x18, "float")
		Case "MarkerY"
			Return MemoryRead($lPtr + 0x1C, "float")
		Case "MarkerZ"
			Return MemoryRead($lPtr + 0x20, "dword")
		Case "MapTo"
			Return MemoryRead($lPtr + 0x28, "dword")
		Case "Description"
			Local $lDescriptionPtr = MemoryRead($lPtr + 0x2C, "ptr")
            Return MemoryRead($lDescriptionPtr, "wchar[256]")
		Case "Objectives"
			Local $lObjectivesPtr = MemoryRead($lPtr + 0x30, "ptr")
            Return MemoryRead($lObjectivesPtr, "wchar[256]")
	EndSwitch

	Return 0
EndFunc
#EndRegion Quest Related

#Region Hero Related
Func GetHeroFlagInfo($aHeroNumber = 1, $aInfo = "")
	Local $lPtr = GetWorldInfo("HeroFlagArray")
	Local $lSize = GetWorldInfo("HeroFlagArraySize")
	$aHeroNumber = $aHeroNumber - 1
	If $lPtr = 0 Or $aHeroNumber < 0 Or $aHeroNumber >= $lSize Then Return 0

    $lPtr = $lPtr + ($aHeroNumber * 0x24)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

	Switch $aInfo
		Case "HeroID"
			Return MemoryRead($lPtr, "dword")
		Case "AgentID"
			Return MemoryRead($lPtr + 0x4, "dword")
		Case "Level"
			Return MemoryRead($lPtr + 0x8, "dword")
		Case "Behavior"
			Return MemoryRead($lPtr + 0xC, "dword")
		Case "FlagX"
			Return MemoryRead($lPtr + 0x10, "float")
		Case "FlagY"
			Return MemoryRead($lPtr + 0x14, "float")
		Case "LockedTargetID"
			Return MemoryRead($lPtr + 0x20, "dword")
	EndSwitch

	Return 0
EndFunc

;~ CAREFUL: This is related to your UNLOCKED Hero, HeroID is Different from GetMyPartyHeroInfo - "HeroID"
Func GetHeroInfo($aHeroNumber, $aInfo = "")
	Local $lPtr = GetWorldInfo("HeroInfoArray")
	Local $lSize = GetWorldInfo("HeroInfoArraySize")
	$aHeroNumber = $aHeroNumber - 1
	If $lPtr = 0 Or $aHeroNumber < 0 Or $aHeroNumber >= $lSize Then Return 0

    $lPtr = $lPtr + ($aHeroNumber * 0x78)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "HeroID"
            Return MemoryRead($lPtr, "dword")
        Case "AgentID"
            Return MemoryRead($lPtr + 0x4, "dword")
        Case "Level"
            Return MemoryRead($lPtr + 0x8, "dword")
        Case "Primary"
            Return MemoryRead($lPtr + 0xC, "dword")
        Case "Secondary"
            Return MemoryRead($lPtr + 0x10, "dword")
        Case "HeroFileID"
            Return MemoryRead($lPtr + 0x14, "dword")
        Case "ModelFileID"
            Return MemoryRead($lPtr + 0x18, "dword")
        Case "Name"
;~ 			Local $lname = MemoryRead($lPtr + 0x50, "ptr")
;~ 			Return MemoryRead($lname, "char[20]")
            Return MemoryRead($lPtr + 0x50, "wchar[24]")
    EndSwitch

    Return 0
EndFunc
#EndRegion Hero Related

#Region Skillbar Related
Func GetSkillbarInfo($aSkillSlot = 0, $aInfo = "", $aHeroNumber = 0)
	Local $lPtr = GetWorldInfo("SkillbarArray")
	Local $lSize = GetWorldInfo("SkillbarArraySize")

	If $lPtr = 0 Or $aHeroNumber < 0 Or $aHeroNumber >= $lSize Then Return 0

    Local $lSkillbarPtr = $lPtr + ($aHeroNumber * 0xBC)
    If $lSkillbarPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "AgentID"
            Return MemoryRead($lSkillbarPtr, "long")
        Case "Disabled"
            Return MemoryRead($lSkillbarPtr + 0xA4, "dword")
        Case "Casting"
            Return MemoryRead($lSkillbarPtr + 0xB0, "dword")
        Case "h00A8[2]"
            Return MemoryRead($lSkillbarPtr + 0xA8, "dword")
        Case "h00B4[2]"
            Return MemoryRead($lSkillbarPtr + 0xB4, "dword")

        Case "SkillID"
            If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0
            Return MemoryRead($lSkillbarPtr + 0x10 + (($aSkillSlot - 1) * 0x14), "dword")

        Case "IsRecharged"
            If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0
            Local $lTimestamp = MemoryRead($lSkillbarPtr + 0xC + (($aSkillSlot - 1) * 0x14), "dword")
            If $lTimestamp = 0 Then Return True
            Return ($lTimestamp - _SkillMod_GetSkillTimer()) = 0

        Case "RawRecharged"
            If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0
            Local $lTimestamp = MemoryRead($lSkillbarPtr + 0xC + (($aSkillSlot - 1) * 0x14), "dword")
			Local $lSkillID = MemoryRead($lSkillbarPtr + 0x10 + (($aSkillSlot - 1) * 0x14), "dword")
			Return _SkillMod_GetSkillInfo($lSkillID, "Recharge") - (_SkillMod_GetSkillTimer() - $lTimestamp)

        Case "Adrenaline"
            If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0
            Return MemoryRead($lSkillbarPtr + 0x4 + (($aSkillSlot - 1) * 0x14), "dword")

		Case "AdrenalineB"
            If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0
            Return MemoryRead($lSkillbarPtr + 0x8 + (($aSkillSlot - 1) * 0x14), "dword")

        Case "Event"
            If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0
            Return MemoryRead($lSkillbarPtr + 0x14 + (($aSkillSlot - 1) * 0x14), "dword")

        Case "HasSkill"
            If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0
            Return MemoryRead($lSkillbarPtr + 0x10 + (($aSkillSlot - 1) * 0x14), "dword") <> 0

        Case "SlotBySkillID"
            For $slot = 1 To 8
                If MemoryRead($lSkillbarPtr + 0x10 + (($slot - 1) * 0x14), "dword") = $aSkillSlot Then
                    Return $slot
                EndIf
            Next
            Return 0

        Case "HasSkillID"
            For $slot = 1 To 8
                If MemoryRead($lSkillbarPtr + 0x10 + (($slot - 1) * 0x14), "dword") = $aSkillSlot Then
                    Return True
                EndIf
            Next
            Return False

        Case Else
            Return 0
    EndSwitch
EndFunc   ;==>GetSkillbarInfo
#EndRegion Skillbar Related

#Region Effect Related
Func GetAgentEffectArrayInfo($aAgentID = -2, $aInfo = "")
    Local $lPtr = GetWorldInfo("AgentEffectsArray")
    Local $lSize = GetWorldInfo("AgentEffectsArraySize")
    Local $lAgentPtr = 0

    For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x24)
        If MemoryRead($lAgentEffectsPtr, "dword") = ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "AgentID"
            Return MemoryRead($lAgentPtr, "dword")
        Case "BuffArray"
            Return MemoryRead($lAgentPtr + 0x4, "ptr")
        Case "BuffArraySize"
            Return MemoryRead($lAgentPtr + 0x4 + 0x8, "long")
        Case "EffectArray"
            Return MemoryRead($lAgentPtr + 0x14, "ptr")
        Case "EffectArraySize"
            Return MemoryRead($lAgentPtr + 0x14 + 0x8, "long")
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GetAgentEffectInfo($aAgentID = -2, $aSkillID = 0, $aInfo = "")
    Local $lEffectArrayPtr = GetAgentEffectArrayInfo($aAgentID, "EffectArray")
    Local $lEffectCount = GetAgentEffectArrayInfo($aAgentID, "EffectArraySize")

    If $lEffectArrayPtr = 0 Or $lEffectCount = 0 Then Return 0

    Local $lEffectPtr = 0
    For $j = 0 To $lEffectCount - 1
        Local $lCurrentPtr = $lEffectArrayPtr + ($j * 0x18)
        Local $lCurrentSkillID = MemoryRead($lCurrentPtr, "long")

        If $lCurrentSkillID = $aSkillID Then
            $lEffectPtr = $lCurrentPtr
            ExitLoop
        EndIf
    Next

    If $lEffectPtr = 0 Then Return 0
    If $aInfo = "" Then Return $lEffectPtr

    Switch $aInfo
;~         Case "SkillID"
;~             Return MemoryRead($lEffectPtr, "long")
        Case "AttributeLevel"
            Return MemoryRead($lEffectPtr + 0x4, "dword")
        Case "EffectID"
            Return MemoryRead($lEffectPtr + 0x8, "long")
        Case "CasterID" ; maintained enchantment
            Return MemoryRead($lEffectPtr + 0xC, "dword")
        Case "Duration"
            Return MemoryRead($lEffectPtr + 0x10, "float")
        Case "Timestamp"
            Return MemoryRead($lEffectPtr + 0x14, "dword")
        Case "TimeElapsed"
            Local $lTimestamp = MemoryRead($lEffectPtr + 0x14, "dword")
            Return _SkillMod_GetSkillTimer() - $lTimestamp
        Case "TimeRemaining"
            Local $lTimestamp = MemoryRead($lEffectPtr + 0x14, "dword")
            Local $lDuration = MemoryRead($lEffectPtr + 0x10, "float")
            Return $lDuration * 1000 - (_SkillMod_GetSkillTimer() - $lTimestamp)
        Case "HasEffect"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GetAgentBuffInfo($aAgentID = -2, $aSkillID = 0, $aInfo = "")
    Local $lBuffArrayPtr = GetAgentEffectArrayInfo($aAgentID, "BuffArray")
    Local $lBuffCount = GetAgentEffectArrayInfo($aAgentID, "BuffArraySize")

    If $lBuffArrayPtr = 0 Or $lBuffCount = 0 Then Return 0

    Local $lBuffPtr = 0
    For $j = 0 To $lBuffCount - 1
        Local $lCurrentPtr = $lBuffArrayPtr + ($j * 0x10)
        Local $lCurrentSkillID = MemoryRead($lCurrentPtr, "long")

        If $lCurrentSkillID = $aSkillID Then
            $lBuffPtr = $lCurrentPtr
            ExitLoop
        EndIf
    Next

    If $lBuffPtr = 0 Then Return 0
    If $aInfo = "" Then Return $lBuffPtr

    Switch $aInfo
;~         Case "SkillID"
;~             Return MemoryRead($lBuffPtr, "long")
        Case "h0004"
            Return MemoryRead($lBuffPtr + 0x4, "dword")
        Case "BuffID"
            Return MemoryRead($lBuffPtr + 0x8, "long")
        Case "TargetAgentID"
            Return MemoryRead($lBuffPtr + 0xC, "dword")
        Case "HasBuff"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion

#Region Outside Context Info
#Region Agent Related
Func ConvertID($aID)
	Select
		Case $aID = -2
			Return GetMyID()
		Case $aID = -1
			Return GetCurrentTargetID()
		Case IsPtr($aID) <> 0
			Return MemoryRead($aID + 0x2C, 'long')
		Case IsDllStruct($aID) <> 0
			Return DllStructGetData($aID, 'ID')
		Case Else
			Return $aID
	EndSelect
EndFunc   ;==>ConvertID

Func GetMyID()
	Local $lOffset[5] = [0, 0x18, 0x2C, 0x680, 0x14]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetMyID

Func GetCurrentTargetID()
	Return MemoryRead($mCurrentTarget)
EndFunc   ;==>GetCurrentTargetID

Func GetAgentPtr($aAgentID = -2)
	If IsPtr($aAgentID) Then Return $aAgentID
	Local $lOffset[3] = [0, 4 * ConvertID($aAgentID), 0]
	Local $lAgentStructAddress = MemoryReadPtr($mAgentBase, $lOffset)
	Return $lAgentStructAddress[0]
EndFunc   ;==>GetAgentPtr

Func GetAgentInfo($aAgentID = -2, $aInfo = "")
    Local $lAgentPtr = GetAgentPtr($aAgentID)
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "vtable"
            Return MemoryRead($lAgentPtr, "ptr")
        Case "h0004"
            Return MemoryRead($lAgentPtr + 0x4, "dword")
        Case "h0008"
            Return MemoryRead($lAgentPtr + 0x8, "dword")
        Case "h000C"
            Return MemoryRead($lAgentPtr + 0xC, "dword")
        Case "h0010"
            Return MemoryRead($lAgentPtr + 0x10, "dword")
        Case "Timer"
            Return MemoryRead($lAgentPtr + 0x14, "dword")
        Case "Timer2"
            Return MemoryRead($lAgentPtr + 0x18, "dword")
        Case "h0018"
            Return MemoryRead($lAgentPtr + 0x1C, "dword[4]")
        Case "ID"
            Return MemoryRead($lAgentPtr + 0x2C, "long")
        Case "Z"
            Return MemoryRead($lAgentPtr + 0x30, "float")
        Case "Width1"
            Return MemoryRead($lAgentPtr + 0x34, "float")
        Case "Height1"
            Return MemoryRead($lAgentPtr + 0x38, "float")
        Case "Width2"
            Return MemoryRead($lAgentPtr + 0x3C, "float")
        Case "Height2"
            Return MemoryRead($lAgentPtr + 0x40, "float")
        Case "Width3"
            Return MemoryRead($lAgentPtr + 0x44, "float")
        Case "Height3"
            Return MemoryRead($lAgentPtr + 0x48, "float")
        Case "Rotation"
            Return MemoryRead($lAgentPtr + 0x4C, "float")
        Case "RotationCos"
            Return MemoryRead($lAgentPtr + 0x50, "float")
        Case "RotationSin"
            Return MemoryRead($lAgentPtr + 0x54, "float")
        Case "NameProperties"
            Return MemoryRead($lAgentPtr + 0x58, "dword")
        Case "Ground"
            Return MemoryRead($lAgentPtr + 0x5C, "dword")
        Case "h0060"
            Return MemoryRead($lAgentPtr + 0x60, "dword")
        Case "TerrainNormalX"
            Return MemoryRead($lAgentPtr + 0x64, "float")
        Case "TerrainNormalY"
            Return MemoryRead($lAgentPtr + 0x68, "float")
        Case "TerrainNormalZ"
            Return MemoryRead($lAgentPtr + 0x6C, "dword")
        Case "h0070"
            Return MemoryRead($lAgentPtr + 0x70, "byte[4]")
        Case "X"
            Return MemoryRead($lAgentPtr + 0x74, "float")
        Case "Y"
            Return MemoryRead($lAgentPtr + 0x78, "float")
        Case "Plane"
            Return MemoryRead($lAgentPtr + 0x7C, "dword")
        Case "h0080"
            Return MemoryRead($lAgentPtr + 0x80, "byte[4]")
        Case "NameTagX"
            Return MemoryRead($lAgentPtr + 0x84, "float")
        Case "NameTagY"
            Return MemoryRead($lAgentPtr + 0x88, "float")
        Case "NameTagZ"
            Return MemoryRead($lAgentPtr + 0x8C, "float")
        Case "VisualEffects"
            Return MemoryRead($lAgentPtr + 0x90, "short")
        Case "h0092"
            Return MemoryRead($lAgentPtr + 0x92, "short")
        Case "h0094"
            Return MemoryRead($lAgentPtr + 0x94, "dword[2]")


        Case "Type"
            Return MemoryRead($lAgentPtr + 0x9C, "long")
		Case "IsItemType"
			Return MemoryRead($lAgentPtr + 0x9C, "long") = 0x400
		Case "IsGadgetType"
			Return MemoryRead($lAgentPtr + 0x9C, "long") = 0x200
		Case "IsLivingType"
			Return MemoryRead($lAgentPtr + 0x9C, "long") = 0xDB


        Case "MoveX"
            Return MemoryRead($lAgentPtr + 0xA0, "float")
        Case "MoveY"
            Return MemoryRead($lAgentPtr + 0xA4, "float")
        Case "h00A8"
            Return MemoryRead($lAgentPtr + 0xA8, "dword")
        Case "RotationCos2"
            Return MemoryRead($lAgentPtr + 0xAC, "float")
        Case "RotationSin2"
            Return MemoryRead($lAgentPtr + 0xB0, "float")
        Case "h00B4"
            Return MemoryRead($lAgentPtr + 0xB4, "dword[4]")

        Case "Owner"
            Return MemoryRead($lAgentPtr + 0xC4, "long")
		Case "CanPickUp"
			If MemoryRead($lAgentPtr + 0x9C, "long") = 0x400 Then
				If MemoryRead($lAgentPtr + 0xC4, "long") = 0 Or MemoryRead($lAgentPtr + 0xC4, "long") = GetMyID() Then Return True
			EndIf
			Return False

        Case "ItemID"
            Return MemoryRead($lAgentPtr + 0xC8, "dword")
        Case "ExtraType"
            Return MemoryRead($lAgentPtr + 0xCC, "dword")
        Case "GadgetID"
            Return MemoryRead($lAgentPtr + 0xD0, "dword")
        Case "h00D4"
            Return MemoryRead($lAgentPtr + 0xD4, "dword[3]")
        Case "AnimationType"
            Return MemoryRead($lAgentPtr + 0xE0, "float")
        Case "h00E4"
            Return MemoryRead($lAgentPtr + 0xE4, "dword[2]")
        Case "AttackSpeed"
            Return MemoryRead($lAgentPtr + 0xEC, "float")
        Case "AttackSpeedModifier"
            Return MemoryRead($lAgentPtr + 0xF0, "float")
        Case "PlayerNumber"
            Return MemoryRead($lAgentPtr + 0xF4, "short")
        Case "AgentModelType"
            Return MemoryRead($lAgentPtr + 0xF6, "short")
		Case "TransmogNpcId"
            Return MemoryRead($lAgentPtr + 0xF8, "dword")
        Case "Equipment"
            Return MemoryRead($lAgentPtr + 0xFC, "ptr")
        Case "h0100"
            Return MemoryRead($lAgentPtr + 0x100, "dword")
        Case "Tags"
            Return MemoryRead(MemoryRead($lAgentPtr + 0x104, "ptr"), "short")
        Case "h0108"
            Return MemoryRead($lAgentPtr + 0x108, "short")
        Case "Primary"
            Return MemoryRead($lAgentPtr + 0x10A, "byte")
        Case "Secondary"
            Return MemoryRead($lAgentPtr + 0x10B, "byte")
        Case "Level"
            Return MemoryRead($lAgentPtr + 0x10C, "byte")
        Case "Team"
            Return MemoryRead($lAgentPtr + 0x10D, "byte")
        Case "h010E"
            Return MemoryRead($lAgentPtr + 0x10E, "byte[2]")
        Case "h0110"
            Return MemoryRead($lAgentPtr + 0x110, "dword")
        Case "EnergyRegen"
            Return MemoryRead($lAgentPtr + 0x114, "float")
        Case "Overcast"
            Return MemoryRead($lAgentPtr + 0x118, "float")
        Case "EnergyPercent"
            Return MemoryRead($lAgentPtr + 0x11C, "float")
        Case "MaxEnergy"
            Return MemoryRead($lAgentPtr + 0x120, "dword")
		Case "CurrentEnergy"
			Return MemoryRead($lAgentPtr + 0x11C, "float") * MemoryRead($lAgentPtr + 0x120, "dword")
        Case "h0124"
            Return MemoryRead($lAgentPtr + 0x124, "dword")
        Case "HPPips"
            Return MemoryRead($lAgentPtr + 0x128, "float")
        Case "h012C"
            Return MemoryRead($lAgentPtr + 0x12C, "dword")
        Case "HP"
            Return MemoryRead($lAgentPtr + 0x130, "float")
        Case "MaxHP"
            Return MemoryRead($lAgentPtr + 0x134, "dword")
		Case "CurrentHP"
			Return MemoryRead($lAgentPtr + 0x130, "float") * MemoryRead($lAgentPtr + 0x134, "dword")

        Case "Effects"
            Return MemoryRead($lAgentPtr + 0x138, "dword")
		Case "EffectCount"
            Local $lAgentID = ConvertID($aAgentID)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x508]
            Local $lAgentEffectsBasePtr = MemoryReadPtr($mBasePointer, $lOffset)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x510]
            Local $lAgentEffectsCount = MemoryReadPtr($mBasePointer, $lOffset)

            If $lAgentEffectsBasePtr[1] = 0 Or $lAgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $lAgentEffectsCount[1] - 1
                Local $lAgentEffectsPtr = $lAgentEffectsBasePtr[1] + ($i * 0x24)
                Local $lCurrentAgentID = MemoryRead($lAgentEffectsPtr, "dword")

                If $lCurrentAgentID = $lAgentID Then
                    Local $lEffectArrayPtr = $lAgentEffectsPtr + 0x14
                    Return MemoryRead($lEffectArrayPtr + 0x8, "long")
                EndIf
            Next
            Return 0
        Case "BuffCount"
            Local $lAgentID = ConvertID($aAgentID)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x508]
            Local $lAgentEffectsBasePtr = MemoryReadPtr($mBasePointer, $lOffset)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x510]
            Local $lAgentEffectsCount = MemoryReadPtr($mBasePointer, $lOffset)

            If $lAgentEffectsBasePtr[1] = 0 Or $lAgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $lAgentEffectsCount[1] - 1
                Local $lAgentEffectsPtr = $lAgentEffectsBasePtr[1] + ($i * 0x24)
                Local $lCurrentAgentID = MemoryRead($lAgentEffectsPtr, "dword")

                If $lCurrentAgentID = $lAgentID Then
                    Local $lBuffArrayPtr = $lAgentEffectsPtr + 0x4
                    Return MemoryRead($lBuffArrayPtr + 0x8, "long")
                EndIf
            Next

            Return 0


		Case "IsBleeding"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0001) > 0
		Case "IsConditioned"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0002) > 0
		Case "IsCrippled"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x000A) = 0xA
		Case "IsDead"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0010) > 0
		Case "IsDeepWounded"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0020) > 0
		Case "IsPoisoned"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0040) > 0
		Case "IsEnchanted"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0080) > 0
		Case "IsDegenHexed"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0400) > 0
		Case "IsHexed"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0800) > 0
		Case "IsWeaponSpelled"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x8000) > 0

        Case "h013C"
            Return MemoryRead($lAgentPtr + 0x13C, "dword")
        Case "Hex"
            Return MemoryRead($lAgentPtr + 0x140, "byte")
        Case "h0141"
            Return MemoryRead($lAgentPtr + 0x141, "byte[19]")

        Case "ModelState"
            Return MemoryRead($lAgentPtr + 0x154, "dword")
		Case "IsKnockedDown"
			Return MemoryRead($lAgentPtr + 0x154, "dword") = 0x450
		Case "IsMoving"
			If MemoryRead($lAgentPtr + 0xA0, "float") <> 0 Or MemoryRead($lAgentPtr + 0xA4, "float") <> 0 Then Return True
			If MemoryRead($lAgentPtr + 0x154, "dword") = 12 Or MemoryRead($lAgentPtr + 0x154, "dword") = 76 Or MemoryRead($lAgentPtr + 0x154, "dword") = 204 Then Return True
			Return False
		Case "IsAttacking"
			If MemoryRead($lAgentPtr + 0x154, "dword") = 0x60 Or MemoryRead($lAgentPtr + 0x154, "dword") = 0x440 Or MemoryRead($lAgentPtr + 0x154, "dword") = 0x460 Then Return True
			Return False
		Case "IsCasting"
			If MemoryRead($lAgentPtr + 0x1B4, "short") <> 0 Then Return True
			If MemoryRead($lAgentPtr + 0x154, "dword") = 0x41 Or MemoryRead($lAgentPtr + 0x154, "dword") = 0x245 Then Return True
			Return False
		Case "IsIdle"
			If MemoryRead($lAgentPtr + 0x154, "dword") = 68 Or MemoryRead($lAgentPtr + 0x154, "dword") = 64 Or MemoryRead($lAgentPtr + 0x154, "dword") = 100 Then Return True
			Return False

        Case "TypeMap"
            Return MemoryRead($lAgentPtr + 0x158, "dword")
		Case "InCombatStance"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000001) > 0
		Case "HasQuest"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000002) > 0
		Case "IsDeadByTypeMap"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000008) > 0
		Case "IsFemale"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000200) > 0
		Case "HasBossGlow"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000400) > 0
		Case "IsHidingCap"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x001000) > 0
		Case "CanBeViewedInPartyWindow"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x20000) > 0
		Case "IsSpawned"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x040000) > 0
		Case "IsBeingObserved"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x400000) > 0

        Case "h015C"
            Return MemoryRead($lAgentPtr + 0x15C, "dword[4]")
        Case "InSpiritRange"
            Return MemoryRead($lAgentPtr + 0x16C, "dword")
		Case "VisibleEffectsPtr"
            Return MemoryRead($lAgentPtr + 0x170, "ptr")
        Case "VisibleEffects"
            Return MemoryRead($lAgentPtr + 0x170, "dword")
        Case "VisibleEffectsID"
            Return MemoryRead($lAgentPtr + 0x174, "dword")
        Case "VisibleEffectsHasEnded"
            Return MemoryRead($lAgentPtr + 0x178, "dword")
        Case "h017C"
            Return MemoryRead($lAgentPtr + 0x17C, "dword")

        Case "LoginNumber"
            Return MemoryRead($lAgentPtr + 0x180, "dword")
		Case "IsPlayer"
			Return MemoryRead($lAgentPtr + 0x180, "dword") <> 0
		Case "IsNPC"
			Return MemoryRead($lAgentPtr + 0x180, "dword") = 0

        Case "AnimationSpeed"
            Return MemoryRead($lAgentPtr + 0x184, "float")
        Case "AnimationCode"
            Return MemoryRead($lAgentPtr + 0x188, "dword")
        Case "AnimationId"
            Return MemoryRead($lAgentPtr + 0x18C, "dword")
        Case "h0190"
            Return MemoryRead($lAgentPtr + 0x190, "byte[32]")
        Case "LastStrike"
            Return MemoryRead($lAgentPtr + 0x1B0, "byte")
        Case "Allegiance"
            Return MemoryRead($lAgentPtr + 0x1B1, "byte")
        Case "WeaponType"
            Return MemoryRead($lAgentPtr + 0x1B2, "short")
        Case "Skill"
            Return MemoryRead($lAgentPtr + 0x1B4, "short")
        Case "h01B6"
            Return MemoryRead($lAgentPtr + 0x1B6, "short")
        Case "WeaponItemType"
            Return MemoryRead($lAgentPtr + 0x1B8, "byte")
        Case "OffhandItemType"
            Return MemoryRead($lAgentPtr + 0x1B9, "byte")
        Case "WeaponItemId"
            Return MemoryRead($lAgentPtr + 0x1BA, "short")
        Case "OffhandItemId"
            Return MemoryRead($lAgentPtr + 0x1BC, "short")

		Case "Name"
			Return 0 ;in progress
		Case Else
			Return 0
	EndSwitch

    Return 0
EndFunc

Func GetAgentEquimentInfo($aAgentID = -2, $aInfo = "")
	Local $lAgentPtr = GetAgentInfo($aAgentID, "Equipment")
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0
    Switch $aInfo
        Case "vtable"
            Return MemoryRead($lAgentPtr, "dword")
		Case "h0004"
			Return MemoryRead($lAgentPtr + 0x4, "dword")
		Case "h0008"
			Return MemoryRead($lAgentPtr + 0x8, "dword")
		Case "h000C"
			Return MemoryRead($lAgentPtr + 0xC, "dword")
		Case "LeftHandData"
			Return MemoryRead($lAgentPtr + 0x10, "Ptr")
		Case "RightHandData"
			Return MemoryRead($lAgentPtr + 0x14, "Ptr")
		Case "h0018"
			Return MemoryRead($lAgentPtr + 0x18, "dword")
		Case "ShieldData"
			Return MemoryRead($lAgentPtr + 0x1C, "Ptr")


		Case "Weapon_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x24, "dword")
		Case "Weapon_Type"
			Return MemoryRead($lAgentPtr + 0x28, "byte")
		Case "Weapon_Dye1"
			Return MemoryRead($lAgentPtr + 0x29, "byte")
		Case "Weapon_Dye2"
			Return MemoryRead($lAgentPtr + 0x2A, "byte")
		Case "Weapon_Dye3"
			Return MemoryRead($lAgentPtr + 0x2B, "byte")
		Case "Weapon_Value"
			Return MemoryRead($lAgentPtr + 0x2C, "dword")
		Case "Weapon_Interaction"
			Return MemoryRead($lAgentPtr + 0x30, "dword")


		Case "Offhand_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x34, "dword")
		Case "Offhand_Type"
			Return MemoryRead($lAgentPtr + 0x38, "byte")
		Case "Offhand_Dye1"
			Return MemoryRead($lAgentPtr + 0x39, "byte")
		Case "Offhand_Dye2"
			Return MemoryRead($lAgentPtr + 0x3A, "byte")
		Case "Offhand_Dye3"
			Return MemoryRead($lAgentPtr + 0x3B, "byte")
		Case "Offhand_Value"
			Return MemoryRead($lAgentPtr + 0x3C, "dword")
		Case "Offhand_Interaction"
			Return MemoryRead($lAgentPtr + 0x40, "dword")

		Case "Chest_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x44, "dword")
		Case "Chest_Type"
			Return MemoryRead($lAgentPtr + 0x48, "byte")
		Case "Chest_Dye1"
			Return MemoryRead($lAgentPtr + 0x49, "byte")
		Case "Chest_Dye2"
			Return MemoryRead($lAgentPtr + 0x4A, "byte")
		Case "Chest_Dye3"
			Return MemoryRead($lAgentPtr + 0x4B, "byte")
		Case "Chest_Value"
			Return MemoryRead($lAgentPtr + 0x4C, "dword")
		Case "Chest_Interaction"
			Return MemoryRead($lAgentPtr + 0x50, "dword")

		Case "Leg_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x54, "dword")
		Case "Leg_Type"
			Return MemoryRead($lAgentPtr + 0x58, "byte")
		Case "Leg_Dye1"
			Return MemoryRead($lAgentPtr + 0x59, "byte")
		Case "Leg_Dye2"
			Return MemoryRead($lAgentPtr + 0x5A, "byte")
		Case "Leg_Dye3"
			Return MemoryRead($lAgentPtr + 0x5B, "byte")
		Case "Leg_Value"
			Return MemoryRead($lAgentPtr + 0x5C, "dword")
		Case "Leg_Interaction"
			Return MemoryRead($lAgentPtr + 0x60, "dword")

		Case "Head_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x64, "dword")
		Case "Head_Type"
			Return MemoryRead($lAgentPtr + 0x68, "byte")
		Case "Head_Dye1"
			Return MemoryRead($lAgentPtr + 0x69, "byte")
		Case "Head_Dye2"
			Return MemoryRead($lAgentPtr + 0x6A, "byte")
		Case "Head_Dye3"
			Return MemoryRead($lAgentPtr + 0x6B, "byte")
		Case "Head_Value"
			Return MemoryRead($lAgentPtr + 0x6C, "dword")
		Case "Head_Interaction"
			Return MemoryRead($lAgentPtr + 0x70, "dword")

		Case "Feet_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x74, "dword")
		Case "Feet_Type"
			Return MemoryRead($lAgentPtr + 0x78, "byte")
		Case "Feet_Dye1"
			Return MemoryRead($lAgentPtr + 0x79, "byte")
		Case "Feet_Dye2"
			Return MemoryRead($lAgentPtr + 0x7A, "byte")
		Case "Feet_Dye3"
			Return MemoryRead($lAgentPtr + 0x7B, "byte")
		Case "Feet_Value"
			Return MemoryRead($lAgentPtr + 0x7C, "dword")
		Case "Feet_Interaction"
			Return MemoryRead($lAgentPtr + 0x80, "dword")

		Case "Hands_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x84, "dword")
		Case "Hands_Type"
			Return MemoryRead($lAgentPtr + 0x88, "byte")
		Case "Hands_Dye1"
			Return MemoryRead($lAgentPtr + 0x89, "byte")
		Case "Hands_Dye2"
			Return MemoryRead($lAgentPtr + 0x8A, "byte")
		Case "Hands_Dye3"
			Return MemoryRead($lAgentPtr + 0x8B, "byte")
		Case "Hands_Value"
			Return MemoryRead($lAgentPtr + 0x8C, "dword")
		Case "Hands_Interaction"
			Return MemoryRead($lAgentPtr + 0x90, "dword")

		Case "CostumeBody_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x94, "dword")
		Case "CostumeBody_Type"
			Return MemoryRead($lAgentPtr + 0x98, "byte")
		Case "CostumeBody_Dye1"
			Return MemoryRead($lAgentPtr + 0x99, "byte")
		Case "CostumeBody_Dye2"
			Return MemoryRead($lAgentPtr + 0x9A, "byte")
		Case "CostumeBody_Dye3"
			Return MemoryRead($lAgentPtr + 0x9B, "byte")
		Case "CostumeBody_Value"
			Return MemoryRead($lAgentPtr + 0x9C, "dword")
		Case "CostumeBody_Interaction"
			Return MemoryRead($lAgentPtr + 0xA0, "dword")

		Case "CostumeHead_ModelFileID"
			Return MemoryRead($lAgentPtr + 0xA4, "dword")
		Case "CostumeHead_Type"
			Return MemoryRead($lAgentPtr + 0xA8, "byte")
		Case "CostumeHead_Dye1"
			Return MemoryRead($lAgentPtr + 0xA9, "byte")
		Case "CostumeHead_Dye2"
			Return MemoryRead($lAgentPtr + 0xAA, "byte")
		Case "CostumeHead_Dye3"
			Return MemoryRead($lAgentPtr + 0xAB, "byte")
		Case "CostumeHead_Value"
			Return MemoryRead($lAgentPtr + 0xAC, "dword")
		Case "CostumeHead_Interaction"
			Return MemoryRead($lAgentPtr + 0xB0, "dword")

		Case "ItemID_Weapon"
			Return MemoryRead($lAgentPtr + 0xB4, "dword")
		Case "ItemID_Offhand"
			Return MemoryRead($lAgentPtr + 0xB8, "dword")
		Case "ItemID_Chest"
			Return MemoryRead($lAgentPtr + 0xBC, "dword")
		Case "ItemID_Legs"
			Return MemoryRead($lAgentPtr + 0xC0, "dword")
		Case "ItemID_Head"
			Return MemoryRead($lAgentPtr + 0xC4, "dword")
		Case "ItemID_Feet"
			Return MemoryRead($lAgentPtr + 0xC8, "dword")
		Case "ItemID_Hands"
			Return MemoryRead($lAgentPtr + 0xCC, "dword")
		Case "ItemID_CostumeBody"
			Return MemoryRead($lAgentPtr + 0xD0, "dword")
		Case "ItemID_CostumeHead"
			Return MemoryRead($lAgentPtr + 0xD4, "dword")
	EndSwitch
	Return 0
EndFunc

Func GetAgentVisibleEffectInfo($aAgentID = -2, $aInfo = "")
	Local $lAgentPtr = GetAgentInfo($aAgentID, "VisibleEffectsPtr")
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "" ; dummy case to avoid syntax error
            Sleep(100)
	EndSwitch

	Return 0
EndFunc

Func GetAgentArraySize()
	Return MemoryRead($mAgentBase + 0x8)
EndFunc   ;==>GetAgentArraySize

Func GetAgentArray($aType = 0)
    Local $lMaxAgents = GetAgentArraySize()
    If $lMaxAgents <= 0 Then Return

	Local $lAgentArray[$lMaxAgents + 1]
    Local $lPtr, $lCount = 0
    Local $lAgentBasePtr = MemoryRead($mAgentBase)
    Local $lAgentPtrBuffer = DllStructCreate("ptr[" & $lMaxAgents & "]")

    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, "ptr", $lAgentBasePtr, "struct*", $lAgentPtrBuffer, "ulong_ptr", 4 * $lMaxAgents, "ulong_ptr*", 0)

    For $i = 1 To $lMaxAgents
        $lPtr = DllStructGetData($lAgentPtrBuffer, 1, $i)
        If $lPtr = 0 Then ContinueLoop

        If $aType <> 0 Then
            If GetAgentInfo($lPtr, "Type") <> $aType Then ContinueLoop
        EndIf

        $lCount += 1
        $lAgentArray[$lCount] = $lPtr
    Next

    $lAgentArray[0] = $lCount
    ReDim $lAgentArray[$lCount + 1]

    Return $lAgentArray
EndFunc

;~ Func GetAgentArray()
;~     Local $lAgentArray = MemoryReadArray($mAgentBase, 0x8)
;~     Return $lAgentArray
;~ EndFunc
#EndRegion Agent Related

#Region Camera Related
#EndRegion Camera Related

#Region FriendList Related
#EndRegion FriendList Related

#Region Salvage Session Related
#EndRegion Salvage Session Related
#EndRegion Outside Context Info

#Region Static Infos
#Region Area Related
Func GetAreaPtr($aMapID = 0)
    Local $lAreaInfoAddress = $mAreaInfo + (0x7C * $aMapID)
    Return Ptr($lAreaInfoAddress)
EndFunc

Func GetAreaInfo($aMapID, $aInfo = "")
    Local $lPtr = GetAreaPtr($aMapID)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Campaign"
            Return MemoryRead($lPtr, "long")
        Case "Continent"
            Return MemoryRead($lPtr + 0x4, "long")
        Case "Region"
            Return MemoryRead($lPtr + 0x8, "long")
        Case "RegionType"
            Return MemoryRead($lPtr + 0xC, "long")
        Case "Flags"
            Return MemoryRead($lPtr + 0x10, "long")
        Case "ThumbnailID"
            Return MemoryRead($lPtr + 0x14, "long")
        Case "MinPartySize"
            Return MemoryRead($lPtr + 0x18, "long")
        Case "MaxPartySize"
            Return MemoryRead($lPtr + 0x1C, "long")
        Case "MinPlayerSize"
            Return MemoryRead($lPtr + 0x20, "long")
        Case "MaxPlayerSize"
            Return MemoryRead($lPtr + 0x24, "long")
        Case "ControlledOutpostID"
            Return MemoryRead($lPtr + 0x28, "long")
        Case "FractionMission"
            Return MemoryRead($lPtr + 0x2C, "long")
        Case "MinLevel"
            Return MemoryRead($lPtr + 0x30, "long")
        Case "MaxLevel"
            Return MemoryRead($lPtr + 0x34, "long")
        Case "NeededPQ"
            Return MemoryRead($lPtr + 0x38, "long")
        Case "MissionMapsTo"
            Return MemoryRead($lPtr + 0x3C, "long")
        Case "X"
            Return MemoryRead($lPtr + 0x40, "long")
        Case "Y"
            Return MemoryRead($lPtr + 0x44, "long")
        Case "IconStartX"
            Return MemoryRead($lPtr + 0x48, "long")
        Case "IconStartY"
            Return MemoryRead($lPtr + 0x4C, "long")
        Case "IconEndX"
            Return MemoryRead($lPtr + 0x50, "long")
        Case "IconEndY"
            Return MemoryRead($lPtr + 0x54, "long")
        Case "IconStartXDupe"
            Return MemoryRead($lPtr + 0x58, "long")
        Case "IconStartYDupe"
            Return MemoryRead($lPtr + 0x5C, "long")
        Case "IconEndXDupe"
            Return MemoryRead($lPtr + 0x60, "long")
        Case "IconEndYDupe"
            Return MemoryRead($lPtr + 0x64, "long")
        Case "FileID"
            Return MemoryRead($lPtr + 0x68, "long")
        Case "MissionChronology"
            Return MemoryRead($lPtr + 0x6C, "long")
        Case "HAMapChronology"
            Return MemoryRead($lPtr + 0x70, "long")
        Case "NameID"
            Return MemoryRead($lPtr + 0x74, "long")
        Case "DescriptionID"
            Return MemoryRead($lPtr + 0x78, "long")


        Case "FileID1"
            Local $fileID = MemoryRead($lPtr + 0x68, "long")
            Return Mod(($fileID - 1), 0xFF00) + 0x100
        Case "FileID2"
            Local $fileID = MemoryRead($lPtr + 0x68, "long")
            Return Int(($fileID - 1) / 0xFF00) + 0x100
        Case "HasEnterButton"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x100) <> 0 Or BitAND($flags, 0x40000) <> 0
        Case "IsOnWorldMap"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x20) = 0
        Case "IsPvP"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x40001) <> 0
        Case "IsGuildHall"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x800000) <> 0
        Case "IsVanquishableArea"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x10000000) <> 0
        Case "IsUnlockable"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x10000) <> 0
        Case "HasMissionMapsTo"
            Local $flags = MemoryRead($lPtr + 0x10, "long")
            Return BitAND($flags, 0x8000000) <> 0
	EndSwitch

    Return 0
EndFunc   ;==>GetAreaInfo
#EndRegion Area Related

#Region Title Client Data Related
#EndRegion Title Client Data Related

#EndRegion Static Infos

