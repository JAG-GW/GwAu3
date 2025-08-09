#include-once

Func Scanner_GWBaseAddress()
    If $g_h_GWProcess = 0 Then
        Log_Error("Invalid process handle", "Memory", $g_h_EditText)
        Return 0
    EndIf

    Local $l_d_Modules = DllStructCreate("ptr[1024]")
    Local $l_d_CbNeeded = DllStructCreate("dword")

    Local $l_h_PSAPI = DllOpen("psapi.dll")
    If @error Then
        Log_Error("Failed to open psapi.dll", "Memory", $g_h_EditText)
        Return 0
    EndIf

    Local $l_b_Success = DllCall($l_h_PSAPI, "bool", "EnumProcessModules", _
        "handle", $g_h_GWProcess, _
        "ptr", DllStructGetPtr($l_d_Modules), _
        "dword", DllStructGetSize($l_d_Modules), _
        "ptr", DllStructGetPtr($l_d_CbNeeded))

    If @error Or Not $l_b_Success[0] Then
        Log_Error("EnumProcessModules failed", "Memory", $g_h_EditText)
        DllClose($l_h_PSAPI)
        Return 0
    EndIf

    Local $l_i_ModuleCount = DllStructGetData($l_d_CbNeeded, 1) / 4

    For $l_i_Idx = 1 To $l_i_ModuleCount
        Local $l_p_ModuleBase = DllStructGetData($l_d_Modules, 1, $l_i_Idx)

        Local $l_s_ModuleName = _WinAPI_GetModuleFileNameEx($g_h_GWProcess, $l_p_ModuleBase)

        If StringInStr($l_s_ModuleName, "Gw.exe", 1) Then
            DllClose($l_h_PSAPI)
            Return $l_p_ModuleBase
        EndIf
    Next

    Log_Error("Gw.exe module not found", "Memory", $g_h_EditText)
    DllClose($l_h_PSAPI)
    Return 0
EndFunc

