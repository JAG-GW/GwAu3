#include-once

#Region Module Constants
; Agent module specific constants
Global Const $AGENT_TYPE_LIVING = 0xDB
Global Const $AGENT_TYPE_GADGET = 0x200
Global Const $AGENT_TYPE_ITEM = 0x400

; Agent array constants
Global Const $AGENT_MAX_COPY = 256
Global Const $AGENT_STRUCT_SIZE = 0x1C0
#EndRegion Module Constants

Func GwAu3_AgentMod_ConvertID($aID)
	Select
		Case $aID = -2
			Return GwAu3_AgentMod_GetMyID()
		Case $aID = -1
			Return GwAu3_AgentMod_GetCurrentTarget()
		Case IsPtr($aID) <> 0
			Return GwAu3_Memory_Read($aID + 0x2C, 'long')
		Case IsDllStruct($aID) <> 0
			Return DllStructGetData($aID, 'ID')
		Case Else
			Return $aID
	EndSelect
EndFunc

Func GwAu3_AgentMod_GetAgentBase()
    Return $g_mAgentBase
EndFunc

Func GwAu3_AgentMod_GetMaxAgents()
    Return GwAu3_Memory_Read($g_mMaxAgents, 'dword')
EndFunc

Func GwAu3_AgentMod_GetMyID()
    Return GwAu3_Memory_Read($g_mMyID, 'dword')
EndFunc

Func GetMyID()
	Local $lOffset[5] = [0, 0x18, 0x2C, 0x680, 0x14]
	Local $lReturn = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc

Func GwAu3_AgentMod_GetCurrentTarget()
    Return GwAu3_Memory_Read($g_mCurrentTarget, 'dword')
EndFunc

Func GwAu3_AgentMod_GetAgentCopyCount()
    Return GwAu3_Memory_Read($g_mAgentCopyCount, 'dword')
EndFunc

Func GwAu3_AgentMod_GetAgentCopyBase()
    Return $g_mAgentCopyBase
EndFunc

Func GwAu3_AgentMod_GetLastTarget()
    Return $g_iLastTargetID
EndFunc

Func GwAu3_AgentMod_GetAgentPtr($aAgentID = -2)
	If IsPtr($aAgentID) Then Return $aAgentID
	Local $lOffset[3] = [0, 4 * GwAu3_AgentMod_ConvertID($aAgentID), 0]
	Local $lAgentStructAddress = GwAu3_Memory_ReadPtr($g_mAgentBase, $lOffset)
	Return $lAgentStructAddress[0]
EndFunc

