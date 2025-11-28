#include-once

#Region Set and Mods
Func UAI_DeterminateWeaponSets()
	For $l_i_Set = 1 To 4
		UAI_ChangeWeaponSetAndSave($l_i_Set)
	Next

	Out("High Hp: " & $g_ai_High_Hp_Set[0] & " - Set: " & $g_ai_High_Hp_Set[1])
	Out("High Energy set: " & $g_ai_High_Energy_Set[0] & " - Set: " & $g_ai_High_Energy_Set[1])

	For $l_i_Set = 0 To 3
		Local $l_i_SetNum = $l_i_Set + 1
		Local $l_i_WeaponType = $g_a2D_WeaponSets[$l_i_Set][$GC_UAI_WEAPONSET_WeaponType]
		Local $l_i_OffhandType = $g_a2D_WeaponSets[$l_i_Set][$GC_UAI_WEAPONSET_OffhandType]

		;Shield and high hp = defensive set
		If $l_i_OffhandType = 24 And $g_ai_High_Hp_Set[1] = $l_i_SetNum Then Out("Set " & $l_i_SetNum & " is probably defensif set")
		;Staff or wand (type > 7) and high energy
		If $l_i_WeaponType > 7 And $g_ai_High_Energy_Set[1] = $l_i_SetNum Then Out("Set " & $l_i_SetNum & " is probably staff high energy set")
		;Wand and focus = 40/40 set
		If $l_i_WeaponType > 7 And $l_i_OffhandType = 12 Then Out("Set " & $l_i_SetNum & " is probably 40/40 set")
	Next
EndFunc

Func UAI_FindWeaponSet4040()
	Local $l_i_MainItem = UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemId)
	Local $l_i_SecondItem = UAI_GetPlayerInfo($GC_UAI_AGENT_OffhandItemId)
	Local $l_s_MainModStruct = Item_GetModStruct($l_i_MainItem)
	Local $l_s_SecondModStruct = Item_GetModStruct($l_i_SecondItem)

	;Check if already equipped 40/40
	If StringInStr($l_s_MainModStruct, "00142828") > 0 And StringInStr($l_s_MainModStruct, "22500140828") > 0 And StringInStr($l_s_SecondModStruct, "02500140828") > 0 And StringInStr($l_s_SecondModStruct, "00142828") > 0 Then
		Return 5 ;I already have the 40/40, don't switch
	EndIf

	;Search for 40/40 in weapon sets
	For $l_i_Set = 1 To 4
		If UAI_CheckInWeaponSet($l_i_Set, 1, "Wand Wrapping of Quickening") And UAI_CheckInWeaponSet($l_i_Set, 1, "Aptitude not Attitude") And UAI_CheckInWeaponSet($l_i_Set, 2, "Focus Core of Swiftness") And UAI_CheckInWeaponSet($l_i_Set, 2, "Forget Me Not") Then Return $l_i_Set
	Next

	Return 0 ;Don't find the 40/40, don't switch
EndFunc

Func UAI_FindWeaponSet402020()
	Local $l_i_MainItem = UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemId)
	Local $l_s_MainModStruct = Item_GetModStruct($l_i_MainItem)
	If StringInStr($l_s_MainModStruct, "1400B822") > 0 And StringInStr($l_s_MainModStruct, "22500140828") > 0 And StringInStr($l_s_MainModStruct, "02500140828") > 0 Then
		Return 5 ;I already have the 40/20/20, don't switch
	Else
		For $l_i_i = 1 To 4
			If UAI_CheckInWeaponSet($l_i_i, 1, "Staff Head Adept") And UAI_CheckInWeaponSet($l_i_i, 1, "Aptitude not Attitude") And UAI_CheckInWeaponSet($l_i_i, 1, "Staff Wrapping of Enchanting") Then Return $l_i_i
		Next
	EndIf
	Return 0 ;Don't find the 40/20/20, don't switch
EndFunc

Func UAI_FindWeaponSetEnchant20()
	Local $l_i_MainItem = UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemId)
	Local $l_s_MainModStruct = Item_GetModStruct($l_i_MainItem)
	If StringInStr($l_s_MainModStruct, "1400B822") > 0 Then
		Return 5 ;already have the +20% enchant
	Else
		For $l_i_i = 1 To 4
			If UAI_CheckInWeaponSet($l_i_i, 1, "Axe Grip of Enchanting") Or UAI_CheckInWeaponSet($l_i_i, 1, "Hammer Haft of Enchanting") Or UAI_CheckInWeaponSet($l_i_i, 1, "Sword Pommel of Enchanting") Then Return $l_i_i
			If UAI_CheckInWeaponSet($l_i_i, 1, "Dagger Handle of Enchanting") Or UAI_CheckInWeaponSet($l_i_i, 1, "Scythe Grip of Enchanting") Or UAI_CheckInWeaponSet($l_i_i, 1, "Bow Grip of Enchanting") Then Return $l_i_i
			If UAI_CheckInWeaponSet($l_i_i, 1, "Spear Grip of Enchanting") Or UAI_CheckInWeaponSet($l_i_i, 1, "Staff Wrapping of Enchanting") Then Return $l_i_i
		Next
	EndIf
	Return 0 ;Don't find the +20% enchant
