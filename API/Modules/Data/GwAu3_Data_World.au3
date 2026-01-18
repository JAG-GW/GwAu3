#include-once

#Region World Context
Func World_GetWorldContextPtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x2C]
    Local $l_ap_WorldContextPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_ap_WorldContextPtr[1]
EndFunc

Func World_GetWorldInfo($a_s_Info = "")
    Local $l_p_Ptr = World_GetWorldContextPtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AccountInfo"
            Return Memory_Read($l_p_Ptr, "ptr")
        Case "MessageBuffArray" ;--> To check <Useless ??>
            Return Memory_Read($l_p_Ptr + 0x4, "ptr")
        Case "DialogBuffArray" ;--> To check <Useless ??>
            Return Memory_Read($l_p_Ptr + 0x14, "ptr")
        Case "MerchItemArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x24, "ptr")
        Case "MerchItemArraySize" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x24 + 0x4, "dword")
        Case "MerchItemArray2" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x34, "ptr")
        Case "MerchItemArray2Size" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x34 + 0x4, "dword")
        Case "PartyAllyArray" ;--> To check <Useless ??>
            Return Memory_Read($l_p_Ptr + 0x8C, "ptr")
        Case "FlagAll"
            Local $l_af_Flags[3] = [Memory_Read($l_p_Ptr + 0x9C, "float"), _
                                    Memory_Read($l_p_Ptr + 0xA0, "float"), _
                                    Memory_Read($l_p_Ptr + 0xA4, "float")]
            Return $l_af_Flags
        Case "ActiveQuestID"
            Return Memory_Read($l_p_Ptr + 0x528, "dword")
        Case "PlayerNumber"
            Return Memory_Read($l_p_Ptr + 0x67C, "dword")
        Case "MyID"
            Local $l_i_ID = Memory_Read($l_p_Ptr + 0x680, "dword")
            Return Memory_Read($l_i_ID + 0x14, "dword")
        Case "IsHmUnlocked"
            Return Memory_Read($l_p_Ptr + 0x684, "dword")
        Case "SalvageSessionID"
            Return Memory_Read($l_p_Ptr + 0x690, "dword")
        Case "PlayerTeamToken"
            Return Memory_Read($l_p_Ptr + 0x6A8, "dword")
        Case "Experience"
            Return Memory_Read($l_p_Ptr + 0x740, "dword")
        Case "CurrentKurzick"
            Return Memory_Read($l_p_Ptr + 0x748, "dword")
        Case "TotalEarnedKurzick"
            Return Memory_Read($l_p_Ptr + 0x750, "dword")
        Case "CurrentLuxon"
            Return Memory_Read($l_p_Ptr + 0x758, "dword")
        Case "TotalEarnedLuxon"
            Return Memory_Read($l_p_Ptr + 0x760, "dword")
        Case "CurrentImperial"
            Return Memory_Read($l_p_Ptr + 0x768, "dword")
        Case "TotalEarnedImperial"
            Return Memory_Read($l_p_Ptr + 0x770, "dword")
        Case "Level"
            Return Memory_Read($l_p_Ptr + 0x788, "dword")
        Case "Morale"
            Return Memory_Read($l_p_Ptr + 0x790, "dword")
        Case "CurrentBalth"
            Return Memory_Read($l_p_Ptr + 0x798, "dword")
        Case "TotalEarnedBalth"
            Return Memory_Read($l_p_Ptr + 0x7A0, "dword")
        Case "CurrentSkillPoints"
            Return Memory_Read($l_p_Ptr + 0x7A8, "dword")
        Case "TotalEarnedSkillPoints"
            Return Memory_Read($l_p_Ptr + 0x7B0, "dword")
        Case "MaxKurzickPoints"
            Return Memory_Read($l_p_Ptr + 0x7B8, "dword")
        Case "MaxLuxonPoints"
            Return Memory_Read($l_p_Ptr + 0x7BC, "dword")
        Case "MaxBalthPoints"
            Return Memory_Read($l_p_Ptr + 0x7C0, "dword")
        Case "MaxImperialPoints"
            Return Memory_Read($l_p_Ptr + 0x7C4, "dword")
        Case "EquipmentStatus"
            Return Memory_Read($l_p_Ptr + 0x7C8, "dword")
        Case "FoesKilled"
            Return Memory_Read($l_p_Ptr + 0x84C, "dword")
        Case "FoesToKill"
            Return Memory_Read($l_p_Ptr + 0x850, "dword")

        ;Map Agent Array <Useless ??>
        Case "MapAgentArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x7C, "ptr")
        Case "MapAgentArraySize" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x7C + 0x8, "long")

        ;Party Attribute Array
        Case "PartyAttributeArray"
            Return Memory_Read($l_p_Ptr + 0xAC, "ptr")
        Case "PartyAttributeArraySize"
            Return Memory_Read($l_p_Ptr + 0xAC + 0x8, "long")

        ;Agent Effect Array
        Case "AgentEffectsArray"
            Return Memory_Read($l_p_Ptr + 0x508, "ptr")
        Case "AgentEffectsArraySize"
            Return Memory_Read($l_p_Ptr + 0x508 + 0x8, "long")

        ;Quest Array
        Case "QuestLog"
            Return Memory_Read($l_p_Ptr + 0x52C, "ptr")
        Case "QuestLogSize"
            Return Memory_Read($l_p_Ptr + 0x52C + 0x8, "long")

        ;Mission Objective <Useless ??>
        Case "MissionObjectiveArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x564, "ptr")
        Case "MissionObjectiveArraySize" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x564 + 0x8, "long")

        ;Hero Array
        Case "HeroFlagArray"
            Return Memory_Read($l_p_Ptr + 0x584, "ptr")
        Case "HeroFlagArraySize"
            Return Memory_Read($l_p_Ptr + 0x584 + 0x8, "long")
        Case "HeroInfoArray"
            Return Memory_Read($l_p_Ptr + 0x594, "ptr")
        Case "HeroInfoArraySize"
            Return Memory_Read($l_p_Ptr + 0x594 + 0x8, "long")

        ;Minion Array
        Case "ControlledMinionsArray"
            Return Memory_Read($l_p_Ptr + 0x5BC, "ptr")
        Case "ControlledMinionsArraySize"
            Return Memory_Read($l_p_Ptr + 0x5BC + 0x8, "long")

        ;Morale Array
        Case "PlayerMoraleInfo"
            Return Memory_Read($l_p_Ptr + 0x624, "ptr")
        Case "PlayerMoraleInfoSize"
            Return Memory_Read($l_p_Ptr + 0x624 + 0x8, "long")
        Case "PartyMoraleInfo"
            Return Memory_Read($l_p_Ptr + 0x62C, "ptr")
        Case "PartyMoraleInfoSize"
            Return Memory_Read($l_p_Ptr + 0x62C + 0x8, "long")

        ;Pet Array
        Case "PetInfoArray"
            Return Memory_Read($l_p_Ptr + 0x6AC, "ptr")
        Case "PetInfoArraySize"
            Return Memory_Read($l_p_Ptr + 0x6AC + 0x8, "long")

        ;Party Profession Array
        Case "PartyProfessionArray"
            Return Memory_Read($l_p_Ptr + 0x6BC, "ptr")
        Case "PartyProfessionArraySize"
            Return Memory_Read($l_p_Ptr + 0x6BC + 0x8, "long")

        ;Skill Array
        Case "SkillbarArray"
            Return Memory_Read($l_p_Ptr + 0x6F0, "ptr")
        Case "SkillbarArraySize"
            Return Memory_Read($l_p_Ptr + 0x6F0 + 0x8, "long")

        ;Agent Info Array (name only)
        Case "AgentInfoArray" ;--> To check (name_enc) <Useless for GwAu3>
            Return Memory_Read($l_p_Ptr + 0x7CC, "ptr")
        Case "AgentInfoArraySize" ;--> To check (name_enc) <Useless for GwAu3>
            Return Memory_Read($l_p_Ptr + 0x7CC + 0x8, "long")

        ;NPC Array
        Case "NPCArray"
            Return Memory_Read($l_p_Ptr + 0x7FC, "ptr")
        Case "NPCArraySize"
            Return Memory_Read($l_p_Ptr + 0x7FC + 0x8, "long")

        ;Player Array
        Case "PlayerArray"
            Return Memory_Read($l_p_Ptr + 0x80C, "ptr")
        Case "PlayerArraySize"
            Return Memory_Read($l_p_Ptr + 0x80C + 0x8, "long")

        ;Title Array
        Case "TitleArray"
            Return Memory_Read($l_p_Ptr + 0x81C, "ptr")
        Case "TitleArraySize"
            Return Memory_Read($l_p_Ptr + 0x81C + 0x8, "long")

        ;Special array
        Case "VanquishedAreasArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x83C, "ptr")
        Case "VanquishedAreasArraySize" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x83C + 0x8, "long")
        Case "MissionsCompletedArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x5CC, "ptr")
        Case "MissionsBonusArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x5DC, "ptr")
        Case "MissionsCompletedHMArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x5EC, "ptr")
        Case "MissionsBonusHMArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x5FC, "ptr")
        Case "LearnableSkillsArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x700, "ptr")
        Case "UnlockedSkillsArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x710, "ptr")
        Case "UnlockedMapArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x60C, "ptr")
        Case "HenchmanIDArray" ;--> To check
            Return Memory_Read($l_p_Ptr + 0x574, "ptr")
    EndSwitch

    Return 0
