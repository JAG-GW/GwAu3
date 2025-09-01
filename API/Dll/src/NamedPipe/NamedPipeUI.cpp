#include "NamedPipe/NamedPipeUI.h"
#include "NamedPipe/NamedPipeServer.h"
#include "Utilities/Debug.h"
#include <sstream>
#include <iomanip>
#include <algorithm>

namespace GW {

    NamedPipeUI* NamedPipeUI::instance = nullptr;

    NamedPipeUI::NamedPipeUI()
        : showWindow(false)
        , serverAutoStart(true)
        , pipeName("\\\\.\\pipe\\GWToolsPipe")
        , customPipeName("")
        , maxLogs(500)
        , autoScrollLogs(true)
        , showTimestamps(true)
        , server(nullptr) {

        // Initialiser les filtres (tous activés par défaut)
        for (int i = 0; i < 6; i++) {
            filterByType[i] = true;
        }

        memset(searchFilter, 0, sizeof(searchFilter));

        // Charger la configuration
        LoadConfig();
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

        // Démarrer le serveur si configuré
        if (serverAutoStart) {
            StartServer();
        }

        // Initialiser les statistiques
        stats.Reset();

        LOG_SUCCESS("NamedPipe UI initialized");
    }

    void NamedPipeUI::Shutdown() {
        if (server && server->IsRunning()) {
            StopServer();
        }
        SaveConfig();
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

        std::string pipeToUse = customPipeName.empty() ? pipeName : customPipeName;

        if (server->Start(pipeToUse)) {
            AddLog(LogEntry::Success, "Server started on: " + pipeToUse);
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

    void NamedPipeUI::ToggleServer() {
        if (IsServerRunning()) {
            StopServer();
        }
        else {
            StartServer();
        }
    }

    void NamedPipeUI::Draw() {
        if (!showWindow) return;

        ImGui::SetNextWindowSize(ImVec2(800, 600), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowPos(ImVec2(100, 100), ImGuiCond_FirstUseEver);

        if (ImGui::Begin("Named Pipe Server Control", &showWindow, ImGuiWindowFlags_MenuBar)) {
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
                    if (ImGui::MenuItem("Save Configuration")) {
                        SaveConfig();
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
                    ImGui::Separator();
                    ImGui::SliderInt("Max Logs", (int*)&maxLogs, 100, 2000);
                    ImGui::EndMenu();
                }

                if (ImGui::BeginMenu("Server")) {
                    if (ImGui::MenuItem("Start", nullptr, false, !IsServerRunning())) {
                        StartServer();
                    }
                    if (ImGui::MenuItem("Stop", nullptr, false, IsServerRunning())) {
                        StopServer();
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
                if (ImGui::BeginTabItem("Statistics")) {
                    DrawStatistics();
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("Logs")) {
                    DrawLogPanel();
                    ImGui::EndTabItem();
                }

                if (ImGui::BeginTabItem("Configuration")) {
                    DrawConfiguration();
                    ImGui::EndTabItem();
                }

                ImGui::EndTabBar();
            }
        }
        ImGui::End();
    }

    void NamedPipeUI::DrawServerControl() {
        ImGui::BeginChild("ServerControl", ImVec2(0, 100), true);

        // État du serveur
        bool isRunning = IsServerRunning();
        ImVec4 statusColor = isRunning ? ImVec4(0.0f, 1.0f, 0.0f, 1.0f) : ImVec4(1.0f, 0.0f, 0.0f, 1.0f);

        ImGui::TextColored(statusColor, "Server Status: %s", isRunning ? "RUNNING" : "STOPPED");

        if (isRunning) {
            // Durée d'exécution
            auto now = std::chrono::system_clock::now();
            auto uptime = now - stats.startTime;
            ImGui::Text("Uptime: %s", FormatDuration(uptime).c_str());

            // Pipe name actuel
            std::string currentPipe = customPipeName.empty() ? pipeName : customPipeName;
            ImGui::Text("Pipe: %s", currentPipe.c_str());
        }

        ImGui::SameLine(ImGui::GetWindowWidth() - 250);

        // Boutons de contrôle
        if (!isRunning) {
            ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.0f, 0.5f, 0.0f, 1.0f));
            if (ImGui::Button("Start Server", ImVec2(100, 30))) {
                StartServer();
            }
            ImGui::PopStyleColor();
        }
        else {
            ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.5f, 0.0f, 0.0f, 1.0f));
            if (ImGui::Button("Stop Server", ImVec2(100, 30))) {
                StopServer();
            }
            ImGui::PopStyleColor();
        }

        ImGui::SameLine();

        // Bouton Toggle
        if (ImGui::Button(isRunning ? "Restart" : "Quick Start", ImVec2(100, 30))) {
            if (isRunning) {
                StopServer();
                StartServer();
            }
            else {
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

        // Graphiques (placeholder pour futur développement)
        if (ImGui::CollapsingHeader("Performance Graphs")) {
            ImGui::Text("Request rate graph would go here");
            // TODO: Implémenter des graphiques de performance
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

        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.8f, 0.8f, 0.8f, 1.0f));
        ImGui::Checkbox("Info", &filterByType[0]);
        ImGui::PopStyleColor();
        ImGui::SameLine();

        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 1.0f));
        ImGui::Checkbox("Error", &filterByType[1]);
        ImGui::PopStyleColor();
        ImGui::SameLine();

        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f));
        ImGui::Checkbox("Success", &filterByType[2]);
        ImGui::PopStyleColor();
        ImGui::SameLine();

        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 0.0f, 1.0f));
        ImGui::Checkbox("Warning", &filterByType[3]);
        ImGui::PopStyleColor();
        ImGui::SameLine();

        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.5f, 0.5f, 1.0f, 1.0f));
        ImGui::Checkbox("Request", &filterByType[4]);
        ImGui::PopStyleColor();
        ImGui::SameLine();

        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.5f, 1.0f, 0.5f, 1.0f));
        ImGui::Checkbox("Response", &filterByType[5]);
        ImGui::PopStyleColor();

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
        ImGui::BeginChild("LogScrollArea", ImVec2(0, 0), true,
            ImGuiWindowFlags_HorizontalScrollbar);

        std::lock_guard<std::mutex> lock(logMutex);

        for (const auto& log : logs) {
            // Appliquer les filtres
            if (!filterByType[static_cast<int>(log.type)]) continue;

            // Filtre de recherche
            if (strlen(searchFilter) > 0) {
                if (log.message.find(searchFilter) == std::string::npos) {
                    continue;
                }
            }

            // Afficher timestamp si activé
            if (showTimestamps) {
                ImGui::TextColored(ImVec4(0.5f, 0.5f, 0.5f, 1.0f),
                    "[%s]", FormatTimestamp(log.timestamp).c_str());
                ImGui::SameLine();
            }

            // Afficher le message avec la couleur appropriée
            ImGui::TextColored(GetLogColor(log.type), "%s", log.message.c_str());
        }

        // Auto-scroll
        if (autoScrollLogs && ImGui::GetScrollY() >= ImGui::GetScrollMaxY()) {
            ImGui::SetScrollHereY(1.0f);
        }

        ImGui::EndChild();
    }

    void NamedPipeUI::DrawConfiguration() {
        ImGui::BeginChild("Configuration", ImVec2(0, 0), true);

        ImGui::Text("Server Configuration");
        ImGui::Separator();

        // Auto-start
        if (ImGui::Checkbox("Auto-start server on launch", &serverAutoStart)) {
            SaveConfig();
        }

        // Pipe name configuration
        ImGui::Text("Pipe Name:");

        if (ImGui::RadioButton("Default", customPipeName.empty())) {
            customPipeName.clear();
        }
        ImGui::SameLine();
        ImGui::Text("(%s)", pipeName.c_str());

        if (ImGui::RadioButton("Custom", !customPipeName.empty())) {
            if (customPipeName.empty()) {
                customPipeName = pipeName;
            }
        }

        if (!customPipeName.empty()) {
            char buffer[256];
            strcpy_s(buffer, customPipeName.c_str());
            if (ImGui::InputText("Custom Pipe", buffer, sizeof(buffer))) {
                customPipeName = buffer;
            }

            if (ImGui::Button("Apply Custom Pipe")) {
                if (IsServerRunning()) {
                    StopServer();
                    StartServer();
                }
                SaveConfig();
            }
        }

        ImGui::Separator();

        // Logging configuration
        ImGui::Text("Logging Configuration");

        ImGui::SliderInt("Max Log Entries", (int*)&maxLogs, 100, 2000);
        ImGui::Checkbox("Auto-scroll logs", &autoScrollLogs);
        ImGui::Checkbox("Show timestamps", &showTimestamps);

        ImGui::Separator();

        // Boutons de configuration
        if (ImGui::Button("Save Configuration")) {
            SaveConfig();
            AddLog(LogEntry::Success, "Configuration saved");
        }

        ImGui::SameLine();

        if (ImGui::Button("Reset to Defaults")) {
            serverAutoStart = true;
            customPipeName.clear();
            maxLogs = 500;
            autoScrollLogs = true;
            showTimestamps = true;
            SaveConfig();
            AddLog(LogEntry::Info, "Configuration reset to defaults");
        }

        ImGui::EndChild();
    }

    void NamedPipeUI::AddLog(LogEntry::Type type, const std::string& message) {
        std::lock_guard<std::mutex> lock(logMutex);

        logs.emplace_back(type, message);

        // Limiter le nombre de logs
        while (logs.size() > maxLogs) {
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

    void NamedPipeUI::OnClientConnected() {
        stats.totalConnections++;
        AddLog(LogEntry::Success, "Client connected");
    }

    void NamedPipeUI::OnClientDisconnected() {
        AddLog(LogEntry::Info, "Client disconnected");
    }

    void NamedPipeUI::OnRequestReceived(int requestType, bool success) {
        stats.totalRequests++;
        if (success) {
            stats.successfulRequests++;
        }
        else {
            stats.failedRequests++;
        }
        stats.lastRequestTime = std::chrono::system_clock::now();
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

    void NamedPipeUI::LoadConfig() {
        std::string configPath = "GWTools.ini";

        serverAutoStart = GetPrivateProfileIntA("NamedPipe", "AutoStart", 1, configPath.c_str()) != 0;
        maxLogs = GetPrivateProfileIntA("NamedPipe", "MaxLogs", 500, configPath.c_str());
        autoScrollLogs = GetPrivateProfileIntA("NamedPipe", "AutoScroll", 1, configPath.c_str()) != 0;
        showTimestamps = GetPrivateProfileIntA("NamedPipe", "ShowTimestamps", 1, configPath.c_str()) != 0;

        char buffer[256];
        GetPrivateProfileStringA("NamedPipe", "CustomPipeName", "", buffer, sizeof(buffer), configPath.c_str());
        customPipeName = buffer;
    }

    void NamedPipeUI::SaveConfig() {
        std::string configPath = "GWTools.ini";

        WritePrivateProfileStringA("NamedPipe", "AutoStart",
            serverAutoStart ? "1" : "0", configPath.c_str());
        WritePrivateProfileStringA("NamedPipe", "MaxLogs",
            std::to_string(maxLogs).c_str(), configPath.c_str());
        WritePrivateProfileStringA("NamedPipe", "AutoScroll",
            autoScrollLogs ? "1" : "0", configPath.c_str());
        WritePrivateProfileStringA("NamedPipe", "ShowTimestamps",
            showTimestamps ? "1" : "0", configPath.c_str());
        WritePrivateProfileStringA("NamedPipe", "CustomPipeName",
            customPipeName.c_str(), configPath.c_str());
    }
}