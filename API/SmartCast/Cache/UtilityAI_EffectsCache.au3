#include-once

; ========== Effect Structure Properties ==========
Global Enum $GC_UAI_EFFECT_SkillID, _
	$GC_UAI_EFFECT_AttributeLevel, _
	$GC_UAI_EFFECT_EffectID, _
	$GC_UAI_EFFECT_CasterID, _
	$GC_UAI_EFFECT_Duration, _
	$GC_UAI_EFFECT_Timestamp, _
	$GC_UAI_EFFECT_TimeElapsed, _
	$GC_UAI_EFFECT_TimeRemaining, _
	$GC_UAI_EFFECT_COUNT

; ========== Buff Structure Properties ==========
Global Enum $GC_UAI_BUFF_SkillID, _
	$GC_UAI_BUFF_Unknown, _
	$GC_UAI_BUFF_BuffID, _
	$GC_UAI_BUFF_TargetAgentID, _
	$GC_UAI_BUFF_COUNT

; ========== Visible Effect Structure Properties ==========
Global Enum $GC_UAI_VISEFFECT_EffectType, _
	$GC_UAI_VISEFFECT_EffectID, _
	$GC_UAI_VISEFFECT_HasEnded, _
	$GC_UAI_VISEFFECT_COUNT

; ========== Global Cache ==========
; Effects cache: $g_amx3_EffectsCache[AgentIndex][EffectIndex][Property]
; Buffs cache: $g_amx3_BuffsCache[AgentIndex][BuffIndex][Property]
; VisibleEffects cache: $g_amx3_VisEffectsCache[AgentIndex][VisEffectIndex][Property]
Global $g_amx3_EffectsCache[1][1][1]
Global $g_amx3_BuffsCache[1][1][1]
Global $g_amx3_VisEffectsCache[1][1][1]

; Count arrays: stores count of effects/buffs/viseffects per agent
Global $g_ai_EffectsCount[1]
Global $g_ai_BuffsCount[1]
Global $g_ai_VisEffectsCount[1]

; ========== Internal: Cache Effects for all cached agents ==========
Func UAI_CacheAgentEffects()
	Static $ss_EffectStruct = Memory_CreateArrayStructure( _
		"long SkillID[0x0];" & _
		"dword AttributeLevel[0x4];" & _
		"long EffectID[0x8];" & _
		"dword CasterID[0xC];" & _
		"float Duration[0x10];" & _
		"dword Timestamp[0x14]", _
		0x18)

	Local $l_i_AgentCount = $g_i_AgentCacheCount
	If $l_i_AgentCount = 0 Then Return SetError(1, 0, False)

	; Reset cache arrays
	$g_amx3_EffectsCache = 0
	$g_ai_EffectsCount = 0
	Global $g_amx3_EffectsCache[$l_i_AgentCount + 1][32][$GC_UAI_EFFECT_COUNT]
	Global $g_ai_EffectsCount[$l_i_AgentCount + 1]

	Local $l_p_AgentEffectsBase = World_GetWorldInfo("AgentEffectsArray")
	Local $l_i_AgentEffectsSize = World_GetWorldInfo("AgentEffectsArraySize")
	If $l_p_AgentEffectsBase = 0 Or $l_i_AgentEffectsSize = 0 Then Return SetError(2, 0, False)

	For $l_i_i = 1 To $l_i_AgentCount
		Local $l_i_AgentID = $g_amx2_AgentCache[$l_i_i][$GC_UAI_AGENT_ID]
		$g_ai_EffectsCount[$l_i_i] = 0

		; Find agent in effects array
		For $l_i_j = 0 To $l_i_AgentEffectsSize - 1
			Local $l_p_AgentEffects = $l_p_AgentEffectsBase + ($l_i_j * 0x24)
			Local $l_i_CurrentAgentID = Memory_Read($l_p_AgentEffects, "dword")

			If $l_i_CurrentAgentID = $l_i_AgentID Then
				Local $l_p_EffectArray = Memory_Read($l_p_AgentEffects + 0x14, "ptr")
				Local $l_i_EffectCount = Memory_Read($l_p_AgentEffects + 0x14 + 0x8, "long")

				If $l_p_EffectArray = 0 Or $l_i_EffectCount <= 0 Then ExitLoop
				If $l_i_EffectCount > 31 Then $l_i_EffectCount = 31

				Local $l_amx2_AllEffects = Memory_ReadArrayStruct($l_p_EffectArray, $l_i_EffectCount, $ss_EffectStruct)
				If @error Then ExitLoop

				For $l_i_k = 0 To $l_i_EffectCount - 1
					$g_amx3_EffectsCache[$l_i_i][$l_i_k][$GC_UAI_EFFECT_SkillID] = $l_amx2_AllEffects[$l_i_k][0]
					$g_amx3_EffectsCache[$l_i_i][$l_i_k][$GC_UAI_EFFECT_AttributeLevel] = $l_amx2_AllEffects[$l_i_k][1]
					$g_amx3_EffectsCache[$l_i_i][$l_i_k][$GC_UAI_EFFECT_EffectID] = $l_amx2_AllEffects[$l_i_k][2]
					$g_amx3_EffectsCache[$l_i_i][$l_i_k][$GC_UAI_EFFECT_CasterID] = $l_amx2_AllEffects[$l_i_k][3]
					$g_amx3_EffectsCache[$l_i_i][$l_i_k][$GC_UAI_EFFECT_Duration] = $l_amx2_AllEffects[$l_i_k][4]
					$g_amx3_EffectsCache[$l_i_i][$l_i_k][$GC_UAI_EFFECT_Timestamp] = $l_amx2_AllEffects[$l_i_k][5]
				Next

				$g_ai_EffectsCount[$l_i_i] = $l_i_EffectCount
				ExitLoop
			EndIf
		Next
	Next

	Return True
