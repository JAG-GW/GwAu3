#include-once
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <InetConstants.au3>
#include <Array.au3>

#Region WinHttp_Constants
Global $hWINHTTPDLL__WINHTTP = ""

; Default ports for WinHttpConnect
Global Const $INTERNET_DEFAULT_PORT = 0
Global Const $INTERNET_DEFAULT_HTTP_PORT = 80
Global Const $INTERNET_DEFAULT_HTTPS_PORT = 443

; WinHttpOpen
Global Const $WINHTTP_FLAG_ASYNC = 0x10000000

; WinHttpOpenRequest
Global Const $WINHTTP_FLAG_ESCAPE_PERCENT = 0x00000004
Global Const $WINHTTP_FLAG_NULL_CODEPAGE = 0x00000008
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE = 0x00000040
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE_QUERY = 0x00000080
Global Const $WINHTTP_FLAG_BYPASS_PROXY_CACHE = 0x00000100
Global Const $WINHTTP_FLAG_REFRESH = $WINHTTP_FLAG_BYPASS_PROXY_CACHE
Global Const $WINHTTP_FLAG_SECURE = 0x00800000

Global Const $WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0
Global Const $WINHTTP_ACCESS_TYPE_NO_PROXY = 1
Global Const $WINHTTP_ACCESS_TYPE_NAMED_PROXY = 3

Global Const $WINHTTP_NO_PROXY_NAME = ""
Global Const $WINHTTP_NO_PROXY_BYPASS = ""

Global Const $WINHTTP_NO_REFERER = ""
Global Const $WINHTTP_DEFAULT_ACCEPT_TYPES  = 0

; WinHttp{Set and Query} Options
Global Const $WINHTTP_OPTION_CALLBACK = 1
Global Const $WINHTTP_FIRST_OPTION = $WINHTTP_OPTION_CALLBACK
Global Const $WINHTTP_OPTION_RESOLVE_TIMEOUT = 2
Global Const $WINHTTP_OPTION_CONNECT_TIMEOUT = 3
Global Const $WINHTTP_OPTION_CONNECT_RETRIES = 4
Global Const $WINHTTP_OPTION_SEND_TIMEOUT = 5
Global Const $WINHTTP_OPTION_RECEIVE_TIMEOUT = 6
Global Const $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT = 7
Global Const $WINHTTP_OPTION_HANDLE_TYPE = 9
Global Const $WINHTTP_OPTION_READ_BUFFER_SIZE = 12
Global Const $WINHTTP_OPTION_WRITE_BUFFER_SIZE = 13
Global Const $WINHTTP_OPTION_PARENT_HANDLE = 21
Global Const $WINHTTP_OPTION_EXTENDED_ERROR = 24
Global Const $WINHTTP_OPTION_SECURITY_FLAGS = 31
Global Const $WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT = 32
Global Const $WINHTTP_OPTION_URL = 34
Global Const $WINHTTP_OPTION_SECURITY_KEY_BITNESS = 36
Global Const $WINHTTP_OPTION_PROXY = 38
Global Const $WINHTTP_OPTION_USER_AGENT = 41
Global Const $WINHTTP_OPTION_CONTEXT_VALUE = 45
Global Const $WINHTTP_OPTION_CLIENT_CERT_CONTEXT = 47
Global Const $WINHTTP_OPTION_REQUEST_PRIORITY = 58
Global Const $WINHTTP_OPTION_HTTP_VERSION = 59
Global Const $WINHTTP_OPTION_DISABLE_FEATURE = 63
Global Const $WINHTTP_OPTION_CODEPAGE = 68
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_SERVER = 73
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER = 74
Global Const $WINHTTP_OPTION_AUTOLOGON_POLICY = 77
Global Const $WINHTTP_OPTION_SERVER_CERT_CONTEXT = 78
Global Const $WINHTTP_OPTION_ENABLE_FEATURE = 79
Global Const $WINHTTP_OPTION_WORKER_THREAD_COUNT = 80
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT = 81
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_URL = 82
Global Const $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH = 83
Global Const $WINHTTP_OPTION_SECURE_PROTOCOLS = 84
Global Const $WINHTTP_OPTION_ENABLETRACING = 85
Global Const $WINHTTP_OPTION_PASSPORT_SIGN_OUT = 86
Global Const $WINHTTP_OPTION_PASSPORT_RETURN_URL = 87
Global Const $WINHTTP_OPTION_REDIRECT_POLICY = 88
Global Const $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS = 89
Global Const $WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE = 90
Global Const $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE = 91
Global Const $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE = 92
Global Const $WINHTTP_OPTION_CONNECTION_INFO = 93
Global Const $WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST = 94
Global Const $WINHTTP_OPTION_SPN = 96
Global Const $WINHTTP_OPTION_GLOBAL_PROXY_CREDS = 97
Global Const $WINHTTP_OPTION_GLOBAL_SERVER_CREDS = 98
Global Const $WINHTTP_OPTION_UNLOAD_NOTIFY_EVENT = 99
Global Const $WINHTTP_OPTION_REJECT_USERPWD_IN_URL = 100
Global Const $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS = 101
Global Const $WINHTTP_OPTION_RECEIVE_PROXY_CONNECT_RESPONSE = 103
Global Const $WINHTTP_OPTION_IS_PROXY_CONNECT_RESPONSE = 104
Global Const $WINHTTP_OPTION_SERVER_SPN_USED = 106
Global Const $WINHTTP_OPTION_PROXY_SPN_USED = 107
Global Const $WINHTTP_OPTION_SERVER_CBT = 108
Global Const $WINHTTP_OPTION_UNSAFE_HEADER_PARSING = 110
Global Const $WINHTTP_OPTION_DECOMPRESSION = 118
Global Const $WINHTTP_LAST_OPTION = $WINHTTP_OPTION_DECOMPRESSION

Global Const $WINHTTP_OPTION_USERNAME = 0x1000
Global Const $WINHTTP_OPTION_PASSWORD = 0x1001
Global Const $WINHTTP_OPTION_PROXY_USERNAME = 0x1002
Global Const $WINHTTP_OPTION_PROXY_PASSWORD = 0x1003

Global Const $WINHTTP_CONNS_PER_SERVER_UNLIMITED = 0xFFFFFFFF

; WinHttpSendRequest defaults
Global Const $WINHTTP_NO_ADDITIONAL_HEADERS = ""
Global Const $WINHTTP_NO_REQUEST_DATA = ""

; WinHttpCrackUrl defaults
Global Const $ICU_ESCAPE = 0x80000000
Global Const $ICU_DECODE = 0x10000000

; _WinHttpQueryHeaders defaults
Global Const $WINHTTP_QUERY_RAW_HEADERS_CRLF = 22
Global Const $WINHTTP_HEADER_NAME_BY_INDEX = ""
Global Const $WINHTTP_NO_HEADER_INDEX = 0

Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM = 0
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW = 1
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH = 2
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT = $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM

; _WinHttpSimpleReadData detection of UTF-8
Global Const $WINHTTP_QUERY_CONTENT_TYPE = 1
#EndRegion WinHttp_Constants

#Region Updater_ScriptVars
; Path to config.ini
Global $g_s_UpdaterConfigIni = @ScriptDir & "\..\..\API\Core\config.ini"
Global $g_s_GwAu3Dir = @ScriptDir & "\..\..\"

; Section names in INI-file
Global $g_s_Section_Update = "Update"
Global $g_s_Section_Hashes = "Hashes"

; Read GitHub repo details from [Update]
Global $g_b_AutoUpdate = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Enabled", "1") = "1"
Global $g_b_Verbose = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Verbose", "1") = "1"
Global $g_s_Owner = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Owner", "myUser")
Global $g_s_Repo = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Repo", "myRepo")
Global $g_s_Branch = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Branch", "main")

; Add files as needed, e.g. [n, "file1", "file2", ...], use relative paths and forward "/"
Global $g_as_IgnoredFiles[2] = [1, "GwAu3/Core/config.ini"]
#EndRegion Updater_ScriptVars

