#include-once
#include "GwAu3_Constants_Core.au3"

; #FUNCTION# ;===============================================================================
; Name...........: MemoryOpen
; Description ...: Opens a process for memory access operations
; Syntax.........: MemoryOpen($aPID)
; Parameters ....: $aPID     - Process ID of the target application
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Must be called before any other memory functions
;                  - Requires administrator privileges (#RequireAdmin)
;                  - Opens the process with full access rights (0x1F0FFF)
; Related .......: MemoryClose
;============================================================================================
Func MemoryOpen($aPID)
	$mKernelHandle = DllOpen('kernel32.dll')
	Local $lOpenProcess = DllCall($mKernelHandle, 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', 1, 'int', $aPID)
	$mGWProcHandle = $lOpenProcess[0]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: MemoryClose
; Description ...: Closes the handle to the previously opened process
; Syntax.........: MemoryClose()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Should be called when memory operations are complete
;                  - Frees resources and closes DLL handles
; Related .......: MemoryOpen
;============================================================================================
Func MemoryClose()
	DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $mGWProcHandle)
	DllClose($mKernelHandle)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: WriteBinary
; Description ...: Writes binary data to a specified memory address
; Syntax.........: WriteBinary($aBinaryString, $aAddress)
; Parameters ....: $aBinaryString - Hex string representing binary data to write
;                  $aAddress      - Target memory address where data will be written
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - The binary string should be in hex format
;                  - Converts each pair of hex characters to a byte
;                  - Writes the entire binary data in a single operation
; Related .......: MemoryWrite
;============================================================================================
Func WriteBinary($aBinaryString, $aAddress)
	Local $lData = DllStructCreate('byte[' & 0.5 * StringLen($aBinaryString) & ']'), $i
	For $i = 1 To DllStructGetSize($lData)
		DllStructSetData($lData, 1, Dec(StringMid($aBinaryString, 2 * $i - 1, 2)), $i)
	Next
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $aAddress, 'ptr', DllStructGetPtr($lData), 'int', DllStructGetSize($lData), 'int', 0)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: MemoryWrite
; Description ...: Writes a value to a specified memory address
; Syntax.........: MemoryWrite($aAddress, $aData, $aType = 'dword')
; Parameters ....: $aAddress - Target memory address
;                  $aData    - Data to write
;                  $aType    - [optional] DLL structure type (default: 'dword')
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Common types: 'byte', 'word', 'dword', 'int', 'uint', 'float'
;                  - Type must match the expected memory structure
; Related .......: MemoryRead, WriteBinary
;============================================================================================
Func MemoryWrite($aAddress, $aData, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllStructSetData($lBuffer, 1, $aData)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: MemoryRead
; Description ...: Reads a value from a specified memory address
; Syntax.........: MemoryRead($aAddress, $aType = 'dword')
; Parameters ....: $aAddress - Memory address to read from
;                  $aType    - [optional] DLL structure type (default: 'dword')
; Return values .: The value at the specified memory address
; Author ........:
; Modified.......:
; Remarks .......: - Common types: 'byte', 'word', 'dword', 'int', 'uint', 'float'
;                  - Type must match the actual memory structure
; Related .......: MemoryWrite
;============================================================================================
Func MemoryRead($aAddress, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Return DllStructGetData($lBuffer, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: MemoryReadPtr
; Description ...: Reads a value by following a chain of pointers
; Syntax.........: MemoryReadPtr($aAddress, $aOffset, $aType = 'dword')
; Parameters ....: $aAddress - Base memory address
;                  $aOffset  - Array of offsets to follow
;                  $aType    - [optional] DLL structure type (default: 'dword')
; Return values .: Array[2]  - [0] = Final memory address, [1] = Value at that address
; Author ........:
; Modified.......:
; Remarks .......: - Used for multi-level pointer dereferencing
;                  - Returns [0,0] if any pointer in the chain is null
;                  - Last element in $aOffset is added to the final pointer
; Related .......: MemoryRead
;============================================================================================
Func MemoryReadPtr($aAddress, $aOffset, $aType = 'dword')
	Local $lPointerCount = UBound($aOffset) - 2
	Local $lBuffer = DllStructCreate('dword')
	For $i = 0 To $lPointerCount
		$aAddress += $aOffset[$i]
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
		$aAddress = DllStructGetData($lBuffer, 1)
		If $aAddress == 0 Then
			Local $lData[2] = [0, 0]
			Return $lData
		EndIf
	Next
	$aAddress += $aOffset[$lPointerCount + 1]
	$lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Local $lData[2] = [Ptr($aAddress), DllStructGetData($lBuffer, 1)]
	Return $lData
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: MemoryReadArray
; Description ...: Reads an array of values from memory
; Syntax.........: MemoryReadArray($aAddress, $aSizeOffset = 0x0)
; Parameters ....: $aAddress    - Memory address pointing to the array
;                  $aSizeOffset - [optional] Offset where array size is stored (default: 0x0)
; Return values .: Array        - [0] = Number of elements, [1..n] = Array values
; Author ........:
; Modified.......:
; Remarks .......: - Reads the array size from ($aAddress + $aSizeOffset)
;                  - Reads the array base pointer from $aAddress
;                  - Skips null (0) values in the array
;                  - Resizes the return array to remove unused elements
; Related .......: MemoryReadArrayPtr
;============================================================================================
Func MemoryReadArray($aAddress, $aSizeOffset = 0x0)
    Local $lArraySize = MemoryRead($aAddress + $aSizeOffset, "dword")
    Local $lArrayBasePtr = MemoryRead($aAddress, "ptr")
    Local $lArray[$lArraySize + 1]
    Local $lBuffer = DllStructCreate("ptr[" & $lArraySize & "]")
	Local $lValue

    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, _
            "ptr", $lArrayBasePtr, "struct*", $lBuffer, _
            "ulong_ptr", 4 * $lArraySize, "ulong_ptr*", 0)

	$lArray[0] = 0
    For $i = 1 To $lArraySize
        $lValue = DllStructGetData($lBuffer, 1, $i)
        If $lValue = 0 Then ContinueLoop

        $lArray[0] += 1
        $lArray[$lArray[0]] = $lValue
    Next

    If $lArray[0] < $lArraySize Then
        ReDim $lArray[$lArray[0] + 1]
    EndIf

    Return $lArray
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: MemoryReadArrayPtr
; Description ...: Reads an array by following a chain of pointers
; Syntax.........: MemoryReadArrayPtr($aAddress, $aOffset, $aSizeOffset)
; Parameters ....: $aAddress    - Base memory address
;                  $aOffset     - Array of offsets to follow
;                  $aSizeOffset - Offset where array size is stored
; Return values .: Array        - [0] = Number of elements, [1..n] = Array values
; Author ........:
; Modified.......:
; Remarks .......: - Combines MemoryReadPtr and MemoryReadArray functionality
;                  - Follows pointer chain then reads the array at the final address
; Related .......: MemoryReadPtr, MemoryReadArray
;============================================================================================
Func MemoryReadArrayPtr($aAddress, $aOffset, $aSizeOffset)
    Local $lAddress = MemoryReadPtr($aAddress, $aOffset, 'ptr')
    Return MemoryReadArray($lAddress[0], $aSizeOffset)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: SwapEndian
; Description ...: Reverses byte order in a 4-byte (DWORD) hex string
; Syntax.........: SwapEndian($aHex)
; Parameters ....: $aHex - 8-character hex string (representing 4 bytes)
; Return values .: Byte-swapped hex string
; Author ........:
; Modified.......:
; Remarks .......: - Converts between big-endian and little-endian formats
;                  - Only works with exactly 4 bytes (8 hex characters)
;                  - Format: input "AABBCCDD" returns "DDCCBBAA"
; Related .......:
;============================================================================================
Func SwapEndian($aHex)
	Return StringMid($aHex, 7, 2) & StringMid($aHex, 5, 2) & StringMid($aHex, 3, 2) & StringMid($aHex, 1, 2)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: ClearMemory
; Description ...: Empties Guild Wars client memory working set
; Syntax.........: ClearMemory()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Forces the operating system to trim the process working set
;                  - Can reduce memory usage but might cause temporary performance decrease
;                  - Uses SetProcessWorkingSetSize with -1 parameters to minimize memory
; Related .......: SetMaxMemory
;============================================================================================
Func ClearMemory()
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSize', 'int', $mGWProcHandle, 'int', -1, 'int', -1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: SetMaxMemory
; Description ...: Changes the maximum memory Guild Wars can use
; Syntax.........: SetMaxMemory($aMemory = 157286400)
; Parameters ....: $aMemory - [optional] Maximum memory in bytes (default: 150MB)
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Sets minimum (1) and maximum ($aMemory) working set size
;                  - Uses flag 6 to enable quota management and hard limits
;                  - Default maximum is 150MB (157,286,400 bytes)
; Related .......: ClearMemory
;============================================================================================
Func SetMaxMemory($aMemory = 157286400)
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSizeEx', 'int', $mGWProcHandle, 'int', 1, 'int', $aMemory, 'int', 6)
EndFunc