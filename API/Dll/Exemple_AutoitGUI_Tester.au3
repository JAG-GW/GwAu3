#RequireAdmin
#include "../_GwAu3.au3"
#include "GWRPCClient.au3"
#include "GWRPCFunc.au3"

Global Const $doLoadLoggedChars = True
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)

#Region Declarations
Global $ProcessID = ""
Global $timer = TimerInit()

Global $BotRunning = False
Global $Bot_Core_Initialized = False
Global Const $BotTitle = "Tester"

$g_bAutoStart = False  ; Flag for auto-start
$g_s_MainCharName  = ""
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
$MainGui = GUICreate($BotTitle, 500, 350, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xEAEAEA, $MainGui)
$Group1 = GUICtrlCreateGroup("Select Your Character", 8, 8, 475, 325)
Global $GUINameCombo
If $doLoadLoggedChars Then
    $GUINameCombo = GUICtrlCreateCombo($g_s_MainCharName, 24, 32, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, Scanner_GetLoggedCharNames())
Else
    $GUINameCombo = GUICtrlCreateInput($g_s_MainCharName, 24, 32, 145, 25)
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

Func StartBot()
    Local $g_s_MainCharName = GUICtrlRead($GUINameCombo)
;~     If $g_s_MainCharName == "" Then
;~         If Core_Initialize(ProcessExists("gw.exe"), True) = 0 Then
;~             MsgBox(0, "Error", "Guild Wars is not running.")
;~             _Exit()
;~         EndIf
;~     ElseIf $ProcessID Then
;~         $proc_id_int = Number($ProcessID, 2)
;~         If Core_Initialize($proc_id_int, True) = 0 Then
;~             MsgBox(0, "Error", "Could not Find a ProcessID or somewhat '"&$proc_id_int&"'  "&VarGetType($proc_id_int)&"'")
;~             _Exit()
;~             If ProcessExists($proc_id_int) Then
;~                 ProcessClose($proc_id_int)
;~             EndIf
;~             Exit
;~         EndIf
;~     Else
;~         If Core_Initialize($g_s_MainCharName, True) = 0 Then
;~             MsgBox(0, "Error", "Could not Find a Guild Wars client with a Character named '"&$g_s_MainCharName&"'")
;~             _Exit()
;~         EndIf
;~     EndIf
    If IsString($g_s_MainCharName) Then
        Local $l_h_ProcessList = ProcessList("gw.exe")
        For $i = 1 To $l_h_ProcessList[0][0]
            $g_i_GWProcessId = $l_h_ProcessList[$i][1]
            $g_h_GWWindow = Scanner_GetHwnd($g_i_GWProcessId)
            Memory_Open($g_i_GWProcessId)
            If $g_h_GWProcess Then
                If StringRegExp(Scanner_ScanForCharname(), $g_s_MainCharName) = 1 Then
                    ExitLoop
                EndIf
            EndIf
            Memory_Close()
            $g_h_GWProcess = 0
        Next
    Else
        $g_i_GWProcessId = $g_s_MainCharName
        $g_h_GWWindow = Scanner_GetHwnd($g_i_GWProcessId)
        Memory_Open($g_s_MainCharName)
        Scanner_ScanForCharname()
    EndIf

    GUICtrlSetState($GUIStartButton, $GUI_Disable)
    GUICtrlSetState($GUIRefreshButton, $GUI_Disable)
    GUICtrlSetState($GUINameCombo, $GUI_DISABLE)
    WinSetTitle($MainGui, "", player_GetCharname() & " - Bot for test")
    $BotRunning = True
    $Bot_Core_Initialized = True
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

        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
EndFunc

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

While $BotRunning
    Sleep(500)
	Test()
    Sleep(500000)
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

