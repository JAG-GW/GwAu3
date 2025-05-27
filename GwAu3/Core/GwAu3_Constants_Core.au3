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
Global Const $GWAU3_LAST_UPDATE = "2025-05-22" ; Last update of the library
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
Global $mCurrentStatus                       ; Current status of the character (idle, moving, etc.)
Global $mUseEventSystem                      ; Flag to enable/disable event system
Global $mUseStringLog                        ; Flag to enable/disable string logging
Global $mDisableRendering                    ; Flag to enable/disable game rendering
Global $lTemp                                ; Temporary variable for various operations
#EndRegion Game State

#Region Game Data Pointers
; Pointers to important game data structures
Global $mBasePointer                         ; Pointer to game base structure
Global $mMyID                                ; Player's agent ID
Global $mPacketLocation                      ; Pointer to packet handler
Global $mTargetLogBase                       ; Base address of target log
Global $mStringLogBase                       ; Base address of string log
Global $mEnsureEnglish                       ; Flag to ensure English language
Global $mStringHandlerPtr                    ; Pointer to string handler
Global $mWriteChatSender                     ; Pointer to chat sender
Global $mLastDialogID                        ; ID of the last dialog
#EndRegion Game Data Pointers

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

#Region Command Processing
; Variables related to command queue processing
Global $mQueueCounter                        ; Current position in command queue
Global $mQueueSize                           ; Size of command queue
Global $mQueueBase                           ; Base address of command queue

; Action command structure
Global $mAction = DllStructCreate('ptr;dword;dword;')
Global $mActionPtr = DllStructGetPtr($mAction)

; Packet command structure
Global $mPacket = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Global $mPacketPtr = DllStructGetPtr($mPacket)
#EndRegion Command Processing

#Region Event System
; Event callback functions
Global $mSkillActivate                       ; Function to call when a skill is activated
Global $mSkillCancel                         ; Function to call when a skill is canceled
Global $mSkillComplete                       ; Function to call when a skill completes
Global $mChatReceive                         ; Function to call when a chat message is received
Global $mLoadFinished                        ; Function to call when map loading is complete

; Structures for event data
Global $mSkillLogStruct = DllStructCreate('dword;dword;dword;float')
Global $mSkillLogStructPtr = DllStructGetPtr($mSkillLogStruct)
Global $mChatLogStruct = DllStructCreate('dword;wchar[256]')
Global $mChatLogStructPtr = DllStructGetPtr($mChatLogStruct)

; Event type constants
Global Const $GWAU3_EVENT_SKILL_ACTIVATE = 0x1  ; Skill activation event
Global Const $GWAU3_EVENT_SKILL_CANCEL = 0x2    ; Skill cancellation event
Global Const $GWAU3_EVENT_SKILL_COMPLETE = 0x3  ; Skill completion event
Global Const $GWAU3_EVENT_CHAT_RECEIVE = 0x4    ; Chat message event
Global Const $GWAU3_EVENT_LOAD_FINISHED = 0x5   ; Map loading finished event

; Chat channel constants
Global Const $GWAU3_CHAT_ALLIANCE = 0           ; Alliance chat channel
Global Const $GWAU3_CHAT_ALL = 3                ; All chat channel (local area)
Global Const $GWAU3_CHAT_GUILD = 9              ; Guild chat channel
Global Const $GWAU3_CHAT_TEAM = 11              ; Team chat channel
Global Const $GWAU3_CHAT_TRADE = 12             ; Trade chat channel
Global Const $GWAU3_CHAT_GLOBAL = 10            ; Global chat channel
Global Const $GWAU3_CHAT_ADVISORY = 13          ; Advisory/system messages channel
Global Const $GWAU3_CHAT_WHISPER = 14           ; Whisper/private messages channel
#EndRegion Event System

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