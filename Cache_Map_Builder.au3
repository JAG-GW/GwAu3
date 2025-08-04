#RequireAdmin
#include "GwAu3/_GwAu3.au3"
#include "Tools/PathFinding/GwAu3_PathFinding.au3"
#include "Tools/PathFinding/GwAu3_PathFinding_Cache.au3"

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", False)

; ===============================================================
; Constants
; ===============================================================
Global Const $CACHE_FOLDER = @ScriptDir & "\Config\MPFs"
Global Const $MAPINFO_FILE = @ScriptDir & "\Config\MPFs\mapinfo.csv"
Global Const $STATUS_FILE = @ScriptDir & "\Config\MPFs\cache_status.ini"
Global Const $TRAVEL_TIMEOUT = 30000 ; 30 seconds
Global Const $CACHE_TIMEOUT = 300000 ; 5 minutes max for caching

; ===============================================================
; Global Variables
; ===============================================================
Global $g_b_Running = False
Global $g_b_BotInitialized = False
Global $g_s_CharacterName = ""
Global $g_a_AllMaps[1][2] ; [MapID, MapName]
Global $g_i_CurrentMapIndex = 1
Global $g_i_StartMapID = 1
Global $g_h_Timer = 0
Global $g_s_CurrentOperation = "Idle"
Global $g_i_TotalMaps = 0
Global $g_i_CompletedMaps = 0
Global $g_i_FailedMaps = 0
Global $g_i_InProgressByOthers = 0

; GUI Controls
Global $g_h_GUI
Global $g_h_ListView
Global $g_h_EditLog
Global $g_h_ComboCharacter
Global $g_h_InputStartID
Global $g_h_BtnStart
Global $g_h_BtnStop
Global $g_h_BtnRefresh
Global $g_h_LabelStatus
Global $g_h_LabelProgress
Global $g_h_Progress

