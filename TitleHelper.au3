#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBoxEx.au3>
#include <ComboConstants.au3>
#include <ButtonConstants.au3>
#include <SliderConstants.au3>
#include <TabConstants.au3>
#include <AVIConstants.au3>
#include <GUIListBox.au3>
#include <GuiListView.au3>
#include <ScrollBarsConstants.au3>
#include <Array.au3>
#include <WinAPIEx.au3>
#include <GuiEdit.au3>
#include <WinAPIFiles.au3>
#include <GuiSlider.au3>
#include <ColorConstants.au3>
#include <WinAPITheme.au3>
#include <WinAPIDiag.au3>
#include "_GwAu3.au3"

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)

#Region Declarations
Global $mCharname
Global $CharList[1]
Global $ProcessIDs[1]

Global $version = "4.0"
Global $BotRunning = False
Global $BotInitialized = False
Global Const $BotTitle = "GW Title Helper v" & $version

Global $bags = 4
Global $slots = 20
Global $lastTimeOfAction = TimerInit()
Global $numberofoutposts = 180
Global $outpost[$numberofoutposts] = ["Ascalon City (pre-Searing)", "Ashford Abbey (pre-Searing)", "Foible's Fair (pre-Searing)","Fort Ranik (pre-Searing)", "The Barradin Estate (pre-Searing)", "Ascalon City", "The Amnoon Oasis", "Droknar's Forge", "Beacon's Perch", "Beetletun", "Bergen Hot Springs", "Camp Rankor", "Copperhammer Mines", "Deldrimor War Camp", "Destiny's Gorge", "Druid's Overlook", "Ember Light Camp", "Fishermen's Haven", "Frontier Gate", "Grendich Courthouse", "Henge of Denravi", "Heroes' Audience", "Ice Tooth Cave", "Lion's Arch", "Maguuma Stade", "Marhan's Grotto", "Piken Square", "Port Sledge", "Quarrel Falls", "Sardelac Sanitarium", "Seeker's Passage", "Serenity Temple", "Temple of the Ages", "The Granite Citadel", "Tomb of the Primeval Kings", "Ventari's Refuge", "Yak's Bend", "Abaddon's Mouth (outpost)", "Augury Rock (outpost)", "Aurora Glade (outpost)", "Bloodstone Fen (outpost)", "Borlis Pass (outpost)", "D'Alessio Seaboard (outpost)", "Divinity Coast (outpost)", "Dunes of Despair (outpost)", "Elona Reach (outpost)", "Fort Ranik (outpost)", "Gates of Kryta (outpost)", "Hell's Precipice (outpost)", "Ice Caves of Sorrow (outpost)", "Iron Mines of Moladune (outpost)", "Nolani Academy (outpost)", "Ring of Fire (outpost)", "Riverside Province (outpost)", "Ruins of Surmia (outpost)", "Sanctum Cay (outpost)", "The Dragon's Lair (outpost)", "The Frost Gate (outpost)", "The Great Northern Wall (outpost)", "The Wilds (outpost)", "Thirsty River (outpost)", "Thunderhead Keep (outpost)", _
"Aspenwood Gate (Kurzick)", "Aspenwood Gate (Luxon)", "Bai Paasu Reach", "Brauer Academy", "Breaker Hollow", "Cavalon", "Durheim Archives", "Eredon Terrace", "Harvest Temple", "House zu Heltzer", "Jade Flats (Kurzick)", "Jade Flats (Luxon)", "Kaineng Center", "Leviathan Pits", "Lutgardis Conservatory", "Maatu Keep", "Ran Musu Gardens", "Saint Anjeka's Shrine", "Seafarer's Rest", "Seitung Harbor", "Senji's Corner", "Shing Jea Arena", "Shing Jea Monastery", "Tanglewood Copse", "The Marketplace", "Tsumei Village", "Vasburg Armory", "Zin Ku Corridor", "Altrumm Ruins (outpost)", "Amatz Basin (outpost)", "Arborstone (outpost)", "Boreas Seabed (outpost)", "Dragon's Throat (outpost)", "Fort Aspenwood (Kurzick) (outpost)", "Fort Aspenwood (Luxon) (outpost)", "Gyala Hatchery (outpost)", "Imperial Sanctum (outpost)", "Minister Cho's Estate (outpost)", "Nahpui Quarter (outpost)", "Raisu Palace (outpost)", "Sunjiang District (outpost)", "Tahnnakai Temple (outpost)", "The Aurios Mines (outpost)", "The Deep (outpost)", "The Eternal Grove (outpost)", "The Jade Quarry (Kurzick) (outpost)", "The Jade Quarry (Luxon) (outpost)", "Unwaking Waters (Kurzick) (outpost)", "Unwaking Waters (Luxon) (outpost)", "Urgoz's Warren (outpost)", "Vizunah Square (Foreign Quarter) (outpost)", "Vizunah Square (Local Quarter) (outpost)", "Zen Daijun (outpost)", "Zos Shivros Channel (outpost)", _
"Basalt Grotto", "Beknur Harbor", "Bone Palace", "Camp Hojanu", "Champion's Dawn", "Chantry of Secrets", "Gate of Fear", "Gate of Secrets", "Gate of the Nightfallen Lands", "Gate of Torment", "Honur Hill", "Kamadan, Jewel of Istan", "Kodlonu Hamlet", "Lair of the Forgotten", "Mihanu Township", "Sunspear Arena", "Sunspear Great Hall", "Sunspear Sanctuary", "The Astralarium", "The Kodash Bazaar", "The Mouth of Torment", "Wehhan Terraces", "Yahnur Market", "Yohlon Haven", "Abaddon's Gate (outpost)", "Blacktide Den (outpost)", "Chahbek Village (outpost)", "Consulate Docks (outpost)", "Dajkah Inlet (outpost)", "Dasha Vestibule (outpost)", "Dzagonur Bastion (outpost)", "Gate of Anguish (outpost)", "Gate of Desolation (outpost)", "Gate of Madness (outpost)", "Gate of Pain (outpost)", "Grand Court of Sebelkeh (outpost)", "Jennur's Horde (outpost)", "Jokanur Diggings (outpost)", "Kodonur Crossroads (outpost)", "Moddok Crevice (outpost)", "Nundu Bay (outpost)", "Pogahn Passage (outpost)", "Remains of Sahlahja (outpost)", "Rilohn Refuge (outpost)", "Ruins of Morah (outpost)", "The Shadow Nexus (outpost)", "Tihark Orchard (outpost)", "Venta Cemetery (outpost)", _
"Boreal Station", "Central Transfer Chamber", "Doomlore Shrine", "Eye of the North", "Gadd's Encampment", "Gunnar's Hold", "Longeye's Ledge", "Olafstead", "Rata Sum", "Sifhalla", "Tarnished Haven", "Umbral Grotto", "Vlox's Falls", _
"Great Temple of Balthazar", "Embark Beach", "Zaishen Menagerie"]

