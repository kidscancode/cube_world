extends Spatial
class_name LevelBase

export var level_num = 0
export (AudioStream) var music

#onready var music = $Music

func _ready():
	$CubePlayer.set_physics_process(false)
#	UI.message.show_message("Level %d" % level_num, 2)
#	yield(get_tree().create_timer(1), "timeout")
#	$CanvasLayer/Message.show_message("Level 1", 2)

func initialize():
	UI.message.show_message(name, 1.5)
	yield(UI.message, "finished")
	$CubePlayer.set_physics_process(true)

func cleanup():
	$CubePlayer.set_physics_process(false)
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
