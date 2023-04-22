/// @file
#ifndef GL_H
#define GL_H

#include "glad/glad.h"
#include <fmt/core.h>
#include <cstdio>

/// Clear OpenGL error queue
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

#endif
