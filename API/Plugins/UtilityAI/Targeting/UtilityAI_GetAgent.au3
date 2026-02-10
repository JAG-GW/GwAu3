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

    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop
        If UAI_GetAgentInfo($i, $GC_UAI_AGENT_PlayerNumber) <> $a_i_PlayerNumber Then ContinueLoop
        If $a_s_Filter <> "" And Not _ApplyFilters($l_i_AgentID, $a_s_Filter) Then ContinueLoop

        Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)

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
    If $l_i_RefID = UAI_GetPlayerInfo($GC_UAI_AGENT_ID) Then
        ; Use cached player position
        $l_f_RefX = UAI_GetPlayerX()
        $l_f_RefY = UAI_GetPlayerY()
    Else
        ; Get position from cache by AgentID
        $l_f_RefX = UAI_GetAgentInfoByID($l_i_RefID, $GC_UAI_AGENT_X)
        $l_f_RefY = UAI_GetAgentInfoByID($l_i_RefID, $GC_UAI_AGENT_Y)
    EndIf

    Local $l_f_RangeSquared = $a_f_Range * $a_f_Range

    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop

        ; Calculate distance from reference agent
        Local $l_f_AgentX = UAI_GetAgentInfo($i, $GC_UAI_AGENT_X)
        Local $l_f_AgentY = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Y)
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

    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop

        Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
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

    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

        If $l_i_AgentID = $l_i_RefID Then ContinueLoop

        Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
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
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Apply custom filters (supports multiple filters separated by |)
		If Not _ApplyFilters($l_i_AgentID, $a_s_CustomFilter) Then ContinueLoop

		; Get property value
		Local $l_v_Value = UAI_GetAgentInfo($i, $a_i_Property)

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
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Apply custom filters (supports multiple filters separated by |)
		If Not _ApplyFilters($l_i_AgentID, $a_s_CustomFilter) Then ContinueLoop

		; Get property value
		Local $l_v_Value = UAI_GetAgentInfo($i, $a_i_Property)

		; Update highest
		If $l_v_Value > $l_f_HighestValue Then
			$l_f_HighestValue = $l_v_Value
			$l_i_HighestAgent = $l_i_AgentID
		EndIf
	Next

	Return $l_i_HighestAgent
EndFunc

Func UAI_GetBestSingleTarget($a_i_AgentID = -2, $a_f_Range = 1320, $a_i_Property = $GC_UAI_AGENT_HP, $a_s_CustomFilter = "")
	If $g_i_FightMode = $g_i_FinisherMode Then Return UAI_GetAgentLowest($a_i_AgentID, $a_f_Range, $a_i_Property, $a_s_CustomFilter)
	If $g_i_FightMode = $g_i_PressureMode Then Return UAI_GetAgentHighest($a_i_AgentID, $a_f_Range, $a_i_Property, $a_s_CustomFilter)
	Return 0
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
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
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
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_CheckID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Skip center agent (already counted)
		If $l_i_CheckID = $a_i_AgentID Then ContinueLoop

		; Apply filter
		If $a_s_Filter <> "" And Not _ApplyFilters($l_i_CheckID, $a_s_Filter) Then ContinueLoop

		; Calculate distance from center agent
		Local $l_f_CheckX = UAI_GetAgentInfo($i, $GC_UAI_AGENT_X)
		Local $l_f_CheckY = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Y)
		Local $l_f_DX = $l_f_CheckX - $l_f_RefX
		Local $l_f_DY = $l_f_CheckY - $l_f_RefY
		Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

		If $l_f_DistSquared > $l_f_RangeSquared Then ContinueLoop

		; Add to total
		$l_f_TotalHP += UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		$l_i_Count += 1
	Next

	$l_av_Result[0] = $l_i_Count
	If $l_i_Count > 0 Then $l_av_Result[1] = $l_f_TotalHP / $l_i_Count

	Return $l_av_Result
EndFunc

