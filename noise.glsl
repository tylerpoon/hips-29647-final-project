#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359

vec3 color_1 = vec3(0.6549, 0.8902, 0.9686);
vec3 color_2 = vec3(0.1137, 0.0275, 0.7686);

// 2D Random
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float monster_noise(in vec2 st) {
    vec2 pos = st + vec2(u_time) * 0.2;
    float val = 0.;

    val += noise(pos);
    val += noise(pos * 2.) / 2.;
    val += noise(pos * 4.) / 4.;
    val += noise(pos * 8.) / 8.;
    val /= 1. + 1./2. + 1./4. + 1./8.;

    val = noise(pos + val);

    return val;
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec3 color = vec3(0.0);
    vec2 pos = 3.0 * st;

    float val = monster_noise(pos) * 0.5 + monster_noise(pos / 2.) * 0.5;
    color = vec3(mix(color_1, color_2, val));

    gl_FragColor = vec4(color, 1.0);
}