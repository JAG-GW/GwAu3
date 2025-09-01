#include "NamedPipe/NamedPipeServer.h"
#include "Utilities/Scanner.h"
#include "Utilities/Debug.h"
#include <sstream>
#include <iomanip>
#include <cstddef>

namespace GW {

    NamedPipeServer* NamedPipeServer::instance = nullptr;

    NamedPipeServer::NamedPipeServer()
        : hPipe(INVALID_HANDLE_VALUE)
        , running(false) {
    }

    NamedPipeServer::~NamedPipeServer() {
        Stop();
    }

    NamedPipeServer& NamedPipeServer::GetInstance() {
        if (!instance) {
            instance = new NamedPipeServer();
        }
        return *instance;
    }

    void NamedPipeServer::Destroy() {
        if (instance) {
            delete instance;
            instance = nullptr;
        }
    }

    bool NamedPipeServer::Start(const std::string& pipeName) {
        if (running) {
            if (OnError) OnError("Server already running");
            return false;
        }

        this->pipeName = pipeName;
        running = true;

        // Log les tailles des structures pour debug
        LOG_INFO("Structure sizes - ScanRequest: %zu bytes, ScanResponse: %zu bytes",
            sizeof(ScanRequest), sizeof(ScanResponse));

        // Démarrer le thread serveur - IMPORTANT: detach() pour ne pas bloquer
        serverThread = std::thread(&NamedPipeServer::ServerLoop, this);
        serverThread.detach(); // NE PAS utiliser join() qui bloque!

        if (OnLog) OnLog("Named pipe server started on: " + pipeName);
        LOG_SUCCESS("Named pipe server started: %s", pipeName.c_str());

        return true;
    }

    void NamedPipeServer::Stop() {
        if (!running) return;

        LOG_INFO("Stopping Named Pipe server...");

        // Signaler l'arrêt
        running = false;

        // Si nous avons un pipe actif, le fermer pour débloquer ConnectNamedPipe
        if (hPipe != INVALID_HANDLE_VALUE) {
            // Créer un client temporaire pour débloquer ConnectNamedPipe si nécessaire
            HANDLE hTempClient = CreateFileA(
                pipeName.c_str(),
                GENERIC_READ | GENERIC_WRITE,
                0,
                NULL,
                OPEN_EXISTING,
                0,
                NULL
            );

            if (hTempClient != INVALID_HANDLE_VALUE) {
                CloseHandle(hTempClient);
            }

            // Fermer le pipe serveur
            DisconnectNamedPipe(hPipe);
            CloseHandle(hPipe);
            hPipe = INVALID_HANDLE_VALUE;
        }

        // NE PAS faire join() sur le thread car on l'a detach
        // Le thread va se terminer tout seul quand running = false

        // Attendre un peu que le thread se termine
        Sleep(100);

        if (OnLog) OnLog("Named pipe server stopped");
        LOG_INFO("Named pipe server stopped");
    }

    void NamedPipeServer::ServerLoop() {
        // Thread séparé pour le serveur
        SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_BELOW_NORMAL);

        // Créer un Security Descriptor qui permet l'accès à tous
        SECURITY_DESCRIPTOR sd;
        InitializeSecurityDescriptor(&sd, SECURITY_DESCRIPTOR_REVISION);
        SetSecurityDescriptorDacl(&sd, TRUE, NULL, FALSE);

        SECURITY_ATTRIBUTES sa;
        sa.nLength = sizeof(SECURITY_ATTRIBUTES);
        sa.lpSecurityDescriptor = &sd;
        sa.bInheritHandle = FALSE;

