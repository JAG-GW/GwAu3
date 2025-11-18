#include-once

#Region Filter
Func Filter_IsLivingEnemy($aAgentID)
	If Agent_GetAgentInfo($aAgentID, 'Allegiance') <> 3 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'HP') <= 0 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'IsDead') Then Return False
	Return True
EndFunc

Func Filter_IsDeadEnemy($aAgentID)
	If Agent_GetAgentInfo($aAgentID, 'Allegiance') <> 3 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'HP') > 0 Then Return False
	If Not Agent_GetAgentInfo($aAgentID, 'IsDead') Then Return False
	Return True
EndFunc

Func Filter_IsLivingAlly($aAgentID)
	If Agent_GetAgentInfo($aAgentID, 'Allegiance') <> 1 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'HP') <= 0 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'IsDead') Then Return False
	Return True
EndFunc

Func Filter_IsDeadAlly($aAgentID)
	If Agent_GetAgentInfo($aAgentID, 'Allegiance') <> 1 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'HP') > 0 Then Return False
	If Not Agent_GetAgentInfo($aAgentID, 'IsDead') Then Return False
	Return True
EndFunc

Func Filter_ExcludeMe($aAgentID)
	If $aAgentID = Agent_GetMyID() Then Return False
	Return True
EndFunc

Func Filter_IsDiseased($aAgentID)
	Return Agent_HasVisibleEffect($aAgentID, 26) ;Disease
EndFunc

Func Filter_IsDazed($aAgentID)
	Return Agent_HasVisibleEffect($aAgentID, 28) ;Dazed
EndFunc

Func Filter_IsWeakness($aAgentID)
	Return Agent_HasVisibleEffect($aAgentID, 29) ;Weakness / Cracked Armor
EndFunc

Func Filter_IsPoisoned($aAgentID)
	Return Agent_HasVisibleEffect($aAgentID, 27) ;Poison
EndFunc

Func Filter_IsBlind($aAgentID)
	Return Agent_HasVisibleEffect($aAgentID, 24) ;Blind
EndFunc

Func Filter_IsBurning($aAgentID)
	Return Agent_HasVisibleEffect($aAgentID, 25) ;Burning
EndFunc

Func Filter_IsBleeding($aAgentID)
	Return Agent_HasVisibleEffect($aAgentID, 23) ;Bleeding
EndFunc

