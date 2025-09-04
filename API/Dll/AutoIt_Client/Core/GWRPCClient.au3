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

Func RPCClient_Init($sPipeName = $RPC_DEFAULT_PIPE, $bDebug = False)
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

; ==================================
; Server Control API Functions
; ==================================

; Get current server status
Func RPCServer_GetStatus()
    RPCClient_DebugOut("[SERVER] Getting server status...")

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type", DllStructGetPtr($tRequest))
    DllStructSetData($tReq, "type", $RPC_SERVER_STATUS)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        RPCClient_DebugOut("[SERVER] Failed to send status request")
        Return -1
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; int status; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $iStatus = DllStructGetData($tResp, "status")
        Switch $iStatus
            Case $RPC_SERVER_STATUS_STOPPED
                RPCClient_DebugOut("[SERVER] Status: STOPPED")
            Case $RPC_SERVER_STATUS_RUNNING
                RPCClient_DebugOut("[SERVER] Status: RUNNING")
            Case $RPC_SERVER_STATUS_ERROR
                RPCClient_DebugOut("[SERVER] Status: ERROR")
        EndSwitch
        Return $iStatus
    Else
        RPCClient_DebugOut("[SERVER] Failed to get status: " & DllStructGetData($tResp, "error"))
        Return -1
    EndIf
EndFunc

; Stop the Named Pipe server
Func RPCServer_Stop()
    RPCClient_DebugOut("[SERVER] Stopping server...")

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type", DllStructGetPtr($tRequest))
    DllStructSetData($tReq, "type", $RPC_SERVER_STOP)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        RPCClient_DebugOut("[SERVER] Failed to send stop request")
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[SERVER] Server stopped successfully")

        ; Close the current connection since server is stopping
        RPCClient_Close()

        Return True
    Else
        RPCClient_DebugOut("[SERVER] Failed to stop server: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

; Start the Named Pipe server
Func RPCServer_Start($sPipeName = "")
    RPCClient_DebugOut("[SERVER] Starting server...")

    ; If not connected, try to connect first
    If Not RPCClient_IsConnected() Then
        If Not RPCClient_Init($sPipeName = "" ? $RPC_DEFAULT_PIPE : $sPipeName) Then
            RPCClient_DebugOut("[SERVER] Failed to connect to pipe")
            Return False
        EndIf
    EndIf

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; char pipe_name[256]", DllStructGetPtr($tRequest))
    DllStructSetData($tReq, "type", $RPC_SERVER_START)
    If $sPipeName <> "" Then
        DllStructSetData($tReq, "pipe_name", $sPipeName)
    EndIf

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        RPCClient_DebugOut("[SERVER] Failed to send start request")
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[SERVER] Server started successfully")
        Return True
    Else
        RPCClient_DebugOut("[SERVER] Failed to start server: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

; Restart the Named Pipe server
Func RPCServer_Restart($sPipeName = "", $iWaitMs = 2000)
    RPCClient_DebugOut("[SERVER] Restarting server...")

    ; Get current status
    Local $iCurrentStatus = RPCServer_GetStatus()

    ; Stop the server if it's running
    If $iCurrentStatus = $RPC_SERVER_STATUS_RUNNING Then
        If Not RPCServer_Stop() Then
            RPCClient_DebugOut("[SERVER] Failed to stop server for restart")
            Return False
        EndIf

        ; Wait for server to stop
        Sleep($iWaitMs)
    EndIf

    ; Reconnect to the DLL (server might be stopped but DLL still running)
    If Not RPCClient_Reconnect() Then
        RPCClient_DebugOut("[SERVER] Failed to reconnect after stopping server")
        Return False
    EndIf

    ; Start the server
    If Not RPCServer_Start($sPipeName) Then
        RPCClient_DebugOut("[SERVER] Failed to start server after stop")
        Return False
    EndIf

    RPCClient_DebugOut("[SERVER] Server restarted successfully")
    Return True
EndFunc

; ==================================
; DLL Control Functions
; ==================================
; Get DLL status
Func RPCDLL_GetStatus()
    RPCClient_DebugOut("[DLL] Getting DLL status...")

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type", DllStructGetPtr($tRequest))
    DllStructSetData($tReq, "type", $RPC_DLL_STATUS)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        RPCClient_DebugOut("[DLL] Failed to send status request")
        Return -1
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; int status; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $iStatus = DllStructGetData($tResp, "status")
        Switch $iStatus
            Case $RPC_DLL_STATUS_INITIALIZING
                RPCClient_DebugOut("[DLL] Status: INITIALIZING")
            Case $RPC_DLL_STATUS_RUNNING
                RPCClient_DebugOut("[DLL] Status: RUNNING")
            Case $RPC_DLL_STATUS_SHUTTING_DOWN
                RPCClient_DebugOut("[DLL] Status: SHUTTING_DOWN")
            Case $RPC_DLL_STATUS_STOPPED
                RPCClient_DebugOut("[DLL] Status: STOPPED")
        EndSwitch
        Return $iStatus
    Else
        RPCClient_DebugOut("[DLL] Failed to get status: " & DllStructGetData($tResp, "error"))
        Return -1
    EndIf
EndFunc

; Detach/Unload the DLL from the game process
Func RPCDLL_Detach($bForce = False)
    RPCClient_DebugOut("[DLL] Requesting DLL detach...")

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; byte force; byte padding[3]", DllStructGetPtr($tRequest))
    DllStructSetData($tReq, "type", $RPC_DLL_DETACH)
    DllStructSetData($tReq, "force", $bForce ? 1 : 0)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then
        RPCClient_DebugOut("[DLL] Failed to send detach request")
        Return False
    EndIf

    Local $tResp = DllStructCreate("byte success; byte padding[3]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        RPCClient_DebugOut("[DLL] DLL detach initiated successfully")

        ; Wait a bit for the DLL to start shutting down
        Sleep(500)

        ; Close the connection as the DLL is detaching
        RPCClient_Close()

        Return True
    Else
        RPCClient_DebugOut("[DLL] Failed to detach DLL: " & DllStructGetData($tResp, "error"))
        Return False
    EndIf
EndFunc

; Check if server is running
Func RPCServer_IsRunning()
    Local $iStatus = RPCServer_GetStatus()
    Return $iStatus = $RPC_SERVER_STATUS_RUNNING
EndFunc

; Check if DLL is running
Func RPCDLL_IsRunning()
    Local $iStatus = RPCDLL_GetStatus()
    Return $iStatus = $RPC_DLL_STATUS_RUNNING
EndFunc

; Safe shutdown - stop server then detach DLL
Func RPC_SafeShutdown()
    RPCClient_DebugOut("[SHUTDOWN] Performing safe shutdown...")

    ; Stop the server first
    If RPCServer_IsRunning() Then
        RPCClient_DebugOut("[SHUTDOWN] Stopping server...")
        RPCServer_Stop()
        Sleep(1000)
    EndIf

    ; Reconnect if needed
    If Not RPCClient_IsConnected() Then
        RPCClient_Reconnect()
    EndIf

    ; Detach the DLL
    If RPCDLL_IsRunning() Then
        RPCClient_DebugOut("[SHUTDOWN] Detaching DLL...")
        RPCDLL_Detach()
    EndIf

    RPCClient_DebugOut("[SHUTDOWN] Safe shutdown complete")
EndFunc