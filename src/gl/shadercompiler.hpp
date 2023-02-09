#pragma once

#include "glad/glad.h"
#include "gl/shader.hpp"
#include <array>

/// @class GLShaderCompiler
/// @brief OpenGL Program compiler helper
///
/// Provides the interface for compilation and linkage of OpenGL Programs
class GLShaderCompiler {
  public:

  /// @brief Default constructor
  GLShaderCompiler() noexcept;

  /// @brief Destructor
  ~GLShaderCompiler() noexcept;

  [[nodiscard]] const std::string& getInfoLog() const noexcept {
    return m_infoLog;
  }

  /// @brief Compiles a given shader source
  ///
  /// @param type Shader type
  /// @param source Shader source
  /// @return bool true if success, false otherwise
  bool compile(GLenum type, const std::string& source);

  /// @brief Links together previously compiled shaders
  /// @param deleteShaders Whenever to mark compiled shaders for deletion after successful
  /// linkage
  /// @return std::optional with GLShaderProgram on success
  std::optional<GLShaderProgram> link(const bool deleteShaders = true);

  private:
  std::array<GLuint, 3> m_shaders;
  std::string m_infoLog;
};
