#include-once

;~ Description: Sleep a random amount of time.
Func RndSleep($aAmount, $aRandom = 0.05)
	Local $lRandom = $aAmount * $aRandom
	Sleep(Random($aAmount - $lRandom, $aAmount + $lRandom))
EndFunc   ;==>RndSleep

;~ Description: Sleep a period of time, plus or minus a tolerance
Func TolSleep($aAmount = 150, $aTolerance = 50)
	Sleep(Random($aAmount - $aTolerance, $aAmount + $aTolerance))
EndFunc   ;==>TolSleep

;~ Description: Sleep a period of time, plus ping.
Func PingSleep($msExtra = 0)
	Sleep(GetPing() + $msExtra)
EndFunc   ;==>PingSleep

#Region Loading build
;~ Func LoadSkillTemplate($aTemplate, $aHeroNumber = 0)
;~ 	Local $lHeroID = GetHeroInfo($aHeroNumber, "AgentID")
;~ 	Local $lSplitTemplate = StringSplit($aTemplate, '')

;~ 	Local $lTemplateType ; 4 Bits
;~ 	Local $lVersionNumber ; 4 Bits
;~ 	Local $lProfBits ; 2 Bits -> P
;~ 	Local $lProfPrimary ; P Bits
;~ 	Local $lProfSecondary ; P Bits
;~ 	Local $lAttributesCount ; 4 Bits
	;~ Local $lAttributesBits ; 4 Bits -> A
	;~ Local $lAttributes[1][2] ; A Bits + 4 Bits (for each Attribute)
	;~ Local $lSkillsBits ; 4 Bits -> S
	;~ Local $lSkills[8] ; S Bits * 8
	;~ Local $lOpTail ; 1 Bit

	;~ $aTemplate = ''
	;~ For $i = 1 To $lSplitTemplate[0]
	;~ 	$aTemplate &= Base64ToBin64($lSplitTemplate[$i])
	;~ Next

	;~ $lTemplateType = Bin64ToDec(StringLeft($aTemplate, 4))
	;~ $aTemplate = StringTrimLeft($aTemplate, 4)
	;~ If $lTemplateType <> 14 Then Return False

	;~ $lVersionNumber = Bin64ToDec(StringLeft($aTemplate, 4))
	;~ $aTemplate = StringTrimLeft($aTemplate, 4)

	;~ $lProfBits = Bin64ToDec(StringLeft($aTemplate, 2)) * 2 + 4
	;~ $aTemplate = StringTrimLeft($aTemplate, 2)

	;~ $lProfPrimary = Bin64ToDec(StringLeft($aTemplate, $lProfBits))
	;~ $aTemplate = StringTrimLeft($aTemplate, $lProfBits)
	;~ If $lProfPrimary <> GetHeroInfo($aHeroNumber, "Primary") Then Return False

	;~ $lProfSecondary = Bin64ToDec(StringLeft($aTemplate, $lProfBits))
	;~ $aTemplate = StringTrimLeft($aTemplate, $lProfBits)

	;~ $lAttributesCount = Bin64ToDec(StringLeft($aTemplate, 4))
	;~ $aTemplate = StringTrimLeft($aTemplate, 4)

	;~ $lAttributesBits = Bin64ToDec(StringLeft($aTemplate, 4)) + 4
	;~ $aTemplate = StringTrimLeft($aTemplate, 4)

	;~ $lAttributes[0][0] = $lAttributesCount
	;~ For $i = 1 To $lAttributesCount
	;~ 	If Bin64ToDec(StringLeft($aTemplate, $lAttributesBits)) == GetProfPrimaryAttribute($lProfPrimary) Then
	;~ 		$aTemplate = StringTrimLeft($aTemplate, $lAttributesBits)
;~ 			$lAttributes[0][1] = Bin64ToDec(StringLeft($aTemplate, 4))
;~ 			$aTemplate = StringTrimLeft($aTemplate, 4)
;~ 			ContinueLoop
;~ 		EndIf
;~ 		$lAttributes[0][0] += 1
;~ 		ReDim $lAttributes[$lAttributes[0][0] + 1][2]
;~ 		$lAttributes[$i][0] = Bin64ToDec(StringLeft($aTemplate, $lAttributesBits))
;~ 		$aTemplate = StringTrimLeft($aTemplate, $lAttributesBits)
;~ 		$lAttributes[$i][1] = Bin64ToDec(StringLeft($aTemplate, 4))
;~ 		$aTemplate = StringTrimLeft($aTemplate, 4)
;~ 	Next

