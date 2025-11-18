#include-once

#Region Set and Mods
Func DeterminateWeaponsSet()
	ChangeSetAndSave(1)
	ChangeSetAndSave(2)
	ChangeSetAndSave(3)
	ChangeSetAndSave(4)
	Out("High Hp: " & $High_Hp_Set[0] & " - Set: " & $High_Hp_Set[1])
	Out("High Energy set: " & $High_Energy_Set[0] & " - Set: " & $High_Energy_Set[1])

	;shield and high hp
	If $lSet_1[2] = 24 And $High_Hp_Set[1] = 1 Then Out("Set 1 is probably defensif set")
	If $lSet_2[2] = 24 And $High_Hp_Set[1] = 2 Then Out("Set 2 is probably defensif set")
	If $lSet_3[2] = 24 And $High_Hp_Set[1] = 3 Then Out("Set 3 is probably defensif set")
	If $lSet_4[2] = 24 And $High_Hp_Set[1] = 4 Then Out("Set 4 is probably defensif set")
	;Staff or wand and high energy
	If $lSet_1[0] > $Sword And $High_Energy_Set[1] = 1 Then Out("Set 1 is probably staff high energy set")
	If $lSet_2[0] > $Sword And $High_Energy_Set[1] = 2 Then Out("Set 2 is probably staff high energy set")
	If $lSet_3[0] > $Sword And $High_Energy_Set[1] = 3 Then Out("Set 3 is probably staff high energy set")
	If $lSet_4[0] > $Sword And $High_Energy_Set[1] = 4 Then Out("Set 4 is probably staff high energy set")
	;wand and focus
	If $lSet_1[0] > $Sword And $lSet_1[2] = 12 Then Out("Set 1 is probably 40/40 set")
	If $lSet_2[0] > $Sword And $lSet_2[2] = 12 Then Out("Set 2 is probably 40/40 set")
	If $lSet_3[0] > $Sword And $lSet_3[2] = 12 Then Out("Set 3 is probably 40/40 set")
	If $lSet_4[0] > $Sword And $lSet_4[2] = 12 Then Out("Set 4 is probably 40/40 set")
EndFunc

Func FindSet4040()
	$aMainItem = GetAgentWeaponItemId_Ptr()
	$aSecondItem = GetAgentOffhandItemId_Ptr()
	$aMainModStruct = GetModStruct($aMainItem)
	$aSecondModStruct = GetModStruct($aSecondItem)
	If StringInStr($aMainModStruct, "00142828") > 0 And StringInStr($aMainModStruct, "22500140828") > 0 And StringInStr($aSecondModStruct, "02500140828") > 0 And StringInStr($aSecondModStruct, "00142828") > 0 Then
		Return 5 ;I already have the 40/40, don't switch
	Else
		If CheckInSet(1, 1, "Wand Wrapping of Quickening") And CheckInSet(1, 1, "Aptitude not Attitude") And CheckInSet(1, 2, "Focus Core of Swiftness") And CheckInSet(1, 2, "Forget Me Not") Then Return 1
		If CheckInSet(2, 1, "Wand Wrapping of Quickening") And CheckInSet(2, 1, "Aptitude not Attitude") And CheckInSet(2, 2, "Focus Core of Swiftness") And CheckInSet(2, 2, "Forget Me Not") Then Return 2
		If CheckInSet(3, 1, "Wand Wrapping of Quickening") And CheckInSet(3, 1, "Aptitude not Attitude") And CheckInSet(3, 2, "Focus Core of Swiftness") And CheckInSet(3, 2, "Forget Me Not") Then Return 3
		If CheckInSet(4, 1, "Wand Wrapping of Quickening") And CheckInSet(4, 1, "Aptitude not Attitude") And CheckInSet(4, 2, "Focus Core of Swiftness") And CheckInSet(4, 2, "Forget Me Not") Then Return 4
	EndIf
	Return 0 ;Don't find the 40/40, don't switch
EndFunc

