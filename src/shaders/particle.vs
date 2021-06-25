#version 300 es
precision highp float;

// uniform float u_Time;
// uniform float u_Delta;
uniform float u_Alpha;

in vec3 i_Position;

out vec3 v_Position;

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
    v_Position = i_Position + get_velocity() / 50.;
}
