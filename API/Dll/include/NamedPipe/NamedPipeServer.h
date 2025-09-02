#pragma once

#include <Windows.h>
#include <string>
#include <thread>
#include <atomic>
#include <functional>

namespace GW {

#pragma pack(push, 1)  // Force 1-byte alignment

    // ==================================
    // Protocol Definitions
    // ==================================

    // Request types
    enum RequestType {
        // Scanner operations
        SCAN_FIND = 1,
        SCAN_FIND_ASSERTION = 2,
        SCAN_FIND_IN_RANGE = 3,
        SCAN_TO_FUNCTION_START = 4,
        SCAN_FUNCTION_FROM_NEAR_CALL = 5,
        READ_MEMORY = 6,
        GET_SECTION_INFO = 7,

        // Function Registry operations
        REGISTER_FUNCTION = 10,
        UNREGISTER_FUNCTION = 11,
        CALL_FUNCTION = 12,
        LIST_FUNCTIONS = 13,

        // Memory Manager operations
        ALLOCATE_MEMORY = 20,
        FREE_MEMORY = 21,
        WRITE_MEMORY = 22,
        PROTECT_MEMORY = 23,

        // Hook operations
        INSTALL_HOOK = 30,
        REMOVE_HOOK = 31,
        ENABLE_HOOK = 32,
        DISABLE_HOOK = 33,

        // Event operations
        GET_PENDING_EVENTS = 40,
        REGISTER_EVENT_BUFFER = 41,
        UNREGISTER_EVENT_BUFFER = 42
    };

    // Parameter types for function calls
    enum ParamType : uint8_t {
        PARAM_INT8 = 1,
        PARAM_INT16 = 2,
        PARAM_INT32 = 3,
        PARAM_INT64 = 4,
        PARAM_FLOAT = 5,
        PARAM_DOUBLE = 6,
        PARAM_POINTER = 7,
        PARAM_STRING = 8,     // ANSI string
        PARAM_WSTRING = 9     // Wide string
    };

    // Calling conventions
    enum CallConvention : uint8_t {
        CONV_CDECL = 1,
        CONV_STDCALL = 2,
        CONV_FASTCALL = 3,
        CONV_THISCALL = 4
    };

    // Function parameter structure
    struct FunctionParam {
        ParamType type;
        uint8_t padding[3];
        union {
            int8_t int8_val;
            int16_t int16_val;
            int32_t int32_val;
            int64_t int64_val;
            float float_val;
            double double_val;
            uintptr_t ptr_val;
            char string_val[256];
            wchar_t wstring_val[128];
        };
    };

    // Request structure for client->server communication
    struct PipeRequest {
        RequestType type;

        union {
            // Scanner operations
            struct {
                uint8_t pattern[256];  // Utiliser uint8_t au lieu de char
                char mask[256];        // Le masque reste char car il n'a que 'x' et '?'
                int32_t offset;
                uint8_t section;
                uint8_t pattern_length;  // AJOUT: longueur réelle du pattern
                uint8_t padding1[2];     // Ajuster le padding
            } scan;

            struct {
                char assertion_file[256];
                char assertion_msg[256];
                uint32_t line_number;
                int32_t offset;
            } assertion;

            struct {
                uint32_t start_address;
                uint32_t end_address;
                uint8_t pattern[256];      // MISE À JOUR: uint8_t au lieu de char
                char mask[256];
                int32_t offset;
                uint8_t pattern_length;    // AJOUT: longueur du pattern
                uint8_t padding[3];        // Padding
            } range;

            // Function registry
            struct {
                char name[64];
                uintptr_t address;
                uint8_t param_count;
                CallConvention convention;
                uint8_t has_return;
                uint8_t padding[1];
            } register_func;

            struct {
                char name[64];
                uint8_t param_count;
                uint8_t padding[3];
                FunctionParam params[10];  // Max 10 params
            } call_func;

            // Memory operations
            struct {
                uintptr_t address;
                uint32_t size;
                uint32_t protection;
                uint8_t data[1024];
            } memory;

            // Hook operations
            struct {
                char name[64];
                uintptr_t target;
                uintptr_t detour;
                uint32_t length;
            } hook;

            // Event operations
            struct {
                char name[64];
                uintptr_t buffer_address;
                uint32_t buffer_size;
                uint32_t max_events;
            } event;
        };
    };

    // Response structure for server->client communication
    struct PipeResponse {
        uint8_t success;
        uint8_t padding[3];

        union {
            // Scanner result
            struct {
                uintptr_t address;
            } scan_result;

            // Function call result
            struct {
                uint8_t has_return;
                uint8_t padding[3];
                union {
                    int32_t int_val;
                    float float_val;
                    uintptr_t ptr_val;
                } return_value;
            } call_result;

            // Memory result
            struct {
                uintptr_t address;
                uint32_t size;
                uint8_t data[1024];
            } memory_result;

            // Function list
            struct {
                uint32_t count;
                char names[20][64];  // Max 20 function names
            } function_list;

            // Section info
            struct {
                uintptr_t start;
                uintptr_t end;
            } section_info;

            // Event data
            struct {
                uint32_t event_count;
                uint8_t events[1024];  // Raw event data
            } event_data;
        };

        char error_message[256];
    };

    // Legacy structures for backward compatibility
    typedef PipeRequest ScanRequest;
    typedef PipeResponse ScanResponse;

#pragma pack(pop)  // Restore default alignment

    // ==================================
    // Named Pipe Server Class
    // ==================================

    class NamedPipeServer {
    private:
        static NamedPipeServer* instance;

        HANDLE hPipe;
        std::thread serverThread;
        std::atomic<bool> running;
        std::string pipeName;

        // Internal methods
        void ServerLoop();
        void ProcessClient(HANDLE clientPipe);
        void HandleRequest(const PipeRequest& request, PipeResponse& response);

        // Helper for hex pattern parsing
        bool ParseHexPattern(const char* hexStr, std::string& outPattern);

    public:
        NamedPipeServer();
        ~NamedPipeServer();

        // Singleton
        static NamedPipeServer& GetInstance();
        static void Destroy();

        // Server control
        bool Start(const std::string& pipeName = "\\\\.\\pipe\\GWToolsPipe");
        void Stop();
        bool IsRunning() const { return running.load(); }

        // Optional callbacks for logging
        std::function<void(const std::string&)> OnLog;
        std::function<void(const std::string&)> OnError;
        std::function<void(const std::string&)> OnClientConnected;
        std::function<void(const std::string&)> OnClientDisconnected;
    };
}