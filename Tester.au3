#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <AVIConstants.au3>
#include <GUIListBox.au3>
#include <GuiListView.au3>
#include <GuiComboBox.au3>
#include <ScrollBarsConstants.au3>
#include <Array.au3>
#Include <WinAPIEx.au3>
#include <GuiEdit.au3>
#include <WinAPIFiles.au3>
#include <GuiSlider.au3>
#include <ColorConstants.au3>
#include <WinAPITheme.au3> ; <<<<<<<<<<<<<<<<<<
#include <WinAPIDiag.au3>
#include "_GwAu3.au3"

Global Const $doLoadLoggedChars = True
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)

GUIRegisterMsg(0x501, "OnPacket")

Opt("ExpandVarStrings", 1)

#Region Declarations
Global $charName  = ""
Global $ProcessID = ""
Global $timer = TimerInit()

Global $BotRunning = False
Global $BotInitialized = False
Global Const $BotTitle = "Tester"
#EndRegion Declaration

#Region ### START Koda GUI section ### Form=
$MainGui = GUICreate($BotTitle, 336, 285, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xEAEAEA, $MainGui)
$Group1 = GUICtrlCreateGroup("Select Your Character", 8, 8, 313, 265)
Global $GUINameCombo
If $doLoadLoggedChars Then
    $GUINameCombo = GUICtrlCreateCombo($charName, 24, 32, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, GetLoggedCharNames())
Else
    $GUINameCombo = GUICtrlCreateInput("Character name", 24, 32, 145, 25)
EndIf
$GUIRefreshButton = GUICtrlCreateButton("Refresh", 176, 34, 51, 17)
GUICtrlSetOnEvent($GUIRefreshButton, "GuiButtonHandler")
$GUIStartButton = GUICtrlCreateButton("Start", 24, 72, 75, 25)
GUICtrlSetOnEvent($GUIStartButton, "GuiButtonHandler")
$gOnTopCheckbox = GUICtrlCreateCheckbox("On Top", 232, 31, 81, 24)
GUICtrlSetState(-1, $GUI_CHECKED)
$GUIActionsEdit = GUICtrlCreateEdit("", 16, 104, 297, 161)
GUICtrlSetData(-1, "")
GUICtrlSetColor(-1, 0x99B2FF)
GUICtrlSetBkColor(-1, 0x23272A)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func GuiButtonHandler()
    Switch @GUI_CtrlId
        Case $GUIStartButton
            Out("Initializing")
            Local $charName = GUICtrlRead($GUINameCombo)
            If $charName=="" Then
                If Initialize(ProcessExists("gw.exe"), True, False, False) = 0 Then
                    MsgBox(0, "Error", "Guild Wars is not running.")
                    _Exit()
                EndIf
            ElseIf $ProcessID Then
                $proc_id_int = Number($ProcessID, 2)
                If Initialize($proc_id_int, True, False, False) = 0 Then
                    MsgBox(0, "Error", "Could not Find a ProcessID or somewhat '"&$proc_id_int&"'  "&VarGetType($proc_id_int)&"'")
                    _Exit()
                    If ProcessExists($proc_id_int) Then
                        ProcessClose($proc_id_int)
                    EndIf
                    Exit
                EndIf
            Else
                If Initialize($CharName, True, False, False) = 0 Then
                    MsgBox(0, "Error", "Could not Find a Guild Wars client with a Character named '"&$CharName&"'")
                    _Exit()
                EndIf
            EndIf
            GUICtrlSetState($GUIStartButton, $GUI_Disable)
			GUICtrlSetState($GUIRefreshButton, $GUI_Disable)
            GUICtrlSetState($GUINameCombo, $GUI_Disable)
            WinSetTitle($MainGui, "", GetCharname() & " - Bot for test")
            $BotRunning = True
            $BotInitialized = True

        Case $GUIRefreshButton
            GUICtrlSetData($GUINameCombo, "")
            GUICtrlSetData($GUINameCombo, GetLoggedCharNames())

        Case $gOnTopCheckbox
            If GetChecked($gOnTopCheckbox) Then
                WinSetOnTop($BotTitle, "", 1)
            Else
                WinSetOnTop($BotTitle, "", 0)
            EndIf

        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
EndFunc

While Not $BotRunning
    Sleep(100)
WEnd

While $BotRunning
	Sleep(500)

	Sleep(5000)
WEnd

Func Out($TEXT)
    Local $TIME = "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] - "
    Local $TEXTLEN = StringLen($TEXT)
    Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GUIActionsEdit)
    If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GUIActionsEdit, StringRight(_GUICtrlEdit_GetText($GUIActionsEdit), 30000 - $TEXTLEN - 1000))
    _GUICtrlEdit_AppendText($GUIActionsEdit, @CRLF & $TIME & $TEXT)
    _GUICtrlEdit_Scroll($GUIActionsEdit, 1)
EndFunc

Func _Exit()
    Exit
EndFunc
