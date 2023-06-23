project('nothings_stb', 'c')

inc = include_directories('include')

stb_image = static_library('stb_image',
  'stb_image.c',
  include_directories: inc
)

stb_image_dep = declare_dependency(
  include_directories: inc,
  link_with: stb_image
)
