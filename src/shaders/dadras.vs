#version 300 es
precision highp float;

uniform float u_Consts[6];
uniform float u_Speed;
uniform sampler2D u_RgbNoise;

in vec3 i_Position;

out vec3 v_Position;

vec3 get_velocity()
{
    return vec3(
        i_Position.y - u_Consts[0] * i_Position.x + u_Consts[1] * i_Position.y * i_Position.z,
        u_Consts[2] * i_Position.y - (i_Position.x + 1.) * i_Position.z,
        u_Consts[3] * i_Position.x * i_Position.y - u_Consts[4] * i_Position.z
    );
}

void main()
{
    vec3 pos = i_Position + get_velocity() * u_Speed;

    ivec2 uv = ivec2(int(i_Position[0]) % 512, int(i_Position[1]) % 512);
    vec3 noise = (texelFetch(u_RgbNoise, uv, 0).rgb / 255.);

    pos = mix(pos, noise, float(length(pos) > 25.));
    pos += noise * 2.;

    v_Position = pos;
}
