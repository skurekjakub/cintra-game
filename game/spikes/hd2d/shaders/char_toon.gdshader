// HD-2D spike: stepped toon shading for low-poly character parts.
// Rendered inside a tiny SubViewport, so every output pixel becomes one sprite texel.
// Lighting is passed in from the main scene (pixel_sprite.gd samples the nearest lights),
// which keeps the sprite consistent with the 3D world it stands in.
shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque;

instance uniform vec3 albedo : source_color = vec3(1.0);
instance uniform float emissive = 0.0;

// Textured rigs (KayKit palette atlases): sampled nearest, then recoloured per role.
uniform bool use_tex = false;
uniform sampler2D albedo_tex : source_color, filter_nearest;
uniform float hue_shift = 0.0;
uniform float sat_mul = 1.0;
uniform float val_mul = 1.0;
// Up to 4 palette swaps: any texel within swap_tol of from_i becomes to_i (keeps shading).
uniform vec3 swap_from[4];
uniform vec3 swap_to[4];
uniform int swap_count = 0;
uniform float swap_tol = 0.12;

uniform vec3 ambient : source_color = vec3(0.18, 0.14, 0.24);
uniform vec3 key_dir = vec3(0.4, 0.8, 0.4);
uniform vec3 key_color : source_color = vec3(1.0, 0.7, 0.45);
uniform vec3 fill_dir = vec3(-0.6, 0.5, -0.2);
uniform vec3 fill_color : source_color = vec3(0.3, 0.35, 0.7);
uniform vec3 rim_color : source_color = vec3(1.0, 0.65, 0.35);
uniform vec3 rim_dir = vec3(0.0, 0.3, -1.0);
uniform float steps = 3.0;

float band(float d) {
	// Three hard bands: shadow, mid, lit. No smooth gradient survives the downscale anyway.
	float x = clamp(d, 0.0, 1.0);
	return floor(x * steps + 0.35) / steps;
}

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
	return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

vec3 base_color(vec2 uv) {
	if (!use_tex) {
		return albedo;
	}
	vec3 t = texture(albedo_tex, uv).rgb;
	for (int i = 0; i < swap_count; i++) {
		if (distance(t, swap_from[i]) < swap_tol) {
			float k = dot(t, vec3(0.333)) / max(dot(swap_from[i], vec3(0.333)), 0.01);
			t = swap_to[i] * k;
		}
	}
	vec3 h = rgb2hsv(t);
	h.x = fract(h.x + hue_shift);
	h.y = clamp(h.y * sat_mul, 0.0, 1.0);
	h.z *= val_mul;
	return hsv2rgb(h) * albedo;
}

void fragment() {
	vec3 n = normalize((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	vec3 light = ambient;
	light += key_color * band(dot(n, normalize(key_dir)));
	light += fill_color * band(dot(n, normalize(fill_dir))) * 0.6;
	float fres = 1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0);
	float rim = step(0.52, fres) * step(0.05, dot(n, normalize(rim_dir)));
	light += rim_color * rim * 1.1;
	vec3 base = base_color(UV);
	vec3 c = base * light;
	c = mix(c, base * 1.4, emissive);
	ALBEDO = c;
}
