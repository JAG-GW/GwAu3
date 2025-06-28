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

Func GwAu3_Merchant_CraftItem($a_i_RecipeID, $a_i_Quantity = 1, $a_v_Materials = 0, $a_i_CrafterID = 0, $a_i_Flags = 0)
    If $a_i_RecipeID <= 0 Then
        GwAu3_Log_Error("Invalid recipe ID: " & $a_i_RecipeID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Quantity <= 0 Or $a_i_Quantity > $GC_I_MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $a_i_Quantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    Local $l_p_MaterialsPtr = 0
    If IsArray($a_v_Materials) Then
        ; Handle materials array if provided
        ; For now, we'll use a simple pointer approach
        $l_p_MaterialsPtr = Ptr($a_v_Materials)
    EndIf

    DllStructSetData($g_d_CraftItemEx, 2, $a_i_RecipeID)
    DllStructSetData($g_d_CraftItemEx, 3, $a_i_Quantity)
    DllStructSetData($g_d_CraftItemEx, 4, $l_p_MaterialsPtr)
    DllStructSetData($g_d_CraftItemEx, 5, $a_i_CrafterID)
    DllStructSetData($g_d_CraftItemEx, 6, $a_i_Flags)

    GwAu3_Core_Enqueue($g_p_CraftItemEx, 24)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_CRAFT
    $g_i_LastItemID = $a_i_RecipeID
    $g_i_LastQuantity = $a_i_Quantity

    GwAu3_Log_Debug("Crafting item " & $a_i_RecipeID & " (quantity: " & $a_i_Quantity & ") with crafter " & $a_i_CrafterID, "TradeMod", $g_h_EditText)
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
