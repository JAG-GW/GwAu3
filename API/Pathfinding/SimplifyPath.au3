#include-once
#include "Pathfinding.au3"

; ============================================================================
; Configuration
; ============================================================================
Global Const $GC_F_MAX_LINE_OF_SIGHT_DISTANCE = 2500.0 ; Maximum distance for line of sight
Global Const $GC_F_WALL_DETECTION_RADIUS = 600.0 ; Wall detection radius (reduced for performance)
Global Const $GC_F_MIN_WALL_DISTANCE = 250.0 ; Minimum distance from walls
Global Const $GC_F_MAX_WALL_DISTANCE = 500.0 ; Maximum distance from walls

; Cache for optimizing calculations
Global $g_af2_AABBCache[0][8]  ; Cache of AABBs with pre-calculated limits
Global $g_af2_TrapezoidCache[0][10] ; Cache of trapezoids
Global $g_amx2_WallCache[0][0] ; Cache of wall detections
Global $g_b_CacheInitialized = False

; Spatial grid for acceleration
Global $g_as_SpatialGrid[0]
Global $g_f_GridCellSize = 500.0
Global $g_f_GridMinX, $g_f_GridMinY, $g_f_GridMaxX, $g_f_GridMaxY
Global $g_i_GridWidth, $g_i_GridHeight

; ============================================================================
; Main optimization function
; ============================================================================
Func Pathfinding_OptimizePath(ByRef $a_af2_OriginalPath, $a_f_Aggressiveness = 0.8)
    If UBound($a_af2_OriginalPath) <= 2 Then Return $a_af2_OriginalPath

    ConsoleWrite("========================================" & @CRLF)
    ConsoleWrite("Starting path optimization with " & UBound($a_af2_OriginalPath) & " waypoints" & @CRLF)

    ; Initialize cache if necessary
    If Not $g_b_CacheInitialized Then
        Local $l_i_Timer = TimerInit()
        Pathfinding_InitializeAABBCache()
        Pathfinding_InitializeTrapezoidCache()
        Pathfinding_InitializeSpatialGrid()
        ConsoleWrite("  Cache initialization: " & Round(TimerDiff($l_i_Timer), 1) & " ms" & @CRLF)
    EndIf

    ; Step 1: Line of sight optimization
    Local $l_i_Timer = TimerInit()
    Local $l_af2_OptimizedPath = Pathfinding_OptimizeByLineOfSight($a_af2_OriginalPath)
    ConsoleWrite("  Line of sight completed in " & Round(TimerDiff($l_i_Timer), 1) & " ms" & @CRLF)

    ; Step 2: Fast wall adjustment
    $l_i_Timer = TimerInit()
    Local $l_af2_AdjustedPath = Pathfinding_WallAdjustment($l_af2_OptimizedPath, $a_f_Aggressiveness)
    ConsoleWrite("  Fast wall adjustment completed in " & Round(TimerDiff($l_i_Timer), 1) & " ms" & @CRLF)

    ; Step 3: Final path smoothing
    $l_i_Timer = TimerInit()
    Local $l_af2_SmoothedPath = Pathfinding_SmoothPath($l_af2_AdjustedPath)
    ConsoleWrite("  Path smoothing completed in " & Round(TimerDiff($l_i_Timer), 1) & " ms" & @CRLF)

    ; IMPORTANT: Ensure the last point is the final destination
    Local $l_i_LastOriginal = UBound($a_af2_OriginalPath) - 1
    Local $l_i_LastSmoothed = UBound($l_af2_SmoothedPath) - 1

    ; Check if the last point is different from the destination
    If $l_af2_SmoothedPath[$l_i_LastSmoothed][0] <> $a_af2_OriginalPath[$l_i_LastOriginal][0] Or _
       $l_af2_SmoothedPath[$l_i_LastSmoothed][1] <> $a_af2_OriginalPath[$l_i_LastOriginal][1] Or _
       $l_af2_SmoothedPath[$l_i_LastSmoothed][2] <> $a_af2_OriginalPath[$l_i_LastOriginal][2] Then
        ; Add the final destination if it's missing
        _ArrayAdd($l_af2_SmoothedPath, $a_af2_OriginalPath[$l_i_LastOriginal][0] & "|" & _
                                       $a_af2_OriginalPath[$l_i_LastOriginal][1] & "|" & _
                                       $a_af2_OriginalPath[$l_i_LastOriginal][2])
        ConsoleWrite("  Added final destination point" & @CRLF)
    EndIf

    ConsoleWrite("Optimization complete: " & UBound($l_af2_SmoothedPath) & " waypoints" & @CRLF)
    ConsoleWrite("========================================" & @CRLF)

    Return $l_af2_SmoothedPath
