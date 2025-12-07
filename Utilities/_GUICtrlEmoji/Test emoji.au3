#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ListViewConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <GuiTreeView.au3>
#include <GuiComboBox.au3>
#include <GuiTab.au3>
#include <GDIPlus.au3>
#include <Math.au3>
#include '_GUICtrlEmoji.au3'

; Initialize emoji system
_GDIPlus_Startup()
_GUICtrlSmiley_Init()

; Create main window
Global $hGUI = GUICreate("PNG Emoji Demo - _GUICtrlEmoji Only", 1000, 700)
GUISetBkColor(0xF5F5F5)

; ===== DEMO 1: BASIC LABELS AND STATUS =====
GUICtrlCreateLabel("DEMO 1: Basic Labels with PNG Emojis", 20, 20, 400, 25)
GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x2C3E50)

; Create background for status messages
GUICtrlCreateLabel("", 20, 60, 460, 180)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState(-1, $GUI_DISABLE)

; Status messages with emojis
_GUICtrlSmiley_Create($EMOJI_SUCCESS, 40, 80, 24)
GUICtrlCreateLabel("Operation completed successfully", 75, 82, 300, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)

_GUICtrlSmiley_Create($EMOJI_ERROR, 40, 110, 24)
GUICtrlCreateLabel("Error: Connection failed", 75, 112, 300, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)

_GUICtrlSmiley_Create($EMOJI_WARNING, 40, 140, 24)
GUICtrlCreateLabel("Warning: Low disk space", 75, 142, 300, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)

_GUICtrlSmiley_Create($EMOJI_INFO, 40, 170, 24)
GUICtrlCreateLabel("Information: Update available", 75, 172, 300, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)

_GUICtrlSmiley_Create($EMOJI_ONLINE, 40, 200, 24)
GUICtrlCreateLabel("Status: Online and active", 75, 202, 300, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)

; ===== DEMO 2: CLICKABLE LABEL BUTTONS =====
GUICtrlCreateLabel("DEMO 2: Clickable Label Buttons", 20, 260, 400, 25)
GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x2C3E50)

; Button 1: Play
Global $lblBtn1 = GUICtrlCreateLabel("", 20, 300, 140, 45)
GUICtrlSetBkColor(-1, 0x3498DB)
GUICtrlSetCursor(-1, 0)

_GUICtrlSmiley_Create($EMOJI_PLAY, 30, 310, 24)
GUICtrlCreateLabel("Play", 65, 315, 70, 20)
GUICtrlSetFont(-1, 11, 500, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x3498DB)

; Button 2: Pause
Global $lblBtn2 = GUICtrlCreateLabel("", 170, 300, 140, 45)
GUICtrlSetBkColor(-1, 0xE67E22)
GUICtrlSetCursor(-1, 0)

_GUICtrlSmiley_Create($EMOJI_PAUSE, 180, 310, 24)
GUICtrlCreateLabel("Pause", 215, 315, 70, 20)
GUICtrlSetFont(-1, 11, 500, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xE67E22)

; Button 3: Stop
Global $lblBtn3 = GUICtrlCreateLabel("", 320, 300, 140, 45)
GUICtrlSetBkColor(-1, 0xE74C3C)
GUICtrlSetCursor(-1, 0)

_GUICtrlSmiley_Create($EMOJI_STOP, 330, 310, 24)
GUICtrlCreateLabel("Stop", 365, 315, 70, 20)
GUICtrlSetFont(-1, 11, 500, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xE74C3C)

; ===== DEMO 3: EMOJI NEXT TO CONTROLS =====
GUICtrlCreateLabel("DEMO 3: Emojis Next to Standard Controls", 20, 370, 400, 25)
GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x2C3E50)

; Input fields with emojis
_GUICtrlSmiley_Create($EMOJI_KEY, 20, 410, 24)
GUICtrlCreateInput("Enter password", 55, 405, 200, 30)