Func FindSet402020()
	$aMainItem = GetAgentWeaponItemId_Ptr()
	$aMainModStruct = GetModStruct($aMainItem)
	If StringInStr($aMainModStruct, "1400B822") > 0 And StringInStr($aMainModStruct, "22500140828") > 0 And StringInStr($aMainModStruct, "02500140828") > 0 Then
		Return 5 ;I already have the 40/20/20, don't switch
	Else
		For $i = 1 To 4
			If CheckInSet($i, 1, "Staff Head Adept") And CheckInSet($i, 1, "Aptitude not Attitude") And CheckInSet($i, 1, "Staff Wrapping of Enchanting") Then Return $i
		Next
	EndIf
	Return 0 ;Don't find the 40/20/20, don't switch
EndFunc

Func FindSetEnchant20()
	$aMainItem = GetAgentWeaponItemId_Ptr()
	$aMainModStruct = GetModStruct($aMainItem)
	If StringInStr($aMainModStruct, "1400B822") > 0 Then
		Return 5 ;already have the +20% enchant
	Else
		For $i = 1 To 4
			If CheckInSet($i, 1, "Axe Grip of Enchanting") Or CheckInSet($i, 1, "Hammer Haft of Enchanting") Or CheckInSet($i, 1, "Sword Pommel of Enchanting") Then Return $i
			If CheckInSet($i, 1, "Dagger Handle of Enchanting") Or CheckInSet($i, 1, "Scythe Grip of Enchanting") Or CheckInSet($i, 1, "Bow Grip of Enchanting") Then Return $i
			If CheckInSet($i, 1, "Spear Grip of Enchanting") Or CheckInSet($i, 1, "Staff Wrapping of Enchanting") Then Return $i
		Next
	EndIf
	Return 0 ;Don't find the +20% enchant
Endfunc

Func FindSetByType($aType)
	If GetAgentWeaponItemType_Ptr() = $aType Then
		Return 5 ;already have the right weapon type
	Else
		If $lSet_1[0] = $aType Then Return 1
		If $lSet_2[0] = $aType Then Return 2
		If $lSet_3[0] = $aType Then Return 3
		If $lSet_4[0] = $aType Then Return 4
	EndIf
	Return 0 ;Don't find the weapon type in any set
EndFunc

Func CheckInSet($aSet = 0, $aWeapon = 0, $LookingFor = "")
	For $i = 0 To 7
		If $Weapon_Mods[$aSet-1][$aWeapon-1][$i] = $LookingFor Then Return True
	Next
	Return False
EndFunc

Func CheckInAllSet($LookingFor = "")
	For $Y = 0 To 3
		For $J = 0 To 1
			For $i = 0 To 7
				If $Weapon_Mods[$Y][$J][$i] = $LookingFor Then
					Out("Find at: " & "[" & $Y & "]" & "[" & $J & "]" & "[" & $i & "]")
					Out("Set: " & $Y+1 & ", Weapon: " & $J+1 & ", Mod: " & $i)
				EndIf
			Next
		Next
	Next
EndFunc

