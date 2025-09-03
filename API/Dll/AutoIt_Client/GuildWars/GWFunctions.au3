#include-once
#include "../API/GWRPCScanner.au3"
#include "../API/GWRPCFunction.au3"
#include "../API/GWRPCMemory.au3"

; ==================================
; Guild Wars Function Pointers
; ==================================

Global $g_pMoveTo = 0
Global $g_pSendChat = 0
Global $g_pChangeTarget = 0
Global $g_pUseSkill = 0
Global $g_pUseItem = 0

Global $g_bGWFunctionsInitialized = False

; ==================================
; Initialization
; ==================================

Func GW_InitializeFunctions()
    RPCClient_DebugOut("[GW] Initializing Guild Wars functions...")

    Local $count = 0

    ; MoveTo
    If _GW_InitMoveTo() Then $count += 1

    ; SendChat
    If _GW_InitSendChat() Then $count += 1

    ; ChangeTarget
    If _GW_InitChangeTarget() Then $count += 1

    ; UseSkill
    If _GW_InitUseSkill() Then $count += 1

    RPCClient_DebugOut("[GW] Initialized " & $count & " functions")

    If $count > 0 Then
        $g_bGWFunctionsInitialized = True
        Return True
    EndIf

    Return False
EndFunc

; ==================================
; MoveTo Function
; ==================================

Func _GW_InitMoveTo()
    ; Find MoveTo pattern
    Local $call_addr = RPCScanner_Find("83 c4 0c 85 ff 74 0b 56 6a 03", "xxxxxxxxxx", -0x5, $RPC_SECTION_TEXT)
    If Not $call_addr Then Return False

    ; Get function address
    $g_pMoveTo = RPCScanner_FunctionFromNearCall($call_addr)
    If Not $g_pMoveTo Then Return False

    ; Register function (CDECL, 1 param, no return)
    Return RPCFunc_Register("GW_MoveTo", $g_pMoveTo, 1, $RPC_CONV_CDECL, False)
EndFunc

Func GW_MoveTo($x, $y, $zplane = 0)
    If Not $g_bGWFunctionsInitialized Then
        RPCClient_DebugOut("[GW] Functions not initialized")
        Return False
    EndIf

    ; Allocate memory for coordinates
    Local $pCoords = RPCMemory_Allocate(16, $RPC_PAGE_READWRITE)
    If Not $pCoords Then Return False

    ; Create coordinate structure
    Local $tCoords = DllStructCreate("float;float;float;float")
    DllStructSetData($tCoords, 1, Number($x, 3))
    DllStructSetData($tCoords, 2, Number($y, 3))
    DllStructSetData($tCoords, 3, Number($zplane, 3))
    DllStructSetData($tCoords, 4, 0.0)

    ; Write to memory
    Local $tBytes = DllStructCreate("byte[16]", DllStructGetPtr($tCoords))
    RPCMemory_Write($pCoords, DllStructGetData($tBytes, 1), 16)

    ; Call function
    Local $params[1] = [$pCoords]
    Local $result = RPCFunc_Call("GW_MoveTo", $params)

    ; Free memory
    RPCMemory_Free($pCoords)

    Return $result
EndFunc

; ==================================
; SendChat Function
; ==================================

Func _GW_InitSendChat()
    Local $addr = RPCScanner_FindAssertion("GmChat.cpp", "!(Channel::CHAT_MAX <= chat_channel)", 0, 0x1E)
    If Not $addr Then Return False

    $g_pSendChat = $addr
    Return RPCFunc_Register("GW_SendChat", $g_pSendChat, 2, $RPC_CONV_STDCALL, False)
EndFunc

Func GW_SendChat($sMessage, $iChannel = 0)
    If Not $g_bGWFunctionsInitialized Then Return False

    ; Allocate memory for message
    Local $msgLen = (StringLen($sMessage) + 1) * 2
    Local $pMsg = RPCMemory_Allocate($msgLen, $RPC_PAGE_READWRITE)
    If Not $pMsg Then Return False

    ; Write message
    RPCMemory_Write($pMsg, StringToBinary($sMessage, 2), $msgLen)

    ; Call function
    Local $params[2] = [$iChannel, $pMsg]
    Local $result = RPCFunc_Call("GW_SendChat", $params)

    ; Free memory
    RPCMemory_Free($pMsg)

    Return $result
EndFunc

; ==================================
; ChangeTarget Function
; ==================================

Func _GW_InitChangeTarget()
    Local $addr = RPCScanner_FindAssertion("AvSelect.cpp", "!(autoAgentId && !ManagerFindAgent(autoAgentId))", 0, 0)
    If Not $addr Then Return False

    $g_pChangeTarget = RPCScanner_ToFunctionStart($addr)
    If Not $g_pChangeTarget Then Return False

    Return RPCFunc_Register("GW_ChangeTarget", $g_pChangeTarget, 1, $RPC_CONV_STDCALL, True)
EndFunc

Func GW_ChangeTarget($iAgentId)
    If Not $g_bGWFunctionsInitialized Then Return False

    Local $params[1] = [$iAgentId]
    Return RPCFunc_Call("GW_ChangeTarget", $params)
EndFunc

; ==================================
; UseSkill Function
; ==================================

Func _GW_InitUseSkill()
    Local $addr = RPCScanner_Find("85 FF 74 60 57", "xxxxx", -0x04, $RPC_SECTION_TEXT)
    If Not $addr Then Return False

    $g_pUseSkill = $addr
    Return RPCFunc_Register("GW_UseSkill", $g_pUseSkill, 3, $RPC_CONV_STDCALL, False)
EndFunc

Func GW_UseSkill($iSkillSlot, $iTarget = 0, $bCallTarget = False)
    If Not $g_bGWFunctionsInitialized Then Return False

    Local $params[3] = [$iSkillSlot, $iTarget, $bCallTarget ? 1 : 0]
    Return RPCFunc_Call("GW_UseSkill", $params)
EndFunc

; ==================================
; Cleanup
; ==================================

Func GW_CleanupFunctions()
    If Not $g_bGWFunctionsInitialized Then Return

    RPCFunc_Unregister("GW_MoveTo")
    RPCFunc_Unregister("GW_SendChat")
    RPCFunc_Unregister("GW_ChangeTarget")
    RPCFunc_Unregister("GW_UseSkill")

    $g_bGWFunctionsInitialized = False
EndFunc