#ifndef FUNCIONES_HPP
#define FUNCIONES_HPP
#include <string>
#include <iostream>

bool check_args(int argc, char* argv[]);

bool is_directory(const std::string& path);

bool is_same_file(const std::string& src_path, const std::string& dest_path);

std::expected<void, std::system_error> copy_file(const std::string& src_path, const std::string& dest_path, mode_t dst_perms = 0644);


#endif