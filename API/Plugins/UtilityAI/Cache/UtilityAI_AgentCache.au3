#include-once

; ========== Agent data ==========
Global $g_amx2_AgentCache[1][1]
Global $g_i_AgentCacheCount = 0
Global $g_i_PlayerCacheIndex = -1
Global $g_f_PlayerCacheX = 0
Global $g_f_PlayerCacheY = 0
Global $g_ai_AgentIDToIndex[1]

Global Enum $GC_UAI_AGENT_Ptr, _
    $GC_UAI_AGENT_Timer, _
    $GC_UAI_AGENT_ID, _
    $GC_UAI_AGENT_Z, _
    $GC_UAI_AGENT_Width1, _
    $GC_UAI_AGENT_Height1, _
    $GC_UAI_AGENT_Rotation, _
    $GC_UAI_AGENT_RotationCos, _
    $GC_UAI_AGENT_RotationSin, _
    $GC_UAI_AGENT_Ground, _
    $GC_UAI_AGENT_X, _
    $GC_UAI_AGENT_Y, _
    $GC_UAI_AGENT_Plane, _
    $GC_UAI_AGENT_Type, _
    $GC_UAI_AGENT_MoveX, _
    $GC_UAI_AGENT_MoveY, _
    $GC_UAI_AGENT_Owner, _
    $GC_UAI_AGENT_ItemID, _
    $GC_UAI_AGENT_ExtraType, _
    $GC_UAI_AGENT_GadgetID, _
    $GC_UAI_AGENT_AnimationType, _
    $GC_UAI_AGENT_AttackSpeed, _
    $GC_UAI_AGENT_AttackSpeedModifier, _
    $GC_UAI_AGENT_PlayerNumber, _
    $GC_UAI_AGENT_AgentModelType, _
    $GC_UAI_AGENT_TransmogNpcId, _
    $GC_UAI_AGENT_Equipment, _
    $GC_UAI_AGENT_Primary, _
    $GC_UAI_AGENT_Secondary, _
    $GC_UAI_AGENT_Level, _
    $GC_UAI_AGENT_Team, _
    $GC_UAI_AGENT_EnergyRegen, _
    $GC_UAI_AGENT_Overcast, _
    $GC_UAI_AGENT_EnergyPercent, _
    $GC_UAI_AGENT_MaxEnergy, _
    $GC_UAI_AGENT_CurrentEnergy, _
    $GC_UAI_AGENT_HPPips, _
    $GC_UAI_AGENT_HP, _
    $GC_UAI_AGENT_MaxHP, _
    $GC_UAI_AGENT_CurrentHP, _
    $GC_UAI_AGENT_Effects, _
    $GC_UAI_AGENT_ModelState, _
    $GC_UAI_AGENT_TypeMap, _
    $GC_UAI_AGENT_LoginNumber, _
    $GC_UAI_AGENT_AnimationSpeed, _
    $GC_UAI_AGENT_AnimationCode, _
    $GC_UAI_AGENT_AnimationId, _
    $GC_UAI_AGENT_LastStrike, _
    $GC_UAI_AGENT_Allegiance, _
    $GC_UAI_AGENT_WeaponType, _
    $GC_UAI_AGENT_Skill, _
    $GC_UAI_AGENT_WeaponItemType, _
    $GC_UAI_AGENT_OffhandItemType, _
    $GC_UAI_AGENT_WeaponItemId, _
    $GC_UAI_AGENT_OffhandItemId, _
    $GC_UAI_AGENT_Distance, _
    $GC_UAI_AGENT_IsItemType, _
    $GC_UAI_AGENT_IsGadgetType, _
    $GC_UAI_AGENT_IsLivingType, _
    $GC_UAI_AGENT_CanPickUp, _
    $GC_UAI_AGENT_IsBleeding, _
    $GC_UAI_AGENT_IsConditioned, _
    $GC_UAI_AGENT_IsCrippled, _
    $GC_UAI_AGENT_IsDead, _
    $GC_UAI_AGENT_IsDeepWounded, _
    $GC_UAI_AGENT_IsPoisoned, _
    $GC_UAI_AGENT_IsEnchanted, _
    $GC_UAI_AGENT_IsDegenHexed, _
    $GC_UAI_AGENT_IsHexed, _
    $GC_UAI_AGENT_IsWeaponSpelled, _
    $GC_UAI_AGENT_IsKnockedDown, _
    $GC_UAI_AGENT_IsMoving, _
    $GC_UAI_AGENT_IsAttacking, _
    $GC_UAI_AGENT_IsCasting, _
    $GC_UAI_AGENT_IsIdle, _
    $GC_UAI_AGENT_InCombatStance, _
    $GC_UAI_AGENT_HasQuest, _
    $GC_UAI_AGENT_IsDeadByTypeMap, _
    $GC_UAI_AGENT_IsFemale, _
    $GC_UAI_AGENT_HasBossGlow, _
    $GC_UAI_AGENT_IsHidingCap, _
    $GC_UAI_AGENT_CanBeViewedInPartyWindow, _
    $GC_UAI_AGENT_IsSpawned, _
    $GC_UAI_AGENT_IsBeingObserved, _
    $GC_UAI_AGENT_IsPlayer, _
    $GC_UAI_AGENT_IsNPC, _
    $GC_UAI_AGENT_COUNT

