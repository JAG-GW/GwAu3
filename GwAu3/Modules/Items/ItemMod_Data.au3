#include-once

#Region Item Context
Func GwAu3_ItemMod_GetItemContextPtr()
    Local $lOffset[3] = [0, 0x18, 0x40]
    Local $lItemContextPtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lItemContextPtr[1]
EndFunc

Func GwAu3_ItemMod_GetInventoryPtr()
	Local $lOffset[4] = [0, 0x18, 0x40, 0xF8]
    Local $lItemContextPtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lItemContextPtr[1]
EndFunc

Func GwAu3_ItemMod_GetInventoryInfo($aInfo = "")
    Local $lPtr = GwAu3_ItemMod_GetInventoryPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "GoldCharacter"
            Return GwAu3_Memory_Read($lPtr + 0x90, "long")
        Case "GoldStorage"
            Return GwAu3_Memory_Read($lPtr + 0x94, "long")
        Case "ActiveWeaponSet"
            Return GwAu3_Memory_Read($lPtr + 0x84, "long")

        Case "BundlePtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x5C, "ptr")
		Case "BundleItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x5C, "ptr"), "dword")
		Case "BundleAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x5C, "ptr") + 0x4, "dword")
		Case "BundleModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x5C, "ptr") + 0x2C, "dword")


        Case "WeaponSet0WeaponPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x64, "ptr")
		Case "WeaponSet0WeaponItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x64, "ptr"), "dword")
		Case "WeaponSet0WeaponAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x64, "ptr") + 0x4, "dword")
		Case "WeaponSet0WeaponModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x64, "ptr") + 0x2C, "dword")


        Case "WeaponSet0OffhandPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x68, "ptr")
		Case "WeaponSet0OffhandItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x68, "ptr"), "dword")
		Case "WeaponSet0OffhandAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x68, "ptr") + 0x4, "dword")
		Case "WeaponSet0OffhandModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x68, "ptr") + 0x2C, "dword")


        Case "WeaponSet1WeaponPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x6C, "ptr")
		Case "WeaponSet1WeaponItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x6C, "ptr"), "dword")
		Case "WeaponSet1WeaponAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x6C, "ptr") + 0x4, "dword")
		Case "WeaponSet1WeaponModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x6C, "ptr") + 0x2C, "dword")


        Case "WeaponSet1OffhandPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x70, "ptr")
		Case "WeaponSet1OffhandItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x70, "ptr"), "dword")
		Case "WeaponSet1OffhandAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x70, "ptr") + 0x4, "dword")
		Case "WeaponSet1OffhandModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x70, "ptr") + 0x2C, "dword")


        Case "WeaponSet2WeaponPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x74, "ptr")
		Case "WeaponSet2WeaponItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x74, "ptr"), "dword")
		Case "WeaponSet2WeaponAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x74, "ptr") + 0x4, "dword")
		Case "WeaponSet2WeaponModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x74, "ptr") + 0x2C, "dword")


        Case "WeaponSet2OffhandPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x78, "ptr")
		Case "WeaponSet2OffhandItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x78, "ptr"), "dword")
		Case "WeaponSet2OffhandAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x78, "ptr") + 0x4, "dword")
		Case "WeaponSet2OffhandModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x78, "ptr") + 0x2C, "dword")


        Case "WeaponSet3WeaponPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x7C, "ptr")
		Case "WeaponSet3WeaponItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x7C, "ptr"), "dword")
		Case "WeaponSet3WeaponAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x7C, "ptr") + 0x4, "dword")
		Case "WeaponSet3WeaponModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x7C, "ptr") + 0x2C, "dword")


        Case "WeaponSet3OffhandPtr" ;<-- Item struct
            Return GwAu3_Memory_Read($lPtr + 0x80, "ptr")
		Case "WeaponSet3OffhandItemID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x80, "ptr"), "dword")
		Case "WeaponSet3OffhandAgentID"
			Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x80, "ptr") + 0x4, "dword")
		Case "WeaponSet3OffhandModelID"
            Return  GwAu3_Memory_Read(GwAu3_Memory_Read($lPtr + 0x80, "ptr") + 0x2C, "dword")
    EndSwitch

    Return 0
