#include-once

#Region Item Enqueue
Func StartSalvage($aItem, $aSalvageKit = "Expert Salvage Kit")
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x690]
	Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)
	Local $lSalvageKit = 0


	Switch $aSalvageKit
		Case "Salvage Kit"
			If GetInstanceInfo("IsOutpost") Then
				$lSalvageKit = GetItemInfoByModelID(2992, "ItemID")
			ElseIf GetInstanceInfo("IsExplorable") Then
				$lSalvageKit = GetBagsItembyModelID(2992)
			EndIf
		Case "Expert Salvage Kit"
			If GetInstanceInfo("IsOutpost") Then
				$lSalvageKit = GetItemInfoByModelID(2991, "ItemID")
			ElseIf GetInstanceInfo("IsExplorable") Then
				$lSalvageKit = GetBagsItembyModelID(2991)
			EndIf
		Case "Superior Salvage Kit"
			If GetInstanceInfo("IsOutpost") Then
				$lSalvageKit = GetItemInfoByModelID(5900, "ItemID")
			ElseIf GetInstanceInfo("IsExplorable") Then
				$lSalvageKit = GetBagsItembyModelID(5900)
			EndIf
		Case "Charr Salvage Kit"
			If GetInstanceInfo("IsOutpost") Then
				$lSalvageKit = GetItemInfoByModelID(170, "ItemID")
			ElseIf GetInstanceInfo("IsExplorable") Then
				$lSalvageKit = GetBagsItembyModelID(170)
			EndIf
		Case "Perfect Salvage Kit"
			If GetInstanceInfo("IsOutpost") Then
				$lSalvageKit = GetItemInfoByModelID(25881, "ItemID")
			ElseIf GetInstanceInfo("IsExplorable") Then
				$lSalvageKit = GetBagsItembyModelID(25881)
			EndIf
	EndSwitch
	If $lSalvageKit = 0 Then Return

	DllStructSetData($mSalvage, 2, ItemID($aItem))
	DllStructSetData($mSalvage, 3, ItemID($lSalvageKit))
	DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])
	Enqueue($mSalvagePtr, 16)
EndFunc   ;==>StartSalvage

;~ Description: Sells an item.
Func SellItem($aItem, $aQuantity = 0)
	Local $lItemID = ItemID($aItem)
	Local $lQuantity = MemoryRead(GetItemPtr($aItem) + 0x4C, 'short')
	Local $lValue = MemoryRead(GetItemPtr($aItem) + 0x24, 'short')

	If $aQuantity = 0 Or $aQuantity > $lQuantity Then $aQuantity = $lQuantity

	DllStructSetData($mSellItem, 2, $aQuantity * $lValue)
	DllStructSetData($mSellItem, 3, $lItemID)
	Return Enqueue($mSellItemPtr, 12)
EndFunc   ;==>SellItem

;~ Description: Buys an item.
Func BuyItem($aItem, $aQuantity, $aValue)
	Local $lMerchantItemsBase = GetWorldInfo("MerchItemArray") ;GetMerchantItemsBase()

	If Not $lMerchantItemsBase Then Return
	If $aItem < 1 Or $aItem > GetWorldInfo("MerchItemArraySize") Then Return ;GetMerchantItemsSize() Then Return

	DllStructSetData($mBuyItem, 2, $aQuantity)
	DllStructSetData($mBuyItem, 3, MemoryRead($lMerchantItemsBase + 4 * ($aItem - 1)))
	DllStructSetData($mBuyItem, 4, $aQuantity * $aValue)
	DllStructSetData($mBuyItem, 5, MemoryRead(GetScannedAddress('ScanBuyItemBase', 15)))
	Enqueue($mBuyItemPtr, 20)
EndFunc   ;==>BuyItem

