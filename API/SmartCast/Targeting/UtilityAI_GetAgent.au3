#include-once

#Region Agent Helpers
; Convert AgentID (-2 = player, -1 = target, else = actual ID)
Func UAI_ConvertAgentID($a_i_AgentID)
    Return Agent_ConvertID($a_i_AgentID)
EndFunc
#EndRegion

#Region Find Agent
Func UAI_FindAgentByPlayerNumber($a_i_PlayerNumber, $a_i_AgentID = -2, $a_i_Range = 5000, $a_s_Filter = "")
    Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)
    Local $l_f_RefX = UAI_GetPlayerX()
    Local $l_f_RefY = UAI_GetPlayerY()

    For $l_i_i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop
        If UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_PlayerNumber) <> $a_i_PlayerNumber Then ContinueLoop
        If $a_s_Filter <> "" And Not _ApplyFilters($l_i_AgentID, $a_s_Filter) Then ContinueLoop

        Local $l_f_Distance = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Distance)

        If $l_f_Distance <= $a_i_Range Then Return $l_i_AgentID
    Next

    Return 0
EndFunc
#EndRegion

#Region GetAgents
; Count agents matching filter within range (using cache)
; Distance is calculated from $a_i_AgentID (not always from player)
Func UAI_CountAgents($a_i_AgentID = -2, $a_f_Range = 1320, $a_s_Filter = "")
    Local $l_i_Count = 0
    Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

    ; Get reference position
    Local $l_f_RefX, $l_f_RefY
    If $l_i_RefID = Agent_GetMyID() Then
        ; Use cached player position
        $l_f_RefX = UAI_GetPlayerX()
        $l_f_RefY = UAI_GetPlayerY()
    Else
        ; Get position from cache by AgentID
        $l_f_RefX = UAI_GetAgentInfoByID($l_i_RefID, $GC_UAI_AGENT_X)
        $l_f_RefY = UAI_GetAgentInfoByID($l_i_RefID, $GC_UAI_AGENT_Y)
    EndIf

    Local $l_f_RangeSquared = $a_f_Range * $a_f_Range

    For $l_i_i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop

        ; Calculate distance from reference agent
        Local $l_f_AgentX = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_X)
        Local $l_f_AgentY = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Y)
        Local $l_f_DX = $l_f_AgentX - $l_f_RefX
        Local $l_f_DY = $l_f_AgentY - $l_f_RefY
        Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

        If $l_f_DistSquared > $l_f_RangeSquared Then ContinueLoop

        If $a_s_Filter <> "" And Not _ApplyFilters($l_i_AgentID, $a_s_Filter) Then ContinueLoop

        $l_i_Count += 1
    Next

    Return $l_i_Count
EndFunc

; Get nearest agent matching filter within range (using cache)
Func UAI_GetNearestAgent($a_i_AgentID = -2, $a_f_Range = 1320, $a_s_Filter = "")
    Local $l_i_NearestID = 0
    Local $l_f_NearestDist = 999999
    Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

    For $l_i_i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop

        Local $l_f_Distance = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Distance)
        If $l_f_Distance > $a_f_Range Then ContinueLoop

        If $a_s_Filter <> "" And Not _ApplyFilters($l_i_AgentID, $a_s_Filter) Then ContinueLoop

        If $l_f_Distance < $l_f_NearestDist Then
            $l_f_NearestDist = $l_f_Distance
            $l_i_NearestID = $l_i_AgentID
        EndIf
    Next

    Return $l_i_NearestID
EndFunc

; Get farthest agent matching filter within range (using cache)
Func UAI_GetFarthestAgent($a_i_AgentID = -2, $a_f_Range = 1320, $a_s_Filter = "")
    Local $l_i_FarthestID = 0
    Local $l_f_FarthestDist = 0
    Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

    For $l_i_i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop

        Local $l_f_Distance = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Distance)
        If $l_f_Distance > $a_f_Range Then ContinueLoop

        If $a_s_Filter <> "" And Not _ApplyFilters($l_i_AgentID, $a_s_Filter) Then ContinueLoop

        If $l_f_Distance > $l_f_FarthestDist Then
            $l_f_FarthestDist = $l_f_Distance
            $l_i_FarthestID = $l_i_AgentID
        EndIf
    Next

    Return $l_i_FarthestID
