#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <AutoItConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>
#include <GDIPlus.au3>
#include <Misc.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiScrollBars.au3>
#include <WinAPISys.au3>

; Initialisation GDI+
_GDIPlus_Startup()

; Variables globales
Global $g_hGUI, $g_hGraphic, $g_hBitmap, $g_hBuffer
Global $g_iWidth = 1400, $g_iHeight = 800
Global $g_iViewWidth = 1000, $g_iViewHeight = 700

; Données de la map
Global $g_aTrapezoids[0][11]  ; x1,y1,x2,y2,x3,y3,x4,y4,bottom,top,flags
Global $g_aConnections[0][6]  ; trap1,trap2,flags,distance,min,max
Global $g_aTeleports[0][6]    ; source,dest,x,y,z,angle
Global $g_aAABBs[0][7]        ; minx,miny,minz,maxx,maxy,maxz,flags
Global $g_aPoints[0][5]       ; x,y,z,type,data
Global $g_aPortals[0][6]      ; zone1,zone2,x,y,width,height

; Variables de vue
Global $g_fZoom = 1.0
Global $g_iOffsetX = 0, $g_iOffsetY = 0
Global $g_bPanning = False
Global $g_iPanStartX, $g_iPanStartY

; Variables d'édition
Global $g_sCurrentFile = ""
Global $g_bModified = False
Global $g_iEditMode = 0  ; 0=Select, 1=Add Trap, 2=Add Conn, 3=Add Point, etc.
Global $g_iSelectedType = 0  ; Type d'élément sélectionné
Global $g_iSelectedIndex = -1  ; Index de l'élément sélectionné
Global $g_bDrawing = False
Global $g_aTempPoints[4][2]  ; Pour dessiner un nouveau trapézoïde
Global $g_iTempPointCount = 0

; Couleurs
Global $g_cBackground = 0xFF1E1E1E
Global $g_cGrid = 0xFF2A2A2A
Global $g_cTrapezoid = 0x8000FF00
Global $g_cTrapezoidSelected = 0xFFFFFF00
Global $g_cConnection = 0xFF00FFFF
Global $g_cTeleport = 0xFFFF00FF
Global $g_cAABB = 0x80FFA500
Global $g_cPoint = 0xFFFF0000
Global $g_cPortal = 0x800080FF

; GUI principale
$g_hGUI = GUICreate("Cache Map Editor - Visual", $g_iWidth, $g_iHeight)

; Menu
Local $mFile = GUICtrlCreateMenu("&Fichier")
Local $mNew = GUICtrlCreateMenuItem("&Nouveau" & @TAB & "Ctrl+N", $mFile)
Local $mOpen = GUICtrlCreateMenuItem("&Ouvrir..." & @TAB & "Ctrl+O", $mFile)
Local $mSave = GUICtrlCreateMenuItem("&Enregistrer" & @TAB & "Ctrl+S", $mFile)
Local $mSaveAs = GUICtrlCreateMenuItem("Enregistrer &sous...", $mFile)
GUICtrlCreateMenuItem("", $mFile)
Local $mExit = GUICtrlCreateMenuItem("&Quitter", $mFile)

Local $mEdit = GUICtrlCreateMenu("&Edition")
Local $mUndo = GUICtrlCreateMenuItem("&Annuler" & @TAB & "Ctrl+Z", $mEdit)
Local $mDelete = GUICtrlCreateMenuItem("&Supprimer" & @TAB & "Del", $mEdit)
GUICtrlCreateMenuItem("", $mEdit)
Local $mSelectAll = GUICtrlCreateMenuItem("Sélectionner &tout" & @TAB & "Ctrl+A", $mEdit)

Local $mView = GUICtrlCreateMenu("&Affichage")
Local $mZoomIn = GUICtrlCreateMenuItem("Zoom &avant" & @TAB & "+", $mView)
Local $mZoomOut = GUICtrlCreateMenuItem("Zoom a&rrière" & @TAB & "-", $mView)
Local $mZoomReset = GUICtrlCreateMenuItem("Zoom &100%" & @TAB & "0", $mView)
GUICtrlCreateMenuItem("", $mView)
Local $mCenter = GUICtrlCreateMenuItem("&Centrer" & @TAB & "C", $mView)
Local $mGrid = GUICtrlCreateMenuItem("&Grille" & @TAB & "G", $mView)
GUICtrlSetState($mGrid, $GUI_CHECKED)

Local $mTools = GUICtrlCreateMenu("&Outils")
Local $mVisualize = GUICtrlCreateMenuItem("&Visualiser dans Cache_Visualizer", $mTools)
Local $mValidate = GUICtrlCreateMenuItem("&Valider la map", $mTools)

; Panneau de contrôle (droite)
GUICtrlCreateGroup("Mode", $g_iViewWidth + 10, 10, 380, 100)
Local $rSelect = GUICtrlCreateRadio("Sélection (S)", $g_iViewWidth + 20, 30, 100, 20)
Local $rAddTrap = GUICtrlCreateRadio("Ajouter Trapézoïde (T)", $g_iViewWidth + 20, 50, 150, 20)
Local $rAddConn = GUICtrlCreateRadio("Ajouter Connection (C)", $g_iViewWidth + 20, 70, 150, 20)
Local $rAddPoint = GUICtrlCreateRadio("Ajouter Point (P)", $g_iViewWidth + 180, 30, 120, 20)
Local $rAddTele = GUICtrlCreateRadio("Ajouter Téléport", $g_iViewWidth + 180, 50, 120, 20)
Local $rAddPortal = GUICtrlCreateRadio("Ajouter Portail", $g_iViewWidth + 180, 70, 120, 20)
GUICtrlSetState($rSelect, $GUI_CHECKED)

