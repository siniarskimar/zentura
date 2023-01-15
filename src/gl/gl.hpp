#pragma once

#include "gl/glad/glad.h"
#include <fmt/core.h>
#include <cstdio>

#define GLCall(func) \
  (func); \
  while(auto error = glGetError()) { \
    fmt::print(stderr, "{}:{} [OPENGL {}]\n", __FILE__, __LINE__, error); \
  }