EndFunc

; ========== Internal: Cache Buffs for all cached agents ==========
Func UAI_CacheAgentBuffs()
	Static $ss_BuffStruct = Memory_CreateArrayStructure( _
		"long SkillID[0x0];" & _
		"dword Unknown[0x4];" & _
		"long BuffID[0x8];" & _
		"dword TargetAgentID[0xC]", _
		0x10)

	Local $l_i_AgentCount = $g_i_AgentCacheCount
	If $l_i_AgentCount = 0 Then Return SetError(1, 0, False)

	; Reset cache arrays
	$g_amx3_BuffsCache = 0
	$g_ai_BuffsCount = 0
	Global $g_amx3_BuffsCache[$l_i_AgentCount + 1][32][$GC_UAI_BUFF_COUNT]
	Global $g_ai_BuffsCount[$l_i_AgentCount + 1]

	Local $l_p_AgentEffectsBase = World_GetWorldInfo("AgentEffectsArray")
	Local $l_i_AgentEffectsSize = World_GetWorldInfo("AgentEffectsArraySize")
	If $l_p_AgentEffectsBase = 0 Or $l_i_AgentEffectsSize = 0 Then Return SetError(2, 0, False)

	For $l_i_i = 1 To $l_i_AgentCount
		Local $l_i_AgentID = $g_amx2_AgentCache[$l_i_i][$GC_UAI_AGENT_ID]
		$g_ai_BuffsCount[$l_i_i] = 0

		; Find agent in effects array
		For $l_i_j = 0 To $l_i_AgentEffectsSize - 1
			Local $l_p_AgentEffects = $l_p_AgentEffectsBase + ($l_i_j * 0x24)
			Local $l_i_CurrentAgentID = Memory_Read($l_p_AgentEffects, "dword")

			If $l_i_CurrentAgentID = $l_i_AgentID Then
				Local $l_p_BuffArray = Memory_Read($l_p_AgentEffects + 0x4, "ptr")
				Local $l_i_BuffCount = Memory_Read($l_p_AgentEffects + 0x4 + 0x8, "long")

				If $l_p_BuffArray = 0 Or $l_i_BuffCount <= 0 Then ExitLoop
				If $l_i_BuffCount > 31 Then $l_i_BuffCount = 31

				Local $l_amx2_AllBuffs = Memory_ReadArrayStruct($l_p_BuffArray, $l_i_BuffCount, $ss_BuffStruct)
				If @error Then ExitLoop

				For $l_i_k = 0 To $l_i_BuffCount - 1
					$g_amx3_BuffsCache[$l_i_i][$l_i_k][$GC_UAI_BUFF_SkillID] = $l_amx2_AllBuffs[$l_i_k][0]
					$g_amx3_BuffsCache[$l_i_i][$l_i_k][$GC_UAI_BUFF_Unknown] = $l_amx2_AllBuffs[$l_i_k][1]
					$g_amx3_BuffsCache[$l_i_i][$l_i_k][$GC_UAI_BUFF_BuffID] = $l_amx2_AllBuffs[$l_i_k][2]
					$g_amx3_BuffsCache[$l_i_i][$l_i_k][$GC_UAI_BUFF_TargetAgentID] = $l_amx2_AllBuffs[$l_i_k][3]
				Next

				$g_ai_BuffsCount[$l_i_i] = $l_i_BuffCount
				ExitLoop
			EndIf
		Next
	Next

	Return True
