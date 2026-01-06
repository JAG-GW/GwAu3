#include-once

#Region === Skill Functions ===

; Get skill slot by skill ID
Func Skill_GetSlotByID($a_i_SkillID, $a_i_HeroNumber = 0)
	For $i = 1 To 8
		Local $l_i_SlotSkillID = Skill_GetSkillbarInfo($i, "SkillID", $a_i_HeroNumber)
		If $l_i_SlotSkillID = $a_i_SkillID Then Return $i
	Next
	Return 0
EndFunc

Func Skill_CheckSlotByID($a_i_SkillID, $a_i_HeroNumber = 0)
	For $i = 1 To 8
		Local $l_i_SlotSkillID = Skill_GetSkillbarInfo($i, "SkillID", $a_i_HeroNumber)
		If $l_i_SlotSkillID = $a_i_SkillID Then Return True
	Next
	Return False
EndFunc

#EndRegion === Skill Functions ===

#Region === Party Functions ===

; Get the current party size
Func Party_GetSize()
	Return Party_GetMyPartyInfo("Size")
EndFunc

; Get the number of heroes in party
Func Party_GetHeroCount()
	Return Party_GetMyPartyInfo("HeroCount")
EndFunc

; Get hero ID by hero number (0 = player)
Func Party_GetHeroID($a_i_HeroNumber)
	If $a_i_HeroNumber = 0 Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
EndFunc

; Get all party members as array
Func Party_GetMembersArray()
	Local $l_i_PartySize = Party_GetSize()
	If $l_i_PartySize < 1 Then $l_i_PartySize = 1
	Local $l_i_HeroCount = Party_GetHeroCount()
	Local $l_ai_ReturnArray[$l_i_PartySize + 1]
	$l_ai_ReturnArray[0] = $l_i_PartySize

	; Add player (index 0)
	$l_ai_ReturnArray[1] = UAI_GetPlayerInfo($GC_UAI_AGENT_ID)

	; Add heroes
	Local $l_i_Index = 2
	For $i = 1 To $l_i_HeroCount
		If $l_i_Index <= $l_i_PartySize Then
			$l_ai_ReturnArray[$l_i_Index] = Party_GetMyPartyHeroInfo($i, "AgentID")
			$l_i_Index += 1
		EndIf
	Next

	; Add henchmen/other party members
	For $i = 1 To Party_GetMyPartyInfo("HenchmanCount")
		If $l_i_Index <= $l_i_PartySize Then
			$l_ai_ReturnArray[$l_i_Index] = Party_GetMyPartyHenchmanInfo($i, "AgentID")
			$l_i_Index += 1
		EndIf
	Next

	Return $l_ai_ReturnArray
EndFunc

; Get average party health percentage
Func Party_GetAverageHealth()
	Local $l_f_TotalHP = 0
	Local $l_i_AliveCount = 0
	Local $l_ai_PartyArray = Party_GetMembersArray()

	For $i = 1 To $l_ai_PartyArray[0]
		If Not UAI_GetAgentInfoByID($l_ai_PartyArray[$i], $GC_UAI_AGENT_IsDead) Then
			$l_f_TotalHP += UAI_GetAgentInfoByID($l_ai_PartyArray[$i], $GC_UAI_AGENT_HP)
			$l_i_AliveCount += 1
		EndIf
	Next

	If $l_i_AliveCount = 0 Then Return 0
	Return Round($l_f_TotalHP / $l_i_AliveCount, 3)
EndFunc

; Check if party is wiped
Func Party_IsWiped()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsDead) Then Return False

	Local $l_i_DeadHeroes = 0
	For $i = 1 To Party_GetHeroCount()
		If UAI_GetAgentInfoByID(Party_GetHeroID($i), $GC_UAI_AGENT_IsDead) Then
			$l_i_DeadHeroes += 1
		EndIf
	Next

	If Party_GetAvailableRezz() = 0 Or $l_i_DeadHeroes >= UBound(Party_GetMembersArray()) - 2 Or Party_GetAverageHealth() < 0.15 Then
		Return True
	EndIf

	Return False
