#ifndef SHADER_SIMPLE_FRAG_H
#define SHADER_SIMPLE_FRAG_H

static const char* const kEmbedShaderSimpleFrag =
    R"(
#version 330 core

in vec4 vertex_color;

out vec4 frag_color;

void main() {
  frag_color = vertex_color;    
}
    
)";

#endif
