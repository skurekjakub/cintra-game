## An aggregate whose state is saved. Sections are plain Dictionaries that the
## save domain stores opaquely (architecture.md §4, §4.18).
## restore() is all or nothing: it validates every key, type, range and id first
## and changes state only after. On any problem it returns Err `save_invalid`
## ("<section>.<key>: <reason>") and leaves the aggregate exactly as it was; it
## never clamps, repairs or drops. It never touches the outbox (no events).
@abstract
class_name Snapshotable
extends RefCounted


@abstract func to_snapshot() -> Dictionary


@abstract func restore(data: Dictionary) -> Result
