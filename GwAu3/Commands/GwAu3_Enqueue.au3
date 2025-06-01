#include-once
#include "../AddOns/GwAu3_AddOns.au3"
#include "../GwAu3_Core.au3"
#include "../Queries/GwAu3_GetInfo.au3"
#include "../Commands/GwAu3_Packet.au3"

#Region Misc Enqueue
;~ Description: Change game language.
Func ToggleLanguage()
	DllStructSetData($mToggleLanguage, 2, 0x18)
	Enqueue($mToggleLanguagePtr, 8)
EndFunc   ;==>ToggleLanguage

Func InviteGuild($charName)
	DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mInviteGuild, 3, 0xBC)
	DllStructSetData($mInviteGuild, 4, 0x01)
	DllStructSetData($mInviteGuild, 5, $charName)
	DllStructSetData($mInviteGuild, 6, 0x02)
	Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
EndFunc   ;==>InviteGuild

Func InviteGuest($charName)
	DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mInviteGuild, 3, 0xBC)
	DllStructSetData($mInviteGuild, 4, 0x01)
	DllStructSetData($mInviteGuild, 5, $charName)
	DllStructSetData($mInviteGuild, 6, 0x01)
	Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
EndFunc   ;==>InviteGuest
#EndRegion Misc Enqueue
