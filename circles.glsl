#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
	vec2 st = gl_FragCoord.xy/u_resolution;
    float pct = 0.0;

    pct = min(distance(st,vec2(0.4)),distance(st,vec2(0.6)));

    float cutoff = abs(sin(u_time)) * 0.8 + 0.1;
	pct = 1. - step(cutoff, pct * 2.);
    vec3 color = vec3(0.9, 0.3, 0.4) * pct;

	gl_FragColor = vec4( color, 1.0 );
}