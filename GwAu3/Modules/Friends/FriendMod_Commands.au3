#include-once
#include "FriendMod_Initialize.au3"
#include "FriendMod_Data.au3"

#Region Status Functions
Func SetPlayerStatus($iStatus)
    If Not $g_bFriendModuleInitialized Then
        _Log_Error("FriendMod module not initialized", "FriendMod", $GUIEdit)
        Return False
    EndIf

    If $iStatus < $FRIEND_STATUS_OFFLINE Or $iStatus > $FRIEND_STATUS_AWAY Then
        _Log_Error("Invalid status: " & $iStatus, "FriendMod", $GUIEdit)
        Return False
    EndIf

    ; Check if status is already set
    Local $lCurrentStatus = GetMyStatus()
    If $lCurrentStatus = $iStatus Then
        _Log_Debug("Status already set to: " & GetFriendStatusName($iStatus), "FriendMod", $GUIEdit)
        Return True
    EndIf

    DllStructSetData($g_mChangeStatus, 1, GetValue('CommandSetOnlineStatus'))
    DllStructSetData($g_mChangeStatus, 2, $iStatus)

    Enqueue($g_mChangeStatusPtr, 8)

    $g_iLastStatus = $iStatus

    _Log_Info("Changed player status to: " & GetFriendStatusName($iStatus), "FriendMod", $GUIEdit)
    Return True
EndFunc

Func SetOnlineStatus()
    Return SetPlayerStatus($FRIEND_STATUS_ONLINE)
EndFunc

Func SetOfflineStatus()
    Return SetPlayerStatus($FRIEND_STATUS_OFFLINE)
EndFunc

Func SetDNDStatus()
    Return SetPlayerStatus($FRIEND_STATUS_DND)
EndFunc

Func SetAwayStatus()
    Return SetPlayerStatus($FRIEND_STATUS_AWAY)
EndFunc
#EndRegion Status Functions

#Region Friend Management Functions
Func AddFriend($sCharacterName, $sAlias = "", $iFriendType = $FRIEND_TYPE_FRIEND)
    If Not $g_bFriendModuleInitialized Then
        _Log_Error("FriendMod module not initialized", "FriendMod", $GUIEdit)
        Return False
    EndIf

    If StringLen($sCharacterName) = 0 Or StringLen($sCharacterName) > $FRIEND_CHARNAME_MAX_LENGTH Then
        _Log_Error("Invalid character name length", "FriendMod", $GUIEdit)
        Return False
    EndIf

    If $iFriendType < $FRIEND_TYPE_FRIEND Or $iFriendType > $FRIEND_TYPE_TRADE Then
        _Log_Error("Invalid friend type: " & $iFriendType, "FriendMod", $GUIEdit)
        Return False
    EndIf

    ; If no alias specified, use the character name as alias (comme dans GWCA)
    If $sAlias = "" Then $sAlias = $sCharacterName

    ; Check if friend already exists
    Local $lExistingFriend = _FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lExistingFriend <> 0 Then
        _Log_Warning("Friend already exists: " & $sCharacterName, "FriendMod", $GUIEdit)
        Return False
    EndIf

;~     ; Create temporary structures for the strings
;~     ; Assurer que les strings sont null-terminated
;~     Local $lNameStruct = DllStructCreate("wchar[" & ($FRIEND_CHARNAME_MAX_LENGTH + 1) & "]")
;~     Local $lAliasStruct = DllStructCreate("wchar[" & ($FRIEND_ALIAS_MAX_LENGTH + 1) & "]")

;~     ; Clear the structures first
;~     DllStructSetData($lNameStruct, 1, "")
;~     DllStructSetData($lAliasStruct, 1, "")

;~     ; Set the data
;~     DllStructSetData($lNameStruct, 1, $sCharacterName)
;~     DllStructSetData($lAliasStruct, 1, $sAlias)

    DllStructSetData($g_mAddFriend, 1, GetValue('CommandAddFriend'))
    DllStructSetData($g_mAddFriend, 2, $sCharacterName)
    DllStructSetData($g_mAddFriend, 3, $sAlias)
    DllStructSetData($g_mAddFriend, 4, $iFriendType)

    Enqueue($g_mAddFriendPtr, 16)

    _Log_Info("Added friend: " & $sCharacterName & " (Alias: " & $sAlias & ", Type: " & GetFriendTypeName($iFriendType) & ")", "FriendMod", $GUIEdit)
    Return True