EndFunc

; ========== Internal: Cache Visible Effects for all cached agents ==========
Func UAI_CacheAgentVisibleEffects()
	Local $l_i_AgentCount = $g_i_AgentCacheCount
	If $l_i_AgentCount = 0 Then Return SetError(1, 0, False)

	; Reset cache arrays
	$g_amx3_VisEffectsCache = 0
	$g_ai_VisEffectsCount = 0
	Global $g_amx3_VisEffectsCache[$l_i_AgentCount + 1][32][$GC_UAI_VISEFFECT_COUNT]
	Global $g_ai_VisEffectsCount[$l_i_AgentCount + 1]

	For $l_i_i = 1 To $l_i_AgentCount
		Local $l_p_AgentPtr = $g_amx2_AgentCache[$l_i_i][$GC_UAI_AGENT_Ptr]
		$g_ai_VisEffectsCount[$l_i_i] = 0

		; Only living agents have visible effects
		If $g_amx2_AgentCache[$l_i_i][$GC_UAI_AGENT_IsLivingType] = False Then ContinueLoop

		Local $l_p_TList = $l_p_AgentPtr + 0x174
		Local $l_av_Iterator = Utils_TList_CreateIterator($l_p_TList)

		Local $l_i_Count = 0
		Local $l_p_Current = Utils_TList_Iterator_Current($l_av_Iterator)

		While $l_p_Current <> 0 And $l_i_Count < 31
			$g_amx3_VisEffectsCache[$l_i_i][$l_i_Count][$GC_UAI_VISEFFECT_EffectType] = Memory_Read($l_p_Current, "dword")
			$g_amx3_VisEffectsCache[$l_i_i][$l_i_Count][$GC_UAI_VISEFFECT_EffectID] = Memory_Read($l_p_Current + 0x4, "dword")
			$g_amx3_VisEffectsCache[$l_i_i][$l_i_Count][$GC_UAI_VISEFFECT_HasEnded] = Memory_Read($l_p_Current + 0x8, "dword")

			$l_i_Count += 1

			If Not Utils_TList_Iterator_Next($l_av_Iterator) Then ExitLoop
			$l_p_Current = Utils_TList_Iterator_Current($l_av_Iterator)
		WEnd

		$g_ai_VisEffectsCount[$l_i_i] = $l_i_Count
	Next

	Return True
EndFunc

; ========== Public: Check if agent has effect ==========
Func UAI_AgentHasEffect($a_i_AgentID, $a_i_SkillID)
	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return False

	Local $l_i_Count = $g_ai_EffectsCount[$l_i_Index]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_EFFECT_SkillID] = $a_i_SkillID Then Return True
	Next

	Return False
EndFunc

; ========== Public: Check if player has effect ==========
Func UAI_PlayerHasEffect($a_i_SkillID)
	If $g_i_PlayerCacheIndex < 1 Then Return False

	Local $l_i_Count = $g_ai_EffectsCount[$g_i_PlayerCacheIndex]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_EFFECT_SkillID] = $a_i_SkillID Then Return True
	Next

	Return False
