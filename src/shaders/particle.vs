#version 300 es
precision highp float;

uniform float u_Time;
uniform sampler2D u_RgbNoise;
uniform vec3 u_Origin;

uniform float u_Alpha;

in vec3 i_Position;
in vec3 i_Velocity;
in float i_Age;

out vec3 o_Position;
out vec3 o_Velocity;
out float o_Age;

mat3 get_perspective(float tx, float ty, float tz)
{
    // Get the Perspective Projection
    float cx = cos(tx),
          cy = cos(ty),
          cz = cos(tz),
          sx = sin(tx),
          sy = sin(ty),
          sz = sin(tz);

    float ex = 1.,
          ey = 1.,
          ez = 1.;

    // clang-format off
    mat3 projection = mat3(
        cy * cz               , cy * sz               , -sy    ,
        sx * sy * cz - cx * sz, sx * sy * sz + cx * cz, sx * cy,
        cx * sy * cz + sx * sz, cx * sy * sz - sx * cz, cx * cy
    );
    // clang-format on

    mat3 homogeneous_transform = mat3(1., 0., ex / ez,
                                      0., 1., ey / ez,
                                      0., 0., 1. / ez);

    return homogeneous_transform * projection;
}

vec3 get_velocity()
{
    return vec3(
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
}

void main()
{
    float angle = i_Age / 25.;
    mat3 projection = get_perspective(angle * 4., angle * 2.5, angle * 1.618);

    o_Position = projection * (i_Position + i_Velocity * u_Time);
    o_Velocity = get_velocity();

    o_Age = i_Age + u_Time;
}
