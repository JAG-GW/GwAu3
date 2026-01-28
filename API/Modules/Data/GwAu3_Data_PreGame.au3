#include-once

Func PreGame_Ptr()
	Return Memory_Read($g_p_PreGame, 'ptr')
EndFunc

Func PreGame_FrameID()
	Return Memory_Read(PreGame_Ptr(), 'dword')
EndFunc

Func PreGame_ChosenCharacter()
	Return Memory_Read(PreGame_Ptr() + 0xD4, 'dword')
EndFunc

Func PreGame_LoginCharacterArray()
	Return Memory_Read(PreGame_Ptr() + 0xDC, 'ptr')
EndFunc

Func PreGame_CharName($a_i_Index) ;from 0 to max character
	Return Memory_Read(PreGame_LoginCharacterArray() + 0x50 + (0x78 * $a_i_Index), 'WCHAR[20]')
EndFunc