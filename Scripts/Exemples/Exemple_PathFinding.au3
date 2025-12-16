#RequireAdmin
#include "../../API/_GwAu3.au3"
#include "../../API/Pathfinding/_Pathfinder.au3"

Global Const $GC_B_LOAD_LOGGED_CHARS = True
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)

;~ DllCall(PATH)
$DLL_PATH = "..\..\API\Pathfinding\GWPathfinder.dll"

#Region Declarations
Global $g_i_ProcessID = ""
Global $g_i_Timer = TimerInit()

Global $g_b_BotRunning = False
Global $g_b_BotCoreInitialized = False
Global Const $GC_S_BOT_TITLE = "PathFinding Tester"

$g_b_AutoStart = False
$g_s_MainCharName = ""

; Pathfinding specific globals
Global $g_b_PathCalculated = False
Global $g_af2_CurrentPath[0][3]
Global $g_i_CurrentWaypoint = 0
Global $g_b_PathRunning = False
Global $g_f_DestX = 0
Global $g_f_DestY = 0
#EndRegion Declaration

; Process command line arguments
For $i = 1 To $CmdLine[0]
    If $CmdLine[$i] = "-character" And $i < $CmdLine[0] Then
        $g_s_MainCharName = $CmdLine[$i + 1]
        $g_b_AutoStart = True
        ExitLoop
    EndIf
Next

#Region ### START Koda GUI section ### Form=
$g_h_MainGui = GUICreate($GC_S_BOT_TITLE, 600, 450, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xEAEAEA, $g_h_MainGui)
$g_h_Group1 = GUICtrlCreateGroup("Select Your Character", 8, 8, 580, 430)

Global $g_h_NameCombo
If $GC_B_LOAD_LOGGED_CHARS Then
    $g_h_NameCombo = GUICtrlCreateCombo($g_s_MainCharName, 24, 32, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, Scanner_GetLoggedCharNames())
Else
    $g_h_NameCombo = GUICtrlCreateInput($g_s_MainCharName, 24, 32, 145, 25)
EndIf

$g_h_OnTopCheckbox = GUICtrlCreateCheckbox("On Top", 200, 31, 60, 24)
GUICtrlSetState($g_h_OnTopCheckbox, $GUI_CHECKED)
GUICtrlSetOnEvent($g_h_OnTopCheckbox, "GuiButtonHandler")

$g_h_DebugCheckbox = GUICtrlCreateCheckbox("Debug Mode", 270, 31, 80, 24)
GUICtrlSetState($g_h_DebugCheckbox, $GUI_CHECKED)
GUICtrlSetOnEvent($g_h_DebugCheckbox, "GuiButtonHandler")

$g_h_StartButton = GUICtrlCreateButton("Start", 24, 72, 75, 25)
GUICtrlSetOnEvent($g_h_StartButton, "GuiButtonHandler")

$g_h_RefreshButton = GUICtrlCreateButton("Refresh", 110, 72, 75, 25)
GUICtrlSetOnEvent($g_h_RefreshButton, "GuiButtonHandler")

; Pathfinding controls
GUICtrlCreateLabel("Destination X:", 200, 72, 70, 20)
$g_h_DestXInput = GUICtrlCreateInput("4409", 270, 70, 60, 20)

GUICtrlCreateLabel("Destination Y:", 340, 72, 70, 20)
$g_h_DestYInput = GUICtrlCreateInput("15043", 410, 70, 60, 20)

$g_h_CalcPathButton = GUICtrlCreateButton("Calculate Path", 490, 69, 85, 25)
GUICtrlSetOnEvent($g_h_CalcPathButton, "GuiButtonHandler")
GUICtrlSetState($g_h_CalcPathButton, $GUI_DISABLE)

$g_h_RunPathButton = GUICtrlCreateButton("Run Path", 200, 100, 75, 25)
GUICtrlSetOnEvent($g_h_RunPathButton, "GuiButtonHandler")
GUICtrlSetState($g_h_RunPathButton, $GUI_DISABLE)

$g_h_StopPathButton = GUICtrlCreateButton("Stop", 285, 100, 75, 25)
GUICtrlSetOnEvent($g_h_StopPathButton, "GuiButtonHandler")
GUICtrlSetState($g_h_StopPathButton, $GUI_DISABLE)

; Aggressiveness slider
GUICtrlCreateLabel("Path Optimization:", 370, 102, 90, 20)
$g_h_AggressSlider = GUICtrlCreateSlider(460, 98, 115, 30)
GUICtrlSetLimit($g_h_AggressSlider, 100, 0)
GUICtrlSetData($g_h_AggressSlider, 50)

