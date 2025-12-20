#include-once

#include "Pathfinder_Core.au3"

; Movement state
Global $g_aPathfinder_CurrentPath[0][3]  ; x, y, layer
Global $g_iPathfinder_CurrentPathIndex = 0
Global $g_hPathfinder_LastPathUpdateTime = 0

; Configuration
Global $g_iPathfinder_PathUpdateInterval = 500      ; Interval before recalculating path (ms)
Global $g_iPathfinder_WaypointReachedDistance = 100 ; Distance to consider waypoint reached
Global $g_iPathfinder_SimplifyRange = 400           ; Path simplification range
Global $g_iPathfinder_ObstacleUpdateInterval = 250  ; Interval for dynamic obstacle updates (ms)
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
    Local $lMyOldMap = Map_GetMapID()
    Local $lMapLoadingOld = Map_GetInstanceInfo("Type")
    Local $lMyX = Agent_GetAgentInfo(-2, "X")
    Local $lMyY = Agent_GetAgentInfo(-2, "Y")

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
            Map_Move($aDestX, $aDestY, 0)
            Return False
        EndIf
    EndIf

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

    Local $lPath = _Pathfinder_GetPath($lMyX, $lMyY, $aDestX, $aDestY, $lCurrentObstacles)
    If Not IsArray($lPath) Or UBound($lPath) = 0 Then
        Map_Move($aDestX, $aDestY, 0)
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
        ; Check for map change or death
        If Map_GetMapID() <> $lMyOldMap Then
            Pathfinder_Shutdown()
            Return False
        EndIf
        If Map_GetInstanceInfo("Type") <> $lMapLoadingOld Then
            Pathfinder_Shutdown()
            Return False
        EndIf
        If Party_GetPartyContextInfo("IsDefeated") Then
            Pathfinder_Shutdown()
            Return False
        EndIf

        $lMyX = Agent_GetAgentInfo(-2, "X")
        $lMyY = Agent_GetAgentInfo(-2, "Y")

        ; Update obstacles (dynamic mode only)
        Local $lNeedPathUpdate = False
        If $lIsDynamicObstacles And TimerDiff($lLastObstacleUpdate) > $g_iPathfinder_ObstacleUpdateInterval Then
            $lCurrentObstacles = Call($aObstacles)
            $lLastObstacleUpdate = TimerInit()
            $lNeedPathUpdate = True
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

        ; Recalculate path if needed (based on time interval)
        If TimerDiff($g_hPathfinder_LastPathUpdateTime) > $g_iPathfinder_PathUpdateInterval Or $lNeedPathUpdate Then
            $lPath = _Pathfinder_GetPath($lMyX, $lMyY, $aDestX, $aDestY, $lCurrentObstacles)
            If IsArray($lPath) And UBound($lPath) > 0 Then
                $g_aPathfinder_CurrentPath = $lPath
                $g_iPathfinder_CurrentPathIndex = 0
                $g_hPathfinder_LastPathUpdateTime = TimerInit()
            Else
                ; Path update failed, but we still have an old path - just update the timer
                ; to avoid spamming failed path requests
                $g_hPathfinder_LastPathUpdateTime = TimerInit()
            EndIf
        EndIf

        ; Move to current waypoint
        If $g_iPathfinder_CurrentPathIndex >= UBound($g_aPathfinder_CurrentPath) Then
            Map_Move($aDestX, $aDestY, 0)
        Else
            Local $lWaypointX = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][0]
            Local $lWaypointY = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][1]
            Local $lWaypointLayer = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][2]

            If _Pathfinder_Distance($lMyX, $lMyY, $lWaypointX, $lWaypointY) < $g_iPathfinder_WaypointReachedDistance Then
                $g_iPathfinder_CurrentPathIndex += 1
                If $g_iPathfinder_CurrentPathIndex < UBound($g_aPathfinder_CurrentPath) Then
                    $lWaypointX = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][0]
                    $lWaypointY = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][1]
                    $lWaypointLayer = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][2]
                Else
                    $lWaypointX = $aDestX
                    $lWaypointY = $aDestY
                    $lWaypointLayer = 0
                EndIf
            EndIf

            ; Use Map_MoveLayer to move to the correct layer (important for bridges)
            Map_MoveLayer($lWaypointX, $lWaypointY, $lWaypointLayer)
        EndIf

        ; Fight if needed
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then UAI_Fight($lMyX, $lMyY, $aAggroRange, $aFightRangeOut, $aFinisherMode)

        Sleep(32)

    Until Agent_GetDistanceToXY($aDestX, $aDestY) < 150

    ; Shutdown DLL and free memory
    Pathfinder_Shutdown()

    Return True
EndFunc

; Internal: Get path from current position to destination
Func _Pathfinder_GetPath($aStartX, $aStartY, $aDestX, $aDestY, $aObstacles)
    Local $lMapID = Map_GetMapID()

    If IsArray($aObstacles) And UBound($aObstacles) > 0 Then
        ; Get raw path with minimal simplification from DLL
        Local $lPath = Pathfinder_FindPathGWWithObstacle($lMapID, $aStartX, $aStartY, $aDestX, $aDestY, $aObstacles, 500)
        If @error Then Return 0

        Return $lPath
    Else
        Return Pathfinder_FindPathGW($lMapID, $aStartX, $aStartY, $aDestX, $aDestY, 500)
    EndIf
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
