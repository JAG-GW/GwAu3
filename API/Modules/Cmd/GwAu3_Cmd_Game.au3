#include-once

;~ Description: Switches to/from Hard Mode.
Func Game_SwitchMode($a_i_Mode)
    Return Core_SendPacket(0x8, $GC_I_HEADER_PARTY_SET_DIFFICULTY, $a_i_Mode)
EndFunc   ;==>SwitchMode

;~ Description: Donate Kurzick or Luxon faction.
Func Game_DonateFaction($a_s_Faction)
    If StringLeft($a_s_Faction, 1) = 'k' Then
        Return Core_SendPacket(0x10, $GC_I_HEADER_FACTION_DEPOSIT, 0, 0, 5000)
    Else
        Return Core_SendPacket(0x10, $GC_I_HEADER_FACTION_DEPOSIT, 0, 1, 5000)
    EndIf
EndFunc   ;==>DonateFaction