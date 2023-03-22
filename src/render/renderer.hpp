#ifndef RENDER_RENDERER_H
#define RENDER_RENDERER_H

#include "render/vertex.hpp"
#include "render/texture.hpp"
#include <memory>

class Renderer {
  public:
  virtual ~Renderer() = default;

  /// Submit a quad to render.
  virtual void submitQuad(
      const glm::vec3 position, const glm::vec2 size, const glm::vec4 color) = 0;

  /// Sumbit a texture quad to render.
  virtual void submitQuad(
      const glm::vec3 position, const glm::vec2 size,
      std::shared_ptr<Texture> texture) = 0;

  /// Renders current batch.
  /// Forces rendering of current batch. If the underlying renderer backend is not
  /// batching draw calls, this function does nothing.
  virtual void flush(){};

  // TODO: implement this function
  // virtual void submitText(const glm::vec3 position, const float scale, FontDescriptor
  // desc, TextView text);

  virtual void clearFramebuffer() = 0;

  /// Returns maximum rectangular size for texture (N x N).
  virtual unsigned int maxTextureSize() = 0;
};

#endif
