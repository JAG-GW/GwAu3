#include-once

Func GwAu3_Agent_ConvertID($a_i_ID)
	Select
		Case $a_i_ID = -2
			Return GwAu3_Agent_GetMyID()
		Case $a_i_ID = -1
			Return GwAu3_Agent_GetCurrentTarget()
		Case IsPtr($a_i_ID) <> 0
			Return GwAu3_Memory_Read($a_i_ID + 0x2C, 'long')
		Case IsDllStruct($a_i_ID) <> 0
			Return DllStructGetData($a_i_ID, 'ID')
		Case Else
			Return $a_i_ID
	EndSelect
EndFunc

Func GwAu3_Agent_GetAgentBase()
    Return $g_p_AgentBase
EndFunc

Func GwAu3_Agent_GetMaxAgents()
    Return GwAu3_Memory_Read($g_i_MaxAgents, 'dword')
EndFunc

Func GwAu3_Agent_GetMyID()
    Return GwAu3_Memory_Read($g_i_MyID, 'dword')
EndFunc

Func GetMyID()
	Local $l_a_Offset[5] = [0, 0x18, 0x2C, 0x680, 0x14]
	Local $l_p_Return = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
	Return $l_p_Return[1]
EndFunc

Func GwAu3_Agent_GetCurrentTarget()
    Return GwAu3_Memory_Read($g_i_CurrentTarget, 'dword')
EndFunc

Func GwAu3_Agent_GetAgentCopyCount()
    Return GwAu3_Memory_Read($g_i_AgentCopyCount, 'dword')
EndFunc

Func GwAu3_Agent_GetAgentCopyBase()
    Return $g_p_AgentCopyBase
EndFunc

Func GwAu3_Agent_GetLastTarget()
    Return $g_iLastTargetID
EndFunc

Func GwAu3_Agent_GetAgentPtr($a_i_AgentID = -2)
	If IsPtr($a_i_AgentID) Then Return $a_i_AgentID
	Local $l_a_Offset[3] = [0, 4 * GwAu3_Agent_ConvertID($a_i_AgentID), 0]
	Local $l_p_Return = GwAu3_Memory_ReadPtr($g_p_AgentBase, $l_a_Offset)
	Return $l_p_Return[0]
EndFunc

