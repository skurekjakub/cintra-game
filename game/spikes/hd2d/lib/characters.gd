extends RefCounted
## HD-2D spike: the cast. Specs and poses for the rig builder, plus the iron-warden construct.
## Palette rule: each character owns 3-4 big colour blocks plus one accent, so it reads at 32 px.

const Rig := preload("res://spikes/hd2d/lib/rig.gd")


static func hale() -> Dictionary:
	return {
		"skin": Color(0.95, 0.74, 0.6), "hair": Color(0.42, 0.24, 0.12),
		"coat": Color(0.2, 0.3, 0.5), "sleeve": Color(0.2, 0.3, 0.5),
		"pants": Color(0.3, 0.24, 0.2), "boots": Color(0.24, 0.15, 0.1),
		"gloves": Color(0.35, 0.22, 0.14), "cloak": Color(0.72, 0.12, 0.1),
		"belt": Color(0.5, 0.33, 0.15), "weapon": "sword", "head": "hair", "grip_rot": Vector3(-25, 0, 0),
	}


static func courier() -> Dictionary:
	return {
		"skin": Color(0.78, 0.82, 0.7), "hair": Color(0.25, 0.2, 0.18),
		"coat": Color(0.55, 0.12, 0.14), "pants": Color(0.25, 0.25, 0.28),
		"boots": Color(0.2, 0.14, 0.1), "cloak": Color(0.3, 0.33, 0.28),
		"satchel": Color(0.45, 0.3, 0.16), "head": "hair",
	}


static func thug(variant: int) -> Dictionary:
	var coats: Array[Color] = [Color(0.45, 0.36, 0.5), Color(0.5, 0.4, 0.3), Color(0.36, 0.4, 0.5)]
	var weapons: Array[String] = ["cosh", "knife", "cosh"]
	var off: Array[String] = ["none", "none", "lid"]
	return {
		"skin": Color(0.86, 0.66, 0.54), "coat": coats[variant % 3], "sleeve": coats[variant % 3] * 0.85,
		"pants": Color(0.22, 0.2, 0.2), "boots": Color(0.15, 0.11, 0.09), "gloves": Color(0.2, 0.16, 0.14),
		"head": "mask_hood", "hood": Color(0.32, 0.26, 0.36), "mask": Color(0.93, 0.9, 0.82),
		"sash": Color(0.62, 0.08, 0.1), "weapon": weapons[variant % 3], "offhand": off[variant % 3],
		"bulk": 1.15, "metal": Color(0.7, 0.72, 0.75),
	}


static func bertha() -> Dictionary:
	return {
		"skin": Color(0.95, 0.72, 0.6), "hair": Color(0.62, 0.25, 0.12), "head": "bun",
		"kerchief": Color(0.92, 0.88, 0.8), "coat": Color(0.25, 0.42, 0.3), "skirt": Color(0.25, 0.42, 0.3),
		"apron": Color(0.88, 0.84, 0.74), "bulk": 1.25, "offhand": "bottle",
	}


static func maelis() -> Dictionary:
	return {
		"skin": Color(0.96, 0.8, 0.68), "head": "wimple", "veil": Color(0.14, 0.16, 0.32),
		"wimple": Color(0.93, 0.91, 0.86), "coat": Color(0.16, 0.18, 0.34), "skirt": Color(0.16, 0.18, 0.34),
		"offhand": "sling", "eyes": Color(0.15, 0.25, 0.45),
	}


static func pose_slash(root: Node3D) -> void:
	# Follow-through of a wide right-to-left horizontal cut.
	Rig.pose(root, {
		"hips": Vector3(0, -35, 0), "spine": Vector3(8, -25, 0), "neck": Vector3(-5, 30, 0),
		"shoulder_r": Vector3(-80, 0, 75), "elbow_r": Vector3(0, 0, 10),
		"shoulder_l": Vector3(20, 0, -40), "elbow_l": Vector3(-40, 0, 0),
		"hip_r": Vector3(-35, 0, 0), "knee_r": Vector3(30, 0, 0),
		"hip_l": Vector3(30, 0, -8), "knee_l": Vector3(15, 0, 0), "hips_y": -0.03,
	})


static func pose_lunge(root: Node3D) -> void:
	Rig.pose(root, {
		"spine": Vector3(18, 0, 0), "shoulder_r": Vector3(-150, 0, 10), "elbow_r": Vector3(-40, 0, 0),
		"shoulder_l": Vector3(30, 0, -25), "hip_r": Vector3(-40, 0, 0), "knee_r": Vector3(35, 0, 0),
		"hip_l": Vector3(35, 0, 0), "knee_l": Vector3(20, 0, 0), "hips_y": -0.03,
	})


static func pose_stagger(root: Node3D) -> void:
	Rig.pose(root, {
		"spine": Vector3(-22, 0, 12), "neck": Vector3(-20, 0, 10),
		"shoulder_r": Vector3(-30, 0, 70), "elbow_r": Vector3(-50, 0, 0),
		"shoulder_l": Vector3(-20, 0, -80), "elbow_l": Vector3(-30, 0, 0),
		"hip_r": Vector3(25, 0, 0), "knee_r": Vector3(25, 0, 0), "hip_l": Vector3(-20, 0, 0),
	})


