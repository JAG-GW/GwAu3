#RequireAdmin
#include "GwAu3/_GwAu3.au3"
#include "Tools/ImGui/ImGui.au3"
#include "Tools/ImGui/ImGui_Utils.au3"

Global Const $doLoadLoggedChars = True
Opt("GUIOnEventMode", False)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)

#Region Declarations
Global $s_GUI_Status = "Ready"
Global $b_GUI_CheckBox_GUI_DebugMode = True
Global $b_GUI_CheckBox_OnTop = True
Global $b_GUI_BotRunning = False
Global $i_Number_CharName = 0
Global $Selected_Char = ""
Global $s_GUI_Script_Name = "Tester Bot"

; Add compatibility with Core_AutoStart
Global $g_s_MainCharName = ""  ; Used by Core_AutoStart()
Global $ProcessID = ""
Global $timer = TimerInit()
Global $Bot_Core_Initialized = False
Global $g_bAutoStart = False  ; Flag for auto-start

; Character list
Global $g_aCharNames[1] = ["Select Character..."]

; Stats
Global $g_iRunCount = 0
Global $g_fRunTime = 0

; Event flags
Global $g_b_Event_StartBot = False
Global $g_b_Event_StopBotNextRun = False
Global $g_b_Event_StopBot = False
Global $g_b_Event_RefreshChars = False
Global $g_b_Event_ClearConsole = False
Global $g_b_Event_CopyConsole = False
Global $g_b_Event_Exit = False
Global $g_b_Event_ToggleDebug = False
Global $g_b_Event_ToggleOnTop = False
Global $g_b_Event_CharacterSelected = False
Global $g_i_Event_SelectedCharIndex = 0
Log_SetCallback(_LogCallback)
#EndRegion Declarations

For $i = 1 To $CmdLine[0]
    If $CmdLine[$i] = "-character" And $i < $CmdLine[0] Then
        $Selected_Char = $CmdLine[$i + 1]
        $g_s_MainCharName = $Selected_Char
        $g_bAutoStart = True
        Log_Message("Auto-start requested for character: " & $Selected_Char, $c_UTILS_Msg_Type_Info, "Init")
        ExitLoop
    EndIf
Next

_ImGui_EnableViewports()
_ImGui_GUICreate($s_GUI_Script_Name, 100, 100)
_ImGui_StyleColorsDark()
_ImGui_SetWindowTitleAlign(0.5, 0.5)
_ImGui_EnableDocking()

TraySetToolTip($s_GUI_Script_Name)

RefreshCharacterList()

Log_Message("Tester Bot Started", $c_UTILS_Msg_Type_Info, "Init")
Log_Message("Based on GWA2 by " & $GC_S_GWA2_CREATOR, $c_UTILS_Msg_Type_Info, "Init")
Log_Message("GwAu3 v" & $GC_S_VERSION & " by " & $GC_S_UPDATOR, $c_UTILS_Msg_Type_Info, "Init")

If $g_bAutoStart And $Selected_Char <> "" Then
    Local $charFound = False
    For $i = 1 To UBound($g_aCharNames) - 1
        If $g_aCharNames[$i] = $Selected_Char Then
            $i_Number_CharName = $i
            $charFound = True
            Log_Message("Character found in list at index " & $i, $c_UTILS_Msg_Type_Info, "Init")
            ExitLoop
        EndIf
    Next

    If Not $charFound Then
        Log_Message("Character not found in list, will try direct initialization", $c_UTILS_Msg_Type_Warning, "Init")
    EndIf

    $g_b_Event_StartBot = True
EndIf

AdlibRegister("_GUI_Handle", 30)
AdlibRegister("ProcessEvents", 30)

While 1
    Sleep(10)

    If $b_GUI_BotRunning And $Bot_Core_Initialized Then
        BotLoop()
    EndIf

	If $g_b_Event_StopBotNextRun Then
        $g_b_Event_StopBotNextRun = False
        StopBot()
    EndIf

    If $g_b_Event_Exit Then _GUI_ExitApp()
WEnd

_GUI_ExitApp()

