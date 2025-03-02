#include-once

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
    ; Variables for tracking
    Local $lCount = 0
    Local $lClosestAgent = 0
    Local $lClosestDistance = $aRange * $aRange  ; Squared distance for performance
    Local $lFarthestAgent = 0
    Local $lFarthestDistance = 0  ; Start with 0 to find the farthest

    ; Get reference agent info
    Local $lRefID = GetAgentInfo($aAgentID, 'ID')
    Local $lRefX = GetAgentInfo($aAgentID, 'X')
    Local $lRefY = GetAgentInfo($aAgentID, 'Y')

    ; Get agent array based on type
    Local $lAgentPtrArray = ($aType > 0) ? GetAgentArray($aType) : GetAgentArray()

    ; Process each agent
    For $i = 1 To $lAgentPtrArray[0]
        Local $lAgentPtr = $lAgentPtrArray[$i]
        Local $lAgentID = GetAgentInfo($lAgentPtr, 'ID')

        ; Skip self
        If $lAgentID == $lRefID Then ContinueLoop

        ; Calculate squared distance (faster than sqrt)
        Local $lAgentX = GetAgentInfo($lAgentPtr, 'X')
        Local $lAgentY = GetAgentInfo($lAgentPtr, 'Y')
        Local $lDistance = ($lRefX - $lAgentX) ^ 2 + ($lRefY - $lAgentY) ^ 2

        ; Skip if outside range
        If $lDistance > ($aRange * $aRange) Then ContinueLoop

        ; Default match = true
        Local $lMatches = True

        ; Apply custom filter if provided
        If $aCustomFilter <> "" And IsFunc($aCustomFilter) Then
            $lMatches = Execute($aCustomFilter & "(" & $lAgentPtr & ")")
        EndIf

        ; Process matching agent
        If $lMatches Then
            $lCount += 1

            ; Track closest if needed
            If ($aReturnMode == 1 Or $aReturnMode == 3) And $lDistance < $lClosestDistance Then
                $lClosestAgent = $lAgentPtr
                $lClosestDistance = $lDistance
            EndIf

            ; Track farthest if needed
            If $aReturnMode == 2 And $lDistance > $lFarthestDistance Then
                $lFarthestAgent = $lAgentPtr
                $lFarthestDistance = $lDistance
            EndIf
        EndIf
    Next

    ; Return appropriate result based on mode
    Switch $aReturnMode
        Case 0 ; Count only
            Return $lCount

        Case 1 ; Closest agent
            Return $lClosestAgent

        Case 2 ; Farthest agent (within range)
            Return $lFarthestAgent

        Case 3 ; Distance to closest agent
            Return Sqrt($lClosestDistance)
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
    ; Variables for tracking
    Local $lCount = 0
    Local $lClosestAgent = 0
    Local $lClosestDistance = $aRange * $aRange  ; Squared distance for performance
    Local $lFarthestAgent = 0
    Local $lFarthestDistance = 0  ; Start with 0 to find the farthest

    ; Get agent array based on type
    Local $lAgentPtrArray = ($aType > 0) ? GetAgentArray($aType) : GetAgentArray()

    ; Process each agent
    For $i = 1 To $lAgentPtrArray[0]
        Local $lAgentPtr = $lAgentPtrArray[$i]

        ; Calculate squared distance (faster than sqrt)
        Local $lAgentX = GetAgentInfo($lAgentPtr, 'X')
        Local $lAgentY = GetAgentInfo($lAgentPtr, 'Y')
        Local $lDistance = ($aX - $lAgentX) ^ 2 + ($aY - $lAgentY) ^ 2

        ; Skip if outside range
        If $lDistance > ($aRange * $aRange) Then ContinueLoop

        ; Default match = true
        Local $lMatches = True

        ; Apply custom filter if provided
        If $aCustomFilter <> "" And IsFunc($aCustomFilter) Then
            $lMatches = Execute($aCustomFilter & "(" & $lAgentPtr & ")")
        EndIf

        ; Process matching agent
        If $lMatches Then
            $lCount += 1

            ; Track closest if needed
            If ($aReturnMode == 1 Or $aReturnMode == 3) And $lDistance < $lClosestDistance Then
                $lClosestAgent = $lAgentPtr
                $lClosestDistance = $lDistance
            EndIf

            ; Track farthest if needed
            If $aReturnMode == 2 And $lDistance > $lFarthestDistance Then
                $lFarthestAgent = $lAgentPtr
                $lFarthestDistance = $lDistance
            EndIf
        EndIf
    Next

    ; Return appropriate result based on mode
    Switch $aReturnMode
        Case 0 ; Count only
            Return $lCount

        Case 1 ; Closest agent
            Return $lClosestAgent

        Case 2 ; Farthest agent (within range)
            Return $lFarthestAgent

        Case 3 ; Distance to closest agent
            Return Sqrt($lClosestDistance)
    EndSwitch
EndFunc