; Panneau d'information
GUICtrlCreateGroup("Élément sélectionné", $g_iViewWidth + 10, 120, 380, 300)
Local $lblInfo = GUICtrlCreateLabel("Aucun élément sélectionné", $g_iViewWidth + 20, 140, 360, 270)

; Panneau de propriétés
GUICtrlCreateGroup("Propriétés", $g_iViewWidth + 10, 430, 380, 200)
GUICtrlCreateLabel("Bottom:", $g_iViewWidth + 20, 450, 50, 20)
Local $inpBottom = GUICtrlCreateInput("0", $g_iViewWidth + 70, 450, 80, 20)
GUICtrlCreateLabel("Top:", $g_iViewWidth + 160, 450, 30, 20)
Local $inpTop = GUICtrlCreateInput("100", $g_iViewWidth + 190, 450, 80, 20)

GUICtrlCreateLabel("Flags:", $g_iViewWidth + 20, 480, 50, 20)
Local $inpFlags = GUICtrlCreateInput("0", $g_iViewWidth + 70, 480, 80, 20)
GUICtrlCreateLabel("Type:", $g_iViewWidth + 160, 480, 30, 20)
Local $cmbType = GUICtrlCreateCombo("", $g_iViewWidth + 190, 480, 100, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData($cmbType, "Normal|Eau|Lave|Téléport|Spawn", "Normal")

Local $btnApply = GUICtrlCreateButton("Appliquer", $g_iViewWidth + 20, 520, 100, 30)
Local $btnDelete = GUICtrlCreateButton("Supprimer", $g_iViewWidth + 130, 520, 100, 30)
Local $btnDuplicate = GUICtrlCreateButton("Dupliquer", $g_iViewWidth + 240, 520, 100, 30)

; Statistiques
GUICtrlCreateGroup("Statistiques", $g_iViewWidth + 10, 640, 380, 100)
Local $lblStats = GUICtrlCreateLabel("", $g_iViewWidth + 20, 660, 360, 70)

; Barre de statut
Local $lblStatus = GUICtrlCreateLabel("Prêt", 0, $g_iHeight - 50, $g_iWidth, 20, $SS_SUNKEN)
Local $lblCoords = GUICtrlCreateLabel("X: 0  Y: 0", 0, $g_iHeight - 30, 200, 20)
Local $lblZoom = GUICtrlCreateLabel("Zoom: 100%", 210, $g_iHeight - 30, 100, 20)

; Zone de dessin
Local $picCanvas = GUICtrlCreatePic("", 0, 0, $g_iViewWidth, $g_iViewHeight)

; Initialisation graphique
$g_hGraphic = _GDIPlus_GraphicsCreateFromHWND(GUICtrlGetHandle($picCanvas))
$g_hBitmap = _GDIPlus_BitmapCreateFromGraphics($g_iViewWidth, $g_iViewHeight, $g_hGraphic)
$g_hBuffer = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)

; Configuration graphique
_GDIPlus_GraphicsSetSmoothingMode($g_hBuffer, 2)
_GDIPlus_GraphicsSetTextRenderingHint($g_hBuffer, 4)

GUISetState(@SW_SHOW)

; Timer pour le rendu
AdlibRegister("Render", 50)

; Boucle principale
While 1
    Local $msg = GUIGetMsg()
    Local $aCursorInfo = GUIGetCursorInfo($g_hGUI)

    ; Mise à jour des coordonnées souris
    If IsArray($aCursorInfo) Then
        If $aCursorInfo[0] < $g_iViewWidth And $aCursorInfo[1] < $g_iViewHeight Then
            Local $worldX = ($aCursorInfo[0] - $g_iOffsetX) / $g_fZoom
            Local $worldY = ($aCursorInfo[1] - $g_iOffsetY) / $g_fZoom
            GUICtrlSetData($lblCoords, StringFormat("X: %d  Y: %d", $worldX, $worldY))
        EndIf
    EndIf

    Switch $msg
        Case $GUI_EVENT_CLOSE, $mExit
            ExitProgram()

        Case $mNew
            NewMap()

        Case $mOpen
            OpenMap()

        Case $mSave
            SaveMap()

        Case $mSaveAs
            SaveMapAs()

        Case $mVisualize
            VisualizeMap()

        Case $mValidate
            ValidateMap()

        Case $mZoomIn
            ZoomIn()

        Case $mZoomOut
            ZoomOut()

        Case $mZoomReset
            ZoomReset()

        Case $mCenter
            CenterView()

        Case $mDelete, $btnDelete
            DeleteSelected()

        Case $rSelect
            $g_iEditMode = 0
            UpdateStatus("Mode: Sélection")

        Case $rAddTrap
            $g_iEditMode = 1
            $g_iTempPointCount = 0
            UpdateStatus("Mode: Ajout de trapézoïde - Cliquez 4 points")

        Case $rAddConn
            $g_iEditMode = 2
            UpdateStatus("Mode: Ajout de connection - Cliquez 2 trapézoïdes")

        Case $rAddPoint
            $g_iEditMode = 3
            UpdateStatus("Mode: Ajout de point - Cliquez pour placer")

        Case $rAddTele
            $g_iEditMode = 4
            UpdateStatus("Mode: Ajout de téléport")

        Case $rAddPortal
            $g_iEditMode = 5
            UpdateStatus("Mode: Ajout de portail")

        Case $btnApply
            ApplyProperties()

        Case $btnDuplicate
            DuplicateSelected()

        Case $GUI_EVENT_PRIMARYDOWN
            HandleMouseDown($aCursorInfo)

        Case $GUI_EVENT_PRIMARYUP
            HandleMouseUp($aCursorInfo)

        Case $GUI_EVENT_MOUSEMOVE
            HandleMouseMove($aCursorInfo)

;~         Case $GUI_EVENT_MOUSEWHEEL
            ; Zoom avec la molette
    EndSwitch

    ; Mise à jour des statistiques
    UpdateStats()
