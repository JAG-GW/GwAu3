#include-once

#Region Module Constants
; Merchant module specific constants
Global Const $GC_I_MERCHANT_MAX_ITEM_STACK = 250
Global Const $GC_I_MERCHANT_MAX_GOLD = 100000

; Transaction types
Global Const $GC_I_TRANSACTION_SELL = 0x0B
Global Const $GC_I_TRANSACTION_BUY = 0x0C
Global Const $GC_I_TRANSACTION_REQUEST_QUOTE = 0x0C
Global Const $GC_I_TRANSACTION_REQUEST_QUOTE_SELL = 0x0D
Global Const $GC_I_TRANSACTION_TRADER_BUY = 0x0C
Global Const $GC_I_TRANSACTION_TRADER_SELL = 0x0D
Global Const $GC_I_TRANSACTION_CRAFT = 0x03

; Salvage types
Global Const $GC_I_SALVAGE_TYPE_NORMAL = 1
Global Const $GC_I_SALVAGE_TYPE_EXPERT = 2
Global Const $GC_I_SALVAGE_TYPE_PERFECT = 3
#EndRegion Module Constants

Func GwAu3_TradeMod_GetLastTransaction()
    Local $l_ai_Result[4] = [$g_i_LastTransactionType, $g_i_LastItemID, $g_i_LastQuantity, $g_i_LastPrice]
    Return $l_ai_Result
EndFunc

Func GwAu3_TradeMod_GetTraderQuoteID()
    Return GwAu3_Memory_Read($g_i_TraderQuoteID, 'dword')
EndFunc

Func GwAu3_TradeMod_GetTraderCostID()
    Return GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
EndFunc

Func GwAu3_TradeMod_GetTraderCostValue()
    Return GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')
EndFunc

Func GwAu3_TradeMod_GetTraderQuoteInfo()
    Local $l_ai_Result[3]
    $l_ai_Result[0] = GwAu3_Memory_Read($g_i_TraderQuoteID, 'dword')
    $l_ai_Result[1] = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
    $l_ai_Result[2] = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')
    Return $l_ai_Result
EndFunc

Func GwAu3_TradeMod_IsValidQuote()
    Local $l_i_CostID = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
    Local $l_i_CostValue = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')
    Return ($l_i_CostID > 0 And $l_i_CostValue > 0)
EndFunc

Func GwAu3_TradeMod_ClearTraderQuote()
    GwAu3_Memory_Write($g_i_TraderCostID, 0, 'dword')
    GwAu3_Memory_Write($g_f_TraderCostValue, 0, 'dword')
    GwAu3_Log_Debug("Trader quote data cleared", "TradeMod", $g_h_EditText)
EndFunc

Func GwAu3_TradeMod_GetTransactionTypeName($a_i_TransactionType)
    Switch $a_i_TransactionType
        Case $GC_I_TRANSACTION_SELL
            Return "Sell"
        Case $GC_I_TRANSACTION_BUY
            Return "Buy"
        Case $GC_I_TRANSACTION_REQUEST_QUOTE
            Return "Request Quote"
        Case $GC_I_TRANSACTION_REQUEST_QUOTE_SELL
            Return "Request Quote Sell"
        Case $GC_I_TRANSACTION_TRADER_BUY
            Return "Trader Buy"
        Case $GC_I_TRANSACTION_TRADER_SELL
            Return "Trader Sell"
        Case $GC_I_TRANSACTION_CRAFT
            Return "Craft"
        Case Else
            Return "Unknown"
    EndSwitch
EndFunc

Func GwAu3_TradeMod_GetSalvageTypeName($a_i_SalvageType)
    Switch $a_i_SalvageType
        Case $GC_I_SALVAGE_TYPE_NORMAL
            Return "Normal"
        Case $GC_I_SALVAGE_TYPE_EXPERT
            Return "Expert"
        Case $GC_I_SALVAGE_TYPE_PERFECT
            Return "Perfect"
        Case Else
            Return "Unknown"
    EndSwitch
EndFunc

Func GwAu3_TradeMod_WaitForQuote($a_i_Timeout = 5000)
    Local $l_i_StartTime = TimerInit()

    While TimerDiff($l_i_StartTime) < $a_i_Timeout
        If GwAu3_TradeMod_IsValidQuote() Then
            GwAu3_Log_Debug("Quote received after " & TimerDiff($l_i_StartTime) & "ms", "TradeMod", $g_h_EditText)
            Return True
        EndIf
        Sleep(32) ; Small delay to prevent excessive polling
    WEnd

    GwAu3_Log_Warning("Quote request timed out after " & $a_i_Timeout & "ms", "TradeMod", $g_h_EditText)
    Return False
EndFunc

Func GwAu3_TradeMod_GetBuyItemBase()
    Return $g_p_BuyItemBase
EndFunc

Func GwAu3_TradeMod_GetSalvageGlobal()
    Return $g_p_SalvageGlobal
EndFunc

#Region Trade Context Related
Func GwAu3_TradeMod_GetTradePtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x58]
    Local $l_ap_TradePtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_TradePtr[1]
EndFunc

