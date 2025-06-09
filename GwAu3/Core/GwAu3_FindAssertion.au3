#include-once

; Memory section definitions
Global Const $SECTION_TEXT = 0
Global Const $SECTION_RDATA = 1
Global Const $SECTION_DATA = 2
Global Const $SECTION_RSRC = 3
Global Const $SECTION_RELOC = 4

; Array to store section address ranges
Global $sections[5][2]  ; [section][0=start, 1=end]
Global Const $BLOCK_SIZE = 262144 ; 256 Ko (doubled from 128 Ko)
Global $g_AssertionCache[0][3] ; [file, msg, pattern]
Global $g_SectionBuffer = 0 ; Buffer to hold entire section
Global $g_SectionBufferSize = 0
Global $g_CompiledPatternsCache[0][4] ; [pattern_binary, length, first_byte, last_byte]

Func GetGWBaseAddress()
    If $mGWProcHandle = 0 Then
        _Log_Error("Invalid process handle", "Memory", $g_h_EditText)
        Return 0
    EndIf

    Local $aModules = DllStructCreate("ptr[1024]")
    Local $cbNeeded = DllStructCreate("dword")

    Local $hPSAPI = DllOpen("psapi.dll")
    If @error Then
        _Log_Error("Failed to open psapi.dll", "Memory", $g_h_EditText)
        Return 0
    EndIf

    Local $success = DllCall($hPSAPI, "bool", "EnumProcessModules", _
        "handle", $mGWProcHandle, _
        "ptr", DllStructGetPtr($aModules), _
        "dword", DllStructGetSize($aModules), _
        "ptr", DllStructGetPtr($cbNeeded))

    If @error Or Not $success[0] Then
        _Log_Error("EnumProcessModules failed", "Memory", $g_h_EditText)
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

    _Log_Error("Gw.exe module not found", "Memory", $g_h_EditText)
    DllClose($hPSAPI)
    Return 0
EndFunc

Func InitializeSections($baseAddress)
    Local $dosHeader = DllStructCreate("struct;word e_magic;byte[58];dword e_lfanew;endstruct")
    Local $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress, DllStructGetPtr($dosHeader), DllStructGetSize($dosHeader), 0)
    If Not $success Then
        _Log_Error("Failed to read DOS header", "Sections", $g_h_EditText)
        Return False
    EndIf

    If DllStructGetData($dosHeader, "e_magic") <> 0x5A4D Then ; 'MZ'
        _Log_Error("Invalid DOS signature", "Sections", $g_h_EditText)
        Return False
    EndIf

    Local $e_lfanew = DllStructGetData($dosHeader, "e_lfanew")

    Local $ntHeaders = DllStructCreate("struct;dword Signature;word Machine;word NumberOfSections;dword TimeDateStamp;dword PointerToSymbolTable;dword NumberOfSymbols;word SizeOfOptionalHeader;word Characteristics;endstruct")
    $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress + $e_lfanew, DllStructGetPtr($ntHeaders), DllStructGetSize($ntHeaders), 0)
    If Not $success Then
        _Log_Error("Failed to read NT headers", "Sections", $g_h_EditText)
        Return False
    EndIf

    If DllStructGetData($ntHeaders, "Signature") <> 0x4550 Then ; 'PE\0\0'
        _Log_Error("Invalid PE signature", "Sections", $g_h_EditText)
        Return False
    EndIf

    Local $numberOfSections = DllStructGetData($ntHeaders, "NumberOfSections")
    Local $sizeOfOptionalHeader = DllStructGetData($ntHeaders, "SizeOfOptionalHeader")
    Local $sectionHeaderOffset = $e_lfanew + 24 + $sizeOfOptionalHeader

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
            _Log_Warning("Failed to read section header " & $i, "Sections", $g_h_EditText)
            ContinueLoop
        EndIf

        Local $sectionName = StringStripWS(DllStructGetData($sectionHeader, "Name"), 8)
        Local $virtualAddress = DllStructGetData($sectionHeader, "VirtualAddress")
        Local $virtualSize = DllStructGetData($sectionHeader, "VirtualSize")
        Local $SizeRawData = DllStructGetData($sectionHeader, "SizeOfRawData")

        Local $actualSize = $virtualSize > $SizeRawData ? $virtualSize : $SizeRawData

        Switch $sectionName
            Case ".text"
                $sections[$SECTION_TEXT][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_TEXT][1] = $sections[$SECTION_TEXT][0] + $actualSize

            Case ".rdata"
                $sections[$SECTION_RDATA][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RDATA][1] = $sections[$SECTION_RDATA][0] + $actualSize

            Case ".data"
                $sections[$SECTION_DATA][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_DATA][1] = $sections[$SECTION_DATA][0] + $actualSize

            Case ".rsrc"
                $sections[$SECTION_RSRC][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RSRC][1] = $sections[$SECTION_RSRC][0] + $actualSize

            Case ".reloc"
                $sections[$SECTION_RELOC][0] = $baseAddress + $virtualAddress
                $sections[$SECTION_RELOC][1] = $sections[$SECTION_RELOC][0] + $actualSize
        EndSwitch
    Next

    If $sections[$SECTION_TEXT][0] = 0 Then
        _Log_Error("Failed to find .text section", "Sections", $g_h_EditText)
        Return False
    EndIf

    Return True
