#version 300 es

precision highp float;

uniform float iSeed;
uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

const vec3 PINK = vec3(233, 71, 245) / 255.;
const vec3 BLUE = vec3(47, 75, 162) / 255.;

const float PI = acos(-1.);

float hash11(float p)
{
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

void main() {
    float t = iTime*.1;
    vec2 uv = (2. * gl_FragCoord.xy - iResolution.xy) / iResolution.y;
    uv *= mat2x2(1., -4., 1., 1.);
    float fade_in = smoothstep(-6., 0., uv.x);
    float fade_out = smoothstep(6., 0., uv.x);

    vec3 col = mix(PINK, BLUE, smoothstep(-1., 1., uv.y));

    vec2 p = vec2(atan(uv.y, uv.x), length(uv) - t*.05);

    float s = .05;
    float id = round(p.y / s);
    float h = hash11(id)*100.;
    p.y -= s*id;

    float m = smoothstep(.02, .0, abs(p.y));

    float a = sin(p.x*3. + h + t);
    m *= smoothstep(0., 2., a) * smoothstep(.1, .8, a);

    m *= fade_in * fade_out;
    
    m *= 2.;

    fragColor = vec4(col*m, 1.);
}