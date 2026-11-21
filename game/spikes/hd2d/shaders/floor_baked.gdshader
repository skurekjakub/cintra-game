// HD-2D spike: baked carved-stone floor panels (art-src/bake_floors.py) with offset-mapped
// relief, world-mapped so panels tile across any floor mesh, plus wet sheen from roughness.
shader_type spatial;
render_mode world_vertex_coords;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D rough_tex : hint_default_white, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D ao_tex : hint_default_white, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D height_tex : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform float panel = 3.0;
uniform vec3 tint : source_color = vec3(1.0);
uniform float normal_strength = 1.2;
uniform float relief = 0.035;
uniform vec2 offset = vec2(0.0);

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
	vec2 uv = (wp.xz + offset) / panel;
	vec3 view_w = normalize((INV_VIEW_MATRIX * vec4(VIEW, 0.0)).xyz);
	float h = texture(height_tex, uv).r;
	uv += view_w.xz / max(view_w.y, 0.3) * (h - 0.8) * relief / panel;
	vec3 tn = texture(normal_tex, uv).xyz * 2.0 - 1.0;
	tn.xy *= normal_strength;
	vec3 nw = normalize(vec3(tn.x, tn.z, -tn.y));
	nw = hd_bend_dir(nw, th);
	NORMAL = normalize((VIEW_MATRIX * vec4(nw, 0.0)).xyz);
	ALBEDO = texture(albedo_tex, uv).rgb * tint;
	ROUGHNESS = texture(rough_tex, uv).r;
	AO = texture(ao_tex, uv).r;
	AO_LIGHT_AFFECT = 0.5;
	SPECULAR = 0.5;
}