; Get best single target considering armor for damage type
; $a_s_DamageType: "elemental" or "physical"
; Calculates effective damage (HP / DamageMultiplier) and prioritizes targets where damage is most effective
; Finisher mode: target with lowest effective HP (easiest to kill with this damage type)
; Pressure mode: target with highest effective HP (most HP to pressure with efficient damage)
Func UAI_GetBestTargetByDamageType($a_i_AgentID = -2, $a_f_Range = 1320, $a_s_DamageType = "Elemental", $a_s_CustomFilter = "")
	Local $l_i_BestAgent = 0
	; Initialize based on fight mode
	Local $l_f_BestScore = ($g_i_FightMode = $g_i_FinisherMode) ? 999999 : 0

	; Get reference ID
	Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

	If $g_i_AgentCacheCount = 0 Then Return 0

	; Process each agent from cache
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Apply custom filters
		If $a_s_CustomFilter <> "" And Not _ApplyFilters($l_i_AgentID, $a_s_CustomFilter) Then ContinueLoop

		; Get HP from cache
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)

		; Calculate armor on-the-fly based on damage type
		Local $l_i_Armor
		Switch $a_s_DamageType
			Case "Elemental", "Fire", "Cold", "Lightning", "Earth"
				$l_i_Armor = UAI_GetElementalArmor($l_i_AgentID)
			Case "Physical", "Blunt", "Piercing", "Slashing"
				$l_i_Armor = UAI_GetPhysicalArmor($l_i_AgentID)
			Case Else
				$l_i_Armor = UAI_GetBaseArmor($l_i_AgentID)
		EndSwitch

		; Calculate damage multiplier (higher = more damage taken)
		Local $l_f_DamageMult = UAI_GetDamageMultiplier($l_i_Armor)

		; Calculate effective HP score
		; Lower armor = higher damage multiplier = lower effective HP = easier to kill
		; Score = HP / DamageMultiplier (lower score = better target for finisher)
		Local $l_f_Score = $l_f_HP / $l_f_DamageMult

		; Finisher mode: prefer lowest score (easiest to kill)
		; Pressure mode: prefer highest score (most efficient damage on high HP target)
		If $g_i_FightMode = $g_i_FinisherMode Then
			If $l_f_Score < $l_f_BestScore Then
				$l_f_BestScore = $l_f_Score
				$l_i_BestAgent = $l_i_AgentID
			EndIf
		Else ; Pressure mode
			If $l_f_Score > $l_f_BestScore Then
				$l_f_BestScore = $l_f_Score
				$l_i_BestAgent = $l_i_AgentID
			EndIf
		EndIf
	Next

	Return $l_i_BestAgent
EndFunc

; Get best AOE target considering armor for damage type
; $a_s_DamageType: "elemental" or "physical"
; Priority: 1) Most enemies in AOE range, 2) Average effective HP score based on armor
; Returns the agent at the center of the best group for this damage type
Func UAI_GetBestAOETargetByDamageType($a_i_AgentID = -2, $a_f_Range = 1320, $a_f_AOERange = $GC_I_RANGE_ADJACENT, $a_s_DamageType = "Elemental", $a_s_CustomFilter = "")
	Local $l_i_BestAgent = 0
	Local $l_i_BestCount = 0
	Local $l_f_BestAvgScore = ($g_i_FightMode = $g_i_FinisherMode) ? 999999 : 0

	; Get reference ID
	Local $l_i_RefID = UAI_ConvertAgentID($a_i_AgentID)

	If $g_i_AgentCacheCount = 0 Then Return 0

	; Process each agent from cache
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Ignore reference agent
		If $l_i_AgentID = $l_i_RefID Then ContinueLoop

		; Check range (already calculated in cache)
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Apply custom filters
		If $a_s_CustomFilter <> "" And Not _ApplyFilters($l_i_AgentID, $a_s_CustomFilter) Then ContinueLoop

		; Get group stats with armor consideration
		Local $l_av_GroupStats = _GetGroupStatsByDamageType($l_i_AgentID, $a_f_AOERange, $a_s_DamageType, $a_s_CustomFilter)
		Local $l_i_Count = $l_av_GroupStats[0]
		Local $l_f_AvgScore = $l_av_GroupStats[1]

		; Priority 1: More enemies wins
		; Priority 2: Score comparison based on fight mode
		If $l_i_Count > $l_i_BestCount Then
			$l_i_BestCount = $l_i_Count
			$l_f_BestAvgScore = $l_f_AvgScore
			$l_i_BestAgent = $l_i_AgentID
		ElseIf $l_i_Count = $l_i_BestCount Then
			Local $l_b_BetterScore = ($g_i_FightMode = $g_i_FinisherMode) ? ($l_f_AvgScore < $l_f_BestAvgScore) : ($l_f_AvgScore > $l_f_BestAvgScore)
			If $l_b_BetterScore Then
				$l_f_BestAvgScore = $l_f_AvgScore
				$l_i_BestAgent = $l_i_AgentID
			EndIf
		EndIf
	Next

	Return $l_i_BestAgent
