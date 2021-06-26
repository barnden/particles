#version 300 es
precision highp float;

out vec4 o_FragColor;

void main()
{
    vec3 color1 = vec3(1., 0., 0.);
    vec3 color2 = vec3(0., 0., 1.);

    vec3 color = mix(color1, color2,  gl_FragCoord[2]);

    o_FragColor = vec4(color, 1.);
}
