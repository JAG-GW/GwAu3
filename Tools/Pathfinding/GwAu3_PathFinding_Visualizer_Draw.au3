#include-once

; ===============================================================
; Global variables for visualization
; ===============================================================
Global $g_h_VisualizerGUI = 0  ; Handle of parent control (Pic)
Global $g_h_VisualizerGraphic = 0
Global $g_h_VisualizerBitmap = 0
Global $g_h_VisualizerBuffer = 0
Global $g_h_VisualizerPen = 0
Global $g_h_VisualizerBrush = 0
Global $g_f_VisualizerScale = 0.1
Global $g_f_VisualizerOffsetX = 400
Global $g_f_VisualizerOffsetY = 300
Global $g_i_VisualizerWidth = 800
Global $g_i_VisualizerHeight = 600
Global $g_b_VisualizerInitialized = False
Global $g_a_VisualizerPath[0][2]
Global $g_f_PlayerX = 0
Global $g_f_PlayerY = 0
Global $g_i_PlayerZ = 0
Global $g_b_InitialCenter = True  ; Flag for initial centering only

; Visualization options
Global $g_b_ShowTrapezoids = True
Global $g_b_ShowAABBs = False
Global $g_b_ShowPortals = False
Global $g_b_ShowConnections = True
Global $g_b_ShowPoints = False
Global $g_b_ShowPath = True
Global $g_b_ShowVisibilityGraph = False
Global $g_b_ShowTeleports = True
Global $g_b_ShowLabels = False
Global $g_b_WireframeMode = False
Global $g_b_ShowDistanceCircles = False
Global $g_b_UseGradientColors = True
Global $g_b_CenterOnPlayer = False  ; New flag for player centering

; Distance circles configuration
Global $g_a_DistanceCircles[8] = [156, 240, 312, 1000, 1320, 1500, 2500, 5000]
Global $g_a_CircleColors[8] = [0xFFFFFFFF, 0xFFFFFF00, 0xFFFF8800, 0xFF00FFFF, 0xFF00FF00, 0xFFFF00FF, 0xFF0080FF, 0xFFFF0000]
Global $g_a_CircleLabels[8] = ["Adjacent", "Nearby", "Area", "Earshot", "Spellcast", "Longbow", "Spirit", "Compass"]

; Variables for last click
Global $g_f_LastClickWorldX = 0
Global $g_f_LastClickWorldY = 0
Global $g_b_ShowLastClick = False

; Variables for map dimensions (for visualizer)
Global $g_f_MapMinX = 0
Global $g_f_MapMaxX = 0
Global $g_f_MapMinY = 0
Global $g_f_MapMaxY = 0
Global $g_f_MapWidth = 0
Global $g_f_MapHeight = 0
Global $g_f_MapCenterX = 0
Global $g_f_MapCenterY = 0
Global $g_i_MaxPlane = 1

; ===============================================================
; Initialization of visualization (Integrated version)
; ===============================================================
Func PathFinding_Visualizer_Init($a_h_Window, $a_i_Width = 800, $a_i_Height = 600)
    If $g_b_VisualizerInitialized Then Return True

    Log_Info("Initializing Integrated PathFinding Visualizer...", "Visualizer", $g_h_EditText)

    ; Initialize GDI+
    _GDIPlus_Startup()

    ; Store window handle (not control handle)
    $g_h_VisualizerGUI = $a_h_Window

    ; Create graphics from window with clipping region
    $g_h_VisualizerGraphic = _GDIPlus_GraphicsCreateFromHWND($g_h_VisualizerGUI)

    ; Set clipping region to visualizer area
    Local $h_Region = _GDIPlus_RegionCreateFromRect(340, 28, $a_i_Width, $a_i_Height)
    _GDIPlus_GraphicsSetClipRegion($g_h_VisualizerGraphic, $h_Region)
    _GDIPlus_RegionDispose($h_Region)

    ; Create bitmap for double buffering
    $g_h_VisualizerBitmap = _GDIPlus_BitmapCreateFromGraphics($a_i_Width, $a_i_Height, $g_h_VisualizerGraphic)
    $g_h_VisualizerBuffer = _GDIPlus_ImageGetGraphicsContext($g_h_VisualizerBitmap)

    ; Set quality
    _GDIPlus_GraphicsSetSmoothingMode($g_h_VisualizerBuffer, 2)

    ; Store dimensions
    $g_i_VisualizerWidth = $a_i_Width
    $g_i_VisualizerHeight = $a_i_Height

    $g_b_VisualizerInitialized = True
    $g_b_InitialCenter = True  ; Reset initial center flag

    ; Initial draw
    PathFinding_Visualizer_Update()

    Log_Info("Integrated PathFinding Visualizer initialized", "Visualizer", $g_h_EditText)
    Return True
EndFunc

; ===============================================================
; Toggle Functions
; ===============================================================
Func PathFinding_Visualizer_ToggleTrapezoids()
    $g_b_ShowTrapezoids = Not $g_b_ShowTrapezoids
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleAABBs()
    $g_b_ShowAABBs = Not $g_b_ShowAABBs
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_TogglePortals()
    $g_b_ShowPortals = Not $g_b_ShowPortals
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleConnections()
    $g_b_ShowConnections = Not $g_b_ShowConnections
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_TogglePoints()
    $g_b_ShowPoints = Not $g_b_ShowPoints
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleVisibilityGraph()
    $g_b_ShowVisibilityGraph = Not $g_b_ShowVisibilityGraph
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleTeleports()
    $g_b_ShowTeleports = Not $g_b_ShowTeleports
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleLabels()
    $g_b_ShowLabels = Not $g_b_ShowLabels
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleWireframe()
    $g_b_WireframeMode = Not $g_b_WireframeMode
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleDistanceCircles()
    $g_b_ShowDistanceCircles = Not $g_b_ShowDistanceCircles
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleGradientColors()
    $g_b_UseGradientColors = Not $g_b_UseGradientColors
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ToggleCenterPlayer()
    $g_b_CenterOnPlayer = Not $g_b_CenterOnPlayer
    If $g_b_CenterOnPlayer Then
        PathFinding_Visualizer_CenterOnPlayer()
    EndIf
EndFunc