#Region Agent Related
Func GwAu3_AgentMod_GetAgentInfo($aAgentID = -2, $aInfo = "")
    Local $lAgentPtr = GwAu3_AgentMod_GetAgentPtr($aAgentID)
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "vtable"
            Return GwAu3_Memory_Read($lAgentPtr, "ptr")
        Case "h0004"
            Return GwAu3_Memory_Read($lAgentPtr + 0x4, "dword")
        Case "h0008"
            Return GwAu3_Memory_Read($lAgentPtr + 0x8, "dword")
        Case "h000C"
            Return GwAu3_Memory_Read($lAgentPtr + 0xC, "dword")
        Case "h0010"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
        Case "Timer"
            Return GwAu3_Memory_Read($lAgentPtr + 0x14, "dword")
        Case "Timer2"
            Return GwAu3_Memory_Read($lAgentPtr + 0x18, "dword")
        Case "h0018"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1C, "dword[4]")
        Case "ID"
            Return GwAu3_Memory_Read($lAgentPtr + 0x2C, "long")
        Case "Z"
            Return GwAu3_Memory_Read($lAgentPtr + 0x30, "float")
        Case "Width1"
            Return GwAu3_Memory_Read($lAgentPtr + 0x34, "float")
        Case "Height1"
            Return GwAu3_Memory_Read($lAgentPtr + 0x38, "float")
        Case "Width2"
            Return GwAu3_Memory_Read($lAgentPtr + 0x3C, "float")
        Case "Height2"
            Return GwAu3_Memory_Read($lAgentPtr + 0x40, "float")
        Case "Width3"
            Return GwAu3_Memory_Read($lAgentPtr + 0x44, "float")
        Case "Height3"
            Return GwAu3_Memory_Read($lAgentPtr + 0x48, "float")
        Case "Rotation"
            Return GwAu3_Memory_Read($lAgentPtr + 0x4C, "float")
        Case "RotationCos"
            Return GwAu3_Memory_Read($lAgentPtr + 0x50, "float")
        Case "RotationSin"
            Return GwAu3_Memory_Read($lAgentPtr + 0x54, "float")
        Case "NameProperties"
            Return GwAu3_Memory_Read($lAgentPtr + 0x58, "dword")
        Case "Ground"
            Return GwAu3_Memory_Read($lAgentPtr + 0x5C, "dword")
        Case "h0060"
            Return GwAu3_Memory_Read($lAgentPtr + 0x60, "dword")
        Case "TerrainNormalX"
            Return GwAu3_Memory_Read($lAgentPtr + 0x64, "float")
        Case "TerrainNormalY"
            Return GwAu3_Memory_Read($lAgentPtr + 0x68, "float")
        Case "TerrainNormalZ"
            Return GwAu3_Memory_Read($lAgentPtr + 0x6C, "dword")
        Case "h0070"
            Return GwAu3_Memory_Read($lAgentPtr + 0x70, "byte[4]")
        Case "X"
            Return GwAu3_Memory_Read($lAgentPtr + 0x74, "float")
        Case "Y"
            Return GwAu3_Memory_Read($lAgentPtr + 0x78, "float")
        Case "Plane"
            Return GwAu3_Memory_Read($lAgentPtr + 0x7C, "dword")
        Case "h0080"
            Return GwAu3_Memory_Read($lAgentPtr + 0x80, "byte[4]")
        Case "NameTagX"
            Return GwAu3_Memory_Read($lAgentPtr + 0x84, "float")
        Case "NameTagY"
            Return GwAu3_Memory_Read($lAgentPtr + 0x88, "float")
        Case "NameTagZ"
            Return GwAu3_Memory_Read($lAgentPtr + 0x8C, "float")
        Case "VisualEffects"
            Return GwAu3_Memory_Read($lAgentPtr + 0x90, "short")
        Case "h0092"
            Return GwAu3_Memory_Read($lAgentPtr + 0x92, "short")
        Case "h0094"
            Return GwAu3_Memory_Read($lAgentPtr + 0x94, "dword[2]")


        Case "Type"
            Return GwAu3_Memory_Read($lAgentPtr + 0x9C, "long")
		Case "IsItemType"
			Return GwAu3_Memory_Read($lAgentPtr + 0x9C, "long") = 0x400
		Case "IsGadgetType"
			Return GwAu3_Memory_Read($lAgentPtr + 0x9C, "long") = 0x200
		Case "IsLivingType"
			Return GwAu3_Memory_Read($lAgentPtr + 0x9C, "long") = 0xDB


        Case "MoveX"
            Return GwAu3_Memory_Read($lAgentPtr + 0xA0, "float")
        Case "MoveY"
            Return GwAu3_Memory_Read($lAgentPtr + 0xA4, "float")
        Case "h00A8"
            Return GwAu3_Memory_Read($lAgentPtr + 0xA8, "dword")
        Case "RotationCos2"
            Return GwAu3_Memory_Read($lAgentPtr + 0xAC, "float")
        Case "RotationSin2"
            Return GwAu3_Memory_Read($lAgentPtr + 0xB0, "float")
        Case "h00B4"
            Return GwAu3_Memory_Read($lAgentPtr + 0xB4, "dword[4]")

        Case "Owner"
            Return GwAu3_Memory_Read($lAgentPtr + 0xC4, "long")
		Case "CanPickUp"
			If GwAu3_Memory_Read($lAgentPtr + 0x9C, "long") = 0x400 Then
				If GwAu3_Memory_Read($lAgentPtr + 0xC4, "long") = 0 Or GwAu3_Memory_Read($lAgentPtr + 0xC4, "long") = GetMyID() Then Return True
			EndIf
			Return False

        Case "ItemID"
            Return GwAu3_Memory_Read($lAgentPtr + 0xC8, "dword")
        Case "ExtraType"
            Return GwAu3_Memory_Read($lAgentPtr + 0xCC, "dword")
        Case "GadgetID"
            Return GwAu3_Memory_Read($lAgentPtr + 0xD0, "dword")
        Case "h00D4"
            Return GwAu3_Memory_Read($lAgentPtr + 0xD4, "dword[3]")
        Case "AnimationType"
            Return GwAu3_Memory_Read($lAgentPtr + 0xE0, "float")
        Case "h00E4"
            Return GwAu3_Memory_Read($lAgentPtr + 0xE4, "dword[2]")
        Case "AttackSpeed"
            Return GwAu3_Memory_Read($lAgentPtr + 0xEC, "float")
        Case "AttackSpeedModifier"
            Return GwAu3_Memory_Read($lAgentPtr + 0xF0, "float")
        Case "PlayerNumber"
            Return GwAu3_Memory_Read($lAgentPtr + 0xF4, "short")
        Case "AgentModelType"
            Return GwAu3_Memory_Read($lAgentPtr + 0xF6, "short")
		Case "TransmogNpcId"
            Return GwAu3_Memory_Read($lAgentPtr + 0xF8, "dword")
        Case "Equipment"
            Return GwAu3_Memory_Read($lAgentPtr + 0xFC, "ptr")
        Case "h0100"
            Return GwAu3_Memory_Read($lAgentPtr + 0x100, "dword")
        Case "Tags"
            Return GwAu3_Memory_Read(GwAu3_Memory_Read($lAgentPtr + 0x104, "ptr"), "short")
        Case "h0108"
            Return GwAu3_Memory_Read($lAgentPtr + 0x108, "short")
        Case "Primary"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10A, "byte")
        Case "Secondary"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10B, "byte")
        Case "Level"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10C, "byte")
        Case "Team"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10D, "byte")
        Case "h010E"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10E, "byte[2]")
        Case "h0110"
            Return GwAu3_Memory_Read($lAgentPtr + 0x110, "dword")
        Case "EnergyRegen"
            Return GwAu3_Memory_Read($lAgentPtr + 0x114, "float")
        Case "Overcast"
            Return GwAu3_Memory_Read($lAgentPtr + 0x118, "float")
        Case "EnergyPercent"
            Return GwAu3_Memory_Read($lAgentPtr + 0x11C, "float")
        Case "MaxEnergy"
            Return GwAu3_Memory_Read($lAgentPtr + 0x120, "dword")
		Case "CurrentEnergy"
			Return GwAu3_Memory_Read($lAgentPtr + 0x11C, "float") * GwAu3_Memory_Read($lAgentPtr + 0x120, "dword")
        Case "h0124"
            Return GwAu3_Memory_Read($lAgentPtr + 0x124, "dword")
        Case "HPPips"
            Return GwAu3_Memory_Read($lAgentPtr + 0x128, "float")
        Case "h012C"
            Return GwAu3_Memory_Read($lAgentPtr + 0x12C, "dword")
        Case "HP"
            Return GwAu3_Memory_Read($lAgentPtr + 0x130, "float")
        Case "MaxHP"
            Return GwAu3_Memory_Read($lAgentPtr + 0x134, "dword")
		Case "CurrentHP"
			Return GwAu3_Memory_Read($lAgentPtr + 0x130, "float") * GwAu3_Memory_Read($lAgentPtr + 0x134, "dword")

        Case "Effects"
            Return GwAu3_Memory_Read($lAgentPtr + 0x138, "dword")
		Case "EffectCount"
            Local $lAgentID = GwAu3_AgentMod_ConvertID($aAgentID)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x508]
            Local $lAgentEffectsBasePtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x510]
            Local $lAgentEffectsCount = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)

            If $lAgentEffectsBasePtr[1] = 0 Or $lAgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $lAgentEffectsCount[1] - 1
                Local $lAgentEffectsPtr = $lAgentEffectsBasePtr[1] + ($i * 0x24)
                Local $lCurrentAgentID = GwAu3_Memory_Read($lAgentEffectsPtr, "dword")

                If $lCurrentAgentID = $lAgentID Then
                    Local $lEffectArrayPtr = $lAgentEffectsPtr + 0x14
                    Return GwAu3_Memory_Read($lEffectArrayPtr + 0x8, "long")
                EndIf
            Next
            Return 0
        Case "BuffCount"
            Local $lAgentID = GwAu3_AgentMod_ConvertID($aAgentID)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x508]
            Local $lAgentEffectsBasePtr = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x510]
            Local $lAgentEffectsCount = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)

            If $lAgentEffectsBasePtr[1] = 0 Or $lAgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $lAgentEffectsCount[1] - 1
                Local $lAgentEffectsPtr = $lAgentEffectsBasePtr[1] + ($i * 0x24)
                Local $lCurrentAgentID = GwAu3_Memory_Read($lAgentEffectsPtr, "dword")

                If $lCurrentAgentID = $lAgentID Then
                    Local $lBuffArrayPtr = $lAgentEffectsPtr + 0x4
                    Return GwAu3_Memory_Read($lBuffArrayPtr + 0x8, "long")
                EndIf
            Next

            Return 0


		Case "IsBleeding"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0001) > 0
		Case "IsConditioned"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0002) > 0
		Case "IsCrippled"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x000A) = 0xA
		Case "IsDead"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0010) > 0
		Case "IsDeepWounded"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0020) > 0
		Case "IsPoisoned"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0040) > 0
		Case "IsEnchanted"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0080) > 0
		Case "IsDegenHexed"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0400) > 0
		Case "IsHexed"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x0800) > 0
		Case "IsWeaponSpelled"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x138, "dword"), 0x8000) > 0

        Case "h013C"
            Return GwAu3_Memory_Read($lAgentPtr + 0x13C, "dword")
        Case "Hex"
            Return GwAu3_Memory_Read($lAgentPtr + 0x140, "byte")
        Case "h0141"
            Return GwAu3_Memory_Read($lAgentPtr + 0x141, "byte[19]")

        Case "ModelState"
            Return GwAu3_Memory_Read($lAgentPtr + 0x154, "dword")
		Case "IsKnockedDown"
			Return GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 0x450
		Case "IsMoving"
			If GwAu3_Memory_Read($lAgentPtr + 0xA0, "float") <> 0 Or GwAu3_Memory_Read($lAgentPtr + 0xA4, "float") <> 0 Then Return True
			If GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 12 Or GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 76 Or GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 204 Then Return True
			Return False
		Case "IsAttacking"
			If GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 0x60 Or GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 0x440 Or GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 0x460 Then Return True
			Return False
		Case "IsCasting"
			If GwAu3_Memory_Read($lAgentPtr + 0x1B4, "short") <> 0 Then Return True
			If GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 0x41 Or GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 0x245 Then Return True
			Return False
		Case "IsIdle"
			If GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 68 Or GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 64 Or GwAu3_Memory_Read($lAgentPtr + 0x154, "dword") = 100 Then Return True
			Return False

        Case "TypeMap"
            Return GwAu3_Memory_Read($lAgentPtr + 0x158, "dword")
		Case "InCombatStance"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x000001) > 0
		Case "HasQuest"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x000002) > 0
		Case "IsDeadByTypeMap"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x000008) > 0
		Case "IsFemale"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x000200) > 0
		Case "HasBossGlow"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x000400) > 0
		Case "IsHidingCap"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x001000) > 0
		Case "CanBeViewedInPartyWindow"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x20000) > 0
		Case "IsSpawned"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x040000) > 0
		Case "IsBeingObserved"
			Return BitAND(GwAu3_Memory_Read($lAgentPtr + 0x158, "dword"), 0x400000) > 0

        Case "h015C"
            Return GwAu3_Memory_Read($lAgentPtr + 0x15C, "dword[4]")
        Case "InSpiritRange"
            Return GwAu3_Memory_Read($lAgentPtr + 0x16C, "dword")
		Case "VisibleEffectsPtr"
            Return GwAu3_Memory_Read($lAgentPtr + 0x170, "ptr")
        Case "VisibleEffects"
            Return GwAu3_Memory_Read($lAgentPtr + 0x170, "dword")
        Case "VisibleEffectsID"
            Return GwAu3_Memory_Read($lAgentPtr + 0x174, "dword")
        Case "VisibleEffectsHasEnded"
            Return GwAu3_Memory_Read($lAgentPtr + 0x178, "dword")
        Case "h017C"
            Return GwAu3_Memory_Read($lAgentPtr + 0x17C, "dword")

        Case "LoginNumber"
            Return GwAu3_Memory_Read($lAgentPtr + 0x180, "dword")
		Case "IsPlayer"
			Return GwAu3_Memory_Read($lAgentPtr + 0x180, "dword") <> 0
		Case "IsNPC"
			Return GwAu3_Memory_Read($lAgentPtr + 0x180, "dword") = 0

        Case "AnimationSpeed"
            Return GwAu3_Memory_Read($lAgentPtr + 0x184, "float")
        Case "AnimationCode"
            Return GwAu3_Memory_Read($lAgentPtr + 0x188, "dword")
        Case "AnimationId"
            Return GwAu3_Memory_Read($lAgentPtr + 0x18C, "dword")
        Case "h0190"
            Return GwAu3_Memory_Read($lAgentPtr + 0x190, "byte[32]")
        Case "LastStrike"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1B0, "byte")
        Case "Allegiance"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1B1, "byte")
        Case "WeaponType"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1B2, "short")
        Case "Skill"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1B4, "short")
        Case "h01B6"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1B6, "short")
        Case "WeaponItemType"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1B8, "byte")
        Case "OffhandItemType"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1B9, "byte")
        Case "WeaponItemId"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1BA, "short")
        Case "OffhandItemId"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1BC, "short")

		Case "Name"
			Return 0 ;in progress
		Case Else
			Return 0
	EndSwitch

    Return 0
