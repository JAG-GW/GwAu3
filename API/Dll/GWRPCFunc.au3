#include-once
#include <WinAPI.au3>
#include <Memory.au3>

; ==================================
; RPC Function Management for GWTools
; ==================================
; Version: 1.0
; Purpose: Register and call functions via RPC

; ==================================
; Constants - Function Operations
; ==================================
Global Const $RPCF_REGISTER_FUNCTION = 10
Global Const $RPCF_UNREGISTER_FUNCTION = 11
Global Const $RPCF_CALL_FUNCTION = 12
Global Const $RPCF_LIST_FUNCTIONS = 13

; Parameter types
Global Const $RPCF_PARAM_INT8 = 1
Global Const $RPCF_PARAM_INT16 = 2
Global Const $RPCF_PARAM_INT32 = 3
Global Const $RPCF_PARAM_INT64 = 4
Global Const $RPCF_PARAM_FLOAT = 5
Global Const $RPCF_PARAM_DOUBLE = 6
Global Const $RPCF_PARAM_POINTER = 7
Global Const $RPCF_PARAM_STRING = 8
Global Const $RPCF_PARAM_WSTRING = 9

; Calling conventions
Global Const $RPCF_CONV_CDECL = 1
Global Const $RPCF_CONV_STDCALL = 2
Global Const $RPCF_CONV_FASTCALL = 3
Global Const $RPCF_CONV_THISCALL = 4

; ==================================
; Function Registration
; ==================================

