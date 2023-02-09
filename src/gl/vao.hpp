#pragma once

#include "glad/glad.h"
#include <cstddef>

/// @brief OpenGL Vertex Array Object abstraction
class GLVertexArray {
  public:
  GLVertexArray() noexcept;
  GLVertexArray(const GLVertexArray&) = delete;
  GLVertexArray(GLVertexArray&&) = default;
  GLVertexArray& operator=(const GLVertexArray&) = delete;
  GLVertexArray& operator=(GLVertexArray&&) = default;
  ~GLVertexArray() noexcept;

  void bind();
  void enableAttrib(GLint attrib);
  void vertexAttribFormat(
      GLint attrib, GLint dimensions, GLenum type, GLboolean normalize, GLsizei step,
      GLsizei offset);

  void uploadDataBuffer(const void* data, GLsizeiptr size, GLenum usageHint);
  void uploadIndexBuffer(const void* data, GLsizeiptr size, GLenum usageHint);

  private:
  GLuint m_glObjectId;
  GLuint m_dataBuffer;
  GLuint m_indexBuffer;
};