#Region Agent Related
Func GwAu3_Agent_GetAgentInfo($a_i_AgentID = -2, $a_s_Info = "")
    Local $l_p_AgentPtr = GwAu3_Agent_GetAgentPtr($a_i_AgentID)
    If $l_p_AgentPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "vtable"
            Return GwAu3_Memory_Read($l_p_AgentPtr, "ptr")
        Case "h0004"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4, "dword")
        Case "h0008"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x8, "dword")
        Case "h000C"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC, "dword")
        Case "h0010"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
        Case "Timer"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x14, "dword")
        Case "Timer2"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x18, "dword")
        Case "h0018"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1C, "dword[4]")
        Case "ID"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x2C, "long")
        Case "Z"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x30, "float")
        Case "Width1"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x34, "float")
        Case "Height1"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x38, "float")
        Case "Width2"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x3C, "float")
        Case "Height2"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x40, "float")
        Case "Width3"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x44, "float")
        Case "Height3"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x48, "float")
        Case "Rotation"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4C, "float")
        Case "RotationCos"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x50, "float")
        Case "RotationSin"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x54, "float")
        Case "NameProperties"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x58, "dword")
        Case "Ground"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x5C, "dword")
        Case "h0060"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x60, "dword")
        Case "TerrainNormalX"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x64, "float")
        Case "TerrainNormalY"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x68, "float")
        Case "TerrainNormalZ"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x6C, "dword")
        Case "h0070"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x70, "byte[4]")
        Case "X"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x74, "float")
        Case "Y"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x78, "float")
        Case "Plane"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x7C, "dword")
        Case "h0080"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x80, "byte[4]")
        Case "NameTagX"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x84, "float")
        Case "NameTagY"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x88, "float")
        Case "NameTagZ"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x8C, "float")
        Case "VisualEffects"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x90, "short")
        Case "h0092"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x92, "short")
        Case "h0094"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x94, "dword[2]")


        Case "Type"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x9C, "long")
		Case "IsItemType"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0x400
		Case "IsGadgetType"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0x200
		Case "IsLivingType"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0xDB


        Case "MoveX"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xA0, "float")
        Case "MoveY"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xA4, "float")
        Case "h00A8"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xA8, "dword")
        Case "RotationCos2"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xAC, "float")
        Case "RotationSin2"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xB0, "float")
        Case "h00B4"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xB4, "dword[4]")

        Case "Owner"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC4, "long")
		Case "CanPickUp"
			If GwAu3_Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0x400 Then
				If GwAu3_Memory_Read($l_p_AgentPtr + 0xC4, "long") = 0 Or GwAu3_Memory_Read($l_p_AgentPtr + 0xC4, "long") = GetMyID() Then Return True
			EndIf
			Return False

        Case "ItemID"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC8, "dword")
        Case "ExtraType"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xCC, "dword")
        Case "GadgetID"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xD0, "dword")
        Case "h00D4"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xD4, "dword[3]")
        Case "AnimationType"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xE0, "float")
        Case "h00E4"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xE4, "dword[2]")
        Case "AttackSpeed"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xEC, "float")
        Case "AttackSpeedModifier"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xF0, "float")
        Case "PlayerNumber"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xF4, "short")
        Case "AgentModelType"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xF6, "short")
		Case "TransmogNpcId"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xF8, "dword")
        Case "Equipment"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xFC, "ptr")
        Case "h0100"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x100, "dword")
        Case "Tags"
            Return GwAu3_Memory_Read(GwAu3_Memory_Read($l_p_AgentPtr + 0x104, "ptr"), "short")
        Case "h0108"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x108, "short")
        Case "Primary"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10A, "byte")
        Case "Secondary"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10B, "byte")
        Case "Level"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10C, "byte")
        Case "Team"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10D, "byte")
        Case "h010E"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10E, "byte[2]")
        Case "h0110"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x110, "dword")
        Case "EnergyRegen"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x114, "float")
        Case "Overcast"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x118, "float")
        Case "EnergyPercent"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x11C, "float")
        Case "MaxEnergy"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x120, "dword")
		Case "CurrentEnergy"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x11C, "float") * GwAu3_Memory_Read($l_p_AgentPtr + 0x120, "dword")
        Case "h0124"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x124, "dword")
        Case "HPPips"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x128, "float")
        Case "h012C"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x12C, "dword")
        Case "HP"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x130, "float")
        Case "MaxHP"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x134, "dword")
		Case "CurrentHP"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x130, "float") * GwAu3_Memory_Read($l_p_AgentPtr + 0x134, "dword")

        Case "Effects"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword")
		Case "EffectCount"
            Local $l_i_AgentID = GwAu3_Agent_ConvertID($a_i_AgentID)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x508]
            Local $l_p_AgentEffectsBase = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x510]
            Local $l_i_AgentEffectsCount = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)

            If $l_p_AgentEffectsBase[1] = 0 Or $l_i_AgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $l_i_AgentEffectsCount[1] - 1
                Local $l_p_AgentEffects = $l_p_AgentEffectsBase[1] + ($i * 0x24)
                Local $l_i_CurrentAgentID = GwAu3_Memory_Read($l_p_AgentEffects, "dword")

                If $l_i_CurrentAgentID = $l_i_AgentID Then
                    Local $l_p_EffectArray = $l_p_AgentEffects + 0x14
                    Return GwAu3_Memory_Read($l_p_EffectArray + 0x8, "long")
                EndIf
            Next
            Return 0
        Case "BuffCount"
            Local $l_i_AgentID = GwAu3_Agent_ConvertID($a_i_AgentID)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x508]
            Local $l_p_AgentEffectsBase = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x510]
            Local $l_i_AgentEffectsCount = GwAu3_Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)

            If $l_p_AgentEffectsBase[1] = 0 Or $l_i_AgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $l_i_AgentEffectsCount[1] - 1
                Local $l_p_AgentEffects = $l_p_AgentEffectsBase[1] + ($i * 0x24)
                Local $l_i_CurrentAgentID = GwAu3_Memory_Read($l_p_AgentEffects, "dword")

                If $l_i_CurrentAgentID = $l_i_AgentID Then
                    Local $l_p_BuffArray = $l_p_AgentEffects + 0x4
                    Return GwAu3_Memory_Read($l_p_BuffArray + 0x8, "long")
                EndIf
            Next

            Return 0


		Case "IsBleeding"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0001) > 0
		Case "IsConditioned"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0002) > 0
		Case "IsCrippled"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x000A) = 0xA
		Case "IsDead"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0010) > 0
		Case "IsDeepWounded"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0020) > 0
		Case "IsPoisoned"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0040) > 0
		Case "IsEnchanted"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0080) > 0
		Case "IsDegenHexed"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0400) > 0
		Case "IsHexed"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0800) > 0
		Case "IsWeaponSpelled"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x8000) > 0

        Case "h013C"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x13C, "dword")
        Case "Hex"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x140, "byte")
        Case "h0141"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x141, "byte[19]")

        Case "ModelState"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword")
		Case "IsKnockedDown"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x450
		Case "IsMoving"
			If GwAu3_Memory_Read($l_p_AgentPtr + 0xA0, "float") <> 0 Or GwAu3_Memory_Read($l_p_AgentPtr + 0xA4, "float") <> 0 Then Return True
			If GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 12 Or GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 76 Or GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 204 Then Return True
			Return False
		Case "IsAttacking"
			If GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x60 Or GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x440 Or GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x460 Then Return True
			Return False
		Case "IsCasting"
			If GwAu3_Memory_Read($l_p_AgentPtr + 0x1B4, "short") <> 0 Then Return True
			If GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x41 Or GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x245 Then Return True
			Return False
		Case "IsIdle"
			If GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 68 Or GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 64 Or GwAu3_Memory_Read($l_p_AgentPtr + 0x154, "dword") = 100 Then Return True
			Return False

        Case "TypeMap"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword")
		Case "InCombatStance"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000001) > 0
		Case "HasQuest"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000002) > 0
		Case "IsDeadByTypeMap"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000008) > 0
		Case "IsFemale"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000200) > 0
		Case "HasBossGlow"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000400) > 0
		Case "IsHidingCap"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x001000) > 0
		Case "CanBeViewedInPartyWindow"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x20000) > 0
		Case "IsSpawned"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x040000) > 0
		Case "IsBeingObserved"
			Return BitAND(GwAu3_Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x400000) > 0

        Case "h015C"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x15C, "dword[4]")
        Case "InSpiritRange"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x16C, "dword")
		Case "VisibleEffectsPtr"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x170, "ptr")
        Case "VisibleEffects"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x170, "dword")
        Case "VisibleEffectsID"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x174, "dword")
        Case "VisibleEffectsHasEnded"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x178, "dword")
        Case "h017C"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x17C, "dword")

        Case "LoginNumber"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x180, "dword")
		Case "IsPlayer"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x180, "dword") <> 0
		Case "IsNPC"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x180, "dword") = 0

        Case "AnimationSpeed"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x184, "float")
        Case "AnimationCode"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x188, "dword")
        Case "AnimationId"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x18C, "dword")
        Case "h0190"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x190, "byte[32]")
        Case "LastStrike"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1B0, "byte")
        Case "Allegiance"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1B1, "byte")
        Case "WeaponType"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1B2, "short")
        Case "Skill"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1B4, "short")
        Case "h01B6"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1B6, "short")
        Case "WeaponItemType"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1B8, "byte")
        Case "OffhandItemType"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1B9, "byte")
        Case "WeaponItemId"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1BA, "short")
        Case "OffhandItemId"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1BC, "short")

		Case "Name"
			Return 0 ;in progress
		Case Else
			Return 0
	EndSwitch

    Return 0