Global $outpostID[$numberofoutposts] = [148, 164, 165, 166, 163, 81, 109, 20, 133, 136, 57, 155, 159, 206, 154, 140, 35, 137, 135, 36, 49, 152, 132, 55, 141, 157, 40, 158, 142, 39, 153, 131, 138, 156, 82, 139, 134, 123, 38, 12, 10, 25, 15, 16, 116, 118, 29, 14, 124, 22, 24, 32, 122, 73, 30, 19, 120, 21, 28, 11, 117, 23, _
388, 389, 288, 286, 278, 193, 287, 350, 277, 77, 390, 391, 194, 279, 129, 283, 251, 349, 289, 250, 51, 243, 242, 348, 303, 249, 130, 284, 272, 230, 218, 219, 274, 294, 293, 224, 226, 214, 216, 225, 220, 217, 234, 307, 222, 296, 295, 298, 297, 266, 292, 291, 213, 273, _
398, 457, 438, 376, 479, 393, 469, 473, 559, 450, 403, 449, 489, 442, 396, 497, 431, 387, 502, 414, 440, 378, 407, 381, 496, 492, 544, 493, 554, 434, 433, 474, 478, 495, 494, 435, 476, 491, 424, 427, 477, 426, 545, 425, 480, 555, 428, 421, _
675, 652, 648, 642, 638, 644, 650, 645, 640, 643, 641, 639, 624, _
248, 857, 795]

Global $outpost1 = 857 ; Default to Embark Beach
Global $outpost2 = 248 ; Default to Great Temple of Balthazar

Global $TonicModelID[20] = [15837, 21490, 30648, 31142, 30642, 22192, 30646, 31141, 30628, 30636, 30630, 31020, 31172, 30624, 31144, 30638, 30626, 30640, 30632, 4730]
Global $AlcoholModelID[19] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 22190, 24593, 28435, 30855, 31145, 35124, 36682, 31146, 19172, 19173, 19171]
Global $PartyModelID[8] = [6376, 6369, 21810, 21813, 21809, 36683, 6368, 29543]
Global $SweetModelID[9] = [22644, 21492, 15528, 15479, 21812, 35125, 31150, 19170, 36681]
Global $giftsModelID[5] = [28434, 21491, 28434, 21491, 28434] ; idk had to have 5 things for info for they array to work
Global $ZkeyModeID[1] = [28517]

