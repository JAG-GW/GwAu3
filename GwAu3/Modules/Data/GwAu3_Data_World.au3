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
            Return Memory_Read($l_p_Ptr + 0x81C, "ptr")

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
#EndRegion World Context
