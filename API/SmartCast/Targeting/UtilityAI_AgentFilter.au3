#include-once

#Region Filter
Func UAI_Filter_IsGadget($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsItemType) Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsLivingType) Then Return False
	Return True
EndFunc

Func UAI_Filter_IsGadgetOrLiving($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsItemType) Then Return False
	Return True
EndFunc

Func UAI_Filter_IsLivingEnemy($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Allegiance) <> 3 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP) <= 0 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsDead) Then Return False
	Return True
EndFunc

Func UAI_Filter_IsDeadEnemy($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Allegiance) <> 3 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP) > 0 Then Return False
	If Not UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsDead) Then Return False
	Return True
EndFunc

Func UAI_Filter_IsLivingAlly($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Allegiance) <> 1 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP) <= 0 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsDead) Then Return False
	Return True
EndFunc

Func UAI_Filter_IsDeadAlly($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Allegiance) <> 1 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP) > 0 Then Return False
	If Not UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsDead) Then Return False
	Return True
EndFunc

Func UAI_Filter_IsBoss($a_i_AgentID)
	If Not UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HasBossGlow) Then Return False
	Return True
EndFunc

Func UAI_Filter_ExcludeMe($a_i_AgentID)
	If $a_i_AgentID = UAI_GetPlayerInfo($GC_UAI_AGENT_ID) Then Return False
	Return True
EndFunc

Func UAI_Filter_IsDiseased($a_i_AgentID)
	Return UAI_AgentHasVisibleEffect($a_i_AgentID, 26) ;Disease
EndFunc

Func UAI_Filter_IsDazed($a_i_AgentID)
	Return UAI_AgentHasVisibleEffect($a_i_AgentID, 28) ;Dazed
EndFunc

Func UAI_Filter_IsWeakness($a_i_AgentID)
	Return UAI_AgentHasVisibleEffect($a_i_AgentID, 29) ;Weakness / Cracked Armor
EndFunc

Func UAI_Filter_IsPoisoned($a_i_AgentID)
	Return UAI_AgentHasVisibleEffect($a_i_AgentID, 27) ;Poison
EndFunc

Func UAI_Filter_IsBlind($a_i_AgentID)
	Return UAI_AgentHasVisibleEffect($a_i_AgentID, 24) ;Blind
EndFunc

Func UAI_Filter_IsBurning($a_i_AgentID)
	Return UAI_AgentHasVisibleEffect($a_i_AgentID, 25) ;Burning
EndFunc

Func UAI_Filter_IsBleeding($a_i_AgentID)
	Return UAI_AgentHasVisibleEffect($a_i_AgentID, 23) ;Bleeding
EndFunc

Func UAI_Filter_IsEnchanted($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsEnchanted)
EndFunc

Func UAI_Filter_IsConditioned($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsConditioned)
EndFunc

Func UAI_Filter_IsCrippled($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsCrippled)
EndFunc

Func UAI_Filter_IsDeepWounded($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsDeepWounded)
EndFunc

Func UAI_Filter_IsDegenHexed($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsDegenHexed)
EndFunc

Func UAI_Filter_IsHexed($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsHexed)
EndFunc

Func UAI_Filter_IsHexedOrEnchanted($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsHexed) Or UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsEnchanted)
EndFunc

Func UAI_Filter_IdConditionedOrEnchanted($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsConditioned) Or UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsEnchanted)
EndFunc

Func UAI_Filter_IsHexedOrConditioned($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsHexed) Or UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsConditioned)
EndFunc

Func UAI_Filter_IsWeaponSpelled($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled)
EndFunc

Func UAI_Filter_IsKnocked($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsKnockedDown)
EndFunc

Func UAI_Filter_IsMoving($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsMoving)
EndFunc

Func UAI_Filter_IsAttacking($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsAttacking)
EndFunc

Func UAI_Filter_IsCasting($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsCasting)
EndFunc

