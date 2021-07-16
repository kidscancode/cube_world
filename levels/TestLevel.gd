extends Spatial
class_name Level

export (AudioStream) var music

var fps = 0

func _ready():
	if music:
		AudioManager.play(music, -10)
	DebugOverlay.stats.add_property(self, "fps", "")
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/Message.show_message("Level 1", 2)
	
func _process(_delta):
	fps = Engine.get_frames_per_second()
