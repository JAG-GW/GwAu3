#include-once

;~ Description: Returns your characters name.
Func Player_GetCharname()
    Return Memory_Read($g_p_CharName, 'wchar[30]')
EndFunc   ;==>GetCharname

Func Player_CampaignCharacter()
    If Map_IsMapUnlocked($GC_I_MAP_ID_ISLAND_OF_SHEHKAH) Then Return $GC_I_MAP_CAMPAIGN_NIGHTFALL
    If Map_IsMapUnlocked($GC_I_MAP_ID_ASCALON_CITY_OUTPOST) Then Return $GC_I_MAP_CAMPAIGN_PROPHECIES

    Return $GC_I_MAP_CAMPAIGN_FACTIONS
EndFunc