WEnd

; Fonction de rendu
Func Render()
    ; Effacer
    _GDIPlus_GraphicsClear($g_hBuffer, $g_cBackground)

    ; Dessiner la grille
    DrawGrid()

    ; Dessiner les éléments
    DrawAABBs()
    DrawPortals()
    DrawConnections()
    DrawTrapezoids()
    DrawTeleports()
    DrawPoints()

    ; Dessiner le trapézoïde en cours de création
    If $g_iEditMode = 1 And $g_iTempPointCount > 0 Then
        DrawTempTrapezoid()
    EndIf

    ; Afficher
    _GDIPlus_GraphicsDrawImage($g_hGraphic, $g_hBitmap, 0, 0)
EndFunc

Func DrawGrid()
    Local $hPen = _GDIPlus_PenCreate($g_cGrid, 1)

    Local $gridSize = 50 * $g_fZoom
    Local $startX = Mod($g_iOffsetX, $gridSize)
    Local $startY = Mod($g_iOffsetY, $gridSize)

    ; Lignes verticales
    For $x = $startX To $g_iViewWidth Step $gridSize
        _GDIPlus_GraphicsDrawLine($g_hBuffer, $x, 0, $x, $g_iViewHeight, $hPen)
    Next

    ; Lignes horizontales
    For $y = $startY To $g_iViewHeight Step $gridSize
        _GDIPlus_GraphicsDrawLine($g_hBuffer, 0, $y, $g_iViewWidth, $y, $hPen)
    Next

    _GDIPlus_PenDispose($hPen)
EndFunc

Func DrawTrapezoids()
    Local $hPen = _GDIPlus_PenCreate($g_cTrapezoid, 2)
    Local $hPenSelected = _GDIPlus_PenCreate($g_cTrapezoidSelected, 3)
    Local $hBrush = _GDIPlus_BrushCreateSolid($g_cTrapezoid)
    Local $hFont = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Arial"), 10)
    Local $hStringFormat = _GDIPlus_StringFormatCreate()
    Local $hBrushText = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)

    For $i = 0 To UBound($g_aTrapezoids) - 1
        Local $points[5][2]
        $points[0][0] = 4  ; Nombre de points

        ; Convertir les coordonnées monde en coordonnées écran
        For $j = 0 To 3
            $points[$j + 1][0] = $g_aTrapezoids[$i][$j * 2] * $g_fZoom + $g_iOffsetX
            $points[$j + 1][1] = $g_aTrapezoids[$i][$j * 2 + 1] * $g_fZoom + $g_iOffsetY
        Next

        ; Dessiner le polygone
        If $g_iSelectedType = 1 And $g_iSelectedIndex = $i Then
            _GDIPlus_GraphicsDrawPolygon($g_hBuffer, $points, $hPenSelected)
        Else
            _GDIPlus_GraphicsDrawPolygon($g_hBuffer, $points, $hPen)
        EndIf

        ; Afficher l'ID au centre
        Local $centerX = ($points[1][0] + $points[2][0] + $points[3][0] + $points[4][0]) / 4
        Local $centerY = ($points[1][1] + $points[2][1] + $points[3][1] + $points[4][1]) / 4

        Local $tLayout = _GDIPlus_RectFCreate($centerX - 20, $centerY - 10, 40, 20)
        _GDIPlus_GraphicsDrawStringEx($g_hBuffer, $i, $hFont, $tLayout, $hStringFormat, $hBrushText)
    Next

    _GDIPlus_PenDispose($hPen)
    _GDIPlus_PenDispose($hPenSelected)
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_FontDispose($hFont)
    _GDIPlus_StringFormatDispose($hStringFormat)
    _GDIPlus_BrushDispose($hBrushText)
EndFunc

Func DrawConnections()
    Local $hPen = _GDIPlus_PenCreate($g_cConnection, 2)
    Local $hBrush = _GDIPlus_BrushCreateSolid($g_cConnection)

    For $i = 0 To UBound($g_aConnections) - 1
        Local $trap1 = $g_aConnections[$i][0]
        Local $trap2 = $g_aConnections[$i][1]

        If $trap1 < UBound($g_aTrapezoids) And $trap2 < UBound($g_aTrapezoids) Then
            ; Calculer les centres des trapézoïdes
            Local $x1 = ($g_aTrapezoids[$trap1][0] + $g_aTrapezoids[$trap1][2] + _
                        $g_aTrapezoids[$trap1][4] + $g_aTrapezoids[$trap1][6]) / 4
            Local $y1 = ($g_aTrapezoids[$trap1][1] + $g_aTrapezoids[$trap1][3] + _
                        $g_aTrapezoids[$trap1][5] + $g_aTrapezoids[$trap1][7]) / 4

            Local $x2 = ($g_aTrapezoids[$trap2][0] + $g_aTrapezoids[$trap2][2] + _
                        $g_aTrapezoids[$trap2][4] + $g_aTrapezoids[$trap2][6]) / 4
            Local $y2 = ($g_aTrapezoids[$trap2][1] + $g_aTrapezoids[$trap2][3] + _
                        $g_aTrapezoids[$trap2][5] + $g_aTrapezoids[$trap2][7]) / 4

            ; Convertir en coordonnées écran
            $x1 = $x1 * $g_fZoom + $g_iOffsetX
            $y1 = $y1 * $g_fZoom + $g_iOffsetY
            $x2 = $x2 * $g_fZoom + $g_iOffsetX
            $y2 = $y2 * $g_fZoom + $g_iOffsetY

            ; Dessiner la ligne
            _GDIPlus_GraphicsDrawLine($g_hBuffer, $x1, $y1, $x2, $y2, $hPen)

            ; Dessiner une flèche au milieu
            Local $midX = ($x1 + $x2) / 2
            Local $midY = ($y1 + $y2) / 2
            _GDIPlus_GraphicsFillEllipse($g_hBuffer, $midX - 3, $midY - 3, 6, 6, $hBrush)
        EndIf
    Next

    _GDIPlus_PenDispose($hPen)
    _GDIPlus_BrushDispose($hBrush)
