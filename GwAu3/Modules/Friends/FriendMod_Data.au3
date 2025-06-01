#include-once
#include "FriendMod_Initialize.au3"

Func GetMyStatus()
    Return MemoryRead($g_mFriendListPtr + 0xA0, 'dword')
EndFunc

Func GetFriendListPtr()
    Return $g_mFriendListPtr
EndFunc

Func _FriendMod_GetFriendListInfo($aInfo = "")
    Local $lPtr = GetFriendListPtr()
    If $lPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
		Case "NumberOfFriend"
			Return MemoryRead($lPtr + 0x24, "dword")
		Case "NumberOfIgnore"
			Return MemoryRead($lPtr + 0x28, "dword")
		Case "NumberOfPartner"
			Return MemoryRead($lPtr + 0x2C, "dword")
		Case "NumberOfTrade"
			Return MemoryRead($lPtr + 0x30, "dword")
		Case "PlayerStatus"
			Return MemoryRead($lPtr + 0xA0, "dword")
	EndSwitch

	Return 0
EndFunc

Func _FriendMod_GetFriendInfo($aFriendIdentifier = "", $aInfo = "")
    If $aFriendIdentifier = "" Or $aInfo = "" Then Return 0

    Local $lFriendPtr = 0
    Local $lFriendNumber = 0

    Local $lTotalFriends = MemoryRead($g_mFriendListPtr + 0x24, "dword") + _  ; Friends
                          MemoryRead($g_mFriendListPtr + 0x28, "dword") + _  ; Ignores
                          MemoryRead($g_mFriendListPtr + 0x2C, "dword") + _  ; Partners
                          MemoryRead($g_mFriendListPtr + 0x30, "dword")      ; Traders

    ; By friend number of Friend Name
    If IsNumber($aFriendIdentifier) Then
        $lFriendNumber = $aFriendIdentifier
        If $lFriendNumber < 1 Or $lFriendNumber > $lTotalFriends Then Return 0

        Local $lOffset[3] = [0, 0x4 * $lFriendNumber, 0]
        Local $lResult = MemoryReadPtr($g_mFriendListPtr, $lOffset, "ptr")
        $lFriendPtr = $lResult[0]
    Else
        ; Find by name
		For $i = 1 To $lTotalFriends
			Local $lOffset[3] = [0, 0x4 * $i, 0x2C]
			Local $lNameResult = MemoryReadPtr($g_mFriendListPtr, $lOffset, 'WCHAR[20]')
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
				Local $lNameResult = MemoryReadPtr($g_mFriendListPtr, $lOffset, 'WCHAR[20]')
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
            Return MemoryRead($lFriendPtr + 0x0, "dword")

        Case "Status", "FriendStatus"
            Return MemoryRead($lFriendPtr + 0x4, "dword")

        Case "UUID"
            Local $lUUID = ""
            For $i = 0 To 15
                $lUUID &= Hex(MemoryRead($lFriendPtr + 0x8 + $i, 'byte'), 2)
            Next
            Return Binary("0x" & $lUUID)

        Case "Name", "Alias"
            Return MemoryRead($lFriendPtr + 0x18, 'wchar[20]')

        Case "ConnectedName", "CharName", "Playing"
            Return MemoryRead($lFriendPtr + 0x2C, 'wchar[20]')

        Case "FriendID"
            Return MemoryRead($lFriendPtr + 0x40, "dword")

        Case "MapID", "ZoneID"
            Return MemoryRead($lFriendPtr + 0x44, "dword")

        Case "TypeName"
            Local $lType = MemoryRead($lFriendPtr + 0x0, "dword")
            Return GetFriendTypeName($lType)

        Case "StatusName"
            Local $lStatus = MemoryRead($lFriendPtr + 0x4, "dword")
            Return GetFriendStatusName($lStatus)

        Case "IsOnline"
            Return MemoryRead($lFriendPtr + 0x4, "dword") = $FRIEND_STATUS_ONLINE

        Case "IsOffline"
            Return MemoryRead($lFriendPtr + 0x4, "dword") = $FRIEND_STATUS_OFFLINE

        Case "IsFriend"
            Return MemoryRead($lFriendPtr + 0x0, "dword") = $FRIEND_TYPE_FRIEND

        Case "IsIgnored"
            Return MemoryRead($lFriendPtr + 0x0, "dword") = $FRIEND_TYPE_IGNORE

        Case "Number", "Index"
            Return $lFriendNumber

        Case Else
            Return 0
    EndSwitch
EndFunc

Func IsFriend($sCharacterName)
    Local $lFriendPtr = _FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lFriendPtr = 0 Then Return False

    Return _FriendMod_GetFriendInfo($sCharacterName, "Type") = $FRIEND_TYPE_FRIEND
EndFunc

Func IsIgnored($sCharacterName)
    Local $lFriendPtr = _FriendMod_GetFriendInfo($sCharacterName, "Ptr")
    If $lFriendPtr = 0 Then Return False

    Return _FriendMod_GetFriendInfo($sCharacterName, "Type") = $FRIEND_TYPE_IGNORE
EndFunc

Func GetFriendStatusName($iFriendStatus)
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

Func GetFriendTypeName($iFriendType)
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