;~ 	$lSkillsBits = Bin64ToDec(StringLeft($aTemplate, 4)) + 8
;~ 	$aTemplate = StringTrimLeft($aTemplate, 4)

;~ 	For $i = 0 To 7
;~ 		$lSkills[$i] = Bin64ToDec(StringLeft($aTemplate, $lSkillsBits))
;~ 		$aTemplate = StringTrimLeft($aTemplate, $lSkillsBits)
;~ 	Next

;~ 	$lOpTail = Bin64ToDec($aTemplate)

;~ 	$lAttributes[0][0] = $lProfSecondary
;~ 	LoadAttributes($lAttributes, $aHeroNumber)
;~ 	LoadSkillBar($lSkills[0], $lSkills[1], $lSkills[2], $lSkills[3], $lSkills[4], $lSkills[5], $lSkills[6], $lSkills[7], $aHeroNumber)
;~ EndFunc   ;==>LoadSkillTemplate

;~ Func LoadAttributes($aAttributesArray, $aHeroNumber = 0)
;~ 	Local $lPrimaryAttribute
;~ 	Local $lDeadlock = 0
;~ 	Local $lHeroID = GetHeroInfo($aHeroNumber, "AgentID")
;~ 	Local $lLevel
;~ 	Local $TestTimer = 0

;~ 	$lPrimaryAttribute = GetProfPrimaryAttribute(GetHeroInfo($aHeroNumber, "Primary"))

;~ 	If $aAttributesArray[0][0] <> 0 And GetHeroInfo($aHeroNumber, "Secondary") <> $aAttributesArray[0][0] And GetHeroInfo($aHeroNumber, "Primary") <> $aAttributesArray[0][0] Then
;~ 		Do
;~ 			$lDeadlock = TimerInit()
;~ 			ChangeSecondProfession($aAttributesArray[0][0], $aHeroNumber)
;~ 			Do
;~ 				Sleep(16)
;~ 			Until GetHeroInfo($aHeroNumber, "Secondary") == $aAttributesArray[0][0] Or TimerDiff($lDeadlock) > 5000
;~ 		Until GetHeroInfo($aHeroNumber, "Secondary") == $aAttributesArray[0][0] Or TimerDiff($lDeadlock) > 10000
;~ 	EndIf

;~ 	$aAttributesArray[0][0] = $lPrimaryAttribute
;~ 	For $i = 0 To UBound($aAttributesArray) - 1
;~ 		If $aAttributesArray[$i][1] > 12 Then $aAttributesArray[$i][1] = 12
;~ 		If $aAttributesArray[$i][1] < 0 Then $aAttributesArray[$i][1] = 0
;~ 	Next

;~ 	While GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $aAttributesArray[0][1]
;~ 		$lLevel = GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
;~ 		$lDeadlock = TimerInit()
;~ 		DecreaseAttribute($lPrimaryAttribute, $aHeroNumber)
;~ 		Do
;~ 			Sleep(16)
;~ 		Until GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
;~ 		Sleep(16)
;~ 	WEnd
;~ 	For $i = 1 To UBound($aAttributesArray) - 1

;~ 		While GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") > $aAttributesArray[$i][1]
;~ 			$lLevel = GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel")
;~ 			$lDeadlock = TimerInit()
;~ 			DecreaseAttribute($aAttributesArray[$i][0], $aHeroNumber)
;~ 			Do
;~ 				Sleep(16)
;~ 			Until GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
;~ 			Sleep(16)
;~ 		WEnd
;~ 	Next
;~ 	For $i = 0 To 44