EndFunc

Func UAI_FindWeaponSetByType($a_i_Type)
	If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) = $a_i_Type Then
		Return 5 ;already have the right weapon type
	Else
		For $l_i_Set = 0 To 3
			If $g_a2D_WeaponSets[$l_i_Set][$GC_UAI_WEAPONSET_WeaponType] = $a_i_Type Then Return $l_i_Set + 1
		Next
	EndIf
	Return 0 ;Don't find the weapon type in any set
EndFunc

Func UAI_CheckInWeaponSet($a_i_Set = 0, $a_i_Weapon = 0, $a_s_LookingFor = "")
	For $l_i_i = 0 To 7
		If $g_as3_Weapon_Mods[$a_i_Set-1][$a_i_Weapon-1][$l_i_i] = $a_s_LookingFor Then Return True
	Next
	Return False
EndFunc

Func UAI_CheckInAllWeaponSets($a_s_LookingFor = "")
	For $l_i_Y = 0 To 3
		For $l_i_J = 0 To 1
			For $l_i_i = 0 To 7
				If $g_as3_Weapon_Mods[$l_i_Y][$l_i_J][$l_i_i] = $a_s_LookingFor Then
					Out("Find at: " & "[" & $l_i_Y & "]" & "[" & $l_i_J & "]" & "[" & $l_i_i & "]")
					Out("Set: " & $l_i_Y+1 & ", Weapon: " & $l_i_J+1 & ", Mod: " & $l_i_i)
				EndIf
			Next
		Next
	Next
EndFunc

Func UAI_GetBestWeaponSetBySkillSlot($a_i_SkillSlot)
	Switch UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillType)
		Case $GC_I_SKILL_TYPE_HEX, $GC_I_SKILL_TYPE_SPELL, $GC_I_SKILL_TYPE_SIGNET, $GC_I_SKILL_TYPE_CONDITION, $GC_I_SKILL_TYPE_WELL, $GC_I_SKILL_TYPE_WARD, $GC_I_SKILL_TYPE_ITEM_SPELL, $GC_I_SKILL_TYPE_WEAPON_SPELL ;Hex, Spell => 40/40
			If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) < 0.25 Then
				If UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP) <> $g_ai_High_Hp_Set[0] Then
					UAI_ChangeWeaponSet($g_ai_High_Hp_Set[1])
					Return
				EndIf
				Return
			EndIf
			If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) < UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_EnergyCost) Then
				If UAI_GetPlayerInfo($GC_UAI_AGENT_MaxEnergy) <> $g_ai_High_Energy_Set[0] Then
					UAI_ChangeWeaponSet($g_ai_High_Energy_Set[1])
					Return
				EndIf
				Return
			EndIf
			If UAI_FindWeaponSet4040() = 5 Or UAI_FindWeaponSet4040() = 0 Then Return
			If UAI_FindWeaponSet4040() <> 5 And UAI_FindWeaponSet4040() <> 0 Then UAI_ChangeWeaponSet(UAI_FindWeaponSet4040())
		Case $GC_I_SKILL_TYPE_ENCHANTMENT ; Enchantment Spell => Enchant 20% or 20/20/20
			If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) < 0.25 Then
				If UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP) <> $g_ai_High_Hp_Set[0] Then
					UAI_ChangeWeaponSet($g_ai_High_Hp_Set[1])
					Return
				EndIf
				Return
			EndIf
			If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) < UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_EnergyCost) Then
				If UAI_GetPlayerInfo($GC_UAI_AGENT_MaxEnergy) <> $g_ai_High_Energy_Set[0] Then
					UAI_ChangeWeaponSet($g_ai_High_Energy_Set[1])
					Return
				EndIf
				Return
			EndIf
			If UAI_FindWeaponSet402020() = 5 Then Return
			If UAI_FindWeaponSet402020() <> 5 And UAI_FindWeaponSet402020() <> 0 Then UAI_ChangeWeaponSet(UAI_FindWeaponSet402020())
			If UAI_FindWeaponSet402020() = 0 Then
				If UAI_FindWeaponSetEnchant20() = 5 Then Return
				If UAI_FindWeaponSetEnchant20() <> 0 And UAI_FindWeaponSetEnchant20() <> 5 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetEnchant20())
			EndIf
		Case $GC_I_SKILL_TYPE_ATTACK ;attack => switch weapon type
			Switch UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_WeaponReq)
				Case 1 ; all Axe Attacks
					If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) <> 2 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetByType(2))
				Case 2 ; all Bow Attacks
					If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) <> 1 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetByType(1))
				Case 8 ; all Dagger Attacks
					If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) <> 4 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetByType(4))
				Case 16 ; all Hammer Attacks
					If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) <> 3 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetByType(3))
				Case 32 ; all Scythe Attacks
					If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) <> 5 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetByType(5))
				Case 64 ; all Spear Attacks
					If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) <> 6 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetByType(6))
				;Case 70 ; Ranged Attack non Weapon Requirement
				Case 128 ; all Sword Attacks
					If UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType) <> 7 Then UAI_ChangeWeaponSet(UAI_FindWeaponSetByType(7))
				;Case 185 ; all Melee Attack non Weapon Requirement
			EndSwitch
		;Case $Stance, $Shout, $Preparation, 20, $Trap, $Ritual, $Chant, $EchoRefrain;Item's attri +1
		;Case Else ;12 Glyph, 26Form, 29disguise
	EndSwitch
