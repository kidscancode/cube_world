extends Spatial
class_name Level

var fps = 0

func _ready():
	DebugOverlay.stats.add_property(self, "fps", "")
	
func _process(_delta):
	fps = Engine.get_frames_per_second()