_GUICtrlSmiley_Create($EMOJI_SEARCH, 20, 450, 24)
GUICtrlCreateInput("Search...", 55, 445, 200, 30)

; Buttons with emojis beside them
_GUICtrlSmiley_Create($EMOJI_ADD, 280, 408, 24)
GUICtrlCreateButton("Add Item", 310, 405, 100, 30)

_GUICtrlSmiley_Create($EMOJI_TRASH, 280, 448, 24)
GUICtrlCreateButton("Delete", 310, 445, 100, 30)

; ===== DEMO 4: LISTVIEW WITH IMAGELIST =====
GUICtrlCreateLabel("DEMO 4: ListView with ImageList", 520, 20, 400, 25)
GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x2C3E50)

; Create ListView
Global $lvDemo = GUICtrlCreateListView("Status|Name|Progress|Action", 520, 60, 460, 200)
_GUICtrlListView_SetColumnWidth($lvDemo, 0, 70)
_GUICtrlListView_SetColumnWidth($lvDemo, 1, 150)
_GUICtrlListView_SetColumnWidth($lvDemo, 2, 120)
_GUICtrlListView_SetColumnWidth($lvDemo, 3, 100)

; Create ImageList
Global $hImgList = _GUIImageList_Create(16, 16, 5, 3)
_AddEmojiToImageList($hImgList, $EMOJI_ONLINE)     ; 0
_AddEmojiToImageList($hImgList, $EMOJI_OFFLINE)    ; 1
_AddEmojiToImageList($hImgList, $EMOJI_WAITING)    ; 2
_AddEmojiToImageList($hImgList, $EMOJI_SUCCESS)    ; 3
_AddEmojiToImageList($hImgList, $EMOJI_ERROR)      ; 4
_AddEmojiToImageList($hImgList, $EMOJI_BOT)        ; 5

; Set ImageList to ListView
_GUICtrlListView_SetImageList($lvDemo, $hImgList, 1)

; Add items with icons
_GUICtrlListView_AddItem($lvDemo, "Active", 0)
_GUICtrlListView_AddSubItem($lvDemo, 0, "John Doe", 1)
_GUICtrlListView_AddSubItem($lvDemo, 0, "Complete", 2)
_GUICtrlListView_AddSubItem($lvDemo, 0, "Running", 3)
_GUICtrlListView_SetItemImage($lvDemo, 0, 3, 2)

_GUICtrlListView_AddItem($lvDemo, "Offline", 1)
_GUICtrlListView_AddSubItem($lvDemo, 1, "Jane Smith", 1)
_GUICtrlListView_AddSubItem($lvDemo, 1, "Failed", 2)
_GUICtrlListView_AddSubItem($lvDemo, 1, "Stopped", 3)
_GUICtrlListView_SetItemImage($lvDemo, 1, 4, 2)

_GUICtrlListView_AddItem($lvDemo, "Waiting", 2)
_GUICtrlListView_AddSubItem($lvDemo, 2, "Bob Wilson", 1)
_GUICtrlListView_AddSubItem($lvDemo, 2, "Pending", 2)
_GUICtrlListView_AddSubItem($lvDemo, 2, "Queued", 3)

_GUICtrlListView_AddItem($lvDemo, "Bot Active", 5)
_GUICtrlListView_AddSubItem($lvDemo, 3, "AI Assistant", 1)
_GUICtrlListView_AddSubItem($lvDemo, 3, "Running", 2)
_GUICtrlListView_AddSubItem($lvDemo, 3, "Processing", 3)

; ===== DEMO 5: CUSTOM DRAWN BUTTONS =====
GUICtrlCreateLabel("DEMO 5: Custom Drawn Buttons", 520, 280, 400, 25)
GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x2C3E50)

; Custom buttons
Global $picBtn1 = GUICtrlCreatePic("", 520, 320, 150, 45)
_DrawCustomButton($picBtn1, $EMOJI_SAVE, "Save", 150, 45, 0x27AE60, False)
GUICtrlSetCursor(-1, 0)

