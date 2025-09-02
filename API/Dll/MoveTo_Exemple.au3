#RequireAdmin
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Memory.au3>
#include "GWRPCClient.au3"
#include "GWRPCFunc.au3"

; ==================================
; Global Variables
; ==================================
Global $g_MoveTo_Func = 0
Global $g_bInitialized = False

; ==================================
; Initialize MoveTo (CORRECTED)
; ==================================
Func InitializeMoveTo()
    ConsoleWrite("========================================" & @CRLF)
    ConsoleWrite("Initializing MoveTo Function (CDECL)..." & @CRLF)
    ConsoleWrite("========================================" & @CRLF)

    ; Connect to RPC server
    If Not RPCClient_Init("\\.\pipe\GWToolsPipe", True) Then
        ConsoleWrite("[ERROR] Failed to connect to RPC server" & @CRLF)
        Return False
    EndIf

    ConsoleWrite("[SUCCESS] Connected to RPC server" & @CRLF)
    Sleep(500)

    ; Step 1: Find the pattern (from GWCA source)
    ; address = Scanner::Find("\x83\xc4\x0c\x85\xff\x74\x0b\x56\x6a\x03", "xxxxxxxxxx", -0x5);
    ConsoleWrite(@CRLF & "Step 1: Searching for MoveTo pattern..." & @CRLF)
    Local $call_addr = RPCScanner_Find("83 c4 0c 85 ff 74 0b 56 6a 03", "xxxxxxxxxx", -0x5, $SECTION_TEXT)

    If Not $call_addr Then
        ConsoleWrite("[ERROR] Pattern not found!" & @CRLF)
        RPCClient_Close()
        Return False
    EndIf

    ConsoleWrite("[SUCCESS] Pattern found at: 0x" & Hex($call_addr) & @CRLF)

    ; Step 2: Get function address from CALL
    ; MoveTo_Func = (MoveTo_pt)Scanner::FunctionFromNearCall(address);
    ConsoleWrite(@CRLF & "Step 2: Getting function address from CALL..." & @CRLF)
    $g_MoveTo_Func = RPCScanner_FunctionFromNearCall($call_addr)

    If Not $g_MoveTo_Func Then
        ConsoleWrite("[ERROR] Failed to get function address!" & @CRLF)
        RPCClient_Close()
        Return False
    EndIf

    ConsoleWrite("[SUCCESS] MoveTo function found at: 0x" & Hex($g_MoveTo_Func) & @CRLF)

    ; Step 3: Register the function with CDECL convention!
    ; GWCA uses default C++ convention which is __cdecl
    ConsoleWrite(@CRLF & "Step 3: Registering MoveTo function as CDECL..." & @CRLF)

    If Not RPCFunc_Register("MoveTo", $g_MoveTo_Func, 1, $RPCF_CONV_CDECL, False) Then
        ConsoleWrite("[ERROR] Failed to register MoveTo function!" & @CRLF)
        RPCClient_Close()
        Return False
    EndIf

    ConsoleWrite("[SUCCESS] MoveTo function registered (CDECL)" & @CRLF)

    $g_bInitialized = True
    ConsoleWrite(@CRLF & "[SUCCESS] MoveTo initialization complete!" & @CRLF)
    ConsoleWrite("========================================" & @CRLF)

    Return True
EndFunc

