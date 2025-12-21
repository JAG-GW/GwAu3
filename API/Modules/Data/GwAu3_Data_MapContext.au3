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

    ; h0034[4] est à offset 0x54
    Local $l_p_SubDeets = Memory_Read($a_p_PropPtr + 0x54, "ptr")
    If $l_p_SubDeets = 0 Then Return 0

    ; sub_deets[1] contient le file hash
    Local $l_p_FileHash = Memory_Read($l_p_SubDeets + 0x4, "ptr")
    If $l_p_FileHash = 0 Then Return 0

    ; Lire les hash values
    Local $l_i_Hash1 = Memory_Read($l_p_FileHash, "word")
    Local $l_i_Hash2 = Memory_Read($l_p_FileHash + 0x2, "word")
    Local $l_i_Hash3 = Memory_Read($l_p_FileHash + 0x4, "word")
    Local $l_i_Hash4 = Memory_Read($l_p_FileHash + 0x6, "word")

    If $l_i_Hash1 > 0xFF And $l_i_Hash2 > 0xFF Then
        If $l_i_Hash3 = 0 Or ($l_i_Hash3 > 0xFF And $l_i_Hash4 = 0) Then
            ; Formule exacte: h1 + h2 * 0xFF00 - 0xFF00FF
            Local $l_i_Result = $l_i_Hash1 + $l_i_Hash2 * 0xFF00 - 0xFF00FF
            Return $l_i_Result
        EndIf
    EndIf

    Return 0
EndFunc

Func Map_GetNearestTravelPortal($a_f_X, $a_f_Y, $a_f_OffsetDistance = 50)
    ; Get all map props
    Local $l_a_Props = Map_GetPropArray()
    If Not IsArray($l_a_Props) Or $l_a_Props[0] = 0 Then Return 0

    Local $l_f_NearestDist = 999999999
    Local $l_a_NearestPortal[6] = [0, 0, 0, 0, 0, 0] ; X, Y, Z, RotationAngle, RotationCos, RotationSin
    Local $l_b_FoundPortal = False
    Local $l_f_PlayerToPortalX = 0, $l_f_PlayerToPortalY = 0

    ; Iterate through all props
    For $i = 1 To $l_a_Props[0]
        Local $l_p_Prop = $l_a_Props[$i]
        If $l_p_Prop = 0 Then ContinueLoop

        ; Check if this prop is a travel portal
        If Not Map_IsTravelPortal($l_p_Prop) Then ContinueLoop

        ; Get portal position (MapProp structure: position is at offset 0x20)
        Local $l_f_PropX = Memory_Read($l_p_Prop + 0x20, "float")
        Local $l_f_PropY = Memory_Read($l_p_Prop + 0x24, "float")
        Local $l_f_PropZ = Memory_Read($l_p_Prop + 0x28, "float")

        ; Calculate distance
        Local $l_f_DX = $l_f_PropX - $a_f_X
        Local $l_f_DY = $l_f_PropY - $a_f_Y
        Local $l_f_Dist = Sqrt($l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY)

        ; Check if this is the nearest portal
        If $l_f_Dist < $l_f_NearestDist Then
            $l_f_NearestDist = $l_f_Dist
            $l_a_NearestPortal[0] = $l_f_PropX
            $l_a_NearestPortal[1] = $l_f_PropY
            $l_a_NearestPortal[2] = $l_f_PropZ
            $l_a_NearestPortal[3] = Memory_Read($l_p_Prop + 0x38, "float") ; rotation_angle
            $l_a_NearestPortal[4] = Memory_Read($l_p_Prop + 0x3C, "float") ; rotation_cos
            $l_a_NearestPortal[5] = Memory_Read($l_p_Prop + 0x40, "float") ; rotation_sin
            $l_f_PlayerToPortalX = $l_f_DX
            $l_f_PlayerToPortalY = $l_f_DY
            $l_b_FoundPortal = True
        EndIf
    Next

    If Not $l_b_FoundPortal Then Return 0

    ; Auto-detect offset direction using dot product
    ; Compare portal facing direction (cos, sin) with player-to-portal direction
    ; Dot product: if positive, portal faces same direction as player approach, go forward
    ; If negative, portal faces toward player, we need to go through (also forward relative to portal)
    Local $l_f_PortalCos = $l_a_NearestPortal[4]
    Local $l_f_PortalSin = $l_a_NearestPortal[5]

    ; Dot product between portal direction and player-to-portal vector
    Local $l_f_DotProduct = $l_f_PortalCos * $l_f_PlayerToPortalX + $l_f_PortalSin * $l_f_PlayerToPortalY

    ; If dot product is positive, portal faces away from player, offset in portal direction
    ; If negative, portal faces toward player, offset in opposite direction (to go through)
    Local $l_f_SignedOffset = $a_f_OffsetDistance
    If $l_f_DotProduct < 0 Then
        $l_f_SignedOffset = -$a_f_OffsetDistance
    EndIf

    ; Calculate target point beyond the portal center
    Local $l_f_TargetX = $l_a_NearestPortal[0] + $l_f_PortalCos * $l_f_SignedOffset
    Local $l_f_TargetY = $l_a_NearestPortal[1] + $l_f_PortalSin * $l_f_SignedOffset

    Local $l_a_Result[4] = [$l_f_TargetX, $l_f_TargetY, $l_a_NearestPortal[2], 0]
    Return $l_a_Result
EndFunc

Func Map_PointInPathingMap($aX, $aY, $aTrapezoidPtr, $aTrapezoidCount)
    For $i = 0 To $aTrapezoidCount - 1
        Local $lTrapPtr = Map_GetTrapezoid($aTrapezoidPtr, $i)

        Local $lYT = Map_GetTrapezoidInfo($lTrapPtr, "YT")
        Local $lYB = Map_GetTrapezoidInfo($lTrapPtr, "YB")

        ; Test rapide sur Y
        If $aY < $lYB Or $aY > $lYT Then ContinueLoop

        Local $lXTL = Map_GetTrapezoidInfo($lTrapPtr, "XTL")
        Local $lXTR = Map_GetTrapezoidInfo($lTrapPtr, "XTR")
        Local $lXBL = Map_GetTrapezoidInfo($lTrapPtr, "XBL")
        Local $lXBR = Map_GetTrapezoidInfo($lTrapPtr, "XBR")

        ; Interpolation pour trouver les bornes X à cette position Y
        Local $lT = 0
        If $lYT <> $lYB Then
            $lT = ($aY - $lYB) / ($lYT - $lYB)
        EndIf

        Local $lXLeft = $lXBL + $lT * ($lXTL - $lXBL)
        Local $lXRight = $lXBR + $lT * ($lXTR - $lXBR)

        If $aX >= $lXLeft And $aX <= $lXRight Then
            Return True
        EndIf
    Next

    Return False
