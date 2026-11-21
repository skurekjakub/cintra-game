// HD-2D spike: shows a character SubViewport as a crisp pixel-art billboard.
// - Nearest sampling, snapped to texel centres.
// - 1-texel dark outline generated from the alpha of the 4 neighbours.
// - "Upright depth": each vertex slides along its own view ray until it sits above the feet,
//   so the sprite occludes and is occluded like a standing figure, while its screen
//   projection stays exactly the camera-facing quad (texel grid unchanged).
shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque, shadows_disabled, fog_disabled;

uniform sampler2D tex : source_color, filter_nearest;
uniform vec2 tex_size = vec2(48.0, 48.0);
uniform vec4 outline_color : source_color = vec4(0.06, 0.03, 0.07, 1.0);
uniform vec3 feet_world = vec3(0.0);
uniform float depth_bias = 0.3;
uniform float brightness = 1.0;
uniform vec3 tint : source_color = vec3(1.0);

void vertex() {
	vec3 w = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 to_cam = normalize(CAMERA_POSITION_WORLD - w);
	vec2 hc = to_cam.xz;
	float hl = max(length(hc), 0.001);
	float back = -dot((w - feet_world).xz, hc / hl);
	w += to_cam * (back / hl + depth_bias);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(w, 1.0);
}

float a_at(vec2 uv) {
	return texture(tex, uv).a;
}

void fragment() {
	vec2 px = 1.0 / tex_size;
	vec2 uv = (floor(UV * tex_size) + 0.5) * px;
	vec4 c = texture(tex, uv);
	if (c.a < 0.5) {
		float n = a_at(uv + vec2(px.x, 0.0)) + a_at(uv - vec2(px.x, 0.0))
			+ a_at(uv + vec2(0.0, px.y)) + a_at(uv - vec2(0.0, px.y));
		if (n < 0.5) {
			discard;
		}
		ALBEDO = outline_color.rgb;
	} else {
		ALBEDO = c.rgb * tint * brightness;
	}
}
