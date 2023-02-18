#ifndef GL_VERTEXARRAY_H
#define GL_VERTEXARRAY_H

#include "glad/glad.h"
#include <cstddef>

/// @brief OpenGL Vertex Array Object abstraction
class GLVertexArray {
  public:
  /// @brief Default constructor
  ///
  /// @remark Caution when using multiple VAOs. Constructor leaves newly created
  /// Vertex Array bound.
  GLVertexArray() noexcept;
  GLVertexArray(const GLVertexArray&) = delete;
  GLVertexArray(GLVertexArray&&) noexcept;
  GLVertexArray& operator=(const GLVertexArray&) = delete;
  GLVertexArray& operator=(GLVertexArray&&) noexcept;
  ~GLVertexArray() noexcept;

  void bind();
  void enableAttrib(GLint attrib);
  void vertexAttribFormat(
      GLint attrib, GLint dimensions, GLenum type, GLboolean normalize, GLsizei step,
      GLsizei offset);

  void uploadDataBuffer(const void* data, GLsizeiptr size);
  void uploadIndexBuffer(const void* data, GLsizeiptr size);

  [[nodiscard]] inline GLuint getGLObjectID() const noexcept {
    return m_glObjectId;
  }

  private:
  GLuint m_glObjectId;
  GLuint m_dataBuffer;
  GLuint m_indexBuffer;
  uint32_t m_dataBufferSize;
  uint32_t m_indexBufferSize;
};

#endif
