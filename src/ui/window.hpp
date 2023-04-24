#ifndef WINDOW_H
#define WINDOW_H
#pragma once

#include <GLFW/glfw3.h>
#include <string_view>
#include <string>
#include <optional>
#include <functional>
#include <SDL2/SDL.h>
#include <utility>

namespace ui {
class Window {
  public:
  /// Takes ownership over window handle
  Window(SDL_Window*);

  /// Window should not be copied.
  Window(const Window&) = delete;
  Window& operator=(const Window&) = delete;

  Window(Window&&);
  Window& operator=(Window&&);

  ~Window();

  /// Create a new window.
  static std::tuple<std::optional<Window>, std::string_view> create(
      const int width, const int height, const std::string& title);

  /// Calls glfwPollEvents
  static void pollEvents();

  /// Change the title of a window.
  void setTitle(const std::string& title);

  void notifyClose();

  [[nodiscard]] bool shouldClose() const;

  SDL_Window* getHandle();

  private:

  SDL_Window* m_window;
  bool m_shouldClose;
};

}; // namespace ui

#endif
