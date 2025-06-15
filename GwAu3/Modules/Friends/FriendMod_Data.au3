#include-once

#Region Module Constants
; Friend types
Global Const $FRIEND_TYPE_UNKNOWN = 0
Global Const $FRIEND_TYPE_FRIEND = 1
Global Const $FRIEND_TYPE_IGNORE = 2
Global Const $FRIEND_TYPE_PLAYER = 3
Global Const $FRIEND_TYPE_TRADE = 4

; Friend status
Global Const $FRIEND_STATUS_OFFLINE = 0
Global Const $FRIEND_STATUS_ONLINE = 1
Global Const $FRIEND_STATUS_DND = 2
Global Const $FRIEND_STATUS_AWAY = 3
Global Const $FRIEND_STATUS_UNKNOWN = 4

; Structure sizes
Global Const $FRIEND_STRUCT_SIZE = 0x48
Global Const $FRIENDLIST_STRUCT_SIZE = 0xA4
Global Const $FRIEND_ALIAS_MAX_LENGTH = 20
Global Const $FRIEND_CHARNAME_MAX_LENGTH = 20
Global Const $FRIEND_UUID_SIZE = 16
#EndRegion Module Constants

Func GwAu3_FriendMod_GetMyStatus()
    Return GwAu3_Memory_Read($g_mFriendListPtr + 0xA0, 'dword')
EndFunc

Func GwAu3_FriendMod_GetFriendListPtr()
    Return $g_mFriendListPtr
EndFunc

Func GwAu3_FriendMod_GetFriendListInfo($aInfo = "")
    Local $lPtr = _FriendMod_GetFriendListPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "NumberOfFriend"
			Return GwAu3_Memory_Read($lPtr + 0x24, "dword")
		Case "NumberOfIgnore"
			Return GwAu3_Memory_Read($lPtr + 0x28, "dword")
		Case "NumberOfPartner"
			Return GwAu3_Memory_Read($lPtr + 0x2C, "dword")
		Case "NumberOfTrade"
			Return GwAu3_Memory_Read($lPtr + 0x30, "dword")
		Case "PlayerStatus"
			Return GwAu3_Memory_Read($lPtr + 0xA0, "dword")
	EndSwitch

	Return 0
EndFunc

