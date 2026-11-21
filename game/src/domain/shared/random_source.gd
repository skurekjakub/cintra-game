## The only way domain code draws random numbers, so tests can inject a seeded or
## scripted source (architecture.md §4.1, §9.6).
@abstract
class_name RandomSource
extends RefCounted


## Returns an integer in [from, to], both inclusive.
@abstract func randi_range(from: int, to: int) -> int


## Returns a float in [0, 1].
@abstract func randf() -> float


@abstract func get_state() -> Dictionary


@abstract func set_state(data: Dictionary) -> void
