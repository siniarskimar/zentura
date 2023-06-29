/// @file

#include <cstddef>
#include <cstdint>
#include <optional>
#include <fmt/core.h>
#include <cstdio>
#include <memory>
#include <fontconfig/fontconfig.h>
#include <freetype/freetype.h>
#include <iostream>

#include "render/glrenderer.hpp"
#include "render/window.hpp"
#include <SDL.h>

#if SDL_MAJOR_VERSION < 2
#error "SDL2 is required!"
#endif

/// Get the path of systems default monospace font.
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

/// Wrapper class over SDL_Init and SDL_Quit
struct SDLContext {
  SDLContext() : m_ok(SDL_Init(SDL_INIT_VIDEO) == 0) {}

  SDLContext(const SDLContext&) = delete;
  SDLContext& operator=(const SDLContext&) = delete;

  ~SDLContext() {
    SDL_Quit();
  }

  [[nodiscard]] inline bool isOk() const noexcept {
    return m_ok;
  }

  private:
  bool m_ok{};
};

int main(int /*argc*/, const char* /*argv*/[]) {
  SDLContext sdlContext;
  if(!sdlContext.isOk()) {
    fmt::print(stderr, "Failed to initialize SDL2: {}", SDL_GetError());
    return 2;
  }

  auto monospaceFontPath = getMonospaceFont();
  if(!monospaceFontPath.has_value()) {
    fmt::print(stderr, "No valid monospace font found!\n");
    return 2;
  }
  fmt::print("{}\n", monospaceFontPath.value());

  auto createWindowResult = createWindow(800, 600, "zen");
  if(!createWindowResult.has_value()) {
    fmt::print(stderr, "Failed to create window: {}", createWindowResult.error());
    return 2;
  }

  Window window = std::move(createWindowResult.value());
  GLRenderer renderer(window);
  TextureData textureData1(0, 0, 1);
  TextureData textureData2(0, 0, 1);

  {
    auto texture = loadImage("share/zen/test_image_grayscale.png");

    if(!texture.has_value()) {
      fmt::print(stderr, "Failed to load 'share/zen/test_image_grayscale.png'\n");
      return 2;
    }
    textureData1 = std::move(texture.value());
  }

  {
    auto texture = loadImage("share/zen/test_image.jpg");

    if(!texture.has_value()) {
      fmt::print(stderr, "Failed to load 'share/zen/test_image.jpg'\n");
      return 2;
    }
    textureData2 = std::move(texture.value());
  }

  textureData1 = textureData1.expandToRGBA();
  auto texture1 = renderer.newTexture(textureData1);
  auto texture2 = renderer.newTexture(textureData2);

  SDL_StartTextInput();
  while(!window.shouldClose()) {
    SDL_Event ev;
    while(SDL_PollEvent(&ev) != 0) {
      switch(ev.type) {
      case SDL_WINDOWEVENT:
        switch(ev.window.event) {
        case SDL_WINDOWEVENT_CLOSE:
          window.notifyClose();
          break;
        default:
          break;
        }
        break;
      case SDL_QUIT:
        window.notifyClose();
        break;
      case SDL_TEXTINPUT:
        fmt::print("{}", ev.text.text);
        std::cout.flush();
        break;
      case SDL_KEYDOWN:
        switch(ev.key.keysym.sym) {
        case SDLK_RETURN:
          fmt::print("\n");
          break;
        }
      }
    }
    renderer.clearFramebuffer();

    renderer.submitTexturedQuad({-1.0f, 1.0f, 0.0f}, {1.0f, 1.0f}, texture1);
    renderer.submitTexturedQuad({-1.0f, 0.0f, 0.0f}, {1.0f, 1.0f}, texture2);

    renderer.flush();
    renderer.swapWindowBuffers();
  }
  SDL_StopTextInput();

  return 0;
}
