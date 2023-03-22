#ifndef LIB_GLFW_H
#define LIB_GLFW_H

#include <memory>
#include <optional>
#include <string>
#include <GLFW/glfw3.h>
#include <exception>
#include <utility>
#include <fmt/core.h>

namespace glfw {

class InitializationError : public std::exception {
  public:
  InitializationError(const char* what) noexcept : m_what(what) {}

  // NOLINTNEXTLINE(modernize-pass-by-value)
  InitializationError(int err, const std::string& what) noexcept : m_what(what) {}

  InitializationError(const InitializationError&) noexcept = default;
  InitializationError(InitializationError&&) noexcept = delete;
  InitializationError& operator=(const InitializationError& other) noexcept = default;
  InitializationError& operator=(InitializationError&&) noexcept = delete;

  ~InitializationError() override = default;

  [[nodiscard]] const char* what() const noexcept override {
    return m_what.c_str();
  }

  private:
  std::string m_what;
};

class GLFWLibrary {
  public:
  GLFWLibrary();
  GLFWLibrary(const GLFWLibrary&) = default;
  GLFWLibrary(GLFWLibrary&&) = default;
  ~GLFWLibrary();

  GLFWLibrary& operator=(const GLFWLibrary&) = default;
  GLFWLibrary& operator=(GLFWLibrary&&) = default;
};

}; // namespace glfw

#endif
