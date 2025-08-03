#RequireAdmin
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <File.au3>
#include <Array.au3>
#include <GuiEdit.au3>
#include <GuiRichEdit.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>

; ===============================================================
; MPF Cache Analyzer
; Analyse les fichiers .mpf existants et les compare avec mapinfo.csv
; ===============================================================

Global Const $CACHE_FOLDER = @ScriptDir
Global Const $MAPINFO_FILE = @ScriptDir & "\mapinfo.csv"
Global $g_a_MapInfo[0][2]  ; [MapID, MapName]
Global $g_a_MPFFiles[0][4] ; [FileName, MapID, MapName, RegionType]
Global $g_a_MissingMaps[0][2] ; [MapID, MapName]

; GUI Controls
Global $g_h_GUI
Global $g_h_ListView_Existing
Global $g_h_ListView_Missing
Global $g_h_Label_Stats
Global $g_h_Progress
Global $g_h_EditLog

Opt("GUIOnEventMode", 1)

; Create main GUI
$g_h_GUI = GUICreate("MPF Cache Analyzer", 1000, 700, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

; Header
GUICtrlCreateLabel("MPF Cache Analyzer - PathFinding Cache Analysis", 10, 10, 980, 25, $SS_CENTER)
GUICtrlSetFont(-1, 12, 800)

; Stats label
$g_h_Label_Stats = GUICtrlCreateLabel("Initializing...", 10, 40, 980, 20)

; Existing files group
GUICtrlCreateGroup("Existing MPF Files", 10, 70, 480, 300)
$g_h_ListView_Existing = GUICtrlCreateListView("Map ID|Map Name|Region Type|File Name", 20, 90, 460, 270)
_GUICtrlListView_SetColumnWidth($g_h_ListView_Existing, 0, 60)
_GUICtrlListView_SetColumnWidth($g_h_ListView_Existing, 1, 180)
_GUICtrlListView_SetColumnWidth($g_h_ListView_Existing, 2, 80)
_GUICtrlListView_SetColumnWidth($g_h_ListView_Existing, 3, 120)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Missing maps group
GUICtrlCreateGroup("Missing Maps (Not Cached)", 510, 70, 480, 300)
$g_h_ListView_Missing = GUICtrlCreateListView("Map ID|Map Name", 520, 90, 460, 270)
_GUICtrlListView_SetColumnWidth($g_h_ListView_Missing, 0, 80)
_GUICtrlListView_SetColumnWidth($g_h_ListView_Missing, 1, 370)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Progress bar
$g_h_Progress = GUICtrlCreateProgress(10, 380, 980, 20)

; Log area
GUICtrlCreateLabel("Analysis Log:", 10, 410, 100, 20)
$g_h_EditLog = _GUICtrlRichEdit_Create($g_h_GUI, "", 10, 430, 980, 200, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
_GUICtrlRichEdit_SetBkColor($g_h_EditLog, $COLOR_WHITE)

; Buttons
Local $h_BtnRefresh = GUICtrlCreateButton("Refresh Analysis", 10, 640, 150, 40)
GUICtrlSetOnEvent($h_BtnRefresh, "_RefreshAnalysis")

Local $h_BtnExport = GUICtrlCreateButton("Export Missing List", 170, 640, 150, 40)
GUICtrlSetOnEvent($h_BtnExport, "_ExportMissingList")

Local $h_BtnOpenFolder = GUICtrlCreateButton("Open Cache Folder", 330, 640, 150, 40)
GUICtrlSetOnEvent($h_BtnOpenFolder, "_OpenCacheFolder")

; Show GUI
GUISetState(@SW_SHOW)

; Initial analysis
_RefreshAnalysis()

; Main loop
While 1
    Sleep(100)
WEnd

; ===============================================================
; Functions
; ===============================================================

Func _RefreshAnalysis()
    _Log("Starting analysis...")
    GUICtrlSetData($g_h_Progress, 0)

    ; Clear lists
    _GUICtrlListView_DeleteAllItems($g_h_ListView_Existing)
    _GUICtrlListView_DeleteAllItems($g_h_ListView_Missing)

    ; Load map info
    If Not _LoadMapInfo() Then
        _Log("ERROR: Failed to load mapinfo.csv!", 0xFF0000)
        Return
    EndIf

    GUICtrlSetData($g_h_Progress, 25)

    ; Scan MPF files
    _ScanMPFFiles()

    GUICtrlSetData($g_h_Progress, 50)

    ; Analyze missing maps
    _AnalyzeMissingMaps()

    GUICtrlSetData($g_h_Progress, 75)

    ; Update displays
    _UpdateDisplays()

    GUICtrlSetData($g_h_Progress, 100)

    ; Update stats
    Local $s_Stats = "Total Maps in Database: " & UBound($g_a_MapInfo) & _
                     " | Cached Maps: " & UBound($g_a_MPFFiles) & _
                     " | Missing Maps: " & UBound($g_a_MissingMaps) & _
                     " | Coverage: " & Round((UBound($g_a_MPFFiles) / UBound($g_a_MapInfo)) * 100, 1) & "%"

    GUICtrlSetData($g_h_Label_Stats, $s_Stats)

    _Log("Analysis complete!")
    _Log($s_Stats)
EndFunc

Func _LoadMapInfo()
    _Log("Loading mapinfo.csv...")

    If Not FileExists($MAPINFO_FILE) Then
        _Log("ERROR: mapinfo.csv not found at: " & $MAPINFO_FILE, 0xFF0000)
        Return False
    EndIf

    Local $a_Lines
    If Not _FileReadToArray($MAPINFO_FILE, $a_Lines) Then
        _Log("ERROR: Failed to read mapinfo.csv", 0xFF0000)
        Return False
    EndIf

    ; Parse CSV (assuming format: MapID,MapName,...)
    ReDim $g_a_MapInfo[$a_Lines[0]][2]
    Local $i_ValidMaps = 0

    For $i = 1 To $a_Lines[0]
        Local $a_Fields = StringSplit($a_Lines[$i], ",", 2)
        If UBound($a_Fields) >= 2 Then
            ; Clean map ID and name
            Local $i_MapID = Int(StringStripWS($a_Fields[0], 3))
            Local $s_MapName = StringStripWS($a_Fields[1], 3)

            ; Remove quotes if present
            $s_MapName = StringReplace($s_MapName, '"', '')
            $s_MapName = StringReplace($s_MapName, "'", '')

            If $i_MapID > 0 And $s_MapName <> "" Then
                $g_a_MapInfo[$i_ValidMaps][0] = $i_MapID
                $g_a_MapInfo[$i_ValidMaps][1] = $s_MapName
                $i_ValidMaps += 1
            EndIf
        EndIf
    Next

    ; Resize to actual count
    ReDim $g_a_MapInfo[$i_ValidMaps][2]

    _Log("Loaded " & $i_ValidMaps & " maps from mapinfo.csv")
    Return True
EndFunc

Func _ScanMPFFiles()
    _Log("Scanning MPF files in: " & $CACHE_FOLDER)

    If Not FileExists($CACHE_FOLDER) Then
        _Log("Cache folder does not exist!", 0xFF8800)
        Return
    EndIf

    ; Find all .mpf files
    Local $h_Search = FileFindFirstFile($CACHE_FOLDER & "\*.mpf")
    If $h_Search = -1 Then
        _Log("No MPF files found", 0xFF8800)
        Return
    EndIf

    ReDim $g_a_MPFFiles[0][4]
    Local $i_Count = 0

    While 1
        Local $s_File = FileFindNextFile($h_Search)
        If @error Then ExitLoop

        ; Parse filename (format: MapID_MapName_RegionType.mpf)
        Local $s_BaseName = StringTrimRight($s_File, 4) ; Remove .mpf
        Local $a_Parts = StringSplit($s_BaseName, "_", 2)

        If UBound($a_Parts) >= 3 Then
            Local $i_MapID = Int($a_Parts[0])
            Local $s_MapName = $a_Parts[1]
            Local $s_RegionType = $a_Parts[2]

            ; Handle multi-part names (rejoin with underscore)
            For $i = 3 To UBound($a_Parts) - 2
                $s_MapName &= "_" & $a_Parts[$i]
            Next

            ; The last part is always region type
            If UBound($a_Parts) > 3 Then
                $s_RegionType = $a_Parts[UBound($a_Parts) - 1]
            EndIf

            ReDim $g_a_MPFFiles[$i_Count + 1][4]
            $g_a_MPFFiles[$i_Count][0] = $s_File
            $g_a_MPFFiles[$i_Count][1] = $i_MapID
            $g_a_MPFFiles[$i_Count][2] = $s_MapName
            $g_a_MPFFiles[$i_Count][3] = $s_RegionType

            $i_Count += 1
        Else
            _Log("Warning: Invalid filename format: " & $s_File, 0xFF8800)
        EndIf
    WEnd

    FileClose($h_Search)
    _Log("Found " & $i_Count & " MPF files")
EndFunc

Func _AnalyzeMissingMaps()
    _Log("Analyzing missing maps...")

    ReDim $g_a_MissingMaps[0][2]
    Local $i_MissingCount = 0

    ; Check each map in mapinfo
    For $i = 0 To UBound($g_a_MapInfo) - 1
        Local $i_MapID = $g_a_MapInfo[$i][0]
        Local $s_MapName = $g_a_MapInfo[$i][1]
        Local $b_Found = False

        ; Check if this map has an MPF file
        For $j = 0 To UBound($g_a_MPFFiles) - 1
            If $g_a_MPFFiles[$j][1] = $i_MapID Then
                $b_Found = True
                ExitLoop
            EndIf
        Next

        If Not $b_Found Then
            ReDim $g_a_MissingMaps[$i_MissingCount + 1][2]
            $g_a_MissingMaps[$i_MissingCount][0] = $i_MapID
            $g_a_MissingMaps[$i_MissingCount][1] = $s_MapName
            $i_MissingCount += 1
        EndIf
    Next

    _Log("Found " & $i_MissingCount & " missing maps")
EndFunc

Func _UpdateDisplays()
    _Log("Updating display lists...")

    ; Sort existing files by Map ID
    _ArraySort($g_a_MPFFiles, 0, 0, 0, 1)

    ; Add existing files to ListView
    For $i = 0 To UBound($g_a_MPFFiles) - 1
        GUICtrlCreateListViewItem($g_a_MPFFiles[$i][1] & "|" & _
                                  $g_a_MPFFiles[$i][2] & "|" & _
                                  $g_a_MPFFiles[$i][3] & "|" & _
                                  $g_a_MPFFiles[$i][0], $g_h_ListView_Existing)
    Next

    ; Sort missing maps by Map ID
    _ArraySort($g_a_MissingMaps, 0, 0, 0, 0)

    ; Add missing maps to ListView
    For $i = 0 To UBound($g_a_MissingMaps) - 1
        GUICtrlCreateListViewItem($g_a_MissingMaps[$i][0] & "|" & _
                                  $g_a_MissingMaps[$i][1], $g_h_ListView_Missing)
    Next
EndFunc

Func _ExportMissingList()
    _Log("Exporting missing maps list...")

    Local $s_ExportFile = FileSaveDialog("Save Missing Maps List", @ScriptDir, "Text files (*.txt)|CSV files (*.csv)", 16, "missing_maps.txt")
    If @error Then Return

    Local $h_File = FileOpen($s_ExportFile, 2)
    If $h_File = -1 Then
        _Log("ERROR: Failed to create export file", 0xFF0000)
        Return
    EndIf

    ; Write header
    FileWriteLine($h_File, "Missing Maps Report - " & @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN)
    FileWriteLine($h_File, "Total Missing: " & UBound($g_a_MissingMaps))
    FileWriteLine($h_File, "")
    FileWriteLine($h_File, "Map ID" & @TAB & "Map Name")
    FileWriteLine($h_File, "------" & @TAB & "--------")

    ; Write missing maps
    For $i = 0 To UBound($g_a_MissingMaps) - 1
        FileWriteLine($h_File, $g_a_MissingMaps[$i][0] & @TAB & $g_a_MissingMaps[$i][1])
    Next

    FileClose($h_File)

    _Log("Export saved to: " & $s_ExportFile)
    MsgBox(64, "Export Complete", "Missing maps list exported to:" & @CRLF & $s_ExportFile)
EndFunc

Func _OpenCacheFolder()
    If FileExists($CACHE_FOLDER) Then
        ShellExecute($CACHE_FOLDER)
    Else
        MsgBox(48, "Folder Not Found", "Cache folder does not exist:" & @CRLF & $CACHE_FOLDER)
    EndIf
EndFunc

Func _Log($s_Text, $i_Color = $COLOR_BLACK)
    Local $i_TextLen = StringLen($s_Text)
    Local $i_ConsoleLen = _GUICtrlRichEdit_GetTextLength($g_h_EditLog)

    ; Limit log size
    If $i_TextLen + $i_ConsoleLen > 30000 Then
        _GUICtrlRichEdit_SetText($g_h_EditLog, "")
    EndIf

    ; Add timestamp
    Local $s_TimeStamp = "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] "

    _GUICtrlRichEdit_SetCharColor($g_h_EditLog, $i_Color)
    _GUICtrlRichEdit_AppendText($g_h_EditLog, $s_TimeStamp & $s_Text & @CRLF)
    _GUICtrlRichEdit_ScrollToCaret($g_h_EditLog)
EndFunc

Func _Exit()
    Exit
EndFunc