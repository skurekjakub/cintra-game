extends Node3D
## HD-2D spike shot 1: the Drowned Rat taproom at night, mid-fight (Act I, scene 1).
## Camera looks south: the front door (thugs, rain) is at the top of the frame, the hearth with
## the dying courier on the left (east), the snug on the right (west), the bar at the bottom.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")
const Props := preload("res://spikes/hd2d/lib/props.gd")
const Rig := preload("res://spikes/hd2d/lib/rig.gd")
const Cast := preload("res://spikes/hd2d/lib/characters.gd")
const PixelSprite := preload("res://spikes/hd2d/lib/pixel_sprite.gd")
const Portrait := preload("res://spikes/hd2d/lib/portrait.gd")
const Vfx := preload("res://spikes/hd2d/lib/vfx.gd")
const Hud := preload("res://spikes/hd2d/hud/hud.gd")

const PLAYER := Vector3(0.6, 0, -1.0)
const THUG_A := Vector3(-0.8, 0, -0.1)
const THUG_B := Vector3(1.9, 0, -2.6)
const THUG_C := Vector3(2.3, 0, -4.4)
const COURIER := Vector3(-6.9, 0.0, 0.2)
const DOOR_X := Vector2(0.9, 2.5)

var cam: Camera3D
var lights: Array[Light3D] = []


func _ready() -> void:
	cam = Kit.camera(self, Vector3(0.0, 0.0, -1.8), 56.0, 0.0, 24.0, 27.0)
	Kit.environment(self, cam, {
		"ambient": Color(0.44, 0.38, 0.72), "ambient_energy": 1.4, "exposure": 1.15,
		"glow": 0.5, "contrast": 1.14, "saturation": 1.12,
		"fog": true, "fog_density": 0.003, "fog_albedo": Color(0.7, 0.55, 0.65),
	}, 24.0)
	_room()
	_furniture()
	_lights()
	_characters()
	_vfx()
	Kit.post_layer(self, {"focus_center": 0.54, "focus_half": 0.18, "blur_px": 8.0, "vignette": 0.62})
	_hud()


func _room() -> void:
	var floor_m := Kit.floor_material("monastery_stone_floor", Color(0.82, 0.74, 0.8), 5.0)
	floor_m.set_shader_parameter(&"crack_amount", 0.7)
	floor_m.set_shader_parameter(&"damp_amount", 0.7)
	var pm := PlaneMesh.new()
	pm.size = Vector2(18, 12)
	Kit.mesh_node(self, pm, Vector3.ZERO, floor_m)
	var hearth_m := Kit.floor_material("monastery_stone_floor", Color(0.55, 0.48, 0.45), 3.0)
	Kit.box(self, Vector3(2.4, 0.08, 4.0), Vector3(-7.6, 0.04, 0.0), hearth_m)
	var quay := Kit.floor_material("seaworn_stone_tiles", Color(0.3, 0.33, 0.42), 3.0)
	quay.set_shader_parameter(&"damp_amount", 1.0)
	var qm := PlaneMesh.new()
	qm.size = Vector2(26, 6)
	Kit.mesh_node(self, qm, Vector3(0, -0.15, -9.2), quay)
	var stone := Kit.pbr("rough_block_wall", Color(0.55, 0.5, 0.52), 2.2)
	var timber := Kit.pbr("old_planks_02", Color(0.62, 0.46, 0.36), 2.4)
	var wood := Kit.pbr("dark_wooden_planks", Color(0.5, 0.38, 0.3), 2.0)
	var h := 3.1
	Props.timber_wall(self, Vector3(-9, 0, -6), Vector3(DOOR_X.x, 0, -6), h, 1.1, stone, timber, wood)
	Props.timber_wall(self, Vector3(DOOR_X.y, 0, -6), Vector3(9, 0, -6), h, 1.1, stone, timber, wood)
	Kit.box(self, Vector3(DOOR_X.y - DOOR_X.x + 0.4, 0.5, 0.5), Vector3((DOOR_X.x + DOOR_X.y) * 0.5, 2.6, -6), wood)
	Props.timber_wall(self, Vector3(-9, 0, -6), Vector3(-9, 0, 6), h, 1.1, stone, timber, wood)
	Props.timber_wall(self, Vector3(9, 0, -6), Vector3(9, 0, 6), h, 1.1, stone, timber, wood)
	# Snug partition (SW corner, top right of frame).
	Props.timber_wall(self, Vector3(5.6, 0, -6), Vector3(5.6, 0, -3.0), 1.5, 0.5, stone, timber, wood)
	# The kicked-in door, hanging open.
	var door := Kit.box(self, Vector3(1.5, 2.3, 0.12), Vector3(DOOR_X.x + 0.1, 1.15, -5.3), wood, Vector3(0, -70, 0))
	door.position.x += 0.1
	_hearth(stone, wood)
	_windows()


