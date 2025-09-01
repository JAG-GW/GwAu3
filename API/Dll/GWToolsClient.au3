; ==================================
; GWTools RPC Client for Guild Wars
; ==================================
; Version: 2.0
; Compatible avec le NamedPipeServer étendu

#include <WinAPI.au3>
#include <Memory.au3>
#include <Array.au3>
#include <Misc.au3>

Global Const $PIPE_NAME = "\\.\pipe\GWToolsPipe"
Global $g_hPipe = 0
Global $g_ProcessHandle = 0

; ==================================
; Request Types Constants
; ==================================

; Scanner Operations (1-10)
Global Enum $RPC_SCAN_FIND = 1, _
    $RPC_SCAN_FIND_ASSERTION = 2, _
    $RPC_SCAN_FIND_IN_RANGE = 3, _
    $RPC_SCAN_TO_FUNCTION_START = 4, _
    $RPC_SCAN_FROM_NEAR_CALL = 5, _
    $RPC_READ_MEMORY = 6, _
    $RPC_GET_SECTION_INFO = 7

; Function Registry (100-110)
Global Enum $RPC_REGISTER_FUNCTION = 100, _
    $RPC_UNREGISTER_FUNCTION = 101, _
    $RPC_LIST_FUNCTIONS = 102, _
    $RPC_CALL_FUNCTION = 103, _
    $RPC_CALL_FUNCTION_ASYNC = 104, _
    $RPC_GET_FUNCTION_INFO = 105

; Memory Operations (200-210)
Global Enum $RPC_WRITE_MEMORY = 200, _
    $RPC_ALLOCATE_MEMORY = 201, _
    $RPC_FREE_MEMORY = 202, _
    $RPC_PROTECT_MEMORY = 203, _
    $RPC_QUERY_MEMORY = 204

; Hook Operations (300-310)
Global Enum $RPC_CREATE_HOOK = 300, _
    $RPC_REMOVE_HOOK = 301, _
    $RPC_ENABLE_HOOK = 302, _
    $RPC_DISABLE_HOOK = 303

; Utility (400+)
Global Enum $RPC_GET_PROCESS_INFO = 400, _
    $RPC_GET_MODULE_INFO = 401, _
    $RPC_GET_EXTENDED_STATUS = 402, _
    $RPC_EXECUTE_SHELLCODE = 403, _
    $RPC_PING = 500, _
    $RPC_SHUTDOWN = 501

; Calling Conventions
Global Enum $CALL_CDECL = 0, _
    $CALL_STDCALL = 1, _
    $CALL_FASTCALL = 2, _
    $CALL_THISCALL = 3

; Scanner Sections
Global Enum $SECTION_TEXT = 0, _
    $SECTION_RDATA = 1, _
    $SECTION_DATA = 2

; Memory Protection
Global Const $PAGE_EXECUTE_READWRITE = 0x40
Global Const $PAGE_EXECUTE_READ = 0x20
Global Const $PAGE_READWRITE = 0x04
Global Const $PAGE_READONLY = 0x02

; ==================================
; Connection Functions
; ==================================

Func ConnectToPipe()
    ; Ouvrir le pipe
    $g_hPipe = _WinAPI_CreateFile($PIPE_NAME, 2, 6, 0, 3, 0, 0)

    If $g_hPipe = -1 Then
        ConsoleWrite("[ERROR] Failed to connect to pipe" & @CRLF)
        Return False
    EndIf

    ; Définir le mode du pipe
    Local $tMode = DllStructCreate("dword Mode")
    DllStructSetData($tMode, "Mode", 2) ; PIPE_READMODE_MESSAGE

    Local $aResult = DllCall("kernel32.dll", "bool", "SetNamedPipeHandleState", _
        "handle", $g_hPipe, _
        "ptr", DllStructGetPtr($tMode), _
        "ptr", 0, _
        "ptr", 0)

    ConsoleWrite("[SUCCESS] Connected to RPC server" & @CRLF)
    Return True
