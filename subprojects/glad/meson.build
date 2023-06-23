project('glad', 'c',
  license: 'MIT',
  version: '2.0'
)

inc = include_directories('include')
libglad = static_library('glad',
  'glad/glad.c',
  include_directories: inc,
  install: false
)

libglad_dep = declare_dependency(
  include_directories: inc,
  link_with: libglad
)
