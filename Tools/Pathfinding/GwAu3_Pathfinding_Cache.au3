#include-once

; ===============================================================
; PathFinding Binary Cache System (.mpf format)
; ===============================================================

Global Const $GC_MPF_MAGIC = 0x4D504631      ; "MPF1"
Global Const $GC_MPF_VERSION = 0x0101        ; Version 1.1
Global Const $GC_S_CACHE_VERSION = "1.1"     ; For compatibility
Global Const $GC_S_CACHE_FOLDER = @ScriptDir & "\Config\MPFs"
Global $g_b_CacheEnabled = True

; Section type identifiers
Global Enum $MPF_SECTION_TRAPEZOIDS = 0x54524150, _  ; "TRAP"
            $MPF_SECTION_AABBS = 0x41414242, _        ; "AABB"
            $MPF_SECTION_PORTALS = 0x504F5254, _      ; "PORT"
            $MPF_SECTION_POINTS = 0x504F494E, _       ; "POIN"
            $MPF_SECTION_TELEPORTS = 0x54454C45, _    ; "TELE"
            $MPF_SECTION_AABB_GRAPH = 0x41474248, _   ; "AGBH"
            $MPF_SECTION_PT_GRAPH = 0x50544752, _     ; "PTGR"
            $MPF_SECTION_VIS_GRAPH = 0x56495347, _    ; "VISG"
            $MPF_SECTION_TELE_GRAPH = 0x54474248      ; "TGBH"

