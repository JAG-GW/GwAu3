#include-once
#include "../Core/GWRPCClient.au3"
#include "../Core/GWRPCHelpers.au3"
#include "../Core/GWRPCProtocol.au3"

; ==================================
; Scanner API Functions
; ==================================

Func RPCScanner_Find($vPattern, $sMask = "", $iOffset = 0, $iSection = $RPC_SECTION_TEXT)
    RPCClient_DebugOut("[SCANNER] Find: " & $vPattern)

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; byte pattern[256]; char mask[256]; int offset; byte section; byte pattern_length; byte padding[2]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_SCAN_FIND)

    Local $iPatternLength = RPCHelpers_ProcessPattern($vPattern, $tReq, "pattern")
    DllStructSetData($tReq, "pattern_length", $iPatternLength)
    DllStructSetData($tReq, "mask", $sMask)
    DllStructSetData($tReq, "offset", $iOffset)
    DllStructSetData($tReq, "section", $iSection)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pAddress = DllStructGetData($tResp, "address")
        RPCClient_DebugOut("[SCANNER] Found at: 0x" & Hex($pAddress))
        Return $pAddress
    EndIf

    RPCClient_DebugOut("[SCANNER] Not found: " & DllStructGetData($tResp, "error"))
    Return 0
EndFunc

Func RPCScanner_FindAssertion($sFile, $sMsg, $iLine = 0, $iOffset = 0)
    RPCClient_DebugOut("[SCANNER] FindAssertion: " & $sFile & " / " & $sMsg)

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; char file[256]; char msg[256]; uint line; int offset", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_SCAN_FIND_ASSERTION)
    DllStructSetData($tReq, "file", $sFile)
    DllStructSetData($tReq, "msg", $sMsg)
    DllStructSetData($tReq, "line", $iLine)
    DllStructSetData($tReq, "offset", $iOffset)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pAddress = DllStructGetData($tResp, "address")
        RPCClient_DebugOut("[SCANNER] Found at: 0x" & Hex($pAddress))
        Return $pAddress
    EndIf

    RPCClient_DebugOut("[SCANNER] Not found")
    Return 0
EndFunc

Func RPCScanner_FindInRange($vPattern, $sMask, $iOffset, $iStartAddress, $iEndAddress)
    RPCClient_DebugOut("[SCANNER] FindInRange: 0x" & Hex($iStartAddress) & " - 0x" & Hex($iEndAddress))

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; uint start_address; uint end_address; byte pattern[256]; char mask[256]; int offset; byte pattern_length; byte padding[3]", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_SCAN_FIND_IN_RANGE)
    DllStructSetData($tReq, "start_address", $iStartAddress)
    DllStructSetData($tReq, "end_address", $iEndAddress)

    Local $iPatternLength = RPCHelpers_ProcessPattern($vPattern, $tReq, "pattern")
    DllStructSetData($tReq, "pattern_length", $iPatternLength)
    DllStructSetData($tReq, "mask", $sMask)
    DllStructSetData($tReq, "offset", $iOffset)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Return DllStructGetData($tResp, "address")
    EndIf

    Return 0
EndFunc

Func RPCScanner_ToFunctionStart($pAddress, $iScanRange = 0xFF)
    If Not RPCHelpers_ValidateAddress($pAddress) Then Return 0

    RPCClient_DebugOut("[SCANNER] ToFunctionStart from: 0x" & Hex($pAddress))

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; ptr address; uint size", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_SCAN_TO_FUNCTION_START)
    DllStructSetData($tReq, "address", $pAddress)
    DllStructSetData($tReq, "size", $iScanRange)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pResult = DllStructGetData($tResp, "address")
        RPCClient_DebugOut("[SCANNER] Function start at: 0x" & Hex($pResult))
        Return $pResult
    EndIf

    Return 0
EndFunc

Func RPCScanner_FunctionFromNearCall($pCallAddress)
    If Not RPCHelpers_ValidateAddress($pCallAddress) Then Return 0

    RPCClient_DebugOut("[SCANNER] FunctionFromNearCall at: 0x" & Hex($pCallAddress))

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; ptr address", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_SCAN_FUNCTION_FROM_NEAR_CALL)
    DllStructSetData($tReq, "address", $pCallAddress)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr address; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $pResult = DllStructGetData($tResp, "address")
        RPCClient_DebugOut("[SCANNER] Function at: 0x" & Hex($pResult))
        Return $pResult
    EndIf

    Return 0
EndFunc

Func RPCScanner_GetSectionInfo($iSection)
    RPCClient_DebugOut("[SCANNER] GetSectionInfo: " & $iSection)

    Local $tRequest = RPCClient_CreateRequest()
    Local $tResponse = RPCClient_CreateResponse()

    Local $tReq = DllStructCreate("int type; byte padding[516]; byte section", _
                                   DllStructGetPtr($tRequest))

    DllStructSetData($tReq, "type", $RPC_GET_SECTION_INFO)
    DllStructSetData($tReq, "section", $iSection)

    If Not RPCClient_SendRequest(DllStructGetPtr($tRequest), DllStructGetPtr($tResponse)) Then Return 0

    Local $tResp = DllStructCreate("byte success; byte padding[3]; ptr start; ptr end; byte data[1024]; char error[256]", _
                                    DllStructGetPtr($tResponse))

    If DllStructGetData($tResp, "success") Then
        Local $aInfo[2]
        $aInfo[0] = DllStructGetData($tResp, "start")
        $aInfo[1] = DllStructGetData($tResp, "end")
        RPCClient_DebugOut("[SCANNER] Section " & $iSection & ": 0x" & Hex($aInfo[0]) & " - 0x" & Hex($aInfo[1]))
        Return $aInfo
    EndIf

    Return 0
EndFunc