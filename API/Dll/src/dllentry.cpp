#include "Headers.h"
#include "Utilities/Debug.h"
#include "Utilities/Scanner.h"
#include "NamedPipe/NamedPipeServer.h"
#include "NamedPipe/NamedPipeUI.h"
#include <MinHook.h>
#include <d3d9.h>
#include <imgui.h>
#include <imgui_impl_dx9.h>
#include <imgui_impl_win32.h>

// ================================
// ImGui Integration
// ================================

// ImGui WndProc handler
extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

// ================================
// Global Variables
// ================================

// Thread management
HANDLE g_mainThread = nullptr;
std::atomic<bool> g_dllRunning(true);
std::atomic<bool> g_shutdownRequested(false);

// DirectX hooks
typedef HRESULT(WINAPI* EndScene_t)(IDirect3DDevice9*);
typedef HRESULT(WINAPI* Reset_t)(IDirect3DDevice9*, D3DPRESENT_PARAMETERS*);
EndScene_t g_EndScene_Original = nullptr;
Reset_t g_Reset_Original = nullptr;

// ImGui state
bool g_imguiInitialized = false;
bool g_showMainWindow = true;
HWND g_gameWindow = nullptr;
WNDPROC g_originalWndProc = nullptr;

// Feature toggles
bool g_showDebugConsole = false;

// Mouse tracking
static bool g_rightMouseDown = false;
static bool g_isDragging = false;
static bool g_isDraggingImgui = false;

//NamedPipe Server
GW::NamedPipeServer* g_pipeServer = nullptr;
GW::NamedPipeUI* g_pipeUI = nullptr;

// ================================
// WndProc Hook
// ================================

LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    // Handle shutdown
    if (msg == WM_CLOSE || (msg == WM_SYSCOMMAND && wParam == SC_CLOSE)) {
        g_shutdownRequested = true;
        return 0;
    }

    // Check if ImGui is initialized
    if (!g_dllRunning || !g_imguiInitialized) {
        return CallWindowProc(g_originalWndProc, hWnd, msg, wParam, lParam);
    }

    ImGuiIO& io = ImGui::GetIO();

    // Track right mouse button for camera control
    if (msg == WM_RBUTTONDOWN || msg == WM_RBUTTONDBLCLK) {
        g_rightMouseDown = true;
    }
    if (msg == WM_RBUTTONUP) {
        g_rightMouseDown = false;
    }

    // If right mouse is down, let GW handle camera
    if (g_rightMouseDown) {
        return CallWindowProc(g_originalWndProc, hWnd, msg, wParam, lParam);
    }

    // Handle left button dragging
    if (msg == WM_LBUTTONDOWN) {
        if (io.WantCaptureMouse) {
            g_isDragging = true;
            g_isDraggingImgui = true;
        }
        else {
            g_isDragging = true;
            g_isDraggingImgui = false;
            return CallWindowProc(g_originalWndProc, hWnd, msg, wParam, lParam);
        }
    }

    if (msg == WM_LBUTTONUP) {
        g_isDragging = false;
        g_isDraggingImgui = false;
    }

    // Handle ongoing drag
    if (g_isDragging) {
        if (g_isDraggingImgui) {
            ImGui_ImplWin32_WndProcHandler(hWnd, msg, wParam, lParam);
            return TRUE;
        }
        else {
            return CallWindowProc(g_originalWndProc, hWnd, msg, wParam, lParam);
        }
    }

    // Let ImGui process events
    ImGui_ImplWin32_WndProcHandler(hWnd, msg, wParam, lParam);

    // Block input if ImGui wants it
    if (io.WantCaptureMouse && (msg == WM_MOUSEMOVE || msg == WM_LBUTTONDOWN ||
        msg == WM_LBUTTONUP || msg == WM_RBUTTONDOWN || msg == WM_RBUTTONUP ||
        msg == WM_MOUSEWHEEL || msg == WM_MOUSEHWHEEL)) {
        return TRUE;
    }

    if (io.WantCaptureKeyboard && io.WantTextInput &&
        (msg == WM_KEYDOWN || msg == WM_KEYUP || msg == WM_CHAR)) {
        return TRUE;
    }

    // Pass to game
    return CallWindowProc(g_originalWndProc, hWnd, msg, wParam, lParam);
}