; ===============================================================
; Map Name Lookup Function
; ===============================================================
Func PathFinding_GetMapName($a_i_MapID)
    ; This function should load the map name from mapinfo.csv
    ; For now, returning a placeholder - you'll need to implement CSV reading

    ; Example implementation (you'll need to adapt based on your CSV structure):
    Local $s_CSVPath = @ScriptDir & "\Config\MPFs\mapinfo.csv"
    Local $a_CSVData

    If Not _FileReadToArray($s_CSVPath, $a_CSVData) Then
        Log_Warning("Could not read mapinfo.csv, using default name", "Cache", $g_h_EditText)
        Return "Unknown_Map"
    EndIf

    ; Assuming CSV format: MapID,MapName,...
    For $i = 1 To $a_CSVData[0]
        Local $a_Line = StringSplit($a_CSVData[$i], ",")
        If $a_Line[0] >= 2 And Int($a_Line[1]) = $a_i_MapID Then
            ; Clean the map name (remove special characters, spaces -> underscores)
            Local $s_MapName = StringStripWS($a_Line[2], 3)
            $s_MapName = StringReplace($s_MapName, " ", "_")
            $s_MapName = StringReplace($s_MapName, "'", "")
            $s_MapName = StringReplace($s_MapName, '"', "")
            $s_MapName = StringRegExpReplace($s_MapName, '[^\w_-]', '')
            Return $s_MapName
        EndIf
    Next

    Return "Unknown_Map"
EndFunc

; ===============================================================
; Get Cache Filename
; ===============================================================
Func PathFinding_GetCacheFilename($a_i_MapID)
    Local $s_MapName = PathFinding_GetMapName($a_i_MapID)
    Local $s_RegionType = Map_GetCurrentRegionType()

    ; Clean region type name (replace spaces with underscores)
    $s_RegionType = StringReplace($s_RegionType, " ", "_")

    ; If map name is unknown, use special format
    If $s_MapName = "Unknown_Map" Then
        Return $a_i_MapID & "_UnknownName_" & $s_RegionType & ".mpf"
    Else
        Return $a_i_MapID & "_" & $s_MapName & "_" & $s_RegionType & ".mpf"
    EndIf
EndFunc

; ===============================================================
; Main Cache Functions
; ===============================================================

Func PathFinding_SaveToCache($a_i_MapID = -1)
    If Not $g_b_PathingInitialized Then
        Log_Error("PathFinding not initialized, cannot save cache", "Cache", $g_h_EditText)
        Return False
    EndIf

    ; Get current map ID if not provided
    If $a_i_MapID = -1 Then $a_i_MapID = Map_GetMapID()

    Log_Info("Saving PathFinding data to cache for map " & $a_i_MapID & "...", "Cache", $g_h_EditText)

    ; Create cache folder if needed
    If Not FileExists($GC_S_CACHE_FOLDER) Then
        DirCreate($GC_S_CACHE_FOLDER)
    EndIf

    ; Get new filename format with region type
    Local $l_s_Filename = PathFinding_GetCacheFilename($a_i_MapID)
    Local $l_s_CacheFile = $GC_S_CACHE_FOLDER & "\" & $l_s_Filename
    Local $l_i_StartTime = TimerInit()

    Log_Info("Cache filename: " & $l_s_Filename, "Cache", $g_h_EditText)

    ; Open file for binary writing
    Local $h_File = FileOpen($l_s_CacheFile, 18)  ; Binary write mode (16 + 2)
    If $h_File = -1 Then
        Log_Error("Failed to create cache file", "Cache", $g_h_EditText)
        Return False
    EndIf

    ; Write header
    _MPF_WriteHeader($h_File, $a_i_MapID)

    ; Count sections
    Local $i_SectionCount = 9  ; All sections
    _MPF_WriteDword($h_File, $i_SectionCount)

    ; Write all sections
    _MPF_WriteTrapezoidSection($h_File)
    _MPF_WriteAABBSection($h_File)
    _MPF_WritePortalSection($h_File)
    _MPF_WritePointSection($h_File)
    _MPF_WriteTeleportSection($h_File)
    _MPF_WriteAABBGraphSection($h_File)
    _MPF_WritePTGraphSection($h_File)
    _MPF_WriteVisGraphSection($h_File)
    _MPF_WriteTeleGraphSection($h_File)

    FileClose($h_File)

    Local $l_f_ElapsedTime = TimerDiff($l_i_StartTime)
    Local $l_i_FileSize = FileGetSize($l_s_CacheFile)

    Log_Info("Cache saved successfully in " & Round($l_f_ElapsedTime, 2) & " ms", "Cache", $g_h_EditText)
    Log_Info("Cache file: " & $l_s_CacheFile & " (" & Round($l_i_FileSize / 1024, 2) & " KB)", "Cache", $g_h_EditText)

    Return True
EndFunc

Func PathFinding_LoadFromCache($a_i_MapID = -1)
    ; Get current map ID if not provided
    If $a_i_MapID = -1 Then $a_i_MapID = Map_GetMapID()

    ; Find cache file that starts with the map ID
    Local $l_s_CacheFile = PathFinding_FindCacheFile($a_i_MapID)

    If $l_s_CacheFile = "" Then
        Log_Warning("No cache file found for map " & $a_i_MapID, "Cache", $g_h_EditText)
        Return False
    EndIf

    Log_Info("Loading PathFinding data from cache: " & $l_s_CacheFile, "Cache", $g_h_EditText)
    Local $l_i_StartTime = TimerInit()

    ; Open file for binary reading
    Local $h_File = FileOpen($l_s_CacheFile, 16)  ; Binary read mode
    If $h_File = -1 Then
        Log_Error("Failed to open cache file", "Cache", $g_h_EditText)
        Return False
    EndIf

    ; Read and verify header
    If Not _MPF_ReadHeader($h_File, $a_i_MapID) Then
        FileClose($h_File)
        Return False
    EndIf

    ; Clear existing data
    PathFinding_ClearData()

    ; Read section count
    Local $i_SectionCount = _MPF_ReadDword($h_File)

    ; Read all sections
    For $i = 1 To $i_SectionCount
        If Not _MPF_ReadSection($h_File) Then
            Log_Error("Failed to read section " & $i, "Cache", $g_h_EditText)
            FileClose($h_File)
            Return False
        EndIf
    Next

    FileClose($h_File)

    $g_b_PathingInitialized = True

    Local $l_f_ElapsedTime = TimerDiff($l_i_StartTime)
    Log_Info("Cache loaded successfully in " & Round($l_f_ElapsedTime, 2) & " ms", "Cache", $g_h_EditText)

    Return True
EndFunc

; ===============================================================
; Header Functions
; ===============================================================

Func _MPF_WriteHeader($h_File, $i_MapID)
    Local $t_Header = DllStructCreate("dword magic; dword version; dword mapid; dword timestamp; byte usevisgraph; byte reserved[3]")

    DllStructSetData($t_Header, "magic", $GC_MPF_MAGIC)
    DllStructSetData($t_Header, "version", $GC_MPF_VERSION)
    DllStructSetData($t_Header, "mapid", $i_MapID)
    DllStructSetData($t_Header, "timestamp", _DateDiff('s', "1970/01/01 00:00:00", _NowCalc()))
    DllStructSetData($t_Header, "usevisgraph", $g_b_UseVisibilityGraph ? 1 : 0)

    FileWrite($h_File, DllStructGetData(DllStructCreate("byte[20]", DllStructGetPtr($t_Header)), 1))
EndFunc

Func _MPF_ReadHeader($h_File, $i_ExpectedMapID)
    Local $b_Header = FileRead($h_File, 20)
    Local $t_Header = DllStructCreate("dword magic; dword version; dword mapid; dword timestamp; byte usevisgraph; byte reserved[3]")
    DllStructSetData(DllStructCreate("byte[20]", DllStructGetPtr($t_Header)), 1, $b_Header)

    ; Verify magic
    If DllStructGetData($t_Header, "magic") <> $GC_MPF_MAGIC Then
        Log_Error("Invalid file format (bad magic)", "Cache", $g_h_EditText)
        Return False
    EndIf

    ; Verify version
    Local $i_FileVersion = DllStructGetData($t_Header, "version")
    If $i_FileVersion > $GC_MPF_VERSION Then
        Log_Error("Unsupported file version: " & Hex($i_FileVersion, 4), "Cache", $g_h_EditText)
        Return False
    EndIf

    ; Verify map ID
    Local $i_FileMapID = DllStructGetData($t_Header, "mapid")
    If $i_FileMapID <> $i_ExpectedMapID Then
        Log_Warning("Map ID mismatch (file: " & $i_FileMapID & ", expected: " & $i_ExpectedMapID & ")", "Cache", $g_h_EditText)
    EndIf

    ; Restore settings
    $g_b_UseVisibilityGraph = (DllStructGetData($t_Header, "usevisgraph") = 1)

    Return True
EndFunc

; ===============================================================
; Section Write Functions
; ===============================================================

Func _MPF_WriteTrapezoidSection($h_File)
    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_TRAPEZOIDS, $g_a_PathingTrapezoids[0], $g_a_PathingTrapezoids[0] * 44)

    For $i = 1 To $g_a_PathingTrapezoids[0]
        Local $l_a_Trap = $g_a_PathingTrapezoids[$i]
        If IsArray($l_a_Trap) Then
            Local $t_Trap = DllStructCreate("int id; int layer; float coords[8]")
            DllStructSetData($t_Trap, "id", $l_a_Trap[0])
            DllStructSetData($t_Trap, "layer", $l_a_Trap[1])
            For $j = 0 To 7
                DllStructSetData($t_Trap, "coords", $l_a_Trap[$j + 2], $j + 1)
            Next
            FileWrite($h_File, DllStructGetData(DllStructCreate("byte[44]", DllStructGetPtr($t_Trap)), 1))
        EndIf
    Next
