#ifndef WINDOW_H
#define WINDOW_H
#pragma once

#include <GLFW/glfw3.h>
#include <string_view>
#include <string>
#include <optional>
#include <memory>
#include <functional>
#include "render/renderer.hpp"

namespace ui {
class Window {
  public:
  /// \{
  Window(GLFWwindow* handle);
  Window(Window&&) = default;
  Window& operator=(Window&&) = default;
  /// \}

  /// Window should not be copied.
  /// \{
  Window(const Window&) = delete;
  Window& operator=(const Window&) = delete;
  /// \}
  ~Window() = default;

  /// Create a new window.
  static std::optional<Window> create(
      const int width, const int height, const std::string& title);

  /// Change the title of a window.
  void setTitle(const std::string& title);

  /// Go into main window loop.
  void runLoop();

  /// Get a reference to Renderer instance.
  render::Renderer& getRenderer();

  private:
  GLFWwindow* getGLFWHandle();

  using WindowHandlePtr =
      std::unique_ptr<GLFWwindow, std::function<decltype(glfwDestroyWindow)>>;

  WindowHandlePtr m_window;

  std::unique_ptr<render::Renderer> m_renderer;
};

}; // namespace ui

#endif
