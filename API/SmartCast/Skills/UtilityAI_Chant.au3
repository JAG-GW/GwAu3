#include-once

Func Anti_Chant()
	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CACOPHONY) Then
		If Effect_GetEffectArg($GC_I_SKILL_ID_CACOPHONY, "Scale") > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50) Then Return True
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VOCAL_MINORITY) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_WELL_OF_SILENCE) Then Return True
	Return False
EndFunc

Func CanUse_AnthemOfFury()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfFury($a_f_AggroRange)
	; Description
	; Elite Chant. For 10 seconds, all party members within earshot gain 1...3...4 strikes of adrenaline the next time they use an attack skill.
	; Concise description
	; Elite Chant. (10 seconds.) Party members in earshot gain 1...3...4 adrenaline with their next attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_CripplingAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingAnthem($a_f_AggroRange)
	; Description
	; Elite Chant. For 10 seconds, the next attack skill used by each ally within earshot causes Crippling for 5...13...15 seconds.
	; Concise description
	; Elite Chant. (10 seconds.) Allies in earshot inflict Crippled condition (5...13...15 seconds) with their next attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_DefensiveAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_DefensiveAnthem($a_f_AggroRange)
	; Description
	; Elite Chant. For 4...9...10 seconds, each party member within earshot has a 50% chance to block incoming attacks. This chant ends if that party member hits with an attack skill.
	; Concise description
	; Elite Chant. (4...9...10 seconds.) Party members in earshot have 50% chance to block. Ends when hitting with an attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfFlame()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfFlame($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next attack skill used by each party member within earshot also causes Burning for 1...3...3 second[s].
	; Concise description
	; Chant. (10 seconds.) Party members in earshot inflict Burning condition (1...3...3 second[s]) with their next attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfEnvy()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfEnvy($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next attack skill used by each ally within earshot deals +10...22...25 damage against foes with more than 50% Health.
	; Concise description
	; Chant. (10 seconds.) Allies in earshot do +10...22...25 damage with their next attack skill. Damage bonus only applies to foes with more than 50% Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SongOfPower()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfPower($a_f_AggroRange)
	; Description
	; Chant. For 5...17...20 seconds, each ally within earshot gains 4 Energy regeneration until that ally uses a Skill.
	; Concise description
	; Chant. (5...17...20 seconds.) Allies in earshot gain +4 Energy regeneration. Ends when using a skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ZealousAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_ZealousAnthem($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next time each ally within earshot uses an attack skill, that ally gains 1...7...8 Energy.
	; Concise description
	; Chant. (10 seconds.) Allies in earshot gain 1...7...8 Energy with their next attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AriaOfZeal()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AriaOfZeal($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next time each ally within earshot uses a Spell, that ally gains 1...5...6 Energy.
	; Concise description
	; Chant. (10 seconds.) Allies in earshot gain 1...5...6 Energy with their next spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_LyricOfZeal()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_LyricOfZeal($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next time each ally within earshot uses a signet, that ally gains 1...7...8 Energy.
	; Concise description
	; Chant. (10 seconds.) Allies in earshot gain 1...7...8 Energy with their next signet.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_BalladOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_BalladOfRestoration($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next time each party member within earshot takes damage, that party member gains 15...63...75 Health.
	; Concise description
	; Chant. (10 seconds.) Party members in earshot gain 15...63...75 Health the next time they take damage.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_ChorusOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_ChorusOfRestoration($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next time each ally within earshot uses a shout or chant, that ally is healed for 30...78...90 Health.
	; Concise description
	; Chant. (10 seconds.) Allies in earshot are healed for 30...78...90 with their next shout or chant.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AriaOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AriaOfRestoration($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next time each party member within earshot uses a spell, that party member gains 30...78...90 Health.
	; Concise description
	; Chant. (10 seconds.) Party members in earshot gain 30...78...90 Health with their next spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SongOfConcentration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfConcentration($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next skill used by each ally within earshot cannot be interrupted.
	; Concise description
	; Chant. (10 seconds.) Allies in earshot are uninterruptible with their next skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfGuidance()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfGuidance($a_f_AggroRange)
	; Description
	; Elite Chant. For 10 seconds, the next attack skill used by each party member within earshot cannot be blocked.
	; Concise description
	; Elite Chant. (10 seconds.) Party members in earshot are unblockable with their next attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_EnergizingChorus()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_EnergizingChorus($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next Shout or Chant used by each ally within earshot costs 3...6...7 less Energy.
	; Concise description
	; Chant. (10 seconds.) The next shout or chant costs 3...6...7 less Energy for allies within earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SongOfPurification()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfPurification($a_f_AggroRange)
	; Description
	; Elite Chant. For 20 seconds, the next 1...3...3 skill[s] used by each ally within earshot remove 1 condition from that ally.
	; Concise description
	; Elite Chant. (20 seconds.) Allies in earshot lose one condition with their next 1...3...3 skill[s].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_HexbreakerAria()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_HexbreakerAria($a_f_AggroRange)
	; Description
	; Chant. For 10 seconds, the next time each ally within earshot casts a spell, that ally loses 1 hex.
	; Concise description
	; Chant. (10 seconds.) Allies in earshot lose one hex with their next spell.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_PresenceOfTheSkaleLord()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_PresenceOfTheSkaleLord($a_f_AggroRange)
	; Description
	; Monster
	; Concise description
	; Notes">edit
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SongOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfRestoration($a_f_AggroRange)
	; Description
	; Elite Chant. For 10 seconds, the next time each party member within earshot uses a skill, that party member gains 45...97...110 Health.
	; Concise description
	; Elite Chant. (10 seconds.) Party members in earshot gain 45...97...110 Health with their next skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_LyricOfPurification()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_LyricOfPurification($a_f_AggroRange)
	; Description
	; Chant. For 5...17...20 seconds, the next time each ally within earshot uses a Signet, that ally loses 1 Condition.
	; Concise description
	; Chant. (5...17...20 seconds.) Allies in earshot lose one condition with their next signet.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfAggression()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfAggression($a_f_AggroRange)
	; Description
	; Paragon
	; Concise description
	; grey;">Ends when using an attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfWeariness()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfWeariness($a_f_AggroRange)
	; Description
	; Chant. For 8 seconds, the next attack skill used by each ally within earshot also causes Weakness for 1...13...16 second[s].
	; Concise description
	; Chant. (8 seconds.) Allies in earshot inflict Weakness (1...13...16 second[s]) with their next attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfDisruption()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfDisruption($a_f_AggroRange)
	; Description
	; Chant. For 1...8...10 seconds, the next attack skill used by each ally within earshot also interrupts an action.
	; Concise description
	; Chant. (1...8...10 seconds.) Allies in earshot interrupt an action with their next attack skill.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfPurity()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfPurity($a_f_AggroRange)
	; Description
	; Chant. Removes 1 hex and 1 condition from all allies within earshot. For each hex removed, enemies within earshot lose 1 enchantment.
	; Concise description
	; Chant. Removes 1 hex and 1 condition from all allies within earshot. For each hex removed, enemies within earshot lose 1 enchantment.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_DefensiveAnthemPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_DefensiveAnthemPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_BalladOfRestorationPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_BalladOfRestorationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_SongOfRestorationPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfRestorationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfDisruptionPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfDisruptionPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

Func CanUse_AnthemOfEnvyPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfEnvyPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
