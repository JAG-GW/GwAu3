#include-once
#include "../../Core/GwAu3_Constants_Core.au3"
#include "../../Core/GwAu3_Assembler.au3"
#include "../../Core/GwAu3_Utils.au3"
#include "../../Core/GwAu3_LogMessages.au3"

#Region Module Constants
; Attribute module specific constants
Global Const $ATTRIBUTE_MIN_VALUE = 0
Global Const $ATTRIBUTE_MAX_VALUE = 12
Global Const $ATTRIBUTE_MAJOR_MAX = 16

; Guild Wars attribute IDs (complete list)
; Core Professions
Global Const $ATTR_FAST_CASTING = 0
Global Const $ATTR_ILLUSION = 1
Global Const $ATTR_DOMINATION = 2
Global Const $ATTR_INSPIRATION = 3
Global Const $ATTR_BLOOD = 4
Global Const $ATTR_DEATH = 5
Global Const $ATTR_SOUL_REAPING = 6
Global Const $ATTR_CURSES = 7
Global Const $ATTR_AIR = 8
Global Const $ATTR_EARTH = 9
Global Const $ATTR_FIRE = 10
Global Const $ATTR_WATER = 11
Global Const $ATTR_ENERGY_STORAGE = 12
Global Const $ATTR_HEALING = 13
Global Const $ATTR_SMITING = 14
Global Const $ATTR_PROTECTION = 15
Global Const $ATTR_DIVINE_FAVOR = 16
Global Const $ATTR_STRENGTH = 17
Global Const $ATTR_AXE = 18
Global Const $ATTR_HAMMER = 19
Global Const $ATTR_SWORDSMANSHIP = 20
Global Const $ATTR_TACTICS = 21
Global Const $ATTR_BEAST_MASTERY = 22
Global Const $ATTR_EXPERTISE = 23
Global Const $ATTR_WILDERNESS = 24
Global Const $ATTR_MARKSMANSHIP = 25

; Factions Professions
Global Const $ATTR_DAGGER_MASTERY = 29
Global Const $ATTR_DEADLY_ARTS = 30
Global Const $ATTR_SHADOW_ARTS = 31
Global Const $ATTR_COMMUNING = 32
Global Const $ATTR_RESTORATION_MAGIC = 33
Global Const $ATTR_CHANNELING_MAGIC = 34
Global Const $ATTR_CRITICAL_STRIKES = 35
Global Const $ATTR_SPAWNING_POWER = 36

; Nightfall Professions
Global Const $ATTR_SPEAR_MASTERY = 37
Global Const $ATTR_COMMAND = 38
Global Const $ATTR_MOTIVATION = 39
Global Const $ATTR_LEADERSHIP = 40
Global Const $ATTR_SCYTHE_MASTERY = 41
Global Const $ATTR_WIND_PRAYERS = 42
Global Const $ATTR_EARTH_PRAYERS = 43
Global Const $ATTR_MYSTICISM = 44

; Attribute operation results
Global Const $ATTR_RESULT_SUCCESS = 0
Global Const $ATTR_RESULT_INVALID_ID = 1
Global Const $ATTR_RESULT_INVALID_VALUE = 2
Global Const $ATTR_RESULT_NO_POINTS = 3
Global Const $ATTR_RESULT_MAX_REACHED = 4
#EndRegion Module Constants

#Region Module Global Variables
Global $g_mAttributeInfo	; Pointer to attribute information

; Attribute command structures
Global $g_mIncreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_mIncreaseAttributePtr = DllStructGetPtr($g_mIncreaseAttribute)

Global $g_mDecreaseAttribute = DllStructCreate('ptr;dword;dword')
Global $g_mDecreaseAttributePtr = DllStructGetPtr($g_mDecreaseAttribute)

Global $g_mMaxAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Global $g_mMaxAttributesPtr = DllStructGetPtr($g_mMaxAttributes)

Global $g_mSetAttributes = DllStructCreate("ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword")
Global $g_mSetAttributesPtr = DllStructGetPtr($g_mSetAttributes)

; Module state variables
Global $g_bAttributeModuleInitialized = False
Global $g_iLastAttributeModified = -1
Global $g_iLastAttributeValue = 0

