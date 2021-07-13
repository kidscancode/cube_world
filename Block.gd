extends StaticBody

export var pushable = false

onready var tween = $Tween

func push(dir):
#	global_translate(dir * 2)
	tween.interpolate_property(self, "transform:origin", null,
			transform.origin + dir * 2, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