Func ProcessEvents()
	If $g_b_Event_Exit Then _GUI_ExitApp()

    If $g_b_Event_StartBot Then
        $g_b_Event_StartBot = False
        StartBot()
    EndIf

    If $g_b_Event_StopBot Then
        $g_b_Event_StopBot = False
        StopBot()
    EndIf

    If $g_b_Event_RefreshChars Then
        $g_b_Event_RefreshChars = False
        RefreshCharacterList()
    EndIf

    If $g_b_Event_ClearConsole Then
        $g_b_Event_ClearConsole = False
        ReDim $a_UTILS_Log_Messages[0][8]
        Log_Message("Console cleared", $c_UTILS_Msg_Type_Info, "GUI")
    EndIf

    If $g_b_Event_CopyConsole Then
        $g_b_Event_CopyConsole = False
        _GUI_CopyConsoleToClipboard()
    EndIf

    If $g_b_Event_ToggleDebug Then
        $g_b_Event_ToggleDebug = False
        $b_GUI_CheckBox_GUI_DebugMode = Not $b_GUI_CheckBox_GUI_DebugMode
        Log_SetDebugMode($b_GUI_CheckBox_GUI_DebugMode)
        Log_Message("Debug mode: " & ($b_GUI_CheckBox_GUI_DebugMode ? "Enabled" : "Disabled"), $c_UTILS_Msg_Type_Info, "GUI")
    EndIf

    If $g_b_Event_ToggleOnTop Then
        $g_b_Event_ToggleOnTop = False
        $b_GUI_CheckBox_OnTop = Not $b_GUI_CheckBox_OnTop
        Log_Message("Always on top: " & ($b_GUI_CheckBox_OnTop ? "Enabled" : "Disabled"), $c_UTILS_Msg_Type_Info, "GUI")
    EndIf

    If $g_b_Event_CharacterSelected Then
        $g_b_Event_CharacterSelected = False
        If $g_i_Event_SelectedCharIndex > 0 And $g_i_Event_SelectedCharIndex <= UBound($g_aCharNames) - 1 Then
            $i_Number_CharName = $g_i_Event_SelectedCharIndex
            $Selected_Char = $g_aCharNames[$g_i_Event_SelectedCharIndex]
            $g_s_MainCharName = $Selected_Char
            Log_Message("Selected character: " & $Selected_Char, $c_UTILS_Msg_Type_Info, "GUI")
        EndIf
    EndIf
EndFunc

Func _GUI_Handle()
    If Not _ImGui_PeekMsg() Then
        $g_b_Event_Exit = True
        Return
    EndIf

    _ImGui_BeginFrame()

    If Not _ImGui_Begin($s_GUI_Script_Name, True, BitOR($ImGuiWindowFlags_AlwaysAutoResize, $ImGuiWindowFlags_MenuBar)) Then
        $g_b_Event_Exit = True
        Return
    EndIf

    _GUI_MenuBar()

    Local $winSize = _ImGui_GetWindowSize()

    If $b_GUI_CheckBox_GUI_DebugMode Then _GUI_AddOns_LogConsole()

    If $b_GUI_BotRunning = False Then
        _ImGui_Text("Select Character:")
        _ImGui_Separator()

        _ImGui_BeginChild("CharList", -1, 150, True)
        For $i = 1 To UBound($g_aCharNames) - 1
            Local $selected = ($i_Number_CharName == $i)
            If _ImGui_Selectable($g_aCharNames[$i], $selected) Then
                $g_i_Event_SelectedCharIndex = $i
                $g_b_Event_CharacterSelected = True
            EndIf
        Next
        _ImGui_EndChild()

        If _ImGui_Button("Refresh Characters", -1, 30) Then
            $g_b_Event_RefreshChars = True
        EndIf

        _ImGui_NewLine()

        If _ImGui_Button("Start Bot", -1, 40) Then
            $g_b_Event_StartBot = True
        EndIf
    Else
        _ImGui_Text("Character: " & player_GetCharname())
        _ImGui_Text("Run Count: " & $g_iRunCount)
        _ImGui_Text("Runtime: " & FormatTime($g_fRunTime))

        _ImGui_NewLine()
        If _ImGui_Button("Stop Bot After This Run", -1, 40) Then
            $g_b_Event_StopBotNextRun = True
        EndIf
		If _ImGui_Button("Stop Bot Now", -1, 40) Then
            $g_b_Event_StopBot = True
        EndIf

    EndIf

    _ImGui_NewLine()

    Local $text_width = _ImGui_CalcTextSize($s_GUI_Status)[0]
    _ImGui_Dummy((_ImGui_GetWindowWidth() - $text_width) * 0.45, 0)
    _ImGui_SameLine()

    Switch $s_GUI_Status
        Case "Ready", "Bot stopped"
            _ImGui_TextColored($s_GUI_Status, 0xFFFFFF00)
        Case "Bot running"
            _ImGui_TextColored($s_GUI_Status, 0xFF00FF00)
        Case "Failed to initialize", "Error"
            _ImGui_TextColored($s_GUI_Status, 0xFFFF0000)
        Case Else
            _ImGui_Text($s_GUI_Status)
    EndSwitch

    _ImGui_EndFrame()
