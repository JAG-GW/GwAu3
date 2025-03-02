# GWA2 (Guild Wars AutoIt) Framework

## Branch Updates
Potential Updates -> https://github.com/JAG-GW

## GWA2 Current Version
- Updated by MrJambix and Glob of Armbraces
- Rewritten and enhanced by Greg76

## Structural Improvements
- **Improved modular architecture**: The new version reorganizes features into more coherent and better separated modules
- **Better code organization**: Grouping related functions into specific files to facilitate maintenance and evolution

## New Features
- **Extended game context support**: Added many functions to access character, agent, and item information
- **Advanced information system**: New functions like `GetAgents()` and `GetXY()` in Gwa2_ExtraInfo.au3 that allow for more sophisticated agent detection
- **Improved buff and effect management**: Full support for reading and manipulating buffs and effects on agents

## Technical Optimizations
- **Memory pointer updates**: Adaptation to changes in the Guild Wars client memory structure
- **Better data management**: More efficient retrieval of information via better organized memory structures
- **More reliable memory scan**: Improvements to search patterns to locate game functions

## Core Components
- **Gwa2_Core.au3**: Foundation for memory interaction and client manipulation
- **Gwa2_Enqueue.au3**: Command queue management for in-game actions
- **Gwa2_ExtraInfo.au3**: Advanced agent filtering and detection tools
- **Gwa2_GetInfo.au3**: Comprehensive game state information retrieval
- **Gwa2_Packet.au3**: Network packet construction and management
- **Gwa2_PerformAction.au3**: User interface and character action control

## Requirements
- AutoIt v3.3.14.5 or higher
- Guild Wars client (32-bit mode only)
- Administrator privileges for memory operations

## Best Practices
- **Do not modify the core GWA2 files**: To ensure compatibility with future updates, avoid modifying the files in the GWA2 folder
- **Create your own functions in GWAddOns.au3**: Implement your custom functions and routines in a separate GWAddOns.au3 file
- **Import both core and custom files**: Include both the core GWA2 files and your custom GWAddOns.au3 in your scripts

## Usage
```autoit
#include "GWAddOns.au3" ; Your custom file with additional functions

; Initialize the connection to Guild Wars
Initialize("Character Name")

; Get player information
$myID = GetMyID()
$myPosition = [GetAgentInfo($myID, "X"), GetAgentInfo($myID, "Y")]

; Perform actions
SendChat("Hello Guild Wars!")

; Use your custom functions from GWAddOns.au3
MyCustomFunction()
```

## Contribution

Contributions to this repository are welcome. If you have additional headers or improvements, please feel free to submit a pull request or open an issue.

## License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.