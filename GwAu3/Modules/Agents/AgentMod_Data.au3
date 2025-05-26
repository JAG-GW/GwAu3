#include-once
#include "AgentMod_Initialize.au3"

Func ConvertID($aID)
	Select
		Case $aID = -2
			Return GetMyID()
		Case $aID = -1
			Return GetCurrentTargetID()
		Case IsPtr($aID) <> 0
			Return MemoryRead($aID + 0x2C, 'long')
		Case IsDllStruct($aID) <> 0
			Return DllStructGetData($aID, 'ID')
		Case Else
			Return $aID
	EndSelect
EndFunc   ;==>ConvertID

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetAgentBase
; Description ...: Returns the base address of the agent array
; Syntax.........: _AgentMod_GetAgentBase()
; Parameters ....: None
; Return values .: Pointer to agent array base
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Used for direct memory access to agent data
; Related .......: _AgentMod_GetMaxAgents
;============================================================================================
Func _AgentMod_GetAgentBase()
    Return $g_mAgentBase
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetMaxAgents
; Description ...: Returns the maximum number of agents
; Syntax.........: _AgentMod_GetMaxAgents()
; Parameters ....: None
; Return values .: Maximum number of agents
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Used to determine array bounds when iterating agents
; Related .......: _AgentMod_GetAgentBase
;============================================================================================
Func _AgentMod_GetMaxAgents()
    Return MemoryRead($g_mMaxAgents, 'dword')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetMyID
; Description ...: Returns the player's agent ID
; Syntax.........: _AgentMod_GetMyID()
; Parameters ....: None
; Return values .: Player's agent ID
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Essential for identifying the player agent
; Related .......: _AgentMod_GetCurrentTarget
;============================================================================================
Func _AgentMod_GetMyID()
    Return MemoryRead($g_mMyID, 'dword')
EndFunc

Func GetMyID()
	Local $lOffset[5] = [0, 0x18, 0x2C, 0x680, 0x14]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetMyID

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetCurrentTarget
; Description ...: Returns the current target agent ID
; Syntax.........: _AgentMod_GetCurrentTarget()
; Parameters ....: None
; Return values .: Current target agent ID, 0 if no target
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Updates when player changes target
; Related .......: _AgentMod_GetMyID, _AgentMod_ChangeTarget
;============================================================================================
Func _AgentMod_GetCurrentTarget()
    Return MemoryRead($g_mCurrentTarget, 'dword')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetAgentCopyCount
; Description ...: Returns the number of agents in the copy array
; Syntax.........: _AgentMod_GetAgentCopyCount()
; Parameters ....: None
; Return values .: Number of copied agents
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Updated after calling MakeAgentArray
; Related .......: _AgentMod_GetAgentCopyBase, _AgentMod_MakeAgentArray
;============================================================================================
Func _AgentMod_GetAgentCopyCount()
    Return MemoryRead($g_mAgentCopyCount, 'dword')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetAgentCopyBase
; Description ...: Returns the base address of the agent copy array
; Syntax.........: _AgentMod_GetAgentCopyBase()
; Parameters ....: None
; Return values .: Pointer to agent copy array base
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Contains snapshot of agent data
;                  - Updated by MakeAgentArray command
; Related .......: _AgentMod_GetAgentCopyCount, _AgentMod_MakeAgentArray
;============================================================================================
Func _AgentMod_GetAgentCopyBase()
    Return $g_mAgentCopyBase
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetLastTarget
; Description ...: Returns the last target ID set
; Syntax.........: _AgentMod_GetLastTarget()
; Parameters ....: None
; Return values .: Last target agent ID
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Useful for tracking target changes
; Related .......: _AgentMod_ChangeTarget
;============================================================================================
Func _AgentMod_GetLastTarget()
    Return $g_iLastTargetID
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetAgentPtr
; Description ...: Returns a pointer to an agent's data structure
; Syntax.........: _AgentMod_GetAgentPtr($aAgentID)
; Parameters ....: $aAgentID - ID of the agent
; Return values .: Pointer to agent data structure, 0 if invalid
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Calculates pointer from agent base and ID
;                  - Each agent structure is indexed in the array
; Related .......: _AgentMod_GetAgentInfo
;============================================================================================
Func GetAgentPtr($aAgentID = -2)
	If IsPtr($aAgentID) Then Return $aAgentID
	Local $lOffset[3] = [0, 4 * ConvertID($aAgentID), 0]
	Local $lAgentStructAddress = MemoryReadPtr($g_mAgentBase, $lOffset)
	Return $lAgentStructAddress[0]
