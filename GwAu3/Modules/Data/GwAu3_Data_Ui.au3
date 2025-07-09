#include-once

;~ Description: Checks if Rendering is disabled
Func Ui_GetRenderDisabled()
    Return Memory_Read($g_b_DisableRendering) = 1
EndFunc ;==>GetRenderDisabled

;~ Description: Checks if Rendering is enabled
Func Ui_GetRenderEnabled()
    Return Memory_Read($g_b_DisableRendering) = 0
EndFunc ;==>GetRenderEnabled