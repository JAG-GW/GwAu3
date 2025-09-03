#include "Utilities/Debug.h"
#include <cstdarg>
#include <algorithm>

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
    , maxLogs(1000) {

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
    static std::once_flag onceFlag;
    std::call_once(onceFlag, []() {
        instance = new Debug();
        });
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

void Debug::Draw() {
    if (!showDebugWindow) return;

    // Window configuration
    ImGui::SetNextWindowSize(ImVec2(900, 600), ImGuiCond_FirstUseEver);
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

                if (ImGui::BeginMenu("Max Logs")) {
                    if (ImGui::MenuItem("100", nullptr, maxLogs == 100)) maxLogs = 100;
                    if (ImGui::MenuItem("500", nullptr, maxLogs == 500)) maxLogs = 500;
                    if (ImGui::MenuItem("1000", nullptr, maxLogs == 1000)) maxLogs = 1000;
                    if (ImGui::MenuItem("2000", nullptr, maxLogs == 2000)) maxLogs = 2000;
                    if (ImGui::MenuItem("5000", nullptr, maxLogs == 5000)) maxLogs = 5000;
                    ImGui::EndMenu();
                }
                ImGui::EndMenu();
            }

            // Log count in menu bar
            ImGui::Separator();
            ImGui::Text("| Logs: %zu/%zu |", logs.size(), maxLogs);

            ImGui::EndMenuBar();
        }

        // Control panel
        DrawControlPanel();

        ImGui::Separator();

        // Log panel
        DrawLogPanel();
    }
    ImGui::End();
}

void Debug::DrawControlPanel() {
    // Filters by level
    ImGui::Text("Filters:");
    ImGui::SameLine();

    // Create filter checkboxes with colors
    struct FilterInfo {
        const char* name;
        ImVec4 color;
    } filters[] = {
        {"Trace", ImVec4(0.5f, 0.5f, 0.5f, 1.0f)},
        {"Debug", ImVec4(0.7f, 0.7f, 0.7f, 1.0f)},
        {"Info", ImVec4(0.8f, 0.8f, 0.8f, 1.0f)},
        {"Warning", ImVec4(1.0f, 1.0f, 0.0f, 1.0f)},
        {"Error", ImVec4(1.0f, 0.0f, 0.0f, 1.0f)},
        {"Critical", ImVec4(1.0f, 0.0f, 1.0f, 1.0f)},
        {"Success", ImVec4(0.0f, 1.0f, 0.0f, 1.0f)}
    };

    for (int i = 0; i < 7; i++) {
        ImGui::PushStyleColor(ImGuiCol_Text, filters[i].color);
        ImGui::Checkbox(filters[i].name, &filterByLevel[i]);
        ImGui::PopStyleColor();

        if (i < 6) ImGui::SameLine();
    }

    // Search bar
    ImGui::SameLine();
    ImGui::SetNextItemWidth(200);
    ImGui::InputText("Search", searchFilter, sizeof(searchFilter));

    // Action buttons
    ImGui::SameLine();
    if (ImGui::Button("Clear All")) {
        Clear();
    }

    ImGui::SameLine();
    if (ImGui::Button("Copy Logs")) {
        CopyFilteredLogsToClipboard();
    }

    // Statistics
    ImGui::Text("Count: ");
    ImGui::SameLine();

    for (int i = 0; i < 7; i++) {
        if (logCounts[i] > 0) {
            ImGui::PushStyleColor(ImGuiCol_Text, filters[i].color);
            ImGui::Text("%s:%zu", filters[i].name, logCounts[i]);
            ImGui::PopStyleColor();
            ImGui::SameLine();
        }
    }

    ImGui::Text("| Total: %zu", logs.size());
}

void Debug::DrawLogPanel() {
    // Log area with scroll
    const float footer_height = ImGui::GetStyle().ItemSpacing.y + ImGui::GetFrameHeightWithSpacing();
    ImGui::BeginChild("LogScrollArea", ImVec2(0, -footer_height), true,
        ImGuiWindowFlags_HorizontalScrollbar);

    // Display filtered logs
    std::lock_guard<std::mutex> lock(logMutex);

    ImGuiListClipper clipper;
    std::vector<size_t> filtered_indices;

    // Build filtered list
    for (size_t i = 0; i < logs.size(); i++) {
        const auto& log = logs[i];

        // Apply level filter
        if (!filterByLevel[static_cast<int>(log.level)]) continue;

        // Apply search filter
        if (strlen(searchFilter) > 0) {
            std::string fullText = log.message + " " + log.file + " " + log.function;
            if (fullText.find(searchFilter) == std::string::npos) {
                continue;
            }
        }

        filtered_indices.push_back(i);
    }

    // Use clipper for performance with large logs
    clipper.Begin(static_cast<int>(filtered_indices.size()));

    while (clipper.Step()) {
        for (int row = clipper.DisplayStart; row < clipper.DisplayEnd; row++) {
            const auto& log = logs[filtered_indices[row]];

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
                    "[%s:%u]",
                    GetShortFileName(log.file).c_str(),
                    log.line);
                ImGui::SameLine();
            }

            // Display message
            ImGui::TextWrapped("%s", log.message.c_str());
        }
    }

    clipper.End();

    // Auto-scroll
    if (autoScroll && ImGui::GetScrollY() >= ImGui::GetScrollMaxY()) {
        ImGui::SetScrollHereY(1.0f);
    }

    ImGui::EndChild();
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
    case LogLevel::Trace:    return ImVec4(0.5f, 0.5f, 0.5f, 1.0f);
    case LogLevel::Debug:    return ImVec4(0.7f, 0.7f, 0.7f, 1.0f);
    case LogLevel::Info:     return ImVec4(0.8f, 0.8f, 0.8f, 1.0f);
    case LogLevel::Warning:  return ImVec4(1.0f, 1.0f, 0.0f, 1.0f);
    case LogLevel::Error:    return ImVec4(1.0f, 0.0f, 0.0f, 1.0f);
    case LogLevel::Critical: return ImVec4(1.0f, 0.0f, 1.0f, 1.0f);
    case LogLevel::Success:  return ImVec4(0.0f, 1.0f, 0.0f, 1.0f);
    default:                 return ImVec4(1.0f, 1.0f, 1.0f, 1.0f);
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
        text.reserve(logs.size() * 100);

        for (const auto& log : logs) {
            text += "[";
            text += GetLogLevelString(log.level);
            text += "] ";
            text += log.message;
            text += "\n";
        }
    }

    if (!text.empty()) {
        ImGui::SetClipboardText(text.c_str());
        LOG_SUCCESS("Logs copied to clipboard (%zu bytes)", text.size());
    }
}

void Debug::CopyFilteredLogsToClipboard() {
    std::string text;

    {
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

            // Build log line
            if (showTimestamps) {
                text += "[" + FormatTimestamp(log.timestamp) + "] ";
            }

            text += "[";
            text += GetLogLevelString(log.level);
            text += "] ";

            if (showFileInfo) {
                text += "[" + GetShortFileName(log.file) + ":" +
                    std::to_string(log.line) + "] ";
            }

            text += log.message;
            text += "\n";
        }
    }

    if (!text.empty()) {
        ImGui::SetClipboardText(text.c_str());
        LOG_SUCCESS("Filtered logs copied to clipboard (%zu bytes)", text.size());
    }
    else {
        LOG_INFO("No filtered logs to copy");
    }
}