#include-once

Func GwAu3_Ui_EnterChallenge($a_b_Foreign = False)
    DllStructSetData($g_d_EnterMission, 2, Not $a_b_Foreign)
    GwAu3_Core_Enqueue($g_p_EnterMission, 8)
EndFunc   ;==>EnterChallenge

;~ Description: Open a dialog.
Func GwAu3_Ui_Dialog($a_v_DialogID)
    Return GwAu3_Core_SendPacket(0x8, $GC_I_HEADER_DIALOG_SEND, $a_v_DialogID)
EndFunc   ;==>Dialog

;~ Description: Enable graphics rendering.
Func GwAu3_Ui_EnableRendering()
    If GwAu3_Ui_GetRenderEnabled() Then Return 1
    GwAu3_Memory_Write($g_b_DisableRendering, 0)
EndFunc ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func GwAu3_Ui_DisableRendering()
    If GwAu3_Ui_GetRenderDisabled() Then Return 1
    GwAu3_Memory_Write($g_b_DisableRendering, 1)
EndFunc ;==>DisableRendering

;~ Description: Toggle Rendering *and* Window State
Func GwAu3_Ui_ToggleRendering()
    If GwAu3_Ui_GetRenderDisabled() Then
        GwAu3_Ui_EnableRendering()
        WinSetState(GetWindowHandle(), "", @SW_SHOW)
    Else
        GwAu3_Ui_DisableRendering()
        WinSetState(GetWindowHandle(), "", @SW_HIDE)
        GwAu3_Memory_Clear()
    EndIf
EndFunc ;==>ToggleRendering

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
;~              Also toggles Window State
Func GwAu3_Ui_PurgeHook($a_i_Time = 10000)
    If GwAu3_Ui_GetRenderEnabled() Then Return 1
    GwAu3_Ui_ToggleRendering()
    Sleep($a_i_Time)
    GwAu3_Ui_ToggleRendering()
EndFunc ;==>PurgeHook

;~ Description: Toggle Rendering (the GW window will stay hidden)
Func GwAu3_Ui_ToggleRendering_()
    If GwAu3_Ui_GetRenderDisabled() Then
        GwAu3_Ui_EnableRendering()
        GwAu3_Memory_Clear()
    Else
        GwAu3_Ui_DisableRendering()
        GwAu3_Memory_Clear()
    EndIf
EndFunc ;==>ToggleRendering_

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
Func GwAu3_Ui_PurgeHook_($a_i_Time = 10000)
    If GwAu3_Ui_GetRenderEnabled() Then Return 1
    GwAu3_Ui_ToggleRendering_()
    Sleep($a_i_Time)
    GwAu3_Ui_ToggleRendering_()
EndFunc ;==PurgeHook_