EndFunc

Func GwAu3_AgentMod_GetAgentEquimentInfo($aAgentID = -2, $aInfo = "")
	Local $lAgentPtr = GwAu3_AgentMod_GetAgentInfo($aAgentID, "Equipment")
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0
    Switch $aInfo
        Case "vtable"
            Return GwAu3_Memory_Read($lAgentPtr, "dword")
		Case "h0004"
			Return GwAu3_Memory_Read($lAgentPtr + 0x4, "dword")
		Case "h0008"
			Return GwAu3_Memory_Read($lAgentPtr + 0x8, "dword")
		Case "h000C"
			Return GwAu3_Memory_Read($lAgentPtr + 0xC, "dword")
		Case "LeftHandData"
			Return GwAu3_Memory_Read($lAgentPtr + 0x10, "Ptr")
		Case "RightHandData"
			Return GwAu3_Memory_Read($lAgentPtr + 0x14, "Ptr")
		Case "h0018"
			Return GwAu3_Memory_Read($lAgentPtr + 0x18, "dword")
		Case "ShieldData"
			Return GwAu3_Memory_Read($lAgentPtr + 0x1C, "Ptr")


		Case "Weapon_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x24, "dword")
		Case "Weapon_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x28, "byte")
		Case "Weapon_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x29, "byte")
		Case "Weapon_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x2A, "byte")
		Case "Weapon_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x2B, "byte")
		Case "Weapon_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x2C, "dword")
		Case "Weapon_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0x30, "dword")


		Case "Offhand_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x34, "dword")
		Case "Offhand_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x38, "byte")
		Case "Offhand_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x39, "byte")
		Case "Offhand_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x3A, "byte")
		Case "Offhand_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x3B, "byte")
		Case "Offhand_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x3C, "dword")
		Case "Offhand_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0x40, "dword")

		Case "Chest_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x44, "dword")
		Case "Chest_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x48, "byte")
		Case "Chest_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x49, "byte")
		Case "Chest_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x4A, "byte")
		Case "Chest_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x4B, "byte")
		Case "Chest_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x4C, "dword")
		Case "Chest_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0x50, "dword")

		Case "Leg_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x54, "dword")
		Case "Leg_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x58, "byte")
		Case "Leg_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x59, "byte")
		Case "Leg_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x5A, "byte")
		Case "Leg_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x5B, "byte")
		Case "Leg_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x5C, "dword")
		Case "Leg_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0x60, "dword")

		Case "Head_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x64, "dword")
		Case "Head_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x68, "byte")
		Case "Head_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x69, "byte")
		Case "Head_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x6A, "byte")
		Case "Head_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x6B, "byte")
		Case "Head_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x6C, "dword")
		Case "Head_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0x70, "dword")

		Case "Feet_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x74, "dword")
		Case "Feet_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x78, "byte")
		Case "Feet_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x79, "byte")
		Case "Feet_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x7A, "byte")
		Case "Feet_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x7B, "byte")
		Case "Feet_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x7C, "dword")
		Case "Feet_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0x80, "dword")

		Case "Hands_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x84, "dword")
		Case "Hands_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x88, "byte")
		Case "Hands_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x89, "byte")
		Case "Hands_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x8A, "byte")
		Case "Hands_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x8B, "byte")
		Case "Hands_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x8C, "dword")
		Case "Hands_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0x90, "dword")

		Case "CostumeBody_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0x94, "dword")
		Case "CostumeBody_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0x98, "byte")
		Case "CostumeBody_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0x99, "byte")
		Case "CostumeBody_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0x9A, "byte")
		Case "CostumeBody_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0x9B, "byte")
		Case "CostumeBody_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0x9C, "dword")
		Case "CostumeBody_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0xA0, "dword")

		Case "CostumeHead_ModelFileID"
			Return GwAu3_Memory_Read($lAgentPtr + 0xA4, "dword")
		Case "CostumeHead_Type"
			Return GwAu3_Memory_Read($lAgentPtr + 0xA8, "byte")
		Case "CostumeHead_Dye1"
			Return GwAu3_Memory_Read($lAgentPtr + 0xA9, "byte")
		Case "CostumeHead_Dye2"
			Return GwAu3_Memory_Read($lAgentPtr + 0xAA, "byte")
		Case "CostumeHead_Dye3"
			Return GwAu3_Memory_Read($lAgentPtr + 0xAB, "byte")
		Case "CostumeHead_Value"
			Return GwAu3_Memory_Read($lAgentPtr + 0xAC, "dword")
		Case "CostumeHead_Interaction"
			Return GwAu3_Memory_Read($lAgentPtr + 0xB0, "dword")

		Case "ItemID_Weapon"
			Return GwAu3_Memory_Read($lAgentPtr + 0xB4, "dword")
		Case "ItemID_Offhand"
			Return GwAu3_Memory_Read($lAgentPtr + 0xB8, "dword")
		Case "ItemID_Chest"
			Return GwAu3_Memory_Read($lAgentPtr + 0xBC, "dword")
		Case "ItemID_Legs"
			Return GwAu3_Memory_Read($lAgentPtr + 0xC0, "dword")
		Case "ItemID_Head"
			Return GwAu3_Memory_Read($lAgentPtr + 0xC4, "dword")
		Case "ItemID_Feet"
			Return GwAu3_Memory_Read($lAgentPtr + 0xC8, "dword")
		Case "ItemID_Hands"
			Return GwAu3_Memory_Read($lAgentPtr + 0xCC, "dword")
		Case "ItemID_CostumeBody"
			Return GwAu3_Memory_Read($lAgentPtr + 0xD0, "dword")
		Case "ItemID_CostumeHead"
			Return GwAu3_Memory_Read($lAgentPtr + 0xD4, "dword")
	EndSwitch
	Return 0
