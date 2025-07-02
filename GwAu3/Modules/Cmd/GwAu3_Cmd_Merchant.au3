#include-once

;~ Description: Internal use for BuyItem()
Func GwAu3_Merchant_GetMerchantItemsBase()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x24]
    Local $l_av_Return = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsBase

;~ Description: Internal use for BuyItem()
Func GwAu3_Merchant_GetMerchantItemsSize()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x28]
    Local $l_av_Return = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsSize

;~ Description: Internal use for buy an item, extraID is for dye
Func GwAu3_Merchant_BuyItem($a_i_ModelID, $a_i_Quantity = 1, $a_b_Trader = False, $a_i_ExtraID = -1)
	If $a_b_Trader Then
        Local $l_i_BoughtCount = 0

        For $i = 1 To $a_i_Quantity
            ; Find the item in trader's inventory
            Local $l_a_Offset[4] = [0, 0x18, 0x40, 0xC0]
            Local $l_i_ItemArraySize = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
            Local $l_ptr_Item = 0
            Local $l_b_Found = False
            Local $l_i_QuoteID = GwAu3_Memory_Read($g_i_TraderQuoteID)

            ; Search for item with matching ModelID
            For $l_i_ItemID = 1 To $l_i_ItemArraySize[1]
                $l_ptr_Item = GwAu3_Item_GetItemPtr($l_i_ItemID)
                If $l_ptr_Item = 0 Then ContinueLoop

                Local $l_i_CurrentModelID = GwAu3_Memory_Read($l_ptr_Item + 44, 'long')

                If $l_i_CurrentModelID = $a_i_ModelID Then
                    Local $l_i_Offset12 = GwAu3_Memory_Read($l_ptr_Item + 12, 'ptr')
                    Local $l_i_Offset4 = GwAu3_Memory_Read($l_ptr_Item + 4, 'long')

                    If $l_i_Offset12 = 0 And $l_i_Offset4 = 0 Then
                        If $a_i_ExtraID = -1 Then
                            $l_b_Found = True
                            ExitLoop
                        Else
                            Local $l_i_ItemExtraID = GwAu3_Memory_Read($l_ptr_Item + 34, 'short')
                            If $l_i_ItemExtraID = $a_i_ExtraID Then
                                $l_b_Found = True
                                ExitLoop
                            EndIf
                        EndIf
                    EndIf
                EndIf
            Next

            If Not $l_b_Found Then
                Return $l_i_BoughtCount
            EndIf

            ; Request quote
            Local $l_i_ItemID = GwAu3_Item_ItemID($l_ptr_Item)
            DllStructSetData($g_d_RequestQuote, 2, $l_i_ItemID)
            GwAu3_Core_Enqueue($g_p_RequestQuote, 8)

            ; Wait for quote
            Local $l_i_Deadlock = TimerInit()
            Local $l_i_Timeout = 5000

            Do
                Sleep(36)
                Local $l_i_NewQuoteID = GwAu3_Memory_Read($g_i_TraderQuoteID)
            Until $l_i_NewQuoteID <> $l_i_QuoteID Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

            If TimerDiff($l_i_Deadlock) > $l_i_Timeout Then
                Return $l_i_BoughtCount
            EndIf

            ; Check if we have valid trader cost data
            Local $l_i_CostID = GwAu3_Memory_Read($g_i_TraderCostID)
            Local $l_f_CostValue = GwAu3_Memory_Read($g_f_TraderCostValue)

            If Not $l_i_CostID Or Not $l_f_CostValue Then
                Return $l_i_BoughtCount
            EndIf

            ; Execute trader buy
            GwAu3_Core_Enqueue($g_p_TraderBuy, 4)
            ; Wait for transaction
            Sleep(36)
            $l_i_BoughtCount += 1
        Next
        Return $l_i_BoughtCount > 0
    Else
        ; Standard merchant buy - search by ModelID
        Local $l_p_MerchantItemsBase = GwAu3_Merchant_GetMerchantItemsBase()
        If Not $l_p_MerchantItemsBase Then Return False

        Local $l_i_MerchantSize = GwAu3_Merchant_GetMerchantItemsSize()
        Local $l_i_FoundIndex = 0
        Local $l_i_FoundItemID = 0
		Local $l_i_ItemValue = 0

        ; Search for ModelID in merchant's items
        For $i = 1 To $l_i_MerchantSize
            Local $l_i_ItemID = GwAu3_Memory_Read($l_p_MerchantItemsBase + 4 * ($i - 1))
            Local $l_ptr_Item = GwAu3_Item_GetItemPtr($l_i_ItemID)
            If $l_ptr_Item = 0 Then ContinueLoop

            Local $l_i_CurrentModelID = GwAu3_Memory_Read($l_ptr_Item + 44, 'long')

            If $l_i_CurrentModelID = $a_i_ModelID Then
                If $a_i_ExtraID = -1 Then
                    $l_i_FoundIndex = $i
                    $l_i_FoundItemID = $l_i_ItemID
                    $l_i_ItemValue = GwAu3_Memory_Read($l_ptr_Item + 36, 'short')
                    ExitLoop
                Else
                    Local $l_i_ItemExtraID = GwAu3_Memory_Read($l_ptr_Item + 34, 'short')
                    If $l_i_ItemExtraID = $a_i_ExtraID Then
                        $l_i_FoundIndex = $i
                        $l_i_FoundItemID = $l_i_ItemID
                        $l_i_ItemValue = GwAu3_Memory_Read($l_ptr_Item + 36, 'short')
                        ExitLoop
                    EndIf
                EndIf
            EndIf
        Next

        If $l_i_FoundIndex = 0 Then Return False

        DllStructSetData($g_d_BuyItem, 2, $a_i_Quantity)
        DllStructSetData($g_d_BuyItem, 3, $l_i_FoundItemID)
        DllStructSetData($g_d_BuyItem, 4, $a_i_Quantity * ($l_i_ItemValue*2))
        DllStructSetData($g_d_BuyItem, 5, GwAu3_Memory_GetValue('BuyItemBase'))
        GwAu3_Core_Enqueue($g_p_BuyItem, 20)

        Return True
    EndIf
