#include <optional>
#include <vector>
#include <fmt/core.h>
#include <cstdio>
#include <fontconfig/fontconfig.h>
#include "gl/shader.hpp"
#include "ui/glfw.hpp"
#include "./ui/Window.hpp"
#include "gl/shadercompiler.hpp"
#include "gl/vao.hpp"
#include "shader/simple_vert.hpp"
#include "shader/simple_frag.hpp"

std::optional<std::string> getMonospaceFont() noexcept {
  FcConfig* config = FcInitLoadConfigAndFonts();
  if(config == NULL) {
    return std::nullopt;
  }
  FcPattern* pattern = FcNameParse(reinterpret_cast<const FcChar8*>("mono"));
  FcConfigSubstitute(config, pattern, FcMatchPattern);
  FcDefaultSubstitute(pattern);

  FcResult res;

  FcPattern* font = FcFontMatch(config, pattern, &res);

  if(font == NULL) {
    FcPatternDestroy(pattern);
    FcConfigDestroy(config);
    FcFini();
    return std::nullopt;
  }

  FcChar8* filepath_pointer;
  if(FcPatternGetString(font, FC_FILE, 0, &filepath_pointer) != FcResultMatch) {
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

  std::string result = reinterpret_cast<const char*>(filepath_pointer);

  FcPatternDestroy(font);
  FcPatternDestroy(pattern);
  FcConfigDestroy(config);
  FcFini();

  return std::make_optional(std::move(result));
}

int main(int argc, const char* argv[]) {

  if(!GLFW::initialize()) {
    fmt::print(stderr, "Failed to initialize GLFW\n");
    return 2;
  }
  auto monospaceFontPath = getMonospaceFont();
  if(!monospaceFontPath.has_value()) {
    fmt::print(stderr, "No valid monospace font found!\n");
    return 2;
  }
  fmt::print("{}\n", monospaceFontPath.value());

  glfwSetErrorCallback([](int errorCode, const char* errorMsg) {
    fmt::print(stderr, "[GLFW {}] {}\n", errorCode, errorMsg);
  });

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);

  Window& window = Window::createInstance(800, 600, "ZEN");

  window.makeContextCurrent();

  int version = gladLoadGLLoader((GLADloadproc) glfwGetProcAddress);

  if(version == 0) {
    fmt::print(stderr, "Failed to load OpenGL context\n");
    return 2;
  }

  const char* glVersion = (const char*) glGetString(GL_VERSION);
  fmt::print("OpenGL {:s}\n", glVersion);

  glfwSwapInterval(1);

  const float vertices[] = {
      // clang-format off
      // position     color
      -0.5f, -0.5f,   0.0f, 0.0f, 1.0f,
      0.5f,  -0.5f,   0.0f, 1.0f, 0.0f,
      0.5f,   0.5f,   1.0f, 1.0f, 0.0f,
      -0.5f,   0.5f,  1.0f, 0.0f, 0.0f,
      // clang-format on
  };

  const unsigned int indicies[] = {
      // clang-format off
      0, 1, 2,
      2, 3, 0
      // clang-format on
  };

  GLShaderCompiler shaderCompiler;

  GLShaderCompiler::CompilationStatus compileStatus;

  if(!(compileStatus =
           shaderCompiler.compile(GL_VERTEX_SHADER, embed_shader_simple_vertex))) {
    fmt::print(stderr, "Vertex shader compilation failed!\n{}\n", compileStatus.infoLog);
    return 2;
  }

  if(!(compileStatus =
           shaderCompiler.compile(GL_FRAGMENT_SHADER, embed_shader_simple_frag))) {
    fmt::print(
        stderr, "Fragment shader compilation failed!\n{}\n", compileStatus.infoLog);
    return 2;
  }

  auto shaderProgram = shaderCompiler.link();

  if(!shaderProgram) {
    fmt::print(stderr, "Failed to link shader program!\n");
    return 2;
  }

  const GLint positionAttribLoc = 0;
  const GLint colorAttribLoc = 1;

  GLVertexArray vertexArray;
  vertexArray.bind();
  vertexArray.uploadDataBuffer(vertices, sizeof(vertices), GL_STATIC_DRAW);
  vertexArray.uploadIndexBuffer(indicies, sizeof(indicies), GL_STATIC_DRAW);

  vertexArray.enableAttrib(positionAttribLoc);
  vertexArray.vertexAttribFormat(
      positionAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0);

  vertexArray.enableAttrib(colorAttribLoc);
  vertexArray.vertexAttribFormat(
      colorAttribLoc, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, sizeof(float) * 2);

  glBindVertexArray(0);

  while(!window.shouldClose()) {
    glClear(GL_COLOR_BUFFER_BIT);

    shaderProgram->use();
    vertexArray.bind();
    GLCall(glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nullptr));

    window.swapBuffers();
    glfwPollEvents();
  }

  return 0;
}
