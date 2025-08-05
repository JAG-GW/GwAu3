#include-once

; ===============================================================
; Global Variables
; ===============================================================
Global $g_a_PathingTrapezoids[1]    ; Array of SimplePT structures
Global $g_a_PathingAABBs[1]         ; Array of AABB structures
Global $g_a_PathingPortals[1]       ; Array of Portal structures
Global $g_a_PathingPoints[1]        ; Array of Point structures
Global $g_a_PathingVisGraph[1]      ; Visibility graph
Global $g_a_PathingAABBGraph[1]     ; AABB connectivity graph
Global $g_a_PathingPTPortalGraph[1] ; Portal graph by trapezoid
Global $g_b_PathingInitialized = False
Global $g_a_PathingTeleports[1]     ; Teleports array
Global $g_a_TeleportGraph[1]        ; Teleport connectivity
Global Const $GC_F_MAX_VISIBILITY_RANGE = 2500.0  ; Reduced from 5000.0 for performance
Global $g_b_UseVisibilityGraph = True  ; Can be set to False to skip visibility graph generation

; ===============================================================
; Error Codes
; ===============================================================
Global Enum $PATHING_ERROR_OK = 0, _
    $PATHING_ERROR_UNKNOWN, _
    $PATHING_ERROR_FAILED_TO_FIND_GOAL_BOX, _
    $PATHING_ERROR_FAILED_TO_FIND_START_BOX, _
    $PATHING_ERROR_FAILED_TO_FINALIZE_PATH, _
    $PATHING_ERROR_INVALID_MAP_CONTEXT, _
    $PATHING_ERROR_BUILD_PATH_LENGTH_EXCEEDED, _
    $PATHING_ERROR_FAILED_TO_GET_PATHING_MAP_BLOCK

; ===============================================================
; Data Structures
; ===============================================================

; SimplePT structure: [id, layer, a.x, a.y, b.x, b.y, c.x, c.y, d.x, d.y]
Func PathFinding_CreateSimplePT($a_p_Trapezoid, $a_i_Layer)
    Local $l_a_PT[10]
    $l_a_PT[0] = Map_GetTrapezoidInfo($a_p_Trapezoid, "ID")
    $l_a_PT[1] = $a_i_Layer
    $l_a_PT[2] = Map_GetTrapezoidInfo($a_p_Trapezoid, "XTL") ; a.x
    $l_a_PT[3] = Map_GetTrapezoidInfo($a_p_Trapezoid, "YT")  ; a.y
    $l_a_PT[4] = Map_GetTrapezoidInfo($a_p_Trapezoid, "XBL") ; b.x
    $l_a_PT[5] = Map_GetTrapezoidInfo($a_p_Trapezoid, "YB")  ; b.y
    $l_a_PT[6] = Map_GetTrapezoidInfo($a_p_Trapezoid, "XBR") ; c.x
    $l_a_PT[7] = Map_GetTrapezoidInfo($a_p_Trapezoid, "YB")  ; c.y
    $l_a_PT[8] = Map_GetTrapezoidInfo($a_p_Trapezoid, "XTR") ; d.x
    $l_a_PT[9] = Map_GetTrapezoidInfo($a_p_Trapezoid, "YT")  ; d.y
    Return $l_a_PT
EndFunc

; AABB structure: [id, pos.x, pos.y, half.x, half.y, trapezoid_index]
Func PathFinding_CreateAABB($a_a_SimplePT, $a_i_TrapezoidIndex)
    Local $l_a_AABB[6]
    Local $l_f_MinX = _Min($a_a_SimplePT[4], $a_a_SimplePT[2])
    Local $l_f_MaxX = _Max($a_a_SimplePT[6], $a_a_SimplePT[8])
    $l_a_AABB[0] = 0 ; id (set later)
    $l_a_AABB[1] = ($l_f_MinX + $l_f_MaxX) / 2                ; pos.x
    $l_a_AABB[2] = ($a_a_SimplePT[3] + $a_a_SimplePT[5]) / 2  ; pos.y
    $l_a_AABB[3] = ($l_f_MaxX - $l_f_MinX) / 2                ; half.x
    $l_a_AABB[4] = ($a_a_SimplePT[3] - $a_a_SimplePT[5]) / 2  ; half.y
    $l_a_AABB[5] = $a_i_TrapezoidIndex                         ; reference to trapezoid
    Return $l_a_AABB
EndFunc

; Portal structure: [start.x, start.y, goal.x, goal.y, box1_id, box2_id]
Func PathFinding_CreatePortal($a_f_StartX, $a_f_StartY, $a_f_GoalX, $a_f_GoalY, $a_i_Box1ID, $a_i_Box2ID)
    Local $l_a_Portal[6]
    $l_a_Portal[0] = $a_f_StartX
    $l_a_Portal[1] = $a_f_StartY
    $l_a_Portal[2] = $a_f_GoalX
    $l_a_Portal[3] = $a_f_GoalY
    $l_a_Portal[4] = $a_i_Box1ID
    $l_a_Portal[5] = $a_i_Box2ID
    Return $l_a_Portal
EndFunc

; Point structure: [id, pos.x, pos.y, box_id, box2_id, portal_id]
Func PathFinding_CreatePoint($a_i_ID = 0, $a_f_X = 0, $a_f_Y = 0, $a_i_BoxID = -1, $a_i_Box2ID = -1, $a_i_PortalID = -1)
    Local $l_a_Point[6]
    $l_a_Point[0] = $a_i_ID
    $l_a_Point[1] = $a_f_X
    $l_a_Point[2] = $a_f_Y
    $l_a_Point[3] = $a_i_BoxID
    $l_a_Point[4] = $a_i_Box2ID
    $l_a_Point[5] = $a_i_PortalID
    Return $l_a_Point
EndFunc

; ===============================================================
; Initialization
; ===============================================================
Func PathFinding_Initialize()
    Log_Info("=== Starting PathFinding initialization ===", "PathFinding", $g_h_EditText)

    If $g_b_PathingInitialized Then
        Log_Warning("PathFinding already initialized", "PathFinding", $g_h_EditText)
        Return True
    EndIf

    ; Load map specific data
    PathFinding_LoadMapSpecificData()

    ; Generate AABBs
    If Not PathFinding_GenerateAABBs() Then
        Log_Error("Failed to generate AABBs", "PathFinding", $g_h_EditText)
        Return False
    EndIf

    ; Generate AABB Graph
    If Not PathFinding_GenerateAABBGraph() Then
        Log_Error("Failed to generate AABB graph", "PathFinding", $g_h_EditText)
        Return False
    EndIf

    ; Generate Points
    PathFinding_GeneratePoints()

    ; Generate Visibility Graph (optional - can be slow)
    If $g_b_UseVisibilityGraph Then
        PathFinding_GenerateVisibilityGraph()
    Else
        Log_Info("Skipping visibility graph generation (disabled)", "PathFinding", $g_h_EditText)
        ; Initialize empty visibility graph
        ReDim $g_a_PathingVisGraph[$g_a_PathingPoints[0] + $g_a_PathingTeleports[0] * 2 + 3]
        For $i = 0 To UBound($g_a_PathingVisGraph) - 1
            $g_a_PathingVisGraph[$i] = ""
        Next
    EndIf

    ; Generate Teleport Graph
    PathFinding_GenerateTeleportGraph()

    ; Insert Teleports into Visibility Graph
    PathFinding_InsertTeleportsIntoVisibilityGraph()

    $g_b_PathingInitialized = True
    Log_Info("=== PathFinding initialization complete ===", "PathFinding", $g_h_EditText)
    Return True
EndFunc

Func PathFinding_LoadMapSpecificData()
    Log_Info("Loading map specific data...", "PathFinding", $g_h_EditText)

    ; Clear teleports array
    ReDim $g_a_PathingTeleports[1]
    $g_a_PathingTeleports[0] = 0

    ; Get current map ID
    Local $l_i_MapID = Map_GetMapID()

    ; Load teleports based on map ID (following MapSpecificData.h)
    Switch $l_i_MapID
        Case 122 ; Salt Flats
            PathFinding_AddTeleport(-14614.0, -1161.0, 11, -18387.0, 214.0, 4, True)
            PathFinding_AddTeleport(-1438.0, 7532.0, 54, -3299.0, 3869.0, 55, True)
            PathFinding_AddTeleport(14437.0, 19515.0, 23, 10846.0, 18889.0, 24, True)

        Case 120 ; Prophet's Path
            PathFinding_AddTeleport(-6828.0, -10891.0, 9, -4630.0, -7482.0, 8, True)
            PathFinding_AddTeleport(6465.0, -782.0, 6, 2315.0, -1533.0, 7, True)
            PathFinding_AddTeleport(-8113.0, 9181.0, 11, -5077.0, 6024.0, 5, True)
            PathFinding_AddTeleport(9929.0, 14956.0, 13, 6330.0, 13056.0, 4, True)

        Case 199, 224, 225 ; Isle of Jade variants
            PathFinding_AddTeleport(6796.0, 735.0, 12, 2465.0, 803.0, 28, True)
            PathFinding_AddTeleport(-3710.0, 674.0, 5, 596.0, 709.0, 26, True)
    EndSwitch

    Log_Info("Loaded " & $g_a_PathingTeleports[0] & " teleports", "PathFinding", $g_h_EditText)
EndFunc

Func PathFinding_AddTeleport($a_f_EnterX, $a_f_EnterY, $a_i_EnterZ, $a_f_ExitX, $a_f_ExitY, $a_i_ExitZ, $a_b_BothWays)
    Local $l_i_Index = $g_a_PathingTeleports[0] + 1
    ReDim $g_a_PathingTeleports[$l_i_Index + 1]

    ; Teleport structure: [enter.x, enter.y, enter.z, exit.x, exit.y, exit.z, both_ways]
    Local $l_a_Teleport[7]
    $l_a_Teleport[0] = $a_f_EnterX
    $l_a_Teleport[1] = $a_f_EnterY
    $l_a_Teleport[2] = $a_i_EnterZ
    $l_a_Teleport[3] = $a_f_ExitX
    $l_a_Teleport[4] = $a_f_ExitY
    $l_a_Teleport[5] = $a_i_ExitZ
    $l_a_Teleport[6] = $a_b_BothWays

    $g_a_PathingTeleports[$l_i_Index] = $l_a_Teleport
    $g_a_PathingTeleports[0] = $l_i_Index
EndFunc

Func PathFinding_GenerateAABBs()
    Log_Info("Generating AABBs...", "PathFinding", $g_h_EditText)

    Local $l_p_ArrayBuffer = Map_GetPathingMapArrayInfo("Buffer")
    Local $l_i_ArraySize = Map_GetPathingMapArrayInfo("Size")

    If $l_p_ArrayBuffer = 0 Then
        Log_Error("Failed to get PathingMapArray buffer", "PathFinding", $g_h_EditText)
        Return False
    EndIf

    ; Clear arrays
    ReDim $g_a_PathingTrapezoids[1]
    ReDim $g_a_PathingAABBs[1]
    $g_a_PathingTrapezoids[0] = 0
    $g_a_PathingAABBs[0] = 0

    Local $l_i_BridgeCount = 0
    Local $l_i_SkippedCount = 0

    If $l_i_ArraySize > 500 Then
        Log_Warning("PathingMapArray size is very large: " & $l_i_ArraySize & ", processing all layers", "PathFinding", $g_h_EditText)
    EndIf

    Local $l_i_MaxLayers = $l_i_ArraySize
    If $l_i_ArraySize > 100 Then
        Log_Info("Processing " & $l_i_ArraySize & " layers (may include bridges)", "PathFinding", $g_h_EditText)
    EndIf

    ; Process each pathing map layer
    For $i = 0 To $l_i_MaxLayers - 1
        Local $l_p_PathingMap = $l_p_ArrayBuffer + ($i * 0x54)
        Local $l_i_Count = Memory_Read($l_p_PathingMap + 0x14, "dword")
        Local $l_p_Trapezoids = Memory_Read($l_p_PathingMap + 0x18, "ptr")

        If $l_i_Count > 10000 Or $l_p_Trapezoids = 0 Then ContinueLoop

        ; Process trapezoids
        For $j = 0 To $l_i_Count - 1
            Local $l_p_Trapezoid = Map_GetTrapezoid($l_p_Trapezoids, $j)
            Local $l_f_YB = Map_GetTrapezoidInfo($l_p_Trapezoid, "YB")
            Local $l_f_YT = Map_GetTrapezoidInfo($l_p_Trapezoid, "YT")
            Local $l_f_XTL = Map_GetTrapezoidInfo($l_p_Trapezoid, "XTL")
            Local $l_f_XTR = Map_GetTrapezoidInfo($l_p_Trapezoid, "XTR")
            Local $l_f_XBL = Map_GetTrapezoidInfo($l_p_Trapezoid, "XBL")
            Local $l_f_XBR = Map_GetTrapezoidInfo($l_p_Trapezoid, "XBR")

            Local $l_f_Height = Abs($l_f_YT - $l_f_YB)
            Local $l_f_WidthTop = Abs($l_f_XTR - $l_f_XTL)
            Local $l_f_WidthBottom = Abs($l_f_XBR - $l_f_XBL)
            Local $l_f_MaxWidth = _Max($l_f_WidthTop, $l_f_WidthBottom)

            Local $l_b_IsBridge = False
            If $l_f_MaxWidth > 500 And $l_f_Height < 200 Then
                $l_b_IsBridge = True
                $l_i_BridgeCount += 1
            EndIf

            Local $l_f_HeightTolerance = 0.5
            If $l_b_IsBridge Then
                $l_f_HeightTolerance = 0.1
            EndIf

            If $l_f_Height < $l_f_HeightTolerance Then
                $l_i_SkippedCount += 1
                If $l_b_IsBridge Then
                    Log_Warning("Skipped potential bridge at layer " & $i & " (height=" & $l_f_Height & ")", "PathFinding", $g_h_EditText)
                EndIf
                ContinueLoop
            EndIf

            ; Create SimplePT
            Local $l_a_SimplePT = PathFinding_CreateSimplePT($l_p_Trapezoid, $i)

            Local $l_i_TrapIndex = $g_a_PathingTrapezoids[0] + 1
            ReDim $g_a_PathingTrapezoids[$l_i_TrapIndex + 1]
            $g_a_PathingTrapezoids[$l_i_TrapIndex] = $l_a_SimplePT
            $g_a_PathingTrapezoids[0] = $l_i_TrapIndex

            ; Create AABB
            Local $l_a_AABB = PathFinding_CreateAABB($l_a_SimplePT, $l_i_TrapIndex)
            $l_a_AABB[0] = $l_i_TrapIndex - 1 ; Set ID
            ReDim $g_a_PathingAABBs[$l_i_TrapIndex + 1]
            $g_a_PathingAABBs[$l_i_TrapIndex] = $l_a_AABB
            $g_a_PathingAABBs[0] = $l_i_TrapIndex
        Next
    Next

    ; Log statistics
    Log_Info("Bridge detection: " & $l_i_BridgeCount & " potential bridges found", "PathFinding", $g_h_EditText)
    Log_Info("Skipped " & $l_i_SkippedCount & " degenerate trapezoids", "PathFinding", $g_h_EditText)

    ; Check if we got any AABBs
    If $g_a_PathingAABBs[0] = 0 Then
        Log_Error("No valid AABBs generated!", "PathFinding", $g_h_EditText)
        Return False
    EndIf

    Log_Info("Generated " & $g_a_PathingAABBs[0] & " AABBs from " & $g_a_PathingTrapezoids[0] & " trapezoids", "PathFinding", $g_h_EditText)
    Return True
