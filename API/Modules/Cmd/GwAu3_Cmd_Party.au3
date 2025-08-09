#include-once

;~ Description: Adds a hero to the party.
Func Party_AddHero($a_i_HeroId)
    Return Core_SendPacket(0x8, $GC_I_HEADER_HERO_ADD, $a_i_HeroId)
EndFunc   ;==>AddHero

;~ Description: Kicks a hero from the party.
Func Party_KickHero($a_i_HeroId)
    Return Core_SendPacket(0x8, $GC_I_HEADER_HERO_KICK, $a_i_HeroId)
EndFunc   ;==>KickHero

;~ Description: Kicks all heroes from the party.
Func Party_KickAllHeroes()
    Return Core_SendPacket(0x8, $GC_I_HEADER_HERO_KICK, 0x26)
EndFunc

;~ Description: Add a henchman to the party.
Func Party_AddNpc($a_i_NpcId)
    Return Core_SendPacket(0x8, $GC_I_HEADER_PARTY_INVITE_NPC, $a_i_NpcId)
EndFunc   ;==>AddNpc

;~ Description: Kick a henchman from the party.
Func Party_KickNpc($a_i_NpcId)
    Return Core_SendPacket(0x8, $GC_I_HEADER_PARTY_KICK_NPC, $a_i_NpcId)
EndFunc   ;==>KickNpc

;~ Description: Clear the position flag from a hero.
Func Party_CancelHero($a_i_HeroNumber)
    Local $l_i_AgentID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Return Core_SendPacket(0x14, $GC_I_HEADER_HERO_FLAG_SINGLE, $l_i_AgentID, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelHero

;~ Description: Clear the position flag from all heroes.
Func Party_CancelAll()
    Return Core_SendPacket(0x10, $GC_I_HEADER_HERO_FLAG_ALL, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelAll

;~ Description: Place a hero's position flag.
Func Party_CommandHero($a_i_HeroNumber, $a_f_X, $a_f_Y)
    Return Core_SendPacket(0x14, $GC_I_HEADER_HERO_FLAG_SINGLE, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), Utils_FloatToInt($a_f_X), Utils_FloatToInt($a_f_Y), 0)
EndFunc   ;==>CommandHero

;~ Description: Place the full-party position flag.
Func Party_CommandAll($a_f_X, $a_f_Y)
    Return Core_SendPacket(0x10, $GC_I_HEADER_HERO_FLAG_ALL, Utils_FloatToInt($a_f_X), Utils_FloatToInt($a_f_Y), 0)
EndFunc   ;==>CommandAll

;~ Description: Lock a hero onto a target.
Func Party_LockHeroTarget($a_i_HeroNumber, $a_i_AgentID = 0) ;$a_i_AgentID=0 Cancels Lock
    Return Core_SendPacket(0xC, $GC_I_HEADER_HERO_LOCK_TARGET, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_AgentID)
EndFunc   ;==>LockHeroTarget

;~ Description: Change a hero's aggression level.
Func Party_SetHeroAggression($a_i_HeroNumber, $a_i_Aggression) ;0=Fight, 1=Guard, 2=Avoid
    Return Core_SendPacket(0xC, $GC_I_HEADER_HERO_BEHAVIOR, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_Aggression)
EndFunc   ;==>SetHeroAggression

;~ Description: Internal use for enabling or disabling hero skills
Func Party_ChangeHeroSkillSlotState($a_i_HeroNumber, $a_i_SkillSlot)
    Return Core_SendPacket(0xC, $GC_I_HEADER_HERO_SKILL_TOGGLE, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_SkillSlot - 1)
EndFunc   ;==>ChangeHeroSkillSlotState

;~ Description: Leave your party.
Func Party_LeaveGroup($a_b_KickHeroes = True)
    If $a_b_KickHeroes Then Party_KickAllHeroes()
    Return Core_SendPacket(0x4, $GC_I_HEADER_PARTY_LEAVE_GROUP)
EndFunc   ;==>LeaveGroup