Func UAI_Filter_IsIdle($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsIdle)
EndFunc

Func UAI_Filter_IsWarrior($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 1 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsRanger($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 2 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsMonk($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 3 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsNecromancer($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 4 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsMesmer($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 5 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsElementalist($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 6 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsAssassin($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 7 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsRitualist($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 8 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsParagon($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 9 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsDervish($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")

	If $l_i_NpcPrimary <> 10 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsSpirit($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Allegiance) <> 4 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcFlags = Memory_Read($l_p_NpcPtr + 0x10, "dword")

	If BitAND($l_i_NpcFlags, 0x4000) = 0 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsControlledSpirit($a_i_AgentID)
	If Not UAI_Filter_IsSpirit($a_i_AgentID) Then Return False

	Local $l_p_OthersPtr = Party_GetMyPartyInfo("ArrayOthersPartyMember")
	Local $l_i_OthersSize = Party_GetMyPartyInfo("ArrayOthersPartyMemberSize")

	If $l_p_OthersPtr = 0 Or $l_i_OthersSize = 0 Then Return False

	Local $l_i_AgentID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_ID)

	For $l_i_i = 0 To $l_i_OthersSize - 1
		Local $l_i_ControlledID = Memory_Read($l_p_OthersPtr + ($l_i_i * 0x4), "dword")
		If $l_i_ControlledID = $l_i_AgentID Then Return True
	Next

	Return False
EndFunc

Func UAI_Filter_IsMinion($a_i_AgentID)
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Allegiance) <> 5 Then Return False
	If UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber) <> 0 Then Return False

	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)

	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf

	If $l_i_NpcIndex = 0 Then Return False

	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return False

	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcFlags = Memory_Read($l_p_NpcPtr + 0x10, "dword")

	If BitAND($l_i_NpcFlags, 0x100) = 0 Then Return False

	Return True
EndFunc

Func UAI_Filter_IsControlledMinion($a_i_AgentID)
	If Not UAI_Filter_IsMinion($a_i_AgentID) Then Return False

	Local $l_p_OthersPtr = Party_GetMyPartyInfo("ArrayOthersPartyMember")
	Local $l_i_OthersSize = Party_GetMyPartyInfo("ArrayOthersPartyMemberSize")

	If $l_p_OthersPtr = 0 Or $l_i_OthersSize = 0 Then Return False

	Local $l_i_AgentID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_ID)

	For $l_i_i = 0 To $l_i_OthersSize - 1
		Local $l_i_ControlledID = Memory_Read($l_p_OthersPtr + ($l_i_i * 0x4), "dword")
		If $l_i_ControlledID = $l_i_AgentID Then Return True
	Next

	Return False
EndFunc

Func UAI_Filter_IsBelow50HP($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP) < 0.5
EndFunc

Func UAI_Filter_IsBelow25HP($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP) < 0.25
EndFunc

Func UAI_Filter_IsAbove50HP($a_i_AgentID)
	Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP) > 0.5
EndFunc

Func UAI_Filter_AgentHasMoreHpThanMe($a_i_AgentID)
	Return UAI_GetEstimatedCurrentHP($g_i_BestTarget) > UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP)
EndFunc

Func UAI_Filter_IsMelee($a_i_AgentID)
	Return UAI_IsMelee($a_i_AgentID)
EndFunc

Func UAI_Filter_IsCaster($a_i_AgentID)
	Return UAI_IsCaster($a_i_AgentID)
EndFunc

Func UAI_Filter_IsRanged($a_i_AgentID)
	Return UAI_IsRanged($a_i_AgentID)
EndFunc

; Negative filters (for pet attacks and other conditional skills)
Func UAI_Filter_IsNotPoisoned($a_i_AgentID)
	Return Not UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsPoisoned)
EndFunc

Func UAI_Filter_IsNotDeepWounded($a_i_AgentID)
	Return Not UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_IsDeepWounded)
EndFunc
#EndRegion
