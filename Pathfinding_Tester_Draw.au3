#RequireAdmin
#include "GwAu3/_GwAu3.au3"
#include "Tools/PathFinding/GwAu3_PathFinding_Cache.au3"
#include "Tools/PathFinding/GwAu3_PathFinding.au3"
#include "Tools/PathFinding/GwAu3_PathFinding_Visualizer_Draw.au3"

Global Const $doLoadLoggedChars = True
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)

#Region Declarations
Global $ProcessID = ""
Global $timer = TimerInit()

Global $BotRunning = False
Global $Bot_Core_Initialized = False
Global Const $BotTitle = "PathFinding Tester"

$g_bAutoStart = False  ; Flag for auto-start
$g_s_MainCharName  = ""

; Make the controls global so they can be accessed from the visualizer
Global $GUIDestXInput, $GUIDestYInput
Global $GUINameCombo
Global $g_h_VisualizerLabel
#EndRegion Declaration

; Process command line arguments
For $i = 1 To $CmdLine[0]
    If $CmdLine[$i] = "-character" And $i < $CmdLine[0] Then
        $g_s_MainCharName = $CmdLine[$i + 1]
        $g_bAutoStart = True
        ExitLoop
    EndIf
Next

#Region ### START Koda GUI section ### Form=
; Main GUI with larger size to accommodate visualizer
$MainGui = GUICreate($BotTitle, 1200, 700, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xEAEAEA, $MainGui)

; Left panel for controls
$Group1 = GUICtrlCreateGroup("Controls", 8, 8, 320, 680)

; Character selection
GUICtrlCreateLabel("Character:", 24, 32, 60, 20)

If $doLoadLoggedChars Then
    $GUINameCombo = GUICtrlCreateCombo($g_s_MainCharName, 90, 30, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, Scanner_GetLoggedCharNames())
Else
    $GUINameCombo = GUICtrlCreateInput($g_s_MainCharName, 90, 30, 145, 25)
EndIf

$gOnTopCheckbox = GUICtrlCreateCheckbox("On Top", 240, 31, 60, 24)
GUICtrlSetState($gOnTopCheckbox, $GUI_CHECKED)
GUICtrlSetOnEvent($gOnTopCheckbox, "GuiButtonHandler")

; Start/Refresh buttons
$GUIStartButton = GUICtrlCreateButton("Start", 24, 60, 75, 25)
GUICtrlSetOnEvent($GUIStartButton, "GuiButtonHandler")

$GUIRefreshButton = GUICtrlCreateButton("Refresh", 110, 60, 75, 25)
GUICtrlSetOnEvent($GUIRefreshButton, "GuiButtonHandler")

$gDebugCheckbox = GUICtrlCreateCheckbox("Debug Mode", 200, 61, 80, 24)
GUICtrlSetState($gDebugCheckbox, $GUI_CHECKED)
GUICtrlSetOnEvent($gDebugCheckbox, "GuiButtonHandler")

; Pathfinding test controls
GUICtrlCreateLabel("Pathfinding Controls:", 24, 95, 120, 20)

$GUITestPathButton = GUICtrlCreateButton("Test Path", 24, 115, 75, 25)
GUICtrlSetOnEvent($GUITestPathButton, "GuiButtonHandler")
GUICtrlSetState($GUITestPathButton, $GUI_DISABLE)

; Destination inputs
GUICtrlCreateLabel("Destination X:", 24, 150, 70, 20)
$GUIDestXInput = GUICtrlCreateInput("-11038.2080", 100, 147, 80, 20)
GUICtrlCreateLabel("Destination Y:", 24, 175, 70, 20)
$GUIDestYInput = GUICtrlCreateInput("-4265.8488", 100, 172, 80, 20)

; Visualizer controls
GUICtrlCreateLabel("Visualizer Controls:", 24, 205, 120, 20)

$GUIZoomInButton = GUICtrlCreateButton("Zoom +", 24, 225, 60, 25)
GUICtrlSetOnEvent($GUIZoomInButton, "VisualizerButtonHandler")

