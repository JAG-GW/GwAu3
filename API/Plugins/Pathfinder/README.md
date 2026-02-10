# Pathfinding System Documentation

## Overview

The pathfinding system consists of two parts:
- **AutoIt**: Movement management, obstacle detection, smart path simplification, party management
- **DLL (C++)**: A* pathfinding on Guild Wars maps with obstacle avoidance and layer support

---

## Functions

### `UAI_GetObstacles()`
Retrieves obstacles from the agent cache for pathfinding.

```autoit
UAI_GetObstacles($Radius = 100, $DetectionRange = 4000, $CustomFilter = "")
```

| Parameter | Description |
|-----------|-------------|
| `$Radius` | Collision radius for each obstacle |
| `$DetectionRange` | Range to scan for agents |
| `$CustomFilter` | Filter function(s) separated by `\|` |

**Returns:** `[[X, Y, Radius], ...]`

**Examples:**
```autoit
; All living NPCs and gadgets (default)
$obs = UAI_GetObstacles(85, 4000)

; Only living enemies
$obs = UAI_GetObstacles(85, 4000, "UAI_Filter_IsLivingEnemy")

; Combined filters
$obs = UAI_GetObstacles(85, 4000, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsNPC")
```

---

### `Pathfinder_MoveTo()`
Moves to destination while avoiding obstacles, with combat and party management.

```autoit
Pathfinder_MoveTo($DestX, $DestY, $Obstacles = 0, $AggroRange = 1320, $FightRangeOut = 3500, $FinisherMode = 0, $CallFunc = "")
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `$DestX, $DestY` | — | Destination coordinates |
| `$Obstacles` | `0` | `0` = none, `[[x,y,r],...]` = static, `"FuncName"` = dynamic |
| `$AggroRange` | `1320` | Range to detect and fight enemies |
| `$FightRangeOut` | `3500` | Range out for fighting |
| `$FinisherMode` | `0` | Finisher mode for `UAI_Fight` |
| `$CallFunc` | `""` | Callback function called each loop iteration |

**Returns:** `True` if destination reached, `False` if interrupted (map change, party defeated)

---

### `Pathfinder_Initialize()`
Loads the DLL and initializes the pathfinding engine.

```autoit
Pathfinder_Initialize()
```

**Returns:** `True` on success, `False` if DLL failed to load

> Called automatically by `Pathfinder_MoveTo()` if not already initialized.

---

### `Pathfinder_Shutdown()`
Closes the DLL and frees all resources.

```autoit
Pathfinder_Shutdown()
```

> Called automatically at the end of `Pathfinder_MoveTo()`.

---

### `Pathfinder_FindPath()`
Finds a path with obstacle avoidance and returns waypoints as a 2D array.

```autoit
Pathfinder_FindPath($mapID, $startX, $startY, $startLayer, $destX, $destY, $aObstacles, $simplifyRange = 1250)
```

| Parameter | Description |
|-----------|-------------|
| `$mapID` | Map ID |
| `$startX, $startY` | Start coordinates |
| `$startLayer` | Start layer/plane (`-1` = auto-detect) |
| `$destX, $destY` | Destination coordinates |
| `$aObstacles` | `[[x, y, radius], ...]` or empty array |
| `$simplifyRange` | DLL-level simplification range (default `1250`) |

**Returns:** 2D array `[[x, y, layer], ...]` or `0` on error

**Error codes** (`@error`):
| Value | Meaning |
|-------|---------|
| `1` | DLL call failed |
| `2` | Pathfinding error (check `@extended` for DLL error code) |
| `3` | Invalid point data returned |

---

### `Pathfinder_FindPathRaw()`
Low-level version of `FindPath` that returns a raw pointer to `PathResult`.

```autoit
Pathfinder_FindPathRaw($mapID, $startX, $startY, $startLayer, $destX, $destY, $aObstacles, $simplifyRange = 1250)
```

**Returns:** Pointer to `PathResult` structure (must be freed with `Pathfinder_FreePathResult()`)

---

### `Pathfinder_IsMapAvailable()`
Checks if a map exists in the archive.

```autoit
Pathfinder_IsMapAvailable($mapID)
```

**Returns:** `True` / `False`

---

### `Pathfinder_GetAvailableMaps()`
Returns all available map IDs.

```autoit
Pathfinder_GetAvailableMaps()
```

**Returns:** 1D array of map IDs or `0` on error

---

### `Pathfinder_GetMapStats()`
Returns statistics for a given map.

```autoit
Pathfinder_GetMapStats($mapID)
```

**Returns:** Array `[trapezoid_count, point_count, teleport_count, travel_portal_count, npc_travel_count, enter_travel_count, error_code]`

---

### Setter Functions

```autoit
Pathfinder_SetPathUpdateInterval($interval)     ; Path recalculation interval (ms)
Pathfinder_SetWaypointReachedDistance($distance)  ; Waypoint reached threshold
Pathfinder_SetSimplifyRange($range)              ; Smart simplification distance
Pathfinder_SetObstacleUpdateInterval($interval)  ; Dynamic obstacle refresh rate (ms)
Pathfinder_SetDebug($bEnabled)                   ; Enable/disable debug logging
```

### Debug Functions

```autoit
Pathfinder_GetCurrentPath()           ; Returns current path (2D array)
Pathfinder_GetCurrentWaypointIndex()  ; Returns current waypoint index
```

---

## How It Works

### 1. Path Calculation
```
AutoIt calls DLL → DLL runs A* on map geometry (with layer support) → Returns raw waypoints [x, y, layer]
```

### 2. Smart Simplification
The DLL returns many waypoints. `_Pathfinder_SmartSimplify()` reduces them while preserving critical points:

- **Critical points** (always kept):
  - First and last waypoint
  - Layer transitions (important for bridges)
  - Points near obstacles (within `radius + 100` margin)
  - Points where removal would cause path to cross an obstacle

- **Non-critical points**: Kept only if distance from last kept point >= 1250

### 3. Movement Loop
```
┌──────────────────────────────────────────────┐
│  1. Check map change / party defeated        │
│  2. Wait if dead (until resurrected)         │
│  3. Update obstacles (if dynamic mode)       │
│  4. Detect stuck → move in cycling direction │
│  5. Recalculate path if needed               │
│  6. Move to current waypoint (with layer)    │
│  7. Fight if enemies in range                │
│  8. Wait for party if heroes too far         │
│  9. Wait for resurrection if dead allies     │
│ 10. Call $CallFunc if provided               │
│ 11. Wait if cinematic playing                │
│ 12. Sleep(32)                                │
└──────────────────────────────────────────────┘
         ↓ repeat until within 125 units
