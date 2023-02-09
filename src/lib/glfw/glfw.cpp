#include "./glfw.hpp"
#include <fmt/core.h>
#include <GLFW/glfw3.h>
#include <stdexcept>

namespace glfw {

GLFWLibrary::GLFWLibrary() {
  glfwSetErrorCallback([](const int errorCode, const char* errorMsg) {
    switch(errorCode) {
    case GLFW_NOT_INITIALIZED:
    case GLFW_NO_CURRENT_CONTEXT:
    case GLFW_NO_WINDOW_CONTEXT:
      throw std::logic_error(errorMsg);
    case GLFW_INVALID_VALUE:
    case GLFW_INVALID_ENUM:
      throw std::invalid_argument(errorMsg);
    case GLFW_OUT_OF_MEMORY:
      throw std::bad_alloc();
    case GLFW_API_UNAVAILABLE:
      fmt::print(stderr, "ERROR: GLFW_API_UNAVAILABLE\n");
      break;
    case GLFW_VERSION_UNAVAILABLE:
      fmt::print(stderr, "ERROR: GLFW_VERSION_UNAVAILABLE\n");
      break;
    case GLFW_PLATFORM_ERROR:
      fmt::print(stderr, "ERROR: GLFW_PLATFORM_ERROR\n");
      break;
    case GLFW_FORMAT_UNAVAILABLE:
      fmt::print(stderr, "ERROR: GLFW_FORMAT_UNAVAILABLE\n");
      break;
    default:
      fmt::print(stderr, "Unknown GLFW error met and std::terminate() called\n");
      std::terminate();
    }
  });

  if(!glfwInit()) {
    const char* desc = nullptr;
    glfwGetError(&desc);
    throw InitializationError(desc ? desc : "Failed to initialize GLFW");
  }
}

GLFWLibrary::~GLFWLibrary() {
  glfwTerminate();
}

} // namespace glfw
