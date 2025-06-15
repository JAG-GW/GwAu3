#include-once
#include '../GwAu3_Core.au3'

; Trading operations
Global Const $HEADER_TRADE_CANCEL = 0x0001          ; Cancel the current trade.
Global Const $HEADER_TRADE_ADD_ITEM = 0x0002        ; Add an item to the trade offer.
Global Const $HEADER_TRADE_SUBMIT_OFFER = 0x0003    ; Submit the current trade offer.
;~ Global Const $HEADER_MAX_ATTRIBUTES_CONST = 0x0004  ; Maximum attributes constant (not in use).
;~ Global Const $HEADER_TRADE_REMOVE_ITEM = 0x0005     ; Remove an item from the trade offer.
Global Const $HEADER_TRADE_CANCEL_OFFER = 0x0006    ; Cancel the trade offer made.
Global Const $HEADER_TRADE_ACCEPT = 0x0007          ; Accept the trade offer.
;~ Global Const $HEADER_DISCONNECT = 0x0008            ; Handle a disconnect event.
;~ Global Const $HEADER_PING_REPLY = 0x0009            ; Respond to a ping request.
;~ Global Const $HEADER_HEARTBEAT = 0x000A             ; Send a heartbeat signal to maintain connection.
;~ Global Const $HEADER_PING_REQUEST = 0x000B          ; Send a ping request to another entity.
;~ Global Const $HEADER_ATTRIBUTE_DECREASE = 0x000C    ; Decrease an attribute value.
;~ Global Const $HEADER_ATTRIBUTE_INCREASE = 0x000D    ; Increase an attribute value.
;~ Global Const $HEADER_ATTRIBUTE_LOAD = 0x000E        ; Load attribute data.

; Quest and Hero operations
Global Const $HEADER_QUEST_ABANDON = 0x0010         ; Abandon the selected quest.
Global Const $HEADER_QUEST_REQUEST_INFOS = 0x0011   ; Request information for a quest.
Global Const $HEADER_QUEST_SET_ACTIVE = 0x0013      ; Set a quest as active.
Global Const $HEADER_HERO_BEHAVIOR = 0x0014         ; Define hero behavior settings.
Global Const $HEADER_HERO_LOCK_TARGET = 0x0015      ; Lock onto a specific target.
Global Const $HEADER_HERO_SKILL_TOGGLE = 0x0018     ; Toggle a hero's skill on/off.
Global Const $HEADER_HERO_FLAG_SINGLE = 0x0019      ; Flag hero for single-target actions.
Global Const $HEADER_HERO_FLAG_ALL = 0x001A         ; Flag hero for multi-target actions. Flag all heroes and Clears All Flags from heroes.
Global Const $HEADER_HERO_USE_SKILL = 0x001B        ; Hero uses a specified skill.
Global Const $HEADER_HERO_ADD = 0x001D              ; Add a hero to the party or team.
Global Const $HEADER_HERO_KICK = 0x001E             ; Remove a hero from the party or team.
;~ Global Const $HEADER_MOVEMENT_TICK = 0x001E         ; Manage movement ticks (not in use).