func _hearth(stone: Material, wood: Material) -> void:
	var hx := -8.4
	Kit.box(self, Vector3(1.2, 3.1, 0.7), Vector3(hx, 1.55, -1.35), stone)
	Kit.box(self, Vector3(1.2, 3.1, 0.7), Vector3(hx, 1.55, 1.35), stone)
	Kit.box(self, Vector3(1.3, 0.6, 3.4), Vector3(hx, 1.55, 0), wood)
	Kit.box(self, Vector3(1.2, 1.3, 2.0), Vector3(hx, 2.45, 0), stone)
	Kit.box(self, Vector3(0.4, 1.3, 2.0), Vector3(hx - 0.4, 0.65, 0), Kit.flat(Color(0.05, 0.03, 0.03)))
	var log_m := Kit.pbr("dark_wooden_planks", Color(0.25, 0.15, 0.1), 1.0)
	for i: int in range(3):
		var lg := Kit.cyl(self, 0.09, 0.09, 1.3, Vector3(hx + 0.1, 0.14 + i * 0.05, -0.2 + i * 0.2), log_m, 8)
		lg.rotation_degrees = Vector3(90, 0, 10 * i)
	for i: int in range(5):
		Kit.flame(self, Vector3(hx + 0.15, 0.12, -0.6 + i * 0.3), Vector2(0.55, 1.0 + 0.25 * (i % 2)), cam, float(i) * 3.1, 5.5)
	Kit.glow(self, Vector3(hx + 0.3, 0.5, 0), 2.6, Color(1.0, 0.45, 0.15), 1.2, cam)
	var poker := Kit.box(self, Vector3(0.03, 1.1, 0.03), Vector3(hx + 0.65, 0.55, 1.75), Kit.flat(Color(0.15, 0.15, 0.17), 0.4, 0.8))
	poker.rotation_degrees = Vector3(12, 0, -8)


func _windows() -> void:
	var cold := Kit.emissive(Color(0.35, 0.5, 1.0), 2.5)
	var shutter := Kit.pbr("old_planks_02", Color(0.35, 0.27, 0.22), 1.0)
	for x: float in [-4.5, 6.8]:
		Kit.box(self, Vector3(1.2, 1.0, 0.1), Vector3(x, 1.75, -5.72), shutter)
		for k: int in range(3):
			Kit.box(self, Vector3(0.025, 0.9, 0.04), Vector3(x - 0.3 + k * 0.3, 1.75, -5.66), cold)