EndFunc

Func GwAu3_Agent_GetAgentEquimentInfo($a_i_AgentID = -2, $a_s_Info = "")
	Local $l_p_AgentPtr = GwAu3_Agent_GetAgentInfo($a_i_AgentID, "Equipment")
    If $l_p_AgentPtr = 0 Or $a_s_Info = "" Then Return 0
    Switch $a_s_Info
        Case "vtable"
            Return GwAu3_Memory_Read($l_p_AgentPtr, "dword")
		Case "h0004"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4, "dword")
		Case "h0008"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x8, "dword")
		Case "h000C"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC, "dword")
		Case "LeftHandData"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "Ptr")
		Case "RightHandData"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x14, "Ptr")
		Case "h0018"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x18, "dword")
		Case "ShieldData"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1C, "Ptr")


		Case "Weapon_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x24, "dword")
		Case "Weapon_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x28, "byte")
		Case "Weapon_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x29, "byte")
		Case "Weapon_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x2A, "byte")
		Case "Weapon_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x2B, "byte")
		Case "Weapon_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x2C, "dword")
		Case "Weapon_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x30, "dword")


		Case "Offhand_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x34, "dword")
		Case "Offhand_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x38, "byte")
		Case "Offhand_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x39, "byte")
		Case "Offhand_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x3A, "byte")
		Case "Offhand_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x3B, "byte")
		Case "Offhand_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x3C, "dword")
		Case "Offhand_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x40, "dword")

		Case "Chest_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x44, "dword")
		Case "Chest_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x48, "byte")
		Case "Chest_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x49, "byte")
		Case "Chest_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4A, "byte")
		Case "Chest_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4B, "byte")
		Case "Chest_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4C, "dword")
		Case "Chest_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x50, "dword")

		Case "Leg_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x54, "dword")
		Case "Leg_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x58, "byte")
		Case "Leg_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x59, "byte")
		Case "Leg_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x5A, "byte")
		Case "Leg_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x5B, "byte")
		Case "Leg_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x5C, "dword")
		Case "Leg_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x60, "dword")

		Case "Head_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x64, "dword")
		Case "Head_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x68, "byte")
		Case "Head_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x69, "byte")
		Case "Head_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x6A, "byte")
		Case "Head_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x6B, "byte")
		Case "Head_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x6C, "dword")
		Case "Head_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x70, "dword")

		Case "Feet_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x74, "dword")
		Case "Feet_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x78, "byte")
		Case "Feet_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x79, "byte")
		Case "Feet_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x7A, "byte")
		Case "Feet_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x7B, "byte")
		Case "Feet_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x7C, "dword")
		Case "Feet_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x80, "dword")

		Case "Hands_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x84, "dword")
		Case "Hands_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x88, "byte")
		Case "Hands_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x89, "byte")
		Case "Hands_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x8A, "byte")
		Case "Hands_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x8B, "byte")
		Case "Hands_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x8C, "dword")
		Case "Hands_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x90, "dword")

		Case "CostumeBody_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x94, "dword")
		Case "CostumeBody_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x98, "byte")
		Case "CostumeBody_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x99, "byte")
		Case "CostumeBody_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x9A, "byte")
		Case "CostumeBody_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x9B, "byte")
		Case "CostumeBody_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0x9C, "dword")
		Case "CostumeBody_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xA0, "dword")

		Case "CostumeHead_ModelFileID"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xA4, "dword")
		Case "CostumeHead_Type"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xA8, "byte")
		Case "CostumeHead_Dye1"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xA9, "byte")
		Case "CostumeHead_Dye2"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xAA, "byte")
		Case "CostumeHead_Dye3"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xAB, "byte")
		Case "CostumeHead_Value"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xAC, "dword")
		Case "CostumeHead_Interaction"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xB0, "dword")

		Case "ItemID_Weapon"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xB4, "dword")
		Case "ItemID_Offhand"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xB8, "dword")
		Case "ItemID_Chest"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xBC, "dword")
		Case "ItemID_Legs"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC0, "dword")
		Case "ItemID_Head"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC4, "dword")
		Case "ItemID_Feet"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC8, "dword")
		Case "ItemID_Hands"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xCC, "dword")
		Case "ItemID_CostumeBody"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xD0, "dword")
		Case "ItemID_CostumeHead"
			Return GwAu3_Memory_Read($l_p_AgentPtr + 0xD4, "dword")
	EndSwitch
	Return 0
