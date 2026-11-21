extends Node3D
## HD-2D spike shot 1 (round 2+): the Drowned Rat taproom at night, mid-fight (Act I, scene 1).
## Full 3D room (KayKit CC0 props with Poly Haven grain, baked carved flagstones, Poly Haven PBR
## walls), rolling-cylinder world bend, volumetric fog with window shafts, hand-authored pixel
## sprites lit by the room's lights. Camera looks south: the front door is at the top.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")
const Props := preload("res://spikes/hd2d/lib/props.gd")
const KK := preload("res://spikes/hd2d/lib/kaykit.gd")
const Card := preload("res://spikes/hd2d/lib/pixel_card.gd")
const Vfx := preload("res://spikes/hd2d/lib/vfx.gd")
const Hud := preload("res://spikes/hd2d/hud/hud.gd")

const PLAYER := Vector3(0.5, 0, -0.3)
const THUG_A := Vector3(-0.9, 0, 0.2)
const THUG_B := Vector3(1.9, 0, -1.7)
const THUG_C := Vector3(1.2, 0, -4.3)
const COURIER := Vector3(-6.0, 0, 0.4)
const BERTHA := Vector3(-1.8, 0, 4.9)
const DOOR := Vector2(0.4, 2.0)
const W := 8.0
const D := 5.5

var cam: Camera3D
var lights: Array[Light3D] = []


func _ready() -> void:
	Kit.env_materials.clear()
	cam = Kit.camera(self, Vector3(0.0, 0.0, -0.6), 52.0, 0.0, 21.0, 27.0)
	var we := Kit.environment(self, cam, {
		"ambient": Color(0.46, 0.4, 0.68), "ambient_energy": 1.1, "exposure": 1.05,
		"glow": 0.4, "contrast": 1.1, "saturation": 1.15,
		"fog": true, "fog_density": 0.028, "fog_albedo": Color(0.75, 0.7, 0.85),
	}, 21.0)
	we.environment.ssr_enabled = true
	we.environment.ssr_max_steps = 48
	we.environment.glow_hdr_threshold = 1.0
	_room()
	_furniture()
	_lights()
	Kit.apply_bend(self, PLAYER, cam, 13.0)
	_characters()
	_vfx()
	Kit.post_layer(self, {"focus_center": 0.52, "focus_half": 0.15, "blur_px": 11.0, "vignette": 0.42,
		"shadow_tint": Color(0.82, 0.74, 1.0), "high_tint": Color(1.06, 0.98, 0.88), "grain": 0.02})
	_hud()


func _room() -> void:
	var pm := PlaneMesh.new()
	pm.size = Vector2(W * 2.0, D * 2.0)
	pm.subdivide_width = 48
	pm.subdivide_depth = 32
	Kit.mesh_node(self, pm, Vector3.ZERO, Kit.floor_material("tavern_floor", Color(0.8, 0.78, 0.84), 2.0))
	var outside := PlaneMesh.new()
	outside.size = Vector2(30, 8)
	outside.subdivide_width = 30
	outside.subdivide_depth = 8
	var quay := Kit.floor_material("karak_floor", Color(0.35, 0.4, 0.55), 3.0)
	Kit.mesh_node(self, outside, Vector3(0, -0.12, -D - 4.2), quay)
	var stone := Kit.pbr("rough_block_wall", Color(0.85, 0.8, 0.86), 2.0)
	var timber := Kit.pbr("old_planks_02", Color(0.95, 0.74, 0.58), 2.2)
	var wood := Kit.pbr("dark_wooden_planks", Color(0.55, 0.4, 0.32), 1.8)
	var h := 3.2
	Props.timber_wall(self, Vector3(-W, 0, -D), Vector3(DOOR.x, 0, -D), h, 1.0, stone, timber, wood)
	Props.timber_wall(self, Vector3(DOOR.y, 0, -D), Vector3(W, 0, -D), h, 1.0, stone, timber, wood)
	Kit.box(self, Vector3(DOOR.y - DOOR.x + 0.5, 0.6, 0.5), Vector3((DOOR.x + DOOR.y) * 0.5, 2.6, -D), wood)
	Props.timber_wall(self, Vector3(-W, 0, -D), Vector3(-W, 0, D), h, 1.0, stone, timber, wood)
	Props.timber_wall(self, Vector3(W, 0, -D), Vector3(W, 0, D), h, 1.0, stone, timber, wood)
	var door := Kit.box(self, Vector3(1.4, 2.2, 0.12), Vector3(DOOR.x - 0.2, 1.1, -D + 0.75), wood, Vector3(0, -62, 0))
	door.position.x += 0.0
	_hearth(stone, wood)
	for x: float in [-4.6, 4.6]:
		Kit.box(self, Vector3(1.3, 1.1, 0.1), Vector3(x, 1.8, -D + 0.24), Kit.pbr("old_planks_02", Color(0.3, 0.24, 0.2), 1.0))
		for k: int in range(4):
			Kit.box(self, Vector3(0.03, 1.0, 0.03), Vector3(x - 0.45 + k * 0.3, 1.8, -D + 0.3), Kit.emissive(Color(0.45, 0.6, 1.0), 4.0))