; ===============================================================
; Update visualization
; ===============================================================
Func PathFinding_Visualizer_Update()
    If Not $g_b_VisualizerInitialized Then Return

    ; Clear buffer
    _GDIPlus_GraphicsClear($g_h_VisualizerBuffer, 0xFF1A1A1A)

    ; Get player position
    $g_f_PlayerX = Agent_GetAgentInfo(-2, "X")
    $g_f_PlayerY = Agent_GetAgentInfo(-2, "Y")
    $g_i_PlayerZ = Agent_GetAgentInfo(-2, "Plane")

    ; Center on player if option is enabled
    If $g_b_CenterOnPlayer Then
        $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $g_f_PlayerX * $g_f_VisualizerScale
        $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $g_f_PlayerY * $g_f_VisualizerScale
    EndIf

    ; Calculate bounds and max plane
    PathFinding_Visualizer_CalculateBounds()

    ; Draw layers in order
    If $g_b_ShowTrapezoids Then PathFinding_Visualizer_DrawTrapezoids()
    If $g_b_ShowAABBs Then PathFinding_Visualizer_DrawAABBs()
    If $g_b_ShowConnections Then PathFinding_Visualizer_DrawConnections()
    If $g_b_ShowPortals Then PathFinding_Visualizer_DrawPortals()
    If $g_b_ShowPoints Then PathFinding_Visualizer_DrawPoints()
    If $g_b_ShowVisibilityGraph Then PathFinding_Visualizer_DrawVisibilityGraph()
    If $g_b_ShowTeleports Then PathFinding_Visualizer_DrawTeleports()
    If $g_b_ShowDistanceCircles Then PathFinding_Visualizer_DrawDistanceCircles()

    ; Always draw path if available
    If UBound($g_a_VisualizerPath) > 0 And $g_b_ShowPath Then
        PathFinding_Visualizer_DrawPath()
    EndIf

    ; Always draw player
    PathFinding_Visualizer_DrawPlayer()

    ; Draw legend and info
    PathFinding_Visualizer_DrawLegend()
    PathFinding_Visualizer_DrawInfo()

    ; Update display
    _GDIPlus_GraphicsDrawImageRect($g_h_VisualizerGraphic, $g_h_VisualizerBitmap, 340, 28, $g_i_VisualizerWidth, $g_i_VisualizerHeight)
EndFunc

; ===============================================================
; Drawing functions
; ===============================================================

Func PathFinding_Visualizer_CalculateBounds()
    If Not $g_b_PathingInitialized Then Return

    ; Calculate map bounds from trapezoids
    If $g_a_PathingTrapezoids[0] > 0 And $g_f_MapWidth = 0 Then
        $g_f_MapMinX = 999999
        $g_f_MapMaxX = -999999
        $g_f_MapMinY = 999999
        $g_f_MapMaxY = -999999

        ; Go through all trapezoids to find limits
        For $i = 1 To $g_a_PathingTrapezoids[0]
            Local $l_a_Trap = $g_a_PathingTrapezoids[$i]
            If Not IsArray($l_a_Trap) Then ContinueLoop

            ; Check all 4 points of trapezoid
            $g_f_MapMinX = _Min($g_f_MapMinX, _Min($l_a_Trap[2], _Min($l_a_Trap[4], _Min($l_a_Trap[6], $l_a_Trap[8]))))
            $g_f_MapMaxX = _Max($g_f_MapMaxX, _Max($l_a_Trap[2], _Max($l_a_Trap[4], _Max($l_a_Trap[6], $l_a_Trap[8]))))
            $g_f_MapMinY = _Min($g_f_MapMinY, _Min($l_a_Trap[3], _Min($l_a_Trap[5], _Min($l_a_Trap[7], $l_a_Trap[9]))))
            $g_f_MapMaxY = _Max($g_f_MapMaxY, _Max($l_a_Trap[3], _Max($l_a_Trap[5], _Max($l_a_Trap[7], $l_a_Trap[9]))))
        Next

        ; Calculate derived dimensions
        $g_f_MapWidth = $g_f_MapMaxX - $g_f_MapMinX
        $g_f_MapHeight = $g_f_MapMaxY - $g_f_MapMinY
        $g_f_MapCenterX = ($g_f_MapMinX + $g_f_MapMaxX) / 2
        $g_f_MapCenterY = ($g_f_MapMinY + $g_f_MapMaxY) / 2
    EndIf

    ; Only do initial centering once
    If $g_b_InitialCenter And $g_f_MapWidth > 0 Then
        ; Calculate initial scale to fit the map
        Local $l_f_ScaleX = $g_i_VisualizerWidth / ($g_f_MapWidth * 1.1)  ; Add 10% margin
        Local $l_f_ScaleY = $g_i_VisualizerHeight / ($g_f_MapHeight * 1.1)
        $g_f_VisualizerScale = _Min($l_f_ScaleX, $l_f_ScaleY)

        ; Center the map initially
        $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $g_f_MapCenterX * $g_f_VisualizerScale
        $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $g_f_MapCenterY * $g_f_VisualizerScale

        $g_b_InitialCenter = False  ; Don't center again
    EndIf

    ; Find max plane for gradient
    $g_i_MaxPlane = 1
    For $i = 1 To $g_a_PathingTrapezoids[0]
        Local $l_a_Trap = $g_a_PathingTrapezoids[$i]
        If IsArray($l_a_Trap) And $l_a_Trap[1] > $g_i_MaxPlane Then
            $g_i_MaxPlane = $l_a_Trap[1]
        EndIf
    Next
EndFunc