EndFunc

Func GwAu3_Agent_GetAgentVisibleEffectInfo($a_i_AgentID = -2, $a_s_Info = "")
	Local $l_p_AgentPtr = GwAu3_Agent_GetAgentInfo($a_i_AgentID, "VisibleEffectsPtr")
    If $l_p_AgentPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "" ; dummy case to avoid syntax error
            Sleep(100)
	EndSwitch

	Return 0
EndFunc

Func GwAu3_Agent_GetAgentArray($a_i_Type = 0)
    Local $l_i_MaxAgents = GwAu3_Agent_GetMaxAgents()
    If $l_i_MaxAgents <= 0 Then Return

	Local $l_a_AgentArray[$l_i_MaxAgents + 1]
    Local $l_p_Pointer, $l_i_Count = 0
    Local $l_p_AgentBase = GwAu3_Memory_Read($g_p_AgentBase)
    Local $l_p_AgentPtrBuffer = DllStructCreate("ptr[" & $l_i_MaxAgents & "]")

    DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", "handle", $g_h_GWProcess, "ptr", $l_p_AgentBase, "struct*", $l_p_AgentPtrBuffer, "ulong_ptr", 4 * $l_i_MaxAgents, "ulong_ptr*", 0)

    For $i = 1 To $l_i_MaxAgents
        $l_p_Pointer = DllStructGetData($l_p_AgentPtrBuffer, 1, $i)
        If $l_p_Pointer = 0 Then ContinueLoop

        If $a_i_Type <> 0 Then
            If GwAu3_Agent_GetAgentInfo($l_p_Pointer, "Type") <> $a_i_Type Then ContinueLoop
        EndIf

        $l_i_Count += 1
        $l_a_AgentArray[$l_i_Count] = $l_p_Pointer
    Next

    $l_a_AgentArray[0] = $l_i_Count
    ReDim $l_a_AgentArray[$l_i_Count + 1]

    Return $l_a_AgentArray