// Safe WndProc wrapper
LRESULT CALLBACK SafeWndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) noexcept {
    __try {
        return WndProc(hWnd, msg, wParam, lParam);
    }
    __except (EXCEPTION_EXECUTE_HANDLER) {
        return CallWindowProc(g_originalWndProc, hWnd, msg, wParam, lParam);
    }
}

// ================================
// ImGui Initialization
// ================================

bool InitImGui(IDirect3DDevice9* device) {
    if (g_imguiInitialized) return true;

    LOG_INFO("Initializing ImGui...");

    // Get window handle
    D3DDEVICE_CREATION_PARAMETERS params;
    if (FAILED(device->GetCreationParameters(&params))) {
        LOG_ERROR("Failed to get device parameters");
        return false;
    }

    g_gameWindow = params.hFocusWindow;
    if (!g_gameWindow) {
        LOG_ERROR("No focus window found");
        return false;
    }

    // Hook WndProc
    g_originalWndProc = (WNDPROC)SetWindowLongPtr(g_gameWindow, GWLP_WNDPROC, (LONG_PTR)SafeWndProc);

    // Create ImGui context
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
    io.ConfigFlags |= ImGuiConfigFlags_NoMouseCursorChange;

    // Setup style
    ImGui::StyleColorsDark();

    // Custom style adjustments
    ImGuiStyle& style = ImGui::GetStyle();
    style.WindowRounding = 5.0f;
    style.FrameRounding = 3.0f;
    style.ScrollbarRounding = 3.0f;
    style.GrabRounding = 3.0f;
    style.WindowTitleAlign = ImVec2(0.5f, 0.5f);

    // Init backends
    ImGui_ImplWin32_Init(g_gameWindow);
    ImGui_ImplDX9_Init(device);

    g_imguiInitialized = true;
    LOG_SUCCESS("ImGui initialized successfully");
    return true;
}

// ================================
// ImGui Cleanup
// ================================

void CleanupImGui() {
    if (!g_imguiInitialized) return;

    LOG_INFO("Cleaning up ImGui...");

    ImGui_ImplDX9_InvalidateDeviceObjects();
    ImGui_ImplDX9_Shutdown();
    ImGui_ImplWin32_Shutdown();

    if (ImGui::GetCurrentContext()) {
        ImGui::DestroyContext();
    }

    // Restore original WndProc
    if (g_originalWndProc && g_gameWindow && IsWindow(g_gameWindow)) {
        SetWindowLongPtr(g_gameWindow, GWLP_WNDPROC, (LONG_PTR)g_originalWndProc);
        g_originalWndProc = nullptr;
    }

    g_imguiInitialized = false;
    LOG_INFO("ImGui cleanup complete");
}

// ================================
// Main GUI Rendering
// ================================

