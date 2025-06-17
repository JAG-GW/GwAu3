#include-once

Func GwAu3_Item_SalvageItem($a_i_ItemID, $a_i_SalvageKitID, $a_i_SalvageType = $GC_I_SALVAGE_TYPE_NORMAL)
    If $a_i_ItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $a_i_ItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_SalvageKitID <= 0 Then
        GwAu3_Log_Error("Invalid salvage kit ID: " & $a_i_SalvageKitID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_SalvageType < $GC_I_SALVAGE_TYPE_NORMAL Or $a_i_SalvageType > $GC_I_SALVAGE_TYPE_PERFECT Then
        GwAu3_Log_Error("Invalid salvage type: " & $a_i_SalvageType, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    DllStructSetData($g_d_Salvage, 1, GwAu3_Memory_GetValue('CommandSalvage'))
    DllStructSetData($g_d_Salvage, 2, $a_i_ItemID)
    DllStructSetData($g_d_Salvage, 3, $a_i_SalvageKitID)
    DllStructSetData($g_d_Salvage, 4, $a_i_SalvageType)

    GwAu3_Core_Enqueue($g_p_Salvage, 16)

    ; Record for tracking
    $g_i_LastTransactionType = 0 ; Salvage doesn't have a specific transaction type
    $g_i_LastItemID = $a_i_ItemID

    GwAu3_Log_Debug("Salvaging item " & $a_i_ItemID & " with kit " & $a_i_SalvageKitID & " (type: " & $a_i_SalvageType & ")", "TradeMod", $g_h_EditText)
    Return True
EndFunc

;~ Description: Salvage the materials out of an item.
Func GwAu3_Item_SalvageMaterials()
    Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_ITEM_SALVAGE_MATERIALS)
EndFunc ;==>SalvageMaterials

;~ Description: Salvages a mod out of an item.
Func GwAu3_Item_SalvageMod($a_i_ModIndex)
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, $a_i_ModIndex)
EndFunc ;==>SalvageMod

;~ Description: Identifies an item.
Func GwAu3_Item_IdentifyItem($a_v_Item, $a_s_KitType = "Superior")
    Local $l_i_IDKit = 0
    Local $l_i_ItemID = GwAu3_Item_ItemID($a_v_Item)

    If GwAu3_Item_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Then Return True

    Switch $a_s_KitType
        Case "Superior"
            If GwAu3_Map_GetInstanceInfo("IsOutpost") Then
                $l_i_IDKit = GwAu3_Item_GetItemInfoByModelID(5899, "ItemID")
                If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_Item_GetItemInfoByModelID(2989, "ItemID")
            ElseIf GwAu3_Map_GetInstanceInfo("IsExplorable") Then
                $l_i_IDKit = GwAu3_Item_GetBagsItembyModelID(5899)
                If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_Item_GetBagsItembyModelID(2989)
            EndIf
        Case "Normal"
            If GwAu3_Map_GetInstanceInfo("IsOutpost") Then
                $l_i_IDKit = GwAu3_Item_GetItemInfoByModelID(2989, "ItemID")
                If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_Item_GetItemInfoByModelID(5899, "ItemID")
            ElseIf GwAu3_Map_GetInstanceInfo("IsExplorable") Then
                $l_i_IDKit = GwAu3_Item_GetBagsItembyModelID(2989)
                If $l_i_IDKit = 0 Then $l_i_IDKit = GwAu3_Item_GetBagsItembyModelID(5899)
            EndIf
    EndSwitch

    If $l_i_IDKit = 0 Then Return False

    GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_ITEM_IDENTIFY, GwAu3_Item_ItemID($l_i_IDKit), $l_i_ItemID)

    Local $l_i_Deadlock = TimerInit()
    Do
        Sleep(16)
    Until GwAu3_Item_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Or TimerDiff($l_i_Deadlock) > 2500

    If TimerDiff($l_i_Deadlock) > 2500 Then Return False

    Return True
EndFunc ;==>IdentifyItem

;~ Description: Equips an item.
Func GwAu3_Item_EquipItem($a_v_Item)
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEM_EQUIP, GwAu3_Item_ItemID($a_v_Item))
EndFunc ;==>EquipItem

;~ Description: Uses an item.
Func GwAu3_Item_UseItem($a_v_Item)
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEM_USE, GwAu3_Item_ItemID($a_v_Item))
EndFunc ;==>UseItem