$g_h_EditText = _GUICtrlRichEdit_Create($g_h_MainGui, "", 16, 135, 560, 295, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
_GUICtrlRichEdit_SetBkColor($g_h_EditText, $COLOR_WHITE)

GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Out("GWA2 PathFinding Tester")
Out("Created by: " & $GC_S_GWA2_CREATOR)
Out("Build date: " & $GC_S_GWA2_BUILD_DATE & @CRLF)
Out("GwAu3 Version: " & $GC_S_VERSION)
Out("Last Update: " & $GC_S_LAST_UPDATE & @CRLF)

Core_AutoStart()

; Main loop
While 1
    Sleep(100)

    If $g_b_BotCoreInitialized Then
        ; Update waypoint progress if path is running
        If $g_b_PathRunning And IsArray($g_af2_CurrentPath) Then
            RunPathUpdate()
        EndIf
    EndIf
WEnd

Func StartBot()
    Local $l_s_MainCharName = GUICtrlRead($g_h_NameCombo)
    If $l_s_MainCharName = "" Then
        If Core_Initialize(ProcessExists("gw.exe"), True) = 0 Then
            MsgBox(0, "Error", "Guild Wars is not running.")
            _Exit()
        EndIf
    ElseIf $g_i_ProcessID Then
        $l_i_ProcIdInt = Number($g_i_ProcessID, 2)
        If Core_Initialize($l_i_ProcIdInt, True) = 0 Then
            MsgBox(0, "Error", "Could not Find a ProcessID")
            _Exit()
        EndIf
    Else
        If Core_Initialize($l_s_MainCharName, True) = 0 Then
            MsgBox(0, "Error", "Could not Find a Guild Wars client with Character named '" & $l_s_MainCharName & "'")
            _Exit()
        EndIf
    EndIf

    GUICtrlSetState($g_h_StartButton, $GUI_DISABLE)
    GUICtrlSetState($g_h_RefreshButton, $GUI_DISABLE)
    GUICtrlSetState($g_h_NameCombo, $GUI_DISABLE)
    GUICtrlSetState($g_h_CalcPathButton, $GUI_ENABLE)

    WinSetTitle($g_h_MainGui, "", player_GetCharname() & " - " & $GC_S_BOT_TITLE)
    $g_b_BotRunning = True
    $g_b_BotCoreInitialized = True

    Out("Bot initialized for: " & player_GetCharname())
    Out("Current Map: " & Map_GetMapID())
    Out("Position: " & Round(Agent_GetAgentInfo(-2, "X")) & ", " & Round(Agent_GetAgentInfo(-2, "Y")))
EndFunc

Func CalculatePath()
    If Not $g_b_BotCoreInitialized Then
        Out("Please start the bot first!")
        Return
    EndIf

    Out("")
    Out("=== Calculating Path ===")

    ; Initialize Pathfinder if not already done
    Static $s_b_PathfinderInit = False
    If Not $s_b_PathfinderInit Then
        If Pathfinder_Initialize() Then
            Out("Pathfinder initialized successfully")
            $s_b_PathfinderInit = True
        Else
            Out("ERROR: Failed to initialize Pathfinder!")
            Out("Error code: " & @error)
            If @error = 1 Then
                Out("GWPathfinder.dll not found")
            ElseIf @error = 2 Then
                Out("Maps folder not found - Please extract maps.zip")
            EndIf
            Return
        EndIf
    EndIf

    ; Get current position
    Local $l_f_StartX = Agent_GetAgentInfo(-2, "X")
    Local $l_f_StartY = Agent_GetAgentInfo(-2, "Y")

    ; Get destination
    Local $l_s_InputX = GUICtrlRead($g_h_DestXInput)
    Local $l_s_InputY = GUICtrlRead($g_h_DestYInput)
    Out("DEBUG: Input X = '" & $l_s_InputX & "', Input Y = '" & $l_s_InputY & "'")

    $g_f_DestX = Number($l_s_InputX)
    $g_f_DestY = Number($l_s_InputY)

    Local $l_i_MapID = Map_GetMapID()

    Out("Map ID: " & $l_i_MapID)
    Out("From: (" & Round($l_f_StartX) & ", " & Round($l_f_StartY) & ")")
    Out("To: (" & Round($g_f_DestX) & ", " & Round($g_f_DestY) & ")" & @CRLF)

    ; Check if map is available
    If Not Pathfinder_IsMapAvailable($l_i_MapID) Then
        Out("ERROR: Map " & $l_i_MapID & " not available in pathfinding data!")
        $g_b_PathCalculated = False
        Return
    EndIf

    ; Calculate path
    Local $l_i_Timer = TimerInit()
    $g_af2_CurrentPath = Pathfinder_FindPathGW($l_i_MapID, $l_f_StartX, $l_f_StartY, $g_f_DestX, $g_f_DestY, 1250)
    Local $l_f_Time = TimerDiff($l_i_Timer)

    If Not IsArray($g_af2_CurrentPath) Then
        Out("ERROR: Failed to find path!")
        Out("Error code: " & @error)
        $g_b_PathCalculated = False
        Return
    EndIf

    Local $l_i_PointCount = UBound($g_af2_CurrentPath)
    Out("Path found in " & Round($l_f_Time, 2) & " ms")
    Out("Waypoints: " & $l_i_PointCount & @CRLF)

    ; Show all waypoints
    Out("All waypoints:")
    For $i = 0 To $l_i_PointCount - 1
        Out("  " & ($i + 1) & ": (" & Round($g_af2_CurrentPath[$i][0]) & ", " & Round($g_af2_CurrentPath[$i][1]) & ")")
    Next

    $g_b_PathCalculated = True
    $g_i_CurrentWaypoint = 0
    GUICtrlSetState($g_h_RunPathButton, $GUI_ENABLE)

    Out("=== End Calculation ===")
EndFunc

Func RunPath()
    If Not $g_b_PathCalculated Or Not IsArray($g_af2_CurrentPath) Then
        Out("Please calculate a path first!")
        Return
    EndIf

    Out("")
    Out("Starting path execution...")
    $g_b_PathRunning = True
    $g_i_CurrentWaypoint = 0

    GUICtrlSetState($g_h_RunPathButton, $GUI_DISABLE)
    GUICtrlSetState($g_h_StopPathButton, $GUI_ENABLE)
    GUICtrlSetState($g_h_CalcPathButton, $GUI_DISABLE)
EndFunc

Func StopPath()
    Out("Stopping path execution...")
    $g_b_PathRunning = False

    GUICtrlSetState($g_h_RunPathButton, $GUI_ENABLE)
    GUICtrlSetState($g_h_StopPathButton, $GUI_DISABLE)
    GUICtrlSetState($g_h_CalcPathButton, $GUI_ENABLE)
EndFunc

Func RunPathUpdate()
    If Not $g_b_PathRunning Then Return
    If $g_i_CurrentWaypoint >= UBound($g_af2_CurrentPath) Then
        Out("Destination reached!")
        StopPath()
        Return
    EndIf

    ; Get current position
    Local $l_f_CurrentX = Agent_GetAgentInfo(-2, "X")
    Local $l_f_CurrentY = Agent_GetAgentInfo(-2, "Y")

    ; Get current waypoint
    Local $l_f_WaypointX = $g_af2_CurrentPath[$g_i_CurrentWaypoint][0]
    Local $l_f_WaypointY = $g_af2_CurrentPath[$g_i_CurrentWaypoint][1]

    ; Calculate distance to waypoint
    Local $l_f_Distance = Sqrt(($l_f_WaypointX - $l_f_CurrentX)^2 + ($l_f_WaypointY - $l_f_CurrentY)^2)

    ; If close enough to waypoint, move to next
    If $l_f_Distance < 100 Then
        $g_i_CurrentWaypoint += 1
        If $g_i_CurrentWaypoint < UBound($g_af2_CurrentPath) Then
            Out("Waypoint " & $g_i_CurrentWaypoint & "/" & UBound($g_af2_CurrentPath) & " reached")
        EndIf
    Else
        ; Move towards waypoint
        Map_Move($l_f_WaypointX, $l_f_WaypointY, 0)
    EndIf
EndFunc

Func GuiButtonHandler()
    Switch @GUI_CtrlId
        Case $g_h_StartButton
            StartBot()

        Case $g_h_RefreshButton
            GUICtrlSetData($g_h_NameCombo, "")
            GUICtrlSetData($g_h_NameCombo, Scanner_GetLoggedCharNames())

        Case $g_h_OnTopCheckbox
            If GetChecked($g_h_OnTopCheckbox) Then
                WinSetOnTop($GC_S_BOT_TITLE, "", 1)
            Else
                WinSetOnTop($GC_S_BOT_TITLE, "", 0)
            EndIf

        Case $g_h_DebugCheckbox
            If GetChecked($g_h_DebugCheckbox) Then
                Log_SetDebugMode(True)
            Else
                Log_SetDebugMode(False)
            EndIf

        Case $g_h_CalcPathButton
            CalculatePath()

        Case $g_h_RunPathButton
            RunPath()

        Case $g_h_StopPathButton
            StopPath()

        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
EndFunc

Func Out($a_s_Text)
    Local $l_i_TextLen = StringLen($a_s_Text)
    Local $l_i_ConsoleLen = _GUICtrlEdit_GetTextLen($g_h_EditText)
    If $l_i_TextLen + $l_i_ConsoleLen > 30000 Then
        _GUICtrlRichEdit_SetText($g_h_EditText, "")
    EndIf
    _GUICtrlRichEdit_SetCharColor($g_h_EditText, $COLOR_BLACK)
    _GUICtrlEdit_AppendText($g_h_EditText, @CRLF & $a_s_Text)
    _GUICtrlEdit_Scroll($g_h_EditText, $SB_BOTTOM)
EndFunc

Func GetChecked($a_h_Ctrl)
    If BitAND(GUICtrlRead($a_h_Ctrl), $GUI_CHECKED) = $GUI_CHECKED Then
        Return True
    Else
        Return False
    EndIf
EndFunc

Func _Exit()
    Exit
EndFunc