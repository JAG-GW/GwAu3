#include-once
#include "GwAu3_Constants_Core.au3"

; #FUNCTION# ;===============================================================================
; Name...........: FloatToInt
; Description ...: Converts a floating-point value to its integer representation
; Syntax.........: FloatToInt($nFloat)
; Parameters ....: $nFloat  - The floating-point value to convert
; Return values .: The integer representation of the float (bit pattern, not rounded value)
; Author ........:
; Modified.......:
; Remarks .......: - Uses DllStructCreate to reinterpret the float's memory representation as an integer
;                  - This function doesn't round the number; it converts the actual IEEE-754 representation
;                  - Useful for working with memory addresses where float values are stored
; Related .......: IntToFloat
;============================================================================================
Func FloatToInt($nFloat)
	Local $tFloat = DllStructCreate("float")
	Local $tInt = DllStructCreate("int", DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $nFloat)
	Return DllStructGetData($tInt, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: IntToFloat
; Description ...: Converts an integer value to its floating-point representation
; Syntax.........: IntToFloat($fInt)
; Parameters ....: $fInt    - The integer value to convert
; Return values .: The floating-point representation of the integer (bit pattern)
; Author ........:
; Modified.......:
; Remarks .......: - Uses DllStructCreate to reinterpret the integer's memory representation as a float
;                  - This function doesn't perform normal integer-to-float conversion; it converts the bit pattern
;                  - Useful for working with memory addresses where integer values need to be treated as floats
; Related .......: FloatToInt
;============================================================================================
Func IntToFloat($fInt)
	Local $tFloat, $tInt
	$tInt = DllStructCreate("int")
	$tFloat = DllStructCreate("float", DllStructGetPtr($tInt))
	DllStructSetData($tInt, 1, $fInt)
	Return DllStructGetData($tFloat, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: Bin64ToDec
; Description ...: Converts a binary string to its decimal equivalent
; Syntax.........: Bin64ToDec($aBinary)
; Parameters ....: $aBinary - String representation of a binary number (e.g., "1001")
; Return values .: The decimal (base-10) equivalent of the binary value
; Author ........:
; Modified.......:
; Remarks .......: - Converts bit by bit, from least significant bit (rightmost) to most significant bit
;                  - Each '1' bit contributes 2^position to the total value
;                  - Works with binary strings of any length
;                  - Used primarily in Guild Wars memory manipulation for parsing binary data
; Related .......: Base64ToBin64
;============================================================================================
Func Bin64ToDec($aBinary)
	Local $lReturn = 0
	For $i = 1 To StringLen($aBinary)
		If StringMid($aBinary, $i, 1) == 1 Then $lReturn += 2 ^ ($i - 1)
	Next
	Return $lReturn
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: Base64ToBin64
; Description ...: Converts a Base64 character to its 6-bit binary representation
; Syntax.........: Base64ToBin64($aCharacter)
; Parameters ....: $aCharacter - A single character from the Base64 alphabet
; Return values .: The 6-bit binary string representation of the character
; Author ........:
; Modified.......:
; Remarks .......: - Each Base64 character represents 6 bits of data
;                  - The full Base64 alphabet is [A-Za-z0-9+/]
;                  - Used primarily for encoding/decoding data in Guild Wars memory operations
;                  - Returns a 6-character string of '0's and '1's
; Related .......: Bin64ToDec
;============================================================================================
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

; #FUNCTION# ;===============================================================================
; Name...........: GetValue
; Description ...: Retrieves a value from the global labels array by key
; Syntax.........: GetValue($aKey)
; Parameters ....: $aKey    - The identifier/key to search for in the labels array
; Return values .: The value associated with the key, or -1 if the key is not found
; Author ........:
; Modified.......:
; Remarks .......: - Used to retrieve stored memory addresses, offsets, and other values
;                  - Searches the global $mLabels array for the matching key
;                  - Essential for memory address management in the Guild Wars API
;                  - Returns -1 if the key doesn't exist
; Related .......: SetValue
;============================================================================================
Func GetValue($aKey)
	For $i = 1 To $mLabels[0][0]
		If $mLabels[$i][0] = $aKey Then Return $mLabels[$i][1]
	Next
	Return -1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: SetValue
; Description ...: Stores a key-value pair in the global labels array
; Syntax.........: SetValue($aKey, $aValue)
; Parameters ....: $aKey    - The identifier/key to store
;                  $aValue  - The value to associate with the key
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Used to store memory addresses, offsets, and other important values
;                  - Increases the size of the global $mLabels array with each new entry
;                  - Essential for memory address management in the Guild Wars API
;                  - No validation is performed to prevent duplicate keys
; Related .......: GetValue
;============================================================================================
Func SetValue($aKey, $aValue)
	$mLabels[0][0] += 1
	ReDim $mLabels[$mLabels[0][0] + 1][2]
	$mLabels[$mLabels[0][0]][0] = $aKey
	$mLabels[$mLabels[0][0]][1] = $aValue
EndFunc
