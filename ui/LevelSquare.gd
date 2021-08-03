tool
extends PanelContainer

signal level_selected

export var locked = true setget set_locked
export var level_num = 1 setget set_level

func _ready():
	set("custom_styles/panel", get("custom_styles/panel").duplicate())

func set_level(value):
	level_num = value
	$Label.text = str(level_num)
	
func set_locked(value):
	locked = value
	if locked:
		$Label.hide()
		$MarginContainer.show()
	else:
		$Label.show()
		$MarginContainer.hide()


func _on_LevelSquare_gui_input(event):
	if locked:
		return
	if not locked:
		if event.is_action_pressed("mouse_left_click"):
			print("clicked level ", level_num)
			emit_signal("level_selected", level_num)


func _on_LevelSquare_mouse_entered():
	get("custom_styles/panel").border_color = Color(1, .95, .2)


func _on_LevelSquare_mouse_exited():
	get("custom_styles/panel").border_color = Color(.09, .38, .27)
