#pragma once

#include <functional>
#include <optional>
#include <vector>
#include <string>
#include <string_view>
#include "gl/gl.hpp"

/// @class GLShaderProgram
/// @brief Represents an OpenGL Program
class GLShaderProgram {
  public:

  GLShaderProgram() = delete;

  /// @brief Constructs GLShaderProgram
  ///
  /// @note GLShaderProgram takes ownership over glID argument
  ///
  /// @param glID OpenGL Program Object
  GLShaderProgram(GLuint glID);

  GLShaderProgram(const GLShaderProgram&) = delete;
  GLShaderProgram(GLShaderProgram&&) = default;

  ~GLShaderProgram();

  GLShaderProgram& operator=(const GLShaderProgram&) = delete;
  GLShaderProgram& operator=(GLShaderProgram&&) = default;

  /// @brief Activates OpenGL program
  void use();

  /// @brief Returns the underlying OpenGL Object
  GLuint getGLObjectID() const noexcept;

  /// @brief Gets location of an attribute
  ///
  /// Gets location of an shader attribute. Useful in OpenGL contexts lower than **3.3**.
  ///
  /// @param name attribute name
  /// @return Attribute location
  GLint getAttribLocation(const std::string& name) const;

  /// @brief Gets location of an uniform
  ///
  /// Gets location of an shader uniform.
  /// @note Unused GLSL uniform will be siletly removed!
  ///
  /// @param name Uniform name
  /// @return Uniform location
  GLint getUniformLocation(const std::string& name) const;

  private:
  GLuint glID_;
};

/// @class GLShaderCompiler
/// @brief OpenGL Program compiler helper
///
/// Provides the interface for compilation and linkage of OpenGL Programs
struct GLShaderCompiler {
  GLuint vertexShader;
  GLuint fragmentShader;
  GLuint geometryShader;

  /// @brief Used in GLShaderCompiler::compile for returning compilation status
  struct CompilationStatus {
    bool success;
    std::string infoLog;

    /// @brief Default constructor
    CompilationStatus() = default;

    /// @brief Constructs CompilationStatus with given success state
    /// @param success true or false depending on the result of compilation
    /// @param infoLog ie. error log
    CompilationStatus(bool success, std::string infoLog = "");

    operator bool();
  };

  /// @brief Default constructor
  GLShaderCompiler();

  /// @brief Compiles a given shader source
  ///
  /// @param type Shader type
  /// @param source Shader source
  /// @return CompilationStatus
  CompilationStatus compile(GLenum type, const std::string& source);

  /// @brief Links together previously compiled shaders
  /// @return std::optional with GLShaderProgram on success
  std::optional<GLShaderProgram> link();
};
