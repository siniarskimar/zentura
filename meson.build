project('zen', ['c','cpp'],
  default_options: [
    'cpp_std=c++20',
    'warning_level=2'
  ],
  license: 'Apache-2.0',
  meson_version: '>=0.64.0'
)

fs = import('fs')

doxygen = find_program('doxygen', required: false)
python = find_program('python3')

opengl_dependencies = []

libOpenGL = dependency('opengl', required: false)

libSDL2 = dependency('sdl2', required: true)

libfmt = dependency('fmt', version: '9.1.0>=', required: true)
libglm = dependency('glm', version: '0.9.9.8>=', required: true)
libfontconfig = dependency('fontconfig', required: true)
libfreetype = dependency('freetype2', required: true)

nothings_stb_proj = subproject('nothings_stb')
stb_image = nothings_stb_proj.get_variable('stb_image_dep')

if libOpenGL.found()
  opengl_dependencies += [libOpenGL]
else
  opengl_dependencies += [dependency('gl')]
endif

libglad_proj = subproject('glad')
libglad = libglad_proj.get_variable('libglad_dep')

subdir('src')
subdir('share')

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

run_target('run',
  command: [
    python,
    meson.project_source_root() / 'scripts' / 'run.py',
    '@BUILD_ROOT@'
  ],
  depends: zen_exe
)

run_target('clang-format',
  command: [
    python,
    meson.project_source_root() / 'scripts' / 'clang-format.py',
    '--format'
  ]
)
