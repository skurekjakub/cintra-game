// HD-2D spike: hand-authored pixel sprite lit by the real 3D lights.
// - nearest-sampled art + auto-bevel normal map (art-src/pixel/pixelart.py), so the hearth lights
//   the side of the figure that faces it;
// - stepped (2-band) diffuse + a rim term from lights behind the figure;
// - a little self-illumination so the art never sinks into the dark;
// - alpha scissor, so the card casts a real silhouette shadow onto the 3D floor;
// - "upright depth": vertices slide along their view ray to stand above the feet.
shader_type spatial;
render_mode cull_disabled, depth_draw_opaque, specular_disabled;

uniform sampler2D tex : source_color, filter_nearest;
uniform sampler2D nrm : hint_normal, filter_nearest;
uniform vec3 feet_world = vec3(0.0);
uniform float depth_bias = 0.25;
uniform float self_light = 0.42;
uniform float rim_strength = 1.6;
uniform float hit_flash = 0.0;
uniform bool flip = false;
uniform bool upright = true;

void vertex() {
	if (!upright) {
		POSITION = PROJECTION_MATRIX * VIEW_MATRIX * MODEL_MATRIX * vec4(VERTEX, 1.0);
	} else {
	vec3 w = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 to_cam = normalize(CAMERA_POSITION_WORLD - w);
	vec2 hc = to_cam.xz;
	float hl = max(length(hc), 0.05);
	float back = -dot((w - feet_world).xz, hc / hl);
	w += to_cam * (back / hl + depth_bias);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(w, 1.0);
	}
	if (flip) {
		UV.x = 1.0 - UV.x;
	}
}

void fragment() {
	vec4 c = texture(tex, UV);
	ALPHA = c.a;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
	vec3 base = mix(c.rgb, vec3(1.0), hit_flash);
	ALBEDO = base;
	vec3 n = texture(nrm, UV).rgb;
	if (flip) {
		n.x = 1.0 - n.x;
	}
	NORMAL_MAP = n;
	NORMAL_MAP_DEPTH = 1.0;
	ROUGHNESS = 1.0;
	EMISSION = base * self_light;
}

void light() {
	float ndl = dot(NORMAL, LIGHT);
	float band = smoothstep(-0.05, 0.05, ndl) * 0.55 + smoothstep(0.45, 0.55, ndl) * 0.45;
	vec3 l = LIGHT_COLOR * ATTENUATION;
	DIFFUSE_LIGHT += l * band;
	// Rim: light coming from behind the figure catches the edges the normal map turns sideways.
	float behind = clamp(dot(LIGHT, -VIEW), 0.0, 1.0);
	float edge = smoothstep(0.25, 0.6, 1.0 - NORMAL.z * NORMAL.z);
	float side = clamp(dot(NORMAL.xy, LIGHT.xy) * 2.0, 0.0, 1.0);
	DIFFUSE_LIGHT += l * (behind * 0.6 + 0.4) * edge * side * rim_strength;
}
