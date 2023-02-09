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

  /// \{
  GLShaderProgram() = delete;

  /// @brief Constructs GLShaderProgram
  ///
  /// @note GLShaderProgram takes ownership over glID argument
  ///
  /// @param glID OpenGL Program Object
  GLShaderProgram(GLuint glID);

  GLShaderProgram(GLShaderProgram&&) = default;
  GLShaderProgram& operator=(GLShaderProgram&&) = default;

  GLShaderProgram(const GLShaderProgram&) = delete;
  GLShaderProgram& operator=(const GLShaderProgram&) = delete;
  /// \}

  ~GLShaderProgram();

  /// @brief Activates OpenGL program
  void use();

  /// @brief Returns the underlying OpenGL Object
  [[nodiscard]] GLuint getGLObjectID() const noexcept;

  /// @brief Gets location of an attribute
  ///
  /// Gets location of an shader attribute. Useful in OpenGL contexts lower than **3.3**.
  ///
  /// @param name attribute name
  /// @return Attribute location
  [[nodiscard]] GLint getAttribLocation(const std::string& name) const;

  /// @brief Gets location of an uniform
  ///
  /// Gets location of an shader uniform.
  /// @note Unused GLSL uniform will be siletly removed!
  ///
  /// @param name Uniform name
  /// @return Uniform location
  [[nodiscard]] GLint getUniformLocation(const std::string& name) const;

  private:
  GLuint m_glId;
};
