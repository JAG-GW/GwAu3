#include-once

;~ Description: Internal use for BuyItem()
Func GwAu3_Merchant_GetMerchantItemsBase()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x24]
    Local $l_av_Return = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsBase

;~ Description: Internal use for BuyItem()
Func GwAu3_Merchant_GetMerchantItemsSize()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x28]
    Local $l_av_Return = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsSize

Func GwAu3_Merchant_GetMerchantItemPtr($a_i_ModelID = 0, $a_b_ByModelID = True, $a_i_ItemSlot = 0, $a_b_ByItemSlot = False)
    If $a_b_ByModelID = $a_b_ByItemSlot Then Return 0

	Local $l_ai_Offsets[5] = [0, 0x18, 0x40, 0xB8]
	Local $l_p_MerchantBase = GwAu3_Merchant_GetMerchantItemsBase()
	Local $l_i_ItemID = 0, $l_p_ItemPtr = 0

	For $i = 0 To GwAu3_Merchant_GetMerchantItemsSize() -1
		$l_i_ItemID = GwAu3_Memory_Read($l_p_MerchantBase + 0x4 * $i)

		If $l_i_ItemID Then
			$l_ai_Offsets[4] = 0x4 * $l_i_ItemID
			$l_p_ItemPtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offsets)[1]
            If $a_b_ByModelID Then
			    If GwAu3_Memory_Read($l_p_ItemPtr + 0x2C) = $a_i_ModelID Then Return $l_p_ItemPtr
            ElseIf $a_b_ByItemSlot Then
                If $i + 1 = $a_i_ItemSlot Then Return $l_p_ItemPtr
            EndIf
		EndIf
	Next
EndFunc   ;==>GetMerchantItemPtrByModelId

