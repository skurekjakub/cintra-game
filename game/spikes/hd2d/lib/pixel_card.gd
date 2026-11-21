extends Node3D
## HD-2D spike: a hand-authored pixel sprite standing in the 3D world (see pixel_lit.gdshader).
## One texel covers `pixel_scale` screen pixels at 1080p at this figure's depth.
## Animated cards (A12): the texture is a horizontal strip of `hframes` frames; `play()` picks a strip
## and a timing chart (a frame sequence at a fixed fps). Every frame the quad is resized for its
## current depth and its centre is snapped to a whole screen pixel, so a moving sprite keeps exactly
## pixel_scale screen pixels per texel and never shimmers.

const LIT := preload("res://spikes/hd2d/shaders/pixel_lit.gdshader")
const BLOB := preload("res://spikes/hd2d/shaders/blob_shadow.gdshader")
const DIR := "res://spikes/hd2d/sprites/"

var pixel_scale: float = 3.0
var screen_h: float = 1080.0
var shadow_size: Vector2 = Vector2(0.8, 0.45)
var hframes: int = 1
var material: ShaderMaterial
var _cam: Camera3D
var _quad: MeshInstance3D
var _mesh: QuadMesh
var _texels: Vector2 = Vector2.ZERO
var _feet_row: int = 0
var _upright: bool = true
var _seq: PackedInt32Array = PackedInt32Array()
var _fps: float = 0.0
var _time: float = 0.0
## last snapped top-left corner on screen and the frame shown (read by shot_runner's --record log)
var screen_corner: Vector2 = Vector2.ZERO
var shown_frame: int = 0


## sprite: base name in DIR (expects <name>.png and <name>_n.png). feet_row: texel row of the feet.
## flat: lay the card on the floor (bodies) instead of standing it up.
func setup(cam: Camera3D, sprite: String, feet_row: int, flip: bool = false, flat: bool = false) -> void:
	_cam = cam
	_feet_row = feet_row
	_upright = not flat
	var tex: Texture2D = load(DIR + sprite + ".png")
	_texels = Vector2(tex.get_size()) / Vector2(hframes, 1)
	_mesh = QuadMesh.new()
	_quad = MeshInstance3D.new()
	_quad.mesh = _mesh
	material = ShaderMaterial.new()
	material.shader = LIT
	material.set_shader_parameter(&"tex", tex)
	material.set_shader_parameter(&"nrm", load(DIR + sprite + "_n.png"))
	material.set_shader_parameter(&"flip", flip)
	material.set_shader_parameter(&"hframes", hframes)
	_quad.material_override = material
	_quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	add_child(_quad)
	if flat:
		_mesh.size = _texels * _texel()
		material.set_shader_parameter(&"upright", false)
		_quad.global_transform = Transform3D(Basis.from_euler(Vector3(-PI * 0.5, cam.global_rotation.y, 0)), global_position + Vector3(0, 0.04, 0))
		_quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	else:
		_place()
	var s := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = shadow_size
	s.mesh = pm
	var sm := ShaderMaterial.new()
	sm.shader = BLOB
	sm.set_shader_parameter(&"strength", 0.55)
	s.material_override = sm
	s.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(s)
	s.global_position = global_position + Vector3(0, 0.02, 0)


## Switch to another strip of the same frame size and restart its timing chart.
func play(sprite: String, fps: float, sequence: PackedInt32Array) -> void:
	material.set_shader_parameter(&"tex", load(DIR + sprite + ".png"))
	material.set_shader_parameter(&"nrm", load(DIR + sprite + "_n.png"))
	_fps = fps
	_seq = sequence
	_time = 0.0
	_show_frame()


## Move the feet to a new world point (already bent by the caller) and re-snap the card.
func move_to(feet: Vector3) -> void:
	global_position = feet
	if _upright and _quad != null:
		_place()


func _process(delta: float) -> void:
	if _seq.is_empty():
		return
	_time += delta
	_show_frame()


func _show_frame() -> void:
	# floor() of time * fps with a small epsilon, so a fixed-fps capture lands exactly on frame edges
	var step := int(floor(_time * _fps + 1e-4))
	shown_frame = _seq[step % _seq.size()]
	material.set_shader_parameter(&"anim_frame", shown_frame)


## World units per texel at the card's depth.
func _texel() -> float:
	var dist := (global_position - _cam.global_position).dot(-_cam.global_basis.z)
	return 2.0 * dist * tan(deg_to_rad(_cam.fov) * 0.5) / screen_h * pixel_scale


func _place() -> void:
	var texel := _texel()
	_mesh.size = _texels * texel
	material.set_shader_parameter(&"feet_world", global_position)
	var lift := (_texels.y * 0.5 - (_texels.y - 1.0 - float(_feet_row))) * texel
	var centre := global_position + _cam.global_basis.y * lift
	# snap the card's top-left corner to a whole screen pixel
	var corner := _cam.unproject_position(centre) - _texels * pixel_scale * 0.5
	var d := corner.round() - corner
	screen_corner = corner.round()
	var per_px := texel / pixel_scale
	centre += _cam.global_basis.x * d.x * per_px - _cam.global_basis.y * d.y * per_px
	_quad.global_transform = Transform3D(_cam.global_basis, centre)
