#include <Array.au3>
#include <Math.au3>
#include "Pathfinding.au3"

; ============================================================================
; Configuration
; ============================================================================
Global Const $MAX_LINE_OF_SIGHT_DISTANCE = 2500.0 ; Distance max pour la ligne de vue
Global Const $WALL_DETECTION_RADIUS = 600.0 ; Rayon de détection des murs (réduit pour performance)
Global Const $MIN_WALL_DISTANCE = 250.0 ; Distance minimale des murs
Global Const $MAX_WALL_DISTANCE = 500.0 ; Distance maximale des murs

; Cache pour optimiser les calculs
Global $g_AABBCache[0][8]  ; Cache des AABBs avec leurs limites pré-calculées
Global $g_TrapezoidCache[0][10] ; Cache des trapézoïdes
Global $g_WallCache[0][0] ; Cache des détections de murs
Global $g_CacheInitialized = False

; Grille spatiale pour accélération
Global $g_SpatialGrid[0]
Global $g_GridCellSize = 500.0
Global $g_GridMinX, $g_GridMinY, $g_GridMaxX, $g_GridMaxY
Global $g_GridWidth, $g_GridHeight

; ============================================================================
; Fonction principale d'optimisation
; ============================================================================
Func OptimizePath(ByRef $originalPath, $aggressiveness = 0.8)
    If UBound($originalPath) <= 2 Then Return $originalPath

    ConsoleWrite("========================================" & @CRLF)
    ConsoleWrite("Starting path optimization with " & UBound($originalPath) & " waypoints" & @CRLF)

    ; Initialiser le cache si nécessaire
    If Not $g_CacheInitialized Then
        Local $timer = TimerInit()
        InitializeAABBCache()
        InitializeTrapezoidCache()
        InitializeSpatialGrid()
        ConsoleWrite("  Cache initialization: " & Round(TimerDiff($timer), 1) & " ms" & @CRLF)
    EndIf

    ; Étape 1: Optimisation par ligne de vue
    Local $timer = TimerInit()
    Local $optimizedPath = OptimizeByLineOfSight($originalPath)
    ConsoleWrite("  Line of sight completed in " & Round(TimerDiff($timer), 1) & " ms" & @CRLF)

    ; Étape 2: Ajustement rapide pour éviter les murs
    $timer = TimerInit()
    Local $adjustedPath = FastWallAdjustment($optimizedPath, $aggressiveness)
    ConsoleWrite("  Fast wall adjustment completed in " & Round(TimerDiff($timer), 1) & " ms" & @CRLF)

    ; Étape 3: Lissage final du chemin
    $timer = TimerInit()
    Local $smoothedPath = SmoothPath($adjustedPath)
    ConsoleWrite("  Path smoothing completed in " & Round(TimerDiff($timer), 1) & " ms" & @CRLF)

    ; IMPORTANT: S'assurer que le dernier point est bien la destination finale
    Local $lastOriginal = UBound($originalPath) - 1
    Local $lastSmoothed = UBound($smoothedPath) - 1

    ; Vérifier si le dernier point est différent de la destination
    If $smoothedPath[$lastSmoothed][0] <> $originalPath[$lastOriginal][0] Or _
       $smoothedPath[$lastSmoothed][1] <> $originalPath[$lastOriginal][1] Or _
       $smoothedPath[$lastSmoothed][2] <> $originalPath[$lastOriginal][2] Then
        ; Ajouter la destination finale si elle manque
        _ArrayAdd($smoothedPath, $originalPath[$lastOriginal][0] & "|" & _
                                 $originalPath[$lastOriginal][1] & "|" & _
                                 $originalPath[$lastOriginal][2])
        ConsoleWrite("  Added final destination point" & @CRLF)
    EndIf

    ConsoleWrite("Optimization complete: " & UBound($smoothedPath) & " waypoints" & @CRLF)
    ConsoleWrite("========================================" & @CRLF)

    Return $smoothedPath
EndFunc

