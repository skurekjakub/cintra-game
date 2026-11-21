## Test helper: the smallest Snapshotable aggregate.
class_name FakeCounter
extends Snapshotable

var count: int = 0


func to_snapshot() -> Dictionary:
	return {"count": count}


func restore(data: Dictionary) -> Result:
	var reader := SnapshotReader.new(data, "fake_counter")
	var stored := reader.read_int("count", SnapshotReader.INT_MIN, SnapshotReader.INT_MAX)
	if reader.failed():
		return reader.result()
	count = stored
	return Result.ok()
