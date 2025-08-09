#include-once

#Region Map Context
Func Map_GetMapContextPtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x14]
    Local $l_ap_MapPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, 'ptr')
    Return $l_ap_MapPtr[1]
EndFunc

Func Map_GetMapContextInfo($a_s_Info = "")
    Local $l_p_Ptr = Map_GetMapContextPtr()
    If $l_p_Ptr = 0 Then
        Log_Error("MapContext is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    If $a_s_Info = "" Then
        Log_Warning("No info requested from MapContext", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_v_Result = 0
    Switch $a_s_Info
        Case "MapBoundaries"
            $l_v_Result = Memory_Read($l_p_Ptr, "float[5]")
        Case "Sub1"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x74, "ptr")
        Case "PropsContext"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x7C, "ptr")
        Case "Terrain"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x84, "ptr")
        Case "Zones"
            $l_v_Result = Memory_Read($l_p_Ptr + 0x130, "ptr")
        Case "Spawns1"
            ; Array at offset 0x2C
            Local $l_a_ArrayInfo[3]
            $l_a_ArrayInfo[0] = Memory_Read($l_p_Ptr + 0x2C, "ptr")     ; buffer
            $l_a_ArrayInfo[1] = Memory_Read($l_p_Ptr + 0x2C + 0x4, "dword") ; capacity
            $l_a_ArrayInfo[2] = Memory_Read($l_p_Ptr + 0x2C + 0x8, "dword") ; size
            $l_v_Result = $l_a_ArrayInfo
        Case "Spawns2"
            ; Array at offset 0x3C
            Local $l_a_ArrayInfo[3]
            $l_a_ArrayInfo[0] = Memory_Read($l_p_Ptr + 0x3C, "ptr")     ; buffer
            $l_a_ArrayInfo[1] = Memory_Read($l_p_Ptr + 0x3C + 0x4, "dword") ; capacity
            $l_a_ArrayInfo[2] = Memory_Read($l_p_Ptr + 0x3C + 0x8, "dword") ; size
            $l_v_Result = $l_a_ArrayInfo
        Case "Spawns3"
            ; Array at offset 0x4C
            Local $l_a_ArrayInfo[3]
            $l_a_ArrayInfo[0] = Memory_Read($l_p_Ptr + 0x4C, "ptr")     ; buffer
            $l_a_ArrayInfo[1] = Memory_Read($l_p_Ptr + 0x4C + 0x4, "dword") ; capacity
            $l_a_ArrayInfo[2] = Memory_Read($l_p_Ptr + 0x4C + 0x8, "dword") ; size
            $l_v_Result = $l_a_ArrayInfo
    EndSwitch

    Return $l_v_Result
EndFunc

