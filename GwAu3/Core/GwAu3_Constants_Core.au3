#include-once
#include "GwAu3_Constants_Core.au3"

;===================================================================================================
; GwAu3_Globals.au3
; Description: Contains all global variables and constants used by the GwAu3 library
; Author: Greg76 and contributors
; Version: 3.0
;===================================================================================================

#Region Version Information
; Version identifiers for the GwAu3 library
Global Const $GWA2_CREATOR = "GameRevision Community" ; Creator
Global Const $GWA2_BUILD_DATE = "approximately 2007" ; Build date of the gwa2 library

Global Const $GWAU3_VERSION = "1.0"         ; Current version of GwAu3 library
Global Const $GWAU3_BUILD_DATE = "2025-05-21" ; Build date of the library
Global Const $GWAU3_LAST_UPDATE = "2025-05-28" ; Last update of the library
Global Const $GWAU3_UPDATOR = "Greg76" ; Updator
#EndRegion Version Information

#Region GUI Elements
; Global GUI elements used across the library
Global $GUIEdit                              ; RichEdit control for logging
Global $mGUI                                 ; Main GUI handle used for callbacks
#EndRegion GUI Elements

#Region Memory Handles
; Process and memory handles
Global $mKernelHandle                        ; Handle to kernel32.dll
Global $mGWProcHandle                        ; Handle to Guild Wars process
Global $mGWProcessId                         ; Process ID of Guild Wars client
Global $mGWWindowHandle                      ; Window handle of Guild Wars client
Global $mBase = 0x00C50000                   ; Base memory address for Guild Wars
Global $mMemory                              ; Memory address where ASM code is stored
Global $SecondInject                         ; Address of secondary code injection
#EndRegion Memory Handles

#Region Game State
; Variables related to game state
Global $mCharname                            ; Character name
Global $mPing                                ; Current ping to server in milliseconds
Global $mUseEventSystem                      ; Flag to enable/disable event system
Global $mDisableRendering                    ; Flag to enable/disable game rendering
Global $lTemp                                ; Temporary variable for various operations
#EndRegion Game State

#Region Assembler Variables
; Variables for assembler functionality
Global $mASMString                           ; String containing assembled ASM code
Global $mASMSize                             ; Size of assembled ASM code
Global $mASMCodeOffset                       ; Offset in ASM code
Global $mLabels[1][2] = [[0]]                ; Array to store labels and their values
#EndRegion Assembler Variables

#Region Assembler Constants
; Constants for assembly data types
Global Const $ASM_BYTE = 0x01                ; 1-byte data size
Global Const $ASM_WORD = 0x02                ; 2-byte data size
Global Const $ASM_DWORD = 0x04               ; 4-byte data size (double word)
Global Const $ASM_QWORD = 0x08               ; 8-byte data size (quad word)
#EndRegion Assembler Constants

#Region Logging System
; Logging related constants and variables
Global $g_iDebugMode = True                     ; Debug mode flag for logging

; Log message types
Global Const $c_Log_Msg_Type_Debug = 0        ; Detailed information for debugging purposes
Global Const $c_Log_Msg_Type_Info = 1         ; General operational information
Global Const $c_Log_Msg_Type_Warning = 2      ; Warning messages for potential issues
Global Const $c_Log_Msg_Type_Error = 3        ; Error messages for operation failures
Global Const $c_Log_Msg_Type_Critical = 4     ; Critical errors requiring immediate attention

; Colors for log messages (BGR format for RichEdit)
Global Const $c_Log_Color_Debug = 0xFFA500    ; Blue color for debug messages
Global Const $c_Log_Color_Info = 0x008000     ; Green color for info messages
Global Const $c_Log_Color_Warning = 0x00C8FF  ; Orange color for warning messages
Global Const $c_Log_Color_Error = 0x0000CC    ; Red color for error messages
Global Const $c_Log_Color_Critical = 0x0000FF ; Bright red color for critical messages
#EndRegion Logging System