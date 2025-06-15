#include-once
#include "../GwAu3_Core.au3"
#include "../Commands/GwAu3_Packet.au3"

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
	Sleep(GwAu3_OtherMod_GetPing() + $msExtra)
EndFunc   ;==>PingSleep
#EndRegion

#Region Rendering
;~ Description: Enable graphics rendering.
Func EnableRendering()
    If GetRenderEnabled() Then Return 1
	GwAu3_Memory_Write($mDisableRendering, 0)
EndFunc ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering()
	If GetRenderDisabled() Then Return 1
	GwAu3_Memory_Write($mDisableRendering, 1)
EndFunc ;==>DisableRendering

;~ Description: Checks if Rendering is disabled
Func GetRenderDisabled()
	Return GwAu3_Memory_Read($mDisableRendering) = 1
EndFunc ;==>GetRenderDisabled

;~ Description: Checks if Rendering is enabled
Func GetRenderEnabled()
	Return GwAu3_Memory_Read($mDisableRendering) = 0
EndFunc ;==>GetRenderEnabled

;~ Description: Toggle Rendering *and* Window State
Func ToggleRendering()
	If GetRenderDisabled() Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		GwAu3_Memory_Clear()
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
		GwAu3_Memory_Clear()
	Else
		DisableRendering()
		GwAu3_Memory_Clear()
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

	GwAu3_Memory_Write($lAddress + 4, $lSender, 'wchar[20]')

	If StringLen($aMessage) > 100 Then
		$lMessage = StringLeft($aMessage, 100)
	Else
		$lMessage = $aMessage
	EndIf

	GwAu3_Memory_Write($lAddress + 44, $lMessage, 'wchar[101]')
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
;~ '!' = All, '@' = Guild, '#' = Team, '$' = Trade, '%' = Alliance, '"' = Whisper
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

	GwAu3_Memory_Write($lAddress + 12, $aChannel & $lMessage, 'wchar[122]')
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mSendChatPtr, 'int', 8, 'int', '')

	If StringLen($aMessage) > 120 Then SendChat(StringTrimLeft($aMessage, 120), $aChannel)
EndFunc   ;==>SendChat
#EndRegion Chat

#Region gold
;~ Description: Deposit gold into storage.
Func DepositGold($aAmount = 0)
	Local $lAmount
	Local $lStorage = GwAu3_ItemMod_GetInventoryInfo("GoldStorage")
	Local $lCharacter = GwAu3_ItemMod_GetInventoryInfo("GoldCharacter")

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
	Local $lStorage = GwAu3_ItemMod_GetInventoryInfo("GoldStorage")
	Local $lCharacter = GwAu3_ItemMod_GetInventoryInfo("GoldCharacter")

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
Func TravelTo($aMapID, $aLanguage = GwAu3_MapMod_GetCharacterInfo("Language"), $aRegion = GwAu3_MapMod_GetCharacterInfo("Region"), $aDistrict = 0)
	If	_MapMod_GetCharacterInfo("MapID") = $aMapID And GwAu3_MapMod_GetInstanceInfo("IsOutpost") _
		And $aLanguage = GwAu3_MapMod_GetCharacterInfo("Language") And $aRegion = GwAu3_MapMod_GetCharacterInfo("Region")  Then Return True
	MoveMap($aMapID, $aRegion, $aDistrict, $aLanguage)
	Return WaitMapLoading($aMapID)
EndFunc   ;==>TravelTo

;~ 	Waits $aDeadlock for load to start, and $aDeadLock for agent to load after map is loaded.
Func WaitMapLoading($aMapID = 0, $aDeadlock = 10000, $aSkipCinematic = False)
	Local $Timer = TimerInit(), $lTypeMap
	Do
		Sleep(100)
		$lTypeMap = GwAu3_Memory_Read(_AgentMod_GetAgentPtr(-2) + 0x158, 'long')
	Until Not BitAND($lTypeMap, 0x400000) Or TimerDiff($Timer) > $aDeadlock

	If $aSkipCinematic Then
		Sleep(2500)
		SkipCinematic()
	EndIf

	$Timer = TimerInit()
	Do
		$lTypeMap = GwAu3_Memory_Read(_AgentMod_GetAgentPtr(-2) + 0x158, 'long')
		Sleep(200)
	Until BitAND($lTypeMap, 0x400000) And (GetMapID() = $aMapID Or $aMapID = 0) Or TimerDiff($Timer) > $aDeadlock
	Sleep(3000)
	If TimerDiff($Timer) < $aDeadlock + 3000 Then Return True
	Return False
