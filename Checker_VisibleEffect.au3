#RequireAdmin
#include "GwAu3/_GwAu3.au3"

Global Const $doLoadLoggedChars = True
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)

#Region Declarations
Global $g_s_MainCharName  = ""
Global $ProcessID = ""
Global $BotRunning = False
Global $Bot_Core_Initialized = False
Global Const $BotTitle = "TList VisibleEffects Tester"
Global $g_bAutoStart = False  ; Flag for auto-start

; Extended effects dictionary
Global $g_EffectNames[1000][3] ; [ID][Name][Type]
InitializeEffectDictionary()

Global $g_i_LastEffectCount = -1
Global $g_a_LastEffects[1] = [0]
Global $g_i_TotalScans = 0
Global $g_i_TotalEffectsDetected = 0
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
$MainGui = GUICreate($BotTitle, 900, 700, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xF5F5F5, $MainGui)

; Header with simulated gradient
GUICtrlCreateLabel("", 0, 0, 900, 50)
GUICtrlSetBkColor(-1, 0x2C3E50)
GUICtrlCreateLabel("TList VisibleEffects Monitor", 20, 10, 500, 30, 0x0200)
GUICtrlSetFont(-1, 16, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x2C3E50)

GUICtrlCreateLabel("C++ Structure Implementation", 20, 35, 300, 15)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xBDC3C7)
GUICtrlSetBkColor(-1, 0x2C3E50)

; Control panel
$groupControl = GUICtrlCreateGroup("Control Panel", 10, 60, 430, 150)
GUICtrlSetFont(-1, 9, 600)

$lblChar = GUICtrlCreateLabel("Character:", 25, 85, 60, 20)
Global $GUINameCombo
If $doLoadLoggedChars Then
    $GUINameCombo = GUICtrlCreateCombo($g_s_MainCharName, 90, 82, 200, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, Scanner_GetLoggedCharNames())
Else
    $GUINameCombo = GUICtrlCreateInput($g_s_MainCharName, 90, 82, 200, 25)
EndIf

$GUIStartButton = GUICtrlCreateButton("Initialize", 25, 115, 110, 35, 0x0001)
GUICtrlSetOnEvent($GUIStartButton, "GuiButtonHandler")
GUICtrlSetFont($GUIStartButton, 10, 600)

$GUIRefreshButton = GUICtrlCreateButton("Refresh", 145, 115, 80, 35)
GUICtrlSetOnEvent($GUIRefreshButton, "GuiButtonHandler")

; Monitoring options
$gAutoMonitorCheckbox = GUICtrlCreateCheckbox("Auto Monitor", 25, 160, 100, 24)
GUICtrlSetOnEvent($gAutoMonitorCheckbox, "GuiButtonHandler")

$lblInterval = GUICtrlCreateLabel("Interval:", 135, 163, 50, 20)
$inputInterval = GUICtrlCreateInput("250", 185, 160, 50, 24, 0x2000)

$gIteratorModeCheckbox = GUICtrlCreateCheckbox("Use Iterator", 250, 160, 90, 24)
GUICtrlSetState($gIteratorModeCheckbox, $GUI_CHECKED)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Statistics panel
$groupStats = GUICtrlCreateGroup("Real-Time Statistics", 450, 60, 440, 150)
GUICtrlSetFont(-1, 9, 600)

; Main effects display
$lblMainEffectCount = GUICtrlCreateLabel("0", 470, 85, 100, 60, 0x01)
GUICtrlSetFont($lblMainEffectCount, 36, 800, 0, "Segoe UI")
GUICtrlSetColor($lblMainEffectCount, 0x27AE60)

$lblEffectLabel = GUICtrlCreateLabel("Active Effects", 470, 145, 100, 20)
GUICtrlSetFont($lblEffectLabel, 10, 400)
GUICtrlSetColor($lblEffectLabel, 0x7F8C8D)

; Detailed stats
$lblTotalScans = GUICtrlCreateLabel("Total Scans: 0", 590, 90, 120, 20)
$lblTotalDetected = GUICtrlCreateLabel("Total Detected: 0", 590, 110, 120, 20)
$lblLastUpdate = GUICtrlCreateLabel("Last Update: Never", 590, 130, 120, 20)
$lblUniqueEffects = GUICtrlCreateLabel("Unique Effects: 0", 590, 150, 120, 20)

