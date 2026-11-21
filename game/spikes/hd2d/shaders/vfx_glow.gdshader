// HD-2D spike: soft additive glow disc (wisps, candle halos, rune motes).
shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, shadows_disabled, fog_disabled;

uniform vec3 color : source_color = vec3(0.4, 0.7, 1.0);
uniform float intensity = 4.0;
uniform float core = 30.0;
uniform float halo = 5.0;

void fragment() {
	vec2 p = UV * 2.0 - 1.0;
	float r2 = dot(p, p);
	float a = exp(-r2 * core) + exp(-r2 * halo) * 0.35;
	a *= 1.0 - smoothstep(0.8, 1.0, sqrt(r2));
	ALBEDO = mix(color, vec3(1.0), exp(-r2 * core * 2.0)) * intensity;
	ALPHA = clamp(a, 0.0, 1.0);
}
