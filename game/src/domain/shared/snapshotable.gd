## An aggregate whose state is saved. Sections are plain Dictionaries that the
## save domain stores opaquely (architecture.md §4, §4.18).
@abstract
class_name Snapshotable
extends RefCounted


@abstract func to_snapshot() -> Dictionary


@abstract func restore(data: Dictionary) -> void
