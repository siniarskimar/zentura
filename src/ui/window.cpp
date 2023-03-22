#include "render/glrenderer.hpp"
#include "./window.hpp"
#include <memory>
#include "stb_image.h"

namespace ui {

std::unique_ptr<Renderer> createRenderer() {
  /// Only OpenGL for now
  return std::make_unique<GLRenderer>();
}

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
  glfwMakeContextCurrent(m_window.get());
  glfwSetWindowUserPointer(m_window.get(), this);
  gladLoadGLLoader(reinterpret_cast<GLADloadproc>(glfwGetProcAddress));
  m_renderer = createRenderer();
}

GLFWwindow* Window::getGLFWHandle() {
  return m_window.get();
}

Renderer& Window::getRenderer() {
  return *m_renderer;
}

void Window::setTitle(const std::string& title) {
  glfwSetWindowTitle(m_window.get(), title.c_str());
}

void Window::runLoop() {
  int tWidth = 0;
  int tHeight = 0;
  int tChannels = 0;
  auto* data = stbi_load("share/zen/test_image.jpg", &tWidth, &tHeight, &tChannels, 0);
  if(data == nullptr) {
    fmt::print("Failed to open 'share/zen/test_image.jpg'\n");
    return;
  }

  std::shared_ptr<Texture> texture = std::make_shared<Texture>(
      tWidth, tHeight, tChannels,
      std::span<const uint8_t>(
          reinterpret_cast<const uint8_t*>(data),
          reinterpret_cast<const uint8_t*>(data) + tWidth * tHeight * tChannels));

  if(texture->getChannelCount() < 4) {
    *texture.get() = texture->expandToRGBA();
  }

  auto& renderer = getRenderer();
  while(!glfwWindowShouldClose(getGLFWHandle())) {
    renderer.clearFramebuffer();
    // renderer.submitQuad({-0.5f, 0.5f, 0.0f}, {0.5f, 0.5f}, {1.0f, 0.0f, 0.0f, 1.0f});
    renderer.submitQuad({-0.5f, 0.5f, 1.0f}, {1.0f, 1.0f}, texture);
    renderer.flush();
    glfwSwapBuffers(getGLFWHandle());
    glfwPollEvents();
  }
}

} // namespace ui
