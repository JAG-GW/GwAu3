#include "NamedPipe/RPCBridge.h"
#include "Utilities/Scanner.h"
#include "Utilities/Debug.h"
#include <MinHook.h>
#include <algorithm>
#include <queue>
#include <memory>
#include <future>
#include <chrono>
#include <vector>

namespace GW {

    // Constants for validation
    static constexpr size_t MAX_WRITE_SIZE = 0x10000;  // 64KB max write
    static constexpr size_t MAX_ALLOC_SIZE = 0x100000; // 1MB max allocation

    RPCBridge* RPCBridge::instance = nullptr;
    std::once_flag RPCBridge::init_flag;

    RPCBridge::RPCBridge() {
        LOG_INFO("RPCBridge initialized");
    }

    RPCBridge::~RPCBridge() {
        // Clean up all allocations
        for (auto& alloc : allocations) {
            VirtualFree((LPVOID)alloc.second.address, 0, MEM_RELEASE);
        }
        allocations.clear();

        // Clean up hooks
        for (auto& hook : hooks) {
            MH_RemoveHook((LPVOID)hook.second);
        }
        hooks.clear();

        LOG_INFO("RPCBridge destroyed");
    }

    RPCBridge& RPCBridge::GetInstance() {
        std::call_once(init_flag, []() {
            instance = new RPCBridge();
            });
        return *instance;
    }

    void RPCBridge::Destroy() {
        if (instance) {
            delete instance;
            instance = nullptr;
        }
    }

    bool RPCBridge::HandleRequest(const PipeRequest& request, PipeResponse& response) {
        memset(&response, 0, sizeof(response));

        try {
            switch (request.type) {
                // Scanner operations
            case SCAN_FIND:
            case SCAN_FIND_ASSERTION:
            case SCAN_FIND_IN_RANGE:
            case SCAN_TO_FUNCTION_START:
            case SCAN_FUNCTION_FROM_NEAR_CALL:
            case READ_MEMORY:
            case GET_SECTION_INFO:
                return HandleScannerRequest(request, response);

                // Function operations
            case REGISTER_FUNCTION:
            case UNREGISTER_FUNCTION:
            case CALL_FUNCTION:
            case LIST_FUNCTIONS:
                return HandleFunctionRequest(request, response);

                // Memory operations
            case ALLOCATE_MEMORY:
            case FREE_MEMORY:
            case WRITE_MEMORY:
            case PROTECT_MEMORY:
                return HandleMemoryRequest(request, response);

                // Hook operations
            case INSTALL_HOOK:
            case REMOVE_HOOK:
            case ENABLE_HOOK:
            case DISABLE_HOOK:
                return HandleHookRequest(request, response);

                // Event operations
            case GET_PENDING_EVENTS:
            case REGISTER_EVENT_BUFFER:
            case UNREGISTER_EVENT_BUFFER:
                return HandleEventRequest(request, response);

            default:
                strcpy_s(response.error_message, "Unknown request type");
                return false;
            }
        }
        catch (const std::exception& e) {
            strcpy_s(response.error_message, e.what());
            return false;
        }
        catch (...) {
            strcpy_s(response.error_message, "Unknown exception");
            return false;
        }
    }

    bool RPCBridge::HandleScannerRequest(const PipeRequest& request, PipeResponse& response) {
        // Scanner requests are handled by NamedPipeServer for backward compatibility
        response.success = 0;
        strcpy_s(response.error_message, "Scanner requests should be handled by NamedPipeServer");
        return false;
    }

    bool RPCBridge::HandleFunctionRequest(const PipeRequest& request, PipeResponse& response) {
        switch (request.type) {
        case REGISTER_FUNCTION: {
            // Validate input
            if (!request.register_func.address) {
                strcpy_s(response.error_message, "Invalid function address");
                response.success = 0;
                return true;
            }

            bool result = RegisterFunction(
                request.register_func.name,
                request.register_func.address,
                request.register_func.param_count,
                request.register_func.convention,
                request.register_func.has_return != 0
            );
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to register function");
            }
            break;
        }

        case UNREGISTER_FUNCTION: {
            bool result = UnregisterFunction(request.call_func.name);
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Function not found");
            }
            break;
        }

