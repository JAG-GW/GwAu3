#include-once

#include "Pathfinder_Core.au3"

; Movement state
Global $g_aPathfinder_CurrentPath[0][3]  ; x, y, layer
Global $g_iPathfinder_CurrentPathIndex = 0
Global $g_hPathfinder_LastPathUpdateTime = 0

; Configuration
Global $g_iPathfinder_PathUpdateInterval = 1000      ; Interval before recalculating path (ms)
Global $g_iPathfinder_WaypointReachedDistance = 250 ; Distance to consider waypoint reached
Global $g_iPathfinder_SimplifyRange = 1250           ; Path simplification range
Global $g_iPathfinder_ObstacleUpdateInterval = 1000  ; Interval for dynamic obstacle updates (ms)
Global $g_iPathfinder_StuckCheckInterval = 1000     ; Interval to check if stuck (ms)
Global $g_iPathfinder_StuckDistance = 50            ; If moved less than this, consider stuck

; Move to a destination using pathfinding with obstacle avoidance
; $aDestX, $aDestY = Destination coordinates
; $aObstacles = Can be:
;   - 0: No obstacles (uses standard pathfinding)
;   - 2D array [[x, y, radius], ...]: Static obstacles
;   - String "FunctionName": Dynamic obstacles (function called periodically)
; $aAggroRange = Range to detect and fight enemies
; $aFightRangeOut = Range out for fighting
; $aFinisherMode = Finisher mode for UAI_Fight
; Returns: True if destination reached, False if interrupted
Func Pathfinder_MoveTo($aDestX, $aDestY, $aObstacles = 0, $aAggroRange = 1320, $aFightRangeOut = 3500, $aFinisherMode = 0)
	If Agent_GetAgentInfo(-2, "IsDead") Then Return
    Local $lMyOldMap = Map_GetMapID()
    Local $lMapLoadingOld = Map_GetInstanceInfo("Type")
    Local $lMyX = Agent_GetAgentInfo(-2, "X")
    Local $lMyY = Agent_GetAgentInfo(-2, "Y")
	Local $lLayer = Agent_GetAgentInfo(-2, "Plane")

	; Map was not full loaded
	If $lMyX = 0 Or $lMyY = 0 Or $lMyOldMap = 0 Or $lMapLoadingOld = $GC_I_MAP_TYPE_LOADING Then
		Do
			Sleep(16)
		Until Map_GetMapID() <> 0 And (Agent_GetAgentInfo(-2, "X") <> 0 Or Agent_GetAgentInfo(-2, "Y") <> 0)

		$lMyX = Agent_GetAgentInfo(-2, "X")
		$lMyY = Agent_GetAgentInfo(-2, "Y")
		$lMyOldMap = Map_GetMapID()
		$lMapLoadingOld = Map_GetInstanceInfo("Type")
	EndIf

	; Initialize DLL if not already loaded
    If $g_hPathfinderDLL = 0 Or $g_hPathfinderDLL = -1 Then
        If Not Pathfinder_Initialize() Then
            ; Fallback to direct movement if DLL fails
            Map_MoveLayer($aDestX, $aDestY, $lLayer)
            Return False
        EndIf
    EndIf

	; Return false if party is defeated
    If Party_GetPartyContextInfo("IsDefeated") Then
        Pathfinder_Shutdown()
        Return False
    EndIf

    ; Determine obstacle mode
    Local $lIsDynamicObstacles = IsString($aObstacles) And $aObstacles <> "" And $aObstacles <> "0"
    Local $lCurrentObstacles = 0

    If $lIsDynamicObstacles Then
        $lCurrentObstacles = Call($aObstacles)
    ElseIf IsArray($aObstacles) Then
        $lCurrentObstacles = $aObstacles
    EndIf

    Local $lPath = _Pathfinder_GetPath($lMyX, $lMyY, $lLayer, $aDestX, $aDestY, $lCurrentObstacles)
    If Not IsArray($lPath) Or UBound($lPath) = 0 Then
        Map_MoveLayer($aDestX, $aDestY, $lLayer)
