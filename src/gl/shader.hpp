#pragma once

#include <functional>
#include <optional>
#include <vector>
#include <string>
#include <string_view>
#include "gl/gl.hpp"
#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>
#include <glm/mat2x2.hpp>
#include <glm/gtc/type_ptr.hpp>

/// @class GLShaderProgram
/// @brief Represents an OpenGL Program
class GLShaderProgram {
  public:

  /// @brief Constructs GLShaderProgram using a given OpenGL object
  ///
  /// @note GLShaderProgram takes ownership over glID argument
  ///
  /// @param glID OpenGL Program Object
  GLShaderProgram(GLuint glID);

  /// \{
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

  /// @brief Sets a value of a shader uniform
  ///
  /// Sets a value of a shader uniform in a safe manner. Firstly it check if a uniform
  /// with given @ref name exists and then sets it to the desired value.
  /// This is done in order to prevent errors when GLSL optimizes an uniform away.
  ///
  /// @param name Uniform name
  /// @param v Uniform value
  /// {
  template <int N, typename T = glm::vec<N, float, glm::defaultp>>
  inline void setUniformSafe(const std::string& name, const T& v) noexcept
    requires(1 <= N && N <= 4)
  {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }
    if constexpr(N == 2) {
      glUniform2fv(kLoc, 2, glm::value_ptr(v));
    } else if constexpr(N == 3) {
      glUniform3fv(kLoc, 3, glm::value_ptr(v));
    } else if constexpr(N == 4) {
      glUniform4fv(kLoc, 4, glm::value_ptr(v));
    }
  }

  template <int N = 1>
  inline void setUniformSafe(const std::string& name, const float& v) noexcept {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }
    glUniform1f(kLoc, v);
  }

  template <int R, int C>
  inline void setUniformMatrixSafe(
      const std::string& name, const glm::mat<C, R, float, glm::defaultp>& v) noexcept
    requires(R <= 4 && C <= 4)
  {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }

    glUniformMatrix2fv(kLoc, 1, false, glm::value_ptr(v));
  }

  /// }

  private:
  GLuint m_glId;
};
