#include-once

#Region Item Context
Func Item_GetItemContextPtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x40]
    Local $l_ap_ItemContextPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_ItemContextPtr[1]
EndFunc

Func Item_GetInventoryPtr()
    Local $l_ai_Offset[4] = [0, 0x18, 0x40, 0xF8]
    Local $l_ap_ItemContextPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_ItemContextPtr[1]
EndFunc

Func Item_GetInventoryInfo($a_s_Info = "")
    Local $l_p_Ptr = Item_GetInventoryPtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "GoldCharacter"
            Return Memory_Read($l_p_Ptr + 0x90, "long")
        Case "GoldStorage"
            Return Memory_Read($l_p_Ptr + 0x94, "long")
        Case "ActiveWeaponSet"
            Return Memory_Read($l_p_Ptr + 0x84, "long")

        Case "BundlePtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x5C, "ptr")
        Case "BundleItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x5C, "ptr"), "dword")
        Case "BundleAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x5C, "ptr") + 0x4, "dword")
        Case "BundleModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x5C, "ptr") + 0x2C, "dword")

        Case "WeaponSet0WeaponPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x64, "ptr")
        Case "WeaponSet0WeaponItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x64, "ptr"), "dword")
        Case "WeaponSet0WeaponAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x64, "ptr") + 0x4, "dword")
        Case "WeaponSet0WeaponModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x64, "ptr") + 0x2C, "dword")

        Case "WeaponSet0OffhandPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x68, "ptr")
        Case "WeaponSet0OffhandItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x68, "ptr"), "dword")
        Case "WeaponSet0OffhandAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x68, "ptr") + 0x4, "dword")
        Case "WeaponSet0OffhandModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x68, "ptr") + 0x2C, "dword")

        Case "WeaponSet1WeaponPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x6C, "ptr")
        Case "WeaponSet1WeaponItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x6C, "ptr"), "dword")
        Case "WeaponSet1WeaponAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x6C, "ptr") + 0x4, "dword")
        Case "WeaponSet1WeaponModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x6C, "ptr") + 0x2C, "dword")

        Case "WeaponSet1OffhandPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x70, "ptr")
        Case "WeaponSet1OffhandItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x70, "ptr"), "dword")
        Case "WeaponSet1OffhandAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x70, "ptr") + 0x4, "dword")
        Case "WeaponSet1OffhandModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x70, "ptr") + 0x2C, "dword")

        Case "WeaponSet2WeaponPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x74, "ptr")
        Case "WeaponSet2WeaponItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x74, "ptr"), "dword")
        Case "WeaponSet2WeaponAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x74, "ptr") + 0x4, "dword")
        Case "WeaponSet2WeaponModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x74, "ptr") + 0x2C, "dword")

        Case "WeaponSet2OffhandPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x78, "ptr")
        Case "WeaponSet2OffhandItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x78, "ptr"), "dword")
        Case "WeaponSet2OffhandAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x78, "ptr") + 0x4, "dword")
        Case "WeaponSet2OffhandModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x78, "ptr") + 0x2C, "dword")

        Case "WeaponSet3WeaponPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x7C, "ptr")
        Case "WeaponSet3WeaponItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x7C, "ptr"), "dword")
        Case "WeaponSet3WeaponAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x7C, "ptr") + 0x4, "dword")
        Case "WeaponSet3WeaponModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x7C, "ptr") + 0x2C, "dword")

        Case "WeaponSet3OffhandPtr" ;<-- Item struct
            Return Memory_Read($l_p_Ptr + 0x80, "ptr")
        Case "WeaponSet3OffhandItemID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x80, "ptr"), "dword")
        Case "WeaponSet3OffhandAgentID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x80, "ptr") + 0x4, "dword")
        Case "WeaponSet3OffhandModelID"
            Return Memory_Read(Memory_Read($l_p_Ptr + 0x80, "ptr") + 0x2C, "dword")
    EndSwitch

    Return 0
EndFunc

