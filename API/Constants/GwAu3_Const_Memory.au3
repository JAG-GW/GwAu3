#include-once

#Region Memory Handles
; Process and memory handles
Global $g_h_Kernel32                        ; Handle to kernel32.dll
Global $g_h_GWProcess                        ; Handle to Guild Wars process
Global $g_i_GWProcessId                         ; Process ID of Guild Wars client
Global $g_h_GWWindow                      ; Window handle of Guild Wars client
Global $g_p_GWBaseAddress = 0x00C50000                   ; Base memory address for Guild Wars
Global $g_p_ASMMemory                              ; Memory address where ASM code is stored
Global $g_p_SecondInjection                         ; Address of secondary code injection
#EndRegion Memory Handles