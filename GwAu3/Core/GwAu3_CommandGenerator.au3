#include-once

#Region Command Generation System
; Supported command types
Global Enum $CMD_TYPE_SIMPLE_CALL = 0, $CMD_TYPE_STRUCT2_CALL = 1, $CMD_TYPE_STRUCT3_CALL = 2, $CMD_TYPE_STRUCT4_CALL = 3, $CMD_TYPE_CUSTOM = 4

; Structure to store command definitions
Global $g_aCommandDefinitions[0][5]

; Predefined assembler templates
Global $g_aASMTemplates[5]

; Configuration variables
Global $g_bGeneratorInitialized = False
#EndRegion Command Generation System

#Region Template Definitions

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_InitializeTemplates
; Description ...: Initializes all ASM templates for different command types
; Syntax.........: _CmdGen_InitializeTemplates()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Sets up templates for all command types (0-5)
;                  - Must be called before using the command generator
;                  - Templates use {FUNCTION} placeholder for function names
; Related .......: _CmdGen_Initialize
;============================================================================================
Func _CmdGen_InitializeTemplates()
    ; Template for simple function call (1 parameter)
    $g_aASMTemplates[$CMD_TYPE_SIMPLE_CALL] = _
        "mov ecx,dword[eax+4]" & @CRLF & _
        "push ecx" & @CRLF & _
        "call {FUNCTION}" & @CRLF & _
        "pop ecx"

    ; Template for commands with 2 parameters
    $g_aASMTemplates[$CMD_TYPE_STRUCT2_CALL] = _
        "mov ebx,dword[eax+8]" & @CRLF & _
        "push ebx" & @CRLF & _
        "mov ecx,dword[eax+4]" & @CRLF & _
        "push ecx" & @CRLF & _
        "call {FUNCTION}" & @CRLF & _
        "add esp,8"

    ; Template for commands with 3 parameters
    $g_aASMTemplates[$CMD_TYPE_STRUCT3_CALL] = _
        "mov ecx,dword[eax+C]" & @CRLF & _
        "push ecx" & @CRLF & _
        "mov ebx,dword[eax+8]" & @CRLF & _
        "push ebx" & @CRLF & _
        "mov edx,dword[eax+4]" & @CRLF & _
        "push edx" & @CRLF & _
        "call {FUNCTION}" & @CRLF & _
        "add esp,C"

    ; Template for commands with 4 parameters
    $g_aASMTemplates[$CMD_TYPE_STRUCT4_CALL] = _
        "mov ecx,dword[eax+10]" & @CRLF & _
        "push ecx" & @CRLF & _
        "mov ebx,dword[eax+C]" & @CRLF & _
        "push ebx" & @CRLF & _
        "mov edx,dword[eax+8]" & @CRLF & _
        "push edx" & @CRLF & _
        "mov ecx,dword[eax+4]" & @CRLF & _
        "push ecx" & @CRLF & _
        "call {FUNCTION}" & @CRLF & _
        "add esp,10"

    ; Custom template (empty by default)
    $g_aASMTemplates[$CMD_TYPE_CUSTOM] = "{CUSTOM_CODE}"
EndFunc

#EndRegion Template Definitions

#Region Command Registration

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_RegisterCommand
; Description ...: Registers a new command definition in the system
; Syntax.........: _CmdGen_RegisterCommand($sName, $iType, $sParams, $sFunction, $sCustomTemplate = "")
; Parameters ....: $sName          - Command name
;                  $iType          - Command type (0-5)
;                  $sParams        - Parameter description
;                  $sFunction      - Function to call
;                  $sCustomTemplate - Optional custom template for type 5
; Return values .: Success - True
;                  Failure - False and sets @error
;                           1 = Invalid parameters (empty name or function)
;                           2 = Invalid command type
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Overwrites existing commands with the same name
;                  - Custom template only used for CMD_TYPE_CUSTOM
; Related .......: _CmdGen_GetCommandDefinition, _CmdGen_GenerateCommand
;============================================================================================
Func _CmdGen_RegisterCommand($sName, $iType, $sParams, $sFunction, $sCustomTemplate = "")
    ; Parameter validation
    If $sName = "" Or $sFunction = "" Then
        _Log_Error("Invalid parameters: Name and Function are required", "CmdGen", $GUIEdit)
        Return SetError(1, 0, False)
    EndIf

    If $iType < 0 Or $iType > 4 Then
        _Log_Error("Invalid command type: " & $iType, "CmdGen", $GUIEdit)
        Return SetError(2, 0, False)
    EndIf

    ; Check for name uniqueness
    For $i = 0 To UBound($g_aCommandDefinitions) - 1
        If $g_aCommandDefinitions[$i][0] = $sName Then
            _Log_Warning("Command already exists, overwriting: " & $sName, "CmdGen", $GUIEdit)
            $g_aCommandDefinitions[$i][1] = $iType
            $g_aCommandDefinitions[$i][2] = $sParams
            $g_aCommandDefinitions[$i][3] = $sFunction
            $g_aCommandDefinitions[$i][4] = $sCustomTemplate
            Return True
        EndIf
    Next

    ; Add new command
    Local $iIndex = UBound($g_aCommandDefinitions)
    ReDim $g_aCommandDefinitions[$iIndex + 1][5]

    $g_aCommandDefinitions[$iIndex][0] = $sName
    $g_aCommandDefinitions[$iIndex][1] = $iType
    $g_aCommandDefinitions[$iIndex][2] = $sParams
    $g_aCommandDefinitions[$iIndex][3] = $sFunction
    $g_aCommandDefinitions[$iIndex][4] = $sCustomTemplate

    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_GetCommandDefinition
