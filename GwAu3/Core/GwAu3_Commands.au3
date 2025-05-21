#include-once

; #FUNCTION# ;===============================================================================
; Name...........: Enqueue
; Description ...: Adds a command to the Guild Wars command queue
; Syntax.........: Enqueue($aPtr, $aSize)
; Parameters ....: $aPtr   - Pointer to the command structure
;                  $aSize  - Size of the command structure in bytes
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Writes the command to the next available slot in the command queue
;                  - Increments the queue counter or resets it when reaching the end
;                  - Uses direct memory writing to interact with the Guild Wars client
;                  - This function is internal and should not be called directly by users
; Related .......: PerformAction, SendPacket
;============================================================================================
Func Enqueue($aPtr, $aSize)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', 256 * $mQueueCounter + $mQueueBase, 'ptr', $aPtr, 'int', $aSize, 'int', '')
	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf
EndFunc   ;==>Enqueue

; #FUNCTION# ;===============================================================================
; Name...........: PerformAction
; Description ...: Performs a specified game action
; Syntax.........: PerformAction($aAction, $aFlag)
; Parameters ....: $aAction - The action ID to perform
;                  $aFlag   - Additional flag for the action
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Sets the action ID and flag in the action structure
;                  - Enqueues the action for processing by the Guild Wars client
;                  - Actions include movement, targeting, skills, etc.
;                  - This function is internal and should be used via wrapper functions
; Related .......: Enqueue
;============================================================================================
Func PerformAction($aAction, $aFlag)
	DllStructSetData($mAction, 2, $aAction)
	DllStructSetData($mAction, 3, $aFlag)
	Enqueue($mActionPtr, 12)
EndFunc   ;==>PerformAction

; #FUNCTION# ;===============================================================================
; Name...........: SendPacket
; Description ...: Sends a network packet to the Guild Wars server
; Syntax.........: SendPacket($aSize, $aHeader, $aParam1 = 0, $aParam2 = 0, $aParam3 = 0, $aParam4 = 0, $aParam5 = 0, $aParam6 = 0, $aParam7 = 0, $aParam8 = 0, $aParam9 = 0, $aParam10 = 0)
; Parameters ....: $aSize    - Size of the packet
;                  $aHeader  - Packet header/type
;                  $aParam1  - [optional] Parameter 1 (default: 0)
;                  $aParam2  - [optional] Parameter 2 (default: 0)
;                  $aParam3  - [optional] Parameter 3 (default: 0)
;                  $aParam4  - [optional] Parameter 4 (default: 0)
;                  $aParam5  - [optional] Parameter 5 (default: 0)
;                  $aParam6  - [optional] Parameter 6 (default: 0)
;                  $aParam7  - [optional] Parameter 7 (default: 0)
;                  $aParam8  - [optional] Parameter 8 (default: 0)
;                  $aParam9  - [optional] Parameter 9 (default: 0)
;                  $aParam10 - [optional] Parameter 10 (default: 0)
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: - Fills the packet structure with the specified data
;                  - Enqueues the packet for sending to the server
;                  - Used for various game actions that require server communication
;                  - All parameters after header are optional and default to 0
;                  - This function is internal and should be used via wrapper functions
; Related .......: Enqueue
;============================================================================================
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
EndFunc   ;==>SendPacket