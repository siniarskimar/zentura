project('zen', ['c','cpp'],
  default_options: [
    'cpp_std=c++17'
  ],
  license: 'Apache-2.0',
  meson_version: '0.63.0>='
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

if not libOpenGL.found()
  # the 'Legacy' OpenGL
  libGL = dependency('gl')
  opengl_dependencies += [libGL]
else
  libGLX = dependency('glx')
  opengl_dependencies += [libGLX, libOpenGL]
endif

if doxygen.found() and get_option('build_devdocs')
  doxyfile_conf_data = configuration_data()
  doxyfile_conf_data.set('PROJECT_NAME', meson.project_name())
  doxyfile_conf_data.set('PROJECT_VERSION', meson.project_version())
  doxyfile_conf_data.set('OUTPUT_DIRECTORY', meson.project_build_root() / 'docs' / 'dev')
  doxyfile_conf_data.set('OUTPUT_LANGUAGE', 'English')
  doxyfile_conf_data.set('INPUT', meson.project_source_root() / 'src')

  configure_file(
    input: 'docs/Doxyfile.in',
    output: 'Doxyfile',
    configuration: doxyfile_conf_data
  )

  run_target('devdoc',
    command: [
      doxygen
    ]
  )
endif

if get_option('build_userdocs')
  run_target('userdoc',
    command: [
      python,
      meson.project_source_root() / 'docs' / 'make.py',
      meson.project_source_root() / 'docs' / 'source',
      meson.project_build_root() / 'docs' / 'user'
    ]
  )
endif

subdir('src')
