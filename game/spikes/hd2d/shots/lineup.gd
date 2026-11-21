extends Node3D
## HD-2D spike: character lineup on the carved floor (pipeline check, art-bible plate).

const Kit := preload("res://spikes/hd2d/lib/kit.gd")
const KK := preload("res://spikes/hd2d/lib/kaykit.gd")
const PixelSprite := preload("res://spikes/hd2d/lib/pixel_sprite.gd")

var cam: Camera3D
var lights: Array[Light3D] = []


func _ready() -> void:
	cam = Kit.camera(self, Vector3(0, 0, 0), 56.0, 0.0, 26.0, 27.0)
	Kit.environment(self, cam, {"ambient": Color(0.5, 0.45, 0.75), "ambient_energy": 1.6, "exposure": 1.2, "glow": 0.35}, 26.0)
	var pm := PlaneMesh.new()
	pm.size = Vector2(24, 14)
	Kit.mesh_node(self, pm, Vector3.ZERO, Kit.floor_material("karak_floor", Color(0.8, 0.78, 0.9), 3.0))
	lights.append(Kit.omni(self, Vector3(0, 6, 1), Color(1.0, 0.85, 0.8), 3.0, 14.0, true))
	lights.append(Kit.omni(self, Vector3(-3, 1.5, -2), Color(1.0, 0.55, 0.25), 3.0, 6.0))
	Kit.apply_bend(self, Vector3.ZERO, cam, 0.0)
	var files: Array[String] = ["adventurers/Knight.glb", "adventurers/Rogue_Hooded.glb", "adventurers/Barbarian.glb", "adventurers/Mage.glb", "adventurers/Rogue.glb", "skeletons/Skeleton_Warrior.glb"]
	var keeps: Array = [["1H_Sword", "Knight_Cape"], ["Knife"], ["1H_Axe", "Barbarian_Hat"], ["Mage_Hat", "1H_Wand"], ["1H_Crossbow"], ["Skeleton_Blade", "Skeleton_Warrior_Helmet"]]
	for i: int in range(files.size()):
		var m := PixelSprite.new_toon_material()
		var k: Array[String] = []
		k.assign(keeps[i])
		var model := KK.character(files[i], m, k, "Idle", 0.3)
		var s: Node3D = PixelSprite.new()
		add_child(s)
		s.global_position = Vector3(-6.0 + i * 2.4, 0, 0)
		s.call(&"setup", cam, model, Vector2i(64, 64), 20.0, lights, m)
	Kit.post_layer(self, {"focus_center": 0.5, "focus_half": 0.25, "blur_px": 4.0, "vignette": 0.4})
