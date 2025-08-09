#RequireAdmin
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <WinAPIProc.au3>
#include <Memory.au3>
#include <Array.au3>
#include <Crypt.au3>
#include <GuiListView.au3>
#include <WinAPIFiles.au3>
#include <Math.au3>
#include <GuiScrollBars.au3>
#include <ScrollBarConstants.au3>
#include <GDIPlus.au3>
#include <GuiRichEdit.au3>
#include <StructureConstants.au3>
#include <GuiImageList.au3>
#include 'Tools/_GUICtrlEmoji/_GUICtrlEmoji.au3'

; --- Options ---
Opt("GUIOnEventMode", 1)
Opt("TCPTimeout", 5000)
Opt("GUIResizeMode", $GUI_DOCKALL)

; ===== CONSTANTS =====
; --- Colors & Theme ---
Global Const $COLOR_BACKGROUND2 = 0x363636
Global Const $COLOR_HEADER = 0x2C3E50
Global Const $COLOR_HEADER_TEXT = 0xFFFFFF
Global Const $COLOR_SUBTITLE = 0xBDC3C7
Global Const $COLOR_SUCCESS = 0x27AE60
Global Const $COLOR_WARNING = 0xF39C12
Global Const $COLOR_ERROR = 0xE74C3C
Global Const $COLOR_INFO = 0x3498DB
Global Const $COLOR_SECONDARY = 0x95A5A6
Global Const $COLOR_ACCENT = 0x9B59B6
Global Const $COLOR_CARD_BG = 0xFFFFFF
Global Const $COLOR_BORDER = 0xE0E0E0

; --- Shortcut Constants ---
Global Const $SHORTCUT_PREFIX = "Guild Wars ML-"
Global Const $AUTO_LAUNCH_SHORTCUT = "Guild Wars ML-X"
Global Const $AUTO_LAUNCH_SWITCH = "-auto"

; ===== GLOBAL VARIABLES =====
; --- Core Data Structures ---
Global $aAccounts[0][8] ; [email, password, character, path, pid, keepalive, botpath, botpid]
Global $aWindowTitleQueue[0][2] ; [PID, AccountIndex]
Global $aAvailableBots[0][2] ; [filename, full path]
Global $aBotSelection[0] ; Bot selection for each account
Global $aGWArguments[35][3] ; Guild Wars available arguments

; --- Configuration ---
Global $sAccountsFile = @ScriptDir & "\accounts.ini"
Global $sCryptKey = "GWLauncherAutoIt2024"

; --- State Variables ---
Global $g_i_ActiveAccounts = 0
Global $g_AnimationTimer = 0
Global $g_AnimationState = 0
Global $g_bUpdatingAccounts = False

; --- GUI Handles - Main Window ---
Global $hGUI
Global $lvAccounts
Global $progressBar
Global $g_h_LogText
Global $g_hAccountsImageList = 0

; --- GUI Handles - Labels ---
Global $lblActiveCount
Global $lblTotalCount
Global $lblStatusIndicator
Global $lblActivityText
Global $lblMemoryUsage
Global $lblCPUUsage

; --- GUI Handles - Main Buttons ---
Global $btnAdd
Global $btnEdit
Global $btnDelete
Global $btnLaunch
Global $btnLaunchAll
Global $btnShortcut
Global $btnMaster
Global $btnRefresh
Global $btnUpdate
Global $btnHelp
Global $hoverBtn = 0

; --- GUI Handles - Dialog Controls ---
Global $hTempDialog
Global $g_hBotDialog
Global $g_hHelpDialog
Global $btnSaveDialog = 0
Global $btnCancelDialog = 0
Global $btnShowPassword = 0
Global $btnBrowse = 0

; --- Dialog Temporary Variables ---
Global $aTempInputs[5]
Global $iTempEditIndex = -1
Global $bTempPasswordVisible = False
Global $hTempListView
Global $hTempStressInput
Global $hTempFPSInput
Global $aTempCheckboxes[35]

; --- Bot Selection Variables ---
Global $g_iBotSelectionIndex
Global $g_lvBots

; ===== INITIALIZATION SEQUENCE =====
_GDIPlus_Startup()
_GUICtrlSmiley_Init()
TCPStartup()
_Crypt_Startup()

InitializeGWArguments()
LoadAccounts()
ScanForBots()

; Initialize bot selection array
ReDim $aBotSelection[UBound($aAccounts)]
For $i = 0 To UBound($aAccounts) - 1
    $aBotSelection[$i] = $aAccounts[$i][6]
Next

; Process command line arguments
If ProcessCommandLine() Then
    ; If a command was processed, don't show the interface
EndIf

CreateModernGUI()

; Start animation timer
AdlibRegister("AnimateUI", 50)

; Main loop
While 1
    Sleep(100)
    UpdateAccountStatus()
    SetListViewCursor()
    CloseGWErrorWindows()
WEnd

; ===== CORE ENGINE =====
Func LoadAccounts()
    Local $i = 0
    While 1
        Local $email = IniRead($sAccountsFile, "Account" & $i, "email", "")
        If $email = "" Then ExitLoop

        ReDim $aAccounts[$i + 1][8]
        $aAccounts[$i][0] = $email

        Local $encPassword = IniRead($sAccountsFile, "Account" & $i, "password", "")
        $aAccounts[$i][1] = BinaryToString(_Crypt_DecryptData($encPassword, $sCryptKey, $CALG_AES_256))

        $aAccounts[$i][2] = IniRead($sAccountsFile, "Account" & $i, "character", "")
        $aAccounts[$i][3] = IniRead($sAccountsFile, "Account" & $i, "path", "C:\Program Files (x86)\Guild Wars\Gw.exe")
        $aAccounts[$i][4] = 0
        $aAccounts[$i][5] = Number(IniRead($sAccountsFile, "Account" & $i, "keepalive", "0"))
        $aAccounts[$i][6] = IniRead($sAccountsFile, "Account" & $i, "bot", "")
        $aAccounts[$i][7] = 0

        $i += 1
    WEnd
EndFunc

Func SaveAccounts()
    For $i = 0 To UBound($aAccounts) - 1
        IniWrite($sAccountsFile, "Account" & $i, "email", $aAccounts[$i][0])
        IniWrite($sAccountsFile, "Account" & $i, "password", _Crypt_EncryptData($aAccounts[$i][1], $sCryptKey, $CALG_AES_256))
        IniWrite($sAccountsFile, "Account" & $i, "character", $aAccounts[$i][2])
        IniWrite($sAccountsFile, "Account" & $i, "path", $aAccounts[$i][3])
        IniWrite($sAccountsFile, "Account" & $i, "keepalive", $aAccounts[$i][5])
        IniWrite($sAccountsFile, "Account" & $i, "bot", $aAccounts[$i][6])
    Next

    Local $i = UBound($aAccounts)
    While IniRead($sAccountsFile, "Account" & $i, "email", "") <> ""
        IniDelete($sAccountsFile, "Account" & $i)
        $i += 1
    WEnd
EndFunc

Func UpdateAccountStatus()
    Local $needUpdate = False
    Local $relaunchList[0]
    Local $relaunchBotList[0]

    For $i = 0 To UBound($aAccounts) - 1
        If $aAccounts[$i][4] > 0 And Not ProcessExists($aAccounts[$i][4]) Then
            $aAccounts[$i][4] = 0
            $needUpdate = True
            AddLog("🔴 Account disconnected: " & $aAccounts[$i][0], $COLOR_ERROR)

            If $aAccounts[$i][7] > 0 And ProcessExists($aAccounts[$i][7]) Then
                CloseBotForAccount($i)
            EndIf
            $aAccounts[$i][7] = 0

            If $aAccounts[$i][5] = 1 And Not $g_bUpdatingAccounts Then
                ReDim $relaunchList[UBound($relaunchList) + 1]
                $relaunchList[UBound($relaunchList) - 1] = $i
            EndIf
        Else
            If $aAccounts[$i][4] > 0 And ProcessExists($aAccounts[$i][4]) Then
                If $aAccounts[$i][7] > 0 And Not ProcessExists($aAccounts[$i][7]) Then
                    $aAccounts[$i][7] = 0
                    $needUpdate = True
                    AddLog("🤖 Bot disconnected: " & $aAccounts[$i][0], $COLOR_WARNING)

                    If $aAccounts[$i][5] = 1 And $aAccounts[$i][6] <> "" And Not $g_bUpdatingAccounts Then
                        ReDim $relaunchBotList[UBound($relaunchBotList) + 1]
                        $relaunchBotList[UBound($relaunchBotList) - 1] = $i
                    EndIf
                EndIf
            EndIf
        EndIf
    Next

    If $needUpdate Then RefreshListView()

    For $i = 0 To UBound($relaunchList) - 1
        AddLog("🔄 Auto-relaunching account and bot: " & $aAccounts[$relaunchList[$i]][0], $COLOR_INFO)
        LaunchAccount($relaunchList[$i])
        Sleep(2000)
    Next

    For $i = 0 To UBound($relaunchBotList) - 1
        AddLog("🔄 Auto-relaunching bot only for: " & $aAccounts[$relaunchBotList[$i]][0], $COLOR_INFO)
        LaunchBotForAccount($relaunchBotList[$i])
        Sleep(1000)
    Next
EndFunc

Func RefreshAccounts()
    LoadAccounts()
    RefreshListView()
    AddLog("🔄 Accounts refreshed", $COLOR_INFO)
EndFunc

Func DeleteAccount()
    Local $selected = _GUICtrlListView_GetSelectedIndices($lvAccounts, True)
    If $selected[0] = 0 Then
        AddLog("⚠️ Please select an account to delete", $COLOR_WARNING)
        Return
    EndIf

    If MsgBox_OnTop(36, "Confirmation", "Delete this account?") = 6 Then
        Local $idx = $selected[1]
        Local $email = $aAccounts[$idx][0]

        If $aAccounts[$idx][7] > 0 And ProcessExists($aAccounts[$idx][7]) Then
            ProcessClose($aAccounts[$idx][7])
        EndIf
        If $aAccounts[$idx][4] > 0 And ProcessExists($aAccounts[$idx][4]) Then
            ProcessClose($aAccounts[$idx][4])
        EndIf

        _ArrayDelete($aAccounts, $idx)
        SaveAccounts()
        RefreshListView()
        AddLog("🗑️ Account deleted: " & $email, $COLOR_INFO)
    EndIf
EndFunc


