#include-once

#Region Logging System
; Logging related constants and variables
Global $g_b_DebugMode = True

; Log message types
Global Enum $GC_I_LOG_MSGTYPE_DEBUG 	= 0, _	; Detailed information for debugging purposes
			$GC_I_LOG_MSGTYPE_INFO 		= 1, _	; General operational information
			$GC_I_LOG_MSGTYPE_WARNING 	= 2, _	; Warning messages for potential issues
			$GC_I_LOG_MSGTYPE_ERROR 	= 3, _	; Error messages for operation failures
			$GC_I_LOG_MSGTYPE_CRITICAL 	= 4     ; Critical errors requiring immediate attention
#EndRegion Logging System