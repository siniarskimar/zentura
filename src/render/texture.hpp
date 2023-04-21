/// @file
#ifndef RENDER_TEXTURE_H
#define RENDER_TEXTURE_H

#include <span>
#include <memory>
#include <cstdint>

/// Container for storing pixel data.
class TextureData {
  public:

  /// Constructs an empty Texture.
  TextureData(unsigned int width, unsigned int height, uint8_t channels);

  /// Constructs a Texture from existing pixel data.
  /// Resulting Texture class holds a copy of provided data.
  ///
  /// @param width texture width
  /// @param height texture height
  /// @param channels number of source data channels
  /// @param data source data
  TextureData(
      unsigned int width, unsigned int height, uint8_t channels,
      const std::span<const uint8_t> data);

  /// \{
  TextureData(const TextureData&);
  TextureData& operator=(const TextureData&);
  /// \}

  /// \{
  TextureData(TextureData&&) = default;
  TextureData& operator=(TextureData&&) = default;
  /// \}
  ~TextureData() = default;

  [[nodiscard]] TextureData expandToRGBA() const;

  /// Get texture width.
  [[nodiscard]] unsigned int getWidth() const;

  /// Get texture height.
  [[nodiscard]] unsigned int getHeight() const;

  /// Get texture channel count.
  [[nodiscard]] uint8_t getChannelCount() const;

  /// Get texture size in bytes.
  [[nodiscard]] unsigned int getTextureSize() const;

  /// Get texture data.
  [[nodiscard]] const std::span<uint8_t> getTextureData() const;

  /// Access a single pixel.
  /// \{
  [[nodiscard]] const std::span<uint8_t> at(unsigned int x, unsigned int y);
  [[nodiscard]] const std::span<const uint8_t> at(unsigned int x, unsigned int y) const;
  /// \}

  private:
  unsigned int m_width;
  unsigned int m_height;
  uint8_t m_channels;
  std::unique_ptr<uint8_t[]> m_data;
};

/// Loads an image from specified path
std::shared_ptr<TextureData> loadImage(const std::string_view path);

/// Exports texture data to PPM file.
bool exportTextureDataPPM(std::shared_ptr<TextureData> data, const std::string_view path);

/// Exports texture data to PPM file.
bool exportTextureDataPPM(
    const std::span<const uint8_t> data, int width, int height, int channels,
    const std::string_view path);

#endif
