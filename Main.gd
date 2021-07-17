extends Node

var current_level = null

func _ready():
	current_level = $Level01
	$Level01/Goal.connect("level_completed", self, "change_level")

func change_level():
	if !current_level:
		return
	var nl = "res://levels/Level%02d.tscn" % (current_level.level_num + 1)
	var next_level = load(nl).instance()
	current_level.cleanup()
	var a = UI.overlay.wipe_in()
	yield(a, "animation_finished")
	add_child(next_level)
	next_level.get_node("Goal").connect("level_completed", self, "change_level")
	UI.overlay.wipe_out()
	
