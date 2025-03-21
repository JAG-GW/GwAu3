#include-once
#Region Sleep
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
#EndRegion

#Region Rendering
;~ Description: Enable graphics rendering.
Func EnableRendering()
    If GetRenderEnabled() Then Return 1
	MemoryWrite($mDisableRendering, 0)
EndFunc ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering()
	If GetRenderDisabled() Then Return 1
	MemoryWrite($mDisableRendering, 1)
EndFunc ;==>DisableRendering

;~ Description: Checks if Rendering is disabled
Func GetRenderDisabled()
	Return MemoryRead($mDisableRendering) = 1
EndFunc ;==>GetRenderDisabled

;~ Description: Checks if Rendering is enabled
Func GetRenderEnabled()
	Return MemoryRead($mDisableRendering) = 0
EndFunc ;==>GetRenderEnabled

;~ Description: Toggle Rendering *and* Window State
Func ToggleRendering()
	If GetRenderDisabled() Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
EndFunc ;==>ToggleRendering

;~ Description: Enable Rendering for duration $aTime(ms), then Disable Rendering again.
;~ 				Also toggles Window State
Func PurgeHook($aTime = 10000)
	If GetRenderEnabled() Then Return 1
	ToggleRendering()
	Sleep($aTime)
	ToggleRendering()
EndFunc ;==>PurgeHook

;~ Description: Toggle Rendering (the GW window will stay hidden)
Func ToggleRendering_()
	If GetRenderDisabled() Then
        EnableRendering()
		ClearMemory()
	Else
		DisableRendering()
		ClearMemory()
	EndIf
EndFunc ;==>ToggleRendering_

;~ Description: Enable Rendering for duration $aTime(ms), then Disable Rendering again.
Func PurgeHook_($aTime = 10000)
	If GetRenderEnabled() Then Return 1
    ToggleRendering_()
    Sleep($aTime)
    ToggleRendering_()
EndFunc ;==PurgeHook_
#EndRegion Rendering

#Region Loading build
Func LoadSkillTemplate($aTemplate, $aHeroNumber = 0)
	Out("Start LoadSkillTemplate")
	Local $lHeroID
	If $aHeroNumber <> 0 Then
		$lHeroID = GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		$lHeroID = GetWorldInfo("MyID")
	EndIf
	Local $lSplitTemplate = StringSplit($aTemplate, '')

	Local $lTemplateType ; 4 Bits
	Local $lVersionNumber ; 4 Bits
	Local $lProfBits ; 2 Bits -> P
	Local $lProfPrimary ; P Bits
	Local $lProfSecondary ; P Bits
	Local $lAttributesCount ; 4 Bits
	Local $lAttributesBits ; 4 Bits -> A
	Local $lAttributes[1][2] ; A Bits + 4 Bits (for each Attribute)
	Local $lSkillsBits ; 4 Bits -> S
	Local $lSkills[8] ; S Bits * 8
	Local $lOpTail ; 1 Bit

	$aTemplate = ''
	For $i = 1 To $lSplitTemplate[0]
		$aTemplate &= Base64ToBin64($lSplitTemplate[$i])
	Next

	$lTemplateType = Bin64ToDec(StringLeft($aTemplate, 4))
	$aTemplate = StringTrimLeft($aTemplate, 4)
	If $lTemplateType <> 14 Then Return False

	$lVersionNumber = Bin64ToDec(StringLeft($aTemplate, 4))
	$aTemplate = StringTrimLeft($aTemplate, 4)

	$lProfBits = Bin64ToDec(StringLeft($aTemplate, 2)) * 2 + 4
	$aTemplate = StringTrimLeft($aTemplate, 2)

	$lProfPrimary = Bin64ToDec(StringLeft($aTemplate, $lProfBits))
	$aTemplate = StringTrimLeft($aTemplate, $lProfBits)
	If $lProfPrimary <> GetPartyProfessionInfo($lHeroID, "Primary") Then Return False

	$lProfSecondary = Bin64ToDec(StringLeft($aTemplate, $lProfBits))
	$aTemplate = StringTrimLeft($aTemplate, $lProfBits)

	$lAttributesCount = Bin64ToDec(StringLeft($aTemplate, 4))
	$aTemplate = StringTrimLeft($aTemplate, 4)

	$lAttributesBits = Bin64ToDec(StringLeft($aTemplate, 4)) + 4
	$aTemplate = StringTrimLeft($aTemplate, 4)

	$lAttributes[0][0] = $lAttributesCount
	For $i = 1 To $lAttributesCount
		If Bin64ToDec(StringLeft($aTemplate, $lAttributesBits)) == GetProfPrimaryAttribute($lProfPrimary) Then
			$aTemplate = StringTrimLeft($aTemplate, $lAttributesBits)
			$lAttributes[0][1] = Bin64ToDec(StringLeft($aTemplate, 4))
			$aTemplate = StringTrimLeft($aTemplate, 4)
			ContinueLoop
		EndIf
		$lAttributes[0][0] += 1
		ReDim $lAttributes[$lAttributes[0][0] + 1][2]
		$lAttributes[$i][0] = Bin64ToDec(StringLeft($aTemplate, $lAttributesBits))
		$aTemplate = StringTrimLeft($aTemplate, $lAttributesBits)
		$lAttributes[$i][1] = Bin64ToDec(StringLeft($aTemplate, 4))
		$aTemplate = StringTrimLeft($aTemplate, 4)
	Next

	$lSkillsBits = Bin64ToDec(StringLeft($aTemplate, 4)) + 8
	$aTemplate = StringTrimLeft($aTemplate, 4)

	For $i = 0 To 7
		$lSkills[$i] = Bin64ToDec(StringLeft($aTemplate, $lSkillsBits))
		$aTemplate = StringTrimLeft($aTemplate, $lSkillsBits)
	Next

	$lOpTail = Bin64ToDec($aTemplate)

	$lAttributes[0][0] = $lProfSecondary
	Out("Start LoadAttributes")
	LoadAttributes($lAttributes, $aHeroNumber)
	Out("Start LoadSkillBar")
	LoadSkillBar($lSkills[0], $lSkills[1], $lSkills[2], $lSkills[3], $lSkills[4], $lSkills[5], $lSkills[6], $lSkills[7], $aHeroNumber)
