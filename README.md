# GwAu3 (Guild Wars AutoIt 3) Framework
- GwAu3 is a rewritten Gwa2, improved by Greg76, KleuTSchi, Logan and all other participants on the Jag-Gw community server

## Branch Updates
Potential Updates -> https://github.com/JAG-GW

## GWA2 Current Version
- Updated by MrJambix and Glob of Armbraces

## Structural Improvements
- **Improved modular architecture**: The new version reorganizes features into more coherent and better separated modules
- **Better code organization**: Grouping related functions into specific files to facilitate maintenance and evolution

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
- Guild Wars client

## Best Practices
- **Do not modify the core GwAu3 files**: To ensure compatibility with future updates, avoid modifying the files in the GwAu3 folder
- **Create your own functions in GwAu3_AddOns.au3**: Implement your custom functions and routines in a separate GwAu3_AddOns.au3 file
- **Import both core and custom files**: Include both the core GwAu3 files and your custom GwAu3_AddOns.au3 in your scripts

## Contribution
Contributions to this repository are welcome. If you have additional headers or improvements, please feel free to submit a pull request or open an issue.

## License
This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.