EndFunc
#EndRegion GetAgents

#Region BestTarget
; Get agent with lowest property value (HP, Energy, etc.)
Func UAI_GetAgentLowest($a_i_AgentID = -2, $a_f_Range = 1320, $a_i_Property = $GC_UAI_AGENT_HP, $a_s_CustomFilter = "")
	Local $l_f_LowestValue = 999999
	Local $l_i_LowestAgent = 0

	; Get reference ID
	Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

	If $g_i_AgentCacheCount = 0 Then Return 0

	; Process each agent from cache
	For $l_i_i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Apply custom filters (supports multiple filters separated by |)
		If Not _ApplyFilters($l_i_AgentID, $a_s_CustomFilter) Then ContinueLoop

		; Get property value
		Local $l_v_Value = UAI_GetAgentInfo($l_i_i, $a_i_Property)

		; Update lowest
		If $l_v_Value < $l_f_LowestValue Then
			$l_f_LowestValue = $l_v_Value
			$l_i_LowestAgent = $l_i_AgentID
		EndIf
	Next

	Return $l_i_LowestAgent
EndFunc

; Get agent with highest property value
Func UAI_GetAgentHighest($a_i_AgentID = -2, $a_f_Range = 1320, $a_i_Property = $GC_UAI_AGENT_HP, $a_s_CustomFilter = "")
	Local $l_f_HighestValue = -1
	Local $l_i_HighestAgent = 0

	; Get reference ID
	Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

	If $g_i_AgentCacheCount = 0 Then Return 0

	; Process each agent from cache
	For $l_i_i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Apply custom filters (supports multiple filters separated by |)
		If Not _ApplyFilters($l_i_AgentID, $a_s_CustomFilter) Then ContinueLoop

		; Get property value
		Local $l_v_Value = UAI_GetAgentInfo($l_i_i, $a_i_Property)

		; Update highest
		If $l_v_Value > $l_f_HighestValue Then
			$l_f_HighestValue = $l_v_Value
			$l_i_HighestAgent = $l_i_AgentID
		EndIf
	Next

	Return $l_i_HighestAgent
EndFunc

Func UAI_GetBestSingleTarget($a_i_AgentID = -2, $a_f_Range = 1320, $a_i_Property = $GC_UAI_AGENT_HP, $a_s_CustomFilter = "")
	If $g_i_FightMode = $g_i_FinisherMode Then UAI_GetAgentHighest($a_i_AgentID, $a_f_Range, $a_i_Property, $a_s_CustomFilter)
	If $g_i_FightMode = $g_i_PressureMode Then UAI_GetAgentLowest($a_i_AgentID, $a_f_Range, $a_i_Property, $a_s_CustomFilter)
EndFunc

; Get best AOE target based on group size first, then average HP as tiebreaker
; Priority: 1) Most enemies in AOE range, 2) HP comparison based on fight mode
; $g_i_FightMode = $g_i_FinisherMode (0): Lowest average HP wins (finish weak enemies)
; $g_i_FightMode = $g_i_PressureMode (1): Highest average HP wins (pressure strong enemies)
; Returns the agent at the center of the best group
Func UAI_GetBestAOETarget($a_i_AgentID = -2, $a_f_Range = 1320, $a_f_AOERange = $GC_I_RANGE_ADJACENT, $a_s_CustomFilter = "")
	Local $l_i_BestAgent = 0
	Local $l_i_BestCount = 0
	; Initialize based on fight mode: 999999 for finisher (looking for min), 0 for pressure (looking for max)
	Local $l_f_BestAvgHP = ($g_i_FightMode = $g_i_FinisherMode) ? 999999 : 0

	; Get reference ID
	Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

	If $g_i_AgentCacheCount = 0 Then Return 0

	; Process each agent from cache
	For $l_i_i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Apply custom filters
		If Not _ApplyFilters($l_i_AgentID, $a_s_CustomFilter) Then ContinueLoop

		; Get group stats around this agent
		Local $l_av_GroupStats = _GetGroupStats($l_i_AgentID, $a_f_AOERange, $a_s_CustomFilter)
		Local $l_i_Count = $l_av_GroupStats[0]
		Local $l_f_AvgHP = $l_av_GroupStats[1]

		; Priority 1: More enemies wins
		; Priority 2: HP comparison based on fight mode
		If $l_i_Count > $l_i_BestCount Then
			$l_i_BestCount = $l_i_Count
			$l_f_BestAvgHP = $l_f_AvgHP
			$l_i_BestAgent = $l_i_AgentID
		ElseIf $l_i_Count = $l_i_BestCount Then
			; Finisher mode: prefer lower HP (finish weak enemies)
			; Pressure mode: prefer higher HP (pressure strong enemies)
			Local $l_b_BetterHP = ($g_i_FightMode = $g_i_FinisherMode) ? ($l_f_AvgHP < $l_f_BestAvgHP) : ($l_f_AvgHP > $l_f_BestAvgHP)
			If $l_b_BetterHP Then
				$l_f_BestAvgHP = $l_f_AvgHP
				$l_i_BestAgent = $l_i_AgentID
			EndIf
		EndIf
	Next

	Return $l_i_BestAgent
