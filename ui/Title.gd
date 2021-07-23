extends MarginContainer

#signal menu_ready

onready var tween = $Tween

func _ready():
	hide()
	
func show():
	get_tree().call_group("menu_buttons", "set_disabled", false)
	tween.interpolate_property(self, "rect_position:x", 1024, 0, 0.5,
			Tween.TRANS_BOUNCE, Tween.EASE_OUT )
	tween.start()
#	emit_signal("menu_ready")
	
	
func hide():
	get_tree().call_group("menu_buttons", "set_disabled", true)
	tween.interpolate_property(self, "rect_position:x", 0, 1024, 0.5,
			Tween.TRANS_BOUNCE, Tween.EASE_OUT )
	tween.start()

