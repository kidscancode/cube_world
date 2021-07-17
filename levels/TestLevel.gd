extends Spatial


var fps = 0

onready var music = $Music

func _ready():
	music.play()
	DebugOverlay.stats.add_property(self, "fps", "")
	yield(get_tree().create_timer(1), "timeout")
	#$CanvasLayer/Message.show_message("Level 1", 2)
	
func _process(_delta):
	fps = Engine.get_frames_per_second()