; Action operations
Global Const $HEADER_ACTION_ATTACK = 0x0025         ; Initiate an attack.
;Global Const $HEADER_ATTACK_AGENT = 0x0024 ; Initiates an attack on a selected agent
Global Const $HEADER_ACTION_CANCEL = 0x0027         ; Cancel the current action.
Global Const $HEADER_BUFF_DROP = 0x0028             ; Drop or remove a buff.
Global Const $HEADER_CALL_TARGET = 0x22 ;Calls the target without attacking (Ctrl+Shift+Space)
;~ Global Const $HEADER_MAP_DRAW = 0x0029              ; Draw or update the map (not in use).
Global Const $HEADER_DROP_ITEM = 0x002B             ; Drop an item from the inventory.
Global Const $HEADER_DROP_GOLD = 0x002E             ; Drop gold or currency.
Global Const $HEADER_ITEM_EQUIP = 0x002F            ; Equip an item.
Global Const $HEADER_INTERACT_PLAYER = 0x0032       ; Interact with another player.
Global Const $HEADER_FACTION_DEPOSIT = 0x0034       ; Deposit resources into a faction bank.
Global Const $HEADER_INTERACT_LIVING = 0x0038       ; Interact with a living entity.
Global Const $HEADER_DIALOG_SEND = 0x003A           ; Send dialog choices.
;~ Global Const $HEADER_PLAYER_MOVE_COORD = 0x003C     ; Move player to specific coordinates (not in use).
Global Const $HEADER_ITEM_INTERACT = 0x003E         ; Interact with an item.
;~ Global Const $HEADER_PLAYER_ROTATE = 0x003E         ; Rotate the player (not in use).
Global Const $HEADER_PROFESSION_CHANGE = 0x0040     ; Change player's profession.
;~ Global Const $HEADER_SKILLS_OPEN = 0x0040           ; Open the skills interface (not in use).
;~ Global Const $HEADER_PROFESSION_ULOCK = 0x0040      ; Unlock a profession (not in use).
Global Const $HEADER_SKILL_USE = 0x0045             ; Use a specific skill (not in use).
Global Const $HEADER_TRADE_INITIATE = 0x0048        ; Initiate a trade with another player.
;~ Global Const $HEADER_BUY_MATERIALS = 0x0048         ; Buy materials (not in use).
Global Const $HEADER_REQUEST_QUOTE = 0x004B         ; Request a quote for services or goods (not in use).
;~ Global Const $HEADER_TRANSACT_ITEMS = 0x004B        ; Transaction of items (not in use).
Global Const $HEADER_ITEM_UNEQUIP = 0x004E          ; Unequip an item.
Global Const $HEADER_GADGET_INTERACT = 0x0050       ; Interact with a gadget.
Global Const $HEADER_CHEST_OPEN = 0x0052            ; Open a treasure chest.
Global Const $HEADER_TITLE_DISPLAY = 0x0057         ; Display a title above the character.
Global Const $HEADER_TITLE_HIDE = 0x0058            ; Hide the displayed title.
Global Const $HEADER_SKILLBAR_SKILL_SET = 0x005B    ; Set a skill on the skillbar.
Global Const $HEADER_SKILLBAR_LOAD = 0x005C         ; Load the skillbar settings.
;~ Global Const $HEADER_SKILLBAR_SKILL_REPLACE = 0x005C; Replace a skill on the skillbar (not in use).
Global Const $HEADER_CINEMATIC_SKIP = 0x0062        ; Skip a cinematic scene.
Global Const $HEADER_SEND_CHAT_MESSAGE = 0x0063     ; Send a message in the chat.
Global Const $HEADER_ITEM_DESTROY = 0x0068          ; Destroy an item.
Global Const $HEADER_ITEM_IDENTIFY = 0x006B         ; Identify the properties of an item.
Global Const $HEADER_TOME_UNLOCK_SKILL = 0x006C     ; Unlock a skill using a tome.
Global Const $HEADER_ITEM_MOVE = 0x0071             ; Move an item within the inventory.
Global Const $HEADER_ITEMS_ACCEPT_UNCLAIMED = 0x0072; Accept unclaimed items.
Global Const $HEADER_ITEM_SPLIT_STACK = 0x0074      ; Split an item stack.
Global Const $HEADER_ITEM_SALVAGE_SESSION_OPEN = 0x0076   ; Open a salvage session.
Global Const $HEADER_ITEM_SALVAGE_SESSION_CANCEL = 0x0077 ; Cancel the salvage session.
Global Const $HEADER_ITEM_SALVAGE_SESSION_DONE = 0x0078   ; Complete the salvage session.
Global Const $HEADER_ITEM_SALVAGE_MATERIALS = 0x0079      ; Salvage materials from an item.
Global Const $HEADER_ITEM_SALVAGE_UPGRADE = 0x007A        ; Upgrade an item through salvage.
Global Const $HEADER_ITEM_CHANGE_GOLD = 0x007B            ; Change the gold amount for an item.
Global Const $HEADER_ITEM_USE = 0x007D                    ; Use an item.
;~ Global Const $HEADER_UPGRADE_ARMOR = 0x0083               ; Upgrade armor (not in use).
;~ Global Const $HEADER_UPGRADE = 0x0086                     ; General upgrade command (not in use).
;~ Global Const $HEADER_INSTANCE_LOAD_REQUEST_SPAWN = 0x0086 ; Request spawn in an instance (not in use).
;~ Global Const $HEADER_INSTANCE_LOAD_REQUEST_PLAYERS = 0x008E; Request player data in an instance (not in use).
;~ Global Const $HEADER_INSTANCE_LOAD_REQUEST_ITEMS = 0x008F ; Request item data in an instance (not in use).
Global Const $HEADER_PARTY_SET_DIFFICULTY = 0x009A        ; Set the difficulty for a party quest or dungeon.
Global Const $HEADER_PARTY_ACCEPT_INVITE = 0x009B         ; Accept an invitation to join a party.
;~ Global Const $HEADER_PARTY_ACCEPT_CANCEL = 0x009B         ; Cancel party invitation acceptance (not in use).
;~ Global Const $HEADER_PARTY_ACCEPT_REFUSE = 0x009C         ; Refuse an invitation to join a party.
Global Const $HEADER_PARTY_INVITE_NPC = 0x009E            ; Invite an NPC to the party.
Global Const $HEADER_PARTY_INVITE_PLAYER = 0x009F         ; Invite a player to the party.
Global Const $HEADER_PARTY_LEAVE_GROUP = 0x00A1           ; Leave the current party or group.
Global Const $HEADER_PARTY_CANCEL_ENTER_CHALLENGE = 0x00A2; Cancel entering a challenge.
Global Const $HEADER_PARTY_ENTER_CHALLENGE = 0x00A4       ; Enter a challenge or dungeon.
Global Const $HEADER_PARTY_RETURN_TO_OUTPOST = 0x00A6     ; Return the party to the outpost.
Global Const $HEADER_PARTY_KICK_NPC = 0x00A7              ; Kick an NPC from the party.
Global Const $HEADER_PARTY_KICK_PLAYER = 0x00A8           ; Kick a player from the party.
;~ Global Const $HEADER_PARTY_SEARCH_SEEK = 0x00A8           ; Search for a party (not in use).
;~ Global Const $HEADER_PARTY_SEARCH_CANCEL = 0x00A9         ; Cancel party search (not in use).
;~ Global Const $HEADER_PARTY_SEARCH_REQUEST_JOIN = 0x00AA   ; Request to join a party search (not in use).
;~ Global Const $HEADER_PARTY_ENTER_FOREIGN_CHALLENGE = 0x00AD; Enter a foreign challenge (not in use).
;~ Global Const $HEADER_PARTY_SEARCH_REQUEST_REPLY = 0x00AB  ; Reply to a party search request (not in use).
;~ Global Const $HEADER_PARTY_SEARCH_TYPE = 0x00AC           ; Set the search type for party search (not in use).
;~ Global Const $HEADER_PARTY_READY_STATUS = 0x00AD          ; Indicate ready status in party (not in use).
Global Const $HEADER_PARTY_ENTER_GUILD_HALL = 0x00AF      ; Enter a guild hall.
Global Const $HEADER_PARTY_TRAVEL = 0x00B0                ; Travel to a new location with the party.
Global Const $HEADER_PARTY_LEAVE_GUILD_HALL = 0x00B1      ; Leave the guild hall.

