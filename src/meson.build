zen_exe = executable('zen',
  'main.cpp',
  'ui/window.cpp',
  'render/glad/glad.c',
  'render/glshader.cpp',
  'stb_image.c',
  'lib/glfw.cpp',
  'render/glrenderer.cpp',
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
  cpp_pch: 'pch/pch.hpp',
  install: true
)