; Description ...: Retrieves a command definition by name
; Syntax.........: _CmdGen_GetCommandDefinition($sName)
; Parameters ....: $sName - Command name to search for
; Return values .: Success - Array[5] containing command definition
;                           [0] = Name
;                           [1] = Type
;                           [2] = Parameters
;                           [3] = Function
;                           [4] = Custom template
;                  Failure - False and sets @error = 1
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Returns a 1D array copy of the command definition
;                  - Used internally by the generation system
; Related .......: _CmdGen_RegisterCommand, _CmdGen_GenerateCommand
;============================================================================================
Func _CmdGen_GetCommandDefinition($sName)
    ; Check if array is empty
    If UBound($g_aCommandDefinitions) = 0 Then
        _Log_Error("No commands registered yet", "CmdGen", $GUIEdit)
        Return SetError(1, 0, False)
    EndIf

    For $i = 0 To UBound($g_aCommandDefinitions) - 1
        If $g_aCommandDefinitions[$i][0] = $sName Then
            ; Create 1D array with this row's data
            Local $aCommandDef[5]
            $aCommandDef[0] = $g_aCommandDefinitions[$i][0] ; Name
            $aCommandDef[1] = $g_aCommandDefinitions[$i][1] ; Type
            $aCommandDef[2] = $g_aCommandDefinitions[$i][2] ; Parameters
            $aCommandDef[3] = $g_aCommandDefinitions[$i][3] ; Function
            $aCommandDef[4] = $g_aCommandDefinitions[$i][4] ; Template
            Return $aCommandDef
        EndIf
    Next

    _Log_Error("Command definition not found: " & $sName, "CmdGen", $GUIEdit)
    Return SetError(1, 0, False)
EndFunc

#EndRegion Command Registration

#Region Code Generation

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_GenerateCommand
; Description ...: Generates assembly code for a specific command
; Syntax.........: _CmdGen_GenerateCommand($sName)
; Parameters ....: $sName - Command name to generate code for
; Return values .: Success - String containing the generated assembly code
;                  Failure - Empty string
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Uses templates based on command type
;                  - Replaces {FUNCTION} placeholder with actual function name
;                  - Adds command label and return jump
; Related .......: _CmdGen_GetCommandDefinition, _CmdGen_GenerateAllCommands
;============================================================================================
Func _CmdGen_GenerateCommand($sName)
    Local $aCommandDef = _CmdGen_GetCommandDefinition($sName)
    If @error Then Return ""

    Local $iType = $aCommandDef[1]
    Local $sFunction = $aCommandDef[3]
    Local $sCustomTemplate = $aCommandDef[4]

    ; Choose appropriate template
    Local $sTemplate = ""
    If $iType = $CMD_TYPE_CUSTOM And $sCustomTemplate <> "" Then
        $sTemplate = $sCustomTemplate
    Else
        If $iType >= 0 And $iType < UBound($g_aASMTemplates) Then
            $sTemplate = $g_aASMTemplates[$iType]
        Else
            _Log_Error("Invalid template type: " & $iType, "CmdGen", $GUIEdit)
            Return ""
        EndIf
    EndIf

    ; Perform replacements
    $sTemplate = StringReplace($sTemplate, "{FUNCTION}", $sFunction)
    $sTemplate = StringReplace($sTemplate, "{NAME}", $sName)

    ; Build final code
    Local $sCode = "Command" & $sName & ":" & @CRLF
    $sCode &= $sTemplate & @CRLF
    $sCode &= "ljmp CommandReturn"

    Return $sCode
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_InjectIntoAssembler
; Description ...: Injects generated code into the assembler system
; Syntax.........: _CmdGen_InjectIntoAssembler($sCode)
; Parameters ....: $sCode - Assembly code to inject
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Generic function to interface with the existing assembler system
;                  - Splits code into lines and calls _() for each line
;                  - Can be used by any module using the command generator
; Related .......: _CmdGen_GenerateAllCommands
;============================================================================================
Func _CmdGen_InjectIntoAssembler($sCode)
    Local $aLines = StringSplit($sCode, @CRLF, 1)
    For $i = 1 To $aLines[0]
        If StringStripWS($aLines[$i], 3) <> "" Then
            _($aLines[$i])
        EndIf
    Next
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_GenerateAllCommands
; Description ...: Generates and optionally injects all registered commands
; Syntax.........: _CmdGen_GenerateAllCommands($funcInject = "_CmdGen_InjectIntoAssembler")
; Parameters ....: $funcInject - Function name to call for injection (optional)
; Return values .: Success - True if all commands generated successfully
;                  Failure - False if any command failed
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Processes all registered commands
;                  - Logs statistics and errors
;                  - Pass empty string to skip injection
; Related .......: _CmdGen_GenerateCommand, _CmdGen_InjectIntoAssembler
;============================================================================================
Func _CmdGen_GenerateAllCommands($funcInject = "_CmdGen_InjectIntoAssembler")
    Local $iSuccess = 0
    Local $iTotal = UBound($g_aCommandDefinitions)

    If $iTotal = 0 Then
        _Log_Warning("No commands registered for generation", "CmdGen", $GUIEdit)
        Return True
    EndIf

    For $i = 0 To $iTotal - 1
        Local $sName = $g_aCommandDefinitions[$i][0]
        Local $sCode = _CmdGen_GenerateCommand($sName)

        If $sCode <> "" Then
            ; Inject generated code
            If $funcInject <> "" Then
                Call($funcInject, $sCode)
            EndIf
            $iSuccess += 1
        Else
            _Log_Error("Failed to generate command: " & $sName, "CmdGen", $GUIEdit)
        EndIf
    Next

    Return ($iSuccess = $iTotal)