EndFunc

Func PathFinding_SortAABBsByY()
    ; Simple bubble sort for AABBs by Y coordinate (descending)
    For $i = 1 To $g_a_PathingAABBs[0] - 1
        For $j = $i + 1 To $g_a_PathingAABBs[0]
            Local $l_a_AABB_i = $g_a_PathingAABBs[$i]
            Local $l_a_AABB_j = $g_a_PathingAABBs[$j]

            If IsArray($l_a_AABB_i) And IsArray($l_a_AABB_j) Then
                If $l_a_AABB_i[2] - $l_a_AABB_i[4] < $l_a_AABB_j[2] - $l_a_AABB_j[4] Then
                    ; Swap
                    $g_a_PathingAABBs[$i] = $l_a_AABB_j
                    $g_a_PathingAABBs[$j] = $l_a_AABB_i
                EndIf
            EndIf
        Next
    Next

    ; Update IDs after sorting
    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_a_AABB = $g_a_PathingAABBs[$i]
        If IsArray($l_a_AABB) Then
            $l_a_AABB[0] = $i - 1
            $g_a_PathingAABBs[$i] = $l_a_AABB
        EndIf
    Next
EndFunc

Func PathFinding_GenerateAABBGraph()
    Log_Info("Generating AABB graph...", "PathFinding", $g_h_EditText)

    ; Initialize graph arrays
    ReDim $g_a_PathingAABBGraph[$g_a_PathingAABBs[0] + 1]

    ; Find maximum trapezoid ID to size the PTPortalGraph correctly
    Local $l_i_MaxTrapID = 0
    For $i = 1 To $g_a_PathingTrapezoids[0]
        Local $l_a_Trap = $g_a_PathingTrapezoids[$i]
        If IsArray($l_a_Trap) And $l_a_Trap[0] > $l_i_MaxTrapID Then
            $l_i_MaxTrapID = $l_a_Trap[0]
        EndIf
    Next

    ReDim $g_a_PathingPTPortalGraph[$l_i_MaxTrapID + 2]
    ReDim $g_a_PathingPortals[1]
    $g_a_PathingPortals[0] = 0

    For $i = 1 To $g_a_PathingAABBs[0]
        $g_a_PathingAABBGraph[$i] = ""
    Next

    For $i = 0 To UBound($g_a_PathingPTPortalGraph) - 1
        $g_a_PathingPTPortalGraph[$i] = ""
    Next

    ; Check connections between AABBs
    For $i = 1 To $g_a_PathingAABBs[0] - 1
        For $j = $i + 1 To $g_a_PathingAABBs[0]
            ; Coarse intersection check
            If Not PathFinding_AABBIntersect($i, $j, 1.0) Then ContinueLoop

            ; Fine intersection check
            Local $l_e_TouchingSide = PathFinding_CheckTouching($i, $j)
            If $l_e_TouchingSide <> 0 Then
                If PathFinding_CreatePortalBetween($i, $j, $l_e_TouchingSide) Then
                    ; Add to AABB graph
                    PathFinding_AddAABBConnection($i, $j)
                EndIf
            EndIf
        Next
    Next

    Log_Info("Generated " & $g_a_PathingPortals[0] & " portals", "PathFinding", $g_h_EditText)
    Return True
EndFunc

Func PathFinding_GeneratePoints()
    Log_Info("Generating points...", "PathFinding", $g_h_EditText)

    ReDim $g_a_PathingPoints[1]
    $g_a_PathingPoints[0] = 0

    ; Distance minimale entre points de différents portals
    Local Const $MIN_POINT_DISTANCE = 500.0  ; La moitié de 500 pour avoir une marge
    Local Const $MIN_POINT_DISTANCE_SQ = $MIN_POINT_DISTANCE * $MIN_POINT_DISTANCE

    ; Create points from portals
    For $i = 1 To $g_a_PathingPortals[0]
        Local $l_a_Portal = $g_a_PathingPortals[$i]
        If Not IsArray($l_a_Portal) Then ContinueLoop

        ; Calculate portal length
        Local $l_f_PortalLength = PathFinding_Distance2D($l_a_Portal[0], $l_a_Portal[1], $l_a_Portal[2], $l_a_Portal[3])

        ; Tableau temporaire pour stocker les points candidats du portal
        Local $l_a_CandidatePoints[1][3] ; [x, y, t]
        $l_a_CandidatePoints[0][0] = 0

        ; Générer les points candidats
        If $l_f_PortalLength <= 1000 Then
            ; Portal court : juste un point au milieu
            ReDim $l_a_CandidatePoints[2][3]
            $l_a_CandidatePoints[1][0] = ($l_a_Portal[0] + $l_a_Portal[2]) / 2
            $l_a_CandidatePoints[1][1] = ($l_a_Portal[1] + $l_a_Portal[3]) / 2
            $l_a_CandidatePoints[1][2] = 0.5
            $l_a_CandidatePoints[0][0] = 1
        Else
            ; Portal long : points espacés d'environ 500
            Local $l_i_NumSegments = Round($l_f_PortalLength / 500)
            If $l_i_NumSegments < 2 Then $l_i_NumSegments = 2
            If $l_i_NumSegments > 10 Then $l_i_NumSegments = 10  ; Limiter le nombre de points par portal

            ReDim $l_a_CandidatePoints[$l_i_NumSegments + 1][3]
            $l_a_CandidatePoints[0][0] = $l_i_NumSegments

            For $j = 0 To $l_i_NumSegments - 1
                Local $l_f_T = ($j + 0.5) / $l_i_NumSegments
                $l_a_CandidatePoints[$j + 1][0] = $l_a_Portal[0] + ($l_a_Portal[2] - $l_a_Portal[0]) * $l_f_T
                $l_a_CandidatePoints[$j + 1][1] = $l_a_Portal[1] + ($l_a_Portal[3] - $l_a_Portal[1]) * $l_f_T
                $l_a_CandidatePoints[$j + 1][2] = $l_f_T
            Next
        EndIf

        ; Filtrer les points trop proches des points existants
        Local $l_i_AddedPoints = 0
        For $j = 1 To $l_a_CandidatePoints[0][0]
            Local $l_f_CandX = $l_a_CandidatePoints[$j][0]
            Local $l_f_CandY = $l_a_CandidatePoints[$j][1]
            Local $l_b_TooClose = False

            ; Vérifier la distance avec tous les points existants
            For $k = 1 To $g_a_PathingPoints[0]
                Local $l_a_ExistingPoint = $g_a_PathingPoints[$k]
                If Not IsArray($l_a_ExistingPoint) Then ContinueLoop

                Local $l_f_DistSq = PathFinding_GetSquareDistance($l_f_CandX, $l_f_CandY, $l_a_ExistingPoint[1], $l_a_ExistingPoint[2])

                If $l_f_DistSq < $MIN_POINT_DISTANCE_SQ Then
                    $l_b_TooClose = True
                    ExitLoop
                EndIf
            Next

            ; Si le point n'est pas trop proche, l'ajouter
            If Not $l_b_TooClose Then
                Local $l_i_PointID = $g_a_PathingPoints[0]
                Local $l_a_Point = PathFinding_CreatePoint($l_i_PointID, $l_f_CandX, $l_f_CandY, $l_a_Portal[4], $l_a_Portal[5], $i - 1)  ; Portal ID est 0-based
                PathFinding_AddPoint($l_a_Point)
                $l_i_AddedPoints += 1
            EndIf
        Next

        ; Si aucun point n'a été ajouté et que c'est un portal important, forcer au moins un point
        If $l_i_AddedPoints = 0 And $l_f_PortalLength > 100 Then
            ; Essayer de trouver le meilleur emplacement
            Local $l_i_BestIndex = -1
            Local $l_f_BestMinDist = 0

            For $j = 1 To $l_a_CandidatePoints[0][0]
                Local $l_f_CandX = $l_a_CandidatePoints[$j][0]
                Local $l_f_CandY = $l_a_CandidatePoints[$j][1]
                Local $l_f_MinDist = 999999

                ; Trouver la distance au point le plus proche
                For $k = 1 To $g_a_PathingPoints[0]
                    Local $l_a_ExistingPoint = $g_a_PathingPoints[$k]
                    If Not IsArray($l_a_ExistingPoint) Then ContinueLoop

                    Local $l_f_DistSq = PathFinding_GetSquareDistance($l_f_CandX, $l_f_CandY, $l_a_ExistingPoint[1], $l_a_ExistingPoint[2])
                    If $l_f_DistSq < $l_f_MinDist Then
                        $l_f_MinDist = $l_f_DistSq
                    EndIf
                Next

                If $l_f_MinDist > $l_f_BestMinDist Then
                    $l_f_BestMinDist = $l_f_MinDist
                    $l_i_BestIndex = $j
                EndIf
            Next

            ; Ajouter le point le plus éloigné des autres
            If $l_i_BestIndex > 0 Then
                Local $l_f_X = $l_a_CandidatePoints[$l_i_BestIndex][0]
                Local $l_f_Y = $l_a_CandidatePoints[$l_i_BestIndex][1]
                Local $l_i_PointID = $g_a_PathingPoints[0]
                Local $l_a_Point = PathFinding_CreatePoint($l_i_PointID, $l_f_X, $l_f_Y, $l_a_Portal[4], $l_a_Portal[5], $i - 1)
                PathFinding_AddPoint($l_a_Point)
                $l_i_AddedPoints = 1
            EndIf
        EndIf
    Next

    ; Sort points by Y coordinate (descending)
    PathFinding_SortPointsByY()

    ; Vérifier et corriger les portails sans points
    Local $l_i_PortalsWithoutPoints = 0
    For $i = 1 To $g_a_PathingPortals[0]
        Local $l_b_HasPoint = False

        For $j = 1 To $g_a_PathingPoints[0]
            Local $l_a_Point = $g_a_PathingPoints[$j]
            If IsArray($l_a_Point) And $l_a_Point[5] = $i - 1 Then  ; Portal ID est 0-based
                $l_b_HasPoint = True
                ExitLoop
            EndIf
        Next

        If Not $l_b_HasPoint Then
            ; Forcer l'ajout d'un point au centre du portal
            Local $l_a_Portal = $g_a_PathingPortals[$i]
            If IsArray($l_a_Portal) Then
                Local $l_f_X = ($l_a_Portal[0] + $l_a_Portal[2]) / 2
                Local $l_f_Y = ($l_a_Portal[1] + $l_a_Portal[3]) / 2
                Local $l_i_PointID = $g_a_PathingPoints[0]
                Local $l_a_Point = PathFinding_CreatePoint($l_i_PointID, $l_f_X, $l_f_Y, $l_a_Portal[4], $l_a_Portal[5], $i - 1)
                PathFinding_AddPoint($l_a_Point)
                $l_i_PortalsWithoutPoints += 1
            EndIf
        EndIf
    Next

    If $l_i_PortalsWithoutPoints > 0 Then
        Log_Info("Added " & $l_i_PortalsWithoutPoints & " points to portals without points", "PathFinding", $g_h_EditText)

        ; Re-trier après avoir ajouté des points supplémentaires
        PathFinding_SortPointsByY()
    EndIf

    ; Vérifier les AABBs sans points d'accès
    Local $l_i_AABBsWithoutPoints = 0
    Local $l_a_AABBHasPoint[$g_a_PathingAABBs[0] + 1]

    ; Initialiser le tableau
    For $i = 0 To $g_a_PathingAABBs[0]
        $l_a_AABBHasPoint[$i] = False
    Next

    ; Marquer les AABBs qui ont des points
    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_Point = $g_a_PathingPoints[$i]
        If IsArray($l_a_Point) Then
            If $l_a_Point[3] >= 0 And $l_a_Point[3] <= $g_a_PathingAABBs[0] Then
                $l_a_AABBHasPoint[$l_a_Point[3]] = True
            EndIf
            If $l_a_Point[4] >= 0 And $l_a_Point[4] <= $g_a_PathingAABBs[0] Then
                $l_a_AABBHasPoint[$l_a_Point[4]] = True
            EndIf
        EndIf
    Next

    ; Ajouter des points aux AABBs isolés qui ont des connexions
    For $i = 0 To $g_a_PathingAABBs[0] - 1
        If Not $l_a_AABBHasPoint[$i] Then
            ; Vérifier si cet AABB a des connexions
            If $i + 1 <= UBound($g_a_PathingAABBGraph) - 1 And $g_a_PathingAABBGraph[$i + 1] <> "" Then
                ; Ajouter un point au centre de l'AABB
                Local $l_a_AABB = $g_a_PathingAABBs[$i + 1]
                If IsArray($l_a_AABB) Then
                    Local $l_i_PointID = $g_a_PathingPoints[0]
                    Local $l_a_Point = PathFinding_CreatePoint($l_i_PointID, $l_a_AABB[1], $l_a_AABB[2], $i, -1, -1)
                    PathFinding_AddPoint($l_a_Point)
                    $l_i_AABBsWithoutPoints += 1
                EndIf
            EndIf
        EndIf
    Next

    If $l_i_AABBsWithoutPoints > 0 Then
        Log_Info("Added " & $l_i_AABBsWithoutPoints & " points to isolated AABBs", "PathFinding", $g_h_EditText)

        ; Re-trier après avoir ajouté des points supplémentaires
        PathFinding_SortPointsByY()
    EndIf

    Log_Info("Generated " & $g_a_PathingPoints[0] & " points total", "PathFinding", $g_h_EditText)

    ; Statistiques finales
    Local $l_i_PointsPerPortal[1]
    ReDim $l_i_PointsPerPortal[$g_a_PathingPortals[0] + 1]
    For $i = 0 To $g_a_PathingPortals[0]
        $l_i_PointsPerPortal[$i] = 0
    Next

    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_Point = $g_a_PathingPoints[$i]
        If IsArray($l_a_Point) And $l_a_Point[5] >= 0 And $l_a_Point[5] < $g_a_PathingPortals[0] Then
            $l_i_PointsPerPortal[$l_a_Point[5] + 1] += 1
        EndIf
    Next

    Local $l_i_MinPoints = 999
    Local $l_i_MaxPoints = 0
    Local $l_i_TotalPortalPoints = 0
    Local $l_i_PortalsWithPoints = 0

    For $i = 1 To $g_a_PathingPortals[0]
        If $l_i_PointsPerPortal[$i] > 0 Then
            $l_i_PortalsWithPoints += 1
            $l_i_TotalPortalPoints += $l_i_PointsPerPortal[$i]
            If $l_i_PointsPerPortal[$i] < $l_i_MinPoints Then $l_i_MinPoints = $l_i_PointsPerPortal[$i]
            If $l_i_PointsPerPortal[$i] > $l_i_MaxPoints Then $l_i_MaxPoints = $l_i_PointsPerPortal[$i]
        EndIf
    Next

    If $l_i_PortalsWithPoints > 0 Then
        Log_Debug("Portal coverage: " & $l_i_PortalsWithPoints & "/" & $g_a_PathingPortals[0] & " portals have points", "PathFinding", $g_h_EditText)
        Log_Debug("Points per portal: Min=" & $l_i_MinPoints & ", Max=" & $l_i_MaxPoints & ", Avg=" & Round($l_i_TotalPortalPoints / $l_i_PortalsWithPoints, 2), "PathFinding", $g_h_EditText)
    EndIf