Func GetBestWeaponSetBySkillSlot($aSkillSlot)

	If GetMapLoading() == 0 Then Return

	Switch $SkillBarCache[$aSkillSlot][$Type]
		Case $Hex, $Spell, $Signet, $Condition, $Well, $Ward, $ItemSpell, $WeaponSpell ;Hex, Spell => 40/40
			If GetHp() < 0.25 Then
				If GetAgentMaxHp_Ptr() <> $High_Hp_Set[0] Then
					ChangeSet($High_Hp_Set[1])
					Return
				EndIf
				Return
			EndIf
			If GetEnergy() < $SkillBarCache[$aSkillSlot][$energyreq] Then
				If GetAgentMaxEnergy_Ptr() <> $High_Energy_Set[0] Then
					ChangeSet($High_Energy_Set[1])
					Return
				EndIf
				Return
			EndIf
			If FindSet4040() = 5 Or FindSet4040() = 0 Then Return
			If FindSet4040() <> 5 And FindSet4040() <> 0 Then ChangeSet(FindSet4040())
		Case $Enchantment ; Enchantment Spell => Enchant 20% or 20/20/20
			If GetHp() < 0.25 Then
				If GetAgentMaxHp_Ptr() <> $High_Hp_Set[0] Then
					ChangeSet($High_Hp_Set[1])
					Return
				EndIf
				Return
			EndIf
			If GetEnergy() < $SkillBarCache[$aSkillSlot][$energyreq] Then
				If GetAgentMaxEnergy_Ptr() <> $High_Energy_Set[0] Then
					ChangeSet($High_Energy_Set[1])
					Return
				EndIf
				Return
			EndIf
			If FindSet402020() = 5 Then Return
			If FindSet402020() <> 5 And FindSet402020() <> 0 Then ChangeSet(FindSet402020())
			If FindSet402020() = 0 Then
				If FindSetEnchant20() = 5 Then Return
				If FindSetEnchant20() <> 0 And FindSetEnchant20() <> 5 Then ChangeSet(FindSetEnchant20())
			EndIf
		Case $Skill, $Attack ;attack => switch weapon type
			Switch $SkillBarCache[$aSkillSlot][$WeaponReq]
				Case 1 ; all Axe Attacks
					If GetAgentWeaponItemType_Ptr() <> 2 Then ChangeSet(FindSetByType(2))
				Case 2 ; all Bow Attacks
					If GetAgentWeaponItemType_Ptr() <> 1 Then ChangeSet(FindSetByType(1))
				Case 8 ; all Dagger Attacks
					If GetAgentWeaponItemType_Ptr() <> 4 Then ChangeSet(FindSetByType(4))
				Case 16 ; all Hammer Attacks
					If GetAgentWeaponItemType_Ptr() <> 3 Then ChangeSet(FindSetByType(3))
				Case 32 ; all Scythe Attacks
					If GetAgentWeaponItemType_Ptr() <> 5 Then ChangeSet(FindSetByType(5))
				Case 64 ; all Spear Attacks
					If GetAgentWeaponItemType_Ptr() <> 6 Then ChangeSet(FindSetByType(6))
				;Case 70 ; Ranged Attack non Weapon Requirement
				Case 128 ; all Sword Attacks
					If GetAgentWeaponItemType_Ptr() <> 7 Then ChangeSet(FindSetByType(7))
				;Case 185 ; all Melee Attack non Weapon Requirement
			EndSwitch
		;Case $Stance, $Shout, $Preparation, 20, $Trap, $Ritual, $Chant, $EchoRefrain;Item's attri +1
		;Case Else ;12 Glyph, 26Form, 29disguise
	EndSwitch
EndFunc   ;==>GetBestWeaponSetBySkillSlot

Func ChangeSet($aSet)
	Local $primaryset, $secondaryset, $MyHp, $MyEnergy
	Local $old_MyHp = GetAgentMaxHp_Ptr()
	Local $old_MyEnergy = GetAgentMaxEnergy_Ptr()
	Local $old_primaryset = GetAgentWeaponItemType_Ptr(-2)
	Local $old_secondaryset = GetAgentOffhandItemType_Ptr(-2)

	Local $lDeadlock = TimerInit()
	CancelAction()
	Do
		ChangeWeaponSet($aSet)
		Sleep(16)
		$primaryset = GetAgentWeaponItemType_Ptr(-2)
		$secondaryset = GetAgentOffhandItemType_Ptr(-2)
		$MyHp = GetAgentMaxHp_Ptr()
		$MyEnergy = GetAgentMaxEnergy_Ptr()
	Until $old_primaryset <> $primaryset Or $old_secondaryset <> $secondaryset Or TimerDiff($lDeadlock) > 5000 Or $old_MyHp <> $MyHp Or $old_MyEnergy <> $MyEnergy
EndFunc

