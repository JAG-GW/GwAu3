#include-once

Global $DLL_PATH = ""

Global Const $tagPathPoint = "float x;float y"
Global Const $tagPathResult = "ptr points;int point_count;float total_cost;int error_code;char error_message[256]"
Global Const $tagMapStats = "int trapezoid_count;int point_count;int teleport_count;int travel_portal_count;int npc_travel_count;int enter_travel_count;int error_code;char error_message[256]"


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

Func Pathfinder_FindPathGW($mapID, $startX, $startY, $destX, $destY, $simplifyRange = 0)
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

Func Pathfinder_FreePathResult($pResult)
    DllCall($DLL_PATH, "none:cdecl", "FreePathResult", "ptr", $pResult)
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