;~ Description: Internal use for buy an item, extraID is for dye
Func GwAu3_Merchant_BuyItem($a_i_ModelID, $a_i_Quantity = 1, $a_b_Trader = False, $a_i_ExtraID = -1)
	If $a_b_Trader Then
        Local $l_i_BoughtCount = 0

        For $i = 1 To $a_i_Quantity
            ; Find the item in trader's inventory
            Local $l_a_Offset[4] = [0, 0x18, 0x40, 0xC0]
            Local $l_i_ItemArraySize = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
            Local $l_p_Item = 0
            Local $l_b_Found = False
            Local $l_i_QuoteID = GwAu3_Memory_Read($g_i_TraderQuoteID)

            ; Search for item with matching ModelID
            For $l_i_ItemID = 1 To $l_i_ItemArraySize[1]
                $l_p_Item = GwAu3_Item_GetItemPtr($l_i_ItemID)
                If $l_p_Item = 0 Then ContinueLoop

                Local $l_i_CurrentModelID = GwAu3_Memory_Read($l_p_Item + 44, 'long')

                If $l_i_CurrentModelID = $a_i_ModelID Then
                    Local $l_i_Offset12 = GwAu3_Memory_Read($l_p_Item + 12, 'ptr')
                    Local $l_i_Offset4 = GwAu3_Memory_Read($l_p_Item + 4, 'long')

                    If $l_i_Offset12 = 0 And $l_i_Offset4 = 0 Then
                        If $a_i_ExtraID = -1 Then
                            $l_b_Found = True
                            ExitLoop
                        Else
                            Local $l_i_ItemExtraID = GwAu3_Memory_Read($l_p_Item + 34, 'short')
                            If $l_i_ItemExtraID = $a_i_ExtraID Then
                                $l_b_Found = True
                                ExitLoop
                            EndIf
                        EndIf
                    EndIf
                EndIf
            Next

            If Not $l_b_Found Then
                Return $l_i_BoughtCount
            EndIf

            ; Request quote
            Local $l_i_ItemID = GwAu3_Item_ItemID($l_p_Item)
            DllStructSetData($g_d_RequestQuote, 2, $l_i_ItemID)
            GwAu3_Core_Enqueue($g_p_RequestQuote, 8)

            ; Wait for quote
            Local $l_i_Deadlock = TimerInit()
            Local $l_i_Timeout = 5000

            Do
                Sleep(36)
                Local $l_i_NewQuoteID = GwAu3_Memory_Read($g_i_TraderQuoteID)
            Until $l_i_NewQuoteID <> $l_i_QuoteID Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

            If TimerDiff($l_i_Deadlock) > $l_i_Timeout Then
                Return $l_i_BoughtCount
            EndIf

            ; Check if we have valid trader cost data
            Local $l_i_CostID = GwAu3_Memory_Read($g_i_TraderCostID)
            Local $l_f_CostValue = GwAu3_Memory_Read($g_f_TraderCostValue)

            If Not $l_i_CostID Or Not $l_f_CostValue Then
                Return $l_i_BoughtCount
            EndIf

            ; Execute trader buy
            GwAu3_Core_Enqueue($g_p_TraderBuy, 4)
            ; Wait for transaction
            Sleep(36)
            $l_i_BoughtCount += 1
        Next
        Return $l_i_BoughtCount > 0
    Else
        ; Standard merchant buy - search by ModelID
        Local $l_p_MerchantItemsBase = GwAu3_Merchant_GetMerchantItemsBase()
        If Not $l_p_MerchantItemsBase Then Return False

        Local $l_i_MerchantSize = GwAu3_Merchant_GetMerchantItemsSize()
        Local $l_i_FoundIndex = 0
        Local $l_i_FoundItemID = 0
		Local $l_i_ItemValue = 0

        ; Search for ModelID in merchant's items
        For $i = 1 To $l_i_MerchantSize
            Local $l_i_ItemID = GwAu3_Memory_Read($l_p_MerchantItemsBase + 4 * ($i - 1))
            Local $l_p_Item = GwAu3_Item_GetItemPtr($l_i_ItemID)
            If $l_p_Item = 0 Then ContinueLoop

            Local $l_i_CurrentModelID = GwAu3_Memory_Read($l_p_Item + 44, 'long')

            If $l_i_CurrentModelID = $a_i_ModelID Then
                If $a_i_ExtraID = -1 Then
                    $l_i_FoundIndex = $i
                    $l_i_FoundItemID = $l_i_ItemID
                    $l_i_ItemValue = GwAu3_Memory_Read($l_p_Item + 36, 'short')
                    ExitLoop
                Else
                    Local $l_i_ItemExtraID = GwAu3_Memory_Read($l_p_Item + 34, 'short')
                    If $l_i_ItemExtraID = $a_i_ExtraID Then
                        $l_i_FoundIndex = $i
                        $l_i_FoundItemID = $l_i_ItemID
                        $l_i_ItemValue = GwAu3_Memory_Read($l_p_Item + 36, 'short')
                        ExitLoop
                    EndIf
                EndIf
            EndIf
        Next

        If $l_i_FoundIndex = 0 Then Return False

        DllStructSetData($g_d_BuyItem, 2, $a_i_Quantity)
        DllStructSetData($g_d_BuyItem, 3, $l_i_FoundItemID)
        DllStructSetData($g_d_BuyItem, 4, $a_i_Quantity * ($l_i_ItemValue*2))
        DllStructSetData($g_d_BuyItem, 5, GwAu3_Memory_GetValue('BuyItemBase'))
        GwAu3_Core_Enqueue($g_p_BuyItem, 20)

        Return True
    EndIf
EndFunc ;==>GwAu3_Merchant_BuyItem

Func GwAu3_Merchant_SellItem($a_p_Item, $a_i_Quantity = 0, $a_b_Trader = False)
    Local $l_p_Item = GwAu3_Item_GetItemPtr($a_p_Item)
    Local $l_i_ItemID = GwAu3_Item_ItemID($a_p_Item)
    Local $l_i_ItemQuantity = GwAu3_Memory_Read($l_p_Item + 0x4C, 'short')

    If $l_i_ItemQuantity <= 0 Then Return False

    ; "SellAll": Set quantity to stack count, but keep track if original was 0
    Local $l_b_SellAll = ($a_i_Quantity = 0)
    If $l_b_SellAll Or $a_i_Quantity > $l_i_ItemQuantity Then
        $a_i_Quantity = $l_i_ItemQuantity
    EndIf

    If $a_b_Trader Then
        ; Trader sell process - one by one
        Local $l_i_SoldCount = 0, $l_i_SellingThreshold = 0
        Local $l_b_IsRareMaterial = GwAu3_Item_GetItemIsRareMaterial($l_p_Item)
        If Not $l_b_IsRareMaterial Then
            $l_i_SellingThreshold = 10
            $a_i_Quantity = Int($a_i_Quantity / 10)
        EndIf

        For $i = 1 To $a_i_Quantity
            ; Request quote
            DllStructSetData($g_d_RequestQuoteSell, 2, $l_i_ItemID)
            GwAu3_Core_Enqueue($g_p_RequestQuoteSell, 8)

            ; Wait for quote response
            Local $l_i_Timeout = TimerInit()
            Do
                Sleep(50)
                Local $l_i_CostID = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
            Until $l_i_CostID = $l_i_ItemID Or TimerDiff($l_i_Timeout) > 2000

			; Check if quote received
            If TimerDiff($l_i_Timeout) > 2000 Then
                GwAu3_Log_Warning("Trader quote timeout for item " & $l_i_ItemID & " (iteration " & $i & ")", "TradeMod", $g_h_EditText)
                ExitLoop
            EndIf

            ; Execute trader sell
            Local $l_i_CostValue = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')
            GwAu3_Core_Enqueue($g_p_TraderSell, 4)

            ; Wait a bit for transaction to complete
            Sleep(250)

            $l_i_SoldCount += 1

            ; Check if item still exists (stack might be depleted)
            Local $l_i_CurrentQuantity = GwAu3_Memory_Read($l_p_Item + 0x4C, 'short')

            If $l_b_IsRareMaterial Then
                If $l_i_CurrentQuantity = $l_i_SellingThreshold Then ExitLoop
            Else
                If $l_i_CurrentQuantity < 10 Then ExitLoop
            EndIf
        Next

        GwAu3_Log_Debug("Sold to trader: Item " & $l_i_ItemID & " x" & $l_i_SoldCount & " (requested: " & $a_i_Quantity & ")", "TradeMod", $g_h_EditText)

    Else
        ; Standard merchant sell - can sell multiple at once
        Local $l_i_Value = GwAu3_Memory_Read($l_p_Item + 0x24, 'short')
        Local $l_i_TotalValue

        If $l_b_SellAll Then
            $l_i_TotalValue = $l_i_ItemQuantity * $l_i_Value
            DllStructSetData($g_d_SellItem, 2, 0)
        Else
            $l_i_TotalValue = $a_i_Quantity * $l_i_Value
            DllStructSetData($g_d_SellItem, 2, $a_i_Quantity)
        EndIf
        DllStructSetData($g_d_SellItem, 3, $l_i_ItemID)
        DllStructSetData($g_d_SellItem, 4, $l_i_TotalValue)
        
        GwAu3_Core_Enqueue($g_p_SellItem, 16)
        GwAu3_Log_Debug("Sold to merchant: Item " & $l_i_ItemID & " x" & $a_i_Quantity, "TradeMod", $g_h_EditText)
    EndIf

    Return True
EndFunc ;==>GwAu3_Merchant_SellItem

