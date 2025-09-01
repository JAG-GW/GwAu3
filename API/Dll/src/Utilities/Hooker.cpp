#include "Headers.h"

#include <MinHook.h>
#include <Utilities/Hooker.h>
#include <Utilities/Debug.h>
#include <Utilities/Scanner.h>

static std::atomic<int> init_count;
static std::atomic<int> in_hook_count;

void GW::HookBase::Initialize()
{
    ++init_count;
    MH_Initialize();
}

void GW::HookBase::Deinitialize()
{
    if (--init_count == 0)
        MH_Uninitialize();
}

void GW::HookBase::EnterHook()
{
    ++in_hook_count;
}

void GW::HookBase::LeaveHook()
{
    --in_hook_count;
}

int GW::HookBase::GetInHookCount()
{
    return in_hook_count;
}

void GW::HookBase::EnableHooks(void *target)
{
    if (!target)
        target = MH_ALL_HOOKS;
    MH_EnableHook(target);
}

void GW::HookBase::DisableHooks(void *target)
{
    if (!target)
        target = MH_ALL_HOOKS;
    MH_DisableHook(target);
}

int GW::HookBase::CreateHook(void** target, void* detour, void** trampoline)
{
    if (!(target && *target))
        return -1;
    if (const auto nested = Scanner::FunctionFromNearCall(*(uintptr_t*)target, false))
        *target = (void*)nested;
    return MH_CreateHook(*target, detour, trampoline);
}

void GW::HookBase::RemoveHook(void *target)
{
    if(target)
        MH_RemoveHook(target);
}