EndFunc

Func GwAu3_AgentMod_GetAgentVisibleEffectInfo($aAgentID = -2, $aInfo = "")
	Local $lAgentPtr = GwAu3_AgentMod_GetAgentInfo($aAgentID, "VisibleEffectsPtr")
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "" ; dummy case to avoid syntax error
            Sleep(100)
	EndSwitch

	Return 0
EndFunc

Func GwAu3_AgentMod_GetAgentArray($aType = 0)
    Local $lMaxAgents = GwAu3_AgentMod_GetMaxAgents()
    If $lMaxAgents <= 0 Then Return

	Local $lAgentArray[$lMaxAgents + 1]
    Local $lPtr, $lCount = 0
    Local $lAgentBasePtr = GwAu3_Memory_Read($g_mAgentBase)
    Local $lAgentPtrBuffer = DllStructCreate("ptr[" & $lMaxAgents & "]")

    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, "ptr", $lAgentBasePtr, "struct*", $lAgentPtrBuffer, "ulong_ptr", 4 * $lMaxAgents, "ulong_ptr*", 0)

    For $i = 1 To $lMaxAgents
        $lPtr = DllStructGetData($lAgentPtrBuffer, 1, $i)
        If $lPtr = 0 Then ContinueLoop

        If $aType <> 0 Then
            If GwAu3_AgentMod_GetAgentInfo($lPtr, "Type") <> $aType Then ContinueLoop
        EndIf

        $lCount += 1
        $lAgentArray[$lCount] = $lPtr
    Next

    $lAgentArray[0] = $lCount
    ReDim $lAgentArray[$lCount + 1]

    Return $lAgentArray