func _furniture() -> void:
	var top := Kit.pbr("wood_table_worn", Color(0.75, 0.6, 0.5), 1.6)
	var wood := Kit.pbr("dark_wooden_planks", Color(0.5, 0.38, 0.3), 1.6)
	var iron := Kit.flat(Color(0.2, 0.2, 0.22), 0.45, 0.8)
	var pewter := Kit.flat(Color(0.55, 0.55, 0.58), 0.35, 0.7)
	var glass := Kit.flat(Color(0.15, 0.35, 0.2), 0.15, 0.0)
	Props.round_table(self, Vector3(-4.3, 0, 2.3), top, wood)
	Props.round_table(self, Vector3(3.8, 0, 2.2), top, wood)
	Props.trestle(self, Vector3(-4.6, 0, -3.4), 0.0, top, wood)
	Props.trestle(self, Vector3(4.2, 0, -1.2), 90.0, top, wood)
	Props.trestle(self, Vector3(-3.6, 0, -0.4), 0.0, top, wood)
	# A bench kicked over in the scuffle.
	Kit.box(self, Vector3(2.2, 0.07, 0.32), Vector3(0.6, 0.18, -2.5), top, Vector3(70, 25, 0))
	for p: Vector3 in [Vector3(-3.2, 0, -1.6), Vector3(3.2, 0, -3.6)]:
		Kit.box(self, Vector3(0.42, 3.1, 0.42), p + Vector3(0, 1.55, 0), wood)
		Kit.box(self, Vector3(0.62, 0.3, 0.62), p + Vector3(0, 0.15, 0), wood)
	# Bar counter at the bottom of the frame.
	Kit.box(self, Vector3(9.0, 1.05, 0.75), Vector3(-0.5, 0.525, 4.6), wood)
	Kit.box(self, Vector3(9.3, 0.1, 0.95), Vector3(-0.5, 1.1, 4.6), top)
	for i: int in range(9):
		Props.bottle(self, Vector3(-4.4 + i * 0.95, 1.15, 4.45 + (i % 2) * 0.15), glass if i % 3 else pewter)
	for p: Vector3 in [Vector3(-4.0, 0.8, 2.1), Vector3(-4.6, 0.8, 2.5), Vector3(4.1, 0.8, 2.0), Vector3(-5.2, 0.8, -3.3), Vector3(-3.4, 0.8, -0.3)]:
		Props.mug(self, p, pewter)
	for p: Vector3 in [Vector3(-8.1, 0, -5.2), Vector3(-7.4, 0, -5.3), Vector3(-7.8, 0, -4.5), Vector3(8.2, 0, 1.5), Vector3(8.1, 0, 2.3)]:
		Props.barrel(self, p, wood, iron)
	Props.barrel(self, Vector3(-6.5, 0, -4.8), wood, iron, true)
	Props.crate(self, Vector3(8.0, 0, 3.4), 0.8, 10.0, top, wood)
	Props.crate(self, Vector3(-8.1, 0, 4.0), 0.7, -15.0, top, wood)
	# Snug settle and table.
	Kit.box(self, Vector3(2.6, 1.5, 0.25), Vector3(7.3, 0.75, -5.6), wood)
	Kit.box(self, Vector3(2.6, 0.12, 0.6), Vector3(7.3, 0.45, -5.25), top)
	Kit.box(self, Vector3(1.6, 0.08, 0.9), Vector3(7.3, 0.75, -4.2), top)
	Kit.box(self, Vector3(0.12, 0.72, 0.12), Vector3(7.3, 0.36, -4.2), wood)
	# Blood on the hearthstones.
	var blood := Kit.flat(Color(0.22, 0.01, 0.02), 0.15)
	Kit.cyl(self, 0.55, 0.55, 0.01, COURIER + Vector3(0.3, 0.09, 0.1), blood, 20)
	Kit.cyl(self, 0.25, 0.25, 0.01, COURIER + Vector3(0.9, 0.09, 0.4), blood, 14)


func _lights() -> void:
	lights.append(Kit.omni(self, Vector3(-7.6, 1.0, 0.0), Color(1.0, 0.52, 0.25), 2.6, 9.0, true))
	lights.append(Kit.omni(self, Vector3(-7.0, 2.2, 0.0), Color(1.0, 0.6, 0.3), 1.0, 6.0))
	for p: Vector3 in [Vector3(-4.3, 0.8, 2.3), Vector3(3.6, 0.8, 2.4), Vector3(-4.0, 0.8, -3.4), Vector3(-3.0, 0.8, -0.5), Vector3(7.5, 0.8, -4.2), Vector3(-2.6, 1.15, 4.5), Vector3(2.0, 1.15, 4.5)]:
		lights.append(Kit.candle(self, p, cam, p.x * 1.7, 0.7))
	# Broad warm-rose wash over the play area: the lit "stage" that falls off into darkness.
	Kit.omni(self, Vector3(0.0, 6.5, -0.8), Color(1.0, 0.86, 0.86), 3.0, 12.0, true)
	# Wall lanterns on the posts.
	for p: Vector3 in [Vector3(-2.8, 2.1, -5.6), Vector3(5.2, 2.1, -5.6), Vector3(8.6, 2.1, -1.5)]:
		Kit.box(self, Vector3(0.22, 0.3, 0.22), p, Kit.emissive(Color(1.0, 0.7, 0.35), 1.6))
		lights.append(Kit.omni(self, p + Vector3(0, 0, 0.4), Color(1.0, 0.6, 0.3), 1.2, 4.5))
	# Cold rain light spilling through the open door.
	var door_c := Vector3((DOOR_X.x + DOOR_X.y) * 0.5, 0, -6.0)
	lights.append(Kit.spot(self, door_c + Vector3(0.0, 4.0, -3.0), door_c + Vector3(0, 0, 3.0), Color(0.45, 0.58, 1.0), 5.0, 10.0, 28.0))
	Kit.omni(self, door_c + Vector3(0, 2.0, -2.5), Color(0.4, 0.5, 1.0), 4.0, 6.0)
	Vfx.rain(self, door_c + Vector3(0, 3.0, -2.6), Vector3(5.0, 0.5, 1.8), Color(0.55, 0.65, 1.0, 0.35), 700)


