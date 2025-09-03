#pragma once

#include <atomic>

namespace GW {

    // DLL State Management
    enum class DllState {
        Initializing,
        Running,
        ShuttingDown,
        Stopped
    };

    // Global state (defined in dllentry.cpp)
    extern std::atomic<DllState> g_dllState;

    // Helper functions
    inline bool IsDllRunning() {
        return g_dllState.load() == DllState::Running;
    }

    inline bool IsDllShuttingDown() {
        auto state = g_dllState.load();
        return state == DllState::ShuttingDown || state == DllState::Stopped;
    }

    inline void RequestShutdown() {
        DllState expected = DllState::Running;
        g_dllState.compare_exchange_strong(expected, DllState::ShuttingDown);
    }

} // namespace GW