EndFunc

Func _MPF_WriteAABBSection($h_File)
    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_AABBS, $g_a_PathingAABBs[0], $g_a_PathingAABBs[0] * 24)

    For $i = 1 To $g_a_PathingAABBs[0]
        Local $l_a_AABB = $g_a_PathingAABBs[$i]
        If IsArray($l_a_AABB) Then
            Local $t_AABB = DllStructCreate("int id; float posx; float posy; float halfx; float halfy; int trapindex")
            DllStructSetData($t_AABB, "id", $l_a_AABB[0])
            DllStructSetData($t_AABB, "posx", $l_a_AABB[1])
            DllStructSetData($t_AABB, "posy", $l_a_AABB[2])
            DllStructSetData($t_AABB, "halfx", $l_a_AABB[3])
            DllStructSetData($t_AABB, "halfy", $l_a_AABB[4])
            DllStructSetData($t_AABB, "trapindex", $l_a_AABB[5])
            FileWrite($h_File, DllStructGetData(DllStructCreate("byte[24]", DllStructGetPtr($t_AABB)), 1))
        EndIf
    Next
EndFunc

Func _MPF_WritePortalSection($h_File)
    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_PORTALS, $g_a_PathingPortals[0], $g_a_PathingPortals[0] * 24)

    For $i = 1 To $g_a_PathingPortals[0]
        Local $l_a_Portal = $g_a_PathingPortals[$i]
        If IsArray($l_a_Portal) Then
            Local $t_Portal = DllStructCreate("float startx; float starty; float goalx; float goaly; int box1; int box2")
            DllStructSetData($t_Portal, "startx", $l_a_Portal[0])
            DllStructSetData($t_Portal, "starty", $l_a_Portal[1])
            DllStructSetData($t_Portal, "goalx", $l_a_Portal[2])
            DllStructSetData($t_Portal, "goaly", $l_a_Portal[3])
            DllStructSetData($t_Portal, "box1", $l_a_Portal[4])
            DllStructSetData($t_Portal, "box2", $l_a_Portal[5])
            FileWrite($h_File, DllStructGetData(DllStructCreate("byte[24]", DllStructGetPtr($t_Portal)), 1))
        EndIf
    Next
EndFunc

