#include-once
#include "TradeMod_Initialize.au3"

Func _TradeMod_GetLastTransaction()
    Local $result[4] = [$g_iLastTransactionType, $g_iLastItemID, $g_iLastQuantity, $g_iLastPrice]
    Return $result
EndFunc

Func _TradeMod_GetTraderQuoteID()
    Return MemoryRead($g_mTraderQuoteID, 'dword')
EndFunc

Func _TradeMod_GetTraderCostID()
    Return MemoryRead($g_mTraderCostID, 'dword')
EndFunc

Func _TradeMod_GetTraderCostValue()
    Return MemoryRead($g_mTraderCostValue, 'dword')
EndFunc

Func _TradeMod_GetTraderQuoteInfo()
    Local $result[3]
    $result[0] = MemoryRead($g_mTraderQuoteID, 'dword')
    $result[1] = MemoryRead($g_mTraderCostID, 'dword')
    $result[2] = MemoryRead($g_mTraderCostValue, 'dword')
    Return $result
EndFunc

Func _TradeMod_IsValidQuote()
    Local $iCostID = MemoryRead($g_mTraderCostID, 'dword')
    Local $iCostValue = MemoryRead($g_mTraderCostValue, 'dword')
    Return ($iCostID > 0 And $iCostValue > 0)
EndFunc

Func _TradeMod_ClearTraderQuote()
    MemoryWrite($g_mTraderCostID, 0, 'dword')
    MemoryWrite($g_mTraderCostValue, 0, 'dword')
    _Log_Debug("Trader quote data cleared", "TradeMod", $GUIEdit)
EndFunc

Func _TradeMod_GetTransactionTypeName($iTransactionType)
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

Func _TradeMod_GetSalvageTypeName($iSalvageType)
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

Func _TradeMod_WaitForQuote($iTimeout = 5000)
    Local $iStartTime = TimerInit()

    While TimerDiff($iStartTime) < $iTimeout
        If _TradeMod_IsValidQuote() Then
            _Log_Debug("Quote received after " & TimerDiff($iStartTime) & "ms", "TradeMod", $GUIEdit)
            Return True
        EndIf
        Sleep(32) ; Small delay to prevent excessive polling
    WEnd

    _Log_Warning("Quote request timed out after " & $iTimeout & "ms", "TradeMod", $GUIEdit)
    Return False
EndFunc

Func _TradeMod_GetBuyItemBase()
    Return $g_mBuyItemBase
EndFunc

Func _TradeMod_GetSalvageGlobal()
    Return $g_mSalvageGlobal
EndFunc