#include-once

Func GwAu3_TradeMod_SellItem($iItemID, $iQuantity = 1, $iMerchantID = 0)
    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iQuantity <= 0 Or $iQuantity > $MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $iQuantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_SellItem, 1, GwAu3_Memory_GetValue('CommandSellItem'))
    DllStructSetData($g_d_SellItem, 2, $iItemID)
    DllStructSetData($g_d_SellItem, 3, $iQuantity)
    DllStructSetData($g_d_SellItem, 4, $iMerchantID)

    GwAu3_Core_Enqueue($g_p_SellItem, 16)

    ; Record for tracking
    $g_i_LastTransactionType = $TRANSACTION_SELL
    $g_i_LastItemID = $iItemID
    $g_i_LastQuantity = $iQuantity

    GwAu3_Log_Debug("Selling item " & $iItemID & " (quantity: " & $iQuantity & ") to merchant " & $iMerchantID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_BuyItem($iItemID, $iQuantity = 1, $iPrice = 0, $iMerchantID = 0)
    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iQuantity <= 0 Or $iQuantity > $MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $iQuantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iPrice < 0 Or $iPrice > $MERCHANT_MAX_GOLD Then
        GwAu3_Log_Error("Invalid price: " & $iPrice, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_BuyItem, 1, GwAu3_Memory_GetValue('CommandBuyItem'))
    DllStructSetData($g_d_BuyItem, 2, $iItemID)
    DllStructSetData($g_d_BuyItem, 3, $iQuantity)
    DllStructSetData($g_d_BuyItem, 4, $iPrice)
    DllStructSetData($g_d_BuyItem, 5, $iMerchantID)

    GwAu3_Core_Enqueue($g_p_BuyItem, 20)

    ; Record for tracking
    $g_i_LastTransactionType = $TRANSACTION_BUY
    $g_i_LastItemID = $iItemID
    $g_i_LastQuantity = $iQuantity
    $g_i_LastPrice = $iPrice

    GwAu3_Log_Debug("Buying item " & $iItemID & " (quantity: " & $iQuantity & ", price: " & $iPrice & ") from merchant " & $iMerchantID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_CraftItem($iRecipeID, $iQuantity = 1, $aMaterials = 0, $iCrafterID = 0, $iFlags = 0)
    If $iRecipeID <= 0 Then
        GwAu3_Log_Error("Invalid recipe ID: " & $iRecipeID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iQuantity <= 0 Or $iQuantity > $MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $iQuantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    Local $pMaterialsPtr = 0
    If IsArray($aMaterials) Then
        ; Handle materials array if provided
        ; For now, we'll use a simple pointer approach
        $pMaterialsPtr = Ptr($aMaterials)
    EndIf

	DllStructSetData($g_d_CraftItemEx, 1, GwAu3_Memory_GetValue('CommandCraftItemEx'))
    DllStructSetData($g_d_CraftItemEx, 2, $iRecipeID)
    DllStructSetData($g_d_CraftItemEx, 3, $iQuantity)
    DllStructSetData($g_d_CraftItemEx, 4, $pMaterialsPtr)
    DllStructSetData($g_d_CraftItemEx, 5, $iCrafterID)
    DllStructSetData($g_d_CraftItemEx, 6, $iFlags)

    GwAu3_Core_Enqueue($g_p_CraftItemEx, 24)

    ; Record for tracking
    $g_i_LastTransactionType = $TRANSACTION_CRAFT
    $g_i_LastItemID = $iRecipeID
    $g_i_LastQuantity = $iQuantity

    GwAu3_Log_Debug("Crafting item " & $iRecipeID & " (quantity: " & $iQuantity & ") with crafter " & $iCrafterID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_RequestQuote($iItemID)
    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_RequestQuote, 1, GwAu3_Memory_GetValue('CommandRequestQuote'))
    DllStructSetData($g_d_RequestQuote, 2, $iItemID)

    GwAu3_Core_Enqueue($g_p_RequestQuote, 8)

    ; Record for tracking
    $g_i_LastTransactionType = $TRANSACTION_REQUEST_QUOTE
    $g_i_LastItemID = $iItemID

    GwAu3_Log_Debug("Requesting quote for item " & $iItemID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_RequestQuoteSell($iItemID)
    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_RequestQuoteSell, 1, GwAu3_Memory_GetValue('CommandRequestQuoteSell'))
    DllStructSetData($g_d_RequestQuoteSell, 2, $iItemID)

    GwAu3_Core_Enqueue($g_p_RequestQuoteSell, 8)

    ; Record for tracking
    $g_i_LastTransactionType = $TRANSACTION_REQUEST_QUOTE_SELL
    $g_i_LastItemID = $iItemID

    GwAu3_Log_Debug("Requesting sell quote for item " & $iItemID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_TraderBuy()
    ; Check if we have valid trader data
    Local $iCostID = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
    Local $iCostValue = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')

    If $iCostID = 0 Then
        GwAu3_Log_Warning("No valid trader quote available", "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_TraderBuy, 1, GwAu3_Memory_GetValue('CommandTraderBuy'))
    GwAu3_Core_Enqueue($g_p_TraderBuy, 4)

    ; Record for tracking
    $g_i_LastTransactionType = $TRANSACTION_TRADER_BUY
    $g_i_LastItemID = $iCostID
    $g_i_LastPrice = $iCostValue

    GwAu3_Log_Debug("Executing trader buy for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_TraderSell()
    ; Check if we have valid trader data
    Local $iCostID = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
    Local $iCostValue = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')

    If $iCostID = 0 Then
        GwAu3_Log_Warning("No valid trader quote available", "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_TraderSell, 1, GwAu3_Memory_GetValue('CommandTraderSell'))
    GwAu3_Core_Enqueue($g_p_TraderSell, 4)

    ; Record for tracking
    $g_i_LastTransactionType = $TRANSACTION_TRADER_SELL
    $g_i_LastItemID = $iCostID
    $g_i_LastPrice = $iCostValue

    GwAu3_Log_Debug("Executing trader sell for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_SalvageItem($iItemID, $iSalvageKitID, $iSalvageType = $SALVAGE_TYPE_NORMAL)
    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iSalvageKitID <= 0 Then
        GwAu3_Log_Error("Invalid salvage kit ID: " & $iSalvageKitID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iSalvageType < $SALVAGE_TYPE_NORMAL Or $iSalvageType > $SALVAGE_TYPE_PERFECT Then
        GwAu3_Log_Error("Invalid salvage type: " & $iSalvageType, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_d_Salvage, 1, GwAu3_Memory_GetValue('CommandSalvage'))
    DllStructSetData($g_d_Salvage, 2, $iItemID)
    DllStructSetData($g_d_Salvage, 3, $iSalvageKitID)
    DllStructSetData($g_d_Salvage, 4, $iSalvageType)

    GwAu3_Core_Enqueue($g_p_Salvage, 16)

    ; Record for tracking
    $g_i_LastTransactionType = 0 ; Salvage doesn't have a specific transaction type
    $g_i_LastItemID = $iItemID

    GwAu3_Log_Debug("Salvaging item " & $iItemID & " with kit " & $iSalvageKitID & " (type: " & $iSalvageType & ")", "TradeMod", $g_h_EditText)
    Return True
EndFunc