;~         Return
    EndIf

    ; Initialize path tracking
    $g_aPathfinder_CurrentPath = $lPath
    $g_iPathfinder_CurrentPathIndex = 0
    $g_hPathfinder_LastPathUpdateTime = TimerInit()

    Local $lLastObstacleUpdate = TimerInit()
    Local $lLastStuckCheckTime = TimerInit()
    Local $lLastStuckCheckX = $lMyX
    Local $lLastStuckCheckY = $lMyY
    Local $lStuckCount = 0

    ; Main movement loop
    Do
        ; Check for map change
        If (Map_GetMapID() <> $lMyOldMap And Not Game_GetGameInfo("IsCinematic")) Or Map_GetInstanceInfo("Type") <> $lMapLoadingOld Then
            Pathfinder_Shutdown()
            Return True
        EndIf

		; Need to return to outpost
        If Party_GetPartyContextInfo("IsDefeated") Then
            Pathfinder_Shutdown()
            Return False
        EndIf

		; wait until rez
		If Agent_GetAgentInfo(-2, "IsDead") Then ContinueLoop

        $lMyX = Agent_GetAgentInfo(-2, "X")
        $lMyY = Agent_GetAgentInfo(-2, "Y")

        ; Update obstacles (dynamic mode only)
        Local $lNeedPathUpdate = False
        If $lIsDynamicObstacles And TimerDiff($lLastObstacleUpdate) > $g_iPathfinder_ObstacleUpdateInterval Then
            Local $lNewObstacles = Call($aObstacles)
            $lLastObstacleUpdate = TimerInit()

            ; Only recalculate if obstacles changed significantly or block current path
            If _Pathfinder_ObstaclesBlockPath($g_aPathfinder_CurrentPath, $g_iPathfinder_CurrentPathIndex, $lNewObstacles) Then
                $lCurrentObstacles = $lNewObstacles
                $lNeedPathUpdate = True
            EndIf
        EndIf

        ; Stuck detection
        If TimerDiff($lLastStuckCheckTime) > $g_iPathfinder_StuckCheckInterval Then
            Local $lMovedDistance = _Pathfinder_Distance($lMyX, $lMyY, $lLastStuckCheckX, $lLastStuckCheckY)
            If $lMovedDistance < $g_iPathfinder_StuckDistance Then
                $lStuckCount += 1
                $lNeedPathUpdate = True
                If $lStuckCount >= 3 Then
                    Local $lRandomAngle = Random(0, 6.28)
                    Map_Move($lMyX + Cos($lRandomAngle) * 200, $lMyY + Sin($lRandomAngle) * 200, 0)
                    Sleep(500)
                    $lStuckCount = 0
                EndIf
            Else
                $lStuckCount = 0
            EndIf
            $lLastStuckCheckX = $lMyX
            $lLastStuckCheckY = $lMyY
            $lLastStuckCheckTime = TimerInit()
        EndIf

        ; Recalculate path at every interval (always from current position)
        If TimerDiff($g_hPathfinder_LastPathUpdateTime) > $g_iPathfinder_PathUpdateInterval Or $lNeedPathUpdate Then
            $lPath = _Pathfinder_GetPath($lMyX, $lMyY, $lLayer, $aDestX, $aDestY, $lCurrentObstacles)
            If IsArray($lPath) And UBound($lPath) > 0 Then
                $g_aPathfinder_CurrentPath = $lPath
                $g_iPathfinder_CurrentPathIndex = 0
            Else
                ; Path calculation failed - clear path so we use direct movement
                Local $lEmptyPath[0][3]
                $g_aPathfinder_CurrentPath = $lEmptyPath
                $g_iPathfinder_CurrentPathIndex = 0
            EndIf
            $g_hPathfinder_LastPathUpdateTime = TimerInit()
        EndIf

        ; Move to current waypoint
        If $g_iPathfinder_CurrentPathIndex >= UBound($g_aPathfinder_CurrentPath) Then
            Map_MoveLayer($aDestX, $aDestY, $lLayer)
        Else
            Local $lWaypointX = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][0]
            Local $lWaypointY = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][1]
            $lLayer = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][2]

            If _Pathfinder_Distance($lMyX, $lMyY, $lWaypointX, $lWaypointY) < $g_iPathfinder_WaypointReachedDistance Then
                $g_iPathfinder_CurrentPathIndex += 1
                If $g_iPathfinder_CurrentPathIndex < UBound($g_aPathfinder_CurrentPath) Then
                    $lWaypointX = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][0]
                    $lWaypointY = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][1]
                    $lLayer = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][2]
                Else
                    $lWaypointX = $aDestX
                    $lWaypointY = $aDestY
                    $lLayer = 0
                EndIf
            EndIf

            ; Use Map_MoveLayer to move to the correct layer (important for bridges)
            Map_MoveLayer($lWaypointX, $lWaypointY, $lLayer)
        EndIf

        ; Fight if needed
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
			UAI_Fight($lMyX, $lMyY, $aAggroRange, $aFightRangeOut, $aFinisherMode)

			; Wait heroes if they are too far
			If _Pathfinder_ShouldWaitForParty(2000, 1400) Then
				Out("Waiting for party to catch up")
				Local $lWaitTimer = TimerInit()
				Do
					Agent_CancelAction()
					Sleep(250)
				Until _Pathfinder_PartyWithinRange(1400) Or TimerDiff($lWaitTimer) > 30000
			EndIf

			; Wait for resurrection if needed
            If _Pathfinder_ShouldWaitForResurrection() Then
                _Pathfinder_WaitForResurrection()
            EndIf
		EndIf

		Sleep(32)

		If IsDeclared("g_b_PickUpFunc") Then Extend_PickUpLoot($aAggroRange * 1.5)

		If Game_GetGameInfo("IsCinematic") Then
			Sleep(3000)
			Cinematic_SkipCinematic()
		EndIf

    Until Agent_GetDistanceToXY($aDestX, $aDestY) < 250

    ; Shutdown DLL and free memory
    Pathfinder_Shutdown()

    Return True
