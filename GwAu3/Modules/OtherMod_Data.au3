#include-once

;~ Description: Internal use for BuyItem()
Func GwAu3_OtherMod_GetMerchantItemsBase()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x24]
    Local $l_av_Return = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsBase

;~ Description: Internal use for BuyItem()
Func GwAu3_OtherMod_GetMerchantItemsSize()
    Local $l_ai_Offset[4] = [0, 0x18, 0x2C, 0x28]
    Local $l_av_Return = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Return[1]
EndFunc   ;==>GetMerchantItemsSize

;~ Description: Returns current ping.
Func GwAu3_OtherMod_GetPing()
    Return GwAu3_Memory_Read($g_p_Ping)
EndFunc   ;==>GetPing

;~ Description: Returns your characters name.
Func GwAu3_OtherMod_GetCharname()
    Return GwAu3_Memory_Read($g_p_CharName, 'wchar[30]')
EndFunc   ;==>GetCharname

;~ Returns how long the current instance has been active, in milliseconds.
Func GwAu3_OtherMod_GetInstanceUpTime()
    Local $l_ai_Offset[4] = [0, 0x18, 0x8, 0x1AC]
    Local $l_av_Timer = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_av_Timer[1]
EndFunc   ;==>GetInstanceUpTime

#Region Game Context Related
Func GwAu3_OtherMod_GetGameContextPtr()
    Local $l_ai_Offset[2] = [0, 0x18]
    Local $l_ap_GamePtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_GamePtr[1]
EndFunc

Func GwAu3_OtherMod_GetGameInfo($a_s_Info = "")
    Local $l_p_Ptr = GwAu3_OtherMod_GetGameContextPtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AgentContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x8, "ptr")
        Case "MapContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x14, "ptr")

        Case "TextParser"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x18, "ptr")
        Case "GameLanguage"
            Local $l_p_TextParserPtr = GwAu3_Memory_Read($l_p_Ptr + 0x18, "ptr")
            Return GwAu3_Memory_Read($l_p_TextParserPtr + 0x1d0, "dword")

        Case "SomeNumber"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x20, "dword")
        Case "AccountContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x28, "ptr")
        Case "WorldContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x2C, "ptr")

        Case "Cinematic"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x30, "ptr")
        Case "IsCinematic"
            Local $l_p_CinematicPtr = GwAu3_Memory_Read($l_p_Ptr + 0x30, "ptr")
            If GwAu3_Memory_Read($l_p_CinematicPtr) <> 0 Or GwAu3_Memory_Read($l_p_CinematicPtr + 0x4) <> 0 Then Return True
            Return False

        Case "GadgetContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x38, "ptr")
        Case "GuildContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x3C, "ptr")
        Case "ItemContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x40, "ptr")
        Case "CharContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x44, "ptr")
        Case "PartyContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x4C, "ptr")
        Case "TradeContext"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x58, "ptr")
    EndSwitch

    Return 0
EndFunc
#EndRegion Game Context Related

#Region World Context
Func GwAu3_OtherMod_GetWorldContextPtr()
    Local $l_ai_Offset[3] = [0, 0x18, 0x2C]
    Local $l_ap_WorldContextPtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Return $l_ap_WorldContextPtr[1]
EndFunc

