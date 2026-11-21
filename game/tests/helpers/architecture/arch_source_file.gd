## Test helper: one GDScript source file as the architecture checker sees it:
## its layer, domain, privacy, declared class, and the identifiers it uses.
class_name ArchSourceFile
extends RefCounted

const SRC_ROOT: String = "res://src/"

var path: String
var layer: StringName = &""
var domain: StringName = &""
var is_internal: bool = false
var declared_class: StringName = &""
var line_count: int = 0
var code_lines: Array[String] = []

var _identifiers: Dictionary[StringName, bool] = {}


static func from_text(res_path: String, text: String) -> ArchSourceFile:
	var f := ArchSourceFile.new()
	f.path = res_path
	f._parse_location()
	var lines := text.split("\n")
	if lines.size() > 0 and lines[lines.size() - 1].is_empty():
		lines.remove_at(lines.size() - 1)
	f.line_count = lines.size()
	f.code_lines = ArchSourceStripper.new().strip(lines)
	f._collect_identifiers()
	return f


func references(identifier: StringName) -> bool:
	return _identifiers.has(identifier)


func identifiers() -> Array[StringName]:
	var out: Array[StringName] = []
	out.assign(_identifiers.keys())
	return out


func file_stem() -> String:
	return path.get_file().get_basename()


func _parse_location() -> void:
	is_internal = path.contains("/_internal/")
	if not path.begins_with(SRC_ROOT):
		return
	var parts := path.substr(SRC_ROOT.length()).split("/")
	if parts.size() < 2:
		return
	layer = StringName(parts[0])
	if layer == &"domain" and parts.size() >= 3:
		domain = StringName(parts[1])


func _collect_identifiers() -> void:
	var word := RegEx.create_from_string("[A-Za-z_][A-Za-z0-9_]*")
	var class_decl := RegEx.create_from_string("(^|\\s)class_name\\s+([A-Za-z_][A-Za-z0-9_]*)")
	for line: String in code_lines:
		if declared_class == &"":
			var m := class_decl.search(line)
			if m != null:
				declared_class = StringName(m.get_string(2))
		for found: RegExMatch in word.search_all(line):
			_identifiers[StringName(found.get_string())] = true