EndFunc

;~ Func GwAu3_Agent_GetAgentArray()
;~     Local $l_a_AgentArray = GwAu3_Memory_ReadArray($mAgentBase, 0x8)
;~     Return $l_a_AgentArray
;~ EndFunc
#EndRegion Agent Related

Func GwAu3_Agent_GetDistance($a_i_Agent1ID, $a_i_Agent2ID = 0)
    If $a_i_Agent2ID = 0 Then $a_i_Agent2ID = GwAu3_Agent_GetMyID()

    Local $l_f_X1 = GwAu3_Agent_GetAgentInfo($a_i_Agent1ID, "X")
    Local $l_f_Y1 = GwAu3_Agent_GetAgentInfo($a_i_Agent1ID, "Y")
    Local $l_f_X2 = GwAu3_Agent_GetAgentInfo($a_i_Agent2ID, "X")
    Local $l_f_Y2 = GwAu3_Agent_GetAgentInfo($a_i_Agent2ID, "Y")

    Return Sqrt(($l_f_X1 - $l_f_X2)^2 + ($l_f_Y1 - $l_f_Y2)^2)
EndFunc

#Region Effect Related
Func GwAu3_Agent_GetAgentEffectArrayInfo($a_i_AgentID = -2, $a_s_Info = "")
    Local $l_p_Pointer = GwAu3_World_GetWorldInfo("AgentEffectsArray")
    Local $l_i_Size = GwAu3_World_GetWorldInfo("AgentEffectsArraySize")
    Local $l_p_AgentPtr = 0

    For $i = 0 To $l_i_Size
        Local $l_p_AgentEffects = $l_p_Pointer + ($i * 0x24)
        If GwAu3_Memory_Read($l_p_AgentEffects, "dword") = GwAu3_Agent_ConvertID($a_i_AgentID) Then
            $l_p_AgentPtr = $l_p_AgentEffects
            ExitLoop
        EndIf
    Next

    If $l_p_AgentPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AgentID"
            Return GwAu3_Memory_Read($l_p_AgentPtr, "dword")
        Case "BuffArray"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4, "ptr")
        Case "BuffArraySize"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x4 + 0x8, "long")
        Case "EffectArray"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x14, "ptr")
        Case "EffectArraySize"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x14 + 0x8, "long")
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GwAu3_Agent_GetAgentEffectInfo($a_i_AgentID = -2, $a_i_SkillID = 0, $a_s_Info = "")
    Local $l_p_EffectArray = GwAu3_Agent_GetAgentEffectArrayInfo($a_i_AgentID, "EffectArray")
    Local $l_i_EffectCount = GwAu3_Agent_GetAgentEffectArrayInfo($a_i_AgentID, "EffectArraySize")

    If $l_p_EffectArray = 0 Or $l_i_EffectCount = 0 Then Return 0

    Local $l_p_EffectPtr = 0
    For $j = 0 To $l_i_EffectCount - 1
        Local $l_p_CurrentPtr = $l_p_EffectArray + ($j * 0x18)
        Local $l_i_CurrentSkillID = GwAu3_Memory_Read($l_p_CurrentPtr, "long")

        If $l_i_CurrentSkillID = $a_i_SkillID Then
            $l_p_EffectPtr = $l_p_CurrentPtr
            ExitLoop
        EndIf
    Next

    If $l_p_EffectPtr = 0 Then Return 0
    If $a_s_Info = "" Then Return $l_p_EffectPtr

    Switch $a_s_Info
