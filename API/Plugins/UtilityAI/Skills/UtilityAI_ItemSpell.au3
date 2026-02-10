#include-once

Func Anti_ItemSpell()
	;~ Generic hex checks
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False
	
	;~ Specific hex checks
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) Then Return True

	;~ Check for hexes that punish casting by damage
	Local $l_i_CommingDamage = 0

	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BACKFIRE) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_BACKFIRE, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
		$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, "Scale")
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
			$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, "BonusScale")
		EndIf
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP) Then
		$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP, "Scale")
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP) Then
			$l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET_PVP, "BonusScale")
		EndIf
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MISTRUST, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST_PVP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MISTRUST_PVP, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MARK_OF_SUBVERSION) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_MARK_OF_SUBVERSION, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SOUL_LEECH) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SOUL_LEECH, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_SPITEFUL_SPIRIT, "Scale")
	Return $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50)
EndFunc

; Skill ID: 772 - $GC_I_SKILL_ID_GENEROUS_WAS_TSUNGRAI
Func CanUse_GenerousWasTsungrai()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_GenerousWasTsungrai($a_f_AggroRange)
	; Description
	; Item Spell. Hold Tsungrai's ashes for up to 15...51...60 seconds and gain +50...122...140 maximum Health. When you drop his ashes, you gain 100...244...280 Health.
	; Concise description
	; Item Spell. (15...51...60 seconds.) You have +50...122...140 maximum Health. Drop effect: you gain 100...244...280 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 773 - $GC_I_SKILL_ID_MIGHTY_WAS_VORIZUN
Func CanUse_MightyWasVorizun()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_MightyWasVorizun($a_f_AggroRange)
	; Description
	; Item Spell. Hold Vorizun's ashes for up to 15...51...60 seconds. While you hold his ashes, you gain +15 armor and +30 maximum Energy.
	; Concise description
	; Item Spell. (15...51...60 seconds.) You have +15 armor and +30 maximum Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 788 - $GC_I_SKILL_ID_BLIND_WAS_MINGSON
Func CanUse_BlindWasMingson()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_BlindWasMingson($a_f_AggroRange)
	; Description
	; Item Spell. Hold Mingson's ashes for up to 15...51...60 seconds. When you drop his ashes, all nearby foes are Blinded for 3...7...8 seconds.
	; Concise description
	; Item Spell. (15...51...60 seconds.) Drop effect: inflicts Blindness condition (3...7...8 seconds) on all nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 789 - $GC_I_SKILL_ID_GRASPING_WAS_KUURONG
Func CanUse_GraspingWasKuurong()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_GraspingWasKuurong($a_f_AggroRange)
	; Description
	; Elite Item Spell. Hold Kuurong's ashes for up to 15...51...60 seconds. When you drop his ashes, all nearby foes are struck for 15...63...75 damage and knocked down.
	; Concise description
	; Elite Item Spell. (15...51...60 seconds.) Drop effect: deal 15...63...75 damage and knocks-down all nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 790 - $GC_I_SKILL_ID_VENGEFUL_WAS_KHANHEI
Func CanUse_VengefulWasKhanhei()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_VengefulWasKhanhei($a_f_AggroRange)
	; Description
	; Elite Item Spell. Hold Khanhei's ashes for 5...10...11 seconds. Whenever a foe strikes you in combat while you are holding Khanhei's ashes, you steal 5...29...35 Health from that foe.
	; Concise description
	; Elite Item Spell. (5...10...11 seconds.) You steal 5...29...35 Health from every foe that hits you with an attack.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 812 - $GC_I_SKILL_ID_DEFIANT_WAS_XINRAE