;=ITEMS=
Global Const $HEADER_ITEM_PICKUP = 0x3E ;Picks up an item from ground
Global Const $HEADER_ITEM_MOVE_EX = 0x73 ;Moves an item, with amount to be moved.
Global Const $HEADER_UPGRADE = 0x86 ;used by gwapi. is it even useful? NOT TESTED
Global Const $HEADER_UPGRADE_ARMOR_1 = 0x83 ;used by gwapi. is it even useful? NOT TESTED
Global Const $HEADER_UPGRADE_ARMOR_2 = 0x86 ;used by gwapi. is it even useful? NOT TESTED
Global Const $HEADER_EQUIP_BAG = 0x70
Global Const $HEADER_SWITCH_SET = 0x31

#Region Item GwAu3_Core_SendPacket
;~ Description: Salvage the materials out of an item.
Func SalvageMaterials()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_ITEM_SALVAGE_MATERIALS)
EndFunc   ;==>SalvageMaterials

;~ Description: Salvages a mod out of an item.
Func SalvageMod($aModIndex)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_ITEM_SALVAGE_UPGRADE, $aModIndex)
EndFunc   ;==>SalvageMod

;~ Description: Identifies an item.
Func IdentifyItem($aItem, $aKitType = "Superior")
	Local $lIDKit = 0
	Local $lItemID = GwAu3_ItemMod_ItemID($aItem)

    If GwAu3_ItemMod_GetItemInfoByItemID($lItemID, "IsIdentified") Then Return True

	Switch $aKitType
		Case "Superior"
			If GwAu3_MapMod_GetInstanceInfo("IsOutpost") Then
				$lIDKit = GwAu3_ItemMod_GetItemInfoByModelID(5899, "ItemID")
				If $lIDKit = 0 Then $lIDKit = GwAu3_ItemMod_GetItemInfoByModelID(2989, "ItemID")
			ElseIf GwAu3_MapMod_GetInstanceInfo("IsExplorable") Then
				$lIDKit = GwAu3_ItemMod_GetBagsItembyModelID(5899)
				If $lIDKit = 0 Then $lIDKit = GwAu3_ItemMod_GetBagsItembyModelID(2989)
			EndIf
		Case "Normal"
			If GwAu3_MapMod_GetInstanceInfo("IsOutpost") Then
				$lIDKit = GwAu3_ItemMod_GetItemInfoByModelID(2989, "ItemID")
				If $lIDKit = 0 Then $lIDKit = GwAu3_ItemMod_GetItemInfoByModelID(5899, "ItemID")
			ElseIf GwAu3_MapMod_GetInstanceInfo("IsExplorable") Then
				$lIDKit = GwAu3_ItemMod_GetBagsItembyModelID(2989)
				If $lIDKit = 0 Then $lIDKit = GwAu3_ItemMod_GetBagsItembyModelID(5899)
			EndIf
	EndSwitch

    If $lIDKit = 0 Then Return False

    GwAu3_Core_SendPacket(0xC, $HEADER_ITEM_IDENTIFY, GwAu3_ItemMod_ItemID($lIDKit), $lItemID)

    Local $lDeadlock = TimerInit()
    Do
        Sleep(16)
    Until GwAu3_ItemMod_GetItemInfoByItemID($lItemID, "IsIdentified") Or TimerDiff($lDeadlock) > 2500

	If TimerDiff($lDeadlock) > 2500 Then Return False

    Return True
