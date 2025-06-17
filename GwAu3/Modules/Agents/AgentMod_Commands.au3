#include-once

Func GwAu3_AgentMod_ChangeTarget($a_i_AgentID)
	$a_i_AgentID = GwAu3_AgentMod_ConvertID($a_i_AgentID)

    If $a_i_AgentID < 0 Then
        GwAu3_Log_Error("Invalid agent ID: " & $a_i_AgentID, "AgentMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_ChangeTarget, 1, GwAu3_Memory_GetValue('CommandChangeTarget'))
    DllStructSetData($g_d_ChangeTarget, 2, $a_i_AgentID)
    GwAu3_Core_Enqueue($g_p_ChangeTarget, 8)

    ; Record for tracking
    $g_i_LastTargetID = $a_i_AgentID

    Return True
EndFunc

Func GwAu3_AgentMod_MakeAgentArray($a_i_Type = 0)
    If $a_i_Type < 0 Then
        GwAu3_Log_Error("Invalid agent type: " & $a_i_Type, "AgentMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_MakeAgentArray, 1, GwAu3_Memory_GetValue('CommandMakeAgentArray'))
    DllStructSetData($g_d_MakeAgentArray, 2, $a_i_Type)
    GwAu3_Core_Enqueue($g_p_MakeAgentArray, 8)

    GwAu3_Log_Debug("Creating agent array snapshot (type filter: " & $a_i_Type & ")", "AgentMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_AgentMod_TargetNearestEnemy($a_f_MaxDistance = 1300)
    Local $l_i_NearestID = 0
    Local $l_f_NearestDistance = $a_f_MaxDistance
    Local $l_i_MyID = GwAu3_AgentMod_GetMyID()
    Local $l_i_MaxAgents = GwAu3_AgentMod_GetMaxAgents()

    For $i = 1 To $l_i_MaxAgents
        ; Check if agent exists
        Local $l_p_Pointer = GwAu3_AgentMod_GetAgentPtr($i)
        If $l_p_Pointer = 0 Then ContinueLoop

        ; Check if agent is alive
        If Not GwAu3_AgentMod_IsAlive($i) Then ContinueLoop

        ; Check if agent is an enemy (simplified check)
        Local $l_i_Allegiance = GwAu3_AgentMod_GetAgentInfo($i, "Allegiance")
        If $l_i_Allegiance <> 3 Then ContinueLoop ; 3 = enemy

        ; Calculate distance
        Local $l_f_Distance = GwAu3_AgentMod_GetDistance($i, $l_i_MyID)
        If $l_f_Distance < $l_f_NearestDistance Then
            $l_f_NearestDistance = $l_f_Distance
            $l_i_NearestID = $i
        EndIf
    Next

    If $l_i_NearestID > 0 Then
        GwAu3_AgentMod_ChangeTarget($l_i_NearestID)
        GwAu3_Log_Debug("Targeted nearest enemy: " & $l_i_NearestID & " at distance: " & $l_f_NearestDistance, "AgentMod", $g_h_EditText)
    Else
        GwAu3_Log_Debug("No enemy found within range: " & $a_f_MaxDistance, "AgentMod", $g_h_EditText)
    EndIf

    Return $l_i_NearestID
EndFunc

Func GwAu3_AgentMod_TargetNearestAlly($a_f_MaxDistance = 1300, $a_b_ExcludeSelf = True)
    Local $l_i_NearestID = 0
    Local $l_f_NearestDistance = $a_f_MaxDistance
    Local $l_i_MyID = GwAu3_AgentMod_GetMyID()
    Local $l_i_MaxAgents = GwAu3_AgentMod_GetMaxAgents()

    For $l_i_Index = 1 To $l_i_MaxAgents
        ; Skip self if requested
        If $a_b_ExcludeSelf And $l_i_Index = $l_i_MyID Then ContinueLoop

        ; Check if agent exists
        Local $l_p_Pointer = GwAu3_AgentMod_GetAgentPtr($l_i_Index)
        If $l_p_Pointer = 0 Then ContinueLoop

        ; Check if agent is alive
        If Not GwAu3_AgentMod_IsAlive($l_i_Index) Then ContinueLoop

        ; Check if agent is an ally (simplified check)
        Local $l_i_Allegiance = GwAu3_AgentMod_GetAgentInfo($l_i_Index, "Allegiance")
        If $l_i_Allegiance <> 1 Then ContinueLoop ; 1 = ally

        ; Calculate distance
        Local $l_f_Distance = GwAu3_AgentMod_GetDistance($l_i_Index, $l_i_MyID)
        If $l_f_Distance < $l_f_NearestDistance Then
            $l_f_NearestDistance = $l_f_Distance
            $l_i_NearestID = $l_i_Index
        EndIf
    Next

    If $l_i_NearestID > 0 Then
        GwAu3_AgentMod_ChangeTarget($l_i_NearestID)
        GwAu3_Log_Debug("Targeted nearest ally: " & $l_i_NearestID & " at distance: " & $l_f_NearestDistance, "AgentMod", $g_h_EditText)
    Else
        GwAu3_Log_Debug("No ally found within range: " & $a_f_MaxDistance, "AgentMod", $g_h_EditText)
    EndIf

    Return $l_i_NearestID
EndFunc

Func GwAu3_AgentMod_ClearTarget()
    Return GwAu3_AgentMod_ChangeTarget(0)
EndFunc

Func GwAu3_AgentMod_TargetSelf()
    Local $l_i_MyID = GwAu3_AgentMod_GetMyID()
    Return GwAu3_AgentMod_ChangeTarget($l_i_MyID)
EndFunc