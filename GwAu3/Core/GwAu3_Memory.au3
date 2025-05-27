#include-once
#include "GwAu3_Constants_Core.au3"

Func MemoryOpen($aPID)
	$mKernelHandle = DllOpen('kernel32.dll')
	Local $lOpenProcess = DllCall($mKernelHandle, 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', 1, 'int', $aPID)
	$mGWProcHandle = $lOpenProcess[0]
EndFunc

Func MemoryClose()
	DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $mGWProcHandle)
	DllClose($mKernelHandle)
EndFunc

Func WriteBinary($aBinaryString, $aAddress)
	Local $lData = DllStructCreate('byte[' & 0.5 * StringLen($aBinaryString) & ']'), $i
	For $i = 1 To DllStructGetSize($lData)
		DllStructSetData($lData, 1, Dec(StringMid($aBinaryString, 2 * $i - 1, 2)), $i)
	Next
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $aAddress, 'ptr', DllStructGetPtr($lData), 'int', DllStructGetSize($lData), 'int', 0)
EndFunc

Func MemoryWrite($aAddress, $aData, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllStructSetData($lBuffer, 1, $aData)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
EndFunc

Func MemoryRead($aAddress, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Return DllStructGetData($lBuffer, 1)
EndFunc

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

Func MemoryReadToStruct($aAddress, ByRef $aStructure)
	Return DllCall($mKernelHandle, "int", "ReadProcessMemory", "int", $mGWProcHandle, "int", $aAddress, "ptr", DllStructGetPtr($aStructure), "int", DllStructGetSize($aStructure), "int", "")[0]
EndFunc

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

Func MemoryReadArrayPtr($aAddress, $aOffset, $aSizeOffset)
    Local $lAddress = MemoryReadPtr($aAddress, $aOffset, 'ptr')
    Return MemoryReadArray($lAddress[0], $aSizeOffset)
EndFunc

Func SwapEndian($aHex)
	Return StringMid($aHex, 7, 2) & StringMid($aHex, 5, 2) & StringMid($aHex, 3, 2) & StringMid($aHex, 1, 2)
EndFunc

Func ClearMemory()
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSize', 'int', $mGWProcHandle, 'int', -1, 'int', -1)
EndFunc

Func SetMaxMemory($aMemory = 157286400)
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSizeEx', 'int', $mGWProcHandle, 'int', 1, 'int', $aMemory, 'int', 6)
EndFunc