;~ Description: Picks up an item.
Func GwAu3_Item_PickUpItem($a_v_AgentID)
    Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_ITEM_PICKUP, GwAu3_Agent_ConvertID($a_v_AgentID), 0)
EndFunc ;==>PickUpItem

;~ Description: Drops an item.
Func GwAu3_Item_DropItem($a_v_Item, $a_i_Amount = 0)
    Local $l_i_ItemID = GwAu3_Item_ItemID($a_v_Item)
    Local $l_i_Quantity = GwAu3_Item_GetItemInfoByItemID($a_v_Item, "Quantity")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Quantity Then $a_i_Amount = $l_i_Quantity
    Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_DROP_ITEM, $l_i_ItemID, $a_i_Amount)
EndFunc ;==>DropItem

;~ Description: Moves an item.
Func GwAu3_Item_MoveItem($a_v_Item, $a_i_BagNumber, $a_i_Slot)
    Return GwAu3_Core_SendPacket(0x10, $GC_I_HEADER_ITEM_MOVE, GwAu3_Item_ItemID($a_v_Item), GwAu3_Item_GetBagInfo($a_i_BagNumber, "ID"), $a_i_Slot - 1)
EndFunc ;==>MoveItem

;~ Description: Accepts unclaimed items after a mission.
Func GwAu3_Item_AcceptAllItems()
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_ITEMS_ACCEPT_UNCLAIMED, GwAu3_Item_GetBagInfo(7, "ID"))
EndFunc ;==>AcceptAllItems

;~ Description: Drop gold on the ground.
Func GwAu3_Item_DropGold($a_i_Amount = 0)
    Local $l_i_Amount = GwAu3_Item_GetInventoryInfo("GoldCharacter")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Amount Then $a_i_Amount = $l_i_Amount
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_DROP_GOLD, $a_i_Amount)
EndFunc ;==>DropGold

;~ Description: Internal use for moving gold.
Func GwAu3_Item_ChangeGold($a_i_Character, $a_i_Storage)
    Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_ITEM_CHANGE_GOLD, $a_i_Character, $a_i_Storage) ;0x75
EndFunc ;==>ChangeGold

;~ Description: Deposit gold into storage.
Func GwAu3_Item_DepositGold($a_i_Amount = 0)
    Local $l_i_Amount
    Local $l_i_Storage = GwAu3_Item_GetInventoryInfo("GoldStorage")
    Local $l_i_Character = GwAu3_Item_GetInventoryInfo("GoldCharacter")

    If $a_i_Amount > 0 And $l_i_Character >= $a_i_Amount Then
        $l_i_Amount = $a_i_Amount
    Else
        $l_i_Amount = $l_i_Character
    EndIf

    If $l_i_Storage + $l_i_Amount > 1000000 Then $l_i_Amount = 1000000 - $l_i_Storage

    GwAu3_Item_ChangeGold($l_i_Character - $l_i_Amount, $l_i_Storage + $l_i_Amount)
EndFunc ;==>DepositGold

;~ Description: Withdraw gold from storage.
Func GwAu3_Item_WithdrawGold($a_i_Amount = 0)
    Local $l_i_Amount
    Local $l_i_Storage = GwAu3_Item_GetInventoryInfo("GoldStorage")
    Local $l_i_Character = GwAu3_Item_GetInventoryInfo("GoldCharacter")

    If $a_i_Amount > 0 And $l_i_Storage >= $a_i_Amount Then
        $l_i_Amount = $a_i_Amount
    Else
        $l_i_Amount = $l_i_Storage
    EndIf

    If $l_i_Character + $l_i_Amount > 100000 Then $l_i_Amount = 100000 - $l_i_Character

    GwAu3_Item_ChangeGold($l_i_Character + $l_i_Amount, $l_i_Storage - $l_i_Amount)
EndFunc ;==>WithdrawGold

;~ Description: Open a chest with key.
Func GwAu3_Item_OpenChestNoLockpick()
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 1)
EndFunc ;==>OpenChestNoLockpick

;~ Description: Open a chest with lockpick.
Func GwAu3_Item_OpenChest()
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 2)
EndFunc ;==>OpenChest

Func GwAu3_Item_SwitchWeaponSet($a_i_WeaponSet)
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_SWITCH_SET, $a_i_WeaponSet)
EndFunc ;==>SwitchWeaponSet
