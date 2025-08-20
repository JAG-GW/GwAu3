#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <Math.au3>

; ============================================================================
; Global variables for pathfinding data
; ============================================================================
Global $g_av_MapData = 0
Global $g_av_Metadata = 0
Global $g_av_Trapezoids = 0
Global $g_av_AABBs = 0
Global $g_av_Portals = 0
Global $g_av_Points = 0
Global $g_av_VisibilityGraph = 0
Global $g_av_AABBGraph = 0
Global $g_av_PortalGraph = 0
Global $g_av_Teleports = 0
Global $g_av_TeleportGraph = 0
Global $g_av_TravelPortals = 0

; Priority Queue for A*
Global $g_af2_PriorityQueue[1][2]
Global $g_i_PQSize = 0

; Constants
Global Const $GC_F_MAX_VISIBILITY_RANGE = 5000.0
Global Const $GC_I_INFINITY = 999999999
Global Const $GC_I_UINT32_MAX = 4294967295

; ============================================================================
; Priority Queue Implementation
; ============================================================================

Func PQ_Init()
    Global $g_af2_PriorityQueue[1][2]
    Global $g_i_PQSize = 0
EndFunc

Func PQ_Push($a_f_Priority, $a_v_Value)
    $g_i_PQSize += 1
    ReDim $g_af2_PriorityQueue[$g_i_PQSize + 1][2]
    $g_af2_PriorityQueue[$g_i_PQSize][0] = $a_f_Priority
    $g_af2_PriorityQueue[$g_i_PQSize][1] = $a_v_Value

    ; Bubble up
    Local $l_i_Index = $g_i_PQSize
    While $l_i_Index > 1
        Local $l_i_Parent = Int($l_i_Index / 2)
        If $g_af2_PriorityQueue[$l_i_Index][0] < $g_af2_PriorityQueue[$l_i_Parent][0] Then
            ; Swap
            Local $l_af_Temp[2] = [$g_af2_PriorityQueue[$l_i_Index][0], $g_af2_PriorityQueue[$l_i_Index][1]]
            $g_af2_PriorityQueue[$l_i_Index][0] = $g_af2_PriorityQueue[$l_i_Parent][0]
            $g_af2_PriorityQueue[$l_i_Index][1] = $g_af2_PriorityQueue[$l_i_Parent][1]
            $g_af2_PriorityQueue[$l_i_Parent][0] = $l_af_Temp[0]
            $g_af2_PriorityQueue[$l_i_Parent][1] = $l_af_Temp[1]
            $l_i_Index = $l_i_Parent
        Else
            ExitLoop
        EndIf
    WEnd
EndFunc

Func PQ_Pop()
    If $g_i_PQSize = 0 Then Return -1

    Local $l_v_Result = $g_af2_PriorityQueue[1][1]

    ; Move last element to root
    $g_af2_PriorityQueue[1][0] = $g_af2_PriorityQueue[$g_i_PQSize][0]
    $g_af2_PriorityQueue[1][1] = $g_af2_PriorityQueue[$g_i_PQSize][1]
    $g_i_PQSize -= 1

    If $g_i_PQSize = 0 Then Return $l_v_Result

    ; Bubble down
    Local $l_i_Index = 1
    While $l_i_Index * 2 <= $g_i_PQSize
        Local $l_i_LeftChild = $l_i_Index * 2
        Local $l_i_RightChild = $l_i_Index * 2 + 1
        Local $l_i_Smallest = $l_i_Index

        If $l_i_LeftChild <= $g_i_PQSize And $g_af2_PriorityQueue[$l_i_LeftChild][0] < $g_af2_PriorityQueue[$l_i_Smallest][0] Then
            $l_i_Smallest = $l_i_LeftChild
        EndIf

        If $l_i_RightChild <= $g_i_PQSize And $g_af2_PriorityQueue[$l_i_RightChild][0] < $g_af2_PriorityQueue[$l_i_Smallest][0] Then
            $l_i_Smallest = $l_i_RightChild
        EndIf

        If $l_i_Smallest <> $l_i_Index Then
            ; Swap
            Local $l_af_Temp[2] = [$g_af2_PriorityQueue[$l_i_Index][0], $g_af2_PriorityQueue[$l_i_Index][1]]
            $g_af2_PriorityQueue[$l_i_Index][0] = $g_af2_PriorityQueue[$l_i_Smallest][0]
            $g_af2_PriorityQueue[$l_i_Index][1] = $g_af2_PriorityQueue[$l_i_Smallest][1]
            $g_af2_PriorityQueue[$l_i_Smallest][0] = $l_af_Temp[0]
            $g_af2_PriorityQueue[$l_i_Smallest][1] = $l_af_Temp[1]
            $l_i_Index = $l_i_Smallest
        Else
            ExitLoop
        EndIf
    WEnd

    Return $l_v_Result
