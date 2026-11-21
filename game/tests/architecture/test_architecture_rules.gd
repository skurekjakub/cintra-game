## Unit tests for the architecture checker itself, on synthetic sources
## (architecture.md §2 "Enforcement", §3.3, §11).
extends GutTest


func _file(path: String, text: String) -> ArchSourceFile:
	return ArchSourceFile.from_text(path, text)


func _violations(files: Array[ArchSourceFile]) -> Array[String]:
	return ArchitectureRules.new().check(files)


func _assert_one_violation(files: Array[ArchSourceFile], needle: String) -> void:
	var found := _violations(files)
	assert_eq(found.size(), 1, "violations: %s" % [found])
	if found.size() == 1:
		assert_string_contains(found[0], needle)


func test_parses_layer_domain_and_internal() -> void:
	var f := _file("res://src/domain/quests/_internal/stage_walker.gd", "class_name StageWalker\nextends RefCounted\n")
	assert_eq(f.layer, &"domain")
	assert_eq(f.domain, &"quests")
	assert_true(f.is_internal)
	assert_eq(f.declared_class, &"StageWalker")


func test_comments_and_strings_are_ignored() -> void:
	var f := _file("res://src/domain/shared/a.gd", "class_name A\n# FileAccess here\nvar s := \"get_tree() Node\" # Input.\nvar t := &\"JSON\"\n")
	assert_false(f.references(&"FileAccess"))
	assert_false(f.references(&"get_tree"))
	assert_false(f.references(&"JSON"))
	assert_true(f.references(&"s"))


func test_multiline_strings_are_ignored() -> void:
	var f := _file("res://src/domain/shared/a.gd", "class_name A\nvar s := \"\"\"\nFileAccess\n\"\"\"\nvar n := 1\n")
	assert_false(f.references(&"FileAccess"))
	assert_true(f.references(&"n"))


func test_clean_layering_has_no_violations() -> void:
	var files: Array[ArchSourceFile] = [
		_file("res://src/domain/shared/result.gd", "class_name Result\nextends RefCounted\n"),
		_file("res://src/domain/quests/quest_log.gd", "class_name QuestLog\nextends RefCounted\nvar r: Result\n"),
		_file("res://src/application/bus/event_bus.gd", "class_name EventBus\nextends RefCounted\nvar q: QuestLog\n"),
		_file("res://src/infrastructure/save/repo.gd", "class_name Repo\nextends RefCounted\nvar b: EventBus\n"),
		_file("res://src/presentation/bootstrap/main.gd", "class_name Main\nextends Node\nvar r: Repo\nfunc _ready() -> void:\n\tvar c := Services.context\n"),
	]
	assert_eq(_violations(files), [] as Array[String])


func test_domain_must_not_use_engine_apis() -> void:
	for snippet: String in ["extends Node", "var t := get_tree()", "var f := FileAccess.open(\"x\", 1)",
			"var d := DirAccess.open(\"x\")", "var p := Input.is_action_pressed(&\"x\")",
			"var j := JSON.parse_string(\"\")", "var c := Services.context", "signal changed"]:
		var files: Array[ArchSourceFile] = [_file("res://src/domain/quests/q.gd", "class_name Q\n" + snippet + "\n")]
		assert_eq(_violations(files).size(), 1, "snippet should be forbidden: " + snippet)


func test_application_must_not_use_scene_tree_or_files() -> void:
	var files: Array[ArchSourceFile] = [_file("res://src/application/use_cases/session/u.gd", "class_name U\nvar f := FileAccess.open(\"x\", 1)\n")]
	_assert_one_violation(files, "FileAccess")


func test_only_presentation_reads_services() -> void:
	var files: Array[ArchSourceFile] = [_file("res://src/infrastructure/godot/l.gd", "class_name L\nvar c := Services.context\n")]
	_assert_one_violation(files, "Services")


func test_inner_layer_must_not_import_outer_layer() -> void:
	var files: Array[ArchSourceFile] = [
		_file("res://src/domain/quests/quest_log.gd", "class_name QuestLog\nvar b: EventBus\n"),
		_file("res://src/application/bus/event_bus.gd", "class_name EventBus\n"),
	]
	_assert_one_violation(files, "EventBus")


func test_application_must_not_name_infrastructure() -> void:
	var files: Array[ArchSourceFile] = [
		_file("res://src/application/session/s.gd", "class_name S\nvar r := JsonRepo.new()\n"),
		_file("res://src/infrastructure/save/json_repo.gd", "class_name JsonRepo\n"),
	]
	_assert_one_violation(files, "JsonRepo")


func test_infrastructure_must_not_reference_presentation() -> void:
	var files: Array[ArchSourceFile] = [
		_file("res://src/infrastructure/save/r.gd", "class_name R\nvar m: MainView\n"),
		_file("res://src/presentation/ui/main_view.gd", "class_name MainView\n"),
	]
	_assert_one_violation(files, "MainView")


func test_other_domains_internals_are_private() -> void:
	var files: Array[ArchSourceFile] = [
		_file("res://src/application/policies/p.gd", "class_name P\nvar w: StageWalker\n"),
		_file("res://src/domain/quests/_internal/stage_walker.gd", "class_name StageWalker\n"),
		_file("res://src/domain/quests/quest_log.gd", "class_name QuestLog\nvar w: StageWalker\n"),
	]
	_assert_one_violation(files, "_internal")


func test_domain_depends_only_on_shared_and_rules() -> void:
	var files: Array[ArchSourceFile] = [
		_file("res://src/domain/quests/quest_log.gd", "class_name QuestLog\nvar c: Condition\nvar r: Result\nvar w: WorldState\n"),
		_file("res://src/domain/rules/condition.gd", "class_name Condition\n"),
		_file("res://src/domain/shared/result.gd", "class_name Result\n"),
		_file("res://src/domain/world_state/world_state.gd", "class_name WorldState\n"),
	]
	_assert_one_violation(files, "WorldState")


func test_shared_kernel_must_not_depend_on_rules() -> void:
	var files: Array[ArchSourceFile] = [
		_file("res://src/domain/shared/result.gd", "class_name Result\nvar c: Condition\n"),
		_file("res://src/domain/rules/condition.gd", "class_name Condition\n"),
	]
	_assert_one_violation(files, "Condition")


func test_file_over_line_cap_fails() -> void:
	var body := "class_name Big\n" + "var x: int = 0\n".repeat(ArchitectureRules.MAX_LINES)
	var files: Array[ArchSourceFile] = [_file("res://src/domain/shared/big.gd", body)]
	_assert_one_violation(files, "lines")


func test_inner_classes_are_forbidden() -> void:
	var files: Array[ArchSourceFile] = [_file("res://src/domain/shared/a.gd", "class_name A\nclass Inner:\n\tvar x: int\n")]
	_assert_one_violation(files, "inner class")


func test_class_name_must_match_file_name() -> void:
	var files: Array[ArchSourceFile] = [_file("res://src/domain/shared/id_rules.gd", "class_name IdRule\n")]
	_assert_one_violation(files, "file name")


func test_file_outside_a_layer_fails() -> void:
	var files: Array[ArchSourceFile] = [_file("res://src/misc/thing.gd", "class_name Thing\n")]
	_assert_one_violation(files, "layer")
