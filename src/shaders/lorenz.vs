#version 300 es
precision highp float;

uniform float u_Alpha;
uniform float u_Speed;
uniform sampler2D u_RgbNoise;

in vec3 i_Position;

out vec3 v_Position;

vec3 get_velocity()
{
    return vec3(
        10. * (i_Position[1] - i_Position[0]),
        28. * i_Position[0] - i_Position[0] * i_Position[2] - i_Position[1],
        i_Position[0] * i_Position[1] - (8. / 3.) * i_Position[2]
    );
}

void main()
{
    v_Position = i_Position + get_velocity() * u_Speed;
}
