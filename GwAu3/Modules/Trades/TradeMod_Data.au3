#include-once

#Region Module Constants
; Merchant module specific constants
Global Const $MERCHANT_MAX_ITEM_STACK = 250
Global Const $MERCHANT_MAX_GOLD = 100000

; Transaction types
Global Const $TRANSACTION_SELL = 0x0B
Global Const $TRANSACTION_BUY = 0x0C
Global Const $TRANSACTION_REQUEST_QUOTE = 0x0C
Global Const $TRANSACTION_REQUEST_QUOTE_SELL = 0x0D
Global Const $TRANSACTION_TRADER_BUY = 0x0C
Global Const $TRANSACTION_TRADER_SELL = 0x0D
Global Const $TRANSACTION_CRAFT = 0x03

; Salvage types
Global Const $SALVAGE_TYPE_NORMAL = 1
Global Const $SALVAGE_TYPE_EXPERT = 2
Global Const $SALVAGE_TYPE_PERFECT = 3
#EndRegion Module Constants

Func GwAu3_TradeMod_GetLastTransaction()
    Local $result[4] = [$g_iLastTransactionType, $g_iLastItemID, $g_iLastQuantity, $g_iLastPrice]
    Return $result
EndFunc

Func GwAu3_TradeMod_GetTraderQuoteID()
    Return GwAu3_Memory_Read($g_mTraderQuoteID, 'dword')
EndFunc

Func GwAu3_TradeMod_GetTraderCostID()
    Return GwAu3_Memory_Read($g_mTraderCostID, 'dword')
EndFunc

Func GwAu3_TradeMod_GetTraderCostValue()
    Return GwAu3_Memory_Read($g_mTraderCostValue, 'dword')
EndFunc

Func GwAu3_TradeMod_GetTraderQuoteInfo()
    Local $result[3]
    $result[0] = GwAu3_Memory_Read($g_mTraderQuoteID, 'dword')
    $result[1] = GwAu3_Memory_Read($g_mTraderCostID, 'dword')
    $result[2] = GwAu3_Memory_Read($g_mTraderCostValue, 'dword')
    Return $result
EndFunc

Func GwAu3_TradeMod_IsValidQuote()
    Local $iCostID = GwAu3_Memory_Read($g_mTraderCostID, 'dword')
    Local $iCostValue = GwAu3_Memory_Read($g_mTraderCostValue, 'dword')
    Return ($iCostID > 0 And $iCostValue > 0)
EndFunc

Func GwAu3_TradeMod_ClearTraderQuote()
    GwAu3_Memory_Write($g_mTraderCostID, 0, 'dword')
    GwAu3_Memory_Write($g_mTraderCostValue, 0, 'dword')
    GwAu3_Log_Debug("Trader quote data cleared", "TradeMod", $g_h_EditText)
EndFunc

Func GwAu3_TradeMod_GetTransactionTypeName($iTransactionType)
    Switch $iTransactionType
        Case $TRANSACTION_SELL
            Return "Sell"
        Case $TRANSACTION_BUY
            Return "Buy"
        Case $TRANSACTION_REQUEST_QUOTE
            Return "Request Quote"
        Case $TRANSACTION_REQUEST_QUOTE_SELL
            Return "Request Quote Sell"
        Case $TRANSACTION_TRADER_BUY
            Return "Trader Buy"
        Case $TRANSACTION_TRADER_SELL
            Return "Trader Sell"
        Case $TRANSACTION_CRAFT
            Return "Craft"
        Case Else
            Return "Unknown"
    EndSwitch
EndFunc

Func GwAu3_TradeMod_GetSalvageTypeName($iSalvageType)
    Switch $iSalvageType
        Case $SALVAGE_TYPE_NORMAL
            Return "Normal"
        Case $SALVAGE_TYPE_EXPERT
            Return "Expert"
        Case $SALVAGE_TYPE_PERFECT
            Return "Perfect"
        Case Else
            Return "Unknown"
    EndSwitch
EndFunc

Func GwAu3_TradeMod_WaitForQuote($iTimeout = 5000)
    Local $iStartTime = TimerInit()

    While TimerDiff($iStartTime) < $iTimeout
        If _TradeMod_IsValidQuote() Then
            GwAu3_Log_Debug("Quote received after " & TimerDiff($iStartTime) & "ms", "TradeMod", $g_h_EditText)
            Return True
        EndIf
        Sleep(32) ; Small delay to prevent excessive polling
    WEnd

    GwAu3_Log_Warning("Quote request timed out after " & $iTimeout & "ms", "TradeMod", $g_h_EditText)
    Return False
EndFunc

Func GwAu3_TradeMod_GetBuyItemBase()
    Return $g_mBuyItemBase
EndFunc

Func GwAu3_TradeMod_GetSalvageGlobal()
    Return $g_mSalvageGlobal
EndFunc

#Region Trade Context Related
Func GwAu3_TradeMod_GetTradePtr()
    Local $lOffset[3] = [0, 0x18, 0x58]
    Local $lTradePtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset, "ptr")
    Return $lTradePtr[1]
EndFunc

