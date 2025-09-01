#pragma once

#include <Windows.h>
#include <string>
#include <thread>
#include <atomic>
#include <functional>

namespace GW {

#pragma pack(push, 1)  // Forcer l'alignement à 1 byte

    // Structure pour les requêtes du client
    struct ScanRequest {
        enum RequestType {
            SCAN_FIND = 1,
            SCAN_FIND_ASSERTION = 2,
            SCAN_FIND_IN_RANGE = 3,
            SCAN_TO_FUNCTION_START = 4,
            SCAN_FUNCTION_FROM_NEAR_CALL = 5,
            READ_MEMORY = 6,
            GET_SECTION_INFO = 7
        };

        int32_t type;

        // Pour SCAN_FIND
        char pattern[256];
        char mask[256];
        int32_t offset;
        uint8_t section;
        uint8_t padding1[3];  // Padding pour alignement

        // Pour SCAN_FIND_ASSERTION
        char assertion_file[256];
        char assertion_msg[256];
        uint32_t line_number;

        // Pour SCAN_FIND_IN_RANGE
        uint32_t start_address;
        uint32_t end_address;

        // Pour READ_MEMORY
        uintptr_t address;
        uint32_t size;

        // Pour SCAN_TO_FUNCTION_START / SCAN_FUNCTION_FROM_NEAR_CALL
        uintptr_t call_address;
        uint32_t scan_range;
        uint8_t check_valid_ptr;
        uint8_t padding2[3];  // Padding pour alignement
    };

    // Structure pour les réponses au client
    struct ScanResponse {
        uint8_t success;
        uint8_t padding1[3];  // Padding pour alignement
        uintptr_t result;
        char error_message[256];

        // Pour READ_MEMORY
        uint8_t data[1024];
        uint32_t data_size;

        // Pour GET_SECTION_INFO
        uintptr_t section_start;
        uintptr_t section_end;
    };

#pragma pack(pop)  // Restaurer l'alignement par défaut

    class NamedPipeServer {
    private:
        static NamedPipeServer* instance;

        HANDLE hPipe;
        std::thread serverThread;
        std::atomic<bool> running;  // Utiliser atomic pour thread-safety
        std::string pipeName;

        // Méthodes internes
        void ServerLoop();
        void ProcessClient(HANDLE clientPipe);
        void HandleRequest(const ScanRequest& request, ScanResponse& response);

        // Helper pour convertir les patterns hexadécimaux
        bool ParseHexPattern(const char* hexStr, std::string& outPattern);

    public:
        NamedPipeServer();
        ~NamedPipeServer();

        // Singleton
        static NamedPipeServer& GetInstance();
        static void Destroy();

        // Contrôle du serveur
        bool Start(const std::string& pipeName = "\\\\.\\pipe\\GWToolsPipe");
        void Stop();
        bool IsRunning() const { return running.load(); }  // Thread-safe read

        // Callbacks optionnels pour logging
        std::function<void(const std::string&)> OnLog;
        std::function<void(const std::string&)> OnError;
    };
}