Func GwAu3_FriendMod_GetFriendInfo($aFriendIdentifier = "", $aInfo = "")
    If $aFriendIdentifier = "" Or $aInfo = "" Then Return 0

    Local $lFriendPtr = 0
    Local $lFriendNumber = 0

    Local $lTotalFriends = GwAu3_Memory_Read($g_mFriendListPtr + 0x24, "dword") + _  ; Friends
                          GwAu3_Memory_Read($g_mFriendListPtr + 0x28, "dword") + _  ; Ignores
                          GwAu3_Memory_Read($g_mFriendListPtr + 0x2C, "dword") + _  ; Partners
                          GwAu3_Memory_Read($g_mFriendListPtr + 0x30, "dword")      ; Traders

    ; By friend number of Friend Name
    If IsNumber($aFriendIdentifier) Then
        $lFriendNumber = $aFriendIdentifier
        If $lFriendNumber < 1 Or $lFriendNumber > $lTotalFriends Then Return 0

        Local $lOffset[3] = [0, 0x4 * $lFriendNumber, 0]
        Local $lResult = GwAu3_Memory_ReadPtr($g_mFriendListPtr, $lOffset, "ptr")
        $lFriendPtr = $lResult[0]
    Else
        ; Find by name
		For $i = 1 To $lTotalFriends
			Local $lOffset[3] = [0, 0x4 * $i, 0x2C]
			Local $lNameResult = GwAu3_Memory_ReadPtr($g_mFriendListPtr, $lOffset, 'WCHAR[20]')
			If $lNameResult[1] = $aFriendIdentifier Then
				$lFriendNumber = $i
				$lFriendPtr = $lNameResult[0] - 0x2C
				ExitLoop
			EndIf
		Next

		; Find by alias
		If $lFriendPtr = 0 Then
			 For $i = 1 To $lTotalFriends
				Local $lOffset[3] = [0, 0x4 * $i, 0x18]
				Local $lNameResult = GwAu3_Memory_ReadPtr($g_mFriendListPtr, $lOffset, 'WCHAR[20]')
				If $lNameResult[1] = $aFriendIdentifier Then
					$lFriendNumber = $i
					$lFriendPtr = $lNameResult[0] - 0x18
					ExitLoop
				EndIf
			Next
		EndIf
    EndIf

    Switch $aInfo
        Case "Type", "FriendType"
            Return GwAu3_Memory_Read($lFriendPtr + 0x0, "dword")

        Case "Status", "FriendStatus"
            Return GwAu3_Memory_Read($lFriendPtr + 0x4, "dword")

        Case "UUID"
            Local $lUUID = ""
            For $i = 0 To 15
                $lUUID &= Hex(GwAu3_Memory_Read($lFriendPtr + 0x8 + $i, 'byte'), 2)
            Next
            Return Binary("0x" & $lUUID)

        Case "Name", "Alias"
            Return GwAu3_Memory_Read($lFriendPtr + 0x18, 'wchar[20]')

        Case "ConnectedName", "CharName", "Playing"
            Return GwAu3_Memory_Read($lFriendPtr + 0x2C, 'wchar[20]')

        Case "FriendID"
            Return GwAu3_Memory_Read($lFriendPtr + 0x40, "dword")

        Case "MapID", "ZoneID"
            Return GwAu3_Memory_Read($lFriendPtr + 0x44, "dword")

        Case "TypeName"
            Local $lType = GwAu3_Memory_Read($lFriendPtr + 0x0, "dword")
            Return _FriendMod_GetFriendTypeName($lType)

        Case "StatusName"
            Local $lStatus = GwAu3_Memory_Read($lFriendPtr + 0x4, "dword")
            Return _FriendMod_GetFriendStatusName($lStatus)

        Case "IsOnline"
            Return GwAu3_Memory_Read($lFriendPtr + 0x4, "dword") = $FRIEND_STATUS_ONLINE

        Case "IsOffline"
            Return GwAu3_Memory_Read($lFriendPtr + 0x4, "dword") = $FRIEND_STATUS_OFFLINE

        Case "IsFriend"
            Return GwAu3_Memory_Read($lFriendPtr + 0x0, "dword") = $FRIEND_TYPE_FRIEND

        Case "IsIgnored"
            Return GwAu3_Memory_Read($lFriendPtr + 0x0, "dword") = $FRIEND_TYPE_IGNORE

        Case "Number", "Index"
            Return $lFriendNumber

        Case Else
            Return 0
    EndSwitch
EndFunc

Func GwAu3_FriendMod_IsFriend($sCharacterName)
    Local $lFriendPtr = _FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lFriendPtr = 0 Then Return False

    Return _FriendMod_GetFriendInfo($sCharacterName, "Type") = $FRIEND_TYPE_FRIEND
EndFunc

Func GwAu3_FriendMod_IsIgnored($sCharacterName)
    Local $lFriendPtr = _FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lFriendPtr = 0 Then Return False

    Return _FriendMod_GetFriendInfo($sCharacterName, "Type") = $FRIEND_TYPE_IGNORE
EndFunc

Func GwAu3_FriendMod_GetFriendStatusName($iFriendStatus)
    Switch $iFriendStatus
        Case $FRIEND_STATUS_OFFLINE
            Return "Offline"
        Case $FRIEND_STATUS_ONLINE
            Return "Online"
        Case $FRIEND_STATUS_DND
            Return "Do Not Disturb"
        Case $FRIEND_STATUS_AWAY
            Return "Away"
        Case Else
            Return "Unknown"
    EndSwitch
EndFunc

Func GwAu3_FriendMod_GetFriendTypeName($iFriendType)
    Switch $iFriendType
        Case $FRIEND_TYPE_FRIEND
            Return "Friend"
        Case $FRIEND_TYPE_IGNORE
            Return "Ignore"
        Case $FRIEND_TYPE_PLAYER
            Return "Player"
        Case $FRIEND_TYPE_TRADE
            Return "Trade"
        Case Else
            Return "Unknown"
    EndSwitch
EndFunc