        case CALL_FUNCTION: {
            void* result_buffer = nullptr;
            int32_t int_result = 0;

            // Determine result buffer based on function signature
            {
                std::lock_guard<std::mutex> lock(functions_mutex);
                auto it = functions.find(request.call_func.name);
                if (it != functions.end() && it->second.has_return) {
                    result_buffer = &int_result;
                }
            }

            bool result = CallFunction(
                request.call_func.name,
                request.call_func.params,
                request.call_func.param_count,
                result_buffer
            );

            response.success = result ? 1 : 0;
            if (result && result_buffer) {
                response.call_result.has_return = 1;
                response.call_result.return_value.int_val = int_result;
            }
            else if (!result) {
                strcpy_s(response.error_message, "Function call failed");
            }
            break;
        }

        case LIST_FUNCTIONS: {
            std::lock_guard<std::mutex> lock(functions_mutex);
            response.function_list.count = 0;

            size_t i = 0;
            for (const auto& func : functions) {
                if (i >= 20) break;  // Max 20 functions in response
                strcpy_s(response.function_list.names[i], func.first.c_str());
                i++;
            }
            response.function_list.count = i;
            response.success = 1;
            break;
        }

        default:
            return false;
        }

        return true;
    }

    bool RPCBridge::HandleMemoryRequest(const PipeRequest& request, PipeResponse& response) {
        switch (request.type) {
        case ALLOCATE_MEMORY: {
            // Validate size
            if (request.memory.size == 0 || request.memory.size > MAX_ALLOC_SIZE) {
                strcpy_s(response.error_message, "Invalid allocation size");
                response.success = 0;
                return true;
            }

            uintptr_t addr = AllocateMemory(request.memory.size, request.memory.protection);
            response.memory_result.address = addr;
            response.memory_result.size = request.memory.size;
            response.success = (addr != 0) ? 1 : 0;
            if (!addr) {
                strcpy_s(response.error_message, "Memory allocation failed");
            }
            break;
        }

        case FREE_MEMORY: {
            // Validate address
            if (!request.memory.address) {
                strcpy_s(response.error_message, "Invalid memory address");
                response.success = 0;
                return true;
            }

            bool result = FreeMemory(request.memory.address);
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to free memory");
            }
            break;
        }

        case WRITE_MEMORY: {
            // Validate parameters
            if (!request.memory.address || request.memory.size == 0 ||
                request.memory.size > MAX_WRITE_SIZE) {
                strcpy_s(response.error_message, "Invalid write parameters");
                response.success = 0;
                return true;
            }

            bool result = WriteMemory(
                request.memory.address,
                request.memory.data,
                request.memory.size
            );
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to write memory");
            }
            break;
        }

        case PROTECT_MEMORY: {
            // Validate parameters
            if (!request.memory.address || request.memory.size == 0) {
                strcpy_s(response.error_message, "Invalid protect parameters");
                response.success = 0;
                return true;
            }

            bool result = ProtectMemory(
                request.memory.address,
                request.memory.size,
                request.memory.protection
            );
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to protect memory");
            }
            break;
        }

        default:
            return false;
        }

        return true;
    }

    bool RPCBridge::HandleHookRequest(const PipeRequest& request, PipeResponse& response) {
        switch (request.type) {
        case INSTALL_HOOK: {
            // Validate addresses
            if (!request.hook.target || !request.hook.detour) {
                strcpy_s(response.error_message, "Invalid hook addresses");
                response.success = 0;
                return true;
            }

            bool result = InstallHook(
                request.hook.name,
                request.hook.target,
                request.hook.detour
            );
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to install hook");
            }
            break;
        }

        case REMOVE_HOOK: {
            bool result = RemoveHook(request.hook.name);
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to remove hook");
            }
            break;
        }

        case ENABLE_HOOK: {
            bool result = EnableHook(request.hook.name);
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to enable hook");
            }
            break;
        }

        case DISABLE_HOOK: {
            bool result = DisableHook(request.hook.name);
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to disable hook");
            }
            break;
        }

        default:
            return false;
        }

        return true;
    }

    bool RPCBridge::HandleEventRequest(const PipeRequest& request, PipeResponse& response) {
        switch (request.type) {
        case REGISTER_EVENT_BUFFER: {
            // Validate parameters
            if (!request.event.buffer_address || request.event.buffer_size == 0) {
                strcpy_s(response.error_message, "Invalid event buffer parameters");
                response.success = 0;
                return true;
            }

            bool result = RegisterEventBuffer(
                request.event.name,
                request.event.buffer_address,
                request.event.buffer_size,
                request.event.max_events
            );
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to register event buffer");
            }
            break;
        }

        case UNREGISTER_EVENT_BUFFER: {
            bool result = UnregisterEventBuffer(request.event.name);
            response.success = result ? 1 : 0;
            if (!result) {
                strcpy_s(response.error_message, "Failed to unregister event buffer");
            }
            break;
        }

        case GET_PENDING_EVENTS: {
            EventData events[10];  // Max 10 events per request
            size_t count = GetPendingEvents(request.event.name, events, 10);

            response.event_data.event_count = count;
            if (count > 0) {
                memcpy(response.event_data.events, events, sizeof(EventData) * count);
            }
            response.success = 1;
            break;
        }

        default:
            return false;
        }

        return true;
    }

    bool RPCBridge::RegisterFunction(const char* name, uintptr_t address,
        uint8_t param_count, CallConvention conv, bool has_return) {

        if (!name || !address) return false;

        // Validate address is executable
        MEMORY_BASIC_INFORMATION mbi;
        if (VirtualQuery((LPCVOID)address, &mbi, sizeof(mbi)) == 0) {
            LOG_ERROR("Invalid function address: 0x%X", address);
            return false;
        }

        if (!(mbi.Protect & (PAGE_EXECUTE | PAGE_EXECUTE_READ |
            PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY))) {
            LOG_ERROR("Address 0x%X is not executable", address);
            return false;
        }

        std::lock_guard<std::mutex> lock(functions_mutex);

        FunctionSignature sig;
        sig.name = name;
        sig.address = address;
        sig.param_count = param_count;
        sig.convention = conv;
        sig.has_return = has_return;

        functions[name] = sig;

        LOG_INFO("Registered function: %s at 0x%X (params: %d, conv: %d)",
            name, address, param_count, conv);

        return true;
    }

    bool RPCBridge::UnregisterFunction(const char* name) {
        if (!name) return false;

        std::lock_guard<std::mutex> lock(functions_mutex);

        auto it = functions.find(name);
        if (it == functions.end()) return false;

        functions.erase(it);
        LOG_INFO("Unregistered function: %s", name);

        return true;
    }

    bool RPCBridge::CallFunction(const char* name, const FunctionParam* params,
        uint8_t param_count, void* result) {

        if (!name) return false;

        LOG_INFO("CallFunction: %s (queued for game thread)", name);

        // Create pending call with timeout
        auto pending = std::make_shared<PendingCall>();
        pending->result_ptr = result;
        pending->timeout = std::chrono::steady_clock::now() + std::chrono::seconds(5);
        auto future = pending->promise.get_future();

        // Copy parameters
        std::vector<FunctionParam> params_copy;
        if (params && param_count > 0) {
            params_copy.assign(params, params + param_count);
        }

        // Capture function name
        std::string func_name(name);

        // Create execution function
        pending->func = [this, func_name, params_copy, pending]() -> bool {
            LOG_DEBUG("Executing %s in game thread", func_name.c_str());

            // Get function signature
            FunctionSignature sig;
            {
                std::lock_guard<std::mutex> lock(functions_mutex);
                auto it = functions.find(func_name);
                if (it == functions.end()) {
                    LOG_ERROR("Function %s not found", func_name.c_str());
                    return false;
                }
                sig = it->second;
            }

            // Validate parameters
            if (params_copy.size() != sig.param_count) {
                LOG_ERROR("Parameter count mismatch for %s", func_name.c_str());
                return false;
            }

            // Call function
            bool success = false;
            const FunctionParam* params_ptr = params_copy.empty() ? nullptr : params_copy.data();

            try {
                switch (sig.convention) {
                case CONV_CDECL:
                    success = CallCdecl(sig, params_ptr, pending->result_ptr);
                    break;
                case CONV_STDCALL:
                    success = CallStdcall(sig, params_ptr, pending->result_ptr);
                    break;
                case CONV_THISCALL:
                    success = CallThiscall(sig, params_ptr, pending->result_ptr);
                    break;
                case CONV_FASTCALL:
                    LOG_ERROR("Fastcall not implemented");
                    success = false;
                    break;
                default:
                    LOG_ERROR("Unknown calling convention: %d", sig.convention);
                    success = false;
                }
            }
            catch (...) {
                LOG_ERROR("Exception caught while calling %s", func_name.c_str());
                success = false;
            }

            return success;
            };

        // Add to queue
        {
            std::lock_guard<std::mutex> lock(pending_calls_mutex);

            // Check for expired calls and remove them
            auto now = std::chrono::steady_clock::now();
            while (!pending_calls.empty()) {
                auto& front = pending_calls.front();
                if (front->timeout < now) {
                    front->promise.set_value(false);
                    pending_calls.pop();
                }
                else {
                    break;
                }
            }

            pending_calls.push(pending);
        }

        // Wait for result with timeout
        auto status = future.wait_for(std::chrono::seconds(5));

        if (status == std::future_status::ready) {
            bool success = future.get();
            LOG_INFO("Function %s returned: %s", name, success ? "success" : "failure");
            return success;
        }
        else {
            LOG_ERROR("Timeout waiting for function %s", name);
            return false;
        }
    }

    void RPCBridge::ProcessPendingCalls() {
        std::queue<std::shared_ptr<PendingCall>> calls_to_process;

        // Get pending calls with timeout check
        {
            std::lock_guard<std::mutex> lock(pending_calls_mutex);

            auto now = std::chrono::steady_clock::now();

            while (!pending_calls.empty()) {
                auto& front = pending_calls.front();

                // Check timeout
                if (front->timeout < now) {
                    // Timeout - fail the call
                    front->promise.set_value(false);
                    pending_calls.pop();
                }
                else {
                    // Move to processing queue
                    calls_to_process.push(front);
                    pending_calls.pop();
                }
            }
        }

        // Process calls
        while (!calls_to_process.empty()) {
            auto call = calls_to_process.front();
            calls_to_process.pop();

            try {
                bool result = call->func();
                call->promise.set_value(result);
            }
            catch (const std::exception& e) {
                LOG_ERROR("Exception in pending call: %s", e.what());
                call->promise.set_value(false);
            }
            catch (...) {
                LOG_ERROR("Unknown exception in pending call");
                call->promise.set_value(false);
            }
        }
    }

    bool RPCBridge::CallStdcall(const FunctionSignature& func,
        const FunctionParam* params, void* result) {

        // Validate and convert parameters
        uintptr_t args[10] = { 0 };
        for (int i = 0; i < func.param_count && i < 10; i++) {
            switch (params[i].type) {
            case PARAM_INT8:
            case PARAM_INT16:
            case PARAM_INT32:
                args[i] = params[i].int32_val;
                break;
            case PARAM_POINTER:
                args[i] = params[i].ptr_val;
                break;
            case PARAM_FLOAT:
                args[i] = *(uintptr_t*)&params[i].float_val;
                break;
            case PARAM_STRING:
                args[i] = (uintptr_t)params[i].string_val;
                break;
            case PARAM_WSTRING:
                args[i] = (uintptr_t)params[i].wstring_val;
                break;
            default:
                LOG_ERROR("Unsupported parameter type: %d", params[i].type);
                return false;
            }
        }

        // Call function based on parameter count with SEH protection
        __try {
            uintptr_t retval = 0;
            switch (func.param_count) {
            case 0: {
                typedef uintptr_t(__stdcall* Func0)();
                retval = ((Func0)func.address)();
                break;
            }
            case 1: {
                typedef uintptr_t(__stdcall* Func1)(uintptr_t);
                retval = ((Func1)func.address)(args[0]);
                break;
            }
            case 2: {
                typedef uintptr_t(__stdcall* Func2)(uintptr_t, uintptr_t);
                retval = ((Func2)func.address)(args[0], args[1]);
                break;
            }
            case 3: {
                typedef uintptr_t(__stdcall* Func3)(uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func3)func.address)(args[0], args[1], args[2]);
                break;
            }
            case 4: {
                typedef uintptr_t(__stdcall* Func4)(uintptr_t, uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func4)func.address)(args[0], args[1], args[2], args[3]);
                break;
            }
            case 5: {
                typedef uintptr_t(__stdcall* Func5)(uintptr_t, uintptr_t, uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func5)func.address)(args[0], args[1], args[2], args[3], args[4]);
                break;
            }
            case 6: {
                typedef uintptr_t(__stdcall* Func6)(uintptr_t, uintptr_t, uintptr_t, uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func6)func.address)(args[0], args[1], args[2], args[3], args[4], args[5]);
                break;
            }
            default:
                LOG_ERROR("Too many parameters: %d (max 6)", func.param_count);
                return false;
            }

            if (result && func.has_return) {
                *(uintptr_t*)result = retval;
            }
            return true;
        }
        __except (GetExceptionCode() == EXCEPTION_ACCESS_VIOLATION ?
            EXCEPTION_EXECUTE_HANDLER : EXCEPTION_CONTINUE_SEARCH) {
            LOG_ERROR("Access violation calling stdcall function at 0x%X", func.address);
            return false;
        }
    }

    bool RPCBridge::CallCdecl(const FunctionSignature& func,
        const FunctionParam* params, void* result) {

        // Convert parameters
        uintptr_t args[10] = { 0 };
        for (int i = 0; i < func.param_count && i < 10; i++) {
            switch (params[i].type) {
            case PARAM_INT8:
            case PARAM_INT16:
            case PARAM_INT32:
                args[i] = params[i].int32_val;
                break;
            case PARAM_POINTER:
                args[i] = params[i].ptr_val;
                break;
            case PARAM_FLOAT:
                args[i] = *(uintptr_t*)&params[i].float_val;
                break;
            case PARAM_STRING:
                args[i] = (uintptr_t)params[i].string_val;
                break;
            case PARAM_WSTRING:
                args[i] = (uintptr_t)params[i].wstring_val;
                break;
            default:
                return false;
            }
        }

        // Call function with cdecl convention with SEH protection
        __try {
            uintptr_t retval = 0;
            switch (func.param_count) {
            case 0: {
                typedef uintptr_t(__cdecl* Func0)();
                retval = ((Func0)func.address)();
                break;
            }
            case 1: {
                typedef uintptr_t(__cdecl* Func1)(uintptr_t);
                retval = ((Func1)func.address)(args[0]);
                break;
            }
            case 2: {
                typedef uintptr_t(__cdecl* Func2)(uintptr_t, uintptr_t);
                retval = ((Func2)func.address)(args[0], args[1]);
                break;
            }
            case 3: {
                typedef uintptr_t(__cdecl* Func3)(uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func3)func.address)(args[0], args[1], args[2]);
                break;
            }
            case 4: {
                typedef uintptr_t(__cdecl* Func4)(uintptr_t, uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func4)func.address)(args[0], args[1], args[2], args[3]);
                break;
            }
            case 5: {
                typedef uintptr_t(__cdecl* Func5)(uintptr_t, uintptr_t, uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func5)func.address)(args[0], args[1], args[2], args[3], args[4]);
                break;
            }
            default:
                LOG_ERROR("Too many parameters: %d (max 5)", func.param_count);
                return false;
            }

            if (result && func.has_return) {
                *(uintptr_t*)result = retval;
            }
            return true;
        }
        __except (GetExceptionCode() == EXCEPTION_ACCESS_VIOLATION ?
            EXCEPTION_EXECUTE_HANDLER : EXCEPTION_CONTINUE_SEARCH) {
            LOG_ERROR("Access violation calling cdecl function at 0x%X", func.address);
            return false;
        }
    }

    bool RPCBridge::CallThiscall(const FunctionSignature& func,
        const FunctionParam* params, void* result) {

        // Validate this pointer
        if (func.param_count < 1) {
            LOG_ERROR("Thiscall requires at least 1 parameter (this pointer)");
            return false;
        }

        uintptr_t args[10] = { 0 };
        for (int i = 0; i < func.param_count && i < 10; i++) {
            switch (params[i].type) {
            case PARAM_INT32:
                args[i] = params[i].int32_val;
                break;
            case PARAM_POINTER:
                args[i] = params[i].ptr_val;
                break;
            default:
                args[i] = params[i].int32_val;
                break;
            }
        }

        // Validate this pointer
        if (!args[0] || IsBadReadPtr((void*)args[0], sizeof(void*))) {
            LOG_ERROR("Invalid this pointer: 0x%X", args[0]);
            return false;
        }

        // Call thiscall function with SEH protection
        __try {
            uintptr_t retval = 0;
            switch (func.param_count) {
            case 1: {
                typedef uintptr_t(__thiscall* Func1)(uintptr_t);
                retval = ((Func1)func.address)(args[0]);
                break;
            }
            case 2: {
                typedef uintptr_t(__thiscall* Func2)(uintptr_t, uintptr_t);
                retval = ((Func2)func.address)(args[0], args[1]);
                break;
            }
            case 3: {
                typedef uintptr_t(__thiscall* Func3)(uintptr_t, uintptr_t, uintptr_t);
                retval = ((Func3)func.address)(args[0], args[1], args[2]);
                break;
            }
            default:
                LOG_ERROR("Invalid parameter count for thiscall: %d", func.param_count);
                return false;
            }

            if (result && func.has_return) {
                *(uintptr_t*)result = retval;
            }
            return true;
        }
        __except (GetExceptionCode() == EXCEPTION_ACCESS_VIOLATION ?
            EXCEPTION_EXECUTE_HANDLER : EXCEPTION_CONTINUE_SEARCH) {
            LOG_ERROR("Access violation calling thiscall function at 0x%X", func.address);
            return false;
        }
    }

    bool RPCBridge::CallFastcall(const FunctionSignature& func,
        const FunctionParam* params, void* result) {
        // Fastcall is rarely used in Guild Wars
        // Implementation would require assembly or compiler intrinsics
        LOG_ERROR("Fastcall not implemented (rarely used in GW)");
        return false;
    }

    uintptr_t RPCBridge::AllocateMemory(size_t size, DWORD protection) {
        // Validate size
        if (size == 0 || size > MAX_ALLOC_SIZE) {
            LOG_ERROR("Invalid allocation size: %zu", size);
            return 0;
        }

        void* addr = VirtualAlloc(NULL, size, MEM_COMMIT | MEM_RESERVE, protection);
        if (!addr) {
            LOG_ERROR("VirtualAlloc failed: %lu", GetLastError());
            return 0;
        }

        std::lock_guard<std::mutex> lock(allocations_mutex);

        MemoryBlock block;
        block.address = (uintptr_t)addr;
        block.size = size;
        block.original_protection = protection;

        allocations[block.address] = block;

        LOG_INFO("Allocated %zu bytes at 0x%X", size, block.address);
        return block.address;
    }

    bool RPCBridge::FreeMemory(uintptr_t address) {
        if (!address) return false;

        std::lock_guard<std::mutex> lock(allocations_mutex);

        auto it = allocations.find(address);
        if (it == allocations.end()) {
            LOG_ERROR("Address 0x%X not found in allocations", address);
            return false;
        }

        bool result = VirtualFree((LPVOID)address, 0, MEM_RELEASE) != 0;
        if (result) {
            allocations.erase(it);
            LOG_INFO("Freed memory at 0x%X", address);
        }
        else {
            LOG_ERROR("VirtualFree failed: %lu", GetLastError());
        }

        return result;
    }

    bool RPCBridge::WriteMemory(uintptr_t address, const void* data, size_t size) {
        // Validate parameters
        if (!address || !data || size == 0 || size > MAX_WRITE_SIZE) {
            LOG_ERROR("Invalid write parameters: addr=0x%X, size=%zu", address, size);
            return false;
        }

        // Check if address is writable
        if (IsBadWritePtr((LPVOID)address, size)) {
            LOG_ERROR("Address 0x%X is not writable for size %zu", address, size);
            return false;
        }

        DWORD oldProtect;
        if (!VirtualProtect((LPVOID)address, size, PAGE_EXECUTE_READWRITE, &oldProtect)) {
            LOG_ERROR("VirtualProtect failed: %lu", GetLastError());
            return false;
        }

        memcpy((void*)address, data, size);

        VirtualProtect((LPVOID)address, size, oldProtect, &oldProtect);

        LOG_INFO("Wrote %zu bytes to 0x%X", size, address);
        return true;
    }

    bool RPCBridge::ProtectMemory(uintptr_t address, size_t size, DWORD protection) {
        // Validate parameters
        if (!address || size == 0) {
            LOG_ERROR("Invalid protect parameters: addr=0x%X, size=%zu", address, size);
            return false;
        }

        // Check if address is valid
        MEMORY_BASIC_INFORMATION mbi;
        if (VirtualQuery((LPCVOID)address, &mbi, sizeof(mbi)) == 0) {
            LOG_ERROR("VirtualQuery failed for address 0x%X", address);
            return false;
        }

        DWORD oldProtect;
        bool result = VirtualProtect((LPVOID)address, size, protection, &oldProtect) != 0;

        if (result) {
            LOG_INFO("Protected memory at 0x%X with 0x%X", address, protection);
        }
        else {
            LOG_ERROR("VirtualProtect failed: %lu", GetLastError());
        }

        return result;
    }

    bool RPCBridge::InstallHook(const char* name, uintptr_t target, uintptr_t detour) {
        if (!name || !target || !detour) {
            LOG_ERROR("Invalid hook parameters");
            return false;
        }

        // Validate target is executable
        MEMORY_BASIC_INFORMATION mbi;
        if (VirtualQuery((LPCVOID)target, &mbi, sizeof(mbi)) == 0) {
            LOG_ERROR("Invalid target address: 0x%X", target);
            return false;
        }

        if (!(mbi.Protect & (PAGE_EXECUTE | PAGE_EXECUTE_READ |
            PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY))) {
            LOG_ERROR("Target address 0x%X is not executable", target);
            return false;
        }

        std::lock_guard<std::mutex> lock(hooks_mutex);

        // Check if hook already exists
        if (hooks.find(name) != hooks.end()) {
            LOG_ERROR("Hook %s already exists", name);
            return false;
        }

        // Create hook using MinHook
        if (MH_CreateHook((LPVOID)target, (LPVOID)detour, nullptr) != MH_OK) {
            LOG_ERROR("Failed to create hook %s", name);
            return false;
        }

        // Enable hook
        if (MH_EnableHook((LPVOID)target) != MH_OK) {
            MH_RemoveHook((LPVOID)target);
            LOG_ERROR("Failed to enable hook %s", name);
            return false;
        }

        hooks[name] = target;
        LOG_INFO("Installed hook %s: 0x%X -> 0x%X", name, target, detour);

        return true;
    }

    bool RPCBridge::RemoveHook(const char* name) {
        if (!name) return false;

        std::lock_guard<std::mutex> lock(hooks_mutex);

        auto it = hooks.find(name);
        if (it == hooks.end()) {
            LOG_ERROR("Hook %s not found", name);
            return false;
        }

        MH_DisableHook((LPVOID)it->second);
        MH_RemoveHook((LPVOID)it->second);

        hooks.erase(it);
        LOG_INFO("Removed hook %s", name);

        return true;
    }

    bool RPCBridge::EnableHook(const char* name) {
        if (!name) return false;

        std::lock_guard<std::mutex> lock(hooks_mutex);

        auto it = hooks.find(name);
        if (it == hooks.end()) {
            LOG_ERROR("Hook %s not found", name);
            return false;
        }

        bool result = MH_EnableHook((LPVOID)it->second) == MH_OK;
        if (result) {
            LOG_INFO("Enabled hook %s", name);
        }
        else {
            LOG_ERROR("Failed to enable hook %s", name);
        }

        return result;
    }

    bool RPCBridge::DisableHook(const char* name) {
        if (!name) return false;

        std::lock_guard<std::mutex> lock(hooks_mutex);

        auto it = hooks.find(name);
        if (it == hooks.end()) {
            LOG_ERROR("Hook %s not found", name);
            return false;
        }

        bool result = MH_DisableHook((LPVOID)it->second) == MH_OK;
        if (result) {
            LOG_INFO("Disabled hook %s", name);
        }
        else {
            LOG_ERROR("Failed to disable hook %s", name);
        }

        return result;
    }

    std::vector<std::string> RPCBridge::ListFunctions() {
        std::lock_guard<std::mutex> lock(functions_mutex);
        std::vector<std::string> names;

        for (const auto& func : functions) {
            names.push_back(func.first);
        }

        return names;
    }

    bool RPCBridge::RegisterEventBuffer(const char* name, uintptr_t buffer, size_t size, size_t max_events) {
        if (!name || !buffer || size == 0) {
            LOG_ERROR("Invalid event buffer parameters");
            return false;
        }

        // Validate buffer is writable
        if (IsBadWritePtr((LPVOID)buffer, size)) {
            LOG_ERROR("Event buffer at 0x%X is not writable", buffer);
            return false;
        }

        std::lock_guard<std::mutex> lock(events_mutex);

        EventBuffer eb;
        eb.name = name;
        eb.address = buffer;
        eb.size = size;
        eb.max_events = max_events > 0 ? max_events : 100;

        event_buffers[name] = eb;

        LOG_INFO("Registered event buffer: %s at 0x%X", name, buffer);
        return true;
    }

    bool RPCBridge::UnregisterEventBuffer(const char* name) {
        if (!name) return false;

        std::lock_guard<std::mutex> lock(events_mutex);

        auto it = event_buffers.find(name);
        if (it == event_buffers.end()) {
            LOG_ERROR("Event buffer %s not found", name);
            return false;
        }

        event_buffers.erase(it);
        LOG_INFO("Unregistered event buffer: %s", name);

        return true;
    }

    void RPCBridge::PushEvent(const char* buffer_name, uint32_t event_id, const void* data, size_t data_size) {
        if (!buffer_name) return;

        std::lock_guard<std::mutex> lock(events_mutex);

        auto it = event_buffers.find(buffer_name);
        if (it == event_buffers.end()) return;

        EventData event;
        event.event_id = event_id;
        event.timestamp = GetTickCount();
        event.data_size = (data_size < sizeof(event.data)) ? data_size : sizeof(event.data);

        if (data && data_size > 0) {
            memcpy(event.data, data, event.data_size);
        }

        // Add to queue
        it->second.pending_events.push(event);

        // Limit queue size
        while (it->second.pending_events.size() > it->second.max_events) {
            it->second.pending_events.pop();
        }
    }

    size_t RPCBridge::GetPendingEvents(const char* buffer_name, EventData* out_events, size_t max_count) {
        if (!buffer_name || !out_events || max_count == 0) return 0;

        std::lock_guard<std::mutex> lock(events_mutex);

        auto it = event_buffers.find(buffer_name);
        if (it == event_buffers.end()) return 0;

        size_t count = 0;
        while (!it->second.pending_events.empty() && count < max_count) {
            out_events[count] = it->second.pending_events.front();
            it->second.pending_events.pop();
            count++;
        }

        return count;
    }
}