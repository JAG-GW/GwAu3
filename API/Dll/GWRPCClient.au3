#include <WinAPI.au3>
#include <Memory.au3>
#include <Array.au3>

; ==================================
; Constants - Request Types
; ==================================
Global Const $SCAN_FIND = 1
Global Const $SCAN_FIND_ASSERTION = 2
Global Const $SCAN_FIND_IN_RANGE = 3
Global Const $SCAN_TO_FUNCTION_START = 4
Global Const $SCAN_FUNCTION_FROM_NEAR_CALL = 5
Global Const $READ_MEMORY = 6
Global Const $GET_SECTION_INFO = 7
Global Const $REGISTER_FUNCTION = 10
Global Const $UNREGISTER_FUNCTION = 11
Global Const $CALL_FUNCTION = 12
Global Const $LIST_FUNCTIONS = 13
Global Const $ALLOCATE_MEMORY = 20
Global Const $FREE_MEMORY = 21
Global Const $WRITE_MEMORY = 22
Global Const $PROTECT_MEMORY = 23
Global Const $INSTALL_HOOK = 30
Global Const $REMOVE_HOOK = 31
Global Const $ENABLE_HOOK = 32
Global Const $DISABLE_HOOK = 33
Global Const $GET_PENDING_EVENTS = 40
Global Const $REGISTER_EVENT_BUFFER = 41
Global Const $UNREGISTER_EVENT_BUFFER = 42

; Parameter types
Global Const $PARAM_INT8 = 1
Global Const $PARAM_INT16 = 2
Global Const $PARAM_INT32 = 3
Global Const $PARAM_INT64 = 4
Global Const $PARAM_FLOAT = 5
Global Const $PARAM_DOUBLE = 6
Global Const $PARAM_POINTER = 7
Global Const $PARAM_STRING = 8
Global Const $PARAM_WSTRING = 9

; Calling conventions
Global Const $CONV_CDECL = 1
Global Const $CONV_STDCALL = 2
Global Const $CONV_FASTCALL = 3
Global Const $CONV_THISCALL = 4

; Scanner sections
Global Const $SECTION_TEXT = 0
Global Const $SECTION_RDATA = 1
Global Const $SECTION_DATA = 2

; ==================================
; CRITICAL: Correct Structure Sizes
; ==================================
Global Const $REQUEST_SIZE = 2672  ; Confirmed by diagnostic
Global Const $RESPONSE_SIZE = 1544 ; Confirmed by diagnostic

; ==================================
; Global Variables
; ==================================
Global $g_hPipe = 0
Global $g_bConnected = False
Global $g_bDebugMode = False  ; Set to True for debug output

; ==================================
; Core Functions
; ==================================

Func RPCClient_Init($sPipeName = "\\.\pipe\GwAu3Server", $bDebug = False)
    $g_bDebugMode = $bDebug
    Out("[INFO] Connecting to named pipe: " & $sPipeName)

    ; Try to connect to pipe
    For $i = 1 To 10
        $g_hPipe = _WinAPI_CreateFile($sPipeName, 3, 6, 0, 0, 0)

        If $g_hPipe And $g_hPipe <> Ptr(-1) Then
            Out("[SUCCESS] Connected to pipe on attempt " & $i)
            $g_bConnected = True
            Return True
        EndIf

        Out("[INFO] Waiting for pipe... (attempt " & $i & "/10)")
        Sleep(1000)
    Next

    Out("[ERROR] Failed to connect to pipe")
    Return False
EndFunc

Func RPCClient_Close()
    If $g_hPipe And $g_hPipe <> Ptr(-1) Then
        _WinAPI_CloseHandle($g_hPipe)
        $g_hPipe = 0
        Out("[INFO] Pipe connection closed")
    EndIf
    $g_bConnected = False
EndFunc

Func RPCClient_IsConnected()
    Return $g_bConnected And $g_hPipe And $g_hPipe <> Ptr(-1)
EndFunc

; ==================================
; Internal Communication
; ==================================