EndFunc   ;==>GetBestWeaponSetBySkillSlot

Func UAI_ChangeWeaponSet($a_i_Set)
	Local $l_i_PrimarySet, $l_i_SecondarySet, $l_i_MyHp, $l_i_MyEnergy
	Local $l_i_OldMyHp = Agent_GetAgentInfo(-2, "MaxHP")
	Local $l_i_OldMyEnergy = Agent_GetAgentInfo(-2, "MaxEnergy")
	Local $l_i_OldPrimarySet = Agent_GetAgentInfo(-2, "WeaponItemType")
	Local $l_i_OldSecondarySet = Agent_GetAgentInfo(-2, "OffhandItemType")

	Local $l_i_Deadlock = TimerInit()

	Local $l_i_SetToUse = 0
	Switch $a_i_Set
		Case 1
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_1
		Case 2
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_2
		Case 3
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_3
		Case 4
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_4
	EndSwitch

	Do
		Core_PerformAction($GC_I_CONTROL_ACTION_CANCEL_ACTION, $GC_I_CONTROL_TYPE_ACTIVATE)
		Sleep(50)
		Core_PerformAction($l_i_SetToUse, $GC_I_CONTROL_TYPE_ACTIVATE)
		Sleep(100)
		$l_i_PrimarySet = Agent_GetAgentInfo(-2, "WeaponItemType")
		$l_i_SecondarySet = Agent_GetAgentInfo(-2, "OffhandItemType")
		$l_i_MyHp = Agent_GetAgentInfo(-2, "MaxHP")
		$l_i_MyEnergy = Agent_GetAgentInfo(-2, "MaxEnergy")
	Until $l_i_OldPrimarySet <> $l_i_PrimarySet Or $l_i_OldSecondarySet <> $l_i_SecondarySet Or TimerDiff($l_i_Deadlock) > 5000 Or $l_i_OldMyHp <> $l_i_MyHp Or $l_i_OldMyEnergy <> $l_i_MyEnergy
EndFunc

Func UAI_ChangeWeaponSetAndSave($a_i_Set)
	Local $l_i_PrimarySet, $l_i_SecondarySet, $l_i_MyHp, $l_i_MyEnergy
	Local $l_i_OldMyHp = Agent_GetAgentInfo(-2, "MaxHP")
	Local $l_i_OldMyEnergy = Agent_GetAgentInfo(-2, "MaxEnergy")
	Local $l_i_OldPrimarySet = Agent_GetAgentInfo(-2, "WeaponItemType")
	Local $l_i_OldSecondarySet = Agent_GetAgentInfo(-2, "OffhandItemType")

	Local $l_i_Deadlock = TimerInit()

	Local $l_i_SetToUse = 0
	Switch $a_i_Set
		Case 1
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_1
		Case 2
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_2
		Case 3
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_3
		Case 4
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_4
	EndSwitch

	Do
		Core_PerformAction($l_i_SetToUse, $GC_I_CONTROL_TYPE_ACTIVATE)
		Sleep(100)
		$l_i_PrimarySet = Agent_GetAgentInfo(-2, "WeaponItemType")
		$l_i_SecondarySet = Agent_GetAgentInfo(-2, "OffhandItemType")
		$l_i_MyHp = Agent_GetAgentInfo(-2, "MaxHP")
		$l_i_MyEnergy = Agent_GetAgentInfo(-2, "MaxEnergy")
	Until $l_i_OldPrimarySet <> $l_i_PrimarySet Or $l_i_OldSecondarySet <> $l_i_SecondarySet Or TimerDiff($l_i_Deadlock) > 5000 Or $l_i_OldMyHp <> $l_i_MyHp Or $l_i_OldMyEnergy <> $l_i_MyEnergy

	If TimerDiff($l_i_Deadlock) > 5000 Then
		Out("Same WeaponSet?")
		UAI_SaveWeaponSet($a_i_Set)
		Return True
	EndIf

	UAI_SaveWeaponSet($a_i_Set)
	Return True
