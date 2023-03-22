#ifndef GL_GLSHADERPROGRAM_H
#define GL_GLSHADERPROGRAM_H

#include <functional>
#include <optional>
#include <vector>
#include <string>
#include <string_view>
#include "render/gl.hpp"
#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>
#include <glm/mat2x2.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <concepts>

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
  template <int N, typename T, typename V = glm::vec<N, T, glm::defaultp>>
  inline void setUniformSafe(const std::string& name, const V& value) noexcept
    requires(1 <= N && N <= 4 && std::is_fundamental_v<T>)
  {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }
    auto valuePtr = glm::value_ptr(value);
    if constexpr(std::is_same_v<T, float>) {
      if constexpr(N == 2) {
        glUniform2fv(kLoc, 2, valuePtr);
      } else if constexpr(N == 3) {
        glUniform3fv(kLoc, 3, valuePtr);
      } else if constexpr(N == 4) {
        glUniform4fv(kLoc, 4, valuePtr);
      }
    } else if constexpr(std::is_same_v<T, int> || std::is_same_v<T, bool>) {
      if constexpr(N == 2) {
        glUniform2iv(kLoc, 2, valuePtr);
      } else if constexpr(N == 3) {
        glUniform3iv(kLoc, 3, valuePtr);
      } else if constexpr(N == 4) {
        glUniform4iv(kLoc, 4, valuePtr);
      }
    }
  }

  /// Template specialization of setUniformSafe for a single float value.
  /// There's no glm::vec1, so that's why.
  template <int N = 1, typename T>
  inline void setUniformSafe(const std::string& name, const T& value) noexcept
    requires(std::is_fundamental_v<T>)
  {
    const GLint kLoc = getUniformLocation(name);

    if(kLoc == -1) {
      return;
    }
    if constexpr(std::is_same_v<T, float>) {
      glUniform1f(kLoc, value);
    } else if constexpr(std::is_same_v<T, int> || std::is_same_v<T, bool>) {
      glUniform1i(kLoc, value);
    }
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