; Visual indicators
$lblStatusIndicator = GUICtrlCreateLabel("●", 720, 90, 20, 20)
GUICtrlSetFont($lblStatusIndicator, 16)
GUICtrlSetColor($lblStatusIndicator, 0x95A5A6)

$lblActivityIndicator = GUICtrlCreateLabel("Idle", 740, 93, 100, 20)
GUICtrlSetFont($lblActivityIndicator, 9, 400)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Quick actions panel
$groupActions = GUICtrlCreateGroup("Quick Actions", 10, 220, 880, 60)
GUICtrlSetFont(-1, 9, 600)

$GUITestSelfButton = GUICtrlCreateButton("🧍 Test Self", 25, 245, 100, 25)
GUICtrlSetOnEvent($GUITestSelfButton, "GuiButtonHandler")

$GUITestTargetButton = GUICtrlCreateButton("🎯 Test Target", 135, 245, 100, 25)
GUICtrlSetOnEvent($GUITestTargetButton, "GuiButtonHandler")

$GUITestPartyButton = GUICtrlCreateButton("👥 Test Party", 245, 245, 100, 25)
GUICtrlSetOnEvent($GUITestPartyButton, "GuiButtonHandler")

$GUITestNearbyButton = GUICtrlCreateButton("📍 Test Nearby", 355, 245, 100, 25)
GUICtrlSetOnEvent($GUITestNearbyButton, "GuiButtonHandler")

$GUIDebugTListButton = GUICtrlCreateButton("🔧 Debug TList", 475, 245, 100, 25)
GUICtrlSetOnEvent($GUIDebugTListButton, "GuiButtonHandler")

$GUIExportButton = GUICtrlCreateButton("📄 Export", 585, 245, 80, 25)
GUICtrlSetOnEvent($GUIExportButton, "GuiButtonHandler")

$GUIClearButton = GUICtrlCreateButton("🗑️ Clear", 675, 245, 80, 25)
GUICtrlSetOnEvent($GUIClearButton, "GuiButtonHandler")

$GUIAnalyzeButton = GUICtrlCreateButton("📊 Analyze", 765, 245, 100, 25)
GUICtrlSetOnEvent($GUIAnalyzeButton, "GuiButtonHandler")

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Log area with simulated tabs
$lblLogTitle = GUICtrlCreateLabel("Event Log", 10, 290, 100, 20)
GUICtrlSetFont($lblLogTitle, 10, 600)

