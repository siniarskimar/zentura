#include "./glfw.hpp"
#include <fmt/core.h>
#include <GLFW/glfw3.h>
#include <stdexcept>

GLFWLibrary::GLFWLibrary() {
  glfwSetErrorCallback([](const int errorCode, const char* errorMsg) {
    // "[...] if no error occoured since the last call, the description is set to NULL."
    if(errorMsg == nullptr) {
      return;
    }

    fmt::print(stderr, "GLFW ERROR: {}", errorMsg);

    switch(errorCode) {
      // Fatal errors
    case GLFW_NOT_INITIALIZED:
    case GLFW_NO_CURRENT_CONTEXT:
    case GLFW_NO_WINDOW_CONTEXT:
      throw std::logic_error(errorMsg);
    case GLFW_INVALID_VALUE:
    case GLFW_INVALID_ENUM:
      throw std::invalid_argument(errorMsg);
    case GLFW_OUT_OF_MEMORY:
      throw std::bad_alloc();
    // "A bug or configuration error in GLFW, the underlying operating system or its
    // drivers, or a lack of required resources."
    case GLFW_PLATFORM_ERROR:
      throw std::runtime_error("ERROR: GLFW_PLATFORM_ERROR\n");

      // Possibly runtime errors
      // These can be handled safely
    case GLFW_API_UNAVAILABLE:
      fmt::print(stderr, "ERROR: GLFW_API_UNAVAILABLE\n");
      break;
    case GLFW_VERSION_UNAVAILABLE:
      fmt::print(stderr, "ERROR: GLFW_VERSION_UNAVAILABLE\n");
      break;
    case GLFW_FORMAT_UNAVAILABLE:
      fmt::print(stderr, "ERROR: GLFW_FORMAT_UNAVAILABLE\n");
      break;
    [[unlikely]] default:
      // This should in theory be unreachable
      throw std::runtime_error("Unknown GLFW error met");
    }
  });

  if(glfwInit() == 0) {
    const char* desc = nullptr;
    glfwGetError(&desc);
    throw GLFWInitError(desc != nullptr ? desc : "Failed to initialize GLFW");
  }
}

GLFWLibrary::~GLFWLibrary() {
  glfwTerminate();
}