EndFunc

; ============================================================================
; Initialize spatial grid for acceleration
; ============================================================================
Func Pathfinding_InitializeSpatialGrid()
    ; Find map boundaries
    $g_f_GridMinX = 999999
    $g_f_GridMinY = 999999
    $g_f_GridMaxX = -999999
    $g_f_GridMaxY = -999999

    For $l_i_Idx = 0 To UBound($g_af2_AABBCache) - 1
        If $g_af2_AABBCache[$l_i_Idx][0] < $g_f_GridMinX Then $g_f_GridMinX = $g_af2_AABBCache[$l_i_Idx][0]
        If $g_af2_AABBCache[$l_i_Idx][1] > $g_f_GridMaxX Then $g_f_GridMaxX = $g_af2_AABBCache[$l_i_Idx][1]
        If $g_af2_AABBCache[$l_i_Idx][2] < $g_f_GridMinY Then $g_f_GridMinY = $g_af2_AABBCache[$l_i_Idx][2]
        If $g_af2_AABBCache[$l_i_Idx][3] > $g_f_GridMaxY Then $g_f_GridMaxY = $g_af2_AABBCache[$l_i_Idx][3]
    Next

    ; Calculate grid dimensions
    $g_i_GridWidth = Ceiling(($g_f_GridMaxX - $g_f_GridMinX) / $g_f_GridCellSize) + 1
    $g_i_GridHeight = Ceiling(($g_f_GridMaxY - $g_f_GridMinY) / $g_f_GridCellSize) + 1

    ; Initialize grid
    Local $l_i_GridSize = $g_i_GridWidth * $g_i_GridHeight
    ReDim $g_as_SpatialGrid[$l_i_GridSize]

    For $l_i_Idx = 0 To $l_i_GridSize - 1
        $g_as_SpatialGrid[$l_i_Idx] = ""
    Next

    ; Fill grid with AABB indices
    For $l_i_AABBIdx = 0 To UBound($g_af2_AABBCache) - 1
        Local $l_i_MinCellX = Floor(($g_af2_AABBCache[$l_i_AABBIdx][0] - $g_f_GridMinX) / $g_f_GridCellSize)
        Local $l_i_MaxCellX = Floor(($g_af2_AABBCache[$l_i_AABBIdx][1] - $g_f_GridMinX) / $g_f_GridCellSize)
        Local $l_i_MinCellY = Floor(($g_af2_AABBCache[$l_i_AABBIdx][2] - $g_f_GridMinY) / $g_f_GridCellSize)
        Local $l_i_MaxCellY = Floor(($g_af2_AABBCache[$l_i_AABBIdx][3] - $g_f_GridMinY) / $g_f_GridCellSize)

        For $l_i_CellX = $l_i_MinCellX To $l_i_MaxCellX
            For $l_i_CellY = $l_i_MinCellY To $l_i_MaxCellY
                If $l_i_CellX >= 0 And $l_i_CellX < $g_i_GridWidth And $l_i_CellY >= 0 And $l_i_CellY < $g_i_GridHeight Then
                    Local $l_i_GridIndex = $l_i_CellY * $g_i_GridWidth + $l_i_CellX
                    If $g_as_SpatialGrid[$l_i_GridIndex] = "" Then
                        $g_as_SpatialGrid[$l_i_GridIndex] = String($l_i_AABBIdx)
                    Else
                        $g_as_SpatialGrid[$l_i_GridIndex] &= "," & $l_i_AABBIdx
                    EndIf
                EndIf
            Next
        Next
    Next

    ConsoleWrite("  Spatial grid initialized: " & $g_i_GridWidth & "x" & $g_i_GridHeight & " cells" & @CRLF)
EndFunc

