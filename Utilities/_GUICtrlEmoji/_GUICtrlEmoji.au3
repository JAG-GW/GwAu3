#include-once
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Memory.au3>
#include <WinAPIHObj.au3>

; ===== CONSTANTS =====

Global Enum $EMOJI_ONLINE, $EMOJI_OFFLINE, $EMOJI_WAITING, $EMOJI_CONNECTING, _
            $EMOJI_UNKNOWN, $EMOJI_BOT_ACTIVE, $EMOJI_MAINTENANCE

Global Enum $EMOJI_PLAY = 7, $EMOJI_PAUSE, $EMOJI_STOP, $EMOJI_REFRESH, _
            $EMOJI_RESTART, $EMOJI_NEXT, $EMOJI_PREVIOUS

Global Enum $EMOJI_ADD = 14, $EMOJI_REMOVE, $EMOJI_EDIT, $EMOJI_NOTES, _
            $EMOJI_SAVE, $EMOJI_BROWSE, $EMOJI_TRASH

Global Enum $EMOJI_SUCCESS = 21, $EMOJI_ERROR, $EMOJI_WARNING, $EMOJI_INFO, _
            $EMOJI_NOTIFICATION, $EMOJI_ANNOUNCE, $EMOJI_HELP

Global Enum $EMOJI_LOCKED = 28, $EMOJI_UNLOCKED, $EMOJI_KEY, $EMOJI_SHIELD, _
            $EMOJI_VISIBLE, $EMOJI_HIDDEN

Global Enum $EMOJI_STATS = 34, $EMOJI_CHART_UP, $EMOJI_CHART_DOWN, $EMOJI_TIME, _
            $EMOJI_TARGET, $EMOJI_GOLD, $EMOJI_PERFORMANCE

Global Enum $EMOJI_BOT = 41, $EMOJI_AI_ACTIVE, $EMOJI_SETTINGS, $EMOJI_GAME_MODE, _
            $EMOJI_BOT_MAINTENANCE, $EMOJI_POSITION

Global Enum $EMOJI_PC = 47, $EMOJI_NETWORK, $EMOJI_SERVER, $EMOJI_MEMORY, _
            $EMOJI_TOOLS, $EMOJI_CPU

Global Enum $EMOJI_LIST = 53, $EMOJI_CARDS, $EMOJI_SEARCH, $EMOJI_DROPDOWN, _
            $EMOJI_ARROW_RIGHT, $EMOJI_ARROW_LEFT

Global Enum $EMOJI_NIGHT_MODE = 59, $EMOJI_DAY_MODE, $EMOJI_THEME, $EMOJI_SOUND_ON, _
            $EMOJI_SOUND_OFF, $EMOJI_SLEEP

Global Enum $EMOJI_SCHEDULED = 65, $EMOJI_CALENDAR, $EMOJI_CLOCK, $EMOJI_HOURGLASS, _
            $EMOJI_COMPLETED

Global Const $EMOJI_COUNT = 70

; Array to store png
Global $__g_ahEmojiPNG[$EMOJI_COUNT]

; ===== INITIALIZATION FUNCTION =====
Func _GUICtrlSmiley_Init()
    _GDIPlus_Startup()

    $__g_ahEmojiPNG[$EMOJI_ONLINE] = _EmojiOnline()
    $__g_ahEmojiPNG[$EMOJI_OFFLINE] = _EmojiOffline()
    $__g_ahEmojiPNG[$EMOJI_WAITING] = _EmojiWaiting()
    $__g_ahEmojiPNG[$EMOJI_CONNECTING] = _EmojiConnecting()
    $__g_ahEmojiPNG[$EMOJI_UNKNOWN] = _EmojiUnknown()
    $__g_ahEmojiPNG[$EMOJI_BOT_ACTIVE] = _EmojiBotActive()
    $__g_ahEmojiPNG[$EMOJI_MAINTENANCE] = _EmojiMaintenance()

    $__g_ahEmojiPNG[$EMOJI_PLAY] = _EmojiPlay()
    $__g_ahEmojiPNG[$EMOJI_PAUSE] = _EmojiPause()
    $__g_ahEmojiPNG[$EMOJI_STOP] = _EmojiStop()
    $__g_ahEmojiPNG[$EMOJI_REFRESH] = _EmojiRefresh()
    $__g_ahEmojiPNG[$EMOJI_RESTART] = _EmojiRestart()
    $__g_ahEmojiPNG[$EMOJI_NEXT] = _EmojiNext()
    $__g_ahEmojiPNG[$EMOJI_PREVIOUS] = _EmojiPrevious()

    $__g_ahEmojiPNG[$EMOJI_ADD] = _EmojiAdd()
    $__g_ahEmojiPNG[$EMOJI_REMOVE] = _EmojiRemove()
    $__g_ahEmojiPNG[$EMOJI_EDIT] = _EmojiEdit()
    $__g_ahEmojiPNG[$EMOJI_NOTES] = _EmojiNotes()
    $__g_ahEmojiPNG[$EMOJI_SAVE] = _EmojiSave()
    $__g_ahEmojiPNG[$EMOJI_BROWSE] = _EmojiBrowse()
    $__g_ahEmojiPNG[$EMOJI_TRASH] = _EmojiTrash()

    $__g_ahEmojiPNG[$EMOJI_SUCCESS] = _EmojiSuccess()
    $__g_ahEmojiPNG[$EMOJI_ERROR] = _EmojiError()
    $__g_ahEmojiPNG[$EMOJI_WARNING] = _EmojiWarning()
    $__g_ahEmojiPNG[$EMOJI_INFO] = _EmojiInfo()
    $__g_ahEmojiPNG[$EMOJI_NOTIFICATION] = _EmojiNotification()
    $__g_ahEmojiPNG[$EMOJI_ANNOUNCE] = _EmojiAnnounce()
    $__g_ahEmojiPNG[$EMOJI_HELP] = _EmojiHelp()

    $__g_ahEmojiPNG[$EMOJI_LOCKED] = _EmojiLocked()
    $__g_ahEmojiPNG[$EMOJI_UNLOCKED] = _EmojiUnlocked()
    $__g_ahEmojiPNG[$EMOJI_KEY] = _EmojiKey()
    $__g_ahEmojiPNG[$EMOJI_SHIELD] = _EmojiShield()
    $__g_ahEmojiPNG[$EMOJI_VISIBLE] = _EmojiVisible()
    $__g_ahEmojiPNG[$EMOJI_HIDDEN] = _EmojiHidden()

    $__g_ahEmojiPNG[$EMOJI_STATS] = _EmojiStats()
    $__g_ahEmojiPNG[$EMOJI_CHART_UP] = _EmojiChartUp()
    $__g_ahEmojiPNG[$EMOJI_CHART_DOWN] = _EmojiChartDown()
    $__g_ahEmojiPNG[$EMOJI_TIME] = _EmojiTime()
    $__g_ahEmojiPNG[$EMOJI_TARGET] = _EmojiTarget()
    $__g_ahEmojiPNG[$EMOJI_GOLD] = _EmojiGold()
    $__g_ahEmojiPNG[$EMOJI_PERFORMANCE] = _EmojiPerformance()

    $__g_ahEmojiPNG[$EMOJI_BOT] = _EmojiBot()
    $__g_ahEmojiPNG[$EMOJI_AI_ACTIVE] = _EmojiAIActive()
    $__g_ahEmojiPNG[$EMOJI_SETTINGS] = _EmojiSettings()
    $__g_ahEmojiPNG[$EMOJI_GAME_MODE] = _EmojiGameMode()
    $__g_ahEmojiPNG[$EMOJI_BOT_MAINTENANCE] = _EmojiBotMaintenance()
    $__g_ahEmojiPNG[$EMOJI_POSITION] = _EmojiPosition()

    $__g_ahEmojiPNG[$EMOJI_PC] = _EmojiPC()
    $__g_ahEmojiPNG[$EMOJI_NETWORK] = _EmojiNetwork()
    $__g_ahEmojiPNG[$EMOJI_SERVER] = _EmojiServer()
    $__g_ahEmojiPNG[$EMOJI_MEMORY] = _EmojiMemory()
    $__g_ahEmojiPNG[$EMOJI_TOOLS] = _EmojiTools()
    $__g_ahEmojiPNG[$EMOJI_CPU] = _EmojiCPU()

    $__g_ahEmojiPNG[$EMOJI_LIST] = _EmojiList()
    $__g_ahEmojiPNG[$EMOJI_CARDS] = _EmojiCards()
    $__g_ahEmojiPNG[$EMOJI_SEARCH] = _EmojiSearch()
    $__g_ahEmojiPNG[$EMOJI_DROPDOWN] = _EmojiDropdown()
    $__g_ahEmojiPNG[$EMOJI_ARROW_RIGHT] = _EmojiArrowRight()
    $__g_ahEmojiPNG[$EMOJI_ARROW_LEFT] = _EmojiArrowLeft()

    $__g_ahEmojiPNG[$EMOJI_NIGHT_MODE] = _EmojiNightMode()
    $__g_ahEmojiPNG[$EMOJI_DAY_MODE] = _EmojiDayMode()
    $__g_ahEmojiPNG[$EMOJI_THEME] = _EmojiTheme()
    $__g_ahEmojiPNG[$EMOJI_SOUND_ON] = _EmojiSoundOn()
    $__g_ahEmojiPNG[$EMOJI_SOUND_OFF] = _EmojiSoundOff()
    $__g_ahEmojiPNG[$EMOJI_SLEEP] = _EmojiSleep()

    $__g_ahEmojiPNG[$EMOJI_SCHEDULED] = _EmojiScheduled()
    $__g_ahEmojiPNG[$EMOJI_CALENDAR] = _EmojiCalendar()
    $__g_ahEmojiPNG[$EMOJI_CLOCK] = _EmojiClock()
    $__g_ahEmojiPNG[$EMOJI_HOURGLASS] = _EmojiHourglass()
    $__g_ahEmojiPNG[$EMOJI_COMPLETED] = _EmojiCompleted()
EndFunc

Func _GUICtrlSmiley_Create($iEmojiID, $iLeft, $iTop, $iSize = 32)
    Local $idPic = GUICtrlCreatePic("", $iLeft, $iTop, $iSize, $iSize, $SS_NOTIFY)
    _GUICtrlSmiley_SetData($idPic, $iEmojiID, $iSize)
    Return $idPic
EndFunc

Func _GUICtrlSmiley_SetData($idEmoji, $iEmojiID, $iSize = 32)
    If $iEmojiID < 0 Or $iEmojiID >= $EMOJI_COUNT Then Return False
    If $__g_ahEmojiPNG[$iEmojiID] = 0 Then Return False

    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iSize, $iSize)
    Local $hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, 2)
    _GDIPlus_GraphicsDrawImageRect($hGfxCtxt, $__g_ahEmojiPNG[$iEmojiID], 0, 0, $iSize, $iSize)
    Local $hBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
    _WinAPI_DeleteObject(GUICtrlSendMsg($idEmoji, $STM_SETIMAGE, $IMAGE_BITMAP, $hBMP))
    _GDIPlus_GraphicsDispose($hGfxCtxt)
    _GDIPlus_BitmapDispose($hBitmap)

    Return True
EndFunc

Func _GUICtrlSmiley_GetName($iEmojiID)
    Local $aNames[$EMOJI_COUNT] = [ _
        "Online", "Offline", "Waiting", "Connecting", "Unknown", "Bot Active", "Maintenance", _
        "Play", "Pause", "Stop", "Refresh", "Restart", "Next", "Previous", _
        "Add", "Remove", "Edit", "Notes", "Save", "Browse", "Trash", _
        "Success", "Error", "Warning", "Info", "Notification", "Announce", "Help", _
        "Locked", "Unlocked", "Key", "Shield", "Visible", "Hidden", _
        "Stats", "Chart Up", "Chart Down", "Time", "Target", "Gold", "Performance", _
        "Bot", "AI Active", "Bot Config", "Game Mode", "Bot Maintenance", "Position", _
        "PC", "Network", "Server", "Memory", "Tools", "CPU", _
        "List", "Cards", "Search", "Dropdown", "Arrow Right", "Arrow Left", _
        "Night Mode", "Day Mode", "Theme", "Sound On", "Sound Off", "Sleep", _
        "Scheduled", "Calendar", "Clock", "Hourglass", "Completed" _
    ]

    If $iEmojiID >= 0 And $iEmojiID < $EMOJI_COUNT Then
        Return $aNames[$iEmojiID]
    EndIf
    Return "Unknown"
