#include-once
#RequireAdmin

#include <Math.au3>

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf /tl
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

If @AutoItX64 Then
	MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
	Exit
EndIf

#Region Declarations
; General settings and handles
Global $mKernelHandle, $mGWProcHandle, $mMemory
Global $mBase = 0x00C50000
Global $mASMString, $mASMSize, $mASMCodeOffset
Global $SecondInject

; GUI elements
Global $mGUI = GUICreate('GwAu3')
GUIRegisterMsg(0x501, 'Event')

; Structs for logging
Global $mSkillLogStruct = DllStructCreate('dword;dword;dword;float')
Global $mSkillLogStructPtr = DllStructGetPtr($mSkillLogStruct)
Global $mChatLogStruct = DllStructCreate('dword;wchar[256]')
Global $mChatLogStructPtr = DllStructGetPtr($mChatLogStruct)

; Game-related variables
Global $mQueueCounter, $mQueueSize, $mQueueBase
Global $mGWWindowHandle
Global $mTargetLogBase, $mStringLogBase, $mSkillBase
Global $mEnsureEnglish
Global $mCurrentTarget
Global $packetlocation
Global $mAgentBase, $mBasePointer
Global $mRegion;, $mLanguage
Global $mPing, $mCharname;, $mMapID
Global $mMaxAgents, $mMapLoading, $mMapIsLoaded, $mLoggedIn
Global $mStringHandlerPtr, $mWriteChatSender
Global $mTraderQuoteID, $mTraderCostID, $mTraderCostValue
Global $mSkillTimer
Global $lTemp
Global $mZoomStill, $mZoomMoving
Global $mDisableRendering, $mAgentCopyCount, $mAgentCopyBase
Global $mCurrentStatus, $mLastDialogID
Global $mUseStringLog, $mUseEventSystem
Global $mCharslots
Global $mInstanceInfo, $mAreaInfo
Global $mAttributeInfo
Global $mWorldConst
#EndRegion Declarations

#Region CommandStructs
Global $mInviteGuild = DllStructCreate('ptr;dword;dword header;dword counter;wchar name[32];dword type')
Global $mInviteGuildPtr = DllStructGetPtr($mInviteGuild)

Global $mUseSkill = DllStructCreate('ptr;dword;dword;dword')
Global $mUseSkillPtr = DllStructGetPtr($mUseSkill)

Global $mMove = DllStructCreate('ptr;float;float;float')
Global $mMovePtr = DllStructGetPtr($mMove)

Global $mChangeTarget = DllStructCreate('ptr;dword')
Global $mChangeTargetPtr = DllStructGetPtr($mChangeTarget)

Global $mPacket = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Global $mPacketPtr = DllStructGetPtr($mPacket)

Global $mWriteChat = DllStructCreate('ptr')
Global $mWriteChatPtr = DllStructGetPtr($mWriteChat)

Global $mSellItem = DllStructCreate('ptr;dword;dword;dword')
Global $mSellItemPtr = DllStructGetPtr($mSellItem)

Global $mAction = DllStructCreate('ptr;dword;dword;')
Global $mActionPtr = DllStructGetPtr($mAction)

Global $mToggleLanguage = DllStructCreate('ptr;dword')
Global $mToggleLanguagePtr = DllStructGetPtr($mToggleLanguage)

Global $mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Global $mUseHeroSkillPtr = DllStructGetPtr($mUseHeroSkill)

Global $mBuyItem = DllStructCreate('ptr;dword;dword;dword;dword')
Global $mBuyItemPtr = DllStructGetPtr($mBuyItem)

Global $mCraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Global $mCraftItemExPtr = DllStructGetPtr($mCraftItemEx)

Global $mSendChat = DllStructCreate('ptr;dword')
Global $mSendChatPtr = DllStructGetPtr($mSendChat)

Global $mRequestQuote = DllStructCreate('ptr;dword')
Global $mRequestQuotePtr = DllStructGetPtr($mRequestQuote)

Global $mRequestQuoteSell = DllStructCreate('ptr;dword')
Global $mRequestQuoteSellPtr = DllStructGetPtr($mRequestQuoteSell)

Global $mTraderBuy = DllStructCreate('ptr')
Global $mTraderBuyPtr = DllStructGetPtr($mTraderBuy)

Global $mTraderSell = DllStructCreate('ptr')
Global $mTraderSellPtr = DllStructGetPtr($mTraderSell)

Global $mSalvage = DllStructCreate('ptr;dword;dword;dword')
Global $mSalvagePtr = DllStructGetPtr($mSalvage)

Global $mIncreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $mIncreaseAttributePtr = DllStructGetPtr($mIncreaseAttribute)

Global $mDecreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $mDecreaseAttributePtr = DllStructGetPtr($mDecreaseAttribute)

Global $mMaxAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Global $mMaxAttributesPtr = DllStructGetPtr($mMaxAttributes)

Global $mSetAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Global $mSetAttributesPtr = DllStructGetPtr($mSetAttributes)

Global $mMakeAgentArray = DllStructCreate('ptr;dword')
Global $mMakeAgentArrayPtr = DllStructGetPtr($mMakeAgentArray)

Global $mChangeStatus = DllStructCreate('ptr;dword')
Global $mChangeStatusPtr = DllStructGetPtr($mChangeStatus)

Global $MTradeHackAddress
Global $mLabels[1][2] = [[0]]
#EndRegion CommandStructs

#Region GwAu3 Structs
;~ Global $g_AgentStruct = DllStructCreate('ptr vtable;dword h0004[4];dword timer;dword timer2;dword h0018[4];long Id;float Z;float width1;float height1;float width2;float height2;float width3;float height3;float Rotation;float rotation_cos;float rotation_sin;dword NameProperties;dword ground;dword h0060;float terrain_normal_x;float terrain_normal_y;dword terrain_normal_z;byte h0070[4];float X;float Y;dword plane;byte h0080[4];float NameTagX;float NameTagY;float NameTagZ;short visual_effects;short h0092;dword h0094[2];long Type;float MoveX;float MoveY;dword h00A8;float rotation_cos2;float rotation_sin2;dword h00B4[4];long Owner;dword ItemID;dword ExtraType;dword GadgetID;dword h00D4[3];float animation_type;dword h00E4[2];float AttackSpeed;float AttackSpeedModifier;short PlayerNumber;short agent_model_type;dword transmog_npc_id;ptr Equip;dword h0100;ptr tags;short h0108;byte Primary;byte Secondary;byte Level;byte Team;byte h010E[2];dword h0110;float energy_regen;float overcast;float EnergyPercent;dword MaxEnergy;dword h0124;float HPPips;dword h012C;float HP;dword MaxHP;dword Effects;dword h013C;byte Hex;byte h0141[19];dword ModelState;dword TypeMap;dword h015C[4];dword InSpiritRange;dword visible_effects;dword visible_effects_ID;dword visible_effects_has_ended;dword h017C;dword LoginNumber;float animation_speed;dword animation_code;dword animation_id;byte h0190[32];byte LastStrike;byte Allegiance;short WeaponType;short Skill;short h01B6;byte weapon_item_type;byte offhand_item_type;short WeaponItemId;short OffhandItemId')
;~ Global $g_ItemStruct = DllStructCreate('long Id;long AgentId;ptr BagEquiped;ptr Bag;ptr ModStruct;long ModStructSize;ptr Customized;long ModelFileID;byte Type;byte unknown4;short ExtraId;short Value;short Unknown1;short Interaction;long ModelId;ptr InfoString;ptr NameEnc;ptr CompleteNameEnc;ptr SingleItemName;long Unknown2[2];short ItemFormula;byte IsMaterialSalvageable;byte Unknown3;short Quantity;byte Equiped;byte Profession;byte Slot')
;~ Global $g_BuffStruct = DllStructCreate('long SkillId;long unknown1;long BuffId;long TargetId')
;~ Global $g_EffectStruct = DllStructCreate('long SkillId;long AttributeLevel;long EffectId;long AgentId;float Duration;long TimeStamp')
;~ Global $g_BagStruct = DllStructCreate('long TypeBag;long index;long unknown1;ptr containerItem;long ItemsCount;ptr bagArray;ptr itemArray;long fakeSlots;long slots')
;~ Global $g_SkillbarStruct = DllStructCreate('long AgentId;long AdrenalineA1;long AdrenalineB1;dword Recharge1;dword Id1;dword Event1;long AdrenalineA2;long AdrenalineB2;dword Recharge2;dword Id2;dword Event2;long AdrenalineA3;long AdrenalineB3;dword Recharge3;dword Id3;dword Event3;long AdrenalineA4;long AdrenalineB4;dword Recharge4;dword Id4;dword Event4;long AdrenalineA5;long AdrenalineB5;dword Recharge5;dword Id5;dword Event5;long AdrenalineA6;long AdrenalineB6;dword Recharge6;dword Id6;dword Event6;long AdrenalineA7;long AdrenalineB7;dword Recharge7;dword Id7;dword Event7;long AdrenalineA8;long AdrenalineB8;dword Recharge8;dword Id8;dword Event8;dword disabled;long unknown1[2];dword Casting;long unknown2[2]')
;~ Global $g_SkillStruct = DllStructCreate('long ID;long Unknown1;long campaign;long Type;long Special;long ComboReq;long Effect1;long Condition;long Effect2;long WeaponReq;byte Profession;byte Attribute;short Title;long PvPID;byte Combo;byte Target;byte unknown3;byte EquipType;byte Overcast;byte EnergyCost;byte HealthCost;byte unknown4;dword Adrenaline;float Activation;float Aftercast;long Duration0;long Duration15;long Recharge;long Unknown5[4];dword SkillArguments;long Scale0;long Scale15;long BonusScale0;long BonusScale15;float AoERange;float ConstEffect;dword caster_overhead_animation_id;dword caster_body_animation_id;dword target_body_animation_id;dword target_overhead_animation_id;dword projectile_animation_1_id;dword projectile_animation_2_id;dword icon_file_id;dword icon_file_id_2;dword name;dword concise;dword description')
;~ Global $g_AttributeStruct = DllStructCreate('dword profession_id;dword attribute_id;dword name_id;dword desc_id;dword is_pve')
;~ Global $g_AreaInfoStruct = DllStructCreate("dword campaign;dword continent;dword region;dword regiontype;dword flags;dword thumbnail_id;dword min_party_size;dword max_party_size;dword min_player_size;dword max_player_size;dword controlled_outpost_id;dword fraction_mission;dword min_level;dword max_level;dword needed_pq;dword mission_maps_to;dword x;dword y;dword icon_start_x;dword icon_start_y;dword icon_end_x;dword icon_end_y;dword icon_start_x_dupe;dword icon_start_y_dupe;dword icon_end_x_dupe;dword icon_end_y_dupe;dword file_id;dword mission_chronology;dword ha_map_chronology;dword name_id;dword description_id")
;~ Global $g_QuestStruct = DllStructCreate('long id;long LogState;ptr Location;ptr Name;ptr NPC;long MapFrom;float X;float Y;long Z;long unlnown1;long MapTo;ptr Description;ptr Objective')
;~ Global $g_WorldStruct = DllStructCreate('long MinGridWidth;long MinGridHeight;long MaxGridWidth;long MaxGridHeight;long Flags;long Type;long SubGridWidth;long SubGridHeight;long StartPosX;long StartPosY;long MapWidth;long MapHeight')
#EndRegion

#Region Memory
;~ Description: Internal use only.
Func MemoryOpen($aPID)
	$mKernelHandle = DllOpen('kernel32.dll')
	Local $lOpenProcess = DllCall($mKernelHandle, 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', 1, 'int', $aPID)
	$mGWProcHandle = $lOpenProcess[0]
EndFunc   ;==>MemoryOpen

;~ Description: Internal use only.
Func MemoryClose()
	DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $mGWProcHandle)
	DllClose($mKernelHandle)
EndFunc   ;==>MemoryClose

;~ Description: Internal use only.
Func WriteBinary($aBinaryString, $aAddress)
	Local $lData = DllStructCreate('byte[' & 0.5 * StringLen($aBinaryString) & ']'), $i
	For $i = 1 To DllStructGetSize($lData)
		DllStructSetData($lData, 1, Dec(StringMid($aBinaryString, 2 * $i - 1, 2)), $i)
	Next
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $aAddress, 'ptr', DllStructGetPtr($lData), 'int', DllStructGetSize($lData), 'int', 0)
EndFunc   ;==>WriteBinary

