#include-once

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

Func GwAu3_TitleMod_GetTitleInfo($aTitle = 0, $aInfo = "")
	Local $lPtr = GwAu3_OtherMod_GetWorldInfo("TitleArray")
	Local $lSize = GwAu3_OtherMod_GetWorldInfo("TitleArraySize")
	If $lPtr = 0 Or $aTitle < 0 Or $aTitle >= $lSize Then Return 0

    $lPtr = $lPtr + ($aTitle * 0x28)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "Props"
			Return GwAu3_Memory_Read($lPtr, "dword")
		Case "CurrentPoints"
			Return GwAu3_Memory_Read($lPtr + 0x4, "dword")
		Case "CurrentTitleTier"
			Return GwAu3_Memory_Read($lPtr + 0x8, "dword")
		Case "PointsNeededCurrentRank"
			Return GwAu3_Memory_Read($lPtr + 0xC, "dword")
		Case "NextTitleTier"
			Return GwAu3_Memory_Read($lPtr + 0x10, "dword")
		Case "PointsNeededNextRank"
			Return GwAu3_Memory_Read($lPtr + 0x14, "dword")
		Case "MaxTitleRank"
			Return GwAu3_Memory_Read($lPtr + 0x18, "dword")
		Case "MaxTitleTier"
			Return GwAu3_Memory_Read($lPtr + 0x1C, "dword")
	EndSwitch

	Return 0
EndFunc
#EndRegion Title Related