;~ Local $myMaterials[3][2]
;~ $myMaterials[0][0] = 921  ; Material ModelID 1
;~ $myMaterials[0][1] = 5    ; Quantity Material 1
;~ $myMaterials[1][0] = 946  ; Material ModelID 2
;~ $myMaterials[1][1] = 3    ; Quantity Material 2
;~ $myMaterials[2][0] = 922  ; Material ModelID 3
;~ $myMaterials[2][1] = 2    ; Quantity Material 3
;~ Local $result = CraftItemEx(2507, 1, 250, $myMaterials)
;~ Func CraftItemEx($aModelID, $aQuantity, $aGold, ByRef $aMatsArray)
;~ 	Local $pSrcItem = GetInventoryItemPtrByModelId($aMatsArray[0][0])
;~ 	If ((Not $pSrcItem) Or (MemoryRead($pSrcItem + 0x4B) < $aMatsArray[0][1])) Then Return 0
;~ 	Local $pDstItem = MemoryRead(GetMerchantItemPtrByModelId($aModelID))
;~ 	If (Not $pDstItem) Then Return 0
;~ 	Local $lMatString = ''
;~ 	Local $lMatCount = 0
;~ 	If IsArray($aMatsArray) = 0 Then Return 0 ; mats are not in an array
;~ 	Local $lMatsArraySize = UBound($aMatsArray) - 1
;~ 	For $i = $lMatsArraySize To 0 Step -1
;~ 		$lCheckQuantity = CountItemInBagsByModelID($aMatsArray[$i][0])
;~ 		If $aMatsArray[$i][1] * $aQuantity > $lCheckQuantity Then ; not enough mats in inventory
;~ 			Return SetExtended($aMatsArray[$i][1] * $aQuantity - $lCheckQuantity, $aMatsArray[$i][0]) ; amount of missing mats in @extended
;~ 		EndIf
;~ 	Next
;~ 	$lCheckGold = GetInventoryInfo("GoldCharacter")
;~ ;~ 	out($lMatsArraySize)

;~ 	For $i = 0 To $lMatsArraySize
;~ 		$lMatString &= GetItemIDfromMobelID($aMatsArray[$i][0]) & ';' ;GetCraftMatsString($aMatsArray[$i][0], $aQuantity * $aMatsArray[$i][1])
;~ ;~ 		out($lMatString)
;~ 		$lMatCount += 1 ;@extended
;~ ;~ 		out($lMatCount)
;~ 	Next

;~ 	$CraftMatsType = 'dword'
;~ 	For $i = 1 To $lMatCount - 1
;~ 		$CraftMatsType &= ';dword'
;~ 	Next
;~ 	$CraftMatsBuffer = DllStructCreate($CraftMatsType)
;~ 	$CraftMatsPointer = DllStructGetPtr($CraftMatsBuffer)
;~ 	For $i = 1 To $lMatCount
;~ 		$lSize = StringInStr($lMatString, ';')
;~ ;~ 		out("Mat: " & StringLeft($lMatString, $lSize - 1))
;~ 		DllStructSetData($CraftMatsBuffer, $i, StringLeft($lMatString, $lSize - 1))
;~ 		$lMatString = StringTrimLeft($lMatString, $lSize)
;~ 	Next
;~ 	Local $lMemSize = $lMatCount * 4
;~ 	Local $lBufferMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $lMemSize, 'dword', 0x1000, 'dword', 0x40)
;~ 	If $lBufferMemory = 0 Then Return 0 ; couldnt allocate enough memory
;~ 	Local $lBuffer = DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lBufferMemory[0], 'ptr', $CraftMatsPointer, 'int', $lMemSize, 'int', '')
;~ 	If $lBuffer = 0 Then Return
;~ ;~ 	Out($lBuffer[0] & " " & $lBuffer[1] & " " & $lBuffer[2] & " " & $lBuffer[3] & " " & $lBuffer[4] & " " & $lBuffer[5])
;~ 	DllStructSetData($mCraftItemEx, 1, GetValue('CommandCraftItemEx'))
;~ 	DllStructSetData($mCraftItemEx, 2, $aQuantity)
;~ ;~ 	Out($aQuantity)
;~ ;~ 	Sleep(3000)
;~ 	DllStructSetData($mCraftItemEx, 3, $pDstItem)
;~ ;~ 	Out($pDstItem)
;~ ;~ 	Sleep(3000)
;~ 	DllStructSetData($mCraftItemEx, 4, $lBufferMemory[0])
;~ ;~ 	Out($lBufferMemory[0])
;~ ;~ 	Sleep(3000)
;~ 	DllStructSetData($mCraftItemEx, 5, $lMatCount)
;~ ;~ 	Out($lMatCount)
;~ ;~ 	Sleep(3000)
;~ 	DllStructSetData($mCraftItemEx, 6, $aQuantity * $aGold)
;~ ;~ 	Out($aQuantity * $aGold)
;~ ;~ 	Sleep(3000)
;~ 	Enqueue($mCraftItemExPtr, 24)
;~ 	$lDeadlock = TimerInit()
;~ 	Do
;~ 		Sleep(250)
;~ 		$lCurrentQuantity = CountItemInBagsByModelID($aMatsArray[0][0])
;~ 	Until $lCurrentQuantity <> $lCheckQuantity Or $lCheckGold <> GetInventoryInfo("GoldCharacter") Or TimerDiff($lDeadlock) > 5000
;~ 	DllCall($mKernelHandle, 'ptr', 'VirtualFreeEx', 'handle', $mGWProcHandle, 'ptr', $lBufferMemory[0], 'int', 0, 'dword', 0x8000)
;~ 	Return SetExtended($lCheckQuantity - $lCurrentQuantity - $aMatsArray[0][1] * $aQuantity, True) ; should be zero if items were successfully crafter
;~ EndFunc   ;==>CraftItemEx