; ===== LAUNCH ENGINE =====
Func LaunchAccount($idx)
    If $idx >= UBound($aAccounts) Then Return

    AddLog("🚀 Launching: " & $aAccounts[$idx][0], $COLOR_INFO)

    GUICtrlSetData($progressBar, 20)

    Local $email = $aAccounts[$idx][0]
    Local $password = $aAccounts[$idx][1]
    Local $character = $aAccounts[$idx][2]
    Local $path = $aAccounts[$idx][3]

    If Not FileExists($path) Then
        AddLog("❌ File not found: " & $path, $COLOR_ERROR)
        GUICtrlSetData($progressBar, 0)
        Return
    EndIf

    GUICtrlSetData($progressBar, 40)

    If StringInStr($password, '"') Then
        AddLog("⚠️ Password contains quotes - using ControlSend method", $COLOR_WARNING)

        Local $mutexName = "Guild Wars Game Client_" & $idx & "_" & Random(1000, 9999, 1)
        Local $hInstanceMutex = _WinAPI_CreateMutex(0, True, $mutexName)

        Local $args = '-email "' & $email & '"'
        If $character <> "" Then
            $args &= ' -character "' & $character & '"'
        EndIf

        Local $customArgs = IniRead($sAccountsFile, "Account" & $idx, "arguments", "")
        If $customArgs <> "" Then
            $args &= " " & $customArgs
        EndIf

        GUICtrlSetData($progressBar, 60)

        Local $tStartup = DllStructCreate($tagSTARTUPINFO)
        Local $tProcess = DllStructCreate($tagPROCESS_INFORMATION)
        DllStructSetData($tStartup, "Size", DllStructGetSize($tStartup))

        Local $sCmd = '"' & $path & '" ' & $args
        Local $sDir = StringRegExpReplace($path, "(.*\\).*", "$1")

        Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", _
                "wstr", $path, _
                "wstr", $sCmd, _
                "ptr", 0, _
                "ptr", 0, _
                "bool", False, _
                "dword", $CREATE_SUSPENDED, _
                "ptr", 0, _
                "wstr", $sDir, _
                "struct*", $tStartup, _
                "struct*", $tProcess)

        If @error Or Not $aResult[0] Then
            AddLog("❌ Failed to launch process", $COLOR_ERROR)
            _WinAPI_CloseHandle($hInstanceMutex)
            GUICtrlSetData($progressBar, 0)
            Return
        EndIf

        GUICtrlSetData($progressBar, 80)

        Local $hProcess = DllStructGetData($tProcess, "hProcess")
        Local $hThread = DllStructGetData($tProcess, "hThread")
        Local $pid = DllStructGetData($tProcess, "ProcessId")

        ApplyMulticlientPatch($hProcess)

        DllCall("kernel32.dll", "dword", "ResumeThread", "handle", $hThread)

        $aAccounts[$idx][4] = $pid

        GUICtrlSetData($progressBar, 90)

        Local $timeout = 30000
        Local $timer = TimerInit()
        Local $passwordSent = False

        While TimerDiff($timer) < $timeout And Not $passwordSent
            Local $aWindows = WinList("[CLASS:ArenaNet_Dx_Window_Class]")
            For $i = 1 To $aWindows[0][0]
                If WinGetProcess($aWindows[$i][1]) = $pid Then

                    WinActivate($aWindows[$i][1])
                    WinWaitActive($aWindows[$i][1], "", 2)

                    _SendPassword($aWindows[$i][1], $password)
					ControlSend($aWindows[$i][1], "", "", "{ENTER}")

                    $passwordSent = True
                    AddLog("✅ Password sent via ControlSend", $COLOR_SUCCESS)
                    ExitLoop
                EndIf
            Next
            Sleep(100)
        WEnd

        GUICtrlSetData($progressBar, 100)
        Sleep(500)
        GUICtrlSetData($progressBar, 0)

        If Not $passwordSent Then
            AddLog("⚠️ Timeout waiting for login screen", $COLOR_WARNING)
        EndIf

        If ProcessExists($pid) Then
            AddLog("✅ Successfully launched with ControlSend (PID: " & $pid & ")", $COLOR_SUCCESS)
            _WinAPI_CloseHandle($hInstanceMutex)

            If $aAccounts[$idx][6] <> "" And FileExists($aAccounts[$idx][6]) Then
                Sleep(8000)
                LaunchBotForAccount($idx)
            EndIf

            Local $queueSize = UBound($aWindowTitleQueue)
            ReDim $aWindowTitleQueue[$queueSize + 1][2]
            $aWindowTitleQueue[$queueSize][0] = $pid
            $aWindowTitleQueue[$queueSize][1] = $idx
            If $queueSize = 0 Then
                AdlibRegister("ProcessWindowTitleQueue", 1000)
            EndIf
        Else
            AddLog("⚠️ Process terminated unexpectedly", $COLOR_WARNING)
            $aAccounts[$idx][4] = 0
            _WinAPI_CloseHandle($hInstanceMutex)
        EndIf

        _WinAPI_CloseHandle($hThread)
        _WinAPI_CloseHandle($hProcess)

        RefreshListView()
        Return
    EndIf

    Local $mutexName = "Guild Wars Game Client_" & $idx & "_" & Random(1000, 9999, 1)
    Local $hInstanceMutex = _WinAPI_CreateMutex(0, True, $mutexName)

    Local $args = '-email "' & $email & '" -password "' & $password & '"'
    If $character <> "" Then
        $args &= ' -character "' & $character & '"'
    EndIf

    Local $customArgs = IniRead($sAccountsFile, "Account" & $idx, "arguments", "")
    If $customArgs <> "" Then
        $args &= " " & $customArgs
    EndIf

    GUICtrlSetData($progressBar, 60)

    Local $tStartup = DllStructCreate($tagSTARTUPINFO)
    Local $tProcess = DllStructCreate($tagPROCESS_INFORMATION)
    DllStructSetData($tStartup, "Size", DllStructGetSize($tStartup))

    Local $sCmd = '"' & $path & '" ' & $args
    Local $sDir = StringRegExpReplace($path, "(.*\\).*", "$1")

    Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", _
            "wstr", $path, _
            "wstr", $sCmd, _
            "ptr", 0, _
            "ptr", 0, _
            "bool", False, _
            "dword", $CREATE_SUSPENDED, _
            "ptr", 0, _
            "wstr", $sDir, _
            "struct*", $tStartup, _
            "struct*", $tProcess)

    If @error Or Not $aResult[0] Then
        AddLog("❌ Failed to launch process", $COLOR_ERROR)
        _WinAPI_CloseHandle($hInstanceMutex)
        GUICtrlSetData($progressBar, 0)
        Return
    EndIf

    GUICtrlSetData($progressBar, 80)

    Local $hProcess = DllStructGetData($tProcess, "hProcess")
    Local $hThread = DllStructGetData($tProcess, "hThread")
    Local $pid = DllStructGetData($tProcess, "ProcessId")

    ApplyMulticlientPatch($hProcess)

    DllCall("kernel32.dll", "dword", "ResumeThread", "handle", $hThread)

    $aAccounts[$idx][4] = $pid

    GUICtrlSetData($progressBar, 100)
    Sleep(500)
    GUICtrlSetData($progressBar, 0)

    If ProcessExists($pid) Then
        AddLog("✅ Successfully launched (PID: " & $pid & ")", $COLOR_SUCCESS)
        _WinAPI_CloseHandle($hInstanceMutex)

        If $aAccounts[$idx][6] <> "" And FileExists($aAccounts[$idx][6]) Then
            Sleep(3000)
            LaunchBotForAccount($idx)
        EndIf

        Local $queueSize = UBound($aWindowTitleQueue)
        ReDim $aWindowTitleQueue[$queueSize + 1][2]
        $aWindowTitleQueue[$queueSize][0] = $pid
        $aWindowTitleQueue[$queueSize][1] = $idx
        If $queueSize = 0 Then
            AdlibRegister("ProcessWindowTitleQueue", 1000)
        EndIf
    Else
        AddLog("⚠️ Process terminated unexpectedly", $COLOR_WARNING)
        $aAccounts[$idx][4] = 0
        _WinAPI_CloseHandle($hInstanceMutex)
    EndIf

    _WinAPI_CloseHandle($hThread)
    _WinAPI_CloseHandle($hProcess)

    RefreshListView()
EndFunc

Func _SendPassword($hWnd, $sPassword)
	AddLog("⚠️ test", $COLOR_WARNING)
    For $i = 0 To StringLen($sPassword)
        Local $char = StringMid($sPassword, $i, 1)
        Switch $char
			Case "!"
                Send("{!}")
            Case "+"
                Send("{+}")
            Case "^"
                Send("{^}")
            Case "#"
                Send("{#}")
            Case "{"
                Send("{{}")
            Case "}"
                Send("{}}")
			Case '"'
                Send('{"}')
			Case "^"
				Send('{^}')
            Case Else
                Send($char)
        EndSwitch
    Next
EndFunc

Func LaunchAll()
    If $g_bUpdatingAccounts Then
        AddLog("⚠️ Cannot launch during update process", $COLOR_WARNING)
        Return
    EndIf

    AddLog("🚀 Launching all accounts...", $COLOR_INFO)
    Local $launched = 0

    For $i = 0 To UBound($aAccounts) - 1
        If $aAccounts[$i][4] = 0 Or Not ProcessExists($aAccounts[$i][4]) Then
            LaunchAccount($i)
            $launched += 1
            Sleep(5000)
        EndIf
    Next

    AddLog("✅ Launched " & $launched & " accounts", $COLOR_SUCCESS)
EndFunc

Func LaunchSelected()
    If $g_bUpdatingAccounts Then
        AddLog("⚠️ Cannot launch during update process", $COLOR_WARNING)
        Return
    EndIf

    Local $selected = _GUICtrlListView_GetSelectedIndices($lvAccounts, True)
    If $selected[0] = 0 Then
        AddLog("⚠️ No account selected", $COLOR_WARNING)
        Return
    EndIf

    LaunchAccount($selected[1])
EndFunc

Func LaunchAvailableAccounts()
    Local $launchedCount = 0

    For $i = 0 To UBound($aAccounts) - 1
        If $aAccounts[$i][4] = 0 Or Not ProcessExists($aAccounts[$i][4]) Then
            LaunchAccount($i)
            $launchedCount += 1
            Sleep(5000)
        EndIf
    Next

    If $launchedCount = 0 Then
        MsgBox_OnTop(48, "Info", "All accounts are already running!")
    EndIf
EndFunc

Func ApplyMulticlientPatch($hProcess)
    Local $aPattern[19] = [0x56, 0x57, 0x68, 0x00, 0x01, 0x00, 0x00, 0x89, 0x85, _
                          0xF4, 0xFE, 0xFF, 0xFF, 0xC7, 0x00, 0x00, 0x00, 0x00, 0x00]

    Local $aPatch[4] = [0x31, 0xC0, 0x90, 0xC3]

    Local $aPatternPatched[4] = [0x31, 0xC0, 0x90, 0xC3]

    Local $found = False
    Local $patchAddress = 0
    Local $alreadyPatched = False
    Local $blockSize = 0x10000

    Local $currentAddr = 0x10000
    Local $maxAddr = 0x7FFFFFFF
    Local $consecutiveFailures = 0
    Local $scannedRanges = 0

    While $currentAddr < $maxAddr And Not $found And Not $alreadyPatched
        Local $tMBI = DllStructCreate("ptr BaseAddress;ptr AllocationBase;dword AllocationProtect;ptr RegionSize;dword State;dword Protect;dword Type")
        Local $aResult = DllCall("kernel32.dll", "ulong_ptr", "VirtualQueryEx", _
                "handle", $hProcess, _
                "ptr", $currentAddr, _
                "struct*", $tMBI, _
                "ulong_ptr", DllStructGetSize($tMBI))

        If @error Or $aResult[0] = 0 Then
            $currentAddr += 0x10000
            $consecutiveFailures += 1
            If $consecutiveFailures > 100 Then ExitLoop
            ContinueLoop
        EndIf

        $consecutiveFailures = 0
        Local $baseAddr = DllStructGetData($tMBI, "BaseAddress")
        Local $regionSize = DllStructGetData($tMBI, "RegionSize")
        Local $state = DllStructGetData($tMBI, "State")
        Local $protect = DllStructGetData($tMBI, "Protect")

        If $state = 0x1000 And BitAND($protect, 0xEE) > 0 Then
            $scannedRanges += 1

            Local $scanSize = $regionSize
            If $scanSize > 0x1000000 Then $scanSize = 0x1000000

            For $offset = 0 To $scanSize - 1 Step $blockSize
                Local $readSize = $blockSize
                If $offset + $readSize > $scanSize Then
                    $readSize = $scanSize - $offset
                EndIf

                Local $tBuffer = DllStructCreate("byte[" & $readSize & "]")
                Local $bytesRead = 0

                If _WinAPI_ReadProcessMemory($hProcess, $baseAddr + $offset, $tBuffer, $readSize, $bytesRead) And $bytesRead > 19 Then
                    For $i = 1 To $bytesRead - 4
                        Local $matchPatched = True
                        For $j = 0 To 3
                            If DllStructGetData($tBuffer, 1, $i + $j) <> $aPatternPatched[$j] Then
                                $matchPatched = False
                                ExitLoop
                            EndIf
                        Next

                        If $matchPatched And $i > 4 Then
                            Local $before1 = DllStructGetData($tBuffer, 1, $i - 4)
                            Local $before2 = DllStructGetData($tBuffer, 1, $i - 3)
                            Local $before3 = DllStructGetData($tBuffer, 1, $i - 2)
                            Local $before4 = DllStructGetData($tBuffer, 1, $i - 1)

                            If $before1 = 0x55 And $before2 = 0x8B And $before3 = 0xEC And $before4 = 0x81 Then
                                $alreadyPatched = True
                                Return True
                            EndIf
                        EndIf
                    Next

                    For $i = 1 To $bytesRead - 19
                        Local $match = True
                        For $j = 0 To 18
                            If DllStructGetData($tBuffer, 1, $i + $j) <> $aPattern[$j] Then
                                $match = False
                                ExitLoop
                            EndIf
                        Next

                        If $match Then
                            $patchAddress = $baseAddr + $offset + $i - 1 - 0x1A
                            $found = True
                            ExitLoop 2
                        EndIf
                    Next
                EndIf
            Next
        EndIf

        $currentAddr = $baseAddr + $regionSize
    WEnd

    If $alreadyPatched Then
        Return True
    EndIf

    If Not $found Then
        Return True
    EndIf

    Local $tTest = DllStructCreate("byte[4]")
    Local $testRead = 0
    If Not _WinAPI_ReadProcessMemory($hProcess, $patchAddress, $tTest, 4, $testRead) Or $testRead <> 4 Then
        Return False
    EndIf

    Local $oldProtect = 0
    _WinAPI_VirtualProtectEx($hProcess, $patchAddress, 4, $PAGE_EXECUTE_READWRITE, $oldProtect)

    Local $tPayload = DllStructCreate("byte[4]")
    For $i = 0 To 3
        DllStructSetData($tPayload, 1, $aPatch[$i], $i + 1)
    Next

    Local $bytesWritten = 0
    Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", _
            "handle", $hProcess, _
            "ptr", $patchAddress, _
            "struct*", $tPayload, _
            "ulong_ptr", 4, _
            "ulong_ptr*", 0)

    If Not @error And IsArray($aResult) Then
        $bytesWritten = $aResult[5]
        If $bytesWritten = 4 Then
            _WinAPI_VirtualProtectEx($hProcess, $patchAddress, 4, $oldProtect, $oldProtect)
            Return True
        EndIf
    EndIf

    _WinAPI_VirtualProtectEx($hProcess, $patchAddress, 4, $oldProtect, $oldProtect)
    Return False
EndFunc

Func _WinAPI_VirtualProtectEx($hProcess, $pAddress, $iSize, $iProtection, ByRef $iOldProtection)
    Local $aResult = DllCall("kernel32.dll", "bool", "VirtualProtectEx", _
            "handle", $hProcess, _
            "ptr", $pAddress, _
            "ulong_ptr", $iSize, _
            "dword", $iProtection, _
            "dword*", 0)

    If @error Then
        Return SetError(@error, @extended, False)
    EndIf

    $iOldProtection = $aResult[5]

    If Not $aResult[0] Then
        Return False
    EndIf

    Return $aResult[0]
EndFunc

Func ProcessWindowTitleQueue()
    Local $newQueue[0][2]

    For $i = 0 To UBound($aWindowTitleQueue) - 1
        Local $pid = $aWindowTitleQueue[$i][0]
        Local $idx = $aWindowTitleQueue[$i][1]

        If ProcessExists($pid) Then
            If Not SetGWWindowTitleByPID($pid, $idx) Then
                Local $size = UBound($newQueue)
                ReDim $newQueue[$size + 1][2]
                $newQueue[$size][0] = $pid
                $newQueue[$size][1] = $idx
            EndIf
        EndIf
    Next

    $aWindowTitleQueue = $newQueue

    If UBound($aWindowTitleQueue) = 0 Then
        AdlibUnRegister("ProcessWindowTitleQueue")
    EndIf
