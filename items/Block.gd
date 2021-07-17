extends StaticBody

export var pushable = false
export (AudioStream) var slide_sound

onready var tween = $Tween


func push(dir):
	tween.interpolate_property(self, "transform:origin", null,
			transform.origin + dir * 2, 0.25,
			Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	if slide_sound:
		AudioManager.play(slide_sound, -5)

