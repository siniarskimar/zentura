#ifndef RENDER_VERTEX_H
#define RENDER_VERTEX_H

#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>

namespace render {

struct Vertex {
  glm::vec3 position{};
  glm::vec4 color{};
  float texture{};
  glm::vec2 textureOffset{};

  Vertex(glm::vec3 position, glm::vec4 color) : position(position), color(color) {}

  Vertex(glm::vec3 position, glm::vec4 color, float texture, glm::vec2 textureOffset)
      : position(position),
        color(color),
        texture(texture),
        textureOffset(textureOffset) {}
};
}

#endif
