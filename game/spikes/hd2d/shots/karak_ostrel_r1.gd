extends Node3D
## HD-2D spike shot 2: a gallery of Karak Ostrel (Act III), cold stone and rune light.
## Proves the look holds in a cold palette: same camera, same sprite pipeline, same post stack.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")
const Props := preload("res://spikes/hd2d/lib/props.gd")
const Rig := preload("res://spikes/hd2d/lib/rig.gd")
const Cast := preload("res://spikes/hd2d/lib/characters.gd")
const PixelSprite := preload("res://spikes/hd2d/lib/pixel_sprite.gd")
const Portrait := preload("res://spikes/hd2d/lib/portrait.gd")
const Vfx := preload("res://spikes/hd2d/lib/vfx.gd")
const Hud := preload("res://spikes/hd2d/hud/hud.gd")

const PLAYER := Vector3(0.5, 0, -0.9)
const WARDEN := Vector3(-2.0, 0, -1.6)
const MAELIS := Vector3(2.6, 0, 1.4)
const RUNE := Color(0.35, 0.75, 1.0)

var cam: Camera3D
var lights: Array[Light3D] = []


func _ready() -> void:
	cam = Kit.camera(self, Vector3(0.0, 0.0, -1.6), 56.0, 0.0, 24.0, 27.0)
	Kit.environment(self, cam, {
		"ambient": Color(0.36, 0.4, 0.68), "ambient_energy": 1.4, "exposure": 1.15,
		"glow": 0.5, "contrast": 1.15, "saturation": 1.08,
		"fog": true, "fog_density": 0.006, "fog_albedo": Color(0.45, 0.55, 0.8),
	}, 24.0)
	_hall()
	_lights()
	_characters()
	_vfx()
	Kit.post_layer(self, {
		"focus_center": 0.54, "focus_half": 0.18, "blur_px": 8.0, "vignette": 0.62,
		"shadow_tint": Color(0.62, 0.68, 1.0), "high_tint": Color(1.02, 1.0, 0.95),
	})
	_hud()


func _hall() -> void:
	var floor_m := Kit.floor_material("granite_tile", Color(0.62, 0.64, 0.74), 2.0)
	floor_m.set_shader_parameter(&"use_grid", true)
	floor_m.set_shader_parameter(&"ornament", true)
	floor_m.set_shader_parameter(&"tile", 1.0)
	floor_m.set_shader_parameter(&"tex_normal_strength", 0.4)
	floor_m.set_shader_parameter(&"crack_amount", 0.8)
	floor_m.set_shader_parameter(&"damp_amount", 0.75)
	floor_m.set_shader_parameter(&"groove_dirt", Color(0.18, 0.2, 0.3))
	var pm := PlaneMesh.new()
	pm.size = Vector2(10, 18)
	Kit.mesh_node(self, pm, Vector3(0, 0, -1.5), floor_m)
	var block := Kit.pbr("large_sandstone_blocks", Color(0.42, 0.45, 0.55), 4.0)
	var trim := Kit.pbr("granite_tile", Color(0.45, 0.47, 0.56), 2.0)
	var iron := Kit.pbr("rusty_metal_02", Color(0.22, 0.22, 0.27), 1.5, 0.7)
	var brass := Kit.flat(Color(0.55, 0.42, 0.25), 0.35, 0.9)
	# Gallery edges: stone kerb, iron railings, abyss beyond.
	for s: float in [-1.0, 1.0]:
		Kit.box(self, Vector3(0.7, 0.5, 18.0), Vector3(5.35 * s, -0.2, -1.5), trim)
		Kit.box(self, Vector3(1.0, 6.0, 18.0), Vector3(5.5 * s, -3.4, -1.5), block)
		Props.railing(self, Vector3(5.2 * s, 0.05, -10.0), Vector3(5.2 * s, 0.05, 7.0), 1.05, iron, brass)
		for z: float in [-7.0, -2.5, 2.0, 6.5]:
			Props.pillar(self, Vector3(6.6 * s, -6.0, z), 1.3, 12.0, block, trim)
			Kit.box(self, Vector3(0.08, 1.6, 0.3), Vector3(6.6 * s - 0.69 * s, 1.0, z), Kit.emissive(RUNE, 3.0))
	# Abyss floor far below, faintly lit.
	var deep := PlaneMesh.new()
	deep.size = Vector2(40, 40)
	Kit.mesh_node(self, deep, Vector3(0, -9.0, -2.0), Kit.floor_material("granite_tile", Color(0.25, 0.28, 0.38), 3.0))
	# The rune-forged bulkhead at the far end.
	Kit.box(self, Vector3(12.0, 7.0, 1.0), Vector3(0, 3.5, -10.5), block)
	Kit.box(self, Vector3(5.0, 4.6, 0.4), Vector3(0, 2.3, -9.9), iron)
	Kit.box(self, Vector3(5.6, 0.5, 0.6), Vector3(0, 4.8, -9.9), trim)
	for i: int in range(7):
		var x := -2.1 + i * 0.7
		Kit.box(self, Vector3(0.06, 3.6 - absf(x) * 0.6, 0.05), Vector3(x, 2.0, -9.68), Kit.emissive(RUNE, 2.2))
	Kit.box(self, Vector3(4.2, 0.06, 0.05), Vector3(0, 0.7, -9.68), Kit.emissive(RUNE, 2.2))
	# Steps up to the gate.
	for i: int in range(3):
		Kit.box(self, Vector3(8.0 - i, 0.22, 0.6), Vector3(0, 0.11 + i * 0.22, -8.3 - i * 0.55), trim)
	# Rubble and a toppled warden plate.
	for p: Vector3 in [Vector3(3.6, 0, -5.3), Vector3(3.9, 0, -4.6), Vector3(-3.8, 0, 4.2)]:
		Kit.box(self, Vector3(0.45, 0.3, 0.4), p + Vector3(0, 0.15, 0), block, Vector3(0, p.x * 20.0, 7))
	Kit.box(self, Vector3(1.2, 0.12, 0.8), Vector3(3.4, 0.06, -3.9), iron, Vector3(0, 25, 4))
	_braziers(iron, brass)