Func _MPF_WritePointSection($h_File)
    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_POINTS, $g_a_PathingPoints[0], $g_a_PathingPoints[0] * 24)

    For $i = 1 To $g_a_PathingPoints[0]
        Local $l_a_Point = $g_a_PathingPoints[$i]
        If IsArray($l_a_Point) Then
            Local $t_Point = DllStructCreate("int id; float posx; float posy; int boxid; int box2id; int portalid")
            DllStructSetData($t_Point, "id", $l_a_Point[0])
            DllStructSetData($t_Point, "posx", $l_a_Point[1])
            DllStructSetData($t_Point, "posy", $l_a_Point[2])
            DllStructSetData($t_Point, "boxid", $l_a_Point[3])
            DllStructSetData($t_Point, "box2id", $l_a_Point[4])
            DllStructSetData($t_Point, "portalid", $l_a_Point[5])
            FileWrite($h_File, DllStructGetData(DllStructCreate("byte[24]", DllStructGetPtr($t_Point)), 1))
        EndIf
    Next
EndFunc

Func _MPF_WriteTeleportSection($h_File)
    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_TELEPORTS, $g_a_PathingTeleports[0], $g_a_PathingTeleports[0] * 28)

    For $i = 1 To $g_a_PathingTeleports[0]
        Local $l_a_Teleport = $g_a_PathingTeleports[$i]
        If IsArray($l_a_Teleport) Then
            Local $t_Teleport = DllStructCreate("float enterx; float entery; int enterz; float exitx; float exity; int exitz; byte bothways; byte reserved[3]")
            DllStructSetData($t_Teleport, "enterx", $l_a_Teleport[0])
            DllStructSetData($t_Teleport, "entery", $l_a_Teleport[1])
            DllStructSetData($t_Teleport, "enterz", $l_a_Teleport[2])
            DllStructSetData($t_Teleport, "exitx", $l_a_Teleport[3])
            DllStructSetData($t_Teleport, "exity", $l_a_Teleport[4])
            DllStructSetData($t_Teleport, "exitz", $l_a_Teleport[5])
            DllStructSetData($t_Teleport, "bothways", $l_a_Teleport[6] ? 1 : 0)
            FileWrite($h_File, DllStructGetData(DllStructCreate("byte[28]", DllStructGetPtr($t_Teleport)), 1))
        EndIf
    Next
EndFunc

Func _MPF_WriteAABBGraphSection($h_File)
    ; Count non-empty entries
    Local $i_Count = 0
    For $i = 1 To $g_a_PathingAABBs[0]
        If $g_a_PathingAABBGraph[$i] <> "" Then $i_Count += 1
    Next

    ; Calculate size (each entry: index + string length + string data)
    Local $i_Size = 0
    For $i = 1 To $g_a_PathingAABBs[0]
        If $g_a_PathingAABBGraph[$i] <> "" Then
            $i_Size += 8 + StringLen($g_a_PathingAABBGraph[$i])
        EndIf
    Next

    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_AABB_GRAPH, $i_Count, $i_Size)

    For $i = 1 To $g_a_PathingAABBs[0]
        If $g_a_PathingAABBGraph[$i] <> "" Then
            _MPF_WriteDword($h_File, $i)
            _MPF_WriteString($h_File, $g_a_PathingAABBGraph[$i])
        EndIf
    Next
EndFunc

Func _MPF_WritePTGraphSection($h_File)
    ; Similar to AABB graph
    Local $i_Count = 0
    For $i = 0 To UBound($g_a_PathingPTPortalGraph) - 1
        If $g_a_PathingPTPortalGraph[$i] <> "" Then $i_Count += 1
    Next

    Local $i_Size = 0
    For $i = 0 To UBound($g_a_PathingPTPortalGraph) - 1
        If $g_a_PathingPTPortalGraph[$i] <> "" Then
            $i_Size += 8 + StringLen($g_a_PathingPTPortalGraph[$i])
        EndIf
    Next

    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_PT_GRAPH, $i_Count, $i_Size)

    For $i = 0 To UBound($g_a_PathingPTPortalGraph) - 1
        If $g_a_PathingPTPortalGraph[$i] <> "" Then
            _MPF_WriteDword($h_File, $i)
            _MPF_WriteString($h_File, $g_a_PathingPTPortalGraph[$i])
        EndIf
    Next
EndFunc

