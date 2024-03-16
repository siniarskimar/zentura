#version 330 core

in vec3 in_pos;
in vec3 in_color;
out vec3 fs_in_color;

void main(){
   gl_Position = vec4(in_pos, 1.0);
   fs_in_color = in_color;
}

