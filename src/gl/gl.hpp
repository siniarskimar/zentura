#pragma once

#include "gl/glad/glad.h"
#include <iostream>

#define GLCall(func) \
  (func); \
  while(auto error = glGetError()) { \
    std::cout << __FILE__ << ":" << __LINE__ << " GLERROR " << error << std::endl; \
  }
