#ifndef WINDOW_H
#define WINDOW_H
#pragma once

#include <GLFW/glfw3.h>
#include <string_view>
#include <string>
#include <optional>
#include <memory>
#include <functional>

namespace ui {

class Window {
  public:
  Window() = delete;
  Window(GLFWwindow* handle);
  Window(const Window&) = delete;
  Window(Window&&) = default;
  Window& operator=(const Window&) = delete;
  Window& operator=(Window&&) = default;
  ~Window() = default;

  static std::optional<Window> create(
      const int width, const int height, const std::string& title);

  GLFWwindow* getHandle();
  void makeCurrent();
  void setTitle(const std::string& title);
  bool shouldClose();

  private:
  using WindowHandlePtr =
      std::unique_ptr<GLFWwindow, std::function<decltype(glfwDestroyWindow)>>;
  WindowHandlePtr m_window;
};
}; // namespace ui

#endif