EndFunc

Func SetGWWindowTitleByPID($pid, $idx)
    If $idx >= UBound($aAccounts) Then Return False

    Local $aWindows = WinList("Guild Wars")
    For $i = 1 To $aWindows[0][0]
        If WinGetProcess($aWindows[$i][1]) = $pid Then
            Local $title = $aAccounts[$idx][2]
            If $title = "" Then $title = $aAccounts[$idx][0]
            WinSetTitle($aWindows[$i][1], "", "Guild Wars - " & $title)
            Return True
        EndIf
    Next
    Return False
EndFunc


; ===== BOT ENGINE =====
Func ScanForBots()
    ReDim $aAvailableBots[0][2]

    ScanDirectoryForBots(@ScriptDir, True)

    Local $botsDir = @ScriptDir & "\bots"
    If FileExists($botsDir) Then
        ScanDirectoryForBots($botsDir, False)
    EndIf

    Local $temp[UBound($aAvailableBots) + 1][2]
    $temp[0][0] = "None"
    $temp[0][1] = ""
    For $i = 0 To UBound($aAvailableBots) - 1
        $temp[$i + 1][0] = $aAvailableBots[$i][0]
        $temp[$i + 1][1] = $aAvailableBots[$i][1]
    Next
    $aAvailableBots = $temp
EndFunc

Func ScanDirectoryForBots($directory, $excludeLauncher = False)
    Local $search = FileFindFirstFile($directory & "\*.exe")
    If $search <> -1 Then
        While 1
            Local $file = FileFindNextFile($search)
            If @error Then ExitLoop
            If Not $excludeLauncher Or ($file <> @ScriptName And $file <> "GwAu3 Multi-Launcher.exe") Then
                AddBotToList($file, $directory & "\" & $file)
            EndIf
        WEnd
        FileClose($search)
    EndIf

    $search = FileFindFirstFile($directory & "\*.au3")
    If $search <> -1 Then
        While 1
            Local $file = FileFindNextFile($search)
            If @error Then ExitLoop
            If Not $excludeLauncher Or ($file <> @ScriptName And $file <> "GwAu3 Multi-Launcher.au3") Then
                AddBotToList($file, $directory & "\" & $file)
            EndIf
        WEnd
        FileClose($search)
    EndIf

    $search = FileFindFirstFile($directory & "\*.a3x")
    If $search <> -1 Then
        While 1
            Local $file = FileFindNextFile($search)
            If @error Then ExitLoop
            AddBotToList($file, $directory & "\" & $file)
        WEnd
        FileClose($search)
    EndIf
EndFunc

Func AddBotToList($filename, $fullpath)
    Local $idx = UBound($aAvailableBots)
    ReDim $aAvailableBots[$idx + 1][2]
    $aAvailableBots[$idx][0] = $filename
    $aAvailableBots[$idx][1] = $fullpath
EndFunc

Func LaunchBotForAccount($idx)
    If $idx >= UBound($aAccounts) Then Return False
    If $aAccounts[$idx][6] = "" Or Not FileExists($aAccounts[$idx][6]) Then Return False

    If $aAccounts[$idx][4] = 0 Or Not ProcessExists($aAccounts[$idx][4]) Then
        AddLog("⚠️ Cannot launch bot - game not running for: " & $aAccounts[$idx][0], $COLOR_WARNING)
        Return False
    EndIf

    Local $botCmd = ""
    Local $botExt = StringLower(StringRight($aAccounts[$idx][6], 4))

    Local $charName = $aAccounts[$idx][2]
    If $charName = "" Then $charName = $aAccounts[$idx][0]

    Switch $botExt
        Case ".exe"
            $botCmd = '"' & $aAccounts[$idx][6] & '" -character "' & $charName & '"'
        Case ".au3", ".a3x"
            If @Compiled Then
                $botCmd = '"' & @ProgramFilesDir & '\AutoIt3\AutoIt3.exe" "' & $aAccounts[$idx][6] & '" -character "' & $charName & '"'
            Else
                $botCmd = '"' & @AutoItExe & '" "' & $aAccounts[$idx][6] & '" -character "' & $charName & '"'
            EndIf
    EndSwitch

    If $botCmd <> "" Then
        Local $botPID = Run($botCmd, StringRegExpReplace($aAccounts[$idx][6], "\\[^\\]*$", ""))
        If $botPID > 0 Then
            $aAccounts[$idx][7] = $botPID
            AddLog("🤖 Bot relaunched for " & $aAccounts[$idx][0] & " (PID: " & $botPID & ")", $COLOR_SUCCESS)
            Return True
        Else
            AddLog("❌ Failed to relaunch bot for " & $aAccounts[$idx][0], $COLOR_ERROR)
            Return False
        EndIf
    EndIf
    Return False
EndFunc

Func CloseBotForAccount($idx)
    If $idx >= UBound($aAccounts) Then Return

    If $aAccounts[$idx][7] > 0 And ProcessExists($aAccounts[$idx][7]) Then
        ProcessClose($aAccounts[$idx][7])
        AddLog("🛑 Bot closed for: " & $aAccounts[$idx][0], $COLOR_INFO)
        $aAccounts[$idx][7] = 0
    EndIf
EndFunc


; ===== UPDATE ENGINE =====
Func Updater()
    If UBound($aAccounts) = 0 Then
        AddLog("⚠️ No accounts to update", $COLOR_WARNING)
        MsgBox_OnTop(48, "Warning", "No accounts configured!")
        Return
    EndIf

    Local $result = MsgBox_OnTop(36, "Update Accounts", _
        "This will update all Guild Wars accounts by downloading game files." & @CRLF & @CRLF & _
        "Each account will be launched with -image parameter." & @CRLF & _
        "The game will close automatically after updating." & @CRLF & @CRLF & _
        "This process may take a while. Continue?")

    If $result <> 6 Then Return

    UpdateAllAccounts()
EndFunc

Func UpdateAllAccounts()
    AddLog("🔄 Starting account updates...", $COLOR_INFO)

    $g_bUpdatingAccounts = True

    GUICtrlSetState($GUI_DISABLE, $hGUI)

    Local $totalAccounts = UBound($aAccounts)
    Local $successCount = 0
    Local $failCount = 0

    For $i = 0 To $totalAccounts - 1
        GUICtrlSetData($lblActivityText, "Updating...")

        Local $progress = Round(($i / $totalAccounts) * 100)
        GUICtrlSetData($progressBar, $progress)

        AddLog("📥 Updating account " & ($i + 1) & "/" & $totalAccounts & ": " & $aAccounts[$i][0], $COLOR_INFO)

        If UpdateSingleAccount($i) Then
            $successCount += 1
            AddLog("✅ Successfully updated: " & $aAccounts[$i][0], $COLOR_SUCCESS)
        Else
            $failCount += 1
            AddLog("❌ Failed to update: " & $aAccounts[$i][0], $COLOR_ERROR)
        EndIf

        Sleep(5000)
    Next

    GUICtrlSetData($progressBar, 100)
    Sleep(500)
    GUICtrlSetData($progressBar, 0)

    $g_bUpdatingAccounts = False

    GUICtrlSetState($GUI_ENABLE, $hGUI)

    If $g_i_ActiveAccounts > 0 Then
        GUICtrlSetData($lblActivityText, "Active")
    Else
        GUICtrlSetData($lblActivityText, "Ready")
    EndIf

    Local $summary = "Update process completed!" & @CRLF & @CRLF
    $summary &= "✅ Success: " & $successCount & @CRLF
    $summary &= "❌ Failed: " & $failCount & @CRLF
    $summary &= "📊 Total: " & $totalAccounts

    MsgBox_OnTop(64, "Update Complete", $summary)
    AddLog("🎯 Update process finished - Success: " & $successCount & ", Failed: " & $failCount, $COLOR_INFO)
EndFunc

Func UpdateSingleAccount($idx)
    If $idx >= UBound($aAccounts) Then Return False

    Local $email = $aAccounts[$idx][0]
    Local $password = $aAccounts[$idx][1]
    Local $path = $aAccounts[$idx][3]

    If Not FileExists($path) Then
        AddLog("❌ File not found: " & $path, $COLOR_ERROR)
        Return False
    EndIf

    Local $mutexName = "Guild Wars Game Client_Update_" & $idx & "_" & Random(1000, 9999, 1)
    Local $hInstanceMutex = _WinAPI_CreateMutex(0, True, $mutexName)

    Local $args = '-email "' & $email & '" -password "' & $password & '" -image'

    Local $customArgs = IniRead($sAccountsFile, "Account" & $idx, "arguments", "")
    $customArgs = StringRegExpReplace($customArgs, "-character\s+""[^""]*""", "")
    $customArgs = StringRegExpReplace($customArgs, "-character\s+\S+", "")
    If $customArgs <> "" Then
        $args &= " " & $customArgs
    EndIf

    Local $tStartup = DllStructCreate($tagSTARTUPINFO)
    Local $tProcess = DllStructCreate($tagPROCESS_INFORMATION)
    DllStructSetData($tStartup, "Size", DllStructGetSize($tStartup))

    Local $sCmd = '"' & $path & '" ' & $args
    Local $sDir = StringRegExpReplace($path, "(.*\\).*", "$1")

    Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", _
            "wstr", $path, _
            "wstr", $sCmd, _
            "ptr", 0, _
            "ptr", 0, _
            "bool", False, _
            "dword", $CREATE_SUSPENDED, _
            "ptr", 0, _
            "wstr", $sDir, _
            "struct*", $tStartup, _
            "struct*", $tProcess)

    If @error Or Not $aResult[0] Then
        AddLog("❌ Failed to launch update process", $COLOR_ERROR)
        _WinAPI_CloseHandle($hInstanceMutex)
        Return False
    EndIf

    Local $hProcess = DllStructGetData($tProcess, "hProcess")
    Local $hThread = DllStructGetData($tProcess, "hThread")
    Local $pid = DllStructGetData($tProcess, "ProcessId")

    ApplyMulticlientPatch($hProcess)

    DllCall("kernel32.dll", "dword", "ResumeThread", "handle", $hThread)

    AddLog("⏳ Waiting for update to complete...", $COLOR_INFO)

    Local $timeout = 300000
    Local $startTime = TimerInit()

    While ProcessExists($pid)
        Sleep(500)

        If TimerDiff($startTime) > $timeout Then
            AddLog("⚠️ Update timeout reached, terminating process", $COLOR_WARNING)
            ProcessClose($pid)
            _WinAPI_CloseHandle($hInstanceMutex)
            _WinAPI_CloseHandle($hThread)
            _WinAPI_CloseHandle($hProcess)
            Return False
        EndIf

        Local $elapsed = TimerDiff($startTime)
        Local $subProgress = Mod($elapsed / 1000, 10) * 10
        GUICtrlSetData($progressBar, GUICtrlRead($progressBar) + $subProgress * 0.01)
    WEnd

    _WinAPI_CloseHandle($hInstanceMutex)
    _WinAPI_CloseHandle($hThread)
    _WinAPI_CloseHandle($hProcess)

    Return True
EndFunc


; ===== MAIN GUI =====
Func CreateModernGUI()
    $hGUI = GUICreate("GwAu3 Multi-Launcher", 1024, 768, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
    GUISetBkColor($COLOR_BACKGROUND2, $hGUI)
    GUISetOnEvent($GUI_EVENT_CLOSE, "ExitApp")

    GUICtrlCreateLabel("", 0, 0, 1024, 60)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    GUICtrlCreateLabel("GwAu3 Multi-Launcher", 20, 8, 400, 30, 0x0200)
    GUICtrlSetFont(-1, 18, 600, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_HEADER_TEXT)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    GUICtrlCreateLabel("Multi-Client and Bots Management", 22, 40, 300, 15)
    GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_SUBTITLE)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    CreateStatsCard(20, 80, "Total Accounts", "0", $COLOR_INFO, "lblTotalCount")
    CreateStatsCard(195, 80, "Active", "0", $COLOR_SUCCESS, "lblActiveCount")
    CreateStatsCard(370, 80, "Memory Usage", "0 MB", $COLOR_WARNING, "lblMemoryUsage")
    CreateStatsCard(545, 80, "CPU Usage", "0%", $COLOR_ACCENT, "lblCPUUsage")

    _GUICtrlSmiley_Create($EMOJI_ONLINE, 974, 20, 20)

    $lblActivityText = GUICtrlCreateLabel("Ready", 884, 26, 80, 20, 0x0002)
    GUICtrlSetFont($lblActivityText, 9, 400)
    GUICtrlSetColor($lblActivityText, $COLOR_HEADER_TEXT)
    GUICtrlSetBkColor($lblActivityText, $COLOR_HEADER)

    CreateGroupBox(20, 175, 685, 410, "Accounts Management")

    $lvAccounts = GUICtrlCreateListView("", 35, 210, 650, 320, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER))
    _GUICtrlListView_SetExtendedListViewStyle($lvAccounts, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER))

    _GUICtrlListView_AddColumn($lvAccounts, "Status", 45)
    _GUICtrlListView_AddColumn($lvAccounts, "Email", 150)
    _GUICtrlListView_AddColumn($lvAccounts, "Character", 130)
    _GUICtrlListView_AddColumn($lvAccounts, "Process", 55)
    _GUICtrlListView_AddColumn($lvAccounts, "Uptime", 55)
    _GUICtrlListView_AddColumn($lvAccounts, "Keep Alive", 70)
    _GUICtrlListView_AddColumn($lvAccounts, "Bot Selection", 150)

    GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

    Global $btnAdd = CreateEmojiButton(35, 540, 95, 35, "Add", $EMOJI_ADD, "ShowAddAccountDialog", $COLOR_SUCCESS)
    Global $btnEdit = CreateEmojiButton(140, 540, 95, 35, "Edit", $EMOJI_EDIT, "ShowEditAccountDialog", $COLOR_INFO)
    Global $btnDelete = CreateEmojiButton(245, 540, 95, 35, "Delete", $EMOJI_TRASH, "DeleteAccount", $COLOR_ERROR)
    Global $btnLaunch = CreateEmojiButton(355, 540, 105, 35, "Launch", $EMOJI_PLAY, "LaunchSelected", $COLOR_ACCENT)
    Global $btnLaunchAll = CreateEmojiButton(470, 540, 105, 35, "Launch All", $EMOJI_PLAY, "LaunchAll", $COLOR_WARNING)
    Global $btnShortcut = CreateEmojiButton(585, 540, 100, 35, "Shortcut", $EMOJI_SAVE, "CreateShortcut", $COLOR_SECONDARY)

    CreateGroupBox(20, 600, 980, 140, "Quick Actions")

    Global $btnMaster = CreateEmojiButton(40, 635, 120, 35, "Master Link", $EMOJI_NETWORK, "CreateMasterShortcut", $COLOR_ACCENT)
    Global $btnRefresh = CreateEmojiButton(170, 635, 120, 35, "Refresh", $EMOJI_REFRESH, "RefreshAccounts", $COLOR_INFO)
    Global $btnUpdate = CreateEmojiButton(300, 635, 120, 35, "Update Accounts", $EMOJI_SETTINGS, "Updater", $COLOR_SECONDARY)
    Global $btnHelp = CreateEmojiButton(430, 635, 120, 35, "Help", $EMOJI_HELP, "ShowHelp", $COLOR_SUCCESS)

    CreateGroupBox(720, 80, 280, 505, "Activity Log")

    $g_h_LogText = _GUICtrlRichEdit_Create($hGUI, "", 730, 115, 260, 460, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
    _GUICtrlRichEdit_SetBkColor($g_h_LogText, $COLOR_CARD_BG)
    _GUICtrlRichEdit_SetFont($g_h_LogText, 9, "Consolas")

    $progressBar = GUICtrlCreateProgress(40, 690, 940, 25)
    GUICtrlSetBkColor($progressBar, $COLOR_BORDER)

    GUISetState(@SW_SHOW)
    RefreshListView()

    AddLog("✅ Launcher initialized", $COLOR_SUCCESS)
    AddLog("📊 " & UBound($aAccounts) & " accounts loaded", $COLOR_INFO)
EndFunc

Func CreateStatsCard($x, $y, $title, $value, $color, $varName)
    GUICtrlCreateLabel("", $x, $y, 160, 80)
    GUICtrlSetBkColor(-1, $COLOR_CARD_BG)

    GUICtrlCreateLabel("", $x, $y, 160, 3)
    GUICtrlSetBkColor(-1, $color)

    GUICtrlCreateLabel($title, $x + 10, $y + 10, 140, 20)
    GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_SECONDARY)
    GUICtrlSetBkColor(-1, $COLOR_CARD_BG)

    Assign($varName, GUICtrlCreateLabel($value, $x + 10, $y + 35, 140, 30, 0x01), 2)
    GUICtrlSetFont(Eval($varName), 20, 600, 0, "Segoe UI")
    GUICtrlSetColor(Eval($varName), $color)
    GUICtrlSetBkColor(Eval($varName), $COLOR_CARD_BG)
