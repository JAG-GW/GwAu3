#include-once

; ===============================================================
; Creates an optimized structure definition from a string
; ===============================================================
Func Memory_CreateStructure($a_a_Definition)
    ; Parse the definition
    Local $l_a_Lines = StringSplit($a_a_Definition, ";", 2)
    Local $l_a_Fields[UBound($l_a_Lines)][5] ; Added column for struct index
    Local $l_i_FieldCount = 0

    ; Parse and sort fields
    For $i = 0 To UBound($l_a_Lines) - 1
        Local $l_s_Line = StringStripWS($l_a_Lines[$i], 3)
        If $l_s_Line = "" Then ContinueLoop

        Local $l_a_Match = StringRegExp($l_s_Line, "^(\w+)\s+(\w+)\[0x([0-9A-Fa-f]+)\]", 3)
        If @error Or UBound($l_a_Match) < 3 Then ContinueLoop

        $l_a_Fields[$l_i_FieldCount][0] = $l_a_Match[0] ; Type
        $l_a_Fields[$l_i_FieldCount][1] = $l_a_Match[1] ; Name
        $l_a_Fields[$l_i_FieldCount][2] = Dec($l_a_Match[2]) ; Offset
        $l_a_Fields[$l_i_FieldCount][3] = Memory_GetTypeSize($l_a_Match[0]) ; Size
        $l_a_Fields[$l_i_FieldCount][4] = 0 ; Index in struct (will be set later)
        $l_i_FieldCount += 1
    Next

    ReDim $l_a_Fields[$l_i_FieldCount][5]

    ; Sort by offset
    For $i = 0 To $l_i_FieldCount - 2
        For $j = $i + 1 To $l_i_FieldCount - 1
            If $l_a_Fields[$i][2] > $l_a_Fields[$j][2] Then
                For $k = 0 To 4
                    Local $vTemp = $l_a_Fields[$i][$k]
                    $l_a_Fields[$i][$k] = $l_a_Fields[$j][$k]
                    $l_a_Fields[$j][$k] = $vTemp
                Next
            EndIf
        Next
    Next

    ; Build optimized structure and track indices
    Local $l_s_StructDef = ""
    Local $l_i_CurrentOffset = 0
    Local $l_i_StructIndex = 1 ; DllStruct indices start at 1

    ; Initial padding if necessary
    If $l_a_Fields[0][2] > 0 Then
        $l_s_StructDef = "byte[" & $l_a_Fields[0][2] & "];"
        $l_i_CurrentOffset = $l_a_Fields[0][2]
        $l_i_StructIndex += 1
    EndIf

    ; Add fields and memorize their indices
    For $i = 0 To $l_i_FieldCount - 1
        $l_s_StructDef &= $l_a_Fields[$i][0] & " " & $l_a_Fields[$i][1] & ";"
        $l_a_Fields[$i][4] = $l_i_StructIndex ; Save the index
        $l_i_StructIndex += 1
        $l_i_CurrentOffset += $l_a_Fields[$i][3]

        ; Add padding between fields if necessary
        If $i < $l_i_FieldCount - 1 Then
            Local $l_i_Gap = $l_a_Fields[$i + 1][2] - $l_i_CurrentOffset
            If $l_i_Gap > 0 Then
                $l_s_StructDef &= "byte[" & $l_i_Gap & "];"
                $l_i_CurrentOffset += $l_i_Gap
                $l_i_StructIndex += 1
            EndIf
        EndIf
    Next

    ; Create the structure
    Local $l_t_Struct = DllStructCreate(StringTrimRight($l_s_StructDef, 1))
    Local $l_i_Size = DllStructGetSize($l_t_Struct)

    ; Create index array for fast access
    Local $l_a_FieldIndices[$l_i_FieldCount]
    For $i = 0 To $l_i_FieldCount - 1
        $l_a_FieldIndices[$i] = $l_a_Fields[$i][4]
    Next

    ; Return everything we need
    Local $l_a_Result[4]
    $l_a_Result[0] = $l_t_Struct       ; The structure
    $l_a_Result[1] = $l_i_Size         ; Its size
    $l_a_Result[2] = $l_a_FieldIndices ; Field indices
    $l_a_Result[3] = $l_i_FieldCount   ; Number of fields

    Return $l_a_Result
EndFunc