EndFunc   ;==>IdentifyItem

;~ Description: Equips an item.
Func EquipItem($aItem)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_ITEM_EQUIP, GwAu3_ItemMod_ItemID($aItem))
EndFunc   ;==>EquipItem

;~ Description: Uses an item.
Func UseItem($aItem)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_ITEM_USE, GwAu3_ItemMod_ItemID($aItem))
EndFunc   ;==>UseItem

;~ Description: Picks up an item.
Func PickUpItem($aAgentID)
    Return GwAu3_Core_SendPacket(0xC, $HEADER_ITEM_PICKUP, GwAu3_AgentMod_ConvertID($aAgentID), 0)
EndFunc   ;==>PickUpItem

;~ Description: Drops an item.
Func DropItem($aItem, $aAmount = 0)
	Local $lItemID = GwAu3_ItemMod_ItemID($aItem)
	Local $lQuantity = GwAu3_ItemMod_GetItemInfoByItemID($aItem, "Quantity")
    If $aAmount = 0 Or $aAmount > $lQuantity Then $aAmount = $lQuantity
    Return GwAu3_Core_SendPacket(0xC, $HEADER_DROP_ITEM, $lItemID, $aAmount)
EndFunc ;==>DropItem

;~ Description: Moves an item.
Func MoveItem($aItem, $aBagNumber, $aSlot)
	Return GwAu3_Core_SendPacket(0x10, $HEADER_ITEM_MOVE, GwAu3_ItemMod_ItemID($aItem), GwAu3_ItemMod_GetBagInfo($aBagNumber, "ID"), $aSlot - 1)