EndFunc

Func DrawPoints()
    Local $hBrush = _GDIPlus_BrushCreateSolid($g_cPoint)

    For $i = 0 To UBound($g_aPoints) - 1
        Local $x = $g_aPoints[$i][0] * $g_fZoom + $g_iOffsetX
        Local $y = $g_aPoints[$i][1] * $g_fZoom + $g_iOffsetY

        _GDIPlus_GraphicsFillEllipse($g_hBuffer, $x - 5, $y - 5, 10, 10, $hBrush)
    Next

    _GDIPlus_BrushDispose($hBrush)
EndFunc

Func DrawTeleports()
    Local $hPen = _GDIPlus_PenCreate($g_cTeleport, 2)
    Local $hBrush = _GDIPlus_BrushCreateSolid($g_cTeleport)

    For $i = 0 To UBound($g_aTeleports) - 1
        Local $x = $g_aTeleports[$i][2] * $g_fZoom + $g_iOffsetX
        Local $y = $g_aTeleports[$i][3] * $g_fZoom + $g_iOffsetY

        ; Dessiner un losange pour les téléports
        Local $points[5][2]
        $points[0][0] = 4
        $points[1][0] = $x
        $points[1][1] = $y - 10
        $points[2][0] = $x + 10
        $points[2][1] = $y
        $points[3][0] = $x
        $points[3][1] = $y + 10
        $points[4][0] = $x - 10
        $points[4][1] = $y

        _GDIPlus_GraphicsDrawPolygon($g_hBuffer, $points, $hPen)
    Next

    _GDIPlus_PenDispose($hPen)
    _GDIPlus_BrushDispose($hBrush)
EndFunc

Func DrawAABBs()
    Local $hPen = _GDIPlus_PenCreate($g_cAABB, 1)
    Local $hBrush = _GDIPlus_BrushCreateSolid($g_cAABB)

    For $i = 0 To UBound($g_aAABBs) - 1
        Local $x = $g_aAABBs[$i][0] * $g_fZoom + $g_iOffsetX
        Local $y = $g_aAABBs[$i][1] * $g_fZoom + $g_iOffsetY
        Local $w = ($g_aAABBs[$i][3] - $g_aAABBs[$i][0]) * $g_fZoom
        Local $h = ($g_aAABBs[$i][4] - $g_aAABBs[$i][1]) * $g_fZoom

        _GDIPlus_GraphicsFillRect($g_hBuffer, $x, $y, $w, $h, $hBrush)
        _GDIPlus_GraphicsDrawRect($g_hBuffer, $x, $y, $w, $h, $hPen)
    Next

    _GDIPlus_PenDispose($hPen)
    _GDIPlus_BrushDispose($hBrush)
EndFunc

Func DrawPortals()
    Local $hPen = _GDIPlus_PenCreate($g_cPortal, 2)
    Local $hBrush = _GDIPlus_BrushCreateSolid($g_cPortal)

    For $i = 0 To UBound($g_aPortals) - 1
        Local $x = $g_aPortals[$i][2] * $g_fZoom + $g_iOffsetX
        Local $y = $g_aPortals[$i][3] * $g_fZoom + $g_iOffsetY
        Local $w = $g_aPortals[$i][4] * $g_fZoom
        Local $h = $g_aPortals[$i][5] * $g_fZoom

        _GDIPlus_GraphicsFillRect($g_hBuffer, $x - $w/2, $y - $h/2, $w, $h, $hBrush)
        _GDIPlus_GraphicsDrawRect($g_hBuffer, $x - $w/2, $y - $h/2, $w, $h, $hPen)
    Next

    _GDIPlus_PenDispose($hPen)
    _GDIPlus_BrushDispose($hBrush)
EndFunc

Func DrawTempTrapezoid()
    Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2)
    Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFF0000)

    For $i = 0 To $g_iTempPointCount - 1
        Local $x = $g_aTempPoints[$i][0] * $g_fZoom + $g_iOffsetX
        Local $y = $g_aTempPoints[$i][1] * $g_fZoom + $g_iOffsetY
        _GDIPlus_GraphicsFillEllipse($g_hBuffer, $x - 3, $y - 3, 6, 6, $hBrush)

        If $i > 0 Then
            Local $prevX = $g_aTempPoints[$i - 1][0] * $g_fZoom + $g_iOffsetX
            Local $prevY = $g_aTempPoints[$i - 1][1] * $g_fZoom + $g_iOffsetY
            _GDIPlus_GraphicsDrawLine($g_hBuffer, $prevX, $prevY, $x, $y, $hPen)
        EndIf
    Next

    _GDIPlus_PenDispose($hPen)
    _GDIPlus_BrushDispose($hBrush)
EndFunc

