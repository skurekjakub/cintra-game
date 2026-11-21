// HD-2D spike: soft elliptical contact shadow under a billboard sprite.
shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_never, cull_disabled, shadows_disabled, fog_disabled;

uniform float strength = 0.75;
uniform vec3 color : source_color = vec3(0.02, 0.0, 0.03);

void fragment() {
	float d = length(UV - 0.5) * 2.0;
	ALBEDO = color;
	ALPHA = (1.0 - smoothstep(0.15, 1.0, d)) * strength;
}
