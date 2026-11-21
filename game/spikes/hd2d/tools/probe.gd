extends SceneTree
## Spike helper: prints the node tree, size and animations of a glTF scene.
func _init() -> void:
	for path: String in OS.get_cmdline_user_args():
		var ps: PackedScene = load(path)
		var n: Node = ps.instantiate()
		print("== ", path)
		_dump(n, 0)
		var ap: AnimationPlayer = n.find_child("AnimationPlayer", true, false) as AnimationPlayer
		if ap:
			print("anims: ", ap.get_animation_list())
		n.free()
	quit()

func _dump(n: Node, d: int) -> void:
	if d > 6:
		return
	var extra := ""
	if n is MeshInstance3D:
		var mi := n as MeshInstance3D
		extra = " aabb=%s surf=%d mat0=%s" % [mi.get_aabb(), mi.mesh.get_surface_count(), mi.mesh.surface_get_material(0)]
	if n is Skeleton3D or n is BoneAttachment3D or n is MeshInstance3D or d < 3:
		print("  ".repeat(d), n.name, " (", n.get_class(), ")", extra)
	for c: Node in n.get_children():
		_dump(c, d + 1)