EndFunc   ;==>GetAgentPtr

#Region Agent Related

Func GetAgentInfo($aAgentID = -2, $aInfo = "")
    Local $lAgentPtr = GetAgentPtr($aAgentID)
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "vtable"
            Return MemoryRead($lAgentPtr, "ptr")
        Case "h0004"
            Return MemoryRead($lAgentPtr + 0x4, "dword")
        Case "h0008"
            Return MemoryRead($lAgentPtr + 0x8, "dword")
        Case "h000C"
            Return MemoryRead($lAgentPtr + 0xC, "dword")
        Case "h0010"
            Return MemoryRead($lAgentPtr + 0x10, "dword")
        Case "Timer"
            Return MemoryRead($lAgentPtr + 0x14, "dword")
        Case "Timer2"
            Return MemoryRead($lAgentPtr + 0x18, "dword")
        Case "h0018"
            Return MemoryRead($lAgentPtr + 0x1C, "dword[4]")
        Case "ID"
            Return MemoryRead($lAgentPtr + 0x2C, "long")
        Case "Z"
            Return MemoryRead($lAgentPtr + 0x30, "float")
        Case "Width1"
            Return MemoryRead($lAgentPtr + 0x34, "float")
        Case "Height1"
            Return MemoryRead($lAgentPtr + 0x38, "float")
        Case "Width2"
            Return MemoryRead($lAgentPtr + 0x3C, "float")
        Case "Height2"
            Return MemoryRead($lAgentPtr + 0x40, "float")
        Case "Width3"
            Return MemoryRead($lAgentPtr + 0x44, "float")
        Case "Height3"
            Return MemoryRead($lAgentPtr + 0x48, "float")
        Case "Rotation"
            Return MemoryRead($lAgentPtr + 0x4C, "float")
        Case "RotationCos"
            Return MemoryRead($lAgentPtr + 0x50, "float")
        Case "RotationSin"
            Return MemoryRead($lAgentPtr + 0x54, "float")
        Case "NameProperties"
            Return MemoryRead($lAgentPtr + 0x58, "dword")
        Case "Ground"
            Return MemoryRead($lAgentPtr + 0x5C, "dword")
        Case "h0060"
            Return MemoryRead($lAgentPtr + 0x60, "dword")
        Case "TerrainNormalX"
            Return MemoryRead($lAgentPtr + 0x64, "float")
        Case "TerrainNormalY"
            Return MemoryRead($lAgentPtr + 0x68, "float")
        Case "TerrainNormalZ"
            Return MemoryRead($lAgentPtr + 0x6C, "dword")
        Case "h0070"
            Return MemoryRead($lAgentPtr + 0x70, "byte[4]")
        Case "X"
            Return MemoryRead($lAgentPtr + 0x74, "float")
        Case "Y"
            Return MemoryRead($lAgentPtr + 0x78, "float")
        Case "Plane"
            Return MemoryRead($lAgentPtr + 0x7C, "dword")
        Case "h0080"
            Return MemoryRead($lAgentPtr + 0x80, "byte[4]")
        Case "NameTagX"
            Return MemoryRead($lAgentPtr + 0x84, "float")
        Case "NameTagY"
            Return MemoryRead($lAgentPtr + 0x88, "float")
        Case "NameTagZ"
            Return MemoryRead($lAgentPtr + 0x8C, "float")
        Case "VisualEffects"
            Return MemoryRead($lAgentPtr + 0x90, "short")
        Case "h0092"
            Return MemoryRead($lAgentPtr + 0x92, "short")
        Case "h0094"
            Return MemoryRead($lAgentPtr + 0x94, "dword[2]")


        Case "Type"
            Return MemoryRead($lAgentPtr + 0x9C, "long")
		Case "IsItemType"
			Return MemoryRead($lAgentPtr + 0x9C, "long") = 0x400
		Case "IsGadgetType"
			Return MemoryRead($lAgentPtr + 0x9C, "long") = 0x200
		Case "IsLivingType"
			Return MemoryRead($lAgentPtr + 0x9C, "long") = 0xDB


        Case "MoveX"
            Return MemoryRead($lAgentPtr + 0xA0, "float")
        Case "MoveY"
            Return MemoryRead($lAgentPtr + 0xA4, "float")
        Case "h00A8"
            Return MemoryRead($lAgentPtr + 0xA8, "dword")
        Case "RotationCos2"
            Return MemoryRead($lAgentPtr + 0xAC, "float")
        Case "RotationSin2"
            Return MemoryRead($lAgentPtr + 0xB0, "float")
        Case "h00B4"
            Return MemoryRead($lAgentPtr + 0xB4, "dword[4]")

        Case "Owner"
            Return MemoryRead($lAgentPtr + 0xC4, "long")
		Case "CanPickUp"
			If MemoryRead($lAgentPtr + 0x9C, "long") = 0x400 Then
				If MemoryRead($lAgentPtr + 0xC4, "long") = 0 Or MemoryRead($lAgentPtr + 0xC4, "long") = GetMyID() Then Return True
			EndIf
			Return False

        Case "ItemID"
            Return MemoryRead($lAgentPtr + 0xC8, "dword")
        Case "ExtraType"
            Return MemoryRead($lAgentPtr + 0xCC, "dword")
        Case "GadgetID"
            Return MemoryRead($lAgentPtr + 0xD0, "dword")
        Case "h00D4"
            Return MemoryRead($lAgentPtr + 0xD4, "dword[3]")
        Case "AnimationType"
            Return MemoryRead($lAgentPtr + 0xE0, "float")
        Case "h00E4"
            Return MemoryRead($lAgentPtr + 0xE4, "dword[2]")
        Case "AttackSpeed"
            Return MemoryRead($lAgentPtr + 0xEC, "float")
        Case "AttackSpeedModifier"
            Return MemoryRead($lAgentPtr + 0xF0, "float")
        Case "PlayerNumber"
            Return MemoryRead($lAgentPtr + 0xF4, "short")
        Case "AgentModelType"
            Return MemoryRead($lAgentPtr + 0xF6, "short")
		Case "TransmogNpcId"
            Return MemoryRead($lAgentPtr + 0xF8, "dword")
        Case "Equipment"
            Return MemoryRead($lAgentPtr + 0xFC, "ptr")
        Case "h0100"
            Return MemoryRead($lAgentPtr + 0x100, "dword")
        Case "Tags"
            Return MemoryRead(MemoryRead($lAgentPtr + 0x104, "ptr"), "short")
        Case "h0108"
            Return MemoryRead($lAgentPtr + 0x108, "short")
        Case "Primary"
            Return MemoryRead($lAgentPtr + 0x10A, "byte")
        Case "Secondary"
            Return MemoryRead($lAgentPtr + 0x10B, "byte")
        Case "Level"
            Return MemoryRead($lAgentPtr + 0x10C, "byte")
        Case "Team"
            Return MemoryRead($lAgentPtr + 0x10D, "byte")
        Case "h010E"
            Return MemoryRead($lAgentPtr + 0x10E, "byte[2]")
        Case "h0110"
            Return MemoryRead($lAgentPtr + 0x110, "dword")
        Case "EnergyRegen"
            Return MemoryRead($lAgentPtr + 0x114, "float")
        Case "Overcast"
            Return MemoryRead($lAgentPtr + 0x118, "float")
        Case "EnergyPercent"
            Return MemoryRead($lAgentPtr + 0x11C, "float")
        Case "MaxEnergy"
            Return MemoryRead($lAgentPtr + 0x120, "dword")
		Case "CurrentEnergy"
			Return MemoryRead($lAgentPtr + 0x11C, "float") * MemoryRead($lAgentPtr + 0x120, "dword")
        Case "h0124"
            Return MemoryRead($lAgentPtr + 0x124, "dword")
        Case "HPPips"
            Return MemoryRead($lAgentPtr + 0x128, "float")
        Case "h012C"
            Return MemoryRead($lAgentPtr + 0x12C, "dword")
        Case "HP"
            Return MemoryRead($lAgentPtr + 0x130, "float")
        Case "MaxHP"
            Return MemoryRead($lAgentPtr + 0x134, "dword")
		Case "CurrentHP"
			Return MemoryRead($lAgentPtr + 0x130, "float") * MemoryRead($lAgentPtr + 0x134, "dword")

        Case "Effects"
            Return MemoryRead($lAgentPtr + 0x138, "dword")
		Case "EffectCount"
            Local $lAgentID = ConvertID($aAgentID)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x508]
            Local $lAgentEffectsBasePtr = MemoryReadPtr($mBasePointer, $lOffset)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x510]
            Local $lAgentEffectsCount = MemoryReadPtr($mBasePointer, $lOffset)

            If $lAgentEffectsBasePtr[1] = 0 Or $lAgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $lAgentEffectsCount[1] - 1
                Local $lAgentEffectsPtr = $lAgentEffectsBasePtr[1] + ($i * 0x24)
                Local $lCurrentAgentID = MemoryRead($lAgentEffectsPtr, "dword")

                If $lCurrentAgentID = $lAgentID Then
                    Local $lEffectArrayPtr = $lAgentEffectsPtr + 0x14
                    Return MemoryRead($lEffectArrayPtr + 0x8, "long")
                EndIf
            Next
            Return 0
        Case "BuffCount"
            Local $lAgentID = ConvertID($aAgentID)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x508]
            Local $lAgentEffectsBasePtr = MemoryReadPtr($mBasePointer, $lOffset)
            Local $lOffset[4] = [0, 0x18, 0x2C, 0x510]
            Local $lAgentEffectsCount = MemoryReadPtr($mBasePointer, $lOffset)

            If $lAgentEffectsBasePtr[1] = 0 Or $lAgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $lAgentEffectsCount[1] - 1
                Local $lAgentEffectsPtr = $lAgentEffectsBasePtr[1] + ($i * 0x24)
                Local $lCurrentAgentID = MemoryRead($lAgentEffectsPtr, "dword")

                If $lCurrentAgentID = $lAgentID Then
                    Local $lBuffArrayPtr = $lAgentEffectsPtr + 0x4
                    Return MemoryRead($lBuffArrayPtr + 0x8, "long")
                EndIf
            Next

            Return 0


		Case "IsBleeding"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0001) > 0
		Case "IsConditioned"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0002) > 0
		Case "IsCrippled"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x000A) = 0xA
		Case "IsDead"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0010) > 0
		Case "IsDeepWounded"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0020) > 0
		Case "IsPoisoned"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0040) > 0
		Case "IsEnchanted"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0080) > 0
		Case "IsDegenHexed"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0400) > 0
		Case "IsHexed"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x0800) > 0
		Case "IsWeaponSpelled"
			Return BitAND(MemoryRead($lAgentPtr + 0x138, "dword"), 0x8000) > 0

        Case "h013C"
            Return MemoryRead($lAgentPtr + 0x13C, "dword")
        Case "Hex"
            Return MemoryRead($lAgentPtr + 0x140, "byte")
        Case "h0141"
            Return MemoryRead($lAgentPtr + 0x141, "byte[19]")

        Case "ModelState"
            Return MemoryRead($lAgentPtr + 0x154, "dword")
		Case "IsKnockedDown"
			Return MemoryRead($lAgentPtr + 0x154, "dword") = 0x450
		Case "IsMoving"
			If MemoryRead($lAgentPtr + 0xA0, "float") <> 0 Or MemoryRead($lAgentPtr + 0xA4, "float") <> 0 Then Return True
			If MemoryRead($lAgentPtr + 0x154, "dword") = 12 Or MemoryRead($lAgentPtr + 0x154, "dword") = 76 Or MemoryRead($lAgentPtr + 0x154, "dword") = 204 Then Return True
			Return False
		Case "IsAttacking"
			If MemoryRead($lAgentPtr + 0x154, "dword") = 0x60 Or MemoryRead($lAgentPtr + 0x154, "dword") = 0x440 Or MemoryRead($lAgentPtr + 0x154, "dword") = 0x460 Then Return True
			Return False
		Case "IsCasting"
			If MemoryRead($lAgentPtr + 0x1B4, "short") <> 0 Then Return True
			If MemoryRead($lAgentPtr + 0x154, "dword") = 0x41 Or MemoryRead($lAgentPtr + 0x154, "dword") = 0x245 Then Return True
			Return False
		Case "IsIdle"
			If MemoryRead($lAgentPtr + 0x154, "dword") = 68 Or MemoryRead($lAgentPtr + 0x154, "dword") = 64 Or MemoryRead($lAgentPtr + 0x154, "dword") = 100 Then Return True
			Return False

        Case "TypeMap"
            Return MemoryRead($lAgentPtr + 0x158, "dword")
		Case "InCombatStance"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000001) > 0
		Case "HasQuest"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000002) > 0
		Case "IsDeadByTypeMap"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000008) > 0
		Case "IsFemale"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000200) > 0
		Case "HasBossGlow"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x000400) > 0
		Case "IsHidingCap"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x001000) > 0
		Case "CanBeViewedInPartyWindow"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x20000) > 0
		Case "IsSpawned"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x040000) > 0
		Case "IsBeingObserved"
			Return BitAND(MemoryRead($lAgentPtr + 0x158, "dword"), 0x400000) > 0

        Case "h015C"
            Return MemoryRead($lAgentPtr + 0x15C, "dword[4]")
        Case "InSpiritRange"
            Return MemoryRead($lAgentPtr + 0x16C, "dword")
		Case "VisibleEffectsPtr"
            Return MemoryRead($lAgentPtr + 0x170, "ptr")
        Case "VisibleEffects"
            Return MemoryRead($lAgentPtr + 0x170, "dword")
        Case "VisibleEffectsID"
            Return MemoryRead($lAgentPtr + 0x174, "dword")
        Case "VisibleEffectsHasEnded"
            Return MemoryRead($lAgentPtr + 0x178, "dword")
        Case "h017C"
            Return MemoryRead($lAgentPtr + 0x17C, "dword")

        Case "LoginNumber"
            Return MemoryRead($lAgentPtr + 0x180, "dword")
		Case "IsPlayer"
			Return MemoryRead($lAgentPtr + 0x180, "dword") <> 0
		Case "IsNPC"
			Return MemoryRead($lAgentPtr + 0x180, "dword") = 0

        Case "AnimationSpeed"
            Return MemoryRead($lAgentPtr + 0x184, "float")
        Case "AnimationCode"
            Return MemoryRead($lAgentPtr + 0x188, "dword")
        Case "AnimationId"
            Return MemoryRead($lAgentPtr + 0x18C, "dword")
        Case "h0190"
            Return MemoryRead($lAgentPtr + 0x190, "byte[32]")
        Case "LastStrike"
            Return MemoryRead($lAgentPtr + 0x1B0, "byte")
        Case "Allegiance"
            Return MemoryRead($lAgentPtr + 0x1B1, "byte")
        Case "WeaponType"
            Return MemoryRead($lAgentPtr + 0x1B2, "short")
        Case "Skill"
            Return MemoryRead($lAgentPtr + 0x1B4, "short")
        Case "h01B6"
            Return MemoryRead($lAgentPtr + 0x1B6, "short")
        Case "WeaponItemType"
            Return MemoryRead($lAgentPtr + 0x1B8, "byte")
        Case "OffhandItemType"
            Return MemoryRead($lAgentPtr + 0x1B9, "byte")
        Case "WeaponItemId"
            Return MemoryRead($lAgentPtr + 0x1BA, "short")
        Case "OffhandItemId"
            Return MemoryRead($lAgentPtr + 0x1BC, "short")

		Case "Name"
			Return 0 ;in progress
		Case Else
			Return 0
	EndSwitch

    Return 0
