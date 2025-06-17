#include-once

Func GwAu3_SkillMod_GetLastUsedSkill()
    Return $g_iLastSkillUsed
EndFunc

Func GwAu3_SkillMod_GetLastTarget()
    Return $g_iLastSkillTarget
EndFunc

Func GwAu3_SkillMod_GetSkillTimer()
	Local $lExeStart = GwAu3_Memory_Read($g_p_SkillTimer, 'dword')
	Local $lTickCount = DllCall($g_h_Kernel32, 'dword', 'GetTickCount')[0]
	Return Int($lTickCount + $lExeStart, 1)
EndFunc

Func GwAu3_SkillMod_GetSkillPtr($aSkillID)
    If IsPtr($aSkillID) Then Return $aSkillID
	Local $Skillptr = $g_p_SkillBase + 0xA0 * $aSkillID
	Return Ptr($Skillptr)
EndFunc

Func GwAu3_SkillMod_GetSkillInfo($aSkillID, $aInfo = "")
    Local $lPtr = _SkillMod_GetSkillPtr($aSkillID)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "SkillID"
            Return GwAu3_Memory_Read($lPtr, "long")
        Case "h0004"
            Return GwAu3_Memory_Read($lPtr + 0x4, "long")
        Case "Campaign"
            Return GwAu3_Memory_Read($lPtr + 0x8, "long")
        Case "SkillType"
            Return GwAu3_Memory_Read($lPtr + 0xC, "long")
        Case "Special"
            Return GwAu3_Memory_Read($lPtr + 0x10, "long")
        Case "ComboReq"
            Return GwAu3_Memory_Read($lPtr + 0x14, "long")
        Case "Effect1"
            Return GwAu3_Memory_Read($lPtr + 0x18, "long")
        Case "Condition"
            Return GwAu3_Memory_Read($lPtr + 0x1C, "long")
        Case "Effect2"
            Return GwAu3_Memory_Read($lPtr + 0x20, "long")
        Case "WeaponReq"
            Return GwAu3_Memory_Read($lPtr + 0x24, "long")
        Case "Profession"
            Return GwAu3_Memory_Read($lPtr + 0x28, "byte")
        Case "Attribute"
            Return GwAu3_Memory_Read($lPtr + 0x29, "byte")
        Case "Title"
            Return GwAu3_Memory_Read($lPtr + 0x2A, "word")
        Case "SkillIDPvP"
            Return GwAu3_Memory_Read($lPtr + 0x2C, "long")
        Case "Combo"
            Return GwAu3_Memory_Read($lPtr + 0x30, "byte")
        Case "Target"
            Return GwAu3_Memory_Read($lPtr + 0x31, "byte")
        Case "h0032"
            Return GwAu3_Memory_Read($lPtr + 0x32, "byte")
        Case "SkillEquipType"
            Return GwAu3_Memory_Read($lPtr + 0x33, "byte")
        Case "Overcast"
            Return GwAu3_Memory_Read($lPtr + 0x34, "byte")
        Case "EnergyCost"
			Local $lEnergyCost = GwAu3_Memory_Read($lPtr + 0x35, "byte")
			Select
				Case $lEnergyCost = 11
					Return 15
				Case $lEnergyCost = 12
					Return 25
				Case Else
					Return $lEnergyCost
			EndSelect
        Case "HealthCost"
            Return GwAu3_Memory_Read($lPtr + 0x36, "byte")
        Case "h0037"
            Return GwAu3_Memory_Read($lPtr + 0x37, "byte")
        Case "Adrenaline"
            Return GwAu3_Memory_Read($lPtr + 0x38, "dword")
        Case "Activation"
            Return GwAu3_Memory_Read($lPtr + 0x3C, "float")
        Case "Aftercast"
            Return GwAu3_Memory_Read($lPtr + 0x40, "float")
        Case "Duration0"
            Return GwAu3_Memory_Read($lPtr + 0x44, "dword")
        Case "Duration15"
            Return GwAu3_Memory_Read($lPtr + 0x48, "dword")
        Case "Recharge"
            Return GwAu3_Memory_Read($lPtr + 0x4C, "dword")
        Case "h0050"
            Return GwAu3_Memory_Read($lPtr + 0x50, "word")
        Case "h0052"
            Return GwAu3_Memory_Read($lPtr + 0x52, "word")
        Case "h0054"
            Return GwAu3_Memory_Read($lPtr + 0x54, "word")
        Case "h0056"
            Return GwAu3_Memory_Read($lPtr + 0x56, "word")
        Case "SkillArguments"
            Return GwAu3_Memory_Read($lPtr + 0x58, "dword")
        Case "Scale0"
            Return GwAu3_Memory_Read($lPtr + 0x5C, "dword")
        Case "Scale15"
            Return GwAu3_Memory_Read($lPtr + 0x60, "dword")
        Case "BonusScale0"
            Return GwAu3_Memory_Read($lPtr + 0x64, "dword")
        Case "BonusScale15"
            Return GwAu3_Memory_Read($lPtr + 0x68, "dword")
        Case "AoeRange"
            Return GwAu3_Memory_Read($lPtr + 0x6C, "float")
        Case "ConstEffect"
            Return GwAu3_Memory_Read($lPtr + 0x70, "float")
        Case "CasterOverheadAnimationID"
            Return GwAu3_Memory_Read($lPtr + 0x74, "dword")
        Case "CasterBodyAnimationID"
            Return GwAu3_Memory_Read($lPtr + 0x78, "dword")
        Case "TargetBodyAnimationID"
            Return GwAu3_Memory_Read($lPtr + 0x7C, "dword")
        Case "TargetOverheadAnimationID"
            Return GwAu3_Memory_Read($lPtr + 0x80, "dword")
        Case "ProjectileAnimation1ID"
            Return GwAu3_Memory_Read($lPtr + 0x84, "dword")
        Case "ProjectileAnimation2ID"
            Return GwAu3_Memory_Read($lPtr + 0x88, "dword")
        Case "IconFileID"
            Return GwAu3_Memory_Read($lPtr + 0x8C, "dword")
        Case "IconFileID2"
            Return GwAu3_Memory_Read($lPtr + 0x90, "dword")
        Case "Name"
            Return GwAu3_Memory_Read($lPtr + 0x94, "dword")
        Case "Concise"
            Return GwAu3_Memory_Read($lPtr + 0x98, "dword")
        Case "Description"
            Return GwAu3_Memory_Read($lPtr + 0x9C, "dword")
    EndSwitch

    Return 0
