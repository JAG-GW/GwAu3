#include-once

; Memory section definitions
Global Const $SECTION_TEXT = 0
Global Const $SECTION_RDATA = 1
Global Const $SECTION_DATA = 2
Global Const $SECTION_RSRC = 3
Global Const $SECTION_RELOC = 4

; Array to store section address ranges
Global $sections[5][2]  ; [section][0=start, 1=end]
Global Const $BLOCK_SIZE = 131072 ; 128 Ko

; #FUNCTION# ;===============================================================================
; Name...........: GetGWBaseAddress
; Description ...: Gets the base address of Guild Wars process
; Syntax.........: GetGWBaseAddress()
; Parameters ....: None
; Return values .: Success - Base address of GW.exe module
;                  Failure - 0
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Uses EnumProcessModules to find GW.exe in process modules
;                  - Requires psapi.dll
; Related .......: InitializeSections
;============================================================================================
Func GetGWBaseAddress()
    If $mGWProcHandle = 0 Then Return 0

    Local $aModules = DllStructCreate("ptr[1024]")
    Local $cbNeeded = DllStructCreate("dword")

    Local $hPSAPI = DllOpen("psapi.dll")
    If @error Then
        Return 0
    EndIf

    Local $success = DllCall($hPSAPI, "bool", "EnumProcessModules", _
        "handle", $mGWProcHandle, _
        "ptr", DllStructGetPtr($aModules), _
        "dword", DllStructGetSize($aModules), _
        "ptr", DllStructGetPtr($cbNeeded))

    If @error Or Not $success[0] Then
        DllClose($hPSAPI)
        Return 0
    EndIf

    Local $moduleCount = DllStructGetData($cbNeeded, 1) / 4

    For $i = 1 To $moduleCount
        Local $moduleBase = DllStructGetData($aModules, 1, $i)

        Local $moduleName = _WinAPI_GetModuleFileNameEx($mGWProcHandle, $moduleBase)

        If StringInStr($moduleName, "Gw.exe", 1) Then
            DllClose($hPSAPI)
            Return $moduleBase
        EndIf
    Next

    DllClose($hPSAPI)

    Return 0
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: InitializeSections
; Description ...: Initializes memory sections from PE headers
; Syntax.........: InitializeSections()
; Parameters ....: None
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Reads PE headers to determine section addresses
;                  - Must be called before using Find functions
;                  - Sets up $g_aSections array with section boundaries
; Related .......: GetGWBaseAddress, Find
;============================================================================================
Func InitializeSections($baseAddress)
    Local $dosHeader = DllStructCreate("struct;word e_magic;byte[58];dword e_lfanew;endstruct")
    Local $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress, DllStructGetPtr($dosHeader), DllStructGetSize($dosHeader), 0)
    If Not $success Then
        Return False
    EndIf

    If DllStructGetData($dosHeader, "e_magic") <> 0x5A4D Then ; 'MZ'
        Return False
    EndIf

    Local $e_lfanew = DllStructGetData($dosHeader, "e_lfanew")

    Local $ntHeaders = DllStructCreate("struct;dword Signature;word Machine;word NumberOfSections;dword TimeDateStamp;dword PointerToSymbolTable;dword NumberOfSymbols;word SizeOfOptionalHeader;word Characteristics;endstruct")
    $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress + $e_lfanew, DllStructGetPtr($ntHeaders), DllStructGetSize($ntHeaders), 0)
    If Not $success Then
        Return False
    EndIf

    If DllStructGetData($ntHeaders, "Signature") <> 0x4550 Then ; 'PE\0\0'
        Return False
    EndIf

    Local $numberOfSections = DllStructGetData($ntHeaders, "NumberOfSections")
    Local $sizeOfOptionalHeader = DllStructGetData($ntHeaders, "SizeOfOptionalHeader")
    Local $sectionHeaderOffset = $e_lfanew + 24 + $sizeOfOptionalHeader

    Local $sectionHeader = DllStructCreate("struct;" & _
        "char Name[8];" & _
        "dword VirtualSize;" & _
        "dword VirtualAddress;" & _
        "dword SizeOfRawData;" & _
        "dword PointerToRawData;" & _
        "dword PointerToRelocations;" & _
        "dword PointerToLinenumbers;" & _
        "word NumberOfRelocations;" & _
        "word NumberOfLinenumbers;" & _
        "dword Characteristics;" & _
        "endstruct")

    For $i = 0 To $numberOfSections - 1
        $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress + $sectionHeaderOffset + ($i * 40), DllStructGetPtr($sectionHeader), DllStructGetSize($sectionHeader), 0)
        If Not $success Then ContinueLoop

        Local $sectionName = StringStripWS(DllStructGetData($sectionHeader, "Name"), 8)
        Local $virtualAddress = DllStructGetData($sectionHeader, "VirtualAddress")
        Local $virtualSize = DllStructGetData($sectionHeader, "VirtualSize")
		Local $SizeRawData = DllStructGetData($sectionHeader, "SizeOfRawData")

		_Log_Message("======== " & $sectionName & " ========", $c_Log_Msg_Type_Debug, "Gwa²")

        Switch $sectionName
            Case ".text"
                $sections[$SECTION_TEXT][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_TEXT][1] = $sections[$SECTION_TEXT][0] + $virtualSize
				_Log_Message(".text Start: " & $sections[$SECTION_TEXT][0], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".text End: " & $sections[$SECTION_TEXT][1], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".text Size: " & $virtualSize, $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".text Raw Size: " & $SizeRawData, $c_Log_Msg_Type_Debug, "Gwa²")


            Case ".rdata"
                $sections[$SECTION_RDATA][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RDATA][1] = $sections[$SECTION_RDATA][0] + $virtualSize
				_Log_Message(".rdata Start: " & $sections[$SECTION_RDATA][0], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".rdata End: " & $sections[$SECTION_RDATA][1], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".rdata Size: " & $virtualSize, $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".rdata Raw Size: " & $SizeRawData, $c_Log_Msg_Type_Debug, "Gwa²")

            Case ".data"
                $sections[$SECTION_DATA][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_DATA][1] = $sections[$SECTION_DATA][0] + $virtualSize
				_Log_Message(".data Start: " & $sections[$SECTION_DATA][0], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".data End: " & $sections[$SECTION_DATA][1], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".data Size: " & $virtualSize, $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".data Raw Size: " & $SizeRawData, $c_Log_Msg_Type_Debug, "Gwa²")

			Case ".rsrc"
                $sections[$SECTION_RSRC][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RSRC][1] = $sections[$SECTION_RSRC][0] + $virtualSize
				_Log_Message(".rsrc Start: " & $sections[$SECTION_RSRC][0], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".rsrc End: " & $sections[$SECTION_RSRC][1], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".rsrc Size: " & $virtualSize, $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".rsrc Raw Size: " & $SizeRawData, $c_Log_Msg_Type_Debug, "Gwa²")

			Case ".reloc"
                $sections[$SECTION_RELOC][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RELOC][1] = $sections[$SECTION_RELOC][0] + $virtualSize
				_Log_Message(".reloc Start: " & $sections[$SECTION_RELOC][0], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".reloc End: " & $sections[$SECTION_RELOC][1], $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".reloc Size: " & $virtualSize, $c_Log_Msg_Type_Debug, "Gwa²")
				_Log_Message(".reloc Raw Size: " & $SizeRawData, $c_Log_Msg_Type_Debug, "Gwa²")
		EndSwitch

		_Log_Message("=======================", $c_Log_Msg_Type_Debug, "Gwa²")
    Next

    If $sections[$SECTION_TEXT][0] = 0 Then
        Return False
    EndIf

	$sections[$SECTION_TEXT][1] = ($sections[$SECTION_RDATA][0] - $sections[$SECTION_TEXT][0]) + $sections[$SECTION_TEXT][0]
	$sections[$SECTION_RDATA][1] = ($sections[$SECTION_DATA][0] - $sections[$SECTION_RDATA][0]) + $sections[$SECTION_RDATA][0]
	$sections[$SECTION_DATA][1] = ($sections[$SECTION_RSRC][0] - $sections[$SECTION_DATA][0]) + $sections[$SECTION_DATA][0]
	$sections[$SECTION_RSRC][1] = ($sections[$SECTION_RELOC][0] - $sections[$SECTION_RSRC][0]) + $sections[$SECTION_RSRC][0]
	_Log_Message(".text Ajusted End: " &  $sections[$SECTION_TEXT][1], $c_Log_Msg_Type_Debug, "Gwa²")
	_Log_Message(".rdata Ajusted End: " & $sections[$SECTION_RDATA][1], $c_Log_Msg_Type_Debug, "Gwa²")
	_Log_Message(".data Ajusted End: " & $sections[$SECTION_DATA][1], $c_Log_Msg_Type_Debug, "Gwa²")
	_Log_Message(".rsrc Ajusted End: " & $sections[$SECTION_RSRC][1], $c_Log_Msg_Type_Debug, "Gwa²")