func _braziers(iron: Material, brass: Material) -> void:
	for p: Vector3 in [Vector3(-3.6, 0, -7.4), Vector3(3.6, 0, -7.4)]:
		Kit.cyl(self, 0.35, 0.18, 0.3, p + Vector3(0, 0.95, 0), iron, 10)
		Kit.cyl(self, 0.08, 0.14, 0.85, p + Vector3(0, 0.42, 0), iron, 8)
		Kit.cyl(self, 0.38, 0.38, 0.06, p + Vector3(0, 1.1, 0), brass, 10)
		var f := Kit.flame(self, p + Vector3(0, 1.05, 0), Vector2(0.7, 1.1), cam, p.x, 4.5)
		f.set_shader_parameter(&"hot", Color(0.8, 0.95, 1.0))
		f.set_shader_parameter(&"mid", Color(0.25, 0.6, 1.0))
		f.set_shader_parameter(&"cool", Color(0.05, 0.15, 0.6))
		lights.append(Kit.omni(self, p + Vector3(0, 1.8, 0), Color(0.4, 0.65, 1.0), 3.5, 8.0, true))
	# One warm brazier behind the player keeps skin tones alive.
	for p: Vector3 in [Vector3(-3.9, 0, 4.0), Vector3(4.0, 0, 3.0)]:
		Kit.cyl(self, 0.3, 0.16, 0.26, p + Vector3(0, 0.9, 0), iron, 10)
		Kit.cyl(self, 0.07, 0.12, 0.8, p + Vector3(0, 0.4, 0), iron, 8)
		Kit.flame(self, p + Vector3(0, 0.98, 0), Vector2(0.55, 0.9), cam, p.z, 5.0)
		lights.append(Kit.omni(self, p + Vector3(0, 1.6, 0), Color(1.0, 0.55, 0.25), 2.5, 7.0, true))