EndFunc

Func World_IsSkillLearnt($a_i_SkillID)
    Local $l_p_WorldContext = World_GetWorldContextPtr()
    If $l_p_WorldContext = 0 Then Return False

    Local $l_p_UnlockedSkillsArray = Memory_Read($l_p_WorldContext + 0x710, "ptr")
    If $l_p_UnlockedSkillsArray = 0 Then Return False

    Local $l_i_ArraySize = Memory_Read($l_p_WorldContext + 0x710 + 0x8, "long")

    Local $l_i_RealIndex = Floor($a_i_SkillID / 32)

    If $l_i_RealIndex >= $l_i_ArraySize Then Return False

    Local $l_i_Shift = Mod($a_i_SkillID, 32)
    Local $l_i_Flag = BitShift(1, -$l_i_Shift)

    Local $l_i_Value = Memory_Read($l_p_UnlockedSkillsArray + ($l_i_RealIndex * 4), "dword")

    Return BitAND($l_i_Value, $l_i_Flag) <> 0
EndFunc

Func World_GetSkillDuplicateCount($a_i_SkillID)
    Local $l_p_WorldContext = World_GetWorldContextPtr()
    If $l_p_WorldContext = 0 Then Return 0

    Local $l_p_DupeSkillsArray = Memory_Read($l_p_WorldContext + 0x720, "ptr")
    If $l_p_DupeSkillsArray = 0 Then Return 0

    Local $l_i_ArraySize = Memory_Read($l_p_WorldContext + 0x720 + 0x8, "long")

    For $i = 0 To $l_i_ArraySize - 1
        Local $l_p_DupeSkill = $l_p_DupeSkillsArray + ($i * 0x4)

        Local $l_i_CurrentSkillID = Memory_Read($l_p_DupeSkill + 0x0, "long")

        If $l_i_CurrentSkillID = $a_i_SkillID Then
            Local $l_i_Count = Memory_Read($l_p_DupeSkill + 0x4, "long")
            Return $l_i_Count
        EndIf
    Next

    Return 0
