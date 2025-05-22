#include-once
#include "GwAu3_Constants_Core.au3"

; #FUNCTION# ;===============================================================================
; Name...........: _Log_Message
; Description ...: Logs a message with timestamp, type, and author information
; Syntax.........: _Log_Message($Message, $MsgType = $c_Log_Msg_Type_Info, $Author = "AutoIt", $GUIEdit = 0)
; Parameters ....: $Message  - The text message to log
;                  $MsgType  - [optional] The type of message (default: $c_Log_Msg_Type_Info)
;                  $Author   - [optional] The source/author of the message (default: "AutoIt")
;                  $GUIEdit  - [optional] The RichEdit control where to display the message (default: 0)
; Return values .: None
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Checks that message and author are not empty
;                  - Ignores DEBUG messages if debug mode is disabled
;                  - Clears the RichEdit control if it contains more than 30000 characters
;                  - Applies different color according to message type
; Related .......: _Log_Debug, _Log_Info, _Log_Warning, _Log_Error, _Log_Critical
;============================================================================================
Func _Log_Message($Message, $MsgType = $c_Log_Msg_Type_Info, $Author = "AutoIt", $GUIEdit = 0)
    If $MsgType = $c_Log_Msg_Type_Debug And Not $g_iDebugMode Then Return False

    Local $sTypeText
    Local $iColor
    Switch $MsgType
        Case $c_Log_Msg_Type_Debug
            $sTypeText = "DEBUG"
            $iColor = 0xFFA500  ; Bleu (format BGR: 0x00BBGGRR)
        Case $c_Log_Msg_Type_Info
            $sTypeText = "INFO"
            $iColor = 0x008000  ; Vert
        Case $c_Log_Msg_Type_Warning
            $sTypeText = "WARNING"
            $iColor = 0x00C8FF  ; Orange (format BGR)
        Case $c_Log_Msg_Type_Error
            $sTypeText = "ERROR"
            $iColor = 0x0000CC  ; Rouge
        Case $c_Log_Msg_Type_Critical
            $sTypeText = "CRITICAL"
            $iColor = 0x0000FF  ; Rouge vif
        Case Else
            $sTypeText = "INFO"
            $iColor = 0x008000  ; Vert
    EndSwitch

    Local $sLogText = @CRLF & "[" & _Log_GetCurrentTime() & "] - " & "[" & $sTypeText & "] - " & "[" & $Author & "] " & $Message

    If _GUICtrlRichEdit_GetTextLength($GUIEdit) > 30000 Then
        _GUICtrlRichEdit_SetText($GUIEdit, "")
    EndIf

    _GUICtrlRichEdit_SetSel($GUIEdit, -1, -1)
    _GUICtrlRichEdit_SetCharColor($GUIEdit, $iColor)
    _GUICtrlRichEdit_AppendText($GUIEdit, $sLogText)
    _GUICtrlEdit_Scroll($GUIEdit, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _Log_Debug
; Description ...: Wrapper function to log a DEBUG type message
; Syntax.........: _Log_Debug($Message, $Author = "AutoIt", $GUIEdit = 0)
; Parameters ....: $Message  - The text message to log
;                  $Author   - [optional] The source/author of the message (default: "AutoIt")
;                  $GUIEdit  - [optional] The RichEdit control where to display the message (default: 0)
; Return values .: None
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Only logs the message if debug mode is enabled
;                  - Uses blue color for messages
; Related .......: _Log_Message, _Log_SetDebugMode
;============================================================================================
Func _Log_Debug($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Debug, $Author, $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _Log_Info
; Description ...: Wrapper function to log an INFO type message
; Syntax.........: _Log_Info($Message, $Author = "AutoIt", $GUIEdit = 0)
; Parameters ....: $Message  - The text message to log
;                  $Author   - [optional] The source/author of the message (default: "AutoIt")
;                  $GUIEdit  - [optional] The RichEdit control where to display the message (default: 0)
; Return values .: None
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Uses green color for messages
; Related .......: _Log_Message
;============================================================================================
Func _Log_Info($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Info, $Author, $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _Log_Warning
; Description ...: Wrapper function to log a WARNING type message
; Syntax.........: _Log_Warning($Message, $Author = "AutoIt", $GUIEdit = 0)
; Parameters ....: $Message  - The text message to log
;                  $Author   - [optional] The source/author of the message (default: "AutoIt")
;                  $GUIEdit  - [optional] The RichEdit control where to display the message (default: 0)
; Return values .: None
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Uses orange color for messages
; Related .......: _Log_Message
;============================================================================================
Func _Log_Warning($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Warning, $Author, $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _Log_Error
; Description ...: Wrapper function to log an ERROR type message
; Syntax.........: _Log_Error($Message, $Author = "AutoIt", $GUIEdit = 0)
; Parameters ....: $Message  - The text message to log
;                  $Author   - [optional] The source/author of the message (default: "AutoIt")
;                  $GUIEdit  - [optional] The RichEdit control where to display the message (default: 0)
; Return values .: None
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Uses red color for messages
; Related .......: _Log_Message
;============================================================================================
Func _Log_Error($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Error, $Author, $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _Log_Critical
; Description ...: Wrapper function to log a CRITICAL type message
; Syntax.........: _Log_Critical($Message, $Author = "AutoIt", $GUIEdit = 0)
; Parameters ....: $Message  - The text message to log
;                  $Author   - [optional] The source/author of the message (default: "AutoIt")
;                  $GUIEdit  - [optional] The RichEdit control where to display the message (default: 0)
; Return values .: None
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Uses bright red color for messages
; Related .......: _Log_Message
;============================================================================================
Func _Log_Critical($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Critical, $Author, $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _Log_SetDebugMode
; Description ...: Enables or disables debug mode
; Syntax.........: _Log_SetDebugMode($bEnable = True)
; Parameters ....: $bEnable - True to enable debug mode, False to disable it
; Return values .: None
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - When debug mode is disabled, DEBUG messages are not displayed
;                  - Automatically logs a message indicating the state change
; Related .......: _Log_Debug, _Log_Message
;============================================================================================
Func _Log_SetDebugMode($bEnable = True)
    $g_iDebugMode = $bEnable
    _Log_Message("Debug Mode " & ($bEnable ? "Enabled" : "Disabled"), $c_Log_Msg_Type_Info, "SetDebugMode")
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _Log_GetCurrentTime
; Description ...: Returns the current time formatted as HH:MM:SS
; Syntax.........: _Log_GetCurrentTime()
; Parameters ....: None
; Return values .: Returns a formatted time string in the format "HH:MM:SS"
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Uses 24-hour format
;                  - Always displays 2 digits for each component (hours, minutes, seconds)
; Related .......: _Log_Message
;============================================================================================
Func _Log_GetCurrentTime()
    Return StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC)
EndFunc
