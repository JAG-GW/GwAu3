#include "NamedPipe/NamedPipeUI.h"
#include "NamedPipe/NamedPipeServer.h"
#include "Utilities/Debug.h"
#include <sstream>
#include <iomanip>

namespace GW {

    NamedPipeUI* NamedPipeUI::instance = nullptr;

    NamedPipeUI::NamedPipeUI()
        : showWindow(false)
        , autoScrollLogs(true)
        , showTimestamps(true)
        , server(nullptr) {

        // Initialiser les filtres (tous activés par défaut)
        for (int i = 0; i < 6; i++) {
            filterByType[i] = true;
        }

        memset(searchFilter, 0, sizeof(searchFilter));
    }

    NamedPipeUI::~NamedPipeUI() {
        Shutdown();
    }

    NamedPipeUI& NamedPipeUI::GetInstance() {
        if (!instance) {
            instance = new NamedPipeUI();
        }
        return *instance;
    }

    void NamedPipeUI::Destroy() {
        if (instance) {
            delete instance;
            instance = nullptr;
        }
    }

    void NamedPipeUI::Initialize() {
        // Obtenir l'instance du serveur
        server = &NamedPipeServer::GetInstance();

        // Configurer les callbacks
        server->OnLog = [this](const std::string& msg) {
            OnServerLog(msg);
            };

        server->OnError = [this](const std::string& msg) {
            OnServerError(msg);
            };

        server->OnClientConnected = [this](const std::string& msg) {
            stats.totalConnections++;
            AddLog(LogEntry::Success, "Client connected");
            };

        server->OnClientDisconnected = [this](const std::string& msg) {
            AddLog(LogEntry::Info, "Client disconnected");
            };

        // Démarrer le serveur automatiquement
        StartServer();

        // Initialiser les statistiques
        stats.Reset();

        LOG_SUCCESS("NamedPipe UI initialized and server started");
    }

    void NamedPipeUI::Shutdown() {
        if (server && server->IsRunning()) {
            StopServer();
        }
    }

    bool NamedPipeUI::StartServer() {
        if (!server) {
            AddLog(LogEntry::Error, "Server instance not available");
            return false;
        }

        if (server->IsRunning()) {
            AddLog(LogEntry::Warning, "Server is already running");
            return true;
        }

        if (server->Start(GetPipeName().c_str())) {
            AddLog(LogEntry::Success, std::string("Server started on: ") + GetPipeName().c_str());
            stats.startTime = std::chrono::system_clock::now();
            return true;
        }
        else {
            AddLog(LogEntry::Error, "Failed to start server");
            return false;
        }
    }

    bool NamedPipeUI::StopServer() {
        if (!server) {
            AddLog(LogEntry::Error, "Server instance not available");
            return false;
        }

        if (!server->IsRunning()) {
            AddLog(LogEntry::Warning, "Server is not running");
            return true;
        }

        server->Stop();
        AddLog(LogEntry::Info, "Server stopped");
        return true;
    }

    bool NamedPipeUI::IsServerRunning() const {
        return server && server->IsRunning();
    }

