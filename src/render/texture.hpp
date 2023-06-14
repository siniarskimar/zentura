#ifndef RENDERTEXTURE_H
#define RENDERTEXTURE_H

#include <cstdint>
#include <utility>

struct Texture {
  uint32_t id;
  uint8_t channels;
  uint32_t width;
  uint32_t height;

  auto operator<=>(const Texture& r) const {
    return id <=> r.id;
  }
};

template <>
struct std::hash<Texture> {
  std::size_t operator()(const Texture& t) const {
    std::size_t ret = 0;
    ret ^= std::hash<uint32_t>{}(t.id) + 0x9e3779b9 + (ret << 6) + (ret >> 2);
    ret ^= std::hash<uint8_t>{}(t.channels) + 0x9e3779b9 + (ret << 6) + (ret >> 2);
    ret ^= std::hash<uint32_t>{}(t.width) + 0x9e3779b9 + (ret << 6) + (ret >> 2);
    ret ^= std::hash<uint32_t>{}(t.height) + 0x9e3779b9 + (ret << 6) + (ret >> 2);
    return ret;
  }
};

#endif
