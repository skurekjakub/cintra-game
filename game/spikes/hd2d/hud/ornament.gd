extends RefCounted
## HD-2D spike: gothic filigree primitives for the HUD, drawn with antialiased vector lines.
## Register: thin gold-white strokes, diamonds, four-point sparkle stars, curling vine spirals.

const GOLD := Color(0.93, 0.83, 0.62)
const GOLD_DIM := Color(0.62, 0.5, 0.34, 0.85)
const WHITE := Color(1.0, 0.97, 0.9)
const INK := Color(0.04, 0.02, 0.05, 0.75)


static func spiral(ci: CanvasItem, c: Vector2, r0: float, turns: float, start: float, dir: float, color: Color, w: float) -> void:
	var pts := PackedVector2Array()
	var n := int(turns * 24.0)
	for i: int in range(n + 1):
		var t := float(i) / float(n)
		var a := start + dir * t * turns * TAU
		var r := r0 * (1.0 - t * 0.85)
		pts.push_back(c + Vector2(cos(a), sin(a)) * r)
	ci.draw_polyline(pts, color, w, true)


static func diamond(ci: CanvasItem, c: Vector2, s: Vector2, color: Color, outline: Color = Color(0, 0, 0, 0)) -> void:
	var pts := PackedVector2Array([c + Vector2(0, -s.y), c + Vector2(s.x, 0), c + Vector2(0, s.y), c + Vector2(-s.x, 0)])
	ci.draw_colored_polygon(pts, color)
	if outline.a > 0.0:
		pts.push_back(pts[0])
		ci.draw_polyline(pts, outline, 1.2, true)


## Four-point sparkle (the medallion and compass studs).
static func star4(ci: CanvasItem, c: Vector2, r: float, color: Color) -> void:
	var pts := PackedVector2Array()
	for i: int in range(8):
		var a := float(i) * PI / 4.0 - PI / 2.0
		var rr := r if i % 2 == 0 else r * 0.22
		pts.push_back(c + Vector2(cos(a), sin(a)) * rr)
	ci.draw_colored_polygon(pts, color)


static func ring(ci: CanvasItem, c: Vector2, r: float, color: Color, w: float) -> void:
	ci.draw_arc(c, r, 0.0, TAU, 96, color, w, true)


## Filled blood drop pointing up. fill 0..1 drains from the top.
static func blood_drop(ci: CanvasItem, c: Vector2, h: float, fill: float) -> void:
	var outline := _drop_points(c, h, 1.0)
	var shadow := PackedVector2Array()
	for p: Vector2 in outline:
		shadow.push_back(p + Vector2(1.5, 2.0))
	ci.draw_colored_polygon(shadow, Color(0, 0, 0, 0.6))
	ci.draw_colored_polygon(outline, Color(0.16, 0.03, 0.05, 0.85))
	if fill > 0.0:
		ci.draw_colored_polygon(_drop_points(c, h * 0.86, 1.0), Color(0.62, 0.04, 0.08))
		ci.draw_colored_polygon(_drop_points(c + Vector2(-h * 0.03, h * 0.05), h * 0.62, 1.0), Color(0.86, 0.12, 0.14))
		ci.draw_circle(c + Vector2(-h * 0.1, h * 0.06), h * 0.07, Color(1.0, 0.75, 0.7))
	var closed := outline.duplicate()
	closed.push_back(outline[0])
	ci.draw_polyline(closed, Color(1.0, 0.85, 0.75, 0.9), 1.3, true)


static func _drop_points(c: Vector2, h: float, _k: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var r := h * 0.32
	var base := c + Vector2(0, h * 0.5 - r)
	pts.push_back(c + Vector2(0, -h * 0.5))
	for i: int in range(0, 19):
		var a := -PI * 0.15 + float(i) / 18.0 * (PI * 1.3)
		pts.push_back(base + Vector2(cos(a), sin(a)) * r)
	return pts


## Horizontal filigree rule: a line with a diamond in the middle and curls at both ends.
static func rule(ci: CanvasItem, a: Vector2, b: Vector2, color: Color) -> void:
	ci.draw_line(a, b, color, 1.4, true)
	var mid := (a + b) * 0.5
	diamond(ci, mid, Vector2(6, 4), color)
	spiral(ci, a + Vector2(-2, -7), 7.0, 1.3, PI * 0.5, 1.0, color, 1.2)
	spiral(ci, b + Vector2(2, -7), 7.0, 1.3, PI * 0.5, -1.0, color, 1.2)


## Spear-tip end cap pointing along dir (1 = right, -1 = left).
static func finial(ci: CanvasItem, p: Vector2, dir: float, color: Color) -> void:
	var pts := PackedVector2Array([p, p + Vector2(10 * dir, -5), p + Vector2(24 * dir, 0), p + Vector2(10 * dir, 5)])
	ci.draw_colored_polygon(pts, color)
	ci.draw_line(p + Vector2(4 * dir, -9), p + Vector2(4 * dir, 9), color, 1.3, true)
	spiral(ci, p + Vector2(8 * dir, -12), 6.0, 1.2, PI, dir, color, 1.1)
	spiral(ci, p + Vector2(8 * dir, 12), 6.0, 1.2, PI, -dir, color, 1.1)


## A long vine flourish growing from a point (screen-edge decoration).
static func vine(ci: CanvasItem, start: Vector2, length: float, angle: float, color: Color) -> void:
	var pts := PackedVector2Array()
	var dir := Vector2(cos(angle), sin(angle))
	var nrm := Vector2(-dir.y, dir.x)
	for i: int in range(41):
		var t := float(i) / 40.0
		pts.push_back(start + dir * length * t + nrm * sin(t * PI * 2.0) * 14.0)
	ci.draw_polyline(pts, color, 1.3, true)
	for k: int in range(1, 4):
		var t2 := float(k) / 4.0
		var p := start + dir * length * t2 + nrm * sin(t2 * PI * 2.0) * 14.0
		var side := 1.0 if k % 2 == 0 else -1.0
		spiral(ci, p + nrm * side * 10.0, 10.0, 1.4, angle + PI, side, color, 1.1)
