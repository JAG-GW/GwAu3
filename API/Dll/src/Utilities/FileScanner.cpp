#include <Utilities/FileScanner.h>

#include <stdio.h>
#include <string>
namespace {

    typedef struct _PE_FILE_HEADER {
        DWORD             Signature;
        IMAGE_FILE_HEADER FileHeader;
    } PE_FILE_HEADER, * PPE_FILE_HEADER;

    bool return_free(bool res, LPVOID FileContent)
    {
        UnmapViewOfFile(FileContent);
        return res;
    }

    static std::string strtolower(const char* src)
    {
        const auto x = strlen(src);
        std::string dest = src;
        for (size_t i = 0; i < x; i++) {
            dest[i] = (char)tolower(dest[i]);
        }
        return dest;
    }

    static std::string ucwords(const char* src)
    {
        const auto x = strlen(src);
        std::string dest = src;
        for (size_t i = 0; i < x; i++) {
            if (isalpha(dest[i]) && (i == 0 || !isalpha(dest[i - 1]))) {
                dest[i] = (char)toupper(dest[i]);
            }
        }
        return dest;
    }
}

bool FileScanner::CreateFromPath(const wchar_t *path, FileScanner *result)
{
    HANDLE hFile = CreateFileW(
        path,
        GENERIC_READ,
        FILE_SHARE_READ,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    if (hFile == INVALID_HANDLE_VALUE) {
        fprintf(stderr, "CreateFileW failed, err: %lu\n", GetLastError());
        return false;
    }

    HANDLE hFileMapping = CreateFileMappingW(
        hFile,
        NULL,
        SEC_IMAGE_NO_EXECUTE | PAGE_READONLY,
        0,
        0,
        NULL);

    if (hFileMapping == NULL) {
        fprintf(stderr, "CreateFileMappingW failed, err: %lu\n", GetLastError());
        CloseHandle(hFile);
        return false;
    }

    LPVOID FileContent = MapViewOfFile(hFileMapping, FILE_MAP_READ, 0, 0, 0);

    CloseHandle(hFileMapping);
    CloseHandle(hFile);

    if (FileContent == NULL) {
        fprintf(stderr, "MapViewOfFile failed, err: %lu\n", GetLastError());
        return return_free(false, FileContent);
    }

    MEMORY_BASIC_INFORMATION BasicInfo;
    if (VirtualQuery(FileContent, &BasicInfo, sizeof(BasicInfo)) != sizeof(BasicInfo)) {
        fprintf(stderr, "VirtualQuery failed: %lu\n", GetLastError());
        return return_free(false, FileContent);
    }

    size_t FileSize = BasicInfo.RegionSize;
    const uint8_t *FileBytes = (const uint8_t *) FileContent;
    //fprintf(stderr, "FileBytes: %p, FileSize: %zX\n", FileBytes, FileSize);
    //MessageBoxA(0, "hey", "hey", 0);

    IMAGE_DOS_HEADER DosHeader;
    if (FileSize < sizeof(DosHeader)) {
        fprintf(stderr, "Not enough bytes for the `IMAGE_DOS_HEADER`\n");
        return return_free(false, FileContent);
    }

    memcpy(&DosHeader, FileContent, sizeof(DosHeader));
    if ((DosHeader.e_magic != IMAGE_DOS_SIGNATURE) || (FileSize < (size_t)DosHeader.e_lfanew)) {
        fprintf(stderr, "Invalid `IMAGE_DOS_HEADER`\n");
        return return_free(false, FileContent);
    }

    if (FileSize < (DosHeader.e_lfanew + sizeof(PE_FILE_HEADER))) {
        fprintf(stderr, "Not enough bytes for the `PE_FILE_HEADER`\n");
        return return_free(false, FileContent);
    }

    PE_FILE_HEADER PeHeader;
    memcpy(&PeHeader, FileBytes + DosHeader.e_lfanew, sizeof(PeHeader));

    if (PeHeader.Signature != IMAGE_NT_SIGNATURE) {
        fprintf(stderr, "Not a PE file, invalid signature\n");
        return return_free(false, FileContent);
    }

    if (PeHeader.FileHeader.Machine != IMAGE_FILE_MACHINE_I386) {
        fprintf(stderr, "Not a 32 bits executable\n");
        return return_free(false, FileContent);
    }

    IMAGE_OPTIONAL_HEADER32 OptHeader;
    if (PeHeader.FileHeader.SizeOfOptionalHeader < sizeof(OptHeader)) {
        fprintf(stderr, "Expected %zu bytes for the optional header, found %u\n", sizeof(OptHeader), PeHeader.FileHeader.SizeOfOptionalHeader);
        return return_free(false, FileContent);
    }

    size_t OptHeaderOffset = (size_t)DosHeader.e_lfanew + sizeof(PeHeader);
    if (FileSize < (OptHeaderOffset + sizeof(OptHeader))) {
        fprintf(stderr, "Not enough bytes for the optional header\n");
        return return_free(false, FileContent);
    }

    memcpy(&OptHeader, FileBytes + OptHeaderOffset, sizeof(OptHeader));

    // `SizeOfOptionalHeader` is untrusted, make sure not to overflow by adding it to a value.
    if ((FileSize - OptHeaderOffset) < PeHeader.FileHeader.SizeOfOptionalHeader) {
        fprintf(stderr, "Not enough bytes for the section header(s)\n");
        return return_free(false, FileContent);
    }

    // This can't overflow for a `uint32_t`, because `NumberOfSections` is a uint16_t,
    // so the max value is (0xFFFF * 40) = 0x27FFD8.
    uint32_t SectionsSize = (uint32_t)PeHeader.FileHeader.NumberOfSections * sizeof(IMAGE_SECTION_HEADER);

    // `SectionsSize` is untrusted, make sure not to overflow by adding it to a value.
    if ((FileSize - PeHeader.FileHeader.SizeOfOptionalHeader) < SectionsSize) {
        fprintf(stderr, "Not enough bytes for the section header(s)\n");
        return return_free(false, FileContent);
    }

    PIMAGE_SECTION_HEADER Sections = IMAGE_FIRST_SECTION((PIMAGE_NT_HEADERS32)(FileBytes + DosHeader.e_lfanew));
    WORD SectionIdx;
    for (SectionIdx = 0; SectionIdx < PeHeader.FileHeader.NumberOfSections; ++SectionIdx) {
        PIMAGE_SECTION_HEADER Section = &Sections[SectionIdx];
        if ((FileSize < Sections->VirtualAddress) || ((FileSize - Sections->VirtualAddress) < Sections->Misc.VirtualSize)) {
            fprintf(stderr, "Not enough bytes for the section '%.8s'\n", Section->Name);
            return return_free(false, FileContent);
        }
    }

    // This is a hack, should use something else, but enough for the demo
    FileScanner tmp = FileScanner(FileContent, OptHeader.ImageBase, Sections, PeHeader.FileHeader.NumberOfSections);
    *result = tmp;
    tmp.FileMapping = nullptr;
    return true;
}

FileScanner::FileScanner()
    : FileScanner(nullptr, 0,nullptr, 0)
{
}

FileScanner::FileScanner(const void *FileMapping, uintptr_t ImageBase, PIMAGE_SECTION_HEADER Sections, size_t Count)
    : FileMapping(FileMapping)
    , ImageBase(ImageBase)
{
    for (size_t idx = 0; idx < Count; ++idx) {
        PIMAGE_SECTION_HEADER pSectionHdr = &Sections[idx];
        GW::ScannerSection section = GW::ScannerSection::Section_Count;
        if (memcmp(pSectionHdr->Name, ".text", sizeof(".text")) == 0) {
            section = GW::ScannerSection::Section_TEXT;
        } else if (memcmp(pSectionHdr->Name, ".rdata", sizeof(".rdata")) == 0) {
            section = GW::ScannerSection::Section_RDATA;
        } else if (memcmp(pSectionHdr->Name, ".data", sizeof(".data")) == 0) {
            section = GW::ScannerSection::Section_DATA;
        }

        if (section != GW::ScannerSection::Section_Count) {
            sections[section].start = (uintptr_t)FileMapping + pSectionHdr->VirtualAddress;
            sections[section].end = sections[section].start + pSectionHdr->Misc.VirtualSize;
        }
    }
}

FileScanner::~FileScanner()
{
    if (FileMapping != NULL) {
        UnmapViewOfFile(FileMapping);
    }
}

void FileScanner::GetSectionAddressRange(GW::ScannerSection section, uintptr_t* start, uintptr_t* end) {
    if (start)
        *start = sections[section].start;
    if (end)
        *end = sections[section].end;
}

uintptr_t FileScanner::FindAssertion(const char* assertion_file, const char* assertion_msg, uint32_t line_number, int offset)
{
    #pragma warning( push )
    #pragma warning( disable : 4838 )
    #pragma warning( disable : 4242 )
    #pragma warning( disable : 4244 )
    #pragma warning( disable : 4365 )
    int i;
    char assertion_bytes[] = "\x68????\xBA????\xB9????";
    char assertion_mask[] = "xxxxxxxxxxxxxxx";

    char* assertion_bytes_ptr = &assertion_bytes[5];
    char* assertion_mask_ptr = &assertion_mask[5];

    
    if (line_number) {
        if ((line_number & 0xff) == line_number) {
            // PUSH uint8
            assertion_bytes_ptr = &assertion_bytes[3];
            assertion_mask_ptr = &assertion_mask[3];
            assertion_bytes[3] = 0x6a;
            assertion_bytes[4] = line_number;
        }
        else {
            // PUSH uint32
            assertion_bytes_ptr = &assertion_bytes[0];
            assertion_mask_ptr = &assertion_mask[0];
            assertion_bytes[0] = 0x68;
            assertion_bytes[1] = line_number;
            assertion_bytes[2] = line_number >> 8;
            assertion_bytes[3] = line_number >> 16;
            assertion_bytes[4] = line_number >> 24;
        }
    }
    offset += &assertion_mask[5] - assertion_mask_ptr; // Legacy code meant that offsets are calculated from the \xBA instruction
    
    char assertion_message_mask[128];
    for (i = 0; assertion_msg[i]; i++) {
        assertion_message_mask[i] = 'x';
    }
    assertion_message_mask[i++] = 'x';
    assertion_message_mask[i] = 0;

    char assertion_file_mask[128];
    for (i = 0; assertion_file[i]; i++) {
        assertion_file_mask[i] = 'x';
    }
    assertion_file_mask[i++] = 'x';
    assertion_file_mask[i] = 0;
    
    uintptr_t start = 0;
    uintptr_t end = 0;

    FileScanner::GetSectionAddressRange(GW::ScannerSection::Section_RDATA, &start, &end);

    uint32_t assertion_message_offset = start;
    uintptr_t found = 0;
    for (;;) {
        found = FindInRange(assertion_msg, assertion_message_mask, 0, assertion_message_offset, end);
        if (!found)
            break;

        assertion_message_offset = found + 1;

        // This part is a bit weird, but basically `SEC_IMAGE_NO_EXECUTE` is supposed to map the
        // image as it's done by LoadLibrary, but the ImageBase isn't updated to the actual loading
        // address. So, all the relocation are base on `ImageBase` in the PE header, instead of
        // the actual address. We fix that to create the correct encoding.
        uintptr_t found_enc = (found - (uintptr_t)FileMapping) + ImageBase;
        assertion_bytes[11] = found_enc;
        assertion_bytes[12] = found_enc >> 8;
        assertion_bytes[13] = found_enc >> 16;
        assertion_bytes[14] = found_enc >> 24;

        uint32_t assertion_file_offset = start;
        for (;;) {
            found = FindInRange(assertion_file, assertion_file_mask, 0, assertion_file_offset, end);
            if (!found) {
                // try lower case file name
                found = FindInRange(strtolower(assertion_file).c_str(), assertion_file_mask, 0, assertion_file_offset, end);
            }
            if (!found) {
                // try camel case file name
                found = FindInRange(ucwords(assertion_file).c_str(), assertion_file_mask, 0, assertion_file_offset, end);
            }
            if (!found)
                break;

            assertion_file_offset = found + 1;

            // Find disk path colon minus one for find the start of the assertion string e.g. p:/
            if (((char*)found)[1] != ':') {
                found = FindInRange(":", "x", -0x1, found, found - 128);
                if (!found)
                    break;
            }

            found_enc = (found - (uintptr_t)FileMapping) + ImageBase;
            assertion_bytes[6] = found_enc;
            assertion_bytes[7] = found_enc >> 8;
            assertion_bytes[8] = found_enc >> 16;
            assertion_bytes[9] = found_enc >> 24;

            found = Find(assertion_bytes_ptr, assertion_mask_ptr, offset);
            if (found) {
                return found;
            }
        }
    }
    return 0;
    #pragma warning(pop)
}

uintptr_t FileScanner::FindInRange(const char* pattern, const char* mask, int offset, uint32_t start, uint32_t end)
{
    char first = pattern[0];
    size_t patternLength = strlen(mask ? mask : pattern);
    bool found = false;
    end -= patternLength;

    if (start > end) {
        // Scan backward
        for (uintptr_t i = start; i >= end; i--) {
            if (*(char*)i != first)
                continue;
            found = true;
            //For each byte in the pattern
            for (size_t idx = 0; idx < patternLength; idx++) {
                if ((!mask || mask[idx] == 'x') && pattern[idx] != *(char*)(i + idx)) {
                    found = false;
                    break;
                }
            }
            if (found)
                return i + offset;
        }
    }
    else {
        // Scan forward
        for (uintptr_t i = start; i < end; i++) {
            if (*(char*)i != first)
                continue;
            found = true;
            //For each byte in the pattern
            for (size_t idx = 0; idx < patternLength; idx++) {
                if ((!mask || mask[idx] == 'x') && pattern[idx] != *(char*)(i + idx)) {
                    found = false;
                    break;
                }
            }
            if (found)
                return i + offset;
        }
    }
    return NULL;
} 

uintptr_t FileScanner::Find(const char* pattern, const char* mask, int offset, GW::ScannerSection section)
{
    return FindInRange(pattern, mask, offset, sections[section].start, sections[section].end);
}
