// HD-2D spike (A10): old crown / wavy window glass. Thin, slightly green, glossy; the normal ripples
// so lantern and moon highlights break up, and a faint cold glow says "night outside".
// Never casts shadows (the node turns them off) so moonlight still streams through.
shader_type spatial;
render_mode world_vertex_coords, blend_mix, cull_disabled, depth_draw_never;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform vec3 tint : source_color = vec3(0.16, 0.22, 0.24);
uniform float alpha = 0.28;
uniform vec3 night : source_color = vec3(0.25, 0.35, 0.7);
uniform float night_glow = 0.12;

varying vec3 wp;
varying float th;

void vertex() {
	wp = VERTEX;
	th = hd_bend_theta(VERTEX);
	VERTEX = hd_bend_point(VERTEX);
	NORMAL = hd_bend_dir(NORMAL, th);
}

void fragment() {
	vec2 p = vec2(wp.x + wp.z, wp.y) * 28.0;
	vec2 rip = vec2(sin(p.x * 1.3 + sin(p.y * 0.7) * 2.0), sin(p.y * 1.1 + sin(p.x * 0.6) * 1.7)) * 0.18;
	NORMAL = normalize(NORMAL + vec3(rip.x, rip.y, 0.0));
	ALBEDO = tint;
	ALPHA = alpha;
	ROUGHNESS = 0.04;
	SPECULAR = 0.9;
	EMISSION = night * night_glow * (0.7 + 0.3 * sin(p.x * 0.3 + p.y * 0.2));
}