EndFunc   ;==>WaitMapLoading

Func WaitMapLoadingEx($aMapID = -1, $aInstanceType = -1)
	Do
		Sleep(250)
		If GwAu3_OtherMod_GetGameInfo("IsCinematic") Then
			SkipCinematic()
			Sleep(1000)
		EndIf
	Until GwAu3_AgentMod_GetAgentPtr(-2) <> 0 And GwAu3_AgentMod_GetAgentArraySize() <> 0 And GwAu3_OtherMod_GetWorldInfo("SkillbarArray") <> 0 And _PartyMod_GetPartyContextPtr() <> 0 _
	And ($aInstanceType = -1 Or GwAu3_MapMod_GetInstanceInfo("Type") = $aInstanceType) And ($aMapID = -1 Or GetMapID() = $aMapID) And Not GwAu3_OtherMod_GetGameInfo("IsCinematic")
EndFunc

;~ Description: Returns current MapID
Func GetMapID()
    Return GwAu3_MapMod_GetCharacterInfo("MapID")
EndFunc   ;==>GetMapID
#EndRegion Travel

#Region Other
;~ Description: Returns the distance between two agents.
Func GetDistance($aAgentID1 = -1, $aAgentID2 = -2)
	Return ComputeDistance(GwAu3_AgentMod_GetAgentInfo($aAgentID1, 'X'), GwAu3_AgentMod_GetAgentInfo($aAgentID1, 'Y'), GwAu3_AgentMod_GetAgentInfo($aAgentID2, 'X'), GwAu3_AgentMod_GetAgentInfo($aAgentID2, 'Y'))
EndFunc   ;==>GetDistance

;~ Description: Returns the distance between two coordinate pairs.
Func ComputeDistance($aX1, $aY1, $aX2, $aY2)
	Return Sqrt(($aX1 - $aX2) ^ 2 + ($aY1 - $aY2) ^ 2)
EndFunc   ;==>ComputeDistance

Func GetBestTarget($aRange = 1320)
	Local $lBestTarget, $lDistance, $lLowestSum = 100000000
	Local $lAgentArray = GwAu3_AgentMod_GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		Local $lSumDistances = 0
		If GwAu3_AgentMod_GetAgentInfo($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If GwAu3_AgentMod_GetAgentInfo($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If GwAu3_AgentMod_GetAgentInfo($lAgentArray[$i], 'ID') = GwAu3_AgentMod_GetMyID() Then ContinueLoop
		If GetDistance($lAgentArray[$i]) > $aRange Then ContinueLoop
		For $j = 1 To $lAgentArray[0]
			If GwAu3_AgentMod_GetAgentInfo($lAgentArray[$j], 'Allegiance') <> 3 Then ContinueLoop
			If GwAu3_AgentMod_GetAgentInfo($lAgentArray[$j], 'HP') <= 0 Then ContinueLoop
			If GwAu3_AgentMod_GetAgentInfo($lAgentArray[$j], 'ID') = GwAu3_AgentMod_GetMyID() Then ContinueLoop
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

;~ Description: Returns modstruct of an item.
Func GetModStruct($aItem)
	If GwAu3_ItemMod_GetItemInfoByItemID($aItem, "ModStruct") = 0 Then Return
	Return GwAu3_Memory_Read(_ItemMod_GetItemInfoByItemID($aItem, "ModStruct"), 'Byte[' & GwAu3_ItemMod_GetItemInfoByItemID($aItem, "ModStructSize") * 4 & ']')
EndFunc   ;==>GetModStruct
#EndRegion
