#include-once

#include 'GwAu3_Core.au3'
#include 'GwAu3_GetInfo.au3'

#Region PerformAction
Global Const $ControlAction_None = 0x00
Global Const $ControlAction_Interact = 0x80
Global Const $ControlAction_ActivateWeaponSet1 = 0x81
Global Const $ControlAction_ActivateWeaponSet2 = 0x82
Global Const $ControlAction_ActivateWeaponSet3 = 0x83
Global Const $ControlAction_ActivateWeaponSet4 = 0x84
Global Const $ControlAction_CloseAllPanels = 0x85
Global Const $ControlAction_CycleEquipment = 0x86
;0x87 ??
Global Const $ControlAction_OpenAlliance = 0x88
Global Const $ControlAction_ShowOthers = 0x89
Global Const $ControlAction_OpenHero = 0x8A
Global Const $ControlAction_ToggleInventoryWindow = 0x8B
Global Const $ControlAction_OpenWorldMap = 0x8C
Global Const $ControlAction_OpenOptions = 0x8D
Global Const $ControlAction_OpenQuestLog = 0x8E
Global Const $ControlAction_OpenSkillsAndAttributes = 0x8F
Global Const $ControlAction_ReverseCamera = 0x90
Global Const $ControlAction_StrafeLeft = 0x91
Global Const $ControlAction_StrafeRight = 0x92
Global Const $ControlAction_TargetNearestEnemy = 0x93
Global Const $ControlAction_ShowTargets = 0x94
Global Const $ControlAction_TargetNextEnemy = 0x95
Global Const $ControlAction_TargetPartyMember1 = 0x96
Global Const $ControlAction_TargetPartyMember2 = 0x97
Global Const $ControlAction_TargetPartyMember3 = 0x98
Global Const $ControlAction_TargetPartyMember4 = 0x99
Global Const $ControlAction_TargetPartyMember5 = 0x9A
Global Const $ControlAction_TargetPartyMember6 = 0x9B
Global Const $ControlAction_TargetPartyMember7 = 0x9C
Global Const $ControlAction_TargetPartyMember8 = 0x9D
Global Const $ControlAction_TargetPreviousEnemy = 0x9E
Global Const $ControlAction_TargetPriorityTarget = 0x9F
Global Const $ControlAction_TargetSelf = 0xA0
Global Const $ControlAction_OpenChat = 0xA1
Global Const $ControlAction_TurnLeft = 0xA2
Global Const $ControlAction_TurnRight = 0xA3
Global Const $ControlAction_UseSkill1 = 0xA4
Global Const $ControlAction_UseSkill2 = 0xA5
Global Const $ControlAction_UseSkill3 = 0xA6
Global Const $ControlAction_UseSkill4 = 0xA7
Global Const $ControlAction_UseSkill5 = 0xA8
Global Const $ControlAction_UseSkill6 = 0xA9
Global Const $ControlAction_UseSkill7 = 0xAA
Global Const $ControlAction_UseSkill8 = 0xAB
Global Const $ControlAction_MoveBackward = 0xAC
Global Const $ControlAction_MoveForward = 0xAD
Global Const $ControlAction_Screenshot = 0xAE
Global Const $ControlAction_CancelAction = 0xAF
Global Const $ControlAction_FreeCamera = 0xB0
Global Const $ControlAction_ReverseDirection = 0xB1
Global Const $ControlAction_OpenBackpack = 0xB2
Global Const $ControlAction_OpenBelt = 0xB3
Global Const $ControlAction_OpenBag1 = 0xB4
Global Const $ControlAction_OpenBag2 = 0xB5
Global Const $ControlAction_OpenMissionMap = 0xB6
Global Const $ControlAction_Autorun = 0xB7
Global Const $ControlAction_ToggleAllBags = 0xB8
Global Const $ControlAction_OpenFriends = 0xB9
Global Const $ControlAction_OpenGuild = 0xBA
;0xBB ??
Global Const $ControlAction_TargetAllyNearest = 0xBC
Global Const $ControlAction_OpenScoreChart = 0xBD
Global Const $ControlAction_CharReply = 0xBE
Global Const $ControlAction_OpenParty = 0xBF
;0xC0 ??
Global Const $ControlAction_OpenCustomizeLayout = 0xC1
Global Const $ControlAction_OpenMinionList = 0xC2
Global Const $ControlAction_TargetNearestItem = 0xC3
Global Const $ControlAction_TargetNextItem = 0xC4
Global Const $ControlAction_TargetPreviousItem = 0xC5
Global Const $ControlAction_TargetPartyMember9 = 0xC6
Global Const $ControlAction_TargetPartyMember10 = 0xC7
Global Const $ControlAction_TargetPartyMember11 = 0xC8
Global Const $ControlAction_TargetPartyMember12 = 0xC9
Global Const $ControlAction_TargetPartyMemberNext = 0xCA
Global Const $ControlAction_TargetPartyMemberPrevious = 0xCB
Global Const $ControlAction_Follow = 0xCC
Global Const $ControlAction_DropItem = 0xCD
Global Const $ControlAction_CameraZoomIn = 0xCE
Global Const $ControlAction_CameraZoomOut = 0xCF
Global Const $ControlAction_SuppressAction = 0xD0
;0xD1  ??
;0xD2 ??
Global Const $ControlAction_OpenTemplateManager = 0xD3
Global Const $ControlAction_OpenSaveEquipmentTemplate = 0xD4
Global Const $ControlAction_OpenSaveSkillTemplate = 0xD5
Global Const $ControlAction_CommandParty = 0xD6
Global Const $ControlAction_CommandHero1 = 0xD7
Global Const $ControlAction_CommandHero2 = 0xD8
Global Const $ControlAction_CommandHero3 = 0xD9
;0xDA ??
Global Const $ControlAction_ClearPartyCommands = 0xDB
Global Const $ControlAction_OpenHeroCommander1 = 0xDC
Global Const $ControlAction_OpenHeroCommander2 = 0xDD
Global Const $ControlAction_OpenHeroCommander3 = 0xDE
;0xDF ??
Global Const $ControlAction_OpenHero1PetCommander = 0xE0
Global Const $ControlAction_OpenHero2PetCommander = 0xE1
Global Const $ControlAction_OpenHero3PetCommander = 0xE2
Global Const $ControlAction_ClearTarget = 0xE3
Global Const $ControlAction_Hero1Skill1 = 0xE5
Global Const $ControlAction_Hero1Skill2 = 0xE6
Global Const $ControlAction_Hero1Skill3 = 0xE7
Global Const $ControlAction_Hero1Skill4 = 0xE8
Global Const $ControlAction_Hero1Skill5 = 0xE9
Global Const $ControlAction_Hero1Skill6 = 0xEA
Global Const $ControlAction_Hero1Skill7 = 0xEB
Global Const $ControlAction_Hero1Skill8 = 0xEC
Global Const $ControlAction_Hero2Skill1 = 0xED
Global Const $ControlAction_Hero2Skill2 = 0xEE
Global Const $ControlAction_Hero2Skill3 = 0xEF
Global Const $ControlAction_Hero2Skill4 = 0xF0
Global Const $ControlAction_Hero2Skill5 = 0xF1
Global Const $ControlAction_Hero2Skill6 = 0xF2
Global Const $ControlAction_Hero2Skill7 = 0xF3
Global Const $ControlAction_Hero2Skill8 = 0xF4
Global Const $ControlAction_Hero3Skill1 = 0xF5
Global Const $ControlAction_Hero3Skill2 = 0xF6
Global Const $ControlAction_Hero3Skill3 = 0xF7
Global Const $ControlAction_Hero3Skill4 = 0xF8
Global Const $ControlAction_Hero3Skill5 = 0xF9
Global Const $ControlAction_Hero3Skill6 = 0xFA
Global Const $ControlAction_Hero3Skill7 = 0xFB
Global Const $ControlAction_Hero3Skill8 = 0xFC
Global Const $ControlAction_OpenHero4PetCommander = 0xFE
Global Const $ControlAction_OpenHero5PetCommander = 0xFF
Global Const $ControlAction_OpenHero6PetCommander = 0x100
Global Const $ControlAction_OpenHero7PetCommander = 0x101
Global Const $ControlAction_CommandHero4 = 0x102
Global Const $ControlAction_CommandHero5 = 0x103
Global Const $ControlAction_CommandHero6 = 0x104
Global Const $ControlAction_CommandHero7 = 0x105
Global Const $ControlAction_Hero4Skill1 = 0x106
Global Const $ControlAction_Hero4Skill2 = 0x107
Global Const $ControlAction_Hero4Skill3 = 0x108
Global Const $ControlAction_Hero4Skill4 = 0x109
Global Const $ControlAction_Hero4Skill5 = 0x10A
Global Const $ControlAction_Hero4Skill6 = 0x10B
Global Const $ControlAction_Hero4Skill7 = 0x10C
Global Const $ControlAction_Hero4Skill8 = 0x10D
Global Const $ControlAction_Hero5Skill1 = 0x10E
Global Const $ControlAction_Hero5Skill2 = 0x10F
Global Const $ControlAction_Hero5Skill3 = 0x110
Global Const $ControlAction_Hero5Skill4 = 0x111
Global Const $ControlAction_Hero5Skill5 = 0x112
Global Const $ControlAction_Hero5Skill6 = 0x113
Global Const $ControlAction_Hero5Skill7 = 0x114
Global Const $ControlAction_Hero5Skill8 = 0x115
Global Const $ControlAction_Hero6Skill1 = 0x116
Global Const $ControlAction_Hero6Skill2 = 0x117
Global Const $ControlAction_Hero6Skill3 = 0x118
Global Const $ControlAction_Hero6Skill4 = 0x119
Global Const $ControlAction_Hero6Skill5 = 0x11A
Global Const $ControlAction_Hero6Skill6 = 0x11B
Global Const $ControlAction_Hero6Skill7 = 0x11C
Global Const $ControlAction_Hero6Skill8 = 0x11D
Global Const $ControlAction_Hero7Skill1 = 0x11E
Global Const $ControlAction_Hero7Skill2 = 0x11F
Global Const $ControlAction_Hero7Skill3 = 0x120
Global Const $ControlAction_Hero7Skill4 = 0x121
Global Const $ControlAction_Hero7Skill5 = 0x122
Global Const $ControlAction_Hero7Skill6 = 0x123
Global Const $ControlAction_Hero7Skill7 = 0x124
Global Const $ControlAction_Hero7Skill8 = 0x125
Global Const $ControlAction_OpenHeroCommander4 = 0x126
Global Const $ControlAction_OpenHeroCommander5 = 0x127
Global Const $ControlAction_OpenHeroCommander6 = 0x128
Global Const $ControlAction_OpenHeroCommander7 = 0x129

Global Const $ActionType_Activate = 0x1E
Global Const $ActionType_Desactivate = 0x20

Func ControlAction($lAction, $lActionType = $ActionType_Activate)
	Return PerformAction($lAction, $lActionType)
EndFunc
#EndRegion
