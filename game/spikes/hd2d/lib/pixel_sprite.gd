extends Node3D
## HD-2D spike: a 3D-rigged character rendered as pixel art.
##
## Pipeline: low-poly model -> own-world SubViewport (tiny, nearest, no AA) seen by an
## orthographic camera with the SAME orientation as the gameplay camera -> ViewportTexture on a
## camera-facing quad in the main world (pixel_sprite.gdshader adds the 1-texel outline and
## upright depth). The quad is sized so one texel covers `pixel_scale` screen pixels at 1080p.
## Toon lighting comes from the nearest real lights, so the sprite is lit like the room.

const TOON := preload("res://spikes/hd2d/shaders/char_toon.gdshader")
const SPRITE := preload("res://spikes/hd2d/shaders/pixel_sprite.gdshader")
const BLOB := preload("res://spikes/hd2d/shaders/blob_shadow.gdshader")

var pixel_scale: float = 2.0
var foot_px: int = 4
var screen_h: float = 1080.0
var shadow_size: Vector2 = Vector2(0.9, 0.55)
var ambient: Color = Color(0.42, 0.34, 0.5)
var fill_color: Color = Color(0.3, 0.3, 0.5)
var fill_dir: Vector3 = Vector3(0.0, 0.6, 1.0)
var rim_boost: float = 1.25
var brightness: float = 1.6
var outline: Color = Color(0.07, 0.03, 0.08)
## Sprites are drawn from a much lower angle than the world camera (classic HD-2D): faces read.
var sprite_pitch: float = 24.0
var model_scale: float = 1.0
var key_strength: float = 0.95

var viewport: SubViewport
var material: ShaderMaterial
var toon: ShaderMaterial
var quad: MeshInstance3D


static func new_toon_material() -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = TOON
	return m


## model: built with `toon` (call new_toon_material first and pass it in).
## facing_deg: yaw of the model in the world. lights: Light3D nodes that may affect it.
func setup(cam: Camera3D, model: Node3D, vp: Vector2i, facing_deg: float, lights: Array[Light3D], mat: ShaderMaterial) -> void:
	toon = mat
	var fwd := -cam.global_basis.z
	var up := cam.global_basis.y
	var dist := (global_position - cam.global_position).dot(fwd)
	var wpp := 2.0 * dist * tan(deg_to_rad(cam.fov) * 0.5) / screen_h
	var texel := wpp * pixel_scale
	var lift := (float(vp.y) * 0.5 - float(foot_px)) * texel

	viewport = SubViewport.new()
	viewport.size = vp
	viewport.transparent_bg = true
	viewport.own_world_3d = true
	viewport.msaa_3d = Viewport.MSAA_DISABLED
	viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.positional_shadow_atlas_size = 0
	add_child(viewport)
	var holder := Node3D.new()
	holder.rotation_degrees.y = facing_deg
	holder.scale = Vector3.ONE * model_scale
	viewport.add_child(holder)
	holder.add_child(model)
	var vcam := Camera3D.new()
	vcam.projection = Camera3D.PROJECTION_ORTHOGONAL
	vcam.size = float(vp.y) * texel
	vcam.near = 0.05
	vcam.far = 60.0
	viewport.add_child(vcam)
	var flat_fwd := Vector3(fwd.x, 0.0, fwd.z).normalized()
	var p := deg_to_rad(sprite_pitch)
	var f2 := flat_fwd * cos(p) + Vector3.DOWN * sin(p)
	var b2 := Basis.looking_at(f2, Vector3.UP)
	vcam.global_transform = Transform3D(b2, b2.y * lift - f2 * 25.0)
	vcam.current = true

	quad = MeshInstance3D.new()
	var qm := QuadMesh.new()
	qm.size = Vector2(vp) * texel
	quad.mesh = qm
	quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	material = ShaderMaterial.new()
	material.shader = SPRITE
	material.set_shader_parameter(&"tex", viewport.get_texture())
	material.set_shader_parameter(&"tex_size", Vector2(vp))
	material.set_shader_parameter(&"feet_world", global_position)
	material.set_shader_parameter(&"brightness", brightness)
	material.set_shader_parameter(&"outline_color", outline)
	quad.material_override = material
	add_child(quad)
	quad.global_transform = Transform3D(cam.global_basis, global_position + up * lift)
	_add_shadow()
	_light_from(lights, fwd)


func _add_shadow() -> void:
	var s := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = shadow_size
	s.mesh = pm
	var sm := ShaderMaterial.new()
	sm.shader = BLOB
	s.material_override = sm
	s.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(s)
	s.global_position = global_position + Vector3(0, 0.02, 0)
	s.global_rotation = Vector3.ZERO


## Picks the strongest light as key and the strongest light behind the figure (relative to
## the camera) as rim, both attenuated by distance, so a hearth behind you rims you in orange.
func _light_from(lights: Array[Light3D], cam_fwd: Vector3) -> void:
	var chest := global_position + Vector3(0, 0.6, 0)
	var best_key := -1.0
	var best_rim := -1.0
	var key_dir := Vector3(0.3, 1, 0.5)
	var key_col := Color(0.4, 0.3, 0.3)
	var rim_dir := Vector3(0, 0.4, -1)
	var rim_col := Color(0.3, 0.2, 0.2)
	for l: Light3D in lights:
		var rng: float = l.get(&"omni_range") if l is OmniLight3D else (l.get(&"spot_range") if l is SpotLight3D else 50.0)
		var to_l := l.global_position - chest
		var d := to_l.length()
		var att := pow(clampf(1.0 - d / rng, 0.0, 1.0), 1.4) * l.light_energy
		if att <= 0.0:
			continue
		var dir := to_l.normalized()
		var col := l.light_color * att
		if att > best_key:
			best_key = att
			key_dir = dir
			key_col = col
		var behind := dir.dot(cam_fwd)
		var rim_score := att * (0.4 + maxf(behind, 0.0))
		if rim_score > best_rim:
			best_rim = rim_score
			rim_dir = dir
			rim_col = col
	toon.set_shader_parameter(&"ambient", ambient)
	toon.set_shader_parameter(&"key_dir", key_dir)
	toon.set_shader_parameter(&"key_color", _norm(key_col, key_strength))
	toon.set_shader_parameter(&"rim_dir", rim_dir)
	toon.set_shader_parameter(&"rim_color", _norm(rim_col, rim_boost))
	toon.set_shader_parameter(&"fill_dir", fill_dir)
	toon.set_shader_parameter(&"fill_color", fill_color)


static func _cap(c: Color, m: float) -> Color:
	var mx := maxf(c.r, maxf(c.g, c.b))
	if mx > m:
		return Color(c.r / mx * m, c.g / mx * m, c.b / mx * m)
	return c


## Keeps the hue of a light, sets its brightest channel to m (attenuation picks lights, not exposure).
static func _norm(c: Color, m: float) -> Color:
	var mx := maxf(c.r, maxf(c.g, c.b))
	if mx <= 0.0001:
		return Color(m, m, m)
	return Color(c.r / mx * m, c.g / mx * m, c.b / mx * m)