EndFunc

Func UAI_SaveWeaponSet($a_i_Set)
	If $a_i_Set < 1 Or $a_i_Set > 4 Then Return

	Local $l_i_Index = $a_i_Set - 1

	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_WeaponType] = Agent_GetAgentInfo(-2, "WeaponItemType")
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_WeaponId] = Agent_GetAgentInfo(-2, "WeaponItemId")
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffhandType] = Agent_GetAgentInfo(-2, "OffhandItemType")
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffhandId] = Agent_GetAgentInfo(-2, "OffhandItemId")
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxHP] = Agent_GetAgentInfo(-2, "MaxHP")
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxEnergy] = Agent_GetAgentInfo(-2, "MaxEnergy")

	Out("Set " & $a_i_Set & ": " & $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_WeaponType] & ", " & $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffhandType])

	UAI_FindAndSaveMod($g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_WeaponId], $a_i_Set, 1)
	UAI_FindAndSaveMod($g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffhandId], $a_i_Set, 2)

	If $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxHP] > $g_ai_High_Hp_Set[0] Then
		$g_ai_High_Hp_Set[0] = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxHP]
		$g_ai_High_Hp_Set[1] = $a_i_Set
	EndIf
	If $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxEnergy] > $g_ai_High_Energy_Set[0] Then
		$g_ai_High_Energy_Set[0] = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxEnergy]
		$g_ai_High_Energy_Set[1] = $a_i_Set
	EndIf
EndFunc

;Helper function to search mods in an upgrade array
Func UAI_SearchModsInArray(ByRef $a_as2_UpgradeArray, ByRef $a_s_ModStruct, ByRef $a_s_NewModStruct, ByRef $a_i_Finding, $a_i_Set, $a_i_Weapon)
	For $l_i_i = 0 To UBound($a_as2_UpgradeArray) - 1
		Local $l_s_SearchIn = ($a_i_Finding = 0) ? $a_s_ModStruct : $a_s_NewModStruct
		If StringInStr($l_s_SearchIn, $a_as2_UpgradeArray[$l_i_i][2]) > 0 Then
			$g_as3_Weapon_Mods[$a_i_Set - 1][$a_i_Weapon - 1][$a_i_Finding] = $a_as2_UpgradeArray[$l_i_i][0]
			If $a_i_Finding = 0 Then
				$a_s_NewModStruct = StringReplace($a_s_ModStruct, $a_as2_UpgradeArray[$l_i_i][2], "")
			Else
				$a_s_NewModStruct = StringReplace($a_s_NewModStruct, $a_as2_UpgradeArray[$l_i_i][2], "")
			EndIf
			Out($a_as2_UpgradeArray[$l_i_i][0])
			Out($a_as2_UpgradeArray[$l_i_i][1])
			$a_i_Finding += 1
		EndIf
	Next
EndFunc

Func UAI_FindAndSaveMod($a_i_Item, $a_i_Set = 0, $a_i_Weapon = 0) ;set 1,2,3,4 / Weapon 1,2
	Local $l_i_Finding = 0
	Local $l_s_ModStruct = Item_GetModStruct($a_i_Item)
	Local $l_s_NewModStruct = ""

	If $a_i_Weapon = 1 Then
		Switch Agent_GetAgentInfo(-2, "WeaponItemType")
			Case 1 ; Bow
				UAI_SearchModsInArray($g_as2_BowUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 2 ; Axe
				UAI_SearchModsInArray($g_as2_AxeUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 3 ; Hammer
				UAI_SearchModsInArray($g_as2_HammerUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 4 ; Daggers
				UAI_SearchModsInArray($g_as2_DaggerUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 5 ; Scythe
				UAI_SearchModsInArray($g_as2_ScytheUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 6 ; Spear
				UAI_SearchModsInArray($g_as2_SpearUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 7 ; Sword
				UAI_SearchModsInArray($g_as2_SwordUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 8, 9, 10, 11, 12, 13, 14 ; Staff/Wand (Chaos, Cold, Dark, Earth, Lightning, Fire, Holy)
				UAI_SearchModsInArray($g_as2_StaffWandUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_SpellCastingWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
		EndSwitch
	ElseIf $a_i_Weapon = 2 Then
		Switch Agent_GetAgentInfo(-2, "OffhandItemType")
			Case 12 ; Focus
				UAI_SearchModsInArray($g_as2_FocusUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_FocusShieldWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 24 ; Shield
				UAI_SearchModsInArray($g_as2_ShieldUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_FocusShieldWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 48 ; Nothing (empty slot)
		EndSwitch
	EndIf
EndFunc
#EndRegion Set and Mods