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

Func GwAu3_Scanner_GWBaseAddress()
    If $mGWProcHandle = 0 Then
        GwAu3_Log_Error("Invalid process handle", "Memory", $g_h_EditText)
        Return 0
    EndIf

    Local $aModules = DllStructCreate("ptr[1024]")
    Local $cbNeeded = DllStructCreate("dword")

    Local $hPSAPI = DllOpen("psapi.dll")
    If @error Then
        GwAu3_Log_Error("Failed to open psapi.dll", "Memory", $g_h_EditText)
        Return 0
    EndIf

    Local $success = DllCall($hPSAPI, "bool", "EnumProcessModules", _
        "handle", $mGWProcHandle, _
        "ptr", DllStructGetPtr($aModules), _
        "dword", DllStructGetSize($aModules), _
        "ptr", DllStructGetPtr($cbNeeded))

    If @error Or Not $success[0] Then
        GwAu3_Log_Error("EnumProcessModules failed", "Memory", $g_h_EditText)
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

    GwAu3_Log_Error("Gw.exe module not found", "Memory", $g_h_EditText)
    DllClose($hPSAPI)
    Return 0
EndFunc

Func GwAu3_Scanner_InitializeSections($baseAddress)
    Local $dosHeader = DllStructCreate("struct;word e_magic;byte[58];dword e_lfanew;endstruct")
    Local $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress, DllStructGetPtr($dosHeader), DllStructGetSize($dosHeader), 0)
    If Not $success Then
        GwAu3_Log_Error("Failed to read DOS header", "Sections", $g_h_EditText)
        Return False
    EndIf

    If DllStructGetData($dosHeader, "e_magic") <> 0x5A4D Then ; 'MZ'
        GwAu3_Log_Error("Invalid DOS signature", "Sections", $g_h_EditText)
        Return False
    EndIf

    Local $e_lfanew = DllStructGetData($dosHeader, "e_lfanew")

    Local $ntHeaders = DllStructCreate("struct;dword Signature;word Machine;word NumberOfSections;dword TimeDateStamp;dword PointerToSymbolTable;dword NumberOfSymbols;word SizeOfOptionalHeader;word Characteristics;endstruct")
    $success = _WinAPI_ReadProcessMemory($mGWProcHandle, $baseAddress + $e_lfanew, DllStructGetPtr($ntHeaders), DllStructGetSize($ntHeaders), 0)
    If Not $success Then
        GwAu3_Log_Error("Failed to read NT headers", "Sections", $g_h_EditText)
        Return False
    EndIf

    If DllStructGetData($ntHeaders, "Signature") <> 0x4550 Then ; 'PE\0\0'
        GwAu3_Log_Error("Invalid PE signature", "Sections", $g_h_EditText)
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
            GwAu3_Log_Warning("Failed to read section header " & $i, "Sections", $g_h_EditText)
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
        GwAu3_Log_Error("Failed to find .text section", "Sections", $g_h_EditText)
        Return False
    EndIf

    Return True
EndFunc

