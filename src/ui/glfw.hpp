#ifndef GLFW_LIBRARY_H
#define GLFW_LIBRARY_H
#pragma once

#define GLFW_INCLUDE_NONE
#include "glad/glad.h"
#include <GLFW/glfw3.h>

/// @class GLFW
/// @brief Represents GLFW library context
class GLFW {
  public:
  ~GLFW();

  /// @brief Initializes GLFW
  /// @return true on sucess, false otherwise
  static bool initialize();

  /// @brief Checks whenever GLFW is initialized
  /// @return true when GLFW is initialized, false otherwise
  static bool isInitialized();

  /// @brief Terminates GLFW on demand
  static void terminate();
};

#endif