Func CanUse_DefiantWasXinrae()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_DefiantWasXinrae($a_f_AggroRange)
	; Description
	; Elite Item Spell. Hold Xinrae's ashes for up to 15...51...60 seconds. While you hold her ashes, you cannot lose more than 20% of your max Health from a single hit. When you drop her ashes, you steal 5...41...50 Health from all nearby foes.
	; Concise description
	; Elite Item Spell. (15...51...60 seconds.) You cannot lose more than 20% of your max Health from a single hit. Drop effect: steal 5...41...50 Health from nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 913 - $GC_I_SKILL_ID_TRANQUIL_WAS_TANASEN
Func CanUse_TranquilWasTanasen()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_TranquilWasTanasen($a_f_AggroRange)
	; Description
	; Elite Item Spell. Hold Tanasen's ashes for up to 5...17...20 seconds. While you hold his ashes, you have +10...22...25 armor and cannot be interrupted.
	; Concise description
	; Elite Item Spell. (5...17...20 seconds.) You have +10...22...25 armor. You cannot be interrupted.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1218 - $GC_I_SKILL_ID_CRUEL_WAS_DAOSHEN
Func CanUse_CruelWasDaoshen()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_CruelWasDaoshen($a_f_AggroRange)
	; Description
	; Item Spell. Hold Daoshen's ashes for up to 15...51...60 seconds. While you hold his ashes, all Ritualist skills have 10% armor penetration. When you drop his ashes, all nearby foes are struck for 15...71...85 lightning damage.
	; Concise description
	; Item Spell. (15...51...60 seconds.) Your Ritualist skills have 10% armor penetration. Drop effect: deals 15...71...85 lightning damage to all nearby foes.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1219 - $GC_I_SKILL_ID_PROTECTIVE_WAS_KAOLAI
Func CanUse_ProtectiveWasKaolai()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_ProtectiveWasKaolai($a_f_AggroRange)
	; Description
	; Item Spell. Hold Kaolai's ashes for up to 15...51...60 seconds. While you hold his ashes, you gain 10 armor. When you drop his ashes, all party members are healed for 10...70...85 Health.
	; Concise description
	; Item Spell. (15...51...60 seconds.) You have +10 armor. Drop effect: all party members are healed for 10...70...85.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1220 - $GC_I_SKILL_ID_ATTUNED_WAS_SONGKAI
Func CanUse_AttunedWasSongkai()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_AttunedWasSongkai($a_f_AggroRange)
	; Description
	; Elite Item Spell. Hold Songkai's ashes for up to 45 seconds. While you hold her ashes, your spells and binding rituals cost &#45;5...41...50% of the base Energy to cast.
	; Concise description
	; Elite Item Spell. (45 seconds.) Your spells and binding rituals cost &#45;5...41...50% of the base Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1221 - $GC_I_SKILL_ID_RESILIENT_WAS_XIKO
Func CanUse_ResilientWasXiko()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_ResilientWasXiko($a_f_AggroRange)
	; Description
	; Item Spell. Hold Xiko's ashes for up to 5...17...20 seconds. For each hex or condition you are suffering from while holding her ashes, you gain +3 Health regeneration. When you drop her ashes, you lose 1...3...4 conditions.
	; Concise description
	; Item Spell. (5...17...20 seconds.) You have +3 Health regeneration for each hex or condition on you. Drop effect: you lose 1...3...4 condition[s].
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1222 - $GC_I_SKILL_ID_LIVELY_WAS_NAOMEI
Func CanUse_LivelyWasNaomei()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_LivelyWasNaomei($a_f_AggroRange)
	; Description
	; Item Spell. Hold Naomei's ashes for up to 45 seconds. When you drop her ashes, all party members in the area are resurrected with 15...63...75% Health and zero Energy.
	; Concise description
	; Item Spell. (45 seconds.) Drop effect: resurrects party members in the area (15...63...75% Health and zero Energy).
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1223 - $GC_I_SKILL_ID_ANGUISHED_WAS_LINGWAH
Func CanUse_AnguishedWasLingwah()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_AnguishedWasLingwah($a_f_AggroRange)
	; Description
	; Item Spell. Hold Lingwah's ashes for up to 10...50...60 seconds. While you hold her ashes, your Ritualist hexes cost 1...4...5 less energy and last 33% longer. When you drop her ashes all your Ritualist hexes are recharged.
	; Concise description
	; Item Spell. (10...50...60 seconds.) Your Ritualist hexes cost 1...4...5 less energy and last 33% longer. Drop effect: all your Ritualist hexes are recharged.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1731 - $GC_I_SKILL_ID_VOCAL_WAS_SOGOLON