Func _SendRequest($pRequest, $pResponse)
    If Not RPCClient_IsConnected() Then
        Out("[ERROR] Not connected to RPC server")
        Return False
    EndIf

    Local $iBytesWritten = 0, $iBytesRead = 0

    ; Send request
    Local $bResult = _WinAPI_WriteFile($g_hPipe, $pRequest, $REQUEST_SIZE, $iBytesWritten)
    If Not $bResult Or $iBytesWritten <> $REQUEST_SIZE Then
        Out("[ERROR] Failed to write to pipe: " & _WinAPI_GetLastError())
        Return False
    EndIf

    ; Read response
    $bResult = _WinAPI_ReadFile($g_hPipe, $pResponse, $RESPONSE_SIZE, $iBytesRead)
    If Not $bResult Or $iBytesRead <> $RESPONSE_SIZE Then
        Out("[ERROR] Failed to read from pipe: " & _WinAPI_GetLastError())
        Return False
    EndIf

    Return True
EndFunc

Func _CreateRequest()
    Local $tRequest = DllStructCreate("byte[" & $REQUEST_SIZE & "]")
    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $REQUEST_SIZE)
    Return $tRequest
EndFunc

Func _CreateResponse()
    Local $tResponse = DllStructCreate("byte[" & $RESPONSE_SIZE & "]")
    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tResponse), "dword", $RESPONSE_SIZE)
    Return $tResponse
EndFunc

; ==================================
; Pattern Helper Functions
; ==================================

Func _ConvertEscapePattern($sPattern)
    ; Convert a pattern with \x escape sequences to actual bytes
    ; e.g., "\x83\xFE\x03" -> actual bytes 0x83, 0xFE, 0x03

    Local $sResult = ""
    Local $i = 1

    While $i <= StringLen($sPattern)
        If StringMid($sPattern, $i, 2) = "\x" Then
            ; Found escape sequence
            Local $sHex = StringMid($sPattern, $i + 2, 2)
            If StringRegExp($sHex, "^[0-9A-Fa-f]{2}$") Then
                ; Valid hex, convert to character
                $sResult &= Chr(Dec($sHex))
                $i += 4 ; Skip \xHH
            Else
                ; Not valid hex, keep as is
                $sResult &= StringMid($sPattern, $i, 1)
                $i += 1
            EndIf
        Else
            ; Regular character
            $sResult &= StringMid($sPattern, $i, 1)
            $i += 1
        EndIf
    WEnd

    Return $sResult
EndFunc

