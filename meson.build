project('zen', ['c','cpp'],
  default_options: [
    'cpp_std=c++20'
  ],
  license: 'Apache-2.0',
  meson_version: '>=0.64.0'
)

doxygen = find_program('doxygen', required: false)
python = find_program('python3')

opengl_dependencies = []

libOpenGL = dependency('opengl', required: false)

# TODO: install glfw3 wrap and provide option to switch to use it when
#       requested
libGLFW = dependency('glfw3', required: true)

libfmt = dependency('fmt', version: '9.1.0>=', required: true)
libglm = dependency('glm', version: '0.9.9.8>=', required: true)
libfontconfig = dependency('fontconfig', required: true)
libfreetype = dependency('freetype2', required: true)

if libOpenGL.found()
  opengl_dependencies += [libOpenGL]
else
  opengl_dependencies += [dependency('gl')]
endif

if doxygen.found() and get_option('build_devdocs')
  run_target('devdoc',
    command: [
      python,
      meson.project_source_root() / 'docs' / 'dev' / 'make.py',
      '-o',
      meson.project_build_root() / 'docs',
      '--doxygen-bin',
      doxygen
    ]
  )
endif

if get_option('build_userdocs')
  run_target('userdoc',
    command: [
      python,
      meson.project_source_root() / 'docs' / 'user' / 'make.py',
      meson.project_source_root() / 'docs' / 'user',
      meson.project_build_root() / 'docs' / 'user'
    ]
  )
endif

subdir('src')
