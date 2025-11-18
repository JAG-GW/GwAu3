#include-once

;~ Description: Sleep a random amount of time.
Func Other_RndSleep($a_i_Amount, $a_f_Random = 0.05)
    Local $l_f_Random = $a_i_Amount * $a_f_Random
    Sleep(Random($a_i_Amount - $l_f_Random, $a_i_Amount + $l_f_Random))
EndFunc   ;==>RndSleep

;~ Description: Sleep a period of time, plus or minus a tolerance
Func Other_TolSleep($a_i_Amount = 150, $a_i_Tolerance = 50)
    Sleep(Random($a_i_Amount - $a_i_Tolerance, $a_i_Amount + $a_i_Tolerance))
EndFunc   ;==>TolSleep

;~ Description: Sleep a period of time, plus ping.
Func Other_PingSleep($a_i_MsExtra = 0)
    Sleep(Other_GetPing() + $a_i_MsExtra)
EndFunc   ;==>PingSleep