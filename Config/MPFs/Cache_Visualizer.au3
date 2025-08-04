#RequireAdmin
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GDIPlus.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <GuiRichEdit.au3>
#include <EditConstants.au3>
#include <Misc.au3>
#include <Date.au3>
#include <Math.au3>

; ===============================================================
; MPF Visualizer - Standalone viewer for .mpf PathFinding cache files
; ===============================================================

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", False)

; Constants from the cache system
Global Const $MPF_MAGIC = 0x4D504631      ; "MPF1"
Global Const $MPF_VERSION = 0x0101        ; Version 1.1

; Section type identifiers
Global Enum $MPF_SECTION_TRAPEZOIDS = 0x54524150, _  ; "TRAP"
            $MPF_SECTION_AABBS = 0x41414242, _        ; "AABB"
            $MPF_SECTION_PORTALS = 0x504F5254, _      ; "PORT"
            $MPF_SECTION_POINTS = 0x504F494E, _       ; "POIN"
            $MPF_SECTION_TELEPORTS = 0x54454C45, _    ; "TELE"
            $MPF_SECTION_AABB_GRAPH = 0x41474248, _   ; "AGBH"
            $MPF_SECTION_PT_GRAPH = 0x50544752, _     ; "PTGR"
            $MPF_SECTION_VIS_GRAPH = 0x56495347, _    ; "VISG"
            $MPF_SECTION_TELE_GRAPH = 0x54474248      ; "TGBH"

; Global data arrays (same structure as PathFinding)
Global $g_a_PathingTrapezoids[1]
Global $g_a_PathingAABBs[1]
Global $g_a_PathingPortals[1]
Global $g_a_PathingPoints[1]
Global $g_a_PathingTeleports[1]
Global $g_a_PathingAABBGraph[1]
Global $g_a_PathingPTPortalGraph[1]
Global $g_a_PathingVisGraph[1]
Global $g_a_TeleportGraph[1]
Global $g_b_UseVisibilityGraph = True

; Visualization globals
Global $g_h_VisualizerGUI = 0
Global $g_h_VisualizerGraphic = 0
Global $g_h_VisualizerBitmap = 0
Global $g_h_VisualizerBuffer = 0
Global $g_f_VisualizerScale = 0.1
Global $g_f_VisualizerOffsetX = 400
Global $g_f_VisualizerOffsetY = 300
Global $g_i_VisualizerWidth = 855
Global $g_i_VisualizerHeight = 635
Global $g_b_VisualizerInitialized = False

; Visualization options
Global $g_b_ShowTrapezoids = True
Global $g_b_ShowAABBs = False
Global $g_b_ShowPortals = False
Global $g_b_ShowConnections = True
Global $g_b_ShowPoints = False
Global $g_b_ShowTeleports = True
Global $g_b_ShowLabels = False
Global $g_b_WireframeMode = True
Global $g_b_UseGradientColors = True

; Map bounds
Global $g_f_MapMinX = 0
Global $g_f_MapMaxX = 0
Global $g_f_MapMinY = 0
Global $g_f_MapMaxY = 0
Global $g_f_MapWidth = 0
Global $g_f_MapHeight = 0
Global $g_f_MapCenterX = 0
Global $g_f_MapCenterY = 0
Global $g_i_MaxPlane = 1

; Current file info
Global $g_s_CurrentFile = ""
Global $g_i_CurrentMapID = 0

; GUI Controls
Global $g_h_GUI
Global $g_h_FileInput
Global $g_h_BrowseButton
Global $g_h_LoadButton
Global $g_h_EditLog
Global $g_h_VisualizerLabel
Global $g_h_StatusLabel
Global $g_h_InfoLabel

; Toggle controls
Global $g_h_CheckTrapezoids
Global $g_h_CheckAABBs
Global $g_h_CheckPortals
Global $g_h_CheckConnections
Global $g_h_CheckPoints
Global $g_h_CheckTeleports
Global $g_h_CheckLabels
Global $g_h_CheckWireframe
Global $g_h_CheckGradient

; Mouse interaction
Global $g_b_MouseDown = False
Global $g_i_MouseStartX = 0
Global $g_i_MouseStartY = 0
Global $g_f_DragStartOffsetX = 0
Global $g_f_DragStartOffsetY = 0

; ===============================================================
; Main GUI Creation
; ===============================================================

$g_h_GUI = GUICreate("MPF Visualizer - PathFinding Map Viewer", 1200, 700, -1, -1)
GUISetBkColor(0xEAEAEA, $g_h_GUI)

; Left panel for controls
$Group1 = GUICtrlCreateGroup("File Selection", 8, 8, 320, 100)

GUICtrlCreateLabel("MPF File:", 24, 32, 60, 20)
$g_h_FileInput = GUICtrlCreateInput("", 90, 30, 170, 22)
$g_h_BrowseButton = GUICtrlCreateButton("...", 265, 29, 30, 24)
GUICtrlSetOnEvent($g_h_BrowseButton, "OnBrowse")

$g_h_LoadButton = GUICtrlCreateButton("Load File", 24, 65, 271, 30)
GUICtrlSetOnEvent($g_h_LoadButton, "OnLoadFile")
GUICtrlSetFont($g_h_LoadButton, 10, 600)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Visualization controls
$Group2 = GUICtrlCreateGroup("Display Options", 8, 115, 320, 180)

$g_h_CheckTrapezoids = GUICtrlCreateCheckbox("Trapezoids", 24, 140, 80, 20)
GUICtrlSetState($g_h_CheckTrapezoids, $GUI_CHECKED)
GUICtrlSetOnEvent($g_h_CheckTrapezoids, "OnToggleOption")

$g_h_CheckAABBs = GUICtrlCreateCheckbox("AABBs", 110, 140, 80, 20)
GUICtrlSetOnEvent($g_h_CheckAABBs, "OnToggleOption")

$g_h_CheckPortals = GUICtrlCreateCheckbox("Portals", 190, 140, 80, 20)
GUICtrlSetOnEvent($g_h_CheckPortals, "OnToggleOption")

