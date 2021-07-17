extends CanvasLayer

onready var tween = $Message/Tween
onready var panel = $Message/Panel
onready var label = $Message/Panel/Label

var panel_style

func _ready():
	panel.hide()
	label.text = ""
	panel_style = panel.get("custom_styles/panel")
	
func show_message(text, time):
	panel.show()
	label.text = text
	tween.interpolate_property(panel_style, "bg_color:a", 0, .15, 0.2, Tween.TRANS_LINEAR)
	tween.interpolate_property(label, "rect_position:x",
		-1024, 0, .5, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(time), "timeout")
	tween.interpolate_property(panel_style, "bg_color:a", .15, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.4)
	tween.interpolate_property(label, "rect_position:x",
		0, 2048, .5, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	panel.hide()
	label.text = ""
