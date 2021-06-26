#version 300 es
precision highp float;

uniform vec3 u_Angles;
uniform vec3 u_Camera;
uniform float u_Scale;
uniform float u_Ortho[6];

in vec3 i_Position;

mat3 get_perspective()
{
    // Get the Perspective Projection
    float cx = cos(u_Angles.x),
          cy = cos(u_Angles.y),
          cz = cos(u_Angles.z),
          sx = sin(u_Angles.x),
          sy = sin(u_Angles.y),
          sz = sin(u_Angles.z);

    // clang-format off
    return mat3(
        cy * cz               , cy * sz               , -sy    ,
        sx * sy * cz - cx * sz, sx * sy * sz + cx * cz, sx * cy,
        cx * sy * cz + sx * sz, cx * sy * sz - sx * cz, cx * cy
    );
    // clang-format on
}

mat4 get_orthographic()
{
    // Ortho 6-tuple: (left, right, bottom, top, near, far)
    return mat4(
        2. / (u_Ortho[1] - u_Ortho[0]), 0., 0., -(u_Ortho[1] + u_Ortho[0]) / (u_Ortho[1] - u_Ortho[0]),
        0., 2. / (u_Ortho[3] - u_Ortho[2]), 0., -(u_Ortho[3] + u_Ortho[2]) / (u_Ortho[3] - u_Ortho[2]),
        0., 0., -2. / (u_Ortho[5] - u_Ortho[4]), -(u_Ortho[5] + u_Ortho[4]) / (u_Ortho[5] - u_Ortho[4]),
        0., 0., 0., 1.);
}

void main()
{
    mat3 projection = get_perspective();
    mat4 ortho = get_orthographic();
    vec3 rel_position = i_Position - u_Camera;

    gl_Position = ortho * vec4(projection * rel_position, u_Scale);
    gl_PointSize = 1.;
}
