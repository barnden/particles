#version 300 es
precision highp float;

in vec3 i_Position;

mat3 get_perspective(float tx, float ty, float tz)
{
    // Get the Perspective Projection
    float cx = cos(tx),
          cy = cos(ty),
          cz = cos(tz),
          sx = sin(tx),
          sy = sin(ty),
          sz = sin(tz);

    float ex = -15.,
          ey = -15.,
          ez = -15.;

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

    return projection;
}

void main() {
    mat3 projection = get_perspective(0.57828, 0.8058, -0.44);

    gl_Position = vec4(i_Position, 25.);
    gl_PointSize = 4.;
}
