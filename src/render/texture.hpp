#ifndef RENDER_TEXTURE_H
#define RENDER_TEXTURE_H

#include <span>
#include <memory>

namespace render {
class Texture {
  public:
  Texture(size_t width, size_t height, const std::span<uint32_t>);
  explicit Texture(const Texture&);
  Texture(Texture&&) = default;
  Texture& operator=(const Texture&);
  Texture& operator=(Texture&&) = default;
  ~Texture() = default;

  [[nodiscard]] size_t getWidth() const;
  [[nodiscard]] size_t getHeight() const;
  [[nodiscard]] const std::span<uint32_t> getTextureData() const;

  [[nodiscard]] uint32_t samplePixel(size_t x, size_t y) const;
  void setPixel(size_t x, size_t y, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
  void setPixel(size_t x, size_t y, uint32_t pixel);

  private:
  size_t m_width;
  size_t m_height;
  std::unique_ptr<uint32_t[]> m_data;
};

template <typename... Args>
inline std::shared_ptr<Texture> makeTexture(Args... args) {
  return std::make_shared<Texture>(std::forward(args...));
};
} // namespace render

#endif
