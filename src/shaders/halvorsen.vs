#version 300 es
precision highp float;

uniform float u_Alpha;
uniform float u_Speed;
uniform sampler2D u_RgbNoise;

in vec3 i_Position;

out vec3 v_Position;

vec3 get_velocity()
{
    int factor = int(i_Position[2]) % 8;
    ivec2 tex_coord = factor * ivec2(int(i_Position[0]) % 64, int(i_Position[1]) % 64);
    vec3 noise = texelFetch(u_RgbNoise, tex_coord, 0).rgb;

    vec3 velo = vec3(
        -u_Alpha * i_Position[0]
            - 4. * i_Position[1]
            - 4. * i_Position[2]
            - i_Position[1] * i_Position[1],

        -u_Alpha * i_Position[1]
            - 4. * i_Position[2]
            - 4. * i_Position[0]
            - i_Position[2] * i_Position[2],

        -u_Alpha * i_Position[2]
            - 4. * i_Position[0]
            - 4. * i_Position[1]
            - i_Position[0] * i_Position[0]);

    return velo;
}

void main()
{

    v_Position = (i_Position + get_velocity() * u_Speed);
}
