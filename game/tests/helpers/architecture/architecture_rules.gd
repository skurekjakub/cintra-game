## Test helper: the architecture rules from architecture.md §2 ("Enforcement" and the
## layer table), §3.3 (only presentation reads Services) and §11 (size, one class per
## file, class_name matches the file). check() returns one message per violation.
class_name ArchitectureRules
extends RefCounted

const MAX_LINES: int = 300
const LAYER_RANK: Dictionary[StringName, int] = {
	&"domain": 0, &"application": 1, &"infrastructure": 2, &"presentation": 3,
}
## Scene tree, input, file and engine-singleton APIs banned in domain and application.
const ENGINE_APIS: Array[StringName] = [
	&"Node", &"Node2D", &"Node3D", &"Control", &"SceneTree", &"get_tree", &"Input", &"InputMap",
	&"FileAccess", &"DirAccess", &"ResourceLoader", &"ResourceSaver", &"JSON", &"ProjectSettings",
	&"Engine", &"OS", &"Time",
]
const PURE_LAYERS: Array[StringName] = [&"domain", &"application"]

var _by_class: Dictionary[StringName, ArchSourceFile] = {}


func check(files: Array[ArchSourceFile]) -> Array[String]:
	_by_class.clear()
	for f: ArchSourceFile in files:
		if f.declared_class != &"":
			_by_class[f.declared_class] = f
	var out: Array[String] = []
	for f: ArchSourceFile in files:
		if not LAYER_RANK.has(f.layer):
			out.append("%s: not inside a layer folder (src/<layer>/...)" % f.path)
			continue
		out.append_array(_check_shape(f))
		out.append_array(_check_apis(f))
		for id: StringName in f.identifiers():
			if _by_class.has(id) and id != f.declared_class:
				out.append_array(_check_reference(f, _by_class[id]))
	return out


func _check_shape(f: ArchSourceFile) -> Array[String]:
	var out: Array[String] = []
	if f.line_count > MAX_LINES:
		out.append("%s: %d lines, over the %d-line cap" % [f.path, f.line_count, MAX_LINES])
	for line: String in f.code_lines:
		var t := line.strip_edges(true, false)
		if t.begins_with("class ") or t.begins_with("class\t"):
			out.append("%s: inner class (%s); use one class per file" % [f.path, t.strip_edges()])
	if f.declared_class != &"" and _normalize(f.declared_class) != _normalize(f.file_stem()):
		out.append("%s: class_name %s does not match the file name" % [f.path, f.declared_class])
	return out


func _check_apis(f: ArchSourceFile) -> Array[String]:
	var out: Array[String] = []
	if f.layer in PURE_LAYERS:
		for api: StringName in ENGINE_APIS:
			if f.references(api):
				out.append("%s: %s layer uses forbidden engine API %s" % [f.path, f.layer, api])
	if f.layer != &"presentation" and f.references(&"Services"):
		out.append("%s: only presentation may read the Services autoload" % f.path)
	if f.layer == &"domain":
		for line: String in f.code_lines:
			if line.strip_edges(true, false).begins_with("signal "):
				out.append("%s: domain declares a signal; record a DomainEvent instead" % f.path)
	return out


func _check_reference(f: ArchSourceFile, target: ArchSourceFile) -> Array[String]:
	var out: Array[String] = []
	var target_name := target.declared_class
	if LAYER_RANK[target.layer] > LAYER_RANK[f.layer]:
		out.append("%s: %s references %s from outer layer %s" % [f.path, f.layer, target_name, target.layer])
	elif target.is_internal and (target.layer != f.layer or target.domain != f.domain):
		out.append("%s: references %s, which is in another domain's _internal/" % [f.path, target_name])
	elif f.layer == &"domain" and target.layer == &"domain" and not _domain_may_use(f.domain, target.domain):
		out.append("%s: domain %s references %s from domain %s (only shared and rules are allowed)"
			% [f.path, f.domain, target_name, target.domain])
	return out


func _domain_may_use(from_domain: StringName, to_domain: StringName) -> bool:
	if from_domain == to_domain or to_domain == &"shared":
		return true
	# The shared kernel knows no game concept, so it may not depend on rules.
	return to_domain == &"rules" and from_domain != &"shared"


func _normalize(text: String) -> String:
	return text.replace("_", "").to_lower()
