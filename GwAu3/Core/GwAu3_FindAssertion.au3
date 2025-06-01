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
Global $g_AssertionCache[0][3] ; [file, msg, pattern]

Func GetGWBaseAddress()
    If $mGWProcHandle = 0 Then
        _Log_Error("Invalid process handle", "Memory", $GUIEdit)
        Return 0
    EndIf

    Local $aModules = DllStructCreate("ptr[1024]")
    Local $cbNeeded = DllStructCreate("dword")

    Local $hPSAPI = DllOpen("psapi.dll")
    If @error Then
        _Log_Error("Failed to open psapi.dll", "Memory", $GUIEdit)
        Return 0
    EndIf

    Local $success = DllCall($hPSAPI, "bool", "EnumProcessModules", _
        "handle", $mGWProcHandle, _
        "ptr", DllStructGetPtr($aModules), _
        "dword", DllStructGetSize($aModules), _
        "ptr", DllStructGetPtr($cbNeeded))

    If @error Or Not $success[0] Then
        _Log_Error("EnumProcessModules failed", "Memory", $GUIEdit)
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

    _Log_Error("Gw.exe module not found", "Memory", $GUIEdit)
    DllClose($hPSAPI)
    Return 0
EndFunc

Func InitializeSections($baseAddress)

    Local $dosHeader = DllStructCreate("struct;word e_magic;byte[58];dword e_lfanew;endstruct")
    Local $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress, DllStructGetPtr($dosHeader), DllStructGetSize($dosHeader), 0)
    If Not $success Then
        _Log_Error("Failed to read DOS header", "Sections", $GUIEdit)
        Return False
    EndIf

    If DllStructGetData($dosHeader, "e_magic") <> 0x5A4D Then ; 'MZ'
        _Log_Error("Invalid DOS signature", "Sections", $GUIEdit)
        Return False
    EndIf

    Local $e_lfanew = DllStructGetData($dosHeader, "e_lfanew")

    Local $ntHeaders = DllStructCreate("struct;dword Signature;word Machine;word NumberOfSections;dword TimeDateStamp;dword PointerToSymbolTable;dword NumberOfSymbols;word SizeOfOptionalHeader;word Characteristics;endstruct")
    $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress + $e_lfanew, DllStructGetPtr($ntHeaders), DllStructGetSize($ntHeaders), 0)
    If Not $success Then
        _Log_Error("Failed to read NT headers", "Sections", $GUIEdit)
        Return False
    EndIf

    If DllStructGetData($ntHeaders, "Signature") <> 0x4550 Then ; 'PE\0\0'
        _Log_Error("Invalid PE signature", "Sections", $GUIEdit)
        Return False
    EndIf

    Local $numberOfSections = DllStructGetData($ntHeaders, "NumberOfSections")
    Local $sizeOfOptionalHeader = DllStructGetData($ntHeaders, "SizeOfOptionalHeader")
    Local $sectionHeaderOffset = $e_lfanew + 24 + $sizeOfOptionalHeader

    ; Clear sections array
    For $i = 0 To 4
        $sections[$i][0] = 0
        $sections[$i][1] = 0
    Next

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
        If Not $success Then
            _Log_Warning("Failed to read section header " & $i, "Sections", $GUIEdit)
            ContinueLoop
        EndIf

        Local $sectionName = StringStripWS(DllStructGetData($sectionHeader, "Name"), 8)
        Local $virtualAddress = DllStructGetData($sectionHeader, "VirtualAddress")
        Local $virtualSize = DllStructGetData($sectionHeader, "VirtualSize")
        Local $SizeRawData = DllStructGetData($sectionHeader, "SizeOfRawData")

        Switch $sectionName
            Case ".text"
                $sections[$SECTION_TEXT][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_TEXT][1] = $sections[$SECTION_TEXT][0] + $virtualSize

            Case ".rdata"
                $sections[$SECTION_RDATA][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RDATA][1] = $sections[$SECTION_RDATA][0] + $virtualSize

            Case ".data"
                $sections[$SECTION_DATA][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_DATA][1] = $sections[$SECTION_DATA][0] + $virtualSize

            Case ".rsrc"
                $sections[$SECTION_RSRC][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RSRC][1] = $sections[$SECTION_RSRC][0] + $virtualSize

            Case ".reloc"
                $sections[$SECTION_RELOC][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RELOC][1] = $sections[$SECTION_RELOC][0] + $virtualSize
        EndSwitch
    Next

    If $sections[$SECTION_TEXT][0] = 0 Then
        _Log_Error("Failed to find .text section", "Sections", $GUIEdit)
        Return False
    EndIf

    ; Adjust section ends
    If $sections[$SECTION_TEXT][0] > 0 And $sections[$SECTION_RDATA][0] > 0 Then
        $sections[$SECTION_TEXT][1] = $sections[$SECTION_RDATA][0]
    EndIf
    If $sections[$SECTION_RDATA][0] > 0 And $sections[$SECTION_DATA][0] > 0 Then
        $sections[$SECTION_RDATA][1] = $sections[$SECTION_DATA][0]
    EndIf
    If $sections[$SECTION_DATA][0] > 0 And $sections[$SECTION_RSRC][0] > 0 Then
        $sections[$SECTION_DATA][1] = $sections[$SECTION_RSRC][0]
    EndIf
    If $sections[$SECTION_RSRC][0] > 0 And $sections[$SECTION_RELOC][0] > 0 Then
        $sections[$SECTION_RSRC][1] = $sections[$SECTION_RELOC][0]
    EndIf

    Return True
