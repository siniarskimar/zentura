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
#include "gl/vao.hpp"
#include "shader/simple_vert.hpp"
#include "shader/simple_frag.hpp"
#include "lib/glfw/glfw.hpp"
#include <glm/vec2.hpp>
#include <glm/vec4.hpp>
#include <glm/ext/matrix_clip_space.hpp>
#include "gl/renderer.hpp"

#include <GLFW/glfw3.h>

/// @brief Gets the path of systems default monospace font
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

  auto window = ui::Window::create(800, 600, "zen");
  if(!window.has_value()) {
    fmt::print(stderr, "Failed to create window: {}", glfwGetError(nullptr));
    return 2;
  }
  window->runLoop();

  return 0;
}
