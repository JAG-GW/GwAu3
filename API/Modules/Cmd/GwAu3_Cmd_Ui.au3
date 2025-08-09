#include-once

Func Ui_EnterChallenge($a_b_Foreign = False)
    DllStructSetData($g_d_EnterMission, 2, Not $a_b_Foreign)
    Core_Enqueue($g_p_EnterMission, 8)
EndFunc   ;==>EnterChallenge

Func Ui_SetDifficulty($a_b_HardMode = False)
    DllStructSetData($g_d_SetDifficulty, 2, $a_b_HardMode)
    Core_Enqueue($g_p_SetDifficulty, 8)
EndFunc   ;==>Ui_SetDifficulty

;~ Description: Open targeted chest using dialog options. (0x1 = Use Key, 0x2 = Use Lockpick, 0x80 = Cancel)
Func Ui_OpenChest($a_b_UseLockpick = True)
    If $a_b_UseLockpick Then 
        DllStructSetData($g_d_OpenChest, 2, 0x2)
    Else
        DllStructSetData($g_d_OpenChest, 2, 0x1)
    EndIf
    Core_Enqueue($g_p_OpenChest, 8)
EndFunc   ;==>Ui_OpenChest

;~ Description: Open a dialog.
Func Ui_Dialog($a_v_DialogID)
    Return Core_SendPacket(0x8, $GC_I_HEADER_DIALOG_SEND, $a_v_DialogID)
EndFunc   ;==>Dialog

;~ Description: Enable graphics rendering.
Func Ui_EnableRendering()
    If Ui_GetRenderEnabled() Then Return 1
    Memory_Write($g_b_DisableRendering, 0)
EndFunc ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func Ui_DisableRendering()
    If Ui_GetRenderDisabled() Then Return 1
    Memory_Write($g_b_DisableRendering, 1)
EndFunc ;==>DisableRendering

;~ Description: Toggle Rendering *and* Window State
Func Ui_ToggleRendering()
    If Ui_GetRenderDisabled() Then
        Ui_EnableRendering()
        WinSetState(Scanner_GetWindowHandle(), "", @SW_SHOW)
    Else
        Ui_DisableRendering()
        WinSetState(Scanner_GetWindowHandle(), "", @SW_HIDE)
        Memory_Clear()
    EndIf
EndFunc ;==>ToggleRendering

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
;~              Also toggles Window State
Func Ui_PurgeHook($a_i_Time = 10000)
    If Ui_GetRenderEnabled() Then Return 1
    Ui_ToggleRendering()
    Sleep($a_i_Time)
    Ui_ToggleRendering()
EndFunc ;==>PurgeHook

;~ Description: Toggle Rendering (the GW window will stay hidden)
Func Ui_ToggleRendering_()
    If Ui_GetRenderDisabled() Then
        Ui_EnableRendering()
        Memory_Clear()
    Else
        Ui_DisableRendering()
        Memory_Clear()
    EndIf
EndFunc ;==>ToggleRendering_

;~ Description: Enable Rendering for duration $a_i_Time(ms), then Disable Rendering again.
Func Ui_PurgeHook_($a_i_Time = 10000)
    If Ui_GetRenderEnabled() Then Return 1
    Ui_ToggleRendering_()
    Sleep($a_i_Time)
    Ui_ToggleRendering_()
EndFunc ;==PurgeHook_