EndFunc

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

Func FindMultipleStrings($aStrings, $section = $SECTION_RDATA)
    Local $stringCount = UBound($aStrings)
    Local $results[$stringCount]
    Local $found[$stringCount]
    Local $patterns[$stringCount]
    Local $masks[$stringCount]
    Local $lengths[$stringCount]

    For $i = 0 To $stringCount - 1
        $results[$i] = 0
        $found[$i] = False
    Next

    For $i = 0 To $stringCount - 1
        $patterns[$i] = _StringToBytes($aStrings[$i])
        $lengths[$i] = BinaryLen($patterns[$i])
        $masks[$i] = ""
        For $j = 1 To $lengths[$i]
            $masks[$i] &= "x"
        Next
    Next

    Local $start = $sections[$section][0]
    Local $end = $sections[$section][1]
    Local $buffer = DllStructCreate("byte[" & $BLOCK_SIZE & "]")
    Local $totalFound = 0
    Local $startTime = TimerInit()
    Local $blocksSearched = 0

    For $currentAddr = $start To $end Step $BLOCK_SIZE - 255
        If $totalFound = $stringCount Then ExitLoop

        Local $readSize = $BLOCK_SIZE
        If $currentAddr + $readSize > $end Then
            $readSize = $end - $currentAddr
        EndIf

        Local $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $currentAddr, DllStructGetPtr($buffer), $readSize, 0)
        If Not $success Then ContinueLoop

        $blocksSearched += 1

        For $patternIdx = 0 To $stringCount - 1
            If $found[$patternIdx] Then ContinueLoop

            Local $patternLen = $lengths[$patternIdx]
            For $i = 0 To $readSize - $patternLen
                Local $match = True

                For $j = 0 To $patternLen - 1
                    If DllStructGetData($buffer, 1, $i + $j + 1) <> BinaryMid($patterns[$patternIdx], $j + 1, 1) Then
                        $match = False
                        ExitLoop
                    EndIf
                Next

                If $match Then
                    $results[$patternIdx] = $currentAddr + $i
                    $found[$patternIdx] = True
                    $totalFound += 1
                    ExitLoop
                EndIf
            Next
        Next

        If Mod($blocksSearched, 100) = 0 Then
        EndIf
    Next

    Return $results
EndFunc

Func GetMultipleAssertionPatterns($aAssertions)
    Local $assertionCount = UBound($aAssertions)
    Local $patterns[$assertionCount]
    Local $allStrings[0]
    Local $stringMap[0][3]

    For $i = 0 To $assertionCount - 1
        Local $cached = False
        For $j = 0 To UBound($g_AssertionCache) - 1
            If $g_AssertionCache[$j][0] = $aAssertions[$i][0] And $g_AssertionCache[$j][1] = $aAssertions[$i][1] Then
                $patterns[$i] = $g_AssertionCache[$j][2]
                $cached = True
                ExitLoop
            EndIf
        Next

        If Not $cached Then
            Local $idx = UBound($allStrings)
            ReDim $allStrings[$idx + 1]
            $allStrings[$idx] = $aAssertions[$i][0]

            ReDim $stringMap[UBound($stringMap) + 1][3]
            $stringMap[UBound($stringMap) - 1][0] = $i
            $stringMap[UBound($stringMap) - 1][1] = 0
            $stringMap[UBound($stringMap) - 1][2] = $aAssertions[$i][0]

            $idx = UBound($allStrings)
            ReDim $allStrings[$idx + 1]
            $allStrings[$idx] = $aAssertions[$i][1]

            ReDim $stringMap[UBound($stringMap) + 1][3]
            $stringMap[UBound($stringMap) - 1][0] = $i
            $stringMap[UBound($stringMap) - 1][1] = 1
            $stringMap[UBound($stringMap) - 1][2] = $aAssertions[$i][1]
        EndIf
    Next

    If UBound($allStrings) > 0 Then

        If $sections[$SECTION_RDATA][0] = 0 Then
            InitializeSections(GetGWBaseAddress())
        EndIf

        Local $addresses = FindMultipleStrings($allStrings)

        Local $tempResults[$assertionCount][2]
        For $i = 0 To $assertionCount - 1
            $tempResults[$i][0] = 0
            $tempResults[$i][1] = 0
        Next

        For $i = 0 To UBound($stringMap) - 1
            Local $assertIdx = $stringMap[$i][0]
            Local $isMsg = $stringMap[$i][1]

            For $j = 0 To UBound($allStrings) - 1
                If $allStrings[$j] = $stringMap[$i][2] Then
                    If $isMsg Then
                        $tempResults[$assertIdx][1] = $addresses[$j]
                    Else
                        $tempResults[$assertIdx][0] = $addresses[$j]
                    EndIf
                    ExitLoop
                EndIf
            Next
        Next

        For $i = 0 To $assertionCount - 1
            If $patterns[$i] = "" Then
                If $tempResults[$i][0] > 0 And $tempResults[$i][1] > 0 Then
                    $patterns[$i] = "BA" & SwapEndian(Hex($tempResults[$i][0], 8)) & "B9" & SwapEndian(Hex($tempResults[$i][1], 8))

                    Local $idx = UBound($g_AssertionCache)
                    ReDim $g_AssertionCache[$idx + 1][3]
                    $g_AssertionCache[$idx][0] = $aAssertions[$i][0]
                    $g_AssertionCache[$idx][1] = $aAssertions[$i][1]
                    $g_AssertionCache[$idx][2] = $patterns[$i]
                Else
                    $patterns[$i] = ""
                EndIf
            EndIf
        Next
    EndIf

    Return $patterns
