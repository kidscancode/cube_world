extends Spatial
class_name LevelBase

export var level_num = 0

onready var music = $Music

func _ready():
	yield(get_tree(), "idle_frame")
	music.play()
	UI.message.show_message("Level %d" % level_num, 2)
#	yield(get_tree().create_timer(1), "timeout")
#	$CanvasLayer/Message.show_message("Level 1", 2)
	
func cleanup():
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
