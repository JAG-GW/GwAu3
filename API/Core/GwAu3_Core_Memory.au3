#include-once

Func Memory_Open($a_i_PID)
    $g_h_Kernel32 = DllOpen('kernel32.dll')
    Local $l_ai_OpenProcess = DllCall($g_h_Kernel32, 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', 1, 'int', $a_i_PID)
    $g_h_GWProcess = $l_ai_OpenProcess[0]
EndFunc

Func Memory_Close()
    DllCall($g_h_Kernel32, 'int', 'CloseHandle', 'int', $g_h_GWProcess)
    DllClose($g_h_Kernel32)
EndFunc

Func Memory_WriteBinary($a_s_BinaryString, $a_p_Address)
    Local $l_d_Data = DllStructCreate('byte[' & 0.5 * StringLen($a_s_BinaryString) & ']')
    Local $l_i_Index

    For $l_i_Index = 1 To DllStructGetSize($l_d_Data)
        DllStructSetData($l_d_Data, 1, Dec(StringMid($a_s_BinaryString, 2 * $l_i_Index - 1, 2)), $l_i_Index)
    Next

    DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'ptr', $a_p_Address, 'ptr', DllStructGetPtr($l_d_Data), 'int', DllStructGetSize($l_d_Data), 'int', 0)
EndFunc

Func Memory_Write($a_p_Address, $a_v_Data, $a_s_Type = 'dword')
    Local $l_d_Buffer = DllStructCreate($a_s_Type)
    DllStructSetData($l_d_Buffer, 1, $a_v_Data)
    DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'int', $a_p_Address, 'ptr', DllStructGetPtr($l_d_Buffer), 'int', DllStructGetSize($l_d_Buffer), 'int', '')
EndFunc

Func Memory_Read($a_p_Address, $a_s_Type = 'dword')
    Local $l_d_Buffer = DllStructCreate($a_s_Type)
    DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $a_p_Address, 'ptr', DllStructGetPtr($l_d_Buffer), 'int', DllStructGetSize($l_d_Buffer), 'int', '')
    Return DllStructGetData($l_d_Buffer, 1)
EndFunc

Func Memory_ReadPtr($a_p_Address, $a_ai_Offset, $a_s_Type = 'dword')
    Local $l_i_PointerCount = UBound($a_ai_Offset) - 2
    Local $l_d_Buffer = DllStructCreate('dword')
    Local $l_i_Index

    For $l_i_Index = 0 To $l_i_PointerCount
        $a_p_Address += $a_ai_Offset[$l_i_Index]
        DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $a_p_Address, 'ptr', DllStructGetPtr($l_d_Buffer), 'int', DllStructGetSize($l_d_Buffer), 'int', '')
        $a_p_Address = DllStructGetData($l_d_Buffer, 1)
        If $a_p_Address == 0 Then
            Local $l_av_Data[2] = [0, 0]
            Return $l_av_Data
        EndIf
    Next

    $a_p_Address += $a_ai_Offset[$l_i_PointerCount + 1]
    $l_d_Buffer = DllStructCreate($a_s_Type)
    DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $a_p_Address, 'ptr', DllStructGetPtr($l_d_Buffer), 'int', DllStructGetSize($l_d_Buffer), 'int', '')

    Local $l_av_Data[2] = [Ptr($a_p_Address), DllStructGetData($l_d_Buffer, 1)]
    Return $l_av_Data
EndFunc

Func Memory_ReadToStruct($a_p_Address, ByRef $a_d_Structure)
    Return DllCall($g_h_Kernel32, "int", "ReadProcessMemory", "int", $g_h_GWProcess, "int", $a_p_Address, "ptr", DllStructGetPtr($a_d_Structure), "int", DllStructGetSize($a_d_Structure), "int", "")[0]
EndFunc

Func Memory_ReadArray($a_p_Address, $a_i_SizeOffset = 0x0)
    Local $l_i_ArraySize = Memory_Read($a_p_Address + $a_i_SizeOffset, "dword")
    Local $l_p_ArrayBasePtr = Memory_Read($a_p_Address, "ptr")
    Local $l_av_Array[$l_i_ArraySize + 1]
    Local $l_d_Buffer = DllStructCreate("ptr[" & $l_i_ArraySize & "]")
    Local $l_v_Value

    DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", "handle", $g_h_GWProcess, _
            "ptr", $l_p_ArrayBasePtr, "struct*", $l_d_Buffer, _
            "ulong_ptr", 4 * $l_i_ArraySize, "ulong_ptr*", 0)

    $l_av_Array[0] = 0
    For $l_i_Index = 1 To $l_i_ArraySize
        $l_v_Value = DllStructGetData($l_d_Buffer, 1, $l_i_Index)
        If $l_v_Value = 0 Then ContinueLoop

        $l_av_Array[0] += 1
        $l_av_Array[$l_av_Array[0]] = $l_v_Value
    Next

    If $l_av_Array[0] < $l_i_ArraySize Then
        ReDim $l_av_Array[$l_av_Array[0] + 1]
    EndIf

    Return $l_av_Array
EndFunc

Func Memory_ReadArrayPtr($a_p_Address, $a_ai_Offset, $a_i_SizeOffset)
    Local $l_ap_Address = Memory_ReadPtr($a_p_Address, $a_ai_Offset, 'ptr')
    Return Memory_ReadArray($l_ap_Address[0], $a_i_SizeOffset)
EndFunc

Func Memory_Clear()
    DllCall($g_h_Kernel32, 'int', 'SetProcessWorkingSetSize', 'int', $g_h_GWProcess, 'int', -1, 'int', -1)
EndFunc

Func Memory_SetMax($a_i_Memory = 157286400)
	DllCall($g_h_Kernel32, 'int', 'SetProcessWorkingSetSizeEx', 'int', $g_h_GWProcess, 'int', 1, 'int', $a_i_Memory, 'int', 6)
EndFunc

Func Memory_GetLabelInfo($a_s_Lab)
    Local Const $l_v_Val = Memory_GetValue($a_s_Lab)
    Return $l_v_Val
EndFunc

Func Memory_GetScannedAddress($a_s_Label, $a_i_Offset)
    Return Memory_Read(Memory_GetLabelInfo($a_s_Label) + 8) - Memory_Read(Memory_GetLabelInfo($a_s_Label) + 4) + $a_i_Offset
EndFunc

Func Memory_WriteDetour($a_s_From, $a_s_To)
    Memory_WriteBinary('E9' & Utils_SwapEndian(Hex(Memory_GetLabelInfo($a_s_To) - Memory_GetLabelInfo($a_s_From) - 5)), Memory_GetLabelInfo($a_s_From))
EndFunc

Func Memory_GetValue($a_s_Key)
    For $l_i_Index = 1 To $g_amx2_Labels[0][0]
        If $g_amx2_Labels[$l_i_Index][0] = $a_s_Key Then
            Return $g_amx2_Labels[$l_i_Index][1]
        EndIf
    Next
    Return -1
EndFunc

Func Memory_SetValue($a_s_Key, $a_v_Value)
    $g_amx2_Labels[0][0] += 1
    ReDim $g_amx2_Labels[$g_amx2_Labels[0][0] + 1][2]
    $g_amx2_Labels[$g_amx2_Labels[0][0]][0] = $a_s_Key
    $g_amx2_Labels[$g_amx2_Labels[0][0]][1] = $a_v_Value
    Return True
EndFunc