#pragma once

#include "gl/glad/glad.h"
#include <fmt/core.h>
#include <cstdio>

inline int glClearError() {
  while(glGetError())
    ;
  return 0;
}

#define GLCall(func) \
  (glClearError(), func); \
  while(auto error = glGetError()) { \
    fmt::print(stderr, "{}:{} [OPENGL {}]\n", __FILE__, __LINE__, error); \
  }