; ============================================================================
; Initialiser la grille spatiale pour accélération
; ============================================================================
Func InitializeSpatialGrid()
    ; Trouver les limites de la carte
    $g_GridMinX = 999999
    $g_GridMinY = 999999
    $g_GridMaxX = -999999
    $g_GridMaxY = -999999

    For $i = 0 To UBound($g_AABBCache) - 1
        If $g_AABBCache[$i][0] < $g_GridMinX Then $g_GridMinX = $g_AABBCache[$i][0]
        If $g_AABBCache[$i][1] > $g_GridMaxX Then $g_GridMaxX = $g_AABBCache[$i][1]
        If $g_AABBCache[$i][2] < $g_GridMinY Then $g_GridMinY = $g_AABBCache[$i][2]
        If $g_AABBCache[$i][3] > $g_GridMaxY Then $g_GridMaxY = $g_AABBCache[$i][3]
    Next

    ; Calculer les dimensions de la grille
    $g_GridWidth = Ceiling(($g_GridMaxX - $g_GridMinX) / $g_GridCellSize) + 1
    $g_GridHeight = Ceiling(($g_GridMaxY - $g_GridMinY) / $g_GridCellSize) + 1

    ; Initialiser la grille
    Local $gridSize = $g_GridWidth * $g_GridHeight
    ReDim $g_SpatialGrid[$gridSize]

    For $i = 0 To $gridSize - 1
        $g_SpatialGrid[$i] = ""
    Next

    ; Remplir la grille avec les indices des AABBs
    For $i = 0 To UBound($g_AABBCache) - 1
        Local $minCellX = Floor(($g_AABBCache[$i][0] - $g_GridMinX) / $g_GridCellSize)
        Local $maxCellX = Floor(($g_AABBCache[$i][1] - $g_GridMinX) / $g_GridCellSize)
        Local $minCellY = Floor(($g_AABBCache[$i][2] - $g_GridMinY) / $g_GridCellSize)
        Local $maxCellY = Floor(($g_AABBCache[$i][3] - $g_GridMinY) / $g_GridCellSize)

        For $cellX = $minCellX To $maxCellX
            For $cellY = $minCellY To $maxCellY
                If $cellX >= 0 And $cellX < $g_GridWidth And $cellY >= 0 And $cellY < $g_GridHeight Then
                    Local $gridIndex = $cellY * $g_GridWidth + $cellX
                    If $g_SpatialGrid[$gridIndex] = "" Then
                        $g_SpatialGrid[$gridIndex] = String($i)
                    Else
                        $g_SpatialGrid[$gridIndex] &= "," & $i
                    EndIf
                EndIf
            Next
        Next
    Next

    ConsoleWrite("  Spatial grid initialized: " & $g_GridWidth & "x" & $g_GridHeight & " cells" & @CRLF)
EndFunc

; ============================================================================
; Validation rapide d'un point avec grille spatiale
; ============================================================================
Func ValidatePointFast($x, $y, $z)
    ; Trouver la cellule de la grille
    Local $cellX = Floor(($x - $g_GridMinX) / $g_GridCellSize)
    Local $cellY = Floor(($y - $g_GridMinY) / $g_GridCellSize)

    If $cellX < 0 Or $cellX >= $g_GridWidth Or $cellY < 0 Or $cellY >= $g_GridHeight Then
        Return False
    EndIf

    Local $gridIndex = $cellY * $g_GridWidth + $cellX
    If $g_SpatialGrid[$gridIndex] = "" Then Return False

    ; Vérifier seulement les AABBs dans cette cellule
    Local $indices = StringSplit($g_SpatialGrid[$gridIndex], ",", 2)

    For $idx In $indices
        Local $i = Number($idx)
        If $g_AABBCache[$i][6] <> $z Then ContinueLoop

        If $x >= $g_AABBCache[$i][0] And $x <= $g_AABBCache[$i][1] And _
           $y >= $g_AABBCache[$i][2] And $y <= $g_AABBCache[$i][3] Then
            Return True
        EndIf
    Next

    Return False
EndFunc

; ============================================================================
; Initialiser le cache des AABBs
; ============================================================================
Func InitializeAABBCache()
    Local $count = UBound($g_AABBs)
    ReDim $g_AABBCache[$count][8]

    For $i = 0 To $count - 1
        Local $centerX = $g_AABBs[$i][1]
        Local $centerY = $g_AABBs[$i][2]
        Local $halfX = $g_AABBs[$i][3]
        Local $halfY = $g_AABBs[$i][4]

        $g_AABBCache[$i][0] = $centerX - $halfX  ; minX
        $g_AABBCache[$i][1] = $centerX + $halfX  ; maxX
        $g_AABBCache[$i][2] = $centerY - $halfY  ; minY
        $g_AABBCache[$i][3] = $centerY + $halfY  ; maxY
        $g_AABBCache[$i][4] = $centerX           ; centerX
        $g_AABBCache[$i][5] = $centerY           ; centerY
        $g_AABBCache[$i][6] = $g_AABBs[$i][6]    ; layer
        $g_AABBCache[$i][7] = _Max($halfX, $halfY) ; max radius
    Next

    ConsoleWrite("  AABB cache initialized with " & $count & " entries" & @CRLF)
