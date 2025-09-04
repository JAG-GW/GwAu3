#include "Headers.h"
#include "Utilities/Debug.h"
#include "Utilities/Scanner.h"
#include "DllState.h"
#include "NamedPipe/NamedPipeServer.h"
#include "NamedPipe/NamedPipeUI.h"
#include "NamedPipe/RPCBridge.h"
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
// DLL State Management (Thread-Safe)
// ================================

// Global state definition
std::atomic<GW::DllState> GW::g_dllState{ GW::DllState::Initializing };

// Synchronization primitives
std::condition_variable g_shutdownCV;
std::mutex g_shutdownMutex;

// Thread management with RAII
class ThreadRAII {
    HANDLE handle;
public:
    ThreadRAII(HANDLE h = nullptr) : handle(h) {}
    ~ThreadRAII() {
        if (handle && handle != INVALID_HANDLE_VALUE) {
            CloseHandle(handle);
        }
    }
    void reset(HANDLE h) {
        if (handle && handle != INVALID_HANDLE_VALUE) {
            CloseHandle(handle);
        }
        handle = h;
    }
    HANDLE get() const { return handle; }
    HANDLE release() {
        HANDLE h = handle;
        handle = nullptr;
        return h;
    }
};

// Global thread handle with RAII
ThreadRAII g_mainThread;

// ================================
// Global Variables
// ================================

// DirectX hooks
typedef HRESULT(WINAPI* EndScene_t)(IDirect3DDevice9*);
typedef HRESULT(WINAPI* Reset_t)(IDirect3DDevice9*, D3DPRESENT_PARAMETERS*);
EndScene_t g_EndScene_Original = nullptr;
Reset_t g_Reset_Original = nullptr;

// ImGui state
bool g_imguiInitialized = false;
bool g_showMainWindow = false;  // Changed to false by default, will be enabled only in debug mode
HWND g_gameWindow = nullptr;
WNDPROC g_originalWndProc = nullptr;

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
        GW::RequestShutdown();
        g_shutdownCV.notify_all();
        return 0;
    }

#ifdef _DEBUG
    // Only handle ImGui input in debug mode
    // Check if ImGui is initialized
    if (!GW::IsDllRunning() || !g_imguiInitialized) {
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
#endif // _DEBUG

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
#ifdef _DEBUG
    if (g_imguiInitialized) return true;

    LOG_INFO("Initializing ImGui (Debug Mode)...");

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
    g_showMainWindow = true; // Show main window in debug mode
    LOG_SUCCESS("ImGui initialized successfully (Debug Mode)");
    return true;
#else
    // In release mode, don't initialize ImGui
    return false;
#endif
}

// ================================
// ImGui Cleanup
// ================================

void CleanupImGui() {
#ifdef _DEBUG
    if (!g_imguiInitialized) return;

    LOG_INFO("Cleaning up ImGui...");

    // Mark as not initialized first to prevent any new rendering
    g_imguiInitialized = false;

    // Wait a bit for any pending render to complete
    Sleep(50);

    try {
        // Cleanup ImGui DirectX resources
        if (ImGui::GetCurrentContext()) {
            ImGui_ImplDX9_InvalidateDeviceObjects();
            ImGui_ImplDX9_Shutdown();
            ImGui_ImplWin32_Shutdown();
            ImGui::DestroyContext();
        }
    }
    catch (...) {
        LOG_ERROR("Exception during ImGui cleanup");
    }

    // Restore original WndProc
    if (g_originalWndProc && g_gameWindow && IsWindow(g_gameWindow)) {
        try {
            SetWindowLongPtr(g_gameWindow, GWLP_WNDPROC, (LONG_PTR)g_originalWndProc);
        }
        catch (...) {
            LOG_ERROR("Failed to restore WndProc");
        }
        g_originalWndProc = nullptr;
    }

    g_gameWindow = nullptr;
    LOG_INFO("ImGui cleanup complete");
#endif
}

// ================================
// Main GUI Rendering
// ================================