; ==================================
; MoveTo Function (matches GWCA)
; ==================================
Func MoveTo($x, $y, $zplane = 0)
    If Not $g_bInitialized Then
        ConsoleWrite("[ERROR] MoveTo not initialized!" & @CRLF)
        Return False
    EndIf

    ConsoleWrite(@CRLF & "MoveTo(" & $x & ", " & $y & ", " & $zplane & ")" & @CRLF)

    ; Allocate memory for float array (4 floats = 16 bytes)
    ; GWCA: float arg[4] = { .0f };
    Local $memSize = 16
    Local $pFloatArray = RPCMemory_Allocate($memSize, 0x04)  ; PAGE_READWRITE

    If Not $pFloatArray Then
        ConsoleWrite("[ERROR] Failed to allocate memory!" & @CRLF)
        Return False
    EndIf

    ConsoleWrite("[INFO] Allocated memory at: 0x" & Hex($pFloatArray) & @CRLF)

    ; Create float array matching GWCA format:
    ; arg[0] = pos.x;
    ; arg[1] = pos.y;
    ; arg[2] = (float)pos.zplane;
    ; arg[3] = 0.0f; // Unknown 4th float
    Local $tFloats = DllStructCreate("float;float;float;float")
    DllStructSetData($tFloats, 1, Number($x, 3))       ; X as float
    DllStructSetData($tFloats, 2, Number($y, 3))       ; Y as float
    DllStructSetData($tFloats, 3, Number($zplane, 3))  ; Z as float
    DllStructSetData($tFloats, 4, 0.0)                 ; 4th float = 0.0

    ; Get binary data
    Local $tBytes = DllStructCreate("byte[16]", DllStructGetPtr($tFloats))
    Local $binaryData = DllStructGetData($tBytes, 1)

    ; Debug output
    ConsoleWrite("[DEBUG] Float values: X=" & $x & ", Y=" & $y & ", Z=" & $zplane & @CRLF)

    ; Write to allocated memory
    If Not RPCMemory_Write($pFloatArray, $binaryData, $memSize) Then
        ConsoleWrite("[ERROR] Failed to write coordinates!" & @CRLF)
        RPCMemory_Free($pFloatArray)
        Return False
    EndIf

    ConsoleWrite("[INFO] Coordinates written to memory" & @CRLF)

    ; Call MoveTo with pointer to float array
    ; MoveTo_Func(arg);
    Local $params[1] = [$pFloatArray]
    Local $result = RPCFunc_Call("MoveTo", $params)

    ; Free memory
    RPCMemory_Free($pFloatArray)

    If $result Or $result = 0 Then  ; void function might return 0
        ConsoleWrite("[SUCCESS] Movement command executed!" & @CRLF)
        Return True
    Else
        ConsoleWrite("[WARNING] Movement might have failed" & @CRLF)
        Return False
    EndIf
EndFunc

; ==================================
; Helper functions
; ==================================
Func RPCClient_CreateRequest()
    Return _CreateRequest()
EndFunc

Func RPCClient_CreateResponse()
    Return _CreateResponse()
EndFunc

Func RPCClient_SendRequest($pRequest, $pResponse)
    Return _SendRequest($pRequest, $pResponse)
EndFunc

; ==================================
; Test Program
; ==================================
Func TestMoveTo()
    ConsoleWrite("========================================" & @CRLF)
    ConsoleWrite("Guild Wars MoveTo Test (CDECL)" & @CRLF)
    ConsoleWrite("========================================" & @CRLF & @CRLF)

    ; Initialize
    If Not InitializeMoveTo() Then
        ConsoleWrite("[FATAL] Failed to initialize MoveTo" & @CRLF)
        Return
    EndIf

    ; Wait a bit for initialization
    Sleep(1000)

    ; Test movements
    ConsoleWrite(@CRLF & "Testing movements..." & @CRLF)
    ConsoleWrite("========================================" & @CRLF)

    ; Test 1: Simple movement
    ConsoleWrite(@CRLF & "Test 1: Move to (1000, 2000, 0)" & @CRLF)
    MoveTo(100, 200, 0)
    Sleep(2000)

    ; Clean up
    ConsoleWrite(@CRLF & "Cleaning up..." & @CRLF)
    RPCFunc_Unregister("MoveTo")
    RPCClient_Close()

    ConsoleWrite(@CRLF & "Test complete!" & @CRLF)
EndFunc

