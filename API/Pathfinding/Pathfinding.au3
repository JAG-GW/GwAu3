#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <Math.au3>

; ============================================================================
; Global variables for pathfinding data
; ============================================================================
Global $g_MapData = 0
Global $g_Metadata = 0
Global $g_Trapezoids = 0
Global $g_AABBs = 0
Global $g_Portals = 0
Global $g_Points = 0
Global $g_VisibilityGraph = 0
Global $g_AABBGraph = 0
Global $g_PortalGraph = 0
Global $g_Teleports = 0
Global $g_TeleportGraph = 0
Global $g_TravelPortals = 0

; Priority Queue for A*
Global $g_PriorityQueue[1][2]
Global $g_PQSize = 0

; Constants
Global Const $MAX_VISIBILITY_RANGE = 5000.0
Global Const $INFINITY = 999999999
Global Const $UINT32_MAX = 4294967295

; ============================================================================
; Priority Queue Implementation
; ============================================================================

Func PQ_Init()
    Global $g_PriorityQueue[1][2]
    Global $g_PQSize = 0
EndFunc

Func PQ_Push($priority, $value)
    $g_PQSize += 1
    ReDim $g_PriorityQueue[$g_PQSize + 1][2]
    $g_PriorityQueue[$g_PQSize][0] = $priority
    $g_PriorityQueue[$g_PQSize][1] = $value

    ; Bubble up
    Local $i = $g_PQSize
    While $i > 1
        Local $parent = Int($i / 2)
        If $g_PriorityQueue[$i][0] < $g_PriorityQueue[$parent][0] Then
            ; Swap
            Local $temp[2] = [$g_PriorityQueue[$i][0], $g_PriorityQueue[$i][1]]
            $g_PriorityQueue[$i][0] = $g_PriorityQueue[$parent][0]
            $g_PriorityQueue[$i][1] = $g_PriorityQueue[$parent][1]
            $g_PriorityQueue[$parent][0] = $temp[0]
            $g_PriorityQueue[$parent][1] = $temp[1]
            $i = $parent
        Else
            ExitLoop
        EndIf
    WEnd
EndFunc

Func PQ_Pop()
    If $g_PQSize = 0 Then Return -1

    Local $result = $g_PriorityQueue[1][1]

    ; Move last element to root
    $g_PriorityQueue[1][0] = $g_PriorityQueue[$g_PQSize][0]
    $g_PriorityQueue[1][1] = $g_PriorityQueue[$g_PQSize][1]
    $g_PQSize -= 1

    If $g_PQSize = 0 Then Return $result

    ; Bubble down
    Local $i = 1
    While $i * 2 <= $g_PQSize
        Local $leftChild = $i * 2
        Local $rightChild = $i * 2 + 1
        Local $smallest = $i

        If $leftChild <= $g_PQSize And $g_PriorityQueue[$leftChild][0] < $g_PriorityQueue[$smallest][0] Then
            $smallest = $leftChild
        EndIf

        If $rightChild <= $g_PQSize And $g_PriorityQueue[$rightChild][0] < $g_PriorityQueue[$smallest][0] Then
            $smallest = $rightChild
        EndIf

        If $smallest <> $i Then
            ; Swap
            Local $temp[2] = [$g_PriorityQueue[$i][0], $g_PriorityQueue[$i][1]]
            $g_PriorityQueue[$i][0] = $g_PriorityQueue[$smallest][0]
            $g_PriorityQueue[$i][1] = $g_PriorityQueue[$smallest][1]
            $g_PriorityQueue[$smallest][0] = $temp[0]
            $g_PriorityQueue[$smallest][1] = $temp[1]
            $i = $smallest
        Else
            ExitLoop
        EndIf
    WEnd

    Return $result
EndFunc

Func PQ_IsEmpty()
    Return $g_PQSize = 0
EndFunc

; ============================================================================
; Data Loading Functions
; ============================================================================