EndFunc

; Internal: Get group statistics (count and average HP) around a target
Func _GetGroupStats($a_i_AgentID, $a_f_Range, $a_s_Filter)
	Local $l_av_Result[2] = [0, 999999] ; [count, avgHP]
	Local $l_f_TotalHP = 0
	Local $l_i_Count = 0

	; Get reference position
	Local $l_f_RefX = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_X)
	Local $l_f_RefY = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Y)
	Local $l_f_RangeSquared = $a_f_Range * $a_f_Range

	; Include the center agent itself
	Local $l_f_CenterHP = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP)
	$l_f_TotalHP += $l_f_CenterHP
	$l_i_Count += 1

	; Check all agents in cache
	For $l_i_i = 1 To $g_i_AgentCacheCount
		Local $l_i_CheckID = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_ID)

		; Skip center agent (already counted)
		If $l_i_CheckID = $a_i_AgentID Then ContinueLoop

		; Apply filter
		If $a_s_Filter <> "" And Not _ApplyFilters($l_i_CheckID, $a_s_Filter) Then ContinueLoop

		; Calculate distance from center agent
		Local $l_f_CheckX = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_X)
		Local $l_f_CheckY = UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_Y)
		Local $l_f_DX = $l_f_CheckX - $l_f_RefX
		Local $l_f_DY = $l_f_CheckY - $l_f_RefY
		Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

		If $l_f_DistSquared > $l_f_RangeSquared Then ContinueLoop

		; Add to total
		$l_f_TotalHP += UAI_GetAgentInfo($l_i_i, $GC_UAI_AGENT_HP)
		$l_i_Count += 1
	Next

	$l_av_Result[0] = $l_i_Count
	If $l_i_Count > 0 Then $l_av_Result[1] = $l_f_TotalHP / $l_i_Count

	Return $l_av_Result
EndFunc
#EndRegion

#Region Helper
; Helper: Check if player has another Mesmer hex besides the specified one
Func UAI_PlayerHasOtherMesmerHex($a_i_ExcludeSkillID)
	If $g_i_PlayerCacheIndex < 1 Then Return False

	Local $l_i_Count = $g_ai_EffectsCount[$g_i_PlayerCacheIndex]
	For $l_i_i = 0 To $l_i_Count - 1
		Local $l_i_SkillID = $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$l_i_i][$GC_UAI_EFFECT_SkillID]
		If $l_i_SkillID = $a_i_ExcludeSkillID Then ContinueLoop

		; Check if this skill is a Mesmer hex
		If Skill_GetSkillInfo($l_i_SkillID, "Profession") = $GC_I_PROFESSION_MESMER Then
			Local $l_i_SkillType = Skill_GetSkillInfo($l_i_SkillID, "SkillType")
			If $l_i_SkillType = $GC_I_SKILL_TYPE_HEX Then Return True
		EndIf
	Next

	Return False
EndFunc
#EndRegion