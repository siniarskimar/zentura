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
#include <utility>

#include <SDL2/SDL.h>

#include "render/glshader.hpp"
#include "render/texturedata.hpp"
#include "render/window.hpp"
#include "expected.hpp"
#include "render/texture.hpp"

/// OpenGL renderer backend.
class GLRenderer {
  public:

  GLRenderer(Window& window);
  GLRenderer(const GLRenderer&) = delete;
  GLRenderer& operator=(const GLRenderer&) = delete;
  ~GLRenderer();

  /// Submit a quad for rendering.
  void submitQuad(const glm::vec3 position, const glm::vec2 size, const glm::vec4 color);

  /// Submit a texture quad for rendering.
  void submitTexturedQuad(
      const glm::vec3 position, const glm::vec2 size, Texture texture);

  /// Get maximum rectangular texture size ( NxN ).
  static unsigned int maxTextureSize();

  /// Render current batch to default framebuffer.
  void flush();

  /// Clear current frambuffer.
  void clearFramebuffer();

  /// Swap framebuffers of a window `this` renderer is bound to
  void swapWindowBuffers();

  /// Creates a new empty texture
  Texture newTexture(GLsizei width, GLsizei height);

  /// Create a new texture from TextureData
  Texture newTexture(const TextureData& data);

  /// Upload/update texture data
  void uploadTextureData(Texture& texture, const TextureData& data);

  // TODO: implement this
  void blitTexture(
      Texture destination, int lod, GLsizei srcWidth, GLsizei srcHeight, GLint xdest,
      GLint ydest, const TextureData& src);

  private:

  /// Generate new TextureId
  uint32_t newTextureId();

  /// Upload/change texture data
  void uploadTextureDataImpl(GLuint texture, const TextureData& data);

  /// Upload vertex data to GPU
  void uploadDataBuffer(const void* data, GLsizeiptr size);

  /// Upload vertex indecies to GPU
  void uploadIndexBuffer(const void* data, GLsizeiptr size);

  struct Vertex {
    glm::vec3 position{};
    glm::vec4 color{};
    uint32_t textureIndex{};
    glm::vec2 textureCoord{};

    // Required for emplace_back
    Vertex(glm::vec3 position, glm::vec4 color) : position(position), color(color) {}

    Vertex(
        glm::vec3 position, glm::vec4 color, uint32_t textureIdx, glm::vec2 textureCoord)
        : position(position),
          color(color),
          textureIndex(textureIdx),
          textureCoord(textureCoord) {}
  };

  GLuint m_vao;
  GLuint m_dataBufferObject;
  GLuint m_indexBufferObject;
  uint32_t m_dataBufferObjectSize;
  uint32_t m_indexBufferObjectSize;

  std::vector<Vertex> m_dataBuffer;
  std::vector<uint32_t> m_indexBuffer;
  GLShaderProgram m_quadProgram;
  Window& m_window;
  std::map<Texture, GLuint> m_textures;
  SDL_GLContext m_sdlGlContext;
};

#endif
