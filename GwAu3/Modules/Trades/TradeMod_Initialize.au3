#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

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

#Region Module Global Variables
; Merchant data pointers
Global $g_mBuyItemBase      ; Pointer to buy item base
Global $g_mTraderQuoteID    ; Current trader quote ID
Global $g_mTraderCostID     ; Trader cost ID
Global $g_mTraderCostValue  ; Trader cost value
Global $g_mSalvageGlobal    ; Pointer to salvage global data

; Merchant command structures
Global $g_mSellItem = DllStructCreate('ptr;dword;dword;dword')
Global $g_mSellItemPtr = DllStructGetPtr($g_mSellItem)

Global $g_mBuyItem = DllStructCreate('ptr;dword;dword;dword;dword')
Global $g_mBuyItemPtr = DllStructGetPtr($g_mBuyItem)

Global $g_mCraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Global $g_mCraftItemExPtr = DllStructGetPtr($g_mCraftItemEx)

Global $g_mRequestQuote = DllStructCreate('ptr;dword')
Global $g_mRequestQuotePtr = DllStructGetPtr($g_mRequestQuote)

Global $g_mRequestQuoteSell = DllStructCreate('ptr;dword')
Global $g_mRequestQuoteSellPtr = DllStructGetPtr($g_mRequestQuoteSell)

Global $g_mTraderBuy = DllStructCreate('ptr')
Global $g_mTraderBuyPtr = DllStructGetPtr($g_mTraderBuy)

Global $g_mTraderSell = DllStructCreate('ptr')
Global $g_mTraderSellPtr = DllStructGetPtr($g_mTraderSell)

Global $g_mSalvage = DllStructCreate('ptr;dword;dword;dword')
Global $g_mSalvagePtr = DllStructGetPtr($g_mSalvage)

; Module state variables
Global $g_bTradeModuleInitialized = False
Global $g_iLastTransactionType = -1
Global $g_iLastItemID = 0
Global $g_iLastQuantity = 0
Global $g_iLastPrice = 0
#EndRegion Module Global Variables

#Region Initialize Functions
Func _TradeMod_Initialize()
    If $g_bTradeModuleInitialized Then
        _Log_Warning("TradeMod module already initialized", "TradeMod", $GUIEdit)
        Return True
    EndIf

    ; Initialize merchant data
    _TradeMod_InitializeData()

    ; Initialize commands
    _TradeMod_InitializeCommands()

    $g_bTradeModuleInitialized = True
    Return True
EndFunc

Func _TradeMod_InitializeData()
    ; Read buy item base address
    $g_mBuyItemBase = MemoryRead(GetScannedAddress('ScanBuyItemBase', 0xF))
    If $g_mBuyItemBase = 0 Then _Log_Error("Invalid BuyItemBase address", "TradeMod", $GUIEdit)
    SetValue('BuyItemBase', Ptr($g_mBuyItemBase))
    _Log_Debug("BuyItemBase: " & Ptr($g_mBuyItemBase), "TradeMod", $GUIEdit)

    ; Read salvage global address
    $g_mSalvageGlobal = MemoryRead(GetScannedAddress('ScanSalvageGlobal', 1) - 0x4)
    If $g_mSalvageGlobal = 0 Then _Log_Error("Invalid SalvageGlobal address", "TradeMod", $GUIEdit)
    SetValue('SalvageGlobal', Ptr($g_mSalvageGlobal))
    _Log_Debug("SalvageGlobal: " & Ptr($g_mSalvageGlobal), "TradeMod", $GUIEdit)
EndFunc

Func _TradeMod_InitializeCommands()
    ; Setup merchant functions
    SetValue('SellItemFunction', Ptr(GetScannedAddress('ScanSellItemFunction', -0x55)))
    SetValue('TransactionFunction', Ptr(GetScannedAddress('ScanTransactionFunction', -0x7E)))
    SetValue('RequestQuoteFunction', Ptr(GetScannedAddress('ScanRequestQuoteFunction', -0x34)))
    SetValue('TraderFunction', Ptr(GetScannedAddress('ScanTraderFunction', -0x1E)))
    SetValue('SalvageFunction', Ptr(GetScannedAddress('ScanSalvageFunction', -0xA)))

    _Log_Debug("SellItemFunction: " & GetValue('SellItemFunction'), "TradeMod", $GUIEdit)
    _Log_Debug("TransactionFunction: " & GetValue('TransactionFunction'), "TradeMod", $GUIEdit)
    _Log_Debug("RequestQuoteFunction: " & GetValue('RequestQuoteFunction'), "TradeMod", $GUIEdit)
    _Log_Debug("TraderFunction: " & GetValue('TraderFunction'), "TradeMod", $GUIEdit)
    _Log_Debug("SalvageFunction: " & GetValue('SalvageFunction'), "TradeMod", $GUIEdit)
EndFunc

Func _TradeMod_Cleanup()
    If Not $g_bTradeModuleInitialized Then Return

    ; Reset state variables
    $g_iLastTransactionType = -1
    $g_iLastItemID = 0
    $g_iLastQuantity = 0
    $g_iLastPrice = 0
    $g_bTradeModuleInitialized = False
EndFunc
#EndRegion Initialize Functions

