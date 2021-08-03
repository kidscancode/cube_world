extends MarginContainer

signal level_selected

var current_grid = 1
var num_grids = 1

var grid_width = 714  # clip size

onready var grid_box = $VBoxContainer/HBoxContainer/ClipControl/GridBox
onready var tween = $Tween

func _ready():
	hide()

func init_grids():
	# TODO: calculate number of grids needed based on num_levels
	num_grids = grid_box.get_child_count()
	# number and unlock all levels
	for grid in grid_box.get_children():
		for button in grid.get_children():
			button.connect("level_selected", self, "_on_level_selected")
			var num = button.get_position_in_parent() + 1 + 18 * grid.get_position_in_parent()
			button.level_num = num
			button.locked = num > UI.num_levels

func start():
	visible = true
#	rect_position.x = 1024
#	get_tree().call_group("menu_buttons", "set_disabled", false)
#	tween.interpolate_property(self, "rect_position:x", 1024, 0, 0.5,
#			Tween.TRANS_BACK, Tween.EASE_OUT )
#	tween.start()
	
	
func end():
	visible = false
#	rect_position.x = 0
#	get_tree().call_group("menu_buttons", "set_disabled", true)
#	tween.interpolate_property(self, "rect_position:x", 0, 1024, 0.75,
#			Tween.TRANS_BACK, Tween.EASE_IN )
#	tween.start()

func _on_level_selected(level):
	emit_signal("level_selected", level)


func _on_BackButton_pressed():
	print("back")
	if current_grid > 1:
		current_grid -= 1
		tween.interpolate_property(grid_box, "rect_position:x",
				grid_box.rect_position.x,
				grid_box.rect_position.x + grid_width,
				0.54, Tween.TRANS_BACK, Tween.EASE_OUT)
		tween.start()

func _on_NextButton_pressed():
	print("next")
	if current_grid < num_grids:
		current_grid += 1
		tween.interpolate_property(grid_box, "rect_position:x",
				grid_box.rect_position.x,
				grid_box.rect_position.x - grid_width,
				0.54, Tween.TRANS_BACK, Tween.EASE_OUT)
		tween.start()
