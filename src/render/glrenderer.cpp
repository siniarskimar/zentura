#include "./glrenderer.hpp"
#include <GLFW/glfw3.h>
#include <memory>
#include <optional>
#include <stdexcept>

static const char* const kEmbedShaderSimpleVertex =
    R"(
#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec4 color;
layout (location = 2) in vec2 textureCoords;

out vec4 vertex_color;
out int vertex_textureIndex;
out vec2 vertex_textureCoords;

void main() {
  gl_Position = vec4(position.xyz, 1.0);
  vertex_color = color;
  vertex_textureCoords = textureCoords;
}
    
)";

static const char* const kEmbedShaderSimpleFrag =
    R"(
#version 330 core

in vec4 vertex_color;
in vec2 vertex_textureCoords;

uniform sampler2D tex;
uniform bool enableTexture;

out vec4 frag_color;

void main() {
  frag_color = vertex_color;
  if(enableTexture) {
    frag_color = texture(tex, vertex_textureCoords);
  }
}
    
)";

GLRenderer::GLRenderer(ui::Window& window)
    : m_vao(0),
      m_dataBufferObject(0),
      m_indexBufferObject(0),
      m_dataBufferObjectSize(0),
      m_indexBufferObjectSize(0),
      m_window(window) {
  constexpr int kPositionAttribLoc = 0;
  constexpr int kColorAttribLoc = 1;
  constexpr int kTextureCoordAttribLoc = 2;
  window.makeContextCurrent();

  gladLoadGLLoader(reinterpret_cast<GLADloadproc>(glfwGetProcAddress));

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
  for(auto pair: m_textures) {
    glDeleteTextures(1, &pair.second);
  }
  glDeleteBuffers(1, &m_dataBufferObject);
  glDeleteBuffers(1, &m_indexBufferObject);
  glDeleteVertexArrays(1, &m_vao);
}

// NOLINTBEGIN(readability-convert-member-functions-to-static)
void GLRenderer::clearFramebuffer() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// NOLINTEND(readability-convert-member-functions-to-static)

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
    const glm::vec3 position, const glm::vec2 size, TextureId texture) {

  glm::vec2 textureCoords[4];
  GLuint textureObject = m_textures.at(texture);

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

  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_2D, textureObject);

  m_quadProgram.use();
  m_quadProgram.setUniformSafe("tex", 1);
  m_quadProgram.setUniformSafe("enableTexture", true);
  flush();
  m_quadProgram.setUniformSafe("enableTexture", false);
}

void GLRenderer::flush() {
  if(m_dataBuffer.empty()) {
    return;
  }
  bindVAO();
  uploadDataBuffer(
      m_dataBuffer.data(), static_cast<GLsizeiptr>(m_dataBuffer.size() * sizeof(Vertex)));
  uploadIndexBuffer(
      m_indexBuffer.data(),
      static_cast<GLsizeiptr>(m_indexBuffer.size() * sizeof(uint32_t)));
  m_quadProgram.use();
  m_quadProgram.setUniformMatrixSafe(
      "u_proj", glm::ortho(0.0f, 400.0f, 0.0f, 400.0f, -1.0f, 1.0f));
  GLCall(glDrawElements(GL_TRIANGLES, m_indexBuffer.size(), GL_UNSIGNED_INT, nullptr));
  m_dataBuffer.erase(m_dataBuffer.begin(), m_dataBuffer.end());
  m_indexBuffer.erase(m_indexBuffer.begin(), m_indexBuffer.end());
}

unsigned int GLRenderer::maxTextureSize() {
  static unsigned int maxSupportedTextureSize = 1024;
  static bool cached = false;
  if(!cached) {
    GLint getResult = 0;
    GLCall(glGetIntegerv(GL_MAX_TEXTURE_SIZE, &getResult));
    maxSupportedTextureSize = getResult;
    cached = true;
  }
  return maxSupportedTextureSize;
}

// NOLINTBEGIN(readability-make-member-function-const)
void GLRenderer::bindVAO() {
  GLCall(glBindVertexArray(m_vao));
}

// NOLINTEND(readability-make-member-function-const)

