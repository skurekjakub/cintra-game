extends Node3D
## HD-2D spike shot 1: the Drowned Rat taproom at night, mid-fight (Act I, scene 1).
## Environment (A10): bespoke Blender set (art-src/env/build_taproom.py: timber framing with
## plaster infill, windows with mullions and wavy glass, stone hearth, bar, stairs, trapdoor,
## clutter, the rain-wet quay outside) + Poly Haven CC0 props, a unique baked plank floor
## (art-src/env/bake_taproom_floor.py), moonlight shafts, lantern and hearth pools.
## Rolling-cylinder world bend, hand-authored pixel sprites lit by the room's lights.
## Camera looks south: the front door is at the top.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")
const Card := preload("res://spikes/hd2d/lib/pixel_card.gd")
const Vfx := preload("res://spikes/hd2d/lib/vfx.gd")
const Hud := preload("res://spikes/hd2d/hud/hud.gd")
const Set := preload("res://spikes/hd2d/lib/taproom.gd")
const Stage := preload("res://spikes/hd2d/lib/stage_walk.gd")

const PLAYER := Vector3(0.5, 0, -0.3)
const THUG_A := Vector3(-0.9, 0, 0.2)
const THUG_B := Vector3(1.9, 0, -1.7)
const THUG_C := Vector3(1.2, 0, -4.3)
const COURIER := Vector3(-6.0, 0, 0.4)
## Bertha (A12, animated): she idles under the bar-end lantern, where the player meets her.
## "--bertha=walk" stages the review walk instead: 3 s idle in the east window's moonlight, then
## straight toward the camera down the aisle east of the trestle, out of the moon into a warm pool.
const BERTHA := Vector3(4.3, 0, 0.9)
## per-light ceiling on her card: the moon spot (energy 14) otherwise burns her white in the shaft
const BERTHA_LIGHT_CAP := 2.0
const BERTHA_WALK: Array[Vector3] = [Vector3(6.5, 0, -2.0), Vector3(6.2, 0, 1.2)]
const DOOR := Vector2(0.4, 2.0)
const W := 8.0
const D := 5.5

var cam: Camera3D
var lights: Array[Light3D] = []
var anchors: Dictionary = {}
## seconds before Bertha's timeline starts (shot_runner sets it to its warm-up when recording)
var lead_in: float = 0.0
const MOON := Color(0.5, 0.68, 1.0)
const FIRE := Color(1.0, 0.6, 0.3)
const CANDLE := Color(1.0, 0.72, 0.44)
const MOON_DIR := Vector3(0.18, -0.62, 0.76)