;~ 		If GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0 Then
;~ 			If $i = $lPrimaryAttribute Then ContinueLoop
;~ 			For $J = 1 To UBound($aAttributesArray) - 1
;~ 				If $i = $aAttributesArray[$J][0] Then ContinueLoop 2
;~ 			Next
;~ 			While GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0
;~ 				$lLevel = GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel")
;~ 				$lDeadlock = TimerInit()
;~ 				DecreaseAttribute($i, $aHeroNumber)
;~ 				Do
;~ 					Sleep(16)
;~ 				Until GetHeroAttributeInfo($i, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
;~ 				Sleep(16)
;~ 			WEnd
;~ 		EndIf
;~ 	Next

;~ 	$TestTimer = 0

;~ 	While GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $aAttributesArray[0][1]
;~ 		$lLevel = GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
;~ 		$lDeadlock = TimerInit()
;~ 		IncreaseAttribute($lPrimaryAttribute, $aHeroNumber)
;~ 		Do
;~ 			Sleep(16)
;~ 			$TestTimer = $TestTimer + 1
;~ 		Until GetHeroAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > 5000
;~ 		Sleep(16)
;~ 		If $TestTimer > 225 Then ExitLoop
;~ 	WEnd
;~ 	For $i = 1 To UBound($aAttributesArray) - 1
;~ 		$TestTimer = 0

;~ 		While GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") < $aAttributesArray[$i][1]
;~ 			$lLevel = GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel")
;~ 			$lDeadlock = TimerInit()
;~ 			IncreaseAttribute($aAttributesArray[$i][0], $aHeroNumber)
;~ 			Do
;~ 				Sleep(16)
;~ 				$TestTimer = $TestTimer + 1
;~ 			Until GetHeroAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > 5000
;~ 			Sleep(16)
;~ 			If $TestTimer > 225 Then ExitLoop
;~ 		WEnd
;~ 	Next
;~ EndFunc   ;==>LoadAttributes

Func GetProfPrimaryAttribute($aProfession)
	Switch $aProfession
		Case 1
			Return 17
		Case 2
			Return 23
		Case 3
			Return 16
		Case 4
			Return 6
		Case 5
			Return 0
		Case 6
			Return 12
		Case 7
			Return 35
		Case 8
			Return 36
		Case 9
			Return 40
		Case 10
			Return 44
	EndSwitch
EndFunc   ;==>GetProfPrimaryAttribute
#EndRegion Loading Build

#Region Rendering
;~ Description: Enable graphics rendering.
Func EnableRendering($aShowWindow = True)
	Local $lWindowHandle = $mGWWindowHandle, $lPrevGWState = WinGetState($lWindowHandle), $lPrevWindow = WinGetHandle("[ACTIVE]", ""), $lPrevWindowState = WinGetState($lPrevWindow)
	If $aShowWindow And $lPrevGWState Then
		If BitAND($lPrevGWState, 16) Then
			WinSetState($lWindowHandle, "", @SW_RESTORE)
		ElseIf Not BitAND($lPrevGWState, 2) Then
			WinSetState($lWindowHandle, "", @SW_SHOW)
		EndIf
		If $lWindowHandle <> $lPrevWindow And $lPrevWindow Then RestoreWindowState($lPrevWindow, $lPrevWindowState)
	EndIf
	If Not GetIsRendering() Then
		$mRendering = True
		If Not MemoryWrite($mDisableRendering, 0) Then Return SetError(@error, False)
		Sleep(250)
	EndIf
	Return 1
EndFunc   ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering($aHideWindow = True)
	Local $lWindowHandle = $mGWWindowHandle
	If $aHideWindow And WinGetState($lWindowHandle) Then WinSetState($lWindowHandle, "", @SW_HIDE)
	If GetIsRendering() Then
		$mRendering = True
		If Not MemoryWrite($mDisableRendering, 1) Then Return SetError(@error, False)
		Sleep(250)
	EndIf
	Return 1
EndFunc   ;==>DisableRendering

;Toggles graphics rendering
Func ToggleRendering()
	Return GetIsRendering() ? DisableRendering() : EnableRendering()
EndFunc   ;==>ToggleRendering

Func GetIsRendering()
	Return MemoryRead($mDisableRendering) <> 1
EndFunc   ;==>GetIsRendering

;Internally used - restores a window to previous state.
Func RestoreWindowState($aWindowHandle, $aPreviousWindowState)
	If Not $aWindowHandle Or Not $aPreviousWindowState Then Return 0

	Local $lStates[6] = [1, 2, 4, 8, 16, 32], $lCurrentWindowState = WinGetState($aWindowHandle)
	For $i = 0 To UBound($lStates) - 1
		If BitAND($aPreviousWindowState, $lStates[$i]) And Not BitAND($lCurrentWindowState, $lStates[$i]) Then WinSetState($aWindowHandle, "", $lStates[$i])
	Next
EndFunc   ;==>RestoreWindowState
#EndRegion Rendering

#Region Chat
;~ Description: Write a message in chat (can only be seen by botter).
Func WriteChat($aMessage, $aSender = 'GwAu3')
	Local $lMessage, $lSender
	Local $lAddress = 256 * $mQueueCounter + $mQueueBase

	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf

	If StringLen($aSender) > 19 Then
		$lSender = StringLeft($aSender, 19)
	Else
		$lSender = $aSender
	EndIf

	MemoryWrite($lAddress + 4, $lSender, 'wchar[20]')

	If StringLen($aMessage) > 100 Then
		$lMessage = StringLeft($aMessage, 100)
	Else
		$lMessage = $aMessage
	EndIf

	MemoryWrite($lAddress + 44, $lMessage, 'wchar[101]')
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mWriteChatPtr, 'int', 4, 'int', '')

	If StringLen($aMessage) > 100 Then WriteChat(StringTrimLeft($aMessage, 100), $aSender)
