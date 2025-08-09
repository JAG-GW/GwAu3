#include-once

Func Attribute_GetAttributeName($a_i_AttributeID)
    If $a_i_AttributeID >= 0 And $a_i_AttributeID < 45 Then
        Return $g_as_AttributeNames[$a_i_AttributeID]
    EndIf
    Return "Unknown"
EndFunc

Func Attribute_GetLastModified()
    Local $l_ai_Result[2] = [$g_i_LastAttributeModified, $g_i_LastAttributeValue]
    Return $l_ai_Result
EndFunc

Func Attribute_GetAttributePtr($a_i_AttributeID)
    Local $l_p_AttributeStructAddress = $g_p_AttributeInfo + (0x14 * $a_i_AttributeID)
    Return Ptr($l_p_AttributeStructAddress)
EndFunc

Func Attribute_GetAttributeInfo($a_i_AttributeID, $a_s_Info = "")
    Local $l_p_Ptr = Attribute_GetAttributePtr($a_i_AttributeID)
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "ProfessionID"
            Return Memory_Read($l_p_Ptr, "long")
        Case "AttributeID"
            Return Memory_Read($l_p_Ptr + 0x4, "long")
        Case "NameID"
            Return Memory_Read($l_p_Ptr + 0x8, "long")
        Case "DescID"
            Return Memory_Read($l_p_Ptr + 0xC, "long")
        Case "IsPVE"
            Return Memory_Read($l_p_Ptr + 0x10, "long")
    EndSwitch

    Return 0
EndFunc

Func Attribute_GetPartyAttributeInfo($a_i_AttributeID, $a_i_HeroNumber = 0, $a_s_Info = "")
    Local $l_i_AgentID
    If $a_i_HeroNumber <> 0 Then
        $l_i_AgentID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Else
        $l_i_AgentID = World_GetWorldInfo("MyID")
    EndIf
    Local $l_av_Buffer
    Local $l_ai_Offset[5]
    $l_ai_Offset[0] = 0
    $l_ai_Offset[1] = 0x18
    $l_ai_Offset[2] = 0x2C
    $l_ai_Offset[3] = 0xAC

    For $l_i_Idx = 0 To World_GetWorldInfo("PartyAttributeArraySize")
        $l_ai_Offset[4] = 0x43C * $l_i_Idx
        $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)

        If $l_av_Buffer[1] == $l_i_AgentID Then
            Local $l_i_BaseAttrOffset = 0x43C * $l_i_Idx + 0x14 * $a_i_AttributeID + 0x4

            Switch $a_s_Info
                Case "ID"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "BaseLevel", "LevelBase"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x4
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "Level", "CurrentLevel"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x8
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "DecrementPoints"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0xC
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "IncrementPoints"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x10
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1]
                Case "HasAttribute"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] <> 0
                Case "BonusLevel"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x4
                    Local $l_i_BaseLevel = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)[1]
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x8
                    Local $l_i_CurrentLevel = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)[1]
                    Return $l_i_CurrentLevel - $l_i_BaseLevel
                Case "IsMaxed"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x8
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] >= 12
                Case "IsRaisable"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0x10
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] > 0
                Case "IsDecreasable"
                    $l_ai_Offset[4] = $l_i_BaseAttrOffset + 0xC
                    $l_av_Buffer = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
                    Return $l_av_Buffer[1] > 0
                Case Else
                    Return 0
            EndSwitch
        EndIf
    Next
    Return 0
EndFunc

Func Attribute_GetProfPrimaryAttribute($a_i_Profession)
    Switch $a_i_Profession
        Case 1
            Return 17
        Case 2
            Return 23
        Case 3
            Return 16
        Case 4
            Return 6
        Case 5
            Return 0
        Case 6
            Return 12
        Case 7
            Return 35
        Case 8
            Return 36
        Case 9
            Return 40
        Case 10
            Return 44
    EndSwitch
EndFunc