Func ChangeSetAndSave($aSet)
	Local $primaryset, $secondaryset, $MyHp, $MyEnergy
	Local $old_MyHp = GetAgentMaxHp_Ptr()
	Local $old_MyEnergy = GetAgentMaxEnergy_Ptr()
	Local $old_primaryset = GetAgentWeaponItemType_Ptr(-2)
	Local $old_secondaryset = GetAgentOffhandItemType_Ptr(-2)

	Local $lDeadlock = TimerInit()
	Do
		ChangeWeaponSet($aSet)
		Sleep(100)
		$primaryset = GetAgentWeaponItemType_Ptr(-2)
		$secondaryset = GetAgentOffhandItemType_Ptr(-2)
		$MyHp = GetAgentMaxHp_Ptr()
		$MyEnergy = GetAgentMaxEnergy_Ptr()
	Until $old_primaryset <> $primaryset Or $old_secondaryset <> $secondaryset Or TimerDiff($lDeadlock) > 5000 Or $old_MyHp <> $MyHp Or $old_MyEnergy <> $MyEnergy

	If TimerDiff($lDeadlock) > 5000 Then
		Out("Same WeaponSet?")
		SaveSet($aSet)
		Return True
	EndIf

	SaveSet($aSet)
	Return True
EndFunc

Func SaveSet($aSet)
	If $aSet = 1 Then
		$lSet_1[0] = GetAgentWeaponItemType_Ptr()
		$lSet_1[1] = GetAgentWeaponItemId_Ptr()
		$lSet_1[2] = GetAgentOffhandItemType_Ptr()
		$lSet_1[3] = GetAgentOffhandItemId_Ptr()
		$lSet_1[4] = GetAgentMaxHp_Ptr()
		$lSet_1[5] = GetAgentMaxEnergy_Ptr()
		Out("Set 1: " & $lSet_1[0] & ", " & $lSet_1[2])
		FindAndSaveMod($lSet_1[1], 1, 1)
		FindAndSaveMod($lSet_1[3], 1, 2)
		If $lSet_1[4] > $High_Hp_Set[0] Then
			$High_Hp_Set[0] = $lSet_1[4]
			$High_Hp_Set[1] = 1
		EndIf
		If $lSet_1[5] > $High_Energy_Set[0] Then
			$High_Energy_Set[0] = $lSet_1[5]
			$High_Energy_Set[1] = 1
		EndIf
	EndIf

	If $aSet = 2 Then
		$lSet_2[0] = GetAgentWeaponItemType_Ptr()
		$lSet_2[1] = GetAgentWeaponItemId_Ptr()
		$lSet_2[2] = GetAgentOffhandItemType_Ptr()
		$lSet_2[3] = GetAgentOffhandItemId_Ptr()
		$lSet_2[4] = GetAgentMaxHp_Ptr()
		$lSet_2[5] = GetAgentMaxEnergy_Ptr()
		Out("Set 2: " & $lSet_2[0] & ", " & $lSet_2[2])
		FindAndSaveMod($lSet_2[1], 2, 1)
		FindAndSaveMod($lSet_2[3], 2, 2)
		If $lSet_2[4] > $High_Hp_Set[0] Then
			$High_Hp_Set[0] = $lSet_2[4]
			$High_Hp_Set[1] = 2
		EndIf
		If $lSet_2[5] > $High_Energy_Set[0] Then
			$High_Energy_Set[0] = $lSet_2[5]
			$High_Energy_Set[1] = 2
		EndIf
	EndIf

	If $aSet = 3 Then
		$lSet_3[0] = GetAgentWeaponItemType_Ptr()
		$lSet_3[1] = GetAgentWeaponItemId_Ptr()
		$lSet_3[2] = GetAgentOffhandItemType_Ptr()
		$lSet_3[3] = GetAgentOffhandItemId_Ptr()
		$lSet_3[4] = GetAgentMaxHp_Ptr()
		$lSet_3[5] = GetAgentMaxEnergy_Ptr()
		Out("Set 3: " & $lSet_3[0] & ", " & $lSet_3[2])
		FindAndSaveMod($lSet_3[1], 3, 1)
		FindAndSaveMod($lSet_3[3], 3, 2)
		If $lSet_3[4] > $High_Hp_Set[0] Then
			$High_Hp_Set[0] = $lSet_3[4]
			$High_Hp_Set[1] = 3
		EndIf
		If $lSet_3[5] > $High_Energy_Set[0] Then
			$High_Energy_Set[0] = $lSet_3[5]
			$High_Energy_Set[1] = 3
		EndIf
	EndIf

	If $aSet = 4 Then
		$lSet_4[0] = GetAgentWeaponItemType_Ptr()
		$lSet_4[1] = GetAgentWeaponItemId_Ptr()
		$lSet_4[2] = GetAgentOffhandItemType_Ptr()
		$lSet_4[3] = GetAgentOffhandItemId_Ptr()
		$lSet_4[4] = GetAgentMaxHp_Ptr()
		$lSet_4[5] = GetAgentMaxEnergy_Ptr()
		Out("Set 4: " & $lSet_4[0] & ", " & $lSet_4[2])
		FindAndSaveMod($lSet_4[1], 4, 1)
		FindAndSaveMod($lSet_4[3], 4, 2)
		If $lSet_4[4] > $High_Hp_Set[0] Then
			$High_Hp_Set[0] = $lSet_4[4]
			$High_Hp_Set[1] = 4
		EndIf
		If $lSet_4[5] > $High_Energy_Set[0] Then
			$High_Energy_Set[0] = $lSet_4[5]
			$High_Energy_Set[1] = 4
		EndIf
	EndIf
