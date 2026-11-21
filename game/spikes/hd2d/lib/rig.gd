extends RefCounted
## HD-2D spike: builds chibi low-poly characters out of primitives, with named joints to pose.
## Faceted primitives (8 radial segments) read well once downsampled to ~32 px tall.
## Every part shares one toon ShaderMaterial per character; colour is an instance uniform.
## Characters face +Z. Joint names: hips, spine, neck, shoulder_r/l, elbow_r/l, hand_r/l,
## hip_r/l, knee_r/l. Character right = -X.

static func box(s: Vector3) -> BoxMesh:
	var m := BoxMesh.new()
	m.size = s
	return m


static func sph(r: float, segs: int = 8, rings: int = 5) -> SphereMesh:
	var m := SphereMesh.new()
	m.radius = r
	m.height = r * 2.0
	m.radial_segments = segs
	m.rings = rings
	return m


static func cap(r: float, h: float) -> CapsuleMesh:
	var m := CapsuleMesh.new()
	m.radius = r
	m.height = maxf(h, r * 2.0)
	m.radial_segments = 8
	m.rings = 2
	return m


static func cyl(rt: float, rb: float, h: float, segs: int = 8) -> CylinderMesh:
	var m := CylinderMesh.new()
	m.top_radius = rt
	m.bottom_radius = rb
	m.height = h
	m.radial_segments = segs
	m.rings = 1
	return m