$g_h_CheckConnections = GUICtrlCreateCheckbox("Connections", 24, 165, 85, 20)
GUICtrlSetState($g_h_CheckConnections, $GUI_CHECKED)
GUICtrlSetOnEvent($g_h_CheckConnections, "OnToggleOption")

$g_h_CheckPoints = GUICtrlCreateCheckbox("Points", 115, 165, 80, 20)
GUICtrlSetOnEvent($g_h_CheckPoints, "OnToggleOption")

$g_h_CheckTeleports = GUICtrlCreateCheckbox("Teleports", 195, 165, 80, 20)
GUICtrlSetState($g_h_CheckTeleports, $GUI_CHECKED)
GUICtrlSetOnEvent($g_h_CheckTeleports, "OnToggleOption")

$g_h_CheckLabels = GUICtrlCreateCheckbox("Labels", 24, 190, 80, 20)
GUICtrlSetOnEvent($g_h_CheckLabels, "OnToggleOption")

$g_h_CheckWireframe = GUICtrlCreateCheckbox("Wireframe", 110, 190, 80, 20)
GUICtrlSetState($g_h_CheckWireframe, $GUI_CHECKED)
GUICtrlSetOnEvent($g_h_CheckWireframe, "OnToggleOption")

$g_h_CheckGradient = GUICtrlCreateCheckbox("Gradient", 195, 190, 80, 20)
GUICtrlSetState($g_h_CheckGradient, $GUI_CHECKED)
GUICtrlSetOnEvent($g_h_CheckGradient, "OnToggleOption")

; Zoom controls
GUICtrlCreateLabel("Controls:", 24, 220, 60, 20)
$g_h_ZoomInButton = GUICtrlCreateButton("Zoom +", 24, 240, 60, 25)
GUICtrlSetOnEvent($g_h_ZoomInButton, "OnZoomIn")

$g_h_ZoomOutButton = GUICtrlCreateButton("Zoom -", 90, 240, 60, 25)
GUICtrlSetOnEvent($g_h_ZoomOutButton, "OnZoomOut")

$g_h_ResetViewButton = GUICtrlCreateButton("Reset View", 156, 240, 70, 25)
GUICtrlSetOnEvent($g_h_ResetViewButton, "OnResetView")

$g_h_ExportButton = GUICtrlCreateButton("Export PNG", 232, 240, 70, 25)
GUICtrlSetOnEvent($g_h_ExportButton, "OnExportImage")

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Info panel
$Group3 = GUICtrlCreateGroup("File Information", 8, 300, 320, 120)
$g_h_InfoLabel = GUICtrlCreateLabel("No file loaded", 24, 320, 290, 90, $SS_LEFT)
GUICtrlSetFont($g_h_InfoLabel, 9)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Console/Log
GUICtrlCreateLabel("Log:", 8, 425, 50, 20)
$g_h_EditLog = _GUICtrlRichEdit_Create($g_h_GUI, "", 8, 445, 320, 245, _
    BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
_GUICtrlRichEdit_SetBkColor($g_h_EditLog, 0xFFFFFF)

; Right panel for visualizer
$Group4 = GUICtrlCreateGroup("Map Visualization", 335, 8, 855, 680)

; Status bar
$g_h_StatusLabel = GUICtrlCreateLabel("Drag to pan | Scroll to zoom | Double-click to reset view", 345, 665, 835, 15)
GUICtrlSetColor($g_h_StatusLabel, 0x666666)

; Create label for visualizer
$g_h_VisualizerLabel = GUICtrlCreateLabel("", 340, 28, 845, 635)
GUICtrlSetBkColor($g_h_VisualizerLabel, 0x1A1A1A)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Set GUI events
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "OnMouseDown")
GUISetOnEvent($GUI_EVENT_PRIMARYUP, "OnMouseUp")
GUISetOnEvent($GUI_EVENT_MOUSEMOVE, "OnMouseMove")
GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "OnRightClick")

; Register mouse wheel
GUIRegisterMsg($WM_MOUSEWHEEL, "OnMouseWheel")

; Show GUI
GUISetState(@SW_SHOW)

; Initialize visualizer
_GDIPlus_Startup()
InitializeVisualizer()

Log("MPF Visualizer started")
Log("Select an .mpf file to begin")

; Main loop
While 1
    Sleep(10)
WEnd

; ===============================================================
; Event Handlers
; ===============================================================

Func OnBrowse()
    Local $s_File = FileOpenDialog("Select MPF File", @ScriptDir, "MPF Files (*.mpf)|All Files (*.*)", 1)
    If Not @error And $s_File <> "" Then
        GUICtrlSetData($g_h_FileInput, $s_File)
    EndIf
EndFunc

Func OnLoadFile()
    Local $s_File = GUICtrlRead($g_h_FileInput)
    If $s_File = "" Then
        MsgBox(48, "Error", "Please select a file first!")
        Return
    EndIf

    If Not FileExists($s_File) Then
        MsgBox(48, "Error", "File not found: " & @CRLF & $s_File)
        Return
    EndIf

    LoadMPFFile($s_File)
EndFunc

