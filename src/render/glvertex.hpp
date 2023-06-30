#ifndef GLVERTEX_H
#define GLVERTEX_H

#include <glm/glm.hpp>

struct GLVertex {
  glm::vec3 position{};
  glm::vec4 color{};
  glm::vec2 textureCoord{};

  GLVertex() = default;

  // NOTE(2023.06.30): Clang does not support CTAD for templated types and explicit
  // constructor is required (https://github.com/llvm/llvm-project/issues/54049)
  GLVertex(glm::vec3 position, glm::vec4 color, glm::vec2 textureCoord = {0.0f, 0.0f})
      : position(position),
        color(color),
        textureCoord(textureCoord) {}
};

#endif
