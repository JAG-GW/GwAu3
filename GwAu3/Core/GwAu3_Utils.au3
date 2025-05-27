#include-once
#include "GwAu3_Constants_Core.au3"

Func FloatToInt($nFloat)
	Local $tFloat = DllStructCreate("float")
	Local $tInt = DllStructCreate("int", DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $nFloat)
	Return DllStructGetData($tInt, 1)
EndFunc

Func IntToFloat($fInt)
	Local $tFloat, $tInt
	$tInt = DllStructCreate("int")
	$tFloat = DllStructCreate("float", DllStructGetPtr($tInt))
	DllStructSetData($tInt, 1, $fInt)
	Return DllStructGetData($tFloat, 1)
EndFunc

Func Bin64ToDec($aBinary)
	Local $lReturn = 0
	For $i = 1 To StringLen($aBinary)
		If StringMid($aBinary, $i, 1) == 1 Then $lReturn += 2 ^ ($i - 1)
	Next
	Return $lReturn
EndFunc

Func Base64ToBin64($aCharacter)
	Select
		Case $aCharacter == 'A'
			Return '000000'
		Case $aCharacter == 'B'
			Return '100000'
		Case $aCharacter == 'C'
			Return '010000'
		Case $aCharacter == 'D'
			Return '110000'
		Case $aCharacter == 'E'
			Return '001000'
		Case $aCharacter == 'F'
			Return '101000'
		Case $aCharacter == 'G'
			Return '011000'
		Case $aCharacter == 'H'
			Return '111000'
		Case $aCharacter == 'I'
			Return '000100'
		Case $aCharacter == 'J'
			Return '100100'
		Case $aCharacter == 'K'
			Return '010100'
		Case $aCharacter == 'L'
			Return '110100'
		Case $aCharacter == 'M'
			Return '001100'
		Case $aCharacter == 'N'
			Return '101100'
		Case $aCharacter == 'O'
			Return '011100'
		Case $aCharacter == 'P'
			Return '111100'
		Case $aCharacter == 'Q'
			Return '000010'
		Case $aCharacter == 'R'
			Return '100010'
		Case $aCharacter == 'S'
			Return '010010'
		Case $aCharacter == 'T'
			Return '110010'
		Case $aCharacter == 'U'
			Return '001010'
		Case $aCharacter == 'V'
			Return '101010'
		Case $aCharacter == 'W'
			Return '011010'
		Case $aCharacter == 'X'
			Return '111010'
		Case $aCharacter == 'Y'
			Return '000110'
		Case $aCharacter == 'Z'
			Return '100110'
		Case $aCharacter == 'a'
			Return '010110'
		Case $aCharacter == 'b'
			Return '110110'
		Case $aCharacter == 'c'
			Return '001110'
		Case $aCharacter == 'd'
			Return '101110'
		Case $aCharacter == 'e'
			Return '011110'
		Case $aCharacter == 'f'
			Return '111110'
		Case $aCharacter == 'g'
			Return '000001'
		Case $aCharacter == 'h'
			Return '100001'
		Case $aCharacter == 'i'
			Return '010001'
		Case $aCharacter == 'j'
			Return '110001'
		Case $aCharacter == 'k'
			Return '001001'
		Case $aCharacter == 'l'
			Return '101001'
		Case $aCharacter == 'm'
			Return '011001'
		Case $aCharacter == 'n'
			Return '111001'
		Case $aCharacter == 'o'
			Return '000101'
		Case $aCharacter == 'p'
			Return '100101'
		Case $aCharacter == 'q'
			Return '010101'
		Case $aCharacter == 'r'
			Return '110101'
		Case $aCharacter == 's'
			Return '001101'
		Case $aCharacter == 't'
			Return '101101'
		Case $aCharacter == 'u'
			Return '011101'
		Case $aCharacter == 'v'
			Return '111101'
		Case $aCharacter == 'w'
			Return '000011'
		Case $aCharacter == 'x'
			Return '100011'
		Case $aCharacter == 'y'
			Return '010011'
		Case $aCharacter == 'z'
			Return '110011'
		Case $aCharacter == '0'
			Return '001011'
		Case $aCharacter == '1'
			Return '101011'
		Case $aCharacter == '2'
			Return '011011'
		Case $aCharacter == '3'
			Return '111011'
		Case $aCharacter == '4'
			Return '000111'
		Case $aCharacter == '5'
			Return '100111'
		Case $aCharacter == '6'
			Return '010111'
		Case $aCharacter == '7'
			Return '110111'
		Case $aCharacter == '8'
			Return '001111'
		Case $aCharacter == '9'
			Return '101111'
		Case $aCharacter == '+'
			Return '011111'
		Case $aCharacter == '/'
			Return '111111'
	EndSelect
EndFunc

Func GetValue($aKey)
	For $i = 1 To $mLabels[0][0]
		If $mLabels[$i][0] = $aKey Then Return $mLabels[$i][1]
	Next
	Return -1
EndFunc

Func SetValue($aKey, $aValue)
	$mLabels[0][0] += 1
	ReDim $mLabels[$mLabels[0][0] + 1][2]
	$mLabels[$mLabels[0][0]][0] = $aKey
	$mLabels[$mLabels[0][0]][1] = $aValue
EndFunc