$GUIZoomOutButton = GUICtrlCreateButton("Zoom -", 90, 225, 60, 25)
GUICtrlSetOnEvent($GUIZoomOutButton, "VisualizerButtonHandler")

$GUIResetViewButton = GUICtrlCreateButton("Reset View", 156, 225, 70, 25)
GUICtrlSetOnEvent($GUIResetViewButton, "VisualizerButtonHandler")

$GUICheckCenterPlayer = GUICtrlCreateCheckbox("Center Player", 232, 227, 85, 20)
GUICtrlSetOnEvent($GUICheckCenterPlayer, "VisualizerToggleHandler")

; Visualizer toggles
GUICtrlCreateLabel("Display Options:", 24, 260, 100, 20)

$GUICheckTrapezoids = GUICtrlCreateCheckbox("Trapezoids", 24, 280, 80, 20)
GUICtrlSetState($GUICheckTrapezoids, $GUI_CHECKED)
GUICtrlSetOnEvent($GUICheckTrapezoids, "VisualizerToggleHandler")

$GUICheckAABBs = GUICtrlCreateCheckbox("AABBs", 110, 280, 80, 20)
GUICtrlSetOnEvent($GUICheckAABBs, "VisualizerToggleHandler")

$GUICheckPortals = GUICtrlCreateCheckbox("Portals", 190, 280, 80, 20)
GUICtrlSetOnEvent($GUICheckPortals, "VisualizerToggleHandler")

$GUICheckConnections = GUICtrlCreateCheckbox("Connections", 24, 305, 85, 20)
GUICtrlSetState($GUICheckConnections, $GUI_CHECKED)
GUICtrlSetOnEvent($GUICheckConnections, "VisualizerToggleHandler")

$GUICheckPoints = GUICtrlCreateCheckbox("Points", 115, 305, 80, 20)
GUICtrlSetOnEvent($GUICheckPoints, "VisualizerToggleHandler")

$GUICheckVisGraph = GUICtrlCreateCheckbox("Vis Graph (cause lag)", 195, 305, 120, 20)
GUICtrlSetOnEvent($GUICheckVisGraph, "VisualizerToggleHandler")
GUICtrlSetState($GUICheckVisGraph, $GUI_DISABLE)

$GUICheckTeleports = GUICtrlCreateCheckbox("Teleports", 24, 330, 80, 20)
GUICtrlSetState($GUICheckTeleports, $GUI_CHECKED)
GUICtrlSetOnEvent($GUICheckTeleports, "VisualizerToggleHandler")

$GUICheckLabels = GUICtrlCreateCheckbox("Labels", 110, 330, 80, 20)
GUICtrlSetOnEvent($GUICheckLabels, "VisualizerToggleHandler")

; New toggles
$GUICheckWireframe = GUICtrlCreateCheckbox("Wireframe", 24, 355, 80, 20)
GUICtrlSetState($GUICheckWireframe, $GUI_CHECKED)
GUICtrlSetOnEvent($GUICheckWireframe, "VisualizerToggleHandler")

$GUICheckDistCircles = GUICtrlCreateCheckbox("Distance Circles", 110, 355, 100, 20)
GUICtrlSetOnEvent($GUICheckDistCircles, "VisualizerToggleHandler")

$GUICheckGradient = GUICtrlCreateCheckbox("Gradient Colors", 24, 380, 100, 20)
GUICtrlSetState($GUICheckGradient, $GUI_CHECKED)
GUICtrlSetOnEvent($GUICheckGradient, "VisualizerToggleHandler")