;~         Case "SkillID"
;~             Return GwAu3_Memory_Read($l_p_EffectPtr, "long")
        Case "AttributeLevel"
            Return GwAu3_Memory_Read($l_p_EffectPtr + 0x4, "dword")
        Case "EffectID"
            Return GwAu3_Memory_Read($l_p_EffectPtr + 0x8, "long")
        Case "CasterID" ; maintained enchantment
            Return GwAu3_Memory_Read($l_p_EffectPtr + 0xC, "dword")
        Case "Duration"
            Return GwAu3_Memory_Read($l_p_EffectPtr + 0x10, "float")
        Case "Timestamp"
            Return GwAu3_Memory_Read($l_p_EffectPtr + 0x14, "dword")
        Case "TimeElapsed"
            Local $l_i_Timestamp = GwAu3_Memory_Read($l_p_EffectPtr + 0x14, "dword")
            Return _Skill_GetSkillTimer() - $l_i_Timestamp
        Case "TimeRemaining"
            Local $l_i_Timestamp = GwAu3_Memory_Read($l_p_EffectPtr + 0x14, "dword")
            Local $l_i_Duration = GwAu3_Memory_Read($l_p_EffectPtr + 0x10, "float")
            Return $l_i_Duration * 1000 - (_Skill_GetSkillTimer() - $l_i_Timestamp)
        Case "HasEffect"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GwAu3_Agent_GetAgentBuffInfo($a_i_AgentID = -2, $a_i_SkillID = 0, $a_s_Info = "")
    Local $l_p_BuffArray = GwAu3_Agent_GetAgentEffectArrayInfo($a_i_AgentID, "BuffArray")
    Local $l_i_BuffCount = GwAu3_Agent_GetAgentEffectArrayInfo($a_i_AgentID, "BuffArraySize")

    If $l_p_BuffArray = 0 Or $l_i_BuffCount = 0 Then Return 0

    Local $l_p_BuffPtr = 0
    For $j = 0 To $l_i_BuffCount - 1
        Local $l_p_CurrentPtr = $l_p_BuffArray + ($j * 0x10)
        Local $l_i_CurrentSkillID = GwAu3_Memory_Read($l_p_CurrentPtr, "long")

        If $l_i_CurrentSkillID = $a_i_SkillID Then
            $l_p_BuffPtr = $l_p_CurrentPtr
            ExitLoop
        EndIf
    Next

    If $l_p_BuffPtr = 0 Then Return 0
    If $a_s_Info = "" Then Return $l_p_BuffPtr

    Switch $a_s_Info
