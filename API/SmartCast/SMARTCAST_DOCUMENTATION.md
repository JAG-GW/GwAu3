# COMPLETE SMARTCAST SYSTEM DOCUMENTATION
## Technical and Customization Guide

*Created by Greg-76 (Alusion)*
*Complete Documentation - Version 1.0*

---

## TABLE OF CONTENTS

1. [Overview](#1-overview)
2. [System Architecture](#2-system-architecture)
3. [Execution Flow](#3-execution-flow)
4. [Cache System](#4-cache-system)
5. [BestTarget System (Targeting)](#5-besttarget-system-targeting)
6. [CanUse System (Conditions)](#6-canuse-system-conditions)
7. [Resource Management System](#7-resource-management-system)
8. [Filters and Utilities](#8-filters-and-utilities)
9. [Advanced Customization](#9-advanced-customization)
10. [Practical Examples](#10-practical-examples)
11. [Optimization and Best Practices](#11-optimization-and-best-practices)

---

## 1. OVERVIEW

### What is SmartCast?

**SmartCast** is an intelligent combat automation system for Guild Wars. It automatically manages:
- ✅ Optimal targeting for each skill
- ✅ Skill usage conditions
- ✅ Resource management (energy, adrenaline, health)
- ✅ Combos and skill chains
- ✅ Form changes (Ursan, Raven, Volfen)
- ✅ Intelligent auto-attacks
- ✅ Weapon set switching

### Weapon Set Switching

The SmartCast system integrates an **automatic weapon set switching** feature currently under implementation. This feature will allow:

- **Automatic weapon switching** based on the skill being used
- **Weapon set adaptation** according to skill modifiers (attribute, profession, type)
- **Build optimization** by allowing the use of skills requiring different weapons in the same skill bar

**Usage examples:**
- A hybrid build could use a 40/40 for spells and automatically switch to a +20% enchantment bonus for enchantments.
- An assassin could alternate between daggers for attacks and a hammer depending on the skills.
- A monk low energy for using he's skill can switch to a set who give him more energy. (Same for HP)

This functionality is managed by the `SmartCast_WeaponSets.au3` module and integrates seamlessly into the system's execution flow.

### System Philosophy

SmartCast works on a principle of **separation of concerns**:
- **Each skill** has its own targeting function (`BestTarget_`)
- **Each skill** has its own condition function (`CanUse_`)
- The system **caches** information to optimize performance

---

## 2. SYSTEM ARCHITECTURE

### File Structure

```
API/SmartCast/
│
├── _SmartCast.au3              # Main entry point (includes all modules)
├── SmartCast_Core.au3          # System core (combat loop)
├── SmartCast_BestTarget.au3    # Targeting functions
├── SmartCast_CanUse.au3        # Usage conditions
├── SmartCast_Cache.au3         # Skill cache system
├── SmartCast_Const.au3         # Constants and global variables
├── SmartCast_Agent.au3         # Agent filters and queries
├── SmartCast_Utils.au3         # Utility functions
└── SmartCast_WeaponSets.au3    # Weapon set management
```

### Main Global Variables

```autoit
Global $BestTarget = 0                    ; Current best target ID
Global $LastCalledTarget = 0              ; Last called target
Global $SkillBarCache[9][44]              ; Cache of all skill info
Global $BestTargetCache[9]                ; BestTarget function cache
Global $CanUseCache[9]                    ; CanUse function cache
Global $CanUseSkill = True                ; Flag if skill can be used
Global $SkillChanged = False              ; Flag for form changes
```

### Skill Properties Enum

```autoit
Global Enum $all = 0, $SkillID, $Campaign, $SkillType, $Special, $ComboReq,
        $Effect1, $RequireCondition, $Effect2, $WeaponReq, $Profession,
        $Attribute, $Title, $SkillIDPvP, $Combo, $Target, $SkillEquipType,
        $Overcast, $EnergyCost, $HealthCost, $Adrenaline, $Activation,
        $Aftercast, $Duration0, $Duration15, $Recharge, $SkillArguments,
        $Scale0, $Scale15, $BonusScale0, $BonusScale15, $EffectConstant1,
        $EffectConstant2, [... animations, icons, descriptions ...]
```

---

## 3. EXECUTION FLOW

### 3.1 Fight() Function - Main Entry Point

```autoit
Func Fight($x, $y, $aAggroRange = 1320, $aMaxDistanceToXY = 3500)
```

**Parameters:**
- `$x, $y` : Reference coordinates for combat
- `$aAggroRange` : Maximum aggro distance (default: 1320)
- `$aMaxDistanceToXY` : Max distance before leaving combat (default: 3500)

**Operation:**
1. Loop until:
   - All enemies are dead
   - Player is dead
   - Party is wiped
   - Map/instance change
2. Calls `UseSkills()` each iteration
3. 32ms sleep between each iteration

### 3.2 UseSkills() Function - Main Loop

```autoit
Func UseSkills($x, $y, $aAggroRange = 1320, $aMaxDistanceToXY = 3500)
```

**Execution sequence (for each skill slot 1-8):**

```
┌─────────────────────────────────────┐
│ 1. Safety checks                   │
│    - Player dead?                  │
│    - Party wiped?                  │
│    - Out of combat?                │
│    - Knocked down?                 │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 2. Form change?                    │
│    - Ursan/Raven/Volfen?           │
│    - Re-cache skillbar             │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 3. Priority skills                 │
│    - Assassin's Promise            │
│    - Infuse Health                 │
│    - Panic                         │
│    - etc...                        │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 4. Drop bundle (in progress)       │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 5. Intelligent auto-attack         │
│    - Check CanAutoAttack()         │
│    - Attack if allowed             │
│    - Cancel if forbidden           │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 6. Cast skill                      │
│    ├─ SmartCast_CanCast($i)       │
│    │   └─ Check recharge,          │
│    │      adrenaline, resources    │
│    │                               │
│    ├─ BestTarget = Call($BestTargetCache[$i])
│    │   └─ Call the function        │
│    │      BestTarget_XXX()         │
│    │                               │
│    ├─ CanUseSkill = Call($CanUseCache[$i])
│    │   └─ Call the function        │
│    │      CanUse_XXX()             │
│    │                               │
│    └─ SmartCast_UseSkillEX($i, $BestTarget)
│        └─ Cast the skill           │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│ 7. Distance check                  │
│    - Too far from $x,$y?           │
│    - Exit if > $aMaxDistanceToXY   │
└─────────────────────────────────────┘
```

### 3.3 SmartCast_UseSkillEX() Function - Cast a Skill

```autoit
Func SmartCast_UseSkillEX($aSkillSlot, $aAgentID = -2)
```

**Sequence:**
1. **Change target** if necessary
2. **Use skill** via `Skill_UseSkill($aSkillSlot, $aAgentID)`
3. **Intelligent waiting** based on type:
   - **Melee/Touch/Attack** : Wait until target is at 240 range
   - **Long range spell** : Wait until target is at 1320 range
4. **Wait for cast end** : Until:
   - Player dead
   - Target out of range (>1320)
   - Instance change
   - No longer casting

---

## 4. CACHE SYSTEM

### 4.1 Cache_SkillBar() - Skill Bar Caching

**Objective:** Optimize performance by avoiding reading memory every frame

```autoit
Func Cache_SkillBar()
```

**Process:**
1. **Reset** cache: `$SkillBarCache = 0`
2. **For each slot 1-8:**
   - Read **44 properties** of the skill from memory
   - Store in `$SkillBarCache[$i][$property]`
3. **Cache functions:**
   - `$BestTargetCache[$i]` = name of function `BestTarget_XXX`
   - `$CanUseCache[$i]` = name of function `CanUse_XXX`
4. **Debug output:** Display info for each skill

**Cached properties (44 total):**
- Skill ID, campaign, type, attribute, profession
- Costs (energy, health, adrenaline, overcast)
- Timings (activation, aftercast, recharge)
- Durations, scaling, effect constants
- Animations, icons, descriptions

### 4.2 Form Changes

**Form Change Detection:**

```autoit
Func Cache_FormChangeBuild($aSkillSlot)
    Switch $SkillBarCache[$aSkillSlot][$SkillID]
        Case $GC_I_SKILL_ID_URSAN_BLESSING,
             $GC_I_SKILL_ID_VOLFEN_BLESSING,
             $GC_I_SKILL_ID_RAVEN_BLESSING
            Cache_SkillBar()  ; Re-cache the bar
            Return True
    EndSwitch
    Return False
EndFunc
```

**End Form Detection:**
- Detects form end (normal skills reappear)
- Automatically re-caches skillbar

---

## 5. BESTTARGET SYSTEM (TARGETING)

### 5.1 Operating Principle

**Each skill** has its own targeting function:

```autoit
Func BestTarget_SkillName($aAggroRange)
    ; Specific targeting logic
    Return $TargetAgentID
EndFunc
```

### 5.2 Skill ID → Function Mapping

The file `SmartCast_BestTarget.au3` contains a **giant switch**:

```autoit
Func SmartCast_BestTarget($aSkillSlot)
    Switch $SkillBarCache[$aSkillSlot][$SkillID]
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
Func BestTarget_HealingSignet($aAggroRange)
    Return Agent_GetMyID()
EndFunc
```

**Used for:**
- Personal buffs (enchantments, stances)
- Healing signets
- Forms (Ursan, etc.)

#### B. Target nearest enemy

```autoit
Func BestTarget_PowerAttack($aAggroRange)
    Return Nearest_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy")
EndFunc
```

**Used for:**
- Melee attacks
- Basic damage spells

#### C. Target lowest HP ally

```autoit
Func BestTarget_Heal($aAggroRange)
    Return Lowest_HP_Agent(-2, $aAggroRange, "Filter_IsLivingAlly|Filter_ExcludeMe")
EndFunc
```

**Used for:**
- Healing spells
- Protective buffs

#### D. Target specific conditions

```autoit
Func BestTarget_CureHex($aAggroRange)
    Return Nearest_Agent_Conditional(-2, $aAggroRange, "Filter_IsLivingAlly|Filter_IsHexed")
EndFunc
```

**Used for:**
- Condition/hex removal
- Situational skills

#### E. Target corpse

```autoit
Func BestTarget_AnimateBoneMinions($aAggroRange)
    Return Nearest_Corpse(-2, $aAggroRange)
EndFunc
```

**Used for:**
- Necro skills (minions, wells)
- Resurrections

#### F. Complex targeting

```autoit
Func BestTarget_GripOfDeathlight($aAggroRange)
    Local $lBestTarget = 0
    Local $lBestPriority = -1

    ; Search all enemies in range
    For $i = 1 To GetMaxAgents()
        Local $lAgentID = Agent_GetAgentByArrayIndex($i)
        If Not Filter_IsLivingEnemy($lAgentID) Then ContinueLoop
        If Agent_GetDistance($lAgentID) > $aAggroRange Then ContinueLoop

        ; Priority calculation
        Local $lPriority = 0
        If Agent_HasEffect($GC_I_SKILL_ID_SomeHex, $lAgentID) Then $lPriority += 10
        If Agent_GetAgentInfo($lAgentID, "HPPercent") < 0.5 Then $lPriority += 5

        If $lPriority > $lBestPriority Then
            $lBestPriority = $lPriority
            $lBestTarget = $lAgentID
        EndIf
    Next

    Return $lBestTarget
EndFunc
```

### 5.4 Targeting Utility Functions

The file `SmartCast_Agent.au3` provides these helpers:

```autoit
; Basic targeting
Nearest_Agent($aBaseAgentID, $aRange, $aFilterFunc)
Farthest_Agent($aBaseAgentID, $aRange, $aFilterFunc)

; Property-based targeting
GetAgentsLowest($aBaseAgentID, $aRange, $aProperty, $aFilterFunc)
GetAgentsHighest($aBaseAgentID, $aRange, $aProperty, $aFilterFunc)

; Counting
Count_NumberOf($aBaseAgentID, $aRange, $aFilterFunc)
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
Func SmartCast_CanUse($aSkillSlot)
    Switch $SkillBarCache[$aSkillSlot][$SkillID]
        Case $GC_I_SKILL_ID_HEALING_SIGNET
            Return "CanUse_HealingSignet"
        ; ... 3000+ cases ...
    EndSwitch
EndFunc
```

### 6.3 Condition Examples

#### A. Simple condition (HP threshold)

```autoit
Func CanUse_HealingSignet()
    ; Don't use if Ignorance is active
    If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_IGNORANCE, "HasEffect") Then
        Return False
    EndIf

    ; Only if HP < 80%
    If Agent_GetAgentInfo(-2, "HPPercent") > 0.80 Then
        Return False
    EndIf

    Return True
EndFunc
```

#### B. Resurrection condition

```autoit
Func CanUse_ResurrectionSignet()
    ; Don't rez if Curse of Dhuum or Frozen Soil
    If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_CURSE_OF_DHUUM, "HasEffect") Then
        Return False
    EndIf
    If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_FROZEN_SOIL, "HasEffect") Then
        Return False
    EndIf

    Return True
EndFunc
```

#### C. Interrupt condition

```autoit
Func CanUse_PowerBlock()
    ; Don't use if Guilt or Diversion
    If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_GUILT, "HasEffect") Then
        Return False
    EndIf
    If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_DIVERSION, "HasEffect") Then
        Return False
    EndIf

    ; Only if target is casting
    If Not Agent_GetAgentInfo($BestTarget, "IsCasting") Then
        Return False
    EndIf

    Return True
EndFunc
```

#### D. Complex condition with multiple effects

```autoit
Func CanUse_ComplexSkill()
    ; Check self effects
    Local $mEffects = Agent_GetEffectsArray(-2)
    Local $lHasRequiredBuff = False

    For $i = 1 To $mEffects[0]
        Local $lEffectID = Memory_Read($mEffects[$i], 'long')
        If $lEffectID = $GC_I_SKILL_ID_RequiredBuff Then
            $lHasRequiredBuff = True
            ExitLoop
        EndIf
    Next

    If Not $lHasRequiredBuff Then Return False

    ; Check target state
    If Agent_GetAgentInfo($BestTarget, "HPPercent") > 0.5 Then Return False

    ; Check environmental conditions
    If Party_GetAverageHealth() < 0.3 Then Return False

    Return True
EndFunc
```

---

## 7. RESOURCE MANAGEMENT SYSTEM

### 7.1 SmartCast_CanCast() - Resource Verification

This function is called **before** `CanUse_` to check if the player has the necessary resources.

```autoit
Func SmartCast_CanCast($aSkillSlot)
```

**Checks performed:**

#### A. Recharge

```autoit
If Not Skill_GetSkillbarInfo($aSkillSlot, "IsRecharged") Then Return False
```

#### B. Adrenaline

```autoit
If $SkillBarCache[$aSkillSlot][$Adrenaline] <> 0 Then
    If Skill_GetSkillbarInfo($aSkillSlot, "Adrenaline") < $SkillBarCache[$aSkillSlot][$Adrenaline] Then
        Return False
    EndIf
EndIf
```

#### C. Health Cost (Sacrifice + Masochism)

```autoit
Local $lTotalHealthCost = 0

; Base cost (sacrifice spells)
Local $lBaseSacrificeCost = Skill_GetSkillInfo($SkillBarCache[$aSkillSlot][$SkillID], "HealthCost")
If $lBaseSacrificeCost <> 0 Then
    $lTotalHealthCost = Agent_GetAgentInfo(-2, "MaxHP") * $lBaseSacrificeCost / 100

    ; Modifiers
    If Agent_HasEffect($GC_I_SKILL_ID_Awaken_the_Blood, -2) Then
        $lTotalHealthCost = $lTotalHealthCost + ($lTotalHealthCost * 0.5) ; +50%
    EndIf
    If Agent_HasEffect($GC_I_SKILL_ID_Scourge_Sacrifice, -2) Then
        $lTotalHealthCost = $lTotalHealthCost * 2 ; Double
    EndIf
EndIf

; Masochism : 5% max HP on ALL spells
If Agent_HasEffect($GC_I_SKILL_ID_Masochism, -2) Then
    $lTotalHealthCost = $lTotalHealthCost + (Agent_GetAgentInfo(-2, "MaxHP") * 0.05)
EndIf

If $lTotalHealthCost > 0 And Agent_GetAgentInfo(-2, "CurrentHP") <= $lTotalHealthCost Then
    Return False
EndIf
```

#### D. Overcast

```autoit
Local $lOvercastCost = Skill_GetSkillInfo($SkillBarCache[$aSkillSlot][$SkillID], "Overcast")
If $lOvercastCost <> 0 Then
    Local $lCurrentOvercast = Agent_GetAgentInfo(-2, "Overcast")
    Local $lMaxEnergy = Agent_GetAgentInfo(-2, "MaxEnergy")

    ; Don't exceed 50% of max energy in overcast
    If ($lCurrentOvercast + $lOvercastCost) >= ($lMaxEnergy * 0.5) Then
        Return False
    EndIf
EndIf
```

#### E. Energy Cost (with complex modifiers)

```autoit
Local $lBaseEnergyCost = $SkillBarCache[$aSkillSlot][$EnergyCost]
Local $lEnergyCost = $lBaseEnergyCost

; INCREASE in cost
If Agent_HasEffect($GC_I_SKILL_ID_Quickening_Zephyr, -2) Then
    $lEnergyCost = $lEnergyCost * 1.3 ; +30%
EndIf

If Agent_HasEffect($GC_I_SKILL_ID_Natures_Renewal, -2) Then
    If $lSkillType = $GC_I_SKILL_TYPE_HEX Or $lSkillType = $GC_I_SKILL_TYPE_ENCHANTMENT Then
        $lEnergyCost = $lEnergyCost * 2 ; Double for hex/enchant
    EndIf
EndIf

If Agent_HasEffect($GC_I_SKILL_ID_Primal_Echoes, -2) Then
    If $lSkillType = $GC_I_SKILL_TYPE_SIGNET Then
        $lEnergyCost = $lEnergyCost + 10 ; +10 for signets
    EndIf
EndIf

; REDUCTION in cost
Local $mEffects = Agent_GetEffectsArray(-2)
For $i = 1 To $mEffects[0]
    Local $lEffectID = Memory_Read($mEffects[$i], 'long')
    Switch $lEffectID
        Case $GC_I_SKILL_ID_Glyph_of_Lesser_Energy
            $lEnergyCost = $lEnergyCost - 18
        Case $GC_I_SKILL_ID_Glyph_of_Energy
            $lEnergyCost = $lEnergyCost - 25
        Case $GC_I_SKILL_ID_Energizing_Wind
            $lEnergyCost = $lEnergyCost - 15
        ; ... 15+ other modifiers ...
    EndSwitch
Next

; Minimum cost = 1 (except Way of the Empty Palm)
If $lEnergyCost < 1 And Not Agent_HasEffect($GC_I_SKILL_ID_Way_of_the_Empty_Palm, -2) Then
    $lEnergyCost = 1
EndIf
If $lEnergyCost < 0 Then $lEnergyCost = 0

If Agent_GetAgentInfo(-2, "CurrentEnergy") < $lEnergyCost Then
    Return False
EndIf
```

### 7.2 SmartCast_CanAutoAttack() - Auto-attack Management

```autoit
Func SmartCast_CanAutoAttack()
    ; Don't attack if Blind
    If Agent_HasEffect($GC_I_SKILL_ID_Blind) Then Return False

    ; Count dangerous hexes
    Local $mEffects = Agent_GetEffectsArray(-2)
    Local $lEffectCount = 0

    For $i = 1 To $mEffects[0]
        Switch Memory_Read($mEffects[$i], 'long')
            Case $GC_I_SKILL_ID_Ineptitude, $GC_I_SKILL_ID_Clumsiness,
                 $GC_I_SKILL_ID_Wandering_Eye, $GC_I_SKILL_ID_Spiteful_Spirit,
                 $GC_I_SKILL_ID_Spoil_Victor, $GC_I_SKILL_ID_Empathy,
                 $GC_I_SKILL_ID_Spirit_Shackles
                $lEffectCount += 1
                ; If HP < 200 and only one dangerous hex, don't attack
                If Agent_GetAgentInfo(-2, "CurrentHP") < 200 Then Return False
        EndSwitch
        ; If 2+ dangerous hexes, NEVER attack
        If $lEffectCount >= 2 Then Return False
    Next

    Return True
EndFunc
```

---

## 8. FILTERS AND UTILITIES

### 8.1 Agent Filters (SmartCast_Agent.au3)

#### Basic Filters

```autoit
Filter_IsLivingEnemy($aAgentID)        ; Living enemy
Filter_IsDeadEnemy($aAgentID)          ; Dead enemy
Filter_IsLivingAlly($aAgentID)         ; Living ally
Filter_IsDeadAlly($aAgentID)           ; Dead ally
Filter_ExcludeMe($aAgentID)            ; Exclude self
```

#### Condition Filters

```autoit
Filter_IsDiseased($aAgentID)           ; Has Disease
Filter_IsPoisoned($aAgentID)           ; Has Poison
Filter_IsBlind($aAgentID)              ; Has Blind
Filter_IsBurning($aAgentID)            ; Has Burning
Filter_IsBleeding($aAgentID)           ; Has Bleeding
Filter_IsCrippled($aAgentID)           ; Has Crippled
Filter_IsDeepWounded($aAgentID)        ; Has Deep Wound
Filter_IsDazed($aAgentID)              ; Has Dazed
Filter_IsWeakness($aAgentID)           ; Has Weakness
```

#### State Filters

```autoit
Filter_IsEnchanted($aAgentID)          ; Has enchantments
Filter_IsConditioned($aAgentID)        ; Has conditions
Filter_IsHexed($aAgentID)              ; Has hexes
Filter_IsDegenHexed($aAgentID)         ; Has degen hexes
Filter_IsWeaponSpelled($aAgentID)      ; Has weapon spell
Filter_IsKnocked($aAgentID)            ; Is knocked down
Filter_IsMoving($aAgentID)             ; Is moving
Filter_IsAttacking($aAgentID)          ; Is attacking
Filter_IsCasting($aAgentID)            ; Is casting
Filter_IsIdle($aAgentID)               ; Is idle
```

#### Advanced Filters

```autoit
Filter_IsSpirit($aAgentID)             ; Is a spirit
Filter_IsControlledSpirit($aAgentID)   ; Is a player-controlled spirit
Filter_IsMinion($aAgentID)             ; Is a minion
Filter_IsControlledMinion($aAgentID)   ; Is a player-controlled minion
Filter_IsBelow50HP($aAgentID)          ; HP < 50%
```

### 8.2 Utility Functions (SmartCast_Utils.au3)

#### Skill Management

```autoit
Skill_GetSlotByID($aSkillID)           ; Return slot of a skill by ID
Skill_CheckSlotByID($aSkillID)         ; Check if a skill is in the bar
```

#### Party Management

```autoit
Party_GetSize()                         ; Party size
Party_GetHeroCount()                    ; Number of heroes
Party_GetHeroID($aHeroNumber)          ; ID of specific hero
Party_GetMembersArray()                ; Array of all members
Party_GetAverageHealth()               ; Party HP average
Party_IsWiped()                        ; Is party wiped?
```

#### Effect Management

```autoit
Agent_GetEffectsArray($aAgentID)       ; Array of all effects
Agent_GetBuffsArray($aAgentID)         ; Array of all buffs
Agent_HasEffect($aSkillID, $aAgentID)  ; Has this effect?
```

---

## 9. ADVANCED CUSTOMIZATION

### 9.1 Modify Skill Targeting

**Example: Modify Healing Signet to only use at 50% HP**

1. **Find the function in SmartCast_BestTarget.au3:**

```autoit
Func BestTarget_HealingSignet($aAggroRange)
    Return Agent_GetMyID()
EndFunc
```

2. **No modification needed** (self-target is correct)

3. **Modify the condition in SmartCast_CanUse.au3:**

```autoit
Func CanUse_HealingSignet()
    If Agent_GetAgentEffectInfo(-2, $GC_I_SKILL_ID_IGNORANCE, "HasEffect") Then
        Return False
    EndIf

    ; MODIFICATION: Use at 50% instead of 80%
    If Agent_GetAgentInfo(-2, "HPPercent") > 0.50 Then
        Return False
    EndIf

    Return True
EndFunc
```

### 9.2 Create Intelligent Targeting for a Skill

**Example: Aegis targeted on the most threatened ally**

```autoit
Func BestTarget_Aegis($aAggroRange)
    Local $lBestTarget = 0
    Local $lBestPriority = -9999

    Local $lPartyArray = Party_GetMembersArray()

    For $i = 1 To $lPartyArray[0]
        Local $lAgentID = $lPartyArray[$i]

        ; Ignore dead
        If Agent_GetAgentInfo($lAgentID, "IsDead") Then ContinueLoop

        ; Ignore if already has Aegis
        If Agent_HasEffect($GC_I_SKILL_ID_AEGIS, $lAgentID) Then ContinueLoop

        ; Ignore if too far
        If Agent_GetDistance($lAgentID) > $aAggroRange Then ContinueLoop

        ; Priority calculation
        Local $lPriority = 0

        ; Lower HP = higher priority
        Local $lHPPercent = Agent_GetAgentInfo($lAgentID, "HPPercent")
        $lPriority += (1 - $lHPPercent) * 100

        ; Bonus if ally is being attacked
        If Agent_GetAgentInfo($lAgentID, "IsBeingAttacked") Then
            $lPriority += 50
        EndIf

        ; Bonus if ally has Deep Wound
        If Agent_GetAgentInfo($lAgentID, "IsDeepWounded") Then
            $lPriority += 30
        EndIf

        ; Penalty if ally already has prots
        If Agent_GetAgentInfo($lAgentID, "IsEnchanted") Then
            $lPriority -= 20
        EndIf

        ; Update best target
        If $lPriority > $lBestPriority Then
            $lBestPriority = $lPriority
            $lBestTarget = $lAgentID
        EndIf
    Next

    Return $lBestTarget
EndFunc
```

### 9.3 Create a Complex Condition

**Example: Only use Shadow Form in critical situations**

```autoit
Func CanUse_ShadowForm()
    ; Don't use if already active
    If Agent_HasEffect($GC_I_SKILL_ID_SHADOW_FORM, -2) Then
        Return False
    EndIf

    ; Danger counter
    Local $lDangerLevel = 0

    ; Low HP = danger
    If Agent_GetAgentInfo(-2, "HPPercent") < 0.5 Then $lDangerLevel += 2
    If Agent_GetAgentInfo(-2, "HPPercent") < 0.3 Then $lDangerLevel += 3

    ; Nearby enemies = danger
    Local $lEnemyCount = Count_NumberOf(-2, 500, "Filter_IsLivingEnemy")
    $lDangerLevel += $lEnemyCount

    ; Dangerous conditions
    If Agent_GetAgentInfo(-2, "IsDeepWounded") Then $lDangerLevel += 2
    If Agent_GetAgentInfo(-2, "IsBleeding") Then $lDangerLevel += 1
    If Agent_GetAgentInfo(-2, "IsPoisoned") Then $lDangerLevel += 1

    ; Dangerous hexes
    If Agent_HasEffect($GC_I_SKILL_ID_PRICE_OF_FAILURE, -2) Then $lDangerLevel += 3
    If Agent_HasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT, -2) Then $lDangerLevel += 3

    ; Danger threshold: only use if danger >= 5
    If $lDangerLevel >= 5 Then
        Return True
    EndIf

    Return False
EndFunc
```

### 9.4 Add Priority Skills

In `SmartCast_Core.au3`, function `SmartCast_PrioritySkills()`:

```autoit
Func SmartCast_PrioritySkills()
    ; Default priority skills
    Local $aPrioritySkills[] = [
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

    For $skillID In $aPrioritySkills
        Local $slot = Skill_GetSlotByID($skillID)
        If $slot > 0 Then
            _TryCastPrioritySkill($slot)
        EndIf
    Next
EndFunc
```

### 9.5 Create a Combo System

**Example: Searing Flames Combo**

```autoit
Func BestTarget_SearingFlames($aAggroRange)
    ; Search for an enemy that does NOT have Burning
    Local $lTarget = Nearest_Agent_Without_Condition(-2, $aAggroRange,
                                                      "Filter_IsLivingEnemy",
                                                      $GC_I_SKILL_ID_BURNING)

    ; If all have Burning, target nearest
    If $lTarget = 0 Then
        $lTarget = Nearest_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy")
    EndIf

    Return $lTarget
EndFunc

Func CanUse_SearingFlames()
    ; Check that we have Glyph of Lesser Energy active (for energy savings)
    If Not Agent_HasEffect($GC_I_SKILL_ID_GLYPH_OF_LESSER_ENERGY, -2) Then
        ; Try to cast Glyph if available
        Local $lGlyphSlot = Skill_GetSlotByID($GC_I_SKILL_ID_GLYPH_OF_LESSER_ENERGY)
        If $lGlyphSlot > 0 And SmartCast_CanCast($lGlyphSlot) Then
            SmartCast_UseSkillEX($lGlyphSlot, Agent_GetMyID())
            Sleep(250) ; Wait for activation
        EndIf
    EndIf

    ; Check available energy
    If Agent_GetAgentInfo(-2, "CurrentEnergy") < 15 Then
        Return False
    EndIf

    ; Check that there are enemies
    If Count_NumberOf(-2, 1320, "Filter_IsLivingEnemy") = 0 Then
        Return False
    EndIf

    Return True
EndFunc
```

---

## 10. PRACTICAL EXAMPLES

### 10.1 Monk Spike Build

**Objective:** Prioritize healing on critical allies

```autoit
; === WORD OF HEALING ===
Func BestTarget_WordOfHealing($aAggroRange)
    ; Priority 1: Ally < 30% HP
    Local $lTarget = Lowest_HP_Agent_Below_Threshold(-2, $aAggroRange,
                                                      "Filter_IsLivingAlly",
                                                      0.30)
    If $lTarget <> 0 Then Return $lTarget

    ; Priority 2: Self if < 50%
    If Agent_GetAgentInfo(-2, "HPPercent") < 0.50 Then
        Return Agent_GetMyID()
    EndIf

    ; Priority 3: Lowest ally
    Return Lowest_HP_Agent(-2, $aAggroRange, "Filter_IsLivingAlly")
EndFunc

Func CanUse_WordOfHealing()
    ; Don't use if target > 80% HP
    If Agent_GetAgentInfo($BestTarget, "HPPercent") > 0.80 Then
        Return False
    EndIf

    ; Don't use if under Guilt/Shame
    If Agent_HasEffect($GC_I_SKILL_ID_GUILT, -2) Or
       Agent_HasEffect($GC_I_SKILL_ID_SHAME, -2) Then
        Return False
    EndIf

    Return True
EndFunc

; === PATIENT SPIRIT ===
Func BestTarget_PatientSpirit($aAggroRange)
    Local $lPartyArray = Party_GetMembersArray()

    For $i = 1 To $lPartyArray[0]
        Local $lAgentID = $lPartyArray[$i]

        ; Ignore if dead, too far, or already has Patient Spirit
        If Agent_GetAgentInfo($lAgentID, "IsDead") Then ContinueLoop
        If Agent_GetDistance($lAgentID) > $aAggroRange Then ContinueLoop
        If Agent_HasEffect($GC_I_SKILL_ID_PATIENT_SPIRIT, $lAgentID) Then ContinueLoop

        ; Target if HP < 70% and being attacked
        If Agent_GetAgentInfo($lAgentID, "HPPercent") < 0.70 And
           Agent_GetAgentInfo($lAgentID, "IsBeingAttacked") Then
            Return $lAgentID
        EndIf
    Next

    Return 0
EndFunc

Func CanUse_PatientSpirit()
    ; Always usable if we found a target
    If $BestTarget = 0 Then Return False
    Return True
EndFunc
```

### 10.2 Discord Necro Build

**Objective:** Optimize cast order to maximize Discord damage

```autoit
; === DISCORD ===
Func BestTarget_Discord($aAggroRange)
    ; Target enemy with MOST conditions (for max damage)
    Local $lBestTarget = 0
    Local $lMaxConditions = 0

    For $i = 1 To GetMaxAgents()
        Local $lAgentID = Agent_GetAgentByArrayIndex($i)
        If Not Filter_IsLivingEnemy($lAgentID) Then ContinueLoop
        If Agent_GetDistance($lAgentID) > $aAggroRange Then ContinueLoop

        ; Count conditions
        Local $lCondCount = 0
        If Filter_IsPoisoned($lAgentID) Then $lCondCount += 1
        If Filter_IsDiseased($lAgentID) Then $lCondCount += 1
        If Filter_IsBleeding($lAgentID) Then $lCondCount += 1
        If Filter_IsWeakness($lAgentID) Then $lCondCount += 1
        If Filter_IsCrippled($lAgentID) Then $lCondCount += 1
        If Filter_IsDazed($lAgentID) Then $lCondCount += 1
        If Filter_IsBlind($lAgentID) Then $lCondCount += 1
        If Filter_IsBurning($lAgentID) Then $lCondCount += 1
        If Filter_IsDeepWounded($lAgentID) Then $lCondCount += 1

        If $lCondCount > $lMaxConditions Then
            $lMaxConditions = $lCondCount
            $lBestTarget = $lAgentID
        EndIf
    Next

    ; Fallback: nearest enemy
    If $lBestTarget = 0 Then
        $lBestTarget = Nearest_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy")
    EndIf

    Return $lBestTarget
EndFunc

Func CanUse_Discord()
    ; Only cast if target has AT LEAST 2 conditions
    Local $lCondCount = 0
    If Filter_IsPoisoned($BestTarget) Then $lCondCount += 1
    If Filter_IsDiseased($BestTarget) Then $lCondCount += 1
    If Filter_IsBleeding($BestTarget) Then $lCondCount += 1
    If Filter_IsWeakness($BestTarget) Then $lCondCount += 1
    If Filter_IsCrippled($BestTarget) Then $lCondCount += 1

    If $lCondCount < 2 Then Return False

    Return True
EndFunc

; === ROTTING FLESH (apply before Discord) ===
Func BestTarget_RottingFlesh($aAggroRange)
    ; Target enemy with LEAST conditions (for optimal spread)
    Return Nearest_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy")
EndFunc

Func CanUse_RottingFlesh()
    ; Cast in priority before Discord
    Return True
EndFunc
```

### 10.3 Assassin's Promise Build

**Objective:** Manage AP cycle + chain skills

```autoit
; === ASSASSIN'S PROMISE ===
Func BestTarget_AssassinsPromise($aAggroRange)
    ; Target enemy with LOWEST HP (for quick kill)
    Local $lTarget = Lowest_HP_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy")

    ; Bonus: if < 25% HP, it's perfect
    If $lTarget <> 0 And Agent_GetAgentInfo($lTarget, "HPPercent") < 0.25 Then
        Return $lTarget
    EndIf

    Return $lTarget
EndFunc

Func CanUse_AssassinsPromise()
    ; Don't re-cast if already active on a target
    If Agent_HasEffect($GC_I_SKILL_ID_ASSASSINS_PROMISE, $BestTarget) Then
        Return False
    EndIf

    ; Only cast if we have enough energy for the full combo
    If Agent_GetAgentInfo(-2, "CurrentEnergy") < 25 Then
        Return False
    EndIf

    ; Only cast if target < 50% HP
    If Agent_GetAgentInfo($BestTarget, "HPPercent") > 0.50 Then
        Return False
    EndIf

    Return True
EndFunc

; === SIPHON SPEED (cast after AP) ===
Func CanUse_SiphonSpeed()
    ; Only if AP is active on target
    If Not Agent_HasEffect($GC_I_SKILL_ID_ASSASSINS_PROMISE, $BestTarget) Then
        Return False
    EndIf

    Return True
EndFunc
```

---

## 11. OPTIMIZATION AND BEST PRACTICES

### 11.1 Performance

#### A. Use cache intelligently

```autoit
; ❌ BAD: Reads memory each time
Func BestTarget_Skill($aAggroRange)
    For $i = 1 To 100
        Local $lSkillID = Skill_GetSkillbarInfo(1, "SkillID")  ; Memory read
        ; ...
    EndFor
EndFunc

; ✅ GOOD: Uses cache
Func BestTarget_Skill($aAggroRange)
    Local $lSkillID = $SkillBarCache[1][$SkillID]  ; Read from cache
    ; ...
EndFunc
```

#### B. Avoid unnecessary loops

```autoit
; ❌ BAD: Loop on all agents
Func BestTarget_Skill($aAggroRange)
    For $i = 1 To GetMaxAgents()
        Local $lAgentID = Agent_GetAgentByArrayIndex($i)
        If Filter_IsLivingEnemy($lAgentID) Then
            Return $lAgentID
        EndIf
    Next
EndFunc

; ✅ GOOD: Use optimized helper function
Func BestTarget_Skill($aAggroRange)
    Return Nearest_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy")
EndFunc
```

#### C. Return early

```autoit
; ❌ BAD: Checks everything even if already invalid
Func CanUse_Skill()
    Local $lValid = True

    If Agent_GetAgentInfo(-2, "HPPercent") > 0.80 Then $lValid = False
    If Agent_HasEffect($GC_I_SKILL_ID_IGNORANCE, -2) Then $lValid = False
    If $BestTarget = 0 Then $lValid = False

    Return $lValid
EndFunc

; ✅ GOOD: Return as soon as invalid
Func CanUse_Skill()
    If Agent_GetAgentInfo(-2, "HPPercent") > 0.80 Then Return False
    If Agent_HasEffect($GC_I_SKILL_ID_IGNORANCE, -2) Then Return False
    If $BestTarget = 0 Then Return False

    Return True
EndFunc
```

### 11.2 Maintainability

#### A. Comment complex logic

```autoit
Func CanUse_ComplexSkill()
    ; Check safety conditions
    ; Don't cast if under Guilt (increases recharge by 10s)
    If Agent_HasEffect($GC_I_SKILL_ID_GUILT, -2) Then Return False

    ; Calculate surrounding danger
    ; Formula: nb_enemies * 10 + (1 - HP%) * 50
    Local $lDanger = Count_NumberOf(-2, 500, "Filter_IsLivingEnemy") * 10
    $lDanger += (1 - Agent_GetAgentInfo(-2, "HPPercent")) * 50

    ; Danger threshold: 30
    ; Below this, the skill is not necessary
    If $lDanger < 30 Then Return False

    Return True
EndFunc
```

#### B. Name variables clearly

```autoit
; ❌ BAD
Func BestTarget_Skill($aAggroRange)
    Local $a = 0
    Local $b = -9999
    For $i = 1 To $x
        Local $c = $y[$i]
        ; ...
    Next
EndFunc

; ✅ GOOD
Func BestTarget_Skill($aAggroRange)
    Local $lBestTarget = 0
    Local $lBestPriority = -9999
    Local $lPartyArray = Party_GetMembersArray()

    For $i = 1 To $lPartyArray[0]
        Local $lAgentID = $lPartyArray[$i]
        ; ...
    Next
EndFunc
```

### 11.3 Debugging

#### A. Use Out() for logging

```autoit
Func BestTarget_Skill($aAggroRange)
    Local $lTarget = Nearest_Agent(-2, $aAggroRange, "Filter_IsLivingEnemy")

    ; Debug log
    Out("BestTarget_Skill : Target = " & $lTarget &
        " (Range: " & Agent_GetDistance($lTarget) & ")")

    Return $lTarget
EndFunc
```

#### B. Test conditions individually

```autoit
Func CanUse_Skill()
    ; Test each condition and log
    If Agent_GetAgentInfo(-2, "HPPercent") > 0.80 Then
        Out("CanUse_Skill : FAILED - HP too high (" &
            Agent_GetAgentInfo(-2, "HPPercent") & ")")
        Return False
    EndIf

    If Agent_HasEffect($GC_I_SKILL_ID_IGNORANCE, -2) Then
        Out("CanUse_Skill : FAILED - Under Ignorance")
        Return False
    EndIf

    Out("CanUse_Skill : SUCCESS")
    Return True
EndFunc
```

---

## CONCLUSION

The **SmartCast** system is an flexible and powerful framework for automating Guild Wars gameplay.

### Key Takeaways:

1. **Modular architecture**: Each skill has its own targeting and condition functions
2. **Intelligent cache**: Optimizes performance by avoiding repeated memory reads
3. **Resource management**: Sophisticated system that accounts for all modifiers
4. **Extensibility**: Easy to add/modify behaviors for each skill
5. **Separation of concerns**: BestTarget (WHO), CanUse (WHEN), CanCast (CAN-WE)

### Going Further:

- Study existing functions in `SmartCast_BestTarget.au3`
- Analyze complex conditions in `SmartCast_CanUse.au3`
- Create your own custom filters
- Optimize skill priorities according to your build

**The system is designed to be modified and customized according to your specific needs!**

---

*Documentation created by Greg-76 (Alusion)*
*For questions or improvements: [GitHub](https://github.com/JAG-GW/GwAu3)*
