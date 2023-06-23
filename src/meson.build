zen_exe = executable('zen',
  'main.cpp',
  'render/window.cpp',
  'render/glshader.cpp',
  'render/glrenderer.cpp',
  'render/texturedata.cpp',
  dependencies: [
    opengl_dependencies,
    libSDL2,
    libfmt,
    libglm,
    libfontconfig,
    libfreetype,
    libglad,
    stb_image
  ],
  include_directories: [
    include_directories('include'),
    include_directories('pch')
  ],
  cpp_pch: 'pch/pch.hpp',
  install: true
)