Func HandleMouseDown($aCursorInfo)
    If Not IsArray($aCursorInfo) Then Return
    If $aCursorInfo[0] >= $g_iViewWidth Or $aCursorInfo[1] >= $g_iViewHeight Then Return

    Local $worldX = ($aCursorInfo[0] - $g_iOffsetX) / $g_fZoom
    Local $worldY = ($aCursorInfo[1] - $g_iOffsetY) / $g_fZoom

    Switch $g_iEditMode
        Case 0  ; Mode sélection
            SelectElement($worldX, $worldY)
            $g_bPanning = True
            $g_iPanStartX = $aCursorInfo[0]
            $g_iPanStartY = $aCursorInfo[1]

        Case 1  ; Ajout trapézoïde
            If $g_iTempPointCount < 4 Then
                $g_aTempPoints[$g_iTempPointCount][0] = $worldX
                $g_aTempPoints[$g_iTempPointCount][1] = $worldY
                $g_iTempPointCount += 1

                If $g_iTempPointCount = 4 Then
                    ; Créer le trapézoïde
                    Local $newSize = UBound($g_aTrapezoids) + 1
                    ReDim $g_aTrapezoids[$newSize][11]
                    Local $idx = $newSize - 1

                    For $i = 0 To 3
                        $g_aTrapezoids[$idx][$i * 2] = $g_aTempPoints[$i][0]
                        $g_aTrapezoids[$idx][$i * 2 + 1] = $g_aTempPoints[$i][1]
                    Next
                    $g_aTrapezoids[$idx][8] = 0     ; bottom
                    $g_aTrapezoids[$idx][9] = 100   ; top
                    $g_aTrapezoids[$idx][10] = 0    ; flags

                    $g_iTempPointCount = 0
                    $g_bModified = True
                    UpdateStatus("Trapézoïde " & $idx & " créé")
                EndIf
            EndIf

        Case 2  ; Ajout connection
            ; Sélectionner un trapézoïde pour la connection
            Local $trap = GetTrapezoidAt($worldX, $worldY)
            If $trap >= 0 Then
                Static Local $firstTrap = -1
                If $firstTrap = -1 Then
                    $firstTrap = $trap
                    UpdateStatus("Premier trapézoïde sélectionné: " & $trap)
                Else
                    ; Créer la connection
                    Local $newSize = UBound($g_aConnections) + 1
                    ReDim $g_aConnections[$newSize][6]
                    Local $idx = $newSize - 1

                    $g_aConnections[$idx][0] = $firstTrap
                    $g_aConnections[$idx][1] = $trap
                    $g_aConnections[$idx][2] = 0  ; flags
                    $g_aConnections[$idx][3] = 100  ; distance
                    $g_aConnections[$idx][4] = 0  ; min
                    $g_aConnections[$idx][5] = 1000  ; max

                    $firstTrap = -1
                    $g_bModified = True
                    UpdateStatus("Connection créée entre " & $g_aConnections[$idx][0] & " et " & $g_aConnections[$idx][1])
                EndIf
            EndIf

        Case 3  ; Ajout point
            Local $newSize = UBound($g_aPoints) + 1
            ReDim $g_aPoints[$newSize][5]
            Local $idx = $newSize - 1

            $g_aPoints[$idx][0] = $worldX
            $g_aPoints[$idx][1] = $worldY
            $g_aPoints[$idx][2] = 0  ; z
            $g_aPoints[$idx][3] = 0  ; type
            $g_aPoints[$idx][4] = 0  ; data

            $g_bModified = True
            UpdateStatus("Point " & $idx & " créé")
    EndSwitch
EndFunc

Func HandleMouseUp($aCursorInfo)
    $g_bPanning = False
EndFunc

Func HandleMouseMove($aCursorInfo)
    If Not IsArray($aCursorInfo) Then Return

    If $g_bPanning And $g_iEditMode = 0 Then
        $g_iOffsetX += $aCursorInfo[0] - $g_iPanStartX
        $g_iOffsetY += $aCursorInfo[1] - $g_iPanStartY
        $g_iPanStartX = $aCursorInfo[0]
        $g_iPanStartY = $aCursorInfo[1]
    EndIf
EndFunc

Func SelectElement($worldX, $worldY)
    ; Vérifier les trapézoïdes
    Local $trap = GetTrapezoidAt($worldX, $worldY)
    If $trap >= 0 Then
        $g_iSelectedType = 1
        $g_iSelectedIndex = $trap
        UpdateSelectedInfo()
        Return
    EndIf

    ; Vérifier les points
    For $i = 0 To UBound($g_aPoints) - 1
        Local $dist = Sqrt(($worldX - $g_aPoints[$i][0])^2 + ($worldY - $g_aPoints[$i][1])^2)
        If $dist < 10 Then
            $g_iSelectedType = 3
            $g_iSelectedIndex = $i
            UpdateSelectedInfo()
            Return
        EndIf
    Next

    ; Aucune sélection
    $g_iSelectedType = 0
    $g_iSelectedIndex = -1
    UpdateSelectedInfo()
EndFunc

Func GetTrapezoidAt($x, $y)
    For $i = 0 To UBound($g_aTrapezoids) - 1
        If PointInPolygon($x, $y, _
            $g_aTrapezoids[$i][0], $g_aTrapezoids[$i][1], _
            $g_aTrapezoids[$i][2], $g_aTrapezoids[$i][3], _
            $g_aTrapezoids[$i][4], $g_aTrapezoids[$i][5], _
            $g_aTrapezoids[$i][6], $g_aTrapezoids[$i][7]) Then
            Return $i
        EndIf
    Next
    Return -1
EndFunc

Func PointInPolygon($px, $py, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4)
    ; Algorithme simple pour quadrilatère
    Local $points[4][2] = [[$x1,$y1], [$x2,$y2], [$x3,$y3], [$x4,$y4]]
    Local $inside = False
    Local $p1x, $p1y, $p2x, $p2y

    $p1x = $points[0][0]
    $p1y = $points[0][1]

    For $i = 1 To 4
        $p2x = $points[Mod($i, 4)][0]
        $p2y = $points[Mod($i, 4)][1]

        If $py > Min($p1y, $p2y) Then
            If $py <= Max($p1y, $p2y) Then
                If $px <= Max($p1x, $p2x) Then
                    If $p1y <> $p2y Then
                        Local $xinters = ($py - $p1y) * ($p2x - $p1x) / ($p2y - $p1y) + $p1x
                    EndIf
                    If $p1x = $p2x Or $px <= $xinters Then
                        $inside = Not $inside
                    EndIf
                EndIf
            EndIf
        EndIf

        $p1x = $p2x
        $p1y = $p2y
    Next

    Return $inside
