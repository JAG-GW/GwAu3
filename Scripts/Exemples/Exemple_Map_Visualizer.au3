#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <Array.au3>
#include <File.au3>
#include <Math.au3>
#include <Misc.au3>
#include <WinAPI.au3>

; Include pathfinding files
#include "../../API/Pathfinding/Pathfinding.au3"
#include "../../API/Pathfinding/SimplifyPath.au3"

; Initialize GDI+
_GDIPlus_Startup()

; Global variables
Global $g_h_GUI, $g_h_Graphics, $g_h_Bitmap, $g_h_GfxCtxt, $g_h_Pen, $g_h_Brush
Global $g_i_Width = 1200, $g_i_Height = 800
Global $g_f_Zoom = 1.0, $g_f_OffsetX = 0, $g_f_OffsetY = 0
Global $g_b_Dragging = False, $g_i_DragStartX, $g_i_DragStartY
Global $g_f_DragOffsetX, $g_f_DragOffsetY

; Map data structures - Only keep what we display
Global $g_amx2_Trapezoids[0] ; Will store: [id, layer, ax, ay, bx, by, cx, cy, dx, dy]
Global $g_amx2_Points[0]      ; Will store: [id, pos_x, pos_y, box_id, layer, box2_id, portal_id]
Global $g_amx2_Teleports[0]   ; Will store: [enter_x, enter_y, enter_z, exit_x, exit_y, exit_z, bidirectional]
Global $g_amx2_TravelPortals[0] ; Will store: [pos_x, pos_y, model_id]

; Map bounds
Global $g_f_MapMinX = 0, $g_f_MapMinY = 0
Global $g_f_MapMaxX = 50000, $g_f_MapMaxY = 50000

; Display options
Global $g_b_ShowTrapezoids = True
Global $g_b_ShowPoints = True
Global $g_b_ShowTeleports = True
Global $g_b_ShowGrid = False
Global $g_i_SelectedLayer = -1 ; -1 = all layers

; Pathfinding variables
Global $g_b_PathfindingMode = False
Global $g_f_StartClickX = -1, $g_f_StartClickY = -1
Global $g_f_EndClickX = -1, $g_f_EndClickY = -1
Global $g_af2_CalculatedPath[0][3]
Global $g_b_ShowPath = False
Global $g_i_CurrentMapID = 0
Global $g_s_CurrentFile = ""

; Color scheme
Global Const $GC_I_COLOR_BACKGROUND = 0xFF1A1A1A ; Dark background
Global Const $GC_I_COLOR_GRID = 0x20FFFFFF
Global Const $GC_I_COLOR_TRAPEZOID = 0xFFB8B8B8 ; Light gray for trapezoids
Global $g_ai_LayerColors[10]

; Initialize layer colors with red/pink gradient
For $i = 0 To 9
    Local $l_i_Red, $l_i_Green, $l_i_Blue
    Switch $i
        Case 0
            ; Layer 0 uses the default gray
            $g_ai_LayerColors[$i] = $GC_I_COLOR_TRAPEZOID
        Case 1
            ; Light pink/red
            $g_ai_LayerColors[$i] = 0xFFFF9696
        Case 2
            $g_ai_LayerColors[$i] = 0xFFFF7878
        Case 3
            $g_ai_LayerColors[$i] = 0xFFFF5A5A
        Case 4
            $g_ai_LayerColors[$i] = 0xFFFF3C3C
        Case 5
            $g_ai_LayerColors[$i] = 0xFFF02828
        Case 6
            $g_ai_LayerColors[$i] = 0xFFDC1E1E
        Case 7
            $g_ai_LayerColors[$i] = 0xFFC81414
        Case 8
            $g_ai_LayerColors[$i] = 0xFFB40A0A
        Case 9
            ; Dark red
            $g_ai_LayerColors[$i] = 0xFFA00000
    EndSwitch
Next

; Create main GUI
$g_h_GUI = GUICreate("GW Map Visualizer with Pathfinding", $g_i_Width, $g_i_Height)

; Register Windows message handler for mouse wheel
GUIRegisterMsg($WM_MOUSEWHEEL, "WM_MOUSEWHEEL")

; Create menu
Local $l_h_FileMenu = GUICtrlCreateMenu("&File")
Local $l_h_OpenItem = GUICtrlCreateMenuItem("&Open .gwau3 file..." & @TAB & "Ctrl+O", $l_h_FileMenu)
Local $l_h_ExitItem = GUICtrlCreateMenuItem("E&xit" & @TAB & "Alt+F4", $l_h_FileMenu)

Local $l_h_ViewMenu = GUICtrlCreateMenu("&View")
Local $l_h_ShowTrapItem = GUICtrlCreateMenuItem("Show &Trapezoids" & @TAB & "T", $l_h_ViewMenu)
GUICtrlSetState($l_h_ShowTrapItem, $GUI_CHECKED)
Local $l_h_ShowPointItem = GUICtrlCreateMenuItem("Show P&oints" & @TAB & "O", $l_h_ViewMenu)
GUICtrlSetState($l_h_ShowPointItem, $GUI_CHECKED)
Local $l_h_ShowTeleportItem = GUICtrlCreateMenuItem("Show T&eleports" & @TAB & "E", $l_h_ViewMenu)
GUICtrlSetState($l_h_ShowTeleportItem, $GUI_CHECKED)
GUICtrlCreateMenuItem("", $l_h_ViewMenu)
Local $l_h_ShowGridItem = GUICtrlCreateMenuItem("Show &Grid" & @TAB & "G", $l_h_ViewMenu)
GUICtrlCreateMenuItem("", $l_h_ViewMenu)
Local $l_h_ResetViewItem = GUICtrlCreateMenuItem("&Reset View" & @TAB & "R", $l_h_ViewMenu)
Local $l_h_ZoomInItem = GUICtrlCreateMenuItem("Zoom &In" & @TAB & "+", $l_h_ViewMenu)
Local $l_h_ZoomOutItem = GUICtrlCreateMenuItem("Zoom &Out" & @TAB & "-", $l_h_ViewMenu)
Local $l_h_FitToWindowItem = GUICtrlCreateMenuItem("&Fit to Window" & @TAB & "F", $l_h_ViewMenu)

Local $l_h_LayerMenu = GUICtrlCreateMenu("&Layer")
Local $l_h_AllLayersItem = GUICtrlCreateMenuItem("Show &All Layers", $l_h_LayerMenu)
GUICtrlSetState($l_h_AllLayersItem, $GUI_CHECKED)
GUICtrlCreateMenuItem("", $l_h_LayerMenu)
Local $l_ah_LayerItems[10]
For $i = 0 To 9
    $l_ah_LayerItems[$i] = GUICtrlCreateMenuItem("Layer " & $i, $l_h_LayerMenu)
Next