Func CanUse_VocalWasSogolon()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_VocalWasSogolon($a_f_AggroRange)
	; Description
	; Item Spell. For 60 seconds, all shouts and chants you use last 20...44...50% longer.
	; Concise description
	; Item Spell. (60 seconds.) Shouts and chants you use last 20...44...50% longer.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 1732 - $GC_I_SKILL_ID_DESTRUCTIVE_WAS_GLAIVE
Func CanUse_DestructiveWasGlaive()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_DestructiveWasGlaive($a_f_AggroRange)
	; Description
	; Elite Item Spell. Hold Glaive's ashes for up to 30...54...60 seconds. While you hold her ashes, all Ritualist skills have 20% armor penetration. When you drop her ashes, all foes in the area are struck for 15...71...85 lightning damage.
	; Concise description
	; Elite Item Spell. (30...54...60 seconds.) Your Ritualist skills have 20% armor penetration. Drop effect: deals 15...71...85 lightning damage to all foes in the area.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2016 - $GC_I_SKILL_ID_ENERGETIC_WAS_LEE_SA
Func CanUse_EnergeticWasLeeSa()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_EnergeticWasLeeSa($a_f_AggroRange)
	; Description
	; Item Spell. Hold Lee Sa's ashes for 5...13...15 seconds. While you hold her ashes, you gain +2 Energy regeneration. When you drop her ashes, you gain +1...8...10 Energy.
	; Concise description
	; Item Spell. (5...13...15 seconds.) You have +2 Energy regeneration. Drop effect: you gain +1...8...10 Energy.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2072 - $GC_I_SKILL_ID_PURE_WAS_LI_MING
Func CanUse_PureWasLiMing()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_PureWasLiMing($a_f_AggroRange)
	; Description
	; Item Spell. Hold Li Ming's ashes for 5...17...20 seconds. While you hold her ashes, conditions on you expire 10...42...50% faster. When you drop her ashes, all allies within earshot lose 1...3...4 condition[s].
	; Concise description
	; Item Spell. (5...17...20 seconds.) Conditions on you expire 10...42...50% faster. Drop effect: removes 1...3...4 condition[s] from allies in earshot.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 2537 - $GC_I_SKILL_ID_COURAGEOUS_WAS_SAIDRA
Func CanUse_CourageousWasSaidra()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_CourageousWasSaidra($a_f_AggroRange)
	; Description
	; Item Spell. Hold Saidra's Ashes for up to 300 seconds. While you hold her ashes, you gain +30 maximum Energy. When you drop her ashes, all party members are healed for 200 Health.
	; Concise description
	; Item Spell. Hold Saidra's Ashes for up to 300 seconds. While you hold her ashes, you gain +30 maximum Energy. When you drop her ashes, all party members are healed for 200 Health.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

; Skill ID: 3157 - $GC_I_SKILL_ID_DESTRUCTIVE_WAS_GLAIVE_PvP
Func CanUse_DestructiveWasGlaivePvP()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc

Func BestTarget_DestructiveWasGlaivePvP($a_f_AggroRange)
	; Description
	; Elite Item Spell. Hold Glaive's ashes for up to 30...54...60 seconds. While you hold her ashes, all Ritualist skills have 10% armor penetration. When you drop her ashes, all foes in the area are struck for 15...71...85 lightning damage.
	; Concise description
	; Elite Item Spell. (30...54...60 seconds.) Your Ritualist skills have 10% armor penetration. Drop effect: deals 15...71...85 lightning damage to all foes in the area.
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc

