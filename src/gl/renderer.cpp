#include "./renderer.hpp"
#include <GLFW/glfw3.h>
#include <optional>
#include <stdexcept>

static const char* const kEmbedShaderSimpleVertex =
    R"(
#version 330 core

layout (location = 0) in vec2 position;
layout (location = 1) in vec4 color;
layout (location = 2) in vec2 textureCoords;

out vec4 vertex_color;
out int vertex_textureIndex;
out vec2 vertex_textureCoords;

void main() {
  gl_Position = vec4(position.xy, 0.0, 1.0);
  vertex_color = color;
  vertex_textureCoords = textureCoords;
}
    
)";

static const char* const kEmbedShaderSimpleFrag =
    R"(
#version 330 core

in vec4 vertex_color;
in vec2 vertex_textureCoords;

uniform sampler2D textureAtlas;

out vec4 frag_color;

void main() {
  frag_color = vertex_color;
}
    
)";

namespace render {

static unsigned int maxSupportedTextureSize = 1024;

GLRenderer::GLRenderer() {
  constexpr int kPositionAttribLoc = 0;
  constexpr int kColorAttribLoc = 1;
  constexpr int kTextureCoordAttribLoc = 2;

  auto quadProgram =
      GLShaderProgram::compile(kEmbedShaderSimpleVertex, kEmbedShaderSimpleFrag);

  if(!quadProgram.has_value()) {
    throw std::runtime_error("Could not compile shader");
  }
  m_quadProgram = std::move(quadProgram.value());

  GLint getResult = 0;
  GLCall(glGetIntegerv(GL_MAX_TEXTURE_SIZE, &getResult));
  maxSupportedTextureSize = getResult;

  GLCall(glEnableVertexAttribArray(kPositionAttribLoc));
  GLCall(glVertexAttribPointer(
      kPositionAttribLoc, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      reinterpret_cast<const void*>(offsetof(Vertex, position))));

  GLCall(glEnableVertexAttribArray(kColorAttribLoc));
  GLCall(glVertexAttribPointer(
      kColorAttribLoc, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      reinterpret_cast<const void*>(offsetof(Vertex, color))));

  GLCall(glEnableVertexAttribArray(kTextureCoordAttribLoc));
  GLCall(glVertexAttribPointer(
      kTextureCoordAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      reinterpret_cast<const void*>(offsetof(Vertex, textureCoord))));
}

void GLRenderer::clearFramebuffer() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void GLRenderer::submitQuad(
    const glm::vec3 position, const glm::vec2 size, const glm::vec4 color) {

  m_dataBuffer.emplace_back(position, color);
  m_dataBuffer.emplace_back(position + glm::vec3(size.x, 0.0f, 0.0f), color);
  m_dataBuffer.emplace_back(position + glm::vec3(size.x, -size.y, 0.0f), color);
  m_dataBuffer.emplace_back(position - glm::vec3(0.0f, size.y, 0.0f), color);

  const uint32_t kIndexCount = m_indexBuffer.size() * 4 / 6;
  m_indexBuffer.push_back(kIndexCount + 0);
  m_indexBuffer.push_back(kIndexCount + 1);
  m_indexBuffer.push_back(kIndexCount + 2);
  m_indexBuffer.push_back(kIndexCount + 2);
  m_indexBuffer.push_back(kIndexCount + 3);
  m_indexBuffer.push_back(kIndexCount + 0);
}

void GLRenderer::submitQuad(
    const glm::vec3 position, const glm::vec2 size, std::shared_ptr<Texture> texture) {}

void GLRenderer::flush() {
  m_vao.uploadDataBuffer(
      m_dataBuffer.data(), static_cast<GLsizeiptr>(m_dataBuffer.size() * sizeof(Vertex)));
  m_vao.uploadIndexBuffer(
      m_indexBuffer.data(),
      static_cast<GLsizeiptr>(m_indexBuffer.size() * sizeof(uint32_t)));
  m_quadProgram.use();
  m_quadProgram.setUniformMatrixSafe(
      "u_proj", glm::ortho(0.0f, 400.0f, 0.0f, 400.0f, -1.0f, 1.0f));
  m_vao.bind();
  GLCall(glDrawElements(GL_TRIANGLES, m_indexBuffer.size(), GL_UNSIGNED_INT, nullptr));
  m_dataBuffer.erase(m_dataBuffer.begin(), m_dataBuffer.end());
  m_indexBuffer.erase(m_indexBuffer.begin(), m_indexBuffer.end());
}

unsigned int GLRenderer::maxTextureSize() {
  return maxSupportedTextureSize;
}

GLRenderer::GLVAO::GLVAO()
    : glId(0),
      dataBufferId(0),
      indexBufferId(0),
      dataBufferSize(),
      indexBufferSize() {
  glGenVertexArrays(1, &glId);
  glGenBuffers(1, &dataBufferId);
  glGenBuffers(1, &indexBufferId);
  glBindVertexArray(glId);
  glBindBuffer(GL_ARRAY_BUFFER, dataBufferId);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferId);
}

GLRenderer::GLVAO::~GLVAO() {
  // We have to check if object exists
  // in case move happened
  if(dataBufferId != 0) {
    glDeleteBuffers(1, &dataBufferId);
  }
  if(indexBufferId != 0) {
    glDeleteBuffers(1, &indexBufferId);
  }
  if(glId != 0) {
    glDeleteVertexArrays(1, &glId);
  }
}

GLRenderer::GLVAO::GLVAO(GLRenderer::GLVAO&& other)
    : glId(other.glId),
      dataBufferId(other.dataBufferId),
      indexBufferId(other.indexBufferId),
      dataBufferSize(other.dataBufferSize),
      indexBufferSize(other.indexBufferSize) {
  other.dataBufferId = 0;
  other.indexBufferId = 0;
  other.glId = 0;
}

GLRenderer::GLVAO& GLRenderer::GLVAO::operator=(GLRenderer::GLVAO&& other) {
  glId = other.glId;
  other.glId = 0;
  dataBufferId = other.dataBufferId;
  other.dataBufferId = 0;
  indexBufferId = other.indexBufferId;
  other.indexBufferId = 0;
  dataBufferSize = other.dataBufferSize;
  indexBufferSize = other.indexBufferSize;

  return *this;
}

void GLRenderer::GLVAO::bind() {
  GLCall(glBindVertexArray(glId));
}

void GLRenderer::GLVAO::uploadDataBuffer(const void* data, GLsizeiptr size) {
  glBindBuffer(GL_ARRAY_BUFFER, dataBufferId);

  if(size > dataBufferSize) {
    glBufferData(GL_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
    dataBufferSize = size;
  } else {
    glBufferSubData(GL_ARRAY_BUFFER, 0, size, data);
  }
}

void GLRenderer::GLVAO::uploadIndexBuffer(const void* data, GLsizeiptr size) {
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferId);

  if(size > indexBufferSize) {
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
  } else {
    glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, size, data);
  }
}

} // namespace render