Func RPCFunc_Register($sName, $pAddress, $iParamCount = 0, $iConvention = $RPCF_CONV_STDCALL, $bHasReturn = True)
    Out("[RPCFUNC] Registering function: " & $sName & " at 0x" & Hex($pAddress))

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Structure for REGISTER_FUNCTION request
    ; Type at offset 0, then union at offset 4
    ; register_func struct in union:
    ;   char name[64]
    ;   uintptr_t address
    ;   uint8_t param_count
    ;   uint8_t convention
    ;   uint8_t has_return
    ;   uint8_t padding[1]

    Local $tReq = DllStructCreate("int type; char name[64]; ptr address; byte param_count; byte convention; byte has_return; byte padding", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPCF_REGISTER_FUNCTION)
    DllStructSetData($tReq, "name", $sName)
    DllStructSetData($tReq, "address", $pAddress)
    DllStructSetData($tReq, "param_count", $iParamCount)
    DllStructSetData($tReq, "convention", $iConvention)
    DllStructSetData($tReq, "has_return", $bHasReturn ? 1 : 0)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send register request")
        Return False
    EndIf

    ; Parse response
    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Out("[SUCCESS] Function '" & $sName & "' registered successfully")
        Return True
    Else
        Out("[ERROR] Failed to register function: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

; ==================================
; Function Unregistration
; ==================================

Func RPCFunc_Unregister($sName)
    Out("[RPCFUNC] Unregistering function: " & $sName)

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; For UNREGISTER_FUNCTION, we use call_func struct which starts with name[64]
    Local $tReq = DllStructCreate("int type; char name[64]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPCF_UNREGISTER_FUNCTION)
    DllStructSetData($tReq, "name", $sName)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send unregister request")
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Out("[SUCCESS] Function '" & $sName & "' unregistered")
        Return True
    Else
        Out("[ERROR] Failed to unregister: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

; ==================================
; Function Calling
; ==================================

Func RPCFunc_Call($sName, $aParams = 0)
    Out("[RPCFUNC] Calling function: " & $sName)

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    ; Calculate param count
    Local $iParamCount = 0
    If IsArray($aParams) Then
        $iParamCount = UBound($aParams)
    EndIf

    ; Build request structure
    ; call_func struct:
    ;   char name[64]
    ;   uint8_t param_count
    ;   uint8_t padding[3]
    ;   FunctionParam params[10]

    ; First set up the basic structure
    Local $tReq = DllStructCreate("int type; char name[64]; byte param_count; byte padding[3]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPCF_CALL_FUNCTION)
    DllStructSetData($tReq, "name", $sName)
    DllStructSetData($tReq, "param_count", $iParamCount)

    ; Now handle parameters if any
    If $iParamCount > 0 Then
        ; Each FunctionParam is:
        ; ParamType type (1 byte)
        ; uint8_t padding[3] (3 bytes)
        ; union value (264 bytes)
        ; Total: 268 bytes per param

        Local $iParamOffset = 4 + 64 + 4  ; After type, name, param_count and padding

        For $i = 0 To $iParamCount - 1
            Local $paramValue = $aParams[$i]
            Local $paramType = 0

            ; Determine parameter type
            If IsString($paramValue) Then
                $paramType = $RPCF_PARAM_STRING
            ElseIf IsFloat($paramValue) Then
                $paramType = $RPCF_PARAM_FLOAT
            ElseIf IsInt($paramValue) Then
                ; Check if it's a pointer (high value)
                If $paramValue > 0x10000000 Then
                    $paramType = $RPCF_PARAM_POINTER
                Else
                    $paramType = $RPCF_PARAM_INT32
                EndIf
            ElseIf IsPtr($paramValue) Then
                $paramType = $RPCF_PARAM_POINTER
            Else
                $paramType = $RPCF_PARAM_INT32  ; Default
            EndIf

            ; Create param structure at correct offset
            Local $tParam = DllStructCreate("byte type; byte padding[3]; byte value[264]", _
                                            DllStructGetPtr($tRequest) + $iParamOffset)

            DllStructSetData($tParam, "type", $paramType)

            ; Set the value based on type
            Switch $paramType
                Case $RPCF_PARAM_INT32
                    Local $tValue = DllStructCreate("int", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_FLOAT
                    Local $tValue = DllStructCreate("float", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_POINTER
                    Local $tValue = DllStructCreate("ptr", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_STRING
                    Local $tValue = DllStructCreate("char[256]", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)
            EndSwitch

            Out("[RPCFUNC]   Param " & $i & ": Type=" & $paramType & ", Value=" & $paramValue)

            $iParamOffset += 268  ; Move to next param slot
        Next
    EndIf

    ; Send request
    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send call request")
        Return 0
    EndIf

    ; Parse response
    ; call_result struct in response union:
    ;   uint8_t has_return
    ;   uint8_t padding[3]
    ;   union return_value (int/float/ptr)
    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte has_return; byte padding2[3]; ptr return_value; byte data[1272]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        If DllStructGetData($tResp, "has_return") Then
            Local $retVal = DllStructGetData($tResp, "return_value")
            Out("[SUCCESS] Function returned: 0x" & Hex($retVal))
            Return $retVal
        Else
            Out("[SUCCESS] Function called (no return value)")
            Return True
        EndIf
    Else
        Out("[ERROR] Function call failed: " & DllStructGetData($tResp, "error"))
        Return 0
    EndIf
EndFunc

; ==================================
; List Functions
; ==================================

Func RPCFunc_List()
    Out("[RPCFUNC] Listing registered functions")

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    Local $tReq = DllStructCreate("int type", DllStructGetPtr($tRequest))
    DllStructSetData($tReq, "type", $RPCF_LIST_FUNCTIONS)

    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send list request")
        Return ""
    EndIf

    ; function_list struct in response:
    ;   uint32_t count
    ;   char names[20][64]
    Local $tResp = DllStructCreate("byte success; byte padding[3]; uint count", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $count = DllStructGetData($tResp, "count")
        Out("[SUCCESS] Found " & $count & " registered functions")

        Local $aFunctions[$count]

        ; Read each function name
        For $i = 0 To $count - 1
            ; Each name is 64 bytes, starting after success(1) + padding(3) + count(4) = 8 bytes
            Local $tName = DllStructCreate("char[64]", DllStructGetPtr($tResponse) + 8 + ($i * 64))
            $aFunctions[$i] = DllStructGetData($tName, 1)
            Out("  [" & $i & "] " & $aFunctions[$i])
        Next

        Return $aFunctions
    Else
        Local $tError = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                        DllStructGetPtr($tResponse))
        Out("[ERROR] Failed to list functions: " & DllStructGetData($tError, "error"))
        Return ""
    EndIf
EndFunc

; ==================================
; Helper Functions for Parameters
; ==================================

Func RPCFunc_CreateIntParam($value)
    Local $param[2] = [$RPCF_PARAM_INT32, $value]
    Return $param
EndFunc

Func RPCFunc_CreateFloatParam($value)
    Local $param[2] = [$RPCF_PARAM_FLOAT, $value]
    Return $param
EndFunc

Func RPCFunc_CreatePtrParam($value)
    Local $param[2] = [$RPCF_PARAM_POINTER, $value]
    Return $param
EndFunc

Func RPCFunc_CreateStringParam($value)
    Local $param[2] = [$RPCF_PARAM_STRING, $value]
    Return $param
EndFunc

; ==================================
; Advanced Call with typed parameters
; ==================================

Func RPCFunc_CallEx($sName, $aTypedParams)
    ; $aTypedParams should be array of arrays: [[type, value], [type, value], ...]
    Out("[RPCFUNC] Calling function (extended): " & $sName)

    Local $tRequest = _CreateRequest()
    Local $tResponse = _CreateResponse()

    Local $iParamCount = 0
    If IsArray($aTypedParams) Then
        $iParamCount = UBound($aTypedParams)
    EndIf

    ; Build request
    Local $tReq = DllStructCreate("int type; char name[64]; byte param_count; byte padding[3]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPCF_CALL_FUNCTION)
    DllStructSetData($tReq, "name", $sName)
    DllStructSetData($tReq, "param_count", $iParamCount)

    ; Add parameters
    If $iParamCount > 0 Then
        Local $iParamOffset = 4 + 64 + 4

        For $i = 0 To $iParamCount - 1
            Local $paramType = $aTypedParams[$i][0]
            Local $paramValue = $aTypedParams[$i][1]

            Local $tParam = DllStructCreate("byte type; byte padding[3]; byte value[264]", _
                                            DllStructGetPtr($tRequest) + $iParamOffset)

            DllStructSetData($tParam, "type", $paramType)

            ; Set value based on type
            Switch $paramType
                Case $RPCF_PARAM_INT8
                    Local $tValue = DllStructCreate("byte", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_INT16
                    Local $tValue = DllStructCreate("short", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_INT32
                    Local $tValue = DllStructCreate("int", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_FLOAT
                    Local $tValue = DllStructCreate("float", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_DOUBLE
                    Local $tValue = DllStructCreate("double", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_POINTER
                    Local $tValue = DllStructCreate("ptr", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_STRING
                    Local $tValue = DllStructCreate("char[256]", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)

                Case $RPCF_PARAM_WSTRING
                    Local $tValue = DllStructCreate("wchar[128]", DllStructGetPtr($tParam, "value"))
                    DllStructSetData($tValue, 1, $paramValue)
            EndSwitch

            Out("[RPCFUNC]   Param " & $i & ": Type=" & $paramType & ", Value=" & $paramValue)

            $iParamOffset += 268
        Next
    EndIf

    ; Send and get response
    If Not _SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Out("[ERROR] Failed to send call request")
        Return 0
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte has_return; byte padding2[3]; ptr return_value; byte data[1272]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        If DllStructGetData($tResp, "has_return") Then
            Local $retVal = DllStructGetData($tResp, "return_value")
            Out("[SUCCESS] Function returned: 0x" & Hex($retVal))
            Return $retVal
        Else
            Out("[SUCCESS] Function called (void)")
            Return True
        EndIf
    Else
        Out("[ERROR] Call failed: " & DllStructGetData($tResp, "error"))
        Return 0
    EndIf
EndFunc

; ==================================
; Test Functions for Guild Wars
; ==================================

Func RPCFunc_TestGuildWars()
    Out("")
    Out("===== Testing RPC Function System =====")

    ; Test 1: List functions (should be empty initially)
    Out("")
    Out("--- Test 1: List Functions (Initial) ---")
    Local $aFuncs = RPCFunc_List()
    If IsArray($aFuncs) Then
        Out("Initial function count: " & UBound($aFuncs))
    Else
        Out("No functions registered yet")
    EndIf

    ; Test 2: Register some test functions
    Out("")
    Out("--- Test 2: Register Test Functions ---")

    ; Find some real GW functions first using scanner
    Local $TestFunc1 = RPCScanner_Find("55 8B EC 83 EC", "xxxxx", 0, $SECTION_TEXT)
    If $TestFunc1 Then
        RPCFunc_Register("TestFunction1", $TestFunc1, 2, $RPCF_CONV_STDCALL, True)
    EndIf

    ; Register a MessageBoxA for testing (if available)
    Local $hUser32 = _WinAPI_GetModuleHandle("user32.dll")
    If $hUser32 Then
        Local $pMessageBoxA = _WinAPI_GetProcAddress($hUser32, "MessageBoxA")
        If $pMessageBoxA Then
            RPCFunc_Register("MessageBoxA", $pMessageBoxA, 4, $RPCF_CONV_STDCALL, True)
            Out("Registered MessageBoxA at: 0x" & Hex($pMessageBoxA))
        EndIf
    EndIf

    ; Test 3: List functions again
    Out("")
    Out("--- Test 3: List Functions (After Registration) ---")
    $aFuncs = RPCFunc_List()

    ; Test 4: Try calling a simple function
    Out("")
    Out("--- Test 4: Call Function Test ---")

    ; If we have a simple function, try calling it
    If IsArray($aFuncs) And UBound($aFuncs) > 0 Then
        ; Try calling first registered function with no params
        Out("Attempting to call: " & $aFuncs[0])
        Local $result = RPCFunc_Call($aFuncs[0], 0)
        Out("Call result: " & $result)
    EndIf

    ; Test 5: Unregister a function
    Out("")
    Out("--- Test 5: Unregister Function ---")
    If IsArray($aFuncs) And UBound($aFuncs) > 0 Then
        RPCFunc_Unregister($aFuncs[0])
    EndIf

    ; Final list
    Out("")
    Out("--- Final Function List ---")
    RPCFunc_List()

    Out("")
    Out("===== RPC Function Tests Complete =====")
EndFunc

; ==================================
; Guild Wars Specific Functions
; ==================================

Func RPCFunc_RegisterGWFunctions()
    Out("")
    Out("===== Registering Guild Wars Functions =====")

    Local $count = 0

    ; Example: Register SendChat function
    Local $SendChat = RPCScanner_FindAssertion("GmChat.cpp", "!(Channel::CHAT_MAX <= chat_channel)", 0, 0x1E)
    If $SendChat Then
        RPCFunc_Register("SendChat", $SendChat, 2, $RPCF_CONV_STDCALL, False)
        $count += 1
    EndIf

    ; Example: Register ChangeTarget
    Local $ChangeTarget = RPCScanner_FindAssertion("AvSelect.cpp", "!(autoAgentId && !ManagerFindAgent(autoAgentId))", 0, 0)
    If $ChangeTarget Then
        $ChangeTarget = RPCScanner_ToFunctionStart($ChangeTarget)
        If $ChangeTarget Then
            RPCFunc_Register("ChangeTarget", $ChangeTarget, 1, $RPCF_CONV_STDCALL, True)
            $count += 1
        EndIf
    EndIf

    ; Example: Register UseSkill
    Local $UseSkill = RPCScanner_Find("85 FF 74 60 57", "xxxxx", -0x04, $SECTION_TEXT)
    If $UseSkill Then
        RPCFunc_Register("UseSkill", $UseSkill, 3, $RPCF_CONV_STDCALL, False)
        $count += 1
    EndIf

    Out("Registered " & $count & " Guild Wars functions")
    Return $count
EndFunc

; ==================================
; Import Functions (Add at top of your script)
; ==================================

Func Out($text)
    ConsoleWrite($text & @CRLF)
EndFunc

; ==================================
; Example Usage Functions
; ==================================

Func RPCFunc_Example_SendChat($channel, $message)
    ; Allocate memory for message
    Local $msgLen = StringLen($message) + 1
    Local $msgAddr = RPCMemory_Allocate($msgLen * 2)  ; Unicode

    If Not $msgAddr Then
        Out("[ERROR] Failed to allocate memory for message")
        Return False
    EndIf

    ; Write message to memory
    RPCMemory_Write($msgAddr, StringToBinary($message, 2), $msgLen * 2)

    ; Call SendChat
    Local $params[2] = [$channel, $msgAddr]
    Local $result = RPCFunc_Call("SendChat", $params)

    ; Free memory
    RPCMemory_Free($msgAddr)

    Return $result
EndFunc

Func RPCFunc_Example_ChangeTarget($agentId)
    Local $params[1] = [$agentId]
    Return RPCFunc_Call("ChangeTarget", $params)
EndFunc

Func RPCFunc_Example_UseSkill($skillSlot, $target, $callTarget)
    Local $params[3] = [$skillSlot, $target, $callTarget]
    Return RPCFunc_Call("UseSkill", $params)
EndFunc