;~ Description: $a_ai2_Materials expects a 2D array with [[Material1, Count1],...,[MaterialN, CountN]]; materials need to be in the order shown in the recipe
Func GwAu3_Merchant_CraftItem($a_i_CraftedItem_ModelID, $a_i_Price, $a_ai2_Materials, $a_i_Quantity = 1)
    Local Const $LC_AI_BAG_LIST[4] = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2]
    Local Const $LC_I_MAX_BAG_SLOTS = 60
    Local Const $LC_I_OFFSET_ITEMID = 0x0
    Local Const $LC_I_OFFSET_MODELID = 0x2C
    Local Const $LC_I_OFFSET_QUANTITY = 0x4C

    If $a_i_CraftedItem_ModelID <= 0 Then Return False
    If $a_i_Quantity <= 0 Or $a_i_Quantity > $GC_I_MERCHANT_MAX_ITEM_STACK Then Return False

    Local $l_i_Price_Total = $a_i_Price * $a_i_Quantity 
    If $l_i_Price_Total > GwAu3_Item_GetInventoryInfo("GoldCharacter") Then return False

    Static $s_i_LastCount_Material_ItemIDs = 0
    Static $s_d_CraftItem, $s_p_CraftItemPtr

    Local $l_i_Count_Materials = UBound($a_ai2_Materials)
    If $l_i_Count_Materials <= 0 Then Return False
  
    Static $s_d_Struct_Item = DllStructCreate( _
        "dword ItemID;" & _
        "byte[" & ($LC_I_OFFSET_MODELID - ($LC_I_OFFSET_ITEMID + 4)) & "];" & _
        "dword ModelID;" & _
        "byte[" & ($LC_I_OFFSET_QUANTITY - ($LC_I_OFFSET_MODELID + 4)) & "];" & _
        "short Quantity" _
    )
    Static $s_i_StructSize_Item = DllStructGetSize($s_d_Struct_Item)

    Local $l_amx2_Inventory[$LC_I_MAX_BAG_SLOTS][4] 
    Local $l_i_Inventory_Idx = 0

    For $l_i_Idx = 0 To UBound($LC_AI_BAG_LIST) - 1
        Local $l_p_BagPtr = GwAu3_Item_GetBagPtr($LC_AI_BAG_LIST[$l_i_Idx])
        If $l_p_BagPtr = 0 Then ContinueLoop

        Local $l_ap_ItemArray = GwAu3_Item_GetBagItemArray($LC_AI_BAG_LIST[$l_i_Idx])
        Local $l_i_ItemCount = $l_ap_ItemArray[0]

        For $l_i_Jdx = 1 To $l_i_ItemCount
            Local $l_p_Cache_ItemPtr = $l_ap_ItemArray[$l_i_Jdx]
            If $l_p_Cache_ItemPtr = 0 Then ContinueLoop

            DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
                "handle", $g_h_GWProcess, _
                "ptr", $l_p_Cache_ItemPtr, _
                "struct*", $s_d_Struct_Item, _
                "ulong_ptr", $s_i_StructSize_Item, _
                "ulong_ptr*", 0 _
            )
            
            Local $l_b_IsReqMaterial = False
            Local $l_i_Cache_ModelID = DllStructGetData($s_d_Struct_Item, "ModelID")
            For $l_i_Kdx = 0 To $l_i_Count_Materials - 1
                If $a_ai2_Materials[$l_i_Kdx][0] = $l_i_Cache_ModelID Then 
                    $l_b_IsReqMaterial = True
                    ExitLoop
                EndIf
            Next

            If Not $l_b_IsReqMaterial Then ContinueLoop

            $l_amx2_Inventory[$l_i_Inventory_Idx][0] = $l_p_Cache_ItemPtr
            $l_amx2_Inventory[$l_i_Inventory_Idx][1] = DllStructGetData($s_d_Struct_Item, "ItemID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][2] = $l_i_Cache_ModelID
            $l_amx2_Inventory[$l_i_Inventory_Idx][3] = DllStructGetData($s_d_Struct_Item, "Quantity")
            $l_i_Inventory_Idx += 1
        Next
    Next

    ReDim $l_amx2_Inventory[$l_i_Inventory_Idx][4]

    Local $l_i_Count_Inventory = UBound($l_amx2_Inventory)
    Local $l_ai_Material_ItemIDs[$l_i_Count_Inventory]
    Local $l_i_Material_Idx = 0

    For $l_i_Idx = 0 To $l_i_Count_Materials - 1
        Local $l_i_Material_ModelID = $a_ai2_Materials[$l_i_Idx][0]
        Local $l_i_Material_QuantityReq = $a_ai2_Materials[$l_i_Idx][1] * $a_i_Quantity
        Local $l_i_Material_RemainingQuantityReq = $l_i_Material_QuantityReq

        For $l_i_Jdx = 0 To $l_i_Count_Inventory - 1
            If $l_amx2_Inventory[$l_i_Jdx][0] = 0 Then ContinueLoop
            If $l_amx2_Inventory[$l_i_Jdx][2] <> $l_i_Material_ModelID Then ContinueLoop

            Local $l_i_Item_UseQuantity
            If $l_amx2_Inventory[$l_i_Jdx][3] < $l_i_Material_RemainingQuantityReq Then
                $l_i_Item_UseQuantity = $l_amx2_Inventory[$l_i_Jdx][3]
            Else
                $l_i_Item_UseQuantity = $l_i_Material_RemainingQuantityReq
            EndIf

            $l_ai_Material_ItemIDs[$l_i_Material_Idx] = $l_amx2_Inventory[$l_i_Jdx][1]
            $l_i_Material_Idx += 1

            $l_i_Material_RemainingQuantityReq -= $l_i_Item_UseQuantity
            If $l_i_Material_RemainingQuantityReq <= 0 Then ExitLoop
        Next

        If $l_i_Material_RemainingQuantityReq > 0 Then Return False
    Next

    ReDim $l_ai_Material_ItemIDs[$l_i_Material_Idx]

    If $s_i_LastCount_Material_ItemIDs <> $l_i_Material_Idx Then
        $s_d_CraftItem = DllStructCreate('ptr;dword;dword;dword;dword;dword[' & $l_i_Material_Idx & ']')
        $s_p_CraftItemPtr = DllStructGetPtr($s_d_CraftItem)
        DllStructSetData($s_d_CraftItem, 1, GwAu3_Memory_GetValue('CommandCraftItem'))
        $s_i_LastCount_Material_ItemIDs = $l_i_Material_Idx
    EndIf

    Local $l_i_Merchant_ItemID = GwAu3_Memory_Read(GwAu3_Merchant_GetMerchantItemPtr($a_i_CraftedItem_ModelID))
    If Not $l_i_Merchant_ItemID Then Return False

    DllStructSetData($s_d_CraftItem, 2, $a_i_Quantity)
    DllStructSetData($s_d_CraftItem, 3, $l_i_Merchant_ItemID)
    DllStructSetData($s_d_CraftItem, 4, $a_i_Price * $a_i_Quantity)
    DllStructSetData($s_d_CraftItem, 5, $l_i_Material_Idx)

    For $l_i_Idx = 1 To $l_i_Material_Idx
        DllStructSetData($s_d_CraftItem, 6, $l_ai_Material_ItemIDs[$l_i_Idx - 1], $l_i_Idx)
    Next

    GwAu3_Core_Enqueue($s_p_CraftItemPtr, 20 + 4 * $l_i_Material_Idx)
    Return True
EndFunc   ;==>GwAu3_Merchant_CraftItem

Func GwAu3_Merchant_CollectorExchange($a_i_ModelID_ItemRecv, $a_i_ExchangeReq, $a_i_ModelID_ItemGive)
    Local Const $LC_AI_BAG_LIST[4] = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2]
    Local Const $LC_I_MAX_BAG_SLOTS = 60
    Local Const $LC_I_OFFSET_ITEMID = 0x0
    Local Const $LC_I_OFFSET_MODELID = 0x2C
    Local Const $LC_I_OFFSET_QUANTITY = 0x4C

    If $a_i_ModelID_ItemRecv <= 0 Or $a_i_ModelID_ItemGive <= 0 Then Return False
    If $a_i_ExchangeReq <= 0 Or $a_i_ExchangeReq > $GC_I_MERCHANT_MAX_ITEM_STACK Then Return False

    Static $s_i_LastCount_UsedItemIDs = 0
    Static $s_d_CollectorExchange, $s_p_CollectorExchangePtr

    Static $s_d_Struct_Item = DllStructCreate( _
        "dword ItemID;" & _
        "byte[" & ($LC_I_OFFSET_MODELID - ($LC_I_OFFSET_ITEMID + 4)) & "];" & _
        "dword ModelID;" & _
        "byte[" & ($LC_I_OFFSET_QUANTITY - ($LC_I_OFFSET_MODELID + 4)) & "];" & _
        "short Quantity" _
    )
    Static $s_i_StructSize_Item = DllStructGetSize($s_d_Struct_Item)

    Local $l_amx2_Inventory[$LC_I_MAX_BAG_SLOTS][4] 
    Local $l_i_Inventory_Idx = 0

     For $l_i_Idx = 0 To UBound($LC_AI_BAG_LIST) - 1
        Local $l_p_BagPtr = GwAu3_Item_GetBagPtr($LC_AI_BAG_LIST[$l_i_Idx])
        If $l_p_BagPtr = 0 Then ContinueLoop

        Local $l_ap_ItemArray = GwAu3_Item_GetBagItemArray($LC_AI_BAG_LIST[$l_i_Idx])
        Local $l_i_ItemCount = $l_ap_ItemArray[0]

        For $l_i_Jdx = 1 To $l_i_ItemCount
            Local $l_p_Cache_ItemPtr = $l_ap_ItemArray[$l_i_Jdx]
            If $l_p_Cache_ItemPtr = 0 Then ContinueLoop

            DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
                "handle", $g_h_GWProcess, _
                "ptr", $l_p_Cache_ItemPtr, _
                "struct*", $s_d_Struct_Item, _
                "ulong_ptr", $s_i_StructSize_Item, _
                "ulong_ptr*", 0 _
            )

            Local $l_i_Cache_ModelID = DllStructGetData($s_d_Struct_Item, "ModelID")
            If $a_i_ModelID_ItemGive <> $l_i_Cache_ModelID Then ContinueLoop

            $l_amx2_Inventory[$l_i_Inventory_Idx][0] = $l_p_Cache_ItemPtr
            $l_amx2_Inventory[$l_i_Inventory_Idx][1] = DllStructGetData($s_d_Struct_Item, "ItemID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][2] = $l_i_Cache_ModelID
            $l_amx2_Inventory[$l_i_Inventory_Idx][3] = DllStructGetData($s_d_Struct_Item, "Quantity")
            $l_i_Inventory_Idx += 1
        Next
    Next

    ReDim $l_amx2_Inventory[$l_i_Inventory_Idx][4]

    Local $l_i_Count_Inventory = UBound($l_amx2_Inventory)
    Local $l_ai_Exchange_Quantities[$a_i_ExchangeReq]
    Local $l_ai_Exchange_ItemIDs[$a_i_ExchangeReq]
    Local $l_i_Exchange_RemainingExchangeReq = $a_i_ExchangeReq
    Local $l_i_Exchange_Idx = 0

    For $l_i_Idx = 0 To $l_i_Count_Inventory - 1
        If $l_amx2_Inventory[$l_i_Idx][0] = 0 Then ContinueLoop

        Local $l_i_Item_Quantity
        If $l_amx2_Inventory[$l_i_Idx][3] < $l_i_Exchange_RemainingExchangeReq Then
            $l_i_Item_Quantity = $l_amx2_Inventory[$l_i_Idx][3]
        Else
            $l_i_Item_Quantity = $l_i_Exchange_RemainingExchangeReq
        EndIf

        $l_ai_Exchange_Quantities[$l_i_Exchange_Idx] = $l_i_Item_Quantity
        $l_ai_Exchange_ItemIDs[$l_i_Exchange_Idx] = $l_amx2_Inventory[$l_i_Idx][1]
        $l_i_Exchange_Idx += 1

        $l_i_Exchange_RemainingExchangeReq -= $l_i_Item_Quantity  
        If $l_i_Exchange_RemainingExchangeReq <= 0 Then ExitLoop
    Next

    If $l_i_Exchange_RemainingExchangeReq > 0 Then Return False

    ReDim $l_ai_Exchange_Quantities[$l_i_Exchange_Idx]
    ReDim $l_ai_Exchange_ItemIDs[$l_i_Exchange_Idx]

    If $s_i_LastCount_UsedItemIDs <> $l_i_Exchange_Idx Then
        $s_d_CollectorExchange = DllStructCreate("ptr;dword;dword;dword[" & $l_i_Exchange_Idx & "];dword[" & $l_i_Exchange_Idx & "]")
        $s_p_CollectorExchangePtr = DllStructGetPtr($s_d_CollectorExchange)
        DllStructSetData($s_d_CollectorExchange, 1, GwAu3_Memory_GetValue('CommandCollectorExchange'))
        $s_i_LastCount_UsedItemIDs = $l_i_Exchange_Idx
    EndIf

    Local $l_i_ItemID_ItemRecv = GwAu3_Memory_Read(GwAu3_Merchant_GetMerchantItemPtr($a_i_ModelID_ItemRecv))
    If $l_i_ItemID_ItemRecv = 0 Then Return False

    DllStructSetData($s_d_CollectorExchange, 2, $l_i_ItemID_ItemRecv)
    DllStructSetData($s_d_CollectorExchange, 3, $l_i_Exchange_Idx)

    For $l_i_Idx = 1 To $l_i_Exchange_Idx
        DllStructSetData($s_d_CollectorExchange, 4, $l_ai_Exchange_Quantities[$l_i_Idx - 1], $l_i_Idx)
    Next
    For $l_i_Idx = 1 To $l_i_Exchange_Idx
        DllStructSetData($s_d_CollectorExchange, 5, $l_ai_Exchange_ItemIDs[$l_i_Idx - 1], $l_i_Idx)
    Next

    GwAu3_Core_Enqueue($s_p_CollectorExchangePtr, 12 + 8 * $l_i_Exchange_Idx)
    Return True
EndFunc