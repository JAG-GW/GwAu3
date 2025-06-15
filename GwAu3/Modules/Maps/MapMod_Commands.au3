#include-once

Func GwAu3_MapMod_Move($fX, $fY, $fRandomize = 50)
    ; Add randomization if requested
    If $fRandomize > 0 Then
        $fX += Random(-$fRandomize, $fRandomize)
        $fY += Random(-$fRandomize, $fRandomize)
    EndIf

    ; Store last move coordinates
    $g_fLastMoveX = $fX
    $g_fLastMoveY = $fY

    ; Set move data
	DllStructSetData($g_mMove, 1, GwAu3_Memory_GetValue('CommandMove'))
    DllStructSetData($g_mMove, 2, $fX)
    DllStructSetData($g_mMove, 3, $fY)
    DllStructSetData($g_mMove, 4, 0)  ; Z coordinate (usually 0)

    GwAu3_Core_Enqueue($g_mMovePtr, 16)

    Return True
EndFunc