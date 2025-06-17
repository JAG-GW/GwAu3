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