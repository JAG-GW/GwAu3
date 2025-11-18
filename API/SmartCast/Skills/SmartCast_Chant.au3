#include-once

Func Anti_Chant()
	;Cacophony did damage when cast a Chant
	;If scale damage make more damage than our HP + 50 then true (don't cast)
	If Effect_GetEffectArg($GC_I_SKILL_ID_CACOPHONY, "Scale") > (Agent_GetAgentInfo(-2, "CurrentHP") + 50) Then Return True
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_VOCAL_MINORITY, "HasEffect") Then Return True
	If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_WELL_OF_SILENCE, "HasEffect") Then Return True
	Return False
EndFunc

Func CanUse_AnthemOfFury()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfFury($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_CripplingAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_CripplingAnthem($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DefensiveAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_DefensiveAnthem($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfFlame()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfFlame($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfEnvy()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfEnvy($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SongOfPower()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfPower($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ZealousAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_ZealousAnthem($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AriaOfZeal()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AriaOfZeal($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LyricOfZeal()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_LyricOfZeal($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BalladOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_BalladOfRestoration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_ChorusOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_ChorusOfRestoration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AriaOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AriaOfRestoration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SongOfConcentration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfConcentration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfGuidance()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfGuidance($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_EnergizingChorus()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_EnergizingChorus($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SongOfPurification()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfPurification($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_HexbreakerAria()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_HexbreakerAria($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_PresenceOfTheSkaleLord()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_PresenceOfTheSkaleLord($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SongOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfRestoration($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_LyricOfPurification()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_LyricOfPurification($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfAggression()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfAggression($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfWeariness()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfWeariness($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfDisruption()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfDisruption($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DesperateHowl()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_DesperateHowl($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfPurity()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfPurity($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_DefensiveAnthemPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_DefensiveAnthemPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_BalladOfRestorationPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_BalladOfRestorationPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_SongOfRestorationPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_SongOfRestorationPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfDisruptionPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfDisruptionPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc

Func CanUse_AnthemOfEnvyPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc

Func BestTarget_AnthemOfEnvyPvp($aAggroRange)
	Return Agent_GetMyID()
EndFunc
