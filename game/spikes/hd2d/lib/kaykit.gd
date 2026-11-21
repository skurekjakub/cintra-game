extends RefCounted
## HD-2D spike: CC0 KayKit assets (Kay Lousberg). Characters become pixel sprites through the
## toon viewport; dungeon props stay full 3D with the bendable environment material.
## KayKit units: a character is about 2.4 units tall. SCALE maps that to our chibi metre.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")
const ROOT := "res://spikes/hd2d/kaykit/"
const SCALE := 0.45
const PROP_SCALE := 1.35

## Accessory meshes hanging off bone attachments; everything not listed in `keep` is hidden.
const ACCESSORIES := ["1H_Sword", "1H_Sword_Offhand", "2H_Sword", "Badge_Shield", "Rectangle_Shield",
	"Round_Shield", "Spike_Shield", "Knight_Helmet", "Knight_Cape", "Barbarian_Hat", "Mage_Hat",
	"Rogue_Hood", "1H_Axe", "1H_Axe_Offhand", "2H_Axe", "Barbarian_Round_Shield", "Mug",
	"1H_Crossbow", "2H_Crossbow", "Knife", "Knife_Offhand", "Throwable", "Spellbook", "Spellbook_open",
	"1H_Wand", "2H_Staff", "Mage_Cape", "Barbarian_Cape", "Rogue_Cape", "Skeleton_Warrior_Helmet",
	"Skeleton_Blade", "Skeleton_Shield_Large_A", "Skeleton_Shield_Small_A", "Skeleton_Axe",
	"Skeleton_Warrior_Cloak", "Skeleton_Minion_Cloak"]


## Loads a rigged KayKit character, retextures it with `toon` and freezes it on one frame.
## recolor: optional palette-swapped texture (see art-src/recolor_kaykit.py).
static func character(file: String, toon: ShaderMaterial, keep: Array[String], anim: String, t: float, recolor: String = "") -> Node3D:
	var ps: PackedScene = load(ROOT + file)
	var n: Node3D = ps.instantiate()
	var tex_set := false
	for c: Node in n.find_children("*", "MeshInstance3D", true, false):
		var mi := c as MeshInstance3D
		if ACCESSORIES.has(String(mi.name)) and not keep.has(String(mi.name)):
			mi.visible = false
			continue
		if not tex_set:
			var src := mi.mesh.surface_get_material(0) as StandardMaterial3D
			if src != null and src.albedo_texture != null:
				var tx: Texture2D = src.albedo_texture
				if recolor != "":
					tx = load(recolor) as Texture2D
				toon.set_shader_parameter(&"use_tex", true)
				toon.set_shader_parameter(&"albedo_tex", tx)
				tex_set = true
		mi.material_override = toon
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	n.scale = Vector3.ONE * SCALE
	var ap := n.find_child("AnimationPlayer", true, false) as AnimationPlayer
	if ap != null and anim != "":
		ap.play(anim)
		ap.seek(t, true)
		ap.pause()
	return n


## Places a KayKit dungeon prop with the bendable UV material (+ optional photo grain).
static func prop(parent: Node3D, file: String, pos: Vector3, yaw: float = 0.0, s: float = 1.0,
		detail: String = "", detail_strength: float = 0.0, tint: Color = Color.WHITE) -> Node3D:
	var ps: PackedScene = load(ROOT + "dungeon/" + file + ".glb")
	var n: Node3D = ps.instantiate()
	parent.add_child(n)
	n.position = pos
	n.rotation_degrees.y = yaw
	n.scale = Vector3.ONE * SCALE * PROP_SCALE * s
	for c: Node in n.find_children("*", "MeshInstance3D", true, false):
		var mi := c as MeshInstance3D
		for i: int in range(mi.mesh.get_surface_count()):
			var src := mi.mesh.surface_get_material(i) as StandardMaterial3D
			var albedo: Texture2D = src.albedo_texture if src != null else null
			var col: Color = src.albedo_color if src != null else Color.WHITE
			var emit := src != null and src.emission_enabled
			var m := Kit.uv_mat(albedo, col * tint, 0.7, 0.0, detail, detail_strength, 0.8)
			if emit:
				m.set_shader_parameter(&"emission", 3.0)
			mi.set_surface_override_material(i, m)
	return n