Func _MPF_WriteVisGraphSection($h_File)
    If Not $g_b_UseVisibilityGraph Then
        _MPF_WriteSectionHeader($h_File, $MPF_SECTION_VIS_GRAPH, 0, 0)
        Return
    EndIf

    ; Count and calculate size
    Local $i_Count = 0
    Local $i_Size = 0

    For $i = 0 To UBound($g_a_PathingVisGraph) - 1
        If $g_a_PathingVisGraph[$i] <> "" Then
            $i_Count += 1
            ; Compress the data
            Local $s_Compressed = PathFinding_CompressVisGraphData($g_a_PathingVisGraph[$i])
            $i_Size += 8 + StringLen($s_Compressed)
        EndIf
    Next

    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_VIS_GRAPH, $i_Count, $i_Size)

    For $i = 0 To UBound($g_a_PathingVisGraph) - 1
        If $g_a_PathingVisGraph[$i] <> "" Then
            _MPF_WriteDword($h_File, $i)
            Local $s_Compressed = PathFinding_CompressVisGraphData($g_a_PathingVisGraph[$i])
            _MPF_WriteString($h_File, $s_Compressed)
        EndIf
    Next
EndFunc

Func _MPF_WriteTeleGraphSection($h_File)
    _MPF_WriteSectionHeader($h_File, $MPF_SECTION_TELE_GRAPH, $g_a_TeleportGraph[0], $g_a_TeleportGraph[0] * 12)

    For $i = 1 To $g_a_TeleportGraph[0]
        Local $l_a_Node = $g_a_TeleportGraph[$i]
        If IsArray($l_a_Node) Then
            Local $t_Node = DllStructCreate("int tp1; int tp2; float distance")
            DllStructSetData($t_Node, "tp1", $l_a_Node[0])
            DllStructSetData($t_Node, "tp2", $l_a_Node[1])
            DllStructSetData($t_Node, "distance", $l_a_Node[2])
            FileWrite($h_File, DllStructGetData(DllStructCreate("byte[12]", DllStructGetPtr($t_Node)), 1))
        EndIf
    Next
EndFunc

; ===============================================================
; Section Read Functions
; ===============================================================

Func _MPF_ReadSection($h_File)
    ; Read section header
    Local $i_Type = _MPF_ReadDword($h_File)
    Local $i_Count = _MPF_ReadDword($h_File)
    Local $i_Size = _MPF_ReadDword($h_File)

    Switch $i_Type
        Case $MPF_SECTION_TRAPEZOIDS
            Return _MPF_ReadTrapezoids($h_File, $i_Count)

        Case $MPF_SECTION_AABBS
            Return _MPF_ReadAABBs($h_File, $i_Count)

        Case $MPF_SECTION_PORTALS
            Return _MPF_ReadPortals($h_File, $i_Count)

        Case $MPF_SECTION_POINTS
            Return _MPF_ReadPoints($h_File, $i_Count)

        Case $MPF_SECTION_TELEPORTS
            Return _MPF_ReadTeleports($h_File, $i_Count)

        Case $MPF_SECTION_AABB_GRAPH
            Return _MPF_ReadAABBGraph($h_File, $i_Count)

        Case $MPF_SECTION_PT_GRAPH
            Return _MPF_ReadPTGraph($h_File, $i_Count)

        Case $MPF_SECTION_VIS_GRAPH
            Return _MPF_ReadVisGraph($h_File, $i_Count)

        Case $MPF_SECTION_TELE_GRAPH
            Return _MPF_ReadTeleGraph($h_File, $i_Count)

        Case Else
            Log_Warning("Unknown section type: " & Hex($i_Type, 8) & ", skipping " & $i_Size & " bytes", "Cache", $g_h_EditText)
            FileRead($h_File, $i_Size)
            Return True
    EndSwitch
EndFunc

Func _MPF_ReadTrapezoids($h_File, $i_Count)
    ReDim $g_a_PathingTrapezoids[$i_Count + 1]
    $g_a_PathingTrapezoids[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 44)
        Local $t_Trap = DllStructCreate("int id; int layer; float coords[8]")
        DllStructSetData(DllStructCreate("byte[44]", DllStructGetPtr($t_Trap)), 1, $b_Data)

        Local $l_a_Trap[10]
        $l_a_Trap[0] = DllStructGetData($t_Trap, "id")
        $l_a_Trap[1] = DllStructGetData($t_Trap, "layer")
        For $j = 0 To 7
            $l_a_Trap[$j + 2] = DllStructGetData($t_Trap, "coords", $j + 1)
        Next

        $g_a_PathingTrapezoids[$i] = $l_a_Trap
    Next

    Return True
EndFunc

