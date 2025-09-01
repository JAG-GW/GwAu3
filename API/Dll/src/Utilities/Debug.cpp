#include "Utilities/Debug.h"
#include <cstdarg>
#include <algorithm>
#include <filesystem>
#include <Psapi.h>
#include <Windowsx.h>

// Static member initialization
Debug* Debug::instance = nullptr;
Debug::LogHandler Debug::s_LogHandler = nullptr;
void* Debug::s_LogHandlerContext = nullptr;
Debug::PanicHandler Debug::s_PanicHandler = nullptr;
void* Debug::s_PanicHandlerContext = nullptr;

Debug::Debug()
    : showDebugWindow(false)
    , autoScroll(true)
    , showTimestamps(true)
    , showFileInfo(false)
    , maxLogs(1000)
    , frameTime(0.0f)
    , fps(0.0f)
    , lastFrameTime(std::chrono::steady_clock::now()) {

    // Initialize filters (all enabled by default)
    for (int i = 0; i < 7; i++) {
        filterByLevel[i] = true;
        logCounts[i] = 0;
    }

    memset(searchFilter, 0, sizeof(searchFilter));

    // Set default internal log handler
    s_LogHandler = [](void* ctx, LogLevel level, const char* msg, const char* file,
        unsigned int line, const char* function) {
            if (Debug::instance) {
                Debug::instance->InternalLog(level, msg, file, line, function);
            }
        };

    // Welcome message
    LOG_SUCCESS("Debug system initialized");
}

Debug::~Debug() {
    Clear();
}

Debug& Debug::GetInstance() {
    if (!instance) {
        instance = new Debug();
    }
    return *instance;
}

void Debug::Destroy() {
    if (instance) {
        delete instance;
        instance = nullptr;
    }
}

void Debug::RegisterLogHandler(LogHandler handler, void* context) {
    s_LogHandler = handler;
    s_LogHandlerContext = context;

    // If no handler, set default internal handler
    if (!handler) {
        s_LogHandler = [](void* ctx, LogLevel level, const char* msg, const char* file,
            unsigned int line, const char* function) {
                if (Debug::instance) {
                    Debug::instance->InternalLog(level, msg, file, line, function);
                }
            };
    }
}

void Debug::RegisterPanicHandler(PanicHandler handler, void* context) {
    s_PanicHandler = handler;
    s_PanicHandlerContext = context;
}

__declspec(noreturn) void Debug::FatalAssert(
    const char* expr,
    const char* file,
    unsigned int line,
    const char* function) {

    // Log the assertion failure
    LOG_CRITICAL("ASSERTION FAILED: %s", expr);

    // Call panic handler if registered
    if (s_PanicHandler) {
        s_PanicHandler(s_PanicHandlerContext, expr, file, line, function);
    }

    // Show message box in debug mode
#ifdef _DEBUG
    char buffer[1024];
    snprintf(buffer, sizeof(buffer),
        "Assertion Failed!\n\nExpression: %s\nFile: %s\nLine: %u\nFunction: %s",
        expr, file, line, function);
    MessageBoxA(NULL, buffer, "Fatal Assert", MB_OK | MB_ICONERROR);
#endif

    abort();
}

void __cdecl Debug::LogMessage(
    LogLevel level,
    const char* file,
    unsigned int line,
    const char* function,
    const char* fmt,
    ...) {

    va_list args;
    va_start(args, fmt);
    LogMessageV(level, file, line, function, fmt, args);
    va_end(args);
}

void __cdecl Debug::LogMessageV(
    LogLevel level,
    const char* file,
    unsigned int line,
    const char* function,
    const char* fmt,
    va_list args) {

    if (s_LogHandler == nullptr)
        return;

    char message[1024];
    vsnprintf(message, sizeof(message), fmt, args);
    s_LogHandler(s_LogHandlerContext, level, message, file, line, function);
}

void Debug::InternalLog(LogLevel level, const char* message, const char* file,
    unsigned int line, const char* function) {
    // Thread-safe logging
    std::lock_guard<std::mutex> lock(logMutex);

    // Add the log
    logs.emplace_back(level, std::string(message), std::string(file), line, std::string(function));

    // Update counters
    logCounts[static_cast<int>(level)]++;

    // Limit the number of logs
    while (logs.size() > maxLogs) {
        LogLevel removedLevel = logs.front().level;
        logCounts[static_cast<int>(removedLevel)]--;
        logs.pop_front();
    }

    // Output to console in debug mode
#ifdef _DEBUG
    const char* levelStr = GetLogLevelString(level);
    if (showFileInfo) {
        printf("[%s] %s (%s:%u in %s)\n", levelStr, message, file, line, function);
    }
    else {
        printf("[%s] %s\n", levelStr, message);
    }
#endif
}

