#include-once

;~ Description: Write a message in chat (can only be seen by botter).
Func Chat_WriteChat($a_s_Message, $a_s_Sender = 'GwAu3')
    Local $l_s_Message, $l_s_Sender
    Local $l_p_Address = 256 * $g_i_QueueCounter + $g_p_QueueBase

    If $g_i_QueueCounter = $g_i_QueueSize Then
        $g_i_QueueCounter = 0
    Else
        $g_i_QueueCounter = $g_i_QueueCounter + 1
    EndIf

    If StringLen($a_s_Sender) > 19 Then
        $l_s_Sender = StringLeft($a_s_Sender, 19)
    Else
        $l_s_Sender = $a_s_Sender
    EndIf

    Memory_Write($l_p_Address + 4, $l_s_Sender, 'wchar[20]')

    If StringLen($a_s_Message) > 100 Then
        $l_s_Message = StringLeft($a_s_Message, 100)
    Else
        $l_s_Message = $a_s_Message
    EndIf

    Memory_Write($l_p_Address + 44, $l_s_Message, 'wchar[101]')
    DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'int', $l_p_Address, 'ptr', $g_p_WriteChatPtr, 'int', 4, 'int', '')

    If StringLen($a_s_Message) > 100 Then Chat_WriteChat(StringTrimLeft($a_s_Message, 100), $a_s_Sender)
EndFunc   ;==>Chat_WriteChat

;~ Description: Send a whisper to another player.
Func Chat_SendWhisper($a_s_Receiver, $a_s_Message)
    Local $l_s_Total = 'whisper ' & $a_s_Receiver & ',' & $a_s_Message
    Local $l_s_Message

    If StringLen($l_s_Total) > 120 Then
        $l_s_Message = StringLeft($l_s_Total, 120)
    Else
        $l_s_Message = $l_s_Total
    EndIf

    Chat_SendChat($l_s_Message, '/')

    If StringLen($l_s_Total) > 120 Then Chat_SendWhisper($a_s_Receiver, StringTrimLeft($l_s_Total, 120))
EndFunc   ;==>Chat_SendWhisper

;~ Description: Send a message to chat.
;~ '!' = All, '@' = Guild, '#' = Team, '$' = Trade, '%' = Alliance, '"' = Whisper
Func Chat_SendChat($a_s_Message, $a_s_Channel = '!')
    Local $l_s_Message
    Local $l_p_Address = 256 * $g_i_QueueCounter + $g_p_QueueBase

    If $g_i_QueueCounter = $g_i_QueueSize Then
        $g_i_QueueCounter = 0
    Else
        $g_i_QueueCounter = $g_i_QueueCounter + 1
    EndIf

    If StringLen($a_s_Message) > 120 Then
        $l_s_Message = StringLeft($a_s_Message, 120)
    Else
        $l_s_Message = $a_s_Message
    EndIf

    Memory_Write($l_p_Address + 12, $a_s_Channel & $l_s_Message, 'wchar[122]')
    DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'int', $l_p_Address, 'ptr', $g_p_SendChat, 'int', 8, 'int', '')

    If StringLen($a_s_Message) > 120 Then Chat_SendChat(StringTrimLeft($a_s_Message, 120), $a_s_Channel)
EndFunc   ;==>Chat_SendChat