EndFunc

Global Enum $INVENTORY_unused_bag, $INVENTORY_backpack, $INVENTORY_belt_pouch, $INVENTORY_bag1, $INVENTORY_bag2, $INVENTORY_equipment_pack, $INVENTORY_material_storage, $INVENTORY_unclaimed_items, _
			$INVENTORY_storage1, $INVENTORY_storage2, $INVENTORY_storage3, $INVENTORY_storage4, $INVENTORY_storage5, $INVENTORY_storage6, $INVENTORY_storage7, _
			$INVENTORY_storage8, $INVENTORY_storage9, $INVENTORY_storage10, $INVENTORY_storage11, $INVENTORY_storage12, $INVENTORY_storage13, $INVENTORY_storage14, $INVENTORY_equipped_items

Func GwAu3_ItemMod_GetBagPtr($aBagNumber)
    If IsPtr($aBagNumber) Then Return $aBagNumber
	Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x4 * $aBagNumber]
	Local $lItemStructAddress = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, 'ptr')
	Return $lItemStructAddress[1]
EndFunc   ;==>_ItemMod_GetBagPtr

Func GwAu3_ItemMod_GetBagInfo($aBagNumber, $aInfo = "")
    Local $lBagPtr = GwAu3_ItemMod_GetBagPtr($aBagNumber)
    If $lBagPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "BagType"
            Return GwAu3_Memory_Read($lBagPtr, "dword")
		Case "IsInventoryBag"
			If GwAu3_Memory_Read($lBagPtr, "dword") = 1 Then Return True
			Return False
		Case "IsEquipped"
			If GwAu3_Memory_Read($lBagPtr, "dword") = 2 Then Return True
			Return False
		Case "IsNotCollected"
			If GwAu3_Memory_Read($lBagPtr, "dword") = 3 Then Return True
			Return False
		Case "IsStorage"
			If GwAu3_Memory_Read($lBagPtr, "dword") = 4 Then Return True
			Return False
		Case "IsMaterialStorage"
			If GwAu3_Memory_Read($lBagPtr, "dword") = 5 Then Return True
			Return False

        Case "Index"
            Return GwAu3_Memory_Read($lBagPtr + 0x4, "dword")
		Case "ID"
            Return GwAu3_Memory_Read($lBagPtr + 0x8, "dword")
		Case "ContainerItem"
            Return GwAu3_Memory_Read($lBagPtr + 0xC, "dword")
		Case "ItemCount"
            Return GwAu3_Memory_Read($lBagPtr + 0x10, "dword")
		Case "Bag"
            Return GwAu3_Memory_Read($lBagPtr + 0x14, "ptr")
		Case "ItemArray"
            Return GwAu3_Memory_Read($lBagPtr + 0x18, "ptr")
		Case "FakeSlots"
            Return GwAu3_Memory_Read($lBagPtr + 0x1C, "long")
		Case "Slots"
            Return GwAu3_Memory_Read($lBagPtr + 0x20, "long")
		Case "EmptySlots"
			Return GwAu3_Memory_Read($lBagPtr + 0x20, "long") - GwAu3_Memory_Read($lBagPtr + 0x10, "dword")
		Case Else
			Return 0
	EndSwitch

    Return 0
EndFunc

