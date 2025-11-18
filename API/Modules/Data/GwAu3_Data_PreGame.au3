#include-once

Func PreGame_Ptr()
	Return Memory_Read($g_p_PreGame, 'PTR')
EndFunc

Func PreGame_FrameID()
	Return Memory_Read(PreGame_Ptr(), 'DWORD')
EndFunc

Func PreGame_ChosenCharacterIndex()
	Return Memory_Read(PreGame_Ptr() + 0x0124, 'DWORD')
EndFunc

Func PreGame_ChosenCharacter() ;Index1
	Return Memory_Read(PreGame_Ptr() + 0x0140, 'DWORD')
EndFunc

Func PreGame_Index2()
	Return Memory_Read(PreGame_Ptr() + 0x0144, 'DWORD')
EndFunc

Func PreGame_LoginCharacterArray()
	Return Memory_Read(PreGame_Ptr() + 0x0148, 'PTR')
EndFunc

Func PreGame_CharName($aNumber) ;from 0 to max character
	Return Memory_Read(PreGame_LoginCharacterArray() + 0x004 + (0x002C * $aNumber), 'WCHAR[20]')
EndFunc