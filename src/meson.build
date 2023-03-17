executable('zen',
  'main.cpp',
  'ui/window.cpp',
  'gl/glad/glad.c',
  'gl/shader.cpp',
  'stb_image.c',
  'lib/glfw/glfw.cpp',
  'gl/renderer.cpp',
  'render/texture.cpp',
  dependencies: [
    opengl_dependencies,
    libGLFW,
    libfmt,
    libglm,
    libfontconfig,
    libfreetype
  ],
  include_directories: [
    include_directories('include'),
    include_directories('pch')
  ],
  cpp_pch: 'pch/pch.hpp'
)
