#include-once

;~ Description: Internal use for BuyItem()
Func Merchant_GetMerchantItemsBase()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x24]
    Local $l_av_Return = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsBase

;~ Description: Internal use for BuyItem()
Func Merchant_GetMerchantItemsSize()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x28]
    Local $l_av_Return = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsSize

Func Merchant_GetMerchantItemPtr($a_i_ModelID = 0, $a_b_ByModelID = True, $a_i_ItemSlot = 0, $a_b_ByItemSlot = False)
    If $a_b_ByModelID = $a_b_ByItemSlot Then Return 0

	Local $l_ai_Offsets[5] = [0, 0x18, 0x40, 0xB8]
	Local $l_p_MerchantBase = Merchant_GetMerchantItemsBase()
	Local $l_i_ItemID = 0, $l_p_ItemPtr = 0

	For $i = 0 To Merchant_GetMerchantItemsSize() -1
		$l_i_ItemID = Memory_Read($l_p_MerchantBase + 0x4 * $i)

		If $l_i_ItemID Then
			$l_ai_Offsets[4] = 0x4 * $l_i_ItemID
			$l_p_ItemPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offsets)[1]
            If $a_b_ByModelID Then
			    If Memory_Read($l_p_ItemPtr + 0x2C) = $a_i_ModelID Then Return $l_p_ItemPtr
            ElseIf $a_b_ByItemSlot Then
                If $i + 1 = $a_i_ItemSlot Then Return $l_p_ItemPtr
            EndIf
		EndIf
	Next
EndFunc   ;==>GetMerchantItemPtrByModelId

;~ Description: Internal use for buy an item, provide $a_s_ModString for runes and $a_i_ExtraID for dye
Func Merchant_BuyItem($a_i_ModelID, $a_i_Quantity = 1, $a_b_Trader = False, $a_s_ModString = "", $a_i_ExtraID = -1)
	If $a_b_Trader Then
        ; Search for item with matching ModelID not belonging to a player
        Local $l_i_ItemArraySize = Item_GetMaxItems()
        Local $l_p_Item, $l_i_ItemID, $l_i_ItemModelID
        Local $l_b_FoundItem = False

        For $l_i_Idx = 1 To $l_i_ItemArraySize
            $l_p_Item = Item_GetItemPtr($l_i_Idx)
            If Not $l_p_Item Then ContinueLoop

            If Memory_Read($l_p_Item + 0x2C, 'dword') <> $a_i_ModelID Then ContinueLoop
            If Memory_Read($l_p_Item + 0xC, 'ptr') <> 0 Or Memory_Read($l_p_Item + 0x4, 'dword') <> 0 Then ContinueLoop

            If $a_s_ModString = "" And $a_i_ExtraID = -1 Then
                $l_b_FoundItem = True
                ExitLoop
            ElseIf $a_s_ModString <> "" And $a_i_ExtraID = -1 Then
                If StringInStr(Item_GetModStruct($l_p_Item), $a_s_ModString) > 0 Then
                    $l_b_FoundItem = True
                    ExitLoop
                EndIf
            ElseIf $a_s_ModString = "" And $a_i_ExtraID <> -1 Then
                If Memory_Read($l_p_Item + 0x22, 'short') = $a_i_ExtraID Then
                    $l_b_FoundItem = True
                    ExitLoop
                EndIf
            EndIf
        Next

        If Not $l_b_FoundItem Then Return False

        For $i = 1 To $a_i_Quantity
            ; Save current QuoteID for later reference
            Local $l_i_QuoteID = Memory_Read($g_i_TraderQuoteID)

            ; Request quote
            $l_i_ItemID = Item_ItemID($l_p_Item)

            DllStructSetData($g_d_RequestQuote, 2, $l_i_ItemID)
            Core_Enqueue($g_p_RequestQuote, 8)

            ; Wait for quote
            Local $l_i_Deadlock = TimerInit()
            Local $l_i_Timeout = 5000

            Do
                Sleep(36)
                Local $l_i_NewQuoteID = Memory_Read($g_i_TraderQuoteID)
            Until $l_i_NewQuoteID <> $l_i_QuoteID Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

            If TimerDiff($l_i_Deadlock) > $l_i_Timeout Then Return False

            ; Check if we have valid trader cost data
            Local $l_i_CostID = Memory_Read($g_i_TraderCostID)
            Local $l_f_CostValue = Memory_Read($g_f_TraderCostValue)

            If Not $l_i_CostID Or Not $l_f_CostValue Then Return False
            If $l_f_CostValue > Item_GetInventoryInfo("GoldCharacter") Then Return False

            ; Execute trader buy
            Core_Enqueue($g_p_TraderBuy, 4)

            ; Wait for transaction
            Sleep(36)
        Next

        Log_Debug("Bought from merchant: Item " & $l_i_ItemID & " x" & $a_i_Quantity, "TradeMod", $g_h_EditText)
        Return True

    Else
        ; Standard merchant buy - search by ModelID
        Local $l_p_Merchant_ItemBase = Merchant_GetMerchantItemsBase()
        If Not $l_p_Merchant_ItemBase Then Return False

        Local $l_i_MerchantItemCount = Merchant_GetMerchantItemsSize()
        Local $l_p_Item, $l_i_ItemID, $l_i_ItemModelID, $l_i_ItemValue
        Local $l_b_FoundItem = False

        ; Search for ModelID in merchant's items
        For $i = 0 To $l_i_MerchantItemCount - 1
            $l_i_ItemID = Memory_Read($l_p_Merchant_ItemBase + 4 * $i)
            $l_p_Item = Item_GetItemPtr($l_i_ItemID)
            If Not $l_p_Item Then ContinueLoop

            $l_i_ItemModelID = Memory_Read($l_p_Item + 0x2C)
            If $l_i_ItemModelID = $a_i_ModelID Then
                If $a_i_ExtraID = -1 Then
                    $l_i_ItemValue = Memory_Read($l_p_Item + 0x24, 'short')
                    $l_b_FoundItem = True
                    ExitLoop
                Else
                    Local $l_i_ItemExtraID = Memory_Read($l_p_Item + 0x22, 'short')
                    If $l_i_ItemExtraID = $a_i_ExtraID Then
                        $l_i_ItemValue = Memory_Read($l_p_Item + 0x24, 'short')
                        $l_b_FoundItem = True
                        ExitLoop
                    EndIf
                EndIf
            EndIf
        Next

        If Not $l_b_FoundItem Then Return False

        DllStructSetData($g_d_BuyItem, 2, $a_i_Quantity)
        DllStructSetData($g_d_BuyItem, 3, $l_i_ItemID)
        DllStructSetData($g_d_BuyItem, 4, $a_i_Quantity * ($l_i_ItemValue*2))
        DllStructSetData($g_d_BuyItem, 5, Memory_GetValue('BuyItemBase'))

        Core_Enqueue($g_p_BuyItem, 20)
        Log_Debug("Bought from merchant: Item " & $l_i_ItemID & " x" & $a_i_Quantity, "TradeMod", $g_h_EditText)

        Return True
    EndIf
