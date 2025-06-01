#include-once
#include "FriendMod_Initialize.au3"

Func GetPlayerStatus()
	Return MemoryRead($g_mCurrentStatus)
EndFunc   ;==>GetPlayerStatus