Global $picBtn2 = GUICtrlCreatePic("", 680, 320, 150, 45)
_DrawCustomButton($picBtn2, $EMOJI_REFRESH, "Refresh", 150, 45, 0x3498DB, False)
GUICtrlSetCursor(-1, 0)

Global $picBtn3 = GUICtrlCreatePic("", 520, 375, 150, 45)
_DrawCustomButton($picBtn3, $EMOJI_SETTINGS, "Settings", 150, 45, 0x95A5A6, False)
GUICtrlSetCursor(-1, 0)

Global $picBtn4 = GUICtrlCreatePic("", 680, 375, 150, 45)
_DrawCustomButton($picBtn4, $EMOJI_HELP, "Help", 150, 45, 0x9B59B6, False)
GUICtrlSetCursor(-1, 0)

; ===== DEMO 6: PROGRESS WITH EMOJIS =====
GUICtrlCreateLabel("DEMO 6: Progress Indicators", 520, 440, 400, 25)
GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x2C3E50)

; Progress examples
GUICtrlCreateLabel("", 520, 480, 460, 180)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState(-1, $GUI_DISABLE)

_GUICtrlSmiley_Create($EMOJI_HOURGLASS, 540, 500, 24)
GUICtrlCreateLabel("Processing:", 575, 502, 80, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateProgress(660, 500, 280, 20)
GUICtrlSetData(-1, 65)

_GUICtrlSmiley_Create($EMOJI_CHART_UP, 540, 535, 24)
GUICtrlCreateLabel("Uploading:", 575, 537, 80, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateProgress(660, 535, 280, 20)
GUICtrlSetData(-1, 30)

_GUICtrlSmiley_Create($EMOJI_CHART_DOWN, 540, 570, 24)
GUICtrlCreateLabel("Downloading:", 575, 572, 80, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateProgress(660, 570, 280, 20)
GUICtrlSetData(-1, 85)

_GUICtrlSmiley_Create($EMOJI_SUCCESS, 540, 605, 24)
GUICtrlCreateLabel("Complete:", 575, 607, 80, 20)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateProgress(660, 605, 280, 20)
GUICtrlSetData(-1, 100)

; ===== DEMO 7: NOTIFICATION CARDS =====
GUICtrlCreateLabel("DEMO 7: Notification Cards", 20, 500, 400, 25)
GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x2C3E50)

; Success notification
GUICtrlCreateLabel("", 20, 540, 460, 40)
GUICtrlSetBkColor(-1, 0xD5F4E6)
GUICtrlSetState(-1, $GUI_DISABLE)

_GUICtrlSmiley_Create($EMOJI_SUCCESS, 30, 548, 24)
GUICtrlCreateLabel("File saved successfully!", 60, 550, 400, 20)
GUICtrlSetBkColor(-1, 0xD5F4E6)

; Error notification
GUICtrlCreateLabel("", 20, 590, 460, 40)
GUICtrlSetBkColor(-1, 0xF9D6D5)
GUICtrlSetState(-1, $GUI_DISABLE)

_GUICtrlSmiley_Create($EMOJI_ERROR, 30, 598, 24)
GUICtrlCreateLabel("Connection failed. Please check your network.", 60, 600, 400, 20)
GUICtrlSetBkColor(-1, 0xF9D6D5)

; Warning notification
GUICtrlCreateLabel("", 20, 640, 460, 40)
GUICtrlSetBkColor(-1, 0xFDEDC8)
GUICtrlSetState(-1, $GUI_DISABLE)

_GUICtrlSmiley_Create($EMOJI_WARNING, 30, 648, 24)
GUICtrlCreateLabel("Low battery: 15% remaining", 60, 650, 400, 20)
GUICtrlSetBkColor(-1, 0xFDEDC8)

; Status bar at bottom
Local $statusBar = GUICtrlCreateLabel("", 0, 670, 1000, 30)
GUICtrlSetBkColor(-1, 0xE0E0E0)
GUICtrlSetState(-1, $GUI_DISABLE)

_GUICtrlSmiley_Create($EMOJI_ONLINE, 10, 675, 20)
GUICtrlCreateLabel("Connected", 35, 677, 80, 20)
GUICtrlSetBkColor(-1, 0xE0E0E0)

_GUICtrlSmiley_Create($EMOJI_CPU, 130, 675, 20)
GUICtrlCreateLabel("CPU: 45%", 155, 677, 80, 20)
GUICtrlSetBkColor(-1, 0xE0E0E0)

_GUICtrlSmiley_Create($EMOJI_MEMORY, 250, 675, 20)
GUICtrlCreateLabel("RAM: 2.1GB", 275, 677, 80, 20)
GUICtrlSetBkColor(-1, 0xE0E0E0)

; Show GUI
GUISetState(@SW_SHOW)

; Main loop
Global $hoverBtn1 = False, $hoverBtn2 = False, $hoverBtn3 = False, $hoverBtn4 = False

While 1
    ; Handle hover effects
    Local $aCursor = GUIGetCursorInfo($hGUI)
    If IsArray($aCursor) Then
        ; Hover for custom buttons
        If $aCursor[4] = $picBtn1 Then
            If Not $hoverBtn1 Then
                _DrawCustomButton($picBtn1, $EMOJI_SAVE, "Save", 150, 45, 0x27AE60, True)
                $hoverBtn1 = True
            EndIf
        ElseIf $hoverBtn1 Then
            _DrawCustomButton($picBtn1, $EMOJI_SAVE, "Save", 150, 45, 0x27AE60, False)
            $hoverBtn1 = False
        EndIf

        If $aCursor[4] = $picBtn2 Then
            If Not $hoverBtn2 Then
                _DrawCustomButton($picBtn2, $EMOJI_REFRESH, "Refresh", 150, 45, 0x3498DB, True)
                $hoverBtn2 = True
            EndIf
        ElseIf $hoverBtn2 Then
            _DrawCustomButton($picBtn2, $EMOJI_REFRESH, "Refresh", 150, 45, 0x3498DB, False)
            $hoverBtn2 = False
        EndIf
    EndIf

    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            ExitLoop

        Case $lblBtn1
            ConsoleWrite("Play button clicked" & @CRLF)
            ; Visual feedback
            GUICtrlSetBkColor($lblBtn1, 0x2980B9)
            Sleep(100)
            GUICtrlSetBkColor($lblBtn1, 0x3498DB)

        Case $lblBtn2
            ConsoleWrite("Pause button clicked" & @CRLF)
            GUICtrlSetBkColor($lblBtn2, 0xD35400)
            Sleep(100)
            GUICtrlSetBkColor($lblBtn2, 0xE67E22)

        Case $lblBtn3
            ConsoleWrite("Stop button clicked" & @CRLF)
            GUICtrlSetBkColor($lblBtn3, 0xC0392B)
            Sleep(100)
            GUICtrlSetBkColor($lblBtn3, 0xE74C3C)

        Case $picBtn1
            ConsoleWrite("Save button clicked" & @CRLF)
            _DrawCustomButton($picBtn1, $EMOJI_SAVE, "Save", 150, 45, 0x229954, False)
            Sleep(100)
            _DrawCustomButton($picBtn1, $EMOJI_SAVE, "Save", 150, 45, 0x27AE60, False)

        Case $picBtn2
            ConsoleWrite("Refresh button clicked" & @CRLF)
            _DrawCustomButton($picBtn2, $EMOJI_REFRESH, "Refresh", 150, 45, 0x2874A6, False)
            Sleep(100)
            _DrawCustomButton($picBtn2, $EMOJI_REFRESH, "Refresh", 150, 45, 0x3498DB, False)
    EndSwitch
WEnd

; Cleanup
_GUIImageList_Destroy($hImgList)
_GUICtrlSmiley_Shutdown()
_GDIPlus_Shutdown()
GUIDelete()

; ===== HELPER FUNCTIONS =====

Func _AddEmojiToImageList($hImageList, $iEmojiID)
    ; Create a 16x16 bitmap
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0(16, 16)
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)

    ; Clear background
    _GDIPlus_GraphicsClear($hGraphics, 0x00FFFFFF)

    ; Draw emoji if valid
    If $iEmojiID >= 0 And $iEmojiID < $EMOJI_COUNT And $__g_ahEmojiPNG[$iEmojiID] <> 0 Then
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $__g_ahEmojiPNG[$iEmojiID], 0, 0, 16, 16)
    EndIf

    ; Convert to HBitmap
    Local $hBMP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)

    ; Add to ImageList
    _GUIImageList_Add($hImageList, $hBMP)

    ; Cleanup
    _WinAPI_DeleteObject($hBMP)
    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_BitmapDispose($hBitmap)
