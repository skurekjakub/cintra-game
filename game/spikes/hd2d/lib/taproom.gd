extends RefCounted
## HD-2D spike (A10): loads the Blender-built Drowned Rat set (art-src/env/build_taproom.py) and
## re-materials it with bend-aware shaders:
##   TRI_*   -> world-space triplanar Poly Haven sets with baked vertex wear (env_set.gdshader)
##   FLOOR_* -> the unique baked floor (floor_room.gdshader)
##   GLASS   -> wavy window glass;  EMIT_* -> emissive;  COL_* -> plain PBR colour
##   textured (Poly Haven models) -> env_set_uv.gdshader keeping their own albedo/normal/ORM maps
## Also builds the light shafts and reads the light anchors exported next to the glTF.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")
const SET_TRI := preload("res://spikes/hd2d/shaders/env_set.gdshader")
const SET_UV := preload("res://spikes/hd2d/shaders/env_set_uv.gdshader")
const FLOOR := preload("res://spikes/hd2d/shaders/floor_room.gdshader")
const GLASS := preload("res://spikes/hd2d/shaders/glass_wavy.gdshader")
const SHAFT := preload("res://spikes/hd2d/shaders/vfx_shaft.gdshader")
const ROOT := "res://spikes/hd2d/models/env/"
const BAKED := "res://spikes/hd2d/textures/baked/"

## name -> [photo set, tint, metres per repeat, {extra uniforms}]
const TRI := {
	"TRI_timber": ["rough_wood", Color(0.86, 0.6, 0.4), 1.5, {"desat": 0.75, "rough_mul": 1.0}],
	"TRI_timber_dark": ["rough_wood", Color(0.55, 0.38, 0.27), 1.4, {"desat": 0.75}],
	"TRI_planks": ["rough_wood", Color(0.98, 0.72, 0.5), 1.1, {"desat": 0.7}],
	"TRI_tabletop": ["wood_table_worn", Color(0.82, 0.68, 0.54), 1.3, {"desat": 0.55, "rough_mul": 0.9}],
	"TRI_plaster": ["rough_plaster_03", Color(1.75, 1.6, 1.32), 2.4, {"desat": 0.9, "macro": 0.45, "edge_wear": 0.0}],
	"TRI_stone": ["quarry_wall", Color(1.1, 1.02, 0.94), 1.3, {"desat": 0.5, "edge_wear": 0.7}],
	"TRI_stone_dark": ["quarry_wall", Color(0.32, 0.28, 0.26), 1.2, {"desat": 0.4}],
	"TRI_flag": ["quarry_wall", Color(0.8, 0.74, 0.68), 0.9, {"desat": 0.5, "rough_mul": 0.8, "edge_wear": 0.9}],
	"TRI_iron": ["rusty_metal_02", Color(0.42, 0.36, 0.32), 0.6, {"desat": 0.3, "metallic": 0.35, "edge_wear": 1.0}],
	"TRI_quay": ["rough_wood", Color(0.62, 0.52, 0.46), 1.2, {"desat": 0.8, "rough_mul": 0.45, "wet": 0.8}],
	"TRI_bark": ["rough_wood", Color(0.5, 0.36, 0.26), 0.5, {"desat": 0.5}],
	"TRI_crock": ["clay_plaster", Color(1.0, 0.8, 0.6), 0.35, {"desat": 0.0, "rough_mul": 0.55}],
}

const EMIT := {
	"EMIT_lamp": [Color(1.0, 0.62, 0.3), 3.5],
	"EMIT_far_window": [Color(1.0, 0.58, 0.26), 2.2],
	"EMIT_cellar": [Color(1.0, 0.55, 0.26), 0.9],
	"COL_ember": [Color(1.0, 0.32, 0.06), 3.0],
}

static var _mats: Dictionary = {}