; ===============================================================
; GUI Creation
; ===============================================================
$g_h_GUI = GUICreate("Map Cache Builder", 800, 600, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

; Header
GUICtrlCreateLabel("Map Cache Builder - Multi-Account Safe", 10, 10, 780, 25, $SS_CENTER)
GUICtrlSetFont(-1, 14, 800)

; Character selection
GUICtrlCreateLabel("Character:", 10, 45, 70, 20)
$g_h_ComboCharacter = GUICtrlCreateCombo("", 85, 42, 200, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, Scanner_GetLoggedCharNames())

; Start Map ID
GUICtrlCreateLabel("Start from Map ID:", 300, 45, 100, 20)
$g_h_InputStartID = GUICtrlCreateInput("1", 405, 42, 60, 23, $ES_NUMBER)

; Control buttons
$g_h_BtnStart = GUICtrlCreateButton("Start", 490, 40, 80, 30)
GUICtrlSetOnEvent($g_h_BtnStart, "_OnStart")

$g_h_BtnStop = GUICtrlCreateButton("Stop", 580, 40, 80, 30)
GUICtrlSetOnEvent($g_h_BtnStop, "_OnStop")
GUICtrlSetState($g_h_BtnStop, $GUI_DISABLE)

$g_h_BtnRefresh = GUICtrlCreateButton("Refresh Status", 670, 40, 100, 30)
GUICtrlSetOnEvent($g_h_BtnRefresh, "_RefreshStatus")

; Status labels
$g_h_LabelStatus = GUICtrlCreateLabel("Status: Idle", 10, 80, 400, 20)
GUICtrlSetFont(-1, 10, 600)

$g_h_LabelProgress = GUICtrlCreateLabel("Progress: 0/0 (0%)", 420, 80, 370, 20)
GUICtrlSetFont(-1, 10)

; Progress bar
$g_h_Progress = GUICtrlCreateProgress(10, 105, 780, 20)

; Map list
GUICtrlCreateLabel("Map Status:", 10, 135, 100, 20)
$g_h_ListView = GUICtrlCreateListView("Map ID|Map Name|Status|Failed By|Time", 10, 155, 780, 250)
_GUICtrlListView_SetColumnWidth($g_h_ListView, 0, 80)
_GUICtrlListView_SetColumnWidth($g_h_ListView, 1, 350)
_GUICtrlListView_SetColumnWidth($g_h_ListView, 2, 120)
_GUICtrlListView_SetColumnWidth($g_h_ListView, 3, 130)
_GUICtrlListView_SetColumnWidth($g_h_ListView, 4, 80)

; Log area
GUICtrlCreateLabel("Activity Log:", 10, 415, 100, 20)
$g_h_EditLog = _GUICtrlRichEdit_Create($g_h_GUI, "", 10, 435, 780, 155, _
    BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
_GUICtrlRichEdit_SetBkColor($g_h_EditLog, $COLOR_WHITE)

GUISetState(@SW_SHOW)

; ===============================================================
; Initialize
; ===============================================================
_LoadMapData()
_RefreshStatus()

; ===============================================================
; Main Loop
; ===============================================================
While 1
    If $g_b_Running Then
        _ProcessNextMap()
    EndIf
    Sleep(100)
WEnd

; ===============================================================
; Core Functions
; ===============================================================
Func _OnStart()
    Local $l_s_Character = GUICtrlRead($g_h_ComboCharacter)
    If $l_s_Character = "" Then
        MsgBox(48, "Error", "Please select a character first!")
        Return
    EndIf

    ; Get start map ID
    $g_i_StartMapID = Int(GUICtrlRead($g_h_InputStartID))
    If $g_i_StartMapID < 1 Then $g_i_StartMapID = 1

    ; Initialize bot if needed
    If Not $g_b_BotInitialized Then
        _Log("Initializing bot for character: " & $l_s_Character)

        If Core_Initialize($l_s_Character, True) = 0 Then
            MsgBox(0, "Error", "Could not find a Guild Wars client with character: " & $l_s_Character)
            Return
        EndIf

        $g_b_BotInitialized = True
        $g_s_CharacterName = Player_GetCharname()
        WinSetTitle($g_h_GUI, "", $g_s_CharacterName & " - Map Cache Builder")
        _Log("Bot initialized successfully for: " & $g_s_CharacterName)
    EndIf

    ; ========== AJOUT POUR SÉCURITÉ ==========
    ; S'assurer que le pathfinding n'est pas marqué comme initialisé au démarrage
    $g_b_PathingInitialized = False
    ; =========================================

    ; Find starting index
    $g_i_CurrentMapIndex = 1
    For $i = 1 To UBound($g_a_AllMaps) - 1
        If $g_a_AllMaps[$i][0] >= $g_i_StartMapID Then
            $g_i_CurrentMapIndex = $i
            ExitLoop
        EndIf
    Next

    ; Clean old in-progress entries
    _CleanOldInProgress()

    $g_b_Running = True
    GUICtrlSetState($g_h_BtnStart, $GUI_DISABLE)
    GUICtrlSetState($g_h_BtnStop, $GUI_ENABLE)
    GUICtrlSetState($g_h_ComboCharacter, $GUI_DISABLE)
    GUICtrlSetState($g_h_InputStartID, $GUI_DISABLE)

    _Log("Cache building started from Map ID: " & $g_i_StartMapID)
EndFunc

Func _OnStop()
    $g_b_Running = False
    $g_s_CurrentOperation = "Stopped"

    GUICtrlSetState($g_h_BtnStart, $GUI_ENABLE)
    GUICtrlSetState($g_h_BtnStop, $GUI_DISABLE)

    GUICtrlSetData($g_h_LabelStatus, "Status: Stopped")
    _Log("Cache building stopped by user")

    ; Clear any in-progress status for this character
    If $g_s_CharacterName <> "" Then
        _ClearCharacterInProgress()
    EndIf
EndFunc

Func _ProcessNextMap()
    ; Refresh status periodically
    Static Local $l_i_LastRefresh = 0
    If TimerDiff($l_i_LastRefresh) > 5000 Then ; Every 5 seconds
        _RefreshStatus()
        $l_i_LastRefresh = TimerInit()
    EndIf

    ; Find next map to process
    Local $l_i_MapID = 0
    Local $l_s_MapName = ""
    Local $l_b_Found = False

    For $i = $g_i_CurrentMapIndex To UBound($g_a_AllMaps) - 1
        Local $l_s_Status = _GetMapStatus($g_a_AllMaps[$i][0])

        If $l_s_Status = "Todo" Then
            $l_i_MapID = $g_a_AllMaps[$i][0]
            $l_s_MapName = $g_a_AllMaps[$i][1]
            $g_i_CurrentMapIndex = $i
            $l_b_Found = True
            ExitLoop
        EndIf
    Next

    If Not $l_b_Found Then
        ; Vérifier s'il y a encore des maps Todo depuis le début
        Local $l_b_HasTodo = False
        For $i = 1 To UBound($g_a_AllMaps) - 1
            If _GetMapStatus($g_a_AllMaps[$i][0]) = "Todo" Then
                $l_b_HasTodo = True
                ExitLoop
            EndIf
        Next

        If $l_b_HasTodo Then
            _Log("Reached end of list, restarting from beginning...")
            $g_i_CurrentMapIndex = 1  ; Recommencer au début
            Return ; La prochaine itération trouvera la map
        Else
            _Log("All maps have been cached successfully!")
            _OnStop()
            Return
        EndIf
    EndIf

    ; Process the map
    _ProcessMap($l_i_MapID, $l_s_MapName)

    ; Move to next map
    $g_i_CurrentMapIndex += 1
EndFunc

Func _ProcessMap($a_i_MapID, $a_s_MapName)
    _Log("Processing map: [" & $a_i_MapID & "] " & $a_s_MapName)
    GUICtrlSetData($g_h_LabelStatus, "Status: Processing [" & $a_i_MapID & "] " & $a_s_MapName)

    ; Mark as in progress
    _SetMapStatus($a_i_MapID, "InProgress", $g_s_CharacterName)
    _RefreshMapInList($a_i_MapID)

    ; ========== NETTOYAGE COMPLET AVANT TOUT ==========
    ; Forcer le nettoyage complet AVANT de voyager
    _Log("Cleaning any previous pathfinding data...")
    PathFinding_ClearData()

    ; Vérification que le nettoyage est bien effectué
    _Log("Verification after cleanup:")
    _Log("  Trapezoids: " & $g_a_PathingTrapezoids[0] & " (should be 0)")
    _Log("  AABBs: " & $g_a_PathingAABBs[0] & " (should be 0)")
    _Log("  Portals: " & $g_a_PathingPortals[0] & " (should be 0)")
    _Log("  Points: " & $g_a_PathingPoints[0] & " (should be 0)")
    _Log("  Teleports: " & $g_a_PathingTeleports[0] & " (should be 0)")
    _Log("  Initialized: " & $g_b_PathingInitialized & " (should be False)")
    ; ================================================

    ; Get current map before travel
    Local $l_i_StartMapID = Map_GetCharacterInfo("MapID")
    _Log("Current map: " & $l_i_StartMapID & ", traveling to: " & $a_i_MapID)

    ; Try to travel to the map
    $g_s_CurrentOperation = "Traveling"
    _Log("Initiating travel to map...")

    Map_MoveMap($a_i_MapID, Map_GetCharacterInfo("Region"), 0, Map_GetCharacterInfo("Language"))
    $g_h_Timer = TimerInit()

    ; Wait for travel or timeout
    Local $l_b_Success = False
    Local $l_b_LoadingDetected = False
    Local $l_i_LastMapID = $l_i_StartMapID

    While TimerDiff($g_h_Timer) < $TRAVEL_TIMEOUT
        Sleep(250)

        ; Check if we're loading
        If Agent_GetAgentPtr(-2) = 0 Or Agent_GetMaxAgents() = 0 Then
            $l_b_LoadingDetected = True
            If Mod(TimerDiff($g_h_Timer), 5000) < 300 Then
                _Log("Loading screen detected...")
            EndIf
            ContinueLoop
        EndIf

        ; Get current map
        Local $l_i_CurrentMapID = Map_GetCharacterInfo("MapID")

        ; Check if we arrived at the target map
        If $l_i_CurrentMapID = $a_i_MapID Then
            $l_b_Success = True
            _Log("Arrived at target map!")
            ExitLoop
        EndIf

        ; If we've been loading and now we're on a map
        If $l_b_LoadingDetected And $l_i_CurrentMapID <> 0 Then
            ; Check if it's the target map
            If $l_i_CurrentMapID = $a_i_MapID Then
                $l_b_Success = True
                _Log("Arrived at target map after loading!")
                ExitLoop
            ElseIf $l_i_CurrentMapID = $l_i_StartMapID Then
                ; We're back on the starting map, travel probably failed
                If TimerDiff($g_h_Timer) > 10000 Then ; Give it 10 seconds
                    _Log("Still on starting map after 10s, travel likely failed")
                    ExitLoop
                EndIf
            Else
                ; We're on a different map that's not the target
                _Log("Arrived at wrong map: " & $l_i_CurrentMapID)
                ExitLoop
            EndIf
        EndIf

        ; If we never saw a loading screen and 15 seconds passed
        If Not $l_b_LoadingDetected And TimerDiff($g_h_Timer) > 15000 Then
            _Log("No loading screen after 15s, travel command probably failed")
            ExitLoop
        EndIf

        ; Update status every 5 seconds
        If Mod(TimerDiff($g_h_Timer), 5000) < 300 Then
            _Log("Still waiting... Current map: " & $l_i_CurrentMapID & ", Loading: " & ($l_b_LoadingDetected ? "Yes" : "No"))
        EndIf
    WEnd

    ; Check final result
    If Not $l_b_Success Then
        Local $l_s_Reason = "Unknown"
        If Not $l_b_LoadingDetected Then
            $l_s_Reason = "No loading (map locked?)"
        ElseIf Map_GetCharacterInfo("MapID") <> $a_i_MapID Then
            $l_s_Reason = "Wrong destination"
        Else
            $l_s_Reason = "Timeout"
        EndIf

        _Log("Failed to travel to map! Reason: " & $l_s_Reason, 0xFF0000)
        _SetMapStatus($a_i_MapID, "Failed", $l_s_Reason)
        _RefreshMapInList($a_i_MapID)
        Return
    EndIf

    _Log("Travel successful, waiting for map to stabilize...")
    Sleep(3000) ; Wait for map to stabilize

    ; Check if cache already exists
    If PathFinding_CacheExists($a_i_MapID) Then
        _Log("Cache already exists for this map")
        _SetMapStatus($a_i_MapID, "Completed", _NowCalc())
        _RefreshMapInList($a_i_MapID)
        Return
    EndIf

    ; Generate cache
    $g_s_CurrentOperation = "Caching"
    _Log("Generating pathfinding cache...")

    ; ========== VÉRIFICATION SUPPLÉMENTAIRE ==========
    ; S'assurer qu'on part d'un état propre
    If $g_a_PathingTrapezoids[0] > 0 Or $g_a_PathingAABBs[0] > 0 Or $g_a_PathingPortals[0] > 0 Or $g_a_PathingPoints[0] > 0 Then
        _Log("WARNING: Found existing data before initialization, forcing cleanup...", 0xFF8800)
        _Log("  Existing Trapezoids: " & $g_a_PathingTrapezoids[0])
        _Log("  Existing AABBs: " & $g_a_PathingAABBs[0])
        _Log("  Existing Portals: " & $g_a_PathingPortals[0])
        _Log("  Existing Points: " & $g_a_PathingPoints[0])
        PathFinding_ClearData()
    EndIf
    ; ================================================

    $g_h_Timer = TimerInit()
    Local $l_b_CacheSuccess = False

    ; Initialize pathfinding
    If PathFinding_InitializeWithCache() Then
        _Log("Pathfinding initialized successfully")

        ; Get stats
        Local $l_s_Stats = "Map data loaded: "
        $l_s_Stats &= "Trapezoids: " & PathFinding_GetTrapezoidCount()
        $l_s_Stats &= ", AABBs: " & PathFinding_GetAABBCount()
        $l_s_Stats &= ", Portals: " & PathFinding_GetPortalCount()
        $l_s_Stats &= ", Points: " & PathFinding_GetPointCount()
        $l_s_Stats &= ", Teleports: " & PathFinding_GetTeleportCount()
        _Log($l_s_Stats)

        ; Check if we have valid data
        If PathFinding_GetTrapezoidCount() > 0 And PathFinding_GetAABBCount() > 0 Then
            ; ========== VÉRIFICATION D'INTÉGRITÉ ==========
            _Log("Verifying data integrity before saving...")
            Local $l_b_IntegrityOK = True

            ; Vérifier que les AABBs référencent des trapezoids valides
            For $i = 1 To $g_a_PathingAABBs[0]
                Local $l_a_AABB = $g_a_PathingAABBs[$i]
                If IsArray($l_a_AABB) And $l_a_AABB[5] > $g_a_PathingTrapezoids[0] Then
                    _Log("ERROR: AABB " & $i & " references invalid trapezoid index " & $l_a_AABB[5], 0xFF0000)
                    $l_b_IntegrityOK = False
                EndIf
            Next

            ; Vérifier que le graph correspond aux AABBs
            If UBound($g_a_PathingAABBGraph) <> $g_a_PathingAABBs[0] + 1 Then
                _Log("ERROR: AABBGraph size (" & UBound($g_a_PathingAABBGraph) & ") doesn't match AABB count (" & ($g_a_PathingAABBs[0] + 1) & ")", 0xFF0000)
                $l_b_IntegrityOK = False
            EndIf

            If Not $l_b_IntegrityOK Then
                _Log("Data integrity check failed! Aborting cache save.", 0xFF0000)
                _SetMapStatus($a_i_MapID, "Failed", "Integrity check failed")
                _RefreshMapInList($a_i_MapID)
                Return
            EndIf

            _Log("Data integrity check passed")
            ; =============================================

            ; Save cache
            If PathFinding_SaveToCache($a_i_MapID) Then
                _Log("Cache saved successfully!")
                $l_b_CacheSuccess = True
            Else
                _Log("Failed to save cache!", 0xFF0000)
            EndIf
        Else
            _Log("No valid pathfinding data found for this map!", 0xFF8800)
            ; Some maps might not have pathfinding data (like cinematics)
            $l_b_CacheSuccess = True ; Mark as success anyway
        EndIf
    Else
        _Log("Failed to initialize pathfinding!", 0xFF0000)
    EndIf

    ; Update status
    If $l_b_CacheSuccess Then
        _SetMapStatus($a_i_MapID, "Completed", _NowCalc())
    Else
        _SetMapStatus($a_i_MapID, "Failed", "Cache failed")
    EndIf

    _RefreshMapInList($a_i_MapID)

    ; ========== NETTOYAGE FINAL ==========
    ; Nettoyer après avoir sauvé pour préparer la prochaine map
    _Log("Cleaning up after processing...")
    PathFinding_ClearData()
    ; ====================================
EndFunc

; ===============================================================
; Map Data Management
; ===============================================================
Func _LoadMapData()
    _Log("Loading map data...")

    ; Load all maps from CSV
    If Not FileExists($MAPINFO_FILE) Then
        _Log("mapinfo.csv not found!", 0xFF0000)
        Return
    EndIf

    Local $a_Lines
    If Not _FileReadToArray($MAPINFO_FILE, $a_Lines) Then
        _Log("Failed to read mapinfo.csv", 0xFF0000)
        Return
    EndIf

    ReDim $g_a_AllMaps[$a_Lines[0]][2]
    $g_i_TotalMaps = 0

    For $i = 1 To $a_Lines[0]
        Local $a_Fields = StringSplit($a_Lines[$i], ",", 2)
        If UBound($a_Fields) >= 2 Then
            Local $i_MapID = Int(StringStripWS($a_Fields[0], 3))
            Local $s_MapName = StringStripWS($a_Fields[1], 3)

            $s_MapName = StringReplace($s_MapName, '"', '')
            $s_MapName = StringReplace($s_MapName, "'", '')

            If $i_MapID > 0 And $s_MapName <> "" Then
                $g_a_AllMaps[$g_i_TotalMaps][0] = $i_MapID
                $g_a_AllMaps[$g_i_TotalMaps][1] = $s_MapName
                $g_i_TotalMaps += 1
            EndIf
        EndIf
    Next

    ReDim $g_a_AllMaps[$g_i_TotalMaps][2]
    _Log("Loaded " & $g_i_TotalMaps & " maps from mapinfo.csv")
EndFunc

Func _RefreshStatus()
    _GUICtrlListView_DeleteAllItems($g_h_ListView)

    $g_i_CompletedMaps = 0
    $g_i_FailedMaps = 0
    $g_i_InProgressByOthers = 0

    For $i = 0 To $g_i_TotalMaps - 1
        Local $l_i_MapID = $g_a_AllMaps[$i][0]
        Local $l_s_MapName = $g_a_AllMaps[$i][1]
        Local $l_s_Status = _GetMapStatus($l_i_MapID)
        Local $l_s_FailedBy = ""
        Local $l_s_Time = ""

        ; Get additional info based on status
        Switch $l_s_Status
            Case "Completed"
                $g_i_CompletedMaps += 1
                $l_s_Time = IniRead($STATUS_FILE, "Completed", $l_i_MapID, "")

            Case "InProgress"
                Local $a_Characters = IniReadSectionNames($STATUS_FILE)
                If IsArray($a_Characters) Then
                    For $j = 1 To $a_Characters[0]
                        If StringLeft($a_Characters[$j], 11) = "InProgress_" Then
                            Local $s_CharName = StringTrimLeft($a_Characters[$j], 11)
                            Local $s_Value = IniRead($STATUS_FILE, $a_Characters[$j], $l_i_MapID, "")
                            If $s_Value <> "" Then
                                If $l_s_FailedBy <> "" Then $l_s_FailedBy &= ", "
                                $l_s_FailedBy &= $s_CharName
                                If $s_CharName <> $g_s_CharacterName Then
                                    $g_i_InProgressByOthers += 1
                                EndIf
                                ; Calculate duration
                                Local $i_StartTime = Int($s_Value)
                                Local $i_Duration = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc()) - $i_StartTime
                                $l_s_Time = _FormatDuration($i_Duration)
                            EndIf
                        EndIf
                    Next
                EndIf

            Case "Todo"
                ; Check if any character failed on this map (for display)
                Local $a_Characters = IniReadSectionNames($STATUS_FILE)
                If IsArray($a_Characters) Then
                    For $j = 1 To $a_Characters[0]
                        If StringLeft($a_Characters[$j], 7) = "Failed_" Then
                            Local $s_CharName = StringTrimLeft($a_Characters[$j], 7)
                            If IniRead($STATUS_FILE, $a_Characters[$j], $l_i_MapID, "") <> "" Then
                                If $l_s_FailedBy <> "" Then $l_s_FailedBy &= ", "
                                $l_s_FailedBy &= $s_CharName
                            EndIf
                        EndIf
                    Next
                EndIf
                If $l_s_FailedBy <> "" Then $g_i_FailedMaps += 1
        EndSwitch

        ; Add to list
        GUICtrlCreateListViewItem($l_i_MapID & "|" & $l_s_MapName & "|" & $l_s_Status & "|" & $l_s_FailedBy & "|" & $l_s_Time, $g_h_ListView)
    Next

    ; Update progress
    Local $i_Remaining = $g_i_TotalMaps - $g_i_CompletedMaps
    Local $f_Percentage = 0
    If $g_i_TotalMaps > 0 Then
        $f_Percentage = Round(($g_i_CompletedMaps / $g_i_TotalMaps) * 100, 1)
    EndIf

    GUICtrlSetData($g_h_LabelProgress, "Progress: " & $g_i_CompletedMaps & "/" & $g_i_TotalMaps & " (" & $f_Percentage & "%) - Remaining: " & $i_Remaining)
    GUICtrlSetData($g_h_Progress, $f_Percentage)
EndFunc

Func _RefreshMapInList($a_i_MapID)
    ; Find and update specific map in list
    For $i = 0 To _GUICtrlListView_GetItemCount($g_h_ListView) - 1
        If _GUICtrlListView_GetItemText($g_h_ListView, $i, 0) = String($a_i_MapID) Then
            Local $l_s_MapName = _GUICtrlListView_GetItemText($g_h_ListView, $i, 1)
            Local $l_s_Status = _GetMapStatus($a_i_MapID)
            Local $l_s_FailedBy = ""
            Local $l_s_Time = ""

            ; Get additional info
            Switch $l_s_Status
                Case "Completed"
                    $l_s_Time = IniRead($STATUS_FILE, "Completed", $a_i_MapID, "")
                Case "InProgress"
                    ; Find who is working on it
                    Local $a_Characters = IniReadSectionNames($STATUS_FILE)
                    If IsArray($a_Characters) Then
                        For $j = 1 To $a_Characters[0]
                            If StringLeft($a_Characters[$j], 11) = "InProgress_" Then
                                Local $s_CharName = StringTrimLeft($a_Characters[$j], 11)
                                Local $s_Value = IniRead($STATUS_FILE, $a_Characters[$j], $a_i_MapID, "")
                                If $s_Value <> "" Then
                                    If $l_s_FailedBy <> "" Then $l_s_FailedBy &= ", "
                                    $l_s_FailedBy &= $s_CharName
                                EndIf
                            EndIf
                        Next
                    EndIf
                Case "Todo"
                    ; Show who failed
                    Local $a_Characters = IniReadSectionNames($STATUS_FILE)
                    If IsArray($a_Characters) Then
                        For $j = 1 To $a_Characters[0]
                            If StringLeft($a_Characters[$j], 7) = "Failed_" Then
                                Local $s_CharName = StringTrimLeft($a_Characters[$j], 7)
                                If IniRead($STATUS_FILE, $a_Characters[$j], $a_i_MapID, "") <> "" Then
                                    If $l_s_FailedBy <> "" Then $l_s_FailedBy &= ", "
                                    $l_s_FailedBy &= $s_CharName
                                EndIf
                            EndIf
                        Next
                    EndIf
            EndSwitch

            ; Update item
            _GUICtrlListView_SetItemText($g_h_ListView, $i, $l_s_Status, 2)
            _GUICtrlListView_SetItemText($g_h_ListView, $i, $l_s_FailedBy, 3)
            _GUICtrlListView_SetItemText($g_h_ListView, $i, $l_s_Time, 4)

            ExitLoop
        EndIf
    Next
EndFunc

Func _GetMapStatus($a_i_MapID)
    ; Check if completed (cache exists)
    If PathFinding_CacheExists($a_i_MapID) Or IniRead($STATUS_FILE, "Completed", $a_i_MapID, "") <> "" Then
        Return "Completed"
    EndIf

    ; Check if in progress by any character
    Local $a_Characters = IniReadSectionNames($STATUS_FILE)
    If IsArray($a_Characters) Then
        For $i = 1 To $a_Characters[0]
            If StringLeft($a_Characters[$i], 11) = "InProgress_" Then
                If IniRead($STATUS_FILE, $a_Characters[$i], $a_i_MapID, "") <> "" Then
                    Return "InProgress"
                EndIf
            EndIf
        Next
    EndIf

    ; Always return Todo for non-completed maps
    Return "Todo"
EndFunc

Func _SetMapStatus($a_i_MapID, $a_s_Status, $a_s_Value = "")
    Switch $a_s_Status
        Case "InProgress"
            ; Remove from our failed list
            Local $s_FailedSection = "Failed_" & $g_s_CharacterName
            IniDelete($STATUS_FILE, $s_FailedSection, $a_i_MapID)

            ; Add to in-progress
            Local $s_Section = "InProgress_" & $g_s_CharacterName
            Local $i_Timestamp = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc())
            IniWrite($STATUS_FILE, $s_Section, $a_i_MapID, $i_Timestamp)

        Case "Completed"
            ; Remove from in-progress
            Local $s_Section = "InProgress_" & $g_s_CharacterName
            IniDelete($STATUS_FILE, $s_Section, $a_i_MapID)

            ; Remove from all failed sections (since we succeeded)
            Local $a_Characters = IniReadSectionNames($STATUS_FILE)
            If IsArray($a_Characters) Then
                For $i = 1 To $a_Characters[0]
                    If StringLeft($a_Characters[$i], 7) = "Failed_" Then
                        IniDelete($STATUS_FILE, $a_Characters[$i], $a_i_MapID)
                    EndIf
                Next
            EndIf

            ; Add to completed
            IniWrite($STATUS_FILE, "Completed", $a_i_MapID, $a_s_Value)

        Case "Failed"
            ; Remove from in-progress
            Local $s_Section = "InProgress_" & $g_s_CharacterName
            IniDelete($STATUS_FILE, $s_Section, $a_i_MapID)

            ; Add to character-specific failed section
            Local $s_FailedSection = "Failed_" & $g_s_CharacterName
            IniWrite($STATUS_FILE, $s_FailedSection, $a_i_MapID, $a_s_Value & "|" & _NowCalc())
    EndSwitch