EndFunc   ;==>MoveItem

;~ Description: Accepts unclaimed items after a mission.
Func AcceptAllItems()
	Return GwAu3_Core_SendPacket(0x8, $HEADER_ITEMS_ACCEPT_UNCLAIMED, GwAu3_ItemMod_GetBagInfo(7, "ID"))
EndFunc   ;==>AcceptAllItems

;~ Description: Drop gold on the ground.
Func DropGold($aAmount = 0)
	Local $lAmount = GwAu3_ItemMod_GetInventoryInfo("GoldCharacter")
	If $aAmount = 0 Or $aAmount > $lAmount Then $aAmount = $lAmount
	Return GwAu3_Core_SendPacket(0x8, $HEADER_DROP_GOLD, $aAmount)
EndFunc   ;==>DropGold

;~ Description: Internal use for moving gold.
Func ChangeGold($aCharacter, $aStorage)
	Return GwAu3_Core_SendPacket(0xC, $HEADER_ITEM_CHANGE_GOLD, $aCharacter, $aStorage) ;0x75
EndFunc   ;==>ChangeGold
#EndRegion Item GwAu3_Core_SendPacket

#Region H&H GwAu3_Core_SendPacket
;~ Description: Adds a hero to the party.
Func AddHero($aHeroId)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_HERO_ADD, $aHeroId)
EndFunc   ;==>AddHero

;~ Description: Kicks a hero from the party.
Func KickHero($aHeroId)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_HERO_KICK, $aHeroId)
EndFunc   ;==>KickHero

;~ Description: Kicks all heroes from the party.
Func KickAllHeroes()
	Return GwAu3_Core_SendPacket(0x8, $HEADER_HERO_KICK, 0x26)
EndFunc

;~ Description: Add a henchman to the party.
Func AddNpc($aNpcId)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_PARTY_INVITE_NPC, $aNpcId)
EndFunc   ;==>AddNpc

;~ Description: Kick a henchman from the party.
Func KickNpc($aNpcId)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_PARTY_KICK_NPC, $aNpcId)
EndFunc   ;==>KickNpc