Func _MPF_ReadAABBs($h_File, $i_Count)
    ReDim $g_a_PathingAABBs[$i_Count + 1]
    $g_a_PathingAABBs[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 24)
        Local $t_AABB = DllStructCreate("int id; float posx; float posy; float halfx; float halfy; int trapindex")
        DllStructSetData(DllStructCreate("byte[24]", DllStructGetPtr($t_AABB)), 1, $b_Data)

        Local $l_a_AABB[6]
        $l_a_AABB[0] = DllStructGetData($t_AABB, "id")
        $l_a_AABB[1] = DllStructGetData($t_AABB, "posx")
        $l_a_AABB[2] = DllStructGetData($t_AABB, "posy")
        $l_a_AABB[3] = DllStructGetData($t_AABB, "halfx")
        $l_a_AABB[4] = DllStructGetData($t_AABB, "halfy")
        $l_a_AABB[5] = DllStructGetData($t_AABB, "trapindex")

        $g_a_PathingAABBs[$i] = $l_a_AABB
    Next

    Return True
EndFunc

Func _MPF_ReadPortals($h_File, $i_Count)
    ReDim $g_a_PathingPortals[$i_Count + 1]
    $g_a_PathingPortals[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 24)
        Local $t_Portal = DllStructCreate("float startx; float starty; float goalx; float goaly; int box1; int box2")
        DllStructSetData(DllStructCreate("byte[24]", DllStructGetPtr($t_Portal)), 1, $b_Data)

        Local $l_a_Portal[6]
        $l_a_Portal[0] = DllStructGetData($t_Portal, "startx")
        $l_a_Portal[1] = DllStructGetData($t_Portal, "starty")
        $l_a_Portal[2] = DllStructGetData($t_Portal, "goalx")
        $l_a_Portal[3] = DllStructGetData($t_Portal, "goaly")
        $l_a_Portal[4] = DllStructGetData($t_Portal, "box1")
        $l_a_Portal[5] = DllStructGetData($t_Portal, "box2")

        $g_a_PathingPortals[$i] = $l_a_Portal
    Next

    Return True
EndFunc

Func _MPF_ReadPoints($h_File, $i_Count)
    ReDim $g_a_PathingPoints[$i_Count + 1]
    $g_a_PathingPoints[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 24)
        Local $t_Point = DllStructCreate("int id; float posx; float posy; int boxid; int box2id; int portalid")
        DllStructSetData(DllStructCreate("byte[24]", DllStructGetPtr($t_Point)), 1, $b_Data)

        Local $l_a_Point[6]
        $l_a_Point[0] = DllStructGetData($t_Point, "id")
        $l_a_Point[1] = DllStructGetData($t_Point, "posx")
        $l_a_Point[2] = DllStructGetData($t_Point, "posy")
        $l_a_Point[3] = DllStructGetData($t_Point, "boxid")
        $l_a_Point[4] = DllStructGetData($t_Point, "box2id")
        $l_a_Point[5] = DllStructGetData($t_Point, "portalid")

        $g_a_PathingPoints[$i] = $l_a_Point
    Next

    Return True
EndFunc

Func _MPF_ReadTeleports($h_File, $i_Count)
    ReDim $g_a_PathingTeleports[$i_Count + 1]
    $g_a_PathingTeleports[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 28)
        Local $t_Teleport = DllStructCreate("float enterx; float entery; int enterz; float exitx; float exity; int exitz; byte bothways; byte reserved[3]")
        DllStructSetData(DllStructCreate("byte[28]", DllStructGetPtr($t_Teleport)), 1, $b_Data)

        Local $l_a_Teleport[7]
        $l_a_Teleport[0] = DllStructGetData($t_Teleport, "enterx")
        $l_a_Teleport[1] = DllStructGetData($t_Teleport, "entery")
        $l_a_Teleport[2] = DllStructGetData($t_Teleport, "enterz")
        $l_a_Teleport[3] = DllStructGetData($t_Teleport, "exitx")
        $l_a_Teleport[4] = DllStructGetData($t_Teleport, "exity")
        $l_a_Teleport[5] = DllStructGetData($t_Teleport, "exitz")
        $l_a_Teleport[6] = (DllStructGetData($t_Teleport, "bothways") = 1)

        $g_a_PathingTeleports[$i] = $l_a_Teleport
    Next

    Return True
EndFunc

Func _MPF_ReadAABBGraph($h_File, $i_Count)
    ReDim $g_a_PathingAABBGraph[$g_a_PathingAABBs[0] + 1]

    For $i = 1 To $i_Count
        Local $i_Index = _MPF_ReadDword($h_File)
        Local $s_Data = _MPF_ReadString($h_File)

        If $i_Index <= $g_a_PathingAABBs[0] Then
            $g_a_PathingAABBGraph[$i_Index] = $s_Data
        EndIf
    Next

    Return True