EndFunc

Func Min($a, $b)
    Return $a < $b ? $a : $b
EndFunc

Func Max($a, $b)
    Return $a > $b ? $a : $b
EndFunc

Func UpdateSelectedInfo()
    Local $info = ""

    Switch $g_iSelectedType
        Case 1  ; Trapézoïde
            $info = "Trapézoïde #" & $g_iSelectedIndex & @CRLF & @CRLF
            $info &= "Points:" & @CRLF
            For $i = 0 To 3
                $info &= StringFormat("P%d: (%.0f, %.0f)" & @CRLF, $i+1, _
                    $g_aTrapezoids[$g_iSelectedIndex][$i*2], _
                    $g_aTrapezoids[$g_iSelectedIndex][$i*2+1])
            Next
            $info &= @CRLF
            $info &= "Bottom: " & $g_aTrapezoids[$g_iSelectedIndex][8] & @CRLF
            $info &= "Top: " & $g_aTrapezoids[$g_iSelectedIndex][9] & @CRLF
            $info &= "Flags: " & $g_aTrapezoids[$g_iSelectedIndex][10]

            GUICtrlSetData($inpBottom, $g_aTrapezoids[$g_iSelectedIndex][8])
            GUICtrlSetData($inpTop, $g_aTrapezoids[$g_iSelectedIndex][9])
            GUICtrlSetData($inpFlags, $g_aTrapezoids[$g_iSelectedIndex][10])

        Case 3  ; Point
            $info = "Point #" & $g_iSelectedIndex & @CRLF & @CRLF
            $info &= StringFormat("Position: (%.0f, %.0f, %.0f)" & @CRLF, _
                $g_aPoints[$g_iSelectedIndex][0], _
                $g_aPoints[$g_iSelectedIndex][1], _
                $g_aPoints[$g_iSelectedIndex][2])
            $info &= "Type: " & $g_aPoints[$g_iSelectedIndex][3] & @CRLF
            $info &= "Data: " & $g_aPoints[$g_iSelectedIndex][4]

        Case Else
            $info = "Aucun élément sélectionné"
    EndSwitch

    GUICtrlSetData($lblInfo, $info)
EndFunc

Func UpdateStats()
    Local $stats = "Trapézoïdes: " & UBound($g_aTrapezoids) & @CRLF
    $stats &= "Connections: " & UBound($g_aConnections) & @CRLF
    $stats &= "Points: " & UBound($g_aPoints) & @CRLF
    $stats &= "Téléports: " & UBound($g_aTeleports) & @CRLF
    $stats &= "AABBs: " & UBound($g_aAABBs) & @CRLF
    $stats &= "Portails: " & UBound($g_aPortals)

    GUICtrlSetData($lblStats, $stats)
EndFunc

Func UpdateStatus($text)
    GUICtrlSetData($lblStatus, $text)
EndFunc

Func ZoomIn()
    $g_fZoom *= 1.2
    If $g_fZoom > 10 Then $g_fZoom = 10
    GUICtrlSetData($lblZoom, "Zoom: " & Round($g_fZoom * 100) & "%")
EndFunc

Func ZoomOut()
    $g_fZoom /= 1.2
    If $g_fZoom < 0.1 Then $g_fZoom = 0.1
    GUICtrlSetData($lblZoom, "Zoom: " & Round($g_fZoom * 100) & "%")
EndFunc

Func ZoomReset()
    $g_fZoom = 1.0
    GUICtrlSetData($lblZoom, "Zoom: 100%")
EndFunc

Func CenterView()
    If UBound($g_aTrapezoids) = 0 Then Return

    ; Calculer le centre de tous les trapézoïdes
    Local $minX = 999999, $minY = 999999
    Local $maxX = -999999, $maxY = -999999

    For $i = 0 To UBound($g_aTrapezoids) - 1
        For $j = 0 To 3
            If $g_aTrapezoids[$i][$j*2] < $minX Then $minX = $g_aTrapezoids[$i][$j*2]
            If $g_aTrapezoids[$i][$j*2] > $maxX Then $maxX = $g_aTrapezoids[$i][$j*2]
            If $g_aTrapezoids[$i][$j*2+1] < $minY Then $minY = $g_aTrapezoids[$i][$j*2+1]
            If $g_aTrapezoids[$i][$j*2+1] > $maxY Then $maxY = $g_aTrapezoids[$i][$j*2+1]
        Next
    Next

    Local $centerX = ($minX + $maxX) / 2
    Local $centerY = ($minY + $maxY) / 2

    $g_iOffsetX = $g_iViewWidth / 2 - $centerX * $g_fZoom
    $g_iOffsetY = $g_iViewHeight / 2 - $centerY * $g_fZoom
EndFunc

Func DeleteSelected()
    If $g_iSelectedType = 0 Or $g_iSelectedIndex = -1 Then Return

    Switch $g_iSelectedType
        Case 1  ; Trapézoïde
            _ArrayDelete($g_aTrapezoids, $g_iSelectedIndex)
            ; Mettre à jour les connections
            For $i = UBound($g_aConnections) - 1 To 0 Step -1
                If $g_aConnections[$i][0] = $g_iSelectedIndex Or _
                   $g_aConnections[$i][1] = $g_iSelectedIndex Then
                    _ArrayDelete($g_aConnections, $i)
                ElseIf $g_aConnections[$i][0] > $g_iSelectedIndex Then
                    $g_aConnections[$i][0] -= 1
                ElseIf $g_aConnections[$i][1] > $g_iSelectedIndex Then
                    $g_aConnections[$i][1] -= 1
                EndIf
            Next

        Case 3  ; Point
            _ArrayDelete($g_aPoints, $g_iSelectedIndex)
    EndSwitch

    $g_iSelectedType = 0
    $g_iSelectedIndex = -1
    $g_bModified = True
    UpdateSelectedInfo()
