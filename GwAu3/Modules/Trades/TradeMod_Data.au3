#include-once
#include "TradeMod_Initialize.au3"

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetLastTransaction
; Description ...: Returns information about the last transaction
; Syntax.........: _TradeMod_GetLastTransaction()
; Parameters ....: None
; Return values .: Array[4] - [0] = Transaction type, [1] = Item ID, [2] = Quantity, [3] = Price
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Returns [-1, 0, 0, 0] if no transactions have been made
;                  - Useful for tracking and debugging
; Related .......: _TradeMod_SellItem, _TradeMod_BuyItem
;============================================================================================
Func _TradeMod_GetLastTransaction()
    Local $result[4] = [$g_iLastTransactionType, $g_iLastItemID, $g_iLastQuantity, $g_iLastPrice]
    Return $result
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetTraderQuoteID
; Description ...: Returns the current trader quote ID
; Syntax.........: _TradeMod_GetTraderQuoteID()
; Parameters ....: None
; Return values .: Current trader quote ID
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Updates each time a quote is requested
;                  - Used to track quote responses
; Related .......: _TradeMod_RequestQuote, _TradeMod_RequestQuoteSell
;============================================================================================
Func _TradeMod_GetTraderQuoteID()
    Return MemoryRead($g_mTraderQuoteID, 'dword')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetTraderCostID
; Description ...: Returns the current trader cost ID
; Syntax.........: _TradeMod_GetTraderCostID()
; Parameters ....: None
; Return values .: Current trader cost ID (item ID for current quote)
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Set by trader hook when quote is received
;                  - Returns 0 if no valid quote is available
; Related .......: _TradeMod_GetTraderCostValue, _TradeMod_TraderBuy
;============================================================================================
Func _TradeMod_GetTraderCostID()
    Return MemoryRead($g_mTraderCostID, 'dword')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetTraderCostValue
; Description ...: Returns the current trader cost value
; Syntax.........: _TradeMod_GetTraderCostValue()
; Parameters ....: None
; Return values .: Current trader cost value (price for current quote)
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Set by trader hook when quote is received
;                  - Returns 0 if no valid quote is available
; Related .......: _TradeMod_GetTraderCostID, _TradeMod_TraderSell
;============================================================================================
Func _TradeMod_GetTraderCostValue()
    Return MemoryRead($g_mTraderCostValue, 'dword')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetTraderQuoteInfo
; Description ...: Returns complete information about the current trader quote
; Syntax.........: _TradeMod_GetTraderQuoteInfo()
; Parameters ....: None
; Return values .: Array[3] - [0] = Quote ID, [1] = Cost ID (Item ID), [2] = Cost Value (Price)
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Combines all trader quote information in one call
;                  - Returns [0, 0, 0] if no valid quote is available
; Related .......: _TradeMod_RequestQuote, _TradeMod_TraderBuy, _TradeMod_TraderSell
;============================================================================================
Func _TradeMod_GetTraderQuoteInfo()
    Local $result[3]
    $result[0] = MemoryRead($g_mTraderQuoteID, 'dword')
    $result[1] = MemoryRead($g_mTraderCostID, 'dword')
    $result[2] = MemoryRead($g_mTraderCostValue, 'dword')
    Return $result
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_IsValidQuote
; Description ...: Checks if there is a valid trader quote available
; Syntax.........: _TradeMod_IsValidQuote()
; Parameters ....: None
; Return values .: True if a valid quote is available, False otherwise
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Checks if both cost ID and cost value are non-zero
;                  - Use before attempting trader buy/sell operations
; Related .......: _TradeMod_GetTraderQuoteInfo, _TradeMod_TraderBuy
;============================================================================================
Func _TradeMod_IsValidQuote()
    Local $iCostID = MemoryRead($g_mTraderCostID, 'dword')
    Local $iCostValue = MemoryRead($g_mTraderCostValue, 'dword')
    Return ($iCostID > 0 And $iCostValue > 0)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_ClearTraderQuote
; Description ...: Clears the current trader quote data
; Syntax.........: _TradeMod_ClearTraderQuote()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Resets all trader quote values to 0
;                  - Called automatically after successful trader operations
; Related .......: _TradeMod_TraderBuy, _TradeMod_TraderSell
;============================================================================================
Func _TradeMod_ClearTraderQuote()
    MemoryWrite($g_mTraderCostID, 0, 'dword')
    MemoryWrite($g_mTraderCostValue, 0, 'dword')
    _Log_Debug("Trader quote data cleared", "TradeMod", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetTransactionTypeName
; Description ...: Returns the name of a transaction type
; Syntax.........: _TradeMod_GetTransactionTypeName($iTransactionType)
; Parameters ....: $iTransactionType - Transaction type constant
; Return values .: String name of the transaction type, "Unknown" if invalid
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Useful for logging and debugging
;                  - Converts transaction type constants to readable names
; Related .......: _TradeMod_GetLastTransaction
;============================================================================================
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

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetSalvageTypeName
; Description ...: Returns the name of a salvage type
; Syntax.........: _TradeMod_GetSalvageTypeName($iSalvageType)
; Parameters ....: $iSalvageType - Salvage type constant
; Return values .: String name of the salvage type, "Unknown" if invalid
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Useful for logging and debugging
;                  - Converts salvage type constants to readable names
; Related .......: _TradeMod_SalvageItem
;============================================================================================
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

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_WaitForQuote
; Description ...: Waits for a trader quote response
; Syntax.........: _TradeMod_WaitForQuote($iTimeout = 5000)
; Parameters ....: $iTimeout - [optional] Maximum time to wait in milliseconds (default: 5000)
; Return values .: True if quote received, False if timeout
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Polls trader quote data until valid response or timeout
;                  - Use after requesting a quote to wait for server response
;                  - Includes small sleep to prevent excessive CPU usage
; Related .......: _TradeMod_RequestQuote, _TradeMod_IsValidQuote
;============================================================================================
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

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetBuyItemBase
; Description ...: Returns the buy item base address
; Syntax.........: _TradeMod_GetBuyItemBase()
; Parameters ....: None
; Return values .: Buy item base address as pointer
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Used for advanced item purchasing operations
;                  - Returns the memory address for buy item data structure
; Related .......: _TradeMod_BuyItem
;============================================================================================
Func _TradeMod_GetBuyItemBase()
    Return $g_mBuyItemBase
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _TradeMod_GetSalvageGlobal
; Description ...: Returns the salvage global data address
; Syntax.........: _TradeMod_GetSalvageGlobal()
; Parameters ....: None
; Return values .: Salvage global data address as pointer
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Used for advanced salvage operations
;                  - Returns the memory address for salvage global data
; Related .......: _TradeMod_SalvageItem
;============================================================================================
Func _TradeMod_GetSalvageGlobal()
    Return $g_mSalvageGlobal
EndFunc