EndFunc

Func PQ_IsEmpty()
    Return $g_i_PQSize = 0
EndFunc

; ============================================================================
; Data Loading Functions
; ============================================================================

Func Pathfinding_LoadData($a_s_FilePath)
    Local $l_s_FileContent = FileRead($a_s_FilePath)
    If @error Then
        ConsoleWrite("Error reading file: " & $a_s_FilePath & @CRLF)
        Return False
    EndIf

    ; Parse file content by sections
    Local $l_as_Lines = StringSplit($l_s_FileContent, @CRLF, 1)
    Local $l_s_CurrentSection = ""
    Local $l_i_Index = 1

    While $l_i_Index <= $l_as_Lines[0]
        Local $l_s_Line = StringStripWS($l_as_Lines[$l_i_Index], 3)

        If StringLeft($l_s_Line, 1) = "[" And StringRight($l_s_Line, 1) = "]" Then
            $l_s_CurrentSection = StringMid($l_s_Line, 2, StringLen($l_s_Line) - 2)
            ConsoleWrite("Loading section: " & $l_s_CurrentSection & @CRLF)
        ElseIf $l_s_Line <> "" Then
            Switch $l_s_CurrentSection
                Case "METADATA"
                    Pathfinding_ParseMetadata($l_s_Line)
                Case "TRAPEZOIDS"
                    Pathfinding_ParseTrapezoids($l_as_Lines, $l_i_Index)
                Case "AABBS"
                    Pathfinding_ParseAABBs($l_as_Lines, $l_i_Index)
                Case "PORTALS"
                    Pathfinding_ParsePortals($l_as_Lines, $l_i_Index)
                Case "POINTS"
                    Pathfinding_ParsePoints($l_as_Lines, $l_i_Index)
                Case "VISIBILITY_GRAPH"
                    Pathfinding_ParseVisibilityGraph($l_as_Lines, $l_i_Index)
                Case "AABB_GRAPH"
                    Pathfinding_ParseAABBGraph($l_as_Lines, $l_i_Index)
                Case "PORTAL_GRAPH"
                    Pathfinding_ParsePortalGraph($l_as_Lines, $l_i_Index)
                Case "TELEPORTS"
                    Pathfinding_ParseTeleports($l_as_Lines, $l_i_Index)
                Case "TELEPORT_GRAPH"
                    Pathfinding_ParseTeleportGraph($l_as_Lines, $l_i_Index)
                Case "TRAVEL_PORTALS"
                    Pathfinding_ParseTravelPortals($l_as_Lines, $l_i_Index)
            EndSwitch
        EndIf

        $l_i_Index += 1
    WEnd

    ConsoleWrite("Data loaded successfully!" & @CRLF)
    ConsoleWrite("Points: " & UBound($g_av_Points) & @CRLF)
    ConsoleWrite("Portals: " & UBound($g_av_Portals) & @CRLF)
    ConsoleWrite("AABBs: " & UBound($g_av_AABBs) & @CRLF)
    ConsoleWrite("Teleports: " & UBound($g_av_Teleports) & @CRLF)

    Return True
EndFunc

Func Pathfinding_ParseMetadata($a_s_Line)
    If Not IsArray($g_av_Metadata) Then
        Dim $g_av_Metadata[20][2]
    EndIf

    Local $l_as_Parts = StringSplit($a_s_Line, "=", 2)
    If UBound($l_as_Parts) >= 2 Then
        ; Store metadata (you can expand this as needed)
    EndIf
EndFunc

