#include-once

; ==================================
; GwAu3 - Guild Wars AutoIt RPC Client
; ==================================
; Version: 1.0
; Author: Your Name
; Description: Complete RPC client for Guild Wars DLL

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
; Version Information
; ==================================

Global Const $GWAU3_VERSION = "1.0.0"
Global Const $GWAU3_BUILD_DATE = @YEAR & "/" & @MON & "/" & @MDAY

Func GwAu3_GetVersion()
    Return $GWAU3_VERSION
EndFunc

Func GwAu3_GetBuildDate()
    Return $GWAU3_BUILD_DATE
EndFunc