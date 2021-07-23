extends MarginContainer

signal menu_ready

onready var tween = $Tween

	
func start():
#	rect_position.x = 0
	get_tree().call_group("menu_buttons", "set_disabled", false)
	tween.interpolate_property(self, "rect_position:x", 1024, 0, 0.5,
			Tween.TRANS_BOUNCE, Tween.EASE_OUT )
	tween.start()
	
	
func end():
#	rect_position.x = 1024
	get_tree().call_group("menu_buttons", "set_disabled", true)
	tween.interpolate_property(self, "rect_position:x", 0, 1024, 0.5,
			Tween.TRANS_BOUNCE, Tween.EASE_OUT )
	tween.start()



func _on_Tween_tween_all_completed():
	emit_signal("menu_ready")