; Add Pathfinding menu
Local $l_h_PathfindingMenu = GUICtrlCreateMenu("&Pathfinding")
Local $l_h_TogglePathfindingItem = GUICtrlCreateMenuItem("&Enable Pathfinding Mode" & @TAB & "P", $l_h_PathfindingMenu)
Local $l_h_ClearPathItem = GUICtrlCreateMenuItem("&Clear Path" & @TAB & "C", $l_h_PathfindingMenu)
GUICtrlCreateMenuItem("", $l_h_PathfindingMenu)
Local $l_h_AggressivenessMenu = GUICtrlCreateMenu("Path Optimization", $l_h_PathfindingMenu)
Local $l_h_Aggr0Item = GUICtrlCreateMenuItem("0% (Safest)", $l_h_AggressivenessMenu)
Local $l_h_Aggr25Item = GUICtrlCreateMenuItem("25%", $l_h_AggressivenessMenu)
Local $l_h_Aggr50Item = GUICtrlCreateMenuItem("50% (Default)", $l_h_AggressivenessMenu)
GUICtrlSetState($l_h_Aggr50Item, $GUI_CHECKED)
Local $l_h_Aggr75Item = GUICtrlCreateMenuItem("75%", $l_h_AggressivenessMenu)
Local $l_h_Aggr100Item = GUICtrlCreateMenuItem("100% (Most Direct)", $l_h_AggressivenessMenu)

Global $g_f_PathAggressiveness = 0.5

; Create graphics
$g_h_Graphics = _GDIPlus_GraphicsCreateFromHWND($g_h_GUI)
$g_h_Bitmap = _GDIPlus_BitmapCreateFromGraphics($g_i_Width, $g_i_Height, $g_h_Graphics)
$g_h_GfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_h_Bitmap)
_GDIPlus_GraphicsSetSmoothingMode($g_h_GfxCtxt, 0) ; Disable antialiasing for sharp edges

; Show GUI
GUISetState(@SW_SHOW)

; Register hotkeys
HotKeySet("^o", "HotkeyOpen")
HotKeySet("t", "ToggleTrapezoids")
HotKeySet("o", "TogglePoints")
HotKeySet("e", "ToggleTeleports")
HotKeySet("g", "ToggleGrid")
HotKeySet("r", "ResetView")
HotKeySet("+", "ZoomIn")
HotKeySet("-", "ZoomOut")
HotKeySet("f", "FitToWindow")
HotKeySet("p", "TogglePathfindingMode")
HotKeySet("c", "ClearPath")

; Initial draw
DrawMap()

; Main loop
While 1
    Local $l_i_Msg = GUIGetMsg()

    Switch $l_i_Msg
        Case $GUI_EVENT_CLOSE, $l_h_ExitItem
            ExitLoop

        Case $l_h_OpenItem
            LoadMapFile()

        Case $l_h_ShowTrapItem
            ToggleTrapezoids()

        Case $l_h_ShowPointItem
            TogglePoints()

        Case $l_h_ShowTeleportItem
            ToggleTeleports()

        Case $l_h_ShowGridItem
            ToggleGrid()

        Case $l_h_ResetViewItem
            ResetView()

        Case $l_h_ZoomInItem
            ZoomIn()

        Case $l_h_ZoomOutItem
            ZoomOut()

        Case $l_h_FitToWindowItem
            FitToWindow()

        Case $l_h_TogglePathfindingItem
            TogglePathfindingMode()

        Case $l_h_ClearPathItem
            ClearPath()

        Case $l_h_Aggr0Item
            SetAggressiveness(0)
            CheckAggressivenessMenu($l_h_Aggr0Item, $l_h_Aggr25Item, $l_h_Aggr50Item, $l_h_Aggr75Item, $l_h_Aggr100Item)

        Case $l_h_Aggr25Item
            SetAggressiveness(0.25)
            CheckAggressivenessMenu($l_h_Aggr25Item, $l_h_Aggr0Item, $l_h_Aggr50Item, $l_h_Aggr75Item, $l_h_Aggr100Item)

        Case $l_h_Aggr50Item
            SetAggressiveness(0.5)
            CheckAggressivenessMenu($l_h_Aggr50Item, $l_h_Aggr0Item, $l_h_Aggr25Item, $l_h_Aggr75Item, $l_h_Aggr100Item)

        Case $l_h_Aggr75Item
            SetAggressiveness(0.75)
            CheckAggressivenessMenu($l_h_Aggr75Item, $l_h_Aggr0Item, $l_h_Aggr25Item, $l_h_Aggr50Item, $l_h_Aggr100Item)

        Case $l_h_Aggr100Item
            SetAggressiveness(1.0)
            CheckAggressivenessMenu($l_h_Aggr100Item, $l_h_Aggr0Item, $l_h_Aggr25Item, $l_h_Aggr50Item, $l_h_Aggr75Item)

        Case $l_h_AllLayersItem
            $g_i_SelectedLayer = -1
            For $i = 0 To 9
                GUICtrlSetState($l_ah_LayerItems[$i], $GUI_UNCHECKED)
            Next
            GUICtrlSetState($l_h_AllLayersItem, $GUI_CHECKED)
            DrawMap()

        Case $l_ah_LayerItems[0] To $l_ah_LayerItems[9]
            For $i = 0 To 9
                If $l_i_Msg = $l_ah_LayerItems[$i] Then
                    $g_i_SelectedLayer = $i
                    GUICtrlSetState($l_ah_LayerItems[$i], $GUI_CHECKED)
                    GUICtrlSetState($l_h_AllLayersItem, $GUI_UNCHECKED)
                Else
                    GUICtrlSetState($l_ah_LayerItems[$i], $GUI_UNCHECKED)
                EndIf
            Next
            DrawMap()

        Case $GUI_EVENT_PRIMARYDOWN
            Local $l_ai_MousePos = MouseGetPos()
            Local $l_ai_WinPos = WinGetPos($g_h_GUI)
            Local $l_ai_ClientPos = WinGetClientSize($g_h_GUI)

            ; Calculate mouse position relative to client area
            Local $l_i_MouseX = $l_ai_MousePos[0] - $l_ai_WinPos[0] - (($l_ai_WinPos[2] - $l_ai_ClientPos[0]) / 2)
            Local $l_i_MouseY = $l_ai_MousePos[1] - $l_ai_WinPos[1] - (($l_ai_WinPos[3] - $l_ai_ClientPos[1]) - (($l_ai_WinPos[2] - $l_ai_ClientPos[0]) / 2))

            If $g_b_PathfindingMode Then
                ; Convert screen coordinates to world coordinates
                Local $l_f_WorldX = ScreenToWorldX($l_i_MouseX)
                Local $l_f_WorldY = ScreenToWorldY($l_i_MouseY)

                If $g_f_StartClickX = -1 Then
                    ; First click - set start point
                    $g_f_StartClickX = $l_f_WorldX
                    $g_f_StartClickY = $l_f_WorldY
                    $g_f_EndClickX = -1
                    $g_f_EndClickY = -1
                    $g_b_ShowPath = False
                    ConsoleWrite("Start point set: " & Round($l_f_WorldX) & ", " & Round($l_f_WorldY) & @CRLF)
                Else
                    ; Second click - set end point and calculate path
                    $g_f_EndClickX = $l_f_WorldX
                    $g_f_EndClickY = $l_f_WorldY
                    ConsoleWrite("End point set: " & Round($l_f_WorldX) & ", " & Round($l_f_WorldY) & @CRLF)

                    ; Calculate path
                    CalculateAndShowPath()
                EndIf
                DrawMap()
            Else
                ; Normal drag mode
                $g_b_Dragging = True
                $g_i_DragStartX = $l_ai_MousePos[0]
                $g_i_DragStartY = $l_ai_MousePos[1]
                $g_f_DragOffsetX = $g_f_OffsetX
                $g_f_DragOffsetY = $g_f_OffsetY
            EndIf

        Case $GUI_EVENT_PRIMARYUP
            $g_b_Dragging = False

        Case $GUI_EVENT_MOUSEMOVE
            If $g_b_Dragging And Not $g_b_PathfindingMode Then
                Local $l_ai_MousePos = MouseGetPos()
                $g_f_OffsetX = $g_f_DragOffsetX + ($l_ai_MousePos[0] - $g_i_DragStartX)
                $g_f_OffsetY = $g_f_DragOffsetY + ($l_ai_MousePos[1] - $g_i_DragStartY)
                DrawMap()
            EndIf
    EndSwitch
