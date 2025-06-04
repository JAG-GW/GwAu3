#include-once

Func _MapMod_Move($fX, $fY, $fRandomize = 50)
    If Not $g_bMapModuleInitialized Then
        _Log_Error("MapMod module not initialized", "MapMod", $GUIEdit)
        Return False
    EndIf

    ; Add randomization if requested
    If $fRandomize > 0 Then
        $fX += Random(-$fRandomize, $fRandomize)
        $fY += Random(-$fRandomize, $fRandomize)
    EndIf

    ; Store last move coordinates
    $g_fLastMoveX = $fX
    $g_fLastMoveY = $fY

    ; Set move data
	DllStructSetData($g_mMove, 1, GetValue('CommandMove'))
    DllStructSetData($g_mMove, 2, $fX)
    DllStructSetData($g_mMove, 3, $fY)
    DllStructSetData($g_mMove, 4, 0)  ; Z coordinate (usually 0)

    Enqueue($g_mMovePtr, 16)

    Return True
EndFunc