EndFunc

; ============================================================================
; Mission State Constants
; ============================================================================
Global Const $c_MissionState_None = 0
Global Const $c_MissionState_Primary = 1      ; Mission completed (basic)
Global Const $c_MissionState_Expert = 2       ; Expert (Prophecies: bonus, Factions/NF: completed)
Global Const $c_MissionState_Master = 4       ; Master (Factions/NF: bonus)

; ============================================================================
; World_MissionGetState - Get mission completion state for a given map
; Parameters:
;   $a_i_MapID    - The map ID to check
;   $a_b_HardMode - True for Hard Mode, False for Normal Mode (default)
; Returns:
;   Bitfield with mission state flags:
;   - $c_MissionState_Primary (1) = Basic completion
;   - $c_MissionState_Expert  (2) = Expert completion
;   - $c_MissionState_Master  (4) = Master completion
;   Returns 0 if not a mission map or not completed
; ============================================================================
Func World_MissionGetState($a_i_MapID, $a_b_HardMode = False)
    ; Check if this is a valid mission map
    Local $l_i_RegionType = Map_GetAreaInfo($a_i_MapID, "RegionType")
    If $l_i_RegionType = 0 Then Return 0

    ; Only missions, cooperative missions, and dungeons have completion state
    Switch $l_i_RegionType
        Case $GC_I_MAP_REGIONTYPE_CooperativeMission, $GC_I_MAP_REGIONTYPE_MissionOutpost, $GC_I_MAP_REGIONTYPE_Dungeon
            ; Valid mission type
        Case Else
            Return 0
    EndSwitch

    ; Get completion arrays from WorldContext
    Local $l_p_WorldContext = World_GetWorldContextPtr()
    If $l_p_WorldContext = 0 Then Return 0

    Local $l_p_CompletedArray, $l_p_BonusArray
    Local $l_i_CompletedSize, $l_i_BonusSize

    If $a_b_HardMode Then
        $l_p_CompletedArray = Memory_Read($l_p_WorldContext + 0x5EC, "ptr")
        $l_i_CompletedSize = Memory_Read($l_p_WorldContext + 0x5EC + 0x8, "long")
        $l_p_BonusArray = Memory_Read($l_p_WorldContext + 0x5FC, "ptr")
        $l_i_BonusSize = Memory_Read($l_p_WorldContext + 0x5FC + 0x8, "long")
    Else
        $l_p_CompletedArray = Memory_Read($l_p_WorldContext + 0x5CC, "ptr")
        $l_i_CompletedSize = Memory_Read($l_p_WorldContext + 0x5CC + 0x8, "long")
        $l_p_BonusArray = Memory_Read($l_p_WorldContext + 0x5DC, "ptr")
        $l_i_BonusSize = Memory_Read($l_p_WorldContext + 0x5DC + 0x8, "long")
    EndIf

    ; Read completion status using bitfield
    Local $l_b_Complete = Utils_Array_BoolAt($l_p_CompletedArray, $l_i_CompletedSize, $a_i_MapID)
    Local $l_b_Bonus = Utils_Array_BoolAt($l_p_BonusArray, $l_i_BonusSize, $a_i_MapID)

    ; Determine state based on campaign
    Local $l_i_Campaign = Map_GetAreaInfo($a_i_MapID, "Campaign")

    Local $l_b_Primary = $l_b_Complete
    Local $l_b_Expert = $l_b_Bonus
    Local $l_b_Master = False

    ; Factions and Nightfall have different completion logic:
    ; - Master = bonus
    ; - Expert = completed
    ; - Primary = any
    Switch $l_i_Campaign
        Case $GC_I_MAP_CAMPAIGN_FACTIONS, $GC_I_MAP_CAMPAIGN_NIGHTFALL
            $l_b_Master = $l_b_Bonus
            $l_b_Expert = $l_b_Complete
            $l_b_Primary = $l_b_Master Or $l_b_Expert
    EndSwitch

    ; Build state bitfield
    Local $l_i_State = 0
    If $l_b_Primary Then $l_i_State = BitOR($l_i_State, $c_MissionState_Primary)
    If $l_b_Expert Then $l_i_State = BitOR($l_i_State, $c_MissionState_Expert)
    If $l_b_Master Then $l_i_State = BitOR($l_i_State, $c_MissionState_Master)

    Return $l_i_State