Func Filter_IsEnchanted($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsEnchanted")
EndFunc

Func Filter_IsConditioned($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsConditioned")
EndFunc

Func Filter_IsCrippled($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsCrippled")
EndFunc

Func Filter_IsDeepWounded($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsDeepWounded")
EndFunc

Func Filter_IsDegenHexed($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsDegenHexed")
EndFunc

Func Filter_IsHexed($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsHexed")
EndFunc

Func Filter_IsWeaponSpelled($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsWeaponSpelled")
EndFunc

Func Filter_IsKnocked($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsKnocked")
EndFunc

Func Filter_IsMoving($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsMoving")
EndFunc

Func Filter_IsAttacking($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsAttacking")
EndFunc

Func Filter_IsCasting($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsCasting")
EndFunc

Func Filter_IsIdle($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, "IsIdle")
EndFunc

Func Filter_IsSpirit($aAgentID)
	If Agent_GetAgentInfo($aAgentID, 'Allegiance') <> 4 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'LoginNumber') <> 0 Then Return False

	Local $lNpcIndex = Agent_GetAgentInfo($aAgentID, 'PlayerNumber')
	Local $lTransmogID = Agent_GetAgentInfo($aAgentID, 'TransmogNpcId')

	If BitAND($lTransmogID, 0x20000000) <> 0 Then
		$lNpcIndex = BitXOR($lTransmogID, 0x20000000)
	EndIf

	If $lNpcIndex = 0 Then Return False

	Local $lNpcArray = World_GetWorldInfo("NpcArray")
	Local $lNpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $lNpcIndex >= $lNpcArraySize Then Return False

	Local $lNpcPtr = $lNpcArray + ($lNpcIndex * 0x30)
	Local $lNpcFlags = Memory_Read($lNpcPtr + 0x10, "dword")

	If BitAND($lNpcFlags, 0x4000) = 0 Then Return False

	Return True
EndFunc

Func Filter_IsControlledSpirit($aAgentID)
	If Not Filter_IsSpirit($aAgentID) Then Return False

	Local $lOthersPtr = Party_GetMyPartyInfo("ArrayOthersPartyMember")
	Local $lOthersSize = Party_GetMyPartyInfo("ArrayOthersPartyMemberSize")

	If $lOthersPtr = 0 Or $lOthersSize = 0 Then Return False

	Local $lAgentID = Agent_GetAgentInfo($aAgentID, "ID")

	For $i = 0 To $lOthersSize - 1
		Local $lControlledID = Memory_Read($lOthersPtr + ($i * 0x4), "dword")
		If $lControlledID = $lAgentID Then Return True
	Next

	Return False
EndFunc

Func Filter_IsMinion($aAgentID)
	If Agent_GetAgentInfo($aAgentID, 'Allegiance') <> 5 Then Return False
	If Agent_GetAgentInfo($aAgentID, 'LoginNumber') <> 0 Then Return False

	Local $lNpcIndex = Agent_GetAgentInfo($aAgentID, 'PlayerNumber')
	Local $lTransmogID = Agent_GetAgentInfo($aAgentID, 'TransmogNpcId')

	If BitAND($lTransmogID, 0x20000000) <> 0 Then
		$lNpcIndex = BitXOR($lTransmogID, 0x20000000)
	EndIf

	If $lNpcIndex = 0 Then Return False

	Local $lNpcArray = World_GetWorldInfo("NpcArray")
	Local $lNpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $lNpcIndex >= $lNpcArraySize Then Return False

	Local $lNpcPtr = $lNpcArray + ($lNpcIndex * 0x30)
	Local $lNpcFlags = Memory_Read($lNpcPtr + 0x10, "dword")

	If BitAND($lNpcFlags, 0x100) = 0 Then Return False

	Return True
EndFunc

Func Filter_IsControlledMinion($aAgentID)
	If Not Filter_IsMinion($aAgentID) Then Return False

	Local $lOthersPtr = Party_GetMyPartyInfo("ArrayOthersPartyMember")
	Local $lOthersSize = Party_GetMyPartyInfo("ArrayOthersPartyMemberSize")

	If $lOthersPtr = 0 Or $lOthersSize = 0 Then Return False

	Local $lAgentID = Agent_GetAgentInfo($aAgentID, "ID")

	For $i = 0 To $lOthersSize - 1
		Local $lControlledID = Memory_Read($lOthersPtr + ($i * 0x4), "dword")
		If $lControlledID = $lAgentID Then Return True
	Next

	Return False
EndFunc

Func Filter_IsBelow50HP($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, 'HP') < 0.5
EndFunc

Func Filter_IsBelow25HP($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, 'HP') < 0.25
EndFunc

Func Filter_IsAbove50HP($aAgentID)
	Return Agent_GetAgentInfo($aAgentID, 'HP') > 0.5
EndFunc
#EndRegion

#Region GetAgents
Func Count_NumberOf($aAgentID = -2, $aRange = 1320, $aFilter = "")
	Return GetAgents($aAgentID, $aRange, $GC_I_AGENT_TYPE_LIVING, 0, $aFilter)
EndFunc

Func Nearest_Agent($aAgentID = -2, $aRange = 1320, $aFilter = "")
	Return GetAgents($aAgentID, $aRange, $GC_I_AGENT_TYPE_LIVING, 1, $aFilter)
EndFunc

Func Farthest_Agent($aAgentID = -2, $aRange = 1320, $aFilter = "")
	Return GetAgents($aAgentID, $aRange, $GC_I_AGENT_TYPE_LIVING, 2, $aFilter)
EndFunc
#EndRegion GetAgents

#Region BestTarget
; Get agent with lowest property value (HP, Energy, etc.)
Func GetAgentsLowest($aAgentID = -2, $aRange = 1320, $aProperty = "HP", $aCustomFilter = "")
	Local $lLowestValue = 999999
	Local $lLowestAgent = 0

	; Get reference coordinates
	Local $lRefID = Agent_ConvertID($aAgentID)
	Local $lRefX = Agent_GetAgentInfo($aAgentID, "X")
	Local $lRefY = Agent_GetAgentInfo($aAgentID, "Y")

	; Get agent array
	Local $lAgentArray = Agent_GetAgentArray(0xDB)

	If Not IsArray($lAgentArray) Or $lAgentArray[0] = 0 Then Return 0

	; Process each agent
	For $i = 1 To $lAgentArray[0]
		Local $lAgentPtr = $lAgentArray[$i]
		Local $lAgentID = Agent_GetAgentInfo($lAgentPtr, "ID")

		; Ignore reference agent
		If $lAgentID = $lRefID Then ContinueLoop

		; Calculate distance
		Local $lAgentX = Agent_GetAgentInfo($lAgentPtr, "X")
		Local $lAgentY = Agent_GetAgentInfo($lAgentPtr, "Y")
		Local $lDistance = Sqrt(($lAgentX - $lRefX) ^ 2 + ($lAgentY - $lRefY) ^ 2)

		; Check range
		If $lDistance > $aRange Then ContinueLoop

		; Apply custom filters (supports multiple filters separated by |)
		If Not _ApplyFilters($lAgentPtr, $aCustomFilter) Then ContinueLoop

		; Get property value
		Local $lValue = Agent_GetAgentInfo($lAgentPtr, $aProperty)

		; Update lowest
		If $lValue < $lLowestValue Then
			$lLowestValue = $lValue
			$lLowestAgent = $lAgentPtr
		EndIf
	Next

	Return $lLowestAgent
EndFunc

; Get agent with highest property value
Func GetAgentsHighest($aAgentID = -2, $aRange = 1320, $aProperty = "HP", $aCustomFilter = "")
	Local $lHighestValue = -1
	Local $lHighestAgent = 0

	; Get reference coordinates
	Local $lRefID = Agent_ConvertID($aAgentID)
	Local $lRefX = Agent_GetAgentInfo($aAgentID, "X")
	Local $lRefY = Agent_GetAgentInfo($aAgentID, "Y")

	; Get agent array
	Local $lAgentArray = Agent_GetAgentArray(0xDB)

	If Not IsArray($lAgentArray) Or $lAgentArray[0] = 0 Then Return 0

	; Process each agent
	For $i = 1 To $lAgentArray[0]
		Local $lAgentPtr = $lAgentArray[$i]
		Local $lAgentID = Agent_GetAgentInfo($lAgentPtr, "ID")

		; Ignore reference agent
		If $lAgentID = $lRefID Then ContinueLoop

		; Calculate distance
		Local $lAgentX = Agent_GetAgentInfo($lAgentPtr, "X")
		Local $lAgentY = Agent_GetAgentInfo($lAgentPtr, "Y")
		Local $lDistance = Sqrt(($lAgentX - $lRefX) ^ 2 + ($lAgentY - $lRefY) ^ 2)

		; Check range
		If $lDistance > $aRange Then ContinueLoop

		; Apply custom filters (supports multiple filters separated by |)
		If Not _ApplyFilters($lAgentPtr, $aCustomFilter) Then ContinueLoop

		; Get property value
		Local $lValue = Agent_GetAgentInfo($lAgentPtr, $aProperty)

		; Update highest
		If $lValue > $lHighestValue Then
			$lHighestValue = $lValue
			$lHighestAgent = $lAgentPtr
		EndIf
	Next

	Return $lHighestAgent
EndFunc

; Get agent that maximizes enemy density around it (best AOE target)
Func GetAgentsBestAOE($aAgentID = -2, $aRange = 1320, $aAOERange = $GC_I_RANGE_ADJACENT, $aCustomFilter = "")
	Local $lBestAgent = 0
	Local $lMaxDensity = 0

	; Get reference coordinates
	Local $lRefID = Agent_ConvertID($aAgentID)
	Local $lRefX = Agent_GetAgentInfo($aAgentID, "X")
	Local $lRefY = Agent_GetAgentInfo($aAgentID, "Y")

	; Get agent array
	Local $lAgentArray = Agent_GetAgentArray(0xDB)

	If Not IsArray($lAgentArray) Or $lAgentArray[0] = 0 Then Return 0

	; Process each agent
	For $i = 1 To $lAgentArray[0]
		Local $lAgentPtr = $lAgentArray[$i]
		Local $lAgentID = Agent_GetAgentInfo($lAgentPtr, "ID")

		; Ignore reference agent
		If $lAgentID = $lRefID Then ContinueLoop

		; Calculate distance to reference
		Local $lAgentX = Agent_GetAgentInfo($lAgentPtr, "X")
		Local $lAgentY = Agent_GetAgentInfo($lAgentPtr, "Y")
		Local $lDistance = Sqrt(($lAgentX - $lRefX) ^ 2 + ($lAgentY - $lRefY) ^ 2)

		; Check range from reference
		If $lDistance > $aRange Then ContinueLoop

		; Apply custom filters (supports multiple filters separated by |)
		If Not _ApplyFilters($lAgentPtr, $aCustomFilter) Then ContinueLoop

		; Count enemies in AOE range around this agent
		Local $lDensity = Count_LivingEnemies($lAgentID, $aAOERange)

		; Update best
		If $lDensity > $lMaxDensity Then
			$lMaxDensity = $lDensity
			$lBestAgent = $lAgentPtr
		EndIf
	Next

	Return $lBestAgent
EndFunc
#EndRegion