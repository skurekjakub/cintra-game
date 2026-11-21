## JsonRoundTrip: test helper that mimics save/load of a snapshot (architecture.md §9.3).
extends GutTest


func test_ints_come_back_and_ids_become_strings() -> void:
	var snap: Dictionary = {"n": 3, "ids": [&"item.rope"], "nested": {"ok": true}}
	var back := JsonRoundTrip.of(snap)
	assert_eq(back["n"], 3.0)
	assert_eq(back["ids"], ["item.rope"])
	assert_eq(back["nested"], {"ok": true})


func test_does_not_alias_the_input() -> void:
	var snap: Dictionary = {"a": [1]}
	var back := JsonRoundTrip.of(snap)
	var a: Array = back["a"]
	a.append(2)
	assert_eq(snap["a"], [1])