        while (running) {
            // Créer le named pipe avec permissions ouvertes
            hPipe = CreateNamedPipeA(
                pipeName.c_str(),
                PIPE_ACCESS_DUPLEX,
                PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
                PIPE_UNLIMITED_INSTANCES,
                sizeof(ScanResponse),
                sizeof(ScanRequest),
                0,
                &sa
            );

            if (hPipe == INVALID_HANDLE_VALUE) {
                if (running) { // Ne log l'erreur que si on n'est pas en train de s'arrêter
                    if (OnError) OnError("Failed to create named pipe: " + std::to_string(GetLastError()));
                    LOG_ERROR("Failed to create named pipe: %lu", GetLastError());
                }
                running = false;
                return;
            }

            // Utiliser un mode non-bloquant avec timeout
            COMMTIMEOUTS timeouts;
            timeouts.ReadIntervalTimeout = 100;
            timeouts.ReadTotalTimeoutMultiplier = 10;
            timeouts.ReadTotalTimeoutConstant = 100;
            timeouts.WriteTotalTimeoutMultiplier = 10;
            timeouts.WriteTotalTimeoutConstant = 100;

            // Attendre une connexion client avec vérification périodique de running
            BOOL connected = FALSE;
            while (running && !connected) {
                connected = ConnectNamedPipe(hPipe, NULL) ?
                    TRUE : (GetLastError() == ERROR_PIPE_CONNECTED);

                if (!connected && running) {
                    // Vérifier si on doit s'arrêter
                    if (!running) break;

                    // Attendre un peu avant de réessayer
                    Sleep(50);
                }
            }

            if (connected && running) {
                if (OnLog) OnLog("Client connected");
                LOG_INFO("Named pipe client connected");

                // Traiter les requêtes du client dans un try-catch
                try {
                    ProcessClient(hPipe);
                }
                catch (...) {
                    LOG_ERROR("Exception while processing client");
                }

                if (OnLog) OnLog("Client disconnected");
                LOG_INFO("Named pipe client disconnected");
            }

            // Fermer le pipe pour cette instance
            if (hPipe != INVALID_HANDLE_VALUE) {
                DisconnectNamedPipe(hPipe);
                CloseHandle(hPipe);
                hPipe = INVALID_HANDLE_VALUE;
            }
        }

