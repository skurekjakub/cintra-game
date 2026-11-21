// HD-2D spike (A10): UV-mapped PBR for Poly Haven CC0 props and plain-colour set pieces, bent with
// the world. Keeps the model's own albedo / normal / ORM (glTF occlusion-roughness-metallic) maps.
// Vertex colours (when present) follow env_set.gdshader: R cavity, G edge wear, B grime, A wet.
shader_type spatial;
render_mode world_vertex_coords;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform sampler2D albedo_tex : source_color, hint_default_white, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D orm_tex : hint_default_white, filter_linear_mipmap_anisotropic, repeat_enable;
uniform bool use_normal = false;
uniform bool use_orm = false;
uniform vec3 albedo_color : source_color = vec3(1.0);
uniform vec3 tint : source_color = vec3(1.0);
uniform float roughness = 0.8;
uniform float metallic = 0.0;
uniform float normal_scale = 1.0;
uniform vec3 emission_color : source_color = vec3(1.0, 0.6, 0.3);
uniform float emission = 0.0;
uniform float cavity = 1.0;
uniform float edge_wear = 0.3;
uniform float grime = 0.6;
uniform vec3 grime_color : source_color = vec3(0.045, 0.036, 0.03);
uniform float wet = 1.0;
uniform float sheen = 0.0;
uniform float rough_min = 0.0;

varying float th;
varying vec4 vc;

void vertex() {
	vc = COLOR;
	th = hd_bend_theta(VERTEX);
	VERTEX = hd_bend_point(VERTEX);
	NORMAL = hd_bend_dir(NORMAL, th);
	TANGENT = hd_bend_dir(TANGENT, th);
	BINORMAL = hd_bend_dir(BINORMAL, th);
}

void fragment() {
	vec3 alb = texture(albedo_tex, UV).rgb * albedo_color * tint;
	float rough = roughness;
	float met = metallic;
	if (use_orm) {
		vec3 orm = texture(orm_tex, UV).rgb;
		AO = orm.r;
		AO_LIGHT_AFFECT = 0.4;
		rough = max(orm.g * roughness, rough_min);
		met = orm.b * metallic;
	}
	if (use_normal) {
		NORMAL_MAP = texture(normal_tex, UV).rgb;
		NORMAL_MAP_DEPTH = normal_scale;
	}
	alb *= mix(1.0, vc.r, cavity);
	alb = mix(alb, alb * 1.4, clamp(vc.g * edge_wear, 0.0, 1.0));
	float g = clamp(vc.b * grime, 0.0, 1.0);
	alb = mix(alb, grime_color, g * 0.7);
	float w = clamp(vc.a * wet, 0.0, 1.0);
	alb *= mix(1.0, 0.55, w);
	rough = mix(rough, 0.1, w);
	ALBEDO = alb;
	ROUGHNESS = clamp(rough, 0.03, 1.0);
	METALLIC = met;
	SPECULAR = 0.5 + sheen;
	EMISSION = emission_color * emission;
}