EndFunc

; Internal: Get group statistics with armor consideration
Func _GetGroupStatsByDamageType($a_i_AgentID, $a_f_Range, $a_s_DamageType, $a_s_Filter)
	Local $l_av_Result[2] = [0, 999999] ; [count, avgScore]
	Local $l_f_TotalScore = 0
	Local $l_i_Count = 0

	; Get reference position
	Local $l_f_RefX = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_X)
	Local $l_f_RefY = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Y)
	Local $l_f_RangeSquared = $a_f_Range * $a_f_Range

	; Include the center agent itself
	Local $l_f_CenterHP = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP)
	Local $l_f_CenterScore = _GetArmorScore($a_i_AgentID, $l_f_CenterHP, $a_s_DamageType)
	$l_f_TotalScore += $l_f_CenterScore
	$l_i_Count += 1

	; Check all agents in cache
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_CheckID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		; Skip center agent (already counted)
		If $l_i_CheckID = $a_i_AgentID Then ContinueLoop

		; Apply filter
		If $a_s_Filter <> "" And Not _ApplyFilters($l_i_CheckID, $a_s_Filter) Then ContinueLoop

		; Calculate distance from center agent
		Local $l_f_CheckX = UAI_GetAgentInfo($i, $GC_UAI_AGENT_X)
		Local $l_f_CheckY = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Y)
		Local $l_f_DX = $l_f_CheckX - $l_f_RefX
		Local $l_f_DY = $l_f_CheckY - $l_f_RefY
		Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

		If $l_f_DistSquared > $l_f_RangeSquared Then ContinueLoop

		; Calculate score with armor
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		$l_f_TotalScore += _GetArmorScore($l_i_CheckID, $l_f_HP, $a_s_DamageType)
		$l_i_Count += 1
	Next

	$l_av_Result[0] = $l_i_Count
	If $l_i_Count > 0 Then $l_av_Result[1] = $l_f_TotalScore / $l_i_Count

	Return $l_av_Result
EndFunc

; Internal: Calculate armor-adjusted score for an agent
Func _GetArmorScore($a_i_AgentID, $a_f_HP, $a_s_DamageType)
	Local $l_i_Armor
	Switch $a_s_DamageType
		Case "Elemental", "Fire", "Cold", "Lightning", "Earth"
			$l_i_Armor = UAI_GetElementalArmor($a_i_AgentID)
		Case "Physical", "Blunt", "Piercing", "Slashing"
			$l_i_Armor = UAI_GetPhysicalArmor($a_i_AgentID)
		Case Else
			$l_i_Armor = UAI_GetBaseArmor($a_i_AgentID)
	EndSwitch

	Local $l_f_DamageMult = UAI_GetDamageMultiplier($l_i_Armor)
	Return $a_f_HP / $l_f_DamageMult
EndFunc
#EndRegion

