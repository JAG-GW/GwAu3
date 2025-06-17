#include-once

#Region Quest Related
Func GwAu3_Quest_GetQuestInfo($a_i_QuestID, $a_s_Info = "")
    Local $l_p_Ptr
    Local $l_i_Size = GwAu3_World_GetWorldInfo("QuestLogSize")
    If $l_i_Size = 0 Or $a_s_Info = "" Then Return 0

    For $l_i_Idx = 0 To $l_i_Size
        Local $l_ai_OffsetQuestLog[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $l_i_Idx]
        Local $l_ap_QuestPtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_ai_OffsetQuestLog, "long")
        If $l_ap_QuestPtr[1] = $a_i_QuestID Then $l_p_Ptr = Ptr($l_ap_QuestPtr[0])
    Next

    Switch $a_s_Info
        Case "QuestID"
            Return GwAu3_Memory_Read($l_p_Ptr, "long")

        Case "LogState"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x4, "long")
        Case "IsCompleted"
            Switch GwAu3_Memory_Read($l_p_Ptr + 0x4, "long")
                Case 2, 3, 19, 32, 34, 35, 79
                    Return True
                Case Else
                    Return False
            EndSwitch
        Case "CanReward"
            Switch GwAu3_Memory_Read($l_p_Ptr + 0x4, "long")
                Case 32, 33
                    Return True
                Case Else
                    Return False
            EndSwitch
        Case "IsIncomplete"
            If GwAu3_Memory_Read($l_p_Ptr + 0x4, "long") = 1 Then Return True
            Return False
        Case "IsCurrentQuest"
            If GwAu3_Memory_Read($l_p_Ptr + 0x4, "long") = 0x10 Then Return True
            Return False
        Case "IsAreaPrimary"
            If GwAu3_Memory_Read($l_p_Ptr + 0x4, "long") = 0x40 Then Return True
            Return False
        Case "IsPrimary"
            If GwAu3_Memory_Read($l_p_Ptr + 0x4, "long") = 0x20 Then Return True
            Return False

        Case "Location"
            Local $l_p_LocationPtr = GwAu3_Memory_Read($l_p_Ptr + 0x8, "ptr")
            Return GwAu3_Memory_Read($l_p_LocationPtr, "wchar[256]")
        Case "Name"
            Local $l_p_NamePtr = GwAu3_Memory_Read($l_p_Ptr + 0xC, "ptr")
            Return GwAu3_Memory_Read($l_p_NamePtr, "wchar[256]")
        Case "NPC"
            Local $l_p_NPCPtr = GwAu3_Memory_Read($l_p_Ptr + 0x10, "ptr")
            Return GwAu3_Memory_Read($l_p_NPCPtr, "wchar[256]")
        Case "MapFrom"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x14, "dword")
        Case "MarkerX"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x18, "float")
        Case "MarkerY"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x1C, "float")
        Case "MarkerZ"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x20, "dword")
        Case "MapTo"
            Return GwAu3_Memory_Read($l_p_Ptr + 0x28, "dword")
        Case "Description"
            Local $l_p_DescriptionPtr = GwAu3_Memory_Read($l_p_Ptr + 0x2C, "ptr")
            Return GwAu3_Memory_Read($l_p_DescriptionPtr, "wchar[256]")
        Case "Objectives"
            Local $l_p_ObjectivesPtr = GwAu3_Memory_Read($l_p_Ptr + 0x30, "ptr")
            Return GwAu3_Memory_Read($l_p_ObjectivesPtr, "wchar[256]")
    EndSwitch

    Return 0
EndFunc
#EndRegion Quest Related
