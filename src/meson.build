executable('zen',
  'main.cpp',
  'ui/Window.cpp',
  'gl/glad/glad.c',
  'gl/shader.cpp',
  'gl/shadercompiler.cpp',
  'gl/vao.cpp',
  'stb_image.c',
  'lib/glfw/glfw.cpp',
  dependencies: [
    opengl_dependencies,
    libGLFW,
    libfmt,
    libglm,
    libfontconfig,
    libfreetype
  ],
  include_directories: [
    include_directories('include')
  ],
  cpp_pch: 'pch/pch.hpp'
)
