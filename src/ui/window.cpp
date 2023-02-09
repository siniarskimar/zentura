#include "Window.hpp"
#include <string>
#include <exception>
#include <stdexcept>
#include <GLFW/glfw3.h>
#include <memory>
#include <iostream>

static std::unique_ptr<Window> pWindow;

Window::Window(const int width, const int height, const std::string_view title) {
  const std::string kTmpTitle(title.begin(), title.end());

  GLFWwindow* window =
      glfwCreateWindow(width, height, kTmpTitle.data(), nullptr, nullptr);
  if(window == nullptr) {
    throw std::runtime_error("Failed to create GLFW window");
  }

  m_glfwWindow = window;
}

Window::~Window() {
  glfwDestroyWindow(m_glfwWindow);
}

Window& Window::createInstance(
    const int width, const int height, const std::string_view title) {
  pWindow = std::unique_ptr<Window>(new Window(width, height, title));
  return *pWindow;
}

Window& Window::getInstance() {
  if(pWindow == nullptr) {
    throw std::runtime_error("Window::getInstance() called but no window created!");
  }
  return *pWindow;
}

void Window::destroyInstance() {
  pWindow.reset(nullptr);
}

void Window::makeContextCurrent() {
  glfwMakeContextCurrent(m_glfwWindow);
}

void Window::swapBuffers() {
  glfwSwapBuffers(m_glfwWindow);
}
bool Window::shouldClose() {
  return glfwWindowShouldClose(m_glfwWindow);
}
