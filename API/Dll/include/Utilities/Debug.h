#pragma once

#include <Windows.h>
#include <cstdarg>
#include <cstdio>
#include <string>
#include <deque>
#include <mutex>
#include <chrono>
#include <imgui.h>

// Assertion macro
#define ASSERT(expr) ((void)(!!(expr) || (Debug::FatalAssert(#expr, __FILE__, (unsigned)__LINE__, __FUNCTION__), 0)))

// Logging macros
#define LOG_TRACE(fmt, ...) Debug::LogMessage(Debug::LogLevel::Trace, __FILE__, (unsigned)__LINE__, __FUNCTION__, fmt, ##__VA_ARGS__)
#define LOG_DEBUG(fmt, ...) Debug::LogMessage(Debug::LogLevel::Debug, __FILE__, (unsigned)__LINE__, __FUNCTION__, fmt, ##__VA_ARGS__)
#define LOG_INFO(fmt, ...) Debug::LogMessage(Debug::LogLevel::Info, __FILE__, (unsigned)__LINE__, __FUNCTION__, fmt, ##__VA_ARGS__)
#define LOG_WARN(fmt, ...) Debug::LogMessage(Debug::LogLevel::Warning, __FILE__, (unsigned)__LINE__, __FUNCTION__, fmt, ##__VA_ARGS__)
#define LOG_ERROR(fmt, ...) Debug::LogMessage(Debug::LogLevel::Error, __FILE__, (unsigned)__LINE__, __FUNCTION__, fmt, ##__VA_ARGS__)
#define LOG_CRITICAL(fmt, ...) Debug::LogMessage(Debug::LogLevel::Critical, __FILE__, (unsigned)__LINE__, __FUNCTION__, fmt, ##__VA_ARGS__)
#define LOG_SUCCESS(fmt, ...) Debug::LogMessage(Debug::LogLevel::Success, __FILE__, (unsigned)__LINE__, __FUNCTION__, fmt, ##__VA_ARGS__)

class Debug {
public:
    // Log levels
    enum class LogLevel {
        Trace,
        Debug,
        Info,
        Warning,
        Error,
        Critical,
        Success
    };

    // Handler function types
    typedef void (*LogHandler)(
        void* context,
        LogLevel level,
        const char* msg,
        const char* file,
        unsigned int line,
        const char* function
        );

    typedef void (*PanicHandler)(
        void* context,
        const char* expr,
        const char* file,
        unsigned int line,
        const char* function
        );

    // Singleton access
    static Debug& GetInstance();
    static void Destroy();

    // Handler registration
    static void RegisterLogHandler(LogHandler handler, void* context = nullptr);
    static void RegisterPanicHandler(PanicHandler handler, void* context = nullptr);

    // Fatal assert
    __declspec(noreturn) static void FatalAssert(
        const char* expr,
        const char* file,
        unsigned int line,
        const char* function
    );

    // Logging functions
    static void __cdecl LogMessage(
        LogLevel level,
        const char* file,
        unsigned int line,
        const char* function,
        const char* fmt,
        ...
    );

    static void __cdecl LogMessageV(
        LogLevel level,
        const char* file,
        unsigned int line,
        const char* function,
        const char* fmt,
        va_list args
    );

    // ImGui rendering
    void Draw();
    void ToggleWindow();
    bool IsWindowVisible() const { return showDebugWindow; }

    // Clear logs
    void Clear();

    // Copy logs to clipboard
    void CopyLogsToClipboard();
    void CopyFilteredLogsToClipboard();

private:
    struct LogEntry {
        LogLevel level;
        std::string message;
        std::string file;
        std::string function;
        unsigned int line;
        std::chrono::system_clock::time_point timestamp;

        LogEntry(LogLevel l, const std::string& msg, const std::string& f,
            unsigned int ln, const std::string& func)
            : level(l), message(msg), file(f), line(ln), function(func),
            timestamp(std::chrono::system_clock::now()) {
        }
    };

    static Debug* instance;

    // Handlers
    static LogHandler s_LogHandler;
    static void* s_LogHandlerContext;
    static PanicHandler s_PanicHandler;
    static void* s_PanicHandlerContext;

    // Log storage
    std::deque<LogEntry> logs;
    std::mutex logMutex;

    // Window settings
    bool showDebugWindow;
    bool autoScroll;
    bool showTimestamps;
    bool showFileInfo;
    bool filterByLevel[7]; // Trace, Debug, Info, Warning, Error, Critical, Success
    char searchFilter[256];
    size_t maxLogs;

    // Statistics
    size_t logCounts[7];

    // Constructor/Destructor
    Debug();
    ~Debug();

    // Internal logging
    void InternalLog(LogLevel level, const char* message, const char* file,
        unsigned int line, const char* function);

    // ImGui helpers
    void DrawControlPanel();
    void DrawLogPanel();

    // Utility functions
    const char* GetLogLevelString(LogLevel level) const;
    ImVec4 GetLogLevelColor(LogLevel level) const;
    std::string FormatTimestamp(const std::chrono::system_clock::time_point& time) const;
    std::string GetShortFileName(const std::string& fullPath) const;
};