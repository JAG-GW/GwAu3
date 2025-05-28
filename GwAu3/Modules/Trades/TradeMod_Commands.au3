#include-once
#include "TradeMod_Initialize.au3"

Func _TradeMod_SellItem($iItemID, $iQuantity = 1, $iMerchantID = 0)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iItemID <= 0 Then
        _Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iQuantity <= 0 Or $iQuantity > $MERCHANT_MAX_ITEM_STACK Then
        _Log_Error("Invalid quantity: " & $iQuantity, "TradeMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mSellItem, 1, GetValue('CommandSellItem'))
    DllStructSetData($g_mSellItem, 2, $iItemID)
    DllStructSetData($g_mSellItem, 3, $iQuantity)
    DllStructSetData($g_mSellItem, 4, $iMerchantID)

    Enqueue($g_mSellItemPtr, 16)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_SELL
    $g_iLastItemID = $iItemID
    $g_iLastQuantity = $iQuantity

    _Log_Debug("Selling item " & $iItemID & " (quantity: " & $iQuantity & ") to merchant " & $iMerchantID, "TradeMod", $GUIEdit)
    Return True
EndFunc

Func _TradeMod_BuyItem($iItemID, $iQuantity = 1, $iPrice = 0, $iMerchantID = 0)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iItemID <= 0 Then
        _Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iQuantity <= 0 Or $iQuantity > $MERCHANT_MAX_ITEM_STACK Then
        _Log_Error("Invalid quantity: " & $iQuantity, "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iPrice < 0 Or $iPrice > $MERCHANT_MAX_GOLD Then
        _Log_Error("Invalid price: " & $iPrice, "TradeMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mBuyItem, 1, GetValue('CommandBuyItem'))
    DllStructSetData($g_mBuyItem, 2, $iItemID)
    DllStructSetData($g_mBuyItem, 3, $iQuantity)
    DllStructSetData($g_mBuyItem, 4, $iPrice)
    DllStructSetData($g_mBuyItem, 5, $iMerchantID)

    Enqueue($g_mBuyItemPtr, 20)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_BUY
    $g_iLastItemID = $iItemID
    $g_iLastQuantity = $iQuantity
    $g_iLastPrice = $iPrice

    _Log_Debug("Buying item " & $iItemID & " (quantity: " & $iQuantity & ", price: " & $iPrice & ") from merchant " & $iMerchantID, "TradeMod", $GUIEdit)
    Return True
EndFunc

Func _TradeMod_CraftItem($iRecipeID, $iQuantity = 1, $aMaterials = 0, $iCrafterID = 0, $iFlags = 0)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iRecipeID <= 0 Then
        _Log_Error("Invalid recipe ID: " & $iRecipeID, "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iQuantity <= 0 Or $iQuantity > $MERCHANT_MAX_ITEM_STACK Then
        _Log_Error("Invalid quantity: " & $iQuantity, "TradeMod", $GUIEdit)
        Return False
    EndIf

    Local $pMaterialsPtr = 0
    If IsArray($aMaterials) Then
        ; Handle materials array if provided
        ; For now, we'll use a simple pointer approach
        $pMaterialsPtr = Ptr($aMaterials)
    EndIf

	DllStructSetData($g_mCraftItemEx, 1, GetValue('CommandCraftItemEx'))
    DllStructSetData($g_mCraftItemEx, 2, $iRecipeID)
    DllStructSetData($g_mCraftItemEx, 3, $iQuantity)
    DllStructSetData($g_mCraftItemEx, 4, $pMaterialsPtr)
    DllStructSetData($g_mCraftItemEx, 5, $iCrafterID)
    DllStructSetData($g_mCraftItemEx, 6, $iFlags)

    Enqueue($g_mCraftItemExPtr, 24)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_CRAFT
    $g_iLastItemID = $iRecipeID
    $g_iLastQuantity = $iQuantity

    _Log_Debug("Crafting item " & $iRecipeID & " (quantity: " & $iQuantity & ") with crafter " & $iCrafterID, "TradeMod", $GUIEdit)
    Return True
EndFunc

Func _TradeMod_RequestQuote($iItemID)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iItemID <= 0 Then
        _Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mRequestQuote, 1, GetValue('CommandRequestQuote'))
    DllStructSetData($g_mRequestQuote, 2, $iItemID)

    Enqueue($g_mRequestQuotePtr, 8)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_REQUEST_QUOTE
    $g_iLastItemID = $iItemID

    _Log_Debug("Requesting quote for item " & $iItemID, "TradeMod", $GUIEdit)
    Return True
EndFunc

Func _TradeMod_RequestQuoteSell($iItemID)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iItemID <= 0 Then
        _Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mRequestQuoteSell, 1, GetValue('CommandRequestQuoteSell'))
    DllStructSetData($g_mRequestQuoteSell, 2, $iItemID)

    Enqueue($g_mRequestQuoteSellPtr, 8)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_REQUEST_QUOTE_SELL
    $g_iLastItemID = $iItemID

    _Log_Debug("Requesting sell quote for item " & $iItemID, "TradeMod", $GUIEdit)
    Return True
EndFunc

Func _TradeMod_TraderBuy()
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    ; Check if we have valid trader data
    Local $iCostID = MemoryRead($g_mTraderCostID, 'dword')
    Local $iCostValue = MemoryRead($g_mTraderCostValue, 'dword')

    If $iCostID = 0 Then
        _Log_Warning("No valid trader quote available", "TradeMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mTraderBuy, 1, GetValue('CommandTraderBuy'))
    Enqueue($g_mTraderBuyPtr, 4)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_TRADER_BUY
    $g_iLastItemID = $iCostID
    $g_iLastPrice = $iCostValue

    _Log_Debug("Executing trader buy for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $GUIEdit)
    Return True
EndFunc

Func _TradeMod_TraderSell()
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    ; Check if we have valid trader data
    Local $iCostID = MemoryRead($g_mTraderCostID, 'dword')
    Local $iCostValue = MemoryRead($g_mTraderCostValue, 'dword')

    If $iCostID = 0 Then
        _Log_Warning("No valid trader quote available", "TradeMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mTraderSell, 1, GetValue('CommandTraderSell'))
    Enqueue($g_mTraderSellPtr, 4)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_TRADER_SELL
    $g_iLastItemID = $iCostID
    $g_iLastPrice = $iCostValue

    _Log_Debug("Executing trader sell for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $GUIEdit)
    Return True
EndFunc

Func _TradeMod_SalvageItem($iItemID, $iSalvageKitID, $iSalvageType = $SALVAGE_TYPE_NORMAL)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iItemID <= 0 Then
        _Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iSalvageKitID <= 0 Then
        _Log_Error("Invalid salvage kit ID: " & $iSalvageKitID, "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iSalvageType < $SALVAGE_TYPE_NORMAL Or $iSalvageType > $SALVAGE_TYPE_PERFECT Then
        _Log_Error("Invalid salvage type: " & $iSalvageType, "TradeMod", $GUIEdit)
        Return False
    EndIf

	DllStructSetData($g_mSalvage, 1, GetValue('CommandSalvage'))
    DllStructSetData($g_mSalvage, 2, $iItemID)
    DllStructSetData($g_mSalvage, 3, $iSalvageKitID)
    DllStructSetData($g_mSalvage, 4, $iSalvageType)

    Enqueue($g_mSalvagePtr, 16)

    ; Record for tracking
    $g_iLastTransactionType = 0 ; Salvage doesn't have a specific transaction type
    $g_iLastItemID = $iItemID

    _Log_Debug("Salvaging item " & $iItemID & " with kit " & $iSalvageKitID & " (type: " & $iSalvageType & ")", "TradeMod", $GUIEdit)
    Return True
EndFunc