#include-once

; ===============================================================
; Array Structure System for GwAu3
; ===============================================================

; ===============================================================
; Creates an array structure definition
; ===============================================================
Func Memory_CreateArrayStructure($a_a_Definition, $a_i_ElementSize)
    ; Use the single structure creation function
    Local $l_a_StructInfo = Memory_CreateStructure($a_a_Definition)
    If @error Then Return SetError(1, 0, 0)

    ; Add array-specific information
    Local $l_a_ArrayStructInfo[5]
    $l_a_ArrayStructInfo[0] = $l_a_StructInfo[0]  ; Structure template
    $l_a_ArrayStructInfo[1] = $l_a_StructInfo[1]  ; Structure size
    $l_a_ArrayStructInfo[2] = $l_a_StructInfo[2]  ; Field indices
    $l_a_ArrayStructInfo[3] = $l_a_StructInfo[3]  ; Field count
    $l_a_ArrayStructInfo[4] = $a_i_ElementSize    ; Size of each element in the array

    Return $l_a_ArrayStructInfo
EndFunc

; ===============================================================
; Reads an array of pointers to structures
; ===============================================================
Func Memory_ReadPointerArrayStruct($a_p_PointerArrayBase, $a_i_ArraySize, ByRef $a_a_StructInfo)
    If Not IsArray($a_a_StructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)

    Local $l_i_FieldCount = $a_a_StructInfo[3]
    Local $l_a_FieldIndices = $a_a_StructInfo[2]

    ; First, read all pointers in the array
    Local $l_d_PointerBuffer = DllStructCreate("ptr[" & $a_i_ArraySize & "]")

    Local $l_a_Call = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
        "handle", $g_h_GWProcess, _
        "ptr", $a_p_PointerArrayBase, _
        "struct*", $l_d_PointerBuffer, _
        "ulong_ptr", 4 * $a_i_ArraySize, _ ; 4 bytes per pointer
        "ulong_ptr*", 0)

    If @error Or Not $l_a_Call[0] Then Return SetError(3, 0, 0)

    ; Count valid (non-null) pointers
    Local $l_i_ValidCount = 0
    For $i = 1 To $a_i_ArraySize
        If DllStructGetData($l_d_PointerBuffer, 1, $i) <> 0 Then
            $l_i_ValidCount += 1
        EndIf
    Next

    If $l_i_ValidCount = 0 Then Return SetError(4, 0, 0)

    ; Create the results table for valid agents only
    Local $l_a_Results[$l_i_ValidCount][$l_i_FieldCount + 1] ; +1 to store the pointer

    ; Structure for reading data
    Local $l_t_Struct = $a_a_StructInfo[0]
    Local $l_i_ResultIndex = 0

    ; Read each structure pointed to
    For $i = 1 To $a_i_ArraySize
        Local $l_p_StructPtr = DllStructGetData($l_d_PointerBuffer, 1, $i)

        ; Ignore null pointers
        If $l_p_StructPtr = 0 Then ContinueLoop

        ; Read the structure at this address
        Local $l_a_Call = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_StructPtr, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $a_a_StructInfo[1], _
            "ulong_ptr*", 0)

        If @error Or Not $l_a_Call[0] Then ContinueLoop

        ; Store the pointer in the first column
        $l_a_Results[$l_i_ResultIndex][0] = $l_p_StructPtr

        ; Extract all defined fields
        For $j = 0 To $l_i_FieldCount - 1
            $l_a_Results[$l_i_ResultIndex][$j + 1] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
        Next

        $l_i_ResultIndex += 1
    Next

    Return $l_a_Results
EndFunc

; ===============================================================
; Read entire array of structures
; ===============================================================
Func Memory_ReadArrayStruct($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo)
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)

    Local $l_i_FieldCount = $l_a_ArrayStructInfo[3]
    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_FieldIndices = $l_a_ArrayStructInfo[2]

    ; Create 2D array for results [row][field]
    Local $l_a_Results[$a_i_ArraySize][$l_i_FieldCount]

    ; Create structure for single read
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]

    ; Read each element
    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)

        ; Single memory read for this element
        Local $aCall = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)

        If @error Or Not $aCall[0] Then ContinueLoop

        ; Extract all fields for this element
        For $j = 0 To $l_i_FieldCount - 1
            $l_a_Results[$i][$j] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
        Next
    Next

    Return $l_a_Results
EndFunc

; ===============================================================
; Read entire array with field selection
; ===============================================================
Func Memory_ReadArrayStructFields($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo, $a_s_Fields)
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)

    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_RequestedFields = StringSplit($a_s_Fields, "|", 2)
    Local $l_i_RequestedCount = UBound($l_a_RequestedFields)

    ; Create 2D array for results
    Local $l_a_Results[$a_i_ArraySize][$l_i_RequestedCount]

    ; Create structure for single read
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]

    ; Read each element
    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)

        ; Single memory read for this element
        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)

        ; Extract only requested fields
        For $j = 0 To $l_i_RequestedCount - 1
            $l_a_Results[$i][$j] = DllStructGetData($l_t_Struct, $l_a_RequestedFields[$j])
        Next
    Next

    Return $l_a_Results
EndFunc

