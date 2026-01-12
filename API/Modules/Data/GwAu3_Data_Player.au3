#include-once

;~ Description: Returns your characters name.
Func Player_GetCharname()
    Return Memory_Read($g_p_CharName, 'wchar[30]')
EndFunc   ;==>GetCharname

Func Player_CampaignCharacter()
    Return Memory_Read(Scanner_GWBaseAddress() + 0x7BD05C)
EndFunc