## Test helper: the smallest Snapshotable aggregate.
class_name FakeCounter
extends Snapshotable

var count: int = 0


func to_snapshot() -> Dictionary:
	return {"count": count}


func restore(data: Dictionary) -> void:
	count = int(data.get("count", 0))
