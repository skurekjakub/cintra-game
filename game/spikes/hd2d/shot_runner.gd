extends Node
## HD-2D spike: renders one shot into a fixed 1920x1080 SubViewport, waits, saves a PNG, quits.
## Usage (windowed, 4.7.2): godot --path game res://spikes/hd2d/shot_runner.tscn -- --shot=drowned_rat --out=<abs png path> [--frames=90]
## Without --out it just shows the shot (for live inspection).

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
	_sv.add_child(root)


func _process(_delta: float) -> void:
	_frames += 1
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