#Region Ward
; Find the best position to cast a Ward to cover the most allies
; Returns an array [X, Y, Count] with the optimal position and number of allies covered
; Uses centroid calculation of all allies to find the center of the group
Func UAI_GetBestWardPosition($a_f_WardRange = $GC_I_RANGE_AREA)
	Local $l_av_Result[3] = [0, 0, 0] ; [X, Y, Count]

	; Collect all living allies positions
	Local $l_af_AlliesX[$g_i_AgentCacheCount + 1]
	Local $l_af_AlliesY[$g_i_AgentCacheCount + 1]
	Local $l_i_AllyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

		$l_af_AlliesX[$l_i_AllyCount] = UAI_GetAgentInfo($i, $GC_UAI_AGENT_X)
		$l_af_AlliesY[$l_i_AllyCount] = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Y)
		$l_i_AllyCount += 1
	Next

	If $l_i_AllyCount = 0 Then Return $l_av_Result

	; Calculate centroid (center of mass) of all allies
	Local $l_f_CentroidX = 0, $l_f_CentroidY = 0
	For $i = 0 To $l_i_AllyCount - 1
		$l_f_CentroidX += $l_af_AlliesX[$i]
		$l_f_CentroidY += $l_af_AlliesY[$i]
	Next
	$l_f_CentroidX /= $l_i_AllyCount
	$l_f_CentroidY /= $l_i_AllyCount

	; Count how many allies would be in ward range from centroid
	Local $l_i_CoveredCount = 0
	Local $l_f_RangeSquared = $a_f_WardRange * $a_f_WardRange

	For $i = 0 To $l_i_AllyCount - 1
		Local $l_f_DX = $l_af_AlliesX[$i] - $l_f_CentroidX
		Local $l_f_DY = $l_af_AlliesY[$i] - $l_f_CentroidY
		Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

		If $l_f_DistSquared <= $l_f_RangeSquared Then
			$l_i_CoveredCount += 1
		EndIf
	Next

	$l_av_Result[0] = $l_f_CentroidX
	$l_av_Result[1] = $l_f_CentroidY
	$l_av_Result[2] = $l_i_CoveredCount

	Return $l_av_Result
EndFunc

; Move to best ward position and return True when ready to cast
; Returns True if player is in position (can cast ward), False if no allies
Func UAI_MoveToWardPosition($a_f_WardRange = $GC_I_RANGE_AREA)
	Local $l_av_BestPos = UAI_GetBestWardPosition($a_f_WardRange)

	; No allies found
	If $l_av_BestPos[2] = 0 Then Return False

	Local $l_f_TargetX = $l_av_BestPos[0]
	Local $l_f_TargetY = $l_av_BestPos[1]

	; Wait until we reach destination or timeout
	Local $l_i_Timeout = 0
	Local Const $l_f_ArrivalDist = 80 ; Consider arrived when within 80 units
	Local Const $l_i_MaxTimeout = 5000 ; Max 5 seconds

	Do
		Map_Move($l_f_TargetX, $l_f_TargetY, 0)
		Sleep(32)
		$l_i_Timeout += 32

		; Update current position
		Local $l_f_CurX = Agent_GetAgentInfo(-2, "X")
		Local $l_f_CurY = Agent_GetAgentInfo(-2, "Y")

		; Check distance to target position
		Local $l_f_DiffX = $l_f_TargetX - $l_f_CurX
		Local $l_f_DiffY = $l_f_TargetY - $l_f_CurY
		Local $l_f_DistToTarget = Sqrt($l_f_DiffX * $l_f_DiffX + $l_f_DiffY * $l_f_DiffY)

		If $l_f_DistToTarget < $l_f_ArrivalDist Then Return True

	Until $l_i_Timeout >= $l_i_MaxTimeout

	Return True
EndFunc

; Count allies that would be covered by a ward at player's current position
Func UAI_CountAlliesInWardRange($a_f_WardRange = $GC_I_RANGE_AREA)
	Return UAI_CountAgents(-2, $a_f_WardRange, "UAI_Filter_IsLivingAlly")
EndFunc

