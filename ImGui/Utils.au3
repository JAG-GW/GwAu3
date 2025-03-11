#include-once

#Region Utils Definitions
; Log level constants
Global Const $c_UTILS_Msg_Type_Debug = 0    ; Detailed information for debugging purposes
Global Const $c_UTILS_Msg_Type_Info = 1     ; General operational information
Global Const $c_UTILS_Msg_Type_Warning = 2  ; Warning messages for potential issues
Global Const $c_UTILS_Msg_Type_Error = 3    ; Error messages for operation failures
Global Const $c_UTILS_Msg_Type_Critical = 4 ; Critical errors requiring immediate attention

; Global array to store log messages [time][timeColor][author][authorColor][type][typeColor][message][messageColor]
Global $a_UTILS_Log_Messages[0][8]

Global $i_Bot_DebugMode
#EndRegion

; #FUNCTION# ;===============================================================================
; Name...........: _Utils_LogMessage
; Description ...: Logs a message with timestamp, type, and author information to both memory and file
; Syntax.........: _Utils_LogMessage($Message, $MsgType = $c_UTILS_Msg_Type_Info, $Author = "AutoIt")
; Parameters ....: $Message  - The message text to log
;                  $MsgType  - [optional] The type of message (default: $c_UTILS_Msg_Type_Info):
;                  |$c_UTILS_Msg_Type_Debug (0)    - Blue color, for debug information
;                  |$c_UTILS_Msg_Type_Info (1)     - Yellow color, for general information
;                  |$c_UTILS_Msg_Type_Warning (2)  - Orange color, for warnings
;                  |$c_UTILS_Msg_Type_Error (3)    - Red color, for errors
;                  |$c_UTILS_Msg_Type_Critical (4) - Red color, for critical errors (message also in red)
;                  $Author   - [optional] The source/author of the message (default: "AutoIt")
; Return values .: Success - Returns True
;                  Failure - Returns False and sets @error:
;                  |1 - Failed to create log directory
;                  |2 - Failed to open log file
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Maintains a rolling buffer of last 100 messages in memory
;                  - Logs to file specified in $CONFIG_LOG_FILE
;                  - Empty messages or authors are silently ignored
;                  - Error and Critical messages are also displayed in GUI status if available
;                  - File format: "YYYY-MM-DD HH:MM:SS [TYPE] [AUTHOR] MESSAGE"
;                  - Colors are stored in memory for GUI display purposes
; Related .......: _Utils_RGBA, _Utils_GetCurrentTime
;============================================================================================
Func _Utils_LogMessage($Message, $MsgType = $c_UTILS_Msg_Type_Info, $Author = "AutoIt")
    If StringStripWS($Message, 3) = "" Or StringStripWS($Author, 3) = "" Then Return

    Local $TimeColor = _Utils_RGBA(128, 128, 128)
    Local $AuthorColor = _Utils_RGBA(204, 77, 192)
    Local $TypeColor = _Utils_RGBA(255, 255, 255)
    Local $MessageColor = _Utils_RGBA(255, 255, 255)
    Local $TypeStr = ""

    Switch $MsgType
        Case $c_UTILS_Msg_Type_Debug
            $TypeColor = _Utils_RGBA(0, 127, 255)
            $TypeStr = "DEBUG"
        Case $c_UTILS_Msg_Type_Info
            $TypeColor = _Utils_RGBA(255, 255, 0)
            $TypeStr = "INFO"
        Case $c_UTILS_Msg_Type_Warning
            $TypeColor = _Utils_RGBA(255, 127, 0)
            $TypeStr = "WARNING"
        Case $c_UTILS_Msg_Type_Error
            $TypeColor = _Utils_RGBA(255, 0, 0)
            $TypeStr = "ERROR"
        Case $c_UTILS_Msg_Type_Critical
            $TypeColor = _Utils_RGBA(255, 0, 0)
            $MessageColor = _Utils_RGBA(255, 0, 0)
            $TypeStr = "CRITICAL"
    EndSwitch

    Local $time = _Utils_GetCurrentTime()
    Local $nIndex = UBound($a_UTILS_Log_Messages, 1)
    ReDim $a_UTILS_Log_Messages[$nIndex + 1][8]
    $a_UTILS_Log_Messages[$nIndex][0] = $time
    $a_UTILS_Log_Messages[$nIndex][1] = $TimeColor
    $a_UTILS_Log_Messages[$nIndex][2] = $Author
    $a_UTILS_Log_Messages[$nIndex][3] = $AuthorColor
    $a_UTILS_Log_Messages[$nIndex][4] = $TypeStr
    $a_UTILS_Log_Messages[$nIndex][5] = $TypeColor
    $a_UTILS_Log_Messages[$nIndex][6] = $Message
    $a_UTILS_Log_Messages[$nIndex][7] = $MessageColor

    If UBound($a_UTILS_Log_Messages, 1) > 1000 Then _ArrayDelete($a_UTILS_Log_Messages, 0)

