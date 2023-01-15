#include <iostream>
#include <vector>
#include "gl/shader.hpp"
#include "shader.hpp"
#include "ui/glfw.hpp"
#include "./ui/Window.hpp"

int main(int argc, const char* argv[]) {

  if(!GLFW::initialize()) {
    std::cerr << "Failed to initialize GLFW library" << std::endl;
    return 2;
  }

  glfwSetErrorCallback([](int errorCode, const char* errorMsg) {
    std::cerr << "[GLFW " << errorCode << "] " << errorMsg << '\n';
  });

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);

  Window& window = Window::createInstance(800, 600, "ZEN");

  window.makeContextCurrent();

  int version = gladLoadGLLoader((GLADloadproc) glfwGetProcAddress);

  if(version == 0) {
    std::cerr << "Failed to load OpenGL 3.0" << std::endl;
    return 2;
  }

  glfwSwapInterval(1);

  const float vertices[] = {
      // clang-format off
      // position     color
      0.0f,   0.5f,   1.0f, 0.0f, 0.0f,
      0.5f,  -0.5f,   0.0f, 1.0f, 0.0f,
      -0.5f, -0.5f,   0.0f, 0.0f, 1.0f
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
    std::cerr << "Vertex shader compilation failed!\n"
              << compileStatus.infoLog << std::endl;
    return 2;
  }

  if(!(compileStatus = shaderCompiler.compile(GL_FRAGMENT_SHADER, fragmentSource))) {
    std::cerr << "Fragment shader compilation failed!\n"
              << compileStatus.infoLog << std::endl;
    return 2;
  }

  auto shaderProgram = shaderCompiler.link();

  if(!shaderProgram) {
    std::cerr << "Failed to link shader program!" << std::endl;
    return 2;
  }

  const GLint positionAttribLoc = shaderProgram->getAttribLocation("iPosition");
  const GLint colorAttribLoc = shaderProgram->getAttribLocation("iColor");

  GLuint vertexArray;
  GLuint vertexBuffer;
  GLCall(glGenBuffers(1, &vertexBuffer));
  GLCall(glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer));
  GLCall(glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW));

  GLCall(glGenVertexArrays(1, &vertexArray));
  GLCall(glBindVertexArray(vertexArray));

  GLCall(glEnableVertexAttribArray(positionAttribLoc));
  GLCall(glVertexAttribPointer(
      positionAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (void*) 0));

  GLCall(glEnableVertexAttribArray(colorAttribLoc));
  GLCall(glVertexAttribPointer(
      colorAttribLoc, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5,
      (void*) (sizeof(float) * 2)));

  while(!window.shouldClose()) {
    glClear(GL_COLOR_BUFFER_BIT);

    shaderProgram->use();
    GLCall(glBindVertexArray(vertexArray));
    GLCall(glDrawArrays(GL_TRIANGLES, 0, 3));

    window.swapBuffers();
    glfwPollEvents();
  }

  return 0;
}
