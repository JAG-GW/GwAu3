#include-once

#Region === Skill Functions ===

; Get skill slot by skill ID
Func Skill_GetSlotByID($aSkillID)
	For $i = 1 To 8
		Local $lSlotSkillID = Skill_GetSkillbarInfo($i, "SkillID")
		If $lSlotSkillID = $aSkillID Then Return $i
	Next
	Return 0
EndFunc

Func Skill_CheckSlotByID($aSkillID)
	For $i = 1 To 8
		Local $lSlotSkillID = Skill_GetSkillbarInfo($i, "SkillID")
		If $lSlotSkillID = $aSkillID Then Return True
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
Func Party_GetHeroID($aHeroNumber)
	If $aHeroNumber = 0 Then Return Agent_GetMyID()
	Return Party_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
EndFunc

; Get hero pointer by hero number
Func Party_GetHeroPtr($aHeroNumber)
	If $aHeroNumber = 0 Then Return Agent_GetAgentPtr(-2)
	Local $lHeroID = Party_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Return Agent_GetAgentPtr($lHeroID)
EndFunc

; Get all party members as array
Func Party_GetMembersArray()
	Local $lPartySize = Party_GetSize()
	Local $lHeroCount = Party_GetHeroCount()
	Local $lReturnArray[$lPartySize + 1]
	$lReturnArray[0] = $lPartySize

	; Add player (index 0)
	$lReturnArray[1] = Agent_GetMyID()

	; Add heroes
	Local $lIndex = 2
	For $i = 1 To $lHeroCount
		If $lIndex <= $lPartySize Then
			$lReturnArray[$lIndex] = Party_GetMyPartyHeroInfo($i, "AgentID")
			$lIndex += 1
		EndIf
	Next

	; Add henchmen/other party members
	For $i = 1 To Party_GetMyPartyInfo("HenchmanCount")
		If $lIndex <= $lPartySize Then
			$lReturnArray[$lIndex] = Party_GetMyPartyHenchmanInfo($i, "AgentID")
			$lIndex += 1
		EndIf
	Next

	Return $lReturnArray
EndFunc

; Get average party health percentage
Func Party_GetAverageHealth()
	Local $lTotalHP = 0
	Local $lAliveCount = 0
	Local $lPartyArray = Party_GetMembersArray()

	For $i = 1 To $lPartyArray[0]
		If Not Agent_GetAgentInfo($lPartyArray[$i], "IsDead") Then
			$lTotalHP += Agent_GetAgentInfo($lPartyArray[$i], "HPPercent")
			$lAliveCount += 1
		EndIf
	Next

	If $lAliveCount = 0 Then Return 0
	Return Round($lTotalHP / $lAliveCount, 3)
EndFunc

; Check if party is wiped
Func Party_IsWiped()
	If Not Agent_GetAgentInfo(-2, "IsDead") Then Return False

	Local $lDeadHeroes = 0
	For $i = 1 To Party_GetHeroCount()
		If Agent_GetAgentInfo(Party_GetHeroID($i), "IsDead") Then
			$lDeadHeroes += 1
		EndIf
	Next

	If GetAvailableRezz() = 0 Or $lDeadHeroes >= UBound(Party_GetMembersArray()) - 2 Or Party_GetAverageHealth() < 0.15 Then
		Return True
	EndIf

	Return False
EndFunc

#EndRegion === Party Functions ===

#Region === Agent Effect Functions ===

; Get all effects on an agent
Func Agent_GetEffectsArray($aAgentID = -2)
	Local $lEffectArray = Agent_GetAgentEffectArrayInfo($aAgentID, "EffectArray")
	Local $lEffectCount = Agent_GetAgentEffectArrayInfo($aAgentID, "EffectArraySize")

	Local $lEmptyArray[1] = [0]
	If $lEffectArray = 0 Or $lEffectCount = 0 Then Return $lEmptyArray

	Local $lEffects[$lEffectCount + 1]
	$lEffects[0] = $lEffectCount

	For $i = 0 To $lEffectCount - 1
		$lEffects[$i + 1] = DllStructCreate('long SkillId;long AttributeLevel;long EffectId;long CasterId;float Duration;long TimeStamp')
		DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $lEffectArray + ($i * 0x18), 'ptr', DllStructGetPtr($lEffects[$i + 1]), 'int', 24, 'int', '')
	Next

	Return $lEffects
EndFunc

; Get all buffs on an agent
Func Agent_GetBuffsArray($aAgentID = -2)
	Local $lBuffArray = Agent_GetAgentEffectArrayInfo($aAgentID, "BuffArray")
	Local $lBuffCount = Agent_GetAgentEffectArrayInfo($aAgentID, "BuffArraySize")

	Local $lEmptyArray[1] = [0]
	If $lBuffArray = 0 Or $lBuffCount = 0 Then Return $lEmptyArray

	Local $lBuffs[$lBuffCount + 1]
	$lBuffs[0] = $lBuffCount

	For $i = 0 To $lBuffCount - 1
		$lBuffs[$i + 1] = DllStructCreate('long SkillId;long h0004;long BuffId;long TargetAgentId')
		DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $lBuffArray + ($i * 0x10), 'ptr', DllStructGetPtr($lBuffs[$i + 1]), 'int', 16, 'int', '')
	Next

	Return $lBuffs
EndFunc
#EndRegion === Agent Effect Functions ===