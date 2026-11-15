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

#include "funciones.hpp"

/**
  * @brief Función que obtiene el error del sistema mediante errno.
  * 
  * @param context Contexto del error del sistema.
  * 
  * @return Error del sistema.
  */

std::unexpected<std::system_error> system_error_from_errno(const std::string& context) {

  return std::unexpected(std::system_error(errno, std::system_category(), std::move(context)));
}

/**
  * @brief Función que comprueba si el número de argumento es correcto.
  * 
  * @param argc Número de argumentos.
  * @param argv Argumentos. 
  * 
  * @return True si es correcto, false si no.
  */

bool check_argcs(int argc, char* argv[]) {

  if (argc != 3) {

    return false;
  }

  return true;
}

/**
  * @brief Función que comprueba si una ruta es un directorio o no.
  * 
  * @param path Ruta a comprobar.
  * 
  * @return True si es directorio, false si no.
  */

bool is_directory(const std::string& path) {

  struct stat st;

  if (stat(path.c_str(), &st) == -1) {

    return false;

  } else {

    if (!S_ISDIR(st.st_mode)) {

      return false;
    }
  }

  return true;
}

/**
  * @brief Función que comprueba si dos rutas son el mismo fichero.
  * 
  * @param source_path Ruta 1.
  * @param destination_path Ruta 2.
  * 
  * @return True si son el mismo fichero, false si no.
  */

bool is_same_file(const std::string& source_path, const std:: string& destination_path) {

  struct stat st_source;
  struct stat st_destination;

  if (stat(source_path.c_str(), &st_source) == -1 || stat(destination_path.c_str(), &st_destination) == -1) {

    return false;

  } else {

    if ((st_source.st_dev == st_destination.st_dev) && (st_source.st_ino == st_destination.st_ino)) {

      return true;
    }
  }

  return false;
}

/**
  * @brief Función que copia un fichero en otro fichero.
  * 
  * @param source_path Ruta del fichero a copiar.
  * @param destination_path Ruta del fichero en donde dejar la copia.
  * @param dst_perms Permisos que tendrá el fichero donde se dejará la copia
  * 
  * @return void si no hubo ningún error, system_error si algo salio mal.
  */

std::expected<void, std::system_error> copy_file(const std::string& source_path, const std::string& destination_path, mode_t dst_perms) {

  int source_descriptor = open(source_path.c_str(), O_RDONLY);

  if (source_descriptor == -1) {

    return system_error_from_errno(std::format("Error al abrir el fichero '{}'", source_path));
  }

  int destination_descriptor = open(destination_path.c_str(), O_WRONLY | O_TRUNC | O_CREAT, dst_perms);

  if (destination_descriptor == -1) {

    auto aux = system_error_from_errno(std::format("Error al abrir el fichero '{}'", destination_path));

    close (source_descriptor);

    return aux;
  }

  std::vector<uint8_t> buffer;

  size_t bytes_needed_read{131072};
  size_t total_bytes_read{};
  ssize_t bytes_read{};

  size_t bytes_needed_write{};
  size_t total_bytes_written{};
  ssize_t bytes_written{};

  while (true) {

    while (total_bytes_read < bytes_needed_read) {

      buffer.resize(bytes_needed_read);
    
      bytes_read = read(source_descriptor,buffer.data() + total_bytes_read,bytes_needed_read - total_bytes_read);

      if (bytes_read == -1) {

        auto aux = system_error_from_errno(std::format("Error al leer en el fichero '{}'", source_path));

        close (source_descriptor);
        close (destination_descriptor);

        return aux;
      } else if (bytes_read == 0) {

        break; // Fin del fichero
      }

      total_bytes_read += static_cast<size_t>(bytes_read);
    }

    buffer.resize(total_bytes_read);
    bytes_needed_write = total_bytes_read;

    while (total_bytes_written < bytes_needed_write) {

      bytes_written = write(destination_descriptor,buffer.data() + total_bytes_written,bytes_needed_write - total_bytes_written);

      if (bytes_written == -1) {

        auto aux = system_error_from_errno(std::format("Error al escribir en el fichero '{}'", destination_path));

        close (source_descriptor);
        close (destination_descriptor);

        return aux;
      }

      if (bytes_written == 0) {

        break;
      }

      total_bytes_written += static_cast<size_t>(bytes_written);
    }

    if (bytes_read == 0) {

      break; // Fin del archivo
    }

    bytes_needed_write = 0;
    total_bytes_written = 0;
    bytes_written = 0;

    bytes_read = 0;
    total_bytes_read = 0;
    buffer.clear();
  }

  close(source_descriptor);
  close(destination_descriptor);

  return {};
}