Func Item_GetBagPtr($a_v_BagNumber)
    If IsPtr($a_v_BagNumber) Then Return $a_v_BagNumber
    Local $l_ai_Offset[5] = [0, 0x18, 0x40, 0xF8, 0x4 * $a_v_BagNumber]
    Local $l_ap_ItemStructAddress = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, 'ptr')
    Return $l_ap_ItemStructAddress[1]
EndFunc   ;==>GetBagPtr

Func Item_GetBagInfo($a_v_BagNumber, $a_s_Info = "")
    Local $l_p_BagPtr = Item_GetBagPtr($a_v_BagNumber)
    If $l_p_BagPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "BagType"
            Return Memory_Read($l_p_BagPtr, "dword")
        Case "IsInventoryBag"
            If Memory_Read($l_p_BagPtr, "dword") = 1 Then Return True
            Return False
        Case "IsEquipped"
            If Memory_Read($l_p_BagPtr, "dword") = 2 Then Return True
            Return False
        Case "IsNotCollected"
            If Memory_Read($l_p_BagPtr, "dword") = 3 Then Return True
            Return False
        Case "IsStorage"
            If Memory_Read($l_p_BagPtr, "dword") = 4 Then Return True
            Return False
        Case "IsMaterialStorage"
            If Memory_Read($l_p_BagPtr, "dword") = 5 Then Return True
            Return False

        Case "Index"
            Return Memory_Read($l_p_BagPtr + 0x4, "dword")
        Case "ID"
            Return Memory_Read($l_p_BagPtr + 0x8, "dword")
        Case "ContainerItem"
            Return Memory_Read($l_p_BagPtr + 0xC, "dword")
        Case "ItemCount"
            Return Memory_Read($l_p_BagPtr + 0x10, "dword")
        Case "Bag"
            Return Memory_Read($l_p_BagPtr + 0x14, "ptr")
        Case "ItemArray"
            Return Memory_Read($l_p_BagPtr + 0x18, "ptr")
        Case "FakeSlots"
            Return Memory_Read($l_p_BagPtr + 0x1C, "long")
        Case "Slots"
            Return Memory_Read($l_p_BagPtr + 0x20, "long")
        Case "EmptySlots"
            Return Memory_Read($l_p_BagPtr + 0x20, "long") - Memory_Read($l_p_BagPtr + 0x10, "dword")
        Case Else
            Return 0
    EndSwitch

    Return 0
EndFunc

Func Item_GetBagsItembyModelID($a_i_ModelID)
    Local $l_ai_BagList[4] = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2]

    For $l_i_Idx = 0 To UBound($l_ai_BagList) - 1
        Local $l_p_BagPtr = Item_GetBagPtr($l_ai_BagList[$l_i_Idx])
        If $l_p_BagPtr = 0 Then ContinueLoop

        Local $l_ap_ItemArray = Item_GetBagItemArray($l_ai_BagList[$l_i_Idx])

        For $l_i_JIdx = 1 To $l_ap_ItemArray[0]
            Local $l_p_ItemPtr = $l_ap_ItemArray[$l_i_JIdx]
            If Memory_Read($l_p_ItemPtr + 0x2C, "dword") = $a_i_ModelID Then
                Return Memory_Read($l_p_ItemPtr, "dword")
            EndIf
        Next
    Next

    Return 0
EndFunc   ;==>GetBagsItemIDbyModelID

Func Item_GetBagItemArray($a_v_BagNumber)
    Local $l_p_BagPtr = Item_GetBagPtr($a_v_BagNumber)
    If $l_p_BagPtr = 0 Then Return 0

    Local $l_p_ItemArrayPtr = Item_GetBagInfo($a_v_BagNumber, "ItemArray")
    If $l_p_ItemArrayPtr = 0 Then Return 0

    Local $l_i_Slots = Item_GetBagInfo($a_v_BagNumber, "Slots")
    If $l_i_Slots = 0 Then Return 0

    Local $l_ap_ItemArray[$l_i_Slots + 1]
    Local $l_p_ItemPtr, $l_i_Count = 0

    Local $l_d_ItemPtrBuffer = DllStructCreate("ptr[" & $l_i_Slots & "]")
    DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", "handle", $g_h_GWProcess, "ptr", $l_p_ItemArrayPtr, "struct*", $l_d_ItemPtrBuffer, "ulong_ptr", 4 * $l_i_Slots, "ulong_ptr*", 0)

    For $l_i_Idx = 1 To $l_i_Slots
        $l_p_ItemPtr = DllStructGetData($l_d_ItemPtrBuffer, 1, $l_i_Idx)
        If $l_p_ItemPtr = 0 Then ContinueLoop

        $l_i_Count += 1
        $l_ap_ItemArray[$l_i_Count] = $l_p_ItemPtr
    Next

    $l_ap_ItemArray[0] = $l_i_Count
    ReDim $l_ap_ItemArray[$l_i_Count + 1]

    Return $l_ap_ItemArray