func _hearth(stone: Material, wood: Material) -> void:
	var hx := -W + 0.55
	Kit.box(self, Vector3(1.1, 3.2, 0.7), Vector3(hx, 1.6, -1.3), stone)
	Kit.box(self, Vector3(1.1, 3.2, 0.7), Vector3(hx, 1.6, 1.3), stone)
	Kit.box(self, Vector3(1.3, 0.35, 3.4), Vector3(hx, 1.45, 0), wood)
	Kit.box(self, Vector3(1.1, 1.6, 1.9), Vector3(hx, 2.4, 0), stone)
	Kit.box(self, Vector3(0.3, 1.3, 1.9), Vector3(hx - 0.35, 0.65, 0), Kit.flat(Color(0.04, 0.02, 0.02)))
	Kit.box(self, Vector3(2.0, 0.07, 3.6), Vector3(hx + 1.2, 0.035, 0), Kit.floor_material("karak_floor", Color(0.62, 0.55, 0.55), 1.5))
	var logm := Kit.pbr("dark_wooden_planks", Color(0.3, 0.18, 0.12), 0.8)
	for i: int in range(3):
		var lg := Kit.cyl(self, 0.08, 0.08, 1.2, Vector3(hx + 0.05, 0.12 + i * 0.05, -0.2 + i * 0.2), logm, 8)
		lg.rotation_degrees = Vector3(90, 0, 12 * i)
	for i: int in range(5):
		Kit.flame(self, Vector3(hx + 0.12, 0.1, -0.6 + i * 0.3), Vector2(0.5, 0.85 + 0.2 * (i % 2)), cam, float(i) * 3.1, 5.0)
	Kit.glow(self, Vector3(hx + 0.3, 0.5, 0), 1.6, Color(1.0, 0.45, 0.15), 0.8, cam)
	Vfx.embers(self, Vector3(hx + 0.3, 0.9, 0), Vector3(0.3, 0.3, 0.8), Color(1.0, 0.5, 0.2), 50)


