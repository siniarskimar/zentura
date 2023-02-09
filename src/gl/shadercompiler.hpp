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

  /// @brief Used in GLShaderCompiler::compile for returning compilation status
  struct CompilationStatus {
    /// @brief indicates whenever compilation succeded
    bool success{};

    /// @brief errorLog returned when error occoured
    std::string infoLog;

    /// @brief Default constructor
    CompilationStatus() = default;

    /// @brief Constructs CompilationStatus with given success state
    /// @param success true or false depending on the result of compilation
    /// @param infoLog ie. error log
    CompilationStatus(bool success, std::string infoLog = "");

    CompilationStatus(const CompilationStatus&) = default;
    CompilationStatus(CompilationStatus&&) = default;

    CompilationStatus& operator=(const CompilationStatus&) = default;
    // CompilationStatus& operator=(CompilationStatus&&) = default;

    ~CompilationStatus() = default;

    /// @brief Implicit boolean conversion
    /// @return @ref success member variable
    operator bool();
  };

  /// @brief Default constructor
  GLShaderCompiler();

  /// @brief Destructor
  ~GLShaderCompiler();

  /// @brief Compiles a given shader source
  ///
  /// @param type Shader type
  /// @param source Shader source
  /// @return CompilationStatus
  CompilationStatus compile(GLenum type, const std::string& source);

  /// @brief Links together previously compiled shaders
  /// @param deleteShaders Whenever to mark compiled shaders for deletion after successful
  /// linkage
  /// @return std::optional with GLShaderProgram on success
  std::optional<GLShaderProgram> link(const bool deleteShaders = true);

  private:
  std::array<GLuint, 3> m_shaders;
};