EndFunc ;==>GwAu3_Merchant_BuyItem

Func GwAu3_Merchant_SellItem($a_p_Item, $a_i_Quantity = 1, $a_b_Trader = False)
    Local $l_i_ItemID = GwAu3_Item_ItemID($a_p_Item)
    Local $l_ptr_Item = GwAu3_Item_GetItemPtr($a_p_Item)
    Local $l_i_ItemQuantity = GwAu3_Memory_Read($l_ptr_Item + 76, 'short')

    ; Adjust quantity if needed
    If $a_i_Quantity = 0 Or $a_i_Quantity > $l_i_ItemQuantity Then
        $a_i_Quantity = $l_i_ItemQuantity
    EndIf

    If $a_b_Trader Then
        ; Trader sell process - one by one
        Local $l_i_SoldCount = 0

        For $i = 1 To $a_i_Quantity
            ; First request quote
            DllStructSetData($g_d_RequestQuoteSell, 2, $l_i_ItemID)
            GwAu3_Core_Enqueue($g_p_RequestQuoteSell, 8)

            ; Wait for quote response
            Local $l_i_Timeout = TimerInit()
            Do
                Sleep(50)
                Local $l_i_CostID = GwAu3_Memory_Read($g_i_TraderCostID, 'dword')
            Until $l_i_CostID = $l_i_ItemID Or TimerDiff($l_i_Timeout) > 2000

            ; Check if quote received
            If TimerDiff($l_i_Timeout) > 2000 Then
                GwAu3_Log_Warning("Trader quote timeout for item " & $l_i_ItemID & " (iteration " & $i & ")", "TradeMod", $g_h_EditText)
                ExitLoop
            EndIf

            ; Execute trader sell
            Local $l_i_CostValue = GwAu3_Memory_Read($g_f_TraderCostValue, 'dword')
            GwAu3_Core_Enqueue($g_p_TraderSell, 4)

            ; Wait a bit for transaction to complete
            Sleep(250)

            $l_i_SoldCount += 1

            ; Check if item still exists (stack might be depleted)
            Local $l_i_CurrentQuantity = GwAu3_Memory_Read($l_ptr_Item + 76, 'short')
            If $l_i_CurrentQuantity = 0 Then ExitLoop
        Next

        GwAu3_Log_Debug("Sold to trader: Item " & $l_i_ItemID & " x" & $l_i_SoldCount & " (requested: " & $a_i_Quantity & ")", "TradeMod", $g_h_EditText)

    Else
        ; Standard merchant sell - can sell multiple at once
        Local $l_i_Value = GwAu3_Memory_Read($l_ptr_Item + 36, 'short')

        DllStructSetData($g_d_SellItem, 2, $a_i_Quantity * $l_i_Value)
        DllStructSetData($g_d_SellItem, 3, $l_i_ItemID)
        GwAu3_Core_Enqueue($g_p_SellItem, 12)

        GwAu3_Log_Debug("Sold to merchant: Item " & $l_i_ItemID & " x" & $a_i_Quantity, "TradeMod", $g_h_EditText)
    EndIf

    Return True
EndFunc ;==>GwAu3_Merchant_SellItem

Func GwAu3_Merchant_CraftItem($a_i_RecipeID, $a_i_Quantity = 1, $a_v_Materials = 0, $a_i_CrafterID = 0, $a_i_Flags = 0)
    If $a_i_RecipeID <= 0 Then
        GwAu3_Log_Error("Invalid recipe ID: " & $a_i_RecipeID, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Quantity <= 0 Or $a_i_Quantity > $GC_I_MERCHANT_MAX_ITEM_STACK Then
        GwAu3_Log_Error("Invalid quantity: " & $a_i_Quantity, "TradeMod", $g_h_EditText)
        Return False
    EndIf

    Local $l_p_MaterialsPtr = 0
    If IsArray($a_v_Materials) Then
        ; Handle materials array if provided
        ; For now, we'll use a simple pointer approach
        $l_p_MaterialsPtr = Ptr($a_v_Materials)
    EndIf

    DllStructSetData($g_d_CraftItemEx, 2, $a_i_RecipeID)
    DllStructSetData($g_d_CraftItemEx, 3, $a_i_Quantity)
    DllStructSetData($g_d_CraftItemEx, 4, $l_p_MaterialsPtr)
    DllStructSetData($g_d_CraftItemEx, 5, $a_i_CrafterID)
    DllStructSetData($g_d_CraftItemEx, 6, $a_i_Flags)

    GwAu3_Core_Enqueue($g_p_CraftItemEx, 24)

    ; Record for tracking
    $g_i_LastTransactionType = $GC_I_TRANSACTION_CRAFT
    $g_i_LastItemID = $a_i_RecipeID
    $g_i_LastQuantity = $a_i_Quantity

    GwAu3_Log_Debug("Crafting item " & $a_i_RecipeID & " (quantity: " & $a_i_Quantity & ") with crafter " & $a_i_CrafterID, "TradeMod", $g_h_EditText)
    Return True
EndFunc
