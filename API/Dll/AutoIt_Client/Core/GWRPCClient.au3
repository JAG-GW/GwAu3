#include-once
#include <WinAPI.au3>
#include "GWRPCProtocol.au3"

; ==================================
; Core RPC Client Communication
; ==================================

; Global connection state
Global $g_hRPCPipe = 0
Global $g_bRPCConnected = False
Global $g_bRPCDebugMode = False
Global $g_sRPCPipeName = ""

; ==================================
; Connection Management
; ==================================

Func RPCClient_Init($bDebug = False)
	Local $sPipeName = $RPC_DEFAULT_PIPE & $g_i_GWProcessId
    $g_bRPCDebugMode = $bDebug
    $g_sRPCPipeName = $sPipeName

    RPCClient_DebugOut("[RPC] Connecting to: " & $sPipeName)

    ; Try to connect with retries
    For $i = 1 To $RPC_MAX_RETRIES
        $g_hRPCPipe = _WinAPI_CreateFile($sPipeName, 3, 6, 0, 0, 0)

        If $g_hRPCPipe And $g_hRPCPipe <> Ptr(-1) Then
            $g_bRPCConnected = True
            RPCClient_DebugOut("[RPC] Connected on attempt " & $i)
            Return True
        EndIf

        RPCClient_DebugOut("[RPC] Waiting... (attempt " & $i & "/" & $RPC_MAX_RETRIES & ")")
        Sleep(1000)
    Next

    RPCClient_DebugOut("[RPC] Connection failed")
    Return False
EndFunc

Func RPCClient_Close()
    If $g_hRPCPipe And $g_hRPCPipe <> Ptr(-1) Then
        _WinAPI_CloseHandle($g_hRPCPipe)
        $g_hRPCPipe = 0
        $g_bRPCConnected = False
        RPCClient_DebugOut("[RPC] Connection closed")
    EndIf
EndFunc

Func RPCClient_IsConnected()
    Return $g_bRPCConnected And $g_hRPCPipe And $g_hRPCPipe <> Ptr(-1)
EndFunc

Func RPCClient_Reconnect()
    RPCClient_Close()
    Sleep(500)
    Return RPCClient_Init($g_sRPCPipeName, $g_bRPCDebugMode)
EndFunc

; ==================================
; Request/Response Management
; ==================================

Func RPCClient_CreateRequest()
    Local $tRequest = DllStructCreate("byte[" & $RPC_REQUEST_SIZE & "]")
    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tRequest), "dword", $RPC_REQUEST_SIZE)
    Return $tRequest
EndFunc

Func RPCClient_CreateResponse()
    Local $tResponse = DllStructCreate("byte[" & $RPC_RESPONSE_SIZE & "]")
    DllCall("kernel32.dll", "none", "RtlZeroMemory", "ptr", DllStructGetPtr($tResponse), "dword", $RPC_RESPONSE_SIZE)
    Return $tResponse
EndFunc

Func RPCClient_SendRequest($pRequest, $pResponse)
    If Not RPCClient_IsConnected() Then
        RPCClient_DebugOut("[RPC] Not connected")
        Return False
    EndIf

    Local $iBytesWritten = 0, $iBytesRead = 0

    ; Send request
    Local $bResult = _WinAPI_WriteFile($g_hRPCPipe, $pRequest, $RPC_REQUEST_SIZE, $iBytesWritten)
    If Not $bResult Or $iBytesWritten <> $RPC_REQUEST_SIZE Then
        RPCClient_DebugOut("[RPC] Write failed: " & _WinAPI_GetLastError())
        Return False
    EndIf

    ; Read response
    $bResult = _WinAPI_ReadFile($g_hRPCPipe, $pResponse, $RPC_RESPONSE_SIZE, $iBytesRead)
    If Not $bResult Or $iBytesRead <> $RPC_RESPONSE_SIZE Then
        RPCClient_DebugOut("[RPC] Read failed: " & _WinAPI_GetLastError())
        Return False
    EndIf

    Return True
EndFunc

; ==================================
; Debug Output
; ==================================

Func RPCClient_DebugOut($sText)
    If $g_bRPCDebugMode Then
        ConsoleWrite($sText & @CRLF)
    EndIf
EndFunc

Func RPCClient_SetDebugMode($bDebug)
    $g_bRPCDebugMode = $bDebug
EndFunc