;~ Description: Internal use only.
Func MemoryWrite($aAddress, $aData, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllStructSetData($lBuffer, 1, $aData)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
EndFunc   ;==>MemoryWrite

;~ Description: Internal use only.
Func MemoryRead($aAddress, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Return DllStructGetData($lBuffer, 1)
EndFunc   ;==>MemoryRead

;~ Description: Internal use only.
Func MemoryReadPtr($aAddress, $aOffset, $aType = 'dword')
	Local $lPointerCount = UBound($aOffset) - 2
	Local $lBuffer = DllStructCreate('dword')
	For $i = 0 To $lPointerCount
		$aAddress += $aOffset[$i]
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
		$aAddress = DllStructGetData($lBuffer, 1)
		If $aAddress == 0 Then
			Local $lData[2] = [0, 0]
			Return $lData
		EndIf
	Next
	$aAddress += $aOffset[$lPointerCount + 1]
	$lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Local $lData[2] = [$aAddress, DllStructGetData($lBuffer, 1)]
	Return $lData
EndFunc   ;==>MemoryReadPtr

;~ Description: Internal use only.
Func MemoryReadArray($aAddress, $aSizeOffset = 0x0)
    Local $lArraySize = MemoryRead($aAddress + $aSizeOffset, "dword")
    Local $lArrayBasePtr = MemoryRead($aAddress, "ptr")
    Local $lArray[$lArraySize + 1]
    Local $lBuffer = DllStructCreate("ptr[" & $lArraySize & "]")
	Local $lValue

    DllCall($mKernelHandle, "bool", "ReadProcessMemory", "handle", $mGWProcHandle, _
            "ptr", $lArrayBasePtr, "struct*", $lBuffer, _
            "ulong_ptr", 4 * $lArraySize, "ulong_ptr*", 0)

	$lArray[0] = 0
    For $i = 1 To $lArraySize
        $lValue = DllStructGetData($lBuffer, 1, $i)
        If $lValue = 0 Then ContinueLoop

        $lArray[0] += 1
        $lArray[$lArray[0]] = $lValue
    Next

    If $lArray[0] < $lArraySize Then
        ReDim $lArray[$lArray[0] + 1]
    EndIf

    Return $lArray
EndFunc   ;==>MemoryReadArray

;~ Description: Internal use only.
Func MemoryReadArrayPtr($aAddress, $aOffset, $aSizeOffset)
    Local $lAddress = MemoryReadPtr($aAddress, $aOffset, 'ptr')
    Return MemoryReadArray($lAddress[0], $aSizeOffset)
EndFunc   ;==>MemoryReadArrayPtr

;~ Description: Internal use only.
Func SwapEndian($aHex)
	Return StringMid($aHex, 7, 2) & StringMid($aHex, 5, 2) & StringMid($aHex, 3, 2) & StringMid($aHex, 1, 2)
EndFunc   ;==>SwapEndian

;~ Description: Emptys Guild Wars client memory
Func ClearMemory()
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSize', 'int', $mGWProcHandle, 'int', -1, 'int', -1)
EndFunc   ;==>ClearMemory

;~ Description: Changes the maximum memory Guild Wars can use.
Func SetMaxMemory($aMemory = 157286400)
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSizeEx', 'int', $mGWProcHandle, 'int', 1, 'int', $aMemory, 'int', 6)
EndFunc   ;==>SetMaxMemory
#EndRegion Memory

#Region Initialisation
;~ Description: Returns a list of logged characters
Func GetLoggedCharNames()
	Local $array = ScanGW()
	If $array[0] == 0 Then Return '' ; No characters logged
	Local $ret = $array[1] ; Start with the first character name
	For $i = 2 To $array[0] ; Concatenate remaining names, if any
		$ret &= "|" & $array[$i]
	Next
	Return $ret
EndFunc   ;==>GetLoggedCharNames

;~ Description: Returns an array of logged characters of gw windows (at pos 0 there is the size of the array)
Func ScanGW()
	Local $lProcessList = ProcessList("gw.exe")
	Local $lReturnArray[1] = [0]
	Local $lPid

	For $i = 1 To $lProcessList[0][0]
		MemoryOpen($lProcessList[$i][1])

		If $mGWProcHandle Then
			$lReturnArray[0] += 1
			ReDim $lReturnArray[$lReturnArray[0] + 1]
			$lReturnArray[$lReturnArray[0]] = ScanForCharname()
		EndIf

		MemoryClose()

		$mGWProcHandle = 0
	Next

	Return $lReturnArray
EndFunc   ;==>ScanGW

Func GetHwnd($aProc)
	Local $wins = WinList()
	For $i = 1 To UBound($wins) - 1
		If (WinGetProcess($wins[$i][1]) == $aProc) And (BitAND(WinGetState($wins[$i][1]), 2)) Then Return $wins[$i][1]
	Next
EndFunc   ;==>GetHwnd

;~ Description: Injects GWA² into the game client.
Func Initialize($aGW, $bChangeTitle = True, $aUseStringLog = False, $aUseEventSystem = True)
   ; Initialize variables
   Local $lWinList, $lWinList2, $mGWProcessId
   $mUseStringLog = $aUseStringLog
   $mUseEventSystem = $aUseEventSystem

   ; Check if $aGW is a string or a process ID
   If IsString($aGW) Then
      ; Find the process ID of the game client
      Local $lProcessList = ProcessList("gw.exe")
      For $i = 1 To $lProcessList[0][0]
        $mGWProcessId = $lProcessList[$i][1]
        $mGWWindowHandle = GetHwnd($mGWProcessId)
        MemoryOpen($mGWProcessId)
        If $mGWProcHandle Then
           ; Check if the character name matches
           If StringRegExp(ScanForCharname(), $aGW) = 1 Then
              ExitLoop
           EndIf
        EndIf
        MemoryClose()
        $mGWProcHandle = 0
      Next
   Else
      ; Use the provided process ID
      $mGWProcessId = $aGW
      $mGWWindowHandle = GetHwnd($mGWProcessId)
      MemoryOpen($aGW)
      ScanForCharname()
   EndIf

   Scan()

   ; Read Memory Values for Game Data
   $mBasePointer = MemoryRead(GetScannedAddress('ScanBasePointer', 0x8))
   SetValue('BasePointer', Ptr($mBasePointer))

   $mAgentBase = MemoryRead(GetScannedAddress('ScanAgentArray', -0x3))
   SetValue('AgentBase', Ptr($mAgentBase))
   $mMaxAgents = $mAgentBase + 0x8
   SetValue('MaxAgents', Ptr($mMaxAgents))

   $mCurrentTarget = MemoryRead(GetScannedAddress('ScanCurrentTarget', -0xE))

   $packetlocation = Ptr(MemoryRead(GetScannedAddress('ScanBaseOffset', 0xB)))
   SetValue('PacketLocation', $packetlocation)

   $mPing = MemoryRead(GetScannedAddress('ScanPing', -0x14))

;~    $mMapID = MemoryRead(GetScannedAddress('ScanMapID', 28))

;~    $mMapLoading = MemoryRead(GetScannedAddress('ScanMapLoading', 0xB))

   $mLoggedIn = MemoryRead(GetScannedAddress('ScanLoggedIn', 0x3))

;~    $mLanguage = MemoryRead(GetScannedAddress('ScanMapInfo', 11)) + 0xC
;~    $mRegion = $mLanguage + 4
   $mRegion = MemoryRead(GetScannedAddress('ScanRegion', -0x3))


   $mSkillBase = MemoryRead(GetScannedAddress('ScanSkillBase', 0x8))
   $mSkillTimer = MemoryRead(GetScannedAddress('ScanSkillTimer', -0x3))

   $mZoomStill = GetScannedAddress("ScanZoomStill", 0x33)
   $mZoomMoving = GetScannedAddress("ScanZoomMoving", 0x21)

   $mCurrentStatus = MemoryRead(GetScannedAddress('ScanChangeStatusFunction', 0x23))
   $mCharslots = MemoryRead(GetScannedAddress('ScanCharslots', 0x16))

   $mInstanceInfo = MemoryRead(GetScannedAddress('ScanInstanceInfo', 0xE))
   $mAreaInfo = MemoryRead(GetScannedAddress('ScanAreaInfo', 0x6))

   $mAttributeInfo = MemoryRead(GetScannedAddress('ScanAttributeInfo', -0x3))

   $mWorldConst = MemoryRead(GetScannedAddress('ScanWorldConst', 0x8))

   $lTemp = GetScannedAddress('ScanEngine', -0x22)
   SetValue('MainStart', Ptr($lTemp))
   SetValue('MainReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanRenderFunc', -0x67)
   	SetValue('RenderingMod', Ptr($lTemp))
	SetValue('RenderingModReturn', Ptr($lTemp + 0xA))

   $lTemp = GetScannedAddress('ScanTargetLog', 0x1)
   SetValue('TargetLogStart', Ptr($lTemp))
   SetValue('TargetLogReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanSkillLog', 0x1)
   SetValue('SkillLogStart', Ptr($lTemp))
   SetValue('SkillLogReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanSkillCompleteLog', -0x4)
   SetValue('SkillCompleteLogStart', Ptr($lTemp))
   SetValue('SkillCompleteLogReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanSkillCancelLog', 0x5)
   SetValue('SkillCancelLogStart', Ptr($lTemp))
   SetValue('SkillCancelLogReturn', Ptr($lTemp + 0x6))

   $lTemp = GetScannedAddress('ScanChatLog', 0x12)
   SetValue('ChatLogStart', Ptr($lTemp))
   SetValue('ChatLogReturn', Ptr($lTemp + 0x6))

   $lTemp = GetScannedAddress('ScanTraderHook', -0x2F)
   SetValue('TraderHookStart', Ptr($lTemp))
   SetValue('TraderHookReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanDialogLog', -0x4)
   SetValue('DialogLogStart', Ptr($lTemp))
   SetValue('DialogLogReturn', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanStringFilter1', -0x5)
   SetValue('StringFilter1Start', Ptr($lTemp))
   SetValue('StringFilter1Return', Ptr($lTemp + 0x5))

   $lTemp = GetScannedAddress('ScanStringFilter2', 0x16)
   SetValue('StringFilter2Start', Ptr($lTemp))
   SetValue('StringFilter2Return', Ptr($lTemp + 0x5))

   SetValue('StringLogStart', Ptr(GetScannedAddress('ScanStringLog', 0x16)))

   SetValue('LoadFinishedStart', Ptr(GetScannedAddress('ScanLoadFinished', 0x1)))
   SetValue('LoadFinishedReturn', Ptr(GetScannedAddress('ScanLoadFinished', 0x6)))

   SetValue('PostMessage', Ptr(MemoryRead(GetScannedAddress('ScanPostMessage', 0xB))))
   SetValue('Sleep', MemoryRead(MemoryRead(GetValue('ScanSleep') + 0x8) + 0x3))

   SetValue('SalvageFunction', Ptr(GetScannedAddress('ScanSalvageFunction', -0xA)))
   SetValue('SalvageGlobal', Ptr(MemoryRead(GetScannedAddress('ScanSalvageGlobal', 1) - 0x4)))

   SetValue('IncreaseAttributeFunction', Ptr(GetScannedAddress('ScanIncreaseAttributeFunction', -0x5A)))
   SetValue("DecreaseAttributeFunction", Ptr(GetScannedAddress("ScanDecreaseAttributeFunction", 0x19)))

   SetValue('MoveFunction', Ptr(GetScannedAddress('ScanMoveFunction', 0x1)))
   SetValue('UseSkillFunction', Ptr(GetScannedAddress('ScanUseSkillFunction', -0x125)))

  ;SetValue('ChangeTargetFunction', Ptr(GetScannedAddress('ScanChangeTargetFunction', -0x0089) + 1, 8))
   SetValue('ChangeTargetFunction', Ptr(GetScannedAddress('ScanChangeTargetFunction', -0x0086) + 1))
   SetValue('WriteChatFunction', Ptr(GetScannedAddress('ScanWriteChatFunction', -0x3D)))

   SetValue('SellItemFunction', Ptr(GetScannedAddress('ScanSellItemFunction', -0x55)))
   SetValue('PacketSendFunction', Ptr(GetScannedAddress('ScanPacketSendFunction', -0x50)))

   SetValue('ActionBase', Ptr(MemoryRead(GetScannedAddress('ScanActionBase', -0x3))))
   SetValue('ActionFunction', Ptr(GetScannedAddress('ScanActionFunction', -0x3)))

   SetValue('UseHeroSkillFunction', Ptr(GetScannedAddress('ScanUseHeroSkillFunction', -0x59)))

   SetValue('BuyItemBase', Ptr(MemoryRead(GetScannedAddress('ScanBuyItemBase', 0xF))))

   SetValue('TransactionFunction', Ptr(GetScannedAddress('ScanTransactionFunction', -0x7E)))
   SetValue('RequestQuoteFunction', Ptr(GetScannedAddress('ScanRequestQuoteFunction', -0x34)))

   SetValue('TraderFunction', Ptr(GetScannedAddress('ScanTraderFunction', -0x1E)))
   SetValue('ClickToMoveFix', Ptr(GetScannedAddress("ScanClickToMoveFix", 0x1)))

   SetValue('ChangeStatusFunction', Ptr(GetScannedAddress("ScanChangeStatusFunction", 0x1)))

   SetValue('QueueSize', '0x00000010')
   SetValue('SkillLogSize', '0x00000010')
   SetValue('ChatLogSize', '0x00000010')
   SetValue('TargetLogSize', '0x00000200')
   SetValue('StringLogSize', '0x00000200')
   SetValue('CallbackEvent', '0x00000501')
   $MTradeHackAddress = GetScannedAddress("ScanTradeHack", 0)

   ModifyMemory()

   $mQueueCounter = MemoryRead(GetValue('QueueCounter'))
   $mQueueSize = GetValue('QueueSize') - 1
   $mQueueBase = GetValue('QueueBase')
   $mTargetLogBase = GetValue('TargetLogBase')
   $mStringLogBase = GetValue('StringLogBase')
   $mMapIsLoaded = GetValue('MapIsLoaded')
   $mEnsureEnglish = GetValue('EnsureEnglish')
   $mTraderQuoteID = GetValue('TraderQuoteID')
   $mTraderCostID = GetValue('TraderCostID')
   $mTraderCostValue = GetValue('TraderCostValue')
   $mDisableRendering = GetValue('DisableRendering')
   $mAgentCopyCount = GetValue('AgentCopyCount')
   $mAgentCopyBase = GetValue('AgentCopyBase')
   $mLastDialogID = GetValue('LastDialogID')

   If $mUseEventSystem Then
      MemoryWrite(GetValue('CallbackHandle'), $mGUI)
   EndIf

   DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mInviteGuild, 2, 0x4C)
   DllStructSetData($mUseSkill, 1, GetValue('CommandUseSkill'))
   DllStructSetData($mMove, 1, GetValue('CommandMove'))
   DllStructSetData($mChangeTarget, 1, GetValue('CommandChangeTarget'))
   DllStructSetData($mPacket, 1, GetValue('CommandPacketSend'))
   DllStructSetData($mSellItem, 1, GetValue('CommandSellItem'))
   DllStructSetData($mAction, 1, GetValue('CommandAction'))
   DllStructSetData($mToggleLanguage, 1, GetValue('CommandToggleLanguage'))
   DllStructSetData($mUseHeroSkill, 1, GetValue('CommandUseHeroSkill'))
   DllStructSetData($mBuyItem, 1, GetValue('CommandBuyItem'))
   DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
   DllStructSetData($mSendChat, 2, 0x0063) ; putting raw value, because $HEADER_SEND_CHAT_MESSAGE is used before declaration
   DllStructSetData($mWriteChat, 1, GetValue('CommandWriteChat'))
   DllStructSetData($mRequestQuote, 1, GetValue('CommandRequestQuote'))
   DllStructSetData($mRequestQuoteSell, 1, GetValue('CommandRequestQuoteSell'))
   DllStructSetData($mTraderBuy, 1, GetValue('CommandTraderBuy'))
   DllStructSetData($mTraderSell, 1, GetValue('CommandTraderSell'))
   DllStructSetData($mSalvage, 1, GetValue('CommandSalvage'))
   DllStructSetData($mIncreaseAttribute, 1, GetValue('CommandIncreaseAttribute'))
   DllStructSetData($mDecreaseAttribute, 1, GetValue('CommandDecreaseAttribute'))
   DllStructSetData($mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
   DllStructSetData($mChangeStatus, 1, GetValue('CommandChangeStatus'))

   If $bChangeTitle Then
      WinSetTitle($mGWWindowHandle, '', 'Guild Wars - ' & GetCharname())
   EndIf
   SetMaxMemory()

   Return $mGWWindowHandle
EndFunc  ;==>Initialize

;~ Description: Internal use only.
Func GetValue($aKey)
	For $i = 1 To $mLabels[0][0]
		If $mLabels[$i][0] = $aKey Then Return $mLabels[$i][1]
	Next
	Return -1
EndFunc   ;==>GetValue

;~ Description: Internal use only.
Func SetValue($aKey, $aValue)
	$mLabels[0][0] += 1
	ReDim $mLabels[$mLabels[0][0] + 1][2]
	$mLabels[$mLabels[0][0]][0] = $aKey
	$mLabels[$mLabels[0][0]][1] = $aValue
EndFunc   ;==>SetValue

;~ Description: Internal use only.
;~ Description: Scan patterns for Guild Wars game client.
Func Scan()
	Local $lGwBase = ScanForProcess()
	$mASMSize = 0
	$mASMCodeOffset = 0
	$mASMString = ''

	_('MainModPtr/4')

	; Scan patterns
	_('ScanBasePointer:')
	AddPattern('506A0F6A00FF35') ;85C0750F8BCE CHECKED ; STILL UPDATED 23.12.24

	_('ScanAgentBase:') ; Still in use? (16/06-2023)
	;AddPattern('FF50104783C6043BFB75E1') ; Still in use? (16/06-2023)
	AddPattern('FF501083C6043BF775E2') ; UPDATED 23.12.24

	_('ScanAgentArray:')
	AddPattern('8B0C9085C97419')

	_('ScanCurrentTarget:')
	AddPattern('83C4085F8BE55DC3CCCCCCCCCCCCCCCCCCCCCC55') ;UPDATED 23.12.24

	_('ScanEngine:')
	AddPattern('568B3085F67478EB038D4900D9460C') ; UPDATED 23.12.24 NEEDS TO GET UPDATED EACH PATCH

	_('ScanRenderFunc:')
	AddPattern('F6C401741C68B1010000BA') ; STILL WORKING 23.12.24

	_('ScanLoadFinished:')
	AddPattern('8B561C8BCF52E8') ; COULD NOT UPDATE! 23.12.24

	_('ScanPostMessage:')
	AddPattern('6A00680080000051FF15') ; COULD NOT UPDATE! 23.12.24

	_('ScanTargetLog:')
	AddPattern('5356578BFA894DF4E8') ; COULD NOT UPDATE! 23.12.24

	_('ScanChangeTargetFunction:')
	AddPattern('3BDF0F95') ; STILL WORKING 23.12.24, 33C03BDA0F95C033

	_('ScanMoveFunction:')
	AddPattern('558BEC83EC208D45F0') ; STILL WORKING 23.12.24, 558BEC83EC2056578BF98D4DF0

	_('ScanPing:')
	AddPattern('E874651600') ; UPDATED 23.12.24

;~ 	_('ScanMapID:')
;~ 	AddPattern('558BEC8B450885C074078B') ;STILL WORKING 23.12.24, B07F8D55

;~ 	_('ScanMapLoading:')
;~ 	AddPattern('2480ED0000000000') ; UPDATED 25.12.24, 6A2C50E8

	_('ScanLoggedIn:')
	AddPattern('C705ACDE740000000000C3CCCCCCCC') ; UPDATED 26.12.24, NEED TO GET UPDATED EACH PATCH OLD:BFFFC70580 85C07411B807

	_('ScanRegion:')
	AddPattern('6A548D46248908') ; STILL WORKING 23.12.24

;~ 	_('ScanMapInfo:')
;~ 	AddPattern('8BF0EB038B750C3B') ; STILL WORKING 23.12.24, 83F9FD7406

;~ 	_('ScanLanguage:')
;~ 	AddPattern('C38B75FC8B04B5') ; COULD NOT UPDATE! 23.12.24

	_('ScanUseSkillFunction:')
	AddPattern('85F6745B83FE1174') ; STILL WORKING 23.12.24, 558BEC83EC1053568BD9578BF2895DF0

	_('ScanPacketSendFunction:')
	AddPattern('C747540000000081E6') ;UPDATED 28.12.24 old: F7D9C74754010000001BC981, 558BEC83EC2C5356578BF985

	_('ScanBaseOffset:')
	AddPattern('83C40433C08BE55DC3A1') ; STILL WORKING 23.12.24, 5633F63BCE740E5633D2

	_('ScanWriteChatFunction:')
	AddPattern('8D85E0FEFFFF50681C01') ;STILL WORKING 23.12.24, 558BEC5153894DFC8B4D0856578B

	_('ScanSkillLog:')
	AddPattern('408946105E5B5D') ; COULD NOT UPDATE! 23.12.24

	_('ScanSkillCompleteLog:')
	AddPattern('741D6A006A40') ; COULD NOT UPDATE! 23.12.24

	_('ScanSkillCancelLog:')
	AddPattern('741D6A006A48') ; COULD NOT UPDATE! 23.12.24

	_('ScanChatLog:')
	AddPattern('8B45F48B138B4DEC50') ; COULD NOT UPDATE! 23.12.24

	_('ScanSellItemFunction:')
	AddPattern('8B4D2085C90F858E') ; COULD NOT UPDATE! 23.12.24

	_('ScanStringLog:')
	AddPattern('893E8B7D10895E04397E08') ; COULD NOT UPDATE! 23.12.24

	_('ScanStringFilter1:')
	AddPattern('8B368B4F2C6A006A008B06') ; COULD NOT UPDATE! 23.12.24

	_('ScanStringFilter2:')
	AddPattern('515356578BF933D28B4F2C') ; COULD NOT UPDATE! 23.12.24

	_('ScanActionFunction:')
	AddPattern('8B7508578BF983FE09750C6876') ;STILL WORKING 23.12.24, ;8B7D0883FF098BF175116876010000

	_('ScanActionBase:')
	AddPattern('8D1C87899DF4') ; UPDATED 24.12.24, OLD: 8D1C87899DF4FEFFFF8BC32BC7C1F802, 8B4208A80175418B4A08

	_('ScanSkillBase:')
	AddPattern('8D04B6C1E00505') ;STILL WORKING 23.12.24 ;8D 04 B6 C1 E0 05 05

	_('ScanUseHeroSkillFunction:')
	AddPattern('BA02000000B954080000') ;STILL WORKING 23.12.24

	_('ScanTransactionFunction:')
	AddPattern('85FF741D8B4D14EB08') ;STILL WORKING 23.12.24 ;558BEC81ECC000000053568B75085783FE108BFA8BD97614

	_('ScanBuyItemFunction:') ; Still in use? (16/06-2023)
	AddPattern('D9EED9580CC74004') ;STILL WORKING 23.12.24 ; Still in use? (16/06-2023)

	_('ScanBuyItemBase:')
	AddPattern('D9EED9580CC74004') ;STILL WORKING 23.12.24

	_('ScanRequestQuoteFunction:')
	AddPattern('8B752083FE107614')  ;STILL WORKING 23.12.24;8B750C5783FE107614 ;53568B750C5783FE10

	_('ScanTraderFunction:')
	;AddPattern('8B45188B551085') ;83FF10761468
	AddPattern('83FF10761468D2210000') ;STILL WORKING 23.12.24

	_('ScanTraderHook:')
	AddPattern('50516A466A06')

	_('ScanSleep:')
	AddPattern('6A0057FF15D8408A006860EA0000') ; UPDATED 24.12.24, OLD:5F5E5B741A6860EA0000

	_('ScanSalvageFunction:')
	AddPattern('33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC76') ; UPDATED 24.12.24 OLD:33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC75
	;AddPattern('8BFA8BD9897DF0895DF4')

	_('ScanSalvageGlobal:')
	AddPattern('8B4A04538945F48B4208') ; UPDATED 24.12.24, OLD: 8B5104538945F48B4108568945E88B410C578945EC8B4110528955E48945F0
	;AddPattern('8B018B4904A3')

	_('ScanIncreaseAttributeFunction:')
	AddPattern('8B7D088B702C8B1F3B9E00050000') ;STILL WORKING 23.12.24, 8B702C8B3B8B86

	_("ScanDecreaseAttributeFunction:")
	AddPattern("8B8AA800000089480C5DC3CC") ;STILL WORKING 23.12.24, 8B402C8BCE059C0000008B1089118B50

	_('ScanSkillTimer:')
	AddPattern('FFD68B4DF08BD88B4708') ;STILL WORKING 23.12.24, 85c974158bd62bd183fa64

	_('ScanClickToMoveFix:')
	AddPattern('3DD301000074') ;STILL WORKING 23.12.24,

	_('ScanZoomStill:')
	AddPattern('558BEC8B41085685C0') ; COULD NOT UPDATE! 23.12.24

	_('ScanZoomMoving:')
	AddPattern('EB358B4304') ; COULD NOT UPDATE! 23.12.24

	_('ScanChangeStatusFunction:')
	AddPattern('558BEC568B750883FE047C14') ;STILL WORKING 23.12.24, 568BF183FE047C14682F020000

	_('ScanCharslots:')
	AddPattern('8B551041897E38897E3C897E34897E48897E4C890D') ; COULD NOT UPDATE! 23.12.24

	_('ScanReadChatFunction:')
	AddPattern('A128B6EB00') ; COULD NOT UPDATE! 23.12.24

	_('ScanDialogLog:')
	AddPattern('8B45088945FC8D45F8506A08C745F841') ;STILL WORKING 23.12.24, 558BEC83EC285356578BF28BD9

	_("ScanTradeHack:")
	AddPattern("8BEC8B450883F846") ;STILL WORKING 23.12.24

	_("ScanClickCoords:")
	AddPattern("8B451C85C0741CD945F8") ;STILL WORKING 23.12.24

	_("ScanInstanceInfo:")
	AddPattern("6A2C50E80000000083C408C7") ;Added by Greg76 to get Instance Info

	_("ScanAreaInfo:")
	AddPattern("6BC67C5E05") ;Added by Greg76 to get Area Info

	_("ScanAttributeInfo:")
	AddPattern("BA3300000089088d4004") ;Added by Greg76 to get Attribute Info

	_("ScanWorldConst:")
	AddPattern("8D0476C1E00405") ;Added by Greg76 to get World Info

	_('ScanProc:') ; Label for the scan procedure
	_('pushad') ; Push all general-purpose registers onto the stack to save their values
	_('mov ecx,' & Hex($lGwBase, 8)) ; Move the base address of the Guild Wars process into the ECX register
	_('mov esi,ScanProc') ; Move the address of the ScanProc label into the ESI register
	_('ScanLoop:') ; Label for the scan loop
	_('inc ecx') ; Increment the value in the ECX register by 1
	_('mov al,byte[ecx]') ; Move the byte value at the address stored in ECX into the AL register
	_('mov edx,ScanBasePointer') ; Move the address of the ScanBasePointer into the EDX register


	_('ScanInnerLoop:') ; Label for the inner scan loop
	_('mov ebx,dword[edx]') ; Move the 4-byte value at the address stored in EDX into the EBX register
	_('cmp ebx,-1') ; Compare the value in EBX to -1
	_('jnz ScanContinue') ; Jump to the ScanContinue label if the comparison is not zero
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero
	_('jmp ScanExit') ; Jump to the ScanExit label


	_('ScanContinue:') ; Label for the scan continue section
	_('lea edi,dword[edx+ebx]') ; Load the effective address of the value at EDX + EBX into the EDI register
	_('add edi,C') ; Add the value of C to the address in EDI
	_('mov ah,byte[edi]') ; Move the byte value at the address stored in EDI into the AH register
	_('cmp al,ah') ; Compare the value in AL to the value in AH
	_('jz ScanMatched') ; Jump to the ScanMatched label if the comparison is zero (i.e., the values match)
	_('cmp ah,00')    ;Added by Greg76 for scan wildcards
	_('jz ScanMatched')    ;Added by Greg76 for scan wildcards
	_('mov dword[edx],0') ; Move the value 0 into the 4-byte location at the address stored in EDX
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero
	_('jmp ScanExit') ; Jump to the ScanExit label


	_('ScanMatched:') ; Label for the scan matched section
	_('inc ebx') ; Increment the value in the EBX register by 1
	_('mov edi,dword[edx+4]') ; Move the 4-byte value at the address EDX + 4 into the EDI register
	_('cmp ebx,edi') ; Compare the value in EBX to the value in EDI
	_('jz ScanFound') ; Jump to the ScanFound label if the comparison is zero (i.e., the values match)
	_('mov dword[edx],ebx') ; Move the value in EBX into the 4-byte location at the address stored in EDX
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero
	_('jmp ScanExit') ; Jump to the ScanExit label


	_('ScanFound:') ; Label for the scan found section
	_('lea edi,dword[edx+8]') ; Load the effective address of the value at EDX + 8 into the EDI register
	_('mov dword[edi],ecx') ; Move the value in ECX into the 4-byte location at the address stored in EDI
	_('mov dword[edx],-1') ; Move the value -1 into the 4-byte location at the address stored in EDX (mark as found)
	_('add edx,50') ; Add 50 to the value in the EDX register
	_('cmp edx,esi') ; Compare the value in EDX to the value in ESI
	_('jnz ScanInnerLoop') ; Jump to the ScanInnerLoop label if the comparison is not zero
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8))) ; Compare the value in ECX to a specific address (+4FF000)
	_('jnz ScanLoop') ; Jump to the ScanLoop label if the comparison is not zero

	_('ScanExit:') ; Label for the scan exit section
	_('popad') ; Pop all general-purpose registers from the stack to restore their original values
	_('retn') ; Return from the current function (exit the scan routine)


	$mBase = $lGwBase + 0x9DF000
	Local $lScanMemory = MemoryRead($mBase, 'ptr')

	; Check if the scan memory address is empty (no previous injection)
	If $lScanMemory = 0 Then
		; Allocate a new block of memory for the scan routine
		$mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 0x40)
		$mMemory = $mMemory[0] ; Get the allocated memory address

		; Write the allocated memory address to the scan memory location
		MemoryWrite($mBase, $mMemory)

