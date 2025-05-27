#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

#Region Module Global Variables
; Map data pointers
Global $g_mMapIsLoaded      ; Flag indicating if map is loaded
Global $g_mMapLoading       ; Flag indicating if map is loading
Global $g_mInstanceInfo     ; Pointer to instance information
Global $g_mAreaInfo         ; Pointer to area information
Global $g_mWorldConst       ; Pointer to world constants
Global $g_mRegion

; Map command structures
Global $g_mMove = DllStructCreate('ptr;float;float;float')
Global $g_mMovePtr = DllStructGetPtr($g_mMove)

; Module state variables
Global $g_bMapModuleInitialized = False
Global $g_fLastMoveX = 0
Global $g_fLastMoveY = 0

Global $g_mClickCoordsX = 0
Global $g_mClickCoordsY = 0
#EndRegion Module Global Variables

#Region Initialize Functions
Func _MapMod_Initialize()
    If $g_bMapModuleInitialized Then
        _Log_Warning("MapMod module already initialized", "MapMod", $GUIEdit)
        Return True
    EndIf

    ; Initialize map data
    _MapMod_InitializeData()

    ; Initialize commands
    _MapMod_InitializeCommands()

    $g_bMapModuleInitialized = True
    Return True
EndFunc

Func _MapMod_InitializeData()
    $g_mInstanceInfo = MemoryRead(GetScannedAddress('ScanInstanceInfo', 0xE))
	_Log_Debug("InstanceInfo: " & Ptr($g_mInstanceInfo), "MapMod", $GUIEdit)

    $g_mAreaInfo = MemoryRead(GetScannedAddress('ScanAreaInfo', 0x6))
	_Log_Debug("AreaInfo: " & Ptr($g_mAreaInfo), "MapMod", $GUIEdit)

	$g_mWorldConst = MemoryRead(GetScannedAddress('ScanWorldConst', 0x8))
	_Log_Debug("WorldConst: " & Ptr($g_mWorldConst), "MapMod", $GUIEdit)

	$g_mClickCoordsX = MemoryRead(GetScannedAddress("ScanClickCoords", 13))
	_Log_Debug("ClickCoordsX: " & Ptr($g_mClickCoordsX), "MapMod", $GUIEdit)

	$g_mClickCoordsY = MemoryRead(GetScannedAddress("ScanClickCoords", 22))
	_Log_Debug("ClickCoordsY: " & Ptr($g_mClickCoordsY), "MapMod", $GUIEdit)

	$g_mRegion = MemoryRead(GetScannedAddress('ScanRegion', -0x3))
   _Log_Debug("Region: " & Ptr($g_mRegion), "Initialize", $GUIEdit)
EndFunc

Func _MapMod_InitializeCommands()
    SetValue('MoveFunction', Ptr(GetScannedAddress('ScanMoveFunction', 0x1)))
	_Log_Debug("MoveFunction: " & GetValue('MoveFunction'), "MapMod", $GUIEdit)
EndFunc

Func _MapMod_Cleanup()
    If Not $g_bMapModuleInitialized Then Return

    _Log_Info("Cleaning up MapMod module...", "MapMod", $GUIEdit)

    ; Reset state variables
    $g_iLastMapID = 0
    $g_fLastMoveX = 0
    $g_fLastMoveY = 0
    $g_bMapModuleInitialized = False

    _Log_Info("MapMod module cleanup completed", "MapMod", $GUIEdit)
EndFunc
#EndRegion Initialize Functions

#Region Pattern, Structure & Assembly Code Generation
Func _MapMod_DefinePatterns()
	_('ScanMoveFunction:')
	AddPattern('558BEC83EC208D45F0')

	_("ScanClickCoords:")
	AddPattern("8B451C85C0741CD945F8")

	_("ScanInstanceInfo:")
	AddPattern("6A2C50E80000000083C408C7")

	_("ScanAreaInfo:")
	AddPattern("6BC67C5E05")

	_("ScanWorldConst:")
	AddPattern("8D0476C1E00405")

	_('ScanRegion:')
	AddPattern('6A548D46248908')
EndFunc

Func _MapMod_SetupStructures()
    DllStructSetData($g_mMove, 1, GetValue('CommandMove'))
EndFunc

Func _MapMod_CreateCommands()
	_('CommandMove:')
	_('lea eax,dword[eax+4]')
	_('push eax')
	_('call MoveFunction')
	_('pop eax')
	_('ljmp CommandReturn')
EndFunc
#EndRegion Pattern, Structure & Assembly Code Generation