#include "../GwAu3.au3"

; ==================================
; Basic Example
; ==================================

ConsoleWrite("GwAu3 Basic Example" & @CRLF)
ConsoleWrite("===================" & @CRLF & @CRLF)

; Initialize
If Not GwAu3_Initialize(True) Then
    MsgBox(0, "Error", "Failed to initialize GwAu3")
    Exit
EndIf

ConsoleWrite("Initialization successful!" & @CRLF & @CRLF)

; Test scanner
ConsoleWrite("Testing scanner..." & @CRLF)
Local $addr = RPCScanner_Find("55 8B EC", "xxx")
If $addr Then
    ConsoleWrite("Found pattern at: 0x" & Hex($addr) & @CRLF)
EndIf

; Test memory
ConsoleWrite(@CRLF & "Testing memory allocation..." & @CRLF)
Local $pMem = RPCMemory_Allocate(1024)
If $pMem Then
    ConsoleWrite("Allocated 1KB at: 0x" & Hex($pMem) & @CRLF)
    RPCMemory_Free($pMem)
    ConsoleWrite("Memory freed" & @CRLF)
EndIf

; List functions
ConsoleWrite(@CRLF & "Listing functions..." & @CRLF)
Local $aFuncs = RPCFunc_List()
If IsArray($aFuncs) Then
    ConsoleWrite("Found " & UBound($aFuncs) & " functions" & @CRLF)
EndIf

; Cleanup
ConsoleWrite(@CRLF & "Shutting down..." & @CRLF)
GwAu3_Shutdown()

ConsoleWrite("Done!" & @CRLF)