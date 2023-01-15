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

GLShaderCompiler::CompilationStatus GLShaderCompiler::compile(
    GLenum type, const std::string& source) {
  GLuint shader = GLCall(glCreateShader(type));

  const GLchar* shaderSources[1] = {source.c_str()};

  GLCall(glShaderSource(shader, 1, shaderSources, nullptr));
  GLCall(glCompileShader(shader));

  GLint compileStatus = GL_TRUE;
  GLCall(glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus));
  if(compileStatus == GL_FALSE) {
    glDeleteShader(shader);
    return false;
  }

  switch(type) {
  case GL_VERTEX_SHADER:
    vertexShader = shader;
    break;
  case GL_FRAGMENT_SHADER:
    fragmentShader = shader;
    break;
  default:
    // ??? possibly higher OpenGL version
    // let's be conservative
    glDeleteShader(shader);
    return false;
  }
  return true;
}

GLShaderCompiler::GLShaderCompiler()
    : vertexShader(0),
      fragmentShader(0),
      geometryShader(0) {}

std::optional<GLShaderProgram> GLShaderCompiler::link() {
  auto shaderProg = GLCall(glCreateProgram());

  if(vertexShader != 0) {
    GLCall(glAttachShader(shaderProg, vertexShader));
  }
  if(fragmentShader != 0) {
    GLCall(glAttachShader(shaderProg, fragmentShader));
  }
  if(geometryShader != 0) {
    GLCall(glAttachShader(shaderProg, geometryShader));
  }

  GLCall(glLinkProgram(shaderProg));

  GLint linkStatus = GL_TRUE;
  glGetProgramiv(shaderProg, GL_LINK_STATUS, &linkStatus);
  if(linkStatus == GL_FALSE) {
    return std::nullopt;
  }

  if(vertexShader != 0) {
    GLCall(glDetachShader(shaderProg, vertexShader));
  }
  if(fragmentShader != 0) {
    GLCall(glDetachShader(shaderProg, fragmentShader));
  }
  if(geometryShader != 0) {
    GLCall(glDetachShader(shaderProg, geometryShader));
  }

  return std::make_optional<GLShaderProgram>(shaderProg);
}

GLShaderCompiler::CompilationStatus::CompilationStatus(bool success, std::string infoLog)
    : success(success),
      infoLog(infoLog) {}

GLShaderCompiler::CompilationStatus::operator bool() {
  return success;
}