Func Scanner_InitializeSections($a_p_BaseAddress)
    Local $l_d_DosHeader = DllStructCreate("struct;word e_magic;byte[58];dword e_lfanew;endstruct")
    Local $l_b_Success = _WinAPI_ReadProcessMemory($g_h_GWProcess, $a_p_BaseAddress, DllStructGetPtr($l_d_DosHeader), DllStructGetSize($l_d_DosHeader), 0)
    If Not $l_b_Success Then
        Log_Error("Failed to read DOS header", "Sections", $g_h_EditText)
        Return False
    EndIf

    If DllStructGetData($l_d_DosHeader, "e_magic") <> 0x5A4D Then ; 'MZ'
        Log_Error("Invalid DOS signature", "Sections", $g_h_EditText)
        Return False
    EndIf

    Local $l_i_ELfanew = DllStructGetData($l_d_DosHeader, "e_lfanew")

    Local $l_d_NtHeaders = DllStructCreate("struct;dword Signature;word Machine;word NumberOfSections;dword TimeDateStamp;dword PointerToSymbolTable;dword NumberOfSymbols;word SizeOfOptionalHeader;word Characteristics;endstruct")
    $l_b_Success = _WinAPI_ReadProcessMemory($g_h_GWProcess, $a_p_BaseAddress + $l_i_ELfanew, DllStructGetPtr($l_d_NtHeaders), DllStructGetSize($l_d_NtHeaders), 0)
    If Not $l_b_Success Then
        Log_Error("Failed to read NT headers", "Sections", $g_h_EditText)
        Return False
    EndIf

    If DllStructGetData($l_d_NtHeaders, "Signature") <> 0x4550 Then ; 'PE\0\0'
        Log_Error("Invalid PE signature", "Sections", $g_h_EditText)
        Return False
    EndIf

    Local $l_i_NumberOfSections = DllStructGetData($l_d_NtHeaders, "NumberOfSections")
    Local $l_i_SizeOfOptionalHeader = DllStructGetData($l_d_NtHeaders, "SizeOfOptionalHeader")
    Local $l_i_SectionHeaderOffset = $l_i_ELfanew + 24 + $l_i_SizeOfOptionalHeader

    For $l_i_Idx = 0 To 4
        $g_ai2_Sections[$l_i_Idx][0] = 0
        $g_ai2_Sections[$l_i_Idx][1] = 0
    Next

    Local $l_d_SectionHeader = DllStructCreate("struct;" & _
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

    For $l_i_Idx = 0 To $l_i_NumberOfSections - 1
        $l_b_Success = _WinAPI_ReadProcessMemory($g_h_GWProcess, $a_p_BaseAddress + $l_i_SectionHeaderOffset + ($l_i_Idx * 40), DllStructGetPtr($l_d_SectionHeader), DllStructGetSize($l_d_SectionHeader), 0)
        If Not $l_b_Success Then
            Log_Warning("Failed to read section header " & $l_i_Idx, "Sections", $g_h_EditText)
            ContinueLoop
        EndIf

        Local $l_s_SectionName = StringStripWS(DllStructGetData($l_d_SectionHeader, "Name"), 8)
        Local $l_i_VirtualAddress = DllStructGetData($l_d_SectionHeader, "VirtualAddress")
        Local $l_i_VirtualSize = DllStructGetData($l_d_SectionHeader, "VirtualSize")
        Local $l_i_SizeRawData = DllStructGetData($l_d_SectionHeader, "SizeOfRawData")

        Local $l_i_ActualSize = $l_i_VirtualSize > $l_i_SizeRawData ? $l_i_VirtualSize : $l_i_SizeRawData

        Switch $l_s_SectionName
            Case ".text"
                $g_ai2_Sections[$GC_I_SECTION_TEXT][0] = $a_p_BaseAddress + $l_i_VirtualAddress
                $g_ai2_Sections[$GC_I_SECTION_TEXT][1] = $g_ai2_Sections[$GC_I_SECTION_TEXT][0] + $l_i_ActualSize

            Case ".rdata"
                $g_ai2_Sections[$GC_I_SECTION_RDATA][0] = $a_p_BaseAddress + $l_i_VirtualAddress
                $g_ai2_Sections[$GC_I_SECTION_RDATA][1] = $g_ai2_Sections[$GC_I_SECTION_RDATA][0] + $l_i_ActualSize

            Case ".data"
                $g_ai2_Sections[$GC_I_SECTION_DATA][0] = $a_p_BaseAddress + $l_i_VirtualAddress
                $g_ai2_Sections[$GC_I_SECTION_DATA][1] = $g_ai2_Sections[$GC_I_SECTION_DATA][0] + $l_i_ActualSize

            Case ".rsrc"
                $g_ai2_Sections[$GC_I_SECTION_RSRC][0] = $a_p_BaseAddress + $l_i_VirtualAddress
                $g_ai2_Sections[$GC_I_SECTION_RSRC][1] = $g_ai2_Sections[$GC_I_SECTION_RSRC][0] + $l_i_ActualSize

            Case ".reloc"
                $g_ai2_Sections[$GC_I_SECTION_RELOC][0] = $a_p_BaseAddress + $l_i_VirtualAddress
                $g_ai2_Sections[$GC_I_SECTION_RELOC][1] = $g_ai2_Sections[$GC_I_SECTION_RELOC][0] + $l_i_ActualSize
        EndSwitch
    Next

    If $g_ai2_Sections[$GC_I_SECTION_TEXT][0] = 0 Then
        Log_Error("Failed to find .text section", "Sections", $g_h_EditText)
        Return False
    EndIf

    Return True
EndFunc

Func Scanner_FindMultipleStrings($a_as_Strings, $a_i_Section = $GC_I_SECTION_RDATA)
    If $g_ai2_Sections[$a_i_Section][0] = 0 Or $g_ai2_Sections[$a_i_Section][1] = 0 Then
        Local $l_p_BaseAddr = Scanner_GWBaseAddress()
        If $l_p_BaseAddr = 0 Then
            Log_Error("Failed to get GW base address", "Scanner_FindMultipleStrings", $g_h_EditText)
            Local $l_ai_EmptyResults[UBound($a_as_Strings)]
            For $l_i_Idx = 0 To UBound($a_as_Strings) - 1
                $l_ai_EmptyResults[$l_i_Idx] = 0
            Next
            Return $l_ai_EmptyResults
        EndIf

        If Not Scanner_InitializeSections($l_p_BaseAddr) Then
            Log_Error("Failed to initialize sections", "Scanner_FindMultipleStrings", $g_h_EditText)
            Local $l_ai_EmptyResults[UBound($a_as_Strings)]
            For $l_i_Idx = 0 To UBound($a_as_Strings) - 1
                $l_ai_EmptyResults[$l_i_Idx] = 0
            Next
            Return $l_ai_EmptyResults
        EndIf
    EndIf

    Local $l_i_StringCount = UBound($a_as_Strings)
    Local $l_ai_Results[$l_i_StringCount]
    Local $l_ab_Found[$l_i_StringCount]
    Local $l_ax_Patterns[$l_i_StringCount]
    Local $l_ai_Lengths[$l_i_StringCount]
    Local $l_ai2_SkipTables[$l_i_StringCount][256]

    For $l_i_Idx = 0 To $l_i_StringCount - 1
        $l_ai_Results[$l_i_Idx] = 0
        $l_ab_Found[$l_i_Idx] = False
        $l_ax_Patterns[$l_i_Idx] = Utils_StringToBytes($a_as_Strings[$l_i_Idx])
        $l_ai_Lengths[$l_i_Idx] = BinaryLen($l_ax_Patterns[$l_i_Idx])

        For $l_i_ByteIdx = 0 To 255
            $l_ai2_SkipTables[$l_i_Idx][$l_i_ByteIdx] = $l_ai_Lengths[$l_i_Idx]
        Next

        For $l_i_PatternIdx = 0 To $l_ai_Lengths[$l_i_Idx] - 2
            Local $l_i_Byte = Number(BinaryMid($l_ax_Patterns[$l_i_Idx], $l_i_PatternIdx + 1, 1))
            $l_ai2_SkipTables[$l_i_Idx][$l_i_Byte] = $l_ai_Lengths[$l_i_Idx] - $l_i_PatternIdx - 1
        Next
    Next

    Local $l_p_Start = $g_ai2_Sections[$a_i_Section][0]
    Local $l_p_End = $g_ai2_Sections[$a_i_Section][1]

    If $l_p_Start = 0 Or $l_p_End = 0 Or $l_p_Start >= $l_p_End Then
        Log_Warning("Invalid section bounds. Start: " & Hex($l_p_Start) & ", End: " & Hex($l_p_End), "Scanner_FindMultipleStrings", $g_h_EditText)
        Return Scanner_FindMultipleStringsFallback($a_as_Strings, $a_i_Section)
    EndIf

    Local $l_i_SectionSize = Number($l_p_End - $l_p_Start)
    Local $l_f_SectionSizeMB = Number($l_i_SectionSize) / Number(1048576)

    Local $l_i_MaxReadSize = 1 * 1024 * 1024
    Local $l_f_MaxReadSizeMB = 1.0

    If $l_i_SectionSize > $l_i_MaxReadSize Then
        Return Scanner_FindMultipleStringsFallback($a_as_Strings, $a_i_Section)
    EndIf

    Local $l_d_SectionBuffer = DllStructCreate("byte[" & $l_i_SectionSize & "]")
    If @error Then
        Return Scanner_FindMultipleStringsFallback($a_as_Strings, $a_i_Section)
    EndIf

    Local $l_i_BytesRead = 0
    Local $l_ab_Success = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
        "handle", $g_h_GWProcess, _
        "ptr", $l_p_Start, _
        "ptr", DllStructGetPtr($l_d_SectionBuffer), _
        "ulong_ptr", $l_i_SectionSize, _
        "ulong_ptr*", $l_i_BytesRead)

    If @error Or Not $l_ab_Success[0] Or $l_ab_Success[5] < $l_i_SectionSize Then
        Log_Warning("Failed to read section into memory. Read " & $l_ab_Success[5] & "/" & $l_i_SectionSize & " bytes. Using fallback method.", "Scanner_FindMultipleStrings", $g_h_EditText)
        Return Scanner_FindMultipleStringsFallback($a_as_Strings, $a_i_Section)
    EndIf

    Local $l_i_TotalFound = 0
    Local $l_i_StartTime = TimerInit()

    For $l_i_PatternIdx = 0 To $l_i_StringCount - 1
        If $l_ab_Found[$l_i_PatternIdx] Then ContinueLoop

        Local $l_i_PatternLen = $l_ai_Lengths[$l_i_PatternIdx]
        Local $l_i_Pos = $l_i_PatternLen - 1

        While $l_i_Pos < $l_i_SectionSize
            Local $l_b_Match = True
            Local $l_i_CheckIdx = $l_i_PatternLen - 1

            While $l_i_CheckIdx >= 0
                Local $l_i_MemByte = DllStructGetData($l_d_SectionBuffer, 1, $l_i_Pos - ($l_i_PatternLen - 1 - $l_i_CheckIdx) + 1)
                Local $l_i_PatByte = Number(BinaryMid($l_ax_Patterns[$l_i_PatternIdx], $l_i_CheckIdx + 1, 1))

                If $l_i_MemByte <> $l_i_PatByte Then
                    $l_b_Match = False
                    $l_i_Pos += $l_ai2_SkipTables[$l_i_PatternIdx][$l_i_MemByte]
                    ExitLoop
                EndIf
                $l_i_CheckIdx -= 1
            WEnd

            If $l_b_Match Then
                $l_ai_Results[$l_i_PatternIdx] = $l_p_Start + $l_i_Pos - ($l_i_PatternLen - 1)
                $l_ab_Found[$l_i_PatternIdx] = True
                $l_i_TotalFound += 1
                ExitLoop
            EndIf
        WEnd

        If $l_i_TotalFound = $l_i_StringCount Then ExitLoop
    Next

    Return $l_ai_Results