EndFunc

;~ Func GwAu3_AgentMod_GetAgentArray()
;~     Local $lAgentArray = GwAu3_Memory_ReadArray($mAgentBase, 0x8)
;~     Return $lAgentArray
;~ EndFunc
#EndRegion Agent Related

Func GwAu3_AgentMod_GetDistance($aAgent1ID, $aAgent2ID = 0)
    If $aAgent2ID = 0 Then $aAgent2ID = GwAu3_AgentMod_GetMyID()

    Local $lX1 = GwAu3_AgentMod_GetAgentInfo($aAgent1ID, "X")
    Local $lY1 = GwAu3_AgentMod_GetAgentInfo($aAgent1ID, "Y")
    Local $lX2 = GwAu3_AgentMod_GetAgentInfo($aAgent2ID, "X")
    Local $lY2 = GwAu3_AgentMod_GetAgentInfo($aAgent2ID, "Y")

    Return Sqrt(($lX1 - $lX2)^2 + ($lY1 - $lY2)^2)
EndFunc

#Region Effect Related
Func GwAu3_AgentMod_GetAgentEffectArrayInfo($aAgentID = -2, $aInfo = "")
    Local $lPtr = GwAu3_OtherMod_GetWorldInfo("AgentEffectsArray")
    Local $lSize = GwAu3_OtherMod_GetWorldInfo("AgentEffectsArraySize")
    Local $lAgentPtr = 0

    For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x24)
        If GwAu3_Memory_Read($lAgentEffectsPtr, "dword") = GwAu3_AgentMod_ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "AgentID"
            Return GwAu3_Memory_Read($lAgentPtr, "dword")
        Case "BuffArray"
            Return GwAu3_Memory_Read($lAgentPtr + 0x4, "ptr")
        Case "BuffArraySize"
            Return GwAu3_Memory_Read($lAgentPtr + 0x4 + 0x8, "long")
        Case "EffectArray"
            Return GwAu3_Memory_Read($lAgentPtr + 0x14, "ptr")
        Case "EffectArraySize"
            Return GwAu3_Memory_Read($lAgentPtr + 0x14 + 0x8, "long")
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GwAu3_AgentMod_GetAgentEffectInfo($aAgentID = -2, $aSkillID = 0, $aInfo = "")
    Local $lEffectArrayPtr = GwAu3_AgentMod_GetAgentEffectArrayInfo($aAgentID, "EffectArray")
    Local $lEffectCount = GwAu3_AgentMod_GetAgentEffectArrayInfo($aAgentID, "EffectArraySize")

    If $lEffectArrayPtr = 0 Or $lEffectCount = 0 Then Return 0

    Local $lEffectPtr = 0
    For $j = 0 To $lEffectCount - 1
        Local $lCurrentPtr = $lEffectArrayPtr + ($j * 0x18)
        Local $lCurrentSkillID = GwAu3_Memory_Read($lCurrentPtr, "long")

        If $lCurrentSkillID = $aSkillID Then
            $lEffectPtr = $lCurrentPtr
            ExitLoop
        EndIf
    Next

    If $lEffectPtr = 0 Then Return 0
    If $aInfo = "" Then Return $lEffectPtr

    Switch $aInfo