EndFunc

; ============================================================================
; Initialiser le cache des trapézoïdes
; ============================================================================
Func InitializeTrapezoidCache()
    If Not IsArray($g_Trapezoids) Then Return

    Local $count = UBound($g_Trapezoids)
    ReDim $g_TrapezoidCache[$count][10]

    For $i = 0 To $count - 1
        $g_TrapezoidCache[$i][0] = $g_Trapezoids[$i][0] ; id
        $g_TrapezoidCache[$i][1] = $g_Trapezoids[$i][1] ; layer
        $g_TrapezoidCache[$i][2] = $g_Trapezoids[$i][2] ; ax
        $g_TrapezoidCache[$i][3] = $g_Trapezoids[$i][3] ; ay
        $g_TrapezoidCache[$i][4] = $g_Trapezoids[$i][4] ; bx
        $g_TrapezoidCache[$i][5] = $g_Trapezoids[$i][5] ; by

        ; Calculer le centre du trapézoïde
        $g_TrapezoidCache[$i][6] = ($g_Trapezoids[$i][2] + $g_Trapezoids[$i][4]) / 2 ; centerX
        $g_TrapezoidCache[$i][7] = ($g_Trapezoids[$i][3] + $g_Trapezoids[$i][5]) / 2 ; centerY

        ; Calculer les dimensions
        $g_TrapezoidCache[$i][8] = Abs($g_Trapezoids[$i][2] - $g_Trapezoids[$i][4]) ; width
        $g_TrapezoidCache[$i][9] = Abs($g_Trapezoids[$i][3] - $g_Trapezoids[$i][5]) ; height
    Next

    ConsoleWrite("  Trapezoid cache initialized with " & $count & " entries" & @CRLF)
    $g_CacheInitialized = True
EndFunc

; ============================================================================
; Optimisation par ligne de vue
; ============================================================================
Func OptimizeByLineOfSight(ByRef $path)
    Local $result[0][3]
    Local $currentIdx = 0

    ; Toujours garder le premier point (départ)
    _ArrayAdd($result, $path[0][0] & "|" & $path[0][1] & "|" & $path[0][2])

    While $currentIdx < UBound($path) - 1
        Local $furthestVisible = $currentIdx + 1

        ; Chercher le point le plus loin visible
        For $i = $currentIdx + 2 To UBound($path) - 1
            Local $dist = GetDistance($path[$currentIdx][0], $path[$currentIdx][1], _
                                     $path[$i][0], $path[$i][1])
            If $dist > $MAX_LINE_OF_SIGHT_DISTANCE Then ExitLoop

            Local $point1[3] = [$path[$currentIdx][0], $path[$currentIdx][1], $path[$currentIdx][2]]
            Local $point2[3] = [$path[$i][0], $path[$i][1], $path[$i][2]]

            If CheckLineOfSightFast($point1, $point2) Then
                $furthestVisible = $i
            EndIf
        Next

        ; Ajouter le point le plus loin visible
        _ArrayAdd($result, $path[$furthestVisible][0] & "|" & $path[$furthestVisible][1] & "|" & $path[$furthestVisible][2])

        $currentIdx = $furthestVisible
    WEnd

    ; S'assurer que le dernier point est bien inclus
    Local $lastIdx = UBound($path) - 1
    Local $lastResultIdx = UBound($result) - 1

    ; Si le dernier point du résultat n'est pas le dernier point du chemin original
    If $result[$lastResultIdx][0] <> $path[$lastIdx][0] Or _
       $result[$lastResultIdx][1] <> $path[$lastIdx][1] Or _
       $result[$lastResultIdx][2] <> $path[$lastIdx][2] Then
        _ArrayAdd($result, $path[$lastIdx][0] & "|" & $path[$lastIdx][1] & "|" & $path[$lastIdx][2])
    EndIf

    ConsoleWrite("  Line of sight: " & UBound($path) & " -> " & UBound($result) & " waypoints" & @CRLF)
    Return $result
EndFunc

