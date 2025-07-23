#include-once

#Region Game Context Related
Func Game_GetGameContextPtr()
    Local $l_ai_Offset[2] = [0, 0x18]
    Local $l_ap_GamePtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "ptr")
    Return $l_ap_GamePtr[1]
EndFunc

Func Game_GetGameInfo($a_s_Info = "")
    Local $l_p_Ptr = Game_GetGameContextPtr()
    If $l_p_Ptr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AgentContext"
            Return Memory_Read($l_p_Ptr + 0x8, "ptr")
        Case "MapContext"
            Return Memory_Read($l_p_Ptr + 0x14, "ptr")

        Case "TextParser"
            Return Memory_Read($l_p_Ptr + 0x18, "ptr")
        Case "GameLanguage"
            Local $l_p_TextParserPtr = Memory_Read($l_p_Ptr + 0x18, "ptr")
            Return Memory_Read($l_p_TextParserPtr + 0x1d0, "dword")

        Case "SomeNumber"
            Return Memory_Read($l_p_Ptr + 0x20, "dword")
        Case "AccountContext"
            Return Memory_Read($l_p_Ptr + 0x28, "ptr")
        Case "WorldContext"
            Return Memory_Read($l_p_Ptr + 0x2C, "ptr")

        Case "Cinematic"
            Return Memory_Read($l_p_Ptr + 0x30, "ptr")
        Case "IsCinematic"
            Local $l_p_CinematicPtr = Memory_Read($l_p_Ptr + 0x30, "ptr")
            If Memory_Read($l_p_CinematicPtr) <> 0 Or Memory_Read($l_p_CinematicPtr + 0x4) <> 0 Then Return True
            Return False

        Case "GadgetContext"
            Return Memory_Read($l_p_Ptr + 0x38, "ptr")
        Case "GuildContext"
            Return Memory_Read($l_p_Ptr + 0x3C, "ptr")
        Case "ItemContext"
            Return Memory_Read($l_p_Ptr + 0x40, "ptr")
        Case "CharContext"
            Return Memory_Read($l_p_Ptr + 0x44, "ptr")
        Case "PartyContext"
            Return Memory_Read($l_p_Ptr + 0x4C, "ptr")
        Case "TradeContext"
            Return Memory_Read($l_p_Ptr + 0x58, "ptr")
    EndSwitch

    Return 0
EndFunc
#EndRegion Game Context Related