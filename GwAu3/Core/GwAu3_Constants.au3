#include-once

;===================================================================================================
; GwAu3_Globals.au3
; Description: Contains all global variables and constants used by the GwAu3 library
; Author: Greg76 and contributors
; Version: 3.0
;===================================================================================================

#Region Version Information
; Version identifiers for the GwAu3 library
Global Const $GC_S_GWA2_CREATOR = "GameRevision Community" ; Creator
Global Const $GC_S_GWA2_BUILD_DATE = "approximately 2007" ; Build date of the gwa2 library

Global Const $GC_S_GWAU3_VERSION = "1.0"         ; Current version of GwAu3 library
Global Const $GC_S_GWAU3_BUILD_DATE = "2025-05-21" ; Build date of the library
Global Const $GC_S_GWAU3_LAST_UPDATE = "2025-06-16" ; Last update of the library
Global Const $GC_S_GWAU3_UPDATOR = "Jag-Gw Community" ; Updator
#EndRegion Version Information

#Region GUI Elements
; Global GUI elements used across the library
Global $g_h_EditText		; RichEdit control for logging
#EndRegion GUI Elements

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

#Region Game State
; Variables related to game state
Global $g_p_CharName                            ; Character name
Global $g_p_Ping                                ; Current ping to server in milliseconds
Global $g_b_DisableRendering                    ; Flag to enable/disable game rendering
#EndRegion Game State

#Region Assembler Variables
; Variables for assembler functionality
Global $g_s_ASMCode                           ; String containing assembled ASM code
Global $g_i_ASMSize                             ; Size of assembled ASM code
Global $g_i_ASMCodeOffset                      ; Offset in ASM code
Global $g_amx2_Labels[1][2] = [[0]]                ; Array to store labels and their values
#EndRegion Assembler Variables

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



Global $g_ap_ScanResults

#Region Global Variables
; Structure to store pattern information
Global $g_amx2_Patterns[1][6] = [[0]] ; [full_name, pattern, offset, type, is_assertion, assertion_msg]
Global $g_amx2_AssertionPatterns[0][2] ; [file, message]

; Pattern types
Global Const $GC_S_PATTERN_TYPE_PTR  = 'Ptr'    ; Pointer to data
Global Const $GC_S_PATTERN_TYPE_FUNC = 'Func'  ; Function to call
Global Const $GC_S_PATTERN_TYPE_HOOK = 'Hook'  ; Hook/injection point

Global $g_d_InviteGuild = DllStructCreate('ptr;dword;dword header;dword counter;wchar name[32];dword type')
Global $g_p_InviteGuild = DllStructGetPtr($g_d_InviteGuild)

Global $g_d_SendChat = DllStructCreate('ptr;dword')
Global $g_p_SendChat = DllStructGetPtr($g_d_SendChat)

Global $g_d_Action = DllStructCreate('ptr;dword;dword;')
Global $g_p_Action = DllStructGetPtr($g_d_Action)

Global $g_d_Packet = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Global $g_p_Packet = DllStructGetPtr($g_d_Packet)

Global $g_d_SkillLog = DllStructCreate('dword;dword;dword');float')
Global $g_p_SkillLog = DllStructGetPtr($g_d_SkillLog)
Global $g_h_GUI = 0

Global $g_p_BasePointer
Global $g_p_PacketLocation
Global $g_i_QueueCounter
Global $g_i_QueueSize
Global $g_p_QueueBase
Global $g_p_PreGame
Global $g_p_FrameArray

;Skill
Global $g_p_SkillBase
Global $g_p_SkillTimer
Global $g_d_UseSkill = DllStructCreate('ptr;dword;dword;dword;bool')
Global $g_p_UseSkill = DllStructGetPtr($g_d_UseSkill)
Global $g_d_UseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Global $g_p_UseHeroSkill = DllStructGetPtr($g_d_UseHeroSkill)
Global $g_i_LastSkillUsed = 0
Global $g_i_LastSkillTarget = 0

