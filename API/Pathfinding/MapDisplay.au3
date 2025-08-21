#include-once

; ============================================================================
; Map Display Module - Easily embeddable map visualization
; Usage: DisplayMap($hParentGUI, $iX, $iY, $iWidth, $iHeight)
; ============================================================================

; Initialize GDI+ if not already done
_GDIPlus_Startup()

; Global variables for timing and click processing
Global $g_i_LastClickTime = 0
Global Const $GC_I_CLICK_DELAY = 100 ; Minimum delay between clicks in ms
Global $g_b_ProcessingClick = False

; Global variables for map display
Global $g_h_MapGraphics = 0
Global $g_h_MapBitmap = 0
Global $g_h_MapGfxCtxt = 0
Global $g_h_MapPic = 0
Global $g_i_MapWidth = 0
Global $g_i_MapHeight = 0
Global $g_f_MapZoom = 1.0
Global $g_f_MapOffsetX = 0
Global $g_f_MapOffsetY = 0
Global $g_i_CurrentMapID = 0
Global $g_b_MapInitialized = False
Global $g_h_ParentGUI = 0
Global $g_i_MapX = 0
Global $g_i_MapY = 0

; Virtual button positions and states
Global $g_amx2_Buttons[3][5] ; [button][x, y, width, height, hover]
Global $g_b_FollowPlayer = False  ; False = center on map, True = center on player
Global $g_b_MouseDown = False

; Map data
Global $g_amx2_MapTrapezoids[0]  ; Store: [id, layer, ax, ay, bx, by, cx, cy, dx, dy]
Global $g_amx2_MapPoints[0]
Global $g_amx2_MapTeleports[0]
Global $g_f_MapMinX = 0, $g_f_MapMaxX = 50000
Global $g_f_MapMinY = 0, $g_f_MapMaxY = 50000

; Player position
Global $g_f_PlayerX = 0
Global $g_f_PlayerY = 0
Global $g_i_PlayerLayer = 0
Global $g_i_PlayerID = 0

; Display options
Global $g_b_ShowPlayer = True
Global $g_b_ShowPath = False
Global $g_b_ShowTeleports = False
Global $g_b_ShowAgents = True  ; Option to show all agents
Global $g_i_SelectedLayer = -1 ; -1 = all layers
Global $g_af2_CurrentPath[0][3]
Global $g_i_MapUpdateTimer = 0

; Agents data
Global $g_amx2_AgentsCache[0][6]  ; Store agent data for display

; Agent allegiance constants
Global Const $GC_I_AGENT_ALLEGIANCE_ENEMY = 3
Global Const $GC_I_AGENT_ALLEGIANCE_ALLY = 1
Global Const $GC_I_AGENT_ALLEGIANCE_SPIRIT = 6
Global Const $GC_I_AGENT_ALLEGIANCE_MINION = 5
Global Const $GC_I_AGENT_ALLEGIANCE_NPC = 2

; Color scheme - EXACTLY like Map_Visualizer
Global Const $GC_I_MAP_COLOR_BG = 0xFF1A1A1A ; Dark background
Global Const $GC_I_MAP_COLOR_TRAPEZOID = 0xFFB8B8B8 ; Light gray for trapezoids
Global Const $GC_I_MAP_COLOR_PLAYER = 0xFF00FF00 ; Green for player
Global Const $GC_I_MAP_COLOR_PATH = 0xFFFFAA00 ; Orange for path
Global Const $GC_I_MAP_COLOR_DESTINATION = 0xFFFF0000 ; Red for destination
Global Const $GC_I_MAP_COLOR_TELEPORT_ENTER = 0xFF00FF00 ; Green for teleport enter
Global Const $GC_I_MAP_COLOR_TELEPORT_EXIT = 0xFFFF0000 ; Red for teleport exit
Global Const $GC_I_MAP_COLOR_TELEPORT_LINK = 0xFF00FFFF ; Cyan for teleport link

; Agent colors
Global Const $GC_I_MAP_COLOR_ITEM = 0xFFFFFFFF ; White for items
Global Const $GC_I_MAP_COLOR_GADGET = 0xFFFFFF00 ; Yellow for gadgets
Global Const $GC_I_MAP_COLOR_ENEMY = 0xFFFF0000 ; Red for enemies
Global Const $GC_I_MAP_COLOR_ALLY = 0xFF00FF00 ; Green for allies
Global Const $GC_I_MAP_COLOR_SPIRIT = 0xFF009900 ; Medium green
Global Const $GC_I_MAP_COLOR_MINION = 0xFF666666 ; Gray for minions
Global Const $GC_I_MAP_COLOR_NPC = 0xFF0080FF ; Blue for NPCs

; Layer colors with red/pink gradient - EXACTLY like Map_Visualizer
Global $g_ai_LayerColors[10]
$g_ai_LayerColors[0] = 0xFFB8B8B8 ; Layer 0 - default gray
$g_ai_LayerColors[1] = 0xFFFF9696 ; Light pink/red
$g_ai_LayerColors[2] = 0xFFFF7878
$g_ai_LayerColors[3] = 0xFFFF5A5A
$g_ai_LayerColors[4] = 0xFFFF3C3C
$g_ai_LayerColors[5] = 0xFFF02828
$g_ai_LayerColors[6] = 0xFFDC1E1E
$g_ai_LayerColors[7] = 0xFFC81414
$g_ai_LayerColors[8] = 0xFFB40A0A
$g_ai_LayerColors[9] = 0xFFA00000 ; Dark red

; Global agent cache
Global $g_amx2_AllAgentsCache[1][6] ; Dynamic array of all Living agents
Global $g_i_AllAgentsCount = 0

; Agent structure indices
Global Enum $GC_I_AGENTID = 0, _           ; ID
            $GC_I_AGENTROTATION = 1, _     ; Rotation
            $GC_I_AGENTX = 2, _            ; X
            $GC_I_AGENTY = 3, _            ; Y
            $GC_I_AGENTTYPE = 4, _         ; Type
            $GC_I_AGENT_ALLEGIANCE = 5     ; Allegiance

; ============================================================================
; Clear agent cache
; ============================================================================
Func MapDisplay_ClearAgentCache()
    ReDim $g_amx2_AllAgentsCache[1][6]
    $g_i_AllAgentsCount = 0
EndFunc

; ============================================================================
; Update all agents from memory
; ============================================================================
Func MapDisplay_UpdateAllAgents()
    Static $s_ad_StructInfo = Memory_CreateStructure( _
        "long ID[0x2C];" & _
        "float Rotation[0x4C];" & _
        "float X[0x74];" & _
        "float Y[0x78];" & _
        "long Type[0x9C];" & _
        "byte Allegiance[0x1B1];")

    Local $l_p_AgentArrayBase = Memory_Read($g_p_AgentBase)
    Local $l_i_MaxAgents = Agent_GetMaxAgents()

    If $g_i_AllAgentsCount <> 0 Then MapDisplay_ClearAgentCache()

    ; Memory_ReadPointerArrayStruct returns [pointer, field1, field2, ...]
    Local $l_amx_TempAgents = Memory_ReadPointerArrayStruct($l_p_AgentArrayBase, $l_i_MaxAgents, $s_ad_StructInfo)

    If @error Or Not IsArray($l_amx_TempAgents) Then
        ReDim $g_amx2_AllAgentsCache[1][6]
        $g_i_AllAgentsCount = 0
        Return
    EndIf

    ; Convert to expected format (without pointer)
    Local $l_i_Count = UBound($l_amx_TempAgents)
    ReDim $g_amx2_AllAgentsCache[$l_i_Count][6]

    For $i = 0 To $l_i_Count - 1
        ; IMPORTANT: Indices are offset by 1 as column 0 contains the pointer
        $g_amx2_AllAgentsCache[$i][$GC_I_AGENTID] = $l_amx_TempAgents[$i][1]        ; ID (was in column 0+1)
        $g_amx2_AllAgentsCache[$i][$GC_I_AGENTROTATION] = $l_amx_TempAgents[$i][2]  ; Rotation (was in column 1+1)
        $g_amx2_AllAgentsCache[$i][$GC_I_AGENTX] = $l_amx_TempAgents[$i][3]         ; X (was in column 2+1)
        $g_amx2_AllAgentsCache[$i][$GC_I_AGENTY] = $l_amx_TempAgents[$i][4]         ; Y (was in column 3+1)
        $g_amx2_AllAgentsCache[$i][$GC_I_AGENTTYPE] = $l_amx_TempAgents[$i][5]      ; Type (was in column 4+1)
        $g_amx2_AllAgentsCache[$i][$GC_I_AGENT_ALLEGIANCE] = $l_amx_TempAgents[$i][6] ; Allegiance (was in column 5+1)
    Next

    $g_i_AllAgentsCount = $l_i_Count
    Return $g_amx2_AllAgentsCache
