#include-once

#Region Status Functions
Func Friend_SetPlayerStatus($a_i_Status)
    If $a_i_Status < $GC_I_FRIEND_STATUS_OFFLINE Or $a_i_Status > $GC_I_FRIEND_STATUS_AWAY Then
        Log_Error("Invalid status: " & $a_i_Status, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if status is already set
    Local $l_i_CurrentStatus = Friend_GetMyStatus()
    If $l_i_CurrentStatus = $a_i_Status Then
        Log_Debug("Status already set to: " & Friend_GetFriendStatusName($a_i_Status), "FriendMod", $g_h_EditText)
        Return True
    EndIf

    DllStructSetData($g_d_ChangeStatus, 2, $a_i_Status)

    Core_Enqueue($g_p_ChangeStatus, 8)

    $g_i_LastStatus = $a_i_Status

    Log_Info("Changed player status to: " & Friend_GetFriendStatusName($a_i_Status), "FriendMod", $g_h_EditText)
    Return True
EndFunc

Func Friend_SetOnlineStatus()
    Return Friend_SetPlayerStatus($GC_I_FRIEND_STATUS_ONLINE)
EndFunc

Func Friend_SetOfflineStatus()
    Return Friend_SetPlayerStatus($GC_I_FRIEND_STATUS_OFFLINE)
EndFunc

Func Friend_SetDNDStatus()
    Return Friend_SetPlayerStatus($GC_I_FRIEND_STATUS_DND)
EndFunc

Func Friend_SetAwayStatus()
    Return Friend_SetPlayerStatus($GC_I_FRIEND_STATUS_AWAY)
EndFunc
#EndRegion Status Functions

#Region Friend Management Functions
Func Friend_AddFriend($a_s_CharacterName, $a_s_Alias = "", $a_i_FriendType = $GC_I_FRIEND_TYPE_FRIEND)
    If StringLen($a_s_CharacterName) = 0 Or StringLen($a_s_CharacterName) > $GC_I_FRIEND_CHARNAME_MAX_LENGTH Then
        Log_Error("Invalid character name length", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    If $a_i_FriendType < 1 Or $a_i_FriendType > 2 Then
        Log_Error("Invalid friend type: " & $a_i_FriendType, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $l_p_ExistingFriend = Friend_GetFriendInfo($a_s_CharacterName, "Ptr")
    If $l_p_ExistingFriend <> 0 Then
        Log_Warning("Friend already exists: " & $a_s_CharacterName, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $l_i_NameSize = (StringLen($a_s_CharacterName) + 1) * 2
    Local $l_i_AliasSize = (StringLen($a_s_Alias = "" ? $a_s_CharacterName : $a_s_Alias) + 1) * 2

    Local $l_p_NameMem = DllCall($g_h_Kernel32, 'ptr', 'VirtualAllocEx', 'handle', $g_h_GWProcess, 'ptr', 0, 'ulong_ptr', $l_i_NameSize, 'dword', 0x1000, 'dword', 0x40)
    $l_p_NameMem = $l_p_NameMem[0]

    Local $l_p_AliasMem = DllCall($g_h_Kernel32, 'ptr', 'VirtualAllocEx', 'handle', $g_h_GWProcess, 'ptr', 0, 'ulong_ptr', $l_i_AliasSize, 'dword', 0x1000, 'dword', 0x40)
    $l_p_AliasMem = $l_p_AliasMem[0]

    If $l_p_NameMem = 0 Or $l_p_AliasMem = 0 Then
        Log_Error("Failed to allocate memory in GW process", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    Local $l_d_NameStruct = DllStructCreate("wchar[" & (StringLen($a_s_CharacterName) + 1) & "]")
    Local $l_d_AliasStruct = DllStructCreate("wchar[" & (StringLen($a_s_Alias = "" ? $a_s_CharacterName : $a_s_Alias) + 1) & "]")

    DllStructSetData($l_d_NameStruct, 1, $a_s_CharacterName)
    DllStructSetData($l_d_AliasStruct, 1, $a_s_Alias = "" ? $a_s_CharacterName : $a_s_Alias)

    DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'ptr', $l_p_NameMem, 'ptr', DllStructGetPtr($l_d_NameStruct), 'int', $l_i_NameSize, 'int', 0)
    DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'ptr', $l_p_AliasMem, 'ptr', DllStructGetPtr($l_d_AliasStruct), 'int', $l_i_AliasSize, 'int', 0)

    Local $l_d_VerifyStruct = DllStructCreate("wchar[20]")
    DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'ptr', $l_p_NameMem, 'ptr', DllStructGetPtr($l_d_VerifyStruct), 'int', 40, 'int', 0)

    DllStructSetData($g_d_AddFriend, 2, $l_p_NameMem)
    DllStructSetData($g_d_AddFriend, 3, $l_p_AliasMem)
    DllStructSetData($g_d_AddFriend, 4, $a_i_FriendType)

    Core_Enqueue($g_p_AddFriend, 16)
    Sleep(500)
    DllCall($g_h_Kernel32, 'int', 'VirtualFreeEx', 'int', $g_h_GWProcess, 'ptr', $l_p_AliasMem, 'int', 0, 'dword', 0x8000)
EndFunc

Func Friend_RemoveFriend($a_s_NameOrAlias)
    ; Get array info
    Local $l_p_ArrayDataPtr = Memory_Read($g_p_FriendList + 0x00, "ptr")
    Local $l_i_ArraySize = Memory_Read($g_p_FriendList + 0x08, "dword")

    If $l_p_ArrayDataPtr = 0 Or $l_i_ArraySize = 0 Then
        Log_Error("Friend array is empty or invalid", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Find friend by name or alias
    Local $l_p_FriendPtr = 0
    Local $l_s_Alias = ""

    For $l_i_Idx = 0 To $l_i_ArraySize - 1
        Local $l_p_TempPtr = Memory_Read($l_p_ArrayDataPtr + (0x4 * $l_i_Idx), "ptr")
        If $l_p_TempPtr = 0 Then ContinueLoop

        ; Check character name
        Local $l_s_TempName = Memory_Read($l_p_TempPtr + 0x2C, 'wchar[20]')
        Local $l_s_TempAlias = Memory_Read($l_p_TempPtr + 0x18, 'wchar[20]')

        If $l_s_TempName = $a_s_NameOrAlias Or $l_s_TempAlias = $a_s_NameOrAlias Then
            $l_p_FriendPtr = $l_p_TempPtr
            $l_s_Alias = $l_s_TempAlias
            ExitLoop
        EndIf
    Next

    If $l_p_FriendPtr = 0 Then
        Log_Warning("Friend not found: " & $a_s_NameOrAlias, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Read UUID
    Local $l_d_UUIDBytes = DllStructCreate("byte[16]")
    DllCall($g_h_Kernel32, 'int', 'ReadProcessMemory', 'int', $g_h_GWProcess, 'ptr', $l_p_FriendPtr + 0x8, 'ptr', DllStructGetPtr($l_d_UUIDBytes), 'int', 16, 'int', '')

    ; Copy UUID to our structure
    For $l_i_Idx = 1 To 16
        DllStructSetData($g_d_RemoveFriend, 2, DllStructGetData($l_d_UUIDBytes, 1, $l_i_Idx), $l_i_Idx)
    Next

    ; Allocate memory for alias in GW process
    Local $l_i_AliasSize = (StringLen($l_s_Alias) + 1) * 2
    Local $l_p_AliasMem = DllCall($g_h_Kernel32, 'ptr', 'VirtualAllocEx', 'handle', $g_h_GWProcess, 'ptr', 0, 'ulong_ptr', $l_i_AliasSize, 'dword', 0x1000, 'dword', 0x40)
    $l_p_AliasMem = $l_p_AliasMem[0]

    If $l_p_AliasMem = 0 Then
        Log_Error("Failed to allocate memory in GW process", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Write alias to GW memory
    Local $l_d_AliasStruct = DllStructCreate("wchar[" & (StringLen($l_s_Alias) + 1) & "]")
    DllStructSetData($l_d_AliasStruct, 1, $l_s_Alias)
    DllCall($g_h_Kernel32, 'int', 'WriteProcessMemory', 'int', $g_h_GWProcess, 'ptr', $l_p_AliasMem, 'ptr', DllStructGetPtr($l_d_AliasStruct), 'int', $l_i_AliasSize, 'int', 0)

    ; Set up the command
    DllStructSetData($g_d_RemoveFriend, 3, $l_p_AliasMem)
    DllStructSetData($g_d_RemoveFriend, 4, 0)

    Core_Enqueue($g_p_RemoveFriend, 24)

    Sleep(500)
    DllCall($g_h_Kernel32, 'int', 'VirtualFreeEx', 'int', $g_h_GWProcess, 'ptr', $l_p_AliasMem, 'int', 0, 'dword', 0x8000)
EndFunc

Func Friend_AddIgnore($a_s_CharacterName, $a_s_Alias = "")
    Return Friend_AddFriend($a_s_CharacterName, $a_s_Alias, $GC_I_FRIEND_TYPE_IGNORE)
EndFunc

Func Friend_RemoveIgnore($a_s_CharacterName)
    ; Get array info
    Local $l_p_ArrayDataPtr = Memory_Read($g_p_FriendList + 0x00, "ptr")
    Local $l_i_ArraySize = Memory_Read($g_p_FriendList + 0x08, "dword")

    If $l_p_ArrayDataPtr = 0 Or $l_i_ArraySize = 0 Then
        Log_Error("Friend array is empty or invalid", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Find the person in the list
    Local $l_p_FriendPtr = 0
    Local $l_i_Type = 0

    For $l_i_Idx = 0 To $l_i_ArraySize - 1
        Local $l_p_TempPtr = Memory_Read($l_p_ArrayDataPtr + (0x4 * $l_i_Idx), "ptr")
        If $l_p_TempPtr = 0 Then ContinueLoop

        ; Check by character name
        Local $l_s_TempName = Memory_Read($l_p_TempPtr + 0x2C, 'wchar[20]')
        If $l_s_TempName = $a_s_CharacterName Then
            $l_p_FriendPtr = $l_p_TempPtr
            $l_i_Type = Memory_Read($l_p_TempPtr + 0x00, "dword")
            ExitLoop
        EndIf

        ; Check by alias
        Local $l_s_TempAlias = Memory_Read($l_p_TempPtr + 0x18, 'wchar[20]')
        If $l_s_TempAlias = $a_s_CharacterName Then
            $l_p_FriendPtr = $l_p_TempPtr
            $l_i_Type = Memory_Read($l_p_TempPtr + 0x00, "dword")
            ExitLoop
        EndIf
    Next

    If $l_p_FriendPtr = 0 Then
        Log_Warning("Person not found in list: " & $a_s_CharacterName, "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Check if the person is in ignore list
    If $l_i_Type <> $GC_I_FRIEND_TYPE_IGNORE Then
        Log_Warning("Person is not in ignore list: " & $a_s_CharacterName & " (Type: " & $l_i_Type & ")", "FriendMod", $g_h_EditText)
        Return False
    EndIf

    ; Remove from ignore list
    Return Friend_RemoveFriend($a_s_CharacterName)
EndFunc
#EndRegion Friend Management Functions