;~ out("First Inject: " & $mMemory)
	Else
		; If the scan memory address is not empty, use the existing memory address
		$mMemory = $lScanMemory
	EndIf


	; Complete the assembly code for the scan routine
	CompleteASMCode()

	; Check if this is the first injection (no previous scan memory address)
	If $lScanMemory = 0 Then
		; Write the assembly code to the allocated memory address
		WriteBinary($mASMString, $mMemory + $mASMCodeOffset)

		; Create a new thread in the target process to execute the scan routine
		Local $lThread = DllCall($mKernelHandle, 'int', 'CreateRemoteThread', 'int', $mGWProcHandle, 'ptr', 0, 'int', 0, 'int', GetLabelInfo('ScanProc'), 'ptr', 0, 'int', 0, 'int', 0)
		$lThread = $lThread[0] ; Get the thread ID

		; Wait for the thread to finish executing
		Local $lResult
		Do
			; Wait for up to 50ms for the thread to finish
			$lResult = DllCall($mKernelHandle, 'int', 'WaitForSingleObject', 'int', $lThread, 'int', 50)
		Until $lResult[0] <> 258 ; Wait until the thread is no longer waiting (258 is the WAIT_TIMEOUT constant)

		; Close the thread handle to free up system resources
		DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $lThread)
	EndIf
