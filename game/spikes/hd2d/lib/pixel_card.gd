extends Node3D
## HD-2D spike: a hand-authored pixel sprite standing in the 3D world (see pixel_lit.gdshader).
## One texel covers `pixel_scale` screen pixels at 1080p at this figure's depth.

const LIT := preload("res://spikes/hd2d/shaders/pixel_lit.gdshader")
const BLOB := preload("res://spikes/hd2d/shaders/blob_shadow.gdshader")
const DIR := "res://spikes/hd2d/sprites/"

var pixel_scale: float = 3.0
var screen_h: float = 1080.0
var shadow_size: Vector2 = Vector2(0.8, 0.45)
var material: ShaderMaterial


## sprite: base name in DIR (expects <name>.png and <name>_n.png). feet_row: texel row of the feet.
## flat: lay the card on the floor (bodies) instead of standing it up.
func setup(cam: Camera3D, sprite: String, feet_row: int, flip: bool = false, flat: bool = false) -> void:
	var tex: Texture2D = load(DIR + sprite + ".png")
	var size := Vector2(tex.get_size())
	var fwd := -cam.global_basis.z
	var dist := (global_position - cam.global_position).dot(fwd)
	var texel := 2.0 * dist * tan(deg_to_rad(cam.fov) * 0.5) / screen_h * pixel_scale
	var mi := MeshInstance3D.new()
	var q := QuadMesh.new()
	q.size = size * texel
	mi.mesh = q
	material = ShaderMaterial.new()
	material.shader = LIT
	material.set_shader_parameter(&"tex", tex)
	material.set_shader_parameter(&"nrm", load(DIR + sprite + "_n.png"))
	material.set_shader_parameter(&"feet_world", global_position)
	material.set_shader_parameter(&"flip", flip)
	mi.material_override = material
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	add_child(mi)
	if flat:
		material.set_shader_parameter(&"upright", false)
		mi.global_transform = Transform3D(Basis.from_euler(Vector3(-PI * 0.5, cam.global_rotation.y, 0)), global_position + Vector3(0, 0.04, 0))
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	else:
		var lift := (size.y * 0.5 - (size.y - 1.0 - float(feet_row))) * texel
		mi.global_transform = Transform3D(cam.global_basis, global_position + cam.global_basis.y * lift)
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
