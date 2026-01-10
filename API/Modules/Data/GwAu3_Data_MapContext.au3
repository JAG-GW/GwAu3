#include-once

#Region Map Context
Func Map_GetMapContextPtr()
	Local $l_ai_Offset[3] = [0, 0x18, 0x14]
	Local $l_ap_MapPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, 'ptr')
	Return $l_ap_MapPtr[1]
EndFunc   ;==>Map_GetMapContextPtr

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
			$l_a_ArrayInfo[0] = Memory_Read($l_p_Ptr + 0x2C, "ptr")                 ; buffer
			$l_a_ArrayInfo[1] = Memory_Read($l_p_Ptr + 0x2C + 0x4, "dword")             ; capacity
			$l_a_ArrayInfo[2] = Memory_Read($l_p_Ptr + 0x2C + 0x8, "dword")             ; size
			$l_v_Result = $l_a_ArrayInfo
		Case "Spawns2"
			; Array at offset 0x3C
			Local $l_a_ArrayInfo[3]
			$l_a_ArrayInfo[0] = Memory_Read($l_p_Ptr + 0x3C, "ptr")                 ; buffer
			$l_a_ArrayInfo[1] = Memory_Read($l_p_Ptr + 0x3C + 0x4, "dword")             ; capacity
			$l_a_ArrayInfo[2] = Memory_Read($l_p_Ptr + 0x3C + 0x8, "dword")             ; size
			$l_v_Result = $l_a_ArrayInfo
		Case "Spawns3"
			; Array at offset 0x4C
			Local $l_a_ArrayInfo[3]
			$l_a_ArrayInfo[0] = Memory_Read($l_p_Ptr + 0x4C, "ptr")                 ; buffer
			$l_a_ArrayInfo[1] = Memory_Read($l_p_Ptr + 0x4C + 0x4, "dword")             ; capacity
			$l_a_ArrayInfo[2] = Memory_Read($l_p_Ptr + 0x4C + 0x8, "dword")             ; size
			$l_v_Result = $l_a_ArrayInfo
	EndSwitch

	Return $l_v_Result
EndFunc   ;==>Map_GetMapContextInfo

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
EndFunc   ;==>Map_GetPathingMapArray

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
EndFunc   ;==>Map_GetPathingMapArrayInfo

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
EndFunc   ;==>Map_GetTotalTrapezoidCount

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
EndFunc   ;==>Map_GetPathingMapBlockArray

; ===============================================================
; Props Context Functions
; ===============================================================
Func Map_GetPropsContext()
	Local $l_p_MapContext = Map_GetMapContextPtr()
	If $l_p_MapContext = 0 Then Return 0

	Return Memory_Read($l_p_MapContext + 0x7C, "ptr")
EndFunc   ;==>Map_GetPropsContext

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
EndFunc   ;==>Map_GetPropArray

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
EndFunc   ;==>Map_GetPropsByType

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
		$l_a_Result[$i + 1] = $l_p_ArrayPtr + ($i * 0x20)         ; Estimate structure size
	Next

	Return $l_a_Result
EndFunc   ;==>Map_GetPropModels

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
EndFunc   ;==>Map_GetPropInfo

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
EndFunc   ;==>Map_GetPropModelFileId

Func Map_GetNearestTravelPortal($a_f_X, $a_f_Y, $a_f_OffsetDistance = 50)
	; Get all map props
	Local $l_a_Props = Map_GetPropArray()
	If Not IsArray($l_a_Props) Or $l_a_Props[0] = 0 Then Return 0

	Local $l_f_NearestDist = 999999999
	Local $l_a_NearestPortal[6] = [0, 0, 0, 0, 0, 0]     ; X, Y, Z, RotationAngle, RotationCos, RotationSin
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
			$l_a_NearestPortal[3] = Memory_Read($l_p_Prop + 0x38, "float")             ; rotation_angle
			$l_a_NearestPortal[4] = Memory_Read($l_p_Prop + 0x3C, "float")             ; rotation_cos
			$l_a_NearestPortal[5] = Memory_Read($l_p_Prop + 0x40, "float")             ; rotation_sin
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
EndFunc   ;==>Map_GetNearestTravelPortal

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
EndFunc   ;==>Map_PointInPathingMap

Func Map_IsTravelPortal($a_p_PropPtr)
	If $a_p_PropPtr = 0 Then Return False

	Local $l_i_ModelFileId = Map_GetPropModelFileId($a_p_PropPtr)

	Switch $l_i_ModelFileId
		Case 0x4e6b2, _         ; Eotn asura gate
				0x3c5ac, _              ; Eotn, Nightfall
				0xa825, _               ; Prophecies, Factions
				0x4e6f2, _
				0xE723, _
				0x4714e, _
				0x4610A, _
				0x4f2a4, _
				0x4f35a, _
				0x858b
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>Map_IsTravelPortal

Func Map_IsTeleporter($a_p_PropPtr)
	If $a_p_PropPtr = 0 Then Return False

	Local $l_i_ModelFileId = Map_GetPropModelFileId($a_p_PropPtr)

	Switch $l_i_ModelFileId
		Case 0xefd0          ; Crystal desert
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>Map_IsTeleporter

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
		$l_a_SpawnData[0] = Memory_Read($l_p_SpawnPtr + 0x0, "float")          ; X
		$l_a_SpawnData[1] = Memory_Read($l_p_SpawnPtr + 0x4, "float")          ; Y
		$l_a_SpawnData[2] = Memory_Read($l_p_SpawnPtr + 0x8, "dword")          ; unk1
		$l_a_SpawnData[3] = Memory_Read($l_p_SpawnPtr + 0xC, "dword")          ; unk2

		$l_a_Result[$i + 1] = $l_a_SpawnData
	Next

	Return $l_a_Result
EndFunc   ;==>Map_GetSpawnPoints
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
	Local $l_p_Result = $l_p_ArrayPtr + ($a_i_Index * 0x54)     ; sizeof(PathingMap) = 84

	Return $l_p_Result
EndFunc   ;==>Map_GetPathingMap

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
EndFunc   ;==>Map_GetPathingMapInfo

Func Map_GetTrapezoid($a_p_TrapezoidsPtr, $a_i_Index)
	Local $l_p_Result = $a_p_TrapezoidsPtr + ($a_i_Index * 0x30)     ; sizeof(PathingTrapezoid) = 48
	Return $l_p_Result
EndFunc   ;==>Map_GetTrapezoid

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
EndFunc   ;==>Map_GetTrapezoidInfo
#EndRegion Pathing Structures

