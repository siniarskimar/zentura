#include "./glrenderer.hpp"
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

uniform sampler2D texture;
uniform bool enableTexture;

out vec4 frag_color;

void main() {
  frag_color = vertex_color;
  if(enableTexture) {
    frag_color = texture(textureAtlas, vertex_textureCoords);
  }
}
    
)";

GLRenderer::GLRenderer()
    : m_vao(0),
      m_dataBufferObject(0),
      m_indexBufferObject(0),
      m_dataBufferObjectSize(0),
      m_indexBufferObjectSize(0) {
  constexpr int kPositionAttribLoc = 0;
  constexpr int kColorAttribLoc = 1;
  constexpr int kTextureCoordAttribLoc = 2;

  auto quadProgram =
      GLShaderProgram::compile(kEmbedShaderSimpleVertex, kEmbedShaderSimpleFrag);

  if(!quadProgram.has_value()) {
    throw std::runtime_error("Could not compile shader");
  }
  m_quadProgram = std::move(quadProgram.value());

  glGenVertexArrays(1, &m_vao);
  glGenBuffers(1, &m_dataBufferObject);
  glGenBuffers(1, &m_indexBufferObject);

  glEnable(GL_DEPTH_TEST);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  bindVAO();
  glBindBuffer(GL_ARRAY_BUFFER, m_dataBufferObject);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBufferObject);

  glEnableVertexAttribArray(kPositionAttribLoc);
  glVertexAttribPointer(
      kPositionAttribLoc, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      reinterpret_cast<const void*>(offsetof(Vertex, position)));

  glEnableVertexAttribArray(kColorAttribLoc);
  glVertexAttribPointer(
      kColorAttribLoc, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      reinterpret_cast<const void*>(offsetof(Vertex, color)));

  glEnableVertexAttribArray(kTextureCoordAttribLoc);
  glVertexAttribPointer(
      kTextureCoordAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      reinterpret_cast<const void*>(offsetof(Vertex, textureCoord)));
}

GLRenderer::~GLRenderer() {
  glDeleteBuffers(1, &m_dataBufferObject);
  glDeleteBuffers(1, &m_indexBufferObject);
  glDeleteVertexArrays(1, &m_vao);
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

void GLRenderer::submitTexturedQuad(
    const glm::vec3 position, const glm::vec2 size, std::shared_ptr<Texture> texture) {

  glm::vec2 textureCoords[4];
  GLuint textureObject{};

  textureCoords[0] = {0.0f, 0.0f};
  textureCoords[1] = {1.0f, 0.0f};
  textureCoords[2] = {1.0f, 1.0f};
  textureCoords[3] = {0.0f, 1.0f};

  m_dataBuffer.emplace_back(
      position, glm::vec4{247 / 255.0f, 5 / 255.0f, 118 / 255.0f, 1.0f}, 0,
      textureCoords[0]);
  m_dataBuffer.emplace_back(
      position + glm::vec3(size.x, 0.0f, 0.0f),
      glm::vec4{247 / 255.0f, 5 / 255.0f, 118 / 255.0f, 1.0f}, 0, textureCoords[1]);
  m_dataBuffer.emplace_back(
      position + glm::vec3(size.x, -size.y, 0.0f),
      glm::vec4{247 / 255.0f, 5 / 255.0f, 118 / 255.0f, 1.0f}, 0, textureCoords[2]);
  m_dataBuffer.emplace_back(
      position - glm::vec3(0.0f, size.y, 0.0f),
      glm::vec4{247 / 255.0f, 5 / 255.0f, 118 / 255.0f, 1.0f}, 0, textureCoords[3]);

  const uint32_t indexCount = m_indexBuffer.size() * 4 / 6;
  m_indexBuffer.push_back(indexCount + 0);
  m_indexBuffer.push_back(indexCount + 1);
  m_indexBuffer.push_back(indexCount + 2);
  m_indexBuffer.push_back(indexCount + 2);
  m_indexBuffer.push_back(indexCount + 3);
  m_indexBuffer.push_back(indexCount + 0);

  m_quadProgram.use();
  m_quadProgram.setUniformSafe("texture", textureObject);
  m_quadProgram.setUniformSafe("enableTexture", true);
  flush();
}

void GLRenderer::flush() {
  uploadDataBuffer(
      m_dataBuffer.data(), static_cast<GLsizeiptr>(m_dataBuffer.size() * sizeof(Vertex)));
  uploadIndexBuffer(
      m_indexBuffer.data(),
      static_cast<GLsizeiptr>(m_indexBuffer.size() * sizeof(uint32_t)));
  m_quadProgram.use();
  m_quadProgram.setUniformMatrixSafe(
      "u_proj", glm::ortho(0.0f, 400.0f, 0.0f, 400.0f, -1.0f, 1.0f));
  bindVAO();
  GLCall(glDrawElements(GL_TRIANGLES, m_indexBuffer.size(), GL_UNSIGNED_INT, nullptr));
  m_dataBuffer.erase(m_dataBuffer.begin(), m_dataBuffer.end());
  m_indexBuffer.erase(m_indexBuffer.begin(), m_indexBuffer.end());
  m_quadProgram.setUniformSafe("enableTexture", false);
}

unsigned int GLRenderer::maxTextureSize() {
  static unsigned int maxSupportedTextureSize = 1024;
  static bool cached = false;
  if(cached == false) {
    GLint getResult = 0;
    GLCall(glGetIntegerv(GL_MAX_TEXTURE_SIZE, &getResult));
    maxSupportedTextureSize = getResult;
    cached = true;
  }
  return maxSupportedTextureSize;
}

void GLRenderer::bindVAO() {
  GLCall(glBindVertexArray(m_vao));
}

void GLRenderer::uploadDataBuffer(const void* data, GLsizeiptr size) {
  glBindBuffer(GL_ARRAY_BUFFER, m_dataBufferObject);

  if(size > m_dataBufferObjectSize) {
    glBufferData(GL_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
    m_dataBufferObjectSize = size;
  } else {
    glBufferSubData(GL_ARRAY_BUFFER, 0, size, data);
  }
}

void GLRenderer::uploadIndexBuffer(const void* data, GLsizeiptr size) {
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBufferObject);

  if(size > m_indexBufferObjectSize) {
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
    m_indexBufferObjectSize = size;
  } else {
    glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, size, data);
  }
}
