#include "./glfw_library.hpp"
#include <GLFW/glfw3.h>
#include <memory>

struct GLFWLibrary_raii {
  ~GLFWLibrary_raii() { glfwTerminate(); }
};

static std::unique_ptr<GLFWLibrary_raii> pContext;

bool GLFW::initialize() {
  if(pContext != nullptr) {
    return true;
  }
  if(!glfwInit()) {
    return false;
  }
  pContext = std::make_unique<GLFWLibrary_raii>();
  return true;
}
bool GLFW::isInitialized() {
  return pContext != nullptr;
}
void GLFW::terminate() {
  pContext.reset(nullptr);
}
