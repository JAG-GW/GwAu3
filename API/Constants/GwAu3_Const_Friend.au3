#include-once

#Region Module Constants
; Friend types
Global Const $GC_I_FRIEND_TYPE_UNKNOWN = 0
Global Const $GC_I_FRIEND_TYPE_FRIEND = 1
Global Const $GC_I_FRIEND_TYPE_IGNORE = 2
Global Const $GC_I_FRIEND_TYPE_PLAYER = 3
Global Const $GC_I_FRIEND_TYPE_TRADE = 4

; Friend status
Global Const $GC_I_FRIEND_STATUS_OFFLINE = 0
Global Const $GC_I_FRIEND_STATUS_ONLINE = 1
Global Const $GC_I_FRIEND_STATUS_DND = 2
Global Const $GC_I_FRIEND_STATUS_AWAY = 3
Global Const $GC_I_FRIEND_STATUS_UNKNOWN = 4

; Structure sizes
Global Const $GC_I_FRIEND_STRUCT_SIZE = 0x48
Global Const $GC_I_FRIENDLIST_STRUCT_SIZE = 0xA4
Global Const $GC_I_FRIEND_ALIAS_MAX_LENGTH = 20
Global Const $GC_I_FRIEND_CHARNAME_MAX_LENGTH = 20
Global Const $GC_I_FRIEND_UUID_SIZE = 16
#EndRegion Module Constants