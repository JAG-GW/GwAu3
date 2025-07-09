#include-once

;~ Description: Skip a cinematic.
Func Cinematic_SkipCinematic()
    Return Core_SendPacket(0x4, $GC_I_HEADER_CINEMATIC_SKIP)
EndFunc   ;==>SkipCinematic