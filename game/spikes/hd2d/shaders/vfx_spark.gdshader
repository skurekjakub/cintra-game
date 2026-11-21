// HD-2D spike: procedural hit-spark starburst on a camera-facing quad.
shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, shadows_disabled, fog_disabled;

uniform vec3 color : source_color = vec3(1.0, 0.82, 0.35);
uniform vec3 core_color : source_color = vec3(1.0, 1.0, 0.9);
uniform float intensity = 3.0;
uniform int rays = 11;
uniform float seed = 3.0;

float hash(float n) {
	return fract(sin(n * 127.1 + seed * 311.7) * 43758.5453);
}

void fragment() {
	vec2 p = UV * 2.0 - 1.0;
	float r = length(p);
	float ang = atan(p.y, p.x);
	float acc = 0.0;
	for (int i = 0; i < rays; i++) {
		float fi = float(i);
		float a0 = fi / float(rays) * 6.2831 + (hash(fi) - 0.5) * 0.5;
		float len = 0.35 + 0.65 * hash(fi + 17.0);
		float d = abs(mod(ang - a0 + 3.14159, 6.28318) - 3.14159);
		float perp = r * sin(min(d, 1.57));
		float w = mix(0.05, 0.004, r / len);
		float ray = (1.0 - smoothstep(0.0, w, perp)) * (1.0 - smoothstep(len * 0.6, len, r));
		acc += ray * step(d, 1.5);
	}
	float core = exp(-r * r * 40.0);
	float halo = exp(-r * r * 6.0) * 0.25;
	vec3 col = mix(color, core_color, clamp(core * 1.5, 0.0, 1.0));
	ALBEDO = col * intensity;
	ALPHA = clamp(acc + core + halo, 0.0, 1.0);
}
