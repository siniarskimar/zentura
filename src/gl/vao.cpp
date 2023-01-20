#include "gl/vao.hpp"

GLVAO::GLVAO() {
  glGenVertexArrays(1, &glObjectId_);
  glGenBuffers(1, &dataBuffer_);
  glGenBuffers(1, &indexBuffer_);
}

GLVAO::~GLVAO() {
  glDeleteVertexArrays(1, &glObjectId_);
  glDeleteBuffers(1, &dataBuffer_);
  glDeleteBuffers(1, &indexBuffer_);
}

void GLVAO::bind() {
  glBindVertexArray(glObjectId_);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer_);
}

void GLVAO::enableAttrib(GLint attrib) {
  bind();
  glEnableVertexAttribArray(attrib);
}

void GLVAO::vertexAttribFormat(
    GLint attrib, GLint dimensions, GLenum type, GLboolean normalize, GLsizei step,
    GLsizei offset) {
  bind();
  glBindBuffer(GL_ARRAY_BUFFER, dataBuffer_);
  glVertexAttribPointer(
      attrib, dimensions, type, normalize, step, (const void*) (uintptr_t) offset);
}

void GLVAO::uploadDataBuffer(const void* data, size_t size, GLenum usageHint) {
  glBindBuffer(GL_ARRAY_BUFFER, dataBuffer_);
  glBufferData(GL_ARRAY_BUFFER, size, data, usageHint);
}

void GLVAO::uploadIndexBuffer(const void* data, size_t size, GLenum usageHint) {
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer_);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, usageHint);
}
