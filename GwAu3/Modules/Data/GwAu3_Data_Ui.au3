#include-once

;~ Description: Checks if Rendering is disabled
Func GwAu3_Ui_GetRenderDisabled()
    Return GwAu3_Memory_Read($g_b_DisableRendering) = 1
EndFunc ;==>GetRenderDisabled

;~ Description: Checks if Rendering is enabled
Func GwAu3_Ui_GetRenderEnabled()
    Return GwAu3_Memory_Read($g_b_DisableRendering) = 0
EndFunc ;==>GetRenderEnabled