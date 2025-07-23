#include-once

Func Skill_GetLastUsedSkill()
    Return $g_i_LastSkillUsed
EndFunc

Func Skill_GetLastTarget()
    Return $g_i_LastSkillTarget
EndFunc

Func Skill_GetSkillTimer()
    Static $l_i_ExeStart = Memory_Read($g_p_SkillTimer, 'dword')
    Local $l_i_TickCount = DllCall($g_h_Kernel32, 'dword', 'GetTickCount')[0]
    Return BitAND($l_i_TickCount + $l_i_ExeStart, 0xFFFFFFFF)
EndFunc

Func Skill_GetSkillPtr($a_v_SkillID)
    If IsPtr($a_v_SkillID) Then Return $a_v_SkillID
    Local $l_p_SkillPtr = $g_p_SkillBase + 0xA0 * $a_v_SkillID
    Return Ptr($l_p_SkillPtr)
EndFunc

Func Skill_GetSkillInfo($a_v_SkillID, $a_s_Info = "")
    Local $l_p_Ptr = Skill_GetSkillPtr($a_v_SkillID)
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "SkillID"
            Return Memory_Read($l_p_Ptr, "long")
        Case "h0004"
            Return Memory_Read($l_p_Ptr + 0x4, "long")
        Case "Campaign"
            Return Memory_Read($l_p_Ptr + 0x8, "long")
        Case "SkillType"
            Return Memory_Read($l_p_Ptr + 0xC, "long")
        Case "Special"
            Return Memory_Read($l_p_Ptr + 0x10, "long")
        Case "ComboReq"
            Return Memory_Read($l_p_Ptr + 0x14, "long")
        Case "Effect1"
            Return Memory_Read($l_p_Ptr + 0x18, "long")
        Case "Condition"
            Return Memory_Read($l_p_Ptr + 0x1C, "long")
        Case "Effect2"
            Return Memory_Read($l_p_Ptr + 0x20, "long")
        Case "WeaponReq"
            Return Memory_Read($l_p_Ptr + 0x24, "long")
        Case "Profession"
            Return Memory_Read($l_p_Ptr + 0x28, "byte")
        Case "Attribute"
            Return Memory_Read($l_p_Ptr + 0x29, "byte")
        Case "Title"
            Return Memory_Read($l_p_Ptr + 0x2A, "word")
        Case "SkillIDPvP"
            Return Memory_Read($l_p_Ptr + 0x2C, "long")
        Case "Combo"
            Return Memory_Read($l_p_Ptr + 0x30, "byte")
        Case "Target"
            Return Memory_Read($l_p_Ptr + 0x31, "byte")
        Case "h0032"
            Return Memory_Read($l_p_Ptr + 0x32, "byte")
        Case "SkillEquipType"
            Return Memory_Read($l_p_Ptr + 0x33, "byte")
        Case "Overcast"
            Return Memory_Read($l_p_Ptr + 0x34, "byte")
        Case "EnergyCost"
            Local $l_i_EnergyCost = Memory_Read($l_p_Ptr + 0x35, "byte")
            Select
                Case $l_i_EnergyCost = 11
                    Return 15
                Case $l_i_EnergyCost = 12
                    Return 25
                Case Else
                    Return $l_i_EnergyCost
            EndSelect
        Case "HealthCost"
            Return Memory_Read($l_p_Ptr + 0x36, "byte")
        Case "h0037"
            Return Memory_Read($l_p_Ptr + 0x37, "byte")
        Case "Adrenaline"
            Return Memory_Read($l_p_Ptr + 0x38, "dword")
        Case "Activation"
            Return Memory_Read($l_p_Ptr + 0x3C, "float")
        Case "Aftercast"
            Return Memory_Read($l_p_Ptr + 0x40, "float")
        Case "Duration0"
            Return Memory_Read($l_p_Ptr + 0x44, "dword")
        Case "Duration15"
            Return Memory_Read($l_p_Ptr + 0x48, "dword")
        Case "Recharge"
            Return Memory_Read($l_p_Ptr + 0x4C, "dword")
        Case "h0050"
            Return Memory_Read($l_p_Ptr + 0x50, "word")
        Case "h0052"
            Return Memory_Read($l_p_Ptr + 0x52, "word")
        Case "h0054"
            Return Memory_Read($l_p_Ptr + 0x54, "word")
        Case "h0056"
            Return Memory_Read($l_p_Ptr + 0x56, "word")
        Case "SkillArguments"
            Return Memory_Read($l_p_Ptr + 0x58, "dword")
        Case "Scale0"
            Return Memory_Read($l_p_Ptr + 0x5C, "dword")
        Case "Scale15"
            Return Memory_Read($l_p_Ptr + 0x60, "dword")
        Case "BonusScale0"
            Return Memory_Read($l_p_Ptr + 0x64, "dword")
        Case "BonusScale15"
            Return Memory_Read($l_p_Ptr + 0x68, "dword")
        Case "AoeRange"
            Return Memory_Read($l_p_Ptr + 0x6C, "float")
        Case "ConstEffect"
            Return Memory_Read($l_p_Ptr + 0x70, "float")
        Case "CasterOverheadAnimationID"
            Return Memory_Read($l_p_Ptr + 0x74, "dword")
        Case "CasterBodyAnimationID"
            Return Memory_Read($l_p_Ptr + 0x78, "dword")
        Case "TargetBodyAnimationID"
            Return Memory_Read($l_p_Ptr + 0x7C, "dword")
        Case "TargetOverheadAnimationID"
            Return Memory_Read($l_p_Ptr + 0x80, "dword")
        Case "ProjectileAnimation1ID"
            Return Memory_Read($l_p_Ptr + 0x84, "dword")
        Case "ProjectileAnimation2ID"
            Return Memory_Read($l_p_Ptr + 0x88, "dword")
        Case "IconFileID"
            Return Memory_Read($l_p_Ptr + 0x8C, "dword")
        Case "IconFileID2"
            Return Memory_Read($l_p_Ptr + 0x90, "dword")
        Case "Name"
            Return Memory_Read($l_p_Ptr + 0x94, "dword")
        Case "Concise"
            Return Memory_Read($l_p_Ptr + 0x98, "dword")
        Case "Description"
            Return Memory_Read($l_p_Ptr + 0x9C, "dword")
    EndSwitch

    Return 0
