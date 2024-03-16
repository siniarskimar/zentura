#version 330 core

uniform sampler2D texture;
in vec3 fs_in_color;
out vec4 out_color;

void main() {
   out_color = vec4(fs_in_color.rgb,1.0);
}

