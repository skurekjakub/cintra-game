## ScriptedRandom: the test fake that replays fixed rolls (architecture.md §9.3, §9.6).
extends GutTest


func test_is_a_random_source() -> void:
	assert_is(ScriptedRandom.new(), RandomSource)


func test_returns_scripted_values_in_order() -> void:
	var r := ScriptedRandom.new([2, 0], [0.5])
	assert_eq(r.randi_range(0, 3), 2)
	assert_eq(r.randi_range(0, 3), 0)
	assert_eq(r.randf(), 0.5)


func test_state_round_trip_replays() -> void:
	var r := ScriptedRandom.new([1, 2, 3])
	r.randi_range(0, 9)
	var s := r.get_state()
	assert_eq(r.randi_range(0, 9), 2)
	r.set_state(s)
	assert_eq(r.randi_range(0, 9), 2)


func test_state_shape_and_json_round_trip() -> void:
	var r := ScriptedRandom.new([1, 2, 3], [0.25, 0.75])
	r.randi_range(0, 9)
	r.randf()
	assert_eq(r.get_state(), {"int_index": 1, "float_index": 1})
	var s := JsonRoundTrip.of(r.get_state())
	r.randi_range(0, 9)
	r.set_state(s)
	assert_eq(r.randi_range(0, 9), 2)
	assert_eq(r.randf(), 0.75)