;~ Description: Clear the position flag from a hero.
Func CancelHero($aHeroNumber)
	Local $lAgentID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Return GwAu3_Core_SendPacket(0x14, $HEADER_HERO_FLAG_SINGLE, $lAgentID, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelHero

;~ Description: Clear the position flag from all heroes.
Func CancelAll()
	Return GwAu3_Core_SendPacket(0x10, $HEADER_HERO_FLAG_ALL, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelAll

;~ Description: Place a hero's position flag.
Func CommandHero($aHeroNumber, $aX, $aY)
	Return GwAu3_Core_SendPacket(0x14, $HEADER_HERO_FLAG_SINGLE, GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID"), GwAu3_Utils_FloatToInt($aX), GwAu3_Utils_FloatToInt($aY), 0)
EndFunc   ;==>CommandHero

;~ Description: Place the full-party position flag.
Func CommandAll($aX, $aY)
	Return GwAu3_Core_SendPacket(0x10, $HEADER_HERO_FLAG_ALL, GwAu3_Utils_FloatToInt($aX), GwAu3_Utils_FloatToInt($aY), 0)
EndFunc   ;==>CommandAll

;~ Description: Lock a hero onto a target.
Func LockHeroTarget($aHeroNumber, $aAgentID = 0) ;$aAgentID=0 Cancels Lock
	Return GwAu3_Core_SendPacket(0xC, $HEADER_HERO_LOCK_TARGET, GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID"), $aAgentID)
EndFunc   ;==>LockHeroTarget

;~ Description: Change a hero's aggression level.
Func SetHeroAggression($aHeroNumber, $aAggression) ;0=Fight, 1=Guard, 2=Avoid
	Return GwAu3_Core_SendPacket(0xC, $HEADER_HERO_BEHAVIOR, GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID"), $aAggression)
EndFunc   ;==>SetHeroAggression

;~ Description: Internal use for enabling or disabling hero skills
Func ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot)
	Return GwAu3_Core_SendPacket(0xC, $HEADER_HERO_SKILL_TOGGLE, GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID"), $aSkillSlot - 1)
EndFunc   ;==>ChangeHeroSkillSlotState
#EndRegion H&H GwAu3_Core_SendPacket

#Region Movement & Combat GwAu3_Core_SendPacket
;~ Description: Run to or follow a player.
Func GoPlayer($aAgent)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_INTERACT_PLAYER, GwAu3_AgentMod_ConvertID($aAgent))
EndFunc   ;==>GoPlayer

;~ Description: Talk to an NPC
Func GoNPC($aAgent)
	Return GwAu3_Core_SendPacket(0xC, $HEADER_INTERACT_LIVING, GwAu3_AgentMod_ConvertID($aAgent))
EndFunc   ;==>GoNPC

;~ Description: Run to a signpost.
Func GoSignpost($aAgent)
	Return GwAu3_Core_SendPacket(0xC, $HEADER_GADGET_INTERACT, GwAu3_AgentMod_ConvertID($aAgent), 0)
EndFunc   ;==>GoSignpost

;~ Description: Attack an agent.
Func Attack($aAgent, $aCallTarget = False)
	Return GwAu3_Core_SendPacket(0xC, $HEADER_ACTION_ATTACK, GwAu3_AgentMod_ConvertID($aAgent), $aCallTarget)
EndFunc   ;==>Attack

;~ Description: Call target.
Func CallTarget($aTarget)
	Return GwAu3_Core_SendPacket(0xC, $HEADER_CALL_TARGET, 0xA, GwAu3_AgentMod_ConvertID($aTarget))
EndFunc   ;==>CallTarget

;~ Description: Cancel current action.
Func CancelAction()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_ACTION_CANCEL)
EndFunc   ;==>CancelAction

;~ Description: Drop a buff with specific skill ID targeting a specific agent
Func DropBuff($aSkillID, $aAgentID, $aHeroNumber = 0)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_BUFF_DROP, GwAu3_AgentMod_GetAgentBuffInfo(_AgentMod_ConvertID($aAgentID), $aSkillID, "BuffID"))
EndFunc   ;==>DropBuff

;~ Description: Leave your party.
Func LeaveGroup($aKickHeroes = True)
	If $aKickHeroes Then KickAllHeroes()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_PARTY_LEAVE_GROUP)
EndFunc   ;==>LeaveGroup

;~ Description: Change a skill on the skillbar.
Func SetSkillbarSkill($aSlot, $aSkillID, $aHeroNumber = 0)
	Local $lHeroID
	If $aHeroNumber <> 0 Then
		$lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		$lHeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
	EndIf
	Return GwAu3_Core_SendPacket(0x14, $HEADER_SKILLBAR_SKILL_SET, $lHeroID, $aSlot - 1, $aSkillID, 0)
EndFunc   ;==>SetSkillbarSkill

;~ Description: Load all skills onto a skillbar simultaneously.
Func LoadSkillBar($aSkill1 = 0, $aSkill2 = 0, $aSkill3 = 0, $aSkill4 = 0, $aSkill5 = 0, $aSkill6 = 0, $aSkill7 = 0, $aSkill8 = 0, $aHeroNumber = 0)
	Local $lHeroID
	If $aHeroNumber <> 0 Then
		$lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		$lHeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
	EndIf
	Return GwAu3_Core_SendPacket(0x2C, $HEADER_SKILLBAR_LOAD, $lHeroID, 8, $aSkill1, $aSkill2, $aSkill3, $aSkill4, $aSkill5, $aSkill6, $aSkill7, $aSkill8)
EndFunc   ;==>LoadSkillBar

;~ Description: Change your secondary profession.
Func ChangeSecondProfession($aProfession, $aHeroNumber = 0)
	Local $lHeroID
	If $aHeroNumber <> 0 Then
		$lHeroID = GwAu3_PartyMod_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
	Else
		$lHeroID = GwAu3_OtherMod_GetWorldInfo("MyID")
	EndIf
	Return GwAu3_Core_SendPacket(0xC, $HEADER_PROFESSION_CHANGE, $lHeroID, $aProfession)
EndFunc   ;==>ChangeSecondProfession
#EndRegion Movement & Combat GwAu3_Core_SendPacket

#Region Misc GwAu3_Core_SendPacket
;~ Description: Internal use for map travel.
Func MoveMap($aMapID, $aRegion, $aDistrict, $aLanguage)
	Return GwAu3_Core_SendPacket(0x18, $HEADER_PARTY_TRAVEL, $aMapID, $aRegion, $aDistrict, $aLanguage, False)
EndFunc   ;==>MoveMap

;~ Description: Returns to outpost after resigning/failure.
Func ReturnToOutpost()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_PARTY_RETURN_TO_OUTPOST)
EndFunc   ;==>ReturnToOutpost

