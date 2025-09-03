#include-once
#include "../Core/GWRPCClient.au3"
#include "../Core/GWRPCProtocol.au3"

; ==================================
; Function Registration & Calling API
; ==================================

Func RPCFunc_Register($sName, $pAddress, $iParamCount = 0, $iConvention = $RPC_CONV_STDCALL, $bHasReturn = True)
    RPCClient_DebugOut("[FUNC] Register: " & $sName & " at 0x" & Hex($pAddress))

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; char name[64]; ptr address; byte param_count; byte convention; byte has_return; byte padding", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_REGISTER_FUNCTION)
    DllStructSetData($tReq, "name", $sName)
    DllStructSetData($tReq, "address", $pAddress)
    DllStructSetData($tReq, "param_count", $iParamCount)
    DllStructSetData($tReq, "convention", $iConvention)
    DllStructSetData($tReq, "has_return", $bHasReturn ? 1 : 0)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[FUNC] Registered successfully")
        Return True
    Else
        RPCClient_DebugOut("[FUNC] Registration failed: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

Func RPCFunc_Unregister($sName)
    RPCClient_DebugOut("[FUNC] Unregister: " & $sName)

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; char name[64]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_UNREGISTER_FUNCTION)
    DllStructSetData($tReq, "name", $sName)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[FUNC] Unregistered successfully")
        Return True
    Else
        RPCClient_DebugOut("[FUNC] Unregistration failed: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

Func RPCFunc_Call($sName, $aParams = 0)
    RPCClient_DebugOut("[FUNC] Call: " & $sName)

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $iParamCount = 0
    If IsArray($aParams) Then
        $iParamCount = UBound($aParams)
    EndIf

    Local $tReq = DllStructCreate("int type; char name[64]; byte param_count; byte padding[3]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_CALL_FUNCTION)
    DllStructSetData($tReq, "name", $sName)
    DllStructSetData($tReq, "param_count", $iParamCount)

    ; Handle parameters
    If $iParamCount > 0 Then
        Local $iParamOffset = 4 + 64 + 4  ; After type, name, param_count and padding

        For $i = 0 To $iParamCount - 1
            Local $paramValue = $aParams[$i]
            Local $paramType = _GetParamType($paramValue)

            Local $tParam = DllStructCreate("byte type; byte padding[3]; byte value[264]", _
                                            DllStructGetPtr($tRequest) + $iParamOffset)

            DllStructSetData($tParam, "type", $paramType)
            _SetParamValue($tParam, $paramType, $paramValue)

            RPCClient_DebugOut("[FUNC]   Param " & $i & ": Type=" & $paramType & ", Value=" & $paramValue)

            $iParamOffset += 268
        Next
    EndIf

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return 0
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte has_return; byte padding2[3]; ptr return_value; byte data[1272]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        If DllStructGetData($tResp, "has_return") Then
            Local $retVal = DllStructGetData($tResp, "return_value")
            RPCClient_DebugOut("[FUNC] Returned: 0x" & Hex($retVal))
            Return $retVal
        Else
            RPCClient_DebugOut("[FUNC] Called successfully (void)")
            Return True
        EndIf
    Else
        RPCClient_DebugOut("[FUNC] Call failed: " & DllStructGetData($tResp, "error"))
        Return 0
    EndIf
EndFunc

Func RPCFunc_List()
    RPCClient_DebugOut("[FUNC] List registered functions")

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type", DllStructGetPtr($tRequest))
    DllStructSetData($tReq, "type", $RPC_LIST_FUNCTIONS)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return ""
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; uint count", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $count = DllStructGetData($tResp, "count")
        RPCClient_DebugOut("[FUNC] Found " & $count & " functions")

        If $count = 0 Then Return ""

        Local $aFunctions[$count]

        For $i = 0 To $count - 1
            Local $tName = DllStructCreate("char[64]", DllStructGetPtr($tResponse) + 8 + ($i * 64))
            $aFunctions[$i] = DllStructGetData($tName, 1)
            RPCClient_DebugOut("[FUNC]   [" & $i & "] " & $aFunctions[$i])
        Next

        Return $aFunctions
    Else
        RPCClient_DebugOut("[FUNC] List failed")
        Return ""
    EndIf
EndFunc

; Internal helper functions
Func _GetParamType($value)
    If IsString($value) Then
        Return $RPC_PARAM_STRING
    ElseIf IsFloat($value) Then
        Return $RPC_PARAM_FLOAT
    ElseIf IsInt($value) Then
        If $value > 0x10000000 Then
            Return $RPC_PARAM_POINTER
        Else
            Return $RPC_PARAM_INT32
        EndIf
    ElseIf IsPtr($value) Then
        Return $RPC_PARAM_POINTER
    Else
        Return $RPC_PARAM_INT32
    EndIf
EndFunc

Func _SetParamValue($tParam, $paramType, $paramValue)
    Switch $paramType
        Case $RPC_PARAM_INT32
            Local $tValue = DllStructCreate("int", DllStructGetPtr($tParam, "value"))
            DllStructSetData($tValue, 1, $paramValue)

        Case $RPC_PARAM_FLOAT
            Local $tValue = DllStructCreate("float", DllStructGetPtr($tParam, "value"))
            DllStructSetData($tValue, 1, $paramValue)

        Case $RPC_PARAM_POINTER
            Local $tValue = DllStructCreate("ptr", DllStructGetPtr($tParam, "value"))
            DllStructSetData($tValue, 1, $paramValue)

        Case $RPC_PARAM_STRING
            Local $tValue = DllStructCreate("char[256]", DllStructGetPtr($tParam, "value"))
            DllStructSetData($tValue, 1, $paramValue)
    EndSwitch
EndFunc