EndFunc   ;==>Scan

; **Function to Retrieve Guild Wars Process Base Address**
Func GetGWBase()
	; **Scan for Guild Wars Process and Get Base Address**
	Local $lGwBase = ScanForProcess() - 4096 ; Subtract 4096 from the process address to get the base address

	; **Convert Base Address to Hexadecimal String**
	$lGwBase = Ptr($lGwBase) ; Prefix the hexadecimal value with "0x"

	; **Return Base Address as Hexadecimal String**
	Return $lGwBase
EndFunc   ;==>GetGWBase

Func ScanForProcess()
	Local $lCharNameCode = BinaryToString('0x558BEC83EC105356578B7D0833F63BFE')
	Local $lCurrentSearchAddress = 0x00000000
	Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

	While $lCurrentSearchAddress < 0x01F00000
		Local $lMBI[7]
		DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
		For $i = 0 To 6
			$lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
		Next
		If $lMBI[4] = 4096 Then
			Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

			$lTmpMemData = DllStructGetData($lBuffer, 1)
			$lTmpMemData = BinaryToString($lTmpMemData)

			$lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
			If $lSearch > 0 Then
				Return $lMBI[0]
			EndIf
		EndIf
		$lCurrentSearchAddress += $lMBI[3]
	WEnd
	Return ''
EndFunc   ;==>ScanForProcess

;~ Description: Internal use only.
Func AddPattern($aPattern) ;modified by Greg76 for scan wildcards
    Local $lSize = Int(0.5 * StringLen($aPattern))
    Local $pattern_header = "00000000" & _
                           SwapEndian(Hex($lSize, 8)) & _
                           "00000000"

    $mASMString &= $pattern_header & $aPattern
    $mASMSize += $lSize + 12

    Local $padding_count = 68 - $lSize
    For $i = 1 To $padding_count
        $mASMSize += 1
        $mASMString &= "00"
    Next
EndFunc

;~ Description: Internal use only.
Func GetScannedAddress($aLabel, $aOffset)
	Return MemoryRead(GetLabelInfo($aLabel) + 8) - MemoryRead(GetLabelInfo($aLabel) + 4) + $aOffset
EndFunc   ;==>GetScannedAddress

;~ Description: Internal use only.
Func ScanForCharname()
	Local $lCharNameCode = BinaryToString('0x6A14FF751868') ;0x90909066C705
	Local $lCurrentSearchAddress = 0x00000000 ;0x00401000
	Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

	While $lCurrentSearchAddress < 0x01F00000
		Local $lMBI[7]
		DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
		For $i = 0 To 6
			$lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
		Next
		If $lMBI[4] = 4096 Then
			Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

			$lTmpMemData = DllStructGetData($lBuffer, 1)
			$lTmpMemData = BinaryToString($lTmpMemData)

			$lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
			If $lSearch > 0 Then
				$lTmpAddress = $lCurrentSearchAddress + $lSearch - 1
				DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lTmpAddress + 6, 'ptr', DllStructGetPtr($lTmpBuffer), 'int', DllStructGetSize($lTmpBuffer), 'int', '')
				$mCharname = DllStructGetData($lTmpBuffer, 1)
				Return GetCharname()
			EndIf
		EndIf
		$lCurrentSearchAddress += $lMBI[3]
	WEnd
	Return ''
EndFunc   ;==>ScanForCharname
#EndRegion Initialisation

