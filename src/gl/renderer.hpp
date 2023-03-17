#ifndef GL_RENDERER_H
#define GL_RENDERER_H

#include "gl/gl.hpp"
#include <vector>
#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>
#include <glm/ext/matrix_clip_space.hpp>
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

  unsigned int maxTextureSize() override;

  /// @brief Render current batch to default framebuffer
  void flush() override;

  void clearFramebuffer() override;

  private:
  struct GLVAO {
    GLuint glId;
    GLuint dataBufferId;
    GLuint indexBufferId;
    uint32_t dataBufferSize;
    uint32_t indexBufferSize;

    GLVAO();
    GLVAO(const GLVAO&) = delete;
    GLVAO& operator=(const GLVAO&) = delete;
    GLVAO(GLVAO&&);
    GLVAO& operator=(GLVAO&&);
    ~GLVAO();

    void bind();
    void uploadDataBuffer(const void* data, GLsizeiptr size);
    void uploadIndexBuffer(const void* data, GLsizeiptr size);
  };

  private:
  std::vector<Vertex> m_dataBuffer;
  std::vector<uint32_t> m_indexBuffer;
  GLVAO m_vao;
  GLShaderProgram m_quadProgram;
};

} // namespace render
#endif
