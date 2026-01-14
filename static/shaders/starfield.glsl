#version 300 es

precision highp float;

uniform float iSeed;
uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

vec2 hash22(vec2 p)
{
	vec3 p3 = vec3(p.xyx) * vec3(18., 2.198, 11.68) * iSeed;
    return fract((p3.xx+p3.yz)*p3.zy);
}

mat2x2 rotate(float r) {
    return mat2x2(cos(r), sin(r), -sin(r), cos(r));
}

float star(vec2 uv) {
    return smoothstep(.1, .0, length(uv));
}

float starLayer(vec2 uv) {
    float time = iTime;
    vec2 id = floor(uv);
    vec2 gv = fract(uv) - .5;

    vec2 h = hash22(id);
    gv += vec2(cos(h.x * time + id.y), sin(h.y * time + id.x)) * .3;
    return star(gv);
}

void main() {
    float time = iTime;

    vec3 base_color = cos(vec3(3., 5., 10.) + time) * .25 + .75;
    vec3 col = base_color * smoothstep(.0, 2., 1. - gl_FragCoord.y / iResolution.y);
    vec2 uv = (2. * gl_FragCoord.xy - iResolution.xy) / iResolution.y;

    const int amount_layers = 6;
    const float layer_distance = 2.;
    for (int i = 0; i < amount_layers; ++i) {
        float fi = float(i);
        float z = fi - fract(time / layer_distance);

        float zoom = z * layer_distance;
        float fade_in = smoothstep(.0, layer_distance + 1., zoom);
        float fade_out = smoothstep(float(amount_layers - 1) * layer_distance, float(amount_layers - 1) * layer_distance * .8, zoom);

        float layer = starLayer(rotate(z*.4) * uv * zoom);
        col += base_color * layer * fade_in * fade_out;
    }

    fragColor = vec4(col, 1.);
}
