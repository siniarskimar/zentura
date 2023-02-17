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
#include <glm/ext/matrix_clip_space.hpp>
#include "gl/renderer.hpp"

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

  render::GLRenderer renderer;

  while(!window->shouldClose()) {
    glClear(GL_COLOR_BUFFER_BIT);

    renderer.submitQuad({-0.9f, .9f, 0.0f}, {1.0f, 1.0f}, {1.0f, .0f, .0f, 0.5f});
    renderer.submitQuad({-0.1f, 0.1f, 0.0f}, {1.0f, 1.5f}, {0.0f, 1.0f, .0f, 0.5f});
    renderer.renderFrame(shaderProgram.value());

    glfwSwapBuffers(window->getHandle());
    glfwPollEvents();
  }

  return 0;
}