Func GwAu3_Scanner_FindMultipleStrings($aStrings, $section = $SECTION_RDATA)
    If $sections[$section][0] = 0 Or $sections[$section][1] = 0 Then
        Local $baseAddr = GwAu3_Scanner_GWBaseAddress()
        If $baseAddr = 0 Then
            GwAu3_Log_Error("Failed to get GW base address", "GwAu3_Scanner_FindMultipleStrings", $g_h_EditText)
            Local $emptyResults[UBound($aStrings)]
            For $i = 0 To UBound($aStrings) - 1
                $emptyResults[$i] = 0
            Next
            Return $emptyResults
        EndIf

        If Not GwAu3_Scanner_InitializeSections($baseAddr) Then
            GwAu3_Log_Error("Failed to initialize sections", "GwAu3_Scanner_FindMultipleStrings", $g_h_EditText)
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
        $patterns[$i] = GwAu3_Utils_StringToBytes($aStrings[$i])
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
        GwAu3_Log_Warning("Invalid section bounds. Start: " & Hex($start) & ", End: " & Hex($end), "GwAu3_Scanner_FindMultipleStrings", $g_h_EditText)
        Return GwAu3_Scanner_FindMultipleStringsFallback($aStrings, $section)
    EndIf

    Local $sectionSize = Number($end - $start)
    Local $sectionSizeMB = Number($sectionSize) / Number(1048576) ; 1024 * 1024 = 1048576

    Local $maxReadSize = 1 * 1024 * 1024 ; 1 MB max for direct read (reduced for safety)
    Local $maxReadSizeMB = 1.0

    If $sectionSize > $maxReadSize Then
        Return GwAu3_Scanner_FindMultipleStringsFallback($aStrings, $section)
    EndIf

    Local $sectionBuffer = DllStructCreate("byte[" & $sectionSize & "]")
    If @error Then
        Return GwAu3_Scanner_FindMultipleStringsFallback($aStrings, $section)
    EndIf

    Local $bytesRead = 0
    Local $success = DllCall($mKernelHandle, "bool", "ReadProcessMemory", _
        "handle", $mGWProcHandle, _
        "ptr", $start, _
        "ptr", DllStructGetPtr($sectionBuffer), _
        "ulong_ptr", $sectionSize, _
        "ulong_ptr*", $bytesRead)

    If @error Or Not $success[0] Or $success[5] < $sectionSize Then
        GwAu3_Log_Warning("Failed to read section into memory. Read " & $success[5] & "/" & $sectionSize & " bytes. Using fallback method.", "GwAu3_Scanner_FindMultipleStrings", $g_h_EditText)
        Return GwAu3_Scanner_FindMultipleStringsFallback($aStrings, $section)
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

Func GwAu3_Scanner_FindMultipleStringsFallback($aStrings, $section = $SECTION_RDATA)
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
        $patterns[$i] = GwAu3_Utils_StringToBytes($aStrings[$i])
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

Func GwAu3_Scanner_GetMultipleAssertionPatterns($aAssertions)
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
        GwAu3_Scanner_InitializeSections(GwAu3_Scanner_GWBaseAddress())
    EndIf

    Local $addresses = GwAu3_Scanner_FindMultipleStrings($allStrings)

    Local $stringToAddress[0][2] ; [string, address]
    For $i = 0 To UBound($allStrings) - 1
        If $addresses[$i] > 0 Then
            GwAu3_Utils_ArrayAdd2D($stringToAddress, $allStrings[$i], $addresses[$i])
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
            $patterns[$assertIdx] = "BA" & GwAu3_Utils_SwapEndian(Hex($fileAddr, 8)) & "B9" & GwAu3_Utils_SwapEndian(Hex($msgAddr, 8))

            Local $cacheIdx = UBound($g_AssertionCache)
            ReDim $g_AssertionCache[$cacheIdx + 1][3]
            $g_AssertionCache[$cacheIdx][0] = $uncachedAssertions[$i][1]
            $g_AssertionCache[$cacheIdx][1] = $uncachedAssertions[$i][2]
            $g_AssertionCache[$cacheIdx][2] = $patterns[$assertIdx]
        EndIf
    Next

    Return $patterns
EndFunc

Func GwAu3_Scanner_FunctionFromNearCall($call_instruction_address)
    Local $opcode = GwAu3_Memory_Read($call_instruction_address, "byte")
    Local $function_address = 0

    Switch $opcode
        Case 0xE8, 0xE9
            Local $near_address = GwAu3_Memory_Read($call_instruction_address + 1, "dword")
            If $near_address > 0x7FFFFFFF Then
                $near_address -= 0x100000000
            EndIf
            $function_address = $near_address + ($call_instruction_address + 5)

        Case 0xEB
            Local $near_address = GwAu3_Memory_Read($call_instruction_address + 1, "byte")
            If BitAND($near_address, 0x80) Then
                $near_address = -((BitNOT($near_address) + 1) And 0xFF)
            EndIf
            $function_address = $near_address + ($call_instruction_address + 2)

        Case Else
            Return 0
    EndSwitch

    Local $nested_call = GwAu3_Scanner_FunctionFromNearCall($function_address)
    If $nested_call <> 0 Then
        Return $nested_call
    EndIf

    Return $function_address