Func Test()
    Out("===== RPC Client Test Suite =====")

    ; Initialize with debug mode
    If Not RPCClient_Init("\\.\pipe\GwAu3Server", True) Then
        Out("[ERROR] Failed to initialize RPC client")
        Return
    EndIf

    Sleep(500)

    Out("--- Test 1: RPCScanner_Find ---")
    Local $AgentArrayPtr = RPCScanner_Find("8B 0C 90 85 C9 74 19", "xxxxxxx", -0x4, $SECTION_TEXT)
    Out("Result: 0x" & Hex($AgentArrayPtr))
    If $AgentArrayPtr Then
        Out("Memory Read: " & Ptr(Memory_Read($AgentArrayPtr)))
    EndIf

    Out("--- Test 2: RPCScanner_FindAssertion ---")
    Local $PreGameContext = RPCScanner_FindAssertion("UiPregame.cpp", "!s_scene", 0, 0x34)
    Out("Result: 0x" & Hex($PreGameContext))
    If $PreGameContext Then
        Out("Memory Read:" & Ptr(Memory_Read($PreGameContext)))
    EndIf

    Out("--- Test 3: RPCScanner_FindInRange ---")
    Local $FriendList = RPCScanner_FindAssertion("FriendApi.cpp", "friendName && *friendName", 0, 0)
    If $FriendList Then
        $FriendList = RPCScanner_FindInRange("57 B9", "xx", 2, $FriendList, $FriendList + 0xFF)
        Out("Result: 0x" & Hex($FriendList))
        If $FriendList Then
            Out("Memory Read:" & Ptr(Memory_Read($FriendList)))
        EndIf
    Else
        Out("FindAssertion failed, skipping FindInRange")
    EndIf

    Out("--- Test 4: RPCScanner_ToFunctionStart Pattern ---")
    ; First find the pattern
    Local $pattern_addr = RPCScanner_Find("83 FE 03 77 40 FF 24 B5 00 00 00 00 33 C0", "xxxxxxxx????xx")
    Out("Pattern found at: 0x" & Hex($pattern_addr))
    If $pattern_addr Then
        Local $SetOnlineStatus_Func = RPCScanner_ToFunctionStart($pattern_addr)
        Out("Function start: 0x" & Hex($SetOnlineStatus_Func))
        If $SetOnlineStatus_Func Then
            Out("Memory Read:" & Ptr(Memory_Read($SetOnlineStatus_Func)))
        EndIf
    Else
        Out("Pattern not found, cannot find function start")
    EndIf

    Out("--- Test 5: RPCScanner_ToFunctionStart Assertion ---")
    Local $assertion_addr = RPCScanner_FindAssertion("AvSelect.cpp", "!(autoAgentId && !ManagerFindAgent(autoAgentId))", 0, 0)
    Out("Assertion found at: 0x" & Hex($assertion_addr))
    If $assertion_addr Then
        Local $ChangeTarget_Func = RPCScanner_ToFunctionStart($assertion_addr)
        Out("Function start: 0x" & Hex($ChangeTarget_Func))
    Else
        Out("Assertion not found, cannot find function start")
    EndIf

    Out("--- Test 6: RPCScanner_FunctionFromNearCall Pattern ---")
    ; Find the pattern with correct offset to get CALL instruction
    Local $call_addr = RPCScanner_Find("83 c4 0c 85 ff 74 0b 56 6a 03", "xxxxxxxxxx", -0x5)
    Out("Call instruction at: 0x" & Hex($call_addr))
    If $call_addr Then
        Local $MoveTo_Func = RPCScanner_FunctionFromNearCall($call_addr)
    Else
        Out("Pattern not found, cannot find function from call")
    EndIf

    Out("--- Test 7: RPCScanner_FunctionFromNearCall Assertion ---")
    Local $weapon_assertion = RPCScanner_FindAssertion("GmWeaponBar.cpp", "slotIndex < ITEM_PLAYER_EQUIP_SETS", 0,0x128)
    Out("Assertion found at: 0x" & Hex($weapon_assertion))
    If $weapon_assertion Then
        Local $PingWeaponSet_Func = RPCScanner_FunctionFromNearCall($weapon_assertion)
        Out("Function address: 0x" & Hex($PingWeaponSet_Func))
        If $PingWeaponSet_Func Then
            Out("Memory Read:" & Ptr(Memory_Read($PingWeaponSet_Func)))
        EndIf
    Else
        Out("Assertion not found, cannot find function from call")
    EndIf

    Out("===== All Tests Complete =====")

    RPCClient_Close()
EndFunc