EndFunc

#EndRegion Code Generation

#Region Specialized Templates

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_AddAttributeTemplate
; Description ...: Creates a specialized template for attribute commands
; Syntax.........: _CmdGen_AddAttributeTemplate()
; Parameters ....: None
; Return values .: String containing the attribute template
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Template for 2-parameter attribute operations
;                  - Parameters are pushed in reverse order
; Related .......: _CmdGen_AddTradeTemplate
;============================================================================================
Func _CmdGen_AddAttributeTemplate()
    Local $sTemplate = _
        "mov edx,dword[eax+4]" & @CRLF & _
        "push edx" & @CRLF & _
        "mov ecx,dword[eax+8]" & @CRLF & _
        "push ecx" & @CRLF & _
        "call {FUNCTION}" & @CRLF & _
        "add esp,8"

    Return $sTemplate
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_AddTradeTemplate
; Description ...: Creates a specialized template for complex trading commands
; Syntax.........: _CmdGen_AddTradeTemplate()
; Parameters ....: None
; Return values .: String containing the trade template
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Complex template with multiple parameter pushes
;                  - Uses specific offsets for trade data structure
;                  - Cleans up 24 bytes from stack after call
; Related .......: _CmdGen_AddAttributeTemplate
;============================================================================================
Func _CmdGen_AddTradeTemplate()
    Local $sTemplate = _
        "mov esi,eax" & @CRLF & _
        "add esi,C" & @CRLF & _
        "push 0" & @CRLF & _
        "push 0" & @CRLF & _
        "push 0" & @CRLF & _
        "push dword[eax+4]" & @CRLF & _
        "push 0" & @CRLF & _
        "add eax,8" & @CRLF & _
        "push eax" & @CRLF & _
        "push 1" & @CRLF & _
        "push 0" & @CRLF & _
        "push B" & @CRLF & _
        "call {FUNCTION}" & @CRLF & _
        "add esp,24"

    Return $sTemplate
EndFunc

Func _CmdGen_AddSendPacketTemplate()
    Local $sTemplate = _
		"lea edx,dword[eax+8]" & @CRLF & _
        "push edx" & @CRLF & _
        "mov ebx,dword[eax+4]" & @CRLF & _
        "push ebx" & @CRLF & _
        "mov eax,dword[PacketLocation]" & @CRLF & _
        "push eax" & @CRLF & _
        "call {FUNCTION}" & @CRLF & _
        "pop eax" & @CRLF & _
        "pop ebx" & @CRLF & _
        "pop edx"

    Return $sTemplate
EndFunc

#EndRegion Specialized Templates

#Region Public Interface

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_Initialize
; Description ...: Initializes the Command Generator System
; Syntax.........: _CmdGen_Initialize($hGUIEdit = 0)
; Parameters ....: $hGUIEdit - Handle to GUI edit control for logging (optional)
; Return values .: Always returns True
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Must be called before using any other functions
;                  - Resets all command definitions
;                  - Initializes all templates
; Related .......: _CmdGen_InitializeTemplates
;============================================================================================
Func _CmdGen_Initialize($hGUIEdit = 0)
    ; Initialize global variable for logs
    $GUIEdit = $hGUIEdit

    ; Reset structures
    ReDim $g_aCommandDefinitions[0][5]

    ; Initialize templates
    _CmdGen_InitializeTemplates()

    $g_bGeneratorInitialized = True
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _CmdGen_GenerateAndInject
; Description ...: Generates and injects all commands using the default injector
; Syntax.........: _CmdGen_GenerateAndInject()
; Parameters ....: None
; Return values .: True if all commands generated successfully, False otherwise
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Convenience function that uses the built-in injector
;                  - Equivalent to _CmdGen_GenerateAllCommands() with default parameters
; Related .......: _CmdGen_GenerateAllCommands, _CmdGen_InjectIntoAssembler
;============================================================================================
Func _CmdGen_GenerateAndInject()
    Return _CmdGen_GenerateAllCommands()
EndFunc
#EndRegion Public Interface