EndFunc

Func _DrawCustomButton($idCtrl, $iEmojiID, $sText, $iWidth, $iHeight, $iColor, $bHover = False)
    ; Create bitmap
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 2)

    ; Adjust color for hover
    Local $iDrawColor = $iColor
    If $bHover Then
        ; Lighten color for hover effect
        Local $r = BitShift(BitAND($iColor, 0xFF0000), 16)
        Local $g = BitShift(BitAND($iColor, 0x00FF00), 8)
        Local $b = BitAND($iColor, 0x0000FF)

        $r = _Min(255, $r + 30)
        $g = _Min(255, $g + 30)
        $b = _Min(255, $b + 30)

        $iDrawColor = BitOR(BitShift($r, -16), BitShift($g, -8), $b)
    EndIf

    ; Draw background
    Local $hBrush = _GDIPlus_BrushCreateSolid(0xFF000000 + $iDrawColor)
    _GDIPlus_GraphicsFillRect($hGraphics, 0, 0, $iWidth, $iHeight, $hBrush)
    _GDIPlus_BrushDispose($hBrush)

    ; Draw border
    Local $hPen = _GDIPlus_PenCreate(0xFF000000, 1)
    _GDIPlus_GraphicsDrawRect($hGraphics, 0, 0, $iWidth - 1, $iHeight - 1, $hPen)
    _GDIPlus_PenDispose($hPen)

    ; Draw emoji
    If $iEmojiID >= 0 And $iEmojiID < $EMOJI_COUNT And $__g_ahEmojiPNG[$iEmojiID] <> 0 Then
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $__g_ahEmojiPNG[$iEmojiID], 10, ($iHeight - 24) / 2, 24, 24)
    EndIf

    ; Draw text
    Local $hFormat = _GDIPlus_StringFormatCreate()
    _GDIPlus_StringFormatSetAlign($hFormat, 0)
    _GDIPlus_StringFormatSetLineAlign($hFormat, 1)

    Local $hFamily = _GDIPlus_FontFamilyCreate("Segoe UI")
    Local $hFont = _GDIPlus_FontCreate($hFamily, 11)
    Local $hTextBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)

    Local $tLayout = _GDIPlus_RectFCreate(45, 0, $iWidth - 55, $iHeight)
    _GDIPlus_GraphicsDrawStringEx($hGraphics, $sText, $hFont, $tLayout, $hFormat, $hTextBrush)

    ; Cleanup
    _GDIPlus_FontDispose($hFont)
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_BrushDispose($hTextBrush)

    ; Convert and set
    Local $hBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
    _WinAPI_DeleteObject(GUICtrlSendMsg($idCtrl, $STM_SETIMAGE, $IMAGE_BITMAP, $hBMP))

    ; Cleanup
    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_BitmapDispose($hBitmap)
EndFunc