```

---

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `$g_iPathfinder_PathUpdateInterval` | 1000ms | Interval before recalculating path |
| `$g_iPathfinder_WaypointReachedDistance` | 250 | Distance to consider waypoint reached |
| `$g_iPathfinder_SimplifyRange` | 1250 | Max distance between non-critical waypoints |
| `$g_iPathfinder_ObstacleUpdateInterval` | 1000ms | Obstacle refresh rate (dynamic mode) |
| `$g_iPathfinder_StuckCheckInterval` | 500ms | Stuck detection interval |
| `$g_iPathfinder_StuckDistance` | 100 | Movement threshold for stuck detection |

---

## DLL Functions

### `Initialize()` / `Shutdown()`
```cpp
int32_t Initialize();   // Returns 1 on success, 0 on failure
void Shutdown();         // Frees all resources
```

### `FindPathWithObstacles()`
```cpp
PathResult* FindPathWithObstacles(
    int32_t mapID,
    float startX, float startY,
    int32_t startLayer,
    float destX, float destY,
    ObstacleZone* obstacles,
    int32_t obstacleCount,
    float simplifyRange
);
```

1. Loads map navigation mesh from `maps.zip` (read directly from the archive, do not extract)
2. Marks zones intersecting obstacles as blocked
3. Runs A* algorithm with layer support
4. Returns waypoints array `[x, y, layer]`

> Must call `FreePathResult()` after use.

### `IsMapAvailable()` / `GetAvailableMaps()`
```cpp
int32_t IsMapAvailable(int32_t mapId);            // Returns 1 if available
int32_t* GetAvailableMaps(int32_t* outCount);     // Must call FreeMapList()
void FreeMapList(int32_t* mapList);
```

### `GetMapStats()`
```cpp
MapStats* GetMapStats(int32_t mapId);  // Must call FreeMapStats()
void FreeMapStats(MapStats* stats);
```

### `LoadMapFromFile()`
```cpp
int32_t LoadMapFromFile(int32_t mapId, const char* filePath);  // Load external JSON map
```

### `GetPathfinderVersion()`
```cpp
const char* GetPathfinderVersion();  // Returns "GWPathfinder v1.0.0"
```

---

## Data Structures

### PathPoint
```cpp
struct PathPoint {
    float x;        // X coordinate
    float y;        // Y coordinate
    int32_t layer;  // Layer/plane (0 = ground, 1+ = elevated/bridge)
};
```

### PathResult
```cpp
struct PathResult {
    PathPoint* points;          // Array of waypoints
    int32_t point_count;        // Number of waypoints
    float total_cost;           // Total path cost
    int32_t error_code;         // 0 = success (see error codes below)
    char error_message[256];    // Error description
};
```

### ObstacleZone
```cpp
struct ObstacleZone {
    float x;       // Center X
    float y;       // Center Y
    float radius;  // Collision radius
};
```

### MapStats
```cpp
struct MapStats {
    int32_t trapezoid_count;
    int32_t point_count;
    int32_t teleport_count;
    int32_t travel_portal_count;
    int32_t npc_travel_count;
    int32_t enter_travel_count;
    int32_t error_code;
    char error_message[256];
};
```

---

## Error Codes (DLL)

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Map not found in archive |
| `2` | No path found (unreachable destination) |
| `-1` | Initialization failed |
| `-2` | C++ exception |
| `-3` | Unknown exception |

---

## Available Filters

| Filter | Description |
|--------|-------------|
| `UAI_Filter_IsLivingEnemy` | Living enemies (Allegiance = 3) |
| `UAI_Filter_IsLivingAlly` | Living allies |
| `UAI_Filter_IsNPC` | NPCs (Living type) |
| `UAI_Filter_IsGadget` | Gadgets |
| `UAI_Filter_IsLivingNPC` | Living NPCs (not dead) |
| `UAI_Filter_IsLivingNPCOrGadget` | Living NPCs or gadgets |

---

## File Structure

| File | Description |
|------|-------------|
| `_Pathfinder.au3` | Main entry point (includes all modules) |
| `Pathfinder_Core.au3` | DLL interface and wrapper functions |
| `Pathfinder_Movements.au3` | Movement logic, combat, party management |
| `GWPathfinder.dll` | Compiled pathfinding engine |
| `maps.zip` | Map data archive (~400+ maps) — **must stay in the same folder as the DLL, do not extract** |

> The DLL automatically locates `maps.zip` in its own directory and reads map data directly from the archive.

---

## Usage Example

```autoit
#include "API/Plugins/Pathfinder/_Pathfinder.au3"
#include "API/Plugins/SmartCast/_UtilityAI.au3"
$DLL_PATH = "API\Plugins\Pathfinder\GWPathfinder.dll"

; Get obstacles (living NPCs and gadgets within 4000 range)
$obstacles = UAI_GetObstacles(85, 4000, "UAI_Filter_IsLivingNPCOrGadget")

; Move to destination, avoiding obstacles, fighting enemies in 1320 range
Pathfinder_MoveTo(6364, -2729, $obstacles, 1320, 3500, 0)

; With dynamic obstacles and a callback function
Pathfinder_MoveTo(6364, -2729, "UAI_GetObstacles", 1320, 3500, 0, "MyCallbackFunc")
```

## Acknowledgements

Special thanks to **[QuarkyUp](https://github.com/QuarkyUp)** for the inspiration and help with this project.