Func PathFinding_Visualizer_CenterOnPlayer()
    $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $g_f_PlayerX * $g_f_VisualizerScale
    $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $g_f_PlayerY * $g_f_VisualizerScale
    PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_DrawTrapezoids()
    If Not $g_b_PathingInitialized Or $g_a_PathingTrapezoids[0] = 0 Then Return

    For $i = 1 To $g_a_PathingTrapezoids[0]
        Local $l_a_Trap = $g_a_PathingTrapezoids[$i]
        If Not IsArray($l_a_Trap) Then ContinueLoop

        ; Calculate color
        Local $l_i_Color, $l_i_BorderColor

        If $g_b_UseGradientColors And $g_i_MaxPlane > 0 Then
            ; Gradient based on plane (light gray to red)
            Local $l_f_ColorRatio = $l_a_Trap[1] / $g_i_MaxPlane

            ; Interpolation from light gray (200,200,200) to red (255,0,0)
            Local $l_i_Red = Int(200 + (55 * $l_f_ColorRatio))      ; 200 -> 255
            Local $l_i_Green = Int(200 * (1 - $l_f_ColorRatio))     ; 200 -> 0
            Local $l_i_Blue = Int(200 * (1 - $l_f_ColorRatio))      ; 200 -> 0

            ; Opaque for fill when wireframe disabled
            If $g_b_WireframeMode Then
                $l_i_Color = 0x40000000 + BitShift($l_i_Red, -16) + BitShift($l_i_Green, -8) + $l_i_Blue
            Else
                $l_i_Color = 0xFF000000 + BitShift($l_i_Red, -16) + BitShift($l_i_Green, -8) + $l_i_Blue  ; Fully opaque
            EndIf
            $l_i_BorderColor = 0xFF000000 + BitShift($l_i_Red, -16) + BitShift($l_i_Green, -8) + $l_i_Blue
        Else
            ; Fixed light gray color instead of yellow
            If $g_b_WireframeMode Then
                $l_i_Color = 0x10C8C8C8  ; Transparent light gray in wireframe
            Else
                $l_i_Color = 0xFFC8C8C8  ; Opaque light gray (200,200,200)
            EndIf
            $l_i_BorderColor = 0xFF808080  ; Medium gray border for contrast
        EndIf

        Local $l_h_Pen = _GDIPlus_PenCreate($l_i_BorderColor, 1)
        Local $l_h_Brush = _GDIPlus_BrushCreateSolid($l_i_Color)

        ; Convert trapezoid points to screen coordinates
        Local $l_a_Points[5][2]
        $l_a_Points[0][0] = 4 ; Number of points
        $l_a_Points[1][0] = PathFinding_Visualizer_WorldToScreenX($l_a_Trap[2]) ; a.x
        $l_a_Points[1][1] = PathFinding_Visualizer_WorldToScreenY($l_a_Trap[3]) ; a.y
        $l_a_Points[2][0] = PathFinding_Visualizer_WorldToScreenX($l_a_Trap[8]) ; d.x
        $l_a_Points[2][1] = PathFinding_Visualizer_WorldToScreenY($l_a_Trap[9]) ; d.y
        $l_a_Points[3][0] = PathFinding_Visualizer_WorldToScreenX($l_a_Trap[6]) ; c.x
        $l_a_Points[3][1] = PathFinding_Visualizer_WorldToScreenY($l_a_Trap[7]) ; c.y
        $l_a_Points[4][0] = PathFinding_Visualizer_WorldToScreenX($l_a_Trap[4]) ; b.x
        $l_a_Points[4][1] = PathFinding_Visualizer_WorldToScreenY($l_a_Trap[5]) ; b.y

        ; Draw based on wireframe mode
        If $g_b_WireframeMode Then
            ; Only draw outline
            _GDIPlus_GraphicsDrawPolygon($g_h_VisualizerBuffer, $l_a_Points, $l_h_Pen)
        Else
            ; Draw filled polygon
            _GDIPlus_GraphicsFillPolygon($g_h_VisualizerBuffer, $l_a_Points, $l_h_Brush)
            _GDIPlus_GraphicsDrawPolygon($g_h_VisualizerBuffer, $l_a_Points, $l_h_Pen)
        EndIf

        ; Draw ID if labels enabled
        If $g_b_ShowLabels And $g_f_VisualizerScale > 0.05 Then
            Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 8)
            ; Text in black to contrast with light gray
            Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFF000000)
            Local $l_h_Format = _GDIPlus_StringFormatCreate()

            Local $l_f_CenterX = ($l_a_Trap[2] + $l_a_Trap[4] + $l_a_Trap[6] + $l_a_Trap[8]) / 4
            Local $l_f_CenterY = ($l_a_Trap[3] + $l_a_Trap[5] + $l_a_Trap[7] + $l_a_Trap[9]) / 4
            Local $l_i_ScreenX = PathFinding_Visualizer_WorldToScreenX($l_f_CenterX)
            Local $l_i_ScreenY = PathFinding_Visualizer_WorldToScreenY($l_f_CenterY)

            Local $l_s_Label = $l_a_Trap[0] & " [" & $l_a_Trap[1] & "]"
            Local $l_t_Layout = _GDIPlus_RectFCreate($l_i_ScreenX - 20, $l_i_ScreenY - 10, 40, 20)
            _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $l_s_Label, $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

            _GDIPlus_FontDispose($l_h_Font)
            _GDIPlus_BrushDispose($l_h_BrushText)
            _GDIPlus_StringFormatDispose($l_h_Format)
        EndIf

        _GDIPlus_PenDispose($l_h_Pen)
        _GDIPlus_BrushDispose($l_h_Brush)
    Next
EndFunc

Func PathFinding_Visualizer_DrawAABBs()
    If Not $g_b_PathingInitialized Or $g_a_PathingAABBs[0] = 0 Then Return

    Local $l_h_Pen = _GDIPlus_PenCreate(0x8000FF00, 2)
    Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 8)
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    Local $l_h_Format = _GDIPlus_StringFormatCreate()

    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_a_AABB = $g_a_PathingAABBs[$i]
        If Not IsArray($l_a_AABB) Then ContinueLoop

        ; Calculate screen coordinates
        Local $l_i_X = PathFinding_Visualizer_WorldToScreenX($l_a_AABB[1] - $l_a_AABB[3])
        Local $l_i_Y = PathFinding_Visualizer_WorldToScreenY($l_a_AABB[2] + $l_a_AABB[4])
        Local $l_i_Width = $l_a_AABB[3] * 2 * $g_f_VisualizerScale
        Local $l_i_Height = $l_a_AABB[4] * 2 * $g_f_VisualizerScale

        ; Draw rectangle
        _GDIPlus_GraphicsDrawRect($g_h_VisualizerBuffer, $l_i_X, $l_i_Y, $l_i_Width, $l_i_Height, $l_h_Pen)

        ; Draw ID if labels enabled
        If $g_b_ShowLabels And $g_f_VisualizerScale > 0.02 Then
            Local $l_t_Layout = _GDIPlus_RectFCreate($l_i_X + 2, $l_i_Y + 2, 30, 20)
            _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $l_a_AABB[0], $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_Brush)
        EndIf
    Next

    _GDIPlus_PenDispose($l_h_Pen)
    _GDIPlus_FontDispose($l_h_Font)
    _GDIPlus_BrushDispose($l_h_Brush)
    _GDIPlus_StringFormatDispose($l_h_Format)
EndFunc

