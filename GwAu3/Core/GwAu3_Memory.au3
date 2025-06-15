#include-once
#include "GwAu3_Constants.au3"

Func GwAu3_Memory_Open($aPID)
	$mKernelHandle = DllOpen('kernel32.dll')
	Local $lOpenProcess = DllCall($mKernelHandle, 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', 1, 'int', $aPID)
	$mGWProcHandle = $lOpenProcess[0]
EndFunc

Func GwAu3_Memory_Close()
	DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $mGWProcHandle)
	DllClose($mKernelHandle)
EndFunc

Func GwAu3_Memory_WriteBinary($aBinaryString, $aAddress)
	Local $lData = DllStructCreate('byte[' & 0.5 * StringLen($aBinaryString) & ']'), $i
	For $i = 1 To DllStructGetSize($lData)
		DllStructSetData($lData, 1, Dec(StringMid($aBinaryString, 2 * $i - 1, 2)), $i)
	Next
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $aAddress, 'ptr', DllStructGetPtr($lData), 'int', DllStructGetSize($lData), 'int', 0)
EndFunc

Func GwAu3_Memory_Write($aAddress, $aData, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllStructSetData($lBuffer, 1, $aData)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
EndFunc

Func GwAu3_Memory_Read($aAddress, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Return DllStructGetData($lBuffer, 1)
EndFunc

Func GwAu3_Memory_ReadPtr($aAddress, $aOffset, $aType = 'dword')
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

Func GwAu3_Memory_ReadToStruct($aAddress, ByRef $aStructure)
	Return DllCall($mKernelHandle, "int", "ReadProcessMemory", "int", $mGWProcHandle, "int", $aAddress, "ptr", DllStructGetPtr($aStructure), "int", DllStructGetSize($aStructure), "int", "")[0]
EndFunc

Func GwAu3_Memory_ReadArray($aAddress, $aSizeOffset = 0x0)
    Local $lArraySize = GwAu3_Memory_Read($aAddress + $aSizeOffset, "dword")
    Local $lArrayBasePtr = GwAu3_Memory_Read($aAddress, "ptr")
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

Func GwAu3_Memory_ReadArrayPtr($aAddress, $aOffset, $aSizeOffset)
    Local $lAddress = GwAu3_Memory_ReadPtr($aAddress, $aOffset, 'ptr')
    Return GwAu3_Memory_ReadArray($lAddress[0], $aSizeOffset)
EndFunc

Func GwAu3_Memory_Clear()
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSize', 'int', $mGWProcHandle, 'int', -1, 'int', -1)
EndFunc

Func GwAu3_Memory_SetMax($aMemory = 157286400)
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSizeEx', 'int', $mGWProcHandle, 'int', 1, 'int', $aMemory, 'int', 6)
EndFunc

Func GwAu3_Memory_GetLabelInfo($aLab)
	Local Const $lVal = GwAu3_Memory_GetValue($aLab)
	Return $lVal
EndFunc

Func GwAu3_Memory_GetScannedAddress($aLabel, $aOffset)
	Return GwAu3_Memory_Read(GwAu3_Memory_GetLabelInfo($aLabel) + 8) - GwAu3_Memory_Read(GwAu3_Memory_GetLabelInfo($aLabel) + 4) + $aOffset
EndFunc

Func GwAu3_Memory_WriteDetour($aFrom, $aTo)
	GwAu3_Memory_WriteBinary('E9' & GwAu3_Utils_SwapEndian(Hex(GwAu3_Memory_GetLabelInfo($aTo) - GwAu3_Memory_GetLabelInfo($aFrom) - 5)), GwAu3_Memory_GetLabelInfo($aFrom))
EndFunc

Func GwAu3_Memory_GetValue($a_s_Key)
    For $l_i_Index = 1 To $g_amx2_Labels[0][0]
        If $g_amx2_Labels[$l_i_Index][0] = $a_s_Key Then
            Return $g_amx2_Labels[$l_i_Index][1]
        EndIf
    Next
    Return -1
EndFunc

Func GwAu3_Memory_SetValue($a_s_Key, $a_v_Value)
    $g_amx2_Labels[0][0] += 1
    ReDim $g_amx2_Labels[$g_amx2_Labels[0][0] + 1][2]
    $g_amx2_Labels[$g_amx2_Labels[0][0]][0] = $a_s_Key
    $g_amx2_Labels[$g_amx2_Labels[0][0]][1] = $a_v_Value
    Return True
EndFunc