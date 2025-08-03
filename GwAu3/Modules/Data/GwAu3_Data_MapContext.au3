#include-once

#Region Map Context
Func Map_GetMapContextPtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x14]
    Local $l_ap_MapPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, 'ptr')
    Return $l_ap_MapPtr[1]
EndFunc

Func Map_GetMapContextInfo($a_s_Info = "")
    Local $l_p_Ptr = Map_GetMapContextPtr()
    If $l_p_Ptr = 0 Then
        Log_Error("MapContext is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    If $a_s_Info = "" Then
        Log_Warning("No info requested from MapContext", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_v_Result = 0
    Switch $a_s_Info
        Case "MapBoundaries"
            $l_v_Result = Memory_Read($l_p_Ptr, "float[5]")
        Case "Sub1"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x74, "ptr")
        Case "PropsContext"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x7C, "ptr")
        Case "Terrain"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x84, "ptr")
        Case "Zones"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x130, "ptr")
    EndSwitch

    Return $l_v_Result
EndFunc

Func Map_GetPathingMapArray()
    Local $l_p_Sub1 = Map_GetMapContextInfo("Sub1")
    If $l_p_Sub1 = 0 Then
        Log_Error("Sub1 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_p_Sub2 = Memory_Read($l_p_Sub1, "ptr")
    If $l_p_Sub2 = 0 Then
        Log_Error("Sub2 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    ; PathingMapArray at sub2 + 0x18
    ; This is the address of the Array structure, not the pointer to the data
    Local $l_p_ArrayStruct = $l_p_Sub2 + 0x18
    Return $l_p_ArrayStruct
EndFunc

Func Map_GetPathingMapArrayInfo($a_s_Info = "")
    Local $l_p_ArrayStruct = Map_GetPathingMapArray()
    If $l_p_ArrayStruct = 0 Then Return 0

    Switch $a_s_Info
        Case "Buffer"
            Return Memory_Read($l_p_ArrayStruct, "ptr")
        Case "Size"
            Return Memory_Read($l_p_ArrayStruct + 0x8, "dword")
        Case "Capacity"
            Return Memory_Read($l_p_ArrayStruct + 0x4, "dword")
    EndSwitch
    Return 0
EndFunc

Func Map_GetTotalTrapezoidCount()
    Local $l_p_Sub1 = Map_GetMapContextInfo("Sub1")
    If $l_p_Sub1 = 0 Then
        Log_Error("Sub1 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_i_Count = Memory_Read($l_p_Sub1 + 0x18, "dword")
    Log_Info("Total trapezoid count: " & $l_i_Count, "PathFinding", $g_h_EditText)
    Return $l_i_Count
EndFunc

Func Map_GetPathingMapBlockArray()
    Local $l_p_Sub1 = Map_GetMapContextInfo("Sub1")
    If $l_p_Sub1 = 0 Then
        Log_Error("Sub1 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    ; Array at sub1 + 0x04
    Local $l_p_ArrayPtr = Memory_Read($l_p_Sub1 + 0x04, "ptr")
    Local $l_i_ArraySize = Memory_Read($l_p_Sub1 + 0x0C, "dword")

    If $l_p_ArrayPtr = 0 Or $l_i_ArraySize = 0 Then
        Log_Warning("Block array is empty", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_a_Result[$l_i_ArraySize]
    For $i = 0 To $l_i_ArraySize - 1
        $l_a_Result[$i] = Memory_Read($l_p_ArrayPtr + ($i * 4), "dword")
    Next

    Log_Info("Loaded " & $l_i_ArraySize & " block entries", "PathFinding", $g_h_EditText)
    Return $l_a_Result
EndFunc
#EndRegion Map Context

#Region Pathing Structures
Func Map_GetPathingMap($a_i_Index)
    Local $l_p_Array = Map_GetPathingMapArray()
    If $l_p_Array = 0 Then
        Log_Error("PathingMapArray is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_p_ArraySize = Memory_Read($l_p_Array + 0x8, "dword")
    If $a_i_Index >= $l_p_ArraySize Then
        Log_Error("Index " & $a_i_Index & " out of bounds (size: " & $l_p_ArraySize & ")", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_p_ArrayPtr = Memory_Read($l_p_Array, "ptr")
    Local $l_p_Result = $l_p_ArrayPtr + ($a_i_Index * 0x54) ; sizeof(PathingMap) = 84

    Return $l_p_Result
EndFunc

Func Map_GetPathingMapInfo($a_i_Index, $a_s_Info = "")
    Local $l_p_PathingMap = Map_GetPathingMap($a_i_Index)
    If $l_p_PathingMap = 0 Then Return 0

    If $a_s_Info = "" Then
        Log_Warning("No info requested from PathingMap", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_v_Result = 0
    Switch $a_s_Info
        Case "ZPlane"
            $l_v_Result = Memory_Read($l_p_PathingMap, "dword")
        Case "TrapezoidCount"
            $l_v_Result = Memory_Read($l_p_PathingMap + 0x14, "dword")
        Case "Trapezoids"
            $l_v_Result = Memory_Read($l_p_PathingMap + 0x18, "ptr")
        Case "RootNode"
            $l_v_Result = Memory_Read($l_p_PathingMap + 0x44, "ptr")
    EndSwitch

    Return $l_v_Result
EndFunc

Func Map_GetTrapezoid($a_p_TrapezoidsPtr, $a_i_Index)
    Local $l_p_Result = $a_p_TrapezoidsPtr + ($a_i_Index * 0x30) ; sizeof(PathingTrapezoid) = 48
    Return $l_p_Result
EndFunc

Func Map_GetTrapezoidInfo($a_p_TrapezoidPtr, $a_s_Info = "")
    If $a_p_TrapezoidPtr = 0 Then
        Log_Error("TrapezoidPtr is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    If $a_s_Info = "" Then Return 0

    Local $l_v_Result = 0
    Switch $a_s_Info
        Case "ID"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr, "dword")
        Case "XTL"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x18, "float")
        Case "XTR"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x1C, "float")
        Case "YT"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x20, "float")
        Case "XBL"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x24, "float")
        Case "XBR"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x28, "float")
        Case "YB"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x2C, "float")
    EndSwitch

    Return $l_v_Result
EndFunc
#EndRegion Pathing Structures