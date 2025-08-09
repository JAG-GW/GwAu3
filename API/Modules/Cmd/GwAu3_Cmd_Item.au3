#include-once

;~ Description: Salvage an item.
Func Item_SalvageItem($a_v_Item, $a_s_KitType = "Standard", $a_s_SalvageType = "Materials")
    Local $l_i_ItemID = Item_ItemID($a_v_Item)

    ; Check if Standard kit is requested with mod salvage (not allowed)
    If $a_s_KitType = "Standard" And $a_s_SalvageType <> "Materials" Then
        Return False ; Standard only salvage materials
    EndIf

    ; Find the optimal salvage kit
    Local $l_ptr_SalvageKit = 0
    Local $l_a_Kits[5][3] ; [ModelID, ItemPtr, Uses]
    $l_a_Kits[0][0] = 0 ; Charr Salvage Kit (ModelID 170)
    $l_a_Kits[1][0] = 0 ; Salvage Kit (ModelID 2992)
    $l_a_Kits[2][0] = 0 ; Expert Salvage Kit (ModelID 2991)
    $l_a_Kits[3][0] = 0 ; Superior Salvage Kit (ModelID 5900)
    $l_a_Kits[4][0] = 0 ; Perfect Salvage Kit (ModelID 25881)

    ; Browse bags to find available salvage kits
    For $i = 1 To 4
        For $j = 1 To Item_GetBagInfo(Item_GetBagPtr($i), 'Slots')
            Local $l_ptr_Item = Item_GetItemBySlot($i, $j)
            Local $l_i_ModelID = Item_GetItemInfoByPtr($l_ptr_Item, 'ModelID')
            Local $l_i_Value = Item_GetItemInfoByPtr($l_ptr_Item, 'Value')

            Switch $l_i_ModelID
                Case 170 ; Charr Salvage Kit
                    Local $l_i_Uses = $l_i_Value / 1
                    If $l_a_Kits[0][0] = 0 Or $l_i_Uses < $l_a_Kits[0][2] Then
                        $l_a_Kits[0][0] = 170
                        $l_a_Kits[0][1] = $l_ptr_Item
                        $l_a_Kits[0][2] = $l_i_Uses
                    EndIf

                Case 2992 ; Salvage Kit (standard)
                    Local $l_i_Uses = $l_i_Value / 2
                    If $l_a_Kits[1][0] = 0 Or $l_i_Uses < $l_a_Kits[1][2] Then
                        $l_a_Kits[1][0] = 2992
                        $l_a_Kits[1][1] = $l_ptr_Item
                        $l_a_Kits[1][2] = $l_i_Uses
                    EndIf

                Case 2991 ; Expert Salvage Kit
                    Local $l_i_Uses = $l_i_Value / 8
                    If $l_a_Kits[2][0] = 0 Or $l_i_Uses < $l_a_Kits[2][2] Then
                        $l_a_Kits[2][0] = 2991
                        $l_a_Kits[2][1] = $l_ptr_Item
                        $l_a_Kits[2][2] = $l_i_Uses
                    EndIf

                Case 5900 ; Superior Salvage Kit
                    Local $l_i_Uses = $l_i_Value / 10
                    If $l_a_Kits[3][0] = 0 Or $l_i_Uses < $l_a_Kits[3][2] Then
                        $l_a_Kits[3][0] = 5900
                        $l_a_Kits[3][1] = $l_ptr_Item
                        $l_a_Kits[3][2] = $l_i_Uses
                    EndIf

                Case 25881 ; Perfect Salvage Kit
                    Local $l_i_Uses = $l_i_Value / 10
                    If $l_a_Kits[4][0] = 0 Or $l_i_Uses < $l_a_Kits[4][2] Then
                        $l_a_Kits[4][0] = 25881
                        $l_a_Kits[4][1] = $l_ptr_Item
                        $l_a_Kits[4][2] = $l_i_Uses
                    EndIf
            EndSwitch
        Next
    Next

    ; Select kit according to preference
    Switch $a_s_KitType
        Case "Perfect"
            ; Prefer perfect kit, then superior, expert, standard, charr
            If $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            EndIf

        Case "Superior"
            ; Prefer superior kit, then perfect, expert, standard, charr
            If $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            EndIf

        Case "Expert"
            ; Prefer expert kit, then superior, perfect, standard, charr
            If $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            EndIf

        Case "Standard"
            ; Prefer standard kit, then charr, expert, superior, perfect
            If $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            EndIf

        Case "Charr"
            ; Prefer charr kit, then standard, expert, superior, perfect
            If $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            EndIf
    EndSwitch

    If $l_ptr_SalvageKit = 0 Then Return False

    ; Start salvage session
    Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x690]
    Local $l_i_SalvageSessionID = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)

    Other_PingSleep(32)

    DllStructSetData($g_d_Salvage, 2, $l_i_ItemID)
    DllStructSetData($g_d_Salvage, 3, Item_ItemID($l_ptr_SalvageKit))
    DllStructSetData($g_d_Salvage, 4, $l_i_SalvageSessionID[1])
    Core_Enqueue($g_p_Salvage, 16)

    ; Wait for salvage window to open
    Other_PingSleep(32)

    ; Perform the salvage type requested
    Switch $a_s_SalvageType
        Case "Materials"
            Core_SendPacket(0x4, $GC_I_HEADER_ITEM_SALVAGE_MATERIALS)
			Other_PingSleep(32)
        Case "Prefix"
            Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, 0)
			Other_PingSleep(32)
        Case "Suffix"
            Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, 1)
			Other_PingSleep(32)
        Case "Inscription"
            Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, 2)
			Other_PingSleep(32)
        Case Else
            Return False
    EndSwitch

    Return True
