#include-once
#include "GWRPCClient.au3"

; ==================================
; Helper Functions
; ==================================

Func RPCHelpers_ProcessPattern($sPattern, $tReq, $sFieldName = "pattern")
    Local $tPatternDest = DllStructCreate("byte[256]", DllStructGetPtr($tReq, $sFieldName))
    Local $iLen = 0

    ; Check if hex pattern with spaces
    If StringRegExp($sPattern, "^[0-9A-Fa-f\s\?]+$") And StringInStr($sPattern, " ") Then
        Local $aBytes = StringSplit($sPattern, " ", 2)

        For $i = 0 To UBound($aBytes) - 1
            If StringLen($aBytes[$i]) > 0 Then
                If $aBytes[$i] = "??" Then
                    DllStructSetData($tPatternDest, 1, 0x00, $iLen + 1)
                Else
                    DllStructSetData($tPatternDest, 1, Dec($aBytes[$i]), $iLen + 1)
                EndIf
                $iLen += 1
            EndIf
        Next

        RPCClient_DebugOut("[PATTERN] Hex pattern: " & $iLen & " bytes")
        Return $iLen

    ; Check for escape sequences
    ElseIf StringInStr($sPattern, "\x") Then
        Local $i = 1
        While $i <= StringLen($sPattern)
            If StringMid($sPattern, $i, 2) = "\x" And $i + 3 <= StringLen($sPattern) Then
                Local $sHex = StringMid($sPattern, $i + 2, 2)
                If StringRegExp($sHex, "^[0-9A-Fa-f]{2}$") Then
                    DllStructSetData($tPatternDest, 1, Dec($sHex), $iLen + 1)
                    $iLen += 1
                    $i += 4
                Else
                    DllStructSetData($tPatternDest, 1, Asc(StringMid($sPattern, $i, 1)), $iLen + 1)
                    $iLen += 1
                    $i += 1
                EndIf
            Else
                DllStructSetData($tPatternDest, 1, Asc(StringMid($sPattern, $i, 1)), $iLen + 1)
                $iLen += 1
                $i += 1
            EndIf
        WEnd

        RPCClient_DebugOut("[PATTERN] Escape pattern: " & $iLen & " bytes")
        Return $iLen
    Else
        ; Raw string
        For $i = 1 To StringLen($sPattern)
            DllStructSetData($tPatternDest, 1, Asc(StringMid($sPattern, $i, 1)), $i)
        Next
        $iLen = StringLen($sPattern)

        RPCClient_DebugOut("[PATTERN] String pattern: " & $iLen & " bytes")
        Return $iLen
    EndIf
EndFunc

Func RPCHelpers_HexDump($bData, $iMaxLen = 32)
    Local $sResult = ""
    Local $iLen = BinaryLen($bData)
    If $iLen > $iMaxLen Then $iLen = $iMaxLen

    For $i = 1 To $iLen
        $sResult &= Hex(BinaryMid($bData, $i, 1), 2) & " "
    Next

    If BinaryLen($bData) > $iMaxLen Then
        $sResult &= "... (" & BinaryLen($bData) & " bytes total)"
    EndIf

    Return $sResult
EndFunc

Func RPCHelpers_ValidateAddress($pAddress)
    If Not $pAddress Or $pAddress = 0 Then
        RPCClient_DebugOut("[VALIDATE] Invalid address: 0x" & Hex($pAddress))
        Return False
    EndIf
    Return True
EndFunc

Func RPCHelpers_GetErrorMessage($tResponse)
    Local $tError = DllStructCreate("byte success; byte padding[3]; byte data[1280]; char error[256]", _
                                     DllStructGetPtr($tResponse))
    Return DllStructGetData($tError, "error")
EndFunc