#include "./texture.hpp"
#include <cstring>
#include <stdexcept>
#include <fmt/core.h>
#include <cstdio>
#include "stb_image.h"

Texture::Texture(unsigned int width, unsigned int height, uint8_t channels)
    : m_width(width),
      m_height(height),
      m_channels(channels),
      m_data(std::make_unique<uint8_t[]>(width * height * channels)) {}

Texture::Texture(
    unsigned int width, unsigned int height, uint8_t channels,
    const std::span<const uint8_t> data)
    : m_width(width),
      m_height(height),
      m_channels(channels),
      m_data(std::make_unique<uint8_t[]>(width * height * channels)) {
  memcpy(m_data.get(), data.data(), getTextureSize());
}

Texture::Texture(const Texture& other)
    : m_width(other.m_width),
      m_height(other.m_height),
      m_channels(other.m_channels),
      m_data(std::make_unique<uint8_t[]>(other.getTextureSize())) {
  memcpy(m_data.get(), other.m_data.get(), getTextureSize());
}

Texture& Texture::operator=(const Texture& other) {
  m_width = other.m_width;
  m_height = other.m_height;
  m_channels = other.m_channels;
  m_data = std::make_unique<uint8_t[]>(getTextureSize());
  memcpy(m_data.get(), other.m_data.get(), getTextureSize());
  return *this;
}

unsigned int Texture::getWidth() const {
  return m_width;
}

unsigned int Texture::getHeight() const {
  return m_height;
}

uint8_t Texture::getChannelCount() const {
  return m_channels;
}

const std::span<uint8_t> Texture::getTextureData() const {
  return {m_data.get(), getTextureSize()};
}

unsigned int Texture::getTextureSize() const {
  return m_width * m_height * m_channels;
}

const std::span<uint8_t> Texture::at(unsigned int x, unsigned int y) {
  if(x >= m_width || y >= m_height) {
    throw std::out_of_range("Tried to index Texture data out of range");
  }
  // NOLINTBEGIN(cppcoreguidelines-pro-bounds-pointer-arithmetic)
  auto begin = m_data.get() + y * getWidth() * m_channels + x * m_channels;
  auto end = begin + m_channels;
  // NOLINTEND(cppcoreguidelines-pro-bounds-pointer-arithmetic)
  return {begin, end};
}

const std::span<const uint8_t> Texture::at(unsigned int x, unsigned int y) const {
  if(x >= m_width || y >= m_height) {
    throw std::out_of_range("Tried to index Texture data out of range");
  }
  // NOLINTBEGIN(cppcoreguidelines-pro-bounds-pointer-arithmetic)
  auto begin = m_data.get() + y * getWidth() * m_channels + x * m_channels;
  auto end = begin + m_channels;
  // NOLINTEND(cppcoreguidelines-pro-bounds-pointer-arithmetic)
  return {begin, end};
}

Texture Texture::expandToRGBA() const {
  auto srcChannels = getChannelCount();
  if(srcChannels == 4) {
    return *this;
  }
  Texture resultTexture(getWidth(), getHeight(), 4);
  for(auto y = 0; y < getHeight(); y++) {
    for(auto x = 0; x < getWidth(); x++) {
      auto destData = resultTexture.at(x, y);
      auto srcData = at(x, y);
      switch(srcChannels) {
      case 1:
        destData[0] = srcData[0];
        destData[1] = srcData[0];
        destData[2] = srcData[0];
        destData[3] = 255;
        break;
      case 2:
        destData[0] = srcData[0];
        destData[1] = srcData[0];
        destData[2] = srcData[0];
        destData[3] = srcData[1];
        break;
      case 3:
        destData[0] = srcData[0];
        destData[1] = srcData[1];
        destData[2] = srcData[2];
        destData[3] = 255;
        break;
      default:
        destData[0] = srcData[0];
        destData[1] = srcData[1];
        destData[2] = srcData[2];
        destData[3] = srcData[3];
        break;
      }
    }
  }
  return resultTexture;
}

std::shared_ptr<Texture> loadImage(const std::string_view path) {
  int width = 0;
  int height = 0;
  int channels = 0;

  uint8_t* data = stbi_load(path.data(), &width, &height, &channels, 0);
  if(data == nullptr) {
    fmt::print(stderr, "{}\n", stbi_failure_reason());
    return nullptr;
  }

  fmt::print(
      "loaded image {}: width={}, height={}, channels={}\n", path, width, height,
      channels);

  auto texture = std::make_shared<Texture>(
      width, height, channels, std::span(data, data + (width * height * channels)));
  stbi_image_free(data);
  return texture;
}

bool exportTextureDataPPM(std::shared_ptr<Texture> data, const std::string_view path) {
  FILE* f = fopen(path.data(), "w");
  if(f == nullptr) {
    fmt::print(stderr, "Failed to open {}\n", path.data());
    return false;
  }
  {
    auto str = fmt::format("P3\n{} {}\n255\n", data->getWidth(), data->getHeight());
    fputs(str.c_str(), f);
  }

  for(unsigned int y = 0; y < data->getHeight(); y++) {
    for(unsigned int x = 0; x < data->getWidth(); x++) {
      auto pixel = data->at(x, y);
      {
        auto str = fmt::format("{} {} {}\n", pixel[0], pixel[1], pixel[2]);
        fputs(str.c_str(), f);
      }
    }
  }
  fclose(f);
  return true;
}

bool exportTextureDataPPM(
    const uint8_t* data, int width, int height, int channels,
    const std::string_view path) {
  FILE* f = fopen(path.data(), "w");
  if(f == nullptr) {
    fmt::print(stderr, "Failed to open {}\n", path.data());
    return false;
  }
  {
    auto str = fmt::format("P3\n{} {}\n255\n", width, height);
    fputs(str.c_str(), f);
  }

  for(unsigned int y = 0; y < height; y++) {
    for(unsigned int x = 0; x < width; x++) {
      auto pixel = data + (y * width + x) * channels;
      {
        auto str = fmt::format("{} {} {}\n", pixel[0], pixel[1], pixel[2]);
        fputs(str.c_str(), f);
      }
    }
  }
  fclose(f);
  return true;
}
