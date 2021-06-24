#version 300 es
precision highp float;

in vec3 i_Position;

void main()
{
    gl_PointSize = 1.;
    gl_Position = vec4(i_Position, 1.);
}
