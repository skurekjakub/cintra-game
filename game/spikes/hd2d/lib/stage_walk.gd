extends Node
## HD-2D spike (A12): stages an animated pixel card on a timeline: idle at the first point, walk the
## path at `speed`, then idle at the last point. Time is the accumulated frame delta, so a fixed-fps
## capture is deterministic. `lead_in` seconds pass (idling) before the timeline starts.

const Kit := preload("res://spikes/hd2d/lib/kit.gd")

var lead_in: float = 0.0
var idle_time: float = 3.0
var speed: float = 1.0
var sprite_prefix: String = "bertha_"
var _card: Node3D
var _meta: Dictionary = {}
var _points: Array[Vector3] = []
var _time: float = 0.0
var _state: String = ""


## meta: the sprite's bertha_anim.json-style dictionary (per strip: fps + sequence).
func setup(card: Node3D, meta: Dictionary, points: Array[Vector3]) -> void:
	_card = card
	_meta = meta
	_points = points
	_card.call(&"move_to", Kit.bend_point(points[0]))
	_set_state("idle")


func _process(delta: float) -> void:
	_time += delta
	var t := _time - lead_in - idle_time
	if t < 0.0 or _points.size() < 2:
		_set_state("idle")
		return
	var d := t * speed
	var length := 0.0
	for i: int in range(_points.size() - 1):
		var seg := _points[i].distance_to(_points[i + 1])
		if d <= length + seg:
			_set_state("walk")
			_card.call(&"move_to", Kit.bend_point(_points[i].lerp(_points[i + 1], (d - length) / seg)))
			return
		length += seg
	_card.call(&"move_to", Kit.bend_point(_points[-1]))
	_set_state("idle")


func _set_state(s: String) -> void:
	if s == _state:
		return
	_state = s
	var name := sprite_prefix + s
	var m: Dictionary = _meta[name]
	var seq := PackedInt32Array()
	for f: Variant in m["sequence"]:
		seq.append(int(f))
	_card.call(&"play", name, float(m["fps"]), seq)