;~         Case "SkillID"
;~             Return GwAu3_Memory_Read($lEffectPtr, "long")
        Case "AttributeLevel"
            Return GwAu3_Memory_Read($lEffectPtr + 0x4, "dword")
        Case "EffectID"
            Return GwAu3_Memory_Read($lEffectPtr + 0x8, "long")
        Case "CasterID" ; maintained enchantment
            Return GwAu3_Memory_Read($lEffectPtr + 0xC, "dword")
        Case "Duration"
            Return GwAu3_Memory_Read($lEffectPtr + 0x10, "float")
        Case "Timestamp"
            Return GwAu3_Memory_Read($lEffectPtr + 0x14, "dword")
        Case "TimeElapsed"
            Local $lTimestamp = GwAu3_Memory_Read($lEffectPtr + 0x14, "dword")
            Return _SkillMod_GetSkillTimer() - $lTimestamp
        Case "TimeRemaining"
            Local $lTimestamp = GwAu3_Memory_Read($lEffectPtr + 0x14, "dword")
            Local $lDuration = GwAu3_Memory_Read($lEffectPtr + 0x10, "float")
            Return $lDuration * 1000 - (_SkillMod_GetSkillTimer() - $lTimestamp)
        Case "HasEffect"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GwAu3_AgentMod_GetAgentBuffInfo($aAgentID = -2, $aSkillID = 0, $aInfo = "")
    Local $lBuffArrayPtr = GwAu3_AgentMod_GetAgentEffectArrayInfo($aAgentID, "BuffArray")
    Local $lBuffCount = GwAu3_AgentMod_GetAgentEffectArrayInfo($aAgentID, "BuffArraySize")

    If $lBuffArrayPtr = 0 Or $lBuffCount = 0 Then Return 0

    Local $lBuffPtr = 0
    For $j = 0 To $lBuffCount - 1
        Local $lCurrentPtr = $lBuffArrayPtr + ($j * 0x10)
        Local $lCurrentSkillID = GwAu3_Memory_Read($lCurrentPtr, "long")

        If $lCurrentSkillID = $aSkillID Then
            $lBuffPtr = $lCurrentPtr
            ExitLoop
        EndIf
    Next

    If $lBuffPtr = 0 Then Return 0
    If $aInfo = "" Then Return $lBuffPtr

    Switch $aInfo