;Friend
Global $g_p_FriendList
Global $g_d_ChangeStatus = DllStructCreate('ptr;dword')
Global $g_p_ChangeStatus = DllStructGetPtr($g_d_ChangeStatus)
Global $g_d_AddFriend = DllStructCreate('ptr;ptr;ptr;dword')
Global $g_p_AddFriend = DllStructGetPtr($g_d_AddFriend)
Global $g_d_RemoveFriend = DllStructCreate('ptr;byte[16];ptr;dword')
Global $g_p_RemoveFriend = DllStructGetPtr($g_d_RemoveFriend)
Global $g_i_LastStatus = 0

;Attribute
Global $g_p_AttributeInfo
Global $g_d_IncreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_p_IncreaseAttribute = DllStructGetPtr($g_d_IncreaseAttribute)
Global $g_d_DecreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_p_DecreaseAttribute = DllStructGetPtr($g_d_DecreaseAttribute)
Global $g_i_LastAttributeModified = -1
Global $g_i_LastAttributeValue = -1

;Trade
Global $g_p_BuyItemBase      ; Pointer to buy item base
Global $g_i_TraderQuoteID    ; Current trader quote ID
Global $g_i_TraderCostID     ; Trader cost ID
Global $g_f_TraderCostValue  ; Trader cost value
Global $g_p_SalvageGlobal    ; Pointer to salvage global data
Global $g_d_SellItem = DllStructCreate('ptr;dword;dword;dword')
Global $g_p_SellItem = DllStructGetPtr($g_d_SellItem)
Global $g_d_BuyItem = DllStructCreate('ptr;dword;dword;dword;dword')
Global $g_p_BuyItem = DllStructGetPtr($g_d_BuyItem)
Global $g_d_CraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Global $g_p_CraftItemEx = DllStructGetPtr($g_d_CraftItemEx)
Global $g_d_RequestQuote = DllStructCreate('ptr;dword')
Global $g_p_RequestQuote = DllStructGetPtr($g_d_RequestQuote)
Global $g_d_RequestQuoteSell = DllStructCreate('ptr;dword')
Global $g_p_RequestQuoteSell = DllStructGetPtr($g_d_RequestQuoteSell)
Global $g_d_TraderBuy = DllStructCreate('ptr')
Global $g_p_TraderBuy = DllStructGetPtr($g_d_TraderBuy)
Global $g_d_TraderSell = DllStructCreate('ptr')
Global $g_p_TraderSell = DllStructGetPtr($g_d_TraderSell)
Global $g_d_Salvage = DllStructCreate('ptr;dword;dword;dword')
Global $g_p_Salvage = DllStructGetPtr($g_d_Salvage)
Global $g_i_LastTransactionType = -1
Global $g_i_LastItemID = 0
Global $g_i_LastQuantity = 0
Global $g_i_LastPrice = 0

;Agent
Global $g_p_AgentBase      ; Pointer to agent array
Global $g_i_MaxAgents      ; Maximum number of agents
Global $g_i_MyID           ; Player's agent ID
Global $g_i_CurrentTarget  ; Current target agent ID
Global $g_i_AgentCopyCount ; Count of copied agents
Global $g_p_AgentCopyBase  ; Base address of agent copy array
Global $g_d_ChangeTarget = DllStructCreate('ptr;dword')
Global $g_p_ChangeTarget = DllStructGetPtr($g_d_ChangeTarget)
Global $g_d_MakeAgentArray = DllStructCreate('ptr;dword')
Global $g_p_MakeAgentArray = DllStructGetPtr($g_d_MakeAgentArray)
Global $g_i_LastTargetID = 0

;Map
Global $g_p_InstanceInfo     ; Pointer to instance information
Global $g_p_WorldConst       ; Pointer to world constants
Global $g_p_Region
Global $g_d_Move = DllStructCreate('ptr;float;float;float')
Global $g_p_Move = DllStructGetPtr($g_d_Move)
Global $g_f_LastMoveX = 0
Global $g_f_LastMoveY = 0
Global $g_f_ClickCoordsX = 0
Global $g_f_ClickCoordsY = 0
#EndRegion Global Variables
