#include-once

; ==================================
; GwAu3 - Guild Wars AutoIt RPC Client
; ==================================
; Version: 1.1
; Description: Complete RPC client for Guild Wars DLL with server control

; Core includes
#include "Core/GWRPCProtocol.au3"
#include "Core/GWRPCClient.au3"
#include "Core/GWRPCHelpers.au3"

; API includes
#include "API/GWRPCScanner.au3"
#include "API/GWRPCMemory.au3"
#include "API/GWRPCFunction.au3"

; Guild Wars includes
#include "GuildWars/GWConstants.au3"
#include "GuildWars/GWFunctions.au3"

Global Const $GWAU3_VERSION = "1.1.0"
Global Const $GWAU3_BUILD_DATE = @YEAR & "/" & @MON & "/" & @MDAY

; ==================================
; Main Functions
; ==================================

Func GwAu3_Initialize($sPipeName = $RPC_DEFAULT_PIPE, $bDebug = False)
    ; Connect to RPC server
    If Not RPCClient_Init($sPipeName, $bDebug) Then
        Return SetError(1, 0, False)
    EndIf

    ; Initialize Guild Wars functions
    GW_InitializeFunctions()

    Return True
EndFunc

Func GwAu3_Shutdown()
    ; Cleanup Guild Wars functions
    GW_CleanupFunctions()

    ; Close RPC connection
    RPCClient_Close()
EndFunc

Func GwAu3_IsConnected()
    Return RPCClient_IsConnected()
EndFunc

Func GwAu3_SetDebugMode($bDebug)
    RPCClient_SetDebugMode($bDebug)
EndFunc

; ==================================
; Server Control Functions (New)
; ==================================

Func GwAu3_StopServer()
    Return RPCServer_Stop()
EndFunc

Func GwAu3_StartServer($sPipeName = "")
    Return RPCServer_Start($sPipeName)
EndFunc

Func GwAu3_RestartServer($sPipeName = "", $iWaitMs = 2000)
    Return RPCServer_Restart($sPipeName, $iWaitMs)
EndFunc

Func GwAu3_GetServerStatus()
    Return RPCServer_GetStatus()
EndFunc

Func GwAu3_IsServerRunning()
    Return RPCServer_IsRunning()
EndFunc

; ==================================
; DLL Control Functions (New)
; ==================================

Func GwAu3_DetachDLL($bForce = False)
    Return RPCDLL_Detach($bForce)
EndFunc

Func GwAu3_GetDLLStatus()
    Return RPCDLL_GetStatus()
EndFunc

Func GwAu3_IsDLLRunning()
    Return RPCDLL_IsRunning()
EndFunc

; ==================================
; Safe Shutdown (New)
; ==================================

Func GwAu3_SafeShutdown()
    RPC_SafeShutdown()
EndFunc

; ==================================
; Version Information
; ==================================

Func GwAu3_GetVersion()
    Return $GWAU3_VERSION
EndFunc

Func GwAu3_GetBuildDate()
    Return $GWAU3_BUILD_DATE
EndFunc