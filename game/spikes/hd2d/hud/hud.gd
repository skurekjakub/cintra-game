extends Control
## HD-2D spike: the in-combat HUD (1920x1080 reference layout), drawn in code.
## cfg keys: hp, hp_max (pips), objective, boss_name, boss_frac, boss_recent, slots (Array of
## {icon, count}), companion, companion_ready (0..1), map (Dictionary), enemies (Array of
## {pos: Vector3, frac: float}), player_pos (Vector3).

const O := preload("res://spikes/hd2d/hud/ornament.gd")
const CIRCLE_SHADER := "shader_type canvas_item;\nvoid fragment(){ if (length(UV - 0.5) > 0.5) { discard; } }"

var cfg: Dictionary = {}
var cam: Camera3D
var font: SystemFont
var font_bold: SystemFont
const MED_C := Vector2(178, 900)
const MED_R := 116.0
const MAP_C := Vector2(1752, 918)
const MAP_R := 112.0


func setup(c: Dictionary, camera: Camera3D, portrait: Texture2D) -> void:
	cfg = c
	cam = camera
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	font = SystemFont.new()
	font.font_names = PackedStringArray(["Palatino Linotype", "Book Antiqua", "Georgia", "serif"])
	font.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	font_bold = font.duplicate() as SystemFont
	font_bold.font_weight = 700
	if portrait != null:
		var tr := TextureRect.new()
		tr.texture = portrait
		tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		var r := MED_R - 10.0
		tr.position = MED_C - Vector2(r, r)
		tr.size = Vector2(r, r) * 2.0
		var sh := Shader.new()
		sh.code = CIRCLE_SHADER
		var sm := ShaderMaterial.new()
		sm.shader = sh
		tr.material = sm
		tr.show_behind_parent = false
		var back := Control.new()
		back.set_anchors_preset(Control.PRESET_FULL_RECT)
		back.mouse_filter = Control.MOUSE_FILTER_IGNORE
		back.draw.connect(_draw_medallion_back.bind(back))
		add_child(back)
		add_child(tr)
		var front := Control.new()
		front.set_anchors_preset(Control.PRESET_FULL_RECT)
		front.mouse_filter = Control.MOUSE_FILTER_IGNORE
		front.draw.connect(_draw_medallion_front.bind(front))
		add_child(front)


func _text(ci: CanvasItem, pos: Vector2, s: String, size: int, color: Color, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT, width: float = -1.0, f: Font = null) -> void:
	var ff: Font = f if f != null else font
	ci.draw_string_outline(ff, pos, s, align, width, size, 5, Color(0.02, 0.0, 0.03, 0.85))
	ci.draw_string(ff, pos, s, align, width, size, color)


func _draw() -> void:
	_draw_edges()
	_draw_health()
	_draw_boss()
	_draw_slots()
	_draw_minimap()
	_draw_enemy_bars()
	_draw_currency()


func _draw_currency() -> void:
	if not cfg.has("crowns"):
		return
	var c := Vector2(1712, 52)
	draw_circle(c, 15, Color(0.55, 0.36, 0.12))
	draw_circle(c, 12, Color(0.96, 0.78, 0.32))
	draw_circle(c + Vector2(-3, -3), 4, Color(1.0, 0.95, 0.7))
	O.ring(self, c, 15, O.GOLD, 1.2)
	_text(self, Vector2(1738, 64), str(cfg["crowns"]), 32, Color(1, 0.96, 0.88), HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_bold)
	O.rule(self, Vector2(1690, 82), Vector2(1880, 82), O.GOLD)


func _draw_edges() -> void:
	O.vine(self, Vector2(6, 560), 300.0, PI * 0.5, Color(O.GOLD_DIM, 0.35))
	O.vine(self, Vector2(1914, 120), 260.0, PI * 0.5, Color(O.GOLD_DIM, 0.3))


func _draw_health() -> void:
	var hp: int = cfg.get("hp", 7)
	var mx: int = cfg.get("hp_max", 10)
	var x0 := 64.0
	var y := 54.0
	draw_rect(Rect2(36, 22, mx * 34 + 40, 64), Color(0.03, 0.0, 0.04, 0.35))
	for i: int in range(mx):
		O.blood_drop(self, Vector2(x0 + i * 34.0, y), 38.0, 1.0 if i < hp else 0.0)
	O.rule(self, Vector2(40, 86), Vector2(40 + mx * 34 + 30, 86), O.GOLD)
	O.spiral(self, Vector2(30, 40), 12.0, 1.5, 0.0, -1.0, O.GOLD, 1.3)
	O.diamond(self, Vector2(48, 112), Vector2(5, 5), O.GOLD)
	_text(self, Vector2(62, 119), String(cfg.get("objective", "")), 21, Color(0.97, 0.92, 0.82))


func _draw_boss() -> void:
	var name_s := String(cfg.get("boss_name", ""))
	if name_s == "":
		return
	var w := 760.0
	var x := 960.0 - w * 0.5
	var y := 66.0
	_text(self, Vector2(x, 44), name_s, 30, Color(1.0, 0.96, 0.88), HORIZONTAL_ALIGNMENT_CENTER, w, font_bold)
	var frac: float = cfg.get("boss_frac", 0.7)
	var recent: float = cfg.get("boss_recent", 0.08)
	draw_rect(Rect2(x - 4, y - 4, w + 8, 22), Color(0.02, 0.0, 0.03, 0.8))
	draw_rect(Rect2(x, y, w, 14), Color(0.12, 0.08, 0.1))
	draw_rect(Rect2(x, y, w * (frac + recent), 14), Color(0.85, 0.12, 0.12))
	draw_rect(Rect2(x, y, w * frac, 14), Color(0.96, 0.8, 0.3))
	draw_rect(Rect2(x, y, w * frac, 4), Color(1.0, 0.95, 0.65))
	draw_rect(Rect2(x - 4, y - 4, w + 8, 22), O.GOLD, false, 1.5, true)
	draw_rect(Rect2(x - 8, y - 8, w + 16, 30), Color(O.GOLD_DIM, 0.6), false, 1.0, true)
	O.finial(self, Vector2(x - 8, y + 7), -1.0, O.GOLD)
	O.finial(self, Vector2(x + w + 8, y + 7), 1.0, O.GOLD)
	O.diamond(self, Vector2(960, y - 8), Vector2(9, 6), Color(0.08, 0.02, 0.06), O.GOLD)
	O.diamond(self, Vector2(960, y + 22), Vector2(9, 6), Color(0.08, 0.02, 0.06), O.GOLD)
	O.spiral(self, Vector2(x - 40, y - 20), 10.0, 1.3, 0.0, 1.0, O.GOLD, 1.2)
	O.spiral(self, Vector2(x + w + 40, y - 20), 10.0, 1.3, PI, -1.0, O.GOLD, 1.2)


func _draw_slots() -> void:
	var slots: Array = cfg.get("slots", [])
	var y := 330.0
	for s: Dictionary in slots:
		var c := Vector2(96, y)
		draw_circle(c, 40, Color(0.06, 0.02, 0.06, 0.78))
		O.ring(self, c, 40, O.GOLD, 1.8)
		O.ring(self, c, 45, Color(O.GOLD_DIM, 0.7), 1.0)
		O.star4(self, c + Vector2(0, -45), 7, O.WHITE)
		_icon(String(s.get("icon", "")), c)
		if s.has("count"):
			_text(self, c + Vector2(-30, 64), str(s["count"]), 26, Color(1, 0.97, 0.9), HORIZONTAL_ALIGNMENT_CENTER, 60.0, font_bold)
		y += 118.0


func _icon(kind: String, c: Vector2) -> void:
	var g := Color(0.95, 0.9, 0.8)
	match kind:
		"sword":
			draw_line(c + Vector2(-20, 20), c + Vector2(18, -18), g, 4.0, true)
			draw_line(c + Vector2(-22, 8), c + Vector2(-8, 22), Color(0.85, 0.65, 0.3), 3.5, true)
			draw_line(c + Vector2(-27, 27), c + Vector2(-19, 19), Color(0.5, 0.3, 0.2), 4.0, true)
		"crossbow":
			draw_arc(c + Vector2(0, 8), 24, PI * 1.1, PI * 1.9, 20, Color(0.6, 0.42, 0.25), 4.0, true)
			draw_line(c + Vector2(0, -12), c + Vector2(0, 26), Color(0.55, 0.36, 0.2), 4.0, true)
			draw_line(c + Vector2(-22, 0), c + Vector2(22, 0), Color(0.85, 0.85, 0.85, 0.8), 1.2, true)
			draw_line(c + Vector2(0, -20), c + Vector2(0, -6), g, 2.0, true)
		"poultice":
			draw_circle(c + Vector2(0, 6), 15, Color(0.3, 0.55, 0.3))
			draw_rect(Rect2(c + Vector2(-5, -18), Vector2(10, 12)), Color(0.75, 0.6, 0.4))
			draw_circle(c + Vector2(-5, 2), 4, Color(0.7, 0.95, 0.7))


func _draw_medallion_back(ci: Control) -> void:
	ci.draw_circle(MED_C, MED_R, Color(0.05, 0.02, 0.07, 0.9))
	ci.draw_circle(MED_C, MED_R - 10, Color(0.3, 0.22, 0.36))
	ci.draw_circle(MED_C + Vector2(0, -30), MED_R - 40, Color(0.45, 0.32, 0.45, 0.7))
	O.vine(ci, MED_C + Vector2(-MED_R + 10, -MED_R - 30), 120.0, -PI * 0.55, Color(O.GOLD_DIM, 0.55))