EndFunc

Func CreateGroupBox($x, $y, $w, $h, $title)
    GUICtrlCreateLabel("", $x, $y, $w, $h)
    GUICtrlSetBkColor(-1, $COLOR_CARD_BG)
    GUICtrlSetState(-1, $GUI_DISABLE)

    GUICtrlCreateLabel("", $x, $y, $w, 25)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)
    GUICtrlSetState(-1, $GUI_DISABLE)

    GUICtrlCreateLabel($title, $x + 10, $y + 3, $w - 20, 20)
    GUICtrlSetFont(-1, 10, 600, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_HEADER_TEXT)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)
EndFunc

Func CreateModernButton($x, $y, $w, $h, $text, $function, $color)
    Local $btn = GUICtrlCreateButton($text, $x, $y, $w, $h)
    GUICtrlSetOnEvent($btn, $function)
    GUICtrlSetFont($btn, 9, 500, 0, "Segoe UI")
    GUICtrlSetColor($btn, $color)
    GUICtrlSetCursor($btn, 0)
    Return $btn
EndFunc


; ===== DIALOGS =====
Func ShowAddAccountDialog()
    Global $aTempCheckboxes[35]
    Global $hTempFPSInput
    Global $hTempStressInput

    Local $hDialog = GUICreate("Add Account", 500, 650, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE), $hGUI)
    GUISetBkColor($COLOR_BACKGROUND2, $hDialog)
    GUISetOnEvent($GUI_EVENT_CLOSE, "CloseDialog")

    GUICtrlCreateLabel("", 0, 0, 500, 50)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    GUICtrlCreateLabel("Add New Account", 20, 10, 300, 30)
    GUICtrlSetFont(-1, 14, 600, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_HEADER_TEXT)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    CreateGroupBox(20, 70, 460, 180, "Account Information")

    GUICtrlCreateLabel("Email:", 40, 105, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputEmail = GUICtrlCreateInput("", 130, 100, 320, 30)
    GUICtrlSetFont(-1, 10)

	GUICtrlCreateLabel("Password:", 40, 140, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputPassword = GUICtrlCreateInput("", 130, 135, 280, 30, $ES_PASSWORD)
    GUICtrlSetFont(-1, 10)

    $btnShowPassword = CreateSmallEmojiButton(415, 135, 35, 30, $EMOJI_VISIBLE, "TogglePasswordVisibility", $COLOR_INFO)

    GUICtrlCreateLabel("Character:", 40, 175, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputCharacter = GUICtrlCreateInput("", 130, 170, 320, 30)
    GUICtrlSetFont(-1, 10)

	GUICtrlCreateLabel("GW Path:", 40, 210, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputPath = GUICtrlCreateInput("C:\Program Files (x86)\Guild Wars\Gw.exe", 130, 205, 280, 30)
    GUICtrlSetFont(-1, 10)

    $btnBrowse = CreateSmallEmojiButton(415, 205, 35, 30, $EMOJI_BROWSE, "BrowseGWPath", $COLOR_INFO)

    CreateGroupBox(20, 270, 460, 320, "Launch Arguments")

    Local $lvArgs = GUICtrlCreateListView("", 35, 300, 430, 230, BitOR($LVS_REPORT, $LVS_NOCOLUMNHEADER))
    _GUICtrlListView_SetExtendedListViewStyle($lvArgs, BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT))
    _GUICtrlListView_AddColumn($lvArgs, "Arguments", 410)

    For $i = 0 To UBound($aGWArguments) - 1
        If $aGWArguments[$i][0] = "-character" Or $aGWArguments[$i][0] = "-email" Or $aGWArguments[$i][0] = "-password" Then
            ContinueLoop
        EndIf

        Local $item = _GUICtrlListView_AddItem($lvArgs, $aGWArguments[$i][0] & " - " & $aGWArguments[$i][1])
        If $aGWArguments[$i][2] Then
            _GUICtrlListView_SetItemChecked($lvArgs, $item, True)
        EndIf
    Next

    GUICtrlCreateLabel("-fps value:", 40, 540, 60, 20)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    $hTempFPSInput = GUICtrlCreateInput("60", 100, 538, 40, 20)
    GUICtrlSetState($hTempFPSInput, $GUI_DISABLE)

    GUICtrlCreateLabel("-stress value:", 150, 540, 70, 20)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    $hTempStressInput = GUICtrlCreateInput("100", 220, 538, 40, 20)
    GUICtrlSetState($hTempStressInput, $GUI_DISABLE)

    GUICtrlCreateLabel("Additional args:", 40, 565, 90, 20)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputManualArgs = GUICtrlCreateInput("", 130, 563, 320, 25)
    GUICtrlSetTip(-1, "Add any additional arguments not listed above")

	$btnSaveDialog = CreateEmojiButton(150, 600, 90, 40, "Save", $EMOJI_SAVE, "SaveNewAccount", $COLOR_SUCCESS)
    $btnCancelDialog = CreateEmojiButton(260, 600, 90, 40, "Cancel", $EMOJI_ERROR, "CloseDialog", $COLOR_ERROR)

    Global $aTempInputs[5] = [$inputEmail, $inputPassword, $inputCharacter, $inputPath, $inputManualArgs]
    Global $hTempDialog = $hDialog
    Global $hTempListView = $lvArgs
    Global $bTempPasswordVisible = False

    GUICtrlSetOnEvent($lvArgs, "OnArgumentListClick")

    GUISetState(@SW_SHOW, $hDialog)
EndFunc

Func ShowEditAccountDialog()
    Global $aTempCheckboxes[35]
    Global $hTempFPSInput
    Global $hTempStressInput

    Local $selected = _GUICtrlListView_GetSelectedIndices($lvAccounts, True)
    If $selected[0] = 0 Then
        AddLog("⚠️ Please select an account to edit", $COLOR_WARNING)
        Return
    EndIf

    Local $idx = $selected[1]
    Local $hDialog = GUICreate("Edit Account", 500, 650, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE), $hGUI)
    GUISetBkColor($COLOR_BACKGROUND2, $hDialog)
    GUISetOnEvent($GUI_EVENT_CLOSE, "CloseDialog")

    GUICtrlCreateLabel("", 0, 0, 500, 50)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    GUICtrlCreateLabel("Edit Account", 20, 10, 300, 30)
    GUICtrlSetFont(-1, 14, 600, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_HEADER_TEXT)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    CreateGroupBox(20, 70, 460, 180, "Account Information")

    GUICtrlCreateLabel("Email:", 40, 105, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputEmail = GUICtrlCreateInput($aAccounts[$idx][0], 130, 100, 320, 30)
    GUICtrlSetFont(-1, 10)

    GUICtrlCreateLabel("Password:", 40, 140, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputPassword = GUICtrlCreateInput($aAccounts[$idx][1], 130, 135, 280, 30, $ES_PASSWORD)
    GUICtrlSetFont(-1, 10)
	$btnShowPassword = CreateEmojiButton(415, 135, 35, 30, "", $EMOJI_VISIBLE, "TogglePasswordVisibility", $COLOR_INFO)


    GUICtrlCreateLabel("Character:", 40, 175, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputCharacter = GUICtrlCreateInput($aAccounts[$idx][2], 130, 170, 320, 30)
    GUICtrlSetFont(-1, 10)

    GUICtrlCreateLabel("GW Path:", 40, 210, 80, 20)
    GUICtrlSetFont(-1, 10, 400)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputPath = GUICtrlCreateInput($aAccounts[$idx][3], 130, 205, 280, 30)
    GUICtrlSetFont(-1, 10)
	$btnBrowse = CreateEmojiButton(415, 205, 35, 30, "", $EMOJI_BROWSE, "BrowseGWPath", $COLOR_INFO)

    CreateGroupBox(20, 270, 460, 320, "Launch Arguments")

    Local $lvArgs = GUICtrlCreateListView("", 35, 300, 430, 230, BitOR($LVS_REPORT, $LVS_NOCOLUMNHEADER))
    _GUICtrlListView_SetExtendedListViewStyle($lvArgs, BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT))
    _GUICtrlListView_AddColumn($lvArgs, "Arguments", 410)

    Local $savedArgs = IniRead($sAccountsFile, "Account" & $idx, "arguments", "")

    For $i = 0 To UBound($aGWArguments) - 1
        If $aGWArguments[$i][0] = "-character" Or $aGWArguments[$i][0] = "-email" Or $aGWArguments[$i][0] = "-password" Then
            ContinueLoop
        EndIf

        Local $item = _GUICtrlListView_AddItem($lvArgs, $aGWArguments[$i][0] & " - " & $aGWArguments[$i][1])

        If StringInStr($savedArgs, $aGWArguments[$i][0]) Then
            _GUICtrlListView_SetItemChecked($lvArgs, $item, True)
        EndIf
    Next

    GUICtrlCreateLabel("-fps value:", 40, 540, 60, 20)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    $hTempFPSInput = GUICtrlCreateInput("60", 100, 538, 40, 20)

    Local $fpsMatch = StringRegExp($savedArgs, "-fps\s+(\d+)", 1)
    If IsArray($fpsMatch) Then
        GUICtrlSetData($hTempFPSInput, $fpsMatch[0])
        GUICtrlSetState($hTempFPSInput, $GUI_ENABLE)
    Else
        GUICtrlSetState($hTempFPSInput, $GUI_DISABLE)
    EndIf

    GUICtrlCreateLabel("-stress value:", 150, 540, 70, 20)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    $hTempStressInput = GUICtrlCreateInput("100", 220, 538, 40, 20)

    Local $stressMatch = StringRegExp($savedArgs, "-stress\s+(\d+)", 1)
    If IsArray($stressMatch) Then
        GUICtrlSetData($hTempStressInput, $stressMatch[0])
        GUICtrlSetState($hTempStressInput, $GUI_ENABLE)
    Else
        GUICtrlSetState($hTempStressInput, $GUI_DISABLE)
    EndIf

    Local $manualArgs = ExtractManualArguments($savedArgs)

    GUICtrlCreateLabel("Additional args:", 40, 565, 90, 20)
    GUICtrlSetBkColor(-1, $COLOR_HEADER_TEXT)
    Local $inputManualArgs = GUICtrlCreateInput($manualArgs, 130, 563, 320, 25)
    GUICtrlSetTip(-1, "Add any additional arguments not listed above")

	$btnSaveDialog = CreateEmojiButton(150, 600, 90, 40, "Save", $EMOJI_SAVE, "SaveEditedAccount", $COLOR_SUCCESS)
    $btnCancelDialog = CreateEmojiButton(260, 600, 90, 40, "Cancel", $EMOJI_ERROR, "CloseDialog", $COLOR_ERROR)

    Global $aTempInputs[5] = [$inputEmail, $inputPassword, $inputCharacter, $inputPath, $inputManualArgs]
    Global $hTempDialog = $hDialog
    Global $hTempListView = $lvArgs
    Global $iTempEditIndex = $idx
    Global $bTempPasswordVisible = False

    GUICtrlSetOnEvent($lvArgs, "OnArgumentListClick")

    GUISetState(@SW_SHOW, $hDialog)
EndFunc

Func ShowHelp()
    Local $hHelpDialog = GUICreate("GwAu3 Multi-Launcher - Complete Help", 700, 600, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE), $hGUI)
    GUISetBkColor($COLOR_CARD_BG, $hHelpDialog)
    GUISetOnEvent($GUI_EVENT_CLOSE, "CloseHelpDialog")

    GUICtrlCreateLabel("", 0, 0, 700, 50)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    GUICtrlCreateLabel(" Complete User Guide", 20, 10, 660, 30)
    GUICtrlSetFont(-1, 16, 600, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_HEADER_TEXT)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)
    _GUICtrlSmiley_Create($EMOJI_HELP, 25, 15, 20)

    Local $hHelpText = GUICtrlCreateEdit("", 20, 60, 660, 480, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
    GUICtrlSetFont($hHelpText, 10, 400, 0, "Consolas")
    GUICtrlSetBkColor($hHelpText, 0xFAFAFA)
    GUICtrlSetColor($hHelpText, 0x333333)

    Local $helpContent = ""

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                             OVERVIEW                               ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "GwAu3 Multi-Launcher is a powerful tool for managing multiple Guild Wars" & @CRLF
    $helpContent &= "accounts. It allows you to launch multiple game clients simultaneously," & @CRLF
    $helpContent &= "manage bots, and automate tasks." & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                          KEY FEATURES                              ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  ✓ Multi-client support with automatic patching" & @CRLF
    $helpContent &= "  ✓ Encrypted account storage" & @CRLF
    $helpContent &= "  ✓ Bot integration and management" & @CRLF
    $helpContent &= "  ✓ Keep-alive functionality" & @CRLF
    $helpContent &= "  ✓ Command-line automation" & @CRLF
    $helpContent &= "  ✓ Custom launch arguments" & @CRLF
    $helpContent &= "  ✓ Desktop shortcuts" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                    🚀 LAUNCHING ACCOUNT                            ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  • Launch Selected: Start only the selected account" & @CRLF
    $helpContent &= "  • Launch All: Start all inactive accounts with a 2-second delay" & @CRLF
    $helpContent &= "  • The launcher automatically applies the multi-client patch" & @CRLF
    $helpContent &= "  • Each account gets a unique window title for easy identification" & @CRLF
    $helpContent &= "  • Error windows are automatically closed" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                    ➕ MANAGING ACCOUNTS                            ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "┌─ ADD ACCOUNT ──────────────────────────────────────────────────────┐" & @CRLF
    $helpContent &= "│  • Email: Your Guild Wars account email                            │" & @CRLF
    $helpContent &= "│  • Password: Stored encrypted in accounts.ini                      │" & @CRLF
    $helpContent &= "│  • Character: Character name for auto-login (optional)             │" & @CRLF
    $helpContent &= "│  • GW Path: Path to Gw.exe                                         │" & @CRLF
    $helpContent &= "│  • Launch Arguments: Select from 35+ available GW options          │" & @CRLF
    $helpContent &= "└────────────────────────────────────────────────────────────────────┘" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "┌─ EDIT ACCOUNT ─────────────────────────────────────────────────────┐" & @CRLF
    $helpContent &= "│  • Modify any account details including launch arguments           │" & @CRLF
    $helpContent &= "│  • Changes are saved immediately                                   │" & @CRLF
    $helpContent &= "└────────────────────────────────────────────────────────────────────┘" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "┌─ DELETE ACCOUNT ───────────────────────────────────────────────────┐" & @CRLF
    $helpContent &= "│  • Removes account from list                                       │" & @CRLF
    $helpContent &= "│  • Closes game and bot if running                                  │" & @CRLF
    $helpContent &= "└────────────────────────────────────────────────────────────────────┘" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                    ⚙️  LAUNCH ARGUMENTS                            ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  Common arguments:" & @CRLF
    $helpContent &= "  • -windowed        Run in windowed mode (enabled by default)" & @CRLF
    $helpContent &= "  • -fps X           Limit frame rate (e.g., -fps 30)" & @CRLF
    $helpContent &= "  • -nosound/-mute   Disable or mute audio" & @CRLF
    $helpContent &= "  • -noshaders       Disable shaders for troubleshooting" & @CRLF
    $helpContent &= "  • -character       Auto-login with character name" & @CRLF
    $helpContent &= "  • Additional manual arguments can be added" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                     🤖 BOT INTEGRATION                             ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  • Click on 'Bot Selection' column to assign a bot" & @CRLF
    $helpContent &= "  • Supports .exe, .au3, and .a3x bot files" & @CRLF
    $helpContent &= "  • Bots are automatically launched 3 seconds after the game starts" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  Bot status indicators:" & @CRLF
    $helpContent &= "    🟢 Green dot = Bot is running" & @CRLF
    $helpContent &= "    ⭕ Red circle = Game running but bot not active" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  Place bot files in:" & @CRLF
    $helpContent &= "    → Launcher directory" & @CRLF
    $helpContent &= "    → 'bots' subfolder" & @CRLF
    $helpContent &= "    → Or browse to any location" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                   🔄 KEEP ALIVE FEATURE                            ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  • Click checkbox in 'Keep Alive' column to enable" & @CRLF
    $helpContent &= "  • Automatically relaunches crashed accounts" & @CRLF
    $helpContent &= "  • Also relaunches associated bots if configured" & @CRLF
    $helpContent &= "  • Disabled during update operations" & @CRLF
    $helpContent &= "  • ☐ = Disabled, ☑ = Enabled" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                      📌 SHORTCUTS                                  ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "┌─ INDIVIDUAL SHORTCUTS ─────────────────────────────────────────────┐" & @CRLF
    $helpContent &= "│  • Creates desktop shortcut for selected account                   │" & @CRLF
    $helpContent &= "│  • Shortcut directly launches that specific account                │" & @CRLF
    $helpContent &= "│  • Named: Guild Wars ML-X (where X is a number)                    │" & @CRLF
    $helpContent &= "└────────────────────────────────────────────────────────────────────┘" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "┌─ MASTER SHORTCUT ──────────────────────────────────────────────────┐" & @CRLF
    $helpContent &= "│  • Creates 'Guild Wars ML-X' shortcut on desktop                   │" & @CRLF
    $helpContent &= "│  • Launches all inactive accounts at once                          │" & @CRLF
    $helpContent &= "│  • Can be used with -auto command line parameter                   │" & @CRLF
    $helpContent &= "└────────────────────────────────────────────────────────────────────┘" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                   🎮 UPDATE ACCOUNTS                               ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  • Updates all Guild Wars game files" & @CRLF
    $helpContent &= "  • Launches each account with -image parameter" & @CRLF
    $helpContent &= "  • Accounts close automatically after updating" & @CRLF
    $helpContent &= "  • Progress shown in status bar" & @CRLF
    $helpContent &= "  • 5-minute timeout per account" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                   📊 STATUS INDICATORS                             ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  ACCOUNT STATUS:" & @CRLF
    $helpContent &= "    🟢 Green = Account is active/online" & @CRLF
    $helpContent &= "    ⭕ Red = Account is inactive/offline" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  STATISTICS CARDS:" & @CRLF
    $helpContent &= "    • Total Accounts = Number of configured accounts" & @CRLF
    $helpContent &= "    • Active = Currently running accounts" & @CRLF
    $helpContent &= "    • Memory Usage = Estimated RAM usage" & @CRLF
    $helpContent &= "    • CPU Usage = Estimated processor usage" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                    💡 TIPS & TRICKS                                ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  • Compile the launcher to .exe for better performance" & @CRLF
    $helpContent &= "  • Use -fps 30 to reduce resource usage" & @CRLF
    $helpContent &= "  • Enable Keep Alive for farming accounts" & @CRLF
    $helpContent &= "  • Create master shortcut for quick daily launches" & @CRLF
    $helpContent &= "  • Place frequently used bots in the 'bots' folder" & @CRLF
    $helpContent &= "  • Use Update Accounts monthly to keep files current" & @CRLF
    $helpContent &= @CRLF

    $helpContent &= "╔════════════════════════════════════════════════════════════════════╗" & @CRLF
    $helpContent &= "║                    ❓ TROUBLESHOOTING                              ║" & @CRLF
    $helpContent &= "╚════════════════════════════════════════════════════════════════════╝" & @CRLF
    $helpContent &= @CRLF
    $helpContent &= "  • Account won't launch → Check GW path and file exists" & @CRLF
    $helpContent &= "  • Bot not starting → Ensure bot file path is correct" & @CRLF
    $helpContent &= "  • Crashes on launch → Try disabling some arguments" & @CRLF
    $helpContent &= "  • Multi-client not working → Run launcher as administrator" & @CRLF
    $helpContent &= "  • Keep Alive not working → Check if updating is in progress" & @CRLF

    GUICtrlSetData($hHelpText, $helpContent)

    Local $btnClose = GUICtrlCreateButton("Close", 300, 555, 100, 35)
    GUICtrlSetFont(-1, 10, 500, 0, "Segoe UI")
    GUICtrlSetBkColor(-1, $COLOR_INFO)
    GUICtrlSetColor(-1, $COLOR_HEADER_TEXT)
    GUICtrlSetOnEvent(-1, "CloseHelpDialog")

    Global $g_hHelpDialog = $hHelpDialog

    GUISetState(@SW_SHOW, $hHelpDialog)
    AddLog("❓ Help guide opened", $COLOR_INFO)
EndFunc

Func ShowBotSelectionMenu($idx)
    If $idx >= UBound($aAccounts) Then Return

    Global $g_iBotSelectionIndex = $idx
    Global $g_hBotDialog
    Global $g_lvBots

    ScanForBots()

    $g_hBotDialog = GUICreate("Select Bot", 400, 350, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE), $hGUI)
    GUISetBkColor($COLOR_CARD_BG)
    GUISetOnEvent($GUI_EVENT_CLOSE, "CloseBotDialog")

    GUICtrlCreateLabel("", 0, 0, 400, 50)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    GUICtrlCreateLabel("Select Bot for: " & $aAccounts[$idx][0], 10, 10, 380, 30)
    GUICtrlSetFont(-1, 12, 600, 0, "Segoe UI")
    GUICtrlSetColor(-1, $COLOR_HEADER_TEXT)
    GUICtrlSetBkColor(-1, $COLOR_HEADER)

    GUICtrlCreateLabel("Available Bots:", 20, 70, 200, 20)
    GUICtrlSetFont(-1, 10, 400)

    Local $currentBot = "None"
    If $aAccounts[$idx][6] <> "" Then
        $currentBot = StringRegExpReplace($aAccounts[$idx][6], ".*\\", "")
    EndIf
    GUICtrlCreateLabel("Current: " & $currentBot, 20, 270, 360, 20)
    GUICtrlSetFont(-1, 9, 400, 2)
    GUICtrlSetColor(-1, $COLOR_INFO)

    Local $btnBrowse = GUICtrlCreateButton(" Browse...", 280, 65, 100, 30)
    GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
    GUICtrlSetBkColor(-1, $COLOR_INFO)
    GUICtrlSetOnEvent(-1, "OnBotBrowse")
    _GUICtrlSmiley_Create($EMOJI_BROWSE, 285, 70, 20)

    $g_lvBots = GUICtrlCreateListView("Bot Name|Path", 20, 100, 360, 160, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS))
    _GUICtrlListView_SetExtendedListViewStyle($g_lvBots, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
    _GUICtrlListView_SetColumnWidth($g_lvBots, 0, 120)
    _GUICtrlListView_SetColumnWidth($g_lvBots, 1, 220)

    If UBound($aAvailableBots) = 1 Then
        Local $item = _GUICtrlListView_AddItem($g_lvBots, "No bots found")
        _GUICtrlListView_AddSubItem($g_lvBots, $item, "Place bot files in launcher folder or 'bots' folder", 1)
        _GUICtrlListView_SetItemState($g_lvBots, $item, 0, $LVIS_SELECTED)
    Else
        For $i = 0 To UBound($aAvailableBots) - 1
            Local $displayPath = $aAvailableBots[$i][1]
            If StringLen($displayPath) > 40 Then
                $displayPath = "..." & StringRight($displayPath, 37)
            EndIf

            Local $item = _GUICtrlListView_AddItem($g_lvBots, $aAvailableBots[$i][0])
            _GUICtrlListView_AddSubItem($g_lvBots, $item, $displayPath, 1)

            If $aAccounts[$idx][6] = $aAvailableBots[$i][1] Then
                _GUICtrlListView_SetItemSelected($g_lvBots, $item, True)
            EndIf
        Next
    EndIf

    GUICtrlSetOnEvent($g_lvBots, "OnBotListDoubleClick")

    Global $btnSelectBot = CreateEmojiButton(75, 300, 90, 35, "Select", $EMOJI_SUCCESS, "OnBotSelect", $COLOR_SUCCESS)
    Global $btnClearBot = CreateEmojiButton(175, 300, 90, 35, "Clear", $EMOJI_REMOVE, "OnBotClear", $COLOR_WARNING)
    Global $btnCancelBot = CreateEmojiButton(275, 300, 90, 35, "Cancel", $EMOJI_ERROR, "CloseBotDialog", $COLOR_ERROR)

    GUISetState(@SW_SHOW, $g_hBotDialog)
EndFunc

Func CloseDialog()
    GUIDelete(@GUI_WinHandle)
EndFunc

Func CloseBotDialog()
    GUIDelete($g_hBotDialog)
EndFunc

Func CloseHelpDialog()
    GUIDelete($g_hHelpDialog)
EndFunc


; ===== DIALOG ACTIONS =====
Func SaveNewAccount()
    Local $email = GUICtrlRead($aTempInputs[0])
    Local $password = GUICtrlRead($aTempInputs[1])
    Local $character = GUICtrlRead($aTempInputs[2])
    Local $path = GUICtrlRead($aTempInputs[3])
    Local $manualArgs = GUICtrlRead($aTempInputs[4])

    If $email = "" Or $password = "" Then
        MsgBox_OnTop(16, "Error", "Email and password required!")
        Return
    EndIf

    Local $args = ""
    Local $itemCount = _GUICtrlListView_GetItemCount($hTempListView)

    For $i = 0 To $itemCount - 1
        If _GUICtrlListView_GetItemChecked($hTempListView, $i) Then
            Local $text = _GUICtrlListView_GetItemText($hTempListView, $i)
            Local $argName = StringLeft($text, StringInStr($text, " - ") - 1)

            If $args <> "" Then $args &= " "

            If $argName = "-fps" Then
                $args &= "-fps " & GUICtrlRead($hTempFPSInput)
            ElseIf $argName = "-stress" Then
                $args &= "-stress " & GUICtrlRead($hTempStressInput)
            Else
                $args &= $argName
            EndIf
        EndIf
    Next

    If $manualArgs <> "" Then
        If $args <> "" Then $args &= " "
        $args &= $manualArgs
    EndIf

	Local $idx = UBound($aAccounts)
    ReDim $aAccounts[$idx + 1][8]
    $aAccounts[$idx][0] = $email
    $aAccounts[$idx][1] = $password
    $aAccounts[$idx][2] = $character
    $aAccounts[$idx][3] = $path
    $aAccounts[$idx][4] = 0
    $aAccounts[$idx][5] = 0
    $aAccounts[$idx][6] = ""
    $aAccounts[$idx][7] = 0

    IniWrite($sAccountsFile, "Account" & $idx, "arguments", $args)

    SaveAccounts()
    RefreshListView()
    GUIDelete($hTempDialog)

    AddLog("✅ Account added: " & $email, $COLOR_SUCCESS)
EndFunc

Func SaveEditedAccount()
    Local $email = GUICtrlRead($aTempInputs[0])
    Local $password = GUICtrlRead($aTempInputs[1])
    Local $character = GUICtrlRead($aTempInputs[2])
    Local $path = GUICtrlRead($aTempInputs[3])
    Local $manualArgs = GUICtrlRead($aTempInputs[4])

    If $email = "" Or $password = "" Then
        MsgBox_OnTop(16, "Error", "Email and password required!")
        Return
    EndIf

    Local $args = ""
    Local $itemCount = _GUICtrlListView_GetItemCount($hTempListView)

    For $i = 0 To $itemCount - 1
        If _GUICtrlListView_GetItemChecked($hTempListView, $i) Then
            Local $text = _GUICtrlListView_GetItemText($hTempListView, $i)
            Local $argName = StringLeft($text, StringInStr($text, " - ") - 1)

            If $args <> "" Then $args &= " "

            If $argName = "-fps" Then
                $args &= "-fps " & GUICtrlRead($hTempFPSInput)
            ElseIf $argName = "-stress" Then
                $args &= "-stress " & GUICtrlRead($hTempStressInput)
            Else
                $args &= $argName
            EndIf
        EndIf
    Next

    If $manualArgs <> "" Then
        If $args <> "" Then $args &= " "
        $args &= $manualArgs
    EndIf

    $aAccounts[$iTempEditIndex][0] = $email
    $aAccounts[$iTempEditIndex][1] = $password
    $aAccounts[$iTempEditIndex][2] = $character
    $aAccounts[$iTempEditIndex][3] = $path

    IniWrite($sAccountsFile, "Account" & $iTempEditIndex, "arguments", $args)

    SaveAccounts()
    RefreshListView()
    GUIDelete($hTempDialog)

    AddLog("✅ Account updated: " & $email, $COLOR_INFO)
EndFunc

Func TogglePasswordVisibility()
    $bTempPasswordVisible = Not $bTempPasswordVisible

    If $bTempPasswordVisible Then
        Local $currentPassword = GUICtrlRead($aTempInputs[1])
        GUICtrlDelete($aTempInputs[1])
        $aTempInputs[1] = GUICtrlCreateInput($currentPassword, 130, 135, 280, 30)
        GUICtrlSetFont($aTempInputs[1], 10)

        If $btnShowPassword <> 0 Then
            _DrawSmallEmojiButton($btnShowPassword, $EMOJI_HIDDEN, 35, 30, $COLOR_INFO, False)
        EndIf
    Else
        Local $currentPassword = GUICtrlRead($aTempInputs[1])
        GUICtrlDelete($aTempInputs[1])
        $aTempInputs[1] = GUICtrlCreateInput($currentPassword, 130, 135, 280, 30, $ES_PASSWORD)
        GUICtrlSetFont($aTempInputs[1], 10)

        If $btnShowPassword <> 0 Then
            _DrawSmallEmojiButton($btnShowPassword, $EMOJI_VISIBLE, 35, 30, $COLOR_INFO, False)
        EndIf
    EndIf
EndFunc

Func BrowseGWPath()
    Local $hActiveWindow = WinGetHandle("[ACTIVE]")

    If $hGUI <> 0 Then WinSetOnTop($hGUI, "", 0)
    If $hTempDialog <> 0 Then WinSetOnTop($hTempDialog, "", 0)

    Local $sFile = FileOpenDialog("Select Gw.exe", "C:\", "Guild Wars (Gw.exe)", 1)

    Local $attempts = 0
    While $attempts < 10
        Local $hDialog = WinGetHandle("[CLASS:#32770]")
        If $hDialog <> 0 And WinGetTitle($hDialog) = "Select Gw.exe" Then
            WinSetState($hDialog, "", @SW_SHOW)
            WinSetState($hDialog, "", @SW_RESTORE)
            WinActivate($hDialog)
            WinSetOnTop($hDialog, "", 1)
            ExitLoop
        EndIf
        Sleep(50)
        $attempts += 1
    WEnd

    If $hGUI <> 0 Then WinSetOnTop($hGUI, "", 1)
    If $hTempDialog <> 0 Then
        WinSetOnTop($hTempDialog, "", 1)
        WinActivate($hTempDialog)
    EndIf

    If $sFile <> "" Then
        GUICtrlSetData($aTempInputs[3], $sFile)
    EndIf
EndFunc


; ===== VISUAL ELEMENTS =====
Func CreateEmojiButton($x, $y, $w, $h, $text, $iEmojiID, $function, $color)
    Local $idPic = GUICtrlCreatePic("", $x, $y, $w, $h)
    GUICtrlSetOnEvent($idPic, $function)
    GUICtrlSetCursor($idPic, 0)

    _DrawEmojiButton($idPic, $text, $iEmojiID, $w, $h, $color, False)

    Return $idPic
EndFunc

Func CreateSmallEmojiButton($x, $y, $w, $h, $iEmojiID, $function, $color)
    Local $idPic = GUICtrlCreatePic("", $x, $y, $w, $h)
    GUICtrlSetOnEvent($idPic, $function)
    GUICtrlSetCursor($idPic, 0)

    _DrawSmallEmojiButton($idPic, $iEmojiID, $w, $h, $color, False)

    Return $idPic
EndFunc

Func _DrawEmojiButton($idCtrl, $sText, $iEmojiID, $iWidth, $iHeight, $iColor, $bHover = False)
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 2)

    Local $iDrawColor = $iColor
    If $bHover Then
        Local $r = BitShift(BitAND($iColor, 0xFF0000), 16)
        Local $g = BitShift(BitAND($iColor, 0x00FF00), 8)
        Local $b = BitAND($iColor, 0x0000FF)

        $r = _Min(255, $r + 30)
        $g = _Min(255, $g + 30)
        $b = _Min(255, $b + 30)

        $iDrawColor = BitOR(BitShift($r, -16), BitShift($g, -8), $b)
    EndIf

    Local $hBrush = _GDIPlus_BrushCreateSolid(0xFF000000 + $iDrawColor)
    _GDIPlus_GraphicsFillRect($hGraphics, 0, 0, $iWidth, $iHeight, $hBrush)
    _GDIPlus_BrushDispose($hBrush)

    Local $hPen = _GDIPlus_PenCreate(0xFF000000, 1)
    _GDIPlus_GraphicsDrawRect($hGraphics, 0, 0, $iWidth - 1, $iHeight - 1, $hPen)
    _GDIPlus_PenDispose($hPen)

    If $iEmojiID >= 0 And $iEmojiID < $EMOJI_COUNT And $__g_ahEmojiPNG[$iEmojiID] <> 0 Then
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $__g_ahEmojiPNG[$iEmojiID], 5, ($iHeight - 20) / 2, 20, 20)
    EndIf

    Local $hFormat = _GDIPlus_StringFormatCreate()
    _GDIPlus_StringFormatSetAlign($hFormat, 0)
    _GDIPlus_StringFormatSetLineAlign($hFormat, 1)

    Local $hFamily = _GDIPlus_FontFamilyCreate("Segoe UI")
    Local $hFont = _GDIPlus_FontCreate($hFamily, 9)
    Local $hTextBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)

    Local $tLayout = _GDIPlus_RectFCreate(30, 0, $iWidth - 35, $iHeight)
    _GDIPlus_GraphicsDrawStringEx($hGraphics, $sText, $hFont, $tLayout, $hFormat, $hTextBrush)

    _GDIPlus_FontDispose($hFont)
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_BrushDispose($hTextBrush)

    Local $hBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
    _WinAPI_DeleteObject(GUICtrlSendMsg($idCtrl, $STM_SETIMAGE, $IMAGE_BITMAP, $hBMP))

    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_BitmapDispose($hBitmap)