EndFunc

Func _GUI_MenuBar()
    If _ImGui_BeginMenuBar() Then
        If _ImGui_BeginMenu("Menu") Then
            If _ImGui_MenuItem("Debug Mode", "", $b_GUI_CheckBox_GUI_DebugMode) Then
                $g_b_Event_ToggleDebug = True
            EndIf

            If _ImGui_MenuItem("Always On Top", "", $b_GUI_CheckBox_OnTop) Then
                $g_b_Event_ToggleOnTop = True
            EndIf

            _ImGui_Separator()

            If _ImGui_MenuItem("Exit") Then
                $g_b_Event_Exit = True
            EndIf

            _ImGui_EndMenu()
        EndIf
        _ImGui_EndMenuBar()
    EndIf
EndFunc

Func _GUI_AddOns_LogConsole()
    _ImGui_Text("Debug Console:")
    _ImGui_BeginChild("DebugConsole", 800, 200, True, $ImGuiWindowFlags_HorizontalScrollbar)

    For $i = 0 To UBound($a_UTILS_Log_Messages) - 1
        _ImGui_Text("[")
        _ImGui_SameLine(0, 0)
        _ImGui_TextColored($a_UTILS_Log_Messages[$i][0], $a_UTILS_Log_Messages[$i][1])
        _ImGui_SameLine(0, 0)
        _ImGui_Text("] - ")
        _ImGui_SameLine(0, 0)
        _ImGui_Text("[")
        _ImGui_SameLine(0, 0)
        _ImGui_TextColored($a_UTILS_Log_Messages[$i][2], $a_UTILS_Log_Messages[$i][3])
        _ImGui_SameLine(0, 0)
        _ImGui_Text("] - ")
        _ImGui_SameLine(0, 0)
        _ImGui_Text("[")
        _ImGui_SameLine(0, 0)
        _ImGui_TextColored($a_UTILS_Log_Messages[$i][4], $a_UTILS_Log_Messages[$i][5])
        _ImGui_SameLine(0, 0)
        _ImGui_Text("] ")
        _ImGui_SameLine(0, 0)
        _ImGui_TextColored($a_UTILS_Log_Messages[$i][6], $a_UTILS_Log_Messages[$i][7])
    Next

    _ImGui_SetScrollFromPosY("DebugConsole", -0.05)
    _ImGui_EndChild()

    If _ImGui_Button("Clear Console") Then
        $g_b_Event_ClearConsole = True
    EndIf
    _ImGui_SameLine()
    If _ImGui_Button("Copy Console") Then
        $g_b_Event_CopyConsole = True
    EndIf

    _ImGui_Separator()
EndFunc

Func _GUI_CopyConsoleToClipboard()
    Local $sConsoleText = ""
    For $i = 0 To UBound($a_UTILS_Log_Messages) - 1
        Local $sLine = "[" & $a_UTILS_Log_Messages[$i][0] & "] - [" & $a_UTILS_Log_Messages[$i][2] & "] - [" & $a_UTILS_Log_Messages[$i][4] & "] " & $a_UTILS_Log_Messages[$i][6]
        $sConsoleText &= $sLine & @CRLF
    Next
    ClipPut($sConsoleText)
    Log_Message("Console copied to clipboard", $c_UTILS_Msg_Type_Info, "GUI")
EndFunc

Func _GUI_ExitApp()
    AdlibUnRegister("_GUI_Handle")
    AdlibUnRegister("TimeUpdater")
    Exit
EndFunc

#Region Bot Functions
Func StartBot()
    If $Selected_Char = "" Or $Selected_Char = "Select Character..." Then
        Log_Message("Please select a character first!", $c_UTILS_Msg_Type_Warning, "StartBot")
        $s_GUI_Status = "No character selected"
        Return
    EndIf

    Log_Message("Starting bot for character: " & $Selected_Char, $c_UTILS_Msg_Type_Info, "StartBot")
    $s_GUI_Status = "Initializing..."

    $g_s_MainCharName = $Selected_Char

    Local $result = 0
    If $ProcessID Then
        $proc_id_int = Number($ProcessID, 2)
        $result = Core_Initialize($proc_id_int, True)
    Else
        $result = Core_Initialize($Selected_Char, True)
    EndIf

    If $result = 0 Then
        Log_Message("Failed to initialize GwAu3 Core!", $c_UTILS_Msg_Type_Error, "StartBot")
        $s_GUI_Status = "Failed to initialize"
        Return
    EndIf

    $Bot_Core_Initialized = True
    $b_GUI_BotRunning = True
    $s_GUI_Status = "Bot running"
    $timer = TimerInit()

    Log_Message("Bot started successfully for " & player_GetCharname(), $c_UTILS_Msg_Type_Info, "StartBot")

    AdlibRegister("TimeUpdater", 500)

    If $g_bAutoStart Then
        AdlibRegister("HandleAutoStart", 100)
    EndIf