EndFunc

Func FindMultipleStrings($aStrings, $section = $SECTION_RDATA)
    If $sections[$section][0] = 0 Or $sections[$section][1] = 0 Then
        Local $baseAddr = GetGWBaseAddress()
        If $baseAddr = 0 Then
            _Log_Error("Failed to get GW base address", "FindMultipleStrings", $g_h_EditText)
            Local $emptyResults[UBound($aStrings)]
            For $i = 0 To UBound($aStrings) - 1
                $emptyResults[$i] = 0
            Next
            Return $emptyResults
        EndIf

        If Not InitializeSections($baseAddr) Then
            _Log_Error("Failed to initialize sections", "FindMultipleStrings", $g_h_EditText)
            Local $emptyResults[UBound($aStrings)]
            For $i = 0 To UBound($aStrings) - 1
                $emptyResults[$i] = 0
            Next
            Return $emptyResults
        EndIf
    EndIf

    Local $stringCount = UBound($aStrings)
    Local $results[$stringCount]
    Local $found[$stringCount]
    Local $patterns[$stringCount]
    Local $lengths[$stringCount]
    Local $skipTables[$stringCount][256]

    For $i = 0 To $stringCount - 1
        $results[$i] = 0
        $found[$i] = False
        $patterns[$i] = _StringToBytes($aStrings[$i])
        $lengths[$i] = BinaryLen($patterns[$i])

        For $j = 0 To 255
            $skipTables[$i][$j] = $lengths[$i]
        Next

        For $j = 0 To $lengths[$i] - 2
            Local $byte = Number(BinaryMid($patterns[$i], $j + 1, 1))
            $skipTables[$i][$byte] = $lengths[$i] - $j - 1
        Next
    Next

    Local $start = $sections[$section][0]
    Local $end = $sections[$section][1]

    If $start = 0 Or $end = 0 Or $start >= $end Then
        _Log_Warning("Invalid section bounds. Start: " & Hex($start) & ", End: " & Hex($end), "FindMultipleStrings", $g_h_EditText)
        Return FindMultipleStringsFallback($aStrings, $section)
    EndIf

    Local $sectionSize = Number($end - $start)
    Local $sectionSizeMB = Number($sectionSize) / Number(1048576) ; 1024 * 1024 = 1048576

    Local $maxReadSize = 1 * 1024 * 1024 ; 1 MB max for direct read (reduced for safety)
    Local $maxReadSizeMB = 1.0

    If $sectionSize > $maxReadSize Then
        Return FindMultipleStringsFallback($aStrings, $section)
    EndIf

    Local $sectionBuffer = DllStructCreate("byte[" & $sectionSize & "]")
    If @error Then
        Return FindMultipleStringsFallback($aStrings, $section)
    EndIf

    Local $bytesRead = 0
    Local $success = DllCall($mKernelHandle, "bool", "ReadProcessMemory", _
        "handle", $mGWProcHandle, _
        "ptr", $start, _
        "ptr", DllStructGetPtr($sectionBuffer), _
        "ulong_ptr", $sectionSize, _
        "ulong_ptr*", $bytesRead)

    If @error Or Not $success[0] Or $success[5] < $sectionSize Then
        _Log_Warning("Failed to read section into memory. Read " & $success[5] & "/" & $sectionSize & " bytes. Using fallback method.", "FindMultipleStrings", $g_h_EditText)
        Return FindMultipleStringsFallback($aStrings, $section)
    EndIf

    Local $totalFound = 0
    Local $startTime = TimerInit()

    For $patternIdx = 0 To $stringCount - 1
        If $found[$patternIdx] Then ContinueLoop

        Local $patternLen = $lengths[$patternIdx]
        Local $pos = $patternLen - 1

        While $pos < $sectionSize
            Local $match = True
            Local $j = $patternLen - 1

            While $j >= 0
                Local $memByte = DllStructGetData($sectionBuffer, 1, $pos - ($patternLen - 1 - $j) + 1)
                Local $patByte = Number(BinaryMid($patterns[$patternIdx], $j + 1, 1))

                If $memByte <> $patByte Then
                    $match = False
                    $pos += $skipTables[$patternIdx][$memByte]
                    ExitLoop
                EndIf
                $j -= 1
            WEnd

            If $match Then
                $results[$patternIdx] = $start + $pos - ($patternLen - 1)
                $found[$patternIdx] = True
                $totalFound += 1
                ExitLoop
            EndIf
        WEnd

        If $totalFound = $stringCount Then ExitLoop
    Next

    Return $results
