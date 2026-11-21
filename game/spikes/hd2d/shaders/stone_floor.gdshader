// HD-2D spike: world-mapped stone floor.
// Photo detail (CC0 Poly Haven set) + a procedural height field for large tiles, carved
// ornament panels, cracks, worn edges and damp stains. The height field is turned into a
// normal by finite differences, so point lights rake across the carving.
shader_type spatial;
render_mode cull_back;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D rough_tex : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform sampler2D ao_tex : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform float tex_scale = 2.0;
uniform vec3 tint : source_color = vec3(1.0);
uniform float tex_normal_strength = 1.0;

uniform bool use_grid = false;
uniform float tile = 1.0;
uniform bool ornament = false;
uniform float ornament_group = 3.0;
uniform float carve_depth = 1.0;
uniform float height_strength = 0.9;
uniform float tile_variation = 0.14;
uniform float crack_amount = 0.5;
uniform float damp_amount = 0.6;
uniform float damp_scale = 0.18;
uniform vec3 groove_dirt : source_color = vec3(0.25, 0.2, 0.22);

varying vec3 wpos;

float h21(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 h22(vec2 p) {
	return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(h21(i), h21(i + vec2(1, 0)), f.x), mix(h21(i + vec2(0, 1)), h21(i + vec2(1, 1)), f.x), f.y);
}

float fbm(vec2 p) {
	float s = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		s += vnoise(p) * a;
		p = p * 2.07 + vec2(1.7, 9.2);
		a *= 0.5;
	}
	return s;
}

// Distance to the nearest Voronoi edge (for crack lines).
float voronoi_edge(vec2 p) {
	vec2 n = floor(p);
	vec2 f = fract(p);
	vec2 mr = vec2(0.0);
	float md = 8.0;
	for (int j = -1; j <= 1; j++) {
		for (int i = -1; i <= 1; i++) {
			vec2 g = vec2(float(i), float(j));
			vec2 r = g + h22(n + g) - f;
			float d = dot(r, r);
			if (d < md) {
				md = d;
				mr = r;
			}
		}
	}
	md = 8.0;
	for (int j = -1; j <= 1; j++) {
		for (int i = -1; i <= 1; i++) {
			vec2 g = vec2(float(i), float(j));
			vec2 r = g + h22(n + g) - f;
			if (dot(mr - r, mr - r) > 0.0001) {
				md = min(md, dot(0.5 * (mr + r), normalize(r - mr)));
			}
		}
	}
	return md;
}

float groove(float d, float w) {
	return 1.0 - smoothstep(w * 0.55, w, abs(d));
}

// 0..1 carving mask for one ornament panel; lp is metres from the panel centre.
float carving(vec2 lp) {
	float half_g = ornament_group * tile * 0.5;
	float ax = abs(lp.x);
	float ay = abs(lp.y);
	float oct = max(max(ax, ay), (ax + ay) * 0.7071);
	float c = 0.0;
	c = max(c, groove(oct - half_g * 0.80, 0.055));
	c = max(c, groove(oct - half_g * 0.68, 0.035));
	// Interlaced lattice inside the inner octagon.
	float u = (lp.x + lp.y) * 0.7071;
	float v = (lp.x - lp.y) * 0.7071;
	float cell = half_g * 0.3;
	float lu = abs(fract(u / cell) - 0.5) * cell;
	float lv = abs(fract(v / cell) - 0.5) * cell;
	float lattice = max(groove(lu, 0.03), groove(lv, 0.03)) * step(oct, half_g * 0.6);
	c = max(c, lattice);
	// Central rosette.
	float r = length(lp);
	c = max(c, groove(r - half_g * 0.2, 0.03));
	c = max(c, groove(ax + ay - half_g * 0.12, 0.03));
	// Quarter-round flourishes at the panel corners.
	vec2 corner = vec2(half_g) - vec2(ax, ay);
	c = max(c, groove(length(corner) - half_g * 0.32, 0.035) * step(oct, half_g * 1.2));
	return c;
}

float height(vec2 p, out float grout, out float carve, out float crack) {
	float h = 0.0;
	grout = 0.0;
	carve = 0.0;
	crack = 0.0;
	if (use_grid) {
		vec2 tp = p / tile;
		vec2 id = floor(tp);
		vec2 q = fract(tp) - 0.5;
		float wear = vnoise(p * 9.0) * 0.05;
		float e = 0.5 - max(abs(q.x), abs(q.y));
		float bevel = smoothstep(0.0, 0.05, e * tile - 0.008 + wear * 0.6);
		grout = 1.0 - bevel;
		vec2 tilt = (h22(id) - 0.5) * 0.06;
		h += bevel * (0.6 + (h21(id + 3.1) - 0.5) * 0.25 + dot(q, tilt));
		if (ornament) {
			vec2 gp = p / (tile * ornament_group);
			vec2 lp = (fract(gp) - 0.5) * tile * ornament_group;
			carve = carving(lp) * bevel;
			h -= carve * 0.22 * carve_depth;
		}
	}
	return h;
}

void vertex() {
	wpos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 p = wpos.xz;
	float grout;
	float carve;
	float crack;
	float g2;
	float c2;
	float k2;
	float eps = 0.006;
	float h0 = height(p, grout, carve, crack);
	if (crack_amount > 0.0) {
		vec2 cp = p * 1.6 + vec2(vnoise(p * 1.3), vnoise(p * 1.3 + 7.0)) * 0.6;
		float ce = voronoi_edge(cp);
		float mask = smoothstep(0.55, 0.75, fbm(p * 0.7 + 3.0)) * crack_amount;
		crack = (1.0 - smoothstep(0.0, 0.02, ce)) * mask;
	}
	float hx = height(p + vec2(eps, 0.0), g2, c2, k2);
	float hz = height(p + vec2(0.0, eps), g2, c2, k2);
	vec2 grad = vec2(hx - h0, hz - h0) / eps * height_strength * 0.06;

	vec2 tuv = p / tex_scale;
	vec2 id = use_grid ? floor(p / tile) : vec2(0.0);
	if (use_grid) {
		tuv += h22(id + 5.0) * 3.0;
	}
	vec3 alb = texture(albedo_tex, tuv).rgb * tint;
	float var = (h21(id + 11.0) - 0.5) * tile_variation;
	alb *= 1.0 + var;
	alb = mix(alb, groove_dirt * alb * 1.4, carve * 0.75);
	alb *= mix(1.0, 0.25, grout);
	alb *= mix(1.0, 0.35, crack);
	vec3 tn = texture(normal_tex, tuv).rgb * 2.0 - 1.0;
	tn.xy *= tex_normal_strength;
	float rough = texture(rough_tex, tuv).r;
	float ao = texture(ao_tex, tuv).r;

	float damp = smoothstep(0.45, 0.75, fbm(p * damp_scale + vec2(4.0, 1.0))) * damp_amount;
	damp = max(damp, grout * 0.6 * damp_amount);
	alb *= mix(1.0, 0.55, damp);
	rough = mix(rough, 0.18, damp);

	vec3 n_world = normalize(vec3(tn.x - grad.x, max(tn.z, 0.2), -tn.y - grad.y));
	NORMAL = normalize((VIEW_MATRIX * vec4(n_world, 0.0)).xyz);
	ALBEDO = alb;
	ROUGHNESS = clamp(rough, 0.05, 1.0);
	AO = ao * mix(1.0, 0.45, max(carve, grout));
	AO_LIGHT_AFFECT = 0.4;
	SPECULAR = 0.45;
}