Func GwAu3_TradeMod_GetTradeInfo($aInfo = "")
	Local $lPtr = _TradeMod_GetTradePtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "Flags"
            Return GwAu3_Memory_Read($lPtr, "long")
        Case "IsTradeClosed"
            Local $flags = GwAu3_Memory_Read($lPtr, "long")
            Return BitAND($flags, 0) = 0
        Case "IsTradeInitiated"
            Local $flags = GwAu3_Memory_Read($lPtr, "long")
            Return BitAND($flags, 1) <> 0
        Case "IsPartnerTradeOffered"
            Local $flags = GwAu3_Memory_Read($lPtr, "long")
            Return BitAND($flags, 2) <> 0
		Case "IsPlayerTradeOffered"
            Local $flags = GwAu3_Memory_Read($lPtr, "long")
            Return BitAND($flags, 3) <> 0
		Case "IsPlayerTradeAccepted"
            Local $flags = GwAu3_Memory_Read($lPtr, "long")
            Return BitAND($flags, 7) <> 0

        Case "PlayerGold"
            Return GwAu3_Memory_Read($lPtr + 0x10, "long")
		Case "PlayerItemsPtr"
            Return GwAu3_Memory_Read($lPtr + 0x14, "ptr")
		Case "PlayerItemCount"
            Return GwAu3_Memory_Read($lPtr + 0x1C, "long")

        Case "PartnerGold"
            Return GwAu3_Memory_Read($lPtr + 0x24, "long")
        Case "PartnerItemsPtr"
            Return GwAu3_Memory_Read($lPtr + 0x28, "ptr")
        Case "PartnerItemCount"
            Return GwAu3_Memory_Read($lPtr + 0x30, "long")

    EndSwitch

    Return 0
EndFunc

Func GwAu3_TradeMod_GetPlayerTradeItemsInfo($aTradeSlot = 0, $aInfo = "")
	Local $itemsPtr = _TradeMod_GetTradeInfo("PlayerItemsPtr")
    If $itemsPtr = 0 Or $aInfo = "" Then Return 0

	Local $itemCount = _TradeMod_GetTradeInfo("PlayerItemCount")
    If $itemCount = 0 Or $aTradeSlot >= $itemCount Then Return 0

    Local $itemPtr = $itemsPtr + ($aTradeSlot * 8)
    Local $itemID = GwAu3_Memory_Read($itemPtr, "long")

    Switch $aInfo
        Case "ItemID"
            Return $itemID
        Case "Quantity"
            Return GwAu3_Memory_Read($itemPtr + 4, "long")
        Case "ModelID"
            Return GwAu3_ItemMod_GetItemInfoByPtr($itemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_TradeMod_GetPartnerTradeItemsInfo($aTradeSlot = 0, $aInfo = "")
	Local $itemsPtr = _TradeMod_GetTradeInfo("PartnerItemsPtr")
    If $itemsPtr = 0 Or $aInfo = "" Then Return 0

	Local $itemCount = _TradeMod_GetTradeInfo("PartnerItemCount")
    If $itemCount = 0 Or $aTradeSlot >= $itemCount Then Return 0

    Local $itemPtr = $itemsPtr + ($aTradeSlot * 8)
    Local $itemID = GwAu3_Memory_Read($itemPtr, "long")

    Switch $aInfo
        Case "ItemID"
            Return $itemID
        Case "Quantity"
            Return GwAu3_Memory_Read($itemPtr + 4, "long")
        Case "ModelID"
            Return GwAu3_ItemMod_GetItemInfoByPtr($itemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_TradeMod_GetArrayPlayerTradeItems()
	Local $itemCount = _TradeMod_GetTradeInfo("PlayerItemCount")

    If $itemCount = 0 Then
        Local $items[1] = [0]
        Return $items
    EndIf

    Local $items[$itemCount + 1][2]
    $items[0][0] = $itemCount

	Local $itemsPtr = _TradeMod_GetTradeInfo("PlayerItemsPtr")
    If $itemsPtr = 0 Then Return $items

    For $i = 0 To $itemCount - 1
        ; Read ModelID
        $items[$i + 1][0] = GwAu3_ItemMod_GetItemInfoByPtr(GwAu3_Memory_Read($itemsPtr + ($i * 8), "long"), "ModelID")
        ; Read item quantity
        $items[$i + 1][1] = GwAu3_Memory_Read($itemsPtr + ($i * 8) + 4, "long")
    Next

    Return $items
EndFunc

Func GwAu3_TradeMod_GetArrayPartnerTradeItems()
	Local $itemCount = _TradeMod_GetTradeInfo("PartnerItemCount")

    If $itemCount = 0 Then
        Local $items[1] = [0]
        Return $items
    EndIf

    Local $items[$itemCount + 1][2]
    $items[0][0] = $itemCount

	Local $itemsPtr = _TradeMod_GetTradeInfo("PartnerItemsPtr")
    If $itemsPtr = 0 Then Return $items

    For $i = 0 To $itemCount - 1
        ; Read ModelID
        $items[$i + 1][0] = GwAu3_ItemMod_GetItemInfoByPtr(GwAu3_Memory_Read($itemsPtr + ($i * 8), "long"), "ModelID")
        ; Read item quantity
        $items[$i + 1][1] = GwAu3_Memory_Read($itemsPtr + ($i * 8) + 4, "long")
    Next

    Return $items
EndFunc
#EndRegion Trade Context Related
