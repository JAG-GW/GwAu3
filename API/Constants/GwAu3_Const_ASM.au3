#include-once

#Region Assembler Variables
; Variables for assembler functionality
Global Const $GC_B_DEV_MODE = False ; Flag used for ASM development/testing

Global Const $GC_S_GWAU3_HEADER_BIN = "4757415533415049"
Global Const $GC_S_GWAU3_HEADER_STR = "GWAU3API"
Global Const $GC_I_GWAU3_HEADER_SIZE = 16
Global Const $GC_I_GWAU3_OFFSET_SCANPTR = 8
Global Const $GC_I_GWAU3_OFFSET_CMDPTR = 12

Global $g_p_GwAu3Header = 0 ; Address of GwAu3 signature
Global $g_p_GwAu3Scan = 0 ; Address containing pointer to scanner opcode
Global $g_p_GwAu3Cmd = 0 ; Address cotnaining pointer to command opcode

Global $g_s_ASMCode ; String containing assembled ASM code
Global $g_i_ASMSize ; Size of assembled ASM code
Global $g_i_ASMCodeOffset ; Offset in ASM code
Global $g_amx2_Labels[1][2] = [[0]] ; Array to store labels and their values
#EndRegion Assembler Variables