EndFunc

Func _ClearCharacterInProgress()
    Local $s_Section = "InProgress_" & $g_s_CharacterName
    IniDelete($STATUS_FILE, $s_Section)
EndFunc

Func _CleanOldInProgress()
    Local $a_Characters = IniReadSectionNames($STATUS_FILE)
    If Not IsArray($a_Characters) Then Return

    For $i = 1 To $a_Characters[0]
        If StringLeft($a_Characters[$i], 11) = "InProgress_" Then
            ; Clean old in-progress (older than 1 hour)
            Local $a_Maps = IniReadSection($STATUS_FILE, $a_Characters[$i])
            If IsArray($a_Maps) Then
                For $j = 1 To $a_Maps[0][0]
                    Local $i_Timestamp = Int($a_Maps[$j][1])
                    Local $i_Age = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc()) - $i_Timestamp
                    If $i_Age > 3600 Then ; 1 hour
                        IniDelete($STATUS_FILE, $a_Characters[$i], $a_Maps[$j][0])
                        _Log("Cleaned old in-progress: Map " & $a_Maps[$j][0] & " from " & StringTrimLeft($a_Characters[$i], 11))
                    EndIf
                Next
            EndIf
        EndIf
    Next
EndFunc

; ===============================================================
; Utility Functions
; ===============================================================
Func _FormatDuration($i_Seconds)
    If $i_Seconds < 60 Then
        Return $i_Seconds & "s"
    ElseIf $i_Seconds < 3600 Then
        Return Int($i_Seconds / 60) & "m " & Mod($i_Seconds, 60) & "s"
    Else
        Return Int($i_Seconds / 3600) & "h " & Int(Mod($i_Seconds, 3600) / 60) & "m"
    EndIf
EndFunc

Func _Log($s_Text, $i_Color = $COLOR_BLACK)
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
    If $g_s_CharacterName <> "" Then
        _ClearCharacterInProgress()
    EndIf
    Exit
EndFunc