; Find the best position to cast an offensive Ward to affect the most enemies
; Returns an array [X, Y, Count] with the optimal position and number of enemies covered
Func UAI_GetBestOffensiveWardPosition($a_f_WardRange = $GC_I_RANGE_AREA)
	Local $l_av_Result[3] = [0, 0, 0] ; [X, Y, Count]

	; Collect all living enemies positions
	Local $l_af_EnemiesX[$g_i_AgentCacheCount + 1]
	Local $l_af_EnemiesY[$g_i_AgentCacheCount + 1]
	Local $l_i_EnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop

		$l_af_EnemiesX[$l_i_EnemyCount] = UAI_GetAgentInfo($i, $GC_UAI_AGENT_X)
		$l_af_EnemiesY[$l_i_EnemyCount] = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Y)
		$l_i_EnemyCount += 1
	Next

	If $l_i_EnemyCount = 0 Then Return $l_av_Result

	; Calculate centroid (center of mass) of all enemies
	Local $l_f_CentroidX = 0, $l_f_CentroidY = 0
	For $i = 0 To $l_i_EnemyCount - 1
		$l_f_CentroidX += $l_af_EnemiesX[$i]
		$l_f_CentroidY += $l_af_EnemiesY[$i]
	Next
	$l_f_CentroidX /= $l_i_EnemyCount
	$l_f_CentroidY /= $l_i_EnemyCount

	; Count how many enemies would be in ward range from centroid
	Local $l_i_CoveredCount = 0
	Local $l_f_RangeSquared = $a_f_WardRange * $a_f_WardRange

	For $i = 0 To $l_i_EnemyCount - 1
		Local $l_f_DX = $l_af_EnemiesX[$i] - $l_f_CentroidX
		Local $l_f_DY = $l_af_EnemiesY[$i] - $l_f_CentroidY
		Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

		If $l_f_DistSquared <= $l_f_RangeSquared Then
			$l_i_CoveredCount += 1
		EndIf
	Next

	$l_av_Result[0] = $l_f_CentroidX
	$l_av_Result[1] = $l_f_CentroidY
	$l_av_Result[2] = $l_i_CoveredCount

	Return $l_av_Result
EndFunc

; Get best position to hit multiple physical attackers (melee/ranged, not casters)
; Returns array [X, Y, Count]
Func UAI_GetBestPhysicalEnemyPosition($a_f_ClusterRange = $GC_I_RANGE_NEARBY)
	Local $l_av_Result[3] = [0, 0, 0] ; [X, Y, Count]

	; Collect all living physical enemies positions
	Local $l_af_EnemiesX[$g_i_AgentCacheCount + 1]
	Local $l_af_EnemiesY[$g_i_AgentCacheCount + 1]
	Local $l_i_EnemyCount = 0

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop
		If UAI_IsCaster($l_i_AgentID) Then ContinueLoop ; Skip casters

		$l_af_EnemiesX[$l_i_EnemyCount] = UAI_GetAgentInfo($i, $GC_UAI_AGENT_X)
		$l_af_EnemiesY[$l_i_EnemyCount] = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Y)
		$l_i_EnemyCount += 1
	Next

	If $l_i_EnemyCount = 0 Then Return $l_av_Result

	; Calculate centroid of physical enemies
	Local $l_f_CentroidX = 0, $l_f_CentroidY = 0
	For $i = 0 To $l_i_EnemyCount - 1
		$l_f_CentroidX += $l_af_EnemiesX[$i]
		$l_f_CentroidY += $l_af_EnemiesY[$i]
	Next
	$l_f_CentroidX /= $l_i_EnemyCount
	$l_f_CentroidY /= $l_i_EnemyCount

	; Count how many physical enemies would be in cluster range from centroid
	Local $l_i_CoveredCount = 0
	Local $l_f_RangeSquared = $a_f_ClusterRange * $a_f_ClusterRange

	For $i = 0 To $l_i_EnemyCount - 1
		Local $l_f_DX = $l_af_EnemiesX[$i] - $l_f_CentroidX
		Local $l_f_DY = $l_af_EnemiesY[$i] - $l_f_CentroidY
		Local $l_f_DistSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY

		If $l_f_DistSquared <= $l_f_RangeSquared Then
			$l_i_CoveredCount += 1
		EndIf
	Next

	$l_av_Result[0] = $l_f_CentroidX
	$l_av_Result[1] = $l_f_CentroidY
	$l_av_Result[2] = $l_i_CoveredCount

	Return $l_av_Result
EndFunc