EndFunc

#Region Skillbar Related
Func GwAu3_SkillMod_GetSkillbarInfo($aSkillSlot = 1, $aInfo = "", $aHeroNumber = 0)
	Local $lPtr = GwAu3_OtherMod_GetWorldInfo("SkillbarArray")
	Local $lSize = GwAu3_OtherMod_GetWorldInfo("SkillbarArraySize")

	If $lPtr = 0 Or $aHeroNumber < 0 Or $aHeroNumber >= $lSize Then Return 0
	If $aSkillSlot < 1 Or $aSkillSlot > 8 Then Return 0

	If $aHeroNumber <> 0 Then
		local $lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		local $lHeroID = GwAu3_AgentMod_GetMyID()
	EndIf

	If $lHeroID = 0 Then Return 0

	Local $lReadHeroID, $lSkillbarPtr
	For $i = 0 To $lSize - 1
		$lSkillbarPtr = $lPtr + (0xBC * $i)
		$lReadHeroID = GwAu3_Memory_Read($lSkillbarPtr, "long")
		If $lSkillbarPtr <> 0 And $lReadHeroID = $lHeroID Then ExitLoop
	Next
	If $lSkillbarPtr = 0 Or $lReadHeroID <> $lHeroID Then Return 0

    Switch $aInfo
        Case "AgentID"
            Return GwAu3_Memory_Read($lSkillbarPtr, "long")
        Case "Disabled"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0xA4, "dword")
        Case "Casting"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0xB0, "dword")
        Case "h00A8[2]"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0xA8, "dword")
        Case "h00B4[2]"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0xB4, "dword")

        Case "SkillID"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0x10 + (($aSkillSlot - 1) * 0x14), "dword")

        Case "IsRecharged"
            Local $lTimestamp = GwAu3_Memory_Read($lSkillbarPtr + 0xC + (($aSkillSlot - 1) * 0x14), "dword")
            If $lTimestamp = 0 Then Return True
            Return ($lTimestamp - _SkillMod_GetSkillTimer()) = 0

        Case "RawRecharged"
            Local $lTimestamp = GwAu3_Memory_Read($lSkillbarPtr + 0xC + (($aSkillSlot - 1) * 0x14), "dword")
			Local $lSkillID = GwAu3_Memory_Read($lSkillbarPtr + 0x10 + (($aSkillSlot - 1) * 0x14), "dword")
			Return _SkillMod_GetSkillInfo($lSkillID, "Recharge") - (_SkillMod_GetSkillTimer() - $lTimestamp)

        Case "Adrenaline"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0x4 + (($aSkillSlot - 1) * 0x14), "dword")

		Case "AdrenalineB"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0x8 + (($aSkillSlot - 1) * 0x14), "dword")

        Case "Event"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0x14 + (($aSkillSlot - 1) * 0x14), "dword")

        Case "HasSkill"
            Return GwAu3_Memory_Read($lSkillbarPtr + 0x10 + (($aSkillSlot - 1) * 0x14), "dword") <> 0

        Case "SlotBySkillID"
            For $slot = 1 To 8
                If GwAu3_Memory_Read($lSkillbarPtr + 0x10 + (($slot - 1) * 0x14), "dword") = $aSkillSlot Then
                    Return $slot
                EndIf
            Next
            Return 0

        Case "HasSkillID"
            For $slot = 1 To 8
                If GwAu3_Memory_Read($lSkillbarPtr + 0x10 + (($slot - 1) * 0x14), "dword") = $aSkillSlot Then
                    Return True
                EndIf
            Next
            Return False

        Case Else
            Return 0
    EndSwitch
EndFunc   ;==>_SkillMod_GetSkillbarInfo
#EndRegion Skillbar Related