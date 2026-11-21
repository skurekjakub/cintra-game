## Test helper: loads every .gd file under a res:// directory as ArchSourceFiles.
class_name ArchSourceScanner
extends RefCounted


static func scan(root: String) -> Array[ArchSourceFile]:
	var files: Array[ArchSourceFile] = []
	for path: String in _gd_paths(root):
		files.append(ArchSourceFile.from_text(path, FileAccess.get_file_as_string(path)))
	return files


static func _gd_paths(dir_path: String) -> Array[String]:
	var out: Array[String] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return out
	for file_name: String in dir.get_files():
		if file_name.get_extension() == "gd":
			out.append(dir_path.path_join(file_name))
	for sub: String in dir.get_directories():
		out.append_array(_gd_paths(dir_path.path_join(sub)))
	return out
