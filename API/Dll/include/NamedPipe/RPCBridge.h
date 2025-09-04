#pragma once

#include "NamedPipe/NamedPipeServer.h"
#include <unordered_map>
#include <memory>
#include <functional>
#include <mutex>
#include <queue>
#include <chrono>
#include <future>

namespace GW {

    // Function signature information
    struct FunctionSignature {
        std::string name;
        uintptr_t address;
        uint8_t param_count;
        CallConvention convention;
        bool has_return;

        FunctionSignature() : address(0), param_count(0),
            convention(CONV_STDCALL), has_return(false) {
        }
    };

    // Memory allocation info
    struct MemoryBlock {
        uintptr_t address;
        size_t size;
        DWORD original_protection;

        MemoryBlock() : address(0), size(0), original_protection(0) {}
    };

    // Event structure for callbacks
    struct EventData {
        uint32_t event_id;
        uint32_t timestamp;
        uint32_t data_size;
        uint8_t data[256];
    };

    // Event buffer for communication with AutoIt
    struct EventBuffer {
        std::string name;
        uintptr_t address;
        size_t size;
        size_t max_events;
        std::queue<EventData> pending_events;
    };

    class RPCBridge {
    private:
        static RPCBridge* instance;
        static std::once_flag init_flag;

        // Function registry
        std::unordered_map<std::string, FunctionSignature> functions;
        std::mutex functions_mutex;

        // Memory allocations
        std::unordered_map<uintptr_t, MemoryBlock> allocations;
        std::mutex allocations_mutex;

        // Hook registry
        std::unordered_map<std::string, uintptr_t> hooks;
        std::mutex hooks_mutex;

        // Event buffers
        std::unordered_map<std::string, EventBuffer> event_buffers;
        std::mutex events_mutex;

        // Internal methods
        bool HandleScannerRequest(const PipeRequest& request, PipeResponse& response);
        bool HandleFunctionRequest(const PipeRequest& request, PipeResponse& response);
        bool HandleMemoryRequest(const PipeRequest& request, PipeResponse& response);
        bool HandleHookRequest(const PipeRequest& request, PipeResponse& response);
        bool HandleEventRequest(const PipeRequest& request, PipeResponse& response);
        bool HandleServerControlRequest(const PipeRequest& request, PipeResponse& response);
        bool HandleDLLControlRequest(const PipeRequest& request, PipeResponse& response);

        // Function calling helpers
        bool CallCdecl(const FunctionSignature& func, const FunctionParam* params, void* result);
        bool CallStdcall(const FunctionSignature& func, const FunctionParam* params, void* result);
        bool CallFastcall(const FunctionSignature& func, const FunctionParam* params, void* result);
        bool CallThiscall(const FunctionSignature& func, const FunctionParam* params, void* result);

        struct PendingCall {
            std::function<bool()> func;
            std::promise<bool> promise;
            void* result_ptr;
            std::chrono::steady_clock::time_point timeout;
        };

        // Queue for pending calls with thread-safety
        std::queue<std::shared_ptr<PendingCall>> pending_calls;
        std::mutex pending_calls_mutex;

    public:
        RPCBridge();
        ~RPCBridge();

        // Singleton (thread-safe)
        static RPCBridge& GetInstance();
        static void Destroy();

        // Main request handler
        bool HandleRequest(const PipeRequest& request, PipeResponse& response);

        // Function registry
        bool RegisterFunction(const char* name, uintptr_t address,
            uint8_t param_count, CallConvention conv, bool has_return);
        bool UnregisterFunction(const char* name);
        bool CallFunction(const char* name, const FunctionParam* params,
            uint8_t param_count, void* result);
        std::vector<std::string> ListFunctions();

        // Memory management (with validation)
        uintptr_t AllocateMemory(size_t size, DWORD protection);
        bool FreeMemory(uintptr_t address);
        bool WriteMemory(uintptr_t address, const void* data, size_t size);
        bool ProtectMemory(uintptr_t address, size_t size, DWORD protection);

        // Hook management (with validation)
        bool InstallHook(const char* name, uintptr_t target, uintptr_t detour);
        bool RemoveHook(const char* name);
        bool EnableHook(const char* name);
        bool DisableHook(const char* name);

        // Event management
        bool RegisterEventBuffer(const char* name, uintptr_t buffer, size_t size, size_t max_events);
        bool UnregisterEventBuffer(const char* name);
        void PushEvent(const char* buffer_name, uint32_t event_id, const void* data, size_t data_size);
        size_t GetPendingEvents(const char* buffer_name, EventData* out_events, size_t max_count);

        // Process pending function calls (must be called from game thread)
        void ProcessPendingCalls();
    };
}