#Region Pattern, Structure & Assembly Code Generation
Func _TradeMod_DefinePatterns()
    _('ScanSellItemFunction:')
	AddPattern('8B4D2085C90F858E') ; COULD NOT UPDATE! 23.12.24
    _('ScanTransactionFunction:')
	AddPattern('85FF741D8B4D14EB08') ;STILL WORKING 23.12.24
    _('ScanBuyItemBase:')
	AddPattern('D9EED9580CC74004') ;STILL WORKING 23.12.24
    _('ScanRequestQuoteFunction:')
	AddPattern('8B752083FE107614')  ;STILL WORKING 23.12.24
    _('ScanTraderFunction:')
	AddPattern('83FF10761468D2210000') ;STILL WORKING 23.12.24
    _('ScanSalvageFunction:')
	AddPattern('33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC76') ; UPDATED 24.12.24
    _('ScanSalvageGlobal:')
	AddPattern('8B4A04538945F48B4208') ; UPDATED 24.12.24
EndFunc

Func _TradeMod_CreateSellItemCommand()
    _('CommandSellItem:')
    _('mov esi,eax')
    _('add esi,C')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push dword[eax+4]')
    _('push 0')
    _('add eax,8')
    _('push eax')
    _('push 1')
    _('push 0')
    _('push B')
    _('call TransactionFunction')
    _('add esp,24')
    _('ljmp CommandReturn')
EndFunc

Func _TradeMod_CreateBuyItemCommand()
    _('CommandBuyItem:')
    _('mov esi,eax')
    _('add esi,10')
    _('mov ecx,eax')
    _('add ecx,4')
    _('push ecx')
    _('mov edx,eax')
    _('add edx,8')
    _('push edx')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('mov eax,dword[eax+C]')
    _('push eax')
    _('push 1')
    _('call TransactionFunction')
    _('add esp,24')
    _('ljmp CommandReturn')
EndFunc

Func _TradeMod_CreateCraftItemExCommand()
    _('CommandCraftItemEx:')
    _('add eax,4')
    _('push eax')
    _('add eax,4')
    _('push eax')
    _('push 1')
    _('push 0')
    _('push 0')
    _('mov ecx,dword[TradeID]')
    _('mov ecx,dword[ecx]')
    _('mov edx,dword[eax+4]')
    _('lea ecx,dword[ebx+ecx*4]')
    _('push ecx')
    _('push 1')
    _('push dword[eax+8]')
    _('push dword[eax+C]')
    _('call TraderFunction')
    _('add esp,24')
    _('mov dword[TraderCostID],0')
    _('ljmp CommandReturn')
EndFunc

Func _TradeMod_CreateRequestQuoteCommand()
    _('CommandRequestQuote:')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('mov esi,eax')
    _('add esi,4')
    _('push esi')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push C')
    _('mov ecx,0')
    _('mov edx,2')
    _('call RequestQuoteFunction')
    _('add esp,20')
    _('ljmp CommandReturn')
EndFunc

Func _TradeMod_CreateRequestQuoteSellCommand()
    _('CommandRequestQuoteSell:')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('add eax,4')
    _('push eax')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push D')
    _('xor edx,edx')
    _('call RequestQuoteFunction')
    _('add esp,20')
    _('ljmp CommandReturn')
EndFunc

Func _TradeMod_CreateTraderBuyCommand()
    _('CommandTraderBuy:')
    _('push 0')
    _('push TraderCostID')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('mov edx,dword[TraderCostValue]')
    _('push edx')
    _('push C')
    _('mov ecx,C')
    _('call TraderFunction')
    _('add esp,24')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('ljmp CommandReturn')
EndFunc

Func _TradeMod_CreateTraderSellCommand()
    _('CommandTraderSell:')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push dword[TraderCostValue]')
    _('push 0')
    _('push TraderCostID')
    _('push 1')
    _('push 0')
    _('push D')
    _('mov ecx,d')
    _('xor edx,edx')
    _('call TransactionFunction')
    _('add esp,24')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('ljmp CommandReturn')
EndFunc

Func _TradeMod_CreateSalvageCommand()
    _('CommandSalvage:')
    _('push eax')
    _('push ecx')
    _('push ebx')
    _('mov ebx,SalvageGlobal')
    _('mov ecx,dword[eax+4]')
    _('mov dword[ebx],ecx')
    _('add ebx,4')
    _('mov ecx,dword[eax+8]')
    _('mov dword[ebx],ecx')
    _('mov ebx,dword[eax+4]')
    _('push ebx')
    _('mov ebx,dword[eax+8]')
    _('push ebx')
    _('mov ebx,dword[eax+c]')
    _('push ebx')
    _('call SalvageFunction')
    _('add esp,C')
    _('pop ebx')
    _('pop ecx')
    _('pop eax')
    _('ljmp CommandReturn')
EndFunc
#EndRegion Pattern, Structure & Assembly Code Generation

#Region Internal Functions
Func _TradeMod_CreateCommands()
    ; Command for selling an item
    _TradeMod_CreateSellItemCommand()

    ; Command for buying an item
    _TradeMod_CreateBuyItemCommand()

    ; Command for crafting an item
    _TradeMod_CreateCraftItemExCommand()

    ; Command for requesting a quote
    _TradeMod_CreateRequestQuoteCommand()

    ; Command for requesting a sell quote
    _TradeMod_CreateRequestQuoteSellCommand()

    ; Command for trader buy
    _TradeMod_CreateTraderBuyCommand()

    ; Command for trader sell
    _TradeMod_CreateTraderSellCommand()

    ; Command for salvaging
    _TradeMod_CreateSalvageCommand()
EndFunc
#EndRegion Internal Functions