EndFunc ;==>Merchant_BuyItem

Func Merchant_SellItem($a_p_Item, $a_i_Quantity = 0, $a_b_Trader = False)
    Local $l_p_Item = Item_GetItemPtr($a_p_Item)
    Local $l_i_ItemID = Item_ItemID($a_p_Item)
	Local $l_i_Item_ModelID = Memory_Read($l_p_Item + 0x2C, "dword")
    Local $l_i_ItemQuantity = Memory_Read($l_p_Item + 0x4C, 'short')

    If $l_i_ItemQuantity <= 0 Then Return False

    ; "SellAll": Set quantity to stack count, but keep track if original was 0
    Local $l_b_SellAll = ($a_i_Quantity = 0)
    If $l_b_SellAll Or $a_i_Quantity > $l_i_ItemQuantity Then
        $a_i_Quantity = $l_i_ItemQuantity
    EndIf

    If $a_b_Trader Then
        ; Trader sell process - one by one
        Local $l_i_SoldCount = 0, $l_i_SellingThreshold = 0
        Local $l_b_IsRareMaterial = Item_GetItemIsRareMaterial($l_p_Item)
		Local $l_b_IsRuneOrInsignia = Item_IsRuneOrInsignia($l_i_Item_ModelID)
        If Not $l_b_IsRareMaterial And $l_b_IsRuneOrInsignia = 0 Then
            $l_i_SellingThreshold = 10
            $a_i_Quantity = Int($a_i_Quantity / 10)
        EndIf

        For $i = 1 To $a_i_Quantity
            ; Request quote
            DllStructSetData($g_d_RequestQuoteSell, 2, $l_i_ItemID)
            Core_Enqueue($g_p_RequestQuoteSell, 8)

            ; Wait for quote response
            Local $l_i_Timeout = TimerInit()
            Do
                Sleep(50)
                Local $l_i_CostID = Memory_Read($g_i_TraderCostID, 'dword')
            Until $l_i_CostID = $l_i_ItemID Or TimerDiff($l_i_Timeout) > 2000

			; Check if quote received
            If TimerDiff($l_i_Timeout) > 2000 Then
                Log_Warning("Trader quote timeout for item " & $l_i_ItemID & " (iteration " & $i & ")", "TradeMod", $g_h_EditText)
                ExitLoop
            EndIf

            ; Execute trader sell
            Local $l_i_CostValue = Memory_Read($g_f_TraderCostValue, 'dword')
            Core_Enqueue($g_p_TraderSell, 4)

            ; Wait a bit for transaction to complete
            Sleep(250)

            $l_i_SoldCount += 1

            ; Check if item still exists (stack might be depleted)
            Local $l_i_CurrentQuantity = Memory_Read($l_p_Item + 0x4C, 'short')

            If $l_b_IsRareMaterial Then
                If $l_i_CurrentQuantity = $l_i_SellingThreshold Then ExitLoop
            Else
                If $l_i_CurrentQuantity < 10 Then ExitLoop
            EndIf
        Next

        Log_Debug("Sold to trader: Item " & $l_i_ItemID & " x" & $l_i_SoldCount & " (requested: " & $a_i_Quantity & ")", "TradeMod", $g_h_EditText)

    Else
        ; Standard merchant sell - can sell multiple at once
        Local $l_i_Value = Memory_Read($l_p_Item + 0x24, 'short')
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

        Core_Enqueue($g_p_SellItem, 16)
        Log_Debug("Sold to merchant: Item " & $l_i_ItemID & " x" & $a_i_Quantity, "TradeMod", $g_h_EditText)
    EndIf

    Return True