Func PathFinding_Visualizer_DrawConnections()
    If Not $g_b_PathingInitialized Then Return
    If Not IsArray($g_a_PathingAABBGraph) Or UBound($g_a_PathingAABBGraph) = 0 Then Return

    Local $l_h_Pen = _GDIPlus_PenCreate(0x400080FF, 1)
    _GDIPlus_PenSetDashStyle($l_h_Pen, $GDIP_DASHSTYLEDASH)

    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_s_Connections = $g_a_PathingAABBGraph[$i]
        If $l_s_Connections = "" Then ContinueLoop

        Local $l_a_AABB1 = $g_a_PathingAABBs[$i]
        If Not IsArray($l_a_AABB1) Then ContinueLoop

        Local $l_a_Connected = StringSplit($l_s_Connections, ",", 2)

        For $j = 0 To UBound($l_a_Connected) - 1
            Local $l_i_ConnectedID = Int($l_a_Connected[$j]) + 1
            If $l_i_ConnectedID < 1 Or $l_i_ConnectedID > $g_a_PathingAABBs[0] Then ContinueLoop
            If $l_i_ConnectedID <= $i Then ContinueLoop ; Avoid drawing twice

            Local $l_a_AABB2 = $g_a_PathingAABBs[$l_i_ConnectedID]
            If Not IsArray($l_a_AABB2) Then ContinueLoop

            ; Draw line between AABB centers
            Local $l_i_X1 = PathFinding_Visualizer_WorldToScreenX($l_a_AABB1[1])
            Local $l_i_Y1 = PathFinding_Visualizer_WorldToScreenY($l_a_AABB1[2])
            Local $l_i_X2 = PathFinding_Visualizer_WorldToScreenX($l_a_AABB2[1])
            Local $l_i_Y2 = PathFinding_Visualizer_WorldToScreenY($l_a_AABB2[2])

            _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_Pen)
        Next
    Next

    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func PathFinding_Visualizer_DrawPortals()
    If Not $g_b_PathingInitialized Or $g_a_PathingPortals[0] = 0 Then Return

    Local $l_h_Pen = _GDIPlus_PenCreate(0xFF00FFFF, 2)
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFF00FFFF)

    For $i = 1 To $g_a_PathingPortals[0]
        Local $l_a_Portal = $g_a_PathingPortals[$i]
        If Not IsArray($l_a_Portal) Then ContinueLoop

        ; Draw portal line
        Local $l_i_X1 = PathFinding_Visualizer_WorldToScreenX($l_a_Portal[0])
        Local $l_i_Y1 = PathFinding_Visualizer_WorldToScreenY($l_a_Portal[1])
        Local $l_i_X2 = PathFinding_Visualizer_WorldToScreenX($l_a_Portal[2])
        Local $l_i_Y2 = PathFinding_Visualizer_WorldToScreenY($l_a_Portal[3])

        _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_Pen)

        ; Draw portal endpoints
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X1 - 3, $l_i_Y1 - 3, 6, 6, $l_h_Brush)
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X2 - 3, $l_i_Y2 - 3, 6, 6, $l_h_Brush)
    Next

    _GDIPlus_PenDispose($l_h_Pen)
    _GDIPlus_BrushDispose($l_h_Brush)
EndFunc

Func PathFinding_Visualizer_DrawPoints()
    If Not $g_b_PathingInitialized Or $g_a_PathingPoints[0] = 0 Then Return

    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFFFF00FF)
    Local $l_h_Pen = _GDIPlus_PenCreate(0xFFFF00FF, 1)

    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_Point = $g_a_PathingPoints[$i]
        If Not IsArray($l_a_Point) Then ContinueLoop

        Local $l_i_X = PathFinding_Visualizer_WorldToScreenX($l_a_Point[1])
        Local $l_i_Y = PathFinding_Visualizer_WorldToScreenY($l_a_Point[2])

        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X - 2, $l_i_Y - 2, 4, 4, $l_h_Brush)

        ; Draw point ID if labels enabled
        If $g_b_ShowLabels And $g_f_VisualizerScale > 0.1 Then
            Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 7)
            Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFFFF00FF)
            Local $l_h_Format = _GDIPlus_StringFormatCreate()

            Local $l_t_Layout = _GDIPlus_RectFCreate($l_i_X + 5, $l_i_Y - 10, 20, 15)
            _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $l_a_Point[0], $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

            _GDIPlus_FontDispose($l_h_Font)
            _GDIPlus_BrushDispose($l_h_BrushText)
            _GDIPlus_StringFormatDispose($l_h_Format)
        EndIf
    Next

    _GDIPlus_PenDispose($l_h_Pen)
    _GDIPlus_BrushDispose($l_h_Brush)
EndFunc

Func PathFinding_Visualizer_DrawVisibilityGraph()
    If Not $g_b_PathingInitialized Or $g_a_PathingPoints[0] = 0 Then Return
    If Not IsArray($g_a_PathingPortals) Or $g_a_PathingPortals[0] = 0 Then Return

    Local $l_h_Pen = _GDIPlus_PenCreate(0x40FF00FF, 1) ; Semi-transparent magenta
    _GDIPlus_PenSetDashStyle($l_h_Pen, $GDIP_DASHSTYLEDOT)

    ; Draw connections between points of the same portal
    For $i = 1 To $g_a_PathingPortals[0]
        Local $l_a_Portal = $g_a_PathingPortals[$i]
        If Not IsArray($l_a_Portal) Then ContinueLoop

        ; Find points that belong to this portal
        Local $l_a_PortalPoints[1]
        $l_a_PortalPoints[0] = 0

        For $j = 1 To $g_a_PathingPoints[0]
            Local $l_a_Point = $g_a_PathingPoints[$j]
            If Not IsArray($l_a_Point) Then ContinueLoop
            If UBound($l_a_Point) < 6 Then ContinueLoop

            ; If the point belongs to this portal
            If $l_a_Point[5] = $i - 1 Then ; portal_id
                Local $l_i_Index = $l_a_PortalPoints[0] + 1
                ReDim $l_a_PortalPoints[$l_i_Index + 1]
                $l_a_PortalPoints[$l_i_Index] = $l_a_Point
                $l_a_PortalPoints[0] = $l_i_Index
            EndIf
        Next

        ; Draw connections between points of the same portal
        For $j = 1 To $l_a_PortalPoints[0] - 1
            Local $l_a_P1 = $l_a_PortalPoints[$j]
            Local $l_a_P2 = $l_a_PortalPoints[$j + 1]

            If IsArray($l_a_P1) And IsArray($l_a_P2) Then
                Local $l_i_X1 = PathFinding_Visualizer_WorldToScreenX($l_a_P1[1])
                Local $l_i_Y1 = PathFinding_Visualizer_WorldToScreenY($l_a_P1[2])
                Local $l_i_X2 = PathFinding_Visualizer_WorldToScreenX($l_a_P2[1])
                Local $l_i_Y2 = PathFinding_Visualizer_WorldToScreenY($l_a_P2[2])

                _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_Pen)
            EndIf
        Next
    Next

    ; Optional: Draw connections between adjacent portals
    ; (between the last point of a portal and the first point of an adjacent portal)
    Local $l_h_PenAdjacent = _GDIPlus_PenCreate(0x4000FF00, 1) ; Semi-transparent green

    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_s_Connections = $g_a_PathingAABBGraph[$i]
        If $l_s_Connections = "" Then ContinueLoop

        Local $l_a_Connected = StringSplit($l_s_Connections, ",", 2)

        ; For each connected AABB, find the portals between them
        For $j = 0 To UBound($l_a_Connected) - 1
            Local $l_i_ConnectedID = Int($l_a_Connected[$j]) + 1
            If $l_i_ConnectedID <= $i Then ContinueLoop ; Avoid duplicates

            ; Find the portal between these two AABBs
            For $k = 1 To $g_a_PathingPortals[0]
                Local $l_a_Portal = $g_a_PathingPortals[$k]
                If Not IsArray($l_a_Portal) Then ContinueLoop

                ; If this portal connects the two AABBs
                If ($l_a_Portal[4] = $i - 1 And $l_a_Portal[5] = $l_i_ConnectedID - 1) Or _
                   ($l_a_Portal[5] = $i - 1 And $l_a_Portal[4] = $l_i_ConnectedID - 1) Then

                    ; Draw a line between the portal centers
                    Local $l_f_CenterX = ($l_a_Portal[0] + $l_a_Portal[2]) / 2
                    Local $l_f_CenterY = ($l_a_Portal[1] + $l_a_Portal[3]) / 2

                    Local $l_i_X = PathFinding_Visualizer_WorldToScreenX($l_f_CenterX)
                    Local $l_i_Y = PathFinding_Visualizer_WorldToScreenY($l_f_CenterY)

                    ; Draw a small circle at the portal center
                    _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, $l_i_X - 3, $l_i_Y - 3, 6, 6, $l_h_PenAdjacent)
                EndIf
            Next
        Next
    Next

    _GDIPlus_PenDispose($l_h_Pen)
    _GDIPlus_PenDispose($l_h_PenAdjacent)
