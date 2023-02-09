#include "./shadercompiler.hpp"
#include <cstddef>
#include <utility>

enum GLShaderIndex {
  kVertexShaderIndex = 0,
  kFragmentShaderIndex = 1,
  kGeometryShaderIndex = 2
};

// I could do some template magic to enforce conteval
// but I prefer not to for readability sake
constexpr int getShaderIndex(const GLenum glenum) {
  switch(glenum) {
  case GL_VERTEX_SHADER:
    return kVertexShaderIndex;
  case GL_FRAGMENT_SHADER:
    return kFragmentShaderIndex;
  case GL_GEOMETRY_SHADER:
    return kGeometryShaderIndex;
  default:
    return -1; // std::array should catch this right?
  }
};

GLShaderCompiler::GLShaderCompiler() noexcept : m_shaders(), m_infoLog() {}

GLShaderCompiler::~GLShaderCompiler() {
  for(auto& shader: m_shaders) {
    if(shader != 0) {
      GLCall(glDeleteShader(shader));
    }
  }
}

bool GLShaderCompiler::compile(GLenum type, const std::string& source) {
  GLuint shader = GLCall(glCreateShader(type));

  const GLchar* shaderSources[1] = {source.c_str()};

  GLCall(glShaderSource(
      shader, 1, reinterpret_cast<const GLchar**>(shaderSources), nullptr));
  GLCall(glCompileShader(shader));

  GLint compileStatus = GL_TRUE;
  GLCall(glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus));
  if(compileStatus == GL_FALSE) {
    int infoLogLen = 0;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLogLen);
    std::vector<char> infoLog(infoLogLen, '\0');
    glGetShaderInfoLog(shader, infoLogLen, nullptr, infoLog.data());

    glDeleteShader(shader);
    m_infoLog = {infoLog.begin(), infoLog.end()};
    return false;
  }

  m_shaders.at(getShaderIndex(type)) = shader;

  return true;
}

std::optional<GLShaderProgram> GLShaderCompiler::link(const bool deleteShaders) {
  auto shaderProg = GLCall(glCreateProgram());

  for(auto& shader: m_shaders) {
    if(shader != 0) {
      GLCall(glAttachShader(shaderProg, shader));
    }
  }

  GLCall(glLinkProgram(shaderProg));

  GLint linkStatus = GL_TRUE;
  glGetProgramiv(shaderProg, GL_LINK_STATUS, &linkStatus);
  if(linkStatus == GL_FALSE) {
    int infoLogLen = 0;
    glGetProgramiv(shaderProg, GL_INFO_LOG_LENGTH, &infoLogLen);
    std::vector<char> infoLog(infoLogLen, '\0');
    glGetProgramInfoLog(shaderProg, infoLogLen, nullptr, infoLog.data());

    glDeleteProgram(shaderProg);
    m_infoLog = {infoLog.begin(), infoLog.end()};
    return std::nullopt;
  }

  if(deleteShaders == true) {
    for(auto& shader: m_shaders) {
      if(shader != 0) {
        GLCall(glDeleteShader(shader));
        shader = 0;
      }
    }
  }

  return std::make_optional<GLShaderProgram>(shaderProg);
}