Func GwAu3_ItemMod_GetBagsItembyModelID($aModelID)
    Local $lBagList[4] = [$INVENTORY_backpack, $INVENTORY_belt_pouch, $INVENTORY_bag1, $INVENTORY_bag2]

    For $i = 0 To UBound($lBagList) - 1
        Local $lBagPtr = GwAu3_ItemMod_GetBagPtr($lBagList[$i])
        If $lBagPtr = 0 Then ContinueLoop

        Local $lItemArray = GwAu3_ItemMod_GetBagItemArray($lBagList[$i])

        For $j = 1 To $lItemArray[0]
            Local $lItemPtr = $lItemArray[$j]
            If GwAu3_Memory_Read($lItemPtr + 0x2C, "dword") = $aModelID Then
                Return GwAu3_Memory_Read($lItemPtr, "dword")
            EndIf
        Next
    Next

    Return 0
EndFunc   ;==>GetBagsItemIDbyModelID

Func GwAu3_ItemMod_GetBagItemArray($aBagNumber)
    Local $lBagPtr = GwAu3_ItemMod_GetBagPtr($aBagNumber)
    If $lBagPtr = 0 Then Return 0

    Local $lItemArrayPtr = GwAu3_ItemMod_GetBagInfo($aBagNumber, "ItemArray")
    If $lItemArrayPtr = 0 Then Return 0

    Local $lSlots = GwAu3_ItemMod_GetBagInfo($aBagNumber, "Slots")
    If $lSlots = 0 Then Return 0

    Local $lItemArray[$lSlots + 1]
    Local $lItemPtr, $lCount = 0

    Local $lItemPtrBuffer = DllStructCreate("ptr[" & $lSlots & "]")
    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, "ptr", $lItemArrayPtr, "struct*", $lItemPtrBuffer, "ulong_ptr", 4 * $lSlots, "ulong_ptr*", 0)

    For $i = 1 To $lSlots
        $lItemPtr = DllStructGetData($lItemPtrBuffer, 1, $i)
        If $lItemPtr = 0 Then ContinueLoop

        $lCount += 1
        $lItemArray[$lCount] = $lItemPtr
    Next

    $lItemArray[0] = $lCount
    ReDim $lItemArray[$lCount + 1]

    Return $lItemArray
EndFunc   ;==>_ItemMod_GetBagItemArray

Func GwAu3_ItemMod_GetItemBySlot($aBagNumber, $aSlot)
	If $aSlot < 1 Or $aSlot > GwAu3_ItemMod_GetBagInfo($aBagNumber, "Slots") Then Return 0

	Local $lBagPtr = GwAu3_ItemMod_GetBagPtr($aBagNumber)
	Local $lItemPtr = GwAu3_Memory_Read($lBagPtr + 0x18, 'ptr')

	Return GwAu3_Memory_Read($lItemPtr + 0x4 * ($aSlot - 1), 'ptr')
EndFunc   ;==>_ItemMod_GetItemBySlot

Func GwAu3_ItemMod_ItemID($aItem)
	If IsPtr($aItem) Then
		Return GwAu3_Memory_Read($aItem, "long")
	ElseIf IsDllStruct($aItem) Then
		Return DllStructGetData($aItem, "ID")
	Else
		Return $aItem
	EndIf
EndFunc   ;==>ItemID

Func GwAu3_ItemMod_GetItemPtr($aItemID)
	If IsPtr($aItemID) Then Return $aItemID
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0x4 * GwAu3_ItemMod_ItemID($aItemID)]
	Local $lItemStructAddress = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "ptr")
	Return $lItemStructAddress[1]
EndFunc   ;==>_ItemMod_GetItemPtr

Func GwAu3_ItemMod_GetItemInfoByItemID($aItemID, $aInfo = "")
    Local $lItemPtr = GwAu3_ItemMod_GetItemPtr($aItemID)
    If $lItemPtr = 0 Or $aInfo = "" Then Return 0

    Return GwAu3_ItemMod_GetItemInfoByPtr($lItemPtr, $aInfo)
EndFunc   ;==>GetItemInfo

Func GwAu3_ItemMod_GetItemInfoByAgentID($aAgentID, $aInfo = "")
    Local $lItemID = GwAu3_ItemMod_FindItemByAgentID($aAgentID)
    If $lItemID = 0 Then Return 0

    If $aInfo = "" Then Return $lItemID
	Local $lItemPtr = GwAu3_ItemMod_GetItemPtr($lItemID)
    Return GwAu3_ItemMod_GetItemInfoByPtr($lItemPtr, $aInfo)