EndFunc

Func HandleAutoStart()
    AdlibUnRegister("HandleAutoStart")
    Log_Message("Handling auto-start character selection...", $c_UTILS_Msg_Type_Info, "HandleAutoStart")
    Core_AutoStart()
    $g_bAutoStart = False
EndFunc

Func StopBot()
    Log_Message("Stopping bot...", $c_UTILS_Msg_Type_Info, "StopBot")

    $b_GUI_BotRunning = False
    $Bot_Core_Initialized = False
    $s_GUI_Status = "Bot stopped"
    $g_bAutoStart = False

    AdlibUnRegister("TimeUpdater")

    Log_Message("Bot stopped", $c_UTILS_Msg_Type_Info, "StopBot")
EndFunc

Func RefreshCharacterList()
    Log_Message("Refreshing character list...", $c_UTILS_Msg_Type_Info, "Refresh")
    Local $sCharNames = Scanner_GetLoggedCharNames()

    ReDim $g_aCharNames[1]
    $g_aCharNames[0] = "Select Character..."

    If $sCharNames <> "" Then
        Local $aTempNames = StringSplit($sCharNames, "|", 2)
        For $i = 0 To UBound($aTempNames) - 1
            _ArrayAdd($g_aCharNames, $aTempNames[$i])
        Next
        Log_Message("Found " & (UBound($g_aCharNames) - 1) & " characters", $c_UTILS_Msg_Type_Info, "Refresh")
    Else
        Log_Message("No characters found", $c_UTILS_Msg_Type_Warning, "Refresh")
    EndIf

    If $Selected_Char <> "" And $Selected_Char <> "Select Character..." Then
        For $i = 1 To UBound($g_aCharNames) - 1
            If $g_aCharNames[$i] = $Selected_Char Then
                $i_Number_CharName = $i
                ExitLoop
            EndIf
        Next
    Else
        $i_Number_CharName = 0
        $Selected_Char = ""
    EndIf
EndFunc

Func BotLoop()
    Sleep(500)
    Log_Message("Ready", $c_UTILS_Msg_Type_Info, "BotLoop")

    Log_Message("Done", $c_UTILS_Msg_Type_Info, "BotLoop")
    $g_iRunCount += 1
    Sleep(5000)
EndFunc

Func TimeUpdater()
    If $b_GUI_BotRunning Then
        $g_fRunTime = TimerDiff($timer) / 1000
    EndIf
EndFunc
#EndRegion Bot Functions

#Region Utility Functions
Func FormatTime($seconds)
    Local $hours = Floor($seconds / 3600)
    Local $minutes = Floor(Mod($seconds, 3600) / 60)
    Local $secs = Mod($seconds, 60)
    Return StringFormat("%02d:%02d:%02d", $hours, $minutes, $secs)
EndFunc

Func _LogCallback($a_s_Message, $a_e_MsgType, $a_s_Author)
    Local $l_i_UtilsMsgType
    Switch $a_e_MsgType
        Case $GC_I_LOG_MSGTYPE_DEBUG
            $l_i_UtilsMsgType = $c_UTILS_Msg_Type_Debug
        Case $GC_I_LOG_MSGTYPE_INFO
            $l_i_UtilsMsgType = $c_UTILS_Msg_Type_Info
        Case $GC_I_LOG_MSGTYPE_WARNING
            $l_i_UtilsMsgType = $c_UTILS_Msg_Type_Warning
        Case $GC_I_LOG_MSGTYPE_ERROR
            $l_i_UtilsMsgType = $c_UTILS_Msg_Type_Error
        Case $GC_I_LOG_MSGTYPE_CRITICAL
            $l_i_UtilsMsgType = $c_UTILS_Msg_Type_Critical
        Case Else
            $l_i_UtilsMsgType = $c_UTILS_Msg_Type_Info
    EndSwitch

    _Utils_LogMessage($a_s_Message, $l_i_UtilsMsgType, $a_s_Author)
EndFunc
#EndRegion Utility Functions