EndFunc

Func FunctionFromNearCall($call_instruction_address)
    Local $opcode = MemoryRead($call_instruction_address, "byte")
    Local $function_address = 0

    Switch $opcode
        Case 0xE8, 0xE9
            Local $near_address = MemoryRead($call_instruction_address + 1, "dword")
            If $near_address > 0x7FFFFFFF Then
                $near_address -= 0x100000000
            EndIf
            $function_address = $near_address + ($call_instruction_address + 5)

        Case 0xEB
            Local $near_address = MemoryRead($call_instruction_address + 1, "byte")
            If BitAND($near_address, 0x80) Then
                $near_address = -((BitNOT($near_address) + 1) And 0xFF)
            EndIf
            $function_address = $near_address + ($call_instruction_address + 2)

        Case Else
            Return 0
    EndSwitch

    Local $nested_call = FunctionFromNearCall($function_address)
    If $nested_call <> 0 Then
        Return $nested_call
    EndIf

    Return $function_address
EndFunc

Func FindInRange($pattern, $mask, $offset, $start, $end)
    Local $patternBytes = StringToByteArray($pattern)
    Local $patternLength = UBound($patternBytes)
    Local $found = False

    $start = BitAND($start, 0xFFFFFFFF)
    $end = BitAND($end, 0xFFFFFFFF)

    If $end > $start Then
        $end = $end - $patternLength + 1
    EndIf

    If $start > $end Then
        Local $i = $start
        While $i >= $end
            Local $firstByte = MemoryRead($i, 'byte')
            If $firstByte <> $patternBytes[0] Then
                $i -= 1
                ContinueLoop
            EndIf

            $found = True
            For $idx = 0 To $patternLength - 1
                If $mask <> "" And StringMid($mask, $idx + 1, 1) <> "x" Then
                    ContinueLoop
                EndIf

                Local $memByte = MemoryRead($i + $idx, 'byte')
                If $memByte <> $patternBytes[$idx] Then
                    $found = False
                    ExitLoop
                EndIf
            Next

            If $found Then
                Return $i + $offset
            EndIf
            $i -= 1
        WEnd
    Else
        Local $i = $start
        While $i < $end
            Local $firstByte = MemoryRead($i, 'byte')
            If $firstByte <> $patternBytes[0] Then
                $i += 1
                ContinueLoop
            EndIf

            $found = True
            For $idx = 0 To $patternLength - 1
                If $mask <> "" And StringMid($mask, $idx + 1, 1) <> "x" Then
                    ContinueLoop
                EndIf

                Local $memByte = MemoryRead($i + $idx, 'byte')
                If $memByte <> $patternBytes[$idx] Then
                    $found = False
                    ExitLoop
                EndIf
            Next

            If $found Then
                Return $i + $offset
            EndIf
            $i += 1
        WEnd
    EndIf

    Return 0
EndFunc

Func ToFunctionStart($call_instruction_address, $scan_range = 0x200)
    If $call_instruction_address = 0 Then Return 0

    Local $start = $call_instruction_address
    Local $end = BitAND($call_instruction_address - $scan_range, 0xFFFFFFFF)

    Return FindInRange("558BEC", "xxx", 0, $start, $end)
EndFunc

Func _UnsignedCompare($a, $b)
   $a = BitAND($a, 0xFFFFFFFF)
   $b = BitAND($b, 0xFFFFFFFF)
   If $a = $b Then Return 0
   Return ($a > $b And $a - $b < 0x80000000) Or ($b > $a And $b - $a > 0x80000000) ? 1 : -1
EndFunc

Func StringToByteArray($hexString)
    Local $length = StringLen($hexString) / 2
    Local $bytes[$length]

    For $i = 0 To $length - 1
        Local $hexByte = StringMid($hexString, ($i * 2) + 1, 2)
        $bytes[$i] = Dec($hexByte)
    Next

    Return $bytes
EndFunc