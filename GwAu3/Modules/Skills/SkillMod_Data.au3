#include-once
#include "SkillMod_Initialize.au3"

Func _SkillMod_GetLastUsedSkill()
    Return $g_iLastSkillUsed
EndFunc

Func _SkillMod_GetLastTarget()
    Return $g_iLastSkillTarget
EndFunc

Func _SkillMod_GetSkillTimer()
	Local $lExeStart = MemoryRead($g_mSkillTimer, 'dword')
	Local $lTickCount = DllCall($mKernelHandle, 'dword', 'GetTickCount')[0]
	Return Int($lTickCount + $lExeStart, 1)
EndFunc

Func _SkillMod_GetSkillPtr($aSkillID)
    If IsPtr($aSkillID) Then Return $aSkillID
	Local $Skillptr = $g_mSkillBase + 0xA0 * $aSkillID
	Return Ptr($Skillptr)
EndFunc

Func _SkillMod_GetSkillInfo($aSkillID, $aInfo = "")
    Local $lPtr = _SkillMod_GetSkillPtr($aSkillID)
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "SkillID"
            Return MemoryRead($lPtr, "long")
        Case "h0004"
            Return MemoryRead($lPtr + 0x4, "long")
        Case "Campaign"
            Return MemoryRead($lPtr + 0x8, "long")
        Case "SkillType"
            Return MemoryRead($lPtr + 0xC, "long")
        Case "Special"
            Return MemoryRead($lPtr + 0x10, "long")
        Case "ComboReq"
            Return MemoryRead($lPtr + 0x14, "long")
        Case "Effect1"
            Return MemoryRead($lPtr + 0x18, "long")
        Case "Condition"
            Return MemoryRead($lPtr + 0x1C, "long")
        Case "Effect2"
            Return MemoryRead($lPtr + 0x20, "long")
        Case "WeaponReq"
            Return MemoryRead($lPtr + 0x24, "long")
        Case "Profession"
            Return MemoryRead($lPtr + 0x28, "byte")
        Case "Attribute"
            Return MemoryRead($lPtr + 0x29, "byte")
        Case "Title"
            Return MemoryRead($lPtr + 0x2A, "word")
        Case "SkillIDPvP"
            Return MemoryRead($lPtr + 0x2C, "long")
        Case "Combo"
            Return MemoryRead($lPtr + 0x30, "byte")
        Case "Target"
            Return MemoryRead($lPtr + 0x31, "byte")
        Case "h0032"
            Return MemoryRead($lPtr + 0x32, "byte")
        Case "SkillEquipType"
            Return MemoryRead($lPtr + 0x33, "byte")
        Case "Overcast"
            Return MemoryRead($lPtr + 0x34, "byte")
        Case "EnergyCost"
			Local $lEnergyCost = MemoryRead($lPtr + 0x35, "byte")
			Select
				Case $lEnergyCost = 11
					Return 15
				Case $lEnergyCost = 12
					Return 25
				Case Else
					Return $lEnergyCost
			EndSelect
        Case "HealthCost"
            Return MemoryRead($lPtr + 0x36, "byte")
        Case "h0037"
            Return MemoryRead($lPtr + 0x37, "byte")
        Case "Adrenaline"
            Return MemoryRead($lPtr + 0x38, "dword")
        Case "Activation"
            Return MemoryRead($lPtr + 0x3C, "float")
        Case "Aftercast"
            Return MemoryRead($lPtr + 0x40, "float")
        Case "Duration0"
            Return MemoryRead($lPtr + 0x44, "dword")
        Case "Duration15"
            Return MemoryRead($lPtr + 0x48, "dword")
        Case "Recharge"
            Return MemoryRead($lPtr + 0x4C, "dword")
        Case "h0050"
            Return MemoryRead($lPtr + 0x50, "word")
        Case "h0052"
            Return MemoryRead($lPtr + 0x52, "word")
        Case "h0054"
            Return MemoryRead($lPtr + 0x54, "word")
        Case "h0056"
            Return MemoryRead($lPtr + 0x56, "word")
        Case "SkillArguments"
            Return MemoryRead($lPtr + 0x58, "dword")
        Case "Scale0"
            Return MemoryRead($lPtr + 0x5C, "dword")
        Case "Scale15"
            Return MemoryRead($lPtr + 0x60, "dword")
        Case "BonusScale0"
            Return MemoryRead($lPtr + 0x64, "dword")
        Case "BonusScale15"
            Return MemoryRead($lPtr + 0x68, "dword")
        Case "AoeRange"
            Return MemoryRead($lPtr + 0x6C, "float")
        Case "ConstEffect"
            Return MemoryRead($lPtr + 0x70, "float")
        Case "CasterOverheadAnimationID"
            Return MemoryRead($lPtr + 0x74, "dword")
        Case "CasterBodyAnimationID"
            Return MemoryRead($lPtr + 0x78, "dword")
        Case "TargetBodyAnimationID"
            Return MemoryRead($lPtr + 0x7C, "dword")
        Case "TargetOverheadAnimationID"
            Return MemoryRead($lPtr + 0x80, "dword")
        Case "ProjectileAnimation1ID"
            Return MemoryRead($lPtr + 0x84, "dword")
        Case "ProjectileAnimation2ID"
            Return MemoryRead($lPtr + 0x88, "dword")
        Case "IconFileID"
            Return MemoryRead($lPtr + 0x8C, "dword")
        Case "IconFileID2"
            Return MemoryRead($lPtr + 0x90, "dword")
        Case "Name"
            Return MemoryRead($lPtr + 0x94, "dword")
        Case "Concise"
            Return MemoryRead($lPtr + 0x98, "dword")
        Case "Description"
            Return MemoryRead($lPtr + 0x9C, "dword")
    EndSwitch

    Return 0
EndFunc
