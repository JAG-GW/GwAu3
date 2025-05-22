#include-once
#include "GwAu3_Constants_Core.au3"

; #FUNCTION# ;===============================================================================
; Name...........: SetEvent
; Description ...: Configures the event system with callback functions
; Syntax.........: SetEvent($aSkillActivate = '', $aSkillCancel = '', $aSkillComplete = '', $aChatReceive = '', $aLoadFinished = '')
; Parameters ....: $aSkillActivate - [optional] Function to call on skill activation (default: '')
;                  $aSkillCancel   - [optional] Function to call on skill cancellation (default: '')
;                  $aSkillComplete - [optional] Function to call on skill completion (default: '')
;                  $aChatReceive   - [optional] Function to call on chat message reception (default: '')
;                  $aLoadFinished  - [optional] Function to call when map loading is finished (default: '')
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - If $mUseEventSystem is False, this function does nothing
;                  - For each event type, if a callback function is provided, a detour is created
;                  - If no callback is provided, original code is restored
;                  - Callback functions should accept parameters specific to each event type
;                  - This function must be called after Initialize()
; Related .......: Event, HandleSkillEvent, ProcessChatMessage
;============================================================================================
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
EndFunc   ;==>SetEvent

; #FUNCTION# ;===============================================================================
; Name...........: Event
; Description ...: Handles Windows messages for Guild Wars events
; Syntax.........: Event($hWnd, $msg, $wparam, $lparam)
; Parameters ....: $hWnd    - Handle to the window that received the message
;                  $msg     - Message identifier
;                  $wparam  - Additional message-specific information (pointer to data)
;                  $lparam  - Additional message-specific information (event type)
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - This function is registered as a message handler for the GwAu3 GUI
;                  - It handles different event types based on the $lparam value:
;                    * 0x1-0x3: Skill events (activate, cancel, complete)
;                    * 0x4: Chat message events
;                    * 0x5: Map loading finished events
;                  - For each event type, it reads the relevant data from memory
;                  - Calls the appropriate event handler based on event type
; Related .......: SetEvent, HandleSkillEvent, ProcessChatMessage
;============================================================================================
Func Event($hWnd, $msg, $wparam, $lparam)
	; Initial check for skill-related events to avoid unnecessary DllCalls for chat events
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
EndFunc   ;==>Event

; #FUNCTION# ;===============================================================================
; Name...........: HandleSkillEvent
; Description ...: Processes skill-related events and calls appropriate callbacks
; Syntax.........: HandleSkillEvent($eventType, $skillLogStruct)
; Parameters ....: $eventType      - Type of skill event (1=activate, 2=cancel, 3=complete)
;                  $skillLogStruct - DllStruct containing skill event data
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Extracts data from the skill log structure
;                  - Different event types have different parameter signatures:
;                    * Skill Activate: skillID, target ID, energy cost, activation time
;                    * Skill Cancel: skillID, target ID, reason code
;                    * Skill Complete: skillID, target ID, result code
;                  - Forwards the data to the appropriate callback function
;                  - Current implementation has callback calls commented out
; Related .......: Event, SetEvent
;============================================================================================
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
EndFunc   ;==>HandleSkillEvent

; #FUNCTION# ;===============================================================================
; Name...........: ProcessChatMessage
; Description ...: Processes chat messages and calls the chat callback function
; Syntax.........: ProcessChatMessage($chatLogStruct)
; Parameters ....: $chatLogStruct - DllStruct containing chat message data
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Extracts message type, content, channel, and sender from the chat structure
;                  - Identifies the channel based on the message type (Alliance, Guild, Team, etc.)
;                  - Extracts sender name and message content from the HTML-formatted message
;                  - Special handling for Sent/Global messages and different channel types
;                  - Forwards channel, sender, and message to the chat callback function
;                  - Current implementation has callback call commented out
; Related .......: Event, SetEvent
;============================================================================================
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
EndFunc   ;==>ProcessChatMessage

; #FUNCTION# ;===============================================================================
; Name...........: RegisterCallbackHandler
; Description ...: Registers the Event function as a message handler for the GwAu3 GUI
; Syntax.........: RegisterCallbackHandler()
; Parameters ....: None
; Return values .: True if registration successful, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Must be called after the GwAu3 GUI is created
;                  - Sets up the communication channel between Guild Wars and AutoIt
;                  - Uses Windows message 0x501 (1281) for callback events
;                  - The Event function will be called when Guild Wars sends events
; Related .......: Event, SetEvent
;============================================================================================
Func RegisterCallbackHandler()
    Return GUIRegisterMsg(0x501, 'Event')
EndFunc   ;==>RegisterCallbackHandler

; #FUNCTION# ;===============================================================================
; Name...........: UnregisterCallbackHandler
; Description ...: Removes the Event function as a message handler
; Syntax.........: UnregisterCallbackHandler()
; Parameters ....: None
; Return values .: True if unregistration successful, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Should be called when closing the application
;                  - Prevents memory leaks and potential crashes
;                  - Removes the message handler for the 0x501 callback message
; Related .......: RegisterCallbackHandler, Event
;============================================================================================
Func UnregisterCallbackHandler()
    Return GUIRegisterMsg(0x501, '')
EndFunc   ;==>UnregisterCallbackHandler