EndFunc   ;==>LoadSkillTemplate

Func LoadAttributes($aAttributesArray, $aHeroNumber = 0)
	Local $lPrimaryAttribute
	Local $lDeadlock = 0
	Local $lHeroID
	If $aHeroNumber <> 0 Then
		$lHeroID = GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		$lHeroID = GetWorldInfo("MyID")
	EndIf
	Local $lLevel
	Local $TestTimer = 0

	$lPrimaryAttribute = GetProfPrimaryAttribute(GetPartyProfessionInfo($lHeroID, "Primary"))

	If $aAttributesArray[0][0] <> 0 And GetPartyProfessionInfo($lHeroID, "Secondary") <> $aAttributesArray[0][0] And GetPartyProfessionInfo($lHeroID, "Primary") <> $aAttributesArray[0][0] Then
		Do
			$lDeadlock = TimerInit()
			ChangeSecondProfession($aAttributesArray[0][0], $aHeroNumber)
			Do
				Sleep(16)
			Until GetPartyProfessionInfo($lHeroID, "Secondary") == $aAttributesArray[0][0] Or TimerDiff($lDeadlock) > 5000
		Until GetPartyProfessionInfo($lHeroID, "Secondary") == $aAttributesArray[0][0] Or TimerDiff($lDeadlock) > 10000
	EndIf
	Out("ok 1")

	$aAttributesArray[0][0] = $lPrimaryAttribute
	For $i = 0 To UBound($aAttributesArray) - 1
		If $aAttributesArray[$i][1] > 12 Then $aAttributesArray[$i][1] = 12
		If $aAttributesArray[$i][1] < 0 Then $aAttributesArray[$i][1] = 0
	Next

	While GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $aAttributesArray[0][1]
		$lLevel = GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
		$lDeadlock = TimerInit()
		DecreaseAttribute($lPrimaryAttribute, $aHeroNumber)
		Do
			Sleep(16)
		Until GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
		Sleep(16)
	WEnd
	Out("ok 2")
	For $i = 1 To UBound($aAttributesArray) - 1

		While GetPartyAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") > $aAttributesArray[$i][1]
			$lLevel = GetPartyAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel")
			$lDeadlock = TimerInit()
			DecreaseAttribute($aAttributesArray[$i][0], $aHeroNumber)
			Do
				Sleep(16)
			Until GetPartyAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
			Sleep(16)
		WEnd
	Next
	Out("ok 3")
	For $i = 0 To 44

		If GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0 Then
			If $i = $lPrimaryAttribute Then ContinueLoop
			For $J = 1 To UBound($aAttributesArray) - 1
				If $i = $aAttributesArray[$J][0] Then ContinueLoop 2
			Next
			While GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0
				$lLevel = GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel")
				$lDeadlock = TimerInit()
				DecreaseAttribute($i, $aHeroNumber)
				Do
					Sleep(16)
				Until GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > 5000
				Sleep(16)
			WEnd
		EndIf
	Next
	Out("ok 4")
	$TestTimer = 0

	While GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $aAttributesArray[0][1]
		$lLevel = GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
		$lDeadlock = TimerInit()
		IncreaseAttribute($lPrimaryAttribute, $aHeroNumber)
		Do
			Sleep(16)
			$TestTimer = $TestTimer + 1
		Until GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > 5000
		Sleep(16)
		If $TestTimer > 225 Then ExitLoop
	WEnd
	Out("ok 5")
	For $i = 1 To UBound($aAttributesArray) - 1
		$TestTimer = 0

		While GetPartyAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") < $aAttributesArray[$i][1]
			$lLevel = GetPartyAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel")
			$lDeadlock = TimerInit()
			IncreaseAttribute($aAttributesArray[$i][0], $aHeroNumber)
			Do
				Sleep(16)
				$TestTimer = $TestTimer + 1
			Until GetPartyAttributeInfo($aAttributesArray[$i][0], $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > 5000
			Sleep(16)
			If $TestTimer > 225 Then ExitLoop
		WEnd
	Next
	Out("ok end")
EndFunc   ;==>LoadAttributes

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

#Region gold
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
#EndRegion

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

Func WaitMapLoadingEx($aMapID = -1, $aInstanceType = -1)
	Do
		Sleep(250)
		If GetGameInfo("IsCinematic") Then
			SkipCinematic()
			Sleep(1000)
		EndIf
	Until GetAgentPtr(-2) <> 0 And GetAgentArraySize() <> 0 And GetWorldInfo("SkillbarArray") <> 0 And GetPartyContextPtr() <> 0 _
	And ($aInstanceType = -1 Or GetInstanceInfo("Type") = $aInstanceType) And ($aMapID = -1 Or GetMapID() = $aMapID) And Not GetGameInfo("IsCinematic")
EndFunc

;~ Description: Returns current MapID
Func GetMapID()
    Return GetCharacterInfo("MapID")
EndFunc   ;==>GetMapID
#EndRegion Travel

#Region Other
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
#EndRegion
