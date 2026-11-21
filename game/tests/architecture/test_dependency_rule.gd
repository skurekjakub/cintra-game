## Scans res://src and fails on any layer, domain, API, size or one-class-per-file
## violation (architecture.md §2 "Enforcement", §3.3, §11).
extends GutTest

const SRC: String = "res://src"


func test_src_has_scripts_to_check() -> void:
	assert_gt(ArchSourceScanner.scan(SRC).size(), 0, "the scanner found no scripts under res://src")


func test_src_obeys_the_architecture_rules() -> void:
	var violations := ArchitectureRules.new().check(ArchSourceScanner.scan(SRC))
	for v: String in violations:
		gut.p("ARCHITECTURE VIOLATION " + v)
	assert_eq(violations.size(), 0, "architecture violations:\n" + "\n".join(violations))
