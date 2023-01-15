#ifndef WINDOW_H
#define WINDOW_H
#pragma once

#include <GLFW/glfw3.h>
#include <string_view>

/// @brief Abstraction over GLFW window
/// @class Window
///
/// @note This class is a singleton. It cannot be copied
class Window {
  private:

  /// @brief Window instance constructor
  /// @param width
  /// @param height
  /// @param title
  Window(const int width, const int height, const std::string_view title);

  public:

  /// @brief Creates a window
  /// @param width Pixel width
  /// @param height Pixel height
  /// @param title Window title
  /// @return Window instance
  /// @exception std::runtime_exception on failure
  static Window& createInstance(
      const int width, const int height, const std::string_view title);

  /// @brief Returns a reference to Window instance
  /// @return Window instance
  /// @exception std::runtime_exception on failure
  static Window& getInstance();

  /// @brief Destroys a Window instance on demand
  static void destroyInstance();

  //! \{
  Window(const Window&) = delete;
  Window& operator=(const Window&) = delete;
  //! \}

  /// @brief Deconstructor
  virtual ~Window();

  /// @brief Activates OpenGL context
  void makeContextCurrent();

  /// @brief Indicates a Window close event
  /// @return true when Window has been closed by the user
  bool shouldClose();

  /// @brief Present recetly rendered backbuffer
  void swapBuffers();

  private:
  GLFWwindow* m_glfwWindow;
};

#endif