;~         Case "SkillID"
;~             Return GwAu3_Memory_Read($l_p_BuffPtr, "long")
        Case "h0004"
            Return GwAu3_Memory_Read($l_p_BuffPtr + 0x4, "dword")
        Case "BuffID"
            Return GwAu3_Memory_Read($l_p_BuffPtr + 0x8, "long")
        Case "TargetAgentID"
            Return GwAu3_Memory_Read($l_p_BuffPtr + 0xC, "dword")
        Case "HasBuff"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion

#Region Related NPC Info
;~ TIPS: $a_i_ModelFileID = Player number of an npc
Func GwAu3_Agent_GetNpcInfo($a_i_ModelFileID = 0, $a_s_Info = "")
	Local $l_p_Pointer = GwAu3_World_GetWorldInfo("NpcArray")
	Local $l_i_Size = GwAu3_World_GetWorldInfo("NpcArraySize")
	Local $l_p_AgentPtr = 0

	For $i = 0 To $l_i_Size
        Local $l_p_AgentEffects = $l_p_Pointer + ($i * 0x30)
        If GwAu3_Memory_Read($l_p_AgentEffects, "dword") = $a_i_ModelFileID Then
            $l_p_AgentPtr = $l_p_AgentEffects
            ExitLoop
        EndIf
    Next

	If $l_p_AgentPtr = 0 Then Return 0

	Switch $a_s_Info
		Case "ModelFileID"
            Return GwAu3_Memory_Read($l_p_AgentPtr, "dword")
        Case "Scale"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x8, "dword")
		Case "Sex"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0xC, "dword")
		Case "NpcFlags"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
		Case "Primary"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x14, "dword")
		Case "DefaultLevel", "Level"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1C, "byte")
		Case "IsHenchman"
			Local $flags = GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x10) <> 0
		Case "IsHero"
			Local $flags = GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x20) <> 0
		Case "IsSpirit"
			Local $flags = GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x4000) <> 0
		Case "IsMinion"
			Local $flags = GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x100) <> 0
		Case "IsPet"
			Local $flags = GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0xD) <> 0
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion

#Region Related Player Info
Func GwAu3_Agent_GetPlayerInfo($a_i_AgentID = 0, $a_s_Info = "")
    Local $l_p_Pointer = GwAu3_World_GetWorldInfo("PlayerArray")
    Local $l_i_Size = GwAu3_World_GetWorldInfo("PlayerArraySize")
    Local $l_p_AgentPtr = 0

    For $i = 1 To $l_i_Size - 1
        Local $l_p_AgentEffects = $l_p_Pointer + ($i * 0x4C)
        If GwAu3_Memory_Read($l_p_AgentEffects, "dword") = GwAu3_Agent_ConvertID($a_i_AgentID) Then
            $l_p_AgentPtr = $l_p_AgentEffects
            ExitLoop
        EndIf
    Next

    If $l_p_AgentPtr = 0 Then Return 0

    Switch $a_s_Info
        Case "AgentID"
            Return GwAu3_Memory_Read($l_p_AgentPtr, "dword")
        Case "AppearanceBitmap"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x10, "dword")
        Case "Flags"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x14, "dword")
        Case "Primary"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x18, "dword")
        Case "Secondary"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x1C, "dword")
        Case "Name"