; Title progress values
Global $drunkard = 0
Global $sweet = 0
Global $party = 0
Global $zaishen = 0
Global $MyID
Global $zchestID
Global $dischanger
Global $lang1 = 0
#EndRegion Declarations

; Scan for running Guild Wars instances
Func ScanGWCharacters()
    Local $processes = ProcessList("gw.exe")
    ReDim $CharList[$processes[0][0] + 1]
    ReDim $ProcessIDs[$processes[0][0] + 1]
    Local $count = 1

    For $i = 1 To $processes[0][0]
        Local $pid = $processes[$i][1]
        MemoryOpen($pid)
        If $mGWProcHandle Then
            Local $charName = ScanForCharname()
            If $charName <> "" Then
                $CharList[$count] = $charName
                $ProcessIDs[$count] = $pid
                $count += 1
            EndIf
        EndIf
        MemoryClose()
    Next
    Return $count - 1
EndFunc

Local $numChars = ScanGWCharacters()

#Region ### START GUI section ###
$MainGui = GUICreate($BotTitle, 336, 425, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xEAEAEA, $MainGui)

$Group1 = GUICtrlCreateGroup("Select Your Character", 8, 8, 313, 72)
$GUINameCombo = GUICtrlCreateCombo("", 24, 24, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
If $numChars > 0 Then
    For $i = 1 To $numChars
        _GUICtrlComboBox_AddString($GUINameCombo, $CharList[$i])
    Next
EndIf

$GUIRefreshButton = GUICtrlCreateButton("Refresh", 176, 26, 51, 17)
$gOnTopCheckbox = GUICtrlCreateCheckbox("On Top", 232, 23, 81, 24)
GUICtrlSetState(-1, $GUI_CHECKED)
$GUIStartButton = GUICtrlCreateButton("Initialize Client", 24, 50, 111, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group2 = GUICtrlCreateGroup("Title Progress", 8, 88, 313, 60)
$drunkardTXT = GUICtrlCreateLabel("Drunkard:", 16, 104, 70, 17)
$sweetTXT = GUICtrlCreateLabel("Sweet Tooth:", 16, 124, 70, 17)
$zaishenTXT = GUICtrlCreateLabel("Zaishen:", 180, 104, 50, 17)
$partyTXT = GUICtrlCreateLabel("Party:", 180, 124, 70, 17)

$drunkardstatus = GUICtrlCreateLabel("0", 96, 104, 70, 17)
$sweetstatus = GUICtrlCreateLabel("0", 96, 124, 70, 17)
$zaishenstatus = GUICtrlCreateLabel("0", 245, 104, 70, 17)
$partystatus = GUICtrlCreateLabel("0", 245, 124, 70, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group3 = GUICtrlCreateGroup("Actions", 8, 155, 313, 100)
$tonics = GUICtrlCreateCheckbox("Drink Tonics", 16, 170, 90, 17)
$alcohol = GUICtrlCreateCheckbox("Drink Alcohol", 16, 190, 90, 17)
$partys = GUICtrlCreateCheckbox("Use Party Items", 16, 210, 100, 17)
$sweets = GUICtrlCreateCheckbox("Eat Sweets", 16, 230, 90, 17)

$zaishencheckbox = GUICtrlCreateCheckbox("Open Z-Chest", 190, 170, 90, 17)
$giftcheckbox = GUICtrlCreateCheckbox("Open Gifts", 190, 190, 90, 17)
$DistrictChangeIsteadofTravel = GUICtrlCreateCheckbox("Use District Change Instead of Travel", 190, 215, 120, 30, $BS_MULTILINE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group4 = GUICtrlCreateGroup("Travel Settings", 8, 265, 313, 67)
$outpost1label = GUICtrlCreateLabel("First City:", 16, 284, 60, 17)
$outpost1lbl = GUICtrlCreateCombo("", 80, 280, 230, 17)
For $i = 0 To ($numberofoutposts - 1)
    _GUICtrlComboBox_AddString($outpost1lbl, $outpost[$i])
Next
_GUICtrlComboBox_SelectString($outpost1lbl, "Embark Beach")

$outpost2label = GUICtrlCreateLabel("Second City:", 16, 308, 60, 17)
$outpost2lbl = GUICtrlCreateCombo("", 80, 304, 230, 17)
For $i = 0 To ($numberofoutposts - 1)
    _GUICtrlComboBox_AddString($outpost2lbl, $outpost[$i])
Next
_GUICtrlComboBox_SelectString($outpost2lbl, "Great Temple of Balthazar")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$GUIActionsEdit = GUICtrlCreateEdit("", 8, 340, 313, 80, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL))
GUICtrlSetData(-1, "Welcome to GW Title Helper " & $version & "!" & @CRLF & "Select a character to begin.")
GUICtrlSetColor(-1, 0x99B2FF)
GUICtrlSetBkColor(-1, 0x23272A)

; Set up GUI events
GUICtrlSetOnEvent($GUIStartButton, "GuiButtonHandler")
GUICtrlSetOnEvent($GUIRefreshButton, "GuiButtonHandler")
GUICtrlSetOnEvent($gOnTopCheckbox, "GuiButtonHandler")
GUICtrlSetOnEvent($tonics, "GuiCheckHandler")
GUICtrlSetOnEvent($alcohol, "GuiCheckHandler")
GUICtrlSetOnEvent($partys, "GuiCheckHandler")
GUICtrlSetOnEvent($sweets, "GuiCheckHandler")
GUICtrlSetOnEvent($zaishencheckbox, "GuiCheckHandler")
GUICtrlSetOnEvent($giftcheckbox, "GuiCheckHandler")
GUICtrlSetOnEvent($outpost1lbl, "GuiOutpostChange")
GUICtrlSetOnEvent($outpost2lbl, "GuiOutpostChange")
GUICtrlSetOnEvent($GUINameCombo, "GuiCharSelect")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUISetState(@SW_SHOW)
#EndRegion ### END GUI section ###

; Main loop
While 1
    ; Only run title actions if the bot is initialized
    If $BotInitialized And $BotRunning Then
        ; Check if it's time to update titles
        If TimerDiff($lastTimeOfAction) > 5000 Then
            UpdateTitleDisplays()
            $lastTimeOfAction = TimerInit()
        EndIf
    EndIf
WEnd

; Event handlers
Func GuiButtonHandler()
    Switch @GUI_CtrlId
        Case $GUIStartButton
            If GUICtrlRead($GUINameCombo) = "" Then
                Out("Please select a character first")
                Return
            EndIf

            Out("Initializing client...")

            Local $charName = GUICtrlRead($GUINameCombo)
            For $i = 1 To $numChars
                If $CharList[$i] = $charName Then
                    If Initialize($ProcessIDs[$i], True, True, True) = 0 Then
                        Out("Error initializing client")
                        Return
                    EndIf

                    Out("Successfully connected to " & GetCharname())
                    GUICtrlSetData($GUIStartButton, "Running")
                    GUICtrlSetState($GUIStartButton, $GUI_DISABLE)
                    WinSetTitle($MainGui, "", GetCharname() & " - " & $BotTitle)
                    $BotInitialized = True
                    $BotRunning = True

                    ; Initialize lang1 value for district change
                    $lang1 = GetCharacterInfo("Language")

                    ; Update title displays
                    UpdateTitleDisplays()

                    ExitLoop
                EndIf
            Next

        Case $GUIRefreshButton
            Out("Refreshing character list...")
            $numChars = ScanGWCharacters()
            GUICtrlSetData($GUINameCombo, "")
            For $i = 1 To $numChars
                _GUICtrlComboBox_AddString($GUINameCombo, $CharList[$i])
            Next
            Out("Found " & $numChars & " characters")

        Case $gOnTopCheckbox
            If BitAND(GUICtrlRead($gOnTopCheckbox), $GUI_CHECKED) Then
                WinSetOnTop($MainGui, "", 1)
                Out("Window set to always on top")
            Else
                WinSetOnTop($MainGui, "", 0)
                Out("Window no longer on top")
            EndIf
    EndSwitch
EndFunc

Func GuiCharSelect()
    $BotInitialized = False
    $BotRunning = False
    GUICtrlSetState($GUIStartButton, $GUI_ENABLE)
    GUICtrlSetData($GUIStartButton, "Initialize Client")
    WinSetTitle($MainGui, "", $BotTitle)
    Out("Selected character: " & GUICtrlRead($GUINameCombo))
EndFunc

Func GuiCheckHandler()
    If Not $BotInitialized Then
        Out("Please initialize client first")
        GUICtrlSetState(@GUI_CtrlId, $GUI_UNCHECKED)
        Return
    EndIf

    Switch @GUI_CtrlId
        Case $tonics
            If BitAND(GUICtrlRead($tonics), $GUI_CHECKED) Then
                Out("Starting to drink tonics...")
                DrinkTonic()
            EndIf

        Case $alcohol
            If BitAND(GUICtrlRead($alcohol), $GUI_CHECKED) Then
                Out("Starting to drink alcohol...")
                DrinkAlcohol()
            EndIf

        Case $partys
            If BitAND(GUICtrlRead($partys), $GUI_CHECKED) Then
                Out("Starting to use party items...")
                UseParty()
            EndIf

        Case $sweets
            If BitAND(GUICtrlRead($sweets), $GUI_CHECKED) Then
                Out("Starting to eat sweets...")
                EatSweets()
            EndIf

        Case $zaishencheckbox
            If BitAND(GUICtrlRead($zaishencheckbox), $GUI_CHECKED) Then
                Out("Starting to open Zaishen chest...")
                ZaishenChestFunction()
            EndIf

        Case $giftcheckbox
            If BitAND(GUICtrlRead($giftcheckbox), $GUI_CHECKED) Then
                Out("Starting to open gifts...")
                Opengifts()
            EndIf
    EndSwitch
EndFunc

Func GuiOutpostChange()
    Switch @GUI_CtrlId
        Case $outpost1lbl
            $outpost1ID = GUICtrlRead($outpost1lbl)
            For $i = 0 to ($numberofoutposts - 1)
                If $outpost1ID = $outpost[$i] Then
                    $outpost1 = $outpostID[$i]
                    Out("First city set to: " & $outpost[$i])
                    ExitLoop
                EndIf
            Next

        Case $outpost2lbl
            $outpost2ID = GUICtrlRead($outpost2lbl)
            For $i = 0 to ($numberofoutposts - 1)
                If $outpost2ID = $outpost[$i] Then
                    $outpost2 = $outpostID[$i]
                    Out("Second city set to: " & $outpost[$i])
                    ExitLoop
                EndIf
            Next
    EndSwitch
EndFunc

; Helper functions
Func UpdateTitleDisplays()
    If Not $BotInitialized Then Return

    $drunkard = GetTitleInfo($TitleID_Drunkard, "CurrentPoints")
    $sweet = GetTitleInfo($TitleID_Sweets, "CurrentPoints")
    $party = GetTitleInfo($TitleID_Party, "CurrentPoints")
    $zaishen = GetTitleInfo($TitleID_Zaishen, "CurrentPoints")

    GUICtrlSetData($drunkardstatus, $drunkard)
    GUICtrlSetData($sweetstatus, $sweet)
    GUICtrlSetData($partystatus, $party)
    GUICtrlSetData($zaishenstatus, $zaishen)
EndFunc

Func Out($text)
    Local $time = "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] "
    Local $textlen = StringLen($text)
    Local $consolelen = _GUICtrlEdit_GetTextLen($GUIActionsEdit)

    If $textlen + $consolelen > 1000 Then
        GUICtrlSetData($GUIActionsEdit, StringRight(_GUICtrlEdit_GetText($GUIActionsEdit), 500))
    EndIf

    _GUICtrlEdit_AppendText($GUIActionsEdit, @CRLF & $time & $text)
    _GUICtrlEdit_Scroll($GUIActionsEdit, $SB_SCROLLCARET)
EndFunc

Func IDofItem($bagid, $slotid)
    Return GetItemBySlot($bagid, $slotid)
EndFunc

Func IDofModel($bagid, $slotid)
    Return GetItemInfoByPtr(GetItemBySlot($bagid, $slotid), "ModelID")
EndFunc

Func QuantityofItem($bagid, $slotid)
    Return GetItemInfoByPtr(GetItemBySlot($bagid, $slotid), "Quantity")
EndFunc

Func DrinkTonic()
    If Not $BotInitialized Then
        GUICtrlSetState($tonics, $GUI_UNCHECKED)
        Return
    EndIf

    Out("Drinking tonics...")

    If BitAND(GUICtrlRead($DistrictChangeIsteadofTravel), $GUI_CHECKED) Then
        DrinkTonicChangeDistrict()
    Else
        For $tonictype = 0 to UBound($TonicModelID) - 1
            For $i = 1 to $bags
                For $j = 0 to $slots
                    $itemmodel = IDofModel($i, $j)
                    If $itemmodel = $TonicModelID[$tonictype] Then
                        $itemquantity = QuantityofItem($i, $j)
                        For $u = 1 to $itemquantity
                            If BitAND(GUICtrlRead($tonics), $GUI_CHECKED) Then
                                UpdateTitleDisplays()
                                If $party < 10000 Then
                                    $itemID = IDofItem($i, $j)
                                    UseItem($itemID)
                                    Out("Used a tonic (ID: " & $itemID & ")")
                                    Sleep(5500)
                                    UpdateTitleDisplays()
                                Else
                                    Out("Party Animal title maxed")
                                    GUICtrlSetState($tonics, $GUI_UNCHECKED)
                                    ExitLoop 4
                                EndIf
                            Else
                                ExitLoop 4
                            EndIf
                        Next
                    EndIf
                Next
            Next
        Next
    EndIf

    GUICtrlSetState($tonics, $GUI_UNCHECKED)
    Out("Finished drinking tonics")
EndFunc

Func DrinkAlcohol()
    If Not $BotInitialized Then
        GUICtrlSetState($alcohol, $GUI_UNCHECKED)
        Return
    EndIf

    Out("Drinking alcohol...")

    For $alcoholtype = 0 to UBound($AlcoholModelID) - 1
        For $i = 1 to $bags
            For $j = 0 to $slots
                $itemmodel = IDofModel($i, $j)
                If $itemmodel = $AlcoholModelID[$alcoholtype] Then
                    $itemquantity = QuantityofItem($i, $j)
                    For $u = 1 to $itemquantity
                        If BitAND(GUICtrlRead($alcohol), $GUI_CHECKED) Then
                            UpdateTitleDisplays()
                            If $drunkard < 10000 Then
                                $itemID = IDofItem($i, $j)
                                UseItem($itemID)
                                Out("Used alcohol (ID: " & $itemID & ")")
                                Sleep(16)
                                UpdateTitleDisplays()
                            Else
                                Out("Drunkard title maxed")
                                GUICtrlSetState($alcohol, $GUI_UNCHECKED)
                                ExitLoop 4
                            EndIf
                        Else
                            ExitLoop 4
                        EndIf
                    Next
                EndIf
            Next
        Next
    Next

    GUICtrlSetState($alcohol, $GUI_UNCHECKED)
    Out("Finished drinking alcohol")
EndFunc

Func UseParty()
    If Not $BotInitialized Then
        GUICtrlSetState($partys, $GUI_UNCHECKED)
        Return
    EndIf

    Out("Using party items...")

    For $partytype = 0 to UBound($PartyModelID) - 1
        For $i = 1 to $bags
            For $j = 0 to $slots
                $itemmodel = IDofModel($i, $j)
                If $itemmodel = $PartyModelID[$partytype] Then
                    $itemquantity = QuantityofItem($i, $j)
                    For $u = 1 to $itemquantity
                        If BitAND(GUICtrlRead($partys), $GUI_CHECKED) Then
                            UpdateTitleDisplays()
                            If $party < 10000 Then
                                $itemID = IDofItem($i, $j)
                                UseItem($itemID)
                                Out("Used party item (ID: " & $itemID & ")")
                                Sleep(16)
                                UpdateTitleDisplays()
                            Else
                                Out("Party Animal title maxed")
                                GUICtrlSetState($partys, $GUI_UNCHECKED)
                                ExitLoop 4
                            EndIf
                        Else
                            ExitLoop 4
                        EndIf
                    Next
                EndIf
            Next
        Next
    Next

    GUICtrlSetState($partys, $GUI_UNCHECKED)
    Out("Finished using party items")
EndFunc

Func EatSweets()
    If Not $BotInitialized Then
        GUICtrlSetState($sweets, $GUI_UNCHECKED)
        Return
    EndIf

    Out("Eating sweets...")

    For $sweettype = 0 to UBound($SweetModelID) - 1
        For $i = 1 to $bags
            For $j = 0 to $slots
                $itemmodel = IDofModel($i, $j)
                If $itemmodel = $SweetModelID[$sweettype] Then
                    $itemquantity = QuantityofItem($i, $j)
                    For $u = 1 to $itemquantity
                        If BitAND(GUICtrlRead($sweets), $GUI_CHECKED) Then
                            UpdateTitleDisplays()
                            If $sweet < 10000 Then
                                $itemID = IDofItem($i, $j)
                                UseItem($itemID)
                                Out("Ate sweet (ID: " & $itemID & ")")
                                Sleep(16)
                                UpdateTitleDisplays()
                            Else
                                Out("Sweet Tooth title maxed")
                                GUICtrlSetState($sweets, $GUI_UNCHECKED)
                                ExitLoop 4
                            EndIf
                        Else
                            ExitLoop 4
                        EndIf
                    Next
                EndIf
            Next
        Next
    Next

    GUICtrlSetState($sweets, $GUI_UNCHECKED)
    Out("Finished eating sweets")
EndFunc

Func Opengifts()
    If Not $BotInitialized Then
        GUICtrlSetState($giftcheckbox, $GUI_UNCHECKED)
        Return
    EndIf

    Out("Opening gifts...")

    For $gifts = 0 to UBound($giftsModelID) - 1
        For $i = 1 to $bags
            For $j = 0 to $slots
                $itemmodel = IDofModel($i, $j)
                If $itemmodel = $giftsModelID[$gifts] Then
                    $itemquantity = QuantityofItem($i, $j)
                    For $u = 1 to $itemquantity
                        If BitAND(GUICtrlRead($giftcheckbox), $GUI_CHECKED) Then
                            $itemID = IDofItem($i, $j)
                            UseItem($itemID)
                            Out("Opened gift (ID: " & $itemID & ")")
                            Sleep(16)
                        Else
                            ExitLoop 4
                        EndIf
                    Next
                EndIf
            Next
        Next
    Next

    GUICtrlSetState($giftcheckbox, $GUI_UNCHECKED)
    Out("Finished opening gifts")
EndFunc

Func DrinkTonicChangeDistrict()
    If Not $BotInitialized Then
        GUICtrlSetState($tonics, $GUI_UNCHECKED)
        Return
    EndIf

    Out("Drinking tonics with district change...")

    For $tonictype = 0 to UBound($TonicModelID) - 1
        For $i = 1 to $bags
            For $j = 0 to $slots
                $itemmodel = IDofModel($i, $j)
                If $itemmodel = $TonicModelID[$tonictype] Then
                    $itemquantity = QuantityofItem($i, $j)
                    For $u = 1 to $itemquantity
                        If BitAND(GUICtrlRead($tonics), $GUI_CHECKED) Then
                            UpdateTitleDisplays()
                            If $party < 10000 Then
                                $lang = GetCharacterInfo("Language")
                                $itemID = IDofItem($i, $j)
                                $random = Random(0, 2, 1)

                                If $lang = $lang1 And $itemmodel <> 0 Then
                                    UseItem($itemID)
                                    Out("Used tonic (ID: " & $itemID & ")")
                                    If $random = 1 Or $random = 2 Then
                                        Sleep(Random(150, 300))
                                        UseItem($itemID)
                                        Out("Used second tonic")
                                    EndIf
                                    Sleep(Random(1500, 3000))
                                    UpdateTitleDisplays()
                                    Out("Changing district...")
                                    DistrictChange2()
                                ElseIf $itemmodel <> 0 Then
                                    UseItem($itemID)
                                    Out("Used tonic (ID: " & $itemID & ")")
                                    If $random = 1 Or $random = 2 Then
                                        Sleep(Random(150, 300))
                                        UseItem($itemID)
                                        Out("Used second tonic")
                                    EndIf
                                    Sleep(Random(1500, 3000))
                                    UpdateTitleDisplays()
                                    Out("Changing district...")
                                    DistrictChange2()
                                Else
                                    ExitLoop 4
                                EndIf
                            Else
                                Out("Party Animal title maxed")
                                GUICtrlSetState($tonics, $GUI_UNCHECKED)
                                ExitLoop 4
                            EndIf
                        Else
                            ExitLoop 4
                        EndIf
                    Next
                EndIf
            Next
        Next
    Next

    GUICtrlSetState($tonics, $GUI_UNCHECKED)
    Out("Finished drinking tonics with district change")
EndFunc

Func ZaishenChestFunction()
    If Not $BotInitialized Then
        GUICtrlSetState($zaishencheckbox, $GUI_UNCHECKED)
        Return
    EndIf

    Out("Starting Zaishen chest function...")

    $ZoneID = GetCharacterInfo("MapID")
    If $ZoneID = 280 Then
        $MyID = GetAgentByID(-2)
        $zchestID = GetNearestSignpostToCoords(-9343, -731)

        If ComputeDistance(DllStructGetData($MyID, 'X'), DllStructGetData($MyID, 'Y'), DllStructGetData($zchestID, 'X'), DllStructGetData($zchestID, 'Y')) < 300 Then
            Out("Already near Zaishen chest")
            OpenZchest()
        Else
            Out("Moving to Zaishen chest")
            ChangeTarget($zchestID)
            GoToZchest()
        EndIf
    Else
        If $ZoneID <> 248 Then
            Out("Traveling to Great Temple of Balthazar")
            TravelTo(248)
        EndIf

        Out("Moving to Zaishen battle isles portal")
        MoveTo(-5923, -4854)
        Move(-6098, 3700, 2)
        WaitMapLoading(280)
        Out("Moving to Zaishen chest")
        GoToZchest()
    EndIf

    GUICtrlSetState($zaishencheckbox, $GUI_UNCHECKED)
EndFunc

Func GoToZchest()
    Out("Moving to Zaishen chest...")

    Do
        Sleep(400)
        $zchestID = GetNearestSignpostToCoords(-9343, -731)
        ChangeTarget($zchestID)
        $MyID = GetAgentByID(-2)
        MoveTo(DllStructGetData($zchestID, 'X'), DllStructGetData($zchestID, 'Y'))
    Until ComputeDistance(DllStructGetData($MyID, 'X'), DllStructGetData($MyID, 'Y'), DllStructGetData($zchestID, 'X'), DllStructGetData($zchestID, 'Y')) < 150

    Out("Reached Zaishen chest")
    Sleep(500)
    OpenZchest()
EndFunc

Func OpenZchest()
    Out("Opening Zaishen chest...")

    For $zkeytype = 0 to 0
        For $i = 1 to $bags
            For $j = 0 to $slots
                $itemmodel = IDofModel($i, $j)
                If $itemmodel = $ZkeyModeID[$zkeytype] Then
                    $itemquantity = QuantityofItem($i, $j)
                    For $u = 1 to $itemquantity
                        If BitAND(GUICtrlRead($zaishencheckbox), $GUI_CHECKED) Then
                            UpdateTitleDisplays()
                            If $zaishen < 100000 Then
                                GoToSignpost($zchestID)
                                Out("Used Zaishen key on chest")
                                Sleep(Random(3000, 4000, 1))
                                UpdateTitleDisplays()
                            Else
                                Out("Zaishen title maxed")
                                GUICtrlSetState($zaishencheckbox, $GUI_UNCHECKED)
                                ExitLoop 4
                            EndIf
                        Else
                            ExitLoop 4
                        EndIf
                    Next
                EndIf
            Next
        Next
    Next

    Out("Finished opening Zaishen chest")
EndFunc

Func CheckforLoad()
    Local $timer = TimerInit()
    Out("Waiting for loading...")

    Do
        Sleep(200)
    Until GetInstanceType() = 0 OR TimerDiff($timer) > 10000

    Out("Loading complete")
EndFunc

Func DistrictChange($townID)
    Local $region[12] = [4, 3, 1, 0, 2, 2, 2, 2, 2, 2, 2]
    Local $language[12] = [0, 0, 0, 0, 0, 2, 3, 4, 5, 9, 10]
    Local $random = Random(0, 10, 1)
    Local $old_region, $old_language

    $old_region = GetCharacterInfo("Region")
    $old_language = GetCharacterInfo("Language")

    While ($old_region = $region[$random])
        $random = Random(0, 10, 1)
    WEnd

    $region = $region[$random]
    $language = $language[$random]

    Out("Changing district to town ID " & $townID & " (Region: " & $region & ", Lang: " & $language & ")")
    MoveMap($townID, $region, 0, $language)

    Return WaitMapLoading($townID)
EndFunc

Func DistrictChange2()
    Local $region[11] = [4, 3, 1, 0, 2, 2, 2, 2, 2, 2, 2]
    Local $language[11] = [0, 0, 0, 0, 0, 2, 3, 4, 5, 9, 10]
    Local $random = Random(0, 10, 1)
    Local $old_region, $old_language

    $old_region = GetCharacterInfo("Region")
    $old_language = GetCharacterInfo("Language")
    $ZoneID = GetCharacterInfo("MapID")

    While ($old_region = $region[$random])
        $random = Random(0, 10, 1)
    WEnd

    $region = $region[$random]
    $language = $language[$random]

    Out("Changing district in current outpost (Region: " & $region & ", Lang: " & $language & ")")
    MoveMap($ZoneID, $region, 0, $language)

    Return WaitMapLoading($ZoneID)
EndFunc

Func _Exit()
    Out("Exiting application...")
    Exit
EndFunc