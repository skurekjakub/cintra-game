## Base class for every domain event. Events are small, past-tense value classes
## with typed fields set in _init. Aggregates record them in an outbox and the
## application publishes them; domain objects never publish (architecture.md §3.1).
@abstract
class_name DomainEvent
extends RefCounted
