#include "./texture.hpp"
#include <cstring>
#include <stdexcept>

namespace render {
Texture::Texture(size_t width, size_t height, uint8_t channels)
    : m_width(width),
      m_height(height),
      m_channels(channels),
      m_data(std::make_unique<uint8_t[]>(width * height * channels)) {}

Texture::Texture(
    size_t width, size_t height, uint8_t channels, const std::span<const uint8_t> data)
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

size_t Texture::getWidth() const {
  return m_width;
}

size_t Texture::getHeight() const {
  return m_height;
}

const std::span<uint8_t> Texture::getTextureData() const {
  return {m_data.get(), getTextureSize()};
}

size_t Texture::getTextureSize() const {
  return m_width * m_height * m_channels;
}

const std::span<uint8_t> Texture::at(size_t x, size_t y) {
  if(x >= m_width || y >= m_height) {
    throw std::out_of_range("Tried to index Texture data out of range");
  }
  // NOLINTBEGIN(cppcoreguidelines-pro-bounds-pointer-arithmetic)
  auto begin = m_data.get() + y * getWidth() * m_channels + x * m_channels;
  auto end = begin + m_channels;
  // NOLINTEND(cppcoreguidelines-pro-bounds-pointer-arithmetic)
  return {begin, end};
}

} // namespace render