EndFunc

Func DisconnectFromPipe()
    If $g_hPipe Then
        _WinAPI_CloseHandle($g_hPipe)
        $g_hPipe = 0
        ConsoleWrite("[INFO] Disconnected from RPC server" & @CRLF)
    EndIf
EndFunc

; ==================================
; Core RPC Communication
; ==================================

Func SendRequest($type, ByRef $request)
    If Not $g_hPipe Then
        ConsoleWrite("[ERROR] Not connected to pipe" & @CRLF)
        Return False
    EndIf

    ; Définir le type de requête
    DllStructSetData($request, "type", $type)

    ; Envoyer la requête
    Local $bytesWritten = 0
    Local $success = _WinAPI_WriteFile($g_hPipe, DllStructGetPtr($request), _
        DllStructGetSize($request), $bytesWritten)

    If Not $success Then
        ConsoleWrite("[ERROR] Failed to send request" & @CRLF)
        Return False
    EndIf

    ; Lire la réponse
    Local $tResponse = DllStructCreate( _
        "byte success;" & _
        "byte padding1[3];" & _
        "ptr result;" & _
        "char error_message[256];" & _
        "byte data[4096];" & _
        "dword data_size;" & _
        "ptr section_start;" & _
        "ptr section_end;" & _
        "char text_data[2048]")

    Local $bytesRead = 0
    $success = _WinAPI_ReadFile($g_hPipe, DllStructGetPtr($tResponse), _
        DllStructGetSize($tResponse), $bytesRead)

    If Not $success Then
        ConsoleWrite("[ERROR] Failed to read response" & @CRLF)
        Return False
    EndIf

    Return $tResponse
EndFunc

; ==================================
; Scanner Functions
; ==================================

Func ScanPattern($pattern, $mask = "", $offset = 0, $section = $SECTION_TEXT)
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "pattern", $pattern)
    DllStructSetData($tRequest, "mask", $mask)
    DllStructSetData($tRequest, "offset", $offset)
    DllStructSetData($tRequest, "section", $section)

    Local $tResponse = SendRequest($RPC_SCAN_FIND, $tRequest)
    If Not $tResponse Then Return 0

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return 0
    EndIf

    Return DllStructGetData($tResponse, "result")
EndFunc

Func ScanAssertion($file, $msg, $line = 0, $offset = 0)
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "assertion_file", $file)
    DllStructSetData($tRequest, "assertion_msg", $msg)
    DllStructSetData($tRequest, "line_number", $line)
    DllStructSetData($tRequest, "offset", $offset)

    Local $tResponse = SendRequest($RPC_SCAN_FIND_ASSERTION, $tRequest)
    If Not $tResponse Then Return 0

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return 0
    EndIf

    Return DllStructGetData($tResponse, "result")
EndFunc

; ==================================
; Function Registry
; ==================================

Func RegisterFunction($name, $address, $convention = $CALL_CDECL, $paramCount = 0, $description = "")
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "function_name", $name)
    DllStructSetData($tRequest, "address", $address)
    DllStructSetData($tRequest, "calling_convention", $convention)
    DllStructSetData($tRequest, "param_count", $paramCount)
    DllStructSetData($tRequest, "pattern", $description) ; Utiliser pattern pour la description

    Local $tResponse = SendRequest($RPC_REGISTER_FUNCTION, $tRequest)
    If Not $tResponse Then Return False

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return False
    EndIf

    ConsoleWrite("[SUCCESS] Function '" & $name & "' registered at 0x" & Hex($address) & @CRLF)
    Return True
EndFunc

Func CallFunction($name, $params = "")
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "function_name", $name)

    ; Formater les paramètres (séparés par |)
    If IsArray($params) Then
        Local $paramStr = ""
        For $i = 0 To UBound($params) - 1
            If $i > 0 Then $paramStr &= "|"
            $paramStr &= $params[$i]
        Next
        DllStructSetData($tRequest, "pattern", $paramStr)
    Else
        DllStructSetData($tRequest, "pattern", $params)
    EndIf

    Local $tResponse = SendRequest($RPC_CALL_FUNCTION, $tRequest)
    If Not $tResponse Then Return 0

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return 0
    EndIf

    Return DllStructGetData($tResponse, "result")
EndFunc

Func ListFunctions()
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    Local $tResponse = SendRequest($RPC_LIST_FUNCTIONS, $tRequest)
    If Not $tResponse Then Return ""

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return ""
    EndIf

    Return DllStructGetData($tResponse, "text_data")
EndFunc

Func GetFunctionInfo($name)
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "function_name", $name)

    Local $tResponse = SendRequest($RPC_GET_FUNCTION_INFO, $tRequest)
    If Not $tResponse Then Return ""

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return ""
    EndIf

    Return DllStructGetData($tResponse, "text_data")
EndFunc

; ==================================
; Memory Operations
; ==================================

Func RPCAllocateMemory($size, $protection = $PAGE_EXECUTE_READWRITE)
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "size", $size)
    DllStructSetData($tRequest, "protection", $protection)

    Local $tResponse = SendRequest($RPC_ALLOCATE_MEMORY, $tRequest)
    If Not $tResponse Then Return 0

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return 0
    EndIf

    Local $addr = DllStructGetData($tResponse, "result")
    ConsoleWrite("[SUCCESS] Allocated " & $size & " bytes at 0x" & Hex($addr) & @CRLF)
    Return $addr
EndFunc

Func RPCFreeMemory($address)
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "address", $address)

    Local $tResponse = SendRequest($RPC_FREE_MEMORY, $tRequest)
    If Not $tResponse Then Return False

    Return DllStructGetData($tResponse, "success") = 1
EndFunc

Func RPCWriteMemory($address, $data, $size)
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "address", $address)
    DllStructSetData($tRequest, "size", $size)
    DllStructSetData($tRequest, "pattern", $data)

    Local $tResponse = SendRequest($RPC_WRITE_MEMORY, $tRequest)
    If Not $tResponse Then Return False

    Return DllStructGetData($tResponse, "success") = 1
EndFunc

Func RPCReadMemory($address, $size)
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    DllStructSetData($tRequest, "address", $address)
    DllStructSetData($tRequest, "size", $size)

    Local $tResponse = SendRequest($RPC_READ_MEMORY, $tRequest)
    If Not $tResponse Then Return ""

    If DllStructGetData($tResponse, "success") = 0 Then
        ConsoleWrite("[ERROR] " & DllStructGetData($tResponse, "error_message") & @CRLF)
        Return ""
    EndIf

    Local $dataSize = DllStructGetData($tResponse, "data_size")
    Local $data = DllStructCreate("byte[" & $dataSize & "]", DllStructGetPtr($tResponse, "data"))
    Return DllStructGetData($data, 1)
EndFunc

; ==================================
; Direct Memory Access (Process)
; ==================================

Func AttachToGuildWars()
    ; Trouver le processus Guild Wars
    Local $pid = ProcessExists("Gw.exe")
    If Not $pid Then
        ConsoleWrite("[ERROR] Guild Wars not found" & @CRLF)
        Return False
    EndIf

    ; Ouvrir le processus
    $g_ProcessHandle = _WinAPI_OpenProcess(0x1F0FFF, False, $pid)
    If Not $g_ProcessHandle Then
        ConsoleWrite("[ERROR] Failed to open Guild Wars process" & @CRLF)
        Return False
    EndIf

    ConsoleWrite("[SUCCESS] Attached to Guild Wars (PID: " & $pid & ")" & @CRLF)
    Return True
EndFunc

Func ReadMemory($address, $type = "dword")
    If Not $g_ProcessHandle Then Return 0

    Local $buffer = DllStructCreate($type)
    _WinAPI_ReadProcessMemory($g_ProcessHandle, $address, DllStructGetPtr($buffer), DllStructGetSize($buffer), 0)

    Return DllStructGetData($buffer, 1)
EndFunc

Func WriteMemory($address, $value, $type = "dword")
    If Not $g_ProcessHandle Then Return False

    Local $buffer = DllStructCreate($type)
    DllStructSetData($buffer, 1, $value)

    Return _WinAPI_WriteProcessMemory($g_ProcessHandle, $address, DllStructGetPtr($buffer), DllStructGetSize($buffer), 0)
EndFunc

Func ReadWString($address, $maxLength = 256)
    If Not $g_ProcessHandle Then Return ""

    Local $buffer = DllStructCreate("wchar[" & $maxLength & "]")
    _WinAPI_ReadProcessMemory($g_ProcessHandle, $address, DllStructGetPtr($buffer), DllStructGetSize($buffer), 0)

    Return DllStructGetData($buffer, 1)
EndFunc

; ==================================
; Utility Functions
; ==================================

Func GetExtendedStatus()
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    Local $tResponse = SendRequest($RPC_GET_EXTENDED_STATUS, $tRequest)
    If Not $tResponse Then Return ""

    Return DllStructGetData($tResponse, "text_data")
EndFunc

Func _Ping()
    Local $tRequest = DllStructCreate( _
        "dword type;" & _
        "char pattern[256];" & _
        "char mask[256];" & _
        "int offset;" & _
        "byte section;" & _
        "byte padding1[3];" & _
        "char assertion_file[256];" & _
        "char assertion_msg[256];" & _
        "dword line_number;" & _
        "dword start_address;" & _
        "dword end_address;" & _
        "ptr address;" & _
        "dword size;" & _
        "ptr call_address;" & _
        "dword scan_range;" & _
        "byte check_valid_ptr;" & _
        "byte padding2[3];" & _
        "char function_name[128];" & _
        "dword calling_convention;" & _
        "dword param_count;" & _
        "dword protection")

    Local $tResponse = SendRequest($RPC_PING, $tRequest)
    If Not $tResponse Then Return False

    Return DllStructGetData($tResponse, "text_data") = "PONG"
EndFunc

; ==================================
; Guild Wars Specific
; ==================================

Global $g_FriendListAddr = 0
Global $g_AddFriendFunc = 0
Global $g_RemoveFriendFunc = 0
Global $g_SetStatusFunc = 0

Func InitializeGuildWars()
    ConsoleWrite("==================================" & @CRLF)
    ConsoleWrite("Initializing Guild Wars..." & @CRLF)
    ConsoleWrite("==================================" & @CRLF)

    ; Connecter au serveur RPC
    If Not ConnectToPipe() Then Return False

    ; Attacher au processus
    If Not AttachToGuildWars() Then
        DisconnectFromPipe()
        Return False
    EndIf

    ; Test de connexion
    If Not _Ping() Then
        ConsoleWrite("[ERROR] Ping failed" & @CRLF)
        Return False
    EndIf
    ConsoleWrite("[SUCCESS] Ping OK" & @CRLF)

    ; Scanner les adresses importantes
    ConsoleWrite(@CRLF & "Scanning for Guild Wars functions..." & @CRLF)

    ; Trouver FriendList
    Local $addr = ScanAssertion("FriendApi.cpp", "friendName && *friendName", 0, 0)
    If $addr Then
        ConsoleWrite("[SCAN] Found assertion at: 0x" & Hex($addr) & @CRLF)
        ; Chercher le pattern suivant
        $addr = ScanPattern("\x57\xB9", "xx", 2, $SECTION_TEXT)
        If $addr Then
            $g_FriendListAddr = ReadMemory($addr)
            ConsoleWrite("[SUCCESS] FriendList at: 0x" & Hex($g_FriendListAddr) & @CRLF)
        EndIf
    EndIf

    ; Trouver AddFriend
    $addr = ScanPattern("\x8B\x75\x10\x83\xFE\x03\x74\x65", "xxxxxxxx")
    If $addr Then
        $g_AddFriendFunc = $addr
        ConsoleWrite("[SUCCESS] AddFriend at: 0x" & Hex($g_AddFriendFunc) & @CRLF)
        RegisterFunction("AddFriend", $g_AddFriendFunc, $CALL_CDECL, 3, "Add a friend to the list")
    EndIf

    ; Trouver SetOnlineStatus
    $addr = ScanPattern("\x83\xFE\x03\x77\x40\xFF\x24\xB5", "xxxxxxxx")
    If $addr Then
        $g_SetStatusFunc = $addr
        ConsoleWrite("[SUCCESS] SetOnlineStatus at: 0x" & Hex($g_SetStatusFunc) & @CRLF)
        RegisterFunction("SetOnlineStatus", $g_SetStatusFunc, $CALL_CDECL, 1, "Set online status")
    EndIf

    ConsoleWrite(@CRLF & "[SUCCESS] Guild Wars initialized!" & @CRLF)
    Return True
