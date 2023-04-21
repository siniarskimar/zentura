#include "render/glshader.hpp"
#include "render/gl.hpp"
#include <optional>
#include <string_view>
#include <fmt/core.h>

GLuint compileShader(GLenum type, const std::string_view source) {
  GLuint shader = GLCall(glCreateShader(type));

  const GLchar* shaderSources[1] = {source.data()};

  GLCall(glShaderSource(
      shader, 1, reinterpret_cast<const GLchar**>(shaderSources), nullptr));
  GLCall(glCompileShader(shader));

  GLint compileStatus = GL_TRUE;
  GLCall(glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus));
  if(compileStatus == GL_FALSE) {
    int infoLogLen = 0;
    GLCall(glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLogLen));
    std::vector<char> infoLog(infoLogLen, '\0');
    GLCall(glGetShaderInfoLog(shader, infoLogLen, nullptr, infoLog.data()));

    glDeleteShader(shader);
    fmt::print(stderr, "Shader source compilation failed!\n{}\n", infoLog.data());
    return 0;
  }

  return shader;
}

GLShaderProgram::GLShaderProgram() : m_glId(0) {}

GLShaderProgram::GLShaderProgram(GLuint glID) : m_glId(glID) {
  if(!glIsProgram(m_glId)) {
    throw std::runtime_error(
        "Attempted to create GLShaderProgram with non GL Program object");
  }
}

GLShaderProgram::GLShaderProgram(GLShaderProgram&& other) : m_glId(other.m_glId) {
  other.m_glId = 0;
}

GLShaderProgram& GLShaderProgram::operator=(GLShaderProgram&& other) {
  m_glId = other.m_glId;
  other.m_glId = 0;
  return *this;
}

GLShaderProgram::~GLShaderProgram() {
  if(m_glId != 0) {
    glDeleteProgram(m_glId);
  }
  m_glId = 0;
}

std::optional<GLShaderProgram> GLShaderProgram::compile(
    const std::string_view vertexSource, const std::string_view fragmentSource) {
  auto vertexShader = compileShader(GL_VERTEX_SHADER, vertexSource);
  auto fragmentShader = compileShader(GL_FRAGMENT_SHADER, fragmentSource);

  if(vertexShader == 0 || fragmentShader == 0) {
    return std::nullopt;
  }
  auto program = GLCall(glCreateProgram());

  GLCall(glAttachShader(program, vertexShader));
  GLCall(glAttachShader(program, fragmentShader));
  GLCall(glLinkProgram(program));

  GLint linkStatus = GL_TRUE;
  GLCall(glGetProgramiv(program, GL_LINK_STATUS, &linkStatus));

  if(linkStatus == GL_FALSE) {
    int infoLogLen = 0;
    GLCall(glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLogLen));
    std::vector<char> infoLog(infoLogLen, '\0');
    GLCall(glGetProgramInfoLog(program, infoLogLen, nullptr, infoLog.data()));

    fmt::print(stderr, "Shader link step failed!\n{}\n", infoLog.data());

    GLCall(glDeleteProgram(program));
    GLCall(glDeleteShader(vertexShader));
    GLCall(glDeleteShader(fragmentShader));
    return std::nullopt;
  }

  return program;
}

// This function changes global state
// NOLINTBEGIN(readability-make-member-function-const)
void GLShaderProgram::use() {
  GLCall(glUseProgram(getGLObjectID()));
}

// NOLINTEND(readability-make-member-function-const)

GLuint GLShaderProgram::getGLObjectID() const noexcept {
  return m_glId;
}

GLint GLShaderProgram::getUniformLocation(const std::string& name) {
  if(m_locCache.contains(name)) {
    return m_locCache.at(name);
  }
  auto loc = GLCall(glGetUniformLocation(getGLObjectID(), name.data()));
  m_locCache.insert({name, loc});
  return loc;
}

GLint GLShaderProgram::getUniformLocation(const std::string& name) const {
  if(m_locCache.contains(name)) {
    return m_locCache.at(name);
  }
  auto loc = GLCall(glGetUniformLocation(getGLObjectID(), name.data()));
  return loc;
}

GLint GLShaderProgram::getAttribLocation(const std::string& name) {
  if(m_locCache.contains(name)) {
    return m_locCache.at(name);
  }
  auto loc = GLCall(glGetAttribLocation(getGLObjectID(), name.data()));
  m_locCache.insert({name, loc});
  return loc;
}

GLint GLShaderProgram::getAttribLocation(const std::string& name) const {
  if(m_locCache.contains(name)) {
    return m_locCache.at(name);
  }
  auto loc = GLCall(glGetAttribLocation(getGLObjectID(), name.data()));
  return loc;
}