static func part(parent: Node3D, mesh: Mesh, pos: Vector3, color: Color, mat: Material,
		rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	mi.rotation_degrees = rot_deg
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	mi.set_instance_shader_parameter(&"albedo", color)
	return mi


static func glow_part(parent: Node3D, mesh: Mesh, pos: Vector3, color: Color, mat: Material) -> MeshInstance3D:
	var mi := part(parent, mesh, pos, color, mat)
	mi.set_instance_shader_parameter(&"emissive", 1.0)
	return mi


static func joint(parent: Node3D, joint_name: String, pos: Vector3) -> Node3D:
	var j := Node3D.new()
	j.name = joint_name
	j.position = pos
	parent.add_child(j)
	return j


static func c(spec: Dictionary, key: String, fallback: Color) -> Color:
	if spec.has(key):
		var v: Color = spec[key]
		return v
	return fallback


## Humanoid chibi: about 1.0 m tall at scale 1.
static func humanoid(spec: Dictionary, mat: Material) -> Node3D:
	var root := Node3D.new()
	var bulk: float = spec.get("bulk", 1.0)
	var skin := c(spec, "skin", Color(0.93, 0.72, 0.58))
	var coat := c(spec, "coat", Color(0.25, 0.3, 0.45))
	var pants := c(spec, "pants", Color(0.25, 0.2, 0.18))
	var boots := c(spec, "boots", Color(0.18, 0.12, 0.09))
	var gloves := c(spec, "gloves", skin)
	var hips := joint(root, "hips", Vector3(0, 0.34, 0))
	part(hips, box(Vector3(0.25 * bulk, 0.1, 0.17)), Vector3(0, 0.0, 0), pants, mat)
	var spine := joint(hips, "spine", Vector3(0, 0.04, 0))
	part(spine, cyl(0.15 * bulk, 0.13 * bulk, 0.27), Vector3(0, 0.13, 0), coat, mat)
	if spec.has("skirt"):
		part(spine, cyl(0.15 * bulk, 0.2 * bulk, 0.26), Vector3(0, -0.1, 0), c(spec, "skirt", coat), mat)
	part(spine, cyl(0.14 * bulk, 0.14 * bulk, 0.04), Vector3(0, 0.0, 0), c(spec, "belt", Color(0.35, 0.22, 0.12)), mat)
	if spec.has("apron"):
		part(spine, box(Vector3(0.22 * bulk, 0.3, 0.02)), Vector3(0, -0.02, 0.15), c(spec, "apron", Color.WHITE), mat, Vector3(-6, 0, 0))
	if spec.has("sash"):
		part(spine, box(Vector3(0.05, 0.34, 0.3 * bulk)), Vector3(0, 0.12, 0.0), c(spec, "sash", Color.RED), mat, Vector3(0, 90, 40))
	if spec.has("cloak"):
		var cl := c(spec, "cloak", Color.DARK_RED)
		part(spine, cyl(0.18 * bulk, 0.2 * bulk, 0.06), Vector3(0, 0.25, 0), cl, mat)
		part(spine, box(Vector3(0.3 * bulk, 0.46, 0.04)), Vector3(0, 0.03, -0.15), cl, mat, Vector3(10, 0, 0))
	if spec.has("satchel"):
		part(spine, box(Vector3(0.1, 0.12, 0.07)), Vector3(0.15 * bulk, -0.02, 0.05), c(spec, "satchel", Color(0.4, 0.28, 0.15)), mat)
	var neck := joint(spine, "neck", Vector3(0, 0.28, 0))
	_head(neck, spec, mat, skin)
	for side: int in [-1, 1]:
		var tag := "r" if side < 0 else "l"
		var sh := joint(spine, "shoulder_" + tag, Vector3(0.19 * bulk * side, 0.23, 0))
		part(sh, cap(0.052, 0.17), Vector3(0, -0.07, 0), coat, mat)
		var el := joint(sh, "elbow_" + tag, Vector3(0, -0.14, 0))
		part(el, cap(0.046, 0.15), Vector3(0, -0.06, 0), c(spec, "sleeve", coat), mat)
		var hand := joint(el, "hand_" + tag, Vector3(0, -0.13, 0))
		part(hand, sph(0.05, 6, 4), Vector3.ZERO, gloves, mat)
		var hp := joint(hips, "hip_" + tag, Vector3(0.075 * bulk * side, -0.02, 0))
		part(hp, cap(0.058, 0.17), Vector3(0, -0.07, 0), pants, mat)
		var kn := joint(hp, "knee_" + tag, Vector3(0, -0.15, 0))
		part(kn, cap(0.052, 0.15), Vector3(0, -0.06, 0), boots, mat)
		part(kn, box(Vector3(0.09, 0.05, 0.15)), Vector3(0, -0.15, 0.03), boots, mat)
	var hand_r: Node3D = root.get_node("hips/spine/shoulder_r/elbow_r/hand_r")
	var hand_l: Node3D = root.get_node("hips/spine/shoulder_l/elbow_l/hand_l")
	_weapon(hand_r, String(spec.get("weapon", "none")), spec, mat)
	_offhand(hand_l, String(spec.get("offhand", "none")), spec, mat)
	return root


static func _head(neck: Node3D, spec: Dictionary, mat: Material, skin: Color) -> void:
	var head := joint(neck, "head", Vector3(0, 0.0, 0))
	var hair := c(spec, "hair", Color(0.35, 0.2, 0.1))
	part(head, sph(0.17, 10, 6), Vector3(0, 0.15, 0), skin, mat)
	var eye := c(spec, "eyes", Color(0.08, 0.05, 0.08))
	var style := String(spec.get("head", "hair"))
	if style != "mask_hood":
		part(head, box(Vector3(0.035, 0.055, 0.02)), Vector3(-0.06, 0.15, 0.158), eye, mat)
		part(head, box(Vector3(0.035, 0.055, 0.02)), Vector3(0.06, 0.15, 0.158), eye, mat)
	match style:
		"hair":
			part(head, sph(0.175, 10, 6), Vector3(0, 0.21, -0.07), hair, mat)
			part(head, box(Vector3(0.3, 0.07, 0.1)), Vector3(0, 0.29, 0.07), hair, mat, Vector3(-30, 0, 0))
			if spec.has("ponytail"):
				part(head, cap(0.05, 0.22), Vector3(0, 0.12, -0.19), hair, mat, Vector3(25, 0, 0))
		"bun":
			part(head, sph(0.175, 10, 6), Vector3(0, 0.21, -0.07), hair, mat)
			part(head, sph(0.08, 8, 4), Vector3(0, 0.33, -0.08), hair, mat)
			if spec.has("kerchief"):
				part(head, cyl(0.17, 0.185, 0.07), Vector3(0, 0.27, -0.02), c(spec, "kerchief", Color.WHITE), mat, Vector3(-15, 0, 0))
		"hood":
			var hc := c(spec, "hood", Color(0.3, 0.3, 0.35))
			part(head, sph(0.2, 10, 6), Vector3(0, 0.18, -0.06), hc, mat)
			part(head, cyl(0.2, 0.24, 0.08), Vector3(0, 0.02, -0.02), hc, mat)
		"wimple":
			var w := c(spec, "wimple", Color(0.92, 0.9, 0.85))
			var veil := c(spec, "veil", Color(0.12, 0.14, 0.28))
			part(head, sph(0.195, 10, 6), Vector3(0, 0.17, -0.05), veil, mat)
			part(head, box(Vector3(0.3, 0.05, 0.06)), Vector3(0, 0.27, 0.1), w, mat, Vector3(-15, 0, 0))
			part(head, cyl(0.15, 0.2, 0.09), Vector3(0, 0.02, 0.0), w, mat)
			part(head, box(Vector3(0.12, 0.34, 0.05)), Vector3(0, 0.0, -0.2), veil, mat, Vector3(15, 0, 0))
		"mask_hood":
			var hc2 := c(spec, "hood", Color(0.2, 0.18, 0.22))
			part(head, sph(0.2, 10, 6), Vector3(0, 0.18, -0.05), hc2, mat)
			part(head, cyl(0.2, 0.25, 0.08), Vector3(0, 0.02, -0.02), hc2, mat)
			var mask := c(spec, "mask", Color(0.9, 0.88, 0.8))
			part(head, box(Vector3(0.24, 0.2, 0.05)), Vector3(0, 0.15, 0.15), mask, mat, Vector3(-8, 0, 0))
			part(head, box(Vector3(0.06, 0.025, 0.02)), Vector3(-0.055, 0.17, 0.18), eye, mat)
			part(head, box(Vector3(0.06, 0.025, 0.02)), Vector3(0.055, 0.17, 0.18), eye, mat)
			part(head, box(Vector3(0.02, 0.08, 0.02)), Vector3(0, 0.1, 0.18), c(spec, "mark", Color(0.7, 0.1, 0.1)), mat)
		"cap":
			part(head, sph(0.175, 10, 6), Vector3(0, 0.21, -0.07), hair, mat)
			part(head, cyl(0.19, 0.2, 0.08), Vector3(0, 0.3, -0.02), c(spec, "hat", Color(0.3, 0.2, 0.15)), mat, Vector3(-10, 0, 0))
		"bald":
			part(head, sph(0.12, 8, 4), Vector3(0, 0.1, -0.1), hair, mat)
	if spec.has("beard"):
		part(head, box(Vector3(0.2, 0.12, 0.1)), Vector3(0, 0.05, 0.12), c(spec, "beard", hair), mat)


static func _weapon(hand: Node3D, kind: String, spec: Dictionary, mat: Material) -> void:
	if kind == "none":
		return
	var grip := joint(hand, "grip", Vector3.ZERO)
	var gr: Vector3 = spec.get("grip_rot", Vector3(-90, 0, 0))
	grip.rotation_degrees = gr
	var steel := c(spec, "metal", Color(0.78, 0.8, 0.86))
	var leather := Color(0.3, 0.17, 0.1)
	match kind:
		"sword":
			part(grip, cyl(0.018, 0.018, 0.12), Vector3(0, 0.02, 0), leather, mat)
			part(grip, box(Vector3(0.16, 0.025, 0.04)), Vector3(0, -0.05, 0), c(spec, "guard", Color(0.8, 0.6, 0.25)), mat)
			part(grip, box(Vector3(0.07, 0.62, 0.03)), Vector3(0, -0.37, 0), steel, mat)
		"cosh":
			part(grip, cyl(0.04, 0.025, 0.36), Vector3(0, -0.14, 0), Color(0.35, 0.24, 0.15), mat)
		"knife":
			part(grip, box(Vector3(0.035, 0.28, 0.01)), Vector3(0, -0.15, 0), steel, mat)
		"hammer":
			part(grip, cyl(0.03, 0.03, 0.7), Vector3(0, -0.3, 0), Color(0.25, 0.22, 0.22), mat)
			part(grip, box(Vector3(0.3, 0.18, 0.18)), Vector3(0, -0.65, 0), steel, mat)


static func _offhand(hand: Node3D, kind: String, spec: Dictionary, mat: Material) -> void:
	match kind:
		"lid":
			part(hand, cyl(0.16, 0.16, 0.03, 10), Vector3(0.03, 0, 0.04), Color(0.45, 0.3, 0.16), mat, Vector3(0, 0, 90))
			part(hand, cyl(0.165, 0.165, 0.015, 10), Vector3(0.05, 0, 0.04), Color(0.3, 0.3, 0.32), mat, Vector3(0, 0, 90))
		"bottle":
			part(hand, cyl(0.035, 0.045, 0.14), Vector3(0, -0.06, 0), Color(0.2, 0.45, 0.25), mat)
		"lantern":
			part(hand, box(Vector3(0.09, 0.12, 0.09)), Vector3(0, -0.1, 0), Color(1.0, 0.8, 0.4), mat)
		"sling":
			part(hand, cyl(0.01, 0.01, 0.3), Vector3(0, -0.15, 0), Color(0.5, 0.35, 0.2), mat)
		_:
			pass


## Sets joint rotations (degrees). Keys are joint names; "hips_y" lowers the hips.
static func pose(root: Node3D, p: Dictionary) -> void:
	for key: String in p.keys():
		if key == "hips_y":
			var hips: Node3D = root.get_node("hips")
			var dy: float = p[key]
			hips.position.y += dy
			continue
		var j := _find(root, key)
		if j != null:
			var r: Vector3 = p[key]
			j.rotation_degrees = r


static func _find(root: Node, joint_name: String) -> Node3D:
	if root.name == joint_name and root is Node3D:
		return root as Node3D
	for ch: Node in root.get_children():
		var f := _find(ch, joint_name)
		if f != null:
			return f
	return null
