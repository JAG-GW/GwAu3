#include-once

Func Merchant_GetLastTransaction()
    Local $l_ai_Result[4] = [$g_i_LastTransactionType, $g_i_LastItemID, $g_i_LastQuantity, $g_i_LastPrice]
    Return $l_ai_Result
EndFunc

Func Merchant_GetTraderQuoteID()
    Return Memory_Read($g_i_TraderQuoteID, 'dword')
EndFunc

Func Merchant_GetTraderCostID()
    Return Memory_Read($g_i_TraderCostID, 'dword')
EndFunc

Func Merchant_GetTraderCostValue()
    Return Memory_Read($g_f_TraderCostValue, 'dword')
EndFunc

Func Merchant_GetTraderQuoteInfo()
    Local $l_ai_Result[3]
    $l_ai_Result[0] = Memory_Read($g_i_TraderQuoteID, 'dword')
    $l_ai_Result[1] = Memory_Read($g_i_TraderCostID, 'dword')
    $l_ai_Result[2] = Memory_Read($g_f_TraderCostValue, 'dword')
    Return $l_ai_Result
EndFunc

Func Merchant_IsValidQuote()
    Local $l_i_CostID = Memory_Read($g_i_TraderCostID, 'dword')
    Local $l_i_CostValue = Memory_Read($g_f_TraderCostValue, 'dword')
    Return ($l_i_CostID > 0 And $l_i_CostValue > 0)
EndFunc

Func Merchant_ClearTraderQuote()
    Memory_Write($g_i_TraderCostID, 0, 'dword')
    Memory_Write($g_f_TraderCostValue, 0, 'dword')
    Log_Debug("Trader quote data cleared", "TradeMod", $g_h_EditText)
EndFunc

Func Merchant_GetTransactionTypeName($a_i_TransactionType)
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

Func Merchant_GetSalvageTypeName($a_i_SalvageType)
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

Func Merchant_WaitForQuote($a_i_Timeout = 5000)
    Local $l_i_StartTime = TimerInit()

    While TimerDiff($l_i_StartTime) < $a_i_Timeout
        If Merchant_IsValidQuote() Then
            Log_Debug("Quote received after " & TimerDiff($l_i_StartTime) & "ms", "TradeMod", $g_h_EditText)
            Return True
        EndIf
        Sleep(32) ; Small delay to prevent excessive polling
    WEnd

    Log_Warning("Quote request timed out after " & $a_i_Timeout & "ms", "TradeMod", $g_h_EditText)
    Return False
EndFunc

Func Merchant_GetBuyItemBase()
    Return $g_p_BuyItemBase
EndFunc

Func Merchant_GetSalvageGlobal()
    Return $g_p_SalvageGlobal
EndFunc