Func LoadPathfindingData($filePath)
    Local $fileContent = FileRead($filePath)
    If @error Then
        ConsoleWrite("Error reading file: " & $filePath & @CRLF)
        Return False
    EndIf

    ; Parse file content by sections
    Local $lines = StringSplit($fileContent, @CRLF, 1)
    Local $currentSection = ""
    Local $i = 1

    While $i <= $lines[0]
        Local $line = StringStripWS($lines[$i], 3)

        If StringLeft($line, 1) = "[" And StringRight($line, 1) = "]" Then
            $currentSection = StringMid($line, 2, StringLen($line) - 2)
            ConsoleWrite("Loading section: " & $currentSection & @CRLF)
        ElseIf $line <> "" Then
            Switch $currentSection
                Case "METADATA"
                    ParseMetadata($line)
                Case "TRAPEZOIDS"
                    ParseTrapezoids($lines, $i)
                Case "AABBS"
                    ParseAABBs($lines, $i)
                Case "PORTALS"
                    ParsePortals($lines, $i)
                Case "POINTS"
                    ParsePoints($lines, $i)
                Case "VISIBILITY_GRAPH"
                    ParseVisibilityGraph($lines, $i)
                Case "AABB_GRAPH"
                    ParseAABBGraph($lines, $i)
                Case "PORTAL_GRAPH"
                    ParsePortalGraph($lines, $i)
                Case "TELEPORTS"
                    ParseTeleports($lines, $i)
                Case "TELEPORT_GRAPH"
                    ParseTeleportGraph($lines, $i)
                Case "TRAVEL_PORTALS"
                    ParseTravelPortals($lines, $i)
            EndSwitch
        EndIf

        $i += 1
    WEnd

    ConsoleWrite("Data loaded successfully!" & @CRLF)
    ConsoleWrite("Points: " & UBound($g_Points) & @CRLF)
    ConsoleWrite("Portals: " & UBound($g_Portals) & @CRLF)
    ConsoleWrite("AABBs: " & UBound($g_AABBs) & @CRLF)
    ConsoleWrite("Teleports: " & UBound($g_Teleports) & @CRLF)

    Return True
EndFunc

Func ParseMetadata($line)
    If Not IsArray($g_Metadata) Then
        Dim $g_Metadata[20][2]
    EndIf

    Local $parts = StringSplit($line, "=", 2)
    If UBound($parts) >= 2 Then
        ; Store metadata (you can expand this as needed)
    EndIf
EndFunc

