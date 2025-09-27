#version 300 es

precision highp float;

uniform float iSeed;
uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

const float PI = acos(-1.);

float drawCircle(vec2 uv, vec2 center, float radius) {
    return smoothstep(radius, radius - .1, length(uv - center));
}

vec2 getInnerPoint(vec2 id) {
    vec2 point = id + .4 * sin(iTime);
    return point + .5;
}

float drawLayer(vec2 lv, float time) {
    float m = 0.;

    vec2 id = floor(lv);
    m += drawCircle(lv, getInnerPoint(id), .1);

    return m;
}

mat2 getRotationMatrix(float time) {
    return mat2(cos(time), -sin(time), sin(time), cos(time));
}

void main()
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    float m = smoothstep(.9, -1.5, length(uv.y));
    float time = iTime * .1;

    uv -= .5;
    uv.x *= iResolution.x / iResolution.y;
    uv *= 20.;

    const float amount_layers = 6.;
    for (float i = 0.; i < amount_layers; i += 1.) {
        float z = fract(2. * (i / (amount_layers * 2.)) - time);

        float fade_in = smoothstep(0., .2, z);
        float fade_out = smoothstep(1., .8, z);
        float fade = fade_in * fade_out;

        vec2 lv = getRotationMatrix(z * 3.) * uv * z;
        m += drawLayer(lv, time) * fade;
    }

    vec3 base_color = sin(time * 5. * vec3(1.5, 3., 7.) + iSeed * PI) * .25 + .75;
    vec3 col = base_color * m;

    fragColor = vec4(col, 1.);
}