; Move to best offensive ward position and return True when ready to cast
; Returns True if player is in position (can cast ward), False if no enemies
Func UAI_MoveToOffensiveWardPosition($a_f_WardRange = $GC_I_RANGE_AREA)
	Local $l_av_BestPos = UAI_GetBestOffensiveWardPosition($a_f_WardRange)

	; No enemies found
	If $l_av_BestPos[2] = 0 Then Return False

	Local $l_f_TargetX = $l_av_BestPos[0]
	Local $l_f_TargetY = $l_av_BestPos[1]

	; Wait until we reach destination or timeout
	Local $l_i_Timeout = 0
	Local Const $l_f_ArrivalDist = 80 ; Consider arrived when within 80 units
	Local Const $l_i_MaxTimeout = 5000 ; Max 5 seconds

	Do
		Map_Move($l_f_TargetX, $l_f_TargetY, 0)
		Sleep(32)
		$l_i_Timeout += 32

		; Update current position
		Local $l_f_CurX = Agent_GetAgentInfo(-2, "X")
		Local $l_f_CurY = Agent_GetAgentInfo(-2, "Y")

		; Check distance to target position
		Local $l_f_DiffX = $l_f_TargetX - $l_f_CurX
		Local $l_f_DiffY = $l_f_TargetY - $l_f_CurY
		Local $l_f_DistToTarget = Sqrt($l_f_DiffX * $l_f_DiffX + $l_f_DiffY * $l_f_DiffY)

		If $l_f_DistToTarget < $l_f_ArrivalDist Then Return True

	Until $l_i_Timeout >= $l_i_MaxTimeout

	Return True
EndFunc
#EndRegion

#Region Helper
; Helper: Check if player has another Mesmer hex besides the specified one
Func UAI_PlayerHasOtherMesmerHex($a_i_ExcludeSkillID)
	If $g_i_PlayerCacheIndex < 1 Then Return False

	Local $l_i_Count = $g_ai_EffectsCount[$g_i_PlayerCacheIndex]
	For $i = 0 To $l_i_Count - 1
		Local $l_i_SkillID = $g_amx3_EffectsCache[$g_i_PlayerCacheIndex][$i][$GC_UAI_EFFECT_SkillID]
		If $l_i_SkillID = $a_i_ExcludeSkillID Then ContinueLoop

		; Check if this skill is a Mesmer hex
		If Skill_GetSkillInfo($l_i_SkillID, "Profession") = $GC_I_PROFESSION_MESMER Then
			Local $l_i_SkillType = Skill_GetSkillInfo($l_i_SkillID, "SkillType")
			If $l_i_SkillType = $GC_I_SKILL_TYPE_HEX Then Return True
		EndIf
	Next

	Return False
EndFunc

; Helper: Find best corpse position for ally support wells
; Returns player ID if best corpse is nearest, otherwise returns best corpse ID to move toward
Func UAI_GetBestCorpseForAllySupport($a_f_Range)
	Local $l_i_BestCorpse = 0
	Local $l_i_BestCount = 0
	Local $l_i_NearestCorpse = 0
	Local $l_f_NearestDist = 999999

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		If Not UAI_Filter_IsDeadEnemy($l_i_AgentID) Then ContinueLoop

		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Track nearest corpse
		If $l_f_Distance < $l_f_NearestDist Then
			$l_f_NearestDist = $l_f_Distance
			$l_i_NearestCorpse = $l_i_AgentID
		EndIf

		; Track best corpse (most allies)
		Local $l_i_Count = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingAlly")

		If $l_i_Count > $l_i_BestCount Then
			$l_i_BestCount = $l_i_Count
			$l_i_BestCorpse = $l_i_AgentID
		EndIf
	Next

	If $l_i_BestCount = 0 Then Return 0

	; If best corpse is nearest, return player ID to cast well
	If $l_i_BestCorpse = $l_i_NearestCorpse Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)

	; Otherwise move toward best corpse until it becomes nearest
	If UAI_MoveTowardCorpse($l_i_BestCorpse) Then
		Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	EndIf
	Return 0
EndFunc