EndFunc

Func Scanner_FindMultipleStringsFallback($a_as_Strings, $a_i_Section = $GC_I_SECTION_RDATA)
    Local $l_i_StringCount = UBound($a_as_Strings)
    Local $l_ai_Results[$l_i_StringCount]
    Local $l_ab_Found[$l_i_StringCount]
    Local $l_ax_Patterns[$l_i_StringCount]
    Local $l_ai_Lengths[$l_i_StringCount]
    Local $l_ai_FirstBytes[$l_i_StringCount]
    Local $l_as_HashTable[256]
    Local $l_i_MinLength = 999999
    Local $l_i_MaxLength = 0

    For $l_i_Idx = 0 To 255
        $l_as_HashTable[$l_i_Idx] = ""
    Next

    For $l_i_Idx = 0 To $l_i_StringCount - 1
        $l_ai_Results[$l_i_Idx] = 0
        $l_ab_Found[$l_i_Idx] = False
        $l_ax_Patterns[$l_i_Idx] = Utils_StringToBytes($a_as_Strings[$l_i_Idx])
        $l_ai_Lengths[$l_i_Idx] = BinaryLen($l_ax_Patterns[$l_i_Idx])
        $l_ai_FirstBytes[$l_i_Idx] = Number(BinaryMid($l_ax_Patterns[$l_i_Idx], 1, 1))

        If $l_ai_Lengths[$l_i_Idx] < $l_i_MinLength Then $l_i_MinLength = $l_ai_Lengths[$l_i_Idx]
        If $l_ai_Lengths[$l_i_Idx] > $l_i_MaxLength Then $l_i_MaxLength = $l_ai_Lengths[$l_i_Idx]

        If $l_as_HashTable[$l_ai_FirstBytes[$l_i_Idx]] = "" Then
            $l_as_HashTable[$l_ai_FirstBytes[$l_i_Idx]] = String($l_i_Idx)
        Else
            $l_as_HashTable[$l_ai_FirstBytes[$l_i_Idx]] &= "," & $l_i_Idx
        EndIf
    Next

    Local $l_p_Start = $g_ai2_Sections[$a_i_Section][0]
    Local $l_p_End = $g_ai2_Sections[$a_i_Section][1]
    Local $l_i_BufferSize = 2097152
    Local $l_d_Buffer = DllStructCreate("byte[" & $l_i_BufferSize & "]")
    Local $l_i_TotalFound = 0
    Local $l_i_StartTime = TimerInit()
    Local $l_i_Overlap = $l_i_MaxLength - 1

    Local $l_ai2_PatternData[$l_i_StringCount][$l_i_MaxLength]
    For $l_i_Idx = 0 To $l_i_StringCount - 1
        For $l_i_ByteIdx = 0 To $l_ai_Lengths[$l_i_Idx] - 1
            $l_ai2_PatternData[$l_i_Idx][$l_i_ByteIdx] = Number(BinaryMid($l_ax_Patterns[$l_i_Idx], $l_i_ByteIdx + 1, 1))
        Next
    Next

    For $l_p_CurrentAddr = $l_p_Start To $l_p_End Step $l_i_BufferSize - $l_i_Overlap
        If $l_i_TotalFound = $l_i_StringCount Then ExitLoop

        Local $l_i_ReadSize = $l_i_BufferSize
        If $l_p_CurrentAddr + $l_i_ReadSize > $l_p_End Then
            $l_i_ReadSize = $l_p_End - $l_p_CurrentAddr
        EndIf

        Local $l_i_BytesRead = 0
        Local $l_ab_Success = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentAddr, _
            "ptr", DllStructGetPtr($l_d_Buffer), _
            "ulong_ptr", $l_i_ReadSize, _
            "ulong_ptr*", $l_i_BytesRead)

        If @error Or Not $l_ab_Success[0] Or $l_ab_Success[5] = 0 Then ContinueLoop

        $l_i_ReadSize = $l_ab_Success[5]

        Local $l_i_SearchEnd = $l_i_ReadSize - $l_i_MinLength + 1
        For $l_i_SearchIdx = 0 To $l_i_SearchEnd - 1
            Local $l_i_Byte = DllStructGetData($l_d_Buffer, 1, $l_i_SearchIdx + 1)

            If $l_as_HashTable[$l_i_Byte] = "" Then ContinueLoop

            Local $l_as_Indices = StringSplit($l_as_HashTable[$l_i_Byte], ",", 2)

            For $l_i_IndexIdx = 0 To UBound($l_as_Indices) - 1
                Local $l_i_PatternIdx = Number($l_as_Indices[$l_i_IndexIdx])
                If $l_ab_Found[$l_i_PatternIdx] Then ContinueLoop

                Local $l_i_PatternLen = $l_ai_Lengths[$l_i_PatternIdx]

                If $l_i_SearchIdx + $l_i_PatternLen > $l_i_ReadSize Then ContinueLoop

                Local $l_b_Match = True

                Local $l_i_MidPoint = Int($l_i_PatternLen / 2)
                If DllStructGetData($l_d_Buffer, 1, $l_i_SearchIdx + $l_i_MidPoint + 1) <> $l_ai2_PatternData[$l_i_PatternIdx][$l_i_MidPoint] Then ContinueLoop

                If DllStructGetData($l_d_Buffer, 1, $l_i_SearchIdx + $l_i_PatternLen) <> $l_ai2_PatternData[$l_i_PatternIdx][$l_i_PatternLen - 1] Then ContinueLoop

                For $l_i_CompareIdx = 1 To $l_i_PatternLen - 2
                    If $l_i_CompareIdx = $l_i_MidPoint Then ContinueLoop
                    If DllStructGetData($l_d_Buffer, 1, $l_i_SearchIdx + $l_i_CompareIdx + 1) <> $l_ai2_PatternData[$l_i_PatternIdx][$l_i_CompareIdx] Then
                        $l_b_Match = False
                        ExitLoop
                    EndIf
                Next

                If $l_b_Match Then
                    $l_ai_Results[$l_i_PatternIdx] = $l_p_CurrentAddr + $l_i_SearchIdx
                    $l_ab_Found[$l_i_PatternIdx] = True
                    $l_i_TotalFound += 1

                    Local $l_s_NewIndices = ""
                    For $l_i_RemoveIdx = 0 To UBound($l_as_Indices) - 1
                        If Number($l_as_Indices[$l_i_RemoveIdx]) <> $l_i_PatternIdx Then
                            If $l_s_NewIndices = "" Then
                                $l_s_NewIndices = $l_as_Indices[$l_i_RemoveIdx]
                            Else
                                $l_s_NewIndices &= "," & $l_as_Indices[$l_i_RemoveIdx]
                            EndIf
                        EndIf
                    Next
                    $l_as_HashTable[$l_i_Byte] = $l_s_NewIndices

                    If $l_i_TotalFound = $l_i_StringCount Then ExitLoop 3
                EndIf
            Next
        Next
    Next

    Local $l_f_ElapsedTime = TimerDiff($l_i_StartTime)

    Return $l_ai_Results