EndFunc

Func DuplicateSelected()
    If $g_iSelectedType = 0 Or $g_iSelectedIndex = -1 Then Return

    Switch $g_iSelectedType
        Case 1  ; Trapézoïde
            Local $newSize = UBound($g_aTrapezoids) + 1
            ReDim $g_aTrapezoids[$newSize][11]
            Local $idx = $newSize - 1

            ; Copier avec décalage
            For $i = 0 To 3
                $g_aTrapezoids[$idx][$i*2] = $g_aTrapezoids[$g_iSelectedIndex][$i*2] + 50
                $g_aTrapezoids[$idx][$i*2+1] = $g_aTrapezoids[$g_iSelectedIndex][$i*2+1] + 50
            Next
            $g_aTrapezoids[$idx][8] = $g_aTrapezoids[$g_iSelectedIndex][8]
            $g_aTrapezoids[$idx][9] = $g_aTrapezoids[$g_iSelectedIndex][9]
            $g_aTrapezoids[$idx][10] = $g_aTrapezoids[$g_iSelectedIndex][10]

            UpdateStatus("Trapézoïde dupliqué")
    EndSwitch

    $g_bModified = True
EndFunc

Func ApplyProperties()
    If $g_iSelectedType = 0 Or $g_iSelectedIndex = -1 Then Return

    Switch $g_iSelectedType
        Case 1  ; Trapézoïde
            $g_aTrapezoids[$g_iSelectedIndex][8] = Number(GUICtrlRead($inpBottom))
            $g_aTrapezoids[$g_iSelectedIndex][9] = Number(GUICtrlRead($inpTop))
            $g_aTrapezoids[$g_iSelectedIndex][10] = Number(GUICtrlRead($inpFlags))

            UpdateStatus("Propriétés appliquées")
    EndSwitch

    $g_bModified = True
EndFunc

Func NewMap()
    If $g_bModified Then
        If MsgBox(4, "Modifications non sauvegardées", "Voulez-vous sauvegarder ?") = 6 Then
            SaveMap()
        EndIf
    EndIf

    ; Réinitialiser
    ReDim $g_aTrapezoids[0][11]
    ReDim $g_aConnections[0][6]
    ReDim $g_aTeleports[0][6]
    ReDim $g_aAABBs[0][7]
    ReDim $g_aPoints[0][5]
    ReDim $g_aPortals[0][6]

    $g_sCurrentFile = ""
    $g_bModified = False
    $g_iSelectedType = 0
    $g_iSelectedIndex = -1

    UpdateStatus("Nouvelle map créée")
EndFunc

Func OpenMap()
    Local $file = FileOpenDialog("Ouvrir une map", @ScriptDir, "Map files (*.mpf)|All (*.*)")
    If @error Then Return

    LoadMapFile($file)
EndFunc

Func LoadMapFile($file)
    If Not FileExists($file) Then
        MsgBox(16, "Erreur", "Fichier introuvable : " & $file)
        Return
    EndIf

    ; Réinitialiser
    NewMap()

    Local $lines = FileReadToArray($file)
    If @error Then
        MsgBox(16, "Erreur", "Impossible de lire le fichier")
        Return
    EndIf

    Local $section = ""

    For $i = 0 To UBound($lines) - 1
        Local $line = StringStripWS($lines[$i], 3)
        If $line = "" Or StringLeft($line, 1) = "#" Then ContinueLoop

        ; Détecter les sections
        If StringLeft($line, 1) = "[" And StringRight($line, 1) = "]" Then
            $section = StringMid($line, 2, StringLen($line) - 2)
            ContinueLoop
        EndIf

        ; Parser selon la section
        Switch $section
            Case "TRAPEZOIDES"
                Local $parts = StringSplit($line, ",", 2)
                If UBound($parts) >= 11 Then
                    Local $idx = UBound($g_aTrapezoids)
                    ReDim $g_aTrapezoids[$idx + 1][11]
                    For $j = 0 To 10
                        $g_aTrapezoids[$idx][$j] = Number($parts[$j])
                    Next
                EndIf

            Case "CONNECTIONS"
                Local $parts = StringSplit($line, ",", 2)
                If UBound($parts) >= 6 Then
                    Local $idx = UBound($g_aConnections)
                    ReDim $g_aConnections[$idx + 1][6]
                    For $j = 0 To 5
                        $g_aConnections[$idx][$j] = Number($parts[$j])
                    Next
                EndIf

            Case "TELEPORTS"
                Local $parts = StringSplit($line, ",", 2)
                If UBound($parts) >= 6 Then
                    Local $idx = UBound($g_aTeleports)
                    ReDim $g_aTeleports[$idx + 1][6]
                    For $j = 0 To 5
                        $g_aTeleports[$idx][$j] = Number($parts[$j])
                    Next
                EndIf

            Case "AABBS"
                Local $parts = StringSplit($line, ",", 2)
                If UBound($parts) >= 7 Then
                    Local $idx = UBound($g_aAABBs)
                    ReDim $g_aAABBs[$idx + 1][7]
                    For $j = 0 To 6
                        $g_aAABBs[$idx][$j] = Number($parts[$j])
                    Next
                EndIf

            Case "POINTS"
                Local $parts = StringSplit($line, ",", 2)
                If UBound($parts) >= 5 Then
                    Local $idx = UBound($g_aPoints)
                    ReDim $g_aPoints[$idx + 1][5]
                    For $j = 0 To 4
                        $g_aPoints[$idx][$j] = Number($parts[$j])
                    Next
                EndIf

            Case "PORTALS"
                Local $parts = StringSplit($line, ",", 2)
                If UBound($parts) >= 6 Then
                    Local $idx = UBound($g_aPortals)
                    ReDim $g_aPortals[$idx + 1][6]
                    For $j = 0 To 5
                        $g_aPortals[$idx][$j] = Number($parts[$j])
                    Next
                EndIf
        EndSwitch
    Next

    $g_sCurrentFile = $file
    $g_bModified = False

    ; Centrer la vue
    CenterView()

    UpdateStatus("Map chargée : " & $file)
