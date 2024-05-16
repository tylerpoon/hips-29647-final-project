#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define ITERS 50
#define MIN_A -50.
#define LENGTH_A 100.
#define MIN_B -50.
#define LENGTH_B 100. 

#define PI 3.14159265359

/// COSH Function (Hyperbolic Cosine)
float cosh(float val)
{
    float tmp = exp(val);
    float cosH = (tmp + 1.0 / tmp) / 2.0;
    return cosH;
}
 
// TANH Function (Hyperbolic Tangent)
float tanh(float val)
{
    float tmp = exp(val);
    float tanH = (tmp - 1.0 / tmp) / (tmp + 1.0 / tmp);
    return tanH;
}
 
// SINH Function (Hyperbolic Sine)
float sinh(float val)
{
    float tmp = exp(val);
    float sinH = (tmp - 1.0 / tmp) / 2.0;
    return sinH;
}

#define cx_mul(a, b) vec2(a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x)
#define cx_div(a, b) vec2(((a.x*b.x + a.y*b.y)/(b.x*b.x + b.y*b.y)),((a.y*b.x - a.x*b.y)/(b.x*b.x + b.y*b.y)))
#define cx_sin(a) vec2(sin(a.x) * cosh(a.y), cos(a.x) * sinh(a.y))
#define cx_cos(a) vec2(cos(a.x) * cosh(a.y), -sin(a.x) * sinh(a.y))

vec2 as_polar(vec2 z) {
  return vec2(
    length(z),
    atan(z.y, z.x)
  );
}

vec2 cx_tan(vec2 a) {return cx_div(cx_sin(a), cx_cos(a)); }
vec2 cx_log(vec2 a) {
    vec2 polar = as_polar(a);
    float rpart = polar.x;
    float ipart = polar.y;
    if (ipart > PI) ipart=ipart-(2.0*PI);
    return vec2(log(rpart),ipart);
}
vec2 cx_pow(vec2 v, float p) {
  vec2 z = as_polar(v);
  return pow(z.x, p) * vec2(cos(z.y * p), sin(z.y * p));
}

vec2 my_polynomial(vec2 x) {
    return cx_pow(x, 3.) - 6. * cx_pow(x, 2.) + 9. * x - vec2(4., 0.);
}

vec2 my_deriv(vec2 x) {
    return 3. * cx_pow(x, 2.) - 12. * x + vec2(9., 0.);
}

int newton_method(vec2 x0) {
    vec2 current = x0;
    for (int i = 0; i < ITERS; i++) {
        if (distance(current, vec2(1., 0)) < 0.01 || distance(current, vec2(4., 0)) < 0.01) {
            return i;
        }
        current = current - cx_div(my_polynomial(current), my_deriv(current));
    }
    return ITERS;
}

float modI(float a,float b) {
    float m=a-floor((a+0.5)/b)*b;
    return floor(m+0.5);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float length_a = LENGTH_A / exp(u_time / 5.);
    float min_a = MIN_A + (LENGTH_A - length_a) / 1.886797;
    float length_b = LENGTH_B / exp(u_time / 5.);
    float min_b = MIN_B + (LENGTH_B - length_b) / 2.;

    vec2 x0 = vec2((length_a * st.x) + min_a, (length_b * st.y) + min_b);
    vec3 color = vec3(modI(float(newton_method(x0)), 2.));

    gl_FragColor = vec4(color, 1.0);
}