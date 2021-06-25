#version 300 es
precision highp float;

uniform float u_Alpha;
uniform float u_Speed;
uniform sampler2D u_RgbNoise;

in vec3 i_Position;

out vec3 v_Position;

vec3 get_velocity()
{
    ivec2 tex_coord = ivec2(int(i_Position[0]) % 512, int(i_Position[1]) % 512);
    vec3 noise = texelFetch(u_RgbNoise, tex_coord, 0).rgb / 64.;

    vec3 velo = vec3(0.);

    velo.x = -u_Alpha * i_Position.x
             - 4. * i_Position.y
             - 4. * i_Position.z
             - i_Position.y * i_Position.y;

    velo.y = -u_Alpha * i_Position.y
             - 4. * i_Position.z
             - 4. * i_Position.x
             - i_Position.z * i_Position.z;

    velo.z = -u_Alpha * i_Position.z
             - 4. * i_Position.x
             - 4. * i_Position.y
             - i_Position.x * i_Position.x;

    velo = mix(velo, normalize(velo), 0.5);

    return velo;
}

void main()
{
    ivec2 uv = ivec2(int(i_Position[0]) % 512, int(i_Position[1]) % 512);
    vec3 noise = texelFetch(u_RgbNoise, uv, 0).rgb / 255.;

    vec3 pos = i_Position + get_velocity() * u_Speed;

    pos = mix(pos, noise, float(length(pos) > 25.));
    pos += noise * 2.;

    v_Position = pos;
}
