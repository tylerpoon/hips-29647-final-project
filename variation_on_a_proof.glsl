#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.01, pct, st.y) -
          smoothstep( pct, pct+0.01, st.y);
}

//This one needs a lot of work but was good practice
void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float x = (u_time / 10.) + st.x * 3.;
    float y = pow(x, 3.) - 6. * pow(x, 2.) + 11. * x - 6.;
    y = (y + 2. - u_time / 5.) / 3.;

    float pct = plot(st,y);
    float pct_lin = plot(st, ((2. * x - 2.) + 2. - u_time / 5.) / 3.);
    vec3 color = pct*vec3(0.0,1.0,0.0) + pct_lin*vec3(1.0, 0.0, 0.0);

    gl_FragColor = vec4(color,1.0);
}