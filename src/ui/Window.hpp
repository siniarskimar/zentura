#ifndef WINDOW_H
#define WINDOW_H
#pragma once

#include <GLFW/glfw3.h>
#include <string_view>

class Window {
private:
  Window(const int width, const int height, const std::string_view title);

public:
  static Window& createInstance(
      const int width, const int height, const std::string_view title);
  static Window& getInstance();
  static void destroyInstance();

  Window(const Window&) = delete;
  Window& operator=(const Window&) = delete;

  virtual ~Window();

  void makeContextCurrent();
  bool shouldClose();
  void swapBuffers();

private:
  GLFWwindow* m_glfwWindow;
};

#endif
