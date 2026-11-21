extends RefCounted
## HD-2D spike: environment kit. PBR materials from the CC0 Poly Haven sets, modular blocks,
## lights, flames and the WorldEnvironment / post stack.

const PH := "res://spikes/hd2d/textures/ph/"
const TRIPLANAR := preload("res://spikes/hd2d/shaders/env_triplanar.gdshader")
const ENV_UV := preload("res://spikes/hd2d/shaders/env_uv.gdshader")
const FLOOR := preload("res://spikes/hd2d/shaders/floor_baked.gdshader")
const FLAME := preload("res://spikes/hd2d/shaders/vfx_flame.gdshader")
const GLOW := preload("res://spikes/hd2d/shaders/vfx_glow.gdshader")
const POST := preload("res://spikes/hd2d/shaders/post_grade.gdshader")
const BAKED := "res://spikes/hd2d/textures/baked/"

static var _cache: Dictionary = {}
## Every environment material, so the world bend can be set on all of them at once.
static var env_materials: Array[ShaderMaterial] = []
static var bend_pivot: Vector3 = Vector3.ZERO
static var bend_fwd: Vector3 = Vector3.FORWARD
static var bend_radius: float = 0.0


static func tex(set_name: String, map: String) -> Texture2D:
	return load(PH + set_name + "/" + map + ".jpg") as Texture2D


static func _register(m: ShaderMaterial) -> ShaderMaterial:
	env_materials.append(m)
	m.set_shader_parameter(&"bend_pivot", bend_pivot)
	m.set_shader_parameter(&"bend_fwd", bend_fwd)
	m.set_shader_parameter(&"bend_radius", bend_radius)
	return m


## Triplanar world-space PBR material. scale = metres covered by one texture repeat.
static func pbr(set_name: String, tint: Color, scale: float, rough_mul: float = 1.0) -> ShaderMaterial:
	var key := "%s|%s|%f|%f" % [set_name, tint, scale, rough_mul]
	if _cache.has(key):
		var cached: ShaderMaterial = _cache[key]
		return cached
	var m := ShaderMaterial.new()
	m.shader = TRIPLANAR
	m.set_shader_parameter(&"albedo_tex", tex(set_name, "diff"))
	m.set_shader_parameter(&"normal_tex", tex(set_name, "nor"))
	m.set_shader_parameter(&"rough_tex", tex(set_name, "rough"))
	m.set_shader_parameter(&"ao_tex", tex(set_name, "ao"))
	m.set_shader_parameter(&"tint", tint)
	m.set_shader_parameter(&"scale", scale)
	m.set_shader_parameter(&"rough_mul", rough_mul)
	_cache[key] = m
	return _register(m)


## UV-mapped material (KayKit atlases or plain colour), optionally with photo grain.
static func uv_mat(albedo: Texture2D, tint: Color, rough: float = 0.75, metal: float = 0.0, detail: String = "", detail_strength: float = 0.0, detail_scale: float = 1.0) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = ENV_UV
	if albedo != null:
		m.set_shader_parameter(&"albedo_tex", albedo)
	m.set_shader_parameter(&"tint", tint)
	m.set_shader_parameter(&"roughness", rough)
	m.set_shader_parameter(&"metallic", metal)
	if detail != "":
		m.set_shader_parameter(&"detail_tex", tex(detail, "diff"))
		m.set_shader_parameter(&"detail_normal", tex(detail, "nor"))
		m.set_shader_parameter(&"detail_strength", detail_strength)
		m.set_shader_parameter(&"detail_scale", detail_scale)
	return _register(m)


static func flat(color: Color, rough: float = 0.8, metal: float = 0.0) -> ShaderMaterial:
	return uv_mat(null, color, rough, metal)


static func emissive(color: Color, energy: float) -> ShaderMaterial:
	var m := uv_mat(null, color, 0.5)
	m.set_shader_parameter(&"emission", energy)
	return m


## Baked carved floor (art-src/bake_floors.py). panel = metres per baked panel.
static func floor_material(panel_name: String, tint: Color, panel: float) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = FLOOR
	for map: String in ["albedo", "normal", "rough", "ao", "height"]:
		m.set_shader_parameter(StringName(map + "_tex"), load(BAKED + panel_name + "_" + map + ".png") as Texture2D)
	m.set_shader_parameter(&"tint", tint)
	m.set_shader_parameter(&"panel", panel)
	return _register(m)


