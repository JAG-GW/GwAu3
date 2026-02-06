#include-once

Func Camera_GetCameraInfo($a_s_Info = "")
    If $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "X"
            Return Memory_Read($g_p_SceneContext + 0x2C, "float")
        Case "Y"
            Return Memory_Read($g_p_SceneContext + 0x30, "float")
        Case "Z"
            Return Memory_Read($g_p_SceneContext + 0x34, "float")
        Case "XYZ", "All"
            Local $l_d_Struct_Item = DllStructCreate( _
                "float cameraX;" & _
                "float cameraY;" & _
                "float cameraZ;" _
            )
            Local $l_i_StructSize_Item = DllStructGetSize($l_d_Struct_Item)

            Local $l_p_CameraX = $g_p_SceneContext + 0x2C
            Local $l_av_Call = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
                "handle", $g_h_GWProcess, _
                "ptr", $l_p_CameraX, _
                "struct*", $l_d_Struct_Item, _
                "ulong_ptr", $l_i_StructSize_Item, _
                "ulong_ptr*", 0 _
            )
            If @error Or Not $l_av_Call[0] Then Return 0

            Local $l_af_XYZ[3]
            $l_af_XYZ[0] = DllStructGetData($l_d_Struct_Item, "cameraX")
            $l_af_XYZ[1] = DllStructGetData($l_d_Struct_Item, "cameraY")
            $l_af_XYZ[2] = DllStructGetData($l_d_Struct_Item, "cameraZ")
            Return $l_af_XYZ
    EndSwitch

    Return 0
EndFunc