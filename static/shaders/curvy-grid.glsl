#version 300 es

precision highp float;

uniform float iSeed;
uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

const vec3 PINK = vec3(233, 71, 245) / 255.;
const vec3 BLUE = vec3(47, 75, 162) / 255.;

vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.283185*(c*t+d) );
}

void main() {
    float t = iTime;
    vec2 uv = (2. * gl_FragCoord.xy - iResolution.xy) / iResolution.y;
    uv = mat2(1., -2., 2., 1.) * uv;

    float fade_out = smoothstep(4., 0., uv.x);
    float fade_in = smoothstep(-4., 0., uv.x);

    vec3 col = palette(t*.1 - uv.x*.1, vec3(.5), vec3(.5), vec3(1.), vec3(.5, .3, .2));
    col = mix(BLUE, PINK, smoothstep(-.5, .5, sin(uv.x*.5 + t*.5)*.5));
    uv.y += sin(uv.x + t*.02 + iSeed*100.)*.5;
    uv.x -= t*.02;

    vec2 p = uv - .3*round(uv/.3);

    float m = smoothstep(.015, .0, abs(p.x));
    m = max(m, smoothstep(.015, .0, abs(p.y)));

    fragColor = vec4(col*m*fade_out*fade_in, 1.);
}