Func Pathfinding_ParseTrapezoids(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_Trapezoids[$l_i_Count][6] ; id, layer, ax, ay, bx, by, cx, cy, dx, dy

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_as_Parts = StringSplit($a_as_Lines[$a_i_Index], "|", 2)
            If UBound($l_as_Parts) >= 6 Then
                $g_av_Trapezoids[$l_i_Idx][0] = Number($l_as_Parts[0]) ; id
                $g_av_Trapezoids[$l_i_Idx][1] = Number($l_as_Parts[1]) ; layer

                ; Parse vertices
                Local $l_as_VertexA = StringSplit($l_as_Parts[2], ",", 2)
                Local $l_as_VertexB = StringSplit($l_as_Parts[3], ",", 2)
                Local $l_as_VertexC = StringSplit($l_as_Parts[4], ",", 2)
                Local $l_as_VertexD = StringSplit($l_as_Parts[5], ",", 2)

                $g_av_Trapezoids[$l_i_Idx][2] = Number($l_as_VertexA[0]) ; ax
                $g_av_Trapezoids[$l_i_Idx][3] = Number($l_as_VertexA[1]) ; ay
                $g_av_Trapezoids[$l_i_Idx][4] = Number($l_as_VertexB[0]) ; bx
                $g_av_Trapezoids[$l_i_Idx][5] = Number($l_as_VertexB[1]) ; by
                ; Store c and d similarly if needed
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParseAABBs(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_AABBs[$l_i_Count][7] ; id, pos_x, pos_y, half_x, half_y, trap_id, layer

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_as_Parts = StringSplit($a_as_Lines[$a_i_Index], "|", 2)
            If UBound($l_as_Parts) >= 5 Then
                $g_av_AABBs[$l_i_Idx][0] = Number($l_as_Parts[0]) ; id

                Local $l_as_Pos = StringSplit($l_as_Parts[1], ",", 2)
                $g_av_AABBs[$l_i_Idx][1] = Number($l_as_Pos[0]) ; pos_x
                $g_av_AABBs[$l_i_Idx][2] = Number($l_as_Pos[1]) ; pos_y

                Local $l_as_Half = StringSplit($l_as_Parts[2], ",", 2)
                $g_av_AABBs[$l_i_Idx][3] = Number($l_as_Half[0]) ; half_x
                $g_av_AABBs[$l_i_Idx][4] = Number($l_as_Half[1]) ; half_y

                $g_av_AABBs[$l_i_Idx][5] = Number($l_as_Parts[3]) ; trap_id
                $g_av_AABBs[$l_i_Idx][6] = Number($l_as_Parts[4]) ; layer
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParsePortals(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_Portals[$l_i_Count][7] ; id, start_x, start_y, goal_x, goal_y, box1_id, box2_id

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_as_Parts = StringSplit($a_as_Lines[$a_i_Index], "|", 2)
            If UBound($l_as_Parts) >= 5 Then
                $g_av_Portals[$l_i_Idx][0] = Number($l_as_Parts[0]) ; id

                Local $l_as_Start = StringSplit($l_as_Parts[1], ",", 2)
                $g_av_Portals[$l_i_Idx][1] = Number($l_as_Start[0]) ; start_x
                $g_av_Portals[$l_i_Idx][2] = Number($l_as_Start[1]) ; start_y

                Local $l_as_Goal = StringSplit($l_as_Parts[2], ",", 2)
                $g_av_Portals[$l_i_Idx][3] = Number($l_as_Goal[0]) ; goal_x
                $g_av_Portals[$l_i_Idx][4] = Number($l_as_Goal[1]) ; goal_y

                $g_av_Portals[$l_i_Idx][5] = Number($l_as_Parts[3]) ; box1_id
                $g_av_Portals[$l_i_Idx][6] = Number($l_as_Parts[4]) ; box2_id
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParsePoints(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_Points[$l_i_Count][7] ; id, pos_x, pos_y, box_id, layer, box2_id, portal_id

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_as_Parts = StringSplit($a_as_Lines[$a_i_Index], "|", 2)
            If UBound($l_as_Parts) >= 6 Then
                $g_av_Points[$l_i_Idx][0] = Number($l_as_Parts[0]) ; id

                Local $l_as_Pos = StringSplit($l_as_Parts[1], ",", 2)
                $g_av_Points[$l_i_Idx][1] = Number($l_as_Pos[0]) ; pos_x
                $g_av_Points[$l_i_Idx][2] = Number($l_as_Pos[1]) ; pos_y

                $g_av_Points[$l_i_Idx][3] = Number($l_as_Parts[2]) ; box_id
                $g_av_Points[$l_i_Idx][4] = Number($l_as_Parts[3]) ; layer
                $g_av_Points[$l_i_Idx][5] = Number($l_as_Parts[4]) ; box2_id
                $g_av_Points[$l_i_Idx][6] = Number($l_as_Parts[5]) ; portal_id
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParseVisibilityGraph(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_VisibilityGraph[$l_i_Count]

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_s_Line = $a_as_Lines[$a_i_Index]
            Local $l_i_EqPos = StringInStr($l_s_Line, "=")
            Local $l_i_PipePos = StringInStr($l_s_Line, "|")

            If $l_i_PipePos > 0 Then
                Local $l_s_EdgesStr = StringMid($l_s_Line, $l_i_PipePos + 1)
                Local $l_as_Edges = StringSplit($l_s_EdgesStr, ";", 2)

                Local $l_i_EdgeCount = UBound($l_as_Edges)
                If $l_i_EdgeCount > 0 Then
                    Dim $l_amx2_EdgeArray[$l_i_EdgeCount][3] ; point_id, distance, blocking_ids

                    For $l_i_EdgeIdx = 0 To $l_i_EdgeCount - 1
                        ; Parse "point_id,distance,[blocking_ids]"
                        Local $l_as_EdgeParts = StringSplit($l_as_Edges[$l_i_EdgeIdx], ",", 2)
                        If UBound($l_as_EdgeParts) >= 2 Then
                            $l_amx2_EdgeArray[$l_i_EdgeIdx][0] = Number($l_as_EdgeParts[0]) ; point_id
                            $l_amx2_EdgeArray[$l_i_EdgeIdx][1] = Number($l_as_EdgeParts[1]) ; distance

                            ; Parse blocking IDs if present
                            Local $l_s_BlockingStr = ""
                            For $l_i_PartIdx = 2 To UBound($l_as_EdgeParts) - 1
                                $l_s_BlockingStr &= $l_as_EdgeParts[$l_i_PartIdx]
                                If $l_i_PartIdx < UBound($l_as_EdgeParts) - 1 Then $l_s_BlockingStr &= ","
                            Next

                            $l_s_BlockingStr = StringReplace($l_s_BlockingStr, "[", "")
                            $l_s_BlockingStr = StringReplace($l_s_BlockingStr, "]", "")

                            If $l_s_BlockingStr <> "" Then
                                $l_amx2_EdgeArray[$l_i_EdgeIdx][2] = $l_s_BlockingStr
                            Else
                                $l_amx2_EdgeArray[$l_i_EdgeIdx][2] = ""
                            EndIf
                        EndIf
                    Next

                    $g_av_VisibilityGraph[$l_i_Idx] = $l_amx2_EdgeArray
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParseAABBGraph(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_AABBGraph[$l_i_Count]

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_s_Line = $a_as_Lines[$a_i_Index]
            Local $l_i_EqPos = StringInStr($l_s_Line, "=")

            If $l_i_EqPos > 0 Then
                Local $l_s_NeighborsStr = StringMid($l_s_Line, $l_i_EqPos + 1)
                If $l_s_NeighborsStr <> "" Then
                    Local $l_as_Neighbors = StringSplit($l_s_NeighborsStr, ",", 2)
                    $g_av_AABBGraph[$l_i_Idx] = $l_as_Neighbors
                Else
                    Dim $l_av_Empty[0]
                    $g_av_AABBGraph[$l_i_Idx] = $l_av_Empty
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParsePortalGraph(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_PortalGraph[$l_i_Count]

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_s_Line = $a_as_Lines[$a_i_Index]
            Local $l_i_EqPos = StringInStr($l_s_Line, "=")

            If $l_i_EqPos > 0 Then
                Local $l_s_PortalsStr = StringMid($l_s_Line, $l_i_EqPos + 1)
                If $l_s_PortalsStr <> "" Then
                    Local $l_as_Portals = StringSplit($l_s_PortalsStr, ",", 2)
                    $g_av_PortalGraph[$l_i_Idx] = $l_as_Portals
                Else
                    Dim $l_av_Empty[0]
                    $g_av_PortalGraph[$l_i_Idx] = $l_av_Empty
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParseTeleports(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_Teleports[$l_i_Count][7] ; enter_x, enter_y, enter_z, exit_x, exit_y, exit_z, bidirectional

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_as_Parts = StringSplit($a_as_Lines[$a_i_Index], "|", 2)
            If UBound($l_as_Parts) >= 3 Then
                Local $l_as_Enter = StringSplit($l_as_Parts[0], ",", 2)
                $g_av_Teleports[$l_i_Idx][0] = Number($l_as_Enter[0]) ; enter_x
                $g_av_Teleports[$l_i_Idx][1] = Number($l_as_Enter[1]) ; enter_y
                $g_av_Teleports[$l_i_Idx][2] = Number($l_as_Enter[2]) ; enter_z

                Local $l_as_Exit = StringSplit($l_as_Parts[1], ",", 2)
                $g_av_Teleports[$l_i_Idx][3] = Number($l_as_Exit[0]) ; exit_x
                $g_av_Teleports[$l_i_Idx][4] = Number($l_as_Exit[1]) ; exit_y
                $g_av_Teleports[$l_i_Idx][5] = Number($l_as_Exit[2]) ; exit_z

                $g_av_Teleports[$l_i_Idx][6] = Number($l_as_Parts[2]) ; bidirectional
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParseTeleportGraph(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_TeleportGraph[$l_i_Count][3] ; tp1_index, tp2_index, distance

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_as_Parts = StringSplit($a_as_Lines[$a_i_Index], "|", 2)
            If UBound($l_as_Parts) >= 3 Then
                $g_av_TeleportGraph[$l_i_Idx][0] = Number($l_as_Parts[0]) ; tp1_index
                $g_av_TeleportGraph[$l_i_Idx][1] = Number($l_as_Parts[1]) ; tp2_index
                $g_av_TeleportGraph[$l_i_Idx][2] = Number($l_as_Parts[2]) ; distance
            EndIf
        Next
    EndIf
EndFunc

Func Pathfinding_ParseTravelPortals(ByRef $a_as_Lines, ByRef $a_i_Index)
    Local $l_s_Line = $a_as_Lines[$a_i_Index]
    If StringInStr($l_s_Line, "count=") Then
        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
        Dim $g_av_TravelPortals[$l_i_Count][3] ; pos_x, pos_y, model_id

        For $l_i_Idx = 0 To $l_i_Count - 1
            $a_i_Index += 1
            Local $l_as_Parts = StringSplit($a_as_Lines[$a_i_Index], "|", 2)
            If UBound($l_as_Parts) >= 2 Then
                Local $l_as_Pos = StringSplit($l_as_Parts[0], ",", 2)
                $g_av_TravelPortals[$l_i_Idx][0] = Number($l_as_Pos[0]) ; pos_x
                $g_av_TravelPortals[$l_i_Idx][1] = Number($l_as_Pos[1]) ; pos_y
                $g_av_TravelPortals[$l_i_Idx][2] = Number($l_as_Parts[1]) ; model_id
            EndIf
        Next
    EndIf
EndFunc

; ============================================================================
; Pathfinding Functions
; ============================================================================

Func Pathfinding_GetDistance($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    Return Sqrt(($a_f_X2 - $a_f_X1) * ($a_f_X2 - $a_f_X1) + ($a_f_Y2 - $a_f_Y1) * ($a_f_Y2 - $a_f_Y1))
EndFunc

Func Pathfinding_GetSquareDistance($a_f_X1, $a_f_Y1, $a_f_X2, $a_f_Y2)
    Return ($a_f_X2 - $a_f_X1) * ($a_f_X2 - $a_f_X1) + ($a_f_Y2 - $a_f_Y1) * ($a_f_Y2 - $a_f_Y1)
EndFunc

Func Pathfinding_IsPointInAABB($a_f_PosX, $a_f_PosY, $a_i_AABBIndex)
    If $a_i_AABBIndex >= UBound($g_av_AABBs) Or $a_i_AABBIndex < 0 Then Return False

    Local $l_f_CenterX = $g_av_AABBs[$a_i_AABBIndex][1]
    Local $l_f_CenterY = $g_av_AABBs[$a_i_AABBIndex][2]
    Local $l_f_HalfX = $g_av_AABBs[$a_i_AABBIndex][3]
    Local $l_f_HalfY = $g_av_AABBs[$a_i_AABBIndex][4]

    If Abs($a_f_PosX - $l_f_CenterX) > $l_f_HalfX Then Return False
    If Abs($a_f_PosY - $l_f_CenterY) > $l_f_HalfY Then Return False

    Return True
EndFunc

Func Pathfinding_FindAABB($a_f_X, $a_f_Y, $a_i_Layer = 0)
    For $l_i_Idx = 0 To UBound($g_av_AABBs) - 1
        If $g_av_AABBs[$l_i_Idx][6] = $a_i_Layer Then ; Check layer
            If Pathfinding_IsPointInAABB($a_f_X, $a_f_Y, $l_i_Idx) Then
                Return $l_i_Idx
            EndIf
        EndIf
    Next

    Return -1
EndFunc

Func Pathfinding_FindClosestPoint($a_f_X, $a_f_Y, $a_i_Layer = 0)
    Local $l_i_ClosestIndex = -1
    Local $l_f_MinDist = $GC_I_INFINITY

    For $l_i_Idx = 0 To UBound($g_av_Points) - 1
        Local $l_f_PointX = $g_av_Points[$l_i_Idx][1]
        Local $l_f_PointY = $g_av_Points[$l_i_Idx][2]
        Local $l_i_PointLayer = $g_av_Points[$l_i_Idx][4]

        ; Consider layer difference as additional distance
        Local $l_f_LayerPenalty = Abs($l_i_PointLayer - $a_i_Layer) * 1000
        Local $l_f_Dist = Pathfinding_GetSquareDistance($a_f_X, $a_f_Y, $l_f_PointX, $l_f_PointY) + $l_f_LayerPenalty

        If $l_f_Dist < $l_f_MinDist Then
            $l_f_MinDist = $l_f_Dist
            $l_i_ClosestIndex = $l_i_Idx
        EndIf
    Next

    Return $l_i_ClosestIndex
EndFunc

Func Pathfinding_GetClosestPointOnMap($a_f_X, $a_f_Y, $a_i_Layer = 0)
    ; Check if already on pathing map
    Local $l_i_AABBIdx = Pathfinding_FindAABB($a_f_X, $a_f_Y, $a_i_Layer)
    If $l_i_AABBIdx >= 0 Then
        Local $l_af_Result[3] = [$a_f_X, $a_f_Y, $a_i_Layer]
        Return $l_af_Result
    EndIf

    ; Find closest point
    Local $l_i_ClosestIdx = Pathfinding_FindClosestPoint($a_f_X, $a_f_Y, $a_i_Layer)
    If $l_i_ClosestIdx >= 0 Then
        Local $l_af_Result[3] = [$g_av_Points[$l_i_ClosestIdx][1], $g_av_Points[$l_i_ClosestIdx][2], $g_av_Points[$l_i_ClosestIdx][4]]
        Return $l_af_Result
    EndIf

    Local $l_af_Result[3] = [0, 0, 0]
    Return $l_af_Result
EndFunc

Func Pathfinding_IsPathBlocked($a_s_BlockingIdsStr, ByRef $a_ab_BlockedLayers)
    If $a_s_BlockingIdsStr = "" Then Return False

    Local $l_as_BlockingIds = StringSplit($a_s_BlockingIdsStr, ",", 2)
    For $l_i_Idx = 0 To UBound($l_as_BlockingIds) - 1
        Local $l_i_LayerId = Number($l_as_BlockingIds[$l_i_Idx])
        If $l_i_LayerId < UBound($a_ab_BlockedLayers) Then
            If $a_ab_BlockedLayers[$l_i_LayerId] Then
                Return True
            EndIf
        EndIf
    Next

    Return False
EndFunc

Func Pathfinding_GetTeleporterHeuristic($a_i_StartPointId, $a_i_GoalPointId)
    If Not IsArray($g_av_Teleports) Or UBound($g_av_Teleports) = 0 Then
        Return $GC_I_INFINITY
    EndIf

    Local $l_f_StartX = $g_av_Points[$a_i_StartPointId][1]
    Local $l_f_StartY = $g_av_Points[$a_i_StartPointId][2]
    Local $l_f_GoalX = $g_av_Points[$a_i_GoalPointId][1]
    Local $l_f_GoalY = $g_av_Points[$a_i_GoalPointId][2]

    Local $l_f_MinCost = $GC_I_INFINITY

    For $l_i_Idx = 0 To UBound($g_av_Teleports) - 1
        Local $l_f_EnterX = $g_av_Teleports[$l_i_Idx][0]
        Local $l_f_EnterY = $g_av_Teleports[$l_i_Idx][1]
        Local $l_f_ExitX = $g_av_Teleports[$l_i_Idx][3]
        Local $l_f_ExitY = $g_av_Teleports[$l_i_Idx][4]
        Local $l_b_Bidirectional = $g_av_Teleports[$l_i_Idx][6]

        ; Distance from start to teleport entrance
        Local $l_f_DistToEnter = Pathfinding_GetDistance($l_f_StartX, $l_f_StartY, $l_f_EnterX, $l_f_EnterY)
        ; Distance from teleport exit to goal
        Local $l_f_DistFromExit = Pathfinding_GetDistance($l_f_ExitX, $l_f_ExitY, $l_f_GoalX, $l_f_GoalY)

        Local $l_f_Cost = $l_f_DistToEnter + $l_f_DistFromExit + 10 ; Small penalty

        If $l_f_Cost < $l_f_MinCost Then
            $l_f_MinCost = $l_f_Cost
        EndIf

        ; Check reverse direction if bidirectional
        If $l_b_Bidirectional Then
            $l_f_DistToEnter = Pathfinding_GetDistance($l_f_StartX, $l_f_StartY, $l_f_ExitX, $l_f_ExitY)
            $l_f_DistFromExit = Pathfinding_GetDistance($l_f_EnterX, $l_f_EnterY, $l_f_GoalX, $l_f_GoalY)
            $l_f_Cost = $l_f_DistToEnter + $l_f_DistFromExit + 10

            If $l_f_Cost < $l_f_MinCost Then
                $l_f_MinCost = $l_f_Cost
            EndIf
        EndIf
    Next

    Return $l_f_MinCost
EndFunc

; Main A* pathfinding function
Func Pathfinding_CalculatePath($a_f_FromX, $a_f_FromY, $a_f_FromZ, $a_f_ToX, $a_f_ToY, $a_f_ToZ, ByRef $a_ab_BlockedLayers)
    Local $l_af2_Path[0][3] ; Array to store path points [x, y, z]

    ; Get closest points on the pathing map
    Local $l_af_StartPos = Pathfinding_GetClosestPointOnMap($a_f_FromX, $a_f_FromY, $a_f_FromZ)
    Local $l_af_GoalPos = Pathfinding_GetClosestPointOnMap($a_f_ToX, $a_f_ToY, $a_f_ToZ)

    If $l_af_StartPos[0] = 0 And $l_af_StartPos[1] = 0 Then
        ConsoleWrite("Failed to find valid start position" & @CRLF)
        Return $l_af2_Path
    EndIf

    If $l_af_GoalPos[0] = 0 And $l_af_GoalPos[1] = 0 Then
        ConsoleWrite("Failed to find valid goal position" & @CRLF)
        Return $l_af2_Path
    EndIf

    ; Find start and goal points in the graph
    Local $l_i_StartPointId = Pathfinding_FindClosestPoint($l_af_StartPos[0], $l_af_StartPos[1], $l_af_StartPos[2])
    Local $l_i_GoalPointId = Pathfinding_FindClosestPoint($l_af_GoalPos[0], $l_af_GoalPos[1], $l_af_GoalPos[2])

    If $l_i_StartPointId < 0 Or $l_i_GoalPointId < 0 Then
        ConsoleWrite("Failed to find start or goal points in graph" & @CRLF)
        Return $l_af2_Path
    EndIf

    ConsoleWrite("Start point: " & $l_i_StartPointId & ", Goal point: " & $l_i_GoalPointId & @CRLF)

    ; Initialize A* algorithm
    Local $l_i_NumPoints = UBound($g_av_Points)
    Local $l_af_GScore[$l_i_NumPoints]
    Local $l_ai_CameFrom[$l_i_NumPoints]
    Local $l_ab_InClosedSet[$l_i_NumPoints]

    For $l_i_Idx = 0 To $l_i_NumPoints - 1
        $l_af_GScore[$l_i_Idx] = $GC_I_INFINITY
        $l_ai_CameFrom[$l_i_Idx] = -1
        $l_ab_InClosedSet[$l_i_Idx] = False
    Next

    ; Initialize start node
    $l_af_GScore[$l_i_StartPointId] = 0

    ; Initialize priority queue
    PQ_Init()
    Local $l_f_Heuristic = Pathfinding_GetDistance($g_av_Points[$l_i_StartPointId][1], $g_av_Points[$l_i_StartPointId][2], _
                                      $g_av_Points[$l_i_GoalPointId][1], $g_av_Points[$l_i_GoalPointId][2])
    PQ_Push($l_f_Heuristic, $l_i_StartPointId)

    Local $l_b_UseTeleports = (IsArray($g_av_Teleports) And UBound($g_av_Teleports) > 0)

    ; A* main loop
    While Not PQ_IsEmpty()
        Local $l_i_Current = PQ_Pop()

        If $l_i_Current = $l_i_GoalPointId Then
            ; Reconstruct path
            ConsoleWrite("Path found!" & @CRLF)
            Local $l_i_Node = $l_i_GoalPointId
            Local $l_ai_TempPath[0]

            While $l_i_Node <> -1 And $l_i_Node <> $l_i_StartPointId
                _ArrayAdd($l_ai_TempPath, $l_i_Node)
                $l_i_Node = $l_ai_CameFrom[$l_i_Node]
            WEnd
            _ArrayAdd($l_ai_TempPath, $l_i_StartPointId)

            ; Reverse path and convert to coordinates
            For $l_i_Idx = UBound($l_ai_TempPath) - 1 To 0 Step -1
                Local $l_i_PointIdx = $l_ai_TempPath[$l_i_Idx]
                Local $l_af_Coord[3] = [$g_av_Points[$l_i_PointIdx][1], $g_av_Points[$l_i_PointIdx][2], $g_av_Points[$l_i_PointIdx][4]]
                Local $l_i_NewRow = UBound($l_af2_Path)
                ReDim $l_af2_Path[$l_i_NewRow + 1][3]
                $l_af2_Path[$l_i_NewRow][0] = $l_af_Coord[0]
                $l_af2_Path[$l_i_NewRow][1] = $l_af_Coord[1]
                $l_af2_Path[$l_i_NewRow][2] = $l_af_Coord[2]
            Next

            ConsoleWrite("Path length: " & $l_af_GScore[$l_i_GoalPointId] & @CRLF)
            Return $l_af2_Path
        EndIf

        If $l_i_Current < 0 Or $l_i_Current >= $l_i_NumPoints Then ContinueLoop

        $l_ab_InClosedSet[$l_i_Current] = True

        ; Check all neighbors
        If $l_i_Current < UBound($g_av_VisibilityGraph) Then
            Local $l_amx2_Edges = $g_av_VisibilityGraph[$l_i_Current]
            If IsArray($l_amx2_Edges) Then
                For $l_i_EdgeIdx = 0 To UBound($l_amx2_Edges) - 1
                    Local $l_i_Neighbor = $l_amx2_Edges[$l_i_EdgeIdx][0]
                    Local $l_f_Distance = $l_amx2_Edges[$l_i_EdgeIdx][1]
                    Local $l_s_BlockingIds = $l_amx2_Edges[$l_i_EdgeIdx][2]

                    ; Skip if in closed set
                    If $l_i_Neighbor >= 0 And $l_i_Neighbor < $l_i_NumPoints Then
                        If $l_ab_InClosedSet[$l_i_Neighbor] Then ContinueLoop
                    Else
                        ContinueLoop
                    EndIf

                    ; Skip if path is blocked
                    If Pathfinding_IsPathBlocked($l_s_BlockingIds, $a_ab_BlockedLayers) Then ContinueLoop

                    ; Calculate tentative g score
                    Local $l_f_TentativeGScore = $l_af_GScore[$l_i_Current] + $l_f_Distance

                    If $l_f_TentativeGScore < $l_af_GScore[$l_i_Neighbor] Then
                        ; This path is better
                        $l_ai_CameFrom[$l_i_Neighbor] = $l_i_Current
                        $l_af_GScore[$l_i_Neighbor] = $l_f_TentativeGScore

                        ; Calculate heuristic
                        Local $l_f_H = Pathfinding_GetDistance($g_av_Points[$l_i_Neighbor][1], $g_av_Points[$l_i_Neighbor][2], _
                                                  $g_av_Points[$l_i_GoalPointId][1], $g_av_Points[$l_i_GoalPointId][2])

                        ; Check for teleporter heuristic
                        If $l_b_UseTeleports Then
                            Local $l_f_TeleportH = Pathfinding_GetTeleporterHeuristic($l_i_Neighbor, $l_i_GoalPointId)
                            If $l_f_TeleportH < $l_f_H Then $l_f_H = $l_f_TeleportH
                        EndIf

                        Local $l_f_FScore = $l_f_TentativeGScore + $l_f_H
                        PQ_Push($l_f_FScore, $l_i_Neighbor)
                    EndIf
                Next
            EndIf
        EndIf
    WEnd

    ConsoleWrite("No path found" & @CRLF)
    Return $l_af2_Path
EndFunc

; Simplify path by removing unnecessary waypoints
Func Pathfinding_SimplifyPath(ByRef $a_af2_Path, $a_f_MaxDist = 2500)
    If UBound($a_af2_Path) <= 2 Then Return $a_af2_Path

    Local $l_af2_Simplified[1][3]
    $l_af2_Simplified[0][0] = $a_af2_Path[0][0]
    $l_af2_Simplified[0][1] = $a_af2_Path[0][1]
    $l_af2_Simplified[0][2] = $a_af2_Path[0][2]

    Local $l_i_CurrentIdx = 0
    While $l_i_CurrentIdx < UBound($a_af2_Path) - 1
        Local $l_i_TestIdx = $l_i_CurrentIdx + 2
        Local $l_i_LastValid = $l_i_CurrentIdx + 1

        ; Try to skip points (simplified line of sight check)
        While $l_i_TestIdx < UBound($a_af2_Path)
            ; Here you would check line of sight
            ; For now, just use distance as a simple heuristic
            Local $l_f_Dist = Pathfinding_GetDistance($a_af2_Path[$l_i_CurrentIdx][0], $a_af2_Path[$l_i_CurrentIdx][1], _
                                         $a_af2_Path[$l_i_TestIdx][0], $a_af2_Path[$l_i_TestIdx][1])
            If $l_f_Dist < $a_f_MaxDist Then
                $l_i_LastValid = $l_i_TestIdx
                $l_i_TestIdx += 1
            Else
                ExitLoop
            EndIf
        WEnd

        Local $l_i_NewRow = UBound($l_af2_Simplified)
        ReDim $l_af2_Simplified[$l_i_NewRow + 1][3]
        $l_af2_Simplified[$l_i_NewRow][0] = $a_af2_Path[$l_i_LastValid][0]
        $l_af2_Simplified[$l_i_NewRow][1] = $a_af2_Path[$l_i_LastValid][1]
        $l_af2_Simplified[$l_i_NewRow][2] = $a_af2_Path[$l_i_LastValid][2]

        $l_i_CurrentIdx = $l_i_LastValid
    WEnd

    Return $l_af2_Simplified
EndFunc