WEnd

; Cleanup
_GDIPlus_GraphicsDispose($g_h_GfxCtxt)
_GDIPlus_BitmapDispose($g_h_Bitmap)
_GDIPlus_GraphicsDispose($g_h_Graphics)
_GDIPlus_Shutdown()
GUIDelete()

; Functions
Func LoadMapFile()
    Local $l_s_File = FileOpenDialog("Open GWAU3 File", @ScriptDir, "GWAU3 Files (*.gwau3)|All Files (*.*)")
    If @error Then Return

    $g_s_CurrentFile = $l_s_File

    ; Extract map ID from filename (assuming format: MapID_*.gwau3)
    Local $l_s_FileName = StringRegExpReplace($l_s_File, "^.*\\", "")
    Local $l_as_Match = StringRegExp($l_s_FileName, "^(\d+)_", 1)
    If IsArray($l_as_Match) Then
        $g_i_CurrentMapID = Number($l_as_Match[0])
        ConsoleWrite("Map ID detected: " & $g_i_CurrentMapID & @CRLF)
    EndIf

    ; Clear existing data
    ReDim $g_amx2_Trapezoids[0]
    ReDim $g_amx2_Points[0]
    ReDim $g_amx2_Teleports[0]
    ReDim $g_amx2_TravelPortals[0]
    ClearPath()

    ; Read file
    Local $l_as_Lines = FileReadToArray($l_s_File)
    If @error Then
        MsgBox(16, "Error", "Failed to read file: " & $l_s_File)
        Return
    EndIf

    Local $l_s_Section = ""
    Local $l_i_Index = 0

    While $l_i_Index < UBound($l_as_Lines)
        Local $l_s_Line = StringStripWS($l_as_Lines[$l_i_Index], 3)

        ; Check for section header
        If StringLeft($l_s_Line, 1) = "[" And StringRight($l_s_Line, 1) = "]" Then
            $l_s_Section = StringMid($l_s_Line, 2, StringLen($l_s_Line) - 2)
            $l_i_Index += 1
            ContinueLoop
        EndIf

        ; Parse only sections we need for display
        Switch $l_s_Section
            Case "METADATA"
                If StringInStr($l_s_Line, "bounds_min=") Then
                    Local $l_as_Parts = StringSplit(StringMid($l_s_Line, 12), ",", 2)
                    If UBound($l_as_Parts) >= 2 Then
                        $g_f_MapMinX = Number($l_as_Parts[0])
                        $g_f_MapMinY = Number($l_as_Parts[1])
                    EndIf
                ElseIf StringInStr($l_s_Line, "bounds_max=") Then
                    Local $l_as_Parts = StringSplit(StringMid($l_s_Line, 12), ",", 2)
                    If UBound($l_as_Parts) >= 2 Then
                        $g_f_MapMaxX = Number($l_as_Parts[0])
                        $g_f_MapMaxY = Number($l_as_Parts[1])
                    EndIf
                EndIf

            Case "TRAPEZOIDS"
                If StringInStr($l_s_Line, "count=") Then
                    Local $l_i_Count = Number(StringMid($l_s_Line, 7))
                    ReDim $g_amx2_Trapezoids[$l_i_Count][10]
                    For $j = 0 To $l_i_Count - 1
                        $l_i_Index += 1
                        If $l_i_Index >= UBound($l_as_Lines) Then ExitLoop
                        ParseTrapezoid($l_as_Lines[$l_i_Index], $j)
                    Next
                EndIf

            Case "POINTS"
                If StringInStr($l_s_Line, "count=") Then
                    Local $l_i_Count = Number(StringMid($l_s_Line, 7))
                    ReDim $g_amx2_Points[$l_i_Count][7]
                    For $j = 0 To $l_i_Count - 1
                        $l_i_Index += 1
                        If $l_i_Index >= UBound($l_as_Lines) Then ExitLoop
                        ParsePoint($l_as_Lines[$l_i_Index], $j)
                    Next
                EndIf

            Case "TELEPORTS"
                If StringInStr($l_s_Line, "count=") Then
                    Local $l_i_Count = Number(StringMid($l_s_Line, 7))
                    ReDim $g_amx2_Teleports[$l_i_Count][7]
                    For $j = 0 To $l_i_Count - 1
                        $l_i_Index += 1
                        If $l_i_Index >= UBound($l_as_Lines) Then ExitLoop
                        ParseTeleport($l_as_Lines[$l_i_Index], $j)
                    Next
                EndIf

            Case "TRAVEL_PORTALS"
                If StringInStr($l_s_Line, "count=") Then
                    Local $l_i_Count = Number(StringMid($l_s_Line, 7))
                    ReDim $g_amx2_TravelPortals[$l_i_Count][3]
                    For $j = 0 To $l_i_Count - 1
                        $l_i_Index += 1
                        If $l_i_Index >= UBound($l_as_Lines) Then ExitLoop
                        ParseTravelPortal($l_as_Lines[$l_i_Index], $j)
                    Next
                EndIf
        EndSwitch

        $l_i_Index += 1
    WEnd

    ; Load pathfinding data for this map
    ConsoleWrite("Loading pathfinding data..." & @CRLF)
    If Pathfinding_LoadData($l_s_File) Then
        ConsoleWrite("Pathfinding data loaded successfully" & @CRLF)
    Else
        ConsoleWrite("Failed to load pathfinding data" & @CRLF)
    EndIf

    ; Fit to window after loading
    FitToWindow()

    ; Update window title
    WinSetTitle($g_h_GUI, "", "GW Map Visualizer - " & StringRegExpReplace($l_s_File, "^.*\\", "") & " - Pathfinding: " & ($g_b_PathfindingMode ? "ON" : "OFF"))
