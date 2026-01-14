#version 300 es

precision highp float;

uniform float iSeed;
uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

const float PI = 3.1415926535;
const vec3 COLOR1 = vec3(0., 70., 135.) / 255.;
const vec3 COLOR2 = vec3(10., 0., 71.) / 255.;

float wave(vec2 uv, vec4 amps, vec4 freqs, vec4 offset) {
    float time = iTime*.3;

    float x = uv.x;
    float y = 0.;
    y += amps.x * sin(freqs.x * x + iSeed * 100. + time + offset.x);
    y += amps.y * sin(freqs.y * x + iSeed * 100. + time + offset.y);
    y += amps.z * sin(freqs.z * x + iSeed * 100. + time + offset.z);
    y += amps.w * sin(freqs.w * x + iSeed * 100. + time + offset.w);

    float blur = .025;

    float top_wave = smoothstep(y + blur, y, uv.y);
    float bottom_wave = smoothstep(y - 1., y, uv.y) * .4;

    return top_wave * bottom_wave;
}

void main() {
    vec2 uv = 2. * (2. * gl_FragCoord.xy - iResolution.xy) / iResolution.y;

    // backkground color;
    fragColor.rgb = mix(COLOR1, COLOR2, (gl_FragCoord.y / iResolution.y));

    float f = 0.;
    f += wave(uv, vec4(.1, .2, .3, .4), vec4(.1, .4, .8, .3), vec4(1., 1.5, 2., 2.5) * PI);
    f += wave(uv, vec4(.1, .3, .4, .1), vec4(.8, .5, .4, .3), vec4(5., 2., 1., 3.));
    f += wave(uv, vec4(.3, .2, .1, .2), vec4(.9, .5, .1, .1), vec4(1., 2., 2., 3.));

    vec3 col = vec3(.6);

    fragColor += vec4((f) * col * .2, 1.);
}