Func GwAu3_OtherMod_GetWorldInfo($a_s_Info = "")
    Local $l_p_Ptr = GwAu3_OtherMod_GetWorldContextPtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AccountInfo"
            Return GwAu3_Memory_Read($l_p_Ptr, "ptr")
        Case "MessageBuffArray" ;--> To check <Useless ??>
            Return GwAu3_Memory_Read($l_p_Ptr + 0x4, "ptr")
        Case "DialogBuffArray" ;--> To check <Useless ??>
            Return GwAu3_Memory_Read($l_p_Ptr + 0x14, "ptr")
        Case "MerchItemArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x24, "ptr")
        Case "MerchItemArraySize" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x24 + 0x4, "dword")
        Case "MerchItemArray2" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x34, "ptr")
        Case "MerchItemArray2Size" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x34 + 0x4, "dword")
        Case "PartyAllyArray" ;--> To check <Useless ??>
            Return GwAu3_Memory_Read($l_p_Ptr + 0x8C, "ptr")
        Case "FlagAll"
            Local $l_af_Flags[3] = [GwAu3_Memory_Read($l_p_Ptr + 0x9C, "float"), _
                                    GwAu3_Memory_Read($l_p_Ptr + 0xA0, "float"), _
                                    GwAu3_Memory_Read($l_p_Ptr + 0xA4, "float")]
            Return $l_af_Flags
        Case "ActiveQuestID"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x528, "dword")
        Case "PlayerNumber"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x67C, "dword")
        Case "MyID"
            Local $l_i_ID = GwAu3_Memory_Read($l_p_Ptr + 0x680, "dword")
            Return GwAu3_Memory_Read($l_i_ID + 0x14, "dword")
        Case "IsHmUnlocked"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x684, "dword")
        Case "SalvageSessionID"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x690, "dword")
        Case "PlayerTeamToken"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x6A8, "dword")
        Case "Experience"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x740, "dword")
        Case "CurrentKurzick"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x748, "dword")
        Case "TotalEarnedKurzick"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x750, "dword")
        Case "CurrentLuxon"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x758, "dword")
        Case "TotalEarnedLuxon"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x760, "dword")
        Case "CurrentImperial"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x768, "dword")
        Case "TotalEarnedImperial"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x770, "dword")
        Case "Level"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x788, "dword")
        Case "Morale"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x790, "dword")
        Case "CurrentBalth"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x798, "dword")
        Case "TotalEarnedBalth"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7A0, "dword")
        Case "CurrentSkillPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7A8, "dword")
        Case "TotalEarnedSkillPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7B0, "dword")
        Case "MaxKurzickPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7B8, "dword")
        Case "MaxLuxonPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7BC, "dword")
        Case "MaxBalthPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7C0, "dword")
        Case "MaxImperialPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7C4, "dword")
        Case "EquipmentStatus"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7C8, "dword")
        Case "FoesKilled"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x84C, "dword")
        Case "FoesToKill"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x850, "dword")

        ;Map Agent Array <Useless ??>
        Case "MapAgentArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7C, "ptr")
        Case "MapAgentArraySize" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7C + 0x8, "long")

        ;Party Attribute Array
        Case "PartyAttributeArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0xAC, "ptr")
        Case "PartyAttributeArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0xAC + 0x8, "long")

        ;Agent Effect Array
        Case "AgentEffectsArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x508, "ptr")
        Case "AgentEffectsArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x508 + 0x8, "long")

        ;Quest Array
        Case "QuestLog"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x52C, "ptr")
        Case "QuestLogSize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x52C + 0x8, "long")

        ;Mission Objective <Useless ??>
        Case "MissionObjectiveArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x564, "ptr")
        Case "MissionObjectiveArraySize" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x564 + 0x8, "long")

        ;Hero Array
        Case "HeroFlagArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x584, "ptr")
        Case "HeroFlagArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x584 + 0x8, "long")
        Case "HeroInfoArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x594, "ptr")
        Case "HeroInfoArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x594 + 0x8, "long")

        ;Minion Array
        Case "ControlledMinionsArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x5BC, "ptr")
        Case "ControlledMinionsArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x5BC + 0x8, "long")

        ;Morale Array
        Case "PlayerMoraleInfo"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x624, "ptr")
        Case "PlayerMoraleInfoSize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x624 + 0x8, "long")
        Case "PartyMoraleInfo"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x62C, "ptr")
        Case "PartyMoraleInfoSize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x62C + 0x8, "long")

        ;Pet Array
        Case "PetInfoArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x6AC, "ptr")
        Case "PetInfoArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x6AC + 0x8, "long")

        ;Party Profession Array
        Case "PartyProfessionArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x6BC, "ptr")
        Case "PartyProfessionArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x6BC + 0x8, "long")

        ;Skill Array
        Case "SkillbarArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x6F0, "ptr")
        Case "SkillbarArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x6F0 + 0x8, "long")

        ;Agent Info Array (name only)
        Case "AgentInfoArray" ;--> To check (name_enc) <Useless for GwAu3>
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7CC, "ptr")
        Case "AgentInfoArraySize" ;--> To check (name_enc) <Useless for GwAu3>
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7CC + 0x8, "long")

        ;NPC Array
        Case "NPCArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7FC, "ptr")
        Case "NPCArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x7FC + 0x8, "long")

        ;Player Array
        Case "PlayerArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x80C, "ptr")
        Case "PlayerArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x80C + 0x8, "long")

        ;Title Array
        Case "TitleArray"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x81C, "ptr")
        Case "TitleArraySize"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x81C, "ptr")

        ;Special array
        Case "VanquishedAreasArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x83C, "ptr")
        Case "VanquishedAreasArraySize" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x83C + 0x8, "long")
        Case "MissionsCompletedArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x5CC, "ptr")
        Case "MissionsBonusArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x5DC, "ptr")
        Case "MissionsCompletedHMArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x5EC, "ptr")
        Case "MissionsBonusHMArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x5FC, "ptr")
        Case "LearnableSkillsArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x700, "ptr")
        Case "UnlockedSkillsArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x710, "ptr")
        Case "UnlockedMapArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x60C, "ptr")
        Case "HenchmanIDArray" ;--> To check
            Return GwAu3_Memory_Read($l_p_Ptr + 0x574, "ptr")
    EndSwitch

    Return 0
EndFunc
#EndRegion World Context

#Region Account Related
Func GwAu3_OtherMod_GetAccountInfo($a_s_Info = "")
    Local $l_p_Ptr = GwAu3_OtherMod_GetWorldInfo("AccountInfo")
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AccountName"
            Local $l_p_Name = GwAu3_Memory_Read($l_p_Ptr, "ptr")
            Return GwAu3_Memory_Read($l_p_Name, "wchar[32]")
        Case "Wins"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x4, "dword")
        Case "Losses"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x8, "dword")
        Case "Rating"
            Return GwAu3_Memory_Read($l_p_Ptr + 0xC, "dword")
        Case "QualifierPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x10, "dword")
        Case "Rank"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x14, "dword")
        Case "TournamentRewardPoints"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x18, "dword")
    EndSwitch

    Return 0
EndFunc
#EndRegion Account Related