Func Map_GetExitPortalsCoords($a_i_FromMapID, $a_i_ToMapID)
	Switch $a_i_FromMapID
		Case $GC_I_MAP_ID_BLOODSTONE_FEN_OUTPOST
			Local $l_ai_Coords[2] = [26456, -7057]

		Case $GC_I_MAP_ID_THE_WILDS_OUTPOST
			Local $l_ai_Coords[2] = [26400, -11328]

		Case $GC_I_MAP_ID_AURORA_GLADE_OUTPOST
			Local $l_ai_Coords[2] = [-16444, -2656]

		Case $GC_I_MAP_ID_DIESSA_LOWLANDS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
					Local $l_ai_Coords[2] = [-23344, 18046]
				Case $GC_I_MAP_ID_GRENDICH_COURTHOUSE
					Local $l_ai_Coords[2] = [1500, 13846]
				Case $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR
					Local $l_ai_Coords[2] = [21236, 17646]
				Case $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST
					Local $l_ai_Coords[2] = [-23044, -16954]
				Case $GC_I_MAP_ID_THE_BREACH
					Local $l_ai_Coords[2] = [23940, -15154]
			EndSwitch

		Case $GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST
			Local $l_ai_Coords[2] = [-4622, 27192]

		Case $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST
			Local $l_ai_Coords[2] = [16039, 17824]

		Case $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST
			Local $l_ai_Coords[2] = [15424, -10640]

		Case $GC_I_MAP_ID_TALMARK_WILDERNESS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MAJESTYS_REST
					Local $l_ai_Coords[2] = [-20339, 3824]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Local $l_ai_Coords[2] = [-1995, -19976]
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Local $l_ai_Coords[2] = [19752, 2324]
			EndSwitch

		Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Local $l_ai_Coords[2] = [-20304, 1824]
				Case $GC_I_MAP_ID_KESSEX_PEAK
					Local $l_ai_Coords[2] = [6144, -18076]
				Case $GC_I_MAP_ID_CURSED_LANDS
					Local $l_ai_Coords[2] = [20332, 5324]
				Case $GC_I_MAP_ID_TEMPLE_OF_THE_AGES
					Local $l_ai_Coords[2] = [-5144, 16324]
			EndSwitch

		Case $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST
			Local $l_ai_Coords[2] = [-23158, 7576]

		Case $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Local $l_ai_Coords[2] = [-300, 10935]
				Case $GC_I_MAP_ID_WITMANS_FOLLY
					Local $l_ai_Coords[2] = [6144, 995]
			EndSwitch

		Case $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST
			Local $l_ai_Coords[2] = [6440, 31349]

		Case $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST
			Local $l_ai_Coords[2] = [-23285, -5644]

		Case $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST
			Local $l_ai_Coords[2] = [-12166, -23419]

		Case $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST
			Local $l_ai_Coords[2] = [-7600, -31664]

		Case $GC_I_MAP_ID_BORLIS_PASS_OUTPOST
			Local $l_ai_Coords[2] = [26033, -2260]

		Case $GC_I_MAP_ID_TALUS_CHUTE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CAMP_RANKOR
					Local $l_ai_Coords[2] = [-23040, 16422]
				Case $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
					Local $l_ai_Coords[2] = [9118, -16878]
				Case $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST
					Local $l_ai_Coords[2] = [23196, -11478]
				Case $GC_I_MAP_ID_ICEDOME
					Local $l_ai_Coords[2] = [24080, 16822]
			EndSwitch

		Case $GC_I_MAP_ID_GRIFFONS_MOUTH
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SCOUNDRELS_RISE
					Local $l_ai_Coords[2] = [-7692, -7788]
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Local $l_ai_Coords[2] = [7768, 8012]
			EndSwitch

		Case $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST
			Local $l_ai_Coords[2] = [8534, -11088]

		Case $GC_I_MAP_ID_FORT_RANIK_OUTPOST
			Local $l_ai_Coords[2] = [7172, -33005]

		Case $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST
			Local $l_ai_Coords[2] = [-1166, -13600]

		Case $GC_I_MAP_ID_XAQUANG_SKYWAY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $l_ai_Coords[2] = [-8201, 16473]
				Case $GC_I_MAP_ID_SENJIS_CORNER
					Local $l_ai_Coords[2] = [6395, -13127]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Local $l_ai_Coords[2] = [19991, -327]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Local $l_ai_Coords[2] = [-16387, 8323]
			EndSwitch

		Case $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST
			Local $l_ai_Coords[2] = [-1052, 20279]

		Case $GC_I_MAP_ID_OLD_ASCALON
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ASCALON_CITY
					Local $l_ai_Coords[2] = [18180, 11046]
				Case $GC_I_MAP_ID_REGENT_VALLEY
					Local $l_ai_Coords[2] = [10629, -13704]
				Case $GC_I_MAP_ID_SARDELAC_SANITARIUM
					Local $l_ai_Coords[2] = [-5303, -4]
				Case $GC_I_MAP_ID_THE_BREACH
					Local $l_ai_Coords[2] = [-19636, 20396]
			EndSwitch

		Case $GC_I_MAP_ID_EMBER_LIGHT_CAMP
			Local $l_ai_Coords[2] = [3782, -8372]

		Case $GC_I_MAP_ID_GRENDICH_COURTHOUSE
			Local $l_ai_Coords[2] = [2304, 13396]

		Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Local $l_ai_Coords[2] = [-20775, -403]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $l_ai_Coords[2] = [-15184, 2624]
			EndSwitch

		Case $GC_I_MAP_ID_SARDELAC_SANITARIUM
			Local $l_ai_Coords[2] = [-4824, -70]

		Case $GC_I_MAP_ID_PIKEN_SQUARE
			Local $l_ai_Coords[2] = [20214, 7272]

		Case $GC_I_MAP_ID_SAGE_LANDS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DRUIDS_OVERLOOK
					Local $l_ai_Coords[2] = [3336, -9507]
				Case $GC_I_MAP_ID_MAJESTYS_REST
					Local $l_ai_Coords[2] = [28828, 11893]
				Case $GC_I_MAP_ID_MAMNOON_LAGOON
					Local $l_ai_Coords[2] = [-26388, -4407]
				Case $GC_I_MAP_ID_THE_WILDS_OUTPOST
					Local $l_ai_Coords[2] = [-16824, 9893]
			EndSwitch

		Case $GC_I_MAP_ID_MAMNOON_LAGOON
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SAGE_LANDS
					Local $l_ai_Coords[2] = [7868, 4512]
				Case $GC_I_MAP_ID_SILVERWOOD
					Local $l_ai_Coords[2] = [-7355, -5206]
			EndSwitch

		Case $GC_I_MAP_ID_SILVERWOOD
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BLOODSTONE_FEN_OUTPOST
					Local $l_ai_Coords[2] = [-14060, 17169]
				Case $GC_I_MAP_ID_ETTINS_BACK
					Local $l_ai_Coords[2] = [-9530, -20195]
				Case $GC_I_MAP_ID_MAMNOON_LAGOON
					Local $l_ai_Coords[2] = [17984, 13297]
				Case $GC_I_MAP_ID_QUARREL_FALLS
					Local $l_ai_Coords[2] = [1575, -2652]
			EndSwitch

		Case $GC_I_MAP_ID_ETTINS_BACK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_AURORA_GLADE_OUTPOST
					Local $l_ai_Coords[2] = [22820, 12907]
				Case $GC_I_MAP_ID_DRY_TOP
					Local $l_ai_Coords[2] = [17281, -7221]
				Case $GC_I_MAP_ID_REED_BOG
					Local $l_ai_Coords[2] = [-23146, -11382]
				Case $GC_I_MAP_ID_SILVERWOOD
					Local $l_ai_Coords[2] = [-14764, 761]
				Case $GC_I_MAP_ID_VENTARIS_REFUGE
					Local $l_ai_Coords[2] = [-19082, 14092]
			EndSwitch

		Case $GC_I_MAP_ID_REED_BOG
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ETTINS_BACK
					Local $l_ai_Coords[2] = [8207, 7080]
				Case $GC_I_MAP_ID_THE_FALLS
					Local $l_ai_Coords[2] = [-6480, -8113]
			EndSwitch

		Case $GC_I_MAP_ID_THE_FALLS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_REED_BOG
					Local $l_ai_Coords[2] = [18182, 4973]
				Case $GC_I_MAP_ID_SECRET_UNDERGROUND_LAIR
					Local $l_ai_Coords[2] = [-16044, 2053]
			EndSwitch

		Case $GC_I_MAP_ID_DRY_TOP
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ETTINS_BACK
					Local $l_ai_Coords[2] = [-8020, 7845]
				Case $GC_I_MAP_ID_TANGLE_ROOT
					Local $l_ai_Coords[2] = [5291, -7896]
			EndSwitch

		Case $GC_I_MAP_ID_TANGLE_ROOT
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DRY_TOP
					Local $l_ai_Coords[2] = [-19568, 5178]
				Case $GC_I_MAP_ID_HENGE_OF_DENRAVI
					Local $l_ai_Coords[2] = [12828, 14344]
				Case $GC_I_MAP_ID_MAGUUMA_STADE
					Local $l_ai_Coords[2] = [929, -10479]
				Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
					Local $l_ai_Coords[2] = [18267, -12079]
			EndSwitch

		Case $GC_I_MAP_ID_HENGE_OF_DENRAVI
			Local $l_ai_Coords[2] = [6089, -10936]

		Case $GC_I_MAP_ID_SENJIS_CORNER
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
					Local $l_ai_Coords[2] = [7278, -17944]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $l_ai_Coords[2] = [5905, -12685]
			EndSwitch

		Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_STINGRAY_STRAND
					Local $l_ai_Coords[2] = [5727, -6682]
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Local $l_ai_Coords[2] = [7784, 8173]
				Case $GC_I_MAP_ID_TWIN_SERPENT_LAKES
					Local $l_ai_Coords[2] = [-3169, -8172]
			EndSwitch

		Case $GC_I_MAP_ID_SCOUNDRELS_RISE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST
					Local $l_ai_Coords[2] = [-1051, -7278]
				Case $GC_I_MAP_ID_GRIFFONS_MOUTH
					Local $l_ai_Coords[2] = [7663, 8129]
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Local $l_ai_Coords[2] = [-7715, 7981]
			EndSwitch

		Case $GC_I_MAP_ID_LIONS_ARCH, $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Local $l_ai_Coords[2] = [225, 12401]
				Case $GC_I_MAP_ID_LIONS_GATE
					Local $l_ai_Coords[2] = [10295, 1587]
				Case $GC_I_MAP_ID_LIONS_ARCH_KEEP
					Local $l_ai_Coords[2] = [7603, 10626]
			EndSwitch

		Case $GC_I_MAP_ID_CURSED_LANDS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Local $l_ai_Coords[2] = [-3651, -11715]
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Local $l_ai_Coords[2] = [-20109, -4634]
			EndSwitch

		Case $GC_I_MAP_ID_BERGEN_HOT_SPRINGS
			Local $l_ai_Coords[2] = [15430, -14700]

		Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BENEATH_LIONS_ARCH
					Local $l_ai_Coords[2] = [8655, -10080]
				Case $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST
					Local $l_ai_Coords[2] = [-11612, -19809]
				Case $GC_I_MAP_ID_LIONS_ARCH, $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [6556, -18531]
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Local $l_ai_Coords[2] = [-19598, 16046]
				Case $GC_I_MAP_ID_SCOUNDRELS_RISE
					Local $l_ai_Coords[2] = [20332, 11431]
			EndSwitch

		Case $GC_I_MAP_ID_NEBO_TERRACE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BEETLETUN
					Local $l_ai_Coords[2] = [-14809, 19019]
				Case $GC_I_MAP_ID_BERGEN_HOT_SPRINGS
					Local $l_ai_Coords[2] = [15542, -15496]
				Case $GC_I_MAP_ID_CURSED_LANDS
					Local $l_ai_Coords[2] = [-4368, -11550]
				Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
					Local $l_ai_Coords[2] = [20433, 3277]
			EndSwitch

		Case $GC_I_MAP_ID_MAJESTYS_REST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SAGE_LANDS
					Local $l_ai_Coords[2] = [-23585, -811]
				Case $GC_I_MAP_ID_TALMARK_WILDERNESS
					Local $l_ai_Coords[2] = [23501, -5657]
			EndSwitch

		Case $GC_I_MAP_ID_TWIN_SERPENT_LAKES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
					Local $l_ai_Coords[2] = [-7589, -20171]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Local $l_ai_Coords[2] = [6626, 22910]
			EndSwitch

		Case $GC_I_MAP_ID_WATCHTOWER_COAST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BEETLETUN
					Local $l_ai_Coords[2] = [17404, -10096]
				Case $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST
					Local $l_ai_Coords[2] = [-22149, -10486]
			EndSwitch

		Case $GC_I_MAP_ID_STINGRAY_STRAND
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FISHERMENS_HAVEN
					Local $l_ai_Coords[2] = [2046, 11083]
				Case $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST
					Local $l_ai_Coords[2] = [8233, -14689]
				Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
					Local $l_ai_Coords[2] = [-13273, 20876]
			EndSwitch

		Case $GC_I_MAP_ID_KESSEX_PEAK
			Local $l_ai_Coords[2] = [9817, 21777]

		Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
			Local $l_ai_Coords[2] = [-16203, 14114]

		Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
					Local $l_ai_Coords[2] = [5936, 6113]
				Case $GC_I_MAP_ID_FERNDALE
					Local $l_ai_Coords[2] = [10928, -1076]
			EndSwitch

		Case $GC_I_MAP_ID_ASCALON_CITY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_OLD_ASCALON
					Local $l_ai_Coords[2] = [-647, 1821]
				Case $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST
					Local $l_ai_Coords[2] = [13118, 13938]
			EndSwitch

		Case $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS, $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS_HALLOWEEN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST
					Local $l_ai_Coords[2] = [-1927, -4521]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $l_ai_Coords[2] = [2313, 4518]
			EndSwitch

		Case $GC_I_MAP_ID_ICEDOME
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Local $l_ai_Coords[2] = [8838, -5009]
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Local $l_ai_Coords[2] = [-7190, -7944]
			EndSwitch

		Case $GC_I_MAP_ID_IRON_HORSE_MINE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ANVIL_ROCK
					Local $l_ai_Coords[2] = [-25876, 1666]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Local $l_ai_Coords[2] = [26061, -7845]
			EndSwitch

		Case $GC_I_MAP_ID_ANVIL_ROCK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Local $l_ai_Coords[2] = [-17776, -17015]
				Case $GC_I_MAP_ID_ICE_TOOTH_CAVE
					Local $l_ai_Coords[2] = [-11677, 11663]
				Case $GC_I_MAP_ID_IRON_HORSE_MINE
					Local $l_ai_Coords[2] = [20479, 20548]
				Case $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST
					Local $l_ai_Coords[2] = [19148, -18048]
			EndSwitch
		Case $GC_I_MAP_ID_LORNARS_PASS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BEACONS_PERCH
					Local $l_ai_Coords[2] = [-8531, 33442]
				Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
					Local $l_ai_Coords[2] = [-8410, -35267]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $l_ai_Coords[2] = [6341, -28768]
			EndSwitch

		Case $GC_I_MAP_ID_SNAKE_DANCE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CAMP_RANKOR
					Local $l_ai_Coords[2] = [6308, -41462]
				Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
					Local $l_ai_Coords[2] = [-7418, 45039]
				Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
					Local $l_ai_Coords[2] = [8651, -3634]
			EndSwitch

		Case $GC_I_MAP_ID_TASCAS_DEMISE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MINERAL_SPRINGS
					Local $l_ai_Coords[2] = [8318, 29896]
				Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
					Local $l_ai_Coords[2] = [-10211, 18666]
			EndSwitch

		Case $GC_I_MAP_ID_SPEARHEAD_PEAK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_COPPERHAMMER_MINES
					Local $l_ai_Coords[2] = [8147, -26829]
				Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
					Local $l_ai_Coords[2] = [-14707, 10]
				Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
					Local $l_ai_Coords[2] = [-11495, 15736]
			EndSwitch

		Case $GC_I_MAP_ID_ICE_FLOE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Local $l_ai_Coords[2] = [-11069, 16830]
				Case $GC_I_MAP_ID_MARHANS_GROTTO
					Local $l_ai_Coords[2] = [5365, -11965]
				Case $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST
					Local $l_ai_Coords[2] = [21820, 13787]
			EndSwitch

		Case $GC_I_MAP_ID_WITMANS_FOLLY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
					Local $l_ai_Coords[2] = [-18878, 7584]
				Case $GC_I_MAP_ID_PORT_SLEDGE
					Local $l_ai_Coords[2] = [-7401, -2933]
			EndSwitch

		Case $GC_I_MAP_ID_MINERAL_SPRINGS
			Local $l_ai_Coords[2] = [-23063, -10524]

		Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LORNARS_PASS
					Local $l_ai_Coords[2] = [-5518, 8346]
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Local $l_ai_Coords[2] = [-7221, -7805]
			EndSwitch

		Case $GC_I_MAP_ID_FROZEN_FOREST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_COPPERHAMMER_MINES
					Local $l_ai_Coords[2] = [-17881, 9740]
				Case $GC_I_MAP_ID_ICE_FLOE
					Local $l_ai_Coords[2] = [23276, -14128]
				Case $GC_I_MAP_ID_ICEDOME
					Local $l_ai_Coords[2] = [-24993, -10537]
				Case $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST
					Local $l_ai_Coords[2] = [20316, 11192]
			EndSwitch

		Case $GC_I_MAP_ID_TRAVELERS_VALE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
					Local $l_ai_Coords[2] = [11345, -17157]
				Case $GC_I_MAP_ID_BORLIS_PASS_OUTPOST
					Local $l_ai_Coords[2] = [-11250, -8455]
				Case $GC_I_MAP_ID_IRON_HORSE_MINE
					Local $l_ai_Coords[2] = [-11061, 14398]
				Case $GC_I_MAP_ID_YAKS_BEND
					Local $l_ai_Coords[2] = [9301, 4246]
			EndSwitch

		Case $GC_I_MAP_ID_DELDRIMOR_BOWL
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ANVIL_ROCK
					Local $l_ai_Coords[2] = [13526, 26142]
				Case $GC_I_MAP_ID_BEACONS_PERCH
					Local $l_ai_Coords[2] = [14135, -23402]
				Case $GC_I_MAP_ID_GRIFFONS_MOUTH
					Local $l_ai_Coords[2] = [-13899, -23382]
			EndSwitch

		Case $GC_I_MAP_ID_REGENT_VALLEY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FORT_RANIK_OUTPOST
					Local $l_ai_Coords[2] = [22535, 7584]
				Case $GC_I_MAP_ID_OLD_ASCALON
					Local $l_ai_Coords[2] = [-17197, 17034]
				Case $GC_I_MAP_ID_POCKMARK_FLATS
					Local $l_ai_Coords[2] = [24367, -4312]
			EndSwitch

		Case $GC_I_MAP_ID_THE_BREACH
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Local $l_ai_Coords[2] = [-19605, 3206]
				Case $GC_I_MAP_ID_OLD_ASCALON
					Local $l_ai_Coords[2] = [1891, -11181]
				Case $GC_I_MAP_ID_PIKEN_SQUARE
					Local $l_ai_Coords[2] = [20249, 7869]
			EndSwitch

		Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Local $l_ai_Coords[2] = [7402, -7244]
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Local $l_ai_Coords[2] = [-7734, 7406]
			EndSwitch

		Case $GC_I_MAP_ID_POCKMARK_FLATS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_EASTERN_FRONTIER
					Local $l_ai_Coords[2] = [9660, 26445]
				Case $GC_I_MAP_ID_REGENT_VALLEY
					Local $l_ai_Coords[2] = [-13095, -20202]
				Case $GC_I_MAP_ID_SERENITY_TEMPLE
					Local $l_ai_Coords[2] = [-6196, 22720]
			EndSwitch

		Case $GC_I_MAP_ID_DRAGONS_GULLET
			Local $l_ai_Coords[2] = [-4819, -1215]

		Case $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DIESSA_LOWLANDS
					Local $l_ai_Coords[2] = [-18414, -13661]
				Case $GC_I_MAP_ID_DRAGONS_GULLET
					Local $l_ai_Coords[2] = [-4449, -846]
			EndSwitch

		Case $GC_I_MAP_ID_EASTERN_FRONTIER
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FRONTIER_GATE
					Local $l_ai_Coords[2] = [-14310, 4317]
				Case $GC_I_MAP_ID_POCKMARK_FLATS
					Local $l_ai_Coords[2] = [15740, -20305]
				Case $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST
					Local $l_ai_Coords[2] = [-20444, 10805]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SCAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DESTINYS_GORGE
					Local $l_ai_Coords[2] = [-13950, 17253]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $l_ai_Coords[2] = [-19102, -15635]
				Case $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST
					Local $l_ai_Coords[2] = [15898, -23618]
			EndSwitch

		Case $GC_I_MAP_ID_THE_AMNOON_OASIS
			Local $l_ai_Coords[2] = [6122, -5425]

		Case $GC_I_MAP_ID_DIVINERS_ASCENT
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ELONA_REACH_OUTPOST
					Local $l_ai_Coords[2] = [-7940, 3682]
				Case $GC_I_MAP_ID_SALT_FLATS
					Local $l_ai_Coords[2] = [-19674, 16216]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $l_ai_Coords[2] = [6122, -5425]
			EndSwitch

		Case $GC_I_MAP_ID_VULTURE_DRIFTS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST
					Local $l_ai_Coords[2] = [-4570, -12082]
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Local $l_ai_Coords[2] = [-7905, 20627]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $l_ai_Coords[2] = [19590, 20735]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Local $l_ai_Coords[2] = [19704, -17234]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ARID_SEA
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Local $l_ai_Coords[2] = [-1139, -20132]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $l_ai_Coords[2] = [-2177, 20966]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Local $l_ai_Coords[2] = [-19754, 6044]
			EndSwitch

		Case $GC_I_MAP_ID_PROPHETS_PATH
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
					Local $l_ai_Coords[2] = [20343, -371]
				Case $GC_I_MAP_ID_HEROES_AUDIENCE
					Local $l_ai_Coords[2] = [-15319, -14653]
				Case $GC_I_MAP_ID_SALT_FLATS
					Local $l_ai_Coords[2] = [7555, 19856]
				Case $GC_I_MAP_ID_THE_AMNOON_OASIS
					Local $l_ai_Coords[2] = [-18916, 19469]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Local $l_ai_Coords[2] = [1279, -20012]
			EndSwitch

		Case $GC_I_MAP_ID_SALT_FLATS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DIVINERS_ASCENT
					Local $l_ai_Coords[2] = [20895, 16122]
				Case $GC_I_MAP_ID_SEEKERS_PASSAGE
					Local $l_ai_Coords[2] = [-16768, 8481]
				Case $GC_I_MAP_ID_PROPHETS_PATH
					Local $l_ai_Coords[2] = [-3969, -20194]
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $l_ai_Coords[2] = [20311, -19727]
			EndSwitch

		Case $GC_I_MAP_ID_SKYWARD_REACH
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
					Local $l_ai_Coords[2] = [-15226, 1880]
				Case $GC_I_MAP_ID_DESTINYS_GORGE
					Local $l_ai_Coords[2] = [20047, 19400]
				Case $GC_I_MAP_ID_DIVINERS_ASCENT
					Local $l_ai_Coords[2] = [8573, 19329]
				Case $GC_I_MAP_ID_SALT_FLATS
					Local $l_ai_Coords[2] = [-7442, 20673]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Local $l_ai_Coords[2] = [7135, -19571]
				Case $GC_I_MAP_ID_THE_SCAR
					Local $l_ai_Coords[2] = [18335, -18521]
				Case $GC_I_MAP_ID_VULTURE_DRIFTS
					Local $l_ai_Coords[2] = [-10510, -20067]
			EndSwitch

		Case $GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST
			Local $l_ai_Coords[2] = [10446, 6009]

		Case $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST
			Local $l_ai_Coords[2] = [13160, 13848]

		Case $GC_I_MAP_ID_ELONA_REACH_OUTPOST
			Local $l_ai_Coords[2] = [17252, 6887]

		Case $GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST
			Local $l_ai_Coords[2] = [-17287, 20669]

		Case $GC_I_MAP_ID_PERDITION_ROCK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_EMBER_LIGHT_CAMP
					Local $l_ai_Coords[2] = [3788, -8746]
				Case $GC_I_MAP_ID_RING_OF_FIRE_OUTPOST
					Local $l_ai_Coords[2] = [-8397, 4512]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST
					Local $l_ai_Coords[2] = [-5246, 9724]
				Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
					Local $l_ai_Coords[2] = [13249, -10009]
				Case $GC_I_MAP_ID_VASBURG_ARMORY
					Local $l_ai_Coords[2] = [18513, 2379]
			EndSwitch

		Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FERNDALE
					Local $l_ai_Coords[2] = [-13835, 1806]
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Local $l_ai_Coords[2] = [-7466, 1997]
			EndSwitch

		Case $GC_I_MAP_ID_VASBURG_ARMORY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MOROSTAV_TRAIL
					Local $l_ai_Coords[2] = [23970, 7278]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Local $l_ai_Coords[2] = [18444, 1988]
			EndSwitch
		Case $GC_I_MAP_ID_SERENITY_TEMPLE
			Local $l_ai_Coords[2] = [-6202, 22292]

		Case $GC_I_MAP_ID_ICE_TOOTH_CAVE
			Local $l_ai_Coords[2] = [-12357, 11803]

		Case $GC_I_MAP_ID_BEACONS_PERCH
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_BOWL
					Local $l_ai_Coords[2] = [-10883, 35722]
				Case $GC_I_MAP_ID_LORNARS_PASS
					Local $l_ai_Coords[2] = [-8399, 33266]
			EndSwitch

		Case $GC_I_MAP_ID_YAKS_BEND
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_TRAVELERS_VALE
					Local $l_ai_Coords[2] = [9222, 4029]
			EndSwitch

		Case $GC_I_MAP_ID_FRONTIER_GATE
			Local $l_ai_Coords[2] = [-13687, 4413]

		Case $GC_I_MAP_ID_BEETLETUN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_NEBO_TERRACE
					Local $l_ai_Coords[2] = [22408, -11478]
				Case $GC_I_MAP_ID_WATCHTOWER_COAST
					Local $l_ai_Coords[2] = [17302, -9293]
			EndSwitch
		Case $GC_I_MAP_ID_FISHERMENS_HAVEN
			Local $l_ai_Coords[2] = [1890, 11538]

		Case $GC_I_MAP_ID_TEMPLE_OF_THE_AGES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
					Local $l_ai_Coords[2] = [-5242, 16001]
				Case $GC_I_MAP_ID_THE_FISSURE_OF_WOE
					Local $l_ai_Coords[2] = [-2759, 18616]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $l_ai_Coords[2] = [-2759, 18616]
			EndSwitch

		Case $GC_I_MAP_ID_VENTARIS_REFUGE
			Local $l_ai_Coords[2] = [-15190, 464]

		Case $GC_I_MAP_ID_DRUIDS_OVERLOOK
			Local $l_ai_Coords[2] = [2982, -9266]

		Case $GC_I_MAP_ID_MAGUUMA_STADE
			Local $l_ai_Coords[2] = [502, -9731]

		Case $GC_I_MAP_ID_QUARREL_FALLS
			Local $l_ai_Coords[2] = [2040, -2021]

		Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST
					Local $l_ai_Coords[2] = [4453, 26331]
				Case $GC_I_MAP_ID_LEVIATHAN_PITS
					Local $l_ai_Coords[2] = [8796, -19945]
				Case $GC_I_MAP_ID_RHEAS_CRATER
					Local $l_ai_Coords[2] = [13801, -11473]
			EndSwitch

		Case $GC_I_MAP_ID_THE_CATACOMBS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
					Local $l_ai_Coords[2] = [15229, 2225]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $l_ai_Coords[2] = [5806, -22750]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Local $l_ai_Coords[2] = [-10629, 16036]
			EndSwitch

		Case $GC_I_MAP_ID_LAKESIDE_COUNTY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ASCALON_CITY_OUTPOST, $GC_I_MAP_ID_ASCALON_CITY_WINTERSDAY
					Local $l_ai_Coords[2] = [7755, 5939]
				Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
					Local $l_ai_Coords[2] = [-11517, -6203]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Local $l_ai_Coords[2] = [-14898, 10092]
				Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
					Local $l_ai_Coords[2] = [4896, -19584]
				Case $GC_I_MAP_ID_THE_NORTHLANDS
					Local $l_ai_Coords[2] = [-5531, 14305]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $l_ai_Coords[2] = [-14291, -19972]
			EndSwitch

		Case $GC_I_MAP_ID_THE_NORTHLANDS
			Local $l_ai_Coords[2] = [-11693, -18762]

		Case $GC_I_MAP_ID_ASCALON_CITY_OUTPOST, $GC_I_MAP_ID_ASCALON_CITY_WINTERSDAY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ASCALON_ACADEMY_EXPLORABLE
					Local $l_ai_Coords[2] = [6650, 4906]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $l_ai_Coords[2] = [11718, 3705]
			EndSwitch

		Case $GC_I_MAP_ID_HEROES_AUDIENCE
			Local $l_ai_Coords[2] = [-14886, -14335]

		Case $GC_I_MAP_ID_SEEKERS_PASSAGE
			Local $l_ai_Coords[2] = [-16383, 8072]

		Case $GC_I_MAP_ID_DESTINYS_GORGE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SKYWARD_REACH
					Local $l_ai_Coords[2] = [-17370, 22689]
				Case $GC_I_MAP_ID_THE_SCAR
					Local $l_ai_Coords[2] = [-13344, 17572]
			EndSwitch

		Case $GC_I_MAP_ID_CAMP_RANKOR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Local $l_ai_Coords[2] = [5873, -41002]
				Case $GC_I_MAP_ID_TALUS_CHUTE
					Local $l_ai_Coords[2] = [7722, -45014]
			EndSwitch

		Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Local $l_ai_Coords[2] = [-11560, 15230]
				Case $GC_I_MAP_ID_TASCAS_DEMISE
					Local $l_ai_Coords[2] = [-9381, 19732]
			EndSwitch
		Case $GC_I_MAP_ID_MARHANS_GROTTO
			Local $l_ai_Coords[2] = [5588, -11428]

		Case $GC_I_MAP_ID_PORT_SLEDGE
			Local $l_ai_Coords[2] = [-7306, -2278]

		Case $GC_I_MAP_ID_COPPERHAMMER_MINES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FROZEN_FOREST
					Local $l_ai_Coords[2] = [-17971, 9397]
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Local $l_ai_Coords[2] = [-23189, 13855]
			EndSwitch

		Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $l_ai_Coords[2] = [22562, 13291]
				Case $GC_I_MAP_ID_PRESEARING_THE_BARRADIN_ESTATE
					Local $l_ai_Coords[2] = [-6937, 1525]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Local $l_ai_Coords[2] = [-2913, 9458]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $l_ai_Coords[2] = [-6870, -17130]
			EndSwitch

		Case $GC_I_MAP_ID_WIZARDS_FOLLY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PRESEARING_FOIBLES_FAIR
					Local $l_ai_Coords[2] = [156, 8706]
				Case $GC_I_MAP_ID_GREEN_HILLS_COUNTY
					Local $l_ai_Coords[2] = [-19038, 20865]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $l_ai_Coords[2] = [11164, 20167]
				Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
					Local $l_ai_Coords[2] = [20779, -9631]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Local $l_ai_Coords[2] = [-5108, 19511]
			EndSwitch
		Case $GC_I_MAP_ID_PRESEARING_REGENT_VALLEY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PRESEARING_FORT_RANIK
					Local $l_ai_Coords[2] = [22538, 7989]
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $l_ai_Coords[2] = [-17258, 17088]
				Case $GC_I_MAP_ID_WIZARDS_FOLLY
					Local $l_ai_Coords[2] = [-26292, -13186]
			EndSwitch

		Case $GC_I_MAP_ID_PRESEARING_THE_BARRADIN_ESTATE
			Local $l_ai_Coords[2] = [-7608, 1548]

		Case $GC_I_MAP_ID_PRESEARING_ASHFORD_ABBEY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LAKESIDE_COUNTY
					Local $l_ai_Coords[2] = [-11021, -5986]
				Case $GC_I_MAP_ID_THE_CATACOMBS
					Local $l_ai_Coords[2] = [-14551, -6785]
			EndSwitch

		Case $GC_I_MAP_ID_PRESEARING_FOIBLES_FAIR
			Local $l_ai_Coords[2] = [543, 7417]

		Case $GC_I_MAP_ID_PRESEARING_FORT_RANIK
			Local $l_ai_Coords[2] = [22601, 7040]

		Case $GC_I_MAP_ID_SORROWS_FURNACE
			Local $l_ai_Coords[2] = [-14758, 18327]

		Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DELDRIMOR_WAR_CAMP
					Local $l_ai_Coords[2] = [-2942, -4593]
				Case $GC_I_MAP_ID_SNAKE_DANCE
					Local $l_ai_Coords[2] = [-19650, -8866]
				Case $GC_I_MAP_ID_SORROWS_FURNACE
					Local $l_ai_Coords[2] = [-13304, 7952]
				Case $GC_I_MAP_ID_SPEARHEAD_PEAK
					Local $l_ai_Coords[2] = [22448, 3822]
			EndSwitch

		Case $GC_I_MAP_ID_CAVALON
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $l_ai_Coords[2] = [6789, -7429]
				Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
					Local $l_ai_Coords[2] = [4824, 3108]
			EndSwitch

		Case $GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BEJUNKAN_PIER
					Local $l_ai_Coords[2] = [-2221, 1485]
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $l_ai_Coords[2] = [3258, -4838]
				Case $GC_I_MAP_ID_RAISU_PAVILLION
					Local $l_ai_Coords[2] = [7955, -1403]
			EndSwitch

		Case $GC_I_MAP_ID_DRAZACH_THICKET
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BRAUER_ACADEMY
					Local $l_ai_Coords[2] = [13866, 1940]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Local $l_ai_Coords[2] = [-3116, -16431]
				Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
					Local $l_ai_Coords[2] = [-11310, 20455]
			EndSwitch

		Case $GC_I_MAP_ID_JAYA_BLUFF
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_HAIJU_LAGOON
					Local $l_ai_Coords[2] = [23655, 1767]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Local $l_ai_Coords[2] = [11079, -13130]
			EndSwitch

		Case $GC_I_MAP_ID_SHENZUN_TUNNELS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MAATU_KEEP
					Local $l_ai_Coords[2] = [10468, -19960]
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
					Local $l_ai_Coords[2] = [-14176, -18445]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST
					Local $l_ai_Coords[2] = [17773, -7073]
				Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST
					Local $l_ai_Coords[2] = [16650, 18985]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $l_ai_Coords[2] = [-14656, 15005]
			EndSwitch

		Case $GC_I_MAP_ID_ARCHIPELAGOS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BREAKER_HOLLOW
					Local $l_ai_Coords[2] = [-20068, 10691]
				Case $GC_I_MAP_ID_CAVALON
					Local $l_ai_Coords[2] = [3271, 11710]
				Case $GC_I_MAP_ID_JADE_FLATS_LUXON
					Local $l_ai_Coords[2] = [-5723, -10329]
				Case $GC_I_MAP_ID_MAISHANG_HILLS
					Local $l_ai_Coords[2] = [16468, 11073]
			EndSwitch

		Case $GC_I_MAP_ID_MAISHANG_HILLS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $l_ai_Coords[2] = [-21127, -10959]
				Case $GC_I_MAP_ID_BAI_PAASU_REACH
					Local $l_ai_Coords[2] = [-16691, 13941]
				Case $GC_I_MAP_ID_EREDON_TERRACE
					Local $l_ai_Coords[2] = [18176, 11988]
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Local $l_ai_Coords[2] = [13212, -11090]
			EndSwitch

		Case $GC_I_MAP_ID_MOUNT_QINKAI
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ASPENWOOD_GATE_LUXON
					Local $l_ai_Coords[2] = [-8373, -10928]
				Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
					Local $l_ai_Coords[2] = [20607, 11310]
				Case $GC_I_MAP_ID_BREAKER_HOLLOW
					Local $l_ai_Coords[2] = [17237, -2160]
			EndSwitch

		Case $GC_I_MAP_ID_MELANDRUS_HOPE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BRAUER_ACADEMY
					Local $l_ai_Coords[2] = [-13777, -16018]
				Case $GC_I_MAP_ID_JADE_FLATS_KURZICK
					Local $l_ai_Coords[2] = [17142, 23821]
				Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
					Local $l_ai_Coords[2] = [-7946, 1832]
			EndSwitch

		Case $GC_I_MAP_ID_RHEAS_CRATER
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Local $l_ai_Coords[2] = [-14140, 19748]
				Case $GC_I_MAP_ID_SEAFARERS_REST
					Local $l_ai_Coords[2] = [-11344, -18478]
				Case $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST
					Local $l_ai_Coords[2] = [15389, -2284]
			EndSwitch

		Case $GC_I_MAP_ID_SILENT_SURF
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LEVIATHAN_PITS
					Local $l_ai_Coords[2] = [8869, 26181]
				Case $GC_I_MAP_ID_SEAFARERS_REST
					Local $l_ai_Coords[2] = [14156, 2082]
				Case $GC_I_MAP_ID_UNWAKING_WATERS_LUXON_MISSION_OUTPOST
					Local $l_ai_Coords[2] = [-10845, -13957]
			EndSwitch

		Case $GC_I_MAP_ID_MOROSTAV_TRAIL
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
					Local $l_ai_Coords[2] = [7612, -10680]
				Case $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK_MISSION_OUTPOST
					Local $l_ai_Coords[2] = [23157, 13987]
				Case $GC_I_MAP_ID_VASBURG_ARMORY
					Local $l_ai_Coords[2] = [-22740, 7193]
			EndSwitch

		Case $GC_I_MAP_ID_DELDRIMOR_WAR_CAMP
			Local $l_ai_Coords[2] = [-2763, -4177]

		Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_AMATZ_BASIN_OUTPOST
					Local $l_ai_Coords[2] = [-16734, -7744]
				Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
					Local $l_ai_Coords[2] = [27795, 6140]
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Local $l_ai_Coords[2] = [-8248, 12180]
			EndSwitch

		Case $GC_I_MAP_ID_FERNDALE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK
					Local $l_ai_Coords[2] = [17060, 22489]
				Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
					Local $l_ai_Coords[2] = [-14497, 14495]
				Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
					Local $l_ai_Coords[2] = [17598, -22700]
				Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
					Local $l_ai_Coords[2] = [-9617, -21311]
			EndSwitch

		Case $GC_I_MAP_ID_PONGMEI_VALLEY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
					Local $l_ai_Coords[2] = [23183, -511]
				Case $GC_I_MAP_ID_MAATU_KEEP
					Local $l_ai_Coords[2] = [-13373, 11713]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
					Local $l_ai_Coords[2] = [15797, 17424]
				Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
					Local $l_ai_Coords[2] = [-17982, -9642]
			EndSwitch
		Case $GC_I_MAP_ID_MONASTERY_OVERLOOK
			Local $l_ai_Coords[2] = [-6949, 6116]

		Case $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST
			Local $l_ai_Coords[2] = [19354, 14378]

		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
			Local $l_ai_Coords[2] = [6756, -11401]

		Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
			Local $l_ai_Coords[2] = [-21684, 14219]

		Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST
			Local $l_ai_Coords[2] = [-11884, -14846]

		Case $GC_I_MAP_ID_ARBORSTONE_OUTPOST
			Local $l_ai_Coords[2] = [-1236, 10382]

		Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
			Local $l_ai_Coords[2] = [-26217, 3236]

		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST
			Local $l_ai_Coords[2] = [-13350, -4015]

		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
					Local $l_ai_Coords[2] = [-5594, 9641]
				Case $GC_I_MAP_ID_DRAZACH_THICKET
					Local $l_ai_Coords[2] = [-6715, 14595]
			EndSwitch

		Case $GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST
			Local $l_ai_Coords[2] = [4438, 26311]

		Case $GC_I_MAP_ID_RAISU_PALACE_OUTPOST
			Local $l_ai_Coords[2] = [-21788, -4489]

		Case $GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST
			Local $l_ai_Coords[2] = [-9611, 3113]

		Case $GC_I_MAP_ID_UNWAKING_WATERS_LUXON_MISSION_OUTPOST
			Local $l_ai_Coords[2] = [-13964, -7765]

		Case $GC_I_MAP_ID_AMATZ_BASIN_OUTPOST
			Local $l_ai_Coords[2] = [-4556, 4753]

		Case $GC_I_MAP_ID_SHADOWS_PASSAGE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $l_ai_Coords[2] = [-14598, 15858]
				Case $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST
					Local $l_ai_Coords[2] = [3140, 11461]
			EndSwitch

		Case $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST
					Local $l_ai_Coords[2] = [-21762, -4523]
				Case $GC_I_MAP_ID_RAISU_PALACE_OUTPOST
					Local $l_ai_Coords[2] = [24185, -476]
			EndSwitch

		Case $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST
			Local $l_ai_Coords[2] = [-6616, 7385]

		Case $GC_I_MAP_ID_PANJIANG_PENINSULA
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Local $l_ai_Coords[2] = [-22270, 17107]
				Case $GC_I_MAP_ID_TSUMEI_VILLAGE
					Local $l_ai_Coords[2] = [10238, 17359]
			EndSwitch

		Case $GC_I_MAP_ID_KINYA_PROVINCE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PANJIANG_PENINSULA
					Local $l_ai_Coords[2] = [-6892, -23276]
				Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
					Local $l_ai_Coords[2] = [15028, 15803]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Local $l_ai_Coords[2] = [17185, 1452]
			EndSwitch

		Case $GC_I_MAP_ID_HAIJU_LAGOON
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_JAYA_BLUFF
					Local $l_ai_Coords[2] = [-13680, -7569]
				Case $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST
					Local $l_ai_Coords[2] = [15973, -22787]
			EndSwitch

		Case $GC_I_MAP_ID_SUNQUA_VALE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Local $l_ai_Coords[2] = [-20407, 7442]
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
					Local $l_ai_Coords[2] = [6975, 16535]
				Case $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
					Local $l_ai_Coords[2] = [22339, -10253]
				Case $GC_I_MAP_ID_TSUMEI_VILLAGE
					Local $l_ai_Coords[2] = [-4854, -13322]
			EndSwitch

		Case $GC_I_MAP_ID_WAIJUN_BAZAAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
					Local $l_ai_Coords[2] = [9049, -19979]
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Local $l_ai_Coords[2] = [11758, 15629]
				Case $GC_I_MAP_ID_THE_UNDERCITY
					Local $l_ai_Coords[2] = [17532, -9887]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $l_ai_Coords[2] = [17537, 5466]
			EndSwitch

		Case $GC_I_MAP_ID_BUKDEK_BYWAY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [-6720, 20504]
				Case $GC_I_MAP_ID_SHADOWS_PASSAGE
					Local $l_ai_Coords[2] = [13198, 15801]
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Local $l_ai_Coords[2] = [-14133, -14264]
				Case $GC_I_MAP_ID_THE_UNDERCITY
					Local $l_ai_Coords[2] = [4271, -16786]
				Case $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER
					Local $l_ai_Coords[2] = [14100, 5275]
				Case $GC_I_MAP_ID_XAQUANG_SKYWAY
					Local $l_ai_Coords[2] = [-5069, -20356]
			EndSwitch

		Case $GC_I_MAP_ID_THE_UNDERCITY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $l_ai_Coords[2] = [1190, 18178]
				Case $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER
					Local $l_ai_Coords[2] = [19807, 17152]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Local $l_ai_Coords[2] = [-16876, -6821]
			EndSwitch
		Case $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LINNOK_COURTYARD
					Local $l_ai_Coords[2] = [-3484, 9500]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Local $l_ai_Coords[2] = [-15271, 11962]
			EndSwitch

		Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
					Local $l_ai_Coords[2] = [8840, -20182]
				Case $GC_I_MAP_ID_ARBORSTONE_OUTPOST
					Local $l_ai_Coords[2] = [-2726, 8396]
				Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
					Local $l_ai_Coords[2] = [12068, 13539]
			EndSwitch

		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
					Local $l_ai_Coords[2] = [7684, -6887]
				Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
					Local $l_ai_Coords[2] = [-20185, -1671]
			EndSwitch

		Case $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE
			Local $l_ai_Coords[2] = [-19311, 6016]
			;[19257, 14162] zen daijun oupost ?

		Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
					Local $l_ai_Coords[2] = [-21543, 933]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Local $l_ai_Coords[2] = [-7425, -10344]
				Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
					Local $l_ai_Coords[2] = [12692, -11173]
			EndSwitch

		Case $GC_I_MAP_ID_GREAT_TEMPLE_OF_BALTHAZAR
			Local $l_ai_Coords[2] = [-6100, -2941]

		Case $GC_I_MAP_ID_TSUMEI_VILLAGE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PANJIANG_PENINSULA
					Local $l_ai_Coords[2] = [-11694, -16968]
				Case $GC_I_MAP_ID_SUNQUA_VALE
					Local $l_ai_Coords[2] = [-4645, -12829]
			EndSwitch

		Case $GC_I_MAP_ID_SEITUNG_HARBOR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_JAYA_BLUFF
					Local $l_ai_Coords[2] = [16669, 17695]
				Case $GC_I_MAP_ID_KAINENG_DOCKS
					Local $l_ai_Coords[2] = [17598, 9443]
				Case $GC_I_MAP_ID_SAOSHANG_TRAIL
					Local $l_ai_Coords[2] = [16157, 13734]
				Case $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE
					Local $l_ai_Coords[2] = [20390, 9591]
			EndSwitch

		Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE
					Local $l_ai_Coords[2] = [17103, 19990]
				Case $GC_I_MAP_ID_KINYA_PROVINCE
					Local $l_ai_Coords[2] = [14677, 15275]
			EndSwitch

		Case $GC_I_MAP_ID_LINNOK_COURTYARD
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SAOSHANG_TRAIL
					Local $l_ai_Coords[2] = [483, 10181]
				Case $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
					Local $l_ai_Coords[2] = [-3923, 9604]
			EndSwitch

		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PONGMEI_VALLEY
					Local $l_ai_Coords[2] = [12853, -16734]
				Case $GC_I_MAP_ID_ZIN_KU_CORRIDOR
					Local $l_ai_Coords[2] = [8648, 17631]
			EndSwitch

		Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SENJIS_CORNER
					Local $l_ai_Coords[2] = [10424, 14463]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Local $l_ai_Coords[2] = [23542, -2849]
			EndSwitch

			;Tahnnakai temple

		Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
					Local $l_ai_Coords[2] = [6502, 8254]
				Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
					Local $l_ai_Coords[2] = [6578, 6126]
			EndSwitch

		Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
					Local $l_ai_Coords[2] = [3522, 7712]
				Case $GC_I_MAP_ID_CAVALON
					Local $l_ai_Coords[2] = [3559, 4461]
			EndSwitch

		Case $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST
			Local $l_ai_Coords[2] = [-12191, 9164]

		Case $GC_I_MAP_ID_HARVEST_TEMPLE
			Local $l_ai_Coords[2] = [3250, 2215]

		Case $GC_I_MAP_ID_BREAKER_HOLLOW
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $l_ai_Coords[2] = [20766, -4997]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Local $l_ai_Coords[2] = [16568, -1653]
			EndSwitch

		Case $GC_I_MAP_ID_LEVIATHAN_PITS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
					Local $l_ai_Coords[2] = [8373, -19462]
				Case $GC_I_MAP_ID_SILENT_SURF
					Local $l_ai_Coords[2] = [9240, -26239]
			EndSwitch

		Case $GC_I_MAP_ID_MAATU_KEEP
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PONGMEI_VALLEY
					Local $l_ai_Coords[2] = [-13339, 11007]
				Case $GC_I_MAP_ID_SHENZUN_TUNNELS
					Local $l_ai_Coords[2] = [-17805, 16616]
			EndSwitch

			;isle of the nameless

		Case $GC_I_MAP_ID_ZIN_KU_CORRIDOR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_FISSURE_OF_WOE
					Local $l_ai_Coords[2] = [-1262, -16243]
				Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
					Local $l_ai_Coords[2] = [11756, -20256]
				Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_EXPLORABLE
					Local $l_ai_Coords[2] = [2740, -15706]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $l_ai_Coords[2] = [-2588, -15183]
			EndSwitch

		Case $GC_I_MAP_ID_MONASTERY_OVERLOOK_2
			Local $l_ai_Coords[2] = [0, 0]

		Case $GC_I_MAP_ID_BRAUER_ACADEMY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DRAZACH_THICKET
					Local $l_ai_Coords[2] = [15393, 7011]
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Local $l_ai_Coords[2] = [17597, 1178]
			EndSwitch

		Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MOROSTAV_TRAIL
					Local $l_ai_Coords[2] = [32836, 11108]
				Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
					Local $l_ai_Coords[2] = [26952, 5318]
			EndSwitch

		Case $GC_I_MAP_ID_BAI_PAASU_REACH
			Local $l_ai_Coords[2] = [-16124, 13701]

		Case $GC_I_MAP_ID_SEAFARERS_REST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_RHEAS_CRATER
					Local $l_ai_Coords[2] = [-10900, -17724]
				Case $GC_I_MAP_ID_SILENT_SURF
					Local $l_ai_Coords[2] = [-14157, -20103]
			EndSwitch

		Case $GC_I_MAP_ID_BEJUNKAN_PIER
			Local $l_ai_Coords[2] = [-1922, 1171]

		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER
			Local $l_ai_Coords[2] = [-5279, -20042]

		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER
			Local $l_ai_Coords[2] = [-13865, 5143]

		Case $GC_I_MAP_ID_FORT_ASPENWOOD_LUXON
			Local $l_ai_Coords[2] = [-1972, 9447]
		Case $GC_I_MAP_ID_FORT_ASPENWOOD_KURZICK
			Local $l_ai_Coords[2] = [-7025, -1417]
		Case $GC_I_MAP_ID_THE_JADE_QUARRY_LUXON
			Local $l_ai_Coords[2] = [6380, 13757]
		Case $GC_I_MAP_ID_THE_JADE_QUARRY_KURZICK
			Local $l_ai_Coords[2] = [-7193, -10646]
		Case $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK_MISSION_OUTPOST
			Local $l_ai_Coords[2] = [-14072, -7940]

		Case $GC_I_MAP_ID_RAISU_PAVILLION
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [-26584, -4451]
				Case $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE
					Local $l_ai_Coords[2] = [-20985, -4471]
			EndSwitch

		Case $GC_I_MAP_ID_KAINENG_DOCKS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_MARKETPLACE
					Local $l_ai_Coords[2] = [12122, 18778]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Local $l_ai_Coords[2] = [7063, 20189]
			EndSwitch

		Case $GC_I_MAP_ID_THE_MARKETPLACE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BUKDEK_BYWAY
					Local $l_ai_Coords[2] = [16684, 20196]
				Case $GC_I_MAP_ID_KAINENG_DOCKS
					Local $l_ai_Coords[2] = [11643, 19336]
				Case $GC_I_MAP_ID_WAIJUN_BAZAAR
					Local $l_ai_Coords[2] = [11502, 15283]
			EndSwitch

		Case $GC_I_MAP_ID_SAOSHANG_TRAIL
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LINNOK_COURTYARD
					Local $l_ai_Coords[2] = [311, 10174]
				Case $GC_I_MAP_ID_SEITUNG_HARBOR
					Local $l_ai_Coords[2] = [16663, 13283]
			EndSwitch

		Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
					Local $l_ai_Coords[2] = [-20254, -13650]
				Case $GC_I_MAP_ID_PONGMEI_VALLEY
					Local $l_ai_Coords[2] = [-17726, -8557]
			EndSwitch

		Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DRAZACH_THICKET
					Local $l_ai_Coords[2] = [-11107, -23507]
				Case $GC_I_MAP_ID_FERNDALE
					Local $l_ai_Coords[2] = [-8635, -21523]
			EndSwitch

		Case $GC_I_MAP_ID_EREDON_TERRACE
			Local $l_ai_Coords[2] = [18503, 11273]

		Case $GC_I_MAP_ID_DIVINE_PATH
			Local $l_ai_Coords[2] = [-26646, -4642]

		Case $GC_I_MAP_ID_JAHAI_BLUFFS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $l_ai_Coords[2] = [-2666, -17151]
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $l_ai_Coords[2] = [-8668, 6566]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Local $l_ai_Coords[2] = [22784, -17287]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Local $l_ai_Coords[2] = [23344, 1501]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $l_ai_Coords[2] = [-22925, 17411]
			EndSwitch

		Case $GC_I_MAP_ID_MARGA_COAST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $l_ai_Coords[2] = [22692, -1108]
				Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
					Local $l_ai_Coords[2] = [-23034, 17254]
				Case $GC_I_MAP_ID_NUNDU_BAY_OUTPOST
					Local $l_ai_Coords[2] = [-15438, -4546]
				Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
					Local $l_ai_Coords[2] = [13204, 14918]
				Case $GC_I_MAP_ID_YOHLON_HAVEN
					Local $l_ai_Coords[2] = [23031, -16644]
			EndSwitch

		Case $GC_I_MAP_ID_SUNWARD_MARCHES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $l_ai_Coords[2] = [18499, -8566]
				Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
					Local $l_ai_Coords[2] = [-19922, -14506]
				Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
					Local $l_ai_Coords[2] = [23471, 14379]
			EndSwitch

		Case $GC_I_MAP_ID_BARBAROUS_SHORE
			Local $l_ai_Coords[2] = [-14568, 18472]

		Case $GC_I_MAP_ID_CAMP_HOJANU
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BARBAROUS_SHORE
					Local $l_ai_Coords[2] = [-13414, 17929]
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Local $l_ai_Coords[2] = [-20341, 19959]
			EndSwitch

		Case $GC_I_MAP_ID_BAHDOK_CAVERNS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
					Local $l_ai_Coords[2] = [-19987, 18328]
				Case $GC_I_MAP_ID_WEHHAN_TERRACES
					Local $l_ai_Coords[2] = [-13717, -10798]
			EndSwitch

		Case $GC_I_MAP_ID_WEHHAN_TERRACES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BAHDOK_CAVERNS
					Local $l_ai_Coords[2] = [5226, 3353]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Local $l_ai_Coords[2] = [-5184, -1499]
			EndSwitch

		Case $GC_I_MAP_ID_DEJARIN_ESTATE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CAMP_HOJANU
					Local $l_ai_Coords[2] = [20372, -20792]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Local $l_ai_Coords[2] = [-3335, 20537]
				Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
					Local $l_ai_Coords[2] = [-19953, -20733]
			EndSwitch

		Case $GC_I_MAP_ID_ARKJOK_WARD
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $l_ai_Coords[2] = [-13974, 17515]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $l_ai_Coords[2] = [10388, 19497]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $l_ai_Coords[2] = [-18754, 1]
				Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
					Local $l_ai_Coords[2] = [21141, -20689]
				Case $GC_I_MAP_ID_YOHLON_HAVEN
					Local $l_ai_Coords[2] = [-20484, -14570]
			EndSwitch

		Case $GC_I_MAP_ID_YOHLON_HAVEN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $l_ai_Coords[2] = [5178, 931]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $l_ai_Coords[2] = [-5563, 5062]
			EndSwitch

		Case $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS
			Local $l_ai_Coords[2] = [8953, 16864]

		Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $l_ai_Coords[2] = [-22541, -5817]
				Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
					Local $l_ai_Coords[2] = [-23328, -17560]
				Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
					Local $l_ai_Coords[2] = [12375, 11366]
				Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST
					Local $l_ai_Coords[2] = [-15491, 9449]
			EndSwitch

		Case $GC_I_MAP_ID_TURAIS_PROCESSION
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $l_ai_Coords[2] = [-701, -26240]
				Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
					Local $l_ai_Coords[2] = [-14379, 26053]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $l_ai_Coords[2] = [17238, -26265]
				Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
					Local $l_ai_Coords[2] = [-753, -26160]
			EndSwitch

		Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_COMMAND_POST
					Local $l_ai_Coords[2] = [-222, 4371]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $l_ai_Coords[2] = [-5050, -8143]
			EndSwitch

		Case $GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FORT_ASPENWOOD_KURZICK
					Local $l_ai_Coords[2] = [-6126, -1066]
				Case $GC_I_MAP_ID_FERNDALE
					Local $l_ai_Coords[2] = [-8072, -8851]
			EndSwitch

		Case $GC_I_MAP_ID_ASPENWOOD_GATE_LUXON
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FORT_ASPENWOOD_LUXON
					Local $l_ai_Coords[2] = [-1739, 8404]
				Case $GC_I_MAP_ID_MOUNT_QINKAI
					Local $l_ai_Coords[2] = [-5831, 14120]
			EndSwitch

		Case $GC_I_MAP_ID_JADE_FLATS_KURZICK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MELANDRUS_HOPE
					Local $l_ai_Coords[2] = [-8055, -13777]
				Case $GC_I_MAP_ID_THE_JADE_QUARRY_KURZICK
					Local $l_ai_Coords[2] = [-6590, -10151]
			EndSwitch

		Case $GC_I_MAP_ID_JADE_FLATS_LUXON
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARCHIPELAGOS
					Local $l_ai_Coords[2] = [6156, 17760]
				Case $GC_I_MAP_ID_THE_JADE_QUARRY_LUXON
					Local $l_ai_Coords[2] = [5616, 12941]
			EndSwitch

		Case $GC_I_MAP_ID_YATENDI_CANYONS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS
					Local $l_ai_Coords[2] = [-7145, -1526]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $l_ai_Coords[2] = [20616, 20473]
				Case $GC_I_MAP_ID_WEHHAN_TERRACES
					Local $l_ai_Coords[2] = [20228, -4431]
			EndSwitch

		Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DOMAIN_OF_ANGUISH
					Local $l_ai_Coords[2] = [-12981, -259]
				Case $GC_I_MAP_ID_THE_FISSURE_OF_WOE
					Local $l_ai_Coords[2] = [-10058, 1106]
				Case $GC_I_MAP_ID_THE_UNDERWORLD_EXPLORABLE
					Local $l_ai_Coords[2] = [-9205, 3901]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Local $l_ai_Coords[2] = [-5835, -1560]
			EndSwitch

		Case $GC_I_MAP_ID_GARDEN_OF_SEBORHIN
			Local $l_ai_Coords[2] = [2221, -17257]

		Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
					Local $l_ai_Coords[2] = [18126, -17235]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Local $l_ai_Coords[2] = [-17236, -16143]
			EndSwitch

		Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
					Local $l_ai_Coords[2] = [-703, 5114]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $l_ai_Coords[2] = [5150, -5126]
			EndSwitch

		Case $GC_I_MAP_ID_VEHJIN_MINES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BASALT_GROTTO
					Local $l_ai_Coords[2] = [-20469, 13716]
				Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
					Local $l_ai_Coords[2] = [16219, 8112]
				Case $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST
					Local $l_ai_Coords[2] = [18117, -17245]
			EndSwitch

		Case $GC_I_MAP_ID_BASALT_GROTTO
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $l_ai_Coords[2] = [-4284, -815]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Local $l_ai_Coords[2] = [4884, -2071]
			EndSwitch

		Case $GC_I_MAP_ID_FORUM_HIGHLANDS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GARDEN_OF_SEBORHIN
					Local $l_ai_Coords[2] = [-4552, 15863]
				Case $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST
					Local $l_ai_Coords[2] = [-23269, 17149]
				Case $GC_I_MAP_ID_NIGHTFALLEN_GARDEN
					Local $l_ai_Coords[2] = [-4552, 15863]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Local $l_ai_Coords[2] = [22886, 16725]
				Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
					Local $l_ai_Coords[2] = [-1078, 13607]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $l_ai_Coords[2] = [23710, -10986]
			EndSwitch

		Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BOKKA_AMPHITHEATRE
					Local $l_ai_Coords[2] = [-2008, -1931]
				Case $GC_I_MAP_ID_HONUR_HILL
					Local $l_ai_Coords[2] = [-18741, 13857]
				Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
					Local $l_ai_Coords[2] = [9621, 18595]
				Case $GC_I_MAP_ID_YAHNUR_MARKET
					Local $l_ai_Coords[2] = [-20129, -20330]
			EndSwitch

		Case $GC_I_MAP_ID_HONUR_HILL
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Local $l_ai_Coords[2] = [-18667, 13015]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $l_ai_Coords[2] = [-20241, 20472]
			EndSwitch

		Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
					Local $l_ai_Coords[2] = [-20237, 1485]
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Local $l_ai_Coords[2] = [7804, -20335]
			EndSwitch

		Case $GC_I_MAP_ID_VEHTENDI_VALLEY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Local $l_ai_Coords[2] = [-14457, -6466]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Local $l_ai_Coords[2] = [-8855, 19484]
				Case $GC_I_MAP_ID_YAHNUR_MARKET
					Local $l_ai_Coords[2] = [15354, -10067]
				Case $GC_I_MAP_ID_YATENDI_CANYONS
					Local $l_ai_Coords[2] = [-13852, -23177]
			EndSwitch
		Case $GC_I_MAP_ID_YAHNUR_MARKET
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
					Local $l_ai_Coords[2] = [5427, 4681]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $l_ai_Coords[2] = [-4914, 6267]
			EndSwitch

		Case $GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM
			Local $l_ai_Coords[2] = [1334, -20516] ; Exit to Dasha Vestibule (outpost)

		Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Local $l_ai_Coords[2] = [-5433, -5465]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $l_ai_Coords[2] = [-863, 5242]
				Case $GC_I_MAP_ID_VEHTENDI_VALLEY
					Local $l_ai_Coords[2] = [5678, -6101]
			EndSwitch

		Case $GC_I_MAP_ID_LIONS_GATE
			Local $l_ai_Coords[2] = [-1869, 1337] ; Exit to Lion's Arch

		Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
					Local $l_ai_Coords[2] = [11117, -7031]
				Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
					Local $l_ai_Coords[2] = [23744, 10544]
				Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
					Local $l_ai_Coords[2] = [1413, 8016]
				Case $GC_I_MAP_ID_HONUR_HILL
					Local $l_ai_Coords[2] = [23736, -17244]
				Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
					Local $l_ai_Coords[2] = [-23975, 17862]
				Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
					Local $l_ai_Coords[2] = [-19420, -17754]
			EndSwitch

		Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Local $l_ai_Coords[2] = [22653, 14067]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $l_ai_Coords[2] = [26258, 17503]
			EndSwitch

		Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Local $l_ai_Coords[2] = [3739, -4826]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $l_ai_Coords[2] = [-5114, 5242]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Local $l_ai_Coords[2] = [5050, 4858]
			EndSwitch

		Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST
			Local $l_ai_Coords[2] = [-15129, 8779] ; Exit to The Floodplain of Mahnkelon

		Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $l_ai_Coords[2] = [-4660, 5275]
				Case $GC_I_MAP_ID_DEJARIN_ESTATE
					Local $l_ai_Coords[2] = [5123, 4561]
				Case $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS
					Local $l_ai_Coords[2] = [2276, -5338]
			EndSwitch

		Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BAHDOK_CAVERNS
					Local $l_ai_Coords[2] = [-13675, -10509]
				Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
					Local $l_ai_Coords[2] = [-16141, -16614]
			EndSwitch
		Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
			Local $l_ai_Coords[2] = [-3193, 14727] ; Exit to Forum Highlands

		Case $GC_I_MAP_ID_CONSULATE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
					Local $l_ai_Coords[2] = [-4168, 16717]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [-6847, 16700]
			EndSwitch

		Case $GC_I_MAP_ID_PLAINS_OF_JARIN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CAVERNS_BELOW_KAMADAN
					Local $l_ai_Coords[2] = [13479, -13131]
				Case $GC_I_MAP_ID_CHAMPIONS_DAWN
					Local $l_ai_Coords[2] = [-19390, -13263]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [18340, -1891]
				Case $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
					Local $l_ai_Coords[2] = [-3102, 4510]
				Case $GC_I_MAP_ID_THE_ASTRALARIUM
					Local $l_ai_Coords[2] = [-20390, 16749]
			EndSwitch

		Case $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
			Local $l_ai_Coords[2] = [-3137, 3344] ; Exit to Plains of Jarin

		Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BEKNUR_HARBOR_2
					Local $l_ai_Coords[2] = [15068, -11202]
				Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
					Local $l_ai_Coords[2] = [-26546, -10889]
				Case $GC_I_MAP_ID_CHAMPIONS_DAWN
					Local $l_ai_Coords[2] = [23934, 6581]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Local $l_ai_Coords[2] = [-26404, 14074]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Local $l_ai_Coords[2] = [819, 14311]
			EndSwitch

		Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $l_ai_Coords[2] = [-5078, -2126]
				Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
					Local $l_ai_Coords[2] = [5217, 876]
			EndSwitch

		Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM
					Local $l_ai_Coords[2] = [1341, -20346]
				Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
					Local $l_ai_Coords[2] = [1122, -23773]
			EndSwitch

		Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
			Local $l_ai_Coords[2] = [-383, 7962] ; Exit to The Mirror of Lyss

		Case $GC_I_MAP_ID_COMMAND_POST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARKJOK_WARD
					Local $l_ai_Coords[2] = [5378, 3718]
				Case $GC_I_MAP_ID_JAHAI_BLUFFS
					Local $l_ai_Coords[2] = [5540, 7676]
				Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
					Local $l_ai_Coords[2] = [-655, 3507]
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Local $l_ai_Coords[2] = [-3672, 9654]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $l_ai_Coords[2] = [1907, 9184]
			EndSwitch

		Case $GC_I_MAP_ID_JOKOS_DOMAIN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BASALT_GROTTO
					Local $l_ai_Coords[2] = [20588, 15341]
				Case $GC_I_MAP_ID_BONE_PALACE
					Local $l_ai_Coords[2] = [-14545, 4045]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $l_ai_Coords[2] = [-4510, 21041]
				Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST
					Local $l_ai_Coords[2] = [-5101, -20152]
			EndSwitch

		Case $GC_I_MAP_ID_BONE_PALACE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $l_ai_Coords[2] = [-14545, 2655]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $l_ai_Coords[2] = [-20605, 7325]
			EndSwitch

		Case $GC_I_MAP_ID_THE_RUPTURED_HEART
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Local $l_ai_Coords[2] = [-19309, 1712]
				Case $GC_I_MAP_ID_POISONED_OUTCROPS
					Local $l_ai_Coords[2] = [21226, 18189]
				Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
					Local $l_ai_Coords[2] = [-2863, -17159]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $l_ai_Coords[2] = [-18419, -19037]
				Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
					Local $l_ai_Coords[2] = [-1485, -4751]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $l_ai_Coords[2] = [21253, 508]
			EndSwitch
		Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GATE_OF_TORMENT
					Local $l_ai_Coords[2] = [-1547, -4776]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $l_ai_Coords[2] = [-5161, -6900]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $l_ai_Coords[2] = [-10804, -11459]
				Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
					Local $l_ai_Coords[2] = [1103, 10901]
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $l_ai_Coords[2] = [-27297, -7264]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $l_ai_Coords[2] = [-26648, 6847]
			EndSwitch

		Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_POISONED_OUTCROPS
					Local $l_ai_Coords[2] = [3420, 5401]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $l_ai_Coords[2] = [-2397, -4986]
			EndSwitch

		Case $GC_I_MAP_ID_POISONED_OUTCROPS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
					Local $l_ai_Coords[2] = [14832, -10494]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $l_ai_Coords[2] = [-25812, -6562]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
					Local $l_ai_Coords[2] = [25950, -14012]
				Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST
					Local $l_ai_Coords[2] = [-4630, 17290]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ALKALI_PAN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BONE_PALACE
					Local $l_ai_Coords[2] = [20050, -2417]
				Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
					Local $l_ai_Coords[2] = [-19826, -2546]
				Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
					Local $l_ai_Coords[2] = [-3648, 11898]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $l_ai_Coords[2] = [-17698, 18421]
				Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
					Local $l_ai_Coords[2] = [20604, 18339]
			EndSwitch

		Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $l_ai_Coords[2] = [14264, -20911]
				Case $GC_I_MAP_ID_THE_ARID_SEA
					Local $l_ai_Coords[2] = [-10500, 9953]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $l_ai_Coords[2] = [14006, 20923]
			EndSwitch

		Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CHUURHIR_FIELDS
					Local $l_ai_Coords[2] = [-7421, 6336]
				Case $GC_I_MAP_ID_CONSULATE
					Local $l_ai_Coords[2] = [-5752, 16732]
				Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
					Local $l_ai_Coords[2] = [-4470, 10023]
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Local $l_ai_Coords[2] = [-9253, 17219]
				Case $GC_I_MAP_ID_SUN_DOCKS
					Local $l_ai_Coords[2] = [-5535, 14889]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_TORMENT
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_NIGHTFALLEN_JAHAI
					Local $l_ai_Coords[2] = [-7687, 14656]
				Case $GC_I_MAP_ID_THE_SHADOW_NEXUS_OUTPOST
					Local $l_ai_Coords[2] = [11459, 9372]
				Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
					Local $l_ai_Coords[2] = [1367, 7829]
			EndSwitch

		Case $GC_I_MAP_ID_NIGHTFALLEN_GARDEN
			Local $l_ai_Coords[2] = [0, 0]

		Case $GC_I_MAP_ID_CHUURHIR_FIELDS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
					Local $l_ai_Coords[2] = [3609, -5576]
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [-7218, 5805]
			EndSwitch

		Case $GC_I_MAP_ID_BEKNUR_HARBOR_2
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $l_ai_Coords[2] = [-19304, 14559]
				Case $GC_I_MAP_ID_ISSNUR_ISLES
					Local $l_ai_Coords[2] = [-15626, 11162]
			EndSwitch

		Case $GC_I_MAP_ID_HEART_OF_ABADDON
			Local $l_ai_Coords[2] = [19256, -1307] ; Exit to Abaddon's Gate (outpost)

		Case $GC_I_MAP_ID_NIGHTFALLEN_JAHAI
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
					Local $l_ai_Coords[2] = [18765, 17338]
				Case $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS
					Local $l_ai_Coords[2] = [-8531, 6833]
				Case $GC_I_MAP_ID_GATE_OF_TORMENT
					Local $l_ai_Coords[2] = [-2491, -17130]
			EndSwitch

		Case $GC_I_MAP_ID_DEPTHS_OF_MADNESS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
					Local $l_ai_Coords[2] = [-14892, -11927]
				Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
					Local $l_ai_Coords[2] = [15829, 15104]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GATE_OF_FEAR
					Local $l_ai_Coords[2] = [9921, 3934]
				Case $GC_I_MAP_ID_GATE_OF_SECRETS
					Local $l_ai_Coords[2] = [-10700, -2949]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_FEAR
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
					Local $l_ai_Coords[2] = [7811, 18636]
				Case $GC_I_MAP_ID_DOMAIN_OF_PAIN
					Local $l_ai_Coords[2] = [15664, 20026]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_PAIN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
					Local $l_ai_Coords[2] = [28970, -6380]
				Case $GC_I_MAP_ID_GATE_OF_FEAR
					Local $l_ai_Coords[2] = [-17911, 1025]
			EndSwitch

		Case $GC_I_MAP_ID_DOMAIN_OF_SECRETS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
					Local $l_ai_Coords[2] = [-9552, -10950]
				Case $GC_I_MAP_ID_GATE_OF_SECRETS
					Local $l_ai_Coords[2] = [15269, 20925]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_SECRETS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
					Local $l_ai_Coords[2] = [17683, -7198]
				Case $GC_I_MAP_ID_DOMAIN_OF_SECRETS
					Local $l_ai_Coords[2] = [11571, -1406]
			EndSwitch

		Case $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_FORUM_HIGHLANDS
					Local $l_ai_Coords[2] = [5082, -4922]
				Case $GC_I_MAP_ID_VEHJIN_MINES
					Local $l_ai_Coords[2] = [-5210, -2557]
			EndSwitch
		Case $GC_I_MAP_ID_NUNDU_BAY_OUTPOST
			Local $l_ai_Coords[2] = [-15567, -3573] ; Exit to Marga Coast

		Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
					Local $l_ai_Coords[2] = [-4798, 5504]
				Case $GC_I_MAP_ID_TURAIS_PROCESSION
					Local $l_ai_Coords[2] = [4864, -4918]
			EndSwitch

		Case $GC_I_MAP_ID_CHAMPIONS_DAWN
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $l_ai_Coords[2] = [23051, 6259]
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Local $l_ai_Coords[2] = [24006, 11766]
			EndSwitch

		Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_THE_ALKALI_PAN
					Local $l_ai_Coords[2] = [-3084, 11424]
				Case $GC_I_MAP_ID_THE_RUPTURED_HEART
					Local $l_ai_Coords[2] = [-2661, 20386]
			EndSwitch

		Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
					Local $l_ai_Coords[2] = [20341, -20322]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Local $l_ai_Coords[2] = [20499, 8882]
			EndSwitch

		Case $GC_I_MAP_ID_BJORA_MARCHES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DARKRIME_DELVES_LVL1
					Local $l_ai_Coords[2] = [-5983, 20195]
				Case $GC_I_MAP_ID_JAGA_MORAINE
					Local $l_ai_Coords[2] = [-20966, 5407]
				Case $GC_I_MAP_ID_LONGEYES_LEDGE
					Local $l_ai_Coords[2] = [20469, -19363]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $l_ai_Coords[2] = [-13697, -20828]
			EndSwitch

		Case $GC_I_MAP_ID_ZEHLON_REACH
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $l_ai_Coords[2] = [8899, -20186]
				Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
					Local $l_ai_Coords[2] = [-20337, -20311]
				Case $GC_I_MAP_ID_THE_ASTRALARIUM
					Local $l_ai_Coords[2] = [19968, -2752]
			EndSwitch

		Case $GC_I_MAP_ID_LAHTEDA_BOG
			Local $l_ai_Coords[2] = [6445, 20893] ; Exit to Blacktide Den (outpost)

		Case $GC_I_MAP_ID_ARBOR_BAY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Local $l_ai_Coords[2] = [-20656, -20081]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Local $l_ai_Coords[2] = [-20709, 9896]
				Case $GC_I_MAP_ID_SHARDS_OF_ORR_LVL1
					Local $l_ai_Coords[2] = [8873, -20635]
				Case $GC_I_MAP_ID_VLOXS_FALLS
					Local $l_ai_Coords[2] = [15807, 13350]
			EndSwitch

		Case $GC_I_MAP_ID_ISSNUR_ISLES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BEKNUR_HARBOR_2
					Local $l_ai_Coords[2] = [-16228, 11334]
				Case $GC_I_MAP_ID_KODLONU_HAMLET
					Local $l_ai_Coords[2] = [29496, 6900]
			EndSwitch

		Case $GC_I_MAP_ID_MEHTANI_KEYS
			Local $l_ai_Coords[2] = [-20492, 11463] ; Exit to Kodlonu Hamlet

		Case $GC_I_MAP_ID_KODLONU_HAMLET
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ISSNUR_ISLES
					Local $l_ai_Coords[2] = [-4775, -2327]
				Case $GC_I_MAP_ID_MEHTANI_KEYS
					Local $l_ai_Coords[2] = [4554, -3559]
			EndSwitch

