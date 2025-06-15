#include-once
#include "FriendMod_Data.au3"

#Region Status Functions
Func GwAu3_FriendMod_SetPlayerStatus($iStatus)
    If Not $g_bFriendModuleInitialized Then
        GwAu3_Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    If $iStatus < $FRIEND_STATUS_OFFLINE Or $iStatus > $FRIEND_STATUS_AWAY Then
        GwAu3_Log_Error("Invalid status: " & $iStatus, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if status is already set
    Local $lCurrentStatus = GwAu3_FriendMod_GetMyStatus()
    If $lCurrentStatus = $iStatus Then
        GwAu3_Log_Debug("Status already set to: " & GwAu3_FriendMod_GetFriendStatusName($iStatus), "FriendMod", $g_h_EditText)
        Return True
    EndIf

    DllStructSetData($g_mChangeStatus, 1, GwAu3_Memory_GetValue('CommandPlayerStatus'))
    DllStructSetData($g_mChangeStatus, 2, $iStatus)

    GwAu3_Core_Enqueue($g_mChangeStatusPtr, 8)

    $g_iLastStatus = $iStatus

    GwAu3_Log_Info("Changed player status to: " & GwAu3_FriendMod_GetFriendStatusName($iStatus), "FriendMod", $g_h_EditText)
    Return True
EndFunc

Func GwAu3_FriendMod_SetOnlineStatus()
    Return GwAu3_FriendMod_SetPlayerStatus($FRIEND_STATUS_ONLINE)
EndFunc

Func GwAu3_FriendMod_SetOfflineStatus()
    Return GwAu3_FriendMod_SetPlayerStatus($FRIEND_STATUS_OFFLINE)
EndFunc

Func GwAu3_FriendMod_SetDNDStatus()
    Return GwAu3_FriendMod_SetPlayerStatus($FRIEND_STATUS_DND)
EndFunc

Func GwAu3_FriendMod_SetAwayStatus()
    Return GwAu3_FriendMod_SetPlayerStatus($FRIEND_STATUS_AWAY)
EndFunc
#EndRegion Status Functions

#Region Friend Management Functions
Func GwAu3_FriendMod_AddFriend($sCharacterName, $sAlias = "", $iFriendType = $FRIEND_TYPE_FRIEND)
    If Not $g_bFriendModuleInitialized Then
        GwAu3_Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    If StringLen($sCharacterName) = 0 Or StringLen($sCharacterName) > $FRIEND_CHARNAME_MAX_LENGTH Then
        GwAu3_Log_Error("Invalid character name length", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    If $iFriendType < 1 Or $iFriendType > 2 Then
        GwAu3_Log_Error("Invalid friend type: " & $iFriendType, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $lExistingFriend = GwAu3_FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lExistingFriend <> 0 Then
        GwAu3_Log_Warning("Friend already exists: " & $sCharacterName, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $iNameSize = (StringLen($sCharacterName) + 1) * 2
    Local $iAliasSize = (StringLen($sAlias = "" ? $sCharacterName : $sAlias) + 1) * 2

    Local $pNameMem = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $iNameSize, 'dword', 0x1000, 'dword', 0x40)
    $pNameMem = $pNameMem[0]

    Local $pAliasMem = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $iAliasSize, 'dword', 0x1000, 'dword', 0x40)
    $pAliasMem = $pAliasMem[0]

    If $pNameMem = 0 Or $pAliasMem = 0 Then
        GwAu3_Log_Error("Failed to allocate memory in GW process", "FriendMod", $g_h_EditText)
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

    DllStructSetData($g_mAddFriend, 1, GwAu3_Memory_GetValue('CommandAddFriend'))
    DllStructSetData($g_mAddFriend, 2, $pNameMem)
    DllStructSetData($g_mAddFriend, 3, $pAliasMem)
    DllStructSetData($g_mAddFriend, 4, $iFriendType)

    GwAu3_Core_Enqueue($g_mAddFriendPtr, 16)
	Sleep(500)
	DllCall($mKernelHandle, 'int', 'VirtualFreeEx', 'int', $mGWProcHandle, 'ptr', $pAliasMem, 'int', 0, 'dword', 0x8000)
EndFunc

Func GwAu3_FriendMod_RemoveFriend($sNameOrAlias)
    If Not $g_bFriendModuleInitialized Then
        GwAu3_Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Get array info
    Local $lArrayDataPtr = GwAu3_Memory_Read($g_mFriendListPtr + 0x00, "ptr")
    Local $lArraySize = GwAu3_Memory_Read($g_mFriendListPtr + 0x08, "dword")

    If $lArrayDataPtr = 0 Or $lArraySize = 0 Then
        GwAu3_Log_Error("Friend array is empty or invalid", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Find friend by name or alias
    Local $lFriendPtr = 0
    Local $lAlias = ""

    For $i = 0 To $lArraySize - 1
        Local $lTempPtr = GwAu3_Memory_Read($lArrayDataPtr + (0x4 * $i), "ptr")
        If $lTempPtr = 0 Then ContinueLoop

        ; Check character name
        Local $lTempName = GwAu3_Memory_Read($lTempPtr + 0x2C, 'wchar[20]')
        Local $lTempAlias = GwAu3_Memory_Read($lTempPtr + 0x18, 'wchar[20]')

        If $lTempName = $sNameOrAlias Or $lTempAlias = $sNameOrAlias Then
            $lFriendPtr = $lTempPtr
            $lAlias = $lTempAlias
            ExitLoop
        EndIf
    Next

    If $lFriendPtr = 0 Then
        GwAu3_Log_Warning("Friend not found: " & $sNameOrAlias, "FriendMod", $g_h_EditText)
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
        GwAu3_Log_Error("Failed to allocate memory in GW process", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Write alias to GW memory
    Local $lAliasStruct = DllStructCreate("wchar[" & (StringLen($lAlias) + 1) & "]")
    DllStructSetData($lAliasStruct, 1, $lAlias)
    DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $pAliasMem, 'ptr', DllStructGetPtr($lAliasStruct), 'int', $iAliasSize, 'int', 0)

    ; Set up the command
    DllStructSetData($g_mRemoveFriend, 1, GwAu3_Memory_GetValue('CommandRemoveFriend'))
    DllStructSetData($g_mRemoveFriend, 3, $pAliasMem)
    DllStructSetData($g_mRemoveFriend, 4, 0)

    GwAu3_Core_Enqueue($g_mRemoveFriendPtr, 24)

    Sleep(500)
    DllCall($mKernelHandle, 'int', 'VirtualFreeEx', 'int', $mGWProcHandle, 'ptr', $pAliasMem, 'int', 0, 'dword', 0x8000)
EndFunc

Func GwAu3_FriendMod_AddIgnore($sCharacterName, $sAlias = "")
    Return GwAu3_FriendMod_AddFriend($sCharacterName, $sAlias, $FRIEND_TYPE_IGNORE)
EndFunc

Func GwAu3_FriendMod_RemoveIgnore($sCharacterName)
    If Not $g_bFriendModuleInitialized Then
        GwAu3_Log_Error("FriendMod module not initialized", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Get array info
    Local $lArrayDataPtr = GwAu3_Memory_Read($g_mFriendListPtr + 0x00, "ptr")
    Local $lArraySize = GwAu3_Memory_Read($g_mFriendListPtr + 0x08, "dword")

    If $lArrayDataPtr = 0 Or $lArraySize = 0 Then
        GwAu3_Log_Error("Friend array is empty or invalid", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Find the person in the list
    Local $lFriendPtr = 0
    Local $lType = 0

    For $i = 0 To $lArraySize - 1
        Local $lTempPtr = GwAu3_Memory_Read($lArrayDataPtr + (0x4 * $i), "ptr")
        If $lTempPtr = 0 Then ContinueLoop

        ; Check by character name
        Local $lTempName = GwAu3_Memory_Read($lTempPtr + 0x2C, 'wchar[20]')
        If $lTempName = $sCharacterName Then
            $lFriendPtr = $lTempPtr
            $lType = GwAu3_Memory_Read($lTempPtr + 0x00, "dword")
            ExitLoop
        EndIf

        ; Check by alias
        Local $lTempAlias = GwAu3_Memory_Read($lTempPtr + 0x18, 'wchar[20]')
        If $lTempAlias = $sCharacterName Then
            $lFriendPtr = $lTempPtr
            $lType = GwAu3_Memory_Read($lTempPtr + 0x00, "dword")
            ExitLoop
        EndIf
    Next

    If $lFriendPtr = 0 Then
        GwAu3_Log_Warning("Person not found in list: " & $sCharacterName, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if the person is in ignore list
    If $lType <> $FRIEND_TYPE_IGNORE Then
        GwAu3_Log_Warning("Person is not in ignore list: " & $sCharacterName & " (Type: " & $lType & ")", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Remove from ignore list
    Return GwAu3_FriendMod_RemoveFriend($sCharacterName)
EndFunc
#EndRegion Friend Management Functions
