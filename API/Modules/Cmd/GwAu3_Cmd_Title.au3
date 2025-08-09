#include-once

Func Title_SetDisplayedTitle($a_i_Title = 0)
    If $a_i_Title <> 0 Then
        Return Core_SendPacket(0x8, $GC_I_HEADER_TITLE_DISPLAY, $a_i_Title)
    Else
        Return Core_SendPacket(0x4, $GC_I_HEADER_TITLE_HIDE)
    EndIf
EndFunc   ;==>SetDisplayedTitle
