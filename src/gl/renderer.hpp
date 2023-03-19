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
#include <map>

namespace render {

/// OpenGL renderer backend.
class GLRenderer : public Renderer {
  public:
  GLRenderer();

  /// Submit a quad for rendering.
  void submitQuad(
      const glm::vec3 position, const glm::vec2 size, const glm::vec4 color) override;

  /// Submit a texture quad for rendering.
  void submitQuad(
      const glm::vec3 position, const glm::vec2 size,
      std::shared_ptr<Texture> texture) override;

  /// Get maximum rectangular texture size ( NxN ).
  unsigned int maxTextureSize() override;

  /// Render current batch to default framebuffer.
  void flush() override;

  /// Clear current frambuffer.
  void clearFramebuffer() override;

  private:
  template <typename K, typename V>
  using WeakPtrMap = std::map<std::weak_ptr<K>, V, std::owner_less<>>;

  /// Wrapper around OpenGL Vertex Array Object.
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

  struct TextureBoundingBox {
    unsigned int x;
    unsigned int y;
    unsigned int width;
    unsigned int height;
  };

  struct TextureAtlas {
    std::shared_ptr<Texture> textureAtlas;
    WeakPtrMap<Texture, TextureBoundingBox> boundingBoxes;
    std::optional<TextureBoundingBox> fit(std::shared_ptr<Texture> texture);
  };

  private:
  std::vector<Vertex> m_dataBuffer;
  std::vector<uint32_t> m_indexBuffer;
  GLVAO m_vao;
  GLShaderProgram m_quadProgram;
  std::vector<TextureAtlas> m_textureAtlases;
  std::vector<std::shared_ptr<Texture>> m_boundTextures;
  std::map<
      std::weak_ptr<Texture>, std::reference_wrapper<TextureAtlas>, std::owner_less<>>
      m_textureToAtlasMap;
  std::map<std::weak_ptr<Texture>, GLuint, std::owner_less<>> m_textureToObjectMap;
};

} // namespace render
#endif
