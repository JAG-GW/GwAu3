# Pathfinding System Documentation

## Overview

The pathfinding system consists of two parts:
- **AutoIt**: Movement management, obstacle detection, smart path simplification
- **DLL (C++)**: A* pathfinding on Guild Wars maps with obstacle avoidance

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
Moves to destination while avoiding obstacles.

```autoit
Pathfinder_MoveTo($DestX, $DestY, $Obstacles, $AggroRange, $FightRangeOut, $FinisherMode)
```

| Parameter | Description |
|-----------|-------------|
| `$DestX, $DestY` | Destination coordinates |
| `$Obstacles` | `0` = none, `[[x,y,r],...]` = static, `"FuncName"` = dynamic |
| `$AggroRange` | Range to detect enemies (0 = no fighting) |

**Returns:** `True` if destination reached, `False` if interrupted

---

## How It Works

### 1. Path Calculation
```
AutoIt calls DLL → DLL runs A* on map geometry → Returns raw waypoints
```

### 2. Smart Simplification
The DLL returns many waypoints. `_Pathfinder_SmartSimplify()` reduces them while preserving critical points:

- **Critical points** (always kept):
  - First and last waypoint
  - Points near obstacles (within `radius + 100` margin)
  - Points where removal would cause path to cross an obstacle

- **Non-critical points**: Kept only if distance from last kept point >= 1250

### 3. Movement Loop
```
┌─────────────────────────────────────────┐
│ 1. Check death / map change             │
│ 2. Update obstacles (if dynamic mode)   │
│ 3. Detect stuck → random offset if 3x   │
│ 4. Recalculate path if needed           │
│ 5. Move to current waypoint             │
│ 6. Fight if enemies in range            │
│ 7. Sleep(32)                            │
└─────────────────────────────────────────┘
         ↓ repeat until arrived
```

---

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `$g_iPathfinder_PathUpdateDistance` | 500 | Recalc path after moving this distance |
| `$g_iPathfinder_WaypointReachedDistance` | 100 | Distance to consider waypoint reached |
| `$g_iPathfinder_SimplifyRange` | 1250 | Max distance between non-critical waypoints |
| `$g_iPathfinder_ObstacleUpdateInterval` | 500ms | Obstacle refresh rate (dynamic mode) |
| `$g_iPathfinder_StuckCheckInterval` | 1000ms | Stuck detection interval |
| `$g_iPathfinder_StuckDistance` | 50 | Movement threshold for stuck detection |

---

## DLL Functions

### `FindPathWithObstacles()`
```cpp
PathResult* FindPathWithObstacles(
    int mapID,
    float startX, float startY,
    float destX, float destY,
    ObstacleZone* obstacles,
    int obstacleCount,
    float simplifyRange
);
```

1. Loads map navigation mesh from `maps.zip`
2. Marks zones intersecting obstacles as blocked
3. Runs A* algorithm
4. Returns waypoints array

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

## Usage Example

```autoit
#include "API/Pathfinding/_Pathfinder.au3"
#include "../../API/SmartCast/_UtilityAI.au3"
$DLL_PATH = "..\..\API\Pathfinding\GWPathfinder.dll"

; Get obstacles (living NPCs and gadgets within 4000 range)
$obstacles = UAI_GetObstacles(85, 4000, "UAI_Filter_IsLivingNPCOrGadget")

; Move to destination, avoiding obstacles, fighting enemies in 1320 range
Pathfinder_MoveTo(6364, -2729, $obstacles, 1320, 3500, 0)
```
