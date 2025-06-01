#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

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

#Region Module Global Variables
; Friend data pointers
Global $g_mFriendListPtr        ; Pointer to FriendList structure

; Friend command structures
Global $g_mChangeStatus = DllStructCreate('ptr;dword')
Global $g_mChangeStatusPtr = DllStructGetPtr($g_mChangeStatus)

Global $g_mAddFriend = DllStructCreate('ptr;ptr;ptr;dword')
Global $g_mAddFriendPtr = DllStructGetPtr($g_mAddFriend)

Global $g_mRemoveFriend = DllStructCreate('ptr;byte[16];ptr;dword')
Global $g_mRemoveFriendPtr = DllStructGetPtr($g_mRemoveFriend)

; Module state variables
Global $g_bFriendModuleInitialized = False
Global $g_iLastStatus = 0
#EndRegion Module Global Variables

#Region Initialize Functions
Func _FriendMod_Initialize()
    If $g_bFriendModuleInitialized Then
        _Log_Warning("FriendMod module already initialized", "FriendMod", $GUIEdit)
        Return True
    EndIf

    _FriendMod_InitializeData()
    _FriendMod_InitializeCommands()

    $g_bFriendModuleInitialized = True
    Return True
EndFunc

Func _FriendMod_InitializeData()
	$g_mFriendListPtr = GetScannedAddress('ScanFriendList', 0)
	$g_mFriendListPtr = MemoryRead(FindInRange("57B9", "xx", 2, $g_mFriendListPtr, $g_mFriendListPtr + 0xFF))
    If $g_mFriendListPtr = 0 Then
        _Log_Error("Invalid FriendList pointer", "FriendMod", $GUIEdit)
    Else
        _Log_Debug("FriendList: " & Ptr($g_mFriendListPtr), "FriendMod", $GUIEdit)
    EndIf
EndFunc

Func _FriendMod_InitializeCommands()
    ; SetOnlineStatus function
    SetValue('SetOnlineStatusFunction', Ptr(GetScannedAddress("ScanSetOnlineStatusFunction", -0x25)))
    _Log_Debug("SetOnlineStatusFunction: " & GetValue('SetOnlineStatusFunction'), "FriendMod", $GUIEdit)

    ; AddFriend function
    SetValue('AddFriendFunction', Ptr(GetScannedAddress("ScanAddFriendFunction", -0x47)))
    _Log_Debug("AddFriendFunction: " & GetValue('AddFriendFunction'), "FriendMod", $GUIEdit)

	Local $lScan = GetScannedAddress("ScanRemoveFriendCall", 0)
	$lScan = FindInRange("50E8", "xx", 1, $lScan, $lScan + 0x32)
	$lScan = FunctionFromNearCall($lScan)
	SetValue('RemoveFriendFunction', Ptr($lScan))
	_Log_Debug("RemoveFriendFunction: " & Ptr($lScan), "FriendMod", $GUIEdit)
EndFunc

Func _FriendMod_Cleanup()
    If Not $g_bFriendModuleInitialized Then Return

    $g_iLastStatus = 0
    $g_bFriendModuleInitialized = False

    _Log_Info("FriendMod module cleanup completed", "FriendMod", $GUIEdit)
EndFunc
#EndRegion Initialize Functions

#Region Pattern, Structure & Assembly Code Generation
Func _FriendMod_DefinePatterns()
    _('ScanSetOnlineStatusFunction:')
    AddPattern('83FE037740FF24B50000000033C0')

    _('ScanAddFriendFunction:')
    AddPattern('8B751083FE037465')

    _('ScanRemoveFriendCall:')
    AddPattern('83F803741D83F8047418')
EndFunc

Func _FriendMod_CreateCommands()
    _('CommandSetOnlineStatus:')
    _('mov eax,dword[eax+4]')
    _('push eax')
    _('call SetOnlineStatusFunction')
    _('pop eax')
    _('ljmp CommandReturn')

    _('CommandAddFriend:')
    _('mov ecx,dword[eax+C]')  ; type
    _('push ecx')
    _('mov edx,dword[eax+8]')   ; alias
    _('push edx')
    _('mov ecx,dword[eax+4]')   ; name
    _('push ecx')
    _('call AddFriendFunction')
    _('add esp,C')
    _('ljmp CommandReturn')

    _('CommandRemoveFriend:')
    _('mov ecx,dword[eax+18]')  ; arg8 (usually 0)
    _('push ecx')
    _('mov edx,dword[eax+14]')  ; name
    _('push edx')
    _('lea ecx,dword[eax+4]')   ; uuid
    _('push ecx')
    _('call RemoveFriendFunction')
    _('add esp,C')
    _('ljmp CommandReturn')
EndFunc
#EndRegion Pattern, Structure & Assembly Code Generation