; ============================================================================
; Fast point validation with spatial grid
; ============================================================================
Func Pathfinding_ValidatePoint($a_f_X, $a_f_Y, $a_i_Z)
    ; Find grid cell
    Local $l_i_CellX = Floor(($a_f_X - $g_f_GridMinX) / $g_f_GridCellSize)
    Local $l_i_CellY = Floor(($a_f_Y - $g_f_GridMinY) / $g_f_GridCellSize)

    If $l_i_CellX < 0 Or $l_i_CellX >= $g_i_GridWidth Or $l_i_CellY < 0 Or $l_i_CellY >= $g_i_GridHeight Then
        Return False
    EndIf

    Local $l_i_GridIndex = $l_i_CellY * $g_i_GridWidth + $l_i_CellX
    If $g_as_SpatialGrid[$l_i_GridIndex] = "" Then Return False

    ; Check only AABBs in this cell
    Local $l_as_Indices = StringSplit($g_as_SpatialGrid[$l_i_GridIndex], ",", 2)

    For $l_s_Idx In $l_as_Indices
        Local $l_i_AABBIdx = Number($l_s_Idx)
        If $g_af2_AABBCache[$l_i_AABBIdx][6] <> $a_i_Z Then ContinueLoop

        If $a_f_X >= $g_af2_AABBCache[$l_i_AABBIdx][0] And $a_f_X <= $g_af2_AABBCache[$l_i_AABBIdx][1] And _
           $a_f_Y >= $g_af2_AABBCache[$l_i_AABBIdx][2] And $a_f_Y <= $g_af2_AABBCache[$l_i_AABBIdx][3] Then
            Return True
        EndIf
    Next

    Return False
EndFunc

; ============================================================================
; Initialize AABB cache
; ============================================================================
Func Pathfinding_InitializeAABBCache()
    Local $l_i_Count = UBound($g_av_AABBs)
    ReDim $g_af2_AABBCache[$l_i_Count][8]

    For $l_i_Idx = 0 To $l_i_Count - 1
        Local $l_f_CenterX = $g_av_AABBs[$l_i_Idx][1]
        Local $l_f_CenterY = $g_av_AABBs[$l_i_Idx][2]
        Local $l_f_HalfX = $g_av_AABBs[$l_i_Idx][3]
        Local $l_f_HalfY = $g_av_AABBs[$l_i_Idx][4]

        $g_af2_AABBCache[$l_i_Idx][0] = $l_f_CenterX - $l_f_HalfX  ; minX
        $g_af2_AABBCache[$l_i_Idx][1] = $l_f_CenterX + $l_f_HalfX  ; maxX
        $g_af2_AABBCache[$l_i_Idx][2] = $l_f_CenterY - $l_f_HalfY  ; minY
        $g_af2_AABBCache[$l_i_Idx][3] = $l_f_CenterY + $l_f_HalfY  ; maxY
        $g_af2_AABBCache[$l_i_Idx][4] = $l_f_CenterX              ; centerX
        $g_af2_AABBCache[$l_i_Idx][5] = $l_f_CenterY              ; centerY
        $g_af2_AABBCache[$l_i_Idx][6] = $g_av_AABBs[$l_i_Idx][6]  ; layer
        $g_af2_AABBCache[$l_i_Idx][7] = _Max($l_f_HalfX, $l_f_HalfY) ; max radius
    Next

    ConsoleWrite("  AABB cache initialized with " & $l_i_Count & " entries" & @CRLF)
EndFunc

; ============================================================================
; Initialize trapezoid cache
; ============================================================================
Func Pathfinding_InitializeTrapezoidCache()
    If Not IsArray($g_av_Trapezoids) Then Return

    Local $l_i_Count = UBound($g_av_Trapezoids)
    ReDim $g_af2_TrapezoidCache[$l_i_Count][10]

    For $l_i_Idx = 0 To $l_i_Count - 1
        $g_af2_TrapezoidCache[$l_i_Idx][0] = $g_av_Trapezoids[$l_i_Idx][0] ; id
        $g_af2_TrapezoidCache[$l_i_Idx][1] = $g_av_Trapezoids[$l_i_Idx][1] ; layer
        $g_af2_TrapezoidCache[$l_i_Idx][2] = $g_av_Trapezoids[$l_i_Idx][2] ; ax
        $g_af2_TrapezoidCache[$l_i_Idx][3] = $g_av_Trapezoids[$l_i_Idx][3] ; ay
        $g_af2_TrapezoidCache[$l_i_Idx][4] = $g_av_Trapezoids[$l_i_Idx][4] ; bx
        $g_af2_TrapezoidCache[$l_i_Idx][5] = $g_av_Trapezoids[$l_i_Idx][5] ; by

        ; Calculate trapezoid center
        $g_af2_TrapezoidCache[$l_i_Idx][6] = ($g_av_Trapezoids[$l_i_Idx][2] + $g_av_Trapezoids[$l_i_Idx][4]) / 2 ; centerX
        $g_af2_TrapezoidCache[$l_i_Idx][7] = ($g_av_Trapezoids[$l_i_Idx][3] + $g_av_Trapezoids[$l_i_Idx][5]) / 2 ; centerY

        ; Calculate dimensions
        $g_af2_TrapezoidCache[$l_i_Idx][8] = Abs($g_av_Trapezoids[$l_i_Idx][2] - $g_av_Trapezoids[$l_i_Idx][4]) ; width
        $g_af2_TrapezoidCache[$l_i_Idx][9] = Abs($g_av_Trapezoids[$l_i_Idx][3] - $g_av_Trapezoids[$l_i_Idx][5]) ; height
    Next

    ConsoleWrite("  Trapezoid cache initialized with " & $l_i_Count & " entries" & @CRLF)
    $g_b_CacheInitialized = True
