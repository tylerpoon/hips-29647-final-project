#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;

vec3 color_s = vec3(0.5,0.8,0.9);

float plot (vec2 st, float pct){
  return  smoothstep( pct-0.05, pct, st.y) -
          smoothstep( pct, pct+0.05, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    vec2 sun_coords = vec2(mod(u_time, PI) / PI, abs(sin(u_time)));

    float d = distance(sun_coords, st) * 2.;
    float pct = 1.0 - smoothstep(0., 0.3, d);

    vec3 color = vec3(0.0);
    color = mix(color, color_s, abs(sin(u_time))); 
    color = mix(color, vec3(0.99,0.72,0.07), pct);
    gl_FragColor = vec4(color, 1.0);
}