#ifndef LIB_GLFW_H
#define LIB_GLFW_H

#include <memory>
#include <optional>
#include <string>
#include <GLFW/glfw3.h>
#include <exception>
#include <utility>
#include <fmt/core.h>

class GLFWInitError : public std::exception {
  public:
  GLFWInitError(const char* what) noexcept : m_what(what) {}

  GLFWInitError(const GLFWInitError&) noexcept = default;
  GLFWInitError(GLFWInitError&&) noexcept = delete;
  GLFWInitError& operator=(const GLFWInitError& other) noexcept = default;
  GLFWInitError& operator=(GLFWInitError&&) noexcept = delete;

  ~GLFWInitError() override = default;

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

#endif