EndFunc

#Region Skillbar Related
Func Skill_GetSkillbarInfo($a_i_SkillSlot = 1, $a_s_Info = "", $a_i_HeroNumber = 0)
    Local $l_p_Ptr = World_GetWorldInfo("SkillbarArray")
    Local $l_i_Size = World_GetWorldInfo("SkillbarArraySize")

    If $l_p_Ptr = 0 Or $a_i_HeroNumber < 0 Or $a_i_HeroNumber >= $l_i_Size Then Return 0
    If $a_i_SkillSlot < 1 Or $a_i_SkillSlot > 8 Then Return 0

    If $a_i_HeroNumber <> 0 Then
        Local $l_i_HeroID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Else
        Local $l_i_HeroID = Agent_GetMyID()
    EndIf

    If $l_i_HeroID = 0 Then Return 0

    Local $l_i_ReadHeroID, $l_p_SkillbarPtr
    For $l_i_Idx = 0 To $l_i_Size - 1
        $l_p_SkillbarPtr = $l_p_Ptr + (0xBC * $l_i_Idx)
        $l_i_ReadHeroID = Memory_Read($l_p_SkillbarPtr, "long")
        If $l_p_SkillbarPtr <> 0 And $l_i_ReadHeroID = $l_i_HeroID Then ExitLoop
    Next
    If $l_p_SkillbarPtr = 0 Or $l_i_ReadHeroID <> $l_i_HeroID Then Return 0

    Switch $a_s_Info
        Case "AgentID"
            Return Memory_Read($l_p_SkillbarPtr, "long")
        Case "Disabled"
            Return Memory_Read($l_p_SkillbarPtr + 0xA4, "dword")
        Case "Casting"
            Return Memory_Read($l_p_SkillbarPtr + 0xB0, "dword")
        Case "h00A8[2]"
            Return Memory_Read($l_p_SkillbarPtr + 0xA8, "dword")
        Case "h00B4[2]"
            Return Memory_Read($l_p_SkillbarPtr + 0xB4, "dword")

        Case "SkillID"
            Return Memory_Read($l_p_SkillbarPtr + 0x10 + (($a_i_SkillSlot - 1) * 0x14), "dword")

        Case "IsRecharged"
            Local $l_i_Timestamp = Memory_Read($l_p_SkillbarPtr + 0xC + (($a_i_SkillSlot - 1) * 0x14), "dword")
            If $l_i_Timestamp = 0 Then Return True
            Return ($l_i_Timestamp - Skill_GetSkillTimer()) = 0

        Case "RechargeTime"
			Local $l_i_RechargeTimestamp = Memory_Read($l_p_SkillbarPtr + 0xC + (($a_i_SkillSlot - 1) * 0x14), "dword")
			If $l_i_RechargeTimestamp = 0 Then Return 0

			Local $l_i_RechargeTimestampSigned = Utils_MakeInt32($l_i_RechargeTimestamp)
			Local $l_i_SkillTimerSigned = Utils_MakeInt32(Skill_GetSkillTimer())

			Local $l_i_TimeRemaining = $l_i_RechargeTimestampSigned - $l_i_SkillTimerSigned
			If $l_i_TimeRemaining <= 0 Then
				Return 0
			Else
				Return $l_i_TimeRemaining
			EndIf

        Case "Adrenaline"
            Return Memory_Read($l_p_SkillbarPtr + 0x4 + (($a_i_SkillSlot - 1) * 0x14), "dword")

        Case "AdrenalineB"
            Return Memory_Read($l_p_SkillbarPtr + 0x8 + (($a_i_SkillSlot - 1) * 0x14), "dword")

        Case "Event"
            Return Memory_Read($l_p_SkillbarPtr + 0x14 + (($a_i_SkillSlot - 1) * 0x14), "dword")

        Case "HasSkill"
            Return Memory_Read($l_p_SkillbarPtr + 0x10 + (($a_i_SkillSlot - 1) * 0x14), "dword") <> 0

        Case "SlotBySkillID"
            For $l_i_Slot = 1 To 8
                If Memory_Read($l_p_SkillbarPtr + 0x10 + (($l_i_Slot - 1) * 0x14), "dword") = $a_i_SkillSlot Then
                    Return $l_i_Slot
                EndIf
            Next
            Return 0

        Case "HasSkillID"
            For $l_i_Slot = 1 To 8
                If Memory_Read($l_p_SkillbarPtr + 0x10 + (($l_i_Slot - 1) * 0x14), "dword") = $a_i_SkillSlot Then
                    Return True
                EndIf
            Next
            Return False

        Case Else
            Return 0
    EndSwitch
EndFunc   ;==>GetSkillbarInfo
#EndRegion Skillbar Related