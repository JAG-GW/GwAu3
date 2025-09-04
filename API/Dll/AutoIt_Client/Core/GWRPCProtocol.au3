#include-once

; ==================================
; Request Types
; ==================================
Global Const $RPC_SCAN_FIND = 1
Global Const $RPC_SCAN_FIND_ASSERTION = 2
Global Const $RPC_SCAN_FIND_IN_RANGE = 3
Global Const $RPC_SCAN_TO_FUNCTION_START = 4
Global Const $RPC_SCAN_FUNCTION_FROM_NEAR_CALL = 5
Global Const $RPC_READ_MEMORY = 6
Global Const $RPC_GET_SECTION_INFO = 7

Global Const $RPC_REGISTER_FUNCTION = 10
Global Const $RPC_UNREGISTER_FUNCTION = 11
Global Const $RPC_CALL_FUNCTION = 12
Global Const $RPC_LIST_FUNCTIONS = 13

Global Const $RPC_ALLOCATE_MEMORY = 20
Global Const $RPC_FREE_MEMORY = 21
Global Const $RPC_WRITE_MEMORY = 22
Global Const $RPC_PROTECT_MEMORY = 23

Global Const $RPC_INSTALL_HOOK = 30
Global Const $RPC_REMOVE_HOOK = 31
Global Const $RPC_ENABLE_HOOK = 32
Global Const $RPC_DISABLE_HOOK = 33

Global Const $RPC_GET_PENDING_EVENTS = 40
Global Const $RPC_REGISTER_EVENT_BUFFER = 41
Global Const $RPC_UNREGISTER_EVENT_BUFFER = 42

; ==================================
; Server Control Commands
; ==================================
Global Const $RPC_SERVER_STATUS = 50
Global Const $RPC_SERVER_STOP = 51
Global Const $RPC_SERVER_START = 52
Global Const $RPC_SERVER_RESTART = 53

; ==================================
; DLL Control Commands
; ==================================
Global Const $RPC_DLL_DETACH = 60
Global Const $RPC_DLL_STATUS = 61

; ==================================
; Parameter Types
; ==================================
Global Const $RPC_PARAM_INT8 = 1
Global Const $RPC_PARAM_INT16 = 2
Global Const $RPC_PARAM_INT32 = 3
Global Const $RPC_PARAM_INT64 = 4
Global Const $RPC_PARAM_FLOAT = 5
Global Const $RPC_PARAM_DOUBLE = 6
Global Const $RPC_PARAM_POINTER = 7
Global Const $RPC_PARAM_STRING = 8
Global Const $RPC_PARAM_WSTRING = 9

; ==================================
; Calling Conventions
; ==================================
Global Const $RPC_CONV_CDECL = 1
Global Const $RPC_CONV_STDCALL = 2
Global Const $RPC_CONV_FASTCALL = 3
Global Const $RPC_CONV_THISCALL = 4

; ==================================
; Scanner Sections
; ==================================
Global Const $RPC_SECTION_TEXT = 0
Global Const $RPC_SECTION_RDATA = 1
Global Const $RPC_SECTION_DATA = 2

; ==================================
; Memory Protection Flags
; ==================================
Global Const $RPC_PAGE_NOACCESS = 0x01
Global Const $RPC_PAGE_READONLY = 0x02
Global Const $RPC_PAGE_READWRITE = 0x04
Global Const $RPC_PAGE_WRITECOPY = 0x08
Global Const $RPC_PAGE_EXECUTE = 0x10
Global Const $RPC_PAGE_EXECUTE_READ = 0x20
Global Const $RPC_PAGE_EXECUTE_READWRITE = 0x40
Global Const $RPC_PAGE_EXECUTE_WRITECOPY = 0x80

; ==================================
; Structure Sizes
; ==================================
Global Const $RPC_REQUEST_SIZE = 2672
Global Const $RPC_RESPONSE_SIZE = 1544

; ==================================
; Default Values
; ==================================
Global Const $RPC_DEFAULT_PIPE = "\\.\pipe\GwAu3Server_"
Global Const $RPC_DEFAULT_TIMEOUT = 5000
Global Const $RPC_MAX_RETRIES = 10

; ==================================
; Server Status Codes
; ==================================
Global Const $RPC_SERVER_STATUS_STOPPED = 0
Global Const $RPC_SERVER_STATUS_RUNNING = 1
Global Const $RPC_SERVER_STATUS_ERROR = 2

; ==================================
; DLL Status Codes
; ==================================
Global Const $RPC_DLL_STATUS_INITIALIZING = 0
Global Const $RPC_DLL_STATUS_RUNNING = 1
Global Const $RPC_DLL_STATUS_SHUTTING_DOWN = 2
Global Const $RPC_DLL_STATUS_STOPPED = 3