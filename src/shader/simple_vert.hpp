#ifndef SHADER_SIMPLE_VERT_H
#define SHADER_SIMPLE_VERT_H

static const char* const kEmbedShaderSimpleVertex =
    R"(
#version 330 core

layout (location = 0) in vec2 position;
layout (location = 1) in vec4 color;

out vec4 vertex_color;

void main() {
  gl_Position = vec4(position.xy, 0.0, 1.0);
  vertex_color = color;
  
}
    
)";

#endif
