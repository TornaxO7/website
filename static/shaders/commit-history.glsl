#version 300 es

precision highp float;

uniform float iSeed;
uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

float hash12(vec2 p)
{
    vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec3 cell(vec2 id, vec2 gv) {
    float hash = hash12(id);

    // glow effect
    float x = sdBox(gv, vec2(.075));
    float glow = .1 / (max(.2, x) - .1) - .3;

    // presence
    float m = (sin(iTime*.5 + iSeed * 100. + 8. * hash) * .4 + .6) * glow;

    vec3 col = sin(2. * vec3(1., 2., 3.) + hash + iSeed * 100. + iTime * .1) * .4 + .6;

    return col * m;
}

vec3 grid(vec2 uv) {
    vec2 id = floor(uv);
    vec2 gv = fract(uv) - .5;

    return cell(id, gv);
}

void main() {
    vec2 uv = (2. * gl_FragCoord.xy - iResolution.xy) / iResolution.y;

    float time = iTime * .005 + iSeed * 100.;
    uv += 5. * vec2(cos(time), sin(time));

    vec3 col = grid(uv * 5.);
    fragColor = vec4(col*.5, 1.);
}