func _sprite(model: Node3D, mat: ShaderMaterial, pos: Vector3, facing: float, vp: Vector2i) -> Node3D:
	var s: Node3D = PixelSprite.new()
	add_child(s)
	s.global_position = pos
	s.call(&"setup", cam, model, vp, facing, lights, mat)
	return s


func _characters() -> void:
	var m := PixelSprite.new_toon_material()
	var hale := Rig.humanoid(Cast.hale(), m)
	Cast.pose_slash(hale)
	_sprite(hale, m, PLAYER, -63.0, Vector2i(92, 76))
	for i: int in range(3):
		var tm := PixelSprite.new_toon_material()
		var t := Rig.humanoid(Cast.thug(i), tm)
		var pos: Vector3 = [THUG_A, THUG_B, THUG_C][i]
		var facing: float = [123.0, -43.0, 10.0][i]
		if i == 0:
			Cast.pose_stagger(t)
		elif i == 1:
			Cast.pose_lunge(t)
		else:
			Cast.pose_guard(t)
		_sprite(t, tm, pos, facing, Vector2i(68, 68))
	var cm := PixelSprite.new_toon_material()
	var courier := Rig.humanoid(Cast.courier(), cm)
	Cast.pose_dead(courier)
	_sprite(courier, cm, COURIER, 100.0, Vector2i(76, 60))
	var bm := PixelSprite.new_toon_material()
	var bertha := Rig.humanoid(Cast.bertha(), bm)
	Rig.pose(bertha, {"shoulder_l": Vector3(-150, 0, -20), "elbow_l": Vector3(-30, 0, 0), "spine": Vector3(-8, 0, 0)})
	_sprite(bertha, bm, Vector3(-1.6, 0, 5.4), 170.0, Vector2i(60, 68))


func _vfx() -> void:
	var c := PLAYER + Vector3(0, 0.55, 0)
	Vfx.slash(self, c, 1.7, 1.0, 300.0, 140.0, Vector3(-14, 0, 10), Color(1.0, 0.04, 0.1), 3.0)
	Vfx.spark(self, THUG_A + Vector3(0.3, 0.7, 0.1), 1.0, cam, 4.0)
	Vfx.spark(self, THUG_A + Vector3(0.1, 0.9, 0.3), 0.5, cam, 9.0, Color(1.0, 0.5, 0.2))
	lights.append(Kit.omni(self, THUG_A + Vector3(0.3, 0.8, 0.6), Color(1.0, 0.35, 0.3), 1.2, 2.5))
	Vfx.embers(self, Vector3(-8.0, 0.8, 0), Vector3(0.4, 0.2, 0.9), Color(1.0, 0.5, 0.2), 40)
	Kit.glow(self, Vector3(1.9, 1.3, -0.2), 0.45, Color(0.35, 0.65, 1.0), 6.0, cam)
	Kit.omni(self, Vector3(1.9, 1.3, -0.2), Color(0.35, 0.6, 1.0), 1.5, 2.5)


func _hud() -> void:
	var bm := PixelSprite.new_toon_material()
	var bust := Rig.humanoid(Cast.bertha(), bm)
	var tex := Portrait.make(self, bust, bm, 48, Color(1.0, 0.7, 0.45), Color(1.0, 0.55, 0.3), Color(0.32, 0.24, 0.4))
	var layer := CanvasLayer.new()
	layer.layer = 2
	add_child(layer)
	var hud: Control = Hud.new()
	layer.add_child(hud)
	hud.call(&"setup", {
		"hp": 7, "hp_max": 10,
		"objective": "Keep the courier's letter. Fight them, or flee through the cellar trapdoor.",
		"boss_name": "Hired Knives of the Pale Choir", "boss_frac": 0.58, "boss_recent": 0.09,
		"slots": [{"icon": "sword"}, {"icon": "crossbow", "count": 12}, {"icon": "poultice", "count": 2}],
		"companion": "Bertha", "companion_ready": 1.0, "companion_hint": "1",
		"enemies": [
			{"pos": THUG_A + Vector3(0, 1.45, 0), "frac": 0.35},
			{"pos": THUG_B + Vector3(0, 1.45, 0), "frac": 0.9},
			{"pos": THUG_C + Vector3(0, 1.45, 0), "frac": 1.0},
		],
		"map": {
			"scale": 6.5, "origin": PLAYER,
			"rooms": [Rect2(-9, -6, 18, 12), Rect2(5.6, -6, 3.4, 3), Rect2(-9, -2, 2.4, 4)],
			"enemies": [THUG_A, THUG_B, THUG_C],
			"doors": [Vector3(1.7, 0, -6)],
		},
	}, cam, tex)
