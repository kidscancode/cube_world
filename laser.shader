shader_type canvas_item;

float line(vec2 uv, float t) {
    uv.x = .0;
    float il = length(uv-.5);
    float l = smoothstep(.7+sin(t*5.)*.0075,.4,il);
    l += smoothstep(.505,.5,il)/2.;
    return l;
}

float wobble(vec2 uv, float t, float amp, float freq, float width) {
    float il = length(vec2(uv.y-.5)+sin((uv.x-t)*freq)*amp);
    float l = smoothstep(width,width-.05,il);
    return l;
}

void fragment() {
    vec3 col = vec3(.9,.1,.1);

    float fx = line(UV, TIME);
    fx += wobble(UV, TIME*2., .1, 10.,.04);
    fx += wobble(UV, TIME*1.456, .3, 12.,.03);
    fx += wobble(UV, TIME*0.876, .2, 14.,.025);
    fx += wobble(UV, TIME, .15, 8.,.03);

    col *= fx;
    if (fx > 1.)
        col.gb += col.r/2.;

    COLOR = vec4(col,fx);
}