EndFunc

Func FindMultipleStringsFallback($aStrings, $section = $SECTION_RDATA)
    Local $stringCount = UBound($aStrings)
    Local $results[$stringCount]
    Local $found[$stringCount]
    Local $patterns[$stringCount]
    Local $lengths[$stringCount]
    Local $firstBytes[$stringCount]
    Local $hashTable[256]
    Local $minLength = 999999
    Local $maxLength = 0

    For $i = 0 To 255
        $hashTable[$i] = ""
    Next

    For $i = 0 To $stringCount - 1
        $results[$i] = 0
        $found[$i] = False
        $patterns[$i] = _StringToBytes($aStrings[$i])
        $lengths[$i] = BinaryLen($patterns[$i])
        $firstBytes[$i] = Number(BinaryMid($patterns[$i], 1, 1))

        If $lengths[$i] < $minLength Then $minLength = $lengths[$i]
        If $lengths[$i] > $maxLength Then $maxLength = $lengths[$i]

        If $hashTable[$firstBytes[$i]] = "" Then
            $hashTable[$firstBytes[$i]] = String($i)
        Else
            $hashTable[$firstBytes[$i]] &= "," & $i
        EndIf
    Next

    Local $start = $sections[$section][0]
    Local $end = $sections[$section][1]
    Local $bufferSize = 2097152 ; 2MB buffer
    Local $buffer = DllStructCreate("byte[" & $bufferSize & "]")
    Local $totalFound = 0
    Local $startTime = TimerInit()
    Local $overlap = $maxLength - 1

    Local $patternData[$stringCount][$maxLength]
    For $i = 0 To $stringCount - 1
        For $j = 0 To $lengths[$i] - 1
            $patternData[$i][$j] = Number(BinaryMid($patterns[$i], $j + 1, 1))
        Next
    Next

    For $currentAddr = $start To $end Step $bufferSize - $overlap
        If $totalFound = $stringCount Then ExitLoop

        Local $readSize = $bufferSize
        If $currentAddr + $readSize > $end Then
            $readSize = $end - $currentAddr
        EndIf

        Local $bytesRead = 0
        Local $success = DllCall($mKernelHandle, "bool", "ReadProcessMemory", _
            "handle", $mGWProcHandle, _
            "ptr", $currentAddr, _
            "ptr", DllStructGetPtr($buffer), _
            "ulong_ptr", $readSize, _
            "ulong_ptr*", $bytesRead)

        If @error Or Not $success[0] Or $success[5] = 0 Then ContinueLoop

        $readSize = $success[5]

        Local $searchEnd = $readSize - $minLength + 1
        For $i = 0 To $searchEnd - 1
            Local $byte = DllStructGetData($buffer, 1, $i + 1)

            If $hashTable[$byte] = "" Then ContinueLoop

            Local $indices = StringSplit($hashTable[$byte], ",", 2)

            For $idx = 0 To UBound($indices) - 1
                Local $patternIdx = Number($indices[$idx])
                If $found[$patternIdx] Then ContinueLoop

                Local $patternLen = $lengths[$patternIdx]

                If $i + $patternLen > $readSize Then ContinueLoop

                Local $match = True

                Local $midPoint = Int($patternLen / 2)
                If DllStructGetData($buffer, 1, $i + $midPoint + 1) <> $patternData[$patternIdx][$midPoint] Then ContinueLoop

                If DllStructGetData($buffer, 1, $i + $patternLen) <> $patternData[$patternIdx][$patternLen - 1] Then ContinueLoop

                For $j = 1 To $patternLen - 2
                    If $j = $midPoint Then ContinueLoop
                    If DllStructGetData($buffer, 1, $i + $j + 1) <> $patternData[$patternIdx][$j] Then
                        $match = False
                        ExitLoop
                    EndIf
                Next

                If $match Then
                    $results[$patternIdx] = $currentAddr + $i
                    $found[$patternIdx] = True
                    $totalFound += 1

                    Local $newIndices = ""
                    For $k = 0 To UBound($indices) - 1
                        If Number($indices[$k]) <> $patternIdx Then
                            If $newIndices = "" Then
                                $newIndices = $indices[$k]
                            Else
                                $newIndices &= "," & $indices[$k]
                            EndIf
                        EndIf
                    Next
                    $hashTable[$byte] = $newIndices

                    If $totalFound = $stringCount Then ExitLoop 3
                EndIf
            Next
        Next
    Next

    Local $elapsedTime = TimerDiff($startTime)

    Return $results