EndFunc

; ========== Public: Get effect info ==========
Func UAI_GetAgentEffectInfo($a_i_AgentID, $a_i_SkillID, $a_i_Property)
	If $a_i_Property < 0 Or $a_i_Property >= $GC_UAI_EFFECT_COUNT Then Return 0

	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return 0

	Local $l_i_Count = $g_ai_EffectsCount[$l_i_Index]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_EFFECT_SkillID] = $a_i_SkillID Then
			; Handle dynamic properties (calculated, not cached)
			If $a_i_Property = $GC_UAI_EFFECT_TimeElapsed Then
				Local $l_i_Timestamp = $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_EFFECT_Timestamp]
				Return BitAND(Skill_GetSkillTimer() - $l_i_Timestamp, 0xFFFFFFFF)
			ElseIf $a_i_Property = $GC_UAI_EFFECT_TimeRemaining Then
				Local $l_i_Timestamp = $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_EFFECT_Timestamp]
				Local $l_f_Duration = $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_EFFECT_Duration]
				Return $l_f_Duration * 1000 - BitAND(Skill_GetSkillTimer() - $l_i_Timestamp, 0xFFFFFFFF)
			Else
				Return $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$a_i_Property]
			EndIf
		EndIf
	Next

	Return 0
EndFunc

; ========== Public: Get player effect info ==========
Func UAI_GetPlayerEffectInfo($a_i_SkillID, $a_i_Property)
	If $a_i_Property < 0 Or $a_i_Property >= $GC_UAI_EFFECT_COUNT Then Return 0
	If $g_i_PlayerCacheIndex < 1 Then Return 0

	Local $l_i_Count = $g_ai_EffectsCount[$g_i_PlayerCacheIndex]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_EFFECT_SkillID] = $a_i_SkillID Then
			; Handle dynamic properties (calculated, not cached)
			If $a_i_Property = $GC_UAI_EFFECT_TimeElapsed Then
				Local $l_i_Timestamp = $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_EFFECT_Timestamp]
				Return BitAND(Skill_GetSkillTimer() - $l_i_Timestamp, 0xFFFFFFFF)
			ElseIf $a_i_Property = $GC_UAI_EFFECT_TimeRemaining Then
				Local $l_i_Timestamp = $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_EFFECT_Timestamp]
				Local $l_f_Duration = $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_EFFECT_Duration]
				Return $l_f_Duration * 1000 - BitAND(Skill_GetSkillTimer() - $l_i_Timestamp, 0xFFFFFFFF)
			Else
				Return $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$a_i_Property]
			EndIf
		EndIf
	Next

	Return 0
EndFunc

; ========== Public: Get agent effect count ==========
Func UAI_GetAgentEffectCount($a_i_AgentID)
	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return 0
	Return $g_ai_EffectsCount[$l_i_Index]
EndFunc

; ========== Public: Get player effect count ==========
Func UAI_GetPlayerEffectCount()
	If $g_i_PlayerCacheIndex < 1 Then Return 0
	Return $g_ai_EffectsCount[$g_i_PlayerCacheIndex]
EndFunc

; ========== Public: Check if agent has buff ==========
Func UAI_AgentHasBuff($a_i_AgentID, $a_i_SkillID)
	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return False

	Local $l_i_Count = $g_ai_BuffsCount[$l_i_Index]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_BuffsCache[$l_i_Index][$l_i_i][$GC_UAI_BUFF_SkillID] = $a_i_SkillID Then Return True
	Next

	Return False
EndFunc

; ========== Public: Check if player has buff ==========
Func UAI_PlayerHasBuff($a_i_SkillID)
	If $g_i_PlayerCacheIndex < 1 Then Return False

	Local $l_i_Count = $g_ai_BuffsCount[$g_i_PlayerCacheIndex]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_BuffsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_BUFF_SkillID] = $a_i_SkillID Then Return True
	Next

	Return False
EndFunc

