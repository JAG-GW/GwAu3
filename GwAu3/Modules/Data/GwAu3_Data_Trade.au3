#include-once

#Region Trade Context Related
Func Trade_GetTradePtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x58]
    Local $l_ap_TradePtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_TradePtr[1]
EndFunc

Func Trade_GetTradeInfo($a_s_Info = "")
    Local $l_p_Ptr = Trade_GetTradePtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "Flags"
            Return Memory_Read($l_p_Ptr, "long")
        Case "IsTradeClosed"
            Local $l_i_Flags = Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 0) = 0
        Case "IsTradeInitiated"
            Local $l_i_Flags = Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 1) <> 0
        Case "IsPartnerTradeOffered"
            Local $l_i_Flags = Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 2) <> 0
        Case "IsPlayerTradeOffered"
            Local $l_i_Flags = Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 3) <> 0
        Case "IsPlayerTradeAccepted"
            Local $l_i_Flags = Memory_Read($l_p_Ptr, "long")
            Return BitAND($l_i_Flags, 7) <> 0

        Case "PlayerGold"
            Return Memory_Read($l_p_Ptr + 0x10, "long")
        Case "PlayerItemsPtr"
            Return Memory_Read($l_p_Ptr + 0x14, "ptr")
        Case "PlayerItemCount"
            Return Memory_Read($l_p_Ptr + 0x1C, "long")

        Case "PartnerGold"
            Return Memory_Read($l_p_Ptr + 0x24, "long")
        Case "PartnerItemsPtr"
            Return Memory_Read($l_p_Ptr + 0x28, "ptr")
        Case "PartnerItemCount"
            Return Memory_Read($l_p_Ptr + 0x30, "long")

    EndSwitch

    Return 0
EndFunc

Func Trade_GetPlayerTradeItemsInfo($a_i_TradeSlot = 0, $a_s_Info = "")
    Local $l_p_ItemsPtr = Trade_GetTradeInfo("PlayerItemsPtr")
    If $l_p_ItemsPtr = 0 Or $a_s_Info = "" Then Return 0

    Local $l_i_ItemCount = Trade_GetTradeInfo("PlayerItemCount")
    If $l_i_ItemCount = 0 Or $a_i_TradeSlot >= $l_i_ItemCount Then Return 0

    Local $l_p_ItemPtr = $l_p_ItemsPtr + ($a_i_TradeSlot * 8)
    Local $l_i_ItemID = Memory_Read($l_p_ItemPtr, "long")

    Switch $a_s_Info
        Case "ItemID"
            Return $l_i_ItemID
        Case "Quantity"
            Return Memory_Read($l_p_ItemPtr + 4, "long")
        Case "ModelID"
            Return Item_GetItemInfoByPtr($l_p_ItemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func Trade_GetPartnerTradeItemsInfo($a_i_TradeSlot = 0, $a_s_Info = "")
    Local $l_p_ItemsPtr = Trade_GetTradeInfo("PartnerItemsPtr")
    If $l_p_ItemsPtr = 0 Or $a_s_Info = "" Then Return 0

    Local $l_i_ItemCount = Trade_GetTradeInfo("PartnerItemCount")
    If $l_i_ItemCount = 0 Or $a_i_TradeSlot >= $l_i_ItemCount Then Return 0

    Local $l_p_ItemPtr = $l_p_ItemsPtr + ($a_i_TradeSlot * 8)
    Local $l_i_ItemID = Memory_Read($l_p_ItemPtr, "long")

    Switch $a_s_Info
        Case "ItemID"
            Return $l_i_ItemID
        Case "Quantity"
            Return Memory_Read($l_p_ItemPtr + 4, "long")
        Case "ModelID"
            Return Item_GetItemInfoByPtr($l_p_ItemPtr, "ModelID")
    EndSwitch

    Return 0
EndFunc

Func Trade_GetArrayPlayerTradeItems()
    Local $l_i_ItemCount = Trade_GetTradeInfo("PlayerItemCount")

    If $l_i_ItemCount = 0 Then
        Local $l_ai2_Items[1] = [0]
        Return $l_ai2_Items
    EndIf

    Local $l_ai2_Items[$l_i_ItemCount + 1][2]
    $l_ai2_Items[0][0] = $l_i_ItemCount

    Local $l_p_ItemsPtr = Trade_GetTradeInfo("PlayerItemsPtr")
    If $l_p_ItemsPtr = 0 Then Return $l_ai2_Items

    For $l_i_Idx = 0 To $l_i_ItemCount - 1
        ; Read ModelID
        $l_ai2_Items[$l_i_Idx + 1][0] = Item_GetItemInfoByPtr(Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8), "long"), "ModelID")
        ; Read item quantity
        $l_ai2_Items[$l_i_Idx + 1][1] = Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8) + 4, "long")
    Next

    Return $l_ai2_Items
EndFunc

Func Trade_GetArrayPartnerTradeItems()
    Local $l_i_ItemCount = Trade_GetTradeInfo("PartnerItemCount")

    If $l_i_ItemCount = 0 Then
        Local $l_ai2_Items[1] = [0]
        Return $l_ai2_Items
    EndIf

    Local $l_ai2_Items[$l_i_ItemCount + 1][2]
    $l_ai2_Items[0][0] = $l_i_ItemCount

    Local $l_p_ItemsPtr = Trade_GetTradeInfo("PartnerItemsPtr")
    If $l_p_ItemsPtr = 0 Then Return $l_ai2_Items

    For $l_i_Idx = 0 To $l_i_ItemCount - 1
        ; Read ModelID
        $l_ai2_Items[$l_i_Idx + 1][0] = Item_GetItemInfoByPtr(Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8), "long"), "ModelID")
        ; Read item quantity
        $l_ai2_Items[$l_i_Idx + 1][1] = Memory_Read($l_p_ItemsPtr + ($l_i_Idx * 8) + 4, "long")
    Next

    Return $l_ai2_Items
EndFunc
#EndRegion Trade Context Related