EndFunc   ;==>WriteChat

;~ Description: Send a whisper to another player.
Func SendWhisper($aReceiver, $aMessage)
	Local $lTotal = 'whisper ' & $aReceiver & ',' & $aMessage
	Local $lMessage

	If StringLen($lTotal) > 120 Then
		$lMessage = StringLeft($lTotal, 120)
	Else
		$lMessage = $lTotal
	EndIf

	SendChat($lMessage, '/')

	If StringLen($lTotal) > 120 Then SendWhisper($aReceiver, StringTrimLeft($lTotal, 120))
EndFunc   ;==>SendWhisper

;~ Description: Send a message to chat.
Func SendChat($aMessage, $aChannel = '!')
	Local $lMessage
	Local $lAddress = 256 * $mQueueCounter + $mQueueBase

	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf

	If StringLen($aMessage) > 120 Then
		$lMessage = StringLeft($aMessage, 120)
	Else
		$lMessage = $aMessage
	EndIf

	MemoryWrite($lAddress + 12, $aChannel & $lMessage, 'wchar[122]')
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mSendChatPtr, 'int', 8, 'int', '')

	If StringLen($aMessage) > 120 Then SendChat(StringTrimLeft($aMessage, 120), $aChannel)
EndFunc   ;==>SendChat
#EndRegion Chat

#Region Item
;~ Description: Identifies all items in a bag.
Func IdentifyBag($aBagNumber, $aGolds = True, $aPurples = False, $aBlue = False, $aWhites = False)
	Local $aItemID
	$aBag = GetBagPtr($aBagNumber)
	For $i = 1 To GetBagInfo($aBagNumber, "Slots")
		$aItemID = GetItemBySlot($aBagNumber, $i)
		If ItemID($aItemID) == 0 Then ContinueLoop

		Switch GetItemInfoByItemID($aItemID, "Rarity")
			Case 2624 ;gold
				If $aGolds == False Then ContinueLoop
				IdentifyItem($aItemID)
			Case 2626 ;purple
				If $aPurples == False Then ContinueLoop
				IdentifyItem($aItemID)
			Case 2623 ;blue
				If $aBlue == False Then ContinueLoop
				IdentifyItem($aItemID)
			Case 2621 ;white
				If $aWhites == False Then ContinueLoop
				IdentifyItem($aItemID)
		EndSwitch
	Next
EndFunc   ;==>IdentifyBag

;~ Description: Deposit gold into storage.
Func DepositGold($aAmount = 0)
	Local $lAmount
	Local $lStorage = GetInventoryInfo("GoldStorage")
	Local $lCharacter = GetInventoryInfo("GoldCharacter")

	If $aAmount > 0 And $lCharacter >= $aAmount Then
		$lAmount = $aAmount
	Else
		$lAmount = $lCharacter
	EndIf

	If $lStorage + $lAmount > 1000000 Then $lAmount = 1000000 - $lStorage

	ChangeGold($lCharacter - $lAmount, $lStorage + $lAmount)
EndFunc   ;==>DepositGold

