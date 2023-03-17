#include "gl/vao.hpp"

void GLVertexArray::bind() {
  glBindVertexArray(m_glObjectId);
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

void GLVertexArray::uploadDataBuffer(const void* data, GLsizeiptr size) {
  glBindBuffer(GL_ARRAY_BUFFER, m_dataBuffer);

  if(size > m_dataBufferSize) {
    glBufferData(GL_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
    m_dataBufferSize = size;
  } else {
    glBufferSubData(GL_ARRAY_BUFFER, 0, size, data);
  }
}

void GLVertexArray::uploadIndexBuffer(const void* data, GLsizeiptr size) {
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);

  if(size > m_indexBufferSize) {
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
  } else {
    glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, size, data);
  }
}
