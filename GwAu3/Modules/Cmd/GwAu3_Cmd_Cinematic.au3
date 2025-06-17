#include-once

;~ Description: Skip a cinematic.
Func GwAu3_Cinematic_SkipCinematic()
    Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_CINEMATIC_SKIP)
EndFunc   ;==>SkipCinematic