#include-once

;~ Description: Returns your characters name.
Func GwAu3_Player_GetCharname()
    Return GwAu3_Memory_Read($g_p_CharName, 'wchar[30]')
EndFunc   ;==>GetCharname