EndFunc

Func Scanner_GetMultipleAssertionPatterns($a_amx_Assertions)
    Local $l_i_AssertionCount = UBound($a_amx_Assertions)
    Local $l_as_Patterns[$l_i_AssertionCount]

    Local $l_amx_UncachedAssertions[0][3]
    Local $l_as_AllStrings[0]

    For $l_i_Idx = 0 To $l_i_AssertionCount - 1
        Local $l_b_Cached = False
        For $l_i_CacheIdx = 0 To UBound($g_amx_AssertionCache) - 1
            If $g_amx_AssertionCache[$l_i_CacheIdx][0] = $a_amx_Assertions[$l_i_Idx][0] And $g_amx_AssertionCache[$l_i_CacheIdx][1] = $a_amx_Assertions[$l_i_Idx][1] Then
                $l_as_Patterns[$l_i_Idx] = $g_amx_AssertionCache[$l_i_CacheIdx][2]
                $l_b_Cached = True
                ExitLoop
            EndIf
        Next

        If Not $l_b_Cached Then
            Local $l_i_UncachedIdx = UBound($l_amx_UncachedAssertions)
            ReDim $l_amx_UncachedAssertions[$l_i_UncachedIdx + 1][3]
            $l_amx_UncachedAssertions[$l_i_UncachedIdx][0] = $l_i_Idx
            $l_amx_UncachedAssertions[$l_i_UncachedIdx][1] = $a_amx_Assertions[$l_i_Idx][0]
            $l_amx_UncachedAssertions[$l_i_UncachedIdx][2] = $a_amx_Assertions[$l_i_Idx][1]

            _ArrayAdd($l_as_AllStrings, $a_amx_Assertions[$l_i_Idx][0])
            _ArrayAdd($l_as_AllStrings, $a_amx_Assertions[$l_i_Idx][1])

            $l_as_Patterns[$l_i_Idx] = ""
        EndIf
    Next

    If UBound($l_amx_UncachedAssertions) = 0 Then
        Return $l_as_Patterns
    EndIf

    If $g_ai2_Sections[$GC_I_SECTION_RDATA][0] = 0 Then
        Scanner_InitializeSections(Scanner_GWBaseAddress())
    EndIf

    Local $l_ap_Addresses = Scanner_FindMultipleStrings($l_as_AllStrings)

    Local $l_amx_StringToAddress[0][2]
    For $l_i_Idx = 0 To UBound($l_as_AllStrings) - 1
        If $l_ap_Addresses[$l_i_Idx] > 0 Then
            Utils_ArrayAdd2D($l_amx_StringToAddress, $l_as_AllStrings[$l_i_Idx], $l_ap_Addresses[$l_i_Idx])
        EndIf
    Next

    For $l_i_Idx = 0 To UBound($l_amx_UncachedAssertions) - 1
        Local $l_i_AssertIdx = $l_amx_UncachedAssertions[$l_i_Idx][0]
        Local $l_p_FileAddr = 0
        Local $l_p_MsgAddr = 0

        For $l_i_LookupIdx = 0 To UBound($l_amx_StringToAddress) - 1
            If $l_amx_StringToAddress[$l_i_LookupIdx][0] = $l_amx_UncachedAssertions[$l_i_Idx][1] Then
                $l_p_FileAddr = $l_amx_StringToAddress[$l_i_LookupIdx][1]
            ElseIf $l_amx_StringToAddress[$l_i_LookupIdx][0] = $l_amx_UncachedAssertions[$l_i_Idx][2] Then
                $l_p_MsgAddr = $l_amx_StringToAddress[$l_i_LookupIdx][1]
            EndIf
        Next

        If $l_p_FileAddr > 0 And $l_p_MsgAddr > 0 Then
            $l_as_Patterns[$l_i_AssertIdx] = "BA" & Utils_SwapEndian(Hex($l_p_FileAddr, 8)) & "B9" & Utils_SwapEndian(Hex($l_p_MsgAddr, 8))

            Local $l_i_CacheIdx = UBound($g_amx_AssertionCache)
            ReDim $g_amx_AssertionCache[$l_i_CacheIdx + 1][3]
            $g_amx_AssertionCache[$l_i_CacheIdx][0] = $l_amx_UncachedAssertions[$l_i_Idx][1]
            $g_amx_AssertionCache[$l_i_CacheIdx][1] = $l_amx_UncachedAssertions[$l_i_Idx][2]
            $g_amx_AssertionCache[$l_i_CacheIdx][2] = $l_as_Patterns[$l_i_AssertIdx]
        EndIf
    Next

    Return $l_as_Patterns
