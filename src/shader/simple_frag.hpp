#ifndef SHADER_SIMPLE_FRAG_H
#define SHADER_SIMPLE_FRAG_H

static const char* const kEmbedShaderSimpleFrag =
    R"(
#version 330 core

in vec3 vertex_color;

out vec4 frag_color;

void main() {
  frag_color = vec4(vertex_color.rgb, 1.0);    
}
    
)";

#endif