func _furniture() -> void:
	var grain := "wood_table_worn"
	KK.prop(self, "table_long", Vector3(-4.3, 0, -2.9), 90.0, 1.0, grain, 0.5)
	KK.prop(self, "table_long_decorated_A", Vector3(4.6, 0, -0.8), 0.0, 1.0, grain, 0.5)
	KK.prop(self, "table_medium_decorated_A", Vector3(-4.0, 0, 2.0), 15.0, 1.0, grain, 0.5)
	KK.prop(self, "table_medium", Vector3(3.8, 0, 2.4), -10.0, 1.0, grain, 0.5)
	for p: Vector3 in [Vector3(-5.3, 0, -3.6), Vector3(-3.3, 0, -3.6), Vector3(-5.2, 0, -2.2), Vector3(-4.9, 0, 2.9),
			Vector3(-3.1, 0, 1.3), Vector3(3.0, 0, 3.0), Vector3(4.7, 0, 1.6), Vector3(5.5, 0, -1.4), Vector3(3.7, 0, -0.2)]:
		KK.prop(self, "stool", p, p.x * 37.0, 1.0, grain, 0.4)
	var chair := KK.prop(self, "chair", Vector3(-0.2, 0.18, -1.9), 40.0, 1.0, grain, 0.4)
	chair.rotation_degrees = Vector3(0, 40, 85)
	KK.prop(self, "table_long_broken", Vector3(0.9, 0, -3.0), 70.0, 1.0, grain, 0.5)
	for p: Vector3 in [Vector3(-7.1, 0, -4.6), Vector3(-6.2, 0, -4.9), Vector3(6.9, 0, 3.6), Vector3(-7.2, 0, 3.2)]:
		KK.prop(self, "barrel_large", p, p.z * 40.0, 1.0, "dark_wooden_planks", 0.35)
	KK.prop(self, "barrel_small_stack", Vector3(6.8, 0, -4.6), 20.0, 1.0, "dark_wooden_planks", 0.35)
	KK.prop(self, "keg_decorated", Vector3(-7.0, 0, 4.4), 90.0, 1.0, "dark_wooden_planks", 0.35)
	KK.prop(self, "crates_stacked", Vector3(7.0, 0, 1.2), -15.0, 1.0, "dark_wooden_planks", 0.3)
	KK.prop(self, "box_large", Vector3(6.6, 0, 0.0), 30.0, 1.0, "dark_wooden_planks", 0.3)
	KK.prop(self, "shelves", Vector3(5.6, 0, -D + 0.4), 0.0, 1.0, grain, 0.4)
	for p: Vector3 in [Vector3(-4.3, 0.61, -3.2), Vector3(4.6, 0.61, -0.4), Vector3(3.8, 0.61, 2.4), Vector3(-4.0, 0.61, 2.0)]:
		KK.prop(self, "candle_triple", p, p.x * 20.0)
	for p: Vector3 in [Vector3(-4.6, 0.61, -2.6), Vector3(4.4, 0.61, -1.3), Vector3(-3.7, 0.61, 1.8)]:
		KK.prop(self, "plate_food_A", p, p.z * 50.0)
	for p: Vector3 in [Vector3(4.9, 0.61, -1.0), Vector3(-4.1, 0.61, -2.4), Vector3(3.6, 0.61, 2.1)]:
		KK.prop(self, "bottle_A_green", p, 0.0)
	# The bar along the bottom of the frame.
	var bar_wood := Kit.pbr("dark_wooden_planks", Color(0.6, 0.44, 0.34), 1.5)
	Kit.box(self, Vector3(8.0, 0.95, 0.7), Vector3(-0.8, 0.475, 4.3), bar_wood)
	Kit.box(self, Vector3(8.3, 0.1, 0.95), Vector3(-0.8, 1.0, 4.3), Kit.pbr("wood_table_worn", Color(0.8, 0.62, 0.5), 1.4, 0.6))
	for i: int in range(8):
		KK.prop(self, ["bottle_A_brown", "bottle_A_green", "bottle_B_green"][i % 3], Vector3(-4.3 + i * 0.95, 1.05, 4.15 + (i % 2) * 0.2), i * 30.0)
	var blood := Kit.flat(Color(0.25, 0.01, 0.03), 0.08)
	Kit.cyl(self, 0.38, 0.38, 0.01, COURIER + Vector3(0.35, 0.075, 0.15), blood, 20)


func _lights() -> void:
	var hx := -W + 0.9
	lights.append(Kit.omni(self, Vector3(hx, 0.9, 0.0), Color(1.0, 0.5, 0.2), 4.0, 9.0, true))
	Kit.omni(self, Vector3(0.0, 7.0, 0.0), Color(0.62, 0.56, 0.9), 1.2, 16.0)
	# Wash on the far wall so the bent background reads.
	Kit.omni(self, Vector3(-3.0, 2.6, -D + 1.6), Color(1.0, 0.7, 0.5), 1.4, 6.0)
	Kit.omni(self, Vector3(4.0, 2.6, -D + 1.6), Color(1.0, 0.7, 0.5), 1.4, 6.0)
	for p: Vector3 in [Vector3(-4.3, 1.05, -3.2), Vector3(4.6, 1.05, -0.4), Vector3(3.8, 1.05, 2.4), Vector3(-4.0, 1.05, 2.0)]:
		lights.append(Kit.omni(self, p, Color(1.0, 0.62, 0.32), 0.9, 3.5))
		Kit.glow(self, p - Vector3(0, 0.15, 0), 0.35, Color(1.0, 0.65, 0.3), 1.0, cam)
	for p: Vector3 in [Vector3(-2.2, 2.0, -D + 0.3), Vector3(3.4, 2.0, -D + 0.3), Vector3(W - 0.3, 2.0, -2.6), Vector3(-W + 0.3, 2.0, 3.2)]:
		KK.prop(self, "torch_mounted", p + Vector3(0, -0.6, 0), 0.0 if p.z < -4.0 else (90.0 if p.x < 0.0 else -90.0))
		Kit.flame(self, p + Vector3(0, -0.02, 0.0), Vector2(0.2, 0.35), cam, p.x, 5.0)
		lights.append(Kit.omni(self, p + Vector3(0, 0.1, 0), Color(1.0, 0.6, 0.3), 1.6, 5.0))
	# Moonlight shafts through the shuttered windows and the open door.
	for x: float in [-4.6, 4.6]:
		var s := Kit.spot(self, Vector3(x, 2.4, -D + 0.45), Vector3(x + 0.8, 0.0, -D + 3.6), Color(0.5, 0.62, 1.0), 5.0, 8.0, 18.0)
		s.light_volumetric_fog_energy = 5.0
	var dc := Vector3((DOOR.x + DOOR.y) * 0.5, 0, -D)
	var ds := Kit.spot(self, dc + Vector3(0.0, 3.4, -2.4), dc + Vector3(0.3, 0, 3.0), Color(0.45, 0.58, 1.0), 6.0, 11.0, 24.0)
	ds.light_volumetric_fog_energy = 4.0
	lights.append(ds)
	Kit.omni(self, dc + Vector3(0, 2.0, -2.2), Color(0.4, 0.5, 1.0), 2.5, 5.0)
	Vfx.rain(self, dc + Vector3(0, 3.0, -2.6), Vector3(5.0, 0.5, 1.8), Color(0.55, 0.65, 1.0, 0.35), 700)
	Vfx.embers(self, Vector3(0, 1.4, -1.0), Vector3(6.0, 1.2, 4.0), Color(0.5, 0.45, 0.35), 40, 0.12)


