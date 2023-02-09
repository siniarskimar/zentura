#include <optional>
#include <vector>
#include <fmt/core.h>
#include <cstdio>
#include <memory>
#include <fontconfig/fontconfig.h>
#include <ft2build.h>
#include <freetype/freetype.h>

#include "gl/shader.hpp"
#include "ui/glfw.hpp"
#include "./ui/Window.hpp"
#include "gl/shadercompiler.hpp"
#include "gl/vao.hpp"
#include "shader/simple_vert.hpp"
#include "shader/simple_frag.hpp"

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

// TODO: break up this behemoth of a function
int main(int argc, const char* argv[]) {

  if(!GLFW::initialize()) {
    fmt::print(stderr, "Failed to initialize GLFW\n");
    return 2;
  }

  glfwSetErrorCallback([](int errorCode, const char* errorMsg) {
    fmt::print(stderr, "[GLFW {}] {}\n", errorCode, errorMsg);
  });

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

  Window& window = Window::createInstance(800, 600, "ZEN");

  window.makeContextCurrent();

  int version = gladLoadGLLoader(reinterpret_cast<GLADloadproc>(glfwGetProcAddress));

  if(version == 0) {
    fmt::print(stderr, "Failed to load OpenGL context\n");
    return 2;
  }

  // unsigned char* -> char*
  fmt::print("OpenGL {:s}\n", reinterpret_cast<const char*>(glGetString(GL_VERSION)));

  glfwSwapInterval(1);

  const float VERTICES[] = {
      // clang-format off
      // position     color
      -0.5f, -0.5f,   0.0f, 0.0f, 1.0f,
      0.5f,  -0.5f,   0.0f, 1.0f, 0.0f,
      0.5f,   0.5f,   1.0f, 1.0f, 0.0f,
      -0.5f,   0.5f,  1.0f, 0.0f, 0.0f,
      // clang-format on
  };

  const unsigned int INDICIES[] = {
      // clang-format off
      0, 1, 2,
      2, 3, 0
      // clang-format on
  };

  GLShaderCompiler shaderCompiler;

  GLShaderCompiler::CompilationStatus compileStatus;

  if(!(compileStatus =
           shaderCompiler.compile(GL_VERTEX_SHADER, EMBED_SHADER_SIMPLE_VERTEX))) {
    fmt::print(stderr, "Vertex shader compilation failed!\n{}\n", compileStatus.infoLog);
    return 2;
  }

  if(!(compileStatus =
           shaderCompiler.compile(GL_FRAGMENT_SHADER, EMBED_SHADER_SIMPLE_FRAG))) {
    fmt::print(
        stderr, "Fragment shader compilation failed!\n{}\n", compileStatus.infoLog);
    return 2;
  }

  auto shaderProgram = shaderCompiler.link();

  if(!shaderProgram) {
    fmt::print(stderr, "Failed to link shader program!\n");
    return 2;
  }

  const GLint POSITION_ATTRIB_LOC = 0;
  const GLint COLOR_ATTRIB_LOC = 1;

  GLVertexArray vertexArray;
  vertexArray.bind();
  vertexArray.uploadDataBuffer(
      static_cast<const void*>(VERTICES), sizeof(VERTICES), GL_STATIC_DRAW);
  vertexArray.uploadIndexBuffer(
      static_cast<const void*>(INDICIES), sizeof(INDICIES), GL_STATIC_DRAW);

  vertexArray.enableAttrib(POSITION_ATTRIB_LOC);
  vertexArray.vertexAttribFormat(
      POSITION_ATTRIB_LOC, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0);

  vertexArray.enableAttrib(COLOR_ATTRIB_LOC);
  vertexArray.vertexAttribFormat(
      COLOR_ATTRIB_LOC, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, sizeof(float) * 2);

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
