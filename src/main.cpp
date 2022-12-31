#include <iostream>
#include <GLFW/glfw3.h>
#include "ui/glfw.hpp"
#include "./ui/Window.hpp"

int main(int argc, const char* argv[]) {

  if(!GLFW::initialize()) {
    std::cerr << "Failed to initialize GLFW library" << std::endl;
    return 2;
  }

  glfwWindowHint(GLFW_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_VERSION_MINOR, 0);
  glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);

  Window& window = Window::createInstance(800, 600, "ZEN");

  window.makeContextCurrent();

  glfwSwapInterval(1);

  while(!window.shouldClose()) {
    glClear(GL_COLOR_BUFFER_BIT);

    glBegin(GL_TRIANGLES);
    glColor3f(1.0f, 0.0f, 0.0f);
    glVertex2f(0.0f, 0.5f);

    glColor3f(0.0f, 1.0f, 0.0f);
    glVertex2f(0.5f, -0.5f);

    glColor3f(0.0f, 0.0f, 1.0f);
    glVertex2f(-0.5f, -0.5f);

    glEnd();

    window.swapBuffers();
    glfwPollEvents();
  }

  return 0;
}