;~ 		Case $GC_I_MAP_ID_ISLAND_OF_SHEHKAH
;~ 			Local $l_ai_Coords[2] = [0, 0] ; Exit to Chahbek Village

		Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $l_ai_Coords[2] = [5088, -4651]
				Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
					Local $l_ai_Coords[2] = [-2869, -1032]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Local $l_ai_Coords[2] = [4871, 4430]
			EndSwitch

		Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
					Local $l_ai_Coords[2] = [4649, 4873]
				Case $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY
					Local $l_ai_Coords[2] = [-4581, 5164]
				Case $GC_I_MAP_ID_LAHTEDA_BOG
					Local $l_ai_Coords[2] = [421, -4841]
			EndSwitch

		Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BEJUNKAN_PIER
					Local $l_ai_Coords[2] = [-4969, 16683]
				Case $GC_I_MAP_ID_CONSULATE
					Local $l_ai_Coords[2] = [-2799, 16719]
				Case $GC_I_MAP_ID_LIONS_GATE
					Local $l_ai_Coords[2] = [-4969, 16683]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
			Local $l_ai_Coords[2] = [-17250, 5367]

		Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
			Local $l_ai_Coords[2] = [-16811, -13684]

		Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_HEART_OF_ABADDON
					Local $l_ai_Coords[2] = [18708, -1915]
				Case $GC_I_MAP_ID_DEPTHS_OF_MADNESS
					Local $l_ai_Coords[2] = [19498, -7235]
			EndSwitch

		Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BOREAL_STATION
					Local $l_ai_Coords[2] = [5456, -27830]
				Case $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST, $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST_WINTERSDAY
					Local $l_ai_Coords[2] = [478, 1293]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $l_ai_Coords[2] = [-3950, 28261]
				Case $GC_I_MAP_ID_BATTLEDEPTHS
					Local $l_ai_Coords[2] = [-10551, -3947]
			EndSwitch

		Case $GC_I_MAP_ID_BOKKA_AMPHITHEATRE
			Local $l_ai_Coords[2] = [-2549, -1419]

		Case $GC_I_MAP_ID_RIVEN_EARTH
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Local $l_ai_Coords[2] = [-8847, -14534]
				Case $GC_I_MAP_ID_ARBOR_BAY
					Local $l_ai_Coords[2] = [26276, 1779]
				Case $GC_I_MAP_ID_RATA_SUM
					Local $l_ai_Coords[2] = [-27091, -4113]
			EndSwitch

		Case $GC_I_MAP_ID_THE_ASTRALARIUM
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_PLAINS_OF_JARIN
					Local $l_ai_Coords[2] = [5050, 897]
				Case $GC_I_MAP_ID_ZEHLON_REACH
					Local $l_ai_Coords[2] = [-4922, -317]
			EndSwitch

		Case $GC_I_MAP_ID_THRONE_OF_SECRETS
			Local $l_ai_Coords[2] = [-19134, 6234]

		Case $GC_I_MAP_ID_DRAKKAR_LAKE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $l_ai_Coords[2] = [17885, -16610]
				Case $GC_I_MAP_ID_SEPULCHRE_OF_DRAGRIMMAR_LVL1
					Local $l_ai_Coords[2] = [-11999, 26657]
				Case $GC_I_MAP_ID_SIFHALLA
					Local $l_ai_Coords[2] = [13547, 19779]
				Case $GC_I_MAP_ID_VARAJAR_FELLS_1
					Local $l_ai_Coords[2] = [-10920, -26639]
			EndSwitch

		Case $GC_I_MAP_ID_SUN_DOCKS
			Local $l_ai_Coords[2] = [-6425, 14927] ; Exit to Kamadan, Jewel of Istan

		Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_JOKOS_DOMAIN
					Local $l_ai_Coords[2] = [1646, 4795]
				Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
					Local $l_ai_Coords[2] = [2364, -4657]
			EndSwitch

		Case $GC_I_MAP_ID_JAGA_MORAINE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Local $l_ai_Coords[2] = [16242, -20629]
				Case $GC_I_MAP_ID_FROSTMAWS_BURROWS_LVL1
					Local $l_ai_Coords[2] = [1666, 26826]
				Case $GC_I_MAP_ID_SIFHALLA
					Local $l_ai_Coords[2] = [-13506, -24262]
			EndSwitch

		Case $GC_I_MAP_ID_NORRHART_DOMAINS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Local $l_ai_Coords[2] = [16783, 17396]
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Local $l_ai_Coords[2] = [-26824, 11216]
				Case $GC_I_MAP_ID_GUNNARS_HOLD
					Local $l_ai_Coords[2] = [15583, -6507]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Local $l_ai_Coords[2] = [11140, -14202]
				Case $GC_I_MAP_ID_VARAJAR_FELLS_1
					Local $l_ai_Coords[2] = [-26334, -14031]
			EndSwitch

		Case $GC_I_MAP_ID_VARAJAR_FELLS_1
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BATTLEDEPTHS
					Local $l_ai_Coords[2] = [26914, -9268]
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Local $l_ai_Coords[2] = [-1580, 17454]
				Case $GC_I_MAP_ID_RAVENS_POINT_LVL1
					Local $l_ai_Coords[2] = [-26531, 16736]
				Case $GC_I_MAP_ID_OLAFSTEAD
					Local $l_ai_Coords[2] = [-192, 1220]
				Case $GC_I_MAP_ID_NORRHART_DOMAINS
					Local $l_ai_Coords[2] = [26339, 17311]
				Case $GC_I_MAP_ID_VERDANT_CASCADES
					Local $l_ai_Coords[2] = [-26531, -13578]
			EndSwitch

		Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [-2522, -2495]
				Case $GC_I_MAP_ID_MARGA_COAST
					Local $l_ai_Coords[2] = [5341, -5120]
				Case $GC_I_MAP_ID_SUNWARD_MARCHES
					Local $l_ai_Coords[2] = [-3753, 4670]
			EndSwitch

		Case $GC_I_MAP_ID_THE_SHADOW_NEXUS_OUTPOST
			Local $l_ai_Coords[2] = [10, -6606]

		Case $GC_I_MAP_ID_SPARKFLY_SWAMP
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GADDS_ENCAMPMENT
					Local $l_ai_Coords[2] = [-9642, -20805]
				Case $GC_I_MAP_ID_BLOODSTONE_CAVES_LVL1
					Local $l_ai_Coords[2] = [12355, -26161]
				Case $GC_I_MAP_ID_BOGROOT_GROWTHS_LVL1
					Local $l_ai_Coords[2] = [13186, 26596]
			EndSwitch

		Case $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS
			Local $l_ai_Coords[2] = [-16100, 18562]

		Case $GC_I_MAP_ID_VERDANT_CASCADES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SLAVERS_EXILE
					Local $l_ai_Coords[2] = [25667, -9043]
				Case $GC_I_MAP_ID_UMBRAL_GROTTO
					Local $l_ai_Coords[2] = [-23107, 6992]
				Case $GC_I_MAP_ID_VARAJAR_FELLS_1
					Local $l_ai_Coords[2] = [26658, 12648]
			EndSwitch

		Case $GC_I_MAP_ID_MAGUS_STONES
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ALCAZIA_TANGLE
					Local $l_ai_Coords[2] = [20832, -7311]
				Case $GC_I_MAP_ID_ARACHNIS_HAUNT_LVL1
					Local $l_ai_Coords[2] = [-11477, -19244]
				Case $GC_I_MAP_ID_OOLAS_LAB_LVL1
					Local $l_ai_Coords[2] = [-20435, 8063]
				Case $GC_I_MAP_ID_RATA_SUM
					Local $l_ai_Coords[2] = [16414, 14111]
			EndSwitch

		Case $GC_I_MAP_ID_ALCAZIA_TANGLE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARBOR_BAY
					Local $l_ai_Coords[2] = [26669, 14014]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Local $l_ai_Coords[2] = [-3761, 17561]
				Case $GC_I_MAP_ID_MAGUS_STONES
					Local $l_ai_Coords[2] = [-26669, 9697]
				Case $GC_I_MAP_ID_TARNISHED_HAVEN
					Local $l_ai_Coords[2] = [19532, -11416]
			EndSwitch

		Case $GC_I_MAP_ID_VLOXS_FALLS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_ARBOR_BAY
					Local $l_ai_Coords[2] = [15391, 12320]
				Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS_LVL1
					Local $l_ai_Coords[2] = [19915, 19690]
			EndSwitch

		Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS_LVL1
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_VLOXS_FALLS
					Local $l_ai_Coords[2] = [-20122, -11955]
			EndSwitch

		Case $GC_I_MAP_ID_BATTLEDEPTHS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_HEART_OF_THE_SHIVERPEAKS_LVL1
					Local $l_ai_Coords[2] = [5941, 7929]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Local $l_ai_Coords[2] = [21367, 15167]
				Case $GC_I_MAP_ID_VARAJAR_FELLS_1
					Local $l_ai_Coords[2] = [-6701, 19891]
				Case $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER
					Local $l_ai_Coords[2] = [-2921, 11612]
			EndSwitch

		Case $GC_I_MAP_ID_GADDS_ENCAMPMENT
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_SPARKFLY_SWAMP
					Local $l_ai_Coords[2] = [-9545, -20058]
				Case $GC_I_MAP_ID_SHARDS_OF_ORR_LVL1
					Local $l_ai_Coords[2] = [-12819, -24885]
			EndSwitch

		Case $GC_I_MAP_ID_UMBRAL_GROTTO
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_VERDANT_CASCADES
					Local $l_ai_Coords[2] = [-22872, 6410]
				Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS_LVL1
					Local $l_ai_Coords[2] = [-26174, 10549]
			EndSwitch

		Case $GC_I_MAP_ID_RATA_SUM
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_MAGUS_STONES
					Local $l_ai_Coords[2] = [16404, 13482]
				Case $GC_I_MAP_ID_RIVEN_EARTH
					Local $l_ai_Coords[2] = [20384, 16874]
			EndSwitch

		Case $GC_I_MAP_ID_TARNISHED_HAVEN
			Local $l_ai_Coords[2] = [18994, -10402] ; Exit to Alcazia Tangle

		Case $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST, $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST_WINTERSDAY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_HALL_OF_MONUMENTS
					Local $l_ai_Coords[2] = [-4919, 5341]
				Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
					Local $l_ai_Coords[2] = [1054, 874]
			EndSwitch

		Case $GC_I_MAP_ID_SIFHALLA
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DRAKKAR_LAKE
					Local $l_ai_Coords[2] = [13551, 18970]
				Case $GC_I_MAP_ID_JAGA_MORAINE
					Local $l_ai_Coords[2] = [16727, 22872]
			EndSwitch

		Case $GC_I_MAP_ID_GUNNARS_HOLD
			Local $l_ai_Coords[2] = [14979, -6325]

		Case $GC_I_MAP_ID_OLAFSTEAD
			Local $l_ai_Coords[2] = [-1578, 1232]

		Case $GC_I_MAP_ID_HALL_OF_MONUMENTS
			Local $l_ai_Coords[2] = [-4416, 4935]

		Case $GC_I_MAP_ID_DALADA_UPLANDS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DOOMLORE_SHRINE
					Local $l_ai_Coords[2] = [-15813, 14307]
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Local $l_ai_Coords[2] = [-20777, 434]
				Case $GC_I_MAP_ID_SACNOTH_VALLEY
					Local $l_ai_Coords[2] = [14468, -20702]
			EndSwitch

		Case $GC_I_MAP_ID_DOOMLORE_SHRINE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Local $l_ai_Coords[2] = [-15360, 13408]
				Case $GC_I_MAP_ID_CATHEDRAL_OF_FLAMES
					Local $l_ai_Coords[2] = [-19166, 17980]
			EndSwitch

		Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Local $l_ai_Coords[2] = [25537, 15372]
				Case $GC_I_MAP_ID_LONGEYES_LEDGE
					Local $l_ai_Coords[2] = [-22051, 13044]
				Case $GC_I_MAP_ID_OOZE_PIT
					Local $l_ai_Coords[2] = [8829, -13368]
				Case $GC_I_MAP_ID_SACNOTH_VALLEY
					Local $l_ai_Coords[2] = [23313, -13368]
			EndSwitch

		Case $GC_I_MAP_ID_LONGEYES_LEDGE
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_BJORA_MARCHES
					Local $l_ai_Coords[2] = [-26677, 16397]
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Local $l_ai_Coords[2] = [-21482, 12387]
			EndSwitch

		Case $GC_I_MAP_ID_SACNOTH_VALLEY
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
					Local $l_ai_Coords[2] = [-20508, 15908]
				Case $GC_I_MAP_ID_DALADA_UPLANDS
					Local $l_ai_Coords[2] = [12733, 18648]
				Case $GC_I_MAP_ID_CATACOMBS_OF_KATHANDRAX
					Local $l_ai_Coords[2] = [19275, -16228]
				Case $GC_I_MAP_ID_RRAGARS_MENAGERIE_LVL1
					Local $l_ai_Coords[2] = [-19460, -15952]
			EndSwitch

		Case $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER
			Local $l_ai_Coords[2] = [-19, 4822] ; Exit to Battledepths

		Case $GC_I_MAP_ID_BOREAL_STATION
			Local $l_ai_Coords[2] = [4297, -27853] ; Exit to Ice Cliff Chasms

			;Case $GC_I_MAP_ID_BENEATH_LIONS_ARCH = 691 ; Special
			;Case $GC_I_MAP_ID_TUNNELS_BELOW_CANTHA = 692 ; Special
			;Case $GC_I_MAP_ID_CAVERNS_BELOW_KAMADAN = 693 ; Special
			;Case $GC_I_MAP_ID_WAR_IN_KRYTA_TALMARK_WILDERNESS = 837 ; War in Kryta
			;Case $GC_I_MAP_ID_TRIAL_OF_ZINN = 838 ; Special
			;Case $GC_I_MAP_ID_DIVINITY_COAST_EXPLORABLE = 839 ; War in Kryta
		Case $GC_I_MAP_ID_LIONS_ARCH_KEEP
			Switch $a_i_ToMapID
				Case $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
					Local $l_ai_Coords[2] = [7611, 10627]
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
			Out($g_a2D_MapArray[$a_i_FromMapID][1] & " to " & $g_a2D_MapArray[$a_i_ToMapID][1])
			Return False
	EndSwitch

	Return $l_ai_Coords