EndFunc

; ============================================================================
; Line of sight optimization
; ============================================================================
Func Pathfinding_OptimizeByLineOfSight(ByRef $a_af2_Path)
    Local $l_af2_Result[0][3]
    Local $l_i_CurrentIdx = 0

    ; Always keep the first point (start)
    _ArrayAdd($l_af2_Result, $a_af2_Path[0][0] & "|" & $a_af2_Path[0][1] & "|" & $a_af2_Path[0][2])

    While $l_i_CurrentIdx < UBound($a_af2_Path) - 1
        Local $l_i_FurthestVisible = $l_i_CurrentIdx + 1

        ; Find the furthest visible point
        For $l_i_TestIdx = $l_i_CurrentIdx + 2 To UBound($a_af2_Path) - 1
            Local $l_f_Dist = Pathfinding_GetDistance($a_af2_Path[$l_i_CurrentIdx][0], $a_af2_Path[$l_i_CurrentIdx][1], _
                                         $a_af2_Path[$l_i_TestIdx][0], $a_af2_Path[$l_i_TestIdx][1])
            If $l_f_Dist > $GC_F_MAX_LINE_OF_SIGHT_DISTANCE Then ExitLoop

            Local $l_af_Point1[3] = [$a_af2_Path[$l_i_CurrentIdx][0], $a_af2_Path[$l_i_CurrentIdx][1], $a_af2_Path[$l_i_CurrentIdx][2]]
            Local $l_af_Point2[3] = [$a_af2_Path[$l_i_TestIdx][0], $a_af2_Path[$l_i_TestIdx][1], $a_af2_Path[$l_i_TestIdx][2]]

            If Pathfinding_CheckLineOfSight($l_af_Point1, $l_af_Point2) Then
                $l_i_FurthestVisible = $l_i_TestIdx
            EndIf
        Next

        ; Add the furthest visible point
        _ArrayAdd($l_af2_Result, $a_af2_Path[$l_i_FurthestVisible][0] & "|" & $a_af2_Path[$l_i_FurthestVisible][1] & "|" & $a_af2_Path[$l_i_FurthestVisible][2])

        $l_i_CurrentIdx = $l_i_FurthestVisible
    WEnd

    ; Ensure the last point is included
    Local $l_i_LastIdx = UBound($a_af2_Path) - 1
    Local $l_i_LastResultIdx = UBound($l_af2_Result) - 1

    ; If the last point of the result is not the last point of the original path
    If $l_af2_Result[$l_i_LastResultIdx][0] <> $a_af2_Path[$l_i_LastIdx][0] Or _
       $l_af2_Result[$l_i_LastResultIdx][1] <> $a_af2_Path[$l_i_LastIdx][1] Or _
       $l_af2_Result[$l_i_LastResultIdx][2] <> $a_af2_Path[$l_i_LastIdx][2] Then
        _ArrayAdd($l_af2_Result, $a_af2_Path[$l_i_LastIdx][0] & "|" & $a_af2_Path[$l_i_LastIdx][1] & "|" & $a_af2_Path[$l_i_LastIdx][2])
    EndIf

    ConsoleWrite("  Line of sight: " & UBound($a_af2_Path) & " -> " & UBound($l_af2_Result) & " waypoints" & @CRLF)
    Return $l_af2_Result
EndFunc

