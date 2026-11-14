#include <iostream>
#include "funciones.hpp"
#include <sys/stat.h>

bool check_args(int argc, char* argv[]){
    if( argv[] > 3){
        std::cerr << "Uso: ./copy.cc ORIGEN DESTINO" << std::endl;
    }
}

bool is_directory(const std::string& path){
struct stat info;

    if (stat(path.c_str(), &info) == -1 ){
        return false;
    }

    return S_ISDIR(info.st_mode);
}

bool is_same_file(const std::string& src_path, const std::string& dest_path);