; Console output
GUICtrlCreateLabel("Console Output:", 24, 410, 100, 20)
$g_h_EditText = _GUICtrlRichEdit_Create($MainGui, "", 24, 430, 290, 245, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
_GUICtrlRichEdit_SetBkColor($g_h_EditText, $COLOR_WHITE)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Right panel for visualizer
$Group2 = GUICtrlCreateGroup("PathFinding Visualizer", 335, 8, 855, 680)

; Info label about controls - Updated to remove left click + drag and keyboard shortcuts
GUICtrlCreateLabel("Right Click: Set destination | Scroll: Zoom", 345, 665, 835, 15)
GUICtrlSetColor(-1, 0x666666)

; Create an invisible label that will capture mouse events
$g_h_VisualizerLabel = GUICtrlCreateLabel("", 340, 28, 845, 635)
GUICtrlSetBkColor($g_h_VisualizerLabel, 0x1A1A1A)

GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "OnSecondaryDown")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Register mouse wheel for zoom
GUIRegisterMsg($WM_MOUSEWHEEL, "PathFinding_Visualizer_MouseWheel")

; Initialize visualizer after GUI is shown
AdlibRegister("InitializeIntegratedVisualizer")

Func InitializeIntegratedVisualizer()
    AdlibUnRegister("InitializeIntegratedVisualizer")
    ; Get the window handle instead of control handle
    PathFinding_Visualizer_Init($MainGui, 845, 635)
EndFunc

; Mouse event handlers for GUIOnEventMode
Func OnSecondaryDown()
    Local $a_MouseInfo = GUIGetCursorInfo($MainGui)
    If Not IsArray($a_MouseInfo) Then Return

    ; Check if mouse is over visualizer area
    If $a_MouseInfo[4] = $g_h_VisualizerLabel Then
        ; Get relative position within visualizer
        Local $l_i_RelX = $a_MouseInfo[0] - 340
        Local $l_i_RelY = $a_MouseInfo[1] - 28
        PathFinding_Visualizer_OnRightClick($l_i_RelX, $l_i_RelY)
    EndIf
EndFunc

Func StartBot()
    Local $g_s_MainCharName = GUICtrlRead($GUINameCombo)
    If $g_s_MainCharName=="" Then
        If Core_Initialize(ProcessExists("gw.exe"), True) = 0 Then
            MsgBox(0, "Error", "Guild Wars is not running.")
            _Exit()
        EndIf
    ElseIf $ProcessID Then
        $proc_id_int = Number($ProcessID, 2)
        If Core_Initialize($proc_id_int, True) = 0 Then
            MsgBox(0, "Error", "Could not Find a ProcessID or somewhat '"&$proc_id_int&"'  "&VarGetType($proc_id_int)&"'")
            _Exit()
            If ProcessExists($proc_id_int) Then
                ProcessClose($proc_id_int)
            EndIf
            Exit
        EndIf
    Else
        If Core_Initialize($g_s_MainCharName, True) = 0 Then
            MsgBox(0, "Error", "Could not Find a Guild Wars client with a Character named '"&$g_s_MainCharName&"'")
            _Exit()
        EndIf
    EndIf

    GUICtrlSetState($GUIStartButton, $GUI_Disable)
    GUICtrlSetState($GUIRefreshButton, $GUI_Disable)
    GUICtrlSetState($GUINameCombo, $GUI_DISABLE)
    GUICtrlSetState($GUITestPathButton, $GUI_ENABLE)

    WinSetTitle($MainGui, "", player_GetCharname() & " - PathFinding Test")
    $BotRunning = True
    $Bot_Core_Initialized = True

    Out("Bot started for " & player_GetCharname())
    Out("")

    ; Initialize pathfinding
    Out("Initializing PathFinding system...")
    Local $l_i_StartTime = TimerInit()

    If PathFinding_InitializeWithCache() Then
        Local $l_f_ElapsedTime = TimerDiff($l_i_StartTime)
        Out("PathFinding initialized in " & Round($l_f_ElapsedTime, 2) & " ms")
        Out("Map data loaded:")
        Out("  - Trapezoids: " & PathFinding_GetTrapezoidCount())
        Out("  - AABBs: " & PathFinding_GetAABBCount())
        Out("  - Portals: " & PathFinding_GetPortalCount())
        Out("  - Points: " & PathFinding_GetPointCount())
        Out("  - Teleports: " & PathFinding_GetTeleportCount())
        Out("")
        Out("Ready for pathfinding tests!")

        ; Update visualizer
        PathFinding_Visualizer_Update()
    Else
        Out("Failed to initialize PathFinding!")
    EndIf
