#include "Headers.h"

#include <Psapi.h>

#include <Utilities/Scanner.h>
#include <DbgHelp.h>
#include <Utilities/Debug.h>
#include <Utilities/FileScanner.h>

#pragma comment( lib, "dbghelp.lib" )

namespace {

    std::string ucwords(const char* src) {
        const auto x = strlen(src);
        std::string dest = src;
        for (size_t i = 0; i < x; i++) {
            if (isalpha(dest[i]) && (i == 0 || !isalpha(dest[i-1]))) {
                dest[i] = (char)toupper(dest[i]);
            }
        }
        return dest;
    }
    std::string strtolower(const char* src) {
        const auto x = strlen(src);
        std::string dest = src;
        for (size_t i = 0; i < x; i++) {
            dest[i] = (char)tolower(dest[i]);
        }
        return dest;
    }
    FileScanner fileScanner;

    uintptr_t section_offset_from_disk = 0;
    GW::ScannerSectionOffset mem_sections[GW::ScannerSection::Section_Count] = {};

}
uintptr_t GW::Scanner::FindAssertion(const char* assertion_file, const char* assertion_msg, uint32_t line_number, int offset) {
    const auto found = fileScanner.FindAssertion(assertion_file, assertion_msg, line_number, offset);
    return found ? found - section_offset_from_disk : found;
}
uintptr_t GW::Scanner::FindInRange(const char* pattern, const char* mask, int offset, DWORD start, DWORD end) {
    const auto found = fileScanner.FindInRange(pattern, mask, offset, start + section_offset_from_disk, end + section_offset_from_disk);
    return found ? found - section_offset_from_disk : found;
}
void GW::Scanner::GetSectionAddressRange(ScannerSection section, uintptr_t* start, uintptr_t* end) {
    return fileScanner.GetSectionAddressRange(section, start, end);
}
uintptr_t GW::Scanner::Find(const char* pattern, const char* mask, int offset, ScannerSection section) {
    return FindInRange(pattern, mask, offset, mem_sections[section].start, mem_sections[section].end);
}

bool GW::Scanner::IsValidPtr(uintptr_t address, ScannerSection section) {
    return address && address > mem_sections[section].start && address < mem_sections[section].end;
}

uintptr_t GW::Scanner::FunctionFromNearCall(uintptr_t call_instruction_address, bool check_valid_ptr) {
    if (!IsValidPtr(call_instruction_address, ScannerSection::Section_TEXT))
        return 0;
    uintptr_t function_address = 0;
    switch (((*(uintptr_t*)call_instruction_address) & 0x000000ff)) {
    case 0xe8:   // CALL
    case 0xe9: { // JMP long
        const auto near_address = *(uintptr_t*)(call_instruction_address + 1);
        function_address = (near_address)+(call_instruction_address + 5);
    } break;
    case 0xeb: { // JMP short
        const auto near_address = *(char*)(call_instruction_address + 1);
        function_address = (near_address)+(call_instruction_address + 2);
    } break;
    default:
        return 0; // Not a near call instruction
    }
    if (check_valid_ptr && !IsValidPtr(function_address, ScannerSection::Section_TEXT))
        return 0;
    // Check to see if there are any nested JMP's etc
    if (const auto nested_call = FunctionFromNearCall(function_address, check_valid_ptr)) {
        return nested_call;
    }
    return function_address;
}

uintptr_t GW::Scanner::ToFunctionStart(uintptr_t call_instruction_address, uint32_t scan_range) {
    return call_instruction_address ? FindInRange("\x55\x8b\xec", "xxx", 0, call_instruction_address, call_instruction_address - scan_range) : 0;
}

void GW::Scanner::Initialize(HMODULE hModule) {

    wchar_t filename[255];
    if (!(hModule && GetModuleFileNameW(hModule, filename, _countof(filename))))
        throw 1;
    if (!FileScanner::CreateFromPath(filename, &fileScanner)) {
        throw 1;
    }
    uint32_t dllImageBase = (uint32_t)hModule;
    IMAGE_NT_HEADERS* pNtHdr = ImageNtHeader(hModule);
    IMAGE_SECTION_HEADER* pSectionHdr = (IMAGE_SECTION_HEADER*)(pNtHdr + 1);
    //iterate through the list of all sections, and check the section name in the if conditon. etc
    for (int i = 0; i < pNtHdr->FileHeader.NumberOfSections; i++)
    {
        char* name = (char*)pSectionHdr->Name;
        uint8_t section = 0x8;
        if (memcmp(name, ".text", 5) == 0)
            section = ScannerSection::Section_TEXT;
        else if (memcmp(name, ".rdata", 6) == 0)
            section = ScannerSection::Section_RDATA;
        else if (memcmp(name, ".data", 5) == 0)
            section = ScannerSection::Section_DATA;
        if (section != 0x8) {
            mem_sections[section].start = dllImageBase + pSectionHdr->VirtualAddress;
            mem_sections[section].end = mem_sections[section].start + pSectionHdr->Misc.VirtualSize;
        }
        pSectionHdr++;
    }
    if (!(mem_sections[ScannerSection::Section_TEXT].start && mem_sections[ScannerSection::Section_TEXT].end))
        throw 1;

    section_offset_from_disk = fileScanner.sections[ScannerSection::Section_TEXT].start - mem_sections[ScannerSection::Section_TEXT].start;
}

void GW::Scanner::Initialize(const char* moduleName) {
    return Initialize(GetModuleHandleA(moduleName));
}
