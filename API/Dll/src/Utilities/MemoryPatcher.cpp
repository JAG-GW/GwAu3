#include "Headers.h"

#include <Utilities/Debug.h>
#include <Utilities/MemoryPatcher.h>

namespace {
    std::vector<GW::MemoryPatcher*> patches;

    bool patching_enabled = true;
}

namespace GW {
    MemoryPatcher::~MemoryPatcher() {
        ASSERT(!(patching_enabled && IsValid() && GetIsActive()));
    }

    void MemoryPatcher::EnableHooks() {
        if (patching_enabled)
            return;
        patching_enabled = true;
        for (auto p : patches) {
            if (!(p->IsValid() && p->GetIsActive())) {
                continue;
            }
            p->PatchActual(true);
        }
    }
    void MemoryPatcher::DisableHooks() {
        if (!patching_enabled)
            return;
        for (auto p : patches) {
            if (!(p->IsValid() && p->GetIsActive())) {
                continue;
            }
            p->PatchActual(false);
        }
        patching_enabled = false;
    }

    void MemoryPatcher::Reset() {
        if (GetIsActive())
            TogglePatch(false);

        if (m_patch) {
            delete[] m_patch;
            m_patch = nullptr;
        }
        if (m_backup) {
            delete[] m_backup;
            m_backup = nullptr;
        }

        m_addr = nullptr;
        m_size = 0;
        m_active = false;

        patches.erase(std::remove(patches.begin(), patches.end(), this), patches.end());
    }

    bool MemoryPatcher::IsValid() {
        return m_addr != nullptr;
    }

    void MemoryPatcher::SetPatch(uintptr_t addr, const char *patch, size_t size) {
        Reset();
#ifdef _DEBUG
        ASSERT(!IsValid());
#endif
        if (IsValid()) return;

        m_addr = reinterpret_cast<void *>(addr);
        m_size = size;
        m_active = false;

        m_patch = new uint8_t[size];
        m_backup = new uint8_t[size];
        memcpy(m_patch, patch, size);

        DWORD old_prot;
        VirtualProtect(m_addr, m_size, PAGE_EXECUTE_READWRITE, &old_prot);
        memcpy(m_backup, m_addr, m_size);
        VirtualProtect(m_addr, m_size, old_prot, &old_prot);

        patches.push_back(this);
    }

    void MemoryPatcher::PatchActual(bool patch) {
#ifdef _DEBUG
        ASSERT(IsValid());
#endif
        if (!IsValid()) return;

        if (!patching_enabled)
            return;
        DWORD old_prot;
        VirtualProtect(m_addr, m_size, PAGE_EXECUTE_READWRITE, &old_prot);
        memcpy(m_addr, patch ? m_patch : m_backup, m_size);
        VirtualProtect(m_addr, m_size, old_prot, &old_prot);
    }

    bool MemoryPatcher::SetRedirect(uintptr_t call_instruction_address, void* redirect_func) {
        ASSERT(!IsValid());
        if (!(call_instruction_address && redirect_func))
            return false;
        if (((*(uintptr_t*)call_instruction_address) & 0x000000e8) != 0x000000e8
            && ((*(uintptr_t*)call_instruction_address) & 0x000000e9) != 0x000000e9)
            return false; // Not a near call instruction

        char instruction_type = (char)((*(uintptr_t*)call_instruction_address) & 0x000000ff);
        switch (instruction_type) {
        case '\xe8': // Near call
        case '\xe9': // Jump call
            break;
        default: // Other instructions not supported
            return false;
        }
        // Figure out the offset from the target address to the destination function
        uintptr_t call_offset = ((uintptr_t)redirect_func) - call_instruction_address - 5;
        const char patch[5] = { instruction_type, (char)(call_offset), (char)(call_offset >> 8), (char)(call_offset >> 16), (char)(call_offset >> 24) };

        // Go through usual channels to set the patch
        SetPatch(call_instruction_address, patch, 5);
        return true;
    }

    bool MemoryPatcher::TogglePatch(bool flag) {
#ifdef _DEBUG
//        ASSERT(IsValid());
#endif
        if (!IsValid()) return false;
        m_active = flag;
        PatchActual(m_active);
        return flag;
    }
}