EndFunc

Func PathFinding_AddPoint($a_a_Point)
    Local $l_i_Index = $g_a_PathingPoints[0] + 1
    ReDim $g_a_PathingPoints[$l_i_Index + 1]
    $g_a_PathingPoints[$l_i_Index] = $a_a_Point
    $g_a_PathingPoints[0] = $l_i_Index
EndFunc

Func PathFinding_SortPointsByY()
    ; Simple bubble sort for points by Y coordinate (descending)
    For $i = 1 To $g_a_PathingPoints[0] - 1
        For $j = $i + 1 To $g_a_PathingPoints[0]
            Local $l_a_Point_i = $g_a_PathingPoints[$i]
            Local $l_a_Point_j = $g_a_PathingPoints[$j]

            If IsArray($l_a_Point_i) And IsArray($l_a_Point_j) Then
                If $l_a_Point_i[2] < $l_a_Point_j[2] Then
                    ; Swap
                    $g_a_PathingPoints[$i] = $l_a_Point_j
                    $g_a_PathingPoints[$j] = $l_a_Point_i
                EndIf
            EndIf
        Next
    Next

    ; Update IDs after sorting
    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_Point = $g_a_PathingPoints[$i]
        If IsArray($l_a_Point) Then
            $l_a_Point[0] = $i - 1
            $g_a_PathingPoints[$i] = $l_a_Point
        EndIf
    Next
EndFunc

Func PathFinding_GenerateVisibilityGraph()
    Log_Info("Generating visibility graph...", "PathFinding", $g_h_EditText)

    ; Initialize visibility graph - ensure it's large enough for temp points
    Local $l_i_VisGraphSize = $g_a_PathingPoints[0] + $g_a_PathingTeleports[0] * 2 + 3
    ReDim $g_a_PathingVisGraph[$l_i_VisGraphSize]

    For $i = 0 To UBound($g_a_PathingVisGraph) - 1
        $g_a_PathingVisGraph[$i] = ""
    Next

    If Not $g_b_UseVisibilityGraph Then
        Log_Info("Visibility graph generation disabled - using portal connections only", "PathFinding", $g_h_EditText)

        ; At minimum, connect portal endpoints that share the same portal
        For $i = 1 To $g_a_PathingPortals[0]
            Local $l_a_Portal = $g_a_PathingPortals[$i]

            ; Find points for this portal
            Local $l_i_Point1 = -1, $l_i_Point2 = -1

            For $j = 1 To $g_a_PathingPoints[0]
                Local $l_a_Point = $g_a_PathingPoints[$j]
                If $l_a_Point[5] = $i Then ; Point belongs to this portal
                    If $l_i_Point1 = -1 Then
                        $l_i_Point1 = $l_a_Point[0]
                    ElseIf $l_i_Point2 = -1 Then
                        $l_i_Point2 = $l_a_Point[0]
                        ExitLoop
                    EndIf
                EndIf
            Next

            ; Connect the two points of the same portal
            If $l_i_Point1 >= 0 And $l_i_Point2 >= 0 Then
                Local $l_f_Distance = PathFinding_Distance2D($l_a_Portal[0], $l_a_Portal[1], $l_a_Portal[2], $l_a_Portal[3])
                Local $l_a_Empty[1]
                $l_a_Empty[0] = 0

                PathFinding_AddToVisGraph($l_i_Point1, $l_i_Point2, $l_f_Distance, $l_a_Empty)
                PathFinding_AddToVisGraph($l_i_Point2, $l_i_Point1, $l_f_Distance, $l_a_Empty)
            EndIf
        Next

        Return
    EndIf

    Local $l_f_SqRange = $GC_F_MAX_VISIBILITY_RANGE * $GC_F_MAX_VISIBILITY_RANGE
    Local $l_i_PointCount = $g_a_PathingPoints[0]
    Local $l_i_Connections = 0

    ; Check visibility between all point pairs
    For $i = 1 To $l_i_PointCount
        Local $l_a_P1 = $g_a_PathingPoints[$i]
        If Not IsArray($l_a_P1) Then ContinueLoop

        Local $l_f_MinRange = $l_a_P1[2] - $GC_F_MAX_VISIBILITY_RANGE
        Local $l_f_MaxRange = $l_a_P1[2] + $GC_F_MAX_VISIBILITY_RANGE

        ; Limit connections per point to reduce complexity
        Local $l_i_ConnectionsForThisPoint = 0
        Local $l_i_MaxConnectionsPerPoint = 50 ; Limit connections per point

        For $j = $i + 1 To $l_i_PointCount
            ; Skip if we already have enough connections for this point
            If $l_i_ConnectionsForThisPoint >= $l_i_MaxConnectionsPerPoint Then ExitLoop

            Local $l_a_P2 = $g_a_PathingPoints[$j]
            If Not IsArray($l_a_P2) Then ContinueLoop

            ; Range check
            If $l_f_MinRange > $l_a_P2[2] Or $l_f_MaxRange < $l_a_P2[2] Then ContinueLoop

            ; Distance check
            Local $l_f_SqDist = PathFinding_GetSquareDistance($l_a_P1[1], $l_a_P1[2], $l_a_P2[1], $l_a_P2[2])
            If $l_f_SqDist > $l_f_SqRange Then ContinueLoop

            ; Skip if points are from the same portal (optimization)
            If $l_a_P1[5] > -1 And $l_a_P1[5] = $l_a_P2[5] Then ContinueLoop

            ; Check if already connected
            If PathFinding_AlreadyInVisGraph($l_a_P1[0], $l_a_P2[0]) Then ContinueLoop

            ; Line of sight check - simplified for distant points
            Local $l_b_CheckLineOfSight = True
            If $l_f_SqDist > 1000000 Then ; If distance > 1000, do simplified check
                ; Only check if points are in connected AABBs
                If $l_a_P1[3] > -1 And $l_a_P2[3] > -1 Then
                    $l_b_CheckLineOfSight = PathFinding_AreAABBsConnected($l_a_P1[3], $l_a_P2[3])
                Else
                    $l_b_CheckLineOfSight = False
                EndIf
            EndIf

            If $l_b_CheckLineOfSight Then
                Local $l_a_BlockingIDs[1]
                $l_a_BlockingIDs[0] = 0

                If PathFinding_HasLineOfSight($l_a_P1, $l_a_P2, $l_a_BlockingIDs) Then
                    Local $l_f_Distance = Sqrt($l_f_SqDist)
                    PathFinding_AddToVisGraph($l_a_P1[0], $l_a_P2[0], $l_f_Distance, $l_a_BlockingIDs)
                    PathFinding_AddToVisGraph($l_a_P2[0], $l_a_P1[0], $l_f_Distance, $l_a_BlockingIDs)
                    $l_i_Connections += 1
                    $l_i_ConnectionsForThisPoint += 1
                EndIf
            EndIf
        Next
    Next

    Log_Info("Visibility graph generated with " & $l_i_Connections & " connections", "PathFinding", $g_h_EditText)
EndFunc

; Helper function to check if two AABBs are connected
Func PathFinding_AreAABBsConnected($a_i_AABB1, $a_i_AABB2, $a_i_MaxDepth = 3)
    If $a_i_AABB1 = $a_i_AABB2 Then Return True

    ; Quick check direct connection
    If $a_i_AABB1 >= 0 And $a_i_AABB1 < UBound($g_a_PathingAABBGraph) Then
        Local $l_s_Connections = $g_a_PathingAABBGraph[$a_i_AABB1 + 1]
        If $l_s_Connections <> "" Then
            Local $l_a_Connected = StringSplit($l_s_Connections, ",", 2)
            For $i = 0 To UBound($l_a_Connected) - 1
                If Int($l_a_Connected[$i]) = $a_i_AABB2 Then Return True
            Next
        EndIf
    EndIf

    ; For distant AABBs, don't do deep search
    Return False
EndFunc

Func PathFinding_GenerateTeleportGraph()
    If $g_a_PathingTeleports[0] = 0 Then Return

    Log_Info("Generating teleport graph...", "PathFinding", $g_h_EditText)

    ReDim $g_a_TeleportGraph[1]
    $g_a_TeleportGraph[0] = 0

    ; Calculate distances between all teleport pairs
    For $i = 1 To $g_a_PathingTeleports[0]
        Local $l_a_TP1 = $g_a_PathingTeleports[$i]

        For $j = $i To $g_a_PathingTeleports[0]
            Local $l_a_TP2 = $g_a_PathingTeleports[$j]

            If $l_a_TP1[6] And $l_a_TP2[6] Then ; Both bidirectional
                ; Calculate all 4 possible distances
                Local $l_f_Dist1 = PathFinding_Distance2D($l_a_TP1[0], $l_a_TP1[1], $l_a_TP2[3], $l_a_TP2[4])
                Local $l_f_Dist2 = PathFinding_Distance2D($l_a_TP1[3], $l_a_TP1[4], $l_a_TP2[0], $l_a_TP2[1])
                Local $l_f_Dist3 = PathFinding_Distance2D($l_a_TP1[3], $l_a_TP1[4], $l_a_TP2[3], $l_a_TP2[4])
                Local $l_f_Dist4 = PathFinding_Distance2D($l_a_TP1[0], $l_a_TP1[1], $l_a_TP2[0], $l_a_TP2[1])

                ; Find minimum distance manually
                Local $l_f_Dist = $l_f_Dist1
                If $l_f_Dist2 < $l_f_Dist Then $l_f_Dist = $l_f_Dist2
                If $l_f_Dist3 < $l_f_Dist Then $l_f_Dist = $l_f_Dist3
                If $l_f_Dist4 < $l_f_Dist Then $l_f_Dist = $l_f_Dist4

                PathFinding_AddTeleportNode($i, $j, $l_f_Dist)
                If $i <> $j Then PathFinding_AddTeleportNode($j, $i, $l_f_Dist)
            EndIf
        Next
    Next

    Log_Info("Teleport graph generated with " & $g_a_TeleportGraph[0] & " connections", "PathFinding", $g_h_EditText)
EndFunc

Func PathFinding_AddTeleportNode($a_i_TP1, $a_i_TP2, $a_f_Distance)
    Local $l_i_Index = $g_a_TeleportGraph[0] + 1
    ReDim $g_a_TeleportGraph[$l_i_Index + 1]

    ; Teleport node: [tp1_index, tp2_index, distance]
    Local $l_a_Node[3]
    $l_a_Node[0] = $a_i_TP1
    $l_a_Node[1] = $a_i_TP2
    $l_a_Node[2] = $a_f_Distance

    $g_a_TeleportGraph[$l_i_Index] = $l_a_Node
    $g_a_TeleportGraph[0] = $l_i_Index
EndFunc

Func PathFinding_InsertTeleportsIntoVisibilityGraph()
    If $g_a_PathingTeleports[0] = 0 Then Return

    Log_Info("Inserting teleports into visibility graph...", "PathFinding", $g_h_EditText)

    For $i = 1 To $g_a_PathingTeleports[0]
        Local $l_a_Teleport = $g_a_PathingTeleports[$i]

        ; Create enter point
        Local $l_a_GamePosEnter[3] = [$l_a_Teleport[0], $l_a_Teleport[1], $l_a_Teleport[2]]
        Local $l_a_PointEnter = PathFinding_CreatePointFromGamePos($l_a_GamePosEnter)
        $l_a_PointEnter[0] = $g_a_PathingPoints[0]
        PathFinding_AddPoint($l_a_PointEnter)

        Local $l_e_TypeEnter = $l_a_Teleport[6] ? 2 : 0 ; both : enter
        PathFinding_InsertTeleportPointIntoVisGraph($l_a_PointEnter, $l_e_TypeEnter)

        ; Create exit point
        Local $l_a_GamePosExit[3] = [$l_a_Teleport[3], $l_a_Teleport[4], $l_a_Teleport[5]]
        Local $l_a_PointExit = PathFinding_CreatePointFromGamePos($l_a_GamePosExit)
        $l_a_PointExit[0] = $g_a_PathingPoints[0]
        PathFinding_AddPoint($l_a_PointExit)

        Local $l_e_TypeExit = $l_a_Teleport[6] ? 2 : 1 ; both : exit
        PathFinding_InsertTeleportPointIntoVisGraph($l_a_PointExit, $l_e_TypeExit)

        ; Connect teleport points
        Local $l_f_Dist = PathFinding_Distance2D($l_a_Teleport[0], $l_a_Teleport[1], $l_a_Teleport[3], $l_a_Teleport[4]) * 0.01
        Local $l_a_Empty[1]
        $l_a_Empty[0] = 0
        PathFinding_AddToVisGraph($l_a_PointEnter[0], $l_a_PointExit[0], $l_f_Dist, $l_a_Empty)

        If $l_a_Teleport[6] Then ; Bidirectional
            PathFinding_AddToVisGraph($l_a_PointExit[0], $l_a_PointEnter[0], $l_f_Dist * 0.01, $l_a_Empty)
        EndIf
    Next

    Log_Info("Teleports inserted into visibility graph", "PathFinding", $g_h_EditText)
EndFunc

Func PathFinding_InsertTeleportPointIntoVisGraph($a_a_Point, $a_e_Type)
    ; Type: 0 = enter only, 1 = exit only, 2 = both
    For $i = 1 To $g_a_PathingPoints[0] - 1 ; Skip the newly added point itself
        Local $l_a_P = $g_a_PathingPoints[$i]

        Local $l_a_BlockingIDs[1]
        $l_a_BlockingIDs[0] = 0

        If PathFinding_HasLineOfSight($l_a_P, $a_a_Point, $l_a_BlockingIDs) Then
            Local $l_f_Distance = PathFinding_Distance2D($a_a_Point[1], $a_a_Point[2], $l_a_P[1], $l_a_P[2])

            If $a_e_Type = 2 Then ; Both ways
                PathFinding_AddToVisGraph($l_a_P[0], $a_a_Point[0], $l_f_Distance, $l_a_BlockingIDs)
                PathFinding_AddToVisGraph($a_a_Point[0], $l_a_P[0], $l_f_Distance, $l_a_BlockingIDs)
            ElseIf $a_e_Type = 0 Then ; Enter only
                PathFinding_AddToVisGraph($l_a_P[0], $a_a_Point[0], $l_f_Distance, $l_a_BlockingIDs)
            ElseIf $a_e_Type = 1 Then ; Exit only
                PathFinding_AddToVisGraph($a_a_Point[0], $l_a_P[0], $l_f_Distance, $l_a_BlockingIDs)
            EndIf
        EndIf
    Next
EndFunc

