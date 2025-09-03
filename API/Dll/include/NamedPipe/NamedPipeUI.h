#pragma once

#include <Windows.h>
#include <imgui.h>
#include <string>
#include <chrono>
#include <mutex>
#include <deque>

namespace GW {
    class NamedPipeServer;

    class NamedPipeUI {
    public:
        // Structure pour stocker les logs du serveur
        struct LogEntry {
            enum Type {
                Info,
                Error,
                Success,
                Warning,
                Request,
                Response
            };

            Type type;
            std::string message;
            std::chrono::system_clock::time_point timestamp;

            LogEntry(Type t, const std::string& msg)
                : type(t), message(msg), timestamp(std::chrono::system_clock::now()) {
            }
        };

        // Structure pour les statistiques
        struct Statistics {
            size_t totalRequests = 0;
            size_t successfulRequests = 0;
            size_t failedRequests = 0;
            size_t totalConnections = 0;
            size_t bytesReceived = 0;
            size_t bytesSent = 0;
            std::chrono::system_clock::time_point startTime;
            std::chrono::system_clock::time_point lastRequestTime;

            void Reset() {
                totalRequests = 0;
                successfulRequests = 0;
                failedRequests = 0;
                totalConnections = 0;
                bytesReceived = 0;
                bytesSent = 0;
                startTime = std::chrono::system_clock::now();
                lastRequestTime = {};
            }
        };

    private:
        static NamedPipeUI* instance;
        static constexpr size_t MAX_LOGS = 500;

        // État
        bool showWindow;

        // Logs et statistiques
        std::deque<LogEntry> logs;
        std::mutex logMutex;
        Statistics stats;

        // Paramètres UI
        bool autoScrollLogs;
        bool showTimestamps;
        bool filterByType[6]; // Info, Error, Success, Warning, Request, Response
        char searchFilter[256];

        // Référence au serveur
        NamedPipeServer* server;

        // Méthodes privées
        void DrawServerControl();
        void DrawStatistics();
        void DrawLogPanel();

        ImVec4 GetLogColor(LogEntry::Type type) const;
        std::string FormatTimestamp(const std::chrono::system_clock::time_point& time) const;
        std::string FormatDuration(const std::chrono::duration<double>& duration) const;
        std::string FormatBytes(size_t bytes) const;

        // Callbacks pour le serveur
        void OnServerLog(const std::string& message);
        void OnServerError(const std::string& message);

    public:
        NamedPipeUI();
        ~NamedPipeUI();

        // Singleton
        static NamedPipeUI& GetInstance();
        static void Destroy();

        // Initialisation
        void Initialize();
        void Shutdown();

        // UI
        void Draw();
        void ToggleWindow() { showWindow = !showWindow; }
        bool IsWindowVisible() const { return showWindow; }

        // Contrôle du serveur
        bool StartServer();
        bool StopServer();
        bool IsServerRunning() const;

        // Logs
        void AddLog(LogEntry::Type type, const std::string& message);
        void ClearLogs();
        void CopyLogsToClipboard();

        // Statistiques
        void UpdateStatistics(int requestType, bool success, size_t bytesIn, size_t bytesOut);
        void ResetStatistics() { stats.Reset(); }
    };
}