EndFunc

; ============================================================================
; Main Display Function - Call this to add a map to your GUI
; ============================================================================
Func DisplayMap($a_h_ParentGUI, $a_i_X, $a_i_Y, $a_i_Width, $a_i_Height, $a_b_AutoUpdate = True)
    ; Store dimensions and parent
    $g_i_MapWidth = $a_i_Width
    $g_i_MapHeight = $a_i_Height
    $g_h_ParentGUI = $a_h_ParentGUI
    $g_i_MapX = $a_i_X
    $g_i_MapY = $a_i_Y

    ; Create a picture control to display the map
    $g_h_MapPic = GUICtrlCreatePic("", $a_i_X, $a_i_Y, $a_i_Width, $a_i_Height)

    ; Initialize graphics
    MapDisplay_InitGraphics($a_h_ParentGUI, $a_i_X, $a_i_Y, $a_i_Width, $a_i_Height)

    ; Initialize virtual buttons at the bottom
    Local $l_i_BtnHeight = 30
    Local $l_i_BtnMargin = 5
    Local $l_i_BtnY = $a_i_Height - $l_i_BtnHeight - $l_i_BtnMargin
    Local $l_i_BtnSpacing = 5

    ; Button 0: Center (left)
    $g_amx2_Buttons[0][0] = $l_i_BtnMargin
    $g_amx2_Buttons[0][1] = $l_i_BtnY
    $g_amx2_Buttons[0][2] = 100  ; Width for center button
    $g_amx2_Buttons[0][3] = $l_i_BtnHeight
    $g_amx2_Buttons[0][4] = False ; hover state

    ; Button 1: Zoom In (middle)
    $g_amx2_Buttons[1][0] = $l_i_BtnMargin + 100 + $l_i_BtnSpacing
    $g_amx2_Buttons[1][1] = $l_i_BtnY
    $g_amx2_Buttons[1][2] = 35  ; Width for + button
    $g_amx2_Buttons[1][3] = $l_i_BtnHeight
    $g_amx2_Buttons[1][4] = False

    ; Button 2: Zoom Out (right)
    $g_amx2_Buttons[2][0] = $l_i_BtnMargin + 100 + $l_i_BtnSpacing + 35 + $l_i_BtnSpacing
    $g_amx2_Buttons[2][1] = $l_i_BtnY
    $g_amx2_Buttons[2][2] = 35  ; Width for - button
    $g_amx2_Buttons[2][3] = $l_i_BtnHeight
    $g_amx2_Buttons[2][4] = False

    ; Set up auto-update if requested
    If $a_b_AutoUpdate Then
        AdlibRegister("MapDisplay_Update", 100) ; Update every 100ms
        AdlibRegister("MapDisplay_CheckMouse", 50) ; Check mouse every 50ms
    EndIf

    ; Initial render
    MapDisplay_Render()

    $g_b_MapInitialized = True

    ; For backward compatibility, return just the map control
    Return $g_h_MapPic
EndFunc

; ============================================================================
; Check mouse position and handle clicks
; ============================================================================
Func MapDisplay_CheckMouse()
    If Not $g_b_MapInitialized Then Return
    If $g_b_ProcessingClick Then Return ; Avoid multiple clicks

    Local $l_am_MouseInfo = GUIGetCursorInfo($g_h_ParentGUI)
    If Not IsArray($l_am_MouseInfo) Then Return

    Local $l_i_MouseX = $l_am_MouseInfo[0] - $g_i_MapX
    Local $l_i_MouseY = $l_am_MouseInfo[1] - $g_i_MapY
    Local $l_b_MousePressed = $l_am_MouseInfo[2] ; Primary button pressed

    Local $l_b_NeedRender = False
    Local $l_b_ClickDetected = False

    ; Check hover on each button
    For $i = 0 To 2
        Local $l_b_WasHover = $g_amx2_Buttons[$i][4]
        Local $l_b_IsHover = MapDisplay_IsPointInButton($l_i_MouseX, $l_i_MouseY, $i)

        If $l_b_IsHover <> $l_b_WasHover Then
            $g_amx2_Buttons[$i][4] = $l_b_IsHover
            $l_b_NeedRender = True
        EndIf

        ; Detect click (transition from not pressed to pressed)
        If $l_b_IsHover And $l_b_MousePressed And Not $g_b_MouseDown Then
            Local $l_i_CurrentTime = TimerInit()

            ; Check delay since last click
            If TimerDiff($g_i_LastClickTime) > $GC_I_CLICK_DELAY Then
                $g_b_ProcessingClick = True
                $l_b_ClickDetected = True
                $g_i_LastClickTime = $l_i_CurrentTime

                ; Process click according to button
                Switch $i
                    Case 0 ; Center
                        MapDisplay_ToggleCenterMode()
                    Case 1 ; Zoom In
                        MapDisplay_ZoomIn()
                    Case 2 ; Zoom Out
                        MapDisplay_ZoomOut()
                EndSwitch

                $l_b_NeedRender = True

                ; Reset after short delay
                AdlibRegister("MapDisplay_ResetClickProcessing", 100)
            EndIf
        EndIf
    Next

    ; Update mouse state
    $g_b_MouseDown = $l_b_MousePressed

    ; Render only if necessary
    If $l_b_NeedRender Then
        MapDisplay_Render()
    EndIf
EndFunc

; ============================================================================
; Reset click processing flag
; ============================================================================
Func MapDisplay_ResetClickProcessing()
    $g_b_ProcessingClick = False
    AdlibUnRegister("MapDisplay_ResetClickProcessing")
EndFunc

; ============================================================================
; Check if point is inside a button
; ============================================================================
Func MapDisplay_IsPointInButton($a_i_X, $a_i_Y, $a_i_Button)
    Return $a_i_X >= $g_amx2_Buttons[$a_i_Button][0] And _
           $a_i_X <= $g_amx2_Buttons[$a_i_Button][0] + $g_amx2_Buttons[$a_i_Button][2] And _
           $a_i_Y >= $g_amx2_Buttons[$a_i_Button][1] And _
           $a_i_Y <= $g_amx2_Buttons[$a_i_Button][1] + $g_amx2_Buttons[$a_i_Button][3]
EndFunc