void RenderMainWindow() {
#ifdef _DEBUG
    if (!g_showMainWindow) return;

    ImGui::SetNextWindowSize(ImVec2(500, 400), ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowPos(ImVec2(50, 50), ImGuiCond_FirstUseEver);

    if (ImGui::Begin("GwAu3 (Debug Mode)", &g_showMainWindow, ImGuiWindowFlags_MenuBar)) {
        // Menu bar
        if (ImGui::BeginMenuBar()) {
            if (ImGui::BeginMenu("Windows")) {
                if (ImGui::MenuItem("Debug Console", nullptr, Debug::GetInstance().IsWindowVisible())) {
                    Debug::GetInstance().ToggleWindow();
                }

                // Menu for Named Pipe Server
                if (ImGui::MenuItem("Named Pipe Server", nullptr, g_pipeUI && g_pipeUI->IsWindowVisible())) {
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
        ImGui::Text("GwAu3 DLL - Debug Mode");
        ImGui::Text("Version: 1.0.0");
        ImGui::Separator();

        // System info
        ImGui::Text("Process ID: %d", GetCurrentProcessId());
        ImGui::Text("Thread ID: %d", GetCurrentThreadId());

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
                    ImGui::Text("Pipe: %s", GetPipeName().c_str());

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
                GW::RequestShutdown();
                g_shutdownCV.notify_all();
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
                GW::RequestShutdown();
                g_shutdownCV.notify_all();
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
#endif
}

// ================================
// ImGui Render Function
// ================================

void RenderImGui() {
#ifdef _DEBUG
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

    // Check for shutdown request from UI
    if (!g_showMainWindow) {
        GW::RequestShutdown();
        g_shutdownCV.notify_all();
    }

    ImGui::EndFrame();
    ImGui::Render();
    ImGui_ImplDX9_RenderDrawData(ImGui::GetDrawData());
#endif
}

// ================================
// DirectX Hooks
// ================================

HRESULT WINAPI OnEndScene(IDirect3DDevice9* device) {
    if (!GW::IsDllRunning()) {
        if (g_EndScene_Original) {
            return g_EndScene_Original(device);
        }
        return S_OK;
    }

    // Process pending RPC calls in game thread context
    if (g_pipeServer || g_pipeUI) {
        GW::RPCBridge::GetInstance().ProcessPendingCalls();
    }

#ifdef _DEBUG
    // Initialize ImGui on first call (only in debug mode)
    if (!g_imguiInitialized) {
        if (!InitImGui(device)) {
            return g_EndScene_Original(device);
        }
    }

    // Render ImGui (only in debug mode)
    if (g_imguiInitialized && GW::IsDllRunning()) {
        RenderImGui();
    }
#endif

    return g_EndScene_Original(device);
}

HRESULT WINAPI OnReset(IDirect3DDevice9* device, D3DPRESENT_PARAMETERS* params) {
    if (!GW::IsDllRunning() && g_Reset_Original) {
        return g_Reset_Original(device, params);
    }

#ifdef _DEBUG
    if (g_imguiInitialized) {
        ImGui_ImplDX9_InvalidateDeviceObjects();
    }
#endif

    HRESULT result = g_Reset_Original ? g_Reset_Original(device, params) : S_OK;

#ifdef _DEBUG
    if (g_imguiInitialized && GW::IsDllRunning()) {
        ImGui_ImplDX9_CreateDeviceObjects();
    }
#endif

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

DWORD WINAPI MainThread(LPVOID param) {
    HMODULE hModule = (HMODULE)param;

    LOG_INFO("===========================================");
    LOG_INFO("GwAu3 DLL Starting");
#ifdef _DEBUG
    LOG_INFO("Running in DEBUG mode - UI enabled");
#else
    LOG_INFO("Running in RELEASE mode - UI disabled");
#endif
    LOG_INFO("===========================================");

    // Set state to running
    GW::g_dllState = GW::DllState::Running;

    // Initialize Debug system
    Debug::RegisterLogHandler(nullptr, nullptr);

    // Initialize MinHook
    if (MH_Initialize() != MH_OK) {
        LOG_ERROR("Failed to initialize MinHook");
        GW::g_dllState = GW::DllState::Stopped;
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return EXIT_FAILURE;
    }

    // Wait for D3D9
    LOG_INFO("Waiting for d3d9.dll...");
    while (!GetModuleHandleA("d3d9.dll") && GW::IsDllRunning()) {
        std::unique_lock<std::mutex> lock(g_shutdownMutex);
        g_shutdownCV.wait_for(lock, std::chrono::milliseconds(100));
    }

    if (GW::IsDllShuttingDown()) {
        LOG_INFO("Shutdown requested before d3d9 loaded");
        MH_Uninitialize();
        Debug::Destroy();
        GW::g_dllState = GW::DllState::Stopped;
        FreeLibraryAndExitThread(hModule, EXIT_SUCCESS);
        return EXIT_SUCCESS;
    }

    // Get D3D9 VTable
    void* d3d9_vtable[119];
    if (!GetD3D9VTable(d3d9_vtable, sizeof(d3d9_vtable))) {
        LOG_ERROR("Failed to get D3D9 VTable");
        MH_Uninitialize();
        Debug::Destroy();
        GW::g_dllState = GW::DllState::Stopped;
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return EXIT_FAILURE;
    }

    // Create hooks
    void* endscene_addr = d3d9_vtable[42];
    void* reset_addr = d3d9_vtable[16];

    if (MH_CreateHook(endscene_addr, OnEndScene, (void**)&g_EndScene_Original) != MH_OK) {
        LOG_ERROR("Failed to create EndScene hook");
        MH_Uninitialize();
        Debug::Destroy();
        GW::g_dllState = GW::DllState::Stopped;
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return EXIT_FAILURE;
    }

    if (MH_CreateHook(reset_addr, OnReset, (void**)&g_Reset_Original) != MH_OK) {
        LOG_ERROR("Failed to create Reset hook");
        MH_RemoveHook(endscene_addr);
        MH_Uninitialize();
        Debug::Destroy();
        GW::g_dllState = GW::DllState::Stopped;
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return EXIT_FAILURE;
    }

    // Enable hooks
    if (MH_EnableHook(MH_ALL_HOOKS) != MH_OK) {
        LOG_ERROR("Failed to enable hooks");
        MH_RemoveHook(endscene_addr);
        MH_RemoveHook(reset_addr);
        MH_Uninitialize();
        Debug::Destroy();
        GW::g_dllState = GW::DllState::Stopped;
        FreeLibraryAndExitThread(hModule, EXIT_FAILURE);
        return EXIT_FAILURE;
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
    LOG_INFO("Initializing Named Pipe server...");
    try {
#ifdef _DEBUG
        // In debug mode, initialize the UI
        g_pipeUI = &GW::NamedPipeUI::GetInstance();
        g_pipeUI->Initialize();

        if (g_pipeUI->IsServerRunning()) {
            LOG_SUCCESS("Named Pipe server started successfully");
        }
        else {
            LOG_INFO("Named Pipe server not auto-started (check configuration)");
        }
#else
        // In release mode, start the server directly without UI
        g_pipeServer = &GW::NamedPipeServer::GetInstance();
        if (g_pipeServer->Start()) {
            LOG_SUCCESS("Named Pipe server started successfully (no UI in release mode)");
        }
        else {
            LOG_ERROR("Failed to start Named Pipe server");
        }
#endif
    }
    catch (const std::exception& e) {
        LOG_ERROR("Failed to initialize Named Pipe: %s", e.what());
    }
    catch (...) {
        LOG_ERROR("Failed to initialize Named Pipe: Unknown error");
    }

    LOG_INFO("===========================================");
    LOG_INFO("GwAu3 Ready!");
#ifdef _DEBUG
    LOG_INFO("Debug UI available - no hotkeys configured");
#else
    LOG_INFO("Running in headless mode - no UI");
#endif
    LOG_INFO("Named Pipe: %s", GetPipeName().c_str());
    LOG_INFO("===========================================");

    // Main loop - Wait for shutdown signal
    {
        std::unique_lock<std::mutex> lock(g_shutdownMutex);
        g_shutdownCV.wait(lock, [] { return GW::IsDllShuttingDown(); });
    }

    LOG_INFO("===========================================");
    LOG_INFO("Shutting down GwAu3...");
    LOG_INFO("===========================================");

    // Cleanup ImGui BEFORE hooks
#ifdef _DEBUG
    LOG_INFO("Cleaning up ImGui...");
    CleanupImGui();
#endif

    // Wait a bit for pending operations
    Sleep(100);

    // Disable hooks
    LOG_INFO("Disabling hooks...");
    MH_DisableHook(MH_ALL_HOOKS);
    Sleep(50);

    // Remove the hooks
    if (endscene_addr) {
        MH_RemoveHook(endscene_addr);
    }
    if (reset_addr) {
        MH_RemoveHook(reset_addr);
    }

    // Uninitialize MinHook
    LOG_INFO("Uninitializing MinHook...");
    MH_Uninitialize();

    // Stop Named Pipe Server
#ifdef _DEBUG
    if (g_pipeUI) {
        LOG_INFO("Shutting down Named Pipe UI and server...");

        try {
            if (g_pipeUI->IsServerRunning()) {
                LOG_INFO("Stopping Named Pipe server...");
                g_pipeUI->StopServer();
                Sleep(100);
            }

            g_pipeUI->Shutdown();
            Sleep(50);

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
#else
    if (g_pipeServer) {
        LOG_INFO("Shutting down Named Pipe server...");
        try {
            g_pipeServer->Stop();
            GW::NamedPipeServer::Destroy();
            g_pipeServer = nullptr;
            LOG_SUCCESS("Named Pipe server shutdown complete");
        }
        catch (...) {
            LOG_ERROR("Error during Named Pipe shutdown");
        }
    }
#endif

    // Cleanup debug
    LOG_INFO("Destroying Debug system...");
    Debug::Destroy();

    LOG_INFO("GwAu3 shutdown complete");
    LOG_INFO("===========================================");

    // Set final state
    GW::g_dllState = GW::DllState::Stopped;

    // Exit thread and unload DLL
    FreeLibraryAndExitThread(hModule, EXIT_SUCCESS);
    return EXIT_SUCCESS;
}

// ================================
// DLL Entry Point
// ================================

BOOL WINAPI DllMain(HMODULE hModule, DWORD reason, LPVOID reserved) {
    switch (reason) {
    case DLL_PROCESS_ATTACH: {
        // Disable thread library calls for optimization
        DisableThreadLibraryCalls(hModule);

        // Initialize state
        GW::g_dllState = GW::DllState::Initializing;

        // Create main thread
        HANDLE hThread = CreateThread(
            nullptr,
            0,
            MainThread,
            hModule,
            0,
            nullptr
        );

        if (!hThread) {
            GW::g_dllState = GW::DllState::Stopped;
            return FALSE;
        }

        // Store thread handle with RAII
        g_mainThread.reset(hThread);
        break;
    }

    case DLL_PROCESS_DETACH: {
        // Signal shutdown to all components
        GW::RequestShutdown();
        g_shutdownCV.notify_all();

        // Stop Named Pipe server immediately if running
#ifdef _DEBUG
        if (g_pipeUI) {
            try {
                if (g_pipeUI->IsServerRunning()) {
                    g_pipeUI->StopServer();
                }
            }
            catch (...) {
                // Ignore errors during emergency shutdown
            }
        }
#else
        if (g_pipeServer) {
            try {
                g_pipeServer->Stop();
            }
            catch (...) {
                // Ignore errors during emergency shutdown
            }
        }
#endif

        // Wait for the main thread with timeout
        HANDLE hThread = g_mainThread.get();
        if (hThread) {
            DWORD result = WaitForSingleObject(hThread, 3000);

            if (result == WAIT_TIMEOUT) {
                LOG_ERROR("Main thread did not terminate in time (3 seconds)");
                // Do NOT TerminateThread - let Windows clean up
            }

            // Thread handle will be closed by RAII destructor
        }

        break;
    }

    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
        // Do nothing for individual threads
        break;
    }

    return TRUE;
}