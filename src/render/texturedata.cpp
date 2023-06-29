#include "./texturedata.hpp"
#include <cstring>
#include <stdexcept>
#include <fmt/core.h>
#include <fmt/ostream.h>
#include <cstdio>
#include <fstream>
#include <limits>
#include <cassert>
#include "stb_image.h"

TextureData::TextureData(unsigned int width, unsigned int height, uint8_t channels)
    : m_width(width),
      m_height(height),
      m_channels(channels),
      m_data(
          std::make_unique<uint8_t[]>(static_cast<size_t>(width) * height * channels)) {}

TextureData::TextureData(
    unsigned int width, unsigned int height, uint8_t channels,
    const std::span<const uint8_t>& data)
    : m_width(width),
      m_height(height),
      m_channels(channels),
      m_data(
          std::make_unique<uint8_t[]>(static_cast<size_t>(width) * height * channels)) {
  memcpy(m_data.get(), data.data(), getTextureSize());
}

TextureData::TextureData(const TextureData& other)
    : m_width(other.m_width),
      m_height(other.m_height),
      m_channels(other.m_channels),
      m_data(std::make_unique<uint8_t[]>(other.getTextureSize())) {
  memcpy(m_data.get(), other.m_data.get(), getTextureSize());
}

TextureData& TextureData::operator=(const TextureData& other) {
  m_width = other.m_width;
  m_height = other.m_height;
  m_channels = other.m_channels;
  m_data = std::make_unique<uint8_t[]>(getTextureSize());
  memcpy(m_data.get(), other.m_data.get(), getTextureSize());
  return *this;
}

unsigned int TextureData::getWidth() const {
  return m_width;
}

unsigned int TextureData::getHeight() const {
  return m_height;
}

uint8_t TextureData::getChannelCount() const {
  return m_channels;
}

std::span<uint8_t> TextureData::getTextureData() const {
  return {m_data.get(), getTextureSize()};
}

unsigned int TextureData::getTextureSize() const {
  return m_width * m_height * m_channels;
}

std::span<uint8_t> TextureData::at(unsigned int x, unsigned int y) {
  if(x >= m_width || y >= m_height) {
    throw std::out_of_range("Tried to index Texture data out of range");
  }
  const auto offset = y * getWidth() * m_channels + x * m_channels;
  return std::span(m_data.get(), getTextureSize()).subspan(offset, m_channels);
}

std::span<const uint8_t> TextureData::at(unsigned int x, unsigned int y) const {
  if(x >= m_width || y >= m_height) {
    throw std::out_of_range("Tried to index Texture data out of range");
  }
  const auto offset = y * getWidth() * m_channels + x * m_channels;
  return std::span(m_data.get(), getTextureSize()).subspan(offset, m_channels);
}

TextureData TextureData::expandToRGBA() const {
  auto srcChannels = getChannelCount();
  if(srcChannels == 4) {
    return *this;
  }
  TextureData resultTexture(getWidth(), getHeight(), 4);
  for(unsigned int y = 0; y < getHeight(); y++) {
    for(unsigned int x = 0; x < getWidth(); x++) {
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

std::optional<TextureData> loadImage(const std::string_view& path) {
  int width = 0;
  int height = 0;
  int channels = 0;

  uint8_t* data = stbi_load(path.data(), &width, &height, &channels, 0);
  if(data == nullptr) {
    fmt::print(stderr, "{}\n", stbi_failure_reason());
    return std::nullopt;
  }

  TextureData texture(
      width, height, channels,
      std::span(data, static_cast<size_t>(width) * height * channels));
  stbi_image_free(data);
  return texture;
}

bool exportTextureDataPPM(
    std::shared_ptr<TextureData> data, const std::string_view& path) {
  const auto width = data->getWidth();
  const auto height = data->getHeight();
  const auto channels = data->getChannelCount();
  constexpr auto intMax = std::numeric_limits<int>::max();

  if(width > intMax) {
    throw std::runtime_error(
        "exportTextureDataPPM(TextureData): width is outside of signed int range");
  }
  if(height > intMax) {
    throw std::runtime_error(
        "exportTextureDataPPM(TextureData): height is outside of signed int range");
  }

  return exportTextureDataPPM(
      data->getTextureData(), static_cast<int>(width), static_cast<int>(height), channels,
      path);
}

bool exportTextureDataPPM(
    const std::span<const uint8_t>& data, int width, int height, int channels,
    const std::string_view& path) {

  if(width < 0) {
    throw std::runtime_error("exportTextureDataPPM(span): width is negative");
  }

  if(height < 0) {
    throw std::runtime_error("exportTextureDataPPM(span): height is negative");
  }

  if(channels > 4) {
    //  NOTE: this could just be an error message
    throw std::runtime_error(
        "exportTextureDataPPM(span): can't deal with more than 4 channels");
  }

  std::ofstream file(path.data(), std::ios::binary | std::ios::out);
  if(!file.is_open()) {
    fmt::print(stderr, "Failed to open {}\n", path.data());
    return false;
  }
  const int version = channels == 4 ? 6 : channels + 3;

  fmt::print(file, "P{}\n{} {}\n255\n", version, width, height);

  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      auto pixel =
          data.subspan((static_cast<size_t>(y) * width + x) * channels, channels);

      file.write(reinterpret_cast<const char*>(pixel.data()), version - 3);
    }
  }
  return true;
}