EndFunc   ;==>Map_GetExitPortalsCoords

#Region Inter-Map Pathfinding
; =============================================================================
; Map_GetConnectedMaps - Returns an array of all maps directly connected to $a_i_MapID
; @param $a_i_MapID: The source map ID
; @return: Array of connected map IDs, or empty array if none
; =============================================================================
Func Map_GetConnectedMaps($a_i_MapID)
	Local $l_a_Connected[0]

	Switch $a_i_MapID
		; === Prophecies - Ascalon ===
		Case $GC_I_MAP_ID_ASCALON_CITY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_OLD_ASCALON, $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST]
		Case $GC_I_MAP_ID_OLD_ASCALON
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ASCALON_CITY, $GC_I_MAP_ID_REGENT_VALLEY, $GC_I_MAP_ID_SARDELAC_SANITARIUM, $GC_I_MAP_ID_THE_BREACH]
		Case $GC_I_MAP_ID_REGENT_VALLEY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FORT_RANIK_OUTPOST, $GC_I_MAP_ID_OLD_ASCALON, $GC_I_MAP_ID_POCKMARK_FLATS]
		Case $GC_I_MAP_ID_THE_BREACH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DIESSA_LOWLANDS, $GC_I_MAP_ID_OLD_ASCALON, $GC_I_MAP_ID_PIKEN_SQUARE]
		Case $GC_I_MAP_ID_DIESSA_LOWLANDS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ASCALON_FOOTHILLS, $GC_I_MAP_ID_GRENDICH_COURTHOUSE, $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR, $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST, $GC_I_MAP_ID_THE_BREACH]
		Case $GC_I_MAP_ID_ASCALON_FOOTHILLS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DIESSA_LOWLANDS, $GC_I_MAP_ID_TRAVELERS_VALE]
		Case $GC_I_MAP_ID_POCKMARK_FLATS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_EASTERN_FRONTIER, $GC_I_MAP_ID_REGENT_VALLEY, $GC_I_MAP_ID_SERENITY_TEMPLE]
		Case $GC_I_MAP_ID_EASTERN_FRONTIER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FRONTIER_GATE, $GC_I_MAP_ID_POCKMARK_FLATS, $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST]
		Case $GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DIESSA_LOWLANDS, $GC_I_MAP_ID_DRAGONS_GULLET]

			; === Prophecies - Northern Shiverpeaks ===
		Case $GC_I_MAP_ID_TRAVELERS_VALE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ASCALON_FOOTHILLS, $GC_I_MAP_ID_BORLIS_PASS_OUTPOST, $GC_I_MAP_ID_IRON_HORSE_MINE, $GC_I_MAP_ID_YAKS_BEND]
		Case $GC_I_MAP_ID_IRON_HORSE_MINE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ANVIL_ROCK, $GC_I_MAP_ID_TRAVELERS_VALE]
		Case $GC_I_MAP_ID_ANVIL_ROCK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DELDRIMOR_BOWL, $GC_I_MAP_ID_ICE_TOOTH_CAVE, $GC_I_MAP_ID_IRON_HORSE_MINE, $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST]
		Case $GC_I_MAP_ID_DELDRIMOR_BOWL
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ANVIL_ROCK, $GC_I_MAP_ID_BEACONS_PERCH, $GC_I_MAP_ID_GRIFFONS_MOUTH]
		Case $GC_I_MAP_ID_GRIFFONS_MOUTH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SCOUNDRELS_RISE, $GC_I_MAP_ID_DELDRIMOR_BOWL]
		Case $GC_I_MAP_ID_BEACONS_PERCH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DELDRIMOR_BOWL, $GC_I_MAP_ID_LORNARS_PASS]
		Case $GC_I_MAP_ID_LORNARS_PASS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BEACONS_PERCH, $GC_I_MAP_ID_DREADNOUGHTS_DRIFT]
		Case $GC_I_MAP_ID_DREADNOUGHTS_DRIFT
			Local $l_a_Connected[] = [$GC_I_MAP_ID_LORNARS_PASS, $GC_I_MAP_ID_SNAKE_DANCE]

			; === Prophecies - Kryta ===
		Case $GC_I_MAP_ID_SCOUNDRELS_RISE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST, $GC_I_MAP_ID_GRIFFONS_MOUTH, $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE]
		Case $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BENEATH_LIONS_ARCH, $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST, $GC_I_MAP_ID_LIONS_ARCH, $GC_I_MAP_ID_NEBO_TERRACE, $GC_I_MAP_ID_SCOUNDRELS_RISE]
		Case $GC_I_MAP_ID_LIONS_ARCH, $GC_I_MAP_ID_LIONS_ARCH_HALLOWEEN, $GC_I_MAP_ID_LIONS_ARCH_WINTERSDAY, $GC_I_MAP_ID_LIONS_ARCH_CANTHAN_NEW_YEAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NORTH_KRYTA_PROVINCE, $GC_I_MAP_ID_LIONS_GATE, $GC_I_MAP_ID_LIONS_ARCH_KEEP]
		Case $GC_I_MAP_ID_NEBO_TERRACE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BEETLETUN, $GC_I_MAP_ID_BERGEN_HOT_SPRINGS, $GC_I_MAP_ID_CURSED_LANDS, $GC_I_MAP_ID_NORTH_KRYTA_PROVINCE]
		Case $GC_I_MAP_ID_BEETLETUN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NEBO_TERRACE, $GC_I_MAP_ID_WATCHTOWER_COAST]
		Case $GC_I_MAP_ID_WATCHTOWER_COAST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BEETLETUN, $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST]
		Case $GC_I_MAP_ID_CURSED_LANDS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NEBO_TERRACE, $GC_I_MAP_ID_THE_BLACK_CURTAIN]
		Case $GC_I_MAP_ID_THE_BLACK_CURTAIN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TALMARK_WILDERNESS, $GC_I_MAP_ID_KESSEX_PEAK, $GC_I_MAP_ID_CURSED_LANDS, $GC_I_MAP_ID_TEMPLE_OF_THE_AGES]
		Case $GC_I_MAP_ID_TALMARK_WILDERNESS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MAJESTYS_REST, $GC_I_MAP_ID_TEARS_OF_THE_FALLEN, $GC_I_MAP_ID_THE_BLACK_CURTAIN]
		Case $GC_I_MAP_ID_TEARS_OF_THE_FALLEN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_STINGRAY_STRAND, $GC_I_MAP_ID_TALMARK_WILDERNESS, $GC_I_MAP_ID_TWIN_SERPENT_LAKES]
		Case $GC_I_MAP_ID_STINGRAY_STRAND
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FISHERMENS_HAVEN, $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST, $GC_I_MAP_ID_TEARS_OF_THE_FALLEN]
		Case $GC_I_MAP_ID_TWIN_SERPENT_LAKES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST, $GC_I_MAP_ID_TEARS_OF_THE_FALLEN]
		Case $GC_I_MAP_ID_MAJESTYS_REST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SAGE_LANDS, $GC_I_MAP_ID_TALMARK_WILDERNESS]
		Case $GC_I_MAP_ID_TEMPLE_OF_THE_AGES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_BLACK_CURTAIN]

			; === Prophecies - Maguuma Jungle ===
		Case $GC_I_MAP_ID_SAGE_LANDS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DRUIDS_OVERLOOK, $GC_I_MAP_ID_MAJESTYS_REST, $GC_I_MAP_ID_MAMNOON_LAGOON, $GC_I_MAP_ID_THE_WILDS_OUTPOST]
		Case $GC_I_MAP_ID_MAMNOON_LAGOON
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SAGE_LANDS, $GC_I_MAP_ID_SILVERWOOD]
		Case $GC_I_MAP_ID_SILVERWOOD
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BLOODSTONE_FEN_OUTPOST, $GC_I_MAP_ID_ETTINS_BACK, $GC_I_MAP_ID_MAMNOON_LAGOON, $GC_I_MAP_ID_QUARREL_FALLS]
		Case $GC_I_MAP_ID_ETTINS_BACK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_AURORA_GLADE_OUTPOST, $GC_I_MAP_ID_DRY_TOP, $GC_I_MAP_ID_REED_BOG, $GC_I_MAP_ID_SILVERWOOD, $GC_I_MAP_ID_VENTARIS_REFUGE]
		Case $GC_I_MAP_ID_REED_BOG
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ETTINS_BACK, $GC_I_MAP_ID_THE_FALLS]
		Case $GC_I_MAP_ID_THE_FALLS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_REED_BOG]
		Case $GC_I_MAP_ID_DRY_TOP
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ETTINS_BACK, $GC_I_MAP_ID_TANGLE_ROOT]
		Case $GC_I_MAP_ID_TANGLE_ROOT
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DRY_TOP, $GC_I_MAP_ID_HENGE_OF_DENRAVI, $GC_I_MAP_ID_MAGUUMA_STADE, $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST]

			; === Prophecies - Crystal Desert ===
		Case $GC_I_MAP_ID_AUGURY_ROCK_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PROPHETS_PATH, $GC_I_MAP_ID_SKYWARD_REACH]
		Case $GC_I_MAP_ID_PROPHETS_PATH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_AUGURY_ROCK_OUTPOST, $GC_I_MAP_ID_HEROES_AUDIENCE, $GC_I_MAP_ID_SALT_FLATS, $GC_I_MAP_ID_THE_AMNOON_OASIS, $GC_I_MAP_ID_VULTURE_DRIFTS]
		Case $GC_I_MAP_ID_SALT_FLATS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DIVINERS_ASCENT, $GC_I_MAP_ID_SEEKERS_PASSAGE, $GC_I_MAP_ID_PROPHETS_PATH, $GC_I_MAP_ID_SKYWARD_REACH]
		Case $GC_I_MAP_ID_SKYWARD_REACH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_AUGURY_ROCK_OUTPOST, $GC_I_MAP_ID_DESTINYS_GORGE, $GC_I_MAP_ID_DIVINERS_ASCENT, $GC_I_MAP_ID_SALT_FLATS, $GC_I_MAP_ID_THE_ARID_SEA, $GC_I_MAP_ID_THE_SCAR, $GC_I_MAP_ID_VULTURE_DRIFTS]
		Case $GC_I_MAP_ID_DIVINERS_ASCENT
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ELONA_REACH_OUTPOST, $GC_I_MAP_ID_SALT_FLATS, $GC_I_MAP_ID_SKYWARD_REACH]
		Case $GC_I_MAP_ID_VULTURE_DRIFTS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST, $GC_I_MAP_ID_PROPHETS_PATH, $GC_I_MAP_ID_SKYWARD_REACH, $GC_I_MAP_ID_THE_ARID_SEA]
		Case $GC_I_MAP_ID_THE_ARID_SEA
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CRYSTAL_OVERLOOK, $GC_I_MAP_ID_SKYWARD_REACH, $GC_I_MAP_ID_VULTURE_DRIFTS]
		Case $GC_I_MAP_ID_THE_SCAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DESTINYS_GORGE, $GC_I_MAP_ID_SKYWARD_REACH, $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST]
		Case $GC_I_MAP_ID_DESTINYS_GORGE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SKYWARD_REACH, $GC_I_MAP_ID_THE_SCAR]
		Case $GC_I_MAP_ID_CRYSTAL_OVERLOOK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_ALKALI_PAN, $GC_I_MAP_ID_THE_ARID_SEA, $GC_I_MAP_ID_THE_RUPTURED_HEART]

			; === Prophecies - Southern Shiverpeaks ===
		Case $GC_I_MAP_ID_SNAKE_DANCE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CAMP_RANKOR, $GC_I_MAP_ID_DREADNOUGHTS_DRIFT, $GC_I_MAP_ID_GRENTHS_FOOTPRINT]
		Case $GC_I_MAP_ID_CAMP_RANKOR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SNAKE_DANCE, $GC_I_MAP_ID_TALUS_CHUTE]
		Case $GC_I_MAP_ID_TALUS_CHUTE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CAMP_RANKOR, $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY, $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST, $GC_I_MAP_ID_ICEDOME]
		Case $GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TALUS_CHUTE, $GC_I_MAP_ID_WITMANS_FOLLY]
		Case $GC_I_MAP_ID_WITMANS_FOLLY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DROKNARS_FORGE, $GC_I_MAP_ID_DROKNARS_FORGE_HALLOWEEN, $GC_I_MAP_ID_DROKNARS_FORGE_WINTERSDAY, $GC_I_MAP_ID_PORT_SLEDGE]
		Case $GC_I_MAP_ID_ICEDOME
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FROZEN_FOREST, $GC_I_MAP_ID_TALUS_CHUTE]
		Case $GC_I_MAP_ID_FROZEN_FOREST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_COPPERHAMMER_MINES, $GC_I_MAP_ID_ICE_FLOE, $GC_I_MAP_ID_ICEDOME, $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST]
		Case $GC_I_MAP_ID_ICE_FLOE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FROZEN_FOREST, $GC_I_MAP_ID_MARHANS_GROTTO, $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST]
		Case $GC_I_MAP_ID_COPPERHAMMER_MINES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FROZEN_FOREST, $GC_I_MAP_ID_SPEARHEAD_PEAK]
		Case $GC_I_MAP_ID_SPEARHEAD_PEAK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_COPPERHAMMER_MINES, $GC_I_MAP_ID_GRENTHS_FOOTPRINT, $GC_I_MAP_ID_THE_GRANITE_CITADEL]
		Case $GC_I_MAP_ID_GRENTHS_FOOTPRINT
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DELDRIMOR_WAR_CAMP, $GC_I_MAP_ID_SNAKE_DANCE, $GC_I_MAP_ID_SORROWS_FURNACE, $GC_I_MAP_ID_SPEARHEAD_PEAK]
		Case $GC_I_MAP_ID_THE_GRANITE_CITADEL
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SPEARHEAD_PEAK, $GC_I_MAP_ID_TASCAS_DEMISE]
		Case $GC_I_MAP_ID_TASCAS_DEMISE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MINERAL_SPRINGS, $GC_I_MAP_ID_THE_GRANITE_CITADEL]

			; === Prophecies - Ring of Fire ===
		Case $GC_I_MAP_ID_PERDITION_ROCK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_EMBER_LIGHT_CAMP, $GC_I_MAP_ID_RING_OF_FIRE_OUTPOST]

			; === Prophecies - Outposts with single exits ===
		Case $GC_I_MAP_ID_BLOODSTONE_FEN_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SILVERWOOD]
		Case $GC_I_MAP_ID_THE_WILDS_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SAGE_LANDS]
		Case $GC_I_MAP_ID_AURORA_GLADE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ETTINS_BACK]
		Case $GC_I_MAP_ID_GATES_OF_KRYTA_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SCOUNDRELS_RISE]
		Case $GC_I_MAP_ID_DALESSIO_SEABOARD_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NORTH_KRYTA_PROVINCE]
		Case $GC_I_MAP_ID_DIVINITY_COAST_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_WATCHTOWER_COAST]
		Case $GC_I_MAP_ID_SANCTUM_CAY_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_STINGRAY_STRAND]
		Case $GC_I_MAP_ID_THE_FROST_GATE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ANVIL_ROCK]
		Case $GC_I_MAP_ID_ICE_CAVES_OF_SORROW_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TALUS_CHUTE]
		Case $GC_I_MAP_ID_THUNDERHEAD_KEEP_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ICE_FLOE]
		Case $GC_I_MAP_ID_IRON_MINES_OF_MOLADUNE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FROZEN_FOREST]
		Case $GC_I_MAP_ID_BORLIS_PASS_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TRAVELERS_VALE]
		Case $GC_I_MAP_ID_THE_GREAT_NORTHERN_WALL_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ASCALON_CITY]
		Case $GC_I_MAP_ID_FORT_RANIK_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_REGENT_VALLEY]
		Case $GC_I_MAP_ID_RUINS_OF_SURMIA_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_EASTERN_FRONTIER]
		Case $GC_I_MAP_ID_NOLANI_ACADEMY_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DIESSA_LOWLANDS]
		Case $GC_I_MAP_ID_GRENDICH_COURTHOUSE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DIESSA_LOWLANDS]
		Case $GC_I_MAP_ID_PIKEN_SQUARE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_BREACH]
		Case $GC_I_MAP_ID_SARDELAC_SANITARIUM
			Local $l_a_Connected[] = [$GC_I_MAP_ID_OLD_ASCALON]
		Case $GC_I_MAP_ID_SERENITY_TEMPLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_POCKMARK_FLATS]
		Case $GC_I_MAP_ID_FRONTIER_GATE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_EASTERN_FRONTIER]
		Case $GC_I_MAP_ID_YAKS_BEND
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TRAVELERS_VALE]
		Case $GC_I_MAP_ID_ICE_TOOTH_CAVE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ANVIL_ROCK]
		Case $GC_I_MAP_ID_HENGE_OF_DENRAVI
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TANGLE_ROOT]
		Case $GC_I_MAP_ID_VENTARIS_REFUGE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ETTINS_BACK]
		Case $GC_I_MAP_ID_DRUIDS_OVERLOOK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SAGE_LANDS]
		Case $GC_I_MAP_ID_MAGUUMA_STADE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TANGLE_ROOT]
		Case $GC_I_MAP_ID_QUARREL_FALLS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SILVERWOOD]
		Case $GC_I_MAP_ID_BERGEN_HOT_SPRINGS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NEBO_TERRACE]
		Case $GC_I_MAP_ID_FISHERMENS_HAVEN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_STINGRAY_STRAND]
		Case $GC_I_MAP_ID_RIVERSIDE_PROVINCE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TANGLE_ROOT, $GC_I_MAP_ID_TWIN_SERPENT_LAKES]
		Case $GC_I_MAP_ID_KESSEX_PEAK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_BLACK_CURTAIN]
		Case $GC_I_MAP_ID_DUNES_OF_DESPAIR_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_VULTURE_DRIFTS]
		Case $GC_I_MAP_ID_THIRSTY_RIVER_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_SCAR]
		Case $GC_I_MAP_ID_ELONA_REACH_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DIVINERS_ASCENT]
		Case $GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS]
		Case $GC_I_MAP_ID_THE_AMNOON_OASIS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PROPHETS_PATH]
		Case $GC_I_MAP_ID_HEROES_AUDIENCE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PROPHETS_PATH]
		Case $GC_I_MAP_ID_SEEKERS_PASSAGE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SALT_FLATS]
		Case $GC_I_MAP_ID_DELDRIMOR_WAR_CAMP
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GRENTHS_FOOTPRINT]
		Case $GC_I_MAP_ID_MINERAL_SPRINGS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TASCAS_DEMISE]
		Case $GC_I_MAP_ID_PORT_SLEDGE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_WITMANS_FOLLY]
		Case $GC_I_MAP_ID_MARHANS_GROTTO
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ICE_FLOE]
		Case $GC_I_MAP_ID_EMBER_LIGHT_CAMP
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PERDITION_ROCK]
		Case $GC_I_MAP_ID_RING_OF_FIRE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PERDITION_ROCK]
		Case $GC_I_MAP_ID_SORROWS_FURNACE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GRENTHS_FOOTPRINT]
		Case $GC_I_MAP_ID_DRAGONS_GULLET
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FLAME_TEMPLE_CORRIDOR]
		Case $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS, $GC_I_MAP_ID_TOMB_OF_THE_PRIMEVAL_KINGS_HALLOWEEN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_DRAGONS_LAIR_OUTPOST]
		Case $GC_I_MAP_ID_LIONS_GATE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_LIONS_ARCH]

			; === Factions - Shing Jea Island ===
		Case $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_SHING_JEA_MONASTERY_CANTHAN_NEW_YEAR, $GC_I_MAP_ID_SHING_JEA_MONASTERY_DRAGON_FESTIVAL
			Local $l_a_Connected[] = [$GC_I_MAP_ID_LINNOK_COURTYARD, $GC_I_MAP_ID_SUNQUA_VALE]
		Case $GC_I_MAP_ID_SUNQUA_VALE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_KINYA_PROVINCE, $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST, $GC_I_MAP_ID_SHING_JEA_MONASTERY, $GC_I_MAP_ID_TSUMEI_VILLAGE]
		Case $GC_I_MAP_ID_PANJIANG_PENINSULA
			Local $l_a_Connected[] = [$GC_I_MAP_ID_KINYA_PROVINCE, $GC_I_MAP_ID_TSUMEI_VILLAGE]
		Case $GC_I_MAP_ID_KINYA_PROVINCE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PANJIANG_PENINSULA, $GC_I_MAP_ID_RAN_MUSU_GARDENS, $GC_I_MAP_ID_SUNQUA_VALE]
		Case $GC_I_MAP_ID_HAIJU_LAGOON
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JAYA_BLUFF, $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST]
		Case $GC_I_MAP_ID_JAYA_BLUFF
			Local $l_a_Connected[] = [$GC_I_MAP_ID_HAIJU_LAGOON, $GC_I_MAP_ID_SEITUNG_HARBOR]
		Case $GC_I_MAP_ID_SEITUNG_HARBOR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JAYA_BLUFF, $GC_I_MAP_ID_KAINENG_DOCKS, $GC_I_MAP_ID_SAOSHANG_TRAIL, $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE]
		Case $GC_I_MAP_ID_LINNOK_COURTYARD
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SAOSHANG_TRAIL, $GC_I_MAP_ID_SHING_JEA_MONASTERY]
		Case $GC_I_MAP_ID_SAOSHANG_TRAIL
			Local $l_a_Connected[] = [$GC_I_MAP_ID_LINNOK_COURTYARD, $GC_I_MAP_ID_SEITUNG_HARBOR]
		Case $GC_I_MAP_ID_TSUMEI_VILLAGE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PANJIANG_PENINSULA, $GC_I_MAP_ID_SUNQUA_VALE]
		Case $GC_I_MAP_ID_RAN_MUSU_GARDENS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE, $GC_I_MAP_ID_KINYA_PROVINCE]
		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST, $GC_I_MAP_ID_RAN_MUSU_GARDENS]

			; === Factions - Kaineng City ===
		Case $GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_KAINENG_CENTER_CANTHAN_NEW_YEAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BEJUNKAN_PIER, $GC_I_MAP_ID_BUKDEK_BYWAY, $GC_I_MAP_ID_RAISU_PAVILLION]
		Case $GC_I_MAP_ID_BUKDEK_BYWAY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_SHADOWS_PASSAGE, $GC_I_MAP_ID_THE_MARKETPLACE, $GC_I_MAP_ID_THE_UNDERCITY, $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER, $GC_I_MAP_ID_XAQUANG_SKYWAY]
		Case $GC_I_MAP_ID_XAQUANG_SKYWAY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BUKDEK_BYWAY, $GC_I_MAP_ID_SENJIS_CORNER, $GC_I_MAP_ID_SHENZUN_TUNNELS, $GC_I_MAP_ID_WAIJUN_BAZAAR]
		Case $GC_I_MAP_ID_WAIJUN_BAZAAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST, $GC_I_MAP_ID_THE_MARKETPLACE, $GC_I_MAP_ID_THE_UNDERCITY, $GC_I_MAP_ID_XAQUANG_SKYWAY]
		Case $GC_I_MAP_ID_THE_UNDERCITY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BUKDEK_BYWAY, $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER, $GC_I_MAP_ID_WAIJUN_BAZAAR]
		Case $GC_I_MAP_ID_SHADOWS_PASSAGE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BUKDEK_BYWAY, $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST]
		Case $GC_I_MAP_ID_SHENZUN_TUNNELS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MAATU_KEEP, $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE, $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST, $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST, $GC_I_MAP_ID_XAQUANG_SKYWAY]
		Case $GC_I_MAP_ID_SENJIS_CORNER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE, $GC_I_MAP_ID_XAQUANG_SKYWAY]
		Case $GC_I_MAP_ID_NAHPUI_QUARTER_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SENJIS_CORNER, $GC_I_MAP_ID_SHENZUN_TUNNELS]
		Case $GC_I_MAP_ID_PONGMEI_VALLEY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BOREAS_SEABED_OUTPOST, $GC_I_MAP_ID_MAATU_KEEP, $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE, $GC_I_MAP_ID_TANGLEWOOD_COPSE]
		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PONGMEI_VALLEY, $GC_I_MAP_ID_ZIN_KU_CORRIDOR]
		Case $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST, $GC_I_MAP_ID_RAISU_PALACE_OUTPOST]
		Case $GC_I_MAP_ID_RAISU_PAVILLION
			Local $l_a_Connected[] = [$GC_I_MAP_ID_KAINENG_CENTER, $GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE]
		Case $GC_I_MAP_ID_KAINENG_DOCKS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_MARKETPLACE, $GC_I_MAP_ID_SEITUNG_HARBOR]
		Case $GC_I_MAP_ID_THE_MARKETPLACE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BUKDEK_BYWAY, $GC_I_MAP_ID_KAINENG_DOCKS, $GC_I_MAP_ID_WAIJUN_BAZAAR]
		Case $GC_I_MAP_ID_MAATU_KEEP
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PONGMEI_VALLEY, $GC_I_MAP_ID_SHENZUN_TUNNELS]

			; === Factions - Echovald Forest ===
		Case $GC_I_MAP_ID_HOUSE_ZU_HELTZER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST, $GC_I_MAP_ID_FERNDALE]
		Case $GC_I_MAP_ID_FERNDALE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK, $GC_I_MAP_ID_HOUSE_ZU_HELTZER, $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY, $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE]
		Case $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FERNDALE, $GC_I_MAP_ID_MELANDRUS_HOPE]
		Case $GC_I_MAP_ID_MELANDRUS_HOPE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BRAUER_ACADEMY, $GC_I_MAP_ID_JADE_FLATS_KURZICK, $GC_I_MAP_ID_LUTGARDIS_CONSERVATORY]
		Case $GC_I_MAP_ID_DRAZACH_THICKET
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BRAUER_ACADEMY, $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE, $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE]
		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST, $GC_I_MAP_ID_MOURNING_VEIL_FALLS, $GC_I_MAP_ID_VASBURG_ARMORY]
		Case $GC_I_MAP_ID_THE_ETERNAL_GROVE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE, $GC_I_MAP_ID_DRAZACH_THICKET]
		Case $GC_I_MAP_ID_MOURNING_VEIL_FALLS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_AMATZ_BASIN_OUTPOST, $GC_I_MAP_ID_DURHEIM_ARCHIVES, $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE]
		Case $GC_I_MAP_ID_VASBURG_ARMORY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MOROSTAV_TRAIL, $GC_I_MAP_ID_THE_ETERNAL_GROVE_EXPLORABLE]
		Case $GC_I_MAP_ID_MOROSTAV_TRAIL
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DURHEIM_ARCHIVES, $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK_MISSION_OUTPOST, $GC_I_MAP_ID_VASBURG_ARMORY]
		Case $GC_I_MAP_ID_DURHEIM_ARCHIVES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MOROSTAV_TRAIL, $GC_I_MAP_ID_MOURNING_VEIL_FALLS]
		Case $GC_I_MAP_ID_ARBORSTONE_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST, $GC_I_MAP_ID_ARBORSTONE_OUTPOST, $GC_I_MAP_ID_TANGLEWOOD_COPSE]
		Case $GC_I_MAP_ID_TANGLEWOOD_COPSE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARBORSTONE_EXPLORABLE, $GC_I_MAP_ID_PONGMEI_VALLEY]
		Case $GC_I_MAP_ID_SAINT_ANJEKAS_SHRINE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DRAZACH_THICKET, $GC_I_MAP_ID_FERNDALE]
		Case $GC_I_MAP_ID_BRAUER_ACADEMY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DRAZACH_THICKET, $GC_I_MAP_ID_MELANDRUS_HOPE]
		Case $GC_I_MAP_ID_ALTRUMM_RUINS_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARBORSTONE_EXPLORABLE, $GC_I_MAP_ID_HOUSE_ZU_HELTZER]

			; === Factions - Jade Sea ===
		Case $GC_I_MAP_ID_CAVALON
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARCHIPELAGOS, $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST]
		Case $GC_I_MAP_ID_ARCHIPELAGOS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BREAKER_HOLLOW, $GC_I_MAP_ID_CAVALON, $GC_I_MAP_ID_JADE_FLATS_LUXON, $GC_I_MAP_ID_MAISHANG_HILLS]
		Case $GC_I_MAP_ID_MAISHANG_HILLS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARCHIPELAGOS, $GC_I_MAP_ID_BAI_PAASU_REACH, $GC_I_MAP_ID_EREDON_TERRACE, $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE]
		Case $GC_I_MAP_ID_MOUNT_QINKAI
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ASPENWOOD_GATE_LUXON, $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE, $GC_I_MAP_ID_BREAKER_HOLLOW]
		Case $GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BOREAS_SEABED_OUTPOST, $GC_I_MAP_ID_MOUNT_QINKAI, $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST]
		Case $GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST, $GC_I_MAP_ID_LEVIATHAN_PITS, $GC_I_MAP_ID_RHEAS_CRATER]
		Case $GC_I_MAP_ID_RHEAS_CRATER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE, $GC_I_MAP_ID_SEAFARERS_REST, $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST]
		Case $GC_I_MAP_ID_SILENT_SURF
			Local $l_a_Connected[] = [$GC_I_MAP_ID_LEVIATHAN_PITS, $GC_I_MAP_ID_SEAFARERS_REST, $GC_I_MAP_ID_UNWAKING_WATERS_LUXON_MISSION_OUTPOST]
		Case $GC_I_MAP_ID_LEVIATHAN_PITS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE, $GC_I_MAP_ID_SILENT_SURF]
		Case $GC_I_MAP_ID_SEAFARERS_REST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RHEAS_CRATER, $GC_I_MAP_ID_SILENT_SURF]
		Case $GC_I_MAP_ID_BREAKER_HOLLOW
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARCHIPELAGOS, $GC_I_MAP_ID_MOUNT_QINKAI]
		Case $GC_I_MAP_ID_ZOS_SHIVROS_CHANNEL_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE, $GC_I_MAP_ID_CAVALON]

			; === Factions - Outposts ===
		Case $GC_I_MAP_ID_ZEN_DAIJUN_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_HAIJU_LAGOON]
		Case $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SUNQUA_VALE, $GC_I_MAP_ID_MINISTER_CHOS_ESTATE_EXPLORABLE]
		Case $GC_I_MAP_ID_ZEN_DAIJUN_EXPLORABLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SEITUNG_HARBOR]
		Case $GC_I_MAP_ID_NAHPUI_QUARTER_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SENJIS_CORNER, $GC_I_MAP_ID_WAIJUN_BAZAAR]
		Case $GC_I_MAP_ID_TAHNNAKAI_TEMPLE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SHENZUN_TUNNELS]
		Case $GC_I_MAP_ID_ARBORSTONE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARBORSTONE_EXPLORABLE]
		Case $GC_I_MAP_ID_BOREAS_SEABED_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BOREAS_SEABED_EXPLORABLE, $GC_I_MAP_ID_PONGMEI_VALLEY]
		Case $GC_I_MAP_ID_SUNJIANG_DISTRICT_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SHENZUN_TUNNELS]
		Case $GC_I_MAP_ID_GYALA_HATCHERY_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GYALA_HATCHERY_EXPLORABLE]
		Case $GC_I_MAP_ID_RAISU_PALACE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE]
		Case $GC_I_MAP_ID_IMPERIAL_SANCTUM_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RAISU_PALACE_EXPLORABLE]
		Case $GC_I_MAP_ID_UNWAKING_WATERS_LUXON_MISSION_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SILENT_SURF]
		Case $GC_I_MAP_ID_UNWAKING_WATERS_KURZICK_MISSION_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MOROSTAV_TRAIL]
		Case $GC_I_MAP_ID_AMATZ_BASIN_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MOURNING_VEIL_FALLS]
		Case $GC_I_MAP_ID_BEJUNKAN_PIER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_KAINENG_CENTER]
		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_LOCAL_QUARTER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_UNDERCITY]
		Case $GC_I_MAP_ID_VIZUNAH_SQUARE_FOREIGN_QUARTER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BUKDEK_BYWAY]
		Case $GC_I_MAP_ID_DRAGONS_THROAT_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SHADOWS_PASSAGE]
		Case $GC_I_MAP_ID_THE_AURIOS_MINES_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RHEAS_CRATER]
		Case $GC_I_MAP_ID_BAI_PAASU_REACH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MAISHANG_HILLS]
		Case $GC_I_MAP_ID_EREDON_TERRACE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MAISHANG_HILLS]
		Case $GC_I_MAP_ID_JADE_FLATS_KURZICK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MELANDRUS_HOPE]
		Case $GC_I_MAP_ID_JADE_FLATS_LUXON
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARCHIPELAGOS]
		Case $GC_I_MAP_ID_ASPENWOOD_GATE_KURZICK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FERNDALE]
		Case $GC_I_MAP_ID_ASPENWOOD_GATE_LUXON
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MOUNT_QINKAI]
		Case $GC_I_MAP_ID_ZIN_KU_CORRIDOR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_TAHNNAKAI_TEMPLE_EXPLORABLE, $GC_I_MAP_ID_SUNJIANG_DISTRICT_EXPLORABLE]
		Case $GC_I_MAP_ID_HARVEST_TEMPLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_UNWAKING_WATERS_EXPLORABLE]
			; === Nightfall - Istan ===
		Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_HALLOWEEN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_WINTERSDAY, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN_CANTHAN_NEW_YEAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CHUURHIR_FIELDS, $GC_I_MAP_ID_CONSULATE, $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST, $GC_I_MAP_ID_PLAINS_OF_JARIN, $GC_I_MAP_ID_SUN_DOCKS]
		Case $GC_I_MAP_ID_PLAINS_OF_JARIN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CHAMPIONS_DAWN, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL, $GC_I_MAP_ID_THE_ASTRALARIUM]
		Case $GC_I_MAP_ID_CLIFFS_OF_DOHJOK
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BEKNUR_HARBOR_2, $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST, $GC_I_MAP_ID_CHAMPIONS_DAWN, $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST, $GC_I_MAP_ID_ZEHLON_REACH]
		Case $GC_I_MAP_ID_ZEHLON_REACH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CLIFFS_OF_DOHJOK, $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST, $GC_I_MAP_ID_THE_ASTRALARIUM]
		Case $GC_I_MAP_ID_ISSNUR_ISLES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BEKNUR_HARBOR_2, $GC_I_MAP_ID_KODLONU_HAMLET]
		Case $GC_I_MAP_ID_BEKNUR_HARBOR_2
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CLIFFS_OF_DOHJOK, $GC_I_MAP_ID_ISSNUR_ISLES]
		Case $GC_I_MAP_ID_CONSULATE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN]
		Case $GC_I_MAP_ID_CHUURHIR_FIELDS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST, $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN]
		Case $GC_I_MAP_ID_CHAMPIONS_DAWN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CLIFFS_OF_DOHJOK, $GC_I_MAP_ID_PLAINS_OF_JARIN]

			; === Nightfall - Kourna ===
		Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_COMMAND_POST, $GC_I_MAP_ID_MARGA_COAST]
		Case $GC_I_MAP_ID_COMMAND_POST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARKJOK_WARD, $GC_I_MAP_ID_JAHAI_BLUFFS, $GC_I_MAP_ID_SUNSPEAR_SANCTUARY, $GC_I_MAP_ID_SUNWARD_MARCHES, $GC_I_MAP_ID_TURAIS_PROCESSION]
		Case $GC_I_MAP_ID_MARGA_COAST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARKJOK_WARD, $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST, $GC_I_MAP_ID_NUNDU_BAY_OUTPOST, $GC_I_MAP_ID_SUNSPEAR_SANCTUARY, $GC_I_MAP_ID_YOHLON_HAVEN]
		Case $GC_I_MAP_ID_ARKJOK_WARD
			Local $l_a_Connected[] = [$GC_I_MAP_ID_COMMAND_POST, $GC_I_MAP_ID_JAHAI_BLUFFS, $GC_I_MAP_ID_MARGA_COAST, $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST, $GC_I_MAP_ID_YOHLON_HAVEN]
		Case $GC_I_MAP_ID_JAHAI_BLUFFS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARKJOK_WARD, $GC_I_MAP_ID_COMMAND_POST, $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST, $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON, $GC_I_MAP_ID_TURAIS_PROCESSION]
		Case $GC_I_MAP_ID_YOHLON_HAVEN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARKJOK_WARD, $GC_I_MAP_ID_MARGA_COAST]
		Case $GC_I_MAP_ID_SUNWARD_MARCHES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_COMMAND_POST, $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST, $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST]
		Case $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JAHAI_BLUFFS, $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST, $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST, $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST]
		Case $GC_I_MAP_ID_DEJARIN_ESTATE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CAMP_HOJANU, $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST, $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST]
		Case $GC_I_MAP_ID_BAHDOK_CAVERNS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST, $GC_I_MAP_ID_WEHHAN_TERRACES]
		Case $GC_I_MAP_ID_WEHHAN_TERRACES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BAHDOK_CAVERNS, $GC_I_MAP_ID_YATENDI_CANYONS]
		Case $GC_I_MAP_ID_TURAIS_PROCESSION
			Local $l_a_Connected[] = [$GC_I_MAP_ID_COMMAND_POST, $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST, $GC_I_MAP_ID_JAHAI_BLUFFS, $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST]

			; === Nightfall - Vabbi ===
		Case $GC_I_MAP_ID_YATENDI_CANYONS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CHANTRY_OF_SECRETS, $GC_I_MAP_ID_VEHTENDI_VALLEY, $GC_I_MAP_ID_WEHHAN_TERRACES]
		Case $GC_I_MAP_ID_VEHTENDI_VALLEY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FORUM_HIGHLANDS, $GC_I_MAP_ID_THE_KODASH_BAZAAR, $GC_I_MAP_ID_YAHNUR_MARKET, $GC_I_MAP_ID_YATENDI_CANYONS]
		Case $GC_I_MAP_ID_FORUM_HIGHLANDS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GARDEN_OF_SEBORHIN, $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST, $GC_I_MAP_ID_THE_KODASH_BAZAAR, $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST, $GC_I_MAP_ID_VEHTENDI_VALLEY]
		Case $GC_I_MAP_ID_THE_MIRROR_OF_LYSS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST, $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST, $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST, $GC_I_MAP_ID_HONUR_HILL, $GC_I_MAP_ID_MIHANU_TOWNSHIP, $GC_I_MAP_ID_THE_KODASH_BAZAAR]
		Case $GC_I_MAP_ID_THE_KODASH_BAZAAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FORUM_HIGHLANDS, $GC_I_MAP_ID_THE_MIRROR_OF_LYSS, $GC_I_MAP_ID_VEHTENDI_VALLEY]
		Case $GC_I_MAP_ID_RESPLENDENT_MAKUUN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BOKKA_AMPHITHEATRE, $GC_I_MAP_ID_HONUR_HILL, $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA, $GC_I_MAP_ID_YAHNUR_MARKET]
		Case $GC_I_MAP_ID_HONUR_HILL
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RESPLENDENT_MAKUUN, $GC_I_MAP_ID_THE_MIRROR_OF_LYSS]
		Case $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST, $GC_I_MAP_ID_RESPLENDENT_MAKUUN]
		Case $GC_I_MAP_ID_HOLDINGSOFCHOKHIN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MIHANU_TOWNSHIP, $GC_I_MAP_ID_VEHJIN_MINES]
		Case $GC_I_MAP_ID_MIHANU_TOWNSHIP
			Local $l_a_Connected[] = [$GC_I_MAP_ID_HOLDINGSOFCHOKHIN, $GC_I_MAP_ID_THE_MIRROR_OF_LYSS]
		Case $GC_I_MAP_ID_VEHJIN_MINES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BASALT_GROTTO, $GC_I_MAP_ID_HOLDINGSOFCHOKHIN, $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST]
		Case $GC_I_MAP_ID_BASALT_GROTTO
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JOKOS_DOMAIN, $GC_I_MAP_ID_VEHJIN_MINES]

			; === Nightfall - The Desolation ===
		Case $GC_I_MAP_ID_JOKOS_DOMAIN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BASALT_GROTTO, $GC_I_MAP_ID_BONE_PALACE, $GC_I_MAP_ID_THE_SHATTERED_RAVINES, $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST]
		Case $GC_I_MAP_ID_BONE_PALACE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JOKOS_DOMAIN, $GC_I_MAP_ID_THE_ALKALI_PAN]
		Case $GC_I_MAP_ID_THE_SULFUROUS_WASTES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST, $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST]
		Case $GC_I_MAP_ID_THE_ALKALI_PAN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BONE_PALACE, $GC_I_MAP_ID_CRYSTAL_OVERLOOK, $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST, $GC_I_MAP_ID_THE_RUPTURED_HEART, $GC_I_MAP_ID_THE_SHATTERED_RAVINES]
		Case $GC_I_MAP_ID_THE_SHATTERED_RAVINES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JOKOS_DOMAIN, $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN, $GC_I_MAP_ID_THE_ALKALI_PAN, $GC_I_MAP_ID_THE_RUPTURED_HEART]
		Case $GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_POISONED_OUTCROPS, $GC_I_MAP_ID_THE_SHATTERED_RAVINES]
		Case $GC_I_MAP_ID_POISONED_OUTCROPS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_LAIR_OF_THE_FORGOTTEN, $GC_I_MAP_ID_THE_RUPTURED_HEART]
		Case $GC_I_MAP_ID_THE_RUPTURED_HEART
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CRYSTAL_OVERLOOK, $GC_I_MAP_ID_POISONED_OUTCROPS, $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST, $GC_I_MAP_ID_THE_ALKALI_PAN, $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT, $GC_I_MAP_ID_THE_SHATTERED_RAVINES]
		Case $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GATE_OF_TORMENT, $GC_I_MAP_ID_THE_RUPTURED_HEART]

			; === Nightfall - Realm of Torment ===
		Case $GC_I_MAP_ID_GATE_OF_TORMENT
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NIGHTFALLEN_JAHAI, $GC_I_MAP_ID_THE_SHADOW_NEXUS_OUTPOST, $GC_I_MAP_ID_THE_MOUTH_OF_TORMENT]
		Case $GC_I_MAP_ID_NIGHTFALLEN_JAHAI
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST, $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS, $GC_I_MAP_ID_GATE_OF_TORMENT]
		Case $GC_I_MAP_ID_DOMAIN_OF_FEAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GATE_OF_FEAR, $GC_I_MAP_ID_GATE_OF_SECRETS]
		Case $GC_I_MAP_ID_GATE_OF_FEAR
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DOMAIN_OF_FEAR, $GC_I_MAP_ID_DOMAIN_OF_PAIN]
		Case $GC_I_MAP_ID_DOMAIN_OF_PAIN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST, $GC_I_MAP_ID_GATE_OF_FEAR]
		Case $GC_I_MAP_ID_DOMAIN_OF_SECRETS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST, $GC_I_MAP_ID_GATE_OF_SECRETS]
		Case $GC_I_MAP_ID_GATE_OF_SECRETS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DOMAIN_OF_FEAR, $GC_I_MAP_ID_DOMAIN_OF_SECRETS]
		Case $GC_I_MAP_ID_DEPTHS_OF_MADNESS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ABADDONS_GATE_OUTPOST, $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST]

			; === Nightfall - Outposts ===
		Case $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PLAINS_OF_JARIN]
		Case $GC_I_MAP_ID_THE_ASTRALARIUM
			Local $l_a_Connected[] = [$GC_I_MAP_ID_PLAINS_OF_JARIN, $GC_I_MAP_ID_ZEHLON_REACH]
		Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CLIFFS_OF_DOHJOK, $GC_I_MAP_ID_ZEHLON_REACH, $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY]
		Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CLIFFS_OF_DOHJOK, $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY, $GC_I_MAP_ID_LAHTEDA_BOG]
		Case $GC_I_MAP_ID_KODLONU_HAMLET
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ISSNUR_ISLES]
		Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CONSULATE]
		Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CHUURHIR_FIELDS]
		Case $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, $GC_I_MAP_ID_MARGA_COAST, $GC_I_MAP_ID_SUNWARD_MARCHES]
		Case $GC_I_MAP_ID_CAMP_HOJANU
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BARBAROUS_SHORE, $GC_I_MAP_ID_DEJARIN_ESTATE]
		Case $GC_I_MAP_ID_BARBAROUS_SHORE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_CAMP_HOJANU]
		Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DEJARIN_ESTATE, $GC_I_MAP_ID_JAHAI_BLUFFS, $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON]
		Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARKJOK_WARD, $GC_I_MAP_ID_DEJARIN_ESTATE, $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS]
		Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON]
		Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BAHDOK_CAVERNS, $GC_I_MAP_ID_THE_FLOODPLAIN_OF_MAHNKELON]
		Case $GC_I_MAP_ID_NUNDU_BAY_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MARGA_COAST]
		Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SUNWARD_MARCHES, $GC_I_MAP_ID_TURAIS_PROCESSION]
		Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_YATENDI_CANYONS]
		Case $GC_I_MAP_ID_YAHNUR_MARKET
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RESPLENDENT_MAKUUN, $GC_I_MAP_ID_VEHTENDI_VALLEY]
		Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FORUM_HIGHLANDS]
		Case $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_MIRROR_OF_LYSS, $GC_I_MAP_ID_WILDERNESS_OF_BAHDZA]
		Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM, $GC_I_MAP_ID_THE_MIRROR_OF_LYSS]
		Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_MIRROR_OF_LYSS]
		Case $GC_I_MAP_ID_BOKKA_AMPHITHEATRE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_RESPLENDENT_MAKUUN]
		Case $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_FORUM_HIGHLANDS, $GC_I_MAP_ID_VEHJIN_MINES]
		Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_SULFUROUS_WASTES, $GC_I_MAP_ID_TURAIS_PROCESSION]
		Case $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JOKOS_DOMAIN, $GC_I_MAP_ID_THE_SULFUROUS_WASTES]
		Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_THE_ALKALI_PAN, $GC_I_MAP_ID_THE_RUPTURED_HEART]
		Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NIGHTFALLEN_JAHAI, $GC_I_MAP_ID_DOMAIN_OF_PAIN]
		Case $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NIGHTFALLEN_JAHAI]
		Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DEPTHS_OF_MADNESS, $GC_I_MAP_ID_DOMAIN_OF_SECRETS]
		Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DEPTHS_OF_MADNESS, $GC_I_MAP_ID_HEART_OF_ABADDON]

			; === Eye of the North ===
		Case $GC_I_MAP_ID_BJORA_MARCHES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_JAGA_MORAINE, $GC_I_MAP_ID_LONGEYES_LEDGE, $GC_I_MAP_ID_NORRHART_DOMAINS]
		Case $GC_I_MAP_ID_ARBOR_BAY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ALCAZIA_TANGLE, $GC_I_MAP_ID_RIVEN_EARTH, $GC_I_MAP_ID_VLOXS_FALLS]
		Case $GC_I_MAP_ID_ICE_CLIFF_CHASMS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BATTLEDEPTHS, $GC_I_MAP_ID_BOREAL_STATION, $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST, $GC_I_MAP_ID_NORRHART_DOMAINS]
		Case $GC_I_MAP_ID_RIVEN_EARTH
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ALCAZIA_TANGLE, $GC_I_MAP_ID_ARBOR_BAY, $GC_I_MAP_ID_RATA_SUM]
		Case $GC_I_MAP_ID_DRAKKAR_LAKE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NORRHART_DOMAINS, $GC_I_MAP_ID_SEPULCHRE_OF_DRAGRIMMAR_LVL1, $GC_I_MAP_ID_SIFHALLA, $GC_I_MAP_ID_VARAJAR_FELLS_1]
		Case $GC_I_MAP_ID_JAGA_MORAINE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BJORA_MARCHES, $GC_I_MAP_ID_FROSTMAWS_BURROWS_LVL1, $GC_I_MAP_ID_SIFHALLA]
		Case $GC_I_MAP_ID_NORRHART_DOMAINS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BJORA_MARCHES, $GC_I_MAP_ID_DRAKKAR_LAKE, $GC_I_MAP_ID_GUNNARS_HOLD, $GC_I_MAP_ID_ICE_CLIFF_CHASMS, $GC_I_MAP_ID_VARAJAR_FELLS_1]
		Case $GC_I_MAP_ID_VARAJAR_FELLS_1
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BATTLEDEPTHS, $GC_I_MAP_ID_DRAKKAR_LAKE, $GC_I_MAP_ID_RAVENS_POINT_LVL1, $GC_I_MAP_ID_OLAFSTEAD, $GC_I_MAP_ID_NORRHART_DOMAINS, $GC_I_MAP_ID_VERDANT_CASCADES]
		Case $GC_I_MAP_ID_SPARKFLY_SWAMP
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GADDS_ENCAMPMENT, $GC_I_MAP_ID_BLOODSTONE_CAVES_LVL1, $GC_I_MAP_ID_BOGROOT_GROWTHS_LVL1]
		Case $GC_I_MAP_ID_VERDANT_CASCADES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SLAVERS_EXILE_LVL1, $GC_I_MAP_ID_UMBRAL_GROTTO, $GC_I_MAP_ID_VARAJAR_FELLS_1]
		Case $GC_I_MAP_ID_MAGUS_STONES
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ALCAZIA_TANGLE, $GC_I_MAP_ID_ARACHNIS_HAUNT_LVL1, $GC_I_MAP_ID_OOLAS_LAB_LVL1, $GC_I_MAP_ID_RATA_SUM]
		Case $GC_I_MAP_ID_ALCAZIA_TANGLE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARBOR_BAY, $GC_I_MAP_ID_RIVEN_EARTH, $GC_I_MAP_ID_MAGUS_STONES, $GC_I_MAP_ID_TARNISHED_HAVEN]
		Case $GC_I_MAP_ID_VLOXS_FALLS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ARBOR_BAY, $GC_I_MAP_ID_VLOXEN_EXCAVATIONS_LVL1]
		Case $GC_I_MAP_ID_VLOXEN_EXCAVATIONS_LVL1
			Local $l_a_Connected[] = [$GC_I_MAP_ID_VLOXS_FALLS]
		Case $GC_I_MAP_ID_BATTLEDEPTHS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_HEART_OF_THE_SHIVERPEAKS_LVL1, $GC_I_MAP_ID_ICE_CLIFF_CHASMS, $GC_I_MAP_ID_VARAJAR_FELLS_1, $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER]
		Case $GC_I_MAP_ID_GADDS_ENCAMPMENT
			Local $l_a_Connected[] = [$GC_I_MAP_ID_SPARKFLY_SWAMP, $GC_I_MAP_ID_SHARDS_OF_ORR_LVL1]
		Case $GC_I_MAP_ID_UMBRAL_GROTTO
			Local $l_a_Connected[] = [$GC_I_MAP_ID_VERDANT_CASCADES, $GC_I_MAP_ID_VLOXEN_EXCAVATIONS_LVL1]
		Case $GC_I_MAP_ID_RATA_SUM
			Local $l_a_Connected[] = [$GC_I_MAP_ID_MAGUS_STONES, $GC_I_MAP_ID_RIVEN_EARTH]
		Case $GC_I_MAP_ID_TARNISHED_HAVEN
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ALCAZIA_TANGLE]
		Case $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST, $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST_WINTERSDAY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_HALL_OF_MONUMENTS, $GC_I_MAP_ID_ICE_CLIFF_CHASMS]
		Case $GC_I_MAP_ID_SIFHALLA
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DRAKKAR_LAKE, $GC_I_MAP_ID_JAGA_MORAINE]
		Case $GC_I_MAP_ID_GUNNARS_HOLD
			Local $l_a_Connected[] = [$GC_I_MAP_ID_NORRHART_DOMAINS]
		Case $GC_I_MAP_ID_OLAFSTEAD
			Local $l_a_Connected[] = [$GC_I_MAP_ID_VARAJAR_FELLS_1]
		Case $GC_I_MAP_ID_HALL_OF_MONUMENTS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST, $GC_I_MAP_ID_EYE_OF_THE_NORTH_OUTPOST_WINTERSDAY]
		Case $GC_I_MAP_ID_DALADA_UPLANDS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DOOMLORE_SHRINE, $GC_I_MAP_ID_GROTHMAR_WARDOWNS, $GC_I_MAP_ID_SACNOTH_VALLEY]
		Case $GC_I_MAP_ID_DOOMLORE_SHRINE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DALADA_UPLANDS, $GC_I_MAP_ID_CATHEDRAL_OF_FLAMES_LVL1]
		Case $GC_I_MAP_ID_GROTHMAR_WARDOWNS
			Local $l_a_Connected[] = [$GC_I_MAP_ID_DALADA_UPLANDS, $GC_I_MAP_ID_LONGEYES_LEDGE, $GC_I_MAP_ID_OOZE_PIT, $GC_I_MAP_ID_SACNOTH_VALLEY]
		Case $GC_I_MAP_ID_LONGEYES_LEDGE
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BJORA_MARCHES, $GC_I_MAP_ID_GROTHMAR_WARDOWNS]
		Case $GC_I_MAP_ID_SACNOTH_VALLEY
			Local $l_a_Connected[] = [$GC_I_MAP_ID_GROTHMAR_WARDOWNS, $GC_I_MAP_ID_DALADA_UPLANDS, $GC_I_MAP_ID_CATACOMBS_OF_KATHANDRAX_LVL1, $GC_I_MAP_ID_RRAGARS_MENAGERIE_LVL1]
		Case $GC_I_MAP_ID_CENTRAL_TRANSFER_CHAMBER
			Local $l_a_Connected[] = [$GC_I_MAP_ID_BATTLEDEPTHS]
		Case $GC_I_MAP_ID_BOREAL_STATION
			Local $l_a_Connected[] = [$GC_I_MAP_ID_ICE_CLIFF_CHASMS]
		Case Else
			; Map has no known connections
	EndSwitch

	Return $l_a_Connected
