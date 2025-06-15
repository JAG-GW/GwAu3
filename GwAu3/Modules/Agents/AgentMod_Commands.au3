#include-once

Func GwAu3_AgentMod_ChangeTarget($iAgentID)
    If Not $g_bAgentModuleInitialized Then
        GwAu3_Log_Error("AgentMod module not initialized", "AgentMod", $g_h_EditText)
        Return False
    EndIf

	$iAgentID = GwAu3_AgentMod_ConvertID($iAgentID)

    If $iAgentID < 0 Then
        GwAu3_Log_Error("Invalid agent ID: " & $iAgentID, "AgentMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_mChangeTarget, 1, GwAu3_Memory_GetValue('CommandChangeTarget'))
    DllStructSetData($g_mChangeTarget, 2, $iAgentID)
    GwAu3_Core_Enqueue($g_mChangeTargetPtr, 8)

    ; Record for tracking
    $g_iLastTargetID = $iAgentID

    Return True
EndFunc

Func GwAu3_AgentMod_MakeAgentArray($iType = 0)
    If Not $g_bAgentModuleInitialized Then
        GwAu3_Log_Error("AgentMod module not initialized", "AgentMod", $g_h_EditText)
        Return False
    EndIf

    If $iType < 0 Then
        GwAu3_Log_Error("Invalid agent type: " & $iType, "AgentMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_mMakeAgentArray, 1, GwAu3_Memory_GetValue('CommandMakeAgentArray'))
    DllStructSetData($g_mMakeAgentArray, 2, $iType)
    GwAu3_Core_Enqueue($g_mMakeAgentArrayPtr, 8)

    GwAu3_Log_Debug("Creating agent array snapshot (type filter: " & $iType & ")", "AgentMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_AgentMod_TargetNearestEnemy($fMaxDistance = 1300)
    If Not $g_bAgentModuleInitialized Then
        GwAu3_Log_Error("AgentMod module not initialized", "AgentMod", $g_h_EditText)
        Return 0
    EndIf

    Local $lNearestID = 0
    Local $lNearestDistance = $fMaxDistance
    Local $lMyID = GwAu3_AgentMod_GetMyID()
    Local $lMaxAgents = GwAu3_AgentMod_GetMaxAgents()

    For $i = 1 To $lMaxAgents
        ; Check if agent exists
        Local $lPtr = GwAu3_AgentMod_GetAgentPtr($i)
        If $lPtr = 0 Then ContinueLoop

        ; Check if agent is alive
        If Not GwAu3_AgentMod_IsAlive($i) Then ContinueLoop

        ; Check if agent is an enemy (simplified check)
        Local $lAllegiance = GwAu3_AgentMod_GetAgentInfo($i, "Allegiance")
        If $lAllegiance <> 3 Then ContinueLoop ; 3 = enemy

        ; Calculate distance
        Local $lDistance = GwAu3_AgentMod_GetDistance($i, $lMyID)
        If $lDistance < $lNearestDistance Then
            $lNearestDistance = $lDistance
            $lNearestID = $i
        EndIf
    Next

    If $lNearestID > 0 Then
        GwAu3_AgentMod_ChangeTarget($lNearestID)
        GwAu3_Log_Debug("Targeted nearest enemy: " & $lNearestID & " at distance: " & $lNearestDistance, "AgentMod", $g_h_EditText)
    Else
        GwAu3_Log_Debug("No enemy found within range: " & $fMaxDistance, "AgentMod", $g_h_EditText)
    EndIf

    Return $lNearestID
EndFunc

Func GwAu3_AgentMod_TargetNearestAlly($fMaxDistance = 1300, $bExcludeSelf = True)
    If Not $g_bAgentModuleInitialized Then
        GwAu3_Log_Error("AgentMod module not initialized", "AgentMod", $g_h_EditText)
        Return 0
    EndIf

    Local $lNearestID = 0
    Local $lNearestDistance = $fMaxDistance
    Local $lMyID = GwAu3_AgentMod_GetMyID()
    Local $lMaxAgents = GwAu3_AgentMod_GetMaxAgents()

    For $i = 1 To $lMaxAgents
        ; Skip self if requested
        If $bExcludeSelf And $i = $lMyID Then ContinueLoop

        ; Check if agent exists
        Local $lPtr = GwAu3_AgentMod_GetAgentPtr($i)
        If $lPtr = 0 Then ContinueLoop

        ; Check if agent is alive
        If Not GwAu3_AgentMod_IsAlive($i) Then ContinueLoop

        ; Check if agent is an ally (simplified check)
        Local $lAllegiance = GwAu3_AgentMod_GetAgentInfo($i, "Allegiance")
        If $lAllegiance <> 1 Then ContinueLoop ; 1 = ally

        ; Calculate distance
        Local $lDistance = GwAu3_AgentMod_GetDistance($i, $lMyID)
        If $lDistance < $lNearestDistance Then
            $lNearestDistance = $lDistance
            $lNearestID = $i
        EndIf
    Next

    If $lNearestID > 0 Then
        GwAu3_AgentMod_ChangeTarget($lNearestID)
        GwAu3_Log_Debug("Targeted nearest ally: " & $lNearestID & " at distance: " & $lNearestDistance, "AgentMod", $g_h_EditText)
    Else
        GwAu3_Log_Debug("No ally found within range: " & $fMaxDistance, "AgentMod", $g_h_EditText)
    EndIf

    Return $lNearestID
EndFunc

Func GwAu3_AgentMod_ClearTarget()
    Return GwAu3_AgentMod_ChangeTarget(0)
EndFunc

Func GwAu3_AgentMod_TargetSelf()
    Local $lMyID = GwAu3_AgentMod_GetMyID()
    Return GwAu3_AgentMod_ChangeTarget($lMyID)
EndFunc