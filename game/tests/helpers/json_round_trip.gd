## Test helper: pushes a snapshot through JSON the way a save file does, so
## ints come back as floats and ids as Strings (architecture.md §9.3).
## Usage: restored.restore(JsonRoundTrip.of(original.to_snapshot())).
class_name JsonRoundTrip
extends RefCounted


static func of(snap: Dictionary) -> Dictionary:
	var parsed: Dictionary = JSON.parse_string(JSON.stringify(snap))
	return parsed
