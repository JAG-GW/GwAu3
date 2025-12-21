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
			Local $aCoords[2] = [26456, -7057]

		Case $GC_I_MAP_ID_THE_WILDS_OUTPOST
			Local $aCoords[2] = [26400, -11328]

		Case $GC_I_MAP_ID_AURORA_GLADE_OUTPOST
			Local $aCoords[2] = [-16444, -2656]

		Case $GC_I_MAP_ID_DIESSA_LOWLANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
					Local $aCoords[2] = [-23344, 18046]
				Case $GC_I_MAP_ID_GRENDICH_COURTHOUSE
					Local $aCoords[2] = [1500, 13846]
				Case $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR
					Local $aCoords[2] = [21236, 17646]
				Case $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST
					Local $aCoords[2] = [-23044, -16954]
				Case $GC_I_MAP_ID_THE_BREACH
					Local $aCoords[2] = [23940, -15154]
			EndSwitch

		Case $GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST
			Local $aCoords[2] = [-4622, 27192]

		Case $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST
			Local $aCoords[2] = [16039, 17824]

		Case $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST
			Local $aCoords[2] = [15424, -10640]

		Case $GC_I_MAP_ID_TALMARK_WILDERNESS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MAJESTYS_REST
					Local $aCoords[2] = [-20339, 3824]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Local $aCoords[2] = [-1995, -19976]
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Local $aCoords[2] = [19752, 2324]
			EndSwitch

		Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Local $aCoords[2] = [-20304, 1824]
				Case $GC_I_MAP_ID_KESSEX_PEAK
					Local $aCoords[2] = [6144, -18076]
				Case $GC_I_MAP_ID_CURSED_LANDS
					Local $aCoords[2] = [20332, 5324]
				Case $GC_I_MAP_ID_TEMPLE_OF_THE_AGES
					Local $aCoords[2] = [-5144, 16324]
			EndSwitch

		Case $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST
			Local $aCoords[2] = [-23158, 7576]

		Case $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Local $aCoords[2] = [-300, 10935]
				Case $GC_I_MAP_ID_WITMANS_FOLLY
					Local $aCoords[2] = [6144, 995]
			EndSwitch

		Case $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST
			Local $aCoords[2] = [6440, 31349]

		Case $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST
			Local $aCoords[2] = [-23285, -5644]

		Case $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST
			Local $aCoords[2] = [-12166, -23419]

		Case $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST
			Local $aCoords[2] = [-7600, -31664]

		Case $GC_I_MAP_ID_BORLIS_PASS_OUTPOST
			Local $aCoords[2] = [26033, -2260]

		Case $GC_I_MAP_ID_TALUS_CHUTE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAMP_RANKOR
					Local $aCoords[2] = [-23040, 16422]
				Case $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
					Local $aCoords[2] = [9118, -16878]
				Case $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST
					Local $aCoords[2] = [23196, -11478]
				Case $GC_I_MAP_ID_ICEDOME
					Local $aCoords[2] = [24080, 16822]
			EndSwitch

		Case $GC_I_MAP_ID_GRIFFONS_MOUTH
			Switch $ToMapID
				Case $GC_I_MAP_ID_SCOUNDRELS_RISE
					Local $aCoords[2] = [-7692, -7788]
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Local $aCoords[2] = [7768, 8012]
			EndSwitch

		Case $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST
			Local $aCoords[2] = [8534, -11088]

		Case $GC_I_MAP_ID_FORT_RANIK_OUTPOST
			Local $aCoords[2] = [7172, -33005]

		Case $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST
			Local $aCoords[2] = [-1166, -13600]

		Case $GC_I_MAP_ID_XAQUANG_SKYWAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $aCoords[2] = [-8201, 16473]
				Case $GC_I_MAP_ID_SENJIS_CORNER
					Local $aCoords[2] = [6395, -13127]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Local $aCoords[2] = [19991, -327]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Local $aCoords[2] = [-16387, 8323]
			EndSwitch

		Case $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST
			Local $aCoords[2] = [-1052, 20279]

		Case $GC_I_MAP_ID_OLD_ASCALON
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_CITY
					Local $aCoords[2] = [18180, 11046]
				Case $GC_I_MAP_ID_REGENT_VALLEY
					Local $aCoords[2] = [10629, -13704]
				Case $GC_I_MAP_ID_SARDELAC_SANITARIUM
					Local $aCoords[2] = [-5303, -4]
				Case $GC_I_MAP_ID_THE_BREACH
					Local $aCoords[2] = [-19636, 20396]
			EndSwitch

		Case $GC_I_MAP_ID_EMBER_LIGHT_CAMP
			Local $aCoords[2] = [3779, -8233]

		Case $GC_I_MAP_ID_GRENDICH_COURTHOUSE
			Local $aCoords[2] = [2304, 13396]

		Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Local $aCoords[2] = [-20775, -403]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $aCoords[2] = [-15184, 2624]
			EndSwitch

		Case $GC_I_MAP_ID_SARDELAC_SANITARIUM
			Local $aCoords[2] = [-4824, -70]

		Case $GC_I_MAP_ID_PIKEN_SQUARE
			Local $aCoords[2] = [20214, 7272]

		Case $GC_I_MAP_ID_SAGE_LANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRUIDS_OVERLOOK
					Local $aCoords[2] = [3336, -9507]
				Case $GC_I_MAP_ID_MAJESTYS_REST
					Local $aCoords[2] = [28828, 11893]
				Case $GC_I_MAP_ID_MAMNOON_LAGOON
					Local $aCoords[2] = [-26388, -4407]
				Case $GC_I_MAP_ID_THE_WILDS_OUTPOST
					Local $aCoords[2] = [-16824, 9893]
			EndSwitch

		Case $GC_I_MAP_ID_MAMNOON_LAGOON
			Switch $ToMapID
				Case $GC_I_MAP_ID_SAGE_LANDS
					Local $aCoords[2] = [7868, 4512]
				Case $GC_I_MAP_ID_SILVERWOOD
					Local $aCoords[2] = [-7355, -5206]
			EndSwitch

		Case $GC_I_MAP_ID_SILVERWOOD
			Switch $ToMapID
				Case $GC_I_MAP_ID_BLOODSTONE_FEN_OUTPOST
					Local $aCoords[2] = [-14060, 17169]
				Case $GC_I_MAP_ID_ETTINS_BACK
					Local $aCoords[2] = [-9530, -20195]
				Case $GC_I_MAP_ID_MAMNOON_LAGOON
					Local $aCoords[2] = [17984, 13297]
				Case $GC_I_MAP_ID_QUARREL_FALLS
					Local $aCoords[2] = [1575, -2652]
			EndSwitch

		Case $GC_I_MAP_ID_ETTINS_BACK
			Switch $ToMapID
				Case $GC_I_MAP_ID_AURORA_GLADE_OUTPOST
					Local $aCoords[2] = [22820, 12907]
				Case $GC_I_MAP_ID_DRY_TOP
					Local $aCoords[2] = [17281, -7221]
				Case $GC_I_MAP_ID_REED_BOG
					Local $aCoords[2] = [-23146, -11382]
				Case $GC_I_MAP_ID_SILVERWOOD
					Local $aCoords[2] = [-14764, 761]
				Case $GC_I_MAP_ID_VENTARIS_REFUGE
					Local $aCoords[2] = [-19082, 14092]
			EndSwitch

		Case $GC_I_MAP_ID_REED_BOG
			Switch $ToMapID
				Case $GC_I_MAP_ID_ETTINS_BACK
					Local $aCoords[2] = [8207, 7080]
				Case $GC_I_MAP_ID_THE_FALLS
					Local $aCoords[2] = [-6480, -8113]
			EndSwitch

		Case $GC_I_MAP_ID_THE_FALLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_REED_BOG
					Local $aCoords[2] = [18182, 4973]
				Case $GC_I_MAP_ID_SECRET_UNDERGROUND_LAIR
					Local $aCoords[2] = [-16044, 2053]
			EndSwitch

		Case $GC_I_MAP_ID_DRY_TOP
			Switch $ToMapID
				Case $GC_I_MAP_ID_ETTINS_BACK
					Local $aCoords[2] = [-8020, 7845]
				Case $GC_I_MAP_ID_TANGLE_ROOT
					Local $aCoords[2] = [5291, -7896]
			EndSwitch

		Case $GC_I_MAP_ID_TANGLE_ROOT
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRY_TOP
					Local $aCoords[2] = [-19568, 5178]
				Case $GC_I_MAP_ID_HENGE_OF_DENRAVI
					Local $aCoords[2] = [12828, 14344]
				Case $GC_I_MAP_ID_MAGUUMA_STADE
					Local $aCoords[2] = [929, -10479]
				Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
					Local $aCoords[2] = [18267, -12079]
			EndSwitch

		Case $GC_I_MAP_ID_HENGE_OF_DENRAVI
			Local $aCoords[2] = [6089, -10936]

		Case $GC_I_MAP_ID_SENJIS_CORNER
			Switch $ToMapID
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
					Local $aCoords[2] = [5893, -12650]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $aCoords[2] = [7399, -18860]
			EndSwitch

		Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
			Switch $ToMapID
				Case $GC_I_MAP_ID_STINGRAY_STRAND
					Local $aCoords[2] = [5727, -6682]
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Local $aCoords[2] = [7784, 8173]
				Case $GC_I_MAP_ID_TWIN_SERPENT_LAKES
					Local $aCoords[2] = [-3169, -8172]
			EndSwitch

		Case $GC_I_MAP_ID_SCOUNDRELS_RISE
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST
					Local $aCoords[2] = [-1051, -7278]
				Case $GC_I_MAP_ID_GRIFFONS_MOUTH
					Local $aCoords[2] = [7663, 8129]
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Local $aCoords[2] = [-7715, 7981]
			EndSwitch

		Case $GC_I_MAP_ID_LIONS_ARCH, $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Local $aCoords[2] = [225, 12401]
				Case $GC_I_MAP_ID_LIONS_GATE
					Local $aCoords[2] = [10295, 1587]
				Case $GC_I_MAP_ID_LIONS_ARCH_KEEP
					Local $aCoords[2] = [7603, 10626]
			EndSwitch

		Case $GC_I_MAP_ID_CURSED_LANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Local $aCoords[2] = [-3651, -11715]
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Local $aCoords[2] = [-20109, -4634]
			EndSwitch

		Case $GC_I_MAP_ID_BERGEN_HOT_SPRINGS
			Local $aCoords[2] = [15430, -14700]

		Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BENEATH_LIONS_ARCH
					Local $aCoords[2] = [8655, -10080]
				Case $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST
					Local $aCoords[2] = [-11612, -19809]
				Case $GC_I_MAP_ID_LIONS_ARCH, $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [6556, -18531]
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Local $aCoords[2] = [-19598, 16046]
				Case $GC_I_MAP_ID_SCOUNDRELS_RISE
					Local $aCoords[2] = [20332, 11431]
			EndSwitch

		Case $GC_I_MAP_ID_NEBO_TERRACE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEETLETUN
					Local $aCoords[2] = [-14809, 19019]
				Case $GC_I_MAP_ID_BERGEN_HOT_SPRINGS
					Local $aCoords[2] = [15542, -15496]
				Case $GC_I_MAP_ID_CURSED_LANDS
					Local $aCoords[2] = [-4368, -11550]
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Local $aCoords[2] = [20433, 3277]
			EndSwitch

		Case $GC_I_MAP_ID_MAJESTYS_REST
			Switch $ToMapID
				Case $GC_I_MAP_ID_SAGE_LANDS
					Local $aCoords[2] = [-23585, -811]
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Local $aCoords[2] = [23501, -5657]
			EndSwitch

		Case $GC_I_MAP_ID_TWIN_SERPENT_LAKES
			Switch $ToMapID
				Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
					Local $aCoords[2] = [-7589, -20171]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Local $aCoords[2] = [6626, 22910]
			EndSwitch

		Case $GC_I_MAP_ID_WATCHTOWER_COAST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEETLETUN
					Local $aCoords[2] = [17404, -10096]
				Case $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST
					Local $aCoords[2] = [-22149, -10486]
			EndSwitch

		Case $GC_I_MAP_ID_STINGRAY_STRAND
			Switch $ToMapID
				Case $GC_I_MAP_ID_FISHERMENS_HAVEN
					Local $aCoords[2] = [2046, 11083]
				Case $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST
					Local $aCoords[2] = [8233, -14689]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Local $aCoords[2] = [-13273, 20876]
			EndSwitch

		Case $GC_I_MAP_ID_KESSEX_PEAK
			Local $aCoords[2] = [9817, 21777]

		Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
			Local $aCoords[2] = [-16203, 14114]

		Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
					Local $aCoords[2] = [5936, 6113]
				Case $GC_I_MAP_ID_FERNDALE
					Local $aCoords[2] = [10928, -1076]
			EndSwitch

		Case $GC_I_MAP_ID_ASCALON_CITY
			Switch $ToMapID
				Case $GC_I_MAP_ID_OLD_ASCALON
					Local $aCoords[2] = [-647, 1821]
				Case $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST
					Local $aCoords[2] = [13118, 13938]
			EndSwitch

		Case $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS, $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS_HALLOWEEN
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST
					Local $aCoords[2] = [-1927, -4521]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $aCoords[2] = [2313, 4518]
			EndSwitch

		Case $GC_I_MAP_ID_ICEDOME
			Switch $ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Local $aCoords[2] = [8838, -5009]
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Local $aCoords[2] = [-7190, -7944]
			EndSwitch

		Case $GC_I_MAP_ID_IRON_HORSE_MINE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ANVIL_ROCK
					Local $aCoords[2] = [-25876, 1666]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Local $aCoords[2] = [26061, -7845]
			EndSwitch

		Case $GC_I_MAP_ID_ANVIL_ROCK
			Switch $ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Local $aCoords[2] = [-17776, -17015]
				Case $GC_I_MAP_ID_ICE_TOOTH_CAVE
					Local $aCoords[2] = [-11677, 11663]
				Case $GC_I_MAP_ID_IRON_HORSE_MINE
					Local $aCoords[2] = [20479, 20548]
				Case $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST
					Local $aCoords[2] = [19148, -18048]
			EndSwitch
		Case $GC_I_MAP_ID_LORNARS_PASS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEACONS_PERCH
					Local $aCoords[2] = [-8531, 33442]
				Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
					Local $aCoords[2] = [-8410, -35267]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $aCoords[2] = [6341, -28768]
			EndSwitch

		Case $GC_I_MAP_ID_SNAKE_DANCE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAMP_RANKOR
					Local $aCoords[2] = [6308, -41462]
				Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
					Local $aCoords[2] = [-7418, 45039]
				Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
					Local $aCoords[2] = [8651, -3634]
			EndSwitch

		Case $GC_I_MAP_ID_TASCAS_DEMISE
			Switch $ToMapID
				Case $GC_I_MAP_ID_MINERAL_SPRINGS
					Local $aCoords[2] = [8318, 29896]
				Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
					Local $aCoords[2] = [-10211, 18666]
			EndSwitch

		Case $GC_I_MAP_ID_SPEARHEAD_PEAK
			Switch $ToMapID
				Case $GC_I_MAP_ID_COPPERHAMMER_MINES
					Local $aCoords[2] = [8147, -26829]
				Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
					Local $aCoords[2] = [-14707, 10]
				Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
					Local $aCoords[2] = [-11495, 15736]
			EndSwitch

		Case $GC_I_MAP_ID_ICE_FLOE
			Switch $ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Local $aCoords[2] = [-11069, 16830]
				Case $GC_I_MAP_ID_MARHANS_GROTTO
					Local $aCoords[2] = [5365, -11965]
				Case $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST
					Local $aCoords[2] = [21820, 13787]
			EndSwitch

		Case $GC_I_MAP_ID_WITMANS_FOLLY
			Switch $ToMapID
				Case $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
					Local $aCoords[2] = [-18878, 7584]
				Case $GC_I_MAP_ID_PORT_SLEDGE
					Local $aCoords[2] = [-7499, -3309]
			EndSwitch

		Case $GC_I_MAP_ID_MINERAL_SPRINGS
			Local $aCoords[2] = [-23063, -10524]

		Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
			Switch $ToMapID
				Case $GC_I_MAP_ID_LORNARS_PASS
					Local $aCoords[2] = [-5518, 8346]
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Local $aCoords[2] = [-7221, -7805]
			EndSwitch

		Case $GC_I_MAP_ID_FROZEN_FOREST
			Switch $ToMapID
				Case $GC_I_MAP_ID_COPPERHAMMER_MINES
					Local $aCoords[2] = [-17881, 9740]
				Case $GC_I_MAP_ID_ICE_FLOE
					Local $aCoords[2] = [23276, -14128]
				Case $GC_I_MAP_ID_ICEDOME
					Local $aCoords[2] = [-24993, -10537]
				Case $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST
					Local $aCoords[2] = [20316, 11192]
			EndSwitch

		Case $GC_I_MAP_ID_TRAVELERS_VALE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
					Local $aCoords[2] = [11345, -17157]
				Case $GC_I_MAP_ID_BORLIS_PASS_OUTPOST
					Local $aCoords[2] = [-11250, -8455]
				Case $GC_I_MAP_ID_IRON_HORSE_MINE
					Local $aCoords[2] = [-11061, 14398]
				Case $GC_I_MAP_ID_YAKS_BEND
					Local $aCoords[2] = [9301, 4246]
			EndSwitch

		Case $GC_I_MAP_ID_DELDRIMOR_BOWL
			Switch $ToMapID
				Case $GC_I_MAP_ID_ANVIL_ROCK
					Local $aCoords[2] = [13526, 26142]
				Case $GC_I_MAP_ID_BEACONS_PERCH
					Local $aCoords[2] = [14135, -23402]
				Case $GC_I_MAP_ID_GRIFFONS_MOUTH
					Local $aCoords[2] = [-13899, -23382]
			EndSwitch

		Case $GC_I_MAP_ID_REGENT_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORT_RANIK_OUTPOST
					Local $aCoords[2] = [22535, 7584]
				Case $GC_I_MAP_ID_OLD_ASCALON
					Local $aCoords[2] = [-17197, 17034]
				Case $GC_I_MAP_ID_POCKMARK_FLATS
					Local $aCoords[2] = [24367, -4312]
			EndSwitch

		Case $GC_I_MAP_ID_THE_BREACH
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Local $aCoords[2] = [-19605, 3206]
				Case $GC_I_MAP_ID_OLD_ASCALON
					Local $aCoords[2] = [1891, -11181]
				Case $GC_I_MAP_ID_PIKEN_SQUARE
					Local $aCoords[2] = [20249, 7869]
			EndSwitch

		Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Local $aCoords[2] = [7402, -7244]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Local $aCoords[2] = [-7734, 7406]
			EndSwitch

		Case $GC_I_MAP_ID_POCKMARK_FLATS
			Switch $ToMapID
				Case $GC_I_MAP_ID_EASTERN_FRONTIER
					Local $aCoords[2] = [9660, 26445]
				Case $GC_I_MAP_ID_REGENT_VALLEY
					Local $aCoords[2] = [-13095, -20202]
				Case $GC_I_MAP_ID_SERENITY_TEMPLE
					Local $aCoords[2] = [-6196, 22720]
			EndSwitch

		Case $GC_I_MAP_ID_DRAGONS_GULLET
			Local $aCoords[2] = [-4819, -1215]

		Case $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Local $aCoords[2] = [-18414, -13661]
				Case $GC_I_MAP_ID_DRAGONS_GULLET
					Local $aCoords[2] = [-4449, -846]
			EndSwitch

		Case $GC_I_MAP_ID_EASTERN_FRONTIER
			Switch $ToMapID
				Case $GC_I_MAP_ID_FRONTIER_GATE
					Local $aCoords[2] = [-14310, 4317]
				Case $GC_I_MAP_ID_POCKMARK_FLATS
					Local $aCoords[2] = [15740, -20305]
				Case $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST
					Local $aCoords[2] = [-20444, 10805]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SCAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_DESTINYS_GORGE
					Local $aCoords[2] = [-13950, 17253]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $aCoords[2] = [-19102, -15635]
				Case $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST
					Local $aCoords[2] = [15898, -23618]
			EndSwitch

		Case $GC_I_MAP_ID_THE_AMNOON_OASIS
			Local $aCoords[2] = [6122, -5425]

		Case $GC_I_MAP_ID_DIVINERS_ASCENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_ELONA_REACH_OUTPOST
					Local $aCoords[2] = [-7940, 3682]
				Case $GC_I_MAP_ID_SALT_FLATS
					Local $aCoords[2] = [-19674, 16216]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $aCoords[2] = [6122, -5425]
			EndSwitch

		Case $GC_I_MAP_ID_VULTURE_DRIFTS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST
					Local $aCoords[2] = [-4570, -12082]
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Local $aCoords[2] = [-7905, 20627]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $aCoords[2] = [19590, 20735]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Local $aCoords[2] = [19704, -17234]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ARID_SEA
			Switch $ToMapID
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Local $aCoords[2] = [-1139, -20132]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $aCoords[2] = [-2177, 20966]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Local $aCoords[2] = [-19754, 6044]
			EndSwitch

		Case $GC_I_MAP_ID_PROPHETS_PATH
			Switch $ToMapID
				Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
					Local $aCoords[2] = [20343, -371]
				Case $GC_I_MAP_ID_HEROES_AUDIENCE
					Local $aCoords[2] = [-15319, -14653]
				Case $GC_I_MAP_ID_SALT_FLATS
					Local $aCoords[2] = [7555, 19856]
				Case $GC_I_MAP_ID_THE_AMNOON_OASIS
					Local $aCoords[2] = [-18916, 19469]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Local $aCoords[2] = [1279, -20012]
			EndSwitch

		Case $GC_I_MAP_ID_SALT_FLATS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DIVINERS_ASCENT
					Local $aCoords[2] = [20895, 16122]
				Case $GC_I_MAP_ID_SEEKERS_PASSAGE
					Local $aCoords[2] = [-16768, 8481]
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Local $aCoords[2] = [-3969, -20194]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $aCoords[2] = [20311, -19727]
			EndSwitch

		Case $GC_I_MAP_ID_SKYWARD_REACH
			Switch $ToMapID
				Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
					Local $aCoords[2] = [-15226, 1880]
				Case $GC_I_MAP_ID_DESTINYS_GORGE
					Local $aCoords[2] = [20047, 19400]
				Case $GC_I_MAP_ID_DIVINERS_ASCENT
					Local $aCoords[2] = [8573, 19329]
				Case $GC_I_MAP_ID_SALT_FLATS
					Local $aCoords[2] = [-7442, 20673]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Local $aCoords[2] = [7135, -19571]
				Case $GC_I_MAP_ID_THE_SCAR
					Local $aCoords[2] = [18335, -18521]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Local $aCoords[2] = [-10510, -20067]
			EndSwitch

		Case $GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_ELONA_REACH_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_PERDITION_ROCK
			Switch $ToMapID
				Case $GC_I_MAP_ID_EMBER_LIGHT_CAMP
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RING_OF_FIRE_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VASBURG_ARMORY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
			Switch $ToMapID
				Case $GC_I_MAP_ID_FERNDALE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VASBURG_ARMORY
			Switch $ToMapID
				Case $GC_I_MAP_ID_MOROSTAV_TRAIL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_SERENITY_TEMPLE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_ICE_TOOTH_CAVE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_BEACONS_PERCH
			Switch $ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LORNARS_PASS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_YAKS_BEND
			Switch $ToMapID
				Case $GC_I_MAP_ID_SHIVERPEAK_ARENA_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_FRONTIER_GATE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_BEETLETUN
			Switch $ToMapID
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WATCHTOWER_COAST
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_FISHERMENS_HAVEN
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_TEMPLE_OF_THE_AGES
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_FISSURE_OF_WOE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VENTARIS_REFUGE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_DRUIDS_OVERLOOK
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_MAGUUMA_STADE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_QUARREL_FALLS
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LEVIATHAN_PITS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RHEAS_CRATER
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_CATACOMBS
			Switch $ToMapID
				Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LAKESIDE_COUNTY
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_CITY_OUTPOST, $GC_I_MAP_ID_ASCALON_CITY_WINTERSDAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_NORTHLANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_NORTHLANDS
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_ASCALON_CITY_OUTPOST, $GC_I_MAP_ID_ASCALON_CITY_WINTERSDAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASCALON_ACADEMY_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HEROES_AUDIENCE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_SEEKERS_PASSAGE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_DESTINYS_GORGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_SCAR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CAMP_RANKOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
			Switch $ToMapID
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TASCAS_DEMISE
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_MARHANS_GROTTO
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_PORT_SLEDGE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_COPPERHAMMER_MINES
			Switch $ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
			Switch $ToMapID
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_THE_BARRADIN_ESTATE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WIZARDS_FOLLY
			Switch $ToMapID
				Case $GC_I_MAP_ID_PRESEARING_FOIBLES_FAIR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_PRESEARING_FORT_RANIK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PRESEARING_THE_BARRADIN_ESTATE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PRESEARING_FOIBLES_FAIR
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_PRESEARING_FORT_RANIK
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_SORROWS_FURNACE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
			Switch $ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_WAR_CAMP
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SORROWS_FURNACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CAVALON
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEJUNKAN_PIER
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RAISU_PAVILLION
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DRAZACH_THICKET
			Switch $ToMapID
				Case $GC_I_MAP_ID_BRAUER_ACADEMY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JAYA_BLUFF
			Switch $ToMapID
				Case $GC_I_MAP_ID_HAIJU_LAGOON
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SHENZUN_TUNNELS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MAATU_KEEP
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ARCHIPELAGOS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BREAKER_HOLLOW
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CAVALON
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JADE_FLATS_LUXON
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MAISHANG_HILLS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAISHANG_HILLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BAI_PAASU_REACH
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_EREDON_TERRACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MOUNT_QINKAI
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASPENWOOD_GATE_LUXON
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BREAKER_HOLLOW
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MELANDRUS_HOPE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BRAUER_ACADEMY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JADE_FLATS_KURZICK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RHEAS_CRATER
			Switch $ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SEAFARERS_REST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SILENT_SURF
			Switch $ToMapID
				Case $GC_I_MAP_ID_LEVIATHAN_PITS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SEAFARERS_REST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_UNWAKING_WATERS_LUXON
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MOROSTAV_TRAIL
			Switch $ToMapID
				Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VASBURG_ARMORY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DELDRIMOR_WAR_CAMP
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_AMATZ_BASIN_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_FERNDALE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PONGMEI_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MAATU_KEEP
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_MONASTERY_OVERLOOK
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_ARBORSTONE_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_RAISU_PALACE_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_UNWAKING_WATERS_LUXON
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_AMATZ_BASIN_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_SHADOWS_PASSAGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RAISU_PALACE_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_PANJIANG_PENINSULA
			Switch $ToMapID
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TSUMEI_VILLAGE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KINYA_PROVINCE
			Switch $ToMapID
				Case $GC_I_MAP_ID_PANJIANG_PENINSULA
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HAIJU_LAGOON
			Switch $ToMapID
				Case $GC_I_MAP_ID_JAYA_BLUFF
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNQUA_VALE
			Switch $ToMapID
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TSUMEI_VILLAGE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WAIJUN_BAZAAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERCITY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BUKDEK_BYWAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHADOWS_PASSAGE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERCITY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_UNDERCITY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
			Switch $ToMapID
				Case $GC_I_MAP_ID_LINNOK_COURTYARD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHING_JEA_ARENA_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ARBORSTONE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GREAT_TEMPLE_OF_BALTHAZAR
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_TSUMEI_VILLAGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_PANJIANG_PENINSULA
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SEITUNG_HARBOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_JAYA_BLUFF
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KAINENG_DOCKS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SAOSHANG_TRAIL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LINNOK_COURTYARD
			Switch $ToMapID
				Case $GC_I_MAP_ID_SAOSHANG_TRAIL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_PONGMEI_VALLEY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZIN_KU_CORRIDOR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_SENJIS_CORNER
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CAVALON
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_HARVEST_TEMPLE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_BREAKER_HOLLOW
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LEVIATHAN_PITS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SILENT_SURF
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAATU_KEEP
			Switch $ToMapID
				Case $GC_I_MAP_ID_PONGMEI_VALLEY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZIN_KU_CORRIDOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_FISSURE_OF_WOE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MONASTERY_OVERLOOK_2
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_BRAUER_ACADEMY
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRAZACH_THICKET
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
			Switch $ToMapID
				Case $GC_I_MAP_ID_MOROSTAV_TRAIL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BAI_PAASU_REACH
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_SEAFARERS_REST
			Switch $ToMapID
				Case $GC_I_MAP_ID_RHEAS_CRATER
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SILENT_SURF
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BEJUNKAN_PIER
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_FORT_ASPENWOOD_LUXON
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_FORT_ASPENWOOD_KURZICK
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_THE_JADE_QUARRY_LUXON
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_THE_JADE_QUARRY_KURZICK
			Local $aCoords[2] = [0, 0]
		Case $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_RAISU_PAVILLION
			Switch $ToMapID
				Case $GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KAINENG_DOCKS
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_MARKETPLACE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KAINENG_DOCKS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SAOSHANG_TRAIL
			Switch $ToMapID
				Case $GC_I_MAP_ID_LINNOK_COURTYARD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JAHAI_BLUFFS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MARGA_COAST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DAJKAH_INLET
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_NUNDU_BAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_YOHLON_HAVEN
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNWARD_MARCHES
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DAJKAH_INLET
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BARBAROUS_SHORE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_CAMP_HOJANU
			Switch $ToMapID
				Case $GC_I_MAP_ID_BARBAROUS_SHORE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BAHDOK_CAVERNS
			Switch $ToMapID
				Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WEHHAN_TERRACES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WEHHAN_TERRACES
			Switch $ToMapID
				Case $GC_I_MAP_ID_BAHDOK_CAVERNS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DEJARIN_ESTATE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAMP_HOJANU
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ARKJOK_WARD
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_YOHLON_HAVEN
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_YOHLON_HAVEN
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
			Switch $ToMapID
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TURAIS_PROCESSION
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_DESOLATION
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
			Switch $ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORT_ASPENWOOD_KURZICK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_FERNDALE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ASPENWOOD_GATE_LUXON
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORT_ASPENWOOD_LUXON
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JADE_FLATS_KURZICK
			Switch $ToMapID
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_JADE_QUARRY_KURZICK
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JADE_FLATS_LUXON
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_JADE_QUARRY_LUXON
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_YATENDI_CANYONS
			Switch $ToMapID
				Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WEHHAN_TERRACES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_ANGUISH
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_FISSURE_OF_WOE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GARDEN_OF_SEBORHIN
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
			Switch $ToMapID
				Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VEHJIN_MINES
			Switch $ToMapID
				Case $GC_I_MAP_ID_BASALT_GROTTO
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JENNURS_HORDE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BASALT_GROTTO
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_FORUM_HIGHLANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GARDEN_OF_SEBORHIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JENNURS_HORDE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_NIGHTFALLEN_GARDEN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOKKA_AMPHITHEATRE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_HONUR_HILL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_YAHNUR_MARKET
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HONUR_HILL
			Switch $ToMapID
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
			Switch $ToMapID
				Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VEHTENDI_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_YAHNUR_MARKET
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_YAHNUR_MARKET
			Switch $ToMapID
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM
			Local $aCoords[2] = [0, 0] ; Exit to Dasha Vestibule (outpost)

		Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LIONS_GATE
			Local $aCoords[2] = [0, 0] ; Exit to Lion's Arch

		Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_HONUR_HILL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST
			Local $aCoords[2] = [0, 0] ; Exit to The Floodplain of Mahnkelon

		Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BAHDOK_CAVERNS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
			Local $aCoords[2] = [0, 0] ; Exit to Forum Highlands

		Case $GC_I_MAP_ID_CONSULATE
			Switch $ToMapID
				Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_PLAINS_OF_JARIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_CAVERNS_BELOW_KAMADAN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CHAMPIONS_DAWN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ASTRALARIUM
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
			Local $aCoords[2] = [0, 0] ; Exit to Plains of Jarin

		Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEKNUR_HARBOR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CHAMPIONS_DAWN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
			Local $aCoords[2] = [0, 0] ; Exit to The Mirror of Lyss

		Case $GC_I_MAP_ID_COMMAND_POST
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JOKOS_DOMAIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_BASALT_GROTTO
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BONE_PALACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BONE_PALACE
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_RUPTURED_HEART
			Switch $ToMapID
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_POISONED_OUTCROPS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_TORMENT
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
			Switch $ToMapID
				Case $GC_I_MAP_ID_POISONED_OUTCROPS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_POISONED_OUTCROPS
			Switch $ToMapID
				Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ALKALI_PAN
			Switch $ToMapID
				Case $GC_I_MAP_ID_BONE_PALACE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_CHUURHIR_FIELDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CONSULATE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUN_DOCKS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNSPEAR_ARENA_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_TORMENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_NIGHTFALLEN_JAHAI
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_SHADOW_NEXUS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_NIGHTFALLEN_GARDEN
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_CHUURHIR_FIELDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BEKNUR_HARBOR
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ISSNUR_ISLES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_HEART_OF_ABADDON
			Local $aCoords[2] = [0, 0] ; Exit to Abaddon's Gate (outpost)

		Case $GC_I_MAP_ID_NIGHTFALLEN_JAHAI
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_TORMENT
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DEPTHS_OF_MADNESS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_FEAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_SECRETS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_FEAR
			Switch $ToMapID
				Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DOMAIN_OF_PAIN
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_PAIN
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_FEAR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_SECRETS
			Switch $ToMapID
				Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GATE_OF_SECRETS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_SECRETS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DOMAIN_OF_SECRETS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_NUNDU_BAY_OUTPOST
			Local $aCoords[2] = [0, 0] ; Exit to Marga Coast

		Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CHAMPIONS_DAWN
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
			Switch $ToMapID
				Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BJORA_MARCHES
			Switch $ToMapID
				Case $GC_I_MAP_ID_DARKRIME_DELVES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JAGA_MORAINE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LONGEYES_LEDGE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ZEHLON_REACH
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_ASTRALARIUM
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LAHTEDA_BOG
			Local $aCoords[2] = [0, 0] ; Exit to Blacktide Den (outpost)

		Case $GC_I_MAP_ID_ARBOR_BAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHARDS_OF_ORR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VLOXS_FALLS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ISSNUR_ISLES
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEKNUR_HARBOR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_KODLONU_HAMLET
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MEHTANI_KEYS
			Local $aCoords[2] = [0, 0] ; Exit to Kodlonu Hamlet

		Case $GC_I_MAP_ID_KODLONU_HAMLET
			Switch $ToMapID
				Case $GC_I_MAP_ID_ISSNUR_ISLES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MEHTANI_KEYS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ISLAND_OF_SHEHKAH
			Local $aCoords[2] = [0, 0] ; Exit to Chahbek Village

		Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LAHTEDA_BOG
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_BEJUNKAN_PIER
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CONSULATE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LIONS_GATE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
			Local $aCoords[2] = [0, 0] ; Exit to Nightfallen Jahai

		Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
			Local $aCoords[2] = [0, 0] ; Exit to Domain of Secrets

		Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_HEART_OF_ABADDON
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DEPTHS_OF_MADNESS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BOREAL_STATION
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_EYE_OF_THE_NORTH, $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST_WINTERSDAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BATTLEDEPTHS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BOKKA_AMPHITHEATRE
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_RIVEN_EARTH
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ARBOR_BAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RATA_SUM
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ASTRALARIUM
			Switch $ToMapID
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THRONE_OF_SECRETS
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_DRAKKAR_LAKE
			Switch $ToMapID
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SEPULCHRE_OF_DRAGRIMMAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SIFHALLA
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SUN_DOCKS
			Local $aCoords[2] = [0, 0] ; Exit to Kamadan, Jewel of Istan

		Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_JAGA_MORAINE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_FROSTMAWS_BURROWS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SIFHALLA
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_NORRHART_DOMAINS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GUNNARS_HOLD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VARAJAR_FELLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_BATTLEDEPTHS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RAVENS_POINT
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_OLAFSTEAD
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VERDANT_CASCADES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
			Switch $ToMapID
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SHADOW_NEXUS_OUTPOST
			Local $aCoords[2] = [0, 0]

		Case $GC_I_MAP_ID_SPARKFLY_SWAMP
			Switch $ToMapID
				Case $GC_I_MAP_ID_GADDS_ENCAMPMENT
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BLOODSTONE_CAVES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_BOGROOT_GROWTHS
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS
			Local $aCoords[2] = [0, 0] ; Exit to Nightfallen Jahai

		Case $GC_I_MAP_ID_VERDANT_CASCADES
			Switch $ToMapID
				Case $GC_I_MAP_ID_SLAVERS_EXILE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_UMBRAL_GROTTO
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_MAGUS_STONES
			Switch $ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ARACHNIS_HAUNT
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_OOLAS_LAB
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RATA_SUM
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_ALCAZIA_TANGLE
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARBOR_BAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_MAGUS_STONES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_TARNISHED_HAVEN
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_VLOXS_FALLS
			Switch $ToMapID
				Case $GC_I_MAP_ID_ARBOR_BAY
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_BATTLEDEPTHS
			Switch $ToMapID
				Case $GC_I_MAP_ID_HEART_OF_THE_SHIVERPEAKS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VARAJAR_FELLS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GADDS_ENCAMPMENT
			Switch $ToMapID
				Case $GC_I_MAP_ID_SPARKFLY_SWAMP
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SHARDS_OF_ORR
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_UMBRAL_GROTTO
			Switch $ToMapID
				Case $GC_I_MAP_ID_VERDANT_CASCADES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_RATA_SUM
			Switch $ToMapID
				Case $GC_I_MAP_ID_MAGUS_STONES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_TARNISHED_HAVEN
			Local $aCoords[2] = [0, 0] ; Exit to Alcazia Tangle

		Case $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST, $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST_WINTERSDAY
			Switch $ToMapID
				Case $GC_I_MAP_ID_HALL_OF_MONUMENTS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SIFHALLA
			Switch $ToMapID
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_JAGA_MORAINE
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GUNNARS_HOLD
			Local $aCoords[2] = [0, 0] ; Exit to Norrhart Domains

		Case $GC_I_MAP_ID_OLAFSTEAD
			Local $aCoords[2] = [0, 0] ; Exit to Varajar Fells

		Case $GC_I_MAP_ID_HALL_OF_MONUMENTS
			Local $aCoords[2] = [0, 0] ;Exit to Eye of the North

		Case $GC_I_MAP_ID_DALADA_UPLANDS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DOOMLORE_SHRINE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SACNOTH_VALLEY
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_DOOMLORE_SHRINE
			Switch $ToMapID
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CATHEDRAL_OF_FLAMES
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
			Switch $ToMapID
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_LONGEYES_LEDGE
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_OOZE_PIT
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_SACNOTH_VALLEY
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_LONGEYES_LEDGE
			Switch $ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Local $aCoords[2] = [0, 0]
			EndSwitch

		Case $GC_I_MAP_ID_SACNOTH_VALLEY
			Switch $ToMapID
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_CATACOMBS_OF_KATHANDRAX
					Local $aCoords[2] = [0, 0]
				Case $GC_I_MAP_ID_RRAGARS_MENAGERIE
					Local $aCoords[2] = [0, 0]
			EndSwitch
		Case $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER
			Local $aCoords[2] = [0, 0] ; Exit to Battledepths

		Case $GC_I_MAP_ID_BOREAL_STATION
			Local $aCoords[2] = [0, 0] ; Exit to Ice Cliff Chasms

		;Case $GC_I_MAP_ID_BENEATH_LIONS_ARCH = 691 ; Special
		;Case $GC_I_MAP_ID_TUNNELS_BELOW_CANTHA = 692 ; Special
		;Case $GC_I_MAP_ID_CAVERNS_BELOW_KAMADAN = 693 ; Special
		;Case $GC_I_MAP_ID_WAR_IN_KRYTA_TALMARK_WILDERNESS = 837 ; War in Kryta
		;Case $GC_I_MAP_ID_TRIAL_OF_ZINN = 838 ; Special
		;Case $GC_I_MAP_ID_DIVINITY_COAST_EXPLORABLE = 839 ; War in Kryta
		Case $GC_I_MAP_ID_LIONS_ARCH_KEEP = 840 ; War in Kryta
			Switch $ToMapID
				Case $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
					Local $aCoords[2] = [0, 0]
			EndSwitch
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

	Return $aCoords
EndFunc   ;==>GetPortalsCoords