EndFunc

; Internal: Get path from current position to destination
Func _Pathfinder_GetPath($aStartX, $aStartY, $aStartLayer, $aDestX, $aDestY, $aObstacles)
    Local $lMapID = Map_GetMapID()
    Local $lObstacleCount = 0
    If IsArray($aObstacles) Then $lObstacleCount = UBound($aObstacles)

    _Pathfinder_Log("GetPath: Map=" & $lMapID & " Start=(" & Round($aStartX, 1) & ", " & Round($aStartY, 1) & ") Layer=" & $aStartLayer & " Dest=(" & Round($aDestX, 1) & ", " & Round($aDestY, 1) & ") Obstacles=" & $lObstacleCount)

    ; Get raw path with minimal simplification from DLL
    Local $lPath = Pathfinder_FindPath($lMapID, $aStartX, $aStartY, $aStartLayer, $aDestX, $aDestY, $aObstacles, 100)
    Local $lError = @error
    Local $lExtended = @extended

    If $lError Then
        _Pathfinder_Log("ERROR: FindPathGWWithObstacle failed - @error=" & $lError & " @extended=" & $lExtended)
        Return 0
    EndIf

    If Not IsArray($lPath) Then
        _Pathfinder_Log("ERROR: FindPathGWWithObstacle returned non-array")
        Return 0
    EndIf

    ; Apply smart simplification if obstacles are provided
    If IsArray($aObstacles) And UBound($aObstacles) > 0 Then
        $lPath = _Pathfinder_SmartSimplify($lPath, $aObstacles, $g_iPathfinder_SimplifyRange)
    EndIf

    _Pathfinder_Log("SUCCESS: Path found with " & UBound($lPath) & " points")
    Return $lPath
