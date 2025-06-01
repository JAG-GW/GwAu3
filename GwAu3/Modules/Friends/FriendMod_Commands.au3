#include-once
#include "FriendMod_Initialize.au3"

Func SetPlayerStatus($iStatus)
	If (($iStatus >= 0 And $iStatus <= 3) And (GetPlayerStatus() <> $iStatus)) Then

		DllStructSetData($g_mChangeStatus, 1, GetValue('CommandChangeStatus'))
		DllStructSetData($g_mChangeStatus, 2, $iStatus)

		Enqueue($g_mChangeStatusPtr, 8)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SetPlayerStatus