EndFunc

Func ParseTrapezoid($a_s_Line, $a_i_Index)
    Local $l_as_Parts = StringSplit($a_s_Line, "|", 2)
    If UBound($l_as_Parts) < 6 Then Return

    $g_amx2_Trapezoids[$a_i_Index][0] = Number($l_as_Parts[0]) ; id
    $g_amx2_Trapezoids[$a_i_Index][1] = Number($l_as_Parts[1]) ; layer

    ; Parse vertices A, B, C, D
    For $i = 0 To 3
        Local $l_as_Coords = StringSplit($l_as_Parts[$i + 2], ",", 2)
        If UBound($l_as_Coords) >= 2 Then
            $g_amx2_Trapezoids[$a_i_Index][2 + $i * 2] = Number($l_as_Coords[0])     ; x coordinate
            $g_amx2_Trapezoids[$a_i_Index][2 + $i * 2 + 1] = Number($l_as_Coords[1]) ; y coordinate
        EndIf
    Next
EndFunc

Func ParsePoint($a_s_Line, $a_i_Index)
    Local $l_as_Parts = StringSplit($a_s_Line, "|", 2)
    If UBound($l_as_Parts) < 6 Then Return

    $g_amx2_Points[$a_i_Index][0] = Number($l_as_Parts[0]) ; id

    ; Parse position
    Local $l_as_Pos = StringSplit($l_as_Parts[1], ",", 2)
    If UBound($l_as_Pos) >= 2 Then
        $g_amx2_Points[$a_i_Index][1] = Number($l_as_Pos[0])
        $g_amx2_Points[$a_i_Index][2] = Number($l_as_Pos[1])
    EndIf

    $g_amx2_Points[$a_i_Index][3] = Number($l_as_Parts[2]) ; box_id
    $g_amx2_Points[$a_i_Index][4] = Number($l_as_Parts[3]) ; layer
    $g_amx2_Points[$a_i_Index][5] = Number($l_as_Parts[4]) ; box2_id
    $g_amx2_Points[$a_i_Index][6] = Number($l_as_Parts[5]) ; portal_id
EndFunc

Func ParseTeleport($a_s_Line, $a_i_Index)
    Local $l_as_Parts = StringSplit($a_s_Line, "|", 2)
    If UBound($l_as_Parts) < 3 Then Return

    ; Parse enter position
    Local $l_as_Enter = StringSplit($l_as_Parts[0], ",", 2)
    If UBound($l_as_Enter) >= 3 Then
        $g_amx2_Teleports[$a_i_Index][0] = Number($l_as_Enter[0])
        $g_amx2_Teleports[$a_i_Index][1] = Number($l_as_Enter[1])
        $g_amx2_Teleports[$a_i_Index][2] = Number($l_as_Enter[2])
    EndIf

    ; Parse exit position
    Local $l_as_Exit = StringSplit($l_as_Parts[1], ",", 2)
    If UBound($l_as_Exit) >= 3 Then
        $g_amx2_Teleports[$a_i_Index][3] = Number($l_as_Exit[0])
        $g_amx2_Teleports[$a_i_Index][4] = Number($l_as_Exit[1])
        $g_amx2_Teleports[$a_i_Index][5] = Number($l_as_Exit[2])
    EndIf

    $g_amx2_Teleports[$a_i_Index][6] = Number($l_as_Parts[2]) ; bidirectional
EndFunc

Func ParseTravelPortal($a_s_Line, $a_i_Index)
    Local $l_as_Parts = StringSplit($a_s_Line, "|", 2)
    If UBound($l_as_Parts) < 2 Then Return

    ; Parse position
    Local $l_as_Pos = StringSplit($l_as_Parts[0], ",", 2)
    If UBound($l_as_Pos) >= 2 Then
        $g_amx2_TravelPortals[$a_i_Index][0] = Number($l_as_Pos[0])
        $g_amx2_TravelPortals[$a_i_Index][1] = Number($l_as_Pos[1])
    EndIf

    $g_amx2_TravelPortals[$a_i_Index][2] = Number($l_as_Parts[1]) ; model_id
EndFunc

Func DrawMap()
    ; Clear background
    _GDIPlus_GraphicsClear($g_h_GfxCtxt, $GC_I_COLOR_BACKGROUND)

    ; Draw grid
    If $g_b_ShowGrid Then DrawGrid()

    ; Draw map elements
    If $g_b_ShowTrapezoids Then DrawTrapezoids()
    If $g_b_ShowTeleports Then DrawTeleports()
    If $g_b_ShowPoints Then DrawPoints()

    ; Draw pathfinding elements
    DrawPathfindingElements()

    ; Draw info
    DrawInfo()

    ; Update display
    _GDIPlus_GraphicsDrawImage($g_h_Graphics, $g_h_Bitmap, 0, 0)
EndFunc