; ============================================================================
; Toggle between center on player and center on map
; ============================================================================
Func MapDisplay_ToggleCenterMode()
    $g_b_FollowPlayer = Not $g_b_FollowPlayer

    If $g_b_FollowPlayer Then
        ; Center on player with zoom to show ~5000 distance
        MapDisplay_CenterOnPlayerWithZoom()
    Else
        ; Center on map
        MapDisplay_FitToMap()
    EndIf

    MapDisplay_Render()
EndFunc

; ============================================================================
; Center on player with appropriate zoom
; ============================================================================
Func MapDisplay_CenterOnPlayerWithZoom()
    ; Calculate zoom to display approximately 5000 units of distance
    ; Half of the window should show 5000 units
    Local $l_f_DesiredViewDistance = 5000.0

    ; Use smallest dimension to ensure 5000 units are visible
    Local $l_f_MinDimension = _Min($g_i_MapWidth, $g_i_MapHeight)

    ; Zoom needed to see 2 * fDesiredViewDistance
    $g_f_MapZoom = $l_f_MinDimension / (2 * $l_f_DesiredViewDistance)

    ; Limit zoom
    If $g_f_MapZoom > 50 Then $g_f_MapZoom = 50
    If $g_f_MapZoom < 0.01 Then $g_f_MapZoom = 0.01

    ; Center on player
    $g_f_MapOffsetX = $g_i_MapWidth / 2 - ($g_f_PlayerX - $g_f_MapMinX) * $g_f_MapZoom
    $g_f_MapOffsetY = $g_i_MapHeight / 2 - ($g_f_PlayerY - $g_f_MapMinY) * $g_f_MapZoom
EndFunc

; ============================================================================
; Center on player maintaining current zoom
; ============================================================================
Func MapDisplay_CenterOnPlayer()
    ; If following player and no defined zoom, apply 5000 zoom
    If $g_b_FollowPlayer And ($g_f_MapZoom < 0.05 Or $g_f_MapZoom > 0.15) Then
        MapDisplay_CenterOnPlayerWithZoom()
    Else
        ; Otherwise just recenter with current zoom
        $g_f_MapOffsetX = $g_i_MapWidth / 2 - ($g_f_PlayerX - $g_f_MapMinX) * $g_f_MapZoom
        $g_f_MapOffsetY = $g_i_MapHeight / 2 - ($g_f_PlayerY - $g_f_MapMinY) * $g_f_MapZoom
    EndIf
EndFunc

; ============================================================================
; Update player position and refresh map
; ============================================================================
Func MapDisplay_SetPlayerPosition($a_f_X, $a_f_Y, $a_i_Layer = 0)
    $g_f_PlayerX = $a_f_X
    $g_f_PlayerY = $a_f_Y
    $g_i_PlayerLayer = $a_i_Layer

    ; If following player, keep centered on player
    If $g_b_FollowPlayer Then
        MapDisplay_CenterOnPlayer()
    Else
        ; Auto-center on player if too close to edge
        MapDisplay_AutoCenter()
    EndIf
EndFunc

; ============================================================================
; Update agents cache from the global cache
; ============================================================================
Func MapDisplay_UpdateAgentsCache()
    ; Directly use updated global cache
    Local $l_i_Count = $g_i_AllAgentsCount
    If $l_i_Count <= 0 Then
        ReDim $g_amx2_AgentsCache[0][6]
        Return
    EndIf

    ; Copy relevant agent data from global cache
    ReDim $g_amx2_AgentsCache[$l_i_Count][6]
    Local $l_i_ValidAgents = 0

    For $i = 0 To $l_i_Count - 1
        ; Skip invalid entries
        If Not IsArray($g_amx2_AllAgentsCache) Or UBound($g_amx2_AllAgentsCache, 2) < 6 Then ContinueLoop

        ; Check if agent has valid position (not 0,0)
        Local $l_f_X = $g_amx2_AllAgentsCache[$i][$GC_I_AGENTX]
        Local $l_f_Y = $g_amx2_AllAgentsCache[$i][$GC_I_AGENTY]

        If $l_f_X <> 0 Or $l_f_Y <> 0 Then
            $g_amx2_AgentsCache[$l_i_ValidAgents][0] = $g_amx2_AllAgentsCache[$i][$GC_I_AGENTID]
            $g_amx2_AgentsCache[$l_i_ValidAgents][1] = $g_amx2_AllAgentsCache[$i][$GC_I_AGENTROTATION]
            $g_amx2_AgentsCache[$l_i_ValidAgents][2] = $l_f_X
            $g_amx2_AgentsCache[$l_i_ValidAgents][3] = $l_f_Y
            $g_amx2_AgentsCache[$l_i_ValidAgents][4] = $g_amx2_AllAgentsCache[$i][$GC_I_AGENTTYPE]
            $g_amx2_AgentsCache[$l_i_ValidAgents][5] = $g_amx2_AllAgentsCache[$i][$GC_I_AGENT_ALLEGIANCE]
            $l_i_ValidAgents += 1
        EndIf
    Next

    ; Resize to actual count
    If $l_i_ValidAgents > 0 Then
        ReDim $g_amx2_AgentsCache[$l_i_ValidAgents][6]
    Else
        ReDim $g_amx2_AgentsCache[0][6]
    EndIf
EndFunc

; ============================================================================
; Set current path to display
; ============================================================================
Func MapDisplay_SetPath(ByRef $a_af2_Path)
    If Not IsArray($a_af2_Path) Then
        ReDim $g_af2_CurrentPath[0][3]
        $g_b_ShowPath = False
        Return
    EndIf

    $g_af2_CurrentPath = $a_af2_Path
    $g_b_ShowPath = True
EndFunc

; ============================================================================
; Set layer to display (-1 for all)
; ============================================================================
Func MapDisplay_SetLayer($a_i_Layer)
    $g_i_SelectedLayer = $a_i_Layer
    MapDisplay_Render()
EndFunc

; ============================================================================
; Load map from current game state
; ============================================================================
Func MapDisplay_LoadFromGame()
    ; This function should be called when connected to the game
    ; It will try to get the current map ID and player position

    Local $l_i_MapID = Map_GetMapID()
    If $l_i_MapID > 0 And $l_i_MapID <> $g_i_CurrentMapID Then
        $g_i_CurrentMapID = $l_i_MapID
        MapDisplay_LoadMapData($l_i_MapID)
    EndIf

    Local $l_f_X = Agent_GetAgentInfo(-2, "X")
    Local $l_f_Y = Agent_GetAgentInfo(-2, "Y")
    MapDisplay_SetPlayerPosition($l_f_X, $l_f_Y)

    ; Update agents cache
    MapDisplay_UpdateAllAgents()
    MapDisplay_UpdateAgentsCache()
EndFunc

; ============================================================================
; Internal functions
; ============================================================================

Func MapDisplay_InitGraphics($a_h_ParentGUI, $a_i_X, $a_i_Y, $a_i_Width, $a_i_Height)
    ; Clean up previous graphics if any
    If $g_h_MapGfxCtxt Then _GDIPlus_GraphicsDispose($g_h_MapGfxCtxt)
    If $g_h_MapBitmap Then _GDIPlus_BitmapDispose($g_h_MapBitmap)
    If $g_h_MapGraphics Then _GDIPlus_GraphicsDispose($g_h_MapGraphics)

    ; Create new graphics context
    $g_h_MapGraphics = _GDIPlus_GraphicsCreateFromHWND($a_h_ParentGUI)
    $g_h_MapBitmap = _GDIPlus_BitmapCreateFromGraphics($a_i_Width, $a_i_Height, $g_h_MapGraphics)
    $g_h_MapGfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_h_MapBitmap)

    ; Set rendering quality - NO antialiasing for sharp edges like Map_Visualizer
    _GDIPlus_GraphicsSetSmoothingMode($g_h_MapGfxCtxt, 0)