; ===============================================================
; A* Search Algorithm
; ===============================================================
Func GetPath($a_f_DestX, $a_f_DestY)
    ; Get current position
    Local $l_f_StartX = Agent_GetAgentInfo(-2, "X")
    Local $l_f_StartY = Agent_GetAgentInfo(-2, "Y")

    If Not $g_b_PathingInitialized Then
        If Not PathFinding_Initialize() Then
            Return $PATHING_ERROR_INVALID_MAP_CONTEXT
        EndIf
    EndIf

    ; Get path
    Local $l_v_Result = PathFinding_Search($l_f_StartX, $l_f_StartY, $a_f_DestX, $a_f_DestY)

    ; Check if result is error code or path
    If Not IsArray($l_v_Result) Then
        Log_Error("PathFinding failed with error code: " & $l_v_Result, "PathFinding", $g_h_EditText)
        Return False
    EndIf

    ; Ensure the exact destination is the last point
    If $l_v_Result[0][0] > 0 Then
        Local $l_i_LastIndex = $l_v_Result[0][0]
        $l_v_Result[$l_i_LastIndex][0] = $a_f_DestX
        $l_v_Result[$l_i_LastIndex][1] = $a_f_DestY
    EndIf

    Return $l_v_Result
EndFunc

Func PathFinding_Search($a_f_StartX, $a_f_StartY, $a_f_GoalX, $a_f_GoalY)
    Log_Info("Starting A* search from (" & $a_f_StartX & ", " & $a_f_StartY & ") to (" & $a_f_GoalX & ", " & $a_f_GoalY & ")", "PathFinding", $g_h_EditText)

    ; Get pathing map blocks
    Local $l_a_BlockArray = Map_GetPathingMapBlockArray()
    If Not IsArray($l_a_BlockArray) Then
        Log_Error("Failed to get pathing map blocks", "PathFinding", $g_h_EditText)
        Return $PATHING_ERROR_FAILED_TO_GET_PATHING_MAP_BLOCK
    EndIf

    ; Create start and goal points
    Local $l_a_GamePosStart[3] = [$a_f_StartX, $a_f_StartY, 0]
    Local $l_a_GamePosGoal[3] = [$a_f_GoalX, $a_f_GoalY, 0]

    ; Get closest points on pathing map
    $l_a_GamePosStart = PathFinding_GetClosestPoint($l_a_GamePosStart)
    $l_a_GamePosGoal = PathFinding_GetClosestPoint($l_a_GamePosGoal)

    Local $l_a_StartPoint = PathFinding_CreatePointFromGamePos($l_a_GamePosStart)
    Local $l_a_GoalPoint = PathFinding_CreatePointFromGamePos($l_a_GamePosGoal)

    If $l_a_StartPoint[3] = -1 Then Return $PATHING_ERROR_FAILED_TO_FIND_START_BOX
    If $l_a_GoalPoint[3] = -1 Then Return $PATHING_ERROR_FAILED_TO_FIND_GOAL_BOX

    ; Check direct line of sight
    Local $l_a_BlockingIDs[1]
    $l_a_BlockingIDs[0] = 0

    If PathFinding_HasLineOfSight($l_a_StartPoint, $l_a_GoalPoint, $l_a_BlockingIDs) Then
        If Not PathFinding_HasBlockedLayers($l_a_BlockingIDs, $l_a_BlockArray) Then
            Log_Info("Direct line of sight found", "PathFinding", $g_h_EditText)
            Return PathFinding_BuildDirectPath($l_a_StartPoint, $l_a_GoalPoint)
        EndIf
    EndIf

    ; Insert start and goal into visibility graph temporarily
    Local $l_i_StartID = UBound($g_a_PathingVisGraph) - 2
    Local $l_i_GoalID = UBound($g_a_PathingVisGraph) - 1

    $l_a_StartPoint[0] = $l_i_StartID
    $l_a_GoalPoint[0] = $l_i_GoalID

    PathFinding_InsertPointIntoVisGraph($l_a_StartPoint)
    PathFinding_InsertPointIntoVisGraph($l_a_GoalPoint)

    ; A* search
    Local $l_a_Path = PathFinding_AStarSearch($l_a_StartPoint, $l_a_GoalPoint, $l_a_BlockArray)

    ; Clean up temporary points from vis graph
    $g_a_PathingVisGraph[$l_i_StartID] = ""
    $g_a_PathingVisGraph[$l_i_GoalID] = ""

    ; Clean up connections to temporary points
    For $i = 0 To UBound($g_a_PathingVisGraph) - 3
        Local $l_s_Connections = $g_a_PathingVisGraph[$i]
        If $l_s_Connections = "" Then ContinueLoop

        Local $l_s_NewConnections = ""
        Local $l_a_Connections = StringSplit($l_s_Connections, "|", 2)

        For $j = 0 To UBound($l_a_Connections) - 1
            Local $l_a_Conn = StringSplit($l_a_Connections[$j], ",", 2)
            If UBound($l_a_Conn) >= 2 Then
                Local $l_i_ConnID = Int($l_a_Conn[0])
                If $l_i_ConnID <> $l_i_StartID And $l_i_ConnID <> $l_i_GoalID Then
                    If $l_s_NewConnections <> "" Then $l_s_NewConnections &= "|"
                    $l_s_NewConnections &= $l_a_Connections[$j]
                EndIf
            EndIf
        Next

        $g_a_PathingVisGraph[$i] = $l_s_NewConnections
    Next

    Return $l_a_Path
EndFunc

Func PathFinding_AStarSearch($a_a_StartPoint, $a_a_GoalPoint, $a_a_BlockArray)
    Local $l_i_MaxNodes = UBound($g_a_PathingVisGraph)

    ; Initialize arrays
    Local $l_a_CostSoFar[$l_i_MaxNodes]
    Local $l_a_CameFrom[$l_i_MaxNodes]

    For $i = 0 To $l_i_MaxNodes - 1
        $l_a_CostSoFar[$i] = -1 ; Infinity
        $l_a_CameFrom[$i] = -1
    Next

    ; Priority queue (simple array implementation)
    Local $l_a_OpenSet[1][2] ; [point_id, priority]
    $l_a_OpenSet[0][0] = $a_a_StartPoint[0]
    $l_a_OpenSet[0][1] = 0

    $l_a_CostSoFar[$a_a_StartPoint[0]] = 0
    $l_a_CameFrom[$a_a_StartPoint[0]] = $a_a_StartPoint[0]

    Local $l_i_Iterations = 0
    Local $l_i_MaxIterations = 500000

    While UBound($l_a_OpenSet) > 0 And $l_i_Iterations < $l_i_MaxIterations
        $l_i_Iterations += 1

        ; Get lowest priority
        Local $l_i_Current = PathFinding_PopLowestPriority($l_a_OpenSet)

        If $l_i_Current = $a_a_GoalPoint[0] Then
            Log_Info("A* found path after " & $l_i_Iterations & " iterations", "PathFinding", $g_h_EditText)
            Return PathFinding_ReconstructPath($l_a_CameFrom, $l_i_Current, $a_a_StartPoint, $a_a_GoalPoint)
        EndIf

        ; Check if we have visibility graph data for this node
        If $l_i_Current >= UBound($g_a_PathingVisGraph) Then
            ContinueLoop
        EndIf

        ; Check neighbors
        Local $l_s_Neighbors = $g_a_PathingVisGraph[$l_i_Current]
        If $l_s_Neighbors = "" Then
            ContinueLoop
        EndIf

        Local $l_a_Neighbors = StringSplit($l_s_Neighbors, "|", 2)

        For $i = 0 To UBound($l_a_Neighbors) - 1
            Local $l_a_NeighborData = StringSplit($l_a_Neighbors[$i], ",", 2)
            If UBound($l_a_NeighborData) < 2 Then ContinueLoop

            Local $l_i_Neighbor = Int($l_a_NeighborData[0])
            Local $l_f_Distance = Number($l_a_NeighborData[1])

            ; Check blocking
            Local $l_b_Blocked = False
            If UBound($l_a_NeighborData) > 2 Then
                For $j = 2 To UBound($l_a_NeighborData) - 1
                    Local $l_i_BlockID = Int($l_a_NeighborData[$j])
                    If $l_i_BlockID < UBound($a_a_BlockArray) And $a_a_BlockArray[$l_i_BlockID] <> 0 Then
                        $l_b_Blocked = True
                        ExitLoop
                    EndIf
                Next
            EndIf

            If $l_b_Blocked Then ContinueLoop

            Local $l_f_NewCost = $l_a_CostSoFar[$l_i_Current] + $l_f_Distance

            If $l_a_CostSoFar[$l_i_Neighbor] = -1 Or $l_f_NewCost < $l_a_CostSoFar[$l_i_Neighbor] Then
                $l_a_CostSoFar[$l_i_Neighbor] = $l_f_NewCost
                $l_a_CameFrom[$l_i_Neighbor] = $l_i_Current

                ; Calculate priority with simple euclidean distance heuristic
                Local $l_f_Priority = $l_f_NewCost

                ; Get neighbor point to calculate heuristic
                Local $l_a_CurrentPoint = PathFinding_GetPointByID($l_i_Neighbor)
                If IsArray($l_a_CurrentPoint) Then
                    $l_f_Priority += PathFinding_Distance2D($l_a_CurrentPoint[1], $l_a_CurrentPoint[2], $a_a_GoalPoint[1], $a_a_GoalPoint[2])
                EndIf

                ; Add to open set
                PathFinding_AddToOpenSet($l_a_OpenSet, $l_i_Neighbor, $l_f_Priority)
            EndIf
        Next
    WEnd

    Log_Error("A* no path found after " & $l_i_Iterations & " iterations", "PathFinding", $g_h_EditText)
    Return $PATHING_ERROR_FAILED_TO_FINALIZE_PATH
EndFunc

Func PathFinding_PopLowestPriority(ByRef $a_a_OpenSet)
    If UBound($a_a_OpenSet) = 0 Then Return -1

    Local $l_i_LowestIndex = 0
    Local $l_f_LowestPriority = $a_a_OpenSet[0][1]

    For $i = 1 To UBound($a_a_OpenSet) - 1
        If $a_a_OpenSet[$i][1] < $l_f_LowestPriority Then
            $l_i_LowestIndex = $i
            $l_f_LowestPriority = $a_a_OpenSet[$i][1]
        EndIf
    Next

    Local $l_i_PointID = $a_a_OpenSet[$l_i_LowestIndex][0]

    ; Remove from array
    For $i = $l_i_LowestIndex To UBound($a_a_OpenSet) - 2
        $a_a_OpenSet[$i][0] = $a_a_OpenSet[$i + 1][0]
        $a_a_OpenSet[$i][1] = $a_a_OpenSet[$i + 1][1]
    Next

    ReDim $a_a_OpenSet[UBound($a_a_OpenSet) - 1][2]

    Return $l_i_PointID
EndFunc

Func PathFinding_GetPointByID($a_i_PointID)
    ; Check regular points
    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_Point = $g_a_PathingPoints[$i]
        If IsArray($l_a_Point) And $l_a_Point[0] = $a_i_PointID Then
            Return $l_a_Point
        EndIf
    Next

    ; Check temporary points (at end of vis graph)
    Local $l_i_TempStartID = UBound($g_a_PathingVisGraph) - 2
    Local $l_i_TempGoalID = UBound($g_a_PathingVisGraph) - 1

    If $a_i_PointID = $l_i_TempStartID Or $a_i_PointID = $l_i_TempGoalID Then
        ; Return 0 to indicate it's a temporary point that should be skipped
        Return 0
    EndIf

    Return 0
EndFunc

Func PathFinding_AddToOpenSet(ByRef $a_a_OpenSet, $a_i_PointID, $a_f_Priority)
    ; Check if already exists
    For $i = 0 To UBound($a_a_OpenSet) - 1
        If $a_a_OpenSet[$i][0] = $a_i_PointID Then
            ; Update priority if lower
            If $a_f_Priority < $a_a_OpenSet[$i][1] Then
                $a_a_OpenSet[$i][1] = $a_f_Priority
            EndIf
            Return
        EndIf
    Next

    ; Add new
    Local $l_i_Index = UBound($a_a_OpenSet)
    ReDim $a_a_OpenSet[$l_i_Index + 1][2]
    $a_a_OpenSet[$l_i_Index][0] = $a_i_PointID
    $a_a_OpenSet[$l_i_Index][1] = $a_f_Priority
EndFunc

Func PathFinding_ReconstructPath($a_a_CameFrom, $a_i_Current, $a_a_StartPoint, $a_a_GoalPoint)
    ; Increase the limit significantly
    Local $l_i_MaxPathLength = 1000  ; Increased from 100
    Local $l_a_AABBPath[$l_i_MaxPathLength]
    Local $l_i_PathIndex = 0

    ; Build AABB path
    While $a_a_CameFrom[$a_i_Current] <> $a_i_Current
        $l_a_AABBPath[$l_i_PathIndex] = $a_i_Current
        $l_i_PathIndex += 1
        $a_i_Current = $a_a_CameFrom[$a_i_Current]

        If $l_i_PathIndex >= $l_i_MaxPathLength Then
            Log_Error("Path too long (>" & $l_i_MaxPathLength & " nodes)", "PathFinding", $g_h_EditText)
            Return $PATHING_ERROR_BUILD_PATH_LENGTH_EXCEEDED
        EndIf
    WEnd

    $l_a_AABBPath[$l_i_PathIndex] = $a_i_Current
    $l_i_PathIndex += 1

    ; Reverse path - also increase this limit
    Local $l_i_MaxWaypoints = 2000  ; Increased from 200
    Local $l_a_Path[$l_i_MaxWaypoints][3] ; [x, y, z]
    Local $l_i_WaypointIndex = 0

    ; Add start point
    $l_i_WaypointIndex += 1
    $l_a_Path[$l_i_WaypointIndex][0] = $a_a_StartPoint[1]
    $l_a_Path[$l_i_WaypointIndex][1] = $a_a_StartPoint[2]
    $l_a_Path[$l_i_WaypointIndex][2] = 0

    ; Add intermediate points
    For $i = $l_i_PathIndex - 2 To 0 Step -1
        Local $l_a_Point = PathFinding_GetPointByID($l_a_AABBPath[$i])
        If IsArray($l_a_Point) Then
            ; Check if it's not a temporary point marker
            If UBound($l_a_Point) >= 3 And $l_a_Point[1] <> 0 And $l_a_Point[2] <> 0 Then
                $l_i_WaypointIndex += 1
                If $l_i_WaypointIndex >= $l_i_MaxWaypoints Then
                    Log_Warning("Waypoint limit reached, truncating path", "PathFinding", $g_h_EditText)
                    ExitLoop
                EndIf
                $l_a_Path[$l_i_WaypointIndex][0] = $l_a_Point[1]
                $l_a_Path[$l_i_WaypointIndex][1] = $l_a_Point[2]
                $l_a_Path[$l_i_WaypointIndex][2] = 0
            EndIf
        EndIf
    Next

    ; Add goal point
    If $l_i_WaypointIndex < $l_i_MaxWaypoints - 1 Then
        $l_i_WaypointIndex += 1
        $l_a_Path[$l_i_WaypointIndex][0] = $a_a_GoalPoint[1]
        $l_a_Path[$l_i_WaypointIndex][1] = $a_a_GoalPoint[2]
        $l_a_Path[$l_i_WaypointIndex][2] = 0
    EndIf

    ; Resize and format
    ReDim $l_a_Path[$l_i_WaypointIndex + 1][2]
    $l_a_Path[0][0] = $l_i_WaypointIndex

    Log_Info("Raw path has " & $l_i_WaypointIndex & " waypoints", "PathFinding", $g_h_EditText)

    ; Smooth path - this should reduce the number of waypoints significantly
    Return PathFinding_SmoothPath($l_a_Path)