; ============================================================================
; Ajustement rapide pour éviter les murs
; ============================================================================
Func FastWallAdjustment(ByRef $path, $aggressiveness = 0.8)
    If UBound($path) <= 2 Then Return $path

    Local $adjustedPath[0][3]
    Local $totalAdjustments = 0

    ; Garder le premier point (départ)
    _ArrayAdd($adjustedPath, $path[0][0] & "|" & $path[0][1] & "|" & $path[0][2])

    ; Traiter chaque point intermédiaire (mais PAS le dernier)
    For $i = 1 To UBound($path) - 2
        Local $x = $path[$i][0]
        Local $y = $path[$i][1]
        Local $z = $path[$i][2]

        ; Calcul rapide de l'ajustement
        Local $adjustment = QuickWallAvoidance($x, $y, $z)

        If $adjustment[0] <> 0 Or $adjustment[1] <> 0 Then
            Local $newX = $x + $adjustment[0] * $aggressiveness
            Local $newY = $y + $adjustment[1] * $aggressiveness

            ; Vérification simple
            If ValidatePointFast($newX, $newY, $z) Then
                ; Vérifier rapidement la ligne de vue
                If $i > 0 Then
                    Local $prevPoint[3] = [$adjustedPath[UBound($adjustedPath)-1][0], _
                                          $adjustedPath[UBound($adjustedPath)-1][1], _
                                          $adjustedPath[UBound($adjustedPath)-1][2]]
                    Local $newPoint[3] = [$newX, $newY, $z]

                    If CheckLineOfSightFast($prevPoint, $newPoint) Then
                        _ArrayAdd($adjustedPath, $newX & "|" & $newY & "|" & $z)
                        $totalAdjustments += 1
                    Else
                        _ArrayAdd($adjustedPath, $x & "|" & $y & "|" & $z)
                    EndIf
                Else
                    _ArrayAdd($adjustedPath, $newX & "|" & $newY & "|" & $z)
                    $totalAdjustments += 1
                EndIf
            Else
                _ArrayAdd($adjustedPath, $x & "|" & $y & "|" & $z)
            EndIf
        Else
            _ArrayAdd($adjustedPath, $x & "|" & $y & "|" & $z)
        EndIf
    Next

    ; IMPORTANT: Toujours garder le dernier point exact (destination)
    Local $lastIdx = UBound($path) - 1
    _ArrayAdd($adjustedPath, $path[$lastIdx][0] & "|" & $path[$lastIdx][1] & "|" & $path[$lastIdx][2])

    ConsoleWrite("  Wall adjustments: " & $totalAdjustments & " waypoints modified" & @CRLF)
    Return $adjustedPath
EndFunc

; ============================================================================
; Calcul rapide de l'évitement des murs
; ============================================================================
Func QuickWallAvoidance($x, $y, $z)
    Local $repulsionX = 0
    Local $repulsionY = 0
    Local $wallCount = 0

    ; Scanner seulement 8 directions principales pour la vitesse
    Local $directions[8][2] = [[1,0], [0.707,0.707], [0,1], [-0.707,0.707], _
                               [-1,0], [-0.707,-0.707], [0,-1], [0.707,-0.707]]

    For $d = 0 To 7
        Local $dirX = $directions[$d][0]
        Local $dirY = $directions[$d][1]

        ; Recherche binaire pour trouver le mur
        Local $minDist = 0
        Local $maxDist = $WALL_DETECTION_RADIUS
        Local $wallDist = $maxDist

        While $maxDist - $minDist > 50
            Local $midDist = ($minDist + $maxDist) / 2
            Local $checkX = $x + $dirX * $midDist
            Local $checkY = $y + $dirY * $midDist

            If ValidatePointFast($checkX, $checkY, $z) Then
                $minDist = $midDist
            Else
                $maxDist = $midDist
                $wallDist = $midDist
            EndIf
        WEnd

        ; Si un mur est proche, ajouter une répulsion
        If $wallDist < $MIN_WALL_DISTANCE Then
            Local $strength = ($MIN_WALL_DISTANCE - $wallDist) / $MIN_WALL_DISTANCE
            $repulsionX -= $dirX * $strength * ($MIN_WALL_DISTANCE - $wallDist)
            $repulsionY -= $dirY * $strength * ($MIN_WALL_DISTANCE - $wallDist)
            $wallCount += 1
        EndIf
    Next

    ; Normaliser si nécessaire
    If $wallCount > 0 Then
        Local $magnitude = Sqrt($repulsionX * $repulsionX + $repulsionY * $repulsionY)
        If $magnitude > $MAX_WALL_DISTANCE Then
            $repulsionX = ($repulsionX / $magnitude) * $MAX_WALL_DISTANCE
            $repulsionY = ($repulsionY / $magnitude) * $MAX_WALL_DISTANCE
        EndIf
    EndIf

    Local $result[2] = [$repulsionX, $repulsionY]
    Return $result
