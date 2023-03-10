#include "./renderer.hpp"
#include <GLFW/glfw3.h>
#include <optional>
#include <stdexcept>

static const char* const kEmbedShaderSimpleVertex =
    R"(
#version 330 core

layout (location = 0) in vec2 position;
layout (location = 1) in vec4 color;
layout (location = 2) in float textureIndex;
layout (location = 3) in vec2 textureCoords;

out vec4 vertex_color;
out float vertex_texture;
out vec2 vertex_textureCoords;

void main() {
  gl_Position = vec4(position.xy, 0.0, 1.0);
  vertex_color = color;
  vertex_texture = textureIndex;
  
}
    
)";

static const char* const kEmbedShaderSimpleFrag =
    R"(
#version 330 core

in vec4 vertex_color;
in float vertex_texture;
in vec2 vertex_textureCoords;

uniform sampler2D textures[16];

out vec4 frag_color;

void main() {
  if(vertex_texture == 255) {
    frag_color = vertex_color;    
  } else {
    switch(int(vertex_texture)) {
      case 0: frag_color = texture(textures[0], vertex_textureCoords); break;
      case 1: frag_color = texture(textures[1], vertex_textureCoords); break;
      case 2: frag_color = texture(textures[2], vertex_textureCoords); break;
      case 3: frag_color = texture(textures[3], vertex_textureCoords); break;
      case 4: frag_color = texture(textures[4], vertex_textureCoords); break;
      case 5: frag_color = texture(textures[5], vertex_textureCoords); break;
      case 6: frag_color = texture(textures[6], vertex_textureCoords); break;
      case 7: frag_color = texture(textures[7], vertex_textureCoords); break;
      case 8: frag_color = texture(textures[8], vertex_textureCoords); break;
      case 9: frag_color = texture(textures[9], vertex_textureCoords); break;
      case 10: frag_color = texture(textures[10], vertex_textureCoords); break;
      case 11: frag_color = texture(textures[11], vertex_textureCoords); break;
      case 12: frag_color = texture(textures[12], vertex_textureCoords); break;
      case 13: frag_color = texture(textures[13], vertex_textureCoords); break;
      case 14: frag_color = texture(textures[14], vertex_textureCoords); break;
      case 15: frag_color = texture(textures[15], vertex_textureCoords); break;
    }
  }
}
    
)";

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
