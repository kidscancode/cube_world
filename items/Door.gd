extends Spatial

export var speed = 2.0

onready var tween = $Tween
onready var door = $Door

func open():
#	if tween.is_active():
#		return
	tween.interpolate_property(door, "transform:origin", null,
			Vector3.UP * 2, 1/speed,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
func close():
#	if tween.is_active():
#		return
	tween.interpolate_property(door, "transform:origin", null,
			Vector3.ZERO, 1/speed,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
