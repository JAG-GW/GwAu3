#include-once
#include "../GwAu3.au3"

; ==================================
; Diagnostic Tools
; ==================================

Func Diag_TestConnection()
    ConsoleWrite("Testing RPC connection..." & @CRLF)

    If Not RPCClient_IsConnected() Then
        ConsoleWrite("Not connected. Attempting to connect..." & @CRLF)
        If Not RPCClient_Init() Then
            ConsoleWrite("Connection failed!" & @CRLF)
            Return False
        EndIf
    EndIf

    ConsoleWrite("Connection successful!" & @CRLF)
    Return True
EndFunc

Func Diag_TestScanner()
    ConsoleWrite("Testing Scanner functions..." & @CRLF)

    ; Test pattern find
    Local $result = RPCScanner_Find("55 8B EC", "xxx")
    ConsoleWrite("Pattern search: " & ($result ? "OK" : "FAIL") & @CRLF)

    ; Test section info
    Local $info = RPCScanner_GetSectionInfo($RPC_SECTION_TEXT)
    ConsoleWrite("Section info: " & (IsArray($info) ? "OK" : "FAIL") & @CRLF)

    Return True
EndFunc

Func Diag_TestMemory()
    ConsoleWrite("Testing Memory functions..." & @CRLF)

    ; Test allocation
    Local $pMem = RPCMemory_Allocate(256)
    If Not $pMem Then
        ConsoleWrite("Allocation failed!" & @CRLF)
        Return False
    EndIf
    ConsoleWrite("Allocated at: 0x" & Hex($pMem) & @CRLF)

    ; Test write
    Local $data = Binary("0x48656C6C6F") ; "Hello"
    If Not RPCMemory_Write($pMem, $data, 5) Then
        ConsoleWrite("Write failed!" & @CRLF)
        RPCMemory_Free($pMem)
        Return False
    EndIf

    ; Test read
    Local $readData = RPCMemory_Read($pMem, 5)
    ConsoleWrite("Read data: " & $readData & @CRLF)

    ; Clean up
    RPCMemory_Free($pMem)

    Return True
EndFunc

Func Diag_RunAll()
    ConsoleWrite("===== Running Diagnostics =====" & @CRLF)

    Diag_TestConnection()
    Diag_TestScanner()
    Diag_TestMemory()

    ConsoleWrite("===== Diagnostics Complete =====" & @CRLF)
EndFunc