EndFunc

Func PathFinding_Visualizer_DrawTeleports()
    If Not $g_b_PathingInitialized Or $g_a_PathingTeleports[0] = 0 Then Return

    Local $l_h_PenEnter = _GDIPlus_PenCreate(0xFF00FF00, 2)
    Local $l_h_PenExit = _GDIPlus_PenCreate(0xFFFF0000, 2)
    Local $l_h_PenLink = _GDIPlus_PenCreate(0xFF00FFFF, 1)
    Local $l_h_BrushEnter = _GDIPlus_BrushCreateSolid(0xFF00FF00)
    Local $l_h_BrushExit = _GDIPlus_BrushCreateSolid(0xFFFF0000)

    _GDIPlus_PenSetDashStyle($l_h_PenLink, $GDIP_DASHSTYLEDASH)

    For $i = 1 To $g_a_PathingTeleports[0]
        Local $l_a_Teleport = $g_a_PathingTeleports[$i]
        If Not IsArray($l_a_Teleport) Then ContinueLoop

        ; Draw enter point
        Local $l_i_EnterX = PathFinding_Visualizer_WorldToScreenX($l_a_Teleport[0])
        Local $l_i_EnterY = PathFinding_Visualizer_WorldToScreenY($l_a_Teleport[1])

        _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, $l_i_EnterX - 8, $l_i_EnterY - 8, 16, 16, $l_h_PenEnter)
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_EnterX - 5, $l_i_EnterY - 5, 10, 10, $l_h_BrushEnter)

        ; Draw exit point
        Local $l_i_ExitX = PathFinding_Visualizer_WorldToScreenX($l_a_Teleport[3])
        Local $l_i_ExitY = PathFinding_Visualizer_WorldToScreenY($l_a_Teleport[4])

        _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, $l_i_ExitX - 8, $l_i_ExitY - 8, 16, 16, $l_h_PenExit)
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_ExitX - 5, $l_i_ExitY - 5, 10, 10, $l_h_BrushExit)

        ; Draw link
        _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_EnterX, $l_i_EnterY, $l_i_ExitX, $l_i_ExitY, $l_h_PenLink)

        ; Draw arrow to show direction
        If Not $l_a_Teleport[6] Then ; One-way
            Local $l_f_Angle = ATan2($l_i_ExitY - $l_i_EnterY, $l_i_ExitX - $l_i_EnterX)
            Local $l_f_ArrowLen = 10
            Local $l_f_ArrowAngle = 0.5

            Local $l_i_MidX = ($l_i_EnterX + $l_i_ExitX) / 2
            Local $l_i_MidY = ($l_i_EnterY + $l_i_ExitY) / 2

            Local $l_i_Arrow1X = $l_i_MidX - $l_f_ArrowLen * Cos($l_f_Angle + $l_f_ArrowAngle)
            Local $l_i_Arrow1Y = $l_i_MidY - $l_f_ArrowLen * Sin($l_f_Angle + $l_f_ArrowAngle)
            Local $l_i_Arrow2X = $l_i_MidX - $l_f_ArrowLen * Cos($l_f_Angle - $l_f_ArrowAngle)
            Local $l_i_Arrow2Y = $l_i_MidY - $l_f_ArrowLen * Sin($l_f_Angle - $l_f_ArrowAngle)

            _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_MidX, $l_i_MidY, $l_i_Arrow1X, $l_i_Arrow1Y, $l_h_PenLink)
            _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_MidX, $l_i_MidY, $l_i_Arrow2X, $l_i_Arrow2Y, $l_h_PenLink)
        EndIf
    Next

    _GDIPlus_PenDispose($l_h_PenEnter)
    _GDIPlus_PenDispose($l_h_PenExit)
    _GDIPlus_PenDispose($l_h_PenLink)
    _GDIPlus_BrushDispose($l_h_BrushEnter)
    _GDIPlus_BrushDispose($l_h_BrushExit)
EndFunc

Func PathFinding_Visualizer_DrawDistanceCircles()
    If Not $g_b_ShowDistanceCircles Then Return

    ; Player position at center
    Local $l_i_CenterX = PathFinding_Visualizer_WorldToScreenX($g_f_PlayerX)
    Local $l_i_CenterY = PathFinding_Visualizer_WorldToScreenY($g_f_PlayerY)

    ; Draw center point
    Local $l_h_BrushCenter = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_CenterX - 3, $l_i_CenterY - 3, 6, 6, $l_h_BrushCenter)
    _GDIPlus_BrushDispose($l_h_BrushCenter)

    ; Draw circles
    For $i = 0 To UBound($g_a_DistanceCircles) - 1
        Local $l_f_Radius = $g_a_DistanceCircles[$i] * $g_f_VisualizerScale
        Local $l_h_Pen = _GDIPlus_PenCreate($g_a_CircleColors[$i], 2)

        _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, _
            $l_i_CenterX - $l_f_Radius, _
            $l_i_CenterY - $l_f_Radius, _
            $l_f_Radius * 2, _
            $l_f_Radius * 2, _
            $l_h_Pen)

        ; Draw label if scale is sufficient
        If $g_f_VisualizerScale > 0.01 And $g_b_ShowLabels Then
            Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 8)
            Local $l_h_BrushText = _GDIPlus_BrushCreateSolid($g_a_CircleColors[$i])
            Local $l_h_Format = _GDIPlus_StringFormatCreate()

            Local $l_s_Label = $g_a_CircleLabels[$i] & " (" & $g_a_DistanceCircles[$i] & ")"
            Local $l_t_Layout = _GDIPlus_RectFCreate($l_i_CenterX + $l_f_Radius + 5, $l_i_CenterY - 10, 100, 20)
            _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $l_s_Label, $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

            _GDIPlus_FontDispose($l_h_Font)
            _GDIPlus_BrushDispose($l_h_BrushText)
            _GDIPlus_StringFormatDispose($l_h_Format)
        EndIf

        _GDIPlus_PenDispose($l_h_Pen)
    Next
EndFunc