Func OnToggleOption()
    ; Update visualization options based on checkboxes
    $g_b_ShowTrapezoids = (BitAND(GUICtrlRead($g_h_CheckTrapezoids), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_ShowAABBs = (BitAND(GUICtrlRead($g_h_CheckAABBs), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_ShowPortals = (BitAND(GUICtrlRead($g_h_CheckPortals), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_ShowConnections = (BitAND(GUICtrlRead($g_h_CheckConnections), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_ShowPoints = (BitAND(GUICtrlRead($g_h_CheckPoints), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_ShowTeleports = (BitAND(GUICtrlRead($g_h_CheckTeleports), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_ShowLabels = (BitAND(GUICtrlRead($g_h_CheckLabels), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_WireframeMode = (BitAND(GUICtrlRead($g_h_CheckWireframe), $GUI_CHECKED) = $GUI_CHECKED)
    $g_b_UseGradientColors = (BitAND(GUICtrlRead($g_h_CheckGradient), $GUI_CHECKED) = $GUI_CHECKED)

    UpdateVisualization()
EndFunc

Func OnZoomIn()
    Local $l_f_CenterX = ScreenToWorldX($g_i_VisualizerWidth / 2)
    Local $l_f_CenterY = ScreenToWorldY($g_i_VisualizerHeight / 2)

    $g_f_VisualizerScale *= 1.5
    If $g_f_VisualizerScale > 10 Then $g_f_VisualizerScale = 10

    $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $l_f_CenterX * $g_f_VisualizerScale
    $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $l_f_CenterY * $g_f_VisualizerScale

    UpdateVisualization()
EndFunc

Func OnZoomOut()
    Local $l_f_CenterX = ScreenToWorldX($g_i_VisualizerWidth / 2)
    Local $l_f_CenterY = ScreenToWorldY($g_i_VisualizerHeight / 2)

    $g_f_VisualizerScale /= 1.5
    If $g_f_VisualizerScale < 0.001 Then $g_f_VisualizerScale = 0.001

    $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $l_f_CenterX * $g_f_VisualizerScale
    $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $l_f_CenterY * $g_f_VisualizerScale

    UpdateVisualization()
EndFunc

Func OnResetView()
    If $g_f_MapWidth > 0 Then
        ; Calculate scale to fit the map
        Local $l_f_ScaleX = $g_i_VisualizerWidth / ($g_f_MapWidth * 1.1)
        Local $l_f_ScaleY = $g_i_VisualizerHeight / ($g_f_MapHeight * 1.1)
        $g_f_VisualizerScale = _Min($l_f_ScaleX, $l_f_ScaleY)

        ; Center the map
        $g_f_VisualizerOffsetX = $g_i_VisualizerWidth / 2 - $g_f_MapCenterX * $g_f_VisualizerScale
        $g_f_VisualizerOffsetY = $g_i_VisualizerHeight / 2 - $g_f_MapCenterY * $g_f_VisualizerScale

        UpdateVisualization()
    EndIf
EndFunc

Func OnExportImage()
    If $g_s_CurrentFile = "" Then
        MsgBox(48, "Error", "No map loaded to export!")
        Return
    EndIf

    ; Create filename based on loaded file
    Local $s_BaseName = StringTrimRight(StringRegExpReplace($g_s_CurrentFile, "^.*\\", ""), 4)
    Local $s_SaveFile = FileSaveDialog("Save Map Image", @ScriptDir, "PNG Image (*.png)", 16, $s_BaseName & ".png")

    If Not @error And $s_SaveFile <> "" Then
        ; Ensure .png extension
        If StringRight($s_SaveFile, 4) <> ".png" Then $s_SaveFile &= ".png"

        ; Save current bitmap
        _GDIPlus_ImageSaveToFile($g_h_VisualizerBitmap, $s_SaveFile)
        _Log("Exported map to: " & $s_SaveFile)
        MsgBox(64, "Success", "Map exported successfully!")
    EndIf
EndFunc

Func OnMouseDown()
    Local $a_MouseInfo = GUIGetCursorInfo($g_h_GUI)
    If IsArray($a_MouseInfo) And $a_MouseInfo[4] = $g_h_VisualizerLabel Then
        $g_b_MouseDown = True
        $g_i_MouseStartX = $a_MouseInfo[0]
        $g_i_MouseStartY = $a_MouseInfo[1]
        $g_f_DragStartOffsetX = $g_f_VisualizerOffsetX
        $g_f_DragStartOffsetY = $g_f_VisualizerOffsetY
    EndIf
EndFunc

Func OnMouseUp()
    $g_b_MouseDown = False
EndFunc

Func OnMouseMove()
    If $g_b_MouseDown Then
        Local $a_MouseInfo = GUIGetCursorInfo($g_h_GUI)
        If IsArray($a_MouseInfo) Then
            Local $l_i_DeltaX = $a_MouseInfo[0] - $g_i_MouseStartX
            Local $l_i_DeltaY = $a_MouseInfo[1] - $g_i_MouseStartY

            $g_f_VisualizerOffsetX = $g_f_DragStartOffsetX + $l_i_DeltaX
            $g_f_VisualizerOffsetY = $g_f_DragStartOffsetY - $l_i_DeltaY

            UpdateVisualization()
        EndIf
    EndIf
EndFunc

Func OnRightClick()
    ; Could implement context menu or other functionality
EndFunc

Func OnMouseWheel($hWnd, $iMsg, $wParam, $lParam)
    Local $a_MouseInfo = GUIGetCursorInfo($g_h_GUI)
    If Not IsArray($a_MouseInfo) Then Return $GUI_RUNDEFMSG

    ; Check if mouse is over visualizer
    If $a_MouseInfo[4] = $g_h_VisualizerLabel Then
        Local $l_i_RelX = $a_MouseInfo[0] - 340
        Local $l_i_RelY = $a_MouseInfo[1] - 28

        Local $l_f_WorldX = ScreenToWorldX($l_i_RelX)
        Local $l_f_WorldY = ScreenToWorldY($l_i_RelY)

        Local $l_i_Delta = BitShift($wParam, 16) / 120

        If $l_i_Delta > 0 Then
            $g_f_VisualizerScale *= 1.2
            If $g_f_VisualizerScale > 10 Then $g_f_VisualizerScale = 10
        Else
            $g_f_VisualizerScale /= 1.2
            If $g_f_VisualizerScale < 0.001 Then $g_f_VisualizerScale = 0.001
        EndIf

        $g_f_VisualizerOffsetX = $l_i_RelX - $l_f_WorldX * $g_f_VisualizerScale
        $g_f_VisualizerOffsetY = $g_i_VisualizerHeight - $l_i_RelY - $l_f_WorldY * $g_f_VisualizerScale

        UpdateVisualization()
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc

; ===============================================================
; MPF Loading Functions
; ===============================================================

Func LoadMPFFile($s_File)
    _Log("Loading file: " & $s_File)

    ; Clear existing data
    ClearData()

    ; Open file
    Local $h_File = FileOpen($s_File, 16) ; Binary read
    If $h_File = -1 Then
        _Log("Failed to open file", 0xFF0000)
        Return False
    EndIf

    ; Read header
    If Not ReadHeader($h_File) Then
        FileClose($h_File)
        Return False
    EndIf

    ; Read section count
    Local $i_SectionCount = ReadDword($h_File)
    _Log("Reading " & $i_SectionCount & " sections...")

    ; Read all sections
    For $i = 1 To $i_SectionCount
        If Not ReadSection($h_File) Then
            _Log("Failed to read section " & $i, 0xFF0000)
            FileClose($h_File)
            Return False
        EndIf
    Next

    FileClose($h_File)

    $g_s_CurrentFile = $s_File

    ; Update info display
    UpdateFileInfo()

    ; Calculate bounds and display
    CalculateBounds()
    OnResetView() ; Auto-fit the map

    _Log("File loaded successfully!", 0x008000)
    Return True
EndFunc

Func ReadHeader($h_File)
    Local $b_Header = FileRead($h_File, 20)
    Local $t_Header = DllStructCreate("dword magic; dword version; dword mapid; dword timestamp; byte usevisgraph; byte reserved[3]")
    DllStructSetData(DllStructCreate("byte[20]", DllStructGetPtr($t_Header)), 1, $b_Header)

    ; Verify magic
    Local $i_Magic = DllStructGetData($t_Header, "magic")
    If $i_Magic <> $MPF_MAGIC Then
        _Log("Invalid file format (bad magic: " & Hex($i_Magic, 8) & ")", 0xFF0000)
        Return False
    EndIf

    ; Get info
    Local $i_Version = DllStructGetData($t_Header, "version")
    $g_i_CurrentMapID = DllStructGetData($t_Header, "mapid")
    Local $i_Timestamp = DllStructGetData($t_Header, "timestamp")
    $g_b_UseVisibilityGraph = (DllStructGetData($t_Header, "usevisgraph") = 1)

    _Log("File version: " & Hex($i_Version, 4))
    _Log("Map ID: " & $g_i_CurrentMapID)
    _Log("Created: " & _DateTimeFormat(_DateAdd('s', $i_Timestamp, "1970/01/01 00:00:00"), 0))

    Return True
EndFunc

Func ReadSection($h_File)
    Local $i_Type = ReadDword($h_File)
    Local $i_Count = ReadDword($h_File)
    Local $i_Size = ReadDword($h_File)

    Switch $i_Type
        Case $MPF_SECTION_TRAPEZOIDS
            _Log("Reading " & $i_Count & " trapezoids...")
            Return ReadTrapezoids($h_File, $i_Count)

        Case $MPF_SECTION_AABBS
            _Log("Reading " & $i_Count & " AABBs...")
            Return ReadAABBs($h_File, $i_Count)

        Case $MPF_SECTION_PORTALS
            _Log("Reading " & $i_Count & " portals...")
            Return ReadPortals($h_File, $i_Count)

        Case $MPF_SECTION_POINTS
            _Log("Reading " & $i_Count & " points...")
            Return ReadPoints($h_File, $i_Count)

        Case $MPF_SECTION_TELEPORTS
            _Log("Reading " & $i_Count & " teleports...")
            Return ReadTeleports($h_File, $i_Count)

        Case $MPF_SECTION_AABB_GRAPH
            _Log("Reading AABB graph (" & $i_Count & " entries)...")
            Return ReadAABBGraph($h_File, $i_Count)

        Case $MPF_SECTION_PT_GRAPH
            _Log("Reading PT graph (" & $i_Count & " entries)...")
            Return ReadPTGraph($h_File, $i_Count)

        Case $MPF_SECTION_VIS_GRAPH
            _Log("Reading visibility graph (" & $i_Count & " entries)...")
            Return ReadVisGraph($h_File, $i_Count)

        Case $MPF_SECTION_TELE_GRAPH
            _Log("Reading teleport graph (" & $i_Count & " entries)...")
            Return ReadTeleGraph($h_File, $i_Count)

        Case Else
            _Log("Unknown section type: " & Hex($i_Type, 8) & ", skipping", 0xFF8800)
            FileRead($h_File, $i_Size)
            Return True
    EndSwitch
EndFunc

Func ReadTrapezoids($h_File, $i_Count)
    ReDim $g_a_PathingTrapezoids[$i_Count + 1]
    $g_a_PathingTrapezoids[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 44)
        Local $t_Trap = DllStructCreate("int id; int layer; float coords[8]")
        DllStructSetData(DllStructCreate("byte[44]", DllStructGetPtr($t_Trap)), 1, $b_Data)

        Local $l_a_Trap[10]
        $l_a_Trap[0] = DllStructGetData($t_Trap, "id")
        $l_a_Trap[1] = DllStructGetData($t_Trap, "layer")
        For $j = 0 To 7
            $l_a_Trap[$j + 2] = DllStructGetData($t_Trap, "coords", $j + 1)
        Next

        $g_a_PathingTrapezoids[$i] = $l_a_Trap
    Next

    Return True
EndFunc

Func ReadAABBs($h_File, $i_Count)
    ReDim $g_a_PathingAABBs[$i_Count + 1]
    $g_a_PathingAABBs[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 24)
        Local $t_AABB = DllStructCreate("int id; float posx; float posy; float halfx; float halfy; int trapindex")
        DllStructSetData(DllStructCreate("byte[24]", DllStructGetPtr($t_AABB)), 1, $b_Data)

        Local $l_a_AABB[6]
        $l_a_AABB[0] = DllStructGetData($t_AABB, "id")
        $l_a_AABB[1] = DllStructGetData($t_AABB, "posx")
        $l_a_AABB[2] = DllStructGetData($t_AABB, "posy")
        $l_a_AABB[3] = DllStructGetData($t_AABB, "halfx")
        $l_a_AABB[4] = DllStructGetData($t_AABB, "halfy")
        $l_a_AABB[5] = DllStructGetData($t_AABB, "trapindex")

        $g_a_PathingAABBs[$i] = $l_a_AABB
    Next

    Return True
EndFunc

Func ReadPortals($h_File, $i_Count)
    ReDim $g_a_PathingPortals[$i_Count + 1]
    $g_a_PathingPortals[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 24)
        Local $t_Portal = DllStructCreate("float startx; float starty; float goalx; float goaly; int box1; int box2")
        DllStructSetData(DllStructCreate("byte[24]", DllStructGetPtr($t_Portal)), 1, $b_Data)

        Local $l_a_Portal[6]
        $l_a_Portal[0] = DllStructGetData($t_Portal, "startx")
        $l_a_Portal[1] = DllStructGetData($t_Portal, "starty")
        $l_a_Portal[2] = DllStructGetData($t_Portal, "goalx")
        $l_a_Portal[3] = DllStructGetData($t_Portal, "goaly")
        $l_a_Portal[4] = DllStructGetData($t_Portal, "box1")
        $l_a_Portal[5] = DllStructGetData($t_Portal, "box2")

        $g_a_PathingPortals[$i] = $l_a_Portal
    Next

    Return True
EndFunc

Func ReadPoints($h_File, $i_Count)
    ReDim $g_a_PathingPoints[$i_Count + 1]
    $g_a_PathingPoints[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 24)
        Local $t_Point = DllStructCreate("int id; float posx; float posy; int boxid; int box2id; int portalid")
        DllStructSetData(DllStructCreate("byte[24]", DllStructGetPtr($t_Point)), 1, $b_Data)

        Local $l_a_Point[6]
        $l_a_Point[0] = DllStructGetData($t_Point, "id")
        $l_a_Point[1] = DllStructGetData($t_Point, "posx")
        $l_a_Point[2] = DllStructGetData($t_Point, "posy")
        $l_a_Point[3] = DllStructGetData($t_Point, "boxid")
        $l_a_Point[4] = DllStructGetData($t_Point, "box2id")
        $l_a_Point[5] = DllStructGetData($t_Point, "portalid")

        $g_a_PathingPoints[$i] = $l_a_Point
    Next

    Return True
EndFunc

Func ReadTeleports($h_File, $i_Count)
    ReDim $g_a_PathingTeleports[$i_Count + 1]
    $g_a_PathingTeleports[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 28)
        Local $t_Teleport = DllStructCreate("float enterx; float entery; int enterz; float exitx; float exity; int exitz; byte bothways; byte reserved[3]")
        DllStructSetData(DllStructCreate("byte[28]", DllStructGetPtr($t_Teleport)), 1, $b_Data)

        Local $l_a_Teleport[7]
        $l_a_Teleport[0] = DllStructGetData($t_Teleport, "enterx")
        $l_a_Teleport[1] = DllStructGetData($t_Teleport, "entery")
        $l_a_Teleport[2] = DllStructGetData($t_Teleport, "enterz")
        $l_a_Teleport[3] = DllStructGetData($t_Teleport, "exitx")
        $l_a_Teleport[4] = DllStructGetData($t_Teleport, "exity")
        $l_a_Teleport[5] = DllStructGetData($t_Teleport, "exitz")
        $l_a_Teleport[6] = (DllStructGetData($t_Teleport, "bothways") = 1)

        $g_a_PathingTeleports[$i] = $l_a_Teleport
    Next

    Return True
EndFunc

Func ReadAABBGraph($h_File, $i_Count)
    ReDim $g_a_PathingAABBGraph[$g_a_PathingAABBs[0] + 1]

    For $i = 1 To $i_Count
        Local $i_Index = ReadDword($h_File)
        Local $s_Data = ReadString($h_File)

        If $i_Index <= $g_a_PathingAABBs[0] Then
            $g_a_PathingAABBGraph[$i_Index] = $s_Data
        EndIf
    Next

    Return True
EndFunc

Func ReadPTGraph($h_File, $i_Count)
    ; Skip for visualization - not needed
    For $i = 1 To $i_Count
        ReadDword($h_File) ; Index
        ReadString($h_File) ; Data
    Next
    Return True
EndFunc

Func ReadVisGraph($h_File, $i_Count)
    ; Skip for visualization - not needed
    For $i = 1 To $i_Count
        ReadDword($h_File) ; Index
        ReadString($h_File) ; Data
    Next
    Return True
EndFunc

Func ReadTeleGraph($h_File, $i_Count)
    ReDim $g_a_TeleportGraph[$i_Count + 1]
    $g_a_TeleportGraph[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 12)
        Local $t_Node = DllStructCreate("int tp1; int tp2; float distance")
        DllStructSetData(DllStructCreate("byte[12]", DllStructGetPtr($t_Node)), 1, $b_Data)

        Local $l_a_Node[3]
        $l_a_Node[0] = DllStructGetData($t_Node, "tp1")
        $l_a_Node[1] = DllStructGetData($t_Node, "tp2")
        $l_a_Node[2] = DllStructGetData($t_Node, "distance")

        $g_a_TeleportGraph[$i] = $l_a_Node
    Next

    Return True
EndFunc

Func ReadDword($h_File)
    Local $b_Data = FileRead($h_File, 4)
    Local $t_Dword = DllStructCreate("dword value")
    DllStructSetData(DllStructCreate("byte[4]", DllStructGetPtr($t_Dword)), 1, $b_Data)
    Return DllStructGetData($t_Dword, "value")
EndFunc

Func ReadString($h_File)
    Local $i_Len = ReadDword($h_File)
    If $i_Len > 0 Then
        Return BinaryToString(FileRead($h_File, $i_Len))
    EndIf
    Return ""
EndFunc

; ===============================================================
; Visualization Functions
; ===============================================================

Func InitializeVisualizer()
    $g_h_VisualizerGraphic = _GDIPlus_GraphicsCreateFromHWND($g_h_GUI)

    Local $h_Region = _GDIPlus_RegionCreateFromRect(340, 28, $g_i_VisualizerWidth, $g_i_VisualizerHeight)
    _GDIPlus_GraphicsSetClipRegion($g_h_VisualizerGraphic, $h_Region)
    _GDIPlus_RegionDispose($h_Region)

    $g_h_VisualizerBitmap = _GDIPlus_BitmapCreateFromGraphics($g_i_VisualizerWidth, $g_i_VisualizerHeight, $g_h_VisualizerGraphic)
    $g_h_VisualizerBuffer = _GDIPlus_ImageGetGraphicsContext($g_h_VisualizerBitmap)

    _GDIPlus_GraphicsSetSmoothingMode($g_h_VisualizerBuffer, 2)

    $g_b_VisualizerInitialized = True

    UpdateVisualization()
EndFunc

Func UpdateVisualization()
    If Not $g_b_VisualizerInitialized Then Return

    ; Clear buffer
    _GDIPlus_GraphicsClear($g_h_VisualizerBuffer, 0xFF1A1A1A)

    ; Draw layers in order
    If $g_b_ShowTrapezoids Then DrawTrapezoids()
    If $g_b_ShowAABBs Then DrawAABBs()
    If $g_b_ShowConnections Then DrawConnections()
    If $g_b_ShowPortals Then DrawPortals()
    If $g_b_ShowPoints Then DrawPoints()
    If $g_b_ShowTeleports Then DrawTeleports()

    ; Draw legend and info
    DrawLegend()
    DrawInfo()

    ; Update display
    _GDIPlus_GraphicsDrawImageRect($g_h_VisualizerGraphic, $g_h_VisualizerBitmap, 340, 28, $g_i_VisualizerWidth, $g_i_VisualizerHeight)
EndFunc

Func DrawTrapezoids()
    If $g_a_PathingTrapezoids[0] = 0 Then Return

    For $i = 1 To $g_a_PathingTrapezoids[0]
        Local $l_a_Trap = $g_a_PathingTrapezoids[$i]
        If Not IsArray($l_a_Trap) Then ContinueLoop

        ; Calculate color
        Local $l_i_Color, $l_i_BorderColor

        If $g_b_UseGradientColors And $g_i_MaxPlane > 0 Then
            Local $l_f_ColorRatio = $l_a_Trap[1] / $g_i_MaxPlane
            Local $l_i_Red = Int(200 + (55 * $l_f_ColorRatio))
            Local $l_i_Green = Int(200 * (1 - $l_f_ColorRatio))
            Local $l_i_Blue = Int(200 * (1 - $l_f_ColorRatio))

            If $g_b_WireframeMode Then
                $l_i_Color = 0x40000000 + BitShift($l_i_Red, -16) + BitShift($l_i_Green, -8) + $l_i_Blue
            Else
                $l_i_Color = 0xFF000000 + BitShift($l_i_Red, -16) + BitShift($l_i_Green, -8) + $l_i_Blue
            EndIf
            $l_i_BorderColor = 0xFF000000 + BitShift($l_i_Red, -16) + BitShift($l_i_Green, -8) + $l_i_Blue
        Else
            If $g_b_WireframeMode Then
                $l_i_Color = 0x10C8C8C8
            Else
                $l_i_Color = 0xFFC8C8C8
            EndIf
            $l_i_BorderColor = 0xFF808080
        EndIf

        Local $l_h_Pen = _GDIPlus_PenCreate($l_i_BorderColor, 1)
        Local $l_h_Brush = _GDIPlus_BrushCreateSolid($l_i_Color)

        ; Convert trapezoid points to screen coordinates
        Local $l_a_Points[5][2]
        $l_a_Points[0][0] = 4
        $l_a_Points[1][0] = WorldToScreenX($l_a_Trap[2])
        $l_a_Points[1][1] = WorldToScreenY($l_a_Trap[3])
        $l_a_Points[2][0] = WorldToScreenX($l_a_Trap[8])
        $l_a_Points[2][1] = WorldToScreenY($l_a_Trap[9])
        $l_a_Points[3][0] = WorldToScreenX($l_a_Trap[6])
        $l_a_Points[3][1] = WorldToScreenY($l_a_Trap[7])
        $l_a_Points[4][0] = WorldToScreenX($l_a_Trap[4])
        $l_a_Points[4][1] = WorldToScreenY($l_a_Trap[5])

        If $g_b_WireframeMode Then
            _GDIPlus_GraphicsDrawPolygon($g_h_VisualizerBuffer, $l_a_Points, $l_h_Pen)
        Else
            _GDIPlus_GraphicsFillPolygon($g_h_VisualizerBuffer, $l_a_Points, $l_h_Brush)
            _GDIPlus_GraphicsDrawPolygon($g_h_VisualizerBuffer, $l_a_Points, $l_h_Pen)
        EndIf

        ; Draw ID if labels enabled
        If $g_b_ShowLabels And $g_f_VisualizerScale > 0.05 Then
            Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 8)
            Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFF000000)
            Local $l_h_Format = _GDIPlus_StringFormatCreate()

            Local $l_f_CenterX = ($l_a_Trap[2] + $l_a_Trap[4] + $l_a_Trap[6] + $l_a_Trap[8]) / 4
            Local $l_f_CenterY = ($l_a_Trap[3] + $l_a_Trap[5] + $l_a_Trap[7] + $l_a_Trap[9]) / 4
            Local $l_i_ScreenX = WorldToScreenX($l_f_CenterX)
            Local $l_i_ScreenY = WorldToScreenY($l_f_CenterY)

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

Func DrawAABBs()
    If $g_a_PathingAABBs[0] = 0 Then Return

    Local $l_h_Pen = _GDIPlus_PenCreate(0x8000FF00, 2)

    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_a_AABB = $g_a_PathingAABBs[$i]
        If Not IsArray($l_a_AABB) Then ContinueLoop

        Local $l_i_X = WorldToScreenX($l_a_AABB[1] - $l_a_AABB[3])
        Local $l_i_Y = WorldToScreenY($l_a_AABB[2] + $l_a_AABB[4])
        Local $l_i_Width = $l_a_AABB[3] * 2 * $g_f_VisualizerScale
        Local $l_i_Height = $l_a_AABB[4] * 2 * $g_f_VisualizerScale

        _GDIPlus_GraphicsDrawRect($g_h_VisualizerBuffer, $l_i_X, $l_i_Y, $l_i_Width, $l_i_Height, $l_h_Pen)
    Next

    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func DrawConnections()
    If $g_a_PathingAABBs[0] = 0 Then Return
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
            If $l_i_ConnectedID <= $i Then ContinueLoop

            Local $l_a_AABB2 = $g_a_PathingAABBs[$l_i_ConnectedID]
            If Not IsArray($l_a_AABB2) Then ContinueLoop

            Local $l_i_X1 = WorldToScreenX($l_a_AABB1[1])
            Local $l_i_Y1 = WorldToScreenY($l_a_AABB1[2])
            Local $l_i_X2 = WorldToScreenX($l_a_AABB2[1])
            Local $l_i_Y2 = WorldToScreenY($l_a_AABB2[2])

            _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_Pen)
        Next
    Next

    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func DrawPortals()
    If $g_a_PathingPortals[0] = 0 Then Return

    Local $l_h_Pen = _GDIPlus_PenCreate(0xFF00FFFF, 2)
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFF00FFFF)

    For $i = 1 To $g_a_PathingPortals[0]
        Local $l_a_Portal = $g_a_PathingPortals[$i]
        If Not IsArray($l_a_Portal) Then ContinueLoop

        Local $l_i_X1 = WorldToScreenX($l_a_Portal[0])
        Local $l_i_Y1 = WorldToScreenY($l_a_Portal[1])
        Local $l_i_X2 = WorldToScreenX($l_a_Portal[2])
        Local $l_i_Y2 = WorldToScreenY($l_a_Portal[3])

        _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_Pen)

        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X1 - 3, $l_i_Y1 - 3, 6, 6, $l_h_Brush)
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X2 - 3, $l_i_Y2 - 3, 6, 6, $l_h_Brush)
    Next

    _GDIPlus_PenDispose($l_h_Pen)
    _GDIPlus_BrushDispose($l_h_Brush)
EndFunc

Func DrawPoints()
    If $g_a_PathingPoints[0] = 0 Then Return

    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFFFF00FF)

    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_Point = $g_a_PathingPoints[$i]
        If Not IsArray($l_a_Point) Then ContinueLoop

        Local $l_i_X = WorldToScreenX($l_a_Point[1])
        Local $l_i_Y = WorldToScreenY($l_a_Point[2])

        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_X - 2, $l_i_Y - 2, 4, 4, $l_h_Brush)
    Next

    _GDIPlus_BrushDispose($l_h_Brush)
EndFunc

Func DrawTeleports()
    If $g_a_PathingTeleports[0] = 0 Then Return

    Local $l_h_PenEnter = _GDIPlus_PenCreate(0xFF00FF00, 2)
    Local $l_h_PenExit = _GDIPlus_PenCreate(0xFFFF0000, 2)
    Local $l_h_PenLink = _GDIPlus_PenCreate(0xFF00FFFF, 1)
    Local $l_h_BrushEnter = _GDIPlus_BrushCreateSolid(0xFF00FF00)
    Local $l_h_BrushExit = _GDIPlus_BrushCreateSolid(0xFFFF0000)

    _GDIPlus_PenSetDashStyle($l_h_PenLink, $GDIP_DASHSTYLEDASH)

    For $i = 1 To $g_a_PathingTeleports[0]
        Local $l_a_Teleport = $g_a_PathingTeleports[$i]
        If Not IsArray($l_a_Teleport) Then ContinueLoop

        Local $l_i_EnterX = WorldToScreenX($l_a_Teleport[0])
        Local $l_i_EnterY = WorldToScreenY($l_a_Teleport[1])
        Local $l_i_ExitX = WorldToScreenX($l_a_Teleport[3])
        Local $l_i_ExitY = WorldToScreenY($l_a_Teleport[4])

        _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, $l_i_EnterX - 8, $l_i_EnterY - 8, 16, 16, $l_h_PenEnter)
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_EnterX - 5, $l_i_EnterY - 5, 10, 10, $l_h_BrushEnter)

        _GDIPlus_GraphicsDrawEllipse($g_h_VisualizerBuffer, $l_i_ExitX - 8, $l_i_ExitY - 8, 16, 16, $l_h_PenExit)
        _GDIPlus_GraphicsFillEllipse($g_h_VisualizerBuffer, $l_i_ExitX - 5, $l_i_ExitY - 5, 10, 10, $l_h_BrushExit)

        _GDIPlus_GraphicsDrawLine($g_h_VisualizerBuffer, $l_i_EnterX, $l_i_EnterY, $l_i_ExitX, $l_i_ExitY, $l_h_PenLink)
    Next

    _GDIPlus_PenDispose($l_h_PenEnter)
    _GDIPlus_PenDispose($l_h_PenExit)
    _GDIPlus_PenDispose($l_h_PenLink)
    _GDIPlus_BrushDispose($l_h_BrushEnter)
    _GDIPlus_BrushDispose($l_h_BrushExit)
EndFunc

Func DrawLegend()
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xC0000000)
    _GDIPlus_GraphicsFillRect($g_h_VisualizerBuffer, 10, 10, 150, 200, $l_h_Brush)
    _GDIPlus_BrushDispose($l_h_Brush)

    Local $l_h_Font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 10)
    Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    Local $l_h_Format = _GDIPlus_StringFormatCreate()

    Local $l_t_Layout = _GDIPlus_RectFCreate(15, 15, 140, 20)
    _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, "Legend", $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)

    Local $l_i_Y = 35
    Local $l_a_Legend[8][3] = [ _
        ["Trapezoids", 0xFFC8C8C8, $l_i_Y], _
        ["AABBs", 0x8000FF00, $l_i_Y + 20], _
        ["Portals", 0xFF00FFFF, $l_i_Y + 40], _
        ["Points", 0xFFFF00FF, $l_i_Y + 60], _
        ["Connections", 0x400080FF, $l_i_Y + 80], _
        ["Teleports", 0xFF00FF00, $l_i_Y + 100], _
        ["Scale: " & Round($g_f_VisualizerScale, 3), 0xFFFFFFFF, $l_i_Y + 130], _
        ["Map ID: " & $g_i_CurrentMapID, 0xFFFFFFFF, $l_i_Y + 150] _
    ]

    For $i = 0 To UBound($l_a_Legend) - 1
        If $i < 6 Then
            Local $l_h_ItemBrush = _GDIPlus_BrushCreateSolid($l_a_Legend[$i][1])
            _GDIPlus_GraphicsFillRect($g_h_VisualizerBuffer, 20, $l_a_Legend[$i][2], 15, 12, $l_h_ItemBrush)
            _GDIPlus_BrushDispose($l_h_ItemBrush)
        EndIf

        $l_t_Layout = _GDIPlus_RectFCreate(40, $l_a_Legend[$i][2], 100, 20)
        _GDIPlus_GraphicsDrawStringEx($g_h_VisualizerBuffer, $l_a_Legend[$i][0], $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_BrushText)
    Next

    _GDIPlus_FontDispose($l_h_Font)
    _GDIPlus_BrushDispose($l_h_BrushText)
    _GDIPlus_StringFormatDispose($l_h_Format)