;~ Local $materialCount = 3
;~ Local $modelID = 2507
;~ Local $tradeWindowID = GetTradeWindowID()
;~ Local $quantity = 1
;~ Local $gold = 250
;~ Local $itemNumber = 1
;~ Func CraftItemEx2($aMatCount, $aModelID, $aTradeWindowID, $aQuantity, $aGold, $aItemNumber)
;~ 	Local $aDstItem = MemoryRead(GetMerchantItemPtrByModelId($aModelID))
;~ 	If (Not $aDstItem) Then Return 0x0
;~ 	DllStructSetData($mCraftItemEx, 0x1, GetValue("CommandCraftItemEx"))
;~ 	DllStructSetData($mCraftItemEx, 0x2, $aMatCount)
;~ 	DllStructSetData($mCraftItemEx, 0x3, $aDstItem)
;~ 	DllStructSetData($mCraftItemEx, 0x4, $aTradeWindowID)
;~ 	DllStructSetData($mCraftItemEx, 0x5, $aQuantity * $aGold)
;~ 	DllStructSetData($mCraftItemEx, 0x6, $aItemNumber)
;~ 	Enqueue($mCraftItemExPtr, 0x18)
;~ EndFunc   ;==>CraftItemEx

;~ Description: Request a quote to buy an item from a trader. Returns true if successful.
;~ Put ModString as $aModString parameter if buying Runes
;~ Put ExtraID as $aExtraID parameter if buying Dye, put "" as $aModString (don't buy and sell black dye)
Func TraderRequest($aModelID, $aModString = "", $aExtraID = -1)
    Local $lItemPtr = 0
    Local $lFound = False
    Local $lQuoteID = MemoryRead($mTraderQuoteID)

    Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
    Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)

    For $lItemID = 1 To $lItemArraySize[1]
        $lItemPtr = GetItemPtr($lItemID)
        If $lItemPtr = 0 Then ContinueLoop

        If MemoryRead($lItemPtr + 0x2C, 'dword') <> $aModelID Then ContinueLoop
		If MemoryRead($lItemPtr + 0xC, 'ptr') <> 0 Or MemoryRead($lItemPtr + 0x4, 'dword') <> 0 Then ContinueLoop ;0xC=BagPtr 0x4=AgentID
		
		If $aModString == "" And $aExtraID = -1 Then
			$lFound = True
			ExitLoop
		ElseIf $aExtraID <> -1 And MemoryRead($lItemPtr + 0x22, 'short') = $aExtraID Then
			$lFound = True
			ExitLoop
		ElseIf $aModstring <> "" And StringInStr(GetModstruct($lItemPtr), $aModString) > 0 Then
			$lFound = True
			ExitLoop
		EndIf
    Next

    If Not $lFound Then Return False

    DllStructSetData($mRequestQuote, 2, ItemID($lItemPtr))
    Enqueue($mRequestQuotePtr, 8)

    Local $lDeadlock = TimerInit()
    Do
        Sleep(50)
        $lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
    Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000

    Return $lFound
EndFunc ;==>TraderRequest

;~ Description: Buy the requested item.
Func TraderBuy()
	If Not MemoryRead($mTraderCostID) Or Not MemoryRead($mTraderCostValue) Then Return False
	Enqueue($mTraderBuyPtr, 4)
	Return True
EndFunc   ;==>TraderBuy

;~ Description: This shit might not work as intended :3
Func TraderRequestBuy($aItem)
    Local $lFound = False
    Local $lQuoteID = MemoryRead($mTraderQuoteID)

    Local $lItemID = ItemID($aItem)

    DllStructSetData($mRequestQuote, 1, $HEADER_REQUEST_QUOTE)
    DllStructSetData($mRequestQuote, 2, $lItemID)

    Enqueue($mRequestQuotePtr, 8)

    Local $lDeadlock = TimerInit()
    Do
        Sleep(16)
        $lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
    Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000

    Return $lFound
EndFunc   ;==>TraderRequestBuy

;~ Description: Request a quote to sell an item to the trader
Func TraderRequestSell($aItem)
	Local $lFound = False
	Local $lQuoteID = MemoryRead($mTraderQuoteID)
	DllStructSetData($mRequestQuoteSell, 2, ItemID($aItem))
	Enqueue($mRequestQuoteSellPtr, 8)
	Local $lDeadlock = TimerInit()
	Do
		Sleep(16)
		$lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
	Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000
	Return $lFound
