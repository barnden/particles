#version 300 es
precision highp float;

uniform vec3 u_Angles;
uniform vec3 u_Camera;
uniform float u_Scale;
uniform mat4 u_Orthographic;
uniform mat3 u_Perspective;

in vec3 i_Position;

void main()
{
    vec3 rel_position = i_Position - u_Camera;

    gl_Position = u_Orthographic * vec4(u_Perspective * rel_position, u_Scale);
    gl_PointSize = 1.;
}