EndFunc

Func GwAu3_Scanner_FindInRange($pattern, $mask, $offset, $start, $end)
    Local $patternBytes = GwAu3_Utils_StringToByteArray($pattern)
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
            Local $firstByte = GwAu3_Memory_Read($i, 'byte')
            If $firstByte <> $patternBytes[0] Then
                $i -= 1
                ContinueLoop
            EndIf

            $found = True
            For $idx = 0 To $patternLength - 1
                If $mask <> "" And StringMid($mask, $idx + 1, 1) <> "x" Then
                    ContinueLoop
                EndIf

                Local $memByte = GwAu3_Memory_Read($i + $idx, 'byte')
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
            Local $firstByte = GwAu3_Memory_Read($i, 'byte')
            If $firstByte <> $patternBytes[0] Then
                $i += 1
                ContinueLoop
            EndIf

            $found = True
            For $idx = 0 To $patternLength - 1
                If $mask <> "" And StringMid($mask, $idx + 1, 1) <> "x" Then
                    ContinueLoop
                EndIf

                Local $memByte = GwAu3_Memory_Read($i + $idx, 'byte')
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

Func GwAu3_Scanner_ToFunctionStart($call_instruction_address, $scan_range = 0x200)
    If $call_instruction_address = 0 Then Return 0

    Local $start = $call_instruction_address
    Local $end = BitAND($call_instruction_address - $scan_range, 0xFFFFFFFF)

    Return GwAu3_Scanner_FindInRange("558BEC", "xxx", 0, $start, $end)
EndFunc

Func GwAu3_Scanner_GetHwnd($aProc)
    Local $wins = WinList()
    For $i = 1 To UBound($wins) - 1
        If (WinGetProcess($wins[$i][1]) == $aProc) And (BitAND(WinGetState($wins[$i][1]), 2)) Then Return $wins[$i][1]
    Next
EndFunc

Func GwAu3_Scanner_GetWindowHandle()
    Return $mGWWindowHandle
EndFunc

Func GwAu3_Scanner_GetLoggedCharNames()
    Local $array = GwAu3_Scanner_ScanGW()
    If $array[0] == 0 Then Return ''
    Local $ret = $array[1]
    For $i = 2 To $array[0]
        $ret &= "|" & $array[$i]
    Next
    Return $ret
EndFunc

Func GwAu3_Scanner_ScanGW()
    Local $lProcessList = ProcessList("gw.exe")
    Local $lReturnArray[1] = [0]
    Local $lPid

    For $i = 1 To $lProcessList[0][0]
        GwAu3_Memory_Open($lProcessList[$i][1])

        If $mGWProcHandle Then
            $lReturnArray[0] += 1
            ReDim $lReturnArray[$lReturnArray[0] + 1]
            $lReturnArray[$lReturnArray[0]] = GwAu3_Scanner_ScanForCharname()
        EndIf

        GwAu3_Memory_Close()

        $mGWProcHandle = 0
    Next

    Return $lReturnArray
EndFunc

Func GwAu3_Scanner_ScanForProcess()
    Local $lCharNameCode = BinaryToString('0x558BEC83EC105356578B7D0833F63BFE')
    Local $lCurrentSearchAddress = 0x00000000
    Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
    Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

    While $lCurrentSearchAddress < 0x01F00000
        Local $lMBI[7]
        DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
        For $i = 0 To 6
            $lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
        Next
        If $lMBI[4] = 4096 Then
            Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
            DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

            $lTmpMemData = DllStructGetData($lBuffer, 1)
            $lTmpMemData = BinaryToString($lTmpMemData)

            $lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
            If $lSearch > 0 Then
                Return $lMBI[0]
            EndIf
        EndIf
        $lCurrentSearchAddress += $lMBI[3]
    WEnd
    Return ''
