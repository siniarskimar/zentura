#ifndef GLVERTEX_H
#define GLVERTEX_H

#include <glm/glm.hpp>

struct GLVertex {
  glm::vec3 position{};
  glm::vec4 color{};
  uint32_t textureIndex{};
  glm::vec2 textureCoord{};

  // Required for emplace_back
  GLVertex(glm::vec3 position, glm::vec4 color) : position(position), color(color) {}

  GLVertex(
      glm::vec3 position, glm::vec4 color, uint32_t textureIdx, glm::vec2 textureCoord)
      : position(position),
        color(color),
        textureIndex(textureIdx),
        textureCoord(textureCoord) {}
};

#endif
