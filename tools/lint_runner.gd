## Lint gate runner (CLAUDE.md "Running tests"). Loads every script under res://src so the
## GDScript compiler applies the strict warning levels from tools/lint_override.cfg: a warning
## treated as an error leaves its script uncompilable, which `can_instantiate()` reports.
## Godot prints the offending "Parse Error" lines itself; this script adds one FAIL line per
## script and exits 1 on any failure. Run it through tools/lint.ps1 or tools/lint.sh, which
## install the override and keep the class cache fresh.
extends SceneTree

const ROOT: String = "res://src"
const OK_MARKER: String = "[lint] OK:"


func _init() -> void:
	var problem: String = _policy_problem()
	if not problem.is_empty():
		print("[lint] FAIL: %s" % problem)
		quit(1)
		return
	var paths: Array[String] = []
	_collect(ROOT, paths)
	paths.sort()
	if paths.is_empty():
		print("[lint] FAIL: no scripts found under %s (wrong --path?)" % ROOT)
		quit(1)
		return
	var failed: Array[String] = []
	for path: String in paths:
		var script: GDScript = load(path) as GDScript
		if script == null or not script.can_instantiate():
			failed.append(path)
			print("[lint] FAIL ", path)
	if failed.is_empty():
		print("%s %d scripts under %s" % [OK_MARKER, paths.size(), ROOT])
		quit(0)
		return
	print("[lint] FAILED: %d of %d scripts" % [failed.size(), paths.size()])
	quit(1)


## Why the strict policy is not in force, or "" when it is. Without it every script compiles
## and the gate would pass vacuously, so a missing override must fail the run, never skip it.
func _policy_problem() -> String:
	var unsafe_cast: int = ProjectSettings.get_setting("debug/gdscript/warnings/unsafe_cast", 0)
	if unsafe_cast != 2:
		return "unsafe_cast is %d, not 2 (error): game/override.cfg is not applied. Run tools/lint.ps1 or tools/lint.sh, not this script by hand." % unsafe_cast
	var rules: Dictionary = ProjectSettings.get_setting("debug/gdscript/warnings/directory_rules", {})
	if rules.get("res://src") != 1:
		return "directory_rules does not include res://src (it is %s): game/override.cfg is not applied." % str(rules)
	return ""


func _collect(dir: String, out: Array[String]) -> void:
	for file: String in DirAccess.get_files_at(dir):
		if file.ends_with(".gd"):
			out.append(dir.path_join(file))
	for sub: String in DirAccess.get_directories_at(dir):
		_collect(dir.path_join(sub), out)