EndFunc   ;==>GetBagItemArray

Func Item_GetInventoryArray($a_b_IncludeEquipmentPack = False)
    Local Const $LC_I_OFFSET_ITEMID = 0x0
    Local Const $LC_I_OFFSET_BAG = 0xC
    Local Const $LC_I_OFFSET_ITEMTYPE = 0x20
    Local Const $LC_I_OFFSET_EXTRAID = 0x22
    Local Const $LC_I_OFFSET_VALUE = 0x24
    Local Const $LC_I_OFFSET_ITEMFLAG = 0x28
    Local Const $LC_I_OFFSET_MODELID = 0x2C
    Local Const $LC_I_OFFSET_RARITY = 0x38
    Local Const $LC_I_OFFSET_MATSALV = 0x4A
    Local Const $LC_I_OFFSET_QUANTITY = 0x4C
    Local Const $LC_I_OFFSET_SLOT = 0x50
    Local Const $LC_I_BYTE_PADDING = 0x1

    Local Const $LC_I_INVENTORY_ARRAY_COLS = 13

    If $a_b_IncludeEquipmentPack Then
        Local $l_ai_BagList = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2, $GC_I_INVENTORY_EQUIPMENT_PACK]
        Local $l_i_MaxBagSlots = 80
    Else
        Local $l_ai_BagList = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2]
        Local $l_i_MaxBagSlots = 60
    EndIf

    Static $s_d_Struct_Item = DllStructCreate( _
        "dword ItemID;" & _
        "byte[" & ($LC_I_OFFSET_BAG - ($LC_I_OFFSET_ITEMID + 4)) & "];" & _
        "ptr Bag;" & _
        "byte[" & ($LC_I_OFFSET_ITEMTYPE - ($LC_I_OFFSET_BAG + 4)) & "];" & _
        "byte ItemType;" & _
        "byte[" & ($LC_I_OFFSET_EXTRAID - ($LC_I_OFFSET_ITEMTYPE + 1)) & "];" & _
        "byte ExtraID;" & _
        "byte[" & ($LC_I_OFFSET_VALUE - ($LC_I_OFFSET_EXTRAID + 1)) & "];" & _
        "short Value;" & _
        "byte[" & ($LC_I_OFFSET_ITEMFLAG - ($LC_I_OFFSET_VALUE + 2)) & "];" & _
        "dword ItemFlag;" & _
        "dword ModelID;" & _
        "byte[" & ($LC_I_OFFSET_RARITY - ($LC_I_OFFSET_MODELID + 4)) & "];" & _
        "ptr Rarity;" & _
        "byte[" & ($LC_I_OFFSET_MATSALV - ($LC_I_OFFSET_RARITY + 4)) & "];" & _
        "byte IsMaterialSalvageable;" & _
        "byte[" & ($LC_I_OFFSET_QUANTITY - ($LC_I_OFFSET_MATSALV + 1)) & "];" & _
        "short Quantity;" & _
        "byte[" & ($LC_I_OFFSET_SLOT - ($LC_I_OFFSET_QUANTITY + 2)) & "];" & _
        "byte Slot" _
    )
    Static $s_i_StructSize_Item = DllStructGetSize($s_d_Struct_Item)

    Local $l_amx2_Inventory[$l_i_MaxBagSlots][$LC_I_INVENTORY_ARRAY_COLS]
    Local $l_i_Inventory_Idx = 0

    For $l_i_Idx = 0 To UBound($l_ai_BagList) - 1
        Local $l_p_BagPtr = Item_GetBagPtr($l_ai_BagList[$l_i_Idx])
        If $l_p_BagPtr = 0 Then ContinueLoop

        Local $l_ap_ItemArray = Item_GetBagItemArray($l_ai_BagList[$l_i_Idx])
        Local $l_i_ItemCount = $l_ap_ItemArray[0]

        For $l_i_Jdx = 1 To $l_i_ItemCount
            Local $l_p_CacheItemPtr = $l_ap_ItemArray[$l_i_Jdx]
            If $l_p_CacheItemPtr = 0 Then ContinueLoop

            DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
                "handle", $g_h_GWProcess, _
                "ptr", $l_p_CacheItemPtr, _
                "struct*", $s_d_Struct_Item, _
                "ulong_ptr", $s_i_StructSize_Item, _
                "ulong_ptr*", 0 _
            )

            Local $l_i_ItemFlag = DllStructGetData($s_d_Struct_Item, "ItemFlag")

            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_PTR] = $l_p_CacheItemPtr
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_ITEMID] = DllStructGetData($s_d_Struct_Item, "ItemID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_BAG] = Memory_Read(DllStructGetData($s_d_Struct_Item, "Bag"), "byte")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_ITEMTYPE] = DllStructGetData($s_d_Struct_Item, "ItemType")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_EXTRAID] = DllStructGetData($s_d_Struct_Item, "ExtraID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_VALUE] = DllStructGetData($s_d_Struct_Item, "Value")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_ISIDENTIFIED] = BitAND($l_i_ItemFlag, 0x1) > 0
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_ISINSCRIBABLE] = BitAND($l_i_ItemFlag, 0x08000000) > 0
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_MODELID] = DllStructGetData($s_d_Struct_Item, "ModelID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_RARITY] = Memory_Read(DllStructGetData($s_d_Struct_Item, "Rarity"), "ushort")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_ISMATERIALSALVAGEABLE] = DllStructGetData($s_d_Struct_Item, "IsMaterialSalvageable")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_QUANTITY] = DllStructGetData($s_d_Struct_Item, "Quantity")
            $l_amx2_Inventory[$l_i_Inventory_Idx][$GC_I_INVENTORY_SLOT] = DllStructGetData($s_d_Struct_Item, "Slot")
            $l_i_Inventory_Idx += 1
        Next
    Next

    ReDim $l_amx2_Inventory[$l_i_Inventory_Idx][$LC_I_INVENTORY_ARRAY_COLS]

    Return $l_amx2_Inventory
EndFunc

Func Item_GetItemBySlot($a_v_BagNumber, $a_i_Slot)
    If $a_i_Slot < 1 Or $a_i_Slot > Item_GetBagInfo($a_v_BagNumber, "Slots") Then Return 0

    Local $l_p_BagPtr = Item_GetBagPtr($a_v_BagNumber)
    Local $l_p_ItemPtr = Memory_Read($l_p_BagPtr + 0x18, 'ptr')

    Return Memory_Read($l_p_ItemPtr + 0x4 * ($a_i_Slot - 1), 'ptr')
EndFunc   ;==>GetItemBySlot

Func Item_ItemID($a_v_Item)
    If IsPtr($a_v_Item) Then
        Return Memory_Read($a_v_Item, "long")
    ElseIf IsDllStruct($a_v_Item) Then
        Return DllStructGetData($a_v_Item, "ID")
    Else
        Return $a_v_Item
    EndIf
EndFunc   ;==>ItemID

Func Item_GetItemPtr($a_v_ItemID)
    If IsPtr($a_v_ItemID) Then Return $a_v_ItemID
    Local $l_ai_Offset[5] = [0, 0x18, 0x40, 0xB8, 0x4 * Item_ItemID($a_v_ItemID)]
    Local $l_ap_ItemStructAddress = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_ItemStructAddress[1]
EndFunc   ;==>GetItemPtr

Func Item_GetItemInfoByItemID($a_v_ItemID, $a_s_Info = "")
    Local $l_p_ItemPtr = Item_GetItemPtr($a_v_ItemID)
    If $l_p_ItemPtr = 0 Or $a_s_Info = "" Then Return 0

    Return Item_GetItemInfoByPtr($l_p_ItemPtr, $a_s_Info)
EndFunc   ;==>GetItemInfo

Func Item_GetItemInfoByAgentID($a_i_AgentID, $a_s_Info = "")
    Local $l_i_ItemID = Item_FindItemByAgentID($a_i_AgentID)
    If $l_i_ItemID = 0 Then Return 0

    If $a_s_Info = "" Then Return $l_i_ItemID
    Local $l_p_ItemPtr = Item_GetItemPtr($l_i_ItemID)
    Return Item_GetItemInfoByPtr($l_p_ItemPtr, $a_s_Info)
EndFunc   ;==>GetItemInfoByAgentID

Func Item_GetItemInfoByModelID($a_i_ModelID, $a_s_Info = "")
    Local $l_i_ItemID = Item_FindItemByModelID($a_i_ModelID)
    If $l_i_ItemID = 0 Then Return 0

    If $a_s_Info = "" Then Return $l_i_ItemID
    Local $l_p_ItemPtr = Item_GetItemPtr($l_i_ItemID)
    Return Item_GetItemInfoByPtr($l_p_ItemPtr, $a_s_Info)
EndFunc   ;==>GetItemInfoByModelID

Func Item_GetItemInfoByPtr($a_p_ItemPtr, $a_s_Info)
    Switch $a_s_Info
        Case "ItemID"
            Return Memory_Read($a_p_ItemPtr, "dword")
        Case "AgentID"
            Return Memory_Read($a_p_ItemPtr + 0x4, "dword")
        Case "BagEquipped"
            Return Memory_Read($a_p_ItemPtr + 0x8, "ptr")
        Case "Bag"
            Return Memory_Read($a_p_ItemPtr + 0xC, "ptr")

        Case "ModStruct"
            Return Memory_Read($a_p_ItemPtr + 0x10, "ptr")
        Case "ModStructSize"
            Return Memory_Read($a_p_ItemPtr + 0x14, "dword")

        Case "Customized"
            Return Memory_Read($a_p_ItemPtr + 0x18, "ptr")
        Case "ModelFileID"
            Return Memory_Read($a_p_ItemPtr + 0x1C, "dword")

        Case "ItemType"
            Return Memory_Read($a_p_ItemPtr + 0x20, "byte")
        Case "IsMaterial"
            If Memory_Read($a_p_ItemPtr + 0x20, "byte") <> 11 Then Return False
            Return True

        Case "Dye1"
            Return Memory_Read($a_p_ItemPtr + 0x21, "byte")
        Case "Dye2"
            Return Memory_Read($a_p_ItemPtr + 0x22, "byte")
        Case "Dye3"
            Return Memory_Read($a_p_ItemPtr + 0x23, "byte")

        Case "ExtraID"
            Return Memory_Read($a_p_ItemPtr + 0x22, "byte")

        Case "Value"
            Return Memory_Read($a_p_ItemPtr + 0x24, "Short")
        Case "h0026"
            Return Memory_Read($a_p_ItemPtr + 0x26, "Short")

        Case "Interaction"
            Return Memory_Read($a_p_ItemPtr + 0x28, "dword")
        Case "IsIdentified"
            Return BitAND(Memory_Read($a_p_ItemPtr + 0x28, "dword"), 0x1) > 0
        Case "IsCommonMaterial"
            Return BitAND(Memory_Read($a_p_ItemPtr + 0x28, "dword"), 0x20) > 0
        Case "IsStackable"
            Return BitAND(Memory_Read($a_p_ItemPtr + 0x28, "dword"), 0x80000) > 0
        Case "IsInscribable"
            Return BitAND(Memory_Read($a_p_ItemPtr + 0x28, "dword"), 0x08000000) > 0

        Case "ModelID"
            Return Memory_Read($a_p_ItemPtr + 0x2C, "dword")
        Case "InfoString"
            Return Memory_Read($a_p_ItemPtr + 0x30, "ptr")

        Case "NameEnc"
            Return Memory_Read($a_p_ItemPtr + 0x34, "ptr")
        Case "Rarity"
            Local $l_p_RarityPtr = Memory_Read($a_p_ItemPtr + 0x38, "ptr")
            Return Memory_Read($l_p_RarityPtr, 'ushort')

        Case "CompleteNameEnc"
            Return Memory_Read($a_p_ItemPtr + 0x38, "ptr")
        Case "SingleItemName"
            Return Memory_Read($a_p_ItemPtr + 0x3C, "ptr")
        Case "h0040[2]"
            Return Memory_Read($a_p_ItemPtr + 0x40, "long")
        Case "ItemFormula"
            Return Memory_Read($a_p_ItemPtr + 0x48, "Short")
        Case "IsMaterialSalvageable"
            Return Memory_Read($a_p_ItemPtr + 0x4A, "byte")
        Case "h004B"
            Return Memory_Read($a_p_ItemPtr + 0x4B, "byte")
        Case "Quantity"
            Return Memory_Read($a_p_ItemPtr + 0x4C, "short")
        Case "Equipped"
            Return Memory_Read($a_p_ItemPtr + 0x4E, "byte")
        Case "Profession"
            Return Memory_Read($a_p_ItemPtr + 0x4F, "byte")
        Case "Slot"
            Return Memory_Read($a_p_ItemPtr + 0x50, "byte")
        Case Else
            Return 0
    EndSwitch
EndFunc   ;==>GetItemInfoByPtr

Func Item_GetItemIsCommonMaterial($a_p_Item)
    Local $l_p_Item = Item_GetItemPtr($a_p_Item)
    Local $l_i_Item_ModelID = Memory_Read($l_p_Item + 0x2C, "dword")
    Local $l_b_IsCommon = False

    For $i = 1 To $GC_AI_COMMON_MATERIALS[0]
        If $GC_AI_COMMON_MATERIALS[$i] = $l_i_Item_ModelID Then
            $l_b_IsCommon = True
            ExitLoop
        EndIf
    Next
    Return $l_b_IsCommon
EndFunc

Func Item_GetItemIsRareMaterial($a_p_Item)
    Local $l_p_Item = Item_GetItemPtr($a_p_Item)
    Local $l_i_Item_ModelID = Memory_Read($l_p_Item + 0x2C, "dword")
    Local $l_b_IsRare = False

    For $i = 1 To $GC_AI_RARE_MATERIALS[0]
        If $GC_AI_RARE_MATERIALS[$i] = $l_i_Item_ModelID Then
            $l_b_IsRare = True
            ExitLoop
        EndIf
    Next
    Return $l_b_IsRare
EndFunc

Func Item_FindItemByModelID($a_i_ModelID)
    Local $l_ap_ItemArray = Item_GetItemArray()

    For $l_i_Idx = 1 To $l_ap_ItemArray[0]
        Local $l_p_ItemPtr = $l_ap_ItemArray[$l_i_Idx]
        If Memory_Read($l_p_ItemPtr + 0x2C, "dword") = $a_i_ModelID Then
            Return Memory_Read($l_p_ItemPtr, "dword")
        EndIf
    Next

    Return 0
EndFunc   ;==>FindItemByModelID

Func Item_FindItemByAgentID($a_i_AgentID)
    Local $l_ap_ItemArray = Item_GetItemArray()

    For $l_i_Idx = 1 To $l_ap_ItemArray[0]
        Local $l_p_ItemPtr = $l_ap_ItemArray[$l_i_Idx]
        If Memory_Read($l_p_ItemPtr + 0x4, "dword") = $a_i_AgentID Then
            Return Memory_Read($l_p_ItemPtr, "dword")
        EndIf
    Next

    Return 0
EndFunc   ;==>FindItemByAgentID

Func Item_GetMaxItems()
    Local $l_ai_Offset[4] = [0, 0x18, 0x40, 0xB8 + 0x8]
    Local $l_ai_ItemStructAddress = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "dword")
    Return $l_ai_ItemStructAddress[1]
