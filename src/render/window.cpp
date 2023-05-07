#include "render/glrenderer.hpp"
#include "./window.hpp"
#include <memory>

std::tuple<std::optional<Window>, std::string_view> Window::create(
    const int width, const int height, const std::string& title) {

  // NOTE: In the future window flags should be composed dynamically
  // mainly for the purpose of multiple render backends
  auto* window = SDL_CreateWindow(
      title.c_str(), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height,
      SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL);

  if(window == nullptr) {
    return {std::nullopt, SDL_GetError()};
  }
  return {window, "No error"};
}

Window::Window(SDL_Window* handle) : m_window(handle), m_shouldClose(false) {}

Window::Window(Window&& other)
    : m_window(other.m_window),
      m_shouldClose(other.m_shouldClose) {
  other.m_window = nullptr;
}

Window& Window::operator=(Window&& other) {
  m_window = other.m_window;
  other.m_window = nullptr;
  m_shouldClose = other.m_shouldClose;
  return *this;
}

Window::~Window() {
  SDL_DestroyWindow(m_window);
}

SDL_Window* Window::getHandle() {
  return m_window;
}

void Window::notifyClose() {
  m_shouldClose = true;
}

bool Window::shouldClose() const {
  return m_shouldClose;
}

void Window::setTitle(const std::string& title) {
  SDL_SetWindowTitle(getHandle(), title.c_str());
}
