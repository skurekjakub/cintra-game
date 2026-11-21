extends Node
## HD-2D spike: renders one shot into a fixed 1920x1080 SubViewport, waits, saves a PNG, quits.
## Usage (windowed, 4.7.2): godot --path game res://spikes/hd2d/shot_runner.tscn -- --shot=drowned_rat --out=<abs png path> [--frames=90]
## Without --out it just shows the shot (for live inspection).
## Recording (A12): add --record=<seconds> [--rec_fps=50] and run Godot with --fixed-fps <rec_fps>:
## after the --frames warm-up, every frame is saved as <out dir>/frame_00000.png ... (fixed timestep,
## so the capture is deterministic). The shot's `lead_in` (if any) is set to the warm-up time.

const SHOTS := {
	"drowned_rat": "res://spikes/hd2d/shots/drowned_rat.gd",
	"karak_ostrel": "res://spikes/hd2d/shots/karak_ostrel.gd",
	"lineup": "res://spikes/hd2d/shots/lineup.gd",
}

var _sv: SubViewport
var _out := ""
var _wait := 90
var _frames := 0
var _msaa := 1
var _record := 0.0
var _rec_fps := 50
var _saved := 0


func _ready() -> void:
	var shot := "drowned_rat"
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--shot="):
			shot = a.trim_prefix("--shot=")
		elif a.begins_with("--out="):
			_out = a.trim_prefix("--out=")
		elif a.begins_with("--frames="):
			_wait = int(a.trim_prefix("--frames="))
		elif a.begins_with("--msaa="):
			_msaa = int(a.trim_prefix("--msaa="))
		elif a.begins_with("--record="):
			_record = float(a.trim_prefix("--record="))
		elif a.begins_with("--rec_fps="):
			_rec_fps = int(a.trim_prefix("--rec_fps="))
	_sv = SubViewport.new()
	_sv.size = Vector2i(1920, 1080)
	_sv.msaa_3d = _msaa as Viewport.MSAA
	_sv.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if _msaa == 0 else Viewport.SCREEN_SPACE_AA_DISABLED
	_sv.positional_shadow_atlas_size = 4096
	_sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(_sv)
	var view := TextureRect.new()
	view.texture = _sv.get_texture()
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	view.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(view)
	var script: GDScript = load(String(SHOTS[shot]))
	var root: Node = script.new()
	if _record > 0.0 and &"lead_in" in root:
		root.set(&"lead_in", float(_wait) / float(_rec_fps))
	_sv.add_child(root)


func _process(delta: float) -> void:
	_frames += 1
	if _record > 0.0:
		_record_frame(delta)
		return
	if _frames % 10 == 0:
		print("frame %d t=%d ms fps=%.1f" % [_frames, Time.get_ticks_msec(), Engine.get_frames_per_second()])
	if _out != "" and _frames == _wait:
		var img := _sv.get_texture().get_image()
		var err := img.save_png(_out)
		print("saved %s (%dx%d) err=%d" % [_out, img.get_width(), img.get_height(), err])
		var i := 0
		for vp: Node in _sv.find_children("*", "SubViewport", true, false):
			var sub := vp as SubViewport
			sub.get_texture().get_image().save_png(_out.get_basename() + "_vp%d.png" % i)
			i += 1
		get_tree().quit()


## One line per recorded frame for every node in group "record_track": the image just grabbed is the
## frame rendered after the previous process step, which is what these values still describe.
func _log_tracks() -> void:
	var line := str(_saved)
	for n: Node in get_tree().get_nodes_in_group(&"record_track"):
		var c: Vector2 = n.get(&"screen_corner")
		line += ",%d,%d,%d" % [int(c.x), int(c.y), int(n.get(&"shown_frame"))]
	var f := FileAccess.open(_out.path_join("track.csv"), FileAccess.READ_WRITE if _saved > 0 else FileAccess.WRITE)
	f.seek_end()
	f.store_line(line)
	f.close()


func _record_frame(delta: float) -> void:
	if _frames <= _wait:
		return
	if absf(delta - 1.0 / float(_rec_fps)) > 1e-4:
		push_warning("frame %d: delta %.5f is not 1/%d (run Godot with --fixed-fps %d)" % [_frames, delta, _rec_fps, _rec_fps])
	var img := _sv.get_texture().get_image()
	img.save_png(_out.path_join("frame_%05d.png" % _saved))
	_log_tracks()
	_saved += 1
	if _saved % 25 == 0:
		print("recorded %d frames, t=%d ms" % [_saved, Time.get_ticks_msec()])
	if _saved >= int(round(_record * float(_rec_fps))):
		print("recorded %d frames to %s" % [_saved, _out])
		get_tree().quit()
