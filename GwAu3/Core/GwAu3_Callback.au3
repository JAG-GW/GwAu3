#include-once
#include "GwAu3_Constants_Core.au3"

Func SetEvent($aSkillActivate = '', $aSkillCancel = '', $aSkillComplete = '', $aChatReceive = '', $aLoadFinished = '')
	If Not $mUseEventSystem Then Return
	If $aSkillActivate <> '' Then
		WriteDetour('SkillLogStart', 'SkillLogProc')
	Else
		$mASMString = ''
		_('inc eax')
		_('mov dword[esi+10],eax')
		_('pop esi')
		WriteBinary($mASMString, GetValue('SkillLogStart'))
	EndIf

	If $aSkillCancel <> '' Then
		WriteDetour('SkillCancelLogStart', 'SkillCancelLogProc')
	Else
		$mASMString = ''
		_('push 0')
		_('push 42')
		_('mov ecx,esi')
		WriteBinary($mASMString, GetValue('SkillCancelLogStart'))
	EndIf

	If $aSkillComplete <> '' Then
		WriteDetour('SkillCompleteLogStart', 'SkillCompleteLogProc')
	Else
		$mASMString = ''
		_('mov eax,dword[edi+4]')
		_('test eax,eax')
		WriteBinary($mASMString, GetValue('SkillCompleteLogStart'))
	EndIf

	If $aChatReceive <> '' Then
		WriteDetour('ChatLogStart', 'ChatLogProc')
	Else
		$mASMString = ''
		_('add edi,E')
		_('cmp eax,B')
		WriteBinary($mASMString, GetValue('ChatLogStart'))
	EndIf

	$mSkillActivate = $aSkillActivate
	$mSkillCancel = $aSkillCancel
	$mSkillComplete = $aSkillComplete
	$mChatReceive = $aChatReceive
	$mLoadFinished = $aLoadFinished
EndFunc

Func Event($hWnd, $msg, $wparam, $lparam)
	If $lparam >= 0x1 And $lparam <= 0x3 Then
		Local $skillLogStruct = DllStructCreate("int skillID;int param1;int param2;int param3")
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', DllStructGetPtr($skillLogStruct), 'int', 16, 'int', '')
		HandleSkillEvent($lparam, $skillLogStruct)
		;DllStructDelete($skillLogStruct) ; Clean up
	ElseIf $lparam == 0x4 Then
		Local $chatLogStruct = DllStructCreate("int messageType;char message[512]")
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', DllStructGetPtr($chatLogStruct), 'int', 512, 'int', '')
		ProcessChatMessage($chatLogStruct)
		;DllStructDelete($chatLogStruct) ; Clean up
	ElseIf $lparam == 0x5 Then
		;Call($mLoadFinished)
	EndIf
EndFunc

Func HandleSkillEvent($eventType, $skillLogStruct)
	Local $skillID = DllStructGetData($skillLogStruct, 1)
	Local $param1 = DllStructGetData($skillLogStruct, 2)
	Local $param2 = DllStructGetData($skillLogStruct, 3)
	Local $param3 = DllStructGetData($skillLogStruct, 4) ; Only used for activation

	; Uncomment to enable callback functions
	;~ Switch $eventType
	;~ 	Case $GWAU3_EVENT_SKILL_ACTIVATE
	;~ 		Call($mSkillActivate, $skillID, $param1, $param2, $param3)
	;~ 	Case $GWAU3_EVENT_SKILL_CANCEL
	;~ 		Call($mSkillCancel, $skillID, $param1, $param2)
	;~ 	Case $GWAU3_EVENT_SKILL_COMPLETE
	;~ 		Call($mSkillComplete, $skillID, $param1, $param2)
	;~ EndSwitch
EndFunc

Func ProcessChatMessage($chatLogStruct)
	Local $messageType = DllStructGetData($chatLogStruct, 1)
	Local $message = DllStructGetData($chatLogStruct, "message[512]")
	Local $channel = "Unknown"
	Local $sender = "Unknown"

	Switch $messageType
		Case $GWAU3_CHAT_ALLIANCE ; Alliance
			$channel = "Alliance"
		Case $GWAU3_CHAT_ALL ; All
			$channel = "All"
		Case $GWAU3_CHAT_GUILD ; Guild
			$channel = "Guild"
		Case $GWAU3_CHAT_TEAM ; Team
			$channel = "Team"
		Case $GWAU3_CHAT_TRADE ; Trade
			$channel = "Trade"
		Case $GWAU3_CHAT_GLOBAL ; Sent or Global
			If StringLeft($message, 3) == "-> " Then
				$channel = "Sent"
			Else
				$channel = "Global"
				$sender = "Guild Wars"
			EndIf
		Case $GWAU3_CHAT_ADVISORY ; Advisory
			$channel = "Advisory"
			$sender = "Guild Wars"
		Case $GWAU3_CHAT_WHISPER ; Whisper
			$channel = "Whisper"
		Case Else
			$channel = "Other"
			$sender = "Other"
	EndSwitch

	If $channel <> "Global" And $channel <> "Advisory" And $channel <> "Other" Then
		$sender = StringMid($message, 6, StringInStr($message, "</a>") - 6)
		$message = StringTrimLeft($message, StringInStr($message, "<quote>") + 6)
	EndIf

	If $channel == "Sent" Then
		$sender = StringMid($message, 10, StringInStr($message, "</a>") - 10)
		$message = StringTrimLeft($message, StringInStr($message, "<quote>") + 6)
	EndIf

	; Uncomment to enable callback function
	;Call($mChatReceive, $channel, $sender, $message)
EndFunc

Func RegisterCallbackHandler()
    Return GUIRegisterMsg(0x501, 'Event')
EndFunc

Func UnregisterCallbackHandler()
    Return GUIRegisterMsg(0x501, '')
EndFunc