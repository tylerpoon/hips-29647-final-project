#version 300 es 

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359
#define TWO_PI 2.*PI

float polygon(vec2 st, vec2 offset, int sides) {
    st = st *2.-1. + offset;

    float a = atan(st.x,st.y)+PI;
    float r = TWO_PI/float(sides);
    return cos(floor(.5+a/r)*r-a)*length(st);
}

out vec4 fragColor;
void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    vec3 color = vec3(1.0 - smoothstep(0.5, 0.51, polygon(st, vec2(-0.3), 6)));
    fragColor = vec4(color, 1.0);
}