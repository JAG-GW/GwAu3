#include-once

Func GwAu3_PreGame_Ptr()
	Return GwAu3_Memory_Read($g_p_PreGame, 'PTR')
EndFunc

Func GwAu3_PreGame_FrameID()
	Return GwAu3_Memory_Read(GwAu3_PreGame_Ptr(), 'DWORD')
EndFunc

Func GwAu3_PreGame_ChosenCharacterIndex()
	Return GwAu3_Memory_Read(GwAu3_PreGame_Ptr() + 0x0124, 'DWORD')
EndFunc

Func GwAu3_PreGame_ChosenCharacter() ;Index1
	Return GwAu3_Memory_Read(GwAu3_PreGame_Ptr() + 0x0140, 'DWORD')
EndFunc

Func GwAu3_PreGame_Index2()
	Return GwAu3_Memory_Read(GwAu3_PreGame_Ptr() + 0x0144, 'DWORD')
EndFunc

Func GwAu3_PreGame_LoginCharacterArray()
	Return GwAu3_Memory_Read(GwAu3_PreGame_Ptr() + 0x0148, 'PTR')
EndFunc

Func GwAu3_PreGame_CharName($aNumber) ;from 0 to max character
	Return GwAu3_Memory_Read(GwAu3_PreGame_LoginCharacterArray() + 0x004 + (0x002C * $aNumber), 'WCHAR[20]')
EndFunc