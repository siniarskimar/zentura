#include "gl/vao.hpp"

GLVertexArray::GLVertexArray() : glObjectId_(0), dataBuffer_(0), indexBuffer_(0) {
  glGenVertexArrays(1, &glObjectId_);
  glGenBuffers(1, &dataBuffer_);
  glGenBuffers(1, &indexBuffer_);
}

GLVertexArray::~GLVertexArray() {
  glDeleteVertexArrays(1, &glObjectId_);
  glDeleteBuffers(1, &dataBuffer_);
  glDeleteBuffers(1, &indexBuffer_);
}

void GLVertexArray::bind() {
  glBindVertexArray(glObjectId_);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer_);
}

void GLVertexArray::enableAttrib(GLint attrib) {
  bind();
  glEnableVertexAttribArray(attrib);
}

void GLVertexArray::vertexAttribFormat(
    GLint attrib, GLint dimensions, GLenum type, GLboolean normalize, GLsizei step,
    GLsizei offset) {
  bind();
  glBindBuffer(GL_ARRAY_BUFFER, dataBuffer_);
  glVertexAttribPointer(
      attrib, dimensions, type, normalize, step, (const void*) (uintptr_t) offset);
}

void GLVertexArray::uploadDataBuffer(
    const void* data, GLsizeiptr size, GLenum usageHint) {
  glBindBuffer(GL_ARRAY_BUFFER, dataBuffer_);
  glBufferData(GL_ARRAY_BUFFER, size, data, usageHint);
}

void GLVertexArray::uploadIndexBuffer(
    const void* data, GLsizeiptr size, GLenum usageHint) {
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer_);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, usageHint);
}