; ========== Public: Get buff info ==========
Func UAI_GetAgentBuffInfo($a_i_AgentID, $a_i_SkillID, $a_i_Property)
	If $a_i_Property < 0 Or $a_i_Property >= $GC_UAI_BUFF_COUNT Then Return 0

	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return 0

	Local $l_i_Count = $g_ai_BuffsCount[$l_i_Index]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_BuffsCache[$l_i_Index][$l_i_i][$GC_UAI_BUFF_SkillID] = $a_i_SkillID Then
			Return $g_amx3_BuffsCache[$l_i_Index][$l_i_i][$a_i_Property]
		EndIf
	Next

	Return 0
EndFunc

; ========== Public: Get player buff info ==========
Func UAI_GetPlayerBuffInfo($a_i_SkillID, $a_i_Property)
	If $a_i_Property < 0 Or $a_i_Property >= $GC_UAI_BUFF_COUNT Then Return 0
	If $g_i_PlayerCacheIndex < 1 Then Return 0

	Local $l_i_Count = $g_ai_BuffsCount[$g_i_PlayerCacheIndex]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_BuffsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_BUFF_SkillID] = $a_i_SkillID Then
			Return $g_amx3_BuffsCache[$g_i_PlayerCacheIndex][$l_i_i][$a_i_Property]
		EndIf
	Next

	Return 0
EndFunc

; ========== Public: Get agent buff count ==========
Func UAI_GetAgentBuffCount($a_i_AgentID)
	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return 0
	Return $g_ai_BuffsCount[$l_i_Index]
EndFunc

; ========== Public: Get player buff count ==========
Func UAI_GetPlayerBuffCount()
	If $g_i_PlayerCacheIndex < 1 Then Return 0
	Return $g_ai_BuffsCount[$g_i_PlayerCacheIndex]
EndFunc

; ========== Public: Check if agent has visible effect ==========
Func UAI_AgentHasVisibleEffect($a_i_AgentID, $a_i_EffectID)
	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return False

	Local $l_i_Count = $g_ai_VisEffectsCount[$l_i_Index]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_VisEffectsCache[$l_i_Index][$l_i_i][$GC_UAI_VISEFFECT_EffectID] = $a_i_EffectID Then Return True
	Next

	Return False
EndFunc

; ========== Public: Check if player has visible effect ==========
Func UAI_PlayerHasVisibleEffect($a_i_EffectID)
	If $g_i_PlayerCacheIndex < 1 Then Return False

	Local $l_i_Count = $g_ai_VisEffectsCount[$g_i_PlayerCacheIndex]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_VisEffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_VISEFFECT_EffectID] = $a_i_EffectID Then Return True
	Next

	Return False
EndFunc

; ========== Public: Get visible effect info ==========
Func UAI_GetAgentVisibleEffectInfo($a_i_AgentID, $a_i_EffectID, $a_i_Property)
	If $a_i_Property < 0 Or $a_i_Property >= $GC_UAI_VISEFFECT_COUNT Then Return 0

	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return 0

	Local $l_i_Count = $g_ai_VisEffectsCount[$l_i_Index]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_VisEffectsCache[$l_i_Index][$l_i_i][$GC_UAI_VISEFFECT_EffectID] = $a_i_EffectID Then
			Return $g_amx3_VisEffectsCache[$l_i_Index][$l_i_i][$a_i_Property]
		EndIf
	Next

	Return 0
EndFunc

; ========== Public: Get player visible effect info ==========
Func UAI_GetPlayerVisibleEffectInfo($a_i_EffectID, $a_i_Property)
	If $a_i_Property < 0 Or $a_i_Property >= $GC_UAI_VISEFFECT_COUNT Then Return 0
	If $g_i_PlayerCacheIndex < 1 Then Return 0

	Local $l_i_Count = $g_ai_VisEffectsCount[$g_i_PlayerCacheIndex]
	For $l_i_i = 0 To $l_i_Count - 1
		If $g_amx3_VisEffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_VISEFFECT_EffectID] = $a_i_EffectID Then
			Return $g_amx3_VisEffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$a_i_Property]
		EndIf
	Next

	Return 0
EndFunc

; ========== Public: Get agent visible effect count ==========
Func UAI_GetAgentVisibleEffectCount($a_i_AgentID)
	Local $l_i_Index = UAI_GetIndexByID($a_i_AgentID)
	If $l_i_Index = 0 Then Return 0
	Return $g_ai_VisEffectsCount[$l_i_Index]
