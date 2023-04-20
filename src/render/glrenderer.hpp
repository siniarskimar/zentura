#ifndef GL_RENDERER_H
#define GL_RENDERER_H

#include "render/gl.hpp"

#include <vector>
#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>
#include <cstdint>
#include <glm/ext/matrix_clip_space.hpp>
#include <map>

#include "render/glshader.hpp"
#include "render/texture.hpp"
#include "ui/window.hpp"

/// OpenGL renderer backend.
class GLRenderer {
  public:
  using TextureId = uint32_t;

  GLRenderer(ui::Window& window);
  GLRenderer(const GLRenderer&) = delete;
  GLRenderer(GLRenderer&&) = delete;
  GLRenderer& operator=(const GLRenderer&) = delete;
  GLRenderer& operator=(GLRenderer&&) = delete;
  ~GLRenderer();

  /// Submit a quad for rendering.
  void submitQuad(const glm::vec3 position, const glm::vec2 size, const glm::vec4 color);

  /// Submit a texture quad for rendering.
  void submitTexturedQuad(
      const glm::vec3 position, const glm::vec2 size, TextureId texture);

  /// Get maximum rectangular texture size ( NxN ).
  unsigned int maxTextureSize();

  /// Render current batch to default framebuffer.
  void flush();

  /// Clear current frambuffer.
  void clearFramebuffer();

  void swapWindowBuffers();

  TextureId newTexture(GLsizei width, GLsizei height);
  TextureId newTexture(std::shared_ptr<TextureData> data);

  void uploadTextureData(TextureId texture, std::shared_ptr<TextureData> data);

  // TODO: implement this
  void blitTexture(
      TextureId destination, int lod, GLsizei srcWidth, GLsizei srcHeight, GLint xdest,
      GLint ydest, std::shared_ptr<TextureData> src);

  private:
  TextureId newTextureId();
  void bindVAO();
  void uploadDataBuffer(const void* data, GLsizeiptr size);
  void uploadIndexBuffer(const void* data, GLsizeiptr size);

  struct Vertex {
    glm::vec3 position{};
    glm::vec4 color{};
    uint32_t textureIndex{};
    glm::vec2 textureCoord{};

    Vertex(glm::vec3 position, glm::vec4 color) : position(position), color(color) {}

    Vertex(
        glm::vec3 position, glm::vec4 color, uint32_t textureIdx, glm::vec2 textureCoord)
        : position(position),
          color(color),
          textureIndex(textureIdx),
          textureCoord(textureCoord) {}
  };

  private:
  GLuint m_vao;
  GLuint m_dataBufferObject;
  GLuint m_indexBufferObject;
  uint32_t m_dataBufferObjectSize;
  uint32_t m_indexBufferObjectSize;

  std::vector<Vertex> m_dataBuffer;
  std::vector<uint32_t> m_indexBuffer;
  GLShaderProgram m_quadProgram;
  ui::Window& m_window;
  std::map<TextureId, GLuint> m_textures;
};

#endif
