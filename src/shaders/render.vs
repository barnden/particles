#version 300 es
precision highp float;

uniform vec3 u_Angles;

// TODO: Use a transform from perspective projection into NDC instead of scaling w
uniform float u_Scale;

in vec3 i_Position;

mat3 get_perspective(vec3 angles)
{
    // Get the Perspective Projection
    float cx = cos(angles.x),
          cy = cos(angles.y),
          cz = cos(angles.z),
          sx = sin(angles.x),
          sy = sin(angles.y),
          sz = sin(angles.z);

    // clang-format off
    mat3 projection = mat3(
        cy * cz               , cy * sz               , -sy    ,
        sx * sy * cz - cx * sz, sx * sy * sz + cx * cz, sx * cy,
        cx * sy * cz + sx * sz, cx * sy * sz - sx * cz, cx * cy
    );
    // clang-format on

    return projection;
}

void main() {
    mat3 projection = get_perspective(u_Angles);

    gl_Position = vec4(projection * i_Position, u_Scale);
    gl_PointSize = 1.;
}