$lblLogFilter = GUICtrlCreateLabel("Filter: ", 780, 290, 40, 20)
$comboLogFilter = GUICtrlCreateCombo("All", 820, 287, 70, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData($comboLogFilter, "Info|Debug|Warning|Error")

$g_h_EditText = _GUICtrlRichEdit_Create($MainGui, "", 10, 310, 880, 380, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
_GUICtrlRichEdit_SetBkColor($g_h_EditText, 0xFFFFFF)
_GUICtrlRichEdit_SetFont($g_h_EditText, 9, "Consolas")

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Global variables
Global $g_b_AutoMonitor = False
Global $g_i_LastCheckTime = 0
Global $g_i_MonitorInterval = 250
Global $g_a_UniqueEffects[1000]
Global $g_i_UniqueCount = 0

Func StartBot()
    Local $g_s_MainCharName = GUICtrlRead($GUINameCombo)
    If $g_s_MainCharName=="" Then
        If Core_Initialize(ProcessExists("gw.exe"), True) = 0 Then
            MsgBox(0, "Error", "Guild Wars is not running.")
            _Exit()
        EndIf
    Else
        If Core_Initialize($g_s_MainCharName, True) = 0 Then
            MsgBox(0, "Error", "Could not find character: '"&$g_s_MainCharName&"'")
            _Exit()
        EndIf
    EndIf

    GUICtrlSetState($GUIStartButton, $GUI_Disable)
    GUICtrlSetState($GUINameCombo, $GUI_DISABLE)
    WinSetTitle($MainGui, "", player_GetCharname() & " - TList Monitor")
    $BotRunning = True
    $Bot_Core_Initialized = True

    GUICtrlSetColor($lblStatusIndicator, 0x27AE60)
    GUICtrlSetData($lblActivityIndicator, "Active")

    Out("╔══════════════════════════════════════╗", 0x3498DB)
    Out("   TList VisibleEffects Monitor", 0x3498DB)
    Out("╚══════════════════════════════════════╝", 0x3498DB)
    Out("Character: " & player_GetCharname(), 0x27AE60)
    Out("Implementation: C++ TList/TLink structure", 0x95A5A6)
    Out("Ready to monitor effects!", 0x27AE60)
EndFunc

Func GuiButtonHandler()
    Switch @GUI_CtrlId
		Case $GUIStartButton
            StartBot()

        Case $GUIRefreshButton
            GUICtrlSetData($GUINameCombo, "")
            GUICtrlSetData($GUINameCombo, Scanner_GetLoggedCharNames())

        Case $gAutoMonitorCheckbox
            $g_b_AutoMonitor = GetChecked($gAutoMonitorCheckbox)
            $g_i_MonitorInterval = Number(GUICtrlRead($inputInterval))
            If $g_i_MonitorInterval < 50 Then $g_i_MonitorInterval = 50

            If $g_b_AutoMonitor Then
                Out("▶ Auto-monitor enabled (" & $g_i_MonitorInterval & "ms)", 0x27AE60)
                GUICtrlSetColor($lblActivityIndicator, 0xF39C12)
                GUICtrlSetData($lblActivityIndicator, "Monitoring")
            Else
                Out("⏸ Auto-monitor disabled", 0xE74C3C)
                GUICtrlSetColor($lblActivityIndicator, 0x27AE60)
                GUICtrlSetData($lblActivityIndicator, "Active")
            EndIf

        Case $GUITestSelfButton
            If $Bot_Core_Initialized Then TestEffectsDetailed(-2, "Self")

        Case $GUITestTargetButton
            If $Bot_Core_Initialized Then
                Local $target = Agent_GetCurrentTarget()
                If $target > 0 Then
                    TestEffectsDetailed($target, "Target")
                Else
                    Out("❌ No target selected!", 0xE74C3C)
                EndIf
            EndIf

        Case $GUITestPartyButton
            If $Bot_Core_Initialized Then TestPartyEffects()

        Case $GUITestNearbyButton
            If $Bot_Core_Initialized Then TestNearbyAgents()

        Case $GUIDebugTListButton
            If $Bot_Core_Initialized Then DebugTListStructure()

        Case $GUIAnalyzeButton
            If $Bot_Core_Initialized Then AnalyzeEffects()

        Case $GUIExportButton
            ExportLog()

        Case $GUIClearButton
            _GUICtrlRichEdit_SetText($g_h_EditText, "")
            Out("Log cleared", 0x95A5A6)

        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
EndFunc

Out("TList VisibleEffects Tester", 0x3498DB)
Out("Ready to initialize...", 0x95A5A6)
Core_AutoStart()

While Not $BotRunning
    Sleep(100)
WEnd

; Main loop
While $BotRunning
    If $g_b_AutoMonitor And (TimerDiff($g_i_LastCheckTime) > $g_i_MonitorInterval) Then
        MonitorEffects()
        $g_i_LastCheckTime = TimerInit()
    EndIf
    Sleep(25)
WEnd

; Automatic monitoring
Func MonitorEffects()
    $g_i_TotalScans += 1

    ; Choose method based on mode
    Local $count = 0
    If GetChecked($gIteratorModeCheckbox) Then
        $count = VisibleEffect_Count(-2)
    Else
        $count = Agent_CountVisibleEffectsSimple(-2)
    EndIf

    ; Update main display
    GUICtrlSetData($lblMainEffectCount, $count)
    If $count = 0 Then
        GUICtrlSetColor($lblMainEffectCount, 0x95A5A6)
    ElseIf $count <= 3 Then
        GUICtrlSetColor($lblMainEffectCount, 0x27AE60)
    ElseIf $count <= 6 Then
        GUICtrlSetColor($lblMainEffectCount, 0xF39C12)
    Else
        GUICtrlSetColor($lblMainEffectCount, 0xE74C3C)
    EndIf

    ; Update stats
    GUICtrlSetData($lblTotalScans, "Total Scans: " & $g_i_TotalScans)
    GUICtrlSetData($lblLastUpdate, "Last Update: " & @HOUR & ":" & @MIN & ":" & @SEC)

    ; If change detected
    If $count <> $g_i_LastEffectCount Then
        $g_i_LastEffectCount = $count

        If $count > 0 Then
            $g_i_TotalEffectsDetected += $count

            ; Get details
            Local $effects = VisibleEffect_GetAll(-2)

            ; Build message
            Local $msg = "📊 Effects changed! Count: " & $count & " ["
            For $i = 1 To $effects[0][0]
                If $i > 1 Then $msg &= ", "

                Local $effectType = ""
                Switch $effects[$i][1] ; unk
                    Case 1
                        $effectType = "E"
                    Case 9
                        $effectType = "W"
                EndSwitch

                $msg &= $effects[$i][2] ; id
                If $effectType <> "" Then $msg &= "(" & $effectType & ")"

                ; Add to unique
                AddUniqueEffect($effects[$i][2])
            Next
            $msg &= "]"

            Out($msg, 0x3498DB)
        Else
            Out("✓ All effects cleared", 0x95A5A6)
        EndIf

    EndIf

    GUICtrlSetData($lblTotalDetected, "Total Detected: " & $g_i_TotalEffectsDetected)
    GUICtrlSetData($lblUniqueEffects, "Unique Effects: " & $g_i_UniqueCount)
EndFunc

; Detailed test with TList structure
Func TestEffectsDetailed($agentID, $agentName)
    Out("╔═══════════════════════════════════╗", 0x3498DB)
    Out("   Testing: " & StringFormat("%-28s", $agentName), 0x3498DB)
    Out("╚═══════════════════════════════════╝", 0x3498DB)

    ; Test with iterator
    Local $countIterator = VisibleEffect_Count($agentID)
    Out("Iterator Count: " & $countIterator, 0x27AE60)

    If $countIterator = 0 Then
        Out("No visible effects detected", 0x95A5A6)
        Return
    EndIf

    ; Get all effects with details
    Local $effects = VisibleEffect_GetAll($agentID)
    Out("Effects found: " & $effects[0][0], 0x27AE60)

    For $i = 1 To $effects[0][0]
        Out(@CRLF & "Effect #" & $i & ":", 0xF39C12)
        Out("  Address: 0x" & Hex($effects[$i][0], 8), 0x95A5A6)
        Out("  Type (unk): " & $effects[$i][1] & " " & GetEffectType($effects[$i][1]), 0x3498DB)
        Out("  ID: " & $effects[$i][2] & " " & GetEffectName($effects[$i][2]), 0x3498DB)
        Out("  Has Ended: " & $effects[$i][3] & ($effects[$i][3] ? " ⚠️" : " ✓"), 0x3498DB)
    Next

    ; Search test
    If $effects[0][0] > 0 Then
        Local $testID = $effects[1][2]
        Local $found = VisibleEffect_FindByID($agentID, $testID)
        Out(@CRLF & "Search test for ID " & $testID & ": " & ($found[0] ? "Found ✓" : "Not found ✗"), 0xE91E63)
    EndIf
EndFunc

; Debug TList structure
Func DebugTListStructure()
    Out("╔═══════════════════════════════════════╗", 0xE91E63)
    Out("   TList Structure Debug", 0xE91E63)
    Out("╚═══════════════════════════════════════╝", 0xE91E63)

    Local $agentPtr = Agent_GetAgentPtr(-2)
    Out("Agent Pointer: 0x" & Hex($agentPtr, 8), 0x95A5A6)

    ; TList at 0x170
    Local $tlistPtr = $agentPtr + 0x170
    Out(@CRLF & "TList at 0x170:", 0xF39C12)
    Out("  offset: " & Memory_Read($tlistPtr, "dword"), 0x95A5A6)

    ; Sentinel at 0x174
    Local $sentinel = $tlistPtr + 0x4
    Out(@CRLF & "Sentinel TLink at 0x174:", 0xF39C12)
    Local $prevLink = Memory_Read($sentinel, "ptr")
    Local $nextNode = Memory_Read($sentinel + 0x4, "ptr")
    Out("  prev_link: 0x" & Hex($prevLink, 8), 0x95A5A6)
    Out("  next_node: 0x" & Hex($nextNode, 8), 0x95A5A6)
    Out("  next_node (cleaned): 0x" & Hex(BitAND($nextNode, 0xFFFFFFFE), 8), 0x95A5A6)

    ; Check if linked
    Local $isLinked = Utils_TLink_IsLinked($sentinel)
    Out("  IsLinked: " & ($isLinked ? "Yes" : "No"), 0x3498DB)

    ; Traverse with iterator
    Out(@CRLF & "Iterator traversal:", 0xF39C12)
    Local $iterator = Utils_TList_CreateIterator($tlistPtr)
    Local $current = Utils_TList_Iterator_Current($iterator)
    Local $index = 0

    While $current <> 0 And $index < 10
        $index += 1
        Out("  [" & $index & "] Effect at 0x" & Hex($current, 8), 0x27AE60)

        If Not Utils_TList_Iterator_Next($iterator) Then ExitLoop
        $current = Utils_TList_Iterator_Current($iterator)
    WEnd

    If $index = 0 Then
        Out("  List is empty", 0x95A5A6)
    EndIf
EndFunc

; Test party effects
Func TestPartyEffects()
    Out(@CRLF & "👥 Party Effects Scan", 0x9B59B6)

    For $i = 1 To 8
        Local $partyID = Party_GetPartyMemberID($i)
        If $partyID <= 0 Then ContinueLoop

        Local $count = VisibleEffect_Count($partyID)
        If $count > 0 Then
            Out("Member " & $i & ": " & $count & " effect(s)", 0x3498DB)

            Local $effects = VisibleEffect_GetAll($partyID)
            For $j = 1 To Min($effects[0][0], 3)
                Out("  - " & GetEffectFullName($effects[$j][2], $effects[$j][1]), 0x95A5A6)
            Next
        EndIf
    Next
EndFunc

; Test nearby agents
Func TestNearbyAgents()
    Out(@CRLF & "📍 Nearby Agents Scan", 0x9B59B6)

    Local $agents = Agent_GetAgentArray(0xDB)
    Local $found = 0

    For $i = 1 To Min($agents[0], 25)
        Local $agentID = Agent_GetAgentInfo($agents[$i], "ID")
        If $agentID = Agent_GetMyID() Then ContinueLoop

        Local $distance = Agent_GetDistance($agentID)
        If $distance < 1000 Then
            Local $count = VisibleEffect_Count($agentID)
            If $count > 0 Then
                $found += 1
                Local $hp = Round(Agent_GetAgentInfo($agentID, "HP") * 100)
                Out("Agent " & $agentID & " (D:" & Round($distance) & ", HP:" & $hp & "%): " & $count & " effects", 0x3498DB)
            EndIf
        EndIf
    Next

    If $found = 0 Then Out("No nearby agents with effects", 0x95A5A6)
EndFunc

; Analyze effects
Func AnalyzeEffects()
    Out(@CRLF & "📊 Effect Analysis", 0xE91E63)
    Out("Total Scans: " & $g_i_TotalScans, 0x95A5A6)
    Out("Total Effects Detected: " & $g_i_TotalEffectsDetected, 0x95A5A6)
    Out("Unique Effects: " & $g_i_UniqueCount, 0x95A5A6)

    If $g_i_UniqueCount > 0 Then
        Out(@CRLF & "Unique Effect IDs:", 0x3498DB)
        For $i = 0 To $g_i_UniqueCount - 1
            Out("  - " & $g_a_UniqueEffects[$i] & " " & GetEffectName($g_a_UniqueEffects[$i]), 0x95A5A6)
        Next
    EndIf
EndFunc

; Add unique effect
Func AddUniqueEffect($effectID)
    For $i = 0 To $g_i_UniqueCount - 1
        If $g_a_UniqueEffects[$i] = $effectID Then Return
    Next

    $g_a_UniqueEffects[$g_i_UniqueCount] = $effectID
    $g_i_UniqueCount += 1
EndFunc

; Export log
Func ExportLog()
    Local $filename = @ScriptDir & "\TListLog_" & @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC & ".txt"
    Local $text = _GUICtrlRichEdit_GetText($g_h_EditText)

    Local $file = FileOpen($filename, 2)
    FileWrite($file, "TList VisibleEffects Log" & @CRLF)
    FileWrite($file, "========================" & @CRLF)
    FileWrite($file, "Character: " & player_GetCharname() & @CRLF)
    FileWrite($file, "Date: " & @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & @CRLF)
    FileWrite($file, "Total Scans: " & $g_i_TotalScans & @CRLF)
    FileWrite($file, "Unique Effects: " & $g_i_UniqueCount & @CRLF)
    FileWrite($file, "========================" & @CRLF & @CRLF)
    FileWrite($file, $text)
    FileClose($file)

    Out("📄 Log exported to: " & $filename, 0x27AE60)
EndFunc

; Get effect type
Func GetEffectType($unk)
    Switch $unk
        Case 1
            Return "[Enchantment]"
        Case 9
            Return "[Weapon Spell]"
        Case Else
            Return "[Type " & $unk & "]"
    EndSwitch
EndFunc

; Get full effect name
Func GetEffectFullName($id, $unk)
    Local $name = GetEffectName($id)
    Local $type = GetEffectType($unk)
    Return "ID " & $id & " " & $type & $name
EndFunc

; Get effect name
Func GetEffectName($effectID)
    For $i = 0 To UBound($g_EffectNames) - 1
        If $g_EffectNames[$i][0] = $effectID Then
            Return " (" & $g_EffectNames[$i][1] & ")"
        EndIf
    Next
    Return ""
EndFunc

; Initialize effect dictionary
Func InitializeEffectDictionary()
    ; Structure: [ID][Name][Type]
    Local $effects[][3] = [ _
        [1, "Enchantment Type", "System"], _
        [9, "Weapon Spell Type", "System"], _
        [26, "Disease", "Condition"], _
        [28, "Dazed", "Condition"], _
        [29, "Weakness", "Condition"], _
        [27, "Poison", "Condition"], _
        [24, "Blind", "Condition"], _
        [25, "Burning", "Condition"], _
        [23, "Bleeding", "Condition"], _
        [29, "Cracked Armor", "Condition"] _
    ]

    For $i = 0 To UBound($effects) - 1
        $g_EffectNames[$i][0] = $effects[$i][0]
        $g_EffectNames[$i][1] = $effects[$i][1]
        $g_EffectNames[$i][2] = $effects[$i][2]
    Next
EndFunc

Func Min($a, $b)
    Return $a < $b ? $a : $b
EndFunc

Func Out($TEXT, $COLOR = 0x000000)
    _GUICtrlRichEdit_SetCharColor($g_h_EditText, $COLOR)
    _GUICtrlEdit_AppendText($g_h_EditText, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
    _GUICtrlEdit_Scroll($g_h_EditText, 1)
EndFunc

Func GetChecked($GUICtrl)
	Return BitAND(GUICtrlRead($GUICtrl), $GUI_CHECKED) = $GUI_CHECKED
EndFunc

; Simple function for compatibility
Func Agent_CountVisibleEffectsSimple($a_i_AgentID = -2)
    Local $l_i_Count = 0
    Local $l_p_Sentinel = Agent_GetAgentInfo($a_i_AgentID, "VisibleEffectsPtr")
    Local $l_p_CurrentEffect = Agent_GetAgentInfo($a_i_AgentID, "VisibleEffectsNextNode")

    If $l_p_CurrentEffect = 0 Or $l_p_CurrentEffect = $l_p_Sentinel Then Return 0

    Local $l_i_SafetyCounter = 0
    While ($l_p_CurrentEffect <> 0 And $l_p_CurrentEffect <> $l_p_Sentinel And $l_i_SafetyCounter < 100)
        $l_i_Count += 1
        Local $l_p_CurrentTLink = $l_p_CurrentEffect - 0x8
        $l_p_CurrentEffect = Memory_Read($l_p_CurrentTLink + 0x4, "ptr")
        $l_i_SafetyCounter += 1
    WEnd

    Return $l_i_Count
EndFunc

; Missing function: Get party member ID
Func Party_GetPartyMemberID($a_i_MemberIndex)
    ; Validate index (1-8 for party members)
    If $a_i_MemberIndex < 1 Or $a_i_MemberIndex > 8 Then Return 0

    ; Get party info base pointer
    Local $l_a_Offset[5] = [0, 0x18, 0x2C, 0x54C, 0x0]
    Local $l_p_PartyBase = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)

    If $l_p_PartyBase[1] = 0 Then Return 0

    ; Each party member structure is 0x4C bytes
    ; First member starts at offset 0x0
    Local $l_i_MemberOffset = ($a_i_MemberIndex - 1) * 0x4C

    ; AgentID is at offset 0x0 in each party member structure
    Local $l_i_AgentID = Memory_Read($l_p_PartyBase[1] + $l_i_MemberOffset, "dword")

    Return $l_i_AgentID
EndFunc

Func _Exit()
    Exit
EndFunc