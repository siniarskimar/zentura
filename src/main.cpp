#include <iostream>
#include <vector>
#include "gl/shader.hpp"
#include "ui/glfw.hpp"
#include "./ui/Window.hpp"
#include <fmt/core.h>
#include <cstdio>
#include "gl/shadercompiler.hpp"
#include "gl/vao.hpp"

int main(int argc, const char* argv[]) {

  if(!GLFW::initialize()) {
    fmt::print(stderr, "Failed to initialize GLFW\n");
    return 2;
  }

  glfwSetErrorCallback([](int errorCode, const char* errorMsg) {
    fmt::print(stderr, "[GLFW {}] {}\n", errorCode, errorMsg);
  });

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);

  Window& window = Window::createInstance(800, 600, "ZEN");

  window.makeContextCurrent();

  int version = gladLoadGLLoader((GLADloadproc) glfwGetProcAddress);

  if(version == 0) {
    fmt::print(stderr, "Failed to load OpenGL context\n");
    return 2;
  }

  const char* glVersion = (const char*) glGetString(GL_VERSION);
  fmt::print("OpenGL {:s}\n", glVersion);

  glfwSwapInterval(1);

  const float vertices[] = {
      // clang-format off
      // position     color
      -0.5f, -0.5f,   0.0f, 0.0f, 1.0f,
      0.5f,  -0.5f,   0.0f, 1.0f, 0.0f,
      0.5f,   0.5f,   1.0f, 1.0f, 0.0f,
      -0.5f,   0.5f,  1.0f, 0.0f, 0.0f,
      // clang-format on
  };

  const unsigned int indicies[] = {
      // clang-format off
      0, 1, 2,
      2, 3, 0
      // clang-format on
  };

  GLShaderCompiler shaderCompiler;

  const char* vertexSource = R"(
    #version 130

    in vec2 iPosition;
    in vec3 iColor;
    out vec3 vertexColor;

    void main() {
      gl_Position = vec4(iPosition.xy, 0.0, 1.0);
      vertexColor = iColor;
    }  
  )";

  const char* fragmentSource = R"(
    #version 130

    in vec3 vertexColor;
    out vec4 fragment;
    
    void main() {
      fragment = vec4(vertexColor, 1.0);  
    }
    )";
  GLShaderCompiler::CompilationStatus compileStatus;

  if(!(compileStatus = shaderCompiler.compile(GL_VERTEX_SHADER, vertexSource))) {
    fmt::print(stderr, "Vertex shader compilation failed!\n{}\n", compileStatus.infoLog);
    return 2;
  }

  if(!(compileStatus = shaderCompiler.compile(GL_FRAGMENT_SHADER, fragmentSource))) {
    fmt::print(
        stderr, "Fragment shader compilation failed!\n{}\n", compileStatus.infoLog);
    return 2;
  }

  auto shaderProgram = shaderCompiler.link();

  if(!shaderProgram) {
    fmt::print(stderr, "Failed to link shader program!\n");
    return 2;
  }

  const GLint positionAttribLoc = shaderProgram->getAttribLocation("iPosition");
  const GLint colorAttribLoc = shaderProgram->getAttribLocation("iColor");

  GLVAO vertexArray;
  vertexArray.bind();
  vertexArray.uploadDataBuffer(vertices, sizeof(vertices), GL_STATIC_DRAW);
  vertexArray.uploadIndexBuffer(indicies, sizeof(indicies), GL_STATIC_DRAW);

  vertexArray.enableAttrib(positionAttribLoc);
  vertexArray.vertexAttribFormat(
      positionAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0);

  vertexArray.enableAttrib(colorAttribLoc);
  vertexArray.vertexAttribFormat(
      colorAttribLoc, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, sizeof(float) * 2);

  glBindVertexArray(0);

  while(!window.shouldClose()) {
    glClear(GL_COLOR_BUFFER_BIT);

    shaderProgram->use();
    vertexArray.bind();
    GLCall(glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nullptr));

    window.swapBuffers();
    glfwPollEvents();
  }

  return 0;
}
