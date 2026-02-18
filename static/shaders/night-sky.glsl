#version 300 es

precision highp float;

uniform float iSeed;
uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

const float PI = acos(-1.);

float hash11(float p)
{
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

float hash12(vec2 p)
{
    vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

vec2 hash22(vec2 p)
{
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+iSeed*50.);
    return fract((p3.xx+p3.yz)*p3.zy);
}

float sdfUnevenCapsule( vec2 p, float r1, float r2, float h )
{
    p.x = abs(p.x);
    float b = (r1-r2)/h;
    float a = sqrt(1.0-b*b);
    float k = dot(p,vec2(-b,a));
    if( k < 0.0 ) return length(p) - r1;
    if( k > a*h ) return length(p-vec2(0.0,h)) - r2;
    return dot(p, vec2(a,b) ) - r1;
}

float valueNoise(vec2 p) {
    vec2 id = floor(p);
    vec2 sgv = smoothstep(0., 1., fract(p));

    float tl = hash12(id + vec2(0., 0.));
    float tr = hash12(id + vec2(1., 0.));
    float bl = hash12(id + vec2(0., 1.));
    float br = hash12(id + vec2(1., 1.));

    float m1 = mix(tl, tr, sgv.x);
    float m2 = mix(bl, br, sgv.x);
    return mix(m1, m2, sgv.y);
}

mat2 rotate(float r) {
    return mat2(
      cos(r), -sin(r),
      sin(r), cos(r)
    );
}

float stars(vec2 uv, float size) {
    float time = iTime*.1;
    vec2 id = floor(uv);
    vec2 h = hash22(id);

    vec2 gv = fract(uv) - .5;
    gv.x += cos(time + h.x*5.) * .3;
    gv.y += sin(time + h.y*8.) * .3;

    float x = length(gv);
    float y = size / max(x, 1e-3) - .1;

    return y;
}

vec3 star_layers(vec3 base_color, vec2 uv) {
    vec3 col = vec3(0.);
    for (int i = 1; i <= 2; ++i) {
      float a = float(i) * 2.;

      col = max(col, base_color * stars(rotate(a) * uv * a, .01));
    }

    return col;
}

float mountains(vec2 uv) {
    const float FACTOR = 5.;

    uv.y *= FACTOR;

    float y = 0.;
    float amp = 10. + iSeed;
    float freq = max(.2 - iSeed, .1);
    for (int i = 0; i < 8; ++i) {
        y += amp * sin(uv.x * freq + iSeed*100.*float(i));

        freq *= 2.;
        amp *= .5;
    }

    return smoothstep(-.1, .1, y - uv.y);
}

float shooting_star(vec2 uv, float rotation, float speed, float offset) {
    uv = rotate(rotation) * uv;
    uv.y -= (fract(iTime * speed) - .5) * offset;
    // debug
    // uv.y -= fract(iTime * .1) - .5;

    float x = sdfUnevenCapsule(uv, .0001, .0009, .7);
    float y = .001 / max(x, 1e-3) - .1;

    return max(y * .7, 0.);
}

vec3 shooting_stars(vec2 uv) {
    float m = 0.;

    vec2 left = uv * vec2(-1., 1.);

    m += shooting_star(uv, PI * .3, .1, 300.);
    m += shooting_star(left, PI * .3, .2, 60.);
    m += shooting_star(left + vec2(0., .5), PI * .3, .2, 180.);
    m += shooting_star(left - vec2(0., .5), PI * .3, .2, 180.);

    return vec3(m);
}

void main() {
    vec2 uv = (2. * gl_FragCoord.xy - iResolution.xy) / iResolution.y;
    uv.y *= -1.;

    vec3 col = vec3(0.);
    col += vec3(.2) + vec3(.1) * cos(2. * PI * (vec3(.1, .5, .5) * (1. - gl_FragCoord.y / iResolution.y) + vec3(.4, .5, .8)));
    col += star_layers(col, 3. * uv + vec2(iTime*.05, 0.));
    col += shooting_stars(uv);
    col *= mountains(10. * (uv + vec2(iTime * .1 + iSeed*100., -.7)));

    fragColor = vec4(col, 1.);
}

