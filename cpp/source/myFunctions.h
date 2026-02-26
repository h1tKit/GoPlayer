#pragma once

#include <string>
#include <windows.h>

// UTF-8转Windows宽字符（解决TagLib中文路径）
inline std::wstring utf8ToWide(const std::string& utf8) {
    int len = MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), -1, nullptr, 0);
    std::wstring wide(len, 0);
    MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), -1, &wide[0], len);
    return wide;
}