#Region Updater_Functions
;=================================================================
; Checks for updates to the GwAu3 GitHub repository and downloads
; them upon confirmation
; Return 0 = Error, 1 = No updates, 2 = Update cancelled by user
; Return 3 = Updates disabled, 4 = Update completed
;=================================================================
Func Updater_CheckForGwAu3Updates()
    If Not $g_b_AutoUpdate Then Return 3

    ; Load WinHttp.dll
    Updater_LoadWinHttp()

    ; Load cashed hashes from INI
    Local $l_o_CachedHashes = Updater_LoadHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes)

    ; Open WinHttp session handle
	Local $l_h_Session = _WinHttpOpen("GwAu3-Updater/1.0", $WINHTTP_ACCESS_TYPE_DEFAULT_PROXY)
	If @error Or Not $l_h_Session Then Return 0

	; Connect to GitHub API via HTTPS, creating connection handle
	Local $l_h_Connect = _WinHttpConnect($l_h_Session, "api.github.com", 443)
	If @error Or Not $l_h_Connect Then Return 0

	; Create WinHttp request handle
	Local $l_s_RequestObject = "/repos/" & $g_s_Owner & "/" & $g_s_Repo & "/git/trees/" & $g_s_Branch & "?recursive=1"
	Local $l_h_Request = _WinHttpOpenRequest($l_h_Connect, "GET", $l_s_RequestObject, Default, Default, Default, $WINHTTP_FLAG_SECURE)
	If @error Or Not $l_h_Request Then Return 0

	; Send WinHttp request
	Local $l_b_Send = _WinHttpSendRequest($l_h_Request, "User-Agent: GwAu3-Updater/1.0")
	If @error Or Not $l_b_Send Then Return 0

	; Wait for request response
	Local $l_b_Recv = _WinHttpReceiveResponse($l_h_Request)
	If @error Or Not $l_b_Recv Then Return 0

	; Read received request data into single string
	Local $l_s_Json = _WinHttpSimpleReadData($l_h_Request)

	; Close all opened handles
	_WinHttpCloseHandle($l_h_Request)
	_WinHttpCloseHandle($l_h_Connect)
	_WinHttpCloseHandle($l_h_Session)

    ; Unload WinHttp.dll
    Updater_UnloadWinHttp()

	; Parse blobs from JSON
    Local $l_as_Tree = StringRegExp($l_s_Json, '(?s)\{[^}]*"path":"([^"]+)"[^}]*"type":"blob"[^}]*"sha":"([0-9a-f]+)"[^}]*\}', 3)
    If @error Then
		MsgBox(16,"Error","Could not parse JSON")
		Return 0
	EndIf

	; Build remote hash dictionary
    Local $l_o_RemoteHashes = ObjCreate("Scripting.Dictionary")
    For $i = 0 To UBound($l_as_Tree) - 1 Step 2
        $l_o_RemoteHashes.Add($l_as_Tree[$i], StringUpper($l_as_Tree[$i + 1]))
    Next

    ; Deletion check, cached but no longer in remote repository
    Local $l_as_Deletion[1] = [0]
    Local $l_as_Keys = $l_o_CachedHashes.Keys
    For $i = 0 To UBound($l_as_Keys) - 1
        If Not $l_o_RemoteHashes.Exists($l_as_Keys[$i]) Then
            _ArrayAdd($l_as_Deletion, $l_as_Keys[$i])
            $l_as_Deletion[0] += 1
        EndIf
    Next

    Local $l_i_Count_Deletion = $l_as_Deletion[0]
    If $l_i_Count_Deletion > 0 Then
        ; Decide whether to delete, silent mode = always delete
        Local $l_b_DeleteFiles = Not $g_b_Verbose
        If $g_b_Verbose Then
            ; Verbose mode, delete only if user confirms
            Local Const $LC_I_MAX_ROWS = 20
            Local $l_s_DeleteMsg = ""

            If $l_i_Count_Deletion > $LC_I_MAX_ROWS Then
                For $i = 1 To $LC_I_MAX_ROWS
                    $l_s_DeleteMsg &= $l_as_Deletion[$i] & @CRLF
                Next
                Local $l_i_Leftovers = $l_i_Count_Deletion - $LC_I_MAX_ROWS
                $l_s_DeleteMsg &= @CRLF & "... and " & $l_i_Leftovers & " more items."
            Else
                For $i = 1 To $l_i_Count_Deletion
                    $l_s_DeleteMsg &= $l_as_Deletion[$i] & @CRLF
                Next
            EndIf

            If MsgBox(4 + 48, "GwAu3-Updater - File Removal", _
                "Tracked file/s removed upstream. Remove file/s locally?" & @CRLF & @CRLF & $l_s_DeleteMsg) = 6 Then
                $l_b_DeleteFiles = True
            EndIf
        EndIf

        If $l_b_DeleteFiles Then
            ; Perform removals
            For $i = 1 To $l_as_Deletion[0]
                Local $l_s_File = $g_s_GwAu3Dir & $l_as_Deletion[$i]
                If FileExists($l_s_File) Then FileDelete($l_s_File)
                IniDelete($g_s_UpdaterConfigIni, $g_s_Section_Hashes, StringReplace($l_as_Deletion[$i], "\", "~"))
                $l_o_CachedHashes.Remove($l_as_Deletion[$i])
            Next
        EndIf
    EndIf

	; Update check, new or changed blobs
    Local $l_as_UpdateFiles[1] = [0]
	Local $l_as_UpdateSHAs[1] = [0]
    Local $l_s_RelPath, $l_s_CachedSHA, $l_s_RemoteSHA
    For $i = 0 To UBound($l_as_Tree) - 1 Step 2
        $l_s_RelPath = $l_as_Tree[$i]
        If Updater_IsIgnoredFile($l_s_RelPath) Then ContinueLoop
		$l_s_RemoteSHA = StringUpper($l_as_Tree[$i + 1])
		If $l_o_CachedHashes.Exists($l_s_RelPath) Then
        	$l_s_CachedSHA = $l_o_CachedHashes.Item($l_s_RelPath)
		Else
			$l_s_CachedSHA = ""
		EndIf
        If $l_s_CachedSHA <> $l_s_RemoteSHA Then
			_ArrayAdd($l_as_UpdateFiles, $l_s_RelPath)
			_ArrayAdd($l_as_UpdateSHAs, $l_s_RemoteSHA)
			$l_as_UpdateFiles[0] += 1
			$l_as_UpdateSHAs[0] += 1
		EndIf
    Next
    If $l_as_UpdateFiles[0]=0 Then Return 1

    If $g_b_Verbose Then
        ; verbose mode: prompt and abort if they decline
        If MsgBox(4 + 32, "GwAu3-Updater - Update/s Available", $l_as_UpdateFiles[0] & " update/s available. Update now?") <> 6 Then Return 2
    EndIf

    Log_Info("Starting download, please wait...", "GwAu3", $g_h_EditText)
    Updater_DownloadFilesParallel_PB($l_as_UpdateFiles, $l_as_UpdateSHAs)

    ; Restart current script with new file version and same privileges
    ;~ Run(@AutoItExe & ' "' & @ScriptFullPath & '"')
    ;~ Exit

    Return 4
EndFunc

;=================================================================
; Load cached SHAs from [Hashes] section into a Dictionary
;=================================================================
Func Updater_LoadHashCache($a_s_IniFile, $a_s_IniSection)
    Local $l_o_HashDict = ObjCreate("Scripting.Dictionary")
    Local $l_as_ShaHashes = _IniReadSection($a_s_IniFile, $a_s_IniSection)
    If @error Or UBound($l_as_ShaHashes) = 0 Then Return $l_o_HashDict
    For $i = 1 To UBound($l_as_ShaHashes) - 1
        Local $l_s_DictKey = $l_as_ShaHashes[$i][0]
        Local $l_s_DictVal = $l_as_ShaHashes[$i][1]
        $l_s_DictKey = StringReplace($l_s_DictKey, "~", "/")
        $l_o_HashDict.Add($l_s_DictKey, $l_s_DictVal)
    Next
    Return $l_o_HashDict
EndFunc

;=================================================================
; Reads all key-value pairs from a section of an INI file
; No length limit
;=================================================================
Func _IniReadSection($a_s_IniFile, $a_s_IniSection)
    If Not FileExists($a_s_IniFile) Then
        SetError(1)
        Return 0
    EndIf

    Local $l_as2_Keys[1][2]
    Local $l_h_File = FileOpen($a_s_IniFile, 0)
    If $l_h_File = -1 Then
        SetError(1)
        Return 0
    EndIf

    Local $l_b_InSection = False, $l_s_Line, $l_i_Count = 0

    While 1
        $l_s_Line = FileReadLine($l_h_File)
        If @error Then ExitLoop

        $l_s_Line = StringStripWS($l_s_Line, 3)
        If $l_s_Line = "" Or StringLeft($l_s_Line, 1) = ";" Or StringLeft($l_s_Line, 1) = "#" Then ContinueLoop

        If StringRegExp($l_s_Line, "^\s*\[.*\]\s*$") Then
            ; Check if this is the target section
            Local $l_s_CurrentSection = StringRegExpReplace($l_s_Line, "^\s*\[(.*)\]\s*$", "\1")
            If $l_s_CurrentSection = $a_s_IniSection Then
                $l_b_InSection = True
            ElseIf $l_b_InSection Then
                ; Exited the section
                ExitLoop
            Else
                $l_b_InSection = False
            EndIf
            ContinueLoop
        EndIf

        If $l_b_InSection Then
            ; Parse key=value
            Local $l_i_EqPosition = StringInStr($l_s_Line, "=")
            If $l_i_EqPosition > 1 Then
                Local $sKey = StringStripWS(StringLeft($l_s_Line, $l_i_EqPosition - 1), 3)
                Local $sVal = StringMid($l_s_Line, $l_i_EqPosition + 1)
                ReDim $l_as2_Keys[UBound($l_as2_Keys) + 1][2]
                $l_as2_Keys[UBound($l_as2_Keys) - 1][0] = $sKey
                $l_as2_Keys[UBound($l_as2_Keys) - 1][1] = $sVal
                $l_i_Count += 1
            EndIf
        EndIf
    WEnd

    FileClose($l_h_File)

    If $l_i_Count = 0 Then
        SetError(1)
        Return 0
    EndIf

    $l_as2_Keys[0][0] = $l_i_Count
    Return $l_as2_Keys
EndFunc

;=================================================================
; Save one SHA entry into [Hashes], encoding backslash -> tilde
;=================================================================
Func Updater_SaveHashCache($a_s_IniFile, $a_s_IniSection, $a_s_RelPath, $a_s_SHA)
    Local $l_s_Key = StringRegExpReplace($a_s_RelPath, "[/\\]", "~")
    IniWrite($a_s_IniFile, $a_s_IniSection, $l_s_Key, $a_s_SHA)
EndFunc

;=================================================================
; Optional one-time: Initialize [Hashes] with current file SHAs
;=================================================================
Func Updater_InitializeHashCache()
    Local $l_as_OldEntries = _IniReadSection($g_s_UpdaterConfigIni, $g_s_Section_Hashes)
    If Not @error Then
        For $i = 0 To UBound($l_as_OldEntries)-1
            IniDelete($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_as_OldEntries[$i][0])
        Next
    EndIf

    Local $l_as_Files = Updater_GetRelativeFiles($g_s_GwAu3Dir)
    For $i = 1 To $l_as_Files[0]
        Local $l_s_RelPath = $l_as_Files[$i]
        Local $l_s_FullPath = $g_s_GwAu3Dir & $l_s_RelPath
        Local $l_s_SHA = Updater_ComputeGitBlobSHA($l_s_FullPath)
        Updater_SaveHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_s_RelPath, $l_s_SHA)
    Next
    MsgBox(64, "Initialized", "Wrote " & $l_as_Files[0] & " entries into [" & $g_s_Section_Hashes & "]")
EndFunc

;=================================================================
; Check if file is on ignore list
;=================================================================
Func Updater_IsIgnoredFile($a_s_Path)
    For $i = 1 To $g_as_IgnoredFiles[0]
        If $a_s_Path = $g_as_IgnoredFiles[$i] Then Return True
    Next
    Return False
EndFunc

;=================================================================
; Recursively get relative paths of all files under $a_s_Base
;=================================================================
Func Updater_GetRelativeFiles($a_s_Base)
    Local $l_as_Files[1] = [0]
    Updater_Scan($a_s_Base, $a_s_Base, $l_as_Files)
    Return $l_as_Files
EndFunc

Func Updater_Scan($a_s_Root, $a_s_Current, ByRef $l_as_Files)
    Local $l_h_FirstFileHnd = FileFindFirstFile($a_s_Current & "\*")
    If $l_h_FirstFileHnd = -1 Then Return
    While 1
        Local $l_h_NextFileHnd = FileFindNextFile($l_h_FirstFileHnd)
        If @error Then ExitLoop
        If $l_h_NextFileHnd = "." Or $l_h_NextFileHnd = ".." Then ContinueLoop
        Local $l_s_FullPath = $a_s_Current & "\" & $l_h_NextFileHnd
        If StringInStr(FileGetAttrib($l_s_FullPath), "D") Then
            Updater_Scan($a_s_Root, $l_s_FullPath, $l_as_Files)
        Else
            Local $l_s_RelPath = StringTrimLeft($l_s_FullPath, StringLen($a_s_Root) + 1)
            _ArrayAdd($l_as_Files, $l_s_RelPath)
			$l_as_Files[0] += 1
        EndIf
    WEnd
    FileClose($l_h_FirstFileHnd)
EndFunc

;=================================================================
; ComputeGitBlobSHA($a_s_File)
; Computes Git’s blob SHA1: SHA1( "blob " + filesize + "\0" + content )
;=================================================================
Func Updater_ComputeGitBlobSHA($a_s_File)
    If Not FileExists($a_s_File) Then Return ""

    ; Read raw file bytes, 0 = read, 8 = binary
    Local $l_h_Input = FileOpen($a_s_File, 0 + 8)
    If $l_h_Input = -1 Then Return ""
    Local $l_s_Content = FileRead($l_h_Input)
    FileClose($l_h_Input)

    ; Build Git blob header
    Local $l_i_Size = BinaryLen($l_s_Content)
    Local $l_s_Header = "blob " & $l_i_Size & Chr(0)

    ; Write header + content to temp file, 2 = write, 8 = binary
    Local $l_s_Temp = @TempDir & "\gitblob.bin"
    Local $l_h_Output = FileOpen($l_s_Temp, 2 + 8)
    If $l_h_Output = -1 Then Return ""
    FileWrite($l_h_Output, StringToBinary($l_s_Header))
    FileWrite($l_h_Output, $l_s_Content)
    FileClose($l_h_Output)

    ; Hash it
    Local $l_s_SHA = Updater_GetSHA1($l_s_Temp)

    ; Clean up
    FileDelete($l_s_Temp)

    Return $l_s_SHA
EndFunc

;=================================================================
; GetSHA1($a_s_File) -> Returns the uppercase 40-char SHA-1 of any file
;=================================================================
Func Updater_GetSHA1($a_s_File)
    If Not FileExists($a_s_File) Then Return ""
    Local $l_s_Cmd = 'certutil -hashfile "' & $a_s_File & '" SHA1'
    Local $l_h_PID = Run(@ComSpec & " /c " & $l_s_Cmd, "", @SW_HIDE, BitOR($STDOUT_CHILD, $STDERR_CHILD))
    Local $l_s_Out = "", $l_s_Line
    While 1
        $l_s_Line = StdoutRead($l_h_PID)
        If @error Then ExitLoop
        $l_s_Out &= $l_s_Line
    WEnd
    ; parse 40-hex line
    Local $l_as_Output = StringSplit($l_s_Out, @CRLF, 1)
    For $i = 1 To $l_as_Output[0]
        Local $l_s_SHA = StringStripWS($l_as_Output[$i], 3)
        If StringRegExp($l_s_SHA, "^[A-Fa-f0-9]{40}$") Then
            Return StringUpper($l_s_SHA)
        EndIf
    Next
    Return ""
EndFunc

;=================================================================
; Download files from $a_as_UpdateFiles and write their respective
; hashes from $a_as_UpdateSHAs into INI file
;=================================================================
Func Updater_DownloadFiles_PB($a_as_UpdateFiles, $a_as_UpdateSHAs)
    Local $l_i_FileSize, $l_s_RelPath
    Local $l_s_Url, $l_s_SHA

    Local $l_i_FileCount = $a_as_UpdateFiles[0]

    ; Build a single GUI with label + progress bar
    Local $l_h_GUI = GUICreate("GwAu3-Updater - Downloading Updates", 400, 120)
    Local $l_h_Lbl = GUICtrlCreateLabel("", 20, 20, 360, 20, BitOR($SS_LEFT, $DT_END_ELLIPSIS))
    Local $l_h_ProgressBar = GUICtrlCreateProgress(20, 50, 360, 20)
    Local $l_i_StepSize = 100 / $l_i_FileCount
    GUISetState(@SW_SHOW)

    ; Download sequentially, shifting the bar by an offset each time
    For $j = 1 To $a_as_UpdateFiles[0]
        $l_s_RelPath = $a_as_UpdateFiles[$j]
        $l_s_SHA = $a_as_UpdateSHAs[$j]
        $l_s_Url = "https://raw.githubusercontent.com/" & $g_s_Owner & "/" & $g_s_Repo & "/" & $g_s_Branch & "/" & $l_s_RelPath

        ; Replace "/" with "\" in relative filepath since Windows and GitHub use different delimiters for folders
        $l_s_RelPath = StringReplace($l_s_RelPath, "/", "\")
        Local $l_s_DownloadDst = $g_s_GwAu3Dir & $l_s_RelPath

        ; Create target directory if not present
        Local $l_s_TargetDir = StringRegExpReplace($l_s_DownloadDst, "\\[^\\]+$", "")
        DirCreate($l_s_TargetDir)

        ; Update status
        GUICtrlSetData($l_h_Lbl, "Downloading [" & $j & "/" & $l_i_FileCount & "]: " & $l_s_RelPath & "   ")

        ; Start background download
        Local $l_h_Download = InetGet($l_s_Url, $l_s_DownloadDst, $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
        If @error Or $l_h_Download = 0 Then
            MsgBox(16, "Download Error", "Failed to fetch " & $l_s_RelPath)
            ContinueLoop
        EndIf

        ; Poll until this file is done
        While True
            If InetGetInfo($l_h_Download, $INET_DOWNLOADCOMPLETE) Then ExitLoop
            If @error Then ExitLoop
            Sleep(100)
        WEnd

        ; Update progress bar
        GUICtrlSetData($l_h_ProgressBar, $j * $l_i_StepSize)

        ; Save hash
        Updater_SaveHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_s_RelPath, $l_s_SHA)
    Next

    ; Remove update GUI
    GUIDelete($l_h_GUI)
EndFunc

Func Updater_DownloadFilesParallel_PB($a_as_UpdateFiles, $a_as_UpdateSHAs)
    Local Const $LC_I_MAX_STREAMS = 4
    Local $l_i_FileCount = $a_as_UpdateFiles[0]

    ; Build a single GUI with label + progress bar
    Local $l_h_GUI = GUICreate("GwAu3-Updater - Downloading Updates", 400, 120)
    Local $l_h_Lbl = GUICtrlCreateLabel("", 20, 20, 360, 20, BitOR($SS_LEFT, $DT_END_ELLIPSIS))
    Local $l_h_ProgressBar = GUICtrlCreateProgress(20, 50, 360, 20)
    GUISetState(@SW_SHOW)

    ; Prepare file list [Index][URL, DownloadDst, RelativePath, SHA, CompleteFlag, Handle]
    Local $l_a_Files[$l_i_FileCount + 1][6]
    For $i = 1 To $l_i_FileCount
        Local $l_s_RelPath = StringReplace($a_as_UpdateFiles[$i], "/", "\")
        $l_a_Files[$i][0] = "https://raw.githubusercontent.com/" & $g_s_Owner & "/" & $g_s_Repo & "/" & $g_s_Branch & "/" & $a_as_UpdateFiles[$i] ; URL
        $l_a_Files[$i][1] = $g_s_GwAu3Dir & $l_s_RelPath ; DownloadDst
        $l_a_Files[$i][2] = $l_s_RelPath ; RelativePath
        $l_a_Files[$i][3] = $a_as_UpdateSHAs[$i] ; SHA
        $l_a_Files[$i][4] = False ; CompleteFlag
        $l_a_Files[$i][5] = 0 ; Handle
        Local $l_s_TargetDir = StringRegExpReplace($l_a_Files[$i][1], "\\[^\\]+$", "")
        DirCreate($l_s_TargetDir)
    Next

    Local $l_i_Started = 1, $l_i_Completed = 0
    ; Start up to $LC_I_MAX_STREAMS initial downloads
    For $i = 1 To _Min($LC_I_MAX_STREAMS, $l_i_FileCount)
        $l_a_Files[$i][5] = InetGet($l_a_Files[$i][0], $l_a_Files[$i][1], $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
        $l_i_Started += 1
    Next

    While $l_i_Completed < $l_i_FileCount
        For $i = 1 To $l_i_FileCount
            If $l_a_Files[$i][4] = True Then ContinueLoop
            Local $l_h_Download = $l_a_Files[$i][5]
            If $l_h_Download = 0 Then ContinueLoop ; Not started yet

            ; Poll download
            If InetGetInfo($l_h_Download, $INET_DOWNLOADCOMPLETE) Then
                ; Done
                $l_a_Files[$i][4] = True
                $l_i_Completed += 1
                GUICtrlSetData($l_h_Lbl, "Downloaded Files: [" & $l_i_Completed & "/" & $l_i_FileCount & "]: " & $l_a_Files[$i][2])
                GUICtrlSetData($l_h_ProgressBar, $l_i_Completed / $l_i_FileCount * 100)

                ; Save hash
                Updater_SaveHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_a_Files[$i][2], $l_a_Files[$i][3])

                ; Start next download if any left
                If $l_i_Started <= $l_i_FileCount Then
                    $l_a_Files[$l_i_Started][5] = InetGet($l_a_Files[$l_i_Started][0], $l_a_Files[$l_i_Started][1], $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
                    $l_i_Started += 1
                EndIf
            EndIf
        Next
        Sleep(100)
    WEnd

    GUIDelete($l_h_GUI)
EndFunc

;=================================================================
; Download files from $a_as_UpdateFiles and write their respective
; hashes from $a_as_UpdateSHAs into INI file
;=================================================================
Func Updater_DownloadFiles_NoPB($a_as_UpdateFiles, $a_as_UpdateSHAs)
    Local $l_i_FileSize, $l_s_RelPath
    Local $l_s_Url, $l_s_SHA

    Local $l_i_FileCount = $a_as_UpdateFiles[0]
    For $j = 1 To $l_i_FileCount
        $l_s_RelPath = $a_as_UpdateFiles[$j]
        $l_s_SHA = $a_as_UpdateSHAs[$j]
        $l_s_Url = "https://raw.githubusercontent.com/" & $g_s_Owner & "/" & $g_s_Repo & "/" & $g_s_Branch & "/" & $l_s_RelPath
        $l_i_FileSize = InetGetSize($l_s_Url)

        ; Replace "/" with "\" in relative filepath since Windows and GitHub use different delimiters for folders
        $l_s_RelPath = StringReplace($l_s_RelPath, "/", "\")
        Local $l_s_DownloadDst = $g_s_GwAu3Dir & $l_s_RelPath

        ; Create target directory if not present
        Local $l_s_TargetDir = StringRegExpReplace($l_s_DownloadDst, "\\[^\\]+$", "")
        DirCreate($l_s_TargetDir)

        ; Update status
        Log_Info("Downloading [" & $j & "/" & $l_i_FileCount & "]: " & $l_s_RelPath, "GwAu3", $g_h_EditText)

        ; Start background download
        Local $l_h_Download = InetGet($l_s_Url, $l_s_DownloadDst, $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
        If @error Or $l_h_Download = 0 Then
            MsgBox(16, "Download Error", "Failed to fetch " & $l_s_RelPath)
            ContinueLoop
        EndIf

        ; Poll until this file is done
        While True
            Local $l_i_BytesRead = InetGetInfo($l_h_Download, $INET_DOWNLOADREAD)
            If @error Then ExitLoop
            If $l_i_BytesRead >= $l_i_FileSize Then ExitLoop
            Sleep(100)
        WEnd

        ; Save hash
        Updater_SaveHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_s_RelPath, $l_s_SHA)
    Next
EndFunc

;=================================================================
; DownloadFile($a_s_URL, $a_s_Dest) -> True on success, False on failure
; Uses InetGet() synchronously (waits until the transfer completes)
;=================================================================
Func Updater_DownloadFile($a_s_URL, $a_s_Dest)
    ; flag 1 = synchronous, flag 1 = binary
    Local $l_h_Download = InetGet($a_s_URL, $a_s_Dest, 1, 1)
    If @error Then Return False

    ; Wait for the download to finish
    While InetGetInfo($l_h_Download, 1) = 1
        Sleep(50)
    WEnd

    ; Check final status (0 = success)
    Return (InetGetInfo($l_h_Download, 2) = 0)
EndFunc

;=================================================================
; DownloadFile($a_s_URL, $a_s_Dest) -> True on success, False on failure
; Uses InetGet() synchronously (waits until the transfer completes)
; Includes GUI for download progress
;=================================================================
Func Updater_DownloadFileGUI($a_s_URL, $a_s_Dest)
    ; Ask the server how big the file is
    Local $l_i_TotalSize = InetGetSize($a_s_URL)
    If @error Or $l_i_TotalSize <= 0 Then Return False

    ; Start the download in the background, binary mode
    Local $l_h_Download = InetGet($a_s_URL, $a_s_Dest, $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
    If @error Or $l_h_Download = 0 Then Return False

    ; Build a tiny GUI with a progress bar
    Local $l_h_UpdaterGUI = GUICreate("Downloading...", 400, 120)
    Local $l_i_Pos = StringInStr($a_s_Dest, "\", 0, -1)
    Local $l_s_FileName
    If $l_i_Pos Then
        $l_s_FileName = StringMid($a_s_Dest, $l_i_Pos + 1)
    Else
        $l_s_FileName = $a_s_Dest
    EndIf
    Local $l_h_FileLabel = GUICtrlCreateLabel($l_s_FileName, 20, 20, 360, 20)
    Local $l_h_ProgressBar = GUICtrlCreateProgress(20, 50, 360, 20)
    GUICtrlSetLimit($l_h_ProgressBar, $l_i_TotalSize)                   ; Set maximum = total bytes
    GUISetState(@SW_SHOW)

    ; Poll the download handle until we’ve read all bytes
    Local $l_i_ReadBytes = 0
    While True
        $l_i_ReadBytes = InetGetInfo($l_h_Download, $INET_DOWNLOADREAD) ; Bytes read so far
        If @error Then ExitLoop
        GUICtrlSetData($l_h_ProgressBar, $l_i_ReadBytes)                ; Update the progress bar
        GUISetState()                                                   ; Refresh GUI
        If $l_i_ReadBytes >= $l_i_TotalSize Then ExitLoop
        Sleep(100)
    WEnd

    GUIDelete($l_h_UpdaterGUI)

    ; Return success if we read exactly the total bytes
    Return ($l_i_ReadBytes >= $l_i_TotalSize)
EndFunc
#EndRegion Updater_Functions

#Region WinHttp
; #MANAGE DLL HANDLES# ;=====================================================================
Func Updater_LoadWinHttp()
    $hWINHTTPDLL__WINHTTP = DllOpen("winhttp.dll")
EndFunc

Func Updater_UnloadWinHttp()
    DllClose($hWINHTTPDLL__WINHTTP)
EndFunc
;============================================================================================

; #INDEX# ===================================================================================
; Title ...............: WinHttp
; File Name............: WinHttp.au3
; File Version.........: 1.6.4.2
; Min. AutoIt Version..: v3.3.7.20
; Description .........: AutoIt wrapper for WinHTTP functions
; Author... ...........: trancexx, ProgAndy
; Dll .................: winhttp.dll, kernel32.dll
; ===========================================================================================

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpOpen
; Description ...: Initializes the use of WinHttp functions and returns a WinHttp-session handle.
; Syntax.........: _WinHttpOpen([$sUserAgent = Default [, $iAccessType = Default [, $sProxyName = Default [, $sProxyBypass = Default [, $iFlag = Default ]]]]])
; Parameters ....: $sUserAgent - [optional] The name of the application or entity calling the WinHttp functions.
;                  $iAccessType - [optional] Type of access required. Default is $WINHTTP_ACCESS_TYPE_NO_PROXY.
;                  $sProxyName - [optional] The name of the proxy server to use when proxy access is specified by setting $iAccessType to $WINHTTP_ACCESS_TYPE_NAMED_PROXY. Default is $WINHTTP_NO_PROXY_NAME.
;                  $sProxyBypass - [optional] An optional list of host names or IP addresses, or both, that should not be routed through the proxy when $iAccessType is set to $WINHTTP_ACCESS_TYPE_NAMED_PROXY. Default is $WINHTTP_NO_PROXY_BYPASS.
;                  $iFlag - [optional] Integer containing the flags that indicate various options affecting the behavior of this function. Default is 0.
; Return values .: Success - Returns valid session handle.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Remarks .......: <b>You are strongly discouraged to use WinHTTP in asynchronous mode with AutoIt. AutoIt's callback implementation can't handle reentrancy properly.</b>
;                  +For asynchronous mode set [[$iFlag]] to [[$WINHTTP_FLAG_ASYNC]]. In that case [[$WINHTTP_OPTION_CONTEXT_VALUE]] for the handle will inernally be set to [[$WINHTTP_FLAG_ASYNC]] also.
; Related .......: _WinHttpCloseHandle, _WinHttpConnect
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384098.aspx
;============================================================================================
Func _WinHttpOpen($sUserAgent = Default, $iAccessType = Default, $sProxyName = Default, $sProxyBypass = Default, $iFlag = Default)
    __WinHttpDefault($sUserAgent, __WinHttpUA())
    __WinHttpDefault($iAccessType, $WINHTTP_ACCESS_TYPE_NO_PROXY)
    __WinHttpDefault($sProxyName, $WINHTTP_NO_PROXY_NAME)
    __WinHttpDefault($sProxyBypass, $WINHTTP_NO_PROXY_BYPASS)
    __WinHttpDefault($iFlag, 0)
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpen", _
            "wstr", $sUserAgent, _
            "dword", $iAccessType, _
            "wstr", $sProxyName, _
            "wstr", $sProxyBypass, _
            "dword", $iFlag)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    If $iFlag = $WINHTTP_FLAG_ASYNC Then _WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $WINHTTP_FLAG_ASYNC)
    Return $aCall[0]
EndFunc

Func __WinHttpDefault(ByRef $vInput, $vOutput)
    If $vInput = Default Or Number($vInput) = -1 Then $vInput = $vOutput
EndFunc

Func __WinHttpUA()
    Local Static $sUA = "Mozilla/5.0 " & __WinHttpSysInfo() & " WinHttp/" & __WinHttpVer() & " (WinHTTP/5.1) like Gecko"
    Return $sUA
EndFunc

Func __WinHttpSysInfo()
	Local $sDta = FileGetVersion("kernel32.dll")
	$sDta = "(Windows NT " & StringLeft($sDta, StringInStr($sDta, ".", 1, 2) - 1)
	If StringInStr(@OSArch, "64") And Not @AutoItX64 Then $sDta &= "; WOW64"
	$sDta &= ")"
	Return $sDta
EndFunc

Func __WinHttpVer()
	Return "1.6.4.2"
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSetOption
; Description ...: Sets an Internet option.
; Syntax.........: _WinHttpSetOption($hInternet, $iOption, $vSetting [, $iSize = Default ])
; Parameters ....: $hInternet - Handle on which to set data.
;                  $iOption - Integer value that contains the Internet option to set.
;                  $vSetting - Value of setting
;                  $iSize    - [optional] Size of $vSetting, required if $vSetting is pointer to memory block
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - Invalid Internet option
;                  |2 - Size required
;                  |3 - Datatype of value does not fit to option
;                  |4 - DllCall failed
; Author ........: ProgAndy, trancexx
; Related .......: _WinHttpQueryOption
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384114.aspx
;============================================================================================
Func _WinHttpSetOption($hInternet, $iOption, $vSetting, $iSize = Default)
    If $iSize = Default Then $iSize = -1
    If IsBinary($vSetting) Then
        $iSize = DllStructCreate("byte[" & BinaryLen($vSetting) & "]")
        DllStructSetData($iSize, 1, $vSetting)
        $vSetting = $iSize
        $iSize = DllStructGetSize($vSetting)
    EndIf
    Local $sType
    Switch $iOption
        Case $WINHTTP_OPTION_AUTOLOGON_POLICY, $WINHTTP_OPTION_CODEPAGE, $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, _
                $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_OPTION_DISABLE_FEATURE, $WINHTTP_OPTION_ENABLE_FEATURE, $WINHTTP_OPTION_ENABLETRACING, _
                $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, $WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, _
                $WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE, $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE, $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE, _
                $WINHTTP_OPTION_READ_BUFFER_SIZE, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
                $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_REDIRECT_POLICY, $WINHTTP_OPTION_REJECT_USERPWD_IN_URL, _
                $WINHTTP_OPTION_REQUEST_PRIORITY, $WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURE_PROTOCOLS, $WINHTTP_OPTION_SECURITY_FLAGS, _
                $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT, $WINHTTP_OPTION_SPN, $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS, _
                $WINHTTP_OPTION_WORKER_THREAD_COUNT, $WINHTTP_OPTION_WRITE_BUFFER_SIZE, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING
            $sType = "dword*"
            $iSize = 4
        Case $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_PASSPORT_SIGN_OUT
            $sType = "ptr*"
            $iSize = 4
            If @AutoItX64 Then $iSize = 8
            If Not IsPtr($vSetting) Then Return SetError(3, 0, 0)
        Case $WINHTTP_OPTION_CONTEXT_VALUE
            $sType = "dword_ptr*"
            $iSize = 4
            If @AutoItX64 Then $iSize = 8
        Case $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_USER_AGENT, $WINHTTP_OPTION_USERNAME
            $sType = "wstr"
            If (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
            If $iSize < 1 Then $iSize = StringLen($vSetting)
        Case $WINHTTP_OPTION_CLIENT_CERT_CONTEXT, $WINHTTP_OPTION_GLOBAL_PROXY_CREDS, $WINHTTP_OPTION_GLOBAL_SERVER_CREDS, $WINHTTP_OPTION_HTTP_VERSION, _
                $WINHTTP_OPTION_PROXY
            $sType = "ptr"
            If Not (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
        Case Else
            Return SetError(1, 0, 0)
    EndSwitch
    If $iSize < 1 Then
        If IsDllStruct($vSetting) Then
            $iSize = DllStructGetSize($vSetting)
        Else
            Return SetError(2, 0, 0)
        EndIf
    EndIf
    Local $aCall
    If IsDllStruct($vSetting) Then
        $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, DllStructGetPtr($vSetting), "dword", $iSize)
    Else
        $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, $vSetting, "dword", $iSize)
    EndIf
    If @error Or Not $aCall[0] Then Return SetError(4, 0, 0)
    Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpConnect
; Description ...: Specifies the initial target server of an HTTP request and returns connection handle to an HTTP session for that initial target.
; Syntax.........: _WinHttpConnect($hSession, $sServerName [, $iServerPort = Default ])
; Parameters ....: $hSession - Valid WinHttp session handle returned by a previous call to _WinHttpOpen().
;                  $sServerName - Host name of an HTTP server. In case URI scheme (http://, https://, ...) is specified $iServerPort is ignored.
;                  $iServerPort - [optional] TCP/IP port on the server to which a connection is made (default is $INTERNET_DEFAULT_PORT)
; Return values .: Success - Returns a valid connection handle to the HTTP session
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Remarks .......: [[$iServerPort]] can be defined via global constants [[$INTERNET_DEFAULT_PORT]], [[$INTERNET_DEFAULT_HTTP_PORT]] or [[$INTERNET_DEFAULT_HTTPS_PORT]]
; Related .......: _WinHttpOpen
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384091.aspx
;============================================================================================
Func _WinHttpConnect($hSession, $sServerName, $iServerPort = Default)
    Local $aURL = _WinHttpCrackUrl($sServerName), $iScheme = 0
    If @error Then
        __WinHttpDefault($iServerPort, $INTERNET_DEFAULT_PORT)
    Else
        $sServerName = $aURL[2]
        $iServerPort = $aURL[3]
        $iScheme = $aURL[1]
    EndIf
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpConnect", _
            "handle", $hSession, _
            "wstr", $sServerName, _
            "dword", $iServerPort, _
            "dword", 0)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    _WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $iScheme)
    Return $aCall[0]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpCrackUrl
; Description ...: Separates a URL into its component parts such as host name and path.
; Syntax.........: _WinHttpCrackUrl($sURL [, $iFlag = Default ])
; Parameters ....: $sURL - String. Canonical URL to separate.
;                  $iFlag - [optional] Flag that control the operation. Default is $ICU_ESCAPE
; Return values .: Success - Returns array with 8 elements:
;                  |$array[0] - scheme name
;                  |$array[1] - internet protocol scheme
;                  |$array[2] - host name
;                  |$array[3] - port number
;                  |$array[4] - user name
;                  |$array[5] - password
;                  |$array[6] - URL path
;                  |$array[7] - extra information
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......: [[$iFlag]] is defined in WinHttpConstants.au3 and can be:
;                  |[[$ICU_DECODE]] - Converts characters that are "escape encoded" (%xx) to their non-escaped form.
;                  |[[$ICU_ESCAPE]] - Escapes certain characters to their escape sequences (%xx).
; Related .......: _WinHttpCreateUrl
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384092.aspx
;============================================================================================
Func _WinHttpCrackUrl($sURL, $iFlag = Default)
    __WinHttpDefault($iFlag, $ICU_ESCAPE)
    Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
            "ptr SchemeName;" & _
            "dword SchemeNameLength;" & _
            "int Scheme;" & _
            "ptr HostName;" & _
            "dword HostNameLength;" & _
            "word Port;" & _
            "ptr UserName;" & _
            "dword UserNameLength;" & _
            "ptr Password;" & _
            "dword PasswordLength;" & _
            "ptr UrlPath;" & _
            "dword UrlPathLength;" & _
            "ptr ExtraInfo;" & _
            "dword ExtraInfoLength")
    DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))
    Local $tBuffers[6]
    Local $iURLLen = StringLen($sURL)
    For $i = 0 To 5
        $tBuffers[$i] = DllStructCreate("wchar[" & $iURLLen + 1 & "]")
    Next
    DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0]))
    DllStructSetData($tURL_COMPONENTS, "HostNameLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1]))
    DllStructSetData($tURL_COMPONENTS, "UserNameLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2]))
    DllStructSetData($tURL_COMPONENTS, "PasswordLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3]))
    DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4]))
    DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5]))
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCrackUrl", _
            "wstr", $sURL, _
            "dword", $iURLLen, _
            "dword", $iFlag, _
            "struct*", $tURL_COMPONENTS)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    Local $aRet[8] = [DllStructGetData($tBuffers[0], 1), _
            DllStructGetData($tURL_COMPONENTS, "Scheme"), _
            DllStructGetData($tBuffers[1], 1), _
            DllStructGetData($tURL_COMPONENTS, "Port"), _
            DllStructGetData($tBuffers[2], 1), _
            DllStructGetData($tBuffers[3], 1), _
            DllStructGetData($tBuffers[4], 1), _
            DllStructGetData($tBuffers[5], 1)]
    Return $aRet
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpOpenRequest
; Description ...: Creates an HTTP request handle.
; Syntax.........: _WinHttpOpenRequest($hConnect [, $sVerb = Default [, $sObjectName = Default [, $sVersion = Default [, $sReferer = Default [, $sAcceptTypes = Default [, $iFlags = Default ]]]]]])
; Parameters ....: $hConnect - Handle to an HTTP session returned by _WinHttpConnect().
;                  $sVerb - [optional] HTTP verb to use in the request. Default is "GET".
;                  $sObjectName - [optional] The name of the target resource of the specified HTTP verb.
;                  $sVersion - [optional] HTTP version. Default is "HTTP/1.1"
;                  $sReferer - [optional] URL of the document from which the URL in the request $sObjectName was obtained. Default is $WINHTTP_NO_REFERER.
;                  $sAcceptTypes - [optional] Media types accepted by the client. Default is $WINHTTP_DEFAULT_ACCEPT_TYPES
;                  $iFlags - [optional] Integer specifying the Internet flag values. Default is $WINHTTP_FLAG_ESCAPE_DISABLE
; Return values .: Success - Returns valid session handle.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Related .......: _WinHttpCloseHandle, _WinHttpConnect, _WinHttpSendRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384099.aspx
;============================================================================================
Func _WinHttpOpenRequest($hConnect, $sVerb = Default, $sObjectName = Default, $sVersion = Default, $sReferer = Default, $sAcceptTypes = Default, $iFlags = Default)
    __WinHttpDefault($sVerb, "GET")
    __WinHttpDefault($sObjectName, "")
    __WinHttpDefault($sVersion, "HTTP/1.1")
    __WinHttpDefault($sReferer, $WINHTTP_NO_REFERER)
    __WinHttpDefault($iFlags, $WINHTTP_FLAG_ESCAPE_DISABLE)
    Local $pAcceptTypes
    If $sAcceptTypes = Default Or Number($sAcceptTypes) = -1 Then
        $pAcceptTypes = $WINHTTP_DEFAULT_ACCEPT_TYPES
    Else
        Local $aTypes = StringSplit($sAcceptTypes, ",", 2)
        Local $tAcceptTypes = DllStructCreate("ptr[" & UBound($aTypes) + 1 & "]")
        Local $tType[UBound($aTypes)]
        For $i = 0 To UBound($aTypes) - 1
            $tType[$i] = DllStructCreate("wchar[" & StringLen($aTypes[$i]) + 1 & "]")
            DllStructSetData($tType[$i], 1, $aTypes[$i])
            DllStructSetData($tAcceptTypes, 1, DllStructGetPtr($tType[$i]), $i + 1)
        Next
        $pAcceptTypes = DllStructGetPtr($tAcceptTypes)
    EndIf
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpenRequest", _
            "handle", $hConnect, _
            "wstr", StringUpper($sVerb), _
            "wstr", $sObjectName, _
            "wstr", StringUpper($sVersion), _
            "wstr", $sReferer, _
            "ptr", $pAcceptTypes, _
            "dword", $iFlags)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    Return $aCall[0]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSendRequest
