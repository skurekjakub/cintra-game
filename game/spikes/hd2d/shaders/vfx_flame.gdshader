// HD-2D spike: procedural flame on a camera-facing quad (hearth, candles, braziers).
shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, shadows_disabled, fog_disabled;

uniform vec3 hot : source_color = vec3(1.0, 0.9, 0.55);
uniform vec3 mid : source_color = vec3(1.0, 0.45, 0.08);
uniform vec3 cool : source_color = vec3(0.7, 0.08, 0.02);
uniform float intensity = 4.0;
uniform float seed = 0.0;
uniform float tongues = 3.0;

float h21(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7)) + seed) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(h21(i), h21(i + vec2(1, 0)), f.x), mix(h21(i + vec2(0, 1)), h21(i + vec2(1, 1)), f.x), f.y);
}

float fbm(vec2 p) {
	float s = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		s += noise(p) * a;
		p *= 2.03;
		a *= 0.5;
	}
	return s;
}

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	float t = TIME * 1.6 + seed;
	float n = fbm(vec2(uv.x * tongues, uv.y * 2.2 - t));
	float x = (uv.x - 0.5) * 2.0;
	// Teardrop envelope narrowing with height, broken up by rising noise.
	float env = 1.0 - smoothstep(0.0, 1.0, abs(x) / max(0.05, 1.0 - uv.y * 0.9));
	float f = env * (1.0 - uv.y) * 1.6 + (n - 0.5) * 0.9 - uv.y * 0.35;
	f = clamp(f, 0.0, 1.0);
	vec3 col = mix(cool, mid, smoothstep(0.1, 0.45, f));
	col = mix(col, hot, smoothstep(0.55, 0.9, f));
	ALBEDO = col * intensity;
	ALPHA = smoothstep(0.08, 0.35, f);
}