void GLRenderer::uploadDataBuffer(const void* data, GLsizeiptr size) {
  GLuint currentBuffer = 0;
  glGetIntegerv(GL_ARRAY_BUFFER_BINDING, reinterpret_cast<int*>(&currentBuffer));

  if(currentBuffer != m_dataBufferObject) {
    glBindBuffer(GL_ARRAY_BUFFER, m_dataBufferObject);
  }

  if(size > m_dataBufferObjectSize) {
    glBufferData(GL_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
    m_dataBufferObjectSize = size;
  } else {
    glBufferSubData(GL_ARRAY_BUFFER, 0, size, data);
  }
}

void GLRenderer::uploadIndexBuffer(const void* data, GLsizeiptr size) {
  GLuint currentBuffer = 0;
  glGetIntegerv(GL_ARRAY_BUFFER_BINDING, reinterpret_cast<int*>(&currentBuffer));

  if(currentBuffer != m_indexBufferObject) {
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBufferObject);
  }

  if(size > m_indexBufferObjectSize) {
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
    m_indexBufferObjectSize = size;
  } else {
    glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, size, data);
  }
}

void GLRenderer::swapWindowBuffers() {
  glfwSwapBuffers(m_window.getGLFWHandle());
}

GLRenderer::TextureId GLRenderer::newTexture(GLsizei width, GLsizei height) {
  static TextureId nextId = 1;
  GLuint textureObject = 0;

  glGenTextures(1, &textureObject);
  if(textureObject == 0) [[unlikely]] {
    throw std::runtime_error("Failed to create OpenGL texture");
  }
  auto textureId = nextId;
  nextId++;
  GLuint currentTexture = 0;
  glGetIntegerv(GL_TEXTURE_BINDING_2D, reinterpret_cast<GLint*>(&currentTexture));

  glBindTexture(GL_TEXTURE_2D, textureObject);
  glTexImage2D(
      GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  glBindTexture(GL_TEXTURE_2D, currentTexture);

  m_textures.insert({textureId, textureObject});
  return textureId;
}

GLRenderer::TextureId GLRenderer::newTexture(std::shared_ptr<TextureData> data) {
  static TextureId nextId = 1;
  GLuint textureObject = 0;

  glGenTextures(1, &textureObject);
  if(textureObject == 0) [[unlikely]] {
    throw std::runtime_error("Failed to create OpenGL texture");
  }
  auto textureId = nextId;
  nextId++;

  if(data->getChannelCount() < 4) {
    data = std::make_shared<TextureData>(data->expandToRGBA());
  }

  GLuint currentTexture = 0;
  glGetIntegerv(GL_TEXTURE_BINDING_2D, reinterpret_cast<GLint*>(&currentTexture));

  glBindTexture(GL_TEXTURE_2D, textureObject);
  glTexImage2D(
      GL_TEXTURE_2D, 0, GL_RGBA8, data->getWidth(), data->getHeight(), 0, GL_RGBA,
      GL_UNSIGNED_BYTE, data->getTextureData().data());
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  glBindTexture(GL_TEXTURE_2D, currentTexture);

  m_textures.insert({textureId, textureObject});
  return textureId;
}

void GLRenderer::uploadTextureData(TextureId texture, std::shared_ptr<TextureData> data) {
  auto textureObject = m_textures.at(texture);
  GLuint currentTexture = 0;
  glGetIntegerv(GL_TEXTURE_BINDING_2D, reinterpret_cast<GLint*>(&currentTexture));

  glBindTexture(GL_TEXTURE_2D, textureObject);

  auto channels = data->getChannelCount();

  if(channels < 4) {
    data = std::make_shared<TextureData>(data->expandToRGBA());
  }

  glTexImage2D(
      GL_TEXTURE_2D, 0, GL_RGBA8, static_cast<int>(data->getWidth()),
      static_cast<int>(data->getHeight()), 0, GL_RGBA, GL_UNSIGNED_BYTE,
      data->getTextureData().data());

  if(currentTexture != textureObject) {
    glBindTexture(GL_TEXTURE_2D, currentTexture);
  }
}
