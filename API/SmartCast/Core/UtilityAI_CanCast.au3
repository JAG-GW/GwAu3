#include-once

;Check if auto attack can be made
Func UAI_CanAutoAttack()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BLIND) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spirit_Shackles) Then Return False

	Local $l_i_CommingDamage = 0

	; Check for hexes that punish attacking
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Ineptitude) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Ineptitude, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Clumsiness) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Clumsiness, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Wandering_Eye) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Wandering_Eye, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Wandering_Eye_PvP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Wandering_Eye_PvP, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spiteful_Spirit) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Spiteful_Spirit, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spoil_Victor) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Spoil_Victor, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Empathy) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Empathy, "Scale")
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Empathy_PvP) Then $l_i_CommingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_Empathy_PvP, "Scale")

	If $l_i_CommingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50) Then Return False

	Return True
EndFunc

; Check if I have resource to use the skill
Func UAI_CanCast($a_i_SkillSlot)
	;~ EARLY CHECK IF CAST IS SENSIBLE AT ALL
	If UAI_IsCastSensible($a_i_SkillSlot) = False Then Return False

	;~ ADRENALINE
	If UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Adrenaline) <> 0 Then
		If UAI_GetDynamicSkillInfo($a_i_SkillSlot, $GC_UAI_DYNAMIC_SKILL_Adrenaline) < UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Adrenaline) Then Return False
		Return True
	EndIf

	;~ COOLDOWN
	If Not UAI_GetDynamicSkillInfo($a_i_SkillSlot, $GC_UAI_DYNAMIC_SKILL_IsRecharged) Then Return False

	;~ HEALTH COST (Sacrifice spells + Masochism effect on ALL spells)
	Local $l_i_TotalHealthCost = 0

	; Check base sacrifice cost (for sacrifice spells)
	Local $l_i_BaseSacrificeCost = Skill_GetSkillInfo(UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillID), "HealthCost")
	If $l_i_BaseSacrificeCost <> 0 Then
		$l_i_TotalHealthCost = UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP) * $l_i_BaseSacrificeCost / 100

		; Check effects that modify sacrifice cost
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Awaken_the_Blood) Then
			$l_i_TotalHealthCost = $l_i_TotalHealthCost + ($l_i_TotalHealthCost * 0.5) ; +50% cost
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Scourge_Sacrifice) Then
			$l_i_TotalHealthCost = $l_i_TotalHealthCost * 2 ; Double cost
		EndIf
	EndIf

	; Masochism: Sacrifice 5% of max HP when casting ANY spell
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Masochism) Then
		$l_i_TotalHealthCost = $l_i_TotalHealthCost + (UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP) * 0.05)
	EndIf

	; Check if we have enough HP for the total health cost
	If $l_i_TotalHealthCost > 0 Then
		If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) <= $l_i_TotalHealthCost Then Return False
	EndIf

	;~ OVERCAST
	Local $l_i_OvercastCost = Skill_GetSkillInfo(UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillID), "Overcast")
	If $l_i_OvercastCost <> 0 Then
		Local $l_i_CurrentOvercast = UAI_GetPlayerInfo($GC_UAI_AGENT_Overcast)
		Local $l_i_MaxEnergy = UAI_GetPlayerInfo($GC_UAI_AGENT_MaxEnergy)

		If ($l_i_CurrentOvercast + $l_i_OvercastCost) >= ($l_i_MaxEnergy * 0.5) Then Return False
	EndIf

	;~ ENERGY
	If UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_EnergyCost) <> 0 Then
		Local $l_i_BaseEnergyCost = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_EnergyCost)
		Local $l_i_EnergyCost = $l_i_BaseEnergyCost
		Local $l_i_CurrentEnergy = UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy)
		Local $l_i_SkillType = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillType)

		; Check effects that INCREASE energy cost
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Quickening_Zephyr) Then
			$l_i_EnergyCost = $l_i_EnergyCost * 1.3 ; +30% energy cost
		EndIf

		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Natures_Renewal) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_HEX Or $l_i_SkillType = $GC_I_SKILL_TYPE_ENCHANTMENT Then
				$l_i_EnergyCost = $l_i_EnergyCost * 2 ; Double cost for hexes/enchantments
			EndIf
		EndIf

		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Primal_Echoes) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_SIGNET Then
				$l_i_EnergyCost = $l_i_EnergyCost + 10 ; Signets cost +10 energy
			EndIf
		EndIf

		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Roaring_Winds) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_CHANT Or $l_i_SkillType = $GC_I_SKILL_TYPE_SHOUT Then
				$l_i_EnergyCost = $l_i_EnergyCost + 5 ; Chants/shouts cost +5 energy (average rank)
			EndIf
		EndIf

		; Check for energy cost REDUCTION effects
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Glyph_of_Lesser_Energy) Then
			$l_i_EnergyCost = $l_i_EnergyCost - 18 ; -18 energy (max rank)
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Glyph_of_Energy) Then
			$l_i_EnergyCost = $l_i_EnergyCost - 25 ; -25 energy (max rank)
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Energizing_Wind) Then
			$l_i_EnergyCost = $l_i_EnergyCost - 15 ; -15 energy
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Divine_Spirit) And UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Attribute) = $GC_I_ATTRIBUTE_MONK Then
			$l_i_EnergyCost = $l_i_EnergyCost - 5 ; Monk spells -5 energy
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Cultists_Fervor) Then
			If UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Attribute) >= $GC_I_ATTRIBUTE_BLOOD_MAGIC And UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Attribute) <= $GC_I_ATTRIBUTE_SOUL_REAPING Then
				$l_i_EnergyCost = $l_i_EnergyCost - 6 ; Necro spells -6 energy (max rank)
			EndIf
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Air_of_Enchantment) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_ENCHANTMENT And UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Target) <> 0 Then
				$l_i_EnergyCost = $l_i_EnergyCost - 5 ; Enchantments on allies -5 energy
			EndIf
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_SELFLESS_SPIRIT_LUXON) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_SELFLESS_SPIRIT_KURZICK) Then
			If UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Target) <> 0 Then ; Target another ally
				$l_i_EnergyCost = $l_i_EnergyCost - 3 ; Spells on allies -3 energy
			EndIf
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Healers_Covenant) And UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Attribute) = $GC_I_ATTRIBUTE_HEALING_PRAYERS Then
			$l_i_EnergyCost = $l_i_EnergyCost - 3 ; Healing Prayers -3 energy
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Attuned_Was_Songkai) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_SPELL Or $l_i_SkillType = $GC_I_SKILL_TYPE_RITUAL Then
				$l_i_EnergyCost = $l_i_EnergyCost - ($l_i_BaseEnergyCost * 0.5) ; -50% cost
			EndIf
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Anguished_Was_Lingwah) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_HEX And UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Attribute) >= $GC_I_ATTRIBUTE_CHANNELING_MAGIC And UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Attribute) <= $GC_I_ATTRIBUTE_SPAWNING_POWER Then
				$l_i_EnergyCost = $l_i_EnergyCost - 5 ; Ritualist hexes -5 energy
			EndIf
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Renewing_Memories) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_WEAPON_SPELL Or $l_i_SkillType = $GC_I_SKILL_TYPE_ITEM_SPELL Then
				$l_i_EnergyCost = $l_i_EnergyCost - ($l_i_BaseEnergyCost * 0.35) ; -35% cost
			EndIf
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Soul_Twisting) And $l_i_SkillType = $GC_I_SKILL_TYPE_RITUAL Then
			$l_i_EnergyCost = $l_i_EnergyCost - 15 ; Binding rituals -15 energy
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Way_of_the_Empty_Palm) Then
			If $l_i_SkillType = $GC_I_SKILL_TYPE_OFF_HAND_ATTACK Or $l_i_SkillType = $GC_I_SKILL_TYPE_DUAL_ATTACK Then
				$l_i_EnergyCost = 0 ; Off-hand and dual attacks cost 0
			EndIf
		EndIf
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_Expert_Focus) And $l_i_SkillType = $GC_I_SKILL_TYPE_BOW_ATTACK Then
			$l_i_EnergyCost = $l_i_EnergyCost - 2 ; Bow attacks -2 energy
		EndIf

		; Minimum cost is 1 (except for Way of the Empty Palm which makes it 0)
		If $l_i_EnergyCost < 1 And Not UAI_PlayerHasEffect($GC_I_SKILL_ID_Way_of_the_Empty_Palm) Then
			$l_i_EnergyCost = 1
		EndIf
		If $l_i_EnergyCost < 0 Then $l_i_EnergyCost = 0

		If $l_i_CurrentEnergy < $l_i_EnergyCost Then Return False
	EndIf

	Return True