EndFunc

Func Scanner_FunctionFromNearCall($a_p_CallInstructionAddress)
    Local $l_i_Opcode = Memory_Read($a_p_CallInstructionAddress, "byte")
    Local $l_p_FunctionAddress = 0

    Switch $l_i_Opcode
        Case 0xE8, 0xE9
            Local $l_i_NearAddress = Memory_Read($a_p_CallInstructionAddress + 1, "dword")
            If $l_i_NearAddress > 0x7FFFFFFF Then
                $l_i_NearAddress -= 0x100000000
            EndIf
            $l_p_FunctionAddress = $l_i_NearAddress + ($a_p_CallInstructionAddress + 5)

        Case 0xEB
            Local $l_i_NearAddress = Memory_Read($a_p_CallInstructionAddress + 1, "byte")
            If BitAND($l_i_NearAddress, 0x80) Then
                $l_i_NearAddress = -((BitNOT($l_i_NearAddress) + 1) And 0xFF)
            EndIf
            $l_p_FunctionAddress = $l_i_NearAddress + ($a_p_CallInstructionAddress + 2)

        Case Else
            Return 0
    EndSwitch

    Local $l_p_NestedCall = Scanner_FunctionFromNearCall($l_p_FunctionAddress)
    If $l_p_NestedCall <> 0 Then
        Return $l_p_NestedCall
    EndIf

    Return $l_p_FunctionAddress
EndFunc