func _draw_medallion_front(ci: Control) -> void:
	O.ring(ci, MED_C, MED_R - 9, O.WHITE, 2.0)
	O.ring(ci, MED_C, MED_R, O.GOLD, 1.4)
	var ready: float = cfg.get("companion_ready", 1.0)
	ci.draw_arc(MED_C, MED_R + 6, -PI * 0.5, -PI * 0.5 + TAU * ready, 96, Color(1.0, 0.78, 0.4, 0.9), 3.0, true)
	for i: int in range(4):
		var a := PI * 0.25 + float(i) * PI * 0.5
		O.star4(ci, MED_C + Vector2(cos(a), sin(a)) * MED_R, 12.0 if i % 2 == 0 else 9.0, O.WHITE)
	O.star4(ci, MED_C + Vector2(0, -MED_R - 2), 15.0, O.WHITE)
	var nm := String(cfg.get("companion", ""))
	ci.draw_string_outline(font_bold, MED_C + Vector2(-90, MED_R + 28), nm, HORIZONTAL_ALIGNMENT_CENTER, 180, 22, 5, Color(0.02, 0, 0.03, 0.9))
	ci.draw_string(font_bold, MED_C + Vector2(-90, MED_R + 28), nm, HORIZONTAL_ALIGNMENT_CENTER, 180, 22, Color(1, 0.95, 0.85))
	var hint := String(cfg.get("companion_hint", ""))
	if hint != "":
		var hc := MED_C + Vector2(MED_R * 0.78, -MED_R * 0.92)
		ci.draw_circle(hc, 20, Color(0.06, 0.03, 0.1, 0.9))
		O.ring(ci, hc, 20, O.GOLD, 1.4)
		ci.draw_string(font_bold, hc + Vector2(-20, 7), hint, HORIZONTAL_ALIGNMENT_CENTER, 40, 18, Color(0.75, 0.9, 1.0))


func _draw_minimap() -> void:
	var map: Dictionary = cfg.get("map", {})
	draw_circle(MAP_C, MAP_R, Color(0.04, 0.02, 0.06, 0.82))
	var scale: float = map.get("scale", 7.0)
	var origin: Vector3 = map.get("origin", Vector3.ZERO)
	for r: Rect2 in map.get("rooms", []):
		var rr := Rect2(MAP_C + r.position * scale - Vector2(origin.x, origin.z) * scale, r.size * scale)
		if _inside(rr.position) or _inside(rr.end):
			draw_rect(_clip(rr), Color(0.5, 0.4, 0.55, 0.35))
			draw_rect(_clip(rr), Color(0.85, 0.75, 0.9, 0.6), false, 1.2)
	for e: Vector3 in map.get("enemies", []):
		var ep := MAP_C + Vector2(e.x - origin.x, e.z - origin.z) * scale
		if _inside(ep):
			draw_circle(ep, 4.0, Color(0.95, 0.2, 0.2))
	for d: Vector3 in map.get("doors", []):
		var dp := MAP_C + Vector2(d.x - origin.x, d.z - origin.z) * scale
		if _inside(dp):
			draw_rect(Rect2(dp - Vector2(5, 5), Vector2(10, 10)), Color(0.95, 0.9, 0.7), false, 1.5)
	var pts := PackedVector2Array([MAP_C + Vector2(0, -11), MAP_C + Vector2(8, 8), MAP_C + Vector2(0, 3), MAP_C + Vector2(-8, 8)])
	draw_colored_polygon(pts, Color(1.0, 0.45, 0.45))
	O.ring(self, MAP_C, MAP_R, O.GOLD, 1.8)
	O.ring(self, MAP_C, MAP_R + 7, Color(O.GOLD_DIM, 0.8), 1.0)
	for i: int in range(4):
		var a := float(i) * PI * 0.5 - PI * 0.5
		O.star4(self, MAP_C + Vector2(cos(a), sin(a)) * (MAP_R + 3), 16.0 if i == 0 else 11.0, O.WHITE)
	for i: int in range(4):
		var a2 := float(i) * PI * 0.5 - PI * 0.25
		O.diamond(self, MAP_C + Vector2(cos(a2), sin(a2)) * (MAP_R + 3), Vector2(3, 3), O.GOLD)
	_text(self, MAP_C + Vector2(-10, -MAP_R - 22), "N", 18, O.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 20.0, font_bold)


func _inside(p: Vector2) -> bool:
	return p.distance_to(MAP_C) < MAP_R - 4.0


func _clip(r: Rect2) -> Rect2:
	var box := Rect2(MAP_C - Vector2(MAP_R, MAP_R) * 0.72, Vector2(MAP_R, MAP_R) * 1.44)
	return r.intersection(box)


func _draw_enemy_bars() -> void:
	if cam == null:
		return
	for e: Dictionary in cfg.get("enemies", []):
		var wp: Vector3 = e["pos"]
		var sp := cam.unproject_position(wp)
		var frac: float = e.get("frac", 1.0)
		var w: float = e.get("width", 64.0)
		var r := Rect2(sp - Vector2(w * 0.5, 0), Vector2(w, 7))
		draw_rect(r.grow(2), Color(0.02, 0.0, 0.03, 0.85))
		draw_rect(Rect2(r.position, Vector2(w * frac, 7)), Color(0.96, 0.8, 0.3))
		draw_rect(Rect2(r.position, Vector2(w * frac, 2)), Color(1.0, 0.95, 0.7))
		draw_rect(r.grow(2), Color(O.GOLD, 0.7), false, 1.0)