; ============================================================================
; Fast wall adjustment
; ============================================================================
Func Pathfinding_WallAdjustment(ByRef $a_af2_Path, $a_f_Aggressiveness = 0.8)
    If UBound($a_af2_Path) <= 2 Then Return $a_af2_Path

    Local $l_af2_AdjustedPath[0][3]
    Local $l_i_TotalAdjustments = 0

    ; Keep the first point (start)
    _ArrayAdd($l_af2_AdjustedPath, $a_af2_Path[0][0] & "|" & $a_af2_Path[0][1] & "|" & $a_af2_Path[0][2])

    ; Process each intermediate point (but NOT the last one)
    For $l_i_Idx = 1 To UBound($a_af2_Path) - 2
        Local $l_f_X = $a_af2_Path[$l_i_Idx][0]
        Local $l_f_Y = $a_af2_Path[$l_i_Idx][1]
        Local $l_i_Z = $a_af2_Path[$l_i_Idx][2]

        ; Quick wall avoidance calculation
        Local $l_af_Adjustment = Pathfinding_WallAvoidance($l_f_X, $l_f_Y, $l_i_Z)

        If $l_af_Adjustment[0] <> 0 Or $l_af_Adjustment[1] <> 0 Then
            Local $l_f_NewX = $l_f_X + $l_af_Adjustment[0] * $a_f_Aggressiveness
            Local $l_f_NewY = $l_f_Y + $l_af_Adjustment[1] * $a_f_Aggressiveness

            ; Simple validation
            If Pathfinding_ValidatePoint($l_f_NewX, $l_f_NewY, $l_i_Z) Then
                ; Quickly check line of sight
                If $l_i_Idx > 0 Then
                    Local $l_af_PrevPoint[3] = [$l_af2_AdjustedPath[UBound($l_af2_AdjustedPath)-1][0], _
                                                $l_af2_AdjustedPath[UBound($l_af2_AdjustedPath)-1][1], _
                                                $l_af2_AdjustedPath[UBound($l_af2_AdjustedPath)-1][2]]
                    Local $l_af_NewPoint[3] = [$l_f_NewX, $l_f_NewY, $l_i_Z]

                    If Pathfinding_CheckLineOfSight($l_af_PrevPoint, $l_af_NewPoint) Then
                        _ArrayAdd($l_af2_AdjustedPath, $l_f_NewX & "|" & $l_f_NewY & "|" & $l_i_Z)
                        $l_i_TotalAdjustments += 1
                    Else
                        _ArrayAdd($l_af2_AdjustedPath, $l_f_X & "|" & $l_f_Y & "|" & $l_i_Z)
                    EndIf
                Else
                    _ArrayAdd($l_af2_AdjustedPath, $l_f_NewX & "|" & $l_f_NewY & "|" & $l_i_Z)
                    $l_i_TotalAdjustments += 1
                EndIf
            Else
                _ArrayAdd($l_af2_AdjustedPath, $l_f_X & "|" & $l_f_Y & "|" & $l_i_Z)
            EndIf
        Else
            _ArrayAdd($l_af2_AdjustedPath, $l_f_X & "|" & $l_f_Y & "|" & $l_i_Z)
        EndIf
    Next

    ; IMPORTANT: Always keep the exact last point (destination)
    Local $l_i_LastIdx = UBound($a_af2_Path) - 1
    _ArrayAdd($l_af2_AdjustedPath, $a_af2_Path[$l_i_LastIdx][0] & "|" & $a_af2_Path[$l_i_LastIdx][1] & "|" & $a_af2_Path[$l_i_LastIdx][2])

    ConsoleWrite("  Wall adjustments: " & $l_i_TotalAdjustments & " waypoints modified" & @CRLF)
    Return $l_af2_AdjustedPath
EndFunc

