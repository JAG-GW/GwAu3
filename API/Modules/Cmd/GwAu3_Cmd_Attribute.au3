#include-once

Func Attribute_IncreaseAttribute($a_i_AttributeID, $a_i_Amount = 1, $a_i_HeroNumber = 0)
    If $a_i_AttributeID < 0 Or $a_i_AttributeID > 44 Then
        Log_Error("Invalid attribute ID: " & $a_i_AttributeID, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Amount < 0 Or $a_i_Amount > 12 Then
        Log_Error("Invalid amount: " & $a_i_Amount, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    ; Increase attribute one point at a time (Guild Wars limitation)
    For $l_i_Idx = 1 To $a_i_Amount
        DllStructSetData($g_d_IncreaseAttribute, 2, $a_i_AttributeID)
        If $a_i_HeroNumber <> 0 Then
            DllStructSetData($g_d_IncreaseAttribute, 3, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
        Else
            DllStructSetData($g_d_IncreaseAttribute, 3, World_GetWorldInfo("MyID"))
        EndIf
        Core_Enqueue($g_p_IncreaseAttribute, 12)

        ; Small delay between increases to avoid issues
        If $l_i_Idx < $a_i_Amount Then Sleep(32)
    Next

    ; Record for tracking
    $g_i_LastAttributeModified = $a_i_AttributeID
    $g_i_LastAttributeValue = $a_i_Amount

    Local $l_s_AttrName = ($a_i_AttributeID < 45) ? $GC_AS_ATTRIBUTE_NAMES[$a_i_AttributeID] : "Unknown"
    Return True
EndFunc

Func Attribute_DecreaseAttribute($a_i_AttributeID, $a_i_Amount = 1, $a_i_HeroNumber = 0)
    If $a_i_AttributeID < 0 Or $a_i_AttributeID > 44 Then
        Log_Error("Invalid attribute ID: " & $a_i_AttributeID, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    If $a_i_Amount < 1 Or $a_i_Amount > 12 Then
        Log_Error("Invalid amount: " & $a_i_Amount, "AttributeMgr", $g_h_EditText)
        Return False
    EndIf

    ; Decrease attribute one point at a time (Guild Wars limitation)
    For $l_i_Idx = 1 To $a_i_Amount
        DllStructSetData($g_d_DecreaseAttribute, 2, $a_i_AttributeID)
        If $a_i_HeroNumber <> 0 Then
            DllStructSetData($g_d_DecreaseAttribute, 3, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
        Else
            DllStructSetData($g_d_DecreaseAttribute, 3, World_GetWorldInfo("MyID"))
        EndIf
        Core_Enqueue($g_p_DecreaseAttribute, 12)

        ; Small delay between decreases to avoid issues
        If $l_i_Idx < $a_i_Amount Then Sleep(32)
    Next

    ; Record for tracking
    $g_i_LastAttributeModified = $a_i_AttributeID
    $g_i_LastAttributeValue = -$a_i_Amount

    Local $l_s_AttrName = ($a_i_AttributeID < 45) ? $GC_AS_ATTRIBUTE_NAMES[$a_i_AttributeID] : "Unknown"
    Return True
EndFunc

Func Attribute_LoadSkillTemplate($a_s_Template, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
        If $l_i_HeroID = 0 Then
            Log_Error("Invalid hero number: " & $a_i_HeroNumber, "LoadTemplate", $g_h_EditText)
            Return False
        EndIf
    Else
        $l_i_HeroID = World_GetWorldInfo("MyID")
    EndIf

    ; Split template into individual characters
    Local $l_as_SplitTemplate = StringSplit($a_s_Template, '')
    If @error Or $l_as_SplitTemplate[0] = 0 Then
        Log_Error("Invalid template format", "LoadTemplate", $g_h_EditText)
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
        $a_s_Template &= Utils_Base64ToBin64($l_as_SplitTemplate[$l_i_Idx])
    Next

    ; Parse template header
    $l_i_TemplateType = Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
    $a_s_Template = StringTrimLeft($a_s_Template, 4)
    If $l_i_TemplateType <> 14 Then
        Log_Error("Invalid template type: " & $l_i_TemplateType & " (expected 14)", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    $l_i_VersionNumber = Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

    ; Parse profession data
    $l_i_ProfBits = Utils_Bin64ToDec(StringLeft($a_s_Template, 2)) * 2 + 4
    $a_s_Template = StringTrimLeft($a_s_Template, 2)

    $l_i_ProfPrimary = Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_ProfBits))
    $a_s_Template = StringTrimLeft($a_s_Template, $l_i_ProfBits)

    ; Validate primary profession
    If $l_i_ProfPrimary <> Party_GetPartyProfessionInfo($l_i_HeroID, "Primary") Then
        Log_Error("Primary profession mismatch. Template: " & $l_i_ProfPrimary & ", Character: " & Party_GetPartyProfessionInfo($l_i_HeroID, "Primary"), "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    $l_i_ProfSecondary = Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_ProfBits))
    $a_s_Template = StringTrimLeft($a_s_Template, $l_i_ProfBits)

    ; Parse attributes
    $l_i_AttributesCount = Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

    $l_i_AttributesBits = Utils_Bin64ToDec(StringLeft($a_s_Template, 4)) + 4
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

	; Initialize attributes array
	$l_ai2_Attributes[0][0] = $l_i_ProfPrimary ; Store primary profession
	$l_ai2_Attributes[0][1] = $l_i_ProfSecondary ; Store secondary profession
	ReDim $l_ai2_Attributes[$l_i_AttributesCount + 1][2]

	For $i = 1 To $l_i_AttributesCount
		$l_ai2_Attributes[$i][0] = Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_AttributesBits))
		$a_s_Template = StringTrimLeft($a_s_Template, $l_i_AttributesBits)
		$l_ai2_Attributes[$i][1] = Utils_Bin64ToDec(StringLeft($a_s_Template, 4))
		$a_s_Template = StringTrimLeft($a_s_Template, 4)
	Next

    ; Parse skills
    $l_i_SkillsBits = Utils_Bin64ToDec(StringLeft($a_s_Template, 4)) + 8
    $a_s_Template = StringTrimLeft($a_s_Template, 4)

    For $l_i_Idx = 0 To 7
        $l_ai_Skills[$l_i_Idx] = Utils_Bin64ToDec(StringLeft($a_s_Template, $l_i_SkillsBits))
        $a_s_Template = StringTrimLeft($a_s_Template, $l_i_SkillsBits)
    Next

    $l_i_OpTail = Utils_Bin64ToDec($a_s_Template)

    ; Load attributes (includes secondary profession change if needed)
    If Not Attribute_LoadAttributes($l_ai2_Attributes, $a_i_HeroNumber) Then
        Log_Error("Failed to load attributes", "LoadTemplate", $g_h_EditText)
        Return False
    EndIf

    ; Load skill bar
    Skill_LoadSkillBar($l_ai_Skills[0], $l_ai_Skills[1], $l_ai_Skills[2], $l_ai_Skills[3], $l_ai_Skills[4], $l_ai_Skills[5], $l_ai_Skills[6], $l_ai_Skills[7], $a_i_HeroNumber)

    Return True
EndFunc

Func Attribute_LoadAttributes($a_ai2_AttributesArray, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
        If $l_i_HeroID = 0 Then
            Log_Error("Invalid hero number: " & $a_i_HeroNumber, "LoadAttributes", $g_h_EditText)
            Return False
        EndIf
    Else
        $l_i_HeroID = World_GetWorldInfo("MyID")
    EndIf
  
	Local $l_i_ProfPrimary = $a_ai2_AttributesArray[0][0] ; Store primary profession ID
	Local $l_i_ProfSecondary = $a_ai2_AttributesArray[0][1] ; Store secondary profession ID

    Local $l_i_AttrCount = UBound($a_ai2_AttributesArray) - 1
    Local $l_i_AttrLevel = $GC_I_ATTRIBUTE_MIN_VALUE

    Local $l_h_Timeout = 0, $l_i_TimeoutThreshold = 5000
    Local $l_i_RetryCount = 0, $l_i_MaxRetries = 10
	
    ; Change secondary profession if needed
    If $l_i_ProfSecondary <> $GC_I_PROFESSION_NONE _ 
    And Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") <> $l_i_ProfSecondary _
    And Party_GetPartyProfessionInfo($l_i_HeroID, "Primary") <> $l_i_ProfSecondary Then
        Log_Info("Changing secondary profession to: " & $l_i_ProfSecondary, "LoadAttributes", $g_h_EditText)
        Do
            $l_h_Timeout = TimerInit()
            Attribute_ChangeSecondProfession($l_i_ProfSecondary, $a_i_HeroNumber)

            Do
                Sleep(32)
            Until Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") = $l_i_ProfSecondary Or TimerDiff($l_h_Timeout) > $l_i_TimeoutThreshold

            $l_i_RetryCount += 1
        Until Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") = $l_i_ProfSecondary Or $l_i_RetryCount >= $l_i_MaxRetries

        If Party_GetPartyProfessionInfo($l_i_HeroID, "Secondary") <> $l_i_ProfSecondary Then
            Log_Error("Failed to change secondary profession after " & $l_i_MaxRetries & " attempts", "LoadAttributes", $g_h_EditText)
            Return False
        EndIf
    EndIf

	; Check pre-existing Attributes
	Local $l_b_CorrectAttrLevels = True
	For $i = 1 To $l_i_AttrCount
		If Attribute_GetPartyAttributeInfo($a_ai2_AttributesArray[$i][0], $a_i_HeroNumber, "BaseLevel") <> $a_ai2_AttributesArray[$i][1] Then
			$l_b_CorrectAttrLevels = False
			ExitLoop
		EndIf
	Next

	If $l_b_CorrectAttrLevels Then Return True
	
    ; Validate and clamp attribute levels
    For $i = 1 To $l_i_AttrCount
        If $a_ai2_AttributesArray[$i][1] > $GC_I_ATTRIBUTE_MAX_VALUE Then $a_ai2_AttributesArray[$i][1] = $GC_I_ATTRIBUTE_MAX_VALUE
        If $a_ai2_AttributesArray[$i][1] < $GC_I_ATTRIBUTE_MIN_VALUE Then $a_ai2_AttributesArray[$i][1] = $GC_I_ATTRIBUTE_MIN_VALUE
    Next

	Local $l_i_TotalAttributePoints = Attribute_GetPartyAttributePointInfo($a_i_HeroNumber, "TotalPoints")
    If $l_i_TotalAttributePoints < $GC_I_ATTRIBUTE_MAX_ATTR_POINTS Then Attribute_CalculateAttributeSpread($a_ai2_AttributesArray, $l_i_TotalAttributePoints)

    Local $l_i_AttrID = $GC_I_ATTRIBUTE_NONE, $l_i_TargetAttrLevel = $GC_I_ATTRIBUTE_MIN_VALUE

    ; Decrease
    For $i = 0 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION, $UBOUND_ROWS) - 1
		If $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][0] <> $l_i_ProfPrimary _
		And $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][0] <> $l_i_ProfSecondary Then ContinueLoop

		For $j = 1 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION, $UBOUND_COLUMNS) - 1 
			Local $l_i_AttrID = $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][$j]
			If $l_i_AttrID == "" Then ExitLoop

            $l_i_TargetAttrLevel = $GC_I_ATTRIBUTE_MIN_VALUE
            For $k = 1 To $l_i_AttrCount
                If $l_i_AttrID = $a_ai2_AttributesArray[$k][0] Then
                    $l_i_TargetAttrLevel = $a_ai2_AttributesArray[$k][1]
                    ExitLoop
                EndIf
            Next

            While Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") > $l_i_TargetAttrLevel
                $l_i_AttrLevel = Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel")
                $l_h_Timeout = TimerInit()

                If Not Attribute_DecreaseAttribute($l_i_AttrID, 1, $a_i_HeroNumber) Then
                    Log_Warning("Failed to reset attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                    ExitLoop
                EndIf

                Do
                    Sleep(32)
                Until Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") < $l_i_AttrLevel Or TimerDiff($l_h_Timeout) > $l_i_TimeoutThreshold

                If TimerDiff($l_h_Timeout) > $l_i_TimeoutThreshold Then
                    Log_Warning("Timeout resetting attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                    ExitLoop
                EndIf
            WEnd

		Next
	Next

    ; Increase
    For $i = 1 To $l_i_AttrCount
        $l_i_AttrID = $a_ai2_AttributesArray[$i][0]
        $l_i_TargetAttrLevel = $a_ai2_AttributesArray[$i][1]

        While Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") < $l_i_TargetAttrLevel
            $l_i_AttrLevel = Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel")
            $l_h_Timeout = TimerInit()

            If Not Attribute_IncreaseAttribute($l_i_AttrID, 1, $a_i_HeroNumber) Then
                Log_Warning("Failed to increase attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf

            Do
                Sleep(32)
            Until Attribute_GetPartyAttributeInfo($l_i_AttrID, $a_i_HeroNumber, "BaseLevel") > $l_i_AttrLevel Or TimerDiff($l_h_Timeout) > $l_i_TimeoutThreshold

            If TimerDiff($l_h_Timeout) > $l_i_TimeoutThreshold Then
                Log_Warning("Timeout increasing attribute " & $l_i_AttrID, "LoadAttributes", $g_h_EditText)
                ExitLoop
            EndIf
        WEnd
    Next

    Return True
EndFunc

Func Attribute_CalculateAttributeSpread(ByRef $a_ai2_AttributeArray, $a_i_AttributePoints)
    Local Const $LC_AI2_ATTRIBUTE_COSTS[12] = [1, 2, 3, 4, 5, 6, 7, 9, 11, 13, 16, 20]

    Local $l_i_AttributeCount = UBound($a_ai2_AttributeArray, $UBOUND_ROWS) - 1
    If $l_i_AttributeCount <= 0 Or $a_i_AttributePoints <= 0 Then Return $a_i_AttributePoints

    Local $l_ai2_TargetLevels[$l_i_AttributeCount + 1]
    Local $l_i_MaxTargetLevel = $GC_I_ATTRIBUTE_MIN_VALUE

    For $i = 1 To $l_i_AttributeCount
        Local $l_i_TargetAttributeLevel = $a_ai2_AttributeArray[$i][1]
        $l_ai2_TargetLevels[$i] = $l_i_TargetAttributeLevel

        $a_ai2_AttributeArray[$i][1] = $GC_I_ATTRIBUTE_MIN_VALUE

        If $l_i_TargetAttributeLevel > $l_i_MaxTargetLevel Then $l_i_MaxTargetLevel = $l_i_TargetAttributeLevel
    Next

    If $l_i_MaxTargetLevel <= 0 Then Return $a_i_AttributePoints

    While $a_i_AttributePoints > 0
        Local $l_b_CanIncrease = False

        For $attributeLevel = $l_i_MaxTargetLevel To 1 Step -1
            For $j = 1 To $l_i_AttributeCount
                Local $l_i_TargetAttributeLevel = $l_ai2_TargetLevels[$j]
                If $l_i_TargetAttributeLevel < $attributeLevel Then ContinueLoop

                Local $l_i_CurrentAttributeLevel = $a_ai2_AttributeArray[$j][1]
                If $l_i_CurrentAttributeLevel >= $l_i_TargetAttributeLevel _
                Or $l_i_CurrentAttributeLevel >= $GC_I_ATTRIBUTE_MAX_VALUE Then ContinueLoop

                Local $l_i_AttributeCost = $LC_AI2_ATTRIBUTE_COSTS[$l_i_CurrentAttributeLevel]
                If $a_i_AttributePoints < $l_i_AttributeCost Then ContinueLoop

                $a_ai2_AttributeArray[$j][1] = $l_i_CurrentAttributeLevel + 1
                $a_i_AttributePoints -= $l_i_AttributeCost
                $l_b_CanIncrease = True

                If $a_i_AttributePoints = 0 Then ExitLoop 2
            Next
        Next

        If Not $l_b_CanIncrease Then ExitLoop
    WEnd

    Return $a_i_AttributePoints
EndFunc

;~ Description: Change your secondary profession.
Func Attribute_ChangeSecondProfession($a_i_Profession, $a_i_HeroNumber = 0)
    Local $l_i_HeroID
    If $a_i_HeroNumber <> 0 Then
        $l_i_HeroID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Else
        $l_i_HeroID = World_GetWorldInfo("MyID")
    EndIf
    Return Core_SendPacket(0xC, $GC_I_HEADER_PROFESSION_CHANGE, $l_i_HeroID, $a_i_Profession)
EndFunc   ;==>ChangeSecondProfession