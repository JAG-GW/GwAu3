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

Func GwAu3_Merchant_SellItem($a_p_Item, $a_i_Quantity = 0)
	Local $lItemID = GwAu3_Item_ItemID($a_p_Item)
	Local $a_i_Quantity = GwAu3_Memory_Read(GwAu3_Item_GetItemPtr($a_p_Item) + 76, 'short')
	Local $l_i_Value = GwAu3_Memory_Read(GwAu3_Item_GetItemPtr($a_p_Item) + 36, 'short')

	If $a_i_Quantity = 0 Or $a_i_Quantity > $a_i_Quantity Then $a_i_Quantity = $a_i_Quantity
	DllStructSetData($g_d_SellItem, 2, $a_i_Quantity * $l_i_Value)
	DllStructSetData($g_d_SellItem, 3, $lItemID)
	GwAu3_Core_Enqueue($g_p_SellItem, 12)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_SELL
    $g_i_LastItemID = $a_i_ItemID
    $g_i_LastQuantity = $a_i_Quantity

    GwAu3_Log_Debug("Selling item " & $a_i_ItemID & " (quantity: " & $a_i_Quantity & ") to merchant " & $a_i_MerchantID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_Merchant_BuyItem($a_p_Item, $a_i_Quantity, $a_i_Value)
	Local $l_p_MerchantItemsBase = GwAu3_Merchant_GetMerchantItemsBase()

	If Not $l_p_MerchantItemsBase Then Return
	If $a_p_Item < 1 Or $a_p_Item > GwAu3_Merchant_GetMerchantItemsSize() Then Return

	DllStructSetData($g_d_BuyItem, 2, $a_i_Quantity)
	DllStructSetData($g_d_BuyItem, 3, GwAu3_Memory_Read($l_p_MerchantItemsBase + 4 * ($a_p_Item - 1)))
	DllStructSetData($g_d_BuyItem, 4, $a_i_Quantity * $a_i_Value)
	DllStructSetData($g_d_BuyItem, 5, GwAu3_Memory_GetValue('BuyItemBase')
;~ 	Or
;~ 	DllStructSetData($g_d_BuyItem, 5, GwAu3_Memory_Read(GwAu3_Memory_GetValue('BuyItemBase')))
	GwAu3_Core_Enqueue($g_p_BuyItem, 20)

    $g_i_LastItemID = $a_p_Item
    $g_i_LastQuantity = $a_i_Quantity
    $g_i_LastPrice = $a_i_Price
    Return True
EndFunc

Func GwAu3_Merchant_CraftItem($a_i_CraftedItem_ModelID, $a_i_Price, $a_ai2_Materials, $a_i_Quantity = 1)
    If $a_i_CraftedItem_ModelID <= 0 Then Return False
    If $a_i_Quantity <= 0 Or $a_i_Quantity > $GC_I_MERCHANT_MAX_ITEM_STACK Then Return False

    Local Const $LC_AI_BAG_LIST[4] = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2]
    Local Const $LC_I_MAX_BAG_SLOTS = 60
    Local Const $LC_I_OFFSET_ITEMID = 0x0
    Local Const $LC_I_OFFSET_MODELID = 0x2C
    Local Const $LC_I_OFFSET_QUANTITY = 0x4C

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
            Local $l_p_CacheItemPtr = $l_ap_ItemArray[$l_i_Jdx]
            If $l_p_CacheItemPtr = 0 Then ContinueLoop

            DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
                "handle", $g_h_GWProcess, _
                "ptr", $l_p_CacheItemPtr, _
                "struct*", $s_d_Struct_Item, _
                "ulong_ptr", $s_i_StructSize_Item, _
                "ulong_ptr*", 0 _
            )

            $l_amx2_Inventory[$l_i_Inventory_Idx][0] = $l_p_CacheItemPtr
            $l_amx2_Inventory[$l_i_Inventory_Idx][1] = DllStructGetData($s_d_Struct_Item, "ItemID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][2] = DllStructGetData($s_d_Struct_Item, "ModelID")
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

            Local $l_i_Item_UseQuantity = ($l_amx2_Inventory[$l_i_Jdx][3] < $l_i_Material_RemainingQuantityReq) _
                ? $l_amx2_Inventory[$l_i_Jdx][3] _
                : $l_i_Material_RemainingQuantityReq

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
    If $a_i_ModelID_ItemRecv <= 0 Or $a_i_ModelID_ItemGive <= 0 Then Return False
    If $a_i_ExchangeReq <= 0 Or $a_i_ExchangeReq > $GC_I_MERCHANT_MAX_ITEM_STACK Then Return False

    Local Const $LC_AI_BAG_LIST[4] = [$GC_I_INVENTORY_BACKPACK, $GC_I_INVENTORY_BELT_POUCH, $GC_I_INVENTORY_BAG1, $GC_I_INVENTORY_BAG2]
    Local Const $LC_I_MAX_BAG_SLOTS = 60
    Local Const $LC_I_OFFSET_ITEMID = 0x0
    Local Const $LC_I_OFFSET_MODELID = 0x2C
    Local Const $LC_I_OFFSET_QUANTITY = 0x4C

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
            Local $l_p_CacheItemPtr = $l_ap_ItemArray[$l_i_Jdx]
            If $l_p_CacheItemPtr = 0 Then ContinueLoop

            DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
                "handle", $g_h_GWProcess, _
                "ptr", $l_p_CacheItemPtr, _
                "struct*", $s_d_Struct_Item, _
                "ulong_ptr", $s_i_StructSize_Item, _
                "ulong_ptr*", 0 _
            )

            $l_amx2_Inventory[$l_i_Inventory_Idx][0] = $l_p_CacheItemPtr
            $l_amx2_Inventory[$l_i_Inventory_Idx][1] = DllStructGetData($s_d_Struct_Item, "ItemID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][2] = DllStructGetData($s_d_Struct_Item, "ModelID")
            $l_amx2_Inventory[$l_i_Inventory_Idx][3] = DllStructGetData($s_d_Struct_Item, "Quantity")
            $l_i_Inventory_Idx += 1
        Next
    Next

    ReDim $l_amx2_Inventory[$l_i_Inventory_Idx][4]

    Local $l_i_Count_Inventory = UBound($l_amx2_Inventory)
    Local $l_ai_Exchange_Quantities[$a_i_ExchangeReq]
    Local $l_ai_Exchange_ItemIDs[$a_i_ExchangeReq]
    Local $l_i_Exchange_RemainingExchangeReq = $a_i_ExchangeReq
    Local $l_i_TotalQuantity_ItemGive = 0, $l_i_Exchange_Idx = 0

    For $l_i_Idx = 0 To $l_i_Count_Inventory - 1
        If $l_amx2_Inventory[$l_i_Idx][0] = 0 Then ContinueLoop
        If $l_amx2_Inventory[$l_i_Idx][2] <> $a_i_ModelID_ItemGive Then ContinueLoop

        Local $l_i_Item_Quantity = ($l_amx2_Inventory[$l_i_Idx][3] < $l_i_Exchange_RemainingExchangeReq) _
            ? $l_amx2_Inventory[$l_i_Idx][3] _
            : $l_i_Exchange_RemainingExchangeReq

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

Func GwAu3_Merchant_RequestQuote($a_i_ItemID)
    If $a_i_ItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $a_i_ItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    DllStructSetData($g_d_RequestQuote, 2, $a_i_ItemID)

    GwAu3_Core_Enqueue($g_p_RequestQuote, 8)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_REQUEST_QUOTE
    $g_i_LastItemID = $a_i_ItemID

    GwAu3_Log_Debug("Requesting quote for item " & $a_i_ItemID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_Merchant_RequestQuoteSell($a_i_ItemID)
    If $a_i_ItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $a_i_ItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    DllStructSetData($g_d_RequestQuoteSell, 2, $a_i_ItemID)

    GwAu3_Core_Enqueue($g_p_RequestQuoteSell, 8)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_REQUEST_QUOTE_SELL
    $g_i_LastItemID = $a_i_ItemID

    GwAu3_Log_Debug("Requesting sell quote for item " & $a_i_ItemID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_Merchant_TraderBuy()
    ; Check if we have valid trader data
    Local $l_i_CostID = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
    Local $l_i_CostValue = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')

    If $l_i_CostID = 0 Then
        GwAu3_Log_Warning("No valid trader quote available", "TradeMod", $g_h_EditText)
        Return False
    EndIf

    GwAu3_Core_Enqueue($g_p_TraderBuy, 4)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_TRADER_BUY
    $g_i_LastItemID = $l_i_CostID
    $g_i_LastPrice = $l_i_CostValue

    GwAu3_Log_Debug("Executing trader buy for item " & $l_i_CostID & " at price " & $l_i_CostValue, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_Merchant_TraderSell()
    ; Check if we have valid trader data
    Local $l_i_CostID = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
    Local $l_i_CostValue = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')

    If $l_i_CostID = 0 Then
        GwAu3_Log_Warning("No valid trader quote available", "TradeMod", $g_h_EditText)
        Return False
    EndIf

    GwAu3_Core_Enqueue($g_p_TraderSell, 4)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_TRADER_SELL
    $g_i_LastItemID = $l_i_CostID
    $g_i_LastPrice = $l_i_CostValue

    GwAu3_Log_Debug("Executing trader sell for item " & $l_i_CostID & " at price " & $l_i_CostValue, "TradeMod", $g_h_EditText)
    Return True
EndFunc