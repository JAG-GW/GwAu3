#include-once

#Region Global Variables
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
Global $g_p_AreaInfo

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

;UI
Global $g_d_EnterMission = DllStructCreate('ptr;dword')
Global $g_p_EnterMission = DllStructGetPtr($g_d_EnterMission)
Global $g_d_SetDifficulty = DllStructCreate('ptr;dword')
Global $g_p_SetDifficulty = DllStructGetPtr($g_d_SetDifficulty)
Global $g_d_OpenChest = DllStructCreate('ptr;dword')
Global $g_p_OpenChest = DllStructGetPtr($g_d_OpenChest)

;Bot related
Global $g_bAutoStart = False  ; Flag for auto-start
Global $g_s_MainCharName  = ""
#EndRegion Global Variables
