#include <cstddef>
#include <cstdint>
#include <optional>
#include <vector>
#include <fmt/core.h>
#include <cstdio>
#include <memory>
#include <fontconfig/fontconfig.h>
#include <ft2build.h>
#include <freetype/freetype.h>

#include "gl/gl.hpp"
#include "gl/shader.hpp"
#include "ui/window.hpp"
#include "gl/shadercompiler.hpp"
#include "gl/vao.hpp"
#include "shader/simple_vert.hpp"
#include "shader/simple_frag.hpp"
#include "lib/glfw/glfw.hpp"
#include <glm/vec2.hpp>
#include <glm/vec4.hpp>

#include <GLFW/glfw3.h>

std::optional<std::string> getMonospaceFont() noexcept {
  FcConfig* config = FcInitLoadConfigAndFonts();
  if(config == nullptr) {
    return std::nullopt;
  }

  // reinterpret_cast is required for conversion of FcChar8 (unsigned char) <-> char
  FcPattern* pattern = FcNameParse(reinterpret_cast<const FcChar8*>("mono"));
  FcConfigSubstitute(config, pattern, FcMatchPattern);
  FcDefaultSubstitute(pattern);

  FcResult res{};
  FcPattern* font = FcFontMatch(config, pattern, &res);

  if(font == nullptr) {
    FcPatternDestroy(pattern);
    FcConfigDestroy(config);
    FcFini();
    return std::nullopt;
  }

  FcChar8* filepathPointer = nullptr;
  if(FcPatternGetString(font, FC_FILE, 0, &filepathPointer) != FcResultMatch) {
    /// ??? There should be at least one entry ???
    FcPatternDestroy(font);
    FcPatternDestroy(pattern);
    FcConfigDestroy(config);
    FcFini();
    fmt::print(
        stderr,
        "fontconfig found a monospace font without a filename! most likely a bug!\n");
    return std::nullopt;
  }

  std::string result = reinterpret_cast<const char*>(filepathPointer);

  FcPatternDestroy(font);
  FcPatternDestroy(pattern);
  FcConfigDestroy(config);
  FcFini();

  return std::make_optional(std::move(result));
}

struct Vertex {
  glm::vec2 position{};
  glm::vec4 color{};
  float textureSlot{};
  glm::vec2 textureOffset{};

  Vertex(glm::vec2 pos, glm::vec4 c, float tSlot, glm::vec2 tOff)
      : position(pos),
        color(c),
        textureSlot(tSlot),
        textureOffset(tOff) {}
};

class Renderer {
  public:

  void submitQuad(const glm::vec2 position, const glm::vec2 size, const glm::vec4 color) {

    m_dataBuffer.emplace_back(position, color, 0.0f, glm::vec2());
    m_dataBuffer.emplace_back(
        position + glm::vec2(size.x, 0.0f), color, 0.0f, glm::vec2());
    m_dataBuffer.emplace_back(
        position + glm::vec2(size.x, -size.y), color, 0.0f, glm::vec2());
    m_dataBuffer.emplace_back(
        position - glm::vec2(0.0f, size.y), color, 0.0f, glm::vec2());

    const uint32_t kIndexCount = (m_indexBuffer.size() / 6) * 4;
    m_indexBuffer.push_back(kIndexCount + 0);
    m_indexBuffer.push_back(kIndexCount + 1);
    m_indexBuffer.push_back(kIndexCount + 2);
    m_indexBuffer.push_back(kIndexCount + 2);
    m_indexBuffer.push_back(kIndexCount + 3);
    m_indexBuffer.push_back(kIndexCount + 0);
  }

  void submitFrame(ui::Window& window, GLShaderProgram& program, GLVertexArray& vao) {
    vao.uploadDataBuffer(
        m_dataBuffer.data(),
        static_cast<GLsizeiptr>(m_dataBuffer.size() * sizeof(Vertex)), GL_DYNAMIC_DRAW);
    vao.uploadIndexBuffer(
        m_indexBuffer.data(),
        static_cast<GLsizeiptr>(m_indexBuffer.size() * sizeof(uint32_t)),
        GL_DYNAMIC_DRAW);
    program.use();
    vao.bind();
    GLCall(glDrawElements(GL_TRIANGLES, m_indexBuffer.size(), GL_UNSIGNED_INT, nullptr));
  }

  private:
  std::vector<Vertex> m_dataBuffer;
  std::vector<uint32_t> m_indexBuffer;
};

// TODO: break up this behemoth of a function
int main(int argc, const char* argv[]) {

  glfw::GLFWLibrary glfwLibrary;

  auto monospaceFontPath = getMonospaceFont();
  if(!monospaceFontPath.has_value()) {
    fmt::print(stderr, "No valid monospace font found!\n");
    return 2;
  }
  fmt::print("{}\n", monospaceFontPath.value());

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);

  auto window = ui::Window::create(800, 600, "zen");
  if(!window.has_value()) {
    fmt::print(stderr, "Failed to create window: {}", glfwGetError(nullptr));
    return 2;
  }

  window->makeCurrent();

  const int kVersion =
      gladLoadGLLoader(reinterpret_cast<GLADloadproc>(glfwGetProcAddress));

  if(kVersion == 0) {
    fmt::print(stderr, "Failed to load OpenGL context\n");
    return 2;
  }
  fmt::print("GLFW {:s}\n", glfwGetVersionString());
  // unsigned char* -> char*
  fmt::print("OpenGL {:s}\n", reinterpret_cast<const char*>(glGetString(GL_VERSION)));

  glfwSwapInterval(1);

  GLShaderCompiler shaderCompiler;

  if(!shaderCompiler.compile(GL_VERTEX_SHADER, kEmbedShaderSimpleVertex)) {
    fmt::print(
        stderr, "Vertex shader compilation failed!\n{}\n", shaderCompiler.getInfoLog());
    return 2;
  }

  if(!shaderCompiler.compile(GL_FRAGMENT_SHADER, kEmbedShaderSimpleFrag)) {
    fmt::print(
        stderr, "Fragment shader compilation failed!\n{}\n", shaderCompiler.getInfoLog());
    return 2;
  }

  auto shaderProgram = shaderCompiler.link();

  if(!shaderProgram) {
    fmt::print(
        stderr, "Failed to link shader program!\n{}\n", shaderCompiler.getInfoLog());
    return 2;
  }

  const GLint kPositionAttribLoc = 0;
  const GLint kColorAttribLoc = 1;

  GLVertexArray vertexArray;

  vertexArray.enableAttrib(kPositionAttribLoc);
  vertexArray.vertexAttribFormat(
      kPositionAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),
      offsetof(Vertex, position));

  vertexArray.enableAttrib(kColorAttribLoc);
  vertexArray.vertexAttribFormat(
      kColorAttribLoc, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, color));

  glBindVertexArray(0);
  Renderer renderer;

  renderer.submitQuad({-0.9f, .9f}, {1.0f, 1.0f}, {1.0f, .0f, .0f, 0.5f});
  renderer.submitQuad({-0.1f, 0.1f}, {1.0f, 1.5f}, {0.0f, 1.0f, .0f, 0.5f});

  while(!window->shouldClose()) {
    glClear(GL_COLOR_BUFFER_BIT);

    renderer.submitFrame(window.value(), shaderProgram.value(), vertexArray);

    glfwSwapBuffers(window->getHandle());
    glfwPollEvents();
  }

  return 0;
}
