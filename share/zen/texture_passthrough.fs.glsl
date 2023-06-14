#version 330 core

in vec4 vs_color;
in vec2 vs_texCoord;

out vec4 fs_color;

uniform sampler2D tex;

void main() {
	fs_color = texture(tex, vs_texCoord);
}