; ============================================================================
; Quick wall avoidance calculation
; ============================================================================
Func Pathfinding_WallAvoidance($a_f_X, $a_f_Y, $a_i_Z)
    Local $l_f_RepulsionX = 0
    Local $l_f_RepulsionY = 0
    Local $l_i_WallCount = 0

    ; Scan only 8 main directions for speed
    Local $l_af2_Directions[8][2] = [[1,0], [0.707,0.707], [0,1], [-0.707,0.707], _
                                     [-1,0], [-0.707,-0.707], [0,-1], [0.707,-0.707]]

    For $l_i_DirIdx = 0 To 7
        Local $l_f_DirX = $l_af2_Directions[$l_i_DirIdx][0]
        Local $l_f_DirY = $l_af2_Directions[$l_i_DirIdx][1]

        ; Binary search to find wall
        Local $l_f_MinDist = 0
        Local $l_f_MaxDist = $GC_F_WALL_DETECTION_RADIUS
        Local $l_f_WallDist = $l_f_MaxDist

        While $l_f_MaxDist - $l_f_MinDist > 50
            Local $l_f_MidDist = ($l_f_MinDist + $l_f_MaxDist) / 2
            Local $l_f_CheckX = $a_f_X + $l_f_DirX * $l_f_MidDist
            Local $l_f_CheckY = $a_f_Y + $l_f_DirY * $l_f_MidDist

            If Pathfinding_ValidatePoint($l_f_CheckX, $l_f_CheckY, $a_i_Z) Then
                $l_f_MinDist = $l_f_MidDist
            Else
                $l_f_MaxDist = $l_f_MidDist
                $l_f_WallDist = $l_f_MidDist
            EndIf
        WEnd

        ; If a wall is close, add repulsion
        If $l_f_WallDist < $GC_F_MIN_WALL_DISTANCE Then
            Local $l_f_Strength = ($GC_F_MIN_WALL_DISTANCE - $l_f_WallDist) / $GC_F_MIN_WALL_DISTANCE
            $l_f_RepulsionX -= $l_f_DirX * $l_f_Strength * ($GC_F_MIN_WALL_DISTANCE - $l_f_WallDist)
            $l_f_RepulsionY -= $l_f_DirY * $l_f_Strength * ($GC_F_MIN_WALL_DISTANCE - $l_f_WallDist)
            $l_i_WallCount += 1
        EndIf
    Next

    ; Normalize if necessary
    If $l_i_WallCount > 0 Then
        Local $l_f_Magnitude = Sqrt($l_f_RepulsionX * $l_f_RepulsionX + $l_f_RepulsionY * $l_f_RepulsionY)
        If $l_f_Magnitude > $GC_F_MAX_WALL_DISTANCE Then
            $l_f_RepulsionX = ($l_f_RepulsionX / $l_f_Magnitude) * $GC_F_MAX_WALL_DISTANCE
            $l_f_RepulsionY = ($l_f_RepulsionY / $l_f_Magnitude) * $GC_F_MAX_WALL_DISTANCE
        EndIf
    EndIf

    Local $l_af_Result[2] = [$l_f_RepulsionX, $l_f_RepulsionY]
    Return $l_af_Result
EndFunc

; ============================================================================
; Fast line of sight check
; ============================================================================
Func Pathfinding_CheckLineOfSight(ByRef $a_af_Point1, ByRef $a_af_Point2)
    If $a_af_Point1[2] <> $a_af_Point2[2] Then Return False

    Local $l_f_X1 = $a_af_Point1[0]
    Local $l_f_Y1 = $a_af_Point1[1]
    Local $l_f_X2 = $a_af_Point2[0]
    Local $l_f_Y2 = $a_af_Point2[1]
    Local $l_i_Layer = $a_af_Point1[2]

    ; Use fewer samples for speed
    Local $l_f_Dist = Pathfinding_GetDistance($l_f_X1, $l_f_Y1, $l_f_X2, $l_f_Y2)
    Local $l_i_Samples = _Min(15, _Max(3, Int($l_f_Dist / 400)))

    For $l_i_SampleIdx = 1 To $l_i_Samples - 1
        Local $l_f_T = $l_i_SampleIdx / $l_i_Samples
        Local $l_f_X = $l_f_X1 + ($l_f_X2 - $l_f_X1) * $l_f_T
        Local $l_f_Y = $l_f_Y1 + ($l_f_Y2 - $l_f_Y1) * $l_f_T

        If Not Pathfinding_ValidatePoint($l_f_X, $l_f_Y, $l_i_Layer) Then
            Return False
        EndIf
    Next

    Return True
EndFunc

