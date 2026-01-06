# COMPLETE SMARTCAST SYSTEM DOCUMENTATION
## Technical and Customization Guide

*Created by Greg-76 (Alusion)*
*Complete Documentation - Version 2.0*

---

## TABLE OF CONTENTS

0. [Getting Started](#0-getting-started)
1. [Overview](#1-overview)
2. [System Architecture](#2-system-architecture)
3. [Execution Flow](#3-execution-flow)
4. [UAI Cache System](#4-uai-cache-system)
5. [BestTarget System (Targeting)](#5-besttarget-system-targeting)
6. [CanUse System (Conditions)](#6-canuse-system-conditions)
7. [Resource Management System](#7-resource-management-system)
8. [Filters and Utilities](#8-filters-and-utilities)
9. [Advanced Customization](#9-advanced-customization)
10. [Practical Examples](#10-practical-examples)
11. [Optimization and Best Practices](#11-optimization-and-best-practices)

---

## 0. GETTING STARTED

### Quick Start

**1. Include the SmartCast module in your script:**

```autoit
#include "API/SmartCast/_UtilityAI.au3"
```

**2. Initialize the skillbar cache when entering an explorable area:**

```autoit
UAI_CacheSkillBar()
```

**3. Start combat using one of these methods:**

```autoit
; Method 1: Full combat loop (recommended)
; Fights until all enemies are dead or player dies
UAI_Fight($x, $y, $aggroRange, $maxDistance, $fightMode)

; Method 2: Single skill cycle
; Use in your own loop for more control
UAI_UseSkills($x, $y, $aggroRange, $maxDistance)
```

### UAI_Fight() Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `$a_f_X` | required | X coordinate of combat center |
| `$a_f_Y` | required | Y coordinate of combat center |
| `$a_f_AggroRange` | 1320 | Maximum distance to engage enemies |
| `$a_f_MaxDistanceToXY` | 3500 | Max distance before exiting combat |
| `$a_i_FightMode` | `$g_i_FinisherMode` | Combat mode (see below) |

### Combat Modes

```autoit
$g_i_FinisherMode = 0  ; Target low HP enemies to secure kills
$g_i_PressureMode = 1  ; Target high HP enemies to spread damage
```

### Minimal Example Script

```autoit
#include "API/SmartCast/_UtilityAI.au3"

; Wait for map load
While Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE
    Sleep(100)
WEnd

; Initialize skillbar cache
UAI_CacheSkillBar()

; Main loop
While True
    ; Get current position
    Local $x = Agent_GetAgentInfo(-2, "X")
    Local $y = Agent_GetAgentInfo(-2, "Y")

    UAI_Fight($x, $y, 1320, 3500, $g_i_FinisherMode)

    Sleep(100)
WEnd
```

### Skill Bar Recommendation

Place skills in order of priority (slot 1 = highest priority):

| Priority | Slots | Skill Types |
|----------|-------|-------------|
| High | 1-3 | Interrupts, key debuffs, finishers |
| Medium | 4-6 | Damage skills, conditions |
| Low | 7-8 | Self-buffs, situational, resurrection |

The system processes slots 1→8 sequentially. The first usable skill that meets its conditions will be cast.

---

## 1. OVERVIEW

### What is SmartCast?

**SmartCast** is an intelligent combat automation system for Guild Wars. It automatically manages:
- Optimal targeting for each skill
- Skill usage conditions
- Resource management (energy, adrenaline, health)
- Combos and skill chains
- Form changes (Ursan, Raven, Volfen)
- Intelligent auto-attacks
- Weapon set switching

### Weapon Set Switching

The SmartCast system integrates an **automatic weapon set switching** feature. This feature allows:

- **Automatic weapon switching** based on the skill being used
- **Weapon set adaptation** according to skill modifiers (attribute, profession, type)
- **Build optimization** by allowing the use of skills requiring different weapons in the same skill bar

**Usage examples:**
- A hybrid build could use a 40/40 for spells and automatically switch to a +20% enchantment bonus for enchantments.
- An assassin could alternate between daggers for attacks and a hammer depending on the skills.
- A monk low on energy can switch to a set that gives more energy. (Same for HP)

This functionality is managed by the `Equipment/UtilityAI_WeaponSets.au3` module and integrates seamlessly into the system's execution flow.

### System Philosophy

SmartCast works on a principle of **separation of concerns**:
- **Each skill** has its own targeting function (`BestTarget_`)
- **Each skill** has its own condition function (`CanUse_`)
- The system **caches** information to optimize performance via the **UAI Cache System**

---

## 2. SYSTEM ARCHITECTURE

### File Structure

```
API/SmartCast/
│
├── _UtilityAI.au3              # Main entry point (includes all modules)
├── SmartCast_Const.au3         # Constants and global variables
│
├── Core/                       # Core System
│   ├── _Core.au3               # Entry point for core modules
│   ├── UtilityAI_Core.au3      # System core (combat loop): UAI_Fight(), UAI_UseSkills()
│   ├── UtilityAI_CanCast.au3   # Resource checks: UAI_CanCast(), UAI_CanAutoAttack()
│   └── UtilityAI_Utils.au3     # Utility functions
│
├── Cache/                      # UAI Cache System
│   ├── _Cache.au3              # Entry point for cache modules
│   ├── UtilityAI_Cache.au3     # Cache coordination: Cache_SkillBar(), UAI_UpdateCache()
│   ├── UtilityAI_AgentCache.au3       # Agent data cache
│   ├── UtilityAI_StaticSkillCache.au3 # Static skill data cache
│   ├── UtilityAI_DynamicSkillCache.au3# Dynamic skill data cache
│   ├── UtilityAI_EffectsCache.au3     # Effects, Bonds, Visible Effects cache
│   ├── UtilityAI_BestTargetCache.au3  # BestTarget dispatcher: UAI_GetBestTargetFunc()
│   └── UtilityAI_CanUseCache.au3      # CanUse dispatcher: UAI_GetCanUseFunc()
│
├── Targeting/                  # Agent Targeting System
│   ├── _Targeting.au3          # Entry point for targeting modules
│   ├── UtilityAI_GetAgent.au3  # Targeting functions: UAI_GetNearestAgent(), UAI_GetBestAOETarget()
│   └── UtilityAI_AgentFilter.au3 # Agent filters: UAI_Filter_IsLivingEnemy(), etc.
│
├── Equipment/                  # Equipment Management
│   ├── _Equipment.au3          # Entry point for equipment modules
│   └── UtilityAI_WeaponSets.au3 # Weapon set management: UAI_ChangeWeaponSet(), etc.
│
└── Skills/                     # Skill-Type Specific Implementations
    ├── _Skills.au3             # Entry point (includes all skill type files)
    ├── UtilityAI_Attack.au3    # Attack skills (melee, ranged, pet attacks)
    ├── UtilityAI_Chant.au3     # Chant skills (Paragon)
    ├── UtilityAI_Condition.au3 # Condition-inflicting skills
    ├── UtilityAI_EchoRefrain.au3 # Echo and Refrain skills (Paragon)
    ├── UtilityAI_Enchantment.au3 # Enchantment spells
    ├── UtilityAI_Form.au3      # Form skills (Ursan, Raven, Volfen, etc.)
    ├── UtilityAI_Glyph.au3     # Glyph skills (Elementalist)
    ├── UtilityAI_Hex.au3       # Hex spells
    ├── UtilityAI_ItemSpell.au3 # Item spells (Ritualist bundles)
    ├── UtilityAI_PetAttack.au3 # Pet attack commands (Ranger)
    ├── UtilityAI_Preparation.au3 # Preparation skills (Ranger)
    ├── UtilityAI_Ritual.au3    # Binding Rituals (Ritualist spirits)
    ├── UtilityAI_Shout.au3     # Shout skills (Warrior, Paragon)
    ├── UtilityAI_Signet.au3    # Signet skills
    ├── UtilityAI_Skill10.au3   # Special skill type 10
    ├── UtilityAI_Skill16.au3   # Special skill type 16
    ├── UtilityAI_Spell.au3     # Generic spell skills
    ├── UtilityAI_Stance.au3    # Stance skills
    ├── UtilityAI_Title.au3     # Title-based skills (Sunspear, Lightbringer, etc.)
    ├── UtilityAI_Trap.au3      # Trap skills (Ranger, Assassin)
    ├── UtilityAI_Ward.au3      # Ward spells (Elementalist)
    ├── UtilityAI_WeaponSpell.au3 # Weapon spells (Ritualist)
    └── UtilityAI_Well.au3      # Well spells (Necromancer)
```

### Skills Folder Organization

The `Skills/` folder contains **skill-type specific implementations** of `BestTarget_` and `CanUse_` functions. Each file groups skills by their **skill type** (as defined in the game data), making it easier to:

- Find and modify behavior for specific skill types
- Apply common logic to all skills of a given type
- Maintain consistent targeting patterns within skill categories

**How it works:**
1. `Cache/UtilityAI_BestTargetCache.au3` and `Cache/UtilityAI_CanUseCache.au3` act as **dispatchers**
2. They determine the skill ID and return the appropriate function name from `Skills/`
3. Each `UtilityAI_<SkillType>.au3` file contains the actual `BestTarget_` and `CanUse_` implementations

**Example:** When casting "Flare" (a Spell):
1. `UAI_GetBestTargetFunc()` identifies it as Flare and returns "BestTarget_Flare"
2. The function is called dynamically from `UtilityAI_Spell.au3`
3. `BestTarget_Flare()` in that file returns the target

### Main Global Variables

```autoit
Global $g_i_BestTarget = 0                ; Current best target ID
Global $g_i_LastCalledTarget = 0          ; Last called target
Global $g_amx2_SkillBarCache[9][44]       ; Cache of all skill info
Global $g_as_BestTargetCache[9]           ; BestTarget function cache
Global $g_as_CanUseCache[9]               ; CanUse function cache
Global $g_b_CanUseSkill = True            ; Flag if skill can be used
Global $g_b_SkillChanged = False          ; Flag for form changes
```

### UAI Cache Global Variables

```autoit
; Agent Cache
Global $g_a2D_AgentCache[1][64]           ; 2D array [AgentIndex][Property]
Global $g_i_AgentCacheCount               ; Number of cached agents
Global $g_i_PlayerCacheIndex              ; Player's index in cache

; Static Skill Cache
Global $g_a2D_StaticSkillCache[9][43]     ; Static skill data per slot

; Dynamic Skill Cache
Global $g_a2D_DynamicSkillCache[9][6]     ; Dynamic skill data per slot

; Effects Cache
Global $g_a_EffectsCache[1][1][1]         ; 3D array [AgentIndex][EffectIndex][Property]
Global $g_a_BondsCache[1][1][1]           ; 3D array [AgentIndex][BondIndex][Property]
Global $g_a_VisEffectsCache[1][1][1]      ; 3D array [AgentIndex][VisEffectIndex][Property]
```

---

## 3. EXECUTION FLOW

### 3.1 UAI_Fight() Function - Main Entry Point

```autoit
Func UAI_Fight($a_f_X, $a_f_Y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500)
```

**Parameters:**
- `$a_f_X, $a_f_Y` : Reference coordinates for combat
- `$a_f_AggroRange` : Maximum aggro distance (default: 1320)
- `$a_f_MaxDistanceToXY` : Max distance before leaving combat (default: 3500)

**Operation:**
1. Loop until:
   - All enemies are dead
   - Player is dead
   - Party is wiped
   - Map/instance change
2. Calls `UAI_UseSkills()` each iteration
3. 32ms sleep between each iteration

### 3.2 UAI_UseSkills() Function - Main Loop

```autoit
Func UAI_UseSkills($a_f_X, $a_f_Y, $a_f_AggroRange = 1320, $a_f_MaxDistanceToXY = 3500)
```

**Execution sequence:**

```
┌─────────────────────────────────────┐
│ FOR EACH SKILL SLOT (1-8):          │
│                                     │
│ 1. Skip empty slots                 │
│    - If SkillID = 0, continue       │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 2. Update UAI Caches (once per slot)│
│    - UAI_UpdateCache($a_f_AggroRange)│
│    - Check enemies exist            │
│    - Check weapon set switching     │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 3. Safety checks                    │
│    - Player dead?                   │
│    - Party wiped?                   │
│    - Not in explorable?             │
│    - Knocked down?                  │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 4. Form change check                │
│    - Ursan/Raven/Volfen active?     │
│    - Re-cache skillbar if needed    │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 5. Intelligent auto-attack          │
│    - Check CanAutoAttack()          │
│    - Attack nearest enemy if allowed│
│    - Cancel attack if forbidden     │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 6. Priority skills                  │
│    - UAI_PrioritySkills()           │
│    - Resurrection, emergency heals  │
│    - Critical interrupts            │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 7. Bundle drop                      │
│    - UAI_DropBundle()               │
│    - Drop held items if in combat   │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 8. Cast skill                       │
│    ├─ UAI_CanCast($i)          │
│    │   └─ Check recharge,           │
│    │      adrenaline, resources     │
│    │                                │
│    ├─ $g_i_BestTarget = Call(BestTarget_XXX)
│    │   └─ Get optimal target        │
│    │                                │
│    ├─ $g_b_CanUseSkill = Call(CanUse_XXX)
│    │   └─ Check skill conditions    │
│    │                                │
│    └─ UAI_UseSkillEX($i, $g_i_BestTarget)
│        └─ Cast the skill            │
│        └─ Apply form change if any  │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 9. Distance check                   │
│    - Too far from $a_f_X,$a_f_Y?    │
│    - ExitLoop if > MaxDistance      │
└─────────────────────────────────────┘
```

**Note:** The loop processes each slot sequentially. When a skill is successfully cast, the loop continues to the next slot. If the player moves too far from the reference point, the loop exits early.

### 3.3 UAI_UseSkillEX() Function - Cast a Skill

```autoit
Func UAI_UseSkillEX($a_i_SkillSlot, $a_i_AgentID = -2)
```

**Sequence:**
1. **Change target** if necessary (if target ≠ self)
2. **Switch weapon set** if enabled and beneficial
3. **Use skill** via `Skill_UseSkill($a_i_SkillSlot, $a_i_AgentID)`
4. **Short delay** (128ms) to allow skill activation
5. **Call target** for heroes/henchmen (if target ≠ self and not already called)
6. **Intelligent waiting** based on skill type:
   - **Melee/Touch/Attack skills** : Wait until target is at 240 range (max 5s)
   - **Cancel if target dies** (except resurrection skills)
7. **Wait for cast end** : Until:
   - Player dead
   - Target out of range (>1320)
   - Instance change
   - No longer casting
   - **Cancel if target dies during cast** (except resurrection skills)

---

## 4. UAI CACHE SYSTEM

The **UAI (Utility AI) Cache System** is the new centralized caching system that replaces the old individual memory reads. It provides significant performance improvements by reading all necessary data in batches.

### 4.1 Agent Cache (UtilityAI_AgentCache.au3)

Caches all agent (player, allies, enemies, NPCs) data in a single batch read.

#### Update Function

```autoit
Func UAI_UpdateAgentCache()
```

Call this at the beginning of each combat loop iteration to refresh all agent data.

#### Accessor Functions

```autoit
; Get player info (using cached player index)
UAI_GetPlayerInfo($a_i_InfoType)

; Get any agent's info by AgentID
UAI_GetAgentInfoByID($a_i_AgentID, $a_i_InfoType)

; Get agent's cache index from AgentID
UAI_GetIndexByID($a_i_AgentID)
```

#### Available Agent Properties

```autoit
Global Enum $GC_UAI_AGENT_Ptr, _           ; Agent pointer
    $GC_UAI_AGENT_ID, _                    ; Agent ID
    $GC_UAI_AGENT_X, _                     ; X position
    $GC_UAI_AGENT_Y, _                     ; Y position
    $GC_UAI_AGENT_HP, _                    ; HP ratio (0.0 - 1.0)
    $GC_UAI_AGENT_CurrentHP, _             ; Current HP value
    $GC_UAI_AGENT_MaxHP, _                 ; Max HP value
    $GC_UAI_AGENT_CurrentEnergy, _         ; Current Energy
    $GC_UAI_AGENT_MaxEnergy, _             ; Max Energy
    $GC_UAI_AGENT_ModelState, _            ; Model state
    $GC_UAI_AGENT_TypeMap, _               ; Type map
    $GC_UAI_AGENT_Allegiance, _            ; Allegiance
    $GC_UAI_AGENT_WeaponItemType, _        ; Weapon type
    $GC_UAI_AGENT_WeaponItemId, _          ; Weapon item ID
    $GC_UAI_AGENT_OffhandItemType, _       ; Offhand type
    $GC_UAI_AGENT_OffhandItemId, _         ; Offhand item ID
    $GC_UAI_AGENT_IsLivingType, _          ; Is living agent
    $GC_UAI_AGENT_IsCasting, _             ; Is casting
    $GC_UAI_AGENT_IsAttacking, _           ; Is attacking
    $GC_UAI_AGENT_IsMoving, _              ; Is moving
    $GC_UAI_AGENT_IsKnocked, _             ; Is knocked down
    $GC_UAI_AGENT_IsDead, _                ; Is dead
    $GC_UAI_AGENT_Overcast, _              ; Overcast amount
    ; ... and more
```

#### Usage Examples

```autoit
; Get player's HP ratio
Local $l_f_MyHP = UAI_GetPlayerInfo($GC_UAI_AGENT_HP)

; Get player's current energy
Local $l_f_MyEnergy = UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy)

; Check if player is casting
If UAI_GetPlayerInfo($GC_UAI_AGENT_IsCasting) Then
    ; Do something
EndIf

; Get enemy's HP by AgentID
Local $l_f_EnemyHP = UAI_GetAgentInfoByID($l_i_EnemyID, $GC_UAI_AGENT_HP)
```

### 4.2 Static Skill Cache (UtilityAI_StaticSkillCache.au3)

Caches **static** skill data that doesn't change during gameplay (costs, durations, types, etc.).

#### Update Function

```autoit
Func UAI_CacheSkillBar()
```

Call this once when entering a map or when the skillbar changes (form transformation).

#### Accessor Function

```autoit
UAI_GetStaticSkillInfo($a_i_Slot, $a_i_InfoType)
```

#### Available Static Skill Properties

```autoit
Global Enum $GC_UAI_STATIC_SKILL_SkillID, _
    $GC_UAI_STATIC_SKILL_Campaign, _
    $GC_UAI_STATIC_SKILL_SkillType, _
    $GC_UAI_STATIC_SKILL_Special, _
    $GC_UAI_STATIC_SKILL_ComboReq, _
    $GC_UAI_STATIC_SKILL_Effect1, _
    $GC_UAI_STATIC_SKILL_Condition, _
    $GC_UAI_STATIC_SKILL_Effect2, _
    $GC_UAI_STATIC_SKILL_WeaponReq, _
    $GC_UAI_STATIC_SKILL_Profession, _
    $GC_UAI_STATIC_SKILL_Attribute, _
    $GC_UAI_STATIC_SKILL_EnergyCost, _
    $GC_UAI_STATIC_SKILL_HealthCost, _
    $GC_UAI_STATIC_SKILL_Adrenaline, _
    $GC_UAI_STATIC_SKILL_Activation, _
    $GC_UAI_STATIC_SKILL_Aftercast, _
    $GC_UAI_STATIC_SKILL_Recharge, _
    $GC_UAI_STATIC_SKILL_Overcast, _
    ; ... and more
```

#### Usage Examples

```autoit
; Get skill type for slot 1
Local $l_i_SkillType = UAI_GetStaticSkillInfo(1, $GC_UAI_STATIC_SKILL_SkillType)

; Get energy cost for slot 3
Local $l_i_EnergyCost = UAI_GetStaticSkillInfo(3, $GC_UAI_STATIC_SKILL_EnergyCost)

; Get activation time for slot 5
Local $l_f_Activation = UAI_GetStaticSkillInfo(5, $GC_UAI_STATIC_SKILL_Activation)
```

### 4.3 Dynamic Skill Cache (UtilityAI_DynamicSkillCache.au3)

Caches **dynamic** skill data that changes during gameplay (recharge status, adrenaline, etc.).

#### Update Function

```autoit
Func UAI_UpdateDynamicSkillbarCache()
```

Call this each combat loop iteration.

#### Accessor Function

```autoit
UAI_GetDynamicSkillInfo($a_i_Slot, $a_i_InfoType)
```

#### Available Dynamic Skill Properties

```autoit
Global Enum $GC_UAI_DYNAMIC_SKILL_Adrenaline, _
    $GC_UAI_DYNAMIC_SKILL_AdrenalineB, _
    $GC_UAI_DYNAMIC_SKILL_IsRecharged, _
    $GC_UAI_DYNAMIC_SKILL_SkillID, _
    $GC_UAI_DYNAMIC_SKILL_Event, _
    $GC_UAI_DYNAMIC_SKILL_RechargeTime
```

#### Usage Examples

```autoit
; Check if skill in slot 2 is recharged
If UAI_GetDynamicSkillInfo(2, $GC_UAI_DYNAMIC_SKILL_IsRecharged) Then
    ; Skill is ready
EndIf

; Get remaining recharge time for slot 4
Local $l_f_RechargeTime = UAI_GetDynamicSkillInfo(4, $GC_UAI_DYNAMIC_SKILL_RechargeTime)

; Get current adrenaline for slot 1
Local $l_i_Adrenaline = UAI_GetDynamicSkillInfo(1, $GC_UAI_DYNAMIC_SKILL_Adrenaline)
```

### 4.4 Effects Cache (UtilityAI_EffectsCache.au3)

Caches **Effects**, **Bonds**, and **Visible Effects** for all cached agents.

#### Update Function

```autoit
Func UAI_UpdateEffectsCache()
```

This updates all three caches (effects, bonds, visible effects) at once.

#### Effect Properties

```autoit
Global Enum $GC_UAI_EFFECT_SkillID, _
    $GC_UAI_EFFECT_AttributeLevel, _
    $GC_UAI_EFFECT_EffectID, _
    $GC_UAI_EFFECT_CasterID, _
    $GC_UAI_EFFECT_Duration, _
    $GC_UAI_EFFECT_Timestamp, _
    $GC_UAI_EFFECT_COUNT
```

#### Bond Properties

```autoit
Global Enum $GC_UAI_BOND_SkillID, _
    $GC_UAI_BOND_Unknown, _
    $GC_UAI_BOND_BondID, _
    $GC_UAI_BOND_TargetAgentID, _
    $GC_UAI_BOND_COUNT
```

#### Visible Effect Properties

```autoit
Global Enum $GC_UAI_VISEFFECT_EffectType, _
    $GC_UAI_VISEFFECT_EffectID, _
    $GC_UAI_VISEFFECT_HasEnded, _
    $GC_UAI_VISEFFECT_COUNT
```

#### Effect Functions

```autoit
; Check if agent has a specific effect (by SkillID)
UAI_AgentHasEffect($a_i_AgentID, $a_i_SkillID)
UAI_PlayerHasEffect($a_i_SkillID)

; Get effect info
UAI_GetAgentEffectInfo($a_i_AgentID, $a_i_SkillID, $a_i_Property)
UAI_GetPlayerEffectInfo($a_i_SkillID, $a_i_Property)

; Get effect count
UAI_GetAgentEffectCount($a_i_AgentID)
UAI_GetPlayerEffectCount()
```

#### Bond Functions

```autoit
; Check if agent upkeeps a specific bond (by SkillID)
UAI_AgentUpkeepsBond($a_i_AgentID, $a_i_SkillID)
UAI_PlayerUpkeepsBond($a_i_SkillID)

; Get bond info
UAI_GetAgentBondInfo($a_i_AgentID, $a_i_SkillID, $a_i_Property)
UAI_GetPlayerBondInfo($a_i_SkillID, $a_i_Property)

; Get bond count
UAI_GetAgentBondCount($a_i_AgentID)
UAI_GetPlayerBondCount()
```

#### Visible Effect Functions

```autoit
; Check if agent has a specific visible effect (by EffectID)
UAI_AgentHasVisibleEffect($a_i_AgentID, $a_i_EffectID)
UAI_PlayerHasVisibleEffect($a_i_EffectID)

; Get visible effect info
UAI_GetAgentVisibleEffectInfo($a_i_AgentID, $a_i_EffectID, $a_i_Property)
UAI_GetPlayerVisibleEffectInfo($a_i_EffectID, $a_i_Property)

; Get visible effect count
UAI_GetAgentVisibleEffectCount($a_i_AgentID)
UAI_GetPlayerVisibleEffectCount()
```

#### Usage Examples

```autoit
; Check if player has Healing Signet effect
If UAI_PlayerHasEffect($GC_I_SKILL_ID_HEALING_SIGNET) Then
    ; Player has Healing Signet active
EndIf

; Check if enemy has a hex
If UAI_AgentHasEffect($l_i_EnemyID, $GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then
    ; Enemy has Spiteful Spirit
EndIf

; Get duration of an effect on player
Local $l_f_Duration = UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SHADOW_FORM, $GC_UAI_EFFECT_Duration)

; Check number of effects on player
Local $l_i_EffectCount = UAI_GetPlayerEffectCount()
```

### 4.5 UAI_UpdateCache() - Unified Cache Update

The `UAI_UpdateCache()` function is a **convenience wrapper** that updates all dynamic caches in one call:

```autoit
Func UAI_UpdateCache($a_f_AggroRange)
    UAI_UpdateAgentCache($a_f_AggroRange + 100)  ; Agent data (with margin)
    UAI_CacheAgentEffects()                       ; Effects cache
    UAI_CacheAgentBonds()                         ; Bonds cache
    UAI_CacheAgentVisibleEffects()                ; Visible effects cache
    UAI_UpdateDynamicSkillbarCache()              ; Skill recharge/adrenaline
EndFunc
```

**Usage:** Call this once per combat loop iteration, before processing skills:

```autoit
Func UAI_UseSkills($a_f_x, $a_f_y, $a_f_AggroRange, $a_f_MaxDistanceToXY)
    For $i = 1 To 8
        UAI_UpdateCache($a_f_AggroRange)  ; Update all caches
        If UAI_CountAgents(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy") = 0 Then ExitLoop
        ; ... process skills ...
    Next
EndFunc
```

### 4.6 Complete Cache Update Pattern

```autoit
; At the start of each combat loop iteration (recommended):
UAI_UpdateCache($a_f_AggroRange)  ; Updates all dynamic caches at once

; Or manually update individual caches:
UAI_UpdateAgentCache()           ; Update all agent data
UAI_UpdateDynamicSkillbarCache() ; Update dynamic skill data
UAI_CacheAgentEffects()          ; Update effects
UAI_CacheAgentBonds()            ; Update bonds
UAI_CacheAgentVisibleEffects()   ; Update visible effects

; On map load or form change:
UAI_CacheSkillBar()              ; Update static skill data
```

---

## 5. BESTTARGET SYSTEM (TARGETING)

### 5.1 Operating Principle

**Each skill** has its own targeting function:

```autoit
Func BestTarget_SkillName($a_f_AggroRange)
    ; Specific targeting logic
    Return $l_i_TargetAgentID
EndFunc
```

### 5.2 Skill ID → Function Mapping

The file `Cache/UtilityAI_BestTargetCache.au3` contains a **giant switch**:

```autoit
Func UAI_GetBestTargetFunc($a_i_SkillSlot)
    Switch UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillID)
        Case $GC_I_SKILL_ID_HEALING_SIGNET
            Return "BestTarget_HealingSignet"
        Case $GC_I_SKILL_ID_RESURRECTION_SIGNET
            Return "BestTarget_ResurrectionSignet"
        ; ... 3000+ cases ...
    EndSwitch
EndFunc
```

### 5.3 Common Targeting Types

#### A. Self-target

```autoit
Func BestTarget_HealingSignet($a_f_AggroRange)
    Return Agent_GetMyID()
EndFunc
```

**Used for:**
- Personal buffs (enchantments, stances)
- Healing signets
- Forms (Ursan, etc.)

#### B. Target nearest enemy

```autoit
Func BestTarget_PowerAttack($a_f_AggroRange)
    Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
```

**Used for:**
- Melee attacks
- Basic damage spells

#### C. Target lowest HP ally

```autoit
Func BestTarget_Heal($a_f_AggroRange)
    Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
```

**Used for:**
- Healing spells
- Protective buffs

#### D. Target with specific conditions

```autoit
Func BestTarget_CureHex($a_f_AggroRange)
    Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
EndFunc
```

**Used for:**
- Condition/hex removal
- Situational skills

#### E. AOE Targeting - Best Group

```autoit
Func BestTarget_FireStorm($a_f_AggroRange)
    ; Returns the AgentID at the center of the largest enemy group
    ; Priority 1: Most enemies in AOE range
    ; Priority 2: If same count, lowest average HP wins
    Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
```

**Used for:**
- AOE damage spells
- Ward placement
- Well placement

### 5.4 Combat Modes

The SmartCast system supports two combat modes that affect target selection:

```autoit
Global $g_i_FinisherMode = 0  ; Target low HP enemies to secure kills
Global $g_i_PressureMode = 1  ; Target high HP enemies to spread damage
```

**UAI_GetBestSingleTarget()** automatically selects targets based on the active combat mode:

```autoit
Func UAI_GetBestSingleTarget($a_i_AgentID, $a_f_Range, $a_i_Property, $a_s_CustomFilter)
    ; Finisher Mode → UAI_GetAgentLowest() (finish weak enemies)
    ; Pressure Mode → UAI_GetAgentHighest() (spread damage on strong enemies)
EndFunc
```

**Usage example:**

```autoit
Func BestTarget_Necrosis($a_f_AggroRange)
    ; Target conditioned or hexed enemy based on combat mode
    Local $l_i_Conditioned = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
    Local $l_i_Hexed = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
    If $l_i_Conditioned <> 0 Then Return $l_i_Conditioned
    If $l_i_Hexed <> 0 Then Return $l_i_Hexed
    Return 0
EndFunc
```

**Note:** If no target matches the filters, `UAI_GetBestSingleTarget()` returns 0. You can implement fallback logic in your `BestTarget_` function.

### 5.5 Targeting Utility Functions

The file `Targeting/UtilityAI_GetAgent.au3` provides these helpers:

```autoit
; Basic targeting
UAI_GetNearestAgent($a_i_BaseAgentID, $a_f_Range, $a_s_FilterFunc)
UAI_GetFarthestAgent($a_i_BaseAgentID, $a_f_Range, $a_s_FilterFunc)

; Property-based targeting (using UAI cache)
UAI_GetAgentLowest($a_i_BaseAgentID, $a_f_Range, $a_i_Property, $a_s_FilterFunc)
UAI_GetAgentHighest($a_i_BaseAgentID, $a_f_Range, $a_i_Property, $a_s_FilterFunc)

; Combat mode-aware targeting (recommended for damage skills)
UAI_GetBestSingleTarget($a_i_AgentID, $a_f_Range, $a_i_Property, $a_s_CustomFilter)

; AOE targeting (prioritizes count, then average HP based on combat mode)
UAI_GetBestAOETarget($a_i_AgentID, $a_f_Range, $a_f_AOERange, $a_s_CustomFilter)

; Counting
UAI_CountAgents($a_i_BaseAgentID, $a_f_Range, $a_s_FilterFunc)

; Find agent by player number
UAI_FindAgentByPlayerNumber($a_i_PlayerNumber, $a_f_Range, $a_s_FilterFunc)
```

---

## 6. CANUSE SYSTEM (CONDITIONS)

### 6.1 Operating Principle

**Each skill** has its own condition function:

```autoit
Func CanUse_SkillName()
    ; Specific checks
    If [condition] Then Return False
    Return True
EndFunc
```

### 6.2 Skill ID → Function Mapping

Similar to BestTarget:

```autoit
Func UAI_GetCanUseFunc($a_i_SkillSlot)
    Switch UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillID)
        Case $GC_I_SKILL_ID_HEALING_SIGNET
            Return "CanUse_HealingSignet"
        ; ... 3000+ cases ...
    EndSwitch
EndFunc
```

### 6.3 Condition Examples (Using UAI Cache)

#### A. Simple condition (HP threshold)

```autoit
Func CanUse_HealingSignet()
    ; Don't use if Ignorance is active
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE) Then
        Return False
    EndIf

    ; Only if HP < 80%
    If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.80 Then
        Return False
    EndIf

    Return True
EndFunc
```

#### B. Resurrection condition

```autoit
Func CanUse_ResurrectionSignet()
    ; Don't rez if Curse of Dhuum or Frozen Soil
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Then
        Return False
    EndIf
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then
        Return False
    EndIf

    Return True
EndFunc
```

#### C. Interrupt condition

```autoit
Func CanUse_PowerBlock()
    ; Don't use if Guilt or Diversion
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) Then
        Return False
    EndIf
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then
        Return False
    EndIf

    ; Only if target is casting
    If Not UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_IsCasting) Then
        Return False
    EndIf

    Return True
EndFunc
```

#### D. Complex condition with target state

```autoit
Func CanUse_ComplexSkill()
    ; Check player has required effect
    If Not UAI_PlayerHasEffect($GC_I_SKILL_ID_RequiredEffect) Then
        Return False
    EndIf

    ; Check target HP
    If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) > 0.5 Then
        Return False
    EndIf

    Return True
EndFunc
```

---

## 7. RESOURCE MANAGEMENT SYSTEM

### 7.1 UAI_CanCast() - Resource Verification

This function is called **before** `CanUse_` to check if the player has the necessary resources.

```autoit
Func UAI_CanCast($a_i_SkillSlot)
```

**Checks performed:**

#### A. Recharge (Using UAI Dynamic Cache)

```autoit
If Not UAI_GetDynamicSkillInfo($a_i_SkillSlot, $GC_UAI_DYNAMIC_SKILL_IsRecharged) Then
    Return False
EndIf
```

#### B. Adrenaline (Using UAI Caches)

```autoit
Local $l_i_RequiredAdrenaline = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Adrenaline)
If $l_i_RequiredAdrenaline <> 0 Then
    Local $l_i_CurrentAdrenaline = UAI_GetDynamicSkillInfo($a_i_SkillSlot, $GC_UAI_DYNAMIC_SKILL_Adrenaline)
    If $l_i_CurrentAdrenaline < $l_i_RequiredAdrenaline Then
        Return False
    EndIf
EndIf
```

#### C. Health Cost (Sacrifice + Masochism)

```autoit
Local $l_i_HealthCost = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_HealthCost)
If $l_i_HealthCost <> 0 Then
    Local $l_i_MaxHP = UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP)
    Local $l_f_TotalCost = $l_i_MaxHP * $l_i_HealthCost / 100

    ; Modifiers
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_Awaken_the_Blood) Then
        $l_f_TotalCost = $l_f_TotalCost * 1.5 ; +50%
    EndIf
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_Scourge_Sacrifice) Then
        $l_f_TotalCost = $l_f_TotalCost * 2 ; Double
    EndIf

    If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) <= $l_f_TotalCost Then
        Return False
    EndIf
EndIf
```

#### D. Overcast

```autoit
Local $l_i_OvercastCost = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_Overcast)
If $l_i_OvercastCost <> 0 Then
    Local $l_i_CurrentOvercast = UAI_GetPlayerInfo($GC_UAI_AGENT_Overcast)
    Local $l_i_MaxEnergy = UAI_GetPlayerInfo($GC_UAI_AGENT_MaxEnergy)

    ; Don't exceed 50% of max energy in overcast
    If ($l_i_CurrentOvercast + $l_i_OvercastCost) >= ($l_i_MaxEnergy * 0.5) Then
        Return False
    EndIf
EndIf
```

#### E. Energy Cost

```autoit
Local $l_i_EnergyCost = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_EnergyCost)

; Apply modifiers (Quickening Zephyr, Nature's Renewal, etc.)
; Apply reductions (Glyph of Lesser Energy, etc.)

If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) < $l_i_EnergyCost Then
    Return False
EndIf
```

### 7.2 UAI_CanAutoAttack() - Auto-attack Management

```autoit
Func UAI_CanAutoAttack()
    ; Don't attack if Blind
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_Blind) Then Return False

    ; Check for dangerous hexes using effects cache
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_Ineptitude) Then Return False
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_Clumsiness) Then Return False
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_Empathy) Then Return False
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spiteful_Spirit) Then Return False

    ; If HP < 200 and has any dangerous hex, don't attack
    If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) < 200 Then
        If UAI_GetPlayerEffectCount() > 0 Then
            ; Check for any dangerous effect
            Return False
        EndIf
    EndIf

    Return True
EndFunc
```

---

## 8. FILTERS AND UTILITIES

### 8.1 Agent Filters (Targeting/UtilityAI_AgentFilter.au3)

#### Basic Filters

```autoit
UAI_Filter_IsLivingEnemy($a_i_AgentID)        ; Living enemy
UAI_Filter_IsDeadEnemy($a_i_AgentID)          ; Dead enemy
UAI_Filter_IsLivingAlly($a_i_AgentID)         ; Living ally
UAI_Filter_IsDeadAlly($a_i_AgentID)           ; Dead ally
UAI_Filter_ExcludeMe($a_i_AgentID)            ; Exclude self
```

#### Condition Filters (Using UAI Cache)

```autoit
UAI_Filter_IsDiseased($a_i_AgentID)           ; Has Disease
UAI_Filter_IsPoisoned($a_i_AgentID)           ; Has Poison
UAI_Filter_IsBlind($a_i_AgentID)              ; Has Blind
UAI_Filter_IsBurning($a_i_AgentID)            ; Has Burning
UAI_Filter_IsBleeding($a_i_AgentID)           ; Has Bleeding
UAI_Filter_IsCrippled($a_i_AgentID)           ; Has Crippled
UAI_Filter_IsDeepWounded($a_i_AgentID)        ; Has Deep Wound
UAI_Filter_IsDazed($a_i_AgentID)              ; Has Dazed
UAI_Filter_IsWeakness($a_i_AgentID)           ; Has Weakness
```

#### State Filters (Using UAI Cache)

```autoit
UAI_Filter_IsEnchanted($a_i_AgentID)          ; Has enchantments
UAI_Filter_IsConditioned($a_i_AgentID)        ; Has conditions
UAI_Filter_IsHexed($a_i_AgentID)              ; Has hexes
UAI_Filter_IsDegenHexed($a_i_AgentID)         ; Has degen hexes
UAI_Filter_IsWeaponSpelled($a_i_AgentID)      ; Has weapon spell
UAI_Filter_IsKnocked($a_i_AgentID)            ; Is knocked down
UAI_Filter_IsMoving($a_i_AgentID)             ; Is moving
UAI_Filter_IsAttacking($a_i_AgentID)          ; Is attacking
UAI_Filter_IsCasting($a_i_AgentID)            ; Is casting
UAI_Filter_IsIdle($a_i_AgentID)               ; Is idle
```

#### Advanced Filters

```autoit
UAI_Filter_IsSpirit($a_i_AgentID)             ; Is a spirit
UAI_Filter_IsControlledSpirit($a_i_AgentID)   ; Is a player-controlled spirit
UAI_Filter_IsMinion($a_i_AgentID)             ; Is a minion
UAI_Filter_IsControlledMinion($a_i_AgentID)   ; Is a player-controlled minion
UAI_Filter_IsBelow50HP($a_i_AgentID)          ; HP < 50%
```

### 8.2 Utility Functions (Core/UtilityAI_Utils.au3)

#### Skill Management

```autoit
Skill_GetSlotByID($a_i_SkillID)           ; Return slot of a skill by ID
Skill_CheckSlotByID($a_i_SkillID)         ; Check if a skill is in the bar
```

#### Party Management

```autoit
Party_GetSize()                           ; Party size
Party_GetHeroCount()                      ; Number of heroes
Party_GetHeroID($a_i_HeroNumber)          ; ID of specific hero
Party_GetMembersArray()                   ; Array of all members
Party_GetAverageHealth()                  ; Party HP average
Party_IsWiped()                           ; Is party wiped?
```

#### Effect Management (Using UAI Cache)

```autoit
; Player effects
UAI_PlayerHasEffect($a_i_SkillID)
UAI_GetPlayerEffectInfo($a_i_SkillID, $a_i_Property)
UAI_GetPlayerEffectCount()

; Agent effects
UAI_AgentHasEffect($a_i_AgentID, $a_i_SkillID)
UAI_GetAgentEffectInfo($a_i_AgentID, $a_i_SkillID, $a_i_Property)
UAI_GetAgentEffectCount($a_i_AgentID)

; Player bonds
UAI_PlayerUpkeepsBond($a_i_SkillID)
UAI_GetPlayerBondCount()

; Agent bonds
UAI_AgentUpkeepsBond($a_i_AgentID, $a_i_SkillID)
UAI_GetAgentBondCount($a_i_AgentID)
```

---

## 9. ADVANCED CUSTOMIZATION

### 9.1 Modify Skill Targeting

**Example: Modify Healing Signet to only use at 50% HP**

1. **Find the function in Skills/UtilityAI_Signet.au3:**

```autoit
Func BestTarget_HealingSignet($a_f_AggroRange)
    Return Agent_GetMyID()
EndFunc
```

2. **No modification needed** (self-target is correct)

3. **Modify the condition in Skills/UtilityAI_Signet.au3:**

```autoit
Func CanUse_HealingSignet()
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE) Then
        Return False
    EndIf

    ; MODIFICATION: Use at 50% instead of 80%
    If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.50 Then
        Return False
    EndIf

    Return True
EndFunc
```

### 9.2 Create Intelligent Targeting for a Skill

**Example: Aegis targeted on the most threatened ally**

```autoit
Func BestTarget_Aegis($a_f_AggroRange)
    Local $l_i_BestTarget = 0
    Local $l_i_BestPriority = -9999

    ; Iterate through cached agents
    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = $g_a2D_AgentCache[$i][$GC_UAI_AGENT_ID]

        ; Apply filters
        If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop

        ; Ignore if already has Aegis
        If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_AEGIS) Then ContinueLoop

        ; Check distance
        Local $l_f_Distance = _GetDistanceToAgent($l_i_AgentID)
        If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

        ; Priority calculation
        Local $l_i_Priority = 0

        ; Lower HP = higher priority
        Local $l_f_HPPercent = $g_a2D_AgentCache[$i][$GC_UAI_AGENT_HP]
        $l_i_Priority += (1 - $l_f_HPPercent) * 100

        ; Bonus if ally is being attacked
        If $g_a2D_AgentCache[$i][$GC_UAI_AGENT_IsAttacking] Then
            $l_i_Priority += 50
        EndIf

        ; Update best target
        If $l_i_Priority > $l_i_BestPriority Then
            $l_i_BestPriority = $l_i_Priority
            $l_i_BestTarget = $l_i_AgentID
        EndIf
    Next

    Return $l_i_BestTarget
EndFunc
```

### 9.3 Create a Complex Condition

**Example: Only use Shadow Form in critical situations**

```autoit
Func CanUse_ShadowForm()
    ; Don't use if already active
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHADOW_FORM) Then
        Return False
    EndIf

    ; Danger counter
    Local $l_i_DangerLevel = 0

    ; Low HP = danger
    Local $l_f_HP = UAI_GetPlayerInfo($GC_UAI_AGENT_HP)
    If $l_f_HP < 0.5 Then $l_i_DangerLevel += 2
    If $l_f_HP < 0.3 Then $l_i_DangerLevel += 3

    ; Nearby enemies = danger
    Local $l_i_EnemyCount = UAI_CountAgents(-2, 500, "UAI_Filter_IsLivingEnemy")
    $l_i_DangerLevel += $l_i_EnemyCount

    ; Dangerous hexes
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_PRICE_OF_FAILURE) Then $l_i_DangerLevel += 3
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_DangerLevel += 3

    ; Danger threshold: only use if danger >= 5
    If $l_i_DangerLevel >= 5 Then
        Return True
    EndIf

    Return False
EndFunc
```

### 9.4 Add Priority Skills

In `Core/UtilityAI_Core.au3`, function `UAI_PrioritySkills()`:

```autoit
Func UAI_PrioritySkills()
    ; Default priority skills
    Local $l_ai_PrioritySkills[] = [
        $GC_I_SKILL_ID_ASSASSINS_PROMISE,
        $GC_I_SKILL_ID_EREMITES_ZEAL,
        $GC_I_SKILL_ID_PANIC,
        $GC_I_SKILL_ID_INFUSE_HEALTH,
        $GC_I_SKILL_ID_SEED_OF_LIFE,
        $GC_I_SKILL_ID_HEALING_BURST,
        $GC_I_SKILL_ID_PATIENT_SPIRIT,
        $GC_I_SKILL_ID_LIFE_SHEATH,
        $GC_I_SKILL_ID_RESTORE_CONDITION,
        $GC_I_SKILL_ID_PEACE_AND_HARMONY,

        ; CUSTOM ADDITIONS
        $GC_I_SKILL_ID_SHADOW_FORM,        ; Emergency escape
        $GC_I_SKILL_ID_DEATHS_CHARGE,      ; Emergency teleport
        $GC_I_SKILL_ID_GLYPH_OF_SWIFTNESS  ; Important for E-burst
    ]

    For $l_i_SkillID In $l_ai_PrioritySkills
        Local $l_i_Slot = Skill_GetSlotByID($l_i_SkillID)
        If $l_i_Slot > 0 Then
            _TryCastPrioritySkill($l_i_Slot)
        EndIf
    Next
EndFunc
```

---

## 10. PRACTICAL EXAMPLES

### 10.1 Monk Spike Build

**Objective:** Prioritize healing on critical allies

```autoit
; === WORD OF HEALING ===
Func BestTarget_WordOfHealing($a_f_AggroRange)
    ; Priority 1: Ally < 30% HP
    Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_HPBelow30")
    If $l_i_Target <> 0 Then Return $l_i_Target

    ; Priority 2: Self if < 50%
    If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) < 0.50 Then
        Return Agent_GetMyID()
    EndIf

    ; Priority 3: Lowest ally
    Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc

Func CanUse_WordOfHealing()
    ; Don't use if target > 80% HP
    If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) > 0.80 Then
        Return False
    EndIf

    ; Don't use if under Guilt/Shame
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) Or
       UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) Then
        Return False
    EndIf

    Return True
EndFunc
```

### 10.2 Discord Necro Build

**Objective:** Optimize cast order to maximize Discord damage

```autoit
; === DISCORD ===
Func BestTarget_Discord($a_f_AggroRange)
    ; Target enemy with MOST conditions (for max damage)
    Local $l_i_BestTarget = 0
    Local $l_i_MaxConditions = 0

    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = $g_a2D_AgentCache[$i][$GC_UAI_AGENT_ID]
        If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop

        Local $l_f_Distance = _GetDistanceToAgent($l_i_AgentID)
        If $l_f_Distance > $a_f_AggroRange Then ContinueLoop

        ; Count conditions
        Local $l_i_CondCount = 0
        If UAI_Filter_IsPoisoned($l_i_AgentID) Then $l_i_CondCount += 1
        If UAI_Filter_IsDiseased($l_i_AgentID) Then $l_i_CondCount += 1
        If UAI_Filter_IsBleeding($l_i_AgentID) Then $l_i_CondCount += 1
        If UAI_Filter_IsWeakness($l_i_AgentID) Then $l_i_CondCount += 1
        If UAI_Filter_IsCrippled($l_i_AgentID) Then $l_i_CondCount += 1

        If $l_i_CondCount > $l_i_MaxConditions Then
            $l_i_MaxConditions = $l_i_CondCount
            $l_i_BestTarget = $l_i_AgentID
        EndIf
    Next

    ; Fallback: nearest enemy
    If $l_i_BestTarget = 0 Then
        $l_i_BestTarget = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
    EndIf

    Return $l_i_BestTarget
EndFunc

Func CanUse_Discord()
    ; Only cast if target has AT LEAST 2 conditions
    Local $l_i_CondCount = 0
    If UAI_Filter_IsPoisoned($g_i_BestTarget) Then $l_i_CondCount += 1
    If UAI_Filter_IsDiseased($g_i_BestTarget) Then $l_i_CondCount += 1
    If UAI_Filter_IsBleeding($g_i_BestTarget) Then $l_i_CondCount += 1
    If UAI_Filter_IsWeakness($g_i_BestTarget) Then $l_i_CondCount += 1
    If UAI_Filter_IsCrippled($g_i_BestTarget) Then $l_i_CondCount += 1

    If $l_i_CondCount < 2 Then Return False

    Return True
EndFunc
```

### 10.3 AOE Build with Best Target Selection

**Objective:** Maximize AOE damage by targeting the best group

```autoit
; === FIRE STORM ===
Func BestTarget_FireStorm($a_f_AggroRange)
    ; Get the center of the largest enemy group
    ; Priority: Most enemies, then lowest average HP
    Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc

Func CanUse_FireStorm()
    ; Only cast if at least 3 enemies in AOE range
    Local $l_i_BestTarget = UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
    If $l_i_BestTarget = 0 Then Return False

    ; Count enemies around best target
    Local $l_i_Count = UAI_CountAgents($l_i_BestTarget, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
    If $l_i_Count < 3 Then Return False

    Return True
EndFunc
```

---

## 11. OPTIMIZATION AND BEST PRACTICES

### 11.1 Performance

#### A. Use UAI cache instead of direct memory reads

```autoit
; BAD: Direct memory read each time
Func CanUse_Skill()
    If Agent_GetAgentInfo(-2, "HPPercent") > 0.80 Then Return False
    If Agent_HasEffect($GC_I_SKILL_ID_IGNORANCE, -2) Then Return False
    Return True
EndFunc

; GOOD: Use UAI cache
Func CanUse_Skill()
    If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.80 Then Return False
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE) Then Return False
    Return True
EndFunc
```

#### B. Iterate through cached agents instead of all agents

```autoit
; BAD: Loop on all possible agents
Func BestTarget_Skill($a_f_AggroRange)
    For $i = 1 To GetMaxAgents()
        Local $l_i_AgentID = Agent_GetAgentByArrayIndex($i)
        ; ...
    Next
EndFunc

; GOOD: Loop only through cached agents
Func BestTarget_Skill($a_f_AggroRange)
    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = $g_a2D_AgentCache[$i][$GC_UAI_AGENT_ID]
        ; ...
    Next
EndFunc
```

#### C. Return early

```autoit
; BAD: Checks everything even if already invalid
Func CanUse_Skill()
    Local $l_b_Valid = True

    If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.80 Then $l_b_Valid = False
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE) Then $l_b_Valid = False
    If $g_i_BestTarget = 0 Then $l_b_Valid = False

    Return $l_b_Valid
EndFunc

; GOOD: Return as soon as invalid
Func CanUse_Skill()
    If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.80 Then Return False
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE) Then Return False
    If $g_i_BestTarget = 0 Then Return False

    Return True
EndFunc
```

### 11.2 Maintainability

#### A. Comment complex logic

```autoit
Func CanUse_ComplexSkill()
    ; Check safety conditions
    ; Don't cast if under Guilt (increases recharge by 10s)
    If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) Then Return False

    ; Calculate surrounding danger
    ; Formula: nb_enemies * 10 + (1 - HP%) * 50
    Local $l_i_Danger = UAI_CountAgents(-2, 500, "UAI_Filter_IsLivingEnemy") * 10
    $l_i_Danger += (1 - UAI_GetPlayerInfo($GC_UAI_AGENT_HP)) * 50

    ; Danger threshold: 30
    ; Below this, the skill is not necessary
    If $l_i_Danger < 30 Then Return False

    Return True
EndFunc
```

#### B. Name variables clearly

```autoit
; BAD
Func BestTarget_Skill($a_f_AggroRange)
    Local $a = 0
    Local $b = -9999
    For $i = 1 To $x
        Local $c = $y[$i]
        ; ...
    Next
EndFunc

; GOOD
Func BestTarget_Skill($a_f_AggroRange)
    Local $l_i_BestTarget = 0
    Local $l_i_BestPriority = -9999

    For $i = 1 To $g_i_AgentCacheCount
        Local $l_i_AgentID = $g_a2D_AgentCache[$i][$GC_UAI_AGENT_ID]
        ; ...
    Next
EndFunc
```

### 11.3 Debugging

#### A. Use Out() for logging

```autoit
Func BestTarget_Skill($a_f_AggroRange)
    Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")

    ; Debug log
    Out("BestTarget_Skill : Target = " & $l_i_Target &
        " (HP: " & UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) & ")")

    Return $l_i_Target
EndFunc
```

#### B. Test conditions individually

```autoit
Func CanUse_Skill()
    ; Test each condition and log
    If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.80 Then
        Out("CanUse_Skill : FAILED - HP too high (" &
            UAI_GetPlayerInfo($GC_UAI_AGENT_HP) & ")")
        Return False
    EndIf

    If UAI_PlayerHasEffect($GC_I_SKILL_ID_IGNORANCE) Then
        Out("CanUse_Skill : FAILED - Under Ignorance")
        Return False
    EndIf

    Out("CanUse_Skill : SUCCESS")
    Return True
EndFunc
```

---

## CONCLUSION

The **SmartCast** system is a flexible and powerful framework for automating Guild Wars gameplay.

### Key Takeaways:

1. **Modular architecture**: Each skill has its own targeting and condition functions
2. **UAI Cache System**: Centralized caching for optimal performance
   - `UAI_UpdateAgentCache()` - Agent data
   - `UAI_CacheSkillBar()` - Static skill data
   - `UAI_UpdateDynamicSkillbarCache()` - Dynamic skill data
   - `UAI_UpdateEffectsCache()` - Effects, Bonds, Visible Effects
3. **Resource management**: Sophisticated system that accounts for all modifiers
4. **Extensibility**: Easy to add/modify behaviors for each skill
5. **Separation of concerns**: BestTarget (WHO), CanUse (WHEN), CanCast (CAN-WE)

### UAI Cache Quick Reference:

| Cache | Update Function | Access Functions |
|-------|----------------|------------------|
| Agent | `UAI_UpdateAgentCache()` | `UAI_GetPlayerInfo()`, `UAI_GetAgentInfoByID()` |
| Static Skill | `UAI_CacheSkillBar()` | `UAI_GetStaticSkillInfo()` |
| Dynamic Skill | `UAI_UpdateDynamicSkillbarCache()` | `UAI_GetDynamicSkillInfo()` |
| Effects | `UAI_UpdateEffectsCache()` | `UAI_PlayerHasEffect()`, `UAI_AgentHasEffect()` |
| Bonds | (via Effects) | `UAI_PlayerUpkeepsBond()`, `UAI_AgentUpkeepsBond()` |
| Visible Effects | (via Effects) | `UAI_PlayerHasVisibleEffect()`, `UAI_AgentHasVisibleEffect()` |

### Going Further:

- Study existing functions in `Cache/UtilityAI_BestTargetCache.au3` and `Skills/*.au3`
- Analyze complex conditions in `Cache/UtilityAI_CanUseCache.au3` and `Skills/*.au3`
- Create your own custom filters in `Targeting/UtilityAI_AgentFilter.au3`
- Optimize skill priorities according to your build
- Use the UAI cache system for maximum performance

**The system is designed to be modified and customized according to your specific needs!**

---

*Documentation created by Greg-76 (Alusion)*
*Version 2.0 - Updated with UAI Cache System*
*For questions or improvements: [GitHub](https://github.com/JAG-GW/GwAu3)*