Func DrawGrid()
    Local $l_h_Pen = _GDIPlus_PenCreate($GC_I_COLOR_GRID, 1)

    ; Calculate grid spacing based on zoom
    Local $l_f_GridSize = 1000
    If $g_f_Zoom < 0.05 Then $l_f_GridSize = 10000
    If $g_f_Zoom < 0.01 Then $l_f_GridSize = 50000
    If $g_f_Zoom > 0.5 Then $l_f_GridSize = 500
    If $g_f_Zoom > 2 Then $l_f_GridSize = 100

    ; Draw vertical lines
    Local $l_f_StartX = Floor($g_f_MapMinX / $l_f_GridSize) * $l_f_GridSize
    Local $l_f_EndX = Ceiling($g_f_MapMaxX / $l_f_GridSize) * $l_f_GridSize

    For $x = $l_f_StartX To $l_f_EndX Step $l_f_GridSize
        Local $l_i_ScreenX = WorldToScreenX($x)
        _GDIPlus_GraphicsDrawLine($g_h_GfxCtxt, $l_i_ScreenX, 0, $l_i_ScreenX, $g_i_Height, $l_h_Pen)
    Next

    ; Draw horizontal lines
    Local $l_f_StartY = Floor($g_f_MapMinY / $l_f_GridSize) * $l_f_GridSize
    Local $l_f_EndY = Ceiling($g_f_MapMaxY / $l_f_GridSize) * $l_f_GridSize

    For $y = $l_f_StartY To $l_f_EndY Step $l_f_GridSize
        Local $l_i_ScreenY = WorldToScreenY($y)
        _GDIPlus_GraphicsDrawLine($g_h_GfxCtxt, 0, $l_i_ScreenY, $g_i_Width, $l_i_ScreenY, $l_h_Pen)
    Next

    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func DrawTrapezoids()
    For $i = 0 To UBound($g_amx2_Trapezoids) - 1
        Local $l_i_Layer = $g_amx2_Trapezoids[$i][1]

        ; Check layer filter
        If $g_i_SelectedLayer >= 0 And $l_i_Layer <> $g_i_SelectedLayer Then ContinueLoop

        ; Choose color based on layer
        Local $l_i_LayerColor = $g_ai_LayerColors[Mod($l_i_Layer, 10)]
        Local $l_h_Brush = _GDIPlus_BrushCreateSolid($l_i_LayerColor)

        ; Get the 4 vertices
        Local $l_i_Ax = WorldToScreenX($g_amx2_Trapezoids[$i][2])
        Local $l_i_Ay = WorldToScreenY($g_amx2_Trapezoids[$i][3])
        Local $l_i_Bx = WorldToScreenX($g_amx2_Trapezoids[$i][4])
        Local $l_i_By = WorldToScreenY($g_amx2_Trapezoids[$i][5])
        Local $l_i_Cx = WorldToScreenX($g_amx2_Trapezoids[$i][6])
        Local $l_i_Cy = WorldToScreenY($g_amx2_Trapezoids[$i][7])
        Local $l_i_Dx = WorldToScreenX($g_amx2_Trapezoids[$i][8])
        Local $l_i_Dy = WorldToScreenY($g_amx2_Trapezoids[$i][9])

        ; Draw filled trapezoid using path (NO OUTLINE)
        Local $l_h_Path = _GDIPlus_PathCreate()
        _GDIPlus_PathAddLine($l_h_Path, $l_i_Ax, $l_i_Ay, $l_i_Bx, $l_i_By)
        _GDIPlus_PathAddLine($l_h_Path, $l_i_Bx, $l_i_By, $l_i_Cx, $l_i_Cy)
        _GDIPlus_PathAddLine($l_h_Path, $l_i_Cx, $l_i_Cy, $l_i_Dx, $l_i_Dy)
        _GDIPlus_PathCloseFigure($l_h_Path)

        ; Fill the path only
        _GDIPlus_GraphicsFillPath($g_h_GfxCtxt, $l_h_Path, $l_h_Brush)

        ; Cleanup
        _GDIPlus_PathDispose($l_h_Path)
        _GDIPlus_BrushDispose($l_h_Brush)
    Next
EndFunc

Func DrawPoints()
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFF00AAFF) ; Light blue for points

    For $i = 0 To UBound($g_amx2_Points) - 1
        Local $l_i_Layer = $g_amx2_Points[$i][4]

        ; Check layer filter
        If $g_i_SelectedLayer >= 0 And $l_i_Layer <> $g_i_SelectedLayer Then ContinueLoop

        Local $l_i_X = WorldToScreenX($g_amx2_Points[$i][1])
        Local $l_i_Y = WorldToScreenY($g_amx2_Points[$i][2])

        ; Draw points
        _GDIPlus_GraphicsFillEllipse($g_h_GfxCtxt, $l_i_X - 3, $l_i_Y - 3, 6, 6, $l_h_Brush)
    Next

    _GDIPlus_BrushDispose($l_h_Brush)
EndFunc

Func DrawTeleports()
    Local $l_h_PenEnter = _GDIPlus_PenCreate(0xFF00FF00, 2) ; Green for enter
    Local $l_h_PenExit = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Red for exit
    Local $l_h_PenLink = _GDIPlus_PenCreate(0xFF00FFFF, 1) ; Cyan for link
    _GDIPlus_PenSetDashStyle($l_h_PenLink, 1) ; Dashed line

    For $i = 0 To UBound($g_amx2_Teleports) - 1
        Local $l_i_LayerEnter = $g_amx2_Teleports[$i][2]
        Local $l_i_LayerExit = $g_amx2_Teleports[$i][5]

        ; Check layer filter
        If $g_i_SelectedLayer >= 0 And $l_i_LayerEnter <> $g_i_SelectedLayer And $l_i_LayerExit <> $g_i_SelectedLayer Then ContinueLoop

        Local $l_i_X1 = WorldToScreenX($g_amx2_Teleports[$i][0])
        Local $l_i_Y1 = WorldToScreenY($g_amx2_Teleports[$i][1])
        Local $l_i_X2 = WorldToScreenX($g_amx2_Teleports[$i][3])
        Local $l_i_Y2 = WorldToScreenY($g_amx2_Teleports[$i][4])

        ; Draw connection line
        _GDIPlus_GraphicsDrawLine($g_h_GfxCtxt, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_PenLink)

        ; Draw enter point (green square)
        _GDIPlus_GraphicsDrawRect($g_h_GfxCtxt, $l_i_X1 - 4, $l_i_Y1 - 4, 8, 8, $l_h_PenEnter)

        ; Draw exit point (red circle)
        _GDIPlus_GraphicsDrawEllipse($g_h_GfxCtxt, $l_i_X2 - 4, $l_i_Y2 - 4, 8, 8, $l_h_PenExit)

        ; Draw arrow if unidirectional
        If $g_amx2_Teleports[$i][6] = 0 Then
            DrawArrow($l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_PenLink)
        EndIf
    Next

    ; Draw travel portals
    Local $l_h_PenTravel = _GDIPlus_PenCreate(0xFFFFAA00, 2) ; Orange
    Local $l_h_BrushTravel = _GDIPlus_BrushCreateSolid(0x40FFAA00) ; Semi-transparent orange
    For $i = 0 To UBound($g_amx2_TravelPortals) - 1
        Local $l_i_X = WorldToScreenX($g_amx2_TravelPortals[$i][0])
        Local $l_i_Y = WorldToScreenY($g_amx2_TravelPortals[$i][1])

        _GDIPlus_GraphicsFillEllipse($g_h_GfxCtxt, $l_i_X - 6, $l_i_Y - 6, 12, 12, $l_h_BrushTravel)
        _GDIPlus_GraphicsDrawEllipse($g_h_GfxCtxt, $l_i_X - 6, $l_i_Y - 6, 12, 12, $l_h_PenTravel)
    Next

    _GDIPlus_PenDispose($l_h_PenEnter)
    _GDIPlus_PenDispose($l_h_PenExit)
    _GDIPlus_PenDispose($l_h_PenLink)
    _GDIPlus_PenDispose($l_h_PenTravel)
    _GDIPlus_BrushDispose($l_h_BrushTravel)
EndFunc