void Debug::Clear() {
    std::lock_guard<std::mutex> lock(logMutex);
    logs.clear();
    for (int i = 0; i < 7; i++) {
        logCounts[i] = 0;
    }
}

void Debug::ToggleWindow() {
    showDebugWindow = !showDebugWindow;
}

bool Debug::WndProc(UINT msg, WPARAM wParam, LPARAM lParam) {
    // Handle custom messages
    switch (msg) {
    //case WM_GW_RBUTTONCLICK: {
        // Custom right click event - can be used for context menus, etc.
        // For now, just return false to let other systems handle it
    //    return false;
    //}
    case WM_KEYDOWN: {
        // Handle debug-specific hotkeys if window is open
        if (showDebugWindow) {
            switch (wParam) {
            case VK_ESCAPE:
                showDebugWindow = false;
                return true;
            case 'C':
                if (GetKeyState(VK_CONTROL) & 0x8000) {
                    Clear();
                    return true;
                }
                break;
            }
        }
        break;
    }
    }
    return false;
}

void Debug::Draw() {
    if (!showDebugWindow) return;

    UpdatePerformanceStats();

    // Window configuration
    ImGui::SetNextWindowSize(ImVec2(900, 700), ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowPos(ImVec2(50, 50), ImGuiCond_FirstUseEver);

    // Main window
    if (ImGui::Begin("Debug Console", &showDebugWindow, ImGuiWindowFlags_MenuBar)) {
        // Menu bar
        if (ImGui::BeginMenuBar()) {
            if (ImGui::BeginMenu("File")) {
                if (ImGui::MenuItem("Clear Logs", "Ctrl+L")) {
                    Clear();
                }

                if (ImGui::MenuItem("Copy All Logs", "Ctrl+C")) {
                    CopyLogsToClipboard();
                }

                if (ImGui::MenuItem("Copy Filtered Logs", "Ctrl+Shift+C")) {
                    CopyFilteredLogsToClipboard();
                }

                if (ImGui::MenuItem("Export Logs...", "Ctrl+S")) {
                    // TODO: Implement log export
                }
                ImGui::Separator();
                if (ImGui::MenuItem("Close", "Esc")) {
                    showDebugWindow = false;
                }
                ImGui::EndMenu();
            }

            if (ImGui::BeginMenu("View")) {
                ImGui::MenuItem("Auto-scroll", nullptr, &autoScroll);
                ImGui::MenuItem("Show Timestamps", nullptr, &showTimestamps);
                ImGui::MenuItem("Show File Info", nullptr, &showFileInfo);
                ImGui::Separator();
                ImGui::SliderInt("Max Logs", (int*)&maxLogs, 100, 10000);
                ImGui::EndMenu();
            }

            // Performance info in menu bar
            ImGui::Separator();
            ImGui::Text("| FPS: %.1f | Frame: %.3f ms | Logs: %zu |", fps, frameTime, logs.size());

            ImGui::EndMenuBar();
        }

        // Control panel
        DrawControlPanel();

        ImGui::Separator();

        // Performance panel
        if (ImGui::CollapsingHeader("Performance Monitor", ImGuiTreeNodeFlags_DefaultOpen)) {
            DrawPerformancePanel();
        }

        // Log panel
        if (ImGui::CollapsingHeader("Logs", ImGuiTreeNodeFlags_DefaultOpen)) {
            DrawLogPanel();
        }
    }
    ImGui::End();
}

void Debug::DrawControlPanel() {
    // Filters by level
    ImGui::Text("Filters:");
    ImGui::SameLine();

    // Trace
    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.5f, 0.5f, 0.5f, 1.0f));
    if (ImGui::Checkbox("Trace", &filterByLevel[0])) {}
    ImGui::PopStyleColor();
    ImGui::SameLine();

    // Debug
    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.7f, 0.7f, 0.7f, 1.0f));
    if (ImGui::Checkbox("Debug", &filterByLevel[1])) {}
    ImGui::PopStyleColor();
    ImGui::SameLine();

    // Info
    if (ImGui::Checkbox("Info", &filterByLevel[2])) {}
    ImGui::SameLine();

    // Warning
    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 0.0f, 1.0f));
    if (ImGui::Checkbox("Warning", &filterByLevel[3])) {}
    ImGui::PopStyleColor();
    ImGui::SameLine();

    // Error
    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 1.0f));
    if (ImGui::Checkbox("Error", &filterByLevel[4])) {}
    ImGui::PopStyleColor();
    ImGui::SameLine();

    // Critical
    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 1.0f, 1.0f));
    if (ImGui::Checkbox("Critical", &filterByLevel[5])) {}
    ImGui::PopStyleColor();
    ImGui::SameLine();

    // Success
    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f));
    if (ImGui::Checkbox("Success", &filterByLevel[6])) {}
    ImGui::PopStyleColor();

    // Search bar
    ImGui::SameLine();
    ImGui::SetNextItemWidth(200);
    ImGui::InputText("Search", searchFilter, sizeof(searchFilter));

    // Clear button
    ImGui::SameLine();
    if (ImGui::Button("Clear All")) {
        Clear();
    }

    if (ImGui::Button("Copy Console")) {
        CopyLogsToClipboard();
    }
    ImGui::SameLine();
    if (ImGui::Button("Copy Filtred Console")) {
        CopyFilteredLogsToClipboard();
    }

    // Tooltip pour le bouton Copy Console
    if (ImGui::IsItemHovered()) {
        ImGui::SetTooltip("Copy all logs to clipboard");
    }

    // Statistics
    ImGui::Text("Stats: Total:%zu T:%zu D:%zu I:%zu W:%zu E:%zu C:%zu S:%zu",
        logs.size(), logCounts[0], logCounts[1], logCounts[2],
        logCounts[3], logCounts[4], logCounts[5], logCounts[6]);
}