    void NamedPipeUI::Draw() {
        if (!showWindow) return;

        ImGui::SetNextWindowSize(ImVec2(800, 600), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowPos(ImVec2(100, 100), ImGuiCond_FirstUseEver);

        if (ImGui::Begin("Named Pipe Server", &showWindow, ImGuiWindowFlags_MenuBar)) {
            // Menu bar
            if (ImGui::BeginMenuBar()) {
                if (ImGui::BeginMenu("File")) {
                    if (ImGui::MenuItem("Clear Logs", "Ctrl+L")) {
                        ClearLogs();
                    }
                    if (ImGui::MenuItem("Copy Logs", "Ctrl+C")) {
                        CopyLogsToClipboard();
                    }
                    ImGui::Separator();
                    if (ImGui::MenuItem("Close", "Esc")) {
                        showWindow = false;
                    }
                    ImGui::EndMenu();
                }

                if (ImGui::BeginMenu("View")) {
                    ImGui::MenuItem("Auto-scroll", nullptr, &autoScrollLogs);
                    ImGui::MenuItem("Show Timestamps", nullptr, &showTimestamps);
                    ImGui::EndMenu();
                }

                if (ImGui::BeginMenu("Server")) {
                    if (ImGui::MenuItem("Start", nullptr, false, !IsServerRunning())) {
                        StartServer();
                    }
                    if (ImGui::MenuItem("Stop", nullptr, false, IsServerRunning())) {
                        StopServer();
                    }
                    if (ImGui::MenuItem("Restart", nullptr, false, IsServerRunning())) {
                        StopServer();
                        StartServer();
                    }
                    ImGui::Separator();
                    if (ImGui::MenuItem("Reset Statistics")) {
                        ResetStatistics();
                    }
                    ImGui::EndMenu();
                }

                ImGui::EndMenuBar();
            }

            // Panneau de contrôle principal
            DrawServerControl();

            ImGui::Separator();

            // Tabs pour différentes sections
            if (ImGui::BeginTabBar("ServerTabs")) {
                if (ImGui::BeginTabItem("Logs")) {
                    DrawLogPanel();
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("Statistics")) {
                    DrawStatistics();
                    ImGui::EndTabItem();
                }

                ImGui::EndTabBar();
            }
        }
        ImGui::End();
    }

    void NamedPipeUI::DrawServerControl() {
        ImGui::BeginChild("ServerControl", ImVec2(0, 80), true);

        // État du serveur
        bool isRunning = IsServerRunning();
        ImVec4 statusColor = isRunning ? ImVec4(0.0f, 1.0f, 0.0f, 1.0f) : ImVec4(1.0f, 0.0f, 0.0f, 1.0f);

        ImGui::TextColored(statusColor, "Server Status: %s", isRunning ? "RUNNING" : "STOPPED");

        if (isRunning) {
            // Durée d'exécution
            auto now = std::chrono::system_clock::now();
            auto uptime = now - stats.startTime;
            ImGui::Text("Uptime: %s", FormatDuration(uptime).c_str());
            ImGui::Text("Pipe: %s", GetPipeName().c_str());
        }
        else {
            ImGui::Text("Server is not running");

            // Bouton pour redémarrer si arrêté
            if (ImGui::Button("Start Server")) {
                StartServer();
            }
        }

        // Statistiques rapides
        ImGui::Text("Connections: %zu | Requests: %zu | Success Rate: %.1f%%",
            stats.totalConnections,
            stats.totalRequests,
            stats.totalRequests > 0 ? (100.0f * stats.successfulRequests / stats.totalRequests) : 0.0f);

        ImGui::EndChild();
    }

    void NamedPipeUI::DrawStatistics() {
        ImGui::BeginChild("Statistics", ImVec2(0, 0), true);

        ImGui::Text("Server Statistics");
        ImGui::Separator();

        // Créer des colonnes pour l'affichage
        ImGui::Columns(2, "StatsColumns");

        // Colonne gauche
        ImGui::Text("Total Connections:");
        ImGui::Text("Total Requests:");
        ImGui::Text("Successful Requests:");
        ImGui::Text("Failed Requests:");
        ImGui::Text("Success Rate:");
        ImGui::Text("Bytes Received:");
        ImGui::Text("Bytes Sent:");

        ImGui::NextColumn();

        // Colonne droite avec les valeurs
        ImGui::Text("%zu", stats.totalConnections);
        ImGui::Text("%zu", stats.totalRequests);
        ImGui::TextColored(ImVec4(0, 1, 0, 1), "%zu", stats.successfulRequests);
        ImGui::TextColored(ImVec4(1, 0, 0, 1), "%zu", stats.failedRequests);

        float successRate = stats.totalRequests > 0 ?
            (100.0f * stats.successfulRequests / stats.totalRequests) : 0.0f;
        ImVec4 rateColor = successRate >= 90.0f ? ImVec4(0, 1, 0, 1) :
            successRate >= 70.0f ? ImVec4(1, 1, 0, 1) :
            ImVec4(1, 0, 0, 1);
        ImGui::TextColored(rateColor, "%.1f%%", successRate);

        ImGui::Text("%s", FormatBytes(stats.bytesReceived).c_str());
        ImGui::Text("%s", FormatBytes(stats.bytesSent).c_str());

        ImGui::Columns(1);

        ImGui::Separator();

        // Temps depuis le démarrage
        if (IsServerRunning()) {
            auto now = std::chrono::system_clock::now();
            auto uptime = now - stats.startTime;
            ImGui::Text("Server Uptime: %s", FormatDuration(uptime).c_str());

            if (stats.lastRequestTime.time_since_epoch().count() > 0) {
                auto timeSinceLastRequest = now - stats.lastRequestTime;
                ImGui::Text("Last Request: %s ago", FormatDuration(timeSinceLastRequest).c_str());
            }
        }

        // Bouton pour réinitialiser les statistiques
        if (ImGui::Button("Reset Statistics")) {
            ResetStatistics();
            AddLog(LogEntry::Info, "Statistics reset");
        }

        ImGui::EndChild();
    }

    void NamedPipeUI::DrawLogPanel() {
        // Filtres
        ImGui::Text("Filters:");
        ImGui::SameLine();

        const char* filterNames[] = { "Info", "Error", "Success", "Warning", "Request", "Response" };
        ImVec4 filterColors[] = {
            ImVec4(0.8f, 0.8f, 0.8f, 1.0f),  // Info
            ImVec4(1.0f, 0.0f, 0.0f, 1.0f),  // Error
            ImVec4(0.0f, 1.0f, 0.0f, 1.0f),  // Success
            ImVec4(1.0f, 1.0f, 0.0f, 1.0f),  // Warning
            ImVec4(0.5f, 0.5f, 1.0f, 1.0f),  // Request
            ImVec4(0.5f, 1.0f, 0.5f, 1.0f)   // Response
        };

        for (int i = 0; i < 6; i++) {
            ImGui::PushStyleColor(ImGuiCol_Text, filterColors[i]);
            ImGui::Checkbox(filterNames[i], &filterByType[i]);
            ImGui::PopStyleColor();
            if (i < 5) ImGui::SameLine();
        }

        // Barre de recherche
        ImGui::SameLine();
        ImGui::SetNextItemWidth(200);
        ImGui::InputText("Search", searchFilter, sizeof(searchFilter));

        // Boutons
        ImGui::SameLine();
        if (ImGui::Button("Clear")) {
            ClearLogs();
        }

        ImGui::SameLine();
        if (ImGui::Button("Copy")) {
            CopyLogsToClipboard();
        }

        ImGui::Separator();

        // Zone de logs avec scroll
        const float footer_height = ImGui::GetStyle().ItemSpacing.y + ImGui::GetFrameHeightWithSpacing();
        ImGui::BeginChild("LogScrollArea", ImVec2(0, -footer_height), true,
            ImGuiWindowFlags_HorizontalScrollbar);

        std::lock_guard<std::mutex> lock(logMutex);

        // Utiliser un clipper pour la performance
        ImGuiListClipper clipper;
        std::vector<size_t> filtered_indices;

        // Construire la liste filtrée
        for (size_t i = 0; i < logs.size(); i++) {
            const auto& log = logs[i];

            // Appliquer les filtres
            if (!filterByType[static_cast<int>(log.type)]) continue;

            // Filtre de recherche
            if (strlen(searchFilter) > 0) {
                if (log.message.find(searchFilter) == std::string::npos) {
                    continue;
                }
            }

            filtered_indices.push_back(i);
        }

        clipper.Begin(static_cast<int>(filtered_indices.size()));

        while (clipper.Step()) {
            for (int row = clipper.DisplayStart; row < clipper.DisplayEnd; row++) {
                const auto& log = logs[filtered_indices[row]];

                // Afficher timestamp si activé
                if (showTimestamps) {
                    ImGui::TextColored(ImVec4(0.5f, 0.5f, 0.5f, 1.0f),
                        "[%s]", FormatTimestamp(log.timestamp).c_str());
                    ImGui::SameLine();
                }

                // Afficher le message avec la couleur appropriée
                ImGui::TextColored(GetLogColor(log.type), "%s", log.message.c_str());
            }
        }

        clipper.End();

        // Auto-scroll
        if (autoScrollLogs && ImGui::GetScrollY() >= ImGui::GetScrollMaxY()) {
            ImGui::SetScrollHereY(1.0f);
        }

        ImGui::EndChild();

        // Status bar
        ImGui::Text("Showing %zu/%zu logs", filtered_indices.size(), logs.size());
    }

    void NamedPipeUI::AddLog(LogEntry::Type type, const std::string& message) {
        std::lock_guard<std::mutex> lock(logMutex);

        logs.emplace_back(type, message);

        // Limiter le nombre de logs
        while (logs.size() > MAX_LOGS) {
            logs.pop_front();
        }
    }

    void NamedPipeUI::ClearLogs() {
        std::lock_guard<std::mutex> lock(logMutex);
        logs.clear();
    }

    void NamedPipeUI::CopyLogsToClipboard() {
        std::string text;

        {
            std::lock_guard<std::mutex> lock(logMutex);

            for (const auto& log : logs) {
                if (showTimestamps) {
                    text += "[" + FormatTimestamp(log.timestamp) + "] ";
                }
                text += log.message + "\n";
            }
        }

        if (!text.empty()) {
            ImGui::SetClipboardText(text.c_str());
            AddLog(LogEntry::Success, "Logs copied to clipboard");
        }
    }

    void NamedPipeUI::OnServerLog(const std::string& message) {
        AddLog(LogEntry::Info, message);
    }

    void NamedPipeUI::OnServerError(const std::string& message) {
        AddLog(LogEntry::Error, message);
    }

    void NamedPipeUI::UpdateStatistics(int requestType, bool success, size_t bytesIn, size_t bytesOut) {
        stats.totalRequests++;
        if (success) {
            stats.successfulRequests++;
        }
        else {
            stats.failedRequests++;
        }
        stats.bytesReceived += bytesIn;
        stats.bytesSent += bytesOut;
        stats.lastRequestTime = std::chrono::system_clock::now();
    }

    ImVec4 NamedPipeUI::GetLogColor(LogEntry::Type type) const {
        switch (type) {
        case LogEntry::Info:     return ImVec4(0.8f, 0.8f, 0.8f, 1.0f);
        case LogEntry::Error:    return ImVec4(1.0f, 0.0f, 0.0f, 1.0f);
        case LogEntry::Success:  return ImVec4(0.0f, 1.0f, 0.0f, 1.0f);
        case LogEntry::Warning:  return ImVec4(1.0f, 1.0f, 0.0f, 1.0f);
        case LogEntry::Request:  return ImVec4(0.5f, 0.5f, 1.0f, 1.0f);
        case LogEntry::Response: return ImVec4(0.5f, 1.0f, 0.5f, 1.0f);
        default:                 return ImVec4(1.0f, 1.0f, 1.0f, 1.0f);
        }
    }

    std::string NamedPipeUI::FormatTimestamp(const std::chrono::system_clock::time_point& time) const {
        auto time_t = std::chrono::system_clock::to_time_t(time);
        auto tm = *std::localtime(&time_t);

        char buffer[32];
        strftime(buffer, sizeof(buffer), "%H:%M:%S", &tm);

        auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
            time.time_since_epoch()) % 1000;

        char finalBuffer[64];
        snprintf(finalBuffer, sizeof(finalBuffer), "%s.%03lld", buffer, ms.count());

        return std::string(finalBuffer);
    }

    std::string NamedPipeUI::FormatDuration(const std::chrono::duration<double>& duration) const {
        auto seconds = std::chrono::duration_cast<std::chrono::seconds>(duration).count();

        int days = seconds / 86400;
        int hours = (seconds % 86400) / 3600;
        int minutes = (seconds % 3600) / 60;
        int secs = seconds % 60;

        std::stringstream ss;
        if (days > 0) {
            ss << days << "d ";
        }
        if (hours > 0 || days > 0) {
            ss << hours << "h ";
        }
        if (minutes > 0 || hours > 0 || days > 0) {
            ss << minutes << "m ";
        }
        ss << secs << "s";

        return ss.str();
    }

    std::string NamedPipeUI::FormatBytes(size_t bytes) const {
        const char* units[] = { "B", "KB", "MB", "GB" };
        int unitIndex = 0;
        double size = static_cast<double>(bytes);

        while (size >= 1024.0 && unitIndex < 3) {
            size /= 1024.0;
            unitIndex++;
        }

        char buffer[32];
        snprintf(buffer, sizeof(buffer), "%.2f %s", size, units[unitIndex]);
        return std::string(buffer);
    }
}