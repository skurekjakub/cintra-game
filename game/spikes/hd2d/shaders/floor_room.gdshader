// HD-2D spike (A10): one unique baked floor for a whole room (art-src/env/bake_taproom_floor.py).
// World XZ maps onto the room rect, so nothing tiles. Offset-mapped relief from the height map,
// puddles and wet streaks come from the roughness map (SSR picks them up).
shader_type spatial;
render_mode world_vertex_coords;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_disable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic, repeat_disable;
uniform sampler2D rough_tex : hint_default_white, filter_linear_mipmap_anisotropic, repeat_disable;
uniform sampler2D ao_tex : hint_default_white, filter_linear_mipmap_anisotropic, repeat_disable;
uniform sampler2D height_tex : hint_default_white, filter_linear_mipmap, repeat_disable;
uniform vec2 rect_min = vec2(-8.1, -5.65);
uniform vec2 rect_size = vec2(16.2, 11.3);
uniform vec3 tint : source_color = vec3(1.0);
uniform float normal_strength = 1.0;
uniform float relief = 0.03;
uniform float rough_mul = 1.0;

varying vec3 wp;
varying float th;

void vertex() {
	wp = VERTEX;
	th = hd_bend_theta(VERTEX);
	VERTEX = hd_bend_point(VERTEX);
	NORMAL = hd_bend_dir(NORMAL, th);
	TANGENT = hd_bend_dir(TANGENT, th);
	BINORMAL = hd_bend_dir(BINORMAL, th);
}

void fragment() {
	vec2 uv = (wp.xz - rect_min) / rect_size;
	vec3 view_w = normalize((INV_VIEW_MATRIX * vec4(VIEW, 0.0)).xyz);
	float h = texture(height_tex, uv).r;
	uv += view_w.xz / max(view_w.y, 0.3) * (h - 0.66) * relief / rect_size;
	vec3 tn = texture(normal_tex, uv).xyz * 2.0 - 1.0;
	tn.xy *= normal_strength;
	vec3 nw = normalize(vec3(tn.x, tn.z, -tn.y));
	nw = hd_bend_dir(nw, th);
	NORMAL = normalize((VIEW_MATRIX * vec4(nw, 0.0)).xyz);
	ALBEDO = texture(albedo_tex, uv).rgb * tint;
	float r = texture(rough_tex, uv).r;
	ROUGHNESS = clamp(r * rough_mul, 0.02, 1.0);
	AO = texture(ao_tex, uv).r;
	AO_LIGHT_AFFECT = 0.55;
	SPECULAR = mix(0.6, 0.5, r);
}