;~             Return GwAu3_Memory_Read($l_p_AgentPtr + 0x24, "wchar[20]")
            Local $lName = GwAu3_Memory_Read($l_p_AgentPtr + 0x24, "ptr")
            Return GwAu3_Memory_Read($lName, "wchar[20]")
        Case "PartLeaderPlayerNumber"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x2C, "dword")
        Case "ActiveTitle"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x30, "dword")
        Case "PlayerNumber"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x34, "dword")
        Case "PartySize"
            Return GwAu3_Memory_Read($l_p_AgentPtr + 0x38, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GwAu3_Agent_GetPlayerLogInfo($a_s_Info = "")
    Local $l_p_Pointer = GwAu3_World_GetWorldInfo("PlayerArray")
    If $l_p_Pointer = 0 Then Return 0

    Switch $a_s_Info
        Case "LastPlayerHeroAdded"
            Return GwAu3_Memory_Read($l_p_Pointer + 0x2C, "dword")
        Case "LastPartyHenchmenCount"
            Local $l_i_HenchmenCount = GwAu3_Memory_Read($l_p_Pointer + 0x38, "dword")
            $l_i_HenchmenCount = $l_i_HenchmenCount - ($l_i_HenchmenCount <> 0)
        Case "LastPlayerOut"
            Local $lLogPtr = GwAu3_Memory_Read($l_p_Pointer + 0x3C, "ptr")
            If $lLogPtr = 0 Then Return 0
            Local $lZoneCnt = GwAu3_Memory_Read($l_p_Pointer + 0x44, "dword")
            Return GwAu3_Memory_Read($lLogPtr + (($lZoneCnt - 1) * 0x4))
        Case "LogCapacity"
            Return GwAu3_Memory_Read($l_p_Pointer + 0x40, "dword")
        Case "ZoneCount"
            Return GwAu3_Memory_Read($l_p_Pointer + 0x44, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion Related Player Info

Func GwAu3_Agent_GetBestTarget($a_i_Range = 1320)
    Local $l_i_BestTarget, $l_f_Distance, $l_f_LowestSum = 100000000
    Local $l_ai_AgentArray = GwAu3_Agent_GetAgentArray(0xDB)
    For $l_i_Idx = 1 To $l_ai_AgentArray[0]
        Local $l_f_SumDistances = 0
        If GwAu3_Agent_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'Allegiance') <> 3 Then ContinueLoop
        If GwAu3_Agent_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'HP') <= 0 Then ContinueLoop
        If GwAu3_Agent_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'ID') = GwAu3_Agent_GetMyID() Then ContinueLoop
        If GwAu3_Agent_GetDistance($l_ai_AgentArray[$l_i_Idx]) > $a_i_Range Then ContinueLoop
        For $l_i_SubIdx = 1 To $l_ai_AgentArray[0]
            If GwAu3_Agent_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'Allegiance') <> 3 Then ContinueLoop
            If GwAu3_Agent_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'HP') <= 0 Then ContinueLoop
            If GwAu3_Agent_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'ID') = GwAu3_Agent_GetMyID() Then ContinueLoop
            If GwAu3_Agent_GetDistance($l_ai_AgentArray[$l_i_SubIdx]) > $a_i_Range Then ContinueLoop
            $l_f_Distance = GwAu3_Agent_GetDistance($l_ai_AgentArray[$l_i_Idx], $l_ai_AgentArray[$l_i_SubIdx])
            $l_f_SumDistances += $l_f_Distance
        Next
        If $l_f_SumDistances < $l_f_LowestSum Then
            $l_f_LowestSum = $l_f_SumDistances
            $l_i_BestTarget = $l_ai_AgentArray[$l_i_Idx]
        EndIf
    Next
    Return $l_i_BestTarget
EndFunc   ;==>GetBestTarget