        LOG_INFO("Named Pipe server thread exiting");
    }

    void NamedPipeServer::ProcessClient(HANDLE clientPipe) {
        ScanRequest request;
        ScanResponse response;
        DWORD bytesRead, bytesWritten;

        // Définir un timeout pour les opérations de lecture
        DWORD timeout = 5000; // 5 secondes

        while (running) {
            // Vérifier si le pipe est toujours valide
            DWORD flags = 0;
            if (!GetNamedPipeInfo(clientPipe, &flags, NULL, NULL, NULL)) {
                break; // Pipe invalide
            }

            // Lire la requête du client avec timeout
            BOOL success = ReadFile(
                clientPipe,
                &request,
                sizeof(request),
                &bytesRead,
                NULL
            );

            if (!success || bytesRead == 0) {
                DWORD error = GetLastError();
                if (error != ERROR_BROKEN_PIPE && error != ERROR_PIPE_NOT_CONNECTED) {
                    if (running && OnError) OnError("Read error: " + std::to_string(error));
                    if (running) LOG_ERROR("Named pipe read error: %lu", error);
                }
                break;
            }

            // Vérifier si on doit s'arrêter
            if (!running) break;

            // Traiter la requête
            memset(&response, 0, sizeof(response));

            try {
                HandleRequest(request, response);
            }
            catch (...) {
                response.success = 0;
                strcpy_s(response.error_message, "Exception during request handling");
            }

            // Envoyer la réponse
            success = WriteFile(
                clientPipe,
                &response,
                sizeof(response),
                &bytesWritten,
                NULL
            );

            if (!success) {
                DWORD error = GetLastError();
                if (running && OnError) OnError("Write error: " + std::to_string(error));
                if (running) LOG_ERROR("Named pipe write error: %lu", error);
                break;
            }

            // Flush pour s'assurer que les données sont envoyées
            FlushFileBuffers(clientPipe);
        }
    }

    void NamedPipeServer::HandleRequest(const ScanRequest& request, ScanResponse& response) {
        // Vérifier qu'on est toujours en cours d'exécution
        if (!running) {
            response.success = 0;
            strcpy_s(response.error_message, "Server is shutting down");
            return;
        }

        try {
            switch (request.type) {
            case ScanRequest::SCAN_FIND: {
                if (OnLog) {
                    std::stringstream ss;
                    ss << "SCAN_FIND request - Pattern: " << request.pattern;
                    ss << ", Mask: " << request.mask;
                    ss << ", Offset: " << request.offset;
                    ss << ", Section: " << (int)request.section;
                    OnLog(ss.str());
                }

                // Convertir le pattern hexadécimal si nécessaire
                std::string pattern;
                if (ParseHexPattern(request.pattern, pattern)) {
                    if (OnLog) {
                        OnLog("Using parsed hex pattern");
                    }
                }
                else {
                    pattern = std::string(request.pattern, strlen(request.pattern));
                    if (OnLog) {
                        std::stringstream ss;
                        ss << "Using raw pattern, length: " << pattern.length();
                        OnLog(ss.str());
                    }
                }

                response.result = Scanner::Find(
                    pattern.c_str(),
                    strlen(request.mask) > 0 ? request.mask : nullptr,
                    request.offset,
                    (ScannerSection)request.section
                );

                response.success = (response.result != 0) ? 1 : 0;
                if (!response.success) {
                    strcpy_s(response.error_message, "Pattern not found");
                }

                if (OnLog) {
                    std::stringstream ss;
                    ss << "SCAN_FIND result: 0x" << std::hex << response.result;
                    ss << " (success: " << (response.success ? "true" : "false") << ")";
                    OnLog(ss.str());
                }
                break;
            }

            case ScanRequest::SCAN_FIND_ASSERTION: {
                if (OnLog) {
                    OnLog("SCAN_FIND_ASSERTION request - File: " +
                        std::string(request.assertion_file) +
                        ", Msg: " + std::string(request.assertion_msg) +
                        ", Line: " + std::to_string(request.line_number) +
                        ", Offset: " + std::to_string(request.offset));
                }

                try {
                    response.result = Scanner::FindAssertion(
                        request.assertion_file,
                        request.assertion_msg,
                        request.line_number,
                        request.offset
                    );

                    if (OnLog) {
                        std::stringstream ss;
                        ss << "SCAN_FIND_ASSERTION result: 0x" << std::hex << response.result;
                        ss << " (success: " << (response.result != 0 ? "true" : "false") << ")";
                        OnLog(ss.str());
                    }
                }
                catch (const std::exception& e) {
                    if (OnError) OnError("Exception in FindAssertion: " + std::string(e.what()));
                    response.result = 0;
                }
                catch (...) {
                    if (OnError) OnError("Unknown exception in FindAssertion");
                    response.result = 0;
                }

                response.success = (response.result != 0) ? 1 : 0;
                if (!response.success) {
                    strcpy_s(response.error_message, "Assertion not found");
                }
                break;
            }

            case ScanRequest::SCAN_FIND_IN_RANGE: {
                if (OnLog) {
                    OnLog("SCAN_FIND_IN_RANGE request - Start: 0x" +
                        std::to_string(request.start_address) +
                        ", End: 0x" + std::to_string(request.end_address));
                }

                std::string pattern;
                if (ParseHexPattern(request.pattern, pattern)) {
                    if (OnLog) OnLog("Using parsed hex pattern");
                }
                else {
                    pattern = std::string(request.pattern, strlen(request.pattern));
                }

                response.result = Scanner::FindInRange(
                    pattern.c_str(),
                    strlen(request.mask) > 0 ? request.mask : nullptr,
                    request.offset,
                    request.start_address,
                    request.end_address
                );

                response.success = (response.result != 0) ? 1 : 0;
                if (!response.success) {
                    strcpy_s(response.error_message, "Pattern not found in range");
                }
                break;
            }

            case ScanRequest::SCAN_TO_FUNCTION_START: {
                if (OnLog) {
                    OnLog("SCAN_TO_FUNCTION_START request - Address: 0x" +
                        std::to_string(request.call_address));
                }

                response.result = Scanner::ToFunctionStart(
                    request.call_address,
                    request.scan_range > 0 ? request.scan_range : 0xff
                );

                response.success = (response.result != 0) ? 1 : 0;
                if (!response.success) {
                    strcpy_s(response.error_message, "Function start not found");
                }
                break;
            }

            case ScanRequest::SCAN_FUNCTION_FROM_NEAR_CALL: {
                if (OnLog) {
                    OnLog("SCAN_FUNCTION_FROM_NEAR_CALL request - Address: 0x" +
                        std::to_string(request.call_address));
                }

                response.result = Scanner::FunctionFromNearCall(
                    request.call_address,
                    request.check_valid_ptr != 0
                );

                response.success = (response.result != 0) ? 1 : 0;
                if (!response.success) {
                    strcpy_s(response.error_message, "Function address not found");
                }
                break;
            }

            case ScanRequest::READ_MEMORY: {
                if (OnLog) {
                    OnLog("READ_MEMORY request - Address: 0x" +
                        std::to_string(request.address) +
                        ", Size: " + std::to_string(request.size));
                }

                if (request.address && request.size > 0 && request.size <= sizeof(response.data)) {
                    // Vérifier si l'adresse est valide
                    if (IsBadReadPtr((void*)request.address, request.size)) {
                        response.success = 0;
                        strcpy_s(response.error_message, "Invalid memory address");
                    }
                    else {
                        memcpy(response.data, (void*)request.address, request.size);
                        response.data_size = request.size;
                        response.success = 1;
                        response.result = request.address;
                    }
                }
                else {
                    response.success = 0;
                    strcpy_s(response.error_message, "Invalid read parameters");
                }
                break;
            }

            case ScanRequest::GET_SECTION_INFO: {
                if (OnLog) {
                    OnLog("GET_SECTION_INFO request - Section: " +
                        std::to_string(request.section));
                }

                Scanner::GetSectionAddressRange(
                    (ScannerSection)request.section,
                    &response.section_start,
                    &response.section_end
                );

                response.success = (response.section_start != 0 && response.section_end != 0) ? 1 : 0;
                response.result = response.section_start;

                if (!response.success) {
                    strcpy_s(response.error_message, "Section not found");
                }

                if (OnLog) {
                    std::stringstream ss;
                    ss << "Section info - Start: 0x" << std::hex << response.section_start;
                    ss << ", End: 0x" << std::hex << response.section_end;
                    OnLog(ss.str());
                }
                break;
            }

            default:
                response.success = 0;
                strcpy_s(response.error_message, "Unknown request type");
                if (OnError) OnError("Unknown request type: " + std::to_string(request.type));
                break;
            }
        }
        catch (const std::exception& e) {
            response.success = 0;
            strcpy_s(response.error_message, e.what());
            if (OnError) OnError("Exception handling request: " + std::string(e.what()));
            LOG_ERROR("Exception in HandleRequest: %s", e.what());
        }
        catch (...) {
            response.success = 0;
            strcpy_s(response.error_message, "Unknown exception");
            if (OnError) OnError("Unknown exception handling request");
            LOG_ERROR("Unknown exception in HandleRequest");
        }
    }

    bool NamedPipeServer::ParseHexPattern(const char* hexStr, std::string& outPattern) {
        // Vérifier si c'est un pattern hexadécimal (format: "8B 0C 90 85 C9 74 19")
        std::string input(hexStr);
        std::stringstream ss(input);
        std::string byteStr;

        outPattern.clear();

        // Tenter de parser comme hex
        while (ss >> byteStr) {
            // Si ce n'est pas un byte hex valide, ce n'est pas un pattern hex
            if (byteStr.length() > 2) {
                return false;
            }

            try {
                unsigned int byte = std::stoul(byteStr, nullptr, 16);
                if (byte > 255) {
                    return false;
                }
                outPattern.push_back((char)byte);
            }
            catch (...) {
                return false;
            }
        }

        // Log du pattern parsé
        if (!outPattern.empty() && OnLog) {
            std::stringstream logMsg;
            logMsg << "Parsed hex pattern: ";
            for (unsigned char c : outPattern) {
                logMsg << "\\x" << std::hex << std::setw(2) << std::setfill('0') << (int)c;
            }
            OnLog(logMsg.str());
        }

        return !outPattern.empty();
    }
}