Func Scanner_FindInRange($a_s_Pattern, $a_s_Mask, $a_i_Offset, $a_p_Start, $a_p_End)
    Local $l_ai_PatternBytes = Utils_StringToByteArray($a_s_Pattern)
    Local $l_i_PatternLength = UBound($l_ai_PatternBytes)
    Local $l_b_Found = False

    $a_p_Start = BitAND($a_p_Start, 0xFFFFFFFF)
    $a_p_End = BitAND($a_p_End, 0xFFFFFFFF)

    If $a_p_End > $a_p_Start Then
        $a_p_End = $a_p_End - $l_i_PatternLength + 1
    EndIf

    If $a_p_Start > $a_p_End Then
        Local $l_p_Idx = $a_p_Start
        While $l_p_Idx >= $a_p_End
            Local $l_i_FirstByte = Memory_Read($l_p_Idx, 'byte')
            If $l_i_FirstByte <> $l_ai_PatternBytes[0] Then
                $l_p_Idx -= 1
                ContinueLoop
            EndIf

            $l_b_Found = True
            For $l_i_ByteIdx = 0 To $l_i_PatternLength - 1
                If $a_s_Mask <> "" And StringMid($a_s_Mask, $l_i_ByteIdx + 1, 1) <> "x" Then
                    ContinueLoop
                EndIf

                Local $l_i_MemByte = Memory_Read($l_p_Idx + $l_i_ByteIdx, 'byte')
                If $l_i_MemByte <> $l_ai_PatternBytes[$l_i_ByteIdx] Then
                    $l_b_Found = False
                    ExitLoop
                EndIf
            Next

            If $l_b_Found Then
                Return $l_p_Idx + $a_i_Offset
            EndIf
            $l_p_Idx -= 1
        WEnd
    Else
        Local $l_p_Idx = $a_p_Start
        While $l_p_Idx < $a_p_End
            Local $l_i_FirstByte = Memory_Read($l_p_Idx, 'byte')
            If $l_i_FirstByte <> $l_ai_PatternBytes[0] Then
                $l_p_Idx += 1
                ContinueLoop
            EndIf

            $l_b_Found = True
            For $l_i_ByteIdx = 0 To $l_i_PatternLength - 1
                If $a_s_Mask <> "" And StringMid($a_s_Mask, $l_i_ByteIdx + 1, 1) <> "x" Then
                    ContinueLoop
                EndIf

                Local $l_i_MemByte = Memory_Read($l_p_Idx + $l_i_ByteIdx, 'byte')
                If $l_i_MemByte <> $l_ai_PatternBytes[$l_i_ByteIdx] Then
                    $l_b_Found = False
                    ExitLoop
                EndIf
            Next

            If $l_b_Found Then
                Return $l_p_Idx + $a_i_Offset
            EndIf
            $l_p_Idx += 1
        WEnd
    EndIf

    Return 0
EndFunc

Func Scanner_ToFunctionStart($a_p_CallInstructionAddress, $a_i_ScanRange = 0x200)
    If $a_p_CallInstructionAddress = 0 Then Return 0

    Local $l_p_Start = $a_p_CallInstructionAddress
    Local $l_p_End = BitAND($a_p_CallInstructionAddress - $a_i_ScanRange, 0xFFFFFFFF)

    Return Scanner_FindInRange("558BEC", "xxx", 0, $l_p_Start, $l_p_End)
EndFunc

Func Scanner_GetHwnd($a_i_Proc)
    Local $l_as_Wins = WinList()
    For $l_i_Idx = 1 To UBound($l_as_Wins) - 1
        If (WinGetProcess($l_as_Wins[$l_i_Idx][1]) == $a_i_Proc) And (BitAND(WinGetState($l_as_Wins[$l_i_Idx][1]), 2)) Then Return $l_as_Wins[$l_i_Idx][1]
    Next
EndFunc

Func Scanner_GetWindowHandle()
    Return $g_h_GWWindow
EndFunc

Func Scanner_GetLoggedCharNames()
    Local $l_as_Array = Scanner_ScanGW()
    If $l_as_Array[0] == 0 Then Return ''
    Local $l_s_Ret = $l_as_Array[1]
    For $l_i_Idx = 2 To $l_as_Array[0]
        $l_s_Ret &= "|" & $l_as_Array[$l_i_Idx]
    Next
    Return $l_s_Ret
EndFunc

Func Scanner_ScanGW()
    Local $l_as_ProcessList = ProcessList("gw.exe")
    Local $l_as_ReturnArray[1] = [0]
    Local $l_i_Pid

    For $l_i_Idx = 1 To $l_as_ProcessList[0][0]
        Memory_Open($l_as_ProcessList[$l_i_Idx][1])

        If $g_h_GWProcess Then
            $l_as_ReturnArray[0] += 1
            ReDim $l_as_ReturnArray[$l_as_ReturnArray[0] + 1]
            $l_as_ReturnArray[$l_as_ReturnArray[0]] = Scanner_ScanForCharname()
        EndIf

        Memory_Close()

        $g_h_GWProcess = 0
    Next

    Return $l_as_ReturnArray
EndFunc

Func Scanner_ScanForProcess()
    Local $l_s_CharNameCode = BinaryToString('0x558BEC83EC105356578B7D0833F63BFE')
    Local $l_p_CurrentSearchAddress = 0x00000000
    Local $l_ai_MBI[7], $l_d_MBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
    Local $l_i_Search, $l_s_TmpMemData, $l_d_TmpBuffer = DllStructCreate('ptr'), $l_i_Idx

    While $l_p_CurrentSearchAddress < 0x01F00000
        Local $l_ai_MBI[7]
        DllCall($g_h_Kernel32, 'int', 'VirtualQueryEx', 'int', $g_h_GWProcess, 'int', $l_p_CurrentSearchAddress, 'ptr', DllStructGetPtr($l_d_MBIBuffer), 'int', DllStructGetSize($l_d_MBIBuffer))
        For $l_i_Idx = 0 To 6
            $l_ai_MBI[$l_i_Idx] = StringStripWS(DllStructGetData($l_d_MBIBuffer, ($l_i_Idx + 1)), 3)
        Next
        If $l_ai_MBI[4] = 4096 Then
            Local $l_d_Buffer = DllStructCreate('byte[' & $l_ai_MBI[3] & ']')
            DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $l_p_CurrentSearchAddress, 'ptr', DllStructGetPtr($l_d_Buffer), 'int', DllStructGetSize($l_d_Buffer), 'int', '')

            $l_s_TmpMemData = DllStructGetData($l_d_Buffer, 1)
            $l_s_TmpMemData = BinaryToString($l_s_TmpMemData)

            $l_i_Search = StringInStr($l_s_TmpMemData, $l_s_CharNameCode, 2)
            If $l_i_Search > 0 Then
                Return $l_ai_MBI[0]
            EndIf
        EndIf
        $l_p_CurrentSearchAddress += $l_ai_MBI[3]
    WEnd
    Return ''
