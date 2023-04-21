/// @file

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

#include "render/glrenderer.hpp"
#include "ui/window.hpp"

#include "lib/glfw.hpp"
#include <glm/vec2.hpp>
#include <glm/vec4.hpp>
#include <glm/ext/matrix_clip_space.hpp>

/// Gets the path of systems default monospace font.
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

int main(int /*argc*/, const char* /*argv*/[]) {

  GLFWLibrary glfwLibrary;

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
  GLRenderer renderer(window.value());

  auto textureData1 = loadImage("share/zen/test_image_grayscale.png");
  auto textureData2 = loadImage("share/zen/test_image.jpg");
  auto textureData3 = loadImage("share/zen/marek-piwnicki-8Hd1IVrDpEc-unsplash.jpg");
  auto textureData4 = loadImage("share/zen/caleb-woods-QPm1dbfq6Vk-unsplash.jpg");
  if(textureData1 == nullptr) {
    fmt::print(stderr, "Failed to load 'share/zen/test_image_grayscale.png'\n");
    return 2;
  }
  if(textureData2 == nullptr) {
    fmt::print(stderr, "Failed to load 'share/zen/test_image.png'\n");
    return 2;
  }
  if(textureData3 == nullptr) {
    fmt::print(
        stderr, "Failed to load 'share/zen/marek-piwnicki-8Hd1IVrDpEc-unsplash.png'\n");
    return 2;
  }
  if(textureData4 == nullptr) {
    fmt::print(
        stderr, "Failed to load 'share/zen/caleb-woods-QPm1dbfq6Vk-unsplash.png'\n");
    return 2;
  }
  textureData1 = std::make_shared<TextureData>(textureData1->expandToRGBA());
  textureData2 = std::make_shared<TextureData>(textureData2->expandToRGBA());
  textureData3 = std::make_shared<TextureData>(textureData3->expandToRGBA());
  textureData4 = std::make_shared<TextureData>(textureData4->expandToRGBA());

  exportTextureDataPPM(textureData1, "out.ppm");

  auto texture1 = renderer.newTexture(textureData1);
  auto texture2 = renderer.newTexture(textureData2);
  auto texture3 = renderer.newTexture(textureData3);
  auto texture4 = renderer.newTexture(textureData4);

  while(!window->shouldClose()) {
    window->pollEvents();
    renderer.clearFramebuffer();

    renderer.submitTexturedQuad({-1.0f, 1.0f, 0.0f}, {1.0f, 1.0f}, texture1);
    renderer.submitTexturedQuad({-1.0f, 0.0f, 0.0f}, {1.0f, 1.0f}, texture2);
    renderer.submitTexturedQuad({0.0f, 1.0f, 0.0f}, {1.0f, 1.0f}, texture3);
    renderer.submitTexturedQuad({0.0f, 0.0f, 0.0f}, {1.0f, 1.0f}, texture4);

    renderer.flush();
    renderer.swapWindowBuffers();
  }

  return 0;
}