; ===============================================================
; Read array with filtering
; ===============================================================
Func Memory_ReadArrayStructFiltered($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo, $a_s_FilterField, $a_v_FilterValue, $a_i_FilterOperator = 0)
    ; $a_i_FilterOperator: 0 = equal, 1 = not equal, 2 = greater, 3 = less
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)

    Local $l_i_FieldCount = $l_a_ArrayStructInfo[3]
    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_FieldIndices = $l_a_ArrayStructInfo[2]

    ; First, count matching elements
    Local $l_i_MatchCount = 0
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]
    Local $l_a_Matches[$a_i_ArraySize]

    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)

        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)

        Local $l_v_FieldValue = DllStructGetData($l_t_Struct, $a_s_FilterField)
        Local $l_b_Match = False

        Switch $a_i_FilterOperator
            Case 0 ; Equal
                $l_b_Match = ($l_v_FieldValue = $a_v_FilterValue)
            Case 1 ; Not equal
                $l_b_Match = ($l_v_FieldValue <> $a_v_FilterValue)
            Case 2 ; Greater
                $l_b_Match = ($l_v_FieldValue > $a_v_FilterValue)
            Case 3 ; Less
                $l_b_Match = ($l_v_FieldValue < $a_v_FilterValue)
        EndSwitch

        If $l_b_Match Then
            $l_a_Matches[$l_i_MatchCount] = $i
            $l_i_MatchCount += 1
        EndIf
    Next

    If $l_i_MatchCount = 0 Then Return SetError(3, 0, 0)

    ; Create result array with only matching elements
    Local $l_a_Results[$l_i_MatchCount][$l_i_FieldCount]

    ; Read matching elements
    For $i = 0 To $l_i_MatchCount - 1
        Local $l_i_Index = $l_a_Matches[$i]
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($l_i_Index * $l_i_ElementSize)

        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)

        For $j = 0 To $l_i_FieldCount - 1
            $l_a_Results[$i][$j] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
        Next
    Next

    Return $l_a_Results
EndFunc

; ===============================================================
; Find single element in array
; ===============================================================
Func Memory_FindInArrayStruct($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo, $sSearchField, $a_v_SearchValue)
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)

    Local $l_i_FieldCount = $l_a_ArrayStructInfo[3]
    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_FieldIndices = $l_a_ArrayStructInfo[2]
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]

    ; Search for the element
    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)

        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)

        Local $l_v_FieldValue = DllStructGetData($l_t_Struct, $sSearchField)

        If $l_v_FieldValue = $a_v_SearchValue Then
            ; Found it, extract all fields
            Local $l_a_Result[$l_i_FieldCount]
            For $j = 0 To $l_i_FieldCount - 1
                $l_a_Result[$j] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
            Next
            Return $l_a_Result
        EndIf
    Next

    Return SetError(3, 0, 0) ; Not found
EndFunc

; ===============================================================
; Usage Examples
; ===============================================================
#CS
; Get all hero flags
Func Party_GetAllHeroFlags()
    Static $l_a_StructInfo = Memory_CreateArrayStructure( _
        "dword HeroID[0x0];" & _
        "dword AgentID[0x4];" & _
        "dword Level[0x8];" & _
        "dword Behavior[0xC];" & _
        "float FlagX[0x10];" & _
        "float FlagY[0x14];" & _
        "dword h0018[0x18];" & _
        "dword h001C[0x1C];" & _
        "dword LockedTargetID[0x20]", _
        0x24) ; Element size

    Local $l_p_Ptr = World_GetWorldInfo("HeroFlagArray")
    Local $l_i_Size = World_GetWorldInfo("HeroFlagArraySize")

    If $l_p_Ptr = 0 Or $l_i_Size = 0 Then Return SetError(1, 0, 0)

    Return Memory_ReadArrayStruct($l_p_Ptr, $l_i_Size, $l_a_StructInfo)
EndFunc

; Get specific hero flag by AgentID
Func Party_GetHeroFlagByAgentID($a_i_AgentID)
    Static $l_a_StructInfo = Memory_CreateArrayStructure( _
        "dword HeroID[0x0];" & _
        "dword AgentID[0x4];" & _
        "dword Level[0x8];" & _
        "dword Behavior[0xC];" & _
        "float FlagX[0x10];" & _
        "float FlagY[0x14];" & _
        "dword h0018[0x18];" & _
        "dword h001C[0x1C];" & _
        "dword LockedTargetID[0x20]", _
        0x24)

    Local $l_p_Ptr = World_GetWorldInfo("HeroFlagArray")
    Local $l_i_Size = World_GetWorldInfo("HeroFlagArraySize")

    If $l_p_Ptr = 0 Or $l_i_Size = 0 Then Return SetError(1, 0, 0)

    Return Memory_FindInArrayStruct($l_p_Ptr, $l_i_Size, $l_a_StructInfo, "AgentID", $a_i_AgentID)
EndFunc

; Example usage with filtering
Func Party_GetHeroFlagsWithBehavior($a_i_Behavior)
    Static $l_a_StructInfo = Memory_CreateArrayStructure( _
        "dword HeroID[0x0];" & _
        "dword AgentID[0x4];" & _
        "dword Level[0x8];" & _
        "dword Behavior[0xC];" & _
        "float FlagX[0x10];" & _
        "float FlagY[0x14];" & _
        "dword LockedTargetID[0x20]", _
        0x24)

    Local $l_p_Ptr = World_GetWorldInfo("HeroFlagArray")
    Local $l_i_Size = World_GetWorldInfo("HeroFlagArraySize")

    If $l_p_Ptr = 0 Or $l_i_Size = 0 Then Return SetError(1, 0, 0)

    Return Memory_ReadArrayStructFiltered($l_p_Ptr, $l_i_Size, $l_a_StructInfo, "Behavior", $a_i_Behavior, 0)
EndFunc
#CE