void Debug::DrawLogPanel() {
    // Log area with scroll
    ImGui::BeginChild("LogScrollArea", ImVec2(0, 400), true,
        ImGuiWindowFlags_HorizontalScrollbar);

    // Display filtered logs
    std::lock_guard<std::mutex> lock(logMutex);

    for (const auto& log : logs) {
        // Apply filters
        if (!filterByLevel[static_cast<int>(log.level)]) continue;

        // Search filter
        if (strlen(searchFilter) > 0) {
            std::string fullText = log.message + " " + log.file + " " + log.function;
            if (fullText.find(searchFilter) == std::string::npos) {
                continue;
            }
        }

        // Display timestamp if enabled
        if (showTimestamps) {
            ImGui::TextColored(ImVec4(0.5f, 0.5f, 0.5f, 1.0f),
                "[%s]", FormatTimestamp(log.timestamp).c_str());
            ImGui::SameLine();
        }

        // Display level
        ImVec4 color = GetLogLevelColor(log.level);
        ImGui::TextColored(color, "[%s]", GetLogLevelString(log.level));
        ImGui::SameLine();

        // Display file info if enabled
        if (showFileInfo) {
            ImGui::TextColored(ImVec4(0.6f, 0.6f, 0.6f, 1.0f),
                "[%s:%u in %s]",
                GetShortFileName(log.file).c_str(),
                log.line,
                log.function.c_str());
            ImGui::SameLine();
        }

        // Display message
        ImGui::TextWrapped("%s", log.message.c_str());
    }

    // Auto-scroll
    if (autoScroll && ImGui::GetScrollY() >= ImGui::GetScrollMaxY()) {
        ImGui::SetScrollHereY(1.0f);
    }

    ImGui::EndChild();
}

void Debug::DrawPerformancePanel() {
    ImGui::Columns(3, "PerfColumns");

    // FPS and Frame Time
    ImGui::Text("FPS: %.1f", fps);
    ImGui::Text("Frame Time: %.3f ms", frameTime);
    ImGui::Text("Log Count: %zu", logs.size());

    ImGui::NextColumn();

    // Memory info
    PROCESS_MEMORY_COUNTERS_EX pmc;
    if (GetProcessMemoryInfo(GetCurrentProcess(), (PROCESS_MEMORY_COUNTERS*)&pmc, sizeof(pmc))) {
        float workingSetMB = pmc.WorkingSetSize / (1024.0f * 1024.0f);
        float privateUsageMB = pmc.PrivateUsage / (1024.0f * 1024.0f);

        ImGui::Text("Working Set: %.2f MB", workingSetMB);
        ImGui::Text("Private Usage: %.2f MB", privateUsageMB);
    }

    ImGui::NextColumn();

    // Thread info
    ImGui::Text("Thread ID: %lu", GetCurrentThreadId());
    ImGui::Text("Process ID: %lu", GetCurrentProcessId());

    // CPU usage (simplified)
    FILETIME ftCreate, ftExit, ftKernel, ftUser;
    if (GetProcessTimes(GetCurrentProcess(), &ftCreate, &ftExit, &ftKernel, &ftUser)) {
        ULARGE_INTEGER ul;
        ul.LowPart = ftUser.dwLowDateTime;
        ul.HighPart = ftUser.dwHighDateTime;
        ImGui::Text("User Time: %.2f s", ul.QuadPart / 10000000.0);
    }

    ImGui::Columns(1);
}

