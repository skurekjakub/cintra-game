extends RefCounted
## HD-2D spike: VFX recipes. All additive and HDR (values > 1) so the glow pass blooms them.

const SLASH := preload("res://spikes/hd2d/shaders/vfx_slash.gdshader")
const SPARK := preload("res://spikes/hd2d/shaders/vfx_spark.gdshader")
const Kit := preload("res://spikes/hd2d/lib/kit.gd")


## Ring-sector mesh in the local XZ plane. UV.x: 0 at a0 (tail) -> 1 at a1 (head).
static func arc_mesh(radius: float, width: float, a0_deg: float, a1_deg: float, segs: int = 64) -> ArrayMesh:
	var verts := PackedVector3Array()
	var uvs := PackedVector2Array()
	var idx := PackedInt32Array()
	for i: int in range(segs + 1):
		var t := float(i) / float(segs)
		var a := deg_to_rad(lerpf(a0_deg, a1_deg, t))
		var d := Vector3(cos(a), 0.0, sin(a))
		verts.push_back(d * (radius - width))
		uvs.push_back(Vector2(t, 0.0))
		verts.push_back(d * radius)
		uvs.push_back(Vector2(t, 1.0))
		if i < segs:
			var b := i * 2
			idx.append_array([b, b + 1, b + 2, b + 1, b + 3, b + 2])
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = idx
	var m := ArrayMesh.new()
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return m


## Crescent slash around `center`. tilt_deg leans the arc plane toward the camera.
static func slash(parent: Node3D, center: Vector3, radius: float, width: float, a0: float, a1: float,
		tilt_deg: Vector3, edge: Color, intensity: float) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = arc_mesh(radius, width, a0, a1)
	var m := ShaderMaterial.new()
	m.shader = SLASH
	m.set_shader_parameter(&"edge_color", edge)
	m.set_shader_parameter(&"intensity", intensity)
	mi.material_override = m
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	mi.position = center
	mi.rotation_degrees = tilt_deg
	return mi


static func spark(parent: Node3D, pos: Vector3, size: float, cam: Camera3D, seed: float, color: Color = Color(1.0, 0.8, 0.3)) -> void:
	var mi := MeshInstance3D.new()
	var q := QuadMesh.new()
	q.size = Vector2(size, size)
	mi.mesh = q
	var m := ShaderMaterial.new()
	m.shader = SPARK
	m.set_shader_parameter(&"seed", seed)
	m.set_shader_parameter(&"color", color)
	mi.material_override = m
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	mi.global_transform = Transform3D(cam.global_basis, pos)


## Falling streak particles in a box (rain beyond a door, drips in a vault).
static func rain(parent: Node3D, pos: Vector3, extents: Vector3, color: Color, amount: int) -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = amount
	p.lifetime = 0.6
	p.preprocess = 2.0
	p.visibility_aabb = AABB(-extents - Vector3(0, 4, 0), extents * 2.0 + Vector3(0, 8, 0))
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = extents
	pm.direction = Vector3(0.1, -1, 0.05)
	pm.spread = 3.0
	pm.initial_velocity_min = 11.0
	pm.initial_velocity_max = 14.0
	pm.gravity = Vector3(0, -9.8, 0)
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(0.015, 0.45)
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.albedo_color = color
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y
	mat.billboard_keep_scale = true
	q.material = mat
	p.draw_pass_1 = q
	p.position = pos
	parent.add_child(p)
	return p


## Rising embers / motes.
static func embers(parent: Node3D, pos: Vector3, extents: Vector3, color: Color, amount: int, speed: float = 0.8) -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = amount
	p.lifetime = 2.5
	p.preprocess = 3.0
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = extents
	pm.direction = Vector3(0, 1, 0)
	pm.spread = 25.0
	pm.initial_velocity_min = speed * 0.5
	pm.initial_velocity_max = speed
	pm.gravity = Vector3(0, 0.2, 0)
	pm.turbulence_enabled = true
	pm.turbulence_noise_strength = 0.6
	pm.scale_min = 0.5
	pm.scale_max = 1.2
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(0.035, 0.035)
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.albedo_color = color * 4.0
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	q.material = mat
	p.draw_pass_1 = q
	p.position = pos
	parent.add_child(p)
	return p