func _lights() -> void:
	lights.append(Kit.omni(self, Vector3(0, 3.0, -8.8), RUNE, 3.0, 10.0, true))
	Kit.omni(self, Vector3(0.0, 6.5, -0.8), Color(0.75, 0.8, 1.0), 2.0, 13.0, true)
	lights.append(Kit.omni(self, WARDEN + Vector3(0, 1.0, 0.6), RUNE, 2.0, 3.0))
	for s: float in [-1.0, 1.0]:
		for z: float in [-2.5, 2.0]:
			lights.append(Kit.omni(self, Vector3(5.6 * s, 1.2, z), RUNE, 1.5, 4.0))
	Kit.omni(self, Vector3(0, -6.0, -2.0), Color(0.3, 0.45, 0.9), 3.0, 14.0)
	Vfx.embers(self, Vector3(0, 0.5, -3.0), Vector3(5.0, 0.4, 6.0), Color(0.4, 0.7, 1.0), 90, 0.35)


func _sprite(model: Node3D, mat: ShaderMaterial, pos: Vector3, facing: float, vp: Vector2i) -> Node3D:
	var s: Node3D = PixelSprite.new()
	s.set(&"shadow_size", Vector2(0.9, 0.55) * (1.7 if vp.x > 80 else 1.0))
	s.set(&"ambient", Color(0.34, 0.36, 0.52))
	add_child(s)
	s.global_position = pos
	s.call(&"setup", cam, model, vp, facing, lights, mat)
	return s


func _characters() -> void:
	var m := PixelSprite.new_toon_material()
	var hale := Rig.humanoid(Cast.hale(), m)
	Cast.pose_slash(hale)
	_sprite(hale, m, PLAYER, -86.0, Vector2i(92, 76))
	var wm := PixelSprite.new_toon_material()
	_sprite(Cast.warden(wm), wm, WARDEN, 70.0, Vector2i(128, 128))
	var mm := PixelSprite.new_toon_material()
	var maelis := Rig.humanoid(Cast.maelis(), mm)
	Rig.pose(maelis, {"shoulder_r": Vector3(-160, 0, 0), "elbow_r": Vector3(-20, 0, 0), "shoulder_l": Vector3(-150, 0, 20)})
	_sprite(maelis, mm, MAELIS, -120.0, Vector2i(64, 72))


func _vfx() -> void:
	var c := PLAYER + Vector3(0, 0.55, 0)
	Vfx.slash(self, c, 1.7, 1.0, 10.0, 175.0, Vector3(-12, 0, 6), Color(1.0, 0.04, 0.1), 3.0)
	Vfx.spark(self, WARDEN + Vector3(0.55, 0.95, 0.3), 1.3, cam, 6.0)
	lights.append(Kit.omni(self, WARDEN + Vector3(0.7, 1.0, 0.5), Color(1.0, 0.7, 0.4), 1.2, 2.5))
	Kit.glow(self, Vector3(1.7, 1.3, 0.2), 0.45, Color(0.35, 0.7, 1.0), 6.0, cam)
	Kit.omni(self, Vector3(1.7, 1.3, 0.2), Color(0.35, 0.65, 1.0), 1.5, 2.5)


func _hud() -> void:
	var mm := PixelSprite.new_toon_material()
	var bust := Rig.humanoid(Cast.maelis(), mm)
	var tex := Portrait.make(self, bust, mm, 48, Color(0.75, 0.82, 1.0), Color(0.5, 0.75, 1.0), Color(0.3, 0.28, 0.42))
	var layer := CanvasLayer.new()
	layer.layer = 2
	add_child(layer)
	var hud: Control = Hud.new()
	layer.add_child(hud)
	hud.call(&"setup", {
		"hp": 6, "hp_max": 10,
		"objective": "Break the warden's rune core. The Forge of Echoes lies beyond the gate.",
		"boss_name": "Iron-Warden of the Weeping Gate", "boss_frac": 0.71, "boss_recent": 0.07,
		"slots": [{"icon": "sword"}, {"icon": "crossbow", "count": 30}, {"icon": "poultice", "count": 1}],
		"companion": "Sister Maelis", "companion_ready": 0.65, "companion_hint": "",
		"enemies": [],
		"map": {
			"scale": 6.0, "origin": PLAYER,
			"rooms": [Rect2(-5, -10, 10, 17), Rect2(-2.5, -14, 5, 4)],
			"enemies": [WARDEN],
			"doors": [Vector3(0, 0, -10)],
		},
	}, cam, tex)