; Description ...: Sends the specified request to the HTTP server.
; Syntax.........: _WinHttpSendRequest($hRequest [, $sHeaders = Default [, $sOptional = Default [, $iTotalLength = Default [, $iContext = Default ]]]])
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest().
;                  $sHeaders - [optional] Additional headers to append to the request. Default is $WINHTTP_NO_ADDITIONAL_HEADERS.
;                  $vOptional - [optional] Optional data to send immediately after the request headers. Default is $WINHTTP_NO_REQUEST_DATA.
;                  $iTotalLength - [optional] Length, in bytes, of the total optional data sent. Default is 0.
;                  $iContext - [optional] Application-defined value that is passed, with the request handle, to any callback functions. Default is 0.
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Remarks .......: Specifying optional data [[$vOptional]] will cause [[$iTotalLength]] to receive the size of that data if left default value.
; Related .......: _WinHttpOpenRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384110.aspx
;============================================================================================
Func _WinHttpSendRequest($hRequest, $sHeaders = Default, $vOptional = Default, $iTotalLength = Default, $iContext = Default)
	__WinHttpDefault($sHeaders, $WINHTTP_NO_ADDITIONAL_HEADERS)
	__WinHttpDefault($vOptional, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($iTotalLength, 0)
	__WinHttpDefault($iContext, 0)
	Local $pOptional = 0, $iOptionalLength = 0
	If @NumParams > 2 Then
		Local $tOptional
		$iOptionalLength = BinaryLen($vOptional)
		$tOptional = DllStructCreate("byte[" & $iOptionalLength & "]")
		If $iOptionalLength Then $pOptional = DllStructGetPtr($tOptional)
		DllStructSetData($tOptional, 1, $vOptional)
	EndIf
	If Not $iTotalLength Or $iTotalLength < $iOptionalLength Then $iTotalLength += $iOptionalLength
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSendRequest", _
			"handle", $hRequest, _
			"wstr", $sHeaders, _
			"dword", 0, _
			"ptr", $pOptional, _
			"dword", $iOptionalLength, _
			"dword", $iTotalLength, _
			"dword_ptr", $iContext)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpReceiveResponse
