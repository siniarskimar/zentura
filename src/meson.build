zen_exe = executable('zen',
  'main.cpp',
  'ui/window.cpp',
  'render/glad/glad.c',
  'render/glshader.cpp',
  'stb_image.c',
  'render/glrenderer.cpp',
  'render/texturedata.cpp',
  dependencies: [
    opengl_dependencies,
    libSDL2,
    libfmt,
    libglm,
    libfontconfig,
    libfreetype
  ],
  include_directories: [
    include_directories('include'),
    include_directories('pch')
  ],
  cpp_pch: 'pch/pch.hpp',
  install: true
)