EndFunc

; Smart path simplification that preserves waypoints near obstacles and layer changes
; $aPath = 2D array of waypoints [[x, y, layer], ...]
; $aObstacles = 2D array of obstacles [[x, y, radius], ...]
; $aSimplifyRange = distance threshold for simplification
Func _Pathfinder_SmartSimplify($aPath, $aObstacles, $aSimplifyRange)
    Local $lPointCount = UBound($aPath)
    If $lPointCount <= 2 Then Return $aPath

    ; Mark which points are critical (near obstacles or layer changes)
    Local $lCritical[$lPointCount]
    $lCritical[0] = True ; First point always critical
    $lCritical[$lPointCount - 1] = True ; Last point always critical

    ; Safety margin around obstacles
    Local $lSafetyMargin = 100

    For $i = 1 To $lPointCount - 2
        $lCritical[$i] = False
        Local $lWpX = $aPath[$i][0]
        Local $lWpY = $aPath[$i][1]
        Local $lWpLayer = $aPath[$i][2]

        ; Check if layer changes from previous point (critical for bridges!)
        If $lWpLayer <> $aPath[$i - 1][2] Then
            $lCritical[$i] = True
            ContinueLoop
        EndIf

        ; Check if layer changes to next point (critical for bridges!)
        If $lWpLayer <> $aPath[$i + 1][2] Then
            $lCritical[$i] = True
            ContinueLoop
        EndIf

        ; Check if this waypoint is near any obstacle
        For $j = 0 To UBound($aObstacles) - 1
            Local $lObsX = $aObstacles[$j][0]
            Local $lObsY = $aObstacles[$j][1]
            Local $lObsRadius = $aObstacles[$j][2]

            Local $lDist = Sqrt(($lWpX - $lObsX)^2 + ($lWpY - $lObsY)^2)

            ; If waypoint is within obstacle radius + safety margin, it's critical
            If $lDist < ($lObsRadius + $lSafetyMargin) Then
                $lCritical[$i] = True
                ExitLoop
            EndIf
        Next

        ; Also check if the line from previous to next point would cross an obstacle
        If Not $lCritical[$i] And $i > 0 And $i < $lPointCount - 1 Then
            Local $lPrevX = $aPath[$i - 1][0]
            Local $lPrevY = $aPath[$i - 1][1]
            Local $lNextX = $aPath[$i + 1][0]
            Local $lNextY = $aPath[$i + 1][1]

            If _Pathfinder_LineIntersectsObstacles($lPrevX, $lPrevY, $lNextX, $lNextY, $aObstacles) Then
                $lCritical[$i] = True
            EndIf
        EndIf
    Next

    ; Now simplify non-critical points based on distance
    Local $lSimplified[$lPointCount][3]  ; x, y, layer
    Local $lSimplifiedCount = 0
    Local $lLastKeptIdx = 0

    ; Always keep first point
    $lSimplified[$lSimplifiedCount][0] = $aPath[0][0]
    $lSimplified[$lSimplifiedCount][1] = $aPath[0][1]
    $lSimplified[$lSimplifiedCount][2] = $aPath[0][2]
    $lSimplifiedCount += 1

    For $i = 1 To $lPointCount - 2
        Local $lDistFromLast = _Pathfinder_Distance($aPath[$i][0], $aPath[$i][1], $aPath[$lLastKeptIdx][0], $aPath[$lLastKeptIdx][1])

        ; Keep point if it's critical OR if we've traveled far enough
        If $lCritical[$i] Or $lDistFromLast >= $aSimplifyRange Then
            $lSimplified[$lSimplifiedCount][0] = $aPath[$i][0]
            $lSimplified[$lSimplifiedCount][1] = $aPath[$i][1]
            $lSimplified[$lSimplifiedCount][2] = $aPath[$i][2]
            $lSimplifiedCount += 1
            $lLastKeptIdx = $i
        EndIf
    Next

    ; Always keep last point
    $lSimplified[$lSimplifiedCount][0] = $aPath[$lPointCount - 1][0]
    $lSimplified[$lSimplifiedCount][1] = $aPath[$lPointCount - 1][1]
    $lSimplified[$lSimplifiedCount][2] = $aPath[$lPointCount - 1][2]
    $lSimplifiedCount += 1

    ; Resize array to actual count
    ReDim $lSimplified[$lSimplifiedCount][3]

    Return $lSimplified