Func ParseTrapezoids(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_Trapezoids[$count][6] ; id, layer, ax, ay, bx, by, cx, cy, dx, dy

        For $i = 0 To $count - 1
            $index += 1
            Local $parts = StringSplit($lines[$index], "|", 2)
            If UBound($parts) >= 6 Then
                $g_Trapezoids[$i][0] = Number($parts[0]) ; id
                $g_Trapezoids[$i][1] = Number($parts[1]) ; layer

                ; Parse vertices
                Local $a = StringSplit($parts[2], ",", 2)
                Local $b = StringSplit($parts[3], ",", 2)
                Local $c = StringSplit($parts[4], ",", 2)
                Local $d = StringSplit($parts[5], ",", 2)

                $g_Trapezoids[$i][2] = Number($a[0]) ; ax
                $g_Trapezoids[$i][3] = Number($a[1]) ; ay
                $g_Trapezoids[$i][4] = Number($b[0]) ; bx
                $g_Trapezoids[$i][5] = Number($b[1]) ; by
                ; Store c and d similarly if needed
            EndIf
        Next
    EndIf
EndFunc

Func ParseAABBs(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_AABBs[$count][7] ; id, pos_x, pos_y, half_x, half_y, trap_id, layer

        For $i = 0 To $count - 1
            $index += 1
            Local $parts = StringSplit($lines[$index], "|", 2)
            If UBound($parts) >= 5 Then
                $g_AABBs[$i][0] = Number($parts[0]) ; id

                Local $pos = StringSplit($parts[1], ",", 2)
                $g_AABBs[$i][1] = Number($pos[0]) ; pos_x
                $g_AABBs[$i][2] = Number($pos[1]) ; pos_y

                Local $half = StringSplit($parts[2], ",", 2)
                $g_AABBs[$i][3] = Number($half[0]) ; half_x
                $g_AABBs[$i][4] = Number($half[1]) ; half_y

                $g_AABBs[$i][5] = Number($parts[3]) ; trap_id
                $g_AABBs[$i][6] = Number($parts[4]) ; layer
            EndIf
        Next
    EndIf
EndFunc

Func ParsePortals(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_Portals[$count][7] ; id, start_x, start_y, goal_x, goal_y, box1_id, box2_id

        For $i = 0 To $count - 1
            $index += 1
            Local $parts = StringSplit($lines[$index], "|", 2)
            If UBound($parts) >= 5 Then
                $g_Portals[$i][0] = Number($parts[0]) ; id

                Local $start = StringSplit($parts[1], ",", 2)
                $g_Portals[$i][1] = Number($start[0]) ; start_x
                $g_Portals[$i][2] = Number($start[1]) ; start_y

                Local $goal = StringSplit($parts[2], ",", 2)
                $g_Portals[$i][3] = Number($goal[0]) ; goal_x
                $g_Portals[$i][4] = Number($goal[1]) ; goal_y

                $g_Portals[$i][5] = Number($parts[3]) ; box1_id
                $g_Portals[$i][6] = Number($parts[4]) ; box2_id
            EndIf
        Next
    EndIf
EndFunc

Func ParsePoints(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_Points[$count][7] ; id, pos_x, pos_y, box_id, layer, box2_id, portal_id

        For $i = 0 To $count - 1
            $index += 1
            Local $parts = StringSplit($lines[$index], "|", 2)
            If UBound($parts) >= 6 Then
                $g_Points[$i][0] = Number($parts[0]) ; id

                Local $pos = StringSplit($parts[1], ",", 2)
                $g_Points[$i][1] = Number($pos[0]) ; pos_x
                $g_Points[$i][2] = Number($pos[1]) ; pos_y

                $g_Points[$i][3] = Number($parts[2]) ; box_id
                $g_Points[$i][4] = Number($parts[3]) ; layer
                $g_Points[$i][5] = Number($parts[4]) ; box2_id
                $g_Points[$i][6] = Number($parts[5]) ; portal_id
            EndIf
        Next
    EndIf
EndFunc

Func ParseVisibilityGraph(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_VisibilityGraph[$count]

        For $i = 0 To $count - 1
            $index += 1
            Local $line = $lines[$index]
            Local $eqPos = StringInStr($line, "=")
            Local $pipePos = StringInStr($line, "|")

            If $pipePos > 0 Then
                Local $edgesStr = StringMid($line, $pipePos + 1)
                Local $edges = StringSplit($edgesStr, ";", 2)

                Local $edgeCount = UBound($edges)
                If $edgeCount > 0 Then
                    Dim $edgeArray[$edgeCount][3] ; point_id, distance, blocking_ids

                    For $j = 0 To $edgeCount - 1
                        ; Parse "point_id,distance,[blocking_ids]"
                        Local $edgeParts = StringSplit($edges[$j], ",", 2)
                        If UBound($edgeParts) >= 2 Then
                            $edgeArray[$j][0] = Number($edgeParts[0]) ; point_id
                            $edgeArray[$j][1] = Number($edgeParts[1]) ; distance

                            ; Parse blocking IDs if present
                            Local $blockingStr = ""
                            For $k = 2 To UBound($edgeParts) - 1
                                $blockingStr &= $edgeParts[$k]
                                If $k < UBound($edgeParts) - 1 Then $blockingStr &= ","
                            Next

                            $blockingStr = StringReplace($blockingStr, "[", "")
                            $blockingStr = StringReplace($blockingStr, "]", "")

                            If $blockingStr <> "" Then
                                $edgeArray[$j][2] = $blockingStr
                            Else
                                $edgeArray[$j][2] = ""
                            EndIf
                        EndIf
                    Next

                    $g_VisibilityGraph[$i] = $edgeArray
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func ParseAABBGraph(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_AABBGraph[$count]

        For $i = 0 To $count - 1
            $index += 1
            Local $line = $lines[$index]
            Local $eqPos = StringInStr($line, "=")

            If $eqPos > 0 Then
                Local $neighborsStr = StringMid($line, $eqPos + 1)
                If $neighborsStr <> "" Then
                    Local $neighbors = StringSplit($neighborsStr, ",", 2)
                    $g_AABBGraph[$i] = $neighbors
                Else
                    Dim $empty[0]
                    $g_AABBGraph[$i] = $empty
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func ParsePortalGraph(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_PortalGraph[$count]

        For $i = 0 To $count - 1
            $index += 1
            Local $line = $lines[$index]
            Local $eqPos = StringInStr($line, "=")

            If $eqPos > 0 Then
                Local $portalsStr = StringMid($line, $eqPos + 1)
                If $portalsStr <> "" Then
                    Local $portals = StringSplit($portalsStr, ",", 2)
                    $g_PortalGraph[$i] = $portals
                Else
                    Dim $empty[0]
                    $g_PortalGraph[$i] = $empty
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func ParseTeleports(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_Teleports[$count][7] ; enter_x, enter_y, enter_z, exit_x, exit_y, exit_z, bidirectional

        For $i = 0 To $count - 1
            $index += 1
            Local $parts = StringSplit($lines[$index], "|", 2)
            If UBound($parts) >= 3 Then
                Local $enter = StringSplit($parts[0], ",", 2)
                $g_Teleports[$i][0] = Number($enter[0]) ; enter_x
                $g_Teleports[$i][1] = Number($enter[1]) ; enter_y
                $g_Teleports[$i][2] = Number($enter[2]) ; enter_z

                Local $exit = StringSplit($parts[1], ",", 2)
                $g_Teleports[$i][3] = Number($exit[0]) ; exit_x
                $g_Teleports[$i][4] = Number($exit[1]) ; exit_y
                $g_Teleports[$i][5] = Number($exit[2]) ; exit_z

                $g_Teleports[$i][6] = Number($parts[2]) ; bidirectional
            EndIf
        Next
    EndIf
EndFunc

Func ParseTeleportGraph(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_TeleportGraph[$count][3] ; tp1_index, tp2_index, distance

        For $i = 0 To $count - 1
            $index += 1
            Local $parts = StringSplit($lines[$index], "|", 2)
            If UBound($parts) >= 3 Then
                $g_TeleportGraph[$i][0] = Number($parts[0]) ; tp1_index
                $g_TeleportGraph[$i][1] = Number($parts[1]) ; tp2_index
                $g_TeleportGraph[$i][2] = Number($parts[2]) ; distance
            EndIf
        Next
    EndIf
EndFunc

Func ParseTravelPortals(ByRef $lines, ByRef $index)
    Local $line = $lines[$index]
    If StringInStr($line, "count=") Then
        Local $count = Number(StringMid($line, 7))
        Dim $g_TravelPortals[$count][3] ; pos_x, pos_y, model_id

        For $i = 0 To $count - 1
            $index += 1
            Local $parts = StringSplit($lines[$index], "|", 2)
            If UBound($parts) >= 2 Then
                Local $pos = StringSplit($parts[0], ",", 2)
                $g_TravelPortals[$i][0] = Number($pos[0]) ; pos_x
                $g_TravelPortals[$i][1] = Number($pos[1]) ; pos_y
                $g_TravelPortals[$i][2] = Number($parts[1]) ; model_id
            EndIf
        Next
    EndIf
EndFunc

; ============================================================================
; Pathfinding Functions
; ============================================================================

Func GetDistance($x1, $y1, $x2, $y2)
    Return Sqrt(($x2 - $x1) * ($x2 - $x1) + ($y2 - $y1) * ($y2 - $y1))
EndFunc

Func GetSquareDistance($x1, $y1, $x2, $y2)
    Return ($x2 - $x1) * ($x2 - $x1) + ($y2 - $y1) * ($y2 - $y1)
EndFunc

Func IsPointInAABB($px, $py, $aabbIndex)
    If $aabbIndex >= UBound($g_AABBs) Or $aabbIndex < 0 Then Return False

    Local $pos_x = $g_AABBs[$aabbIndex][1]
    Local $pos_y = $g_AABBs[$aabbIndex][2]
    Local $half_x = $g_AABBs[$aabbIndex][3]
    Local $half_y = $g_AABBs[$aabbIndex][4]

    If Abs($px - $pos_x) > $half_x Then Return False
    If Abs($py - $pos_y) > $half_y Then Return False

    Return True
EndFunc

Func FindAABB($x, $y, $layer = 0)
    For $i = 0 To UBound($g_AABBs) - 1
        If $g_AABBs[$i][6] = $layer Then ; Check layer
            If IsPointInAABB($x, $y, $i) Then
                Return $i
            EndIf
        EndIf
    Next

    Return -1
EndFunc

Func FindClosestPoint($x, $y, $layer = 0)
    Local $closestIndex = -1
    Local $minDist = $INFINITY

    For $i = 0 To UBound($g_Points) - 1
        Local $px = $g_Points[$i][1]
        Local $py = $g_Points[$i][2]
        Local $player = $g_Points[$i][4]

        ; Consider layer difference as additional distance
        Local $layerPenalty = Abs($player - $layer) * 1000
        Local $dist = GetSquareDistance($x, $y, $px, $py) + $layerPenalty

        If $dist < $minDist Then
            $minDist = $dist
            $closestIndex = $i
        EndIf
    Next

    Return $closestIndex
EndFunc

Func GetClosestPointOnMap($x, $y, $layer = 0)
    ; Check if already on pathing map
    Local $aabbIdx = FindAABB($x, $y, $layer)
    If $aabbIdx >= 0 Then
        Local $result[3] = [$x, $y, $layer]
        Return $result
    EndIf

    ; Find closest point
    Local $closestIdx = FindClosestPoint($x, $y, $layer)
    If $closestIdx >= 0 Then
        Local $result[3] = [$g_Points[$closestIdx][1], $g_Points[$closestIdx][2], $g_Points[$closestIdx][4]]
        Return $result
    EndIf

    Local $result[3] = [0, 0, 0]
    Return $result
EndFunc

Func IsPathBlocked($blockingIdsStr, ByRef $blockedLayers)
    If $blockingIdsStr = "" Then Return False

    Local $blockingIds = StringSplit($blockingIdsStr, ",", 2)
    For $i = 0 To UBound($blockingIds) - 1
        Local $layerId = Number($blockingIds[$i])
        If $layerId < UBound($blockedLayers) Then
            If $blockedLayers[$layerId] Then
                Return True
            EndIf
        EndIf
    Next

    Return False
EndFunc

Func GetTeleporterHeuristic($startPointId, $goalPointId)
    If Not IsArray($g_Teleports) Or UBound($g_Teleports) = 0 Then
        Return $INFINITY
    EndIf

    Local $startX = $g_Points[$startPointId][1]
    Local $startY = $g_Points[$startPointId][2]
    Local $goalX = $g_Points[$goalPointId][1]
    Local $goalY = $g_Points[$goalPointId][2]

    Local $minCost = $INFINITY

    For $i = 0 To UBound($g_Teleports) - 1
        Local $enterX = $g_Teleports[$i][0]
        Local $enterY = $g_Teleports[$i][1]
        Local $exitX = $g_Teleports[$i][3]
        Local $exitY = $g_Teleports[$i][4]
        Local $bidir = $g_Teleports[$i][6]

        ; Distance from start to teleport entrance
        Local $distToEnter = GetDistance($startX, $startY, $enterX, $enterY)
        ; Distance from teleport exit to goal
        Local $distFromExit = GetDistance($exitX, $exitY, $goalX, $goalY)

        Local $cost = $distToEnter + $distFromExit + 10 ; Small penalty

        If $cost < $minCost Then
            $minCost = $cost
        EndIf

        ; Check reverse direction if bidirectional
        If $bidir Then
            $distToEnter = GetDistance($startX, $startY, $exitX, $exitY)
            $distFromExit = GetDistance($enterX, $enterY, $goalX, $goalY)
            $cost = $distToEnter + $distFromExit + 10

            If $cost < $minCost Then
                $minCost = $cost
            EndIf
        EndIf
    Next

    Return $minCost
EndFunc

; Main A* pathfinding function
Func CalculatePath($fromX, $fromY, $fromZ, $toX, $toY, $toZ, ByRef $blockedLayers)
    Local $path[0][3] ; Array to store path points [x, y, z]

    ; Get closest points on the pathing map
    Local $startPos = GetClosestPointOnMap($fromX, $fromY, $fromZ)
    Local $goalPos = GetClosestPointOnMap($toX, $toY, $toZ)

    If $startPos[0] = 0 And $startPos[1] = 0 Then
        ConsoleWrite("Failed to find valid start position" & @CRLF)
        Return $path
    EndIf

    If $goalPos[0] = 0 And $goalPos[1] = 0 Then
        ConsoleWrite("Failed to find valid goal position" & @CRLF)
        Return $path
    EndIf

    ; Find start and goal points in the graph
    Local $startPointId = FindClosestPoint($startPos[0], $startPos[1], $startPos[2])
    Local $goalPointId = FindClosestPoint($goalPos[0], $goalPos[1], $goalPos[2])

    If $startPointId < 0 Or $goalPointId < 0 Then
        ConsoleWrite("Failed to find start or goal points in graph" & @CRLF)
        Return $path
    EndIf

    ConsoleWrite("Start point: " & $startPointId & ", Goal point: " & $goalPointId & @CRLF)

    ; Initialize A* algorithm
    Local $numPoints = UBound($g_Points)
    Local $gScore[$numPoints]
    Local $cameFrom[$numPoints]
    Local $inClosedSet[$numPoints]

    For $i = 0 To $numPoints - 1
        $gScore[$i] = $INFINITY
        $cameFrom[$i] = -1
        $inClosedSet[$i] = False
    Next

    ; Initialize start node
    $gScore[$startPointId] = 0

    ; Initialize priority queue
    PQ_Init()
    Local $heuristic = GetDistance($g_Points[$startPointId][1], $g_Points[$startPointId][2], _
                                  $g_Points[$goalPointId][1], $g_Points[$goalPointId][2])
    PQ_Push($heuristic, $startPointId)

    Local $useTeleports = (IsArray($g_Teleports) And UBound($g_Teleports) > 0)

    ; A* main loop
    While Not PQ_IsEmpty()
        Local $current = PQ_Pop()

        If $current = $goalPointId Then
            ; Reconstruct path
            ConsoleWrite("Path found!" & @CRLF)
            Local $node = $goalPointId
            Local $tempPath[0]

            While $node <> -1 And $node <> $startPointId
                _ArrayAdd($tempPath, $node)
                $node = $cameFrom[$node]
            WEnd
            _ArrayAdd($tempPath, $startPointId)

            ; Reverse path and convert to coordinates
            For $i = UBound($tempPath) - 1 To 0 Step -1
                Local $pointIdx = $tempPath[$i]
                Local $coord[3] = [$g_Points[$pointIdx][1], $g_Points[$pointIdx][2], $g_Points[$pointIdx][4]]
                Local $newRow = UBound($path)
                ReDim $path[$newRow + 1][3]
                $path[$newRow][0] = $coord[0]
                $path[$newRow][1] = $coord[1]
                $path[$newRow][2] = $coord[2]
            Next

            ConsoleWrite("Path length: " & $gScore[$goalPointId] & @CRLF)
            Return $path
        EndIf

        If $current < 0 Or $current >= $numPoints Then ContinueLoop

        $inClosedSet[$current] = True

        ; Check all neighbors
        If $current < UBound($g_VisibilityGraph) Then
            Local $edges = $g_VisibilityGraph[$current]
            If IsArray($edges) Then
                For $i = 0 To UBound($edges) - 1
                    Local $neighbor = $edges[$i][0]
                    Local $distance = $edges[$i][1]
                    Local $blockingIds = $edges[$i][2]

                    ; Skip if in closed set
                    If $neighbor >= 0 And $neighbor < $numPoints Then
                        If $inClosedSet[$neighbor] Then ContinueLoop
                    Else
                        ContinueLoop
                    EndIf

                    ; Skip if path is blocked
                    If IsPathBlocked($blockingIds, $blockedLayers) Then ContinueLoop

                    ; Calculate tentative g score
                    Local $tentativeGScore = $gScore[$current] + $distance

                    If $tentativeGScore < $gScore[$neighbor] Then
                        ; This path is better
                        $cameFrom[$neighbor] = $current
                        $gScore[$neighbor] = $tentativeGScore

                        ; Calculate heuristic
                        Local $h = GetDistance($g_Points[$neighbor][1], $g_Points[$neighbor][2], _
                                             $g_Points[$goalPointId][1], $g_Points[$goalPointId][2])

                        ; Check for teleporter heuristic
                        If $useTeleports Then
                            Local $teleportH = GetTeleporterHeuristic($neighbor, $goalPointId)
                            If $teleportH < $h Then $h = $teleportH
                        EndIf

                        Local $fScore = $tentativeGScore + $h
                        PQ_Push($fScore, $neighbor)
                    EndIf
                Next
            EndIf
        EndIf
    WEnd

    ConsoleWrite("No path found" & @CRLF)
    Return $path
EndFunc

; Simplify path by removing unnecessary waypoints
Func SimplifyPath(ByRef $path, $aMaxDist = 2500)
    If UBound($path) <= 2 Then Return $path

    Local $simplified[1][3]
    $simplified[0][0] = $path[0][0]
    $simplified[0][1] = $path[0][1]
    $simplified[0][2] = $path[0][2]

    Local $i = 0
    While $i < UBound($path) - 1
        Local $j = $i + 2
        Local $lastValid = $i + 1

        ; Try to skip points (simplified line of sight check)
        While $j < UBound($path)
            ; Here you would check line of sight
            ; For now, just use distance as a simple heuristic
            Local $dist = GetDistance($path[$i][0], $path[$i][1], $path[$j][0], $path[$j][1])
            If $dist < $aMaxDist Then
                $lastValid = $j
                $j += 1
            Else
                ExitLoop
            EndIf
        WEnd

        Local $newRow = UBound($simplified)
        ReDim $simplified[$newRow + 1][3]
        $simplified[$newRow][0] = $path[$lastValid][0]
        $simplified[$newRow][1] = $path[$lastValid][1]
        $simplified[$newRow][2] = $path[$lastValid][2]

        $i = $lastValid
    WEnd

    Return $simplified
EndFunc

; ============================================================================
; Example Usage
; ============================================================================

;~ Func ExampleUsage()
;~     ; Load pathfinding data
;~     Local $dataFile = "675_Boreal_Station.gwau3" ; Your exported file

;~     If Not LoadPathfindingData($dataFile) Then
;~         ConsoleWrite("Failed to load pathfinding data from: " & $dataFile & @CRLF)
;~         Return
;~     EndIf

;~     ; Define blocked layers (0 = not blocked, 1 = blocked)
;~     Local $blockedLayers[256]
;~     For $i = 0 To 255
;~         $blockedLayers[$i] = False
;~     Next

;~     ; Example: Calculate path from point A to point B
;~     Local $fromX = 7444
;~     Local $fromY = -25168
;~     Local $fromZ = 0
;~     Local $toX = -4553
;~     Local $toY = 24731
;~     Local $toZ = 0

;~     ConsoleWrite("Calculating path from (" & $fromX & ", " & $fromY & ", " & $fromZ & ") to (" & _
;~                  $toX & ", " & $toY & ", " & $toZ & ")" & @CRLF)

;~     Local $path = CalculatePath($fromX, $fromY, $fromZ, $toX, $toY, $toZ, $blockedLayers)

;~     If UBound($path) > 0 Then
;~         ConsoleWrite("Path found with " & UBound($path) & " waypoints:" & @CRLF)
;~         For $i = 0 To UBound($path) - 1
;~             ConsoleWrite("(" & $path[$i][0] & ", " & _
;~                         $path[$i][1] & ", " & $path[$i][2] & ")" & @CRLF)
;~         Next

;~         ; Simplify path
;~         Local $simplified = SimplifyPath($path)
;~         ConsoleWrite(@CRLF & "Simplified path has " & UBound($simplified) & " waypoints:" & @CRLF)
;~         For $i = 0 To UBound($simplified) - 1
;~             ConsoleWrite("(" & $simplified[$i][0] & ", " & _
;~                         $simplified[$i][1] & ", " & $simplified[$i][2] & ")" & @CRLF)
;~         Next
;~     Else
;~         ConsoleWrite("No path found!" & @CRLF)
;~     EndIf
;~ EndFunc

;~ ; Run the example
;~ ExampleUsage()

