# GW PathFinding System [🚧 IN DEVELOPMENT]

An advanced pathfinding system for Guild Wars based on extraction and analysis of the game's navigation data.

> **⚠️ Important note**: This project is still in active development. Path calculation can take 1-5 minutes on large maps. Optimization is in progress!

## 🎯 Overview

This project implements a complete pathfinding system that:
- Extracts navigation data directly from game memory
- Generates optimized navigation graphs
- Calculates optimal paths between two points
- Visualizes navigation data in real-time
- Saves data in cache for optimal performance

## 📁 Project Structure

### Main Files

#### `GwAu3_PathFinding.au3`
The core of the pathfinding system. This file contains:
- A* algorithm for pathfinding
- Generation of navigation structures (Trapezoids, AABBs, Portals, Points)
- Map-specific teleporter management
- Visibility calculation between points
- Path optimization (path smoothing)

#### `GwAu3_Data_MapContext.au3`
Interface with game memory to extract:
- Terrain collision data
- Map boundaries
- Navigation zones (PathingMaps)
- Trapezoids that define walkable areas

#### `GwAu3_PathFinding_Cache.au3`
Binary cache system (.mpf format) that:
- Saves calculated navigation data
- Instantly loads precalculated data
- Reduces initialization time from ~30s to <100ms
- Manages version compatibility

#### `GwAu3_PathFinding_Visualizer_Draw.au3`
Graphical visualization interface that displays:
- Trapezoids (navigation zones)
- AABBs (bounding boxes)
- Portals (connections between zones)
- Navigation points
- Calculated path
- Teleporters

#### `Pathfinding_Tester_Draw.au3`
Test application with GUI for:
- Testing pathfinding in real-time
- Visualizing navigation data
- Setting destinations by right-click
- Adjusting display options

#### `Cache_Analyzer.au3`
Cache file analysis tool that:
- Lists all existing .mpf files
- Compares with map database
- Identifies missing maps
- Exports reports

### Data Files

#### `mapinfo.csv`
Map database containing:
- Map ID
- Map name (Gladiators_Arena, etc.)

## 🚀 How to Use

### For Users

1. **Launch pathfinding test**
   ```
   - Run Pathfinding_Tester_Draw.au3
   - Select your character
   - Click "Start"
   - Right-click on visualization to set destination
   - Click "Test Path" to calculate path
   ```

2. **Visualization options**
   - **Trapezoids**: Basic navigation zones
   - **AABBs**: Bounding boxes for optimization
   - **Portals**: Connections between zones
   - **Connections**: Connectivity graph
   - **Points**: Detailed navigation points
   - **Teleports**: Teleportation points
   - **Wireframe**: Wireframe mode
   - **Gradient Colors**: Coloring by altitude

### For Developers

1. **Basic integration**
   ```autoit
   ; Initialize pathfinding with cache
   PathFinding_InitializeWithCache()
   
   ; Calculate a path
   Local $aPath = GetPath($fDestX, $fDestY)
   
   ; Use the path
   If IsArray($aPath) Then
       For $i = 1 To $aPath[0][0]
           ; Move to $aPath[$i][0], $aPath[$i][1]
       Next
   EndIf
   ```

2. **Cache generation**
   ```autoit
   ; Initialize normally
   PathFinding_Initialize()
   
   ; Save to cache
   PathFinding_SaveToCache()
   ```

## 🔧 Technical Details

### Data Structures

1. **Trapezoids**: Quadrilaterals defining walkable areas
2. **AABBs**: Axis-Aligned Bounding Boxes for acceleration
3. **Portals**: Segments connecting two adjacent AABBs
4. **Points**: Navigation points on portals
5. **Visibility Graph**: Direct connections between visible points

### Algorithm

1. Data extraction from memory
2. Navigation structure construction
3. Visibility graph generation
4. A* on graph to find optimal path
5. Path smoothing to reduce waypoints

### Cache Format (.mpf)

Binary format containing:
- Header with magic number and version
- Sections for each data type
- Visibility data compression
- Per-map teleporter support

## 📊 Performance

- **Without cache**: ~5-30 seconds initialization depending on map
- **With cache**: <100ms loading
- **Pathfinding**: 10-200ms for simple paths, **1-5 minutes on very large maps** ⚠️
- **Cache size**: 50KB-2MB depending on map

### ⚠️ Development Status

**This project is still in active development!** Path calculation performance is not yet optimal:
- Small maps and short paths: fast (~100ms)
- Large maps with complex paths: can take several minutes
- Algorithm optimization is in progress

## 🤝 Contributing

Contributions are welcome! Especially for:
- Adding missing teleporters
- Optimizing algorithms
- Improving visualization
- Documenting data structures

## ⚠️ Important Notes

- Requires administrator privileges
- Compatible only with Guild Wars 1
- Cache files are map-specific
- Visualization may slow down on very large maps