EndFunc

; ============================================================================
; World_MissionIsCompleted - Check if a mission is completed
; Parameters:
;   $a_i_MapID    - The map ID to check
;   $a_b_HardMode - True for Hard Mode, False for Normal Mode (default)
; Returns: True if mission has any completion, False otherwise
; ============================================================================
Func World_MissionIsCompleted($a_i_MapID, $a_b_HardMode = False)
    Return BitAND(World_MissionGetState($a_i_MapID, $a_b_HardMode), $c_MissionState_Primary) <> 0
EndFunc

; ============================================================================
; World_MissionHasExpert - Check if a mission has expert completion
; Parameters:
;   $a_i_MapID    - The map ID to check
;   $a_b_HardMode - True for Hard Mode, False for Normal Mode (default)
; Returns: True if expert completed, False otherwise
; ============================================================================
Func World_MissionHasExpert($a_i_MapID, $a_b_HardMode = False)
    Return BitAND(World_MissionGetState($a_i_MapID, $a_b_HardMode), $c_MissionState_Expert) <> 0
EndFunc

; ============================================================================
; World_MissionHasMaster - Check if a mission has master completion
; Parameters:
;   $a_i_MapID    - The map ID to check
;   $a_b_HardMode - True for Hard Mode, False for Normal Mode (default)
; Returns: True if master completed, False otherwise
; ============================================================================
Func World_MissionHasMaster($a_i_MapID, $a_b_HardMode = False)
    Return BitAND(World_MissionGetState($a_i_MapID, $a_b_HardMode), $c_MissionState_Master) <> 0
EndFunc
#EndRegion World Context
