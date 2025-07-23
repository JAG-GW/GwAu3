#include-once

#Region Quest Related
Func Quest_GetQuestInfo($a_i_QuestID, $a_s_Info = "")
    Local $l_p_Ptr
    Local $l_i_Size = World_GetWorldInfo("QuestLogSize")
    If $l_i_Size = 0 Or $a_s_Info = "" Then Return 0

    For $l_i_Idx = 0 To $l_i_Size
        Local $l_ai_OffsetQuestLog[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $l_i_Idx]
        Local $l_ap_QuestPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_OffsetQuestLog, "long")
        If $l_ap_QuestPtr[1] = $a_i_QuestID Then $l_p_Ptr = Ptr($l_ap_QuestPtr[0])
    Next

    Switch $a_s_Info
        Case "QuestID"
            Return Memory_Read($l_p_Ptr, "long")

        Case "LogState"
            Return Memory_Read($l_p_Ptr + 0x4, "long")
        Case "IsCompleted"
            Switch Memory_Read($l_p_Ptr + 0x4, "long")
                Case 2, 3, 19, 32, 34, 35, 79
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
            Return Memory_Read($l_p_LocationPtr, "wchar[256]")
        Case "Name"
            Local $l_p_NamePtr = Memory_Read($l_p_Ptr + 0xC, "ptr")
            Return Memory_Read($l_p_NamePtr, "wchar[256]")
        Case "NPC"
            Local $l_p_NPCPtr = Memory_Read($l_p_Ptr + 0x10, "ptr")
            Return Memory_Read($l_p_NPCPtr, "wchar[256]")
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
        Case "Description"
            Local $l_p_DescriptionPtr = Memory_Read($l_p_Ptr + 0x2C, "ptr")
            Return Memory_Read($l_p_DescriptionPtr, "wchar[256]")
        Case "Objectives"
            Local $l_p_ObjectivesPtr = Memory_Read($l_p_Ptr + 0x30, "ptr")
            Return Memory_Read($l_p_ObjectivesPtr, "wchar[256]")
    EndSwitch

    Return 0
EndFunc
#EndRegion Quest Related
