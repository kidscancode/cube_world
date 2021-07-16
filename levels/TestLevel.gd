extends Spatial
class_name Level

var fps = 0

func _ready():
	DebugOverlay.stats.add_property(self, "fps", "")
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/Message.show_message("Level 1", 2)
	var f = get_node("foo")
	print(is_instance_valid(f))
	if f:
		print("not null")
	
func _process(_delta):
	fps = Engine.get_frames_per_second()