Func PathFinding_Visualizer_DrawPath()
    If Not IsArray($g_a_VisualizerPath) Or $g_a_VisualizerPath[0][0] < 2 Then Return

    ; Draw path lines
    Local $l_h_Pen = _GDIPlus_PenCreate(0xFFFF0000, 3)
    _GDIPlus_PenSetLineCap($l_h_Pen, 0, 0, 2)

    For $i = 1 To $g_a_VisualizerPath[0][0] - 1
        Local $l_i_X1 = PathFinding_Visualizer_WorldToScreenX($g_a_VisualizerPath[$i][0])
        Local $l_i_Y1 = PathFinding_Visualizer_WorldToScreenY($g_a_VisualizerPath[$i][1])
        Local $l_i_X2 = PathFinding_Visualizer_WorldToScreenX($g_a_VisualizerPath[$i + 1][0])
        Local $l_i_Y2 = PathFinding_Visualizer_WorldToScreenY($g_a_VisualizerPath[$i + 1][1])

        _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_Pen)
    Next

    _GDIPlus_PenDispose($l_h_Pen)

    ; Draw waypoints
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFFFFFF00)
    Local $l_h_PenWaypoint = _GDIPlus_PenCreate(0xFF000000, 1)

    For $i = 1 To $g_a_VisualizerPath[0][0]
        Local $l_i_X = PathFinding_Visualizer_WorldToScreenX($g_a_VisualizerPath[$i][0])
        Local $l_i_Y = PathFinding_Visualizer_WorldToScreenY($g_a_VisualizerPath[$i][1])

        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X - 4, $l_i_Y - 4, 8, 8, $l_h_Brush)
        _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, $l_i_X - 4, $l_i_Y - 4, 8, 8, $l_h_PenWaypoint)
    Next

    _GDIPlus_BrushDispose($l_h_Brush)
    _GDIPlus_PenDispose($l_h_PenWaypoint)

    ; Draw start and end markers
    If $g_a_VisualizerPath[0][0] >= 2 Then
        ; Start (green)
        Local $l_h_BrushStart = _GDIPlus_BrushCreateSolid(0xFF00FF00)
        Local $l_i_StartX = PathFinding_Visualizer_WorldToScreenX($g_a_VisualizerPath[1][0])
        Local $l_i_StartY = PathFinding_Visualizer_WorldToScreenY($g_a_VisualizerPath[1][1])
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_StartX - 6, $l_i_StartY - 6, 12, 12, $l_h_BrushStart)
        _GDIPlus_BrushDispose($l_h_BrushStart)

        ; End (red)
        Local $l_h_BrushEnd = _GDIPlus_BrushCreateSolid(0xFFFF0000)
        Local $l_i_EndX = PathFinding_Visualizer_WorldToScreenX($g_a_VisualizerPath[$g_a_VisualizerPath[0][0]][0])
        Local $l_i_EndY = PathFinding_Visualizer_WorldToScreenY($g_a_VisualizerPath[$g_a_VisualizerPath[0][0]][1])
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_EndX - 6, $l_i_EndY - 6, 12, 12, $l_h_BrushEnd)
        _GDIPlus_BrushDispose($l_h_BrushEnd)
    EndIf
EndFunc

Func PathFinding_Visualizer_DrawPlayer()
    Local $l_i_X = PathFinding_Visualizer_WorldToScreenX($g_f_PlayerX)
    Local $l_i_Y = PathFinding_Visualizer_WorldToScreenY($g_f_PlayerY)

    ; Draw player as blue circle with direction arrow
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFF0080FF)
    Local $l_h_Pen = _GDIPlus_PenCreate(0xFFFFFFFF, 2)

    _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X - 8, $l_i_Y - 8, 16, 16, $l_h_Brush)
    _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, $l_i_X - 8, $l_i_Y - 8, 16, 16, $l_h_Pen)

    ; Draw direction indicator
    Local $l_f_Rotation = Agent_GetAgentInfo(-2, "Rotation")
    If $l_f_Rotation <> 0 Then
        ; Invert Y component because screen Y is inverted compared to world Y
        Local $l_i_ArrowX = $l_i_X + 12 * Cos($l_f_Rotation)
        Local $l_i_ArrowY = $l_i_Y - 12 * Sin($l_f_Rotation)
        _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_X, $l_i_Y, $l_i_ArrowX, $l_i_ArrowY, $l_h_Pen)
    EndIf

    _GDIPlus_BrushDispose($l_h_Brush)
    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func PathFinding_Visualizer_DrawLegend()
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xC0000000)
    _GDIPlus_GraphicsFillRect($g_h_VisualizerBuffer, 10, 10, 150, 245, $l_h_Brush)
    _GDIPlus_BrushDispose($l_h_Brush)

    Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 10)
    Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    Local $l_h_Format = _GDIPlus_StringFormatCreate()

    ; Title
    Local $l_t_Layout = _GDIPlus_RectFCreate(15, 15, 140, 20)
    _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, "Legend", $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

    ; Legend items
    Local $l_i_Y = 35
    Local $l_a_Legend[11][3] = [ _
        ["Player", 0xFF0080FF, $l_i_Y], _
		["Trapezoids", ($g_b_UseGradientColors ? 0xFFC8C8C8 : 0xFFC8C8C8), $l_i_Y + 15], _
        ["AABBs", 0x8000FF00, $l_i_Y + 30], _
        ["Portals", 0xFF00FFFF, $l_i_Y + 45], _
        ["Points", 0xFFFF00FF, $l_i_Y + 60], _
        ["Connections", 0x400080FF, $l_i_Y + 75], _
        ["Teleports", 0xFF00FF00, $l_i_Y + 90], _
        ["Path", 0xFFFF0000, $l_i_Y + 105], _
        ["Wireframe: " & ($g_b_WireframeMode ? "On" : "Off"), 0xFFFFFFFF, $l_i_Y + 125], _
        ["Gradient: " & ($g_b_UseGradientColors ? "On" : "Off"), 0xFFFFFFFF, $l_i_Y + 140] _
    ]

    For $i = 0 To UBound($l_a_Legend) - 1
        If $i < 8 Then
            ; Color box
            Local $l_h_ItemBrush = _GDIPlus_BrushCreateSolid($l_a_Legend[$i][1])
            _GDIPlus_GraphicsFillRect($g_h_VisualizerBuffer, 20, $l_a_Legend[$i][2], 15, 12, $l_h_ItemBrush)
            _GDIPlus_BrushDispose($l_h_ItemBrush)
        EndIf

		; Text
       $l_t_Layout = _GDIPlus_RectFCreate(40, $l_a_Legend[$i][2], 100, 20)
       _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $l_a_Legend[$i][0], $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)
   Next

   ; Show gradient legend if using gradient colors
   If $g_b_UseGradientColors And $g_i_MaxPlane > 0 Then
       Local $l_i_GradY = $l_i_Y + 180
       $l_t_Layout = _GDIPlus_RectFCreate(15, $l_i_GradY, 140, 20)
       _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, "Plane Colors:", $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

       ; Draw gradient bar
       For $i = 0 To 50
			Local $l_f_Ratio = $i / 50
			Local $l_i_Red = Int(200 + (55 * $l_f_Ratio))      ; 200 -> 255
			Local $l_i_Green = Int(200 * (1 - $l_f_Ratio))     ; 200 -> 0
			Local $l_i_Blue = Int(200 * (1 - $l_f_Ratio))      ; 200 -> 0
			Local $l_i_Color = 0xFF000000 + BitShift($l_i_Red, -16) + BitShift($l_i_Green, -8) + $l_i_Blue

			Local $l_h_GradBrush = _GDIPlus_BrushCreateSolid($l_i_Color)
			_GDIPlus_GraphicsFillRect($g_h_VisualizerBuffer, 20 + ($i * 2), $l_i_GradY + 20, 2, 10, $l_h_GradBrush)
			_GDIPlus_BrushDispose($l_h_GradBrush)
		Next

       ; Labels
       Local $l_h_SmallFont = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 8)
       $l_t_Layout = _GDIPlus_RectFCreate(15, $l_i_GradY + 32, 20, 15)
       _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, "0", $l_h_SmallFont, $l_t_Layout, $l_h_Format, $l_h_BrushText)
       $l_t_Layout = _GDIPlus_RectFCreate(110, $l_i_GradY + 32, 30, 15)
       _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $g_i_MaxPlane, $l_h_SmallFont, $l_t_Layout, $l_h_Format, $l_h_BrushText)
       _GDIPlus_FontDispose($l_h_SmallFont)
   EndIf

   _GDIPlus_FontDispose($l_h_Font)
   _GDIPlus_BrushDispose($l_h_BrushText)
   _GDIPlus_StringFormatDispose($l_h_Format)