EndFunc

Func GetAgentEquimentInfo($aAgentID = -2, $aInfo = "")
	Local $lAgentPtr = GetAgentInfo($aAgentID, "Equipment")
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0
    Switch $aInfo
        Case "vtable"
            Return MemoryRead($lAgentPtr, "dword")
		Case "h0004"
			Return MemoryRead($lAgentPtr + 0x4, "dword")
		Case "h0008"
			Return MemoryRead($lAgentPtr + 0x8, "dword")
		Case "h000C"
			Return MemoryRead($lAgentPtr + 0xC, "dword")
		Case "LeftHandData"
			Return MemoryRead($lAgentPtr + 0x10, "Ptr")
		Case "RightHandData"
			Return MemoryRead($lAgentPtr + 0x14, "Ptr")
		Case "h0018"
			Return MemoryRead($lAgentPtr + 0x18, "dword")
		Case "ShieldData"
			Return MemoryRead($lAgentPtr + 0x1C, "Ptr")


		Case "Weapon_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x24, "dword")
		Case "Weapon_Type"
			Return MemoryRead($lAgentPtr + 0x28, "byte")
		Case "Weapon_Dye1"
			Return MemoryRead($lAgentPtr + 0x29, "byte")
		Case "Weapon_Dye2"
			Return MemoryRead($lAgentPtr + 0x2A, "byte")
		Case "Weapon_Dye3"
			Return MemoryRead($lAgentPtr + 0x2B, "byte")
		Case "Weapon_Value"
			Return MemoryRead($lAgentPtr + 0x2C, "dword")
		Case "Weapon_Interaction"
			Return MemoryRead($lAgentPtr + 0x30, "dword")


		Case "Offhand_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x34, "dword")
		Case "Offhand_Type"
			Return MemoryRead($lAgentPtr + 0x38, "byte")
		Case "Offhand_Dye1"
			Return MemoryRead($lAgentPtr + 0x39, "byte")
		Case "Offhand_Dye2"
			Return MemoryRead($lAgentPtr + 0x3A, "byte")
		Case "Offhand_Dye3"
			Return MemoryRead($lAgentPtr + 0x3B, "byte")
		Case "Offhand_Value"
			Return MemoryRead($lAgentPtr + 0x3C, "dword")
		Case "Offhand_Interaction"
			Return MemoryRead($lAgentPtr + 0x40, "dword")

		Case "Chest_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x44, "dword")
		Case "Chest_Type"
			Return MemoryRead($lAgentPtr + 0x48, "byte")
		Case "Chest_Dye1"
			Return MemoryRead($lAgentPtr + 0x49, "byte")
		Case "Chest_Dye2"
			Return MemoryRead($lAgentPtr + 0x4A, "byte")
		Case "Chest_Dye3"
			Return MemoryRead($lAgentPtr + 0x4B, "byte")
		Case "Chest_Value"
			Return MemoryRead($lAgentPtr + 0x4C, "dword")
		Case "Chest_Interaction"
			Return MemoryRead($lAgentPtr + 0x50, "dword")

		Case "Leg_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x54, "dword")
		Case "Leg_Type"
			Return MemoryRead($lAgentPtr + 0x58, "byte")
		Case "Leg_Dye1"
			Return MemoryRead($lAgentPtr + 0x59, "byte")
		Case "Leg_Dye2"
			Return MemoryRead($lAgentPtr + 0x5A, "byte")
		Case "Leg_Dye3"
			Return MemoryRead($lAgentPtr + 0x5B, "byte")
		Case "Leg_Value"
			Return MemoryRead($lAgentPtr + 0x5C, "dword")
		Case "Leg_Interaction"
			Return MemoryRead($lAgentPtr + 0x60, "dword")

		Case "Head_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x64, "dword")
		Case "Head_Type"
			Return MemoryRead($lAgentPtr + 0x68, "byte")
		Case "Head_Dye1"
			Return MemoryRead($lAgentPtr + 0x69, "byte")
		Case "Head_Dye2"
			Return MemoryRead($lAgentPtr + 0x6A, "byte")
		Case "Head_Dye3"
			Return MemoryRead($lAgentPtr + 0x6B, "byte")
		Case "Head_Value"
			Return MemoryRead($lAgentPtr + 0x6C, "dword")
		Case "Head_Interaction"
			Return MemoryRead($lAgentPtr + 0x70, "dword")

		Case "Feet_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x74, "dword")
		Case "Feet_Type"
			Return MemoryRead($lAgentPtr + 0x78, "byte")
		Case "Feet_Dye1"
			Return MemoryRead($lAgentPtr + 0x79, "byte")
		Case "Feet_Dye2"
			Return MemoryRead($lAgentPtr + 0x7A, "byte")
		Case "Feet_Dye3"
			Return MemoryRead($lAgentPtr + 0x7B, "byte")
		Case "Feet_Value"
			Return MemoryRead($lAgentPtr + 0x7C, "dword")
		Case "Feet_Interaction"
			Return MemoryRead($lAgentPtr + 0x80, "dword")

		Case "Hands_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x84, "dword")
		Case "Hands_Type"
			Return MemoryRead($lAgentPtr + 0x88, "byte")
		Case "Hands_Dye1"
			Return MemoryRead($lAgentPtr + 0x89, "byte")
		Case "Hands_Dye2"
			Return MemoryRead($lAgentPtr + 0x8A, "byte")
		Case "Hands_Dye3"
			Return MemoryRead($lAgentPtr + 0x8B, "byte")
		Case "Hands_Value"
			Return MemoryRead($lAgentPtr + 0x8C, "dword")
		Case "Hands_Interaction"
			Return MemoryRead($lAgentPtr + 0x90, "dword")

		Case "CostumeBody_ModelFileID"
			Return MemoryRead($lAgentPtr + 0x94, "dword")
		Case "CostumeBody_Type"
			Return MemoryRead($lAgentPtr + 0x98, "byte")
		Case "CostumeBody_Dye1"
			Return MemoryRead($lAgentPtr + 0x99, "byte")
		Case "CostumeBody_Dye2"
			Return MemoryRead($lAgentPtr + 0x9A, "byte")
		Case "CostumeBody_Dye3"
			Return MemoryRead($lAgentPtr + 0x9B, "byte")
		Case "CostumeBody_Value"
			Return MemoryRead($lAgentPtr + 0x9C, "dword")
		Case "CostumeBody_Interaction"
			Return MemoryRead($lAgentPtr + 0xA0, "dword")

		Case "CostumeHead_ModelFileID"
			Return MemoryRead($lAgentPtr + 0xA4, "dword")
		Case "CostumeHead_Type"
			Return MemoryRead($lAgentPtr + 0xA8, "byte")
		Case "CostumeHead_Dye1"
			Return MemoryRead($lAgentPtr + 0xA9, "byte")
		Case "CostumeHead_Dye2"
			Return MemoryRead($lAgentPtr + 0xAA, "byte")
		Case "CostumeHead_Dye3"
			Return MemoryRead($lAgentPtr + 0xAB, "byte")
		Case "CostumeHead_Value"
			Return MemoryRead($lAgentPtr + 0xAC, "dword")
		Case "CostumeHead_Interaction"
			Return MemoryRead($lAgentPtr + 0xB0, "dword")

		Case "ItemID_Weapon"
			Return MemoryRead($lAgentPtr + 0xB4, "dword")
		Case "ItemID_Offhand"
			Return MemoryRead($lAgentPtr + 0xB8, "dword")
		Case "ItemID_Chest"
			Return MemoryRead($lAgentPtr + 0xBC, "dword")
		Case "ItemID_Legs"
			Return MemoryRead($lAgentPtr + 0xC0, "dword")
		Case "ItemID_Head"
			Return MemoryRead($lAgentPtr + 0xC4, "dword")
		Case "ItemID_Feet"
			Return MemoryRead($lAgentPtr + 0xC8, "dword")
		Case "ItemID_Hands"
			Return MemoryRead($lAgentPtr + 0xCC, "dword")
		Case "ItemID_CostumeBody"
			Return MemoryRead($lAgentPtr + 0xD0, "dword")
		Case "ItemID_CostumeHead"
			Return MemoryRead($lAgentPtr + 0xD4, "dword")
	EndSwitch
	Return 0