EndFunc

Func Map_IsTravelPortal($a_p_PropPtr)
    If $a_p_PropPtr = 0 Then Return False

    Local $l_i_ModelFileId = Map_GetPropModelFileId($a_p_PropPtr)

    Switch $l_i_ModelFileId
        Case 0x4e6b2, _ ; Eotn asura gate
             0x3c5ac, _ ; Eotn, Nightfall
             0xa825,  _ ; Prophecies, Factions
             0x4e6f2, _
             0xE723,  _
             0x4714e, _
             0x4610A, _
             0x4f2a4, _
             0x4f35a, _
             0x858b
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

Func GetExitPortalsCoords($FromMapID, $ToMapID)
	Switch $FromMapID
		Case $GC_I_MAP_ID_BLOODSTONE_FEN_OUTPOST
			Return [26456, -7057]

		Case $GC_I_MAP_ID_THE_WILDS_OUTPOST
			Return [26400, -11328]

		Case $GC_I_MAP_ID_AURORA_GLADE_OUTPOST
			Return [-16444, -2656]

		Case $GC_I_MAP_ID_DIESSA_LOWLANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
					Return [-23344, 18046]
				Case $GC_I_MAP_ID_GRENDICH_COURTHOUSE
					Return [1500, 13846]
				Case $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR
					Return [21236, 17646]
				Case $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST
					Return [-23044, -16954]
				Case $GC_I_MAP_ID_THE_BREACH
					Return [23940, -15154]
			EndSwitch

		Case $GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST
			Return [-4622, 27192]

		Case $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST
			Return [16039, 17824]

		Case $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST
			Return [15424, -10640]

		Case $GC_I_MAP_ID_TALMARK_WILDERNESS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MAJESTYS_REST
					Return [-20339, 3824]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Return [-1995, -19976]
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Return [19752, 2324]
			EndSwitch

		Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Return [-20304, 1824]
				Case $GC_I_MAP_ID_KESSEX_PEAK
					Return [6144, -18076]
				Case $GC_I_MAP_ID_CURSED_LANDS
					Return [20332, 5324]
				Case $GC_I_MAP_ID_TEMPLE_OF_THE_AGES
					Return [-5144, 16324]
			EndSwitch

		Case $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST
			Return [-23158, 7576]

		Case $GC_I_MAP_ID_DROKNARS_FORGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Return [-300, 10935]
				Case $GC_I_MAP_ID_WITMANS_FOLLY
					Return [6144, 995]
			EndSwitch

		Case $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST
			Return [6440, 31349]

		Case $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST
			Return [-23285, -5644]

		Case $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST
			Return [-12166, -23419]

		Case $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST
			Return [-7600, -31664]

		Case $GC_I_MAP_ID_BORLIS_PASS_OUTPOST
			Return [26033, -2260]

		Case $GC_I_MAP_ID_TALUS_CHUTE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAMP_RANKOR
					Return [-23040, 16422]
				Case $GC_I_MAP_ID_DROKNARS_FORGE
					Return [9118, -16878]
				Case $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST
					Return [23196, -11478]
				Case $GC_I_MAP_ID_ICEDOME
					Return [24080, 16822]
			EndSwitch

		Case $GC_I_MAP_ID_GRIFFONS_MOUTH
			Switch $ToMapID
				Case $GC_I_MAP_ID_SCOUNDRELS_RISE
					Return [-7692, -7788]
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Return [7768, 8012]
			EndSwitch

		Case $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST
			Return [8534, -11088]

		Case $GC_I_MAP_ID_FORT_RANIK_OUTPOST
			Return [7172, -33005]

		Case $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST
			Return [-1166, -13600]

		Case $GC_I_MAP_ID_XAQUANG_SKYWAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Return [-8201, 16473]
				Case $GC_I_MAP_ID_SENJIS_CORNER
					Return [6395, -13127]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Return [19991, -327]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Return [-16387, 8323]
			EndSwitch

		Case $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST
			Return [-1052, 20279]

		Case $GC_I_MAP_ID_OLD_ASCALON
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_CITY
					Return [18180, 11046]
				Case $GC_I_MAP_ID_REGENT_VALLEY
					Return [10629, -13704]
				Case $GC_I_MAP_ID_SARDELAC_SANITARIUM
					Return [-5303, -4]
				Case $GC_I_MAP_ID_THE_BREACH
					Return [-19636, 20396]
			EndSwitch

		Case $GC_I_MAP_ID_EMBER_LIGHT_CAMP
			Return [3779, -8233]

		Case $GC_I_MAP_ID_GRENDICH_COURTHOUSE
			Return [2304, 13396]

		Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Return [-20775, -403]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Return [-15184, 2624]
			EndSwitch

		Case $GC_I_MAP_ID_SARDELAC_SANITARIUM
			Return [-4824, -70]

		Case $GC_I_MAP_ID_PIKEN_SQUARE
			Return [20214, 7272]

		Case $GC_I_MAP_ID_SAGE_LANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRUIDS_OVERLOOK
					Return [0, 0]
				Case $GC_I_MAP_ID_MAJESTYS_REST
					Return [0, 0]
				Case $GC_I_MAP_ID_MAMNOON_LAGOON
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_WILDS_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAMNOON_LAGOON
			Switch $ToMapID
				Case $GC_I_MAP_ID_SAGE_LANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_SILVERWOOD
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SILVERWOOD
			Switch $ToMapID
				Case $GC_I_MAP_ID_BLOODSTONE_FEN_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_ETTINS_BACK
					Return [0, 0]
				Case $GC_I_MAP_ID_MAMNOON_LAGOON
					Return [0, 0]
				Case $GC_I_MAP_ID_QUARREL_FALLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ETTINS_BACK
			Switch $ToMapID
				Case $GC_I_MAP_ID_AURORA_GLADE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_DRY_TOP
					Return [0, 0]
				Case $GC_I_MAP_ID_REED_BOG
					Return [0, 0]
				Case $GC_I_MAP_ID_SILVERWOOD
					Return [0, 0]
				Case $GC_I_MAP_ID_VENTARIS_REFUGE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_REED_BOG
			Switch $ToMapID
				Case $GC_I_MAP_ID_ETTINS_BACK
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_FALLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_FALLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_REED_BOG
					Return [0, 0]
				Case $GC_I_MAP_ID_SECRET_UNDERGROUND_LAIR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DRY_TOP
			Switch $ToMapID
				Case $GC_I_MAP_ID_ETTINS_BACK
					Return [0, 0]
				Case $GC_I_MAP_ID_TANGLE_ROOT
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TANGLE_ROOT
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRY_TOP
					Return [0, 0]
				Case $GC_I_MAP_ID_HENGE_OF_DENRAVI
					Return [0, 0]
				Case $GC_I_MAP_ID_MAGUUMA_STADE
					Return [0, 0]
				Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HENGE_OF_DENRAVI
			Return [0, 0]

		Case $GC_I_MAP_ID_SENJIS_CORNER
			Switch $ToMapID
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
			Switch $ToMapID
				Case $GC_I_MAP_ID_STINGRAY_STRAND
					Return [0, 0]
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Return [0, 0]
				Case $GC_I_MAP_ID_TWIN_SERPENT_LAKES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SCOUNDRELS_RISE
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_GRIFFONS_MOUTH
					Return [0, 0]
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LIONS_ARCH
			Switch $ToMapID
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Return [0, 0]
				Case $GC_I_MAP_ID_LIONS_GATE
					Return [0, 0]
				Case $GC_I_MAP_ID_LIONS_ARCH_KEEP
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CURSED_LANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BERGEN_HOT_SPRINGS
			Return [0, 0]

		Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BENEATH_LIONS_ARCH
					Return [0, 0]
				Case $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_LIONS_ARCH
					Return [0, 0]
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Return [0, 0]
				Case $GC_I_MAP_ID_SCOUNDRELS_RISE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_NEBO_TERRACE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEETLETUN
					Return [0, 0]
				Case $GC_I_MAP_ID_BERGEN_HOT_SPRINGS
					Return [0, 0]
				Case $GC_I_MAP_ID_CURSED_LANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAJESTYS_REST
			Switch $ToMapID
				Case $GC_I_MAP_ID_SAGE_LANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TWIN_SERPENT_LAKES
			Switch $ToMapID
				Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WATCHTOWER_COAST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEETLETUN
					Return [0, 0]
				Case $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_STINGRAY_STRAND
			Switch $ToMapID
				Case $GC_I_MAP_ID_FISHERMENS_HAVEN
					Return [0, 0]
				Case $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KESSEX_PEAK
			Return [0, 0]

		Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_FERNDALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ASCALON_CITY
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_ARENA
					Return [0, 0]
				Case $GC_I_MAP_ID_OLD_ASCALON
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_ICEDOME
			Switch $ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Return [0, 0]
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_IRON_HORSE_MINE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ANVIL_ROCK
					Return [0, 0]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ANVIL_ROCK
			Switch $ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Return [0, 0]
				Case $GC_I_MAP_ID_ICE_TOOTH_CAVE
					Return [0, 0]
				Case $GC_I_MAP_ID_IRON_HORSE_MINE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_LORNARS_PASS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEACONS_PERCH
					Return [0, 0]
				Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SNAKE_DANCE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAMP_RANKOR
					Return [0, 0]
				Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
					Return [0, 0]
				Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TASCAS_DEMISE
			Switch $ToMapID
				Case $GC_I_MAP_ID_MINERAL_SPRINGS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SPEARHEAD_PEAK
			Switch $ToMapID
				Case $GC_I_MAP_ID_COPPERHAMMER_MINES
					Return [0, 0]
				Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ICE_FLOE
			Switch $ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Return [0, 0]
				Case $GC_I_MAP_ID_MARHANS_GROTTO
					Return [0, 0]
				Case $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WITMANS_FOLLY
			Switch $ToMapID
				Case $GC_I_MAP_ID_DROKNARS_FORGE
					Return [0, 0]
				Case $GC_I_MAP_ID_PORT_SLEDGE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MINERAL_SPRINGS
			Return [0, 0]

		Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
			Switch $ToMapID
				Case $GC_I_MAP_ID_LORNARS_PASS
					Return [0, 0]
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_FROZEN_FOREST
			Switch $ToMapID
				Case $GC_I_MAP_ID_COPPERHAMMER_MINES
					Return [0, 0]
				Case $GC_I_MAP_ID_ICE_FLOE
					Return [0, 0]
				Case $GC_I_MAP_ID_ICEDOME
					Return [0, 0]
				Case $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TRAVELERS_VALE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
					Return [0, 0]
				Case $GC_I_MAP_ID_BORLIS_PASS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_IRON_HORSE_MINE
					Return [0, 0]
				Case $GC_I_MAP_ID_YAKS_BEND
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DELDRIMOR_BOWL
			Switch $ToMapID
				Case $GC_I_MAP_ID_ANVIL_ROCK
					Return [0, 0]
				Case $GC_I_MAP_ID_BEACONS_PERCH
					Return [0, 0]
				Case $GC_I_MAP_ID_GRIFFONS_MOUTH
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_REGENT_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORT_RANIK_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_OLD_ASCALON
					Return [0, 0]
				Case $GC_I_MAP_ID_POCKMARK_FLATS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_BREACH
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_OLD_ASCALON
					Return [0, 0]
				Case $GC_I_MAP_ID_PIKEN_SQUARE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_POCKMARK_FLATS
			Switch $ToMapID
				Case $GC_I_MAP_ID_EASTERN_FRONTIER
					Return [0, 0]
				Case $GC_I_MAP_ID_REGENT_VALLEY
					Return [0, 0]
				Case $GC_I_MAP_ID_SERENITY_TEMPLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DRAGONS_GULLET
			Return [0, 0]

		Case $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_DRAGONS_GULLET
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_EASTERN_FRONTIER
			Switch $ToMapID
				Case $GC_I_MAP_ID_FRONTIER_GATE
					Return [0, 0]
				Case $GC_I_MAP_ID_POCKMARK_FLATS
					Return [0, 0]
				Case $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SCAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_DESTINYS_GORGE
					Return [0, 0]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Return [0, 0]
				Case $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_AMNOON_OASIS
			Return [0, 0]

		Case $GC_I_MAP_ID_DIVINERS_ASCENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_ELONA_REACH_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_SALT_FLATS
					Return [0, 0]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VULTURE_DRIFTS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Return [0, 0]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ARID_SEA
			Switch $ToMapID
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Return [0, 0]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Return [0, 0]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PROPHETS_PATH
			Switch $ToMapID
				Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_HEROES_AUDIENCE
					Return [0, 0]
				Case $GC_I_MAP_ID_SALT_FLATS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_AMNOON_OASIS
					Return [0, 0]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SALT_FLATS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIVINERS_ASCENT
					Return [0, 0]
				Case $GC_I_MAP_ID_SEEKERS_PASSAGE
					Return [0, 0]
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Return [0, 0]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SKYWARD_REACH
			Switch $ToMapID
				Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_DESTINYS_GORGE
					Return [0, 0]
				Case $GC_I_MAP_ID_DIVINERS_ASCENT
					Return [0, 0]
				Case $GC_I_MAP_ID_SALT_FLATS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SCAR
					Return [0, 0]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_ELONA_REACH_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_PERDITION_ROCK
			Switch $ToMapID
				Case $GC_I_MAP_ID_EMBER_LIGHT_CAMP
					Return [0, 0]
				Case $GC_I_MAP_ID_RING_OF_FIRE_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
					Return [0, 0]
				Case $GC_I_MAP_ID_VASBURG_ARMORY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
			Switch $ToMapID
				Case $GC_I_MAP_ID_FERNDALE
					Return [0, 0]
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VASBURG_ARMORY
			Switch $ToMapID
				Case $GC_I_MAP_ID_MOROSTAV_TRAIL
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_SERENITY_TEMPLE
			Return [0, 0]

		Case $GC_I_MAP_ID_ICE_TOOTH_CAVE
			Return [0, 0]

		Case $GC_I_MAP_ID_BEACONS_PERCH
			Switch $ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Return [0, 0]
				Case $GC_I_MAP_ID_LORNARS_PASS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_YAKS_BEND
			Switch $ToMapID
				Case $GC_I_MAP_ID_SHIVERPEAK_ARENA_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_FRONTIER_GATE
			Return [0, 0]

		Case $GC_I_MAP_ID_BEETLETUN
			Switch $ToMapID
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Return [0, 0]
				Case $GC_I_MAP_ID_WATCHTOWER_COAST
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_FISHERMENS_HAVEN
			Return [0, 0]

		Case $GC_I_MAP_ID_TEMPLE_OF_THE_AGES
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Return [0, 0]
				Case $GC_I_MAP_ID_FISSURE_OF_WOE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VENTARIS_REFUGE
			Return [0, 0]

		Case $GC_I_MAP_ID_DRUIDS_OVERLOOK
			Return [0, 0]

		Case $GC_I_MAP_ID_MAGUUMA_STADE
			Return [0, 0]

		Case $GC_I_MAP_ID_QUARREL_FALLS
			Return [0, 0]

		Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_LEVIATHAN_PITS
					Return [0, 0]
				Case $GC_I_MAP_ID_RHEAS_CRATER
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_CATACOMBS
			Switch $ToMapID
				Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
					Return [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Return [0, 0]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LAKESIDE_COUNTY
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_CITY_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
					Return [0, 0]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Return [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_NORTHLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_NORTHLANDS
			Return [0, 0]

		Case $GC_I_MAP_ID_ASCALON_CITY_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_ACADEMY_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HEROES_AUDIENCE
			Return [0, 0]

		Case $GC_I_MAP_ID_SEEKERS_PASSAGE
			Return [0, 0]

		Case $GC_I_MAP_ID_DESTINYS_GORGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SCAR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CAMP_RANKOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Return [0, 0]
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
			Switch $ToMapID
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Return [0, 0]
				Case $GC_I_MAP_ID_TASCAS_DEMISE
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_MARHANS_GROTTO
			Return [0, 0]

		Case $GC_I_MAP_ID_PORT_SLEDGE
			Return [0, 0]

		Case $GC_I_MAP_ID_COPPERHAMMER_MINES
			Switch $ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Return [0, 0]
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
			Switch $ToMapID
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Return [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_THE_BARRADIN_ESTATE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Return [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WIZARDS_FOLLY
			Switch $ToMapID
				Case $GC_I_MAP_ID_PRESEARING_FOIBLES_FAIR
					Return [0, 0]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Return [0, 0]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Return [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_PRESEARING_FORT_RANIK
					Return [0, 0]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Return [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PRESEARING_THE_BARRADIN_ESTATE
			Return [0, 0]

		Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PRESEARING_FOIBLES_FAIR
			Return [0, 0]

		Case $GC_I_MAP_ID_PRESEARING_FORT_RANIK
			Return [0, 0]

		Case $GC_I_MAP_ID_SORROWS_FURNACE
			Return [0, 0]

		Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
			Switch $ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_WAR_CAMP
					Return [0, 0]
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Return [0, 0]
				Case $GC_I_MAP_ID_SORROWS_FURNACE
					Return [0, 0]
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CAVALON
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Return [0, 0]
				Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KAINENG_CENTER
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEJUNKAN_PIER
					Return [0, 0]
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Return [0, 0]
				Case $GC_I_MAP_ID_RAISU_PAVILLION
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DRAZACH_THICKET
			Switch $ToMapID
				Case $GC_I_MAP_ID_BRAUER_ACADEMY
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JAYA_BLUFF
			Switch $ToMapID
				Case $GC_I_MAP_ID_HAIJU_LAGOON
					Return [0, 0]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SHENZUN_TUNNELS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MAATU_KEEP
					Return [0, 0]
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ARCHIPELAGOS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BREAKER_HOLLOW
					Return [0, 0]
				Case $GC_I_MAP_ID_CAVALON
					Return [0, 0]
				Case $GC_I_MAP_ID_JADE_FLATS_LUXON
					Return [0, 0]
				Case $GC_I_MAP_ID_MAISHANG_HILLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAISHANG_HILLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Return [0, 0]
				Case $GC_I_MAP_ID_BAI_PAASU_REACH
					Return [0, 0]
				Case $GC_I_MAP_ID_EREDON_TERRACE
					Return [0, 0]
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MOUNT_QINKAI
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASPENWOOD_GATE_LUXON
					Return [0, 0]
				Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_BREAKER_HOLLOW
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MELANDRUS_HOPE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BRAUER_ACADEMY
					Return [0, 0]
				Case $GC_I_MAP_ID_JADE_FLATS_KURZICK
					Return [0, 0]
				Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RHEAS_CRATER
			Switch $ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_SEAFARERS_REST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SILENT_SURF
			Switch $ToMapID
				Case $GC_I_MAP_ID_LEVIATHAN_PITS
					Return [0, 0]
				Case $GC_I_MAP_ID_SEAFARERS_REST
					Return [0, 0]
				Case $GC_I_MAP_ID_UNWAKING_WATERS_LUXON
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MOROSTAV_TRAIL
			Switch $ToMapID
				Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
					Return [0, 0]
				Case $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK
					Return [0, 0]
				Case $GC_I_MAP_ID_VASBURG_ARMORY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DELDRIMOR_WAR_CAMP
			Return [0, 0]

		Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_AMATZ_BASIN_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_FERNDALE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK
					Return [0, 0]
				Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
					Return [0, 0]
				Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
					Return [0, 0]
				Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PONGMEI_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_MAATU_KEEP
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_MONASTERY_OVERLOOK
			Return [0, 0]

		Case $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST
			Return [0, 0]
		Case $GC_I_MAP_ID_ARBORSTONE_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_RAISU_PALACE_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST
			Return [0, 0]
		Case $GC_I_MAP_ID_UNWAKING_WATERS_LUXON
			Return [0, 0]

		Case $GC_I_MAP_ID_AMATZ_BASIN_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_SHADOWS_PASSAGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Return [0, 0]
				Case $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_RAISU_PALACE_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_PANJIANG_PENINSULA
			Switch $ToMapID
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Return [0, 0]
				Case $GC_I_MAP_ID_TSUMEI_VILLAGE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KINYA_PROVINCE
			Switch $ToMapID
				Case $GC_I_MAP_ID_PANJIANG_PENINSULA
					Return [0, 0]
				Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HAIJU_LAGOON
			Switch $ToMapID
				Case $GC_I_MAP_ID_JAYA_BLUFF
					Return [0, 0]
				Case $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNQUA_VALE
			Switch $ToMapID
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Return [0, 0]
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_SHING_JEA_MONASTERY
					Return [0, 0]
				Case $GC_I_MAP_ID_TSUMEI_VILLAGE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WAIJUN_BAZAAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERCITY
					Return [0, 0]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BUKDEK_BYWAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_KAINENG_CENTER
					Return [0, 0]
				Case $GC_I_MAP_ID_SHADOWS_PASSAGE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERCITY
					Return [0, 0]
				Case $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER
					Return [0, 0]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_UNDERCITY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Return [0, 0]
				Case $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER
					Return [0, 0]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_SHING_JEA_MONASTERY
			Switch $ToMapID
				Case $GC_I_MAP_ID_LINNOK_COURTYARD
					Return [0, 0]
				Case $GC_I_MAP_ID_SHING_JEA_ARENA_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_ARBORSTONE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE
			Return [0, 0]

		Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Return [0, 0]
				Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GREAT_TEMPLE_OF_BALTHAZAR
			Return [0, 0]
		Case $GC_I_MAP_ID_TSUMEI_VILLAGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_PANJIANG_PENINSULA
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SEITUNG_HARBOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_JAYA_BLUFF
					Return [0, 0]
				Case $GC_I_MAP_ID_KAINENG_DOCKS
					Return [0, 0]
				Case $GC_I_MAP_ID_SAOSHANG_TRAIL
					Return [0, 0]
				Case $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LINNOK_COURTYARD
			Switch $ToMapID
				Case $GC_I_MAP_ID_SAOSHANG_TRAIL
					Return [0, 0]
				Case $GC_I_MAP_ID_SHING_JEA_MONASTERY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_PONGMEI_VALLEY
					Return [0, 0]
				Case $GC_I_MAP_ID_ZIN_KU_CORRIDOR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_SENJIS_CORNER
					Return [0, 0]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_CAVALON
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_HARVEST_TEMPLE
			Return [0, 0]

		Case $GC_I_MAP_ID_BREAKER_HOLLOW
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Return [0, 0]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LEVIATHAN_PITS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_SILENT_SURF
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAATU_KEEP
			Switch $ToMapID
				Case $GC_I_MAP_ID_PONGMEI_VALLEY
					Return [0, 0]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZIN_KU_CORRIDOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_FISSURE_OF_WOE
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MONASTERY_OVERLOOK_2
			Return [0, 0]

		Case $GC_I_MAP_ID_BRAUER_ACADEMY
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRAZACH_THICKET
					Return [0, 0]
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
			Switch $ToMapID
				Case $GC_I_MAP_ID_MOROSTAV_TRAIL
					Return [0, 0]
				Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BAI_PAASU_REACH
			Return [0, 0]

		Case $GC_I_MAP_ID_SEAFARERS_REST
			Switch $ToMapID
				Case $GC_I_MAP_ID_RHEAS_CRATER
					Return [0, 0]
				Case $GC_I_MAP_ID_SILENT_SURF
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BEJUNKAN_PIER
			Return [0, 0]
		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER
			Return [0, 0]

		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER
			Return [0, 0]

		Case $GC_I_MAP_ID_FORT_ASPENWOOD_LUXON
			Return [0, 0]
		Case $GC_I_MAP_ID_FORT_ASPENWOOD_KURZICK
			Return [0, 0]
		Case $GC_I_MAP_ID_THE_JADE_QUARRY_LUXON
			Return [0, 0]
		Case $GC_I_MAP_ID_THE_JADE_QUARRY_KURZICK
			Return [0, 0]
		Case $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK
			Return [0, 0]

		Case $GC_I_MAP_ID_RAISU_PAVILLION
			Switch $ToMapID
				Case $GC_I_MAP_ID_KAINENG_CENTER
					Return [0, 0]
				Case $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KAINENG_DOCKS
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Return [0, 0]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_MARKETPLACE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Return [0, 0]
				Case $GC_I_MAP_ID_KAINENG_DOCKS
					Return [0, 0]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SAOSHANG_TRAIL
			Switch $ToMapID
				Case $GC_I_MAP_ID_LINNOK_COURTYARD
					Return [0, 0]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JAHAI_BLUFFS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Return [0, 0]
				Case $GC_I_MAP_ID_COMMAND_POST
					Return [0, 0]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Return [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MARGA_COAST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Return [0, 0]
				Case $GC_I_MAP_ID_DAJKAH_INLET
					Return [0, 0]
				Case $GC_I_MAP_ID_NUNDU_BAY
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
					Return [0, 0]
				Case $GC_I_MAP_ID_YOHLON_HAVEN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNWARD_MARCHES
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Return [0, 0]
				Case $GC_I_MAP_ID_DAJKAH_INLET
					Return [0, 0]
				Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BARBAROUS_SHORE
			Return [0, 0]

		Case $GC_I_MAP_ID_CAMP_HOJANU
			Switch $ToMapID
				Case $GC_I_MAP_ID_BARBAROUS_SHORE
					Return [0, 0]
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BAHDOK_CAVERNS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_WEHHAN_TERRACES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WEHHAN_TERRACES
			Switch $ToMapID
				Case $GC_I_MAP_ID_BAHDOK_CAVERNS
					Return [0, 0]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DEJARIN_ESTATE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAMP_HOJANU
					Return [0, 0]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ARKJOK_WARD
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Return [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Return [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Return [0, 0]
				Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_YOHLON_HAVEN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_YOHLON_HAVEN
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Return [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS
			Return [0, 0]

		Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
			Switch $ToMapID
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Return [0, 0]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TURAIS_PROCESSION
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Return [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_DESOLATION
					Return [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Return [0, 0]
				Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Return [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORT_ASPENWOOD_KURZICK
					Return [0, 0]
				Case $GC_I_MAP_ID_FERNDALE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ASPENWOOD_GATE_LUXON
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORT_ASPENWOOD_LUXON
					Return [0, 0]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JADE_FLATS_KURZICK = 390
			Switch $ToMapID
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_JADE_QUARRY_KURZICK
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JADE_FLATS_LUXON = 391
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_JADE_QUARRY_LUXON
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_YATENDI_CANYONS
			Switch $ToMapID
				Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS
					Return [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Return [0, 0]
				Case $GC_I_MAP_ID_WEHHAN_TERRACES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_ANGUISH
					Return [0, 0]
				Case $GC_I_MAP_ID_FISSURE_OF_WOE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Return [0, 0]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GARDEN_OF_SEBORHIN
			Return [0, 0]

		Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
					Return [0, 0]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
			Switch $ToMapID
				Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VEHJIN_MINES
			Switch $ToMapID
				Case $GC_I_MAP_ID_BASALT_GROTTO
					Return [0, 0]
				Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
					Return [0, 0]
				Case $GC_I_MAP_ID_JENNURS_HORDE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BASALT_GROTTO
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Return [0, 0]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_FORUM_HIGHLANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GARDEN_OF_SEBORHIN
					Return [0, 0]
				Case $GC_I_MAP_ID_JENNURS_HORDE
					Return [0, 0]
				Case $GC_I_MAP_ID_NIGHTFALLEN_GARDEN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Return [0, 0]
				Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOKKA_AMPHITHEATRE
					Return [0, 0]
				Case $GC_I_MAP_ID_HONUR_HILL
					Return [0, 0]
				Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
					Return [0, 0]
				Case $GC_I_MAP_ID_YAHNUR_MARKET
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HONUR_HILL
			Switch $ToMapID
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
			Switch $ToMapID
				Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VEHTENDI_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Return [0, 0]
				Case $GC_I_MAP_ID_YAHNUR_MARKET
					Return [0, 0]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_YAHNUR_MARKET
			Switch $ToMapID
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Return [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM
			Return [0, 0] ; Exit to Dasha Vestibule (outpost)

		Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Return [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LIONS_GATE
			Return [0, 0] ; Exit to Lion's Arch

		Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_HONUR_HILL
					Return [0, 0]
				Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST = 421
			Switch $ToMapID
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Return [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Return [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST
			Return [0, 0] ; Exit to The Floodplain of Mahnkelon

		Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Return [0, 0]
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Return [0, 0]
				Case $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BAHDOK_CAVERNS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
			Return [0, 0] ; Exit to Forum Highlands

		Case $GC_I_MAP_ID_CONSULATE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PLAINS_OF_JARIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAVERNS_BELOW_KAMADAN
					Return [0, 0]
				Case $GC_I_MAP_ID_CHAMPIONS_DAWN
					Return [0, 0]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ASTRALARIUM
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
			Return [0, 0] ; Exit to Plains of Jarin

		Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEKNUR_HARBOR
					Return [0, 0]
				Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_CHAMPIONS_DAWN
					Return [0, 0]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Return [0, 0]
				Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
			Return [0, 0] ; Exit to The Mirror of Lyss

		Case $GC_I_MAP_ID_COMMAND_POST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Return [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Return [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JOKOS_DOMAIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_BASALT_GROTTO
					Return [0, 0]
				Case $GC_I_MAP_ID_BONE_PALACE
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Return [0, 0]
				Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BONE_PALACE
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_RUPTURED_HEART
			Switch $ToMapID
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Return [0, 0]
				Case $GC_I_MAP_ID_POISONED_OUTCROPS
					Return [0, 0]
				Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_TORMENT
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Return [0, 0]
				Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
			Switch $ToMapID
				Case $GC_I_MAP_ID_POISONED_OUTCROPS
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_POISONED_OUTCROPS
			Switch $ToMapID
				Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ALKALI_PAN
			Switch $ToMapID
				Case $GC_I_MAP_ID_BONE_PALACE
					Return [0, 0]
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Return [0, 0]
				Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
			Switch $ToMapID
				Case $GC_I_MAP_ID_CHUURHIR_FIELDS
					Return [0, 0]
				Case $GC_I_MAP_ID_CONSULATE
					Return [0, 0]
				Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Return [0, 0]
				Case $GC_I_MAP_ID_SUN_DOCKS
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_ARENA_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_TORMENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_NIGHTFALLEN_JAHAI
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SHADOW_NEXUS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_NIGHTFALLEN_GARDEN = 455 ; Realm of Torment
			Return [0, 0]

		Case $GC_I_MAP_ID_CHUURHIR_FIELDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BEKNUR_HARBOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Return [0, 0]
				Case $GC_I_MAP_ID_ISSNUR_ISLES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HEART_OF_ABADDON
			Return [0, 0] ; Exit to Abaddon's Gate (outpost)

		Case $GC_I_MAP_ID_NIGHTFALLEN_JAHAI
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_TORMENT
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DEPTHS_OF_MADNESS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_FEAR
					Return [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_SECRETS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_FEAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
					Return [0, 0]
				Case $GC_I_MAP_ID_DOMAIN_OF_PAIN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_PAIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_FEAR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_SECRETS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_SECRETS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_SECRETS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
					Return [0, 0]
				Case $GC_I_MAP_ID_DOMAIN_OF_SECRETS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_NUNDU_BAY_OUTPOST
			Return [0, 0] ; Exit to Marga Coast

		Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
					Return [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CHAMPIONS_DAWN
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Return [0, 0]
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BJORA_MARCHES
			Switch $ToMapID
				Case $GC_I_MAP_ID_DARKRIME_DELVES
					Return [0, 0]
				Case $GC_I_MAP_ID_JAGA_MORAINE
					Return [0, 0]
				Case $GC_I_MAP_ID_LONGEYES_LEDGE
					Return [0, 0]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZEHLON_REACH
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Return [0, 0]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_ASTRALARIUM
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LAHTEDA_BOG
			Return [0, 0] ; Exit to Blacktide Den (outpost)

		Case $GC_I_MAP_ID_ARBOR_BAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Return [0, 0]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Return [0, 0]
				Case $GC_I_MAP_ID_SHARDS_OF_ORR
					Return [0, 0]
				Case $GC_I_MAP_ID_VLOXS_FALLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ISSNUR_ISLES
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEKNUR_HARBOR
					Return [0, 0]
				Case $GC_I_MAP_ID_KODLONU_HAMLET
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MEHTANI_KEYS
			Return [0, 0] ; Exit to Kodlonu Hamlet

		Case $GC_I_MAP_ID_KODLONU_HAMLET
			Switch $ToMapID
				Case $GC_I_MAP_ID_ISSNUR_ISLES
					Return [0, 0]
				Case $GC_I_MAP_ID_MEHTANI_KEYS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ISLAND_OF_SHEHKAH
			Return [0, 0] ; Exit to Chahbek Village

		Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Return [0, 0]
				Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
					Return [0, 0]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Return [0, 0]
				Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
					Return [0, 0]
				Case $GC_I_MAP_ID_LAHTEDA_BOG
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEJUNKAN_PIER
					Return [0, 0]
				Case $GC_I_MAP_ID_CONSULATE
					Return [0, 0]
				Case $GC_I_MAP_ID_LIONS_GATE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
			Return [0, 0] ; Exit to Nightfallen Jahai

		Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
			Return [0, 0] ; Exit to Domain of Secrets

		Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_HEART_OF_ABADDON
					Return [0, 0]
				Case $GC_I_MAP_ID_DEPTHS_OF_MADNESS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAL_STATION
					Return [0, 0]
				Case $GC_I_MAP_ID_EYE_OF_THE_NORTH
					Return [0, 0]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Return [0, 0]
				Case $GC_I_MAP_ID_BATTLEDEPTHS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BOKKA_AMPHITHEATRE
			Return [0, 0]

		Case $GC_I_MAP_ID_RIVEN_EARTH
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Return [0, 0]
				Case $GC_I_MAP_ID_ARBOR_BAY
					Return [0, 0]
				Case $GC_I_MAP_ID_RATA_SUM
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ASTRALARIUM
			Switch $ToMapID
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Return [0, 0]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THRONE_OF_SECRETS
			Return [0, 0]

		Case $GC_I_MAP_ID_DRAKKAR_LAKE
			Switch $ToMapID
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Return [0, 0]
				Case $GC_I_MAP_ID_SEPULCHRE_OF_DRAGRIMMAR
					Return [0, 0]
				Case $GC_I_MAP_ID_SIFHALLA
					Return [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUN_DOCKS
			Return [0, 0] ; Exit to Kamadan, Jewel of Istan

		Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Return [0, 0]
				Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JAGA_MORAINE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Return [0, 0]
				Case $GC_I_MAP_ID_FROSTMAWS_BURROWS
					Return [0, 0]
				Case $GC_I_MAP_ID_SIFHALLA
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_NORRHART_DOMAINS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Return [0, 0]
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Return [0, 0]
				Case $GC_I_MAP_ID_GUNNARS_HOLD
					Return [0, 0]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Return [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VARAJAR_FELLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BATTLEDEPTHS
					Return [0, 0]
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Return [0, 0]
				Case $GC_I_MAP_ID_RAVENS_POINT
					Return [0, 0]
				Case $GC_I_MAP_ID_OLAFSTEAD
					Return [0, 0]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Return [0, 0]
				Case $GC_I_MAP_ID_VERDANT_CASCADES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
					Return [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Return [0, 0]
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SHADOW_NEXUS_OUTPOST
			Return [0, 0]

		Case $GC_I_MAP_ID_SPARKFLY_SWAMP
			Switch $ToMapID
				Case $GC_I_MAP_ID_GADDS_ENCAMPMENT
					Return [0, 0]
				Case $GC_I_MAP_ID_BLOODSTONE_CAVES
					Return [0, 0]
				Case $GC_I_MAP_ID_BOGROOT_GROWTHS
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS
			Return [0, 0] ; Exit to Nightfallen Jahai

		Case $GC_I_MAP_ID_VERDANT_CASCADES
			Switch $ToMapID
				Case $GC_I_MAP_ID_SLAVERS_EXILE
					Return [0, 0]
				Case $GC_I_MAP_ID_UMBRAL_GROTTO
					Return [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAGUS_STONES
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Return [0, 0]
				Case $GC_I_MAP_ID_ARACHNIS_HAUNT
					Return [0, 0]
				Case $GC_I_MAP_ID_OOLAS_LAB
					Return [0, 0]
				Case $GC_I_MAP_ID_RATA_SUM
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ALCAZIA_TANGLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARBOR_BAY
					Return [0, 0]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Return [0, 0]
				Case $GC_I_MAP_ID_MAGUS_STONES
					Return [0, 0]
				Case $GC_I_MAP_ID_TARNISHED_HAVEN
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VLOXS_FALLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARBOR_BAY
					Return [0, 0]
				Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BATTLEDEPTHS
			Switch $ToMapID
				Case $GC_I_MAP_ID_HEART_OF_THE_SHIVERPEAKS
					Return [0, 0]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Return [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Return [0, 0]
				Case $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GADDS_ENCAMPMENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_SPARKFLY_SWAMP
					Return [0, 0]
				Case $GC_I_MAP_ID_SHARDS_OF_ORR
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_UMBRAL_GROTTO
			Switch $ToMapID
				Case $GC_I_MAP_ID_VERDANT_CASCADES
					Return [0, 0]
				Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RATA_SUM
			Switch $ToMapID
				Case $GC_I_MAP_ID_MAGUS_STONES
					Return [0, 0]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TARNISHED_HAVEN
			Return [0, 0] ; Exit to Alcazia Tangle

		Case $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_HALL_OF_MONUMENTS
					Return [0, 0]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SIFHALLA
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Return [0, 0]
				Case $GC_I_MAP_ID_JAGA_MORAINE
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GUNNARS_HOLD
			Return [0, 0] ; Exit to Norrhart Domains

		Case $GC_I_MAP_ID_OLAFSTEAD
			Return [0, 0] ; Exit to Varajar Fells

		Case $GC_I_MAP_ID_HALL_OF_MONUMENTS
			Return [0, 0] ;Exit to Eye of the North

		Case $GC_I_MAP_ID_DALADA_UPLANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DOOMLORE_SHRINE
					Return [0, 0]
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Return [0, 0]
				Case $GC_I_MAP_ID_SACNOTH_VALLEY
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_DOOMLORE_SHRINE
			Switch $ToMapID
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_CATHEDRAL_OF_FLAMES
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_LONGEYES_LEDGE
					Return [0, 0]
				Case $GC_I_MAP_ID_OOZE_PIT
					Return [0, 0]
				Case $GC_I_MAP_ID_SACNOTH_VALLEY
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LONGEYES_LEDGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Return [0, 0]
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Return [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SACNOTH_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Return [0, 0]
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Return [0, 0]
				Case $GC_I_MAP_ID_CATACOMBS_OF_KATHANDRAX
					Return [0, 0]
				Case $GC_I_MAP_ID_RRAGARS_MENAGERIE
					Return [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER
			Return [0, 0] ; Exit to Battledepths

		Case $GC_I_MAP_ID_BOREAL_STATION
			Return [0, 0] ; Exit to Ice Cliff Chasms

		;Case $GC_I_MAP_ID_BENEATH_LIONS_ARCH = 691 ; Special
		;Case $GC_I_MAP_ID_TUNNELS_BELOW_CANTHA = 692 ; Special
		;Case $GC_I_MAP_ID_CAVERNS_BELOW_KAMADAN = 693 ; Special
		;Case $GC_I_MAP_ID_WAR_IN_KRYTA_TALMARK_WILDERNESS = 837 ; War in Kryta
		;Case $GC_I_MAP_ID_TRIAL_OF_ZINN = 838 ; Special
		;Case $GC_I_MAP_ID_DIVINITY_COAST_EXPLORABLE = 839 ; War in Kryta
		;Case $GC_I_MAP_ID_LIONS_ARCH_KEEP = 840 ; War in Kryta
		;Case $GC_I_MAP_ID_DALESSIO_SEABOARD_EXPLORABLE = 841 ; War in Kryta
		;Case $GC_I_MAP_ID_THE_BATTLE_FOR_LIONS_ARCH_EXPLORABLE = 842 ; War in Kryta
		;Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_EXPLORABLE = 843 ; War in Kryta
		;Case $GC_I_MAP_ID_WAR_IN_KRYTA_LIONS_ARCH = 844 ; War in Kryta
		;Case $GC_I_MAP_ID_THE_MASOLEUM = 845 ; Special
		;Case $GC_I_MAP_ID_RISE_MAP = 846 ; Special
		;Case $GC_I_MAP_ID_SHADOWS_IN_THE_JUNGLE = 847 ; Winds of Change
		;Case $GC_I_MAP_ID_A_VENGEANCE_OF_BLADES = 848 ; Winds of Change
		;Case $GC_I_MAP_ID_AUSPICIOUS_BEGINNINGS = 849 ; Winds of Change
		;Case $GC_I_MAP_ID_OLFSTEAD_EXPLORABLE = 854 ; Special
		;Case $GC_I_MAP_ID_THE_GREAT_SNOWBALL_FIGHT_CRUSH_SPIRITS = 855 ; Event
		;Case $GC_I_MAP_ID_THE_GREAT_SNOWBALL_FIGHT_WINTER_WONDERLAND = 856 ; Event
		;Case $GC_I_MAP_ID_EMBARK_BEACH = 857 ; Special
		;Case $GC_I_MAP_ID_WHAT_WAITS_IN_SHADOW_DRAGONS_THROAT_EXPLORABLE = 860 ; Winds of Change
		;Case $GC_I_MAP_ID_A_CHANCE_ENCOUNTER_KAINENG_CENTER = 861 ; Winds of Change
		;Case $GC_I_MAP_ID_TRACKING_THE_CORRUPTION_MARKETPLACE_EXPLORABLE = 862 ; Winds of Change
		;Case $GC_I_MAP_ID_CANTHA_COURIER_BUKDEK_BYWAY = 863 ; Winds of Change
		;Case $GC_I_MAP_ID_A_TREATYS_A_TREATY_TSUMEI_VILLAGE = 864 ; Winds of Change
		;Case $GC_I_MAP_ID_DEADLY_CARGO_SEITUNG_HARBOR_EXPLORABLE = 865 ; Winds of Change
		;Case $GC_I_MAP_ID_THE_RESCUE_ATTEMPT_TAHNNAKAI_TEMPLE = 866 ; Winds of Change
		;Case $GC_I_MAP_ID_VILOENCE_IN_THE_STREETS_WAJJUN_BAZAAR = 867 ; Winds of Change
		;Case $GC_I_MAP_ID_SACRED_PSYCHE = 868 ; Winds of Change
		;Case $GC_I_MAP_ID_CALLING_ALL_THUGS_SHADOWS_PASSAGE = 869 ; Winds of Change
		;Case $GC_I_MAP_ID_FINDING_JINNAI_ALTRUMN_RUINS = 870 ; Winds of Change
		;Case $GC_I_MAP_ID_RAID_ON_SHING_JEA_MONASTERY_SHING_JEA_MONASTERY = 871 ; Winds of Change
		;Case $GC_I_MAP_ID_RAID_ON_KAINENG_CENTER_KAINENG_CENTER = 872 ; Winds of Change
		;Case $GC_I_MAP_ID_MINISTRY_OF_OPPRESSION_WAJJUN_BAZAAR = 873 ; Winds of Change
		;Case $GC_I_MAP_ID_THE_FINAL_CONFRONTATION = 874 ; Winds of Change
		;Case $GC_I_MAP_ID_LAKESIDE_COUNTY_1070_AE = 875 ; Pre-Searing
		;Case $GC_I_MAP_ID_ASHFORD_CATACOMBS_1070_AE = 876 ; Pre-Searing

		Case Else
			Out("WARNING: No exit coords defined for: ")
			Out($g_a2D_MapArray[$FromMapID][1] & " to " & $g_a2D_MapArray[$ToMapID][1])
			Return False
	EndSwitch
EndFunc   ;==>GetPortalsCoords