EndFunc

; Check if a line segment intersects any obstacle
Func _Pathfinder_LineIntersectsObstacles($aX1, $aY1, $aX2, $aY2, $aObstacles)
    For $i = 0 To UBound($aObstacles) - 1
        Local $lObsX = $aObstacles[$i][0]
        Local $lObsY = $aObstacles[$i][1]
        Local $lObsRadius = $aObstacles[$i][2]

        ; Calculate distance from obstacle center to line segment
        Local $lDist = _Pathfinder_PointToLineDistance($lObsX, $lObsY, $aX1, $aY1, $aX2, $aY2)

        If $lDist < $lObsRadius Then
            Return True
        EndIf
    Next
    Return False
EndFunc

; Calculate distance from point to line segment
Func _Pathfinder_PointToLineDistance($aPx, $aPy, $aX1, $aY1, $aX2, $aY2)
    Local $lDx = $aX2 - $aX1
    Local $lDy = $aY2 - $aY1
    Local $lLenSq = $lDx * $lDx + $lDy * $lDy

    If $lLenSq = 0 Then
        ; Line segment is a point
        Return Sqrt(($aPx - $aX1)^2 + ($aPy - $aY1)^2)
    EndIf

    ; Calculate projection parameter
    Local $lT = (($aPx - $aX1) * $lDx + ($aPy - $aY1) * $lDy) / $lLenSq

    ; Clamp to segment
    If $lT < 0 Then $lT = 0
    If $lT > 1 Then $lT = 1

    ; Find closest point on segment
    Local $lClosestX = $aX1 + $lT * $lDx
    Local $lClosestY = $aY1 + $lT * $lDy

    Return Sqrt(($aPx - $lClosestX)^2 + ($aPy - $lClosestY)^2)
EndFunc

; Internal: Calculate distance between two points
Func _Pathfinder_Distance($aX1, $aY1, $aX2, $aY2)
    Return Sqrt(($aX2 - $aX1) ^ 2 + ($aY2 - $aY1) ^ 2)
EndFunc

; Check if any obstacle blocks the remaining path
; Returns True if path needs recalculation, False otherwise
Func _Pathfinder_ObstaclesBlockPath($aPath, $aCurrentIndex, $aObstacles)
    If Not IsArray($aPath) Or UBound($aPath) = 0 Then Return False
    If Not IsArray($aObstacles) Or UBound($aObstacles) = 0 Then Return False

    ; Check each remaining segment of the path
    For $i = $aCurrentIndex To UBound($aPath) - 2
        Local $lX1 = $aPath[$i][0]
        Local $lY1 = $aPath[$i][1]
        Local $lX2 = $aPath[$i + 1][0]
        Local $lY2 = $aPath[$i + 1][1]

        ; Check if any obstacle blocks this segment
        For $j = 0 To UBound($aObstacles) - 1
            Local $lObsX = $aObstacles[$j][0]
            Local $lObsY = $aObstacles[$j][1]
            Local $lObsRadius = $aObstacles[$j][2]

            ; Calculate distance from obstacle center to line segment
            Local $lDist = _Pathfinder_PointToLineDistance($lObsX, $lObsY, $lX1, $lY1, $lX2, $lY2)

            ; If obstacle intersects the path segment, we need to recalculate
            If $lDist < $lObsRadius Then
                Return True
            EndIf
        Next
    Next

    Return False
EndFunc

