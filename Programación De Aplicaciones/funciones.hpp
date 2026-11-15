#ifndef FUNCIONES_HPP
#define FUNCIONES_HPP

#include <filesystem>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <vector>
#include <system_error>
#include <format>
#include <sys/types.h>
#include <string>
#include <expected>
#include <cerrno>

std::unexpected<std::system_error> system_error_from_errno(const std::string& context);
bool check_argcs(int argc, char* argv[]);
bool is_directory(const std::string& path);
bool is_same_file(const std::string& source_path, const std:: string& destination_path);
std::expected<void, std::system_error> copy_file(const std::string& source_path, const std::string& destination_path, mode_t dst_perms = 0644);

#endif