func _ready() -> void:
	Kit.env_materials.clear()
	cam = Kit.camera(self, Vector3(0.0, 0.0, -0.6), 52.0, 0.0, 21.0, 27.0)
	var we := Kit.environment(self, cam, {
		"ambient": Color(0.36, 0.44, 0.62), "ambient_energy": 1.15, "exposure": 1.18,
		"glow": 0.4, "contrast": 1.08, "saturation": 0.92,
		"fog": true, "fog_density": 0.012, "fog_albedo": Color(0.82, 0.84, 0.9),
	}, 21.0)
	var env := we.environment
	env.ssr_enabled = true
	env.ssr_max_steps = 48
	env.ssr_fade_in = 0.1
	env.ssr_depth_tolerance = 0.3
	env.glow_hdr_threshold = 1.0
	env.volumetric_fog_anisotropy = 0.1
	env.volumetric_fog_gi_inject = 0.0
	env.volumetric_fog_ambient_inject = 0.05
	# SSIL cost ~4 ms on the Adreno X2 for an almost invisible gain here: bounce is faked with fill lights
	env.ssil_enabled = false
	RenderingServer.environment_set_volumetric_fog_volume_size(96, 64)
	# stronger near blur so the hanging net / herbs / lantern in front of the lens read as foreground
	var attrs := we.camera_attributes as CameraAttributesPractical
	attrs.dof_blur_amount = 0.06
	attrs.dof_blur_near_transition = 2.0
	anchors = Set.anchors()
	Set.instance(self, "taproom_arch.glb")
	if ResourceLoader.exists("res://spikes/hd2d/models/env/taproom_props.glb"):
		Set.instance(self, "taproom_props.glb")
	_fire()
	_lamps()
	_outside()
	Kit.apply_bend(self, PLAYER, cam, 13.0)
	_moonlight()
	_fog_energies()
	_characters()
	_vfx()
	Kit.post_layer(self, {"focus_center": 0.52, "focus_half": 0.15, "blur_px": 11.0, "vignette": 0.32,
		"shadow_tint": Color(0.82, 0.9, 1.06), "high_tint": Color(1.03, 1.0, 0.93), "grain": 0.02, "lift": 2.0})
	_hud()
	var dbg := OS.get_environment("A10_DEBUG")
	if dbg.contains("noglass"):
		for n: Node in find_children("glass*", "MeshInstance3D", true, false):
			(n as MeshInstance3D).visible = false
	if dbg.contains("nossr"):
		env.ssr_enabled = false
	if dbg.contains("nossil"):
		env.ssil_enabled = false
	if dbg.contains("noprops"):
		for n: Node in get_children():
			if n.name.begins_with("taproom_props"):
				(n as Node3D).visible = false
	if dbg.contains("nofog"):
		env.volumetric_fog_enabled = false
	if dbg.contains("moononly"):
		for n: Node in find_children("*", "OmniLight3D", true, false):
			(n as OmniLight3D).visible = false
		env.ambient_light_energy = 0.1
	if dbg.contains("nospot"):
		for n: Node in find_children("*", "SpotLight3D", true, false):
			(n as SpotLight3D).visible = false


## Hearth fire, candles (clustered into a few lights), embers.
func _fire() -> void:
	for h: Dictionary in anchors["hearth"]:
		var p := Set.v3(h["pos"])
		for i: int in range(6):
			Kit.flame(self, p + Vector3(0.05 * (i % 2), -0.12, -0.62 + i * 0.25), Vector2(0.42, 0.72 + 0.22 * (i % 3)), cam, float(i) * 3.1, 5.0)
		Kit.glow(self, p + Vector3(0.35, 0.25, 0), 1.7, Color(1.0, 0.45, 0.15), 0.7, cam)
		lights.append(Kit.omni(self, p + Vector3(0.45, 0.5, 0.0), FIRE, 3.4, 8.5, true))
		# fake bounce off the hearthstones and the chimney breast
		Kit.omni(self, p + Vector3(1.6, 1.6, 0.0), FIRE, 0.6, 4.5)
	for e: Dictionary in anchors["embers"]:
		Vfx.embers(self, Set.v3(e["pos"]), Set.v3(e["ext"]) * Vector3(1.0, 0.6, 0.8), Color(1.0, 0.5, 0.2), 16, 0.5)
	var groups: Array = []
	for c: Dictionary in anchors["candles"]:
		var p := Set.v3(c["pos"])
		Kit.flame(self, p, Vector2(0.07, 0.15), cam, p.x * 7.0 + p.z, 5.0)
		Kit.glow(self, p + Vector3(0, 0.07, 0), 0.38, Color(1.0, 0.62, 0.28), 1.1, cam)
		var placed := false
		for g: Array in groups:
			if (g[0] as Vector3).distance_to(p) < 1.4:
				g[1] = int(g[1]) + 1
				placed = true
				break
		if not placed:
			groups.append([p, 1])
	for g: Array in groups:
		var n := int(g[1])
		var gp := g[0] as Vector3
		var far := 0.55 if gp.z < -2.0 else 1.0
		Kit.omni(self, gp + Vector3(0, 0.25, 0), CANDLE, (0.45 + 0.1 * float(n)) * far, 2.4 + 0.2 * float(n))


