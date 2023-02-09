#include "./window.hpp"
#include <GLFW/glfw3.h>

namespace ui {

std::optional<Window> Window::create(
    const int width, const int height, const std::string& title) {
  auto window = glfwCreateWindow(width, height, title.c_str(), nullptr, nullptr);

  if(window == nullptr) {
    return std::nullopt;
  }
  return {window};
}

Window::Window(GLFWwindow* handle)
    : m_window(WindowHandlePtr(handle, glfwDestroyWindow)) {}

void Window::makeCurrent() {
  glfwMakeContextCurrent(m_window.get());
}

GLFWwindow* Window::getHandle() {
  return m_window.get();
}

void Window::setTitle(const std::string& title) {
  glfwSetWindowTitle(m_window.get(), title.c_str());
}

bool Window::shouldClose() {
  return glfwWindowShouldClose(m_window.get());
}

} // namespace ui
