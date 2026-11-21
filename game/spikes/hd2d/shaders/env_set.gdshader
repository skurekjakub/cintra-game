// HD-2D spike (A10): world-space triplanar PBR for the bespoke Blender set pieces, driven by the
// vertex colours baked in art-src/env/envlib.py:
//   R = cavity / contact darkening (multiplier), G = edge wear (rubbed lighter),
//   B = grime / soot (toward grime_color, rougher), A = wet (darker, glossy).
// Plus a large-scale value variation (macro) so long timbers and plaster never read flat.
shader_type spatial;
render_mode world_vertex_coords;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D rough_tex : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec3 tint : source_color = vec3(1.0);
uniform float desat = 0.0;
uniform float scale = 2.0;
uniform float rough_mul = 1.0;
uniform float normal_strength = 1.0;
uniform float sharpness = 6.0;
uniform float metallic = 0.0;
uniform float cavity = 1.0;
uniform float edge_wear = 0.6;
uniform vec3 edge_tint : source_color = vec3(1.45, 1.25, 1.02);
uniform float grime = 0.85;
uniform vec3 grime_color : source_color = vec3(0.045, 0.036, 0.03);
uniform float wet = 1.0;
uniform float macro = 0.35;
uniform float emission = 0.0;

varying vec3 wp;
varying vec3 wn;
varying float th;
varying vec4 vc;

void vertex() {
	wp = VERTEX;
	wn = NORMAL;
	vc = COLOR;
	th = hd_bend_theta(VERTEX);
	VERTEX = hd_bend_point(VERTEX);
	NORMAL = hd_bend_dir(NORMAL, th);
	TANGENT = hd_bend_dir(TANGENT, th);
	BINORMAL = hd_bend_dir(BINORMAL, th);
}

vec3 unpack_n(vec4 t) {
	vec3 n = t.xyz * 2.0 - 1.0;
	n.xy *= normal_strength;
	return n;
}

void fragment() {
	vec3 n0 = normalize(wn);
	vec3 bw = pow(abs(n0), vec3(sharpness));
	bw /= (bw.x + bw.y + bw.z);
	vec2 ux = wp.zy / scale;
	vec2 uy = wp.xz / scale;
	vec2 uz = wp.xy / scale;
	vec3 alb = texture(albedo_tex, ux).rgb * bw.x + texture(albedo_tex, uy).rgb * bw.y + texture(albedo_tex, uz).rgb * bw.z;
	float rough = texture(rough_tex, ux).r * bw.x + texture(rough_tex, uy).r * bw.y + texture(rough_tex, uz).r * bw.z;
	vec3 tx = unpack_n(texture(normal_tex, ux));
	vec3 ty = unpack_n(texture(normal_tex, uy));
	vec3 tz = unpack_n(texture(normal_tex, uz));
	tx = vec3(tx.xy + n0.zy, abs(tx.z) * n0.x);
	ty = vec3(ty.xy + n0.xz, abs(ty.z) * n0.y);
	tz = vec3(tz.xy + n0.xy, abs(tz.z) * n0.z);
	vec3 nw = normalize(tx.zyx * bw.x + ty.xzy * bw.y + tz.xyz * bw.z);
	nw = hd_bend_dir(nw, th);
	NORMAL = normalize((VIEW_MATRIX * vec4(nw, 0.0)).xyz);

	float l = dot(alb, vec3(0.333));
	alb = mix(alb, vec3(l), desat) * tint;
	// macro variation: the same photo sampled ~9x larger, as a luminance multiplier
	vec3 m3 = texture(albedo_tex, ux * 0.11 + 0.31).rgb * bw.x + texture(albedo_tex, uy * 0.11 + 0.57).rgb * bw.y
			+ texture(albedo_tex, uz * 0.11 + 0.13).rgb * bw.z;
	float m = dot(m3, vec3(0.333));
	alb *= mix(1.0, 0.55 + 1.0 * m, macro);
	alb *= mix(1.0, vc.r, cavity);
	alb = mix(alb, alb * edge_tint, clamp(vc.g * edge_wear, 0.0, 1.0));
	float g = clamp(vc.b * grime, 0.0, 1.0);
	alb = mix(alb, grime_color * (0.7 + 0.6 * l), g * 0.85);
	rough = mix(rough * rough_mul, 0.95, g * 0.4);
	float w = clamp(vc.a * wet, 0.0, 1.0);
	alb *= mix(1.0, 0.5, w);
	rough = mix(rough, 0.1, w);

	ALBEDO = alb;
	ROUGHNESS = clamp(rough, 0.04, 1.0);
	METALLIC = metallic;
	EMISSION = alb * emission;
}
