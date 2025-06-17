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

Func GwAu3_Merchant_SellItem($a_i_ItemID, $a_i_Quantity = 1, $a_i_MerchantID = 0)
    If $a_i_ItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $a_i_ItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Quantity <= 0 Or $a_i_Quantity > $GC_I_MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $a_i_Quantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    DllStructSetData($g_d_SellItem, 1, GwAu3_Memory_GetValue('CommandSellItem'))
    DllStructSetData($g_d_SellItem, 2, $a_i_ItemID)
    DllStructSetData($g_d_SellItem, 3, $a_i_Quantity)
    DllStructSetData($g_d_SellItem, 4, $a_i_MerchantID)

    GwAu3_Core_Enqueue($g_p_SellItem, 16)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_SELL
    $g_i_LastItemID = $a_i_ItemID
    $g_i_LastQuantity = $a_i_Quantity

    GwAu3_Log_Debug("Selling item " & $a_i_ItemID & " (quantity: " & $a_i_Quantity & ") to merchant " & $a_i_MerchantID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_Merchant_BuyItem($a_i_ItemID, $a_i_Quantity = 1, $a_i_Price = 0, $a_i_MerchantID = 0)
    If $a_i_ItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $a_i_ItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Quantity <= 0 Or $a_i_Quantity > $GC_I_MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $a_i_Quantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Price < 0 Or $a_i_Price > $GC_I_MERCHANT_MAX_GOLD Then
        GwAu3_Log_Error("Invalid price: " & $a_i_Price, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    DllStructSetData($g_d_BuyItem, 1, GwAu3_Memory_GetValue('CommandBuyItem'))
    DllStructSetData($g_d_BuyItem, 2, $a_i_ItemID)
    DllStructSetData($g_d_BuyItem, 3, $a_i_Quantity)
    DllStructSetData($g_d_BuyItem, 4, $a_i_Price)
    DllStructSetData($g_d_BuyItem, 5, $a_i_MerchantID)

    GwAu3_Core_Enqueue($g_p_BuyItem, 20)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_BUY
    $g_i_LastItemID = $a_i_ItemID
    $g_i_LastQuantity = $a_i_Quantity
    $g_i_LastPrice = $a_i_Price

    GwAu3_Log_Debug("Buying item " & $a_i_ItemID & " (quantity: " & $a_i_Quantity & ", price: " & $a_i_Price & ") from merchant " & $a_i_MerchantID, "TradeMod", $g_h_EditText)
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

    DllStructSetData($g_d_CraftItemEx, 1, GwAu3_Memory_GetValue('CommandCraftItemEx'))
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

    DllStructSetData($g_d_RequestQuote, 1, GwAu3_Memory_GetValue('CommandRequestQuote'))
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

    DllStructSetData($g_d_RequestQuoteSell, 1, GwAu3_Memory_GetValue('CommandRequestQuoteSell'))
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

    DllStructSetData($g_d_TraderBuy, 1, GwAu3_Memory_GetValue('CommandTraderBuy'))
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

    DllStructSetData($g_d_TraderSell, 1, GwAu3_Memory_GetValue('CommandTraderSell'))
    GwAu3_Core_Enqueue($g_p_TraderSell, 4)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_TRADER_SELL
    $g_i_LastItemID = $l_i_CostID
    $g_i_LastPrice = $l_i_CostValue

    GwAu3_Log_Debug("Executing trader sell for item " & $l_i_CostID & " at price " & $l_i_CostValue, "TradeMod", $g_h_EditText)
    Return True
EndFunc