EndFunc

Func SaveMap()
    If $g_sCurrentFile = "" Then
        SaveMapAs()
    Else
        SaveMapToFile($g_sCurrentFile)
    EndIf
EndFunc

Func SaveMapAs()
    Local $file = FileSaveDialog("Enregistrer la map", @ScriptDir, "Map files (*.mpf)", 18, "map.mpf")
    If @error Then Return

    If StringRight($file, 4) <> ".mpf" Then $file &= ".mpf"

    SaveMapToFile($file)
    $g_sCurrentFile = $file
EndFunc

Func SaveMapToFile($file)
    Local $content = ""

    ; Header
    $content &= "[HEADER]" & @CRLF
    $content &= "version=MPF_1.0" & @CRLF
    $content &= "name=Map Editor" & @CRLF
    $content &= "date=" & @YEAR & "-" & @MON & "-" & @MDAY & @CRLF
    $content &= @CRLF

    ; Trapezoides
    $content &= "[TRAPEZOIDES]" & @CRLF
    For $i = 0 To UBound($g_aTrapezoids) - 1
        For $j = 0 To 10
            $content &= $g_aTrapezoids[$i][$j]
            If $j < 10 Then $content &= ","
        Next
        $content &= @CRLF
    Next
    $content &= @CRLF

    ; Connections
    $content &= "[CONNECTIONS]" & @CRLF
    For $i = 0 To UBound($g_aConnections) - 1
        For $j = 0 To 5
            $content &= $g_aConnections[$i][$j]
            If $j < 5 Then $content &= ","
        Next
        $content &= @CRLF
    Next
    $content &= @CRLF

    ; Teleports
    $content &= "[TELEPORTS]" & @CRLF
    For $i = 0 To UBound($g_aTeleports) - 1
        For $j = 0 To 5
            $content &= $g_aTeleports[$i][$j]
            If $j < 5 Then $content &= ","
        Next
        $content &= @CRLF
    Next
    $content &= @CRLF

    ; AABBs
    $content &= "[AABBS]" & @CRLF
    For $i = 0 To UBound($g_aAABBs) - 1
        For $j = 0 To 6
            $content &= $g_aAABBs[$i][$j]
            If $j < 6 Then $content &= ","
        Next
        $content &= @CRLF
    Next
    $content &= @CRLF

    ; Points
    $content &= "[POINTS]" & @CRLF
    For $i = 0 To UBound($g_aPoints) - 1
        For $j = 0 To 4
            $content &= $g_aPoints[$i][$j]
            If $j < 4 Then $content &= ","
        Next
        $content &= @CRLF
    Next
    $content &= @CRLF

    ; Portals
    $content &= "[PORTALS]" & @CRLF
    For $i = 0 To UBound($g_aPortals) - 1
        For $j = 0 To 5
            $content &= $g_aPortals[$i][$j]
            If $j < 5 Then $content &= ","
        Next
        $content &= @CRLF
    Next

    ; Écrire le fichier
    Local $hFile = FileOpen($file, 2)
    FileWrite($hFile, $content)
    FileClose($hFile)

    $g_bModified = False
    UpdateStatus("Map sauvegardée : " & $file)
EndFunc

Func VisualizeMap()
    If $g_bModified Then
        If MsgBox(4, "Modifications non sauvegardées", "Sauvegarder avant de visualiser ?") = 6 Then
            SaveMap()
        EndIf
    EndIf

    If $g_sCurrentFile = "" Then
        MsgBox(48, "Attention", "Veuillez d'abord sauvegarder la map")
        Return
    EndIf

    ; Lancer le visualizer
    Local $visualizer = @ScriptDir & "\Cache_Visualizer.au3"
    If FileExists($visualizer) Then
        Run(@AutoItExe & ' "' & $visualizer & '" "' & $g_sCurrentFile & '"')
        UpdateStatus("Visualisation lancée")
    Else
        MsgBox(16, "Erreur", "Cache_Visualizer.au3 introuvable")
    EndIf
EndFunc

Func ValidateMap()
    Local $errors = ""
    Local $warnings = ""

    If UBound($g_aTrapezoids) = 0 Then
        $errors &= "- Aucun trapézoïde défini" & @CRLF
    EndIf

    ; Vérifier les connections
    For $i = 0 To UBound($g_aConnections) - 1
        If $g_aConnections[$i][0] >= UBound($g_aTrapezoids) Then
            $errors &= "- Connection " & $i & " : Trapézoïde source " & $g_aConnections[$i][0] & " invalide" & @CRLF
        EndIf
        If $g_aConnections[$i][1] >= UBound($g_aTrapezoids) Then
            $errors &= "- Connection " & $i & " : Trapézoïde destination " & $g_aConnections[$i][1] & " invalide" & @CRLF
        EndIf
    Next

    ; Afficher le rapport
    If $errors = "" And $warnings = "" Then
        MsgBox(64, "Validation", "Map valide !")
    Else
        MsgBox(48, "Validation", $errors & $warnings)
    EndIf
EndFunc

Func ExitProgram()
    If $g_bModified Then
        If MsgBox(4, "Modifications non sauvegardées", "Voulez-vous sauvegarder ?") = 6 Then
            SaveMap()
        EndIf
    EndIf

    ; Nettoyage GDI+
    _GDIPlus_GraphicsDispose($g_hBuffer)
    _GDIPlus_BitmapDispose($g_hBitmap)
    _GDIPlus_GraphicsDispose($g_hGraphic)
    _GDIPlus_Shutdown()

    Exit
EndFunc