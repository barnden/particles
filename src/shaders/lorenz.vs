#version 300 es
precision highp float;

uniform float u_Consts[3];
uniform float u_Speed;
uniform sampler2D u_RgbNoise;

in vec3 i_Position;

out vec3 v_Position;

vec3 get_velocity()
{
    return vec3(
        u_Consts[0] * (i_Position[1] - i_Position[0]),
        u_Consts[1] * i_Position[0] - i_Position[0] * i_Position[2] - i_Position[1],
        i_Position[0] * i_Position[1] - u_Consts[2] * i_Position[2]
    );
}

void main()
{
    v_Position = i_Position + get_velocity() * u_Speed;
}
