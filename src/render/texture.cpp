#include "./texture.hpp"
#include <cstring>
#include <stdexcept>

namespace render {
Texture::Texture(size_t width, size_t height, const std::span<uint32_t> data)
    : m_width(width),
      m_height(height),
      m_data(std::make_unique<uint32_t[]>(width * height)) {
  if(data.size() < width * height) {
    // TODO: Think of a better message
    throw std::logic_error(
        "Tried to construct a Texture object bigger than the provided data");
  }
  memcpy(m_data.get(), data.data(), m_width * m_height);
}

Texture::Texture(const Texture& other)
    : m_width(other.m_width),
      m_height(other.m_height),
      m_data(std::make_unique<uint32_t[]>(other.m_width * other.m_height)) {
  memcpy(m_data.get(), other.m_data.get(), m_width * m_height);
}

Texture& Texture::operator=(const Texture& other) {
  m_width = other.m_width;
  m_height = other.m_height;
  m_data.reset();
  m_data = std::make_unique<uint32_t[]>(other.m_width * other.m_height);
  memcpy(m_data.get(), other.m_data.get(), m_width * m_height);
  return *this;
}

size_t Texture::getWidth() const {
  return m_width;
}

size_t Texture::getHeight() const {
  return m_height;
}

const std::span<uint32_t> Texture::getTextureData() const {
  return {m_data.get(), m_width * m_height};
}

uint32_t Texture::samplePixel(size_t x, size_t y) const {
  if(x >= m_width || y >= m_height) {
    throw std::out_of_range("Tried to index Texture data out of range");
  }
  return m_data[m_width * y + x];
}

void Texture::setPixel(size_t x, size_t y, uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
  setPixel(
      x, y,
      (static_cast<uint32_t>(r) << 24) | (static_cast<uint32_t>(g) << 16) |
          (static_cast<uint32_t>(b) << 8) | static_cast<uint32_t>(a));
}

void Texture::setPixel(size_t x, size_t y, uint32_t pixel) {
  if(x >= m_width || y >= m_height) {
    throw std::out_of_range("Tried to index Texture data out of range");
  }
  m_data[m_width * y + x] = pixel;
}
} // namespace render