EndFunc

Func MapDisplay_LoadMapData($a_i_MapID)
    ; Clear existing data
    ReDim $g_amx2_MapTrapezoids[0]
    ReDim $g_amx2_MapPoints[0]
    ReDim $g_amx2_MapTeleports[0]

    ; Debug message
    ConsoleWrite("Loading map data for ID: " & $a_i_MapID & @CRLF)

    ; Try to find the map file
    Local $l_s_DataFile = $a_i_MapID & "_*.gwau3"
    Local $l_as_Files = _FileListToArray(@ScriptDir, $l_s_DataFile, 1)

    If @error Or Not IsArray($l_as_Files) Or $l_as_Files[0] = 0 Then
        ; Try API folder
        $l_as_Files = _FileListToArray(@ScriptDir & "\..\..\API\Pathfinding\", $l_s_DataFile, 1)
        If @error Or Not IsArray($l_as_Files) Or $l_as_Files[0] = 0 Then
            ConsoleWrite("Map file not found for ID: " & $a_i_MapID & @CRLF)
            Return False
        EndIf
        $l_s_DataFile = @ScriptDir & "\..\..\API\Pathfinding\" & $l_as_Files[1]
    Else
        $l_s_DataFile = @ScriptDir & "\" & $l_as_Files[1]
    EndIf

    ConsoleWrite("Loading file: " & $l_s_DataFile & @CRLF)

    ; Load the file
    MapDisplay_ParseFile($l_s_DataFile)

    ; Auto fit to map bounds
    MapDisplay_FitToMap()

    Return True
EndFunc

Func MapDisplay_ParseFile($a_s_FilePath)
    Local $l_as_Lines = FileReadToArray($a_s_FilePath)
    If @error Then Return False

    Local $l_s_Section = ""
    Local $l_i_Index = 0

    While $l_i_Index < UBound($l_as_Lines)
        Local $l_s_Line = StringStripWS($l_as_Lines[$l_i_Index], 3)

        If StringLeft($l_s_Line, 1) = "[" And StringRight($l_s_Line, 1) = "]" Then
            $l_s_Section = StringMid($l_s_Line, 2, StringLen($l_s_Line) - 2)
        ElseIf $l_s_Line <> "" Then
            Switch $l_s_Section
                Case "METADATA"
                    If StringInStr($l_s_Line, "bounds_min=") Then
                        Local $l_as_Parts = StringSplit(StringMid($l_s_Line, 12), ",", 2)
                        If UBound($l_as_Parts) >= 2 Then
                            $g_f_MapMinX = Number($l_as_Parts[0])
                            $g_f_MapMinY = Number($l_as_Parts[1])
                        EndIf
                    ElseIf StringInStr($l_s_Line, "bounds_max=") Then
                        Local $l_as_Parts = StringSplit(StringMid($l_s_Line, 12), ",", 2)
                        If UBound($l_as_Parts) >= 2 Then
                            $g_f_MapMaxX = Number($l_as_Parts[0])
                            $g_f_MapMaxY = Number($l_as_Parts[1])
                        EndIf
                    EndIf

                Case "TRAPEZOIDS"
                    If StringInStr($l_s_Line, "count=") Then
                        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
                        ReDim $g_amx2_MapTrapezoids[$l_i_Count][10]
                        For $j = 0 To $l_i_Count - 1
                            $l_i_Index += 1
                            If $l_i_Index >= UBound($l_as_Lines) Then ExitLoop
                            MapDisplay_ParseTrapezoid($l_as_Lines[$l_i_Index], $j)
                        Next
                    EndIf

                Case "TELEPORTS"
                    If StringInStr($l_s_Line, "count=") Then
                        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
                        ReDim $g_amx2_MapTeleports[$l_i_Count][7]
                        For $j = 0 To $l_i_Count - 1
                            $l_i_Index += 1
                            If $l_i_Index >= UBound($l_as_Lines) Then ExitLoop
                            MapDisplay_ParseTeleport($l_as_Lines[$l_i_Index], $j)
                        Next
                    EndIf

                Case "POINTS"
                    If StringInStr($l_s_Line, "count=") Then
                        Local $l_i_Count = Number(StringMid($l_s_Line, 7))
                        ReDim $g_amx2_MapPoints[$l_i_Count][7]
                        For $j = 0 To $l_i_Count - 1
                            $l_i_Index += 1
                            If $l_i_Index >= UBound($l_as_Lines) Then ExitLoop
                            MapDisplay_ParsePoint($l_as_Lines[$l_i_Index], $j)
                        Next
                    EndIf
            EndSwitch
        EndIf

        $l_i_Index += 1
    WEnd

    ; Calculate actual bounds from trapezoids
    MapDisplay_CalculateBounds()

    Return True
EndFunc

Func MapDisplay_ParseTrapezoid($a_s_Line, $a_i_Index)
    Local $l_as_Parts = StringSplit($a_s_Line, "|", 2)
    If UBound($l_as_Parts) < 6 Then Return

    $g_amx2_MapTrapezoids[$a_i_Index][0] = Number($l_as_Parts[0]) ; id
    $g_amx2_MapTrapezoids[$a_i_Index][1] = Number($l_as_Parts[1]) ; layer

    ; Parse vertices A, B, C, D
    For $i = 0 To 3
        Local $l_as_Coords = StringSplit($l_as_Parts[$i + 2], ",", 2)
        If UBound($l_as_Coords) >= 2 Then
            $g_amx2_MapTrapezoids[$a_i_Index][2 + $i * 2] = Number($l_as_Coords[0])     ; x coordinate
            $g_amx2_MapTrapezoids[$a_i_Index][2 + $i * 2 + 1] = Number($l_as_Coords[1]) ; y coordinate
        EndIf
    Next
EndFunc

Func MapDisplay_ParseTeleport($a_s_Line, $a_i_Index)
    Local $l_as_Parts = StringSplit($a_s_Line, "|", 2)
    If UBound($l_as_Parts) < 3 Then Return

    ; Parse enter position
    Local $l_as_Enter = StringSplit($l_as_Parts[0], ",", 2)
    If UBound($l_as_Enter) >= 3 Then
        $g_amx2_MapTeleports[$a_i_Index][0] = Number($l_as_Enter[0])
        $g_amx2_MapTeleports[$a_i_Index][1] = Number($l_as_Enter[1])
        $g_amx2_MapTeleports[$a_i_Index][2] = Number($l_as_Enter[2])
    EndIf

    ; Parse exit position
    Local $l_as_Exit = StringSplit($l_as_Parts[1], ",", 2)
    If UBound($l_as_Exit) >= 3 Then
        $g_amx2_MapTeleports[$a_i_Index][3] = Number($l_as_Exit[0])
        $g_amx2_MapTeleports[$a_i_Index][4] = Number($l_as_Exit[1])
        $g_amx2_MapTeleports[$a_i_Index][5] = Number($l_as_Exit[2])
    EndIf

    $g_amx2_MapTeleports[$a_i_Index][6] = Number($l_as_Parts[2]) ; bidirectional
EndFunc

Func MapDisplay_ParsePoint($a_s_Line, $a_i_Index)
    Local $l_as_Parts = StringSplit($a_s_Line, "|", 2)
    If UBound($l_as_Parts) < 6 Then Return

    $g_amx2_MapPoints[$a_i_Index][0] = Number($l_as_Parts[0]) ; id

    ; Parse position
    Local $l_as_Pos = StringSplit($l_as_Parts[1], ",", 2)
    If UBound($l_as_Pos) >= 2 Then
        $g_amx2_MapPoints[$a_i_Index][1] = Number($l_as_Pos[0])
        $g_amx2_MapPoints[$a_i_Index][2] = Number($l_as_Pos[1])
    EndIf

    $g_amx2_MapPoints[$a_i_Index][3] = Number($l_as_Parts[2]) ; box_id
    $g_amx2_MapPoints[$a_i_Index][4] = Number($l_as_Parts[3]) ; layer
    $g_amx2_MapPoints[$a_i_Index][5] = Number($l_as_Parts[4]) ; box2_id
    $g_amx2_MapPoints[$a_i_Index][6] = Number($l_as_Parts[5]) ; portal_id
EndFunc

Func MapDisplay_CalculateBounds()
    ; Calculate actual map bounds from loaded data
    Local $l_f_ActualMinX = 999999, $l_f_ActualMinY = 999999
    Local $l_f_ActualMaxX = -999999, $l_f_ActualMaxY = -999999
    Local $l_b_HasData = False

    ; Check trapezoids bounds
    For $i = 0 To UBound($g_amx2_MapTrapezoids) - 1
        $l_b_HasData = True
        For $j = 0 To 3
            Local $l_f_X = $g_amx2_MapTrapezoids[$i][2 + $j * 2]
            Local $l_f_Y = $g_amx2_MapTrapezoids[$i][3 + $j * 2]
            If $l_f_X < $l_f_ActualMinX Then $l_f_ActualMinX = $l_f_X
            If $l_f_X > $l_f_ActualMaxX Then $l_f_ActualMaxX = $l_f_X
            If $l_f_Y < $l_f_ActualMinY Then $l_f_ActualMinY = $l_f_Y
            If $l_f_Y > $l_f_ActualMaxY Then $l_f_ActualMaxY = $l_f_Y
        Next
    Next

    ; If we have actual data, use those bounds with padding
    If $l_b_HasData Then
        Local $l_f_PaddingX = ($l_f_ActualMaxX - $l_f_ActualMinX) * 0.05
        Local $l_f_PaddingY = ($l_f_ActualMaxY - $l_f_ActualMinY) * 0.05
        $g_f_MapMinX = $l_f_ActualMinX - $l_f_PaddingX
        $g_f_MapMaxX = $l_f_ActualMaxX + $l_f_PaddingX
        $g_f_MapMinY = $l_f_ActualMinY - $l_f_PaddingY
        $g_f_MapMaxY = $l_f_ActualMaxY + $l_f_PaddingY
    EndIf
EndFunc

Func MapDisplay_Render()
    If Not $g_h_MapGfxCtxt Then Return

    ; Clear background with dark color like Map_Visualizer
    _GDIPlus_GraphicsClear($g_h_MapGfxCtxt, $GC_I_MAP_COLOR_BG)

    ; Draw trapezoids (filled polygons like Map_Visualizer)
    MapDisplay_DrawTrapezoids()

    ; Draw teleports if enabled
    If $g_b_ShowTeleports Then
        MapDisplay_DrawTeleports()
    EndIf

    ; Draw path if any
    If $g_b_ShowPath Then
        MapDisplay_DrawPath()
    EndIf

    ; Draw all agents if enabled
    If $g_b_ShowAgents Then
        MapDisplay_DrawAgents()
    EndIf

    ; Draw player (always on top)
    If $g_b_ShowPlayer Then
        MapDisplay_DrawPlayer()
    EndIf

    ; Draw mini info
    MapDisplay_DrawInfo()

    ; Draw virtual buttons
    MapDisplay_DrawButtons()

    ; Update display
    Local $l_h_HBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($g_h_MapBitmap)
    _WinAPI_DeleteObject(GUICtrlSendMsg($g_h_MapPic, 0x0172, 0, $l_h_HBitmap)) ; STM_SETIMAGE
    _WinAPI_DeleteObject($l_h_HBitmap)
EndFunc

Func MapDisplay_DrawTrapezoids()
    ; Draw trapezoids EXACTLY like Map_Visualizer - filled polygons with layer colors
    For $i = 0 To UBound($g_amx2_MapTrapezoids) - 1
        Local $l_i_Layer = $g_amx2_MapTrapezoids[$i][1]

        ; Check layer filter
        If $g_i_SelectedLayer >= 0 And $l_i_Layer <> $g_i_SelectedLayer Then ContinueLoop

        ; Choose color based on layer (use the gradient)
        Local $l_i_LayerColor = $g_ai_LayerColors[Mod($l_i_Layer, 10)]
        Local $l_h_Brush = _GDIPlus_BrushCreateSolid($l_i_LayerColor)

        ; Get the 4 vertices
        Local $l_i_Ax = MapDisplay_WorldToScreenX($g_amx2_MapTrapezoids[$i][2])
        Local $l_i_Ay = MapDisplay_WorldToScreenY($g_amx2_MapTrapezoids[$i][3])
        Local $l_i_Bx = MapDisplay_WorldToScreenX($g_amx2_MapTrapezoids[$i][4])
        Local $l_i_By = MapDisplay_WorldToScreenY($g_amx2_MapTrapezoids[$i][5])
        Local $l_i_Cx = MapDisplay_WorldToScreenX($g_amx2_MapTrapezoids[$i][6])
        Local $l_i_Cy = MapDisplay_WorldToScreenY($g_amx2_MapTrapezoids[$i][7])
        Local $l_i_Dx = MapDisplay_WorldToScreenX($g_amx2_MapTrapezoids[$i][8])
        Local $l_i_Dy = MapDisplay_WorldToScreenY($g_amx2_MapTrapezoids[$i][9])

        ; Only draw if visible on screen (optimization)
        Local $l_i_MinX = _Min(_Min($l_i_Ax, $l_i_Bx), _Min($l_i_Cx, $l_i_Dx))
        Local $l_i_MaxX = _Max(_Max($l_i_Ax, $l_i_Bx), _Max($l_i_Cx, $l_i_Dx))
        Local $l_i_MinY = _Min(_Min($l_i_Ay, $l_i_By), _Min($l_i_Cy, $l_i_Dy))
        Local $l_i_MaxY = _Max(_Max($l_i_Ay, $l_i_By), _Max($l_i_Cy, $l_i_Dy))

        If $l_i_MaxX >= 0 And $l_i_MinX <= $g_i_MapWidth And $l_i_MaxY >= 0 And $l_i_MinY <= $g_i_MapHeight Then
            ; Draw filled trapezoid using path (NO OUTLINE - exactly like Map_Visualizer)
            Local $l_h_Path = _GDIPlus_PathCreate()
            _GDIPlus_PathAddLine($l_h_Path, $l_i_Ax, $l_i_Ay, $l_i_Bx, $l_i_By)
            _GDIPlus_PathAddLine($l_h_Path, $l_i_Bx, $l_i_By, $l_i_Cx, $l_i_Cy)
            _GDIPlus_PathAddLine($l_h_Path, $l_i_Cx, $l_i_Cy, $l_i_Dx, $l_i_Dy)
            _GDIPlus_PathCloseFigure($l_h_Path)

            ; Fill the path only (no outline)
            _GDIPlus_GraphicsFillPath($g_h_MapGfxCtxt, $l_h_Path, $l_h_Brush)

            ; Cleanup
            _GDIPlus_PathDispose($l_h_Path)
        EndIf

        _GDIPlus_BrushDispose($l_h_Brush)
    Next
EndFunc

Func MapDisplay_DrawTeleports()
    Local $l_h_PenEnter = _GDIPlus_PenCreate($GC_I_MAP_COLOR_TELEPORT_ENTER, 2) ; Green for enter
    Local $l_h_PenExit = _GDIPlus_PenCreate($GC_I_MAP_COLOR_TELEPORT_EXIT, 2)   ; Red for exit
    Local $l_h_PenLink = _GDIPlus_PenCreate($GC_I_MAP_COLOR_TELEPORT_LINK, 1)   ; Cyan for link
    _GDIPlus_PenSetDashStyle($l_h_PenLink, 1) ; Dashed line

    For $i = 0 To UBound($g_amx2_MapTeleports) - 1
        Local $l_i_X1 = MapDisplay_WorldToScreenX($g_amx2_MapTeleports[$i][0])
        Local $l_i_Y1 = MapDisplay_WorldToScreenY($g_amx2_MapTeleports[$i][1])
        Local $l_i_X2 = MapDisplay_WorldToScreenX($g_amx2_MapTeleports[$i][3])
        Local $l_i_Y2 = MapDisplay_WorldToScreenY($g_amx2_MapTeleports[$i][4])

        ; Draw connection line
        _GDIPlus_GraphicsDrawLine($g_h_MapGfxCtxt, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_PenLink)

        ; Draw enter point (green square)
        _GDIPlus_GraphicsDrawRect($g_h_MapGfxCtxt, $l_i_X1 - 4, $l_i_Y1 - 4, 8, 8, $l_h_PenEnter)

        ; Draw exit point (red circle)
        _GDIPlus_GraphicsDrawEllipse($g_h_MapGfxCtxt, $l_i_X2 - 4, $l_i_Y2 - 4, 8, 8, $l_h_PenExit)
    Next

    _GDIPlus_PenDispose($l_h_PenEnter)
    _GDIPlus_PenDispose($l_h_PenExit)
    _GDIPlus_PenDispose($l_h_PenLink)
EndFunc

Func MapDisplay_DrawPath()
    If UBound($g_af2_CurrentPath) < 2 Then Return

    Local $l_h_Pen = _GDIPlus_PenCreate($GC_I_MAP_COLOR_PATH, 3)

    For $i = 1 To UBound($g_af2_CurrentPath) - 1
        Local $l_i_X1 = MapDisplay_WorldToScreenX($g_af2_CurrentPath[$i-1][0])
        Local $l_i_Y1 = MapDisplay_WorldToScreenY($g_af2_CurrentPath[$i-1][1])
        Local $l_i_X2 = MapDisplay_WorldToScreenX($g_af2_CurrentPath[$i][0])
        Local $l_i_Y2 = MapDisplay_WorldToScreenY($g_af2_CurrentPath[$i][1])

        _GDIPlus_GraphicsDrawLine($g_h_MapGfxCtxt, $l_i_X1, $l_i_Y1, $l_i_X2, $l_i_Y2, $l_h_Pen)

        ; Draw waypoint markers
        Local $l_h_BrushWaypoint = _GDIPlus_BrushCreateSolid(0x80FFAA00)
        _GDIPlus_GraphicsFillEllipse($g_h_MapGfxCtxt, $l_i_X2 - 3, $l_i_Y2 - 3, 6, 6, $l_h_BrushWaypoint)
        _GDIPlus_BrushDispose($l_h_BrushWaypoint)
    Next

    ; Draw destination marker (bigger red circle)
    If UBound($g_af2_CurrentPath) > 0 Then
        Local $l_i_LastIdx = UBound($g_af2_CurrentPath) - 1
        Local $l_i_X = MapDisplay_WorldToScreenX($g_af2_CurrentPath[$l_i_LastIdx][0])
        Local $l_i_Y = MapDisplay_WorldToScreenY($g_af2_CurrentPath[$l_i_LastIdx][1])

        Local $l_h_Brush = _GDIPlus_BrushCreateSolid($GC_I_MAP_COLOR_DESTINATION)
        _GDIPlus_GraphicsFillEllipse($g_h_MapGfxCtxt, $l_i_X - 6, $l_i_Y - 6, 12, 12, $l_h_Brush)
        _GDIPlus_BrushDispose($l_h_Brush)
    EndIf

    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func MapDisplay_DrawAgents()
    If Not IsArray($g_amx2_AgentsCache) Then Return
    If UBound($g_amx2_AgentsCache) = 0 Then Return

    For $i = 0 To UBound($g_amx2_AgentsCache) - 1
        ; Skip if this is the player
        If $g_amx2_AgentsCache[$i][0] = $g_i_PlayerID Then ContinueLoop

        Local $l_i_X = MapDisplay_WorldToScreenX($g_amx2_AgentsCache[$i][2])
        Local $l_i_Y = MapDisplay_WorldToScreenY($g_amx2_AgentsCache[$i][3])

        ; Skip if outside visible area
        If $l_i_X < -10 Or $l_i_X > $g_i_MapWidth + 10 Or $l_i_Y < -10 Or $l_i_Y > $g_i_MapHeight + 10 Then ContinueLoop

        ; Determine color based on type and allegiance
        Local $l_i_Color = 0xFFFFFFFF ; Default white
        Local $l_f_Size = 2 ; Default size
        Local $l_s_Shape = "circle" ; Default shape

        ; Check type first
        If BitAND($g_amx2_AgentsCache[$i][4], $GC_I_AGENT_TYPE_ITEM) Then
            $l_i_Color = $GC_I_MAP_COLOR_ITEM ; White for items
            $l_s_Shape = "square"
            $l_f_Size = 2
        ElseIf BitAND($g_amx2_AgentsCache[$i][4], $GC_I_AGENT_TYPE_GADGET) Then
            $l_i_Color = $GC_I_MAP_COLOR_GADGET ; Yellow for gadgets
            $l_s_Shape = "diamond"
            $l_f_Size = 2
        ElseIf BitAND($g_amx2_AgentsCache[$i][4], $GC_I_AGENT_TYPE_LIVING) Then
            ; Living agent - check allegiance
            Switch $g_amx2_AgentsCache[$i][5]
                Case $GC_I_AGENT_ALLEGIANCE_ENEMY
                    $l_i_Color = $GC_I_MAP_COLOR_ENEMY ; Red
                    $l_s_Shape = "circle"
                    $l_f_Size = 2.5
                Case $GC_I_AGENT_ALLEGIANCE_ALLY
                    $l_i_Color = $GC_I_MAP_COLOR_ALLY ; Green
                    $l_s_Shape = "circle"
                    $l_f_Size = 2.5
                Case $GC_I_AGENT_ALLEGIANCE_SPIRIT
                    $l_i_Color = $GC_I_MAP_COLOR_SPIRIT ; Blue
                    $l_s_Shape = "triangle"
                    $l_f_Size = 2.5
                Case $GC_I_AGENT_ALLEGIANCE_MINION
                    $l_i_Color = $GC_I_MAP_COLOR_MINION ; Gray
                    $l_s_Shape = "diamond"
                    $l_f_Size = 2.5
                Case $GC_I_AGENT_ALLEGIANCE_NPC
                    $l_i_Color = $GC_I_MAP_COLOR_NPC ; Light green
                    $l_s_Shape = "square"
                    $l_f_Size = 2.5
            EndSwitch
        EndIf

        ; Draw the agent
        Local $l_h_Brush = _GDIPlus_BrushCreateSolid($l_i_Color)

        Switch $l_s_Shape
            Case "circle"
                _GDIPlus_GraphicsFillEllipse($g_h_MapGfxCtxt, $l_i_X - $l_f_Size, $l_i_Y - $l_f_Size, $l_f_Size * 2, $l_f_Size * 2, $l_h_Brush)

            Case "square"
                _GDIPlus_GraphicsFillRect($g_h_MapGfxCtxt, $l_i_X - $l_f_Size, $l_i_Y - $l_f_Size, $l_f_Size * 2, $l_f_Size * 2, $l_h_Brush)

            Case "diamond"
                ; Create 2D array with exactly 2 columns
                Local $l_af2_Points[5][2] ; 5 points to close polygon
                $l_af2_Points[0][0] = 4   ; Number of points
                $l_af2_Points[0][1] = 0   ; Not used
                $l_af2_Points[1][0] = $l_i_X
                $l_af2_Points[1][1] = $l_i_Y - $l_f_Size * 1.5
                $l_af2_Points[2][0] = $l_i_X + $l_f_Size * 1.5
                $l_af2_Points[2][1] = $l_i_Y
                $l_af2_Points[3][0] = $l_i_X
                $l_af2_Points[3][1] = $l_i_Y + $l_f_Size * 1.5
                $l_af2_Points[4][0] = $l_i_X - $l_f_Size * 1.5
                $l_af2_Points[4][1] = $l_i_Y

                _GDIPlus_GraphicsFillPolygon($g_h_MapGfxCtxt, $l_af2_Points, $l_h_Brush)

            Case "triangle"
                ; Create 2D array with exactly 2 columns
                Local $l_af2_Points[4][2] ; 4 points (3 + counter)
                $l_af2_Points[0][0] = 3   ; Number of points
                $l_af2_Points[0][1] = 0   ; Not used
                $l_af2_Points[1][0] = $l_i_X
                $l_af2_Points[1][1] = $l_i_Y - $l_f_Size * 1.5
                $l_af2_Points[2][0] = $l_i_X + $l_f_Size * 1.3
                $l_af2_Points[2][1] = $l_i_Y + $l_f_Size
                $l_af2_Points[3][0] = $l_i_X - $l_f_Size * 1.3
                $l_af2_Points[3][1] = $l_i_Y + $l_f_Size

                _GDIPlus_GraphicsFillPolygon($g_h_MapGfxCtxt, $l_af2_Points, $l_h_Brush)
        EndSwitch

        _GDIPlus_BrushDispose($l_h_Brush)
    Next
EndFunc

Func MapDisplay_DrawPlayer()
    Local $l_i_X = MapDisplay_WorldToScreenX($g_f_PlayerX)
    Local $l_i_Y = MapDisplay_WorldToScreenY($g_f_PlayerY)

    ; Draw player as a bright green circle (bigger than other agents)
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid($GC_I_MAP_COLOR_PLAYER)
    _GDIPlus_GraphicsFillEllipse($g_h_MapGfxCtxt, $l_i_X - 6, $l_i_Y - 6, 12, 12, $l_h_Brush)

    ; Draw white border for visibility
    Local $l_h_Pen = _GDIPlus_PenCreate(0xFFFFFFFF, 2)
    _GDIPlus_GraphicsDrawEllipse($g_h_MapGfxCtxt, $l_i_X - 6, $l_i_Y - 6, 12, 12, $l_h_Pen)

    _GDIPlus_BrushDispose($l_h_Brush)
    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func MapDisplay_DrawInfo()
    Local $l_h_Brush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    Local $l_h_Format = _GDIPlus_StringFormatCreate()
    Local $l_h_Family = _GDIPlus_FontFamilyCreate("Consolas")
    Local $l_h_Font = _GDIPlus_FontCreate($l_h_Family, 9)

    Local $l_s_Info = StringFormat("Map: %d | Pos: %d, %d", _
        $g_i_CurrentMapID, Round($g_f_PlayerX), Round($g_f_PlayerY))

    If $g_i_SelectedLayer >= 0 Then
        $l_s_Info &= " | Layer: " & $g_i_SelectedLayer
    EndIf

    ; Add follow mode indicator
    If $g_b_FollowPlayer Then
        $l_s_Info &= " | Following Player"
    EndIf

    ; Add agent count
    If IsArray($g_amx2_AgentsCache) Then
        $l_s_Info &= " | Agents: " & UBound($g_amx2_AgentsCache)
    EndIf

    Local $l_t_Layout = _GDIPlus_RectFCreate(5, 5, $g_i_MapWidth - 10, 20)
    _GDIPlus_GraphicsDrawStringEx($g_h_MapGfxCtxt, $l_s_Info, $l_h_Font, $l_t_Layout, $l_h_Format, $l_h_Brush)

    _GDIPlus_FontDispose($l_h_Font)
    _GDIPlus_FontFamilyDispose($l_h_Family)
    _GDIPlus_StringFormatDispose($l_h_Format)
    _GDIPlus_BrushDispose($l_h_Brush)
EndFunc

Func MapDisplay_DrawButtons()
    Local $l_h_Format = _GDIPlus_StringFormatCreate()
    _GDIPlus_StringFormatSetAlign($l_h_Format, 1) ; Center align
    _GDIPlus_StringFormatSetLineAlign($l_h_Format, 1) ; Center vertically

    Local $l_h_Family = _GDIPlus_FontFamilyCreate("Arial")
    Local $l_h_FontLarge = _GDIPlus_FontCreate($l_h_Family, 16, 1) ; Bold for +/-
    Local $l_h_FontSmall = _GDIPlus_FontCreate($l_h_Family, 9)

    ; Button 0: Center (left)
    Local $l_s_Text = $g_b_FollowPlayer ? "Center Map" : "Center Player"
    MapDisplay_DrawButton(0, $l_s_Text, $l_h_FontSmall, $l_h_Format)

    ; Button 1: Zoom In (middle)
    MapDisplay_DrawButton(1, "+", $l_h_FontLarge, $l_h_Format)

    ; Button 2: Zoom Out (right)
    MapDisplay_DrawButton(2, "-", $l_h_FontLarge, $l_h_Format)

    _GDIPlus_FontDispose($l_h_FontLarge)
    _GDIPlus_FontDispose($l_h_FontSmall)
    _GDIPlus_FontFamilyDispose($l_h_Family)
    _GDIPlus_StringFormatDispose($l_h_Format)
EndFunc

Func MapDisplay_DrawButton($a_i_Button, $a_s_Text, $a_h_Font, $a_h_Format)
    Local $l_i_X = $g_amx2_Buttons[$a_i_Button][0]
    Local $l_i_Y = $g_amx2_Buttons[$a_i_Button][1]
    Local $l_i_Width = $g_amx2_Buttons[$a_i_Button][2]
    Local $l_i_Height = $g_amx2_Buttons[$a_i_Button][3]
    Local $l_b_Hover = $g_amx2_Buttons[$a_i_Button][4]

    ; Button background color with transparency
    Local $l_i_BgColor = $l_b_Hover ? 0xCC505050 : 0xCC303030  ; CC = 80% opacity
    Local $l_h_BrushBg = _GDIPlus_BrushCreateSolid($l_i_BgColor)

    ; Button border color
    Local $l_i_BorderColor = $l_b_Hover ? 0xFF808080 : 0xFF606060
    Local $l_h_Pen = _GDIPlus_PenCreate($l_i_BorderColor, 2)

    ; Draw button background
    _GDIPlus_GraphicsFillRect($g_h_MapGfxCtxt, $l_i_X, $l_i_Y, $l_i_Width, $l_i_Height, $l_h_BrushBg)

    ; Draw button border
    _GDIPlus_GraphicsDrawRect($g_h_MapGfxCtxt, $l_i_X, $l_i_Y, $l_i_Width, $l_i_Height, $l_h_Pen)

    ; Draw button text
    Local $l_h_BrushText = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    Local $l_t_Layout = _GDIPlus_RectFCreate($l_i_X, $l_i_Y, $l_i_Width, $l_i_Height)
    _GDIPlus_GraphicsDrawStringEx($g_h_MapGfxCtxt, $a_s_Text, $a_h_Font, $l_t_Layout, $a_h_Format, $l_h_BrushText)

    _GDIPlus_BrushDispose($l_h_BrushBg)
    _GDIPlus_BrushDispose($l_h_BrushText)
    _GDIPlus_PenDispose($l_h_Pen)
EndFunc

Func MapDisplay_WorldToScreenX($a_f_WorldX)
    Return ($a_f_WorldX - $g_f_MapMinX) * $g_f_MapZoom + $g_f_MapOffsetX
EndFunc

Func MapDisplay_WorldToScreenY($a_f_WorldY)
    ; Invert Y axis for correct display (GW coordinates vs screen coordinates)
    Return $g_i_MapHeight - (($a_f_WorldY - $g_f_MapMinY) * $g_f_MapZoom + $g_f_MapOffsetY)
EndFunc

Func MapDisplay_FitToMap()
    If $g_f_MapMaxX = $g_f_MapMinX Or $g_f_MapMaxY = $g_f_MapMinY Then Return

    Local $l_f_MapWidth = $g_f_MapMaxX - $g_f_MapMinX
    Local $l_f_MapHeight = $g_f_MapMaxY - $g_f_MapMinY

    ; Calculate zoom to fit with padding
    Local $l_f_Padding = 20
    Local $l_f_ZoomX = ($g_i_MapWidth - $l_f_Padding) / $l_f_MapWidth
    Local $l_f_ZoomY = ($g_i_MapHeight - $l_f_Padding) / $l_f_MapHeight
    $g_f_MapZoom = _Min($l_f_ZoomX, $l_f_ZoomY)

    ; Center the map
    Local $l_f_MapCenterX = ($g_f_MapMinX + $g_f_MapMaxX) / 2
    Local $l_f_MapCenterY = ($g_f_MapMinY + $g_f_MapMaxY) / 2

    $g_f_MapOffsetX = ($g_i_MapWidth / 2) - ($l_f_MapCenterX - $g_f_MapMinX) * $g_f_MapZoom
    $g_f_MapOffsetY = ($g_i_MapHeight / 2) - ($l_f_MapCenterY - $g_f_MapMinY) * $g_f_MapZoom
EndFunc

Func MapDisplay_AutoCenter()
    ; Center on player position if near edge
    Local $l_f_ScreenX = MapDisplay_WorldToScreenX($g_f_PlayerX)
    Local $l_f_ScreenY = MapDisplay_WorldToScreenY($g_f_PlayerY)

    Local $l_f_Margin = 50 ; Pixels from edge before recentering

    If $l_f_ScreenX < $l_f_Margin Or $l_f_ScreenX > $g_i_MapWidth - $l_f_Margin Or _
       $l_f_ScreenY < $l_f_Margin Or $l_f_ScreenY > $g_i_MapHeight - $l_f_Margin Then

        ; Recenter on player
        MapDisplay_CenterOnPlayer()
    EndIf
EndFunc

Func MapDisplay_Update()
    ; Auto-update from game if functions are available
    If $g_b_MapInitialized Then
        ; Try to load map data from game
        MapDisplay_LoadFromGame()
        ; Always render to update display
        MapDisplay_Render()
    EndIf
EndFunc

; ============================================================================
; Optimize zoom functions for better reactivity
; ============================================================================
Func MapDisplay_ZoomIn()
    Local $l_f_OldZoom = $g_f_MapZoom
    $g_f_MapZoom *= 1.5 ; Increase zoom factor for better reactivity
    If $g_f_MapZoom > 50 Then $g_f_MapZoom = 50

    ; Zoom to center of view
    Local $l_f_CenterX = $g_i_MapWidth / 2
    Local $l_f_CenterY = $g_i_MapHeight / 2
    Local $l_f_ZoomRatio = $g_f_MapZoom / $l_f_OldZoom
    $g_f_MapOffsetX = $l_f_CenterX - ($l_f_CenterX - $g_f_MapOffsetX) * $l_f_ZoomRatio
    $g_f_MapOffsetY = $l_f_CenterY - ($l_f_CenterY - $g_f_MapOffsetY) * $l_f_ZoomRatio

    ; Force immediate render
    MapDisplay_Render()
EndFunc

Func MapDisplay_ZoomOut()
    Local $l_f_OldZoom = $g_f_MapZoom
    $g_f_MapZoom /= 1.5 ; Increase factor for better reactivity
    If $g_f_MapZoom < 0.01 Then $g_f_MapZoom = 0.01

    ; Zoom from center of view
    Local $l_f_CenterX = $g_i_MapWidth / 2
    Local $l_f_CenterY = $g_i_MapHeight / 2
    Local $l_f_ZoomRatio = $g_f_MapZoom / $l_f_OldZoom
    $g_f_MapOffsetX = $l_f_CenterX - ($l_f_CenterX - $g_f_MapOffsetX) * $l_f_ZoomRatio
    $g_f_MapOffsetY = $l_f_CenterY - ($l_f_CenterY - $g_f_MapOffsetY) * $l_f_ZoomRatio

    ; Force immediate render
    MapDisplay_Render()
EndFunc

Func MapDisplay_SetZoom($a_f_Zoom)
    $g_f_MapZoom = _Max(0.01, _Min(50, $a_f_Zoom))
    MapDisplay_Render()
EndFunc

Func MapDisplay_Cleanup()
    AdlibUnRegister("MapDisplay_Update")
    AdlibUnRegister("MapDisplay_CheckMouse")

    If $g_h_MapGfxCtxt Then _GDIPlus_GraphicsDispose($g_h_MapGfxCtxt)
    If $g_h_MapBitmap Then _GDIPlus_BitmapDispose($g_h_MapBitmap)
    If $g_h_MapGraphics Then _GDIPlus_GraphicsDispose($g_h_MapGraphics)

    $g_h_MapGfxCtxt = 0
    $g_h_MapBitmap = 0
    $g_h_MapGraphics = 0
    $g_b_MapInitialized = False
EndFunc

; ============================================================================
; Helper functions for external use
; ============================================================================

Func MapDisplay_GetCurrentMapID()
    Return $g_i_CurrentMapID
EndFunc

Func MapDisplay_IsInitialized()
    Return $g_b_MapInitialized
EndFunc

Func MapDisplay_ShowPath($a_b_Show = True)
    $g_b_ShowPath = $a_b_Show
    MapDisplay_Render()
EndFunc

Func MapDisplay_ShowPlayer($a_b_Show = True)
    $g_b_ShowPlayer = $a_b_Show
    MapDisplay_Render()
EndFunc

Func MapDisplay_ShowTeleports($a_b_Show = True)
    $g_b_ShowTeleports = $a_b_Show
    MapDisplay_Render()
EndFunc

Func MapDisplay_ShowAgents($a_b_Show = True)
    $g_b_ShowAgents = $a_b_Show
    MapDisplay_Render()
EndFunc

; ============================================================================
; Clean up on script exit
; ============================================================================
Func MapDisplay_OnExit()
    MapDisplay_Cleanup()
    _GDIPlus_Shutdown()
EndFunc

OnAutoItExitRegister("MapDisplay_OnExit")