Func UAI_GetBestCorpseForEnemyPressure($a_f_Range)
	Local $l_i_BestCorpse = 0
	Local $l_i_BestCount = 0
	Local $l_i_NearestCorpse = 0
	Local $l_f_NearestDist = 999999

	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)

		If Not UAI_Filter_IsDeadEnemy($l_i_AgentID) Then ContinueLoop

		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_Range Then ContinueLoop

		; Track nearest corpse
		If $l_f_Distance < $l_f_NearestDist Then
			$l_f_NearestDist = $l_f_Distance
			$l_i_NearestCorpse = $l_i_AgentID
		EndIf

		; Track best corpse (most enemies)
		Local $l_i_Count = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy")

		If $l_i_Count > $l_i_BestCount Then
			$l_i_BestCount = $l_i_Count
			$l_i_BestCorpse = $l_i_AgentID
		EndIf
	Next

	If $l_i_BestCount = 0 Then Return 0

	; If best corpse is nearest, return player ID to cast well
	If $l_i_BestCorpse = $l_i_NearestCorpse Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)

	; Otherwise move toward best corpse until it becomes nearest
	If UAI_MoveTowardCorpse($l_i_BestCorpse) Then
		Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	EndIf
	Return 0
EndFunc

; Move to the target corpse position so it becomes the nearest one
; Returns True if successfully positioned (target is now nearest), False otherwise
Func UAI_MoveTowardCorpse($a_i_TargetCorpseID)
	Local $l_f_TargetX = UAI_GetAgentInfoByID($a_i_TargetCorpseID, $GC_UAI_AGENT_X)
	Local $l_f_TargetY = UAI_GetAgentInfoByID($a_i_TargetCorpseID, $GC_UAI_AGENT_Y)

	; Wait until we reach destination or timeout
	Local $l_i_Timeout = 0
	Local Const $l_f_ArrivalDist = 80 ; Consider arrived when within 80 units
	Local Const $l_i_MaxTimeout = 5000 ; Max 5 seconds

	Do
		Map_Move($l_f_TargetX, $l_f_TargetY, 0)
		Sleep(32)
		$l_i_Timeout += 32

		; Update current position
		Local $l_f_CurX = Agent_GetAgentInfo(-2, "X")
		Local $l_f_CurY = Agent_GetAgentInfo(-2, "Y")

		; Check distance to target corpse
		Local $l_f_DiffX = $l_f_TargetX - $l_f_CurX
		Local $l_f_DiffY = $l_f_TargetY - $l_f_CurY
		Local $l_f_DistToTarget = Sqrt($l_f_DiffX * $l_f_DiffX + $l_f_DiffY * $l_f_DiffY)

		; Check if target corpse is now the nearest
		If UAI_IsCorpseNearest($a_i_TargetCorpseID, $l_f_CurX, $l_f_CurY) Then Return True

	Until $l_f_DistToTarget < $l_f_ArrivalDist Or $l_i_Timeout >= $l_i_MaxTimeout

	Return True
EndFunc

; Check if target corpse is the nearest corpse from given position
Func UAI_IsCorpseNearest($a_i_TargetCorpseID, $a_f_X, $a_f_Y)
	Local $l_f_TargetX = UAI_GetAgentInfoByID($a_i_TargetCorpseID, $GC_UAI_AGENT_X)
	Local $l_f_TargetY = UAI_GetAgentInfoByID($a_i_TargetCorpseID, $GC_UAI_AGENT_Y)
	Local $l_f_DiffX = $l_f_TargetX - $a_f_X
	Local $l_f_DiffY = $l_f_TargetY - $a_f_Y
	Local $l_f_DistToTarget = Sqrt($l_f_DiffX * $l_f_DiffX + $l_f_DiffY * $l_f_DiffY)

	; Check all other corpses
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsDeadEnemy($l_i_AgentID) Then ContinueLoop
		If $l_i_AgentID = $a_i_TargetCorpseID Then ContinueLoop

		Local $l_f_OtherX = UAI_GetAgentInfo($i, $GC_UAI_AGENT_X)
		Local $l_f_OtherY = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Y)
		Local $l_f_OtherDiffX = $l_f_OtherX - $a_f_X
		Local $l_f_OtherDiffY = $l_f_OtherY - $a_f_Y
		Local $l_f_DistToOther = Sqrt($l_f_OtherDiffX * $l_f_OtherDiffX + $l_f_OtherDiffY * $l_f_OtherDiffY)

		; If another corpse is closer, target is not nearest
		If $l_f_DistToOther < $l_f_DistToTarget Then Return False
	Next

	Return True
EndFunc
#EndRegion