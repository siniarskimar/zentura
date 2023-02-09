#ifndef LIB_GLFW_H
#define LIB_GLFW_H

#include <memory>
#include <optional>
#include <string>
#include <GLFW/glfw3.h>

namespace glfw {

class Window {
  public:
  Window(GLFWwindow* window);
  Window(const Window&) = delete;
  Window(Window&&) = default;
  ~Window();

  Window& operator=(const Window&) = delete;
  Window& operator=(Window&&) = default;

  void loadGL();

  void setTitle(const std::string&);

  bool shouldClose() noexcept;

  private:
  GLFWwindow* m_window;
};

class GLFWLibrary {
  public:
  GLFWLibrary() = default;
  GLFWLibrary(const GLFWLibrary&) = default;
  GLFWLibrary(GLFWLibrary&&) = default;
  ~GLFWLibrary();

  GLFWLibrary& operator=(const GLFWLibrary&) = default;
  GLFWLibrary& operator=(GLFWLibrary&&) = default;

  const char* getVersionString() noexcept;
  std::optional<Window> createWindow() noexcept;
};

std::optional<GLFWLibrary> initialize() noexcept;
void terminate() noexcept;
}; // namespace glfw

#endif