Func Map_GetPathingMapArray()
    Local $l_p_Sub1 = Map_GetMapContextInfo("Sub1")
    If $l_p_Sub1 = 0 Then
        Log_Error("Sub1 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    ; Sub2 pointer is at offset 0x0 in Sub1
    Local $l_p_Sub2 = Memory_Read($l_p_Sub1, "ptr")
    If $l_p_Sub2 = 0 Then
        Log_Error("Sub2 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    ; PathingMapArray (pmaps) is at offset 0x18 in Sub2
    Local $l_p_ArrayStruct = $l_p_Sub2 + 0x18
    Return $l_p_ArrayStruct
EndFunc

Func Map_GetPathingMapArrayInfo($a_s_Info = "")
    Local $l_p_ArrayStruct = Map_GetPathingMapArray()
    If $l_p_ArrayStruct = 0 Then Return 0

    Switch $a_s_Info
        Case "Buffer"
            Return Memory_Read($l_p_ArrayStruct, "ptr")
        Case "Size"
            Return Memory_Read($l_p_ArrayStruct + 0x8, "dword")
        Case "Capacity"
            Return Memory_Read($l_p_ArrayStruct + 0x4, "dword")
    EndSwitch
    Return 0
EndFunc

Func Map_GetTotalTrapezoidCount()
    Local $l_p_Sub1 = Map_GetMapContextInfo("Sub1")
    If $l_p_Sub1 = 0 Then
        Log_Error("Sub1 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    ; Total trapezoid count at offset 0x18 in Sub1
    Local $l_i_Count = Memory_Read($l_p_Sub1 + 0x18, "dword")
    Log_Info("Total trapezoid count: " & $l_i_Count, "PathFinding", $g_h_EditText)
    Return $l_i_Count
EndFunc

Func Map_GetPathingMapBlockArray()
    Local $l_p_Sub1 = Map_GetMapContextInfo("Sub1")
    If $l_p_Sub1 = 0 Then
        Log_Error("Sub1 is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    ; Array at sub1 + 0x04 (pathing_map_block)
    Local $l_p_ArrayPtr = Memory_Read($l_p_Sub1 + 0x04, "ptr")
    Local $l_i_ArraySize = Memory_Read($l_p_Sub1 + 0x0C, "dword")

    If $l_p_ArrayPtr = 0 Or $l_i_ArraySize = 0 Then
        Log_Warning("Block array is empty", "PathFinding", $g_h_EditText)
        ; Return empty array instead of 0
        Local $l_a_EmptyResult[1] = [0]
        Return $l_a_EmptyResult
    EndIf

    Local $l_a_Result[$l_i_ArraySize + 1]
    $l_a_Result[0] = $l_i_ArraySize

    For $i = 0 To $l_i_ArraySize - 1
        $l_a_Result[$i + 1] = Memory_Read($l_p_ArrayPtr + ($i * 4), "dword")
    Next

    Log_Info("Loaded " & $l_i_ArraySize & " block entries", "PathFinding", $g_h_EditText)
    Return $l_a_Result
EndFunc

; ===============================================================
; Props Context Functions
; ===============================================================
Func Map_GetPropsContext()
    Local $l_p_MapContext = Map_GetMapContextPtr()
    If $l_p_MapContext = 0 Then Return 0

    Return Memory_Read($l_p_MapContext + 0x7C, "ptr")
EndFunc

Func Map_GetPropArray()
    Local $l_p_PropsContext = Map_GetPropsContext()
    If $l_p_PropsContext = 0 Then Return 0

    ; PropArray is at offset 0x194 in PropsContext
    Local $l_p_ArrayPtr = Memory_Read($l_p_PropsContext + 0x194, "ptr")
    Local $l_i_ArraySize = Memory_Read($l_p_PropsContext + 0x194 + 0x8, "dword")

    If $l_p_ArrayPtr = 0 Or $l_i_ArraySize = 0 Then
        Local $l_a_EmptyResult[1] = [0]
        Return $l_a_EmptyResult
    EndIf

    Local $l_a_Result[$l_i_ArraySize + 1]
    $l_a_Result[0] = $l_i_ArraySize

    For $i = 0 To $l_i_ArraySize - 1
        $l_a_Result[$i + 1] = Memory_Read($l_p_ArrayPtr + ($i * 4), "ptr")
    Next

    Log_Info("Loaded " & $l_i_ArraySize & " map props", "PathFinding", $g_h_EditText)
    Return $l_a_Result
EndFunc

Func Map_GetPropsByType()
    Local $l_p_PropsContext = Map_GetPropsContext()
    If $l_p_PropsContext = 0 Then Return 0

    ; PropsByType array is at offset 0x6C in PropsContext
    Local $l_p_ArrayPtr = Memory_Read($l_p_PropsContext + 0x6C, "ptr")
    Local $l_i_ArraySize = Memory_Read($l_p_PropsContext + 0x6C + 0x8, "dword")

    If $l_p_ArrayPtr = 0 Or $l_i_ArraySize = 0 Then
        Local $l_a_EmptyResult[1] = [0]
        Return $l_a_EmptyResult
    EndIf

    Local $l_a_Result[$l_i_ArraySize + 1]
    $l_a_Result[0] = $l_i_ArraySize

    For $i = 0 To $l_i_ArraySize - 1
        $l_a_Result[$i + 1] = Memory_Read($l_p_ArrayPtr + ($i * 4), "ptr")
    Next

    Return $l_a_Result
EndFunc

Func Map_GetPropModels()
    Local $l_p_PropsContext = Map_GetPropsContext()
    If $l_p_PropsContext = 0 Then Return 0

    ; PropModels array is at offset 0xA4 in PropsContext
    Local $l_p_ArrayPtr = Memory_Read($l_p_PropsContext + 0xA4, "ptr")
    Local $l_i_ArraySize = Memory_Read($l_p_PropsContext + 0xA4 + 0x8, "dword")

    If $l_p_ArrayPtr = 0 Or $l_i_ArraySize = 0 Then
        Local $l_a_EmptyResult[1] = [0]
        Return $l_a_EmptyResult
    EndIf

    Local $l_a_Result[$l_i_ArraySize + 1]
    $l_a_Result[0] = $l_i_ArraySize

    For $i = 0 To $l_i_ArraySize - 1
        ; PropModelInfo structures - store the pointer for now
        $l_a_Result[$i + 1] = $l_p_ArrayPtr + ($i * 0x20) ; Estimate structure size
    Next

    Return $l_a_Result
EndFunc

; ===============================================================
; Map Property Functions
; ===============================================================
Func Map_GetPropInfo($a_p_PropPtr, $a_s_Info = "")
    If $a_p_PropPtr = 0 Or $a_s_Info = "" Then Return 0

    ; MapProp structure access - based on common prop structures
    Local $l_v_Result = 0
    Switch $a_s_Info
        Case "X"
            $l_v_Result = Memory_Read($a_p_PropPtr + 0x0, "float")
        Case "Y"
            $l_v_Result = Memory_Read($a_p_PropPtr + 0x4, "float")
        Case "Z"
            $l_v_Result = Memory_Read($a_p_PropPtr + 0x8, "float")
        Case "PropType"
            $l_v_Result = Memory_Read($a_p_PropPtr + 0x10, "dword")
        Case "ModelInfo"
            $l_v_Result = Memory_Read($a_p_PropPtr + 0x34, "ptr")
        Case "h0034"
            ; Array of pointers at offset 0x34
            Local $l_a_Array[5]
            For $i = 0 To 4
                $l_a_Array[$i] = Memory_Read($a_p_PropPtr + 0x34 + ($i * 4), "ptr")
            Next
            $l_v_Result = $l_a_Array
    EndSwitch

    Return $l_v_Result
EndFunc

Func Map_GetPropModelFileId($a_p_PropPtr)
    If $a_p_PropPtr = 0 Then Return 0

    ; Get h0034[4] pointer
    Local $l_p_ModelInfo = Memory_Read($a_p_PropPtr + 0x34 + (4 * 4), "ptr")
    If $l_p_ModelInfo = 0 Then Return 0

    ; Get sub_deets[1] which should contain the file hash
    Local $l_p_FileHash = Memory_Read($l_p_ModelInfo + 0x4, "ptr")
    If $l_p_FileHash = 0 Then Return 0

    ; Convert file hash to file ID (implementation of FileHashToFileId)
    Local $l_s_Hash1 = Memory_Read($l_p_FileHash, "wchar")
    Local $l_s_Hash2 = Memory_Read($l_p_FileHash + 0x2, "wchar")
    Local $l_s_Hash3 = Memory_Read($l_p_FileHash + 0x4, "wchar")
    Local $l_s_Hash4 = Memory_Read($l_p_FileHash + 0x6, "wchar")

    If $l_s_Hash1 > 0xFF And $l_s_Hash2 > 0xFF And ($l_s_Hash3 = 0 Or ($l_s_Hash3 > 0xFF And $l_s_Hash4 = 0)) Then
        Return ($l_s_Hash1 - 0xFF00FF) + $l_s_Hash2 * 0xFF00
    EndIf

    Return 0
EndFunc

Func Map_IsTravelPortal($a_p_PropPtr)
    If $a_p_PropPtr = 0 Then Return False

    Local $l_i_ModelFileId = Map_GetPropModelFileId($a_p_PropPtr)

    Switch $l_i_ModelFileId
        Case 0x4e6b2 ; Eotn asura gate
            Return True
        Case 0x3c5ac ; Eotn, Nightfall
            Return True
        Case 0xa825  ; Prophecies, Factions
            Return True
        Case Else
            Return False
    EndSwitch
EndFunc

Func Map_IsTeleporter($a_p_PropPtr)
    If $a_p_PropPtr = 0 Then Return False

    Local $l_i_ModelFileId = Map_GetPropModelFileId($a_p_PropPtr)

    Switch $l_i_ModelFileId
        Case 0xefd0  ; Crystal desert
            Return True
        Case Else
            Return False
    EndSwitch
EndFunc

; ===============================================================
; Spawn Points Functions
; ===============================================================
Func Map_GetSpawnPoints($a_i_SpawnType = 1)
    ; SpawnType: 1 = Spawns1, 2 = Spawns2, 3 = Spawns3
    Local $l_s_SpawnName = "Spawns" & $a_i_SpawnType
    Local $l_a_SpawnArray = Map_GetMapContextInfo($l_s_SpawnName)

    If Not IsArray($l_a_SpawnArray) Then
        Local $l_a_EmptyResult[1] = [0]
        Return $l_a_EmptyResult
    EndIf

    Local $l_p_ArrayPtr = $l_a_SpawnArray[0]
    Local $l_i_ArraySize = $l_a_SpawnArray[2]

    If $l_p_ArrayPtr = 0 Or $l_i_ArraySize = 0 Then
        Local $l_a_EmptyResult[1] = [0]
        Return $l_a_EmptyResult
    EndIf

    Local $l_a_Result[$l_i_ArraySize + 1]
    $l_a_Result[0] = $l_i_ArraySize

    ; Each spawn point seems to be: X, Y, unk1, unk2 (4 dwords = 16 bytes)
    For $i = 0 To $l_i_ArraySize - 1
        Local $l_p_SpawnPtr = $l_p_ArrayPtr + ($i * 16)
        Local $l_a_SpawnData[4]
        $l_a_SpawnData[0] = Memory_Read($l_p_SpawnPtr + 0x0, "float")  ; X
        $l_a_SpawnData[1] = Memory_Read($l_p_SpawnPtr + 0x4, "float")  ; Y
        $l_a_SpawnData[2] = Memory_Read($l_p_SpawnPtr + 0x8, "dword")  ; unk1
        $l_a_SpawnData[3] = Memory_Read($l_p_SpawnPtr + 0xC, "dword")  ; unk2

        $l_a_Result[$i + 1] = $l_a_SpawnData
    Next

    Return $l_a_Result
EndFunc
#EndRegion Map Context

#Region Pathing Structures
Func Map_GetPathingMap($a_i_Index)
    Local $l_p_Array = Map_GetPathingMapArray()
    If $l_p_Array = 0 Then
        Log_Error("PathingMapArray is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_p_ArraySize = Memory_Read($l_p_Array + 0x8, "dword")
    If $a_i_Index >= $l_p_ArraySize Then
        Log_Error("Index " & $a_i_Index & " out of bounds (size: " & $l_p_ArraySize & ")", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_p_ArrayPtr = Memory_Read($l_p_Array, "ptr")
    Local $l_p_Result = $l_p_ArrayPtr + ($a_i_Index * 0x54) ; sizeof(PathingMap) = 84

    Return $l_p_Result
EndFunc

Func Map_GetPathingMapInfo($a_i_Index, $a_s_Info = "")
    Local $l_p_PathingMap = Map_GetPathingMap($a_i_Index)
    If $l_p_PathingMap = 0 Then Return 0

    If $a_s_Info = "" Then
        Log_Warning("No info requested from PathingMap", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    Local $l_v_Result = 0
    Switch $a_s_Info
        Case "ZPlane"
            $l_v_Result = Memory_Read($l_p_PathingMap, "dword")
        Case "TrapezoidCount"
            $l_v_Result = Memory_Read($l_p_PathingMap + 0x14, "dword")
        Case "Trapezoids"
            $l_v_Result = Memory_Read($l_p_PathingMap + 0x18, "ptr")
        Case "RootNode"
            $l_v_Result = Memory_Read($l_p_PathingMap + 0x44, "ptr")
    EndSwitch

    Return $l_v_Result
EndFunc

Func Map_GetTrapezoid($a_p_TrapezoidsPtr, $a_i_Index)
    Local $l_p_Result = $a_p_TrapezoidsPtr + ($a_i_Index * 0x30) ; sizeof(PathingTrapezoid) = 48
    Return $l_p_Result
EndFunc

Func Map_GetTrapezoidInfo($a_p_TrapezoidPtr, $a_s_Info = "")
    If $a_p_TrapezoidPtr = 0 Then
        Log_Error("TrapezoidPtr is null", "PathFinding", $g_h_EditText)
        Return 0
    EndIf

    If $a_s_Info = "" Then Return 0

    Local $l_v_Result = 0
    Switch $a_s_Info
        Case "ID"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr, "dword")
        Case "XTL"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x18, "float")
        Case "XTR"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x1C, "float")
        Case "YT"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x20, "float")
        Case "XBL"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x24, "float")
        Case "XBR"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x28, "float")
        Case "YB"
            $l_v_Result = Memory_Read($a_p_TrapezoidPtr + 0x2C, "float")
    EndSwitch

    Return $l_v_Result
EndFunc
#EndRegion Pathing Structures