static func tri(mat_name: String) -> ShaderMaterial:
	if _mats.has(mat_name):
		return _mats[mat_name]
	var spec: Array = TRI[mat_name]
	var m := ShaderMaterial.new()
	m.shader = SET_TRI
	var set_name: String = spec[0]
	m.set_shader_parameter(&"albedo_tex", Kit.tex(set_name, "diff"))
	m.set_shader_parameter(&"normal_tex", Kit.tex(set_name, "nor"))
	m.set_shader_parameter(&"rough_tex", Kit.tex(set_name, "rough"))
	m.set_shader_parameter(&"tint", spec[1])
	m.set_shader_parameter(&"scale", spec[2])
	var extra: Dictionary = spec[3]
	for k: String in extra.keys():
		m.set_shader_parameter(StringName(k), extra[k])
	_mats[mat_name] = m
	return Kit._register(m)


static func floor_mat() -> ShaderMaterial:
	if _mats.has("FLOOR_room"):
		return _mats["FLOOR_room"]
	var m := ShaderMaterial.new()
	m.shader = FLOOR
	for map: String in ["albedo", "normal", "rough", "ao", "height"]:
		m.set_shader_parameter(StringName(map + "_tex"), load(BAKED + "taproom_floor_" + map + ".png") as Texture2D)
	_mats["FLOOR_room"] = m
	return Kit._register(m)


static func glass() -> ShaderMaterial:
	if _mats.has("GLASS"):
		return _mats["GLASS"]
	var m := ShaderMaterial.new()
	m.shader = GLASS
	_mats["GLASS"] = m
	return Kit._register(m)


## Converts one imported glTF material into its bend-aware replacement.
static func convert_mat(src: Material, has_vcol: bool = true) -> Material:
	var mat_name := src.resource_name if src != null else ""
	if TRI.has(mat_name):
		return tri(mat_name)
	if mat_name.begins_with("FLOOR_"):
		return floor_mat()
	if mat_name == "GLASS":
		return glass()
	if mat_name == "RUG":
		var rm := ShaderMaterial.new()
		rm.shader = SET_UV
		rm.set_shader_parameter(&"albedo_tex", load(BAKED + "taproom_rug_albedo.png") as Texture2D)
		rm.set_shader_parameter(&"roughness", 0.95)
		rm.set_shader_parameter(&"grime", 0.5)
		_mats["RUG"] = rm
		return Kit._register(rm)
	var key := "uv|" + mat_name + "|" + str(src.get_instance_id() if src != null else 0)
	if mat_name.begins_with("COL_") or mat_name.begins_with("EMIT_"):
		key = "uv|" + mat_name + ("" if has_vcol else "|novc")
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = SET_UV
	var sm := src as BaseMaterial3D
	if sm != null:
		m.set_shader_parameter(&"albedo_color", Color(sm.albedo_color.r, sm.albedo_color.g, sm.albedo_color.b))
		m.set_shader_parameter(&"roughness", sm.roughness)
		m.set_shader_parameter(&"metallic", sm.metallic)
		if sm.albedo_texture != null:
			m.set_shader_parameter(&"albedo_tex", sm.albedo_texture)
		if sm.normal_enabled and sm.normal_texture != null:
			m.set_shader_parameter(&"normal_tex", sm.normal_texture)
			m.set_shader_parameter(&"use_normal", true)
			m.set_shader_parameter(&"normal_scale", sm.normal_scale)
		if sm.roughness_texture != null:
			m.set_shader_parameter(&"orm_tex", sm.roughness_texture)
			m.set_shader_parameter(&"use_orm", true)
			# scanned props: no glitter under the hard moon / lantern lights at this distance
			m.set_shader_parameter(&"rough_min", 0.5)
			m.set_shader_parameter(&"metallic", maxf(sm.metallic, 0.0))
	if EMIT.has(mat_name):
		var e: Array = EMIT[mat_name]
		m.set_shader_parameter(&"emission_color", e[0])
		m.set_shader_parameter(&"emission", e[1])
	if mat_name.begins_with("COL_glass"):
		m.set_shader_parameter(&"sheen", 0.4)
	if mat_name == "COL_sky":
		m.set_shader_parameter(&"emission_color", Color(0.05, 0.07, 0.16))
		m.set_shader_parameter(&"emission", 1.0)
	if mat_name == "COL_water":
		m.set_shader_parameter(&"sheen", 0.5)
	if not has_vcol:
		# meshes without a colour attribute read COLOR = (1,1,1,1): that would mean "fully wet + grimy"
		for k: String in ["cavity", "edge_wear", "grime", "wet"]:
			m.set_shader_parameter(StringName(k), 0.0)
	_mats[key] = m
	return Kit._register(m)