;~ Description: Enter a challenge mission/pvp.
Func EnterChallenge()
	Return GwAu3_Core_SendPacket(0x8, $HEADER_PARTY_ENTER_CHALLENGE, 1)
EndFunc   ;==>EnterChallenge

;~ Description: Enter a foreign challenge mission/pvp.
;~ Func EnterChallengeForeign()
;~ 	Return GwAu3_Core_SendPacket(0x8, $HEADER_PARTY_ENTER_FOREIGN_CHALLENGE, 0)
;~ EndFunc   ;==>EnterChallengeForeign

;~ Description: Travel to your guild hall.
Func TravelGH()
	Local $lOffset[3] = [0, 0x18, 0x3C]
	Local $lGH = GwAu3_Memory_ReadPtr($mBasePointer, $lOffset)
	GwAu3_Core_SendPacket(0x18, $HEADER_PARTY_ENTER_GUILD_HALL, GwAu3_Memory_Read($lGH[1] + 0x64), GwAu3_Memory_Read($lGH[1] + 0x68), GwAu3_Memory_Read($lGH[1] + 0x6C), GwAu3_Memory_Read($lGH[1] + 0x70), 1)
	;~ Return WaitMapLoading()
EndFunc   ;==>TravelGH

;~ Description: Leave your guild hall.
Func LeaveGH()
	GwAu3_Core_SendPacket(0x8, $HEADER_PARTY_LEAVE_GUILD_HALL, 1)
	;~ Return WaitMapLoading()
EndFunc   ;==>LeaveGH

;~ Description: Switches to/from Hard Mode.
Func SwitchMode($aMode)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_PARTY_SET_DIFFICULTY, $aMode)
EndFunc   ;==>SwitchMode

;~ Description: Donate Kurzick or Luxon faction.
Func DonateFaction($aFaction)
	If StringLeft($aFaction, 1) = 'k' Then
		Return GwAu3_Core_SendPacket(0x10, $HEADER_FACTION_DEPOSIT, 0, 0, 5000)
	Else
		Return GwAu3_Core_SendPacket(0x10, $HEADER_FACTION_DEPOSIT, 0, 1, 5000)
	EndIf
