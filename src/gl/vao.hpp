#pragma once

#include "glad/glad.h"
#include <cstddef>

/// @brief OpenGL Vertex Array Object abstraction
class GLVertexArray {
  public:
  GLVertexArray();
  ~GLVertexArray();

  void bind();
  void enableAttrib(GLint attrib);
  void vertexAttribFormat(
      GLint attrib, GLint dimensions, GLenum type, GLboolean normalize, GLsizei step,
      GLsizei offset);

  void uploadDataBuffer(const void* data, GLsizeiptr size, GLenum usageHint);
  void uploadIndexBuffer(const void* data, GLsizeiptr size, GLenum usageHint);

  private:
  GLuint glObjectId_;
  GLuint dataBuffer_;
  GLuint indexBuffer_;
};