func _card(sprite: String, pos: Vector3, flip: bool = false, flat: bool = false) -> Node3D:
	var c: Node3D = Card.new()
	add_child(c)
	c.global_position = Kit.bend_point(pos)
	c.call(&"setup", cam, sprite, 33, flip, flat)
	return c


func _characters() -> void:
	_card("hale_idle_s", PLAYER, true)
	var a := _card("thug_s", THUG_A)
	(a.get(&"material") as ShaderMaterial).set_shader_parameter(&"hit_flash", 0.0)
	_card("thug_s", THUG_B, true)
	_card("thug_s", THUG_C)
	_card("courier_lying", COURIER)
	_card("bertha_s", BERTHA)
	Kit.omni(self, PLAYER + Vector3(0.3, 1.2, 0.6), Color(1.0, 0.72, 0.45), 1.0, 3.5)


func _vfx() -> void:
	var c := PLAYER + Vector3(0, 0.5, 0)
	Vfx.slash(self, c, 1.5, 0.85, 320.0, 150.0, Vector3(-16, 0, 8), Color(1.0, 0.05, 0.12), 3.0)
	Vfx.spark(self, THUG_A + Vector3(0.45, 0.6, 0.35), 0.8, cam, 4.0)
	Vfx.spark(self, THUG_A + Vector3(0.3, 0.8, 0.35), 0.35, cam, 9.0, Color(1.0, 0.5, 0.2))
	Kit.omni(self, THUG_A + Vector3(0.5, 0.8, 0.6), Color(1.0, 0.6, 0.35), 0.8, 2.2)
	Kit.omni(self, PLAYER + Vector3(-0.6, 0.6, 0.6), Color(1.0, 0.15, 0.2), 1.4, 2.8)
	Kit.glow(self, Kit.bend_point(Vector3(2.6, 1.3, -3.0)), 0.4, Color(0.4, 0.7, 1.0), 5.0, cam)
	Kit.omni(self, Kit.bend_point(Vector3(2.6, 1.3, -3.0)), Color(0.4, 0.65, 1.0), 1.2, 2.5)


func _hud() -> void:
	var at := AtlasTexture.new()
	at.atlas = load("res://spikes/hd2d/sprites/bertha_s.png")
	at.region = Rect2(5, 0, 24, 24)
	var layer := CanvasLayer.new()
	layer.layer = 2
	add_child(layer)
	var hud: Control = Hud.new()
	layer.add_child(hud)
	hud.call(&"setup", {
		"hp": 7, "hp_max": 10, "crowns": 137,
		"objective": "Keep the courier's letter. Fight them, or flee through the cellar trapdoor.",
		"boss_name": "Hired Knives of the Pale Choir", "boss_frac": 0.58, "boss_recent": 0.09,
		"slots": [{"icon": "sword"}, {"icon": "crossbow", "count": 12}, {"icon": "poultice", "count": 2}],
		"companion": "Bertha", "companion_ready": 1.0, "companion_hint": "1",
		"enemies": [
			{"pos": Kit.bend_point(THUG_A + Vector3(0, 1.2, 0)), "frac": 0.35},
			{"pos": Kit.bend_point(THUG_B + Vector3(0, 1.2, 0)), "frac": 0.9},
			{"pos": Kit.bend_point(THUG_C + Vector3(0, 1.2, 0)), "frac": 1.0},
		],
		"map": {
			"scale": 6.5, "origin": PLAYER,
			"rooms": [Rect2(-W, -D, W * 2.0, D * 2.0), Rect2(-W, -1.5, 2.0, 3.0)],
			"enemies": [THUG_A, THUG_B, THUG_C],
			"doors": [Vector3(1.2, 0, -D)],
		},
	}, cam, at)
