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
#include "render/renderer.hpp"
#include "render/vertex.hpp"

namespace render {

class GLRenderer : public Renderer {
  public:
  GLRenderer();

  /// @brief Submit a quad for rendering
  void submitQuad(
      const glm::vec3 position, const glm::vec2 size, const glm::vec4 color) override;

  /// @brief Submit a texture quad for rendering
  void submitQuad(
      const glm::vec3 position, const glm::vec2 size,
      std::shared_ptr<Texture> texture) override;

  /// @brief Render to a Texture
  void renderFrame(GLShaderProgram& program, Texture& texture);

  /// @brief Render to default framebuffer
  void renderFrame(GLShaderProgram& program);

  /// @brief Render current batch to default framebuffer
  void flush() override;

  void clearFramebuffer() override;

  private:
  std::vector<Vertex> m_dataBuffer;
  std::vector<uint32_t> m_indexBuffer;
  GLVertexArray m_vao;
  GLShaderProgram m_quadProgram;
};

} // namespace render
#endif
