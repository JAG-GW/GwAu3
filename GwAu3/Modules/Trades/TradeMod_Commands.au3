#include-once

Func GwAu3_TradeMod_SellItem($iItemID, $iQuantity = 1, $iMerchantID = 0)
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iQuantity <= 0 Or $iQuantity > $MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $iQuantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_mSellItem, 1, GwAu3_Memory_GetValue('CommandSellItem'))
    DllStructSetData($g_mSellItem, 2, $iItemID)
    DllStructSetData($g_mSellItem, 3, $iQuantity)
    DllStructSetData($g_mSellItem, 4, $iMerchantID)

    GwAu3_Core_Enqueue($g_mSellItemPtr, 16)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_SELL
    $g_iLastItemID = $iItemID
    $g_iLastQuantity = $iQuantity

    GwAu3_Log_Debug("Selling item " & $iItemID & " (quantity: " & $iQuantity & ") to merchant " & $iMerchantID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_BuyItem($iItemID, $iQuantity = 1, $iPrice = 0, $iMerchantID = 0)
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

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

	DllStructSetData($g_mBuyItem, 1, GwAu3_Memory_GetValue('CommandBuyItem'))
    DllStructSetData($g_mBuyItem, 2, $iItemID)
    DllStructSetData($g_mBuyItem, 3, $iQuantity)
    DllStructSetData($g_mBuyItem, 4, $iPrice)
    DllStructSetData($g_mBuyItem, 5, $iMerchantID)

    GwAu3_Core_Enqueue($g_mBuyItemPtr, 20)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_BUY
    $g_iLastItemID = $iItemID
    $g_iLastQuantity = $iQuantity
    $g_iLastPrice = $iPrice

    GwAu3_Log_Debug("Buying item " & $iItemID & " (quantity: " & $iQuantity & ", price: " & $iPrice & ") from merchant " & $iMerchantID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_CraftItem($iRecipeID, $iQuantity = 1, $aMaterials = 0, $iCrafterID = 0, $iFlags = 0)
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

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

	DllStructSetData($g_mCraftItemEx, 1, GwAu3_Memory_GetValue('CommandCraftItemEx'))
    DllStructSetData($g_mCraftItemEx, 2, $iRecipeID)
    DllStructSetData($g_mCraftItemEx, 3, $iQuantity)
    DllStructSetData($g_mCraftItemEx, 4, $pMaterialsPtr)
    DllStructSetData($g_mCraftItemEx, 5, $iCrafterID)
    DllStructSetData($g_mCraftItemEx, 6, $iFlags)

    GwAu3_Core_Enqueue($g_mCraftItemExPtr, 24)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_CRAFT
    $g_iLastItemID = $iRecipeID
    $g_iLastQuantity = $iQuantity

    GwAu3_Log_Debug("Crafting item " & $iRecipeID & " (quantity: " & $iQuantity & ") with crafter " & $iCrafterID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_RequestQuote($iItemID)
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_mRequestQuote, 1, GwAu3_Memory_GetValue('CommandRequestQuote'))
    DllStructSetData($g_mRequestQuote, 2, $iItemID)

    GwAu3_Core_Enqueue($g_mRequestQuotePtr, 8)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_REQUEST_QUOTE
    $g_iLastItemID = $iItemID

    GwAu3_Log_Debug("Requesting quote for item " & $iItemID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_RequestQuoteSell($iItemID)
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $iItemID <= 0 Then
        GwAu3_Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_mRequestQuoteSell, 1, GwAu3_Memory_GetValue('CommandRequestQuoteSell'))
    DllStructSetData($g_mRequestQuoteSell, 2, $iItemID)

    GwAu3_Core_Enqueue($g_mRequestQuoteSellPtr, 8)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_REQUEST_QUOTE_SELL
    $g_iLastItemID = $iItemID

    GwAu3_Log_Debug("Requesting sell quote for item " & $iItemID, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_TraderBuy()
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if we have valid trader data
    Local $iCostID = GwAu3_Memory_Read($g_mTraderCostID, 'dword')
    Local $iCostValue = GwAu3_Memory_Read($g_mTraderCostValue, 'dword')

    If $iCostID = 0 Then
        GwAu3_Log_Warning("No valid trader quote available", "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_mTraderBuy, 1, GwAu3_Memory_GetValue('CommandTraderBuy'))
    GwAu3_Core_Enqueue($g_mTraderBuyPtr, 4)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_TRADER_BUY
    $g_iLastItemID = $iCostID
    $g_iLastPrice = $iCostValue

    GwAu3_Log_Debug("Executing trader buy for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_TraderSell()
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if we have valid trader data
    Local $iCostID = GwAu3_Memory_Read($g_mTraderCostID, 'dword')
    Local $iCostValue = GwAu3_Memory_Read($g_mTraderCostValue, 'dword')

    If $iCostID = 0 Then
        GwAu3_Log_Warning("No valid trader quote available", "TradeMod", $g_h_EditText)
        Return False
    EndIf

	DllStructSetData($g_mTraderSell, 1, GwAu3_Memory_GetValue('CommandTraderSell'))
    GwAu3_Core_Enqueue($g_mTraderSellPtr, 4)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_TRADER_SELL
    $g_iLastItemID = $iCostID
    $g_iLastPrice = $iCostValue

    GwAu3_Log_Debug("Executing trader sell for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_TradeMod_SalvageItem($iItemID, $iSalvageKitID, $iSalvageType = $SALVAGE_TYPE_NORMAL)
    If Not $g_bTradeModuleInitialized Then
        GwAu3_Log_Error("TradeMod module not initialized", "TradeMod", $g_h_EditText)
        Return False
    EndIf

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

	DllStructSetData($g_mSalvage, 1, GwAu3_Memory_GetValue('CommandSalvage'))
    DllStructSetData($g_mSalvage, 2, $iItemID)
    DllStructSetData($g_mSalvage, 3, $iSalvageKitID)
    DllStructSetData($g_mSalvage, 4, $iSalvageType)

    GwAu3_Core_Enqueue($g_mSalvagePtr, 16)

    ; Record for tracking
    $g_iLastTransactionType = 0 ; Salvage doesn't have a specific transaction type
    $g_iLastItemID = $iItemID

    GwAu3_Log_Debug("Salvaging item " & $iItemID & " with kit " & $iSalvageKitID & " (type: " & $iSalvageType & ")", "TradeMod", $g_h_EditText)
    Return True
EndFunc