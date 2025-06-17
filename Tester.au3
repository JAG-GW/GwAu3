#RequireAdmin
#include "_GwAu3.au3"

Global Const $doLoadLoggedChars = True
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)

#Region Declarations
Global $charName  = ""
Global $ProcessID = ""
Global $timer = TimerInit()

Global $BotRunning = False
Global $Bot_Core_Initialized = False
Global Const $BotTitle = "Tester"
#EndRegion Declaration

#Region ### START Koda GUI section ### Form=
$MainGui = GUICreate($BotTitle, 500, 350, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xEAEAEA, $MainGui)
$Group1 = GUICtrlCreateGroup("Select Your Character", 8, 8, 475, 325)
Global $GUINameCombo
If $doLoadLoggedChars Then
    $GUINameCombo = GUICtrlCreateCombo($charName, 24, 32, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, GwAu3_Scanner_GetLoggedCharNames())
Else
    $GUINameCombo = GUICtrlCreateInput("Character name", 24, 32, 145, 25)
EndIf
$gOnTopCheckbox = GUICtrlCreateCheckbox("On Top", 200, 31, 60, 24)
GUICtrlSetState($gOnTopCheckbox, $GUI_CHECKED)
GUICtrlSetOnEvent($gOnTopCheckbox, "GuiButtonHandler")
$gDebugCheckbox = GUICtrlCreateCheckbox("Debug Mode", 260, 31, 80, 24)
GUICtrlSetState($gDebugCheckbox, $GUI_CHECKED)
GUICtrlSetOnEvent($gDebugCheckbox, "GuiButtonHandler")
$GUIStartButton = GUICtrlCreateButton("Start", 24, 72, 75, 25)
GUICtrlSetOnEvent($GUIStartButton, "GuiButtonHandler")
$GUIRefreshButton = GUICtrlCreateButton("Refresh", 110, 72, 75, 25)
GUICtrlSetOnEvent($GUIRefreshButton, "GuiButtonHandler")
$g_h_EditText = _GUICtrlRichEdit_Create($MainGui, "", 16, 104, 458, 222, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
_GUICtrlRichEdit_SetBkColor($g_h_EditText, $COLOR_WHITE) ; Couleur de fond

GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func GuiButtonHandler()
    Switch @GUI_CtrlId
		Case $GUIStartButton
            Local $charName = GUICtrlRead($GUINameCombo)
            If $charName=="" Then
                If GwAu3_Core_Initialize(ProcessExists("gw.exe"), True) = 0 Then
                    MsgBox(0, "Error", "Guild Wars is not running.")
                    _Exit()
                EndIf
            ElseIf $ProcessID Then
                $proc_id_int = Number($ProcessID, 2)
                If GwAu3_Core_Initialize($proc_id_int, True) = 0 Then
                    MsgBox(0, "Error", "Could not Find a ProcessID or somewhat '"&$proc_id_int&"'  "&VarGetType($proc_id_int)&"'")
                    _Exit()
                    If ProcessExists($proc_id_int) Then
                        ProcessClose($proc_id_int)
                    EndIf
                    Exit
                EndIf
            Else
                If GwAu3_Core_Initialize($CharName, True) = 0 Then
                    MsgBox(0, "Error", "Could not Find a Guild Wars client with a Character named '"&$CharName&"'")
                    _Exit()
                EndIf
            EndIf
            GUICtrlSetState($GUIStartButton, $GUI_Disable)
			GUICtrlSetState($GUIRefreshButton, $GUI_Disable)
            GUICtrlSetState($GUINameCombo, $GUI_DISABLE)
            WinSetTitle($MainGui, "", GwAu3_OtherMod_GetCharname() & " - Bot for test")
            $BotRunning = True
            $Bot_Core_Initialized = True

        Case $GUIRefreshButton
            GUICtrlSetData($GUINameCombo, "")
            GUICtrlSetData($GUINameCombo, GwAu3_Scanner_GetLoggedCharNames())

        Case $gOnTopCheckbox
            If GetChecked($gOnTopCheckbox) Then
                WinSetOnTop($BotTitle, "", 1)
            Else
                WinSetOnTop($BotTitle, "", 0)
            EndIf

		Case $gDebugCheckbox
            If GetChecked($gDebugCheckbox) Then
                GwAu3_Log_SetDebugMode(True)
            Else
                GwAu3_Log_SetDebugMode(False)
            EndIf

        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
EndFunc

Out("Based on GWA2")
Out("GWA2 - Created by: " & $GC_S_GWA2_CREATOR)
Out("GWA2 - Build date: " & $GC_S_GWA2_BUILD_DATE & @CRLF)

Out("GwAu3 - Created by: " & $GC_S_GWAU3_UPDATOR)
Out("GwAu3 - Build date: " & $GC_S_GWAU3_BUILD_DATE)
Out("GwAu3 - Version: " & $GC_S_GWAU3_VERSION)
Out("GwAu3 - Last Update: " & $GC_S_GWAU3_LAST_UPDATE & @CRLF)

While Not $BotRunning
    Sleep(100)
WEnd

While $BotRunning
    Sleep(500)
	Out("Ready")

	Out("Done")
    Sleep(500)
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
		Return  True;$GUI_Checked
	Else
		Return False;$GUI_UNCHECKED
	EndIf
EndFunc

Func _Exit()
    Exit
EndFunc
