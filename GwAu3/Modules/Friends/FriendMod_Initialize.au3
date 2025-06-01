#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

Global $g_mChangeStatus = DllStructCreate('ptr;dword')
Global $g_mChangeStatusPtr = DllStructGetPtr($g_mChangeStatus)

Global $g_bFriendModuleInitialized = False
Global $g_iLastStatus = 0
Global $g_mCurrentStatus = 0

Func _FriendMod_Initialize()
    If $g_bFriendModuleInitialized Then
        _Log_Warning("SkillMod module already initialized", "SkillMod", $GUIEdit)
        Return True
    EndIf

    _FriendMod_InitializeData()
    _FriendMod_InitializeCommands()
    $g_bFriendModuleInitialized = True

    Return True
EndFunc

Func _FriendMod_InitializeData()
	$g_mCurrentStatus = MemoryRead(GetScannedAddress('ScanChangeStatusFunction', 0x23))
	If $g_mCurrentStatus = 0 Then _Log_Error("Invalid Current status address", "FriendMod", $GUIEdit)
	SetValue('CurrentStatus', Ptr($g_mCurrentStatus))
	_Log_Debug("CurrentStatus: " & Ptr($g_mCurrentStatus), "FriendMod", $GUIEdit)
EndFunc

Func _FriendMod_InitializeCommands()
	SetValue('ChangeStatusFunction', Ptr(GetScannedAddress("ScanChangeStatusFunction", 0x1)))
	_Log_Debug("ChangeStatusFunction: " & GetValue('ChangeStatusFunction'), "FriendMod", $GUIEdit)
EndFunc

Func _FriendMod_Cleanup()
    If Not $g_bFriendModuleInitialized Then Return

	$g_iLastStatus = 0
    $g_bFriendModuleInitialized = False
EndFunc

Func _FriendMod_DefinePatterns()
	_('ScanChangeStatusFunction:')
	AddPattern('558BEC568B750883FE047C14')
EndFunc

Func _FriendMod_CreateCommands()
	_('CommandChangeStatus:')
	_('mov eax,dword[eax+4]')
	_('push eax')
	_('call ChangeStatusFunction')
	_('pop eax')
	_('ljmp CommandReturn')
EndFunc