EndFunc

Func DrawInfo()
    ; Additional map information if needed
EndFunc

; ===============================================================
; Utility Functions
; ===============================================================

Func ClearData()
    ReDim $g_a_PathingTrapezoids[1]
    ReDim $g_a_PathingAABBs[1]
    ReDim $g_a_PathingPortals[1]
    ReDim $g_a_PathingPoints[1]
    ReDim $g_a_PathingTeleports[1]
    ReDim $g_a_PathingAABBGraph[1]
    ReDim $g_a_PathingPTPortalGraph[1]
    ReDim $g_a_PathingVisGraph[1]
    ReDim $g_a_TeleportGraph[1]

    $g_a_PathingTrapezoids[0] = 0
    $g_a_PathingAABBs[0] = 0
    $g_a_PathingPortals[0] = 0
    $g_a_PathingPoints[0] = 0
    $g_a_PathingTeleports[0] = 0
    $g_a_TeleportGraph[0] = 0
EndFunc

Func CalculateBounds()
    $g_f_MapMinX = 999999
    $g_f_MapMaxX = -999999
    $g_f_MapMinY = 999999
    $g_f_MapMaxY = -999999
    $g_i_MaxPlane = 1

    For $i = 1 To $g_a_PathingTrapezoids[0]
        Local $l_a_Trap = $g_a_PathingTrapezoids[$i]
        If Not IsArray($l_a_Trap) Then ContinueLoop

        $g_f_MapMinX = _Min($g_f_MapMinX, _Min($l_a_Trap[2], _Min($l_a_Trap[4], _Min($l_a_Trap[6], $l_a_Trap[8]))))
        $g_f_MapMaxX = _Max($g_f_MapMaxX, _Max($l_a_Trap[2], _Max($l_a_Trap[4], _Max($l_a_Trap[6], $l_a_Trap[8]))))
        $g_f_MapMinY = _Min($g_f_MapMinY, _Min($l_a_Trap[3], _Min($l_a_Trap[5], _Min($l_a_Trap[7], $l_a_Trap[9]))))
        $g_f_MapMaxY = _Max($g_f_MapMaxY, _Max($l_a_Trap[3], _Max($l_a_Trap[5], _Max($l_a_Trap[7], $l_a_Trap[9]))))

        If $l_a_Trap[1] > $g_i_MaxPlane Then
            $g_i_MaxPlane = $l_a_Trap[1]
        EndIf
    Next

    $g_f_MapWidth = $g_f_MapMaxX - $g_f_MapMinX
    $g_f_MapHeight = $g_f_MapMaxY - $g_f_MapMinY
    $g_f_MapCenterX = ($g_f_MapMinX + $g_f_MapMaxX) / 2
    $g_f_MapCenterY = ($g_f_MapMinY + $g_f_MapMaxY) / 2