## Same math as bend.gdshaderinc, for placing sprites, lights and VFX on the bent world.
static func bend_point(w: Vector3) -> Vector3:
	if bend_radius <= 0.0:
		return w
	var rel := w - bend_pivot
	var d := rel.dot(bend_fwd)
	if d <= 0.0:
		return w
	var th := d / bend_radius
	var side := rel - bend_fwd * d
	side.y = 0.0
	var r := bend_radius + rel.y
	return bend_pivot + side + bend_fwd * (r * sin(th)) + Vector3(0.0, r * cos(th) - bend_radius, 0.0)


## Sets the bend on every environment material and moves loose nodes (lights, particles,
## billboards, VFX) to their bent positions. Call once after building the scene.
static func apply_bend(root: Node, pivot: Vector3, cam: Camera3D, radius: float) -> void:
	var f := -cam.global_basis.z
	bend_fwd = Vector3(f.x, 0.0, f.z).normalized()
	bend_pivot = pivot
	bend_radius = radius
	for m: ShaderMaterial in env_materials:
		m.set_shader_parameter(&"bend_pivot", bend_pivot)
		m.set_shader_parameter(&"bend_fwd", bend_fwd)
		m.set_shader_parameter(&"bend_radius", bend_radius)
	for n: Node in root.find_children("*", "Node3D", true, false):
		var n3 := n as Node3D
		if n3 is Light3D or n3 is GPUParticles3D or n3.has_meta(&"bend_move"):
			n3.global_position = bend_point(n3.global_position)