;~ 	_Log_Message(".reloc Ajusted End: " & , $c_Log_Msg_Type_Debug, "Gwa²")

    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _StringToBytes
; Description ...: Converts a string to binary with null terminator
; Syntax.........: _StringToBytes($str)
; Parameters ....: $str - String to convert
; Return values .: Binary data
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Adds null terminator at the end
;                  - Used for pattern creation
; Related .......: FindAssertion
;============================================================================================
Func _StringToBytes($str)
    Local $result = Binary("")
    For $i = 1 To StringLen($str)
        $result &= Binary(Chr(Asc(StringMid($str, $i, 1))))
    Next
    $result &= Binary(Chr(0))

    Local $debug_str = ""
    For $i = 1 To BinaryLen($result)
        $debug_str &= Hex(BinaryMid($result, $i, 1), 2) & " "
    Next

    Return $result
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AddressToBytes
; Description ...: Converts address to little-endian binary format
; Syntax.........: _AddressToBytes($address)
; Parameters ....: $address - Address to convert
; Return values .: Binary data in little-endian format
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Used for creating x86 instruction patterns
; Related .......: FindAssertion
;============================================================================================
Func _AddressToBytes($address)
    Local $result = Binary("")
    Local $addr = $address
    For $i = 0 To 3
        $result &= Binary(Chr(BitAND($addr, 0xFF)))
        $addr = BitShift($addr, 8)
    Next
    Return $result
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: FindAssertion
; Description ...: Finds assertion pattern in code (GWCA++ compatible)
; Syntax.........: FindAssertion($assertion_file, $assertion_msg = "", $instance = 0, $offset = 0)
; Parameters ....: $assertion_file - File path string to search
;                  $assertion_msg  - Assertion message (optional)
;                  $instance      - Which instance to return (unused)
;                  $offset        - Offset to apply to result
; Return values .: Success - Address with offset applied
;                  Failure - 0
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Searches for strings in .rdata section
;                  - Finds code pattern that references both strings
;                  - Compatible with GWCA++ Scanner::FindAssertion
; Related .......: Find, InitializeSections
;============================================================================================
Func FindAssertion($assertion_file, $assertion_msg = "", $offset = 0)

    If $sections[$SECTION_RDATA][0] = 0 Or $sections[$SECTION_RDATA][1] = 0 Then
        Return 0
    EndIf
    If $sections[$SECTION_TEXT][0] = 0 Or $sections[$SECTION_TEXT][1] = 0 Then
        Return 0
    EndIf

    Local $file_rdata = 0
    If $assertion_file <> "" Then
        Local $file_bytes = _StringToBytes($assertion_file)
        Local $file_mask = ""
        For $i = 1 To BinaryLen($file_bytes)
            $file_mask &= "x"
        Next

        Local $file_bytes_hex = ""
        For $i = 1 To BinaryLen($file_bytes)
            $file_bytes_hex &= Hex(BinaryMid($file_bytes, $i, 1), 2) & " "
        Next

        $file_rdata = Find($file_bytes, $file_mask, 0, $SECTION_RDATA)

        If $file_rdata = 0 Then
            Return 0
        EndIf
    EndIf

    Local $msg_rdata = 0
    If $assertion_msg <> "" Then
        Local $msg_bytes = _StringToBytes($assertion_msg)
        Local $msg_mask = ""
        For $i = 1 To BinaryLen($msg_bytes)
            $msg_mask &= "x"
        Next

        Local $msg_bytes_hex = ""
        For $i = 1 To BinaryLen($msg_bytes)
            $msg_bytes_hex &= Hex(BinaryMid($msg_bytes, $i, 1), 2) & " "
        Next

        $msg_rdata = Find($msg_bytes, $msg_mask, 0, $SECTION_RDATA)

        If $msg_rdata = 0 Then
            Return 0
        EndIf
    EndIf

    Local $pattern = Binary("")
    Local $assertion_mask = ""

    $pattern &= Binary(Chr(0xBA)) ; mov edx, offset
    $pattern &= _AddressToBytes($file_rdata)
    $assertion_mask &= "xxxxx"

    $pattern &= Binary(Chr(0xB9)) ; mov ecx, offset
    $pattern &= _AddressToBytes($msg_rdata)
    $assertion_mask &= "xxxxx"

    Local $debug_pattern = ""
    For $i = 1 To BinaryLen($pattern)
        $debug_pattern &= Hex(BinaryMid($pattern, $i, 1), 2) & " "
    Next

    Local $result = Find($pattern, $assertion_mask, $offset, $SECTION_TEXT)

    If $result Then
        Local $buffer = DllStructCreate("byte[20]")
        Local $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $result, DllStructGetPtr($buffer), 20, 0)
        If $success Then
            Local $bytes = ""
            For $i = 1 To 20
                $bytes &= Hex(DllStructGetData($buffer, 1, $i), 2) & " "
            Next
        EndIf
    EndIf

    Return $result
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: Find
; Description ...: Finds pattern in specified memory section
; Syntax.........: Find($pattern, $mask, $offset = 0, $section = $SECTION_TEXT)
; Parameters ....: $pattern - Binary pattern to search
;                  $mask    - Mask string ('x' = must match, '?' = wildcard)
;                  $offset  - Offset to apply to result
;                  $section - Section to search in
; Return values .: Success - Address where pattern was found + offset
;                  Failure - 0
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Searches in blocks for efficiency
;                  - Supports wildcards in mask
; Related .......: FindAssertion, InitializeSections
;============================================================================================
Func Find($pattern, $mask, $offset = 0, $section = $SECTION_TEXT)
    Local $start = $sections[$section][0]
    Local $end = $sections[$section][1]
    Local $buffer = DllStructCreate("byte[" & $BLOCK_SIZE & "]")
    Local $patternLen = StringLen($mask)

    If $offset < 0 Then
        $start += Abs($offset)
    ElseIf $offset > 0 Then
        $end -= $offset
    EndIf

    For $currentAddr = $start To $end - $patternLen Step $BLOCK_SIZE - $patternLen
        Local $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $currentAddr, DllStructGetPtr($buffer), $BLOCK_SIZE, 0)
        If Not $success Then ContinueLoop

        For $i = 0 To $BLOCK_SIZE - $patternLen
            Local $found = True
            For $j = 0 To $patternLen - 1
                If StringMid($mask, $j + 1, 1) = "x" Then
                    If DllStructGetData($buffer, 1, $i + $j + 1) <> BinaryMid($pattern, $j + 1, 1) Then
                        $found = False
                        ExitLoop
                    EndIf
                EndIf
            Next

            If $found Then
                Return $currentAddr + $i + $offset
            EndIf
        Next
    Next

    Return 0
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: FunctionFromNearCall
; Description ...: Resolves the target address of a CALL or JMP instruction
; Syntax.........: FunctionFromNearCall($call_instruction_address)
; Parameters ....: $call_instruction_address - Address of the CALL/JMP instruction
; Return values .: Success - Target function address
;                  Failure - 0 (not a valid CALL/JMP instruction)
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Handles E8 (CALL rel32), E9 (JMP rel32), and EB (JMP rel8)
;                  - Recursively follows nested calls/jumps
;                  - Properly handles signed relative offsets
; Related .......: FindAssertion
;============================================================================================
Func FunctionFromNearCall($call_instruction_address)
    ; Read the opcode (first byte)
    Local $opcode = MemoryRead($call_instruction_address, "byte")
    Local $function_address = 0

    Switch $opcode
        Case 0xE8, 0xE9 ; CALL or JMP near (32-bit relative)
            ; Read the 4-byte relative address
            Local $near_address = MemoryRead($call_instruction_address + 1, "dword")
            ; Convert to signed value if necessary
            If $near_address > 0x7FFFFFFF Then
                $near_address -= 0x100000000
            EndIf
            ; Calculate absolute address
            $function_address = $near_address + ($call_instruction_address + 5)

        Case 0xEB ; JMP short (8-bit relative)
            ; Read the 1-byte offset
            Local $near_address = MemoryRead($call_instruction_address + 1, "byte")
            ; Convert to signed value if necessary
            If BitAND($near_address, 0x80) Then
                $near_address = -((BitNOT($near_address) + 1) And 0xFF)
            EndIf
            ; Calculate absolute address
            $function_address = $near_address + ($call_instruction_address + 2)

        Case Else
            Return 0 ; Not a CALL/JMP instruction
    EndSwitch

    ; Check for nested calls
    Local $nested_call = FunctionFromNearCall($function_address)
    If $nested_call <> 0 Then
        Return $nested_call
    EndIf

    Return $function_address
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: FindInRange
; Description ...: Searches for a pattern within a specific memory range
; Syntax.........: FindInRange($pattern, $mask, $offset, $start, $end)
; Parameters ....: $pattern - Hex string pattern to search
;                  $mask    - Mask string ('x' = must match, '?' = wildcard)
;                  $offset  - Offset to apply to found address
;                  $start   - Start address of search range
;                  $end     - End address of search range
; Return values .: Success - Address where pattern was found + offset
;                  Failure - 0
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Supports forward and backward searching
;                  - Handles unsigned address comparison properly
;                  - Used for searching within specific code regions
; Related .......: Find, _UnsignedCompare
;============================================================================================
Func FindInRange($pattern, $mask, $offset, $start, $end)
    Local $patternBytes = StringToByteArray($pattern)
    Local $patternLength = UBound($patternBytes)
    Local $found = False

    ; Adjust end like in C++
    $end = BitAND($end, 0xFFFFFFFF)
    $end -= $patternLength

    If $start > $end Then  ; Backward search
        Local $i = $start
        While $i >= $end
            If MemoryRead($i, 'byte') <> $patternBytes[0] Then
                $i -= 1
                ContinueLoop
            EndIf

            $found = True
            For $idx = 0 To $patternLength - 1
                If (Not $mask Or StringMid($mask, $idx + 1, 1) = "x") And _
                   MemoryRead($i + $idx, 'byte') <> $patternBytes[$idx] Then
                    $found = False
                    ExitLoop
                EndIf
            Next

            If $found Then
                Return BitAND($i + $offset, 0xFFFFFFFF)
            EndIf
            $i -= 1
        WEnd
    Else ; Forward search
       Local $i = $start
       While _UnsignedCompare($i, $end) < 0
           If MemoryRead($i, 'byte') <> $patternBytes[0] Then
               $i = BitAND($i + 1, 0xFFFFFFFF)
               ContinueLoop
           EndIf

           $found = True
           For $idx = 0 To $patternLength - 1
               If (Not $mask Or StringMid($mask, $idx + 1, 1) = "x") And _
                  MemoryRead($i + $idx, 'byte') <> $patternBytes[$idx] Then
                   $found = False
                   ExitLoop
               EndIf
           Next

           If $found Then
               Return $i + $offset
           EndIf
           $i = BitAND($i + 1, 0xFFFFFFFF)
       WEnd
   EndIf
   Return 0
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _UnsignedCompare
; Description ...: Compares two addresses as unsigned 32-bit values
; Syntax.........: _UnsignedCompare($a, $b)
; Parameters ....: $a - First address
;                  $b - Second address
; Return values .: -1 if $a < $b
;                   0 if $a = $b
;                   1 if $a > $b
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Handles address wraparound correctly
;                  - Essential for proper memory range comparisons
; Related .......: FindInRange
;============================================================================================
Func _UnsignedCompare($a, $b)
   $a = BitAND($a, 0xFFFFFFFF)
   $b = BitAND($b, 0xFFFFFFFF)
   If $a = $b Then Return 0
   Return ($a > $b And $a - $b < 0x80000000) Or ($b > $a And $b - $a > 0x80000000) ? 1 : -1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: StringToByteArray