; Get current path for debugging/visualization
Func Pathfinder_GetCurrentPath()
    Return $g_aPathfinder_CurrentPath
EndFunc

; Get current waypoint index
Func Pathfinder_GetCurrentWaypointIndex()
    Return $g_iPathfinder_CurrentPathIndex
EndFunc

; Set path update interval (in ms)
Func Pathfinder_SetPathUpdateInterval($aInterval)
    $g_iPathfinder_PathUpdateInterval = $aInterval
EndFunc

; Set waypoint reached distance threshold
Func Pathfinder_SetWaypointReachedDistance($aDistance)
    $g_iPathfinder_WaypointReachedDistance = $aDistance
EndFunc

; Set path simplification range
Func Pathfinder_SetSimplifyRange($aRange)
    $g_iPathfinder_SimplifyRange = $aRange
EndFunc

; Set obstacle update interval for dynamic mode (in ms)
Func Pathfinder_SetObstacleUpdateInterval($aInterval)
    $g_iPathfinder_ObstacleUpdateInterval = $aInterval
EndFunc

; Enable/disable debug logging
Func Pathfinder_SetDebug($bEnabled)
    $g_bPathfinder_Debug = $bEnabled
EndFunc

; Internal: Log debug message
Func _Pathfinder_Log($sMessage)
    If $g_bPathfinder_Debug Then
        Out("[Pathfinder] " & $sMessage)
    EndIf
EndFunc

