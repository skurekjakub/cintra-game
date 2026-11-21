extends RefCounted
## HD-2D spike: modular environment pieces (walls, posts, tables, barrels, railings, pillars).
## Everything is chunky on purpose: at ~70 px per metre, thin detail vanishes.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")


## Axis-aligned wall from a to b (floor points). Stone footing + timber upper + posts + beam.
static func timber_wall(parent: Node3D, a: Vector3, b: Vector3, h: float, footing: float, stone: Material, timber: Material, wood: Material) -> void:
	var d := b - a
	var length := d.length()
	var mid := (a + b) * 0.5
	var yaw := rad_to_deg(atan2(-d.z, d.x))
	var t := 0.4
	Kit.box(parent, Vector3(length, footing, t), mid + Vector3(0, footing * 0.5, 0), stone, Vector3(0, yaw, 0))
	Kit.box(parent, Vector3(length, h - footing, t * 0.8), mid + Vector3(0, footing + (h - footing) * 0.5, 0), timber, Vector3(0, yaw, 0))
	Kit.box(parent, Vector3(length + 0.2, 0.28, t + 0.2), mid + Vector3(0, h - 0.14, 0), wood, Vector3(0, yaw, 0))
	Kit.box(parent, Vector3(length, 0.16, t + 0.16), mid + Vector3(0, footing + 0.08, 0), wood, Vector3(0, yaw, 0))
	var n := maxi(1, int(length / 3.0))
	for i: int in range(n + 1):
		var p := a + d * (float(i) / float(n))
		Kit.box(parent, Vector3(0.32, h, 0.32), p + Vector3(0, h * 0.5, 0), wood, Vector3(0, yaw, 0))


static func round_table(parent: Node3D, pos: Vector3, top: Material, wood: Material) -> void:
	Kit.cyl(parent, 0.72, 0.72, 0.08, pos + Vector3(0, 0.76, 0), top, 20)
	Kit.cyl(parent, 0.09, 0.14, 0.72, pos + Vector3(0, 0.36, 0), wood, 8)
	Kit.cyl(parent, 0.35, 0.4, 0.06, pos + Vector3(0, 0.03, 0), wood, 10)
	for i: int in range(4):
		var a := float(i) * TAU / 4.0 + 0.6
		var sp := pos + Vector3(cos(a), 0, sin(a)) * 1.05
		Kit.cyl(parent, 0.2, 0.2, 0.07, sp + Vector3(0, 0.46, 0), top, 10)
		Kit.cyl(parent, 0.05, 0.07, 0.44, sp + Vector3(0, 0.22, 0), wood, 6)


static func trestle(parent: Node3D, pos: Vector3, yaw: float, top: Material, wood: Material) -> void:
	var r := Vector3(0, yaw, 0)
	var b := Basis.from_euler(Vector3(0, deg_to_rad(yaw), 0))
	Kit.box(parent, Vector3(2.6, 0.08, 0.85), pos + Vector3(0, 0.76, 0), top, r)
	for s: float in [-1.0, 1.0]:
		Kit.box(parent, Vector3(0.1, 0.72, 0.7), pos + b * Vector3(1.05 * s, 0.36, 0), wood, r)
		Kit.box(parent, Vector3(2.5, 0.07, 0.32), pos + b * Vector3(0, 0.45, 0.75 * s), top, r)
		Kit.box(parent, Vector3(0.08, 0.42, 0.26), pos + b * Vector3(1.0, 0.21, 0.75 * s), wood, r)
		Kit.box(parent, Vector3(0.08, 0.42, 0.26), pos + b * Vector3(-1.0, 0.21, 0.75 * s), wood, r)


static func barrel(parent: Node3D, pos: Vector3, wood: Material, iron: Material, lying: bool = false) -> void:
	var mi := Kit.cyl(parent, 0.34, 0.34, 0.9, pos + Vector3(0, 0.45, 0), wood, 14)
	var bulge := Kit.cyl(parent, 0.38, 0.38, 0.5, pos + Vector3(0, 0.45, 0), wood, 14)
	var hoop1 := Kit.cyl(parent, 0.37, 0.37, 0.06, pos + Vector3(0, 0.2, 0), iron, 14)
	var hoop2 := Kit.cyl(parent, 0.37, 0.37, 0.06, pos + Vector3(0, 0.7, 0), iron, 14)
	if lying:
		for n: Node3D in [mi, bulge, hoop1, hoop2]:
			n.rotation_degrees = Vector3(0, 30, 90)
			n.position.y = 0.38


