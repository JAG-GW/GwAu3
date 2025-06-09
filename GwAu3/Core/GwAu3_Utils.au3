#include-once
#include "GwAu3_Constants.au3"

Global Const $GC_AS_BASE64_BINARY_GW[64] = [ _
        "000000", "100000", "010000", "110000", "001000", "101000", "011000", "111000", _ ; A-H
        "000100", "100100", "010100", "110100", "001100", "101100", "011100", "111100", _ ; I-P
        "000010", "100010", "010010", "110010", "001010", "101010", "011010", "111010", _ ; Q-X
        "000110", "100110", "010110", "110110", "001110", "101110", "011110", "111110", _ ; Y-f
        "000001", "100001", "010001", "110001", "001001", "101001", "011001", "111001", _ ; g-n
        "000101", "100101", "010101", "110101", "001101", "101101", "011101", "111101", _ ; o-v
        "000011", "100011", "010011", "110011", "001011", "101011", "011011", "111011", _ ; w-3
        "000111", "100111", "010111", "110111", "001111", "101111", "011111", "111111"]   ; 4-/

Func FloatToInt($a_f_Float)
;~     Local $l_d_Float = DllStructCreate("float")
;~     Local $l_d_Int = DllStructCreate("int", DllStructGetPtr($l_d_Float))
;~     DllStructSetData($l_d_Float, 1, $a_f_Float)
;~     Return DllStructGetData($l_d_Int, 1)
	Return Int($a_f_Float)
EndFunc

Func IntToFloat($a_i_Int)
;~     Local $l_d_Int = DllStructCreate("int")
;~     Local $l_d_Float = DllStructCreate("float", DllStructGetPtr($l_d_Int))
;~     DllStructSetData($l_d_Int, 1, $a_i_Int)
;~     Return DllStructGetData($l_d_Float, 1)
	Return Number($a_i_Int, 3)
EndFunc

Func Bin64ToDec($a_s_Binary)
;~     Local $l_i_Return = 0
;~     Local $l_i_Length = StringLen($a_s_Binary)
;~
;~     For $l_i_Pos = 1 To $l_i_Length
;~         If StringMid($a_s_Binary, $l_i_Length - $l_i_Pos + 1, 1) == "1" Then
;~             $l_i_Return += 2 ^ ($l_i_Pos - 1)
;~         EndIf
;~     Next
;~
;~     Return $l_i_Return
	Return Dec(StringReplace($a_s_Binary, "0b", ""), 2)
EndFunc

Func Base64ToBin64_GW($a_s_Character)
    Local $l_i_Index = StringInStr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", $a_s_Character, 1) - 1

    If $l_i_Index < 0 Then Return SetError(1, 0, "")

    Return $GC_AS_BASE64_BINARY_GW[$l_i_Index]
EndFunc

Func GetValue($a_s_Key)
    For $l_i_Index = 1 To $g_amx2_Labels[0][0]
        If $g_amx2_Labels[$l_i_Index][0] = $a_s_Key Then
            Return $g_amx2_Labels[$l_i_Index][1]
        EndIf
    Next
    Return -1
EndFunc

Func SetValue($a_s_Key, $a_v_Value)
    $g_amx2_Labels[0][0] += 1
    ReDim $g_amx2_Labels[$g_amx2_Labels[0][0] + 1][2]
    $g_amx2_Labels[$g_amx2_Labels[0][0]][0] = $a_s_Key
    $g_amx2_Labels[$g_amx2_Labels[0][0]][1] = $a_v_Value
    Return True
EndFunc