void Debug::UpdatePerformanceStats() {
    auto now = std::chrono::steady_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(now - lastFrameTime);

    frameTime = duration.count() / 1000.0f; // Convert to milliseconds
    fps = frameTime > 0 ? 1000.0f / frameTime : 0.0f;

    lastFrameTime = now;
}

const char* Debug::GetLogLevelString(LogLevel level) const {
    switch (level) {
    case LogLevel::Trace:    return "TRACE";
    case LogLevel::Debug:    return "DEBUG";
    case LogLevel::Info:     return "INFO";
    case LogLevel::Warning:  return "WARN";
    case LogLevel::Error:    return "ERROR";
    case LogLevel::Critical: return "CRITICAL";
    case LogLevel::Success:  return "OK";
    default:                 return "UNKNOWN";
    }
}

ImVec4 Debug::GetLogLevelColor(LogLevel level) const {
    switch (level) {
    case LogLevel::Trace:    return ImVec4(0.5f, 0.5f, 0.5f, 1.0f);  // Gray
    case LogLevel::Debug:    return ImVec4(0.7f, 0.7f, 0.7f, 1.0f);  // Light gray
    case LogLevel::Info:     return ImVec4(0.8f, 0.8f, 0.8f, 1.0f);  // White-ish
    case LogLevel::Warning:  return ImVec4(1.0f, 1.0f, 0.0f, 1.0f);  // Yellow
    case LogLevel::Error:    return ImVec4(1.0f, 0.0f, 0.0f, 1.0f);  // Red
    case LogLevel::Critical: return ImVec4(1.0f, 0.0f, 1.0f, 1.0f);  // Magenta
    case LogLevel::Success:  return ImVec4(0.0f, 1.0f, 0.0f, 1.0f);  // Green
    default:                 return ImVec4(1.0f, 1.0f, 1.0f, 1.0f);  // White
    }
}

std::string Debug::FormatTimestamp(const std::chrono::system_clock::time_point& time) const {
    auto time_t = std::chrono::system_clock::to_time_t(time);
    auto tm = *std::localtime(&time_t);

    char buffer[32];
    strftime(buffer, sizeof(buffer), "%H:%M:%S", &tm);

    // Add milliseconds
    auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
        time.time_since_epoch()) % 1000;

    char finalBuffer[64];
    snprintf(finalBuffer, sizeof(finalBuffer), "%s.%03lld", buffer, ms.count());

    return std::string(finalBuffer);
}

std::string Debug::GetShortFileName(const std::string& fullPath) const {
    size_t pos = fullPath.find_last_of("\\/");
    if (pos != std::string::npos) {
        return fullPath.substr(pos + 1);
    }
    return fullPath;
}

void Debug::CopyLogsToClipboard() {
    std::string text;

    {
        std::lock_guard<std::mutex> lock(logMutex);

        // Réserver de l'espace pour éviter les réallocations
        text.reserve(logs.size() * 100);

        for (const auto& log : logs) {
            // Format simple et sûr
            text += "[";
            text += GetLogLevelString(log.level);
            text += "] ";
            text += log.message;
            text += "\n";
        }
    }

    if (text.empty()) {
        return;
    }

    // Utiliser ImGui pour copier dans le presse-papiers (plus sûr)
    ImGui::SetClipboardText(text.c_str());

    LOG_SUCCESS("Logs copied to clipboard (%zu bytes)", text.size());
}

void Debug::CopyFilteredLogsToClipboard() {
    std::string text;

    {
        std::lock_guard<std::mutex> lock(logMutex);

        for (const auto& log : logs) {
            // Appliquer les filtres
            if (!filterByLevel[static_cast<int>(log.level)]) continue;

            // Filtre de recherche
            if (strlen(searchFilter) > 0) {
                std::string fullText = log.message + " " + log.file + " " + log.function;
                if (fullText.find(searchFilter) == std::string::npos) {
                    continue;
                }
            }

            // Construire la ligne de log
            std::string line;

            if (showTimestamps) {
                line += "[" + FormatTimestamp(log.timestamp) + "] ";
            }

            line += "[";
            line += GetLogLevelString(log.level);
            line += "] ";

            if (showFileInfo) {
                line += "[" + GetShortFileName(log.file) + ":" +
                    std::to_string(log.line) + " in " + log.function + "] ";
            }

            line += log.message;
            line += "\n";

            text += line;
        }
    }

    if (text.empty()) {
        LOG_INFO("No filtered logs to copy");
        return;
    }

    // Utiliser ImGui pour copier (plus sûr)
    ImGui::SetClipboardText(text.c_str());

    LOG_SUCCESS("Filtered logs copied to clipboard (%zu bytes)", text.size());
}