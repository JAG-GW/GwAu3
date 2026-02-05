#include-once

#Region Quest Related
Func Quest_GetQuestInfo($a_i_QuestID, $a_s_Info = "")
    Local $l_p_Ptr = 0
    Local $l_i_Size = World_GetWorldInfo("QuestLogSize")
    If $l_i_Size = 0 Or $a_s_Info = "" Then Return 0

    For $l_i_Idx = 0 To $l_i_Size
        Local $l_ai_OffsetQuestLog[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $l_i_Idx]
        Local $l_ap_QuestPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_OffsetQuestLog, "long")
        If $l_ap_QuestPtr[1] = $a_i_QuestID Then $l_p_Ptr = Ptr($l_ap_QuestPtr[0])
    Next
    If $l_p_Ptr = 0 Then Return 0

    Switch $a_s_Info
        Case "QuestID"
            Return Memory_Read($l_p_Ptr, "long")

        Case "LogState"
            Return Memory_Read($l_p_Ptr + 0x4, "long")
        Case "IsCompleted"
            Switch Memory_Read($l_p_Ptr + 0x4, "long")
                Case 2, 3, 19, 32, 33, 34, 35, 79
                    Return True
                Case Else
                    Return False
            EndSwitch
        Case "CanReward"
            Switch Memory_Read($l_p_Ptr + 0x4, "long")
                Case 32, 33
                    Return True
                Case Else
                    Return False
            EndSwitch
        Case "IsIncomplete"
            If Memory_Read($l_p_Ptr + 0x4, "long") = 1 Then Return True
            Return False
        Case "IsCurrentQuest"
            If Memory_Read($l_p_Ptr + 0x4, "long") = 0x10 Then Return True
            Return False
        Case "IsAreaPrimary"
            If Memory_Read($l_p_Ptr + 0x4, "long") = 0x40 Then Return True
            Return False
        Case "IsPrimary"
            If Memory_Read($l_p_Ptr + 0x4, "long") = 0x20 Then Return True
            Return False

        Case "Location"
            Local $l_p_LocationPtr = Memory_Read($l_p_Ptr + 0x8, "ptr")
            Return Utils_DecodeEncString($l_p_LocationPtr)
        Case "LocationStr"
            Local $l_p_LocationPtr = Memory_Read($l_p_Ptr + 0x8, "ptr")
            Return Utils_DecodeEncStringAsync($l_p_LocationPtr)

        Case "NameEnc"
            Local $l_p_NamePtr = Memory_Read($l_p_Ptr + 0xC, "ptr")
            Return Utils_DecodeEncString($l_p_NamePtr)
        Case "Name"
            Local $l_p_NamePtr = Memory_Read($l_p_Ptr + 0xC, "ptr")
            Return Utils_DecodeEncStringAsync($l_p_NamePtr)

        Case "NPCNameEnc"
            Local $l_p_NPCPtr = Memory_Read($l_p_Ptr + 0x10, "ptr")
            Return Utils_DecodeEncString($l_p_NPCPtr)
        Case "NPCName"
            Local $l_p_NPCPtr = Memory_Read($l_p_Ptr + 0x10, "ptr")
            Return Utils_DecodeEncStringAsync($l_p_NPCPtr)

        Case "MapFrom"
            Return Memory_Read($l_p_Ptr + 0x14, "dword")
        Case "MarkerX"
            Return Memory_Read($l_p_Ptr + 0x18, "float")
        Case "MarkerY"
            Return Memory_Read($l_p_Ptr + 0x1C, "float")
        Case "MarkerZ"
            Return Memory_Read($l_p_Ptr + 0x20, "dword")
        Case "MapTo"
            Return Memory_Read($l_p_Ptr + 0x28, "dword")

        Case "DescriptionEnc"
            Local $l_p_DescriptionPtr = Memory_Read($l_p_Ptr + 0x2C, "ptr")
            Return Utils_DecodeEncString($l_p_DescriptionPtr)
        Case "Description"
            Local $l_p_DescriptionPtr = Memory_Read($l_p_Ptr + 0x2C, "ptr")
            Return Utils_DecodeEncStringAsync($l_p_DescriptionPtr)

        Case "ObjectivesEnc"
            Local $l_p_ObjectivesPtr = Memory_Read($l_p_Ptr + 0x30, "ptr")
            Return Utils_DecodeEncString($l_p_ObjectivesPtr)
        Case "Objectives"
            Local $l_p_ObjectivesPtr = Memory_Read($l_p_Ptr + 0x30, "ptr")
            Return Utils_DecodeEncStringAsync($l_p_ObjectivesPtr)
    EndSwitch

    Return 0
EndFunc
#EndRegion Quest Related

#Region Mission Objectives
; Returns the number of mission objectives
Func Mission_GetObjectiveCount()
    Return World_GetWorldInfo("MissionObjectiveArraySize")
EndFunc

; Returns info about a mission objective by index
; @param $a_i_Index - 0-based index in the objective array
; @param $a_s_Info - Info to retrieve: "ObjectiveID", "Type", "TextEnc", "Text"
Func Mission_GetObjectiveInfo($a_i_Index, $a_s_Info = "")
    Local $l_p_Array = World_GetWorldInfo("MissionObjectiveArray")
    Local $l_i_Size = World_GetWorldInfo("MissionObjectiveArraySize")

    If $l_p_Array = 0 Or $a_i_Index >= $l_i_Size Or $a_s_Info = "" Then Return 0

    ; MissionObjective struct size = 0xC
    Local $l_p_Entry = $l_p_Array + ($a_i_Index * 0xC)

    Switch $a_s_Info
        Case "ObjectiveID"
            Return Memory_Read($l_p_Entry, "dword")
        Case "State"
            Return Memory_Read($l_p_Entry + 0x8, "dword")
        Case "TextEnc"
            Local $l_p_TextPtr = Memory_Read($l_p_Entry + 0x4, "ptr")
            Return Utils_DecodeEncString($l_p_TextPtr)
        Case "Text"
            Local $l_p_TextPtr = Memory_Read($l_p_Entry + 0x4, "ptr")
            Return Utils_DecodeEncStringAsync($l_p_TextPtr)
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion Mission Objectives