;~         Case "SkillID"
;~             Return GwAu3_Memory_Read($lBuffPtr, "long")
        Case "h0004"
            Return GwAu3_Memory_Read($lBuffPtr + 0x4, "dword")
        Case "BuffID"
            Return GwAu3_Memory_Read($lBuffPtr + 0x8, "long")
        Case "TargetAgentID"
            Return GwAu3_Memory_Read($lBuffPtr + 0xC, "dword")
        Case "HasBuff"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion

#Region Related NPC Info
;~ TIPS: $aModelFileID = Player number of an npc
Func GwAu3_AgentMod_GetNpcInfo($aModelFileID = 0, $aInfo = "")
	Local $lPtr = GwAu3_OtherMod_GetWorldInfo("NpcArray")
	Local $lSize = GwAu3_OtherMod_GetWorldInfo("NpcArraySize")
	Local $lAgentPtr = 0

	For $i = 0 To $lSize
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x30)
        If GwAu3_Memory_Read($lAgentEffectsPtr, "dword") = $aModelFileID Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

	If $lAgentPtr = 0 Then Return 0

	Switch $aInfo
		Case "ModelFileID"
            Return GwAu3_Memory_Read($lAgentPtr, "dword")
        Case "Scale"
            Return GwAu3_Memory_Read($lAgentPtr + 0x8, "dword")
		Case "Sex"
            Return GwAu3_Memory_Read($lAgentPtr + 0xC, "dword")
		Case "NpcFlags"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
		Case "Primary"
            Return GwAu3_Memory_Read($lAgentPtr + 0x14, "dword")
		Case "DefaultLevel", "Level"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1C, "byte")
		Case "IsHenchman"
			Local $flags = GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x10) <> 0
		Case "IsHero"
			Local $flags = GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x20) <> 0
		Case "IsSpirit"
			Local $flags = GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x4000) <> 0
		Case "IsMinion"
			Local $flags = GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x100) <> 0
		Case "IsPet"
			Local $flags = GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
            Return BitAND($flags, 0xD) <> 0
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion

#Region Related Player Info
Func GwAu3_AgentMod_GetPlayerInfo($aAgentID = 0, $aInfo = "")
    Local $lPtr = GwAu3_OtherMod_GetWorldInfo("PlayerArray")
    Local $lSize = GwAu3_OtherMod_GetWorldInfo("PlayerArraySize")
    Local $lAgentPtr = 0

    For $i = 1 To $lSize - 1
        Local $lAgentEffectsPtr = $lPtr + ($i * 0x4C)
        If GwAu3_Memory_Read($lAgentEffectsPtr, "dword") = GwAu3_AgentMod_ConvertID($aAgentID) Then
            $lAgentPtr = $lAgentEffectsPtr
            ExitLoop
        EndIf
    Next

    If $lAgentPtr = 0 Then Return 0

    Switch $aInfo
        Case "AgentID"
            Return GwAu3_Memory_Read($lAgentPtr, "dword")
        Case "AppearanceBitmap"
            Return GwAu3_Memory_Read($lAgentPtr + 0x10, "dword")
        Case "Flags"
            Return GwAu3_Memory_Read($lAgentPtr + 0x14, "dword")
        Case "Primary"
            Return GwAu3_Memory_Read($lAgentPtr + 0x18, "dword")
        Case "Secondary"
            Return GwAu3_Memory_Read($lAgentPtr + 0x1C, "dword")
        Case "Name"
;~             Return GwAu3_Memory_Read($lAgentPtr + 0x24, "wchar[20]")
            Local $lName = GwAu3_Memory_Read($lAgentPtr + 0x24, "ptr")
            Return GwAu3_Memory_Read($lName, "wchar[20]")
        Case "PartLeaderPlayerNumber"
            Return GwAu3_Memory_Read($lAgentPtr + 0x2C, "dword")
        Case "ActiveTitle"
            Return GwAu3_Memory_Read($lAgentPtr + 0x30, "dword")
        Case "PlayerNumber"
            Return GwAu3_Memory_Read($lAgentPtr + 0x34, "dword")
        Case "PartySize"
            Return GwAu3_Memory_Read($lAgentPtr + 0x38, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc

Func GwAu3_AgentMod_GetPlayerLogInfo($aInfo = "")
    Local $lPtr = GwAu3_OtherMod_GetWorldInfo("PlayerArray")
    If $lPtr = 0 Then Return 0

    Switch $aInfo
        Case "LastPlayerHeroAdded"
            Return GwAu3_Memory_Read($lPtr + 0x2C, "dword")
        Case "LastPartyHenchmenCount"
            Local $lHenchmenCnt = GwAu3_Memory_Read($lPtr + 0x38, "dword")
            $lHenchmenCnt = $lHenchmenCnt - ($lHenchmenCnt <> 0)
        Case "LastPlayerOut"
            Local $lLogPtr = GwAu3_Memory_Read($lPtr + 0x3C, "ptr")
            If $lLogPtr = 0 Then Return 0
            Local $lZoneCnt = GwAu3_Memory_Read($lPtr + 0x44, "dword")
            Return GwAu3_Memory_Read($lLogPtr + (($lZoneCnt - 1) * 0x4))
        Case "LogCapacity"
            Return GwAu3_Memory_Read($lPtr + 0x40, "dword")
        Case "ZoneCount"
            Return GwAu3_Memory_Read($lPtr + 0x44, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion Related Player Info
