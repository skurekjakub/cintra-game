extends RefCounted
## HD-2D spike: pixel-art companion portrait. Same toon pipeline as the sprites, framed on the
## head and shoulders from slightly above, rendered small and shown with nearest filtering.

static func make(parent: Node, model: Node3D, mat: ShaderMaterial, px: int, key: Color, rim: Color, ambient: Color) -> ViewportTexture:
	var vp := SubViewport.new()
	vp.size = Vector2i(px, px)
	vp.transparent_bg = true
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_DISABLED
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	parent.add_child(vp)
	var holder := Node3D.new()
	holder.rotation_degrees.y = -18.0
	vp.add_child(holder)
	holder.add_child(model)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 0.74
	vp.add_child(cam)
	cam.look_at_from_position(Vector3(0.0, 1.3, 3.0), Vector3(0.0, 0.84, 0.0), Vector3.UP)
	cam.current = true
	mat.set_shader_parameter(&"ambient", ambient)
	mat.set_shader_parameter(&"key_dir", Vector3(0.6, 0.7, 0.6))
	mat.set_shader_parameter(&"key_color", key)
	mat.set_shader_parameter(&"rim_dir", Vector3(-0.8, 0.3, -0.5))
	mat.set_shader_parameter(&"rim_color", rim)
	mat.set_shader_parameter(&"fill_dir", Vector3(-0.5, 0.4, 0.8))
	mat.set_shader_parameter(&"fill_color", Color(0.25, 0.28, 0.5))
	return vp.get_texture()