EndFunc

Func PathFinding_SmoothPath($a_a_Path)
    If $a_a_Path[0][0] < 3 Then Return $a_a_Path

    Local $l_i_MaxSmoothedWaypoints = 500
    Local $l_a_SmoothedPath[$l_i_MaxSmoothedWaypoints][2]
    Local $l_i_PathIndex = 0

    ; Always keep start
    $l_i_PathIndex += 1
    $l_a_SmoothedPath[$l_i_PathIndex][0] = $a_a_Path[1][0]
    $l_a_SmoothedPath[$l_i_PathIndex][1] = $a_a_Path[1][1]

    Local $l_i_CurrentIndex = 1

    While $l_i_CurrentIndex < $a_a_Path[0][0]
        Local $l_i_FarthestVisible = $l_i_CurrentIndex

        ; Find farthest visible point
        For $i = $l_i_CurrentIndex + 1 To $a_a_Path[0][0]
            If PathFinding_HasDirectLineOfSight( _
                $a_a_Path[$l_i_CurrentIndex][0], $a_a_Path[$l_i_CurrentIndex][1], _
                $a_a_Path[$i][0], $a_a_Path[$i][1]) Then
                $l_i_FarthestVisible = $i
            Else
                ; Can't see this point, so use the previous one
                If $l_i_FarthestVisible > $l_i_CurrentIndex + 1 Then
                    $l_i_FarthestVisible = $i - 1
                EndIf
                ExitLoop
            EndIf
        Next

        ; Add the farthest visible point
        If $l_i_FarthestVisible > $l_i_CurrentIndex Then
            $l_i_PathIndex += 1
            If $l_i_PathIndex >= $l_i_MaxSmoothedWaypoints Then
                Log_Warning("Smoothed path exceeds limit, truncating", "PathFinding", $g_h_EditText)
                ExitLoop
            EndIf
            $l_a_SmoothedPath[$l_i_PathIndex][0] = $a_a_Path[$l_i_FarthestVisible][0]
            $l_a_SmoothedPath[$l_i_PathIndex][1] = $a_a_Path[$l_i_FarthestVisible][1]
            $l_i_CurrentIndex = $l_i_FarthestVisible
        Else
            ; No improvement possible, move to next point
            $l_i_CurrentIndex += 1
            If $l_i_CurrentIndex <= $a_a_Path[0][0] Then
                $l_i_PathIndex += 1
                If $l_i_PathIndex >= $l_i_MaxSmoothedWaypoints Then
                    Log_Warning("Smoothed path exceeds limit, truncating", "PathFinding", $g_h_EditText)
                    ExitLoop
                EndIf
                $l_a_SmoothedPath[$l_i_PathIndex][0] = $a_a_Path[$l_i_CurrentIndex][0]
                $l_a_SmoothedPath[$l_i_PathIndex][1] = $a_a_Path[$l_i_CurrentIndex][1]
            EndIf
        EndIf
    WEnd

    ReDim $l_a_SmoothedPath[$l_i_PathIndex + 1][2]
    $l_a_SmoothedPath[0][0] = $l_i_PathIndex

    Log_Info("Smoothed path to " & $l_i_PathIndex & " waypoints", "PathFinding", $g_h_EditText)

    Return $l_a_SmoothedPath
EndFunc

