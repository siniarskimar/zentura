#include "./glfw.hpp"
#include <GLFW/glfw3.h>
#include <memory>

static std::unique_ptr<GLFW> pContext;

GLFW::~GLFW() {
  glfwTerminate();
}

bool GLFW::initialize() {
  if(pContext != nullptr) {
    return true;
  }
  if(!glfwInit()) {
    return false;
  }
  pContext = std::make_unique<GLFW>();
  return true;
}
bool GLFW::isInitialized() {
  return pContext != nullptr;
}
void GLFW::terminate() {
  pContext.reset(nullptr);
}