EndFunc   ;==>Map_GetConnectedMaps

; =============================================================================
; Map_FindMapPath - Finds the shortest path between two maps using BFS
; @param $a_i_FromMapID: Starting map ID
; @param $a_i_ToMapID: Destination map ID
; @return: Array of map IDs representing the path (including start and end), or empty array if no path
; =============================================================================
Func Map_FindMapPath($a_i_FromMapID, $a_i_ToMapID)
	; Handle same map case
	If $a_i_FromMapID = $a_i_ToMapID Then
		Local $l_a_Path[1] = [$a_i_FromMapID]
		Return $l_a_Path
	EndIf

	; BFS implementation
	Local $l_a_Queue[1] = [$a_i_FromMapID]
	Local $l_a_Visited[1000] ; Map ID visited flags (max 1000 maps)
	Local $l_a_Parent[1000] ; Parent map for path reconstruction
	For $i = 0 To 999
		$l_a_Visited[$i] = False
		$l_a_Parent[$i] = -1
	Next
	$l_a_Visited[$a_i_FromMapID] = True

	Local $l_i_QueueStart = 0
	Local $l_i_QueueEnd = 1
	Local $l_b_Found = False

	While $l_i_QueueStart < $l_i_QueueEnd
		Local $l_i_Current = $l_a_Queue[$l_i_QueueStart]
		$l_i_QueueStart += 1

		; Get connected maps
		Local $l_a_Connected = Map_GetConnectedMaps($l_i_Current)
		If Not IsArray($l_a_Connected) Then ContinueLoop

		For $i = 0 To UBound($l_a_Connected) - 1
			Local $l_i_Neighbor = $l_a_Connected[$i]

			; Skip if already visited or invalid
			If $l_i_Neighbor < 0 Or $l_i_Neighbor >= 1000 Then ContinueLoop
			If $l_a_Visited[$l_i_Neighbor] Then ContinueLoop

			$l_a_Visited[$l_i_Neighbor] = True
			$l_a_Parent[$l_i_Neighbor] = $l_i_Current

			; Found destination!
			If $l_i_Neighbor = $a_i_ToMapID Then
				$l_b_Found = True
				ExitLoop 2
			EndIf

			; Add to queue
			ReDim $l_a_Queue[$l_i_QueueEnd + 1]
			$l_a_Queue[$l_i_QueueEnd] = $l_i_Neighbor
			$l_i_QueueEnd += 1
		Next
	WEnd

	; Path not found
	If Not $l_b_Found Then
		Local $l_a_Empty[0]
		Return $l_a_Empty
	EndIf

	; Reconstruct path from destination to source
	Local $l_a_PathReverse[0]
	Local $l_i_Current = $a_i_ToMapID
	While $l_i_Current <> -1
		ReDim $l_a_PathReverse[UBound($l_a_PathReverse) + 1]
		$l_a_PathReverse[UBound($l_a_PathReverse) - 1] = $l_i_Current
		$l_i_Current = $l_a_Parent[$l_i_Current]
	WEnd

	; Reverse the path
	Local $l_i_PathLen = UBound($l_a_PathReverse)
	Local $l_a_Path[$l_i_PathLen]
	For $i = 0 To $l_i_PathLen - 1
		$l_a_Path[$i] = $l_a_PathReverse[$l_i_PathLen - 1 - $i]
	Next

	Return $l_a_Path
