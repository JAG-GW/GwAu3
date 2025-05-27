#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

#Region Module Constants
; Skill module specific constants
Global Const $SKILL_LOG_SIZE = 0x00000010
Global Const $SKILL_EVENT_ACTIVATE = 1
Global Const $SKILL_EVENT_CANCEL = 2
Global Const $SKILL_EVENT_COMPLETE = 3
#EndRegion Module Constants

#Region Module Global Variables
Global $g_mSkillBase	; Pointer to skill data array
Global $g_mSkillTimer	; Pointer to skill timer

; Skill command structures
Global $g_mUseSkill = DllStructCreate('ptr;dword;dword;dword;bool')
Global $g_mUseSkillPtr = DllStructGetPtr($g_mUseSkill)

Global $g_mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Global $g_mUseHeroSkillPtr = DllStructGetPtr($g_mUseHeroSkill)

; Module state variables
Global $g_bSkillModuleInitialized = False
Global $g_iLastSkillUsed = 0
Global $g_iLastSkillTarget = 0
#EndRegion Module Global Variables

#Region Initialize Functions
Func _SkillMod_Initialize()
    If $g_bSkillModuleInitialized Then
        _Log_Warning("SkillMod module already initialized", "SkillMod", $GUIEdit)
        Return True
    EndIf

    _SkillMod_InitializeData()
    _SkillMod_InitializeCommands()
    $g_bSkillModuleInitialized = True

    Return True
EndFunc

Func _SkillMod_InitializeData()
	$g_mSkillBase = MemoryRead(GetScannedAddress('ScanSkillBase', 0x8))
	If $g_mSkillBase = 0 Then _Log_Error("Invalid SkillBase address", "SkillMod", $GUIEdit)
	SetValue('SkillBase', Ptr($g_mSkillBase))
	_Log_Debug("SkillBase: " & Ptr($g_mSkillBase), "SkillMod", $GUIEdit)

	$g_mSkillTimer = MemoryRead(GetScannedAddress('ScanSkillTimer', -0x3))
	If $g_mSkillTimer = 0 Then _Log_Error("Invalid SkillTimer address", "SkillMod", $GUIEdit)
	SetValue('SkillTimer', Ptr($g_mSkillTimer))
	_Log_Debug("SkillTimer: " & Ptr($g_mSkillTimer), "SkillMod", $GUIEdit)
EndFunc

Func _SkillMod_InitializeCommands()
	SetValue('UseSkillFunction', Ptr(GetScannedAddress('ScanUseSkillFunction', -0x125)))
	_Log_Debug("UseSkillFunction: " & GetValue('UseSkillFunction'), "SkillMod", $GUIEdit)

	SetValue('UseHeroSkillFunction', Ptr(GetScannedAddress('ScanUseHeroSkillFunction', -0x59)))
	_Log_Debug("UseHeroSkillFunction: " & GetValue('UseHeroSkillFunction'), "SkillMod", $GUIEdit)

	Local $lTemp
	$lTemp = GetScannedAddress('ScanSkillLog', 0x1)
	SetValue('SkillLogStart', Ptr($lTemp))
	SetValue('SkillLogReturn', Ptr($lTemp + 0x5))

	$lTemp = GetScannedAddress('ScanSkillCompleteLog', -0x4)
	SetValue('SkillCompleteLogStart', Ptr($lTemp))
	SetValue('SkillCompleteLogReturn', Ptr($lTemp + 0x5))

	$lTemp = GetScannedAddress('ScanSkillCancelLog', 0x5)
	SetValue('SkillCancelLogStart', Ptr($lTemp))
	SetValue('SkillCancelLogReturn', Ptr($lTemp + 0x6))

	SetValue('SkillLogSize', $SKILL_LOG_SIZE)
EndFunc

Func _SkillMod_Cleanup()
    If Not $g_bSkillModuleInitialized Then Return

    $g_iLastSkillUsed = 0
    $g_iLastSkillTarget = 0
    $g_bSkillModuleInitialized = False
EndFunc
#EndRegion Initialize Functions

#Region Pattern, Structure & Assembly Code Generation
Func _SkillMod_DefinePatterns()
    _('ScanSkillBase:')
    AddPattern('8D04B6C1E00505') ; STILL WORKING 23.12.24

    _('ScanSkillTimer:')
    AddPattern('FFD68B4DF08BD88B4708') ; STILL WORKING 23.12.24

    _('ScanUseSkillFunction:')
    AddPattern('85F6745B83FE1174') ; STILL WORKING 23.12.24

    _('ScanUseHeroSkillFunction:')
    AddPattern('BA02000000B954080000') ; STILL WORKING 23.12.24

    _('ScanSkillLog:')
    AddPattern('408946105E5B5D') ; COULD NOT UPDATE! 23.12.24

    _('ScanSkillCompleteLog:')
    AddPattern('741D6A006A40') ; COULD NOT UPDATE! 23.12.24

    _('ScanSkillCancelLog:')
    AddPattern('741D6A006A48') ; COULD NOT UPDATE! 23.12.24
EndFunc

Func _SkillMod_SetupStructures()
    DllStructSetData($g_mUseSkill, 1, GetValue('CommandUseSkill'))
    DllStructSetData($g_mUseHeroSkill, 1, GetValue('CommandUseHeroSkill'))
EndFunc

Func _SkillMod_CreateCommands()
	_('CommandUseSkill:')
	_('mov ecx,dword[eax+10]')
	_('push ecx')
	_('mov ebx,dword[eax+C]')
	_('push ebx')
	_('mov edx,dword[eax+8]')
	_('push edx')
	_('mov ecx,dword[eax+4]')
	_('push ecx')
	_('call UseSkillFunction')
	_('add esp,10')
	_('ljmp CommandReturn')

	_('CommandUseHeroSkill:')
    _('mov ecx,dword[eax+8]')
    _('push ecx')
    _('mov ecx,dword[eax+c]')
    _('push ecx')
    _('mov ecx,dword[eax+4]')
    _('push ecx')
    _('call UseHeroSkillFunction')
    _('add esp,C')
    _('ljmp CommandReturn')
EndFunc
#EndRegion Pattern, Structure & Assembly Code Generation