EndFunc

Func GetMultipleAssertionPatterns($aAssertions)
    Local $assertionCount = UBound($aAssertions)
    Local $patterns[$assertionCount]

    Local $uncachedAssertions[0][3] ; [index, file, msg]
    Local $allStrings[0]

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
            Local $idx = UBound($uncachedAssertions)
            ReDim $uncachedAssertions[$idx + 1][3]
            $uncachedAssertions[$idx][0] = $i
            $uncachedAssertions[$idx][1] = $aAssertions[$i][0]
            $uncachedAssertions[$idx][2] = $aAssertions[$i][1]

            _ArrayAdd($allStrings, $aAssertions[$i][0])
            _ArrayAdd($allStrings, $aAssertions[$i][1])

            $patterns[$i] = ""
        EndIf
    Next

    If UBound($uncachedAssertions) = 0 Then
        Return $patterns
    EndIf

    If $sections[$SECTION_RDATA][0] = 0 Then
        InitializeSections(GetGWBaseAddress())
    EndIf

    Local $addresses = FindMultipleStrings($allStrings)

    Local $stringToAddress[0][2] ; [string, address]
    For $i = 0 To UBound($allStrings) - 1
        If $addresses[$i] > 0 Then
            _ArrayAdd2D($stringToAddress, $allStrings[$i], $addresses[$i])
        EndIf
    Next

    For $i = 0 To UBound($uncachedAssertions) - 1
        Local $assertIdx = $uncachedAssertions[$i][0]
        Local $fileAddr = 0
        Local $msgAddr = 0

        For $j = 0 To UBound($stringToAddress) - 1
            If $stringToAddress[$j][0] = $uncachedAssertions[$i][1] Then
                $fileAddr = $stringToAddress[$j][1]
            ElseIf $stringToAddress[$j][0] = $uncachedAssertions[$i][2] Then
                $msgAddr = $stringToAddress[$j][1]
            EndIf
        Next

        If $fileAddr > 0 And $msgAddr > 0 Then
            $patterns[$assertIdx] = "BA" & SwapEndian(Hex($fileAddr, 8)) & "B9" & SwapEndian(Hex($msgAddr, 8))

            Local $cacheIdx = UBound($g_AssertionCache)
            ReDim $g_AssertionCache[$cacheIdx + 1][3]
            $g_AssertionCache[$cacheIdx][0] = $uncachedAssertions[$i][1]
            $g_AssertionCache[$cacheIdx][1] = $uncachedAssertions[$i][2]
            $g_AssertionCache[$cacheIdx][2] = $patterns[$assertIdx]
        EndIf
    Next

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

Func _ArrayAdd2D(ByRef $array, $val1, $val2)
    Local $idx = UBound($array)
    ReDim $array[$idx + 1][2]
    $array[$idx][0] = $val1
    $array[$idx][1] = $val2
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

Func _StringToBytes($str)
    Local $len = StringLen($str) + 1
    Local $struct = DllStructCreate("byte[" & $len & "]")

    For $i = 1 To StringLen($str)
        DllStructSetData($struct, 1, Asc(StringMid($str, $i, 1)), $i)
    Next
    DllStructSetData($struct, 1, 0, $len)

    Local $result = DllStructGetData($struct, 1)
    Return $result
EndFunc