EndFunc

Func GetAgentVisibleEffectInfo($aAgentID = -2, $aInfo = "")
	Local $lAgentPtr = GetAgentInfo($aAgentID, "VisibleEffectsPtr")
    If $lAgentPtr = 0 Or $aInfo = "" Then Return 0

    Switch $aInfo
        Case "" ; dummy case to avoid syntax error
            Sleep(100)
	EndSwitch

	Return 0
EndFunc

Func GetAgentArray($aType = 0)
    Local $lMaxAgents = _AgentMod_GetMaxAgents()
    If $lMaxAgents <= 0 Then Return

	Local $lAgentArray[$lMaxAgents + 1]
    Local $lPtr, $lCount = 0
    Local $lAgentBasePtr = MemoryRead($g_mAgentBase)
    Local $lAgentPtrBuffer = DllStructCreate("ptr[" & $lMaxAgents & "]")

    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, "ptr", $lAgentBasePtr, "struct*", $lAgentPtrBuffer, "ulong_ptr", 4 * $lMaxAgents, "ulong_ptr*", 0)

    For $i = 1 To $lMaxAgents
        $lPtr = DllStructGetData($lAgentPtrBuffer, 1, $i)
        If $lPtr = 0 Then ContinueLoop

        If $aType <> 0 Then
            If GetAgentInfo($lPtr, "Type") <> $aType Then ContinueLoop
        EndIf

        $lCount += 1
        $lAgentArray[$lCount] = $lPtr
    Next

    $lAgentArray[0] = $lCount
    ReDim $lAgentArray[$lCount + 1]

    Return $lAgentArray
