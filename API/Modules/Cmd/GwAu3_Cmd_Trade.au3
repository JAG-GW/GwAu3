#include-once

;~ Description: Initiates a trade with a player based on AgentID
Func Trade_InitiateTrade_($a_v_Agent)
    Return Core_SendPacket(0x08, $GC_I_HEADER_TRADE_INITIATE, Agent_ConvertID($a_v_Agent))
EndFunc   ;==>TradePlayer

;~ Description: Like pressing the "Accept" button in a trade. Can only be used after both players have submitted their offer
Func Trade_AcceptTrade_()
    Return Core_SendPacket(0x4, $GC_I_HEADER_TRADE_ACCEPT)
EndFunc   ;==>AcceptTrade

;~ Description: Like pressing the "Submit Offer" button in a trade
Func Trade_SubmitOffer_($a_i_Gold = 0)
    Return Core_SendPacket(0x8, $GC_I_HEADER_TRADE_SUBMIT_OFFER, $a_i_Gold)
EndFunc   ;==>SubmitOffer

;~ Description: Like pressing the "Cancel" button in a trade
Func Trade_CancelTrade_()
    Return Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CANCEL)
EndFunc   ;==>CancelTrade

;~ Description: Like pressing the "Change Offer" button
Func Trade_ChangeOffer_()
    Return Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CANCEL_OFFER)
EndFunc   ;==>ChangeOffer

;~ $a_i_ItemID = ID of the item or item agent, $a_i_Quantity = Quantity
Func Trade_OfferItem_($a_i_ItemID, $a_i_Quantity = 1)
    Return Core_SendPacket(0xC, $GC_I_HEADER_TRADE_ADD_ITEM, $a_i_ItemID, $a_i_Quantity)
EndFunc   ;==>OfferItem

;~ Description: Resets the TradePartner value in memory
Func Trade_InitTradePartner()
    Memory_Write($g_p_TradePartner, 0)
EndFunc

;~ Description: Retrieves the PlayerNumber of the last player that initiated a trade
Func Trade_GetTradePartner()
    Local $l_i_TradePartner = Memory_Read($g_p_TradePartner)
    If $l_i_TradePartner <> 0 Then 
        Memory_Write($g_p_TradePartner, 0)
        Return $l_i_TradePartner
    EndIf
    Return 0
EndFunc

;~ Description: Initiates a trade with a player based on AgentID
Func Trade_InitiateTrade($a_v_Agent)
    DllStructSetData($g_d_TradeInitiate, 2, $GC_I_UIMSG_INITIATE_TRADE)
    DllStructSetData($g_d_TradeInitiate, 3, Agent_ConvertID($a_v_Agent))
    Core_Enqueue($g_p_TradeInitiate, 12)
EndFunc   ;==>Trade_InitiateTrade

;~ Description: Cancel the current trade session
Func Trade_CancelTrade()
    Core_Enqueue($g_p_TradeCancel, 4)
EndFunc

;~ Description: Accept the trade; only possible once both sides submitted their offers
Func Trade_AcceptTrade()
    Core_Enqueue($g_p_TradeAccept, 4)
EndFunc

;~ Description: Submit player's trade offer including $a_i_Gold amount; submitted offer will not be visible for the one running this command
Func Trade_SubmitOffer($a_i_Gold = 0)
    DllStructSetData($g_d_TradeSubmitOffer, 2, $a_i_Gold)
    Core_Enqueue($g_p_TradeSubmitOffer, 8)
EndFunc

;~ Description: Add $a_v_Item with $a_i_Qty to trade window; offered item will not be visible for the one running this command and will not appear in the TradeInfo array.
Func Trade_OfferItem($a_v_Item, $a_i_Qty = 1)
    DllStructSetData($g_d_TradeOfferItem, 2, Item_ItemID($a_v_Item))
    DllStructSetData($g_d_TradeOfferItem, 3, $a_i_Qty)
    Core_Enqueue($g_p_TradeOfferItem, 12)
EndFunc