EndFunc

Func UAI_CanDrop($a_i_SkillSlot)
	Switch UAI_GetStaticSkillInfo($l_i_Slot, $GC_UAI_STATIC_SKILL_SkillID)
		Case
	EndSwitch
	Return False
EndFunc

Func UAI_IsCastSensible($a_i_SkillSlot)
    Local $l_i_TargetType = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Target)
    If $l_i_TargetType <> $GC_I_SKILL_TARGET_SELF Then Return True

    Local $l_i_SkillType = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillType)
    Local $l_i_SkillID   = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillID)

    Switch $l_i_SkillType
        Case _
            $GC_I_SKILL_TYPE_ENCHANTMENT, _
            $GC_I_SKILL_TYPE_WARD, _
            $GC_I_SKILL_TYPE_SHOUT, _
            $GC_I_SKILL_TYPE_RITUAL, _
            $GC_I_SKILL_TYPE_FORM, _
            $GC_I_SKILL_TYPE_ECHO_REFRAIN

			Return _UAI_EffectEndingSoon($l_i_SkillID, $a_i_SkillSlot)

		Case $GC_I_SKILL_TYPE_STANCE
			If Not UAI_PlayerHasEffectType("HasStance") Then Return True
			If @extended <> $l_i_SkillID Then Return False
			Return _UAI_EffectEndingSoon($l_i_SkillID, $a_i_SkillSlot)
		Case $GC_I_SKILL_TYPE_GLYPH
			If Not UAI_PlayerHasEffectType("HasGlyph") Then Return True
			If @extended <> $l_i_SkillID Then Return False
			Return _UAI_EffectEndingSoon($l_i_SkillID, $a_i_SkillSlot)
		Case  $GC_I_SKILL_TYPE_PREPARATION
			If Not UAI_PlayerHasEffectType("HasPreparation") Then Return True
			If @extended <> $l_i_SkillID Then Return False
			Return _UAI_EffectEndingSoon($l_i_SkillID, $a_i_SkillSlot)
    EndSwitch

    Return True
EndFunc

Func _UAI_EffectEndingSoon($a_i_SkillID, $a_i_SkillSlot)
	Return UAI_GetPlayerEffectInfo($a_i_SkillID, $GC_UAI_EFFECT_TimeRemaining) < _
		(UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Activation)*1000 + 1000)
EndFunc