; Description ...: Waits to receive the response to an HTTP request initiated by WinHttpSendRequest().
; Syntax.........: _WinHttpReceiveResponse($hRequest)
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest() and sent by _WinHttpSendRequest().
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Remarks .......: Call to _WinHttpReceiveResponse() must be done before _WinHttpQueryDataAvailable() and _WinHttpReadData().
; Related .......: _WinHttpOpenRequest, _WinHttpSetTimeouts
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384105.aspx
;============================================================================================
Func _WinHttpReceiveResponse($hRequest)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReceiveResponse", "handle", $hRequest, "ptr", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _WinHttpSimpleReadData
; Description ...: Reads data from a request
; Syntax.........: _WinHttpSimpleReadData($hRequest [, $iMode = Default ])
; Parameters ....: $hRequest - request handle after _WinHttpReceiveResponse
;                  $iMode         - [optional] type of data returned
;                  |0 - ASCII-String
;                  |1 - UTF-8-String
;                  |2 - binary data
; Return values .: Success      - String or binary depending on $iMode
;                  Failure      - empty string or empty binary (mode 2) and set @error
;                  |1 - invalid mode
;                  |2 - no data available
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......: In case of default reading mode, if the server specifies utf-8 content type, function will force UTF-8 string.
; Related .......: _WinHttpReadData, _WinHttpSimpleRequest, _WinHttpSimpleSSLRequest
; ===============================================================================================================================
Func _WinHttpSimpleReadData($hRequest, $iMode = Default)
	If $iMode = Default Then
		$iMode = 0
		If __WinHttpCharSet(_WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_CONTENT_TYPE)) = 65001 Then $iMode = 1 ; header suggest utf-8
	Else
		__WinHttpDefault($iMode, 0)
	EndIf
	If $iMode > 2 Or $iMode < 0 Then Return SetError(1, 0, '')
	Local $vData = Binary('')
	If _WinHttpQueryDataAvailable($hRequest) Then
		Do
			$vData &= _WinHttpReadData($hRequest, 2)
		Until @error
		Switch $iMode
			Case 0
				Return BinaryToString($vData)
			Case 1
				Return BinaryToString($vData, 4)
			Case Else
				Return $vData
		EndSwitch
	EndIf
	Return SetError(2, 0, $vData)
