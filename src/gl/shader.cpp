#include "gl/shader.hpp"
#include "gl.hpp"
#include <optional>
#include <string_view>

GLShaderProgram::GLShaderProgram(GLuint glID) : glID_(glID) {}

GLShaderProgram::~GLShaderProgram() {
  auto object = getGLObjectID();
  if(object != 0) {
    glDeleteProgram(object);
  }
}

void GLShaderProgram::use() {
  GLCall(glUseProgram(getGLObjectID()));
}

GLuint GLShaderProgram::getGLObjectID() const noexcept {
  return glID_;
}

GLint GLShaderProgram::getUniformLocation(const std::string& name) const {
  auto loc = GLCall(glGetUniformLocation(getGLObjectID(), name.data()));
  return loc;
}

GLint GLShaderProgram::getAttribLocation(const std::string& name) const {
  auto loc = GLCall(glGetAttribLocation(getGLObjectID(), name.data()));
  return loc;
}