void RenderMainWindow() {
    if (!g_showMainWindow) return;

    ImGui::SetNextWindowSize(ImVec2(500, 400), ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowPos(ImVec2(50, 50), ImGuiCond_FirstUseEver);

    if (ImGui::Begin("GWTools Enhanced", &g_showMainWindow, ImGuiWindowFlags_MenuBar)) {
        // Menu bar
        if (ImGui::BeginMenuBar()) {
            if (ImGui::BeginMenu("Windows")) {
                if (ImGui::MenuItem("Debug Console", "HOME", Debug::GetInstance().IsWindowVisible())) {
                    Debug::GetInstance().ToggleWindow();
                }

                // Menu for Named Pipe Server
                if (ImGui::MenuItem("Named Pipe Server", "F9", g_pipeUI && g_pipeUI->IsWindowVisible())) {
                    if (g_pipeUI) {
                        g_pipeUI->ToggleWindow();
                    }
                }

                ImGui::Separator();
                if (ImGui::MenuItem("Settings...")) {
                    // Open settings window
                }
                ImGui::EndMenu();
            }

            if (ImGui::BeginMenu("Help")) {
                if (ImGui::MenuItem("About...")) {
                    // Show about dialog
                }
                if (ImGui::MenuItem("Documentation")) {
                    // Open documentation
                }
                ImGui::EndMenu();
            }

            ImGui::EndMenuBar();
        }

        // Main content
        ImGui::Text("GWTools Enhanced DLL");
        ImGui::Text("Version: 1.0.0");
        ImGui::Separator();

        // System info
        ImGui::Text("Process ID: %d", GetCurrentProcessId());
        ImGui::Text("Thread ID: %d", GetCurrentThreadId());
        ImGui::Text("Main Thread: 0x%p", g_mainThread);

        ImGui::Separator();

        // Quick actions
        if (ImGui::Button("Toggle Debug Console")) {
            Debug::GetInstance().ToggleWindow();
        }

        // Button for Named Pipe Server
        ImGui::SameLine();
        if (ImGui::Button("Named Pipe Server")) {
            if (g_pipeUI) {
                g_pipeUI->ToggleWindow();
            }
        }

        // Server Status Indicator
        if (g_pipeUI) {
            ImGui::SameLine();
            bool serverRunning = g_pipeUI->IsServerRunning();
            ImVec4 statusColor = serverRunning ?
                ImVec4(0.0f, 1.0f, 0.0f, 1.0f) : ImVec4(1.0f, 0.0f, 0.0f, 1.0f);
            ImGui::TextColored(statusColor, "[%s]", serverRunning ? "PIPE ON" : "PIPE OFF");
        }

        ImGui::Separator();

        // Section Named Pipe Status
        if (ImGui::CollapsingHeader("Named Pipe Server")) {
            if (g_pipeUI) {
                bool isRunning = g_pipeUI->IsServerRunning();
                ImGui::Text("Status: %s", isRunning ? "Running" : "Stopped");

                if (isRunning) {
                    ImGui::Text("Pipe: \\\\.\\pipe\\GWToolsPipe");

                    if (ImGui::Button("Stop Server")) {
                        g_pipeUI->StopServer();
                    }
                }
                else {
                    if (ImGui::Button("Start Server")) {
                        g_pipeUI->StartServer();
                    }
                }

                ImGui::SameLine();
                if (ImGui::Button("Open Control Panel")) {
                    g_pipeUI->ToggleWindow();
                }
            }
            else {
                ImGui::Text("Named Pipe UI not initialized");
            }
        }

        ImGui::Separator();

        // Shutdown button
        if (ImGui::Button("Unload DLL", ImVec2(100, 30))) {
            if (ImGui::IsKeyDown(ImGuiKey_LeftShift)) {
                // Immediate shutdown with shift held
                g_shutdownRequested = true;
            }
            else {
                // Confirmation popup
                ImGui::OpenPopup("Confirm Shutdown");
            }
        }

        // Confirmation popup
        if (ImGui::BeginPopupModal("Confirm Shutdown", NULL, ImGuiWindowFlags_AlwaysAutoResize)) {
            ImGui::Text("Are you sure you want to unload the DLL?");
            ImGui::Separator();

            if (ImGui::Button("Yes", ImVec2(120, 0))) {
                g_shutdownRequested = true;
                ImGui::CloseCurrentPopup();
            }
            ImGui::SetItemDefaultFocus();
            ImGui::SameLine();
            if (ImGui::Button("No", ImVec2(120, 0))) {
                ImGui::CloseCurrentPopup();
            }
            ImGui::EndPopup();
        }
    }
    ImGui::End();
}

// ================================
// ImGui Render Function
// ================================

void RenderImGui() {
    ImGui_ImplDX9_NewFrame();
    ImGui_ImplWin32_NewFrame();
    ImGui::NewFrame();

    // Render main window
    RenderMainWindow();

    // Render debug console
    if (Debug::GetInstance().IsWindowVisible()) {
        Debug::GetInstance().Draw();
    }

    // Render Named Pipe UI
    if (g_pipeUI && g_pipeUI->IsWindowVisible()) {
        g_pipeUI->Draw();
    }

    // Check for shutdown
    if (!g_showMainWindow || g_shutdownRequested) {
        g_dllRunning = false;
    }

    ImGui::EndFrame();
    ImGui::Render();
    ImGui_ImplDX9_RenderDrawData(ImGui::GetDrawData());
}

// ================================
// DirectX Hooks
// ================================

HRESULT WINAPI OnEndScene(IDirect3DDevice9* device) {
    if (!g_dllRunning) {
        if (g_EndScene_Original) {
            return g_EndScene_Original(device);
        }
        return S_OK;
    }

    // Initialize ImGui on first call
    if (!g_imguiInitialized) {
        if (!InitImGui(device)) {
            return g_EndScene_Original(device);
        }
    }

    // Render ImGui
    if (g_imguiInitialized && g_dllRunning) {
        RenderImGui();
    }

    return g_EndScene_Original(device);
}

HRESULT WINAPI OnReset(IDirect3DDevice9* device, D3DPRESENT_PARAMETERS* params) {
    if (!g_dllRunning && g_Reset_Original) {
        return g_Reset_Original(device, params);
    }

    if (g_imguiInitialized) {
        ImGui_ImplDX9_InvalidateDeviceObjects();
    }

    HRESULT result = g_Reset_Original ? g_Reset_Original(device, params) : S_OK;

    if (g_imguiInitialized && g_dllRunning) {
        ImGui_ImplDX9_CreateDeviceObjects();
    }

    return result;
}

// ================================
// Get D3D9 VTable
// ================================

bool GetD3D9VTable(void** vtable, size_t size) {
    if (!vtable) return false;

    IDirect3D9* d3d = Direct3DCreate9(D3D_SDK_VERSION);
    if (!d3d) return false;

    IDirect3DDevice9* device = nullptr;
    D3DPRESENT_PARAMETERS params = {};
    params.Windowed = TRUE;
    params.SwapEffect = D3DSWAPEFFECT_DISCARD;
    params.BackBufferFormat = D3DFMT_UNKNOWN;
    params.hDeviceWindow = GetDesktopWindow();

    HRESULT hr = d3d->CreateDevice(
        D3DADAPTER_DEFAULT,
        D3DDEVTYPE_HAL,
        params.hDeviceWindow,
        D3DCREATE_SOFTWARE_VERTEXPROCESSING,
        &params,
        &device
    );

    if (FAILED(hr) || !device) {
        d3d->Release();
        return false;
    }

    memcpy(vtable, *(void***)device, size);

    device->Release();
    d3d->Release();

    return true;
}

// ================================
// Main DLL Thread
// ================================

void MainThread(HMODULE hModule) {
    LOG_INFO("===========================================");
    LOG_INFO("GWTools Enhanced DLL Starting");
    LOG_INFO("===========================================");

    // Initialize Debug system
    Debug::RegisterLogHandler(nullptr, nullptr);

    // Initialize MinHook
    if (MH_Initialize() != MH_OK) {
        LOG_ERROR("Failed to initialize MinHook");
        g_dllRunning = false;
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return;
    }

    // Wait for D3D9
    LOG_INFO("Waiting for d3d9.dll...");
    while (!GetModuleHandleA("d3d9.dll") && g_dllRunning) {
        Sleep(100);
    }

    if (!g_dllRunning) {
        LOG_INFO("Shutdown requested before d3d9 loaded");
        MH_Uninitialize();
        Debug::Destroy();
        FreeLibraryAndExitThread(hModule, EXIT_SUCCESS);
        return;
    }

    // Get D3D9 VTable
    void* d3d9_vtable[119];
    if (!GetD3D9VTable(d3d9_vtable, sizeof(d3d9_vtable))) {
        LOG_ERROR("Failed to get D3D9 VTable");
        MH_Uninitialize();
        Debug::Destroy();
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return;
    }

    // Create hooks
    void* endscene_addr = d3d9_vtable[42];
    void* reset_addr = d3d9_vtable[16];

    if (MH_CreateHook(endscene_addr, OnEndScene, (void**)&g_EndScene_Original) != MH_OK) {
        LOG_ERROR("Failed to create EndScene hook");
        MH_Uninitialize();
        Debug::Destroy();
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return;
    }

    if (MH_CreateHook(reset_addr, OnReset, (void**)&g_Reset_Original) != MH_OK) {
        LOG_ERROR("Failed to create Reset hook");
        MH_RemoveHook(endscene_addr);
        MH_Uninitialize();
        Debug::Destroy();
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return;
    }

    // Enable hooks
    if (MH_EnableHook(MH_ALL_HOOKS) != MH_OK) {
        LOG_ERROR("Failed to enable hooks");
        MH_RemoveHook(endscene_addr);
        MH_RemoveHook(reset_addr);
        MH_Uninitialize();
        Debug::Destroy();
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return;
    }

    LOG_SUCCESS("Hooks initialized successfully");

    // Initialize Scanner
    LOG_INFO("Initializing Scanner...");
    try {
        GW::Scanner::Initialize();
        LOG_SUCCESS("Scanner initialized successfully");
    }
    catch (const std::exception& e) {
        LOG_ERROR("Failed to initialize Scanner: %s", e.what());
    }
    catch (...) {
        LOG_ERROR("Failed to initialize Scanner: Unknown error");
    }

    // Initialize Named Pipe server with UI
    LOG_INFO("Initializing Named Pipe server with UI...");
    try {
        g_pipeUI = &GW::NamedPipeUI::GetInstance();
        g_pipeUI->Initialize();

        if (g_pipeUI->IsServerRunning()) {
            LOG_SUCCESS("Named Pipe server started successfully");
        }
        else {
            LOG_INFO("Named Pipe server not auto-started (check configuration)");
        }
    }
    catch (const std::exception& e) {
        LOG_ERROR("Failed to initialize Named Pipe UI: %s", e.what());
        g_pipeUI = nullptr;
    }
    catch (...) {
        LOG_ERROR("Failed to initialize Named Pipe UI: Unknown error");
        g_pipeUI = nullptr;
    }

    LOG_INFO("===========================================");
    LOG_INFO("GWTools Ready!");
    LOG_INFO("Hotkeys:");
    LOG_INFO("  END - Toggle main window");
    LOG_INFO("  HOME - Toggle debug console");
    LOG_INFO("  F9 - Toggle Named Pipe server control");
    LOG_INFO("  CTRL+F9 - Emergency shutdown");
    LOG_INFO("===========================================");

    // Main loop
    while (g_dllRunning && !g_shutdownRequested) {
        Sleep(16); // ~60 FPS
    }

    LOG_INFO("===========================================");
    LOG_INFO("Shutting down GWTools...");
    LOG_INFO("===========================================");

    // 1. Mark that we are shutting down
    g_dllRunning = false;
    g_shutdownRequested = true;

    // 2. Wait a bit for the running threads to finish
    Sleep(200);

    // 3. Cleanup ImGui BEFORE hooks
    LOG_INFO("Cleaning up ImGui...");
    CleanupImGui();

    // 4. Wait a little longer
    Sleep(100);

    // 5. Disable hooks
    LOG_INFO("Disabling hooks...");
    MH_DisableHook(MH_ALL_HOOKS);
    Sleep(50);

    // 6. Remove the hooks
    if (endscene_addr) {
        MH_RemoveHook(endscene_addr);
    }
    if (reset_addr) {
        MH_RemoveHook(reset_addr);
    }

    // 7. Uninitialize MinHook
    LOG_INFO("Uninitializing MinHook...");
    MH_Uninitialize();

    // 8. Stop Named Pipe Server with UI
    if (g_pipeUI) {
        LOG_INFO("Shutting down Named Pipe UI and server...");

        try {
            // Stop the server first if it is running
            if (g_pipeUI->IsServerRunning()) {
                LOG_INFO("Stopping Named Pipe server...");
                g_pipeUI->StopServer();

                // Wait a bit for the server to shut down properly
                Sleep(100);
            }

            // Then shutdown the UI
            g_pipeUI->Shutdown();

            // Wait a bit
            Sleep(50);

            // Finally destroy the instance
            GW::NamedPipeUI::Destroy();
            g_pipeUI = nullptr;

            LOG_SUCCESS("Named Pipe shutdown complete");
        }
        catch (const std::exception& e) {
            LOG_ERROR("Error during Named Pipe shutdown: %s", e.what());
        }
        catch (...) {
            LOG_ERROR("Unknown error during Named Pipe shutdown");
        }
    }

    // 9. If the NamedPipe server was created directly (old method), clean it up too
    if (g_pipeServer) {
        LOG_INFO("Cleaning up legacy Named Pipe server...");
        try {
            g_pipeServer->Stop();
            GW::NamedPipeServer::Destroy();
            g_pipeServer = nullptr;
        }
        catch (...) {
            LOG_ERROR("Error cleaning up legacy Named Pipe server");
        }
    }

    // 10. Cleanup debug
    LOG_INFO("Destroying Debug system...");
    Debug::Destroy();

    LOG_INFO("GWTools shutdown complete");
    LOG_INFO("===========================================");

    // 11. Last wait before unloading the DLL
    Sleep(100);

    // Exit thread and unload DLL
    g_mainThread = nullptr;
    FreeLibraryAndExitThread(hModule, EXIT_SUCCESS);
}

// ================================
// DLL Entry Point
// ================================

BOOL WINAPI DllMain(HMODULE hModule, DWORD reason, LPVOID reserved) {
    switch (reason) {
    case DLL_PROCESS_ATTACH: {
        // Disable thread library calls pour optimiser les performances
        DisableThreadLibraryCalls(hModule);

        // Initialiser les flags
        g_dllRunning = true;
        g_shutdownRequested = false;

        // Create main thread
        g_mainThread = CreateThread(
            nullptr,
            0,
            (LPTHREAD_START_ROUTINE)MainThread,
            hModule,
            0,
            nullptr
        );

        if (!g_mainThread) {
            // Thread creation failed
            return FALSE;
        }
        break;
    }

    case DLL_PROCESS_DETACH: {
        // Signal shutdown to all components
        g_shutdownRequested = true;
        g_dllRunning = false;

        // If we have a Named Pipe server, try to shut it down immediately.
        // This prevents the server from continuing to accept connections during shutdown.
        if (g_pipeUI) {
            try {
                if (g_pipeUI->IsServerRunning()) {
                    g_pipeUI->StopServer();
                }
            }
            catch (...) {
                // Ignore errors here, the main thread will do the full cleanup
            }
        }

        // Wait for the main thread with a reasonable timeout
        if (g_mainThread) {
            // Give the thread 3 seconds to terminate properly
            DWORD result = WaitForSingleObject(g_mainThread, 3000);

            switch (result) {
            case WAIT_OBJECT_0:
                // Thread terminated cleanly
                break;

            case WAIT_TIMEOUT:
                // Thread did not terminate in time
                // DO NOT TerminateThread as this can corrupt the state
                // Let Windows clean up
                LOG_ERROR("Main thread did not terminate in time (3 seconds)");
                // We can try to force some critical cleanups here
                // but it's risky
                break;

            case WAIT_FAILED:
                LOG_ERROR("WaitForSingleObject failed: %lu", GetLastError());
                break;
            }

            // Close the thread handle
            CloseHandle(g_mainThread);
            g_mainThread = nullptr;
        }
        // If reserved is NULL, this is an explicit detachment(FreeLibrary)
        // If reserved is non - NULL, this is a process detachment
        if (reserved == NULL) {
            // Explicit detachment - we can do a little more cleanup
            // But most of it should already be done by MainThread
        }
        else {
            // Process terminates - minimal cleanup only
            // Windows will clean everything up anyway
        }

        break;
    }

    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
        // Do nothing for individual threads
        // (DisableThreadLibraryCalls has been called)
        break;
    }

    return TRUE;
}