static func pose_guard(root: Node3D) -> void:
	Rig.pose(root, {
		"spine": Vector3(10, 0, 0), "shoulder_r": Vector3(-60, 0, 20), "elbow_r": Vector3(-70, 0, 0),
		"shoulder_l": Vector3(-75, 0, -10), "elbow_l": Vector3(-50, 0, 0),
		"hip_r": Vector3(-20, 0, 0), "knee_r": Vector3(25, 0, 0), "hip_l": Vector3(20, 0, 0),
		"knee_l": Vector3(10, 0, 0), "hips_y": -0.02,
	})


static func pose_dead(root: Node3D) -> void:
	Rig.pose(root, {
		"neck": Vector3(10, 25, 0), "shoulder_r": Vector3(0, 0, 80), "elbow_r": Vector3(-30, 0, 0),
		"shoulder_l": Vector3(-40, 0, -20), "elbow_l": Vector3(-90, 0, 0),
		"hip_r": Vector3(0, 0, 12), "knee_r": Vector3(40, 0, 0), "hip_l": Vector3(0, 0, -6),
	})
	root.rotation_degrees = Vector3(-90, 0, 0)
	root.position = Vector3(0, 0.15, 0.5)


## The dwarven iron-warden: a squat riveted construct with a glowing rune core.
static func warden(mat: Material) -> Node3D:
	var root := Node3D.new()
	var iron := Color(0.42, 0.44, 0.5)
	var dark := Color(0.2, 0.21, 0.26)
	var brass := Color(0.78, 0.6, 0.3)
	var rune := Color(0.45, 0.85, 1.0)
	var hips := Rig.joint(root, "hips", Vector3(0, 0.55, 0))
	Rig.part(hips, Rig.box(Vector3(0.6, 0.22, 0.4)), Vector3.ZERO, dark, mat)
	var spine := Rig.joint(hips, "spine", Vector3(0, 0.1, 0))
	Rig.part(spine, Rig.box(Vector3(0.86, 0.62, 0.55)), Vector3(0, 0.33, 0), iron, mat)
	Rig.part(spine, Rig.box(Vector3(0.9, 0.08, 0.58)), Vector3(0, 0.62, 0), brass, mat)
	Rig.part(spine, Rig.box(Vector3(0.9, 0.06, 0.58)), Vector3(0, 0.06, 0), brass, mat)
	var core := Rig.glow_part(spine, Rig.cyl(0.11, 0.11, 0.06, 6), Vector3(0, 0.36, 0.28), rune, mat)
	core.rotation_degrees = Vector3(90, 0, 0)
	var neck := Rig.joint(spine, "neck", Vector3(0, 0.66, 0.04))
	Rig.part(neck, Rig.box(Vector3(0.34, 0.26, 0.32)), Vector3(0, 0.12, 0), iron, mat)
	Rig.glow_part(neck, Rig.box(Vector3(0.26, 0.05, 0.02)), Vector3(0, 0.14, 0.165), rune, mat)
	Rig.part(neck, Rig.box(Vector3(0.38, 0.05, 0.36)), Vector3(0, 0.27, 0), brass, mat)
	for side: int in [-1, 1]:
		var tag := "r" if side < 0 else "l"
		var sh := Rig.joint(spine, "shoulder_" + tag, Vector3(0.52 * side, 0.5, 0))
		Rig.part(sh, Rig.box(Vector3(0.36, 0.22, 0.46)), Vector3(0.04 * side, 0.08, 0), brass, mat, Vector3(0, 0, -15 * side))
		Rig.part(sh, Rig.cyl(0.11, 0.1, 0.34), Vector3(0, -0.18, 0), dark, mat)
		var el := Rig.joint(sh, "elbow_" + tag, Vector3(0, -0.36, 0))
		Rig.part(el, Rig.box(Vector3(0.24, 0.34, 0.24)), Vector3(0, -0.14, 0), iron, mat)
		Rig.part(el, Rig.box(Vector3(0.28, 0.16, 0.28)), Vector3(0, -0.36, 0), dark, mat)
		var hp := Rig.joint(hips, "hip_" + tag, Vector3(0.2 * side, -0.05, 0))
		Rig.part(hp, Rig.box(Vector3(0.24, 0.3, 0.26)), Vector3(0, -0.12, 0), dark, mat)
		Rig.part(hp, Rig.box(Vector3(0.3, 0.2, 0.42)), Vector3(0, -0.38, 0.05), iron, mat)
	var el_l: Node3D = Rig._find(root, "elbow_l")
	var shield := Rig.joint(el_l, "shield", Vector3(0.1, -0.2, 0.22))
	Rig.part(shield, Rig.box(Vector3(0.08, 0.9, 0.62)), Vector3.ZERO, iron, mat, Vector3(0, -90, 0))
	Rig.part(shield, Rig.box(Vector3(0.1, 0.92, 0.1)), Vector3(0, 0, 0.02), brass, mat, Vector3(0, -90, 0))
	Rig.glow_part(shield, Rig.box(Vector3(0.14, 0.14, 0.05)), Vector3(0, 0.1, 0.06), rune, mat)
	Rig.pose(root, {
		"spine": Vector3(12, 15, 0), "shoulder_r": Vector3(-110, 0, -10), "elbow_r": Vector3(-30, 0, 0),
		"shoulder_l": Vector3(-50, 30, 0), "elbow_l": Vector3(-40, 0, 0), "hip_r": Vector3(-15, 0, 0),
		"hip_l": Vector3(15, 0, 0),
	})
	return root
