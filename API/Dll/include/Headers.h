#pragma once

#pragma comment(lib, "Shlwapi.lib")
#pragma comment(lib, "ws2_32.lib")

#ifndef PCH_H
#define PCH_H

// Windows headers
#include <Windows.h>
#include <Windowsx.h>
#include <psapi.h>
#include <tlhelp32.h>
#include <tchar.h>
#include <sysinfoapi.h>

// c++ style c headers
#include <ctime>
#include <string>
#include <random>
#include <cstdint>
#include <array>
#include <cstring>
#include <vector>
#include <map>
#include <unordered_map>
#include <functional>
#include <memory>
#include <algorithm>
#include <chrono>
#include <iostream>
#include <iterator>
#include <thread>
#include <queue>
#include <cmath>
#include <mutex>
#include <cstdarg>
#include <cstdio>
#include <assert.h>
#include <sstream>
#include <codecvt>
#include <locale>
#include <cctype>
#include <bitset>
#include <concepts>
#include <deque>
#include <filesystem>
#include <format>
#include <fstream>
#include <initializer_list>
#include <iomanip>
#include <list>
#include <ranges>
#include <regex>
#include <set>
#include <unordered_set>

// windows headers
#include <DbgHelp.h>
#include <shellapi.h>
#include <ShlObj.h>
#include <Shlwapi.h>
#include <strsafe.h>
#include <WinInet.h>
#include <WinSock2.h>
#include <WinUser.h>
#include <WS2tcpip.h>

// STL headers
#include <string_view>

// DirectX headers
#include <d3d9.h>

// ImGui headers
#include "imgui.h"
#include "imgui_impl_win32.h"
#include "imgui_impl_dx9.h"

#include <stdexcept>
#include <future>

#include <nlohmann/json.hpp>

#include <d3d11.h>
#include <DirectXMath.h>

#include <atomic>
#include <condition_variable>


//Add file here





//manually added libs
#include <commdlg.h>

#endif // PCH_H