EndFunc

Func FindAndSaveMod($aItem, $Set = 0, $Weapon = 0) ;set 1,2,3,4 / Weapon 1,2
	Local $lFinding = 0
	$aModStruct = GetModStruct($aItem)
	If $Weapon = 1 Then
		Switch GetAgentWeaponItemType_Ptr()
			Case $Bow
				For $i = 0 To UBound($array_BowUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_BowUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_BowUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_BowUpgrade[$i][2], "")
							Out($array_BowUpgrade[$i][0])
							Out($array_BowUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_BowUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_BowUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_BowUpgrade[$i][2], "")
							Out($array_BowUpgrade[$i][0])
							Out($array_BowUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_MartialWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case $Axe
				For $i = 0 To UBound($array_AxeUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_AxeUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_AxeUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_AxeUpgrade[$i][2], "")
							Out($array_AxeUpgrade[$i][0])
							Out($array_AxeUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_AxeUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_AxeUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_AxeUpgrade[$i][2], "")
							Out($array_AxeUpgrade[$i][0])
							Out($array_AxeUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_MartialWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case $Hammer
				For $i = 0 To UBound($array_HammerUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_HammerUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_HammerUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_HammerUpgrade[$i][2], "")
							Out($array_HammerUpgrade[$i][0])
							Out($array_HammerUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_HammerUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_HammerUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_HammerUpgrade[$i][2], "")
							Out($array_HammerUpgrade[$i][0])
							Out($array_HammerUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_MartialWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case $Daggers
				For $i = 0 To UBound($array_DaggerUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_DaggerUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_DaggerUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_DaggerUpgrade[$i][2], "")
							Out($array_DaggerUpgrade[$i][0])
							Out($array_DaggerUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_DaggerUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_DaggerUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_DaggerUpgrade[$i][2], "")
							Out($array_DaggerUpgrade[$i][0])
							Out($array_DaggerUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_MartialWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case $Scythe
				For $i = 0 To UBound($array_ScytheUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_ScytheUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_ScytheUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_ScytheUpgrade[$i][2], "")
							Out($array_ScytheUpgrade[$i][0])
							Out($array_ScytheUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_ScytheUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_ScytheUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_ScytheUpgrade[$i][2], "")
							Out($array_ScytheUpgrade[$i][0])
							Out($array_ScytheUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_MartialWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case $Spear
				For $i = 0 To UBound($array_SpearUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_SpearUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_SpearUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_SpearUpgrade[$i][2], "")
							Out($array_SpearUpgrade[$i][0])
							Out($array_SpearUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_SpearUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_SpearUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_SpearUpgrade[$i][2], "")
							Out($array_SpearUpgrade[$i][0])
							Out($array_SpearUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_MartialWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case $Sword
				For $i = 0 To UBound($array_SwordUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_SwordUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_SwordUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_SwordUpgrade[$i][2], "")
							Out($array_SwordUpgrade[$i][0])
							Out($array_SwordUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_SwordUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_SwordUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_SwordUpgrade[$i][2], "")
							Out($array_SwordUpgrade[$i][0])
							Out($array_SwordUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_MartialWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_MartialWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_MartialWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_MartialWeaponsInscription[$i][2], "")
							Out($array_MartialWeaponsInscription[$i][0])
							Out($array_MartialWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case $Chaos, $Cold, $Dark, $Earth, $Lightning, $Fire, $Holy
				For $i = 0 To UBound($array_StaffWandUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_StaffWandUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_StaffWandUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_StaffWandUpgrade[$i][2], "")
							Out($array_StaffWandUpgrade[$i][0])
							Out($array_StaffWandUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_StaffWandUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_StaffWandUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_StaffWandUpgrade[$i][2], "")
							Out($array_StaffWandUpgrade[$i][0])
							Out($array_StaffWandUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_SpellCastingWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_SpellCastingWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_SpellCastingWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_SpellCastingWeaponsInscription[$i][2], "")
							Out($array_SpellCastingWeaponsInscription[$i][0])
							Out($array_SpellCastingWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_SpellCastingWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_SpellCastingWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_SpellCastingWeaponsInscription[$i][2], "")
							Out($array_SpellCastingWeaponsInscription[$i][0])
							Out($array_SpellCastingWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
		EndSwitch
	ElseIf $Weapon = 2 Then
		Switch GetAgentOffhandItemType_Ptr()
			Case 12 ;focus
				For $i = 0 To UBound($array_FocusUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_FocusUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_FocusUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_FocusUpgrade[$i][2], "")
							Out($array_FocusUpgrade[$i][0])
							Out($array_FocusUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_FocusUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_FocusUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_FocusUpgrade[$i][2], "")
							Out($array_FocusUpgrade[$i][0])
							Out($array_FocusUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_FocusShieldWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_FocusShieldWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_FocusShieldWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_FocusShieldWeaponsInscription[$i][2], "")
							Out($array_FocusShieldWeaponsInscription[$i][0])
							Out($array_FocusShieldWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_FocusShieldWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_FocusShieldWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_FocusShieldWeaponsInscription[$i][2], "")
							Out($array_FocusShieldWeaponsInscription[$i][0])
							Out($array_FocusShieldWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case 24 ;shield
				For $i = 0 To UBound($array_ShieldUpgrade) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_ShieldUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_ShieldUpgrade[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_ShieldUpgrade[$i][2], "")
							Out($array_ShieldUpgrade[$i][0])
							Out($array_ShieldUpgrade[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_ShieldUpgrade[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_ShieldUpgrade[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_ShieldUpgrade[$i][2], "")
							Out($array_ShieldUpgrade[$i][0])
							Out($array_ShieldUpgrade[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
				For $i = 0 To UBound($array_FocusShieldWeaponsInscription) - 1
					If $lFinding = 0 Then
						If StringInStr($aModStruct, $array_FocusShieldWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_FocusShieldWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aModStruct, $array_FocusShieldWeaponsInscription[$i][2], "")
							Out($array_FocusShieldWeaponsInscription[$i][0])
							Out($array_FocusShieldWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					ElseIf $lFinding <> 0 Then
						If StringInStr($aNewModStruct, $array_FocusShieldWeaponsInscription[$i][2]) > 0 Then
							$Weapon_Mods[$Set-1][$Weapon-1][$lFinding] = $array_FocusShieldWeaponsInscription[$i][0]
							$aNewModStruct = StringReplace($aNewModStruct, $array_FocusShieldWeaponsInscription[$i][2], "")
							Out($array_FocusShieldWeaponsInscription[$i][0])
							Out($array_FocusShieldWeaponsInscription[$i][1])
							$lFinding += 1
						EndIf
					EndIf
				Next
			Case 48 ;nothing

		EndSwitch
	EndIf
EndFunc
#EndRegion Set and Mods