EndFunc

Func _DrawSmallEmojiButton($idCtrl, $iEmojiID, $iWidth, $iHeight, $iColor, $bHover = False)
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 2)

    Local $iDrawColor = $iColor
    If $bHover Then
        Local $r = BitShift(BitAND($iColor, 0xFF0000), 16)
        Local $g = BitShift(BitAND($iColor, 0x00FF00), 8)
        Local $b = BitAND($iColor, 0x0000FF)

        $r = _Min(255, $r + 30)
        $g = _Min(255, $g + 30)
        $b = _Min(255, $b + 30)

        $iDrawColor = BitOR(BitShift($r, -16), BitShift($g, -8), $b)
    EndIf

    Local $hBrush = _GDIPlus_BrushCreateSolid(0xFF000000 + $iDrawColor)
    _GDIPlus_GraphicsFillRect($hGraphics, 0, 0, $iWidth, $iHeight, $hBrush)
    _GDIPlus_BrushDispose($hBrush)

    Local $hPen = _GDIPlus_PenCreate(0xFF000000, 1)
    _GDIPlus_GraphicsDrawRect($hGraphics, 0, 0, $iWidth - 1, $iHeight - 1, $hPen)
    _GDIPlus_PenDispose($hPen)

    If $iEmojiID >= 0 And $iEmojiID < $EMOJI_COUNT And $__g_ahEmojiPNG[$iEmojiID] <> 0 Then
        Local $emojiSize = 20
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $__g_ahEmojiPNG[$iEmojiID], _
            ($iWidth - $emojiSize) / 2, ($iHeight - $emojiSize) / 2, $emojiSize, $emojiSize)
    EndIf

    Local $hBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
    _WinAPI_DeleteObject(GUICtrlSendMsg($idCtrl, $STM_SETIMAGE, $IMAGE_BITMAP, $hBMP))

    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_BitmapDispose($hBitmap)