EndFunc   ;==>GetMaxItems

Func Item_GetItemArray()
    Local $l_i_MaxItems = Item_GetMaxItems()
    If $l_i_MaxItems <= 0 Then Return

    Local $l_ai_Offset[4] = [0, 0x18, 0x40, 0xB8]
    Local $l_ai_ItemStructAddress = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "dword")

    Local $l_ap_ItemArray[$l_i_MaxItems + 1]
    Local $l_p_Ptr, $l_i_Count = 0
    Local $l_p_ItemBasePtr = $l_ai_ItemStructAddress[1]
    Local $l_d_ItemPtrBuffer = DllStructCreate("ptr[" & $l_i_MaxItems & "]")

    DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", "handle", $g_h_GWProcess, "ptr", $l_p_ItemBasePtr, "struct*", $l_d_ItemPtrBuffer, "ulong_ptr", 4 * $l_i_MaxItems, "ulong_ptr*", 0)

    For $l_i_Idx = 1 To $l_i_MaxItems
        $l_p_Ptr = DllStructGetData($l_d_ItemPtrBuffer, 1, $l_i_Idx)
        If $l_p_Ptr = 0 Then ContinueLoop

        $l_i_Count += 1
        $l_ap_ItemArray[$l_i_Count] = $l_p_Ptr
    Next

    $l_ap_ItemArray[0] = $l_i_Count
    ReDim $l_ap_ItemArray[$l_i_Count + 1]

    Return $l_ap_ItemArray