EndFunc

Func AddFriend($characterName, $alias = "")
    If Not $g_AddFriendFunc Then
        ConsoleWrite("[ERROR] AddFriend function not found" & @CRLF)
        Return False
    EndIf

    ; Allouer de la mémoire pour les strings
    Local $nameSize = (StringLen($characterName) + 1) * 2
    Local $aliasText = $alias ? $alias : $characterName
    Local $aliasSize = (StringLen($aliasText) + 1) * 2

    Local $nameAddr = RPCAllocateMemory($nameSize)
    Local $aliasAddr = RPCAllocateMemory($aliasSize)

    If Not $nameAddr Or Not $aliasAddr Then
        ConsoleWrite("[ERROR] Failed to allocate memory for strings" & @CRLF)
        Return False
    EndIf

    ; Écrire les strings en mémoire (format Unicode)
    Local $nameBuffer = StringToBinary($characterName, 2) ; 2 = UTF16LE
    Local $aliasBuffer = StringToBinary($aliasText, 2)

    RPCWriteMemory($nameAddr, BinaryToString($nameBuffer), $nameSize)
    RPCWriteMemory($aliasAddr, BinaryToString($aliasBuffer), $aliasSize)

    ; Appeler la fonction
    Local $params[3] = [$nameAddr, $aliasAddr, 1] ; 1 = Friend type
    Local $result = CallFunction("AddFriend", $params)

    ; Libérer la mémoire
    RPCFreeMemory($nameAddr)
    RPCFreeMemory($aliasAddr)

    ConsoleWrite("[INFO] AddFriend called with result: " & $result & @CRLF)
    Return $result
EndFunc

Func SetOnlineStatus($status)
    ; Status: 0=Offline, 1=Online, 2=Away, 3=DND
    If Not $g_SetStatusFunc Then
        ConsoleWrite("[ERROR] SetOnlineStatus function not found" & @CRLF)
        Return False
    EndIf

    Local $params[1] = [$status]
    Local $result = CallFunction("SetOnlineStatus", $params)

    ConsoleWrite("[INFO] Status set to: " & $status & @CRLF)
    Return $result
EndFunc

; ==================================
; Main Example
; ==================================

