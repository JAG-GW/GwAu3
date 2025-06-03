#include-once

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

	DllStructSetData($g_mChangeTarget, 1, GetValue('CommandChangeTarget'))
    DllStructSetData($g_mChangeTarget, 2, $iAgentID)
    Enqueue($g_mChangeTargetPtr, 8)

    ; Record for tracking
    $g_iLastTargetID = $iAgentID

    Return True
EndFunc

Func _AgentMod_MakeAgentArray($iType = 0)
    If Not $g_bAgentModuleInitialized Then
        _Log_Error("AgentMod module not initialized", "AgentMod", $GUIEdit)
        Return False
    EndIf

    If $iType < 0 Then
        _Log_Error("Invalid agent type: " & $iType, "AgentMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
    DllStructSetData($g_mMakeAgentArray, 2, $iType)
    Enqueue($g_mMakeAgentArrayPtr, 8)

    _Log_Debug("Creating agent array snapshot (type filter: " & $iType & ")", "AgentMod", $GUIEdit)
    Return True
EndFunc

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

Func _AgentMod_ClearTarget()
    Return _AgentMod_ChangeTarget(0)
EndFunc

Func _AgentMod_TargetSelf()
    Local $lMyID = _AgentMod_GetMyID()
    Return _AgentMod_ChangeTarget($lMyID)
EndFunc