const NO_SHADOW := ["FG_beams", "FG_hang", "glass", "lamp_glass", "far", "water"]


## Instances a set glTF under parent and swaps every material. Returns the root.
static func instance(parent: Node3D, file: String) -> Node3D:
	var ps: PackedScene = load(ROOT + file)
	var n: Node3D = ps.instantiate()
	parent.add_child(n)
	for c: Node in n.find_children("*", "MeshInstance3D", true, false):
		var mi := c as MeshInstance3D
		for i: int in range(mi.mesh.get_surface_count()):
			var arrays := mi.mesh.surface_get_arrays(i)
			var has_vcol: bool = arrays[Mesh.ARRAY_COLOR] != null
			mi.set_surface_override_material(i, convert_mat(mi.mesh.surface_get_material(i), has_vcol))
		var nm := String(mi.name)
		for prefix: String in NO_SHADOW:
			if nm.begins_with(prefix):
				mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return n


static func anchors() -> Dictionary:
	var txt := FileAccess.get_file_as_string(ROOT + "taproom_anchors.json")
	var d: Variant = JSON.parse_string(txt)
	return d as Dictionary


static func v3(a: Variant) -> Vector3:
	var arr := a as Array
	return Vector3(float(arr[0]), float(arr[1]), float(arr[2]))


## A light shaft through a rectangular opening. `corners` are the 4 opening corners (world,
## unbent), `dir` the light direction, `length` how far the shaft reaches. Several crossed
## additive sheets give volume from any angle.
static func shaft(parent: Node3D, corners: Array, dir: Vector3, length: float, color: Color, intensity: float, seed: float) -> MeshInstance3D:
	var c0: Vector3 = corners[0]
	var c1: Vector3 = corners[1]
	var c2: Vector3 = corners[2]
	var c3: Vector3 = corners[3]
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var sheets: Array = []
	# 5 sheets spanning the opening's width at different heights + 3 spanning its height
	for k: int in range(5):
		var t := (float(k) + 0.5) / 5.0
		sheets.append([c0.lerp(c3, t), c1.lerp(c2, t)])
	for k: int in range(3):
		var t := (float(k) + 0.5) / 3.0
		sheets.append([c0.lerp(c1, t), c3.lerp(c2, t)])
	var segs := 10
	for sh: Array in sheets:
		var a: Vector3 = sh[0]
		var b: Vector3 = sh[1]
		for s: int in range(segs):
			var t0 := float(s) / segs
			var t1 := float(s + 1) / segs
			var p00 := a + dir * length * t0
			var p10 := b + dir * length * t0
			var p01 := a + dir * length * t1
			var p11 := b + dir * length * t1
			# widen slightly with distance (soft penumbra)
			var spread := (b - a).normalized() * 0.08
			p01 -= spread * t1
			p11 += spread * t1
			for v: Array in [[p00, Vector2(0, t0)], [p10, Vector2(1, t0)], [p11, Vector2(1, t1)],
					[p00, Vector2(0, t0)], [p11, Vector2(1, t1)], [p01, Vector2(0, t1)]]:
				st.set_uv(v[1])
				st.add_vertex(v[0])
	st.generate_normals()
	var mi := MeshInstance3D.new()
	mi.mesh = st.commit()
	var m := ShaderMaterial.new()
	m.shader = SHAFT
	m.set_shader_parameter(&"color", color)
	m.set_shader_parameter(&"intensity", intensity)
	m.set_shader_parameter(&"seed", seed)
	Kit._register(m)
	mi.material_override = m
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	return mi
