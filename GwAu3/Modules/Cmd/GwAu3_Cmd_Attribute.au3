#include-once

Func GwAu3_Attribute_IncreaseAttribute($a_i_AttributeID, $a_i_Amount = 1, $a_i_HeroNumber = 0)
    If $a_i_AttributeID < 0 Or $a_i_AttributeID > 44 Then
        GwAu3_Log_Error("Invalid attribute ID: " & $a_i_AttributeID, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Amount < 0 Or $a_i_Amount > 12 Then
        GwAu3_Log_Error("Invalid amount: " & $a_i_Amount, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    ; Increase attribute one point at a time (Guild Wars limitation)
    For $l_i_Idx = 1 To $a_i_Amount
        DllStructSetData($g_d_IncreaseAttribute, 2, $a_i_AttributeID)
        If $a_i_HeroNumber <> 0 Then
            DllStructSetData($g_d_IncreaseAttribute, 3, GwAu3_Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
        Else
            DllStructSetData($g_d_IncreaseAttribute, 3, GwAu3_World_GetWorldInfo("MyID"))
        EndIf
        GwAu3_Core_Enqueue($g_p_IncreaseAttribute, 12)

        ; Small delay between increases to avoid issues
        If $l_i_Idx < $a_i_Amount Then Sleep(32)
    Next

    ; Record for tracking
    $g_i_LastAttributeModified = $a_i_AttributeID
    $g_i_LastAttributeValue = $a_i_Amount

    Local $l_s_AttrName = ($a_i_AttributeID < 45) ? $g_as_AttributeNames[$a_i_AttributeID] : "Unknown"
    Return True
EndFunc

Func GwAu3_Attribute_DecreaseAttribute($a_i_AttributeID, $a_i_Amount = 1, $a_i_HeroNumber = 0)
    If $a_i_AttributeID < 0 Or $a_i_AttributeID > 44 Then
        GwAu3_Log_Error("Invalid attribute ID: " & $a_i_AttributeID, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Amount < 1 Or $a_i_Amount > 12 Then
        GwAu3_Log_Error("Invalid amount: " & $a_i_Amount, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    ; Decrease attribute one point at a time (Guild Wars limitation)
    For $l_i_Idx = 1 To $a_i_Amount
        DllStructSetData($g_d_DecreaseAttribute, 2, $a_i_AttributeID)
        If $a_i_HeroNumber <> 0 Then
            DllStructSetData($g_d_DecreaseAttribute, 3, GwAu3_Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
        Else
            DllStructSetData($g_d_DecreaseAttribute, 3, GwAu3_World_GetWorldInfo("MyID"))
        EndIf
        GwAu3_Core_Enqueue($g_p_DecreaseAttribute, 12)

        ; Small delay between decreases to avoid issues
        If $l_i_Idx < $a_i_Amount Then Sleep(32)
    Next

    ; Record for tracking
    $g_i_LastAttributeModified = $a_i_AttributeID
    $g_i_LastAttributeValue = -$a_i_Amount

    Local $l_s_AttrName = ($a_i_AttributeID < 45) ? $g_as_AttributeNames[$a_i_AttributeID] : "Unknown"
    Return True
EndFunc

Func GwAu3_Attribute_LoadSkillTemplate($a_s_Template, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = GwAu3_Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
        If $l_i_HeroID = 0 Then
            GwAu3_Log_Error("Invalid hero number: " & $a_i_HeroNumber, "LoadTemplate", $g_h_EditText)
            Return False
        EndIf
    Else
        $l_i_HeroID = GwAu3_World_GetWorldInfo("MyID")
    EndIf

    ; Split template into individual characters
    Local $l_as_SplitTemplate = StringSplit($a_s_Template, '')
    If @error Or $l_as_SplitTemplate[0] = 0 Then
        GwAu3_Log_Error("Invalid template format", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    ; Template structure variables
    Local $l_i_TemplateType        ; 4 Bits
    Local $l_i_VersionNumber       ; 4 Bits
    Local $l_i_ProfBits           ; 2 Bits -> P
    Local $l_i_ProfPrimary        ; P Bits
    Local $l_i_ProfSecondary      ; P Bits
    Local $l_i_AttributesCount    ; 4 Bits
    Local $l_i_AttributesBits     ; 4 Bits -> A
    Local $l_ai2_Attributes[1][2]   ; A Bits + 4 Bits (for each Attribute)
    Local $l_i_SkillsBits         ; 4 Bits -> S
    Local $l_ai_Skills[8]          ; S Bits * 8
    Local $l_i_OpTail             ; 1 Bit

    ; Convert Base64 to binary
    $a_s_Template = ''
    For $l_i_Idx = 1 To $l_as_SplitTemplate[0]
        $a_s_Template &= GwAu3_Utils_Base64ToBin64($l_as_SplitTemplate[$l_i_Idx])
    Next

    ; Parse template header
    $l_i_TemplateType = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
    $a_s_Template = StringTrimLeft($a_s_Template, 4)
    If $l_i_TemplateType <> 14 Then
        GwAu3_Log_Error("Invalid template type: " & $l_i_TemplateType & " (expected 14)", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    $l_i_VersionNumber = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

    ; Parse profession data
    $l_i_ProfBits = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, 2)) * 2 + 4
    $a_s_Template = StringTrimLeft($a_s_Template, 2)

    $l_i_ProfPrimary = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_ProfBits))
    $a_s_Template = StringTrimLeft($a_s_Template, $l_i_ProfBits)

    ; Validate primary profession
    If $l_i_ProfPrimary <> GwAu3_Party_GetPartyProfessionInfo($l_i_HeroID, "Primary") Then
        GwAu3_Log_Error("Primary profession mismatch. Template: " & $l_i_ProfPrimary & ", Character: " & GwAu3_Party_GetPartyProfessionInfo($l_i_HeroID, "Primary"), "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    $l_i_ProfSecondary = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_ProfBits))
    $a_s_Template = StringTrimLeft($a_s_Template, $l_i_ProfBits)

    ; Parse attributes
    $l_i_AttributesCount = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

    $l_i_AttributesBits = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, 4)) + 4
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

    ; Initialize attributes array
    Local $l_i_PrimaryAttribute = GwAu3_Attribute_GetProfPrimaryAttribute($l_i_ProfPrimary)
    $l_ai2_Attributes[0][0] = $l_i_PrimaryAttribute  ; Store primary attribute ID
    $l_ai2_Attributes[0][1] = 0                      ; Will be set later

    ; Parse attribute data
    Local $l_i_AttributeIndex = 1
    For $l_i_Idx = 1 To $l_i_AttributesCount
        Local $l_i_AttrID = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_AttributesBits))
        $a_s_Template = StringTrimLeft($a_s_Template, $l_i_AttributesBits)
        Local $l_i_AttrLevel = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
        $a_s_Template = StringTrimLeft($a_s_Template, 4)

        If $l_i_AttrID = $l_i_PrimaryAttribute Then
            $l_ai2_Attributes[0][1] = $l_i_AttrLevel
        Else
            ReDim $l_ai2_Attributes[$l_i_AttributeIndex + 1][2]
            $l_ai2_Attributes[$l_i_AttributeIndex][0] = $l_i_AttrID
            $l_ai2_Attributes[$l_i_AttributeIndex][1] = $l_i_AttrLevel
            $l_i_AttributeIndex += 1
        EndIf
    Next

    ; Parse skills
    $l_i_SkillsBits = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, 4)) + 8
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

    For $l_i_Idx = 0 To 7
        $l_ai_Skills[$l_i_Idx] = GwAu3_Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_SkillsBits))
        $a_s_Template = StringTrimLeft($a_s_Template, $l_i_SkillsBits)
    Next

    $l_i_OpTail = GwAu3_Utils_Bin64ToDec($a_s_Template)

    ; Load attributes (includes secondary profession change if needed)
    If Not GwAu3_Attribute_LoadAttributes($l_ai2_Attributes, $l_i_ProfSecondary, $a_i_HeroNumber) Then
        GwAu3_Log_Error("Failed to load attributes", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    ; Load skill bar
    GwAu3_Skill_LoadSkillBar($l_ai_Skills[0], $l_ai_Skills[1], $l_ai_Skills[2], $l_ai_Skills[3], $l_ai_Skills[4], $l_ai_Skills[5], $l_ai_Skills[6], $l_ai_Skills[7], $a_i_HeroNumber)

    Return True
EndFunc

Func GwAu3_Attribute_LoadAttributes($a_ai2_AttributesArray, $a_i_SecondaryProfession, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = GwAu3_Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
        If $l_i_HeroID = 0 Then
            GwAu3_Log_Error("Invalid hero number: " & $a_i_HeroNumber, "LoadAttributes", $g_h_EditText)
            Return False
        EndIf
    Else
        $l_i_HeroID = GwAu3_World_GetWorldInfo("MyID")
    EndIf

    Local $l_i_PrimaryAttribute = $a_ai2_AttributesArray[0][0]
    Local $l_i_Deadlock = 0
    Local $l_i_Level = 0
    Local $l_i_TestTimer = 0
    Local $l_i_MaxRetries = 10
    Local $l_i_Timeout = 5000

    ; Change secondary profession if needed
    If $a_i_SecondaryProfession <> 0 And _
       GwAu3_Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") <> $a_i_SecondaryProfession And _
       GwAu3_Party_GetPartyProfessionInfo($l_i_HeroID, "Primary") <> $a_i_SecondaryProfession Then

        GwAu3_Log_Info("Changing secondary profession to: " & $a_i_SecondaryProfession, "LoadAttributes", $g_h_EditText)

        Local $l_i_RetryCount = 0
        Do
            $l_i_Deadlock = TimerInit()
            GwAu3_Attribute_ChangeSecondProfession($a_i_SecondaryProfession, $a_i_HeroNumber)

            Do
                Sleep(32)
            Until GwAu3_Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") = $a_i_SecondaryProfession Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

            $l_i_RetryCount += 1
        Until GwAu3_Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") = $a_i_SecondaryProfession Or $l_i_RetryCount >= $l_i_MaxRetries

        If GwAu3_Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") <> $a_i_SecondaryProfession Then
            GwAu3_Log_Error("Failed to change secondary profession after " & $l_i_MaxRetries & " attempts", "LoadAttributes", $g_h_EditText)
            Return False
        EndIf
    EndIf

    ; Validate and clamp attribute levels
    For $l_i_Idx = 0 To UBound($a_ai2_AttributesArray) - 1
        If $a_ai2_AttributesArray[$l_i_Idx][1] > 12 Then $a_ai2_AttributesArray[$l_i_Idx][1] = 12
        If $a_ai2_AttributesArray[$l_i_Idx][1] < 0 Then $a_ai2_AttributesArray[$l_i_Idx][1] = 0
    Next

    While GwAu3_Attribute_GetPartyAttributeInfo($l_i_PrimaryAttribute, $a_i_HeroNumber, "BaseLevel") > $a_ai2_AttributesArray[0][1]
        $l_i_Level = GwAu3_Attribute_GetPartyAttributeInfo($l_i_PrimaryAttribute, $a_i_HeroNumber, "BaseLevel")
        $l_i_Deadlock = TimerInit()

        If Not GwAu3_Attribute_DecreaseAttribute($l_i_PrimaryAttribute, 1, $a_i_HeroNumber) Then
            GwAu3_Log_Error("Failed to decrease primary attribute", "LoadAttributes", $g_h_EditText)
            Return False
        EndIf

        Do
            Sleep(32)
        Until GwAu3_Attribute_GetPartyAttributeInfo($l_i_PrimaryAttribute, $a_i_HeroNumber, "BaseLevel") < $l_i_Level Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

        If TimerDiff($l_i_Deadlock) > $l_i_Timeout Then
            GwAu3_Log_Warning("Timeout decreasing primary attribute", "LoadAttributes", $g_h_EditText)
            ExitLoop
        EndIf
    WEnd

    ; Phase 2: Decrease secondary attributes to target levels
    GwAu3_Log_Debug("Phase 2: Adjusting secondary attributes", "LoadAttributes", $g_h_EditText)

    For $l_i_Idx = 1 To UBound($a_ai2_AttributesArray) - 1
        Local $l_i_AttrID = $a_ai2_AttributesArray[$l_i_Idx][0]
        Local $l_i_TargetLevel = $a_ai2_AttributesArray[$l_i_Idx][1]

        While GwAu3_Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") > $l_i_TargetLevel
            $l_i_Level = GwAu3_Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel")
            $l_i_Deadlock = TimerInit()

            If Not GwAu3_Attribute_DecreaseAttribute($l_i_AttrID, 1, $a_i_HeroNumber) Then
                GwAu3_Log_Warning("Failed to decrease attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf

            Do
                Sleep(32)
            Until GwAu3_Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") < $l_i_Level Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

            If TimerDiff($l_i_Deadlock) > $l_i_Timeout Then
                GwAu3_Log_Warning("Timeout decreasing attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf
        WEnd
    Next

    For $l_i_Idx = 0 To 44
        If GwAu3_Attribute_GetPartyAttributeInfo($l_i_Idx, $a_i_HeroNumber, "BaseLevel") > 0 Then
            ; Skip primary attribute
            If $l_i_Idx = $l_i_PrimaryAttribute Then ContinueLoop

            ; Skip attributes that are in our target list
            Local $l_b_SkipAttribute = False
            For $l_i_JIdx = 1 To UBound($a_ai2_AttributesArray) - 1
                If $l_i_Idx = $a_ai2_AttributesArray[$l_i_JIdx][0] Then
                    $l_b_SkipAttribute = True
                    ExitLoop
                EndIf
            Next
            If $l_b_SkipAttribute Then ContinueLoop

            ; Reset this attribute to 0
            While GwAu3_Attribute_GetPartyAttributeInfo($l_i_Idx, $a_i_HeroNumber, "BaseLevel") > 0
                $l_i_Level = GwAu3_Attribute_GetPartyAttributeInfo($l_i_Idx, $a_i_HeroNumber, "BaseLevel")
                $l_i_Deadlock = TimerInit()

                If Not GwAu3_Attribute_DecreaseAttribute($l_i_Idx, 1, $a_i_HeroNumber) Then
                    GwAu3_Log_Warning("Failed to reset attribute " & $l_i_Idx, "LoadAttributes", $g_h_EditText)
                    ExitLoop
                EndIf

                Do
                    Sleep(32)
                Until GwAu3_Attribute_GetPartyAttributeInfo($l_i_Idx, $a_i_HeroNumber, "BaseLevel") < $l_i_Level Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

                If TimerDiff($l_i_Deadlock) > $l_i_Timeout Then
                    GwAu3_Log_Warning("Timeout resetting attribute " & $l_i_Idx, "LoadAttributes", $g_h_EditText)
                    ExitLoop
                EndIf
            WEnd
        EndIf
    Next

    $l_i_TestTimer = 0
    While GwAu3_Attribute_GetPartyAttributeInfo($l_i_PrimaryAttribute, $a_i_HeroNumber, "BaseLevel") < $a_ai2_AttributesArray[0][1]
        $l_i_Level = GwAu3_Attribute_GetPartyAttributeInfo($l_i_PrimaryAttribute, $a_i_HeroNumber, "BaseLevel")
        $l_i_Deadlock = TimerInit()

        If Not GwAu3_Attribute_IncreaseAttribute($l_i_PrimaryAttribute, 1, $a_i_HeroNumber) Then
            GwAu3_Log_Error("Failed to increase primary attribute", "LoadAttributes", $g_h_EditText)
            ExitLoop
        EndIf

        Do
            Sleep(32)
            $l_i_TestTimer += 1
        Until GwAu3_Attribute_GetPartyAttributeInfo($l_i_PrimaryAttribute, $a_i_HeroNumber, "BaseLevel") > $l_i_Level Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

        If TimerDiff($l_i_Deadlock) > $l_i_Timeout Or $l_i_TestTimer > 225 Then
            GwAu3_Log_Warning("Timeout or max attempts reached for primary attribute", "LoadAttributes", $g_h_EditText)
            ExitLoop
        EndIf
    WEnd

    For $l_i_Idx = 1 To UBound($a_ai2_AttributesArray) - 1
        Local $l_i_AttrID = $a_ai2_AttributesArray[$l_i_Idx][0]
        Local $l_i_TargetLevel = $a_ai2_AttributesArray[$l_i_Idx][1]

        $l_i_TestTimer = 0
        While GwAu3_Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") < $l_i_TargetLevel
            $l_i_Level = GwAu3_Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel")
            $l_i_Deadlock = TimerInit()

            If Not GwAu3_Attribute_IncreaseAttribute($l_i_AttrID, 1, $a_i_HeroNumber) Then
                GwAu3_Log_Warning("Failed to increase attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf

            Do
                Sleep(32)
                $l_i_TestTimer += 1
            Until GwAu3_Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") > $l_i_Level Or TimerDiff($l_i_Deadlock) > $l_i_Timeout

            If TimerDiff($l_i_Deadlock) > $l_i_Timeout Or $l_i_TestTimer > 225 Then
                GwAu3_Log_Warning("Timeout or max attempts reached for attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf
        WEnd
    Next

    Return True
EndFunc

;~ Description: Change your secondary profession.
Func GwAu3_Attribute_ChangeSecondProfession($a_i_Profession, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = GwAu3_Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Else
        $l_i_HeroID = GwAu3_World_GetWorldInfo("MyID")
    EndIf
    Return GwAu3_Core_SendPacket(0xC, $GC_I_HEADER_PROFESSION_CHANGE, $l_i_HeroID, $a_i_Profession)
EndFunc   ;==>ChangeSecondProfession