EndFunc

; ========== Public: Get player visible effect count ==========
Func UAI_GetPlayerVisibleEffectCount()
	If $g_i_PlayerCacheIndex < 1 Then Return 0
	Return $g_ai_VisEffectsCount[$g_i_PlayerCacheIndex]
EndFunc

Func UAI_GetFeederEnchOnTop()
	Local $l_i_MyID = Agent_GetMyID()
    If $l_i_MyID = 0 Then Return SetError(1, 0, False)

    Local $l_i_EffectCount = UAI_GetPlayerEffectCount()
    If $l_i_EffectCount = 0 Then Return False

	Local $l_i_Index = UAI_GetIndexByID($l_i_MyID)

    Local $l_i_Timestamp = 0
    Local $l_i_SkillID = 0

    For $l_i_i = 0 To $l_i_EffectCount - 1
        Local $l_i_CurrentSkillID = $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_BUFF_SkillID]
		If $GC_AMX2_SKILL_DATA[$l_i_CurrentSkillID][$GC_I_SKILL_PROFESSION] <> $GC_I_PROFESSION_DERVISH Then ContinueLoop
        If $GC_AMX2_SKILL_DATA[$l_i_CurrentSkillID][$GC_I_SKILL_TYPE] <> $GC_I_SKILL_TYPE_ENCHANTMENT Then ContinueLoop
		Local $l_i_CurrentTimeStamp = $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_EFFECT_Timestamp]
        If $l_i_CurrentTimeStamp > $l_i_Timestamp Then 
            $l_i_Timestamp = $l_i_CurrentTimeStamp
            $l_i_SkillID = $l_i_CurrentSkillID
        EndIf
    Next

    Local $l_ai_FeederEnchantmens[8] = [$GC_I_SKILL_ID_GRENTHS_FINGERS, $GC_I_SKILL_ID_AURA_OF_THORNS, _
        $GC_I_SKILL_ID_BALTHAZARS_RAGE, $GC_I_SKILL_ID_DUST_CLOAK, $GC_I_SKILL_ID_STAGGERING_FORCE, _
        $GC_I_SKILL_ID_PIOUS_RENEWAL, $GC_I_SKILL_ID_EREMITES_ZEAL, $GC_I_SKILL_ID_ZEALOUS_RENEWAL]

    If $l_i_SkillID <> 0 And (_ArrayBinarySearch($l_ai_FeederEnchantmens, $l_i_SkillID)) >= 0 Then Return True
    Return False
EndFunc

Func UAI_PlayerHasEffectType($a_s_EffectType = "")
	Local $l_i_MyID = Agent_GetMyID()
    If $l_i_MyID = 0 Then Return SetError(1, 0, False)

    Local $l_i_EffectCount = UAI_GetPlayerEffectCount()
    If $l_i_EffectCount = 0 Then Return False

	Local $l_i_Index = UAI_GetIndexByID($l_i_MyID)

	Local $l_i_EffectType = ""
	Switch $a_s_EffectType
		Case "HasStance"
			$l_i_EffectType = $GC_I_SKILL_TYPE_STANCE
		Case "HasGlyph"
			$l_i_EffectType = $GC_I_SKILL_TYPE_GLYPH
		Case "HasPreparation"
			$l_i_EffectType = $GC_I_SKILL_TYPE_PREPARATION
		Case Else
			Return SetError(2, 0, False)
	EndSwitch

    For $l_i_i = ($l_i_EffectCount - 1) To 0 Step -1
		Local $l_i_CurrentSkillID = $g_amx3_EffectsCache[$l_i_Index][$l_i_i][$GC_UAI_BUFF_SkillID]
		Local $l_i_SkillType = $GC_AMX2_SKILL_DATA[$l_i_CurrentSkillID][$GC_I_SKILL_TYPE]
		If $l_i_SkillType = $l_i_EffectType Then
			SetExtended($l_i_CurrentSkillID)
			Return True
		EndIf
    Next
    Return False
EndFunc