Func DiagnoseMoveTo()
    ConsoleWrite("========================================" & @CRLF)
    ConsoleWrite("MoveTo Diagnostic" & @CRLF)
    ConsoleWrite("========================================" & @CRLF)

    ; Connect
    If Not RPCClient_Init("\\.\pipe\GWToolsPipe", True) Then
        ConsoleWrite("[ERROR] Failed to connect" & @CRLF)
        Return
    EndIf

    ; Find the MoveTo pattern
    Local $call_addr = RPCScanner_Find("83 c4 0c 85 ff 74 0b 56 6a 03", "xxxxxxxxxx", -0x5, $SECTION_TEXT)
    ConsoleWrite("[INFO] Call instruction at: 0x" & Hex($call_addr) & @CRLF)

    ; Get function address
    Local $func_addr = RPCScanner_FunctionFromNearCall($call_addr)
    ConsoleWrite("[INFO] Function address: 0x" & Hex($func_addr) & @CRLF)

    ; Read the first bytes of the function to see what's there
    ConsoleWrite(@CRLF & "Reading function prologue..." & @CRLF)
    Local $funcBytes = RPCMemory_Read($func_addr, 32)
    If $funcBytes Then
        ConsoleWrite("[INFO] First 32 bytes of function:" & @CRLF)
        Local $hexStr = ""
        For $i = 1 To BinaryLen($funcBytes)
            $hexStr &= Hex(BinaryMid($funcBytes, $i, 1), 2) & " "
            If Mod($i, 16) = 0 Then
                ConsoleWrite("  " & $hexStr & @CRLF)
                $hexStr = ""
            EndIf
        Next
        If $hexStr <> "" Then ConsoleWrite("  " & $hexStr & @CRLF)

        ; Check for common function prologues
        Local $byte1 = BinaryMid($funcBytes, 1, 1)
        Local $byte2 = BinaryMid($funcBytes, 2, 1)
        Local $byte3 = BinaryMid($funcBytes, 3, 1)

        If $byte1 = 0x55 Then ; PUSH EBP
            ConsoleWrite("[INFO] Standard function prologue detected (PUSH EBP)" & @CRLF)
        ElseIf $byte1 = 0xE9 Then ; JMP
            ConsoleWrite("[WARNING] Function starts with JMP - might be a trampoline!" & @CRLF)
            ; Calculate jump target
            Local $jumpOffset = BinaryMid($funcBytes, 2, 4)
            ; Convert to signed int32
            Local $tOffset = DllStructCreate("int")
            DllStructSetData($tOffset, 1, $jumpOffset)
            Local $offset = DllStructGetData($tOffset, 1)
            Local $jumpTarget = $func_addr + 5 + $offset
            ConsoleWrite("[INFO] Jump target: 0x" & Hex($jumpTarget) & @CRLF)

            ; Try to read the jump target
            Local $targetBytes = RPCMemory_Read($jumpTarget, 16)
            If $targetBytes Then
                ConsoleWrite("[INFO] Jump target bytes: ")
                For $i = 1 To BinaryLen($targetBytes)
                    ConsoleWrite(Hex(BinaryMid($targetBytes, $i, 1), 2) & " ")
                Next
                ConsoleWrite(@CRLF)
            EndIf
        ElseIf $byte1 = 0xFF And $byte2 = 0x25 Then ; JMP [address]
            ConsoleWrite("[WARNING] Indirect jump detected - IAT or hook?" & @CRLF)
        Else
            ConsoleWrite("[INFO] Unknown prologue: " & Hex($byte1, 2) & " " & Hex($byte2, 2) & @CRLF)
        EndIf
    EndIf

    ; Try different approaches
    ConsoleWrite(@CRLF & "========================================" & @CRLF)
    ConsoleWrite("Testing different approaches..." & @CRLF)
    ConsoleWrite("========================================" & @CRLF)

    ; Test 1: Try with different memory protection
    ConsoleWrite(@CRLF & "Test 1: PAGE_EXECUTE_READWRITE (0x40)" & @CRLF)
    TestMoveToWithProtection($func_addr, 0x40)

    ; Test 2: Try with PAGE_READWRITE
    ConsoleWrite(@CRLF & "Test 2: PAGE_READWRITE (0x04)" & @CRLF)
    TestMoveToWithProtection($func_addr, 0x04)

    ; Test 3: Try calling with no parameters (sanity check)
    ConsoleWrite(@CRLF & "Test 3: Call with no parameters" & @CRLF)
    RPCFunc_Register("MoveTo_NoParam", $func_addr, 0, $RPCF_CONV_CDECL, False)
    Local $result = RPCFunc_Call("MoveTo_NoParam", 0)
    ConsoleWrite("[RESULT] No param call: " & $result & @CRLF)
    RPCFunc_Unregister("MoveTo_NoParam")

    ; Test 4: Try as THISCALL with dummy this pointer
    ConsoleWrite(@CRLF & "Test 4: THISCALL convention" & @CRLF)
    RPCFunc_Register("MoveTo_This", $func_addr, 2, $RPCF_CONV_THISCALL, False)
    Local $pMem = RPCMemory_Allocate(16, 0x04)
    If $pMem Then
        ; Write test data
        Local $tFloats = DllStructCreate("float;float;float;float")
        DllStructSetData($tFloats, 1, 100.0)
        DllStructSetData($tFloats, 2, 200.0)
        DllStructSetData($tFloats, 3, 0.0)
        DllStructSetData($tFloats, 4, 0.0)
        Local $tBytes = DllStructCreate("byte[16]", DllStructGetPtr($tFloats))
        RPCMemory_Write($pMem, DllStructGetData($tBytes, 1), 16)

        ; Try with different "this" pointers
        Local $thisParams[2] = [0, $pMem]  ; NULL this
        $result = RPCFunc_Call("MoveTo_This", $thisParams)
        ConsoleWrite("[RESULT] THISCALL with NULL this: " & $result & @CRLF)

        $thisParams[0] = $pMem  ; Memory as this
        $thisParams[1] = $pMem
        $result = RPCFunc_Call("MoveTo_This", $thisParams)
        ConsoleWrite("[RESULT] THISCALL with mem as this: " & $result & @CRLF)

        RPCMemory_Free($pMem)
    EndIf
    RPCFunc_Unregister("MoveTo_This")

    ; Clean up
    RPCClient_Close()
    ConsoleWrite(@CRLF & "Diagnostic complete" & @CRLF)