EndFunc

; returns the number of available rezz skills excluding dead party members, use to force move, aggro and death when no more rezz is available
Func Party_GetAvailableRezz()
	Local $l_i_HeroRezzSkills = 0
	Local $l_i_HeroCount = Party_GetHeroCount()
	For $aHeroNumber = 1 To $l_i_HeroCount
		$aHeroPtr = GetHeroPtr($aHeroNumber)
		For $aSkillSlot = 1 To 8
			$aSkill = Skill_GetSlotByID($aSkillSlot, $aHeroNumber)
			If Skill_HasSpecialFlag($aSkill, $GC_I_SKILL_SPECIAL_FLAG_RESURRECTION) Then
				$l_i_HeroRezzSkills += 1
			EndIf
		Next
	Next
	Return $l_i_HeroRezzSkills
EndFunc   ;==>GetAvailableRezz
#EndRegion === Party Functions ===

#Region === Agent Estimation Functions ===

; Profession constants for reference
; 0 = None, 1 = Warrior, 2 = Ranger, 3 = Monk, 4 = Necromancer
; 5 = Mesmer, 6 = Elementalist, 7 = Assassin, 8 = Ritualist, 9 = Paragon, 10 = Dervish

; Get the primary profession of an agent (works for players, heroes, henchmen AND mobs)
; For players: uses $GC_UAI_AGENT_Primary
; For mobs (NPCs): reads from NpcArray in memory
Func UAI_GetAgentProfession($a_i_AgentID)
	; Check if it's a player/hero/henchman (LoginNumber != 0)
	Local $l_i_LoginNumber = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber)
	If $l_i_LoginNumber <> 0 Then
		Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Primary)
	EndIf

	; It's a mob/NPC, read from NpcArray
	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return 0

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return 0

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	Return $l_i_NpcPrimary
EndFunc

; Get armor bonus based on profession
; Warrior/Paragon: +20, Ranger/Assassin/Dervish: +10, Others: +0
Func UAI_GetArmorBonus($a_i_Profession)
	Switch $a_i_Profession
		Case 1, 9  ; Warrior, Paragon
			Return 20
		Case 2, 7, 10  ; Ranger, Assassin, Dervish
			Return 10
		Case Else  ; Monk, Necro, Mesmer, Ele, Rit, None
			Return 0
	EndSwitch
EndFunc

; Get estimated max HP for an agent
; Normal Mode: Level × 20 + 80
; Hard Mode: Level × 20 + 80 + (Level - 20) × 20 if Level > 20
; Exception: Enemy Dervishes don't get +25 HP bonus (but that's for players, not relevant here)
Func UAI_GetEstimatedMaxHP($a_i_AgentID)
	Local $l_i_Level = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Level)
	If $l_i_Level = 0 Then $l_i_Level = 20  ; Default to level 20 if unknown

	Local $l_i_BaseHP = $l_i_Level * 20 + 80

	; Hard Mode bonus: +20 HP per level above 20
	If Party_GetPartyContextInfo("IsHardMode") And $l_i_Level > 20 Then
		$l_i_BaseHP += ($l_i_Level - 20) * 20
	EndIf

	Return $l_i_BaseHP
EndFunc

; Get estimated current HP for an agent
; Formula: HP% × EstimatedMaxHP
Func UAI_GetEstimatedCurrentHP($a_i_AgentID)
	Local $l_f_HPPercent = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP)
	Return Round($l_f_HPPercent * UAI_GetEstimatedMaxHP($a_i_AgentID))
EndFunc

; Get base armor rating for an agent
; Formula: Level × 3 + ArmorBonus
Func UAI_GetBaseArmor($a_i_AgentID)
	Local $l_i_Level = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Level)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	If $l_i_Level = 0 Then $l_i_Level = 20  ; Default to level 20 if unknown
	Return $l_i_Level * 3 + UAI_GetArmorBonus($l_i_Primary)
EndFunc