EndFunc

Func PathFinding_Visualizer_DrawInfo()
   Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 10)
   Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
   Local $l_h_Format = _GDIPlus_StringFormatCreate()

   ; Info box
   Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xC0000000)
   _GDIPlus_GraphicsFillRect($g_h_VisualizerBuffer, 10, $g_i_VisualizerHeight - 120, 220, 110, $l_h_Brush)
   _GDIPlus_BrushDispose($l_h_Brush)

   Local $l_s_Info = "Scale: " & Round($g_f_VisualizerScale, 3) & @CRLF
   $l_s_Info &= "Player: (" & Round($g_f_PlayerX, 0) & ", " & Round($g_f_PlayerY, 0) & ", " & $g_i_PlayerZ & ")" & @CRLF

   ; Add last click coordinates
   If $g_b_ShowLastClick Then
       $l_s_Info &= "Last Click: (" & Round($g_f_LastClickWorldX, 2) & ", " & Round($g_f_LastClickWorldY, 2) & ")" & @CRLF
   EndIf

   If IsArray($g_a_PathingAABBs) Then $l_s_Info &= "AABBs: " & $g_a_PathingAABBs[0] & @CRLF
   If IsArray($g_a_PathingPortals) Then $l_s_Info &= "Portals: " & $g_a_PathingPortals[0] & @CRLF
   If IsArray($g_a_PathingPoints) Then $l_s_Info &= "Points: " & $g_a_PathingPoints[0]

   Local $l_t_Layout = _GDIPlus_RectFCreate(15, $g_i_VisualizerHeight - 115, 210, 105)
   _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $l_s_Info, $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

   ; Draw click marker if exists
   If $g_b_ShowLastClick Then
       Local $l_i_ClickX = PathFinding_Visualizer_WorldToScreenX($g_f_LastClickWorldX)
       Local $l_i_ClickY = PathFinding_Visualizer_WorldToScreenY($g_f_LastClickWorldY)

       ; Draw crosshair at click location
       Local $l_h_PenClick = _GDIPlus_PenCreate(0xFFFFFF00, 2)
       _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_ClickX - 10, $l_i_ClickY, $l_i_ClickX + 10, $l_i_ClickY, $l_h_PenClick)
       _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_ClickX, $l_i_ClickY - 10, $l_i_ClickX, $l_i_ClickY + 10, $l_h_PenClick)
       _GDIPlus_PenDispose($l_h_PenClick)
   EndIf

   _GDIPlus_FontDispose($l_h_Font)
   _GDIPlus_BrushDispose($l_h_BrushText)
   _GDIPlus_StringFormatDispose($l_h_Format)
EndFunc

; ===============================================================
; Coordinate conversion
; ===============================================================
Func PathFinding_Visualizer_WorldToScreenX($a_f_WorldX)
   Return $a_f_WorldX * $g_f_VisualizerScale + $g_f_VisualizerOffsetX
EndFunc

Func PathFinding_Visualizer_WorldToScreenY($a_f_WorldY)
   Return $g_i_VisualizerHeight - ($a_f_WorldY * $g_f_VisualizerScale + $g_f_VisualizerOffsetY)
EndFunc

Func PathFinding_Visualizer_ScreenToWorldX($a_i_ScreenX)
   Return ($a_i_ScreenX - $g_f_VisualizerOffsetX) / $g_f_VisualizerScale
EndFunc

Func PathFinding_Visualizer_ScreenToWorldY($a_i_ScreenY)
   Return ($g_i_VisualizerHeight - $a_i_ScreenY - $g_f_VisualizerOffsetY) / $g_f_VisualizerScale
EndFunc