EndFunc

Func _AddEmojiToImageList($hImageList, $iEmojiID)
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0(16, 16)
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)

    _GDIPlus_GraphicsClear($hGraphics, 0x00FFFFFF)

    If $iEmojiID >= 0 And $iEmojiID < $EMOJI_COUNT And $__g_ahEmojiPNG[$iEmojiID] <> 0 Then
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $__g_ahEmojiPNG[$iEmojiID], 0, 0, 16, 16)
    EndIf

    Local $hBMP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)

    _GUIImageList_Add($hImageList, $hBMP)

    _WinAPI_DeleteObject($hBMP)
    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_BitmapDispose($hBitmap)
EndFunc

Func RefreshListView()
    _GUICtrlListView_DeleteAllItems($lvAccounts)
    $g_i_ActiveAccounts = 0

    If $g_hAccountsImageList <> 0 Then
        _GUIImageList_Destroy($g_hAccountsImageList)
    EndIf

    $g_hAccountsImageList = _GUIImageList_Create(16, 16, 5, 3)
    _AddEmojiToImageList($g_hAccountsImageList, $EMOJI_ONLINE)
    _AddEmojiToImageList($g_hAccountsImageList, $EMOJI_OFFLINE)
    _AddEmojiToImageList($g_hAccountsImageList, $EMOJI_WAITING)
    _AddEmojiToImageList($g_hAccountsImageList, $EMOJI_BOT)
    _AddEmojiToImageList($g_hAccountsImageList, $EMOJI_BOT_ACTIVE)

    _GUICtrlListView_SetImageList($lvAccounts, $g_hAccountsImageList, 1)

    For $i = 0 To UBound($aAccounts) - 1
        Local $status = ""
        Local $statusIcon = 1
        Local $pid = "-"
        Local $uptime = "-"
        Local $keepAlive = "☐"
        Local $botName = "None"

        If $aAccounts[$i][4] > 0 And ProcessExists($aAccounts[$i][4]) Then
            $status = ""
            $statusIcon = 0
            $pid = $aAccounts[$i][4]
            $uptime = "Active"
            $g_i_ActiveAccounts += 1
        EndIf

        If $aAccounts[$i][5] = 1 Then
            $keepAlive = "☑"
        EndIf

        If $aAccounts[$i][6] <> "" Then
            $botName = StringRegExpReplace($aAccounts[$i][6], ".*\\", "")

            If $aAccounts[$i][7] > 0 And ProcessExists($aAccounts[$i][7]) Then
                $botName = "● " & $botName
            ElseIf $aAccounts[$i][4] > 0 And ProcessExists($aAccounts[$i][4]) Then
                $botName = "○ " & $botName
            EndIf
        EndIf

        Local $item = _GUICtrlListView_AddItem($lvAccounts, $status, $statusIcon)
        _GUICtrlListView_AddSubItem($lvAccounts, $item, $aAccounts[$i][0], 1)
        _GUICtrlListView_AddSubItem($lvAccounts, $item, $aAccounts[$i][2], 2)
        _GUICtrlListView_AddSubItem($lvAccounts, $item, $pid, 3)
        _GUICtrlListView_AddSubItem($lvAccounts, $item, $uptime, 4)
        _GUICtrlListView_AddSubItem($lvAccounts, $item, $keepAlive, 5)
        _GUICtrlListView_AddSubItem($lvAccounts, $item, $botName, 6)
    Next

    If $g_i_ActiveAccounts > 0 Then
        GUICtrlSetData($lblActivityText, "Active")
    Else
        GUICtrlSetData($lblActivityText, "Ready")
    EndIf
