#include-once
#include "../Core/GWRPCClient.au3"
#include "../Core/GWRPCHelpers.au3"
#include "../Core/GWRPCProtocol.au3"

; ==================================
; Memory Management API
; ==================================

Func RPCMemory_Allocate($iSize, $iProtection = $RPC_PAGE_EXECUTE_READWRITE)
    RPCClient_DebugOut("[MEMORY] Allocate " & $iSize & " bytes, protection: 0x" & Hex($iProtection))

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $RPC_REQUEST_SIZE)

    Local $tMemStruct = DllStructCreate("int type; ptr address; uint size; uint protection", _
                                         DllStructGetPtr($tRequest))

    DllStructSetData($tMemStruct, "type", $RPC_ALLOCATE_MEMORY)
    DllStructSetData($tMemStruct, "address", 0)
    DllStructSetData($tMemStruct, "size", $iSize)
    DllStructSetData($tMemStruct, "protection", $iProtection)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return 0
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; uint size; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pAddress = DllStructGetData($tResp, "address")
        RPCClient_DebugOut("[MEMORY] Allocated at: 0x" & Hex($pAddress))
        Return $pAddress
    Else
        RPCClient_DebugOut("[MEMORY] Allocation failed: " & DllStructGetData($tResp, "error"))
        Return 0
    EndIf
EndFunc

Func RPCMemory_Free($pAddress)
    If Not RPCHelpers_ValidateAddress($pAddress) Then Return False

    RPCClient_DebugOut("[MEMORY] Free: 0x" & Hex($pAddress))

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $RPC_REQUEST_SIZE)

    Local $tMem = DllStructCreate("int type; ptr address", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tMem, "type", $RPC_FREE_MEMORY)
    DllStructSetData($tMem, "address", $pAddress)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[MEMORY] Freed successfully")
        Return True
    Else
        RPCClient_DebugOut("[MEMORY] Free failed: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

Func RPCMemory_Write($pAddress, $vData, $iSize)
    If Not RPCHelpers_ValidateAddress($pAddress) Then Return False

    If $iSize > 1024 Then
        RPCClient_DebugOut("[MEMORY] Write size too large: " & $iSize)
        Return False
    EndIf

    RPCClient_DebugOut("[MEMORY] Write to 0x" & Hex($pAddress) & ", size: " & $iSize)

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $RPC_REQUEST_SIZE)

    Local $tMem = DllStructCreate("int type; ptr address; uint size; uint protection; byte data[1024]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tMem, "type", $RPC_WRITE_MEMORY)
    DllStructSetData($tMem, "address", $pAddress)
    DllStructSetData($tMem, "size", $iSize)
    DllStructSetData($tMem, "protection", 0)

    ; Copy data
    If IsBinary($vData) Then
        Local $tData = DllStructCreate("byte[" & $iSize & "]", DllStructGetPtr($tMem, "data"))
        DllStructSetData($tData, 1, $vData)
    ElseIf IsDllStruct($vData) Then
        DllCall("kernel32.dll", "none", "RtlMoveMemory", _
                "ptr", DllStructGetPtr($tMem, "data"), _
                "ptr", DllStructGetPtr($vData), _
                "dword", $iSize)
    Else
        RPCClient_DebugOut("[MEMORY] Unsupported data type")
        Return False
    EndIf

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[MEMORY] Written successfully")
        Return True
    Else
        RPCClient_DebugOut("[MEMORY] Write failed: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

Func RPCMemory_Read($pAddress, $iSize)
    If Not RPCHelpers_ValidateAddress($pAddress) Then Return 0

    If $iSize > 1024 Then
        RPCClient_DebugOut("[MEMORY] Read size too large: " & $iSize)
        Return 0
    EndIf

    RPCClient_DebugOut("[MEMORY] Read from 0x" & Hex($pAddress) & ", size: " & $iSize)

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; byte padding[768]; ptr address; uint size", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_READ_MEMORY)
    DllStructSetData($tReq, "address", $pAddress)
    DllStructSetData($tReq, "size", $iSize)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return 0
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; uint size; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $readSize = DllStructGetData($tResp, "size")
        Local $tData = DllStructCreate("byte[" & $readSize & "]", DllStructGetPtr($tResp, "data"))
        RPCClient_DebugOut("[MEMORY] Read " & $readSize & " bytes")
        Return DllStructGetData($tData, 1)
    Else
        RPCClient_DebugOut("[MEMORY] Read failed: " & DllStructGetData($tResp, "error"))
        Return 0
    EndIf
EndFunc

Func RPCMemory_Protect($pAddress, $iSize, $iProtection)
    If Not RPCHelpers_ValidateAddress($pAddress) Then Return False

    RPCClient_DebugOut("[MEMORY] Protect 0x" & Hex($pAddress) & ", size: " & $iSize & ", protection: 0x" & Hex($iProtection))

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $RPC_REQUEST_SIZE)

    Local $tMem = DllStructCreate("int type; ptr address; uint size; uint protection", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tMem, "type", $RPC_PROTECT_MEMORY)
    DllStructSetData($tMem, "address", $pAddress)
    DllStructSetData($tMem, "size", $iSize)
    DllStructSetData($tMem, "protection", $iProtection)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[MEMORY] Protected successfully")
        Return True
    Else
        RPCClient_DebugOut("[MEMORY] Protection failed: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc