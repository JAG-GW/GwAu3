#include-once
#include "FriendMod_Data.au3"

#Region Status Functions
Func SetPlayerStatus($iStatus)
    If Not $g_bFriendModuleInitialized Then
        _Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    If $iStatus < $FRIEND_STATUS_OFFLINE Or $iStatus > $FRIEND_STATUS_AWAY Then
        _Log_Error("Invalid status: " & $iStatus, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if status is already set
    Local $lCurrentStatus = GetMyStatus()
    If $lCurrentStatus = $iStatus Then
        _Log_Debug("Status already set to: " & GetFriendStatusName($iStatus), "FriendMod", $g_h_EditText)
        Return True
    EndIf

    DllStructSetData($g_mChangeStatus, 1, GetValue('CommandSetOnlineStatus'))
    DllStructSetData($g_mChangeStatus, 2, $iStatus)

    Enqueue($g_mChangeStatusPtr, 8)

    $g_iLastStatus = $iStatus

    _Log_Info("Changed player status to: " & GetFriendStatusName($iStatus), "FriendMod", $g_h_EditText)
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
        _Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    If StringLen($sCharacterName) = 0 Or StringLen($sCharacterName) > $FRIEND_CHARNAME_MAX_LENGTH Then
        _Log_Error("Invalid character name length", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    If $iFriendType < 1 Or $iFriendType > 2 Then
        _Log_Error("Invalid friend type: " & $iFriendType, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $lExistingFriend = _FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lExistingFriend <> 0 Then
        _Log_Warning("Friend already exists: " & $sCharacterName, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $iNameSize = (StringLen($sCharacterName) + 1) * 2
    Local $iAliasSize = (StringLen($sAlias = "" ? $sCharacterName : $sAlias) + 1) * 2

    Local $pNameMem = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $iNameSize, 'dword', 0x1000, 'dword', 0x40)
    $pNameMem = $pNameMem[0]

    Local $pAliasMem = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $iAliasSize, 'dword', 0x1000, 'dword', 0x40)
    $pAliasMem = $pAliasMem[0]

    If $pNameMem = 0 Or $pAliasMem = 0 Then
        _Log_Error("Failed to allocate memory in GW process", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $lNameStruct = DllStructCreate("wchar[" & (StringLen($sCharacterName) + 1) & "]")
    Local $lAliasStruct = DllStructCreate("wchar[" & (StringLen($sAlias = "" ? $sCharacterName : $sAlias) + 1) & "]")

    DllStructSetData($lNameStruct, 1, $sCharacterName)
    DllStructSetData($lAliasStruct, 1, $sAlias = "" ? $sCharacterName : $sAlias)

    DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $pNameMem, 'ptr', DllStructGetPtr($lNameStruct), 'int', $iNameSize, 'int', 0)
    DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $pAliasMem, 'ptr', DllStructGetPtr($lAliasStruct), 'int', $iAliasSize, 'int', 0)

    Local $lVerifyStruct = DllStructCreate("wchar[20]")
    DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'ptr', $pNameMem, 'ptr', DllStructGetPtr($lVerifyStruct), 'int', 40, 'int', 0)

    DllStructSetData($g_mAddFriend, 1, GetValue('CommandAddFriend'))
    DllStructSetData($g_mAddFriend, 2, $pNameMem)
    DllStructSetData($g_mAddFriend, 3, $pAliasMem)
    DllStructSetData($g_mAddFriend, 4, $iFriendType)

    Enqueue($g_mAddFriendPtr, 16)
	Sleep(500)
	DllCall($mKernelHandle, 'int', 'VirtualFreeEx', 'int', $mGWProcHandle, 'ptr', $pAliasMem, 'int', 0, 'dword', 0x8000)
EndFunc

Func RemoveFriend($sNameOrAlias)
    If Not $g_bFriendModuleInitialized Then
        _Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Get array info
    Local $lArrayDataPtr = MemoryRead($g_mFriendListPtr + 0x00, "ptr")
    Local $lArraySize = MemoryRead($g_mFriendListPtr + 0x08, "dword")

    If $lArrayDataPtr = 0 Or $lArraySize = 0 Then
        _Log_Error("Friend array is empty or invalid", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Find friend by name or alias
    Local $lFriendPtr = 0
    Local $lAlias = ""

    For $i = 0 To $lArraySize - 1
        Local $lTempPtr = MemoryRead($lArrayDataPtr + (0x4 * $i), "ptr")
        If $lTempPtr = 0 Then ContinueLoop

        ; Check character name
        Local $lTempName = MemoryRead($lTempPtr + 0x2C, 'wchar[20]')
        Local $lTempAlias = MemoryRead($lTempPtr + 0x18, 'wchar[20]')

        If $lTempName = $sNameOrAlias Or $lTempAlias = $sNameOrAlias Then
            $lFriendPtr = $lTempPtr
            $lAlias = $lTempAlias
            ExitLoop
        EndIf
    Next

    If $lFriendPtr = 0 Then
        _Log_Warning("Friend not found: " & $sNameOrAlias, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Read UUID
    Local $lUUIDBytes = DllStructCreate("byte[16]")
    DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'ptr', $lFriendPtr + 0x8, 'ptr', DllStructGetPtr($lUUIDBytes), 'int', 16, 'int', '')

    ; Copy UUID to our structure
    For $i = 1 To 16
        DllStructSetData($g_mRemoveFriend, 2, DllStructGetData($lUUIDBytes, 1, $i), $i)
    Next

    ; Allocate memory for alias in GW process
    Local $iAliasSize = (StringLen($lAlias) + 1) * 2
    Local $pAliasMem = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $iAliasSize, 'dword', 0x1000, 'dword', 0x40)
    $pAliasMem = $pAliasMem[0]

    If $pAliasMem = 0 Then
        _Log_Error("Failed to allocate memory in GW process", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Write alias to GW memory
    Local $lAliasStruct = DllStructCreate("wchar[" & (StringLen($lAlias) + 1) & "]")
    DllStructSetData($lAliasStruct, 1, $lAlias)
    DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $pAliasMem, 'ptr', DllStructGetPtr($lAliasStruct), 'int', $iAliasSize, 'int', 0)

    ; Set up the command
    DllStructSetData($g_mRemoveFriend, 1, GetValue('CommandRemoveFriend'))
    DllStructSetData($g_mRemoveFriend, 3, $pAliasMem)
    DllStructSetData($g_mRemoveFriend, 4, 0)

    Enqueue($g_mRemoveFriendPtr, 24)

    Sleep(500)
    DllCall($mKernelHandle, 'int', 'VirtualFreeEx', 'int', $mGWProcHandle, 'ptr', $pAliasMem, 'int', 0, 'dword', 0x8000)
EndFunc

Func AddIgnore($sCharacterName, $sAlias = "")
    Return AddFriend($sCharacterName, $sAlias, $FRIEND_TYPE_IGNORE)
EndFunc

Func RemoveIgnore($sCharacterName)
    If Not $g_bFriendModuleInitialized Then
        _Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Get array info
    Local $lArrayDataPtr = MemoryRead($g_mFriendListPtr + 0x00, "ptr")
    Local $lArraySize = MemoryRead($g_mFriendListPtr + 0x08, "dword")

    If $lArrayDataPtr = 0 Or $lArraySize = 0 Then
        _Log_Error("Friend array is empty or invalid", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Find the person in the list
    Local $lFriendPtr = 0
    Local $lType = 0

    For $i = 0 To $lArraySize - 1
        Local $lTempPtr = MemoryRead($lArrayDataPtr + (0x4 * $i), "ptr")
        If $lTempPtr = 0 Then ContinueLoop

        ; Check by character name
        Local $lTempName = MemoryRead($lTempPtr + 0x2C, 'wchar[20]')
        If $lTempName = $sCharacterName Then
            $lFriendPtr = $lTempPtr
            $lType = MemoryRead($lTempPtr + 0x00, "dword")
            ExitLoop
        EndIf

        ; Check by alias
        Local $lTempAlias = MemoryRead($lTempPtr + 0x18, 'wchar[20]')
        If $lTempAlias = $sCharacterName Then
            $lFriendPtr = $lTempPtr
            $lType = MemoryRead($lTempPtr + 0x00, "dword")
            ExitLoop
        EndIf
    Next

    If $lFriendPtr = 0 Then
        _Log_Warning("Person not found in list: " & $sCharacterName, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if the person is in ignore list
    If $lType <> $FRIEND_TYPE_IGNORE Then
        _Log_Warning("Person is not in ignore list: " & $sCharacterName & " (Type: " & $lType & ")", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Remove from ignore list
    Return RemoveFriend($sCharacterName)
EndFunc
#EndRegion Friend Management Functions
