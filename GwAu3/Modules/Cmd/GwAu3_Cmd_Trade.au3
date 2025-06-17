#include-once

Func GwAu3_Trade_TradePlayer($a_v_Agent)
    Return GwAu3_Core_SendPacket(0x08, $GC_I_HEADER_TRADE_INITIATE, GwAu3_Agent_ConvertID($a_v_Agent))
EndFunc   ;==>TradePlayer

Func GwAu3_Trade_AcceptTrade()
    Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_TRADE_ACCEPT)
EndFunc   ;==>AcceptTrade

;~ Description: Like pressing the "Accept" button in a trade. Can only be used after both players have submitted their offer.
Func GwAu3_Trade_SubmitOffer($a_i_Gold = 0)
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_TRADE_SUBMIT_OFFER, $a_i_Gold)
EndFunc   ;==>SubmitOffer

;~ Description: Like pressing the "Cancel" button in a trade.
Func GwAu3_Trade_CancelTrade()
    Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CANCEL)
EndFunc   ;==>CancelTrade

;~ Description: Like pressing the "Change Offer" button.
Func GwAu3_Trade_ChangeOffer()
    Return GwAu3_Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CANCEL_OFFER)
EndFunc   ;==>ChangeOffer

;~ $a_i_ItemID = ID of the item or item agent, $a_i_Quantity = Quantity
Func GwAu3_Trade_OfferItem($a_i_ItemID, $a_i_Quantity = 1)
;~     Local $l_i_ItemID
;~     $l_i_ItemID = GetBag_Item_ItemIDByModelID($a_i_ModelID)
    Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_TRADE_ADD_ITEM, $a_i_ItemID, $a_i_Quantity)
EndFunc   ;==>OfferItem
