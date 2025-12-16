#include-once

Global $DLL_PATH = ""

Global Const $tagPathPoint = "float x;float y"
Global Const $tagPathResult = "ptr points;int point_count;float total_cost;int error_code;char error_message[256]"
Global Const $tagMapStats = "int trapezoid_count;int point_count;int teleport_count;int travel_portal_count;int npc_travel_count;int enter_travel_count;int error_code;char error_message[256]"
Global Const $tagObstacleZone = "float x;float y;float radius"


Func Pathfinder_Initialize()
    Local $result = DllCall($DLL_PATH, "int:cdecl", "Initialize")
    If @error Then
        Return False
    EndIf
    If $result[0] = 0 Then
        Return False
    EndIf
    Return True
EndFunc

Func Pathfinder_Shutdown()
    DllCall($DLL_PATH, "none:cdecl", "Shutdown")
EndFunc

Func Pathfinder_FindPathGWRaw($mapID, $startX, $startY, $destX, $destY, $simplifyRange = 1250)
    Local $result = DllCall($DLL_PATH, "ptr:cdecl", "FindPath", _
        "int", $mapID, _
        "float", $startX, _
        "float", $startY, _
        "float", $destX, _
        "float", $destY, _
        "float", $simplifyRange)

    If @error Then
        Return SetError(1, 0, 0)
    EndIf

    Return $result[0]
EndFunc

Func Pathfinder_FindPathGW($mapID, $startX, $startY, $destX, $destY, $simplifyRange = 1250)
    Local $l_p_Result = Pathfinder_FindPathGWRaw($mapID, $startX, $startY, $destX, $destY, $simplifyRange)

    If $l_p_Result = 0 Then
        Return SetError(1, 0, 0)
    EndIf

    Local $l_t_Result = DllStructCreate($tagPathResult, $l_p_Result)
    Local $l_i_ErrorCode = DllStructGetData($l_t_Result, "error_code")

    If $l_i_ErrorCode <> 0 Then
        Local $l_s_ErrorMsg = DllStructGetData($l_t_Result, "error_message")
        Pathfinder_FreePathResult($l_p_Result)
        Return SetError(2, $l_i_ErrorCode, 0)
    EndIf

    Local $l_i_PointCount = DllStructGetData($l_t_Result, "point_count")
    Local $l_p_Points = DllStructGetData($l_t_Result, "points")

    Local $a_Path[$l_i_PointCount][2]
    For $i = 0 To $l_i_PointCount - 1
        Local $l_t_Point = DllStructCreate($tagPathPoint, $l_p_Points + ($i * 8))
        $a_Path[$i][0] = DllStructGetData($l_t_Point, "x")
        $a_Path[$i][1] = DllStructGetData($l_t_Point, "y")
    Next

    Pathfinder_FreePathResult($l_p_Result)

    Return $a_Path
EndFunc

Func Pathfinder_FreePathResult($pResult)
    DllCall($DLL_PATH, "none:cdecl", "FreePathResult", "ptr", $pResult)
EndFunc

; Find a path with obstacle avoidance (Raw version - returns pointer)
; $aObstacles = 2D array [[x, y, radius], [x, y, radius], ...]
Func Pathfinder_FindPathGWWithObstacleRaw($mapID, $startX, $startY, $destX, $destY, $aObstacles, $simplifyRange = 1250)
    Local $obstacleCount = 0
    Local $pObstacles = 0

    ; Check if obstacles are provided
    If IsArray($aObstacles) And UBound($aObstacles) > 0 Then
        $obstacleCount = UBound($aObstacles)

        ; Create a contiguous array of ObstacleZone structures in memory
        ; Each ObstacleZone is 12 bytes (3 floats: x, y, radius)
        Local $obstacleStructSize = 12
        Local $obstacleBuffer = DllStructCreate("byte[" & ($obstacleCount * $obstacleStructSize) & "]")
        $pObstacles = DllStructGetPtr($obstacleBuffer)

        ; Fill the obstacle buffer
        For $i = 0 To $obstacleCount - 1
            Local $obstacle = DllStructCreate($tagObstacleZone, $pObstacles + $i * $obstacleStructSize)
            DllStructSetData($obstacle, "x", $aObstacles[$i][0])
            DllStructSetData($obstacle, "y", $aObstacles[$i][1])
            DllStructSetData($obstacle, "radius", $aObstacles[$i][2])
        Next
    EndIf

    ; Call FindPathWithObstacles
    Local $result = DllCall($DLL_PATH, "ptr:cdecl", "FindPathWithObstacles", _
        "int", $mapID, _
        "float", $startX, _
        "float", $startY, _
        "float", $destX, _
        "float", $destY, _
        "ptr", $pObstacles, _
        "int", $obstacleCount, _
        "float", $simplifyRange)

    If @error Then
        Return SetError(1, 0, 0)
    EndIf

    Return $result[0]
