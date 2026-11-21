## SeededRandom: the deterministic RandomSource used by the domain (architecture.md §4.1, §9.6).
extends GutTest


func _sequence(rng: RandomSource, n: int) -> Array[int]:
	var out: Array[int] = []
	for i: int in n:
		out.append(rng.randi_range(1, 1000))
	return out


func test_is_a_random_source() -> void:
	assert_is(SeededRandom.new(1), RandomSource)


func test_same_seed_same_sequence() -> void:
	assert_eq(_sequence(SeededRandom.new(7), 20), _sequence(SeededRandom.new(7), 20))


func test_different_seeds_differ() -> void:
	assert_ne(_sequence(SeededRandom.new(7), 20), _sequence(SeededRandom.new(8), 20))


func test_randi_range_is_inclusive_and_bounded() -> void:
	var rng := SeededRandom.new(3)
	var seen: Dictionary[int, bool] = {}
	for i: int in 500:
		var v := rng.randi_range(1, 4)
		assert_between(v, 1, 4)
		seen[v] = true
	assert_eq(seen.size(), 4, "all of 1..4 appear")


func test_randf_is_in_unit_interval() -> void:
	var rng := SeededRandom.new(3)
	for i: int in 200:
		var f := rng.randf()
		assert_true(f >= 0.0 and f <= 1.0)


func test_state_round_trip_replays_sequence() -> void:
	var rng := SeededRandom.new(11)
	_sequence(rng, 5)
	var saved := rng.get_state()
	var expected := _sequence(rng, 10)
	var other := SeededRandom.new(999)
	other.set_state(saved)
	assert_eq(_sequence(other, 10), expected)


func test_state_survives_json_round_trip() -> void:
	# Saves are JSON; 64-bit state must not lose precision as a float.
	var rng := SeededRandom.new(123456789)
	_sequence(rng, 3)
	var saved: Dictionary = JSON.parse_string(JSON.stringify(rng.get_state()))
	var expected := _sequence(rng, 10)
	var other := SeededRandom.new(0)
	other.set_state(saved)
	assert_eq(_sequence(other, 10), expected)