## Lanterns (hanging, wall, the foreground one) and the cellar glow under the trapdoor.
func _lamps() -> void:
	var shadowed := 0
	for l: Dictionary in anchors["lanterns"]:
		var p := Set.v3(l["pos"])
		var fg: bool = l.get("fg", false)
		Kit.flame(self, p - Vector3(0, 0.07, 0), Vector2(0.08, 0.16), cam, p.x * 3.0, 5.0)
		Kit.glow(self, p, 1.0 if fg else 0.7, Color(1.0, 0.6, 0.28), 1.0, cam)
		var sh := (not fg) and shadowed < 1 and p.z > 0.0
		if sh:
			shadowed += 1
		var rng := 3.0 if fg else (3.4 if p.z < -2.0 else 4.5)
		lights.append(Kit.omni(self, p, CANDLE, 0.8 if fg else 1.3, rng, sh))
	for l: Dictionary in anchors["wall_lamps"]:
		var p := Set.v3(l["pos"])
		Kit.flame(self, p - Vector3(0, 0.07, 0), Vector2(0.08, 0.16), cam, p.x * 5.0, 5.0)
		Kit.glow(self, p, 0.8, Color(1.0, 0.6, 0.28), 1.0, cam)
		Kit.omni(self, p + Vector3(0, 0.1, 0.35), CANDLE, 0.75, 3.2)
	for t: Dictionary in anchors["trapdoor"]:
		var p := Set.v3(t["pos"])
		Kit.omni(self, p, Color(1.0, 0.6, 0.3), 7.0, 3.6)
		Kit.omni(self, p + Vector3(0, 1.5, 0), Color(1.0, 0.62, 0.32), 1.2, 2.2)
		Kit.glow(self, p + Vector3(0, 1.25, 0), 1.3, Color(1.0, 0.55, 0.22), 0.6, cam)
	# soft play-area fill + far-wall wash so the walls read in mid-tones
	# cool moon-bounce fill over the play area: the room's base light is cold, fire pools are local
	Kit.omni(self, Vector3(0.5, 6.5, -0.5), Color(0.62, 0.7, 1.0), 0.7, 14.0)
	Kit.omni(self, Vector3(0.0, 2.6, -4.4), Color(0.52, 0.62, 1.0), 1.0, 6.5)
	Vfx.embers(self, Vector3(0, 1.4, -1.0), Vector3(6.0, 1.2, 4.0), Color(0.42, 0.46, 0.55), 40, 0.12)


## The quay outside: rain, the dock lantern, cold night fill, distant harbour lights.
func _outside() -> void:
	Vfx.rain(self, Vector3(0, 3.2, -7.2), Vector3(9.0, 0.6, 1.5), Color(0.55, 0.65, 1.0, 0.35), 1200)
	for d: Dictionary in anchors["dock"]:
		var p := Set.v3(d["pos"])
		Kit.flame(self, p - Vector3(0, 0.08, 0), Vector2(0.1, 0.2), cam, 4.2, 5.0)
		Kit.glow(self, p, 1.0, Color(1.0, 0.6, 0.28), 1.2, cam)
		Kit.omni(self, p, CANDLE, 2.2, 6.0)
	Kit.omni(self, Vector3(1.2, 3.0, -7.4), Color(0.42, 0.52, 1.0), 2.4, 8.0)
	Kit.omni(self, Vector3(-5.0, 3.0, -7.4), Color(0.42, 0.52, 1.0), 1.6, 7.0)
	Kit.omni(self, Vector3(5.5, 3.0, -7.4), Color(0.42, 0.52, 1.0), 1.6, 7.0)
	for f: Dictionary in anchors["far_lights"]:
		Kit.glow(self, Set.v3(f["pos"]), 0.9 if f.has("boat") else 1.4, Color(1.0, 0.62, 0.3), 2.2, cam)