; Attribute name lookup table
Global $g_aAttributeNames[45] = [ _
    "Fast Casting", "Illusion Magic", "Domination Magic", "Inspiration Magic", _
    "Blood Magic", "Death Magic", "Soul Reaping", "Curses", _
    "Air Magic", "Earth Magic", "Fire Magic", "Water Magic", "Energy Storage", _
    "Healing Prayers", "Smiting Prayers", "Protection Prayers", "Divine Favor", _
    "Strength", "Axe Mastery", "Hammer Mastery", "Swordsmanship", "Tactics", _
    "Beast Mastery", "Expertise", "Wilderness Survival", "Marksmanship", _
    "Unknown", "Unknown", "Unknown", _
    "Dagger Mastery", "Deadly Arts", "Shadow Arts", _
    "Communing", "Restoration Magic", "Channeling Magic", _
    "Critical Strikes", "Spawning Power", _
    "Spear Mastery", "Command", "Motivation", "Leadership", _
    "Scythe Mastery", "Wind Prayers", "Earth Prayers", "Mysticism"]
#EndRegion Module Global Variables

#Region Initialize Functions
; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_Initialize
; Description ...: Initializes the attribute management module
; Syntax.........: _AttributeMod_Initialize()
; Parameters ....: None
; Return values .: True if initialization succeeds, False otherwise
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Must be called after main initialization
;                  - Sets up all necessary data for the module
; Related .......: _AttributeMod_Cleanup
;============================================================================================
Func _AttributeMod_Initialize()
    If $g_bAttributeModuleInitialized Then
        _Log_Warning("AttributeMgr module already initialized", "AttributeMgr", $GUIEdit)
        Return True
    EndIf

    _Log_Info("Initializing AttributeMgr module...", "AttributeMgr", $GUIEdit)

    ; Initialize attribute data
    _AttributeMod_InitializeData()

    ; Initialize commands
    _AttributeMod_InitializeCommands()

    $g_bAttributeModuleInitialized = True
    _Log_Info("AttributeMgr module initialized successfully", "AttributeMgr", $GUIEdit)
    Return True
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_InitializeData
; Description ...: Initializes attribute base data
; Syntax.........: _AttributeMod_InitializeData()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _AttributeMod_Initialize
;============================================================================================
Func _AttributeMod_InitializeData()
    ; Read attribute info address
    $g_mAttributeInfo = MemoryRead(GetScannedAddress('ScanAttributeInfo', -0x3))
    If $g_mAttributeInfo = 0 Then _Log_Error("Invalid AttributeInfo address", "SkillMod", $GUIEdit)
    SetValue('AttributeInfo', Ptr($g_mAttributeInfo))
    _Log_Debug("AttributeInfo: " & Ptr($g_mAttributeInfo), "AttributeMgr", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_InitializeCommands
; Description ...: Initializes command and function addresses
; Syntax.........: _AttributeMod_InitializeCommands()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _AttributeMod_Initialize
;============================================================================================
Func _AttributeMod_InitializeCommands()
    ; Setup attribute functions
    SetValue('IncreaseAttributeFunction', Ptr(GetScannedAddress('ScanIncreaseAttributeFunction', -0x5A)))
    SetValue("DecreaseAttributeFunction", Ptr(GetScannedAddress("ScanDecreaseAttributeFunction", 0x19)))

    _Log_Debug("IncreaseAttributeFunction: " & GetValue('IncreaseAttributeFunction'), "AttributeMgr", $GUIEdit)
    _Log_Debug("DecreaseAttributeFunction: " & GetValue('DecreaseAttributeFunction'), "AttributeMgr", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_Cleanup
; Description ...: Cleans up module resources
; Syntax.........: _AttributeMod_Cleanup()
; Parameters ....: None
; Return values .: None
; Author ........: Greg76
; Modified.......:
; Remarks .......: - Should be called when closing the application
; Related .......: _AttributeMod_Initialize
;============================================================================================
Func _AttributeMod_Cleanup()
    If Not $g_bAttributeModuleInitialized Then Return

    _Log_Info("Cleaning up AttributeMgr module...", "AttributeMgr", $GUIEdit)

    ; Reset state variables
    $g_iLastAttributeModified = -1
    $g_iLastAttributeValue = 0
    $g_bAttributeModuleInitialized = False

    _Log_Info("AttributeMgr module cleanup completed", "AttributeMgr", $GUIEdit)
EndFunc
#EndRegion Initialize Functions

#Region Pattern, Structure & Assembly Code Generation
; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_DefinePatterns
; Description ...: Defines scan patterns for attribute-related functions
; Syntax.........: _AttributeMod_DefinePatterns()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Called during the scan phase of initialization
; Related .......: _AttributeMod_CreateCommands
;============================================================================================
Func _AttributeMod_DefinePatterns()
    _Log_Debug("Defining attribute-related scan patterns...", "AttributeMgr", $GUIEdit)

    _('ScanAttributeInfo:')
    AddPattern("BA3300000089088d4004") ; Added by Greg76 to get Attribute Info

    _('ScanIncreaseAttributeFunction:')
    AddPattern('8B7D088B702C8B1F3B9E00050000') ; STILL WORKING 23.12.24

    _("ScanDecreaseAttributeFunction:")
    AddPattern("8B8AA800000089480C5DC3CC") ; STILL WORKING 23.12.24

    _Log_Debug("Attribute patterns defined successfully", "AttributeMgr", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_SetupStructures
; Description ...: Configures data structures for commands
; Syntax.........: _AttributeMod_SetupStructures()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Called after command creation to setup structure pointers
;                  - Must be called before using attribute commands
; Related .......: _AttributeMod_Initialize
;============================================================================================
Func _AttributeMod_SetupStructures()
    DllStructSetData($g_mIncreaseAttribute, 1, GetValue('CommandIncreaseAttribute'))
    DllStructSetData($g_mDecreaseAttribute, 1, GetValue('CommandDecreaseAttribute'))
;~     DllStructSetData($g_mMaxAttributes, 1, GetValue('CommandMaxAttributes'))
;~     DllStructSetData($g_mSetAttributes, 1, GetValue('CommandSetAttributes'))

    _Log_Debug("Attribute structures configured successfully", "AttributeMgr", $GUIEdit)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_CreateIncreaseAttributeCommand
; Description ...: Creates ASM command for increasing an attribute
; Syntax.........: _AttributeMod_CreateIncreaseAttributeCommand()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _AttributeMod_CreateCommands
;============================================================================================
Func _AttributeMod_CreateIncreaseAttributeCommand()
    _('CommandIncreaseAttribute:')
    _('mov edx,dword[eax+4]')
    _('push edx')
    _('mov ecx,dword[eax+8]')
    _('push ecx')
    _('call IncreaseAttributeFunction')
    _('pop ecx')
    _('pop edx')
    _('ljmp CommandReturn')
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_CreateDecreaseAttributeCommand
; Description ...: Creates ASM command for decreasing an attribute
; Syntax.........: _AttributeMod_CreateDecreaseAttributeCommand()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Internal module function
; Related .......: _AttributeMod_CreateCommands
;============================================================================================
Func _AttributeMod_CreateDecreaseAttributeCommand()
    _('CommandDecreaseAttribute:')
    _('mov edx,dword[eax+4]')
    _('push edx')
    _('mov ecx,dword[eax+8]')
    _('push ecx')
    _('call DecreaseAttributeFunction')
    _('pop ecx')
    _('pop edx')
    _('ljmp CommandReturn')
EndFunc
#EndRegion Pattern, Structure & Assembly Code Generation

#Region Internal Functions
; #FUNCTION# ;===============================================================================
; Name...........: _AttributeMod_CreateCommands
; Description ...: Creates ASM commands for attribute operations
; Syntax.........: _AttributeMod_CreateCommands()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified.......: Greg76
; Remarks .......: - Called during ASM command creation phase
; Related .......: _AttributeMod_DefinePatterns
;============================================================================================
Func _AttributeMod_CreateCommands()
    _Log_Debug("Creating attribute-related ASM commands...", "AttributeMgr", $GUIEdit)

    ; Command for increasing an attribute
    _AttributeMod_CreateIncreaseAttributeCommand()

    ; Command for decreasing an attribute
    _AttributeMod_CreateDecreaseAttributeCommand()

    _Log_Debug("Attribute commands created successfully", "AttributeMgr", $GUIEdit)
EndFunc
#EndRegion Internal Functions