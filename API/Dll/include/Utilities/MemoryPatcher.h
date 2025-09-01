#pragma once

namespace GW {

    class MemoryPatcher {
    public:
        MemoryPatcher() = default;
        MemoryPatcher(const MemoryPatcher&) = delete;
        ~MemoryPatcher();

        void Reset();
        bool IsValid();
        void SetPatch(uintptr_t addr, const char* patch, size_t size);

        const void* GetAddress() { return m_addr; }

        // Use to redirect a CALL or JMP instruction to call a different function instead.
        bool SetRedirect(uintptr_t call_instruction_address, void* redirect_func);

        bool TogglePatch(bool flag);
        bool TogglePatch() { return TogglePatch(!m_active); };

        bool GetIsActive() { return m_active; };

        // Disconnect all patches from memory, restoring original values if applicable
        static void DisableHooks();
        // Connect any applicable patches that have been disconnected.
        static void EnableHooks();
    private:
        void       *m_addr = nullptr;
        uint8_t    *m_patch = nullptr;
        uint8_t    *m_backup = nullptr;
        size_t      m_size = 0;
        bool        m_active = false;

        void PatchActual(bool patch);
    };
}
