# GwAu3 - Guild Wars AutoIt3 API

A comprehensive AutoIt3 API for automating and controlling Guild Wars.

## 📋 Description

GwAu3 is an AutoIt3 library that provides a programming interface to interact with the Guild Wars game. It allows you to create bots, assistance tools, and automation applications for Guild Wars.

## ✨ Features

### Core
- **Initialization**: Connection to Guild Wars process
- **Memory**: Read/write game memory
- **Scanner**: Pattern search in memory
- **Updates**: Automatic update system from GitHub

### Commands
- **Agent**: Targeting, interaction with NPCs and players
- **Attributes**: Attribute points management
- **Chat**: Send messages, whispers
- **Friend**: Friend list and status management
- **Party**: Party and heroes management
- **Inventory**: Item manipulation
- **Map**: Movement and travel
- **Skills**: Skill usage
- **Trade**: Buy/sell with merchants
- ...

### Data
- **Agent**: Game entity information
- **Guild**: Guild data
- **Inventory**: Inventory management
- **Map**: Map information
- **Party**: Party composition and states
- **Quest**: Quest tracking
- **Skill**: Skills database
- ...

## 🚀 Installation

1. **Prerequisites**
   - AutoIt3 v3.3.16.1 or higher (32-bit)
   - Guild Wars installed
   - Windows 7/8/10/11

2. **Installation**
   ```
   1. Download the project
   2. Ensure all files are in the same folder
   3. Launch Guild Wars
   4. Run your AutoIt3 script
   ```

## 💻 Usage

### Basic Example

```autoit
#include "Core.au3"

; Initialize with character name
Core_Initialize("Character Name")

; Or initialize with process PID
; Core_Initialize($ProcessID)

; Usage examples
Local $l_i_MyID = Agent_GetMyID()
Local $l_s_CharName = Player_GetCharname()
Local $l_i_MapID = Map_GetCharacterInfo("MapID")

; Movement
Map_Move(1000, -500)

; Targeting
Agent_ChangeTarget($TargetID)

; Use a skill
Skill_UseSkill(1) ; Uses skill 1
```

## 📚 Module Documentation
📖 [AutoIt Naming Convention Documentation](GwAu3/Constants/README.md)
### Core
- `Core_Initialize($CharacterName)` : Initialize connection
- `Core_SendPacket(...)` : Send packets to server
- `Core_Enqueue(...)` : Queue commands

### Agent
- `Agent_GetMyID()` : Returns your character's ID
- `Agent_ChangeTarget($AgentID)` : Target an agent
- `Agent_GetAgentInfo($AgentID, $Info)` : Get agent information

### Map
- `Map_Move($X, $Y)` : Move character
- `Map_TravelTo($MapID)` : Travel to a zone
- `Map_GetCharacterInfo($Info)` : Current zone information

### Inventory
- `Item_UseItem($Item)` : Use an item
- `Item_MoveItem($Item, $Bag, $Slot)` : Move an item
- `Item_GetBagInfo($BagNumber, $Info)` : Bag information

### Skills
- `Skill_UseSkill($SkillSlot)` : Use a skill
- `Skill_GetSkillInfo($SkillID, $Info)` : Skill information

## ⚙️ Configuration

### Automatic Updates

The `config.ini` file in GwAu3\GwAu3\Core allows you to configure automatic updates:

```ini
[Update]
Enabled=1      ;0 = Disable Automatic Updates
Verbose=1      ;0 = Silently update and delete, no prompts (Use at your own risk)
Owner=JAG-GW
Repo=GwAu3
Branch=main
```

## ⚠️ Warnings

- **Use at your own risk**: Using bots may violate Guild Wars Terms of Service
- **32-bit mode required**: AutoIt3 must be run in 32-bit (x86) mode
- **Antivirus**: Some antivirus software may detect scripts as potential threats

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Improve documentation

## 📄 License
This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## 🙏 Acknowledgments

- Guild Wars community
- AutoIt3 developers
- All project contributors