Func _ProcessPatternBinaryWithLength($sPattern, $tReq, $sFieldName = "pattern")
    ; Process a pattern and write it to the request structure as binary data
    ; Returns the actual length of the pattern

    Local $tPatternDest = DllStructCreate("byte[256]", DllStructGetPtr($tReq, $sFieldName))
    Local $iLen = 0

    ; First check if it's a hex string with spaces (e.g., "8B 0C 90" or "8B ?? 90")
    If StringRegExp($sPattern, "^[0-9A-Fa-f\s\?]+$") And StringInStr($sPattern, " ") Then
        ; Hex string with spaces - split by space properly
        Local $aBytes = StringSplit($sPattern, " ", 2) ; Flag 2 = no count in [0], treat consecutive delimiters as one

        For $i = 0 To UBound($aBytes) - 1
            If StringLen($aBytes[$i]) > 0 Then
                If $aBytes[$i] = "??" Then
                    ; For wildcards, write 0x00 (value doesn't matter, mask will handle it)
                    DllStructSetData($tPatternDest, 1, 0x00, $iLen + 1)
                    $iLen += 1
                Else
                    Local $byteVal = Dec($aBytes[$i])
                    DllStructSetData($tPatternDest, 1, $byteVal, $iLen + 1)
                    $iLen += 1
                EndIf
            EndIf
        Next

        Out("[PATTERN] Converted hex pattern: " & $iLen & " bytes from: " & $sPattern)
        Return $iLen

    ; Check if it contains escape sequences
    ElseIf StringInStr($sPattern, "\x") Then
        ; Pattern with escape sequences - convert properly to binary
        Local $i = 1
        While $i <= StringLen($sPattern)
            If StringMid($sPattern, $i, 2) = "\x" And $i + 3 <= StringLen($sPattern) Then
                ; Found escape sequence
                Local $sHex = StringMid($sPattern, $i + 2, 2)
                If StringRegExp($sHex, "^[0-9A-Fa-f]{2}$") Then
                    ; Valid hex
                    DllStructSetData($tPatternDest, 1, Dec($sHex), $iLen + 1)
                    $iLen += 1
                    $i += 4 ; Skip \xHH
                Else
                    ; Not valid hex, treat as regular character
                    DllStructSetData($tPatternDest, 1, Asc(StringMid($sPattern, $i, 1)), $iLen + 1)
                    $iLen += 1
                    $i += 1
                EndIf
            Else
                ; Regular character
                DllStructSetData($tPatternDest, 1, Asc(StringMid($sPattern, $i, 1)), $iLen + 1)
                $iLen += 1
                $i += 1
            EndIf
        WEnd

        Out("[PATTERN] Converted escape pattern: " & $iLen & " bytes")
        Return $iLen
    Else
        ; Raw string pattern - convert each character to byte
        For $i = 1 To StringLen($sPattern)
            DllStructSetData($tPatternDest, 1, Asc(StringMid($sPattern, $i, 1)), $i)
        Next
        $iLen = StringLen($sPattern)

        Out("[PATTERN] Raw string pattern: " & $iLen & " bytes")
        Return $iLen
    EndIf
EndFunc

; Keep the old function for backward compatibility
Func _ProcessPatternBinary($sPattern, $tReq, $sFieldName = "pattern")
    Return _ProcessPatternBinaryWithLength($sPattern, $tReq, $sFieldName)
EndFunc

Func _ProcessPattern($sPattern, $tReq, $sFieldName = "pattern")
    ; Wrapper for backward compatibility
    Return _ProcessPatternBinary($sPattern, $tReq, $sFieldName)
EndFunc

; ==================================
; Scanner Functions
; ==================================

Func RPCScanner_Find($vPattern, $sMask = "", $iOffset = 0, $iSection = $SECTION_TEXT)
    Out("[SCANNER] Find pattern: " & $vPattern)

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Create typed view with new structure
    Local $tReq = DllStructCreate("int type; byte pattern[256]; char mask[256]; int offset; byte section; byte pattern_length; byte padding[2]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $SCAN_FIND)

    ; Process the pattern and get the length
    Local $iPatternLength = _ProcessPatternBinaryWithLength($vPattern, $tReq, "pattern")

    ; Set the pattern length
    DllStructSetData($tReq, "pattern_length", $iPatternLength)

    DllStructSetData($tReq, "mask", $sMask)
    DllStructSetData($tReq, "offset", $iOffset)
    DllStructSetData($tReq, "section", $iSection)

    Out("[SCANNER] Sending pattern with length: " & $iPatternLength)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    ; Parse response
    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pAddress = DllStructGetData($tResp, "address")
        Out("[SCANNER] Pattern found at: 0x" & Hex($pAddress))
        Return $pAddress
    EndIf

    Out("[SCANNER] Pattern not found: " & DllStructGetData($tResp, "error"))
    Return 0
EndFunc

Func RPCScanner_FindAssertion($sFile, $sMsg, $iLine = 0, $iOffset = 0)
    Out("[SCANNER] FindAssertion: " & $sFile & " / " & $sMsg)

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    Local $tReq = DllStructCreate("int type; char file[256]; char msg[256]; uint line; int offset", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $SCAN_FIND_ASSERTION)
    DllStructSetData($tReq, "file", $sFile)
    DllStructSetData($tReq, "msg", $sMsg)
    DllStructSetData($tReq, "line", $iLine)
    DllStructSetData($tReq, "offset", $iOffset)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pAddress = DllStructGetData($tResp, "address")
        Out("[SCANNER] Assertion found at: 0x" & Hex($pAddress))
        Return $pAddress
    EndIf

    Out("[SCANNER] Assertion not found")
    Return 0
EndFunc

Func RPCScanner_FindInRange($vPattern, $sMask, $iOffset, $iStartAddress, $iEndAddress)
    Out("[SCANNER] FindInRange: 0x" & Hex($iStartAddress) & " - 0x" & Hex($iEndAddress))

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Updated structure with pattern_length
    Local $tReq = DllStructCreate("int type; uint start_address; uint end_address; byte pattern[256]; char mask[256]; int offset; byte pattern_length; byte padding[3]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $SCAN_FIND_IN_RANGE)
    DllStructSetData($tReq, "start_address", $iStartAddress)
    DllStructSetData($tReq, "end_address", $iEndAddress)

    ; Process the pattern and get the length
    Local $iPatternLength = _ProcessPatternBinaryWithLength($vPattern, $tReq, "pattern")

    ; Set the pattern length
    DllStructSetData($tReq, "pattern_length", $iPatternLength)

    DllStructSetData($tReq, "mask", $sMask)
    DllStructSetData($tReq, "offset", $iOffset)

    Out("[SCANNER] Sending range pattern with length: " & $iPatternLength)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Return DllStructGetData($tResp, "address")
    EndIf

    Return 0
EndFunc

Func RPCScanner_ToFunctionStart($pAddress, $iScanRange = 0xFF)
    Out("[SCANNER] ToFunctionStart from: 0x" & Hex($pAddress))

    ; Check for null address
    If $pAddress = 0 Then
        Out("[SCANNER] Error: Null address provided")
        Return 0
    EndIf

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; The union starts at offset 4 (after type)
    ; We want to write to the memory struct which has:
    ; - address (ptr/uint32) at offset 0
    ; - size (uint32) at offset 4
    Local $tReq = DllStructCreate("int type; ptr address; uint size", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $SCAN_TO_FUNCTION_START)
    DllStructSetData($tReq, "address", $pAddress)
    DllStructSetData($tReq, "size", $iScanRange)

    Out("[SCANNER] Sending address: 0x" & Hex($pAddress) & " with range: " & $iScanRange)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pResult = DllStructGetData($tResp, "address")
        Out("[SCANNER] Function start found at: 0x" & Hex($pResult))
        Return $pResult
    EndIf

    Out("[SCANNER] Function start not found: " & DllStructGetData($tResp, "error"))
    Return 0
EndFunc

Func RPCScanner_FunctionFromNearCall($pCallAddress)
    Out("[SCANNER] FunctionFromNearCall at: 0x" & Hex($pCallAddress))

    ; Check for null address
    If $pCallAddress = 0 Then
        Out("[SCANNER] Error: Null address provided")
        Return 0
    EndIf

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Same structure as ToFunctionStart - memory struct starts right after type
    Local $tReq = DllStructCreate("int type; ptr address", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $SCAN_FUNCTION_FROM_NEAR_CALL)
    DllStructSetData($tReq, "address", $pCallAddress)

    Out("[SCANNER] Sending call address: 0x" & Hex($pCallAddress))

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pResult = DllStructGetData($tResp, "address")
        Out("[SCANNER] Function found at: 0x" & Hex($pResult))
        Return $pResult
    EndIf

    Out("[SCANNER] Function not found: " & DllStructGetData($tResp, "error"))
    Return 0
EndFunc

Func RPCScanner_GetSectionInfo($iSection)
    Out("[SCANNER] GetSectionInfo for section: " & $iSection)

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    Local $tReq = DllStructCreate("int type; byte padding[256]; byte padding2[256]; byte padding3[4]; byte section", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $GET_SECTION_INFO)
    DllStructSetData($tReq, "section", $iSection)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    ; Response has section_info in union
    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr start; ptr end; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $aInfo[2]
        $aInfo[0] = DllStructGetData($tResp, "start")
        $aInfo[1] = DllStructGetData($tResp, "end")
        Out("[SCANNER] Section " & $iSection & ": 0x" & Hex($aInfo[0]) & " - 0x" & Hex($aInfo[1]))
        Return $aInfo
    EndIf

    Return 0
EndFunc

; ==================================
; Memory Functions
; ==================================

Func RPCMemory_Allocate($iSize, $iProtection = 0x40)
    Out("[MEMORY] Allocate " & $iSize & " bytes with protection 0x" & Hex($iProtection))

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Clear the request
    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $REQUEST_SIZE)

    ; The working structure - memory fields start right after type
    Local $tMemStruct = DllStructCreate("int type; ptr address; uint size; uint protection", _
                                         DllStructGetPtr($tRequest))

    DllStructSetData($tMemStruct, "type", $ALLOCATE_MEMORY)
    DllStructSetData($tMemStruct, "address", 0)
    DllStructSetData($tMemStruct, "size", $iSize)
    DllStructSetData($tMemStruct, "protection", $iProtection)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send")
        Return 0
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; uint size; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pAddress = DllStructGetData($tResp, "address")
        Out("[SUCCESS] Allocated at: 0x" & Hex($pAddress))
        Return $pAddress
    Else
        Out("[ERROR] " & DllStructGetData($tResp, "error"))
        Return 0
    EndIf
EndFunc

Func RPCMemory_Free($pAddress)
    Out("[MEMORY] Free 0x" & Hex($pAddress))

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Clear request
    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $REQUEST_SIZE)

    ; For FREE_MEMORY, we only need address
    Local $tMem = DllStructCreate("int type; ptr address", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tMem, "type", $FREE_MEMORY)
    DllStructSetData($tMem, "address", $pAddress)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send free request")
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Out("[SUCCESS] Memory freed")
        Return True
    Else
        Out("[ERROR] Free failed: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

Func RPCMemory_Write($pAddress, $vData, $iSize)
    Out("[MEMORY] Write to 0x" & Hex($pAddress) & ", size: " & $iSize)

    If $iSize > 1024 Then
        Out("[ERROR] Write size too large (max 1024)")
        Return False
    EndIf

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Clear request
    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $REQUEST_SIZE)

    ; Structure for WRITE_MEMORY
    Local $tMem = DllStructCreate("int type; ptr address; uint size; uint protection; byte data[1024]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tMem, "type", $WRITE_MEMORY)
    DllStructSetData($tMem, "address", $pAddress)
    DllStructSetData($tMem, "size", $iSize)
    DllStructSetData($tMem, "protection", 0)  ; Not used for write

    ; Copy binary data
    If IsBinary($vData) Then
        ; Create a temporary struct to hold the binary data
        Local $tData = DllStructCreate("byte[" & $iSize & "]", DllStructGetPtr($tMem, "data"))
        DllStructSetData($tData, 1, $vData)
    ElseIf IsDllStruct($vData) Then
        ; Copy from DllStruct
        DllCall("kernel32.dll", "none", "RtlMoveMemory", _
                "ptr", DllStructGetPtr($tMem, "data"), _
                "ptr", DllStructGetPtr($vData), _
                "dword", $iSize)
    Else
        Out("[ERROR] Unsupported data type")
        Return False
    EndIf

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send write request")
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Out("[SUCCESS] Memory written")
        Return True
    Else
        Out("[ERROR] Write failed: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

Func RPCMemory_Read($pAddress, $iSize)
    Out("[MEMORY] Read from 0x" & Hex($pAddress) & ", size: " & $iSize)

    If $iSize > 1024 Then
        Out("[ERROR] Read size too large (max 1024)")
        Return 0
    EndIf

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    Local $tReq = DllStructCreate("int type; byte padding[768]; ptr address; uint size", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $READ_MEMORY)
    DllStructSetData($tReq, "address", $pAddress)
    DllStructSetData($tReq, "size", $iSize)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send read request")
        Return 0
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; uint size; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $readSize = DllStructGetData($tResp, "size")
        Local $tData = DllStructCreate("byte[" & $readSize & "]", DllStructGetPtr($tResp, "data"))
        Out("[SUCCESS] Read " & $readSize & " bytes")
        Return DllStructGetData($tData, 1)
    Else
        Out("[ERROR] Read failed: " & DllStructGetData($tResp, "error"))
        Return 0
    EndIf
EndFunc
