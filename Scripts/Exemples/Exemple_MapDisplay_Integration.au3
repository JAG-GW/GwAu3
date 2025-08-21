#RequireAdmin
#include "../../API/_GwAu3.au3"
#include "../../API/Pathfinding/MapDisplay.au3"

; Simple example showing how to integrate the map display

Global $g_h_MainGUI
Global $g_h_MapControl ; Single handle for the map control
Global $g_h_NameCombo
Global $g_b_BotRunning = False

; Create main GUI
$g_h_MainGUI = GUICreate("Bot with Integrated Map", 800, 600)

; Add controls
GUICtrlCreateLabel("Character:", 10, 10, 60, 20)
$g_h_NameCombo = GUICtrlCreateCombo($g_s_MainCharName, 70, 8, 150, 22, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, Scanner_GetLoggedCharNames())
$g_h_StartButton = GUICtrlCreateButton("Start Bot", 230, 8, 80, 24)

; Add status area
$g_h_StatusEdit = GUICtrlCreateEdit("", 10, 40, 380, 250, BitOR($ES_AUTOVSCROLL, $ES_READONLY))

; ============================================================================
; ADD THE MAP DISPLAY WITH CONTROLS
; ============================================================================
; DisplayMap returns the map control handle and creates buttons internally
$g_h_MapControl = DisplayMap($g_h_MainGUI, 400, 40, 380, 380, True)

; Additional bot controls
GUICtrlCreateLabel("Path waypoints:", 10, 300, 100, 20)
$g_h_PathList = GUICtrlCreateList("", 10, 320, 380, 200)

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)

; Main loop
While 1
    $l_i_Msg = GUIGetMsg()

    Switch $l_i_Msg
        Case $GUI_EVENT_CLOSE
            ExitLoop

        Case $g_h_StartButton
            StartBot()

    EndSwitch
WEnd

; Cleanup
MapDisplay_Cleanup()
GUIDelete()

; ============================================================================
; Bot Functions
; ============================================================================

Func StartBot()
    Local $l_s_CharName = GUICtrlRead($g_h_NameCombo)

    If $l_s_CharName = "" Then
        AddStatus("Please enter character name")
        Return
    EndIf

    ; Initialize bot
    If Core_Initialize($l_s_CharName, True) = 0 Then
        AddStatus("Failed to initialize bot")
        Return
    EndIf

    $g_b_BotRunning = True
    GUICtrlSetData($g_h_StartButton, "Stop Bot")

    AddStatus("Bot started for: " & player_GetCharname())
EndFunc

Func AddStatus($a_s_Text)
    GUICtrlSetData($g_h_StatusEdit, @HOUR & ":" & @MIN & ":" & @SEC & " - " & $a_s_Text & @CRLF, 1)
EndFunc

; ============================================================================
; Example: Display path on map
; ============================================================================
Func ShowPathOnMap($a_af2_Path)
    If Not IsArray($a_af2_Path) Then Return

    ; Display path on map
    MapDisplay_SetPath($a_af2_Path)

    ; Also show in list
    GUICtrlSetData($g_h_PathList, "")
    For $i = 0 To UBound($a_af2_Path) - 1
        GUICtrlSetData($g_h_PathList, "Point " & $i & ": " & Round($a_af2_Path[$i][0]) & ", " & Round($a_af2_Path[$i][1]))
    Next
EndFunc

Func _Exit()
    Exit
EndFunc