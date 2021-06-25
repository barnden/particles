#version 300 es
precision highp float;

out vec4 o_FragColor;

void main()
{
    vec2 circ = 2. * gl_PointCoord - 1.;

    if (dot(circ, circ) > 0.5)
        discard;

    o_FragColor = vec4(1., 1., 0., 1.);
}