EndFunc

Func TestPathFinding()
    Out("")
    Out("=== Testing PathFinding ===")

    ; Get destination from inputs
    Local $l_f_DestX = Number(GUICtrlRead($GUIDestXInput))
    Local $l_f_DestY = Number(GUICtrlRead($GUIDestYInput))

    ; Get current position
    Local $l_f_StartX = Agent_GetAgentInfo(-2, "X")
    Local $l_f_StartY = Agent_GetAgentInfo(-2, "Y")

    Out("From: (" & Round($l_f_StartX, 2) & ", " & Round($l_f_StartY, 2) & ")")
    Out("To: (" & Round($l_f_DestX, 2) & ", " & Round($l_f_DestY, 2) & ")")
    Out("")

    ; Test pathfinding
    Local $l_i_StartTime = TimerInit()
    Local $l_v_Result = GetPath($l_f_DestX, $l_f_DestY)
    Local $l_f_ElapsedTime = TimerDiff($l_i_StartTime)

    ; Check result
    If IsArray($l_v_Result) Then
        Out("Path found in " & Round($l_f_ElapsedTime, 2) & " ms")
        Out("Path has " & $l_v_Result[0][0] & " waypoints:")

        Local $l_f_TotalDistance = 0
        For $i = 1 To $l_v_Result[0][0]
            Out("  " & $i & ": (" & Round($l_v_Result[$i][0], 2) & ", " & Round($l_v_Result[$i][1], 2) & ")")

            If $i > 1 Then
                Local $l_f_SegmentDist = PathFinding_Distance2D($l_v_Result[$i-1][0], $l_v_Result[$i-1][1], _
                                                                $l_v_Result[$i][0], $l_v_Result[$i][1])
                $l_f_TotalDistance += $l_f_SegmentDist
            EndIf
        Next

        Out("")
        Out("Total path distance: " & Round($l_f_TotalDistance, 2))

        ; Update visualizer with path
        PathFinding_Visualizer_SetPath($l_v_Result)
    Else
        Out("PathFinding failed!")
        Out("Error code: " & $l_v_Result)

        Switch $l_v_Result
            Case $PATHING_ERROR_UNKNOWN
                Out("Unknown error")
            Case $PATHING_ERROR_FAILED_TO_FIND_GOAL_BOX
                Out("Failed to find goal AABB")
            Case $PATHING_ERROR_FAILED_TO_FIND_START_BOX
                Out("Failed to find start AABB")
            Case $PATHING_ERROR_FAILED_TO_FINALIZE_PATH
                Out("Failed to finalize path")
            Case $PATHING_ERROR_INVALID_MAP_CONTEXT
                Out("Invalid map context")
            Case $PATHING_ERROR_BUILD_PATH_LENGTH_EXCEEDED
                Out("Path too long")
            Case $PATHING_ERROR_FAILED_TO_GET_PATHING_MAP_BLOCK
                Out("Failed to get pathing map blocks")
        EndSwitch
    EndIf

    Out("=== End Test ===")
EndFunc

Func GuiButtonHandler()
    Switch @GUI_CtrlId
        Case $GUIStartButton
            StartBot()

        Case $GUIRefreshButton
            GUICtrlSetData($GUINameCombo, "")
            GUICtrlSetData($GUINameCombo, Scanner_GetLoggedCharNames())

        Case $gOnTopCheckbox
            If GetChecked($gOnTopCheckbox) Then
                WinSetOnTop($BotTitle, "", 1)
            Else
                WinSetOnTop($BotTitle, "", 0)
            EndIf

        Case $gDebugCheckbox
            If GetChecked($gDebugCheckbox) Then
                Log_SetDebugMode(True)
            Else
                Log_SetDebugMode(False)
            EndIf

        Case $GUITestPathButton
            TestPathFinding()

        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