EndFunc

Func GwAu3_Scanner_ScanForCharname()
    Local $lCharNameCode = BinaryToString('0x6A14FF751868')
    Local $lCurrentSearchAddress = 0x00000000
    Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
    Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

    While $lCurrentSearchAddress < 0x01F00000
        Local $lMBI[7]
        DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
        For $i = 0 To 6
            $lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
        Next
        If $lMBI[4] = 4096 Then
            Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
            DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

            $lTmpMemData = DllStructGetData($lBuffer, 1)
            $lTmpMemData = BinaryToString($lTmpMemData)

            $lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
            If $lSearch > 0 Then
                $lTmpAddress = $lCurrentSearchAddress + $lSearch - 1
                DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lTmpAddress + 6, 'ptr', DllStructGetPtr($lTmpBuffer), 'int', DllStructGetSize($lTmpBuffer), 'int', '')
                $mCharname = DllStructGetData($lTmpBuffer, 1)
                Return GwAu3_OtherMod_GetCharname()
            EndIf
        EndIf
        $lCurrentSearchAddress += $lMBI[3]
    WEnd
    Return ''
EndFunc

; Add a pattern to the scan list
Func GwAu3_Scanner_AddPattern($sName, $sPattern, $iOffsetOrMsg = 0, $sType = 'Ptr')
    Local $iIndex = $g_aPatterns[0][0] + 1
    ReDim $g_aPatterns[$iIndex + 1][6]
    $g_aPatterns[0][0] = $iIndex

    ; Build full name with prefix and suffix
    Local $sFullName = 'Scan' & $sName & $sType

    ; Check if it's an assertion pattern
    Local $bIsAssertion = False
    Local $sAssertionMsg = ""

    If StringInStr($sPattern, ":\") Or StringInStr($sPattern, ":/") Then
        ; This is a file path, so it's an assertion
        $bIsAssertion = True
        $sAssertionMsg = $iOffsetOrMsg

        ; Add to assertion list
        Local $iAssertIndex = UBound($g_aAssertionPatterns)
        ReDim $g_aAssertionPatterns[$iAssertIndex + 1][2]
        $g_aAssertionPatterns[$iAssertIndex][0] = $sPattern
        $g_aAssertionPatterns[$iAssertIndex][1] = $sAssertionMsg
    EndIf

    ; Store pattern information
    $g_aPatterns[$iIndex][0] = $sFullName
    $g_aPatterns[$iIndex][1] = $sPattern
    $g_aPatterns[$iIndex][2] = $bIsAssertion ? 0 : $iOffsetOrMsg ; Offset if not assertion
    $g_aPatterns[$iIndex][3] = $sType
    $g_aPatterns[$iIndex][4] = $bIsAssertion
    $g_aPatterns[$iIndex][5] = $sAssertionMsg
EndFunc

; Clear all patterns
Func GwAu3_Scanner_ClearPatterns()
    ReDim $g_aPatterns[1][6]
    $g_aPatterns[0][0] = 0
    ReDim $g_aAssertionPatterns[0][2]
EndFunc

; Get pattern info by original name
Func GwAu3_Scanner_GetPatternInfo($sName, $sType = '')
    Local $sSearchName = 'Scan' & $sName & $sType
    For $i = 1 To $g_aPatterns[0][0]
        If $g_aPatterns[$i][0] = $sSearchName Or _
           ($sType = '' And StringInStr($g_aPatterns[$i][0], 'Scan' & $sName)) Then
            Local $aInfo[6]
            For $j = 0 To 5
                $aInfo[$j] = $g_aPatterns[$i][$j]
            Next
            Return $aInfo
        EndIf
    Next
    Return 0
EndFunc

; Scan all patterns and return results
Func GwAu3_Scanner_ScanAllPatterns()
    Local $lGwBase = GwAu3_Scanner_ScanForProcess()
    Local $aResults[$g_aPatterns[0][0] + 1]
    $aResults[0] = $g_aPatterns[0][0]

    ; Handle assertion patterns first if any exist
    If UBound($g_aAssertionPatterns) > 0 Then
        Local $assertionPatterns = GwAu3_Scanner_GetMultipleAssertionPatterns($g_aAssertionPatterns)

        ; Update assertion patterns with actual patterns
        Local $iAssertIdx = 0
        For $i = 1 To $g_aPatterns[0][0]
            If $g_aPatterns[$i][4] Then ; Is assertion
                $g_aPatterns[$i][1] = $assertionPatterns[$iAssertIdx]
                $iAssertIdx += 1
            EndIf
        Next
    EndIf

    ; Create ASM for scanning
    $mASMSize = 0
    $mASMCodeOffset = 0
    $mASMString = ''

    _('MainModPtr/4')

    ; Add all patterns to ASM
    For $i = 1 To $g_aPatterns[0][0]
        _($g_aPatterns[$i][0] & ':')
        GwAu3_Scanner_AddPatternToASM($g_aPatterns[$i][1])
    Next

    ; Add scan procedure
    GwAu3_Assembler_CreateScanProcedure($lGwBase)

    ; Execute scan
    $mBase = $lGwBase + 0x9DF000
    Local $lScanMemory = GwAu3_Memory_Read($mBase, 'ptr')

    If $lScanMemory = 0 Then
        $mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 0x40)
        $mMemory = $mMemory[0]
        GwAu3_Memory_Write($mBase, $mMemory)
    Else
        $mMemory = $lScanMemory
    EndIf

    GwAu3_Assembler_CompleteASMCode()

    If $lScanMemory = 0 Then
        GwAu3_Memory_WriteBinary($mASMString, $mMemory + $mASMCodeOffset)

        Local $lThread = DllCall($mKernelHandle, 'int', 'CreateRemoteThread', 'int', $mGWProcHandle, 'ptr', 0, 'int', 0, 'int', GwAu3_Memory_GetLabelInfo('ScanProc'), 'ptr', 0, 'int', 0, 'int', 0)
        $lThread = $lThread[0]

        Local $lResult
        Do
            $lResult = DllCall($mKernelHandle, 'int', 'WaitForSingleObject', 'int', $lThread, 'int', 50)
        Until $lResult[0] <> 258

        DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $lThread)
    EndIf

    ; Collect results using GwAu3_Memory_GetScannedAddress which does the proper calculation
    For $i = 1 To $g_aPatterns[0][0]
        $aResults[$i] = GwAu3_Memory_GetScannedAddress($g_aPatterns[$i][0], $g_aPatterns[$i][2])
    Next

    Return $aResults
EndFunc

; Get a specific scan result by original name and optional type
Func GwAu3_Scanner_GetScanResult($sName, $aResults = 0, $sType = '')
    If Not IsArray($aResults) Then Return 0

    Local $sSearchName = 'Scan' & $sName & $sType

    For $i = 1 To $g_aPatterns[0][0]
        If $g_aPatterns[$i][0] = $sSearchName Or _
           ($sType = '' And StringInStr($g_aPatterns[$i][0], 'Scan' & $sName)) Then
            Return $aResults[$i]
        EndIf
    Next

    Return 0
EndFunc

; Helper function to add pattern to ASM
Func GwAu3_Scanner_AddPatternToASM($aPattern)

	$aPattern = StringReplace($aPattern, "??", "00")

    Local $lSize = Int(0.5 * StringLen($aPattern))
    Local $pattern_header = "00000000" & _
                           GwAu3_Utils_SwapEndian(Hex($lSize, 8)) & _
                           "00000000"

    $mASMString &= $pattern_header & $aPattern
    $mASMSize += $lSize + 12

    Local $padding_count = 68 - $lSize
    For $i = 1 To $padding_count
        $mASMSize += 1
        $mASMString &= "00"
    Next
EndFunc