Func GwAu3_TradeMod_GetTradeInfo($a_s_Info = "")
    Local $l_p_Ptr = GwAu3_TradeMod_GetTradePtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "Flags"
            Return GwAu3_Memory_Read($l_p_Ptr, "long")
        Case "IsTradeClosed"
            Local $l_i_Flags = GwAu3_Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 0) = 0
        Case "IsTradeInitiated"
            Local $l_i_Flags = GwAu3_Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 1) <> 0
        Case "IsPartnerTradeOffered"
            Local $l_i_Flags = GwAu3_Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 2) <> 0
        Case "IsPlayerTradeOffered"
            Local $l_i_Flags = GwAu3_Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 3) <> 0
        Case "IsPlayerTradeAccepted"
            Local $l_i_Flags = GwAu3_Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 7) <> 0

        Case "PlayerGold"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x10, "long")
        Case "PlayerItemsPtr"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x14, "ptr")
        Case "PlayerItemCount"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x1C, "long")

        Case "PartnerGold"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x24, "long")
        Case "PartnerItemsPtr"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x28, "ptr")
        Case "PartnerItemCount"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x30, "long")

    EndSwitch

    Return 0
EndFunc

Func GwAu3_TradeMod_GetPlayerTradeItemsInfo($a_i_TradeSlot = 0, $a_s_Info = "")
    Local $l_p_ItemsPtr = GwAu3_TradeMod_GetTradeInfo("PlayerItemsPtr")
    If $l_p_ItemsPtr = 0 Or $a_s_Info = "" Then Return 0

    Local $l_i_ItemCount = GwAu3_TradeMod_GetTradeInfo("PlayerItemCount")
    If $l_i_ItemCount = 0 Or $a_i_TradeSlot >= $l_i_ItemCount Then Return 0

    Local $l_p_ItemPtr = $l_p_ItemsPtr + ($a_i_TradeSlot * 8)
    Local $l_i_ItemID = GwAu3_Memory_Read($l_p_ItemPtr, "long")

    Switch $a_s_Info
        Case "ItemID"
            Return $l_i_ItemID
        Case "Quantity"
            Return GwAu3_Memory_Read($l_p_ItemPtr + 4, "long")
        Case "ModelID"
            Return GwAu3_ItemMod_GetItemInfoByPtr($l_p_ItemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_TradeMod_GetPartnerTradeItemsInfo($a_i_TradeSlot = 0, $a_s_Info = "")
    Local $l_p_ItemsPtr = GwAu3_TradeMod_GetTradeInfo("PartnerItemsPtr")
    If $l_p_ItemsPtr = 0 Or $a_s_Info = "" Then Return 0

    Local $l_i_ItemCount = GwAu3_TradeMod_GetTradeInfo("PartnerItemCount")
    If $l_i_ItemCount = 0 Or $a_i_TradeSlot >= $l_i_ItemCount Then Return 0

    Local $l_p_ItemPtr = $l_p_ItemsPtr + ($a_i_TradeSlot * 8)
    Local $l_i_ItemID = GwAu3_Memory_Read($l_p_ItemPtr, "long")

    Switch $a_s_Info
        Case "ItemID"
            Return $l_i_ItemID
        Case "Quantity"
            Return GwAu3_Memory_Read($l_p_ItemPtr + 4, "long")
        Case "ModelID"
            Return GwAu3_ItemMod_GetItemInfoByPtr($l_p_ItemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func GwAu3_TradeMod_GetArrayPlayerTradeItems()
    Local $l_i_ItemCount = GwAu3_TradeMod_GetTradeInfo("PlayerItemCount")

    If $l_i_ItemCount = 0 Then
        Local $l_ai2_Items[1] = [0]
        Return $l_ai2_Items
    EndIf

    Local $l_ai2_Items[$l_i_ItemCount + 1][2]
    $l_ai2_Items[0][0] = $l_i_ItemCount

    Local $l_p_ItemsPtr = GwAu3_TradeMod_GetTradeInfo("PlayerItemsPtr")
    If $l_p_ItemsPtr = 0 Then Return $l_ai2_Items

    For $l_i_Idx = 0 To $l_i_ItemCount - 1
        ; Read ModelID
        $l_ai2_Items[$l_i_Idx + 1][0] = GwAu3_ItemMod_GetItemInfoByPtr(GwAu3_Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8), "long"), "ModelID")
        ; Read item quantity
        $l_ai2_Items[$l_i_Idx + 1][1] = GwAu3_Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8) + 4, "long")
    Next

    Return $l_ai2_Items
EndFunc

Func GwAu3_TradeMod_GetArrayPartnerTradeItems()
    Local $l_i_ItemCount = GwAu3_TradeMod_GetTradeInfo("PartnerItemCount")

    If $l_i_ItemCount = 0 Then
        Local $l_ai2_Items[1] = [0]
        Return $l_ai2_Items
    EndIf

    Local $l_ai2_Items[$l_i_ItemCount + 1][2]
    $l_ai2_Items[0][0] = $l_i_ItemCount

    Local $l_p_ItemsPtr = GwAu3_TradeMod_GetTradeInfo("PartnerItemsPtr")
    If $l_p_ItemsPtr = 0 Then Return $l_ai2_Items

    For $l_i_Idx = 0 To $l_i_ItemCount - 1
        ; Read ModelID
        $l_ai2_Items[$l_i_Idx + 1][0] = GwAu3_ItemMod_GetItemInfoByPtr(GwAu3_Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8), "long"), "ModelID")
        ; Read item quantity
        $l_ai2_Items[$l_i_Idx + 1][1] = GwAu3_Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8) + 4, "long")
    Next

    Return $l_ai2_Items
EndFunc
#EndRegion Trade Context Related