; =============================================================================
; Helper function to check if party members are too far and need to wait
; Returns True if we should wait, False if we can continue moving
; =============================================================================
Func _Pathfinder_ShouldWaitForParty($fMaxDistance = 1800, $fResumeDistance = 1400)
    ; Don't wait if there are enemies nearby
    Local $iEnemyCount = GetAgents(-2, 1250, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")

    If $iEnemyCount > 0 Then Return False

    ; Get the "Flag All" position (if set, heroes following flag are excluded)
    Local $aFlagAll = World_GetWorldInfo("FlagAll")
	Local $fX = $aFlagAll[0]
	Local $fY = $aFlagAll[1]
	; Check if values are finite and not zero (meaning flag is actually placed)
	If _IsFinite($fX) And _IsFinite($fY) Then Return False

    ; Get party size (players + heroes + henchmen)
    Local $iPartySize = Party_GetPartyContextInfo("TotalPartySize")

    ; Count party members within resume distance
    Local $iNearbyCount = _Pathfinder_CountPartyMembersInRange($fResumeDistance)
    ; If all party members are nearby, no need to wait
    If $iNearbyCount >= $iPartySize - 1 Then Return False ; -1 for self

    ; Count party members within max distance (5000)
    Local $iTotalCount = _Pathfinder_CountPartyMembersInRange(5000)
    ; If not all party members are even in 5000 range, someone is lost - don't wait forever
    If $iTotalCount < $iPartySize - 1 Then Return False

    ; Get farthest party member and check if they are moving
    Local $iFarthestID = _Pathfinder_GetFarthestPartyMember()
    If $iFarthestID = 0 Then Return False

    Return True
EndFunc

Func _IsFinite($fValue)
    ; inf and NaN comparisons: inf > any number, NaN <> NaN
    Return ($fValue > -1e30 And $fValue < 1e30)
EndFunc

; =============================================================================
; Check if all party members are close enough to resume movement
; Returns True if all are within resume distance, False otherwise
; =============================================================================
Func _Pathfinder_PartyWithinRange($fResumeDistance = 1400)
    ; If enemies appeared, resume movement immediately
    Local $iEnemyCount = GetAgents(-2, 1200, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")
    If $iEnemyCount > 0 Then Return True

    ; Get the "Flag All" position
    Local $aFlagAll = World_GetWorldInfo("FlagAll")
If IsArray($aFlagAll) Then
	Local $fX = $aFlagAll[0]
	Local $fY = $aFlagAll[1]
	; Check if values are finite and not zero (meaning flag is actually placed)
	If _IsFinite($fX) And _IsFinite($fY) Then Return True
EndIf

    ; Get party size and count nearby members
    Local $iPartySize = Party_GetPartyContextInfo("TotalPartySize")
    Local $iNearbyCount = _Pathfinder_CountPartyMembersInRange($fResumeDistance)

    Return ($iNearbyCount >= $iPartySize - 1) ; -1 for self
EndFunc

; =============================================================================
; Count party members (heroes + henchmen) within range
; =============================================================================
Func _Pathfinder_CountPartyMembersInRange($fRange)
    Local $iCount = 0
    Local $iMyID = Agent_GetMyID()

    ; Count heroes in range
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop

        Local $fDist = Agent_GetDistance($iHeroAgentID, $iMyID)
        If $fDist <= $fRange Then $iCount += 1
    Next

    ; Count henchmen in range
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then ContinueLoop

        Local $fDist = Agent_GetDistance($iHenchAgentID, $iMyID)
        If $fDist <= $fRange Then $iCount += 1
    Next

    Return $iCount
EndFunc

; =============================================================================
; Get the farthest party member (hero or henchman)
; =============================================================================
Func _Pathfinder_GetFarthestPartyMember()
    Local $iFarthestID = 0
    Local $fFarthestDist = 0
    Local $iMyID = Agent_GetMyID()

    ; Check heroes
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        ; Skip if hero is flagged
        Local $fFlagX = Party_GetHeroFlagInfo($i, "FlagX")
        Local $fFlagY = Party_GetHeroFlagInfo($i, "FlagY")
        If $fFlagX <> 0 Or $fFlagY <> 0 Then ContinueLoop

        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop

        Local $fDist = Agent_GetDistance($iHeroAgentID, $iMyID)
        If $fDist > $fFarthestDist Then
            $fFarthestDist = $fDist
            $iFarthestID = $iHeroAgentID
        EndIf
    Next

    ; Check henchmen
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then ContinueLoop

        Local $fDist = Agent_GetDistance($iHenchAgentID, $iMyID)
        If $fDist > $fFarthestDist Then
            $fFarthestDist = $fDist
            $iFarthestID = $iHenchAgentID
        EndIf
    Next

    Return $iFarthestID
EndFunc

; =============================================================================
; Check if there are dead party members that can be resurrected
; Returns True if we should wait for resurrection, False otherwise
; =============================================================================
Func _Pathfinder_ShouldWaitForResurrection()
    ; Don't wait if there are enemies nearby
    Local $iEnemyCount = GetAgents(-2, 1200, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")
    If $iEnemyCount > 0 Then Return False

    ; Count dead party members
    Local $iDeadCount = _Pathfinder_CountDeadPartyMembers()
    If $iDeadCount = 0 Then Return False

    ; Check if we have resurrection skills available
    Local $iRezCount = _Pathfinder_CountAvailableResurrections()
    If $iRezCount = 0 Then Return False

    Return True
EndFunc

; =============================================================================
; Count dead party members (heroes + henchmen)
; =============================================================================
Func _Pathfinder_CountDeadPartyMembers()
    Local $iCount = 0

    ; Count dead heroes
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then $iCount += 1
    Next

    ; Count dead henchmen
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then $iCount += 1
    Next

    Return $iCount
EndFunc

; =============================================================================
; Count available resurrection skills on living heroes (not on cooldown)
; =============================================================================
Func _Pathfinder_CountAvailableResurrections()
    Local $iCount = 0
    Local $iMyID = Agent_GetMyID()

    ; Check player's skillbar
;~     If Not Agent_GetAgentInfo(-2, "IsDead") Then
;~         For $iSlot = 1 To 8
;~             Local $iSkillID = Skill_GetSkillbarInfo($iSlot, "SkillID", 0)
;~             If $iSkillID = 0 Then ContinueLoop
;~             If Skill_IsAnyResurrection($iSkillID) Or Skill_IsResurrectionSpecial($iSkillID) Then
;~                 If Skill_GetSkillbarInfo($iSlot, "IsRecharged", 0) Then
;~                     $iCount += 1
;~                 EndIf
;~             EndIf
;~         Next
;~     EndIf

    ; Check heroes' skillbars
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $iHero = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($iHero, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop
        If Agent_GetDistance($iHeroAgentID, $iMyID) > 5000 Then ContinueLoop

        For $iSlot = 1 To 8
            Local $iSkillID = Skill_GetSkillbarInfo($iSlot, "SkillID", $iHero)
            If $iSkillID = 0 Then ContinueLoop
            If Skill_IsAnyResurrection($iSkillID) Or Skill_IsResurrectionSpecial($iSkillID) Then
                If Skill_GetSkillbarInfo($iSlot, "IsRecharged", $iHero) Then
                    $iCount += 1
                EndIf
            EndIf
        Next
    Next

    Return $iCount
EndFunc

; =============================================================================
; Get nearest dead party member
; Returns AgentID or 0 if none
; =============================================================================
Func _Pathfinder_GetNearestDeadPartyMember()
    Local $iNearestID = 0
    Local $fNearestDist = 999999
    Local $iMyID = Agent_GetMyID()

    ; Check dead heroes
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Not Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop

        Local $fDist = Agent_GetDistance($iHeroAgentID, $iMyID)
        If $fDist < $fNearestDist Then
            $fNearestDist = $fDist
            $iNearestID = $iHeroAgentID
        EndIf
    Next

    ; Check dead henchmen
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Not Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then ContinueLoop

        Local $fDist = Agent_GetDistance($iHenchAgentID, $iMyID)
        If $fDist < $fNearestDist Then
            $fNearestDist = $fDist
            $iNearestID = $iHenchAgentID
        EndIf
    Next

    Return $iNearestID
EndFunc

; =============================================================================
; Wait for dead party member to be resurrected
; Moves player towards the dead ally so heroes can res
; =============================================================================
Func _Pathfinder_WaitForResurrection()
    Local $iDeadAllyID = _Pathfinder_GetNearestDeadPartyMember()
    If $iDeadAllyID = 0 Then Return

    Out("Waiting for dead ally to be resurrected")

    ; Move towards dead ally (within earshot range so heroes can res)
    Local $fDeadX = Agent_GetAgentInfo($iDeadAllyID, "X")
    Local $fDeadY = Agent_GetAgentInfo($iDeadAllyID, "Y")
    Local $fDist = Agent_GetDistanceToXY($fDeadX, $fDeadY)

    ; If we're too far, move closer
    If $fDist > 1000 Then
        Map_Move($fDeadX, $fDeadY, 0)
    Else
        Agent_CancelAction()
    EndIf

    ; Wait for resurrection
    Local $lRezTimer = TimerInit()
    Do
        Sleep(250)

        ; Check if enemies appeared
        Local $iEnemyCount = GetAgents(-2, 1200, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")
        If $iEnemyCount > 0 Then
            Out("Enemies appeared, stopping res wait")
            Return
        EndIf

        ; Update dead ally (might have been rezzed, check for another)
        If Not Agent_GetAgentInfo($iDeadAllyID, "IsDead") Then
            $iDeadAllyID = _Pathfinder_GetNearestDeadPartyMember()
            If $iDeadAllyID = 0 Then
                Out("All allies resurrected")
                Return
            EndIf
        EndIf

    Until _Pathfinder_CountAvailableResurrections() = 0 Or _Pathfinder_CountDeadPartyMembers() = 0 Or TimerDiff($lRezTimer) > 30000

    Out("Res wait ended")
EndFunc

; =============================================================================
; Filter: Is living enemy
; =============================================================================
Func _Pathfinder_FilterIsEnemy($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "HP") <= 0 Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "IsDead") Then Return False
    Return True
EndFunc