EndFunc   ;==>GetItemArray

;~ Description: Returns modstruct of an item.
Func Item_GetModStruct($a_v_Item)
    If Not IsPtr($a_v_Item) Then $a_v_Item= Item_GetItemPtr($a_v_Item)
    If Item_GetItemInfoByPtr($a_v_Item, "ModStruct") = 0 Then Return
    Return Memory_Read(Item_GetItemInfoByPtr($a_v_Item, "ModStruct"), 'Byte[' & Item_GetItemInfoByPtr($a_v_Item, "ModStructSize") * 4 & ']')
EndFunc   ;==>Item_GetModStruct

;~ Description: Returns 1 for Rune, 2 for Insignia, 0 if not found.
Func Item_IsRuneOrInsignia($a_i_ModelID)
	Switch $a_i_ModelID
		Case 903, 5558, 5559 ; Warrior Runes
			Return 1
		Case 19152 to 19156 ; Warrior Insignias
			Return 2
		Case 5560, 5561, 904 ; Ranger Runes
			Return 1
		Case 19157 to 19162 ; Ranger Insignias
			Return 2
		Case 5556, 5557, 902 ; Monk Runes
			Return 1
		Case 19149 to 19151 ; Monk Insignias
			Return 2
		Case 5552, 5553, 900 ; Necromancer Runes
			Return 1
		Case 19138 to 19143 ; Necromancer Insignias
			Return 2
		Case 3612, 5549, 899 ; Mesmer Runes
			Return 1
		Case 19128, 19130, 19129 ; Mesmer Insignias
			Return 2
		Case 5554, 5555, 901 ; Elementalist Runes
			Return 1
		Case 19144 to 19148 ; Elementalist Insignias
			Return 2
		Case 6327 to 6329 ; Ritualist Runes
			Return 1
		Case 19165 to 19167 ; Ritualist Insignias
			Return 2
		Case 6324 to 6326 ; Assassin Runes
			Return 1
		Case 19124 to 19127 ; Assassin Insignia
			Return 2
		Case 15545 to 15547 ; Dervish Runes
			Return 1
		Case 19163 to 19164 ; Dervish Insignias
			Return 2
		Case 15548 to 15550 ; Paragon Runes
			Return 1
		Case 19168  ; Paragon Insignias
			Return 2
		Case 5550, 5551, 898 ; All Profession Runes
			Return 1
		Case 19131 to 19137 ; All Profession Insignias
			Return 2
		Case Else
			Return 0
   EndSwitch
EndFunc   ;==>IsRuneOrInsignia
#EndRegion Item Context