EndFunc   ;==>Map_FindMapPath

; =============================================================================
; Map_FindNearestUnlockedOutpost - Finds the nearest unlocked outpost to a destination
; Uses BFS from destination backwards to find closest unlocked outpost
; @param $a_i_DestMapID: Destination map ID
; @param $a_i_FromMapID: Starting map ID (to exclude from search)
; @return: MapID of nearest unlocked outpost, or 0 if none found
; =============================================================================
Func Map_FindNearestUnlockedOutpost($a_i_DestMapID, $a_i_FromMapID = 0)
	; Check if destination itself is an unlocked valid outpost
	If Map_IsMapUnlocked($a_i_DestMapID) And Map_IsOutpost($a_i_DestMapID) Then
		Return $a_i_DestMapID
	EndIf

	; BFS from destination to find nearest unlocked outpost
	Local $l_a_Queue[1] = [$a_i_DestMapID]
	Local $l_a_Visited[1000]
	Local $l_a_Distance[1000]
	For $i = 0 To 999
		$l_a_Visited[$i] = False
		$l_a_Distance[$i] = 999999
	Next
	$l_a_Visited[$a_i_DestMapID] = True
	$l_a_Distance[$a_i_DestMapID] = 0

	Local $l_i_QueueStart = 0
	Local $l_i_QueueEnd = 1
	Local $l_i_BestOutpost = 0
	Local $l_i_BestDistance = 999999

	While $l_i_QueueStart < $l_i_QueueEnd
		Local $l_i_Current = $l_a_Queue[$l_i_QueueStart]
		$l_i_QueueStart += 1

		Local $l_i_CurrentDist = $l_a_Distance[$l_i_Current]

		; If we already found a closer outpost, skip maps that are further
		If $l_i_CurrentDist >= $l_i_BestDistance Then ContinueLoop

		; Check if current map is an unlocked valid outpost (and not our starting point)
		If $l_i_Current <> $a_i_FromMapID And Map_IsMapUnlocked($l_i_Current) And Map_IsOutpost($l_i_Current) Then
			If $l_i_CurrentDist < $l_i_BestDistance Then
				$l_i_BestDistance = $l_i_CurrentDist
				$l_i_BestOutpost = $l_i_Current
			EndIf
			ContinueLoop ; Don't explore further from this outpost
		EndIf

		; Get connected maps
		Local $l_a_Connected = Map_GetConnectedMaps($l_i_Current)
		If Not IsArray($l_a_Connected) Then ContinueLoop

		For $i = 0 To UBound($l_a_Connected) - 1
			Local $l_i_Neighbor = $l_a_Connected[$i]

			If $l_i_Neighbor < 0 Or $l_i_Neighbor >= 1000 Then ContinueLoop
			If $l_a_Visited[$l_i_Neighbor] Then ContinueLoop

			$l_a_Visited[$l_i_Neighbor] = True
			$l_a_Distance[$l_i_Neighbor] = $l_i_CurrentDist + 1

			ReDim $l_a_Queue[$l_i_QueueEnd + 1]
			$l_a_Queue[$l_i_QueueEnd] = $l_i_Neighbor
			$l_i_QueueEnd += 1
		Next
	WEnd

	Return $l_i_BestOutpost
