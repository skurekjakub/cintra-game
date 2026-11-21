// HD-2D spike: crescent sword-slash arc on a ring-sector mesh (vfx.gd builds it).
// UV.x runs along the arc: 0 = tail, 1 = blade head. UV.y runs across: 0 = inner edge, 1 = outer edge.
shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, shadows_disabled, fog_disabled;

uniform vec3 edge_color : source_color = vec3(1.0, 0.04, 0.12);
uniform vec3 core_color : source_color = vec3(1.0, 0.75, 0.75);
uniform float intensity = 5.0;
uniform float head = 0.86;

void fragment() {
	float u = UV.x;
	float v = UV.y;
	// Crescent: thin tail, fat body near the head, sharp rounded tip.
	float body = smoothstep(0.0, head, u) * (1.0 - smoothstep(head, 1.0, u));
	float width = mix(0.04, 1.0, body);
	float inner = 1.0 - width;
	float band = smoothstep(inner, inner + 0.55 * width + 0.01, v) * (1.0 - smoothstep(0.93, 1.0, v));
	float hot = smoothstep(0.82, 0.97, v) * smoothstep(0.35, 0.95, u);
	float streak = 0.9 + 0.1 * sin(v * 40.0 + u * 6.0);
	vec3 col = mix(edge_color, core_color, hot);
	float a = band * (0.25 + 0.75 * smoothstep(0.0, 0.7, u)) * streak;
	ALBEDO = col * intensity;
	ALPHA = clamp(a, 0.0, 1.0);
}