EndFunc

; Find a path with obstacle avoidance (returns 2D array of coordinates)
; $aObstacles = 2D array [[x, y, radius], [x, y, radius], ...]
Func Pathfinder_FindPathGWWithObstacle($mapID, $startX, $startY, $destX, $destY, $aObstacles, $simplifyRange = 1250)
    Local $l_p_Result = Pathfinder_FindPathGWWithObstacleRaw($mapID, $startX, $startY, $destX, $destY, $aObstacles, $simplifyRange)

    If $l_p_Result = 0 Then
        Return SetError(1, 0, 0)
    EndIf

    Local $l_t_Result = DllStructCreate($tagPathResult, $l_p_Result)
    Local $l_i_ErrorCode = DllStructGetData($l_t_Result, "error_code")

    If $l_i_ErrorCode <> 0 Then
        Local $l_s_ErrorMsg = DllStructGetData($l_t_Result, "error_message")
        Pathfinder_FreePathResult($l_p_Result)
        Return SetError(2, $l_i_ErrorCode, 0)
    EndIf

    Local $l_i_PointCount = DllStructGetData($l_t_Result, "point_count")
    Local $l_p_Points = DllStructGetData($l_t_Result, "points")

    Local $a_Path[$l_i_PointCount][2]
    For $i = 0 To $l_i_PointCount - 1
        Local $l_t_Point = DllStructCreate($tagPathPoint, $l_p_Points + ($i * 8))
        $a_Path[$i][0] = DllStructGetData($l_t_Point, "x")
        $a_Path[$i][1] = DllStructGetData($l_t_Point, "y")
    Next

    Pathfinder_FreePathResult($l_p_Result)

    Return $a_Path
EndFunc

Func Pathfinder_IsMapAvailable($mapID)
    Local $result = DllCall($DLL_PATH, "int:cdecl", "IsMapAvailable", "int", $mapID)
    If @error Then Return False
    Return $result[0] = 1
EndFunc

Func Pathfinder_GetAvailableMaps()
    Local $count = 0
    Local $result = DllCall($DLL_PATH, "ptr:cdecl", "GetAvailableMaps", "int*", $count)
    If @error Or $result[0] = 0 Then
        Return SetError(1, 0, 0)
    EndIf

    Local $pMapList = $result[0]
    $count = $result[1]

    Local $mapIds[$count]
    For $i = 0 To $count - 1
        $mapIds[$i] = DllStructGetData(DllStructCreate("int", $pMapList + $i * 4), 1)
    Next

    DllCall($DLL_PATH, "none:cdecl", "FreeMapList", "ptr", $pMapList)

    Return $mapIds
EndFunc

Func Pathfinder_GetMapStats($mapID)
    Local $result = DllCall($DLL_PATH, "ptr:cdecl", "GetMapStats", "int", $mapID)
    If @error Or $result[0] = 0 Then
        Return SetError(1, 0, 0)
    EndIf

    Local $pStats = $result[0]
    Local $stats = DllStructCreate($tagMapStats, $pStats)

    Local $statsArray[7]
    $statsArray[0] = DllStructGetData($stats, "trapezoid_count")
    $statsArray[1] = DllStructGetData($stats, "point_count")
    $statsArray[2] = DllStructGetData($stats, "teleport_count")
    $statsArray[3] = DllStructGetData($stats, "travel_portal_count")
    $statsArray[4] = DllStructGetData($stats, "npc_travel_count")
    $statsArray[5] = DllStructGetData($stats, "enter_travel_count")
    $statsArray[6] = DllStructGetData($stats, "error_code")

    DllCall($DLL_PATH, "none:cdecl", "FreeMapStats", "ptr", $pStats)

    Return $statsArray
EndFunc