EndFunc   ;==>Map_FindNearestUnlockedOutpost

; =============================================================================
; Map_GetPathWithPortalCoords - Finds path and returns map IDs with portal coordinates
; @param $a_i_FromMapID: Starting map ID
; @param $a_i_ToMapID: Destination map ID
; @param $a_b_TravelToNearest: If True, find nearest unlocked outpost to destination
;                              and travel there first (shorter path)
; @return: 2D Array where each row is [MapID, MapName, PortalX, PortalY, TravelHere]
;          PortalX/Y are coordinates to reach the NEXT map (0 for last map)
;          TravelHere = 1 if you should Map_TravelTo this map, 0 otherwise
;          Returns empty array if no path found
; =============================================================================
Func Map_GetPathWithPortalCoords($a_i_FromMapID, $a_i_ToMapID, $a_b_TravelToNearest = False)
	Local $l_i_TravelMapID = 0

	; If TravelToNearest is enabled, find the nearest unlocked outpost
	If $a_b_TravelToNearest Then
		$l_i_TravelMapID = Map_FindNearestUnlockedOutpost($a_i_ToMapID, $a_i_FromMapID)

		; If we found an unlocked outpost, use it as the starting point for walking
		If $l_i_TravelMapID > 0 And $l_i_TravelMapID <> $a_i_FromMapID Then
			; Get path from travel point to destination
			Local $l_a_WalkPath = Map_FindMapPath($l_i_TravelMapID, $a_i_ToMapID)

			If UBound($l_a_WalkPath) = 0 Then
				; Fallback to full path if walk path fails
				$l_i_TravelMapID = 0
			Else
				; Build result with travel marker
				Local $l_i_PathLen = UBound($l_a_WalkPath)
				Local $l_a_Result[$l_i_PathLen][5] ; [MapID, MapName, PortalX, PortalY, TravelHere]

				For $i = 0 To $l_i_PathLen - 1
					Local $l_i_MapID = $l_a_WalkPath[$i]
					$l_a_Result[$i][0] = $l_i_MapID

					; Get map name
					Local $l_i_ArrayIndex = $l_i_MapID - 1
					If $l_i_ArrayIndex >= 0 And $l_i_ArrayIndex < UBound($g_a2D_MapArray) Then
						$l_a_Result[$i][1] = $g_a2D_MapArray[$l_i_ArrayIndex][1]
					Else
						$l_a_Result[$i][1] = "Unknown"
					EndIf

					; Get portal coords to next map
					If $i < $l_i_PathLen - 1 Then
						Local $l_i_NextMapID = $l_a_WalkPath[$i + 1]
						Local $l_a_Coords = Map_GetExitPortalsCoords($l_i_MapID, $l_i_NextMapID)

						If IsArray($l_a_Coords) Then
							$l_a_Result[$i][2] = $l_a_Coords[0]
							$l_a_Result[$i][3] = $l_a_Coords[1]
						Else
							$l_a_Result[$i][2] = 0
							$l_a_Result[$i][3] = 0
						EndIf
					Else
						$l_a_Result[$i][2] = 0
						$l_a_Result[$i][3] = 0
					EndIf

					; Mark first map as travel destination
					$l_a_Result[$i][4] = ($i = 0) ? 1 : 0
				Next

				Return $l_a_Result
			EndIf
		EndIf
	EndIf

	; Standard path finding (no travel optimization)
	Local $l_a_Path = Map_FindMapPath($a_i_FromMapID, $a_i_ToMapID)

	If UBound($l_a_Path) = 0 Then
		Local $l_a_Empty[0][5]
		Return $l_a_Empty
	EndIf

	Local $l_i_PathLen = UBound($l_a_Path)
	Local $l_a_Result[$l_i_PathLen][5] ; [MapID, MapName, PortalX, PortalY, TravelHere]

	For $i = 0 To $l_i_PathLen - 1
		Local $l_i_MapID = $l_a_Path[$i]
		$l_a_Result[$i][0] = $l_i_MapID

		; Get map name (array index = MapID - 1 since IDs start at 1)
		Local $l_i_ArrayIndex = $l_i_MapID - 1
		If $l_i_ArrayIndex >= 0 And $l_i_ArrayIndex < UBound($g_a2D_MapArray) Then
			$l_a_Result[$i][1] = $g_a2D_MapArray[$l_i_ArrayIndex][1]
		Else
			$l_a_Result[$i][1] = "Unknown"
		EndIf

		; Get portal coords to next map (if not last map)
		If $i < $l_i_PathLen - 1 Then
			Local $l_i_NextMapID = $l_a_Path[$i + 1]
			Local $l_a_Coords = Map_GetExitPortalsCoords($l_i_MapID, $l_i_NextMapID)

			If IsArray($l_a_Coords) Then
				$l_a_Result[$i][2] = $l_a_Coords[0]
				$l_a_Result[$i][3] = $l_a_Coords[1]
			Else
				$l_a_Result[$i][2] = 0
				$l_a_Result[$i][3] = 0
			EndIf
		Else
			; Last map - no portal needed
			$l_a_Result[$i][2] = 0
			$l_a_Result[$i][3] = 0
		EndIf

		; No travel for standard path
		$l_a_Result[$i][4] = 0
	Next

	Return $l_a_Result
