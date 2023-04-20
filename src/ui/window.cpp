#include "render/glrenderer.hpp"
#include "./window.hpp"
#include <memory>
#include "stb_image.h"

namespace ui {

std::optional<Window> Window::create(
    const int width, const int height, const std::string& title) {

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);

  auto window = glfwCreateWindow(width, height, title.c_str(), nullptr, nullptr);

  if(window == nullptr) {
    return std::nullopt;
  }
  return {window};
}

Window::Window(GLFWwindow* handle)
    : m_window(WindowHandlePtr(handle, glfwDestroyWindow)) {
  glfwSetWindowUserPointer(m_window.get(), this);
}

GLFWwindow* Window::getGLFWHandle() {
  return m_window.get();
}

void Window::makeContextCurrent() {
  glfwMakeContextCurrent(getGLFWHandle());
}

bool Window::shouldClose() {
  return glfwWindowShouldClose(getGLFWHandle());
}

void Window::setTitle(const std::string& title) {
  glfwSetWindowTitle(m_window.get(), title.c_str());
}

void Window::pollEvents() {
  glfwPollEvents();
}
} // namespace ui
