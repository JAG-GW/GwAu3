#include-once

#include 'GwAu3_GetInfo.au3'

Func MyCustomEnemyFilter($aAgentPtr)

    If GetAgentInfo($aAgentPtr, 'Allegiance') <> 3 Then Return False
    If GetAgentInfo($aAgentPtr, 'HP') < 0.5 Then Return False

    Return True
EndFunc

;~ Description: Basic agent finder with type filtering and range checking
;~ Parameters:
;~   $aAgentID = Reference agent ID or pointer (-2 for player by default)
;~   $aRange = Range to check (default: 1320 = aggro range)
;~   $aType = Agent type (0xDB=Living, 0x400=Item, 0x200=Object, 0=All)
;~   $aReturnMode = 0=Count only, 1=Return closest, 2=Return farthest, 3=Return distance
;~   $aCustomFilter = Optional callback function for custom filtering
Func GetAgents($aAgentID = -2, $aRange = 1320, $aType = 0, $aReturnMode = 0, $aCustomFilter = "")
    ; Variables pour le suivi
    Local $lCount = 0
    Local $lClosestAgent = 0
    Local $lClosestDistance = 999999
    Local $lFarthestAgent = 0
    Local $lFarthestDistance = 0

    ; Obtenir les coordonnées de l'agent de référence
    Local $lRefID = ConvertID($aAgentID)
    Local $lRefX = GetAgentInfo($aAgentID, "X")
    Local $lRefY = GetAgentInfo($aAgentID, "Y")

    ; Obtenir le tableau d'agents en fonction du type
    Local $lAgentArray
    If $aType > 0 Then
        $lAgentArray = GetAgentArray($aType)
    Else
        $lAgentArray = GetAgentArray()
    EndIf

    ; Si aucun agent trouvé, retourner 0
    If Not IsArray($lAgentArray) Or $lAgentArray[0] = 0 Then
        Return 0
    EndIf

    ; Traiter chaque agent
    For $i = 1 To $lAgentArray[0]
        Local $lAgentPtr = $lAgentArray[$i]
        Local $lAgentID = MemoryRead($lAgentPtr + 0x2C, "long");GetAgentInfo($lAgentPtr, "ID")

        ; Ignorer l'agent de référence
        If $lAgentID = $lRefID Then ContinueLoop

        ; Calculer la distance par rapport à l'agent de référence (pas par rapport au joueur)
        Local $lAgentX = MemoryRead($lAgentPtr + 0x74, "float");GetAgentInfo($lAgentPtr, "X")
        Local $lAgentY = MemoryRead($lAgentPtr + 0x78, "float");GetAgentInfo($lAgentPtr, "Y")
        Local $lDistance = Sqrt(($lAgentX - $lRefX) ^ 2 + ($lAgentY - $lRefY) ^ 2)

        ; Ignorer si en dehors de la portée de l'agent de référence
        If $lDistance > $aRange Then ContinueLoop

        ; Appliquer le filtre personnalisé
		If $aCustomFilter <> "" Then
            Local $lResult = Call($aCustomFilter, $lAgentPtr)
            If Not $lResult Then ContinueLoop
        EndIf

        ; Incrémenter le compteur
        $lCount += 1

        ; Mettre à jour l'agent le plus proche
        If $lDistance < $lClosestDistance Then
            $lClosestDistance = $lDistance
            $lClosestAgent = $lAgentPtr
        EndIf

        ; Mettre à jour l'agent le plus éloigné
        If $lDistance > $lFarthestDistance Then
            $lFarthestDistance = $lDistance
            $lFarthestAgent = $lAgentPtr
        EndIf
    Next

    ; Retourner le résultat en fonction du mode
    Switch $aReturnMode
        Case 0 ; Nombre d'agents
            Return $lCount
        Case 1 ; Agent le plus proche
            Return $lClosestAgent
        Case 2 ; Agent le plus éloigné
            Return $lFarthestAgent
        Case 3 ; Distance à l'agent le plus proche
            Return $lClosestDistance
    EndSwitch
EndFunc

;~ Description: Basic agent finder with type filtering and range checking around coordinates
;~ Parameters:
;~   $aX = X coordinate of reference point
;~   $aY = Y coordinate of reference point
;~   $aRange = Range to check (default: 1320 = aggro range)
;~   $aType = Agent type (0xDB=Living, 0x400=Item, 0x200=Object, 0=All)
;~   $aReturnMode = 0=Count only, 1=Return closest, 2=Return farthest, 3=Return distance
;~   $aCustomFilter = Optional callback function for custom filtering
Func GetXY($aX, $aY, $aRange = 1320, $aType = 0, $aReturnMode = 0, $aCustomFilter = "")
    ; Variables pour le suivi
    Local $lCount = 0
    Local $lClosestAgent = 0
    Local $lClosestDistance = 999999
    Local $lFarthestAgent = 0
    Local $lFarthestDistance = 0

    ; Obtenir le tableau d'agents en fonction du type
    Local $lAgentArray
    If $aType > 0 Then
        $lAgentArray = GetAgentArray($aType)
    Else
        $lAgentArray = GetAgentArray()
    EndIf

    ; Si aucun agent trouvé, retourner 0
    If Not IsArray($lAgentArray) Or $lAgentArray[0] = 0 Then
        Return 0
    EndIf

    ; Traiter chaque agent
    For $i = 1 To $lAgentArray[0]
        Local $lAgentPtr = $lAgentArray[$i]

        ; Calculer la distance par rapport aux coordonnées spécifiées
        Local $lAgentX = GetAgentInfo($lAgentPtr, "X")
        Local $lAgentY = GetAgentInfo($lAgentPtr, "Y")
        Local $lDistance = Sqrt(($lAgentX - $aX) ^ 2 + ($lAgentY - $aY) ^ 2)

        ; Ignorer si en dehors de la portée spécifiée
        If $lDistance > $aRange Then ContinueLoop

        ; Appliquer le filtre personnalisé
        If $aCustomFilter <> "" Then
            Local $lResult = Call($aCustomFilter, $lAgentPtr)
            If Not $lResult Then ContinueLoop
        EndIf

        ; Incrémenter le compteur
        $lCount += 1

        ; Mettre à jour l'agent le plus proche
        If $lDistance < $lClosestDistance Then
            $lClosestDistance = $lDistance
            $lClosestAgent = $lAgentPtr
        EndIf

        ; Mettre à jour l'agent le plus éloigné
        If $lDistance > $lFarthestDistance Then
            $lFarthestDistance = $lDistance
            $lFarthestAgent = $lAgentPtr
        EndIf
    Next

    ; Retourner le résultat en fonction du mode
    Switch $aReturnMode
        Case 0 ; Nombre d'agents
            Return $lCount
        Case 1 ; Agent le plus proche
            Return $lClosestAgent
        Case 2 ; Agent le plus éloigné
            Return $lFarthestAgent
        Case 3 ; Distance à l'agent le plus proche
            Return $lClosestDistance
    EndSwitch
EndFunc

