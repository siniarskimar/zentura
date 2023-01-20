#pragma once

#include "gl/glad/glad.h"
#include <cstddef>

/// @brief OpenGL Vertex Array Object abstraction
class GLVAO {
  public:
  GLVAO();
  ~GLVAO();

  void bind();
  void enableAttrib(GLint attrib);
  void vertexAttribFormat(
      GLint attrib, GLint dimensions, GLenum type, GLboolean normalize, GLsizei step,
      GLsizei offset);

  void uploadDataBuffer(const void* data, size_t size, GLenum usageHint);
  void uploadIndexBuffer(const void* data, size_t size, GLenum usageHint);

  private:
  GLuint glObjectId_;
  GLuint dataBuffer_;
  GLuint indexBuffer_;
};
