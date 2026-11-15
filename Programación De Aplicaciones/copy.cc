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

#include <iostream>

#include "funciones.hpp"

int protected_main(int argc, char* argv[]) {

  if (!check_argcs(argc,argv)) {

    std::cerr << "copy: se deben indicar los archivos ORIGEN y DESTINO." << std::endl;
    return EXIT_FAILURE;
  }

  std::string source{argv[1]};
  std::string destination{argv[2]};

  if (is_directory(destination)) {

    std::filesystem::path source_aux{source};
    std::filesystem::path destination_aux{destination};
    
    destination_aux = destination_aux / source_aux.filename();

    destination = destination_aux.string();
  }

  if (is_same_file(source, destination)) {

    std::cerr << "copy: ORIGEN y DESTINO son el mismo archivo." << std::endl;
    return EXIT_FAILURE;
  }

  auto result = copy_file(source, destination);

  if (!result.has_value()) {

    std::cerr << "copy: " << result.error().what() << std::endl;
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}

int main(int argc, char* argv[]) {

  try {

    return protected_main(argc, argv);
  }

  catch (const std::system_error& e) {

    std::cerr << std::format("copy: error inesperado ({}): {}", e.code().value(), e.what()) << std::endl;
  }

  catch (const std::exception& e) {

    std::cerr << std::format("copy: error inesperado: {}", e.what()) << std::endl;
  }

  return EXIT_FAILURE;
}