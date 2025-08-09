#include-once

Global $g_f_LogCallback = Null

Func Log_SetCallback($a_f_Callback)
    $g_f_LogCallback = $a_f_Callback
EndFunc

Func Log_Message($a_s_Message, $a_e_MsgType = $GC_I_LOG_MSGTYPE_INFO, $a_s_Author = "AutoIt", $a_h_EditText = 0)
    If IsFunc($g_f_LogCallback) Then
        Call($g_f_LogCallback, $a_s_Message, $a_e_MsgType, $a_s_Author)
        Return
    EndIf

    If $a_e_MsgType = $GC_I_LOG_MSGTYPE_DEBUG And Not $g_b_DebugMode Then Return False

    Local $l_s_TypeText
    Local $l_x_Color
    Switch $a_e_MsgType
        Case $GC_I_LOG_MSGTYPE_DEBUG
            $l_s_TypeText = "DEBUG"
            $l_x_Color = 0xFFA500
        Case $GC_I_LOG_MSGTYPE_INFO
            $l_s_TypeText = "INFO"
            $l_x_Color = 0x008000
        Case $GC_I_LOG_MSGTYPE_WARNING
            $l_s_TypeText = "WARNING"
            $l_x_Color = 0x00C8FF
        Case $GC_I_LOG_MSGTYPE_ERROR
            $l_s_TypeText = "ERROR"
            $l_x_Color = 0x0000CC
        Case $GC_I_LOG_MSGTYPE_CRITICAL
            $l_s_TypeText = "CRITICAL"
            $l_x_Color = 0x0000FF
        Case Else
            $l_s_TypeText = "INFO"
            $l_x_Color = 0x008000
    EndSwitch

    Local $sLogText = @CRLF & "[" & Log_GetCurrentTime() & "] - " & "[" & $l_s_TypeText & "] - " & "[" & $a_s_Author & "] " & $a_s_Message

    If _GUICtrlRichEdit_GetTextLength($a_h_EditText) > 30000 Then
        _GUICtrlRichEdit_SetText($a_h_EditText, "")
    EndIf

    _GUICtrlRichEdit_SetSel($a_h_EditText, -1, -1)
    _GUICtrlRichEdit_SetCharColor($a_h_EditText, $l_x_Color)
    _GUICtrlRichEdit_AppendText($a_h_EditText, $sLogText)
    _GUICtrlEdit_Scroll($a_h_EditText, 1)
EndFunc

Func Log_Debug($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
	Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_DEBUG, $a_s_Author, $a_h_EditText)
EndFunc

Func Log_Info($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
	Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_INFO, $a_s_Author, $a_h_EditText)
EndFunc

Func Log_Warning($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
	Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_WARNING, $a_s_Author, $a_h_EditText)
EndFunc

Func Log_Error($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
	Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_ERROR, $a_s_Author, $a_h_EditText)
EndFunc

Func Log_Critical($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
	Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_CRITICAL, $a_s_Author, $a_h_EditText)
EndFunc

Func Log_SetDebugMode($a_b_Enable = True)
    $g_b_DebugMode = $a_b_Enable
    Log_Message("Debug Mode " & ($a_b_Enable ? "Enabled" : "Disabled"), $GC_I_LOG_MSGTYPE_INFO, "SetDebugMode")
EndFunc

Func Log_GetCurrentTime()
    Return StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC)
EndFunc