Func DrawPathfindingElements()
    ; Draw start point
    If $g_f_StartClickX <> -1 Then
        Local $l_h_BrushStart = _GDIPlus_BrushCreateSolid(0xFF00FF00) ; Green
        Local $l_i_X = WorldToScreenX($g_f_StartClickX)
        Local $l_i_Y = WorldToScreenY($g_f_StartClickY)
        _GDIPlus_GraphicsFillEllipse($g_h_GfxCtxt, $l_i_X - 8, $l_i_Y - 8, 16, 16, $l_h_BrushStart)

        ; Draw "S" label
        Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFF000000)
        Local $l_h_Format = _GDIPlus_StringFormatCreate()
        Local $l_h_Family = _GDIPlus_FontFamilyCreate("Arial")
        Local $l_h_Font = _GDIPlus_FontCreate($l_h_Family, 10, 1)
        Local $l_t_Layout = _GDIPlus_RectFCreate($l_i_X - 5, $l_i_Y - 7, 20, 20)
        _GDIPlus_GraphicsDrawStringEx($g_h_GfxCtxt, "S", $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

        _GDIPlus_BrushDispose($l_h_BrushStart)
        _GDIPlus_BrushDispose($l_h_BrushText)
        _GDIPlus_FontDispose($l_h_Font)
        _GDIPlus_FontFamilyDispose($l_h_Family)
        _GDIPlus_StringFormatDispose($l_h_Format)
    EndIf

    ; Draw end point
    If $g_f_EndClickX <> -1 Then
        Local $l_h_BrushEnd = _GDIPlus_BrushCreateSolid(0xFFFF0000) ; Red
        Local $l_i_X = WorldToScreenX($g_f_EndClickX)
        Local $l_i_Y = WorldToScreenY($g_f_EndClickY)
        _GDIPlus_GraphicsFillEllipse($g_h_GfxCtxt, $l_i_X - 8, $l_i_Y - 8, 16, 16, $l_h_BrushEnd)

        ; Draw "E" label
        Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
        Local $l_h_Format = _GDIPlus_StringFormatCreate()
        Local $l_h_Family = _GDIPlus_FontFamilyCreate("Arial")
        Local $l_h_Font = _GDIPlus_FontCreate($l_h_Family, 10, 1)
        Local $l_t_Layout = _GDIPlus_RectFCreate($l_i_X - 5, $l_i_Y - 7, 20, 20)
        _GDIPlus_GraphicsDrawStringEx($g_h_GfxCtxt, "E", $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

        _GDIPlus_BrushDispose($l_h_BrushEnd)
        _GDIPlus_BrushDispose($l_h_BrushText)
        _GDIPlus_FontDispose($l_h_Font)
        _GDIPlus_FontFamilyDispose($l_h_Family)
        _GDIPlus_StringFormatDispose($l_h_Format)
    EndIf

    ; Draw calculated path
    If $g_b_ShowPath And UBound($g_af2_CalculatedPath) > 0 Then
        Local $l_h_PenPath = _GDIPlus_PenCreate(0xFFFFFF00, 3) ; Yellow
        Local $l_h_BrushWaypoint = _GDIPlus_BrushCreateSolid(0xFFFF8800) ; Orange

        ; Draw path lines
        For $i = 1 To UBound($g_af2_CalculatedPath) - 1
            Local $l_i_X1 = WorldToScreenX($g_af2_CalculatedPath[$i-1][0])
            Local $l_i_Y1 = WorldToScreenY($g_af2_CalculatedPath[$i-1][1])
            Local $l_i_X2 = WorldToScreenX($g_af2_CalculatedPath[$i][0])
            Local $l_i_Y2 = WorldToScreenY($g_af2_CalculatedPath[$i][1])

            _GDIPlus_GraphicsDrawLine($g_h_GfxCtxt, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_PenPath)
        Next

        ; Draw waypoints
        For $i = 1 To UBound($g_af2_CalculatedPath) - 2
            Local $l_i_X = WorldToScreenX($g_af2_CalculatedPath[$i][0])
            Local $l_i_Y = WorldToScreenY($g_af2_CalculatedPath[$i][1])
            _GDIPlus_GraphicsFillEllipse($g_h_GfxCtxt, $l_i_X - 4, $l_i_Y - 4, 8, 8, $l_h_BrushWaypoint)
        Next

        _GDIPlus_PenDispose($l_h_PenPath)
        _GDIPlus_BrushDispose($l_h_BrushWaypoint)
    EndIf
EndFunc

Func DrawArrow($a_i_X1, $a_i_Y1, $a_i_X2, $a_i_Y2, $a_h_Pen)
    Local $l_f_Angle = ATan2($a_i_Y2 - $a_i_Y1, $a_i_X2 - $a_i_X1)
    Local $l_f_ArrowLen = 10
    Local $l_f_ArrowAngle = 0.5

    Local $l_i_XArr1 = $a_i_X2 - $l_f_ArrowLen * Cos($l_f_Angle - $l_f_ArrowAngle)
    Local $l_i_YArr1 = $a_i_Y2 - $l_f_ArrowLen * Sin($l_f_Angle - $l_f_ArrowAngle)
    Local $l_i_XArr2 = $a_i_X2 - $l_f_ArrowLen * Cos($l_f_Angle + $l_f_ArrowAngle)
    Local $l_i_YArr2 = $a_i_Y2 - $l_f_ArrowLen * Sin($l_f_Angle + $l_f_ArrowAngle)

    _GDIPlus_GraphicsDrawLine($g_h_GfxCtxt, $a_i_X2, $a_i_Y2, $l_i_XArr1, $l_i_YArr1, $a_h_Pen)
    _GDIPlus_GraphicsDrawLine($g_h_GfxCtxt, $a_i_X2, $a_i_Y2, $l_i_XArr2, $l_i_YArr2, $a_h_Pen)
EndFunc

Func DrawInfo()
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    Local $l_h_Format = _GDIPlus_StringFormatCreate()
    Local $l_h_Family = _GDIPlus_FontFamilyCreate("Consolas")
    Local $l_h_Font = _GDIPlus_FontCreate($l_h_Family, 10)

    Local $l_s_Info = StringFormat("Zoom: %.2f%%", $g_f_Zoom * 100)
    If $g_i_SelectedLayer >= 0 Then $l_s_Info &= " | Layer: " & $g_i_SelectedLayer
    $l_s_Info &= " | Pathfinding: " & ($g_b_PathfindingMode ? "ON" : "OFF")
    If $g_b_PathfindingMode Then
        $l_s_Info &= " | Optimization: " & Round($g_f_PathAggressiveness * 100) & "%"
        If $g_f_StartClickX <> -1 And $g_f_EndClickX = -1 Then
            $l_s_Info &= " | Click to set END point"
        ElseIf $g_f_StartClickX = -1 Then
            $l_s_Info &= " | Click to set START point"
        EndIf
        If $g_b_ShowPath And UBound($g_af2_CalculatedPath) > 0 Then
            $l_s_Info &= " | Path: " & UBound($g_af2_CalculatedPath) & " waypoints"
        EndIf
    EndIf
    $l_s_Info &= @CRLF & "Controls: Mouse drag to pan, wheel to zoom, +/- zoom, R reset, F fit"
    $l_s_Info &= @CRLF & "Toggle: T trapezoids, O points, E teleports, G grid, P pathfinding, C clear path"

    Local $l_t_Layout = _GDIPlus_RectFCreate(5, 5, 800, 60)
    _GDIPlus_GraphicsDrawStringEx($g_h_GfxCtxt, $l_s_Info, $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_Brush)

    _GDIPlus_FontDispose($l_h_Font)
    _GDIPlus_FontFamilyDispose($l_h_Family)
    _GDIPlus_StringFormatDispose($l_h_Format)
    _GDIPlus_BrushDispose($l_h_Brush)
EndFunc

; Coordinate conversion functions
Func WorldToScreenX($a_f_WorldX)
    Return ($a_f_WorldX - $g_f_MapMinX) * $g_f_Zoom + $g_f_OffsetX
EndFunc

Func WorldToScreenY($a_f_WorldY)
    ; Invert Y axis for correct display (GW coordinates vs screen coordinates)
    Return $g_i_Height - (($a_f_WorldY - $g_f_MapMinY) * $g_f_Zoom + $g_f_OffsetY)
EndFunc

Func ScreenToWorldX($a_i_ScreenX)
    Return ($a_i_ScreenX - $g_f_OffsetX) / $g_f_Zoom + $g_f_MapMinX
EndFunc

Func ScreenToWorldY($a_i_ScreenY)
    ; Invert Y axis for correct conversion back to world coordinates
    Return (($g_i_Height - $a_i_ScreenY) - $g_f_OffsetY) / $g_f_Zoom + $g_f_MapMinY
EndFunc

; Pathfinding functions
Func TogglePathfindingMode()
    $g_b_PathfindingMode = Not $g_b_PathfindingMode
    ClearPath()
    WinSetTitle($g_h_GUI, "", "GW Map Visualizer - " & StringRegExpReplace($g_s_CurrentFile, "^.*\\", "") & " - Pathfinding: " & ($g_b_PathfindingMode ? "ON" : "OFF"))
    DrawMap()
EndFunc

Func ClearPath()
    $g_f_StartClickX = -1
    $g_f_StartClickY = -1
    $g_f_EndClickX = -1
    $g_f_EndClickY = -1
    ReDim $g_af2_CalculatedPath[0][3]
    $g_b_ShowPath = False
    DrawMap()
EndFunc

Func SetAggressiveness($a_f_Value)
    $g_f_PathAggressiveness = $a_f_Value
    ; Recalculate path if both points are set
    If $g_f_StartClickX <> -1 And $g_f_EndClickX <> -1 Then
        CalculateAndShowPath()
    EndIf
EndFunc

Func CheckAggressivenessMenu($a_h_Checked, $a_h_Item1, $a_h_Item2, $a_h_Item3, $a_h_Item4)
    GUICtrlSetState($a_h_Checked, $GUI_CHECKED)
    GUICtrlSetState($a_h_Item1, $GUI_UNCHECKED)
    GUICtrlSetState($a_h_Item2, $GUI_UNCHECKED)
    GUICtrlSetState($a_h_Item3, $GUI_UNCHECKED)
    GUICtrlSetState($a_h_Item4, $GUI_UNCHECKED)
EndFunc

Func CalculateAndShowPath()
    If $g_f_StartClickX = -1 Or $g_f_EndClickX = -1 Then Return
    If $g_s_CurrentFile = "" Then
        MsgBox(16, "Error", "Please load a map file first")
        Return
    EndIf

    ConsoleWrite("========================================" & @CRLF)
    ConsoleWrite("Calculating path..." & @CRLF)
    ConsoleWrite("From: " & Round($g_f_StartClickX) & ", " & Round($g_f_StartClickY) & @CRLF)
    ConsoleWrite("To: " & Round($g_f_EndClickX) & ", " & Round($g_f_EndClickY) & @CRLF)
    ConsoleWrite("Aggressiveness: " & Round($g_f_PathAggressiveness * 100) & "%" & @CRLF)

    ; Calculate path using the pathfinding function
    Local $l_ab_BlockedLayers[256]
    For $i = 0 To 255
        $l_ab_BlockedLayers[$i] = False
    Next

    ; Calculate raw path
    Local $l_af2_RawPath = Pathfinding_CalculatePath($g_f_StartClickX, $g_f_StartClickY, 0, $g_f_EndClickX, $g_f_EndClickY, 0, $l_ab_BlockedLayers)

    If UBound($l_af2_RawPath) > 0 Then
        ; Optimize the path
        $g_af2_CalculatedPath = Pathfinding_OptimizePath($l_af2_RawPath, $g_f_PathAggressiveness)
        $g_b_ShowPath = True

        ConsoleWrite("Path found!" & @CRLF)
        ConsoleWrite("Raw waypoints: " & UBound($l_af2_RawPath) & @CRLF)
        ConsoleWrite("Optimized waypoints: " & UBound($g_af2_CalculatedPath) & @CRLF)

        ; Calculate total distance
        Local $l_f_TotalDist = 0
        For $i = 1 To UBound($g_af2_CalculatedPath) - 1
            $l_f_TotalDist += Sqrt(($g_af2_CalculatedPath[$i][0] - $g_af2_CalculatedPath[$i-1][0])^2 + _
                               ($g_af2_CalculatedPath[$i][1] - $g_af2_CalculatedPath[$i-1][1])^2)
        Next
        ConsoleWrite("Total distance: " & Round($l_f_TotalDist) & @CRLF)
    Else
        ConsoleWrite("No path found!" & @CRLF)
        MsgBox(48, "Pathfinding", "No path could be found between these points")
        $g_b_ShowPath = False
    EndIf

    ConsoleWrite("========================================" & @CRLF)

    ; Reset click points for next path
    $g_f_StartClickX = -1
    $g_f_StartClickY = -1
    $g_f_EndClickX = -1
    $g_f_EndClickY = -1

    DrawMap()
EndFunc

; View control functions
Func ResetView()
    $g_f_Zoom = 1.0
    $g_f_OffsetX = 0
    $g_f_OffsetY = 0
    DrawMap()
EndFunc

Func ZoomIn()
    Local $l_f_OldZoom = $g_f_Zoom
    $g_f_Zoom *= 1.2
    If $g_f_Zoom > 50 Then $g_f_Zoom = 50

    ; Zoom to center
    Local $l_f_CenterX = $g_i_Width / 2
    Local $l_f_CenterY = $g_i_Height / 2
    Local $l_f_ZoomRatio = $g_f_Zoom / $l_f_OldZoom
    $g_f_OffsetX = $l_f_CenterX - ($l_f_CenterX - $g_f_OffsetX) * $l_f_ZoomRatio
    $g_f_OffsetY = $l_f_CenterY - ($l_f_CenterY - $g_f_OffsetY) * $l_f_ZoomRatio

    DrawMap()
EndFunc

Func ZoomOut()
    Local $l_f_OldZoom = $g_f_Zoom
    $g_f_Zoom /= 1.2
    If $g_f_Zoom < 0.01 Then $g_f_Zoom = 0.01

    ; Zoom to center
    Local $l_f_CenterX = $g_i_Width / 2
    Local $l_f_CenterY = $g_i_Height / 2
    Local $l_f_ZoomRatio = $g_f_Zoom / $l_f_OldZoom
    $g_f_OffsetX = $l_f_CenterX - ($l_f_CenterX - $g_f_OffsetX) * $l_f_ZoomRatio
    $g_f_OffsetY = $l_f_CenterY - ($l_f_CenterY - $g_f_OffsetY) * $l_f_ZoomRatio

    DrawMap()
EndFunc

Func FitToWindow()
    ; Calculate actual map bounds from loaded data
    Local $l_f_ActualMinX = 999999, $l_f_ActualMinY = 999999
    Local $l_f_ActualMaxX = -999999, $l_f_ActualMaxY = -999999
    Local $l_b_HasData = False

    ; Check trapezoids bounds
    For $i = 0 To UBound($g_amx2_Trapezoids) - 1
        $l_b_HasData = True
        For $j = 0 To 3
            Local $l_f_X = $g_amx2_Trapezoids[$i][2 + $j * 2]
            Local $l_f_Y = $g_amx2_Trapezoids[$i][3 + $j * 2]
            If $l_f_X < $l_f_ActualMinX Then $l_f_ActualMinX = $l_f_X
            If $l_f_X > $l_f_ActualMaxX Then $l_f_ActualMaxX = $l_f_X
            If $l_f_Y < $l_f_ActualMinY Then $l_f_ActualMinY = $l_f_Y
            If $l_f_Y > $l_f_ActualMaxY Then $l_f_ActualMaxY = $l_f_Y
        Next
    Next

    ; If we have actual data, use those bounds
    If $l_b_HasData Then
        ; Add some padding (5%)
        Local $l_f_PaddingX = ($l_f_ActualMaxX - $l_f_ActualMinX) * 0.05
        Local $l_f_PaddingY = ($l_f_ActualMaxY - $l_f_ActualMinY) * 0.05
        $g_f_MapMinX = $l_f_ActualMinX - $l_f_PaddingX
        $g_f_MapMaxX = $l_f_ActualMaxX + $l_f_PaddingX
        $g_f_MapMinY = $l_f_ActualMinY - $l_f_PaddingY
        $g_f_MapMaxY = $l_f_ActualMaxY + $l_f_PaddingY
    EndIf

    Local $l_f_MapWidth = $g_f_MapMaxX - $g_f_MapMinX
    Local $l_f_MapHeight = $g_f_MapMaxY - $g_f_MapMinY

    If $l_f_MapWidth = 0 Or $l_f_MapHeight = 0 Then
        $g_f_Zoom = 1.0
        $g_f_OffsetX = $g_i_Width / 2
        $g_f_OffsetY = $g_i_Height / 2
    Else
        ; Calculate zoom to fit with padding
        Local $l_f_Padding = 40
        Local $l_f_ZoomX = ($g_i_Width - $l_f_Padding) / $l_f_MapWidth
        Local $l_f_ZoomY = ($g_i_Height - $l_f_Padding) / $l_f_MapHeight
        $g_f_Zoom = _Min($l_f_ZoomX, $l_f_ZoomY)

        ; Center the map
        Local $l_f_MapCenterX = ($g_f_MapMinX + $g_f_MapMaxX) / 2
        Local $l_f_MapCenterY = ($g_f_MapMinY + $g_f_MapMaxY) / 2

        $g_f_OffsetX = ($g_i_Width / 2) - ($l_f_MapCenterX - $g_f_MapMinX) * $g_f_Zoom
        $g_f_OffsetY = ($g_i_Height / 2) - ($l_f_MapCenterY - $g_f_MapMinY) * $g_f_Zoom
    EndIf

    DrawMap()
EndFunc

; Toggle functions
Func ToggleTrapezoids()
    $g_b_ShowTrapezoids = Not $g_b_ShowTrapezoids
    DrawMap()
EndFunc

Func TogglePoints()
    $g_b_ShowPoints = Not $g_b_ShowPoints
    DrawMap()
EndFunc

Func ToggleTeleports()
    $g_b_ShowTeleports = Not $g_b_ShowTeleports
    DrawMap()
EndFunc

Func ToggleGrid()
    $g_b_ShowGrid = Not $g_b_ShowGrid
    DrawMap()
EndFunc

Func HotkeyOpen()
    LoadMapFile()
EndFunc

Func ATan2($a_f_Y, $a_f_X)
    Return ATan($a_f_Y / $a_f_X) + ($a_f_X < 0 ? ($a_f_Y >= 0 ? 3.14159265359 : -3.14159265359) : 0)
EndFunc

; Mouse wheel handler
Func WM_MOUSEWHEEL($a_h_Wnd, $a_i_Msg, $a_w_Param, $a_l_Param)
    If $a_h_Wnd <> $g_h_GUI Then Return $GUI_RUNDEFMSG

    Local $l_ai_MousePos = GUIGetCursorInfo($g_h_GUI)
    If Not IsArray($l_ai_MousePos) Then Return $GUI_RUNDEFMSG

    ; Get wheel delta
    Local $l_i_Delta = BitShift($a_w_Param, 16)
    If $l_i_Delta > 32768 Then $l_i_Delta = $l_i_Delta - 65536

    Local $l_f_OldZoom = $g_f_Zoom

    ; Zoom in or out based on wheel direction
    If $l_i_Delta > 0 Then
        If _IsPressed("10") Then ; Shift for fine zoom
            $g_f_Zoom *= 1.05
        Else
            $g_f_Zoom *= 1.2
        EndIf
    Else
        If _IsPressed("10") Then ; Shift for fine zoom
            $g_f_Zoom /= 1.05
        Else
            $g_f_Zoom /= 1.2
        EndIf
    EndIf

    ; Limit zoom
    If $g_f_Zoom > 50 Then $g_f_Zoom = 50
    If $g_f_Zoom < 0.01 Then $g_f_Zoom = 0.01

    ; Zoom to mouse position
    Local $l_f_ZoomRatio = $g_f_Zoom / $l_f_OldZoom
    $g_f_OffsetX = $l_ai_MousePos[0] - ($l_ai_MousePos[0] - $g_f_OffsetX) * $l_f_ZoomRatio
    $g_f_OffsetY = $l_ai_MousePos[1] - ($l_ai_MousePos[1] - $g_f_OffsetY) * $l_f_ZoomRatio

    DrawMap()

    Return $GUI_RUNDEFMSG
EndFunc