EndFunc


; ===== UI UPDATES =====
Func AnimateUI()
    $g_AnimationState += 1
    If $g_AnimationState > 360 Then $g_AnimationState = 0

    CheckButtonHover()

    Local Static $lastUpdate = 0
    If TimerDiff($lastUpdate) > 1000 Then
        UpdateStatistics()
        $lastUpdate = TimerInit()
    EndIf
EndFunc

Func UpdateStatistics()
    GUICtrlSetData($lblTotalCount, UBound($aAccounts))
    GUICtrlSetData($lblActiveCount, $g_i_ActiveAccounts)

    Local $memUsage = 0
    For $i = 0 To UBound($aAccounts) - 1
        If $aAccounts[$i][4] > 0 And ProcessExists($aAccounts[$i][4]) Then
            $memUsage += Random(100, 300, 1)
        EndIf
    Next
    GUICtrlSetData($lblMemoryUsage, Round($memUsage) & " MB")

    Local $cpuUsage = $g_i_ActiveAccounts * Random(5, 15, 1)
    GUICtrlSetData($lblCPUUsage, Round($cpuUsage) & "%")
EndFunc

Func CheckButtonHover()
    Local $aCursor
    Local $currentWindow = 0

    If $hTempDialog <> 0 And WinExists($hTempDialog) And WinActive($hTempDialog) Then
        $aCursor = GUIGetCursorInfo($hTempDialog)
        $currentWindow = $hTempDialog
    ElseIf $g_hBotDialog <> 0 And WinExists($g_hBotDialog) And WinActive($g_hBotDialog) Then
        $aCursor = GUIGetCursorInfo($g_hBotDialog)
        $currentWindow = $g_hBotDialog
    ElseIf $g_hHelpDialog <> 0 And WinExists($g_hHelpDialog) And WinActive($g_hHelpDialog) Then
        Return
    Else
        $aCursor = GUIGetCursorInfo($hGUI)
        $currentWindow = $hGUI
    EndIf

    If Not IsArray($aCursor) Then Return

    Local $newHover = 0
    Local $buttons[14][5] = [ _
        [$btnAdd, "Add", $EMOJI_ADD, $COLOR_SUCCESS, 95], _
        [$btnEdit, "Edit", $EMOJI_EDIT, $COLOR_INFO, 95], _
        [$btnDelete, "Delete", $EMOJI_TRASH, $COLOR_ERROR, 95], _
        [$btnLaunch, "Launch", $EMOJI_PLAY, $COLOR_ACCENT, 105], _
        [$btnLaunchAll, "Launch All", $EMOJI_PLAY, $COLOR_WARNING, 105], _
        [$btnShortcut, "Shortcut", $EMOJI_SAVE, $COLOR_SECONDARY, 100], _
        [$btnMaster, "Master Link", $EMOJI_NETWORK, $COLOR_ACCENT, 120], _
        [$btnRefresh, "Refresh", $EMOJI_REFRESH, $COLOR_INFO, 120], _
        [$btnUpdate, "Update Accounts", $EMOJI_SETTINGS, $COLOR_SECONDARY, 120], _
        [$btnHelp, "Help", $EMOJI_HELP, $COLOR_SUCCESS, 120], _
        [$btnSaveDialog, "Save", $EMOJI_SAVE, $COLOR_SUCCESS, 90], _
        [$btnCancelDialog, "Cancel", $EMOJI_ERROR, $COLOR_ERROR, 90], _
        [$btnShowPassword, "", $bTempPasswordVisible ? $EMOJI_HIDDEN : $EMOJI_VISIBLE, $COLOR_INFO, 35], _
        [$btnBrowse, "", $EMOJI_BROWSE, $COLOR_INFO, 35] _
    ]

    For $i = 0 To UBound($buttons) - 1
        If $buttons[$i][0] <> 0 And IsObj($buttons[$i][0]) = 0 And $aCursor[4] = $buttons[$i][0] Then
            $newHover = $buttons[$i][0]
            If $hoverBtn <> $newHover Then
                If $buttons[$i][4] = 35 Then
                    _DrawSmallEmojiButton($buttons[$i][0], $buttons[$i][2], 35, 30, $buttons[$i][3], True)
                Else
                    _DrawEmojiButton($buttons[$i][0], $buttons[$i][1], $buttons[$i][2], _
                        $buttons[$i][4], 35, $buttons[$i][3], True)
                EndIf
            EndIf
            ExitLoop
        EndIf
    Next

    If $hoverBtn <> 0 And $hoverBtn <> $newHover Then
        For $i = 0 To UBound($buttons) - 1
            If $buttons[$i][0] <> 0 And IsObj($buttons[$i][0]) = 0 And $hoverBtn = $buttons[$i][0] Then
                If $buttons[$i][4] = 35 Then
                    _DrawSmallEmojiButton($buttons[$i][0], $buttons[$i][2], 35, 30, $buttons[$i][3], False)
                Else
                    _DrawEmojiButton($buttons[$i][0], $buttons[$i][1], $buttons[$i][2], _
                        $buttons[$i][4], 35, $buttons[$i][3], False)
                EndIf
                ExitLoop
            EndIf
        Next
    EndIf

    $hoverBtn = $newHover
EndFunc

