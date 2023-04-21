#pragma once

#include "glad/glad.h"
#include <fmt/core.h>
#include <cstdio>

inline int glClearError() {
  while(glGetError()) {
  }
  return 0;
}

// NOLINTNEXTLINE(cppcoreguidelines-macro-usage)
#define GLCall(func) \
  (glClearError(), func); \
  while(auto error = glGetError()) { \
    fmt::print(stderr, "{}:{} [OPENGL {:#x}]\n", __FILE__, __LINE__, error); \
  }
