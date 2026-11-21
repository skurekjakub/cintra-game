// HD-2D spike: UV-mapped props (KayKit palette atlases) with a triplanar photo detail overlay
// so stylised meshes pick up real grain under real lighting.
shader_type spatial;
render_mode world_vertex_coords;
#include "res://spikes/hd2d/shaders/bend.gdshaderinc"

uniform sampler2D albedo_tex : source_color, hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec3 tint : source_color = vec3(1.0);
uniform sampler2D detail_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D detail_normal : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform float detail_strength = 0.0;
uniform float detail_scale = 1.0;
uniform float roughness = 0.75;
uniform float metallic = 0.0;
uniform float emission = 0.0;

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

void fragment() {
	vec3 base = texture(albedo_tex, UV).rgb * tint;
	if (detail_strength > 0.0) {
		vec3 n0 = normalize(wn);
		vec3 bw = pow(abs(n0), vec3(6.0));
		bw /= (bw.x + bw.y + bw.z);
		vec3 d = texture(detail_tex, wp.zy / detail_scale).rgb * bw.x + texture(detail_tex, wp.xz / detail_scale).rgb * bw.y + texture(detail_tex, wp.xy / detail_scale).rgb * bw.z;
		float l = dot(d, vec3(0.333));
		base *= mix(1.0, l * 2.2, detail_strength);
		vec3 tx = texture(detail_normal, wp.zy / detail_scale).xyz * 2.0 - 1.0;
		vec3 ty = texture(detail_normal, wp.xz / detail_scale).xyz * 2.0 - 1.0;
		vec3 tz = texture(detail_normal, wp.xy / detail_scale).xyz * 2.0 - 1.0;
		tx = vec3(tx.xy + n0.zy, abs(tx.z) * n0.x);
		ty = vec3(ty.xy + n0.xz, abs(ty.z) * n0.y);
		tz = vec3(tz.xy + n0.xy, abs(tz.z) * n0.z);
		vec3 nw = normalize(tx.zyx * bw.x + ty.xzy * bw.y + tz.xyz * bw.z);
		nw = normalize(mix(n0, nw, detail_strength));
		NORMAL = normalize((VIEW_MATRIX * vec4(hd_bend_dir(nw, th), 0.0)).xyz);
	}
	ALBEDO = base;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	EMISSION = base * emission;
}
