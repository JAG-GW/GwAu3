#include-once

Func GwAu3_GuildMod_InviteGuild($charName)
	DllStructSetData($mInviteGuild, 1, GwAu3_Memory_GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mInviteGuild, 3, 0xBC)
	DllStructSetData($mInviteGuild, 4, 0x01)
	DllStructSetData($mInviteGuild, 5, $charName)
	DllStructSetData($mInviteGuild, 6, 0x02)
	GwAu3_Core_Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
EndFunc   ;==>InviteGuild

Func GwAu3_GuildMod_InviteGuest($charName)
	DllStructSetData($mInviteGuild, 1, GwAu3_Memory_GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mInviteGuild, 3, 0xBC)
	DllStructSetData($mInviteGuild, 4, 0x01)
	DllStructSetData($mInviteGuild, 5, $charName)
	DllStructSetData($mInviteGuild, 6, 0x01)
	GwAu3_Core_Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
EndFunc   ;==>InviteGuest