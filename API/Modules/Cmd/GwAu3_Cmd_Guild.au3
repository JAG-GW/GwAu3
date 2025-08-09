#include-once

Func Guild_InviteGuild($a_s_CharName)
    DllStructSetData($g_d_InviteGuild, 2, 0x4C)
    DllStructSetData($g_d_InviteGuild, 3, 0xB4)
    DllStructSetData($g_d_InviteGuild, 4, 0x01)
    DllStructSetData($g_d_InviteGuild, 5, $a_s_CharName)
    DllStructSetData($g_d_InviteGuild, 6, 0x02)
    Core_Enqueue(DllStructGetPtr($g_d_InviteGuild), DllStructGetSize($g_d_InviteGuild))
EndFunc   ;==>InviteGuild

Func Guild_InviteGuest($a_s_CharName)
    DllStructSetData($g_d_InviteGuild, 2, 0x4C)
    DllStructSetData($g_d_InviteGuild, 3, 0xB4)
    DllStructSetData($g_d_InviteGuild, 4, 0x01)
    DllStructSetData($g_d_InviteGuild, 5, $a_s_CharName)
    DllStructSetData($g_d_InviteGuild, 6, 0x01)
    Core_Enqueue(DllStructGetPtr($g_d_InviteGuild), DllStructGetSize($g_d_InviteGuild))
EndFunc   ;==>InviteGuest