Func PathFinding_HasDirectLineOfSight($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    ; Quick distance check - if too far, assume no line of sight
    Local $l_f_Distance = PathFinding_Distance2D($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    If $l_f_Distance > 5000 Then Return False  ; Max sight distance

    ; Sample points along the line
    Local $l_i_Steps = Ceiling($l_f_Distance / 100)  ; Check every 100 units
    If $l_i_Steps < 2 Then $l_i_Steps = 2

    Local $l_i_PreviousAABB = -1
    Local $l_b_FirstPoint = True

    For $i = 0 To $l_i_Steps
        Local $l_f_T = $i / $l_i_Steps
        Local $l_f_X = $a_f_X1 + ($a_f_X2 - $a_f_X1) * $l_f_T
        Local $l_f_Y = $a_f_Y1 + ($a_f_Y2 - $a_f_Y1) * $l_f_T

        Local $l_a_CurrentAABB = PathFinding_FindAABB($l_f_X, $l_f_Y)
        If Not IsArray($l_a_CurrentAABB) Then
            ; Point is not on the pathing map
            Return False
        EndIf

        If $l_b_FirstPoint Then
            $l_i_PreviousAABB = $l_a_CurrentAABB[0]
            $l_b_FirstPoint = False
        ElseIf $l_a_CurrentAABB[0] <> $l_i_PreviousAABB Then
            ; Check if AABBs are connected
            If Not PathFinding_QuickAABBConnectionCheck($l_i_PreviousAABB, $l_a_CurrentAABB[0]) Then
                Return False
            EndIf
            $l_i_PreviousAABB = $l_a_CurrentAABB[0]
        EndIf
    Next

    Return True
EndFunc

Func PathFinding_QuickAABBConnectionCheck($a_i_AABB1, $a_i_AABB2)
    If $a_i_AABB1 = $a_i_AABB2 Then Return True

    ; Vérifier la connexion directe
    If $a_i_AABB1 >= 0 And $a_i_AABB1 < UBound($g_a_PathingAABBGraph) Then
        Local $l_s_Connections = $g_a_PathingAABBGraph[$a_i_AABB1 + 1]
        If $l_s_Connections <> "" Then
            Local $l_a_Connected = StringSplit($l_s_Connections, ",", 2)
            For $i = 0 To UBound($l_a_Connected) - 1
                If Int($l_a_Connected[$i]) = $a_i_AABB2 Then Return True
            Next
        EndIf
    EndIf

    Return False
EndFunc

; ===============================================================
; Helper Functions
; ===============================================================

Func PathFinding_FindAABB($a_f_X, $a_f_Y, $a_i_Layer = 0)
    ; First pass: try to find exact match with layer
    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_a_AABB = $g_a_PathingAABBs[$i]
        If Not IsArray($l_a_AABB) Then ContinueLoop

        Local $l_a_Trap = $g_a_PathingTrapezoids[$l_a_AABB[5]]
        If Not IsArray($l_a_Trap) Then ContinueLoop

        ; Skip layer check if layer is 0 (default)
        If $a_i_Layer <> 0 And $l_a_Trap[1] <> $a_i_Layer Then ContinueLoop

        ; Check if point is in trapezoid
        If PathFinding_IsOnPathingTrapezoid($a_f_X, $a_f_Y, $l_a_Trap) Then
            Return $l_a_AABB
        EndIf
    Next

    ; Second pass: ignore layer if not found
    If $a_i_Layer <> 0 Then
        For $i = 1 To $g_a_PathingAABBs[0]
            Local $l_a_AABB = $g_a_PathingAABBs[$i]
            If Not IsArray($l_a_AABB) Then ContinueLoop

            Local $l_a_Trap = $g_a_PathingTrapezoids[$l_a_AABB[5]]
            If Not IsArray($l_a_Trap) Then ContinueLoop

            If PathFinding_IsOnPathingTrapezoid($a_f_X, $a_f_Y, $l_a_Trap) Then
                Return $l_a_AABB
            EndIf
        Next
    EndIf

    ; Don't return a "close enough" AABB - let the caller handle it
    Return 0
EndFunc

Func PathFinding_IsOnPathingTrapezoid($a_f_X, $a_f_Y, $a_a_Trapezoid)
    Local $l_f_Tolerance = 5.0  ; Increased from 2.0

    ; Check Y bounds with tolerance
    If $a_a_Trapezoid[3] + $l_f_Tolerance < $a_f_Y Or $a_a_Trapezoid[5] - $l_f_Tolerance > $a_f_Y Then Return False

    ; Check X bounds with tolerance
    If $a_a_Trapezoid[4] - $l_f_Tolerance > $a_f_X And $a_a_Trapezoid[2] - $l_f_Tolerance > $a_f_X Then Return False
    If $a_a_Trapezoid[6] + $l_f_Tolerance < $a_f_X And $a_a_Trapezoid[8] + $l_f_Tolerance < $a_f_X Then Return False

    ; Check edges using cross product with tolerance
    Local $l_f_Cross1 = PathFinding_Cross2D($a_a_Trapezoid[4] - $a_a_Trapezoid[2], $a_a_Trapezoid[5] - $a_a_Trapezoid[3], _
                                            $a_f_X - $a_a_Trapezoid[2], $a_f_Y - $a_a_Trapezoid[3])
    If $l_f_Cross1 > $l_f_Tolerance Then Return False

    Local $l_f_Cross2 = PathFinding_Cross2D($a_a_Trapezoid[8] - $a_a_Trapezoid[6], $a_a_Trapezoid[9] - $a_a_Trapezoid[7], _
                                            $a_f_X - $a_a_Trapezoid[6], $a_f_Y - $a_a_Trapezoid[7])
    If $l_f_Cross2 > $l_f_Tolerance Then Return False

    Return True
EndFunc

Func PathFinding_Cross2D($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    Return ($a_f_X1 * $a_f_Y2) - ($a_f_Y1 * $a_f_X2)
EndFunc

Func PathFinding_GetClosestPoint($a_a_GamePos)
    ; First try to find AABB at exact position
    Local $l_a_AABB = PathFinding_FindAABB($a_a_GamePos[0], $a_a_GamePos[1], $a_a_GamePos[2])
    If IsArray($l_a_AABB) Then
        Return $a_a_GamePos
    EndIf

    ; Try without layer restriction
    $l_a_AABB = PathFinding_FindAABB($a_a_GamePos[0], $a_a_GamePos[1], 0)
    If IsArray($l_a_AABB) Then
        ; Update layer from found AABB
        Local $l_a_Trap = $g_a_PathingTrapezoids[$l_a_AABB[5]]
        $a_a_GamePos[2] = $l_a_Trap[1]
        Return $a_a_GamePos
    EndIf

    ; Find nearest point on any trapezoid
    Local $l_f_MinDist = 999999
    Local $l_a_ClosestPos = $a_a_GamePos
    Local $l_i_ClosestAABBIndex = -1

    ; Check all AABBs to find closest edge point
    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_a_TestAABB = $g_a_PathingAABBs[$i]
        If Not IsArray($l_a_TestAABB) Then ContinueLoop

        Local $l_a_TestTrap = $g_a_PathingTrapezoids[$l_a_TestAABB[5]]
        If Not IsArray($l_a_TestTrap) Then ContinueLoop

        ; Get closest point on trapezoid edges
        Local $l_a_ClosestOnTrap = PathFinding_GetClosestPointOnTrapezoid($a_a_GamePos[0], $a_a_GamePos[1], $l_a_TestTrap)
        If IsArray($l_a_ClosestOnTrap) Then
            Local $l_f_Dist = PathFinding_Distance2D($a_a_GamePos[0], $a_a_GamePos[1], $l_a_ClosestOnTrap[0], $l_a_ClosestOnTrap[1])

            If $l_f_Dist < $l_f_MinDist Then
                $l_f_MinDist = $l_f_Dist
                $l_a_ClosestPos[0] = $l_a_ClosestOnTrap[0]
                $l_a_ClosestPos[1] = $l_a_ClosestOnTrap[1]
                $l_a_ClosestPos[2] = $l_a_TestTrap[1]
                $l_i_ClosestAABBIndex = $i
            EndIf
        EndIf
    Next

    If $l_i_ClosestAABBIndex > 0 Then
        Log_Info("Found closest point on AABB " & ($l_i_ClosestAABBIndex-1) & " at distance " & Round($l_f_MinDist, 2), "PathFinding", $g_h_EditText)
    Else
        Log_Warning("No valid closest point found!", "PathFinding", $g_h_EditText)
    EndIf

    Return $l_a_ClosestPos
EndFunc

Func PathFinding_GetClosestPointOnTrapezoid($a_f_X, $a_f_Y, $a_a_Trapezoid)
    ; If point is already inside, return it
    If PathFinding_IsOnPathingTrapezoid($a_f_X, $a_f_Y, $a_a_Trapezoid) Then
        Local $l_a_Result[2] = [$a_f_X, $a_f_Y]
        Return $l_a_Result
    EndIf

    ; Check distance to all four edges and find closest point
    Local $l_f_MinDist = 999999
    Local $l_a_ClosestPoint[2]

    ; Edge 1: a to b
    Local $l_a_EdgePoint = PathFinding_ClosestPointOnSegment($a_f_X, $a_f_Y, _
        $a_a_Trapezoid[2], $a_a_Trapezoid[3], $a_a_Trapezoid[4], $a_a_Trapezoid[5])
    Local $l_f_Dist = PathFinding_Distance2D($a_f_X, $a_f_Y, $l_a_EdgePoint[0], $l_a_EdgePoint[1])
    If $l_f_Dist < $l_f_MinDist Then
        $l_f_MinDist = $l_f_Dist
        $l_a_ClosestPoint = $l_a_EdgePoint
    EndIf

    ; Edge 2: b to c
    $l_a_EdgePoint = PathFinding_ClosestPointOnSegment($a_f_X, $a_f_Y, _
        $a_a_Trapezoid[4], $a_a_Trapezoid[5], $a_a_Trapezoid[6], $a_a_Trapezoid[7])
    $l_f_Dist = PathFinding_Distance2D($a_f_X, $a_f_Y, $l_a_EdgePoint[0], $l_a_EdgePoint[1])
    If $l_f_Dist < $l_f_MinDist Then
        $l_f_MinDist = $l_f_Dist
        $l_a_ClosestPoint = $l_a_EdgePoint
    EndIf

    ; Edge 3: c to d
    $l_a_EdgePoint = PathFinding_ClosestPointOnSegment($a_f_X, $a_f_Y, _
        $a_a_Trapezoid[6], $a_a_Trapezoid[7], $a_a_Trapezoid[8], $a_a_Trapezoid[9])
    $l_f_Dist = PathFinding_Distance2D($a_f_X, $a_f_Y, $l_a_EdgePoint[0], $l_a_EdgePoint[1])
    If $l_f_Dist < $l_f_MinDist Then
        $l_f_MinDist = $l_f_Dist
        $l_a_ClosestPoint = $l_a_EdgePoint
    EndIf

    ; Edge 4: d to a
    $l_a_EdgePoint = PathFinding_ClosestPointOnSegment($a_f_X, $a_f_Y, _
        $a_a_Trapezoid[8], $a_a_Trapezoid[9], $a_a_Trapezoid[2], $a_a_Trapezoid[3])
    $l_f_Dist = PathFinding_Distance2D($a_f_X, $a_f_Y, $l_a_EdgePoint[0], $l_a_EdgePoint[1])
    If $l_f_Dist < $l_f_MinDist Then
        $l_f_MinDist = $l_f_Dist
        $l_a_ClosestPoint = $l_a_EdgePoint
    EndIf

    Return $l_a_ClosestPoint
EndFunc

Func PathFinding_Distance2D($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    Return Sqrt(PathFinding_GetSquareDistance($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2))
EndFunc

Func PathFinding_ClosestPointOnSegment($a_f_PX, $a_f_PY, $a_f_AX, $a_f_AY, $a_f_BX, $a_f_BY)
    Local $l_f_ABX = $a_f_BX - $a_f_AX
    Local $l_f_ABY = $a_f_BY - $a_f_AY
    Local $l_f_APX = $a_f_PX - $a_f_AX
    Local $l_f_APY = $a_f_PY - $a_f_AY

    Local $l_f_ABSquared = $l_f_ABX * $l_f_ABX + $l_f_ABY * $l_f_ABY

    If $l_f_ABSquared = 0 Then
        ; A and B are the same point
        Local $l_a_Result[2] = [$a_f_AX, $a_f_AY]
        Return $l_a_Result
    EndIf

    Local $l_f_T = ($l_f_APX * $l_f_ABX + $l_f_APY * $l_f_ABY) / $l_f_ABSquared

    ; Clamp t to [0, 1] to handle points outside the segment
    If $l_f_T < 0 Then $l_f_T = 0
    If $l_f_T > 1 Then $l_f_T = 1

    Local $l_a_Result[2]
    $l_a_Result[0] = $a_f_AX + $l_f_T * $l_f_ABX
    $l_a_Result[1] = $a_f_AY + $l_f_T * $l_f_ABY

    Return $l_a_Result
EndFunc

Func PathFinding_CreatePointFromGamePos($a_a_GamePos)
    Local $l_a_Point = PathFinding_CreatePoint(0, $a_a_GamePos[0], $a_a_GamePos[1])

    ; Find AABB with fallback to closest
    Local $l_a_AABB = PathFinding_FindAABB($a_a_GamePos[0], $a_a_GamePos[1], $a_a_GamePos[2])
    If IsArray($l_a_AABB) Then
        $l_a_Point[3] = $l_a_AABB[0]
    Else
        ; Try without layer restriction
        $l_a_AABB = PathFinding_FindAABB($a_a_GamePos[0], $a_a_GamePos[1], 0)
        If IsArray($l_a_AABB) Then
            $l_a_Point[3] = $l_a_AABB[0]
        Else
            ; Find nearest AABB
            Local $l_f_MinDist = 999999
            Local $l_i_NearestAABB = -1

            For $i = 1 To $g_a_PathingAABBs[0]
                Local $l_a_TestAABB = $g_a_PathingAABBs[$i]
                If Not IsArray($l_a_TestAABB) Then ContinueLoop

                Local $l_f_Dist = PathFinding_Distance2D($a_a_GamePos[0], $a_a_GamePos[1], $l_a_TestAABB[1], $l_a_TestAABB[2])
                If $l_f_Dist < $l_f_MinDist Then
                    $l_f_MinDist = $l_f_Dist
                    $l_i_NearestAABB = $l_a_TestAABB[0]
                EndIf
            Next

            If $l_i_NearestAABB >= 0 Then
                $l_a_Point[3] = $l_i_NearestAABB
            Else
                Log_Warning("No AABB found for position (" & $a_a_GamePos[0] & ", " & $a_a_GamePos[1] & ")", "PathFinding", $g_h_EditText)
            EndIf
        EndIf
    EndIf

    Return $l_a_Point
EndFunc

Func PathFinding_AABBIntersect($a_i_AABB1ID, $a_i_AABB2ID, $a_f_Padding = 0)
    Local $l_a_AABB1 = $g_a_PathingAABBs[$a_i_AABB1ID]
    Local $l_a_AABB2 = $g_a_PathingAABBs[$a_i_AABB2ID]

    Local $l_f_DX = Abs($l_a_AABB2[1] - $l_a_AABB1[1])
    Local $l_f_DY = Abs($l_a_AABB2[2] - $l_a_AABB1[2])

    Local $l_f_PX = ($l_a_AABB2[3] + $l_a_AABB1[3] + $a_f_Padding) - $l_f_DX
    If $l_f_PX <= 0 Then Return False

    Local $l_f_PY = ($l_a_AABB2[4] + $l_a_AABB1[4] + $a_f_Padding) - $l_f_DY
    If $l_f_PY <= 0 Then Return False

    Return True
EndFunc

; Adjacent side enum: 0=none, 1=aBottom_bTop, 2=aTop_bBottom, 3=aLeft_bRight, 4=aRight_bLeft
Func PathFinding_CheckTouching($a_i_AABB1ID, $a_i_AABB2ID)
    If $a_i_AABB1ID < 1 Or $a_i_AABB1ID > $g_a_PathingAABBs[0] Then Return 0
    If $a_i_AABB2ID < 1 Or $a_i_AABB2ID > $g_a_PathingAABBs[0] Then Return 0

    Local $l_a_AABB1 = $g_a_PathingAABBs[$a_i_AABB1ID]
    Local $l_a_AABB2 = $g_a_PathingAABBs[$a_i_AABB2ID]

    If Not IsArray($l_a_AABB1) Or Not IsArray($l_a_AABB2) Then Return 0
    If UBound($l_a_AABB1) < 6 Or UBound($l_a_AABB2) < 6 Then Return 0

    Local $l_i_TrapIndex1 = $l_a_AABB1[5]
    Local $l_i_TrapIndex2 = $l_a_AABB2[5]

    If $l_i_TrapIndex1 < 1 Or $l_i_TrapIndex1 > $g_a_PathingTrapezoids[0] Then Return 0
    If $l_i_TrapIndex2 < 1 Or $l_i_TrapIndex2 > $g_a_PathingTrapezoids[0] Then Return 0

    Local $l_a_Trap1 = $g_a_PathingTrapezoids[$l_i_TrapIndex1]
    Local $l_a_Trap2 = $g_a_PathingTrapezoids[$l_i_TrapIndex2]

    If Not IsArray($l_a_Trap1) Or Not IsArray($l_a_Trap2) Then Return 0

    Local $l_i_LayerDiff = Abs($l_a_Trap1[1] - $l_a_Trap2[1])

    If $l_a_Trap1[1] = $l_a_Trap2[1] Then
        Return PathFinding_TrapezoidsTouch($l_a_Trap1, $l_a_Trap2)
    ElseIf $l_i_LayerDiff <= 2 Then
        Local $l_f_Trap1Width = _Max(Abs($l_a_Trap1[8] - $l_a_Trap1[2]), Abs($l_a_Trap1[6] - $l_a_Trap1[4]))
        Local $l_f_Trap2Width = _Max(Abs($l_a_Trap2[8] - $l_a_Trap2[2]), Abs($l_a_Trap2[6] - $l_a_Trap2[4]))
        Local $l_f_Trap1Height = Abs($l_a_Trap1[3] - $l_a_Trap1[5])
        Local $l_f_Trap2Height = Abs($l_a_Trap2[3] - $l_a_Trap2[5])

        If ($l_f_Trap1Width > 500 And $l_f_Trap1Height < 200) Or ($l_f_Trap2Width > 500 And $l_f_Trap2Height < 200) Then
            Return PathFinding_TrapezoidsTouch($l_a_Trap1, $l_a_Trap2)
        EndIf
    EndIf

    Return 0
EndFunc

Func PathFinding_TrapezoidsTouch($a_a_Trap1, $a_a_Trap2)
    If Not IsArray($a_a_Trap1) Or Not IsArray($a_a_Trap2) Then Return 0
    If UBound($a_a_Trap1) < 10 Or UBound($a_a_Trap2) < 10 Then Return 0

    Local $l_f_Trap1Width = _Max(Abs($a_a_Trap1[8] - $a_a_Trap1[2]), Abs($a_a_Trap1[6] - $a_a_Trap1[4]))
    Local $l_f_Trap2Width = _Max(Abs($a_a_Trap2[8] - $a_a_Trap2[2]), Abs($a_a_Trap2[6] - $a_a_Trap2[4]))
    Local $l_f_Trap1Height = Abs($a_a_Trap1[3] - $a_a_Trap1[5])
    Local $l_f_Trap2Height = Abs($a_a_Trap2[3] - $a_a_Trap2[5])

    Local $l_b_HasBridge = False
    If ($l_f_Trap1Width > 500 And $l_f_Trap1Height < 200) Or ($l_f_Trap2Width > 500 And $l_f_Trap2Height < 200) Then
        $l_b_HasBridge = True
    EndIf

    ; Check all possible touching configurations

    ; Bottom of 1 touches top of 2
    If $a_a_Trap1[2] <> $a_a_Trap1[8] And $a_a_Trap2[4] <> $a_a_Trap2[6] Then
        Local $l_f_YTolerance = 1.0
        If $l_b_HasBridge Then $l_f_YTolerance = 5.0

        If Abs($a_a_Trap1[3] - $a_a_Trap1[5]) < $l_f_YTolerance Then
            If PathFinding_Collinear($a_a_Trap1[2], $a_a_Trap1[3], $a_a_Trap1[8], $a_a_Trap1[9], _
                                     $a_a_Trap2[4], $a_a_Trap2[5], $a_a_Trap2[6], $a_a_Trap2[7]) Then
                Return 1 ; aBottom_bTop
            EndIf
        EndIf
    EndIf

    ; Top of 1 touches bottom of 2
    If $a_a_Trap1[4] <> $a_a_Trap1[6] And $a_a_Trap2[2] <> $a_a_Trap2[8] Then
        Local $l_f_YTolerance = 1.0
        If $l_b_HasBridge Then $l_f_YTolerance = 5.0

        If Abs($a_a_Trap1[5] - $a_a_Trap2[3]) < $l_f_YTolerance Then
            If PathFinding_Collinear($a_a_Trap1[6], $a_a_Trap1[7], $a_a_Trap1[4], $a_a_Trap1[5], _
                                     $a_a_Trap2[8], $a_a_Trap2[9], $a_a_Trap2[2], $a_a_Trap2[3]) Then
                Return 2 ; aTop_bBottom
            EndIf
        EndIf
    EndIf

    ; Right of 1 touches left of 2
    If PathFinding_Collinear($a_a_Trap1[2], $a_a_Trap1[3], $a_a_Trap1[4], $a_a_Trap1[5], _
                             $a_a_Trap2[6], $a_a_Trap2[7], $a_a_Trap2[8], $a_a_Trap2[9]) Then
        Return 4 ; aRight_bLeft
    EndIf

    ; Left of 1 touches right of 2
    If PathFinding_Collinear($a_a_Trap1[8], $a_a_Trap1[9], $a_a_Trap1[6], $a_a_Trap1[7], _
                             $a_a_Trap2[4], $a_a_Trap2[5], $a_a_Trap2[2], $a_a_Trap2[3]) Then
        Return 3 ; aLeft_bRight
    EndIf

    If $l_b_HasBridge Then
        If PathFinding_CheckVerticalOverlap($a_a_Trap1, $a_a_Trap2) Then
            If $a_a_Trap1[3] > $a_a_Trap2[5] Then
                Return 1
            Else
                Return 2
            EndIf
        EndIf
    EndIf

    Return 0 ; none
EndFunc

Func PathFinding_CheckVerticalOverlap($a_a_Trap1, $a_a_Trap2)
    If Not IsArray($a_a_Trap1) Or Not IsArray($a_a_Trap2) Then Return False
    If UBound($a_a_Trap1) < 10 Or UBound($a_a_Trap2) < 10 Then Return False

    Local $l_f_Trap1MinX = _Min(_Min($a_a_Trap1[2], $a_a_Trap1[4]), _Min($a_a_Trap1[6], $a_a_Trap1[8]))
    Local $l_f_Trap1MaxX = _Max(_Max($a_a_Trap1[2], $a_a_Trap1[4]), _Max($a_a_Trap1[6], $a_a_Trap1[8]))
    Local $l_f_Trap2MinX = _Min(_Min($a_a_Trap2[2], $a_a_Trap2[4]), _Min($a_a_Trap2[6], $a_a_Trap2[8]))
    Local $l_f_Trap2MaxX = _Max(_Max($a_a_Trap2[2], $a_a_Trap2[4]), _Max($a_a_Trap2[6], $a_a_Trap2[8]))

    If $l_f_Trap1MaxX < $l_f_Trap2MinX Or $l_f_Trap2MaxX < $l_f_Trap1MinX Then
        Return False
    EndIf

    Local $l_f_VerticalGap = _Min(Abs($a_a_Trap1[3] - $a_a_Trap2[5]), Abs($a_a_Trap2[3] - $a_a_Trap1[5]))

    If $l_f_VerticalGap < 100 Then
        Return True
    EndIf

    Return False
EndFunc

Func PathFinding_Collinear($a_f_A1X, $a_f_A1Y, $a_f_A2X, $a_f_A2Y, $a_f_B1X, $a_f_B1Y, $a_f_B2X, $a_f_B2Y)
    Local $l_f_Tolerance = 0.1

    ; Check if segments are collinear
    Local $l_f_SX = $a_f_B2X - $a_f_B1X
    Local $l_f_SY = $a_f_B2Y - $a_f_B1Y
    Local $l_f_DotSS = $l_f_SX * $l_f_SX + $l_f_SY * $l_f_SY

    If $l_f_DotSS = 0 Then Return False

    Local $l_f_InvDotSS = 1.0 / $l_f_DotSS

    ; Project a1 and a2 onto line b1-b2
    Local $l_f_Q1X = $a_f_B1X + PathFinding_Dot2D($a_f_A1X - $a_f_B1X, $a_f_A1Y - $a_f_B1Y, $l_f_SX, $l_f_SY) * $l_f_InvDotSS * $l_f_SX
    Local $l_f_Q1Y = $a_f_B1Y + PathFinding_Dot2D($a_f_A1X - $a_f_B1X, $a_f_A1Y - $a_f_B1Y, $l_f_SX, $l_f_SY) * $l_f_InvDotSS * $l_f_SY
    Local $l_f_Q2X = $a_f_B1X + PathFinding_Dot2D($a_f_A2X - $a_f_B1X, $a_f_A2Y - $a_f_B1Y, $l_f_SX, $l_f_SY) * $l_f_InvDotSS * $l_f_SX
    Local $l_f_Q2Y = $a_f_B1Y + PathFinding_Dot2D($a_f_A2X - $a_f_B1X, $a_f_A2Y - $a_f_B1Y, $l_f_SX, $l_f_SY) * $l_f_InvDotSS * $l_f_SY

    ; Check distance from projected points to original points
    If PathFinding_GetSquareDistance($a_f_A1X, $a_f_A1Y, $l_f_Q1X, $l_f_Q1Y) > $l_f_Tolerance Or _
       PathFinding_GetSquareDistance($a_f_A2X, $a_f_A2Y, $l_f_Q2X, $l_f_Q2Y) > $l_f_Tolerance Then
        Return False
    EndIf

    ; Check if segments overlap
    Return PathFinding_OnSegment($a_f_A1X, $a_f_A1Y, $a_f_B1X, $a_f_B1Y, $a_f_A2X, $a_f_A2Y) Or _
           PathFinding_OnSegment($a_f_A1X, $a_f_A1Y, $a_f_B2X, $a_f_B2Y, $a_f_A2X, $a_f_A2Y) Or _
           PathFinding_OnSegment($a_f_B1X, $a_f_B1Y, $a_f_A1X, $a_f_A1Y, $a_f_B2X, $a_f_B2Y) Or _
           PathFinding_OnSegment($a_f_B1X, $a_f_B1Y, $a_f_A2X, $a_f_A2Y, $a_f_B2X, $a_f_B2Y)
EndFunc

Func PathFinding_OnSegment($a_f_PX, $a_f_PY, $a_f_QX, $a_f_QY, $a_f_RX, $a_f_RY)
    ; Check if point q lies on segment pr
    If $a_f_QX <= _Max($a_f_PX, $a_f_RX) And $a_f_QX >= _Min($a_f_PX, $a_f_RX) And _
       $a_f_QY <= _Max($a_f_PY, $a_f_RY) And $a_f_QY >= _Min($a_f_PY, $a_f_RY) Then
        Return True
    EndIf
    Return False
EndFunc

Func PathFinding_Dot2D($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    Return ($a_f_X1 * $a_f_X2) + ($a_f_Y1 * $a_f_Y2)
EndFunc

Func PathFinding_CreatePortalBetween($a_i_AABB1ID, $a_i_AABB2ID, $a_e_TouchingSide)
    If $a_i_AABB1ID < 1 Or $a_i_AABB1ID > $g_a_PathingAABBs[0] Then Return False
    If $a_i_AABB2ID < 1 Or $a_i_AABB2ID > $g_a_PathingAABBs[0] Then Return False

    Local $l_a_AABB1 = $g_a_PathingAABBs[$a_i_AABB1ID]
    Local $l_a_AABB2 = $g_a_PathingAABBs[$a_i_AABB2ID]

    If Not IsArray($l_a_AABB1) Or Not IsArray($l_a_AABB2) Then Return False

    Local $l_i_TrapIndex1 = $l_a_AABB1[5]
    Local $l_i_TrapIndex2 = $l_a_AABB2[5]

    If $l_i_TrapIndex1 < 1 Or $l_i_TrapIndex1 > $g_a_PathingTrapezoids[0] Then Return False
    If $l_i_TrapIndex2 < 1 Or $l_i_TrapIndex2 > $g_a_PathingTrapezoids[0] Then Return False

    Local $l_a_Trap1 = $g_a_PathingTrapezoids[$l_i_TrapIndex1]
    Local $l_a_Trap2 = $g_a_PathingTrapezoids[$l_i_TrapIndex2]

    If Not IsArray($l_a_Trap1) Or Not IsArray($l_a_Trap2) Then Return False

    Local $l_f_Trap1Width = _Max(Abs($l_a_Trap1[8] - $l_a_Trap1[2]), Abs($l_a_Trap1[6] - $l_a_Trap1[4]))
    Local $l_f_Trap2Width = _Max(Abs($l_a_Trap2[8] - $l_a_Trap2[2]), Abs($l_a_Trap2[6] - $l_a_Trap2[4]))
    Local $l_f_Trap1Height = Abs($l_a_Trap1[3] - $l_a_Trap1[5])
    Local $l_f_Trap2Height = Abs($l_a_Trap2[3] - $l_a_Trap2[5])

    Local $l_b_IsBridge1 = ($l_f_Trap1Width > 500 And $l_f_Trap1Height < 200)
    Local $l_b_IsBridge2 = ($l_f_Trap2Width > 500 And $l_f_Trap2Height < 200)

    Local $l_f_Tolerance = 10.0
    Local $l_f_SquareTolerance = 100.0

    If $l_b_IsBridge1 Or $l_b_IsBridge2 Then
        $l_f_Tolerance = 50.0
        $l_f_SquareTolerance = 2500.0
    EndIf

    Switch $a_e_TouchingSide
        Case 1 ; aBottom_bTop
            Local $l_f_A = _Max($l_a_Trap1[2], $l_a_Trap2[4])
            Local $l_f_B = _Min($l_a_Trap1[8], $l_a_Trap2[6])
            If Abs($l_f_A - $l_f_B) < $l_f_Tolerance Then Return False

            Local $l_a_Portal = PathFinding_CreatePortal($l_f_A, $l_a_Trap1[3], $l_f_B, $l_a_Trap1[3], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            PathFinding_AddPortal($l_a_Portal)
            PathFinding_AddPTPortalConnection($l_a_Trap1[0], $g_a_PathingPortals[0])
            PathFinding_AddPTPortalConnection($l_a_Trap2[0], $g_a_PathingPortals[0])
            Return True

        Case 2 ; aTop_bBottom
            Local $l_f_A = _Max($l_a_Trap1[4], $l_a_Trap2[2])
            Local $l_f_B = _Min($l_a_Trap1[6], $l_a_Trap2[8])
            If Abs($l_f_A - $l_f_B) < $l_f_Tolerance Then Return False

            Local $l_a_Portal = PathFinding_CreatePortal($l_f_A, $l_a_Trap1[5], $l_f_B, $l_a_Trap1[5], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            PathFinding_AddPortal($l_a_Portal)
            PathFinding_AddPTPortalConnection($l_a_Trap1[0], $g_a_PathingPortals[0])
            PathFinding_AddPTPortalConnection($l_a_Trap2[0], $g_a_PathingPortals[0])
            Return True

        Case 3 ; aLeft_bRight
            Local $l_b_O1 = PathFinding_OnSegment($l_a_Trap1[6], $l_a_Trap1[7], $l_a_Trap2[2], $l_a_Trap2[3], $l_a_Trap1[8], $l_a_Trap1[9])
            Local $l_b_O2 = PathFinding_OnSegment($l_a_Trap1[6], $l_a_Trap1[7], $l_a_Trap2[4], $l_a_Trap2[5], $l_a_Trap1[8], $l_a_Trap1[9])

            Local $l_a_Portal
            If $l_b_O1 And $l_b_O2 Then
                If PathFinding_GetSquareDistance($l_a_Trap2[2], $l_a_Trap2[3], $l_a_Trap2[4], $l_a_Trap2[5]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap2[2], $l_a_Trap2[3], $l_a_Trap2[4], $l_a_Trap2[5], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            ElseIf $l_b_O1 Then
                If PathFinding_GetSquareDistance($l_a_Trap2[2], $l_a_Trap2[3], $l_a_Trap1[6], $l_a_Trap1[7]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap2[2], $l_a_Trap2[3], $l_a_Trap1[6], $l_a_Trap1[7], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            ElseIf $l_b_O2 Then
                If PathFinding_GetSquareDistance($l_a_Trap1[8], $l_a_Trap1[9], $l_a_Trap2[4], $l_a_Trap2[5]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap1[8], $l_a_Trap1[9], $l_a_Trap2[4], $l_a_Trap2[5], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            Else
                If PathFinding_GetSquareDistance($l_a_Trap1[6], $l_a_Trap1[7], $l_a_Trap1[8], $l_a_Trap1[9]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap1[6], $l_a_Trap1[7], $l_a_Trap1[8], $l_a_Trap1[9], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            EndIf

            PathFinding_AddPortal($l_a_Portal)
            PathFinding_AddPTPortalConnection($l_a_Trap1[0], $g_a_PathingPortals[0])
            PathFinding_AddPTPortalConnection($l_a_Trap2[0], $g_a_PathingPortals[0])
            Return True

        Case 4 ; aRight_bLeft
            Local $l_b_O1 = PathFinding_OnSegment($l_a_Trap1[2], $l_a_Trap1[3], $l_a_Trap2[6], $l_a_Trap2[7], $l_a_Trap1[4], $l_a_Trap1[5])
            Local $l_b_O2 = PathFinding_OnSegment($l_a_Trap1[2], $l_a_Trap1[3], $l_a_Trap2[8], $l_a_Trap2[9], $l_a_Trap1[4], $l_a_Trap1[5])

            Local $l_a_Portal
            If $l_b_O1 And $l_b_O2 Then
                If PathFinding_GetSquareDistance($l_a_Trap2[8], $l_a_Trap2[9], $l_a_Trap2[6], $l_a_Trap2[7]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap2[8], $l_a_Trap2[9], $l_a_Trap2[6], $l_a_Trap2[7], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            ElseIf $l_b_O1 Then
                If PathFinding_GetSquareDistance($l_a_Trap2[6], $l_a_Trap2[7], $l_a_Trap1[2], $l_a_Trap1[3]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap2[6], $l_a_Trap2[7], $l_a_Trap1[2], $l_a_Trap1[3], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            ElseIf $l_b_O2 Then
                If PathFinding_GetSquareDistance($l_a_Trap1[4], $l_a_Trap1[5], $l_a_Trap2[8], $l_a_Trap2[9]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap1[4], $l_a_Trap1[5], $l_a_Trap2[8], $l_a_Trap2[9], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            Else
                If PathFinding_GetSquareDistance($l_a_Trap1[2], $l_a_Trap1[3], $l_a_Trap1[4], $l_a_Trap1[5]) < $l_f_SquareTolerance Then Return False
                $l_a_Portal = PathFinding_CreatePortal($l_a_Trap1[2], $l_a_Trap1[3], $l_a_Trap1[4], $l_a_Trap1[5], $a_i_AABB1ID - 1, $a_i_AABB2ID - 1)
            EndIf

            PathFinding_AddPortal($l_a_Portal)
            PathFinding_AddPTPortalConnection($l_a_Trap1[0], $g_a_PathingPortals[0])
            PathFinding_AddPTPortalConnection($l_a_Trap2[0], $g_a_PathingPortals[0])
            Return True
    EndSwitch

    Return False
EndFunc

Func PathFinding_AddPortal($a_a_Portal)
    Local $l_i_Index = $g_a_PathingPortals[0] + 1
    ReDim $g_a_PathingPortals[$l_i_Index + 1]
    $g_a_PathingPortals[$l_i_Index] = $a_a_Portal
    $g_a_PathingPortals[0] = $l_i_Index
EndFunc

Func PathFinding_AddAABBConnection($a_i_AABB1ID, $a_i_AABB2ID)
    ; Add to AABB1's connections
    If $g_a_PathingAABBGraph[$a_i_AABB1ID] = "" Then
        $g_a_PathingAABBGraph[$a_i_AABB1ID] = String($a_i_AABB2ID - 1)
    Else
        $g_a_PathingAABBGraph[$a_i_AABB1ID] &= "," & String($a_i_AABB2ID - 1)
    EndIf

    ; Add to AABB2's connections
    If $g_a_PathingAABBGraph[$a_i_AABB2ID] = "" Then
        $g_a_PathingAABBGraph[$a_i_AABB2ID] = String($a_i_AABB1ID - 1)
    Else
        $g_a_PathingAABBGraph[$a_i_AABB2ID] &= "," & String($a_i_AABB1ID - 1)
    EndIf
EndFunc

Func PathFinding_AddPTPortalConnection($a_i_TrapezoidID, $a_i_PortalID)
    ; Ensure the array is large enough
    Local $l_i_RequiredSize = $a_i_TrapezoidID + 2
    If UBound($g_a_PathingPTPortalGraph) < $l_i_RequiredSize Then
        ReDim $g_a_PathingPTPortalGraph[$l_i_RequiredSize]
        ; Initialize new elements
        For $i = UBound($g_a_PathingPTPortalGraph) - 1 To $l_i_RequiredSize - 1
            $g_a_PathingPTPortalGraph[$i] = ""
        Next
    EndIf

    If $g_a_PathingPTPortalGraph[$a_i_TrapezoidID + 1] = "" Then
        $g_a_PathingPTPortalGraph[$a_i_TrapezoidID + 1] = String($a_i_PortalID - 1)
    Else
        $g_a_PathingPTPortalGraph[$a_i_TrapezoidID + 1] &= "," & String($a_i_PortalID - 1)
    EndIf
EndFunc

Func PathFinding_HasLineOfSight($a_a_StartPoint, $a_a_GoalPoint, ByRef $a_a_BlockingIDs)
    ; Check if start and goal are in same AABB
    If ($a_a_StartPoint[3] > -1 And $a_a_GoalPoint[3] > -1 And $a_a_StartPoint[3] = $a_a_GoalPoint[3]) Or _
       ($a_a_StartPoint[3] > -1 And $a_a_GoalPoint[4] > -1 And $a_a_StartPoint[3] = $a_a_GoalPoint[4]) Or _
       ($a_a_StartPoint[4] > -1 And $a_a_GoalPoint[3] > -1 And $a_a_StartPoint[4] = $a_a_GoalPoint[3]) Or _
       ($a_a_StartPoint[4] > -1 And $a_a_GoalPoint[4] > -1 And $a_a_StartPoint[4] = $a_a_GoalPoint[4]) Then

        ; Add blocking IDs
        PathFinding_AddBlockingID($a_a_BlockingIDs, $a_a_StartPoint[3])
        PathFinding_AddBlockingID($a_a_BlockingIDs, $a_a_StartPoint[4])
        PathFinding_AddBlockingID($a_a_BlockingIDs, $a_a_GoalPoint[3])
        PathFinding_AddBlockingID($a_a_BlockingIDs, $a_a_GoalPoint[4])
        Return True
    EndIf

    ; Breadth-first search through AABBs
    Local $l_a_Open[100]
    Local $l_i_OpenCount = 0
    Local $l_a_Visited[$g_a_PathingAABBs[0] + 1]

    For $i = 0 To $g_a_PathingAABBs[0]
        $l_a_Visited[$i] = False
    Next

    ; Add start AABBs to open list
    If $a_a_StartPoint[3] > -1 Then
        $l_a_Open[$l_i_OpenCount] = $a_a_StartPoint[3]
        $l_i_OpenCount += 1
    EndIf
    If $a_a_StartPoint[4] > -1 And $a_a_StartPoint[4] <> $a_a_StartPoint[3] Then
        $l_a_Open[$l_i_OpenCount] = $a_a_StartPoint[4]
        $l_i_OpenCount += 1
    EndIf

    Local $l_i_LastLayer = 0

    While $l_i_OpenCount > 0
        ; Pop from open list
        $l_i_OpenCount -= 1
        Local $l_i_CurrentAABB = $l_a_Open[$l_i_OpenCount]

        If $l_a_Visited[$l_i_CurrentAABB] Then ContinueLoop
        $l_a_Visited[$l_i_CurrentAABB] = True

        ; Get portals of current AABB
        Local $l_a_CurrentAABBData = $g_a_PathingAABBs[$l_i_CurrentAABB + 1]
        If Not IsArray($l_a_CurrentAABBData) Then ContinueLoop

        Local $l_a_CurrentTrap = $g_a_PathingTrapezoids[$l_a_CurrentAABBData[5]]
        If Not IsArray($l_a_CurrentTrap) Then ContinueLoop

        ; Check bounds for PTPortalGraph access
        Local $l_i_PortalGraphIndex = $l_a_CurrentTrap[0] + 1
        If $l_i_PortalGraphIndex >= UBound($g_a_PathingPTPortalGraph) Then ContinueLoop

        Local $l_s_Portals = $g_a_PathingPTPortalGraph[$l_i_PortalGraphIndex]

        If $l_s_Portals <> "" Then
            Local $l_a_PortalIDs = StringSplit($l_s_Portals, ",", 2)

            For $i = 0 To UBound($l_a_PortalIDs) - 1
                Local $l_i_PortalID = Int($l_a_PortalIDs[$i]) + 1
                If $l_i_PortalID < 1 Or $l_i_PortalID > $g_a_PathingPortals[0] Then ContinueLoop

                Local $l_a_Portal = $g_a_PathingPortals[$l_i_PortalID]
                If Not IsArray($l_a_Portal) Then ContinueLoop

                ; Skip self-portal
                If $a_a_StartPoint[5] = $l_i_PortalID - 1 Then ContinueLoop

                ; Check if line passes through portal
                If Not PathFinding_PortalIntersect($l_a_Portal, $a_a_StartPoint[1], $a_a_StartPoint[2], $a_a_GoalPoint[1], $a_a_GoalPoint[2]) Then
                    ContinueLoop
                EndIf

                ; Add layer to blocking IDs
                If $l_i_LastLayer <> $l_a_CurrentTrap[1] Then
                    $l_i_LastLayer = $l_a_CurrentTrap[1]
                    If $l_i_LastLayer > 0 Then
                        PathFinding_AddBlockingID($a_a_BlockingIDs, $l_i_LastLayer)
                    EndIf
                EndIf

                ; Check if goal reached
                If ($a_a_GoalPoint[3] > -1 And $l_i_CurrentAABB = $a_a_GoalPoint[3]) Or _
                   ($a_a_GoalPoint[4] > -1 And $l_i_CurrentAABB = $a_a_GoalPoint[4]) Then
                    Return True
                EndIf

                ; Add connected AABBs to open list
                If $l_i_CurrentAABB <> $l_a_Portal[4] And $l_i_OpenCount < 100 Then
                    $l_a_Open[$l_i_OpenCount] = $l_a_Portal[4]
                    $l_i_OpenCount += 1
                EndIf
                If $l_i_CurrentAABB <> $l_a_Portal[5] And $l_i_OpenCount < 100 Then
                    $l_a_Open[$l_i_OpenCount] = $l_a_Portal[5]
                    $l_i_OpenCount += 1
                EndIf
            Next
        EndIf
    WEnd

    Return False
EndFunc

Func PathFinding_PortalIntersect($a_a_Portal, $a_f_P1X, $a_f_P1Y, $a_f_P2X, $a_f_P2Y)
    Return PathFinding_SegmentIntersect($a_a_Portal[0], $a_a_Portal[1], $a_a_Portal[2], $a_a_Portal[3], _
                                        $a_f_P1X, $a_f_P1Y, $a_f_P2X, $a_f_P2Y)
EndFunc

Func PathFinding_SegmentIntersect($a_f_P1X, $a_f_P1Y, $a_f_Q1X, $a_f_Q1Y, $a_f_P2X, $a_f_P2Y, $a_f_Q2X, $a_f_Q2Y)
    Local $l_f_Eps = 0.001
    Local $l_f_Denom = ($a_f_Q2Y - $a_f_P2Y) * ($a_f_Q1X - $a_f_P1X) - ($a_f_Q2X - $a_f_P2X) * ($a_f_Q1Y - $a_f_P1Y)

    ; Parallel lines
    If Abs($l_f_Denom) < $l_f_Eps Then Return False

    Local $l_f_NumA = ($a_f_Q2X - $a_f_P2X) * ($a_f_P1Y - $a_f_P2Y) - ($a_f_Q2Y - $a_f_P2Y) * ($a_f_P1X - $a_f_P2X)
    Local $l_f_NumB = ($a_f_Q1X - $a_f_P1X) * ($a_f_P1Y - $a_f_P2Y) - ($a_f_Q1Y - $a_f_P1Y) * ($a_f_P1X - $a_f_P2X)

    ; Coincident lines
    If Abs($l_f_NumA) < $l_f_Eps And Abs($l_f_NumB) < $l_f_Eps Then Return True

    ; Check intersection
    Local $l_f_MuA = $l_f_NumA / $l_f_Denom
    Local $l_f_MuB = $l_f_NumB / $l_f_Denom

    Return $l_f_MuA >= 0 And $l_f_MuA <= 1 And $l_f_MuB >= 0 And $l_f_MuB <= 1
EndFunc

Func PathFinding_AddBlockingID(ByRef $a_a_BlockingIDs, $a_i_BoxID)
    If $a_i_BoxID < 0 Then Return

    ; Check if already exists
    For $i = 1 To $a_a_BlockingIDs[0]
        If $a_a_BlockingIDs[$i] = $a_i_BoxID Then Return
    Next

    ; Add new ID
    Local $l_i_Index = $a_a_BlockingIDs[0] + 1
    If $l_i_Index >= UBound($a_a_BlockingIDs) Then
        ReDim $a_a_BlockingIDs[$l_i_Index + 10]
    EndIf

    $a_a_BlockingIDs[$l_i_Index] = $a_i_BoxID
    $a_a_BlockingIDs[0] = $l_i_Index
EndFunc

Func PathFinding_HasBlockedLayers($a_a_BlockingIDs, $a_a_BlockArray)
    For $i = 1 To $a_a_BlockingIDs[0]
        Local $l_i_Layer = $a_a_BlockingIDs[$i]
        If $l_i_Layer < UBound($a_a_BlockArray) And $a_a_BlockArray[$l_i_Layer] <> 0 Then
            Return True
        EndIf
    Next
    Return False
EndFunc

Func PathFinding_AlreadyInVisGraph($a_i_PointID1, $a_i_PointID2)
    Local $l_s_Connections = $g_a_PathingVisGraph[$a_i_PointID1]
    If $l_s_Connections = "" Then Return False

    Local $l_a_Connections = StringSplit($l_s_Connections, "|", 2)
    For $i = 0 To UBound($l_a_Connections) - 1
        Local $l_a_ConnData = StringSplit($l_a_Connections[$i], ",", 2)
        If UBound($l_a_ConnData) >= 1 And Int($l_a_ConnData[0]) = $a_i_PointID2 Then
            Return True
        EndIf
    Next

    Return False
EndFunc

Func PathFinding_AddToVisGraph($a_i_FromID, $a_i_ToID, $a_f_Distance, $a_a_BlockingIDs)
    ; Format: "point_id,distance,blocking_id1,blocking_id2,..."
    Local $l_s_Connection = $a_i_ToID & "," & $a_f_Distance

    For $i = 1 To $a_a_BlockingIDs[0]
        $l_s_Connection &= "," & $a_a_BlockingIDs[$i]
    Next

    If $g_a_PathingVisGraph[$a_i_FromID] = "" Then
        $g_a_PathingVisGraph[$a_i_FromID] = $l_s_Connection
    Else
        $g_a_PathingVisGraph[$a_i_FromID] &= "|" & $l_s_Connection
    EndIf
EndFunc

Func PathFinding_InsertPointIntoVisGraph($a_a_Point)
    Local $l_f_SqRange = $GC_F_MAX_VISIBILITY_RANGE * $GC_F_MAX_VISIBILITY_RANGE
    Local $l_i_ConnectionCount = 0
    Local $l_f_MinConnectionRange = 500.0 ; Distance minimale pour garantir des connexions
    Local $l_f_MinSqRange = $l_f_MinConnectionRange * $l_f_MinConnectionRange

    ; Structure pour stocker les connexions potentielles triées par distance
    Local $l_a_PotentialConnections[100][3] ; [point_id, distance, blocking_ids_string]
    Local $l_i_PotentialCount = 0

    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_P = $g_a_PathingPoints[$i]
        If Not IsArray($l_a_P) Then ContinueLoop

        Local $l_f_SqDist = PathFinding_GetSquareDistance($l_a_P[1], $l_a_P[2], $a_a_Point[1], $a_a_Point[2])

        ; Ignorer les points trop éloignés
        If $l_f_SqDist > $l_f_SqRange Then ContinueLoop

        ; Ignorer le point lui-même
        If $l_f_SqDist < 1 Then ContinueLoop

        Local $l_a_BlockingIDs[1]
        $l_a_BlockingIDs[0] = 0

        If PathFinding_HasLineOfSight($l_a_P, $a_a_Point, $l_a_BlockingIDs) Then
            Local $l_f_Distance = Sqrt($l_f_SqDist)

            ; Convertir blocking IDs en string pour stockage
            Local $l_s_BlockingIDs = ""
            For $j = 1 To $l_a_BlockingIDs[0]
                If $l_s_BlockingIDs <> "" Then $l_s_BlockingIDs &= ","
                $l_s_BlockingIDs &= $l_a_BlockingIDs[$j]
            Next

            ; Ajouter à la liste des connexions potentielles
            If $l_i_PotentialCount < 100 Then
                $l_a_PotentialConnections[$l_i_PotentialCount][0] = $l_a_P[0]
                $l_a_PotentialConnections[$l_i_PotentialCount][1] = $l_f_Distance
                $l_a_PotentialConnections[$l_i_PotentialCount][2] = $l_s_BlockingIDs
                $l_i_PotentialCount += 1
            EndIf
        EndIf
    Next

    ; Trier les connexions par distance (du plus proche au plus éloigné)
    For $i = 0 To $l_i_PotentialCount - 2
        For $j = $i + 1 To $l_i_PotentialCount - 1
            If $l_a_PotentialConnections[$j][1] < $l_a_PotentialConnections[$i][1] Then
                ; Swap
                Local $l_a_Temp[3]
                For $k = 0 To 2
                    $l_a_Temp[$k] = $l_a_PotentialConnections[$i][$k]
                    $l_a_PotentialConnections[$i][$k] = $l_a_PotentialConnections[$j][$k]
                    $l_a_PotentialConnections[$j][$k] = $l_a_Temp[$k]
                Next
            EndIf
        Next
    Next

    ; Ajouter les connexions, en garantissant au moins quelques connexions proches
    Local $l_i_MinConnections = 3 ; Nombre minimum de connexions à garantir
    Local $l_i_MaxConnections = 20 ; Nombre maximum de connexions pour éviter la surcharge

    For $i = 0 To $l_i_PotentialCount - 1
        If $l_i_ConnectionCount >= $l_i_MaxConnections Then ExitLoop

        ; Forcer l'ajout des premières connexions même si elles sont loin
        If $l_i_ConnectionCount < $l_i_MinConnections Or $l_a_PotentialConnections[$i][1] < $GC_F_MAX_VISIBILITY_RANGE Then
            ; Reconstruire le tableau blocking IDs
            Local $l_a_BlockingIDs[1]
            $l_a_BlockingIDs[0] = 0

            If $l_a_PotentialConnections[$i][2] <> "" Then
                Local $l_a_BlockingParts = StringSplit($l_a_PotentialConnections[$i][2], ",", 2)
                ReDim $l_a_BlockingIDs[UBound($l_a_BlockingParts) + 1]
                $l_a_BlockingIDs[0] = UBound($l_a_BlockingParts)
                For $j = 0 To UBound($l_a_BlockingParts) - 1
                    $l_a_BlockingIDs[$j + 1] = Int($l_a_BlockingParts[$j])
                Next
            EndIf

            ; Ajouter les connexions bidirectionnelles
            PathFinding_AddToVisGraph($a_a_Point[0], $l_a_PotentialConnections[$i][0], $l_a_PotentialConnections[$i][1], $l_a_BlockingIDs)
            PathFinding_AddToVisGraph($l_a_PotentialConnections[$i][0], $a_a_Point[0], $l_a_PotentialConnections[$i][1], $l_a_BlockingIDs)
            $l_i_ConnectionCount += 1
        EndIf
    Next

    ; Si aucune connexion n'a été trouvée, essayer une approche de secours
    If $l_i_ConnectionCount = 0 Then
        Log_Warning("No visibility connections found for point " & $a_a_Point[0] & ", trying fallback approach", "PathFinding", $g_h_EditText)

        ; Connecter aux points les plus proches dans le même AABB ou les AABBs adjacents
        If $a_a_Point[3] >= 0 Then
            PathFinding_ConnectToNearestInAABB($a_a_Point)
        EndIf
    EndIf

    Log_Debug("Added " & $l_i_ConnectionCount & " connections for temporary point", "PathFinding", $g_h_EditText)
EndFunc

; Nouvelle fonction pour connecter aux points dans le même AABB
Func PathFinding_ConnectToNearestInAABB($a_a_Point)
    Local $l_i_ConnectionCount = 0
    Local $l_f_MaxDistanceInAABB = 2000.0 ; Distance max pour connexion dans le même AABB

    ; Trouver tous les points dans le même AABB ou les AABBs adjacents
    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_P = $g_a_PathingPoints[$i]
        If Not IsArray($l_a_P) Then ContinueLoop

        ; Vérifier si le point est dans le même AABB ou un AABB adjacent
        Local $l_b_InSameOrAdjacentAABB = False

        If ($a_a_Point[3] >= 0 And $l_a_P[3] >= 0 And $a_a_Point[3] = $l_a_P[3]) Or _
           ($a_a_Point[3] >= 0 And $l_a_P[4] >= 0 And $a_a_Point[3] = $l_a_P[4]) Or _
           ($a_a_Point[4] >= 0 And $l_a_P[3] >= 0 And $a_a_Point[4] = $l_a_P[3]) Or _
           ($a_a_Point[4] >= 0 And $l_a_P[4] >= 0 And $a_a_Point[4] = $l_a_P[4]) Then
            $l_b_InSameOrAdjacentAABB = True
        Else
            ; Vérifier si les AABBs sont connectés
            If $a_a_Point[3] >= 0 And $l_a_P[3] >= 0 Then
                If PathFinding_QuickAABBConnectionCheck($a_a_Point[3], $l_a_P[3]) Then
                    $l_b_InSameOrAdjacentAABB = True
                EndIf
            EndIf
        EndIf

        If $l_b_InSameOrAdjacentAABB Then
            Local $l_f_Distance = PathFinding_Distance2D($a_a_Point[1], $a_a_Point[2], $l_a_P[1], $l_a_P[2])

            If $l_f_Distance < $l_f_MaxDistanceInAABB And $l_f_Distance > 1 Then
                Local $l_a_BlockingIDs[1]
                $l_a_BlockingIDs[0] = 0

                ; Ajouter les AABBs comme blocking IDs
                PathFinding_AddBlockingID($l_a_BlockingIDs, $a_a_Point[3])
                PathFinding_AddBlockingID($l_a_BlockingIDs, $l_a_P[3])

                PathFinding_AddToVisGraph($a_a_Point[0], $l_a_P[0], $l_f_Distance, $l_a_BlockingIDs)
                PathFinding_AddToVisGraph($l_a_P[0], $a_a_Point[0], $l_f_Distance, $l_a_BlockingIDs)

                $l_i_ConnectionCount += 1

                If $l_i_ConnectionCount >= 3 Then ExitLoop ; Au moins 3 connexions
            EndIf
        EndIf
    Next

    Log_Info("Added " & $l_i_ConnectionCount & " fallback connections in same/adjacent AABBs", "PathFinding", $g_h_EditText)
EndFunc

Func PathFinding_GetSquareDistance($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    Local $l_f_DX = $a_f_X2 - $a_f_X1
    Local $l_f_DY = $a_f_Y2 - $a_f_Y1
    Return $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY
EndFunc

Func PathFinding_GetTrapezoidCount()
    If Not IsArray($g_a_PathingTrapezoids) Then Return 0
    Return $g_a_PathingTrapezoids[0]
EndFunc

Func PathFinding_GetAABBCount()
    If Not IsArray($g_a_PathingAABBs) Then Return 0
    Return $g_a_PathingAABBs[0]
EndFunc

Func PathFinding_GetPortalCount()
    If Not IsArray($g_a_PathingPortals) Then Return 0
    Return $g_a_PathingPortals[0]
EndFunc

Func PathFinding_GetPointCount()
    If Not IsArray($g_a_PathingPoints) Then Return 0
    Return $g_a_PathingPoints[0]
EndFunc

Func PathFinding_GetTeleportCount()
    If Not IsArray($g_a_PathingTeleports) Then Return 0
    Return $g_a_PathingTeleports[0]
EndFunc