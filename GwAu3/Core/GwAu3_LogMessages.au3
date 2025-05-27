#include-once
#include <RichEditConstants.au3>
#include <GuiRichEdit.au3>
#include <GuiEdit.au3>
#include "GwAu3_Constants_Core.au3"

Func _Log_Message($Message, $MsgType = $c_Log_Msg_Type_Info, $Author = "AutoIt", $GUIEdit = 0)
    If $MsgType = $c_Log_Msg_Type_Debug And Not $g_iDebugMode Then Return False

    Local $sTypeText
    Local $iColor
    Switch $MsgType
        Case $c_Log_Msg_Type_Debug
            $sTypeText = "DEBUG"
            $iColor = 0xFFA500
        Case $c_Log_Msg_Type_Info
            $sTypeText = "INFO"
            $iColor = 0x008000
        Case $c_Log_Msg_Type_Warning
            $sTypeText = "WARNING"
            $iColor = 0x00C8FF
        Case $c_Log_Msg_Type_Error
            $sTypeText = "ERROR"
            $iColor = 0x0000CC
        Case $c_Log_Msg_Type_Critical
            $sTypeText = "CRITICAL"
            $iColor = 0x0000FF
        Case Else
            $sTypeText = "INFO"
            $iColor = 0x008000
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

Func _Log_Debug($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Debug, $Author, $GUIEdit)
EndFunc

Func _Log_Info($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Info, $Author, $GUIEdit)
EndFunc

Func _Log_Warning($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Warning, $Author, $GUIEdit)
EndFunc

Func _Log_Error($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Error, $Author, $GUIEdit)
EndFunc

Func _Log_Critical($Message, $Author = "AutoIt", $GUIEdit = 0)
	_Log_Message($Message, $c_Log_Msg_Type_Critical, $Author, $GUIEdit)
EndFunc

Func _Log_SetDebugMode($bEnable = True)
    $g_iDebugMode = $bEnable
    _Log_Message("Debug Mode " & ($bEnable ? "Enabled" : "Disabled"), $c_Log_Msg_Type_Info, "SetDebugMode")
EndFunc

Func _Log_GetCurrentTime()
    Return StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC)
EndFunc
