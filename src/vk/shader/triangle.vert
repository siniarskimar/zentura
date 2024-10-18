#version 450

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;

layout(location = 0) out vec3 fragColor;

void main() {
    // vec3 pos = inPosition * 2 + vec3(-1, -1, 0);
    // pos = pos * 0.5;
    gl_Position = vec4(inPosition, 1.0);
    fragColor = inColor;
}