EndFunc   ;==>Map_GetPathWithPortalCoords

; =============================================================================
; Map_GetPathToUnlockCity - Gets path from nearest unlocked outpost to a locked city
; @param $a_i_CityID: The city/outpost to unlock
; @return: Array [OutpostID, PathWithCoords] where PathWithCoords is from Map_GetPathWithPortalCoords
;          OutpostID = 0 if no path found, or = CityID if already unlocked
; =============================================================================
Func Map_GetPathToUnlockCity($a_i_CityID)
	Local $l_a_Result[2]
	$l_a_Result[0] = 0
	Local $l_a_Empty[0][5]
	$l_a_Result[1] = $l_a_Empty

	; Si déjà débloqué, retourner directement
	If Map_IsMapUnlocked($a_i_CityID) And Map_IsValidOutpost($a_i_CityID) Then
		$l_a_Result[0] = $a_i_CityID
		Return $l_a_Result
	EndIf

	; Trouver l'outpost débloqué le plus proche de cityID
	Local $l_i_NearestOutpost = Map_FindNearestUnlockedOutpost($a_i_CityID, 0)

	If $l_i_NearestOutpost = 0 Then Return $l_a_Result

	; Obtenir le chemin avec coordonnées
	Local $l_a_Path = Map_GetPathWithPortalCoords($l_i_NearestOutpost, $a_i_CityID, False)

	If UBound($l_a_Path) = 0 Then Return $l_a_Result

	$l_a_Result[0] = $l_i_NearestOutpost
	$l_a_Result[1] = $l_a_Path

	Return $l_a_Result
EndFunc   ;==>Map_GetPathToUnlockCity

; =============================================================================
; Map_PrintPath - Helper function to print the path with coordinates (for debugging)
; @param $a_i_FromMapID: Starting map ID
; @param $a_i_ToMapID: Destination map ID
; @param $a_b_TravelToNearest: If True, use travel optimization
; =============================================================================
Func Map_PrintPath($a_i_FromMapID, $a_i_ToMapID, $a_b_TravelToNearest = False)
	Local $l_a_Path = Map_GetPathWithPortalCoords($a_i_FromMapID, $a_i_ToMapID, $a_b_TravelToNearest)

	If UBound($l_a_Path) = 0 Then
		Out("No path found from map " & $a_i_FromMapID & " to " & $a_i_ToMapID)
		Return
	EndIf

	Out("=== Path from " & $l_a_Path[0][1] & " to " & $l_a_Path[UBound($l_a_Path) - 1][1] & " ===")
	If $a_b_TravelToNearest And $l_a_Path[0][4] = 1 Then
		Out("(Using Map Travel to nearest unlocked outpost)")
	EndIf
	Out("Total maps to traverse: " & UBound($l_a_Path))

	For $i = 0 To UBound($l_a_Path) - 1
		Local $l_s_Prefix = ($i + 1) & ". "
		Local $l_s_Travel = ""

		If $l_a_Path[$i][4] = 1 Then
			$l_s_Travel = "[TRAVEL HERE] "
		EndIf

		If $i < UBound($l_a_Path) - 1 Then
			Out($l_s_Prefix & $l_s_Travel & $l_a_Path[$i][1] & " (ID:" & $l_a_Path[$i][0] & ") -> Portal at [" & $l_a_Path[$i][2] & ", " & $l_a_Path[$i][3] & "]")
		Else
			Out($l_s_Prefix & $l_a_Path[$i][1] & " (ID:" & $l_a_Path[$i][0] & ") [DESTINATION]")
		EndIf
	Next
EndFunc   ;==>Map_PrintPath
#EndRegion Inter-Map Pathfinding
