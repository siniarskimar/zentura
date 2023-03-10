#include "./renderer.hpp"
#include <GLFW/glfw3.h>
#include <optional>
#include "shader/simple_vert.hpp"
#include "shader/simple_frag.hpp"
#include <stdexcept>

namespace render {

GLRenderer::GLRenderer() {
  constexpr int kPositionAttribLoc = 0;
  constexpr int kColorAttribLoc = 1;

  auto quadProgram =
      GLShaderProgram::compile(kEmbedShaderSimpleVertex, kEmbedShaderSimpleFrag);

  if(!quadProgram.has_value()) {
    throw std::runtime_error("Could not compile shader");
  }
  m_quadProgram = std::move(quadProgram.value());

  m_vao.enableAttrib(kPositionAttribLoc);
  m_vao.vertexAttribFormat(
      kPositionAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      offsetof(Vertex, position));

  m_vao.enableAttrib(kColorAttribLoc);
  m_vao.vertexAttribFormat(
      kColorAttribLoc, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, color));
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

} // namespace render