EndFunc

Func _MPF_ReadPTGraph($h_File, $i_Count)
    ; Determine max index first
    Local $i_MaxIndex = 0
    Local $i_CurrentPos = FileGetPos($h_File)

    ; Pre-read to find max index
    For $i = 1 To $i_Count
        Local $i_Index = _MPF_ReadDword($h_File)
        If $i_Index > $i_MaxIndex Then $i_MaxIndex = $i_Index
        Local $i_StrLen = _MPF_ReadDword($h_File)
        FileRead($h_File, $i_StrLen)  ; Skip string data
    Next

    ; Reset position
    FileSetPos($h_File, $i_CurrentPos, 0)

    ; Resize array
    ReDim $g_a_PathingPTPortalGraph[$i_MaxIndex + 1]

    ; Read actual data
    For $i = 1 To $i_Count
        Local $i_Index = _MPF_ReadDword($h_File)
        Local $s_Data = _MPF_ReadString($h_File)
        $g_a_PathingPTPortalGraph[$i_Index] = $s_Data
    Next

    Return True
EndFunc

Func _MPF_ReadVisGraph($h_File, $i_Count)
    Local $i_VisGraphSize = $g_a_PathingPoints[0] + $g_a_PathingTeleports[0] * 2 + 3
    ReDim $g_a_PathingVisGraph[$i_VisGraphSize]

    For $i = 0 To $i_VisGraphSize - 1
        $g_a_PathingVisGraph[$i] = ""
    Next

    For $i = 1 To $i_Count
        Local $i_Index = _MPF_ReadDword($h_File)
        Local $s_Compressed = _MPF_ReadString($h_File)

        If $i_Index < $i_VisGraphSize Then
            $g_a_PathingVisGraph[$i_Index] = PathFinding_DecompressVisGraphData($s_Compressed)
        EndIf
    Next

    Return True
EndFunc

Func _MPF_ReadTeleGraph($h_File, $i_Count)
    ReDim $g_a_TeleportGraph[$i_Count + 1]
    $g_a_TeleportGraph[0] = $i_Count

    For $i = 1 To $i_Count
        Local $b_Data = FileRead($h_File, 12)
        Local $t_Node = DllStructCreate("int tp1; int tp2; float distance")
        DllStructSetData(DllStructCreate("byte[12]", DllStructGetPtr($t_Node)), 1, $b_Data)

        Local $l_a_Node[3]
        $l_a_Node[0] = DllStructGetData($t_Node, "tp1")
        $l_a_Node[1] = DllStructGetData($t_Node, "tp2")
        $l_a_Node[2] = DllStructGetData($t_Node, "distance")

        $g_a_TeleportGraph[$i] = $l_a_Node
    Next

    Return True
EndFunc

; ===============================================================
; Helper Functions
; ===============================================================

Func _MPF_WriteSectionHeader($h_File, $i_Type, $i_Count, $i_Size)
    Local $t_Header = DllStructCreate("dword type; dword count; dword size")
    DllStructSetData($t_Header, "type", $i_Type)
    DllStructSetData($t_Header, "count", $i_Count)
    DllStructSetData($t_Header, "size", $i_Size)
    FileWrite($h_File, DllStructGetData(DllStructCreate("byte[12]", DllStructGetPtr($t_Header)), 1))
EndFunc

Func _MPF_WriteDword($h_File, $i_Value)
    Local $t_Dword = DllStructCreate("dword value")
    DllStructSetData($t_Dword, "value", $i_Value)
    FileWrite($h_File, DllStructGetData(DllStructCreate("byte[4]", DllStructGetPtr($t_Dword)), 1))
EndFunc

Func _MPF_WriteString($h_File, $s_String)
    Local $i_Len = StringLen($s_String)
    _MPF_WriteDword($h_File, $i_Len)
    If $i_Len > 0 Then
        FileWrite($h_File, $s_String)
    EndIf
EndFunc

Func _MPF_ReadDword($h_File)
    Local $b_Data = FileRead($h_File, 4)
    Local $t_Dword = DllStructCreate("dword value")
    DllStructSetData(DllStructCreate("byte[4]", DllStructGetPtr($t_Dword)), 1, $b_Data)
    Return DllStructGetData($t_Dword, "value")
EndFunc

Func _MPF_ReadString($h_File)
    Local $i_Len = _MPF_ReadDword($h_File)
    If $i_Len > 0 Then
        Return BinaryToString(FileRead($h_File, $i_Len))
    EndIf
    Return ""