EndFunc

;~ Func GetAgentArray()
;~     Local $lAgentArray = MemoryReadArray($mAgentBase, 0x8)
;~     Return $lAgentArray
;~ EndFunc
#EndRegion Agent Related

; #FUNCTION# ;===============================================================================
; Name...........: _AgentMod_GetDistance
; Description ...: Calculates distance between two agents
; Syntax.........: _AgentMod_GetDistance($aAgent1ID, $aAgent2ID = 0)
; Parameters ....: $aAgent1ID - First agent ID
;                  $aAgent2ID - [optional] Second agent ID (default: player)
; Return values .: Distance between agents
; Author ........: Greg76
; Modified.......:
; Remarks .......: - If second agent is 0, uses player position
;                  - Returns straight-line distance
; Related .......: _AgentMod_GetAgentInfo, _AgentMod_GetMyID
;============================================================================================
Func _AgentMod_GetDistance($aAgent1ID, $aAgent2ID = 0)
    If $aAgent2ID = 0 Then $aAgent2ID = _AgentMod_GetMyID()

    Local $lX1 = _AgentMod_GetAgentInfo($aAgent1ID, "X")
    Local $lY1 = _AgentMod_GetAgentInfo($aAgent1ID, "Y")
    Local $lX2 = _AgentMod_GetAgentInfo($aAgent2ID, "X")
    Local $lY2 = _AgentMod_GetAgentInfo($aAgent2ID, "Y")

    Return Sqrt(($lX1 - $lX2)^2 + ($lY1 - $lY2)^2)
EndFunc