Func Main()
    ConsoleWrite("==================================" & @CRLF)
    ConsoleWrite("GWTools RPC Client v2.0" & @CRLF)
    ConsoleWrite("==================================" & @CRLF & @CRLF)

    ; Initialiser
    If Not InitializeGuildWars() Then
        ConsoleWrite("[FATAL] Failed to initialize" & @CRLF)
        Exit
    EndIf

    ; Afficher le statut
    ConsoleWrite(@CRLF & "Server Status:" & @CRLF)
    ConsoleWrite(GetExtendedStatus() & @CRLF)

    ; Lister les fonctions enregistrées
    ConsoleWrite(@CRLF & "Registered Functions:" & @CRLF)
    Local $functions = ListFunctions()
    Local $funcArray = StringSplit($functions, ";")
    For $i = 1 To $funcArray[0]
        If $funcArray[$i] <> "" Then
            ConsoleWrite("  - " & $funcArray[$i] & @CRLF)
        EndIf
    Next

    ; Menu interactif
    While True
        ConsoleWrite(@CRLF & "==================================" & @CRLF)
        ConsoleWrite("Commands:" & @CRLF)
        ConsoleWrite("1 - Add Friend" & @CRLF)
        ConsoleWrite("2 - Set Status" & @CRLF)
        ConsoleWrite("3 - Scan Pattern" & @CRLF)
        ConsoleWrite("4 - List Functions" & @CRLF)
        ConsoleWrite("5 - Get Function Info" & @CRLF)
        ConsoleWrite("6 - Test Memory Operations" & @CRLF)
        ConsoleWrite("7 - Server Status" & @CRLF)
        ConsoleWrite("0 - Exit" & @CRLF)
        ConsoleWrite("==================================" & @CRLF)

        Local $choice = InputBox("GWTools RPC", "Enter command (0-7):", "")

        Switch $choice
            Case "0"
                ExitLoop

            Case "1"
                Local $name = InputBox("Add Friend", "Character name:", "")
                If $name Then
                    Local $alias = InputBox("Add Friend", "Alias (optional):", $name)
                    AddFriend($name, $alias)
                EndIf

            Case "2"
                Local $status = InputBox("Set Status", "0=Offline, 1=Online, 2=Away, 3=DND:", "1")
                SetOnlineStatus(Number($status))

            Case "3"
                Local $pattern = InputBox("Pattern Scan", "Pattern (hex bytes):", "8B 0C 90")
                Local $mask = InputBox("Pattern Scan", "Mask (x=match, ?=skip):", "xxx")
                Local $result = ScanPattern($pattern, $mask)
                ConsoleWrite("Pattern found at: 0x" & Hex($result) & @CRLF)

            Case "4"
                ConsoleWrite(ListFunctions() & @CRLF)

            Case "5"
                Local $fname = InputBox("Function Info", "Function name:", "AddFriend")
                ConsoleWrite(GetFunctionInfo($fname) & @CRLF)

            Case "6"
                TestMemoryOperations()

            Case "7"
                ConsoleWrite(GetExtendedStatus() & @CRLF)
        EndSwitch
    WEnd

    ; Cleanup
    Cleanup()
EndFunc

Func TestMemoryOperations()
    ConsoleWrite(@CRLF & "Testing memory operations..." & @CRLF)

    ; Allouer 1KB
    Local $addr = RPCAllocateMemory(1024)
    If Not $addr Then
        ConsoleWrite("[ERROR] Allocation failed" & @CRLF)
        Return
    EndIf

    ; Écrire des données
    Local $testData = "Hello from AutoIt!"
    RPCWriteMemory($addr, $testData, StringLen($testData))
    ConsoleWrite("[SUCCESS] Wrote data to memory" & @CRLF)

    ; Lire les données
    Local $readData = RPCReadMemory($addr, StringLen($testData))
    ConsoleWrite("[SUCCESS] Read back: " & BinaryToString($readData) & @CRLF)

    ; Libérer
    RPCFreeMemory($addr)
    ConsoleWrite("[SUCCESS] Memory freed" & @CRLF)
EndFunc

Func Cleanup()
    ConsoleWrite(@CRLF & "Cleaning up..." & @CRLF)

    If $g_ProcessHandle Then
        _WinAPI_CloseHandle($g_ProcessHandle)
        $g_ProcessHandle = 0
    EndIf

    DisconnectFromPipe()

    ConsoleWrite("Goodbye!" & @CRLF)
EndFunc

; ==================================
; Point d'entrée
; ==================================

Main()