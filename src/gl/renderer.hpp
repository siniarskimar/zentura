#ifndef GL_RENDERER_H
#define GL_RENDERER_H

#include "gl/gl.hpp"
#include <vector>
#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>
#include <glm/ext/matrix_clip_space.hpp>
#include "gl/vao.hpp"
#include "gl/shader.hpp"
#include "render/texture.hpp"

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

class GLRenderer {
  public:
  GLRenderer() noexcept;

  void submitQuad(const glm::vec3 position, const glm::vec2 size, const glm::vec4 color);
  void submitQuad(const glm::vec3 position, const glm::vec2 size, Texture texture);

  void renderFrame(GLShaderProgram& program);

  private:
  std::vector<Vertex> m_dataBuffer;
  std::vector<uint32_t> m_indexBuffer;
  GLVertexArray m_vao;
};

} // namespace render
#endif