; Get physical armor rating for an agent
; Warriors have +20 armor vs physical damage
Func UAI_GetPhysicalArmor($a_i_AgentID)
	Local $l_i_BaseArmor = UAI_GetBaseArmor($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)

	; Warriors have +20 vs physical
	If $l_i_Primary = 1 Then  ; Warrior
		Return $l_i_BaseArmor + 20
	EndIf

	Return $l_i_BaseArmor
EndFunc

; Get elemental armor rating for an agent
; Rangers have +30 armor vs elemental damage
Func UAI_GetElementalArmor($a_i_AgentID)
	Local $l_i_BaseArmor = UAI_GetBaseArmor($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)

	; Rangers have +30 vs elemental
	If $l_i_Primary = 2 Then  ; Ranger
		Return $l_i_BaseArmor + 30
	EndIf

	Return $l_i_BaseArmor
EndFunc

; Calculate damage multiplier based on armor
; Formula: 2 ^ ((60 - Armor) / 40)
; Reference: 60 AL = 1.0x damage
; Lower armor = more damage, higher armor = less damage
Func UAI_GetDamageMultiplier($a_i_Armor)
	; Clamp armor to reasonable values (minimum 0)
	If $a_i_Armor < 0 Then $a_i_Armor = 0
	Return 2 ^ ((60 - $a_i_Armor) / 40)
EndFunc

; Calculate effective armor after penetration
; Penetration reduces armor by a percentage
; Example: 20% penetration on 100 AL = 80 AL effective
Func UAI_GetEffectiveArmor($a_i_BaseArmor, $a_f_Penetration = 0)
	If $a_f_Penetration <= 0 Then Return $a_i_BaseArmor
	If $a_f_Penetration > 1 Then $a_f_Penetration = 1  ; Cap at 100%
	Return Round($a_i_BaseArmor * (1 - $a_f_Penetration))
EndFunc

; Estimate damage dealt to a target based on base damage and target's armor
; $a_i_BaseDamage: Raw damage before armor
; $a_i_AgentID: Target agent
; $a_s_DamageType: "physical", "elemental", or "armor-ignoring"
; $a_f_Penetration: Armor penetration (0.0 to 1.0, e.g., 0.20 for 20%)
Func UAI_EstimateDamage($a_i_BaseDamage, $a_i_AgentID, $a_s_DamageType = "physical", $a_f_Penetration = 0)
	; Armor-ignoring damage bypasses armor completely
	If $a_s_DamageType = "armor-ignoring" Then Return $a_i_BaseDamage

	; Get appropriate armor based on damage type
	Local $l_i_Armor
	Switch $a_s_DamageType
		Case "physical"
			$l_i_Armor = UAI_GetPhysicalArmor($a_i_AgentID)
		Case "elemental", "fire", "cold", "lightning", "earth"
			$l_i_Armor = UAI_GetElementalArmor($a_i_AgentID)
		Case Else
			$l_i_Armor = UAI_GetBaseArmor($a_i_AgentID)
	EndSwitch

	; Apply penetration
	Local $l_i_EffectiveArmor = UAI_GetEffectiveArmor($l_i_Armor, $a_f_Penetration)

	; Calculate final damage
	Local $l_f_Multiplier = UAI_GetDamageMultiplier($l_i_EffectiveArmor)
	Return Round($a_i_BaseDamage * $l_f_Multiplier)
EndFunc

; Check if agent is a caster (low armor profession)
Func UAI_IsCaster($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	; Monk, Necro, Mesmer, Ele, Rit = casters (armor bonus = 0)
	Switch $l_i_Primary
		Case 3, 4, 5, 6, 8  ; Monk, Necro, Mesmer, Ele, Rit
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc

; Check if agent is melee (high armor profession)
Func UAI_IsMelee($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	; Warrior, Assassin, Dervish = melee
	Switch $l_i_Primary
		Case 1, 7, 10  ; Warrior, Assassin, Dervish
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc

; Check if agent is ranged (Ranger, Paragon)
Func UAI_IsRanged($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	; Ranger, Paragon = ranged physical
	Switch $l_i_Primary
		Case 2, 9  ; Ranger, Paragon
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc

#EndRegion === Agent Estimation Functions ===
