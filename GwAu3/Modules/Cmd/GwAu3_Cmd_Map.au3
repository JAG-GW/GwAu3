#include-once

Func Map_Move($a_f_X, $a_f_Y, $a_f_Randomize = 50)
    ; Add randomization if requested
    If $a_f_Randomize > 0 Then
        $a_f_X += Random(-$a_f_Randomize, $a_f_Randomize)
        $a_f_Y += Random(-$a_f_Randomize, $a_f_Randomize)
    EndIf

    ; Store last move coordinates
    $g_f_LastMoveX = $a_f_X
    $g_f_LastMoveY = $a_f_Y

    ; Set move data
    DllStructSetData($g_d_Move, 2, $a_f_X)
    DllStructSetData($g_d_Move, 3, $a_f_Y)
    DllStructSetData($g_d_Move, 4, 0)  ; Z coordinate (usually 0)

    Core_Enqueue($g_p_Move, 16)

    Return True
EndFunc

;~ Description: Internal use for map travel.
Func Map_MoveMap($a_i_MapID, $a_i_Region, $a_i_District, $a_i_Language)
    Return Core_SendPacket(0x18, $GC_I_HEADER_PARTY_TRAVEL, $a_i_MapID, $a_i_Region, $a_i_District, $a_i_Language, False)
EndFunc   ;==>MoveMap

;~ Description: Returns to outpost after resigning/failure.
Func Map_ReturnToOutpost()
    Return Core_SendPacket(0x4, $GC_I_HEADER_PARTY_RETURN_TO_OUTPOST)
EndFunc   ;==>ReturnToOutpost

;~ Description: Enter a challenge mission/pvp.
Func Map_EnterChallenge()
    Return Core_SendPacket(0x8, $GC_I_HEADER_PARTY_ENTER_CHALLENGE, 1)
EndFunc   ;==>EnterChallenge

;~ Description: Enter a foreign challenge mission/pvp.
;~ Func EnterChallengeForeign()
;~     Return Core_SendPacket(0x8, $GC_I_HEADER_PARTY_ENTER_FOREIGN_CHALLENGE, 0)
;~ EndFunc   ;==>EnterChallengeForeign

;~ Description: Travel to your guild hall.
Func Map_TravelGH()
    Local $l_ai_Offset[3] = [0, 0x18, 0x3C]
    Local $l_ap_GH = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)
    Core_SendPacket(0x18, $GC_I_HEADER_PARTY_ENTER_GUILD_HALL, Memory_Read($l_ap_GH[1] + 0x64), Memory_Read($l_ap_GH[1] + 0x68), Memory_Read($l_ap_GH[1] + 0x6C), Memory_Read($l_ap_GH[1] + 0x70), 1)
    ;~ Return Map_WaitMapLoading()
EndFunc   ;==>TravelGH

;~ Description: Leave your guild hall.
Func Map_LeaveGH()
    Core_SendPacket(0x8, $GC_I_HEADER_PARTY_LEAVE_GUILD_HALL, 1)
    ;~ Return Map_WaitMapLoading()
EndFunc   ;==>LeaveGH

;~ Description: Map travel to an outpost.
Func Map_TravelTo($a_i_MapID, $a_i_Language = Map_GetCharacterInfo("Language"), $a_i_Region = Map_GetCharacterInfo("Region"), $a_i_District = 0)
    If Map_GetCharacterInfo("MapID") = $a_i_MapID And Map_GetInstanceInfo("IsOutpost") _
        And $a_i_Language = Map_GetCharacterInfo("Language") And $a_i_Region = Map_GetCharacterInfo("Region") Then Return True
    Map_MoveMap($a_i_MapID, $a_i_Region, $a_i_District, $a_i_Language)
    Return Map_WaitMapLoading($a_i_MapID)
EndFunc   ;==>TravelTo

Func Map_WaitMapLoading($a_i_MapID = -1, $a_i_InstanceType = -1)
    Do
        Sleep(250)
        If Game_GetGameInfo("IsCinematic") Then
            Cinematic_SkipCinematic()
            Sleep(1000)
        EndIf
    Until Agent_GetAgentPtr(-2) <> 0 And Agent_GetMaxAgents() <> 0 And World_GetWorldInfo("SkillbarArray") <> 0 And Party_GetPartyContextPtr() <> 0 _
    And ($a_i_InstanceType = -1 Or Map_GetInstanceInfo("Type") = $a_i_InstanceType) And ($a_i_MapID = -1 Or Map_GetCharacterInfo("MapID") = $a_i_MapID) And Not Game_GetGameInfo("IsCinematic")
EndFunc
