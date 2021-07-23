extends Node

var level = 6
var num_levels = 1
var current_level = null

var first_level = preload("res://levels/Level01.tscn")

onready var tween = $Tween

func _ready():
	UI.game_scene = self
	randomize()
	get_levels()
	UI.go_to_title()
	
func start_game():
	change_level(true)

func end_game():
	print("game over")
	level = 1
	UI.overlay.wipe_in()
	yield(UI.overlay, "finished")
	if current_level:
		current_level.cleanup()
		current_level = null
	if $Music.playing:
		tween.interpolate_property($Music, "volume_db", null, -25, 0.5, Tween.TRANS_LINEAR)
		tween.start()
		yield(tween, "tween_all_completed")
		$Music.stop()
		$Music.stream = null
	UI.go_to_title()

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

func change_level(start=false):
	if current_level:
		level += 1
	if level > num_levels:
		end_game()
		return
	var next_level
	if not start:
		UI.overlay.wipe_in()
	next_level = load("res://levels/Level%02d.tscn" % level)
	if current_level:
		current_level.cleanup()
	current_level = next_level.instance()
	current_level.connect("ready", self, "level_ready")
	if not start:
		yield(UI.overlay, "finished")
	add_child(current_level)

func reset_level():
	level -= 1
	change_level()
	
func level_ready():
	current_level.get_node("Goal").connect("level_completed", self, "change_level")
	current_level.get_node("CubePlayer").connect("died", self, "reset_level")
	UI.overlay.wipe_out()
	yield(UI.overlay, "finished")
	current_level.initialize()
	play_music(current_level.music)

func play_music(song):
	if $Music.stream and $Music.stream == song:
		return
	if $Music.playing:
		tween.interpolate_property($Music, "volume_db", null, -25, 0.5, Tween.TRANS_LINEAR)
		tween.start()
		yield(tween, "tween_all_completed")
		$Music.stop()
	$Music.stream = song
	$Music.volume_db = 0
	$Music.play()
