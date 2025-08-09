#include-once

; Memory section definitions
Global Const $GC_I_SECTION_TEXT = 0
Global Const $GC_I_SECTION_RDATA = 1
Global Const $GC_I_SECTION_DATA = 2
Global Const $GC_I_SECTION_RSRC = 3
Global Const $GC_I_SECTION_RELOC = 4

; Array to store section address ranges
Global $g_ai2_Sections[5][2]  ; [section][0=start, 1=end]
Global Const $GC_I_BLOCK_SIZE = 262144 ; 256 Ko (doubled from 128 Ko)
Global $g_amx_AssertionCache[0][3] ; [file, msg, pattern]
Global $g_p_SectionBuffer = 0 ; Buffer to hold entire section
Global $g_i_SectionBufferSize = 0
Global $g_amx_CompiledPatternsCache[0][4] ; [pattern_binary, length, first_byte, last_byte]

; Structure to store pattern information
Global $g_amx2_Patterns[1][6] = [[0]] ; [full_name, pattern, offset, type, is_assertion, assertion_msg]
Global $g_amx2_AssertionPatterns[0][2] ; [file, message]
Global $g_ap_ScanResults