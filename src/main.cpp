#include <iostream>
#include <vector>
#include "ui/glfw.hpp"
#include "./ui/Window.hpp"

#define GLCall(func) \
 (func);\
  while(auto error = glGetError()) {\
    std::cout << __FILE__ << ":" << __LINE__ << " GLERROR " << error << std::endl; \
  }

/// @brief Compiles a GLSL shader
/// @returns 0 on failure
GLuint compileShader(GLenum shaderType, const std::string shaderSource) {
  GLuint shader = glCreateShader(shaderType);
  const GLchar* shaderSources[1] = {
    shaderSource.c_str()
  };
  glShaderSource(shader, 1, shaderSources, NULL);

  glCompileShader(shader);
  
  GLint compileStatus = GL_TRUE;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);

  if(compileStatus == GL_FALSE) {
    int infoLogSize{};
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLogSize);
    std::vector<char> infoLog(infoLogSize, '\0');
    glGetShaderInfoLog(shader, infoLog.size(), NULL, infoLog.data());

    std::cout << "Shader Compilation Error: \n" << infoLog.data() << std::endl; 
    glDeleteShader(shader);
    return 0;
  }
  
  return shader;
}

class GLShaderProgram {
  public:
  
  GLShaderProgram()
    : shaderProgram_(glCreateProgram()), ready_(false)
  {}

  void attachShader(GLuint shader) {
    GLCall(glAttachShader(getProgramID(), shader));
  }
  
  bool linkProgram() {
    ready_ = false;
    
    GLCall(glLinkProgram(getProgramID()));
    
    GLint linkStatus = GL_TRUE;
    glGetProgramiv(getProgramID(), GL_LINK_STATUS, &linkStatus);
    if(linkStatus == GL_FALSE) {
      return false;
    }
    
    ready_ = true;
    return true;
  }
  
  void use() {
      GLCall(glUseProgram(getProgramID()));
  }
  
  inline GLuint getProgramID() const noexcept {
    return shaderProgram_;
  }

  inline bool isReady() const noexcept {
    return ready_;
  }

  GLint getUniformLocation(const std::string& name) {
    auto loc = GLCall(glGetUniformLocation(getProgramID(), name.c_str()));
    return loc;
  }
  
  GLint getAttribLocation(const std::string& name) {
    auto loc = GLCall(glGetAttribLocation(getProgramID(), name.c_str()));
    return loc;
  }

  private:
  GLuint shaderProgram_;
  bool ready_;
};

int main(int argc, const char* argv[]) {

  if(!GLFW::initialize()) {
    std::cerr << "Failed to initialize GLFW library" << std::endl;
    return 2;
  }

  glfwWindowHint(GLFW_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_VERSION_MINOR, 0);
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
    // position     color
    0.0f,   0.5f,   1.0f, 0.0f, 0.0f,
    0.5f,  -0.5f,   0.0f, 1.0f, 0.0f,
    -0.5f, -0.5f,   0.0f, 0.0f, 1.0f
  };

  const char* vertexShaderSrc = R"(
    #version 130

    in vec2 iPosition;
    in vec3 iColor;
    out vec3 vertexColor;

    void main() {
      gl_Position = vec4(iPosition.xy, 0.0, 1.0);
      vertexColor = iColor;
    }  
  )";

  const char* fragmentShaderSrc = R"(
    #version 130

    in vec3 vertexColor;
    out vec4 fragment;
    
    void main() {
      fragment = vec4(vertexColor, 1.0);  
    }
    )";
  GLuint fragmentShader = compileShader(GL_FRAGMENT_SHADER, fragmentShaderSrc);
  GLuint vertexShader = compileShader(GL_VERTEX_SHADER, vertexShaderSrc);

  if(vertexShader == 0) {
    std::cerr << "Failed to compile vertex shader [" << glGetError() << ']' << std::endl;
    return 2;
  }
  
  if(fragmentShader == 0) {
    std::cerr << "Failed to compile fragment shader [" << glGetError() << ']' << std::endl;
    return 2;
  }

  GLShaderProgram shaderProg;
  shaderProg.attachShader(vertexShader);
  shaderProg.attachShader(fragmentShader);

  if(!shaderProg.linkProgram()) {
    std::cerr << "Failed to link shader program [" << glGetError() << ']' << std::endl; 
    return 2;
  }
  
  const GLint positionAttribLoc = shaderProg.getAttribLocation("iPosition");
  const GLint colorAttribLoc = shaderProg.getAttribLocation("iColor");
 
  GLuint vertexArray;
  GLuint vertexBuffer;
  GLCall(glGenBuffers(1, &vertexBuffer));
  GLCall(glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer));
  GLCall(glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW));

  GLCall(glGenVertexArrays(1, &vertexArray));
  GLCall(glBindVertexArray(vertexArray));
  
  GLCall(glEnableVertexAttribArray(positionAttribLoc));
  GLCall(glVertexAttribPointer(positionAttribLoc, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (void*) 0));
  
  GLCall(glEnableVertexAttribArray(colorAttribLoc));
  GLCall(glVertexAttribPointer(colorAttribLoc, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (void*) (sizeof(float) * 2)));

  while(!window.shouldClose()) {
    glClear(GL_COLOR_BUFFER_BIT);

    shaderProg.use();
    GLCall(glBindVertexArray(vertexArray));
    GLCall(glDrawArrays(GL_TRIANGLES, 0, 3));

    window.swapBuffers();
    glfwPollEvents();
  }

  return 0;
}
