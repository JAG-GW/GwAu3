#include-once
#include "AgentMod_Initialize.au3"

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_ChangeTarget
; Description ...: Changes the current target to a specified agent
; Syntax.........: _AgentMod_ChangeTarget($iAgentID)
; Parameters ....: $iAgentID - ID of the agent to target
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Agent must be in range and visible
;                  - Does not validate agent existence
; Related .......: _AgentMod_GetCurrentTarget, _AgentMod_GetAgentInfo
;============================================================================================
Func _AgentMod_ChangeTarget($iAgentID)
    If Not $g_bAgentModuleInitialized Then
        _Log_Error("AgentMod module not initialized", "AgentMod", $GUIEdit)
        Return False
    EndIf

	$iAgentID = ConvertID($iAgentID)

    If $iAgentID < 0 Then
        _Log_Error("Invalid agent ID: " & $iAgentID, "AgentMod", $GUIEdit)
        Return False
    EndIf

    DllStructSetData($g_mChangeTarget, 2, $iAgentID)
    Enqueue($g_mChangeTargetPtr, 8)

    ; Record for tracking
    $g_iLastTargetID = $iAgentID

    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_MakeAgentArray
; Description ...: Creates a snapshot copy of all agents or agents of a specific type
; Syntax.........: _AgentMod_MakeAgentArray($iType = 0)
; Parameters ....: $iType - [optional] Agent type filter (0 for all agents)
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Copies agent data to a separate array for safe iteration
;                  - Useful when you need stable agent data while processing
;                  - Type can be used to filter specific agent types
; Related .......: _AgentMod_GetAgentCopyCount, _AgentMod_GetAgentCopyBase
;============================================================================================
Func _AgentMod_MakeAgentArray($iType = 0)
    If Not $g_bAgentModuleInitialized Then
        _Log_Error("AgentMod module not initialized", "AgentMod", $GUIEdit)
        Return False
    EndIf

    If $iType < 0 Then
        _Log_Error("Invalid agent type: " & $iType, "AgentMod", $GUIEdit)
        Return False
    EndIf

    DllStructSetData($g_mMakeAgentArray, 2, $iType)
    Enqueue($g_mMakeAgentArrayPtr, 8)

    _Log_Debug("Creating agent array snapshot (type filter: " & $iType & ")", "AgentMod", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_TargetNearestEnemy
; Description ...: Targets the nearest enemy agent
; Syntax.........: _AgentMod_TargetNearestEnemy($fMaxDistance = 1300)
; Parameters ....: $fMaxDistance - [optional] Maximum search distance (default: 1300)
; Return values .: Agent ID of targeted enemy, 0 if none found
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Searches for living enemy agents within range
;                  - Automatically changes target to nearest enemy
; Related .......: _AgentMod_ChangeTarget, _AgentMod_GetDistance
;============================================================================================
Func _AgentMod_TargetNearestEnemy($fMaxDistance = 1300)
    If Not $g_bAgentModuleInitialized Then
        _Log_Error("AgentMod module not initialized", "AgentMod", $GUIEdit)
        Return 0
    EndIf

    Local $lNearestID = 0
    Local $lNearestDistance = $fMaxDistance
    Local $lMyID = _AgentMod_GetMyID()
    Local $lMaxAgents = _AgentMod_GetMaxAgents()

    For $i = 1 To $lMaxAgents
        ; Check if agent exists
        Local $lPtr = _AgentMod_GetAgentPtr($i)
        If $lPtr = 0 Then ContinueLoop

        ; Check if agent is alive
        If Not _AgentMod_IsAlive($i) Then ContinueLoop

        ; Check if agent is an enemy (simplified check)
        Local $lAllegiance = _AgentMod_GetAgentInfo($i, "Allegiance")
        If $lAllegiance <> 3 Then ContinueLoop ; 3 = enemy

        ; Calculate distance
        Local $lDistance = _AgentMod_GetDistance($i, $lMyID)
        If $lDistance < $lNearestDistance Then
            $lNearestDistance = $lDistance
            $lNearestID = $i
        EndIf
    Next

    If $lNearestID > 0 Then
        _AgentMod_ChangeTarget($lNearestID)
        _Log_Debug("Targeted nearest enemy: " & $lNearestID & " at distance: " & $lNearestDistance, "AgentMod", $GUIEdit)
    Else
        _Log_Debug("No enemy found within range: " & $fMaxDistance, "AgentMod", $GUIEdit)
    EndIf

    Return $lNearestID
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_TargetNearestAlly
; Description ...: Targets the nearest ally agent
; Syntax.........: _AgentMod_TargetNearestAlly($fMaxDistance = 1300, $bExcludeSelf = True)
; Parameters ....: $fMaxDistance - [optional] Maximum search distance (default: 1300)
;                  $bExcludeSelf - [optional] Exclude self from search (default: True)
; Return values .: Agent ID of targeted ally, 0 if none found
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Searches for living ally agents within range
;                  - Useful for healing or buffing allies
; Related .......: _AgentMod_ChangeTarget, _AgentMod_GetDistance
;============================================================================================
Func _AgentMod_TargetNearestAlly($fMaxDistance = 1300, $bExcludeSelf = True)
    If Not $g_bAgentModuleInitialized Then
        _Log_Error("AgentMod module not initialized", "AgentMod", $GUIEdit)
        Return 0
    EndIf

    Local $lNearestID = 0
    Local $lNearestDistance = $fMaxDistance
    Local $lMyID = _AgentMod_GetMyID()
    Local $lMaxAgents = _AgentMod_GetMaxAgents()

    For $i = 1 To $lMaxAgents
        ; Skip self if requested
        If $bExcludeSelf And $i = $lMyID Then ContinueLoop

        ; Check if agent exists
        Local $lPtr = _AgentMod_GetAgentPtr($i)
        If $lPtr = 0 Then ContinueLoop

        ; Check if agent is alive
        If Not _AgentMod_IsAlive($i) Then ContinueLoop

        ; Check if agent is an ally (simplified check)
        Local $lAllegiance = _AgentMod_GetAgentInfo($i, "Allegiance")
        If $lAllegiance <> 1 Then ContinueLoop ; 1 = ally

        ; Calculate distance
        Local $lDistance = _AgentMod_GetDistance($i, $lMyID)
        If $lDistance < $lNearestDistance Then
            $lNearestDistance = $lDistance
            $lNearestID = $i
        EndIf
    Next

    If $lNearestID > 0 Then
        _AgentMod_ChangeTarget($lNearestID)
        _Log_Debug("Targeted nearest ally: " & $lNearestID & " at distance: " & $lNearestDistance, "AgentMod", $GUIEdit)
    Else
        _Log_Debug("No ally found within range: " & $fMaxDistance, "AgentMod", $GUIEdit)
    EndIf

    Return $lNearestID
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_ClearTarget
; Description ...: Clears the current target
; Syntax.........: _AgentMod_ClearTarget()
; Parameters ....: None
; Return values .: True if successful, False otherwise
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Sets target to 0 (no target)
; Related .......: _AgentMod_ChangeTarget, _AgentMod_GetCurrentTarget
;============================================================================================
Func _AgentMod_ClearTarget()
    Return _AgentMod_ChangeTarget(0)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_TargetSelf
; Description ...: Targets the player's own agent
; Syntax.........: _AgentMod_TargetSelf()
; Parameters ....: None
; Return values .: True if successful, False otherwise
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Useful for self-targeting skills
; Related .......: _AgentMod_ChangeTarget, _AgentMod_GetMyID
;============================================================================================
Func _AgentMod_TargetSelf()
    Local $lMyID = _AgentMod_GetMyID()
    Return _AgentMod_ChangeTarget($lMyID)
EndFunc