## Moonlight through every window and the door: a shadowed spot (volumetric) + a shaft mesh.
## Built after the bend so the spots can be aimed at their bent windows.
func _moonlight() -> void:
	var i := 0
	for w: Dictionary in anchors["windows"]:
		var corners: Array = []
		var dir := MOON_DIR
		if String(w.get("axis", "z")) == "x":
			var x := float(w["x"])
			dir = Vector3(-0.78, -0.6, 0.18)
			corners = [Vector3(x, float(w["y0"]), float(w["x0"])), Vector3(x, float(w["y0"]), float(w["x1"])),
				Vector3(x, float(w["y1"]), float(w["x1"])), Vector3(x, float(w["y1"]), float(w["x0"]))]
		else:
			var z := float(w["z"]) - 0.12
			corners = [Vector3(float(w["x0"]), float(w["y0"]), z), Vector3(float(w["x1"]), float(w["y0"]), z),
				Vector3(float(w["x1"]), float(w["y1"]), z), Vector3(float(w["x0"]), float(w["y1"]), z)]
		_moon_opening(corners, dir.normalized(), 0.5 if bool(w.get("barred", false)) else 1.0, float(i))
		i += 1
	for d: Dictionary in anchors["door"]:
		var z := float(d["z"]) - 0.1
		var corners: Array = [Vector3(float(d["x0"]), 0.0, z), Vector3(float(d["x1"]), 0.0, z),
			Vector3(float(d["x1"]), float(d["y1"]), z), Vector3(float(d["x0"]), float(d["y1"]), z)]
		_moon_opening(corners, MOON_DIR.normalized(), 1.3, 9.0)


## Only the fire and the moon may light the fog; small lights stay out of it (no orange haze).
func _fog_energies() -> void:
	for n: Node in find_children("*", "OmniLight3D", true, false):
		var l := n as OmniLight3D
		l.light_volumetric_fog_energy = 0.45 if l.shadow_enabled and l.light_energy > 4.0 else 0.04


func _moon_opening(corners: Array, dir: Vector3, strength: float, seed: float) -> void:
	var c := Vector3.ZERO
	for p: Vector3 in corners:
		c += p
	c /= 4.0
	var bs := Kit.bend_point(c - dir * 1.6)
	var bt := Kit.bend_point(c + dir * 3.0)
	var s := Kit.spot(self, bs, bt, MOON, 14.0 * strength, 7.5, 26.0)
	s.light_volumetric_fog_energy = 0.6
	s.shadow_bias = 0.04
	lights.append(s)
	var reach := c.y / maxf(-dir.y, 0.1)
	if not OS.get_environment("A10_DEBUG").contains("noshaft"):
		Set.shaft(self, corners, dir, reach * 1.25, MOON, 0.22 * strength, seed)


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
	_bertha()
	Kit.omni(self, PLAYER + Vector3(0.3, 1.2, 0.6), Color(1.0, 0.72, 0.45), 1.0, 3.5)


func _bertha() -> void:
	var c: Node3D = Card.new()
	c.set(&"hframes", 8)
	add_child(c)
	c.global_position = Kit.bend_point(BERTHA)
	c.call(&"setup", cam, "bertha_idle", 33)
	c.add_to_group(&"record_track")
	(c.get(&"material") as ShaderMaterial).set_shader_parameter(&"light_cap", BERTHA_LIGHT_CAP)
	var meta: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://spikes/hd2d/sprites/bertha_anim.json"))
	var path: Array[Vector3] = [BERTHA]
	if OS.get_cmdline_user_args().has("--bertha=walk"):
		path = BERTHA_WALK
	var probe := OS.get_environment("A12_PROBE")
	if probe != "":
		path = []
		for p: String in probe.split(";"):
			var xz := p.split_floats(",")
			path.append(Vector3(xz[0], 0, xz[1]))
		for i: int in range(1, path.size()):
			var extra: Node3D = Card.new()
			extra.set(&"hframes", 8)
			add_child(extra)
			extra.global_position = Kit.bend_point(path[i])
			extra.call(&"setup", cam, "bertha_idle", 33)
		path = [path[0]]
	var st: Node = Stage.new()
	st.set(&"lead_in", lead_in)
	add_child(st)
	st.call(&"setup", c, meta, path)


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
	at.atlas = load("res://spikes/hd2d/sprites/bertha_idle.png")
	at.region = Rect2(5, 2, 24, 24)
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
