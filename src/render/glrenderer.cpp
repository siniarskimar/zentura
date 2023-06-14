#include "./glrenderer.hpp"
#include <GLFW/glfw3.h>
#include <memory>
#include <optional>
#include <stdexcept>

GLRenderer::GLRenderer(Window& window)
    : m_vao(0),
      m_dataBufferObject(0),
      m_indexBufferObject(0),
      m_dataBufferObjectSize(0),
      m_indexBufferObjectSize(0),
      m_window(window),
      m_sdlGlContext(SDL_GL_CreateContext(window.getHandle())) {
  constexpr int kPositionAttribLoc = 0;
  constexpr int kColorAttribLoc = 1;
  constexpr int kTextureCoordAttribLoc = 2;

  if(m_sdlGlContext == nullptr) {
    throw std::runtime_error(
        fmt::format("Failed to create OpenGL context: {}", SDL_GetError()));
  }

  gladLoadGLLoader(reinterpret_cast<GLADloadproc>(SDL_GL_GetProcAddress));

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

  glBindVertexArray(m_vao);
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
    const glm::vec3 position, const glm::vec2 size, Texture texture) {

  if(!m_dataBuffer.empty()) {
    m_quadProgram.setUniformSafe("enableTexture", false);
    flush();
  }

  glm::vec2 textureCoords[4];
  const GLuint textureObject = m_textures.at(texture);

  textureCoords[0] = {0.0f, 0.0f};
  textureCoords[1] = {1.0f, 0.0f};
  textureCoords[2] = {1.0f, 1.0f};
  textureCoords[3] = {0.0f, 1.0f};

  constexpr glm::vec4 color = {247 / 255.0f, 5 / 255.0f, 118 / 255.0f, 1.0f};

  m_dataBuffer.emplace_back(position, color, 0, textureCoords[0]);
  m_dataBuffer.emplace_back(
      position + glm::vec3(size.x, 0.0f, 0.0f), color, 0, textureCoords[1]);
  m_dataBuffer.emplace_back(
      position + glm::vec3(size.x, -size.y, 0.0f), color, 0, textureCoords[2]);
  m_dataBuffer.emplace_back(
      position - glm::vec3(0.0f, size.y, 0.0f), color, 0, textureCoords[3]);

  const uint32_t indexCount = (m_indexBuffer.size() / 6) * 4;
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
}

void GLRenderer::flush() {
  if(m_dataBuffer.empty()) {
    return;
  }
  glBindVertexArray(m_vao);
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
  glGetIntegerv(GL_ELEMENT_ARRAY_BUFFER_BINDING, reinterpret_cast<int*>(&currentBuffer));

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
  SDL_GL_SwapWindow(m_window.getHandle());
}

Texture GLRenderer::newTexture(GLsizei width, GLsizei height) {
  GLuint textureObject = 0;

  glGenTextures(1, &textureObject);
  if(textureObject == 0) [[unlikely]] {
    throw std::runtime_error("Failed to create OpenGL texture");
  }
  auto textureId = newTextureId();

  glBindTexture(GL_TEXTURE_2D, textureObject);
  glTexImage2D(
      GL_TEXTURE_2D, 0, GL_R8, width, height, 0, GL_RED, GL_UNSIGNED_BYTE, nullptr);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  Texture tex{textureId, 0};

  m_textures.insert({tex, textureObject});
  return tex;
}

Texture GLRenderer::newTexture(const TextureData& data) {
  GLuint textureObject = 0;

  const auto width = data.getWidth();
  const auto height = data.getHeight();

  if(width > std::numeric_limits<GLsizei>::max()) {
    throw std::runtime_error(
        "GLRenderer::newTexture(TextureData): width is outside of GLsizei range");
  }
  if(height > std::numeric_limits<GLsizei>::max()) {
    throw std::runtime_error(
        "GLRenderer::newTexture(TextureData): height is outside of GLsizei range");
  }

  glGenTextures(1, &textureObject);
  if(textureObject == 0) [[unlikely]] {
    throw std::runtime_error("Failed to create OpenGL texture");
  }
  auto textureId = newTextureId();

  uploadTextureDataImpl(textureObject, data);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  Texture tex{textureId, data.getChannelCount()};

  m_textures.insert({tex, textureObject});
  return tex;
}

void GLRenderer::uploadTextureData(Texture& texture, const TextureData& data) {
  const auto textureObject = m_textures.at(texture);
  uploadTextureDataImpl(textureObject, data);
  texture.channels = data.getChannelCount();
}

void GLRenderer::uploadTextureDataImpl(GLuint texture, const TextureData& data) {
  glBindTexture(GL_TEXTURE_2D, texture);

  const auto channels = data.getChannelCount();

  auto internalFormat = 0;
  auto format = 0;

  switch(channels) {
  case 1:
    format = GL_RED;
    internalFormat = GL_R8;
    break;
  case 2:
    format = GL_RG;
    internalFormat = GL_RG8;
    break;
  case 3:
    format = GL_RGB;
    internalFormat = GL_RGB8;
    break;
  case 4:
    format = GL_RGBA;
    internalFormat = GL_RGBA8;
    break;
  default:
    throw std::logic_error("Tried to upload Texture data with more than 4 channels");
    break;
  }

  glTexImage2D(
      GL_TEXTURE_2D, 0, internalFormat, static_cast<int>(data.getWidth()),
      static_cast<int>(data.getHeight()), 0, format, GL_UNSIGNED_BYTE,
      data.getTextureData().data());
}

uint32_t GLRenderer::newTextureId() {
  static uint32_t idCount = 0;
  return idCount++;
}