;~     Local $sLogFolder = StringRegExpReplace($CONFIG_LOG_FILE, "\\[^\\]+$", "")
;~     If Not FileExists($sLogFolder) Then
;~         DirCreate($sLogFolder)
;~         If @error Then Return SetError(1, 0, False)
;~     EndIf

    Local $sTimestamp = @YEAR & "-" & @MON & "-" & @MDAY & " " & $time
    Local $sLogMessage = StringFormat("%s [%s] [%s] %s", $sTimestamp, $TypeStr, $Author, $Message)

;~     Local $hFile = FileOpen($CONFIG_LOG_FILE, $FO_APPEND)
;~     If $hFile = -1 Then Return SetError(2, 0, False)
;~     FileWriteLine($hFile, $sLogMessage)
;~     FileClose($hFile)

    If ($MsgType = $c_UTILS_Msg_Type_Error Or $MsgType = $c_UTILS_Msg_Type_Critical) And IsDeclared("g_hStatus") Then GUICtrlSetData($s_GUI_Status, $TypeStr & ": " & $Message)

    Return True
EndFunc


; #FUNCTION# ;===============================================================================
; Name...........: _Utils_RGBA
; Description ...: Creates a 32-bit RGBA color value from individual color components
; Syntax.........: _Utils_RGBA($r, $g, $b, $a = 255)
; Parameters ....: $r - Red component (0-255)
;                  $g - Green component (0-255)
;                  $b - Blue component (0-255)
;                  $a - [optional] Alpha component (0-255, default: 255)
; Return values .: Returns 32-bit integer representing the RGBA color
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Components are combined using bit shifting and OR operations
;                  - Alpha channel is stored in the highest 8 bits
;                  - Color components are stored in order: ARGB
;                  - No validation is performed on input values
; Related .......: _Utils_LogMessage
;============================================================================================
Func _Utils_RGBA($r, $g, $b, $a = 255)
    Return BitOR(BitShift($a, -24), BitShift($r, -16), BitShift($g, -8), $b)
EndFunc


; #FUNCTION# ;===============================================================================
; Name...........: _Utils_GetCurrentTime
; Description ...: Returns the current time formatted as HH:MM:SS
; Syntax.........: _Utils_GetCurrentTime()
; Parameters ....: None
; Return values .: Returns formatted time string in format "HH:MM:SS"
; Author ........: Greg-76
; Modified.......:
; Remarks .......: - Uses 24-hour format
;                  - Always returns 2 digits for each component
;                  - Uses system time (@HOUR, @MIN, @SEC)
;                  - Time is formatted using leading zeros where necessary
; Related .......: _Utils_LogMessage
;============================================================================================
Func _Utils_GetCurrentTime()
    Return StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC)
EndFunc


Func _Utils_SetDebugMode($enable = True)
    $i_Bot_DebugMode = $enable
    _Utils_LogMessage("Mode Debug Bot " & ($enable ? "enabled" : "disabled"), $c_UTILS_Msg_Type_Info, $g_aBots[$g_iSelectedFolder][0])
EndFunc