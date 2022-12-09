cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project("zen"
    VERSION 0.1.0
)

set(OpenGL_GL_PREFERENCE "GLVND" CACHE STRING "OpenGL preference (GLVND or LEGACY)" FORCE)
find_package("OpenGL" REQUIRED)
find_package("PkgConfig" QUIET)
find_package("glfw3" 3.3 REQUIRED)

add_executable(zen
    "src/main.cpp"
    "src/glfw_library.cpp"
    "src/ui/Window.cpp"
)

target_link_libraries(zen
    glfw ${GLFW_LIBRARIES}
    OpenGL::OpenGL
    OpenGL::GLX
)

target_include_directories(zen
    PRIVATE
    "${PROJECT_SOURCE_DIR}/src"
    "${PROJECT_SOURCE_DIR}/include"
)
