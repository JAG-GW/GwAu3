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

Func GwAu3_Utils_FloatToInt($a_f_Float)
;~     Local $l_d_Float = DllStructCreate("float")
;~     Local $l_d_Int = DllStructCreate("int", DllStructGetPtr($l_d_Float))
;~     DllStructSetData($l_d_Float, 1, $a_f_Float)
;~     Return DllStructGetData($l_d_Int, 1)
	Return Int($a_f_Float)
EndFunc

Func GwAu3_Utils_IntToFloat($a_i_Int)
;~     Local $l_d_Int = DllStructCreate("int")
;~     Local $l_d_Float = DllStructCreate("float", DllStructGetPtr($l_d_Int))
;~     DllStructSetData($l_d_Int, 1, $a_i_Int)
;~     Return DllStructGetData($l_d_Float, 1)
	Return Number($a_i_Int, 3)
EndFunc

Func GwAu3_Utils_Bin64ToDec($a_s_Binary)
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

Func GwAu3_Utils_Base64ToBin64($a_s_Character)
    Local $l_i_Index = StringInStr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", $a_s_Character, 1) - 1

    If $l_i_Index < 0 Then Return SetError(1, 0, "")

    Return $GC_AS_BASE64_BINARY_GW[$l_i_Index]
EndFunc

Func GwAu3_Utils_ArrayAdd2D(ByRef $a_amx2_Array, $a_v_Val1, $a_v_Val2)
    Local $l_i_Idx = UBound($a_amx2_Array)
    ReDim $a_amx2_Array[$l_i_Idx + 1][2]
    $a_amx2_Array[$l_i_Idx][0] = $a_v_Val1
    $a_amx2_Array[$l_i_Idx][1] = $a_v_Val2
EndFunc

Func GwAu3_Utils_UnsignedCompare($a_i_A, $a_i_B)
    $a_i_A = BitAND($a_i_A, 0xFFFFFFFF)
    $a_i_B = BitAND($a_i_B, 0xFFFFFFFF)
    If $a_i_A = $a_i_B Then Return 0
    Return ($a_i_A > $a_i_B And $a_i_A - $a_i_B < 0x80000000) Or ($a_i_B > $a_i_A And $a_i_B - $a_i_A > 0x80000000) ? 1 : -1
EndFunc

Func GwAu3_Utils_StringToByteArray($a_s_HexString)
    Local $l_i_Length = StringLen($a_s_HexString) / 2
    Local $l_ax_Bytes[$l_i_Length]
    For $l_i_Index = 0 To $l_i_Length - 1
        Local $l_s_HexByte = StringMid($a_s_HexString, ($l_i_Index * 2) + 1, 2)
        $l_ax_Bytes[$l_i_Index] = Dec($l_s_HexByte)
    Next
    Return $l_ax_Bytes
EndFunc

Func GwAu3_Utils_StringToBytes($a_s_Str)
    Local $l_i_Len = StringLen($a_s_Str) + 1
    Local $l_d_Struct = DllStructCreate("byte[" & $l_i_Len & "]")
    For $l_i_Index = 1 To StringLen($a_s_Str)
        DllStructSetData($l_d_Struct, 1, Asc(StringMid($a_s_Str, $l_i_Index, 1)), $l_i_Index)
    Next
    DllStructSetData($l_d_Struct, 1, 0, $l_i_Len)
    Local $l_ax_Result = DllStructGetData($l_d_Struct, 1)
    Return $l_ax_Result
EndFunc

Func GwAu3_Utils_SwapEndian($a_s_Hex)
    Return StringMid($a_s_Hex, 7, 2) & StringMid($a_s_Hex, 5, 2) & StringMid($a_s_Hex, 3, 2) & StringMid($a_s_Hex, 1, 2)
EndFunc
