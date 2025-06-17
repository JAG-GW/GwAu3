#include-once

#Region Quest Related
Func GwAu3_QuestMod_GetQuestInfo($aQuestID, $aInfo = "")
	Local $lPtr
    Local $lSize = GwAu3_OtherMod_GetWorldInfo("QuestLogSize")
	If $lSize = 0 Or $aInfo = "" Then Return 0

	For $i = 0 To $lSize
		Local $lOffsetQuestLog[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $i]
		Local $lQuestPtr = GwAu3_Memory_ReadPtr($g_p_BasePointer, $lOffsetQuestLog, "long")
		If $lQuestPtr[1] = $aQuestID Then $lPtr = Ptr($lQuestPtr[0])
	Next

    Switch $aInfo
		Case "QuestID"
			Return GwAu3_Memory_Read($lPtr, "long")

		Case "LogState"
			Return GwAu3_Memory_Read($lPtr + 0x4, "long")
		Case "IsCompleted"
			Switch GwAu3_Memory_Read($lPtr + 0x4, "long")
				Case 2, 3, 19, 32, 34, 35, 79
					Return True
				Case Else
					Return False
			EndSwitch
		Case "CanReward"
			Switch GwAu3_Memory_Read($lPtr + 0x4, "long")
				Case 32, 33
					Return True
				Case Else
					Return False
			EndSwitch
		Case "IsIncomplete"
			If GwAu3_Memory_Read($lPtr + 0x4, "long") = 1 Then Return True
			Return False
		Case "IsCurrentQuest"
			If GwAu3_Memory_Read($lPtr + 0x4, "long") = 0x10 Then Return True
			Return False
		Case "IsAreaPrimary"
			If GwAu3_Memory_Read($lPtr + 0x4, "long") = 0x40 Then Return True
			Return False
		Case "IsPrimary"
			If GwAu3_Memory_Read($lPtr + 0x4, "long") = 0x20 Then Return True
			Return False


		Case "Location"
			Local $lLocationPtr = GwAu3_Memory_Read($lPtr + 0x8, "ptr")
            Return GwAu3_Memory_Read($lLocationPtr, "wchar[256]")
		Case "Name"
			Local $lNamePtr = GwAu3_Memory_Read($lPtr + 0xC, "ptr")
            Return GwAu3_Memory_Read($lNamePtr, "wchar[256]")
		Case "NPC"
			Local $lNPCPtr = GwAu3_Memory_Read($lPtr + 0x10, "ptr")
            Return GwAu3_Memory_Read($lNPCPtr, "wchar[256]")
		Case "MapFrom"
			Return GwAu3_Memory_Read($lPtr + 0x14, "dword")
		Case "MarkerX"
			Return GwAu3_Memory_Read($lPtr + 0x18, "float")
		Case "MarkerY"
			Return GwAu3_Memory_Read($lPtr + 0x1C, "float")
		Case "MarkerZ"
			Return GwAu3_Memory_Read($lPtr + 0x20, "dword")
		Case "MapTo"
			Return GwAu3_Memory_Read($lPtr + 0x28, "dword")
		Case "Description"
			Local $lDescriptionPtr = GwAu3_Memory_Read($lPtr + 0x2C, "ptr")
            Return GwAu3_Memory_Read($lDescriptionPtr, "wchar[256]")
		Case "Objectives"
			Local $lObjectivesPtr = GwAu3_Memory_Read($lPtr + 0x30, "ptr")
            Return GwAu3_Memory_Read($lObjectivesPtr, "wchar[256]")
	EndSwitch

	Return 0
EndFunc
#EndRegion Quest Related