EndFunc ;==>Merchant_SellItem

;~ Description: $a_ai2_Materials expects a 2D array with [[Material1, Count1],...,[MaterialN, CountN]]; materials need to be in the order shown in the recipe
Func Merchant_CraftItem($a_i_CraftedItem_ModelID, $a_i_Price, $a_ai2_Materials, $a_i_Quantity = 1)
    Local Const $LC_AI_BAG_LIST[4] = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2]
    Local Const $LC_I_MAX_BAG_SLOTS = 60
    Local Const $LC_I_OFFSET_ITEMID = 0x0
    Local Const $LC_I_OFFSET_MODELID = 0x2C
    Local Const $LC_I_OFFSET_QUANTITY = 0x4C

    If $a_i_CraftedItem_ModelID <= 0 Then Return False
    If $a_i_Quantity <= 0 Or $a_i_Quantity > $GC_I_MERCHANT_MAX_ITEM_STACK Then Return False

    Local $l_i_Price_Total = $a_i_Price * $a_i_Quantity
    If $l_i_Price_Total > Item_GetInventoryInfo("GoldCharacter") Then Return False

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
        Local $l_p_BagPtr = Item_GetBagPtr($LC_AI_BAG_LIST[$l_i_Idx])
        If $l_p_BagPtr = 0 Then ContinueLoop

        Local $l_ap_ItemArray = Item_GetBagItemArray($LC_AI_BAG_LIST[$l_i_Idx])
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
        DllStructSetData($s_d_CraftItem, 1, Memory_GetValue('CommandCraftItem'))
        $s_i_LastCount_Material_ItemIDs = $l_i_Material_Idx
    EndIf

    Local $l_i_Merchant_ItemID = Memory_Read(Merchant_GetMerchantItemPtr($a_i_CraftedItem_ModelID))
    If Not $l_i_Merchant_ItemID Then Return False

    DllStructSetData($s_d_CraftItem, 2, $a_i_Quantity)
    DllStructSetData($s_d_CraftItem, 3, $l_i_Merchant_ItemID)
    DllStructSetData($s_d_CraftItem, 4, $a_i_Price * $a_i_Quantity)
    DllStructSetData($s_d_CraftItem, 5, $l_i_Material_Idx)

    For $l_i_Idx = 1 To $l_i_Material_Idx
        DllStructSetData($s_d_CraftItem, 6, $l_ai_Material_ItemIDs[$l_i_Idx - 1], $l_i_Idx)
    Next

    Core_Enqueue($s_p_CraftItemPtr, 20 + 4 * $l_i_Material_Idx)
    Return True
EndFunc   ;==>Merchant_CraftItem

Func Merchant_CollectorExchange($a_i_ModelID_ItemRecv, $a_i_ExchangeReq, $a_i_ModelID_ItemGive)
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
        Local $l_p_BagPtr = Item_GetBagPtr($LC_AI_BAG_LIST[$l_i_Idx])
        If $l_p_BagPtr = 0 Then ContinueLoop

        Local $l_ap_ItemArray = Item_GetBagItemArray($LC_AI_BAG_LIST[$l_i_Idx])
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
        DllStructSetData($s_d_CollectorExchange, 1, Memory_GetValue('CommandCollectorExchange'))
        $s_i_LastCount_UsedItemIDs = $l_i_Exchange_Idx
    EndIf

    Local $l_i_ItemID_ItemRecv = Memory_Read(Merchant_GetMerchantItemPtr($a_i_ModelID_ItemRecv))
    If $l_i_ItemID_ItemRecv = 0 Then Return False

    DllStructSetData($s_d_CollectorExchange, 2, $l_i_ItemID_ItemRecv)
    DllStructSetData($s_d_CollectorExchange, 3, $l_i_Exchange_Idx)

    For $l_i_Idx = 1 To $l_i_Exchange_Idx
        DllStructSetData($s_d_CollectorExchange, 4, $l_ai_Exchange_Quantities[$l_i_Idx - 1], $l_i_Idx)
    Next
    For $l_i_Idx = 1 To $l_i_Exchange_Idx
        DllStructSetData($s_d_CollectorExchange, 5, $l_ai_Exchange_ItemIDs[$l_i_Idx - 1], $l_i_Idx)
    Next

    Core_Enqueue($s_p_CollectorExchangePtr, 12 + 8 * $l_i_Exchange_Idx)
    Return True
EndFunc