EndFunc   ;==>_ItemMod_GetItemInfoByAgentID

Func GwAu3_ItemMod_GetItemInfoByModelID($aModelID, $aInfo = "")
    Local $lItemID = GwAu3_ItemMod_FindItemByModelID($aModelID)
    If $lItemID = 0 Then Return 0

    If $aInfo = "" Then Return $lItemID
	Local $lItemPtr = GwAu3_ItemMod_GetItemPtr($lItemID)
    Return GwAu3_ItemMod_GetItemInfoByPtr($lItemPtr, $aInfo)
EndFunc   ;==>_ItemMod_GetItemInfoByModelID

Func GwAu3_ItemMod_GetItemInfoByPtr($lItemPtr, $aInfo)
    Switch $aInfo
        Case "ItemID"
            Return GwAu3_Memory_Read($lItemPtr, "dword")
        Case "AgentID"
            Return GwAu3_Memory_Read($lItemPtr + 0x4, "dword")
        Case "BagEquipped"
            Return GwAu3_Memory_Read($lItemPtr + 0x8, "ptr")
        Case "Bag"
            Return GwAu3_Memory_Read($lItemPtr + 0xC, "ptr")

        Case "ModStruct"
            Return GwAu3_Memory_Read($lItemPtr + 0x10, "ptr")
        Case "ModStructSize"
            Return GwAu3_Memory_Read($lItemPtr + 0x14, "dword")

        Case "Customized"
            Return GwAu3_Memory_Read($lItemPtr + 0x18, "ptr")
        Case "ModelFileID"
            Return GwAu3_Memory_Read($lItemPtr + 0x1C, "dword")

        Case "ItemType"
            Return GwAu3_Memory_Read($lItemPtr + 0x20, "byte")
		Case "IsMaterial"
			If GwAu3_Memory_Read($lItemPtr + 0x20, "byte") <> 11 Then Return False
			Return True

        Case "Dye1"
            Return GwAu3_Memory_Read($lItemPtr + 0x21, "byte")
        Case "Dye2"
            Return GwAu3_Memory_Read($lItemPtr + 0x22, "byte")
        Case "Dye3"
            Return GwAu3_Memory_Read($lItemPtr + 0x23, "byte")

        Case "ExtraID"
            Return GwAu3_Memory_Read($lItemPtr + 0x22, "byte")

         Case "Value"
            Return GwAu3_Memory_Read($lItemPtr + 0x24, "Short")
        Case "h0026"
            Return GwAu3_Memory_Read($lItemPtr + 0x26, "Short")

        Case "Interaction"
            Return GwAu3_Memory_Read($lItemPtr + 0x28, "dword")
        Case "IsIdentified"
            Return BitAND(GwAu3_Memory_Read($lItemPtr + 0x28, "dword"), 0x1) > 0
        Case "IsCommonMaterial"
            Return BitAND(GwAu3_Memory_Read($lItemPtr + 0x28, "dword"), 0x20) > 0
        Case "IsStackable"
            Return BitAND(GwAu3_Memory_Read($lItemPtr + 0x28, "dword"), 0x80000) > 0
        Case "IsInscribable"
            Return BitAND(GwAu3_Memory_Read($lItemPtr + 0x28, "dword"), 0x08000000) > 0

        Case "ModelID"
            Return GwAu3_Memory_Read($lItemPtr + 0x2C, "dword")
        Case "InfoString"
            Return GwAu3_Memory_Read($lItemPtr + 0x30, "ptr")

        Case "NameEnc"
            Return GwAu3_Memory_Read($lItemPtr + 0x34, "ptr")
		Case "Rarity"
			Local $lRarityPtr = GwAu3_Memory_Read($lItemPtr + 0x38, "ptr")
			Return GwAu3_Memory_Read($lRarityPtr, 'ushort')

        Case "CompleteNameEnc"
            Return GwAu3_Memory_Read($lItemPtr + 0x38, "ptr")
        Case "SingleItemName"
            Return GwAu3_Memory_Read($lItemPtr + 0x3C, "ptr")
        Case "h0040[2]"
            Return GwAu3_Memory_Read($lItemPtr + 0x40, "long")
        Case "ItemFormula"
            Return GwAu3_Memory_Read($lItemPtr + 0x48, "Short")
        Case "IsMaterialSalvageable"
            Return GwAu3_Memory_Read($lItemPtr + 0x4A, "byte")
        Case "h004B"
            Return GwAu3_Memory_Read($lItemPtr + 0x4B, "byte")
        Case "Quantity"
            Return GwAu3_Memory_Read($lItemPtr + 0x4C, "short")
        Case "Equipped"
            Return GwAu3_Memory_Read($lItemPtr + 0x4E, "byte")
        Case "Profession"
            Return GwAu3_Memory_Read($lItemPtr + 0x4F, "byte")
        Case "Slot"
            Return GwAu3_Memory_Read($lItemPtr + 0x50, "byte")
        Case Else
            Return 0
    EndSwitch