static func mesh_node(parent: Node3D, mesh: Mesh, pos: Vector3, mat: Material, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	mi.rotation_degrees = rot_deg
	parent.add_child(mi)
	return mi


static func box(parent: Node3D, size: Vector3, pos: Vector3, mat: Material, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var m := BoxMesh.new()
	m.size = size
	return mesh_node(parent, m, pos, mat, rot_deg)


static func cyl(parent: Node3D, rt: float, rb: float, h: float, pos: Vector3, mat: Material, segs: int = 16) -> MeshInstance3D:
	var m := CylinderMesh.new()
	m.top_radius = rt
	m.bottom_radius = rb
	m.height = h
	m.radial_segments = segs
	return mesh_node(parent, m, pos, mat)


static func sphere(parent: Node3D, r: float, pos: Vector3, mat: Material) -> MeshInstance3D:
	var m := SphereMesh.new()
	m.radius = r
	m.height = r * 2.0
	return mesh_node(parent, m, pos, mat)


static func omni(parent: Node3D, pos: Vector3, color: Color, energy: float, rng: float, shadow: bool = false) -> OmniLight3D:
	var l := OmniLight3D.new()
	l.position = pos
	l.light_color = color
	l.light_energy = energy
	l.omni_range = rng
	l.omni_attenuation = 1.3
	l.shadow_enabled = shadow
	l.shadow_blur = 1.5
	l.light_specular = 0.6
	l.light_volumetric_fog_energy = 0.25
	parent.add_child(l)
	return l


static func spot(parent: Node3D, pos: Vector3, target: Vector3, color: Color, energy: float, rng: float, angle: float) -> SpotLight3D:
	var l := SpotLight3D.new()
	parent.add_child(l)
	l.position = pos
	l.look_at_from_position(pos, target, Vector3.UP if absf((target - pos).normalized().y) < 0.99 else Vector3.FORWARD)
	l.light_color = color
	l.light_energy = energy
	l.spot_range = rng
	l.spot_angle = angle
	l.spot_attenuation = 1.0
	l.shadow_enabled = true
	l.shadow_blur = 2.0
	l.light_volumetric_fog_energy = 0.6
	return l


static func billboard(parent: Node3D, shader: Shader, pos: Vector3, size: Vector2, cam: Camera3D) -> ShaderMaterial:
	var mi := MeshInstance3D.new()
	var q := QuadMesh.new()
	q.size = size
	mi.mesh = q
	var m := ShaderMaterial.new()
	m.shader = shader
	mi.material_override = m
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	# Upright billboard: faces the camera horizontally, stays vertical.
	var to_cam := cam.global_position - pos
	to_cam.y = 0.0
	mi.global_transform = Transform3D(Basis.looking_at(-to_cam.normalized(), Vector3.UP), pos)
	mi.set_meta(&"bend_move", true)
	return m


static func flame(parent: Node3D, pos: Vector3, size: Vector2, cam: Camera3D, seed: float, intensity: float = 4.0) -> ShaderMaterial:
	var m := billboard(parent, FLAME, pos + Vector3(0, size.y * 0.5, 0), size, cam)
	m.set_shader_parameter(&"seed", seed)
	m.set_shader_parameter(&"intensity", intensity)
	return m


static func glow(parent: Node3D, pos: Vector3, size: float, color: Color, intensity: float, cam: Camera3D) -> ShaderMaterial:
	var m := billboard(parent, GLOW, pos, Vector2(size, size), cam)
	m.set_shader_parameter(&"color", color)
	m.set_shader_parameter(&"intensity", intensity)
	return m


## A candle: wax stub, flame, halo and a small warm light. Returns the light.
static func candle(parent: Node3D, pos: Vector3, cam: Camera3D, seed: float, energy: float = 1.2) -> OmniLight3D:
	cyl(parent, 0.035, 0.04, 0.14, pos + Vector3(0, 0.07, 0), flat(Color(0.9, 0.85, 0.7), 0.6), 8)
	flame(parent, pos + Vector3(0, 0.13, 0), Vector2(0.08, 0.16), cam, seed, 5.0)
	glow(parent, pos + Vector3(0, 0.2, 0), 0.5, Color(1.0, 0.6, 0.25), 1.2, cam)
	return omni(parent, pos + Vector3(0, 0.35, 0), Color(1.0, 0.62, 0.32), energy, 3.2)


## WorldEnvironment + camera attributes. grade: Dictionary with ambient, ambient_energy, glow, fog.
static func environment(parent: Node3D, cam: Camera3D, grade: Dictionary, focus_dist: float) -> WorldEnvironment:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.01, 0.005, 0.015)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = grade.get("ambient", Color(0.35, 0.25, 0.5))
	env.ambient_light_energy = grade.get("ambient_energy", 0.35)
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_exposure = grade.get("exposure", 0.9)
	env.tonemap_white = 6.0
	env.ssao_enabled = true
	env.ssao_radius = 1.2
	env.ssao_intensity = 2.5
	env.ssao_power = 1.6
	env.ssao_detail = 0.6
	env.ssil_enabled = true
	env.ssil_radius = 4.0
	env.ssil_intensity = 0.8
	env.glow_enabled = true
	env.glow_normalized = false
	env.glow_intensity = grade.get("glow", 0.5)
	env.glow_strength = 1.1
	env.glow_bloom = 0.04
	env.glow_hdr_threshold = 1.2
	env.glow_hdr_scale = 2.0
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SCREEN
	for i: int in range(7):
		env.set_glow_level(i, [0.0, 0.6, 1.0, 1.0, 0.8, 0.5, 0.3][i])
	env.adjustment_enabled = true
	env.adjustment_contrast = grade.get("contrast", 1.12)
	env.adjustment_saturation = grade.get("saturation", 1.1)
	if grade.get("fog", false):
		env.volumetric_fog_enabled = true
		env.volumetric_fog_density = grade.get("fog_density", 0.015)
		env.volumetric_fog_albedo = grade.get("fog_albedo", Color(0.6, 0.5, 0.7))
		env.volumetric_fog_anisotropy = 0.3
		env.volumetric_fog_length = 40.0
	var we := WorldEnvironment.new()
	we.environment = env
	var attrs := CameraAttributesPractical.new()
	attrs.dof_blur_far_enabled = true
	attrs.dof_blur_far_distance = focus_dist + 5.0
	attrs.dof_blur_far_transition = 7.0
	attrs.dof_blur_near_enabled = true
	attrs.dof_blur_near_distance = focus_dist - 4.5
	attrs.dof_blur_near_transition = 3.0
	attrs.dof_blur_amount = 0.045
	we.camera_attributes = attrs
	parent.add_child(we)
	return we


## Full-screen finishing pass (tilt-shift, grade, vignette) under the HUD layer.
static func post_layer(parent: Node, params: Dictionary) -> ShaderMaterial:
	var layer := CanvasLayer.new()
	layer.layer = 1
	parent.add_child(layer)
	var rect := ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var m := ShaderMaterial.new()
	m.shader = POST
	for k: String in params.keys():
		m.set_shader_parameter(StringName(k), params[k])
	rect.material = m
	layer.add_child(rect)
	return m


static func camera(parent: Node3D, target: Vector3, pitch_deg: float, yaw_deg: float, dist: float, fov: float) -> Camera3D:
	var cam := Camera3D.new()
	cam.fov = fov
	cam.near = 0.5
	cam.far = 200.0
	parent.add_child(cam)
	var p := deg_to_rad(pitch_deg)
	var y := deg_to_rad(yaw_deg)
	var offset := Vector3(sin(y) * cos(p), sin(p), cos(y) * cos(p)) * dist
	cam.look_at_from_position(target + offset, target, Vector3.UP)
	cam.current = true
	return cam
