// HD-2D spike: world-space triplanar PBR for walls, beams, furniture (high-res, smooth filtering).
shader_type spatial;
render_mode world_vertex_coords;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D rough_tex : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform sampler2D ao_tex : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec3 tint : source_color = vec3(1.0);
uniform float scale = 2.0;
uniform float rough_mul = 1.0;
uniform float normal_strength = 1.0;
uniform float sharpness = 6.0;
uniform float edge_wear = 0.0;

varying vec3 wp;
varying vec3 wn;
varying float th;

void vertex() {
	wp = VERTEX;
	wn = NORMAL;
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
	float ao = texture(ao_tex, ux).r * bw.x + texture(ao_tex, uy).r * bw.y + texture(ao_tex, uz).r * bw.z;
	vec3 tx = unpack_n(texture(normal_tex, ux));
	vec3 ty = unpack_n(texture(normal_tex, uy));
	vec3 tz = unpack_n(texture(normal_tex, uz));
	tx = vec3(tx.xy + n0.zy, abs(tx.z) * n0.x);
	ty = vec3(ty.xy + n0.xz, abs(ty.z) * n0.y);
	tz = vec3(tz.xy + n0.xy, abs(tz.z) * n0.z);
	vec3 nw = normalize(tx.zyx * bw.x + ty.xzy * bw.y + tz.xyz * bw.z);
	nw = hd_bend_dir(nw, th);
	NORMAL = normalize((VIEW_MATRIX * vec4(nw, 0.0)).xyz);
	ALBEDO = alb * tint;
	ROUGHNESS = clamp(rough * rough_mul, 0.05, 1.0);
	AO = ao;
	AO_LIGHT_AFFECT = 0.35;
}
