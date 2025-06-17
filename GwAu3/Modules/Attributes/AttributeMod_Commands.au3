#include-once

Func GwAu3_AttributeMod_IncreaseAttribute($iAttributeID, $iAmount = 1, $aHeroNumber = 0)
    If $iAttributeID < 0 Or $iAttributeID > 44 Then
        GwAu3_Log_Error("Invalid attribute ID: " & $iAttributeID, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    If $iAmount < 0 Or $iAmount > 12 Then
        GwAu3_Log_Error("Invalid amount: " & $iAmount, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    ; Increase attribute one point at a time (Guild Wars limitation)
    For $i = 1 To $iAmount
		DllStructSetData($g_d_IncreaseAttribute, 1, GwAu3_Memory_GetValue('CommandIncreaseAttribute'))
        DllStructSetData($g_d_IncreaseAttribute, 2, $iAttributeID)
		If $aHeroNumber <> 0 Then
			DllStructSetData($g_d_IncreaseAttribute, 3, GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID"))
		Else
			DllStructSetData($g_d_IncreaseAttribute, 3, GwAu3_OtherMod_GetWorldInfo("MyID"))
		EndIf
        GwAu3_Core_Enqueue($g_p_IncreaseAttribute, 12)

        ; Small delay between increases to avoid issues
        If $i < $iAmount Then Sleep(32)
    Next

    ; Record for tracking
    $g_i_LastAttributeModified = $iAttributeID
    $g_i_LastAttributeValue = $iAmount

    Local $attrName = ($iAttributeID < 45) ? $g_aAttributeNames[$iAttributeID] : "Unknown"
    GwAu3_Log_Debug("Increased attribute " & $attrName & " (" & $iAttributeID & ") by " & $iAmount, "AttributeMgr", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_AttributeMod_DecreaseAttribute($iAttributeID, $iAmount = 1, $aHeroNumber = 0)
    If $iAttributeID < 0 Or $iAttributeID > 44 Then
        GwAu3_Log_Error("Invalid attribute ID: " & $iAttributeID, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    If $iAmount < 1 Or $iAmount > 12 Then
        GwAu3_Log_Error("Invalid amount: " & $iAmount, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    ; Decrease attribute one point at a time (Guild Wars limitation)
    For $i = 1 To $iAmount
		DllStructSetData($g_d_DecreaseAttribute, 1, GwAu3_Memory_GetValue('CommandDecreaseAttribute'))
        DllStructSetData($g_d_DecreaseAttribute, 2, $iAttributeID)
        If $aHeroNumber <> 0 Then
			DllStructSetData($g_d_DecreaseAttribute, 3, GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID"))
		Else
			DllStructSetData($g_d_DecreaseAttribute, 3, GwAu3_OtherMod_GetWorldInfo("MyID"))
		EndIf
        GwAu3_Core_Enqueue($g_p_DecreaseAttribute, 12)

        ; Small delay between decreases to avoid issues
        If $i < $iAmount Then Sleep(32)
    Next

    ; Record for tracking
    $g_i_LastAttributeModified = $iAttributeID
    $g_i_LastAttributeValue = -$iAmount

    Local $attrName = ($iAttributeID < 45) ? $g_aAttributeNames[$iAttributeID] : "Unknown"
    GwAu3_Log_Debug("Decreased attribute " & $attrName & " (" & $iAttributeID & ") by " & $iAmount, "AttributeMgr", $g_h_EditText)
    Return True
EndFunc

Func LoadSkillTemplate($aTemplate, $aHeroNumber = 0)
    Local $lHeroID
    If $aHeroNumber <> 0 Then
        $lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
        If $lHeroID = 0 Then
            GwAu3_Log_Error("Invalid hero number: " & $aHeroNumber, "LoadTemplate", $g_h_EditText)
            Return False
        EndIf
    Else
        $lHeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
    EndIf

    ; Split template into individual characters
    Local $lSplitTemplate = StringSplit($aTemplate, '')
    If @error Or $lSplitTemplate[0] = 0 Then
        GwAu3_Log_Error("Invalid template format", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    ; Template structure variables
    Local $lTemplateType        ; 4 Bits
    Local $lVersionNumber       ; 4 Bits
    Local $lProfBits           ; 2 Bits -> P
    Local $lProfPrimary        ; P Bits
    Local $lProfSecondary      ; P Bits
    Local $lAttributesCount    ; 4 Bits
    Local $lAttributesBits     ; 4 Bits -> A
    Local $lAttributes[1][2]   ; A Bits + 4 Bits (for each Attribute)
    Local $lSkillsBits         ; 4 Bits -> S
    Local $lSkills[8]          ; S Bits * 8
    Local $lOpTail             ; 1 Bit

    ; Convert Base64 to binary
    $aTemplate = ''
    For $i = 1 To $lSplitTemplate[0]
        $aTemplate &= GwAu3_Utils_Base64ToBin64($lSplitTemplate[$i])
    Next

    ; Parse template header
    $lTemplateType = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, 4))
    $aTemplate = StringTrimLeft($aTemplate, 4)
    If $lTemplateType <> 14 Then
        GwAu3_Log_Error("Invalid template type: " & $lTemplateType & " (expected 14)", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    $lVersionNumber = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, 4))
    $aTemplate = StringTrimLeft($aTemplate, 4)

    ; Parse profession data
    $lProfBits = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, 2)) * 2 + 4
    $aTemplate = StringTrimLeft($aTemplate, 2)

    $lProfPrimary = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, $lProfBits))
    $aTemplate = StringTrimLeft($aTemplate, $lProfBits)

    ; Validate primary profession
    If $lProfPrimary <> GwAu3_PartyMod_GetPartyProfessionInfo($lHeroID, "Primary") Then
        GwAu3_Log_Error("Primary profession mismatch. Template: " & $lProfPrimary & ", Character: " & GwAu3_PartyMod_GetPartyProfessionInfo($lHeroID, "Primary"), "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    $lProfSecondary = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, $lProfBits))
    $aTemplate = StringTrimLeft($aTemplate, $lProfBits)

    ; Parse attributes
    $lAttributesCount = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, 4))
    $aTemplate = StringTrimLeft($aTemplate, 4)

    $lAttributesBits = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, 4)) + 4
    $aTemplate = StringTrimLeft($aTemplate, 4)

    ; Initialize attributes array
    Local $lPrimaryAttribute = _AttributeMod_GetProfPrimaryAttribute($lProfPrimary)
    $lAttributes[0][0] = $lPrimaryAttribute  ; Store primary attribute ID
    $lAttributes[0][1] = 0                   ; Will be set later

    ; Parse attribute data
    Local $lAttributeIndex = 1
    For $i = 1 To $lAttributesCount
        Local $lAttrID = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, $lAttributesBits))
        $aTemplate = StringTrimLeft($aTemplate, $lAttributesBits)
        Local $lAttrLevel = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, 4))
        $aTemplate = StringTrimLeft($aTemplate, 4)

        If $lAttrID = $lPrimaryAttribute Then
            $lAttributes[0][1] = $lAttrLevel
        Else
            ReDim $lAttributes[$lAttributeIndex + 1][2]
            $lAttributes[$lAttributeIndex][0] = $lAttrID
            $lAttributes[$lAttributeIndex][1] = $lAttrLevel
            $lAttributeIndex += 1
        EndIf
    Next

    ; Parse skills
    $lSkillsBits = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, 4)) + 8
    $aTemplate = StringTrimLeft($aTemplate, 4)

    For $i = 0 To 7
        $lSkills[$i] = GwAu3_Utils_Bin64ToDec(StringLeft($aTemplate, $lSkillsBits))
        $aTemplate = StringTrimLeft($aTemplate, $lSkillsBits)
    Next

    $lOpTail = GwAu3_Utils_Bin64ToDec($aTemplate)

    ; Apply the template
    GwAu3_Log_Info("Loading template - Primary: " & $lProfPrimary & ", Secondary: " & $lProfSecondary, "LoadTemplate", $g_h_EditText)

    ; Load attributes (includes secondary profession change if needed)
    If Not LoadAttributes($lAttributes, $lProfSecondary, $aHeroNumber) Then
        GwAu3_Log_Error("Failed to load attributes", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    ; Load skill bar
    LoadSkillBar($lSkills[0], $lSkills[1], $lSkills[2], $lSkills[3], $lSkills[4], $lSkills[5], $lSkills[6], $lSkills[7], $aHeroNumber)

    GwAu3_Log_Info("Template loaded successfully", "LoadTemplate", $g_h_EditText)
    Return True
EndFunc

Func LoadAttributes($aAttributesArray, $aSecondaryProfession, $aHeroNumber = 0)
    Local $lHeroID
    If $aHeroNumber <> 0 Then
        $lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
        If $lHeroID = 0 Then
            GwAu3_Log_Error("Invalid hero number: " & $aHeroNumber, "LoadAttributes", $g_h_EditText)
            Return False
        EndIf
    Else
        $lHeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
    EndIf

    Local $lPrimaryAttribute = $aAttributesArray[0][0]
    Local $lDeadlock = 0
    Local $lLevel = 0
    Local $lTestTimer = 0
    Local $lMaxRetries = 10
    Local $lTimeout = 5000

    GwAu3_Log_Info("Loading attributes for " & ($aHeroNumber = 0 ? "player" : "hero " & $aHeroNumber), "LoadAttributes", $g_h_EditText)

    ; Change secondary profession if needed
    If $aSecondaryProfession <> 0 And _
       GwAu3_PartyMod_GetPartyProfessionInfo($lHeroID, "Secondary") <> $aSecondaryProfession And _
       GwAu3_PartyMod_GetPartyProfessionInfo($lHeroID, "Primary") <> $aSecondaryProfession Then

        GwAu3_Log_Info("Changing secondary profession to: " & $aSecondaryProfession, "LoadAttributes", $g_h_EditText)

        Local $lRetryCount = 0
        Do
            $lDeadlock = TimerInit()
            ChangeSecondProfession($aSecondaryProfession, $aHeroNumber)

            Do
                Sleep(32)
            Until GwAu3_PartyMod_GetPartyProfessionInfo($lHeroID, "Secondary") = $aSecondaryProfession Or TimerDiff($lDeadlock) > $lTimeout

            $lRetryCount += 1
        Until GwAu3_PartyMod_GetPartyProfessionInfo($lHeroID, "Secondary") = $aSecondaryProfession Or $lRetryCount >= $lMaxRetries

        If GwAu3_PartyMod_GetPartyProfessionInfo($lHeroID, "Secondary") <> $aSecondaryProfession Then
            GwAu3_Log_Error("Failed to change secondary profession after " & $lMaxRetries & " attempts", "LoadAttributes", $g_h_EditText)
            Return False
        EndIf

        GwAu3_Log_Info("Secondary profession changed successfully", "LoadAttributes", $g_h_EditText)
    EndIf

    ; Validate and clamp attribute levels
    For $i = 0 To UBound($aAttributesArray) - 1
        If $aAttributesArray[$i][1] > 12 Then $aAttributesArray[$i][1] = 12
        If $aAttributesArray[$i][1] < 0 Then $aAttributesArray[$i][1] = 0
    Next

    ; Phase 1: Decrease primary attribute to target level
    GwAu3_Log_Debug("Phase 1: Adjusting primary attribute (" & $lPrimaryAttribute & ") to level " & $aAttributesArray[0][1], "LoadAttributes", $g_h_EditText)

    While _AttributeMod_GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $aAttributesArray[0][1]
        $lLevel = _AttributeMod_GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
        $lDeadlock = TimerInit()

        If Not _AttributeMod_DecreaseAttribute($lPrimaryAttribute, 1, $aHeroNumber) Then
            GwAu3_Log_Error("Failed to decrease primary attribute", "LoadAttributes", $g_h_EditText)
            Return False
        EndIf

        Do
            Sleep(32)
        Until _AttributeMod_GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > $lTimeout

        If TimerDiff($lDeadlock) > $lTimeout Then
            GwAu3_Log_Warning("Timeout decreasing primary attribute", "LoadAttributes", $g_h_EditText)
            ExitLoop
        EndIf
    WEnd

    ; Phase 2: Decrease secondary attributes to target levels
    GwAu3_Log_Debug("Phase 2: Adjusting secondary attributes", "LoadAttributes", $g_h_EditText)

    For $i = 1 To UBound($aAttributesArray) - 1
        Local $lAttrID = $aAttributesArray[$i][0]
        Local $lTargetLevel = $aAttributesArray[$i][1]

        While _AttributeMod_GetPartyAttributeInfo($lAttrID, $aHeroNumber, "BaseLevel") > $lTargetLevel
            $lLevel = _AttributeMod_GetPartyAttributeInfo($lAttrID, $aHeroNumber, "BaseLevel")
            $lDeadlock = TimerInit()

            If Not _AttributeMod_DecreaseAttribute($lAttrID, 1, $aHeroNumber) Then
                GwAu3_Log_Warning("Failed to decrease attribute " & $lAttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf

            Do
                Sleep(32)
            Until _AttributeMod_GetPartyAttributeInfo($lAttrID, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > $lTimeout

            If TimerDiff($lDeadlock) > $lTimeout Then
                GwAu3_Log_Warning("Timeout decreasing attribute " & $lAttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf
        WEnd
    Next

    ; Phase 3: Reset all other attributes to 0
    GwAu3_Log_Debug("Phase 3: Resetting unused attributes", "LoadAttributes", $g_h_EditText)

    For $i = 0 To 44
        If _AttributeMod_GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0 Then
            ; Skip primary attribute
            If $i = $lPrimaryAttribute Then ContinueLoop

            ; Skip attributes that are in our target list
            Local $bSkipAttribute = False
            For $j = 1 To UBound($aAttributesArray) - 1
                If $i = $aAttributesArray[$j][0] Then
                    $bSkipAttribute = True
                    ExitLoop
                EndIf
            Next
            If $bSkipAttribute Then ContinueLoop

            ; Reset this attribute to 0
            While _AttributeMod_GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel") > 0
                $lLevel = _AttributeMod_GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel")
                $lDeadlock = TimerInit()

                If Not _AttributeMod_DecreaseAttribute($i, 1, $aHeroNumber) Then
                    GwAu3_Log_Warning("Failed to reset attribute " & $i, "LoadAttributes", $g_h_EditText)
                    ExitLoop
                EndIf

                Do
                    Sleep(32)
                Until _AttributeMod_GetPartyAttributeInfo($i, $aHeroNumber, "BaseLevel") < $lLevel Or TimerDiff($lDeadlock) > $lTimeout

                If TimerDiff($lDeadlock) > $lTimeout Then
                    GwAu3_Log_Warning("Timeout resetting attribute " & $i, "LoadAttributes", $g_h_EditText)
                    ExitLoop
                EndIf
            WEnd
        EndIf
    Next

    ; Phase 4: Increase primary attribute to target level
    GwAu3_Log_Debug("Phase 4: Setting primary attribute to target level", "LoadAttributes", $g_h_EditText)

    $lTestTimer = 0
    While _AttributeMod_GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") < $aAttributesArray[0][1]
        $lLevel = _AttributeMod_GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel")
        $lDeadlock = TimerInit()

        If Not _AttributeMod_IncreaseAttribute($lPrimaryAttribute, 1, $aHeroNumber) Then
            GwAu3_Log_Error("Failed to increase primary attribute", "LoadAttributes", $g_h_EditText)
            ExitLoop
        EndIf

        Do
            Sleep(32)
            $lTestTimer += 1
        Until _AttributeMod_GetPartyAttributeInfo($lPrimaryAttribute, $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > $lTimeout

        If TimerDiff($lDeadlock) > $lTimeout Or $lTestTimer > 225 Then
            GwAu3_Log_Warning("Timeout or max attempts reached for primary attribute", "LoadAttributes", $g_h_EditText)
            ExitLoop
        EndIf
    WEnd

    ; Phase 5: Increase secondary attributes to target levels
    GwAu3_Log_Debug("Phase 5: Setting secondary attributes to target levels", "LoadAttributes", $g_h_EditText)

    For $i = 1 To UBound($aAttributesArray) - 1
        Local $lAttrID = $aAttributesArray[$i][0]
        Local $lTargetLevel = $aAttributesArray[$i][1]

        $lTestTimer = 0
        While _AttributeMod_GetPartyAttributeInfo($lAttrID, $aHeroNumber, "BaseLevel") < $lTargetLevel
            $lLevel = _AttributeMod_GetPartyAttributeInfo($lAttrID, $aHeroNumber, "BaseLevel")
            $lDeadlock = TimerInit()

            If Not _AttributeMod_IncreaseAttribute($lAttrID, 1, $aHeroNumber) Then
                GwAu3_Log_Warning("Failed to increase attribute " & $lAttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf

            Do
                Sleep(32)
                $lTestTimer += 1
            Until _AttributeMod_GetPartyAttributeInfo($lAttrID, $aHeroNumber, "BaseLevel") > $lLevel Or TimerDiff($lDeadlock) > $lTimeout

            If TimerDiff($lDeadlock) > $lTimeout Or $lTestTimer > 225 Then
                GwAu3_Log_Warning("Timeout or max attempts reached for attribute " & $lAttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf
        WEnd
    Next

    GwAu3_Log_Info("Attribute loading completed", "LoadAttributes", $g_h_EditText)
    Return True
EndFunc
