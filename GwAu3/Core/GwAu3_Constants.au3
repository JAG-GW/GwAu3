#include-once

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
Global $g_h_EditText		; RichEdit control for logging
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
Global $mDisableRendering                    ; Flag to enable/disable game rendering
#EndRegion Game State

#Region Assembler Variables
; Variables for assembler functionality
Global $mASMString                           ; String containing assembled ASM code
Global $mASMSize                             ; Size of assembled ASM code
Global $mASMCodeOffset                       ; Offset in ASM code
Global $g_amx2_Labels[1][2] = [[0]]                ; Array to store labels and their values
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
Global $g_b_DebugMode = True

; Log message types
Global Enum $g_e_Log_MsgType_Debug 		= 0, _	; Detailed information for debugging purposes
			$g_e_Log_MsgType_Info 		= 1, _	; General operational information
			$g_e_Log_MsgType_Warning 	= 2, _	; Warning messages for potential issues
			$g_e_Log_MsgType_Error 		= 3, _	; Error messages for operation failures
			$g_e_Log_MsgType_Critical 	= 4     ; Critical errors requiring immediate attention
#EndRegion Logging System



Global $aScanResults

#Region Global Variables
; Structure to store pattern information
Global $g_aPatterns[1][6] = [[0]] ; [full_name, pattern, offset, type, is_assertion, assertion_msg]
Global $g_aAssertionPatterns[0][2] ; [file, message]

; Pattern types
Global Const $PATTERN_TYPE_PTR = 'Ptr'    ; Pointer to data
Global Const $PATTERN_TYPE_FUNC = 'Func'  ; Function to call
Global Const $PATTERN_TYPE_HOOK = 'Hook'  ; Hook/injection point

Global $mInviteGuild = DllStructCreate('ptr;dword;dword header;dword counter;wchar name[32];dword type')
Global $mInviteGuildPtr = DllStructGetPtr($mInviteGuild)

Global $mSendChat = DllStructCreate('ptr;dword')
Global $mSendChatPtr = DllStructGetPtr($mSendChat)

Global $mAction = DllStructCreate('ptr;dword;dword;')
Global $mActionPtr = DllStructGetPtr($mAction)

Global $mPacket = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Global $mPacketPtr = DllStructGetPtr($mPacket)

Global $mSkillLogStruct = DllStructCreate('dword;dword;dword');float')
Global $mSkillLogStructPtr = DllStructGetPtr($mSkillLogStruct)
Global $mGUI = 0;GUICreate('GwAu3')
;GUIRegisterMsg(0x501, 'Event')

Global $mBasePointer
Global $mPacketLocation
Global $mQueueCounter
Global $mQueueSize
Global $mQueueBase
Global $mPreGame
Global $mFrameArray
Global $mFriendList
Global $mPostMessageA

;Skill
Global $g_mSkillBase
Global $g_mSkillTimer
Global $g_mUseSkill = DllStructCreate('ptr;dword;dword;dword;bool')
Global $g_mUseSkillPtr = DllStructGetPtr($g_mUseSkill)
Global $g_mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Global $g_mUseHeroSkillPtr = DllStructGetPtr($g_mUseHeroSkill)
Global $g_iLastSkillUsed = 0
Global $g_iLastSkillTarget = 0

;Friend
Global $g_mFriendList
Global $g_mChangeStatus = DllStructCreate('ptr;dword')
Global $g_mChangeStatusPtr = DllStructGetPtr($g_mChangeStatus)
Global $g_mAddFriend = DllStructCreate('ptr;ptr;ptr;dword')
Global $g_mAddFriendPtr = DllStructGetPtr($g_mAddFriend)
Global $g_mRemoveFriend = DllStructCreate('ptr;byte[16];ptr;dword')
Global $g_mRemoveFriendPtr = DllStructGetPtr($g_mRemoveFriend)
Global $g_iLastStatus = 0

;Attribute
Global $g_mAttributeInfo
Global $g_mIncreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_mIncreaseAttributePtr = DllStructGetPtr($g_mIncreaseAttribute)
Global $g_mDecreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_mDecreaseAttributePtr = DllStructGetPtr($g_mDecreaseAttribute)
Global $g_bAttributeModuleInitialized = False
Global $g_iLastAttributeModified = -1
Global $g_iLastAttributeValue = 0

;Trade
Global $g_mBuyItemBase      ; Pointer to buy item base
Global $g_mTraderQuoteID    ; Current trader quote ID
Global $g_mTraderCostID     ; Trader cost ID
Global $g_mTraderCostValue  ; Trader cost value
Global $g_mSalvageGlobal    ; Pointer to salvage global data
Global $g_mSellItem = DllStructCreate('ptr;dword;dword;dword')
Global $g_mSellItemPtr = DllStructGetPtr($g_mSellItem)
Global $g_mBuyItem = DllStructCreate('ptr;dword;dword;dword;dword')
Global $g_mBuyItemPtr = DllStructGetPtr($g_mBuyItem)
Global $g_mCraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Global $g_mCraftItemExPtr = DllStructGetPtr($g_mCraftItemEx)
Global $g_mRequestQuote = DllStructCreate('ptr;dword')
Global $g_mRequestQuotePtr = DllStructGetPtr($g_mRequestQuote)
Global $g_mRequestQuoteSell = DllStructCreate('ptr;dword')
Global $g_mRequestQuoteSellPtr = DllStructGetPtr($g_mRequestQuoteSell)
Global $g_mTraderBuy = DllStructCreate('ptr')
Global $g_mTraderBuyPtr = DllStructGetPtr($g_mTraderBuy)
Global $g_mTraderSell = DllStructCreate('ptr')
Global $g_mTraderSellPtr = DllStructGetPtr($g_mTraderSell)
Global $g_mSalvage = DllStructCreate('ptr;dword;dword;dword')
Global $g_mSalvagePtr = DllStructGetPtr($g_mSalvage)
Global $g_bTradeModuleInitialized = False
Global $g_iLastTransactionType = -1
Global $g_iLastItemID = 0
Global $g_iLastQuantity = 0
Global $g_iLastPrice = 0

;Agent
Global $g_mAgentBase      ; Pointer to agent array
Global $g_mMaxAgents      ; Maximum number of agents
Global $g_mMyID           ; Player's agent ID
Global $g_mCurrentTarget  ; Current target agent ID
Global $g_mAgentCopyCount ; Count of copied agents
Global $g_mAgentCopyBase  ; Base address of agent copy array
Global $g_mChangeTarget = DllStructCreate('ptr;dword')
Global $g_mChangeTargetPtr = DllStructGetPtr($g_mChangeTarget)
Global $g_mMakeAgentArray = DllStructCreate('ptr;dword')
Global $g_mMakeAgentArrayPtr = DllStructGetPtr($g_mMakeAgentArray)
Global $g_bAgentModuleInitialized = False
Global $g_iLastTargetID = 0

;Map
Global $g_mMapIsLoaded      ; Flag indicating if map is loaded
Global $g_mMapLoading       ; Flag indicating if map is loading
Global $g_mInstanceInfo     ; Pointer to instance information
Global $g_mAreaInfo         ; Pointer to area information
Global $g_mWorldConst       ; Pointer to world constants
Global $g_mRegion
Global $g_mMove = DllStructCreate('ptr;float;float;float')
Global $g_mMovePtr = DllStructGetPtr($g_mMove)
Global $g_bMapModuleInitialized = False
Global $g_fLastMoveX = 0
Global $g_fLastMoveY = 0
Global $g_mClickCoordsX = 0
Global $g_mClickCoordsY = 0
#EndRegion Global Variables
