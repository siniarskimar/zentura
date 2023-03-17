#ifndef GL_GLSHADERPROGRAM_H
#define GL_GLSHADERPROGRAM_H

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

/// Represents an OpenGL Program.
class GLShaderProgram {
  public:
  GLShaderProgram();

  /// Construct GLShaderProgram using a given OpenGL object.
  /// @note GLShaderProgram takes ownership over glID argument
  ///
  /// @param glID OpenGL Program Object
  GLShaderProgram(GLuint glID);

  /// \{
  GLShaderProgram(GLShaderProgram&&);
  GLShaderProgram& operator=(GLShaderProgram&&);

  GLShaderProgram(const GLShaderProgram&) = delete;
  GLShaderProgram& operator=(const GLShaderProgram&) = delete;
  /// \}

  ~GLShaderProgram();

  /// Quickly create GLShaderProgram from vertex shader and fragment shader.
  static std::optional<GLShaderProgram> compile(
      const std::string_view vertexSource, const std::string_view fragmentSource);

  /// Activate OpenGL program.
  void use();

  /// Return the underlying OpenGL Object.
  [[nodiscard]] GLuint getGLObjectID() const noexcept;

  /// \{
  /// Get location of an attribute
  [[nodiscard]] GLint getAttribLocation(const std::string& name);

  /// Get location of an attribute.
  /// Doesn't cache new entries.
  [[nodiscard]] GLint getAttribLocation(const std::string& name) const;
  /// \}

  /// \{
  /// Get location of an uniform.
  /// @note Unused GLSL uniform will be siletly removed!
  [[nodiscard]] GLint getUniformLocation(const std::string& name);

  /// Gets location of an uniform.
  /// Doesn't cache new entries.
  [[nodiscard]] GLint getUniformLocation(const std::string& name) const;

  /// \}

  /// Set a value of a shader uniform in a safe manner.
  ///
  /// Firstly it check if a uniform with given name exists and then sets it to the desired
  /// value. This is done in order to prevent errors when GLSL optimizes an uniform away.
  /// \{
  template <int N, typename T = glm::vec<N, float, glm::defaultp>>
  inline void setUniformSafe(const std::string& name, const T& value) noexcept
    requires(1 <= N && N <= 4)
  {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }
    if constexpr(N == 2) {
      glUniform2fv(kLoc, 2, glm::value_ptr(value));
    } else if constexpr(N == 3) {
      glUniform3fv(kLoc, 3, glm::value_ptr(value));
    } else if constexpr(N == 4) {
      glUniform4fv(kLoc, 4, glm::value_ptr(value));
    }
  }

  /// Template specialization of setUniformSafe for a single float value.
  /// There's no glm::vec1, so that's why.
  template <int N = 1>
  inline void setUniformSafe(const std::string& name, const float& value) noexcept {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }
    glUniform1f(kLoc, value);
  }

  /// Set uniform matrix in a safe manner.
  /// Analogous to setUniformSafe but for matricies.
  // TODO: Properly implement this function
  template <int R, int C>
  inline void setUniformMatrixSafe(
      const std::string& name, const glm::mat<C, R, float, glm::defaultp>& value) noexcept
    requires(R <= 4 && C <= 4)
  {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }

    glUniformMatrix2fv(kLoc, 1, false, glm::value_ptr(value));
  }

  /// \}

  private:
  GLuint m_glId;
  std::unordered_map<std::string, GLint> m_locCache;
};

#endif
