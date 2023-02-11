#include "gl/vao.hpp"

GLVertexArray::GLVertexArray() noexcept
    : m_glObjectId(0),
      m_dataBuffer(0),
      m_indexBuffer(0) {
  glGenVertexArrays(1, &m_glObjectId);
  glGenBuffers(1, &m_dataBuffer);
  glGenBuffers(1, &m_indexBuffer);
}

GLVertexArray::~GLVertexArray() noexcept {
  // We have to check if object exists
  // in case move happened
  if(m_glObjectId != 0) {
    glDeleteVertexArrays(1, &m_glObjectId);
  }
  if(m_dataBuffer != 0) {
    glDeleteBuffers(1, &m_dataBuffer);
  }
  if(m_indexBuffer != 0) {
    glDeleteBuffers(1, &m_indexBuffer);
  }
}

GLVertexArray::GLVertexArray(GLVertexArray&& other) noexcept
    : m_glObjectId(other.m_glObjectId),
      m_dataBuffer(other.m_dataBuffer),
      m_indexBuffer(other.m_indexBuffer) {
  other.m_dataBuffer = 0;
  other.m_glObjectId = 0;
  other.m_indexBuffer = 0;
}

GLVertexArray& GLVertexArray::operator=(GLVertexArray&& other) noexcept {
  this->m_glObjectId = other.m_glObjectId;
  other.m_glObjectId = 0;

  this->m_dataBuffer = other.m_dataBuffer;
  other.m_dataBuffer = 0;
  this->m_indexBuffer = other.m_indexBuffer;
  other.m_indexBuffer = 0;
  return *this;
}

void GLVertexArray::bind() {
  glBindVertexArray(m_glObjectId);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);
}

void GLVertexArray::enableAttrib(GLint attrib) {
  bind();
  glEnableVertexAttribArray(attrib);
}

void GLVertexArray::vertexAttribFormat(
    GLint attrib, GLint dimensions, GLenum type, GLboolean normalize, GLsizei step,
    GLsizei offset) {
  bind();
  glBindBuffer(GL_ARRAY_BUFFER, m_dataBuffer);
  glVertexAttribPointer(
      attrib, dimensions, type, normalize, step, reinterpret_cast<const void*>(offset));
}

void GLVertexArray::uploadDataBuffer(
    const void* data, GLsizeiptr size, GLenum usageHint) {
  glBindBuffer(GL_ARRAY_BUFFER, m_dataBuffer);
  glBufferData(GL_ARRAY_BUFFER, size, data, usageHint);
}

void GLVertexArray::uploadIndexBuffer(
    const void* data, GLsizeiptr size, GLenum usageHint) {
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, usageHint);
}