EndFunc

; ============================================================================
; Vérification rapide de ligne de vue
; ============================================================================
Func CheckLineOfSightFast(ByRef $point1, ByRef $point2)
    If $point1[2] <> $point2[2] Then Return False

    Local $x1 = $point1[0]
    Local $y1 = $point1[1]
    Local $x2 = $point2[0]
    Local $y2 = $point2[1]
    Local $layer = $point1[2]

    ; Utiliser moins d'échantillons pour la vitesse
    Local $dist = GetDistance($x1, $y1, $x2, $y2)
    Local $samples = _Min(15, _Max(3, Int($dist / 400)))

    For $i = 1 To $samples - 1
        Local $t = $i / $samples
        Local $x = $x1 + ($x2 - $x1) * $t
        Local $y = $y1 + ($y2 - $y1) * $t

        If Not ValidatePointFast($x, $y, $layer) Then
            Return False
        EndIf
    Next

    Return True
EndFunc

; ============================================================================
; Lissage du chemin
; ============================================================================
Func SmoothPath(ByRef $path)
    If UBound($path) <= 3 Then Return $path

    Local $smoothed[0][3]

    ; Garder le premier point (départ)
    _ArrayAdd($smoothed, $path[0][0] & "|" & $path[0][1] & "|" & $path[0][2])

    ; Appliquer un lissage simple (mais PAS sur le dernier point)
    For $i = 1 To UBound($path) - 2
        Local $prevX = $path[$i-1][0]
        Local $prevY = $path[$i-1][1]
        Local $currX = $path[$i][0]
        Local $currY = $path[$i][1]
        Local $nextX = $path[$i+1][0]
        Local $nextY = $path[$i+1][1]
        Local $z = $path[$i][2]

        ; Moyenne pondérée simple
        Local $smoothX = $currX * 0.6 + $prevX * 0.2 + $nextX * 0.2
        Local $smoothY = $currY * 0.6 + $prevY * 0.2 + $nextY * 0.2

        ; Vérifier rapidement la validité
        If ValidatePointFast($smoothX, $smoothY, $z) Then
            _ArrayAdd($smoothed, $smoothX & "|" & $smoothY & "|" & $z)
        Else
            _ArrayAdd($smoothed, $currX & "|" & $currY & "|" & $z)
        EndIf
    Next

    ; IMPORTANT: Toujours garder le dernier point exact (destination)
    Local $lastIdx = UBound($path) - 1
    _ArrayAdd($smoothed, $path[$lastIdx][0] & "|" & $path[$lastIdx][1] & "|" & $path[$lastIdx][2])

    Return $smoothed
EndFunc

; ============================================================================
; Calculer la longueur du chemin
; ============================================================================
Func CalculatePathLength(ByRef $path)
    Local $totalLength = 0
    For $i = 1 To UBound($path) - 1
        $totalLength += GetDistance($path[$i-1][0], $path[$i-1][1], _
                                   $path[$i][0], $path[$i][1])
    Next
    Return $totalLength
EndFunc

Func GetPathCoords($aMapID, $aFromX, $aFromY, $aToX, $aToY, $aAggressivity = 0.5)
    Local $dataFile = $aMapID & "_*.gwau3"
    Local $files = _FileListToArray(@ScriptDir, $dataFile, 1) ; 1 = fichiers seulement

    If @error Or Not IsArray($files) Or $files[0] = 0 Then
        $files = _FileListToArray(@ScriptDir & "\..\..\API\Pathfinding\", $dataFile, 1)
        If @error Or Not IsArray($files) Or $files[0] = 0 Then
            Return False
        EndIf
        $dataFile = @ScriptDir & "\..\..\API\Pathfinding\" & $files[1]
    Else
        $dataFile = @ScriptDir & "\" & $files[1]
    EndIf

    If Not LoadPathfindingData($dataFile) Then
        Return False
    EndIf

    Local $blockedLayers[256]
    For $i = 0 To 255
        $blockedLayers[$i] = False
    Next

    Local $originalPath = CalculatePath($aFromX, $aFromY, 0, $aToX, $aToY, 0, $blockedLayers)
    Local $optimizedPath = OptimizePath($originalPath, $aAggressivity)

    Return $optimizedPath
EndFunc
