#ifndef RENDER_TEXTURE_H
#define RENDER_TEXTURE_H

#include <span>
#include <memory>
#include <cstdint>

namespace render {

/// Container for storing pixel data.
class Texture {
  public:

  /// Constructs an empty Texture.
  Texture(size_t width, size_t height, uint8_t channels);

  /// Constructs a Texture from existing pixel data.
  /// Resulting Texture class holds a copy of provided data.
  ///
  /// @param width texture width
  /// @param height texture height
  /// @param channels number of source data channels
  /// @param data source data
  Texture(
      size_t width, size_t height, uint8_t channels, const std::span<const uint8_t> data);

  // NOTE: This might be useful
  // Texture(size_t width, size_t height, uint8_t channels, const std::span<uint8_t[]>&&
  // data);

  // NOTE: Consider implementing this function
  // void combine(const Texture& source, size_t sourceX, size_t sourceY, size_t
  // regionWidth, size_t regionHeight);

  /// \{
  explicit Texture(const Texture&);
  Texture& operator=(const Texture&);
  /// \}

  /// \{
  Texture(Texture&&) = default;
  Texture& operator=(Texture&&) = default;
  /// \}
  ~Texture() = default;

  /// Get texture width.
  [[nodiscard]] size_t getWidth() const;

  /// Get texture height.
  [[nodiscard]] size_t getHeight() const;

  /// Get texture channel count.
  [[nodiscard]] uint8_t getChannelCount() const;

  /// Get texture size in bytes.
  [[nodiscard]] size_t getTextureSize() const;

  /// Get texture data.
  [[nodiscard]] const std::span<uint8_t> getTextureData() const;

  /// Access a single pixel.
  /// \{
  [[nodiscard]] const std::span<uint8_t> at(size_t x, size_t y);
  [[nodiscard]] const std::span<const uint8_t> at(size_t x, size_t y) const;
  /// \}

  private:
  size_t m_width;
  size_t m_height;
  uint8_t m_channels;
  std::unique_ptr<uint8_t[]> m_data;
};

} // namespace render

#endif
