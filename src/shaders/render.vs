#version 300 es
precision highp float;

uniform vec3 u_Angles;
uniform vec3 u_Camera;
uniform float u_Scale;

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
    mat3 projection = mat3(
        cy * cz               , cy * sz               , -sy    ,
        sx * sy * cz - cx * sz, sx * sy * sz + cx * cz, sx * cy,
        cx * sy * cz + sx * sz, cx * sy * sz - sx * cz, cx * cy
    );
    // clang-format on

    return projection;
}

void main() {
    mat3 projection = get_perspective();
    vec3 rel_position = i_Position - u_Camera;

    gl_Position = vec4(projection * rel_position, u_Scale);
    gl_PointSize = 1.;
}