EndFunc

Func _GUICtrlSmiley_Shutdown()
    For $i = 0 To $EMOJI_COUNT - 1
        If $__g_ahEmojiPNG[$i] <> 0 Then
            _GDIPlus_ImageDispose($__g_ahEmojiPNG[$i])
        EndIf
    Next
    _GDIPlus_Shutdown()
EndFunc

Func _WinAPI_Base64Decode($sB64String)
    Local $aCrypt = DllCall("Crypt32.dll", "bool", "CryptStringToBinaryA", "str", $sB64String, "dword", 0, "dword", 1, "ptr", 0, "dword*", 0, "ptr", 0, "ptr", 0)
    If @error Or Not $aCrypt[0] Then Return SetError(1, 0, "")
    Local $bBuffer = DllStructCreate("byte[" & $aCrypt[5] & "]")
    $aCrypt = DllCall("Crypt32.dll", "bool", "CryptStringToBinaryA", "str", $sB64String, "dword", 0, "dword", 1, "struct*", $bBuffer, "dword*", $aCrypt[5], "ptr", 0, "ptr", 0)
    If @error Or Not $aCrypt[0] Then Return SetError(2, 0, "")
    Return DllStructGetData($bBuffer, 1)
EndFunc


Func _EmojiOnline()
    ; 🟢
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAKlBMVEVHcEx4sVl4sVl4sVl4sVl4sVl4sVl4sVl4sVl4sVl4sVl4" & _
        "sVl4sVl4sVlvsrX5AAAADnRSTlMAIGCPv9//UJ/vQK+Az1vcyGwAAAESSURBVHja7ZhZDoMwDESBkInNcv/rVmqprBYRAjN/7TuA" & _
        "5S2OPV2FfkhjxkYe09B3NyiWsSNb6S7RJ8cBntr9mmZUmac2bwynWINXi6MBX87cWdHIWnWqOJrxUgkLlzgMz3ARI+0ERtoJrJIf" & _
        "Mk8FNylf/eO4iX/204rbrGSCgmUXGB+cIWB6YALJez7NIJm3DIHmlaUEmvQ05KDxeBwkJWrPd0CGgBw1o+s2QMIQxWcbYISEMXLN" & _
        "Zhsi/oZ+2pCsIWVPRPZoZWNENthUo1Y2/GXfkeqDlH3ZsiVCtdaIFy1+9VMvo/x6rF/Y+RNCf9TwZxZ/+BGW9Eetic91XkDQSxq8" & _
        "yMLLPmIhSi+N6cU6Xj58AMJUYqG+9bSbAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiOffline()
    ; 🔴
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAKlBMVEVHcEzdLkTdLkTdLkTdLkTdLkTdLkTdLkTdLkTdLkTdLkTd" & _
        "LkTdLkTdLkTinyuNAAAADnRSTlMAIGCPv9//UJ/vQK+Az1vcyGwAAAESSURBVHja7ZhZDoMwDESBkInNcv/rVmqprBYRAjN/7TuA" & _
        "5S2OPV2FfkhjxkYe09B3NyiWsSNb6S7RJ8cBntr9mmZUmac2bwynWINXi6MBX87cWdHIWnWqOJrxUgkLlzgMz3ARI+0ERtoJrJIf" & _
        "Mk8FNylf/eO4iX/204rbrGSCgmUXGB+cIWB6YALJez7NIJm3DIHmlaUEmvQ05KDxeBwkJWrPd0CGgBw1o+s2QMIQxWcbYISEMXLN" & _
        "Zhsi/oZ+2pCsIWVPRPZoZWNENthUo1Y2/GXfkeqDlH3ZsiVCtdaIFy1+9VMvo/x6rF/Y+RNCf9TwZxZ/+BGW9Eetic91XkDQSxq8" & _
        "yMLLPmIhSi+N6cU6Xj58AMJUYqG+9bSbAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiWaiting()
    ; 🟡
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAKlBMVEVHcEz9y1j9y1j9y1j9y1j9y1j9y1j9y1j9y1j9y1j9y1j9" & _
        "y1j9y1j9y1iQpHQ3AAAADnRSTlMAIGCPv9//UJ/vQK+Az1vcyGwAAAESSURBVHja7ZhZDoMwDESBkInNcv/rVmqprBYRAjN/7TuA" & _
        "5S2OPV2FfkhjxkYe09B3NyiWsSNb6S7RJ8cBntr9mmZUmac2bwynWINXi6MBX87cWdHIWnWqOJrxUgkLlzgMz3ARI+0ERtoJrJIf" & _
        "Mk8FNylf/eO4iX/204rbrGSCgmUXGB+cIWB6YALJez7NIJm3DIHmlaUEmvQ05KDxeBwkJWrPd0CGgBw1o+s2QMIQxWcbYISEMXLN" & _
        "Zhsi/oZ+2pCsIWVPRPZoZWNENthUo1Y2/GXfkeqDlH3ZsiVCtdaIFy1+9VMvo/x6rF/Y+RNCf9TwZxZ/+BGW9Eetic91XkDQSxq8" & _
        "yMLLPmIhSi+N6cU6Xj58AMJUYqG+9bSbAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiConnecting()
    ; 🟠
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAKlBMVEVHcEz0kAz0kAz0kAz0kAz0kAz0kAz0kAz0kAz0kAz0kAz0" & _
        "kAz0kAz0kAxZQiakAAAADnRSTlMAIGCPv9//UJ/vQK+Az1vcyGwAAAESSURBVHja7ZhZDoMwDESBkInNcv/rVmqprBYRAjN/7TuA" & _
        "5S2OPV2FfkhjxkYe09B3NyiWsSNb6S7RJ8cBntr9mmZUmac2bwynWINXi6MBX87cWdHIWnWqOJrxUgkLlzgMz3ARI+0ERtoJrJIf" & _
        "Mk8FNylf/eO4iX/204rbrGSCgmUXGB+cIWB6YALJez7NIJm3DIHmlaUEmvQ05KDxeBwkJWrPd0CGgBw1o+s2QMIQxWcbYISEMXLN" & _
        "Zhsi/oZ+2pCsIWVPRPZoZWNENthUo1Y2/GXfkeqDlH3ZsiVCtdaIFy1+9VMvo/x6rF/Y+RNCf9TwZxZ/+BGW9Eetic91XkDQSxq8" & _
        "yMLLPmIhSi+N6cU6Xj58AMJUYqG+9bSbAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiUnknown()
    ; ⚫
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAKlBMVEVHcEwxNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0x" & _
        "Nz0xNz0xNz1W538qAAAADnRSTlMAIGCPv9//UJ/vQK+Az1vcyGwAAAESSURBVHja7ZhZDoMwDESBkInNcv/rVmqprBYRAjN/7TuA" & _
        "5S2OPV2FfkhjxkYe09B3NyiWsSNb6S7RJ8cBntr9mmZUmac2bwynWINXi6MBX87cWdHIWnWqOJrxUgkLlzgMz3ARI+0ERtoJrJIf" & _
        "Mk8FNylf/eO4iX/204rbrGSCgmUXGB+cIWB6YALJez7NIJm3DIHmlaUEmvQ05KDxeBwkJWrPd0CGgBw1o+s2QMIQxWcbYISEMXLN" & _
        "Zhsi/oZ+2pCsIWVPRPZoZWNENthUo1Y2/GXfkeqDlH3ZsiVCtdaIFy1+9VMvo/x6rF/Y+RNCf9TwZxZ/+BGW9Eetic91XkDQSxq8" & _
        "yMLLPmIhSi+N6cU6Xj58AMJUYqG+9bSbAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiBotActive()
    ; 🔵
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAKlBMVEVHcExVrO5VrO5VrO5VrO5VrO5VrO5VrO5VrO5VrO5VrO5V" & _
        "rO5VrO5VrO7fvvRWAAAADnRSTlMAIGCPv9//UJ/vQK+Az1vcyGwAAAESSURBVHja7ZhZDoMwDESBkInNcv/rVmqprBYRAjN/7TuA" & _
        "5S2OPV2FfkhjxkYe09B3NyiWsSNb6S7RJ8cBntr9mmZUmac2bwynWINXi6MBX87cWdHIWnWqOJrxUgkLlzgMz3ARI+0ERtoJrJIf" & _
        "Mk8FNylf/eO4iX/204rbrGSCgmUXGB+cIWB6YALJez7NIJm3DIHmlaUEmvQ05KDxeBwkJWrPd0CGgBw1o+s2QMIQxWcbYISEMXLN" & _
        "Zhsi/oZ+2pCsIWVPRPZoZWNENthUo1Y2/GXfkeqDlH3ZsiVCtdaIFy1+9VMvo/x6rF/Y+RNCf9TwZxZ/+BGW9Eetic91XkDQSxq8" & _
        "yMLLPmIhSi+N6cU6Xj58AMJUYqG+9bSbAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiMaintenance()
    ; 🟣
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAKlBMVEVHcEyqjtaqjtaqjtaqjtaqjtaqjtaqjtaqjtaqjtaqjtaq" & _
        "jtaqjtaqjtb0wMBrAAAADnRSTlMAIGCPv9//UJ/vQK+Az1vcyGwAAAESSURBVHja7ZhZDoMwDESBkInNcv/rVmqprBYRAjN/7TuA" & _
        "5S2OPV2FfkhjxkYe09B3NyiWsSNb6S7RJ8cBntr9mmZUmac2bwynWINXi6MBX87cWdHIWnWqOJrxUgkLlzgMz3ARI+0ERtoJrJIf" & _
        "Mk8FNylf/eO4iX/204rbrGSCgmUXGB+cIWB6YALJez7NIJm3DIHmlaUEmvQ05KDxeBwkJWrPd0CGgBw1o+s2QMIQxWcbYISEMXLN" & _
        "Zhsi/oZ+2pCsIWVPRPZoZWNENthUo1Y2/GXfkeqDlH3ZsiVCtdaIFy1+9VMvo/x6rF/Y+RNCf9TwZxZ/+BGW9Eetic91XkDQSxq8" & _
        "yMLLPmIhSi+N6cU6Xj58AMJUYqG+9bSbAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiPlay()
    ; ▶️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABIBAMAAACnw650AAAAKlBMVEVHcEw7iMM7iMM7iMM7iMM7iMM7iMNHj8fz+PudxOH////n" & _
        "8PiFtdqRvN0EUhs+AAAAB3RSTlMAYL//IM/vVZgOvgAAALZJREFUeAFiYGAQMsYLFBmAwNWYAAhhYGBJJqTIzIGB1ZggCGAQJqzI" & _
        "kEGZsCIjBmMiwAhRVEyMos5iQLt1aAMwDAAxcH/QRTpDhys8Zr0UGn7cHtBLBaICUYFCQaGgUFAoiApEFaIKUYWoQlQhqhBViCpE" & _
        "FaIKUYWoQNSCvkRMIwYKA4WBwkBhoDBQGCgMFAYKA4WBmEBhoDBQGCgMFAYKA4WBnpvXczQNzbRG02RNuzaN37KQP03j8PLrPA2+" & _
        "AAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiPause()
    ; ⏸️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABIBAMAAACnw650AAAAG1BMVEVHcEw7iMM7iMM7iMM7iMM7iMP///87iMNsptLCEAVxAAAA" & _
        "BnRSTlMAYCDPv++evUMBAAAAaElEQVRIx2NgYBApxwscGYBAuZwAMGJgYAonpKhUgYG5nCAwYBAnrKiQwZ2wohKGciLAyFHUAQIo" & _
        "DCyK0kAAhTGqaFTRqKJRRaOKRhVRpmi0DsajiKgGDVFNI6IaWUQ114hq+BHThAQAA8SME6BTT3sAAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiStop()
    ; ⏹️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABIBAMAAACnw650AAAAGFBMVEVHcEw7iMM7iMM7iMM7iMM7iMP///87iMMg5IntAAAABnRS" & _
        "TlMAYCDPv++evUMBAAAAXUlEQVR4Xu3WsQ1AABgF4QsrSLQSC4gNVEawgV5C/vV1KvFe1O/qb4ADuvpsARhLNEOzKXQNtCWb6DU6" & _
        "WDU6KaMHBe2v/UJBQUFBQUE6gqyhsdbImixr16zxsxbyBuwUaFmPjuToAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiRefresh()
    ; 🔄
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAARVBMVEVHcEw7iMM7iMM7iMM7iMM7iMP///9sptLO4fC20ulUl8ud" & _
        "xOFgns7a6fQ7iMPz+PuFtdrC2uypy+VHj8eRvN3n8Ph4rdZhf4NlAAAABnRSTlMAv+9gIM+kpfmZAAAB20lEQVR4Xt3Y227DIAyA" & _
        "4XRtbXMmPb3/o04Lm1hmiK3C1f7r5FMkBAGWr86nONDpvJQu1zjY9bI5H3G4jy/pGid0XZZznNJ5Oc2BTkuclAa621HIZkNQSmSy" & _
        "fQ+ytyf86XmzGsj/ZpCgGaEMkakmQTfyIgQ/koPDnAAFKJIPIBT8IQSwSZhALKEEgcmgKvch2wLS6nDLrYlJHQg5Y3ZjjWYnoRoy" & _
        "bGbY31TyHeghj8x+REMHcjvHxE6mSk4BPSKPf7lvQsQ+SJRIgCSpjh62oACSxB9dWxCAWvLwkxUgSTJ84JbuDCHKDGAPBw7h99ur" & _
        "cxnxXgD5kyyD7uVtZS82d5f4XglKt1FohRKNQg5KqQlZxIfVQQjfMYgCbOEoBPA/oECjkM2ItrlCJjYNVXGIoLSOQjcopVEow3cv" & _
        "DcAnOl+PjPx2dm4lqmPTWbNt18hE8CfLIadcYvcd7ka8IAlQXNlCLEuhBaH671ijHcT/tQ9BEiCv30Q0/2s1p9vWyFAMuo1W7dGB" & _
        "fFJt/WrYgSIKm1E1FLN2e8x3I0xSlcvnxS6kP0IYAdIeajYpHEH6Y5YBEiDtwc8IkP4o6ucfjuXjelIf1+UqIEPjTbtkmXbtM+si" & _
        "atrV2LzLumnXh58fkO/Lo6a6oQAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiRestart()
    ; ♻️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAk1BMVEVHcEx3slU+ch13slV3slV3slV3slV3slV3slV3slU+ch13" & _
        "slV3slV3slV3slU+ch0+ch13slU+ch13slU+ch0+ch0+ch0+ch13slU+ch0+ch0+ch0+ch0+ch1VjDNbkjk+ch13slVpokdzrlJJ" & _
        "fihbkjlMgitFeiRwqk5TijJelj1Qhi9CdiFXjjZimkBspktlnkRZCcOUAAAAIHRSTlMAIDBQQL8Qn++A36+P32AQgHDvMCBQj6/P" & _
        "v0DPcGBQILIJkG4AAAJjSURBVHhe1ZfnktswDIRFSRRVi2u53CWgy5X093+6jH0Y+SQgNGFpMpP972+WwGpJB/9CdWUHqu/iGEuU" & _
        "JoFcmWWUyTlfTsfj7yks7QAAfo23tIKznkdbauZw0Z6QjAy0BkBLRErCeUDOaEufACax9AgwiaUlTnq0pQ3AJJZCJDgtKaMzr5W5" & _
        "LSmDXeC3M9QLAuSfS7Puk35aXguPQPZMfeY5aeCj9hqBllScaHnLDXLyJlAsKPJukvwCWmHryk5Gh745M5XsZFRh+9icQcn2rpMt" & _
        "alNVH9KWZKn8ZItZgb/qOrVORTtDCLWeWNHO4kzbvkoEKUEaE2692wClOVDBgmaWU+c2MnRKtf/tbGPksKyEH5CjJXhWEfBS3Bw0" & _
        "3UhZ3XzfRExY2IiU1Y2Lu2SHxLKy7L3SnnKYh8S1uErD3aVkhqCtc0hUTdvVniBJbFeh5stetFNHkqiWO7hqQ96dVDP3qVAPjkm7" & _
        "YhfmcNVg3pUVXDhrGKp1fGrblF6BpbUZB+rmrVJqRaliGGCDe1wC0e4dVPBTjrSO+xwMREtJUTdpvtMGHAQ1OQFV5whVjvyQfOAb" & _
        "fKA3W7OTNgwHxT3pnk8HW3KNfPj+Ho9Vj+OW5kb9A3CrLg4tisWQswcU+HNszMTx2IH8OTqga/sKndwcuuaYTBrlzdEBjfYb9ECl" & _
        "9VFMa20PfZAXRzNF+yIC0SLVyDnBAFSKDHVhesVJy4Yd0+vxGxBQYCSGMEyvCBAEkv6RiK4rk30ihnsjHUmB3iYp+mYp7OHjkPKQ" & _
        "1Ij4feAotrEyI0G0/KciBVOQRoHIlf0f6Q+l9zfssTO/4QAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiNext()
    ; ⏭️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAANlBMVEVHcEw7iMM7iMM7iMM7iMM7iMM7iMNHj8dsptLa6fT///9g" & _
        "ns7z+PuFtdq20umpy+V4rdZUl8tW45JBAAAAB3RSTlMAYL//IM/vVZgOvgAAAQxJREFUeAHtmIWOw0AQQxeCTrJ79/8fezgVWmDF" & _
        "UikWv8qvbXA06Te51BMpOf1nGOvJjMOfZ6qnM/2axmrImFKuluRUPKKSqimX6MlFM/l4rjxLhIpW0mLsN4hQEUgrmCjCutUIY4II" & _
        "e7QIU0SkFUwXYT9qhDBFBESLMEEULcp0ERpnugiNM12ENlOmi7DOjImiaFGmi7BulOki7BtjoihalOki7Adlugg4GNNFPDhcIjSX" & _
        "CM0lQvOLHuOvdfPpv8MFuX8wZr5p7/AYWT8ZMz9q7/Dwb5zd7QXZGbMOEXcYa+IWIMw6+t1hGL3dApTdYWAnnZl7uMiQS3SJXEsW" & _
        "29rHtYiyrcZ8yzrb+vAbKJpltkS1JjAAAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiPrevious()
    ; ⏮️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAANlBMVEVHcEw7iMM7iMM7iMM7iMM7iMP///87iMOFtdq20ulgns7z" & _
        "+PtHj8fa6fSpy+VUl8t4rdZsptLtya6MAAAABnRSTlMAv+9gIM+kpfmZAAABHklEQVR4Xu2Y22qEQBBEx3XtnvGW5P9/NmxSEJbS" & _
        "h8KCIWA9HqgDojM2XV4Zh7yQYSy/eU55MdPzx/PIy3m8TFMaMpUypiVjGTyioaQp/1x0i76Qk8J6wlgUyIlnO2KSCJ04YrJo3sCJ" & _
        "aaJ5ASemiNAJYrKoLuDENFEFJyaKKnEwUdSCeQtBRJ0gJojWFlQCk0TrBgQOJom4E2Ahi+b3ToDJonmJ94CJIu4EmCiq1AkwTVSD" & _
        "AyaI4KHoohYeUQuPCB6/qP+jZe6iSH/9/T7IzE8+DmCuQ9vlGkE+NiqBua7aPpc/0qgE1uMHiexUArMNEd3Gmr/jQsw3+nUbRnE0" & _
        "jlingR2t9YCR6FJu0S2yLVlsax/XIsq2GvMt62zrw28574l/Z8VgIAAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiAdd()
    ; ➕
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABIBAMAAACnw650AAAAFVBMVEVHcEwxNz0xNz0xNz0xNz0xNz0xNz00FWOiAAAAB3RSTlMA" & _
        "IJ/v/zAQ8+scuwAAAH9JREFUeAHtlsEJwCAMRXuxA+gEhS4gZAKTAbr/NK2F9NaffxXyzg+U6Cd/W4EqekROETO9AqnZQw+kc0oj" & _
        "kGRKip3dXjgJs5iUUkpV7BePcwHOF+dmkO6hRQwPLUI9jxBaoo6jLk6MgBgm/yz5fVNKiV/5fHngawhTaLwaLcANMWSyVST4DfoA" & _
        "AAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiRemove()
    ; ➖
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAElBMVEVHcEwxNz0xNz0xNz0xNz0xNz3y9AWAAAAABXRSTlMA7yCf" & _
        "MKQ6t0YAAABOSURBVHja7dO7EQAhDANRhFH/LV/GESMHBPsK0Pg7AAAAXjBLvqKa47Dka1pHPXJAf03lSO0gOaId5FB3UN5a97Dz" & _
        "9TcfZP4iAAAAD/gAXIUOWQcR/RwAAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiEdit()
    ; ✏️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAsVBMVEVHcEzZnoLZnoLZnoLM1t3qWW7ZnoL/zE3qWW7ZnoLZnoKZ" & _
        "qrWisbzZnoLZnoLZnoLqWW4pLzMpLzMpLzPZnoLqWW7qWW7ZnoLZnoLqWW4pLzPqWW7qWW67x9DV1MUpLzPqWW4pLzPZnoLZnoIp" & _
        "LzPZnoLM1t0pLzOZqrXqWW7J09ujsr3/zE3nr27DkHjCztb8zVacrbi5xs7W1MLfiJg0NjhKREKXdGQ/PT1rWVF2YFZwkFC4AAAA" & _
        "JXRSTlMA7yAQYGBgYBDPgGBgcL/fgIBwz49wIJ9Q799Qn2BgYM8gQDAQun1/XwAAAWBJREFUeNrt0GdywlAMRWG5Aqb3DiGJCyW9" & _
        "Z/8LSygzF2eCxnryT58FfCNdOm/Qb7W8Mmkrz9b7xlOtc7U+5akdSCoHvbo5OVHk5uRED9WcnKcEks5JknlOzjN2UjrRpiaDZpec" & _
        "rWynwWUnSSQ39RlnuxHs1OKcKFoIIM55eSxlhTze2e2ySuUx72SXpqwjkTzGEUqMI5NcxhFKjCOTqowjlBhHJs0ZR7hTytFINcaR" & _
        "7gRHeRMcpeTCUUoLOEqptCukQiqkQsog3Y1UEpzQcjQSnDAMSCPBCZtkLME55KskOGGDDCU4p2yVBCesk4EEB1XIRIKDbDMJDn4z" & _
        "kOCgBplIcJBjIsFBPhlIcNCQpBKcVBaJJTipbsTSyPoXCkicEzT/Kvff7xMyyW+knI+3OI6XZJTda+KevRN3yTS7XjlCX/GhFZnn" & _
        "+MPf6T+PUId0XfcmR6hN6pZdXKRs1Wm3b38Ai5w9ZKhA8zsAAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiNotes()
    ; 📝
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiSave()
    ; 💾
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAS1BMVEVHcEwxNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz1V" & _
        "rO7h6O1+hIpTpePL0tdRndjW3eKUm6A/Y39BaoozPkhzeX+fpqs8Qkhju1jkAAAACnRSTlMAQO+AUBC/359gaxWCaQAAAMJJREFU" & _
        "eF7t2MsKhDAMhtGoram/97m//5OOmykVLBgNzMDk22VzIKtAaMlXjGNxQ0muxPGCj06BU4UIMXSkZgO4dLt6rqR6A+p29kolCCDE" & _
        "1nPQghC0IAQtCE4LYi0IBhmUZpBBO8pD8nN0yUDy/hC6Da2g4ZaDrq2wawaapNCUgVpx95+DMqt14r4AGWSQQQYZZJBBo9QZVxDH" & _
        "oZdCj8SpqUKsnyXM3COpIV9CISYiB4UKWioYJyvd5z1W40RceSJ6A3RD2qmpnYlRAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiBrowse()
    ; 📁
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAYFBMVEVHcEwiZpkiZpkiZpkiZpkiZpkiZpkiZpkiZpkiZpkiZpki" & _
        "ZpkiZpkiZpkob6Q4hb5Im9lVrO5Im9klap48icRVrO5VrO5Ln95VrO5VrO4/jclVrO41gLksc6lSqOkyfLRR3uaiAAAAHHRSTlMA" & _
        "YL//cCDPgBDvjzBQQP////+A///PIP/vYP+/Y8OpvgAAAORJREFUeAHtzFVihEAUBEDgrXvjzv1PGSP5WRnt+NQBKgp+qziRG8li" & _
        "adssV3LfemP3bOWRldW0EqFMsaiszKNElHbGkWjErGi7J0WyPRCiWXI4EiLFHxOi2WpJimS7JEWycohO5wtuXFLbKMtxX1FaRVmF" & _
        "R+r3yfcBCouogkpjHLVQ6kyjHhqG0TByomkEIRqmC2AX9RcYU0SnCmBEpxGcqAIn6kGKLqwIpCj7cZGEKERqIfIUohBNIhMlqqap" & _
        "okQdvHVvUQNvTfSmgKcimpU1vNRl9DEV8FDMz6zp4KhrouAXewayILxkODCyogAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiTrash()
    ; 🗑️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAP1BMVEVHcExndX9ndX9ndX+aqrSaqrSaqrSaqrSaqrSaqrSaqrSa" & _
        "qrSaqrSaqrSaqrSaqrSaqrSaqrSaqrSaqrRndX8VtlsmAAAAFXRSTlMAUN//v/9gQM+fMK+AIBDvcI/fUBDdJcf4AAADVElEQVR4" & _
        "AazRAQ0AMBCDQNr697xMw3MOCJDurIFMETpFmYRJvLRMEW//9xgto3VJQRgGc4EoKoD4/u+6Z/XHbc7Xi+3NGIcGJ4ll4vJT6blc" & _
        "F2oLitcXb4rT38sYnoIImJdZu+L8wH2xmM7jIzqfr8rPVW2y0uBWLS+4PJfnR9QffPGo30rFyfKCr+eqBwoh2ifByUrwJxq854fb" & _
        "lIsq7IEEuS6IBs6I9kqyVPDDiybUQmdmh4MF4PXlY8MjgOFdwr8aGPU86gjhfkWrE49XtFeSe2IsHIYIahSazC1NjGjwglluYjTV" & _
        "p8p3o01cDLwQlXpvSJCoA/kFH2YfwRIjNKGSvArgZFJgMZpJkKgWdCW46T5gTDalv5gMg0XFVgWL+0q0cycr3uVdBTtEUSTg1wpG" & _
        "tFWxuC8u5F8h7ebFlvBlcdXxvyrR+a1Qouq4z35U10QM4cVrp0EUkc4DvOqCQ3nVfU3yrjfyL0mK8HLD9T97oqkk8Ir7KgGRE9xV" & _
        "kiFxBWuQZiV99KG8y6qvmsaIyF9kkEenVnipTBpZfgkNmpTxyo0krdMJb2+Itr+PWiVGNjbr7OQTvlphgG/yBhssCVJiEiLJTkdK" & _
        "8O+IxuQsNkbi/0kMMw1os21oxQbZHibBI8oyKrtxC/e6DMZkicT/KJOvmlyiapVJeuK+1vFuevmHgA59bL+ESPy3nbcElY7b8kZ1" & _
        "n+q8sJtGP8nQRzRSuyGk4/9Kp0ksojXgZXjp+FUFoyqdRUdqNst4syu/wQ0SnQx9jgtp2CaviZHWQNGo0yGJRFOkiPAs84JUjGnc" & _
        "plNsK16MjIx8ECM0sZodEiOkc4JUQ9POc8JTeZsTIxkkSUcskqAGaUO0DQHcIN1RRyySIBq8iObHCP91xCLJFE1H7s6L7RM1Gc5I" & _
        "QhUd5VFjpP5TOFeROkbkrvK1676MiEZ8O5KkhGid0DchkhKnLzrGqsN/HfBfmglvkMhxtGxyHAE5juB0CkvkgISXTj0gXfcltUnz" & _
        "I0c2eUrfHm7x7f/8iQAEv4b7t6bwtKJvhtSvyO+WzkOzIX+0fPeZIMOyIgmi2d7Bw7t12mgkHfozhMlbq/VnjEzkDxwgANnjSJgm" & _
        "MZE7uIIGRJjJBDQyiHKvUR7YVI9+ALq4Sv5opt7bAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiSuccess()
    ; ✅
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAARVBMVEVHcEx3slV3slV3slV3slV3slX///93slWAt2D3+vSRwHXM" & _
        "4r+72aqz1J/u9eqIvGrm8d+qz5WZxYDd7NXV58rE3bWiyor8Z4cFAAAABnRSTlMAYO8gz79WeQLOAAABcUlEQVR4Xu3YWY6DQAwE" & _
        "UEjA7pV1uf9RR1lGcjqtFGr3SPOROsCD+imEm1vanhXp2+aRa8fKdNe7c2F1Ljep4wrpmqblKmmbvg7UN1wpfwZ9IbO4GtDoicgG" & _
        "NTRausdroZWemXVQpN9MCMLFnlFBG9WBDuFsCshYAR0KaEteCEO4mDXlkBkEFLkc2oWzcjm0yGJjAimKFUMhKVYKORJxCmgSTuBy" & _
        "SBabGECniymgVTg7l0NROIMph+Sa0cIAUhQDECiGILxmGHLekvUGrBmGjseTrcNrlofSBtaBYgCKRLlvqE/WDEMrCQmsGYaklF8z" & _
        "DO0k4z/MNIBGSqR8MQxxeJeGzJphiOOrtJr8mmGI51dpkqwD0EfpQzEA8WLzzsAISuPy0gIhLOXXDEM8Tu/FTAnEZsoVwxCWPBdC" & _
        "bDzhNcNQukIHKyAhbayCOIhiKohne3MGx1qITQxh/n+/ol+o2pGl2tmn1iGq2mms3rGu2vnwB/HSjdEb7tSVAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiError()
    ; ❌
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAHlBMVEVHcEzdLkTdLkTdLkTdLkTdLkTdLkTdLkTdLkTdLkSddiGb" & _
        "AAAACXRSTlMAEM/vgCAwQJ937tdTAAAA9klEQVR42u3YSwrDMAwEUDlykur+Fy5tKbPQQoxHlFCipbEfjn+xZX8eY3qET7nd2OId" & _
        "26CY3G5G8BKciG+fPCCtOOGfkj2CkeAgANESHEDmSSIdx2AniXFiopiRcgMzSiqqlxLhlFLt8FKuWFYgHF6SK+nd7h9IfWq7F5u+" & _
        "/AmnkAqHkAqHkAqHkBadLGVnUUqOJsHRJDiaBEeT4OgSHF6SHR3SP00fbH369QWpb5Ffb1r9GNEPNv2o1Q9//XdEO/c9875n3vfM" & _
        "69wzre0p2vw4Prqe62dXAsGiKaVhDznJ0p32sfHqk8+xkIhK7c7DlmLf7arxBG7ZOBvhaT96AAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiWarning()
    ; ⚠️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAWlBMVEVHcEz/zE3/zE3/zE3/zE3/zE3/zE3/zE3/zE3/zE3/zE3/" & _
        "zE3/zE3/zE3/zE3/zE3/zE2tizwjHyCRdjfIoULxwUpoVS4xKiN2YDFaSis/NSZMPyifgDnWrEWCNKz2AAAAEHRSTlMAgL9gQO/f" & _
        "IJ8Qr48wcFDP1xEQBwAAAZhJREFUeNrN2IuKwjAQhWET2/Sm7kla6/39X3OhTTdISCfTkcXzAD8fKBlx948ruq74RGcPAHt5pykB" & _
        "oGzEoQ7TOmmngl8lDNXwq8WgQBKCAkkOkpNaIKwVfKfxtmJzSONtWgiSkzQgIwWQnBRActIJ8/q7cw+LeacNIYNpVzftimlm43sG" & _
        "DM5vwLT9VlC/hPpA4oPiEJ9kEiEu6YhUCEf+ix+H2HdAIR2CYoLiEJ+ksBaCYoHiEJ+kkAgxSVVJhcoq8wRRIdRZINAhVHkgOlQz" & _
        "QFGISaqTIR7pgLwQDkRI54Y0dYJyQygIUHZIkyA6RJM0J6QJEB2iSYYX+qFOEB0iTpPhhkw+CM8l9MQKiQbhfJk7lzNWSDQIeF2m" & _
        "zgvIJDUeFJts31vviUlN4sVnTyVOEHtlE4NkJBpk787dLUEiQeE3JEEiQdb52SxSjdRuS+iBsOQdqJCc+xuSqwJIFqozQBiXzgiC" & _
        "lARFP9gpkgcRH5sFSFKL1Q3j7TYOWF3rX3z5igCiRpPwkX1lqINs4e8lZSCcUbsv3C/iUatV7NwgPwAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiInfo()
    ; ℹ️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAQlBMVEVHcEw7iMM7iMM7iMM7iMM7iMM7iMN4rdb///+dxOHa6fRH" & _
        "j8dgns7n8PhsptJUl8u20unz+PuRvN3O4fDC2uypy+VNH0VfAAAABnRSTlMAv+9gIM+kpfmZAAAAuUlEQVR4Xu3YWQrDMAxFUTuO" & _
        "5Tlz97/VkrELeA9aiu4Czo8RyDJ7zgqQdeas9wLm+8PpBK7bJS+EvDFOKDljOZA1QooBKTRsrW0DDqV49EKhEK8CCLUbahg0xqcR" & _
        "guoHqhAk8wMJBk23M4FQyaczFxCSsu7OWgkjUpel/un0h5QCCj3PlgsMXc+ff2b60w2l70MKKaSQQgoppBC++ePbCL4f8Tc2/Yoq" & _
        "RDuy0M4+rEMU7TTGO9bRzodv4yN8wB6d3B0AAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiNotification()
    ; 🔔
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAM1BMVEVHcEz/rDP/rDP/rDP/rDP/rDP/rDP/rDP/rDP/rDP/rDP/" & _
        "rDP/rDP/rDP/rDP/rDP/rDPIzIGKAAAAEXRSTlMAIJ/v/zAQQK+/j89ggHDfUC2EKUAAAAEoSURBVHgB7dgFcugwDARQJ1qzA/e/" & _
        "7IcyryyV23cAGUbaZByYZRVA1iU4RcEFicFlEVwR355W3FiDh+CGBIeEO1xXjTvsl5QL7inZVqbikTpfKjU8qaXJOh3P6MnSz/fN" & _
        "93gSvECS/VzG0zUQLahkULouqKCqfUOGLRUolEAtILQTPKAy1JlI8LzsUOmBgdLnK5TUKU1EdV8T+ecWGiC0M7JBaaOjprTq4tEf" & _
        "klBTNba/tXeo7ZrAdsd2woTE29HfkgcmHGxD/i2lA1OOxOfMNW8R0yI5mO9wFQaVX5D1miKMMv/km34CTpidPGEtmSswE5Kwep+8" & _
        "0AGzgyeRKZV2gYns4VX8wgMfX6iSXFUb5IOo13FH97+Mwf82tvSb/ZA61KgAUOn9/AVW2in/wdtp3QAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiAnnounce()
    ; 📢
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAwFBMVEVHcEzQJTt8iZO+GTHdLkS+GTHdLkTdLkS+GTFmdX/dLkS+" & _
        "GTHM1t3M1t1mdX/M1t3dNErM1t3TJz7M1t2+GTFmdX9mdX/XKkDdLkTM1t2+GTHM1t1mdX9mdX/M1t2+GTHM1t3M1t2Zpq7ZU2bd" & _
        "LkRmdX9mdX/dLkTM1t1mdX/dLkS+GTGZqrV0g42Xp7GGlaCzvsaPnqiAjpjVgpFtfIfOx8+jr7fGHjbSl6S/ytHRJjzaTWC5xMvX" & _
        "bX3Pt8B8jJdXLlKbAAAAKHRSTlMAEBBAQIKAv8LCj+PDn4Dv+YUgQK9rQDBwUGwwn68gUN9ggI/f7zDPwwvGZwAAActJREFUeF7t" & _
        "19eSgjAUgGEQEQR7WV3X7S2h2svW93+rRYzECGbkJN7s+N/7jXNISFDO3KVC+6nWLYgqN80KWmCMy0LSdbWOEPrCm26FlLgJjrsC" & _
        "KXfNB0Ra421DAPNYQbQxJhVy/5k62s/HpG6+p1RlFDLq3ONuV9BhiwR6hTC0ECe9nTibKspqhvGJQ1KLxWK/VHpGma0xbXjkp5Zh" & _
        "GA1n1082NMK0MgF69Kfppii7AO8VM6rlcPpkgfRypEvy3eG1ShPMRqPbrcR1GnMe5M8o1HK4faNjRcDYC4hUUxSLD604kO95XphA" & _
        "L3xozoHCCAp2UI/vNCiQ3rKBF+WTbdvnQ59HoRGeeZsmZEVagFkTyI+hkEAGH5pyoN8YGotDk38K0RlJfmrS1pG0lS2+12Tvfmnv" & _
        "I3lvyChDxjtb2iki8Vyj6a7rLpfLj20O4KRNICYzOfvrOc/+Dgtp4NuIyTg2/H5kM5AOv7G5TBr4DqmyEPxWq7Ejgt+zWciE3/x1" & _
        "FgJ+i6Qh+NdRh4Xg32smC8G/IO0UBMxlssGO6rKBIe0A0mRBA1lQBw5JmnaLAOLP3xSYEXf3wxvsO6oi0L1NGFsnDpzSowY95Rxd" & _
        "+gM9kbO827m8HwAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiHelp()
    ; ❓
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAM1BMVEVHcEy+GTG+GTG+GTG+GTG+GTG+GTG+GTG+GTG+GTG+GTG+" & _
        "GTG+GTG+GTG+GTG+GTG+GTHqIc8BAAAAEHRSTlMA378QMEBg758ggHDPj1CvUGoeAgAAATNJREFUeF7t1duOgzAMBNBJE+JcgPr/" & _
        "v3ZX2oddizZD3EqrSpxnNCLgifGiS+33oD9uJVf4xLyqtfaIeV30SNpsVFr1sbBgRhZ9quG8piMFZ3U13ElZmY4zqiiVwOGm3Apu" & _
        "0TOy/4WsACapFbblWy6i1g6iPZm+2NS4T51MEn6lYJJY6fQv26soM2czXRj90G0iaBmd+zYRNCyPYEzMo6OzYazYkvMgXlmpJIhI" & _
        "YmbI2GaCUIuoSqk4iGKDuFjJ9yNBRD7032c7tNZlWdXq8NiP113FLHOrDapGR+GxBUd8ONkL+TecVMwo/m1kiX/5WyTn5aCOtwSF" & _
        "hHcESQPHg0KLeD0olB0UD8oVhGPHfXIQ37oc37oc37oc37qEe+tyF//H/p/f7x9If0X8pb3uo+s++ihfTixKw77tQyEAAAAASUVO" & _
        "RK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiLocked()
    ; 🔒
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAP1BMVEVHcEyquMKquMKquMKquMKquMKquMKquMKquMKquMKquMKq" & _
        "uMKquMKquMKquML/rDP/rDP/rDP/rDP/rDP/rDNHelJiAAAAFXRSTlMAIGCfz/9Ar78QjzDvcIBgv/8gz+9LsFlVAAAA9klEQVR4" & _
        "AezS187DMAiG4QzA2fv+b/Wfzca1SXfLe4r0yPmUQHu7wigG/AviKDzMkMFVho4xCe5K5FSaIVuWCh1ASyCS8gKtFbngPaPDS6n0" & _
        "uy7+utXOpqSfSrNa3M8hnKvS6ZkVzpEXlOAYrHbNAccSwYOYLVIQPcmsHV4ybifEMeZ/yXEsdELRtDN3nRaPnFCMp1Lumo7X2AkB" & _
        "swKzIDghPFXy53K8e0PEn+lxkPyu0KOgumk9a+ozTNe3gvrO6gytqMEm9a2w3rJPK47fqZFDDQu1B1JIIYUUUkghhV4X+h7FjQjK" & _
        "mzWUN7So3PSjvDFKk+YxAB0Uk+0jTt6RAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiUnlocked()
    ; 🔓
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAQlBMVEVHcEyquMKquMKquMKquMKquMKquMKquMKquMKquMKquMKq" & _
        "uMKquMKquMKquMKquML/rDP/rDP/rDP/rDP/rDP/rDMmhaaLAAAAFnRSTlMAIGCfz/9Ar7+PEDDf73CAYL//IM/vpykfGgAAAO9J" & _
        "REFUeAHt1gWSBCEMheF0TwJMaJf7H3V9HId1vgP8lXplAaemPSC9wUPbQCoh6YYUaRlFD1RC6khGR4YojGSBUSXdkVWvIRibO6cS" & _
        "QygkJ+SUneUgXgzyZnEIIuhiZPjAI10ICKHoBG921UgnKuIgwxaMUSdJc+e2JMGL6UTDA00nDfi0553B4Lx4C15NK3t6wc57DxBE" & _
        "j0q6F0TINNAHyCR+XIhLheBfh2qohqZ5CTRPYLduS4RttXb2JcpuK21LpM2yzxLNvNO8RJvBZEnwa0M1VEM1VEM1VEM1lP5ElH9r" & _
        "0h+t8q9f/jNa/j1+Bnmmm2tQyokYAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiKey()
    ; 🔑
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAM1BMVEVHcEzBaU/BaU/BaU/BaU/BaU/BaU/BaU/BaU/BaU/BaU/B" & _
        "aU/BaU/BaU/BaU/BaU/BaU8TO/0hAAAAEXRSTlMAMGCAr7+PcECf7//fEM8gUNW42NsAAAFLSURBVHgB7dYHgqQgEIXhR1LgUdj3" & _
        "v+zkPIhld23e7wC/gYgznA8xPVjWjOvlUvlB9LiKb/yqBsFZrnOkepwTuCcK9CRyX3P6TudMdTYdfanwSBMorBxrXuAKnyQc2yqH" & _
        "uuCR55MVhxLHtk8TowoOZI4lvNj4JOBA5FjAK6peaeOO8iVEf92QseHFhc8iphL3rF9nq2CGnJe2zlcZE44TbQmF7wImLtQrmAjU" & _
        "S/9Dt4Uy9RZMbNQLmKlUy5iJVMOUp1bElFQqXTBXqNMw5yp1vFGnGXWYjTqLUadbdeRP6qBRKdisseTO32Jr+Z7xwOlQdRAf+a4v" & _
        "DsfioPPEXcKjNQs0yrijZ9iRdRVtRzUP/3fGmlEHVh00ow6iQcfFFP7GeYj02417N+pgNeqgG3Vg1clGHWxGHaAadRCMOpBm0wFc" & _
        "V3R01kT2ILjBPVocWyZYgdJoAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiShield()
    ; 🛡️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAk1BMVEVHcEzM1t3M1t3M1t3M1t3M1t3M1t3M1t3M1t3M1t3M1t3M" & _
        "1t3M1t3M1t3M1t3M1t3M1t0tbZ1cr+2fxuOMrMRikLOCvOhNgqpVrO6iusyuzOFzt+oiZplrtOtCe6Z3nruRweaJvudsl7fF097B" & _
        "z9mswdC2zuCYxORksew3dKK3yNW90d9Xia56uemCpb+Xs8inyeL68RH8AAAAEHRSTlMAgI+/YDDPQJ8Q368g71BwOmdwowAAAl5J" & _
        "REFUeF7t1tly6yAMBmDsgA12nOIl+750X9//6Q6MqwkwWIlpLnpm+l/m4hshCWLSFZZGUT5IJEQmgzy6Sxm5PiKNcgA8SfIoFZcR" & _
        "yg0D0ThFMBa7CI7FzK9kFnBc1LvJcjnTWelMp+NtMz9ZVuZagpq1PNT7FoCsjJTTQ3Nv1kVNKD0jOzD8EGjbM5Ya0F2rfE0qABAI" & _
        "sPFnC90ZEFfKAhQMcq25grgBDRQER0IhN1MFDQxIqlQhUClVzs5Qj3sWAq30OgytoS3CIN2k1BpaHQY11tgiBe3CoK2CIgLJFTQJ" & _
        "g8YKypHpIxA2/+RnUGKt0SwMWkmV3wnBYr+GQi+w2rDYQRCs9n8M/UHip3skfu9dKxT0FAY9K6e42cN2s6f29o8/VdBXGPSpIEog" & _
        "7MIiXVgjduP/fhjbewj05nyNxAp6DIE+FBQb0AhvEt6iESjQpHV/aGO1SCdHz4aeLLcgip4NPRm1ICGx64ZcNHiMrLPVfaEGvmnd" & _
        "T/anftAzfK5byZCSkIIy4oYiJSEFQaudkhZ9oDkU5Cvp/XrozVsQ3NxjdS1Unoz7aofJrvet60WTjHgTa2l/HXTQTkz8EUnHfnfs" & _
        "dCJIR1ih27S+DG10gwpGOkOlV/I6khIksVfyOjFBw32Sz+EAoJKcdENj6Ti4VFd+qGw8DtYn+bD2QZt7iffHnZ3OY+VC5YeUzrzw" & _
        "sEzqHCc2ND5JnYyRqyN4W9RrS7XMS/sbF6RPRtk3ta80VB6+mWxEekZERUsd6+W0ObVMEQnSP0MunfAhAOFUOAMHzFolg0OFZ8SL" & _
        "gl9u8T92AGF17KClGwAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiVisible()
    ; 👁️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAwFBMVEVHcEzh6O3h6O3h6O3h6O3h6O3h6O3h6O3h6O3h6O3h6O3h" & _
        "6O3h6O3h6O3h6O3h6O2ImaYpLzPv8/b1+Pr09/nn7PBwf4m/ydGqt8Dx9fjp7vLw9Pfl6+/s8fSPn6vi6e7h6O01PECCkp/q7/PF" & _
        "ztWjsbt8jJjn7fE7Q0nCxsicq7axvcZkcXu4w8vN1NqorrHb4OVZZG1cYWVDSExqeIJPVVhpbnFNV15BSlDS2eAvNjqerbhTXWV2" & _
        "hZCWpbHh5urrANQpAAAAEHRSTlMAIBCAMGDP70C/34+vn3BQ8J8JlQAAAt9JREFUeF7tmNeS4yAQRa3xWJbjNCg65zQxh83//1fb" & _
        "wMiAW9ZuuXj0fXPVqUv3JQhcMXTWWZdB8D/QZSlw0fWnQs1WCee1FORXvWM21fp0r7Z3BOpMtVoXheX6U1P1WhF0VbehoMBHIjHv" & _
        "hRHvT+R4FKpJgz6PBCStaoU+w16oFC0E1Cn02UQ5FCsn6tMPtfiEQlfChxvQSDhdWhH6tg+qNzmEvLrtg+IiJzPxlvIhkG8aNYiP" & _
        "qqltNCbyQYBCVTugDYE2CAXWWL2QaGjV3ZxOJxFhIkygmSMB+oxCqoFZUk02RjUyJqWtxqKKjZKaqnuq4T5KzyiIllTTU88LIb5P" & _
        "qYpMFBYq3o/WzguimuRLt2nOBh3NkwtNV020wADyzvgRJkKjbh51dATqIXSFTNdi6DJpCKOO1RmNu6W6jw2ATu5X+4ujUF8lWf/q" & _
        "/j4bA8D1XXxYdqDb58sVoFZLfpikYgZh+O035LozqYkMKVDtp+OcGacHSQZfzI0A5sn4Txgu4dpwimX/VRERzwS0TlZxyFPIuD2a" & _
        "Yu6QSLaMPQqD1HRayLQ7IkfhcztjM9l7Bpk1WlUYxY+IfDDG3qQ//srMtJtyV49SLPkToWcJ4a/UTLshmD7m85OhXiRzPwd4NHdJ" & _
        "peJj2ZgP+uRGD5gT16Mpo28ACZPaCeb9A+DGNkK3FPuSjOr/7RZgaZWNRjeqMdTsYbd7Z2wOY3P+PWH0A2CmoBeEntkMYGWN1pDM" & _
        "d2bqFSDOITm1CAKsmaU1QIGRzTxhSNQosaHErVF5a8lpramwtUrC1iJh6+nXKpl+LTL9ekHmmpUvSKVPsiCNLaK0/VW+RZTPnGyR" & _
        "/aZ93cpynhAp27QSwr7IprWOkQSrgX8dI8kaGXKMODvYXB21zg5/Z58jZx9IV59sZ5cIZ9caVxctZ1c/V5dRZ9djVxd2Z08Id48a" & _
        "4jQcnPrMOv3h19MPPzdPUVePY0fPddd/IJx11l/gOBfaR45jVQAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiHidden()
    ; 👁️‍🗨️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAV1BMVEVHcEwxNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0x" & _
        "Nz0xNz0xNz0xNz0xNz0xNz3y8/P////Y2tuYm55laW4+REmlqKrMzc9xdnpLUFVYXWGytLbdKaogAAAAEHRSTlMAgEDP378g7zAQ" & _
        "n2CvcI9QYpGcMQAAAa1JREFUeNrtl0mSgzAMRQ2YwWCCmDPd/5w9FBXT/k4ARYss+m1TeSXJlpDVP+8R12VKC2lZxzxLZXPyyG11" & _
        "1JKViwVcZXYkpZRekMZ7o7G0gd0VVUQ7iDY1haZd6OJAOPygTEoHSA0vLSQpnnhyAi7zufvlPF8IyIOmBjzT0HYr2mECU4Oeinyc" & _
        "xqnIp9rM69p3AforZLfhubVdkPb20mR0wLPTpI1yJH5ezoMmP7vEeU7k0Xcv6MnjpBZiOK/134bxm2GthrOLnxRoap1mpIXRqdop" & _
        "XKboeUD3aaW/u5CCDZyRT/vw0B8eppZ8fiZdCf0FVYUzgL4rlTJgn7uFkTzGbmEmH6Nq8ukhIPjpTD61wlmGJcVjwCmnCMDMMDcC" & _
        "UDR9loifmlixxY5f7EJKtYhY00qNEbHBJjVqpYa/1OdI7AMp+cmWXyL4a43UoiW6+qEpoUPoQmo9llnYtcQTwo0OiaBOvGcWopkP" & _
        "P6TiPUWRhPk4RmLecz0JVImFsYEq8aih2QxPhN1oFRPjX9dGcSlSSI5Lo+Eycak0tByX2DqTeo+sTkDEd1lNFKkP5QtSiM1e2cy8" & _
        "iwAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiStats()
    ; 📊
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAARVBMVEVHcEzh6O3h6O3h6O3h6O3h6O3h6O3M1t3X3+XR2+Hh6O1q" & _
        "mk+pwKqfwdzg5+xNnNo7lNndLkRckTvRoq3bQ1fN197Q2eBxOmesAAAAB3RSTlMAYO8QIM+/iPzB7wAAAPZJREFUeF7t2LuOgzAQ" & _
        "heFAAuML90ve/1FXY7GMURoyx9IiL3/n5itGcnMeV62onbK6iJhX5YCq1+6UDqr8lSoHVm33YaAzlrYYIO7E25qOpSJANTtvIg1E" & _
        "9GapDhCThrQQGYbZeTJk9ZA9QKSH1gBxIES5QG0/hPoWg9phr4WgXqAegoaoT+iLYshJmUP4sf8cuqHGTyHfYFAz7TUQ5AXyEDRF" & _
        "ZQFJMQT8/swg/Nj/HpqXMbTMGDSPezMELQItEDRGAdANnfm0MQT8/gygNMe+oRuyesgeIKOHTIBkQFBCMiDIpKGAVpk00owsiWcf" & _
        "fIhKNY1dtB+3F8T/isWgqQAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiChartUp()
    ; 📈
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAb1BMVEVHcEzh6O3h6O3h6O3h6O3h6O3h6O3M1t3h6O3dLkTOwcrS" & _
        "l6TbQ1fNzNPeRVnXbX3Roq3ZWGrgrrjh3OLX3+XR2+HgusPcOU7fi5nh0djVgpHgoq7g5+zdOk/fdIPeaHnQ2eDYY3TeXW7QrLfN" & _
        "196Tx1eoAAAAB3RSTlMAYO8QIM+/iPzB7wAAAhBJREFUeF7N2NluwjAUBFBCIV6yb+w7/f9vrEzs+CaXWnYuD8wbVXQyUuuh8uJb" & _
        "E8V8ZuIIMKs1J2S9GpwlJ2VppPl9mqbv1DuRAk5tx3QUwHScn8tUiLxWUvSCYuXcGAuFSvGKkuIXpMiWhUNpD+UKVs6Pgrpw6CB0" & _
        "RhALhrKtgRoNLeZAoFDKKRAolJAgUIiRIGkL0aDCFiJBe2HypEEX41QMQoGBhTZKmQ9djfPgJGhjC9Ggh3Gumpl5RGwhyVRmQ0Oh" & _
        "gpGgpy1Eg1JbiAQlxtlKAgQLHRgBgoUyEgQLkaCDLUSCsi0q5IbqVIi0RBAcWC+o1is6geDiv4WmaXLd/8jH2Rkn5yBjCD+Ppf0Z" & _
        "/dwJNfp5JF1QIQzhQljCA8udeyTFKMmwBgUYWObxWyvERNKQtIW8ICmmOfbQ3RbygirxToJ7tvGA9PNYAi+4cxeEC1UJlODAekEl" & _
        "GGQoJZUdWC8IDrKScKQXlIBCSNKFfKBssn9Y2koPCMzNOUMVzQs8IDA3OzT2ZmCdEJ6bhg85QmjH3wRB+8l4YOnceEB4brC0404I" & _
        "Fao5ktALHHtU/Xu6jVSaz84Zwacbfz15QPC0BnxhYgieVhIETysJAqeVBoHTSoPsYSJCtlAw1I2gvHfSLBxqByjmwz8yJQuGbqfh" & _
        "AiHiSsr1324Q9Nu1yuGRuWQhZv3hax/6RdSnrsa+NH++RJUePREKqAAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiChartDown()
    ; 📉
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAb1BMVEVHcEzh6O3h6O3h6O3h6O3h6O3h6O3M1t07lNnh6O3D0t26" & _
        "zt1NnNqWvdxQn9xxrdufwdzX3+XR2+FfpdqOvuOjyeaEtdvX4+ytzudEmNng5+y40+hFmdpvrt/Q2eBoqdplqd6oxtx5tOHN197M" & _
        "3usNTMi4AAAAB3RSTlMAYO8QIM+/iPzB7wAAAg9JREFUeF7N2MmS4jAQBNAxA9bmlX2nl/n/b5woQFVy4W5JFAfy1gdepMM4TevP" & _
        "u6YozZMpi4CZzowgsyk6EyPKxEszI8zs5hQAbButq05BAFA+kb/n/R6k4gqV4OhrumQIcwapvEJANjeostmQ6gEG5y9A+p51PjQf" & _
        "hXY2G/oGCC+twkrZkBpAtfZxMkhhpVYIdVRJBqmFhxajkLWp0CdWOjxC2wq/91GIKn08QCv83scgyD+stDVh0NGNGQ2HzJeHGu74" & _
        "LGMQr7Qad/RxkwSZJVbaMAcrRSEFsTv8gPKpdZidjd81yBqvwTLHZ50GWXp2mYOVXAziBZx3WNo0KHh20WFxaVBHlQZOvcBKSVD4" & _
        "7IbOKngUXRpEHwidcB0uUYgqcYetQxrkxhxocMF1SINUy5z63thRpTTIMQf3p8VKP0EsS3ZdtA5UiWUc2hyZExksBvFK5FClI/pp" & _
        "0KZhzuNg/bJHFPyRU/Oxp8GqI3ct8vqhwaoiUOyFSJXWqRCHeaWdlUGKNlQI1VRJALFKMogqOQHEZl0EhaMrg9QHVhJCB6rEoNxg" & _
        "pZOBPA9RpYMMMiccXRHER/fpuxaO7kJy1waVPmWQaXHhhJCj0ZVBwegKIUuVZFBQSQhRpQE0z4WwEoP6fEhVwVsXDxD253yoo/+l" & _
        "SjrS2PfzPAikSusGHFO86pDlxcc+8oOoVx2NvWn+A8oxmWCM9XrhAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiTime()
    ; ⏱️
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiTarget()
    ; 🎯
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiGold()
    ; 💰
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiPerformance()
    ; ⚡
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiBot()
    ; 🤖
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAwFBMVEVHcEw7iMP0kAwiZpn/zE07iMNVrO70kAz6ry//zE30kAz/" & _
        "rDP0kAxVrO70kAwiZpk7iMMzfbUiZplVrO47iMP/zE3/zE3/zE3/zE3/zE3/zE3/zE3/zE3/zE3/zE07iMM7iMP1+PrM1t1FltPF" & _
        "096Rwea2zuBcr+0+jcj0kAxVrO74pyRgse+f0PXul6L/rDP///8iZpnysbn8uDeKxvPf7/zfO1D98vP0+v7/zE2Vy/T1lhLdLkT6" & _
        "ri39wUH3nxwSPdbFAAAAIHRSTlMA34Dv71DfUBAw74DPUN+AJRDPEJ/PgCCPYN+vv59wQB8B+fAAAAHsSURBVHja7dXZdoIwEAZg" & _
        "rPu+1H1rWteIivuuff+3aojawWISwOlpL/yvcjKTjwQENUmizUa9ur2kWm80o5r7RCq1wNaWQK0SccWUymflND/qnzz6cX46W+WS" & _
        "890U+ZK5vqc32etzXig63FW0wBlQrBanClFHDj+VTgXR+fmUUto/dRh/WsJkc1MXyUn2M3UV8Z787iC/EJq6zC9DydDAdULJO87A" & _
        "U+xSyBsU+um8DjwGG4KgQHHDMLxCbGn8GzIegwwBNBwtJyzL0RDm7BU1tNhMLtksoN9esUPhlBXaTSzZgWKvAJQKc4dSC7Qwu9az" & _
        "8Xi2NkdwZXsFIEqZFIlZoaG5+9nqwLKamWdgd0NcASgW0V6oFRqZ3YdLzP4RmxRWAKIvWuIGWrLdr67tK3aGJZsUVwBKaPQGul4W" & _
        "LswmxRWAqB0aQ/sYIFEFH0I7GtrNRnv8aD9IrFcE66XF/Izgf9hcByC0jz/a39ET+muo037n+WARj9odBdTrwiL5qNuTQh1oVY06" & _
        "UqjtHGrLoB60qkfYEP7R8G82j/PHj/WDfL793qCgj9xP63ZNS9DmC14cIkxL6kDOko/IJbVDfKaTJbK0wJEFILEEjgLSiEICRw69" & _
        "EZWkdkiGQRmiSr9P1BALQYhmJv+4k9f+Yb4AyFWW7aIiG90AAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiAIActive()
    ; 🧠
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAwFBMVEVHcEz0q7r0q7r0q7r0q7r0q7r0q7r0q7r0q7r0q7r0q7r0" & _
        "q7r0q7r0q7r0q7r0q7rqWW7eMEfdLkTqWW7qWW7qWW7qWW7qWW7nTmToXHDdLkTqWW7qWW7wmKjqWW7dLkTqWW7yl6fvgpTzprXt" & _
        "boHrXnPsaHzrY3j0q7rwjJ7wh5nxkaLtc4bynKzueIvzobHufY/kS2HhPFLfNUrnTmTpbX/kRFndLkTpVGrwlKTnZXjujJ3xm6vq" & _
        "dIbmXXDkVWnroXLVAAAAIHRSTlMAUICPnyC/70AQMM+v33BgMEAQgO/fv89An8+PYM9wj9ON+l8AAAPCSURBVHhe7ZfXdts4EIbV" & _
        "LEpyT3ZTtg462CWX9Oy+/1utSAL8AdF0FHsv/V3h+Bx/mBkMBtTkEV54YbNqWT/HsZotE9uznE+fottcnFkQ6X7CMl2c23GS2XGB" & _
        "ncyRz5jq8gjNwglKxmoIuqUopKxSsV8tfqBZz93/VYr2aO/ZEm8WjBoUb0yPprdypUkVdTiPoE5kM85ls4GwNpmPqy6s8zS71tay" & _
        "0okyIoEsCxdqMnZ+fXWIdG1DtiRtACdK28X8wfL0fcPICBshqYrEFbFugZqDoP9KYWM4IjrgYiwvIBjWaV/2oohFyclInUERpFMT" & _
        "5d2KqGBpCtFhcps+CY4Ck+HaVVV7a0UNpQWrSHSKAwsq2pA5q3F+TUQyqmHYBDMcGERCkalSv4GPwtDWG3IuDsq0TgKRCCqMbiJi" & _
        "WDgkqda+DAPCXWCoNk4IEQWilJxphYB6FGV+abBkRRSRhynS4cldwoMwwr231LDFToipPdUk7mlcT58N7IYbkv1OQJJEbmsvwcDA" & _
        "AaLJ3ZjLcWpo+W5gTg/uo5KyEG0313aMUnK/G6bAPBLl1MBQIwBSRSoKu22lZSQyRBVv66mRRESdGSLF/La4cec2SD5tryeuhUOk" & _
        "laY9RkpqkKUrhDuCpBm77R8qrtrjyDB5ysaJpwCoiqFFMly4bkz4LmUiOFvdCqs2Bp4zxjjneWlBoV2zzFxqXBPGT3C2FZeG3FMQ" & _
        "UPLOBs76YnMyUUELQx7DhY2RxG3Msr+yNVEaPDgOLStsDrakbcwCDSlJ1XgeVcEZDIcwwo1DjSZJF4YiU/rpkIlDgai2FjQlzZkF" & _
        "G9/aeF9TPI8HQSDCjFoQ1Xn3AZL044VIdy/7EENbZ8olkc40UY7M4gkp2sZTYuR6obWD8Z9nEAXXTWyDq5qhtZihAJ3aaJjjJVmf" & _
        "YorosBJpljNh64qa4oqasYxrkvGwqNtae9MCrRZEBwwbfgfgGiUTMO2GAFf+bErdZtF/oyGGLP7AGbzblz4/31ZUNVLB9PAa4gZI" & _
        "N9ciTi7OEuylcr/EvB8MUz36ZepNgnuPFbmwAGSkuJ9qQ2b2eEp8jzzA6aiA399//zywJfDEbBILwOd/bj823P4by5Yo9BGmb/c3" & _
        "HwNud/dfv3Wa6eQRTuIH6usXZ7nZfSK6231w0t3u/Ug0w5Y6/fPLzodx84nA3d2HPdeTH7PufjW++s1nc0cD3k5+gld/I5xD3kFw" & _
        "lOr6+vrdLzTk9eQJ/EED3k+exNWvz4wH/BWq3lxNnsHV6zdtrd7+Ds3/ywsv/AfIZrOiTyoODAAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiSettings()
    ; ⚙️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAMFBMVEVHcExmdX9mdX9mdX9mdX9mdX9mdX9mdX9mdX9mdX9mdX9m" & _
        "dX9mdX9mdX9mdX9mdX94+S8fAAAAEHRSTlMAUN//EEAggO8wn2CvcM+PW+dFPQAAAWJJREFUeNrtmMGWgyAMRYEgxKLy/3874ywa" & _
        "KEZan5zZ9G7l3AUxIYnpYB394ayBsPQEMzkROcTjqeA+EcL/i6bwrihMRicykZvfEc2OiKPmedAOz33RzLTz0D21yVsqsL70iEnx" & _
        "iCkt9MKSxKOaIlFp8pHpAI5+9wjtPXF1fq01+idu4k4XmUxNoIuENs8v4cQgIb0AzwY2iQc3iadv2rKdfrF50z19E+dQxDVzzyOs" & _
        "dUZ4U+HrnFl1j2cSOJmGVB3wqih+FpCoivizgLDmSSQk5NBS3LNR6Z/y2j3qEfG9dz6bE7LSD1jXrw16xZFexVLLZk7ZqMUe1qF8" & _
        "LsqHdYkO9adYOsCodVhn+oquXfZt4b/th7wrRdCkRcpIUMsIXtjwUju2+OPPEf5A4k/2uCYCb2vwRmtU64c3o3h7PKZhx0cIfKgZ" & _
        "Mmbhgx8+io4bjvFxHV8g4CuNrwhbjeHLOnx9+AO4/SLPhJJxTAAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiGameMode()
    ; 🎮
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiBotMaintenance()
    ; 🛠️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAjVBMVEVHcEyImaaImaaImaaImaZmdX9mdX+ImaaImaZmdX/0kAyI" & _
        "mab0kAyImaZmdX+ImaaImaaImab0kAxmdX9mdX9mdX9mdX9mdX9mdX+Imab0kAyImaaImaZmdX/0kAxmdX9mdX9mdX/0kAz0kAz0" & _
        "kAyTmJdmdX/0kAyImaZmdX/0kAzgkim/hjePmJzMk0bf6kn5AAAAKHRSTlMAQIDvz+8wnxCfECCfYL+P37+A32CAj0DPUM8wr1Dv" & _
        "cBCvUGBwnyAguBawEwAAAiJJREFUeNrd1+uSmkAQhuFvQARBDp511dXd7CbD5nD/lxedStkjkPm2zb+8F/AUzTQ1BUKNV1XSXkuq" & _
        "1QZSmTbW2niHz7VctH7J+oxrWRTbP2UA7+iYu064ZBp7qwDt/NJjkmoMoLRSCtp46xOTzRkuvZN4TPUVrn911pCK+HFnCa/0cecE" & _
        "r+Jxp4JffXMapdNu4CcbVCudBf4yWYT7iizotC/wMwIdgM4h7EJOu4JfJFCcdRwbDzkcslFvKUJOu+5C0r7j2IDTPf2dD8V7cVwh" & _
        "p01yeO3tXVHmOw2ubcbi+P14ynvvQooPUd34qz5eXIYYdD4+RBJnsFJmGnJEIk5MHCdxx63DNuCIRJwmA4jjJOZYA4A4TnonTolL" & _
        "666xWK+2zpG+/+QOMLnfwRMuTQWhUuycnrQBdFJaAEPSBBqpqYXpSAk+I6X7XRRFRpS+tEVA4neISEcwyTlUWgJEcg6ROg7SX0NS" & _
        "CtKyqo7du6EvicMTZ0B6f8zpS0+53iGSyuESd4ikd7jEHS5xh0t6h0vckdJpQNI4QEBSOURSOERSOFziDpHUDpe4wyXuMEnjcIk7" & _
        "SqkOOBrJBByVNLOumDhUyuy1UYFiRBwimdsPTxZ7jkaaCjSTIfsOl77doBGujcTRSW/yjkoApThKae4NdIhScTSSQIadO5fe4KqJ" & _
        "Q6XnHF2pBh6QvshXMnPMzEDV/Nk9z8WRMmNMBm3563z+muO/7je+6nfRvPo7kwAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiPosition()
    ; 📍
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAdVBMVEVHcEzdLkTdLkTdLkTdLkTdLkTdLkTdLkTdLkTdLkTYN0yZ" & _
        "qrWmk6C7bH3MTWCZqrWZqrWZqrWZqrWZqrWZqrWZqrWZqrWZqrWZqrWZqrWZqrWZqrUpLzMpLzMpLzMpLzNaZWwpLzMpLzM+Rksp" & _
        "LzOSoq1vfISBw8GTAAAAJXRSTlMAMIC//2DPIFDv31D///9A/yDfv6+AcDDvj2DPYJ/P//9Q3//vLAM7jgAAAU1JREFUeAHs1TUC" & _
        "xSAQBNCBHYjL/S/7rYnbFFv91yfAKs6FaPyxGKBLmTM5QVMYV6yAoKy4UZXCs7gr4aGSB8qH8al4oHoWJ+Mh0wNEPUyZJzJuCzwV" & _
        "cFfkqaiGWg83L/j/6P8jp/QLBenQIkrTCmOk9B9s+qjVh7/POhIWpLCyNanmTJ0ga9qu50/ftQ10w/gupT5MLIaBIAxvB1or2O85" & _
        "ybn/Es+IgyEf3P8VMCDNsC4BBHUu3hngLkZE5UQjkoKSEVlB2YiioGJEr6DeiMBmJIOCBkPgjOTjvz7GJM2IyZoRUzQjpteMmKAZ" & _
        "MZ2uEaQZQVHXiElsRvL15mtUYTOSoPaZQUcEUvtQVPtMUvtMUWnM6K/RuKD2IZUGTe6TCTrb2ah5WevmvtV1mUHMftTX6X7W17Hb" & _
        "f121ue/aXDToeWBQe5ocO/zs5s/P/gEcTCzGH83q4QAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiPC()
    ; 🖥️
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiNetwork()
    ; 🌐
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAM1BMVEVHcEw7iMM7iMM7iMM7iMM7iMM7iMM7iMM7iMM7iMM7iMM7" & _
        "iMM7iMM7iMM7iMM7iMM7iMMRH0i/AAAAEHRSTlMAgL8Q32AgQO+fj1CvzzBw4ZaNVwAAAg5JREFUeF7lmMtyhiAMhaPcUX59/6ft" & _
        "AOoBp6At6apZZQb4cggRAeqYVn6W+2Fy9krTL2xxFwMm3fIzivZ2b5j173WZde/aat6pcZUAt0Vnc5VE90LVVI6QShBFh0goWfKn" & _
        "JzmhDDwJohNEJKayLXRFLaUca4gAimaq5s4CHiGDTJwP3UH0SSR5yG5Oz+VI2wYOQCVp27I01+OEj7bgAFSSrP6ETGpznKA5Ooq+" & _
        "B5GKgJmEa5GmzDl6rtQC0XrEcd/nabkCyKhdtEEiTk5eU7itnbYnR+WATRB6ZJKt6ylkziFIUgeELpkU6gQN2FRNbMCKybkBTFkD" & _
        "Zh80U1WGiSZzDbWTjRHzIQIjdPLhqi4IFZBTM8P1SR06iGeQSAEhySfXXjrJwe2Bsg4H114fh0KpTW9AE8pWnR+KS0QoNm9ApsiB" & _
        "LT5SVzf3QfeQLqvThzIIfgQhCdg4dLVQHrlug5BiXy2hhwq09kGICXU+odcCNL0DTRmEOq9WHOnqgZCYqhbyBAEy70AGoJxmDP4d" & _
        "CP7OYP8B9Jxsc7ctAkqfbfnZCpLtE2H7aNm2EbaNjWurZdv82X5HXD9Itl827yGCVkgK7481AYJWtoMW19GP7TDKdTxuH9hDf4eM" & _
        "+mV00qjAdoXgutRwXbO4Ln5cV1HGyzH/dZ3/AeH5ScPXTxpMjyxczz5cD1H8T2P8j3Vsz4dfTyiMV5arauoAAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiServer()
    ; 📡
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAwFBMVEVHcEz/rDP/rDNmdX9mdX//rDP/rDOIlqD/rDPM1t1mdX9o" & _
        "d4FmdX//rDP/rDNmdX9mdX//rDPL1dzM1t3/rDNmdX//rDPM1t3M1t1mdX+ZqrSZqbP/rDPM1t1mdX/M1t3/rDPM1t1mdX//rDPM" & _
        "1t3M1t2ZqrXM1t3/rDP/rDOZqrWZqrWntL2DkZqAkJrM1t1mdX+ZqrWms7t9i5Wuu8OXpq+erbdreoWMmaKOnqjEz9eEk52+ytFz" & _
        "goy4xMv/rDPkKcXuAAAAL3RSTlMAz5/vQr9AEBCAIGWAMICfv++kIGDPIMYw3+oyUECPcK9cMHCP31vvj9+vgK/fgOZC9L8AAAL4" & _
        "SURBVHhexZfpfqpADEdRUMRd1Kq1Vnvb3rZ3C+vi2vd/qysEhjLMxFI/9DzA+SX/JIMq30GvHzPpXeu5e08Z1ZtXiRrvOY1rVPX3" & _
        "j2xaXxa1NrXGmcz0dn1WWWkT5Vpu6hdNncHwzKDzQ6FpjkiTtrAy1IHGC/rngF4nacatWrII4pw6VoFFp1hENq7mB9ObaHZL1bII" & _
        "1WO+RDe56bXs0W+tMgstT3jETKO7xJTkdFMSGa4lYthmpsd+vZZNnt1MnfeMwRKjdkSTT2raiEoywZIx1AtvAM6rFVtj0SNfEFhS" & _
        "VJYUpsxaip0NLiEUyeiWTb1skkXRM4BLmQa6sjJMY4zdYUnpbhVWaQ4AkUUxNSHmib0oo1gZiwpP0xoAAlIUAPLAtrwpEpkAcKA8" & _
        "IaQ8KzHxLvbTHgv3NgOgQ3IhA59dDGlSChtigs+L+vHccWq1smhHiBzWGhNt4kXAu2OsICEiPcg6u2AMuddSBKLDZY+jp0vZZDcm" & _
        "EEFEejzPca2hQjEHqiSn0Pg9aYKULelBOp8R7ULKg6jUJ2YGKR7pQaaE6Aky9qTnYkwPkDdHehBNKhoDwyM9yIIKibElPUhXKlpD" & _
        "jkt5ELUtE+mQszsmHp/a9oEiw4ScUxI4fchtIm4ucOa5oiRwMCL0VC3phTdFvkt+6mQYwJko6F2qZpLf7vyliom+uAJeSGjoR8CE" & _
        "AifaRIiWOyhwcL8W0vI24Ey7iBBpco9tB8DhhJVF+q19xgGOk1tV9MtOcHbA4VfL6KedwUx05irRGBIcgMc7fvr+f9sfOEEJh1ep" & _
        "Ol0Q4kAZb1/w0AkxghOUOQQsrL9LcmSIZHrIyfN93zN1RYItwNuBmNlKfhy2EO8AZUzUEBGJCDjXbD1WKP5tbTnOH8MwZk+G8TBX" & _
        "LtG1jnuJxt+HXYWE/18cupFfthz532g0bQs5uvtouz37/O12vz+Gok8YzT35yldAn0o9U12pZBrI//JVRBsKNENN+QLtbrHBaZeM" & _
        "mUbrdBFNU76F/6dW+fp/DGDyAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiMemory()
    ; 💾
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAS1BMVEVHcEwxNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz0xNz1V" & _
        "rO7h6O1+hIpTpePL0tdRndjW3eKUm6A/Y39BaoozPkhzeX+fpqs8Qkhju1jkAAAACnRSTlMAQO+AUBC/359gaxWCaQAAAMJJREFU" & _
        "eF7t2MsKhDAMhtGoram/97m//5OOmykVLBgNzMDk22VzIKtAaMlXjGNxQ0muxPGCj06BU4UIMXSkZgO4dLt6rqR6A+p29kolCCDE" & _
        "1nPQghC0IAQtCE4LYi0IBhmUZpBBO8pD8nN0yUDy/hC6Da2g4ZaDrq2wawaapNCUgVpx95+DMqt14r4AGWSQQQYZZJBBo9QZVxDH" & _
        "oZdCj8SpqUKsnyXM3COpIV9CISYiB4UKWioYJyvd5z1W40RceSJ6A3RD2qmpnYlRAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiTools()
    ; 🔧
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiCPU()
    ; ⚡
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAMFBMVEVHcEz/rDP/rDP/rDP/rDP/rDP/rDP/rDP/rDP/rDP/rDP/" & _
        "rDP/rDP/rDP/rDP/rDNIzNElAAAAD3RSTlMA7xBgnzDPgCDfj0C/r3DHfpOdAAABLklEQVR42q2XSxLDIAzFbCCBJml9/9v2s3kb" & _
        "dwGKDsBoRvXL1OY5IrpxyjM+GKbs8aUYZPP40gxyevwYxqgRTEi57hAqLSSEc3GhTe80nv2HD5RLkPPoIbzYMi1uESpX3CI09sBC" & _
        "ysWFqgcTUnYupFziBUY1QjzYlYoKcmGh0wMLKRcXOiKhglEFQsqFhbb8nYtlF+d0rln6n1GdJ7/SBdJRXeDIRnWBmuWax2s2qvP4" & _
        "RrKLfSRXusCVLHgs0MzAQ/QXzcfg/JtrkivPtZHtFnuxWR5prmJMSFcKhG7/uvlpTEjZsZBycaHn2juv5EpXKI5yiZ6MKhFSLiak" & _
        "UWVCGlUmpFxUiP9DQ9nFcJRLNOVC7wx2paIlo4qEDmM05UIMjSqjKTuiKBdEowrpS7neXD5UXwGvjogAAAAASUVORK5CYII=")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiList()
    ; 📋
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiCards()
    ; 📇
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiSearch()
    ; 🔍
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAolBMVEVHcEyImaaImaaImaaImaaImaaImaZmdX9mdX+ImaaImaaI" & _
        "maaImaaImaaImaZmdX9mdX+ImaZmdX9mdX+aqrSImaZmdX9mdX+TpK9mdX+ImaZmdX9mdX9mdX+Imaa73fWuzOGiu86SprWx0Oao" & _
        "xNeVqrqet8mLnau42fCOorCaqrSlv9K11eubs8SYrr9mdX+Roq2JmqeTpK+QoKppeIKPn6tleVTkAAAAHnRSTlMA788wvyAQ7zCA" & _
        "n2BA36+fz1Agv2CPj9+AEHCvYEDbxs89AAACRklEQVR4Xs3X95KbMBDAYWEwPsC4+2qyohe3K0ne/9Xi88AsuUG7UqI/8nuAb9ao" & _
        "gIVe03UQep8tgsgVf5u7j2GYs4h8YV6ECuaEU1PGAUVGlDsBdU6g7QRA5+kN5S+Ay3F1nAloFJk67SVNPjtWmaE0dOpzLrGmaIeS" & _
        "SzshYGkjv5QMKId84hEy5UmOlKI0IZwpbsNKjpfX0EfsJ1z4QkpC4n7cHPqOCBBSqIK83jlLqhz6FCO5vdM2kizFkeilTyRT1kv+" & _
        "KNQvWSm5EnJ/r7UHwpEWY9C+czLJV0AXdcqOkq/pofkIBF251KjsoGdi8SXG74C9eluXEuMfkqdYNG0oQUh146f/HVSZQcTDtgVl" & _
        "WtBRfUamRvuoIq5bB88sX0scf8/gaZ/w7aZettrghMTkTVuwTlOTd23cQa32QLCmP4uOugPFYjS/h+qchi7cuzbspazR2Yzg+MSr" & _
        "n5cKjZd/ACjxTuzrfGZlOXE28OJX9fgOffXY2uUZOnvC2R0+AGuLL8zpDNx31tP9drvc7A6HwxsMqSpBpShh6Iyu2N3D67XZj8O1" & _
        "X/Bn5SVN06psATSc2eutnzfpDah4B6WPd85ZkA5KjxPaeRaUg9JOiMCh/tKQDkq722kJFUy8FqSDze66gxfEIw9nLjgHW+KdGXiA" & _
        "xWHkC97BHsQwdx4F1+Y4CuNgK0HEO9jSkjPbGDpPCudOGLa15Hy35IilJUesLDnCliNsOWJryRH3lhyxseLgSLzDt+Ic85lWtMO3" & _
        "WV6nmr18+xfjNwIbZG8aSnjVAAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiDropdown()
    ; 🔽
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABIBAMAAACnw650AAAAJ1BMVEVHcEw7iMM7iMM7iMM7iMM7iMM7iMPn8Pj////z+PuFtdqd" & _
        "xOFHj8cIJBZSAAAAB3RSTlMAYL//IM/vVZgOvgAAAPBJREFUeAFiYGAQMsYLFBmAwNWYAAhhYGBJJqTIzIGB1ZggCGAQJqzIkEGZ" & _
        "sCIjBmMiAA0UjSoClFuHxhFFIRhGi0IwQ2WUkJ208ArAvxLSWPw9V+AXfcTn+Pvncp8DzQ39Hihv6DlQ3dB7hrfm83eiuSWdKEUP" & _
        "qEQvKNok0ZgkSpNEZZIo2iTRmCRKk0RlkijaJNGYJEqTRGWSKNok0ZgkSpNEZZIo2iTRmCRKk0RlkijaJNGYJEqTRGWSKNok0Zgk" & _
        "SpNEZZIo2iTRmCRKk0RlkiiapBANSSHKZ4Hq/bLPuRo0q2m0GlmrubYafqsJ+Q/ReLNhJ04RTAAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiArrowRight()
    ; ➡️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAP1BMVEVHcEw7iMM7iMM7iMM7iMM7iMP///+Ftdo7iMPz+Pva6fRH" & _
        "j8e20ulgns6dxOHC2uxsptJUl8vO4fDn8Ph4rdb6HuEyAAAABnRSTlMAv+9gIM+kpfmZAAAA1UlEQVR4Xu3YW46DMBBEUTvG1X7y" & _
        "nP2vdUSi+eaDK40VUQs4EgI37XJngk834oP7ZIrpZuL0dl7pdl6nFBOQ6FxISILzDORdgvKV0ANVCioVgnR0CFL+gSDJKEiNgrRX" & _
        "CFLZIEi5Q5BkFKSZgtQqBKlUCNLRGejvvFxDuo5RkBoFaa8QpLJBkHKHIMkoSDMFqWHQWI+WjXr9Y32QSx3r0Bo02FZq1I41/NtY" & _
        "P8hs1BIx1lqz1LFWP4PW4/UfFnbkCgHkgR6IKlmw2ocqorBqjCvrsPrwFzyjmvPABXg5AAAAAElFTkSuQmCC")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiArrowLeft()
    ; ⬅️
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAP1BMVEVHcEw7iMM7iMM7iMM7iMM7iMP///9Hj8c7iMO20umFtdrz" & _
        "+Ptgns7a6fSdxOHn8Ph4rdZUl8vO4fDC2uxsptK23xy9AAAABnRSTlMAv+9gIM+kpfmZAAAA30lEQVR4Xu3YWwqDMBBG4UTNP7l6" & _
        "a/e/1mL7kMcWPCAUzwI+KDZxHHc0+ngiP7pPU4gnC9PbGeLphkMKESg4N0ak0XkG8i5C/TN0QwZB1hioLkKgtQiBsoRASQhkuxBo" & _
        "a0KgWoRAWUKgWQhkSQhkTQhUFyHQWoRAWd/7BUpCINuFQFsTAtUiBMoSAs1CIEtioAhA0E/r5SKxj//6P2TPHtLFh5a/RnrPIsFX" & _
        "7fWXfy8BEPeC7OeFHyKuH2v6eQFHP34Y5cdjfmDnPyGAbuiGqCULtvahFlHYaoxb1mHrwxdCRZri8W6IAQAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiNightMode()
    ; 🌙
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiDayMode()
    ; ☀️
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiTheme()
    ; 🎨
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiSoundOn()
    ; 🔊
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiSoundOff()
    ; 🔇
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiSleep()
    ; 💤
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiScheduled()
    ; ⏰
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiCalendar()
    ; 📅
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiClock()
    ; 🕐
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiHourglass()
    ; ⏳
    Local $bString = _WinAPI_Base64Decode( _
        "iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAXVBMVEVHcEz/6Lb/6Lb/6Lb/6LY7iMM7iMP/6Lb/6Lb/6Lb/6Lb/" & _
        "6Lb/6Lb/6Lb/6Lb/5K7/w2T/2ZX/sDv/v1z/tEM7iMP/u1T/zn3/t0z/0oX/xmz/ynX/1Y3/rDP/4aY+pSzXAAAADnRSTlMAcIBA" & _
        "MFDf788QIK/fvznR7JEAAAHBSURBVHhe7dhZcoMwDAZgYxKwWcSWdWnvf8zK00mdoEYWYvKW/wDfRJKFCeYp22IvTrE1L7PdL8pr" & _
        "qVgGFS+h/cK8C9KX9q5m68fPBjBffEbAmFQahA48dEDHJaFWBrUi6MJDF4TqJGQROvLQESGbhDKEBh4aEMqSUI5Qx0MdQnkS8oDZ" & _
        "cc4OMN6I5t9zUI9OY9KpEbpx0C0OLdntbkyc60wAVYDp+cqgMoI49ieNHVkQpjbmTB6FlWF8OSuOFFZ6I4oNUHf6zzl1AbJGFu8e" & _
        "Jeo4I82mjBJ1yo1ZKk3PzkQckUQ63kN0NBJ1VNJfn046J85ufDjQ4LwxWun8C52jo5V2wdlFR5Mq9OkaoCs6ZWXUsfebYIiLoUr+" & _
        "COUrIQjQ90rI3qG48+pmR0jfbO8gQiuPUYTWHewI6SVcWgLplz9CWilHh0LaBySFFI9sAmkk74CDwMkXg4Pky+JLFpJf2RmwkPwl" & _
        "wrGQvEsVzHII7/qzVMLKKKSorZZAtQBqJFCTdjzMcwl/Y+bxSSgnEF5sVwLly3sdLu0zLO+2JdDwe60t3ZIWSHBDSGoNNE0UauXT" & _
        "5+OSEAjDEJ/vR5/vR+rx/wBq/cBI2rwXpAAAAABJRU5ErkJggg==")
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc

Func _EmojiCompleted()
    ; ✔️
    Local $bString = _WinAPI_Base64Decode("") ; ADD BASE64 CODE HERE
    Return _GDIPlus_BitmapCreateFromMemory($bString)
EndFunc