; ============================================================================
; Path smoothing
; ============================================================================
Func Pathfinding_SmoothPath(ByRef $a_af2_Path)
    If UBound($a_af2_Path) <= 3 Then Return $a_af2_Path

    Local $l_af2_Smoothed[0][3]

    ; Keep the first point (start)
    _ArrayAdd($l_af2_Smoothed, $a_af2_Path[0][0] & "|" & $a_af2_Path[0][1] & "|" & $a_af2_Path[0][2])

    ; Apply simple smoothing (but NOT on the last point)
    For $l_i_Idx = 1 To UBound($a_af2_Path) - 2
        Local $l_f_PrevX = $a_af2_Path[$l_i_Idx-1][0]
        Local $l_f_PrevY = $a_af2_Path[$l_i_Idx-1][1]
        Local $l_f_CurrX = $a_af2_Path[$l_i_Idx][0]
        Local $l_f_CurrY = $a_af2_Path[$l_i_Idx][1]
        Local $l_f_NextX = $a_af2_Path[$l_i_Idx+1][0]
        Local $l_f_NextY = $a_af2_Path[$l_i_Idx+1][1]
        Local $l_i_Z = $a_af2_Path[$l_i_Idx][2]

        ; Simple weighted average
        Local $l_f_SmoothX = $l_f_CurrX * 0.6 + $l_f_PrevX * 0.2 + $l_f_NextX * 0.2
        Local $l_f_SmoothY = $l_f_CurrY * 0.6 + $l_f_PrevY * 0.2 + $l_f_NextY * 0.2

        ; Quickly check validity
        If Pathfinding_ValidatePoint($l_f_SmoothX, $l_f_SmoothY, $l_i_Z) Then
            _ArrayAdd($l_af2_Smoothed, $l_f_SmoothX & "|" & $l_f_SmoothY & "|" & $l_i_Z)
        Else
            _ArrayAdd($l_af2_Smoothed, $l_f_CurrX & "|" & $l_f_CurrY & "|" & $l_i_Z)
        EndIf
    Next

    ; IMPORTANT: Always keep the exact last point (destination)
    Local $l_i_LastIdx = UBound($a_af2_Path) - 1
    _ArrayAdd($l_af2_Smoothed, $a_af2_Path[$l_i_LastIdx][0] & "|" & $a_af2_Path[$l_i_LastIdx][1] & "|" & $a_af2_Path[$l_i_LastIdx][2])

    Return $l_af2_Smoothed
EndFunc

; ============================================================================
; Calculate path length
; ============================================================================
Func Pathfinding_CalculatePathLength(ByRef $a_af2_Path)
    Local $l_f_TotalLength = 0
    For $l_i_Idx = 1 To UBound($a_af2_Path) - 1
        $l_f_TotalLength += Pathfinding_GetDistance($a_af2_Path[$l_i_Idx-1][0], $a_af2_Path[$l_i_Idx-1][1], _
                                       $a_af2_Path[$l_i_Idx][0], $a_af2_Path[$l_i_Idx][1])
    Next
    Return $l_f_TotalLength
EndFunc

Func Pathfinding_GetPathCoords($a_i_MapID, $a_f_FromX, $a_f_FromY, $a_f_ToX, $a_f_ToY, $a_f_Aggressivity = 0.5)
    Local $l_s_DataFile = $a_i_MapID & "_*.gwau3"
    Local $l_as_Files = _FileListToArray(@ScriptDir, $l_s_DataFile, 1) ; 1 = files only

    If @error Or Not IsArray($l_as_Files) Or $l_as_Files[0] = 0 Then
        $l_as_Files = _FileListToArray(@ScriptDir & "\..\..\API\Pathfinding\", $l_s_DataFile, 1)
        If @error Or Not IsArray($l_as_Files) Or $l_as_Files[0] = 0 Then
            Return False
        EndIf
        $l_s_DataFile = @ScriptDir & "\..\..\API\Pathfinding\" & $l_as_Files[1]
    Else
        $l_s_DataFile = @ScriptDir & "\" & $l_as_Files[1]
    EndIf

    If Not Pathfinding_LoadData($l_s_DataFile) Then
        Return False
    EndIf

    Local $l_ab_BlockedLayers[256]
    For $l_i_Idx = 0 To 255
        $l_ab_BlockedLayers[$l_i_Idx] = False
    Next

    Local $l_af2_OriginalPath = Pathfinding_CalculatePath($a_f_FromX, $a_f_FromY, 0, $a_f_ToX, $a_f_ToY, 0, $l_ab_BlockedLayers)
    Local $l_af2_OptimizedPath = Pathfinding_OptimizePath($l_af2_OriginalPath, $a_f_Aggressivity)

    Return $l_af2_OptimizedPath
EndFunc