EndFunc

Func UpdateFileInfo()
    Local $s_Info = "Map ID: " & $g_i_CurrentMapID & @CRLF
    $s_Info &= "Trapezoids: " & $g_a_PathingTrapezoids[0] & @CRLF
    $s_Info &= "AABBs: " & $g_a_PathingAABBs[0] & @CRLF
    $s_Info &= "Portals: " & $g_a_PathingPortals[0] & @CRLF
    $s_Info &= "Points: " & $g_a_PathingPoints[0] & @CRLF
    $s_Info &= "Teleports: " & $g_a_PathingTeleports[0]

    GUICtrlSetData($g_h_InfoLabel, $s_Info)
EndFunc

Func WorldToScreenX($f_WorldX)
    Return $f_WorldX * $g_f_VisualizerScale + $g_f_VisualizerOffsetX
EndFunc

Func WorldToScreenY($f_WorldY)
    Return $g_i_VisualizerHeight - ($f_WorldY * $g_f_VisualizerScale + $g_f_VisualizerOffsetY)
EndFunc

Func ScreenToWorldX($i_ScreenX)
    Return ($i_ScreenX - $g_f_VisualizerOffsetX) / $g_f_VisualizerScale
EndFunc

Func ScreenToWorldY($i_ScreenY)
    Return ($g_i_VisualizerHeight - $i_ScreenY - $g_f_VisualizerOffsetY) / $g_f_VisualizerScale
EndFunc

Func _Log($s_Text, $i_Color = 0x000000)
    Local $i_TextLen = StringLen($s_Text)
    Local $i_ConsoleLen = _GUICtrlRichEdit_GetTextLength($g_h_EditLog)

    If $i_TextLen + $i_ConsoleLen > 30000 Then
        _GUICtrlRichEdit_SetText($g_h_EditLog, "")
    EndIf

    Local $s_TimeStamp = "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] "

    _GUICtrlRichEdit_SetCharColor($g_h_EditLog, $i_Color)
    _GUICtrlRichEdit_AppendText($g_h_EditLog, $s_TimeStamp & $s_Text & @CRLF)
    _GUICtrlRichEdit_ScrollToCaret($g_h_EditLog)
EndFunc

Func _Exit()
    If $g_h_VisualizerBuffer Then _GDIPlus_GraphicsDispose($g_h_VisualizerBuffer)
    If $g_h_VisualizerBitmap Then _GDIPlus_BitmapDispose($g_h_VisualizerBitmap)
    If $g_h_VisualizerGraphic Then _GDIPlus_GraphicsDispose($g_h_VisualizerGraphic)
    _GDIPlus_Shutdown()
    Exit
EndFunc