#include-once
#include "ImGui/ImGui.au3"
#include "ImGui/Utils.au3"
#include "_GwAu3.au3"

Global $s_GUI_Script_Name = "ImGui Demo"
Global $s_GUI_Status = "Ready"
Global $b_GUI_CheckBox_GUI_DebugMode = True
Global $b_GUI_BotRunning = False
Global $i_Number_CharName = 1
Global $l_Selected_Char
Global $l_CharName = ScanGW()

_ImGui_EnableViewports()
_ImGui_GUICreate($s_GUI_Script_Name, 100, 100)
_ImGui_StyleGwToolBox()
_ImGui_SetWindowTitleAlign(0.5, 0.5)
_ImGui_EnableDocking()

TraySetToolTip($s_GUI_Script_Name)
AdlibRegister("_GUI_Handle", 30)

Func _GUI_Handle()
    If Not _ImGui_PeekMsg() Then _GUI_ExitApp()
    _ImGui_BeginFrame()

	If Not _ImGui_Begin($s_GUI_Script_Name, True, $ImGuiWindowFlags_AlwaysAutoResize + $ImGuiWindowFlags_MenuBar) Then _GUI_ExitApp()

	_GUI_MenuBar()
	Local $winSize = _ImGui_GetWindowSize()

	If $b_GUI_CheckBox_GUI_DebugMode Then _GUI_AddOns_LogConsole()

	If $b_GUI_BotRunning = False Then
		_ImGui_Text("Select Charname:")
		; begin a child window inside the main window
		_ImGui_BeginChild("##child_list_view2", $winSize*0, $winSize[1] *0.23, True, $ImGuiWindowFlags_ChildWindow)
			For $i = 1 To UBound($l_CharName) - 1
				Local $selected = ($i_Number_CharName == $i) ; if $i_radio_theme = $i then $selected = True
				If _ImGui_Selectable($l_CharName[$i], $selected) Then
					$i_Number_CharName = $i
					$l_Selected_Char = $l_CharName[$i]
				EndIf
			Next
		_ImGui_EndChild()
		If _ImGui_Button("Refresh", -1, 40) Then $l_CharName = ScanGW()
		_ImGui_NewLine()
		If _ImGui_Button("Start", -1, 40) Then
			If initialize($l_Selected_Char, True) = True Then
				$b_GUI_BotRunning = True
				$s_GUI_Status = "Running"
			Else
				$s_GUI_Status = "Fail Running"
			EndIf
		EndIf

	Else

	EndIf

	_ImGui_NewLine()

	Local $text_width = _ImGui_CalcTextSize($s_GUI_Status)[0]
	_ImGui_Dummy((_ImGui_GetWindowWidth() - $text_width) * 0.45, 0)
	_ImGui_SameLine()
	_ImGui_TextColored($s_GUI_Status, 0xFF00FF00)

    _ImGui_EndFrame()
EndFunc

Func _GUI_MenuBar()
	If _ImGui_BeginMenuBar() Then
		If _ImGui_BeginMenu("Menu") Then

			If _ImGui_MenuItem("Debug Mode", "", $b_GUI_CheckBox_GUI_DebugMode) Then $b_GUI_CheckBox_GUI_DebugMode = Not $b_GUI_CheckBox_GUI_DebugMode

			_ImGui_Separator()

			If _ImGui_MenuItem("Exit") Then _GUI_ExitApp()

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

	If _ImGui_Button("Clear Console") Then ReDim $a_UTILS_Log_Messages[0][8]
	_ImGui_SameLine()
	If _ImGui_Button("Copy Console") Then _GUI_CopyConsoleToClipboard()
	_ImGui_Separator()
EndFunc

Func _GUI_CopyConsoleToClipboard()
    Local $sConsoleText = ""
    For $i = 0 To UBound($a_UTILS_Log_Messages) - 1
        Local $sLine = "[" & $a_UTILS_Log_Messages[$i][0] & "] - [" & $a_UTILS_Log_Messages[$i][2] & "] - [" & $a_UTILS_Log_Messages[$i][4] & "] " & $a_UTILS_Log_Messages[$i][6]
        $sConsoleText &= $sLine & @CRLF
    Next
    ClipPut($sConsoleText)
EndFunc

Func _GUI_ExitApp()
    Exit
EndFunc

_Utils_LogMessage("This is a debug msg", $c_UTILS_Msg_Type_Debug, "API")
_Utils_LogMessage("This is a info msg", $c_UTILS_Msg_Type_Info, "Main")
_Utils_LogMessage("This is a warn msg", $c_UTILS_Msg_Type_Warning, "Initialize")
_Utils_LogMessage("This is a error msg", $c_UTILS_Msg_Type_Error, "GetNumber")
_Utils_LogMessage("This is a critical msg", $c_UTILS_Msg_Type_Critical, "Random function name")

While 1
	Sleep(16)
WEnd
