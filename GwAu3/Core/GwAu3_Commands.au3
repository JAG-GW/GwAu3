#include-once
#include "GwAu3_Constants.au3"

Func Enqueue($aPtr, $aSize)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', 256 * $mQueueCounter + $mQueueBase, 'ptr', $aPtr, 'int', $aSize, 'int', '')
	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf
EndFunc

Func PerformAction($aAction, $aFlag)
	DllStructSetData($mAction, 2, $aAction)
	DllStructSetData($mAction, 3, $aFlag)
	Enqueue($mActionPtr, 12)
EndFunc

Func SendPacket($aSize, $aHeader, $aParam1 = 0, $aParam2 = 0, $aParam3 = 0, $aParam4 = 0, $aParam5 = 0, $aParam6 = 0, $aParam7 = 0, $aParam8 = 0, $aParam9 = 0, $aParam10 = 0)
	DllStructSetData($mPacket, 2, $aSize)
	DllStructSetData($mPacket, 3, $aHeader)
	DllStructSetData($mPacket, 4, $aParam1)
	DllStructSetData($mPacket, 5, $aParam2)
	DllStructSetData($mPacket, 6, $aParam3)
	DllStructSetData($mPacket, 7, $aParam4)
	DllStructSetData($mPacket, 8, $aParam5)
	DllStructSetData($mPacket, 9, $aParam6)
	DllStructSetData($mPacket, 10, $aParam7)
	DllStructSetData($mPacket, 11, $aParam8)
	DllStructSetData($mPacket, 12, $aParam9)
	DllStructSetData($mPacket, 13, $aParam10)
	Enqueue($mPacketPtr, 52)
EndFunc