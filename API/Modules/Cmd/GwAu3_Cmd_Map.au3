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
Func Map_ReturnToOutpost($a_WaitToLoad = True)
	Map_InitMapIsLoaded()
    Core_SendPacket(0x4, $GC_I_HEADER_PARTY_RETURN_TO_OUTPOST)
	If $a_WaitToLoad Then Return Map_WaitMapIsLoaded()
EndFunc   ;==>ReturnToOutpost

;~ Description: Enter a challenge mission/pvp.
Func Map_EnterChallenge($a_WaitToLoad = True)
	Map_InitMapIsLoaded()
    Core_SendPacket(0x8, $GC_I_HEADER_PARTY_ENTER_CHALLENGE, 1)
	If $a_WaitToLoad Then Return Map_WaitMapIsLoaded()
EndFunc   ;==>EnterChallenge

;~ Description: Enter a foreign challenge mission/pvp.
;~ Func EnterChallengeForeign()
;~     Return Core_SendPacket(0x8, $GC_I_HEADER_PARTY_ENTER_FOREIGN_CHALLENGE, 0)
;~ EndFunc   ;==>EnterChallengeForeign

;~ Description: Travel to your guild hall.
Func Map_TravelGH()
    Local $l_ai_Offset[3] = [0, 0x18, 0x3C]
    Local $l_ap_GH = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset)

	Map_InitMapIsLoaded()
    Core_SendPacket(0x18, $GC_I_HEADER_PARTY_ENTER_GUILD_HALL, Memory_Read($l_ap_GH[1] + 0x64), Memory_Read($l_ap_GH[1] + 0x68), Memory_Read($l_ap_GH[1] + 0x6C), Memory_Read($l_ap_GH[1] + 0x70), 1)
    Map_WaitMapIsLoaded()
EndFunc   ;==>TravelGH

;~ Description: Leave your guild hall.
Func Map_LeaveGH()
	Map_InitMapIsLoaded()
    Core_SendPacket(0x8, $GC_I_HEADER_PARTY_LEAVE_GUILD_HALL, 1)
    Map_WaitMapIsLoaded()
EndFunc   ;==>LeaveGH

;~ Description: Map travel to an outpost.
Func Map_TravelTo($a_i_MapID, $a_i_Language = Map_GetCharacterInfo("Language"), $a_i_Region = Map_GetCharacterInfo("Region"), $a_i_District = 0, $a_WaitToLoad = True)
    If Map_GetCharacterInfo("MapID") = $a_i_MapID _
    And Map_GetInstanceInfo("IsOutpost") _
    And $a_i_Language = Map_GetCharacterInfo("Language") _
    And $a_i_Region = Map_GetCharacterInfo("Region") Then
        Return True
    EndIf
	Map_InitMapIsLoaded()
    Map_MoveMap($a_i_MapID, $a_i_Region, $a_i_District, $a_i_Language)
    If $a_WaitToLoad Then Return Map_WaitMapIsLoaded()
EndFunc   ;==>TravelTo

;~ Description: Travel to a map in a random district (different from current)
;~ $a_i_MapID = Target map ID
;~ $a_i_MaxRegions = Number of regions to use (7=EU only, 8=EU+Int, 11=All excluding America)
Func Map_RndTravel($a_i_MapID)
    ; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, us-en, int, asia-ko, asia-ch
	Local $a_i_MaxRegions = 11
    Local $a_i_Region[11]   = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
    Local $a_i_Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]

    ; Clamp to valid range
    If $a_i_MaxRegions < 1 Then $a_i_MaxRegions = 1
    If $a_i_MaxRegions > 11 Then $a_i_MaxRegions = 11

    ; Get current region/language
    Local $l_i_CurrentRegion = Map_GetCharacterInfo("Region")
    Local $l_i_CurrentLanguage = Map_GetCharacterInfo("Language")

    ; Find a different district
    Local $l_i_Random
    Local $l_i_Attempts = 0
    Do
        $l_i_Random = Random(0, $a_i_MaxRegions - 1, 1)
        $l_i_Attempts += 1
        ; Safety: prevent infinite loop if only 1 district available
        If $l_i_Attempts > 50 Then ExitLoop
    Until $a_i_Region[$l_i_Random] <> $l_i_CurrentRegion Or $a_i_Language[$l_i_Random] <> $l_i_CurrentLanguage

    Map_InitMapIsLoaded()
    Map_MoveMap($a_i_MapID, $a_i_Region[$l_i_Random], 0, $a_i_Language[$l_i_Random])
    Return Map_WaitMapIsLoaded()
EndFunc   ;==>Map_RndTravel

Func Map_WaitMapLoading($a_i_MapID = -1, $a_i_InstanceType = -1, $a_i_Timeout = 30000)
	Local $l_b_TimedOut = False, $l_h_Timeout = TimerInit()

    Do
        Sleep(250)
        If Game_GetGameInfo("IsCinematic") Then
            Cinematic_SkipCinematic()
            Sleep(1000)
        EndIf
        $l_b_TimedOut = (TimerDiff($l_h_Timeout) >= $a_i_Timeout)
    Until ( _
        Agent_GetAgentPtr(-2) <> 0 _
        And Agent_GetMaxAgents() <> 0 _
        And World_GetWorldInfo("SkillbarArray") <> 0 _
        And Party_GetPartyContextPtr() <> 0 _
        And ($a_i_InstanceType = -1 Or Map_GetInstanceInfo("Type") = $a_i_InstanceType) _
        And ($a_i_MapID = -1 Or Map_GetCharacterInfo("MapID") = $a_i_MapID) _
        And Not Game_GetGameInfo("IsCinematic") _
        And Other_GetPing() <> 0 _
    ) Or $l_b_TimedOut
	If $l_b_TimedOut Then Return False

    Sleep(250)

	Return True
EndFunc

Func Map_InitMapIsLoaded()
    Memory_Write($g_p_MapIsLoaded, 0)
EndFunc

Func Map_MapIsLoaded()
    If Memory_Read($g_p_MapIsLoaded) = 1 Then
        Memory_Write($g_p_MapIsLoaded, 0)
        Return True
    EndIf
    Return False
EndFunc

Func Map_WaitMapIsLoaded($a_i_Timeout = 30000)
    If Map_MapIsLoaded() Then Return True

    Local $l_b_TimedOut = False, $l_h_Timeout = TimerInit()
    Do
        Sleep(50)
        $l_b_TimedOut = (TimerDiff($l_h_Timeout) >= $a_i_Timeout)
    Until Map_MapIsLoaded() Or $l_b_TimedOut
    If $l_b_TimedOut Then Return False

    Sleep(250)

    $l_h_Timeout = TimerInit()
    If Game_GetGameInfo("IsCinematic") Then
        Cinematic_SkipCinematic()
        Do
            Sleep(50)
            $l_b_TimedOut = (TimerDiff($l_h_Timeout) >= $a_i_Timeout)
        Until Map_MapIsLoaded() Or $l_b_TimedOut
        If $l_b_TimedOut Then Return False
    EndIf

    Sleep(250)

    Return True
EndFunc