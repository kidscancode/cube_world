extends Node

var level = 4
var num_levels = 1
var current_level = null

onready var tween = $Tween

func _ready():
	# TODO: Get total number of levels
	get_levels()
	change_level()
#	current_level = $Level01
#	level_ready()

func get_levels():
	var n = 0
	var d = Directory.new()
	if d.open("res://levels") == OK:
		print("scanning for levels...")
		d.list_dir_begin(true, true)
		var file_name = d.get_next()
		while file_name != "":
			if file_name.begins_with("Level") and filename.get_extension() == "tscn":
				n += 1
			file_name = d.get_next()
	print(n, " levels found")
	num_levels = n

func change_level():
	# 1. load new scene
	# 2. play out transition
	# 3. free old scene
	# 4. instance and add new scene and wait for ready signal
	# 5. play in transition
	# 6. tell new scene to begin
	
	if current_level:
		level += 1
	if level > num_levels:
		return
	UI.overlay.wipe_in()
	var next_level = load("res://levels/Level%02d.tscn" % level)
	if current_level:
		current_level.cleanup()
	current_level = next_level.instance()
	current_level.connect("ready", self, "level_ready")
	yield(UI.overlay, "finished")
	add_child(current_level)


func level_ready():
	current_level.get_node("Goal").connect("level_completed", self, "change_level")
	UI.overlay.wipe_out()
	yield(UI.overlay, "finished")
	current_level.initialize()
	play_music(current_level.music)

func play_music(song):
	if $Music.stream and $Music.stream == song:
		return
	if $Music.playing:
		tween.interpolate_property($Music, "volume_db", null, -25, 0.5, Tween.TRANS_LINEAR)
		yield(tween, "tween_all_completed")
		$Music.stop()
	$Music.stream = song
	$Music.play()