; ===============================================================
; Optimized reading without loops
; ===============================================================
Func Memory_ReadStruct($a_p_Address, ByRef $a_a_StructInfo)
    Local $l_t_Struct = $a_a_StructInfo[0]
    Local $l_i_Size = $a_a_StructInfo[1]
    Local $l_a_Indices = $a_a_StructInfo[2]
    Local $l_i_FieldCount = $a_a_StructInfo[3]

    ; Single memory read
    Local $l_a_Call = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
        "handle", $g_h_GWProcess, _
        "ptr", $a_p_Address, _
        "struct*", $l_t_Struct, _
        "ulong_ptr", $l_i_Size, _
        "ulong_ptr*", 0)

    ; Check if read succeeded
    If @error Or Not $l_a_Call[0] Then Return SetError(1, 0, 0)

    ; Extract values using correct indices
    Local $l_a_Result[$l_i_FieldCount]

    For $i = 0 To $l_i_FieldCount - 1
        $l_a_Result[$i] = DllStructGetData($l_t_Struct, $l_a_Indices[$i])
    Next

    Return $l_a_Result
EndFunc

; ===============================================================
; Version with specific field selection
; ===============================================================
Func Memory_ReadStructFields($a_p_Address, ByRef $a_a_StructInfo, $a_s_Fields)
    Local $l_t_Struct = $a_a_StructInfo[0]
    Local $l_i_Size = $a_a_StructInfo[1]

    ; Single memory read
    DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
        "handle", $g_h_GWProcess, _
        "ptr", $a_p_Address, _
        "struct*", $l_t_Struct, _
        "ulong_ptr", $l_i_Size, _
        "ulong_ptr*", 0)

    ; Extract only requested fields
    Local $l_a_RequestedFields = StringSplit($a_s_Fields, "|", 2)
    Local $l_i_Count = UBound($l_a_RequestedFields)
    Local $l_a_Result[$l_i_Count]

    For $i = 0 To $l_i_Count - 1
        $l_a_Result[$i] = DllStructGetData($l_t_Struct, $l_a_RequestedFields[$i])
    Next

    Return $l_a_Result
EndFunc

; ===============================================================
; Returns the size of a type
; ===============================================================
Func Memory_GetTypeSize($a_s_Type)
    Local $l_i_Size
    Switch StringLower($a_s_Type)
        Case 'byte', 'boolean', 'char'
			$l_i_Size = 1
        Case 'wchar', 'short', 'ushort', 'word'
            $l_i_Size = 2
        Case 'int', 'long', 'bool', 'uint', 'ulong', 'dword', 'float'
            $l_i_Size = 4
        Case 'int64', 'uint64', 'double'
            $l_i_Size = 8
        Case 'ptr', 'hwnd', 'handle'
            $l_i_Size = @AutoItX64 ? 8 : 4
        Case Else
            $l_i_Size = 0
    EndSwitch
    Return $l_i_Size
EndFunc

; ===============================================================
; Usage Examples
; ===============================================================
#CS
; Version using the optimized system
Func Agent_GeneralInfo($a_i_AgentID = -2)
    Static $gs_s_StructInfo = Memory_CreateStructure( _
        "float X[0x74];" & _
        "float Y[0x78];" & _
        "float HP[0x130];" & _
        "short Skill[0x1B4]")

    Local $l_p_AgentPtr = Agent_GetAgentPtr($a_i_AgentID)
    If $l_p_AgentPtr = 0 Then Return SetError(1, 0, 0)

    Return Memory_ReadStruct($l_p_AgentPtr, $gs_s_StructInfo)
EndFunc

; Version with field selection
Func Agent_GetPosition($a_i_AgentID = -2)
    Static $gs_s_StructInfo = Memory_CreateStructure( _
        "float X[0x74];" & _
        "float Y[0x78];" & _
        "float Z[0x30]")

    Local $l_p_AgentPtr = Agent_GetAgentPtr($a_i_AgentID)
    If $l_p_AgentPtr = 0 Then Return SetError(1, 0, 0)

    Return Memory_ReadStructFields($l_p_AgentPtr, $gs_s_StructInfo, "X|Y")
EndFunc

; Version using the optimized system
Func Skill_Base($a_i_SkillID)
    Static $gs_s_StructInfo = Memory_CreateStructure( _
		"long SkillID[0x0];" & _
		"byte Target[0x31];" & _
        "byte EnergyCost[0x35];")

    Local $l_p_SkillPtr = Skill_GetSkillPtr($a_i_SkillID)
    If $l_p_SkillPtr = 0 Then Return SetError(1, 0, 0)

    Return Memory_ReadStruct($l_p_SkillPtr, $gs_s_StructInfo)
EndFunc

; Version with field selection
Func Skill_Base2($a_i_SkillID)
    Static $gs_s_StructInfo = Memory_CreateStructure( _
		"long SkillID[0x0];" & _
		"byte Target[0x31];" & _
        "byte EnergyCost[0x35];")

    Local $l_p_SkillPtr = Skill_GetSkillPtr($a_i_SkillID)
    If $l_p_SkillPtr = 0 Then Return SetError(1, 0, 0)

    Return Memory_ReadStructFields($l_p_SkillPtr, $gs_s_StructInfo, "Target|EnergyCost")
EndFunc
#CE