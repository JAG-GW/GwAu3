#include-once

#Region === Skill Functions ===

; Get skill slot by skill ID
Func Skill_GetSlotByID($a_i_SkillID)
	For $l_i_i = 1 To 8
		Local $l_i_SlotSkillID = Skill_GetSkillbarInfo($l_i_i, "SkillID")
		If $l_i_SlotSkillID = $a_i_SkillID Then Return $l_i_i
	Next
	Return 0
EndFunc

Func Skill_CheckSlotByID($a_i_SkillID)
	For $l_i_i = 1 To 8
		Local $l_i_SlotSkillID = Skill_GetSkillbarInfo($l_i_i, "SkillID")
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
	If $a_i_HeroNumber = 0 Then Return Agent_GetMyID()
	Return Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
EndFunc

; Get all party members as array
Func Party_GetMembersArray()
	Local $l_i_PartySize = Party_GetSize()
	Local $l_i_HeroCount = Party_GetHeroCount()
	Local $l_ai_ReturnArray[$l_i_PartySize + 1]
	$l_ai_ReturnArray[0] = $l_i_PartySize

	; Add player (index 0)
	$l_ai_ReturnArray[1] = Agent_GetMyID()

	; Add heroes
	Local $l_i_Index = 2
	For $l_i_i = 1 To $l_i_HeroCount
		If $l_i_Index <= $l_i_PartySize Then
			$l_ai_ReturnArray[$l_i_Index] = Party_GetMyPartyHeroInfo($l_i_i, "AgentID")
			$l_i_Index += 1
		EndIf
	Next

	; Add henchmen/other party members
	For $l_i_i = 1 To Party_GetMyPartyInfo("HenchmanCount")
		If $l_i_Index <= $l_i_PartySize Then
			$l_ai_ReturnArray[$l_i_Index] = Party_GetMyPartyHenchmanInfo($l_i_i, "AgentID")
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

	For $l_i_i = 1 To $l_ai_PartyArray[0]
		If Not UAI_GetAgentInfoByID($l_ai_PartyArray[$l_i_i], $GC_UAI_AGENT_IsDead) Then
			$l_f_TotalHP += UAI_GetAgentInfoByID($l_ai_PartyArray[$l_i_i], $GC_UAI_AGENT_HP)
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
	For $l_i_i = 1 To Party_GetHeroCount()
		If UAI_GetAgentInfoByID(Party_GetHeroID($l_i_i), $GC_UAI_AGENT_IsDead) Then
			$l_i_DeadHeroes += 1
		EndIf
	Next

	If GetAvailableRezz() = 0 Or $l_i_DeadHeroes >= UBound(Party_GetMembersArray()) - 2 Or Party_GetAverageHealth() < 0.15 Then
		Return True
	EndIf

	Return False
EndFunc

#EndRegion === Party Functions ===