EndFunc

Func __WinHttpCharSet($sContentType)
	Local $aContentType = StringRegExp($sContentType, "(?i).*?\Qcharset=\E(?U)([^ ]+)(;| |\Z)", 2)
	If Not @error Then $sContentType = $aContentType[1]
	If StringLeft($sContentType, 2) = "cp" Then Return Int(StringTrimLeft($sContentType, 2))
	If $sContentType = "utf-8" Then Return 65001
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpQueryHeaders
; Description ...: Retrieves header information associated with an HTTP request.
; Syntax.........: _WinHttpQueryHeaders($hRequest [, $iInfoLevel = Default [, $sName = Default [, $iIndex = Default ]]])
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest().
;                  $iInfoLevel - [optional] A combination of attribute and modifier flags. Default is $WINHTTP_QUERY_RAW_HEADERS_CRLF.
;                  $sName - [optional] Header name string. Default is $WINHTTP_HEADER_NAME_BY_INDEX.
;                  $iIndex - [optional] Index used to enumerate multiple headers with the same name
; Return values .: Success - Returns string that contains header.
;                          - @extended is set to the index of the next header
;                  Failure - Returns empty string and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Related .......: _WinHttpAddRequestHeaders, _WinHttpOpenRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384102.aspx
;============================================================================================
Func _WinHttpQueryHeaders($hRequest, $iInfoLevel = Default, $sName = Default, $iIndex = Default)
	__WinHttpDefault($iInfoLevel, $WINHTTP_QUERY_RAW_HEADERS_CRLF)
	__WinHttpDefault($sName, $WINHTTP_HEADER_NAME_BY_INDEX)
	__WinHttpDefault($iIndex, $WINHTTP_NO_HEADER_INDEX)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryHeaders", _
			"handle", $hRequest, _
			"dword", $iInfoLevel, _
			"wstr", $sName, _
			"wstr", "", _
			"dword*", 65536, _
			"dword*", $iIndex)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Return SetExtended($aCall[6], $aCall[4])
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpQueryDataAvailable
; Description ...: Returns the availability to be read with _WinHttpReadData().
; Syntax.........: _WinHttpQueryDataAvailable($hRequest)
; Parameters ....: $hRequest - handle returned by _WinHttpOpenRequest().
; Return values .: Success - Returns 1 if data is available.
;                          - Returns 0 if no data is available.
;                          - @extended receives the number of available bytes.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Remarks .......: _WinHttpReceiveResponse must have been called for this handle and completed before _WinHttpQueryDataAvailable is called.
; Related .......: _WinHttpOpenRequest, _WinHttpReadData, _WinHttpReceiveResponse
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384101.aspx
;============================================================================================
Func _WinHttpQueryDataAvailable($hRequest)
	Local $sReadType = "dword*"
	If BitAND(_WinHttpQueryOption(_WinHttpQueryOption(_WinHttpQueryOption($hRequest, $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_CONTEXT_VALUE), $WINHTTP_FLAG_ASYNC) Then $sReadType = "ptr"
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryDataAvailable", "handle", $hRequest, $sReadType, 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetExtended($aCall[2], $aCall[0])
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpQueryOption
; Description ...: Queries an Internet option on the specified handle.
; Syntax.........: _WinHttpQueryOption($hInternet, $iOption)
; Parameters ....: $hInternet - Handle on which to query information.
;                  $iOption - Internet option to query.
; Return values .: Success - Returns data containing requested information.
;                  Failure - Returns empty string and sets @error:
;                  |1 - Initial DllCall failed
;                  |2 - Main DllCall failed
; Author ........: trancexx
; Remarks .......: Type of the returned data varies on request.
; Related .......: _WinHttpSetOption
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384103.aspx
;============================================================================================
Func _WinHttpQueryOption($hInternet, $iOption)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"ptr", 0, _
			"dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, "")
	Local $iSize = $aCall[4]
	Local $tBuffer
	Switch $iOption
		Case $WINHTTP_OPTION_CONNECTION_INFO, $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_URL, $WINHTTP_OPTION_USERNAME, $WINHTTP_OPTION_USER_AGENT, _
				$WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT, $WINHTTP_OPTION_PASSPORT_COBRANDING_URL
			$tBuffer = DllStructCreate("wchar[" & $iSize + 1 & "]")
		Case $WINHTTP_OPTION_PARENT_HANDLE, $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_SERVER_CERT_CONTEXT
			$tBuffer = DllStructCreate("ptr")
		Case $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM, _
				$WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, $WINHTTP_OPTION_EXTENDED_ERROR, $WINHTTP_OPTION_HANDLE_TYPE, $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, _
				$WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURITY_FLAGS, $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT
			$tBuffer = DllStructCreate("int")
		Case $WINHTTP_OPTION_CONTEXT_VALUE
			$tBuffer = DllStructCreate("dword_ptr")
		Case Else
			$tBuffer = DllStructCreate("byte[" & $iSize & "]")
	EndSwitch
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"struct*", $tBuffer, _
			"dword*", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpReadData
; Description ...: Reads data from a handle opened by the _WinHttpOpenRequest() function.
; Syntax.........: _WinHttpReadData($hRequest [, $iMode = Default [, $iNumberOfBytesToRead = Default ]])
; Parameters ....: $hRequest - Valid handle returned from a previous call to _WinHttpOpenRequest().
;                  $iMode - [optional] Integer representing reading mode. Default is 0 (charset is decoded as it is ANSI).
;                  $iNumberOfBytesToRead - [optional] The number of bytes to read. Default is 8192 bytes.
; Return values .: Success - Returns data read.
;                          - @extended receives the number of bytes read.
;                  Special: Sets @error to -1 if no more data to read (end reached).
;                  Failure - Returns empty string and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx, ProgAndy
; Remarks .......: [[$iMode]] can have these values:
;                  |[[0]] - ANSI
;                  |[[1]] - UTF8
;                  |[[2]] - Binary
; Related .......: _WinHttpOpenRequest, _WinHttpWriteData
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384104.aspx
;============================================================================================
Func _WinHttpReadData($hRequest, $iMode = Default, $iNumberOfBytesToRead = Default, $pBuffer = Default)
	__WinHttpDefault($iMode, 0)
	__WinHttpDefault($iNumberOfBytesToRead, 8192)
	Local $tBuffer, $vOutOnError = ""
	If $iMode = 2 Then $vOutOnError = Binary($vOutOnError)
	Switch $iMode
		Case 1, 2
			If $pBuffer And $pBuffer <> Default Then
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]", $pBuffer)
			Else
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]")
			EndIf
		Case Else
			$iMode = 0
			If $pBuffer And $pBuffer <> Default Then
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]", $pBuffer)
			Else
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]")
			EndIf
	EndSwitch
	Local $sReadType = "dword*"
	If BitAND(_WinHttpQueryOption(_WinHttpQueryOption(_WinHttpQueryOption($hRequest, $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_CONTEXT_VALUE), $WINHTTP_FLAG_ASYNC) Then $sReadType = "ptr"
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReadData", _
			"handle", $hRequest, _
			"struct*", $tBuffer, _
			"dword", $iNumberOfBytesToRead, _
			$sReadType, 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	If Not $aCall[4] Then Return SetError(-1, 0, $vOutOnError)
	If $aCall[4] < $iNumberOfBytesToRead Then
		Switch $iMode
			Case 0
				Return SetExtended($aCall[4], StringLeft(DllStructGetData($tBuffer, 1), $aCall[4]))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]), 4))
			Case 2
				Return SetExtended($aCall[4], BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]))
		EndSwitch
	Else
		Switch $iMode
			Case 0, 2
				Return SetExtended($aCall[4], DllStructGetData($tBuffer, 1))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(DllStructGetData($tBuffer, 1), 4))
		EndSwitch
	EndIf
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpCloseHandle
; Description ...: Closes a single handle.
; Syntax.........: _WinHttpCloseHandle($hInternet)
; Parameters ....: $hInternet - Valid handle to be closed.
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed
; Author ........: trancexx
; Related .......: _WinHttpConnect, _WinHttpOpen, _WinHttpOpenRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384090.aspx
;============================================================================================
Func _WinHttpCloseHandle($hInternet)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCloseHandle", "handle", $hInternet)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
#EndRegion WinHttp