Func AddLog($text, $color = 0x000000)
    _GUICtrlRichEdit_SetCharColor($g_h_LogText, $color)
    _GUICtrlRichEdit_AppendText($g_h_LogText, "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $text & @CRLF)
    _GUICtrlRichEdit_ScrollToCaret($g_h_LogText)
EndFunc


; ===== EVENT SYSTEM =====
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $tInfo
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")

    Switch $iIDFrom
        Case $lvAccounts
            Switch $iCode
                Case $NM_CLICK
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
                    Local $iItem = DllStructGetData($tInfo, "Index")
                    Local $iSubItem = DllStructGetData($tInfo, "SubItem")

                    If $iItem >= 0 And $iSubItem = 5 Then
                        ToggleKeepAlive($iItem)
                    ElseIf $iItem >= 0 And $iSubItem = 6 Then
                        ShowBotSelectionMenu($iItem)
                    EndIf

                Case $NM_DBLCLK
                    Return 1
            EndSwitch
    EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc


; ===== LISTVIEW EVENT =====
Func ToggleKeepAlive($idx)
    If $idx >= UBound($aAccounts) Then Return

    If $aAccounts[$idx][5] = 0 Then
        $aAccounts[$idx][5] = 1
        _GUICtrlListView_SetItemText($lvAccounts, $idx, "☑", 5)
        AddLog("✅ Keep Alive enabled for: " & $aAccounts[$idx][0], $COLOR_SUCCESS)
    Else
        $aAccounts[$idx][5] = 0
        _GUICtrlListView_SetItemText($lvAccounts, $idx, "☐", 5)
        AddLog("❌ Keep Alive disabled for: " & $aAccounts[$idx][0], $COLOR_INFO)
    EndIf

    IniWrite($sAccountsFile, "Account" & $idx, "keepalive", $aAccounts[$idx][5])
EndFunc

Func SetListViewCursor()
    Local $aCursorInfo = GUIGetCursorInfo($hGUI)
    If Not IsArray($aCursorInfo) Then Return

    If $aCursorInfo[4] = $lvAccounts Then
        Local $aHit = _GUICtrlListView_SubItemHitTest($lvAccounts)
        If $aHit[0] >= 0 And ($aHit[1] = 5 Or $aHit[1] = 6) Then
            GUISetCursor(0, 1)
        Else
            GUISetCursor(2, 1)
        EndIf
    EndIf
EndFunc

Func OnArgumentListClick()
    Local $itemCount = _GUICtrlListView_GetItemCount($hTempListView)

    For $i = 0 To $itemCount - 1
        Local $text = _GUICtrlListView_GetItemText($hTempListView, $i)
        Local $argName = StringLeft($text, StringInStr($text, " - ") - 1)
        Local $checked = _GUICtrlListView_GetItemChecked($hTempListView, $i)

        If $argName = "-fps" Then
            If $checked Then
                GUICtrlSetState($hTempFPSInput, $GUI_ENABLE)
            Else
                GUICtrlSetState($hTempFPSInput, $GUI_DISABLE)
            EndIf
        ElseIf $argName = "-stress" Then
            If $checked Then
                GUICtrlSetState($hTempStressInput, $GUI_ENABLE)
            Else
                GUICtrlSetState($hTempStressInput, $GUI_DISABLE)
            EndIf
        EndIf
    Next
EndFunc


; ===== BOT SELECTION EVENT =====
Func OnBotSelect()
    Local $selected = _GUICtrlListView_GetSelectedIndices($g_lvBots, True)
    If $selected[0] > 0 Then
        Local $botIdx = $selected[1]

        If UBound($aAvailableBots) = 1 Then
            Return
        EndIf

        $aAccounts[$g_iBotSelectionIndex][6] = $aAvailableBots[$botIdx][1]
        IniWrite($sAccountsFile, "Account" & $g_iBotSelectionIndex, "bot", $aAvailableBots[$botIdx][1])

        If $aAvailableBots[$botIdx][0] = "None" Then
            AddLog("🤖 Bot cleared for " & $aAccounts[$g_iBotSelectionIndex][0], $COLOR_INFO)
        Else
            AddLog("🤖 Bot selected for " & $aAccounts[$g_iBotSelectionIndex][0] & ": " & $aAvailableBots[$botIdx][0], $COLOR_SUCCESS)
        EndIf

        RefreshListView()
    EndIf
    GUIDelete($g_hBotDialog)
EndFunc

Func OnBotBrowse()
    If $hGUI <> 0 Then WinSetOnTop($hGUI, "", 0)
    If $g_hBotDialog <> 0 Then WinSetOnTop($g_hBotDialog, "", 0)

    Local $botFile = FileOpenDialog("Select Bot File", @ScriptDir, "Bot Files (*.exe;*.au3;*.a3x)|All Files (*.*)", 1)

    Local $attempts = 0
    While $attempts < 10
        Local $hDialog = WinGetHandle("[CLASS:#32770]")
        If $hDialog <> 0 And WinGetTitle($hDialog) = "Select Bot File" Then
            WinSetState($hDialog, "", @SW_SHOW)
            WinSetState($hDialog, "", @SW_RESTORE)
            WinActivate($hDialog)
            WinSetOnTop($hDialog, "", 1)
            ExitLoop
        EndIf
        Sleep(50)
        $attempts += 1
    WEnd

    If $hGUI <> 0 Then WinSetOnTop($hGUI, "", 1)
    If $g_hBotDialog <> 0 Then
        WinSetOnTop($g_hBotDialog, "", 1)
        WinActivate($g_hBotDialog)
    EndIf

    If $botFile <> "" Then
        $aAccounts[$g_iBotSelectionIndex][6] = $botFile
        IniWrite($sAccountsFile, "Account" & $g_iBotSelectionIndex, "bot", $botFile)
        AddLog("🤖 Bot selected for " & $aAccounts[$g_iBotSelectionIndex][0] & ": " & StringRegExpReplace($botFile, ".*\\", ""), $COLOR_SUCCESS)
        RefreshListView()
        GUIDelete($g_hBotDialog)
    EndIf
EndFunc

Func OnBotClear()
    $aAccounts[$g_iBotSelectionIndex][6] = ""
    IniWrite($sAccountsFile, "Account" & $g_iBotSelectionIndex, "bot", "")
    AddLog("🤖 Bot cleared for " & $aAccounts[$g_iBotSelectionIndex][0], $COLOR_INFO)
    RefreshListView()
    GUIDelete($g_hBotDialog)
EndFunc

Func OnBotListDoubleClick()
    OnBotSelect()
EndFunc


; ===== SHORTCUT EVENT =====
Func CreateShortcut()
    Local $selected = _GUICtrlListView_GetSelectedIndices($lvAccounts, True)
    If $selected[0] = 0 Then
        AddLog("⚠️ Please select an account", $COLOR_WARNING)
        Return
    EndIf

    Local $idx = $selected[1]
    If $idx >= UBound($aAccounts) Then Return

    Local $shortcutName = GetUniqueShortcutName()
    Local $shortcutPath = @DesktopDir & "\" & $shortcutName

    Local $targetPath = @ScriptFullPath
    If @Compiled Then
        $targetPath = @ScriptFullPath
    Else
        MsgBox_OnTop(48, "Warning", "The launcher is not compiled." & @CRLF & _
            "The shortcut will launch the AutoIt script." & @CRLF & @CRLF & _
            "For best results, compile the script to .exe first.")
    EndIf

    Local $launcherArgs = "-directlaunch " & $idx

    Local $workingDir = @ScriptDir
    Local $description = "Launch Guild Wars - " & $aAccounts[$idx][2]
    If $aAccounts[$idx][2] = "" Then
        $description = "Launch Guild Wars - " & $aAccounts[$idx][0]
    EndIf

    Local $result = FileCreateShortcut($targetPath, _
        $shortcutPath, _
        $workingDir, _
        $launcherArgs, _
        $description, _
        $aAccounts[$idx][3], _
        "", _
        0, _
        @SW_SHOWNORMAL)

    If $result Then
        AddLog("✅ Shortcut created: " & $shortcutName, $COLOR_SUCCESS)
    Else
        AddLog("❌ Failed to create shortcut", $COLOR_ERROR)
    EndIf
EndFunc

Func CreateMasterShortcut()
    Local $shortcutPath = @DesktopDir & "\" & $AUTO_LAUNCH_SHORTCUT & ".lnk"

    If FileExists($shortcutPath) Then
        If MsgBox_OnTop(36, "Confirm", "Master shortcut already exists. Replace it?") <> 6 Then
            Return
        EndIf
    EndIf

    Local $targetPath = @ScriptFullPath
    Local $iconPath = @ScriptFullPath

    If @Compiled Then
        $iconPath = @ScriptFullPath
    Else
        MsgBox_OnTop(48, "Warning", "The launcher is not compiled." & @CRLF & _
            "The shortcut will launch the AutoIt script." & @CRLF & @CRLF & _
            "For best results, compile the script to .exe first.")

        If UBound($aAccounts) > 0 And FileExists($aAccounts[0][3]) Then
            $iconPath = $aAccounts[0][3]
        EndIf
    EndIf

    Local $result = FileCreateShortcut($targetPath, _
        $shortcutPath, _
        @ScriptDir, _
        $AUTO_LAUNCH_SWITCH, _
        "Launch all Guild Wars accounts", _
        $iconPath, _
        "", _
        0, _
        @SW_SHOWNORMAL)

    If $result Then
        AddLog("✅ Master shortcut created successfully!", $COLOR_SUCCESS)
    Else
        AddLog("❌ Failed to create master shortcut", $COLOR_ERROR)
    EndIf
EndFunc


; ===== HELPER FUNCTIONS =====
Func InitializeGWArguments()
    $aGWArguments[0][0] = "-windowed"
    $aGWArguments[0][1] = "Run in windowed mode"
    $aGWArguments[0][2] = True

    $aGWArguments[1][0] = "-fps"
    $aGWArguments[1][1] = "Limit frame rate (e.g. -fps 60)"
    $aGWArguments[1][2] = False

    $aGWArguments[2][0] = "-nosound"
    $aGWArguments[2][1] = "Disable all sounds"
    $aGWArguments[2][2] = False

    $aGWArguments[3][0] = "-mute"
    $aGWArguments[3][1] = "Mute audio (but still process it)"
    $aGWArguments[3][2] = False

    $aGWArguments[4][0] = "-noshaders"
    $aGWArguments[4][1] = "Disable shaders (troubleshooting)"
    $aGWArguments[4][2] = False

    $aGWArguments[5][0] = "-dx8"
    $aGWArguments[5][1] = "Force DirectX 8 compatibility"
    $aGWArguments[5][2] = False

    $aGWArguments[6][0] = "-dsound"
    $aGWArguments[6][1] = "Use old DirectSound mixer"
    $aGWArguments[6][2] = False

    $aGWArguments[7][0] = "-lodfull"
    $aGWArguments[7][1] = "Use highest level of detail"
    $aGWArguments[7][2] = False

    $aGWArguments[8][0] = "-noui"
    $aGWArguments[8][1] = "Disable user interface"
    $aGWArguments[8][2] = False

    $aGWArguments[9][0] = "-bmp"
    $aGWArguments[9][1] = "Create screenshots as BMP"
    $aGWArguments[9][2] = False

    $aGWArguments[10][0] = "-perf"
    $aGWArguments[10][1] = "Display performance indicators"
    $aGWArguments[10][2] = False

    $aGWArguments[11][0] = "-log"
    $aGWArguments[11][1] = "Enable logging to gw.log"
    $aGWArguments[11][2] = False

    $aGWArguments[12][0] = "-diag"
    $aGWArguments[12][1] = "Create diagnostic log (terminates after)"
    $aGWArguments[12][2] = False

    $aGWArguments[13][0] = "-image"
    $aGWArguments[13][1] = "Download all updates (terminates after)"
    $aGWArguments[13][2] = False

    $aGWArguments[14][0] = "-nopatchui"
    $aGWArguments[14][1] = "Patch invisibly in background"
    $aGWArguments[14][2] = False

    $aGWArguments[15][0] = "-oldfov"
    $aGWArguments[15][1] = "Use old field of view"
    $aGWArguments[15][2] = False

    $aGWArguments[16][0] = "-repair"
    $aGWArguments[16][1] = "Repair GW.dat file"
    $aGWArguments[16][2] = False

    $aGWArguments[17][0] = "-sndasio"
    $aGWArguments[17][1] = "Use ASIO driver in software mode"
    $aGWArguments[17][2] = False

    $aGWArguments[18][0] = "-sndwinmm"
    $aGWArguments[18][1] = "Use Windows Multimedia audio driver"
    $aGWArguments[18][2] = False

    $aGWArguments[19][0] = "-windowedfullscreen"
    $aGWArguments[19][1] = "Windowed fullscreen mode"
    $aGWArguments[19][2] = False

    $aGWArguments[20][0] = "-character"
    $aGWArguments[20][1] = "Auto-fill character name (use with -email -password)"
    $aGWArguments[20][2] = False

    $aGWArguments[21][0] = "-email"
    $aGWArguments[21][1] = "Sets the email address on login screen"
    $aGWArguments[21][2] = False

    $aGWArguments[22][0] = "-password"
    $aGWArguments[22][1] = "Enable auto-login with password"
    $aGWArguments[22][2] = False

    $aGWArguments[23][0] = "-fqdn"
    $aGWArguments[23][1] = "Use Auth1.0.ArenaNetworks.com to connect"
    $aGWArguments[23][2] = False

    $aGWArguments[24][0] = "-mce"
    $aGWArguments[24][1] = "Windows Media Center compatibility"
    $aGWArguments[24][2] = False

    $aGWArguments[25][0] = "-newauth"
    $aGWArguments[25][1] = "Use new authentication system (default)"
    $aGWArguments[25][2] = False

    $aGWArguments[26][0] = "-oldauth"
    $aGWArguments[26][1] = "Use old authentication system (deprecated)"
    $aGWArguments[26][2] = False

    $aGWArguments[27][0] = "-prefresetlocal"
    $aGWArguments[27][1] = "Reset all local preferences in .dat file"
    $aGWArguments[27][2] = False

    $aGWArguments[28][0] = "-resetmap"
    $aGWArguments[28][1] = "Reset character to last valid map"
    $aGWArguments[28][2] = False

    $aGWArguments[29][0] = "-stress"
    $aGWArguments[29][1] = "Run stress test (e.g. -stress 100)"
    $aGWArguments[29][2] = False

    $aGWArguments[30][0] = "-uninstall"
    $aGWArguments[30][1] = "Uninstalls Guild Wars"
    $aGWArguments[30][2] = False

    $aGWArguments[31][0] = "-update"
    $aGWArguments[31][1] = "Prompts for install disk to update"
    $aGWArguments[31][2] = False

    $aGWArguments[32][0] = "-exit"
    $aGWArguments[32][1] = "Exit after updating"
    $aGWArguments[32][2] = False

    $aGWArguments[33][0] = "-h"
    $aGWArguments[33][1] = "Display help (if implemented)"
    $aGWArguments[33][2] = False

    $aGWArguments[34][0] = "-help"
    $aGWArguments[34][1] = "Display help (if implemented)"
    $aGWArguments[34][2] = False
EndFunc

Func ProcessCommandLine()
    If $CmdLine[0] = 0 Then Return False

    Local $handled = False

    For $i = 1 To $CmdLine[0]
        Switch $CmdLine[$i]
            Case "-directlaunch"
                If $i < $CmdLine[0] Then
                    Local $accountIdx = Number($CmdLine[$i + 1])
                    If $accountIdx >= 0 And $accountIdx < UBound($aAccounts) Then
                        LaunchAccount($accountIdx)
                        $handled = True
                        Sleep(3000)
                        Exit
                    EndIf
                EndIf

            Case $AUTO_LAUNCH_SWITCH, "-auto"
                LaunchAvailableAccounts()
                $handled = True
                Sleep(3000)
                Exit
        EndSwitch
    Next

    Return $handled
EndFunc

Func ExtractManualArguments($allArgs)
    Local $manualArgs = $allArgs

    For $i = 0 To UBound($aGWArguments) - 1
        If $aGWArguments[$i][0] = "-fps" Then
            $manualArgs = StringRegExpReplace($manualArgs, "-fps\s+\d+", "")
        ElseIf $aGWArguments[$i][0] = "-stress" Then
            $manualArgs = StringRegExpReplace($manualArgs, "-stress\s+\d+", "")
        Else
            $manualArgs = StringReplace($manualArgs, $aGWArguments[$i][0], "")
        EndIf
    Next

    $manualArgs = StringRegExpReplace($manualArgs, "\s+", " ")
    $manualArgs = StringStripWS($manualArgs, 3)

    Return $manualArgs
EndFunc

Func GetUniqueShortcutName()
    For $i = 1 To 100
        Local $name = $SHORTCUT_PREFIX & $i & ".lnk"
        If Not FileExists(@DesktopDir & "\" & $name) Then
            Return $name
        EndIf
    Next

    Return $SHORTCUT_PREFIX & @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC & ".lnk"
EndFunc

Func RGB($r, $g, $b)
    Return BitOR(BitShift($b, -16), BitShift($g, -8), $r)
EndFunc

Func MsgBox_OnTop($iFlag, $sTitle, $sText, $iTimeOut = 0, $hHandle = -1)
    If $hHandle = -1 Then
        $hHandle = WinGetHandle(AutoItWinGetTitle())
        WinSetOnTop($hHandle, "", 1)
    EndIf
    Return MsgBox($iFlag, $sTitle, $sText, $iTimeOut, $hHandle)
EndFunc


; ===== ERROR MANAGEMENT =====
Func CloseGWErrorWindows()
    Local $aErrorTitles[2] = [ _
        "Gw.exe", _
        "Guild Wars Game Client"]

    For $i = 0 To UBound($aErrorTitles) - 1
        If WinExists($aErrorTitles[$i]) Then
            Local $aWindows = WinList($aErrorTitles[$i])

            For $j = 1 To $aWindows[0][0]
                Local $hWnd = $aWindows[$j][1]

                Local $sClass = _WinAPI_GetClassName($hWnd)

                If StringInStr($sClass, "#32770") Or _
                   StringInStr($sClass, "Dialog") Or _
                   StringInStr($sClass, "Error") Or _
                   _IsErrorWindow($hWnd) Then

                    WinClose($hWnd)

                    If WinExists($hWnd) Then
                        WinKill($hWnd)
                    EndIf

                    AddLog("🚫 Closed error window: " & $aErrorTitles[$i], $COLOR_WARNING)
                EndIf
            Next
        EndIf
    Next

    Local $aAllWindows = WinList()
    For $i = 1 To $aAllWindows[0][0]
        If StringInStr($aAllWindows[$i][0], "Gw.exe") Or StringInStr($aAllWindows[$i][0], "Error") Then
            Local $hWnd = $aAllWindows[$i][1]

            If Not _IsGameWindow($hWnd) And _IsErrorWindow($hWnd) Then
                WinClose($hWnd)
                If WinExists($hWnd) Then
                    WinKill($hWnd)
                EndIf
                AddLog("🚫 Closed error window: " & $aAllWindows[$i][0], $COLOR_WARNING)
            EndIf
        EndIf
    Next
EndFunc

Func _IsErrorWindow($hWnd)
    Local $aPos = WinGetPos($hWnd)
    If Not IsArray($aPos) Then Return False

    If $aPos[2] < 600 And $aPos[3] < 400 Then
        Local $iStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)

        If BitAND($iStyle, $WS_DLGFRAME) Or _
           BitAND($iStyle, $DS_MODALFRAME) Or _
           Not BitAND($iStyle, $WS_MAXIMIZEBOX) Then
            Return True
        EndIf
    EndIf

    Return False
EndFunc

Func _IsGameWindow($hWnd)
    Local $iPID = WinGetProcess($hWnd)

    For $i = 0 To UBound($aAccounts) - 1
        If $aAccounts[$i][4] = $iPID Then
            Return True
        EndIf
    Next

    Local $aPos = WinGetPos($hWnd)
    If IsArray($aPos) And $aPos[2] >= 800 And $aPos[3] >= 600 Then
        Return True
    EndIf

    Return False
EndFunc


; ===== PROGRAM TERMINATION =====
Func ExitApp()
    AddLog("👋 Shutting down...", $COLOR_INFO)
    Sleep(500)
    AdlibUnRegister("AnimateUI")
    AdlibUnRegister("ProcessWindowTitleQueue")

    If $g_hAccountsImageList <> 0 Then
        _GUIImageList_Destroy($g_hAccountsImageList)
    EndIf

    TCPShutdown()
    _Crypt_Shutdown()
    _GUICtrlSmiley_Shutdown()
    _GDIPlus_Shutdown()
    Exit
EndFunc