static func crate(parent: Node3D, pos: Vector3, s: float, yaw: float, wood: Material, dark: Material) -> void:
	Kit.box(parent, Vector3(s, s, s), pos + Vector3(0, s * 0.5, 0), wood, Vector3(0, yaw, 0))
	Kit.box(parent, Vector3(s + 0.02, 0.06, s + 0.02), pos + Vector3(0, s - 0.03, 0), dark, Vector3(0, yaw, 0))
	Kit.box(parent, Vector3(s + 0.02, 0.06, s + 0.02), pos + Vector3(0, 0.03, 0), dark, Vector3(0, yaw, 0))


static func mug(parent: Node3D, pos: Vector3, mat: Material) -> void:
	Kit.cyl(parent, 0.05, 0.05, 0.11, pos + Vector3(0, 0.055, 0), mat, 8)


static func bottle(parent: Node3D, pos: Vector3, mat: Material) -> void:
	Kit.cyl(parent, 0.045, 0.05, 0.2, pos + Vector3(0, 0.1, 0), mat, 8)
	Kit.cyl(parent, 0.018, 0.025, 0.1, pos + Vector3(0, 0.25, 0), mat, 6)


## Chunky iron railing along a -> b: posts with finials, two rails, dense balusters.
static func railing(parent: Node3D, a: Vector3, b: Vector3, h: float, iron: Material, accent: Material) -> void:
	var d := b - a
	var length := d.length()
	var yaw := rad_to_deg(atan2(-d.z, d.x))
	var mid := (a + b) * 0.5
	Kit.box(parent, Vector3(length, 0.12, 0.22), mid + Vector3(0, h, 0), iron, Vector3(0, yaw, 0))
	Kit.box(parent, Vector3(length, 0.07, 0.14), mid + Vector3(0, 0.22, 0), iron, Vector3(0, yaw, 0))
	Kit.box(parent, Vector3(length, 0.2, 0.36), mid + Vector3(0, 0.1, 0), accent, Vector3(0, yaw, 0))
	var n := int(length / 0.18)
	for i: int in range(n + 1):
		var p := a + d * (float(i) / float(n))
		Kit.box(parent, Vector3(0.045, h - 0.2, 0.045), p + Vector3(0, 0.2 + (h - 0.2) * 0.5, 0), iron, Vector3(0, yaw + 45.0, 0))
	var posts := maxi(1, int(length / 2.0))
	for i: int in range(posts + 1):
		var p := a + d * (float(i) / float(posts))
		Kit.box(parent, Vector3(0.2, h + 0.25, 0.2), p + Vector3(0, (h + 0.25) * 0.5, 0), iron, Vector3(0, yaw, 0))
		Kit.sphere(parent, 0.13, p + Vector3(0, h + 0.34, 0), accent)
		Kit.box(parent, Vector3(0.12, 0.25, 0.12), p + Vector3(0, h + 0.55, 0), iron, Vector3(0, yaw + 45.0, 0))


## Heavy square pillar with plinth, banding and capital.
static func pillar(parent: Node3D, pos: Vector3, w: float, h: float, stone: Material, trim: Material) -> void:
	Kit.box(parent, Vector3(w + 0.4, 0.4, w + 0.4), pos + Vector3(0, 0.2, 0), trim)
	Kit.box(parent, Vector3(w + 0.2, 0.2, w + 0.2), pos + Vector3(0, 0.5, 0), stone)
	Kit.box(parent, Vector3(w, h, w), pos + Vector3(0, h * 0.5, 0), stone)
	for y: float in [1.4, 2.6]:
		Kit.box(parent, Vector3(w + 0.1, 0.14, w + 0.1), pos + Vector3(0, y, 0), trim)
	Kit.box(parent, Vector3(w + 0.5, 0.35, w + 0.5), pos + Vector3(0, h, 0), trim)