EndFunc   ;==>_ItemMod_GetItemInfoByPtr

Func GwAu3_ItemMod_FindItemByModelID($aModelID)
    Local $lItemArray = GwAu3_ItemMod_GetItemArray()

    For $i = 1 To $lItemArray[0]
        Local $lItemPtr = $lItemArray[$i]
        If GwAu3_Memory_Read($lItemPtr + 0x2C, "dword") = $aModelID Then
            Return GwAu3_Memory_Read($lItemPtr, "dword")
        EndIf
    Next

    Return 0
EndFunc   ;==>_ItemMod_FindItemByModelID

Func GwAu3_ItemMod_FindItemByAgentID($aAgentID)
    Local $lItemArray = GwAu3_ItemMod_GetItemArray()

    For $i = 1 To $lItemArray[0]
        Local $lItemPtr = $lItemArray[$i]
        If GwAu3_Memory_Read($lItemPtr + 0x4, "dword") = $aAgentID Then
            Return GwAu3_Memory_Read($lItemPtr, "dword")
        EndIf
    Next

    Return 0
EndFunc   ;==>__ItemMod_FindItemByAgentID

Func GwAu3_ItemMod_GetMaxItems()
	Local $lOffset[4] = [0, 0x18, 0x40, 0xB8 + 0x8]
	Local $lItemStructAddress = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "dword")
	Return $lItemStructAddress[1]
EndFunc   ;==>_ItemMod_GetMaxItems

Func GwAu3_ItemMod_GetItemArray()
	Local $lMaxItems = GwAu3_ItemMod_GetMaxItems()
    If $lMaxItems <= 0 Then Return

	Local $lOffset[4] = [0, 0x18, 0x40, 0xB8]
	Local $lItemStructAddress = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "dword")

	Local $lItemArray[$lMaxItems + 1]
    Local $lPtr, $lCount = 0
    Local $lItemBasePtr = $lItemStructAddress[1]
    Local $lItemPtrBuffer = DllStructCreate("ptr[" & $lMaxItems & "]")

    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, "ptr", $lItemBasePtr, "struct*", $lItemPtrBuffer, "ulong_ptr", 4 * $lMaxItems, "ulong_ptr*", 0)

    For $i = 1 To $lMaxItems
        $lPtr = DllStructGetData($lItemPtrBuffer, 1, $i)
        If $lPtr = 0 Then ContinueLoop

        $lCount += 1
        $lItemArray[$lCount] = $lPtr
    Next

    $lItemArray[0] = $lCount
    ReDim $lItemArray[$lCount + 1]

    Return $lItemArray
EndFunc   ;==>_ItemMod_GetItemArray

#EndRegion Item Context