EndFunc   ;==>DonateFaction

;~ Description: Open a dialog.
Func Dialog($aDialogID)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_DIALOG_SEND, $aDialogID)
EndFunc   ;==>Dialog

;~ Description: Skip a cinematic.
Func SkipCinematic()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_CINEMATIC_SKIP)
EndFunc   ;==>SkipCinematic

Func SetDisplayedTitle($aTitle = 0)
	If $aTitle <> 0 Then
		Return GwAu3_Core_SendPacket(0x8, $HEADER_TITLE_DISPLAY, $aTitle)
	Else
		Return GwAu3_Core_SendPacket(0x4, $HEADER_TITLE_HIDE)
	EndIf
EndFunc   ;==>SetDisplayedTitle
#EndRegion Misc GwAu3_Core_SendPacket

#Region Quest GwAu3_Core_SendPacket
;~ Description: Accept a quest from an NPC.
Func AcceptQuest($aQuestID)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_DIALOG_SEND, '0x008' & Hex($aQuestID, 3) & '01')
EndFunc   ;==>AcceptQuest

;~ Description: Accept the reward for a quest.
Func QuestReward($aQuestID)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_DIALOG_SEND, '0x008' & Hex($aQuestID, 3) & '07')
EndFunc   ;==>QuestReward

;~ Description: Abandon a quest.
Func AbandonQuest($aQuestID)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_QUEST_ABANDON, $aQuestID)
EndFunc   ;==>AbandonQuest
#EndRegion Quest GwAu3_Core_SendPacket

#Region Trade GwAu3_Core_SendPacket
Func TradePlayer($aAgent)
	Return GwAu3_Core_SendPacket(0x08, $HEADER_TRADE_INITIATE, GwAu3_AgentMod_ConvertID($aAgent))
EndFunc   ;==>TradePlayer

Func AcceptTrade()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_TRADE_ACCEPT)
EndFunc   ;==>AcceptTrade

;~ Description: Like pressing the "Accept" button in a trade. Can only be used after both players have submitted their offer.
Func SubmitOffer($aGold = 0)
	Return GwAu3_Core_SendPacket(0x8, $HEADER_TRADE_SUBMIT_OFFER, $aGold)
EndFunc   ;==>SubmitOffer

;~ Description: Like pressing the "Cancel" button in a trade.
Func CancelTrade()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_TRADE_CANCEL)
EndFunc   ;==>CancelTrade

;~ Description: Like pressing the "Change Offer" button.
Func ChangeOffer()
	Return GwAu3_Core_SendPacket(0x4, $HEADER_TRADE_CANCEL_OFFER)
EndFunc   ;==>ChangeOffer

;~ $a_ItemMod_ItemID = ID of the item or item agent, $aQuantity = Quantity
Func OfferItem($lItemID, $aQuantity = 1)
;~ 	Local $lItemID
;~ 	$lItemID = GetBag_ItemMod_ItemIDByModelID($aModelID)
	Return GwAu3_Core_SendPacket(0xC, $HEADER_TRADE_ADD_ITEM, $lItemID, $aQuantity)
EndFunc   ;==>OfferItem
#EndRegion Trade GwAu3_Core_SendPacket

;~ Description: Open a chest with key.
Func OpenChestNoLockpick()
	Return GwAu3_Core_SendPacket(0x8, $HEADER_CHEST_OPEN, 1)
EndFunc   ;==>OpenChestNoLockpick

;~ Description: Open a chest with lockpick.
Func OpenChest()
	Return GwAu3_Core_SendPacket(0x8, $HEADER_CHEST_OPEN, 2)
EndFunc   ;==>OpenChest

Func SwitchWeaponSet($aWeaponSet)
    Return GwAu3_Core_SendPacket(0x8, $HEADER_SWITCH_SET, $aWeaponSet)
EndFunc   ;==>SwitchWeaponSet