; ========== Cache Agents data ==========
Func UAI_UpdateAgentCache($a_f_Range = 1320, $a_i_Type = 0xDB)
    Static $ss_AgentStruct = Memory_CreateStructure( _
        "dword Timer[0x14];" & _
        "long ID[0x2C];" & _
        "float Z[0x30];" & _
        "float Width1[0x34];" & _
        "float Height1[0x38];" & _
        "float Rotation[0x4C];" & _
        "float RotationCos[0x50];" & _
        "float RotationSin[0x54];" & _
        "dword Ground[0x5C];" & _
        "float X[0x74];" & _
        "float Y[0x78];" & _
        "dword Plane[0x7C];" & _
        "long Type[0x9C];" & _
        "float MoveX[0xA0];" & _
        "float MoveY[0xA4];" & _
        "long Owner[0xC4];" & _
        "dword ItemID[0xC8];" & _
        "dword ExtraType[0xCC];" & _
        "dword GadgetID[0xD0];" & _
        "float AnimationType[0xE0];" & _
        "float AttackSpeed[0xEC];" & _
        "float AttackSpeedModifier[0xF0];" & _
        "short PlayerNumber[0xF4];" & _
        "short AgentModelType[0xF6];" & _
        "dword TransmogNpcId[0xF8];" & _
        "ptr Equipment[0xFC];" & _
        "byte Primary[0x10E];" & _
        "byte Secondary[0x10F];" & _
        "byte Level[0x110];" & _
        "byte Team[0x111];" & _
        "float EnergyRegen[0x118];" & _
        "float Overcast[0x11C];" & _
        "float EnergyPercent[0x120];" & _
        "dword MaxEnergy[0x124];" & _
        "float HPPips[0x12C];" & _
        "float HP[0x134];" & _
        "dword MaxHP[0x138];" & _
        "dword Effects[0x13C];" & _
        "dword ModelState[0x158];" & _
        "dword TypeMap[0x15C];" & _
        "dword LoginNumber[0x184];" & _
        "float AnimationSpeed[0x188];" & _
        "dword AnimationCode[0x18C];" & _
        "dword AnimationId[0x190];" & _
        "byte LastStrike[0x1B4];" & _
        "byte Allegiance[0x1B5];" & _
        "short WeaponType[0x1B6];" & _
        "short Skill[0x1B8];" & _
        "byte WeaponItemType[0x1BC];" & _
        "byte OffhandItemType[0x1BD];" & _
        "short WeaponItemId[0x1BE];" & _
        "short OffhandItemId[0x1C0]")

    $g_i_AgentCacheCount = 0
    $g_i_PlayerCacheIndex = -1

    Local $l_i_MyID = Agent_GetMyID()
    If $l_i_MyID = 0 Then Return SetError(1, 0, False)

    $g_f_PlayerCacheX = Agent_GetAgentInfo(-2, "X")
    $g_f_PlayerCacheY = Agent_GetAgentInfo(-2, "Y")

    Local $l_ap_AgentArray = Agent_GetAgentArray($a_i_Type)
    If Not IsArray($l_ap_AgentArray) Or $l_ap_AgentArray[0] = 0 Then Return SetError(2, 0, False)

    Local $l_i_TotalAgents = $l_ap_AgentArray[0]
    Local $l_f_RangeSquared = $a_f_Range * $a_f_Range

    ReDim $g_amx2_AgentCache[$l_i_TotalAgents + 1][$GC_UAI_AGENT_COUNT]

    Local $l_i_CacheIndex = 0
    For $i = 1 To $l_i_TotalAgents
        Local $l_p_AgentPtr = $l_ap_AgentArray[$i]
        If $l_p_AgentPtr = 0 Then ContinueLoop

        Local $l_av_Data = Memory_ReadStruct($l_p_AgentPtr, $ss_AgentStruct)
        If @error Then ContinueLoop

        Local $l_i_ID = $l_av_Data[1]
        Local $l_f_X = $l_av_Data[9]
        Local $l_f_Y = $l_av_Data[10]

        Local $l_f_DX = $l_f_X - $g_f_PlayerCacheX
        Local $l_f_DY = $l_f_Y - $g_f_PlayerCacheY
        Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

        Local $l_b_IsPlayer = ($l_i_ID = $l_i_MyID)
        If Not $l_b_IsPlayer And $l_f_DistSquared > $l_f_RangeSquared Then ContinueLoop

        $l_i_CacheIndex += 1

        Local $l_i_Effects = $l_av_Data[37]
        Local $l_i_ModelState = $l_av_Data[38]
        Local $l_i_TypeMap = $l_av_Data[39]
        Local $l_i_Type = $l_av_Data[12]
        Local $l_i_Owner = $l_av_Data[15]
        Local $l_i_LoginNumber = $l_av_Data[40]
        Local $l_f_MoveX = $l_av_Data[13]
        Local $l_f_MoveY = $l_av_Data[14]

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Ptr] = $l_p_AgentPtr
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Timer] = $l_av_Data[0]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_ID] = $l_i_ID
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Z] = $l_av_Data[2]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Width1] = $l_av_Data[3]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Height1] = $l_av_Data[4]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Rotation] = $l_av_Data[5]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_RotationCos] = $l_av_Data[6]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_RotationSin] = $l_av_Data[7]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Ground] = $l_av_Data[8]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_X] = $l_f_X
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Y] = $l_f_Y
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Plane] = $l_av_Data[11]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Type] = $l_i_Type
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_MoveX] = $l_f_MoveX
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_MoveY] = $l_f_MoveY
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Owner] = $l_i_Owner
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_ItemID] = $l_av_Data[16]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_ExtraType] = $l_av_Data[17]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_GadgetID] = $l_av_Data[18]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_AnimationType] = $l_av_Data[19]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_AttackSpeed] = $l_av_Data[20]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_AttackSpeedModifier] = $l_av_Data[21]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_PlayerNumber] = $l_av_Data[22]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_AgentModelType] = $l_av_Data[23]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_TransmogNpcId] = $l_av_Data[24]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Equipment] = $l_av_Data[25]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Primary] = $l_av_Data[26]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Secondary] = $l_av_Data[27]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Level] = $l_av_Data[28]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Team] = $l_av_Data[29]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_EnergyRegen] = $l_av_Data[30]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Overcast] = $l_av_Data[31]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_EnergyPercent] = $l_av_Data[32]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_MaxEnergy] = $l_av_Data[33]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_CurrentEnergy] = $l_av_Data[32] * $l_av_Data[33]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_HPPips] = $l_av_Data[34]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_HP] = $l_av_Data[35]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_MaxHP] = $l_av_Data[36]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_CurrentHP] = $l_av_Data[35] * $l_av_Data[36]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Effects] = $l_i_Effects
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_ModelState] = $l_i_ModelState
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_TypeMap] = $l_i_TypeMap
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_LoginNumber] = $l_i_LoginNumber
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_AnimationSpeed] = $l_av_Data[41]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_AnimationCode] = $l_av_Data[42]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_AnimationId] = $l_av_Data[43]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_LastStrike] = $l_av_Data[44]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Allegiance] = $l_av_Data[45]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_WeaponType] = $l_av_Data[46]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Skill] = $l_av_Data[47]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_WeaponItemType] = $l_av_Data[48]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_OffhandItemType] = $l_av_Data[49]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_WeaponItemId] = $l_av_Data[50]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_OffhandItemId] = $l_av_Data[51]

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_Distance] = Sqrt($l_f_DistSquared)

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsItemType] = ($l_i_Type = 0x400)
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsGadgetType] = ($l_i_Type = 0x200)
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsLivingType] = ($l_i_Type = 0xDB)

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_CanPickUp] = ($l_i_Type = 0x400 And ($l_i_Owner = 0 Or $l_i_Owner = $l_i_MyID))

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsBleeding] = BitAND($l_i_Effects, 0x0001) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsConditioned] = BitAND($l_i_Effects, 0x0002) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsCrippled] = BitAND($l_i_Effects, 0x000A) = 0xA
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsDead] = BitAND($l_i_Effects, 0x0010) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsDeepWounded] = BitAND($l_i_Effects, 0x0020) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsPoisoned] = BitAND($l_i_Effects, 0x0040) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsEnchanted] = BitAND($l_i_Effects, 0x0080) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsDegenHexed] = BitAND($l_i_Effects, 0x0400) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsHexed] = BitAND($l_i_Effects, 0x0800) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsWeaponSpelled] = BitAND($l_i_Effects, 0x8000) > 0

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsKnockedDown] = ($l_i_ModelState = 0x450)
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsAttacking] = ($l_i_ModelState = 0x60 Or $l_i_ModelState = 0x440 Or $l_i_ModelState = 0x460)
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsIdle] = ($l_i_ModelState = 68 Or $l_i_ModelState = 64 Or $l_i_ModelState = 100)

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsMoving] = ($l_f_MoveX <> 0 Or $l_f_MoveY <> 0 Or _
            $l_i_ModelState = 12 Or $l_i_ModelState = 76 Or $l_i_ModelState = 204)

        Local $l_i_Skill = $l_av_Data[47]
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsCasting] = ($l_i_Skill <> 0 Or _
            $l_i_ModelState = 0x41 Or $l_i_ModelState = 0x245)

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_InCombatStance] = BitAND($l_i_TypeMap, 0x000001) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_HasQuest] = BitAND($l_i_TypeMap, 0x000002) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsDeadByTypeMap] = BitAND($l_i_TypeMap, 0x000008) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsFemale] = BitAND($l_i_TypeMap, 0x000200) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_HasBossGlow] = BitAND($l_i_TypeMap, 0x000400) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsHidingCap] = BitAND($l_i_TypeMap, 0x001000) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_CanBeViewedInPartyWindow] = BitAND($l_i_TypeMap, 0x20000) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsSpawned] = BitAND($l_i_TypeMap, 0x040000) > 0
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsBeingObserved] = BitAND($l_i_TypeMap, 0x400000) > 0

        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsPlayer] = ($l_i_LoginNumber <> 0)
        $g_amx2_AgentCache[$l_i_CacheIndex][$GC_UAI_AGENT_IsNPC] = ($l_i_LoginNumber = 0)

        If $l_b_IsPlayer Then $g_i_PlayerCacheIndex = $l_i_CacheIndex
    Next

    $g_i_AgentCacheCount = $l_i_CacheIndex
    $g_amx2_AgentCache[0][0] = $l_i_CacheIndex

	UAI_BuildAgentIDMap()

    Return True