;~ Description: Withdraw gold from storage.
Func WithdrawGold($aAmount = 0)
	Local $lAmount
	Local $lStorage = GetInventoryInfo("GoldStorage")
	Local $lCharacter = GetInventoryInfo("GoldCharacter")

	If $aAmount > 0 And $lStorage >= $aAmount Then
		$lAmount = $aAmount
	Else
		$lAmount = $lStorage
	EndIf

	If $lCharacter + $lAmount > 100000 Then $lAmount = 100000 - $lCharacter

	ChangeGold($lCharacter + $lAmount, $lStorage - $lAmount)
EndFunc   ;==>WithdrawGold
#EndRegion Item

#Region Travel
;~ Description: Map travel to an outpost.
Func TravelTo($aMapID, $aLanguage = GetCharacterInfo("Language"), $aRegion = GetCharacterInfo("Region"), $aDistrict = 0)
	If	GetCharacterInfo("MapID") = $aMapID And GetInstanceInfo("IsOutpost") _
		And $aLanguage = GetCharacterInfo("Language") And $aRegion = GetCharacterInfo("Region")  Then Return True
	MoveMap($aMapID, $aRegion, $aDistrict, $aLanguage)
	Return WaitMapLoading($aMapID)
EndFunc   ;==>TravelTo

;~ 	Waits $aDeadlock for load to start, and $aDeadLock for agent to load after map is loaded.
Func WaitMapLoading($aMapID = 0, $aDeadlock = 10000, $aSkipCinematic = False)
	Local $Timer = TimerInit(), $lTypeMap
	Do
		Sleep(100)
		$lTypeMap = MemoryRead(GetAgentPtr(-2) + 0x158, 'long')
	Until Not BitAND($lTypeMap, 0x400000) Or TimerDiff($Timer) > $aDeadlock

	If $aSkipCinematic Then
		Sleep(2500)
		SkipCinematic()
	EndIf

	$Timer = TimerInit()
	Do
		$lTypeMap = MemoryRead(GetAgentPtr(-2) + 0x158, 'long')
		Sleep(200)
	Until BitAND($lTypeMap, 0x400000) And (GetMapID() = $aMapID Or $aMapID = 0) Or TimerDiff($Timer) > $aDeadlock
	Sleep(3000)
	If TimerDiff($Timer) < $aDeadlock + 3000 Then Return True
	Return False
EndFunc   ;==>WaitMapLoading

;~ Description: Returns current MapID
Func GetMapID()
    Return GetCharacterInfo("MapID")
EndFunc   ;==>GetMapID
#EndRegion Travel

Func CheckArea($aX, $aY, $range = 1320)
	$ret = False
	$pX = GetAgentInfo(-2, "X")
    $pY = GetAgentInfo(-2, "Y")

	If ($pX < $aX + $range) And ($pX > $aX - $range) And ($pY < $aY + $range) And ($pY > $aY - $range) Then
		$ret = True
	EndIf
	Return $ret
EndFunc   ;==>CheckAreaRange

Func GetBestTarget($aRange = 1320)
	Local $lBestTarget, $lDistance, $lLowestSum = 100000000
	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		Local $lSumDistances = 0
		If GetAgentInfo($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If GetAgentInfo($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If GetAgentInfo($lAgentArray[$i], 'ID') = GetMyID() Then ContinueLoop
		If GetDistance($lAgentArray[$i]) > $aRange Then ContinueLoop
		For $j = 1 To $lAgentArray[0]
			If GetAgentInfo($lAgentArray[$j], 'Allegiance') <> 3 Then ContinueLoop
			If GetAgentInfo($lAgentArray[$j], 'HP') <= 0 Then ContinueLoop
			If GetAgentInfo($lAgentArray[$j], 'ID') = GetMyID() Then ContinueLoop
			If GetDistance($lAgentArray[$j]) > $aRange Then ContinueLoop
			$lDistance = GetDistance($lAgentArray[$i], $lAgentArray[$j])
			$lSumDistances += $lDistance
		Next
		If $lSumDistances < $lLowestSum Then
			$lLowestSum = $lSumDistances
			$lBestTarget = $lAgentArray[$i]
		EndIf
	Next
	Return $lBestTarget
EndFunc   ;==>GetBestTarget
