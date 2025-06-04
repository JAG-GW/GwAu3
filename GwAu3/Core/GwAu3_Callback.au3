#include-once
#include "GwAu3_Constants_Core.au3"

Global $mCasterSkillActivate, $mMeleeSkillActivate

;~ Description: Controls Event System.
Func SetEvent($aCasterSkillActivate = '', $aMeleeSkillActivate = '')
	If Not $mUseEventSystem Then Return
	$mCasterSkillActivate = 0
	$mMeleeSkillActivate = 0

	If $aCasterSkillActivate <> '' Then
		WriteDetour('CasterSkillLogStart', 'CasterSkillLogProc')
	Else
		$mASMString = ''
		_('mov ebp,esp')
		_('push dword[ebp+8]')
		WriteBinary($mASMString, GetValue('CasterSkillLogStart'))
	EndIf

	If $aMeleeSkillActivate <> '' Then
		WriteDetour('MeleeSkillLogStart', 'MeleeSkillLogProc')
	Else
		$mASMString = ''
		_('mov ebp,esp')
		_('push dword[ebp+8]')
		WriteBinary($mASMString, GetValue('MeleeSkillLogStart'))
	EndIf

	$mCasterSkillActivate = $aCasterSkillActivate
	$mMeleeSkillActivate = $aMeleeSkillActivate
EndFunc   ;==>SetEvent

;~ Description: Internal use for event system.
;~ modified by gigi, avoid getagentbyid, just pass agent id to callback
Func Event($hwnd, $msg, $wparam, $lparam)
	Switch $lparam
		Case 0x1
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
			Call($mCasterSkillActivate, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3), DllStructGetData($mSkillLogStruct, 4))
		Case 0x2
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
			Call($mMeleeSkillActivate, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3), DllStructGetData($mSkillLogStruct, 4))
	EndSwitch
EndFunc   ;==>Event
