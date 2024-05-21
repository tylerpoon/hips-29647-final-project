#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}