EndFunc

Func TestMoveToWithProtection($func_addr, $protection)
    ; Register function
    RPCFunc_Register("MoveTo_Test", $func_addr, 1, $RPCF_CONV_CDECL, False)

    ; Allocate with specific protection
    Local $pMem = RPCMemory_Allocate(16, $protection)
    If Not $pMem Then
        ConsoleWrite("[ERROR] Allocation failed" & @CRLF)
        RPCFunc_Unregister("MoveTo_Test")
        Return
    EndIf

    ; Write float data
    Local $tFloats = DllStructCreate("float;float;float;float")
    DllStructSetData($tFloats, 1, 100.0)
    DllStructSetData($tFloats, 2, 200.0)
    DllStructSetData($tFloats, 3, 0.0)
    DllStructSetData($tFloats, 4, 0.0)

    Local $tBytes = DllStructCreate("byte[16]", DllStructGetPtr($tFloats))
    RPCMemory_Write($pMem, DllStructGetData($tBytes, 1), 16)

    ; Try to call
    Local $params[1] = [$pMem]
    Local $result = RPCFunc_Call("MoveTo_Test", $params)
    ConsoleWrite("[RESULT] Call result: " & $result & @CRLF)

    ; Clean up
    RPCMemory_Free($pMem)
    RPCFunc_Unregister("MoveTo_Test")
EndFunc

; Run diagnostic
DiagnoseMoveTo()