EndFunc

; ===============================================================
; Utility Functions
; ===============================================================

Func PathFinding_ClearData()
    ReDim $g_a_PathingTrapezoids[1]
    ReDim $g_a_PathingAABBs[1]
    ReDim $g_a_PathingPortals[1]
    ReDim $g_a_PathingPoints[1]
    ReDim $g_a_PathingVisGraph[1]
    ReDim $g_a_PathingAABBGraph[1]
    ReDim $g_a_PathingPTPortalGraph[1]
    ReDim $g_a_PathingTeleports[1]
    ReDim $g_a_TeleportGraph[1]

    $g_a_PathingTrapezoids[0] = 0
    $g_a_PathingAABBs[0] = 0
    $g_a_PathingPortals[0] = 0
    $g_a_PathingPoints[0] = 0
    $g_a_PathingTeleports[0] = 0
    $g_a_TeleportGraph[0] = 0

	$g_b_PathingInitialized = False
EndFunc

Func PathFinding_CompressVisGraphData($a_s_Data)
    ; Compress visibility graph data by reducing decimal precision
    Local $l_a_Connections = StringSplit($a_s_Data, "|", 2)
    Local $l_s_Compressed = ""

    For $i = 0 To UBound($l_a_Connections) - 1
        Local $l_a_Parts = StringSplit($l_a_Connections[$i], ",", 2)
        If UBound($l_a_Parts) >= 2 Then
            If $l_s_Compressed <> "" Then $l_s_Compressed &= "|"
            $l_s_Compressed &= $l_a_Parts[0] & "," & Round(Number($l_a_Parts[1]), 2)

            ; Add blocking IDs if present
            For $j = 2 To UBound($l_a_Parts) - 1
                $l_s_Compressed &= "," & $l_a_Parts[$j]
            Next
        EndIf
    Next

    Return $l_s_Compressed
EndFunc

Func PathFinding_DecompressVisGraphData($a_s_Compressed)
    ; Simply return as-is since we're already in the right format
    Return $a_s_Compressed
EndFunc

Func PathFinding_CacheExists($a_i_MapID = -1)
    If $a_i_MapID = -1 Then $a_i_MapID = Map_GetMapID()
    Return PathFinding_FindCacheFile($a_i_MapID) <> ""
EndFunc

Func PathFinding_FindCacheFile($a_i_MapID)
    ; Search for any file that starts with the map ID
    Local $l_s_SearchPattern = $GC_S_CACHE_FOLDER & "\" & $a_i_MapID & "_*.mpf"
    Local $h_Search = FileFindFirstFile($l_s_SearchPattern)

    If $h_Search = -1 Then Return ""

    Local $l_s_FileName = FileFindNextFile($h_Search)
    FileClose($h_Search)

    If @error Then Return ""

    Return $GC_S_CACHE_FOLDER & "\" & $l_s_FileName
EndFunc

Func PathFinding_InitializeWithCache()
    Log_Info("=== Starting PathFinding initialization with cache ===", "PathFinding", $g_h_EditText)

    ; ========== NETTOYAGE PRÉVENTIF ==========
    If $g_b_PathingInitialized Then
        Log_Warning("PathFinding already initialized, cleaning up first", "PathFinding", $g_h_EditText)
        PathFinding_ClearData()
    EndIf
    ; ========================================

    Local $l_i_MapID = Map_GetMapID()

    ; Try to load from cache first
    If $g_b_CacheEnabled And PathFinding_CacheExists($l_i_MapID) Then
        Log_Info("Cache found for map " & $l_i_MapID & ", attempting to load...", "PathFinding", $g_h_EditText)

        If PathFinding_LoadFromCache($l_i_MapID) Then
            Log_Info("Successfully loaded from cache!", "PathFinding", $g_h_EditText)

            ; Still need to load map-specific teleports if not in cache
            If $g_a_PathingTeleports[0] = 0 Then
                PathFinding_LoadMapSpecificData()
            EndIf

            Return True
        Else
            Log_Warning("Failed to load from cache, falling back to normal initialization", "PathFinding", $g_h_EditText)
        EndIf
    EndIf

    ; Normal initialization
    Log_Info("No valid cache found, performing normal initialization", "PathFinding", $g_h_EditText)
    Local $l_b_Result = PathFinding_Initialize()

    ; Save to cache if successful
    If $l_b_Result And $g_b_CacheEnabled Then
        PathFinding_SaveToCache($l_i_MapID)
    EndIf

    Return $l_b_Result
EndFunc