EndFunc

Func UAI_BuildAgentIDMap()
    Local $l_i_MaxID = 0
    Local $l_i_Count = $g_amx2_AgentCache[0][0]

    For $i = 1 To $l_i_Count
        If $g_amx2_AgentCache[$i][$GC_UAI_AGENT_ID] > $l_i_MaxID Then
            $l_i_MaxID = $g_amx2_AgentCache[$i][$GC_UAI_AGENT_ID]
        EndIf
    Next

    ReDim $g_ai_AgentIDToIndex[$l_i_MaxID + 1]
    For $i = 0 To $l_i_MaxID
        $g_ai_AgentIDToIndex[$i] = 0
    Next

    For $i = 1 To $l_i_Count
        Local $l_i_ID = $g_amx2_AgentCache[$i][$GC_UAI_AGENT_ID]
        $g_ai_AgentIDToIndex[$l_i_ID] = $i
    Next
EndFunc

Func UAI_GetIndexByID($a_i_AgentID)
    If $a_i_AgentID < 1 Or $a_i_AgentID >= UBound($g_ai_AgentIDToIndex) Then Return 0
    Return $g_ai_AgentIDToIndex[$a_i_AgentID]
EndFunc

Func UAI_GetAgentInfoByID($a_i_AgentID, $a_i_InfoType)
    If $a_i_InfoType < 0 Or $a_i_InfoType >= $GC_UAI_AGENT_COUNT Then Return 0
    Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
    If $l_i_Index = 0 Then Return 0
    Return $g_amx2_AgentCache[$l_i_Index][$a_i_InfoType]
EndFunc

Func UAI_GetAgentInfo($a_i_Index, $a_i_InfoType)
    If $a_i_Index < 1 Or $a_i_Index > $g_i_AgentCacheCount Then Return 0
    If $a_i_InfoType < 0 Or $a_i_InfoType >= $GC_UAI_AGENT_COUNT Then Return 0
    Return $g_amx2_AgentCache[$a_i_Index][$a_i_InfoType]
EndFunc

Func UAI_GetPlayerInfo($a_i_InfoType)
    If $g_i_PlayerCacheIndex < 1 Then Return 0
    Return $g_amx2_AgentCache[$g_i_PlayerCacheIndex][$a_i_InfoType]
EndFunc

Func UAI_GetPlayerIndex()
    Return $g_i_PlayerCacheIndex
EndFunc

Func UAI_GetAgentCount()
    Return $g_i_AgentCacheCount
EndFunc

Func UAI_GetPlayerX()
    Return $g_f_PlayerCacheX
EndFunc

Func UAI_GetPlayerY()
    Return $g_f_PlayerCacheY
EndFunc
