shader_type canvas_item;

uniform vec2 square = vec2(10, 10);
uniform vec2 direction = vec2(1.0, -0.5);
uniform float smoothness = 1.6;
uniform float progress : hint_range(0, 1);

void fragment() {
	vec2 p = UV;
	vec2 center = vec2(0.5);
	vec2 v = normalize(direction);
	v /= abs(v.x) + abs(v.y);
	float d = v.x * center.x + v.y * center.y;
	float offset = smoothness;
	float pr = smoothstep(-offset, 0.0, v.x * p.x + v.y * p.y - (d - 0.5 + progress * (1.0 + offset)));
	vec2 squarep = fract(p * vec2(square));
	vec2 squaremin = vec2(pr / 2.0);
	vec2 squaremax = vec2(1.0 - pr / 2.0);
	float a = (1.0 - step(progress, 0.0)) * step(squaremin.x, squarep.x) * step(squaremin.y, squarep.y) * step(squarep.x, squaremax.x) * step(squarep.y, squaremax.y);
	COLOR = mix(texture(TEXTURE, p), vec4(0.0), a);
}
