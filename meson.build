project('zen', ['cpp'],
  default_options: [
    'cpp_std=c++17'
  ],
  license: 'Apache-2.0',
  meson_version: '0.63.0>='
)

opengl_dependencies = []

libOpenGL = dependency('opengl', required: false)

# TODO: install glfw3 wrap and provide option to switch to use it when
#       requested
libGLFW = dependency('glfw3', required: true)

if not libOpenGL.found()
  # the 'Legacy' OpenGL
  libGL = dependency('gl')
  opengl_dependencies += [libGL]
else
  libGLX = dependency('glx')
  opengl_dependencies += [libGLX, libOpenGL]
endif

subdir('src')