EndFunc   ;==>TraderRequestSell

;~ Description: ID of the item item being sold.
Func TraderSell()
	If Not MemoryRead($mTraderCostID) Or Not MemoryRead($mTraderCostValue) Then Return False
	Enqueue($mTraderSellPtr, 4)
	Return True
EndFunc   ;==>TraderSell
#EndRegion Item Enqueue

#Region H&H Enqueue
;~ Description: Order a hero to use a skill.
Func UseHeroSkill($aHeroNumber, $aSkillSlot, $aTarget = -2)
	DllStructSetData($mUseHeroSkill, 2, GetMyPartyHeroInfo($aHeroNumber, "AgentID"))
	DllStructSetData($mUseHeroSkill, 3, ConvertID($aTarget))
	DllStructSetData($mUseHeroSkill, 4, $aSkillSlot - 1)
	Enqueue($mUseHeroSkillPtr, 16)
EndFunc   ;==>UseHeroSkill
#EndRegion H&H Enqueue

#Region Movement Enqueue
;~ Description: Move to a location.
Func Move($aX, $aY, $aRandom = 50)
	DllStructSetData($mMove, 2, $aX + Random(-$aRandom, $aRandom))
	DllStructSetData($mMove, 3, $aY + Random(-$aRandom, $aRandom))
	Enqueue($mMovePtr, 16)
EndFunc   ;==>Move
#EndRegion Movement Enqueue

#Region Fighting Enqueue
;~ Description: Target an agent.
Func ChangeTarget($aAgent)
	DllStructSetData($mChangeTarget, 2, ConvertID($aAgent))
	Enqueue($mChangeTargetPtr, 8)
EndFunc   ;==>ChangeTarget

;~ Description: Use a skill.
Func UseSkill($aSkillSlot, $aTarget = -2, $aCallTarget = False)
	DllStructSetData($mUseSkill, 2, $aSkillSlot)
	DllStructSetData($mUseSkill, 3, ConvertID($aTarget))
	DllStructSetData($mUseSkill, 4, $aCallTarget)
	Enqueue($mUseSkillPtr, 16)
EndFunc   ;==>UseSkill

;~ Description: Increase attribute by 1
Func IncreaseAttribute($aAttributeID, $aHeroNumber = 0)
	DllStructSetData($mIncreaseAttribute, 2, $aAttributeID)
	DllStructSetData($mIncreaseAttribute, 3, GetMyPartyHeroInfo($aHeroNumber, "AgentID"))
	Enqueue($mIncreaseAttributePtr, 12)
EndFunc   ;==>IncreaseAttribute

;~ Description: Decrease attribute by 1
Func DecreaseAttribute($aAttributeID, $aHeroNumber = 0)
	DllStructSetData($mDecreaseAttribute, 2, $aAttributeID)
	DllStructSetData($mDecreaseAttribute, 3, GetMyPartyHeroInfo($aHeroNumber, "AgentID"))
	Enqueue($mDecreaseAttributePtr, 12)
EndFunc   ;==>DecreaseAttribute
#EndRegion Fighting Enqueue

#Region Misc Enqueue
;~ Description: Change game language.
Func ToggleLanguage()
	DllStructSetData($mToggleLanguage, 2, 0x18)
	Enqueue($mToggleLanguagePtr, 8)
EndFunc   ;==>ToggleLanguage

Func InviteGuild($charName)
	DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mInviteGuild, 3, 0xBC)
	DllStructSetData($mInviteGuild, 4, 0x01)
	DllStructSetData($mInviteGuild, 5, $charName)
	DllStructSetData($mInviteGuild, 6, 0x02)
	Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
EndFunc   ;==>InviteGuild

Func InviteGuest($charName)
	DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mInviteGuild, 3, 0xBC)
	DllStructSetData($mInviteGuild, 4, 0x01)
	DllStructSetData($mInviteGuild, 5, $charName)
	DllStructSetData($mInviteGuild, 6, 0x01)
	Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
EndFunc   ;==>InviteGuest

;~ Description: Change online status. 0 = Offline, 1 = Online, 2 = Do not disturb, 3 = Away
Func SetPlayerStatus($iStatus)
	If (($iStatus >= 0 And $iStatus <= 3) And (GetPlayerStatus() <> $iStatus)) Then
		DllStructSetData($mChangeStatus, 2, $iStatus)

		Enqueue($mChangeStatusPtr, 8)
		Return True
	EndIf
	Return False
EndFunc   ;==>SetPlayerStatus
#EndRegion Misc Enqueue