#Region Assembler
Func _($aASM)
	Local $lBuffer
	Local $lOpCode
	Select
		Case StringInStr($aASM, ' -> ')
			Local $split = StringSplit($aASM, ' -> ', 1)
			$lOpCode = StringReplace($split[2], ' ', '')
			$mASMSize += 0.5 * StringLen($lOpCode)
			$mASMString &= $lOpCode
		Case StringLeft($aASM, 3) = 'jb '
			$mASMSize += 2
			$mASMString &= '72(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 3) = 'je '
			$mASMSize += 2
			$mASMString &= '74(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringRegExp($aASM, 'cmp ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81FB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'cmp edx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81FA[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRight($aASM, 1) = ':'
			SetValue('Label_' & StringLeft($aASM, StringLen($aASM) - 1), $mASMSize)
		Case StringInStr($aASM, '/') > 0
			SetValue('Label_' & StringLeft($aASM, StringInStr($aASM, '/') - 1), $mASMSize)
			Local $lOffset = StringRight($aASM, StringLen($aASM) - StringInStr($aASM, '/'))
			$mASMSize += $lOffset
			$mASMCodeOffset += $lOffset
		Case StringLeft($aASM, 5) = 'nop x'
			$lBuffer = Int(Number(StringTrimLeft($aASM, 5)))
			$mASMSize += $lBuffer
			For $i = 1 To $lBuffer
				$mASMString &= '90'
			Next
		Case StringLeft($aASM, 5) = 'ljmp '
			$mASMSize += 5
			$mASMString &= 'E9{' & StringRight($aASM, StringLen($aASM) - 5) & '}'
		Case StringLeft($aASM, 5) = 'ljne '
			$mASMSize += 6
			$mASMString &= '0F85{' & StringRight($aASM, StringLen($aASM) - 5) & '}'
		Case StringLeft($aASM, 4) = 'jmp ' And StringLen($aASM) > 7
			$mASMSize += 2
			$mASMString &= 'EB(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 4) = 'jae '
			$mASMSize += 2
			$mASMString &= '73(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 3) = 'jz '
			$mASMSize += 2
			$mASMString &= '74(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 4) = 'jnz '
			$mASMSize += 2
			$mASMString &= '75(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 4) = 'jbe '
			$mASMSize += 2
			$mASMString &= '76(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 3) = 'ja '
			$mASMSize += 2
			$mASMString &= '77(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 3) = 'jl '
			$mASMSize += 2
			$mASMString &= '7C(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 4) = 'jge '
			$mASMSize += 2
			$mASMString &= '7D(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 4) = 'jle '
			$mASMSize += 2
			$mASMString &= '7E(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringRegExp($aASM, 'mov eax,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 5
			$mASMString &= 'A1[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov ebx,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B1D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov ecx,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B0D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov edx,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B15[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov esi,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B35[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov edi,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B3D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'cmp ebx,dword\[[a-z,A-Z]{4,}\]')
			$mASMSize += 6
			$mASMString &= '3B1D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'lea eax,dword[[]ecx[*]8[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8D04CD[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'lea edi,dword\[edx\+[a-z,A-Z]{4,}\]')
			$mASMSize += 7
			$mASMString &= '8D3C15[' & StringMid($aASM, 19, StringLen($aASM) - 19) & ']'
		Case StringRegExp($aASM, 'cmp dword[[][a-z,A-Z]{4,}[]],[-[:xdigit:]]')
			$lBuffer = StringInStr($aASM, ',')
			$lBuffer = ASMNumber(StringMid($aASM, $lBuffer + 1), True)
			If @extended Then
				$mASMSize += 7
				$mASMString &= '833D[' & StringMid($aASM, 11, StringInStr($aASM, ',') - 12) & ']' & $lBuffer
			Else
				$mASMSize += 10
				$mASMString &= '813D[' & StringMid($aASM, 11, StringInStr($aASM, ',') - 12) & ']' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'cmp ecx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81F9[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'cmp ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81FB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'cmp eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= '3D[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'add eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= '05[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'B8[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov ecx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'B9[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov esi,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BE[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov edi,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BF[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov edx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BA[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],ecx')
			$mASMSize += 6
			$mASMString &= '890D[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'fstp dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= 'D91D[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
		Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],edx')
			$mASMSize += 6
			$mASMString &= '8915[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],eax')
			$mASMSize += 5
			$mASMString &= 'A3[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'lea eax,dword[[]edx[*]4[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8D0495[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'mov eax,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8B048D[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'mov ecx,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8B0C8D[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'push dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= 'FF35[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
		Case StringRegExp($aASM, 'push [a-z,A-Z]{4,}\z')
			$mASMSize += 5
			$mASMString &= '68[' & StringMid($aASM, 6, StringLen($aASM) - 5) & ']'
		Case StringRegExp($aASM, 'call dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= 'FF15[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
		Case StringLeft($aASM, 5) = 'call ' And StringLen($aASM) > 8
			$mASMSize += 5
			$mASMString &= 'E8{' & StringMid($aASM, 6, StringLen($aASM) - 5) & '}'
		Case StringRegExp($aASM, 'mov dword\[[a-z,A-Z]{4,}\],[-[:xdigit:]]{1,8}\z')
			$lBuffer = StringInStr($aASM, ',')
			$mASMSize += 10
			$mASMString &= 'C705[' & StringMid($aASM, 11, $lBuffer - 12) & ']' & ASMNumber(StringMid($aASM, $lBuffer + 1))
		Case StringRegExp($aASM, 'push [-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 6), True)
			If @extended Then
				$mASMSize += 2
				$mASMString &= '6A' & $lBuffer
			Else
				$mASMSize += 5
				$mASMString &= '68' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'mov eax,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'B8' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'mov ebx,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'BB' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'mov ecx,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'B9' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'mov edx,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'BA' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'add eax,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C0' & $lBuffer
			Else
				$mASMSize += 5
				$mASMString &= '05' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add ebx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C3' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C3' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add ecx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C1' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C1' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add edx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C2' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C2' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add edi,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C7' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C7' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add esi,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C6' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C6' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add esp,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C4' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C4' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'cmp ebx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83FB' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81FB' & $lBuffer
			EndIf
		Case StringLeft($aASM, 8) = 'cmp ecx,' And StringLen($aASM) > 10
			Local $lOpCode = '81F9' & StringMid($aASM, 9)
			$mASMSize += 0.5 * StringLen($lOpCode)
			$mASMString &= $lOpCode
		Case Else
			Local $lOpCode
			Switch $aASM
				Case 'Flag_'
					$lOpCode = '9090903434'
				Case 'nop'
					$lOpCode = '90'
				Case 'pushad'
					$lOpCode = '60'
				Case 'popad'
					$lOpCode = '61'
				Case 'mov ebx,dword[eax]'
					$lOpCode = '8B18'
				Case 'mov ebx,dword[ecx]'            ; added
					$lOpCode = '8B19'                ; added
				Case 'mov ecx,dword[ebx+ecx]'        ; added
					$lOpCode = '8B0C0B'                ; added
				Case 'test eax,eax'
					$lOpCode = '85C0'
				Case 'test ebx,ebx'
					$lOpCode = '85DB'
				Case 'test ecx,ecx'
					$lOpCode = '85C9'
				Case 'mov dword[eax],0'
					$lOpCode = 'C70000000000'
				Case 'push eax'
					$lOpCode = '50'
				Case 'push ebx'
					$lOpCode = '53'
				Case 'push ecx'
					$lOpCode = '51'
				Case 'push edx'
					$lOpCode = '52'
				Case 'push ebp'
					$lOpCode = '55'
				Case 'push esi'
					$lOpCode = '56'
				Case 'push edi'
					$lOpCode = '57'
				Case 'jmp ebx'
					$lOpCode = 'FFE3'
				Case 'pop eax'
					$lOpCode = '58'
				Case 'pop ebx'
					$lOpCode = '5B'
				Case 'pop edx'
					$lOpCode = '5A'
				Case 'pop ecx'
					$lOpCode = '59'
				Case 'pop esi'
					$lOpCode = '5E'
				Case 'inc eax'
					$lOpCode = '40'
				Case 'inc ecx'
					$lOpCode = '41'
				Case 'inc ebx'
					$lOpCode = '43'
				Case 'dec edx'
					$lOpCode = '4A'
				Case 'mov edi,edx'
					$lOpCode = '8BFA'
				Case 'mov ecx,esi'
					$lOpCode = '8BCE'
				Case 'mov ecx,edi'
					$lOpCode = '8BCF'
				Case 'mov ecx,esp'
					$lOpCode = '8BCC'
				Case 'xor eax,eax'
					$lOpCode = '33C0'
				Case 'xor ecx,ecx'
					$lOpCode = '33C9'
				Case 'xor edx,edx'
					$lOpCode = '33D2'
				Case 'xor ebx,ebx'
					$lOpCode = '33DB'
				Case 'mov edx,eax'
					$lOpCode = '8BD0'
				Case 'mov edx,ecx'
					$lOpCode = '8BD1'
				Case 'mov ebp,esp'
					$lOpCode = '8BEC'
				Case 'sub esp,8'
					$lOpCode = '83EC08'
				Case 'sub esi,4'
					$lOpCode = '83EE04'
				Case 'sub esp,14'
					$lOpCode = '83EC14'
				Case 'sub eax,C'
					$lOpCode = '83E80C'
				Case 'cmp ecx,4'
					$lOpCode = '83F904'
				Case 'cmp ecx,32'
					$lOpCode = '83F932'
				Case 'cmp ecx,3C'
					$lOpCode = '83F93C'
				Case 'mov ecx,edx'
					$lOpCode = '8BCA'
				Case 'mov eax,ecx'
					$lOpCode = '8BC1'
				Case 'mov ecx,dword[ebp+8]'
					$lOpCode = '8B4D08'
				Case 'mov ecx,dword[esp+1F4]'
					$lOpCode = '8B8C24F4010000'
				Case 'mov ecx,dword[edi+4]'
					$lOpCode = '8B4F04'
				Case 'mov ecx,dword[edi+8]'
					$lOpCode = '8B4F08'
				Case 'mov eax,dword[edi+4]'
					$lOpCode = '8B4704'
				Case 'mov dword[eax+4],ecx'
					$lOpCode = '894804'
				Case 'mov dword[eax+8],ebx'
					$lOpCode = '895808'
				Case 'mov dword[eax+8],ecx'
					$lOpCode = '894808'
				Case 'mov dword[eax+C],ecx'
					$lOpCode = '89480C'
				Case 'mov dword[esi+10],eax'
					$lOpCode = '894610'
				Case 'mov ecx,dword[edi]'
					$lOpCode = '8B0F'
				Case 'mov dword[eax],ecx'
					$lOpCode = '8908'
				Case 'mov dword[eax],ebx'
					$lOpCode = '8918'
				Case 'mov edx,dword[eax+4]'
					$lOpCode = '8B5004'
				Case 'mov edx,dword[eax+8]'
					$lOpCode = '8B5008'
				Case 'mov edx,dword[eax+c]'
					$lOpCode = '8B500C'
				Case 'mov edx,dword[esi+1c]'
					$lOpCode = '8B561C'
				Case 'push dword[eax+8]'
					$lOpCode = 'FF7008'
				Case 'lea eax,dword[eax+18]'
					$lOpCode = '8D4018'
				Case 'lea ecx,dword[eax+4]'
					$lOpCode = '8D4804'
				Case 'lea ecx,dword[eax+C]'
					$lOpCode = '8D480C'
				Case 'lea eax,dword[eax+4]'
					$lOpCode = '8D4004'
				Case 'lea edx,dword[eax]'
					$lOpCode = '8D10'
				Case 'lea edx,dword[eax+4]'
					$lOpCode = '8D5004'
				Case 'lea edx,dword[eax+8]'
					$lOpCode = '8D5008'
				Case 'mov ecx,dword[eax+4]'
					$lOpCode = '8B4804'
				Case 'mov esi,dword[eax+4]'
					$lOpCode = '8B7004'
				Case 'mov esp,dword[eax+4]'
					$lOpCode = '8B6004'
				Case 'mov ecx,dword[eax+8]'
					$lOpCode = '8B4808'
				Case 'mov eax,dword[eax+8]'
					$lOpCode = '8B4008'
				Case 'mov eax,dword[eax+C]'
					$lOpCode = '8B400C'
				Case 'mov ebx,dword[eax+4]'
					$lOpCode = '8B5804'
				Case 'mov ebx,dword[eax]'
					$lOpCode = '8B10'
				Case 'mov ebx,dword[eax+8]'
					$lOpCode = '8B5808'
				Case 'mov ebx,dword[eax+C]'
					$lOpCode = '8B580C'
				Case 'mov ebx,dword[ecx+148]'
					$lOpCode = '8B9948010000'
				Case 'mov ecx,dword[ebx+13C]'
					$lOpCode = '8B9B3C010000'
				Case 'mov ebx,dword[ebx+F0]'
					$lOpCode = '8B9BF0000000'
				Case 'mov ecx,dword[eax+C]'
					$lOpCode = '8B480C'
				Case 'mov ecx,dword[eax+10]'
					$lOpCode = '8B4810'
				Case 'mov eax,dword[eax+4]'
					$lOpCode = '8B4004'
				Case 'push dword[eax+4]'
					$lOpCode = 'FF7004'
				Case 'push dword[eax+c]'
					$lOpCode = 'FF700C'
				Case 'mov esp,ebp'
					$lOpCode = '8BE5'
				Case 'mov esp,ebp'
					$lOpCode = '8BE5'
				Case 'pop ebp'
					$lOpCode = '5D'
				Case 'retn 10'
					$lOpCode = 'C21000'
				Case 'cmp eax,2'
					$lOpCode = '83F802'
				Case 'cmp eax,0'
					$lOpCode = '83F800'
				Case 'cmp eax,B'
					$lOpCode = '83F80B'
				Case 'cmp eax,200'
					$lOpCode = '3D00020000'
				Case 'shl eax,4'
					$lOpCode = 'C1E004'
				Case 'shl eax,8'
					$lOpCode = 'C1E008'
				Case 'shl eax,6'
					$lOpCode = 'C1E006'
				Case 'shl eax,7'
					$lOpCode = 'C1E007'
				Case 'shl eax,8'
					$lOpCode = 'C1E008'
				Case 'shl eax,9'
					$lOpCode = 'C1E009'
				Case 'mov edi,eax'
					$lOpCode = '8BF8'
				Case 'mov dx,word[ecx]'
					$lOpCode = '668B11'
				Case 'mov dx,word[edx]'
					$lOpCode = '668B12'
				Case 'mov word[eax],dx'
					$lOpCode = '668910'
				Case 'test dx,dx'
					$lOpCode = '6685D2'
				Case 'cmp word[edx],0'
					$lOpCode = '66833A00'
				Case 'cmp eax,ebx'
					$lOpCode = '3BC3'
				Case 'cmp eax,ecx'
					$lOpCode = '3BC1'
				Case 'mov eax,dword[esi+8]'
					$lOpCode = '8B4608'
				Case 'mov ecx,dword[eax]'
					$lOpCode = '8B08'
				Case 'mov ebx,edi'
					$lOpCode = '8BDF'
				Case 'mov ebx,eax'
					$lOpCode = '8BD8'
				Case 'mov eax,edi'
					$lOpCode = '8BC7'
				Case 'mov al,byte[ebx]'
					$lOpCode = '8A03'
				Case 'test al,al'
					$lOpCode = '84C0'
				Case 'mov eax,dword[ecx]'
					$lOpCode = '8B01'
				Case 'lea ecx,dword[eax+180]'
					$lOpCode = '8D8880010000'
				Case 'mov ebx,dword[ecx+14]'
					$lOpCode = '8B5914'
				Case 'mov eax,dword[ebx+c]'
					$lOpCode = '8B430C'
				Case 'mov ecx,eax'
					$lOpCode = '8BC8'
				Case 'cmp eax,-1'
					$lOpCode = '83F8FF'
				Case 'mov al,byte[ecx]'
					$lOpCode = '8A01'
				Case 'mov ebx,dword[edx]'
					$lOpCode = '8B1A'
				Case 'lea edi,dword[edx+ebx]'
					$lOpCode = '8D3C1A'
				Case 'mov ah,byte[edi]'
					$lOpCode = '8A27'
				Case 'cmp al,ah'
					$lOpCode = '3AC4'
				Case 'mov dword[edx],0'
					$lOpCode = 'C70200000000'
				Case 'mov dword[ebx],ecx'
					$lOpCode = '890B'
				Case 'cmp edx,esi'
					$lOpCode = '3BD6'
				Case 'cmp ecx,1050000'
					$lOpCode = '81F900000501'
				Case 'mov edi,dword[edx+4]'
					$lOpCode = '8B7A04'
				Case 'mov edi,dword[eax+4]'
					$lOpCode = '8B7804'
				Case $aASM = 'mov ecx,dword[E1D684]'
					$lOpCode = '8B0D84D6E100'
				Case $aASM = 'mov dword[edx-0x70],ecx'
					$lOpCode = '894A90'
				Case $aASM = 'mov ecx,dword[edx+0x1C]'
					$lOpCode = '8B4A1C'
				Case $aASM = 'mov dword[edx+0x54],ecx'
					$lOpCode = '894A54'
				Case $aASM = 'mov ecx,dword[edx+4]'
					$lOpCode = '8B4A04'
				Case $aASM = 'mov dword[edx-0x14],ecx'
					$lOpCode = '894AEC'
				Case 'cmp ebx,edi'
					$lOpCode = '3BDF'
				Case 'mov dword[edx],ebx'
					$lOpCode = '891A'
				Case 'lea edi,dword[edx+8]'
					$lOpCode = '8D7A08'
				Case 'mov dword[edi],ecx'
					$lOpCode = '890F'
				Case 'retn'
					$lOpCode = 'C3'
				Case 'mov dword[edx],-1'
					$lOpCode = 'C702FFFFFFFF'
				Case 'cmp eax,1'
					$lOpCode = '83F801'
				Case 'mov eax,dword[ebp+37c]'
					$lOpCode = '8B857C030000'
				Case 'mov eax,dword[ebp+338]'
					$lOpCode = '8B8538030000'
				Case 'mov ecx,dword[ebx+250]'
					$lOpCode = '8B8B50020000'
				Case 'mov ecx,dword[ebx+194]'
					$lOpCode = '8B8B94010000'
				Case 'mov ecx,dword[ebx+18]'
					$lOpCode = '8B5918'
				Case 'mov ecx,dword[ebx+40]'
					$lOpCode = '8B5940'
				Case 'mov ebx,dword[ecx+10]'
					$lOpCode = '8B5910'
				Case 'mov ebx,dword[ecx+18]'
					$lOpCode = '8B5918'
				Case 'mov ebx,dword[ecx+4c]'
					$lOpCode = '8B594C'
				Case 'mov ecx,dword[ebx]'
					$lOpCode = '8B0B'
				Case 'mov edx,esp'
					$lOpCode = '8BD4'
				Case 'mov ecx,dword[ebx+170]'
					$lOpCode = '8B8B70010000'
				Case 'cmp eax,dword[esi+9C]'
					$lOpCode = '3B869C000000'
				Case 'mov ebx,dword[ecx+20]'
					$lOpCode = '8B5920'
				Case 'mov ecx,dword[ecx]'
					$lOpCode = '8B09'
				Case 'mov eax,dword[ecx+40]'
					$lOpCode = '8B4140'
				Case 'mov ecx,dword[ecx+4]'
					$lOpCode = '8B4904'
					;			Case 'mov ecx,dword[ecx+Ñ]'		; Removed following April update
					;				$lOpCode = '8B490C'			; Removed following April update
				Case 'mov ecx,dword[ecx+8]'
					$lOpCode = '8B4908'
				Case 'mov ecx,dword[ecx+34]'
					$lOpCode = '8B4934'
				Case 'mov ecx,dword[ecx+C]'
					$lOpCode = '8B490C'
				Case 'mov ecx,dword[ecx+10]'
					$lOpCode = '8B4910'
				Case 'mov ecx,dword[ecx+18]'
					$lOpCode = '8B4918'
				Case 'mov ecx,dword[ecx+20]'
					$lOpCode = '8B4920'
				Case 'mov ecx,dword[ecx+4c]'
					$lOpCode = '8B494C'
				Case 'mov ecx,dword[ecx+50]'
					$lOpCode = '8B4950'
				Case 'mov ecx,dword[ecx+148]'    ; this was added following April update
					$lOpCode = '8B8948010000'    ; this was added following April update
				Case 'mov ecx,dword[ecx+170]'
					$lOpCode = '8B8970010000'
				Case 'mov ecx,dword[ecx+194]'
					$lOpCode = '8B8994010000'
				Case 'mov ecx,dword[ecx+250]'
					$lOpCode = '8B8950020000'
				Case 'mov ecx,dword[ecx+134]'
					$lOpCode = '8B8934010000'
				Case 'mov ecx,dword[ecx+13C]'
					$lOpCode = '8B893C010000'
				Case 'mov al,byte[ecx+4f]'
					$lOpCode = '8A414F'
				Case 'mov al,byte[ecx+3f]'
					$lOpCode = '8A413F'
				Case 'cmp al,f'
					$lOpCode = '3C0F'
				Case 'lea esi,dword[esi+ebx*4]'
					$lOpCode = '8D349E'
				Case 'mov esi,dword[esi]'
					$lOpCode = '8B36'
				Case 'test esi,esi'
					$lOpCode = '85F6'
				Case 'clc'
					$lOpCode = 'F8'
				Case 'repe movsb'
					$lOpCode = 'F3A4'
				Case 'inc edx'
					$lOpCode = '42'
				Case 'mov eax,dword[ebp+8]'
					$lOpCode = '8B4508'
				Case 'mov eax,dword[ecx+8]'
					$lOpCode = '8B4108'
				Case 'test al,1'
					$lOpCode = 'A801'
				Case $aASM = 'mov eax,[eax+2C]'
					$lOpCode = '8B402C'
				Case $aASM = 'mov eax,[eax+680]'
					$lOpCode = '8B8080060000'
				Case $aASM = 'fld st(0),dword[ebp+8]'
					$lOpCode = 'D94508'
				Case 'mov esi,eax'
					$lOpCode = '8BF0'
				Case 'mov edx,dword[ecx]'
					$lOpCode = '8B11'
				Case 'mov dword[eax],edx'
					$lOpCode = '8910'
				Case 'test edx,edx'
					$lOpCode = '85D2'
				Case 'mov dword[eax],F'
					$lOpCode = 'C7000F000000'
				Case 'mov ebx,[ebx+0]'
					$lOpCode = '8B1B'
				Case 'mov ebx,[ebx+AC]'
					$lOpCode = '8B9BAC000000'
				Case 'mov ebx,[ebx+C]'
					$lOpCode = '8B5B0C'
				Case 'mov eax,dword[ebx+28]'
					$lOpCode = '8B4328'
				Case 'mov eax,[eax]'
					$lOpCode = '8B00'
				Case 'mov eax,[eax+4]'
					$lOpCode = '8B4004'
				Case 'mov ebx,dword[ebp+C]'
					$lOpCode = '8B5D0C'
				Case 'add ebx,ecx'
					$lOpCode = '03D9'
				Case 'lea ecx,dword[ecx+ecx*2]'
					$lOpCode = '8D0C49'
				Case 'lea ecx,dword[ebx+ecx*4]'
					$lOpCode = '8D0C8B'
				Case 'lea ecx,dword[ecx+18]'    ; this was added for crafting
					$lOpCode = '8D4918'            ; this was added for crafting
				Case 'mov ecx,dword[ecx+edx]'
					$lOpCode = '8B0C11'
				Case 'push dword[ebp+8]'
					$lOpCode = 'FF7508'
				Case 'mov dword[eax],edi'
					$lOpCode = '8938'
				Case 'mov [eax+8],ecx'             ; this was added for crafting
					$lOpCode = '894808'            ; this was added for crafting
				Case 'mov [eax+C],ecx'             ; this was added for crafting
					$lOpCode = '89480C'            ; this was added for crafting
				Case 'mov ebx,dword[ecx-C]'        ; this was added
					$lOpCode = '8B59F4'            ; this was added
				Case 'mov [eax+!],ebx'             ; this was added
					$lOpCode = '89580C'            ; this was added
				Case 'mov ecx,[eax+8]'             ; this was added
					$lOpCode = '8B4808'            ; this was added
				Case 'lea ecx,dword[ebx+18]'       ; this was added
					$lOpCode = '8D4B18'            ; this was added
				Case 'mov ebx,dword[ebx+18]'       ; this was added
					$lOpCode = '8B5B18'            ; this was added
				Case 'mov ecx,dword[ecx+0xF4]'     ; this was added for crafting
					$lOpCode = '8B89F4000000'      ; this was added for crafting
				Case 'cmp ah,00' ;Added by Greg76 for scan wildcards
					$lOpCode = '80FC00'
				Case Else
					MsgBox(0x0, 'ASM', 'Could not assemble: ' & $aASM)
					Exit
			EndSwitch
			$mASMSize += 0.5 * StringLen($lOpCode)
			$mASMString &= $lOpCode
	EndSelect
EndFunc   ;==>_

;~ Description: Internal use only.
Func CompleteASMCode()
	Local $lInExpression = False
	Local $lExpression
	Local $lTempASM = $mASMString
	Local $lCurrentOffset = Dec(Hex($mMemory)) + $mASMCodeOffset
	Local $lToken

	For $i = 1 To $mLabels[0][0]
		If StringLeft($mLabels[$i][0], 6) = 'Label_' Then
			$mLabels[$i][0] = StringTrimLeft($mLabels[$i][0], 6)
			$mLabels[$i][1] = $mMemory + $mLabels[$i][1]
		EndIf
	Next

	$mASMString = ''
	For $i = 1 To StringLen($lTempASM)
		$lToken = StringMid($lTempASM, $i, 1)
		Switch $lToken
			Case '(', '[', '{'
				$lInExpression = True
			Case ')'
				$mASMString &= Hex(GetLabelInfo($lExpression) - Int($lCurrentOffset) - 1, 2)
				$lCurrentOffset += 1
				$lInExpression = False
				$lExpression = ''
			Case ']'
				$mASMString &= SwapEndian(Hex(GetLabelInfo($lExpression), 8))
				$lCurrentOffset += 4
				$lInExpression = False
				$lExpression = ''
			Case '}'
				$mASMString &= SwapEndian(Hex(GetLabelInfo($lExpression) - Int($lCurrentOffset) - 4, 8))
				$lCurrentOffset += 4
				$lInExpression = False
				$lExpression = ''
			Case Else
				If $lInExpression Then
					$lExpression &= $lToken
				Else
					$mASMString &= $lToken
					$lCurrentOffset += 0.5
				EndIf
		EndSwitch
	Next
EndFunc   ;==>CompleteASMCode

;~ Description: Internal use only.
Func GetLabelInfo($aLab)
	Local Const $lVal = GetValue($aLab)
	Return $lVal
EndFunc   ;==>GetLabelInfo

;~ Description: Internal use only.
Func ASMNumber($aNumber, $aSmall = False)
	If $aNumber >= 0 Then
		$aNumber = Dec($aNumber)
	EndIf
	If $aSmall And $aNumber <= 127 And $aNumber >= -128 Then
		Return SetExtended(1, Hex($aNumber, 2))
	Else
		Return SetExtended(0, SwapEndian(Hex($aNumber, 8)))
	EndIf
EndFunc   ;==>ASMNumber
#EndRegion Assembler

#Region Callback
;~ Description: Controls Event System.
Func SetEvent($aSkillActivate = '', $aSkillCancel = '', $aSkillComplete = '', $aChatReceive = '', $aLoadFinished = '')
	If Not $mUseEventSystem Then Return
	If $aSkillActivate <> '' Then
		WriteDetour('SkillLogStart', 'SkillLogProc')
	Else
		$mASMString = ''
		_('inc eax')
		_('mov dword[esi+10],eax')
		_('pop esi')
		WriteBinary($mASMString, GetValue('SkillLogStart'))
	EndIf

	If $aSkillCancel <> '' Then
		WriteDetour('SkillCancelLogStart', 'SkillCancelLogProc')
	Else
		$mASMString = ''
		_('push 0')
		_('push 42')
		_('mov ecx,esi')
		WriteBinary($mASMString, GetValue('SkillCancelLogStart'))
	EndIf

	If $aSkillComplete <> '' Then
		WriteDetour('SkillCompleteLogStart', 'SkillCompleteLogProc')
	Else
		$mASMString = ''
		_('mov eax,dword[edi+4]')
		_('test eax,eax')
		WriteBinary($mASMString, GetValue('SkillCompleteLogStart'))
	EndIf

	If $aChatReceive <> '' Then
		WriteDetour('ChatLogStart', 'ChatLogProc')
	Else
		$mASMString = ''
		_('add edi,E')
		_('cmp eax,B')
		WriteBinary($mASMString, GetValue('ChatLogStart'))
	EndIf

	$mSkillActivate = $aSkillActivate
	$mSkillCancel = $aSkillCancel
	$mSkillComplete = $aSkillComplete
	$mChatReceive = $aChatReceive
	$mLoadFinished = $aLoadFinished
EndFunc   ;==>SetEvent

;~ Description: Internal use for event system.
Func Event($hWnd, $msg, $wparam, $lparam)
	; Initial check for skill-related events to avoid unnecessary DllCalls for chat events
	If $lparam >= 0x1 And $lparam <= 0x3 Then
		Local $skillLogStruct = DllStructCreate("int skillID;int param1;int param2;int param3")
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', DllStructGetPtr($skillLogStruct), 'int', 16, 'int', '')
		HandleSkillEvent($lparam, $skillLogStruct)
		;DllStructDelete($skillLogStruct) ; Clean up
	ElseIf $lparam == 0x4 Then
		Local $chatLogStruct = DllStructCreate("int messageType;char message[512]")
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', DllStructGetPtr($chatLogStruct), 'int', 512, 'int', '')
		ProcessChatMessage($chatLogStruct)
		;DllStructDelete($chatLogStruct) ; Clean up
	ElseIf $lparam == 0x5 Then
		;Call($mLoadFinished)
	EndIf
EndFunc   ;==>Event

Func HandleSkillEvent($eventType, $skillLogStruct)
	Local $skillID = DllStructGetData($skillLogStruct, 1)
	Local $param1 = DllStructGetData($skillLogStruct, 2)
	Local $param2 = DllStructGetData($skillLogStruct, 3)
	Local $param3 = DllStructGetData($skillLogStruct, 4) ; Only used for activation

;~ Switch $eventType
;~ 	Case 0x1
;~ 		Call($mSkillActivate, $skillID, $param1, $param2, $param3)
;~ 	Case 0x2
;~ 		Call($mSkillCancel, $skillID, $param1, $param2)
;~ 	Case 0x3
;~ 		Call($mSkillComplete, $skillID, $param1, $param2)
;~ EndSwitch
EndFunc   ;==>HandleSkillEvent

Func ProcessChatMessage($chatLogStruct)
	Local $messageType = DllStructGetData($chatLogStruct, 1)
	Local $message = DllStructGetData($chatLogStruct, "message[512]")
	Local $channel = "Unknown"
	Local $sender = "Unknown"

	Switch $messageType
		Case 0 ; Alliance
			$channel = "Alliance"
		Case 3 ; All
			$channel = "All"
		Case 9 ; Guild
			$channel = "Guild"
		Case 11 ; Team
			$channel = "Team"
		Case 12 ; Trade
			$channel = "Trade"
		Case 10 ; Sent or Global
			If StringLeft($message, 3) == "-> " Then
				$channel = "Sent"
			Else
				$channel = "Global"
				$sender = "Guild Wars"
			EndIf
		Case 13 ; Advisory
			$channel = "Advisory"
			$sender = "Guild Wars"
		Case 14 ; Whisper
			$channel = "Whisper"
		Case Else
			$channel = "Other"
			$sender = "Other"
	EndSwitch

	If $channel <> "Global" And $channel <> "Advisory" And $channel <> "Other" Then
		$sender = StringMid($message, 6, StringInStr($message, "</a>") - 6)
		$message = StringTrimLeft($message, StringInStr($message, "<quote>") + 6)
	EndIf

	If $channel == "Sent" Then
		$sender = StringMid($message, 10, StringInStr($message, "</a>") - 10)
		$message = StringTrimLeft($message, StringInStr($message, "<quote>") + 6)
	EndIf

	;Call($mChatReceive, $channel, $sender, $message)
EndFunc   ;==>ProcessChatMessage
#EndRegion Callback

#Region Modification
;~ Description: Internal use only.
Func ModifyMemory()
	$mASMSize = 0
	$mASMCodeOffset = 0
	$mASMString = ''
	CreateData()
	CreateMain()
;~ 	CreateTargetLog()
;~ 	CreateSkillLog()
;~ 	CreateSkillCancelLog()
;~ 	CreateSkillCompleteLog()
;~ 	CreateChatLog()
	CreateTraderHook()
;~ 	CreateLoadFinished()
	CreateStringLog()
;~ 	CreateStringFilter1()
;~ 	CreateStringFilter2()
	CreateRenderingMod()
	CreateCommands()
	CreateDialogHook()
	$mMemory = MemoryRead(MemoryRead($mBase), 'ptr')

	Switch $mMemory
		Case 0
			$mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 64)
			$mMemory = $mMemory[0]
			MemoryWrite(MemoryRead($mBase), $mMemory)
;~ 			MsgBox(1,1,$mASMString)
			CompleteASMCode()
			WriteBinary($mASMString, $mMemory + $mASMCodeOffset)
			$SecondInject = $mMemory + $mASMCodeOffset
;~ 			MsgBox(1,1,$mASMString)
;~ 			WriteBinary('83F8009090', GetValue('ClickToMoveFix'))
			MemoryWrite(GetValue('QueuePtr'), GetValue('QueueBase'))
;~ 			MemoryWrite(GetValue('SkillLogPtr'), GetValue('SkillLogBase'))
;~ 			MemoryWrite(GetValue('ChatRevAdr'), GetValue('ChatRevBase'))
;~ 			MemoryWrite(GetValue('ChatLogPtr'), GetValue('ChatLogBase'))
;~ 			MemoryWrite(GetValue('StringLogPtr'), GetValue('StringLogBase'))
		Case Else
			CompleteASMCode()
	EndSwitch
	WriteDetour('MainStart', 'MainProc')
	WriteDetour('TargetLogStart', 'TargetLogProc')
	WriteDetour('TraderHookStart', 'TraderHookProc')
	WriteDetour('LoadFinishedStart', 'LoadFinishedProc')
	WriteDetour('RenderingMod', 'RenderingModProc')
;~ 	WriteDetour('StringLogStart', 'StringLogProc')
;~ 	WriteDetour('StringFilter1Start', 'StringFilter1Proc')
;~ 	WriteDetour('StringFilter2Start', 'StringFilter2Proc')
	WriteDetour('DialogLogStart', 'DialogLogProc')
EndFunc   ;==>ModifyMemory

;~ Description: Internal use only.
Func WriteDetour($aFrom, $aTo)
	WriteBinary('E9' & SwapEndian(Hex(GetLabelInfo($aTo) - GetLabelInfo($aFrom) - 5)), GetLabelInfo($aFrom))
EndFunc   ;==>WriteDetour

;~ Description: Internal use only.
Func CreateData()
	_('CallbackHandle/4')
	_('QueueCounter/4')
	_('SkillLogCounter/4')
	_('ChatLogCounter/4')
	_('ChatLogLastMsg/4')
	_('MapIsLoaded/4')
	_('NextStringType/4')
	_('EnsureEnglish/4')
	_('TraderQuoteID/4')
	_('TraderCostID/4')
	_('TraderCostValue/4')
	_('DisableRendering/4')

	_('QueueBase/' & 256 * GetValue('QueueSize'))
	_('TargetLogBase/' & 4 * GetValue('TargetLogSize'))
	_('SkillLogBase/' & 16 * GetValue('SkillLogSize'))
	_('StringLogBase/' & 256 * GetValue('StringLogSize'))
	_('ChatLogBase/' & 512 * GetValue('ChatLogSize'))

	_('LastDialogID/4')

	_('AgentCopyCount/4')
	_('AgentCopyBase/' & 0x1C0 * 256)
EndFunc   ;==>CreateData

;~ Description: Internal use only.
Func CreateMain()
	_('MainProc:')
	_('nop x')
	_('pushad')
	_('mov eax,dword[EnsureEnglish]')
	_('test eax,eax')
	_('jz MainMain')
	_('mov ecx,dword[BasePointer]')
	_('mov ecx,dword[ecx+18]')
	_('mov ecx,dword[ecx+18]')
	_('mov ecx,dword[ecx+194]')
	_('mov al,byte[ecx+4f]')
	_('cmp al,f')
	_('ja MainMain')
	_('mov ecx,dword[ecx+4c]')
	_('mov al,byte[ecx+3f]')
	_('cmp al,f')
	_('ja MainMain')
	_('mov eax,dword[ecx+40]')
	_('test eax,eax')
	_('jz MainMain')

	_('MainMain:')
	_('mov eax,dword[QueueCounter]')
	_('mov ecx,eax')
	_('shl eax,8')
	_('add eax,QueueBase')
	_('mov ebx,dword[eax]')
	_('test ebx,ebx')

	_('jz MainExit')
	_('push ecx')
	_('mov dword[eax],0')
	_('jmp ebx')
	_('CommandReturn:')
	_('pop eax')
	_('inc eax')
	_('cmp eax,QueueSize')
	_('jnz MainSkipReset')
	_('xor eax,eax')
	_('MainSkipReset:')
	_('mov dword[QueueCounter],eax')
	_('MainExit:')
	_('popad')

	_('mov ebp,esp')
	_('fld st(0),dword[ebp+8]')

	_('ljmp MainReturn')
EndFunc   ;==>CreateMain

;~ Description: Internal use only.
Func CreateTargetLog()
	_('TargetLogProc:')
	_('cmp ecx,4')
	_('jz TargetLogMain')
	_('cmp ecx,32')
	_('jz TargetLogMain')
	_('cmp ecx,3C')
	_('jz TargetLogMain')
	_('jmp TargetLogExit')

	_('TargetLogMain:')
	_('pushad')
	_('mov ecx,dword[ebp+8]')
	_('test ecx,ecx')
	_('jnz TargetLogStore')
	_('mov ecx,edx')

	_('TargetLogStore:')
	_('lea eax,dword[edx*4+TargetLogBase]')
	_('mov dword[eax],ecx')
	_('popad')

	_('TargetLogExit:')
	_('push ebx')
	_('push esi')
	_('push edi')
	_('mov edi,edx')
	_('ljmp TargetLogReturn')
EndFunc   ;==>CreateTargetLog

;~ Description: Internal use only.
Func CreateSkillLog()
	_('SkillLogProc:')
	_('pushad')

	_('mov eax,dword[SkillLogCounter]')
	_('push eax')
	_('shl eax,4')
	_('add eax,SkillLogBase')

	_('mov ecx,dword[edi]')
	_('mov dword[eax],ecx')
	_('mov ecx,dword[ecx*4+TargetLogBase]')
	_('mov dword[eax+4],ecx')
	_('mov ecx,dword[edi+4]')
	_('mov dword[eax+8],ecx')
	_('mov ecx,dword[edi+8]')
	_('mov dword[eax+c],ecx')

	_('push 1')
	_('push eax')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,SkillLogSize')
	_('jnz SkillLogSkipReset')
	_('xor eax,eax')
	_('SkillLogSkipReset:')
	_('mov dword[SkillLogCounter],eax')

	_('popad')
	_('inc eax')
	_('mov dword[esi+10],eax')
	_('pop esi')
	_('ljmp SkillLogReturn')
EndFunc   ;==>CreateSkillLog

;~ Description: Internal use only.
Func CreateSkillCancelLog()
	_('SkillCancelLogProc:')
	_('pushad')

	_('mov eax,dword[SkillLogCounter]')
	_('push eax')
	_('shl eax,4')
	_('add eax,SkillLogBase')

	_('mov ecx,dword[edi]')
	_('mov dword[eax],ecx')
	_('mov ecx,dword[ecx*4+TargetLogBase]')
	_('mov dword[eax+4],ecx')
	_('mov ecx,dword[edi+4]')
	_('mov dword[eax+8],ecx')

	_('push 2')
	_('push eax')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,SkillLogSize')
	_('jnz SkillCancelLogSkipReset')
	_('xor eax,eax')
	_('SkillCancelLogSkipReset:')
	_('mov dword[SkillLogCounter],eax')

	_('popad')
	_('push 0')
	_('push 48')
	_('mov ecx,esi')
	_('ljmp SkillCancelLogReturn')
EndFunc   ;==>CreateSkillCancelLog

;~ Description: Internal use only.
Func CreateSkillCompleteLog()
	_('SkillCompleteLogProc:')
	_('pushad')

	_('mov eax,dword[SkillLogCounter]')
	_('push eax')
	_('shl eax,4')
	_('add eax,SkillLogBase')

	_('mov ecx,dword[edi]')
	_('mov dword[eax],ecx')
	_('mov ecx,dword[ecx*4+TargetLogBase]')
	_('mov dword[eax+4],ecx')
	_('mov ecx,dword[edi+4]')
	_('mov dword[eax+8],ecx')

	_('push 3')
	_('push eax')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,SkillLogSize')
	_('jnz SkillCompleteLogSkipReset')
	_('xor eax,eax')
	_('SkillCompleteLogSkipReset:')
	_('mov dword[SkillLogCounter],eax')

	_('popad')
	_('mov eax,dword[edi+4]')
	_('test eax,eax')
	_('ljmp SkillCompleteLogReturn')
EndFunc   ;==>CreateSkillCompleteLog

;~ Description: Internal use only.
Func CreateChatLog()
	_('ChatLogProc:')

	_('pushad')
	_('mov ecx,dword[esp+1F4]')
	_('mov ebx,eax')
	_('mov eax,dword[ChatLogCounter]')
	_('push eax')
	_('shl eax,9')
	_('add eax,ChatLogBase')
	_('mov dword[eax],ebx')

	_('mov edi,eax')
	_('add eax,4')
	_('xor ebx,ebx')

	_('ChatLogCopyLoop:')
	_('mov dx,word[ecx]')
	_('mov word[eax],dx')
	_('add ecx,2')
	_('add eax,2')
	_('inc ebx')
	_('cmp ebx,FF')
	_('jz ChatLogCopyExit')
	_('test dx,dx')
	_('jnz ChatLogCopyLoop')

	_('ChatLogCopyExit:')
	_('push 4')
	_('push edi')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,ChatLogSize')
	_('jnz ChatLogSkipReset')
	_('xor eax,eax')
	_('ChatLogSkipReset:')
	_('mov dword[ChatLogCounter],eax')
	_('popad')

	_('ChatLogExit:')
	_('add edi,E')
	_('cmp eax,B')
	_('ljmp ChatLogReturn')
EndFunc   ;==>CreateChatLog

;~ Description: Internal use only.
Func CreateTraderHook()
	_('TraderHookProc:')
	_('push eax')
	_('mov eax,dword[ebx+28] -> 8b 43 28')
	_('mov eax,[eax] -> 8b 00')
	_('mov dword[TraderCostID],eax')
	_('mov eax,dword[ebx+28] -> 8b 43 28')
	_('mov eax,[eax+4] -> 8b 40 04')
	_('mov dword[TraderCostValue],eax')
	_('pop eax')
	_('mov ebx,dword[ebp+C] -> 8B 5D 0C')
	_('mov esi,eax')
	_('push eax')
	_('mov eax,dword[TraderQuoteID]')
	_('inc eax')
	_('cmp eax,200')
	_('jnz TraderSkipReset')
	_('xor eax,eax')
	_('TraderSkipReset:')
	_('mov dword[TraderQuoteID],eax')
	_('pop eax')
	_('ljmp TraderHookReturn')
EndFunc   ;==>CreateTraderHook

;~ Description: Internal use only.
Func CreateDialogHook()
	_('DialogLogProc:')
	_('push ecx')
	_('mov ecx,esp')
	_('add ecx,C')
	_('mov ecx,dword[ecx]')
	_('mov dword[LastDialogID],ecx')
	_('pop ecx')
	_('mov ebp,esp')
	_('sub esp,8')
	_('ljmp DialogLogReturn')
EndFunc   ;==>CreateDialogHook

;~ Description: Internal use only.
Func CreateLoadFinished()
	_('LoadFinishedProc:')
	_('pushad')

	_('mov eax,1')
	_('mov dword[MapIsLoaded],eax')

	_('xor ebx,ebx')
	_('mov eax,StringLogBase')
	_('LoadClearStringsLoop:')
	_('mov dword[eax],0')
	_('inc ebx')
	_('add eax,100')
	_('cmp ebx,StringLogSize')
	_('jnz LoadClearStringsLoop')

	_('xor ebx,ebx')
	_('mov eax,TargetLogBase')
	_('LoadClearTargetsLoop:')
	_('mov dword[eax],0')
	_('inc ebx')
	_('add eax,4')
	_('cmp ebx,TargetLogSize')
	_('jnz LoadClearTargetsLoop')

	_('push 5')
	_('push 0')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('popad')
	_('mov edx,dword[esi+1C]')
	_('mov ecx,edi')
	_('ljmp LoadFinishedReturn')
EndFunc   ;==>CreateLoadFinished

;~ Description: Internal use only.
Func CreateStringLog()
	_('StringLogProc:')
	_('pushad')
	_('mov eax,dword[NextStringType]')
	_('test eax,eax')
	_('jz StringLogExit')

	_('cmp eax,1')
	_('jnz StringLogFilter2')
	_('mov eax,dword[ebp+37c]')
	_('jmp StringLogRangeCheck')

	_('StringLogFilter2:')
	_('cmp eax,2')
	_('jnz StringLogExit')
	_('mov eax,dword[ebp+338]')

	_('StringLogRangeCheck:')
	_('mov dword[NextStringType],0')
	_('cmp eax,0')
	_('jbe StringLogExit')
	_('cmp eax,StringLogSize')
	_('jae StringLogExit')

	_('shl eax,8')
	_('add eax,StringLogBase')

	_('xor ebx,ebx')
	_('StringLogCopyLoop:')
	_('mov dx,word[ecx]')
	_('mov word[eax],dx')
	_('add ecx,2')
	_('add eax,2')
	_('inc ebx')
	_('cmp ebx,80')
	_('jz StringLogExit')
	_('test dx,dx')
	_('jnz StringLogCopyLoop')

	_('StringLogExit:')
	_('popad')
	_('mov esp,ebp')
	_('pop ebp')
	_('retn 10')
EndFunc   ;==>CreateStringLog

;~ Description: Internal use only.
Func CreateStringFilter1()
	_('StringFilter1Proc:')
	_('mov dword[NextStringType],1')

	_('push ebp')
	_('mov ebp,esp')
	_('push ecx')
	_('push esi')
	_('ljmp StringFilter1Return')
EndFunc   ;==>CreateStringFilter1

;~ Description: Internal use only.
Func CreateStringFilter2()
	_('StringFilter2Proc:')
	_('mov dword[NextStringType],2')

	_('push ebp')
	_('mov ebp,esp')
	_('push ecx')
	_('push esi')
	_('ljmp StringFilter2Return')
EndFunc   ;==>CreateStringFilter2

;~ Description: Internal use only.
Func CreateRenderingMod()
;~ 	_('RenderingModProc:')
;~ 	_('cmp dword[DisableRendering],1')
;~ 	_('jz RenderingModSkipCompare')
;~ 	_('cmp eax,ebx')
;~ 	_('ljne RenderingModReturn')
;~ 	_('RenderingModSkipCompare:')

;~ 	$mASMSize += 17
;~ 	$mASMString &= StringTrimLeft(MemoryRead(GetValue("RenderingMod") + 4, "byte[17]"), 2)

;~ 	_('cmp dword[DisableRendering],1')
;~ 	_('jz DisableRenderingProc')
;~ 	_('retn')

;~ 	_('DisableRenderingProc:')
;~ 	_('push 1')
;~ 	_('call dword[Sleep]')
;~ 	_('retn')

	_("RenderingModProc:")
	_("add esp,4")
	_("cmp dword[DisableRendering],1")
	_("ljmp RenderingModReturn")
EndFunc   ;==>CreateRenderingMod

;~ Description: Internal use only.
Func CreateCommands()
	_('CommandUseSkill:')
	_('mov ecx,dword[eax+C]')
	_('push ecx')
	_('mov ebx,dword[eax+8]')
	_('push ebx')
	_('mov edx,dword[eax+4]')
	_('dec edx')
	_('push edx')
	_('mov eax,dword[MyID]')
	_('push eax')
	_('call UseSkillFunction')
	_('pop eax')
	_('pop edx')
	_('pop ebx')
	_('pop ecx')
	_('ljmp CommandReturn')

	_('CommandMove:')
	_('lea eax,dword[eax+4]')
	_('push eax')
	_('call MoveFunction')
	_('pop eax')
	_('ljmp CommandReturn')

	_("CommandChangeTarget:")
	_("xor edx,edx")
	_("push edx")
	_("mov eax,dword[eax+4]")
	_("push eax")
	_("call ChangeTargetFunction")
	_("pop eax")
	_("pop edx")
	_("ljmp CommandReturn")

	_('CommandPacketSend:')
	_('lea edx,dword[eax+8]')
	_('push edx')
	_('mov ebx,dword[eax+4]')
	_('push ebx')
	;_('push edx')
	;_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSendFunction')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandChangeStatus:')
	_('mov eax,dword[eax+4]')
	_('push eax')
	_('call ChangeStatusFunction')
	_('pop eax')
	_('ljmp CommandReturn')

	_("CommandWriteChat:")
	_("push 0")    ; new from April update
	_("add eax,4")
	_("push eax")
	_("call WriteChatFunction")
	_("add esp,8")                ; was _('pop eax') before April change
	_("ljmp CommandReturn")

	_('CommandSellItem:')
	_('mov esi,eax')
	_('add esi,C')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push dword[eax+4]')
	_('push 0')
	_('add eax,8')
	_('push eax')
	_('push 1')
	_('push 0')
	_('push B')
	_('call TransactionFunction')
	_('add esp,24')
	_('ljmp CommandReturn')

	_('CommandBuyItem:')
	_('mov esi,eax')
	_('add esi,10') ;01239A20
	_('mov ecx,eax')
	_('add ecx,4')
	_('push ecx')
	_('mov edx,eax')
	_('add edx,8')
	_('push edx')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('mov eax,dword[eax+C]')
	_('push eax')
	_('push 1')
	_('call TransactionFunction')
	_('add esp,24')
	_('ljmp CommandReturn')

	_('CommandCraftItemEx:')
	_('add eax,4')
	_('push eax')
	_('add eax,4')
	_('push eax')
	_('push 1')
	_('push 0')
	_('push 0')
	_('mov ecx,dword[TradeID]')
	_('mov ecx,dword[ecx]')
	;_('mov ebx,dword[ecx+148]')
	_('mov edx,dword[eax+4]')
	;_('mov ecx,dword[ecx+edx]')
	;_('lea ecx,dword[ecx+ecx*2]')
	_('lea ecx,dword[ebx+ecx*4]')
	_('push ecx')
	_('push 1')
	_('push dword[eax+8]')
	_('push dword[eax+C]')
	_('call TraderFunction')
	_('add esp,24')
	_('mov dword[TraderCostID],0')
	_('ljmp CommandReturn')

	_("CommandAction:")
	_("mov ecx,dword[ActionBase]")
	_("mov ecx,dword[ecx+c]")    ; was _("mov ecx,dword[ecx+!]")
	_("add ecx,A0")
	_("push 0")
	_("add eax,4")
	_("push eax")
	_("push dword[eax+4]")
	_("mov edx,0")
	_("call ActionFunction")
	_("ljmp CommandReturn")

	_('CommandUseHeroSkill:')
	_('mov ecx,dword[eax+8]')
	_('push ecx')
	_('mov ecx,dword[eax+c]')
	_('push ecx')
	_('mov ecx,dword[eax+4]')
	_('push ecx')
	_('call UseHeroSkillFunction')
	_('add esp,C')
	_('ljmp CommandReturn')

;~ 	_('CommandToggleLanguage:')
;~ 	_('mov ecx,dword[ActionBase]')
;~ 	_('mov ecx,dword[ecx+170]')
;~ 	_('mov ecx,dword[ecx+20]')
;~ 	_('mov ecx,dword[ecx]')
;~ 	_('push 0')
;~ 	_('push 0')
;~ 	_('push bb')
;~ 	_('mov edx,esp')
;~ 	_('push 0')
;~ 	_('push edx')
;~ 	_('push dword[eax+4]')
;~ 	_('call ActionFunction')
;~ 	_('pop eax')
;~ 	_('pop ebx')
;~ 	_('pop ecx')
;~ 	_('ljmp CommandReturn')

	_('CommandSendChat:')
	_('lea edx,dword[eax+4]')
	_('push edx')
	_('mov ebx,11c')
	_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSendFunction')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandRequestQuote:')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('mov esi,eax')
	_('add esi,4')
	_('push esi')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push C')
	_('mov ecx,0')
	_('mov edx,2')
	_('call RequestQuoteFunction')
	_('add esp,20')
	_('ljmp CommandReturn')

	_('CommandRequestQuoteSell:')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('add eax,4')
	_('push eax')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push D')
	_('xor edx,edx')
	_('call RequestQuoteFunction')
	_('add esp,20')
	_('ljmp CommandReturn')

	_('CommandTraderBuy:')
	_('push 0')
	_('push TraderCostID')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('mov edx,dword[TraderCostValue]')
	_('push edx')
	_('push C')
	_('mov ecx,C')
	_('call TraderFunction')
	_('add esp,24')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('ljmp CommandReturn')

	_('CommandTraderSell:')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push dword[TraderCostValue]')
	_('push 0')
	_('push TraderCostID')
	_('push 1')
	_('push 0')
	_('push D')
	_('mov ecx,d')
	_('xor edx,edx')
	_('call TransactionFunction')  ; 	_('call TraderFunction')
	_('add esp,24')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('ljmp CommandReturn')

	_('CommandSalvage:')
	_('push eax')
	_('push ecx')
	_('push ebx')
	_('mov ebx,SalvageGlobal')
	_('mov ecx,dword[eax+4]')
	_('mov dword[ebx],ecx')
	_('add ebx,4')
	_('mov ecx,dword[eax+8]')
	_('mov dword[ebx],ecx')
	_('mov ebx,dword[eax+4]')
	_('push ebx')
	_('mov ebx,dword[eax+8]')
	_('push ebx')
	_('mov ebx,dword[eax+c]')
	_('push ebx')
	_('call SalvageFunction')
	_('add esp,C')
	_('pop ebx')
	_('pop ecx')
	_('pop eax')
	_('ljmp CommandReturn')

	_("CommandCraftItemEx2:")    ; this was added
	_("add eax,4")
	_("push eax")
	_("add eax,4")
	_("push eax")
	_("push 1")
	_("push 0")
	_("push 0")
	_("mov ecx,dword[TradeID]")
	_("mov ecx,dword[ecx]")
	;_("mov ebx,dword[ecx+148]")
	_("mov edx,dword[eax+8]")
	;_("mov ecx,dword[ecx+edx]")
	;_("lea ecx,dword[ecx+ecx*2]")
	_("lea ecx,dword[ebx+ecx*4]")
	_("mov ecx,dword[ecx]")
	_("mov [eax+8],ecx")
	_("mov ecx,dword[TradeID]")
	_("mov ecx,dword[ecx]")
	_("mov ecx,dword[ecx+0xF4]")
	_("lea ecx,dword[ecx+ecx*2]")
	_("lea ecx,dword[ebx+ecx*4]")
	_("mov ecx,dword[ecx]")
	_("mov [eax+C],ecx")
	_("mov ecx,eax")
	_("add ecx,8")
	_("push ecx")
	_("push 2")
	_("push dword[eax+4]")
	_("push 3")
	_("call TransactionFunction")
	_("add esp,24")
	_("mov dword[TraderCostID],0")
	_("ljmp CommandReturn")

	_('CommandIncreaseAttribute:')
	_('mov edx,dword[eax+4]')
	_('push edx')
	_('mov ecx,dword[eax+8]')
	_('push ecx')
	_('call IncreaseAttributeFunction')
	_('pop ecx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandDecreaseAttribute:')
	_('mov edx,dword[eax+4]')
	_('push edx')
	_('mov ecx,dword[eax+8]')
	_('push ecx')
	_('call DecreaseAttributeFunction')
	_('pop ecx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandMakeAgentArray:')
	_('mov eax,dword[eax+4]')
	_('xor ebx,ebx')
	_('xor edx,edx')
	_('mov edi,AgentCopyBase')

	_('AgentCopyLoopStart:')
	_('inc ebx')
	_('cmp ebx,dword[MaxAgents]')
	_('jge AgentCopyLoopExit')

	_('mov esi,dword[AgentBase]')
	_('lea esi,dword[esi+ebx*4]')
	_('mov esi,dword[esi]')
	_('test esi,esi')
	_('jz AgentCopyLoopStart')

	_('cmp eax,0')
	_('jz CopyAgent')
	_('cmp eax,dword[esi+9C]')
	_('jnz AgentCopyLoopStart')

	_('CopyAgent:')
	_('mov ecx,1C0')
	_('clc')
	_('repe movsb')
	_('inc edx')
	_('jmp AgentCopyLoopStart')
	_('AgentCopyLoopExit:')
	_('mov dword[AgentCopyCount],edx')
	_('ljmp CommandReturn')

	_('CommandSendChatPartySearch:')
	_('lea edx,dword[eax+4]')
	_('push edx')
	_('mov ebx,4C')
	_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSendFunction')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')
EndFunc   ;==>CreateCommands
#EndRegion Modification

#Region Misc
;~ Description: Converts float to integer.
Func FloatToInt($nFloat)
	Local $tFloat = DllStructCreate("float")
	Local $tInt = DllStructCreate("int", DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $nFloat)
	Return DllStructGetData($tInt, 1)
EndFunc   ;==>FloatToInt

Func IntToFloat($fInt)
	Local $tFloat, $tInt
	$tInt = DllStructCreate("int")
	$tFloat = DllStructCreate("float", DllStructGetPtr($tInt))
	DllStructSetData($tInt, 1, $fInt)
	Return DllStructGetData($tFloat, 1)
EndFunc   ;==>IntToFloat

;~ Description: Internal use only.
Func Bin64ToDec($aBinary)
	Local $lReturn = 0

	For $i = 1 To StringLen($aBinary)
		If StringMid($aBinary, $i, 1) == 1 Then $lReturn += 2 ^ ($i - 1)
	Next

	Return $lReturn
EndFunc   ;==>Bin64ToDec

;~ Description: Internal use only.
Func Base64ToBin64($aCharacter)
	Select
		Case $aCharacter == 'A'
			Return '000000'
		Case $aCharacter == 'B'
			Return '100000'
		Case $aCharacter == 'C'
			Return '010000'
		Case $aCharacter == 'D'
			Return '110000'
		Case $aCharacter == 'E'
			Return '001000'
		Case $aCharacter == 'F'
			Return '101000'
		Case $aCharacter == 'G'
			Return '011000'
		Case $aCharacter == 'H'
			Return '111000'
		Case $aCharacter == 'I'
			Return '000100'
		Case $aCharacter == 'J'
			Return '100100'
		Case $aCharacter == 'K'
			Return '010100'
		Case $aCharacter == 'L'
			Return '110100'
		Case $aCharacter == 'M'
			Return '001100'
		Case $aCharacter == 'N'
			Return '101100'
		Case $aCharacter == 'O'
			Return '011100'
		Case $aCharacter == 'P'
			Return '111100'
		Case $aCharacter == 'Q'
			Return '000010'
		Case $aCharacter == 'R'
			Return '100010'
		Case $aCharacter == 'S'
			Return '010010'
		Case $aCharacter == 'T'
			Return '110010'
		Case $aCharacter == 'U'
			Return '001010'
		Case $aCharacter == 'V'
			Return '101010'
		Case $aCharacter == 'W'
			Return '011010'
		Case $aCharacter == 'X'
			Return '111010'
		Case $aCharacter == 'Y'
			Return '000110'
		Case $aCharacter == 'Z'
			Return '100110'
		Case $aCharacter == 'a'
			Return '010110'
		Case $aCharacter == 'b'
			Return '110110'
		Case $aCharacter == 'c'
			Return '001110'
		Case $aCharacter == 'd'
			Return '101110'
		Case $aCharacter == 'e'
			Return '011110'
		Case $aCharacter == 'f'
			Return '111110'
		Case $aCharacter == 'g'
			Return '000001'
		Case $aCharacter == 'h'
			Return '100001'
		Case $aCharacter == 'i'
			Return '010001'
		Case $aCharacter == 'j'
			Return '110001'
		Case $aCharacter == 'k'
			Return '001001'
		Case $aCharacter == 'l'
			Return '101001'
		Case $aCharacter == 'm'
			Return '011001'
		Case $aCharacter == 'n'
			Return '111001'
		Case $aCharacter == 'o'
			Return '000101'
		Case $aCharacter == 'p'
			Return '100101'
		Case $aCharacter == 'q'
			Return '010101'
		Case $aCharacter == 'r'
			Return '110101'
		Case $aCharacter == 's'
			Return '001101'
		Case $aCharacter == 't'
			Return '101101'
		Case $aCharacter == 'u'
			Return '011101'
		Case $aCharacter == 'v'
			Return '111101'
		Case $aCharacter == 'w'
			Return '000011'
		Case $aCharacter == 'x'
			Return '100011'
		Case $aCharacter == 'y'
			Return '010011'
		Case $aCharacter == 'z'
			Return '110011'
		Case $aCharacter == '0'
			Return '001011'
		Case $aCharacter == '1'
			Return '101011'
		Case $aCharacter == '2'
			Return '011011'
		Case $aCharacter == '3'
			Return '111011'
		Case $aCharacter == '4'
			Return '000111'
		Case $aCharacter == '5'
			Return '100111'
		Case $aCharacter == '6'
			Return '010111'
		Case $aCharacter == '7'
			Return '110111'
		Case $aCharacter == '8'
			Return '001111'
		Case $aCharacter == '9'
			Return '101111'
		Case $aCharacter == '+'
			Return '011111'
		Case $aCharacter == '/'
			Return '111111'
	EndSelect
EndFunc   ;==>Base64ToBin64

;~ Description: Internal use only.
Func Enqueue($aPtr, $aSize)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', 256 * $mQueueCounter + $mQueueBase, 'ptr', $aPtr, 'int', $aSize, 'int', '')
	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf
EndFunc   ;==>Enqueue

;~ Description: Internal use only.
Func PerformAction($aAction, $aFlag)
	DllStructSetData($mAction, 2, $aAction)
	DllStructSetData($mAction, 3, $aFlag)
	Enqueue($mActionPtr, 12)
EndFunc   ;==>PerformAction

;~ Description: Internal use only.
Func SendPacket($aSize, $aHeader, $aParam1 = 0, $aParam2 = 0, $aParam3 = 0, $aParam4 = 0, $aParam5 = 0, $aParam6 = 0, $aParam7 = 0, $aParam8 = 0, $aParam9 = 0, $aParam10 = 0)
	DllStructSetData($mPacket, 2, $aSize)
	DllStructSetData($mPacket, 3, $aHeader)
	DllStructSetData($mPacket, 4, $aParam1)
	DllStructSetData($mPacket, 5, $aParam2)
	DllStructSetData($mPacket, 6, $aParam3)
	DllStructSetData($mPacket, 7, $aParam4)
	DllStructSetData($mPacket, 8, $aParam5)
	DllStructSetData($mPacket, 9, $aParam6)
	DllStructSetData($mPacket, 10, $aParam7)
	DllStructSetData($mPacket, 11, $aParam8)
	DllStructSetData($mPacket, 12, $aParam9)
	DllStructSetData($mPacket, 13, $aParam10)
	Enqueue($mPacketPtr, 52)
EndFunc   ;==>SendPacket

#EndRegion Misc