EndFunc

Func VisualizerButtonHandler()
    Switch @GUI_CtrlId
        Case $GUIZoomInButton
            PathFinding_Visualizer_ZoomIn()
			$g_b_CenterOnPlayer = False
			GUICtrlSetState($GUICheckCenterPlayer, $GUI_UNCHECKED)

        Case $GUIZoomOutButton
            PathFinding_Visualizer_ZoomOut()
			$g_b_CenterOnPlayer = False
			GUICtrlSetState($GUICheckCenterPlayer, $GUI_UNCHECKED)

        Case $GUIResetViewButton
            PathFinding_Visualizer_Reset()
			$g_b_CenterOnPlayer = False
			GUICtrlSetState($GUICheckCenterPlayer, $GUI_UNCHECKED)

    EndSwitch
EndFunc

Func VisualizerToggleHandler()
    Switch @GUI_CtrlId
        Case $GUICheckTrapezoids
            PathFinding_Visualizer_ToggleTrapezoids()

        Case $GUICheckAABBs
            PathFinding_Visualizer_ToggleAABBs()

        Case $GUICheckPortals
            PathFinding_Visualizer_TogglePortals()

        Case $GUICheckConnections
            PathFinding_Visualizer_ToggleConnections()

        Case $GUICheckPoints
            PathFinding_Visualizer_TogglePoints()

        Case $GUICheckVisGraph
            PathFinding_Visualizer_ToggleVisibilityGraph()

        Case $GUICheckTeleports
            PathFinding_Visualizer_ToggleTeleports()

        Case $GUICheckLabels
            PathFinding_Visualizer_ToggleLabels()

        Case $GUICheckWireframe
            PathFinding_Visualizer_ToggleWireframe()

        Case $GUICheckDistCircles
            PathFinding_Visualizer_ToggleDistanceCircles()

        Case $GUICheckGradient
            PathFinding_Visualizer_ToggleGradientColors()

        Case $GUICheckCenterPlayer
            PathFinding_Visualizer_ToggleCenterPlayer()
    EndSwitch
EndFunc

Out("PathFinding Test")
Out("==========================================")
Out("Based on GWA2")
Out("GWA2 - Created by: " & $GC_S_GWA2_CREATOR)
Out("GWA2 - Build date: " & $GC_S_GWA2_BUILD_DATE & @CRLF)

Out("GwAu3 - Created by: " & $GC_S_UPDATOR)
Out("GwAu3 - Build date: " & $GC_S_BUILD_DATE)
Out("GwAu3 - Version: " & $GC_S_VERSION)
Out("GwAu3 - Last Update: " & $GC_S_LAST_UPDATE & @CRLF)

Core_AutoStart()

While Not $BotRunning
    Sleep(100)
WEnd

; Main loop - update visualizer periodically
While $BotRunning
    If $g_b_VisualizerInitialized Then
        PathFinding_Visualizer_Update()
    EndIf
    Sleep(16)
WEnd

Func Out($TEXT)
    Local $TEXTLEN = StringLen($TEXT)
    Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($g_h_EditText)
    If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($g_h_EditText, StringRight(_GUICtrlEdit_GetText($g_h_EditText), 30000 - $TEXTLEN - 1000))
    _GUICtrlRichEdit_SetCharColor($g_h_EditText, $COLOR_BLACK)
    _GUICtrlEdit_AppendText($g_h_EditText, @CRLF & $TEXT)
    _GUICtrlEdit_Scroll($g_h_EditText, 1)
EndFunc

Func GetChecked($GUICtrl)
    If BitAND(GUICtrlRead($GUICtrl), $GUI_CHECKED) = $GUI_CHECKED then
        Return  True
    Else
        Return False
    EndIf
EndFunc

Func _Exit()
    If $g_b_VisualizerInitialized Then
        PathFinding_Visualizer_Close()
    EndIf
    Exit
EndFunc