extends SceneTree
## Spike helper: which 128x256 palette cells (8 cols x 4 rows) each KayKit mesh samples.
func _init() -> void:
	for path: String in OS.get_cmdline_user_args():
		var n: Node = (load(path) as PackedScene).instantiate()
		print("== ", path)
		for c: Node in n.find_children("*", "MeshInstance3D", true, false):
			var mi := c as MeshInstance3D
			var arr := mi.mesh.surface_get_arrays(0)
			var uvs: PackedVector2Array = arr[Mesh.ARRAY_TEX_UV]
			var hist := {}
			for uv: Vector2 in uvs:
				var key := "%d,%d" % [clampi(int(uv.x * 8.0), 0, 7), clampi(int(uv.y * 4.0), 0, 3)]
				hist[key] = int(hist.get(key, 0)) + 1
			print("  ", mi.name, " ", hist)
		n.free()
	quit()
