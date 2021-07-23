extends Spatial
class_name LevelBase

export var level_num = 0
export (AudioStream) var music


func _ready():
	$CubePlayer.set_physics_process(false)

func initialize():
	UI.message.show_message(name, 1.5)
	yield(UI.message, "finished")
	$CubePlayer.set_physics_process(true)

func cleanup():
	$CubePlayer.set_physics_process(false)
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
