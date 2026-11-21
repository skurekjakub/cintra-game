## RandomSource backed by RandomNumberGenerator (architecture.md §4.1).
## State is stored as decimal strings: saves are JSON, and a 64-bit integer
## stored as a JSON number would lose precision.
class_name SeededRandom
extends RandomSource

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _init(seed_value: int) -> void:
	_rng.seed = seed_value


func randi_range(from: int, to: int) -> int:
	return _rng.randi_range(from, to)


func randf() -> float:
	return _rng.randf()


func get_state() -> Dictionary:
	return {"seed": str(_rng.seed), "state": str(_rng.state)}


func set_state(data: Dictionary) -> void:
	assert(data.has("seed") and data.has("state"), "SeededRandom state needs seed and state")
	_rng.seed = str(data["seed"]).to_int()
	_rng.state = str(data["state"]).to_int()