; ===============================================================
; Controls - Fixed zoom functions
; ===============================================================
Func PathFinding_Visualizer_ZoomIn()
   ; Disable center on player when manually zooming
   $g_b_CenterOnPlayer = False

   ; Get current mouse position for zoom center
   Local $a_MouseInfo = GUIGetCursorInfo($g_h_VisualizerGUI)
   If IsArray($a_MouseInfo) Then
       ; Get world coordinates at mouse position
       Local $l_i_RelX = $a_MouseInfo[0] - 340
       Local $l_i_RelY = $a_MouseInfo[1] - 28

       Local $l_f_WorldX = PathFinding_Visualizer_ScreenToWorldX($l_i_RelX)
       Local $l_f_WorldY = PathFinding_Visualizer_ScreenToWorldY($l_i_RelY)

       ; Zoom in
       $g_f_VisualizerScale *= 1.5
       If $g_f_VisualizerScale > 10 Then $g_f_VisualizerScale = 10

       ; Adjust offset to keep mouse position at same world coordinate
       $g_f_VisualizerOffsetX = $l_i_RelX - $l_f_WorldX * $g_f_VisualizerScale
       $g_f_VisualizerOffsetY = $g_i_VisualizerHeight - $l_i_RelY - $l_f_WorldY * $g_f_VisualizerScale
   Else
       ; Fallback to center zoom
       Local $l_f_CenterX = PathFinding_Visualizer_ScreenToWorldX($g_i_VisualizerWidth / 2)
       Local $l_f_CenterY = PathFinding_Visualizer_ScreenToWorldY($g_i_VisualizerHeight / 2)

       $g_f_VisualizerScale *= 1.5
       If $g_f_VisualizerScale > 10 Then $g_f_VisualizerScale = 10

       $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $l_f_CenterX * $g_f_VisualizerScale
       $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $l_f_CenterY * $g_f_VisualizerScale
   EndIf

   PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_ZoomOut()
   ; Disable center on player when manually zooming
   $g_b_CenterOnPlayer = False

   ; Get current mouse position for zoom center
   Local $a_MouseInfo = GUIGetCursorInfo($g_h_VisualizerGUI)
   If IsArray($a_MouseInfo) Then
       ; Get world coordinates at mouse position
       Local $l_i_RelX = $a_MouseInfo[0] - 340
       Local $l_i_RelY = $a_MouseInfo[1] - 28

       Local $l_f_WorldX = PathFinding_Visualizer_ScreenToWorldX($l_i_RelX)
       Local $l_f_WorldY = PathFinding_Visualizer_ScreenToWorldY($l_i_RelY)

       ; Zoom out
       $g_f_VisualizerScale /= 1.5
       If $g_f_VisualizerScale < 0.001 Then $g_f_VisualizerScale = 0.001

       ; Adjust offset to keep mouse position at same world coordinate
       $g_f_VisualizerOffsetX = $l_i_RelX - $l_f_WorldX * $g_f_VisualizerScale
       $g_f_VisualizerOffsetY = $g_i_VisualizerHeight - $l_i_RelY - $l_f_WorldY * $g_f_VisualizerScale
   Else
       ; Fallback to center zoom
       Local $l_f_CenterX = PathFinding_Visualizer_ScreenToWorldX($g_i_VisualizerWidth / 2)
       Local $l_f_CenterY = PathFinding_Visualizer_ScreenToWorldY($g_i_VisualizerHeight / 2)

       $g_f_VisualizerScale /= 1.5
       If $g_f_VisualizerScale < 0.001 Then $g_f_VisualizerScale = 0.001

       $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $l_f_CenterX * $g_f_VisualizerScale
       $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $l_f_CenterY * $g_f_VisualizerScale
   EndIf

   PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_Reset()
   ; Re-enable initial centering for reset
   $g_b_InitialCenter = True

   ; Reset scale
   $g_f_VisualizerScale = 0.1

   ; Recalculate bounds and center
   PathFinding_Visualizer_CalculateBounds()

   PathFinding_Visualizer_Update()
EndFunc

Func PathFinding_Visualizer_SetPath($a_a_Path)
   If IsArray($a_a_Path) Then
       $g_a_VisualizerPath = $a_a_Path
       PathFinding_Visualizer_Update()
   EndIf
EndFunc

Func PathFinding_Visualizer_Close()
   PathFinding_Visualizer_Cleanup()
   $g_b_VisualizerInitialized = False
EndFunc

Func PathFinding_Visualizer_Cleanup()
   If $g_h_VisualizerPen Then _GDIPlus_PenDispose($g_h_VisualizerPen)
   If $g_h_VisualizerBrush Then _GDIPlus_BrushDispose($g_h_VisualizerBrush)
   If $g_h_VisualizerBuffer Then _GDIPlus_GraphicsDispose($g_h_VisualizerBuffer)
   If $g_h_VisualizerBitmap Then _GDIPlus_BitmapDispose($g_h_VisualizerBitmap)
   If $g_h_VisualizerGraphic Then _GDIPlus_GraphicsDispose($g_h_VisualizerGraphic)
   _GDIPlus_Shutdown()
EndFunc

; ===============================================================
; Mouse handling - Simplified for integrated version
; ===============================================================

; Right click handler
Func PathFinding_Visualizer_OnRightClick($a_i_RelX, $a_i_RelY)
   ; Use ConsoleWrite for debugging if Out() is not available
   If IsDeclared("g_h_EditText") Then
       Out("Right click at: " & $a_i_RelX & ", " & $a_i_RelY)
   Else
       ConsoleWrite("Right click at: " & $a_i_RelX & ", " & $a_i_RelY & @CRLF)
   EndIf

   ; Calculate world coordinates
   Local $l_f_WorldX = PathFinding_Visualizer_ScreenToWorldX($a_i_RelX)
   Local $l_f_WorldY = PathFinding_Visualizer_ScreenToWorldY($a_i_RelY)

   ; Update destination inputs
   If IsDeclared("GUIDestXInput") Then
       GUICtrlSetData(Eval("GUIDestXInput"), Round($l_f_WorldX, 2))
   EndIf
   If IsDeclared("GUIDestYInput") Then
       GUICtrlSetData(Eval("GUIDestYInput"), Round($l_f_WorldY, 2))
   EndIf

   ; Show visual feedback
   $g_f_LastClickWorldX = $l_f_WorldX
   $g_f_LastClickWorldY = $l_f_WorldY
   $g_b_ShowLastClick = True
   PathFinding_Visualizer_Update()
EndFunc

; Mouse wheel handler - Fixed for proper zoom
Func PathFinding_Visualizer_MouseWheel($hWnd, $iMsg, $wParam, $lParam)
   ; Disable center on player when manually zooming
   $g_b_CenterOnPlayer = False

   ; Get mouse position
   Local $a_MouseInfo = GUIGetCursorInfo($g_h_VisualizerGUI)
   If Not IsArray($a_MouseInfo) Then Return $GUI_RUNDEFMSG

   ; Check if mouse is over visualizer area
   If $a_MouseInfo[0] >= 340 And $a_MouseInfo[0] <= 340 + $g_i_VisualizerWidth And _
      $a_MouseInfo[1] >= 28 And $a_MouseInfo[1] <= 28 + $g_i_VisualizerHeight Then

       ; Get relative position within visualizer
       Local $l_i_RelX = $a_MouseInfo[0] - 340
       Local $l_i_RelY = $a_MouseInfo[1] - 28

       ; Get world coordinates at mouse position before zoom
       Local $l_f_WorldX = PathFinding_Visualizer_ScreenToWorldX($l_i_RelX)
       Local $l_f_WorldY = PathFinding_Visualizer_ScreenToWorldY($l_i_RelY)

       ; Get wheel delta
       Local $l_i_Delta = BitShift($wParam, 16) / 120

       ; Apply zoom
       If $l_i_Delta > 0 Then
           $g_f_VisualizerScale *= 1.2
           If $g_f_VisualizerScale > 10 Then $g_f_VisualizerScale = 10
       Else
           $g_f_VisualizerScale /= 1.2
           If $g_f_VisualizerScale < 0.001 Then $g_f_VisualizerScale = 0.001
       EndIf

       ; Adjust offset to keep mouse position at same world coordinate
       $g_f_VisualizerOffsetX = $l_i_RelX - $l_f_WorldX * $g_f_VisualizerScale
       $g_f_VisualizerOffsetY = $g_i_VisualizerHeight - $l_i_RelY - $l_f_WorldY * $g_f_VisualizerScale

       PathFinding_Visualizer_Update()
   EndIf

   Return $GUI_RUNDEFMSG
EndFunc