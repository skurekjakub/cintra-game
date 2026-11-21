// HD-2D spike (A10): hand-placed light shaft (god ray) through a window or door. A box mesh swept
// along the light direction; UV.y = 0 at the opening -> 1 at the far end. Additive, soft edges,
// slow drifting dust bands. Works with the volumetric fog, which only gives faint shafts on the
// Adreno budget. Bent with the world so it stays glued to its window.
shader_type spatial;
render_mode world_vertex_coords, blend_add, unshaded, cull_disabled, depth_draw_never, shadows_disabled, fog_disabled;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform vec3 color : source_color = vec3(0.45, 0.58, 1.0);
uniform float intensity = 0.35;
uniform float seed = 0.0;
uniform float edge_soft = 0.45;

varying vec3 wp;

void vertex() {
	wp = VERTEX;
	VERTEX = hd_bend_point(VERTEX);
}

void fragment() {
	float along = clamp(UV.y, 0.0, 1.0);
	float across = clamp(abs(UV.x - 0.5) * 2.0, 0.0, 1.0);
	float edge = 1.0 - smoothstep(1.0 - edge_soft, 1.0, across);
	float fall = smoothstep(0.0, 0.08, along) * pow(max(1.0 - along, 0.0), 1.6);
	float bands = 0.65 + 0.35 * sin(UV.x * 23.0 + seed * 3.1 + wp.y * 2.0) * sin(UV.x * 9.0 - seed);
	// view-angle fade: faces seen edge-on are less dense
	float facing = abs(dot(normalize(NORMAL + vec3(0.0, 0.0, 1e-4)), VIEW));
	float a = edge * fall * bands * mix(0.35, 1.0, facing);
	ALBEDO = color * intensity * a;
}