EndFunc ;==>Item_SalvageItem

;~ Description: Identifies an item.
Func Item_IdentifyItem($a_v_Item, $a_s_KitType = "Superior")
    Local $l_i_ItemID = Item_ItemID($a_v_Item)

    ; Check if item is already identified
    If Item_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Then Return True

    ; Find the optimal identification kit
    Local $l_i_IDKit = 0
    Local $l_i_BestUses = 101
    Local $l_a_Kits[2][3] ; [ModelID, ItemID, Uses]
    $l_a_Kits[0][0] = 0 ; Normal kit (ModelID 2989)
    $l_a_Kits[1][0] = 0 ; Superior kit (ModelID 5899)

    ; Browse bags to find available kits
    For $i = 1 To 4
        For $j = 1 To Item_GetBagInfo(Item_GetBagPtr($i), 'Slots')
            Local $l_ptr_Item = Item_GetItemBySlot($i, $j)
            Local $l_i_ModelID = Item_GetItemInfoByPtr($l_ptr_Item, 'ModelID')
            Local $l_i_Value = Item_GetItemInfoByPtr($l_ptr_Item, 'Value')

            Switch $l_i_ModelID
                Case 2989 ; Normal kit
                    Local $l_i_Uses = $l_i_Value / 2
                    If $l_a_Kits[0][0] = 0 Or $l_i_Uses < $l_a_Kits[0][2] Then
                        $l_a_Kits[0][0] = 2989
                        $l_a_Kits[0][1] = Item_GetItemInfoByPtr($l_ptr_Item, 'ItemID')
                        $l_a_Kits[0][2] = $l_i_Uses
                    EndIf

                Case 5899 ; Superior kit
                    Local $l_i_Uses = $l_i_Value / 2.5
                    If $l_a_Kits[1][0] = 0 Or $l_i_Uses < $l_a_Kits[1][2] Then
                        $l_a_Kits[1][0] = 5899
                        $l_a_Kits[1][1] = Item_GetItemInfoByPtr($l_ptr_Item, 'ItemID')
                        $l_a_Kits[1][2] = $l_i_Uses
                    EndIf
            EndSwitch
        Next
    Next

    ; Select kit according to preference
    Switch $a_s_KitType
        Case "Superior"
            ; Prefer superior kit, otherwise use normal
            If $l_a_Kits[1][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[0][1]
            EndIf

        Case "Normal"
            ; Prefer normal kit, otherwise use superior
            If $l_a_Kits[0][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[0][1]
            ElseIf $l_a_Kits[1][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[1][1]
            EndIf
    EndSwitch

    ; If no kit found, return False
    If $l_i_IDKit = 0 Then Return False

    ; Send identification packet
    Core_SendPacket(0xC, $GC_I_HEADER_ITEM_IDENTIFY, $l_i_IDKit, $l_i_ItemID)

    ; Wait for item to be identified
    Local $l_i_Deadlock = TimerInit()
    Do
        Sleep(16)
    Until Item_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Or TimerDiff($l_i_Deadlock) > 2500

    If TimerDiff($l_i_Deadlock) > 2500 Then Return False
    Return True
EndFunc ;==>Item_IdentifyItem

;~ Description: Equips an item.
Func Item_EquipItem($a_v_Item)
    Return Core_SendPacket(0x8, $GC_I_HEADER_ITEM_EQUIP, Item_ItemID($a_v_Item))
EndFunc ;==>EquipItem

;~ Description: Uses an item.
Func Item_UseItem($a_v_Item)
    Return Core_SendPacket(0x8, $GC_I_HEADER_ITEM_USE, Item_ItemID($a_v_Item))
EndFunc ;==>UseItem

;~ Description: Picks up an item.
Func Item_PickUpItem($a_v_AgentID)
    Return Core_SendPacket(0xC, $GC_I_HEADER_ITEM_PICKUP, Agent_ConvertID($a_v_AgentID), 0)
EndFunc ;==>PickUpItem

;~ Description: Drops an item.
Func Item_DropItem($a_v_Item, $a_i_Amount = 0)
    Local $l_i_ItemID = Item_ItemID($a_v_Item)
    Local $l_i_Quantity = Item_GetItemInfoByItemID($a_v_Item, "Quantity")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Quantity Then $a_i_Amount = $l_i_Quantity
    Return Core_SendPacket(0xC, $GC_I_HEADER_DROP_ITEM, $l_i_ItemID, $a_i_Amount)
EndFunc ;==>DropItem

;~ Description: Moves an item.
Func Item_MoveItem($a_v_Item, $a_i_BagNumber, $a_i_Slot)
    Return Core_SendPacket(0x10, $GC_I_HEADER_ITEM_MOVE, Item_ItemID($a_v_Item), Item_GetBagInfo($a_i_BagNumber, "ID"), $a_i_Slot - 1)
EndFunc ;==>MoveItem

;~ Description: Accepts unclaimed items after a mission.
Func Item_AcceptAllItems()
    Return Core_SendPacket(0x8, $GC_I_HEADER_ITEMS_ACCEPT_UNCLAIMED, Item_GetBagInfo(7, "ID"))
EndFunc ;==>AcceptAllItems

;~ Description: Drop gold on the ground.
Func Item_DropGold($a_i_Amount = 0)
    Local $l_i_Amount = Item_GetInventoryInfo("GoldCharacter")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Amount Then $a_i_Amount = $l_i_Amount
    Return Core_SendPacket(0x8, $GC_I_HEADER_DROP_GOLD, $a_i_Amount)
EndFunc ;==>DropGold

;~ Description: Internal use for moving gold.
Func Item_ChangeGold($a_i_Character, $a_i_Storage)
    Return Core_SendPacket(0xC, $GC_I_HEADER_ITEM_CHANGE_GOLD, $a_i_Character, $a_i_Storage) ;0x75
EndFunc ;==>ChangeGold

;~ Description: Deposit gold into storage.
Func Item_DepositGold($a_i_Amount = 0)
    Local $l_i_Amount
    Local $l_i_Storage = Item_GetInventoryInfo("GoldStorage")
    Local $l_i_Character = Item_GetInventoryInfo("GoldCharacter")

    If $a_i_Amount > 0 And $l_i_Character >= $a_i_Amount Then
        $l_i_Amount = $a_i_Amount
    Else
        $l_i_Amount = $l_i_Character
    EndIf

    If $l_i_Storage + $l_i_Amount > 1000000 Then $l_i_Amount = 1000000 - $l_i_Storage

    Item_ChangeGold($l_i_Character - $l_i_Amount, $l_i_Storage + $l_i_Amount)
EndFunc ;==>DepositGold

;~ Description: Withdraw gold from storage.
Func Item_WithdrawGold($a_i_Amount = 0)
    Local $l_i_Amount
    Local $l_i_Storage = Item_GetInventoryInfo("GoldStorage")
    Local $l_i_Character = Item_GetInventoryInfo("GoldCharacter")

    If $a_i_Amount > 0 And $l_i_Storage >= $a_i_Amount Then
        $l_i_Amount = $a_i_Amount
    Else
        $l_i_Amount = $l_i_Storage
    EndIf

    If $l_i_Character + $l_i_Amount > 100000 Then $l_i_Amount = 100000 - $l_i_Character

    Item_ChangeGold($l_i_Character + $l_i_Amount, $l_i_Storage - $l_i_Amount)
EndFunc ;==>WithdrawGold

;~ Description: Open a chest.
Func Item_OpenChest($a_b_WithLockpick = True)
	If $a_b_WithLockpick Then
		Return Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 2)
	Else
		Return Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 1)
	EndIf
EndFunc ;==>OpenChest

Func Item_SwitchWeaponSet($a_i_WeaponSet)
    Return Core_SendPacket(0x8, $GC_I_HEADER_SWITCH_SET, $a_i_WeaponSet)
EndFunc ;==>SwitchWeaponSet
