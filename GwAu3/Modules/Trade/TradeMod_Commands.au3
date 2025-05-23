#include-once
#include "TradeMod_Initialize.au3"

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_SellItem
; Description ...: Sells an item to a merchant
; Syntax.........: _TradeMod_SellItem($iItemID, $iQuantity = 1, $iMerchantID = 0)
; Parameters ....: $iItemID     - ID of the item to sell
;                  $iQuantity   - [optional] Quantity to sell (default: 1)
;                  $iMerchantID - [optional] ID of the merchant (default: 0)
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Item must be in inventory
;                  - Merchant must be in range and available
;                  - Does not validate item ownership or merchant availability
; Related .......: _TradeMod_BuyItem, _TradeMod_RequestQuoteSell
;============================================================================================
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

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_BuyItem
; Description ...: Buys an item from a merchant
; Syntax.........: _TradeMod_BuyItem($iItemID, $iQuantity = 1, $iPrice = 0, $iMerchantID = 0)
; Parameters ....: $iItemID     - ID of the item to buy
;                  $iQuantity   - [optional] Quantity to buy (default: 1)
;                  $iPrice      - [optional] Price to pay (default: 0)
;                  $iMerchantID - [optional] ID of the merchant (default: 0)
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Merchant must have the item in stock
;                  - Player must have enough gold
;                  - Does not validate gold amount or item availability
; Related .......: _TradeMod_SellItem, _TradeMod_RequestQuote
;============================================================================================
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

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_CraftItem
; Description ...: Crafts an item using materials
; Syntax.........: _TradeMod_CraftItem($iRecipeID, $iQuantity = 1, $aMaterials = 0, $iCrafterID = 0, $iFlags = 0)
; Parameters ....: $iRecipeID   - ID of the recipe to craft
;                  $iQuantity   - [optional] Quantity to craft (default: 1)
;                  $aMaterials  - [optional] Array of material IDs (default: 0)
;                  $iCrafterID  - [optional] ID of the crafter NPC (default: 0)
;                  $iFlags      - [optional] Crafting flags (default: 0)
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Player must have required materials
;                  - Crafter must be in range and available
;                  - Does not validate material availability
; Related .......: _TradeMod_BuyItem, _TradeMod_SellItem
;============================================================================================
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

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_RequestQuote
; Description ...: Requests a price quote for buying an item
; Syntax.........: _TradeMod_RequestQuote($iItemID)
; Parameters ....: $iItemID - ID of the item to get a quote for
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Used to get current market price for an item
;                  - Quote response is handled by trader hook system
; Related .......: _TradeMod_RequestQuoteSell, _TradeMod_BuyItem
;============================================================================================
Func _TradeMod_RequestQuote($iItemID)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iItemID <= 0 Then
        _Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $GUIEdit)
        Return False
    EndIf

    DllStructSetData($g_mRequestQuote, 2, $iItemID)

    Enqueue($g_mRequestQuotePtr, 8)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_REQUEST_QUOTE
    $g_iLastItemID = $iItemID

    _Log_Debug("Requesting quote for item " & $iItemID, "TradeMod", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_RequestQuoteSell
; Description ...: Requests a price quote for selling an item
; Syntax.........: _TradeMod_RequestQuoteSell($iItemID)
; Parameters ....: $iItemID - ID of the item to get a sell quote for
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Used to get current sell price for an item
;                  - Quote response is handled by trader hook system
; Related .......: _TradeMod_RequestQuote, _TradeMod_SellItem
;============================================================================================
Func _TradeMod_RequestQuoteSell($iItemID)
    If Not $g_bTradeModuleInitialized Then
        _Log_Error("TradeMod module not initialized", "TradeMod", $GUIEdit)
        Return False
    EndIf

    If $iItemID <= 0 Then
        _Log_Error("Invalid item ID: " & $iItemID, "TradeMod", $GUIEdit)
        Return False
    EndIf

    DllStructSetData($g_mRequestQuoteSell, 2, $iItemID)

    Enqueue($g_mRequestQuoteSellPtr, 8)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_REQUEST_QUOTE_SELL
    $g_iLastItemID = $iItemID

    _Log_Debug("Requesting sell quote for item " & $iItemID, "TradeMod", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_TraderBuy
; Description ...: Executes a trader buy operation
; Syntax.........: _TradeMod_TraderBuy()
; Parameters ....: None
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Uses current trader quote data
;                  - Must have previously requested a quote
;                  - Completes the purchase at the quoted price
; Related .......: _TradeMod_RequestQuote, _TradeMod_TraderSell
;============================================================================================
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

    Enqueue($g_mTraderBuyPtr, 4)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_TRADER_BUY
    $g_iLastItemID = $iCostID
    $g_iLastPrice = $iCostValue

    _Log_Debug("Executing trader buy for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_TraderSell
; Description ...: Executes a trader sell operation
; Syntax.........: _TradeMod_TraderSell()
; Parameters ....: None
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Uses current trader quote data
;                  - Must have previously requested a sell quote
;                  - Completes the sale at the quoted price
; Related .......: _TradeMod_RequestQuoteSell, _TradeMod_TraderBuy
;============================================================================================
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

    Enqueue($g_mTraderSellPtr, 4)

    ; Record for tracking
    $g_iLastTransactionType = $TRANSACTION_TRADER_SELL
    $g_iLastItemID = $iCostID
    $g_iLastPrice = $iCostValue

    _Log_Debug("Executing trader sell for item " & $iCostID & " at price " & $iCostValue, "TradeMod", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_SalvageItem
; Description ...: Salvages an item for materials
; Syntax.........: _TradeMod_SalvageItem($iItemID, $iSalvageKitID, $iSalvageType = $SALVAGE_TYPE_NORMAL)
; Parameters ....: $iItemID       - ID of the item to salvage
;                  $iSalvageKitID - ID of the salvage kit to use
;                  $iSalvageType  - [optional] Type of salvage operation (default: normal)
; Return values .: True if command is sent successfully, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Item must be salvageable
;                  - Salvage kit must have uses remaining
;                  - Does not validate item or kit availability
; Related .......: _TradeMod_SellItem
;============================================================================================
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