EndFunc

Func RemoveFriend($vFriend)
    If Not $g_bFriendModuleInitialized Then
        _Log_Error("FriendMod module not initialized", "FriendMod", $GUIEdit)
        Return False
    EndIf

    Local $lFriendPtr = 0
    Local $lUUID = 0
    Local $lName = ""

    ; Handle different input types
    If IsString($vFriend) Then
        ; Friend name - get friend info
        $lFriendPtr = _FriendMod_GetFriendInfo($vFriend, "Ptr")
        If $lFriendPtr = 0 Then
            _Log_Warning("Friend not found: " & $vFriend, "FriendMod", $GUIEdit)
            Return False
        EndIf
        $lUUID = _FriendMod_GetFriendInfo($vFriend, "UUID")
        $lName = _FriendMod_GetFriendInfo($vFriend, "Alias")
    ElseIf IsNumber($vFriend) Then
        ; Friend number
        $lFriendPtr = _FriendMod_GetFriendInfo($vFriend, "Ptr")
        If $lFriendPtr = 0 Then
            _Log_Warning("Friend not found at index: " & $vFriend, "FriendMod", $GUIEdit)
            Return False
        EndIf
        $lUUID = _FriendMod_GetFriendInfo($vFriend, "UUID")
        $lName = _FriendMod_GetFriendInfo($vFriend, "Alias")
    ElseIf IsPtr($vFriend) Then
        ; Friend pointer
        $lFriendPtr = $vFriend
        $lUUID = MemoryRead($lFriendPtr + 0x8, 'byte[16]')
        $lName = MemoryRead($lFriendPtr + 0x18, 'wchar[20]')
    Else
        _Log_Error("Invalid friend parameter type", "FriendMod", $GUIEdit)
        Return False
    EndIf

    ; Convert UUID binary to byte array in struct
    Local $lUUIDStruct = DllStructCreate("byte[16]")
    If IsBinary($lUUID) Then
        For $i = 0 To 15
            DllStructSetData($lUUIDStruct, 1, Number(BinaryMid($lUUID, $i + 1, 1)), $i + 1)
        Next
    Else
        ; If UUID is already a struct or array, copy it
        For $i = 0 To 15
            DllStructSetData($lUUIDStruct, 1, MemoryRead($lFriendPtr + 0x8 + $i, 'byte'), $i + 1)
        Next
    EndIf

    ; Create name struct
    Local $lNameStruct = DllStructCreate("wchar[" & ($FRIEND_ALIAS_MAX_LENGTH + 1) & "]")
    DllStructSetData($lNameStruct, 1, $lName)

    DllStructSetData($g_mRemoveFriend, 1, GetValue('CommandRemoveFriend'))
    ; Copy UUID bytes
    For $i = 0 To 15
        DllStructSetData($g_mRemoveFriend, 2, DllStructGetData($lUUIDStruct, 1, $i + 1), $i + 1)
    Next
    DllStructSetData($g_mRemoveFriend, 3, DllStructGetPtr($lNameStruct))
    DllStructSetData($g_mRemoveFriend, 4, 0)  ; arg8 is usually 0

    Enqueue($g_mRemoveFriendPtr, 28)

    _Log_Info("Removed friend: " & $lName, "FriendMod", $GUIEdit)
    Return True
EndFunc

Func AddIgnore($sCharacterName, $sAlias = "")
    Return AddFriend($sCharacterName, $sAlias, $FRIEND_TYPE_IGNORE)
EndFunc

Func RemoveIgnore($sCharacterName)
    ; Check if the person is in ignore list
    Local $lFriendPtr = _FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lFriendPtr = 0 Then Return False

    Local $lType = _FriendMod_GetFriendInfo($sCharacterName, "Type")
    If $lType <> $FRIEND_TYPE_IGNORE Then
        _Log_Warning("Person is not in ignore list: " & $sCharacterName, "FriendMod", $GUIEdit)
        Return False
    EndIf

    Return RemoveFriend($sCharacterName)
EndFunc
#EndRegion Friend Management Functions