EndFunc

Func Scanner_ScanForCharname()
    Local $l_s_CharNameCode = BinaryToString('0x6A14FF751868')
    Local $l_p_CurrentSearchAddress = 0x00000000
    Local $l_ai_MBI[7], $l_d_MBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
    Local $l_i_Search, $l_s_TmpMemData, $l_p_TmpAddress, $l_d_TmpBuffer = DllStructCreate('ptr'), $l_i_Idx

    While $l_p_CurrentSearchAddress < 0x01F00000
        Local $l_ai_MBI[7]
        DllCall($g_h_Kernel32, 'int', 'VirtualQueryEx', 'int', $g_h_GWProcess, 'int', $l_p_CurrentSearchAddress, 'ptr', DllStructGetPtr($l_d_MBIBuffer), 'int', DllStructGetSize($l_d_MBIBuffer))
        For $l_i_Idx = 0 To 6
            $l_ai_MBI[$l_i_Idx] = StringStripWS(DllStructGetData($l_d_MBIBuffer, ($l_i_Idx + 1)), 3)
        Next
        If $l_ai_MBI[4] = 4096 Then
            Local $l_d_Buffer = DllStructCreate('byte[' & $l_ai_MBI[3] & ']')
            DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $l_p_CurrentSearchAddress, 'ptr', DllStructGetPtr($l_d_Buffer), 'int', DllStructGetSize($l_d_Buffer), 'int', '')

            $l_s_TmpMemData = DllStructGetData($l_d_Buffer, 1)
            $l_s_TmpMemData = BinaryToString($l_s_TmpMemData)

            $l_i_Search = StringInStr($l_s_TmpMemData, $l_s_CharNameCode, 2)
            If $l_i_Search > 0 Then
                $l_p_TmpAddress = $l_p_CurrentSearchAddress + $l_i_Search - 1
                DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'int', $l_p_TmpAddress + 6, 'ptr', DllStructGetPtr($l_d_TmpBuffer), 'int', DllStructGetSize($l_d_TmpBuffer), 'int', '')
                $g_p_CharName = DllStructGetData($l_d_TmpBuffer, 1)
                Return Player_GetCharname()
            EndIf
        EndIf
        $l_p_CurrentSearchAddress += $l_ai_MBI[3]
    WEnd
    Return ''
EndFunc

