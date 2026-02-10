#include-once

; ========== Dynamic Skill data ==========
Global $g_amx2_DynamicSkillCache[9][6]

Global Enum $GC_UAI_DYNAMIC_SKILL_Adrenaline, _
    $GC_UAI_DYNAMIC_SKILL_AdrenalineB, _
    $GC_UAI_DYNAMIC_SKILL_IsRecharged, _
    $GC_UAI_DYNAMIC_SKILL_SkillID, _
    $GC_UAI_DYNAMIC_SKILL_Event, _
    $GC_UAI_DYNAMIC_SKILL_RechargeTime

; ========== Cache Dynamic Skill data ==========
Func UAI_UpdateDynamicSkillbarCache()
	$g_amx2_DynamicSkillCache = 0			; resets the array if we cache a different skill bar
	Global $g_amx2_DynamicSkillCache[9][6]

    Static $ss_SkillArrayStruct = Memory_CreateArrayStructure( _
        "dword Adrenaline[0x0];" & _
        "dword AdrenalineB[0x4];" & _
        "dword Timestamp[0x8];" & _
        "dword SkillID[0xC];" & _
        "dword Event[0x10]", _
        0x14)

    Local $l_p_Ptr = World_GetWorldInfo("SkillbarArray")
    Local $l_i_Size = World_GetWorldInfo("SkillbarArraySize")
    If $l_p_Ptr = 0 Or $l_i_Size = 0 Then Return SetError(1, 0, False)

    Local $l_i_MyID = Agent_GetMyID()
    If $l_i_MyID = 0 Then Return SetError(2, 0, False)

    Local $l_p_SkillbarPtr = 0
    Local $l_i_ReadID = 0

    For $l_i_Idx = 0 To $l_i_Size - 1
        Local $l_p_CurrentPtr = $l_p_Ptr + (0xBC * $l_i_Idx)
        $l_i_ReadID = Memory_Read($l_p_CurrentPtr, "long")

        If $l_i_ReadID = $l_i_MyID Then
            $l_p_SkillbarPtr = $l_p_CurrentPtr
            ExitLoop
        EndIf
    Next

    If $l_p_SkillbarPtr = 0 Then Return SetError(3, 0, False)

    Local $l_amx2_AllSkills = Memory_ReadArrayStruct($l_p_SkillbarPtr + 0x4, 8, $ss_SkillArrayStruct)
    If @error Then Return SetError(4, 0, False)

    Local $l_i_SkillTimer = Skill_GetSkillTimer()

    For $i = 1 To 8
        Local $l_i_Idx = $i - 1

        $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_Adrenaline] = $l_amx2_AllSkills[$l_i_Idx][0]
        $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_AdrenalineB] = $l_amx2_AllSkills[$l_i_Idx][1]
        $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_SkillID] = $l_amx2_AllSkills[$l_i_Idx][3]
        $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_Event] = $l_amx2_AllSkills[$l_i_Idx][4]

        Local $l_i_RechargeTimestamp = $l_amx2_AllSkills[$l_i_Idx][2]

        If $l_i_RechargeTimestamp = 0 Then
            $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_IsRecharged] = True
            $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_RechargeTime] = 0
        Else
            Local $l_i_RechargeTimestampSigned = Utils_MakeInt32($l_i_RechargeTimestamp)
            Local $l_i_SkillTimerSigned = Utils_MakeInt32($l_i_SkillTimer)
            Local $l_i_TimeRemaining = $l_i_RechargeTimestampSigned - $l_i_SkillTimerSigned

            If $l_i_TimeRemaining <= 0 Then
                $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_IsRecharged] = True
                $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_RechargeTime] = 0
            Else
                $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_IsRecharged] = False
                $g_amx2_DynamicSkillCache[$i][$GC_UAI_DYNAMIC_SKILL_RechargeTime] = $l_i_TimeRemaining
            EndIf
        EndIf
    Next

    Return True
EndFunc

Func UAI_GetDynamicSkillInfo($a_i_Slot, $a_i_InfoType)
    If $a_i_Slot < 1 Or $a_i_Slot > 8 Then Return 0
    If $a_i_InfoType < 0 Or $a_i_InfoType > 5 Then Return 0
    Return $g_amx2_DynamicSkillCache[$a_i_Slot][$a_i_InfoType]
EndFunc
