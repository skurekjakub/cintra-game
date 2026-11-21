// HD-2D spike: screen-space finishing pass (runs on a full-rect ColorRect under the HUD layer).
// 1. Tilt-shift: blur grows with distance from a horizontal focus band (on top of the camera DOF).
// 2. Split-tone grade: shadows pushed to violet/magenta, highlights to warm amber.
// 3. Vignette and a faint film grain.
shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture, filter_linear_mipmap;
uniform float focus_center = 0.55;
uniform float focus_half = 0.2;
uniform float blur_px = 7.0;
uniform vec3 shadow_tint : source_color = vec3(0.75, 0.62, 1.0);
uniform vec3 high_tint : source_color = vec3(1.08, 0.98, 0.86);
uniform float tone_split = 0.35;
uniform float vignette = 0.6;
uniform float vignette_round = 0.62;
uniform float grain = 0.025;
uniform float lift = 0.0;

vec3 sample_blur(vec2 uv, float amount, vec2 px) {
	if (amount < 0.01) {
		return texture(screen, uv).rgb;
	}
	vec3 acc = vec3(0.0);
	float wsum = 0.0;
	float r = amount * blur_px;
	float lod = log2(max(r * 0.5, 1.0));
	for (int i = 0; i < 12; i++) {
		float a = float(i) * 2.39996;
		float d = sqrt((float(i) + 0.5) / 12.0);
		vec2 o = vec2(cos(a), sin(a)) * d * r * px;
		acc += textureLod(screen, uv + o, lod).rgb;
		wsum += 1.0;
	}
	return acc / wsum;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 px = SCREEN_PIXEL_SIZE;
	float d = max(abs(uv.y - focus_center) - focus_half, 0.0) / max(0.5 - focus_half, 0.01);
	float amount = smoothstep(0.0, 1.0, d);
	vec3 c = sample_blur(uv, amount, px);
	float lum = dot(c, vec3(0.299, 0.587, 0.114));
	vec3 tint = mix(shadow_tint, high_tint, smoothstep(0.0, tone_split, lum));
	c *= tint;
	c += lift * shadow_tint * 0.02;
	vec2 q = (uv - 0.5) * vec2(1.0, vignette_round);
	float v = 1.0 - smoothstep(0.2, 0.78, length(q));
	c *= mix(1.0 - vignette, 1.0, v);
	float g = fract(sin(dot(uv * 1000.0, vec2(12.9898, 78.233))) * 43758.5453) - 0.5;
	c += g * grain;
	COLOR = vec4(c, 1.0);
}