Func Scanner_AddPattern($a_s_Name, $a_s_Pattern, $a_v_OffsetOrMsg = 0, $a_s_Type = 'Ptr')
    Local $l_i_Index = $g_amx2_Patterns[0][0] + 1
    ReDim $g_amx2_Patterns[$l_i_Index + 1][6]
    $g_amx2_Patterns[0][0] = $l_i_Index

    Local $l_s_FullName = 'Scan' & $a_s_Name & $a_s_Type

    Local $l_b_IsAssertion = False
    Local $l_s_AssertionMsg = ""

    If StringInStr($a_s_Pattern, ":\") Or StringInStr($a_s_Pattern, ":/") Then
        $l_b_IsAssertion = True
        $l_s_AssertionMsg = $a_v_OffsetOrMsg

        Local $l_i_AssertIndex = UBound($g_amx2_AssertionPatterns)
        ReDim $g_amx2_AssertionPatterns[$l_i_AssertIndex + 1][2]
        $g_amx2_AssertionPatterns[$l_i_AssertIndex][0] = $a_s_Pattern
        $g_amx2_AssertionPatterns[$l_i_AssertIndex][1] = $l_s_AssertionMsg
    EndIf

    $g_amx2_Patterns[$l_i_Index][0] = $l_s_FullName
    $g_amx2_Patterns[$l_i_Index][1] = $a_s_Pattern
    $g_amx2_Patterns[$l_i_Index][2] = $l_b_IsAssertion ? 0 : $a_v_OffsetOrMsg
    $g_amx2_Patterns[$l_i_Index][3] = $a_s_Type
    $g_amx2_Patterns[$l_i_Index][4] = $l_b_IsAssertion
    $g_amx2_Patterns[$l_i_Index][5] = $l_s_AssertionMsg
EndFunc

Func Scanner_ClearPatterns()
    ReDim $g_amx2_Patterns[1][6]
    $g_amx2_Patterns[0][0] = 0
    ReDim $g_amx2_AssertionPatterns[0][2]
EndFunc

Func Scanner_GetPatternInfo($a_s_Name, $a_s_Type = '')
    Local $l_s_SearchName = 'Scan' & $a_s_Name & $a_s_Type
    For $l_i_Idx = 1 To $g_amx2_Patterns[0][0]
        If $g_amx2_Patterns[$l_i_Idx][0] = $l_s_SearchName Or _
           ($a_s_Type = '' And StringInStr($g_amx2_Patterns[$l_i_Idx][0], 'Scan' & $a_s_Name)) Then
            Local $l_av_Info[6]
            For $l_i_InfoIdx = 0 To 5
                $l_av_Info[$l_i_InfoIdx] = $g_amx2_Patterns[$l_i_Idx][$l_i_InfoIdx]
            Next
            Return $l_av_Info
        EndIf
    Next
    Return 0
EndFunc

Func Scanner_ScanAllPatterns()
    Local $l_p_GwBase = Scanner_ScanForProcess()
    Local $l_ap_Results[$g_amx2_Patterns[0][0] + 1]
    $l_ap_Results[0] = $g_amx2_Patterns[0][0]

    If UBound($g_amx2_AssertionPatterns) > 0 Then
        Local $l_as_AssertionPatterns = Scanner_GetMultipleAssertionPatterns($g_amx2_AssertionPatterns)

        Local $l_i_AssertIdx = 0
        For $l_i_Idx = 1 To $g_amx2_Patterns[0][0]
            If $g_amx2_Patterns[$l_i_Idx][4] Then
                $g_amx2_Patterns[$l_i_Idx][1] = $l_as_AssertionPatterns[$l_i_AssertIdx]
                $l_i_AssertIdx += 1
            EndIf
        Next
    EndIf

    $g_i_ASMSize = 0
    $g_i_ASMCodeOffset= 0
    $g_s_ASMCode = ''

    _('MainModPtr/4')

    For $l_i_Idx = 1 To $g_amx2_Patterns[0][0]
        _($g_amx2_Patterns[$l_i_Idx][0] & ':')
        Scanner_AddPatternToASM($g_amx2_Patterns[$l_i_Idx][1])
    Next

    Assembler_CreateScanProcedure($l_p_GwBase)

    $g_p_GWBaseAddress = $l_p_GwBase + 0x9DF000
    Local $l_p_ScanMemory = Memory_Read($g_p_GWBaseAddress, 'ptr')

    If $l_p_ScanMemory = 0 Then
        $g_p_ASMMemory = DllCall($g_h_Kernel32, 'ptr', 'VirtualAllocEx', 'handle', $g_h_GWProcess, 'ptr', 0, 'ulong_ptr', $g_i_ASMSize, 'dword', 0x1000, 'dword', 0x40)
        $g_p_ASMMemory = $g_p_ASMMemory[0]
        Memory_Write($g_p_GWBaseAddress, $g_p_ASMMemory)
    Else
        $g_p_ASMMemory = $l_p_ScanMemory
    EndIf

    Assembler_CompleteASMCode()

    If $l_p_ScanMemory = 0 Then
        Memory_WriteBinary($g_s_ASMCode, $g_p_ASMMemory + $g_i_ASMCodeOffset)

        Local $l_h_Thread = DllCall($g_h_Kernel32, 'int', 'CreateRemoteThread', 'int', $g_h_GWProcess, 'ptr', 0, 'int', 0, 'int', Memory_GetLabelInfo('ScanProc'), 'ptr', 0, 'int', 0, 'int', 0)
        $l_h_Thread = $l_h_Thread[0]

        Local $l_av_Result
        Do
            $l_av_Result = DllCall($g_h_Kernel32, 'int', 'WaitForSingleObject', 'int', $l_h_Thread, 'int', 50)
        Until $l_av_Result[0] <> 258

        DllCall($g_h_Kernel32, 'int', 'CloseHandle', 'int', $l_h_Thread)
    EndIf

    For $l_i_Idx = 1 To $g_amx2_Patterns[0][0]
        $l_ap_Results[$l_i_Idx] = Memory_GetScannedAddress($g_amx2_Patterns[$l_i_Idx][0], $g_amx2_Patterns[$l_i_Idx][2])
    Next

    Return $l_ap_Results
EndFunc

Func Scanner_GetScanResult($a_s_Name, $a_ap_Results = 0, $a_s_Type = '')
    If Not IsArray($a_ap_Results) Then Return 0

    Local $l_s_SearchName = 'Scan' & $a_s_Name & $a_s_Type

    For $l_i_Idx = 1 To $g_amx2_Patterns[0][0]
        If $g_amx2_Patterns[$l_i_Idx][0] = $l_s_SearchName Or _
           ($a_s_Type = '' And StringInStr($g_amx2_Patterns[$l_i_Idx][0], 'Scan' & $a_s_Name)) Then
            Return $a_ap_Results[$l_i_Idx]
        EndIf
    Next

    Return 0
EndFunc

Func Scanner_AddPatternToASM($a_s_Pattern)

	$a_s_Pattern = StringReplace($a_s_Pattern, "??", "00")

    Local $l_i_Size = Int(0.5 * StringLen($a_s_Pattern))
    Local $l_s_PatternHeader = "00000000" & _
                           Utils_SwapEndian(Hex($l_i_Size, 8)) & _
                           "00000000"

    $g_s_ASMCode &= $l_s_PatternHeader & $a_s_Pattern
    $g_i_ASMSize += $l_i_Size + 12

    Local $l_i_PaddingCount = 68 - $l_i_Size
    For $l_i_Idx = 1 To $l_i_PaddingCount
        $g_i_ASMSize += 1
        $g_s_ASMCode &= "00"
    Next
EndFunc

Func Scanner_GetCallTargetAddress($a_p_Address)
    Local $l_x_Offset = Memory_Read($a_p_Address + 1, 'dword')

    If $l_x_Offset > 0x7FFFFFFF Then
        $l_x_Offset -= 0x100000000
    EndIf

    Local $l_p_TargetAddress = $a_p_Address + 5 + $l_x_Offset

    Return $l_p_TargetAddress
EndFunc