; Description ...: Converts a hex string to an array of bytes
; Syntax.........: StringToByteArray($hexString)
; Parameters ....: $hexString - Hex string to convert (e.g. "5589E5")
; Return values .: Array of byte values
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Each pair of hex characters becomes one byte
;                  - Used for pattern matching operations
; Related .......: FindInRange
;============================================================================================
Func StringToByteArray($hexString)
   Local $length = StringLen($hexString) / 2
   Local $bytes[$length]

   For $i = 0 To $length - 1
       Local $hexByte = StringMid($hexString, ($i * 2) + 1, 2)
       $bytes[$i] = "0x" & $hexByte
   Next

   Return $bytes
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: DllReadByte
; Description ...: Reads a single byte from process memory using WinAPI
; Syntax.........: DllReadByte($address)
; Parameters ....: $address - Memory address to read from
; Return values .: Success - Byte value at the address
;                  Failure - 0
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Alternative to MemoryRead for single bytes
;                  - Uses direct WinAPI call
; Related .......: DllReadInt, MemoryRead
;============================================================================================
Func DllReadByte($address)
    Local $buffer = DllStructCreate("byte")
    DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'ptr', $address, 'ptr', DllStructGetPtr($buffer), 'int', 1, 'int', '')
    If @error Then Return 0
    Return DllStructGetData($buffer, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: DllReadInt
; Description ...: Reads a 32-bit integer from process memory using WinAPI
; Syntax.........: DllReadInt($address)
; Parameters ....: $address - Memory address to read from
; Return values .: Success - Integer value at the address
;                  Failure - 0
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Alternative to MemoryRead for integers
;                  - Uses direct WinAPI call
; Related .......: DllReadByte, MemoryRead
;============================================================================================
Func DllReadInt($address)
    Local $buffer = DllStructCreate("int")
    DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'ptr', $address, 'ptr', DllStructGetPtr($buffer), 'int', 4, 'int', '')
    If @error Then Return 0
    Return DllStructGetData($buffer, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: GetAssertionPattern
; Description ...: Builds an assertion pattern from file and message strings
; Syntax.........: GetAssertionPattern($assertion_file, $assertion_msg)
; Parameters ....: $assertion_file - File path string
;                  $assertion_msg  - Message string
; Return values .: Hex string pattern for the assertion
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Searches for strings in .rdata section first
;                  - Builds pattern: mov edx, file_addr; mov ecx, msg_addr
;                  - Returns pattern in hex string format for searching
; Related .......: FindAssertion, Find
;============================================================================================
Func GetAssertionPattern($assertion_file, $assertion_msg)
    Local $file_rdata = 0
    Local $msg_rdata = 0

    ; First search for strings in RDATA
    If $assertion_file <> "" Then
        Local $file_bytes = _StringToBytes($assertion_file)
        Local $file_mask = ""
        For $i = 1 To BinaryLen($file_bytes)
            $file_mask &= "x"
        Next
        $file_rdata = Find($file_bytes, $file_mask, 0, $SECTION_RDATA)
    EndIf

    If $assertion_msg <> "" Then
        Local $msg_bytes = _StringToBytes($assertion_msg)
        Local $msg_mask = ""
        For $i = 1 To BinaryLen($msg_bytes)
            $msg_mask &= "x"
        Next
        $msg_rdata = Find($msg_bytes, $msg_mask, 0, $SECTION_RDATA)
    EndIf

    ; Generate pattern in little-endian format
    Local $pattern = "BA" ; mov edx

    ; Convert $file_rdata to little-endian
    Local $file_bytes = SwapEndian(Hex($file_rdata, 8))
    $pattern &= $file_bytes

    $pattern &= "B9" ; mov ecx

    ; Convert $msg_rdata to little-endian
    Local $msg_bytes = SwapEndian(Hex($msg_rdata, 8))
    $pattern &= $msg_bytes

    Return $pattern
EndFunc
